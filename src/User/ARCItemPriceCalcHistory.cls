/// ARC Item Price Calc History(1637)
Class User.ARCItemPriceCalcHistory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemPriceCalcHistory, StorageStrategy = SQLStorage ]
{

/// Childsub
Property HISChildsub As %Float [ InitialExpression = {$i(^ARC("PRC",$p(%d(0),$c(1)),"HIS",0))}, SqlColumnNumber = 2, SqlFieldName = HIS_Childsub ];

/// Cost
Property HISCost As %Float [ SqlColumnNumber = 4, SqlFieldName = HIS_Cost ];

/// Des Ref Currency
Property HISCurrencyDR As CTCurrency [ SqlColumnNumber = 3, SqlFieldName = HIS_Currency_DR ];

/// Date Update
Property HISDateUpdate As %Date [ SqlColumnNumber = 6, SqlFieldName = HIS_DateUpdate ];

/// ARC_ItemPriceCalc Parent Reference
Relationship HISParRef As ARCItemPriceCalc [ Cardinality = parent, Inverse = ChildARCItemPriceCalcHistory, Required, SqlFieldName = HIS_ParRef ];

/// Percentage Increase
Property HISPercentageIncrease As %Float [ SqlColumnNumber = 5, SqlFieldName = HIS_PercentageIncrease ];

/// Time Update
Property HISTimeUpdate As %Time [ SqlColumnNumber = 7, SqlFieldName = HIS_TimeUpdate ];

Index RowIDBasedIDKeyIndex On HISChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemPriceCalcHistory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemPriceCalcHistory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemPriceCalcHistory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemPriceCalcHistory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemPriceCalcHistory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemPriceCalcHistory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemPriceCalcHistory).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemPriceCalcHistory","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemPriceCalcHistory).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemPriceCalcHistory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HIS_Cost">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HIS_Currency_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HIS_DateUpdate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HIS_PercentageIncrease">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HIS_TimeUpdate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_ItemPriceCalc.PRC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>HIS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PRC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItemPriceCalc.PRC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HIS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HIS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HIS_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemPriceCalcHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
