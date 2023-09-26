/// 处理一些小的操作
Class web.DHCBldActSymptomUtil Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	S actionType=$ZCVT($g(request.Data("actionType",1)),"U")
	S deli=$C(2)
	S info="操作失败" 
	S success="false"
	S ret=""
	S userCode=$g(request.Data("userCode",1))
	//根据条码获取血袋信息
	I actionType="GETPACK" {
		S patAdmID=$g(request.Data("patAdmID",1))
		S packMainID=$g(request.Data("packMainID",1))
		S ret=##class(web.DHCBldSymptom).GetPatPack(packMainID,patAdmID,userCode)
		
	}
	
	//没有发生输血不良反应的血袋确认
	I actionType="CONFIRMNORMALPACK" {
		S patAdmID=$g(request.Data("patAdmID",1))
		S packRowIDs=$g(request.Data("packRowIDs",1))
		S ret=##class(web.DHCBldSymptom).ConfirmNormalPack(packRowIDs,patAdmID,userCode)
		S info=$P(ret,deli,2)
	}
	
	S retVal=$P(ret,deli,1)
	S returnData=$P(ret,deli,2)
		
	I retVal=0 {
		S success="true"
		S info=""  
	}
	
	S ret="{'success':"_success_",'info':'"_info_"','returnData':"""_returnData_"""}"
	W ret
	Q ret
}

Parameter ActionID = "BLD.REACTION.UTIL";

Parameter Version = "1.0.0.1";

}
