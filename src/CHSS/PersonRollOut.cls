Class CHSS.PersonRollOut Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RollOutRowId, SqlTableName = PersonRollOut ]
{

/// 个人档案主键	
Property PersonRowId As %String(MAXLEN = 60, TRUNCATE = 1);

Index PersonRowIdIndex On PersonRowId [ Unique ];

Storage Default
{
<Data name="PersonRollOutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonRowId</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonRollOutD</DataLocation>
<DefaultData>PersonRollOutDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonRollOutD</IdLocation>
<IndexLocation>^CHSS.PersonRollOutI</IndexLocation>
<StreamLocation>^CHSS.PersonRollOutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
