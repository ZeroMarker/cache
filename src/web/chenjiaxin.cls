Class web.chenjiaxin Extends %RegisteredObject
{

/// Function:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述
/// CreaterDate:2023-09-11
/// Creater:陈佳欣
/// InPut:就诊表RowId
/// OutPut:对应的性别描述
/// Others:w ##class(web.chenjiaxin).GetPAAdmSexDesc(5)
ClassMethod GetPAAdmSexDesc(AdmRowId As %String)
{
	q:AdmRowId="" "就诊表RowId为空"
	q:^PAADM(AdmRowId)="" "没有对应的就诊表RowId"
	s patmasDr=$p($g(^PAADM(AdmRowId)),"^",1)
	s sexDr=$p($g(^PAPER(patmasDr,"ALL")),"^",7)
	s sexDesc=$p($g(^CT("SEX",sexDr)),"^",2)
	q sexDesc
}

}
