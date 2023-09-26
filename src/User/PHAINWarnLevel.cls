/// 药品警示级别主表
Class User.PHAINWarnLevel Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlTableName = PHAIN_WarnLevel ]
{

Relationship ChildItem As User.PHAINWarnLevelItm [ Cardinality = children, Inverse = PWLIParRef ];

/// 代码
Property PWLCode As %String [ SqlColumnNumber = 2, SqlFieldName = PWL_Code ];

/// 描述
Property PWLDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PWL_Desc ];

/// 类型
Property PWLType As %String [ SqlColumnNumber = 4, SqlFieldName = PWL_Type ];

Storage Default
{
<Data name="PHAINFaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PWLCode</Value>
</Value>
<Value name="3">
<Value>PWLDesc</Value>
</Value>
<Value name="4">
<Value>PWLType</Value>
</Value>
</Data>
<DataLocation>^CD.PHA.IN.WarnLevlD</DataLocation>
<DefaultData>PHAINWarnLevelDefaultData</DefaultData>
<ExtentSize>20</ExtentSize>
<IdLocation>^CD.PHA.IN.WarnLevlD</IdLocation>
<IndexLocation>^CD.PHA.IN.WarnLevlI</IndexLocation>
<SqlRowIdName>PWL_RowID</SqlRowIdName>
<StreamLocation>^CD.PHA.IN.WarnLevlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
