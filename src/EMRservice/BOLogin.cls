Class EMRservice.BOLogin Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "BOLogin";

Parameter DefaultAdmin = "admin";

// w ##class(EPRservice.BOLogin).ifPass("admin","admin")

ClassMethod UserIdLogic(UserId As %String) As %String [ WebMethod ]
{
	q:($d(UserId)=0 || (UserId = "")) "0^"
	s userName = ""
	s resultFlag = ""
	s trakCount = 0
	s eprCount = 0
	s totCount = 0
	
	;comment
	&SQL(select count(SupUserName) into:totCount from EMRmeta.SuperUser)
	if (totCount > 0)
	{
		&SQL(select count(SSUSR_Name) into:trakCount from SQLUser.SS_User where SSUSR_Initials=:UserId)
		if (trakCount = 0)
		{
			s resultFlag = "1^"	//无此用户
			q resultFlag 	
		}
		
		&SQL(select count(SupUserName),SupUserName into:eprCount,:userName from EMRmeta.SuperUser where SupUserId=:UserId)
		if (eprCount = 0)
		{
			s resultFlag = "2^"	//此用户没授权
		}
		else
		{
			s resultFlag = "100^"	//此用户有效
		}
	
		q resultFlag_userName
	}
	else
	{
		if (UserId = "admin")
		{
			s resultFlag = "100^"
			s userName = "初始用户"
		}
		else
		{
			s resultFlag = "1^"
		}
		
		q resultFlag_userName
	}
}

