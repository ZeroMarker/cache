/// 名称:	EMR.DOC.BL.UserLogin
/// 描述:	通用文档管理模块 Document(Doc) 用户登录业务逻辑类
/// 编写者:	yejian
/// 编写日期: 	2021-3-5
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.UserLogin Extends EMR.DOC.COM.ActionBase
{

Parameter DefaultAdmin = "admin";

/// Desc:       验证用户ID
/// Creator:    yejian
/// CreateDate: 2021-3-8
/// Input:      argArray  命令参数 {"params":{"action":"CHEACK_USERID_LOGIC","args":{"UserId":"admin"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据 100 (用户有效)，1 (无此用户)，2（此用户没授权）
ClassMethod UserIdLogic(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserId = argInJson.params.userId
    
    s strRes = ##Class(EMR.DOC.BL.UserLogin).UserIdLogicJson(UserId)
    d argOutData.Write(strRes)
	if (strRes = "100")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       用户登录
/// Creator:    yejian
/// CreateDate: 2021-3-8
/// Input:      argArray  命令参数 {"action":"CHEACK_USER_LOGIN","params":{"userCode":"2322","password":"1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData :{  
/// 								"LoginStatus":"100", //100 通过校验,3 密码错误，0 未校验，1 无此用户， 2 用户未授权，4 异常,
/// 								"UserId":"0100", //用户登录ID
/// 								"UserName":"李利萍", //用户名
/// 								"IsSysManager":"0",	 //是否超级管理管：0 否，1 是
/// 								"RoleID":"3",	//角色ID
/// 								"CTLocID":["7","3","55","117","139"] //用户可登录科室ID
/// 						 }
ClassMethod Login(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s Password = argInJson.params.password
    s strRes = ..ifPass(UserCode,Password)
    
	if (strRes = "100")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "1")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户不存在",2)
	}elseif(strRes = "2")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","维护系统不存在此用户",2)
	}
	elseif(strRes = "3")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","密码不正确",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","登陆失败",2)
	}
	
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       验证用户ID
/// Creator:    yejian
/// CreateDate: 2021-3-8
/// Input:      UserId 用户ID
/// Output:    argOutData  100 (用户有效)，1 (无此用户)，2（此用户没授权）
/// Debug:     w ##Class(EMR.DOC.BL.UserLogin).UserIdLogicJson("YS01")
ClassMethod UserIdLogicJson(UserId As %String) As %String
{

	q:($d(UserId)=0 || (UserId = "")) "-1"
	s userName = ""
	s resultFlag = ""
	s trakCount = 0
	s eprCount = 0
	s totCount = 0

	&SQL(select count(UserName) into:totCount from CF_EMR_DOC.RBACUser)
	if (totCount > 0)
	{
		&SQL(select count(SSUSR_Name) into:trakCount from SQLUser.SS_User where SSUSR_Initials=:UserId)
		if (trakCount = 0)
		{
			s resultFlag = "1"	//无此用户
			q resultFlag 	
		}
		
		&SQL(select count(UserName),UserName into:eprCount,:userName from CF_EMR_DOC.RBACUser where UserCode=:UserId)
		if (eprCount = 0)
		{
			s resultFlag = "2"	//此用户没授权
		}
		else
		{
			s resultFlag = "100"	//此用户有效
		}
	}
	else
	{
		if (UserId = "admin")
		{
			s resultFlag = "100"
			//s userName = "初始用户"
		}
		else
		{
			s resultFlag = "1"
		}
	}
	q resultFlag
}

