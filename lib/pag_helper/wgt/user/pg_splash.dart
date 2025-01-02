import 'package:buff_helper/pag_helper/def/def_page_route.dart';
import 'package:buff_helper/pag_helper/model/mdl_pag_user.dart';
import 'package:buff_helper/pag_helper/model/provider/pag_app_provider.dart';
import 'package:buff_helper/pag_helper/model/provider/pag_user_provider.dart';
import 'package:buff_helper/util/util.dart';
import 'package:buff_helper/xt_ui/wdgt/info/get_error_text_prompt.dart';
import 'package:buff_helper/xt_ui/wdgt/wgt_pag_wait.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:buff_helper/pag_helper/comm/comm_batch_op.dart';
import 'package:buff_helper/pag_helper/wgt/progress/wgt_progress_bar.dart';
import 'package:provider/provider.dart';

import '../../model/mdl_pag_app_config.dart';

class PgSplash extends StatefulWidget {
  const PgSplash({
    super.key,
    required this.appConfig,
    required this.appCtxBoardContext,
    this.loggedInUser,
    this.doPostLogin = true,
    this.showProgress = false,
    this.onSplashDone,
    this.doPostLoginFunction,
  });

  final MdlPagAppConfig appConfig;
  final bool showProgress;
  final bool doPostLogin;
  final MdlPagUser? loggedInUser;
  final BuildContext appCtxBoardContext;
  final Function? onSplashDone;
  final Function? doPostLoginFunction;

  @override
  State<PgSplash> createState() => _PgSplashState();
}

class _PgSplashState extends State<PgSplash> {
  MdlPagUser? loggedInUser;

  int _loadingDots = 0;
  double _progress = 0;

  // bool _isDoingPostLogin = false;
  bool _postLoginDone = false;
  bool _showProgress = false;
  String _userErrorText = '';

  Future<void> _doPostLogin() async {
    // if (_isDoingPostLogin) {
    if (_postLoginDone) {
      return;
    }
    if (loggedInUser?.isDoingPostLogin ?? false) {
      return;
    }

    setState(() {
      _userErrorText = '';
      // _isDoingPostLogin = true;

      loggedInUser?.isDoingPostLogin = true;
      _showProgress = true;
    });

    try {
      String randStr = rand(10000, 99999).toStringAsFixed(0);
      String taskName = 'get_user_role_scope_list_$randStr';

      _updateBatchOpProgress(taskName);

      // await doPostLogin(
      await widget.doPostLoginFunction
          ?.call(
        widget.appCtxBoardContext ?? context,
        loggedInUser!,
        taskName: taskName,
        prCur: Provider.of<PagAppProvider>(context, listen: false).prCur,
      )
          .then((_) {
        if (kDebugMode) {
          print('doPostLogin: done');
        }
        // if (mounted) {
        //   Provider.of<PagUserProvider>(context, listen: false)
        //       .setCurrentUser(loggedInUser!);
        //   // routeGuard(widget.appCtxBoardContext ?? context, loggedInUser,
        //   //     goHome: true);
        //   widget.appCtxBoardContext
        //       ?.go(getRoute(PagPageRoute.consoleHomeDashboard));
        // }
      });
    } catch (e) {
      if (kDebugMode) {
        print('_doPostLogin: $e');
      }
      _userErrorText = 'Service Error';
      if (e.toString().contains('user_role_list')) {
        _userErrorText = 'Scope Error. Please check role settings';
      } else if (e.toString().contains('project id not found for role id')) {
        _userErrorText = 'Project Role Settings Error';
      }
      rethrow;
    } finally {
      setState(() {
        _progress = 100;
        // _isDoingPostLogin = false;
        _postLoginDone = true;
        loggedInUser?.isDoingPostLogin = false;
      });

      if (kDebugMode) {
        print('_isDoingPostLogin = false');
      }

      if (loggedInUser == null || _userErrorText.isNotEmpty) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(getRoute(PagPageRoute.projectPublicFront));
          });
        }
      } else {
        widget.onSplashDone?.call(loggedInUser);
      }
    }
  }

  Future<dynamic> _updateBatchOpProgress(String taskName) async {
    while (mounted &&
        !(_postLoginDone) &&
        (loggedInUser?.isDoingPostLogin ?? false)) {
      await Future.delayed(const Duration(milliseconds: 500));

      // if (kDebugMode) {
      //   print('updateBatchOpProgress: $taskName');
      // }

      try {
        Map<String, dynamic> progressResult = await pagUpdateBatchOpProgress(
            widget.appConfig, loggedInUser, taskName);

        if (kDebugMode) {
          print('progressResult: $progressResult');
        }
        if (progressResult.isEmpty) {
          continue;
        }

        String progressMessage = progressResult['message'] ?? '';
        double progress = progressResult['progress'] ?? -1;

        if (progress < 0) {
          continue;
        }
        if (progress >= 100) {
          break;
        }

        if (kDebugMode) {
          print('progress: $progress, message: $progressMessage');
        }

        setState(() {
          _progress = progress;
          _loadingDots = (_loadingDots + 1) % 4;
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error in _getBatchOpProgress: $e');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    loggedInUser = widget.loggedInUser ??
        Provider.of<PagUserProvider>(context, listen: false).currentUser;

    _showProgress = widget.showProgress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 95),
          Container(
            height: 200,
            width: 350,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/energy_at_grid_logo.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: widget.doPostLogin &&
                      // (loggedInUser != null) &&
                      // !_isDoingPostLogin
                      !(loggedInUser?.isDoingPostLogin ?? false)
                  ? FutureBuilder<void>(
                      future: _doPostLogin(),
                      builder: (context, AsyncSnapshot<void> snapshot) {
                        if (kDebugMode) {
                          print(
                              'snapshot.connectionState: ${snapshot.connectionState}');
                        }

                        switch (snapshot.connectionState) {
                          default:
                            if (snapshot.hasError) {
                              if (kDebugMode) {
                                print(
                                    'splash snapshot.error: ${snapshot.error}');
                              }
                              if (_userErrorText.isEmpty) {
                                _userErrorText = 'Serivce Error';
                              }
                              return getErrorTextPrompt(
                                  context: context, errorText: _userErrorText);
                            } else {
                              if (kDebugMode) {
                                print('User: ${loggedInUser?.username}');
                              }
                              return completedWidget();
                            }
                        }
                      },
                    )
                  : completedWidget()),
        ],
      ),
    ));
  }

  Widget completedWidget() {
    if (_userErrorText.isNotEmpty) {
      return getErrorTextPrompt(
        context: context,
        errorText: _userErrorText,
      );
    }
    return _showProgress
        ? WgtProgressBar(
            width: 180,
            high: 21,
            progress: _progress,
            progressDots: _loadingDots,
            loadingMessage: '     loading project assets',
          )
        : const WgtPagWait(size: 55);
  }

  // Scaffold homeBoard(String boardTitle, Widget contentWidget) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Center(child: Text(boardTitle)),
  //     ),
  //     body: CustomPaint(
  //       painter: NeoDotPatternPainter(
  //         color: Colors.grey.shade600.withAlpha(80),
  //       ),
  //       child: Center(
  //         child: contentWidget,
  //       ),
  //     ),
  //   );
  // }
}
