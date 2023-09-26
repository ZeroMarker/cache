/// 描述：医呼通-群组
/// 创建人：陈莹-基础数据平台
/// 创建日期：2020-12-15
Class User.CTHCCSGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlTableName = CT_HCCSGroup, StorageStrategy = SQLStorage ]
{

/// 群组关联用户表（子表）
Relationship ChildGroupLinkContList As User.CTHCCSGroupLinkContList [ Cardinality = children, Inverse = CGCLParRef ];

/// 群组代码（界面上先隐藏）
Property GROUPCode As %String(MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = GROUP_Code ];

/// 群组名称
Property GROUPDesc As %String(MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = GROUP_Desc ];

/// 开始日期
Property GROUPDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = GROUP_DateFrom ];

/// 结束日期
Property GROUPDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = GROUP_DateTo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("HCCSGROUP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GROUP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GROUP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GROUP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GROUP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>GROUP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"HCCSGROUP"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{GROUP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GROUP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"HCCSGROUP"</Expression>
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
<Expression>{GROUP_Code}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GROUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GROUP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HCCSGROUP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GROUP_Desc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GROUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>GROUP_RowId</SqlRowIdName>
<StreamLocation>^User.CTHCCSGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
