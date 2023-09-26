/// 皮试维护
/// creator: Huxt
/// date: 2020-03-18
Class User.PHAINSkinTest Extends (%Persistent, User.Abstract) [ SqlRowIdName = PIST_RowId, SqlTableName = PHAIN_SkinTest, StorageStrategy = CacheSQLStorage ]
{

/// 定义子表
Relationship ChildPHAINSkinTestItm As User.PHAINSkinTestItm [ Cardinality = children, Inverse = PISTIParref ];

/// 过敏源ID
Property PISTALGDR As User.PACAllergy [ SqlColumnNumber = 2, SqlFieldName = PIST_ALG_DR ];

/// 医嘱项ID (与通用名二选一)
Property PISTARCIMDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = PIST_ARCIM_DR ];

/// 通用名ID (与医嘱项二选一)
Property PISTGenericDR As User.PHCGeneric [ SqlColumnNumber = 4, SqlFieldName = PIST_Generic_DR ];

/// 皮试有效时间 (小时)
Property PISTValidTime As %Float [ SqlColumnNumber = 5, SqlFieldName = PIST_ValidTime ];

/// 允许脱敏
Property PISTDesensitFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PIST_DesensitFlag ];

/// 允许免试
Property PISTNoTestFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PIST_NoTestFlag ];

/// 允许脱敏
Property PISTExceptionFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PIST_ExceptionFlag ];

/// 开始日期
Property PISTStartDate As %Date [ SqlColumnNumber = 9, SqlFieldName = PIST_StartDate ];

/// 截止日期
Property PISTEndDate As %Date [ SqlColumnNumber = 10, SqlFieldName = PIST_EndDate ];

/// 默认免试
Property PISTDefNoTest As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PIST_DefNoTest ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^CF.PHA.IN.SkinTest)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="PIST_ALG_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIST_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIST_DefNoTest">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PIST_DesensitFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIST_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PIST_ExceptionFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PIST_Generic_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIST_NoTestFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PIST_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PIST_ValidTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CF.PHA.IN.SkinTest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIST_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexALG">
<Global>^CF.PHA.IN.SkinTesti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ALG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIST_ALG_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^CF.PHA.IN.SkinTesti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIST_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGeneric">
<Global>^CF.PHA.IN.SkinTesti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Generic"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIST_Generic_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PIST_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINSkinTestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CF.PHA.IN.SkinTest)
	s oldI = +$g(^mdata("CF.PHA.IN.SkinTest"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CF.PHA.IN.SkinTest = maxI
	s ^mdata("CF.PHA.IN.SkinTest") = maxI
}

}
