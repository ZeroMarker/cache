/// UserAppointment(2200)
Class User.SSUserAppointment Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserAppointment, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On APPTChildsub [ IdKey, PrimaryKey, Unique ];

/// SS_User Parent Reference
Relationship APPTParRef As SSUser [ Cardinality = parent, Inverse = ChildSSUserAppointment, Required, SqlFieldName = APPT_ParRef ];

/// Childsub
Property APPTChildsub As %Float [ InitialExpression = {$i(^SSU("SSUSR",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"APPT",0))}, SqlColumnNumber = 2, SqlFieldName = APPT_Childsub ];

/// Des Ref Title
Property APPTTitleDR As CTUserAppointTitle [ SqlColumnNumber = 3, SqlFieldName = APPT_Title_DR ];

/// DateFrom
Property APPTDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = APPT_DateFrom ];

/// DateTo
Property APPTDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = APPT_DateTo ];

/// CareProvNumber
Property APPTCareProvNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = APPT_CareProvNumber ];

/// DocProvNumber
Property APPTDocProvNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = APPT_DocProvNumber ];

/// Des Ref Classification
Property APPTClassificationDR As CTPayrollClassification [ SqlColumnNumber = 8, SqlFieldName = APPT_Classification_DR ];

/// HoursPerFortnight
Property APPTHoursPerFortnight As %Float [ SqlColumnNumber = 9, SqlFieldName = APPT_HoursPerFortnight ];

/// Des Ref CostCenter
Property APPTCostCenterDR As GLCCC [ SqlColumnNumber = 10, SqlFieldName = APPT_CostCenter_DR ];

/// Discount
Property APPTDiscount As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = APPT_Discount ];

/// Comments
Property APPTComments As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = APPT_Comments ];

/// UpdateDate
Property APPTUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = APPT_UpdateDate ];

/// UpdateTime
Property APPTUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = APPT_UpdateTime ];

/// Des Ref UpdateUser
Property APPTUpdateUserDR As SSUser [ SqlColumnNumber = 15, SqlFieldName = APPT_UpdateUser_DR ];

/// Appointment Number
Property APPTAppointmentNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = APPT_AppointmentNumber ];

/// Admitting Rights
Property APPTAdmittingRights As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = APPT_AdmittingRights ];

/// Des Ref Hospital
Property APPTHospitalDR As CTHospital [ SqlColumnNumber = 18, SqlFieldName = APPT_Hospital_DR ];

/// Des Ref UpdateUserHospital
Property APPTUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 19, SqlFieldName = APPT_UpdateUserHospital_DR ];

/// Des Ref RespUnit
Property APPTRespUnitDR As CTResponsibleUnit [ SqlColumnNumber = 20, SqlFieldName = APPT_RespUnit_DR ];

/// MaxNumPatients
Property APPTMaxNumPatients As %Float [ SqlColumnNumber = 21, SqlFieldName = APPT_MaxNumPatients ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserAppointment).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserAppointment","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserAppointment).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserAppointment","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserAppointment).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserAppointment","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserAppointment).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserAppointment","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserAppointment).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserAppointment","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="APPT_AdmittingRights">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="APPT_AppointmentNumber">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="APPT_CareProvNumber">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APPT_Classification_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APPT_Comments">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="APPT_CostCenter_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="APPT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APPT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APPT_Discount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="APPT_DocProvNumber">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APPT_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="APPT_HoursPerFortnight">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APPT_MaxNumPatients">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="APPT_RespUnit_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="APPT_Title_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APPT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="APPT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="APPT_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="APPT_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>APPT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"APPT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APPT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>APPT_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserAppointmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
