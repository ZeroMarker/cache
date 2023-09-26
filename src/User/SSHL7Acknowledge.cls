/// HL7 Acknowledge (2485)
Class User.SSHL7Acknowledge Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7Acknowledge, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HL7ACKSequence [ IdKey, PrimaryKey, Unique ];

/// SS_HL7 Parent Reference
Relationship HL7ACKParRef As SSHL7 [ Cardinality = parent, Inverse = ChildSSHL7Acknowledge, Required, SqlFieldName = HL7ACK_ParRef ];

/// Sequence Number
Property HL7ACKSequence As %Float [ SqlColumnNumber = 2, SqlFieldName = HL7ACK_Sequence ];

/// Segment Type
Property HL7ACKSegment As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HL7ACK_Segment ];

/// Mandatory
Property HL7ACKMandatory As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = HL7ACK_Mandatory ];

/// Contains Error Condition
Property HL7ACKContainError As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = HL7ACK_ContainError ];

/// Error Condition Field
Property HL7ACKErrorField As %Float [ SqlColumnNumber = 6, SqlFieldName = HL7ACK_ErrorField ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSHL7Acknowledge).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Acknowledge","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSHL7Acknowledge).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Acknowledge","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSHL7Acknowledge).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Acknowledge","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSHL7Acknowledge).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Acknowledge","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSHL7Acknowledge).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Acknowledge","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HL7ACK_ContainError">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HL7ACK_ErrorField">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HL7ACK_Mandatory">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HL7ACK_Segment">
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
<Field>HL7ACK_Sequence</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MSG-ACK"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7ACK_Sequence}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7ACK_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7AcknowledgeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