/// Desc:       用户登录
/// Creator:    yejian
/// CreateDate: 2021-3-8
/// Input:      initial 用户ID
/// 			password 用户密码
///             argOutData  100 (用户有效)，1 (无此用户)，2（此用户没授权）
/// Output:     -1 失败，1 成功
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 			w ##Class(EMR.DOC.BL.UserLogin).LoginJson("YS01","1",argOutData)
ClassMethod LoginJson(initial As %Library.String, password As %Library.String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-1"
	s passStatus = ..ifPass(initial, password)
	s jsonLoginUser  = ##class(%DynamicObject).%New()
	q:(passStatus '= "100") passStatus
	s userName = ""
	s isSysManager = ""
	s roleID = ""
	s CTLocID = ""
	&SQL(select ssusr_name,ssusr_defaultdept_dr into :userName ,:CTLocID from SQLUser.SS_User where ssusr_initials = :initial)
	  
	
	if (..IsDefaultAdmin(..#DefaultAdmin) = 1){  
	    //admin 默认为Administrator 全功能权限	
		&SQL(select ID into :roleID from CF_EMR_DOC.RBACRole where RoleCode="SuperAdmin")	
	   if (isSysManager = "") s isSysManager="1"
	}
	else{
	   ; &SQL(select IsAdmin, RoleID into:isSysManager, :roleID from CF_EMR_DOC.RBACUser where UserCode=:initial)
	    ;if (isSysManager = "") s isSysManager="0"
	}
	
	s jsonLoginUser.UserId = initial
	s jsonLoginUser.UserName = userName	
	s jsonLoginUser.IsSysManager = isSysManager
	s jsonLoginUser.RoleID = roleID
	s jsonLoginUser.CTLocID =CTLocID
	//获取其他登录科室串
	s jsonLoginUser.CTLocID = ..SSUSRInitialsLoc(initial)
	d jsonLoginUser.%ToJSON(argOutData)
	s strRes = "100"
	q strRes
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
	&SQL(select count(UserName) into:userCount from CF_EMR_DOC.RBACUser)
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
		s userIdCheck = ##Class(EMR.DOC.BL.UserLogin).UserIdLogicJson(initial)
		s userIdCheck = $p(userIdCheck,"^",1)
		q:(userIdCheck'="100") userIdCheck
		
		//Check PW
 		s passCheck = ..CheckPass(initial,password)
		q passCheck	
	}
}

/// Desc:       
/// Creator:    zhangxiaolan
/// CreateDate: 
/// Table:
/// Input:      argArray  	 {"product":"GlobalEMR","action":"LOAD_LOGININFO","params":{"IP": "111.205.6.195:1443"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetEMRLoginInfo(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{

	s $zt = "Error"
	s ip = argInJson.params.IP
    s strRes = ##Class(EMR.DOC.BL.UserLogin).GetEMRLoginInfoJson(ip,.argOutData)
 
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Debug: s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// w ##class(EMR.DOC.BL.UserLogin).GetEMRLogonInfoJson(.argOutData)
ClassMethod GetEMRLoginInfoJson(aIp As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	s json = ##Class(%GlobalBinaryStream).%New()
	s jsonArr = ##class(%DynamicArray).%New()
	s jsonMenu  = ##class(%DynamicObject).%New()
	
	s key=""
	/* 
	//屏蔽後台方法不在取session
	for 
	{
		s key =%session.Next(.key)
		q:(key="")
		
		s newKey = $replace(key,".","")
		s newKey = $replace(newKey,"_","")
		d jsonMenu.%Set(newKey,%session.Data(key))
    }*/

	d jsonArr.%Push(jsonMenu)
	
	d jsonArr.%ToJSON(argOutData)

	q strRes
Error
	q "-1^获取Session信息失败"
}

/// w ##Class(EMR.DOC.BL.UserLogin).CheckPass("demo","1")
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
	&SQL(select count(UserName) into:count from CF_EMR_DOC.RBACUser)
	
	q:(count > 0) 0 
	
	q 1
}

/// w ##Class(EMRservice.BOLogin).SSUSRInitialsLoc("337")
/// 获取其他登录科室RowID数组
ClassMethod SSUSRInitialsLoc(SSUSRInitials As %String) As %DynamicArray
{
	s jsonArr = ##class(%DynamicArray).%New()
	q:SSUSRInitials="" jsonArr
	s SSUSRInitials=$$ALPHAUP^SSUTIL4(SSUSRInitials)
	S SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",SSUSRInitials,""),-1)
	q:SSUSRRowId="" jsonArr
	s SSUSRDefaultDeptDR=$p(^SSU("SSUSR",SSUSRRowId),"^",4)
	s SSUSRGroup=$p(^SSU("SSUSR",SSUSRRowId),"^",5)
	d jsonArr.%Push(SSUSRDefaultDeptDR)
	i $d(^SSU("SSUSR",SSUSRRowId,"OTHLL"))  d  
	.s OTHLLChildsub=""
	.f  s OTHLLChildsub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub)) q:OTHLLChildsub=""  d
	..s OTHLLCTLOCDR=$p(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub),"^",1)
	..s OTHLLUserGroupDR=$p(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub),"^",2)
	..d:(OTHLLCTLOCDR'="") jsonArr.%Push(OTHLLCTLOCDR)
	q jsonArr
}

}
