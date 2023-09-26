/// 名称:	EMR.DOC.BL.RBACDataPermission
/// 描述:	通用文档管理模块 Document(Doc) 数据授权逻辑类
/// 编写者:	yejian
/// 编写日期: 	2020-12-14
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.RBACDataPermission Extends EMR.DOC.COM.ActionBase
{

/// 数据的默认权限(1/只读,2/可编辑)
Parameter defPermission = 1;

/// Desc:       获取数据授权
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aProduct 项目标识
///             aRoleID 角色ID
///             DataTypes 授权数据类型
///             NodeType 数据节点类型
///             aDataID 数据ID
/// OutPut:     Permission 	返回数据授权（1：只读/0：隐藏/2：可操作）
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(1,1,"TEMPLATE","LF",1)
ClassMethod GetDataPermission(aProductID As %String, aRoleID As %String, DataTypes As %String, NodeType As %String, aDataID As %String) As %String
{
	//判断是否有授权数据
	s Permission = "1"
	q:(aRoleID="") "0"
	s objRole = ##class(CF.EMR.DOC.RBACRole).%OpenId(aRoleID)
	q:(objRole="") Permission
	q:(objRole.RoleCode="SuperAdmin") "2"
	s rbacDataTID = $o(^CF.EMR.DOC.RBACDataTypesI("IdxCode"," "_$zcvt(DataTypes,"U"),""))
	q:(rbacDataTID="") Permission
	s count = 0
	&SQL(select count(*) into :count from CF_EMR_DOC.RBACDataPermission where RoleID = :aRoleID and DataTypes = :rbacDataTID)
	q:(count=0) Permission
	s dataRowID = $o(^CF.EMR.DOC.RBACDataPermissionI("IdxRoleTypeDataID",aProductID,aRoleID,rbacDataTID," "_$zcvt(NodeType,"U")," "_aDataID,""))
	if (dataRowID '= "")
	{
		s objData = ##Class(CF.EMR.DOC.RBACDataPermission).%OpenId(dataRowID)
		q:(objData="") Permission
		s Permission = objData.DataPerTypes.Code
	}
	q Permission
}

/// Desc:       获取节点勾选状态
/// Creator:    huhao
/// CreateDate: 2023/2/17
/// Input:      aProduct 项目标识
///             aRoleID 角色ID
///             DataTypes 授权数据类型
///             NodeType 数据节点类型
///             aDataID 数据ID
/// OutPut:     res 	返回节点选中状态（1：只读/0：隐藏/2：可操作）
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.BL.RBACDataPermission)GetEditViewType(1,1," TEMPLATE"," RT",101)
ClassMethod GetEditViewType(ProductId As %String, RoleId As %String, DataTypes As %String, NodeType As %String, DataID As %String) As %String
{
	s rowId="",res="false"
	s roleObj=##class(CF.EMR.DOC.RBACRole).%OpenId(RoleId)
	q:roleObj.RoleCode="SuperAdmin" "true"
	s datatypes=$o(^CF.EMR.DOC.RBACDataTypesI("IdxCode"," "_$zcvt(DataTypes,"U"),""))
	q:datatypes="" res
	s rowId=$o(^CF.EMR.DOC.RBACDataPermissionI("IdxRoleTypeDataID",ProductId,RoleId,datatypes," "_$zcvt(NodeType,"U")," "_$zcvt(DataID,"U"),rowId))
	s dataPermissionObj=##class(CF.EMR.DOC.RBACDataPermission).%OpenId(rowId)
	q:dataPermissionObj="" res
	s res="true"
	q res
}

/// Desc:       批量角色授权
/// Creator:    huhao
/// CreateDate: 2023/2/16
/// Table:		
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod UpRBACDataPermission(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s userCode=argInJson.params.userCode
	s permissionData=argInJson.params.permissionData 
	s roleId=argInJson.params.safeGroupId
	s datatypes=argInJson.params.dataTypes

	if (argInJson.params.%GetTypeOf("permissionData")'="array")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","permissionData参数必须是数组",2)
	}
	
	s strRes = ##class(EMR.DOC.BL.RBACDataPermission).Uppermission(userCode,permissionData,datatypes,roleId)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod Uppermission(userCode As %String, permissionData As %DynamicArray, dataTypes As %String, roleId As %String) As %String
{
	s strRes=""
	;if (roleId="")
	;{
	;	s roleid=$o(^CF.EMR.DOC.RBACUserI("IdxUserRoles"," "_$zcvt(userCode,"U"),""))
	;}
	;else
	;{
		s roleid=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleId)
	;}
	
	s datatypeId=$o(^CF.EMR.DOC.RBACDataTypesI("IdxCode"," "_$zcvt(dataTypes,"U"),""))
	s DataTypesObj=##class(CF.EMR.DOC.RBACDataTypes).%OpenId(datatypeId)
	q:DataTypesObj=""

	s roleObj=##class(CF.EMR.DOC.RBACRole).%OpenId(roleid)
	q:roleObj="" "-1^角色不存在"

	&sql(delete from CF_EMR_DOC.RBACDATAPermission where roleId=:roleid and DataTypes=:datatypeId)
	q:(permissionData.%Size()=0) "1"
		for j=0:1:(permissionData.%Size()-1)
		{
			s resObj=permissionData.%Get(j)
			s obj=##class(CF.EMR.DOC.RBACDataPermission).%New()
			S obj.DataID=resObj.dataID
			s obj.DataName=resObj.dataName
			s DataPerTypesObj=##class(CF.EMR.DOC.RBACDataPerTypes).%OpenId(resObj.dataPerTypes)
			continue:DataPerTypesObj=""
			s obj.DataPerTypes=DataPerTypesObj
			s obj.DataTypes=DataTypesObj
			s obj.NodeType=resObj.nodeType
			s productId=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(resObj.productCode,"U"),""))
			s productObj=##class(CT.EMR.DOC.Products).%OpenId(productId)
			continue:productObj=""
			s obj.Product=productObj
			s obj.RoleID=roleObj
			;s obj.CheckStatus=resObj.checkStatus
			s sc=obj.%Save()
			if ($$$ISOK(sc))
			{
				s strRes="1"
			}
		}
	q strRes
}

