/// Pregnancy(2230)
Class User.PAPregnancy Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Pregnancy, StorageStrategy = SQLStorage ]
{

Relationship ChildPAPregDelivery As PAPregDelivery [ Cardinality = children, Inverse = DELParRef ];

Relationship ChildPAPregAntenatalCompl As PAPregAntenatalCompl [ Cardinality = children, Inverse = PANCParRef ];

Relationship ChildPAPregArt As PAPregArt [ Cardinality = children, Inverse = PARMParRef ];

Relationship ChildPAPregMenst As PAPregMenst [ Cardinality = children, Inverse = MHPParRef ];

Relationship ChildPAPregContr As PAPregContr [ Cardinality = children, Inverse = CONTRParRef ];

/// Des Ref Person
Property PREGPersonDR As PAPerson [ SqlColumnNumber = 2, SqlFieldName = PREG_Person_DR ];

/// Pregnancy Status
Property PREGStatus As PACPregStatus [ SqlColumnNumber = 3, SqlFieldName = PREG_Status ];

/// Date of LNMP
Property PREGLnmp As %Date [ SqlColumnNumber = 4, SqlFieldName = PREG_Lnmp ];

/// Est. date of confinement based on LNMP
Property PREGEdcLnmp As %Date [ SqlColumnNumber = 5, SqlFieldName = PREG_EdcLnmp ];

/// Est. date of confinement based on u/s
Property PREGEdcUltrasound1 As %Date [ SqlColumnNumber = 6, SqlFieldName = PREG_EdcUltrasound1 ];

/// Agreed EDC
Property PREGEdcAgreed As %Date [ SqlColumnNumber = 7, SqlFieldName = PREG_EdcAgreed ];

/// Des Ref PAC_FeedType
Property PREGFeedIntentionDR As PACFeedType [ SqlColumnNumber = 8, SqlFieldName = PREG_FeedIntention_DR ];

/// Des Ref PAC_DeliveryPlace 
Property PREGIntendedDelivPlaceDR As PACDeliveryPlace [ SqlColumnNumber = 9, SqlFieldName = PREG_IntendedDelivPlace_DR ];

/// Date of Booking
Property PREGDateOfBooking As %Date [ SqlColumnNumber = 10, SqlFieldName = PREG_DateOfBooking ];

/// Des Ref PAC_OriginalBooking
Property PREGOriginalBookingDR As PACOriginalBooking [ SqlColumnNumber = 11, SqlFieldName = PREG_OriginalBooking_DR ];

/// Des Ref PAC_DelivPlanManag
Property PREGDelivPlanManagementDR As PACDelivPlanManag [ SqlColumnNumber = 12, SqlFieldName = PREG_DelivPlanManagement_DR ];

/// Des Ref PAC_BookingChangePlace
Property PREGBookingChangePlaceDR As PACBookingChangePlace [ SqlColumnNumber = 13, SqlFieldName = PREG_BookingChangePlace_DR ];

/// Des ref PAC_BookingChangeManag
Property PREGBookingChangeManagDR As PACBookingChangeManag [ SqlColumnNumber = 14, SqlFieldName = PREG_BookingChangeManag_DR ];

/// Certainty of gestation based on Scan
Property PREGScanGestCertaintyDR As PACCertaintyOfGestation [ SqlColumnNumber = 15, SqlFieldName = PREG_ScanGestCertainty_DR ];

/// Pregnancy Contact Surname
Property PREGContactSurname As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PREG_ContactSurname ];

/// Pregnancy Contact Forename
Property PREGContactForename As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PREG_ContactForename ];

/// EDC by Ultrasound 2
Property PREGEdcUltrasound2 As %Date [ SqlColumnNumber = 18, SqlFieldName = PREG_EdcUltrasound2 ];

/// EDC by ultrasound 3
Property PREGEdcUltrasound3 As %Date [ SqlColumnNumber = 19, SqlFieldName = PREG_EdcUltrasound3 ];

