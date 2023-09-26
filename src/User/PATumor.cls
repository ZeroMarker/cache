/// PA Tumor(1358)
Class User.PATumor Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Tumor, StorageStrategy = SQLStorage ]
{

Relationship ChildPATumorClinDiagReason As PATumorClinDiagReason [ Cardinality = children, Inverse = CDRParRef ];

Relationship ChildPATumorMetatstatic As PATumorMetatstatic [ Cardinality = children, Inverse = METParRef ];

Relationship ChildPATumorHistoryOfTreatment As PATumorHistoryOfTreatment [ Cardinality = children, Inverse = HISParRef ];

/// First Diagnosis Date
Property TUMFirstDiagnosisDate As %Date [ SqlColumnNumber = 2, SqlFieldName = TUM_FirstDiagnosisDate ];

/// Primary Site of Cancer
Property TUMPrimarySiteCancer As %String(COLLATION = "Exact", MAXLEN = 75, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TUM_PrimarySiteCancer ];

/// Des REf to FirstDiagnosisPlace
Property TUMFirstDiagnosisPlaceDR As MRCFirstVisitPlace [ SqlColumnNumber = 4, SqlFieldName = TUM_FirstDiagnosisPlace_DR ];

/// Des MRCIDx Pathologic Diagnosis
Property TUMPathologicDiagnosisDR As MRCICDDx [ SqlColumnNumber = 5, SqlFieldName = TUM_PathologicDiagnosis_DR ];

/// Date of Death
Property TUMDateDeath As %Date [ SqlColumnNumber = 6, SqlFieldName = TUM_DateDeath ];

/// Survival Periods
Property TUMSurvivalPeriods As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = TUM_SurvivalPeriods ];

/// Des Ref Diagn Method of Cancer
Property TUMDiagnMethodCancerDR As MRCDiagMethodCancer [ SqlColumnNumber = 8, SqlFieldName = TUM_DiagnMethodCancer_DR ];

/// Des Ref CurrTreatment of Cancer
Property TUMCurrTreatmentCancerDR As MRCCancerTreatType [ SqlColumnNumber = 9, SqlFieldName = TUM_CurrTreatmentCancer_DR ];

/// Des Ref HistDeliv
Property TUMHistDelivDR As PACHistOfDeliv [ SqlColumnNumber = 10, SqlFieldName = TUM_HistDeliv_DR ];

/// Des Ref AdmissRoute
Property TUMAdmissRouteDR As MRCAdmissionRoute [ SqlColumnNumber = 11, SqlFieldName = TUM_AdmissRoute_DR ];

/// Des Ref HistoryTreatment
Property TUMHistoryTreatmentDR As MRCHistoryOfTreatment [ SqlColumnNumber = 12, SqlFieldName = TUM_HistoryTreatment_DR ];

/// Des Ref DegreeProgress
Property TUMDegreeProgressDR As MRCDegreeProgression [ SqlColumnNumber = 13, SqlFieldName = TUM_DegreeProgress_DR ];

/// Des Ref DegreeDifferent
Property TUMDegreeDifferentDR As MRCDegreeDifferent [ SqlColumnNumber = 14, SqlFieldName = TUM_DegreeDifferent_DR ];

/// Des Ref TumorType
Property TUMTumorTypeDR As MRCTumorType [ SqlColumnNumber = 15, SqlFieldName = TUM_TumorType_DR ];

/// Des Ref to CTZIP
Property TUMCTZIPDR As CTZip [ SqlColumnNumber = 16, SqlFieldName = TUM_CTZIP_DR ];

/// Des Ref Morphology
Property TUMMorphologyDR As MRCICDDx [ SqlColumnNumber = 17, SqlFieldName = TUM_Morphology_DR ];

/// Date of First Diag is Estimated
Property TUMDateFirstDiagEstimated As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = TUM_DateFirstDiagEstimated ];

/// Des Ref CityAtFirstDiag
Property TUMCityAtFirstDiagDR As CTCity [ SqlColumnNumber = 19, SqlFieldName = TUM_CityAtFirstDiag_DR ];

/// Des Ref ZipAtFirstDiag
Property TUMZipAtFirstDiagDR As CTZip [ SqlColumnNumber = 20, SqlFieldName = TUM_ZipAtFirstDiag_DR ];

/// Comments
Property TUMComments As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = TUM_Comments ];

/// Specify
Property TUMSpecify As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = TUM_Specify ];

/// Metastatic Site
Property TUMMetastaticSite As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = TUM_MetastaticSite ];

/// Histological Site
Property TUMHistologicalSite As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = TUM_HistologicalSite ];

/// Des Ref TreatingDoctor
Property TUMTreatingDoctorDR As CTCareProv [ SqlColumnNumber = 25, SqlFieldName = TUM_TreatingDoctor_DR ];

