/// BTFridgeStorage
Class dbo.BTFridgeStorage Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_FridgeStorage ]
{

/// Foreign Key FKSpecimenRackFridge created via DDL
ForeignKey FKSpecimenRackFridge(FridgeDR) References dbo.BTFridge(PKBTFRIDGE) [ SqlName = FK_SpecimenRackFridge ];

/// Foreign Key FKStorageStructDR created via DDL
ForeignKey FKStorageStructDR(StorageStructDR) References dbo.BTStorageStruct(PKBTSTORAGESTRUCT) [ SqlName = FK_StorageStructDR ];

/// Foreign Key FKFridgeType created via DDL
ForeignKey FKFridgeType(FridgeTypeDR) References dbo.BTFridgeType(PKBTFRIDGETYPE) [ SqlName = FK_FridgeType ];

Index IndexBarcode On Barcode [ SqlName = Index_Barcode, Type = index ];

Index IndexSequence On (FridgeDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexCode On (FridgeDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexLayerNo On (FridgeDR, LayerNo) [ SqlName = Index_LayerNo, Type = index ];

/// DDL Primary Key Specification
Index PKBTFRIDGESTORAGE On RowID [ PrimaryKey, SqlName = PK_BT_FRIDGESTORAGE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 编码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 冰箱  
Property FridgeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 层数  
Property LayerNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 存储结构  
Property StorageStructDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 保存天数  
Property HoldDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 警告天数  
Property WarningDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 架子条码  
Property Barcode As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 10 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

/// 类型  
Property FridgeTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

///       
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BTFridgeStorageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>FridgeDR</Value>
</Value>
<Value name="5">
<Value>LayerNo</Value>
</Value>
<Value name="6">
<Value>StorageStructDR</Value>
</Value>
<Value name="7">
<Value>HoldDays</Value>
</Value>
<Value name="8">
<Value>WarningDays</Value>
</Value>
<Value name="9">
<Value>Barcode</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
<Value name="11">
<Value>FridgeTypeDR</Value>
</Value>
<Value name="12">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTFridgeStorageD</DataLocation>
<DefaultData>BTFridgeStorageDefaultData</DefaultData>
<IdLocation>^dbo.BTFridgeStorageD</IdLocation>
<IndexLocation>^dbo.BTFridgeStorageI</IndexLocation>
<StreamLocation>^dbo.BTFridgeStorageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
