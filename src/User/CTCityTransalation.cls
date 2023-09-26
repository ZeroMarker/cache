/// City Transalation(2354)
Class User.CTCityTransalation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_CityTransalation, StorageStrategy = SQLStorage ]
{

/// Abbreviation
Property CITYTRANSCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CITYTRANS_Code ];

/// Description
Property CITYTRANSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CITYTRANS_Desc ];

Parameter EXTENTSIZE = 9;

Storage SQLStorage
{
<ExtentSize>9</ExtentSize>
<Property name="CITYTRANSCode">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="CITYTRANSDesc">
<Selectivity>11.1111%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("CITYTRANS",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="CITYTRANS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CITYTRANS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CITYTRANS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CITYTRANS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CITYTRANS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CITYTRANS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CITYTRANS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CITYTRANS_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CITYTRANS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CITYTRANS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CITYTRANS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CITYTRANS_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CITYTRANS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CITYTRANS_RowId</SqlRowIdName>
<StreamLocation>^User.CTCityTransalationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
