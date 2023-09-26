Class User.EnsApiSysConfig Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Ens_ApiSysConfig ]
{

Index systemCodeIndex On systemCode;

Index systemDescIndex On systemDesc;

Index hospitalIndex On systemHospital;

Index systemDBModeIndex On systemDBMode;

Index workGroupIndex On systemWorkGroup;

Index statusIndex On systemStatus;

/// DDL Primary Key Specification
Index PKSystemConfig On (systemCode, systemHospital, systemVersion) [ PrimaryKey, SqlName = PK_SystemConfig, Type = index, Unique ];

/// 系统代码
Property systemCode As %String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = system_Code ];

/// 系统描述
Property systemDesc As %String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 3, SqlFieldName = system_Desc ];

/// 所属院区
Property systemHospital As %String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 4, SqlFieldName = system_Hospital ];

/// 系统版本
Property systemVersion As %String(COLLATION = "EXACT", MAXLEN = 200) [ InitialExpression = "Default", SqlColumnNumber = 5, SqlFieldName = system_Version ];

/// 系统数据库模式（共库/分库）
Property systemDBMode As %String(MAXLEN = 200) [ SqlColumnNumber = 6, SqlFieldName = system_DBMode ];

/// 工作组
Property systemWorkGroup As %String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 7, SqlFieldName = system_WorkGroup ];

/// 状态(Yes：运行，No：停止)
Property systemStatus As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = system_Status ];

/// 科室代码
Property systemDeptCode As %String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 9, SqlFieldName = system_DeptCode ];

Storage Default
{
<Data name="EnsApiSysConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>systemCode</Value>
</Value>
<Value name="3">
<Value>systemDesc</Value>
</Value>
<Value name="4">
<Value>systemHospital</Value>
</Value>
<Value name="5">
<Value>systemVersion</Value>
</Value>
<Value name="6">
<Value>systemDBMode</Value>
</Value>
<Value name="7">
<Value>systemWorkGroup</Value>
</Value>
<Value name="8">
<Value>systemStatus</Value>
</Value>
<Value name="9">
<Value>systemDeptCode</Value>
</Value>
</Data>
<DataLocation>^Config.ENS.EnsApiSysConfigD</DataLocation>
<DefaultData>EnsApiSysConfigDefaultData</DefaultData>
<IdLocation>^Config.ENS.EnsApiSysConfigD</IdLocation>
<IndexLocation>^Config.ENS.EnsApiSysConfigI</IndexLocation>
<StreamLocation>^Config.ENS.EnsApiSysConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
