Class User.gzyDay1 Extends %Persistent
{

/// Function:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述
/// creator:高泽宇
/// table:pa_adm
/// input:rowid
/// other:w ##class(User.gzyDay1).GetCTSexDesc(rowid)
ClassMethod GetCTSexDesc(rowid As %String) As %String
{
	q:rowid="" ""
    q:$d(^PAADM(rowid))=0 ""
    s AdmStr=$g(^PAADM(rowid))
    s PAADMPAPMIDR=$p(AdmStr,"^",1)
    s PatMasStr=$g(^PAPER(PAADMPAPMIDR,"ALL"))
    s PAPMISexDR=$p(PatMasStr,"^",7)
    s SexStr=$g(^CT("SEX",PAPMISexDR))
    s CTSexDesc=$p(SexStr,"^",2)
    q CTSexDesc
}

Storage Default
{
<Data name="gzyDay1DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^User.gzyDay1D</DataLocation>
<DefaultData>gzyDay1DefaultData</DefaultData>
<IdLocation>^User.gzyDay1D</IdLocation>
<IndexLocation>^User.gzyDay1I</IndexLocation>
<StreamLocation>^User.gzyDay1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
