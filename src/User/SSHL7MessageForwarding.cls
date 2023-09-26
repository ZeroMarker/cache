/// HL7 Message Forwarding (2471)
Class User.SSHL7MessageForwarding Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7MessageForwarding, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (HL7MFMsgType, HL7MFInterface) [ IdKey, PrimaryKey, Unique ];

/// SS_HL7 Parent Reference
Relationship HL7MFParRef As SSHL7 [ Cardinality = parent, Inverse = ChildSSHL7MessageForwarding, Required, SqlFieldName = HL7MF_ParRef ];

/// Message Type
Property HL7MFMsgType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = HL7MF_MsgType ];

/// Outbound Interface
Property HL7MFInterface As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HL7MF_Interface ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSHL7MessageForwarding).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MessageForwarding","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSHL7MessageForwarding).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MessageForwarding","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSHL7MessageForwarding).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MessageForwarding","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSHL7MessageForwarding).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MessageForwarding","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSHL7MessageForwarding).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MessageForwarding","OnBeforeUpdate")
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
<Field>HL7MF_MsgType</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>HL7MF_Interface</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MSG-FWD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7MF_MsgType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"INT"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HL7MF_Interface}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7MF_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7MessageForwardingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
