/// 名称: DHC_PhysiologicalCycle
/// 描述: 生理周期字典表
/// 编写者：谷雪萍
/// 编写日期: 2016-05-13
Class User.DHCPhysiologicalCycle Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHYC_RowId, SqlTableName = DHC_PhysiologicalCycle, StorageStrategy = SQLStorage ]
{

// ^DHCPHYC

Property PHYCCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHYC_Code ];

Property PHYCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHYC_Desc ];

Property PHYCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHYC_ActiveFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHYC(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHYCi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SYF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHYC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHYC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPHYCi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SYF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHYC_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHYC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHYC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHYC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHYC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHYC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHYC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHYC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHYC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSymptomFeildS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
