/// Labour New Born          (LNB,5014)
Class User.PALabourNewBorn Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_LabourNewBorn, StorageStrategy = SQLStorage ]
{

Relationship ChildPALabourNewBornCareReq As PALabourNewBornCareReq [ Cardinality = children, Inverse = IMCParRef ];

Relationship ChildPALabourNewBornProcedures As PALabourNewBornProcedures [ Cardinality = children, Inverse = PROCParRef ];

/// PA_AdmLab Parent Reference
Relationship LNBALBParRef As PAAdmLab [ Cardinality = parent, Inverse = ChildPALabourNewBorn, Required, SqlFieldName = LNB_ALB_ParRef ];

/// Abnormal Details
Property LNBAbnormalDetails As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = LNB_AbnormalDetails, SqlListType = SUBNODE ];

/// Abnormalities
Property LNBAbnormalities As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = LNB_Abnormalities ];

/// Apgar Score after 1 min
Property LNBApgarScore1min As PACApgarScore [ SqlColumnNumber = 14, SqlFieldName = LNB_ApgarScore1min ];

/// Apgar Score after 5 min
Property LNBApgarScore5min As PACApgarScore [ SqlColumnNumber = 15, SqlFieldName = LNB_ApgarScore5min ];

/// Des Ref Baby Discharged To
Property LNBBabyDischargedToDR As PACBabyDischargedTo [ SqlColumnNumber = 31, SqlFieldName = LNB_BabyDischargedTo_DR ];

/// Newborn No.
Property LNBBirthOrderNumber As %Float [ SqlColumnNumber = 3, SqlFieldName = LNB_BirthOrderNumber ];

/// Birth Weight
Property LNBBirthWeight As %Float [ SqlColumnNumber = 11, SqlFieldName = LNB_Birth_Weight ];

/// ChildSub
Property LNBChildSub As %Float [ InitialExpression = {$i(^PAADM($P($s($d(initvalue):initvalue,1:%d(0)),"||",1),"ALB",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"LNB",0))}, SqlColumnNumber = 2, SqlFieldName = LNB_ChildSub ];

/// Crown Heel
Property LNBCrownHeel As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = LNB_CrownHeel ];

/// Defecation
Property LNBDefecation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = LNB_Defecation ];

/// Des REf DelivMethod
Property LNBDelivMethodDR As PACDeliveryMethod [ SqlColumnNumber = 27, SqlFieldName = LNB_DelivMethod_DR ];

/// Delivery Date
Property LNBDeliveryDate As %Date [ SqlColumnNumber = 12, SqlFieldName = LNB_DeliveryDate ];

/// Discharge Weight
Property LNBDischargeWeight As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = LNB_DischargeWeight ];

/// Des Ref Feed On Discharge
Property LNBFeedOnDischargeDR As PACFeedOnDischarge [ SqlColumnNumber = 32, SqlFieldName = LNB_FeedOnDischarge_DR ];

/// Grade of Danger of Cord Neck
Property LNBGradeDangCordNeck As %Float [ SqlColumnNumber = 20, SqlFieldName = LNB_GradeDangCordNeck ];

/// Healthy Flag
Property LNBHealthy As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = LNB_Healthy ];

/// Des Ref Hpoglycaemia
Property LNBHpoglycaemiaDR As PACHpoglycaemia [ SqlColumnNumber = 36, SqlFieldName = LNB_Hpoglycaemia_DR ];

/// Immed Care Req Des Ref to PacImmedCareReq
Property LNBImmedCareReqDR As PACImmedCareRequired [ SqlColumnNumber = 21, SqlFieldName = LNB_ImmedCareReq_DR ];

/// Intrauterine Death
Property LNBIntrauterineDeath As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = LNB_IntrauterineDeath ];

/// Des Ref Jaundice
Property LNBJaundiceDR As PACJaundice [ SqlColumnNumber = 33, SqlFieldName = LNB_Jaundice_DR ];

/// Lowest Glucose
Property LNBLowestGlucose As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = LNB_LowestGlucose ];

/// Des Ref Maconium Stain
Property LNBMaconiumStainDR As PACMaconiumStain [ SqlColumnNumber = 19, SqlFieldName = LNB_MaconiumStain_DR ];

/// Des Ref ManagementOfAbortion
Property LNBManagementOfAbortionDR As PACManagementOfAbortion [ SqlColumnNumber = 40, SqlFieldName = LNB_ManagementOfAbortion_DR ];

/// Max billrubin
Property LNBMaxbillrubin As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = LNB_Maxbillrubin ];

