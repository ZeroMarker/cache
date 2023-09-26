/// Person                  (PAPER,182)
Class User.PAPerson Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Person, StorageStrategy = SQLStorage ]
{

Relationship ChildPAPersonKeywords As PAPersonKeywords [ Cardinality = children, Inverse = KEYWParRef ];

Relationship ChildPATempAddress As PATempAddress [ Cardinality = children, Inverse = ADDRParRef ];

Relationship ChildPAPersonAlias As PAPersonAlias [ Cardinality = children, Inverse = ALIASParRef ];

Relationship ChildPAPersonSurnameAlias As PAPersonSurnameAlias [ Cardinality = children, Inverse = SURParRef ];

Relationship ChildPAPersonInsurance As PAPersonInsurance [ Cardinality = children, Inverse = INSParRef ];

Relationship ChildPAPersonOrganDonor As PAPersonOrganDonor [ Cardinality = children, Inverse = ORGParRef ];

Relationship ChildPAPersonCareProvider As PAPersonCareProvider [ Cardinality = children, Inverse = CPParRef ];

Relationship ChildPAPersonAdmInsurance As PAPersonAdmInsurance [ Cardinality = children, Inverse = PAINSParRef ];

Relationship ChildPAPersonTooth As PAPersonTooth [ Cardinality = children, Inverse = TOOTHParRef ];

Relationship ChildPAPersonRoyalOrder As PAPersonRoyalOrder [ Cardinality = children, Inverse = ROYALParRef ];

Relationship ChildPAPersonSchedule As PAPersonSchedule [ Cardinality = children, Inverse = SCHParRef ];

/// Person ID (ICPPBC)
Property PAPERID As %String(COLLATION = "AlphaUp", MAXLEN = 18, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PAPER_ID ];

/// Person Name
Property PAPERName As %String(COLLATION = "AlphaUp", MAXLEN = 80, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = PAPER_Name ];

/// Person Name 2
Property PAPERName2 As %String(COLLATION = "AlphaUp", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PAPER_Name2 ];

/// Soundex3
Property PAPERSoundex3 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PAPER_Soundex3 ];

/// Foreign Phone
Property PAPERForeignPhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PAPER_ForeignPhone ];

/// Person Date Of Birth
Property PAPERDob As %Date [ SqlColumnNumber = 11, SqlFieldName = PAPER_Dob ];

/// Age In Year
Property PAPERAgeYr As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlComputeCode = { s {PAPER_AgeYr}=$P({PAPER_Age},"|",12)
}, SqlComputed, SqlFieldName = PAPER_AgeYr, Transient ];

/// Age In Month
Property PAPERAgeMth As %String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlComputeCode = { s {PAPER_AgeMth}=$P({PAPER_Age},"|",13)
}, SqlComputed, SqlFieldName = PAPER_AgeMth, Transient ];

/// Age In Day
Property PAPERAgeDay As %String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlComputeCode = { s {PAPER_AgeDay}=$P({PAPER_Age},"|",14)
}, SqlComputed, SqlFieldName = PAPER_AgeDay, Transient ];

/// Des Ref to CTSEX
Property PAPERSexDR As CTSex [ Required, SqlColumnNumber = 15, SqlFieldName = PAPER_Sex_DR ];

/// Deceased
Property PAPERDeceased As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = PAPER_Deceased ];

/// Foreign City
Property PAPERForeignCity As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PAPER_ForeignCity ];

/// Foreign Post Code
Property PAPERForeignPostCode As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PAPER_ForeignPostCode ];

/// Des Ref to CTMAR
Property PAPERMaritalDR As CTMarital [ SqlColumnNumber = 20, SqlFieldName = PAPER_Marital_DR ];

/// Des Ref Education
Property PAPEREducationDR As CTEducation [ SqlColumnNumber = 21, SqlFieldName = PAPER_Education_DR ];

/// Des Ref to CTNAT
Property PAPERNationDR As CTNation [ SqlColumnNumber = 22, SqlFieldName = PAPER_Nation_DR ];

/// Des Ref to CTRLG
Property PAPERReligionDR As CTReligion [ SqlColumnNumber = 23, SqlFieldName = PAPER_Religion_DR ];

/// Des Ref to CTLAN
Property PAPERLangPrimDR As SSLanguage [ SqlColumnNumber = 24, SqlFieldName = PAPER_LangPrim_DR ];

/// Foreign Address
Property PAPERForeignAddress As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = PAPER_ForeignAddress ];

/// Soundex2
Property PAPERSoundex2 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = PAPER_Soundex2 ];

/// Person Street
Property PAPERStName As list Of %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = PAPER_StName, SqlListType = SUBNODE ];

/// Des Ref InsType
Property PAPERInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 31, SqlFieldName = PAPER_InsType_DR ];

/// Soundex1
Property PAPERSoundex1 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = PAPER_Soundex1 ];

/// Des Ref to CTCIT
Property PAPERCityCodeDR As CTCity [ SqlColumnNumber = 33, SqlFieldName = PAPER_CityCode_DR ];

/// Des Ref to CTSTT
Property PAPERStateCodeDR As CTState [ SqlColumnNumber = 34, SqlFieldName = PAPER_StateCode_DR ];

/// Des Ref to CTZIP
Property PAPERZipDR As CTZip [ SqlColumnNumber = 35, SqlFieldName = PAPER_Zip_DR ];

/// Telephone No(Office)
Property PAPERTelO As %String(COLLATION = "AlphaUp", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = PAPER_TelO ];

/// Des Ref Social Status
Property PAPERSocialStatusDR As CTSocialStatus [ SqlColumnNumber = 37, SqlFieldName = PAPER_SocialStatus_DR ];

/// Telephone No(Home)
Property PAPERTelH As %String(COLLATION = "AlphaUp", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = PAPER_TelH ];

/// Foreign Country
Property PAPERForeignCountry As %String(COLLATION = "AlphaUp", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = PAPER_ForeignCountry ];

/// Des Ref to CTCOU
Property PAPERCountryDR As CTCountry [ SqlColumnNumber = 55, SqlFieldName = PAPER_Country_DR ];

/// Insurance Card Owner
Property PAPERInsCardOwner As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 56, SqlFieldName = PAPER_InsCardOwner ];

/// Des Ref Occupation
Property PAPEROccupationDR As CTOccupation [ SqlColumnNumber = 57, SqlFieldName = PAPER_Occupation_DR ];

/// Des Ref Ref Doctor
Property PAPERFamilyDoctorDR As PACRefDoctor [ SqlColumnNumber = 67, SqlFieldName = PAPER_FamilyDoctor_DR ];

