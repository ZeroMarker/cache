/// PregDelBaby(2232)
Class User.PAPregDelBaby Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PregDelBaby, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On BABYChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPAPrDelBabyCongAnom As PAPrDelBabyCongAnom [ Cardinality = children, Inverse = CAParRef ];

Relationship ChildPAPrDelBabyNeoMorb As PAPrDelBabyNeoMorb [ Cardinality = children, Inverse = PDBNMParRef ];

Relationship ChildPAPrDelBabyResusMthd As PAPrDelBabyResusMthd [ Cardinality = children, Inverse = PDBRMParRef ];

Relationship ChildPAPrDelBabyDelMthd As PAPrDelBabyDelMthd [ Cardinality = children, Inverse = PDBDMParRef ];

Relationship ChildPAPrDelBabyApgarScore As PAPrDelBabyApgarScore [ Cardinality = children, Inverse = PDBASParRef ];

/// PA_PregDelivery Parent Reference
Relationship BABYParRef As PAPregDelivery [ Cardinality = parent, Inverse = ChildPAPregDelBaby, Required, SqlFieldName = BABY_ParRef ];

/// Childsub
Property BABYChildsub As %Float [ InitialExpression = {$i(^PAPRG($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DEL",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"BABY",0))}, SqlColumnNumber = 2, SqlFieldName = BABY_Childsub ];

/// Birth Order Number
Property BABYBirthOrderNumber As %Float [ SqlColumnNumber = 3, SqlFieldName = BABY_BirthOrderNumber ];

/// Time of birth
Property BABYTimeOfBirth As %Time [ SqlColumnNumber = 4, SqlFieldName = BABY_TimeOfBirth ];

/// Des ref CTSex
Property BABYSexDR As CTSex [ SqlColumnNumber = 5, SqlFieldName = BABY_Sex_DR ];

/// Birth Weight
Property BABYBirthWeigth As %Float [ SqlColumnNumber = 6, SqlFieldName = BABY_BirthWeigth ];

/// Birth Date
Property BABYBirthDate As %Date [ SqlColumnNumber = 7, SqlFieldName = BABY_BirthDate ];

/// Baby Abnormalities
Property BABYAbnormalities As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = BABY_Abnormalities ];

/// Apgar score at 1 min Des res PAC_ApgarScore
Property BABYApgarScore1minDR As PACApgarScore [ SqlColumnNumber = 9, SqlFieldName = BABY_ApgarScore1min_DR ];

/// Apgar score at 5 min Des ref PAC_ApgarScore
Property BABYApgarScore5minDR As PACApgarScore [ SqlColumnNumber = 10, SqlFieldName = BABY_ApgarScore5min_DR ];

/// Urination
Property BABYUrination As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = BABY_Urination ];

/// Defecation
Property BABYDefecation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = BABY_Defecation ];

/// Des Ref PAC_MaconiumStain
Property BABYMaconiumStainDR As PACMaconiumStain [ SqlColumnNumber = 13, SqlFieldName = BABY_MaconiumStain_DR ];

/// Des Ref PAC_Presentation
Property BABYPresentation As PACPresentation [ SqlColumnNumber = 14, SqlFieldName = BABY_Presentation ];

/// Des Ref PAC_OutcomeOfPregnancy
Property BABYOutcomeDR As PACOutcomeOfPregnancy [ SqlColumnNumber = 15, SqlFieldName = BABY_Outcome_DR ];

/// Operative Delivery Indication
Property BABYOpDelIndicationDR As PACOpDelivIndication [ SqlColumnNumber = 16, SqlFieldName = BABY_OpDelIndication_DR ];

/// Occipito Frontal Circumference
Property BABYOccipitoFrontalCircum As %Float [ SqlColumnNumber = 17, SqlFieldName = BABY_OccipitoFrontalCircum ];

/// Discharge weight
Property BABYDischargeWeight As %Float [ SqlColumnNumber = 18, SqlFieldName = BABY_DischargeWeight ];

/// Gestation weeks
Property BABYGestationWeeks As %Float [ SqlColumnNumber = 19, SqlFieldName = BABY_GestationWeeks ];

/// Gestation Days
Property BABYGestationDays As %Float [ SqlColumnNumber = 20, SqlFieldName = BABY_GestationDays ];

/// Des ref PAC_CertaintyOfGestation
Property BabyCertOfGestationDR As PACCertaintyOfGestation [ SqlColumnNumber = 21, SqlFieldName = Baby_CertOfGestation_DR ];

/// Des Ref PAC_DeliveryPlace
Property BABYActualDelivPlaceDR As PACDeliveryPlace [ SqlColumnNumber = 22, SqlFieldName = BABY_ActualDelivPlace_DR ];

/// Actual Delivery place other
Property BABYActualDelivPlaceOth As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = BABY_ActualDelivPlaceOth ];

