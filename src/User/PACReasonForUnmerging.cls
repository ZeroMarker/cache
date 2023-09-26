/// ReasonForUnmerging(2359)
Class User.PACReasonForUnmerging Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ReasonForUnmerging, StorageStrategy = SQLStorage ]
{

/// Code
Property REAUNMCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = REAUNM_Code ];

/// Date From
Property REAUNMDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = REAUNM_DateFrom ];

/// Date To
Property REAUNMDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = REAUNM_DateTo ];

/// Description
Property REAUNMDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = REAUNM_Desc ];

Parameter EXTENTSIZE = 2;

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="REAUNMCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="REAUNMDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="REAUNMDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="REAUNMDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("REAUNM",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="REAUNM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REAUNM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REAUNM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REAUNM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>REAUNM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REAUNM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{REAUNM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REAUNM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REAUNM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REAUNM_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REAUNM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REAUNM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REAUNM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REAUNM_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REAUNM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REAUNM_RowId</SqlRowIdName>
<StreamLocation>^User.PACReasonForUnmergingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
