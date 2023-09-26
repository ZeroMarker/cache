/// 名称:	EMR.DOC.BL.RouteManage
/// 描述:	菜单管理（NEW）
/// 编写者:	zhangzheyi
/// 编写日期: 	2021-10-28
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.RouteManage Extends EMR.DOC.COM.ActionBase [ ProcedureBlock ]
{

/// Desc:       获取菜单列表
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_ALL_MENU", "params":{"userCode":"YS01" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetAllMenu(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s userCode=argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
	s searchValue = argInJson.params.searchValue
	s jArryMeun = ##class(%DynamicArray).%New()
	if (searchValue = "") {
		s strRes = ##Class(EMR.DOC.BL.RouteManage).GetAllMenuJson(userCode,roleCode,.jArryMeun)
	}
	else 
	{
		s strRes = ##Class(EMR.DOC.BL.RouteManage).GetSearchMenuJson(searchValue,0,.jArryMeun)
	}
    
	if (strRes = "1")
	{ 
	    d jArryMeun.%ToJSON(argOutData)
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","id不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","数据表名不能为空",2)
	}
	elseif (strRes = -103)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","配置表不存在",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","数据表查询失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取菜单列表
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetAllMenuJson(userCode As %String, roleCode As %String, ByRef jsonArr As %DynamicArray) As %String
{
	s strRes = "1"
	s jsonArr = ##class(%DynamicArray).%New()

	s roleId=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(roleId="") "-302"
	s checkId=""
	s seq = ""
	for {
		s seq = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",0,seq))
		q:(seq = "")	
		s rowID = ""	
		for 
			{
			s rowID = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",0,seq,rowID))
			q:(rowID = "")		
			s obj = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowID)
			continue:(obj="")
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.key = obj.%Id()
			s jsonItem.ParentId = ""  	
        	s jsonItem.Name = obj.FuncName
        	s jsonItem.FuncCode=obj.FuncCode
        	s jsonItem.ParentCode=obj.ParentCode
        	s jsonItem.Type = obj.Type.Code
        	s jsonItem.Path = obj.Path      
        	s jsonItem.Icon = obj.Icon
        	s jsonItem.Sequence = obj.Sequence
        	s jsonItem.Perms = obj.Perms
        	s jsonItem.Component = obj.Component
        	s jsonItem.Visible = obj.Visible
        	s jsonItem.UpdateTime = obj.UpdateTime
        	if (roleCode="SuperAdmin")
        	{	s jsonItem.Checked="true"	}
        	else
        	{
				for
				{
					s checkId=$o(^CF.EMR.DOC.RBACOperPermissionI("IdxRoleFunction",roleId,checkId))
					q:checkId=""
					if (checkId=obj.%Id())
					{
						s jsonItem.Checked="true"
					}
				}
        	}	
			s list = ..GetChildrenMenuJson(userCode,roleCode,jsonItem.key)
			
	      	
	    	if (list '= "101") {
		    	s jsonItem.children = list
		 	}
			d jsonArr.%Push(jsonItem)
		
		}
	}
	q strRes
}

/// Desc:       菜单查询
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetSearchMenuJson(SearchText As %String, ParentId As %String, ByRef jsonArr As %DynamicArray) As %String
{
	s strRes = "1"
	s seq = ""
	for {
		s seq = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",ParentId,seq))
		q:(seq = "")	
		s rowID = ""	
		for 
			{
			s rowID = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",ParentId,seq,rowID))
			q:(rowID = "")		
			s obj = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowID)
			continue:((obj="")  || ($find(obj.FuncName,SearchText) = 0))
			
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.key = obj.%Id()
			s jsonItem.ParentId = ""  	
        	s jsonItem.Name = obj.FuncName
        	s jsonItem.Type = obj.Type.Code
         	s jsonItem.FuncCode=obj.FuncCode
        	s jsonItem.ParentCode=obj.ParentCode
	       	s jsonItem.Path = obj.Path      
        	s jsonItem.Icon = obj.Icon
        	s jsonItem.Sequence = obj.Sequence
        	s jsonItem.Perms = obj.Perms
        	s jsonItem.Component = obj.Component
        	s jsonItem.Visible = obj.Visible
        	s jsonItem.UpdateTime = obj.UpdateTime
        	
        	
        	s arrItem = ##class(%DynamicArray).%New()
			s result = ##class(EMR.DOC.BL.RouteManage).GetSearchMenuJson(SearchText,jsonItem.key,.arrItem)
			if (arrItem.%Size() >0) {
					s jsonItem.children = arrItem
			}
			d jsonArr.%Push(jsonItem)
		
		}
	}
	q strRes
}

