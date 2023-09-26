Class DHCMGNUR.MgNurSecLayOutSub Extends %Persistent
{

Relationship layparref As DHCMGNUR.MgNurSecLayOut [ Cardinality = parent, Inverse = ChildSub, Required ];

Property laysubmoud As DHCMGNUR.MgChildPagEle;

Property laysubitem As %String(TRUNCATE = 1);

Index menu On laysubmoud;

Storage Default
{
<Data name="MgNurSecLayOutSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>laysubmoud</Value>
</Value>
<Value name="3">
<Value>laysubitem</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>MgNurSecLayOutSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurSecLayOutC("ChildSub")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurSecLayOutSubI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurSecLayOutSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
