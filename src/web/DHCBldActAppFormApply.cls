/// 提交申请单信息
Class web.DHCBldActAppFormApply Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	S ret="{'success':"_"true"_",'info':'保存成功'}"
	
	
	S test=$g(request.Data("apply",1))
	S test2=$g(request.Data("orders",1))
	S test3="手动"
	
	
	//S test=request.CharSet
	S ret="{'success':"_"true"_",'info':'"_"CharSet:"_request.CharSet_",Response:"_test3_",POST:"_test_",URL:"_test2_"'}"
	w ret
	Q ret
}

Parameter ActionID = "BLD.APPFORM.APPLY";

Parameter Version = "1.0.0.1";

}
