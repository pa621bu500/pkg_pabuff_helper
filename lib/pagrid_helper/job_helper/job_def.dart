enum JobTaskType {
  itemHistory,
}

String? getJobTaskTypeName(JobTaskType jobType) {
  switch (jobType) {
    case JobTaskType.itemHistory:
      return 'item-history';
  }
  return null;
}

const int minJobTypeLabelLength = 0;
const int maxJobTypeLabelLength = 30;

String? jobTypeLabelValidator(String? val) {
  // if (required) {
  //   if (val == null) {
  //     return 'required';
  //   }
  //   if (val.trim().isEmpty) {
  //     return 'required';
  //   }
  // }
  val = val ?? '';
  if (val.trim().isEmpty) {
    return null;
  }

  if (val.trim().length < minJobTypeLabelLength) {
    return 'must be at least $minJobTypeLabelLength characters';
  }
  if (val.trim().length > maxJobTypeLabelLength) {
    return 'must be less than $maxJobTypeLabelLength characters';
  }
  if (!RegExp(r"^[a-zA-Z0-9()/'@.,& -]+$").hasMatch(val)) {
    return "alphanumeric, (), ', @, ., -, /, &, space, and comma only";
  }

  return null;
}