/// Remark
Property PAPERRemark As list Of %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 73, SqlFieldName = PAPER_Remark, SqlListType = SUBNODE ];

/// Deceased Date
Property PAPERDeceasedDate As %Date [ SqlColumnNumber = 74, SqlFieldName = PAPER_Deceased_Date ];

/// ForeignID
Property PAPERForeignId As %String(COLLATION = "AlphaUp", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 75, SqlFieldName = PAPER_ForeignId ];

/// Des Ref to 国籍/地区(现住)
Property PAPERCountryBirthDR As CTCountry [ SqlColumnNumber = 77, SqlFieldName = PAPER_Country_Birth_DR ];

/// Estimated Age in Year
Property PAPEREstAgeYear As %Float(MAXVAL = 999, MINVAL = 1) [ SqlColumnNumber = 79, SqlFieldName = PAPER_EstAgeYear ];

/// Estimated Age in Month
Property PAPEREstAgeMonth As %Float(MAXVAL = 99, MINVAL = 1) [ SqlColumnNumber = 80, SqlFieldName = PAPER_EstAgeMonth ];

/// Estimate Age Time Stamp
Property PAPEREstAgeTmStmp As %Date [ SqlColumnNumber = 81, SqlFieldName = PAPER_EstAgeTmStmp ];

/// Deceased Time
Property PAPERDeceasedTime As %Time [ SqlColumnNumber = 82, SqlFieldName = PAPER_DeceasedTime ];

/// Des Ref Region
Property PAPERRegionBirthDR As CTRegion [ SqlColumnNumber = 83, SqlFieldName = PAPER_RegionBirth_DR ];

/// Des Ref to ARC_Debtor
Property PAPERDebtorDR As ARCDebtor [ SqlColumnNumber = 84, SqlFieldName = PAPER_Debtor_DR ];

/// Age External
Property PAPERAge As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 85, SqlComputeCode = { s {PAPER_Age}=$$CalAge^at182({PAPER_Dob},+$H,{PAPER_EstAgeMonth},{PAPER_EstAgeYear},{PAPER_EstAgeTmStmp})
}, SqlComputed, SqlFieldName = PAPER_Age, Transient ];

/// Insurance Card Holder
Property PAPERInsuranceCardHolder As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 86, SqlFieldName = PAPER_InsuranceCardHolder ];

/// Sur Name (Computered)
Property PAPERSurName As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 87, SqlComputeCode = { i $L({PAPER_Name}," ")'>1 s {PAPER_SurName}="" q
 S {PAPER_SurName}=$P({PAPER_Name}," ",2,9)
}, SqlComputed, SqlFieldName = PAPER_SurName, Transient ];

/// Line 1 of St Name
Property PAPERStNameLine1 As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 88, SqlComputeCode = { s {PAPER_StNameLine1}=$s({PAPER_StName}'="":$li({PAPER_StName},1),1:"")
}, SqlComputed, SqlFieldName = PAPER_StNameLine1, Transient ];

/// Des Ref Province of Birth
Property PAPERProvinceBirthDR As CTProvince [ SqlColumnNumber = 89, SqlFieldName = PAPER_Province_Birth_DR ];

/// Des Ref EmplType
Property PAPEREmplTypeDR As PACEmployeeType [ SqlColumnNumber = 90, SqlFieldName = PAPER_EmplType_DR ];

/// Job Title
Property PAPERJobTitle As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 91, SqlFieldName = PAPER_JobTitle ];

/// Employee Related To
Property PAPEREmplRelatedTo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 92, SqlFieldName = PAPER_EmplRelatedTo ];

/// Des Ref CTRLT
Property PAPERCTRLTDR As CTRelation [ SqlColumnNumber = 93, SqlFieldName = PAPER_CTRLT_DR ];

/// Employee No
Property PAPEREmployeeNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 94, SqlFieldName = PAPER_EmployeeNo ];

/// Des Ref to CTLOC
Property PAPEREmplDepDR As CTLoc [ SqlColumnNumber = 95, SqlFieldName = PAPER_EmplDep_DR ];

/// Discount Date From
Property PAPERDiscDateFrom As %Date [ SqlColumnNumber = 96, SqlFieldName = PAPER_DiscDateFrom ];

/// Discount Date To
Property PAPERDiscDateTo As %Date [ SqlColumnNumber = 97, SqlFieldName = PAPER_DiscDateTo ];

/// Des Ref DiscType
Property PAPERDiscTypeDR As ARCDiscType [ SqlColumnNumber = 98, SqlFieldName = PAPER_DiscType_DR ];

/// Outstanding Amt
Property PAPEROutstandAmt As %Float [ SqlColumnNumber = 99, SqlFieldName = PAPER_OutstandAmt ];

/// Employee Function
Property PAPEREmployeeFunction As CTEmpFunc [ SqlColumnNumber = 100, SqlFieldName = PAPER_EmployeeFunction ];

/// Company the person works for
Property PAPEREmployeeCompany As CTCompany [ SqlColumnNumber = 101, SqlFieldName = PAPER_EmployeeCompany ];

/// Contract with the employees company
Property PAPEREmployeeCoContract As CTCompanyContract [ SqlColumnNumber = 102, SqlFieldName = PAPER_EmployeeCoContract ];

/// Des Ref PAPER
Property PAPERGuardian1DR As PAPerson [ SqlColumnNumber = 103, SqlFieldName = PAPER_Guardian1_DR ];

/// Des Ref PAPER
Property PAPERGuardian2DR As PAPerson [ SqlColumnNumber = 104, SqlFieldName = PAPER_Guardian2_DR ];

/// Outstanding Date
Property PAPEROutstandingDate As %Date [ SqlColumnNumber = 105, SqlFieldName = PAPER_OutstandingDate ];

/// Expected Pay Date
Property PAPERExpectedPayDate As %Date [ SqlColumnNumber = 106, SqlFieldName = PAPER_ExpectedPayDate ];

/// Bill Code
Property PAPERBillCode As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 107, SqlFieldName = PAPER_BillCode ];

/// Next of Kin Name
Property PAPERNokName As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 108, SqlFieldName = PAPER_NokName ];

/// Next of Kin Phone
Property PAPERNokPhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 109, SqlFieldName = PAPER_NokPhone ];

/// Next of Kin Text
Property PAPERNokText As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 110, SqlFieldName = PAPER_NokText ];

/// Des Ref CTRLT
Property PAPERNokCTRLTDR As CTRelation [ SqlColumnNumber = 111, SqlFieldName = PAPER_NokCTRLT_DR ];

