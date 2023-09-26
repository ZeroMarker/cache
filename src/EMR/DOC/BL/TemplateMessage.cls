/// 名称：		EMR.DOC.BL.TemplateMessage
/// 描述：		模板提示信息业务逻辑类
/// 编写者：	huhao
/// 编写时间：	2021-11-2
Class EMR.DOC.BL.TemplateMessage Extends EMR.DOC.COM.ActionBase
{

/// Creator:	huhao
/// CreatDate:  2021-11-11
/// Desc:		获取模板提示信息
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod GetTmpMsg(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s TmpName=argInJson.params.templateName
	s TmpMsg=argInJson.params.templatemsg
    s strRes = ##class(EMR.DOC.BL.TemplateMessage).GetMsg(TmpName,TmpMsg,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查询到内容",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod GetMsg(TemplateName As %String, TemMessage As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s rowId=""
	s resJson=##class(%DynamicArray).%New()
	for
	{
		;$find(obj.MenuName,SearchText) = 0
		s resObj=##class(%DynamicObject).%New()
		s rowId=$o(^CF.EMR.DOC.TemplateMessageD(rowId))
		q:rowId=""
		s obj = ##Class(CF.EMR.DOC.TemplateMessage).%OpenId(rowId)
		;q:TemplateName=""&&TemMessage=""
		if ((TemplateName'="") && (TemMessage=""))
		{
			if ($find(obj.TemplateName,TemplateName)'=0)
			{
				s resObj.key=rowId
				s resObj.templateId=obj.TemplateID
				s resObj.templateName=obj.TemplateName
				s resObj.templatemsg=obj.TemMessage
				d resJson.%Push(resObj)
			}
			else{break}
		}
		elseif ((TemplateName="")&&(TemMessage'=""))
		{
			if ($find(obj.TemMessage,TemMessage)'=0)
			{
				s resObj.key=rowId
				s resObj.templateId=obj.TemplateID
				s resObj.templateName=obj.TemplateName
				s resObj.templatemsg=obj.TemMessage
				d resJson.%Push(resObj)
			}
			else{break}
		}
		elseif ((TemplateName'="")&&(TemMessage'=""))
		{
			if ($find(obj.TemMessage,TemMessage)'=0 && $find(obj.TemplateName,TemplateName)'=0)
			{
				s resObj.key=rowId
				s resObj.templateId=obj.TemplateID
				s resObj.templateName=obj.TemplateName
				s resObj.templatemsg=obj.TemMessage
				d resJson.%Push(resObj)
			}
			else {break}	
		}
		elseif ((TemplateName="")&&(TemMessage=""))
		{
				s resObj.key=rowId
				s resObj.templateId=obj.TemplateID
				s resObj.templateName=obj.TemplateName
				s resObj.templatemsg=obj.TemMessage
				d resJson.%Push(resObj)
		}
	}
	d resJson.%ToJSON(argOutData)
	q "1"
}

/// Creator:	huhao
/// CreatDate:  2021-11-11
/// Desc:		新建模板提示信息
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod AddTmpMsg(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s Tmpmsgid=argInJson.params.templateId
	s Tmpmsgname=argInJson.params.templateName
	s Tmpmsgdesc=argInJson.params.templatemsg
    s strRes = ##class(EMR.DOC.BL.TemplateMessage).AddMsg(Tmpmsgid,Tmpmsgname,Tmpmsgdesc)
	if (strRes = "1")
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
	    q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod AddMsg(TmpMsgId As %String, TmpMsgName As %String, TmpMsgDesc As %String) As %String
{
	q:TmpMsgId="" "-1^模板id不能为空"
	s rowId=""
	s obj=##class(CF.EMR.DOC.TemplateMessage).%New()
	s rowId=$o(^CF.EMR.DOC.TemplateMessageI("IdxTemplateID"," "_$zcvt(TmpMsgId,"U"),rowId))
	q:rowId'="" "-1^模板id不能重复"
	s obj.TemplateID=TmpMsgId
	s obj.TemplateName=TmpMsgName
	S obj.TemMessage=TmpMsgDesc
	s s=obj.%Save()
	q s
}

/// Creator:	huhao
/// CreatDate:  2021-11-17
/// Desc:		更新模板提示信息
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod UpdateTmpMsg(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=argInJson.params.Id
	s Tmpmsgid=argInJson.params.TemplateId
	s Tmpmsgname=argInJson.params.TemplateName
	s Tmpmsgdesc=argInJson.params.TemMessage
    s strRes = ##class(EMR.DOC.BL.TemplateMessage).UpdateMsg(id,Tmpmsgid,Tmpmsgname,Tmpmsgdesc)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","更新失败，请检查参数",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod UpdateMsg(id As %String, Tmpmsgid As %String, TmpMsgName As %String, TmpMsgDesc As %String) As %String
{
	s strRes=""
	q:id="" "-1^id不能为空"
	q:Tmpmsgid="" "-1^模板id不能为空"
	s obj=##class(CF.EMR.DOC.TemplateMessage).%OpenId(id)
	if (obj.TemplateID=Tmpmsgid)
	{
		s obj.TemMessage=TmpMsgDesc
		s obj.TemplateName=TmpMsgName
		d obj.%Save()
		s strRes="1"
	}
	else
	{
		s rowId=$o(^CF.EMR.DOC.TemplateMessageI("IdxTemplateID"," "_$zcvt(Tmpmsgid,"U"),""))
		q:rowId'="" "-1^模板id重复"
		s obj.TemplateID=Tmpmsgid
		s obj.TemMessage=TmpMsgDesc
		s obj.TemplateName=TmpMsgName
		d obj.%Save()
		s strRes="1"
	}	
	q strRes
}

/// Creator:	huhao
/// CreatDate:  2021-11-17
/// Desc:		删除模板提示信息
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod DeleteTmpMsg(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=argInJson.params.Id
    s strRes = ##class(EMR.DOC.BL.TemplateMessage).DeleteMsg(id)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod DeleteMsg(id As %String) As %String
{
	s obj=##class(CF.EMR.DOC.TemplateMessage).%OpenId(id)
	q:obj="" "2"
	&sql(DELETE FROM CF_EMR_DOC.TemplateMessage WHERE ID=:id)
	q "1"
}

}
