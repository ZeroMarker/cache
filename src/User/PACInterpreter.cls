/// Interpreter(2329)
Class User.PACInterpreter Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_Interpreter, StorageStrategy = SQLStorage ]
{

/// Address
Property INTERPAddress As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = INTERP_Address, SqlListType = SUBNODE ];

/// Code
Property INTERPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = INTERP_Code ];

/// Contact Method
Property INTERPContactMethod As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = INTERP_ContactMethod ];

/// Date From
Property INTERPDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = INTERP_DateFrom ];

/// Date To
Property INTERPDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = INTERP_DateTo ];

/// Description
Property INTERPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = INTERP_Desc ];

/// Email
Property INTERPEmail As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = INTERP_Email ];

/// Fax
Property INTERPFax As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = INTERP_Fax ];

/// Phone
Property INTERPPhone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = INTERP_Phone ];

Parameter EXTENTSIZE = 6;

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="INTERPAddress">
<Selectivity>1</Selectivity>
</Property>
<Property name="INTERPCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="INTERPContactMethod">
<Selectivity>1</Selectivity>
</Property>
<Property name="INTERPDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="INTERPDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="INTERPDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="INTERPEmail">
<Selectivity>1</Selectivity>
</Property>
<Property name="INTERPFax">
<Selectivity>1</Selectivity>
</Property>
<Property name="INTERPPhone">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("INTERP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INTERP_Address">
<Node>"ADDR"</Node>
</Data>
<Data name="INTERP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INTERP_ContactMethod">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INTERP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INTERP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INTERP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INTERP_Email">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INTERP_Fax">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INTERP_Phone">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>INTERP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTERP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INTERP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTERP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTERP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INTERP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTERP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTERP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTERP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INTERP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTERP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INTERP_RowId</SqlRowIdName>
<StreamLocation>^User.PACInterpreterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
