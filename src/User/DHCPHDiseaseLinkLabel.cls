/// 名称：推导目录表
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-12
Class User.DHCPHDiseaseLinkLabel Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PDL_RowId, SqlTableName = DHC_PHDiseaseLinkLabel, StorageStrategy = SQLStorage ]
{

// ^DHCPHDISLILA,^DHCPHDISLILAi

Property PDLLabelDr As DHCPHGuideLabel [ SqlColumnNumber = 2, SqlFieldName = PDL_Label_Dr ];

Property PDLRelation As %String(DISPLAYLIST = ",Or,And", VALUELIST = ",O,A") [ SqlColumnNumber = 3, SqlFieldName = PDL_Relation ];

Property PDLOperator As %String [ SqlColumnNumber = 4, SqlFieldName = PDL_Operator ];

Property PDLNum As %String [ SqlColumnNumber = 5, SqlFieldName = PDL_Num ];

Property PDLDisTreeDr As DHCPHDiseaseTree [ SqlColumnNumber = 6, SqlFieldName = PDL_DisTree_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHDISLILA(0))</SqlIdExpression>
<SQLMap name="LabelIndex">
<Global>^DHCPHDISLILAi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Label"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDL_Label_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="LinkIndex">
<Global>^DHCPHDISLILAi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PDL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Link"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDL_DisTree_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDL_Label_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PDL_DisTree_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDL_Label_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDL_Num">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDL_Operator">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDL_Relation">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHDISLILA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="TreeIndex">
<Global>^DHCPHDISLILAi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Tree"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDL_DisTree_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDiseaseLinkLabelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
