Class dbo.BBHandleWayFee Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_HandleWayFee, StorageStrategy = Default ]
{

/// Foreign Key FKBBBPFOBProduct created via DDL
ForeignKey FKBBHWFHandleWay(HandleWayDR) References dbo.BBHandleWay(PKBBHANDLEWAY) [ SqlName = FK_BB_HWF_HandleWay ];

/// Foreign Key FKBBBPFOCostItem created via DDL
ForeignKey FKBBHWFCostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BB_HWF_CostItem ];

Index IndexMaster On (HandleWayDR, HandleWay, CostItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBHANDLEWAYFEE On RowID [ PrimaryKey, SqlName = PK_BB_HANDLEWAYFEE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血液产品  
Property HandleWayDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 加工方式：{辐照：FZ,去白：QB，洗涤：XD}
Property HandleWay As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ Required, SqlColumnNumber = 4 ];

/// 收费项目  
Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 收费项目数量  
Property ItemNum As %Library.Float [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BBHandleWayFeeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HandleWayDR</Value>
</Value>
<Value name="3">
<Value>HandleWay</Value>
</Value>
<Value name="4">
<Value>CostItemDR</Value>
</Value>
<Value name="5">
<Value>ItemNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BBHandleWayFeeD</DataLocation>
<DefaultData>BBHandleWayFeeDefaultData</DefaultData>
<IdLocation>^dbo.BBHandleWayFeeD</IdLocation>
<IndexLocation>^dbo.BBHandleWayFeeI</IndexLocation>
<StreamLocation>^dbo.BBHandleWayFeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
