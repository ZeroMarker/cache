/// 名称: 症状分级关联表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-5-16
Class User.DHCSymptomCon Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = SYC_RowId, SqlTableName = DHC_SymptomCon, StorageStrategy = SQLStorage ]
{

/// SYC_RowId  ^DHCSYMCON
Property SYCLevDr As User.DHCSymptomLev [ SqlColumnNumber = 2, SqlFieldName = SYC_Lev_Dr ];

Property SYCFieldDr As User.DHCSymptomFeild [ SqlColumnNumber = 3, SqlFieldName = SYC_Field_Dr ];

Property SYCSequence As %String [ SqlColumnNumber = 4, SqlFieldName = SYC_Sequence ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCSYMCON(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SYC_Field_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SYC_Lev_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SYC_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSYMCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SYC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SYC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCon">
<Global>^DHCSYMCONi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SYC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SYC_Lev_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SYC_Field_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SYC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSeq">
<Global>^DHCSYMCONi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SYC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SEQ"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SYC_Lev_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SYC_Sequence}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SYC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SYC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSymptomConS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
