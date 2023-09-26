Class User.PHCDrgIngrIndItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DIII_RowID, SqlTableName = PHC_DrgIngrIndItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DIIIChildSub [ IdKey, PrimaryKey, Unique ];

/// PHCDI Childsub
Property DIIIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DIII_ChildSub ];

Relationship DIIIParRef As User.PHCDrgIngredIndex [ Cardinality = parent, Inverse = ChildPHCDrgIngrIndItm, Required, SqlFieldName = DIII_ParRef ];

/// 指标名称
Property DIIIDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DIII_Desc ];

/// 指标下限
Property DIIIMinIndex As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DIII_MinIndex ];

/// 指标上限
Property DIIIMaxIndex As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DIII_MaxIndex ];

/// 指标单位
Property DIIIUom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DIII_Uom ];

/// 指标公式
Property DIIIFormula As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DIII_Formula ];

/// 指标代码
Property DIIICode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DIII_Code ];

/// 指标备注(类似外周<900mosm/L 等用于直接文字提醒的)
Property DIIIRemark As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DIII_Remark ];

/// 关联成分(只有一组药中存在这个成分才计算这个公式)
Property DIIIIngredient As User.PHCIngredient [ SqlColumnNumber = 10, SqlFieldName = DIII_Ingredient ];

/// 危重标志
Property DIIIWZFlag As %String [ SqlColumnNumber = 11, SqlFieldName = DIII_WZFlag ];

/// 关联用法
Property DIIIInstruc As User.PHCInstruc [ SqlColumnNumber = 12, SqlFieldName = DIII_Instruc ];

/// 排序字段
Property DIIISortIndex As %String [ SqlColumnNumber = 13, SqlFieldName = DIII_SortIndex ];

Storage SQLStorage
{
<SQLMap name="DIIIMasterIndex">
<Data name="DIII_Code">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DIII_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIII_Formula">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DIII_Ingredient">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DIII_Instruc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DIII_MaxIndex">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DIII_MinIndex">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DIII_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DIII_SortIndex">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DIII_Uom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DIII_WZFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^PHCDII</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHC_DrgIngredIndex.DII_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DIII_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHC_DrgIngredIndex.DII_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIII_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHCDrgIngrIndItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
