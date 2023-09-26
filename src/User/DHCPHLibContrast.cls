/// 基础数据平台-临床知识库-知识库标识和HIS科室对照
Class User.DHCPHLibContrast Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHLC_RowId, SqlTableName = DHC_PHLibContrast, StorageStrategy = SQLStorage ]
{

// ^DHCPHLIBC

Property PHLCLibCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHLC_LibCode ];

Property PHLCLibDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHLC_LibDesc ];

Property PHLCHisLocCode As %String [ SqlColumnNumber = 4, SqlFieldName = PHLC_HisLocCode ];

Property PHLCHisLocDesc As %String [ SqlColumnNumber = 5, SqlFieldName = PHLC_HisLocDesc ];

Property PHLCHospDr As %String [ SqlColumnNumber = 6, SqlFieldName = PHLC_Hosp_Dr ];

Property PHLCSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PHLC_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHLIBC(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHLIBC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHLC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHLC_LibCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHLC_HisLocCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHLC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHisCode">
<Global>^DHCPHLIBC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHLC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHLC_HisLocCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHLC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHLC_HisLocCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHLC_HisLocDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHLC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHLC_LibCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHLC_LibDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHLC_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHLIBC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHLC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHLC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHLC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHLibContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
