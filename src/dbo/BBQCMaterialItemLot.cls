/// 输血质控 质控项目批号
Class dbo.BBQCMaterialItemLot Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BBQC_MaterialItemLot ]
{

/// Foreign Key FKBBQCMaterialItemLotMaterialItemDR created via DDL
ForeignKey FKBBQCMaterialItemLotMaterialItemDR(MaterialItemDR) References dbo.BBQCMaterialItem(PKBBQCMATERIALITEM) [ SqlName = FK_BBQCMaterialItemLotMaterialItemDR ];

/// Foreign Key FKBBQCMaterialItemLotManufacturerDR created via DDL
ForeignKey FKBBQCMaterialItemLotManufacturerDR(ManufacturerDR) References dbo.BBQCManufacturer(PKBBQCMANUFACTURER) [ SqlName = FK_BBQCMaterialItemLotManufacturerDR ];

/// DDL Primary Key Specification
Index PKBBQCMATERIALITEMLOT On RowID [ PrimaryKey, SqlName = PK_BBQC_MATERIALITEMLOT, Type = index, Unique ];

Index IndexMaster On (MaterialItemDR, StartDate) [ SqlName = Index_Master, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// MaterialItemDR  
Property MaterialItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 开始日期  
Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 批号  
Property LotNo As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 5 ];

/// LotMemo  
Property LotMemo As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 6 ];

/// ReagLotNo  
Property ReagLotNo As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 7 ];

/// 有效日期  
Property ExpiryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 仪器厂商  
Property ManufacturerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 结束日期  
Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BBQCMaterialItemLotDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialItemDR</Value>
</Value>
<Value name="3">
<Value>StartDate</Value>
</Value>
<Value name="4">
<Value>LotNo</Value>
</Value>
<Value name="5">
<Value>LotMemo</Value>
</Value>
<Value name="6">
<Value>ReagLotNo</Value>
</Value>
<Value name="7">
<Value>ExpiryDate</Value>
</Value>
<Value name="8">
<Value>ManufacturerDR</Value>
</Value>
<Value name="9">
<Value>EndDate</Value>
</Value>
</Data>
<DataLocation>^dbo.BBQCMaterialItemLotD</DataLocation>
<DefaultData>BBQCMaterialItemLotDefaultData</DefaultData>
<IdLocation>^dbo.BBQCMaterialItemLotD</IdLocation>
<IndexLocation>^dbo.BBQCMaterialItemLotI</IndexLocation>
<StreamLocation>^dbo.BBQCMaterialItemLotS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
