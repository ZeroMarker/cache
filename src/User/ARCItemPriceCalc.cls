/// ARC Item Price Calculation(1636)
Class User.ARCItemPriceCalc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemPriceCalc, StorageStrategy = SQLStorage ]
{

Relationship ChildARCItemPriceCalcHistory As ARCItemPriceCalcHistory [ Cardinality = children, Inverse = HISParRef ];

/// Cost From
Property PRCCostFrom As %Float(MINVAL = 0) [ Required, SqlColumnNumber = 3, SqlFieldName = PRC_CostFrom ];

/// Des Ref Currency
Property PRCCurrencyDR As CTCurrency [ SqlColumnNumber = 2, SqlFieldName = PRC_Currency_DR ];

/// Percentage Increase
Property PRCPercentageIncrease As %Float [ Required, SqlColumnNumber = 4, SqlFieldName = PRC_PercentageIncrease ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemPriceCalc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemPriceCalc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemPriceCalc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemPriceCalc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemPriceCalc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemPriceCalc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemPriceCalc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemPriceCalc","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemPriceCalc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemPriceCalc","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="PRCCostFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PRCCurrencyDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PRCPercentageIncrease">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARC("PRC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PRC_CostFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRC_Currency_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRC_PercentageIncrease">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PRC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PRC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PRC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCurrency">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PRC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PRC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Curr"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRC_Currency_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{PRC_CostFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PRC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PRC_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemPriceCalcS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
