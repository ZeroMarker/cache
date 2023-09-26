/// Reason For Merging(2358)
Class User.PACReasonForMerging Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ReasonForMerging, StorageStrategy = SQLStorage ]
{

/// Code
Property REAMRGCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = REAMRG_Code ];

/// Date From
Property REAMRGDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = REAMRG_DateFrom ];

/// Date To
Property REAMRGDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = REAMRG_DateTo ];

/// Description
Property REAMRGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = REAMRG_Desc ];

Parameter EXTENTSIZE = 2;

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="REAMRGCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="REAMRGDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="REAMRGDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="REAMRGDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("REAMRG",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="REAMRG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REAMRG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REAMRG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REAMRG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>REAMRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REAMRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{REAMRG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REAMRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REAMRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REAMRG_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REAMRG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REAMRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REAMRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REAMRG_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REAMRG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REAMRG_RowId</SqlRowIdName>
<StreamLocation>^User.PACReasonForMergingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
