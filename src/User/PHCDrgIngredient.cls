Class User.PHCDrgIngredient Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCDI_RowID, SqlTableName = PHC_DrgIngredient, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PHCDIChildSub [ IdKey, PrimaryKey, Unique ];

/// PHCDI Childsub
Property PHCDIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHCDI_ChildSub ];

/// PHC_DrgMast Parent Reference
Relationship PHCDIPHCDParRef As User.PHCDrgMast [ Cardinality = parent, Inverse = ChildPHCDrgIngredient, Required, SqlFieldName = PHCDI_PHCD_ParRef ];

/// 成分
Property PHCDIIngredDr As User.PHCIngredient [ SqlColumnNumber = 3, SqlFieldName = PHCDI_Ingred_Dr ];

/// 数量
Property PHCDIIngredQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHCDI_IngredQty ];

/// 单位
Property PHCDIIngredUom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHCDI_IngredUom ];

Storage SQLStorage
{
<SqlIdExpression>$I(^PHCDINGRED(0))</SqlIdExpression>
<SQLMap name="IndexIngredient">
<Global>^PHCDINGRED</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHCDI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Ingredient"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCDI_Ingred_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCDI_PHCD_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCDI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterPHCDINGRED">
<Data name="PHCDI_IngredQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCDI_IngredUom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHCDI_Ingred_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PHCDINGRED</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHCDI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCDI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHCDrgIngredientS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
