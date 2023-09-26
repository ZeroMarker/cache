/// HL7 Master File Messages
Class User.SSHL7MasterFileMsg Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7MasterFileMsg, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HL7MFMType [ IdKey, PrimaryKey, Unique ];

Relationship ChildSSHL7MasterFileTable As SSHL7MasterFileTable [ Cardinality = children, Inverse = HL7MFTParRef ];

/// SS_HL7 Parent Reference
Relationship HL7MFMParRef As SSHL7 [ Cardinality = parent, Inverse = ChildSSHL7MasterFileMsg, Required, SqlFieldName = HL7MFM_ParRef ];

/// Message Type
Property HL7MFMType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = HL7MFM_Type ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSHL7MasterFileMsg).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFileMsg","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSHL7MasterFileMsg).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFileMsg","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSHL7MasterFileMsg).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFileMsg","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSHL7MasterFileMsg).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFileMsg","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSHL7MasterFileMsg).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFileMsg","OnBeforeUpdate")
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
<Field>HL7MFM_Type</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MAST-FILE-MSG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7MFM_Type}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7MFM_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7MasterFileMsgS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
