/// 描述: 病症常用名/别名字典表
/// 编写者：谷雪萍
/// 编写日期: 2016-05-18
Class User.DHCPHDiseaseComList Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHDCL_RowId, SqlTableName = DHC_PHDiseaseComList, StorageStrategy = SQLStorage ]
{

// ^DHCPHDISCOML

Property PHDCLDisDr As User.DHCPHDiseaseList [ SqlColumnNumber = 2, SqlFieldName = PHDCL_Dis_Dr ];

Property PHDCLCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHDCL_Code ];

Property PHDCLDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHDCL_Desc ];

Property PHDCLType As %String(DISPLAYLIST = ",常用名,别名", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",C,A") [ SqlColumnNumber = 5, SqlFieldName = PHDCL_Type ];

Property PHDCLActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PHDCL_ActiveFlag ];

Property PHDCLSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PHDCL_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHDISCOML(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHDISCOMLi</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PHDCL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDCL_Dis_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDCL_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$UPPER({PHDCL_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHDCL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="PHDCL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHDCL_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDCL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHDCL_Dis_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDCL_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHDCL_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHDISCOML</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHDCL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHDCL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHDISCOMLi</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PHDCL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDCL_Dis_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDCL_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$UPPER({PHDCL_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHDCL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DisIndex">
<Global>^DHCPHDISCOMLi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHDCL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Dis"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDCL_Dis_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDCL_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHDCL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHDCL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDiseaseComListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
