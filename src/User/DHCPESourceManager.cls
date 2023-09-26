/// Description: 号源管理 8.5启用 
/// FileName: User.DHCPESourceManager.cls
/// Creator: wangguoying
/// Date: 2022-09-29
Class User.DHCPESourceManager Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_SourceManager ]
{

Parameter ClassName = "User.DHCPESourceManager";

Relationship SMTime As User.DHCPESourceTimeManager [ Cardinality = children, Inverse = STMParRef ];

/// 体检科室
Property SMLocDR As User.CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = SM_Loc_DR ];

/// 号源类别 O：外部号源  I：内部号源
Property SMClass As %String(COLLATION = "AlphaUp", VALUELIST = ",I,O") [ Required, SqlColumnNumber = 3, SqlFieldName = SM_Class ];

/// 日期,不设置即为不上班
Property SMDate As %Date [ Required, SqlColumnNumber = 4, SqlFieldName = SM_Date ];

/// 更新人
Property SMUpdateUserDR As User.SSUser [ Required, SqlColumnNumber = 5, SqlFieldName = SM_UpdateUser_DR ];

/// 更新日期
Property SMUpdateDate As %Date [ InitialExpression = {+$H}, Required, SqlColumnNumber = 6, SqlFieldName = SM_UpdateDate ];

/// 更新时间
Property SMUpdateTime As %Time [ InitialExpression = {$p($H,",",2)}, Required, SqlColumnNumber = 7, SqlFieldName = SM_UpdateTime ];

/// 停诊标记
Property SMStopFlag As %String(VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 8, SqlFieldName = SM_StopFlag ];

/// 根据科室、日期索引
Index IndOfLocClassDate On (SMLocDR, SMClass, SMDate) [ Unique ];

Storage Default
{
<Data name="DHCPESourceManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SMLocDR</Value>
</Value>
<Value name="3">
<Value>SMClass</Value>
</Value>
<Value name="4">
<Value>SMDate</Value>
</Value>
<Value name="5">
<Value>SMUpdateUserDR</Value>
</Value>
<Value name="6">
<Value>SMUpdateDate</Value>
</Value>
<Value name="7">
<Value>SMUpdateTime</Value>
</Value>
<Value name="8">
<Value>SMStopFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCPESourceManagerD</DataLocation>
<DefaultData>DHCPESourceManagerDefaultData</DefaultData>
<IdLocation>^User.DHCPESourceManagerD</IdLocation>
<IndexLocation>^User.DHCPESourceManagerI</IndexLocation>
<StreamLocation>^User.DHCPESourceManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
