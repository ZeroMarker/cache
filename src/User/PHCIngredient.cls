/// PHC_Ingredient(2626)
Class User.PHCIngredient Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_Ingredient, StorageStrategy = SQLStorage ]
{

/// 成分代码
Property INGRCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = INGR_Code ];

/// 成分名称
Property INGRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = INGR_Desc ];

/// Allow Duplicate(未知)
Property INGRAllowDuplicate As %Float [ SqlColumnNumber = 4, SqlFieldName = INGR_AllowDuplicate ];

/// 成分单位
Property INGRUomDr As User.CTUOM [ SqlColumnNumber = 5, SqlFieldName = INGR_Uom_Dr ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCIngredient).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCIngredient","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCIngredient).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCIngredient","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCIngredient).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCIngredient","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCIngredient).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCIngredient","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCIngredient).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCIngredient","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCIngredient","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>8</ExtentSize>
<Property name="INGRAllowDuplicate">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INGRCode">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="INGRDesc">
<Selectivity>12.5000%</Selectivity>
</Property>
<SqlIdExpression>$i(^PHC("INGR",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="INGR_AllowDuplicate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INGR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INGR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INGR_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PHC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INGR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INGR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PHC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INGR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INGR_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PHC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INGR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INGR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INGR_RowId</SqlRowIdName>
<StreamLocation>^User.PHCIngredientS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
