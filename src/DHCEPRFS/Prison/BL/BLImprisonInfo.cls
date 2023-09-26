Class DHCEPRFS.Prison.BL.BLImprisonInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc: 同步罪犯收监信息
/// Debug: d ##class(DHCEPRFS.Prison.BL.BLImprisonInfo).UpdateImprisonInfo()
ClassMethod UpdateImprisonInfo()
{
	s patientID = 0
	f {
		s patientID = $o(^PAPER(patientID))
		q:(patientID = "")
		s childSub = 0
		f {
			s childSub = $o(^PAPER(patientID,"IMP",childSub))
			q:(childSub = "")
			s ret = ..AddImprisonInfoDtl(patientID,childSub)
		}
	}
}

/// Debug: w ##class(DHCEPRFS.Prison.BL.BLImprisonInfo).AddImprisonInfoDtl(9239,1)
ClassMethod AddImprisonInfoDtl(APatientID As %String, AChildSub As %String) As %String
{
	s mrPatientID = ""
	s mrPatientID = ##Class(DHCEPRFS.BL.BLMRPatient).RegMRPatientID(APatientID, "DHC")
	q:(mrPatientID = "") ""
	s paiNumber = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",1)
	s imprisonID = ""
	s imprisonID = $o(^DHCEPRFS.Prison.INST.IPI("IdxMain"," "_APatientID," "_paiNumber,imprisonID))
	if (imprisonID = "")
	{
		s objInfo = ##class(DHCEPRFS.Prison.INST.ImprisonInfo).%New()
	}
	else
	{
		s objInfo = ##class(DHCEPRFS.Prison.INST.ImprisonInfo).%OpenId(imprisonID)
	}
	s objInfo.PAINumber = paiNumber
	s objInfo.PatientID = APatientID
	s objInfo.EscortUnitCode = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",4)
	s objInfo.EscortUnitRegionCode = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",10)
	s objInfo.CreateUser = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",9)
	s objInfo.CreateDate = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",7)
	s objInfo.CreateTime = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",8)
	s objInfo.PAIInDate = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",2)
	s objInfo.PAIInTime = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",3)
	s objInfo.PAIOutDate = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",5)
	s objInfo.PAIOutTime = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",6)
	s sc = objInfo.%Save()
	d objInfo.%Close()
	if ($$$ISOK(sc))
	{
		q objInfo.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod GetImprisonInfoByPAI(APatientID As %String, APAINumber As %String) As %String
{
	s imprisonID = ""
	s imprisonID = $o(^DHCEPRFS.Prison.INST.IPI("IdxMain"," "_APatientID," "_APAINumber,imprisonID))
	q:(imprisonID = "") ""
	s objImprison = ##class(DHCEPRFS.Prison.INST.ImprisonInfo).%OpenId(imprisonID)
	s paIInDate = objIP.PAIInDate
	d objImprison.%Close()
}

/// Desc: 获取入监信息
/// Debug: w ##class(DHCEPRFS.Prison.BL.BLImprisonInfo).GetImprisonInfoByID(1)
ClassMethod GetImprisonInfoByID(AImprisonID As %String) As %String
{
	s ret= ""
	q:(AImprisonID = "") ret
	s objIP = ##class(DHCEPRFS.Prison.INST.ImprisonInfo).%OpenId(AImprisonID)
	s patientID = objIP.PatientID
	s paIInDate = objIP.PAIInDate
	d objIP.%Close()
	s:(paIInDate '= "") paIInDate = $zd(paIInDate,3)
	s mrPatientID = ""
	s mrPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxPatientID"," DHC"," "_patientID,mrPatientID))
	q:(mrPatientID = "") result
	s name = $lg(^DHCEPRFS.INST.MRPatientD(mrPatientID),13)
	s gender = $lg(^DHCEPRFS.INST.MRPatientD(mrPatientID),14)
	s age = $lg(^DHCEPRFS.INST.MRPatientD(mrPatientID),16)
	s ret = name_"^"_gender_"^"_age_"^"_paIInDate
	q ret
}

ClassMethod AddImprisonByPAAdm(APAAdm As %String) As %String
{
	s PAAdmPAIDR = ""
	s PAAdmPAIDR = $p($g(^PAADM(APAAdm,"DHC")),"^",47)
	q:(PAAdmPAIDR = "") ""
	s APatientID = $p(PAAdmPAIDR,"||",1)
	s AChildSub = $p(PAAdmPAIDR,"||",2)
	s paiNumber = ""
	s paiNumber = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",1)
	q:(paiNumber ="") ""
	s imprisonID = ""
	s imprisonID = $o(^DHCEPRFS.Prison.INST.IPI("IdxMain"," "_APatientID," "_paiNumber,imprisonID))
	if (imprisonID = "")
	{
		s objInfo = ##class(DHCEPRFS.Prison.INST.ImprisonInfo).%New()
	}
	else
	{
		s objInfo = ##class(DHCEPRFS.Prison.INST.ImprisonInfo).%OpenId(imprisonID)
	}
	s objInfo.PAINumber = paiNumber
	s objInfo.PatientID = APatientID
	s objInfo.EscortUnitCode = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",4)
	s objInfo.EscortUnitRegionCode = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",10)
	s objInfo.CreateUser = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",9)
	s objInfo.CreateDate = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",7)
	s objInfo.CreateTime = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",8)
	s objInfo.PAIInDate = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",2)
	s objInfo.PAIInTime = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",3)
	s objInfo.PAIOutDate = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",5)
	s objInfo.PAIOutTime = $p($g(^PAPER(APatientID,"IMP",AChildSub)),"^",6)
	s sc = objInfo.%Save()
	d objInfo.%Close()
	if ($$$ISOK(sc))
	{
		q objInfo.%Id()
	}
	else
	{
		q ""
	}
}

}
