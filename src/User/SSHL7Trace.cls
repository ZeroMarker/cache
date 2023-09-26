/// HL7 Message Trace (2383)
Class User.SSHL7Trace Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7Trace, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (HL7MTDate, HL7MTSequence) [ IdKey, PrimaryKey, Unique ];

Relationship ChildSSHL7TraceRejections As SSHL7TraceRejections [ Cardinality = children, Inverse = HL7TRParRef ];

/// SS_HL7 Parent Reference
Relationship HL7MTParRef As SSHL7 [ Cardinality = parent, Inverse = ChildSSHL7Trace, Required, SqlFieldName = HL7MT_ParRef ];

/// Date message received/sent
Property HL7MTDate As %Date [ SqlColumnNumber = 2, SqlFieldName = HL7MT_Date ];

/// Sequence
Property HL7MTSequence As %Float [ InitialExpression = {$i(^SSHL7($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"TRACE",$p(%d(2),$c(1))))}, Required, SqlColumnNumber = 3, SqlFieldName = HL7MT_Sequence ];

/// HL7 message received/sent
Property HL7MTMessage As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = HL7MT_Message, SqlListType = SUBNODE ];

/// Time message received/sent
Property HL7MTTime As %Time [ SqlColumnNumber = 5, SqlFieldName = HL7MT_Time ];

/// Ack/Nak message
Property HL7MTAckNak As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = HL7MT_AckNak, SqlListType = SUBNODE ];

/// Direction of message
Property HL7MTDirection As %String(DISPLAYLIST = ",E-->M,M-->E,*****", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",E-->M,M-->E,*****") [ SqlColumnNumber = 7, SqlFieldName = HL7MT_Direction ];

/// Type of message in trace
Property HL7MTMessageType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = HL7MT_MessageType ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSHL7Trace).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Trace","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSHL7Trace).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Trace","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSHL7Trace).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Trace","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSHL7Trace).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Trace","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSHL7Trace).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Trace","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HL7MT_AckNak">
<Node>"ACK"</Node>
</Data>
<Data name="HL7MT_Direction">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HL7MT_Message">
<Node>"MSG"</Node>
</Data>
<Data name="HL7MT_MessageType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HL7MT_Time">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSHL7</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SS_HL7.HL7_Code</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HL7MT_Date</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>HL7MT_Sequence</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRACE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7MT_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HL7MT_Sequence}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7MT_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7TraceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
