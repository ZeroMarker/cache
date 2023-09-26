/// Descript:项目预约限额管理日志表
/// Creator:wangguoying
Class User.DHCPEArcimPMLog Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_ArcimPMLog ]
{

Parameter ClassName = "User.DHCPEArcimPMLog";

/// 操作类型 I：插入 U：更新 D：删除
Property APMLType As %String(COLLATION = "ALPHAUP", VALUELIST = ",I,U,D") [ Required, SqlColumnNumber = 2, SqlFieldName = APML_Type ];

/// 节点
Property APMLNode As %Integer [ Required, SqlColumnNumber = 3, SqlFieldName = APML_Node ];

/// 科室
Property APMLLoc As User.CTLoc [ Required, SqlColumnNumber = 4, SqlFieldName = APML_Loc ];

/// 日期
Property APMLDate As %Date [ Required, SqlColumnNumber = 5, SqlFieldName = APML_Date ];

/// 原信息
Property APMLOldInfo As %String(MAXLEN = 500) [ SqlColumnNumber = 6, SqlFieldName = APML_OldInfo ];

/// 新信息
Property APMLNewInfo As %String(MAXLEN = 500) [ SqlColumnNumber = 7, SqlFieldName = APML_NewInfo ];

/// 备注
Property APMLRemark As %String(MAXLEN = 500) [ SqlColumnNumber = 8, SqlFieldName = APML_Reamrk ];

/// 更新人
Property APMLUpdateUserDR As User.SSUser [ Required, SqlColumnNumber = 9, SqlFieldName = APML_UpdateUser_DR ];

/// 操作日期
Property APMLUpdateDate As %Date [ Required, SqlColumnNumber = 10, SqlFieldName = APML_UpdateDate ];

/// 更新时间
Property APMLUpdateTime As %Time [ Required, SqlColumnNumber = 11, SqlFieldName = APML_UpdateTime ];

Index NodeLocDateIndex On (APMLNode, APMLLoc, APMLDate);

Storage Default
{
<Data name="DHCPEArcimPMLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>APMLType</Value>
</Value>
<Value name="3">
<Value>APMLNode</Value>
</Value>
<Value name="4">
<Value>APMLLoc</Value>
</Value>
<Value name="5">
<Value>APMLDate</Value>
</Value>
<Value name="6">
<Value>APMLOldInfo</Value>
</Value>
<Value name="7">
<Value>APMLNewInfo</Value>
</Value>
<Value name="8">
<Value>APMLRemark</Value>
</Value>
<Value name="9">
<Value>APMLUpdateUserDR</Value>
</Value>
<Value name="10">
<Value>APMLUpdateDate</Value>
</Value>
<Value name="11">
<Value>APMLUpdateTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEArcimPMLogD</DataLocation>
<DefaultData>DHCPEArcimPMLogDefaultData</DefaultData>
<IdLocation>^User.DHCPEArcimPMLogD</IdLocation>
<IndexLocation>^User.DHCPEArcimPMLogI</IndexLocation>
<StreamLocation>^User.DHCPEArcimPMLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
