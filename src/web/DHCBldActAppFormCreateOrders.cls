/// 保存申请单信息
Class web.DHCBldActAppFormCreateOrders Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	S patAdmID=$g(request.Data("patAdmID",1))
	S userCode=$g(request.Data("userCode",1))
	S transOrders=$g(request.Data("transOrders",1))
	
	S ^DEBUG($zn,"Par")=patAdmID_$C(2)_userCode_$C(2)_transOrders_$C(2)
	S dataDeli=$C(2),fieldDeli=$C(3)
	S bldOrders=##class(web.DHCBldAppForm).CreateTransOrders(patAdmID,userCode,transOrders)
	I $l(bldOrders) {
		//生成医嘱成功,转换为JSon数据
		S ret=##class(web.DHCBldAppFormLayout).BuildStoreData("ORDERS",bldOrders)
			
	}ELSE{
		S ret="{resutls:0,rows:''}"
	}
	w ret
	Q ret
}

Parameter ActionID = "BLD.APPFORM.CREATEORDERS";

Parameter Version = "1.0.0.1";

}
