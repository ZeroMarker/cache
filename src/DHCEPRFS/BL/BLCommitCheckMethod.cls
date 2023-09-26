/// Desc: 医生提交pdf时，保存完整性校验信息过程中每个大类的校验方法
Class DHCEPRFS.BL.BLCommitCheckMethod Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// Desc: 病历类型1 -- 有子项结果为"1"则返回"1", 无子项或子项结果全为"0"则返回"0"
/// Debug: w ##class(DHCEPRFS.BL.BLCommitCheckMethod).MedRecordType01("593",64359,35258,"Category001")
ClassMethod MedRecordType01(AEpisodeID As %String, ACheckDate As %String, ACheckTime As %String, ACategoryCode As %String) As %String
{
	s categoryCode = $zcvt(ACategoryCode,"U")
	s result = "0"
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.INST.CheckedRetDtlI("IdxCategoryCode"," "_AEpisodeID,ACheckDate,ACheckTime," "_categoryCode,rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.CheckedRetDtl).%OpenId(rowID)
		s ret = obj.CheckResult
		d obj.%Close()
		if (ret = "1")
		{
			s result = "1"
		}
	}
	q result
}

/// Desc: 病历类型2 -- 有子项必须提交且结果为"0"则返回"0",用于日常病程记录
/// Debug: w ##class(DHCEPRFS.BL.BLCommitCheckMethod).MedRecordType02("593",64359,35258,"Category003")
ClassMethod MedRecordType02(AEpisodeID As %String, ACheckDate As %String, ACheckTime As %String, ACategoryCode As %String) As %String
{
	s categoryCode = $zcvt(ACategoryCode,"U")
	s result = "1"
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.INST.CheckedRetDtlI("IdxCategoryCode"," "_AEpisodeID,ACheckDate,ACheckTime," "_categoryCode,rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.CheckedRetDtl).%OpenId(rowID)
		s ret = obj.CheckResult
		s isNeeded = obj.IsNeeded
		d obj.%Close()
		if (ret = "0")
		{
			if (isNeeded = "Y")
			{
				s result = "0"
			}
		}
	}
	q result
}

/// Desc: 病历类型3 -- 无子项则返回"1",有子项结果为"1"则返回"1",子项结果全为"0"则返回"0",用于手术记录
/// Debug: w ##class(DHCEPRFS.BL.BLCommitCheckMethod).MedRecordType03("373",64401,49373,"Category011")
ClassMethod MedRecordType03(AEpisodeID As %String, ACheckDate As %String, ACheckTime As %String, ACategoryCode As %String) As %String
{
	s categoryCode = $zcvt(ACategoryCode,"U")
	s existID = ""
	s existID = $o(^DHCEPRFS.INST.CheckedRetDtlI("IdxCategoryCode"," "_AEpisodeID,ACheckDate,ACheckTime," "_categoryCode,existID))
	q:(existID = "") "1"
	s result = "0"
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.INST.CheckedRetDtlI("IdxCategoryCode"," "_AEpisodeID,ACheckDate,ACheckTime," "_categoryCode,rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.CheckedRetDtl).%OpenId(rowID)
		s ret = obj.CheckResult
		d obj.%Close()
		if (ret = "1")
		{
			s result = "1"
		}
	}
	q result
}

/// Desc: 医技报告类型 -- 有子项结果为"0"则返回"0", 无子项或子项结果全为"1"则返回"1",用于RIS、LIS、EKG、PIS
/// Debug: w ##class(DHCEPRFS.BL.BLCommitCheckMethod).ReportType("373",64398,58669,"Category007")
ClassMethod ReportType(AEpisodeID As %String, ACheckDate As %String, ACheckTime As %String, ACategoryCode As %String) As %String
{
	s categoryCode = $zcvt(ACategoryCode,"U")
	s result = "1"
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.INST.CheckedRetDtlI("IdxCategoryCode"," "_AEpisodeID,ACheckDate,ACheckTime," "_categoryCode,rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.CheckedRetDtl).%OpenId(rowID)
		s ret = obj.CheckResult
		d obj.%Close()
		if (ret = "0")
		{
			s result = "0"
		}
	}
	q result
}

//AnesthesiaRecord

//OpsAnaRelated

//HighValueCGEAndBarcode

//GeneralReportAndRecord

//InformedConsentForm

//NursingRecord

//Others

ClassMethod CheckItem001(AEpisodeID As %String, ACheckDate As %String, ACheckTime As %String, ACategoryCode As %String)
{
	q "1"
}

ClassMethod CheckItem002(AEpisodeID As %String, ACheckDate As %String, ACheckTime As %String, ACategoryCode As %String)
{
	q "0"
}

}
