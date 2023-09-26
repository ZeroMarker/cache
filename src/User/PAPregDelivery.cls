/// PregDelivery(2231)
Class User.PAPregDelivery Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PregDelivery, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DELChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPAPregDelBaby As PAPregDelBaby [ Cardinality = children, Inverse = BABYParRef ];

Relationship ChildPAPregDelPlacenta As PAPregDelPlacenta [ Cardinality = children, Inverse = PLACParRef ];

Relationship ChildPAPrDelIndIndctrs As PAPrDelIndIndctrs [ Cardinality = children, Inverse = PDIIParRef ];

Relationship ChildPAPrDelLacerations As PAPrDelLacerations [ Cardinality = children, Inverse = PDLACERParRef ];

Relationship ChildPAPrDelLabDelCompl As PAPrDelLabDelCompl [ Cardinality = children, Inverse = PDLDCParRef ];

Relationship ChildPAPrDelPuerpCompl As PAPrDelPuerpCompl [ Cardinality = children, Inverse = PDPCParRef ];

Relationship ChildPAPrDelIndMethods As PAPrDelIndMethods [ Cardinality = children, Inverse = PDIMParRef ];

Relationship ChildPAPrDelAugMethods As PAPrDelAugMethods [ Cardinality = children, Inverse = PDAMParRef ];

/// PA_Pregnancy Parent Reference
Relationship DELParRef As PAPregnancy [ Cardinality = parent, Inverse = ChildPAPregDelivery, Required, SqlFieldName = DEL_ParRef ];

/// Childsub
Property DELChildsub As %Float [ InitialExpression = {$i(^PAPRG($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DEL",0))}, SqlColumnNumber = 2, SqlFieldName = DEL_Childsub ];

/// Des ref PA_ADM
Property DELAdmDR As PAAdm [ SqlColumnNumber = 3, SqlFieldName = DEL_Adm_DR ];

/// Blood Loss 
Property DELBloodLoss As %Float [ SqlColumnNumber = 4, SqlFieldName = DEL_BloodLoss ];

/// Labour Onset Date
Property DELLabourOnsetDate As %Date [ SqlColumnNumber = 5, SqlFieldName = DEL_LabourOnsetDate ];

/// Labour Onset Time
Property DELLabourOnsetTime As %Time [ SqlColumnNumber = 6, SqlFieldName = DEL_LabourOnsetTime ];

/// Labour Method
Property DELLabourMethodDR As PACLabourMethod [ SqlColumnNumber = 7, SqlFieldName = DEL_LabourMethod_DR ];

/// Full Dilatation Date
Property DELFullDilatationDate As %Date [ SqlColumnNumber = 8, SqlFieldName = DEL_FullDilatationDate ];

/// Full Dilatation Time
Property DELFullDilatationTime As %Time [ SqlColumnNumber = 9, SqlFieldName = DEL_FullDilatationTime ];

/// Des ref PAC_TypeOfAbortion
Property DELTypeOfAbortionDR As PACTypeOfAbortion [ SqlColumnNumber = 10, SqlFieldName = DEL_TypeOfAbortion_DR ];

/// Des ref PAC_MidwifeToConsTrans
Property DELMidwifeConsultTrnsfrDR As PACMidwifeToConsTrans [ SqlColumnNumber = 11, SqlFieldName = DEL_MidwifeConsultTrnsfr_DR ];

/// Contractions Interval
Property DELContractionsInterval As %Float [ SqlColumnNumber = 12, SqlFieldName = DEL_ContractionsInterval ];

/// Des Ref Episiotomy Type
Property DELEpisTypeDR As PACEpisiotomyType [ SqlColumnNumber = 16, SqlFieldName = DEL_EpisType_DR ];

/// Degree of Laceration
Property DELDegreeLacerationDR As PACLacerationDegree [ SqlColumnNumber = 17, SqlFieldName = DEL_DegreeLaceration_DR ];

/// Most senior doctor Des Ref  CT_CarPrv
Property DELMostSeniorDocDR As CTCarPrvTp [ SqlColumnNumber = 19, SqlFieldName = DEL_MostSeniorDoc_DR ];

/// Most senior midwife Des Ref CT_CarPrvTp
Property DELMostSeniorMidwifeDR As CTCarPrvTp [ SqlColumnNumber = 20, SqlFieldName = DEL_MostSeniorMidwife_DR ];

/// Des Ref PAC_SutureType
Property DELSutureType As PACSutureType [ SqlColumnNumber = 21, SqlFieldName = DEL_SutureType ];

/// Des Ref CT_CareProv
Property DELSutureBy As CTCareProv [ SqlColumnNumber = 22, SqlFieldName = DEL_SutureBy ];

/// Blood Transfusion
Property DELBloodTransfusion As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = DEL_BloodTransfusion ];

/// Caesarean decision date
Property DELCsDecisionDate As %Date [ SqlColumnNumber = 24, SqlFieldName = DEL_CsDecisionDate ];

/// CS Decision Time
Property DELCsDecisionTime As %Time [ SqlColumnNumber = 25, SqlFieldName = DEL_CsDecisionTime ];

/// Cervix Dilation 
Property DELCervixDilation As %Float [ SqlColumnNumber = 26, SqlFieldName = DEL_CervixDilation ];

/// Des ref PAC_Perineum
Property DELPerineumDR As PACPerineum [ SqlColumnNumber = 27, SqlFieldName = DEL_Perineum_DR ];

/// Des Ref PAC_IndcutionMethods
Property DELPlannedInductionMthDR As PACInductionMethods [ SqlColumnNumber = 28, SqlFieldName = DEL_PlannedInductionMth_DR ];

/// Des Ref PAC_MotherOutcome
Property DELMotherOutcomeDR As PACMotherOutcome [ SqlColumnNumber = 29, SqlFieldName = DEL_MotherOutcome_DR ];

/// Duration of labour
Property DELTotalDuration As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = DEL_TotalDuration ];

/// Delivery Type
Property DELDeliveryType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = DEL_DeliveryType ];

/// Date of Induction
Property DELDateOfInduction As %Date [ SqlColumnNumber = 32, SqlFieldName = DEL_DateOfInduction ];

/// Time of Induction
Property DELTimeOfInduction As %Time [ SqlColumnNumber = 33, SqlFieldName = DEL_TimeOfInduction ];

/// Other Induction Augmentation methods
Property DELOthIndAugMthd As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = DEL_OthIndAugMthd, SqlListType = SUBNODE ];