/// Des Ref CT_Region
Property PAPERCTRegionDR As CTRegion [ SqlColumnNumber = 112, SqlFieldName = PAPER_CT_Region_DR ];

/// Des Ref CT_Province
Property PAPERCTProvinceDR As CTProvince [ SqlColumnNumber = 113, SqlFieldName = PAPER_CT_Province_DR ];

/// Des Ref CT_HCA
Property PAPERCTHCADR As CTHealthCareArea [ SqlColumnNumber = 114, SqlFieldName = PAPER_CT_HCA_DR ];

/// Des Ref CityBirth
Property PAPERCityBirthDR As CTCity [ SqlColumnNumber = 115, SqlFieldName = PAPER_CityBirth_DR ];

/// Patient Name3
Property PAPERName3 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 118, SqlFieldName = PAPER_Name3 ];

/// Government Card No
Property PAPERGovernCardNo As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 119, SqlFieldName = PAPER_GovernCardNo ];

/// From This Area
Property PAPERFromThisArea As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 120, SqlFieldName = PAPER_FromThisArea ];

/// ForeignNotes
Property PAPERForeignNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 121, SqlFieldName = PAPER_ForeignNotes, SqlListType = SUBNODE ];

/// Reason For Change Data
Property PAPERReasonForChangeData As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 122, SqlFieldName = PAPER_ReasonForChangeData ];

/// UserUpdate
Property PAPERUserUpdate As SSUser [ SqlColumnNumber = 123, SqlFieldName = PAPER_UserUpdate ];

/// Exemption Number
Property PAPERExemptionNumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 124, SqlFieldName = PAPER_ExemptionNumber ];

/// Des Ref CityArea
Property PAPERCityAreaDR As CTCityArea [ SqlColumnNumber = 125, SqlFieldName = PAPER_CityArea_DR ];

/// Complement
Property PAPERComplement As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 126, SqlFieldName = PAPER_Complement ];

/// Responsible For Payment
Property PAPERResponsibleForPayment As PAPerson [ SqlColumnNumber = 127, SqlFieldName = PAPER_ResponsibleForPayment ];

/// Des Ref Mother
Property PAPERMotherDR As PAPerson [ SqlColumnNumber = 128, SqlFieldName = PAPER_Mother_DR ];

/// Des REf Father
Property PAPERFatherDR As PAPerson [ SqlColumnNumber = 129, SqlFieldName = PAPER_Father_DR ];

/// Des Ref FamilyGroup
Property PAPERFamilyGroupDR As PACFamilyGroup [ SqlColumnNumber = 130, SqlFieldName = PAPER_FamilyGroup_DR ];

/// Discret OutsType
Property PAPERDiscretOutsTypeDR As ARCDisretOutstType [ SqlColumnNumber = 131, SqlFieldName = PAPER_DiscretOutsType_DR ];

/// Des Ref HCP
Property PAPERHCPDR As CTHealthCareProvider [ SqlColumnNumber = 132, SqlFieldName = PAPER_HCP_DR ];

/// Second Phone
Property PAPERSecondPhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 133, SqlFieldName = PAPER_SecondPhone ];

/// Nok Address
Property PAPERNokAddress1 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 134, SqlFieldName = PAPER_NokAddress1 ];

/// Des Ref City
Property PAPERNokCityDR As CTCity [ SqlColumnNumber = 135, SqlFieldName = PAPER_NokCity_DR ];

/// Des Ref NZip
Property PAPERNokZipDR As CTZip [ SqlColumnNumber = 136, SqlFieldName = PAPER_NokZip_DR ];

/// NokAddress2
Property PAPERNokAddress2 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 137, SqlFieldName = PAPER_NokAddress2 ];

/// Email
Property PAPEREmail As %String(COLLATION = "Exact", MAXLEN = 70, TRUNCATE = 1) [ SqlColumnNumber = 138, SqlFieldName = PAPER_Email ];

/// Des Ref Title
Property PAPERTitleDR As CTTitle [ SqlColumnNumber = 139, SqlFieldName = PAPER_Title_DR ];

/// MobPhone
Property PAPERMobPhone As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 140, SqlFieldName = PAPER_MobPhone ];

/// Des Ref IndigStat
Property PAPERIndigStatDR As PACIndigStatus [ SqlColumnNumber = 141, SqlFieldName = PAPER_IndigStat_DR ];

/// Des Ref AuxInsType
Property PAPERAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 142, SqlFieldName = PAPER_AuxInsType_DR ];

/// Des Ref PrefLanguage
Property PAPERPrefLanguageDR As PACPreferredLanguage [ SqlColumnNumber = 143, SqlFieldName = PAPER_PrefLanguage_DR ];

/// Des Ref PatType
Property PAPERPatTypeDR As PACPatientType [ SqlColumnNumber = 144, SqlFieldName = PAPER_PatType_DR ];

/// Update Date
Property PAPERUpdateDate As %Date [ SqlColumnNumber = 145, SqlFieldName = PAPER_UpdateDate ];

/// Update Time
Property PAPERUpdateTime As %Time [ SqlColumnNumber = 146, SqlFieldName = PAPER_UpdateTime ];

/// GLFlag
Property PAPERGLFlag As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 147, SqlFieldName = PAPER_GLFlag ];

/// Des Ref FamilyDoctorClinic
Property PAPERFamilyDoctorClinicDR As PACRefDoctorClinic [ SqlColumnNumber = 148, SqlFieldName = PAPER_FamilyDoctorClinic_DR ];

/// Donated Organs On Death
Property PAPERDonatedOrgansOnDeath As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 149, SqlFieldName = PAPER_DonatedOrgansOnDeath ];

/// Who Notified about death
Property PAPERWhoNotified As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 150, SqlFieldName = PAPER_WhoNotified ];

/// Location Of Death
Property PAPERLocationOfDeath As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 151, SqlFieldName = PAPER_LocationOfDeath ];

/// PAPEstDOB
Property PAPEREstDOB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 152, SqlFieldName = PAPER_EstDOB ];

/// Staying Permanently
Property PAPERStayingPermanently As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 153, SqlFieldName = PAPER_StayingPermanently ];

/// Date Of Entry
Property PAPERDateOfEntry As %Date [ SqlColumnNumber = 154, SqlFieldName = PAPER_DateOfEntry ];

/// Des Ref Country 国籍/地区(籍贯)
Property PAPERCountryCameFromDR As CTCountry [ SqlColumnNumber = 155, SqlFieldName = PAPER_CountryCameFrom_DR ];

/// National Resident
Property PAPERNationalResident As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 156, SqlFieldName = PAPER_NationalResident ];

