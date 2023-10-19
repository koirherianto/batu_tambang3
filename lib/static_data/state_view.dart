class StateView {
  const StateView();
}

class InitialStateView extends StateView {
  const InitialStateView();
}

class LoadingStateView extends StateView {
  const LoadingStateView();
}

class SuccessStateView extends StateView {
  final Map<String, dynamic> data;
  const SuccessStateView({this.data = const {}});
}

class FailedStateView extends StateView {
  final Map<String, dynamic> errorMassage;
  const FailedStateView({this.errorMassage = const {}});
}

class UnauthenticatedStateView extends StateView {
  const UnauthenticatedStateView();
}
