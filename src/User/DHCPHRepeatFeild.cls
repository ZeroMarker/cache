/// 基础数据平台-临床知识库-重复用药规则
Class User.DHCPHRepeatFeild Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHRF_RowId, SqlTableName = DHC_PHRepeatFeild, StorageStrategy = SQLStorage ]
{

// ^DHCPHRFE

Property PHRFCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHRF_Code ];

Property PHRFDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHRF_Desc ];

Property PHRFActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHRF_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHRFE(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHRFEi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHRF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHRF_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHRF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPHRFEi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHRF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHRF_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHRF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHRF_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHRF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHRF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHRFE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHRF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHRF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHRF_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHRepeatFeildS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
