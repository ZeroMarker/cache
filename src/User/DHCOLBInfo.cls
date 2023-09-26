/// OLB Information
Class User.DHCOLBInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ID, SqlTableName = DHC_OLBInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Server Reference RowID
Property ServerDR As User.DHCOLBServer [ SqlColumnNumber = 2 ];

/// Client Reference RowID
Property ClientDR As User.DHCOLBClient [ SqlColumnNumber = 3 ];

/// ServerIP
Property ServerIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// ComputerIP
Property ComputerIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// ComputerMac
Property ComputerMac As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// ComputerName
Property ComputerName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// ConnUpdateUser
Property ConnUpdateUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

/// ConnUpdateDate
Property ConnUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9 ];

/// ConnUpdateTime
Property ConnUpdateTime As %Library.Time [ SqlColumnNumber = 10 ];

/// Info Note
Property Note As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

/// Process ID
Property ProcessId As %Library.Float [ SqlColumnNumber = 12 ];

/// Connection CTLoc
Property ConnLoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

/// Connection Group
Property ConnGroup As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOLBInfo)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ClientDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ComputerIP">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ComputerMac">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ComputerName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ConnGroup">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ConnLoc">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ConnUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ConnUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ConnUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Note">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ProcessId">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ServerDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ServerIP">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCOLBInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexClientDR">
<Global>^DHCOLBInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ClientDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ClientDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexComputerIP">
<Global>^DHCOLBInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ComputerIP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ComputerIP}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexComputerMac">
<Global>^DHCOLBInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ComputerMac"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ComputerMac}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexComputerName">
<Global>^DHCOLBInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ComputerName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ComputerName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConnUpdateDate">
<Global>^DHCOLBInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ConnUpdateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ConnUpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConnUpdateTime">
<Global>^DHCOLBInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ConnUpdateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ConnUpdateTime}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConnUpdateUser">
<Global>^DHCOLBInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ConnUpdateUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ConnUpdateUser}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServerClient">
<Global>^DHCOLBInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ServerClient"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ServerIP}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ComputerIP}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServerClientUser">
<Global>^DHCOLBInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ServerClientUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ServerIP}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ComputerIP}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ConnUpdateUser}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServerDR">
<Global>^DHCOLBInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ServerDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ServerDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServerIP">
<Global>^DHCOLBInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ServerIP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ServerIP}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServerUser">
<Global>^DHCOLBInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ServerUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ServerIP}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ConnUpdateUser}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOLBInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
