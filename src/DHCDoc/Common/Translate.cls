/// Desc：翻译类，对日常表数据进行翻译取值
/// CreateDate:20211106
Class DHCDoc.Common.Translate Extends DHCDoc.Util.RegisteredObject
{

/// 医院
ClassMethod GetTransHosp(HospDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s HospDesc=##class(User.CTHospital).GetTranByDesc("HOSPDesc",HospDesc,langid)
	Q HospDesc
}

/// 用户
ClassMethod GetTransUser(UserDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s UserDesc=##class(User.SSUser).GetTranByDesc("SSUSRName",UserDesc,langid)
	Q UserDesc
}

/// 医护人员
ClassMethod GetTransDoc(DoctorDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s DoctorDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",DoctorDesc,langid)
	Q DoctorDesc
}

/// 科室
ClassMethod GetTransLoc(LocDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s LocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",LocDesc,langid)
	Q LocDesc
}

/// 病区
ClassMethod GetTransWard(PACWardDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s PACWardDesc=##class(User.PACWard).GetTranByDesc("WARDDesc",PACWardDesc,langid)
	Q PACWardDesc
}

/// 医嘱项
ClassMethod GetTransARCIM(ARCIMDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
	Q ARCIMDesc
}

/// 医嘱状态
ClassMethod GetTransOrdStat(StatusDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s StatusDesc=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",StatusDesc,langid)
	Q StatusDesc
}

/// 社会地位
ClassMethod GetTransSocial(SocialDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s SocialDesc=##class(User.CTSocialStatus).GetTranByDesc("OSTATDesc",SocialDesc,langid)
	Q SocialDesc
}

/// 费别
ClassMethod GetTransAdmReason(PAAdmReason As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s PAAdmReason=##class(User.PACAdmReason).GetTranByDesc("READesc",PAAdmReason,langid)
	Q PAAdmReason
}

/// 诊断
ClassMethod GetTransMRCICD(MRCICDDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s MRCICDDesc =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",MRCICDDesc,langid)
	Q MRCICDDesc
}

/// 单位
ClassMethod GetTransUOM(CTUOMDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s CTUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",CTUOMDesc,langid)
	Q CTUOMDesc
}

/// 用法
ClassMethod GetTransInstr(InstrDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s InstrDesc=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",InstrDesc,langid)
	Q InstrDesc
}

/// 频次
ClassMethod GetTransFreq(FreqDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s FreqDesc=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",FreqDesc,langid)
	Q FreqDesc
}

/// 医嘱类型
ClassMethod GetTransOECPR(OECPRDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s OECPRDesc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",OECPRDesc,langid)
	Q OECPRDesc
}

/// 疗程
ClassMethod GetTransDura(DuraDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s DuraDesc=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",DuraDesc,langid)
	Q DuraDesc
}

/// 疗程
ClassMethod GetTransSex(SexDesc As %String, langid As %String = "")
{
	if langid="" s langid=..%LanguageID()
	s SexDesc=##class(User.CTSex).GetTranByDesc("CTSEXDesc",SexDesc,langid)
	Q SexDesc
}

/// 就诊类型
ClassMethod GetTransAdmType(EpisodeID As %String, CspName As %String, langid As %String = "")
{
	s PAAdmType=$P($g(^PAADM(EpisodeID)),"^",2)
	if langid="" s langid=..%LanguageID()
	s PAAdmType=$case(PAAdmType,"I":"住院","O":"门诊","E":"急诊","H":"体检",:"其他")
	s PAAdmType=##class(websys.Translation).Get(CspName,PAAdmType,langid)
	Q PAAdmType
}

/// 在院状态
ClassMethod GetTransAdmStat(EpisodeID As %String, CspName As %String, langid As %String = "")
{
	s PAAdmType=$P($g(^PAADM(EpisodeID)),"^",2)
	s PAAdmStatus=$P($g(^PAADM(EpisodeID)),"^",20)
	if langid="" s langid=..%LanguageID()
	
	if (PAAdmStatus'=""){
		if PAAdmType="I"{
			s PAAdmStatus=$case(PAAdmStatus,"A":"在院","C":"退院","D":"出院","P":"预住院",:"其他")
		}else{
			s PAAdmStatus=$case(PAAdmStatus,"A":"正常","C":"退号","D":"出院",:"其他")
		}
	}
	
	s PAAdmStatus=##class(websys.Translation).Get(CspName,PAAdmStatus,langid)
	Q PAAdmStatus
}

}