/// Des Ref PAC_BirthPlaceChangeWhen
Property BABYBirthPlaceChangeWhenDR As PACBirthPlaceChangeWhen [ SqlColumnNumber = 24, SqlFieldName = BABY_BirthPlaceChangeWhen_DR ];

/// Breast Fed
Property BABYBreastFed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = BABY_BreastFed ];

/// Artificially Fed
Property BABYArtificiallyFed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = BABY_ArtificiallyFed ];

/// DR Formula Type
Property BABYFormulaTypeDR As PACFormulaType [ SqlColumnNumber = 27, SqlFieldName = BABY_FormulaType_DR ];

/// Baby Length at Birth
Property BABYBirthLength As %Float [ SqlColumnNumber = 28, SqlFieldName = BABY_BirthLength ];

/// Apgar score time extra 1
Property BABYApgarTime3 As %Float [ SqlColumnNumber = 29, SqlFieldName = BABY_ApgarTime3 ];

/// Apgar Score extra 1 Des Ref Apgar Score
Property BABYApgarScore3DR As PACApgarScore [ SqlColumnNumber = 30, SqlFieldName = BABY_ApgarScore3_DR ];

/// Apgar Score extra 2
Property BABYApgarTime4 As %Float [ SqlColumnNumber = 31, SqlFieldName = BABY_ApgarTime4 ];

/// Apgar score extra 2 Des Ref Apgar Score
Property BABYApgarScore4DR As PACApgarScore [ SqlColumnNumber = 32, SqlFieldName = BABY_ApgarScore4_DR ];

/// Time to estblsh resprtn PAC_Respiration
Property BABYTimeToEstRespirationDR As PACRespiration [ SqlColumnNumber = 33, SqlFieldName = BABY_TimeToEstRespiration_DR ];

/// Vitamin K given
Property BABYVitKGiven As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = BABY_VitKGiven ];

/// Date newborn screening test done
Property BABYNewbornScrnTestDate As %Date [ SqlColumnNumber = 35, SqlFieldName = BABY_NewbornScrnTestDate ];

/// Time newborn screen test done
Property BABYNewbornScrnTestTime As %Time [ SqlColumnNumber = 36, SqlFieldName = BABY_NewbornScrnTestTime ];

/// Hepatitis B vaccine given
Property BABYHepBGiven As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = BABY_HepBGiven ];

/// Hepatitis B vaccine refused
Property BABYHepBRefused As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = BABY_HepBRefused ];

/// When FDIU was diagnosed
Property BABYFdiuDiagnosis As PACFdiuDiagnosis [ SqlColumnNumber = 39, SqlFieldName = BABY_FdiuDiagnosis ];

/// Date of neonatal death
Property BABYNndDate As %Date [ SqlColumnNumber = 40, SqlFieldName = BABY_NndDate ];

/// Time of neonatal death
Property BABYNndTime As %Time [ SqlColumnNumber = 41, SqlFieldName = BABY_NndTime ];

/// Des Ref Liquor Colour
Property BABYLiquorColorDR As PACLiquorColour [ SqlColumnNumber = 42, SqlFieldName = BABY_LiquorColor_DR ];

/// Delivery Doctor Des Ref CT_CareProv
Property BABYDeliveryDoctorDR As CTCareProv [ SqlColumnNumber = 43, SqlFieldName = BABY_DeliveryDoctor_DR ];

/// Delivery midwife Des ref CT_CareProv
Property BABYDeliveryMidwifeDR As CTCareProv [ SqlColumnNumber = 44, SqlFieldName = BABY_DeliveryMidwife_DR ];

/// Moulding
Property BABYMoulding As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = BABY_Moulding ];

/// Caput
Property BABYCaput As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 46, SqlFieldName = BABY_Caput ];

/// Accoucheur 1 Des Ref CT_CareProv
Property BABYAccoucheur1DR As CTCareProv [ SqlColumnNumber = 47, SqlFieldName = BABY_Accoucheur1_DR ];

