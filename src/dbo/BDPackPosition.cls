///     
Class dbo.BDPackPosition Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackPosition, StorageStrategy = Default ]
{

/// Foreign Key FKPackPositionFridgeLayer created via DDL
ForeignKey FKPackPositionFridgeLayer(FridgeLayerDR) References dbo.BTFridgeLayer(PKBTFridgeLayer) [ SqlName = FK_PackPosition_FridgeLayer ];

Index IndexBarCode On BarCode [ SqlName = Index_BarCode, Type = index ];

Index IndexCode On (FridgeLayerDR, Code) [ SqlName = Index_Code, Type = index ];

/// DDL Primary Key Specification
Index PKBDPackPosition On RowID [ PrimaryKey, SqlName = PK_BD_PackPosition, Type = index, Unique ];

/// RowID
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 关联存储架
Property FridgeLayerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 条码
Property BarCode As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 6 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

/// 存储数量
Property PositionNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 计数号
Property CalNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BDPackPositionDefaultData">
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
<Value>FridgeLayerDR</Value>
</Value>
<Value name="5">
<Value>BarCode</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>PositionNum</Value>
</Value>
<Value name="8">
<Value>RowID</Value>
</Value>
<Value name="9">
<Value>CalNo</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackPositionD</DataLocation>
<DefaultData>BDPackPositionDefaultData</DefaultData>
<IdLocation>^dbo.BDPackPositionD</IdLocation>
<IndexLocation>^dbo.BDPackPositionI</IndexLocation>
<StreamLocation>^dbo.BDPackPositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