/// Other Induction Indicators
Property DELOthIndIndctr As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = DEL_OthIndIndctr, SqlListType = SUBNODE ];

/// Other Labour & Delivery Complications
Property DELOthLabDelCompl As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = DEL_OthLabDelCompl, SqlListType = SUBNODE ];

/// Other puerperium complications
Property DELOthPuerpCompl As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = DEL_OthPuerpCompl, SqlListType = SUBNODE ];

/// Des Ref PAC_AntenatalSteroid
Property DELAntenatalSteroidsDR As PACAntenatalSteroid [ SqlColumnNumber = 39, SqlFieldName = DEL_AntenatalSteroids_DR ];

/// Sterile after delivery
Property DELSterileAfterDelivery As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = DEL_SterileAfterDelivery ];

/// Des Ref PAC_SkinClosure
Property DELSkinClosureDR As PACSkinClosure [ SqlColumnNumber = 41, SqlFieldName = DEL_SkinClosure_DR ];

/// Perineum free text
Property DELPerineumText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = DEL_PerineumText, SqlListType = SUBNODE ];

/// Type of abortion free text
Property DELTypeOfAbortionText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = DEL_TypeOfAbortionText, SqlListType = SUBNODE ];

/// Plurality
Property DELPlurality As PACBabyPlurality [ SqlColumnNumber = 45, SqlFieldName = DEL_Plurality ];

/// Last update time
Property DELUpdateTime As %Time [ SqlColumnNumber = 46, SqlFieldName = DEL_UpdateTime ];

/// Last Update Date
Property DELUpdateDate As %Date [ SqlColumnNumber = 47, SqlFieldName = DEL_UpdateDate ];

/// Last Update User
Property DELUpdateUser As SSUser [ SqlColumnNumber = 48, SqlFieldName = DEL_UpdateUser ];

