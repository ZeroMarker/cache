/// Admission Labour           (ALB,96)
Class User.PAAdmLab Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmLab, StorageStrategy = SQLStorage ]
{

/// AnaestUsed Des Ref to ORCAnaMeth
Property ALBAnaestUsedDR As ORCAnaestMethod [ SqlColumnNumber = 48, SqlFieldName = ALB_AnaestUsed_DR ];

/// Des Ref Antenatal Steroids
Property ALBAntenatalSteroidsDR As PACAntenatalSteroid [ SqlColumnNumber = 58, SqlFieldName = ALB_AntenatalSteroids_DR ];

/// Blood Loss
Property ALBBloodLoss As %Float(MINVAL = 0) [ SqlColumnNumber = 10, SqlFieldName = ALB_BloodLoss ];

/// Des Ref Certainty Of Gestation
Property ALBCertOfGestationDR As PACCertaintyOfGestation [ SqlColumnNumber = 54, SqlFieldName = ALB_CertOfGestation_DR ];

/// Cervix Expand Date
Property ALBCervixDate As %Date [ SqlColumnNumber = 22, SqlFieldName = ALB_CervixDate ];

/// Cervix Expand Time
Property ALBCervixTime As %Time [ SqlColumnNumber = 23, SqlFieldName = ALB_CervixTime ];

/// Childsub
Property ALBChildsub As %Numeric(MAXVAL = 999999999, MINVAL = 1, SCALE = 0) [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"ALB",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ALB_Childsub ];

/// Cord Length
Property ALBCordLength As %Float [ SqlColumnNumber = 45, SqlFieldName = ALB_CordLength ];

/// Degree of Laceration Des Ref to PACLacerDeg
Property ALBDegreeLacerationDR As PACLacerationDegree [ SqlColumnNumber = 50, SqlFieldName = ALB_DegreeLaceration_DR ];

/// Delivery Date
Property ALBDelivDate As %Date [ SqlColumnNumber = 24, SqlFieldName = ALB_DelivDate ];

/// Delivery Method
Property ALBDelivMethodDR As PACDeliveryMethod [ SqlColumnNumber = 26, SqlFieldName = ALB_DelivMethod_DR ];

/// Delivery Time
Property ALBDelivTime As %Time [ SqlColumnNumber = 25, SqlFieldName = ALB_DelivTime ];

/// ALB_DeliveryDoctor_DR
Property ALBDeliveryDoctorDR As CTCareProv [ SqlColumnNumber = 35, SqlFieldName = ALB_DeliveryDoctor_DR ];

/// DeliveryNurse Des Ref to CTCP
Property ALBDeliveryNurseDR As CTCareProv [ SqlColumnNumber = 36, SqlFieldName = ALB_DeliveryNurse_DR ];

/// Des Ref DeliveryType
Property ALBDeliveryTypeDR As PACDeliveryType [ SqlColumnNumber = 53, SqlFieldName = ALB_DeliveryType_DR ];

/// Duration of Labour
Property ALBDurationLabour As %Time [ SqlColumnNumber = 40, SqlFieldName = ALB_Duration_Labour ];

/// Episiotomy Type Des Ref to PACEpisType
Property ALBEpisTypeDR As PACEpisiotomyType [ SqlColumnNumber = 49, SqlFieldName = ALB_EpisType_DR ];

/// Gestation In No Of Weeks
Property ALBGestation As %Float [ SqlColumnNumber = 9, SqlFieldName = ALB_Gestation ];

/// Gestation Period in Days
Property ALBGestationDays As %Float [ SqlColumnNumber = 37, SqlFieldName = ALB_Gestation_Days ];

/// Des Ref ICDDx
Property ALBIndicOperDelivDR As MRCICDDx [ SqlColumnNumber = 55, SqlFieldName = ALB_IndicOperDeliv_DR ];

/// Interval between Contractions
Property ALBIntervalContractions As %Float [ SqlColumnNumber = 39, SqlFieldName = ALB_Interval_Contractions ];

/// Labour Date
Property ALBLabourDate As %Date [ SqlColumnNumber = 16, SqlFieldName = ALB_LabourDate ];

/// Not Currently Used
Property ALBLabourIntensDR As PACIntensityLabour [ SqlColumnNumber = 38, SqlFieldName = ALB_LabourIntens_DR ];

/// Des Ref to LBMTH
Property ALBLabourMethodDR As PACLabourMethod [ SqlColumnNumber = 18, SqlFieldName = ALB_LabourMethod_DR ];

/// Labour start Time
Property ALBLabourStartTime As %Time [ SqlColumnNumber = 17, SqlFieldName = ALB_LabourStartTime ];

/// Location of Laceration Des Ref to PacLacLoc
Property ALBLocationLacerationDR As PACLacerationLoc [ SqlColumnNumber = 51, SqlFieldName = ALB_LocationLaceration_DR ];

/// Des Ref CareProvType
Property ALBMostSeniorDocDR As CTCarPrvTp [ SqlColumnNumber = 56, SqlFieldName = ALB_MostSeniorDoc_DR ];

/// Des Ref CareProvType
Property ALBMostSeniorMidwifePresent As CTCarPrvTp [ SqlColumnNumber = 57, SqlFieldName = ALB_MostSeniorMidwifePresent ];

/// No Of Newborn (Should be computed from ADMNB)
Property ALBNumberOfNewborn As %Float(MAXVAL = 99, MINVAL = 1) [ SqlColumnNumber = 8, SqlFieldName = ALB_NumberOfNewborn ];

/// Des Ref to PAADM
Relationship ALBPAADMParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmLab, Required, SqlFieldName = ALB_PAADM_ParRef ];

