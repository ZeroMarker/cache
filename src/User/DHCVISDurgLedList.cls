/// Durg Led Show List
Class User.DHCVISDurgLedList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHC_VIS_DurgLedList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PatNo
Property PatNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// PatName
Property PatName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// PrescNo
Property PrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// WindowDesc
Property WindowDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// WindowNo
Property WindowNo As %Library.Float [ SqlColumnNumber = 6 ];

/// UseFlag
Property ActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7 ];

/// InsertDate
Property InsertDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8 ];

/// InsertTime
Property InsertTime As %Library.Time [ SqlColumnNumber = 9 ];

/// InsertUser
Property InsertUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

/// Window Top IP
Property TopIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

/// Presc State
Property PrescState As %Library.String(DISPLAYLIST = ",Wait,Dispensing,Skip", MAXLEN = 10, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",W,D,S") [ SqlColumnNumber = 12 ];

/// Voice Server ID
Property ServerID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISDurgList)</SqlIdExpression>
<SQLMap name="IndexDateServerWindowNo">
<Global>^DHCVISDurgListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ServerWindowNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InsertDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ServerID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WindowNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ActiveFlag}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateTopIP">
<Global>^DHCVISDurgListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TopIP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InsertDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TopIP}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PrescState}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateWindowNo">
<Global>^DHCVISDurgListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WindowNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InsertDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WindowNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ActiveFlag}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^DHCVISDurgListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrescNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrescNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InsertDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="InsertTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="InsertUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PatName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PatNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PrescState">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ServerID">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TopIP">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WindowDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WindowNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCVISDurgList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCVISDurgLedListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
