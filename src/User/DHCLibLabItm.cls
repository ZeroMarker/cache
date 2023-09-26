/// 基础数据平台-临床知识库-药品业务表 - 检验指标业务表
/// 编写者:基础数据平台组-高姗姗
/// 编写日期: 2014-12-15
Class User.DHCLibLabItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = LABI_RowId, SqlTableName = DHC_LibLabItm, StorageStrategy = SQLStorage ]
{

/// LABI_RowId  ^DHCLIBLABI
Property LABIInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = LABI_Inst_Dr ];

Property LABILabDr As DHCPHExtGeneric [ SqlColumnNumber = 3, SqlFieldName = LABI_Lab_Dr ];

Property LABIMaxVal As %String [ SqlColumnNumber = 4, SqlFieldName = LABI_MaxVal ];

Property LABIMinVal As %String [ SqlColumnNumber = 5, SqlFieldName = LABI_MinVal ];

Property LABIUomDr As DHCPHExtUom [ SqlColumnNumber = 6, SqlFieldName = LABI_Uom_Dr ];

/// 关系 2017-3-29  (DISPLAYLIST = ",大于,小于,等于,不大于,不小于,不等于", VALUELIST = ",>,<,=,!>,!<,<>")
Property LABIRelation As %String [ SqlColumnNumber = 7, SqlFieldName = LABI_Relation ];

/// 是否为报告状态  
Property LABIRepActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = LABI_RepActiveFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLIBLABI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LABI_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LABI_Lab_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LABI_MaxVal">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LABI_MinVal">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LABI_Relation">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LABI_RepActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LABI_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCLIBLABI</Global>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{LABI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCLIBLABI</Global>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LABI_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LABI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LABI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLibLabItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
