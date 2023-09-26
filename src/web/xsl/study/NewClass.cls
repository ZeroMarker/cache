Class web.xsl.study.NewClass Extends %Persistent
{

/// w ##class(web.study.WorkOne).getSex("7")
ClassMethod getSex(RowId As %String) As %String
{
    s:RowId'="" PAADMPAPMIDR = $p(^PAADM(RowId),"^",1)
    s SexDR=$p(^PAPER(PAADMPAPMIDR,"ALL"),"^",7)
    s SexDesc=$p(^CT("SEX",SexDR),"^",2)
    q SexDesc
}

Storage Default
{
<Data name="NewClassDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.xsl.study.NewClassD</DataLocation>
<DefaultData>NewClassDefaultData</DefaultData>
<IdLocation>^web.xsl.study.NewClassD</IdLocation>
<IndexLocation>^web.xsl.study.NewClassI</IndexLocation>
<StreamLocation>^web.xsl.study.NewClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
