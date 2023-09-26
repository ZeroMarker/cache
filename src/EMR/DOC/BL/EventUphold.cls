/// 名称：		EMR.DOC.BL.EventUphold
/// 描述：		事件维护业务逻辑类
/// 编写者：	huhao
/// 编写时间：	2021-12-1
Class EMR.DOC.BL.EventUphold Extends EMR.DOC.COM.ActionBase
{

ClassMethod GetEventList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s EventType=argInJson.params.EventType

    s strRes = ##class(EMR.DOC.BL.EventUphold).GetEventU(EventType,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查到签名角色信息",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod GetEventU(EventType As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s rowId=""
	s resJson=##class(%DynamicArray).%New()
	for 
	{
		s resObj=##class(%DynamicObject).%New()
		s rowId=$o(^CF.EMR.DOC.EventConfigD(rowId))
		s obj=##class(CF.EMR.DOC.EventConfig).%OpenId(rowId)
		q:obj=""
		if (EventType="")
		{
			s resObj.key=rowId
			s ID=$o(^CF.EMR.DOC.EventTypeI("TypeCodeIndex"," "_$zcvt(obj.EventType,"U"),""))
			s Sobj=##class(CF.EMR.DOC.EventType).%OpenId(ID)
			s resObj.EventType=Sobj.TypeDesc
			s resObj.Location=obj.Location
			s resObj.LinkDocID=obj.LinkDocID
			s resObj.PromptMessage=obj.PromptMessage
			s resObj.LinkTitleCode=..getTitle(Sobj.TypeCode)
			s resObj.Scheme=obj.Scheme
			d resJson.%Push(resObj)

		}
		else
		{
			if ($find(obj.EventType,EventType)'=0)
			{
				s resObj.key=rowId
				s ID=$o(^CF.EMR.DOC.EventTypeI("TypeCodeIndex"," "_$zcvt(obj.EventType,"U"),""))
				s Sobj=##class(CF.EMR.DOC.EventType).%OpenId(ID)
				s resObj.EventType=Sobj.TypeDesc
				s resObj.Location=obj.Location
				s resObj.LinkDocID=obj.LinkDocID
				s resObj.PromptMessage=obj.PromptMessage
				s resObj.LinkTitleCode=..getTitle(Sobj.TypeCode)
				s resObj.Scheme=obj.Scheme
				d resJson.%Push(resObj)
			}
			else{break}
			

		}
	}	
	d resJson.%ToJSON(argOutData)
	q "1"
}

ClassMethod getTitle(code As %String) As %String
{
	s title=..QueryDesc(code)
	s res="",EMRName=""
	while title.%Next()
	{
		s titlecontent=title.GetDataByName("ID")
		&sql(select name into:EMRName from CF_EMR_DOC.TEMPLATECATEGORY WHERE Title=:titlecontent)
		s res=EMRName_","_res
	}
	q res
}

ClassMethod QueryDesc(EventCode As %String) As %XML.DataSet
{
 	s dataset = ##Class(%XML.DataSet).%New("%DynamicQuery:SQL")
 	s sql = "SELECT ID FROM CF_EMR_DOC.Titles WHERE EventCode='"_EventCode_"'"
	s status=dataset.Prepare(sql)
	d dataset.Execute()
	if $$$ISERR(status) { q "" }
    q dataset
}

ClassMethod UpdateEventList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s EventType=argInJson.params.EventType
	q:EventType=""
	s LinkTitleCode=argInJson.params.LinkTitleCode
	s LinkDocID=argInJson.params.LinkDocID
	s PromptMessage=argInJson.params.PromptMessage
	s Location=argInJson.params.Location
	s Scheme=argInJson.params.Scheme
    s strRes = ##class(EMR.DOC.BL.EventUphold).UpdateEventU(EventType,LinkTitleCode,LinkDocID,PromptMessage,Location,Scheme,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","参数有误，修改失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod UpdateEventU(EventType As %String, LinkTitleCode As %String, LinkDocID As %String, PromptMessage As %String, Location As %String, Scheme As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s nam=..getcode(EventType)
	s rowId=$o(^CF.EMR.DOC.EventConfigI("EventTypeIndex"," "_$zcvt(nam,"U"),""))
	s obj=##class(CF.EMR.DOC.EventConfig).%OpenId(rowId)
	s obj.LinkDocID=LinkDocID
	;s obj.LinkTitleCode=LinkTitleCode
	s obj.Location=Location
	s obj.PromptMessage=PromptMessage
	s obj.Scheme=Scheme
	s s=obj.%Save()
	q s
}

ClassMethod getcode(val As %String) As %String
{
	s res=""
	&sql(select count(*) into countc from CF_EMR_DOC.EventType)
	for i=1:1:countc
	{
		s obj=##class(CF.EMR.DOC.EventType).%OpenId(i)
		if (obj.TypeDesc=val)
		{
			s res=obj.TypeCode
		}	
	}
	q res
}

ClassMethod GetEventConfig(EventType As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	
	
	
	s tmpId=""
	s tmpId = $o(^CF.EMR.DOC.EventConfigI("EventTypeIndex"," "_$zcvt(EventType,"U"),tmpId))
	q:(tmpId="") 1

	s objEventCfg=##class(CF.EMR.DOC.EventConfig).%OpenId(tmpId)
	q:(objEventCfg="") 1

	s json={}
	//EventType,TypeDesc,LinkDocID,LinkTitleCode,PromptMessage,Location,Scheme
	s json.EventType=objEventCfg.EventType
	s json.Location=objEventCfg.Location
	s json.LinkDocID=objEventCfg.LinkDocID
	s json.PromptMessage=objEventCfg.PromptMessage
	s json.LinkTitleCode=..getTitle(objEventCfg.EventType)
	s json.Scheme=objEventCfg.Scheme


	d json.%ToJSON(argOutData)
	q "1"
}

}
