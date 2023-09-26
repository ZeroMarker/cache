/// Huxt 2020-04-17
/// 卡片属性附加表子表
/// d ##class(User.PHAINCardOptItm).%BuildIndices()
Class User.PHAINCardOptItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = PICOI_RowId, SqlTableName = PHAIN_CardOptItm, StorageStrategy = SQLStorage ]
{

/// 指向父表
Index RowIDBasedIDKeyIndex On PICOIChildsub [ IdKey, PrimaryKey, Unique ];

Relationship PICOIParref As User.PHAINCardOpt [ Cardinality = parent, Inverse = ChildPHAINCardOptItm, Required, SqlFieldName = PICOI_Parref ];

Property PICOIChildsub As %Integer [ SqlColumnNumber = 2, SqlFieldName = PICOI_Childsub ];

/// 医院(院区)
Property PICOIHOSPDR As User.CTHospital [ Required, SqlColumnNumber = 3, SqlFieldName = PICOI_HOSP_DR ];

/// 属性授权类型
Property PICOIType As %String(DISPLAYLIST = ",User,Group,Loc,All", MAXLEN = 10, SELECTIVITY = "25%", VALUELIST = ",U,G,L,A") [ Required, SqlColumnNumber = 4, SqlFieldName = PICOI_Type ];

/// 授权类型指向
Property PICOIPointer As %String [ InitialExpression = 0, Required, SqlColumnNumber = 5, SqlFieldName = PICOI_Pointer ];

/// 指向公共属性
Property PICOIPICADR As User.PHAINComAttr [ SqlColumnNumber = 6, SqlFieldName = PICOI_PICA_DR ];

/// 属性值
Property PICOIValue As %String [ SqlColumnNumber = 7, SqlFieldName = PICOI_Value ];

Storage SQLStorage
{
<SQLMap name="DataMap">
<Data name="PICOI_HOSP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PICOI_PICA_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PICOI_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PICOI_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PICOI_Value">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^CF.PHA.IN.CardOpt</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_CardOpt.PICO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PICOI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_CardOpt.PICO_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICOI_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHTPP">
<Global>^CF.PHA.IN.CardOpti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHAIN_CardOpt.PICO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>PICOI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HTPP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAIN_CardOpt.PICO_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICOI_HOSP_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PICOI_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PICOI_Pointer}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PICOI_PICA_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PICOI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTPP">
<Global>^CF.PHA.IN.CardOpti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHAIN_CardOpt.PICO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PICOI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TPP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAIN_CardOpt.PICO_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICOI_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PICOI_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PICOI_PICA_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PICOI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PICOI_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINCardOptItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