/// Desc:       获取文档管理目录树
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_RBAC_TEMPLATEDATA","params":{"roleId":"1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRBACTemplateData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DataTypes = "TEMPLATE"
	s RoleID = argInJson.params.roleId
    s strRes = ##Class(EMR.DOC.BL.RBACDataPermission).GetRBACTemplateDataJson(RoleID,DataTypes,.argOutData)
	// 成功 1 失败 -201 角色ID必传  -202 DataTypes必传
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","角色ID必传",2)
	}
	elseif(strRes="-202")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","DataTypes必传",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取数据授权中文档片段树目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_RBAC_KBDATA","params":{"roleId":"1","loadType":"ST"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRBACKBData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DataTypes = "KB"
	s RoleID = argInJson.params.roleId
	s loadType = argInJson.params.loadType
	s parentId = ..GetIDByKey(argInJson.params.id)
	if (parentId=""){	
		s:(loadType="") loadType="ALL"
    	s strRes = ##Class(EMR.DOC.BL.RBACDataPermission).GetRBACKBDataJson(RoleID,DataTypes,loadType,.argOutData)
	}else{
		s resultArr = ##class(%DynamicArray).%New()
		/// OutPut:     成功 1  失败 -202 parentId必传  -201 角色id必传
		s strRes = ##Class(EMR.DOC.BL.RBACDataPermission).GetKBNodeByParentIDJson(parentId,RoleID,.resultArr)	
		d resultArr.%ToJSON(argOutData)
	}
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","roleId参数必传",2)
	}
	elseif(strRes="-202")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","parentId必传",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取文档片段子节点数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_RBAC_KBNODEBYSID","params":{"id": "1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRBACKBNodeBYSID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strSectionID = ..GetIDByKey(argInJson.params.id)
	s RoleID = argInJson.params.roleId
	s resultArr = ##class(%DynamicArray).%New()
    s strRes = ##Class(EMR.DOC.BL.RBACDataPermission).GetKBNodeByParentIDJson(strSectionID,RoleID,.resultArr)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","roleId参数必传",2)
	}
	elseif(strRes="-202")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","parentId必传",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据角色获取关联的数据权限(DataType:TEMPLATE/模板,KB/片段,HFF/版式)
/// Creator:    duan
/// CreateDate: 2021-5-25
/// Input:      argArray  命令参数 {"action":"GET_RBAC_TEMPLATEPERMDATA","params":{"roleId":"1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
/// 			根节点（type="RT"）中的permission字段标识数据权限状态：2/全部可编辑,1/全部只读,0/全部不可见,-1/其他情况
ClassMethod GetRBACRoleDataPermission(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DataType = "KB"
	s RoleID = argInJson.params.roleId
	/// OutPut:     成功 1  失败 -201 角色id必传
    s strRes = ##Class(EMR.DOC.BL.RBACDataPermission).GetRBACRoleDataPermissionJson(RoleID,DataType,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","roleId参数必传",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       批量更新角色数据授权
/// Creator:    yejian
/// CreateDate: 2021-03-08
/// Input:      {"action": "UP_RBAC_ROLEDATAPERMISSION","params": {"roleId": "2","dataType": "KB","dataMark": "-1","dataIDS": [{"productId": "1","dataId": "1","nodeType": "CG","permission": "2"}]},"product": "GlobalEMR"}
/// 				roleId 角色ID
/// 			    dataType TEMPLATE:文档目录    HFF：文档版式  KB：文档片段
/// 			    dataMark  2/全部可编辑,1/全部只读,0/全部不可见,-1/其他情况
/// OutPut:     argOutMessage 返回消息 成功<string> 1 失败 <string> -1
///            	argOutData    返回数据
ClassMethod UpRBACRoleDataPermission(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s RoleID = argInJson.params.roleId
	s DataType = argInJson.params.dataType
	s DataIDS = argInJson.params.dataIDS
	/// OutPut:     argOutData 返回数据  失败： -101操作数据失败 -102批量更新数据失败 
	///											-201 角色ID必传 -202 数据类型必传 -203 授权标志必传
	///											-301  数据类型不存在，检查参数dataType -302 角色不存在
    s strRes = ##Class(EMR.DOC.BL.RBACDataPermission).UpRBACRoleDataPermissionJson(RoleID,DataType,DataIDS,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","更新数据权限失败",2)
	}
	elseif(strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","roleId参数必传",2)
	}
	elseif(strRes="-202")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","DataType参数必传",2)
	}
	elseif(strRes="-203")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","dataMark参数必传",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据类型不存在，检查参数dataType",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","角色不存在",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       获取模板树结构
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserCode用户编码
/// Input:      DataTypes  授权数据类型
/// OutPut:     成功 1 失败 -201 角色ID必传  -202 DataTypes必传
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACDataPermission).GetRBACTemplateDataJson("1","TEMPLATE",.argOutData)
ClassMethod GetRBACTemplateDataJson(strRoleID As %String, DataTypes As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s jsonArr = ##class(%DynamicArray).%New()
	q:(strRoleID="") "-201"
	q:(DataTypes="") "-202"
 	s ProductID = ""
	for {
		s ProductID = $o(^CT.EMR.DOC.ProductsD(ProductID))
		q:(ProductID = "")			
		s objProduct = ##Class(CT.EMR.DOC.Products).%OpenId(ProductID)
        continue:(objProduct="")
        s jsonRoot  = ##class(%DynamicObject).%New()
        s jsonRoot.key =objProduct.ProductCode_"||RT"
        s jsonRoot.productId =ProductID
        s jsonRoot.title ="文档管理("_objProduct.ProductName_")"
        s jsonRoot.type = "RT"
   		//设置权限状态
        s permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(ProductID,strRoleID,DataTypes,"RT","0")
	    d ..ResolvePermission(permission,jsonRoot)
		s jsonCategory = ##class(%DynamicArray).%New()
		s DataTypes = $zcvt(DataTypes,"U")
		d ##Class(EMR.DOC.BL.RBACDataPermission).GetJsonCategroyByID(0,ProductID,strRoleID,DataTypes,.jsonCategory)
		s jsonRoot.children = jsonCategory
		d jsonArr.%Push(jsonRoot)
	}
	d jsonArr.%ToJSON(argOutData)

	q "1"
}

