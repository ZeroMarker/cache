var isShowVersion = 0 //1是演示版--演示版修改此处即可
var ISMOBILE = mui.os.plus; //打包版
var his85 = 1 //1是8.5版本,0是其它版本
var isLoginPage = 0 //1是登录界面
if (window.location.href.indexOf("login") > 0)
{
	isLoginPage = 1
}

var tapType = 'tap'
if ('ontouchstart' in window || (window.DocumentTouch && document instanceof DocumentTouch)) {
	tapType = 'touchstart'
}

var protocol = 'https:';
var ipUrl = '114.242.246.235:1443';

var webUrl = '/imedical/web'; // /dthealth/web
// var authUserName = 'dhsyslogin';
// var authPwd = '1q2w3e4r%T6y7u8i9o0p';
// authUserName = 'dhwebservice';
// authPwd = '3ua4B&9Q';
var hisURl = protocol + '//' + ipUrl + webUrl; //his完整地址
var jsonFilePath= hisURl+'/scripts/nurse/NurWB/json/';
var bedImageUrl = hisURl + '/images/'; //床位图图标使用his的图标
var webServiceURl = hisURl + '/Nur.DWB.WebService.DWBService.cls'
var webserviceConfigTail = '/csp/xml/iMedical.xml'
var webserviceConfigPath = hisURl+webserviceConfigTail
if (his85) {
	webUrl = '/imedical/webservice'; // imedical 8.5 webservice 
	hisURl = protocol + '//' + ipUrl + webUrl; //his完整地址
	jsonFilePath= protocol + '//' + ipUrl+'/imedical/web/scripts/nurse/NurWB/json/';
	bedImageUrl = protocol + '//' + ipUrl+'/imedical/web/images/';
	webServiceURl = hisURl + '/Nur.DWB.WebService.DWBService.cls'
	webserviceConfigPath =  protocol + '//' + ipUrl+'/imedical/web'+webserviceConfigTail
}

if(!ISMOBILE){
	protocol = window.location.protocol;
	var host = window.location.host;
	if (host!= '' && host.indexOf('127.0.0.1') == -1) {
		ipUrl = host
		hisURl = protocol + '//' + host + webUrl;
		imgWeb = '../../../..'
		jsonFilePath= protocol + '//' + ipUrl+webUrl+'/scripts/nurse/NurWB/json/';
		webserviceConfigPath = hisURl+webserviceConfigTail
		if (his85) {
			jsonFilePath= protocol + '//' + ipUrl+'/imedical/web/scripts/nurse/NurWB/json/';
			webserviceConfigPath =  protocol + '//' + ipUrl+'/imedical/web'+webserviceConfigTail
		}
		bedImageUrl = '../../../../images/';
		webServiceURl = hisURl + '/Nur.DWB.WebService.DWBService.cls'
	}
}

 //正常打包非登录界面
if (!isLoginPage && !isShowVersion && ISMOBILE && localStorage['ipConfigDict'] != undefined){
	var configDict = JSON.parse(localStorage['ipConfigDict']);
	protocol = configDict['protocol']
	his85 = configDict['his85']+''
	webUrl = configDict['webUrl']
	ipUrl = configDict['ipUrl']
	hisURl = protocol + '//' + ipUrl + webUrl; //his完整地址
	if (his85 == '1') {
		jsonFilePath = protocol + '//' + ipUrl+'/imedical/web/scripts/nurse/NurWB/json/';
		bedImageUrl = protocol + '//' + ipUrl + '/imedical/web/images/';
		webserviceConfigPath =  protocol + '//' + ipUrl+'/imedical/web'+webserviceConfigTail
	}else{
		jsonFilePath = hisURl+ '/scripts/nurse/NurWB/json/';
		bedImageUrl = hisURl + '/images/';
		webserviceConfigPath =  hisURl+webserviceConfigTail
	}
	webServiceURl = hisURl+ '/Nur.DWB.WebService.DWBService.cls';
}
/**
 * 演示版修代码--演示库
 */
if (isShowVersion) {  
	protocol = 'https:';
	ipUrl = '140.143.188.73:1443';
	webUrl = '/imedical/webservice';
	hisURl = protocol + '//' + ipUrl + webUrl; //his完整地址
	webServiceURl = hisURl+ '/Nur.DWB.WebService.DWBService.cls';
	jsonFilePath = protocol + '//' + ipUrl+'/imedical/web/scripts/nurse/NurWB/json/';
	if(ISMOBILE){
		bedImageUrl = protocol + '//' + ipUrl + '/imedical/web/images/';
	}else{
		bedImageUrl = '../../../../images/';
	}
	webserviceConfigPath = protocol + '//' + ipUrl+'/imedical/web'+webserviceConfigTail
}

//适配
var SCALE = computeScale();
function computeScale(){
	var windowW = window.screen.width;
	var param = 16
	if (windowW < 960) {
		param = 8
	}else if (windowW >= 960 && windowW < 1280) {
		param = 10
	}else if (windowW >= 1280 && windowW < 1920) {
		param = 15 //华为屏也是1280,所以都适配了
	}else if (windowW >= 1920 && windowW < 3840) {
		param = 18
	}else if (windowW >= 3840) {
		param = 32
	}
	return param/16
}