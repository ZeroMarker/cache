/// 基础数据平台-临床知识库-剂型对照表
Class User.DHCPHFormContrast Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHFCT_RowId, SqlTableName = DHC_PHFormContrast, StorageStrategy = SQLStorage ]
{

// ^DHCPHFOCON

Property PHFCTFormCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHFCT_FormCode ];

Property PHFCTFormDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHFCT_FormDesc ];

Property PHFCTHisFormCode As %String [ SqlColumnNumber = 4, SqlFieldName = PHFCT_HisFormCode ];

Property PHFCTHisFormDesc As %String [ SqlColumnNumber = 5, SqlFieldName = PHFCT_HisFormDesc ];

Property PHFCTHospDr As %String [ SqlColumnNumber = 6, SqlFieldName = PHFCT_Hosp_Dr ];

Property PHFCTSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PHFCT_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHFOCON(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHFOCON</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHFCT_FormCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHFCT_HisFormCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHFCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHisCode">
<Global>^DHCPHFOCON</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHFCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHFCT_HisFormCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHFCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHFCT_FormCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHFCT_FormDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHFCT_HisFormCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHFCT_HisFormDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHFCT_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHFCT_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHFOCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHFCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHFCT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHFCT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHFormContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
