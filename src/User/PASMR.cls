/// PA SMR(2005)
Class User.PASMR Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_SMR, StorageStrategy = SQLStorage ]
{

/// Des Ref PAADM
Property SMRPAADMDR As PAAdm [ SqlColumnNumber = 2, SqlFieldName = SMR_PAADM_DR ];

/// Des Ref Appointment
Property SMRAppointmentDR As RBAppointment [ SqlColumnNumber = 3, SqlFieldName = SMR_Appointment_DR ];

/// Des Ref WaitList
Property SMRWaitListDR As PAWaitingList [ SqlColumnNumber = 4, SqlFieldName = SMR_WaitList_DR ];

/// Status
Property SMRStatusDR As PACSMRStatus [ SqlColumnNumber = 5, SqlFieldName = SMR_Status_DR ];

/// Des Ref SMR Batch
Property SMRBatchDR As PASMRBatch [ SqlColumnNumber = 8, SqlFieldName = SMR_Batch_DR ];

/// Des Ref AdmCoding
Property SMRAdmCodingDR As PAAdmCoding [ SqlColumnNumber = 10, SqlFieldName = SMR_AdmCoding_DR ];

/// isdref
Property SMRisdref As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = SMR_isdref ];

/// Des Ref Extract
Property SMRExtractDR As PASMRExtract [ SqlColumnNumber = 12, SqlFieldName = SMR_Extract_DR ];

/// Validation Status
Property SMRValidationStatus As %String(DISPLAYLIST = ",Awaiting validation,Errors found,Queries found,Queries and errors found,Ready to generate SMR record,SMR record submitted to ISD", MAXLEN = 28, TRUNCATE = 1, VALUELIST = ",A,E,Q,EQ,V,S") [ SqlColumnNumber = 13, SqlFieldName = SMR_ValidationStatus ];

/// Des Ref ExtractBuild
Property SMRExtractBuildDR As PASMRExtractBuild [ SqlColumnNumber = 14, SqlFieldName = SMR_ExtractBuild_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PASMR).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMR","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PASMR).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMR","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PASMR).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMR","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PASMR).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMR","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMR","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PASMR).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMR","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PASMR(0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="SMR_AdmCoding_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SMR_Appointment_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SMR_Batch_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SMR_ExtractBuild_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SMR_Extract_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SMR_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SMR_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SMR_ValidationStatus">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SMR_WaitList_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SMR_isdref">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PASMR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SMR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SMR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmCoding">
<Global>^PASMRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SMR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMR_Status_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMR_AdmCoding_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAppointment">
<Global>^PASMRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SMR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Appoint"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMR_Status_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMR_Appointment_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBatch">
<Global>^PASMRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>SMR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Batch"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMR_Batch_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExtBuildAp">
<Global>^PASMRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SMR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ExtrBuildAp"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMR_ExtractBuild_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMR_Appointment_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExtrBuild">
<Global>^PASMRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>SMR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ExtrBuild"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMR_ExtractBuild_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExtractBuild">
<Global>^PASMRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SMR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ExtractBuild"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMR_ExtractBuild_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMR_AdmCoding_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^PASMRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SMR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMR_Status_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMR_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADm1">
<Global>^PASMRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SMR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAADM1"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMR_PAADM_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMR_ExtractBuild_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^PASMRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>SMR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Stat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMR_Status_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWaitList">
<Global>^PASMRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SMR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WaitList"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMR_Status_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMR_WaitList_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SMR_RowId</SqlRowIdName>
<StreamLocation>^User.PASMRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
