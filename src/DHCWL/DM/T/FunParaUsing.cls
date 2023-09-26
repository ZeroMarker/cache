Class DHCWL.DM.T.FunParaUsing Extends %Persistent
{

// ClassFullName:ID

Property UsingMaster As %String [ Required ];

Property DefinedPara As FunParaConfig [ Required ];

Property ParaValue As %String;

Property ParaName As %String;

Index MainI On (DefinedPara, UsingMaster As Exact);

ClassMethod GetInstance(master As %String, paraId As %String) As FunParaUsing
{
	q:'$d(^DHCWL.DM.T.FunParaUsingI("MainI",paraId,master)) ""
	s id=$o(^DHCWL.DM.T.FunParaUsingI("MainI",paraId,master,""))
	q ##class(FunParaUsing).%OpenId(id)
}

Storage Default
{
<Data name="FunParaUsingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UsingMaster</Value>
</Value>
<Value name="3">
<Value>DefinedPara</Value>
</Value>
<Value name="4">
<Value>ParaValue</Value>
</Value>
<Value name="5">
<Value>ParaName</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.FunParaUsingD</DataLocation>
<DefaultData>FunParaUsingDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.FunParaUsingD</IdLocation>
<IndexLocation>^DHCWL.DM.T.FunParaUsingI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.FunParaUsingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
