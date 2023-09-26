/// DHC OLB Pronfile
Class User.DHCOLBProfile Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ID, SqlTableName = DHC_OLBProfile, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OLB Name
Property OLBName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// Site IP address
Property SiteIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// Site Name
Property SiteName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// Application Name
Property Application As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// OLB Profile Note
Property Note As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOLBProfile)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Application">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Note">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OLBName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SiteIP">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SiteName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCOLBProfile</Global>
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
<SQLMap name="IndexApplication">
<Global>^DHCOLBProfilei</Global>
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
<Expression>"Application"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Application}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOLBName">
<Global>^DHCOLBProfilei</Global>
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
<Expression>"OLBName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OLBName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSiteIP">
<Global>^DHCOLBProfilei</Global>
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
<Expression>"SiteIP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SiteIP}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOLBProfileS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
