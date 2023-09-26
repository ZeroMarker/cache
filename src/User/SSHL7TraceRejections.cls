/// HL7 Trace Rejections (2386)
Class User.SSHL7TraceRejections Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7TraceRejections, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HL7TRRejDR [ IdKey, PrimaryKey, Unique ];

/// SS_HL7Trace Parent Reference
Relationship HL7TRParRef As SSHL7Trace [ Cardinality = parent, Inverse = ChildSSHL7TraceRejections, Required, SqlFieldName = HL7TR_ParRef ];

/// Des Ref to OE_HL7Messages
Property HL7TRRejDR As OEHL7Messages [ SqlColumnNumber = 2, SqlFieldName = HL7TR_Rej_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSHL7TraceRejections).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7TraceRejections","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSHL7TraceRejections).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7TraceRejections","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSHL7TraceRejections).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7TraceRejections","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSHL7TraceRejections).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7TraceRejections","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSHL7TraceRejections).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7TraceRejections","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Global>^SSHL7</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SS_HL7.HL7_Code</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SS_HL7Trace.HL7MT_Date</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>SS_HL7Trace.HL7MT_Sequence</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L6}</Expression>
<Field>HL7TR_Rej_DR</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRACE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SS_HL7Trace.HL7MT_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SS_HL7Trace.HL7MT_Sequence}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"REJ"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{HL7TR_Rej_DR}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7TR_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7TraceRejectionsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
