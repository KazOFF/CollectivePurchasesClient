abstract class CPServerException implements Exception{
  String message;

  CPServerException(this.message);
}

class EmptyTokenException extends CPServerException{
  EmptyTokenException() : super('Пустой токен');
}

class AuthenticationException extends CPServerException{
  AuthenticationException() : super('Проблема аутентификации');
}

class NotAuthenticatedException extends CPServerException{
  NotAuthenticatedException() : super('Аутентификация не пройдена');
}

class ConnectionException extends CPServerException{
  ConnectionException() : super('Проблема с соединением');
}

class UnknownException extends CPServerException{
  UnknownException() : super('Unknown');
}

class ServerException extends CPServerException{
  ServerException(super.message);
}