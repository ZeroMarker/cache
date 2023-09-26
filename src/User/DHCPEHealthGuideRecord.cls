Class User.DHCPEHealthGuideRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_HealthGuideRecord ]
{

Parameter ClassName = "User.DHCPEHealthGuideRecord";

Property HGRPAADMDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = HGR_PAADM_DR ];

Property HGRType As %Library.String [ Required, SqlColumnNumber = 3, SqlFieldName = HGR_Type ];

Property HGRDetail As %Stream.GlobalCharacter [ SqlColumnNumber = 7, SqlFieldName = HGR_Detail ];

Property HGRUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = HG_UpdateDate ];

Property HGRUpdateTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = HG_UpdateTime ];

Property HGRUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = HGRUpdateUserDR ];

Index IndexPAADMType On (HGRPAADMDR, HGRType As AlphaUp);

Storage Default
{
<Data name="DHCPEHealthGuideRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HGRPAADMDR</Value>
</Value>
<Value name="3">
<Value>HGRType</Value>
</Value>
<Value name="4">
<Value>HGRUpdateUserDR</Value>
</Value>
<Value name="5">
<Value>HGRUpdateDate</Value>
</Value>
<Value name="6">
<Value>HGRUpdateTime</Value>
</Value>
<Value name="7">
<Value>HGRDetail</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEHealthGuideRecordD</DataLocation>
<DefaultData>DHCPEHealthGuideRecordDefaultData</DefaultData>
<IdLocation>^User.DHCPEHealthGuideRecordD</IdLocation>
<IndexLocation>^User.DHCPEHealthGuideRecordI</IndexLocation>
<StreamLocation>^User.DHCPEHealthGuideRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
