/// ADL Sub Type(2389)
Class User.PACADLSubType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ADLSubType, StorageStrategy = SQLStorage ]
{

/// Code
Property ADLSTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ADLST_Code ];

/// Date From
Property ADLSTDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ADLST_DateFrom ];

/// Date To
Property ADLSTDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ADLST_DateTo ];

/// Description
Property ADLSTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ADLST_Desc ];

/// National Code
Property ADLSTNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ADLST_NationalCode ];

Parameter EXTENTSIZE = 2;

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="ADLSTCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="ADLSTDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="ADLSTDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="ADLSTDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="ADLSTNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("ADLST",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="ADLST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADLST_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADLST_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADLST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADLST_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ADLST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADLST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADLST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADLST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADLST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ADLST_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADLST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADLST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADLST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ADLST_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADLST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADLST_RowId</SqlRowIdName>
<StreamLocation>^User.PACADLSubTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
