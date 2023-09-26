Class DHCMGNUR.GSSGRPLAYOUTSUB Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship layparref As DHCMGNUR.GSSGRPLAYOUT [ Cardinality = parent, Inverse = ChildSub, Required ];

Property laysubmoud As DHCMGNUR.MenuSystem;

Property laysubitem As %String(MAXLEN = 1000, TRUNCATE = 1);

//头菜单

Property laysubSort As %String(TRUNCATE = 1);

Property layHeadFlag As %String(TRUNCATE = 1);

Index menu On laysubmoud;

Storage Default
{
<Data name="GSSGRPLAYOUTSUBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>laysubSort</Value>
</Value>
<Value name="3">
<Value>laysubitem</Value>
</Value>
<Value name="4">
<Value>laysubmoud</Value>
</Value>
<Value name="5">
<Value>layHeadFlag</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>GSSGRPLAYOUTSUBDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCMGNUR.GSSGRPLAYOUTSUBI</IndexLocation>
<StreamLocation>^DHCMGNUR.GSSGRPLAYOUTSUBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
