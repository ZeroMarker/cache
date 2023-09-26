/// 名称:	EMR.DOC.BL.TextKBCategory
/// 描述:	专科知识库目录业务类
/// 编写者：zhangxl
/// 编写日期: 2021-7-26
/// 产品组：电子病历产品组
Class EMR.DOC.BL.TextKBCategory Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取专科知识库维护目录类别
/// Creator:    zhangxl
/// CreateDate: 2021-7-26
/// Input:      argArray  命令参数 {'params':{'action':'GET_TEXTKB_CATEGORY",'args':{}},'product':'GlobalEMR'}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTextKBCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.TextKBCategory).GetTextKBCategoryJson(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取角色类型数据出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       获取专科知识库维护目录类别
/// Creator:    zhangxl
/// CreateDate: 2021-7-26
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.TextKBCategory).GetTextKBCategoryJson(.argOutData)
ClassMethod GetTextKBCategoryJson(ByRef argOutData As %GlobalBinaryStream)
{
	s seq =""
	s jsonArr = ##class(%DynamicArray).%New()
	for
	{
		s seq = $o(^CF.EMR.DOC.TextKBCategoryI("IdxParentIDSeq","0",seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^CF.EMR.DOC.TextKBCategoryI("IdxParentIDSeq","0",seq,rowId))
			q:(rowId = "")
			s obj = ##Class(CF.EMR.DOC.TextKBCategory).%OpenId(rowId)
			continue:(obj = "")
			continue:(obj.IsValid = "N")
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.id= rowId
			s jsonItem.Name= obj.Name
			s jsonItem.ParentID= obj.ParentID
			s jsonItem.Type= obj.Type
			d jsonArr.%Push(jsonItem)
		}
	}
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       添加类别
/// Creator:    zhangxl
/// CreateDate: 2021-7-26
/// Input:      argArray  	命令参数 {"action":"ADD_TEXTKB_CATEGORY","params":{"Name":"WS"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddTextKBCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s argDTO = ##class(EMR.DOC.DTO.TextKBCategory).%New()
    ;s argDTO.ParentID = argInJson.params.ParentID
    ;s argDTO.Type = argInJson.params.Type
    s argDTO.Name = argInJson.params.Name
    s strRes = ##Class(EMR.DOC.BL.TextKBCategory).AddTextKBCategoryJson(argDTO)
    if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取角色类型数据出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       添加类别
/// Creator:    zhangxl
/// CreateDate: 2021-7-26
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败
/// Debug:      w ##Class(EMR.DOC.BL.TextKBCategory).AddTextKBCategoryJson()
ClassMethod AddTextKBCategoryJson(argDTO As EMR.DOC.DTO.TextKBCategory) As %String
{
    s result = ""
    q:(argDTO.Name = "") result
    s rowId = $o(^CF.EMR.DOC.TextKBCategoryI("IdxName"," "_$zcvt(argDTO.Name,"u"),""))
    if (rowId = "")
      {
          s obj = ##Class(CF.EMR.DOC.TextKBCategory).%New()
          s obj.Sequence = $case($d(^CF.EMR.DOC.TextKBCategoryD)>0,0:1,:^CF.EMR.DOC.TextKBCategoryD+1)
      }
    else
      {
          s obj = ##Class(CF.EMR.DOC.TextKBCategory).%OpenId(rowId)
      }
    s obj.Name = argDTO.Name
    s obj.Type = "folder"
    s obj.ParentID = "0"
    s obj.IsValid = "Y"
    s sc = obj.%Save()
    s:($$$ISOK(sc)) result = "1"
    q result
}

/// Desc:       删除类别
/// Creator:    zhangxl
/// CreateDate: 2021-7-28
/// Input:      argArray  	命令参数 {"action":"DEL_TEXTKB_CATEGORY","params":{"id":1},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DelTextKBCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s strID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.TextKBCategory).DelTextKBCategoryJson(strID)
    if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-100")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","目录ID未查到",2)
	}	
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取角色类型数据出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       删除类别
/// Creator:    zhangxl
/// CreateDate: 2021-7-28
/// Input:      argCategoryID  文档目录ID
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 删除失败
/// Debug:      w ##Class(EMR.DOC.BL.DataElement).DelTextKBCategoryJson("1")
ClassMethod DelTextKBCategoryJson(strID As %String) As %String
{
	q:(strID="") "-100"
	;s sc = ##class(CF.EMR.DOC.TextKBCategory).%DeleteId(strID)
	s objCategory = ##class(CF.EMR.DOC.TextKBCategory).%OpenId(strID)
	q:(objCategory="") ""
	s objCategory.IsValid = "N"	
	s sc = objCategory.%Save()
    s:($$$ISOK(sc)) strRes = "1"
    q strRes
}

