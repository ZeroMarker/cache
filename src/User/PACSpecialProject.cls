/// Special Project(2415)
Class User.PACSpecialProject Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SpecialProject, StorageStrategy = SQLStorage ]
{

Relationship ChildPACSpecialProjectHosp As PACSpecialProjectHosp [ Cardinality = children, Inverse = HOSParRef ];

/// Code
Property SPECPROCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SPECPRO_Code ];

/// Description
Property SPECPRODesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SPECPRO_Desc ];

/// Date From
Property SPECPRODateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = SPECPRO_DateFrom ];

/// Date To
Property SPECPRODateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = SPECPRO_DateTo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("SPECPRO",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="SPECPRO_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SPECPRO_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SPECPRO_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SPECPRO_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SPECPRO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SPECPRO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SPECPRO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SPECPRO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SPECPRO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SPECPRO_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SPECPRO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SPECPRO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SPECPRO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SPECPRO_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SPECPRO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SPECPRO_RowId</SqlRowIdName>
<StreamLocation>^User.PACSpecialProjectS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
