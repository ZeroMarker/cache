Class User.PIVABatFreq Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PBF_RowID, SqlTableName = PIVA_BatFreq, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PBF_PHCFR_Dr
Property PBFPHCFRDr As User.PHCFreq [ SqlColumnNumber = 2, SqlFieldName = PBF_PHCFR_Dr ];

/// PBF_BatNo
Property PBFBatNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PBF_BatNo ];

/// PBF_Time
Property PBFTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = PBF_Time ];

/// PBF_Ctloc_Dr
Property PBFCtlocDr As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = PBF_Ctloc_Dr ];

/// PBF_GrpNo
Property PBFGrpNo As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PBF_GrpNo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVABF)</SqlIdExpression>
<SQLMap name="DataMasterPIVABatFreq">
<Data name="PBF_BatNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PBF_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PBF_GrpNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PBF_PHCFR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PBF_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PIVABF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PBF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PBF_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFreqBat">
<Global>^PIVABF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PBF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FREQBAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBF_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBF_PHCFR_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PBF_BatNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PBF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFreqGrp">
<Global>^PIVABF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PBF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FREQGRP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBF_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBF_PHCFR_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PBF_GrpNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PBF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVABatFreqS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
