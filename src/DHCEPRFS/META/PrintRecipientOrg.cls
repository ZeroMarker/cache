/// Desc: 打印领用机构维护
Class DHCEPRFS.META.PrintRecipientOrg Extends %Persistent
{

/// 机构编码
Property Code As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 机构名称
Property Name As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Storage Default
{
<Data name="PrintRecipientOrgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.PrintRecipiFA59D</DataLocation>
<DefaultData>PrintRecipientOrgDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.PrintRecipiFA59D</IdLocation>
<IndexLocation>^DHCEPRFS.META.PrintRecipiFA59I</IndexLocation>
<StreamLocation>^DHCEPRFS.META.PrintRecipiFA59S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
