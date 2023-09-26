/// 质控批次项目
Class dbo.BTQCMatLotTCChild Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_MatLotTCChild ]
{

/// Foreign Key FKMatLotTCLot created via DDL
ForeignKey FKMatLotTCLot(MatLotTCDR) References dbo.BTQCMaterialLotTestCode(PKBTQCMATERIALLOTTESTCODE) [ SqlName = FK_MatLotTCLot ];

/// Foreign Key FKMatLotTCTc created via DDL
ForeignKey FKMatLotTCTc(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_MatLotTCTc ];

Index IndexMaster On (MatLotTCDR, StartDate, EndDate) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBTQCMATLOTTCCHILD On RowID [ PrimaryKey, SqlName = PK_BTQC_MATLOTTCCHILD, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 质控批次  
Property MatLotTCDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 质控浓度  
Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 靶值  
Property Mean As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 6 ];

/// 标准差  
Property SD As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 7 ];

/// 计算均值  
Property FloatMean As %Library.Float [ SqlColumnNumber = 8 ];

/// 计算标准差  
Property FloatSD As %Library.Float [ SqlColumnNumber = 9 ];

/// 检查方法  
Property TestMethod As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 10 ];

/// 靶值类型  {FX:固定,FL:浮动}
Property CalcType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 11 ];

/// 数值精确度(默认为两  
Property Precision As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 累计结果个数  
Property AccSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 累计均值  
Property AccMean As %Library.Float [ SqlColumnNumber = 14 ];

/// 累计标准差  
Property AccSD As %Library.Float [ SqlColumnNumber = 15 ];

/// 稀释倍数  
Property Dilutions As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 17 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 19 ];

/// 在控个数  
Property InControlNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 在控均值  
Property InControlMean As %Library.Float [ SqlColumnNumber = 21 ];

/// 在控标准差  
Property InControlSD As %Library.Float [ SqlColumnNumber = 22 ];

/// 是否取值  {1:true,0:false}
Property IsGetValue As %Library.Boolean [ SqlColumnNumber = 23 ];

/// 试剂批号  
Property RgLot As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 24 ];

/// 试剂厂家  
Property RgManufacturer As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 25 ];

/// 浓度单位  
Property LevelUnit As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 26 ];

/// 质控物厂家  
Property MatManufacturer As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 27 ];

/// 设置CV  
Property SetCV As %Library.Float [ SqlColumnNumber = 28 ];

/// 目标CV  
Property TargetCV As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 29 ];

/// 厂家均值  
Property ManufacturerMean As %Library.Float [ SqlColumnNumber = 30 ];

/// 厂家标准差  
Property ManufacturerSD As %Library.Float [ SqlColumnNumber = 31 ];

/// CV来源  
Property CVSource As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 32 ];

/// 批次序号  
Property LevelSeq As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 33 ];

/// 开始日期  
Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 34 ];

/// 结束日期  
Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 35 ];

/// 生产日期  
Property ProductDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 36 ];

/// 有效日期  
Property ExpiryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 37 ];

/// 关闭日期  
Property ClosingDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 38 ];

/// 校正液批次  
Property AmendLiquidLot As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 39 ];

/// 主波长  
Property WaveLengthMian As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 40 ];

/// 波长  
Property WaveLength As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 41 ];

/// 批号  
Property LotNo As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 42 ];

/// 试剂有效期  
Property RgEffectiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 43 ];

/// 校正液有效期  
Property AmendLiquidDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 44 ];

/// 校准液ID  
Property AmendLiquid As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 45 ];

Storage Default
{
<Data name="BTQCMatLotTCChildDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MatLotTCDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>LevelNo</Value>
</Value>
<Value name="5">
<Value>Mean</Value>
</Value>
<Value name="6">
<Value>SD</Value>
</Value>
<Value name="7">
<Value>FloatMean</Value>
</Value>
<Value name="8">
<Value>FloatSD</Value>
</Value>
<Value name="9">
<Value>TestMethod</Value>
</Value>
<Value name="10">
<Value>CalcType</Value>
</Value>
<Value name="11">
<Value>Precision</Value>
</Value>
<Value name="12">
<Value>AccSum</Value>
</Value>
<Value name="13">
<Value>AccMean</Value>
</Value>
<Value name="14">
<Value>AccSD</Value>
</Value>
<Value name="15">
<Value>Dilutions</Value>
</Value>
<Value name="16">
<Value>Remark</Value>
</Value>
<Value name="17">
<Value>Sequence</Value>
</Value>
<Value name="18">
<Value>Active</Value>
</Value>
<Value name="19">
<Value>InControlNum</Value>
</Value>
<Value name="20">
<Value>InControlMean</Value>
</Value>
<Value name="21">
<Value>InControlSD</Value>
</Value>
<Value name="22">
<Value>IsGetValue</Value>
</Value>
<Value name="23">
<Value>RgLot</Value>
</Value>
<Value name="24">
<Value>RgManufacturer</Value>
</Value>
<Value name="25">
<Value>LevelUnit</Value>
</Value>
<Value name="26">
<Value>MatManufacturer</Value>
</Value>
<Value name="27">
<Value>SetCV</Value>
</Value>
<Value name="28">
<Value>TargetCV</Value>
</Value>
<Value name="29">
<Value>ManufacturerMean</Value>
</Value>
<Value name="30">
<Value>ManufacturerSD</Value>
</Value>
<Value name="31">
<Value>CVSource</Value>
</Value>
<Value name="32">
<Value>LevelSeq</Value>
</Value>
<Value name="33">
<Value>StartDate</Value>
</Value>
<Value name="34">
<Value>EndDate</Value>
</Value>
<Value name="35">
<Value>ProductDate</Value>
</Value>
<Value name="36">
<Value>ExpiryDate</Value>
</Value>
<Value name="37">
<Value>ClosingDate</Value>
</Value>
<Value name="38">
<Value>AmendLiquidLot</Value>
</Value>
<Value name="39">
<Value>WaveLengthMian</Value>
</Value>
<Value name="40">
<Value>WaveLength</Value>
</Value>
<Value name="41">
<Value>LotNo</Value>
</Value>
<Value name="42">
<Value>RgEffectiveDate</Value>
</Value>
<Value name="43">
<Value>AmendLiquidDate</Value>
</Value>
<Value name="44">
<Value>AmendLiquid</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCMatLotTCChildD</DataLocation>
<DefaultData>BTQCMatLotTCChildDefaultData</DefaultData>
<IdLocation>^dbo.BTQCMatLotTCChildD</IdLocation>
<IndexLocation>^dbo.BTQCMatLotTCChildI</IndexLocation>
<StreamLocation>^dbo.BTQCMatLotTCChildS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
