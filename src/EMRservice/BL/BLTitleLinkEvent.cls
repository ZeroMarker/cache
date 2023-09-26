/// Desc:       标题与事件关联逻辑类
/// Creator:    Donglulu
/// CreateDate: 2021-4-9
Class EMRservice.BL.BLTitleLinkEvent Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       获取标题关联事件code
/// Creator:    Donglulu
/// CreateDate: 2021-4-9
/// Input:      ATitleCode 标题Code
/// Output:     标题Code
/// Debug:      w ##Class(EMRservice.BL.BLTitleLinkEvent).GetEventCodeByTitle("EMR100003")
ClassMethod GetEventCodeByTitle(ATitleCode As %String) As %String
{
	s result = ""
	q:(ATitleCode = "") result
	s linkId = $o(^DHCEMRM.TitleLinkEventI("IdxTitleCode"," "_$zcvt(ATitleCode,"U"),""))
	q:(linkId = "") result
	
	s objLink = ##Class(EMRmeta.TitleLinkEvent).%OpenId(linkId)
	s result = objLink.EventCode

	q result
}

/// Desc:       获取所有事件数据
/// Creator:    yejian
/// CreateDate: 2021-4-19
/// Input:      
/// Output:     事件数据
/// Debug:      d ##class(%ResultSet).RunQuery("EMRservice.BL.BLTitleLinkEvent","GetEventTypes")
Query GetEventTypes() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,TypeCode,TypeDesc", SELECTMODE = "RUNTIME")
{
	SELECT ID,TypeCode,TypeDesc
	FROM EMRmeta_Events.EventType
}

/// Desc:       获取所有事件数据
/// Creator:    yejian
/// CreateDate: 2021-4-19
/// Input:      
/// Output:     事件数据
/// Debug:      d ##Class(EMRservice.BL.BLTitleLinkEvent).GetTitleEventByCode("EMR0001")
ClassMethod GetTitleEventByCode(aTitleCode As %String) As EMRservice.entity.ETitleLinkEvent
{
	s objEntity = ##class(EMRservice.entity.ETitleLinkEvent).%New()
	q:(aTitleCode = "") obj
	s rowId = $o(^DHCEMRM.TitleLinkEventI("IdxTitleCode"," "_$zcvt(aTitleCode,"U"),""))
	if (rowId '= "")
	{
		s obj = ##Class(EMRmeta.TitleLinkEvent).%OpenId(rowId)
		s objEntity.ID = rowId
		s objEntity.TitleCode = obj.TitleCode
		s objEntity.EventCode = obj.EventCode
	}
	q objEntity
}

/// Desc:       更新标题和事件关联
/// Creator:    yejian
/// CreateDate: 2021-4-19
/// Input:      
/// Output:     事件数据
/// Debug:      d ##Class(EMRservice.BL.BLTitleLinkEvent).UpdateTitleLinkEvnet(aETitleLEvent)
ClassMethod UpdateTitleLinkEvnet(aETitleLEvent As EMRservice.entity.ETitleLinkEvent) As %String
{
	s result = "-1"
	q:(aETitleLEvent = "")||(aETitleLEvent.TitleCode = "") result
	s rowId = $o(^DHCEMRM.TitleLinkEventI("IdxTitleCode"," "_$zcvt(aETitleLEvent.TitleCode,"U"),""))
	//事件编码为空删除
	if (aETitleLEvent.EventCode="")||(aETitleLEvent.EventCode=$c(0))
	{
		if (rowId '= "")
		{
			s result= ##Class(EMRservice.BL.BLTitleLinkEvent).DeleteTitleLinkEvnet(rowId)
		}
	}
	else
	{
		if (rowId = "")
		{
			s obj = ##Class(EMRmeta.TitleLinkEvent).%New()
			s obj.TitleCode = aETitleLEvent.TitleCode
			s obj.EventCode = aETitleLEvent.EventCode
		}
		else
		{
			s obj = ##Class(EMRmeta.TitleLinkEvent).%OpenId(rowId)
			s obj.TitleCode = aETitleLEvent.TitleCode
			s obj.EventCode = aETitleLEvent.EventCode
		}
		s sc = obj.%Save()
		if ($$$ISOK(sc)) 
		{
		 	s result = "1" 
		}
	}
	q result
}

/// Desc:       删除标题和事件关联
/// Creator:    yejian
/// CreateDate: 2021-4-19
/// Input:      
/// Output:     事件数据
/// Debug:      d ##Class(EMRservice.BL.BLTitleLinkEvent).DeleteTitleLinkEvnet(1)
ClassMethod DeleteTitleLinkEvnet(RowID As %String) As %String
{
	s ret = "1"
	q:(RowID="") ret
	//原有数据进行“删除”,将数据ActiveFlag设置为0
	s obj = ##class(EMRmeta.TitleLinkEvent).%OpenId(RowID)
	q:(obj="") ret
	if '(obj.%DeleteId(RowID))
	{
		s ret = "-1"	
	}
	d obj.%Close()
	
	q ret
}

}
