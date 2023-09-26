Class User.DHCPESourceTimeVIPTemplate Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_SourceTimeVIPTemplate ]
{

Parameter ClassName = "User.DHCPESourceTimeVIPTemplate";

Relationship STTVParRef As User.DHCPESourceTimeTemplate [ Cardinality = parent, Inverse = STTVIPType ];

/// VIP等级  8.5之后改成 User.DHCPEVIPLevel
Property STTVVIPLevel As %Integer [ Required, SqlColumnNumber = 2, SqlFieldName = STTV_VIPLevel ];

/// I:个人、G:单位、N:不限
Property STTVType As %String(COLLATION = "AlphaUp", VALUELIST = ",I,G,N") [ Required, SqlColumnNumber = 3, SqlFieldName = STTV_Type ];

/// 总数量
Property STTVNum As %Integer [ SqlColumnNumber = 4, SqlFieldName = STTV_Num ];

/// 男性数量
Property STTVMaleNum As %Integer [ SqlColumnNumber = 5, SqlFieldName = STTV_MaleNum ];

/// 女性数量
Property STTVFemaleNum As %Integer [ SqlColumnNumber = 6, SqlFieldName = STTV_FemaleNum ];

/// 更新人
Property STTVUpdateUserDR As User.SSUser [ Required, SqlColumnNumber = 7, SqlFieldName = STTV_UpdateUser_DR ];

/// 更新日期
Property STTVUpdateDate As %Date [ InitialExpression = {+$H}, Required, SqlColumnNumber = 8, SqlFieldName = STTV_UpdateDate ];

/// 更新时间
Property STTVUpdateTime As %Time [ InitialExpression = {$p($H,",",2)}, Required, SqlColumnNumber = 9, SqlFieldName = STTV_UpdateTime ];

Index IndOfVIPType On (STTVParRef, STTVVIPLevel, STTVType) [ Unique ];

Index IndOfVIPTypeParRef On (STTVVIPLevel, STTVType, STTVParRef) [ Unique ];

Storage Default
{
<Data name="DHCPESourceTimeVIPTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>STTVVIPLevel</Value>
</Value>
<Value name="3">
<Value>STTVType</Value>
</Value>
<Value name="4">
<Value>STTVNum</Value>
</Value>
<Value name="5">
<Value>STTVMaleNum</Value>
</Value>
<Value name="6">
<Value>STTVFemaleNum</Value>
</Value>
<Value name="7">
<Value>STTVUpdateUserDR</Value>
</Value>
<Value name="8">
<Value>STTVUpdateDate</Value>
</Value>
<Value name="9">
<Value>STTVUpdateTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("STTVIPType")</DataLocation>
<DefaultData>DHCPESourceTimeVIPTemplateDefaultData</DefaultData>
<IdLocation>^User.DHCPESourceTimeTemplateC("STTVIPType")</IdLocation>
<IndexLocation>^User.DHCPESourceTVIPTemplateI</IndexLocation>
<StreamLocation>^User.DHCPESourceTVIPTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
