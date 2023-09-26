///     
Class dbo.RGStkInOrder Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_StkInOrder, StorageStrategy = Default ]
{

Index IndexMaster On (StkInDR, OrderDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexOrder On OrderDR [ SqlName = Index_Order, Type = index ];

Index IndexStkIn On StkInDR [ SqlName = Index_StkIn, Type = index ];

/// DDL Primary Key Specification
Index PKRGSTKINORDER On RowID [ PrimaryKey, SqlName = PK_RG_STKINORDER, Type = index, Unique ];

/// Foreign Key FKRGStkInOrderOrder created via DDL
ForeignKey FKRGStkInOrderOrder(OrderDR) References dbo.RGOrder(PKRGORDER) [ SqlName = FK_RG_StkInOrder_Order ];

/// Foreign Key FKRGStkInOrderStkIn created via DDL
ForeignKey FKRGStkInOrderStkIn(StkInDR) References dbo.RGStkIn(PKRGSTKIN) [ SqlName = FK_RG_StkInOrder_StkIn ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StkInDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OrderDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="RGStkInOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StkInDR</Value>
</Value>
<Value name="3">
<Value>OrderDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RGStkInOrderD</DataLocation>
<DefaultData>RGStkInOrderDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGStkInOrderD</IdLocation>
<IndexLocation>^dbo.RGStkInOrderI</IndexLocation>
<StreamLocation>^dbo.RGStkInOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