/// Desc:   获取菜单列表
/// Creator:    zhanzgheyi
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     1 获取数据成功
/// Debug:     
ClassMethod GetChildrenMenuJson(userCode As %String, roleCode As %String, ParentId As %Integer) As %String
{
	
	s strRes = "101"
	s seq = ""
	s roleId=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(roleId="") 

	s checkId=""

	s jsonArr = ##class(%DynamicArray).%New()
	for {
		s seq = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",ParentId,seq))
		q:(seq = "")	
		s rowID = ""	
		for {
			s rowID = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",ParentId,seq,rowID))
			q:(rowID = "")		
			s obj = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowID)
	        continue:(obj="")
	        s strRes = "1"	
	        
	        s jsonMenuDoc  = ##class(%DynamicObject).%New()
	        s jsonMenuDoc.key =obj.%Id()
	        s jsonMenuDoc.ParentId = obj.ParentID
        	s jsonMenuDoc.FuncCode=obj.FuncCode
        	s jsonMenuDoc.ParentCode=obj.ParentCode
	        s jsonMenuDoc.Name =obj.FuncName
	        s jsonMenuDoc.Type =obj.Type.Code
	        s jsonMenuDoc.Path =obj.Path
	        s jsonMenuDoc.Icon =obj.Icon
	        s jsonMenuDoc.Sequence = obj.Sequence
	        s jsonMenuDoc.Perms = obj.Perms
	        s jsonMenuDoc.Component = obj.Component
	        s jsonMenuDoc.Visible = obj.Visible
	        s jsonMenuDoc.UpdateTime = obj.UpdateTime
        	if (roleCode="SuperAdmin")
        	{	s jsonMenuDoc.Checked="true"	}
        	else
        	{
				for
				{
					s checkId=$o(^CF.EMR.DOC.RBACOperPermissionI("IdxRoleFunction",roleId,checkId))
					q:checkId=""
					if (checkId=obj.%Id())
					{
						s jsonMenuDoc.Checked="true"
					}
				}
        	}	
	        
			s list = ..GetChildrenMenuJson(userCode,roleCode,jsonMenuDoc.key)
		    if (list '= "101") {
			    s jsonMenuDoc.children = list
			 }
			 	
			d jsonArr.%Push(jsonMenuDoc)
		}
	}
	q:(jsonArr.%Size()'>0) strRes
	q jsonArr
}

/// Desc:       添加菜单
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"ADD_MENU_DATA","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddMenuData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s strRes = ##Class(EMR.DOC.BL.RouteManage).AddMenuDataJson(argInJson,.argOutData)
    
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","菜单名不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","菜单类型不能为空",2)
	}
	elseif (strRes = -103)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","父节点不存在",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","保存失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Description:   添加菜单数据
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod AddMenuDataJson(argInJson As %DynamicAbstractObject, Properties As %String) As %String
{
	s name = argInJson.params.Name
	q:(name= "") "-1^菜单名不能为空"
	s type = argInJson.params.Type
	q:(type= "") "-102^菜单类型不能为空"
	s params = argInJson.params
	
	TSTART
	s objCompRegistered=##class(CT.EMR.DOC.DictFunction).%New()
	
	s objCompRegistered.Icon = params.Icon
	s objCompRegistered.ParentID = params.ParentId
	if (params.ParentId = ""){
		s objCompRegistered.ParentId = 0
	}
	
	
	s objCompRegistered.FuncName = params.Name
	s objCompRegistered.Sequence = +(^CT.EMR.DOC.DictFunctionD)+1
	s objCompRegistered.ParentCode=params.ParentCode
	s objCompRegistered.FuncCode=params.FuncCode
	s objCompRegistered.Perms = params.Perms
	s objCompRegistered.Path = params.Path
	s typeId=""
	&sql(select id into:typeId from CT_EMR_DOC.DictFunctionTypes where Code=:params.Type )
	s objCompRegistered.Type = ##class(CT.EMR.DOC.DictFunctionTypes).%OpenId(typeId)
	s objCompRegistered.Visible = params.Visible
	s Date = $ZDATE($p($HOROLOG,",",1),3)_" "_$ZTIME($p($HOROLOG,",",2))
	s objCompRegistered.UpdateTime = Date
	s objCompRegistered.Component = params.Component

	s sc = objCompRegistered.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q "-104^保存失败"
	}
	TCOMMIT
	q 1
}

