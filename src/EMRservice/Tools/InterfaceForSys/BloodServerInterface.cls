Class EMRservice.Tools.InterfaceForSys.BloodServerInterface Extends %RegisteredObject
{

/// 标准版病历输血同意书模板展现结构 DocumentID 94  模板ID35
Parameter BloodRecord = 621;

Parameter BloodTempalteID = 563;

Parameter InterfaceCSP = "emr.record.interface.csp";

/// Return: status^url
/// status^url [status：0，未保存；1，已保存。url：打开病历的链接] 
/// w ##class(EMRservice.Tools.InterfaceForSys.BloodServerInterface).FinishRecord(11)
ClassMethod FinishRecord(EpisodeID As %String = "") As %String
{
	s ret="0^"
	q:(EpisodeID="") ret
	s tmpDocID=..#BloodRecord
	s tmpTemplateID= ..#BloodTempalteID
	
	s tmpECRID=""
	s tmpECRID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeID,tmpDocID,tmpECRID))
	q:(tmpECRID="") ret
	s IsSaveDoc=$d(^DHCEMRI.InstanceDataI("IdxHappenDateTime",tmpECRID," SAVE"))
	q:(IsSaveDoc=0) ret
	s tmpChild=$o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",tmpECRID,tmpTemplateID," SAVE",""))
	s tmpInstanceID=tmpECRID_"||"_tmpChild
	s patientID = $p($g(^PAADM(EpisodeID)),"^",1)
	s episodeID = EpisodeID
	s docID = tmpDocID
	s pageType = ""
	
	//验证是否为InstanceID
	s instanceID = tmpInstanceID
	s urlIP=##class(EMRservice.SystemParameter).GetServerIP()_"/dthealth/web/csp/"
	s retUrl=urlIP_..#InterfaceCSP
	
	s retUrl=retUrl_"?PatientID="_patientID
	s retUrl=retUrl_"&EpisodeID="_episodeID
	s retUrl=retUrl_"&DocID="_tmpDocID
	s retUrl=retUrl_"&PageType="_pageType
	s retUrl=retUrl_"&InstanceID="_instanceID
	
	s ret="1^"_retUrl
	q ret
}

}
