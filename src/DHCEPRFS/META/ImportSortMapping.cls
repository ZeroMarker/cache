Class DHCEPRFS.META.ImportSortMapping Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MRItemID As %String(TRUNCATE = 1);

Property ThirdPartyName As %String(TRUNCATE = 1);

Property IsActive As %String(TRUNCATE = 1);

Index IdxMRItemID On MRItemID;

Index IdxThirdPartyName On (ThirdPartyName, MRItemID) [ Unique ];

Storage Default
{
<Data name="ImportSortMappingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRItemID</Value>
</Value>
<Value name="3">
<Value>ThirdPartyName</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.ImportSortMPD</DataLocation>
<DefaultData>ImportSortMappingDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.ImportSortMPD</IdLocation>
<IndexLocation>^DHCEPRFS.META.ImportSortMPI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.ImportSortMPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
