Class web.study.CYWDayOne Extends %RegisteredObject
{

/// Function:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述
/// CreaterDate:2023-09-12
/// Creater:caiyaowei
/// InPut:就诊表rowId
/// OutPut:对应的性别描述
/// Others:w ##class(web.study.CYWDayOne).GetCTSexDesc(1)
ClassMethod GetCTSexDesc(rowid As %String)
{
	q:rowid="" 
	s:$d(^PAADM(rowid))'=0 AdmStr=$g(^PAADM(rowid)) //拿到另一个表的rowid
	s PAADMPAMIDR=$p(AdmStr,"^",1)
	s:$d(^PAPER(PAADMPAMIDR,"ALL")) PatMasStr=$g(^PAPER(PAADMPAMIDR,"ALL"))
	s PAPMISexDR=$p(PatMasStr,"^",7) //取出性别
	s SexStr=$g(^CT("SEX",PAPMISexDR))
	s CTSexDesc=$p(SexStr,"^",2) //取出性别描述
	q CTSexDesc
}

}
