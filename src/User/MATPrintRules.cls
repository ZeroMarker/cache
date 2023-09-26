/// 物资打印模式说明表
Class User.MATPrintRules Extends (%Persistent, User.Abstract) [ SqlRowIdName = MATPR_RowId, SqlTableName = MAT_PrintRules ]
{

/// 打印代码
Property MATPRCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = MATPR_Code ];

/// 打印描述
Property MATPRDesc As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = MATPR_Desc ];

Index MATPRCode On MATPRCode As Exact;

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATPRCode</Value>
</Value>
<Value name="3">
<Value>MATPRDesc</Value>
</Value>
</Data>
<DataLocation>^User.MATPrintRulesD</DataLocation>
<IdLocation>^User.MATPrintRulesD</IdLocation>
<IndexLocation>^User.MATPrintRulesI</IndexLocation>
<SqlRowIdName>MATPR_RowId</SqlRowIdName>
<StreamLocation>^User.MATPrintRulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
