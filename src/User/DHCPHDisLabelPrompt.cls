/// 名称：推导目录提示表
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-13
Class User.DHCPHDisLabelPrompt Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PDP_RowId, SqlTableName = DHC_PHDisLabelPrompt, StorageStrategy = SQLStorage ]
{

// ^DHCPHDISLPRO  ^DHCPHDISLPROi  PDP_RowId

Property PDPLastId As User.DHCPHDiseaseTree [ SqlColumnNumber = 2, SqlFieldName = PDP_LastId ];

Property PDPLabelDr As DHCPHGuideLabel [ SqlColumnNumber = 3, SqlFieldName = PDP_Label_Dr ];

Property PDPPrompt As %String [ SqlColumnNumber = 4, SqlFieldName = PDP_Prompt ];

Property PDPPromptVal As %String [ SqlColumnNumber = 5, SqlFieldName = PDP_PromptVal ];

Property PDPSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PDP_SysFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHDISLPRO(0))</SqlIdExpression>
<SQLMap name="LabelIndex">
<Global>^DHCPHDISLPROi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PDP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Label"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDP_LastId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDP_Label_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="LastIdIndex">
<Global>^DHCPHDISLPROi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LastId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDP_LastId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PDP_Label_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDP_LastId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDP_Prompt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDP_PromptVal">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDP_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHDISLPRO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PDP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDisLabelPromptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
