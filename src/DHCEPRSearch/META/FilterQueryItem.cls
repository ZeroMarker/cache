Class DHCEPRSearch.META.FilterQueryItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property ItemID As %String(TRUNCATE = 1);

Property ItemName As %String(TRUNCATE = 1);

Property ItemAlias As %String(TRUNCATE = 1);

Property ItemGroupID As %String(TRUNCATE = 1);

Property ItemGroupName As %String(TRUNCATE = 1);

Property ItemGroupDesc As %String(TRUNCATE = 1);

/// 归档病历子类ID
Property FQSubCategoryID As %String(TRUNCATE = 1);

/// 次序号
Property Sequence As %Integer [ SqlColumnNumber = 4 ];

Index IdxItemGroupID On ItemGroupID;

Index IdxItemID On ItemID;

Index IdxSubCategory On FQSubCategoryID;

Index IdxSequence On (FQSubCategoryID, Sequence);

Index IdxGroupItem On (ItemGroupID, ItemID);

Storage Default
{
<Data name="FilterQueryItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemID</Value>
</Value>
<Value name="3">
<Value>ItemName</Value>
</Value>
<Value name="4">
<Value>ItemAlias</Value>
</Value>
<Value name="5">
<Value>ItemGroupID</Value>
</Value>
<Value name="6">
<Value>ItemGroupName</Value>
</Value>
<Value name="7">
<Value>ItemGroupDesc</Value>
</Value>
<Value name="8">
<Value>FQSubCategoryID</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEPRSearch.META.FilterQueryD</DataLocation>
<DefaultData>FilterQueryItemDefaultData</DefaultData>
<IdLocation>^DHCEPRSearch.META.FilterQueryD</IdLocation>
<IndexLocation>^DHCEPRSearch.META.FilterQueryI</IndexLocation>
<StreamLocation>^DHCEPRSearch.META.FilterQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
