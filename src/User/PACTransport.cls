/// Transport(2328)
Class User.PACTransport Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_Transport, StorageStrategy = SQLStorage ]
{

/// Address
Property TRANSPAddress As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 10, SqlFieldName = TRANSP_Address, SqlListType = SUBNODE ];

/// Code
Property TRANSPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = TRANSP_Code ];

/// Contact Method
Property TRANSPContactMethod As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = TRANSP_ContactMethod ];

/// Date From
Property TRANSPDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = TRANSP_DateFrom ];

/// Date To
Property TRANSPDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = TRANSP_DateTo ];

/// Description
Property TRANSPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TRANSP_Desc ];

/// Email
Property TRANSPEmail As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = TRANSP_Email ];

/// Fax
Property TRANSPFax As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = TRANSP_Fax ];

/// Phone
Property TRANSPPhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = TRANSP_Phone ];

Parameter EXTENTSIZE = 3;

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="TRANSPAddress">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSPCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSPContactMethod">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSPDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSPDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSPDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSPEmail">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSPFax">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSPPhone">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("TRANSP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TRANSP_Address">
<Node>"ADDR"</Node>
</Data>
<Data name="TRANSP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRANSP_ContactMethod">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TRANSP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRANSP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRANSP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRANSP_Email">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TRANSP_Fax">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TRANSP_Phone">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TRANSP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRANSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TRANSP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TRANSP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRANSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TRANSP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRANSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TRANSP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRANSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TRANSP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRANSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TRANSP_RowId</SqlRowIdName>
<StreamLocation>^User.PACTransportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
