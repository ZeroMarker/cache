/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 子项设置
Class User.GCPSWItem Extends %Persistent [ SqlTableName = GCPSW_Item, StorageStrategy = SQLStorage ]
{

Relationship ChildIK As User.GCPSWItemKPI [ Cardinality = children, Inverse = IKParref ];

Relationship ITParRef As User.GCPSWKPIType [ Cardinality = parent, Inverse = ChildItem, Required, SqlFieldName = IT_ParRef ];

Index RowIDBasedIDKeyIndex On ITChildSub [ IdKey, PrimaryKey, Unique ];

/// ITChildSub
Property ITChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^CF.DOC.GCPSW.KPIType(+$s($d(initvalue):initvalue,1:%d(0)),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = IT_ChildSub ];

/// 代码
Property ITCode As %String [ SqlColumnNumber = 3, SqlFieldName = IT_Code ];

/// 描述
Property ITDesc As %String [ SqlColumnNumber = 4, SqlFieldName = IT_Desc ];

/// 日期
Property ITDate As %String [ SqlColumnNumber = 5, SqlFieldName = IT_Date ];

/// 时间
Property ITTime As %String [ SqlColumnNumber = 6, SqlFieldName = IT_Time ];

/// 用户
Property ITUser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = IT_User ];

/// 备注
Property ITNote As %String [ SqlColumnNumber = 8, SqlFieldName = IT_Note ];

/// 医嘱项
Property ITArcim As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = IT_Arcim ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="IT_Arcim">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IT_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IT_Note">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IT_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IT_User">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^CF.DOC.GCPSW.KPITypeD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GCPSW_KPIType.KT_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{GCPSW_KPIType.KT_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IT_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxITCode">
<Global>^CF.DOC.GCPSW.KPITypeI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>GCPSW_KPIType.KT_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>IT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCPSW_KPIType.KT_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IT_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IT_ID</SqlRowIdName>
<StreamLocation>^User.GCPSWItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
