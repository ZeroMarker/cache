/// 收费项目关联
Class dbo.BTCostItemLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CostItemLink, StorageStrategy = Default ]
{

/// Foreign Key FKBTCILinkCostItem created via DDL
ForeignKey FKBTCILinkCostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BT_CILink_CostItem ];

/// Foreign Key FKBTCILinkHospital created via DDL
ForeignKey FKBTCILinkHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BT_CILink_Hospital ];

Index IndexHISCostItemID On HISCostItemID [ SqlName = Index_HISCostItemID, Type = index ];

Index IndexMaster On (CostItemDR, HospitalDR, HISCostItemID) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTCOSTITEMLINK On RowID [ PrimaryKey, SqlName = PK_BT_COSTITEMLINK, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 收费项目  
Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// HIS收费项  
Property HISCostItemID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

/// HIS收费数量  
Property HISCostItemQuantity As %Library.Float [ Required, SqlColumnNumber = 6 ];

/// 默认  {1:true,0:false}
Property IsDefalult As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTCostItemLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CostItemDR</Value>
</Value>
<Value name="3">
<Value>HospitalDR</Value>
</Value>
<Value name="4">
<Value>HISCostItemID</Value>
</Value>
<Value name="5">
<Value>HISCostItemQuantity</Value>
</Value>
<Value name="6">
<Value>IsDefalult</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCostItemLinkD</DataLocation>
<DefaultData>BTCostItemLinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTCostItemLinkD</IdLocation>
<IndexLocation>^dbo.BTCostItemLinkI</IndexLocation>
<StreamLocation>^dbo.BTCostItemLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
