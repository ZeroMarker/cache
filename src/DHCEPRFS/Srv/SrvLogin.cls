Class DHCEPRFS.Srv.SrvLogin Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvLogin";

Parameter DefaultAdmin = "admin";

/// w ##class(EPRservice.BOLogin).UserIdLogic("admin")
ClassMethod UserIdLogic(UserId As %String) As %String [ WebMethod ]
{
	q:($d(UserId)=0 || (UserId = "")) "0^"
	s userName = ""
	s resultFlag = ""
	s trakCount = 0
	s eprCount = 0
	s totCount = 0
	
	;comment
	&SQL(select count(SupUserName) into:totCount from DHCEPRFS_META.SuperUser)
	if (totCount > 0)
	{
		&SQL(select count(SSUSR_Name) into:trakCount from SQLUser.SS_User where SSUSR_Initials=:UserId)
		if (trakCount = 0)
		{
			s resultFlag = "1^"	//无此用户
			q resultFlag 	
		}
		
		&SQL(select count(SupUserName),SupUserName into:eprCount,:userName from DHCEPRFS_META.SuperUser where SupUserId=:UserId)
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

/// w ##class(EPRservice.BOLogin).ifPass("admin","admin")
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
	/// 如果EPRmeta.SuperUser有了用户信息 admin 用户就失效
	&SQL(select count(SupUserName) into:userCount from DHCEPRFS_META.SuperUser)
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

ClassMethod CheckPass(initial As %Library.String, password As %Library.String) As %Library.String
{
	 
	//更换验证方法
	s eprNameSpace = $ZUTIL(5)
	//modified on 2009-04-22 by houj -- 名字空间参数变化
	s dataNameSpace = ##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")  
	S dataNameSpace = $p($g(dataNameSpace),"^",1)
	i dataNameSpace="" {s dataNameSpace="MEDDATA"}
	
 	d $ZUTIL(5,dataNameSpace)
 	s ertCode=$$select^MVBSSUSR(initial,password)
 	d $ZUTIL(5,eprNameSpace)
 	if (ertCode= 0)
 	{
		q "100"	
	}
	elseif(ertCode= 62)
	{
		q "1"	
	}
	elseif(ertCode= 63)
	{
		q "3"	
	}
	else
	{
		q "4"	
	}
	
 	
 	/*
 	// 0--未校验  1--无此用户  2--此用户没授权 3--用户名与密码不匹配  4--异常 100--通过校验
 	s ret=##class(web.SSUser).IsValidUser(initial,password,1)
 	q:(""=ret) 0
 	q:(-101=ret) 3
 	q:(0>ret) 2
 	q:(0<ret) 100
 	*/
}

ClassMethod IsDefaultAdmin(initial As %Library.String)
{
	q:(initial '= ..#DefaultAdmin) 0
	 
	s count = 0
	&SQL(select count(SupUserName) into:count from DHCEPRFS_META.SuperUser)
	
	q:(count > 0) 0 
	
	q 1
}

///  默认用户admin admin
///  w ##Class(EPRservice.BOLogin).Login("admin", "admin")
ClassMethod Login(initial As %Library.String, password As %Library.String) As DHCEPRFS.Entity.ELoginInfo [ WebMethod ]
{
	
	s passStatus = ..ifPass(initial, password)
	
	s objLoginUser = ##class(DHCEPRFS.Entity.ELoginInfo).%New()
	q:(objLoginUser = "") ""  
   
	s objLoginUser.LoginStatus = passStatus	
	
	q:(passStatus '= "100") objLoginUser
	
	s userName = "", userID = ""
	s isSysManager = ""
	s roleID = ""
	&SQL(select ssusr_name, ssusr_rowid into :userName, :userID from SQLUser.SS_User where ssusr_initials = :initial)
	  
	
	if (..IsDefaultAdmin(..#DefaultAdmin) = 1){  
	    //admin 默认为Administrator 全功能权限	
		&SQL(select ID into :roleID from DHCEPRFS_META.UserRole where RoleName = 'Administrator')	
	   if (isSysManager = "") s isSysManager="1"
	}
	else{
	    &SQL(select IsAdmin, RoleID into:isSysManager, :roleID from DHCEPRFS_META.SuperUser where SupUserId=:initial)
	    if (isSysManager = "") s isSysManager="0"
	}
    
	s objLoginUser.UserId = userID
	s objLoginUser.UserName = userName	
	s objLoginUser.IsSysManager = isSysManager
	s objLoginUser.RoleID = roleID
	
	s OptionValueName=""
	//&SQL(select OptionValue into :OptionValueName from EPRmeta.SysOption where Name='LastProductVersion')
	//if (OptionValueName="")||(OptionValueName=$c(0))  s objLoginUser.LoginStatus = 101
	
	q objLoginUser
}

}
