/// INC Item Location Daily Tot(1650)
Class User.INCItmLcDailyTotal Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = INC_ItmLcDailyTotal, StorageStrategy = SQLStorage ]
{

/// Date
Property DAYDate As %Date [ SqlColumnNumber = 2, SqlFieldName = DAY_Date ];

/// INC_ItmLoc Parent Reference
Relationship DAYParRef As INCItmLoc [ Cardinality = parent, Inverse = ChildINCItmLcDailyTotal, Required, SqlFieldName = DAY_ParRef ];

/// Price at the Beginning of day
Property DAYPriceBeg As %Float [ SqlColumnNumber = 4, SqlFieldName = DAY_PriceBeg ];

/// Price at the End of the day
Property DAYPriceEnd As %Float [ SqlColumnNumber = 6, SqlFieldName = DAY_PriceEnd ];

/// Qty at the Beginning of day
Property DAYQtyBeg As %Float [ SqlColumnNumber = 3, SqlFieldName = DAY_QtyBeg ];

/// Qty at the End of the day
Property DAYQtyEnd As %Float [ SqlColumnNumber = 5, SqlFieldName = DAY_QtyEnd ];

Index RowIDBasedIDKeyIndex On DAYDate [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 19;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INCItmLcDailyTotal).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmLcDailyTotal","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INCItmLcDailyTotal).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmLcDailyTotal","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INCItmLcDailyTotal).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmLcDailyTotal","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INCItmLcDailyTotal).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmLcDailyTotal","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INCItmLcDailyTotal).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmLcDailyTotal","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>19</ExtentSize>
<Property name="DAYDate">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="DAYParRef">
<Selectivity>6.2500%</Selectivity>
</Property>
<Property name="DAYPriceBeg">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="DAYPriceEnd">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="DAYQtyBeg">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="DAYQtyEnd">
<Selectivity>7.6923%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DAY_PriceBeg">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DAY_PriceEnd">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DAY_QtyBeg">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DAY_QtyEnd">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^INCI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INC_ItmLoc.INCIL_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DAY_Date</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INC_ItmLoc.INCIL_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DAY"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DAY_Date}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DAY_RowId</SqlRowIdName>
<StreamLocation>^User.INCItmLcDailyTotalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
