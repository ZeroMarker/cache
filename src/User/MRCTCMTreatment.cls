/// Creator：基础数据平台-陈莹
/// CreatDate: 2020-12-21
/// Description：中医治法
Class User.MRCTCMTreatment Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlTableName = MRC_TCMTreatment, StorageStrategy = SQLStorage ]
{

/// 中医治法名代码
Property TCMTCode As %String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = TCMT_Code ];

/// 中医治法名称
Property TCMTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = TCMT_Desc ];

/// 编号
Property TCMTNumber As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = TCMT_Number ];

/// 国家标准名称
Property TCMTNationalDesc As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = TCMT_NationalDesc ];

/// 临床可开立标记（N时不能作为中医治法来开）
Property TCMTValid As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = TCMT_Valid ];

/// 开始日期
Property TCMTDateFrom As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = TCMT_DateFrom ];

/// 结束日期
Property TCMTDateTo As %Date [ SqlColumnNumber = 8, SqlFieldName = TCMT_DateTo ];

/// 别名
Property TCMTAlias As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = TCMT_Alias ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^MRC("TCMT",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="TCMT_Alias">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TCMT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TCMT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TCMT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TCMT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TCMT_NationalDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TCMT_Number">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TCMT_Valid">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TCMT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"TCMT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{TCMT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNationDesc">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TCMT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TCMT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"NationalDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TCMT_NationalDesc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TCMT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TCMT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TCMT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Number"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TCMT_Number}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TCMT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTCMTCode">
<Data name="TCMT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TCMT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"TCMT"</Expression>
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
<Expression>{TCMT_Code}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{TCMT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTCMTDesc">
<Data name="TCMT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TCMT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"TCMT"</Expression>
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
<Expression>{TCMT_Desc}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{TCMT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TCMT_RowId</SqlRowIdName>
<StreamLocation>^User.MRCTCMTreatmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