/// Des Ref PAC_Rhesus_Status
Property PREGRhesusDR As PACRhesusStatus [ SqlColumnNumber = 20, SqlFieldName = PREG_Rhesus_DR ];

/// Antibodies present
Property PREGAntibodies As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = PREG_Antibodies, SqlListType = subnode ];

/// Date of previous anti-rh
Property PREGPrevAntiRh As %Date [ SqlColumnNumber = 22, SqlFieldName = PREG_PrevAntiRh ];

/// Des ref PAC_RubellaImmune_Status
Property PREGRubellaImmuneDR As PACRubellaImmuneStatus [ SqlColumnNumber = 23, SqlFieldName = PREG_RubellaImmune_DR ];

/// No. of ultrasounds in 1st trimester
Property PREGUltrasounds1 As %Float [ SqlColumnNumber = 24, SqlFieldName = PREG_Ultrasounds1 ];

/// No. of ultrasounds in 2nd trimester
Property PREGUltrasounds2 As %Float [ SqlColumnNumber = 25, SqlFieldName = PREG_Ultrasounds2 ];

/// No. of ultrasounds in 3rd trimester
Property PREGUltrasounds3 As %Float [ SqlColumnNumber = 26, SqlFieldName = PREG_Ultrasounds3 ];

/// Artificial reproductive technologies
Property PREGArt As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = PREG_Art, SqlListType = subnode ];

/// Other Procedures
Property PREGOthProc As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = PREG_OthProc, SqlListType = subnode ];

/// Other Operations
Property PREGOthOper As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = PREG_OthOper, SqlListType = subnode ];

/// Other Antenatal Complications
Property PREGOthAntenatalCompl As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = PREG_OthAntenatalCompl, SqlListType = subnode ];

/// Time of Booking
Property PREGTimeOfBooking As %Time [ SqlColumnNumber = 31, SqlFieldName = PREG_TimeOfBooking ];

/// No. of fetus this Pregnancy
Property PREGFetusThisPreg As PACBabyPlurality [ SqlColumnNumber = 32, SqlFieldName = PREG_FetusThisPreg ];

/// Pregnancy Type
Property PREGPregType As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = PREG_PregType ];

/// Midwife Community Team
Property PREGMidCommTeamDR As PACMidwifeCommTeam [ SqlColumnNumber = 34, SqlFieldName = PREG_MidCommTeam_DR ];

/// Cancellation Reason DR PAC_ReasonPregCancel
Property PREGCancelReasonDR As PACReasonPregCancel [ SqlColumnNumber = 35, SqlFieldName = PREG_CancelReason_DR ];

/// Confidentiality Flag
Property PREGConfidential As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = PREG_Confidential ];

/// Confidential Reason
Property PREGConfidentialReason As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = PREG_ConfidentialReason, SqlListType = subnode ];

/// Midwife Locality Team Contact
Property PREGLocalityTeamContact As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = PREG_LocalityTeamContact, SqlListType = subnode ];

/// Gestation at Booking
Property PREGBookingGestation As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 39, SqlFieldName = PREG_BookingGestation ];

/// Antenatal Care DR PACTypeOFAntenatalCare
Property PREGAntenatalCareDR As PACTypeOfAntenatalCare [ SqlColumnNumber = 40, SqlFieldName = PREG_AntenatalCare_DR ];

/// LMP approximate date flag
Property PREGLmpApproxDateFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = PREG_LmpApproxDateFlag ];

/// Consultant
Property PREGConsultant As CTCareProv [ SqlColumnNumber = 42, SqlFieldName = PREG_Consultant ];

/// Original Booking free text
Property PREGOriginalBookingText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = PREG_OriginalBookingText, SqlListType = subnode ];

/// Last Update Date
Property PREGUpdateDate As %Date [ SqlColumnNumber = 44, SqlFieldName = PREG_UpdateDate ];

/// Last Update Hospital
Property PREGUpdateHospitalDR As CTHospital [ SqlColumnNumber = 45, SqlFieldName = PREG_UpdateHospital_DR ];

