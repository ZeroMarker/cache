Class User.DHCPESourceTimeManager Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_SourceTimeManager ]
{

Parameter ClassName = "User.DHCPESourceTimeManager";

Relationship STMParRef As User.DHCPESourceManager [ Cardinality = parent, Inverse = SMTime ];

Relationship STMVIPType As User.DHCPESourceTimeVIPManager [ Cardinality = children, Inverse = STVMParRef ];

/// 总数量
Property STMNum As %Integer [ Required, SqlColumnNumber = 2, SqlFieldName = STM_Num ];

/// 男性数量
Property STMMaleNum As %Integer [ SqlColumnNumber = 3, SqlFieldName = STM_MaleNum ];

/// 女性数量
Property STMFemaleNum As %Integer [ SqlColumnNumber = 4, SqlFieldName = STM_FemaleNum ];

/// 更新人
Property STMUpdateUserDR As User.SSUser [ Required, SqlColumnNumber = 5, SqlFieldName = STM_UpdateUser_DR ];

/// 更新日期
Property STMUpdateDate As %Date [ InitialExpression = {+$H}, Required, SqlColumnNumber = 6, SqlFieldName = STM_UpdateDate ];

/// 更新时间
Property STMUpdateTime As %Time [ InitialExpression = {$p($H,",",2)}, Required, SqlColumnNumber = 7, SqlFieldName = STM_UpdateTime ];

/// 开始时间
Property STMStartTime As %Library.Time [ Required, SqlColumnNumber = 8, SqlFieldName = STM_StartTime ];

/// 结束时间
Property STMEndTime As %Library.Time [ Required, SqlColumnNumber = 9, SqlFieldName = STM_EndTime ];

Index IndOfSTime On (STMParRef, STMStartTime) [ Unique ];

Storage Default
{
<Data name="DHCPESourceTimeManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>STMNum</Value>
</Value>
<Value name="3">
<Value>STMMaleNum</Value>
</Value>
<Value name="4">
<Value>STMFemaleNum</Value>
</Value>
<Value name="5">
<Value>STMUpdateUserDR</Value>
</Value>
<Value name="6">
<Value>STMUpdateDate</Value>
</Value>
<Value name="7">
<Value>STMUpdateTime</Value>
</Value>
<Value name="8">
<Value>STMStartTime</Value>
</Value>
<Value name="9">
<Value>STMEndTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("SMTime")</DataLocation>
<DefaultData>DHCPESourceTimeManagerDefaultData</DefaultData>
<IdLocation>^User.DHCPESourceManagerC("SMTime")</IdLocation>
<IndexLocation>^User.DHCPESourceTimeManagerI</IndexLocation>
<StreamLocation>^User.DHCPESourceTimeManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