/// Des Ref OSVStatus
Property PAPEROSVStatusDR As PACOSVisitorStatus [ SqlColumnNumber = 157, SqlFieldName = PAPER_OSVStatus_DR ];

/// Interviewed By
Property PAPERInterviewedBy As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 158, SqlFieldName = PAPER_InterviewedBy ];

/// Date Of Interview
Property PAPERDateOfInterview As %Date [ SqlColumnNumber = 159, SqlFieldName = PAPER_DateOfInterview ];

/// DateAdded
Property PAPERDateAdded As %Date [ SqlColumnNumber = 160, SqlFieldName = PAPER_DateAdded ];

/// Des Ref UserAdded_DR
Property PAPERUserAddedDR As SSUser [ SqlColumnNumber = 161, SqlFieldName = PAPER_UserAdded_DR ];

/// Des Ref PAPER_PAPMI_DR
Property PAPERPAPMIDR As PAPatMas [ SqlColumnNumber = 162, SqlComputeCode = { s {PAPER_PAPMI_DR}=$s($d(^PAPER({PAPER_RowId})):{PAPER_RowId},1:"")
}, SqlComputed, SqlFieldName = PAPER_PAPMI_DR, Transient ];

/// NOK Business Phone
Property PAPERNOKBusPhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 163, SqlFieldName = PAPER_NOKBusPhone ];

/// Des Ref Hospital
Property PAPERLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 164, SqlFieldName = PAPER_LastUpdateHospital_DR ];

/// Des Ref DoctorDeclared as deceased
Property PAPERDoctorDeclaredDR As CTCareProv [ SqlColumnNumber = 165, SqlFieldName = PAPER_DoctorDeclared_DR ];

/// NOKInformed
Property PAPERNOKInformed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 166, SqlFieldName = PAPER_NOKInformed ];

/// Procurator Fiscal Informed
Property PAPERProcuratorFiscalInformed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 167, SqlFieldName = PAPER_ProcuratorFiscalInformed ];

/// Interpreter Required
Property PAPERInterpreterRequired As %String(DISPLAYLIST = ",Yes,No,Not Stated", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N,NS") [ SqlColumnNumber = 168, SqlFieldName = PAPER_InterpreterRequired ];

/// Prev HACC Eligible
Property PAPERPrevHACCEligible As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 169, SqlFieldName = PAPER_PrevHACCEligible ];

/// Des Ref Resource
Property PAPERUsualRoundDR As RBResource [ SqlColumnNumber = 170, SqlFieldName = PAPER_UsualRound_DR ];

/// Des Ref EmploymentStat
Property PAPEREmploymentStatDR As PACEmploymentStatus [ SqlColumnNumber = 171, SqlFieldName = PAPER_EmploymentStat_DR ];

/// Des Ref SourceOfIncome
Property PAPERSourceOfIncomeDR As PACSourceOfIncome [ SqlColumnNumber = 172, SqlFieldName = PAPER_SourceOfIncome_DR ];

/// Des Ref LivingArrangement
Property PAPERLivingArrangementDR As PACLivingArrangement [ SqlColumnNumber = 173, SqlFieldName = PAPER_LivingArrangement_DR ];

/// Des Ref ResidenceStatus
Property PAPERResidenceStatusDR As PACResidenceStatus [ SqlColumnNumber = 174, SqlFieldName = PAPER_ResidenceStatus_DR ];

/// Des Ref TransportUsed
Property PAPERTransportUsedDR As PACTransportUsed [ SqlColumnNumber = 175, SqlFieldName = PAPER_TransportUsed_DR ];

/// CancerReg
Property PAPERCancerReg As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 176, SqlFieldName = PAPER_CancerReg ];

/// Des Ref Blood type
Property PAPERBloodTypeDR As PACBloodType [ SqlColumnNumber = 177, SqlFieldName = PAPER_BloodType_DR ];

/// EffDateCurrAddress
Property PAPEREffDateCurrAddress As %Date [ SqlColumnNumber = 178, SqlFieldName = PAPER_EffDateCurrAddress ];

/// FeedBackConsent
Property PAPERFeedBackConsent As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 179, SqlFieldName = PAPER_FeedBackConsent ];

/// Des Ref AusSouthSeaIslander
Property PAPERAusSouthSeaIslanderDR As PACAusSouthSeaIslander [ SqlColumnNumber = 180, SqlFieldName = PAPER_AusSouthSeaIslander_DR ];

/// Occupation
Property PAPEROccupation As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 181, SqlFieldName = PAPER_Occupation ];

/// Incomplete Registration
Property PAPERIncompleteRegistration As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 182, SqlFieldName = PAPER_IncompleteRegistration ];

/// FamilyLinkText
Property PAPERFamilyLinkText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 183, SqlFieldName = PAPER_FamilyLinkText, SqlListType = SUBNODE ];

/// DVAExpiryDate
Property PAPERDVAExpiryDate As %Date [ SqlColumnNumber = 184, SqlFieldName = PAPER_DVAExpiryDate ];

/// PensionCardExpiryDate
Property PAPERPensionCardExpiryDate As %Date [ SqlColumnNumber = 185, SqlFieldName = PAPER_PensionCardExpiryDate ];

/// ReversedBy
Property PAPERReversedBy As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 186, SqlFieldName = PAPER_ReversedBy ];

/// Des Ref Hospital
Property PAPERHospitalDR As CTHospital [ SqlColumnNumber = 187, SqlFieldName = PAPER_Hospital_DR ];

/// Name4
Property PAPERName4 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 188, SqlFieldName = PAPER_Name4 ];

/// Name5
Property PAPERName5 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 189, SqlFieldName = PAPER_Name5 ];

/// Name6
Property PAPERName6 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 190, SqlFieldName = PAPER_Name6 ];

/// Name7
Property PAPERName7 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 191, SqlFieldName = PAPER_Name7 ];

/// Name8
Property PAPERName8 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 192, SqlFieldName = PAPER_Name8 ];

/// DentalDisplay
Property PAPERDentalDisplay As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 193, SqlFieldName = PAPER_DentalDisplay ];

/// FeedbackConsentDate
Property PAPERFeedbackConsentDate As %Date [ SqlColumnNumber = 194, SqlFieldName = PAPER_FeedbackConsentDate ];

/// Address2
Property PAPERAddress2 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 195, SqlFieldName = PAPER_Address2 ];

/// PassportNumber
Property PAPERPassportNumber As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 196, SqlFieldName = PAPER_PassportNumber ];

