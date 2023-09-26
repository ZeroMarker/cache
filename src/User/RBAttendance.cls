/// Attendance(2761)
Class User.RBAttendance Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_Attendance, StorageStrategy = SQLStorage ]
{

/// Date
Property ATTDate As %Date [ SqlColumnNumber = 2, SqlFieldName = ATT_Date ];

/// Time
Property ATTTime As %Time [ SqlColumnNumber = 3, SqlFieldName = ATT_Time ];

/// Outcome
Property ATTOutcome As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ATT_Outcome ];

/// Des Ref Payor
Property ATTPayorDR As ARCInsuranceType [ SqlColumnNumber = 5, SqlFieldName = ATT_Payor_DR ];

/// Des Ref Plan
Property ATTPlanDR As ARCAuxilInsurType [ SqlColumnNumber = 6, SqlFieldName = ATT_Plan_DR ];

/// Comments
Property ATTComments As list Of %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ATT_Comments, SqlListType = SUBNODE ];

/// FirstAttendance
Property ATTFirstAttendance As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ATT_FirstAttendance ];

/// Des Ref CancelReason
Property ATTCancelReasonDR As RBCReasonForCancel [ SqlColumnNumber = 9, SqlFieldName = ATT_CancelReason_DR ];

/// Priority
Property ATTPriority As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ATT_Priority ];

/// UpdateDate
Property ATTUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = ATT_UpdateDate ];

/// UpdateTime
Property ATTUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = ATT_UpdateTime ];

/// Des Ref UpdateUser
Property ATTUpdateUserDR As SSUser [ SqlColumnNumber = 13, SqlFieldName = ATT_UpdateUser_DR ];

/// Des Ref UpdateHospital
Property ATTUpdateHospitalDR As CTHospital [ SqlColumnNumber = 14, SqlFieldName = ATT_UpdateHospital_DR ];

/// Des Ref PAAdm
Property ATTPAAdmDR As PAAdm [ SqlColumnNumber = 15, SqlFieldName = ATT_PAAdm_DR ];

/// Des Ref PAPMI
Property ATTPAPMIDR As PAPatMas [ SqlColumnNumber = 16, SqlFieldName = ATT_PAPMI_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBAttendance).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAttendance","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBAttendance).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAttendance","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBAttendance).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAttendance","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBAttendance).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAttendance","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBAttendance).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAttendance","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAttendance","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>11</ExtentSize>
<Property name="ATTCancelReasonDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ATTComments">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ATTDate">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ATTFirstAttendance">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ATTOutcome">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ATTPAAdmDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ATTPAPMIDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ATTPayorDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ATTPlanDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ATTPriority">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ATTTime">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="ATTUpdateDate">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ATTUpdateHospitalDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ATTUpdateTime">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="ATTUpdateUserDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^RBAT(0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="ATT_CancelReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ATT_Comments">
<Node>"CMT"</Node>
</Data>
<Data name="ATT_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ATT_FirstAttendance">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ATT_Outcome">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ATT_PAAdm_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ATT_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ATT_Payor_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ATT_Plan_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ATT_Priority">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ATT_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ATT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ATT_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ATT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ATT_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^RBAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ATT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ATT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^RBATi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ATT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ATT_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ATT_Time}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ATT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutcome">
<Global>^RBATi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ATT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Outcome"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ATT_Outcome}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ATT_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ATT_Time}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ATT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^RBATi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ATT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ATT_PAAdm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ATT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMI">
<Global>^RBATi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ATT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ATT_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ATT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ATT_RowId</SqlRowIdName>
<StreamLocation>^User.RBAttendanceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
