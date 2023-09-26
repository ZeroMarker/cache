/// Manufact. Order Batch(1089)
Class User.INManufactureOrderBatch Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_Manufacture_Order_Batch, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 7;

/// Childsub
Property MOBATChildsub As %Float [ InitialExpression = {$i(^INMAN($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"BAT",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MOBAT_Childsub ];

/// Des Ref to INCLB
Property MOBATINCLBDR As INCItmLcBt [ Required, SqlColumnNumber = 3, SqlFieldName = MOBAT_INCLB_DR ];

/// IN_Manufacture_Order Parent Reference
Relationship MOBATParRef As INManufactureOrder [ Cardinality = parent, Inverse = ChildINManufactureOrderBatch, Required, SqlFieldName = MOBAT_ParRef ];

/// Quantity
Property MOBATQty As %Float(MINVAL = .001) [ SqlColumnNumber = 4, SqlFieldName = MOBAT_Qty ];

Index RowIDBasedIDKeyIndex On MOBATChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INManufactureOrderBatch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INManufactureOrderBatch","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INManufactureOrderBatch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INManufactureOrderBatch","OnAfterInsert")
 d POFILINS^MVBSTMOI
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INManufactureOrderBatch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INManufactureOrderBatch","OnAfterUpdate")
 d POFILUPD^MVBSTMOI
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INManufactureOrderBatch).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INManufactureOrderBatch","OnBeforeInsert")
 d PREFDEL^MVBSTMOI
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INManufactureOrderBatch).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INManufactureOrderBatch","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>7</ExtentSize>
<Property name="MOBATChildsub">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="MOBATINCLBDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="MOBATParRef">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MOBATQty">
<Selectivity>20.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="MOBAT_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MOBAT_Qty">
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
<Field>MOBAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_Manufacture_Order.INMAN_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MOBAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MOBAT_RowId</SqlRowIdName>
<StreamLocation>^User.INManufactureOrderBatchS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
