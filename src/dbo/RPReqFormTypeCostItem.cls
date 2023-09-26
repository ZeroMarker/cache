Class dbo.RPReqFormTypeCostItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_ReqFormTypeCostItem ]
{

Index IndexMaster On (ReqFormType, CostItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Index PKRPREQFORMTYPECOSTITEM On RowID [ PrimaryKey, SqlName = PK_RP_REQFORMTYPECOSTITEM, Type = index, Unique ];

/// Foreign Key FKBDRFCostICostItem created via DDL
ForeignKey FKBDRFCostICostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BD_RFCostI_CostItem ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqFormType As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 3 ];

Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="RPReqFormTypeCostItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqFormType</Value>
</Value>
<Value name="3">
<Value>CostItemDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.RPReqFormTypeCostItemD</DataLocation>
<DefaultData>RPReqFormTypeCostItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPReqFormTypeCostItemD</IdLocation>
<IndexLocation>^dbo.RPReqFormTypeCostItemI</IndexLocation>
<StreamLocation>^dbo.RPReqFormTypeCostItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
