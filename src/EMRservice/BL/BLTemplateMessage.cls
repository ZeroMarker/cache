/// 名称：EMRservice.BL.BLTemplateMessage
/// 描述:模板消息提示维护BL
/// 编写者：yejian
/// 编写日期: 2019-9-9
Class EMRservice.BL.BLTemplateMessage Extends (%RegisteredObject, %XML.Adaptor)
{

/// 获取所有数据
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTemplateMessage","SelectAll")
Query SelectAll() As %Query(ROWSPEC = "ID:%Integer,TemplateID:%String,TemplateName:%String,TemMessage:%String")
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.TemplateMessageD(rowID))
		q:(rowID = "")
		s objTemMessage = ##Class(EMRmeta.TemplateMessage).%OpenId(rowID)
		continue:(objTemMessage = "")
	
		s TemplateID = objTemMessage.TemplateID
		s TemplateName = objTemMessage.TemplateName
		s TemMessage = objTemMessage.TemMessage
		s Data = $lb(rowID,TemplateID,TemplateName,TemMessage)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
		
	}
	
	q $$$OK
}

ClassMethod SelectAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectAllExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectAllExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 根据模板ID获取模板消息
ClassMethod GetTemMessageByID(aTemID As %String) As EMRservice.entity.ETemplateMessage
{
	s ARowID = ""
	s ARowID = $o(^DHCEMRM.TemplateMessageI("IdxTemplateID"," "_$zcvt(aTemID,"U"),ARowID))
	q:(ARowID = "") ""
	s objTemMessage = ##Class(EMRmeta.TemplateMessage).%OpenId(ARowID)
	q:(objTemMessage = "") ""
	
	s Result = ##Class(EMRservice.entity.ETemplateMessage).%New()
	s Result.ID = objTemMessage.%Id()
	s Result.TemplateID = objTemMessage.TemplateID
	s Result.TemplateName = objTemMessage.TemplateName
	s Result.TemMessage = objTemMessage.TemMessage
	q Result
}

/// 更新
ClassMethod UpdateData(aTemMessage As EMRservice.entity.ETemplateMessage) As %String
{
	set objTemMessage = ##class(EMRmeta.TemplateMessage).%OpenId(aTemMessage.ID)
	q:(objTemMessage="") "0"
	set objTemMessage.TemplateID = aTemMessage.TemplateID
	set objTemMessage.TemplateName = aTemMessage.TemplateName
	set objTemMessage.TemMessage = aTemMessage.TemMessage
	s status = objTemMessage.%Save()
	q:('$$$ISOK(status)) "0"	
	q "1"
}

/// 增加
ClassMethod AddData(aTemMessage As EMRservice.entity.ETemplateMessage) As %String
{
	set objTemMessage = ##class(EMRmeta.TemplateMessage).%New()
	set objTemMessage.TemplateID = aTemMessage.TemplateID
	set objTemMessage.TemplateName = aTemMessage.TemplateName
	set objTemMessage.TemMessage = aTemMessage.TemMessage
	s status = objTemMessage.%Save()
	q:('$$$ISOK(status)) "0"	
	q "1"
}

/// 删除
ClassMethod DeleteData(rowID As %String) As %String
{
	set objTemMessage = ##class(EMRmeta.TemplateMessage).%OpenId(rowID)
	q:(objTemMessage="") "0"
	s status = objTemMessage.%DeleteId(rowID)
	q:('$$$ISOK(status)) "0"	
	q "1"
}

}
