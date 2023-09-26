///     
Class dbo.BDSendCost Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_SendCost, StorageStrategy = Default ]
{

/// Foreign Key FKBDSCostCostItem created via DDL
ForeignKey FKBDSCostCostItem(ReqFormCostItemDR) References dbo.BDReqFormCostItem(PKBDREQFORMCOSTITEM) [ SqlName = FK_BD_SCost_CostItem ];

/// Foreign Key FKBDSCostUser created via DDL
ForeignKey FKBDSCostUser(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_SCost_User ];

Index IndexIsSended On IsSended [ SqlName = Index_IsSended, Type = index ];

Index IndexReqFormCostItem On ReqFormCostItemDR [ SqlName = Index_ReqFormCostItem, Type = index ];

Index IndexSendDate On SendDate [ SqlName = Index_SendDate, Type = index ];

/// DDL Primary Key Specification
Index PKBDSENDCOST On RowID [ PrimaryKey, SqlName = PK_BD_SENDCOST, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqFormCostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property HISCostItemID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

Property Quantity As %Library.Float [ SqlColumnNumber = 5 ];

Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property SendDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property SendTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property IsSended As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BDSendCostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqFormCostItemDR</Value>
</Value>
<Value name="3">
<Value>HISCostItemID</Value>
</Value>
<Value name="4">
<Value>Quantity</Value>
</Value>
<Value name="5">
<Value>UserDR</Value>
</Value>
<Value name="6">
<Value>SendDate</Value>
</Value>
<Value name="7">
<Value>SendTime</Value>
</Value>
<Value name="8">
<Value>IsSended</Value>
</Value>
</Data>
<DataLocation>^dbo.BDSendCostD</DataLocation>
<DefaultData>BDSendCostDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDSendCostD</IdLocation>
<IndexLocation>^dbo.BDSendCostI</IndexLocation>
<StreamLocation>^dbo.BDSendCostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
