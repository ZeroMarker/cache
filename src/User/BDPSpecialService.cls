/// 节假日特别情况业务代码表 add@20180205
/// 基础数据平台组-陈莹
Class User.BDPSpecialService Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = BDP_SpecialService, StorageStrategy = SQLStorage ]
{

/// 业务代码 1
Property BDPSSCode As %String [ SqlColumnNumber = 2, SqlFieldName = BDPSS_Code ];

/// 业务描述 2
Property BDPSSDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BDPSS_Desc ];

/// 备注 3
Property BDPSSRemark As %String [ SqlColumnNumber = 4, SqlFieldName = BDPSS_Remark ];

/// 是否开启时段标识Y/N 4
Property BDPSSTimeRangeFlag As %String [ SqlColumnNumber = 5, SqlFieldName = BDPSS_TimeRangeFlag ];

Index BDPSSCodeUnqIdx1 On BDPSSCode [ Unique ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CT("BDPSS",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BDPSS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BDPSS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BDPSS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BDPSS_TimeRangeFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BDPSS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"BDPSS"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{BDPSS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BDPSS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"BDPSS"</Expression>
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
<AccessType>sub</AccessType>
<Expression>{BDPSS_Code}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BDPSS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BDPSS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"BDPSS"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BDPSS_Desc}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{BDPSS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BDPSS_RowId</SqlRowIdName>
<StreamLocation>^User.BDPSpecialServiceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
