///     
Class dbo.BTBillItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_BillItem ]
{

/// Foreign Key FKBTBillItemBillItemTypeDR created via DDL
ForeignKey FKBTBillItemBillItemTypeDR(BillItemTypeDR) References dbo.BTBillItemType(PKBTBILLITEMTYPE) [ SqlName = FK_BTBillItemBillItemTypeDR ];

/// DDL Primary Key Specification
Index PKBTBILLITEM On RowID [ PrimaryKey, SqlName = PK_BT_BILLITEM, Type = index, Unique ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property BillItemTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTBillItemDefaultData">
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
<Value>BillItemTypeDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTBillItemD</DataLocation>
<DefaultData>BTBillItemDefaultData</DefaultData>
<IdLocation>^dbo.BTBillItemD</IdLocation>
<IndexLocation>^dbo.BTBillItemI</IndexLocation>
<StreamLocation>^dbo.BTBillItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
