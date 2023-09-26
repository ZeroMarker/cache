Class web.study.CxyStudy Extends %RegisteredObject
{

// 题目：获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述.

// 崔兴阳  基础平台组

ClassMethod GetPAAdmSexDesc(AdmRowId As %String) As %String
{
		Set Str = ^PAADM(AdmRowId)
 		Set PAPMIDr = $p(Str,"^",1) ;是就诊表PA_Adm的外键, 病人信息表的RowId
 		Set PatInfo = ^PAPER(PAPMIDr,"ALL")
 		Set PatSexDr = $p(PatInfo,"^",7)
 		Set SexDesc = $p(^CT("SEX",PatSexDr),"^",2)
 		q "(崔兴阳  基础平台组)病人性别："_SexDesc
}

}
