/// Admission Mother            (1293)
Class User.PAAdmMother Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmMother, StorageStrategy = SQLStorage ]
{

/// Des Ref PACAbdState
Property MOTHAbdStateDR As PACAbdomenState [ SqlColumnNumber = 2, SqlFieldName = MOTH_AbdState_DR ];

/// Des Ref Actual Delivery Place
Property MOTHActualDelivPlaceDR As PACDeliveryPlace [ SqlColumnNumber = 42, SqlFieldName = MOTH_ActualDelivPlace_DR ];

/// Des Ref Booking Change Management
Property MOTHBookingChangeManagemDR As PACBookingChangeManag [ SqlColumnNumber = 52, SqlFieldName = MOTH_BookingChangeManagem_DR ];

/// Des Ref Booking Change Place
Property MOTHBookingChangePlaceDR As PACBookingChangePlace [ SqlColumnNumber = 51, SqlFieldName = MOTH_BookingChangePlace_DR ];

/// Des Ref to Breast
Property MOTHBreastDR As PACBreastNipple [ SqlColumnNumber = 4, SqlFieldName = MOTH_Breast_DR ];

/// Breast Feeding Actual
Property MOTHBreastFeedingActual As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = MOTH_BreastFeedingActual ];

/// Cervix Dilation
Property MOTHCervixDilation As %Float [ SqlColumnNumber = 6, SqlFieldName = MOTH_CervixDilation ];

/// Des Ref to PACChar
Property MOTHCharDR As PACCharacter [ SqlColumnNumber = 7, SqlFieldName = MOTH_Char_DR ];

/// Circumference of Abdomen
Property MOTHCircumAbdomen As %Float [ SqlColumnNumber = 39, SqlFieldName = MOTH_CircumAbdomen ];

/// Des Ref Condition Episiotomy
Property MOTHCondEpis As PACEpisiotomyCondition [ SqlColumnNumber = 8, SqlFieldName = MOTH_CondEpis ];

/// Date Of Booking
Property MOTHDateOfBooking As %Date [ SqlColumnNumber = 48, SqlFieldName = MOTH_DateOfBooking ];

/// Des Ref Deliv Plan Management
Property MOTHDelivPlanManagementDR As PACDelivPlanManag [ SqlColumnNumber = 50, SqlFieldName = MOTH_DelivPlanManagement_DR ];

/// Des Ref Diabetes
Property MOTHDiabetesDR As PACDiabetes [ SqlColumnNumber = 56, SqlFieldName = MOTH_Diabetes_DR ];

/// Effacement
Property MOTHEffacement As %Float [ SqlColumnNumber = 11, SqlFieldName = MOTH_Effacement ];

/// Des Ref to PACFetHeartLoc
Property MOTHFetHeartLoc As PACFetalHeartLocation [ SqlColumnNumber = 14, SqlFieldName = MOTH_FetHeartLoc ];

/// Fetal Heart Rate
Property MOTHFetHeartRate As %Float [ SqlColumnNumber = 36, SqlFieldName = MOTH_FetHeartRate ];

/// Fetal Heart Sound
Property MOTHFetHeartSound As %Float [ SqlColumnNumber = 15, SqlFieldName = MOTH_FetHeartSound ];

/// Fetus Moving
Property MOTHFetusMoving As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = MOTH_FetusMoving ];

/// First Antenatal Assesment Date
Property MOTHFirstAntenatalAssesDate As %Date [ SqlColumnNumber = 41, SqlFieldName = MOTH_FirstAntenatalAssesDate ];

/// Des Ref GMP responsible for Antenatal Care
Property MOTHGMPAntenatalCareDR As PACRefDoctor [ SqlColumnNumber = 40, SqlFieldName = MOTH_GMPAntenatalCare_DR ];

/// Sign Go to Labour
Property MOTHGoLabour As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = MOTH_GoLabour ];

/// Height of Fundus
Property MOTHHeightFundus As %Float [ SqlColumnNumber = 19, SqlFieldName = MOTH_HeightFundus ];

