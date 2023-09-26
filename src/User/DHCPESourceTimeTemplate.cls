Class User.DHCPESourceTimeTemplate Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_SourceTimeTemplate ]
{

Parameter ClassName = "User.DHCPESourceTimeTemplate";

Relationship STTParRef As User.DHCPESourceTemplate [ Cardinality = parent, Inverse = STTime ];

Relationship STTVIPType As User.DHCPESourceTimeVIPTemplate [ Cardinality = children, Inverse = STTVParRef ];

/// 总数量
Property STTNum As %Integer [ Required, SqlColumnNumber = 2, SqlFieldName = STT_Num ];

/// 男性数量
Property STTMaleNum As %Integer [ SqlColumnNumber = 3, SqlFieldName = STT_MaleNum ];

/// 女性数量
Property STTFemaleNum As %Integer [ SqlColumnNumber = 4, SqlFieldName = STT_FemaleNum ];

/// 更新人
Property STTUpdateUserDR As User.SSUser [ Required, SqlColumnNumber = 5, SqlFieldName = STT_UpdateUser_DR ];

/// 更新日期
Property STTUpdateDate As %Date [ InitialExpression = {+$H}, Required, SqlColumnNumber = 6, SqlFieldName = STT_UpdateDate ];

/// 更新时间
Property STTUpdateTime As %Time [ InitialExpression = {$p($H,",",2)}, Required, SqlColumnNumber = 7, SqlFieldName = STT_UpdateTime ];

/// 开始时间
Property STTStartTime As %Library.Time [ Required, SqlColumnNumber = 8, SqlFieldName = STT_StartTime ];

/// 结束时间
Property STTEndTime As %Library.Time [ Required, SqlColumnNumber = 9, SqlFieldName = STT_EndTime ];

Index IndOfSTime On (STTParRef, STTStartTime) [ Unique ];

Storage Default
{
<Data name="DHCPESourceTimeTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>STTNum</Value>
</Value>
<Value name="3">
<Value>STTMaleNum</Value>
</Value>
<Value name="4">
<Value>STTFemaleNum</Value>
</Value>
<Value name="5">
<Value>STTUpdateUserDR</Value>
</Value>
<Value name="6">
<Value>STTUpdateDate</Value>
</Value>
<Value name="7">
<Value>STTUpdateTime</Value>
</Value>
<Value name="8">
<Value>STTStartTime</Value>
</Value>
<Value name="9">
<Value>STTEndTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("STTime")</DataLocation>
<DefaultData>DHCPESourceTimeTemplateDefaultData</DefaultData>
<IdLocation>^User.DHCPESourceTemplateC("STTime")</IdLocation>
<IndexLocation>^User.DHCPESourceTimeTemplateI</IndexLocation>
<StreamLocation>^User.DHCPESourceTimeTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
