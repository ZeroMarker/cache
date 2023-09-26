/// Referral Further Care(2369)
Class User.PACReferralFurtherCare Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ReferralFurtherCare, StorageStrategy = SQLStorage ]
{

/// Code
Property RFCARECode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = RFCARE_Code ];

/// DateFrom
Property RFCAREDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = RFCARE_DateFrom ];

/// DateTo
Property RFCAREDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = RFCARE_DateTo ];

/// Description
Property RFCAREDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RFCARE_Desc ];

/// National Code
Property RFCARENationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = RFCARE_NationalCode ];

Parameter EXTENTSIZE = 1;

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="RFCARECode">
<Selectivity>1</Selectivity>
</Property>
<Property name="RFCAREDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="RFCAREDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="RFCAREDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="RFCARENationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("RFCARE",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="RFCARE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RFCARE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RFCARE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RFCARE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RFCARE_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RFCARE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RFCARE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RFCARE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RFCARE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RFCARE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RFCARE_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RFCARE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RFCARE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RFCARE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RFCARE_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RFCARE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RFCARE_RowId</SqlRowIdName>
<StreamLocation>^User.PACReferralFurtherCareS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
