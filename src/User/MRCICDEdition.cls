/// ICD Edition(2173)
Class User.MRCICDEdition Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_ICDEdition, StorageStrategy = SQLStorage ]
{

/// Code
Property ICDEDCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ICDED_Code ];

/// Date From
Property ICDEDDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ICDED_DateFrom ];

/// Date To
Property ICDEDDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ICDED_DateTo ];

/// Description
Property ICDEDDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ICDED_Desc ];

Parameter EXTENTSIZE = 1;

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="ICDEDCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ICDEDDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ICDEDDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ICDEDDesc">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^MRC("ICDED",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICDED_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICDED_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICDED_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICDED_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ICDED_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ICDED"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ICDED_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICDED_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ICDED"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ICDED_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICDED_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexdesc">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICDED_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ICDED"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ICDED_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICDED_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ICDED_RowId</SqlRowIdName>
<StreamLocation>^User.MRCICDEditionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
