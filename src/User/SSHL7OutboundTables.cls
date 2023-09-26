/// HL7 Outbound Tables
Class User.SSHL7OutboundTables Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7OutboundTables, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HL7OUTTable [ IdKey, PrimaryKey, Unique ];

/// SS_HL7 Parent Reference
Relationship HL7OUTParRef As SSHL7 [ Cardinality = parent, Inverse = ChildSSHL7OutboundTables, Required, SqlFieldName = HL7OUT_ParRef ];

/// Updated Table
Property HL7OUTTable As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = HL7OUT_Table ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSHL7OutboundTables).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7OutboundTables","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSHL7OutboundTables).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7OutboundTables","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSHL7OutboundTables).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7OutboundTables","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSHL7OutboundTables).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7OutboundTables","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSHL7OutboundTables).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7OutboundTables","OnBeforeUpdate")
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
<Field>HL7OUT_Table</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OUT-TABLE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7OUT_Table}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOutboundTables">
<Global>^SSHL7i</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SS_HL7.HL7_Code</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>HL7OUT_Table</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OUT-TABLE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{HL7OUT_Table}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LINK"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HL7OUT_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7OutboundTablesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
