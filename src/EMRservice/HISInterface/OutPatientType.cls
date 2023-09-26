Class EMRservice.HISInterface.OutPatientType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:	 取门诊就诊类型,调初复诊接口
/// Input:	 InstanceID 实例ID AEpisodeID 就诊号
ClassMethod GetOPType(AEpisodeID As %String, AInstanceID As %String)
{
    q:((AEpisodeID = "")||(AInstanceID = ""))
    //在系统参数中维护初诊及复诊DocID（初诊doc^复诊doc）
	s firstAgainDocId = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("FirstAgainDocID","")
	q:(firstAgainDocId = "")
	q:(##class(%Dictionary.CompiledClass).%ExistsId("web.DHCMRDiagnos") = "0")
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCMRDiagnos||UpdatePAADM") = "0")
	
	s ecrecordId = $p(AInstanceID,"||",1)
	q:(ecrecordId = "")
	s objEcrecord=##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "")
	s instancedoc = objEcrecord.RealChartItemID
	q:(instancedoc = "")
	
	if ($p(firstAgainDocId,"^",1) '= "")
	{
		s firstDocId = $p(firstAgainDocId,"^",1)
		s length = $l(firstDocId,"#")
		for I=1:1:length
		{
			s docID = $p(firstDocId,"#",I)
			continue:(docID '= instancedoc)
			s result = ##class(web.DHCMRDiagnos).UpdatePAADM(AEpisodeID,"^^^^F^^^^1^CZ^^^N^N","Hidden","Hidden")
			q
		}
	}
	if ($p(firstAgainDocId,"^",2) '= "")
	{
		s againDocId = $p(firstAgainDocId,"^",2)
		s length = $l(againDocId,"#")
		for I=1:1:length
		{
			s docID = $p(againDocId,"#",I)
			continue:(docID '= instancedoc)
			s result = ##class(web.DHCMRDiagnos).UpdatePAADM(AEpisodeID,"R^^^^^^^^1^MZFZ^^^N^N","Hidden","Hidden")
			q
		}
	}
	q
}

}
