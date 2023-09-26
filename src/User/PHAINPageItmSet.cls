/// 页面元素授权设置
Class User.PHAINPageItmSet Extends (%Persistent, User.Abstract) [ SqlTableName = PHAIN_PageItmSet, StorageStrategy = CacheSQLStorage ]
{

/// 指向父表
Index RowIDBasedIDKeyIndex On PageItmSetChildsub [ IdKey, PrimaryKey, Unique ];

Relationship PageItmSetParref As User.PHAINPageItm [ Cardinality = parent, Inverse = ChildPHAINPageItmSet, Required, SqlFieldName = PageItmSet_Parref ];

Property PageItmSetChildsub As %Float [ SqlColumnNumber = 2, SqlFieldName = PageItmSet_Childsub ];

/// 授权类型(U-用户; G-安全组; L-科室; A-通用)
Property PageItmSetType As %String(DISPLAYLIST = ",User,Loc,Group,All", MAXLEN = 10, SELECTIVITY = "20%", VALUELIST = ",U,L,G,A") [ Required, SqlColumnNumber = 3, SqlFieldName = PageItmSet_Type ];

/// 授权类型指向
Property PageItmSetPointer As %String [ InitialExpression = 0, Required, SqlColumnNumber = 4, SqlFieldName = PageItmSet_Pointer ];

/// 元素属性指针
Property PageItmSetEleItmDR As User.PHAINEleItm [ SqlColumnNumber = 5, SqlFieldName = PageItmSet_EleItm_DR ];

/// 元素属性值
Property PageItmSetEleItmVal As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = PageItmSet_EleItmVal ];

/// 医院
Property PageItmSetHospDR As User.CTHospital [ Required, SqlColumnNumber = 7, SqlFieldName = PageItmSet_Hosp_DR ];

Storage CacheSQLStorage
{
<SQLMap name="DataMap">
<Data name="PageItmSet_EleItmVal">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PageItmSet_EleItm_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PageItmSet_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PageItmSet_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PageItmSet_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CF.PHA.IN.Page</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_Page.Page_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHAIN_PageItm.PageItm_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PageItmSet_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_Page.Page_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAIN_PageItm.PageItm_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"S"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PageItmSet_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHospTypePointer">
<Global>^CF.PHA.IN.Pagei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHAIN_Page.Page_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHAIN_PageItm.PageItm_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>PageItmSet_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HospTypePointer"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAIN_Page.Page_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAIN_PageItm.PageItm_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PageItmSet_Hosp_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PageItmSet_Type}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PageItmSet_Pointer}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PageItmSet_EleItm_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{PageItmSet_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^CF.PHA.IN.Pagei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHAIN_Page.Page_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHAIN_PageItm.PageItm_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>PageItmSet_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAIN_Page.Page_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAIN_PageItm.PageItm_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PageItmSet_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PageItmSet_Pointer}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PageItmSet_EleItm_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PageItmSet_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PageItmSet_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINPageItmSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
