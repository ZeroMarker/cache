Class DHCMGNUR.SSGROUP Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property grpname As %String(TRUNCATE = 1);

Property grpcode As %String(TRUNCATE = 1);

Property Typ As %Library.String(DISPLAYLIST = ",Doc,Nur,All", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",D,N,A");

Storage Default
{
<Data name="SSGROUPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Typ</Value>
</Value>
<Value name="3">
<Value>grpcode</Value>
</Value>
<Value name="4">
<Value>grpname</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.SSGROUPD</DataLocation>
<DefaultData>SSGROUPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.SSGROUPD</IdLocation>
<IndexLocation>^DHCMGNUR.SSGROUPI</IndexLocation>
<StreamLocation>^DHCMGNUR.SSGROUPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
