Class EMRservice.HISInterface.QualityInterface Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod QualityInterfaceCheck(AEpisodeID As %String, AEventType As %String, ATemplateID As %String = "", AInstanceIDs As %String = "", AEditType As %String = "") As %GlobalCharacterStream
{
    d ##class(EMRservice.SystemParameter).SetHisService(AEpisodeID,AEventType,ATemplateID,AInstanceIDs)
	s:(AEditType="EASYUI") result = "" 
	s:(AEditType'="EASYUI") result = ##Class(%GlobalCharacterStream).%New()
	s qualityRuleID = ""
	s isActive = ""
	if (AEventType [ "Save")
	{
		s qualityRuleID = $o(^DHCEPRM.QualityRuleI("IdxCode","C",""))
	}
	elseif (AEventType [ "Commit")
	{
		s qualityRuleID = $o(^DHCEPRM.QualityRuleI("IdxCode","D",""))
	}
	elseif (AEventType [ "Print")
	{
		s qualityRuleID = $o(^DHCEPRM.QualityRuleI("IdxCode","E",""))
	}
	elseif (AEventType [ "Confirm")
	{
		s qualityRuleID = $o(^DHCEPRM.QualityRuleI("IdxCode","H",""))
	}
	q:(qualityRuleID = "") result
	s objQuality = ##Class(EPRmeta.Quality.QualityRule).%OpenId(qualityRuleID)
	q:(objQuality = "") result
	s isActive = objQuality.IsActive
	q:((isActive = "")||(isActive = "N")) result
	s:(AEditType="EASYUI") result = ##Class(web.eprajax.qualitycheck).GetQualityCheck(AEpisodeID,AEventType,ATemplateID,AInstanceIDs)	//非融合界面还是走原来的质控接口
	d:(AEditType'="EASYUI") result.CopyFrom(..GetCheckResult(AEpisodeID,AEventType,ATemplateID,AInstanceIDs))
	q result
}

/// ##class(EMRservice.HISInterface.QualityInterface).QualityInterfaceCheckBatch(614233,"Print","52")
ClassMethod QualityInterfaceCheckBatch(AEpisodeID As %String, AEventType As %String, ADocIDs As %String = "")
{
    s RecordInfo=##Class(EPRservice.Quality.EmrCheckRule.Template).GetRecordInfoByDocID(AEpisodeID,ADocIDs)
    s AInstanceIDs=$p(RecordInfo,"^",1)
    s ATemplateID=$p(RecordInfo,"^",2)
	s result = "" 
	s qualityRuleID = ""
	s isActive = ""
	if (AEventType [ "Print")
	{
		s qualityRuleID = $o(^DHCEPRM.QualityRuleI("IdxCode","E",""))
	}
	q:(qualityRuleID = "") result
	s objQuality = ##Class(EPRmeta.Quality.QualityRule).%OpenId(qualityRuleID)
	q:(objQuality = "") result
	s isActive = objQuality.IsActive
	q:((isActive = "")||(isActive = "N")) result
	s result = ##Class(web.eprajax.qualitycheck).GetQualityCheckBatch(AEpisodeID,AEventType,ATemplateID,AInstanceIDs)
	q result
}

/// yhy
/// 2019-07-20
/// Desc:取保存打印等操作的控制类型，数量，临时global的key值
ClassMethod GetCheckResult(AEpisodeID As %String, AEventType As %String, ATemplateID As %String = "", AInstanceIDs As %String = "") As %GlobalCharacterStream
{
	q ##class(EMRservice.Ajax.Quality).GetRunTimeQuality(AEpisodeID,ATemplateID,AEventType,AInstanceIDs)
}

/// yhy
/// 2019-07-20
/// Desc:取保存打印等操作质控数据
ClassMethod GetCheckResultList(AEpisodeID As %String, AKey As %String) As %String
{
	q ##class(EMRservice.Ajax.Quality).GetRunTimeQualityList(AEpisodeID,AKey)
}

}
