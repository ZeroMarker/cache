Class User.ACCTSysBusiType Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = Type_Rowid, SqlTableName = ACCT_SysBusiType ]
{

/// des ref to ACCTSysFun 业务类型
Property AcctSysModeDr As ACCTSysMode [ SqlFieldName = ACCT_SysMode_Dr ];

Property TypeCode As %String(MAXLEN = 10) [ Required, SqlFieldName = type_code ];

Property TypeName As %String(MAXLEN = 40) [ Required, SqlFieldName = type_name ];

Property WhileSql As %String(MAXLEN = 200) [ SqlFieldName = while_sql ];

Property IsPhase As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ Required, SqlFieldName = is_phase ];

Property IsInstall As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = is_install ];

Index PKModeDrTypeCode On (AcctSysModeDr, TypeCode) [ Unique ];

Storage Default
{
<Data name="ACCTSysBusiTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcctSysFunDr</Value>
</Value>
<Value name="3">
<Value>IsInstall</Value>
</Value>
<Value name="4">
<Value>IsPhase</Value>
</Value>
<Value name="5">
<Value>TypeId</Value>
</Value>
<Value name="6">
<Value>TypeName</Value>
</Value>
<Value name="7">
<Value>WhileSql</Value>
</Value>
<Value name="8">
<Value>AcctSysModeDr</Value>
</Value>
<Value name="9">
<Value>TypeCode</Value>
</Value>
</Data>
<DataLocation>^User.ACCTSysBusiTypeD</DataLocation>
<DefaultData>ACCTSysBusiTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTSysBusiTypeD</IdLocation>
<IndexLocation>^User.ACCTSysBusiTypeI</IndexLocation>
<StreamLocation>^User.ACCTSysBusiTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