/// Des Ref DependChildren
Property PAPERDependChildrenDR As PACDependentChildren [ SqlColumnNumber = 197, SqlFieldName = PAPER_DependChildren_DR ];

/// PreferredContactMethod
Property PAPERPreferredContactMethod As %String(DISPLAYLIST = ",Post,Email,Fax,Phone", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",P,E,F,M") [ SqlColumnNumber = 198, SqlFieldName = PAPER_PreferredContactMethod ];

/// ContactNotes
Property PAPERContactNotes As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 200, SqlFieldName = PAPER_ContactNotes ];

/// Des Ref Accom Setting
Property PAPERAccomSettingDR As PACAccomSetting [ SqlColumnNumber = 201, SqlFieldName = PAPER_AccomSetting_DR ];

/// Photo
Property PAPERPhoto As %String(COLLATION = "Exact", MAXLEN = 100000, TRUNCATE = 1) [ SqlColumnNumber = 202, SqlFieldName = PAPER_Photo ];

/// PDSSerialNumber
Property PAPERPDSSerialNumber As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 203, SqlFieldName = PAPER_PDSSerialNumber ];

/// EmployeeDateFrom
Property PAPEREmployeeDateFrom As %Date [ SqlColumnNumber = 204, SqlFieldName = PAPER_EmployeeDateFrom ];

/// Employee DateTo
Property PAPEREmployeeDateTo As %Date [ SqlColumnNumber = 205, SqlFieldName = PAPER_EmployeeDateTo ];

/// EmployeeGrade
Property PAPEREmployeeGrade As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 206, SqlFieldName = PAPER_EmployeeGrade ];

/// House building_No
Property PAPERHouseBuildingNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 207, SqlFieldName = PAPER_House_Building_No ];

/// AppartmentNo
Property PAPERAppartmentNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 208, SqlFieldName = PAPER_AppartmentNo ];

/// Gravida
Property PAPERGravida As %Float [ SqlColumnNumber = 209, SqlFieldName = PAPER_Gravida ];

/// Para
Property PAPERPara As %Float [ SqlColumnNumber = 210, SqlFieldName = PAPER_Para ];

/// Miscarriage
Property PAPERMiscarriage As %Float [ SqlColumnNumber = 211, SqlFieldName = PAPER_Miscarriage ];

/// TOP
Property PAPERTOP As %Float [ SqlColumnNumber = 212, SqlFieldName = PAPER_TOP ];

/// PreTerm
Property PAPERPreTerm As %Float [ SqlColumnNumber = 213, SqlFieldName = PAPER_PreTerm ];

/// MultBirth
Property PAPERMultBirth As %Float [ SqlColumnNumber = 214, SqlFieldName = PAPER_MultBirth ];

/// LivingChild
Property PAPERLivingChild As %Float [ SqlColumnNumber = 215, SqlFieldName = PAPER_LivingChild ];

/// Des Ref SpecNeedStat
Property PAPERSpecNeedStatDR As PACSpecialNeedsStatus [ SqlColumnNumber = 216, SqlFieldName = PAPER_SpecNeedStat_DR ];

/// SpecNeedStatLastReviewDate
Property PAPERSNSLastReviewDate As %Date [ SqlColumnNumber = 217, SqlFieldName = PAPER_SNSLastReviewDate ];

/// SNSNextReviewDate
Property PAPERSNSNextReviewDate As %Date [ SqlColumnNumber = 218, SqlFieldName = PAPER_SNSNextReviewDate ];

/// SNSLastLiveUpdDate
Property PAPERSNSLastLiveUpdDate As %Date [ SqlColumnNumber = 219, SqlFieldName = PAPER_SNSLastLiveUpdDate ];

/// PostCode
Property PAPERPostCode As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 220, SqlFieldName = PAPER_PostCode ];

/// Des Ref IDDocType
Property PAPERIDDocTypeDR As PACIDDocType [ SqlColumnNumber = 221, SqlFieldName = PAPER_IDDocType_DR ];

/// DocNumber
Property PAPERDocNumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 222, SqlFieldName = PAPER_DocNumber ];

/// ChineseName
Property PAPERChineseName As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 223, SqlFieldName = PAPER_ChineseName ];

/// NoChinName
Property PAPERNoChinName As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 224, SqlFieldName = PAPER_NoChinName ];

/// CCC1
Property PAPERCCC1 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 225, SqlFieldName = PAPER_CCC1 ];

/// CCC2
Property PAPERCCC2 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 226, SqlFieldName = PAPER_CCC2 ];

/// CCC3
Property PAPERCCC3 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 227, SqlFieldName = PAPER_CCC3 ];

/// CCC4
Property PAPERCCC4 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 228, SqlFieldName = PAPER_CCC4 ];

/// CCC5
Property PAPERCCC5 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 229, SqlFieldName = PAPER_CCC5 ];

/// CCC6
Property PAPERCCC6 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 230, SqlFieldName = PAPER_CCC6 ];

/// ChineseAddress
Property PAPERChineseAddress As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 231, SqlFieldName = PAPER_ChineseAddress ];

/// ChineseDistrict
Property PAPERChineseDistrict As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 232, SqlFieldName = PAPER_ChineseDistrict ];

/// ChineseArea
Property PAPERChineseArea As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 233, SqlFieldName = PAPER_ChineseArea ];

/// Pager
Property PAPERPager As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 234, SqlFieldName = PAPER_Pager ];

/// Fax
Property PAPERFax As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 235, SqlFieldName = PAPER_Fax ];

/// PhotoDocument
Property PAPERPhotoDocument As websys.Document [ SqlColumnNumber = 236, SqlFieldName = PAPER_PhotoDocument ];

/// Email2
Property PAPEREmail2 As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 237, SqlFieldName = PAPER_Email2 ];

/// Des Ref CardType
Property PAPERForeignCardTypeDR As PACCardType [ SqlColumnNumber = 238, SqlFieldName = PAPER_ForeignCardTypeDR ];

/// Des Ref CityArea
Property PAPERAreaHomeDR As CTCityArea [ SqlColumnNumber = 239, SqlFieldName = PAPER_AreaHome_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPerson).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPerson","OnAfterInsert")
 d Table^HL7Outbound("PAPerson",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPerson).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPerson","OnAfterUpdate")
 d Table^HL7Outbound("PAPerson",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPerson).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPerson","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPerson).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPerson","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPerson","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPerson).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPerson","OnAfterDelete")
 d Table^HL7Outbound("PAPerson",%old(1),"Delete")
}