/// PlacDelivType Des Ref to PacPlacDelType
Property ALBPlacDelivTypeDR As PACPlacDelivType [ SqlColumnNumber = 43, SqlFieldName = ALB_PlacDelivType_DR ];

/// Placenta Condition Des Ref to PacPlacCond
Property ALBPlacentaCondDR As PACPlacentaCondtion [ SqlColumnNumber = 46, SqlFieldName = ALB_PlacentaCond_DR ];

/// Date Placenta was Delivered
Property ALBPlacentaDate As %Date [ SqlColumnNumber = 41, SqlFieldName = ALB_Placenta_Date ];

/// Time Placenta was Delivered
Property ALBPlacentaTime As %Time [ SqlColumnNumber = 42, SqlFieldName = ALB_Placenta_Time ];

/// Placenta Weight
Property ALBPlacentaWeight As %Float [ SqlColumnNumber = 44, SqlFieldName = ALB_Placenta_Weight ];

/// Post Natal Problem Des Ref to PacPosNatProb
Property ALBPostNatProbDR As PACPostNatalProblems [ SqlColumnNumber = 52, SqlFieldName = ALB_PostNatProb_DR ];

/// Remarks
Property ALBRemarks As list Of %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = ALB_Remarks, SqlListType = SUBNODE ];

/// Rupture Date of Amniotic Membrane
Property ALBRuptureDate As %Date [ SqlColumnNumber = 19, SqlFieldName = ALB_RuptureDate ];

/// Rupture Time of Amniotic Membrane
Property ALBRuptureTime As %Time [ SqlColumnNumber = 20, SqlFieldName = ALB_RuptureTime ];

Relationship ChildPALabourNewBorn As PALabourNewBorn [ Cardinality = children, Inverse = LNBALBParRef ];

Index RowIDBasedIDKeyIndex On ALBChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 24;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmLab).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmLab","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmLab).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmLab","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmLab).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmLab","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmLab).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmLab","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmLab).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmLab","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>24</ExtentSize>
<Property name="ALBAnaestUsedDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBAntenatalSteroidsDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBBloodLoss">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBCertOfGestationDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBCervixDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBCervixTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBCordLength">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBDegreeLacerationDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBDelivDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBDelivMethodDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBDelivTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBDeliveryDoctorDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBDeliveryNurseDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBDeliveryTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBDurationLabour">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBEpisTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBGestation">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBGestationDays">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBIndicOperDelivDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBIntervalContractions">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBLabourDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBLabourIntensDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBLabourMethodDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBLabourStartTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBLocationLacerationDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBMostSeniorDocDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBMostSeniorMidwifePresent">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBNumberOfNewborn">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBPAADMParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBPlacDelivTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBPlacentaCondDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBPlacentaDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBPlacentaTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBPlacentaWeight">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBPostNatProbDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBRemarks">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBRuptureDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALBRuptureTime">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMasterMapALB">
<Data name="ALB_AnaestUsed_DR">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="ALB_AntenatalSteroids_DR">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="ALB_BloodLoss">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ALB_CertOfGestation_DR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="ALB_CervixDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ALB_CervixTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ALB_CordLength">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="ALB_DegreeLaceration_DR">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="ALB_DelivDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ALB_DelivMethod_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ALB_DelivTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ALB_DeliveryDoctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ALB_DeliveryNurse_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ALB_DeliveryType_DR">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="ALB_Duration_Labour">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ALB_EpisType_DR">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="ALB_Gestation">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ALB_Gestation_Days">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ALB_IndicOperDeliv_DR">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="ALB_Interval_Contractions">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ALB_LabourDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ALB_LabourIntens_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ALB_LabourMethod_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ALB_LabourStartTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ALB_LocationLaceration_DR">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="ALB_MostSeniorDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="ALB_MostSeniorMidwifePresent">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="ALB_NumberOfNewborn">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ALB_PlacDelivType_DR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ALB_PlacentaCond_DR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="ALB_Placenta_Date">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ALB_Placenta_Time">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ALB_Placenta_Weight">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="ALB_PostNatProb_DR">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="ALB_Remarks">
<Node>"RMK"</Node>
</Data>
<Data name="ALB_RuptureDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ALB_RuptureTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ALB_Childsub</Field>
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
<Expression>{ALB_Childsub}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ALB_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmLabS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
