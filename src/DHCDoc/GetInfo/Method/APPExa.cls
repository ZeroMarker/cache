/// 名称:    DHCDoc.GetInfo.Method.APPExa
/// 描述:    医生（检查检验病理申请单）相关信息获取公共类
/// 编写者:  屈坚
/// 编写日期:2020.01.05
/// 继承:
Class DHCDoc.GetInfo.Method.APPExa Extends %RegisteredObject
{

// Into DHC_AppReport(AR_No,AR_CreateDate,AR_CreateTime,AR_CreateDoc_Dr,AR_ExecLoc_Dr,AR_Adm_Dr,AR_Cat_Dr,AR_EmgFlag,AR_AppointDoc,AR_Purpose,AR_SendFlag,AR_PatDiags)

ClassMethod GetAPPExaInfo(OEORIRowID As %String) As DHCDoc.GetInfo.Entry.APPExa
{
	s OutputObj=##class(DHCDoc.GetInfo.Entry.APPExa).%New()
	s ARRowid=$O(^DHCAPREP(0,"OrdItem",OEORIRowID,0))
	q:ARRowid="" ""
	s ExaObj=##class(User.OEOrdItem).%OpenId(ARRowid)
	if $ISOBJECT(OrdObj) {
		s OutputObj.ARRowid=ARRowid
		s OutputObj.ARNo=ExaObj.ARNo
		s OutputObj.ARCreateDate=ExaObj.ARCreateDate
		s OutputObj.ARCreateTime=ExaObj.ARCreateTime
		s OutputObj.ARCreateDocDr=ExaObj.ARCreateDocDr
		if $ISOBJECT(OutputObj.ARCreateDocDr) {
			s OutputObj.ARCreateDocDr=ExaObj.ARCreateDocDr.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.ARCreateDocDr)
			if $ISOBJECT(UserObj) {
			   s OutputObj.ARCreateDocCode=UserObj.SSUSRInitials
			   s OutputObj.ARCreateDocDesc=UserObj.SSUSRName
			   do UserObj.%Close()
			}
		}
		s OutputObj.ARExecLocDr=ExaObj.ARExecLocDr
		if $ISOBJECT(OutputObj.ARExecLocDr) {
			s OutputObj.ARExecLocDr=ExaObj.ARExecLocDr.%Id()
			s LocObj=##class(User.CTLoc).%OpenId(OutputObj.ARExecLocDr)
			if $ISOBJECT(LocObj) {
			   s OutputObj.ARExecLocCode=LocObj.CTLOCCode
			   s OutputObj.ARExecLocDesc=LocObj.CTLOCDesc
			   do LocObj.%Close()
			}
		}
		s OutputObj.ARAdmDr=ExaObj.ARAdmDr.%Id()
		s OutputObj.ARCatDr=ExaObj.ARCatDr
		if $ISOBJECT(OutputObj.ARCatDr) {
			s OutputObj.ARCatDr=ExaObj.ARCatDr.%Id()
			s LocObj=##class(User.CTLoc).%OpenId(OutputObj.ARCatDr)
			if $ISOBJECT(LocObj) {
			   s OutputObj.ARCatCode=LocObj.CTLOCCode
			   s OutputObj.ARCatDesc=LocObj.CTLOCDesc
			   do LocObj.%Close()
			}
		}
		s OutputObj.AREmgFlag=ExaObj.AREmgFlag
		s OutputObj.ARAppointDoc=ExaObj.ARAppointDoc
		if $ISOBJECT(OutputObj.ARAppointDoc) {
			s OutputObj.ARAppointDoc=ExaObj.ARAppointDoc.%Id()
			s UserObj=##class(User.SSUser).%OpenId(OutputObj.ARAppointDoc)
			if $ISOBJECT(UserObj) {
			   s OutputObj.ARAppointDocCode=UserObj.SSUSRInitials
			   s OutputObj.ARAppointDocDesc=UserObj.SSUSRName
			   do UserObj.%Close()
			}
		}
		s OutputObj.ARPurpose=ExaObj.ARPurpose
		s OutputObj.ARSendFlag=ExaObj.ARSendFlag
		s OutputObj.ARPatDiags=ExaObj.ARPatDiags
		do ExaObj.%Close()
		}
	q OutputObj
}

}
