import 'package:buff_helper/pagrid_helper/pagrid_helper.dart';
import 'package:buff_helper/up_helper/up_helper.dart';
import 'package:flutter/foundation.dart';

enum PagSvcType { usersvc2, oresvc }

class PagUrlController {
  late ProjectScope _activePortalProjectScope;
  ProjectScope get activePortalProjectScope => _activePortalProjectScope;

  late String _usersvcURL;
  String get usersvcURL => _usersvcURL;

  late String _oresvcURL;
  String get oresvcURL => _oresvcURL;

  late String _destPortalURL;
  String get destPortalURL => _destPortalURL;

  PagUrlController(PaGridAppConfig appConfig) {
    _usersvcURL = getProjectHostUser(appConfig);
    _oresvcURL = getProjectHostOre(appConfig);
    _destPortalURL = getProjectHostDestPortal(appConfig);
  }

  String getUrl(PagSvcType svcType, String endpoint) {
    switch (svcType) {
      case PagSvcType.usersvc2:
        return '$_usersvcURL$endpoint';
      case PagSvcType.oresvc:
        return '$_oresvcURL$endpoint';
    }
  }

  String getProjectHostUser(PaGridAppConfig paGridAppConfig) {
    ProjectScope activeProjectScope = paGridAppConfig.activePortalProjectScope;
    bool useDevUsersvc = paGridAppConfig.useDevUsersvc;
    switch (activeProjectScope) {
      case ProjectScope.EVS2_NTU:
        return kDebugMode
            ? PagUrlBase.dUsersvcUrl
            : useDevUsersvc
                ? PagUrlBase.rDevUsersvcUrl
                : PagUrlBase.rProdUsersvcUrl;
      case ProjectScope.EMS_SMRT:
        return kDebugMode
            ? PagUrlBase.dUsersvcUrl
            : useDevUsersvc
                ? PagUrlBase.rDevUsersvcUrl
                : PagUrlBase.rProdUsersvcUrl;
      case ProjectScope.EMS_CW_NUS:
        return kDebugMode
            ? PagUrlBase.dUsersvcUrl
            : useDevUsersvc
                ? PagUrlBase.rDevUsersvcUrl
                : PagUrlBase.rProdUsersvcUrl;
      default:
        return kDebugMode
            ? PagUrlBase.dUsersvcUrl
            : useDevUsersvc
                ? PagUrlBase.rDevUsersvcUrl
                : PagUrlBase.rProdUsersvcUrl;
    }
  }

  String getProjectHostOre(PaGridAppConfig paGridAppConfig) {
    ProjectScope activeProjectScope = paGridAppConfig.activePortalProjectScope;
    bool useDevOresvc = paGridAppConfig.useDevOresvc;
    switch (activeProjectScope) {
      case ProjectScope.EVS2_NTU:
        return kDebugMode
            ? PagUrlBase.dOresvcUrl
            : useDevOresvc
                ? PagUrlBase.rDevOresvcUrlNTU
                : PagUrlBase.rProdOresvcUrlNTU;
      case ProjectScope.EMS_SMRT:
        return kDebugMode
            ? PagUrlBase.dOresvcUrl
            : useDevOresvc
                ? PagUrlBase.rDevOresvcUrlSMRT
                : PagUrlBase.rProdOresvcUrlSMRT;
      case ProjectScope.EMS_CW_NUS:
        return kDebugMode
            ? PagUrlBase.dOresvcUrl
            : useDevOresvc
                ? PagUrlBase.rDevOresvcUrlCwNus
                : PagUrlBase.rProdOresvcUrlCwNus;
      default:
        return kDebugMode
            ? PagUrlBase.dOresvcUrl
            : useDevOresvc
                ? PagUrlBase.rOresvcUrl
                : PagUrlBase.rOresvcUrl;
    }
  }

  String getProjectHostDestPortal(PaGridAppConfig paGridAppConfig) {
    ProjectScope activeProjectScope = paGridAppConfig.activePortalProjectScope;
    switch (activeProjectScope) {
      case ProjectScope.EVS2_NTU:
        return kDebugMode
            ? PagUrlBase.dDestPortalEvs2cp
            : PagUrlBase.rDestPortalEvs2cp;
      case ProjectScope.EMS_SMRT:
        return kDebugMode
            ? PagUrlBase.dDestPortalEvs2cp
            : PagUrlBase.rDestPortalEvs2cp;
      case ProjectScope.EMS_CW_NUS:
        return kDebugMode
            ? PagUrlBase.dDestPortalEvs2cp
            : PagUrlBase.rDestPortalEvs2cp;
      default:
        return kDebugMode
            ? PagUrlBase.dDestPortalEvs2cp
            : PagUrlBase.rDestPortalEvs2cp;
    }
  }
}

