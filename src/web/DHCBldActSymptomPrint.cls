/// 打印记录单
Class web.DHCBldActSymptomPrint Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	S recordID=$g(request.Data("recordID",1))
	S userCode=$g(request.Data("userCode",1))
	S patAdmID=$g(request.Data("patAdmID",1))
	S printType=$g(request.Data("printType",1))		 
	
	S errCode="0"
	S errMsg="打印错误"
	S repData=##class(web.DHCBldSymptom).GetPrintData(printType,recordID,patAdmID,userCode)
	S retVal=0
	S staticData=$P(repData,$C(1),1)
	S dynamicData=$P(repData,$C(1),2)
	S template=$P(repData,$C(1),3)
	S success="false"
	S info=""  
	I retVal=0 {
		S errMsg=""
		S success="true"
		S info="" 
	}
	
	S ret="{'success':"_success_",'info':'"_info_"','staticData':'"_staticData
	S ret=ret_"','dynamicData':'"_dynamicData_"','template':'"_template
	S ret=ret_"','errCode':'"_errCode_"','errMsg':'"_errMsg_"'}"
	
	W ret
	Q ret
}

Parameter ActionID = "BLD.REACTION.PRINT";

Parameter Version = "1.0.0.1";

}
