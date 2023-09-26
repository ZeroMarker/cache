/// 页面元素属性(子表)
Class User.PHAINEleItm Extends (%Persistent, User.Abstract) [ Owner = {_PUBLIC}, SqlTableName = PHAIN_EleItm, StorageStrategy = CacheSQLStorage ]
{

Index RowIDBasedIDKeyIndex On EleItmChildsub [ IdKey, PrimaryKey, Unique ];

Relationship EleItmParref As User.PHAINEle [ Cardinality = parent, Inverse = ChildPHAINEleItm, Required, SqlFieldName = EleItm_Parref ];

Property EleItmChildsub As %Float [ SqlColumnNumber = 2, SqlFieldName = EleItm_Childsub ];

/// 属性代码
Property EleItmCode As %String(MAXLEN = 150) [ Required, SqlColumnNumber = 3, SqlFieldName = EleItm_Code ];

/// 属性名称
Property EleItmDesc As %String(MAXLEN = 150) [ Required, SqlColumnNumber = 4, SqlFieldName = EleItm_Desc ];

/// 属性类型 (string/boolean/number/pointer)
Property EleItmValType As %String [ SqlColumnNumber = 5, SqlFieldName = EleItm_ValType ];

/// 属性说明(备注)
Property EleItmMemo As %String(MAXLEN = 300) [ SqlColumnNumber = 6, SqlFieldName = EleItm_Memo ];

/// 属性是否启用
Property EleItmActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 7, SqlFieldName = EleItm_Active ];

/// 属性默认值
Property EleItmDefVal As %String [ SqlColumnNumber = 8, SqlFieldName = EleItm_DefVal ];

Storage CacheSQLStorage
{
<SQLMap name="DataMaster">
<Data name="EleItm_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EleItm_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EleItm_DefVal">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EleItm_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EleItm_Memo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EleItm_ValType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF.PHA.IN.Ele</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_Ele.Ele_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EleItm_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_Ele.Ele_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EleItm_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CF.PHA.IN.Elei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHAIN_Ele.Ele_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>EleItm_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ItmCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAIN_Ele.Ele_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EleItm_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EleItm_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EleItm_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINEleItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
