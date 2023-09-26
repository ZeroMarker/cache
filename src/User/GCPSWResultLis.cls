/// CTOR: QP
/// DATE: 2021-03-04
/// DESC: 筛选结果入选Lis集
Class User.GCPSWResultLis Extends %Persistent [ SqlTableName = GCPSW_ResultLis, StorageStrategy = SQLStorage ]
{

Relationship PLParRef As User.GCPSWResult [ Cardinality = parent, Inverse = ChildLis, Required, SqlFieldName = PL_ParRef ];

Index RowIDBasedIDKeyIndex On PLChildSub [ IdKey, PrimaryKey, Unique ];

/// PLChildSub
Property PLChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^BS.DOC.GCPSW.Result(+$s($d(initvalue):initvalue,1:%d(0)),"L",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PL_ChildSub ];

/// 入选医嘱
Property PLOeori As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = PL_Oeori ];

/// 入选细项Code
Property PLCode As %String [ SqlColumnNumber = 4, SqlFieldName = PL_Code ];

/// 入选细项VAL
Property PLVal As %String [ SqlColumnNumber = 5, SqlFieldName = PL_Val ];

/// 医嘱项
Property PLArcim As User.ARCItmMast [ SqlColumnNumber = 6, SqlFieldName = PL_Arcim ];

/// 创建日期	
Property PLAddDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PL_AddDate ];

/// 创建时间	
Property PLAddTime As %Time [ SqlColumnNumber = 8, SqlFieldName = PL_AddTime ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PL_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PL_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PL_Arcim">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PL_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PL_Oeori">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PL_Val">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^BS.DOC.GCPSW.ResultD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GCPSW_Result.R_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{GCPSW_Result.R_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"L"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PL_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxArcimCode">
<Global>^BS.DOC.GCPSW.ResultI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>GCPSW_Result.R_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ResultLis"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ArcimCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCPSW_Result.R_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PL_Arcim}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PL_Code}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxCode">
<Global>^BS.DOC.GCPSW.ResultI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>GCPSW_Result.R_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ResultLis"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCPSW_Result.R_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PL_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.GCPSWResultLisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
