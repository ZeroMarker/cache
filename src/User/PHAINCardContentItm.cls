/// Huxt 2020-04-17
/// 卡片内容字典子表(此表与User.PHAINComAttr类似,感觉有点多余)
/// d ##class(User.PHAINCardContentItm).%BuildIndices()
Class User.PHAINCardContentItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = PICCI_RowId, SqlTableName = PHAIN_CardContentItm, StorageStrategy = SQLStorage ]
{

/// 指向父表
Index RowIDBasedIDKeyIndex On PICCIChildsub [ IdKey, PrimaryKey, Unique ];

Relationship PICCIParref As User.PHAINCardContent [ Cardinality = parent, Inverse = ChildPHAINCardContentItm, Required, SqlFieldName = PICCI_Parref ];

Property PICCIChildsub As %Integer [ SqlColumnNumber = 2, SqlFieldName = PICCI_Childsub ];

/// 内容代码
Property PICCICode As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PICCI_Code ];

/// 内容名称
Property PICCIDesc As %String [ Required, SqlColumnNumber = 4, SqlFieldName = PICCI_Desc ];

/// 公共属性
Property PICCIComFlag As %String [ Required, SqlColumnNumber = 5, SqlFieldName = PICCI_ComFlag ];

/// HISUI属性
Property PICCIHUIFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PICCI_HUIFlag ];

/// 必填属性
Property PICCIRequiredFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PICCI_RequiredFlag ];

/// 属性是否可用
Property PICCIActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PICCI_ActiveFlag ];

/// 属性值类型 (string/number/boolean/pointer/object/function)
Property PICCIValType As %String(MAXLEN = 10) [ SqlColumnNumber = 9, SqlFieldName = PICCI_ValType ];

/// 属性值范围
Property PICCIValRange As %String(MAXLEN = 200) [ SqlColumnNumber = 10, SqlFieldName = PICCI_ValRange ];

/// 表单类型(文本,下拉, 复选, 连接弹窗(pointer赋值))
Property PICCIFormType As %String(MAXLEN = 20) [ SqlColumnNumber = 11, SqlFieldName = PICCI_FormType ];

/// 表单显示顺序
Property PICCIFormSort As %String(MAXLEN = 10) [ SqlColumnNumber = 12, SqlFieldName = PICCI_FormSort ];

/// 表单默认值
Property PICCIFormVal As %String(MAXLEN = 50) [ SqlColumnNumber = 13, SqlFieldName = PICCI_FormVal ];

/// 属性使用备注 (内容可能很多,单独存)
Property PICCIMemo As list Of %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PICCI_Memo, SqlListType = SUBNODE ];

Storage SQLStorage
{
<SQLMap name="DataMap">
<Data name="PICCI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PICCI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PICCI_ComFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PICCI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PICCI_FormSort">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PICCI_FormType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PICCI_FormVal">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PICCI_HUIFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PICCI_Memo">
<Delimiter>"^"</Delimiter>
<Node>"Memo"</Node>
</Data>
<Data name="PICCI_RequiredFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PICCI_ValRange">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PICCI_ValType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CD.PHA.IN.CardContent</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_CardContent.PICC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PICCI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_CardContent.PICC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICCI_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CD.PHA.IN.CardContenti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHAIN_CardContent.PICC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PICCI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ICode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAIN_CardContent.PICC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICCI_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PICCI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PICCI_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINCardContentItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
