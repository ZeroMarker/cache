/// PACBed Organization
/// created by caihaozhe @2015-4-3 
Class User.PACBedOrganization Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PAC_BedOrganization, StorageStrategy = SQLStorage ]
{

/// BEDORGZ Code
Property BEDORGZCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = BEDORGZ_Code ];

/// BEDORGZ Description
Property BEDORGZDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = BEDORGZ_Desc ];

Index BEDORGZCodeUnqIdx1 On BEDORGZCode [ Unique ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<Property name="INGRACode"/>
<Property name="INGRADesc"/>
<SqlIdExpression>$i(^PAC("BEDORGZ",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BEDORGZ_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BEDORGZ_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BEDORGZ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BEDORGZ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BEDORGZ_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BEDORGZ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BEDORGZ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({BEDORGZ_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BEDORGZ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BEDORGZ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BEDORGZ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({BEDORGZ_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BEDORGZ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BEDORGZ_RowId</SqlRowIdName>
<StreamLocation>^User.PACBedOrganizationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
