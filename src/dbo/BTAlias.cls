/// 别名翻译
Class dbo.BTAlias Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Alias, StorageStrategy = Default ]
{

Index IndexMaster On (TableName, DataAlias, DataID) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexDataID On (TableName, DataID) [ SqlName = Index_DataID, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTALIAS On RowID [ PrimaryKey, SqlName = PK_BT_ALIAS, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 表名  
Property TableName As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 3 ];

/// 别名  
Property DataAlias As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 表里数据ID  
Property DataID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTAliasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableName</Value>
</Value>
<Value name="3">
<Value>DataAlias</Value>
</Value>
<Value name="4">
<Value>DataID</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTAliasD</DataLocation>
<DefaultData>BTAliasDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTAliasD</IdLocation>
<IndexLocation>^dbo.BTAliasI</IndexLocation>
<StreamLocation>^dbo.BTAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