/// Des Ref LocalDoctor
Property TUMLocalDoctorDR As CTCareProv [ SqlColumnNumber = 26, SqlFieldName = TUM_LocalDoctor_DR ];

/// FirstAdmDate
Property TUMFirstAdmDate As %Date [ SqlColumnNumber = 27, SqlFieldName = TUM_FirstAdmDate ];

/// Des Ref LastUpdateUser
Property TUMLastUpdateUserDR As SSUser [ SqlColumnNumber = 28, SqlFieldName = TUM_LastUpdateUser_DR ];

/// LastUpdateDate
Property TUMLastUpdateDate As %Date [ SqlColumnNumber = 29, SqlFieldName = TUM_LastUpdateDate ];

/// LastUpdateTime
Property TUMLastUpdateTime As %Time [ SqlColumnNumber = 30, SqlFieldName = TUM_LastUpdateTime ];

/// Des Ref CancerReg
Property TUMCancerRegDR As PACancerReg [ SqlColumnNumber = 31, SqlFieldName = TUM_CancerReg_DR ];

/// Date of Recurrence
Property TUMDateRecurrence As %Date [ SqlColumnNumber = 32, SqlFieldName = TUM_DateRecurrence ];

/// Date of Metastatic Spread
Property TUMDateMetastatSpread As %Date [ SqlColumnNumber = 33, SqlFieldName = TUM_DateMetastatSpread ];

/// Morphology Text
Property TUMMorphologyText As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = TUM_MorphologyText ];

/// Des Ref Laterality
Property TUMLateralityDR As PACLaterality [ SqlColumnNumber = 35, SqlFieldName = TUM_Laterality_DR ];

/// Diagnosed Prior
Property TUMDiagnosedPrior As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = TUM_DiagnosedPrior ];

/// Diagnosed Where
Property TUMDiagnosedWhere As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = TUM_DiagnosedWhere ];

/// Des Ref CTLOC
Property TUMSpecialityDR As CTLoc [ SqlColumnNumber = 38, SqlFieldName = TUM_Speciality_DR ];

/// Registration At Screening
Property TUMRegistrationAtScreening As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = TUM_RegistrationAtScreening ];

/// Des Ref Hospital
Property TUMHospitalDR As CTHospital [ SqlColumnNumber = 40, SqlFieldName = TUM_Hospital_DR ];

/// UpdateDate
Property TUMUpdateDate As %Date [ SqlColumnNumber = 41, SqlFieldName = TUM_UpdateDate ];

/// UpdateTime
Property TUMUpdateTime As %Time [ SqlColumnNumber = 42, SqlFieldName = TUM_UpdateTime ];

/// Des Ref UpdateUser
Property TUMUpdateUserDR As SSUser [ SqlColumnNumber = 43, SqlFieldName = TUM_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property TUMUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 44, SqlFieldName = TUM_UpdateUserHospital_DR ];

/// Active
Property TUMActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = TUM_Active ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PATumor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumor","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PATumor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumor","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PATumor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumor","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PATumor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumor","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PATumor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumor","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PATUM(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TUM_Active">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="TUM_AdmissRoute_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TUM_CTZIP_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TUM_CancerReg_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="TUM_CityAtFirstDiag_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="TUM_Comments">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="TUM_CurrTreatmentCancer_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TUM_DateDeath">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TUM_DateFirstDiagEstimated">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="TUM_DateMetastatSpread">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="TUM_DateRecurrence">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="TUM_DegreeDifferent_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TUM_DegreeProgress_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TUM_DiagnMethodCancer_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TUM_DiagnosedPrior">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="TUM_DiagnosedWhere">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="TUM_FirstAdmDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="TUM_FirstDiagnosisDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TUM_FirstDiagnosisPlace_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TUM_HistDeliv_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TUM_HistologicalSite">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="TUM_HistoryTreatment_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TUM_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="TUM_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="TUM_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="TUM_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="TUM_Laterality_DR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="TUM_LocalDoctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="TUM_MetastaticSite">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="TUM_MorphologyText">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="TUM_Morphology_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TUM_PathologicDiagnosis_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TUM_PrimarySiteCancer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TUM_RegistrationAtScreening">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="TUM_Speciality_DR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="TUM_Specify">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="TUM_SurvivalPeriods">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TUM_TreatingDoctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="TUM_TumorType_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TUM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="TUM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="TUM_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="TUM_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="TUM_ZipAtFirstDiag_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^PATUM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TUM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{TUM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCancerReg">
<Global>^PATUM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TUM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Canc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TUM_CancerReg_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TUM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdDate">
<Global>^PATUM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TUM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UpdDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TUM_LastUpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TUM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TUM_RowId</SqlRowIdName>
<StreamLocation>^User.PATumorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
