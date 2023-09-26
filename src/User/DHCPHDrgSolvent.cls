/// 名称: 溶媒
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-10-11
Class User.DHCPHDrgSolvent Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PDINT_RowId, SqlTableName = DHC_PHDrgSolvent, StorageStrategy = SQLStorage ]
{

/// PDINT_RowId ^DHCPHDST
Property PDINTInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PDINT_Inst_Dr ];

Property PDINTDrgDr As DHCPHProName [ SqlColumnNumber = 3, SqlFieldName = PDINT_Drg_Dr ];

/// 管控级别: Warn警示, Control管控, Stat统计
Property PDINTManage As %String(DISPLAYLIST = ",Warn,Control,Stat", VALUELIST = ",W,C,S") [ SqlColumnNumber = 4, SqlFieldName = PDINT_Manage ];

/// 浓度
Property PDINTDosage As %String [ SqlColumnNumber = 5, SqlFieldName = PDINT_Dosage ];

/// 关系 2016-11-24 (DISPLAYLIST = ",大于,小于,等于,不大于,不小于,不等于", VALUELIST = ",>,<,=,!>,!<,<>")
Property PDINTRelation As %String [ SqlColumnNumber = 6, SqlFieldName = PDINT_Relation ];

/// 单位 2016-11-24
Property PDINTMustUomDr As DHCPHExtUom [ SqlColumnNumber = 7, SqlFieldName = PDINT_MustUom_Dr ];

/// 浓度上限 2018-01-04
Property PDINTDosageMax As %String [ SqlColumnNumber = 8, SqlFieldName = PDINT_DosageMax ];

/// 浓度下限 2018-01-04
Property PDINTDosageMin As %String [ SqlColumnNumber = 9, SqlFieldName = PDINT_DosageMin ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHDST(0))</SqlIdExpression>
<SQLMap name="IndexInst">
<Global>^DHCPHDST</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDINT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDINT_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDINT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PDINT_Dosage">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDINT_DosageMax">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDINT_DosageMin">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PDINT_Drg_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDINT_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDINT_Manage">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDINT_MustUom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDINT_Relation">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHDST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDINT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDINT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PDINT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDrgSolventS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