/// Last Update Time
Property PREGUpdateTime As %Time [ SqlColumnNumber = 46, SqlFieldName = PREG_UpdateTime ];

/// Last Update User
Property PREGUpdateUserDR As SSUser [ SqlColumnNumber = 47, SqlFieldName = PREG_UpdateUser_DR ];

/// Menarche
Property PREGMenarche As %Date [ SqlColumnNumber = 48, SqlFieldName = PREG_Menarche ];

/// MenstCycleReg
Property PREGMenstCycleReg As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = PREG_MenstCycleReg ];

/// Daysofbleeding
Property PREGDaysofbleeding As %Float [ SqlColumnNumber = 50, SqlFieldName = PREG_Daysofbleeding ];

/// CycleL
Property PREGCycleL As %Float [ SqlColumnNumber = 51, SqlFieldName = PREG_CycleL ];

/// HistUterineAnomaly
Property PREGHistUterineAnomaly As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 52, SqlFieldName = PREG_HistUterineAnomaly, SqlListType = subnode ];

/// PostnatalCompl
Property PREGPostnatalCompl As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 53, SqlFieldName = PREG_PostnatalCompl, SqlListType = subnode ];

/// Comments
Property PREGComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 54, SqlFieldName = PREG_Comments, SqlListType = subnode ];

/// Des Ref ConsDegree
Property PREGConsDegreeDR As PACPregnConsultDegree [ SqlColumnNumber = 55, SqlFieldName = PREG_ConsDegree_DR ];

/// Des Ref FatherBldType
Property PREGFatherBldTypeDR As PACBloodType [ SqlColumnNumber = 56, SqlFieldName = PREG_FatherBldType_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAPregnancy).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregnancy","OnAfterDelete")

 d CheckForGravida^CPAPreg($g(%d(1)),"D")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAPregnancy).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregnancy","OnAfterInsert")

 d CheckForGravida^CPAPreg($g(%d(1)),"I")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAPregnancy).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregnancy","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAPregnancy).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregnancy","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAPregnancy).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregnancy","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>70</ExtentSize>
