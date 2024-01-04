import 'Constants/urlConstant.dart';

enum environment { mock, realService }

abstract class setEnvironment {
  static late environment env;
  static late String apiBaseUrlPHQ,
      apiBaseUrlDiab,
      apiBaseUrlAlzh,
      apiBaseUrlPAR,
      apiBaseUrlGAD,
      apiBaseUrlSleepQ,
      loginBaseUrl,
      apiBaseUrlAUDIT,
      calendarUrl,
      apiPayload,
      addTokenUrl;
  static setUpEnv(environment _environment) {
    env = _environment;
    switch (_environment) {
      case environment.mock:
        {
          apiBaseUrlAUDIT = Mock_Url_nodejs_audit;
          apiBaseUrlPHQ = Mock_Url_nodejs_phq8;
          apiBaseUrlGAD = Mock_Url_nodejs_gad7;
          apiBaseUrlSleepQ = Mock_Url_nodejs_sleepq;
          apiBaseUrlDiab = Mock_Url_nodejs_diab;
          apiBaseUrlAlzh = Mock_Url_nodejs_alzh;
          calendarUrl = calendar_mock_nodejs;
          loginBaseUrl = login_mock_nodejs;
          apiBaseUrlPAR = Mock_Url_nodejs_par_d;
          addTokenUrl = add_token_mock;
          break;
        }
      case environment.realService:
        {
          apiBaseUrlPHQ = phq_Post_BaseUrl;
          apiBaseUrlSleepQ = sleepq_Post_BaseUrl;
          calendarUrl = calendar_BaseUrl;
          loginBaseUrl = login_BaseUrl;
          break;
        }
    }
  }
}
