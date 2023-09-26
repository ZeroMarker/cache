/// Units Collected(2429)
Class User.OECUnitsCollected Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = OEC_UnitsCollected, StorageStrategy = SQLStorage ]
{

/// Code
Property UNITCOLCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = UNITCOL_Code ];

/// Description
Property UNITCOLDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = UNITCOL_Desc ];

Parameter EXTENTSIZE = 3;

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="UNITCOLCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="UNITCOLDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^OEC("UNITCOL",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="UNITCOL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UNITCOL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>UNITCOL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNITCOL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UNITCOL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UNITCOL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNITCOL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({UNITCOL_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UNITCOL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UNITCOL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNITCOL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({UNITCOL_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UNITCOL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>UNITCOL_RowId</SqlRowIdName>
<StreamLocation>^User.OECUnitsCollectedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
