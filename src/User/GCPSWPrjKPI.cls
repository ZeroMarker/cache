/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 项目指标
Class User.GCPSWPrjKPI Extends %Persistent [ SqlTableName = GCPSW_PrjKPI, StorageStrategy = SQLStorage ]
{

Relationship ChildIK As User.GCPSWPrjKPIItem [ Cardinality = children, Inverse = PKIParref ];

Relationship PKParRef As User.GCPSWPrj [ Cardinality = parent, Inverse = ChildKPI, Required, SqlFieldName = PK_ParRef ];

Index RowIDBasedIDKeyIndex On PKChildSub [ IdKey, PrimaryKey, Unique ];

/// PKChildSub
Property PKChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^CF.DOC.GCPSW.Prj(+$s($d(initvalue):initvalue,1:%d(0)),"K",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PK_ChildSub ];

/// 指标
Property PKKPI As User.GCPSWKPI [ SqlColumnNumber = 3, SqlFieldName = PK_KPI ];

/// 是否区间	
Property PKSection As %String [ SqlColumnNumber = 4, SqlFieldName = PK_Section ];

/// 筛选值	
Property PKVal As %String [ SqlColumnNumber = 5, SqlFieldName = PK_Val ];

/// 指标单位		
Property PKKPIUom As %String [ SqlColumnNumber = 6, SqlFieldName = PK_KPIUom ];

/// 创建日期			
Property PKAddDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PK_AddDate ];

/// 创建时间		
Property PKAddTime As %Time [ SqlColumnNumber = 8, SqlFieldName = PK_AddTime ];

/// 创建人	
Property PKAddUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PK_AddUser ];

/// 备注	
Property PKNote As %String [ SqlColumnNumber = 10, SqlFieldName = PK_Note ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PK_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PK_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PK_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PK_KPI">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PK_KPIUom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PK_Note">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PK_Section">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PK_Val">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF.DOC.GCPSW.PrjD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GCPSW_Prj.P_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PK_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{GCPSW_Prj.P_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"K"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PK_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxKPI">
<Global>^CF.DOC.GCPSW.PrjI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>GCPSW_Prj.P_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PK_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PrjKPI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCPSW_Prj.P_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PK_KPI}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PK_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PK_ID</SqlRowIdName>
<StreamLocation>^User.GCPSWPrjKPIS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
