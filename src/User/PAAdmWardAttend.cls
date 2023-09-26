/// Ward Attendance(2179)
Class User.PAAdmWardAttend Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmWardAttend, StorageStrategy = SQLStorage ]
{

/// Attendance Details
Property WATAttendanceDetails As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = WAT_AttendanceDetails, SqlListType = SUBNODE ];

/// Des Ref CTCP
Property WATCTCPDR As CTCareProv [ SqlColumnNumber = 6, SqlFieldName = WAT_CTCP_DR ];

/// Des Ref CTCPType
Property WATCTCPTypeDR As CTCarPrvTp [ SqlColumnNumber = 7, SqlFieldName = WAT_CTCPType_DR ];

/// Des Ref CTLOC
Property WATCTLOCDR As CTLoc [ SqlColumnNumber = 9, SqlFieldName = WAT_CTLOC_DR ];

/// Des Ref CTLOCSeen
Property WATCTLOCSeenDR As CTLoc [ SqlColumnNumber = 18, SqlFieldName = WAT_CTLOCSeen_DR ];

/// Childsub
Property WATChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"WAT",0))}, SqlColumnNumber = 2, SqlFieldName = WAT_Childsub ];

/// Date
Property WATDate As %Date [ SqlColumnNumber = 3, SqlFieldName = WAT_Date ];

/// Date Update
Property WATDateUpdate As %Date [ SqlColumnNumber = 13, SqlFieldName = WAT_DateUpdate ];

/// First Attendance
Property WATFirstAttendance As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = WAT_FirstAttendance ];

/// Des Ref InsType
Property WATInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 16, SqlFieldName = WAT_InsType_DR ];

/// Des Ref Outcome
Property WATOutcomeDR As RBCOutcomeOfAppoint [ SqlColumnNumber = 11, SqlFieldName = WAT_Outcome_DR ];

/// PA_Adm Parent Reference
Relationship WATParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmWardAttend, Required, SqlFieldName = WAT_ParRef ];

/// Patient See In Loc
Property WATPatSeeInLoc As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = WAT_PatSeeInLoc ];

/// Time
Property WATTime As %Time [ SqlColumnNumber = 4, SqlFieldName = WAT_Time ];

/// Time Update
Property WATTimeUpdate As %Time [ SqlColumnNumber = 14, SqlFieldName = WAT_TimeUpdate ];

/// Des Ref User
Property WATUserDR As SSUser [ SqlColumnNumber = 15, SqlFieldName = WAT_User_DR ];

/// Des Ref UserHospitalUpdate
Property WATUserHospitalUpdateDR As CTHospital [ SqlColumnNumber = 17, SqlFieldName = WAT_UserHospitalUpdate_DR ];

/// Des Ref Ward
Property WATWardDR As PACWard [ SqlColumnNumber = 5, SqlFieldName = WAT_Ward_DR ];

Index RowIDBasedIDKeyIndex On WATChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 40;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmWardAttend).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmWardAttend","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmWardAttend).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmWardAttend","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmWardAttend).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmWardAttend","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmWardAttend).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmWardAttend","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmWardAttend).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmWardAttend","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>40</ExtentSize>
<Property name="WATAttendanceDetails">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATCTCPDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATCTCPTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATCTLOCSeenDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATDateUpdate">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATFirstAttendance">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="WATInsTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATOutcomeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATPatSeeInLoc">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="WATTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATTimeUpdate">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATUserHospitalUpdateDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="WATWardDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="WAT_AttendanceDetails">
<Node>"DET"</Node>
</Data>
<Data name="WAT_CTCPType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WAT_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WAT_CTLOCSeen_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="WAT_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WAT_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WAT_DateUpdate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WAT_FirstAttendance">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WAT_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WAT_Outcome_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WAT_PatSeeInLoc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WAT_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WAT_TimeUpdate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WAT_UserHospitalUpdate_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="WAT_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WAT_Ward_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>WAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>WAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WATDateTime"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WAT_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WAT_Time}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WAT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWard">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>WAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WATWard"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WAT_Ward_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WAT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WAT_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmWardAttendS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
