/// 名称:	EMR.DOC.BL.RBACUser
/// 描述:	通用文档管理模块 Document(Doc) 用户业务逻辑类
/// 编写者:	yejian
/// 编写日期: 	2020-12-14
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.RBACUser Extends EMR.DOC.COM.ActionBase
{

/// Desc:       加载用户信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_USER", "params":{"userCode":"YS01" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetUser(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
    s userDataJson = ##class(%DynamicObject).%New()
    s outData = ##class(%DynamicObject).%New()
    s strRes = ##Class(EMR.DOC.BL.RBACUser).GetUserJson(UserCode,userDataJson)
	if (strRes = "1")
	{ 
	    s argOutMessage.success = ..#OK
	}
	elseif(strRes = "-1")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户不存在",2)
	}else{
		q ..SetOutMessage(argOutMessage,"ERROR","获取用户信息失败",2)	
	}
	/*拼接菜单信息*/
	s jArrMeun = ##class(%DynamicArray).%New()
    s strRes = ##Class(EMR.DOC.BL.TemplateManage).GetEMRSystemMenuJson(UserCode,"MENU",.jArrMeun)
	if (strRes = "1")
	{ 
		s outData.user = userDataJson
		s outData.list = jArrMeun
		d outData.%ToJSON(argOutData)
	    q ..SetOutMessage(argOutMessage,"OK")
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","该用户没有功能授权",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取所有科室数据
/// Creator:    yejian
/// CreateDate: 2021-3-9
/// Input:      argArray  命令参数 {"params":{"action":"GET_RBAC_CTLOCS","args":{}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRBACCTLocs(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    
    s strRes = ##Class(EMR.DOC.BL.RBACUser).GetRBACCTLocsJson(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","接口错误,未获取到科室列表数据",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据科室获取用户数据
/// Creator:    yejian
/// CreateDate: 2021-3-9
/// Input:      argArray  命令参数 {"params":{"action":"GET_RBAC_CTLOCUSERS","args":{"CTLocName":"呼吸内科门诊"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRBACCTLocUsers(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s CTLocName = argInJson.params.CTLocName
    s UserName = argInJson.params.userName
    s current = argInJson.params.current
    s pageSize = argInJson.params.pageSize 
    s strRes = ##Class(EMR.DOC.BL.RBACUser).GetRBACCTLocUsersJson(CTLocName,UserName,current,pageSize,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未获取到科室用户",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取本系统用户数据
/// Creator:    yejian
/// CreateDate: 2021-3-9
/// Input:      argArray  命令参数 {"action":"GET_RBAC_USERS","params":{"current":1,"pageSize":20},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRBACUsers(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s current = argInJson.params.current
	s pageSize = argInJson.params.pageSize
	s userCode = argInJson.params.code
	s userName = argInJson.params.name
    s strRes = ##Class(EMR.DOC.BL.RBACUser).GetRBACUsersJson(current,pageSize,userCode,userName,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取维护程序用户列表出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       新增用户
/// Creator:    yejian
/// CreateDate: 2021-03-08
/// Input:      argArray  命令参数 {"action":"ADD_RBAC_USER","params":[{"userCode":"2343","userName":"w","roleId":1}],"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息 成功<string> 角色id 失败 <string> -1
///            	argOutData    返回数据
ClassMethod AddRBACUsers(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	if (argInJson.%GetTypeOf("params")'="array")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","params参数应该为数组",2)
	}	
	s jsonArr = argInJson.params
    s strRes = ##Class(EMR.DOC.BL.RBACUser).AddRBACUsersJson(jsonArr,.argOutData)
    //失败:失败:-1 用户不能为空, -2 无效的角色 -3 添加用户失败
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-1")
	{  
		d argOutData.Write(..#NONE)
	    q ..SetOutMessage(argOutMessage,"ERROR","用户不能为空",2)
	}
	elseif(strRes="-2")
	{  
		d argOutData.Write(..#NONE)
	    q ..SetOutMessage(argOutMessage,"ERROR","无效的角色",2)
	}else
	{  
		d argOutData.Write(..#NONE)
	    q ..SetOutMessage(argOutMessage,"ERROR","添加用户失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       更新用户
/// Creator:    yejian
/// CreateDate: 2021-03-08
/// Input:      argArray  命令参数 {"params":{"action":"UP_RBAC_USER","args":{"ID":"1","RoleID":"1"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息 
///            	argOutData    返回数据 返回1，失败：返回-1
ClassMethod UpRBACUsers(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoUser = ##class(EMR.DOC.DTO.RBACUser).%New()
	s dtoUser.ID = argInJson.params.id
	s dtoUser.RoleID = argInJson.params.roleId
    s strRes = ##Class(EMR.DOC.BL.RBACUser).UpRBACUsersJson(dtoUser,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-1")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入用户ID",2)
	}elseif(strRes="-2")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","没有找到用户记录",2)
	}elseif(strRes="-3")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","没有找到角色记录",2)
	}else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","更新用户出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除用户
/// Creator:    yejian
/// CreateDate: 2021-03-08
/// Input:      argArray  命令参数 {"params":{"action":"DEL_RBAC_USER","args":{["1","2","3"]}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息 
///            	argOutData    返回数据 返回1，失败：返回-1
ClassMethod DelRBACUsers(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s arrIDS = argInJson.params
    s strRes = ##Class(EMR.DOC.BL.RBACUser).DelRBACUsersJson(arrIDS)
    d argOutData.Write(strRes)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-1")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入用户ID数组",2)
	}else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","删除用户失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取用户信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserCode  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACUser).GetUser("YS01",argOutData)
ClassMethod GetUserJson(argUserCode As %String, argJsonObj As %DynamicObject) As %String
{
	s json = ##Class(%GlobalBinaryStream).%New()
	s strRes = "-1"
	s strRowID = $o(^CF.EMR.DOC.RBACUserI("IdxUser"," "_$zcvt(argUserCode,"U"),""))
	q:(strRowID="") strRes
	s objUser = ##Class(CF.EMR.DOC.RBACUser).%OpenId(strRowID)
	q:(objUser="") strRes
	s strRes = "1"
	s argJsonObj.userId = strRowID
	s argJsonObj.userName = objUser.UserName
	s argJsonObj.userCode = argUserCode
	s strRoleID = objUser.RoleID.%Id()
	s strRoleName = objUser.RoleID.RoleName
	s argJsonObj.admin = "false"
	s:(objUser.IsAdmin="1") argJsonObj.admin = "true"
	s argJsonObj.roleId =strRoleID
	s argJsonObj.roleName = strRoleName

	//s ipHref = %request.CgiEnvs("SERVER_NAME")
	s argJsonObj.server = ""
	/*s ProductID = ""
	for {
		s ProductID = $o(^CF.EMR.DOC.RBACOperPermissionI("IdxRoleProuct",strRoleID,ProductID))
		q:(ProductID = "")			
		s objProduct = ##Class(CT.EMR.DOC.Products).%OpenId(ProductID)
        continue:(objProduct="")
        s jsonProduct  = ##class(%DynamicObject).%New()
        
        s jsonProduct.ProductID = ProductID
        s jsonProduct.ProductCode =objProduct.ProductCode
        s jsonProduct.ProductName =objProduct.ProductName

		//添加操作授权数据
		s jsonArrOperPermission = ##class(%DynamicArray).%New()
        if (strRoleID'="")
        {
	        s operRowID = ""
			for {
				s operRowID = $o(^CF.EMR.DOC.RBACOperPermissionI("IdxProRole",ProductID,strRoleID,operRowID))
				q:(operRowID = "")				
				s objOper = ##Class(CF.EMR.DOC.RBACOperPermission).%OpenId(operRowID)
				q:(objOper="")
				s jsonOperPermission  = ##class(%DynamicObject).%New()
				s jsonOperPermission.FuncCode = objOper.FuncCode.FuncCode_"^"_objOper.FuncCode.ParentCode
				s jsonOperPermission.Permission = objOper.DataPerTypes.Code
		        d jsonArrOperPermission.%Push(jsonOperPermission)
			}
        }
        s jsonProduct.RBACOperPermission =jsonArrOperPermission
        //添加数据授权
        s jsonArrDataPermission = ##class(%DynamicArray).%New()
        if (strRoleID'="")
        {
	        s dataRowID = ""
			for {
				s dataRowID = $o(^CF.EMR.DOC.RBACDataPermissionI("IdxProRole",ProductID,strRoleID,dataRowID))
				q:(dataRowID = "")				
				s objData = ##Class(CF.EMR.DOC.RBACDataPermission).%OpenId(dataRowID)
				q:(objData="")
				s jsonDataPermission  = ##class(%DynamicObject).%New()
				s jsonDataPermission.DataTypes = objData.DataTypes.Code
				s jsonDataPermission.DataName = objData.DataName
				s jsonDataPermission.DataID = objData.DataID
				s jsonDataPermission.Permission = objData.DataPerTypes.Code
		        d jsonArrDataPermission.%Push(jsonDataPermission)
			}
        }
        s jsonProduct.RBACDataPermission = jsonArrDataPermission
        d jsonArr.%Push(jsonProduct)
	}
	s jsonObj.Product = jsonArr*/
	q strRes
}

/// Desc:       获取所有科室数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACUser).GetRBACCTLocsJson(.argOutData)
ClassMethod GetRBACCTLocsJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s json = ##Class(%GlobalBinaryStream).%New()
	s jsonArrLoc = ##class(%DynamicArray).%New()
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.RBACUser:GetAllCTLoc")
	d result.Execute()
	q:(result = "") "-1" 
	
	While result.Next() 
	{
		s jsonLoc  = ##class(%DynamicObject).%New()
	 	s jsonLoc.CTLocRowid = result.GetDataByName("CTLOC_RowID")
	 	s jsonLoc.CTLocDesc = result.GetDataByName("CTLOC_Desc")

        d jsonArrLoc.%Push(jsonLoc)
	}
	d jsonArrLoc.%ToJSON(argOutData)

	q strRes
}

Query GetAllCTLoc() As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTLOC_RowID,CTLOC_Desc", SELECTMODE = "RUNTIME") [ SqlName = GetAllCTLoc, SqlProc ]
{
	Select CTLOC_RowID,CTLOC_Desc from SQLUser.CT_Loc order by CTLOC_RowID
}

/// Desc:       根据条件获取用户数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACUser).GetRBACCTLocUsersJson("呼吸内科门诊",.argOutData)
ClassMethod GetRBACCTLocUsersJson(argCTLocName As %String = "", argUserName As %String = "", argCurrent As %String = 1, argPageSize As %String = 20, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s:argCurrent="" argCurrent=..#DECURRENT
	s:argPageSize="" argPageSize=..#DEPAGESIZE
	s resultObj = ##class(%DynamicObject).%New()
	s jsonArrUser = ##class(%DynamicArray).%New()
	if ((argCTLocName'="")&(argUserName'="")){
		s result = ##class(%ResultSet).%New("EMR.DOC.BL.RBACUser:SelectCTLocUserSubByCTLocNameAndUserName")
		d result.Execute(argCTLocName,argUserName)
	}elseif((argCTLocName="")&(argUserName="")){
		s result = ##class(%ResultSet).%New("EMR.DOC.BL.RBACUser:SelectCTLocUserSubAll")
		d result.Execute()
	}else{
		s result = ##class(%ResultSet).%New("EMR.DOC.BL.RBACUser:SelectCTLocUserSubByCTLocNameOrUserName")
		d result.Execute(argCTLocName,argUserName)
	}
	q:(result = "") "-1" 
	s count = 0
	s startIndex = (argCurrent-1)*argPageSize+1
	s endIndex = startIndex+argPageSize-1
	While result.Next() 
	{
		s SSUsrInitials = result.GetDataByName("SSUSR_Initials")
		s userRowID = $o(^CF.EMR.DOC.RBACUserI("IdxUser"," "_$zcvt(SSUsrInitials,"U"),""))
		continue:(userRowID'="")
		s count=count+1
		continue:((count<startIndex)||(count>endIndex))
		s jsonUser  = ##class(%DynamicObject).%New()
	 	s jsonUser.SSUsrGroup = result.GetDataByName("SSUSR_Group")
	 	s jsonUser.SSUsrRowid = result.GetDataByName("SSUSR_RowId")
	 	s jsonUser.SSUsrName = result.GetDataByName("SSUSR_Name")
	 	s jsonUser.SSUsrInitials = result.GetDataByName("SSUSR_Initials")
	 	s jsonUser.SSUsrDefaultDept = result.GetDataByName("CTLOC_Desc")
	 	;
	 	;s jsonUser.checked = $case(userRowID,"":"false",:"true")
        d jsonArrUser.%Push(jsonUser)
	}
	s resultObj.list = jsonArrUser
	s resultObj.current = argCurrent
	s resultObj.pageSize = argPageSize
	s resultObj.total = count
	d resultObj.%ToJSON(argOutData)

	q strRes
}

/// debug d ##class(%ResultSet).RunQuery("EMR.DOC.BL.RBACUser","SelectCTLocUserSubByCTLocNameAndUserName","","")
Query SelectCTLocUserSubByCTLocNameAndUserName(CTLocName As %String, UserName As %String) As %SQLQuery
{
	select a.SSUSR_Group, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, a.SSUSR_Name, a.SSUSR_Initials 
	from SQLUser.SS_User as a where a.SSUSR_Name like "%"_:UserName_"%" and a.SSUSR_DefaultDept_DR->CTLOC_Desc = :CTLocName and a.SSUSR_Active='Y'
}

Query SelectCTLocUserSubByCTLocNameOrUserName(CTLocName As %String = "", UserName As %String = "") As %SQLQuery
{
	select a.SSUSR_Group, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, a.SSUSR_Name, a.SSUSR_Initials 
	from SQLUser.SS_User as a where (a.SSUSR_DefaultDept_DR->CTLOC_Desc like :CTLocName or a.SSUSR_Name like "%"_:UserName_"%") and a.SSUSR_Active='Y'
}

Query SelectCTLocUserSubAll() As %SQLQuery
{
	select a.SSUSR_Group, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, a.SSUSR_Name, a.SSUSR_Initials 
	from SQLUser.SS_User as a where  a.SSUSR_Active='Y'
}

/// Desc:       获取本系统用户数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     返回数据 成功：1,
/// 					 失败:-1 
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACUser).GetRBACUsersJson(.argOutData)
ClassMethod GetRBACUsersJson(argCurrent As %String, argPageSize As %String, argUserCode As %String = "", argUserName As %String = 20, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s:argCurrent="" argCurrent=1
	s:argPageSize="" argPageSize=20
	s resultObj = ##class(%DynamicObject).%New()
	s json = ##Class(%GlobalBinaryStream).%New()
	s jsonArrUser = ##class(%DynamicArray).%New()
	if ((argUserCode'="") && (argUserName '="")){
		s result = ##class(%ResultSet).%New("EMR.DOC.BL.RBACUser:SelectRBACUsers")
		d result.Execute(argUserCode,argUserName)	
	}elseif((argUserCode="") && (argUserName ="")){
		s result = ##class(%ResultSet).%New("EMR.DOC.BL.RBACUser:SelectRBACUsersAll")
		d result.Execute()	
	}else{
		s result = ##class(%ResultSet).%New("EMR.DOC.BL.RBACUser:SelectRBACUsersNew")
		d result.Execute(argUserCode,argUserName)
	}
	
	q:(result = "") "-1" 
	s count = 0
	s startIndex = (argCurrent-1)*argPageSize+1
	s endIndex = startIndex+argPageSize-1
	While result.Next() 
	{
		s count = count+1
		continue:((count<startIndex)||(count>endIndex))
		s jsonUser  = ##class(%DynamicObject).%New()
	 	s jsonUser.id = result.GetDataByName("ID")
	 	s jsonUser.isAdmin = result.GetDataByName("IsAdmin")
		s jsonUser.roleId = result.GetDataByName("RoleID")
		s jsonUser.userCode = result.GetDataByName("UserCode")
		s jsonUser.userName = result.GetDataByName("UserName")
		
        d jsonArrUser.%Push(jsonUser)
	}
	s resultObj.list = jsonArrUser
	s resultObj.current = argCurrent
	s resultObj.pageSize = argPageSize
	s resultObj.total = count
	d resultObj.%ToJSON(argOutData)

	q strRes
}

/// d ##class(%ResultSet).RunQuery("EMR.DOC.BL.RBACUser","SelectRBACUsers","","")
/// desc 根据userCode或userName做模糊查找
Query SelectRBACUsers(aUserCode As %String = "", aUserName As %String = "") As %SQLQuery
{
	select a.ID,convert(varchar(50),a.RoleID) AS RoleID,a.UserCode,a.UserName,a.IsAdmin from CF_EMR_DOC.RBACUser as a WHERE a.UserCode like "%"_:aUserCode_"%" and a.UserName like "%"_:aUserName_"%"
}

/// d ##class(%ResultSet).RunQuery("EMR.DOC.BL.RBACUser","SelectRBACUsers","","")
/// desc 根据userCode或userName做模糊查找
Query SelectRBACUsersNew(aUserCode As %String = "", aUserName As %String = "") As %SQLQuery
{
	select a.ID,convert(varchar(50),a.RoleID) AS RoleID,a.UserCode,a.UserName,a.IsAdmin from CF_EMR_DOC.RBACUser as a WHERE a.UserCode like "%"_:aUserCode_"%" OR a.UserName like "%"_:aUserName_"%"
}

/// desc 获取全部用户
Query SelectRBACUsersAll() As %SQLQuery
{
	select a.ID,convert(varchar(50),a.RoleID) AS RoleID,a.UserCode,a.UserName,a.IsAdmin from CF_EMR_DOC.RBACUser as a
}

/// d ##class(%ResultSet).RunQuery("EMR.DOC.BL.RBACUser","test","")
/// desc 根据userCode或userName做模糊查找
Query test(aUserCode As %String = "") As %SQLQuery
{
	select a.ID,a.RoleID,a.UserCode,a.UserName,a.IsAdmin from CF_EMR_DOC.RBACUser as a WHERE a.UserCode like "'"_:aUserCode_"%'"
}

/// Desc:       新增用户
/// Creator:    yejian
/// CreateDate: 2021-03-08
/// OutPut:     返回数据 成功：1,
/// 					 失败:-1 用户不能为空, -2 无效的角色 -3 添加用户失败
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 				s strJson = "[{""UserCode"":""demo"",""UserName"":""DemoGroup""},{""UserCode"":""YS01"",""UserName"":""医生01""}]"
///   			set objJson = ##class(%DynamicAbstractObject).%FromJSON(strJson)
///             w ##class(EMR.DOC.BL.RBACUser).AddRBACUsersJson([],argOutData)
ClassMethod AddRBACUsersJson(arrUsers As %DynamicArray, ByRef argOutData As %GlobalBinaryStream)
{
	
	s strRes = "-1"
	q:((arrUsers = "")) strRes
	TSTART
	s strMark = "1"
	s intUserSize = arrUsers.%Size()
	for i=0:1:(intUserSize-1)
	{
		s jItem = arrUsers.%Get(i)
		s UserCode = jItem.userCode
		s UserName = jItem.userName
		s RoleID = jItem.roleId
		continue:((UserCode="")||(UserName="")||(RoleID=""))
		s userRowID = $o(^CF.EMR.DOC.RBACUserI("IdxUser"," "_$zcvt(UserCode,"U"),""))
		continue:(userRowID '= "") 
		s objUsers = ##class(CF.EMR.DOC.RBACUser).%New()
		s objUsers.UserCode = UserCode
		s objUsers.UserName = UserName
		s objUsers.IsAdmin = 0
		if (RoleID'=""){
			s roleObj = ##class(CF.EMR.DOC.RBACRole).%OpenId(RoleID)
			s strRes = "-2"
			s strMark = "-1"
			q:(roleObj="") 
			s strMark= "1"
			s objUsers.RoleID = roleObj
			s:(roleObj.RoleTypes.Code="1") objUsers.IsAdmin = "1"
		}
		s strRes= "-3"
		s sc = objUsers.%Save()
		if ('$$$ISOK(sc))
		{
			s strMark="-1"
			break
		}
	}
	if (strMark ="-1")
	{
		TROLLBACK
	}
	else
	{
		TCOMMIT
		s strRes = "1"
	}

	d argOutData.Write(strRes)
	q strRes
}

/// Desc:       更新角色
/// Creator:    yejian
/// CreateDate: 2021-03-08
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 			s dtoUser = ##Class(EMR.DOC.DTO.RBACUser).%New()
///             w ##class(EMR.DOC.BL.RBACUser).UpRBACUsersJson(dtoUser,argOutData)
ClassMethod UpRBACUsersJson(dtoUser As EMR.DOC.DTO.RBACUser, ByRef argOutData As %GlobalBinaryStream)
{
	q:(dtoUser.ID="") "-1"
	s objUser = ##class(CF.EMR.DOC.RBACUser).%OpenId(dtoUser.ID)
	q:(objUser="") "-2"
	if (dtoUser.RoleID'=""){
		s objRole = ##class(CF.EMR.DOC.RBACRole).%OpenId(dtoUser.RoleID)
		q:(objRole="") "-3"
		s objUser.RoleID = objRole
		s objUser.IsAdmin = "0"
		s:(objRole.RoleTypes.Code="1") objUser.IsAdmin ="1"
	}else{
		s objUser.RoleID = ""
		s objUser.IsAdmin = "0"
	}
	s sc = objUser.%Save()
	if ('$$$ISOK(sc))
	{
		q "-4"
	}
	q "1"
}

/// Desc:       删除用户
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      ATemplate 模板对象
/// output:     模板ID
/// Debug:      s strJson = "[""3"",""4""]"
///   			set objJson = ##class(%DynamicAbstractObject).%FromJSON(strJson)
/// 			w ##Class(EMR.DOC.BL.RBACUser).DelRBACUsersJson(objJson)
ClassMethod DelRBACUsersJson(arrIDs As %DynamicArray) As %String
{
	s strRes ="-1"
	q:(arrIDs.%Size()=0) strRes
	TSTART
	s strRes = "-2"
	s strMark = "1"
	s intIDSize = arrIDs.%Size()
	for i=0:1:(intIDSize-1)
	{
		s jItem = arrIDs.%Get(i)
		s strID = jItem
		s objUsers = ##class(CF.EMR.DOC.RBACUser).%OpenId(strID)
		if (objUsers="") 
		{
			s strMark="-1"
			q
		}
		s sc = objUsers.%DeleteId(strID)
		if ('$$$ISOK(sc))
		{
			s strMark="-1"
			q
		}
	}
	if (strMark ="-1")
	{
		TROLLBACK
	}
	else
	{
		TCOMMIT
		s strRes = "1"
	}
	q strRes
}

/// desc 根据UserCode 获取RBACUser中的用户对象
/// debug w ##Class(EMR.DOC.BL.RBACUser).getUserByUserCode("YS01")
ClassMethod getUserByUserCode(AUserCode As %String) As CF.EMR.DOC.RBACUser
{
	q:AUserCode="" ""
	s strRes = ##Class(CF.EMR.DOC.RBACUser).%New()
	s strRowID = $o(^CF.EMR.DOC.RBACUserI("IdxUser"," "_$zcvt(AUserCode,"U"),""))
	q:(strRowID="") strRes
	s objUser = ##Class(CF.EMR.DOC.RBACUser).%OpenId(strRowID)
	q objUser
}

}
