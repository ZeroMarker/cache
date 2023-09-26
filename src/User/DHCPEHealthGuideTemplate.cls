Class User.DHCPEHealthGuideTemplate Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_HealthGuideTemplate ]
{

Parameter ClassName = "User.DHCPEHealthGuideTemplate";

Property HGTVIP As %String [ SqlFieldName = HGT_VIP ];

// HomePage，Record

Property HGTType As %String [ Required, SqlFieldName = HGT_Type ];

// 数据分析，风险评估，方案制定，随访记录，疗效评估，需求备注

Property HGTRecordType As %String [ Required, SqlFieldName = HGT_RecordType ];

Property HGTUser As %String [ SqlFieldName = HGT_User ];

Property HGTDetail As %Stream.GlobalCharacter [ SqlFieldName = HGT_Detail ];

Storage Default
{
<Data name="DHCPEHealthGuideTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HGTVIP</Value>
</Value>
<Value name="3">
<Value>HGTType</Value>
</Value>
<Value name="4">
<Value>HGTRecordType</Value>
</Value>
<Value name="5">
<Value>HGTUser</Value>
</Value>
<Value name="6">
<Value>HGTDetail</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEHealthGuideTemplateD</DataLocation>
<DefaultData>DHCPEHealthGuideTemplateDefaultData</DefaultData>
<IdLocation>^User.DHCPEHealthGuideTemplateD</IdLocation>
<IndexLocation>^User.DHCPEHealthGuideTemplateI</IndexLocation>
<StreamLocation>^User.DHCPEHealthGuideTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index IndexHGTType On (HGTType As AlphaUp, HGTRecordType As AlphaUp);

}
