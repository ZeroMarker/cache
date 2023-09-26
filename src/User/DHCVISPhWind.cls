Class User.DHCVISPhWind Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ID, SqlTableName = DHC_VIS_PhWind, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// From Window ID
Property WindowId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// From Window State
Property WindowState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// Receive Window ID 
Property ReceiveWindowId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// Window Show Content
Property WindowContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// Change Date
Property ChangeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6 ];

/// Change Time
Property ChangeTime As %Library.Time [ SqlColumnNumber = 7 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISPhWind)</SqlIdExpression>
<SQLMap name="IndexDateWindow">
<Global>^DHCVISPhWindi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateWind"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ChangeDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WindowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MapMaster">
<Data name="ChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ChangeTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ReceiveWindowId">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WindowContent">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WindowId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WindowState">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCVISPhWind</Global>
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
<StreamLocation>^User.DHCVISPhWindS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
