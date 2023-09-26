/// 描述：个人通讯录HIS科室授权HIS科室
/// 创建人：丁亚男-基础数据平台
/// 创建日期：2021-03-16
Class User.CTHCCSLocLinkLoc Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlTableName = CT_HCCSLocLinkLoc, StorageStrategy = SQLStorage ]
{

/// 个人通讯录授权his科室代码
Property LLLHISCode As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = LLL_HISCode ];

/// 个人通讯录授权his科室名称
Property LLLHISDesc As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LLL_HISDesc ];

/// 个人通讯录his科室代码
Property LLLAutHISCode As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LLL_AutHISCode ];

/// 个人通讯录his科室名称
Property LLLAutHISDesc As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = LLL_AutHISDesc ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("HCCSAUTLOC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LLL_AutHISCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LLL_AutHISDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LLL_HISCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LLL_HISDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LLL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HCCSAUTLOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LLL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHISCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>LLL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HCCSAUTLOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HISCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LLL_HISCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LLL_AutHISCode}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LLL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LLL_RowId</SqlRowIdName>
<StreamLocation>^User.CTHCCSLocationLinkLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