/// Accoucheur 2 Des ref CT_CareProv
Property BABYAccoucheur2DR As CTCareProv [ SqlColumnNumber = 48, SqlFieldName = BABY_Accoucheur2_DR ];

/// Receiver 1 Des ref CT_CareProv
Property BABYReceiver1DR As CTCareProv [ SqlColumnNumber = 49, SqlFieldName = BABY_Receiver1_DR ];

/// Receiver 2 Des Ref CT_CareProv
Property BABYReceiver2DR As CTCareProv [ SqlColumnNumber = 50, SqlFieldName = BABY_Receiver2_DR ];

/// Other staff registration number
Property BABYOtherStaffReg As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = BABY_OtherStaffReg ];

/// Des ref PAC_Respiration
Property BABYFirstRespirationDR As PACRespiration [ SqlColumnNumber = 52, SqlFieldName = BABY_FirstRespiration_DR ];

/// Membranes rupture date
Property BABYMembRuptureDate As %Date [ SqlColumnNumber = 53, SqlFieldName = BABY_MembRuptureDate ];

/// Membrane rupture time
Property BABYMembRuptureTime As %Time [ SqlColumnNumber = 54, SqlFieldName = BABY_MembRuptureTime ];

/// Other delivery methods
Property BABYOthDelMthd As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 55, SqlFieldName = BABY_OthDelMthd, SqlListType = SUBNODE ];

/// Other resuscitation methods
Property BABYOthResusMth As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 56, SqlFieldName = BABY_OthResusMth, SqlListType = SUBNODE ];

/// Other congenital anomalies
Property BABYOthCongAnom As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 57, SqlFieldName = BABY_OthCongAnom, SqlListType = SUBNODE ];

/// Other Neonatal morbidity
Property BABYOthNeoMorb As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 58, SqlFieldName = BABY_OthNeoMorb, SqlListType = SUBNODE ];

/// Des Ref PAC_NeonatalIndicator
Property BABYNeonatalIndicatorDR As PACNeonatalIndicator [ SqlColumnNumber = 59, SqlFieldName = BABY_NeonatalIndicator_DR ];

/// Reason for Death
Property BABYReasonDeath As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 60, SqlFieldName = BABY_ReasonDeath, SqlListType = SUBNODE ];

/// Positon of baby DR PAC_BabyPosition
Property BABYPositionDR As PACBabyPosition [ SqlColumnNumber = 61, SqlFieldName = BABY_Position_DR ];

/// Baby Alive
Property BABYAlive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 62, SqlFieldName = BABY_Alive ];

/// Position adopted by mother
Property BABYMotherPositionDR As PACMaternalPosition [ SqlColumnNumber = 63, SqlFieldName = BABY_MotherPosition_DR ];

/// Flying squad
Property BABYFlyingSquad As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 64, SqlFieldName = BABY_FlyingSquad ];

/// Decision Maker DR PACDelDecisionMaker
Property BABYDecisionMakerDR As PACDelDecisionMaker [ SqlColumnNumber = 65, SqlFieldName = BABY_DecisionMaker_DR ];

/// Cord pH Venous
Property BABYCordPHVenous As %Float [ SqlColumnNumber = 66, SqlFieldName = BABY_CordPHVenous ];

/// Cord pH Arterial
Property BABYCordPHArterial As %Float [ SqlColumnNumber = 67, SqlFieldName = BABY_CordPHArterial ];

/// Cord Blood - Base Excess
Property BABYCordBldBaseExcess As %Float [ SqlColumnNumber = 68, SqlFieldName = BABY_CordBldBaseExcess ];

/// Cord Blood Lactate
Property BABYCordBldLactate As %Float [ SqlColumnNumber = 69, SqlFieldName = BABY_CordBldLactate ];

/// Cord Blood Sent as Rh Negative
Property BABYCordBldSentRhNeg As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 70, SqlFieldName = BABY_CordBldSentRhNeg ];

/// Cord Blood Sent - Other
Property BABYCordBldSentOther As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 71, SqlFieldName = BABY_CordBldSentOther ];

/// Other Cord Details
Property BABYOthCordDetails As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 72, SqlFieldName = BABY_OthCordDetails, SqlListType = SUBNODE ];

/// Skin to Skin Contact
Property BABYSkinToSkinContactDR As PACSkinToSkinContact [ SqlColumnNumber = 73, SqlFieldName = BABY_SkinToSkinContact_DR ];

