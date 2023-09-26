/// RBC Appointment Transport(1935)
Class User.RBCAppointTransport Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_AppointTransport, StorageStrategy = SQLStorage ]
{

/// Adress
Property APTRAdress As list Of %String(COLLATION = "Exact", MAXLEN = 230, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = APTR_Adress, SqlListType = SUBNODE ];

/// Code
Property APTRCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = APTR_Code ];

/// Contact Methods
Property APTRContactMethod As %String(COLLATION = "Exact", MAXLEN = 530, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = APTR_ContactMethod ];

/// Date From
Property APTRDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = APTR_DateFrom ];

/// Date To
Property APTRDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = APTR_DateTo ];

/// Description
Property APTRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = APTR_Desc ];

/// Email
Property APTREmail As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = APTR_Email ];

/// Fax
Property APTRFax As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = APTR_Fax ];

/// Phone
Property APTRPhone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = APTR_Phone ];

Parameter EXTENTSIZE = 6;

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="APTRAdress">
<Selectivity>1</Selectivity>
</Property>
<Property name="APTRCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="APTRContactMethod">
<Selectivity>1</Selectivity>
</Property>
<Property name="APTRDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="APTRDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="APTRDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="APTREmail">
<Selectivity>1</Selectivity>
</Property>
<Property name="APTRFax">
<Selectivity>1</Selectivity>
</Property>
<Property name="APTRPhone">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^RBC("APTR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="APTR_Adress">
<Node>"ADDR"</Node>
</Data>
<Data name="APTR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APTR_ContactMethod">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APTR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APTR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APTR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APTR_Email">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APTR_Fax">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APTR_Phone">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>APTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"APTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APTR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>APTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"APTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({APTR_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>APTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"APTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({APTR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>APTR_RowId</SqlRowIdName>
<StreamLocation>^User.RBCAppointTransportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
