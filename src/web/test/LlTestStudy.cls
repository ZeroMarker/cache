Class web.test.LlTestStudy Extends %RegisteredObject
{

/// function:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述
/// CreateDate:2023-09-11
/// Creator:林乐
/// Table:PA_Adm PA_PatMas  CT_Sex
/// Input:rowid
/// Output:sexDesc
/// Others:d ##class(web.test.LlTestStudy).GetPAAdmSexDesc(1)
ClassMethod GetPAAdmSexDesc(rowid As %String) As %String
{
		q:rowid="" ""
		s PaadmPapmiDr=$p($g(^PAADM(rowid)),"^",1)
		q:PaadmPapmiDr="" ""
		s PapmiSexDr=$p($g(^PAPER(PaadmPapmiDr,"ALL")),"^",7)
		q:PapmiSexDr="" ""
		s SexDesc=$p($g(^CT("SEX",PapmiSexDr)),"^",2)
		w SexDesc
}

}
