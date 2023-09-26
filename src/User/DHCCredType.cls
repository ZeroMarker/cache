Class User.DHCCredType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CRT_RowID, SqlTableName = DHC_CredType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CRT_Code
Property CRTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CRT_Code ];

/// CRT_Desc
Property CRTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CRT_Desc ];

/// CRT_default
Property CRTdefault As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = CRT_default ];

/// CRT_Active
Property CRTActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = CRT_Active ];

/// CRT_DateFrom
Property CRTDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = CRT_DateFrom ];

/// CRT_DateTo
Property CRTDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = CRT_DateTo ];

Property CRTCredNoRequired As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = CRT_CredNoRequired ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PAC("CARD",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CRT_Active">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="CRT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CRT_CredNoRequired">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="CRT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CRT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CRT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CRT_default">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CRT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CARD"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CRT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCACCCredType</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CRT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({CRT_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CRT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexCode">
<Global>^DHCACCCredType</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CRT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{CRT_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{CRT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexdefault">
<Global>^DHCACCCredType</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CRT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DFT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CRT_default}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CRT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCredTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
