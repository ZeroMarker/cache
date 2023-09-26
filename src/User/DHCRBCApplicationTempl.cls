/// /
Class User.DHCRBCApplicationTempl Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DAST_RowID, SqlTableName = DHCRBC_ApplicationTempl, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DAST_ApplicationShape_DR
Property DASTApplicationShapeDR As User.DHCRBCApplicationShape [ SqlColumnNumber = 2, SqlFieldName = DAST_ApplicationShape_DR ];

/// DAST_AppLoc_DR
Property DASTAppLocDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DAST_AppLoc_DR ];

/// DAST_Content
Property DASTContent As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DAST_Content ];

/// DAST_FieldTag
Property DASTFieldTag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DAST_FieldTag ];

/// DAST_
Property DASTTemplName As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DAST_TemplName ];

/// DSAT_User_DR
Property DSATUserDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DSAT_User_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCApp("Template"))</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^DHCRBCAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DAST_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Loc-Template"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAST_AppLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DAST_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DAST_AppLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DAST_ApplicationShape_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DAST_Content">
<Node>"Content"</Node>
</Data>
<Data name="DAST_FieldTag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DAST_TemplName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSAT_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCRBCApp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DAST_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Template"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAST_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCApplicationTemplS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