/// Resusciated By
Property BABYResusciatedByDR As CTCareProv [ SqlColumnNumber = 74, SqlFieldName = BABY_ResusciatedBy_DR ];

/// Cord Vessels
Property BABYCordVesselsDR As PACCordVessels [ SqlColumnNumber = 75, SqlFieldName = BABY_CordVessels_DR ];

/// True Knot
Property BABYTrueKnot As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 76, SqlFieldName = BABY_TrueKnot ];

/// Cord Round Neck
Property BABYCordRoundNeck As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 77, SqlFieldName = BABY_CordRoundNeck ];

/// Cord Insertion
Property BABYCordInsertionDR As PACCordInsertion [ SqlColumnNumber = 78, SqlFieldName = BABY_CordInsertion_DR ];

/// Membranes
Property BABYMembranesDR As PACMembCond [ SqlColumnNumber = 79, SqlFieldName = BABY_Membranes_DR ];

/// Outcome Free Text
Property BABYOutcomeFreeText As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 80, SqlFieldName = BABY_OutcomeFreeText, SqlListType = SUBNODE ];

/// Birth Date Approximate Flag
Property BABYBirthDateAprxFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 81, SqlFieldName = BABY_BirthDateAprxFlag ];

/// Operative Delivery Indication Free Text
Property BABYOpDelIndicationText As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 82, SqlFieldName = BABY_OpDelIndicationText, SqlListType = SUBNODE ];

/// Presentation Free Text
Property BABYPresentationText As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 83, SqlFieldName = BABY_PresentationText, SqlListType = SUBNODE ];

/// Skin to Skin Contact Free Text
Property BABYSkinToSkinContactText As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 84, SqlFieldName = BABY_SkinToSkinContactText, SqlListType = SUBNODE ];

/// Des Ref PAPerson
Property BABYPersonDR As PAPerson [ SqlColumnNumber = 85, SqlFieldName = BABY_Person_DR ];

/// Last Update User
Property BABYUpdateUser As SSUser [ SqlColumnNumber = 86, SqlFieldName = BABY_UpdateUser ];

/// Last Update Date
Property BABYUpdateDate As %Date [ SqlColumnNumber = 87, SqlFieldName = BABY_UpdateDate ];

/// Last Update Time
Property BABYUpdateTime As %Time [ SqlColumnNumber = 88, SqlFieldName = BABY_UpdateTime ];

/// Last update hospital
Property BABYUpdateHospitalDR As CTHospital [ SqlColumnNumber = 89, SqlFieldName = BABY_UpdateHospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPregDelBaby).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelBaby","OnAfterDelete")
 d PrepareForCG^CPAPreg($g(%d(1)),"D")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPregDelBaby).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelBaby","OnAfterInsert")
 d PrepareForCG^CPAPreg($g(%d(1)),"I")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPregDelBaby).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelBaby","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPregDelBaby).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelBaby","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPregDelBaby).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelBaby","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="BABY_Abnormalities">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BABY_Accoucheur1_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BABY_Accoucheur2_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BABY_ActualDelivPlaceOth">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BABY_ActualDelivPlace_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BABY_Alive">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="BABY_ApgarScore1min_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BABY_ApgarScore3_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BABY_ApgarScore4_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BABY_ApgarScore5min_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BABY_ApgarTime3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BABY_ApgarTime4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BABY_ArtificiallyFed">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BABY_BirthDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BABY_BirthDateAprxFlag">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="BABY_BirthLength">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BABY_BirthOrderNumber">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BABY_BirthPlaceChangeWhen_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BABY_BirthWeigth">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BABY_BreastFed">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BABY_Caput">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BABY_CordBldBaseExcess">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="BABY_CordBldLactate">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="BABY_CordBldSentOther">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="BABY_CordBldSentRhNeg">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="BABY_CordInsertion_DR">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="BABY_CordPHArterial">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="BABY_CordPHVenous">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="BABY_CordRoundNeck">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="BABY_CordVessels_DR">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="BABY_DecisionMaker_DR">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="BABY_Defecation">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BABY_DeliveryDoctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BABY_DeliveryMidwife_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BABY_DischargeWeight">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BABY_FdiuDiagnosis">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BABY_FirstRespiration_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BABY_FlyingSquad">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="BABY_FormulaType_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BABY_GestationDays">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="BABY_GestationWeeks">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="BABY_HepBGiven">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="BABY_HepBRefused">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="BABY_LiquorColor_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="BABY_MaconiumStain_DR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="BABY_MembRuptureDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="BABY_MembRuptureTime">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="BABY_Membranes_DR">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="BABY_MotherPosition_DR">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="BABY_Moulding">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="BABY_NeonatalIndicator_DR">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="BABY_NewbornScrnTestDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="BABY_NewbornScrnTestTime">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="BABY_NndDate">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="BABY_NndTime">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="BABY_OccipitoFrontalCircum">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="BABY_OpDelIndicationText">
