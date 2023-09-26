Class web.study.ZyzFirstWork Extends %RegisteredObject
{

/// Function:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述
/// CreateDate:2023-09-11
/// Creator:zhangyizhu
/// Table:PA_Adm
/// Input:rowid
/// Output:性别描述
/// Others:w ##class(web.study.ZyzFirstWork).GetPAAdmSexDesc()
ClassMethod GetPAAdmSexDesc(AdmRowId As %String) As %String
{
	q:AdmRowId="" ""
	q:$d(^PAADM(AdmRowId))=0 ""
	s AdmStr=$g(^PAADM(AdmRowId))
	s PAADMPAPMIDR=$p(AdmStr,"^",1)
	s PatMasStr=$g(^PAPER(PAADMPAPMIDR,"ALL"))
	s PAPMISexDR=$p(PatMasStr,"^",7)
	s SexDesc=$p($g(^CT("SEX",PAPMISexDR)),"^",2)
	q "性别为："_SexDesc
}

}