/// Desc:     删除菜单
/// Creator:    duan
/// CreateDate: 2021-06-22
/// Input:      argArray  命令参数 {"action": "DELETE_MENU_DATA","params":{"id":"6"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleMenuData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID = argInJson.params.key
    s strRes = ##Class(EMR.DOC.BL.RouteManage).DeleMenuDataJson(ID)
	if (strRes = 1)
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","参数id未传",2)
	}
	else
	{  
	     q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// desc 删除菜单
/// input aID 关联ID
/// output 成功 1 失败 -201 关联术语id未传 -202 数据元标识符未传 -203 映射list不能为空 -302 数据元值域关联ID不存在
ClassMethod DeleMenuDataJson(aID As %String)
{
	q:(aID="") "-101"
	&sql(Delete from CT_EMR_DOC.DictFunction where ID=:aID)
	q 1
}

/// Desc:       更新菜单数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"UPDATE_MENU_DATA","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateMenuData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id= argInJson.params.key
	s type= argInJson.params.Type
    s strRes = ##Class(EMR.DOC.BL.RouteManage).UpdateMenuDataJson(id,type,argInJson,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","id不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在",2)
	}
	elseif (strRes = -103)
	{  	
		q ..SetOutMessage(argOutMessage,"ERROR","菜单不存在",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","保存失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       更新配置表所属数据表的数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:    
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DynamicConfigTable)GetDynamicConfigTableJson(argOutData)
ClassMethod UpdateMenuDataJson(id As %String, type As %String, argInJson As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(id= "") -101
	q:(type= "") -102
	s params = argInJson.params
	TSTART
	s objCompRegistered=##class(CT.EMR.DOC.DictFunction).%OpenId(id)
	if ('objCompRegistered)
		{
		q 103
	}
    s objCompRegistered.Icon = params.Icon
   	s objCompRegistered.ParentID = params.ParentId
   	if (params.ParentId = "") {
   		s objCompRegistered.ParentId = 0
   	}
	   		
	s objCompRegistered.FuncName = params.Name
	s objCompRegistered.Perms = params.Perms
	s objCompRegistered.Path = params.Path
	s objCompRegistered.ParentCode=params.ParentCode
	s objCompRegistered.FuncCode=params.FuncCode
	s typeId=""
	&sql(select id into:typeId from CT_EMR_DOC.DictFunctionTypes where Code=:params.Type )
	s objCompRegistered.Type = ##class(CT.EMR.DOC.DictFunctionTypes).%OpenId(typeId)
	s objCompRegistered.Visible = params.Visible
	s Date = $ZDATE($p($HOROLOG,",",1),3)_" "_$ZTIME($p($HOROLOG,",",2))
	s objCompRegistered.UpdateTime = Date
	s objCompRegistered.Component = params.Component
 	s sc = objCompRegistered.%Save()
 	
 	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q -104
	}
	TCOMMIT
	q 1
}

/// desc 获取所有目录数据并按照顺序排序
Query GetAllRoute() As %SQLQuery
{
	SELECT * FROM CT_EMR_DOC.DictFunction WHERE ParentID is NULL ORDER BY Sequence
}

/// Desc:       获取不同页面按钮
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_SEARCH_BUTTON", "params":{"userCode":"YS01" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSearchButton(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s parentId = argInJson.params.parentId
	s jArryMeun = ##class(%DynamicArray).%New()
    s strRes = ##Class(EMR.DOC.BL.RouteManage).GetSearchButtonJson(parentId,.jArryMeun)
	if (strRes = "1")
	{ 	
		d jArryMeun.%ToJSON(argOutData)
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","id不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","数据表名不能为空",2)
	}
	elseif (strRes = -103)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","配置表不存在",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","数据表查询失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取不同页面按钮
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetSearchButtonJson(ParentId As %String, ByRef jsonArr As %DynamicArray) As %String
{
	s strRes = "1"
	s seq = ""
	for {
		s seq = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",ParentId,seq))
		q:(seq = "")	
		s rowID = ""	
		for 
			{
			s rowID = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",ParentId,seq,rowID))
			q:(rowID = "")		
			s obj = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowID)
			continue:(obj="")
			
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.key = obj.%Id()  	
        	s jsonItem.Name = obj.FuncName
        	s jsonItem.Type = obj.Type.Code
        	s jsonItem.Sequence = obj.Sequence
        	s jsonItem.Perms = obj.Perms

 
        	
        	
        	s arrItem = ##class(%DynamicArray).%New()
			s result = ##class(EMR.DOC.BL.RouteManage).GetSearchButtonJson(jsonItem.key,.arrItem)
			if (arrItem.%Size() >0) {
					s jsonItem.children = arrItem
			}
			d jsonArr.%Push(jsonItem)
		
		}
	}
	q strRes
}

}
