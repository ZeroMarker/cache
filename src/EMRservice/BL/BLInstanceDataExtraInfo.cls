Class EMRservice.BL.BLInstanceDataExtraInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       取病历关联附加信息
/// CreateDate: 2020-8-17
/// Input:      AInstanceID 病历ID
/// Output:     result xml
/// Debug:      w ##Class(EMRservice.BL.BLInstanceDataExtraInfo).GetDocumentExtraInfo("1||1")
ClassMethod GetDocumentExtraInfo(AInstanceID As %String) As %String
{
    s result = ""
    q:(AInstanceID = "") result
    s rowId = $o(^DHCEMRI.InstanceDataExtraInfoI("IdxMain"," "_AInstanceID,""))
    q:(rowId = "") result
    s obj = ##Class(EMRinstance.InstanceDataExtraInfo).%OpenId(rowId)
    q:(obj = "") result
    s result = result_"<PageBreak>"
    s result = result_obj.PageBreak
    s result = result_"</PageBreak>"
    q result
}

/// Desc:       设置病历关联附加信息
/// CreateDate: 2020-8-17
/// Input:      AInstanceID 病历ID
///             APageBreak 病历的另起页状态
/// Output:     result "" 失败 1成功
/// Debug:      w ##Class(EMRservice.BL.BLInstanceDataExtraInfo).SetDocumentExtraInfo("1||1","1")
ClassMethod SetDocumentExtraInfo(AInstanceID As %String, APageBreak As %String) As %String
{
    s result = ""
    q:(AInstanceID = "") result
    s rowId = $o(^DHCEMRI.InstanceDataExtraInfoI("IdxMain"," "_AInstanceID,""))
    if (rowId = "")
    {
        s objExtra = ##Class(EMRinstance.InstanceDataExtraInfo).%New()
        s objExtra.InstanceID = AInstanceID
    }
    else
    { 
        s objExtra = ##Class(EMRinstance.InstanceDataExtraInfo).%OpenId(rowId)
    }
    s objExtra.PageBreak = APageBreak
    s sc = objExtra.%Save()
    s:($$$ISOK(sc)) result = 1
    q result
}

}
