/// ItmVenDiscount(2071)
Class User.INCItmVenDiscount Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = INC_ItmVenDiscount, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DISCChildsub [ IdKey, PrimaryKey, Unique ];

/// INC_ItmVen Parent Reference
Relationship DISCParRef As INCItmVen [ Cardinality = parent, Inverse = ChildINCItmVenDiscount, Required, SqlFieldName = DISC_ParRef ];

/// Childsub
Property DISCChildsub As %Float [ InitialExpression = {$i(^INCI($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"VE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DISC",0))}, SqlColumnNumber = 2, SqlFieldName = DISC_Childsub ];

/// Date From
Property DISCDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DISC_DateFrom ];

/// Date To
Property DISCDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DISC_DateTo ];

/// Qty From
Property DISCQtyFrom As %Float [ SqlColumnNumber = 5, SqlFieldName = DISC_QtyFrom ];

/// Qty To
Property DISCQtyTo As %Float [ SqlColumnNumber = 6, SqlFieldName = DISC_QtyTo ];

/// % Discount
Property DISCDiscount As %Float [ SqlColumnNumber = 7, SqlFieldName = DISC_Discount ];

/// Bonus Stock
Property DISCBonusStock As %Float [ SqlColumnNumber = 8, SqlFieldName = DISC_BonusStock ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INCItmVen).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVen","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INCItmVen).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVen","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INCItmVen).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVen","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INCItmVen).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVen","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INCItmVen).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVen","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DISC_BonusStock">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DISC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DISC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DISC_Discount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DISC_QtyFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DISC_QtyTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^INCI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INC_ItmVen.INCV_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DISC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INC_ItmVen.INCV_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DISC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DISC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DISC_RowId</SqlRowIdName>
<StreamLocation>^User.INCItmVenDiscountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
