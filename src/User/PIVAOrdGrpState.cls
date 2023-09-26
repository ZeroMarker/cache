Class User.PIVAOrdGrpState Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = POGS_RowID, SqlTableName = PIVA_OrdGrpState, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On POGSChildSub [ IdKey, PrimaryKey, Unique ];

/// PIVA_OrdGrp Parent Reference
Relationship POGSPOGParref As User.PIVAOrdGrp [ Cardinality = parent, Inverse = ChildPIVAOrdGrpState, Required, SqlFieldName = POGS_POG_Parref ];

Property POGSChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = POGS_ChildSub ];

/// POGS_PS_Dr
Property POGSPSDr As User.PIVAState [ SqlColumnNumber = 3, SqlFieldName = POGS_PS_Dr ];

/// POGS_SSUSR_Dr
Property POGSSSUSRDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = POGS_SSUSR_Dr ];

/// POGS_Date
Property POGSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = POGS_Date ];

/// POGS_Time
Property POGSTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = POGS_Time ];

/// POGS_Loc_Dr
Property POGSLocDr As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = POGS_Loc_Dr ];

/// POGS_No
Property POGSNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = POGS_No ];

/// POGS_PrintTimes
Property POGSPrintTimes As %Library.Double(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 9, SqlFieldName = POGS_PrintTimes ];

/// 自增序号:$i(^mdata("PIVAOrdGrpState"))
Property POGSSerialNo As %Library.Double(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 10, SqlFieldName = POGS_SerialNo ];

/// 连续扫描序号(默认为1)
Property POGSScanNo As %Library.Double(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 11, SqlFieldName = POGS_ScanNo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="POGS_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="POGS_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="POGS_No">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="POGS_PS_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="POGS_PrintTimes">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="POGS_SSUSR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="POGS_ScanNo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="POGS_SerialNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="POGS_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PIVA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_OrdGrp.POG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>POGS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PIVA_OrdGrp.POG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POGS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDATEUSER">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PIVA_OrdGrp.POG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>POGS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SDU"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POGS_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POGS_SSUSR_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PIVA_OrdGrp.POG_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{POGS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDATEUSERSTAT">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PIVA_OrdGrp.POG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>POGS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SDUS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POGS_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POGS_SSUSR_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POGS_PS_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{POGS_POG_Parref}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{POGS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLOCPS">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PIVA_OrdGrp.POG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>POGS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATELOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POGS_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POGS_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POGS_PS_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{POGS_POG_Parref}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{POGS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPS">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIVA_OrdGrp.POG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>POGS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POGS_PS_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIVA_OrdGrp.POG_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POGS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPogsNo">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PogsNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POGS_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIVA_OrdGrp.POG_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POGS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatUserScan">
<Global>^PIVA</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PIVA_OrdGrp.POG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>POGS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SUSCAN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POGS_PS_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POGS_SSUSR_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POGS_SerialNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{POGS_POG_Parref}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{POGS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVAOrdGrpStateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
