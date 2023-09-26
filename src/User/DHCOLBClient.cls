/// DHC OLB Client
Class User.DHCOLBClient Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ID, SqlTableName = DHC_OLBClient, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Client Name
Property ClientName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// Server Reference RowID
Property ServerDR As User.DHCOLBServer [ SqlColumnNumber = 3 ];

/// Active Flag
Property ActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4 ];

/// Computer IP
Property ComputerIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// Computer Mac
Property ComputerMac As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// Computer Name
Property ComputerName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// ComputerIPUpper
Property ComputerIPUpper As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

/// ComputerIPLower
Property ComputerIPLower As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

/// Note
Property Note As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOLBClient)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ClientName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ComputerIP">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ComputerIPLower">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ComputerIPUpper">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ComputerMac">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ComputerName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Note">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ServerDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCOLBClient</Global>
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
<SQLMap name="IndexActiveFlag">
<Global>^DHCOLBClienti</Global>
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
<Expression>"ActiveFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ActiveFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexClientName">
<Global>^DHCOLBClienti</Global>
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
<Expression>"ClientName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ClientName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexComputerIP">
<Global>^DHCOLBClienti</Global>
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
<SQLMap name="IndexComputerIPLower">
<Global>^DHCOLBClienti</Global>
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
<Expression>"ComputerIPLower"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ComputerIPLower}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexComputerIPUpper">
<Global>^DHCOLBClienti</Global>
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
<Expression>"ComputerIPUpper"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ComputerIPUpper}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexComputerMac">
<Global>^DHCOLBClienti</Global>
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
<Global>^DHCOLBClienti</Global>
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
<SQLMap name="IndexServer">
<Global>^DHCOLBClienti</Global>
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
<StreamLocation>^User.DHCOLBClientS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
