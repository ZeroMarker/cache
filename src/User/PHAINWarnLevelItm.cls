/// 警示级别子表
Class User.PHAINWarnLevelItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlTableName = PHAIN_WarnLevelItm ]
{

Relationship PWLIParRef As User.PHAINWarnLevel [ Cardinality = parent, Inverse = ChildItem, SqlFieldName = PWLI_ParRef ];

/// 代码
Property PWLICode As %String [ SqlColumnNumber = 2, SqlFieldName = PWLI_Code ];

/// 描述
Property PWLIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PWLI_Desc ];

Storage Default
{
<Data name="PHAINFaceItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PWLICode</Value>
</Value>
<Value name="3">
<Value>PWLIDesc</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ITM")</DataLocation>
<DefaultData>PHAINWarnLevelItmDefaultData</DefaultData>
<ExtentSize>200</ExtentSize>
<IdLocation>{%%PARENT}("ITM")</IdLocation>
<IndexLocation>^CD.PHA.IN.WarnLevlI</IndexLocation>
<SqlChildSub>PWLI_ChildSub</SqlChildSub>
<SqlRowIdName>PWLI_RowID</SqlRowIdName>
<StreamLocation>^CD.PHA.IN.WarnLevlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
