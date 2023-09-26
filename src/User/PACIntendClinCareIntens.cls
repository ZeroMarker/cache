/// PAC IntendClinical Care Inten(1959
Class User.PACIntendClinCareIntens Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_IntendClinCareIntens, StorageStrategy = SQLStorage ]
{

/// Activity Points
Property ICCIActivityPoints As %Float [ SqlColumnNumber = 4, SqlFieldName = ICCI_ActivityPoints ];

/// Code
Property ICCICode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ICCI_Code ];

/// Description
Property ICCIDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ICCI_Desc ];

Parameter EXTENTSIZE = 4;

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="ICCIActivityPoints">
<Selectivity>1</Selectivity>
</Property>
<Property name="ICCICode">
<Selectivity>1</Selectivity>
</Property>
<Property name="ICCIDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("ICCI",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICCI_ActivityPoints">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICCI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICCI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ICCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ICCI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ICCI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ICCI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ICCI_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ICCI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ICCI_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ICCI_RowId</SqlRowIdName>
<StreamLocation>^User.PACIntendClinCareIntensS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
