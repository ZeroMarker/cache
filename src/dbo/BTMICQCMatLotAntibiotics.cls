Class dbo.BTMICQCMatLotAntibiotics Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMICQC_MatLotAntibiotics ]
{

/// DDL IndexMaster
Index IndexMaster On (MICQCMaterialDR, AntibioticsDR) [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKBTMICQCMatLotAntibioticsMICQCMaterialDR created via DDL
ForeignKey FKBTMICQCMatLotAntibioticsMICQCMaterialDR(MICQCMaterialDR) References dbo.BTMICQCMaterial(PKBTMICQCMATERIAL) [ SqlName = FK_BTMICQCMatLotAntibioticsMICQCMaterialDR ];

/// Foreign Key FKBTMICQCMatLotAntibioticsAntibioticsDR created via DDL
ForeignKey FKBTMICQCMatLotAntibioticsAntibioticsDR(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_BTMICQCMatLotAntibioticsAntibioticsDR ];

/// DDL Primary Key Specification
Index PKBTMICQCMATLOTANTIBIOTICS On RowID [ PrimaryKey, SqlName = PK_BTMIC_QCMATLOTANTIBIOTICS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MICQCMaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property MinVal As %Library.Float [ SqlColumnNumber = 5 ];

Property MaxVal As %Library.Float [ SqlColumnNumber = 6 ];

Property TestMethod As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 7 ];

Property CalcType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 8 ];

Property Precision As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Dilutions As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 11 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 13 ];

Property RgLot As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 14 ];

Property RgManufacturer As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 15 ];

Property MatManufacturer As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 16 ];

Property ManufacturerMin As %Library.Float [ SqlColumnNumber = 17 ];

Property ManufacturerMax As %Library.Float [ SqlColumnNumber = 18 ];

Property LevelSeq As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property ProductDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property ExpiryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Property ClosingDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

Property AntSenShow As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 25 ];

Storage Default
{
<Data name="BTMICQCMatLotAntibioticsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MICQCMaterialDR</Value>
</Value>
<Value name="3">
<Value>AntibioticsDR</Value>
</Value>
<Value name="4">
<Value>MinVal</Value>
</Value>
<Value name="5">
<Value>MaxVal</Value>
</Value>
<Value name="6">
<Value>TestMethod</Value>
</Value>
<Value name="7">
<Value>CalcType</Value>
</Value>
<Value name="8">
<Value>Precision</Value>
</Value>
<Value name="9">
<Value>Dilutions</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
<Value name="11">
<Value>Sequence</Value>
</Value>
<Value name="12">
<Value>Active</Value>
</Value>
<Value name="13">
<Value>RgLot</Value>
</Value>
<Value name="14">
<Value>RgManufacturer</Value>
</Value>
<Value name="15">
<Value>MatManufacturer</Value>
</Value>
<Value name="16">
<Value>ManufacturerMin</Value>
</Value>
<Value name="17">
<Value>ManufacturerMax</Value>
</Value>
<Value name="18">
<Value>LevelSeq</Value>
</Value>
<Value name="19">
<Value>StartDate</Value>
</Value>
<Value name="20">
<Value>EndDate</Value>
</Value>
<Value name="21">
<Value>ProductDate</Value>
</Value>
<Value name="22">
<Value>ExpiryDate</Value>
</Value>
<Value name="23">
<Value>ClosingDate</Value>
</Value>
<Value name="24">
<Value>AntSenShow</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMICQCMatLotAntibioticsD</DataLocation>
<DefaultData>BTMICQCMatLotAntibioticsDefaultData</DefaultData>
<IdLocation>^dbo.BTMICQCMatLotAntibioticsD</IdLocation>
<IndexLocation>^dbo.BTMICQCMatLotAntibioticsI</IndexLocation>
<StreamLocation>^dbo.BTMICQCMatLotAntibioticsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
