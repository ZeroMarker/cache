/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 子项指标
Class User.GCPSWItemKPI Extends %Persistent [ SqlTableName = GCPSW_ItemKPI, StorageStrategy = SQLStorage ]
{

/// IK
Relationship IKParref As User.GCPSWItem [ Cardinality = parent, Inverse = ChildIK, Required, SqlFieldName = IK_Parref ];

Index RowIDBasedIDKeyIndex On IKChildSub [ IdKey, PrimaryKey, Unique ];

/// IK_ChildSub
Property IKChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^CF.DOC.GCPSW.KPIType($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"I",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"K",0))}, Required, SqlColumnNumber = 2, SqlFieldName = IK_ChildSub ];

/// 指标代码
Property IKCode As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = IK_Code ];

/// 指标名称	
Property IKName As %String [ SqlColumnNumber = 4, SqlFieldName = IK_Name ];

/// 复合指标	
Property IKComplex As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = IK_Complex ];

/// 添加日期	
Property IKAddDate As %String [ SqlColumnNumber = 6, SqlFieldName = IK_AddDate ];

/// 添加时间	
Property IKAddTime As %String [ SqlColumnNumber = 7, SqlFieldName = IK_AddTime ];

/// 添加用户	
Property IKAddUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = IK_AddUser ];

/// 备注
Property IKNote As %String [ SqlColumnNumber = 9, SqlFieldName = IK_Note ];

/// 表达式
Property IKExpress As %String [ SqlColumnNumber = 10, SqlFieldName = IK_Express ];

/// 医嘱项
Property IKArcim As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = IK_Arcim ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="IK_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IK_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IK_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IK_Arcim">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IK_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IK_Complex">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IK_Express">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IK_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IK_Note">
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
<Field>GCPSW_Item.IT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>IK_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{GCPSW_KPIType.KT_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCPSW_Item.IT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"K"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IK_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxIKCode">
<Global>^CF.DOC.GCPSW.KPITypeI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>GCPSW_KPIType.KT_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>GCPSW_Item.IT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>IK_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ItemKPI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IKCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCPSW_KPIType.KT_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GCPSW_Item.IT_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IK_Code}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IK_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IK_ID</SqlRowIdName>
<StreamLocation>^User.GCPSWItemKPIS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