/// Des Ref Intended Deliv Place
Property MOTHIntendedDelivPlaceDR As PACDeliveryPlace [ SqlColumnNumber = 43, SqlFieldName = MOTH_IntendedDelivPlace_DR ];

/// LMP
Property MOTHLMP As %Date [ SqlColumnNumber = 55, SqlFieldName = MOTH_LMP ];

/// Des Ref to PACMaconium Stain
Property MOTHMacStainDR As PACMaconiumStain [ SqlColumnNumber = 23, SqlFieldName = MOTH_MacStain_DR ];

/// Des Ref Management Of Abortion
Property MOTHManagementOfAbortionDR As PACManagementOfAbortion [ SqlColumnNumber = 54, SqlFieldName = MOTH_ManagementOfAbortion_DR ];

/// Des Ref Midwife to Consultant Transfer
Property MOTHMidwifeConsultTransfDR As PACMidwifeToConsTrans [ SqlColumnNumber = 57, SqlFieldName = MOTH_MidwifeConsultTransf_DR ];

/// Des Ref Original Booking
Property MOTHOriginalBookingDR As PACOriginalBooking [ SqlColumnNumber = 49, SqlFieldName = MOTH_OriginalBooking_DR ];

/// Des Ref Perineum
Property MOTHPerineumDR As PACPerineum [ SqlColumnNumber = 26, SqlFieldName = MOTH_Perineum_DR ];

/// Des Ref PACPresent
Property MOTHPresentDR As PACPresentation [ SqlColumnNumber = 28, SqlFieldName = MOTH_Present_DR ];

/// Prev Admissions To Hosp
Property MOTHPrevAdmToHosp As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 47, SqlFieldName = MOTH_PrevAdmToHosp ];

/// not used
Property MOTHPrevCaesareanSections As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = MOTH_PrevCaesareanSections ];

/// not used
Property MOTHPrevNeonatalBirths As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 46, SqlFieldName = MOTH_PrevNeonatalBirths ];

/// not used
Property MOTHPrevStillBirths As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = MOTH_PrevStillBirths ];

/// Des Ref PACPuerper
Property MOTHPuerperDR As PACPuerperium [ SqlColumnNumber = 30, SqlFieldName = MOTH_Puerper_DR ];

/// Remarks
Property MOTHRemarks As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = MOTH_Remarks, SqlListType = SUBNODE ];

/// PA_AdmMother Row ID
Property MOTHRowId As %Float [ Required, SqlFieldName = MOTH_RowId ];

/// Des Ref Smoker During Pregnancy
Property MOTHSmokerDuringPregnDR As PACSmokerDuringPregn [ SqlColumnNumber = 58, SqlFieldName = MOTH_SmokerDuringPregn_DR ];

/// Station
Property MOTHStation As PACStation [ SqlColumnNumber = 33, SqlFieldName = MOTH_Station ];

/// Des Ref Type Of Abortion
Property MOTHTypeOfAbortionDR As PACTypeOfAbortion [ SqlColumnNumber = 53, SqlFieldName = MOTH_TypeOfAbortion_DR ];

/// Des Ref Uterus
Property MOTHUterusDR As PACUterusState [ SqlColumnNumber = 34, SqlFieldName = MOTH_Uterus_DR ];

