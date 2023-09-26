/// DHC_PA_ProcBooking
Class User.DHCPAProcBooking Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PROCB_RowId, SqlTableName = DHC_PA_ProcBooking, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PROCBChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PA_Process Parent Reference
Relationship PROCBParref As User.DHCPAProcess [ Cardinality = parent, Inverse = ChildDHCPAProcBooking, Required, SqlFieldName = PROCB_Parref ];

/// PROCB_ChildSub
Property PROCBChildSub As %Library.Float [ InitialExpression = {$i(^DHCProc($p(%d(0),$c(1),1),"Booking",0))}, SqlColumnNumber = 2, SqlFieldName = PROCB_ChildSub ];

/// PROCB_Status
Property PROCBStatus As %Library.String(DISPLAYLIST = ",Booking,Admit,Cancel", MAXLEN = 7, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",B,A,C") [ SqlColumnNumber = 3, SqlFieldName = PROCB_Status ];

/// PROCB_BookingAdm_DR
Property PROCBBookingAdmDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PROCB_BookingAdm_DR ];

/// PROCB_BookingDept_DR
Property PROCBBookingDeptDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PROCB_BookingDept_DR ];

/// PROCB_BookingUser_DR
Property PROCBBookingUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PROCB_BookingUser_DR ];

/// PROCB_BookingDate
Property PROCBBookingDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PROCB_BookingDate ];

/// PROCB_BookingTime
Property PROCBBookingTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = PROCB_BookingTime ];

/// PROCB_AdmitAdm_DR
Property PROCBAdmitAdmDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PROCB_AdmitAdm_DR ];

/// PROCB_UpdateUser_Dr
Property PROCBUpdateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PROCB_UpdateUser_Dr ];

/// PROCB_UpdateDate
Property PROCBUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = PROCB_UpdateDate ];

/// PROCB_UpdateTime
Property PROCBUpdateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = PROCB_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PROCB_AdmitAdm_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PROCB_BookingAdm_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PROCB_BookingDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PROCB_BookingDept_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PROCB_BookingTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PROCB_BookingUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PROCB_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PROCB_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PROCB_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PROCB_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCProc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PA_Process.PROC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PROCB_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_PA_Process.PROC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Booking"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PROCB_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBookingAdm">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCProc</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PA_Process.PROC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PROCB_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BookingAdm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PROCB_BookingAdm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PROCB_Parref}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PROCB_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBookingDate">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCProc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PA_Process.PROC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PROCB_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BookingDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PROCB_BookingDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PROCB_Parref}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PROCB_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPAProcBookingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
