/// 报告处理
Class web.DHCBldActReport Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	
	S appFormID=$g(request.Data("appFormID",1))	//申请单号
	S userCode=$g(request.Data("userCode",1))	//操作者
	S repType=$g(request.Data("repType",1))		//报告单类型
	S patAdmID=$g(request.Data("patAdmID",1))
   	
   	s ^DEBUG=appFormID_","_repType_","_patAdmID_","_userCode
	S retVal=0
	S errCode="0"
	S errMsg="rrrrr"
	S repData=##class(web.DHCBldAppForm).GetReportData(appFormID,repType,patAdmID,userCode)
	S staticData=$P(repData,$C(4),1)
	S dynamicData=$P(repData,$C(4),2)
	S template=$P(repData,$C(4),3)
	S success="false"
	I retVal=0 {
		S success="true"
		S info=""  
    }
    ELSE {
	    
	}
	
	S ret="{'success':"_success_",'info':'"_info_"','staticData':'"_staticData
	S ret=ret_"','dynamicData':'"_dynamicData_"','template':'"_template
	S ret=ret_"','errCode':'"_errCode_"','errMsg':'"_errMsg_"'}"
	
	w ret
	Q ret
}

Parameter ActionID = "BLD.APPFORM.REPORT";

Parameter Version = "1.0.0.1";

}
