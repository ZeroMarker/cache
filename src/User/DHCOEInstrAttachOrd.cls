/// DHC Instruct Attach Order
Class User.DHCOEInstrAttachOrd Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INATT_RowId, SqlTableName = DHC_OE_InstrAttachOrd, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INATT_PhcInstr_dr
Property INATTPHCInstrDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = INATT_PHCInstr_Dr ];

/// INATT_PHCFreq_Dr
Property INATTPHCFreqDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = INATT_PHCFreq_Dr ];

/// INATT_RecLoc_Dr
Property INATTRecLocDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = INATT_RecLoc_Dr ];

/// INATT_ArcItmmast_Dr
Property INATTArcimDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = INATT_Arcim_Dr ];

/// INATT_OrdQty
Property INATTOrdQty As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = INATT_OrdQty ];

/// INATT_Default
Property INATTDefault As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = INATT_Default ];

/// INATT_Type
Property INATTType As %Library.String(DISPLAYLIST = ",Day,Freq,Normal", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",D,F,N") [ SqlColumnNumber = 8, SqlFieldName = INATT_Type ];

/// INATT_IneffectLoc
Property INATTIneffectLoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INATT_IneffectLoc ];

/// INATT_ExecLoc_Dr
Property INATTExecLocDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INATT_ExecLoc_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOEInstrAttachOrd(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INATT_Arcim_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INATT_Default">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INATT_ExecLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INATT_IneffectLoc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INATT_OrdQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INATT_PHCFreq_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INATT_PHCInstr_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INATT_RecLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INATT_Type">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCOEInstrAttachOrd</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INATT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INATT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPhcinLoc">
<Global>^DHCOEInstrAttachOrd</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INATT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PhcinLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INATT_PHCInstr_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INATT_ExecLoc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INATT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexphcinstr">
<Global>^DHCOEInstrAttachOrd</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INATT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHCInstr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INATT_PHCInstr_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INATT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOEInstrAttachOrdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
