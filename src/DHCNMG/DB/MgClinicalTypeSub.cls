Class DHCNMG.DB.MgClinicalTypeSub Extends %Persistent [ Owner = {dhpm1} ]
{

Relationship Parref As DHCNMG.DB.MgClinicalType [ Cardinality = parent, Inverse = ChildSub ];

/// 项目
Property DetailItem As %String [ SqlColumnNumber = 2, SqlFieldName = Detail_Item ];

Property DetailCreator As %String [ SqlColumnNumber = 3, SqlFieldName = Detail_Creator ];

Property DetailSort As %Integer [ SqlColumnNumber = 4, SqlFieldName = Detail_Sort ];

Index Item On (Parref, DetailItem);

Index Sort On (Parref, DetailSort);

Storage Default
{
<Data name="MgClinicalTypeSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DetailItem</Value>
</Value>
<Value name="3">
<Value>DetailCreator</Value>
</Value>
<Value name="4">
<Value>DetailSort</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgClinicalTypeSubD</DataLocation>
<DefaultData>MgClinicalTypeSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.DB.MgClinicalTypeSubI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgClinicalTypeSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
