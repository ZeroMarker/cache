Class dbo.BBSupplierBldType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_SupplierBldType ]
{

Index IndexMaster On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBBldType On RowID [ PrimaryKey, SqlName = PK_BB_BldType, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBSupplierBldTypeDefaultData">
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
<Value>Unit</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBSupplierBldTypeD</DataLocation>
<DefaultData>BBSupplierBldTypeDefaultData</DefaultData>
<IdLocation>^dbo.BBSupplierBldTypeD</IdLocation>
<IndexLocation>^dbo.BBSupplierBldTypeI</IndexLocation>
<StreamLocation>^dbo.BBSupplierBldTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
