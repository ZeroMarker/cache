/// 名称: 科室常用诊断表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-7-14
Class User.DHCPHHospLocIcd Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = LOCI_RowId, SqlTableName = DHC_PHHospLocIcd, StorageStrategy = SQLStorage ]
{

/// ^DHCPHHLOCICD
Property LOCILOCDr As DHCPHHospLoc [ SqlColumnNumber = 2, SqlFieldName = LOCI_LOC_Dr ];

Property LOCIICDDr As DHCExtIcdFeild [ SqlColumnNumber = 3, SqlFieldName = LOCI_ICD_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHHLOCICD(0))</SqlIdExpression>
<SQLMap name="ICDIndex">
<Global>^DHCPHHLOCICD</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LOCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LOCI_ICD_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOCI_LOC_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LOCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="LocIndex">
<Global>^DHCPHHLOCICD</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LOCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LOCI_LOC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="LOCI_ICD_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LOCI_LOC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHHLOCICD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LOCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LOCI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LOCI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHHospLocIcdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
