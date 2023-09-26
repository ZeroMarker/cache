Class User.LYZTest Extends %Persistent
{

/// Function:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述
/// creator:刘酝泽
/// table:pa_adm
/// input:rowid
/// other:w ##class(User.LYZTest).GetCTSexDesc(rowid)
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
<Data name="LYZTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^User.LYZTestD</DataLocation>
<DefaultData>LYZTestDefaultData</DefaultData>
<IdLocation>^User.LYZTestD</IdLocation>
<IndexLocation>^User.LYZTestI</IndexLocation>
<StreamLocation>^User.LYZTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
