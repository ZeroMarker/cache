Class web.CHL.Study.Day1 Extends %RegisteredObject
{

/// Function:通过就诊表Rowid获取患者性别
/// CreateDate:2023-09-11
/// Creator:chenhongliang
/// Table:PA_Adm, PA_PatMas, CT_Sex
/// Input: Adm_rowid
/// Outpput:SexDesc
/// Others: w ##class(web.CHL.Study.Day1).GetSexDescByAdmRowId(1)
ClassMethod GetSexDescByAdmRowId(RowId As %String) As %String
{
    q:RowId="" "RowId不能为空"
    s AdmStr = $g(^PAADM(RowId))
    s PatMasDR = $p(AdmStr,"^",1)
    s PatMasStr = $g(^PAPER(PatMasDR,"ALL"))
    s SexDR = $p(PatMasStr,"^",7)
    s SexStr = $g(^CT("SEX",SexDR))
    s SexDesc = $p(SexStr,"^",2)
    q "就诊RowId为"_RowId_"的病人性别为："_SexDesc
}

}
