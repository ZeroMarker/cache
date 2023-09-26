/// Patient Alert Messge      (ALM,100)
Class User.PAAlertMsg Extends (%Persistent, User.Abstract) [ ClassType = persistent, CompileAfter = User.PAPatMas, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AlertMsg, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 446;

Index RowIDBasedIDKeyIndex On ALMChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to PAPMI
Relationship ALMPAPMIParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPAAlertMsg, Required, SqlFieldName = ALM_PAPMI_ParRef ];

/// Alert Message ChildSub
Property ALMChildSub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"ALM",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ALM_ChildSub ];

/// Patient Message
Property ALMMessage As list Of %String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ALM_Message, SqlListType = SUBNODE ];

/// Action
Property ALMActionTaken As list Of %String(COLLATION = "AlphaUp", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ALM_ActionTaken, SqlListType = SUBNODE ];

/// Date Viewed
Property ALMViewDate As %Date [ SqlColumnNumber = 11, SqlFieldName = ALM_ViewDate ];

/// Time Viewed
Property ALMViewTime As %Time [ SqlColumnNumber = 12, SqlFieldName = ALM_ViewTime ];

/// User ID View
Property ALMViewUserId As SSUser [ SqlColumnNumber = 13, SqlFieldName = ALM_ViewUserId ];

/// Closed Flag
Property ALMClosedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 14, SqlFieldName = ALM_ClosedFlag ];

/// Message 1st line
Property ALMMess1 As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlComputeCode = { s {ALM_Mess_1}=$li({ALM_Message},1)
}, SqlComputed, SqlFieldName = ALM_Mess_1, Transient ];

/// Date Created
Property ALMCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 18, SqlFieldName = ALM_CreateDate ];

/// Time Created
Property ALMCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 19, SqlFieldName = ALM_CreateTime ];

/// User Created
Property ALMCreateUser As SSUser [ SqlColumnNumber = 20, SqlFieldName = ALM_CreateUser ];

/// Des Ref Alert
Property ALMAlertDR As PACPatientAlert [ SqlColumnNumber = 21, SqlFieldName = ALM_Alert_DR ];

/// Review Date
Property ALMReviewDate As %Date [ SqlColumnNumber = 22, SqlFieldName = ALM_ReviewDate ];

/// Expiry Date
Property ALMExpiryDate As %Date [ SqlColumnNumber = 23, SqlFieldName = ALM_ExpiryDate ];

/// Des Ref ExpiryReason
Property ALMExpiryReasonDR As PACAlertExpiryReason [ SqlColumnNumber = 24, SqlFieldName = ALM_ExpiryReason_DR ];

/// Onset Date
Property ALMOnsetDate As %Date [ SqlColumnNumber = 25, SqlFieldName = ALM_OnsetDate ];

/// Onset Time
Property ALMOnsetTime As %Time [ SqlColumnNumber = 26, SqlFieldName = ALM_OnsetTime ];

/// Closed Date
Property ALMClosedDate As %Date [ SqlColumnNumber = 27, SqlFieldName = ALM_ClosedDate ];

/// Closed Time
Property ALMClosedTime As %Time [ SqlColumnNumber = 28, SqlFieldName = ALM_ClosedTime ];

/// Des Ref LastUpdateHospital
Property ALMLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 29, SqlFieldName = ALM_LastUpdateHospital_DR ];

/// Status
Property ALMStatus As %String(DISPLAYLIST = ",Active,Inactive,ToBeConfirmed", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",A,I,C") [ SqlColumnNumber = 30, SqlFieldName = ALM_Status ];

/// ExternalID
Property ALMExternalID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = ALM_ExternalID ];

/// Des Ref AlertCategory
Property ALMAlertCategoryDR As PACAlertCategory [ SqlColumnNumber = 32, SqlFieldName = ALM_AlertCategory_DR ];

/// DSReportFlag
Property ALMDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = ALM_DSReportFlag ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAlertMsg).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAlertMsg","OnAfterDelete")
 d Table^HL7Outbound("PAAlertMsg",%old(1),"Delete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAlertMsg).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAlertMsg","OnAfterInsert")
 d Table^HL7Outbound("PAAlertMsg",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAlertMsg).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAlertMsg","OnAfterUpdate")
 d Table^HL7Outbound("PAAlertMsg",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAlertMsg).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAlertMsg","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAlertMsg).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAlertMsg","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterMapALM">
<Data name="ALM_ActionTaken">
<Node>"ACT"</Node>
</Data>
<Data name="ALM_AlertCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ALM_Alert_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ALM_ClosedDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ALM_ClosedFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ALM_ClosedTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ALM_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ALM_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ALM_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ALM_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ALM_ExpiryDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ALM_ExpiryReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ALM_ExternalID">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ALM_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ALM_Mess_1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ALM_Message">
<Node>"MSG"</Node>
</Data>
<Data name="ALM_OnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ALM_OnsetTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ALM_ReviewDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ALM_Status">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ALM_ViewDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALM_ViewTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ALM_ViewUserId">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ALM_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ALM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ALM_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexClosedFlag">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ALM_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ALM_CloseFlag"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ALM_ClosedFlag}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ALM_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ALM_RowId</SqlRowIdName>
<StreamLocation>^User.PAAlertMsgS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
