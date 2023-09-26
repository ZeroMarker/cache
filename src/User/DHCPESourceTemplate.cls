/// Description: 号源管理模板 8.5启用 
/// FileName: User.DHCPESourceTemplate.cls
/// Creator: wangguoying
/// Date: 2022-09-29
Class User.DHCPESourceTemplate Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_SourceTemplate ]
{

Parameter ClassName = "User.DHCPESourceTemplate";

Relationship STTime As User.DHCPESourceTimeTemplate [ Cardinality = children, Inverse = STTParRef ];

/// 体检科室
Property STLocDR As User.CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = ST_Loc_DR ];

/// 号源类别 O：外部号源  I：内部号源
Property STClass As %String(COLLATION = "AlphaUp", VALUELIST = ",I,O") [ Required, SqlColumnNumber = 3, SqlFieldName = ST_Class ];

/// 周几,不设置即为不上班
Property STWeekNum As %Integer [ Required, SqlColumnNumber = 4, SqlFieldName = ST_WeekNum ];

/// 更新人
Property STUpdateUserDR As User.SSUser [ Required, SqlColumnNumber = 5, SqlFieldName = ST_UpdateUser_DR ];

/// 更新日期
Property STUpdateDate As %Date [ InitialExpression = {+$H}, Required, SqlColumnNumber = 6, SqlFieldName = ST_UpdateDate ];

/// 更新时间
Property STUpdateTime As %Time [ InitialExpression = {$p($H,",",2)}, Required, SqlColumnNumber = 7, SqlFieldName = ST_UpdateTime ];

/// 根据科室、周几索引
Index IndOfLocClassWeek On (STLocDR, STClass, STWeekNum) [ Unique ];

Storage Default
{
<Data name="DHCPESourceTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>STLocDR</Value>
</Value>
<Value name="3">
<Value>STClass</Value>
</Value>
<Value name="4">
<Value>STWeekNum</Value>
</Value>
<Value name="5">
<Value>STUpdateUserDR</Value>
</Value>
<Value name="6">
<Value>STUpdateDate</Value>
</Value>
<Value name="7">
<Value>STUpdateTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCPESourceTemplateD</DataLocation>
<DefaultData>DHCPESourceTemplateDefaultData</DefaultData>
<IdLocation>^User.DHCPESourceTemplateD</IdLocation>
<IndexLocation>^User.DHCPESourceTemplateI</IndexLocation>
<StreamLocation>^User.DHCPESourceTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
