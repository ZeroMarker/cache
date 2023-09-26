Class dbo.BDPackStockCount Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackStockCount ]
{

ForeignKey FKBDPackStcok(PackStockDR) References dbo.BDPackStock(PKPACKSTOCK) [ SqlName = FK_BD_PackStcok ];

ForeignKey FKSTOCKBloodProduct(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_STOCK_BloodProduct ];

ForeignKey FKSTBloodGroup(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_ST_BloodGroup ];

ForeignKey FKBBBPorductBComponets(BloodComponentsDR) References dbo.BBBloodComponents(PKBBBLOODCOMPONENTS) [ SqlName = FK_BB_BPorduct_BComponets ];

Index PKPACKSTOCKCOUNT On RowID [ PrimaryKey, SqlName = PK_BD_PACKSTOCKCOUNT, Type = index, Unique ];

Index IndexMaster On PackStockDR [ SqlName = Index_Master, Type = index ];

Index IndexBldComponets On (PackStockDR, BloodComponentsDR) [ SqlName = Index_BldComponets, Type = index ];

Index IndexBldProduct On (PackStockDR, BloodProductDR, BloodGroupDR) [ SqlName = Index_BldProduct, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property PackStockDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 账盘袋数
Property StcokBags As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 账盘血量
Property StcokVolume As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

/// 实盘袋数
Property RealBags As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 实盘血量
Property RealVolume As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

/// 差异袋数
Property DiffBags As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 差异血量
Property DiffVolume As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 11 ];

Property BloodComponentsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BDPackStockCountDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackStockDR</Value>
</Value>
<Value name="3">
<Value>BloodProductDR</Value>
</Value>
<Value name="4">
<Value>BloodGroupDR</Value>
</Value>
<Value name="5">
<Value>StcokBags</Value>
</Value>
<Value name="6">
<Value>StcokVolume</Value>
</Value>
<Value name="7">
<Value>RealBags</Value>
</Value>
<Value name="8">
<Value>RealVolume</Value>
</Value>
<Value name="9">
<Value>DiffBags</Value>
</Value>
<Value name="10">
<Value>DiffVolume</Value>
</Value>
<Value name="11">
<Value>BloodComponentsDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackStockCountD</DataLocation>
<DefaultData>BDPackStockCountDefaultData</DefaultData>
<IdLocation>^dbo.BDPackStockCountD</IdLocation>
<IndexLocation>^dbo.BDPackStockCountI</IndexLocation>
<StreamLocation>^dbo.BDPackStockCountS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
