/// Huxt 2020-04-17
/// 卡片子表(定义卡片各项内容的属性)
/// d ##class(User.PHAINCardItmSet).%BuildIndices()
Class User.PHAINCardItmSet Extends (%Persistent, User.Abstract) [ SqlRowIdName = PICIS_RowId, SqlTableName = PHAIN_CardItmSet, StorageStrategy = SQLStorage ]
{

/// 指向父表
Index RowIDBasedIDKeyIndex On PICISChildsub [ IdKey, PrimaryKey, Unique ];

Relationship PICISParref As User.PHAINCardItm [ Cardinality = parent, Inverse = ChildPHAINCardItmSet, Required, SqlFieldName = PICIS_Parref ];

Property PICISChildsub As %Integer [ SqlColumnNumber = 2, SqlFieldName = PICIS_Childsub ];

/// 卡片内容属性名称
Property PICISPICCIDR As User.PHAINCardContentItm [ Required, SqlColumnNumber = 3, SqlFieldName = PICIS_PICCI_DR ];

/// 卡片内容属性值
Property PICISValue As %String(MAXLEN = 300) [ SqlColumnNumber = 4, SqlFieldName = PICIS_Value ];

Storage SQLStorage
{
<SQLMap name="DataMap">
<Data name="PICIS_PICCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PICIS_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CF.PHA.IN.Card</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_Card.PIC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHAIN_CardItm.PICI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PICIS_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_Card.PIC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAIN_CardItm.PICI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"S"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PICIS_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPICCI">
<Global>^CF.PHA.IN.Cardi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHAIN_Card.PIC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHAIN_CardItm.PICI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PICIS_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PICCI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAIN_Card.PIC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAIN_CardItm.PICI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PICIS_PICCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PICIS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PICIS_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINCardItmSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
