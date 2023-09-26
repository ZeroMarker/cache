Class User.DHCRBCItemBase Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DIB_RowID, SqlTableName = DHCRBC_ItemBase, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Name
Property DIBName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DIB_Name ];

/// Description
Property DIBDescription As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DIB_Description ];

/// DIB_LocID
Property DIBLocID As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = DIB_LocID ];

/// DIB_Unit
Property DIBUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DIB_Unit ];

/// DIB_MIN
Property DIBMIN As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DIB_MIN ];

/// DIB_MAX
Property DIBMAX As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DIB_MAX ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCItemBase("Base"))</SqlIdExpression>
<SQLMap name="Datamastermap">
<Data name="DIB_Description">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DIB_LocID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DIB_MAX">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DIB_MIN">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DIB_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIB_Unit">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCRBCItemBase</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DIB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Base"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIB_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocID">
<Global>^DHCRBCItemBasei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DIB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIB_LocID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCItemBaseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