/// Desc:       递归获取模板目录数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             aRoleID 角色ID
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.RBACDataPermission).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(aParentId As %String, aProductID As %String, aRoleID As %String, DataTypes As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowTemCID = ""
	for {
		s rowTemCID = $o(^CF.EMR.DOC.TemplateCategoryI("IdxProParentId",aProductID," "_aParentId,rowTemCID))
		q:(rowTemCID = "")				
		s objTemCat = ##Class(CF.EMR.DOC.TemplateCategory).%OpenId(rowTemCID)
	    continue:(objTemCat="")
	    s jsonTemCat  = ##class(%DynamicObject).%New()
	    s jsonTemCat.key = rowTemCID_"||CG"
	    s jsonTemCat.title = objTemCat.Name
	    s jsonTemCat.type = "CG"
	    s jsonTemCat.productId = aProductID
	    //设置权限
	    s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(aProductID,aRoleID,DataTypes,"CG",rowTemCID)
	    
	    d ..ResolvePermission(Permission,jsonTemCat)
		s jsonCateNew = ##class(%DynamicArray).%New()
		//如果子节点为模板则ResChildCount不为0
		if (objTemCat.ResChildCount=0)
		{
			s result = ##Class(EMR.DOC.BL.RBACDataPermission).GetJsonCategroyByID(rowTemCID,aProductID,aRoleID,DataTypes,.jsonCateNew)
		}
		else
		{	
			//根据目录获取模板数据
			s result = ##Class(EMR.DOC.BL.RBACDataPermission).GetJsonTempalteByCID(rowTemCID,aProductID,aRoleID,DataTypes,.jsonCateNew)
		}
		if (jsonCateNew.%Size()>0)
		{
			s jsonTemCat.children = jsonCateNew
		}
		d jsonCategory.%Push(jsonTemCat)	
	}
	q res
}

/// Desc:       获取模板数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             aRoleID 角色ID
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.RBACDataPermission).GetJsonTempalteByCID(0,1,1,)
ClassMethod GetJsonTempalteByCID(aParentId As %String, aProductid As %String, aRoleID As %String, DataTypes As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowTemID = ""
	for {
		s rowTemID = $o(^CF.EMR.DOC.TemplateI("IdxProCategory",aProductid,aParentId,rowTemID))
		q:(rowTemID = "")				
		s objTem = ##Class(CF.EMR.DOC.Template).%OpenId(rowTemID)
	    continue:(objTem="")
	    s jsonTem  = ##class(%DynamicObject).%New()
	    s jsonTem.key = rowTemID_"||LF"
	    s jsonTem.title = objTem.Name
	    s jsonTem.type = "LF"
	    s jsonTem.productId = aProductid
	    s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(aProductid,aRoleID,DataTypes,"LF",rowTemID)
	    
	   
	    d ..ResolvePermission(Permission,jsonTem)
	    
		d jsonCategory.%Push(jsonTem)	
	}
	q res
}

/// Desc:       获取文档片段目录树JSON
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      TemplateID	模板ID
/// Input:      aProductCode  项目标识
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACDataPermission).GetRBACKBDataJson("1","KB",.argOutData)
ClassMethod GetRBACKBDataJson(strRoleID As %String, DataTypes As %String, LoadType As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(strRoleID="") "-201"
	s:LoadType="" LoadType="ALL"
	s:DataTypes="" DataTypes="KB"
	s jsonArr = ##class(%DynamicArray).%New()
 	s ProductID = ""
	for {
		s ProductID = $o(^CT.EMR.DOC.ProductsD(ProductID))
		q:(ProductID = "")			
		s objProduct = ##Class(CT.EMR.DOC.Products).%OpenId(ProductID)
        continue:(objProduct="")
        s jsonRoot  = ##class(%DynamicObject).%New()
        s jsonRoot.key =objProduct.ProductCode_"||RT"
        s jsonRoot.productId =ProductID
        s jsonRoot.title ="文档片段("_objProduct.ProductName_")"
       	//设置权限状态
        s permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(ProductID,strRoleID,DataTypes,"RT","0")
	    d ..ResolvePermission(permission,jsonRoot)
        s jsonRoot.type = "RT"
   		
		s jsonCategory = ##class(%DynamicArray).%New()
		s DataTypes = $ZCVT(DataTypes,"U")
		d ##Class(EMR.DOC.BL.RBACDataPermission).GetKBJsonCategroyByID(0,ProductID,strRoleID,DataTypes,LoadType,.jsonCategory)	
		s jsonRoot.children = jsonCategory
		d jsonArr.%Push(jsonRoot)
	}
	d jsonArr.%ToJSON(argOutData)

	q "1"
}

