/// 基础数据平台-临床知识库-通用名和his对照
Class User.DHCGenItmContrast Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = GICT_RowId, SqlTableName = DHC_GenItmContrast, StorageStrategy = SQLStorage ]
{

// ^DHCPHGENCON

Property GICTCode As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = GICT_Code ];

Property GICTDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = GICT_Desc ];

Property GICTHisCode As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = GICT_HisCode ];

Property GICTHisDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = GICT_HisDesc ];

Property GICTHospDr As %String [ SqlColumnNumber = 6, SqlFieldName = GICT_Hosp_Dr ];

Property GICTSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = GICT_SysFlag ];

Property GICTGenDr As %String [ SqlColumnNumber = 8, SqlFieldName = GICT_Gen_Dr ];

Property GICTPointer As %String [ SqlColumnNumber = 9, SqlFieldName = GICT_Pointer ];

Property GICTCoeff As %Numeric [ SqlColumnNumber = 10, SqlFieldName = GICT_Coeff ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHGENCON(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHGENCON</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GICT_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GICT_HisCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GICT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHisCode">
<Global>^DHCPHGENCON</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GICT_HisCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GICT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="GICT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GICT_Coeff">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GICT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GICT_Gen_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GICT_HisCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GICT_HisDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GICT_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GICT_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GICT_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHGENCON</Global>
<Subscript name="1">
<Expression>{GICT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>GICT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCGenItmContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
