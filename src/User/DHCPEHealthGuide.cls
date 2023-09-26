Class User.DHCPEHealthGuide Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_HealthGuide ]
{

Parameter ClassName = "User.DHCPEHealthGuide";

Property HGPAPMIDR As User.PAPatMas [ SqlFieldName = HG_PAPMI_DR ];

Property HGDetail As %Stream.GlobalCharacter [ SqlFieldName = HG_Detail ];

Property HGUpdateDate As %Library.Date(FORMAT = 4) [ SqlFieldName = HG_UpdateDate ];

Property HGUpdateTime As %Library.Time [ SqlFieldName = HG_UpdateTime ];

Property HGUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlFieldName = HGUpdateUserDR ];

Storage Default
{
<Data name="DHCPEHealthGuideDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HGPAPMIDR</Value>
</Value>
<Value name="3">
<Value>HGUpdateUserDR</Value>
</Value>
<Value name="4">
<Value>HGUpdateDate</Value>
</Value>
<Value name="5">
<Value>HGUpdateTime</Value>
</Value>
<Value name="6">
<Value>HGDetail</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEHealthGuideD</DataLocation>
<DefaultData>DHCPEHealthGuideDefaultData</DefaultData>
<IdLocation>^User.DHCPEHealthGuideD</IdLocation>
<IndexLocation>^User.DHCPEHealthGuideI</IndexLocation>
<StreamLocation>^User.DHCPEHealthGuideS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index IndexPAPMIDR On HGPAPMIDR [ Unique ];

}
