Class User.ZKCLASS Extends %RegisteredObject
{

/// Function:根据AdmRowId返回患者性别
/// CreatDte:2023-09-11
/// Creator:张珂
/// Input:AdmRowId
/// Output:SexDescStr
/// Other: d ##class(User.ZKCLASS).GetPAAdmSexDesc()
ClassMethod GetPAAdmSexDesc(AdmRowId As %String) As %String
{
	q:AdmRowId="" ""
	s (PAADMPAPMIDR,PAPMISexDR,SexDesc)=""
	s PAADMPAPMIDR=$p($g(^PAADM(AdmRowId)),"^",1)
	s PAPMISexDR=$p($g(^PAPER(PAADMPAPMIDR,"ALL")),"^",7)
	s SexDesc=$p($g(^CT("SEX",PAPMISexDR)),"^",2)
	w SexDesc
}

}
