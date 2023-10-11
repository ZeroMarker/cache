/*
 * @Author: 基础数据平台-范文凯
 * @Date:   2020-07-09
 * @Last Modified by:   范文凯
 * @Last Modified time: 2020-07-09
 * @描述:临床数据拼成JSON串后传给后台去做校验
 */
var DataInfo = "";
var PerPatientInfo="";
//同步捕捉预警的预返回值 用于后台报错或运行时间超过设定值
var synReturn = {
    "BlockWarn": [],
    "PopWarn": []
}
//异步预返回值
var asynReturn = [{
    "ResultCode": "0",
    "ResultContent": "成功"
}]
/**
 * @Author 范文凯
 * @desc 封装跨域调用CDSS后台M方法类
 * @Last Modified by:   范文凯
 * @Last Modified time: 
 */
function CDSSMakeServerCall(DataInfo) {
    var returnInfo = "";
    var str = DataInfo.replace(/\"/g, '""')
    returnInfo = tkMakeServerCall("web.CDSS.Public.MethodForWebservice", "CallMethod", str)
    return returnInfo;
}
var PatientConfig = CDSSMakeServerCall("web.CDSS.Config.MKBConfig[A]GetConfigValue[A]CDSSdyn20200416")
//解析数据并进入CDSS知识库
function TriggerDHCDSS(action, json) {
    //当action为初始化患者信息时,直接前台拼串,不进行前后台交互
    if (action == "INITIALIZE_PATIENT_INFORMATION") {
        if (json.VisitType == 1) {
            var VisitType = "急诊"
        } else if (json.VisitType == 2) {
            var VisitType = "门诊"
        } else if (json.VisitType == 3) {
            var VisitType = "住院"
        }
        var PatientUserInfo = json.IDNO + "^" + json.PatientDR + "^" + json.VisitID + "^" + VisitType + "^" + json.UserID + "^" + json.UserName + "^" + json.DeptCode + "^" + json.DeptName + "^" + PatientConfig
        if(PatientUserInfo!=PerPatientInfo)
        {
            json = JSON.stringify(json)
            DataInfo = "web.CDSS.MachineLearning.InteractiveInterface[A]DHCHisInterface[A]" + action + "[A]" + json;
            $m({
                ClassName: "web.CDSS.Public.MethodForWebservice",
                MethodName: "CallMethod",
                InputStr: DataInfo,
            }, function (PatientUserInfo) {
                TriggerPatientInfo(PatientUserInfo);
                //return Result
            });
            //TriggerPatientInfo(PatientUserInfo)
            PerPatientInfo=PatientUserInfo
        }
        return asynReturn
    }
    var DataInfo = "";
    if (json == undefined) {
        return
    }
    if (typeof (json) == 'object') {
        json = JSON.stringify(json)

    }
    //根据action来判断同步还是异步调用CDSS后台方法  CATCH_DIAG_WARNING or CATCH_ORDER_WARNING 同步调用 其他异步
    if ((action == 'CATCH_DIAG_WARNING') || (action == 'CATCH_ORDER_WARNING')) {
        //同步调用后台方法
        DataInfo = "web.CDSS.MachineLearning.InteractiveInterface[A]DHCHisInterface[A]" + action + "[A]" + json;
        var WarnList = $cm({
            ClassName: "web.CDSS.Public.MethodForWebservice",
            MethodName: "CallMethod",
            InputStr: DataInfo,
        }, false);
        if (WarnList == "") {
            return synReturn
        } else {
            return WarnList
        }
    } else {
        DataInfo = "web.CDSS.MachineLearning.InteractiveInterface[A]DHCHisInterface[A]" + action + "[A]" + json;
        $m({
            ClassName: "web.CDSS.Public.MethodForWebservice",
            MethodName: "CallMethod",
            InputStr: DataInfo,
        }, function (PatientUserInfo) {
            TriggerPatientInfo(PatientUserInfo);
            //return Result
        });
        return asynReturn
    }
}

function TriggerPatientInfo(PatientUserInfo) {
    if ((PatientUserInfo !== "") && (PatientUserInfo.split('^').length == 9)) {
        window.PatientUserInfo = PatientUserInfo
        window.IDNO = PatientUserInfo.split('^')[0]
        window.PatientDR = PatientUserInfo.split('^')[1]
        window.VisitID = PatientUserInfo.split('^')[2]
        window.VisitType = PatientUserInfo.split('^')[3]
        window.UserName = PatientUserInfo.split('^')[5]
        window.Config = "1"
        if (typeof (DriverCDSS) == "function") {
            DriverCDSS(PatientUserInfo)
        }
    }
}
DHCCDSSAPI=function() {
    //智能推荐请求
    this.TriggerDHCDSS = TriggerDHCDSS
    //写回监听
    this.MonitorWriteData=function(){
        alert("请手动切换到病历界面再进行写回操作")    
    }
    //开立医嘱
    this.OpenOrderToHis=function(){ 
    }
}
window.TriggerDHCDSS = TriggerDHCDSS;
window.CDSSMakeServerCall = CDSSMakeServerCall;
window.DHCCDSSAPI = DHCCDSSAPI