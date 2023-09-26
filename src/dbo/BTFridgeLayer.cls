/// 冰箱层信息
Class dbo.BTFridgeLayer Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_FridgeLayer, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index ];

Index IndexMaster On (FridgeDR, LayerNo) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTFridgeLayer On RowID [ PrimaryKey, SqlName = PK_BT_FridgeLayer, Type = index, Unique ];

/// Foreign Key FKBTFridge created via DDL
ForeignKey FKBTFridge(FridgeDR) References dbo.BTFridge(PKBTFRIDGE) [ SqlName = FK_BT_Fridge ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 冰箱  
Property FridgeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 层编号  
Property LayerNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 5 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTFridgeLayerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FridgeDR</Value>
</Value>
<Value name="3">
<Value>LayerNo</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>CName</Value>
</Value>
</Data>
<DataLocation>^dbo.BTFridgeLayerD</DataLocation>
<DefaultData>BTFridgeLayerDefaultData</DefaultData>
<IdLocation>^dbo.BTFridgeLayerD</IdLocation>
<IndexLocation>^dbo.BTFridgeLayerI</IndexLocation>
<StreamLocation>^dbo.BTFridgeLayerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
