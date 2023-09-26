/// 描述: 病症拼音码字典表
/// 编写者：谷雪萍
/// 编写日期: 2016-05-18
Class User.DHCPHDiseaseKey Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHDK_RowId, SqlTableName = DHC_PHDiseaseKey, StorageStrategy = SQLStorage ]
{

// ^DHCPHDISCOML

Property PHDKDisDr As %String [ SqlColumnNumber = 2, SqlFieldName = PHDK_Dis_Dr ];

Property PHDKCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHDK_Code ];

Property PHDKDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHDK_Desc ];

Property PHDKType As %String(DISPLAYLIST = ",常用名,别名,主症状", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",C,A,M") [ SqlColumnNumber = 5, SqlFieldName = PHDK_Type ];

Property PHDKActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PHDK_ActiveFlag ];

Property PHDKSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PHDK_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHDISKEY(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHDISKEYi</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PHDK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDK_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDK_Dis_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$UPPER({PHDK_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHDK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="PHDK_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHDK_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDK_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHDK_Dis_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDK_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHDK_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHDISKEY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHDK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHDK_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHDISKEYi</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PHDK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDK_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDK_Dis_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$UPPER({PHDK_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHDK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DisIndex">
<Global>^DHCPHDISKEYi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHDK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Dis"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDK_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDK_Dis_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHDK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHDK_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDiseaseKeyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
