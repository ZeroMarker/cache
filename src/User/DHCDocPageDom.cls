/// CTOR: QP
/// DATE: 2019-10-23
/// DESC: PageDom
Class User.DHCDocPageDom Extends %Persistent [ ClassType = persistent, SqlRowIdName = PD_Id, SqlTableName = DHC_DocPageDom, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PDChildSub [ IdKey, PrimaryKey, Unique ];

/// PD_ParRef
Relationship PDParRef As User.DHCDocOrderPage [ Cardinality = parent, Inverse = ChildDHCDocPageDom, Required, SqlFieldName = PD_ParRef ];

/// PD_ChildSub
Property PDChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocPageDom(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = PD_ChildSub ];

/// PDDomID Dom Id
Property PDDomID As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PD_DomID ];

/// PD_DomName Dom 名称
Property PDDomName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PD_DomName ];

/// PD_MustFill 是否必填（Y/N）
Property PDMustFill As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PD_MustFill ];

/// PD_Seqno  顺序
Property PDSeqno As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PD_Seqno ];

/// PD_Css CSS样式
Property PDCss As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PD_Css ];

/// PD_Note 备注
Property PDNote As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PD_Note ];

/// PD_DomClass dom选择器
Property PDDomClass As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PD_DomClass ];

/// PD_ComponentType 组件类型
Property PDComponentType As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PD_ComponentType ];

/// PD_SupportJump 是否支持跳转（Y/N）
Property PDSupportJump As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PD_SupportJump ];

/// 元素所在单元ID 用于医生站应用配置缓存
Property PDDomUnitID As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PD_DomUnitID ];

/// 元素所在单元描述 用于医生站应用配置缓存
Property PDDomUnitName As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PD_DomUnitName ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PD_ComponentType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PD_Css">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PD_DomClass">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PD_DomID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PD_DomName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PD_DomUnitID">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PD_DomUnitName">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PD_MustFill">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PD_Note">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PD_Seqno">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PD_SupportJump">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCDocPageDom</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PD_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxDomClass">
<Global>^DHCDocPageDomI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DomClass"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PD_DomClass}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxDomClassSeqno">
<Global>^DHCDocPageDomI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DomClassSeqno"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PD_DomClass}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PD_Seqno}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxDomId">
<Global>^DHCDocPageDomI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DomId"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PD_DomID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxDomSeqno">
<Global>^DHCDocPageDomI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DomSeqno"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PD_Seqno}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PD_Id</SqlRowIdName>
<StreamLocation>^User.DHCDocPageDomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
