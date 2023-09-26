/// Desc:    调用病案归档接口
/// Creator: Candy
/// CreateDate:2018-12-7
Class EMRservice.HISInterface.DHCEPRFSInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:运行态病历调用归档，生成诊断证明书等信息
/// 系统参数DHCEPRFSPrint 格式：DOCID|versionNumber&DOCID|versionNumber&...【docID目录展现结构的第3层 versionNuber 改新模板前的版本号】
/// Creator:Candy
/// CreateDate:2018-12-7
/// Input: AEpisodeID 就诊号 35465791
///       AInstanceID 病历ID
/// Output: Result "" 其他 0 插入失败 1 插入成功
ClassMethod SetRunDocQueue(AEpisodeID As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(AInstanceID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s docId = objInstance.TheECRecord.RealChartItemID
	s DHCEPRFSPrint = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("DHCEPRFSPrint")
	s flag = 0
	for I=1:1:$l(DHCEPRFSPrint,"&")
	{
		s item = $p(DHCEPRFSPrint,"&",I)
		s:($p(item,"|",1) = docId) flag = 1
		q:(flag = 1)
	}
	q:(flag '= 1) result
	s result = ##Class(DHCEPRFS.BI.BIToEMR).AddDiagSignQueue(AEpisodeID,docId)
	q result
}

/// Desc:判断病历使用什么系统打印
/// 系统参数DHCEPRFSPrint 格式：DOCID|versionNumber&DOCID|versionNumber&...【docID目录展现结构的第3层 versionNuber 改新模板前的版本号】
/// Creator:candy
/// CreateDate:2018-12-7
/// Input: AEpisodeID 就诊号 35465791
///       AInstanceID 病历ID
/// Output: Result "DHCEPRFS" 归档系统 "EMR" 电子病历
ClassMethod GetPrintType(AEpisodeID As %String, AInstanceID As %String) As %String
{
	s result = "EMR"
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s docId = objInstance.TheECRecord.RealChartItemID
	s DHCEPRFSPrint = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("DHCEPRFSPrint")
	for I=1:1:$l(DHCEPRFSPrint,"&")
	{
		s tempItem = $p(DHCEPRFSPrint,"&",I)
		if ($p(tempItem,"|",1) = docId) 
		{
			s result = "DHCEPRFS"
			s templateIdVersion = objInstance.TemplateVersion
			s:(templateIdVersion <= $p(tempItem,"|",2)) result = "EMR"
		}
	}
	q result
}

}
