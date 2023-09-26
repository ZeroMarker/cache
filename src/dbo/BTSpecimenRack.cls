/// BTSpecimenRack
Class dbo.BTSpecimenRack Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SpecimenRack, StorageStrategy = Default ]
{

/// Foreign Key FKSpecimenRackFridge created via DDL
ForeignKey FKSpecimenRackFridge(FridgeDR) References dbo.BTFridge(PKBTFRIDGE) [ SqlName = FK_SpecimenRackFridge ];

/// Foreign Key FKSpecimenRackSpecimenClass created via DDL
ForeignKey FKSpecimenRackSpecimenClass(SpecimenClassDR) References dbo.BTSpecimenGroup(PKBTSPECIMENGROUP) [ SqlName = FK_SpecimenRackSpecimenClass ];

/// Foreign Key FKSpecimenRackType created via DDL
ForeignKey FKSpecimenRackType(RackTypeDR) References dbo.BTRackType(PKBTRACKTYPE) [ SqlName = FK_SpecimenRackType ];

/// Foreign Key FKSpecimenRackType created via DDL
ForeignKey FKSpecimenRackLayer(LayerDR) References dbo.BTFridgeLayer(PKBTFridgeLayer) [ SqlName = FK_SpecimenRackLayer ];

Index IndexBarcode On Barcode [ SqlName = Index_Barcode, Type = index ];

Index IndexCode On (FridgeDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexLayerNo On (FridgeDR, LayerNo) [ SqlName = Index_LayerNo, Type = index ];

Index IndexFridgeLayer On (FridgeDR, LayerDR) [ SqlName = Index_FridgeLayer, Type = index ];

/// DDL Primary Key Specification
Index PKBTSPECIMENRACK On RowID [ PrimaryKey, SqlName = PK_BT_SPECIMENRACK, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 冰箱  
Property FridgeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 层号  
Property LayerNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 存储架类型  
Property RackTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 标本组  
Property SpecimenClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 存储天数  
Property HoldDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 预警天数  
Property WarningDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 检验号  
Property Barcode As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 11 ];

/// 是否激活  {1:True,0:False}
Property Active As %Library.Boolean [ SqlColumnNumber = 12 ];

/// 标本类型  
Property SpecType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ SqlColumnNumber = 13 ];

/// 层数  
Property LayerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BTSpecimenRackDefaultData">
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
<Value>RackTypeDR</Value>
</Value>
<Value name="7">
<Value>SpecimenClassDR</Value>
</Value>
<Value name="8">
<Value>HoldDays</Value>
</Value>
<Value name="9">
<Value>WarningDays</Value>
</Value>
<Value name="10">
<Value>Barcode</Value>
</Value>
<Value name="11">
<Value>Active</Value>
</Value>
<Value name="12">
<Value>SpecType</Value>
</Value>
<Value name="13">
<Value>LayerDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSpecimenRackD</DataLocation>
<DefaultData>BTSpecimenRackDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTSpecimenRackD</IdLocation>
<IndexLocation>^dbo.BTSpecimenRackI</IndexLocation>
<StreamLocation>^dbo.BTSpecimenRackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
