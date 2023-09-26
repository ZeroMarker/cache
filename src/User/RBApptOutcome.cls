/// RB Appoint Outcome(1962)
Class User.RBApptOutcome Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ApptOutcome, StorageStrategy = SQLStorage ]
{

/// Des Ref Appt Outcome
Property OUTCApOutcomeDR As RBCOutcomeOfAppoint [ SqlColumnNumber = 3, SqlFieldName = OUTC_ApOutcome_DR ];

/// Childsub
Property OUTCChildsub As %Float [ InitialExpression = {$i(^RBAS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"APPT",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"OUTC",0))}, SqlColumnNumber = 2, SqlFieldName = OUTC_Childsub ];

/// Date
Property OUTCDate As %Date [ SqlColumnNumber = 4, SqlFieldName = OUTC_Date ];

/// Des Ref LastUpdateHospital
Property OUTCLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 7, SqlFieldName = OUTC_LastUpdateHospital_DR ];

/// RB_Appointment Parent Reference
Relationship OUTCParRef As RBAppointment [ Cardinality = parent, Inverse = ChildRBApptOutcome, Required, SqlFieldName = OUTC_ParRef ];

/// Time
Property OUTCTime As %Time [ SqlColumnNumber = 5, SqlFieldName = OUTC_Time ];

/// Des Ref User
Property OUTCUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = OUTC_User_DR ];

Index RowIDBasedIDKeyIndex On OUTCChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 215;

Storage SQLStorage
{
<ExtentSize>215</ExtentSize>
<Property name="OUTCApOutcomeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="OUTCChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="OUTCDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="OUTCLastUpdateHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="OUTCParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="OUTCTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="OUTCUserDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="OUTC_ApOutcome_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OUTC_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OUTC_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OUTC_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OUTC_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^RBAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>RB_Appointment.APPT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L6}</Expression>
<Field>OUTC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"APPT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_Appointment.APPT_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"OUTC"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OUTC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OUTC_RowId</SqlRowIdName>
<StreamLocation>^User.RBApptOutcomeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
