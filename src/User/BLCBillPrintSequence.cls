/// BLC Bill Print Sequence(1488)
Class User.BLCBillPrintSequence Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_BillPrintSequence, StorageStrategy = SQLStorage ]
{

/// Des Ref BillGroup
Property BPSBillGroupDR As ARCBillGrp [ SqlColumnNumber = 2, SqlFieldName = BPS_BillGroup_DR ];

/// Des Ref InsType
Property BPSInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 3, SqlFieldName = BPS_InsType_DR ];

/// Sequence
Property BPSSequence As %Float [ Required, SqlColumnNumber = 4, SqlFieldName = BPS_Sequence ];

/// Summary
Property BPSSummary As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = BPS_Summary ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCBillPrintSequence).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCBillPrintSequence","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCBillPrintSequence).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCBillPrintSequence","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCBillPrintSequence).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCBillPrintSequence","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCBillPrintSequence).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCBillPrintSequence","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCBillPrintSequence).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCBillPrintSequence","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCBillPrintSequence","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^BLC("BPS",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BPS_BillGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BPS_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BPS_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BPS_Summary">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BPS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BPS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BPS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBillGrp">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BPS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BPS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BillGrp"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BPS_BillGroup_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BPS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BPS_RowId</SqlRowIdName>
<StreamLocation>^User.BLCBillPrintSequenceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
