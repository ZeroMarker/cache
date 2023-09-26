Class User.DHCPEArea Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_Area ]
{

Parameter ClassName = "User.DHCPEArea";

Relationship ChildRoom As User.DHCPERoom [ Cardinality = children, Inverse = RParref ];

Property ACode As %String [ Required, SqlFieldName = A_Code ];

Property ADesc As %String [ Required, SqlFieldName = A_Desc ];

Property ASort As %String [ Required, SqlFieldName = A_Sort ];

Property ALocDR As %String [ Required, SqlFieldName = A_Loc_DR ];

Property APEType As %String [ SqlFieldName = A_PEType ];

Property AAreaFlag As %String [ SqlFieldName = A_AreaFlag ];

Property AActiveFlag As %String [ SqlFieldName = A_ActiveFlag ];

Property AUpdateDate As %Library.Date [ SqlFieldName = A_UpdateDate ];

Property AUpdateTime As %Library.Time [ SqlFieldName = A_UpdateTime ];

Property AUpdateUserDR As %String [ SqlFieldName = A_UpdateUserDR ];

Index ACodeIndex On (ALocDR, ACode) [ Unique ];

Index ALocDRIndex On ALocDR;

Index ALocDRSortIndex On (ALocDR, ASort As AlphaUp);

Index ALocTypeSortIndex On (ALocDR, APEType, ASort As AlphaUp);

Storage Default
{
<Data name="DHCPEAreaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ACode</Value>
</Value>
<Value name="3">
<Value>ADesc</Value>
</Value>
<Value name="4">
<Value>ALocDR</Value>
</Value>
<Value name="5">
<Value>APEType</Value>
</Value>
<Value name="6">
<Value>ASort</Value>
</Value>
<Value name="7">
<Value>AAreaFlag</Value>
</Value>
<Value name="8">
<Value>AActiveFlag</Value>
</Value>
<Value name="9">
<Value>AUpdateDate</Value>
</Value>
<Value name="10">
<Value>AUpdateTime</Value>
</Value>
<Value name="11">
<Value>AUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEAreaD</DataLocation>
<DefaultData>DHCPEAreaDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEAreaD</IdLocation>
<IndexLocation>^User.DHCPEAreaI</IndexLocation>
<StreamLocation>^User.DHCPEAreaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
