/// Application & File Server
Class User.DHCOLBServer Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ID, SqlTableName = DHC_OLBServer, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Server Name
Property ServerName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// Sercer Site IP
Property ServerIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// Server Active Flag
Property ActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4 ];

/// Profile Reference RowID
Property ProfileDR As User.DHCOLBProfile [ SqlColumnNumber = 5 ];

/// Server License Max
Property LicenseMax As %Library.Float [ SqlColumnNumber = 6 ];

/// Server License Min
Property LicenseMin As %Library.Float [ SqlColumnNumber = 7 ];

/// Server IIS Connection Max
Property IISConMax As %Library.Float [ SqlColumnNumber = 8 ];

/// Server IIS Connection Minimum
Property IISConMin As %Library.Float [ SqlColumnNumber = 9 ];

/// Server CPU Maximum
Property CPUMax As %Library.Float [ SqlColumnNumber = 10 ];

/// Server Memory Maximum
Property MemoryMax As %Library.Float [ SqlColumnNumber = 11 ];

/// Server Note
Property Note As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOLBServer)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CPUMax">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IISConMax">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IISConMin">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LicenseMax">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LicenseMin">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MemoryMax">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Note">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ProfileDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ServerIP">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ServerName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCOLBServer</Global>
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
<SQLMap name="IndexActive">
<Global>^DHCOLBServeri</Global>
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
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ActiveFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProfile">
<Global>^DHCOLBServeri</Global>
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
<Expression>"Profile"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ProfileDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServerIP">
<Global>^DHCOLBServeri</Global>
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
<SQLMap name="IndexServerName">
<Global>^DHCOLBServeri</Global>
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
<Expression>"ServerName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ServerName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOLBServerS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
