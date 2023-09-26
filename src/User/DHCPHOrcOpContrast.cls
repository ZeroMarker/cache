/// 基础数据平台-临床知识库-手术对照表
Class User.DHCPHOrcOpContrast Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHOCT_RowId, SqlTableName = DHC_PHOrcOpContrast, StorageStrategy = SQLStorage ]
{

// ^DHCPHOPCON

Property PHOCTOperCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHOCT_OperCode ];

Property PHOCTOperDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHOCT_OperDesc ];

Property PHOCTHisOperCode As %String [ SqlColumnNumber = 4, SqlFieldName = PHOCT_HisOperCode ];

Property PHOCTHisOperDesc As %String [ SqlColumnNumber = 5, SqlFieldName = PHOCT_HisOperDesc ];

Property PHOCTHospDr As %String [ SqlColumnNumber = 6, SqlFieldName = PHOCT_Hosp_Dr ];

Property PHOCTSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PHOCT_SysFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHOPCON(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHOPCON</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHOCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHOCT_OperCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHOCT_HisOperCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHOCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHisCode">
<Global>^DHCPHOPCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHOCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHOCT_HisOperCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHOCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHOCT_HisOperCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHOCT_HisOperDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHOCT_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHOCT_OperCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHOCT_OperDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHOCT_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHOPCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHOCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHOCT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHOCT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHOrcOpContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
