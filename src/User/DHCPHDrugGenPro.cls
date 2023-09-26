/// 基础数据平台-临床知识库-通用名药品属性表
Class User.DHCPHDrugGenPro Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHGPR_RowId, SqlTableName = DHC_PHDrugGenPro, StorageStrategy = SQLStorage ]
{

// ^DHCPHDGP

Property PHGPRGenDr As User.DHCPHExtGeneric [ SqlColumnNumber = 2, SqlFieldName = PHGPR_Gen_Dr ];

Property PHGPRAtc As %String [ SqlColumnNumber = 3, SqlFieldName = PHGPR_Atc ];

Property PHGPROTC As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHGPR_OTC ];

Property PHGPRCatDr As User.DHCPHLibCat [ SqlColumnNumber = 5, SqlFieldName = PHGPR_Cat_Dr ];

Property PHGPRSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PHGPR_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHDGP(0))</SqlIdExpression>
<SQLMap name="IndexCat">
<Global>^DHCPHDGPi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHGPR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHGPR_Cat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHGPR_Gen_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHGPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGen">
<Global>^DHCPHDGPi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHGPR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Gen"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHGPR_Gen_Dr})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHGPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHGPR_Atc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHGPR_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHGPR_Gen_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHGPR_OTC">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHGPR_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHDGP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHGPR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHGPR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHGPR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDrugGenProS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
