Class EMRservice.BL.BLECRecordExtraInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       取病历关联附加信息
/// Creator:    Candy
/// CreateDate: 2016-12-12
/// Input:       AID ECRecordID
/// Output:      result xml
/// Debug:       w ##Class(EMRservice.BL.BLECRecordExtraInfo).GetDocumentExtraInfo(1)
ClassMethod GetDocumentExtraInfo(AID As %String) As %String
{
	s result = ""
	q:(AID = "") result
	s rowId = $o(^DHCEMRI.ECRecordExtraInfoI("IdxMain",AID,""))
	q:(rowId = "") result
	s obj = ##Class(EMRinstance.ECRecordExtraInfo).%OpenId(rowId)
	q:(obj = "") result
	s result = result_"<LastModifyPosition>"
	s result = result_obj.LastModifyPosition
	s result = result_"</LastModifyPosition>"
	q result
}

/// Desc:       设置病历关联附加信息
/// Creator:    Candy
/// CreateDate: 2016-12-13
/// Input:      AInstanceID 病历ID
///            ALastModifyPos 最后一次修改位置
/// Output:     result "" 失败 1成功
/// Debug:      w ##Class(EMRservice.BL.BLInstanceExtraInfo).SetDocumentExtraInfo("2||12",16)
ClassMethod SetDocumentExtraInfo(AID As %String, ALastModifyPos As %String) As %String
{
	s result = ""
	q:(AID = "") result
	s rowId = $o(^DHCEMRI.ECRecordExtraInfoI("IdxMain",AID,""))
	if (rowId = "")
	{
		s objExtra = ##Class(EMRinstance.ECRecordExtraInfo).%New()
		s objExtra.ECRecordID = AID
	}
	else
	{ 
		s objExtra = ##Class(EMRinstance.ECRecordExtraInfo).%OpenId(rowId)
	}
	s objExtra.LastModifyPosition = ALastModifyPos
	s sc = objExtra.%Save()
	s:($$$ISOK(sc)) result = 1
	q result
}

}
