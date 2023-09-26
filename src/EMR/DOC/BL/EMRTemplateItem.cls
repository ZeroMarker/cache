/// 名称:	EMR.DOC.BL.EMRTemplateItem
/// 描述:	病历模板
/// 编写者：zhangxl
/// 编写日期: 2021-9-24
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRTemplateItem Extends EMR.DOC.COM.ActionBase
{

/// Desc:       添加文档模板
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数 {"action":"SAVE_TEMPLATE_ITEM","params":{"groupID":"0","tempID":"30","tempName":"手术同意书"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据str
ClassMethod SaveTemplateItem(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s groupID = argInJson.params.groupID
	s tempID = argInJson.params.tempID
	s tempName = argInJson.params.tempName
    s strRes = ##Class(EMR.DOC.BL.EMRTemplateItem).SaveTemplateItemJson(groupID,tempID,tempName)
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif(strRes = "-200")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","name不能为空","2")
	}
	elseif(strRes = "-300")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","模板已存在","2")
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       添加文档模板
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.Spechars).CreateSpecharsJson()
ClassMethod SaveTemplateItemJson(groupID As %String, tempID As %String, tempName As %String)
{
	s strRes ="-100"
	q:(tempName="") "-200"
	s count=0
	&sql(SELECT count(*) into :count FROM CF_EMR_DOC.EMRTemplateItem WHERE EMRTemplateID = :tempID )
 	q:(count>0) "-300"
	s obj=##class(CF.EMR.DOC.EMRTemplateItem).%New()
	s obj.TemplateGroupCode=groupID
	s obj.EMRTemplateID=tempID
	s obj.EMRTemplateName=tempName
	s obj.TemplateSeq = $case($d(^CF.EMR.DOC.EMRTemplateItemD)>0,0:1,:^CF.EMR.DOC.EMRTemplateItemD+1)
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{		
		 q obj.%Id()
	}
	else
	{
		 q strRes
	}
}

/// Desc:       添加文档模板
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数 {"action":"SAVE_TEMPLATE_ITEM","params":{"groupID":"0","tempID":"30","tempName":"手术同意书"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据str
ClassMethod AddTemplateItem(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	TSTART
	s arry = argInJson.params 
	s intIDSize = arry.%Size()
	for i=0:1:(intIDSize-1)
	{
		s jItem = arry.%Get(i)
		s jsonObj  = ##class(%DynamicObject).%New()
		s jsonObj.groupID = jItem.groupID
		s jsonObj.tempID  = ##Class(EMR.DOC.COM.ActionBase).GetIDByKey(jItem.tempID)
		s jsonObj.tempName = jItem.tempName 
		s result = ##Class(EMR.DOC.BL.EMRTemplateItem).AddTemplateItemJson(jsonObj,.argOutData)
		s strRes =result 
		continue:(result = "-300") 
		if ((result '= "1")){
			TROLLBACK
			q
		}
		
	}  
	TCOMMIT
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif(strRes = "-200")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","name不能为空","2")
	}
	elseif(strRes = "-300")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","模板已存在","2")
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       添加文档模板
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.Spechars).CreateSpecharsJson()
ClassMethod AddTemplateItemJson(Obj As %DynamicObject, Properties As %String) As %String
{
	
	s groupID = Obj.groupID
	s tempID = Obj.tempID
	s tempName = Obj.tempName
	q:(tempName= "") -200
	
	s count=0
	&sql(SELECT count(*) into :count FROM CF_EMR_DOC.EMRTemplateItem WHERE EMRTemplateID = :tempID )
 	q:(count>0) "-300"
	
	
	TSTART
	s ObjItem=##class(CF.EMR.DOC.EMRTemplateItem).%New()
	
	s ObjItem.TemplateGroupCode=groupID
	s ObjItem.EMRTemplateID=tempID
	s ObjItem.EMRTemplateName=tempName
	s ObjItem.TemplateSeq = $case($d(^CF.EMR.DOC.EMRTemplateItemD)>0,0:1,:^CF.EMR.DOC.EMRTemplateItemD+1)
	
	
	s sc = ObjItem.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q -100
	}
	TCOMMIT
	q 1
}

/// Desc:       删除文档模板
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数 {"action":"DELETE_TEMPLATE_ITEM","params":{"id":"0"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据str
ClassMethod DeleteTemplateItem(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s tempID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.EMRTemplateItem).DeleteTemplateItemJson(tempID)
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
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到","2")
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       删除文档模板
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.EMRTemplateItem).DeleteTemplateItemJson()
ClassMethod DeleteTemplateItemJson(tempID As %String)
{
	s strRes = "-100"
	q:(tempID="") "-200"
    s obj = ##Class(CF.EMR.DOC.EMRTemplateItem).%OpenId(tempID)
	q:(obj="") "-300"
	s sc = ##Class(CF.EMR.DOC.EMRTemplateItem).%DeleteId(tempID)
    q "1"
}

/// Desc:       批量删除文档模板
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数 {"action":"DELETE_BATCH_ITEMS","params":{"id":"0"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据str
ClassMethod DeleteBatchItems(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s tempID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.EMRTemplateItem).DeleteBatchItemsJson(tempID)
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
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到","2")
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       删除文档模板
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.EMRTemplateItem).DeleteTemplateItemJson()
ClassMethod DeleteBatchItemsJson(tempID As %String)
{
	s strRes = "-100"
	q:(tempID="") "-200"
	S IDCount =$L(tempID,"^") 
	TSTART 
	For I=1:1:IDCount
	
	{
		s id = $p(tempID,"^",I)
		continue:(id="")
		s obj = ##Class(CF.EMR.DOC.EMRTemplateItem).%OpenId(id)
		if (obj="")
		{
			TROLLBACK
			s strRes = "-300"
			q 
		}
	    s sc = ##Class(CF.EMR.DOC.EMRTemplateItem).%DeleteId(id)
		
		}
		TCOMMIT
    s strRes = "1"
	q strRes
}

/// Desc:       获取分组下的所有文档
/// Creator:    zhangxl
/// CreateDate: 2021-11-24
/// Input:      argArray  命令参数 {"action":"GET_TEMPLATE_ITEM_BYID","params":{"id":1},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTemplateItemById(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s groupID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.EMRTemplateItem).GetTemplateItemByIdJson(groupID,.argOutData)
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

/// Desc:       获取分组下的所有文档
/// Creator:    zhangxl
/// CreateDate: 2021-11-24
/// OutPut:     argOutData 返回数据
ClassMethod GetTemplateItemByIdJson(groupID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	
	s seq =""
	s jsonArr = ##class(%DynamicArray).%New()
	for
	{
		s seq = $o(^CF.EMR.DOC.EMRTemplateItemI("IdxTemplateGroupSeq",groupID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^CF.EMR.DOC.EMRTemplateItemI("IdxTemplateGroupSeq",groupID,seq,rowId))
			q:(rowId = "")
			s obj = ##Class(CF.EMR.DOC.EMRTemplateItem).%OpenId(rowId)
			continue:(obj = "")
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.id= rowId
			s jsonItem.code= obj.EMRTemplateID
			s jsonItem.name= obj.EMRTemplateName
			d jsonArr.%Push(jsonItem)
		}
	}
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

}
