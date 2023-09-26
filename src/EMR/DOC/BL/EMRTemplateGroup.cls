/// 名称:	EMR.DOC.BL.EMRTemplateGroup
/// 描述:	病历分组类
/// 编写者：zhangxl
/// 编写日期: 2021-9-24
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRTemplateGroup Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取所有分组列表
/// Creator:    zhangxl
/// CreateDate: 2021-11-15
/// Input:      argArray  命令参数 {"action":"GET_ALL_GROUPS","params":{},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetAllGroups(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.EMRTemplateGroup).GetAllGroupsJson(.argOutData)
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

/// Desc:       获取所有分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.SpecharsCategory).GetAllGroupsJson(.argOutData)
ClassMethod GetAllGroupsJson(ByRef argOutData As %GlobalBinaryStream)
{
	s TemplateGroupName =""
	s jsonArr = ##class(%DynamicArray).%New()
	for
	{
		s TemplateGroupName = $o(^CF.EMR.DOC.EMRTemplateGroupI("IdxTemplateGroupName",TemplateGroupName))
		q:(TemplateGroupName = "")
		s rowId = ""
		for
		{
			s rowId = $o(^CF.EMR.DOC.EMRTemplateGroupI("IdxTemplateGroupName",TemplateGroupName,rowId))
			q:(rowId = "")
			s obj = ##Class(CF.EMR.DOC.EMRTemplateGroup).%OpenId(rowId)
			continue:(obj = "")
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.id= rowId
			s jsonItem.key= rowId
			s jsonItem.code= obj.TemplateGroupCode
			s jsonItem.title= obj.TemplateGroupName
			s jsonItem.time= obj.ModifyDate
			s jsonItem.seq= obj.TemplateSeq
			s jsonItem.locTitle= obj.LocTitle
			d jsonArr.%Push(jsonItem)
		}
	}
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       创建分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数 {"action":"CREATE_TEMPLATE_GROUP","params":{"code":"0","title":"&&&"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod CreateTemplateGroup(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s groupCODE = argInJson.params.code
	s groupNAME = argInJson.params.title
    s strRes = ##Class(EMR.DOC.BL.EMRTemplateGroup).CreateTemplateGroupJson(groupCODE,groupNAME)
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","分组code不能为空",2)	
	}
	elseif (strRes = "-300")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","名称不能为空",2)	
	}
	elseif (strRes = "-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","分组code已存在",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       创建分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     argOutData 返回数据
/// Debug:      ##Class(EMR.DOC.BL.EMRTemplateGroup).CreateTemplateGroupJson(groupCODE,groupNAME)
ClassMethod CreateTemplateGroupJson(groupCODE As %String, groupNAME As %String)
{
	s strRes ="-100"	
	q:(groupCODE="") "-200"
	q:(groupNAME="") "-300"
	s count=0
	&sql(SELECT count(*) into :count FROM CF_EMR_DOC.EMRTemplateGroup WHERE TemplateGroupCode = :groupCODE )
 	q:(count>0) "-301"
	s objTemplateGroup=##class(CF.EMR.DOC.EMRTemplateGroup).%New()
	s objTemplateGroup.TemplateGroupCode= groupCODE
	s objTemplateGroup.TemplateGroupName= groupNAME
	s Date = $ZDATE($p($HOROLOG,",",1),3)_" "_$ZTIME($p($HOROLOG,",",2))
	s objTemplateGroup.CreateDate= Date
	s objTemplateGroup.CreateTime= $p($h,",",2)
	s objTemplateGroup.ModifyDate= Date
	s objTemplateGroup.ModifyTime= $p($h,",",2)
	s objTemplateGroup.TemplateSeq = (^CF.EMR.DOC.EMRTemplateGroupD +1)
	;$case($d(^CF.EMR.DOC.EMRTemplateGroupI)>0,0:1,:^CF.EMR.DOC.EMRTemplateGroupI+1)
	s sc = objTemplateGroup.%Save()
	if ($$$ISOK(sc))
	{		
		q objTemplateGroup.%Id()
	}
	else
	{
		q strRes	
	}
}

/// Desc:       更新分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数 {"action":"UPDATE_TEMPLATE_GROUP","params":{"id":"1","code":"0","title":"&&&"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateTemplateGroup(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s groupID = argInJson.params.id
	s groupCODE = argInJson.params.code
	s groupNAME = argInJson.params.title
    s strRes = ##Class(EMR.DOC.BL.EMRTemplateGroup).UpdateTemplateGroupJson(groupID,groupCODE,groupNAME)
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","分组code不能为空",2)	
	}
	elseif (strRes = "-300")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","名称不能为空",2)	
		
	}
	elseif (strRes = "-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","分组code找不到",2)
	}
	elseif (strRes = "-302")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","分组code已存在",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       更新分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     
/// Debug:    w ##UpdateTemplateGroupJson(groupCODE As %String, groupNAME As %String)
ClassMethod UpdateTemplateGroupJson(groupID As %String, groupCODE As %String, groupNAME As %String) As %String
{
	
	s strRes ="-100"	
	q:(groupCODE="") "-200"
	q:(groupNAME="") "-300"
	
	TSTART
	s obj = ##class(CF.EMR.DOC.EMRTemplateGroup).%OpenId(groupID)
	if (obj="")
	{
		TROLLBACK
		q "-301"
	}
	

	s obj.TemplateGroupCode= groupCODE
	s obj.TemplateGroupName= groupNAME
	s Date = $ZDATE($p($HOROLOG,",",1),3)_" "_$ZTIME($p($HOROLOG,",",2))
	s obj.ModifyDate= Date
 	
	if '(obj.%Save())
 	{
	 	TROLLBACK
		q strRes
	} 
	TCOMMIT
	s strRes = "1"
	q strRes
}

/// Desc:       删除分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数 {"action":"DELETE_TEMPLATE_GROUP","params":{"id":1},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteTemplateGroup(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s groupID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.EMRTemplateGroup).DeleteTemplateGroupJson(groupID)
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","删除失败","2")
	}
	elseif(strRes = "-200")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空","2")
	}
	elseif(strRes = "-300")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到分组目录","2")
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       删除分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.Spechars).UpdateSpecharsJson(strID,strNAME)
ClassMethod DeleteTemplateGroupJson(groupID As %String) As %String
{
	
	
	s strRes = "-100"
	q:(groupID="") "-200"
    s obj = ##Class(CF.EMR.DOC.EMRTemplateGroup).%OpenId(groupID)
	q:(obj="") "-300"
	s sc = ##Class(CF.EMR.DOC.EMRTemplateGroup).%DeleteId(groupID)
	if (sc=1)
	{
		&sql(delete  from CF_EMR_DOC.EMRTemplateItem where TemplateGroupCode=:groupID)
	}
    q "1"
}

}
