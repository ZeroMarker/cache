Class web.study.kongjinchuanDay1 Extends %RegisteredObject [ StorageStrategy = NewStorage1 ]
{

/// Function:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述
/// CreaterDate:2023-09-11
/// Creater:孔晋川
/// InPut:就诊表PA_Adm的PAADM_RowID
/// OutPut:病人性别描述
/// Others:w ##class(web.study.kongjinchuanDay1).GetPAAdmSexDesc(1)
ClassMethod GetPAAdmSexDesc(AdmRowId As %String) As %String
{
	
		q:AdmRowId="" "RowId为空"
		q:$d(^PAADM(AdmRowId))=0 "RowId对应数据项为空"
		s patmasDr=$p($g(^PAADM(AdmRowId)),"^",1)
		s sexDr=$p($g(^PAPER(patmasDr,"ALL")),"^",7)
		s sexDesc=$p($g(^CT("SEX",sexDr)),"^",2)
		q sexDesc
}

}
