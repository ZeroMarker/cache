/// DHC_ANC_OperRoom
Class User.DHCANCOperRoom Extends %Library.Persistent [ ClassType = persistent, ClientName = n, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OPR_RowId, SqlTableName = DHC_ANC_OperRoom, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OPR_Ctloc_Dr
Property OPRCtlocDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = OPR_Ctloc_Dr ];

/// OPR_Code
Property OPRCode As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OPR_Code ];

/// OPR_Desc
Property OPRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OPR_Desc ];

/// OPR_Floor_Dr
Property OPRFloorDr As User.DHCANCFloor [ SqlColumnNumber = 5, SqlFieldName = OPR_Floor_Dr ];

/// OPR_OTType_Dr
Property OPROTTypeDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = OPR_OTType_Dr ];

/// OPR_DefUseCtloc_Dr
Property OPRDefUseCtlocDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = OPR_DefUseCtloc_Dr ];

/// OPR_Available
Property OPRAvailable As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = OPR_Available ];

/// OPR_NotAvailReason
Property OPRNotAvailReason As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = OPR_NotAvailReason ];

/// OPR_BedType
Property OPRBedType As %Library.String(DISPLAYLIST = ",Theatre,PACU,Induce", MAXLEN = 7, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",T,P,I") [ SqlColumnNumber = 10, SqlFieldName = OPR_BedType ];

/// 20141011new
Property OPRDefScrubNurseDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = OPR_DefScrubNurse_Dr ];

Property OPRDefCirculNurseDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = OPR_DefCirculNurse_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("OPRoom",0))</SqlIdExpression>
<SQLMap name="DHCANOPRoom">
<Data name="OPR_Available">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OPR_BedType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OPR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPR_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPR_DefCirculNurse_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OPR_DefScrubNurse_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OPR_DefUseCtloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OPR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPR_Floor_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPR_NotAvailReason">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OPR_OTType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OPR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPRoom"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OPR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLOC">
<Global>^DHCANC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OPR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPRoom"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CtLoc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPR_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDefDep">
<Global>^DHCANC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OPR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OPRoom"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DefDep"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPR_DefUseCtloc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANCOperRoomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
