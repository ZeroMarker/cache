/// 取消申请
Class web.DHCBldActAppFormCancleApply Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	
	S appFormID=$g(request.Data("appFormID",1))
	S curUserCode=$g(request.Data("curUserCode",1))
	S retVal=##class(web.DHCBldAppForm).CancelApplyAppForm(appFormID,curUserCode)
	S success="false"
	I retVal=0 {
		S success="true"
		S info="操作成功!"
    }
    ELSE {
	    S info=$S(retVal=1:"申请单号错误!",retVal=2:"只能取消已经提交申请的申请单!",1:"操作失败!")
	}
	
	S ret="{'success':"_success_",'info':'"_info_"'}"
	
	w ret
	Q ret
}

Parameter ActionID = "BLD.APPFORM.CANCELAPPLY";

Parameter Version = "1.0.0.1";

}
