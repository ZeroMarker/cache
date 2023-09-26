/// LocStockFavourites(2721)
Class User.CTLocStockFavourites Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_LocStockFavourites, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On STFChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_Loc Parent Reference
Relationship STFParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocStockFavourites, Required, SqlFieldName = STF_ParRef ];

/// Childsub
Property STFChildsub As %Float [ InitialExpression = {$i(^CTLOC($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"STF",0))}, SqlColumnNumber = 2, SqlFieldName = STF_Childsub ];

/// Des Ref INCI
Property STFINCIDR As INCItm [ SqlColumnNumber = 3, SqlFieldName = STF_INCI_DR ];

/// Des Ref Generic
Property STFGenericDR As PHCGeneric [ SqlColumnNumber = 4, SqlFieldName = STF_Generic_DR ];

/// Des Ref GenericRouteForm
Property STFGenericRouteFormDR As PHCGenericRtForms [ SqlColumnNumber = 5, SqlFieldName = STF_GenericRouteForm_DR ];

/// Min
Property STFMin As %Float [ SqlColumnNumber = 6, SqlFieldName = STF_Min ];

/// Max
Property STFMax As %Float [ SqlColumnNumber = 7, SqlFieldName = STF_Max ];

/// Position
Property STFPosition As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = STF_Position ];

/// Sequence
Property STFSequence As %Float [ SqlColumnNumber = 9, SqlFieldName = STF_Sequence ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocStockFavourites).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocStockFavourites","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocStockFavourites).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocStockFavourites","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocStockFavourites).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocStockFavourites","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocStockFavourites).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocStockFavourites","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocStockFavourites).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocStockFavourites","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="STF_GenericRouteForm_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STF_Generic_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STF_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STF_Max">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="STF_Min">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STF_Position">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="STF_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>STF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STF_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>STF_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocStockFavouritesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
