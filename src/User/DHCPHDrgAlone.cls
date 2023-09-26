/// 名称: 单独用药
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-11-3
Class User.DHCPHDrgAlone Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHDAL_RowId, SqlTableName = DHC_PHDrgAlone, StorageStrategy = SQLStorage ]
{

/// PHDAL_RowId  ^DHCPHDAL
Property PHDALInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PHDAL_Inst_Dr ];

Property PHDALDrgDr As DHCPHProName [ SqlColumnNumber = 3, SqlFieldName = PHDAL_Drg_Dr ];

/// 管控级别: Warn警示, Control管控, Stat统计
Property PHDALManage As %String(DISPLAYLIST = ",Warn,Control,Stat", VALUELIST = ",W,C,S") [ SqlColumnNumber = 4, SqlFieldName = PHDAL_Manage ];

/// 组号 2016-11-24
Property PHDALGrpNo As %String [ SqlColumnNumber = 5, SqlFieldName = PHDAL_GrpNo ];

/// 溶媒分类 2016-11-24
Property PHDALCatDr As DHCPHMenstruumCat [ SqlColumnNumber = 6, SqlFieldName = PHDAL_Cat_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHDAL(0))</SqlIdExpression>
<SQLMap name="IndexInst">
<Global>^DHCPHDAL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHDAL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDAL_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHDAL_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHDAL_Drg_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDAL_GrpNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHDAL_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDAL_Manage">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHDAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHDAL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHDAL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHDAL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDrgAloneS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
