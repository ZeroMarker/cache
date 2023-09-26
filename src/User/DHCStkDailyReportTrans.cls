Class User.DHCStkDailyReportTrans Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SDRT_RowId, SqlTableName = DHC_StkDailyReportTrans, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SDRTChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkDailyReport Parent Reference
Relationship SDRTSDRParref As User.DHCStkDailyReport [ Cardinality = parent, Inverse = ChildDHCStkDailyReportTrans, Required, SqlFieldName = SDRT_SDR_Parref ];

/// SDRT_ChildSub
Property SDRTChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SDRT_ChildSub ];

/// SDRT_Pointer
Property SDRTPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SDRT_Pointer ];

/// SDRT_Qty
Property SDRTQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SDRT_Qty ];

/// SDRT_RpAmt
Property SDRTRpAmt As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SDRT_RpAmt ];

/// SDRT_SpAmt
Property SDRTSpAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SDRT_SpAmt ];

/// SDRT_Type
Property SDRTType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SDRT_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexType">
<Global>^DHCSDR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_StkDaily.SD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_StkDailyReport.SDR_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SDRT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SDRT_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_StkDaily.SD_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_StkDailyReport.SDR_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SDRT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataDHCSDR">
<Data name="SDRT_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SDRT_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SDRT_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SDRT_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SDRT_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCSDR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkDaily.SD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_StkDailyReport.SDR_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>SDRT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_StkDaily.SD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"R"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_StkDailyReport.SDR_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"T"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SDRT_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCStkDailyReportTransS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
