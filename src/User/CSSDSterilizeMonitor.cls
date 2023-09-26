Class User.CSSDSterilizeMonitor Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_SterilizeMonitor ]
{

Relationship SMParRef As User.CSSDSterilizeRecord [ Cardinality = parent, Inverse = Monitor, Required, SqlFieldName = SM_ParRef ];

/// 类型
Property SMType As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 2, SqlFieldName = SM_Type ];

/// 人员
Property SMUserDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = SM_User_DR ];

/// 日期
Property SMDate As %Date [ SqlColumnNumber = 4, SqlFieldName = SM_Date ];

/// 时间
Property SMTime As %Time [ SqlColumnNumber = 5, SqlFieldName = SM_Time ];

/// 验收标志
Property SMAuditFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = SM_AuditFlag ];

/// 验收级别
Property SMLevel As %Numeric [ SqlColumnNumber = 7, SqlFieldName = SM_Level ];

Index Type On (SMParRef As Exact, SMType As Exact);

Index TypeLevel On (SMParRef As Exact, SMType As Exact, SMLevel As Exact);

Index TypeAudit On (SMParRef As Exact, SMType As Exact, SMAuditFlag As Exact);

Storage Default
{
<Data name="CSSDSterilizeMonitorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SMType</Value>
</Value>
<Value name="3">
<Value>SMUserDR</Value>
</Value>
<Value name="4">
<Value>SMDate</Value>
</Value>
<Value name="5">
<Value>SMTime</Value>
</Value>
<Value name="6">
<Value>SMAuditFlag</Value>
</Value>
<Value name="7">
<Value>SMLevel</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Monitor")</DataLocation>
<DefaultData>CSSDSterilizeMonitorDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Monitor")</IdLocation>
<IndexLocation>^User.CSSDSterilizeMonitorI</IndexLocation>
<StreamLocation>^User.CSSDSterilizeMonitorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
