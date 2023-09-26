/// Descript:套餐限额模板
/// Creator:wangguoying
Class User.DHCPEOrdSetsPreTemplate Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_OrdSetsPreTemplate ]
{

Parameter ClassName = "User.DHCPEOrdSetsPreTemplate";

Relationship OSPTTime As User.DHCPEOSPreTimeTemplate [ Cardinality = children, Inverse = OSPTTParRef ];

/// 套餐
Property OSPTOrdSets As User.ARCOrdSets [ Required, SqlColumnNumber = 2, SqlFieldName = OSPT_OrdSets ];

/// 科室
Property OSPTLoc As User.CTLoc [ Required, SqlColumnNumber = 3, SqlFieldName = OSPT_Loc ];

/// 数量
Property OSPTNum As %Integer [ Required, SqlColumnNumber = 4, SqlFieldName = OSPT_Num ];

/// 星期  周几
Property OSPTWeekNum As %Integer [ Required, SqlColumnNumber = 5, SqlFieldName = OSPT_WeekNum ];

Index SetsLocWeekIndex On (OSPTOrdSets, OSPTLoc, OSPTWeekNum) [ Unique ];

Storage Default
{
<Data name="DHCPEOrdSetsPreTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OSPTOrdSets</Value>
</Value>
<Value name="3">
<Value>OSPTLoc</Value>
</Value>
<Value name="4">
<Value>OSPTNum</Value>
</Value>
<Value name="5">
<Value>OSPTWeekNum</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEOrdSetsPreTemplateD</DataLocation>
<DefaultData>DHCPEOrdSetsPreTemplateDefaultData</DefaultData>
<IdLocation>^User.DHCPEOrdSetsPreTemplateD</IdLocation>
<IndexLocation>^User.DHCPEOrdSetsPreTemplateI</IndexLocation>
<StreamLocation>^User.DHCPEOrdSetsPreTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
