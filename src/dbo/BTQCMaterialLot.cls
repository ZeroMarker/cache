/// 质控批次
Class dbo.BTQCMaterialLot Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_MaterialLot, StorageStrategy = Default ]
{

Index IndexMaterialDR On MaterialDR [ SqlName = Index_MaterialDR, Type = index, Unique ];

/// Foreign Key FKMaterialLot created via DDL
ForeignKey FKMaterialLot(MaterialDR) References dbo.BTQCMaterial(PKBTQCMATERIAL) [ SqlName = FK_MaterialLot ];

Index IndexMaster On (MaterialDR, Code) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBTQCMATERIALLOT On RowID [ PrimaryKey, SqlName = PK_BTQC_MATERIALLOT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 编码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 质控物  
Property MaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 批号  
Property LotNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

/// 开始日期  
Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 结束日期  
Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 生产日期  
Property ProductDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 有效日期  
Property ExpiryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 厂家  
Property Manufacturer As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 10 ];

/// 当前批次  {1:true,0:false}
Property CurrentLot As %Library.Boolean [ SqlColumnNumber = 11 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 12 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 14 ];

/// 试剂有效期  
Property RgDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 校正液批次  
Property AmendLiquidLot As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

/// 校正液有效期  
Property AmendLiquidDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// CalcType  
Property CalcType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 18 ];

/// RgLot  
Property RgLot As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 19 ];

/// 校准液  
Property AmendLiquid As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 20 ];

/// 试剂厂家  
Property RgManufacturer As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="BTQCMaterialLotDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>MaterialDR</Value>
</Value>
<Value name="4">
<Value>LotNo</Value>
</Value>
<Value name="5">
<Value>StartDate</Value>
</Value>
<Value name="6">
<Value>EndDate</Value>
</Value>
<Value name="7">
<Value>ProductDate</Value>
</Value>
<Value name="8">
<Value>ExpiryDate</Value>
</Value>
<Value name="9">
<Value>Manufacturer</Value>
</Value>
<Value name="10">
<Value>CurrentLot</Value>
</Value>
<Value name="11">
<Value>Remark</Value>
</Value>
<Value name="12">
<Value>Sequence</Value>
</Value>
<Value name="13">
<Value>Active</Value>
</Value>
<Value name="14">
<Value>RgDate</Value>
</Value>
<Value name="15">
<Value>AmendLiquidLot</Value>
</Value>
<Value name="16">
<Value>AmendLiquidDate</Value>
</Value>
<Value name="17">
<Value>CalcType</Value>
</Value>
<Value name="18">
<Value>RgLot</Value>
</Value>
<Value name="19">
<Value>AmendLiquid</Value>
</Value>
<Value name="20">
<Value>RgManufacturer</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCMaterialLotD</DataLocation>
<DefaultData>BTQCMaterialLotDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTQCMaterialLotD</IdLocation>
<IndexLocation>^dbo.BTQCMaterialLotI</IndexLocation>
<StreamLocation>^dbo.BTQCMaterialLotS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