<Property name="PREGAntenatalCareDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PREGAntibodies">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="PREGArt">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PREGBookingChangeManagDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PREGBookingChangePlaceDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PREGBookingGestation">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="PREGCancelReasonDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PREGComments">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PREGConfidential">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PREGConfidentialReason">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PREGConsDegreeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PREGConsultant">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="PREGContactForename">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PREGContactSurname">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PREGCycleL">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PREGDateOfBooking">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="PREGDaysofbleeding">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PREGDelivPlanManagementDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PREGEdcAgreed">
<Selectivity>2.6316%</Selectivity>
</Property>
<Property name="PREGEdcLnmp">
<Selectivity>3.7037%</Selectivity>
</Property>
<Property name="PREGEdcUltrasound1">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PREGEdcUltrasound2">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PREGEdcUltrasound3">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PREGFatherBldTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PREGFeedIntentionDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PREGFetusThisPreg">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="PREGHistUterineAnomaly">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="PREGIntendedDelivPlaceDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="PREGLmpApproxDateFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PREGLnmp">
<Selectivity>3.1250%</Selectivity>
</Property>
<Property name="PREGLocalityTeamContact">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PREGMenarche">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PREGMenstCycleReg">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PREGMidCommTeamDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PREGOriginalBookingDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PREGOriginalBookingText">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="PREGOthAntenatalCompl">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="PREGOthOper">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="PREGOthProc">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PREGPersonDR">
<Selectivity>2.0000%</Selectivity>
</Property>
<Property name="PREGPostnatalCompl">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PREGPregType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PREGPrevAntiRh">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PREGRhesusDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PREGRubellaImmuneDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PREGScanGestCertaintyDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PREGStatus">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PREGTimeOfBooking">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="PREGUltrasounds1">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PREGUltrasounds2">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PREGUltrasounds3">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PREGUpdateDate">
<Selectivity>2.7027%</Selectivity>
</Property>
<Property name="PREGUpdateHospitalDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PREGUpdateTime">
<Selectivity>2.0408%</Selectivity>
</Property>
<Property name="PREGUpdateUserDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAPRG(0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="PREG_AntenatalCare_DR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PREG_Antibodies">
<Node>"ANTIBD"</Node>
</Data>
<Data name="PREG_Art">
<Node>"OART"</Node>
</Data>
<Data name="PREG_BookingChangeManag_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PREG_BookingChangePlace_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PREG_BookingGestation">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PREG_CancelReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PREG_Comments">
<Node>"CMT"</Node>
</Data>
<Data name="PREG_Confidential">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PREG_ConfidentialReason">
<Node>"CONFRSN"</Node>
</Data>
<Data name="PREG_ConsDegree_DR">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="PREG_Consultant">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="PREG_ContactForename">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PREG_ContactSurname">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PREG_CycleL">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="PREG_DateOfBooking">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PREG_Daysofbleeding">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="PREG_DelivPlanManagement_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PREG_EdcAgreed">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PREG_EdcLnmp">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PREG_EdcUltrasound1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PREG_EdcUltrasound2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PREG_EdcUltrasound3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PREG_FatherBldType_DR">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="PREG_FeedIntention_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PREG_FetusThisPreg">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PREG_HistUterineAnomaly">
<Node>"HUAN"</Node>
</Data>
<Data name="PREG_IntendedDelivPlace_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PREG_LmpApproxDateFlag">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="PREG_Lnmp">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PREG_LocalityTeamContact">
<Node>"MLTC"</Node>
</Data>
<Data name="PREG_Menarche">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="PREG_MenstCycleReg">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="PREG_MidCommTeam_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PREG_OriginalBookingText">
<Node>"OORGBK"</Node>
</Data>
<Data name="PREG_OriginalBooking_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PREG_OthAntenatalCompl">
<Node>"OANTE"</Node>
</Data>
<Data name="PREG_OthOper">
<Node>"OOPER"</Node>
</Data>
<Data name="PREG_OthProc">
<Node>"OPROC"</Node>
</Data>
<Data name="PREG_Person_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PREG_PostnatalCompl">
<Node>"PONCOM"</Node>
</Data>
<Data name="PREG_PregType">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PREG_PrevAntiRh">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PREG_Rhesus_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PREG_RubellaImmune_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PREG_ScanGestCertainty_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PREG_Status">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PREG_TimeOfBooking">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PREG_Ultrasounds1">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PREG_Ultrasounds2">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PREG_Ultrasounds3">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PREG_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="PREG_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="PREG_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="PREG_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Global>^PAPRG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PREG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAntenatalCare">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_AntenatalCare"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_AntenatalCare_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBookingChangeMng">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_BookingChangeManag_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_BookingChangeManag_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBookingchangeplc">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_BookingChangePlace_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_BookingChangePlace_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCancellationreasn">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_CancelReason_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_CancelReason_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConsultant">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_Consultant"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_Consultant}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateofBooking">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_DateOfBooking"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_DateOfBooking}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateofLMP">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_Lnmp"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_Lnmp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDelPlanPlace">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_IntendedDelivPlace"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_IntendedDelivPlace_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDelivPlanMngmnt">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_DelivPlanMngmnt"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_DelivPlanManagement_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEDCAgreed">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_EdcAgreed"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_EdcAgreed}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExpectednofetus">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_FetusThisPreg"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_FetusThisPreg}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFeedingIntention">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_FeedIntention_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_FeedIntention_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMidwifeCommTeam">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_MidCommTeam"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_MidCommTeam_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOriginalBooking">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_OriginalBooking_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_OriginalBooking_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPerson">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_Person"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_Person_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPregnancyType">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_PregType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_PregType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_Status"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_Status}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTimeofBooking">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PREG_TimeOfBooking"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PREG_TimeOfBooking}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PREG_RowId</SqlRowIdName>
<StreamLocation>^User.PAPregnancyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
