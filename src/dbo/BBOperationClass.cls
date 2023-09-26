/// 手术分类
Class dbo.BBOperationClass Extends (%Persistent, %XML.Adaptor) [ Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_OperationClass ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBOperationClassId On RowID [ PrimaryKey, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ Required, SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BBOperationClassDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBOperationClassD</DataLocation>
<DefaultData>BBOperationClassDefaultData</DefaultData>
<IdLocation>^dbo.BBOperationClassD</IdLocation>
<IndexLocation>^dbo.BBOperationClassI</IndexLocation>
<StreamLocation>^dbo.BBOperationClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