/// Duration of Stage 1
Property DELStage1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 49, SqlFieldName = DEL_Stage1 ];

/// Duration of Stage 2
Property DELStage2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = DEL_Stage2 ];

/// Duration of Stage 3
Property DELStage3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = DEL_Stage3 ];

/// Last Update Hospital
Property DELUpdateHospitalDR As CTHospital [ SqlColumnNumber = 52, SqlFieldName = DEL_UpdateHospital_DR ];

/// PainReliefFreeText
Property DELPainReliefFreeText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 53, SqlFieldName = DEL_PainReliefFreeText, SqlListType = SUBNODE ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPregDelivery).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelivery","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPregDelivery).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelivery","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPregDelivery).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelivery","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPregDelivery).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelivery","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPregDelivery).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelivery","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregDelivery","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DEL_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DEL_AntenatalSteroids_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DEL_BloodLoss">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DEL_BloodTransfusion">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DEL_CervixDilation">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DEL_ContractionsInterval">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DEL_CsDecisionDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DEL_CsDecisionTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DEL_DateOfInduction">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DEL_DegreeLaceration_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DEL_DeliveryType">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="DEL_EpisType_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DEL_FullDilatationDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DEL_FullDilatationTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DEL_LabourMethod_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DEL_LabourOnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DEL_LabourOnsetTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DEL_MidwifeConsultTrnsfr_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DEL_MostSeniorDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DEL_MostSeniorMidwife_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DEL_MotherOutcome_DR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="DEL_OthIndAugMthd">
<Node>"OIAM"</Node>
</Data>
<Data name="DEL_OthIndIndctr">
<Node>"OII"</Node>
</Data>
<Data name="DEL_OthLabDelCompl">
<Node>"OLDC"</Node>
</Data>
<Data name="DEL_OthPuerpCompl">
<Node>"OPC"</Node>
</Data>
<Data name="DEL_PainReliefFreeText">
<Node>"PR"</Node>
</Data>
<Data name="DEL_PerineumText">
<Node>"OPRNM"</Node>
</Data>
<Data name="DEL_Perineum_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DEL_PlannedInductionMth_DR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="DEL_Plurality">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="DEL_SkinClosure_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="DEL_Stage1">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="DEL_Stage2">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="DEL_Stage3">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="DEL_SterileAfterDelivery">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DEL_SutureBy">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DEL_SutureType">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DEL_TimeOfInduction">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="DEL_TotalDuration">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="DEL_TypeOfAbortionText">
<Node>"OTOA"</Node>
</Data>
<Data name="DEL_TypeOfAbortion_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DEL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="DEL_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="DEL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="DEL_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Global>^PAPRG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DEL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAbortiontype">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_TypeOfAbortion_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_TypeOfAbortion_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdmDR">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_Adm_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_Adm_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCervixDilation">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_CervixDilation"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_CervixDilation}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateofInduction">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_DateOfInduction"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_FullDilatationTime}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDegreeofTear">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_DegreeLaceration_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_DegreeLaceration_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDeliveryType">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_DeliveryType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_DeliveryType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpisiotomy">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_EpisType_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_EpisType_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLabourMethod">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_LabourMethod_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_LabourMethod_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMidwfCnsltntTrns">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_MidwifeConsultTrnsfr_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_MidwifeConsultTrnsfr_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMngmntofAbortion">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_ManagementOfAbortion_DR}"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_PlannedInductionMth_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMostseniordoctor">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_MostSeniorDoc_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_MostSeniorDoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMostseniormidwfe">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_MostSeniorMidwife_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_MostSeniorMidwife_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMotheroutcome">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_MotherOutcome_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_MotherOutcome_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPerineum">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_Perineum_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_Perineum_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPlanInductionMtd">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_PlannedInductionMth_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_PlannedInductionMth_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSterileafterDel">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_SterileAfterDelivery"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_SterileAfterDelivery}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTimeofInduction">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_TimeOfInduction"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_TimeOfInduction}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DEL_RowId</SqlRowIdName>
<StreamLocation>^User.PAPregDeliveryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