Index RowIDBasedIDKeyIndex On MOTHRowId [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 19353;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmMother).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmMother","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmMother).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmMother","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmMother).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmMother","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmMother).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmMother","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmMother).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmMother","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>19353</ExtentSize>
<Property name="MOTHAbdStateDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHActualDelivPlaceDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHBookingChangeManagemDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHBookingChangePlaceDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHBreastDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHBreastFeedingActual">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MOTHCervixDilation">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHCharDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHCircumAbdomen">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHCondEpis">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHDateOfBooking">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHDelivPlanManagementDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHDiabetesDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHEffacement">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHFetHeartLoc">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHFetHeartRate">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHFetHeartSound">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHFetusMoving">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MOTHFirstAntenatalAssesDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHGMPAntenatalCareDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHGoLabour">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MOTHHeightFundus">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHIntendedDelivPlaceDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHLMP">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHMacStainDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHManagementOfAbortionDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHMidwifeConsultTransfDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHOriginalBookingDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHPerineumDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHPresentDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHPrevAdmToHosp">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHPrevCaesareanSections">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHPrevNeonatalBirths">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHPrevStillBirths">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHPuerperDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHRemarks">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHRowId">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHSmokerDuringPregnDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHStation">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHTypeOfAbortionDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHUterusDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="MOTH_AbdState_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>1</Piece>
</Data>
<Data name="MOTH_ActualDelivPlace_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>24</Piece>
</Data>
<Data name="MOTH_BookingChangeManagem_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>34</Piece>
</Data>
<Data name="MOTH_BookingChangePlace_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>33</Piece>
</Data>
<Data name="MOTH_BreastFeedingActual">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>20</Piece>
</Data>
<Data name="MOTH_Breast_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>2</Piece>
</Data>
<Data name="MOTH_CervixDilation">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>4</Piece>
</Data>
<Data name="MOTH_Char_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>5</Piece>
</Data>
<Data name="MOTH_CircumAbdomen">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>21</Piece>
</Data>
<Data name="MOTH_CondEpis">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>6</Piece>
</Data>
<Data name="MOTH_DateOfBooking">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>30</Piece>
</Data>
<Data name="MOTH_DelivPlanManagement_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>32</Piece>
</Data>
<Data name="MOTH_Diabetes_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>38</Piece>
</Data>
<Data name="MOTH_Effacement">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>7</Piece>
</Data>
<Data name="MOTH_FetHeartLoc">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>8</Piece>
</Data>
<Data name="MOTH_FetHeartRate">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>9</Piece>
</Data>
<Data name="MOTH_FetHeartSound">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>10</Piece>
</Data>
<Data name="MOTH_FetusMoving">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>11</Piece>
</Data>
<Data name="MOTH_FirstAntenatalAssesDate">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>23</Piece>
</Data>
<Data name="MOTH_GMPAntenatalCare_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>22</Piece>
</Data>
<Data name="MOTH_GoLabour">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>12</Piece>
</Data>
<Data name="MOTH_HeightFundus">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>13</Piece>
</Data>
<Data name="MOTH_IntendedDelivPlace_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>25</Piece>
</Data>
<Data name="MOTH_LMP">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>37</Piece>
</Data>
<Data name="MOTH_MacStain_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>14</Piece>
</Data>
<Data name="MOTH_ManagementOfAbortion_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>36</Piece>
</Data>
<Data name="MOTH_MidwifeConsultTransf_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>39</Piece>
</Data>
<Data name="MOTH_OriginalBooking_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>31</Piece>
</Data>
<Data name="MOTH_Perineum_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>15</Piece>
</Data>
<Data name="MOTH_Present_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>16</Piece>
</Data>
<Data name="MOTH_PrevAdmToHosp">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>29</Piece>
</Data>
<Data name="MOTH_PrevCaesareanSections">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>26</Piece>
</Data>
<Data name="MOTH_PrevNeonatalBirths">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>28</Piece>
</Data>
<Data name="MOTH_PrevStillBirths">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>27</Piece>
</Data>
<Data name="MOTH_Puerper_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>17</Piece>
</Data>
<Data name="MOTH_Remarks">
<Node>"MOTHREM"</Node>
</Data>
<Data name="MOTH_SmokerDuringPregn_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>40</Piece>
</Data>
<Data name="MOTH_Station">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>18</Piece>
</Data>
<Data name="MOTH_TypeOfAbortion_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>35</Piece>
</Data>
<Data name="MOTH_Uterus_DR">
<Delimiter>"^"</Delimiter>
<Node>"MOTH"</Node>
<Piece>19</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MOTH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MOTH_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MOTH_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmMotherS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
