Class User.DHCPEOSPreTimeTemplate Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_OSPreTimeTemplate ]
{

Parameter ClassName = "User.DHCPEOSPreTimeTemplate";

Relationship OSPTTParRef As User.DHCPEOrdSetsPreTemplate [ Cardinality = parent, Inverse = OSPTTime ];

/// 开始时间
Property OSPTTStartTime As %Library.Time [ Required, SqlFieldName = OSPTT_StartTime ];

/// 结束时间
Property OSPTTEndTime As %Library.Time [ Required, SqlFieldName = OSPTT_EndTime ];

/// 数量
Property OSPTTNum As %Integer [ SqlFieldName = OSPTT_Num ];

Storage Default
{
<Data name="DHCPEOSPreTimeTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OSPTTStartTime</Value>
</Value>
<Value name="3">
<Value>OSPTTEndTime</Value>
</Value>
<Value name="4">
<Value>OSPTTNum</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("OSPTTime")</DataLocation>
<DefaultData>DHCPEOSPreTimeTemplateDefaultData</DefaultData>
<IdLocation>^User.DHCPEOrdSetsPreTemplateC("OSPTTime")</IdLocation>
<IndexLocation>^User.DHCPEOSPreTimeTemplateI</IndexLocation>
<StreamLocation>^User.DHCPEOSPreTimeTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
