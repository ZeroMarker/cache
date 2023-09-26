/// User Client Infomation
Class User.DHCVISClientInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ID, SqlTableName = DHC_VIS_ClientInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Client Room IP
Property ClientIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// UserID
Property UserID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// DocDr
Property DocDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// MarkDr
Property MarkDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// LastDate
Property LastDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6 ];

/// LastTime
Property LastTime As %Library.Time [ SqlColumnNumber = 7 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISClientInfo)</SqlIdExpression>
<SQLMap name="IndexClientIP">
<Global>^DHCVISClientInfoi</Global>
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
<Expression>"ClientIP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ClientIP}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDocDr">
<Global>^DHCVISClientInfoi</Global>
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
<Expression>"DocDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DocDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMarkDr">
<Global>^DHCVISClientInfoi</Global>
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
<Expression>"MarkDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MarkDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserID">
<Global>^DHCVISClientInfoi</Global>
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
<Expression>"UserID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UserID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="ClientIP">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DocDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LastDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LastTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MarkDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UserID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCVISClientInfo</Global>
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
<StreamLocation>^User.DHCVISClientInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
