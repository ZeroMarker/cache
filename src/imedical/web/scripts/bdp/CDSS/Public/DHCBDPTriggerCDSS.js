/*
 * @Author: 基础数据平台-范文凯
 * @Date:   2020-07-09
 * @Last Modified by:   范文凯
 * @Last Modified time: 2020-07-09
 * @描述:临床数据拼成JSON串后传给后台去做校验
 */
$(function() {
    var DataInfo = "";
    window.InterfaceIP = "192.144.152.252:8080";
    window.MInterface = "http://192.144.152.252/imedical/web/csp";
	/**
	* @Author 范文凯
	* @desc 封装跨域调用CDSS后台M方法类
	* @Last Modified by:   范文凯
	* @Last Modified time: 
	*/
    function CDSSMakeServerCall (DataInfo){
        var flag = false;
        var returnInfo ="";
        var str = DataInfo.replace(/\"/g, '""')
        returnInfo = tkMakeServerCall("web.CDSS.Public.MethodForWebservice","CallMethod",str)
        return returnInfo;
    }
    //判断该患者是否已经存在医嘱
    function getDHCDocDataFlag(PatientDR,VisitID){
        var DataInfo = "web.CDSS.MachineLearning.ParseMode[A]getDHCDocFlag[A]"+PatientDR+"[A]"+VisitID;
        
        var DHCDocFlag = CDSSMakeServerCall(DataInfo);
        
        return DHCDocFlag
    }
    //医生站数据接口
    function DocToCDSSInterface(funName,IDNO,UserID,CTLocID,HospID)
    {
        try{
            //if(!CDSSOpenFlag) return;
            switch(funName){
            case "SynDiagInfo":
                $.cm({
                    ClassName:"web.CDSS.MachineLearning.ExtractDHCDocData",
                    MethodName:"GetAllDiagnos", //"GetDiagnosInfo",
                    EpisodeID:IDNO,
                    UserID:UserID,
                    LogonLocID:CTLocID,
                    LogonHospID:HospID
                },function(DiagInfo){
                   // var CDSSRet=TriggerDHCDSS("SYNCHRONOUS_DIAGNOSTIC_INFORMATION",DiagInfo);
                   // 入CDSS知识库
                   return DiagInfo
                   //CDSSDataBase("SYNCHRONOUS_DIAGNOSTIC_INFORMATION",DiagInfo)
                });
                break;
            case "SynOrdInfo":
                $.cm({
                    ClassName:"web.CDSS.MachineLearning.ExtractDHCDocData",
                    MethodName:"GetAllOrderInfo",  //"GetAllOrderInfo",
                    EpisodeID:IDNO,
                    UserID:UserID,
                    LogonLocID:CTLocID,
                    LogonHospID:HospID
                },function(OrderInfo){
                    //var CDSSRet=TriggerDHCDSS("SYNCHRONIZE_PATIENT_ORDERS",OrderInfo);
                    //入CDSS知识库
                    CDSSDataBase("SYNCHRONIZE_PATIENT_ORDERS",OrderInfo)
                    
                });
                break;
                default:break;
        	}
    	}catch(e){
        debugger;
        }
    }
    function TriggerDHCDSS (action,json){
        //同步患者历史诊断
        //return 1 = 存在 return 0  = 不存在   
        if (action == 'INITIALIZE_PATIENT_INFORMATION')
        {
            //声明全局变量
            window.UserName = json.UserName;
            window.PatientDR = json.PatientDR;
            window.VisitID = json.VisitID;   
            window.IDNO =json.IDNO ;
            window.UserID = json.UserID;
            window.CTLocID = json.CTLocID;
            var HospID = "";  
            var DHCDocFlag = getDHCDocDataFlag(PatientDR,VisitID);
            if (DHCDocFlag == 0)
            {
                //当前CDSS库不存在患者诊断 同步患者历史诊断
                json = DocToCDSSInterface("SynDiagInfo",IDNO,UserID,CTLocID,HospID);     
                action = "SYNCHRONOUS_DIAGNOSTIC_INFORMATION"      
            }
        }
	    CDSSDataBase(action,json) 
           
    }
    //解析数据并进入CDSS知识库
    function CDSSDataBase(action,json){
        var DataInfo = "";
        if (json == undefined) {
            return
        }
        if (typeof(json) == 'object')
        {
            json = JSON.stringify(json)  
        }
        //测试把tk改为CDSSMakeServerCall
        DataInfo = "web.CDSS.MachineLearning.InteractiveInterface[A]DHCHisInterface[A]"+action+"[A]"+json;
        var PatientUserInfo = CDSSMakeServerCall(DataInfo);
        if (PatientUserInfo !=="")
        {
            window.PatientUserInfo = PatientUserInfo
            window.IDNO = PatientUserInfo.split('^')[0]
            window.PatientDR = PatientUserInfo.split('^')[1]
            window.VisitID = PatientUserInfo.split('^')[2]
            window.VisitType = PatientUserInfo.split('^')[3]
            window.UserName = PatientUserInfo.split('^')[5]
            window.Config = "1"
            DriverCDSS(PatientUserInfo)     
        }
        var params = [{"ResultCode": "0", "ResultContent": "成功"}]
        return params
    }
    window.TriggerDHCDSS = TriggerDHCDSS; 
    window.CDSSMakeServerCall = CDSSMakeServerCall;
})
