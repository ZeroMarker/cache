/// 血液盘库明细
Class dbo.BDStockCheckItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_StockCheckItem ]
{

/// Foreign Key FKBDStockCheckItemStockCheckDR created via DDL
ForeignKey FKBDStockCheckItemStockCheckDR(StockCheckDR) References dbo.BDStockCheck(PKBDSTOCKCHECK) [ SqlName = FK_BDStockCheckItemStockCheckDR ];

/// Foreign Key FKBDStockCheckItemPackDR created via DDL
ForeignKey FKBDStockCheckItemPackDR(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BDStockCheckItemPackDR ];

/// Foreign Key FKBDStockCheckItemBloodProductDR created via DDL
ForeignKey FKBDStockCheckItemBloodProductDR(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BDStockCheckItemBloodProductDR ];

/// Foreign Key FKBDStockCheckItemBloodGroupDR created via DDL
ForeignKey FKBDStockCheckItemBloodGroupDR(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BDStockCheckItemBloodGroupDR ];

/// Foreign Key FKBDStockCheckItemSupplierDR created via DDL
ForeignKey FKBDStockCheckItemSupplierDR(SupplierDR) References dbo.BBSupplier(PKBBSUPPLIER) [ SqlName = FK_BDStockCheckItemSupplierDR ];

/// DDL Primary Key Specification
Index PKBDSTOCKCHECKITEM On RowID [ PrimaryKey, SqlName = PK_BD_STOCKCHECKITEM, Type = index, Unique ];

Index IndexMaster On (StockCheckDR, PackBarcode, ProductBarcode) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPack On (StockCheckDR, PackDR) [ SqlName = Index_Pack, Type = index ];

Index IndexCheckType On (StockCheckDR, CheckType) [ SqlName = Index_CheckType, Type = index ];

Index IndexStockCheckDate On (StockCheckDR, StockCheckDate, StockCheckTime) [ SqlName = Index_StockCheckDate, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 盘库单
Property StockCheckDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血袋条码
Property PackBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

/// 血制品条码
Property ProductBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

/// 血袋
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 盘点类型  0:盘亏, 1:正常，2:盘盈（入库），3:盘盈（返库） 枚举类：BLD.ENUM.BDStockCheckItem
Property CheckType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 7 ];

/// 血液产品
Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 血型组
Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 有效日期
Property ExpiredDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 有效时间
Property ExpiredTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 血量
Property PackVolume As %Library.Float [ SqlColumnNumber = 12 ];

/// 入库单价
Property InPrice As %Library.Float [ SqlColumnNumber = 13 ];

/// 血站
Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 14 ];

/// 盘点日期
Property StockCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 盘点时间
Property StockCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="BDStockCheckItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StockCheckDR</Value>
</Value>
<Value name="3">
<Value>PackBarcode</Value>
</Value>
<Value name="4">
<Value>ProductBarcode</Value>
</Value>
<Value name="5">
<Value>PackDR</Value>
</Value>
<Value name="6">
<Value>CheckType</Value>
</Value>
<Value name="7">
<Value>BloodProductDR</Value>
</Value>
<Value name="8">
<Value>BloodGroupDR</Value>
</Value>
<Value name="9">
<Value>ExpiredDate</Value>
</Value>
<Value name="10">
<Value>ExpiredTime</Value>
</Value>
<Value name="11">
<Value>PackVolume</Value>
</Value>
<Value name="12">
<Value>InPrice</Value>
</Value>
<Value name="13">
<Value>SupplierDR</Value>
</Value>
<Value name="14">
<Value>StockCheckDate</Value>
</Value>
<Value name="15">
<Value>StockCheckTime</Value>
</Value>
</Data>
<DataLocation>^dbo.BDStockCheckItemD</DataLocation>
<DefaultData>BDStockCheckItemDefaultData</DefaultData>
<IdLocation>^dbo.BDStockCheckItemD</IdLocation>
<IndexLocation>^dbo.BDStockCheckItemI</IndexLocation>
<StreamLocation>^dbo.BDStockCheckItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