/// Desc:       递归获取目录数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             aRoleID 角色ID
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.RBACDataPermission).GetJsonCategroyByID(0,1,1,)
ClassMethod GetKBJsonCategroyByID(aParentId As %String, aProductID As %String, aRoleID As %String, DataTypes As %String, LoadType As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowCID = ""
	for {
		s rowCID = $o(^CF.EMR.DOC.KBCategoryI("IdxProParentId",aProductID," "_aParentId,rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s type = ..FormatType(objCat.KBCategoryTypes.Code)
	    s jsonCat.key = rowCID_"||"_type
	    s jsonCat.title = objCat.Name
	    s jsonCat.type = type
	    s jsonCat.productId = aProductID
	     //设置权限
	    s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(aProductID,aRoleID,DataTypes,type,rowCID)
	    
	    d ..ResolvePermission(Permission,jsonCat)
	    
		s jsonCateNew = ##class(%DynamicArray).%New()
		if (($ZCVT(objCat.KBCategoryTypes.Code,"U")="KBTREE")&&(objCat.ResChildCount>0))
		{
			//根据目录获取模板数据
			s result = ##Class(EMR.DOC.BL.RBACDataPermission).GetKBNodeJsonByID(rowCID,aRoleID,DataTypes,.jsonCateNew)
			s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		}
		else 
		{
			//根据目录获取模板数据
			s result = ##Class(EMR.DOC.BL.RBACDataPermission).GetKBJsonCategroyByID(rowCID,aProductID,aRoleID,DataTypes,LoadType,.jsonCateNew)
			s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		}
		
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

/// Desc:       根据角色获取关联的模板数据权限(DataType:TEMPLATE/模板,KB/片段,HFF/版式)
/// Creator:    yejian
/// CreateDate: 2021-3-18
/// Input:      
/// OutPut:     成功 1  失败 -201 角色id必传
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACDataPermission).GetRBACRoleDataPermissionJson("1","TEMPLATE",.argOutData)
ClassMethod GetRBACRoleDataPermissionJson(strRoleID As %String, DataType As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:strRoleID="" "-201"
	s:DataType="" DataType="KB"
	s strRes = "1"
	s json = ##Class(%GlobalBinaryStream).%New()
	s jArrDPer = ##class(%DynamicArray).%New()
	
	s strDTRowID = $o(^CF.EMR.DOC.RBACDataTypesI("IdxCode"," "_$zcvt(DataType,"U"),""))
	q:(strDTRowID = "") "-1"
	s strRowID = ""
	for {
		s strRowID = $o(^CF.EMR.DOC.RBACDataPermissionI("IdxRoleDataType",strRoleID,strDTRowID,strRowID))
		q:(strRowID = "")			
		s objDataPer = ##Class(CF.EMR.DOC.RBACDataPermission).%OpenId(strRowID)
        continue:(objDataPer="")
        s jsonItem  = ##class(%DynamicObject).%New()
	    s jsonItem.ID = strRowID
	    s jsonItem.ProductID = $case(objDataPer.Product,"":"",:objDataPer.Product.%Id())
	    s jsonItem.ProductCode =$case(objDataPer.Product,"":"",:objDataPer.Product.ProductCode) 
	    s jsonItem.DataID = objDataPer.DataID
	    s jsonItem.DataName = objDataPer.DataName
	    s jsonItem.NodeType = objDataPer.NodeType
		s jsonItem.Permission =objDataPer.DataPerTypes.Code
        d jArrDPer.%Push(jsonItem)
	}
	d jArrDPer.%ToJSON(argOutData)

	q strRes
}

/// Desc:       批量更新角色数据授权
/// Creator:    yejian
/// CreateDate: 2021-03-08
/// InPut:		strRoleID 角色ID
/// 			DataType 数据类型
/// 			DataMark 数据标识：2/全部可编辑,1/全部只读,0/全部不可见,-1/其他情况
/// 			DataIDS json数组
/// OutPut:     argOutData 返回数据  失败： -101操作数据失败 -102批量更新数据失败 
/// 											-201 角色ID必传 -202 数据类型必传 -203 授权标志必传
/// 											-301  数据类型不存在，检查参数dataType -302 角色不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 			s strJson = "[{""ProductID"":""1"",""DataID"":""3"",""NodeType"":""LF"",""Permission"":""2""},{""ProductID"":""1"",""DataID"":""3"",""NodeType"":""LF"",""Permission"":""2""}]"
///   			set objJson = ##class(%DynamicAbstractObject).%FromJSON(strJson)
///             w ##class(EMR.DOC.BL.RBACDataPermission).UpRBACRoleDataPermissionJson("1","TEMPLATE","OTHER",objJson,argOutData)
ClassMethod UpRBACRoleDataPermissionJson(strRoleID As %String, DataType As %String, DataIDS As %DynamicArray, ByRef argOutData As %GlobalBinaryStream)
{
	q:(strRoleID="") "-201"
	q:(DataType="") "-202"
	TSTART
	s strDTRowID = $o(^CF.EMR.DOC.RBACDataTypesI("IdxCode"," "_$zcvt(DataType,"U"),""))
	q:(strDTRowID="") "-301"
	//判断角色是否有数据权限数据
	s dataCount = 0
	&SQL(select count(*) into :dataCount from CF_EMR_DOC.RBACDataPermission WHERE RoleID=:strRoleID AND DataTypes=:strDTRowID)
	if (dataCount=0)
	{
		//生成数据权限数据	
		s res =  ..LoadPermissionData(strRoleID,DataType)
		if (res '= "1")
		{
			q res	
		}
	}
	s objDType = ##class(CF.EMR.DOC.RBACDataTypes).%OpenId(strDTRowID)
	if (objDType = "") 
	{
		TROLLBACK
		q "-301"
	}
	s objRole = ##class(CF.EMR.DOC.RBACRole).%OpenId(strRoleID)
	if (objRole = "") 
	{
		TROLLBACK
		q "-302"
	}
	s strMark = "1"
	s intDataSize = DataIDS.%Size()
	for i=0:1:(intDataSize-1)
	{
		s jItem = DataIDS.%Get(i)
		if (jItem = "") 
		{
			s strMark="-1"
			q
		}
		s strProductID =jItem.productId
		s strDataID =..GetIDByKey(jItem.dataId)
		s strPermission = ..FormatPermission(jItem)
		s strNodeType = jItem.nodeType
		
		s:strNodeType="RT" strDataID=0	
		if (strPermission=""){
			s strMark = "-1"
			q 	
		}
		s isOk = ..SetPermissionData(strRoleID,strDataID,DataType,strNodeType,"",strPermission,strProductID)
		if (isOk'="1"){
			s strMark = "-1"
			q 	
		}
	}
	if (strMark ="-1")
	{
		TROLLBACK
		s strRes = "-101"
	}
	else
	{
		TCOMMIT
		s strRes = "1"
	}
	q strRes
}

/// Desc:       获取数据名称
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      DataType 数据节点类型
///             aDataID 数据ID
/// OutPut:     string 节点名称
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.BL.RBACDataPermission).GetDataNameByID("TEMPLATE","CG",1)
ClassMethod GetDataNameByID(DataType As %String, NodeType As %String, strDataID As %String, ProductID As %String) As %String
{
	s strRes= ""
	q:((DataType="")||(NodeType="")||(strDataID="")) strRes
	//判断是否有授权数据
	if (DataType="TEMPLATE")
	{
		if (NodeType="CG")
		{
			s objTemCat = ##Class(CF.EMR.DOC.TemplateCategory).%OpenId(strDataID)
			q:(objTemCat="") strRes
			s strRes = objTemCat.Name
		}
		elseif(NodeType="LF")
		{
			s objTem = ##Class(CF.EMR.DOC.Template).%OpenId(strDataID)
			q:(objTem="") strRes
			s strRes = objTem.Name
		}
		elseif(NodeType="RT")
		{	
			s objProduct = ##Class(CT.EMR.DOC.Products).%OpenId(ProductID)
			q:(objProduct="") strRes
			s strRes ="文档管理("_objProduct.ProductName_")"
		}
	}
	elseif(DataType="KB")
	{
		if (NodeType="KBNODE")
		{
			s objKBNode = ##Class(CF.EMR.DOC.KBNode).%OpenId(strDataID)
			q:(objKBNode="") strRes
			s strRes = objKBNode.Name
		}
		elseif(NodeType="RT")
		{	
			s objProduct = ##Class(CT.EMR.DOC.Products).%OpenId(ProductID)
			q:(objProduct="") strRes
			s strRes ="文档片段管理("_objProduct.ProductName_")"
		}
		else
		{
			s objKBC = ##Class(CF.EMR.DOC.KBCategory).%OpenId(strDataID)
			q:(objKBC="") strRes
			s strRes = objKBC.Name
		}
	}
	q strRes
}

/// Desc:       根据片段父节子节点数据的数据权限
/// Creator:    duan
/// CreateDate: 2021-05-20
/// Input:      aParentId 父节点id
///             aRoleID 角色id
/// OutPut:     成功 1  失败 -202 parentId必传  -201 角色id必传
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.BL.RBACDataPermission).SetPermissionData()
ClassMethod GetKBNodeByParentIDJson(aParentId As %String, aRoleID As %String, ByRef JsonCategory As %DynamicArray) As %String
{
	q:(aParentId="") "-202"
	q:(aRoleID="") "-203"
	s rowCID = ""
	for {
		s rowCID = $o(^CF.EMR.DOC.KBCategoryI("IdxParentId"," "_aParentId,rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s type = ..FormatType(objCat.KBCategoryTypes.Code)
	    s jsonCat.key = rowCID_"||"_type
	    s jsonCat.title = objCat.Name
	    s jsonCat.type = type
	    s ProductID = objCat.Product.%Id()
	    s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(ProductID,aRoleID,"KB","KT",rowCID)
		s jsonCat.permission = Permission
	    
		s jsonCateNew = ##class(%DynamicArray).%New()
		
		if ((type="KT")&&(objCat.ResChildCount>0))
		{
			//根据KBTree取片段
			s result = ##Class(EMR.DOC.BL.RBACDataPermission).GetKBNodeJsonByID(rowCID,aRoleID,.jsonCateNew)
			s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		}else{
			d ..GetKBNodeByParentIDJson(rowCID,aRoleID,.jsonCateNew)
			s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		}
		d JsonCategory.%Push(jsonCat)	
	}
	q "1"
}

ClassMethod GetKBNodeJsonByID(aParentId As %String, aRoleID As %String, DataTypes As %String, ByRef jsonCategory As %DynamicArray)
{
	s res = "1"
	s rowID = $o(^CF.EMR.DOC.KBNodeI("IdxKBCategory",aParentId,""))
	s:(rowID="") res ="-1"
	s rowNID = ""
	for {
		s rowNID = $o(^CF.EMR.DOC.KBNodeI("IdxKBCategory",aParentId,rowNID))
		q:(rowNID = "")				
		s objKBNode = ##Class(CF.EMR.DOC.KBNode).%OpenId(rowNID)
	    continue:(objKBNode="")
	    s jsonSim  = ##class(%DynamicObject).%New()
	    s type = "IT"
	    s jsonSim.key = rowNID_"||"_type
	    s jsonSim.title = objKBNode.Name
	    s jsonSim.type = type
	    s jsonSim.description = objKBNode.Description
	    s jsonSim.status = objKBNode.Status_""
	    s ProductID = objKBNode.Product.%Id()
	    s jsonSim.productId = ProductID
	   	 //设置权限
	    s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(ProductID,aRoleID,DataTypes,type,rowNID)
	    
	    d ..ResolvePermission(Permission,jsonSim)
	    
		d jsonCategory.%Push(jsonSim)	
	}
	q res
}

/// Desc:       根据角色Id为数据设置指定的数据权限
/// Creator:    duan
/// CreateDate: 2021-05-20
/// Others：     权限为1（可见,不可编辑）的数据不保存  权限为0（不可见，不可编辑） 2（可见，可编辑） 3（不可见，可编辑）的数据保存
/// Debug:         w ##Class(EMR.DOC.BL.RBACDataPermission).SetPermissionData()
ClassMethod SetPermissionData(argRoleID As %String, argDataID As %String, argDataType As %String, argNodeType As %String, argDataName As %String, argPermissionCode As %String, argProductID As %String = "")
{
	//检查数据是否存在
	q:(argRoleID="") "-201"
	q:(argDataID="") "-203"
	q:(argDataType="") "-202"
	q:(argPermissionCode="") "-204"
	TSTART
	s DataTypesID = $o(^CF.EMR.DOC.RBACDataTypesI("IdxCode"," "_$zcvt(argDataType,"U"),""))
	q:(DataTypesID="") "-104"
	s ObjDataType = ##class(CF.EMR.DOC.RBACDataTypes).%OpenId(DataTypesID)
	q:(ObjDataType="") "-104"
	s PermissionTypeID = $O(^CF.EMR.DOC.RBACDataPerTypesI("IdxCode"," "_argPermissionCode,""))
	q:(PermissionTypeID="") "-104"
	s dataID = ""
	&SQL(select ID into :dataID from CF_EMR_DOC.RBACDataPermission where RoleID = :argRoleID and DataTypes = :DataTypesID and DataID=:argDataID and NodeType=:argNodeType and Product = :argProductID)
	if (dataID=""){
			//添加记录
			s objRole = ##class(CF.EMR.DOC.RBACRole).%OpenId(argRoleID)
			q:objRole="" "-301"
			s objDataPer = ##class(CF.EMR.DOC.RBACDataPermission).%New()
			s objDataPer.RoleID = objRole
			s objDataPer.DataID = argDataID
			s:(argDataName="") argDataName= ##Class(EMR.DOC.BL.RBACDataPermission).GetDataNameByID(argDataType,argNodeType,argDataID,argProductID)
			s objDataPer.DataName = argDataName
			s objDataPer.NodeType = argNodeType
			s objDataPer.DataTypes = ObjDataType
			if (argProductID'=""){
				s ObjProduct = ##class(CT.EMR.DOC.Products).%OpenId(argProductID)
				q:(ObjProduct="") "-104"
				s objDataPer.Product = ObjProduct	
			}
			s objDPTTypes = ##class(CF.EMR.DOC.RBACDataPerTypes).%OpenId(PermissionTypeID)
			s objDataPer.DataPerTypes = objDPTTypes
			s sc = objDataPer.%Save()
			if ('$$$ISOK(sc))
			{
				TROLLBACK
				q "-103"
			}
	}	
	else
	{
			//修改数据
			s ObjPermissionData = ##class(CF.EMR.DOC.RBACDataPermission).%OpenId(dataID)
			q:(ObjPermissionData="") "-301"
			s objDPTTypes = ##class(CF.EMR.DOC.RBACDataPerTypes).%OpenId(PermissionTypeID)
			s ObjPermissionData.DataPerTypes = objDPTTypes
			s sc = ObjPermissionData.%Save()
			if ('$$$ISOK(sc))
			{
				TROLLBACK
				q "-103"
			}
	}
	TCOMMIT
	q "1"
}

/// Desc:       根据permission状态返回前端需要的字段标识
/// Creator:    duan
/// CreateDate: 2021-06-04
/// Others：     permission -1(不可见，可编辑),0（不可见，不可编辑）,1（可见，不可编辑）,2（可见，可编辑） 
///                 view： 可见      edit： 可编辑
ClassMethod ResolvePermission(APermission As %String, AObj As %DynamicAbstractObject)
{
	q:(APermission="") "-1"
	s true = "1"
	s false = "0"
	if (APermission=0){
		s AObj.view = false
		s AObj.edit = false
	}
	elseif (APermission=1)
	{
		s AObj.view = true
		s AObj.edit = false
	}
	elseif (APermission=2)
	{
		s AObj.view = true
		s AObj.edit = true	
	}
	elseif (APermission=-1)
	{
		s AObj.view = false
		s AObj.edit = true	
	}
	q "1"
}

/// Desc:      将前端传回来的权限字段转换为数据库中的permission字段
/// Creator:    duan
/// CreateDate: 2021-06-04
/// Others：     permission -1(不可见，可编辑),0（不可见，不可编辑）,1（可见，不可编辑）,2（可见，可编辑） 
///                 view： 可见      edit： 可编辑
ClassMethod FormatPermission(AObj As %DynamicAbstractObject) As %String
{
	s permission = 2
	q:(AObj="") permission
	s view = AObj.view
	s edit = AObj.edit
	s:((view=1)&&(edit=1)) permission = 2
	s:((view=1)&&(edit=0)) permission = 1
	s:((view=0)&&(edit=1)) permission = -1
	s:((view=0)&&(edit=0)) permission = 0
	q permission
}

/// Desc:       在数据权限表CF.EMR.DOC.RBACDataPermission中根据角色生成角色的权限数据
/// Creator:    duan
/// CreateDate: 2021-06-04
/// Input: strRoleID 角色ID  DataType 数据类型标识 TEMPLATE/文档目录 KB/片段
/// output： 成功： 1  失败：-201 角色ID必传 -202 DataType 数据类型必传 -103 操作权限数据失败 -104 设置权限数据参数错误
ClassMethod LoadPermissionData(strRoleID As %String, DataType As %String)
{
	s jsonArr = ##class(%DynamicArray).%New()
	q:(strRoleID="") "-201"
	q:(DataType="") "-202"
	s strRes = "1" 
 	s ProductID = ""
	for {
		s ProductID = $o(^CT.EMR.DOC.ProductsD(ProductID))
		q:(ProductID = "")			
		s objProduct = ##Class(CT.EMR.DOC.Products).%OpenId(ProductID)
        continue:(objProduct="")
        if (DataType="TEMPLATE"){
	     	s isOk = ##Class(EMR.DOC.BL.RBACDataPermission).SetPermissionData(strRoleID,"0",DataType,"RT","文档管理("_objProduct.ProductName_")",2,ProductID)
			if (isOk'=1){
				s strRes=isOk
				q
			}
			s res =  ##Class(EMR.DOC.BL.RBACDataPermission).SetTemplateCategoryPermission(0,ProductID,strRoleID,DataType,2)
	    	if (res'="1")
	    	{
		    	s strRes=res
				q
		    }
	    }elseif (DataType="KB"){
	     	s isOk = ##Class(EMR.DOC.BL.RBACDataPermission).SetPermissionData(strRoleID,"0",DataType,"RT","文档片段("_objProduct.ProductName_")",2,ProductID)
			if (isOk'=1){
				s strRes=isOk
				q
			}
			s res =  ##Class(EMR.DOC.BL.RBACDataPermission).SetKBCategoryPermission(0,ProductID,strRoleID,DataType,2)
	    	if (res'="1")
	    	{
		    	s strRes=res
				q
		    }
	    }
    }
	q strRes
}

ClassMethod SetTemplateCategoryPermission(aParentId As %String, aProductID As %String, aRoleID As %String, DataTypes As %String, aPermissionCode As %String)
{
	s res = "1"
	s rowTemCID = ""
	for {
		s rowTemCID = $o(^CF.EMR.DOC.TemplateCategoryI("IdxProParentId",aProductID," "_aParentId,rowTemCID))
		q:(rowTemCID = "")				
		s objTemCat = ##Class(CF.EMR.DOC.TemplateCategory).%OpenId(rowTemCID)
	    continue:(objTemCat="")
	  	s dataID  = rowTemCID
	    s dataName= objTemCat.Name
	    s nodeType = "CG"
	   	s isOk = ..SetPermissionData(aRoleID,dataID,DataTypes,nodeType,dataName,aPermissionCode,aProductID)
		if (isOk '= "1")
		{
			s res = isOk
			q	
		}
		//如果子节点为模板则ResChildCount不为0
		if (objTemCat.ResChildCount=0)
		{
			s result = ##Class(EMR.DOC.BL.RBACDataPermission).SetTemplateCategoryPermission(rowTemCID,aProductID,aRoleID,DataTypes,2)
			if (result'="1")
			{
				s res = result
				q	
			}
		}
		else
		{	
			//根据目录获取模板数据
			s result = ##Class(EMR.DOC.BL.RBACDataPermission).SetTemplatePermission(rowTemCID,aProductID,aRoleID,DataTypes,2)
			if (result'="1")
			{
				s res = result
				q	
			}
		}
	}
	q res
}

ClassMethod SetTemplatePermission(aParentId As %String, aProductID As %String, aRoleID As %String, DataTypes As %String, aPermissionCode As %String)
{
	s res = "1"
	s rowTemID = ""
	for {
		s rowTemID = $o(^CF.EMR.DOC.TemplateI("IdxProCategory",aProductID,aParentId,rowTemID))
		q:(rowTemID = "")				
		s objTem = ##Class(CF.EMR.DOC.Template).%OpenId(rowTemID)
	    continue:(objTem="")
	    s dataID = rowTemID
	    s dataName = objTem.Name
	    s nodeType = "LF"	
	    s isOk = ..SetPermissionData(aRoleID,dataID,DataTypes,nodeType,dataName,aPermissionCode,aProductID)
		if (isOk '= "1")
		{
			s res = isOk
			q	
		}
	}
	q res
}

ClassMethod SetKBCategoryPermission(aParentId As %String, aProductID As %String, aRoleID As %String, aDataType As %String, aPermissionCode As %String)
{
	q:(aRoleID="") "-201"
	q:(aDataType="") "-202"
	s rowCID = ""
	for {
		s rowCID = $o(^CF.EMR.DOC.KBCategoryI("IdxParentId"," "_aParentId,rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s nodeType = ..FormatType(objCat.KBCategoryTypes.Code)
	    s dataID = rowCID
	    s dataName = objCat.Name
	    s ProductID = objCat.Product.%Id()
	   	s isOk = ..SetPermissionData(aRoleID,dataID,aDataType,nodeType,dataName,aPermissionCode,aProductID)
		if (isOk '= "1")
		{
			s res = isOk
			q	
		}
		
		if ((nodeType="KT")&&(objCat.ResChildCount>0))
		{
			//根据KBTree取片段
			s result = ##Class(EMR.DOC.BL.RBACDataPermission).SetKBNodePermission(rowCID,ProductID,aRoleID,aDataType,2)
			if (result'="1")
			{
				s res = result
				q	
			}
		}else{
			s result = ..SetKBCategoryPermission(rowCID,ProductID,aRoleID,aDataType,2)
			if (result'="1")
			{
				s res = result
				q	
			}
		}	
	}
	q "1"
}

ClassMethod SetKBNodePermission(aParentId As %String, aProductID As %String, aRoleID As %String, aDataType As %String, aPermissionCode As %String)
{
	s res = "1"
	s rowNID = ""
	for {
		s rowNID = $o(^CF.EMR.DOC.KBNodeI("IdxKBCategory",aParentId,rowNID))
		q:(rowNID = "")				
		s objKBNode = ##Class(CF.EMR.DOC.KBNode).%OpenId(rowNID)
	    continue:(objKBNode="")
	    s nodeType = "IT"
	    s dataID = rowNID
	    s dataName = objKBNode.Name
	    s ProductID = objKBNode.Product.%Id()
	   	s isOk = ..SetPermissionData(aRoleID,dataID,aDataType,nodeType,dataName,aPermissionCode,aProductID)
		if (isOk '= "1")
		{
			s res = isOk
			q	
		}
	}
	q res
}

/// desc 新建数据添加数据的数据权限
/// creator huhao
/// date 2023.03.08
/// indata argRoleID 安全组id argDataID 授权节点id argDataType 授权数据类型 argNodeType 授权节点类型 argDataName 节点名称 argProductID 项目标识
/// outout 成功：1 失败：-201 角色ID未传  -202 数据类型未传 -203 数据ID未传 -204 节点类型未传
/// 						-104 数据类型不正确
/// debug d ##class(EMR.DOC.BL.RBACDataPermission).AddPermissionData()
ClassMethod AddPermissionData(argRoleID As %String, argDataID As %String, argDataType As %String, argNodeType As %String, argDataName As %String, argProductID As %String = "")
{
	s strRes=""
	//检查数据是否存在
	q:(argRoleID="") "-1^安全组不能为空"
	q:(argDataID="") "-1^节点id不能为空"
	q:(argDataType="") "-1^授权类型不能为空"
	q:(argNodeType="") "-1^节点类型不能为空"
	q:(argProductID="") "-1^项目标识不为空"
	q:(argDataName="") "-1^节点名称不能为空"
	
	s obj=##class(CF.EMR.DOC.RBACDataPermission).%New()
	s obj.DataID=argDataID
	s obj.DataName=argDataName
	s obj.DataPerTypes=##class(CF.EMR.DOC.RBACDataPerTypes).%OpenId(2)
	s datatypeId=$o(^CF.EMR.DOC.RBACDataTypesI("IdxCode"," "_$zcvt(argDataType,"U"),""))
	s dataTypeObj=##class(CF.EMR.DOC.RBACDataTypes).%OpenId(datatypeId)
	q:dataTypeObj="" "-1^授权类型有误"
	s obj.DataTypes=dataTypeObj
	s obj.NodeType=argNodeType
	s productObj=##class(CT.EMR.DOC.Products).%OpenId(argProductID)
	q:productObj="" "-1^项目标识不存在"
	s obj.Product=productObj
	s roleObj=##class(CF.EMR.DOC.RBACRole).%OpenId(argRoleID)
	q:roleObj="" "-1^安全组不存在"
	s obj.RoleID=roleObj
	s sc=obj.%Save()
	if ($$$ISOK(sc))
	{
		s strRes="1"
	}
	q strRes
}

/// Desc:       获取文档管理目录所有的key
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_RBAC_TEMPLATEDATAKEY","params":{"roleId":"1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRBACTemplateKey(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DataTypes = "TEMPLATE"
	s RoleID = argInJson.params.roleId
    s strRes = ##Class(EMR.DOC.BL.RBACDataPermission).GetRBACTemplateKeyJson(RoleID,DataTypes,.argOutData)
	// 成功 1 失败 -201 角色ID必传  -202 DataTypes必传
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","角色ID必传",2)
	}
	elseif(strRes="-202")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","DataTypes必传",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取文档管理目录所有的key
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserCode用户编码
/// Input:      DataTypes  授权数据类型
/// OutPut:     成功 1 失败 -201 角色ID必传  -202 DataTypes必传
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACDataPermission).GetRBACTemplateDataJson("1","TEMPLATE",.argOutData)
ClassMethod GetRBACTemplateKeyJson(strRoleID As %String, DataTypes As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s jsonArr = ##class(%DynamicArray).%New()
	q:(strRoleID="") "-201"
	q:(DataTypes="") "-202"
 	s ProductID = ""
	for {
		s ProductID = $o(^CT.EMR.DOC.ProductsD(ProductID))
		q:(ProductID = "")			
		s objProduct = ##Class(CT.EMR.DOC.Products).%OpenId(ProductID)
        continue:(objProduct="")
        s jsonRoot  = ##class(%DynamicObject).%New()
        s jsonRoot.key =objProduct.ProductCode_"||RT"
		d jsonArr.%Push(jsonRoot)
	}
	d jsonArr.%ToJSON(argOutData)

	q "1"
}

}
