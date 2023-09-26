/// PA ISD(2048)
Class User.PAISD Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_ISD, StorageStrategy = SQLStorage ]
{

/// Des Ref APPT
Property ISD1APPTDR As RBAppointment [ SqlColumnNumber = 8, SqlFieldName = ISD1_APPT_DR ];

/// Average Waiting Time
Property ISD1AverageWaitingTime As %Float [ SqlColumnNumber = 26, SqlFieldName = ISD1_AverageWaitingTime ];

/// Beds Available
Property ISD1BedsAvailable As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = ISD1_BedsAvailable ];

/// Cancelled
Property ISD1Cancelled As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = ISD1_Cancelled ];

/// Consultant Type
Property ISD1ConsultantType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ISD1_ConsultantType ];

/// DNA First Appointment
Property ISD1DNAFirstAppointment As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = ISD1_DNAFirstAppointment ];

/// DNA Return Appointment
Property ISD1DNAReturnAppointment As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = ISD1_DNAReturnAppointment ];

/// Daycase
Property ISD1Daycase As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = ISD1_Daycase ];

/// Emergency Inpatient
Property ISD1EmergencyInpatient As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = ISD1_EmergencyInpatient ];

/// Des Ref Extract
Property ISD1ExtractDR As PAISDExtract [ SqlColumnNumber = 6, SqlFieldName = ISD1_Extract_DR ];

/// First Attendance
Property ISD1FirstAttendance As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = ISD1_FirstAttendance ];

/// Des Ref Hospital
Property ISD1HospitalDR As CTHospital [ SqlColumnNumber = 2, SqlFieldName = ISD1_Hospital_DR ];

/// ISD Type
Property ISD1ISDType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = ISD1_ISDType ];

/// Inpatient
Property ISD1Inpatient As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = ISD1_Inpatient ];

/// Intented Management
Property ISD1IntentedManagement As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ISD1_IntentedManagement ];

/// Locum Clinics
Property ISD1LocumClinics As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ISD1_LocumClinics ];

/// No Held
Property ISD1NoHeld As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = ISD1_NoHeld ];

/// Others
Property ISD1Others As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ISD1_Others ];

/// Des Ref PAADM
Property ISD1PAADMDR As PAAdm [ SqlColumnNumber = 7, SqlFieldName = ISD1_PAADM_DR ];

/// Patient From Another Ward
Property ISD1PatientFromAnotherWard As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = ISD1_PatientFromAnotherWard ];

/// Reduced
Property ISD1Reduced As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = ISD1_Reduced ];

/// Return Attendance
Property ISD1ReturnAttendance As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = ISD1_ReturnAttendance ];

/// Des Ref CTLOC
Property ISD1SpecialtyDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = ISD1_Specialty_DR ];

/// Des Ref WaitListCategory
Property ISD1WaitListCategoryDR As PACWLReasonForList [ SqlColumnNumber = 4, SqlFieldName = ISD1_WaitListCategory_DR ];

/// Des Ref WaitList
Property ISD1WaitListDR As PAWaitingList [ SqlColumnNumber = 9, SqlFieldName = ISD1_WaitList_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAISD).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAISD","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAISD).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAISD","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAISD).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAISD","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAISD).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAISD","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAISD).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAISD","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAISD1(0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="ISD1_APPT_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ISD1_AverageWaitingTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ISD1_BedsAvailable">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ISD1_Cancelled">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ISD1_ConsultantType">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ISD1_DNAFirstAppointment">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ISD1_DNAReturnAppointment">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ISD1_Daycase">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ISD1_EmergencyInpatient">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ISD1_Extract_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ISD1_FirstAttendance">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ISD1_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ISD1_ISDType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ISD1_Inpatient">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ISD1_IntentedManagement">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ISD1_LocumClinics">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ISD1_NoHeld">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ISD1_Others">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ISD1_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ISD1_PatientFromAnotherWard">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ISD1_Reduced">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ISD1_ReturnAttendance">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ISD1_Specialty_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ISD1_WaitListCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ISD1_WaitList_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAISD1</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ISD1_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ISD1_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHospital">
<Global>^PAISD1i</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ISD1_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ISD1_Hospital_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ISD1_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexISDType">
<Global>^PAISD1i</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ISD1_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ISDType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ISD1_ISDType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ISD1_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSpecialty">
<Global>^PAISD1i</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ISD1_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Spec"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ISD1_Specialty_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ISD1_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ISD1_RowId</SqlRowIdName>
<StreamLocation>^User.PAISDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
