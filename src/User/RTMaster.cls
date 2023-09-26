/// RT RecordTracking Master(RTMAS,347)
Class User.RTMaster Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RT_Master, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 31931;

Relationship ChildRTMasVol As RTMasVol [ Cardinality = children, Inverse = RTMAVRTMASParRef ];

/// Medical Record Number
Property RTMASMRNo As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = RTMAS_MRNo ];

/// Des Ref to PAPMI
Property RTMASPatNoDR As PAPatMas [ Required, SqlColumnNumber = 3, SqlFieldName = RTMAS_PatNo_DR ];

/// Expected Number of Use Day
Property RTMASExpDays As %Float(MAXVAL = 99, MINVAL = 1) [ InitialExpression = {$$DEF04^at347}, SqlColumnNumber = 4, SqlFieldName = RTMAS_ExpDays ];

/// Des Ref to CTLOC
Property RTMASHomeLocDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = RTMAS_HomeLoc_DR ];

/// Status (In/Out/Misplaced)
Property RTMASStatus As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlComputeCode = { s {RTMAS_Status}=$$CO06^at347({RTMAS_RowId})
}, SqlComputed, SqlFieldName = RTMAS_Status, Transient ];

/// Lookup field (combination of many field)
Property RTMASLookUp As %String(COLLATION = "Exact", MAXLEN = 78, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlComputeCode = { i ($G(XFUNC("LOOKUP","RTMAS"))="") s {RTMAS_LookUp}="" q
 s {RTMAS_LookUp}=$$CO07^at347({RTMAS_MRNo},{RTMAS_PatNo_DR},{RTMAS_HomeLoc_DR})
}, SqlComputed, SqlFieldName = RTMAS_LookUp, Transient ];

/// MR type - (I)nPatient, (O)utpatient
Property RTMASType As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = RTMAS_Type ];

/// Des Ref MR Type
Property RTMASMRTypeDR As RTCMRecordType [ SqlColumnNumber = 9, SqlFieldName = RTMAS_MRType_DR ];

/// Date Create
Property RTMASDateCreate As %Date [ SqlColumnNumber = 10, SqlFieldName = RTMAS_DateCreate ];

/// Time Create
Property RTMASTimeCreate As %Time [ SqlColumnNumber = 11, SqlFieldName = RTMAS_TimeCreate ];

/// Des Ref UserCreate
Property RTMASUserCreateDR As SSUser [ SqlColumnNumber = 12, SqlFieldName = RTMAS_UserCreate_DR ];

/// Active
Property RTMASActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = RTMAS_Active ];

/// Des Ref CreateLoc
Property RTMASCreateLocDR As CTLoc [ SqlColumnNumber = 14, SqlFieldName = RTMAS_CreateLoc_DR ];

/// Des Ref Hospital
Property RTMASHospitalDR As CTHospital [ SqlColumnNumber = 15, SqlFieldName = RTMAS_Hospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTMaster).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMaster","OnAfterDelete")

 d Table^HL7Outbound("RTMaster",%old(1),"Delete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTMaster).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMaster","OnAfterInsert")

 d Table^HL7Outbound("RTMaster",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTMaster).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMaster","OnAfterUpdate")

 d Table^HL7Outbound("RTMaster",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTMaster).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMaster","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTMaster).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMaster","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>31931</ExtentSize>
<Property name="RTMASActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RTMASCreateLocDR">
<Selectivity>7.6923%</Selectivity>
</Property>
<Property name="RTMASDateCreate">
<Selectivity>0.7498%</Selectivity>
</Property>
<Property name="RTMASExpDays">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="RTMASHomeLocDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="RTMASHospitalDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="RTMASLookUp">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="RTMASMRNo">
<Selectivity>0.0097%</Selectivity>
</Property>
<Property name="RTMASMRTypeDR">
<Selectivity>3.1250%</Selectivity>
</Property>
<Property name="RTMASPatNoDR">
<Selectivity>0.0085%</Selectivity>
</Property>
<Property name="RTMASStatus">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="RTMASTimeCreate">
<Selectivity>0.6460%</Selectivity>
</Property>
<Property name="RTMASType">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="RTMASUserCreateDR">
<Selectivity>6.2500%</Selectivity>
</Property>
<SqlIdExpression>$i(^RT(0))</SqlIdExpression>
<SQLMap name="DataMasterRTMAS">
<Data name="RTMAS_Active">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RTMAS_CreateLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RTMAS_DateCreate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RTMAS_ExpDays">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RTMAS_HomeLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RTMAS_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RTMAS_MRNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RTMAS_MRType_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RTMAS_PatNo_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RTMAS_TimeCreate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RTMAS_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RTMAS_UserCreate_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^RT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RTMAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RTMAS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHosp">
<Global>^RT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RTMAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTMAS_Hospital_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTMAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatNoDR">
<Global>^RT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RTMAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RTMAS_PatNo_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RTMAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRTMASMRNo">
<Global>^RT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RTMAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MRNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({RTMAS_MRNo})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RTMAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RTMAS_RowId</SqlRowIdName>
<StreamLocation>^User.RTMasterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
