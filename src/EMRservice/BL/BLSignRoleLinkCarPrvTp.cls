Class EMRservice.BL.BLSignRoleLinkCarPrvTp Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:    初始化数据
/// Creator: Candy
/// Debug:   d ##Class(EMRservice.BL.BLSignRoleLinkCarPrvTp).InitData()
ClassMethod InitData()
{
	k ^DHCEMRM.SignRoleLinkCarPrvTpD
	k ^DHCEMRM.SignRoleLinkCarPrvTpI
	&SQL(insert into EMRmeta.SignRoleLinkCarPrvTp(SignRoleCode,CarPrvTpCode)values('intern','PRACTICE'))
	&SQL(insert into EMRmeta.SignRoleLinkCarPrvTp(SignRoleCode,CarPrvTpCode)values('student','STUDENT'))
	&SQL(insert into EMRmeta.SignRoleLinkCarPrvTp(SignRoleCode,CarPrvTpCode)values('Resident','235'))
	&SQL(insert into EMRmeta.SignRoleLinkCarPrvTp(SignRoleCode,CarPrvTpCode)values('Resident','234'))
	&SQL(insert into EMRmeta.SignRoleLinkCarPrvTp(SignRoleCode,CarPrvTpCode)values('Attending','233'))
	&SQL(insert into EMRmeta.SignRoleLinkCarPrvTp(SignRoleCode,CarPrvTpCode)values('ViceChief','232'))
	&SQL(insert into EMRmeta.SignRoleLinkCarPrvTp(SignRoleCode,CarPrvTpCode)values('Chief','231'))
}

/// Desc:       根据his医师级别取签名级别
/// Creator:    Candy
/// CreateDate: 2016-12-06
/// Input:      ACarPrvTpCode his医师级别Code
/// Output:     电子病历医师级别
/// Debug:      d ##Class(EMRservice.BL.BLSignRoleLinkCarPrvTp).GetSignRoleByCarPrvTp(235)
ClassMethod GetSignRoleByCarPrvTp(ACarPrvTpCode As %String) As %String
{
	s result = ""
	q:(ACarPrvTpCode = "") result
	s signRoleCode = $o(^DHCEMRM.SignRoleLinkCarPrvTpI("IdxCarPrvTpSignRole"," "_$zcvt(ACarPrvTpCode,"U"),""))
	q:(signRoleCode = "") result
	s rowId = $o(^DHCEMRM.SignRoleLinkCarPrvTpI("IdxCarPrvTpSignRole"," "_$zcvt(ACarPrvTpCode,"U"),signRoleCode,""))
	q:(rowId = "") result
	s obj = ##class(EMRmeta.SignRoleLinkCarPrvTp).%OpenId(rowId)
	q:(rowId = "") result
	s result = obj.SignRoleCode
	q result
}

}
