/// Exception thrown when doing user cancelled the login flow.
class CanceledByUserException implements Exception {
  const CanceledByUserException();
  String toString() => "CanceledByUserException";
}

/// Exception to be thrown when all the scopes specified by the user are invalid
class NoValidScopeSpecified implements Exception{

  const NoValidScopeSpecified();
  String toString() => "No valid scope specified by the user";

}
