Class dbo.RPTransitItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_TransitItems, StorageStrategy = Default ]
{

Index IndexMaster On (TransitDR, Barcode) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexBarcode On Barcode [ SqlName = Index_Barcode, Type = index ];

/// DDL Primary Key Specification
Index PKRPTRANSITITEMS On RowID [ PrimaryKey, SqlName = PK_RP_TRANSITITEMS, Type = index, Unique ];

/// Foreign Key FKItemTransit created via DDL
ForeignKey FKItemTransit(TransitDR) References dbo.RPTransit(PKRPTRANSIT) [ SqlName = FK_ItemTransit ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 运送单
Property TransitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 条码号
Property Barcode As %Library.String(COLLATION = "EXACT", MAXLEN = 30) [ Required, SqlColumnNumber = 4 ];

/// 状态 1:未完成,2:完成,3:异常取消
Property Status As %Library.String(COLLATION = "EXACT", MAXLEN = 1) [ SqlColumnNumber = 5 ];

/// 备注
Property Remark As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="RPTransitItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransitDR</Value>
</Value>
<Value name="3">
<Value>Barcode</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.RPTransitItemsD</DataLocation>
<DefaultData>RPTransitItemsDefaultData</DefaultData>
<IdLocation>^dbo.RPTransitItemsD</IdLocation>
<IndexLocation>^dbo.RPTransitItemsI</IndexLocation>
<StreamLocation>^dbo.RPTransitItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
