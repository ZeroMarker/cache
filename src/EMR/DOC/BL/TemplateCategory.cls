/// 名称:EMR.DOC.COM.TemplateCategory
/// 描述:通用文档管理模块 Document(Doc) 公用程序层 TemplateCategory 维护业务类
/// 编写者：Guozongtao@mediway.cn
/// 编写日期: 2020-07-08
/// 产品组：电子病历产品组
Class EMR.DOC.BL.TemplateCategory Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取文档管理目录树
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action": "GET_TEMPLATE_TREE","params": {"dataTypes": "TEMPLATE","userCode": "YS01"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTemplateTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s DataTypes="TEMPLATE"
	s type = argInJson.params.type
	s:type="" type="ALL"
 	s role =  argInJson.params.safeGroupId
 	s scene=	argInJson.params.scene			
    s strRes = ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateTreeJson(UserCode,DataTypes,type,role,scene,.argOutData)
	if (strRes = "1")
	{ 
	  q argOutMessage
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","该用户不存在，先维护用户到系统再访问",2)
	}
	elseif(strRes="-102")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","该用户未关联角色，无法访问",2)
	}
	elseif(strRes="-103")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","该用户无项目标识授权,请联系管理员维护再访问",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取文档管理操作数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"params":{"action":"GET_TEMPLATE_OPERATION","args":{"ParentCode":"Menu_Doc_Template","UserCode":"001"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTemplateOperation(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ParentCode = "Menu_Doc_Template"
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId

    s strRes = ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateOperationJson(ParentCode,UserCode,roleCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户不存在",2)
	}
	elseif(strRes="-102")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","用户没有关联角色，请先授权",2)	
	}
	elseif(strRes="-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","文档管理操作数据为空,检查数据源",2)	
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       添加文档目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"ADD_TEMPLATE_CATEGORY","params":{"title":"住院IP添加目录测试","description":"住院IP添加目录测试","parentId":"IP"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddTemplateCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.TemplateCategory).%New()

	//新建业务活动记录所需参数
	s argDTO.Name = argInJson.params.title
	s argDTO.Description = argInJson.params.description
	s argDTO.ParentID = ..GetIDByKey(argInJson.params.id)
	s argDTO.ParentType=..GetTypeByKey(argInJson.params.id)
	s argDTO.EMRName=argInJson.params.emrName
	s argDTO.StructType = argInJson.params.childType
	s argDTO.Alias = argInJson.params.alias
	s argDTO.BDMCategory = argInJson.params.BDMCategory
	s argDTO.Code = argInJson.params.code
	
	
	//同步新建标题所需参数
	s objDataFontStyle= ##class(%DynamicObject).%New()
	s objDataFontStyle.fontSize=argInJson.params.dateFontSize
	s objDataFontStyle.bold=argInJson.params.dateFontStyle
	s objDataFontStyle.fontFamily=argInJson.params.dateFontFamily
	s objDataFontStyle.color=argInJson.params.dateColor
	
	s objTitleFontStyle= ##class(%DynamicObject).%New()
	s objTitleFontStyle.fontSize=argInJson.params.titleFontSize
	s objTitleFontStyle.bold=argInJson.params.titleFontStyle
	s objTitleFontStyle.fontFamily=argInJson.params.titleFontFamily
	s objTitleFontStyle.color=argInJson.params.titleColor
	
	s objtitleConfig=##class(EMR.DOC.DTO.Titles).%New()
	s objtitleConfig.DateFontStyle=objDataFontStyle.%ToJSON()
	s objtitleConfig.DateReadonly=argInJson.params.dateReadonly
	s objtitleConfig.Datevisible=argInJson.params.dateVisible
	s objtitleConfig.DateAlign=argInJson.params.dateAlign
	s objtitleConfig.DefaultCreate=argInJson.params.defaultCreate
	s objtitleConfig.DoctorLevel=argInJson.params.doctorLevel
	s objtitleConfig.EventCode=argInJson.params.eventCode
	s objtitleConfig.IncludeDoctorLevel=argInJson.params.includeDoctorLevel
	s objtitleConfig.IncludeDoctorName=argInJson.params.includeDoctorName
	s objtitleConfig.IsLeadframe=argInJson.params.isLeadframe
	s objtitleConfig.IsMutex=argInJson.params.isMutex
	s objtitleConfig.LineBreak=argInJson.params.lineBreak
	s objtitleConfig.PageBreak=argInJson.params.pageBreak
	s objtitleConfig.PageBreakOdd=argInJson.params.pageBreakOdd
	s objtitleConfig.Serial=argInJson.params.serial
	s objtitleConfig.TitleAlign=argInJson.params.titleAlign
	s objtitleConfig.TitleBeforeDate=argInJson.params.titleBeforeDate
	s objtitleConfig.TitleFontStyle=objTitleFontStyle.%ToJSON()
	s objtitleConfig.DateFormat=argInJson.params.dateFormat
	s objtitleConfig.TitleReadonly=argInJson.params.titleReadonly
	s objtitleConfig.Titlevisible=argInJson.params.titleVisible
	s objtitleConfig.UniqueCreate=argInJson.params.uniqueCreate



	s userCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId

    s strRes = ##Class(EMR.DOC.BL.TemplateCategory).AddTemplateCategoryJson(argDTO,objtitleConfig,userCode,roleCode,.argOutData)
    if (strRes>0){
	    q argOutMessage
	}
		elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       更新文档目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"UP_TEMPLATE_CATEGORY","params":{"id":170,"name":"住院目录更新测试","description":"住院测试更新目录"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpTemplateCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.TemplateCategory).%New()
	s argDTO.ID = argInJson.params.id
	 
	 //更新目录参数
	s argDTO.Name = argInJson.params.title
	s argDTO.Description = argInJson.params.description
	s argDTO.Alias = argInJson.params.alias
	s argDTO.BDMCategory = argInJson.params.BDMCategory
	s argDTO.Code = argInJson.params.code
	s argDTO.EMRName=argInJson.params.emrName
	//更新标题参数
	s objDataFontStyle= ##class(%DynamicObject).%New()
	s objDataFontStyle.fontSize=argInJson.params.dateFontSize
	s objDataFontStyle.bold=argInJson.params.dateFontStyle
	s objDataFontStyle.fontFamily=argInJson.params.dateFontFamily
	s objDataFontStyle.color=argInJson.params.dateColor
	
	s objTitleFontStyle= ##class(%DynamicObject).%New()
	s objTitleFontStyle.fontSize=argInJson.params.titleFontSize
	s objTitleFontStyle.bold=argInJson.params.titleFontStyle
	s objTitleFontStyle.fontFamily=argInJson.params.titleFontFamily
	s objTitleFontStyle.color=argInJson.params.titleColor
	
	s objtitleConfig=##class(EMR.DOC.DTO.Titles).%New()
	s objtitleConfig.DateFontStyle=objDataFontStyle.%ToJSON()
	s objtitleConfig.DateReadonly=argInJson.params.dateReadonly
	s objtitleConfig.Datevisible=argInJson.params.dateVisible
	s objtitleConfig.DateAlign=argInJson.params.dateAlign
	s objtitleConfig.DefaultCreate=argInJson.params.defaultCreate
	s objtitleConfig.DoctorLevel=argInJson.params.doctorLevel
	s objtitleConfig.EventCode=argInJson.params.eventCode
	s objtitleConfig.IncludeDoctorLevel=argInJson.params.includeDoctorLevel
	s objtitleConfig.IncludeDoctorName=argInJson.params.includeDoctorName
	s objtitleConfig.IsLeadframe=argInJson.params.isLeadframe
	s objtitleConfig.IsMutex=argInJson.params.isMutex
	s objtitleConfig.LineBreak=argInJson.params.lineBreak
	s objtitleConfig.PageBreak=argInJson.params.pageBreak
	s objtitleConfig.PageBreakOdd=argInJson.params.pageBreakOdd
	s objtitleConfig.Serial=argInJson.params.serial
	s objtitleConfig.TitleAlign=argInJson.params.titleAlign
	s objtitleConfig.TitleBeforeDate=argInJson.params.titleBeforeDate
	s objtitleConfig.TitleFontStyle=objTitleFontStyle.%ToJSON()
	s objtitleConfig.DateFormat=argInJson.params.dateFormat
	s objtitleConfig.TitleReadonly=argInJson.params.titleReadonly
	s objtitleConfig.Titlevisible=argInJson.params.titleVisible
	s objtitleConfig.UniqueCreate=argInJson.params.uniqueCreate

	
    s strRes = ##Class(EMR.DOC.BL.TemplateCategory).UpTemplateCategoryJson(argDTO,objtitleConfig)
    if (strRes = "1")
    {
	    q argOutMessage.success=..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误","2")	
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除文档目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"DEL_TEMPLATE_CATEGORY","params":{"id":173},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DelTemplateCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s strID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.TemplateCategory).DelTemplateCategoryJson(strID)
    if (strRes = "1"){
	   q argOutMessage
	}
	elseif (strRes = "-201")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","目录ID必传，检查参数",2)
	}
	elseif(strRes = "-101")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","目录节点下方有子节点，不允许删除",2)
	}
	elseif(strRes = "-301")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","目录数据不存在，检查参数",2)
	}
	else{
		q ..SetOutMessage(argOutMessage,"ERROR","删除节点失败",2)	
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取模板树结构
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserCode用户编码
/// Input:      DataTypes  授权数据类型
/// OutPut:     -101 用户不存在  -102 用户未维护角色 -103 角色没有项目标识授权
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.TemplateCategory).GetTemplateTreeJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetTemplateTreeJson(argUserCode As %String, argDataTypes As %String, argType As %String, ARole As %String, scene As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s jsonArr = ##class(%DynamicArray).%New()
	s RoleID =##Class(EMR.DOC.BL.RBACRole).GetRoleByCode(ARole)
	q:(RoleID["-1^") "-102" 
	if (scene="permission")
	{
		s productArray =  ##Class(EMR.DOC.BL.RBACRoleProduct).GetProductArrayByRoleCode("SuperAdmin")
		q:(productArray.%Size()=0) "-103"
	}
	else
	{
		s productArray =  ##Class(EMR.DOC.BL.RBACRoleProduct).GetProductArrayByRoleCode(ARole)
		q:(productArray.%Size()=0) "-103"
	}
	s strRes = "1"
	s rootID=""
	&sql(select ID into :rootID from CF_EMR_DOC.TemplateCTypes where Code = "Root")
	q:(rootID="") strRes
	set iter = productArray.%GetIterator()
	while iter.%GetNext(.key , .objProduct ) {
		s ProductID = objProduct.%Id()
		// 获取根节点 structType为Root product为ProductID的节点
	    s jsonRoot  = ##class(%DynamicObject).%New()
	    s cateID=""
	    &sql(select ID into :cateID from CF_EMR_DOC.TemplateCategory where Product = :ProductID and StructType = :rootID)
	    continue:(cateID="")
	    s objRoot=##class(CF.EMR.DOC.TemplateCategory).%OpenId(cateID)
        s jsonRoot.key =cateID_"||RT"
        s jsonRoot.title =objRoot.Name
        s jsonRoot.description=objRoot.Description
        s jsonRoot.emrName=objRoot.EMRName
   		s jsonRoot.type = "RT"
   		s jsonRoot.code=objRoot.Code
   		s jsonRoot.product=objRoot.Product.ProductCode
		s DataTypes = $zcvt(argDataTypes,"U")
		//判断节点授权状态
	    s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(ProductID,RoleID,DataTypes,"RT",cateID)
		S jsonRoot.permission=Permission
		//判断节点勾选状态
		s checkStatus=##class(EMR.DOC.BL.RBACDataPermission).GetEditViewType(ProductID,RoleID,DataTypes,"RT",cateID)
		s jsonRoot.checked=checkStatus

		s jsonCategory = ##class(%DynamicArray).%New()
		d ##Class(EMR.DOC.BL.TemplateCategory).GetJsonCategroyByID(cateID,ProductID,RoleID,DataTypes,argType,.jsonCategory)
		s jsonRoot.children = jsonCategory

		d jsonArr.%Push(jsonRoot)
	}
	d jsonArr.%ToJSON(argOutData)

	q strRes
}

/// Desc:       递归获取模板目录数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             aRoleID 角色ID
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.TemplateCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(aParentId As %String, aProductID As %String, aRoleID As %String, DataTypes As %String, Type As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowTemCID = "",sequence=""
	for {
		s sequence = $o(^CF.EMR.DOC.TemplateCategoryI("IdxProParentIdSeq",aProductID," "_aParentId,sequence))
		q:(sequence = "")		
		for
		{
		s rowTemCID= $o(^CF.EMR.DOC.TemplateCategoryI("IdxProParentIdSeq",aProductID," "_aParentId,sequence,rowTemCID))
		q:(rowTemCID="")
		s objTemCat = ##Class(CF.EMR.DOC.TemplateCategory).%OpenId(rowTemCID)
	    continue:(objTemCat="")
	    s jsonTemCat  = ##class(%DynamicObject).%New()
	    s productObj = ##class(CT.EMR.DOC.Products).%OpenId(aProductID)
	    s objType=##class(CF.EMR.DOC.TemplateCTypes).%OpenId(objTemCat.StructType.%Id())
	    s strType=""
	    if (objType.Code="Classification")
	    {
		    s strType="CT"
		}
		elseif (objType.Code="Record")
		{
			s strType="LF"
			s jsonTemCat.titleId=objTemCat.Title.%Id()
		}
	    elseif (objType.Code="Category")
		{
			s strType="CG"
		}
	    s jsonTemCat.key = rowTemCID_"||"_strType
	    s jsonTemCat.title = objTemCat.Name
	    ;
	    
	   
	    if (objType.Code="Record")
	    {
		    s jsonTemCat.isMutex=objTemCat.Title.IsMutex
			s jsonTemCat.alias=objTemCat.Alias
			s jsonTemCat.pageBreak=objTemCat.Title.PageBreak
			s jsonTemCat.pageBreakOdd=objTemCat.Title.PageBreakOdd
			s jsonTemCat.uniqueCreate=objTemCat.Title.UniqueCreate
			s jsonTemCat.defaultCreate=objTemCat.Title.DefaultCreate
			s jsonTemCat.lineBreak=objTemCat.Title.LineBreak
			s jsonTemCat.titleBeforeDate=objTemCat.Title.TitleBeforeDate
			s jsonTemCat.isLeadframe=objTemCat.Title.IsLeadframe
			s jsonTemCat.eventCode=objTemCat.Title.EventCode
			s jsonTemCat.serial=objTemCat.Title.Serial
		}
		s bdmcat= $CASE(objTemCat.BDMCategory,"":"",:objTemCat.BDMCategory.%Id())
		;s bdmtype=""
		
		if (objTemCat.BDMCategory="")
			{s bdmtype=""}
		else{
			if (objTemCat.BDMCategory.StructType.%Id()=1)
				{ s bdmtype="CG"}
			elseif (objTemCat.BDMCategory.StructType.%Id()=2)
				{s bdmtype="DT"}
			elseif (objTemCat.BDMCategory.StructType.%Id()=3)
				{s bdmtype="ST"}
			elseif (objTemCat.BDMCategory.StructType.%Id()=4)
				{s bdmtype="RT"}
			}
		if ((bdmcat'="")||(bdmtype'=""))
		{s jsonTemCat.BDMCategory=bdmcat_"||"_bdmtype}
	    
	    
	    s jsonTemCat.emrName=objTemCat.EMRName
	    s jsonTemCat.code=objTemCat.Code
	    s jsonTemCat.type = strType
	    s jsonTemCat.description = objTemCat.Description
	    s jsonTemCat.product=objTemCat.Product.ProductCode
	    //判断是否有授权数据
	    s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(aProductID,aRoleID,DataTypes,strType,rowTemCID)
		;continue:(Permission<="0")
		s jsonTemCat.permission = Permission
		
		//判断节点勾选状态
		s checkStatus=##class(EMR.DOC.BL.RBACDataPermission).GetEditViewType(aProductID,aRoleID,DataTypes,strType,rowTemCID)
		s jsonTemCat.checked=checkStatus
		;s jsonTemCat.isLeaf = "true"
		;s:(objTemCat.ResChildCount>0) jsonTemCat.isLeaf = "false"
	    s jsonTemCat.sequence = objTemCat.Sequence
	    
		s jsonCateNew = ##class(%DynamicArray).%New()
		//如果子节点为模板则ResChildCount不为0
		if (objTemCat.ResChildCount=0)
		{
			s result = ##Class(EMR.DOC.BL.TemplateCategory).GetJsonCategroyByID(rowTemCID,aProductID,aRoleID,DataTypes,Type,.jsonCateNew)
		}
		else
		{	
			//根据目录获取模板数据
			s result=##class(EMR.DOC.BL.Template).GetJsonTempalteByCID(rowTemCID,aProductID,aRoleID,DataTypes,Type,.jsonCateNew)
		}
		
		s:(jsonCateNew.%Size()>0) jsonTemCat.children = jsonCateNew
		d jsonCategory.%Push(jsonTemCat)	
		}
		
	}
	q res
}

/// Desc:      添加根节点目录
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"ADD_KB_MANAGE","params":{"id": "12||CG","childType":"CG","name":"","description":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddRootCategoryJson(product As %String, name As %String, desc As %String)
{
	s objCate=##class(CF.EMR.DOC.TemplateCategory).%New()
	s objCate.Description=desc
	s objCate.Name=name
	s objProcudt=##class(CT.EMR.DOC.Products).%OpenId(product)
	s objCate.Product=objProcudt
	s rootID=""
	&sql(select ID into :rootID from CF_EMR_DOC.TemplateCTypes where Code = "Root")
	s objType=##class(CF.EMR.DOC.TemplateCTypes).%OpenId(rootID)
	s objCate.StructType=objType
	s objCate.ParentID=0
	s sc=objCate.%Save()
}

/// Desc:       获取模板操作
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      ParentCode  功能字典目录编码
/// 			UserCode	用户编码
/// OutPut:     -101 用户不存在  -102 用户未维护角色 
///             -301 文档管理操作数据为空
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.TemplateCategory).GetTemplateOperationJson("Menu_Doc","YS01",.argOutData)
ClassMethod GetTemplateOperationJson(ParentCode As %String, UserCode As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
#;	s objUser = ##Class(EMR.DOC.BL.RBACUser).getUserByUserCode(UserCode)
#;	q:(objUser="") "-101"
#;	q:(objUser.RoleID="") "-102"
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-102"

	s strRoleID = RoleID
	s jsonObj  = ##class(%DynamicObject).%New()
 	s strRPRowID = ""
 	s strRes = "-301"

	//添加右键授权数据
	s jsonFuncMenuNode = ##class(%DynamicObject).%New()
	//添加按钮授权数据
	s arrayFuncBtn = ##class(%DynamicArray).%New()
	s rowFunID = ""
	for {
		s rowFunID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(ParentCode,"U"),rowFunID))
		q:(rowFunID = "") 			
		s objFun = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowFunID)
        continue:(objFun="")
        s strRes = "1"
	    if (objFun.Type.Code="funcMenuNode")
	    {
			s permission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFunID)
			//添加功能菜单授权数据
			s jsonFuncMenu = ##class(%DynamicArray).%New()
			s rowFunMenuID = ""
			for {
				s rowFunMenuID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(objFun.FuncCode,"U"),rowFunMenuID))
				q:(rowFunMenuID = "")				
				s objFunMenu = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowFunMenuID)
				continue:objFunMenu=""
				s jsonMenu  = ##class(%DynamicObject).%New()
				s jsonMenu.code = objFunMenu.FuncCode
				s jsonMenu.name =objFunMenu.FuncName
				s menuPermission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFunMenuID)
				continue:(menuPermission'=2)
				d jsonFuncMenu.%Push(jsonMenu)
			}
		    s:(objFun.FuncCode="menu_template_root") jsonFuncMenuNode.root=jsonFuncMenu
		    s:(objFun.FuncCode="menu_template_category") jsonFuncMenuNode.category=jsonFuncMenu
		    s:(objFun.FuncCode="menu_template_docment") jsonFuncMenuNode.document=jsonFuncMenu
		    s:(objFun.FuncCode="menu_template_record") jsonFuncMenuNode.record=jsonFuncMenu
		    s:(objFun.FuncCode="menu_template_loctemplate") jsonFuncMenuNode.loctemplate=jsonFuncMenu
		    s:(objFun.FuncCode="menu_template_loccategory") jsonFuncMenuNode.loccategory=jsonFuncMenu
		    s:(objFun.FuncCode="menu_template_classification") jsonFuncMenuNode.classification=jsonFuncMenu
		    s:(objFun.FuncCode="menu_template_version") jsonFuncMenuNode.version=jsonFuncMenu
	     }
	     elseif(objFun.Type.Code="funcBtnType")
	     {
		   
			//添加功能菜单授权数据
			s rowFunMenuID = ""
			for {
				s rowFunMenuID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(objFun.FuncCode,"U"),rowFunMenuID))
				q:(rowFunMenuID = "")				
				s objFunMenu = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowFunMenuID)
				continue:objFunMenu=""
				s jsonMenu  = ##class(%DynamicObject).%New()
				s jsonMenu.code = objFunMenu.FuncCode
				s jsonMenu.name =objFunMenu.FuncName
				s menuPermission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFunMenuID)
				continue:(menuPermission'=2)
				d arrayFuncBtn.%Push(jsonMenu)
			}
		
	    }
	}
    
    s jsonObj.tree =jsonFuncMenuNode
    s jsonObj.btn =arrayFuncBtn
	d jsonObj.%ToJSON(argOutData)

	q strRes
}

