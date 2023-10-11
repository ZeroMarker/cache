
    DHCDSSAPI=function() {
        //智能推荐请求
        this.TriggerDHCDSS = function (action, json) {
            if (json == undefined) {
                return
            }
            //同步捕捉预警的预返回值 用于后台报错或运行时间超过设定值
            var synReturn = { "BlockWarn": [], "PopWarn": [] }
            //异步预返回值
            var asynReturn = [{ "ResultCode": "0", "ResultContent": "成功" }]
            //初始化请求信息
            var DataInfo = ""
            //获取患者信息串用于驱动CDSS界面刷新
            if (typeof (json) == 'object') {
                if (json.VisitType == 1) {
                    var VisitType = "急诊"
                } else if (json.VisitType == 2) {
                    var VisitType = "门诊"
                } else if (json.VisitType == 3) {
                    var VisitType = "住院"
                }
                PatientUserInfo = json.IDNO + "^" + json.PatientDR + "^" + json.VisitID + "^" + VisitType + "^" + json.UserID + "^" + json.UserName + "^" + json.DeptCode + "^" + json.DeptName + "^1"
                //return掉多余的初始化患者信息
                if ((action == 'INITIALIZE_PATIENT_INFORMATION')&&(PatientUserInfo==prePatientInfo)){
                    return asynReturn
                }
            }
            if (typeof (json) == 'object') {
                json = JSON.stringify(json)
            }
            //根据action来判断同步还是异步调用CDSS后台方法  CATCH_DIAG_WARNING or CATCH_ORDER_WARNING 同步调用 其他异步
            if ((action == 'CATCH_DIAG_WARNING')||(action == 'CATCH_ORDER_WARNING'))
            {
                //同步调用后台方法
                DataInfo = "web.CDSS.MachineLearning.InteractiveInterface[A]DHCHisInterface[A]" + action + "[A]" + json;
                var WarnList = $cm({
                    ClassName:"web.CDSS.Public.MethodForWebservice",
                    MethodName:"CallMethod",
                    InputStr: DataInfo,
                },false);
                if (WarnList==""){
                    return synReturn
                }else{
                    return WarnList
                }
            }else if(action == 'ALLERGY_INFORMATION'){
                 //异步调用后台方法
                 DataInfo = "web.CDSS.MachineLearning.InteractiveInterface[A]DHCHisInterface[A]" + action + "[A]" + json;
                 $m({
                     ClassName: "web.CDSS.Public.MethodForWebservice",
                     MethodName: "CallMethod",
                     InputStr: DataInfo,
                 }, function () {
                 });
                 return asynReturn
            }else{
                //异步调用后台方法
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
        };
        //写回监听
        this.MonitorWriteData=function(){    
        }
        //开立医嘱
        this.OpenOrderToHis=function(){ 
        }
        document.write('<script type="text/javascript" src="../scripts/bdp/CDSSVue/Public/DHCBDP_CDSS.js"></script>');
    }
var PatientUserInfo = "";
var prePatientInfo = "";
function TriggerPatientInfo(PatientUserInfo) {
    if ((PatientUserInfo !== "")&&(PatientUserInfo.split('^').length==9)&&(PatientUserInfo !== prePatientInfo)) {
        window.PatientUserInfo = PatientUserInfo
        window.IDNO = PatientUserInfo.split('^')[0]
        window.PatientDR = PatientUserInfo.split('^')[1]
        window.VisitID = PatientUserInfo.split('^')[2]
        window.VisitType = PatientUserInfo.split('^')[3]
        window.UserCode = PatientUserInfo.split('^')[4]
        window.UserName = PatientUserInfo.split('^')[5]
        window.Config = "1"
        prePatientInfo = PatientUserInfo
    }
    if (PatientUserInfo !== "")
    {
        DriverCDSS(PatientUserInfo)
    }
}
function CDSSMakeServerCall (DataInfo){
            var returnInfo ="";
            $.ajax({
                url:"dhc.bdp.cdss.postservice.csp",
                type: "post",
                data:{
                    "jsonInfo":DataInfo
                },
                async:false,
                success: function(data){
                    returnInfo=data;
                },
                error:function(){
                    returnInfo ="false"
                }
            }); 
            return returnInfo.replace(/[\r\n]/g, "");
        }

window.DHCDSSAPI=DHCDSSAPI;