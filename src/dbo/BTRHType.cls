/// RH 表型
Class dbo.BTRHType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_RHType, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTRHTYPE On RowID [ PrimaryKey, SqlName = PK_BT_RHTYPE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 激活  {1:是,0:否}
Property Active As %Library.Boolean [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTRHTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Sequence</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRHTypeD</DataLocation>
<DefaultData>BTRHTypeDefaultData</DefaultData>
<IdLocation>^dbo.BTRHTypeD</IdLocation>
<IndexLocation>^dbo.BTRHTypeI</IndexLocation>
<StreamLocation>^dbo.BTRHTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
