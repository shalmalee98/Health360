// IBM URLs'
import '../loginpage.dart';

const String phq_Post_BaseUrl =
    "https://hg-api-gateway-phq8-ce-demo.ortmd733nb9.us-east.codeengine.appdomain.cloud/api/v1";
const String phq_Get_BaseUrl =
    "https://hg-api-gateway-phq8-ce-demo.ortmd733nb9.us-east.codeengine.appdomain.cloud/api/v1";
const String sleepq_Post_BaseUrl =
    "https://hg-api-gateway-sleep-questionnaire-ce-demo.ortmd733nb9.us-east.codeengine.appdomain.cloud/api/v1";
const String sleepq_Get_BaseUrl =
    "https://hg-api-gateway-sleep-questionnaire-ce-demo.ortmd733nb9.us-east.codeengine.appdomain.cloud/api/v1";
const String login_BaseUrl =
    "https://hg-production-taskmanager-ssc.ortmd733nb9.us-east.codeengine.appdomain.cloud/api/v1/token/";
const String calendar_BaseUrl =
    "https://hg-production-taskmanager-ssc.ortmd733nb9.us-east.codeengine.appdomain.cloud/api/v1/my-datasets";
//Mock URLs'
const String Mock_Url_nodejs_phq8 =
    "https://midyear-castle-408217.uc.r.appspot.com/phq_8";
const String Mock_Url_nodejs_audit =
    "https://midyear-castle-408217.uc.r.appspot.com/audit";
const String Mock_Url_nodejs_sleepq =
    "https://midyear-castle-408217.uc.r.appspot.com/sleep_q";
const String Mock_Url_nodejs_gad7 =
    "https://midyear-castle-408217.uc.r.appspot.com/gad_7";
const String Mock_Url_nodejs_par_d =
    "https://midyear-castle-408217.uc.r.appspot.com/par_d";
const String Mock_Url_nodejs_diab =
    "https://midyear-castle-408217.uc.r.appspot.com/diab";
const String Mock_Url_nodejs_alzh =
    "https://midyear-castle-408217.uc.r.appspot.com/alzh_d";
const String calendar_mock_nodejs =
    "https://midyear-castle-408217.uc.r.appspot.com/data";
const String login_mock_nodejs =
    "https://midyear-castle-408217.uc.r.appspot.com/users/login";
const String add_token_mock =
    "https://midyear-castle-408217.uc.r.appspot.com/users/addToken";
//Headers
const String phq_unencoded_post = "score_calculate_phq8";
const String sleepq_unencoded_post = "get_scale";
const String gad_unencoded_post = "score_calculate_gad7";
const String audit_unencoded_post = "score_calculate_audit";
const String par_unencoded_post = "score_calculate_pard";
const String diab_unencoded_post = "score_calculate_diab";
const String alzh_unencoded_post = "score_calculate_alz";
//Bearer token
String bearerToken = "";
