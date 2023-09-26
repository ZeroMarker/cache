/// RGLotBox
Class dbo.RGLotBox Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_LotBox, StorageStrategy = Default ]
{

/// Foreign Key FKRGLotBoxRGLot created via DDL
ForeignKey FKRGLotBoxRGLot(LotDR) References dbo.RGLot(PKRGLOT) [ SqlName = FK_RG_LotBox_RG_Lot ];

Index IndexMaster On (LotDR, BoxNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IXRGLotBox On BoxBarcode [ SqlName = IX_RG_LotBox, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRGLotBox On RowID [ PrimaryKey, SqlName = PK_RG_LotBox, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 试剂批次  
Property LotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 试剂盒号序号  
Property BoxNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 试剂盒条码号  
Property BoxBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 5 ];

/// 已出库  {1:true,0:false}
Property IsOuted As %Library.Boolean [ Required, SqlColumnNumber = 6 ];

/// 已使用  {1:true,0:false}
Property IsUsed As %Library.Boolean [ Required, SqlColumnNumber = 7 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="RGLotBoxDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>LotDR</Value>
</Value>
<Value name="4">
<Value>BoxNo</Value>
</Value>
<Value name="5">
<Value>BoxBarcode</Value>
</Value>
<Value name="6">
<Value>IsOuted</Value>
</Value>
<Value name="7">
<Value>IsUsed</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.RGLotBoxD</DataLocation>
<DefaultData>RGLotBoxDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGLotBoxD</IdLocation>
<IndexLocation>^dbo.RGLotBoxI</IndexLocation>
<StreamLocation>^dbo.RGLotBoxS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