class PagUrlBase {
  //host
  static const String _dDestPortalEvs2cp = 'https://cp2test.evs.com.sg';
  static const String _rDestPortalEvs2cp = 'https://cp2.evs.com.sg';

  static const String _dOresvcUrl = 'http://localhost:8018';
  static const String _rOresvc = 'https://oresvc2.evs.com.sg';
  static const String _rDevOresvcNTU = _rOresvc;
  static const String _rProdOresvcUrlNTU = 'https://ore-ntu.evs.com.sg';
  static const String _rDevOresvcUrlSMRT = _rOresvc;
  static const String _rProdOresvcUrlSMRT = 'https://ore-smrt.web-ems.com';
  static const String _rProdOresvcUrlCwNus =
      'https://oresvc-cw-nus.web-ems.com';
  static const String _rDevOresvcUrlCwNus = _rOresvc;

  static const String _dUsersvcUrl =
      // 'http://13.228.16.206:8081';
      'http://3.1.141.233:8081';
  static const String _rDevUsersvcUrl = 'https://pag-u.evs.com.sg';
  static const String _rProdUsersvcUrl = 'https://pag-u.evs.com.sg';

  static get dDestPortalEvs2cp => _dDestPortalEvs2cp;
  static get rDestPortalEvs2cp => _rDestPortalEvs2cp;

  static get dUsersvcUrl => _dUsersvcUrl;
  static get rDevUsersvcUrl => _rDevUsersvcUrl;
  static get rProdUsersvcUrl => _rProdUsersvcUrl;

  static get dOresvcUrl => _dOresvcUrl;
  static get rOresvcUrl => _rOresvc;
  static get rProdOresvcUrlNTU => _rProdOresvcUrlNTU;
  static get rDevOresvcUrlNTU => _rDevOresvcNTU;
  static get rProdOresvcUrlSMRT => _rProdOresvcUrlSMRT;
  static get rDevOresvcUrlSMRT => _rDevOresvcUrlSMRT;
  static get rProdOresvcUrlCwNus => _rProdOresvcUrlCwNus;
  static get rDevOresvcUrlCwNus => _rDevOresvcUrlCwNus;

  //user service endpoints
  static const String eptUsersvcGetAppToken = '/auth/get_evs2up_app_token';
  static const String eptUsersvcGetAclSetting = '/auth/get_acl_setting';
  static const String eptUsersvcGetPgk = '/auth/get_pgk';
  static const String eptUsersvcRegister = '/register';
  static const String eptUsersvcUpdateProfile = '/update_profile';
  static const String eptUsersvcUpdateKeyVal = '/update_key_val';
  static const String eptUsersvcCheckUnique = '/check_unique';
  static const String eptUsersvcLogin = '/login';
  static const String eptUsersvcListUsers = '/ops/list_users';
  static const String eptUsersvcUpdateUsers = '/ops/update_users';
  static const String eptUsersvcUpdateUserPassword = '/ops/update_user_pwd';
  static const String eptUsersvcGetRoleList = '/ops/get_role_list';
  static const String eptUsersvcGetScopeList = '/ops/get_scope_list';
  static const String eptUsersvcGetRoleProfile = '/ops/get_role_profile';
  static const String eptUsersvcUpdateRoles = '/ops/update_roles';
  static const String eptUsersvcBatchReg = '/ops/batch_register';
  static const String eptUsersvcGetPermissionList = '/ops/get_permission_list';
  static const String eptUsersvcUpdateRolePerm = '/ops/update_role_permission';
  static const String eptUsersvcUpdateUserRole = '/ops/update_user_role';
  static const String eptUsersvcCheckExists = '/check_exists';
  static const String eptUsersvcForgotPassword = '/forgot_password';
  static const String eptUsersvcResetPassword = '/reset_password';
  static const String pathApplySvcToken = 'auth/apply_svc_token';
  static const String eptUsersvcApplySvcToken = '/$pathApplySvcToken';
  static const String eptUsersvcPollingUserBatchOpProgress =
      '/ops/progress_update';
  static const String eptUsersvcGetUserKeyVal = '/ops/get_user_key_val';

  static const String eptUsersvcSsoVerifyEmailAddress = '/sso/verify_email';

  //ore service endpoints
  //keysvc
  static const String eptGetOaxLink = '/key/get_oax_link';

