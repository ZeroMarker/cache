/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 指标子项
Class User.GCPSWPrjKPIItem Extends %Persistent [ SqlTableName = GCPSW_PrjKPIItem, StorageStrategy = SQLStorage ]
{

/// PKI_Parref
Relationship PKIParref As User.GCPSWPrjKPI [ Cardinality = parent, Inverse = ChildIK, Required, SqlFieldName = PKI_Parref ];

Index RowIDBasedIDKeyIndex On PKIChildSub [ IdKey, PrimaryKey, Unique ];

/// PKI_ChildSub
Property PKIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^CF.DOC.GCPSW.Prj($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"K",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PKI_ChildSub ];

/// 指标
Property PKIKPI As User.GCPSWItemKPI [ SqlColumnNumber = 3, SqlFieldName = PKI_KPI ];

/// 是否区间	
Property PKISection As %String [ SqlColumnNumber = 4, SqlFieldName = PKI_Section ];

/// 筛选值	
Property PKIVal As %String [ SqlColumnNumber = 5, SqlFieldName = PKI_Val ];

/// 指标单位		
Property PKIKPIUom As %String [ SqlColumnNumber = 6, SqlFieldName = PKI_KPIUom ];

/// 标准值		
Property PKIStdVal As %String [ SqlColumnNumber = 7, SqlFieldName = PKI_StdVal ];

/// 创建日期			
Property PKIAddDate As %Date [ SqlColumnNumber = 8, SqlFieldName = PKI_AddDate ];

/// 创建时间		
Property PKIAddTime As %Time [ SqlColumnNumber = 9, SqlFieldName = PKI_AddTime ];

/// 创建人	
Property PKIAddUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = PKI_AddUser ];

/// 备注	
Property PKINote As %String [ SqlColumnNumber = 11, SqlFieldName = PKI_Note ];

/// 筛选规则【LIKE,FULL: 模糊匹配，精确匹配】
Property PKIRule As %String [ SqlColumnNumber = 12, SqlFieldName = PKI_Rule ];

/// 指标类型
Property PKIKPIType As User.GCPSWItem [ SqlColumnNumber = 13, SqlFieldName = PKI_KPIType ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PKI_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PKI_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PKI_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PKI_KPI">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PKI_KPIType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PKI_KPIUom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PKI_Note">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PKI_Rule">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PKI_Section">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PKI_StdVal">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PKI_Val">
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
<Field>GCPSW_PrjKPI.PK_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PKI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{GCPSW_Prj.P_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"K"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCPSW_PrjKPI.PK_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PKI_ChildSub}</Expression>
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
<Expression>{L4}</Expression>
<Field>GCPSW_PrjKPI.PK_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PKI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PrjKPIItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCPSW_Prj.P_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GCPSW_PrjKPI.PK_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PKI_KPI}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PKI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxKPIType">
<Global>^CF.DOC.GCPSW.PrjI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>GCPSW_Prj.P_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>GCPSW_PrjKPI.PK_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PKI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PrjKPIItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KPIType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCPSW_Prj.P_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GCPSW_PrjKPI.PK_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PKI_KPIType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PKI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PKI_ID</SqlRowIdName>
<StreamLocation>^User.GCPSWPrjKPIItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
