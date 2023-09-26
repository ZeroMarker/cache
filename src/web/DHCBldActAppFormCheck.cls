/// 提交申请单信息
Class web.DHCBldActAppFormCheck Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	
	//S appFormID=$g(request.Data("appFormID",1))
	S checkUserCode=$g(request.Data("checkUserCode",1))
	S checkUserPwd=$g(request.Data("checkUserPwd",1))
	//S curUserCode=$g(request.Data("curUserCode",1))
	S bldVolume=$g(request.Data("bldVolume",1))
	 
	/*
	S retVal=##class(web.DHCBldAppForm).CheckAppForm(appFormID,checkUserCode,checkUserPwd,curUserCode)
	S success="false"
	I retVal=0 {
		S success="true"
		S info="操作成功!"
    }
    ELSE {
	    S info=$S(retVal=1:"申请单号错误!",retVal=2:"审核者用户名或密码错误!",retVal=3:"审核者错误!",retVal=4:"当前申请单尚未提交申请,请提交申请后再操作!",1:"操作失败!")
	}
	
	S ret="{'success':"_success_",'info':'"_info_"'}"
	*/
	S retVal=##class(web.DHCBldAppForm).CheckUserPwdConfirm(checkUserCode,checkUserPwd,bldVolume)
	S success="false"
	I retVal=0 {
		S success="true"
		S info="操作成功!"
    }
    ELSE {
	    S info=$S(retVal=1:"审核者代码不能为空!",retVal=2:"审核者用户名或密码错误!",retVal=3:"审核者所在用户组错误或所在用户组没有设置最大申请血量!",retVal=4:"审核者所在用户组最大申请血量低于当前申请血量!",retVal=5:"审核者没有审核权限!",1:"操作失败!")
	}
	
	S ret="{'success':"_success_",'info':'"_info_"'}"
	w ret
	Q ret
}

Parameter ActionID = "BLD.APPFORM.CHECK";

Parameter Version = "1.0.0.1";

}
