Class web.xsl.study.NewClass1 Extends %RegisteredObject
{

/// Description:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述
/// Date:2023-09-11
/// Input:AdmRowld
/// Output:PAAdmSexDesc
/// w ##class(web.xsl.study.NewClass1).GetPAAdmSexDesc("11")
ClassMethod GetPAAdmSexDesc(AdmRowld As %String) As %String
{
    s:AdmRowld'="" PAADMPAPMIDR = $p(^PAADM(AdmRowld),"^",1)
    s SexDR=$p(^PAPER(PAADMPAPMIDR,"ALL"),"^",7)
    s PAAdmSexDesc=$p(^CT("SEX",SexDR),"^",2)
    q PAAdmSexDesc
}

}