/// Creator：      Guozongtao@mediway.cn
/// CreatDate：    2020-07-08
/// Description:   TemplateCategory 增加
/// Table：        CF_EMR_DOC.TemplateCategory
/// Input：        
/// Output         -200 必填参数未填(parentID,name)
///                -301 父目录ID对象不存在  -302 项目标识不存在
/// 			   -101 添加目录数据失败 -102 设置权限失败
/// 					
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.COM.TemplateCategory).Add()
ClassMethod AddTemplateCategoryJson(argDTO As EMR.DOC.DTO.TemplateCategory, argTitleDTO As EMR.DOC.BL.Titles, argUserCode As %String = "", roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:argDTO.ParentID="" "-1^父节点不能为空"
	q:argDTO.Name="" "-1^名称不能为空"
	q:argDTO.StructType="" "-1^结构类型不能为空"
	q:argDTO.EMRName="" "-1^业务名称不能为空"
	s strRes = "",titleId=""
	TSTART
	//添加标题
	s objconfig= ##class(CF.EMR.DOC.Titles).%New()
	s objconfig.DateAlign=argTitleDTO.DateAlign
	s objconfig.DateFontStyle=argTitleDTO.DateFontStyle
	s objconfig.DateReadonly=argTitleDTO.DateReadonly
	s objconfig.Datevisible=argTitleDTO.Datevisible
	s objconfig.DefaultCreate=argTitleDTO.DefaultCreate
	s objconfig.DoctorLevel=argTitleDTO.DoctorLevel
	s objconfig.EventCode=argTitleDTO.EventCode
	s objconfig.IncludeDoctorLevel=argTitleDTO.IncludeDoctorLevel
	s objconfig.IncludeDoctorName=argTitleDTO.IncludeDoctorName
	s objconfig.IsLeadframe=argTitleDTO.IsLeadframe
	s objconfig.IsMutex=argTitleDTO.IsMutex
	s objconfig.LineBreak=argTitleDTO.LineBreak
	s objconfig.PageBreak=argTitleDTO.PageBreak
	s objconfig.PageBreakOdd=argTitleDTO.PageBreakOdd
	s objconfig.Serial=argTitleDTO.Serial
	s objconfig.TitleAlign=argTitleDTO.TitleAlign
	s objconfig.TitleBeforeDate=argTitleDTO.TitleBeforeDate
	s objconfig.TitleFontStyle=argTitleDTO.TitleFontStyle
	s objconfig.DateFormat=argTitleDTO.DateFormat
	s objconfig.TitleReadonly=argTitleDTO.TitleReadonly
	s objconfig.Titlevisible=argTitleDTO.Titlevisible
	s objconfig.UniqueCreate=argTitleDTO.UniqueCreate
	
	s sc=objconfig.%Save()
	if ($$$ISOK(sc))
	{
		s strRes="1"
		s titleId=objconfig.%Id()
	}
	else
	{
		TROLLBACK
	}
	//添加目录
	s obj = ##class(CF.EMR.DOC.TemplateCategory).%New()
	
	s structType="Category"
	
	if (argDTO.StructType="CT")
	{
		q:argDTO.Code="" "-1^Code不能为空"
		s structType="Classification"
	}
	elseif (argDTO.StructType="LF")
	{
		q:argDTO.Code="" "-1^Code不能为空"
		s structType="Record"
		s obj.Alias=argDTO.Alias
		s obj.BDMCategory = ##class(CF.EMR.DOC.BDMCategory).%OpenId(..GetIDByKey(argDTO.BDMCategory ))
	}
	
	s flag=""
	&sql(SELECT ID into :flag FROM CF_EMR_DOC.TemplateCategory WHERE Code=:argDTO.Code)
	q:flag'="" "-1^Code值重复"
	
	s obj.Code=argDTO.Code
	
	s TemplateTypeID = $o(^CF.EMR.DOC.TemplateCTypesI("IdxCode"," "_$zcvt(structType,"U"),""))
	s objTemplateType=##class(CF.EMR.DOC.TemplateCTypes).%OpenId(TemplateTypeID)
	q:(objTemplateType="")

	//在父目录下添加子目录
	s objParent = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(argDTO.ParentID)
	q:(objParent="") "-1^父目录对象为空,检查参数是否正确"
	s obj.Product = objParent.Product
	s ProductID = objParent.Product.%Id()
	s obj.ParentID = +(argDTO.ParentID)
		
	
	s obj.EMRName=argDTO.EMRName
	s obj.Name = argDTO.Name
	s obj.StructType=objTemplateType
	s obj.Description = argDTO.Description
	s obj.Title=##class(CF.EMR.DOC.Titles).%OpenId(titleId)
	s obj.ResChildCount = 0
	
	
	s sc = obj.%Save()
	s outObj=##class(%DynamicObject).%New()
	if ($$$ISOK(sc))
	{
		s Sequence=obj.%Id()
		s obj.Sequence=Sequence
		s outObj.id=Sequence
		d obj.%Save()
		//添加文档目录成功 设置目录权限为可编辑
	
		s RoleID = ##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
		if (RoleID="")
		{
			s strRes = "-1^设置权限失败"
			q strRes		
		}
		s isOk = ##class(EMR.DOC.BL.RBACDataPermission).AddPermissionData(RoleID,obj.%Id(),"TEMPLATE",argDTO.StructType,obj.Name,ProductID)
		if (isOk'="1"){
			TROLLBACK
			s strRes = "-1^设置权限失败"
			q strRes	
		}
		
		// 新增病历导航节点
		
		if (objTemplateType.Code="Classification")
		{
			s SchemeID = ""
			for {
				s SchemeID = $o(^CF.EMR.DOC.EMRTSchemeD(SchemeID))
				q:(SchemeID = "")			
				s objScheme = ##Class(CF.EMR.DOC.EMRTScheme).%OpenId(SchemeID)
        		continue:(objScheme="")
        		s argDTOItem=##class(EMR.DOC.DTO.EMRTSchemeItem).%New()
        		s argDTOItem.EMRTScheme=objScheme.%Id()
        		s maxID=""
        		&sql(select max(ID) into:maxID from CF_EMR_DOC.TemplateCategory)
				s argDTOItem.DataID=maxID
				s argDTOItem.DataType="Classification"
        		s res=##class(EMR.DOC.BL.EMRTSchemeItem).AddSchemeItemJson(argDTOItem)
        		if (res'="1")
        		{
	        		
					s strRes = "-1^病历导航新增失败"
	        	}
	}
		}
		
	}
	else
	{
		TROLLBACK
		 s strRes= "-101"
	}
	d outObj.%ToJSON(argOutData)
	TCOMMIT
	q strRes
}

/// Desc:       更新文档目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argDTO  文档目录对象
/// OutPut:     成功：1,
/// 				失败：-200 必填项为空（目录ID，目录名称）  -201 目录对象为空
/// 					  -100 更新操作失败
/// Debug:      w ##Class(EMR.DOC.COM.TemplateCategory).Add()
ClassMethod UpTemplateCategoryJson(argDTO As EMR.DOC.DTO.TemplateCategory, objCon As EMR.DOC.DTO.Titles) As %String
{
	s strRes=""
	q:((argDTO="")||(argDTO.ID="")||(argDTO.Name="")||(argDTO.EMRName="")) "-1^请检验必传项(ID,Name,EMRname等)"
	s id=..GetIDByKey(argDTO.ID)
	s type=..GetTypeByKey(argDTO.ID)
	TSTART
	s obj = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(id)
	q:(obj="") "-1^目录对象为空，检擦id参数值是否正确"
	if ((type="LF")||(type="CT"))&&(argDTO.Code="")
	{
		q "-1^非根节点需传Code"
	}
	else
	{
		s flag=""
		&sql(SELECT ID into :flag FROM CF_EMR_DOC.TemplateCategory WHERE Code=:argDTO.Code and id!=:id)
		q:flag'="" "-1^Code值重复"
		s obj.Name = argDTO.Name 
		s obj.Description = argDTO.Description 
		s obj.Alias = argDTO.Alias  
		s bdmkey=..GetIDByKey(argDTO.BDMCategory )
		s obj.BDMCategory = ##class(CF.EMR.DOC.BDMCategory).%OpenId(bdmkey)
		s obj.Code = argDTO.Code 
		s obj.EMRName = argDTO.EMRName
	}

	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		if (type="LF")
		{
			s objconfig=obj.Title
			s objconfig.DateAlign=objCon.DateAlign
			s objconfig.DateFontStyle=objCon.DateFontStyle
			s objconfig.DateReadonly=objCon.DateReadonly
			s objconfig.Datevisible=objCon.Datevisible
			s objconfig.DefaultCreate=objCon.DefaultCreate
			s objconfig.DoctorLevel=objCon.DoctorLevel
			s objconfig.EventCode=objCon.EventCode
			s objconfig.IncludeDoctorLevel=objCon.IncludeDoctorLevel
			s objconfig.IncludeDoctorName=objCon.IncludeDoctorName
			s objconfig.IsLeadframe=objCon.IsLeadframe
			s objconfig.IsMutex=objCon.IsMutex
			s objconfig.LineBreak=objCon.LineBreak
			s objconfig.PageBreak=objCon.PageBreak
			s objconfig.PageBreakOdd=objCon.PageBreakOdd
			s objconfig.Serial=objCon.Serial
			s objconfig.TitleAlign=objCon.TitleAlign
			s objconfig.TitleBeforeDate=objCon.TitleBeforeDate
			s objconfig.TitleFontStyle=objCon.TitleFontStyle
			s objconfig.DateFormat=objCon.DateFormat
			s objconfig.TitleReadonly=objCon.TitleReadonly
			s objconfig.Titlevisible=objCon.Titlevisible
			s objconfig.UniqueCreate=objCon.UniqueCreate
			s se=objconfig.%Save()
			if ($$$ISOK(se))
			{
				s strRes="1"
			}
			else
			{
				TROLLBACK
				s strRes= "-1^保存失败"
			}
		}
		s strRes= "1"
	}
	else
	{
		TROLLBACK
		 s strRes= "-1^保存失败"
	}
	TCOMMIT
	q strRes
}

