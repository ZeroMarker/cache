/// 名称：推导目录明细表（新）
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-12
Class User.DHCPHDisLabelItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PDLI_RowId, SqlTableName = DHC_PHDisLabelItm, StorageStrategy = SQLStorage ]
{

// ^DHCPHDISLITM   ^DHCPHDISLITMi   PDLI_RowId

// 推导目录

Property PDLIId As User.DHCPHDiseaseLinkLabel [ SqlColumnNumber = 2, SqlFieldName = PDLI_Id ];

// 通用名字典

Property PDLIGenDr As User.DHCPHExtGeneric [ SqlColumnNumber = 3, SqlFieldName = PDLI_Gen_Dr ];

// 检验值

Property PDLIVal As %String [ SqlColumnNumber = 4, SqlFieldName = PDLI_Val ];

// 运算符

Property PDLIOperator As %String [ SqlColumnNumber = 5, SqlFieldName = PDLI_Operator ];

// 结果

Property PDLIResultText As %String(DISPLAYLIST = ",高,低,正常,包含,阴性,阳性", VALUELIST = ",H,L,N,I,NT,PT") [ SqlColumnNumber = 6, SqlFieldName = PDLI_ResultText ];

// 关键字  症状是 存分类标识为症状体征的知识库关键字id,为诊断时存病症的id

Property PDLIKeyWord As %String [ SqlColumnNumber = 7, SqlFieldName = PDLI_KeyWord ];

// 逻辑

Property PDLIRelation As %String(DISPLAYLIST = ",Or,And", VALUELIST = ",O,A") [ SqlColumnNumber = 8, SqlFieldName = PDLI_Relation ];

// 是否系统标识

Property PDLISysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PDLI_SysFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHDISLITM(0))</SqlIdExpression>
<SQLMap name="GenDrIndex">
<Global>^DHCPHDISLITMi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PDLI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GenDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDLI_Id}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{PDLI_Gen_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDLI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="KeyWordIndex">
<Global>^DHCPHDISLITMi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PDLI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KeyWord"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDLI_Id}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{PDLI_KeyWord}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDLI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="LinkLabelIndex">
<Global>^DHCPHDISLITMi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDLI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LinkLabel"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDLI_Id}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDLI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PDLI_Gen_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDLI_Id">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDLI_KeyWord">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDLI_Operator">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDLI_Relation">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDLI_ResultText">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDLI_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PDLI_Val">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHDISLITM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDLI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDLI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PDLI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDisLabelItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
