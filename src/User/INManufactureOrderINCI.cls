/// Manufacture_OrderINCI(2591)
Class User.INManufactureOrderINCI Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_Manufacture_OrderINCI, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INCIChildsub [ IdKey, PrimaryKey, Unique ];

/// IN_Manufacture_Order Parent Reference
Relationship INCIParRef As INManufactureOrder [ Cardinality = parent, Inverse = ChildINManufactureOrderINCI, Required, SqlFieldName = INCI_ParRef ];

/// Childsub
Property INCIChildsub As %Float [ InitialExpression = {$i(^INMAN($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"INCI",0))}, SqlColumnNumber = 2, SqlFieldName = INCI_Childsub ];

/// Des Ref INCI
Property INCIINCIDR As INCItm [ SqlColumnNumber = 3, SqlFieldName = INCI_INCI_DR ];

/// Qty
Property INCIQty As %Float [ SqlColumnNumber = 4, SqlFieldName = INCI_Qty ];

/// DoseQty
Property INCIDoseQty As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = INCI_DoseQty ];

/// Des Ref DoseUOM
Property INCIDoseUOMDR As CTUOM [ SqlColumnNumber = 6, SqlFieldName = INCI_DoseUOM_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INManufactureOrderINCI).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INManufactureOrderINCI","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INManufactureOrderINCI).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INManufactureOrderINCI","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INManufactureOrderINCI).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INManufactureOrderINCI","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INManufactureOrderINCI).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INManufactureOrderINCI","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INManufactureOrderINCI).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INManufactureOrderINCI","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="INCI_DoseQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCI_DoseUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INCI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^INMAN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_Manufacture_Order.INMAN_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INCI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_Manufacture_Order.INMAN_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INCI_RowId</SqlRowIdName>
<StreamLocation>^User.INManufactureOrderINCIS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
