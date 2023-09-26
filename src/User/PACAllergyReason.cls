/// Allergy Reason(2306)
Class User.PACAllergyReason Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_AllergyReason, StorageStrategy = SQLStorage ]
{

/// Code
Property ALRGREACode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ALRGREA_Code ];

/// Description
Property ALRGREADesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ALRGREA_Desc ];

Parameter EXTENTSIZE = 1;

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="ALRGREACode">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALRGREADesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("ALRGREA",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ALRGREA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALRGREA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ALRGREA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALRGREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ALRGREA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALRGREA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALRGREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALRGREA_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALRGREA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALRGREA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALRGREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALRGREA_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALRGREA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ALRGREA_RowId</SqlRowIdName>
<StreamLocation>^User.PACAllergyReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
