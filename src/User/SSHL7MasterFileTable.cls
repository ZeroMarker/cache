/// HL7 Master File Table
Class User.SSHL7MasterFileTable Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7MasterFileTable, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HL7MFTExternalTable [ IdKey, PrimaryKey, Unique ];

/// SS_HL7MasterFileMsg Parent Reference
Relationship HL7MFTParRef As SSHL7MasterFileMsg [ Cardinality = parent, Inverse = ChildSSHL7MasterFileTable, Required, SqlFieldName = HL7MFT_ParRef ];

/// Updated External Table
Property HL7MFTExternalTable As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = HL7MFT_ExternalTable ];

/// TrakCare table
Property HL7MFTTable As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HL7MFT_Table ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSHL7MasterFileTable).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFileTable","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSHL7MasterFileTable).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFileTable","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSHL7MasterFileTable).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFileTable","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSHL7MasterFileTable).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFileTable","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSHL7MasterFileTable).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFileTable","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HL7MFT_Table">
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
<Field>SS_HL7MasterFileMsg.HL7MFM_Type</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>HL7MFT_ExternalTable</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MAST-FILE-MSG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SS_HL7MasterFileMsg.HL7MFM_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TABLE"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HL7MFT_ExternalTable}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7MFT_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7MasterFileTableS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
