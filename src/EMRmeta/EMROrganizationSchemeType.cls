Class EMRmeta.EMROrganizationSchemeType Extends (%Persistent, %XML.Adaptor)
{

/// 方案类型 病历书写顺序方案(Running)、病历归档顺序方案(Archiving)
Property SchemType As %String;

Relationship ParScheme As EMRmeta.EMROrganizationScheme [ Cardinality = parent, Inverse = SchemType ];

Relationship Details As EMRmeta.EMROrganizationSchemeDetails [ Cardinality = children, Inverse = ParSchemeType ];

Index IdxSchemType On SchemType;

Storage Default
{
<Data name="EMROrganizationSchemeTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SchemType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("SchemType")</DataLocation>
<DefaultData>EMROrgSchemeTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("SchemType")</IdLocation>
<IndexLocation>^DHCEMRM.EMROrgSchemeTypeI</IndexLocation>
<StreamLocation>^DHCEMRM.EMROrgSchemeTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
