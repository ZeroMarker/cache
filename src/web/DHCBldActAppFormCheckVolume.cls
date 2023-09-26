/// 保存申请单信息
Class web.DHCBldActAppFormCheckVolume Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	S patAdmID=$g(request.Data("admID",1))
	S userCode=$g(request.Data("userCode",1))
	S orders=$g(request.Data("orders",1))
	S ^DEBUG($zn,"Par")=patAdmID_$C(2)_userCode_$C(2)_orders_$C(2)
	S dataDeli=$C(2),fieldDeli=$C(3)
	S retStr=##class(web.DHCBldAppForm).GetUserCPVolume(userCode,orders)
	S success=$p(retStr,"^",1)
	S info=$p(retStr,"^",2)
	
	S ret="{'success':"_success_",'info':'"_info_"'}"
	w ret
	Q ret
}

Parameter ActionID = "BLD.APPFORM.CHECKVOLUME";

Parameter Version = "1.0.0.1";

}
