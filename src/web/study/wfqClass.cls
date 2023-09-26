Class web.study.wfqClass Extends %RegisteredObject
{

/// Function: 获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述
/// CreateDate: 2023-09-11
/// Creator: 魏方茜
/// Table: PA_PatMas
/// Input: AdmRowId
/// output: SexDesc
/// others: w ##class(web.study.wfqClass).GetPAAdmSexDesc()
ClassMethod GetPAAdmSexDesc(AdmRowId As %String) As %String
{
		q:AdmRowId="" ""
		q:$d(^PAADM(AdmRowId))=0 ""
		s AdmStr=$get(^PAADM(AdmRowId))
		s PAADMPAPMIDR=$p(AdmStr,"^",1)
		s PatMasStr=$g(^PAPER(PAADMPAPMIDR,"ALL"))
		s PAPMISexDR=$p(PatMasStr,"^",7)
		s SexDesc=$p($g(^CT("SEX",PAPMISexDR)),"^",2)
		q SexDesc
}

}
