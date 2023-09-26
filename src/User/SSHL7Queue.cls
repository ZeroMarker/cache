/// HL7 Outbound Message Queue (2388)
Class User.SSHL7Queue Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7Queue, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HL7MQSequence [ IdKey, PrimaryKey, Unique ];

/// SS_HL7 Parent Reference
Relationship HL7MQParRef As SSHL7 [ Cardinality = parent, Inverse = ChildSSHL7Queue, Required, SqlFieldName = HL7MQ_ParRef ];

/// Sequence
Property HL7MQSequence As %Float [ InitialExpression = {$i(^SSHL7($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"QUEUE"))}, Required, SqlColumnNumber = 2, SqlFieldName = HL7MQ_Sequence ];

/// HL7 message queued
Property HL7MQMessage As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HL7MQ_Message, SqlListType = SUBNODE ];

/// Message type
Property HL7MQType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = HL7MQ_Type ];

/// MSH Receiving Application to send
Property HL7MQMSHReceivingApp As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = HL7MQ_MSHReceivingApp ];

/// MSH Receiving Facility to send
Property HL7MQMSHReceivingFac As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = HL7MQ_MSHReceivingFac ];

/// MSH Sending Facility to send
Property HL7MQMSHSendingFac As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = HL7MQ_MSHSendingFac ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSHL7Queue).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Queue","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSHL7Queue).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Queue","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSHL7Queue).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Queue","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSHL7Queue).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Queue","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSHL7Queue).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Queue","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HL7MQ_MSHReceivingApp">
<Delimiter>"\"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HL7MQ_MSHReceivingFac">
<Delimiter>"\"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HL7MQ_MSHSendingFac">
<Delimiter>"\"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HL7MQ_Message">
<Node>"MSG"</Node>
</Data>
<Data name="HL7MQ_Type">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSHL7</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SS_HL7.HL7_Code</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HL7MQ_Sequence</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"QUEUE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7MQ_Sequence}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7MQ_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7QueueS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