  //m3
  static const String eptGetMmsSatus = '/m3/get_mms_status';
  static const String eptGetMeterRLS = '/m3/get_meter_rls';
  static const String eptGetMeterComm = '/m3/get_meter_comm';
  static const String eptTurnMeterOnOff = '/m3/turn_meter_on_off';
  static const String eptTurnAcLockOnOff = '/m3/turn_ac_lock_on_off';
  static const String eptGetMeterData = '/m3/get_meter_data';

  static const String eptCheckMeterDisplayname = '/check_meter_displayname';

  //ops_dashboard
  static const String eptGetActiveMeterCount =
      '/ops_dashboard/get_active_meter_count';
  static const String eptGetActiveKwhConsumption =
      '/ops_dashboard/get_active_kwh_consumption';
  static const String eptGetRecentTotalTopup =
      '/ops_dashboard/get_recent_total_topup';
  static const String eptGetTotalTopupHistory =
      '/ops_dashboard/get_total_topup_history';
  static const String eptGetActiveMeterCountHistory =
      '/ops_dashboard/get_active_meter_count_history';
  static const String eptGetAcitveUsageHistory =
      '/ops_dashboard/get_active_kwh_consumption_history';
  static const String eptGetRlsHistory = '/get_rls_history';
  static const String eptGetMonthToDateUsage =
      '/ops_dashboard/get_month_to_date_usage';
  static const String eptGetTopKwhUsageByBuilding =
      '/ops_dashboard/get_top_kwh_usage_by_building';

  static const String eptGetAllUsageHistory =
      '/ops_dashboard/get_all_usage_history';

  //ems_dashboard
  static const String eptEmsDashboardGetMeter3pStat =
      '/ems_dashboard/get_meter_3p_stat';
  static const String eptEmsDashboardGetSensorStat =
      '/ems_dashboard/get_sensor_stat';

  //tcm
  static const String eptGetCreditBalance = '/tcm/get_credit_balance';
  static const String eptAdjCredit = '/tcm/adj_credit';
  static const String eptGetCreditBalanceList = '/tcm/get_credit_balance_list';

  //batch_op
  static const String eptCheckOpList = '/batch_op/check_op_list';
  static const String eptPollingBatchOpProgress = '/batch_op/progress_update';
  static const String eptPollingAutogenProgress = '/batch_op/progress_update';
  static const String eptPollingBatchCreditOpProgress =
      '/batch_op/progress_update';

  //credit_op
  static const String eptCreditOpDoOp = '/credit_op/do_op_batch_credit';
  //commision
  static const String eptCheckCommissionList =
      '/commission/check_commission_list';
  static const String eptDoCommission = '/commission/do_commission';
  static const String eptAutogen = '/commission/autogen';
  //bypass
  static const String eptGetMeterBypassPolicyList =
      '/bypass/get_meter_bypass_policy_list';
  static const String eptDoOpBypass = '/bypass/do_op';
  //cpc
  static const String eptGetMeterCpcPolicyList =
      '/cpc/get_meter_cpc_policy_list';
  static const String eptDoOpCpc = '/cpc/do_op';
  //detach/attach sn
  static const String eptDoDetach = '/attach_detach/do_detach_sn';
  static const String eptDoAttach = '/attach_detach/do_attach_sn';

  //key_val_update
  static const String eptGetMeterKeyValList =
      '/key_val_update/get_meter_key_val_list';
  static const String eptDoOpUpdateSingleKeyVal =
      '/key_val_update/do_op_single';
  static const String eptDoOpUpdateMultiKeyVal = '/key_val_update/do_op_multi';
  //comm_data
  static const String eptCommDataGetRecentComsumption =
      '/comm_data/get_active_consumption';
  static const String eptCommDataGetMonthToDateUsageTotal =
      '/comm_data/get_month_to_date_consumption_total';
  static const String eptGetMeterInfo = '/get_meter_info';
  static const String eptGetHistory = '/get_history';
  static const String eptGetTargetHistory = '/get_target_history';

  static const String eptGetMeterKiv = '/get_meter_kiv';
  static const String eptGetRecentReadingInterval =
      '/get_recent_reading_interval';

  //fleet_stat
  static const String eptGetSiteStatHealth = '/fleet_stat/get_site_stat_health';
  static const String eptGetBuildingBlockReport =
      '/fleet_stat/get_building_block_report';
  static const String getFleetHealthHistorySnapshot =
      '/fleet_stat/get_health_history_snapshot';

  //meter_usage
  static const String eptGetMeterListUsageSummary =
      '/meter_usage/get_meter_list_usage_summary';
  static const String eptGetMeterListConsolidatedUsageHistory =
      '/meter_usage/get_meter_list_consolidated_usage_history';

