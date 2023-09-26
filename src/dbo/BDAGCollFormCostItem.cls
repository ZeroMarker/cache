///     
Class dbo.BDAGCollFormCostItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AGCollFormCostItem, StorageStrategy = Default ]
{

/// Foreign Key FKAGCollFormCostItem1 created via DDL
ForeignKey FKAGCollFormCostItem1(AGCollectFormDR) References dbo.BDAGCollForm(PKBDAGCOLLFORM) [ SqlName = FK_AGCollFormCostItem1 ];

/// Foreign Key FKAGCollFormCostItem2 created via DDL
ForeignKey FKAGCollFormCostItem2(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_AGCollFormCostItem2 ];

/// Foreign Key FKAGCollFormCostItemAddUser created via DDL
ForeignKey FKAGCollFormCostItemAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AGCollFormCostItem_AddUser ];

/// Foreign Key FKAGCollFormCostItemCancelUser created via DDL
ForeignKey FKAGCollFormCostItemCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AGCollFormCostItem_CancelUser ];

/// Foreign Key FKAGCollFormCostItemExecUser created via DDL
ForeignKey FKAGCollFormCostItemExecUser(ExecUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AGCollFormCostItem_ExecUser ];

Index IndexCostItem On (AGCollectFormDR, CostItemDR) [ SqlName = Index_CostItem, Type = index ];

Index IndexMaster On (AGCollectFormDR, CostType, CostItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDAGCOLLFORMCOSTITEM On RowID [ PrimaryKey, SqlName = PK_BD_AGCOLLFORMCOSTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AGCollectFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property CostType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Price As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ Required, SqlColumnNumber = 6 ];

Property Quantity As %Library.Float [ Required, SqlColumnNumber = 7 ];

Property PayAmount As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ Required, SqlColumnNumber = 8 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

Property ExecDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property ExecTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property ExecUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 18 ];

Property ItemStatus As %Library.SmallInt [ SqlColumnNumber = 19 ];

Property HisOrderID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="BDAGCollFormCostItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AGCollectFormDR</Value>
</Value>
<Value name="3">
<Value>CostType</Value>
</Value>
<Value name="4">
<Value>CostItemDR</Value>
</Value>
<Value name="5">
<Value>Price</Value>
</Value>
<Value name="6">
<Value>Quantity</Value>
</Value>
<Value name="7">
<Value>PayAmount</Value>
</Value>
<Value name="8">
<Value>AddDate</Value>
</Value>
<Value name="9">
<Value>AddTime</Value>
</Value>
<Value name="10">
<Value>AddUserDR</Value>
</Value>
<Value name="11">
<Value>ExecDate</Value>
</Value>
<Value name="12">
<Value>ExecTime</Value>
</Value>
<Value name="13">
<Value>ExecUserDR</Value>
</Value>
<Value name="14">
<Value>CancelDate</Value>
</Value>
<Value name="15">
<Value>CancelTime</Value>
</Value>
<Value name="16">
<Value>CancelUserDR</Value>
</Value>
<Value name="17">
<Value>Remark</Value>
</Value>
<Value name="18">
<Value>ItemStatus</Value>
</Value>
<Value name="19">
<Value>HisOrderID</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAGCollFormCostItemD</DataLocation>
<DefaultData>BDAGCollFormCostItemDefaultData</DefaultData>
<IdLocation>^dbo.BDAGCollFormCostItemD</IdLocation>
<IndexLocation>^dbo.BDAGCollFormCostItemI</IndexLocation>
<StreamLocation>^dbo.BDAGCollFormCostItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
