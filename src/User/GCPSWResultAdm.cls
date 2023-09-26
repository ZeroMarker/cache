/// CTOR: QP
/// DATE: 2020-09-23
/// DESC: 筛选结果就诊表
Class User.GCPSWResultAdm Extends %Persistent [ SqlTableName = GCPSW_ResultAdm, StorageStrategy = SQLStorage ]
{

Relationship PAParRef As User.GCPSWResult [ Cardinality = parent, Inverse = ChildAdm, Required, SqlFieldName = PA_ParRef ];

Index RowIDBasedIDKeyIndex On PAChildSub [ IdKey, PrimaryKey, Unique ];

/// PAChildSub
Property PAChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^BS.DOC.GCPSW.Result(+$s($d(initvalue):initvalue,1:%d(0)),"A",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PA_ChildSub ];

/// 就诊
Property PAAdm As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = PA_Adm ];

/// 医嘱
Property PAOeori As User.OEOrdItem [ SqlColumnNumber = 4, SqlFieldName = PA_Oeori ];

/// 医嘱项
Property PAArcim As User.ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = PA_Arcim ];

/// 创建日期	
Property PAAddDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PA_AddDate ];

/// 创建时间	
Property PAAddTime As %Time [ SqlColumnNumber = 7, SqlFieldName = PA_AddTime ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PA_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PA_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PA_Adm">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PA_Arcim">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PA_Oeori">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^BS.DOC.GCPSW.ResultD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GCPSW_Result.R_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{GCPSW_Result.R_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"A"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxAddDate">
<Global>^BS.DOC.GCPSW.ResultI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>GCPSW_Result.R_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ResultAdm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AddDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCPSW_Result.R_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_AddDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxAdm">
<Global>^BS.DOC.GCPSW.ResultI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>GCPSW_Result.R_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ResultAdm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCPSW_Result.R_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Adm}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxArcim">
<Global>^BS.DOC.GCPSW.ResultI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>GCPSW_Result.R_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ResultAdm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arcim"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCPSW_Result.R_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Arcim}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxOeori">
<Global>^BS.DOC.GCPSW.ResultI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>GCPSW_Result.R_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ResultAdm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Oeori"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCPSW_Result.R_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Oeori}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PA_ID</SqlRowIdName>
<StreamLocation>^User.GCPSWResultAdmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