/// Occipito Frontal Circumference
Property LNBOccipitoFrontalCircumference As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = LNB_OccipitoFrontalCircumference ];

/// Des Ref Outcome Of Pregnancy
Property LNBOutcomeOfPregnancyDR As PACOutcomeOfPregnancy [ SqlColumnNumber = 28, SqlFieldName = LNB_OutcomeOfPregnancy_DR ];

/// Des Ref To PAADM
Property LNBPAADMDR As PAAdm [ SqlColumnNumber = 8, SqlFieldName = LNB_PAADM_DR ];

/// Des Ref Phototherapy
Property LNBPhototherapyDR As PACPhototherapy [ SqlColumnNumber = 34, SqlFieldName = LNB_Phototherapy_DR ];

/// Des Ref Present
Property LNBPresentDR As PACPresentation [ SqlColumnNumber = 26, SqlFieldName = LNB_Present_DR ];

/// Respiration Des Ref to PacResp
Property LNBRespirationDR As PACRespiration [ SqlColumnNumber = 16, SqlFieldName = LNB_Respiration_DR ];

/// Des Ref to CTSex
Property LNBSexDR As CTSex [ SqlColumnNumber = 10, SqlFieldName = LNB_Sex_DR ];

/// Time to reach Apgar7
Property LNBTimeApgar7 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = LNB_TimeApgar7 ];

/// Time of Birth
Property LNBTimeOfBirth As %Time [ SqlColumnNumber = 7, SqlFieldName = LNB_TimeOfBirth ];

/// Des Ref TypeOfAbortion
Property LNBTypeOfAbortionDR As PACTypeOfAbortion [ SqlColumnNumber = 39, SqlFieldName = LNB_TypeOfAbortion_DR ];

/// Urination
Property LNBUrination As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = LNB_Urination ];

Index RowIDBasedIDKeyIndex On LNBChildSub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 22;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PALabourNewBorn).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PALabourNewBorn","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PALabourNewBorn).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PALabourNewBorn","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PALabourNewBorn).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PALabourNewBorn","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PALabourNewBorn).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PALabourNewBorn","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PALabourNewBorn).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PALabourNewBorn","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>22</ExtentSize>
<Property name="LNBALBParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBAbnormalDetails">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBAbnormalities">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="LNBApgarScore1min">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBApgarScore5min">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBBabyDischargedToDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBBirthOrderNumber">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBBirthWeight">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBChildSub">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBCrownHeel">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBDefecation">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="LNBDelivMethodDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBDeliveryDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBDischargeWeight">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBFeedOnDischargeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBGradeDangCordNeck">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBHealthy">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="LNBHpoglycaemiaDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBImmedCareReqDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBIntrauterineDeath">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="LNBJaundiceDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBLowestGlucose">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBMaconiumStainDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBManagementOfAbortionDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBMaxbillrubin">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBOccipitoFrontalCircumference">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBOutcomeOfPregnancyDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBPAADMDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBPhototherapyDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBPresentDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBRespirationDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBSexDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBTimeApgar7">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBTimeOfBirth">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBTypeOfAbortionDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LNBUrination">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMasterMapLNB">
<Data name="LNB_AbnormalDetails">
<Node>"DET"</Node>
</Data>
<Data name="LNB_Abnormalities">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LNB_ApgarScore1min">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LNB_ApgarScore5min">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LNB_BabyDischargedTo_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="LNB_BirthOrderNumber">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LNB_Birth_Weight">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LNB_CrownHeel">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="LNB_Defecation">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="LNB_DelivMethod_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="LNB_DeliveryDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LNB_DischargeWeight">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="LNB_FeedOnDischarge_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="LNB_GradeDangCordNeck">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="LNB_Healthy">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="LNB_Hpoglycaemia_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="LNB_ImmedCareReq_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="LNB_IntrauterineDeath">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="LNB_Jaundice_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="LNB_LowestGlucose">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="LNB_MaconiumStain_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="LNB_ManagementOfAbortion_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="LNB_Maxbillrubin">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="LNB_OccipitoFrontalCircumference">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="LNB_OutcomeOfPregnancy_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="LNB_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LNB_Phototherapy_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="LNB_Present_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="LNB_Respiration_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="LNB_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LNB_TimeApgar7">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="LNB_TimeOfBirth">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LNB_TypeOfAbortion_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="LNB_Urination">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_AdmLab.ALB_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>LNB_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PA_Adm.PAADM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ALB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PA_AdmLab.ALB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"LNB"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{LNB_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LNB_RowID</SqlRowIdName>
<StreamLocation>^User.PALabourNewBornS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
