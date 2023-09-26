/// HL7 Master File Defaults
Class User.SSHL7MasterFile Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7MasterFile, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HL7MFDCount [ IdKey, PrimaryKey, Unique ];

/// SS_HL7 Parent Reference
Relationship HL7MFDParRef As SSHL7 [ Cardinality = parent, Inverse = ChildSSHL7MasterFile, Required, SqlFieldName = HL7MFD_ParRef ];

/// Count - Always 1
Property HL7MFDCount As %Float [ SqlColumnNumber = 2, SqlFieldName = HL7MFD_Count ];

/// M05 Default Ward Type
Property HL7MFDM05DefWardType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HL7MFD_M05DefWardType ];

/// M05 Mark Ward as Inpatient
Property HL7MFDM05WardAsInpat As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = HL7MFD_M05WardAsInpat ];

/// M05 Mark Bed as Available
Property HL7MFDM05BedAvail As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = HL7MFD_M05BedAvail ];

/// M05 Mark Bed as Active
Property HL7MFDM05BedActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = HL7MFD_M05BedActive ];

/// M05 Default Bed Type
Property HL7MFDM05DefBedType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = HL7MFD_M05DefBedType ];

/// M05 Default Room Type
Property HL7MFDM05DefRoomType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = HL7MFD_M05DefRoomType ];

/// M08 Default Security Group
Property HL7MFDM08DefSecurityGrp As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = HL7MFD_M08DefSecurityGrp ];

/// M08 Default Billing Sub Group
Property HL7MFDM08DefBillingSubGrp As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = HL7MFD_M08DefBillingSubGrp ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSHL7MasterFile).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFile","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSHL7MasterFile).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFile","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSHL7MasterFile).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFile","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSHL7MasterFile).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFile","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSHL7MasterFile).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7MasterFile","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HL7MFD_M05BedActive">
<Delimiter>"^"</Delimiter>
<Node>"M05"</Node>
<Piece>4</Piece>
</Data>
<Data name="HL7MFD_M05BedAvail">
<Delimiter>"^"</Delimiter>
<Node>"M05"</Node>
<Piece>3</Piece>
</Data>
<Data name="HL7MFD_M05DefBedType">
<Delimiter>"^"</Delimiter>
<Node>"M05"</Node>
<Piece>5</Piece>
</Data>
<Data name="HL7MFD_M05DefRoomType">
<Delimiter>"^"</Delimiter>
<Node>"M05"</Node>
<Piece>6</Piece>
</Data>
<Data name="HL7MFD_M05DefWardType">
<Delimiter>"^"</Delimiter>
<Node>"M05"</Node>
<Piece>1</Piece>
</Data>
<Data name="HL7MFD_M05WardAsInpat">
<Delimiter>"^"</Delimiter>
<Node>"M05"</Node>
<Piece>2</Piece>
</Data>
<Data name="HL7MFD_M08DefBillingSubGrp">
<Delimiter>"^"</Delimiter>
<Node>"M08"</Node>
<Piece>2</Piece>
</Data>
<Data name="HL7MFD_M08DefSecurityGrp">
<Delimiter>"^"</Delimiter>
<Node>"M08"</Node>
<Piece>1</Piece>
</Data>
<Global>^SSHL7</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SS_HL7.HL7_Code</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HL7MFD_Count</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MAST-FILE-DEFAULT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7MFD_Count}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7MFD_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7MasterFileS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