ClassMethod ifPass(initial As %Library.String, password As %Library.String) As %Library.String [ WebMethod ]
{
	// 0--未校验  1--无此用户  2--此用户没授权 3--用户名与密码不匹配  4--异常 100--通过校验
	set resultFlag = ""  
	
	if ($d(initial)=0 || (initial = ""))
	{
		s resultFlag = "1"
		q resultFlag
	}
	if ($d(password)=0)
	{
		s password = ""	
	}
	
	s userCount = 0
	/// 如果EMRmeta.SuperUser有了用户信息 admin 用户就失效
	&SQL(select count(SupUserName) into:userCount from EMRmeta.SuperUser)
	if (userCount = 0)
	{
		if (initial '= ..#DefaultAdmin)
		{
			s resultFlag = "1"
			q resultFlag	
		}
		elseif (password '= ..#DefaultAdmin)
		{
			s resultFlag = "3"
			q resultFlag				
		}
		else
		{
			s rtnCode = "100"
			q rtnCode			
		}

	}
	else
	{
		s userIdCheck = ..UserIdLogic(initial)
		s userIdCheck = $p(userIdCheck,"^",1)
		q:(userIdCheck'="100") userIdCheck
		
		//Check PW
 		s passCheck = ..CheckPass(initial,password)
		q passCheck	
	}
}

/// w ##Class(EMRservice.BOLogin).CheckPass("demo","1")
ClassMethod CheckPass(initial As %Library.String, password As %Library.String) As %Library.String
{
	// 错误返回-101，正确返回rowid
	s ertCode=##class(web.SSUser).IsValidUser(initial,password,1)
	q:(("-101"=ertCode)||(ertCode["^")) 3
	q 100
}

ClassMethod IsDefaultAdmin(initial As %Library.String)
{
	q:(initial '= ..#DefaultAdmin) 0
	 
	s count = 0
	&SQL(select count(SupUserName) into:count from EMRmeta.SuperUser)
	
	q:(count > 0) 0 
	
	q 1
}

///  默认用户admin admin
ClassMethod Login(initial As %Library.String, password As %Library.String) As EMRservice.entity.ELoginInfo [ WebMethod ]
{
	
	s passStatus = ..ifPass(initial, password)
	b
	s objLoginUser = ##class(EMRservice.entity.ELoginInfo).%New()
	q:(objLoginUser = "") ""  
   
	s objLoginUser.LoginStatus = passStatus	
	q:(passStatus '= "100") objLoginUser
	
	s userName = ""
	s isSysManager = ""
	s roleID = ""
	s CTLocID = ""
	&SQL(select ssusr_name,ssusr_defaultdept_dr into :userName ,:CTLocID from SQLUser.SS_User where ssusr_initials = :initial)
	  
	
	if (..IsDefaultAdmin(..#DefaultAdmin) = 1){  
	    //admin 默认为Administrator 全功能权限	
		&SQL(select ID into :roleID from EMRmeta.MainRole where RoleName = 'Administrator')	
	   if (isSysManager = "") s isSysManager="1"
	}
	else{
	    &SQL(select IsAdmin, RoleID into:isSysManager, :roleID from EMRmeta.SuperUser where SupUserId=:initial)
	    if (isSysManager = "") s isSysManager="0"
	}

	s objLoginUser.UserId = initial
	s objLoginUser.UserName = userName	
	s objLoginUser.IsSysManager = isSysManager
	s objLoginUser.RoleID = roleID
	s objLoginUser.CTLocID =CTLocID
	//获取其他登录科室串
	s OtherLogLoc = ..SSUSRInitialsLoc(initial)
	
	s objLoginUser.CTLocID = "^"_OtherLogLoc_"^"
	;s OptionValueName=""
	;&SQL(select OptionValue into :OptionValueName from EMRmeta.SysOption where Name='LastProductVersion')
	;if (OptionValueName="")||(OptionValueName=$c(0))  s objLoginUser.LoginStatus = 101
	
	q objLoginUser
}

///  单点登录获取用户信息
/// debug: s obj = ##class(EMRservice.BOLogin).GetLogin("ys01")
ClassMethod GetLogin(initial As %Library.String) As EMRservice.entity.ELoginInfo [ WebMethod ]
{
	

	s objLoginUser = ##class(EMRservice.entity.ELoginInfo).%New()
	q:(objLoginUser = "") "" 
	s userIDMark ="" 
    &SQL(select SupUserID into:userIDMark from EMRmeta.SuperUser where SupUserId=:initial)
	if (userIDMark'="")
	{
		s objLoginUser.LoginStatus = "100"
	}
	else
	{
		s objLoginUser.LoginStatus = "2"
	}
	q:(objLoginUser.LoginStatus '= "100") objLoginUser
	
	s userName = ""
	s isSysManager = ""
	s roleID = ""
	s CTLocID = ""
	&SQL(select ssusr_name,ssusr_defaultdept_dr into :userName ,:CTLocID from SQLUser.SS_User where ssusr_initials = :initial)
	  
	
	if (..IsDefaultAdmin(..#DefaultAdmin) = 1){  
	    //admin 默认为Administrator 全功能权限	
		&SQL(select ID into :roleID from EMRmeta.MainRole where RoleName = 'Administrator')	
	   if (isSysManager = "") s isSysManager="1"
	}
	else{
	    &SQL(select IsAdmin, RoleID into:isSysManager, :roleID from EMRmeta.SuperUser where SupUserId=:initial)
	    if (isSysManager = "") s isSysManager="0"
	}

	s objLoginUser.UserId = initial
	s objLoginUser.UserName = userName	
	s objLoginUser.IsSysManager = isSysManager
	s objLoginUser.RoleID = roleID
	s objLoginUser.CTLocID =CTLocID
	//获取其他登录科室串
	s OtherLogLoc = ..SSUSRInitialsLoc(initial)
	
	s objLoginUser.CTLocID = "^"_OtherLogLoc_"^"
	
	q objLoginUser
}

/// w ##Class(EMRservice.BOLogin).SSUSRInitialsLoc("337")
/// 获取其他登录科室RowID串
ClassMethod SSUSRInitialsLoc(SSUSRInitials As %String) As %String
{
	q:SSUSRInitials="" ""
	s LocRet=""
	s SSUSRInitials=$$ALPHAUP^SSUTIL4(SSUSRInitials)
	S SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",SSUSRInitials,""),-1)
	q:SSUSRRowId="" ""
	s SSUSRDefaultDeptDR=$p(^SSU("SSUSR",SSUSRRowId),"^",4)
	s SSUSRGroup=$p(^SSU("SSUSR",SSUSRRowId),"^",5)
	s LocRet=SSUSRDefaultDeptDR
	i $d(^SSU("SSUSR",SSUSRRowId,"OTHLL"))  d  
	.s OTHLLChildsub=""
	.f  s OTHLLChildsub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub)) q:OTHLLChildsub=""  d
	..s OTHLLCTLOCDR=$p(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub),"^",1)
	..s OTHLLUserGroupDR=$p(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub),"^",2)
	..s LocRet=LocRet_"^"_OTHLLCTLOCDR
	q LocRet
}

}