/// Desc:       删除文档目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argCategoryID  文档目录ID
/// OutPut:     返回数据 成功：1,
/// 						 失败：-101 文档下有子节点  不允许删除
/// 							   -201  目录ID未传   -301 目录对象不存在  
/// Debug:      w ##Class(EMR.DOC.COM.TemplateCategory).DelTemplateCategory("1")
ClassMethod DelTemplateCategoryJson(argCategoryID As %String) As %String
{
	q:(argCategoryID="") "-201"
	if (##class(CF.EMR.DOC.TemplateCategory).%ExistsId(argCategoryID))	
	{
		s strNodesCount = 0
		&sql(SELECT count(*) into:strNodesCount  FROM CF_EMR_DOC.TemplateCategory c ,CF_EMR_DOC.Template t WHERE c.ParentID = :argCategoryID OR t.TemplateCategory =:argCategoryID)
		q:(strNodesCount'=0) "-101"
		s Objtitle=##class(CF.EMR.DOC.TemplateCategory).%OpenId(argCategoryID)
		if (Objtitle'="")
		{s titleId=Objtitle.%Id()
			d ##class(CF.EMR.DOC.Titles).%DeleteId(titleId)
		}
		d ##class(CF.EMR.DOC.TemplateCategory).%DeleteId(argCategoryID)
		
		// 删除病历导航目录
		s rowItemID = ""
		for {
			
			s rowItemID = $o(^CF.EMR.DOC.EMRTSchemeItemI("IdxDataID"," "_$zcvt(argCategoryID,"u"),rowItemID))
			q:(rowItemID = "") 			
		 	d ##class(EMR.DOC.BL.EMRTSchemeItem).DeleteSchemeItemJson(rowItemID)
		 }
		
		q "1"
	}
	else	  
	{ 
		q "-301"
	}
}

/// Desc:       获取业务活动记录类型文档目录
/// Creator:    yejian
/// CreateDate: 2022-4-19
/// Input:      objCategory 模板目录对象
/// Output:    成功 目录ID，失败 "-1"
/// Debug:	q ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateRecord()
ClassMethod GetTemplateRecord(objCategory As CF.EMR.DOC.TemplateCategory) As %String
{
	s res = "-1"
	q:(objCategory="") res
	q:(objCategory.StructType.Code ="Record") objCategory.%Id()
	if (objCategory.ParentID'="")
	{
		s objPCategory = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(objCategory.ParentID)
		s res= ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateRecord(objPCategory)
	}
	q res
}

/// Desc:       获取标题信息
/// Creator:    yejian
/// CreateDate: 2022-4-19
/// Input:      aInstanceID 实例ID
///             aTemplateID 模板ID
/// Output:    成功 %DynamicObject，失败 ""
/// 	Debug:	q ##Class(EMR.DOC.BL.TemplateCategory).GetTitleDatas(1,1||1)
ClassMethod GetTitleDatas(aTemplateID As %String, dtoInData As EMR.DOC.DTO.DocumentData) As %DynamicObject
{
	s resJson = ##class(%DynamicObject).%New()
	q:(aTemplateID="") resJson
	s objTemplate = ##class(CF.EMR.DOC.Template).%OpenId(aTemplateID)
	q:(objTemplate="") resJson
	s strTemCId = ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateRecord(objTemplate.TemplateCategory)
	q:(strTemCId="-1") resJson
 	s objTemCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strTemCId)
 	s resJson.id = dtoInData.ID
 	s resJson.titleCode = objTemCat.Code
	s resJson.pageBreak=$case(objTemCat.Title.PageBreak,"":0,:objTemCat.Title.PageBreak)
	s resJson.pageBreakOdd=$case(objTemCat.Title.PageBreakOdd,"":0,:objTemCat.Title.PageBreakOdd)
	s resJson.lineBreak=$case(objTemCat.Title.LineBreak,"":0,:objTemCat.Title.LineBreak)
	s resJson.beforeDate =$case(objTemCat.Title.TitleBeforeDate,"":0,:objTemCat.Title.TitleBeforeDate)
	s resJson.eventID=dtoInData.EventID
	s resJson.eventType=dtoInData.EventType
	s isShowTitle = 0,isShowTime = 0
	s resTitle={"fontSize":"","bold":0,"fontFamily":"","color":"","textAlign":"","value":"","doctor":"","showDoctor":0,"doctorLevel":"","showDoctorLevel":0}
	s resTime={"fontSize":"","bold":"","fontFamily":"","color":"","textAlign":"","format":"","value":""}
	s resTitle.value = $zcvt(objTemCat.EMRName,"O","UTF8")
	s dtoInData.HappenDate =$case(dtoInData.HappenDate,"":$ZDH($ZD($h)),:dtoInData.HappenDate)
 	s dtoInData.HappenTime =$case(dtoInData.HappenTime,"":$ZTH($ZT($P($h,",",2),1)),:dtoInData.HappenTime) 
	s HappenDateTime = dtoInData.HappenDate_","_dtoInData.HappenTime
    s timeStamp = ##class(EMR.DOC.COM.DateTimeFormat).GetTimeStamp(HappenDateTime,"ms")
    d resTime.%Set("value",timeStamp,"string")
    
    s objDateFontStype = ##class(%DynamicAbstractObject).%FromJSON(objTemCat.Title.DateFontStyle)
	s objTitleFontStyle= ##class(%DynamicAbstractObject).%FromJSON(objTemCat.Title.TitleFontStyle)

	;s resTitle = ##class(%DynamicObject).%New()
    s:(objTemCat.Title.Titlevisible'="") isShowTitle = objTemCat.Title.Titlevisible
    s resTitle.fontSize = objTitleFontStyle.%Get("font-size")
    s resTitle.bold = $case(objTitleFontStyle.%Get("font-weight"),"bold":1,:0)
    s resTitle.fontFamily = objTitleFontStyle.%Get("font-family")
    s resTitle.color = objTitleFontStyle.%Get("color")
    s resTitle.textAlign = objTemCat.Title.TitleAlign
    ;s resTitle.value = $zcvt(objTemCat.EMRName,"O","UTF8")
    ;s strFormat = objTitleCol.Format
    s resTitle.doctor = $zcvt(dtoInData.DoctorName,"O","UTF8")
    s resTitle.doctorID = dtoInData.DoctorID
    s resTitle.showDoctor = objTemCat.Title.IncludeDoctorName
    s resTitle.doctorLevel = $zcvt(dtoInData.DoctorLevel,"O","UTF8")
    s resTitle.doctorLevelCode = dtoInData.DoctorLevelCode
    s resTitle.showDoctorLevel = objTemCat.Title.IncludeDoctorLevel
    
	;s resTime = ##class(%DynamicObject).%New()
	s:(objTemCat.Title.Datevisible'="") isShowTime = objTemCat.Title.Datevisible
    s resTime.fontSize = objDateFontStype.%Get("font-size")
    s resTime.bold = $case(objDateFontStype.%Get("font-weight"),"bold":1,:0)
    s resTime.fontFamily = objDateFontStype.%Get("font-family")
    s resTime.color = objDateFontStype.%Get("color")
    s resTime.textAlign = objTemCat.Title.DateAlign
    s resTime.format = $zcvt(objTemCat.Title.DateFormat,"O","UTF8")
		    
	s resJson.showTitle=objTemCat.Title.Titlevisible
	s resJson.showDate = objTemCat.Title.Datevisible
	s resJson.name=resTitle
	s resJson.time=resTime
	q resJson
}

/// w ##Class(EMR.DOC.COM.TemplateCategory).Test()
ClassMethod Test() As %String
{
	s ReturnValue = ""
	
	s objDTO  = ##class(EMR.DOC.DTO.TemplateCategory).%New()
	
	s objDTO.Code = "EMR090001"
	s objDTO.Name = "入院记录"
	s objDTO.Description = " 入院记录"
	s objDTO.ParentID = 0
	s objDTO.ResChildCount = 1
	
	s ReturnValue =  ..AddTemplateCategory(objDTO)
	
	q ReturnValue
}

}