  //set conc
  static const String eptGetAllConcIds = '/concentrator/get_all_conc_ids';

  //insert reading
  static const String eptDoOpInsertReadingData = '/reading/insert';

  //meter_list_search
  static const String eptListMeters = '/meter_list_search/list_meters';
  static const String eptGetBuildingList =
      '/meter_list_search/get_building_list';
  static const String eptGetConcList =
      '/meter_list_search/get_concentrator_list';
  static const String eptGetBlockList = '/meter_list_search/get_block_list';
  static const String eptGetLevelList = '/meter_list_search/get_level_list';
  static const String eptGetUnitList = '/meter_list_search/get_unit_list';

  static const String eptListItems = '/item_list_search/list_items';
  static const String eptGetItemInfo = '/get_item_info';
  static const String eptPullItemLastReading = '/item_pull_last_reading';

  static const String eptUpdateMeterKeyVal = '/update_key_val';
  static const String eptOreCheckExists = '/check_exists';
  static const String eptOreCheckExists2 = '/check_exists2';
  static const String eptGetVerion = '/get_version';
  static const String eptOreHello = '/hello';
  static const String eptGetSysVar = '/get_sys_var';

  //Tenant manager
  static const String eptCreateTenant = '/tenant/create_tenant';
  static const String eptUpdateTenantMeterGroups = '/tenant/update_items';
  static const String eptGetTenantMeterGroups = '/tenant/get_meter_groups';
  static const String eptGetMeterTenants = '/tenant/get_meter_tenants';
  static const String eptGetTenantMap = '/tenant/get_tenant_map';
  static const String eptGetUserTenant = '/tenant/get_user_tenant';
  static const String eptSetUserTenant = '/tenant/set_user_tenant';
  static const String eptCheckMainTenant = '/tenant/check_main_tenant';
  static const String eptGetUserTenantList = '/tenant/get_user_tenant_list';
  static const String eptUpdateUserTenantList =
      '/tenant/update_user_tenant_list';

  //tenant_usage
  static const String eptGetTenantListUsageSummary =
      '/tenant_usage/get_tenant_list_usage_summary';
  static const String eptGetTenantListConsolidatedUsageHistory =
      '/tenant_usage/get_tenant_list_consolidated_usage_history';

  // Tenant Dashboard
  static const String eptTenantGetActiveUsage =
      '/tenant_dashboard/get_active_usage';

  //meter group
  static const String eptCreateMeterGroup = '/meter_group/create_meter_group';
  static const String eptGetGroupMeters = '/meter_group/get_group_meters';
  // static const String eptGetMeterPercentage =
  //     '/meter_group/get_meter_percentage';
  static const String eptUpdateGroupItems = '/meter_group/update_items';
  static const String eptGetMeterGroupListUsageSummary =
      '/meter_group/get_meter_group_list_usage_summary';

  //tariff package
  static const String eptCreateTariffPackage =
      '/tariff_package/create_tariff_package';
  static const String eptGetRateRowList =
      '/tariff_package/get_package_rate_row_list';
  static const String eptUpdatePackageRateRowList =
      '/tariff_package/update_package_rate_row_list';
  static const String eptUpdateTariffPackageTenants =
      '/tariff_package/update_tariff_package_tenants';
  static const String eptGetTariffPackageTenants =
      '/tariff_package/get_tariff_package_tenants';

  //alarm
  static const String eptGetAlarmStreamItem = '/alarm/get_alarm_stream_item';
  static const String eptGetAlarmList = '/alarm/get_alarm_list';
  static const String eptAckAlarm = '/alarm/ack';
  static const String eptCheckAlarmAck = '/alarm/check_ack';

  //Iwow
  static const String eptGetItemSnIwow = '/iwow/get_item_sn';

  //Job
  static const String eptPostJob = '/job/post_job';
  static const String eptGetJobTypeSubs = '/job/get_job_type_subs';
  static const String eptAddJobTypeSub = '/job/add_job_type_sub';
  static const String eptDeleteJobTypeSub = '/job/delete_job_type_sub';

  //Billing Manager
  static const String eptGetBill = '/billing/get_bill';
  static const String eptGenerateBillingRec = '/billing/generate_billing_rec';
  static const String eptCheckTpInfo = '/billing/check_tp_rate_info';
  static const String eptGetReleaseCandidate = '/billing/get_rc';
  static const String eptReleaseBills = '/billing/release_bills';
  static const String eptGetUsageFactor = '/billing/get_usage_factor';
  static const String eptBlastBillingNotification =
      '/billing/blast_billing_notification';
}
