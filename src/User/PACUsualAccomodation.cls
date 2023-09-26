/// Usual Accomodation(2367)
Class User.PACUsualAccomodation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_UsualAccomodation, StorageStrategy = SQLStorage ]
{

/// Code
Property USACCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = USACC_Code ];

/// Date From
Property USACCDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = USACC_DateFrom ];

/// Date To
Property USACCDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = USACC_DateTo ];

/// Description
Property USACCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = USACC_Desc ];

/// NationalCode
Property USACCNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = USACC_NationalCode ];

Parameter EXTENTSIZE = 1;

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="USACCCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="USACCDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="USACCDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="USACCDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="USACCNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("USACC",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="USACC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="USACC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="USACC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="USACC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="USACC_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>USACC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"USACC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{USACC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>USACC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"USACC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({USACC_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{USACC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>USACC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"USACC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({USACC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{USACC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>USACC_RowId</SqlRowIdName>
<StreamLocation>^User.PACUsualAccomodationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
