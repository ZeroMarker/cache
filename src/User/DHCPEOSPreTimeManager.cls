Class User.DHCPEOSPreTimeManager Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_OSPreTimeManager ]
{

Parameter ClassName = "User.DHCPEOSPreTimeManager";

Relationship OSPMTParRef As User.DHCPEOrdSetsPreManager [ Cardinality = parent, Inverse = OSPMTime ];

/// 开始时间
Property OSPMTStartTime As %Library.Time [ Required, SqlColumnNumber = 2, SqlFieldName = OSPMT_StartTime ];

/// 结束时间
Property OSPMTEndTime As %Library.Time [ Required, SqlColumnNumber = 3, SqlFieldName = OSPMT_EndTime ];

/// 数量
Property OSPMTNum As %Integer [ Required, SqlColumnNumber = 4, SqlFieldName = OSPMT_Num ];

/// 更新日期
Property OSPMTUpdateDate As %Date [ Required, SqlColumnNumber = 5, SqlFieldName = OSPMT_UpdateDate ];

/// 更新时间
Property OSPMTUpdateTime As %Time [ Required, SqlColumnNumber = 6, SqlFieldName = OSPMT_UpdateTime ];

/// 更新人
Property OSPMTUpdateUserDR As User.SSUser [ Required, SqlColumnNumber = 7, SqlFieldName = OSPMT_UpdateUser_DR ];

Storage Default
{
<Data name="DHCPEOSPreTimeManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OSPMTStartTime</Value>
</Value>
<Value name="3">
<Value>OSPMTEndTime</Value>
</Value>
<Value name="4">
<Value>OSPMTNum</Value>
</Value>
<Value name="5">
<Value>OSPMTUpdateDate</Value>
</Value>
<Value name="6">
<Value>OSPMTUpdateTime</Value>
</Value>
<Value name="7">
<Value>OSPMTUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("OSPMTime")</DataLocation>
<DefaultData>DHCPEOSPreTimeManagerDefaultData</DefaultData>
<IdLocation>^User.DHCPEOrdSetsPreManagerC("OSPMTime")</IdLocation>
<IndexLocation>^User.DHCPEOSPreTimeManagerI</IndexLocation>
<StreamLocation>^User.DHCPEOSPreTimeManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
