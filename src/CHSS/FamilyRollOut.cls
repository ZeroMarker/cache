Class CHSS.FamilyRollOut Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RollOutRowId, SqlTableName = FamilyRollOut ]
{

/// 家庭档案主键	
Property FamilyRowId As %String(MAXLEN = 60, TRUNCATE = 1);

Index FamilyRowIdIndex On FamilyRowId;

Storage Default
{
<Data name="FamilyRollOutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FamilyRowId</Value>
</Value>
</Data>
<DataLocation>^CHSS.FamilyRollOutD</DataLocation>
<DefaultData>FamilyRollOutDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.FamilyRollOutD</IdLocation>
<IndexLocation>^CHSS.FamilyRollOutI</IndexLocation>
<StreamLocation>^CHSS.FamilyRollOutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
