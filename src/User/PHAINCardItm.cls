/// Huxt 2020-04-17
/// 卡片子表(定义卡片的内容)
/// d ##class(User.PHAINCardItm).%BuildIndices()
Class User.PHAINCardItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = PICI_RowId, SqlTableName = PHAIN_CardItm, StorageStrategy = SQLStorage ]
{

/// 指向父表
Index RowIDBasedIDKeyIndex On PICIChildsub [ IdKey, PrimaryKey, Unique ];

Relationship PICIParref As User.PHAINCard [ Cardinality = parent, Inverse = ChildPHAINCardItm, Required, SqlFieldName = PICI_Parref ];

Property PICIChildsub As %Integer [ SqlColumnNumber = 2, SqlFieldName = PICI_Childsub ];

/// 定义子表
Relationship ChildPHAINCardItmSet As User.PHAINCardItmSet [ Cardinality = children, Inverse = PICISParref ];

/// 卡片内容代码
Property PICICode As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PICI_Code ];

/// 卡片内容名称
Property PICIDesc As %String [ Required, SqlColumnNumber = 4, SqlFieldName = PICI_Desc ];

/// 卡片内容类型
Property PICIPICCDR As User.PHAINCardContent [ SqlColumnNumber = 5, SqlFieldName = PICI_PICC_DR ];

/// 卡片内容是否可用
Property PICIActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PICI_ActiveFlag ];

/// 卡片内容RowIndex (内容定位)
Property PICIRowIndex As %Integer [ SqlColumnNumber = 7, SqlFieldName = PICI_RowIndex ];

/// 卡片内容ColIndex (内容定位)
Property PICIColIndex As %Integer [ SqlColumnNumber = 8, SqlFieldName = PICI_ColIndex ];

/// 卡片内容排序号码
Property PICISortNum As %String [ SqlColumnNumber = 9, SqlFieldName = PICI_SortNum ];

Storage SQLStorage
{
<SQLMap name="DataMap">
<Data name="PICI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PICI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PICI_ColIndex">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PICI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PICI_PICC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PICI_RowIndex">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PICI_SortNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CF.PHA.IN.Card</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_Card.PIC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PICI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_Card.PIC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICI_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CF.PHA.IN.Cardi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"ICode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PICI_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAIN_Card.PIC_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PICI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRC">
<Global>^CF.PHA.IN.Cardi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHAIN_Card.PIC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PICI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAIN_Card.PIC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICI_RowIndex}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PICI_ColIndex}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PICI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSN">
<Global>^CF.PHA.IN.Cardi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHAIN_Card.PIC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PICI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAIN_Card.PIC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICI_SortNum}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PICI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PICI_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINCardItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
