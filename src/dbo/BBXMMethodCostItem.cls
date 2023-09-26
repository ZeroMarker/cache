///     
Class dbo.BBXMMethodCostItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_XMMethodCostItem, StorageStrategy = Default ]
{

/// Foreign Key FKBBXMMCICostItem created via DDL
ForeignKey FKBBXMMCICostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BB_XMMCI_CostItem ];

/// Foreign Key FKBBXMMCIMethod created via DDL
ForeignKey FKBBXMMCIMethod(XMMethodDR) References dbo.BBXMMethod(PKBBXMMETHOD) [ SqlName = FK_BB_XMMCI_Method ];

Index IndexMaster On (XMMethodDR, CostItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBXMMETHODCOSTITEM On RowID [ PrimaryKey, SqlName = PK_BB_XMMETHODCOSTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property XMMethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property BillType As %Library.SmallInt [ Required, SqlColumnNumber = 5 ];

Property Volumn As %Library.Float [ SqlColumnNumber = 6 ];

Property ItemNum As %Library.Float [ SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBXMMethodCostItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>XMMethodDR</Value>
</Value>
<Value name="3">
<Value>CostItemDR</Value>
</Value>
<Value name="4">
<Value>BillType</Value>
</Value>
<Value name="5">
<Value>Volumn</Value>
</Value>
<Value name="6">
<Value>ItemNum</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBXMMethodCostItemD</DataLocation>
<DefaultData>BBXMMethodCostItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBXMMethodCostItemD</IdLocation>
<IndexLocation>^dbo.BBXMMethodCostItemI</IndexLocation>
<StreamLocation>^dbo.BBXMMethodCostItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
