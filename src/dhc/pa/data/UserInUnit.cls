Class dhc.pa.data.UserInUnit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UserInUnit_rowid, SqlTableName = UserInUnit ]
{

/// KPI
Property UserInUnitjxUnitDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 2, SqlFieldName = UserInUnit_jxUnitDr ];

Property UserInUnituserDr As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = UserInUnit_userDr ];

Storage Default
{
<Data name="UserInUnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserInUnitjxUnitDr</Value>
</Value>
<Value name="3">
<Value>UserInUnituserDr</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.data.UserInUnitD</DataLocation>
<DefaultData>UserInUnitDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.data.UserInUnitD</IdLocation>
<IndexLocation>^dhc.pa.data.UserInUnitI</IndexLocation>
<StreamLocation>^dhc.pa.data.UserInUnitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
