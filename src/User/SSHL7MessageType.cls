/// HL7 Message Types (2395)
Class User.SSHL7MessageType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7MessageType, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HL7MSGType [ IdKey, PrimaryKey, Unique ];

Relationship ChildSSHL7Segment As SSHL7Segment [ Cardinality = children, Inverse = HL7SEGParRef ];

/// SS_HL7 Parent Reference
Relationship HL7MSGParRef As SSHL7 [ Cardinality = parent, Inverse = ChildSSHL7MessageType, Required, SqlFieldName = HL7MSG_ParRef ];

/// Message Type
Property HL7MSGType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = HL7MSG_Type ];

/// Also send this message
Property HL7MSGAlsoSendMsg As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HL7MSG_AlsoSendMsg ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSHL7MessageType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MessageType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSHL7MessageType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MessageType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSHL7MessageType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MessageType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSHL7MessageType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MessageType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSHL7MessageType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MessageType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HL7MSG_AlsoSendMsg">
<Delimiter>"^"</Delimiter>
<Node>"ALSO-SEND"</Node>
<Piece>1</Piece>
</Data>
<Global>^SSHL7</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SS_HL7.HL7_Code</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HL7MSG_Type</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MSG-TYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7MSG_Type}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMessageType">
<Global>^SSHL7i</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SS_HL7.HL7_Code</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>HL7MSG_Type</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MSG-TYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{HL7MSG_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LINK"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HL7MSG_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7MessageTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
