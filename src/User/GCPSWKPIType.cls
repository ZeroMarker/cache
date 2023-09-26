/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 指标类型
Class User.GCPSWKPIType Extends %Persistent [ SqlTableName = GCPSW_KPIType, StorageStrategy = SQLStorage ]
{

Relationship ChildKPI As User.GCPSWKPI [ Cardinality = children, Inverse = KPIParRef ];

Relationship ChildItem As User.GCPSWItem [ Cardinality = children, Inverse = ITParRef ];

Index RowIDBasedIDKeyIndex On KTID [ IdKey, PrimaryKey, Unique ];

/// KT_ID
Property KTID As %Numeric(SCALE = 0) [ InitialExpression = {$i(^CF.DOC.GCPSW.KPIType(0))}, Required, SqlFieldName = KT_ID ];

/// 代码
Property KTCode As %String [ SqlColumnNumber = 2, SqlFieldName = KT_Code ];

/// 描述
Property KTDesc As %String [ SqlColumnNumber = 3, SqlFieldName = KT_Desc ];

/// 日期
Property KTDate As %String [ SqlColumnNumber = 4, SqlFieldName = KT_Date ];

/// 时间
Property KTTime As %String [ SqlColumnNumber = 5, SqlFieldName = KT_Time ];

/// 用户
Property KTUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = KT_User ];

/// 备注
Property KTNote As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = KT_Note ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="KT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="KT_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="KT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="KT_Note">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="KT_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="KT_User">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^CF.DOC.GCPSW.KPITypeD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>KT_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{KT_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxKTCode">
<Global>^CF.DOC.GCPSW.KPITypeI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>KT_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"KPIType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KTCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KT_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KT_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>KT_ID</SqlRowIdName>
<StreamLocation>^User.GCPSWKPITypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
