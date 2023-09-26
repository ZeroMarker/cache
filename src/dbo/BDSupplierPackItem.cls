Class dbo.BDSupplierPackItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_SupplierPackItem, StorageStrategy = Default ]
{

/// Foreign Key FKBDPIItemsPack created via DDL
ForeignKey FKBDSPItemSupplierPack(SupplierPackDR) References dbo.BDSupplierPack(PKBDSUPPLIERPACK) [ SqlName = FK_BDSPItem_SupplierPack ];

/// Foreign Key FKBDPIItemsPackIn created via DDL
ForeignKey FKBDSPItemPackCheckItem(PackCheckItemDR) References dbo.BBPackCheckItems(PKBBPACKCHECKITEMS) [ SqlName = FK_BDSPItem_PackCheckItem ];

Index IndexMaster On (SupplierPackDR, PackCheckItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (SupplierPackDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBDSUPPLIERPACKITEM On RowID [ PrimaryKey, SqlName = PK_BD_SUPPLIERPACKITEM, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血袋入库单  
Property SupplierPackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血袋  
Property PackCheckItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 结果  
Property Result As %Library.Boolean [ SqlColumnNumber = 5 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BDSupplierPackItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SupplierPackDR</Value>
</Value>
<Value name="3">
<Value>PackCheckItemDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDSupplierPackItemD</DataLocation>
<DefaultData>BDSupplierPackItemDefaultData</DefaultData>
<IdLocation>^dbo.BDSupplierPackItemD</IdLocation>
<IndexLocation>^dbo.BDSupplierPackItemI</IndexLocation>
<StreamLocation>^dbo.BDSupplierPackItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