Parameter EXTENTSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SqlIdExpression>$i(^PAPER(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PAPER_AccomSetting_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>4</Piece>
</Data>
<Data name="PAPER_Address2">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>44</Piece>
</Data>
<Data name="PAPER_AppartmentNo">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>11</Piece>
</Data>
<Data name="PAPER_AreaHome_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>41</Piece>
</Data>
<Data name="PAPER_AusSouthSeaIslander_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>35</Piece>
</Data>
<Data name="PAPER_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>23</Piece>
</Data>
<Data name="PAPER_BillCode">
<Delimiter>"^"</Delimiter>
<Node>"PER",3</Node>
<Piece>9</Piece>
</Data>
<Data name="PAPER_BloodType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>32</Piece>
</Data>
<Data name="PAPER_CCC1">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>28</Piece>
</Data>
<Data name="PAPER_CCC2">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>29</Piece>
</Data>
<Data name="PAPER_CCC3">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>30</Piece>
</Data>
<Data name="PAPER_CCC4">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>31</Piece>
</Data>
<Data name="PAPER_CCC5">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>32</Piece>
</Data>
<Data name="PAPER_CCC6">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>33</Piece>
</Data>
<Data name="PAPER_CTRLT_DR">
<Delimiter>"^"</Delimiter>
<Node>"EMP"</Node>
<Piece>4</Piece>
</Data>
<Data name="PAPER_CT_HCA_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>3</Piece>
</Data>
<Data name="PAPER_CT_Province_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPER_CT_Region_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPER_CancerReg">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>31</Piece>
</Data>
<Data name="PAPER_ChineseAddress">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>34</Piece>
</Data>
<Data name="PAPER_ChineseArea">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>36</Piece>
</Data>
<Data name="PAPER_ChineseDistrict">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>35</Piece>
</Data>
<Data name="PAPER_ChineseName">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>26</Piece>
</Data>
<Data name="PAPER_CityArea_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>9</Piece>
</Data>
<Data name="PAPER_CityBirth_DR">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>18</Piece>
</Data>
<Data name="PAPER_CityCode_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",1</Node>
<Piece>5</Piece>
</Data>
<Data name="PAPER_Complement">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>10</Piece>
</Data>
<Data name="PAPER_ContactNotes">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>3</Piece>
</Data>
<Data name="PAPER_CountryCameFrom_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>12</Piece>
</Data>
<Data name="PAPER_Country_Birth_DR">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>11</Piece>
</Data>
<Data name="PAPER_Country_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",1</Node>
<Piece>8</Piece>
</Data>
<Data name="PAPER_DVAExpiryDate">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>38</Piece>
</Data>
<Data name="PAPER_DateAdded">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>17</Piece>
</Data>
<Data name="PAPER_DateOfEntry">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>11</Piece>
</Data>
<Data name="PAPER_DateOfInterview">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>16</Piece>
</Data>
<Data name="PAPER_Debtor_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",2</Node>
<Piece>9</Piece>
</Data>
<Data name="PAPER_Deceased">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>12</Piece>
</Data>
<Data name="PAPER_DeceasedTime">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>8</Piece>
</Data>
<Data name="PAPER_Deceased_Date">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>13</Piece>
</Data>
<Data name="PAPER_DentalDisplay">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>42</Piece>
</Data>
<Data name="PAPER_DependChildren_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPER_DiscDateFrom">
<Delimiter>"^"</Delimiter>
<Node>"EMP"</Node>
<Piece>7</Piece>
</Data>
<Data name="PAPER_DiscDateTo">
<Delimiter>"^"</Delimiter>
<Node>"EMP"</Node>
<Piece>8</Piece>
</Data>
<Data name="PAPER_DiscType_DR">
<Delimiter>"^"</Delimiter>
<Node>"EMP"</Node>
<Piece>9</Piece>
</Data>
<Data name="PAPER_DiscretOutsType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>16</Piece>
</Data>
<Data name="PAPER_Dob">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>6</Piece>
</Data>
<Data name="PAPER_DocNumber">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>25</Piece>
</Data>
<Data name="PAPER_DoctorDeclared_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>20</Piece>
</Data>
<Data name="PAPER_DonatedOrgansOnDeath">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>6</Piece>
</Data>
<Data name="PAPER_Education_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",2</Node>
<Piece>5</Piece>
</Data>
<Data name="PAPER_EffDateCurrAddress">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>33</Piece>
</Data>
<Data name="PAPER_Email">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>19</Piece>
</Data>
<Data name="PAPER_Email2">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>40</Piece>
</Data>
<Data name="PAPER_EmplDep_DR">
<Delimiter>"^"</Delimiter>
<Node>"EMP"</Node>
<Piece>6</Piece>
</Data>
<Data name="PAPER_EmplRelatedTo">
<Delimiter>"^"</Delimiter>
<Node>"EMP"</Node>
<Piece>3</Piece>
</Data>
<Data name="PAPER_EmplType_DR">
<Delimiter>"^"</Delimiter>
<Node>"EMP"</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPER_EmployeeCoContract">
<Delimiter>"^"</Delimiter>
<Node>"PER",3</Node>
<Piece>4</Piece>
</Data>
<Data name="PAPER_EmployeeCompany">
<Delimiter>"^"</Delimiter>
<Node>"PER",3</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPER_EmployeeDateFrom">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>7</Piece>
</Data>
<Data name="PAPER_EmployeeDateTo">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>8</Piece>
</Data>
<Data name="PAPER_EmployeeFunction">
<Delimiter>"^"</Delimiter>
<Node>"PER",3</Node>
<Piece>3</Piece>
</Data>
<Data name="PAPER_EmployeeGrade">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>9</Piece>
</Data>
<Data name="PAPER_EmployeeNo">
<Delimiter>"^"</Delimiter>
<Node>"EMP"</Node>
<Piece>5</Piece>
</Data>
<Data name="PAPER_EmploymentStat_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>26</Piece>
</Data>
<Data name="PAPER_EstAgeMonth">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>16</Piece>
</Data>
<Data name="PAPER_EstAgeTmStmp">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>17</Piece>
</Data>
<Data name="PAPER_EstAgeYear">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>15</Piece>
</Data>
<Data name="PAPER_EstDOB">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>9</Piece>
</Data>
<Data name="PAPER_ExemptionNumber">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>8</Piece>
</Data>
<Data name="PAPER_ExpectedPayDate">
<Delimiter>"^"</Delimiter>
<Node>"PER",3</Node>
<Piece>8</Piece>
</Data>
<Data name="PAPER_FamilyDoctorClinic_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>5</Piece>
</Data>
<Data name="PAPER_FamilyDoctor_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",2</Node>
<Piece>7</Piece>
</Data>
<Data name="PAPER_FamilyGroup_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>15</Piece>
</Data>
<Data name="PAPER_FamilyLinkText">
<Node>"FLT"</Node>
</Data>
<Data name="PAPER_Father_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>12</Piece>
</Data>
<Data name="PAPER_Fax">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>38</Piece>
</Data>
<Data name="PAPER_FeedBackConsent">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>34</Piece>
</Data>
<Data name="PAPER_FeedbackConsentDate">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>43</Piece>
</Data>
<Data name="PAPER_ForeignAddress">
<Delimiter>"^"</Delimiter>
<Node>"PER",1</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPER_ForeignCardTypeDR">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>25</Piece>
</Data>
<Data name="PAPER_ForeignCity">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>5</Piece>
</Data>
<Data name="PAPER_ForeignCountry">
<Delimiter>"^"</Delimiter>
<Node>"PER",2</Node>
<Piece>4</Piece>
</Data>
<Data name="PAPER_ForeignId">
<Delimiter>"^"</Delimiter>
<Node>"PER",2</Node>
<Piece>13</Piece>
</Data>
<Data name="PAPER_ForeignNotes">
<Node>"FNOTES"</Node>
</Data>
<Data name="PAPER_ForeignPhone">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>4</Piece>
</Data>
<Data name="PAPER_ForeignPostCode">
<Delimiter>"^"</Delimiter>
<Node>"PER",2</Node>
<Piece>8</Piece>
</Data>
<Data name="PAPER_FromThisArea">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>6</Piece>
</Data>
<Data name="PAPER_GLFlag">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>4</Piece>
</Data>
<Data name="PAPER_GovernCardNo">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>4</Piece>
</Data>
<Data name="PAPER_Gravida">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>12</Piece>
</Data>
<Data name="PAPER_Guardian1_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",3</Node>
<Piece>5</Piece>
</Data>
<Data name="PAPER_Guardian2_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",3</Node>
<Piece>6</Piece>
</Data>
<Data name="PAPER_HCP_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>17</Piece>
</Data>
<Data name="PAPER_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>41</Piece>
</Data>
<Data name="PAPER_House_Building_No">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>10</Piece>
</Data>
<Data name="PAPER_ID">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>9</Piece>
</Data>
<Data name="PAPER_IDDocType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>24</Piece>
</Data>
<Data name="PAPER_IncompleteRegistration">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>37</Piece>
</Data>
<Data name="PAPER_IndigStat_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>22</Piece>
</Data>
<Data name="PAPER_InsCardOwner">
<Delimiter>"^"</Delimiter>
<Node>"PER",2</Node>
<Piece>10</Piece>
</Data>
<Data name="PAPER_InsType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",1</Node>
<Piece>3</Piece>
</Data>
<Data name="PAPER_InsuranceCardHolder">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>5</Piece>
</Data>
<Data name="PAPER_InterpreterRequired">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>23</Piece>
</Data>
<Data name="PAPER_InterviewedBy">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>15</Piece>
</Data>
<Data name="PAPER_JobTitle">
<Delimiter>"^"</Delimiter>
<Node>"EMP"</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPER_LangPrim_DR">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>10</Piece>
</Data>
<Data name="PAPER_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>19</Piece>
</Data>
<Data name="PAPER_LivingArrangement_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>28</Piece>
</Data>
<Data name="PAPER_LivingChild">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>18</Piece>
</Data>
<Data name="PAPER_LocationOfDeath">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>8</Piece>
</Data>
<Data name="PAPER_Marital_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",2</Node>
<Piece>3</Piece>
</Data>
<Data name="PAPER_Miscarriage">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>14</Piece>
</Data>
<Data name="PAPER_MobPhone">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>21</Piece>
</Data>
<Data name="PAPER_Mother_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>13</Piece>
</Data>
<Data name="PAPER_MultBirth">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>17</Piece>
</Data>
<Data name="PAPER_NOKBusPhone">
<Delimiter>"^"</Delimiter>
<Node>"NOK"</Node>
<Piece>9</Piece>
</Data>
<Data name="PAPER_NOKInformed">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>21</Piece>
</Data>
<Data name="PAPER_Name">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPER_Name2">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPER_Name3">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>19</Piece>
</Data>
<Data name="PAPER_Name4">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>20</Piece>
</Data>
<Data name="PAPER_Name5">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>21</Piece>
</Data>
<Data name="PAPER_Name6">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>22</Piece>
</Data>
<Data name="PAPER_Name7">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>23</Piece>
</Data>
<Data name="PAPER_Name8">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>24</Piece>
</Data>
<Data name="PAPER_Nation_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",2</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPER_NationalResident">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>13</Piece>
</Data>
<Data name="PAPER_NoChinName">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>27</Piece>
</Data>
<Data name="PAPER_NokAddress1">
<Delimiter>"^"</Delimiter>
<Node>"NOK"</Node>
<Piece>7</Piece>
</Data>
<Data name="PAPER_NokAddress2">
<Delimiter>"^"</Delimiter>
<Node>"NOK"</Node>
<Piece>8</Piece>
</Data>
<Data name="PAPER_NokCTRLT_DR">
<Delimiter>"^"</Delimiter>
<Node>"NOK"</Node>
<Piece>4</Piece>
</Data>
<Data name="PAPER_NokCity_DR">
<Delimiter>"^"</Delimiter>
<Node>"NOK"</Node>
<Piece>5</Piece>
</Data>
<Data name="PAPER_NokName">
<Delimiter>"^"</Delimiter>
<Node>"NOK"</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPER_NokPhone">
<Delimiter>"^"</Delimiter>
<Node>"NOK"</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPER_NokText">
<Delimiter>"^"</Delimiter>
<Node>"NOK"</Node>
<Piece>3</Piece>
</Data>
<Data name="PAPER_NokZip_DR">
<Delimiter>"^"</Delimiter>
<Node>"NOK"</Node>
<Piece>6</Piece>
</Data>
<Data name="PAPER_OSVStatus_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>14</Piece>
</Data>
<Data name="PAPER_Occupation">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>36</Piece>
</Data>
<Data name="PAPER_Occupation_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",2</Node>
<Piece>6</Piece>
</Data>
<Data name="PAPER_OutstandAmt">
<Delimiter>"^"</Delimiter>
<Node>"PER",3</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPER_OutstandingDate">
<Delimiter>"^"</Delimiter>
<Node>"PER",3</Node>
<Piece>7</Piece>
</Data>
<Data name="PAPER_PDSSerialNumber">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>6</Piece>
</Data>
<Data name="PAPER_Pager">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>37</Piece>
</Data>
<Data name="PAPER_Para">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>13</Piece>
</Data>
<Data name="PAPER_PassportNumber">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>45</Piece>
</Data>
<Data name="PAPER_PatType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPER_PensionCardExpiryDate">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>39</Piece>
</Data>
<Data name="PAPER_Photo">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>5</Piece>
</Data>
<Data name="PAPER_PhotoDocument">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>39</Piece>
</Data>
<Data name="PAPER_PostCode">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>23</Piece>
</Data>
<Data name="PAPER_PreTerm">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>16</Piece>
</Data>
<Data name="PAPER_PrefLanguage_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>24</Piece>
</Data>
<Data name="PAPER_PreferredContactMethod">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPER_PrevHACCEligible">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>24</Piece>
</Data>
<Data name="PAPER_ProcuratorFiscalInformed">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>22</Piece>
</Data>
<Data name="PAPER_Province_Birth_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",2</Node>
<Piece>11</Piece>
</Data>
<Data name="PAPER_ReasonForChangeData">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>14</Piece>
</Data>
<Data name="PAPER_RegionBirth_DR">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>14</Piece>
</Data>
<Data name="PAPER_Religion_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",2</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPER_Remark">
<Node>"PER","RMK"</Node>
</Data>
<Data name="PAPER_ResidenceStatus_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>29</Piece>
</Data>
<Data name="PAPER_ResponsibleForPayment">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>11</Piece>
</Data>
<Data name="PAPER_ReversedBy">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>40</Piece>
</Data>
<Data name="PAPER_SNSLastLiveUpdDate">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>22</Piece>
</Data>
<Data name="PAPER_SNSLastReviewDate">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>20</Piece>
</Data>
<Data name="PAPER_SNSNextReviewDate">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>21</Piece>
</Data>
<Data name="PAPER_SecondPhone">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>18</Piece>
</Data>
<Data name="PAPER_Sex_DR">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>7</Piece>
</Data>
<Data name="PAPER_SocialStatus_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",1</Node>
<Piece>10</Piece>
</Data>
<Data name="PAPER_Soundex1">
<Delimiter>"^"</Delimiter>
<Node>"PER",1</Node>
<Piece>4</Piece>
</Data>
<Data name="PAPER_Soundex2">
<Delimiter>"^"</Delimiter>
<Node>"PER",1</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPER_Soundex3">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>3</Piece>
</Data>
<Data name="PAPER_SourceOfIncome_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>27</Piece>
</Data>
<Data name="PAPER_SpecNeedStat_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>19</Piece>
</Data>
<Data name="PAPER_StName">
<Node>"PER","ADD"</Node>
</Data>
<Data name="PAPER_StateCode_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",1</Node>
<Piece>6</Piece>
</Data>
<Data name="PAPER_StayingPermanently">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>10</Piece>
</Data>
<Data name="PAPER_TOP">
<Delimiter>"^"</Delimiter>
<Node>"PER",6</Node>
<Piece>15</Piece>
</Data>
<Data name="PAPER_TelH">
<Delimiter>"^"</Delimiter>
<Node>"PER",1</Node>
<Piece>11</Piece>
</Data>
<Data name="PAPER_TelO">
<Delimiter>"^"</Delimiter>
<Node>"PER",1</Node>
<Piece>9</Piece>
</Data>
<Data name="PAPER_Title_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>20</Piece>
</Data>
<Data name="PAPER_TransportUsed_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>30</Piece>
</Data>
<Data name="PAPER_UpdateDate">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPER_UpdateTime">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>3</Piece>
</Data>
<Data name="PAPER_UserAdded_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>18</Piece>
</Data>
<Data name="PAPER_UserUpdate">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>7</Piece>
</Data>
<Data name="PAPER_UsualRound_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>25</Piece>
</Data>
<Data name="PAPER_WhoNotified">
<Delimiter>"^"</Delimiter>
<Node>"PER",5</Node>
<Piece>7</Piece>
</Data>
<Data name="PAPER_Zip_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",1</Node>
<Piece>7</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PAPER_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdddate">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AddDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPER_DateAdded}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDOB">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DOB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{PAPER_Dob}</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PAPER_Name})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDOB2">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DOB2"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPER_Dob}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDebtor">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPER_Debtor_DR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PAPER_Debtor_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDeceasedDate">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DecDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPER_Deceased_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEmplNo1">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EmplNo1"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPER_EmployeeNo})_"Z"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEmployeeNo">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EmplNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPER_EmployeeNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFamilyGroup">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FamGrp"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPER_FamilyGroup_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexForeignCard">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"ForeignCard"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({PAPER_ForeignCountry})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGovernCardNo">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Govern"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPER_GovernCardNo})_"Z"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexICPPBC">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPMI_ICPPBC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PAPER_ID})_"Z"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMobPhone">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MobPhone"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPER_MobPhone})_"Z"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMother">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MotherDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPER_Mother_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPER_PatName"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PAPER_Name})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAPER_RowId}</Expression>
<NextCode> S {L3}=$O(^PAPERi({L1},{L2},{L3}))
 I {L3}="" K XFUNC("LOOKUP","SURNAME") Q
 Q:$G(XFUNC("LOOKUP","SURNAME"))=2
 S L3Node=^({L3})
 I $G(XFUNC("LOOKUP","SURNAME"))=1 G:L3Node="" NEXT
 I +$G(XFUNC("LOOKUP","SURNAME"))=0 G:L3Node="*" NEXT
</NextCode>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName2">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAPER_PatName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPER_Name2})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName3">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAPER_PatName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPER_Name3})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName5">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PAPER_PatName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPER_Name5})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOccupation">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Occup"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPER_Occupation_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PAPER_Name})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutstanding">
<Condition>{PAPER_OutstandAmt}</Condition>
<ConditionFields>PAPER_BillCode,PAPER_OutstandAmt,PAPER_OutstandingDate</ConditionFields>
<Global>^PAPERi</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Outstand"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPER_BillCode}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_OutstandingDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPassport">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Passport"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPER_PassportNumber})_"Z"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPhone">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Phone"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPER_TelH})_"Z"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvinceofBirth">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Prov-Birth"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPER_Province_Birth_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSoundex1">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Soundex"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPER_Soundex1}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSoundex2">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Soundex"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPER_Soundex2}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSoundex3">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Soundex"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPER_Soundex3}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStName">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPER_StName"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP($e({PAPER_StNameLine1},1,100))</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSurName">
<Data name="PAPER_InsuranceCardHolder"/>
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPER_PatName"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PAPER_SurName})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDate">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UpdDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPER_UpdateDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAPER_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
