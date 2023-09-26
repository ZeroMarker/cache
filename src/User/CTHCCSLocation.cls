/// 描述：医呼通科室
/// 创建人：陈莹-基础数据平台
/// 创建日期：2021-01-28
Class User.CTHCCSLocation Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlTableName = CT_HCCSLocation, StorageStrategy = SQLStorage ]
{

/// 科室关联HIS科室 子表
Relationship ChildLocationLinkLoc As User.CTHCCSLocationLinkLoc [ Cardinality = children, Inverse = LLLParRef ];

/// 科室代码
Property LOCCode As %String(MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = LOC_Code ];

/// 科室名称
Property LOCDesc As %String(MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = LOC_Desc ];

/// 开始日期
Property LOCDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = LOC_DateFrom ];

/// 结束日期
Property LOCDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = LOC_DateTo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("HCCSLOC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LOC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LOC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LOC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LOC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"HCCSLOC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{LOC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"HCCSLOC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{LOC_Code}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{LOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LOC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HCCSLOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOC_Desc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LOC_RowId</SqlRowIdName>
<StreamLocation>^User.CTHCCSLocationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
