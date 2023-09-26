/// ItmVenCommItems(2593)
Class User.INCItmVenCommItems Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = INC_ItmVenCommItems, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On COMMChildsub [ IdKey, PrimaryKey, Unique ];

/// INC_ItmVen Parent Reference
Relationship COMMParRef As INCItmVen [ Cardinality = parent, Inverse = ChildINCItmVenCommItems, Required, SqlFieldName = COMM_ParRef ];

/// Childsub
Property COMMChildsub As %Float [ InitialExpression = {$i(^INCI($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"VE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"COMM",0))}, SqlColumnNumber = 2, SqlFieldName = COMM_Childsub ];

/// Des REf CommItem
Property COMMCommItemDR As INCCommercialItem [ SqlColumnNumber = 3, SqlFieldName = COMM_CommItem_DR ];

/// DateFrom
Property COMMDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = COMM_DateFrom ];

/// DateTo
Property COMMDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = COMM_DateTo ];

/// Des REf UOM
Property COMMUOMDR As CTUOM [ SqlColumnNumber = 6, SqlFieldName = COMM_UOM_DR ];

/// Price
Property COMMPrice As %Float [ SqlColumnNumber = 7, SqlFieldName = COMM_Price ];

/// Preffered
Property COMMPreffered As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = COMM_Preffered ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INCItmVenCommItems).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVenCommItems","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INCItmVenCommItems).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVenCommItems","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INCItmVenCommItems).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVenCommItems","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INCItmVenCommItems).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVenCommItems","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INCItmVenCommItems).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVenCommItems","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVenCommItems","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="COMM_CommItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="COMM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="COMM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="COMM_Preffered">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="COMM_Price">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="COMM_UOM_DR">
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
<Field>COMM_Childsub</Field>
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
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<Expression>"COMM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{COMM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>COMM_RowId</SqlRowIdName>
<StreamLocation>^User.INCItmVenCommItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