<Node>"OOPDEL"</Node>
</Data>
<Data name="BABY_OpDelIndication_DR">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="BABY_OthCongAnom">
<Node>"OCA"</Node>
</Data>
<Data name="BABY_OthCordDetails">
<Node>"OCD"</Node>
</Data>
<Data name="BABY_OthDelMthd">
<Node>"ODM"</Node>
</Data>
<Data name="BABY_OthNeoMorb">
<Node>"ONM"</Node>
</Data>
<Data name="BABY_OthResusMth">
<Node>"ORM"</Node>
</Data>
<Data name="BABY_OtherStaffReg">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="BABY_OutcomeFreeText">
<Node>"OOUTCOME"</Node>
</Data>
<Data name="BABY_Outcome_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BABY_Person_DR">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="BABY_Position_DR">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="BABY_Presentation">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="BABY_PresentationText">
<Node>"OPRES"</Node>
</Data>
<Data name="BABY_ReasonDeath">
<Node>"DTHRSN"</Node>
</Data>
<Data name="BABY_Receiver1_DR">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="BABY_Receiver2_DR">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="BABY_ResusciatedBy_DR">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="BABY_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="BABY_SkinToSkinContactText">
<Node>"OSTSC"</Node>
</Data>
<Data name="BABY_SkinToSkinContact_DR">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="BABY_TimeOfBirth">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="BABY_TimeToEstRespiration_DR">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="BABY_TrueKnot">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="BABY_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="BABY_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="BABY_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="BABY_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="BABY_Urination">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="BABY_VitKGiven">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="Baby_CertOfGestation_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^PAPRG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BABY_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccoucheur1">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_Accoucheur1_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_Accoucheur1_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAccoucheur2">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_Accoucheur2_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_Accoucheur2_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApgar1min">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_ApgarScore1min_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_ApgarScore1min_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApgar3">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_ApgarScore3_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_ApgarScore3_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApgar4">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_ApgarScore4_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_ApgarScore4_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApgar5min">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_ApgarScore5min_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_ApgarScore5min_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApgarat1min">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_ApgarScore1min_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_ApgarScore1min_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApgarat5min">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_ApgarScore5min_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_ApgarScore5min_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexArtificiallyFed">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_ArtificiallyFed"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_ArtificiallyFed}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBirthDate">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_BirthDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_BirthDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBirthOrderNo">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_BirthOrderNumber"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_BirthOrderNumber}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBirthweight">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_BirthWeigth"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_BirthWeigth}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBreastFed">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_BreastFed"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_BreastFed}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDecisionMaker">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_DecisionMaker_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_DecisionMaker_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDeliveryPlace">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_ActualDelivPlace_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_ActualDelivPlace_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDeliverydoctor">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_DeliveryDoctor_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_DeliveryDoctor_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFdiuDiagnosis">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_FdiuDiagnosis"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_FdiuDiagnosis}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFirstrespiration">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_FirstRespiration_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_FirstRespiration_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFormulaType">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_FormulaType_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_FormulaType_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGestationdays">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_GestationDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_GestationDays}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGestationweeks">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_GestationWeeks"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_GestationWeeks}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLiquorcolour">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_LiquorColor_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_LiquorColor_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMembranes">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_Membranes_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_Membranes_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOpDelIndication">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_OpDelIndication_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_OpDelIndication_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutcome">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_Outcome_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_OpDelIndication_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPersonDR">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_Person_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_Person_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPresentation">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_Presentation"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_Presentation}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReceiver1">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_Receiver1_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_Receiver1_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReceiver2">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_Receiver2_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_Receiver2_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSex">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_Sex_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_Sex_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTimeofbirth">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_TimeOfBirth"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_TimeOfBirth}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexdeliverymidwife">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_DeliveryMidwife_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_DeliveryMidwife_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BABY_RowId</SqlRowIdName>
<StreamLocation>^User.PAPregDelBabyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
