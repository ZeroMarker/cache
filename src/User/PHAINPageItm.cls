/// 页面维护子表
Class User.PHAINPageItm Extends (%Persistent, User.Abstract) [ SqlTableName = PHAIN_PageItm, StorageStrategy = CacheSQLStorage ]
{

Index RowIDBasedIDKeyIndex On PageItmChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPHAINPageItmSet As User.PHAINPageItmSet [ Cardinality = children, Inverse = PageItmSetParref ];

Relationship PageItmParref As User.PHAINPage [ Cardinality = parent, Inverse = ChildPHAINPageItm, Required, SqlFieldName = PageItm_Parref ];

Property PageItmChildsub As %Float [ SqlColumnNumber = 2, SqlFieldName = PageItm_Childsub ];

/// 元素DomId
Property PageItmDom As %String(MAXLEN = 100) [ Required, SqlColumnNumber = 3, SqlFieldName = PageItm_Dom ];

/// 元素名称
Property PageItmDesc As %String(MAXLEN = 150) [ Required, SqlColumnNumber = 4, SqlFieldName = PageItm_Desc ];

/// 元素类型
Property PageItmEleDR As User.PHAINEle [ Required, SqlColumnNumber = 5, SqlFieldName = PageItm_Ele_DR ];

Storage CacheSQLStorage
{
<SQLMap name="DataMaster">
<Data name="PageItm_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PageItm_Dom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PageItm_Ele_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF.PHA.IN.Page</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_Page.Page_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PageItm_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_Page.Page_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PageItm_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDom">
<Global>^CF.PHA.IN.Pagei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHAIN_Page.Page_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PageItm_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Dom"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAIN_Page.Page_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PageItm_Dom}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PageItm_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PageItm_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINPageItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