/// Desc:       获取类别对应树结构
/// Creator:    zhangxl
/// CreateDate: 2021-7-30
/// Input:      argArray  命令参数{"action":"GET_TextKB_TREE","params":{"userCode":"YS01","getDataType":"CG","id":"0"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTextKBTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s GetDataType = argInJson.params.getDataType
	s ParentID = argInJson.params.id
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.TextKBCategory).GetTextKBTreeJson(UserCode,GetDataType,ParentID,roleCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","安全组用户必传，检查safegroupid",2)
	}	
	elseif(strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据类型必须为ALL或CG",2)
	}
	elseif(strRes="-202")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","目录ID未查到",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未获取到用户",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户未关联角色",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
	
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取类别对应树结构
/// Creator:    zhangxl
/// CreateDate: 2021-7-30
/// Input:      argUserCode用户编码
/// 		    DataTypes  授权数据类型
/// 		    strID 根据目录ID查询数据
/// OutPut:     成功 1 失败 -200 用户code必传 -201 获取数据类型必须为ALL或CG, -202 目录ID未查到
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ###Class(EMR.DOC.BL.TextKBCategory).GetTextKBTreeJson("YS01","CG","9",.argOutData)
ClassMethod GetTextKBTreeJson(aUserCode As %String, aAction As %String, strID As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(roleCode="") "-200"
	q:((aAction'="ALL")&&(aAction'="CG")) "-201"
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-302"
	s jsonArr = ##class(%DynamicArray).%New()
    s jsonRoot  = ##class(%DynamicObject).%New()
    s objCate = ##class(CF.EMR.DOC.TextKBCategory).%OpenId(strID)
    q:(objCate="") "-202"
    s jsonRoot.key =strID_"||RT"
    s jsonRoot.title =objCate.Name
    s jsonRoot.id =strID
    s jsonRoot.type = "RT"
	s jsonCategory = ##class(%DynamicArray).%New()
	d ##Class(EMR.DOC.BL.TextKBCategory).GetJsonCategroyByID(strID,aAction,jsonRoot,.jsonCategory)	
	s:(jsonCategory.%Size()>0) jsonRoot.children = jsonCategory
	d jsonArr.%Push(jsonRoot)
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       获取tree
/// Creator:    zhangxl
/// CreateDate: 2021-7-30
/// Input:      argArray  命令参数{"action":"GET_KNOWLEDGE_TREE","params":{"userCode":"YS01","getDataType":"CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetKnowledgeTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s GetDataType = argInJson.params.getDataType
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.TextKBCategory).GetKnowledgeTreeJson(UserCode,GetDataType,roleCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户code必传,检查参数userCode",2)
	}	
	elseif(strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据类型必须为ALL或CG",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未获取到用户",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户未关联角色",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
	
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取tree
/// Creator:    zhangxl
/// CreateDate: 2021-7-30
/// Input:      argUserCode用户编码   DataTypes  授权数据类型
/// OutPut:     成功 1 失败 -200 用户code必传
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ###Class(EMR.DOC.BL.TextKBCategory).GetKnowledgeTreeJson("YS01","CG",.argOutData)
ClassMethod GetKnowledgeTreeJson(aUserCode As %String, aAction As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(roleCode="") "-200"
	q:((aAction'="ALL")&&(aAction'="CG")) "-201"
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-302"
	s seq =""
    s jsonArr = ##class(%DynamicArray).%New()
	for
	{
		s seq = $o(^CF.EMR.DOC.TextKBCategoryI("IdxParentIDSeq","0",seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^CF.EMR.DOC.TextKBCategoryI("IdxParentIDSeq","0",seq,rowId))
			q:(rowId = "")
			s obj = ##Class(CF.EMR.DOC.TextKBCategory).%OpenId(rowId)
			continue:(obj = "")
			continue:(obj.IsValid = "N")
			s jsonRoot  = ##class(%DynamicObject).%New()
			s jsonRoot.key = rowId_"||RT"
   			s jsonRoot.title =obj.Name
    		s jsonRoot.id =rowId
    		s jsonRoot.type = "RT"
    		s jsonRoot.nodeType = obj.Type	
			s jsonCategory = ##class(%DynamicArray).%New()
	        d ##Class(EMR.DOC.BL.TextKBCategory).GetJsonCategroyByID(rowId,aAction,jsonRoot,.jsonCategory)	
	        s:(jsonCategory.%Size()>0) jsonRoot.children = jsonCategory
			d jsonArr.%Push(jsonRoot)
		}
	}
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       递归获取目录数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.TextKBCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(aParentId As %String, GetDataType As %String, jsonRoot As %DynamicArray, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowCID = ""
	for {
		s rowCID = $O(^CF.EMR.DOC.TextKBCategoryI("IdxParentID",aParentId,rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.TextKBCategory).%OpenId(rowCID)
	    continue:(objCat="")
		continue:(objCat.IsValid = "N")
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s jsonCat.key = rowCID_"||IT"
	    s jsonCat.title = objCat.Name
	    s jsonCat.type = "IT"
	    s jsonCat.id = rowCID
	    s jsonCat.nodeType = objCat.Type
	    if (objCat.ParentID = jsonRoot.id ) {
		    s jsonCat.key = rowCID_"||CG"
		    s jsonCat.type = "CG"
		}
	    if (objCat.Type="leaf")
	    {
		     s jsonCat.isLeaf = "true"
		}	    	   
		s jsonCateNew = ##class(%DynamicArray).%New()
		if (jsonCateNew.%Size()<=0)
		{	
			s result = ##Class(EMR.DOC.BL.TextKBCategory).GetJsonCategroyByID(rowCID,GetDataType,jsonRoot,.jsonCateNew)
		}
		s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew		
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

/// Desc:       获取模板操作相关数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_TEXTKB_OPERATION","params":{"userCode":"YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTextKBOperation(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ParentCode = "MENU_GLOSSARY_DATAELMENT"
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.TextKBCategory).GetTextKBOperationJson(ParentCode,UserCode,roleCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取术语操作
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      ParentCode  功能字典目录编码
/// 			UserCode	用户编码
/// OutPut:     argOutData 	返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##Class(EMR.DOC.BL.DataElementCategory).GetTextKBOperationJson(ParentCode,UserCode,.argOutData)
ClassMethod GetTextKBOperationJson(ParentCode As %String, UserCode As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s json = ##Class(%GlobalBinaryStream).%New()
	
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-102"
	s strRoleID =	RoleID
	s jsonObj  = ##class(%DynamicObject).%New()
 	s strRPRowID = ""
 	s strRes = "-301"
	
	//添加右键授权数据
	s jsonFuncMenuNode = ##class(%DynamicObject).%New()
	//添加按钮授权数据
	s arrayFuncBtn = ##class(%DynamicArray).%New()
	s rowFuncItemID = ""
	for {
		s rowFuncItemID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(ParentCode,"U"),rowFuncItemID))
		q:(rowFuncItemID = "")				
		s objFunItem = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowFuncItemID)
		continue:(objFunItem="")
		s strRes="1"
        if (objFunItem.Type.Code="funcMenuNode")
        {
			s Permission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFuncItemID)
			//添加功能菜单授权数据
			s jsonFuncMenu = ##class(%DynamicArray).%New()
			s rowFunMenuID = ""
			for {
				s rowFunMenuID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(objFunItem.FuncCode,"U"),rowFunMenuID))
				q:(rowFunMenuID = "")				
				s objFunMenu = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowFunMenuID)
				s jsonMenu  = ##class(%DynamicObject).%New()
				s jsonMenu.code = objFunMenu.FuncCode
				s jsonMenu.name =objFunMenu.FuncName
				s menuPermission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFunMenuID)
				continue:menuPermission'=2
				d jsonFuncMenu.%Push(jsonMenu)
			}
	        s:($ZCVT(objFunItem.FuncCode,"U")="MENU_GLOSSARY_DATAELMENT_ROOT") jsonFuncMenuNode.root = jsonFuncMenu
	        s:($ZCVT(objFunItem.FuncCode,"U")="MENU_GLOSSARY_DATAELMENT_CATEGORY") jsonFuncMenuNode.category = jsonFuncMenu
	        s:($ZCVT(objFunItem.FuncCode,"U")="MENU_GLOSSARY_DATAELMENT_ELEMENT") jsonFuncMenuNode.element = jsonFuncMenu
	    
        }
        elseif(objFunItem.Type.Code="funcBtnType")
        {
	        s permission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFuncItemID)
			s rowFunMenuID = ""
			for {
				s rowFunMenuID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(objFunItem.FuncCode,"U"),rowFunMenuID))
				q:(rowFunMenuID = "")				
				s objFunMenu = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowFunMenuID)
				s jsonMenu  = ##class(%DynamicObject).%New()
				s jsonMenu.code = objFunMenu.FuncCode
				s jsonMenu.name =objFunMenu.FuncName
				s btnPermission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFunMenuID)
				s jsonMenu.permission = btnPermission
				d arrayFuncBtn.%Push(jsonMenu)
			}
        }
	}
    
    s jsonObj.tree =jsonFuncMenuNode
    s jsonObj.btn =arrayFuncBtn
	d jsonObj.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

}
