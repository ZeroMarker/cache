/// OE Ord Bills(1351)
Class User.OEOrdBills Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdBills, StorageStrategy = SQLStorage ]
{

/// Des Ref ARPBL Item
Property BILLARPBLItemDR As ARPatBillGroupCharges [ SqlColumnNumber = 3, SqlFieldName = BILL_ARPBLItem_DR ];

/// Amount
Property BILLAmount As %Float [ SqlColumnNumber = 4, SqlFieldName = BILL_Amount ];

/// Childsub
Property BILLChildsub As %Float [ InitialExpression = {$i(^OEORD($p(%d(0),"||"),"I",$p(%d(0),"||",2),"BILL",0))}, SqlColumnNumber = 2, SqlFieldName = BILL_Childsub ];

/// OE_OrdItem Parent Reference
Relationship BILLParRef As OEOrdItem [ Cardinality = parent, Inverse = ChildOEOrdBills, Required, SqlFieldName = BILL_ParRef ];

/// Payor Type
Property BILLPayorType As %String(DISPLAYLIST = ",Patient,Insurance", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",P,I") [ SqlColumnNumber = 5, SqlFieldName = BILL_PayorType ];

Index RowIDBasedIDKeyIndex On BILLChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 4665;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdBills).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdBills","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdBills).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdBills","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdBills).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdBills","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdBills).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdBills","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdBills).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdBills","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4665</ExtentSize>
<Property name="BILLARPBLItemDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="BILLAmount">
<Selectivity>1</Selectivity>
</Property>
<Property name="BILLChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="BILLParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="BILLPayorType">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="BILL_ARPBLItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BILL_Amount">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BILL_PayorType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>BILL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"BILL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BILL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>BILL_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdBillsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
