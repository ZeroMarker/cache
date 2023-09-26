Class User.EnsSubApiSysConfig Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Ens_SubApiSysConfig ]
{

/// DDL Primary Key Specification
Index PKFunctionCode On (systemCode, systemHospital, systemVersion, systemFuncCode) [ PrimaryKey, SqlName = PK_FunctionCode, Type = index, Unique ];

/// Foreign Key FKParaRefFunc created via DDL
ForeignKey FKParaRefFunc(systemCode,systemHospital,systemVersion) References User.EnsApiSysConfig(PKSystemConfig) [ OnDelete = cascade, OnUpdate = cascade, SqlName = FK_Para_Ref_Func ];

/// 系统代码
Property systemCode As %String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = system_Code ];

/// 所属院区
Property systemHospital As %String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = system_Hospital ];

/// 系统版本
Property systemVersion As %String(COLLATION = "EXACT", MAXLEN = 200) [ InitialExpression = "Default", SqlColumnNumber = 4, SqlFieldName = system_Version ];

/// 功能代码
Property systemFuncCode As %String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 5, SqlFieldName = system_FuncCode ];

/// 功能描述
Property systemFuncDesc As %String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 6, SqlFieldName = system_FuncDesc ];

Storage Default
{
<Data name="EnsSubApiSysConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>systemCode</Value>
</Value>
<Value name="3">
<Value>systemHospital</Value>
</Value>
<Value name="4">
<Value>systemVersion</Value>
</Value>
<Value name="5">
<Value>systemFuncCode</Value>
</Value>
<Value name="6">
<Value>systemFuncDesc</Value>
</Value>
</Data>
<DataLocation>^Config.ENS.EnsSubApiSysConfigD</DataLocation>
<DefaultData>EnsSubApiSysConfigDefaultData</DefaultData>
<IdLocation>^Config.ENS.EnsSubApiSysConfigD</IdLocation>
<IndexLocation>^Config.ENS.EnsSubApiSysConfigI</IndexLocation>
<StreamLocation>^Config.ENS.EnsSubApiSysConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
