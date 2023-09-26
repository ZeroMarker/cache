///     
Class dbo.BTQCMaterialLotTCParam Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_MaterialLotTCParam, StorageStrategy = Default ]
{

/// Foreign Key FKMaterialLotTCParamLot created via DDL
ForeignKey FKMaterialLotTCParamLot(MaterialLotDR) References dbo.BTQCMaterialLot(PKBTQCMATERIALLOT) [ SqlName = FK_MaterialLotTCParamLot ];

/// Foreign Key FKMaterialLotTCParamTc created via DDL
ForeignKey FKMaterialLotTCParamTc(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_MaterialLotTCParamTc ];

Index IndexMaster On (MaterialLotDR, TestCodeDR, LevelNo, ClosingDate) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTQCMATERIALLOTTCPARAM On RowID [ PrimaryKey, SqlName = PK_BTQC_MATERIALLOTTCPARAM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MaterialLotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property ClosingDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property LotNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

Property Mean As %Library.Float [ SqlColumnNumber = 8 ];

Property SD As %Library.Float [ SqlColumnNumber = 9 ];

Property FloatMean As %Library.Float [ SqlColumnNumber = 10 ];

Property FloatSD As %Library.Float [ SqlColumnNumber = 11 ];

Property TestMethod As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 12 ];

Property Precision As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property AccSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property AccMean As %Library.Float [ SqlColumnNumber = 15 ];

Property AccSD As %Library.Float [ SqlColumnNumber = 16 ];

Property Dilutions As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="BTQCMaterialLotTCParamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialLotDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>LevelNo</Value>
</Value>
<Value name="5">
<Value>ClosingDate</Value>
</Value>
<Value name="6">
<Value>LotNo</Value>
</Value>
<Value name="7">
<Value>Mean</Value>
</Value>
<Value name="8">
<Value>SD</Value>
</Value>
<Value name="9">
<Value>FloatMean</Value>
</Value>
<Value name="10">
<Value>FloatSD</Value>
</Value>
<Value name="11">
<Value>TestMethod</Value>
</Value>
<Value name="12">
<Value>Precision</Value>
</Value>
<Value name="13">
<Value>AccSum</Value>
</Value>
<Value name="14">
<Value>AccMean</Value>
</Value>
<Value name="15">
<Value>AccSD</Value>
</Value>
<Value name="16">
<Value>Dilutions</Value>
</Value>
<Value name="17">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCMaterialLotTCParamD</DataLocation>
<DefaultData>BTQCMaterialLotTCParamDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTQCMaterialLotTCParamD</IdLocation>
<IndexLocation>^dbo.BTQCMaterialLotTCParamI</IndexLocation>
<StreamLocation>^dbo.BTQCMaterialLotTCParamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
