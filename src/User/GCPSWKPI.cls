/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 指标
Class User.GCPSWKPI Extends %Persistent [ SqlTableName = GCPSW_KPI, StorageStrategy = SQLStorage ]
{

Relationship KPIParRef As User.GCPSWKPIType [ Cardinality = parent, Inverse = ChildKPI, Required, SqlFieldName = KPI_ParRef ];

Index RowIDBasedIDKeyIndex On KPIChildSub [ IdKey, PrimaryKey, Unique ];

/// KPIChildSub
Property KPIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^CF.DOC.GCPSW.KPIType(+$s($d(initvalue):initvalue,1:%d(0)),"K",0))}, Required, SqlColumnNumber = 2, SqlFieldName = KPI_ChildSub ];

/// 指标代码
Property KPICode As %String [ SqlColumnNumber = 3, SqlFieldName = KPI_Code ];

/// 指标名称	
Property KPIName As %String [ SqlColumnNumber = 4, SqlFieldName = KPI_Name ];

/// 复合指标
Property KPIComplex As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = KPI_Complex ];

/// 添加日期
Property KPIAddDate As %String [ SqlColumnNumber = 6, SqlFieldName = KPI_AddDate ];

/// 添加时间
Property KPIAddTime As %String [ SqlColumnNumber = 7, SqlFieldName = KPI_AddTime ];

/// 添加用户
Property KPIAddUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = KPI_AddUser ];

/// 备注
Property KPINote As %String [ SqlColumnNumber = 9, SqlFieldName = KPI_Note ];

/// 表达式
Property KPIExpress As %String [ SqlColumnNumber = 10, SqlFieldName = KPI_Express ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="KPI_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="KPI_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="KPI_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="KPI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="KPI_Complex">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="KPI_Express">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="KPI_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="KPI_Note">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CF.DOC.GCPSW.KPITypeD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GCPSW_KPIType.KT_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>KPI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{GCPSW_KPIType.KT_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"K"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KPI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxKPICode">
<Global>^CF.DOC.GCPSW.KPITypeI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>GCPSW_KPIType.KT_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>KPI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"KPI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KPICode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCPSW_KPIType.KT_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KPI_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KPI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>KPI_ID</SqlRowIdName>
<StreamLocation>^User.GCPSWKPIS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
