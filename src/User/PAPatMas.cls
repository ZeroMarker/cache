/// Patient Master           (PAPMI,84)
Class User.PAPatMas Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PatMas, StorageStrategy = SQLStorage ]
{

Relationship ChildPAAlertMsg As PAAlertMsg [ Cardinality = children, Inverse = ALMPAPMIParRef ];

Relationship ChildPAFamily As PAFamily [ Cardinality = children, Inverse = FAMPAPMIParRef ];

Relationship ChildPANok As PANok [ Cardinality = children, Inverse = NOKPAPMIParRef ];

Relationship ChildPASocHist As PASocHist [ Cardinality = children, Inverse = SCHPAPMIParRef ];

Relationship ChildPAEmployee As PAEmployee [ Cardinality = children, Inverse = EPEParRef ];

Relationship ChildPADesease As PADesease [ Cardinality = children, Inverse = DESParRef ];

Relationship ChildPAOperation As PAOperation [ Cardinality = children, Inverse = OPERParRef ];

Relationship ChildPAPastHistCondition As PAPastHistCondition [ Cardinality = children, Inverse = PHISTParRef ];

Relationship ChildPADrugs As PADrugs [ Cardinality = children, Inverse = DRGParRef ];

Relationship ChildPADrugDescription As PADrugDescription [ Cardinality = children, Inverse = DRDParRef ];

Relationship ChildPAReferralDoctor As PAReferralDoctor [ Cardinality = children, Inverse = REFDParRef ];

Relationship ChildPAExemption As PAExemption [ Cardinality = children, Inverse = EXParRef ];

Relationship ChildPAFamilyDoctor As PAFamilyDoctor [ Cardinality = children, Inverse = FAMDParRef ];

Relationship ChildPAMedicalRecord As PAMedicalRecord [ Cardinality = children, Inverse = MRNParRef ];

Relationship ChildPAQuestionnaire As PAQuestionnaire [ Cardinality = children, Inverse = QUEParRef ];

Relationship ChildPADentist As PADentist [ Cardinality = children, Inverse = DENTParRef ];

Relationship ChildPAPatMasComments As PAPatMasComments [ Cardinality = children, Inverse = CMTParRef ];

Relationship ChildPATreatmentProgress As PATreatmentProgress [ Cardinality = children, Inverse = TRPRParRef ];

Relationship ChildPAAllergy As PAAllergy [ Cardinality = children, Inverse = ALGPAPMIParRef ];

/// PAPMI Row ID
Property PAPMIRowId As PAPerson [ InitialExpression = {$i(^PAPER(0))}, Required, SqlFieldName = PAPMI_RowId ];

/// Patient No
Property PAPMINo As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlComputeCode = { S {PAPMI_No}=$S($G(XFUNC("CLASS"))="OP":{PAPMI_OPNo},1:{PAPMI_IPNo})
 ;S {PAPMI_No}=$$CO2^at84({PAPMI_IPNo},{PAPMI_OPNo})
}, SqlComputed, SqlComputeOnChange = (PAPMIIPNo, PAPMIOPNo), SqlFieldName = PAPMI_No, Transient ];

/// Patient IC/PP/BC No
Property PAPMIID As %String(COLLATION = "AlphaUp", MAXLEN = 18, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PAPMI_ID ];

/// Patient Name
Property PAPMIName As %String(COLLATION = "AlphaUp", MAXLEN = 60, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = PAPMI_Name ];

/// Patient Name 2
Property PAPMIName2 As %String(COLLATION = "AlphaUp", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PAPMI_Name2 ];

/// Patient Alias
Property PAPMIAlias As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PAPMI_Alias ];

/// Foreign Phone Number
Property PAPMIForeignPhoneNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PAPMI_ForeignPhoneNo ];

/// Inpatient No
Property PAPMIIPNo As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PAPMI_IPNo ];

/// Outpatient No
Property PAPMIOPNo As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PAPMI_OPNo ];

/// Patient Date Of Birth
Property PAPMIDOB As %Date [ SqlColumnNumber = 11, SqlFieldName = PAPMI_DOB ];

/// Estimated Age In Years
Property PAPMIEstAgeYear As %Float(MAXVAL = 999, MINVAL = 1) [ SqlColumnNumber = 12, SqlFieldName = PAPMI_EstAgeYear ];

/// Estimated Age In Month
Property PAPMIEstAgeMonth As %Float(MAXVAL = 99, MINVAL = 1) [ SqlColumnNumber = 13, SqlFieldName = PAPMI_EstAgeMonth ];

/// Estimated Age Time Stamp
Property PAPMIEstAgeTmStmp As %Date [ SqlColumnNumber = 14, SqlFieldName = PAPMI_EstAgeTmStmp ];

/// Des Ref to CTSEX
Property PAPMISexDR As CTSex [ Required, SqlColumnNumber = 15, SqlFieldName = PAPMI_Sex_DR ];

/// Patient Soundex
Property PAPMISoundex As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PAPMI_Soundex ];

/// Des Ref to CTLAN
Property PAPMILangPrimDR As SSLanguage [ SqlColumnNumber = 24, SqlFieldName = PAPMI_LangPrim_DR ];

/// Is This Patient Usable?
Property PAPMIActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 42, SqlFieldName = PAPMI_Active ];

/// Des Ref to Pat. Categ
Property PAPMIPatCategoryDR As PACPatientCategory [ SqlColumnNumber = 54, SqlFieldName = PAPMI_PatCategory_DR ];

/// Home Clinic number
Property PAPMIHomeClinicNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 61, SqlFieldName = PAPMI_HomeClinicNo ];

/// Next OP Encounter No
Property PAPMINxtOPAdmNo As %Float(MAXVAL = 9999, MINVAL = 1) [ SqlColumnNumber = 63, SqlFieldName = PAPMI_NxtOPAdmNo ];

/// Not Used Des Ref to CTPTI
Property PAPMILangPrintDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 71, SqlFieldName = PAPMI_LangPrintDR ];

/// Patient Remark
Property PAPMIRemark As list Of %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 73, SqlFieldName = PAPMI_Remark, SqlListType = SUBNODE ];

/// Des Ref to CTLAN (Secondary Language)
Property PAPMILangSecondDR As SSLanguage [ SqlColumnNumber = 80, SqlFieldName = PAPMI_LangSecondDR ];

/// Deceased Flag
Property PAPMIDeceased As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 83, SqlFieldName = PAPMI_Deceased ];

/// Deceased Date
Property PAPMIDeceasedDate As %Date [ SqlColumnNumber = 84, SqlFieldName = PAPMI_Deceased_Date ];

/// Lookup Display
Property PAPMILookupDisplay As %String(COLLATION = "Exact", MAXLEN = 78, TRUNCATE = 1) [ SqlColumnNumber = 85, SqlComputeCode = { s {PAPMI_LookupDisplay}=$$CO85^at84b({PAPMI_IPNo},{PAPMI_OPNo},{PAPMI_ID},{PAPMI_Name},{PAPMI_Sex_DR},{PAPMI_DOB},{PAPMI_PatCategory_DR})
}, SqlComputed, SqlFieldName = PAPMI_LookupDisplay, Transient ];

/// Deceased Time
Property PAPMIDeceasedTime As %Time [ SqlColumnNumber = 86, SqlFieldName = PAPMI_DeceasedTime ];

/// Computered Surname
Property PAPMISurName As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 87, SqlComputeCode = { i $L({PAPMI_Name}," ")'>1 s {PAPMI_SurName}="" q
 s {PAPMI_SurName}=$P({PAPMI_Name}," ",2,9)
}, SqlComputed, SqlFieldName = PAPMI_SurName, Transient ];

/// Mark "*" in Index
Property PAPMIIndexMark As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 88, SqlComputeCode = { s {PAPMI_IndexMark}="*"
}, SqlComputed, SqlFieldName = PAPMI_IndexMark, Transient ];

/// Des Ref to PAPER
Property PAPMIPAPERDR As PAPerson [ SqlColumnNumber = 89, SqlComputeCode = { s {PAPMI_PAPER_DR}={PAPMI_RowId}
}, SqlComputed, SqlFieldName = PAPMI_PAPER_DR, Transient ];

/// Black List Flag
Property PAPMIBlackList As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 90, SqlFieldName = PAPMI_BlackList ];

/// Des Ref to PA_Mother
Property PAPMIMotherDR As PAMother [ SqlColumnNumber = 91, SqlFieldName = PAPMI_Mother_DR ];

/// Des Ref RefDoc
Property PAPMIRefDocDR As PACRefDoctor [ SqlColumnNumber = 97, SqlFieldName = PAPMI_RefDoc_DR ];

/// Medicare No
Property PAPMIMedicare As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 98, SqlFieldName = PAPMI_Medicare ];

/// PAPMI Name3
Property PAPMIName3 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 99, SqlFieldName = PAPMI_Name3 ];

/// Refund
Property PAPMIRefund As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 100, SqlFieldName = PAPMI_Refund ];

/// Medicare String
Property PAPMIMedicareString As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 101, SqlComputeCode = { s {PAPMI_MedicareString}=$s({PAPMI_Medicare}="":"",1:{PAPMI_Medicare}_"Z")
}, SqlComputed, SqlFieldName = PAPMI_MedicareString, Transient ];

/// User Update
Property PAPMIUserUpdate As SSUser [ SqlColumnNumber = 102, SqlFieldName = PAPMI_UserUpdate ];

/// Des Ref TraceOutcome
Property PAPMITraceStatusDR As PACTraceOutcome [ SqlColumnNumber = 103, SqlFieldName = PAPMI_TraceStatus_DR ];

/// Des Ref MedicareSuffix_DR
Property PAPMIMedicareSuffixDR As PACMedicareSuffix [ SqlColumnNumber = 105, SqlFieldName = PAPMI_MedicareSuffix_DR ];

/// Medicare Code
Property PAPMIMedicareCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 106, SqlFieldName = PAPMI_MedicareCode ];

/// Allergy
Property PAPMIAllergy As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 107, SqlFieldName = PAPMI_Allergy, SqlListType = SUBNODE ];

/// EPR Description
Property PAPMIEPRDescription As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 108, SqlComputeCode = { s {PAPMI_EPRDescription}=$$CO108^at84b({PAPMI_IPNo},{PAPMI_OPNo},{PAPMI_Name},{PAPMI_Name2},{PAPMI_Name3},{PAPMI_Sex_DR},{PAPMI_DOB},{PAPMI_RowId})
}, SqlComputed, SqlFieldName = PAPMI_EPRDescription, Transient ];

/// ConcessionCardNo
Property PAPMIConcessionCardNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 109, SqlFieldName = PAPMI_ConcessionCardNo ];

/// Concession Card ExpDate
Property PAPMIConcessionCardExpDate As %Date [ SqlColumnNumber = 110, SqlFieldName = PAPMI_ConcessionCardExpDate ];

/// Safety Net Card No
Property PAPMISafetyNetCardNo As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 111, SqlFieldName = PAPMI_SafetyNetCardNo ];

/// Safety Net Card ExpDate
Property PAPMISafetyNetCardExpDate As %Date [ SqlColumnNumber = 112, SqlFieldName = PAPMI_SafetyNetCardExpDate ];

/// DVA number
Property PAPMIDVAnumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 113, SqlFieldName = PAPMI_DVAnumber ];

/// Des Ref CardType
Property PAPMICardTypeDR As PACCardType [ SqlColumnNumber = 114, SqlFieldName = PAPMI_CardType_DR ];

/// Medicare Expiry Date
Property PAPMIMedicareExpDate As %Date [ SqlColumnNumber = 115, SqlFieldName = PAPMI_MedicareExpDate ];

/// CHC Patient
Property PAPMICHCPatient As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 116, SqlFieldName = PAPMI_CHCPatient ];

/// Estimated Death Date
Property PAPMIEstimatedDeathDate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 117, SqlFieldName = PAPMI_EstimatedDeathDate ];

/// Batallion
Property PAPMIBatallion As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 118, SqlFieldName = PAPMI_Batallion ];

/// Health FundNo
Property PAPMIHealthFundNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 119, SqlFieldName = PAPMI_HealthFundNo ];

/// Des Ref 国籍/地区(出生)
Property PAPMICountryOfBirthDR As CTCountry [ SqlColumnNumber = 120, SqlFieldName = PAPMI_CountryOfBirth_DR ];

/// Des Ref Title
Property PAPMITitleDR As CTTitle [ SqlColumnNumber = 121, SqlFieldName = PAPMI_Title_DR ];

/// Des Ref PrefLanguage
Property PAPMIPrefLanguageDR As PACPreferredLanguage [ SqlColumnNumber = 122, SqlFieldName = PAPMI_PrefLanguage_DR ];

/// Des REf Region
Property PAPMICTRegionDR As CTRegion [ SqlColumnNumber = 123, SqlFieldName = PAPMI_CT_Region_DR ];

/// Des Ref CT_Province
Property PAPMICTProvinceDR As CTProvince [ SqlColumnNumber = 124, SqlFieldName = PAPMI_CT_Province_DR ];

/// Government Card No_
Property PAPMIGovernCardNo As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 125, SqlFieldName = PAPMI_GovernCardNo ];

/// InsuranceCardHolder
Property PAPMIInsuranceCardHolder As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 126, SqlFieldName = PAPMI_InsuranceCardHolder ];

/// Des Ref CityArea
Property PAPMICityAreaDR As CTCityArea [ SqlColumnNumber = 127, SqlFieldName = PAPMI_CityArea_DR ];

/// ResponsibleForPayment
Property PAPMIResponsibleForPayment As PAPerson [ SqlColumnNumber = 128, SqlFieldName = PAPMI_ResponsibleForPayment ];

/// SecondPhone
Property PAPMISecondPhone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 129, SqlFieldName = PAPMI_SecondPhone ];

/// Email
Property PAPMIEmail As %String(COLLATION = "Exact", MAXLEN = 70, TRUNCATE = 1) [ SqlColumnNumber = 130, SqlFieldName = PAPMI_Email ];

/// MobPhone
Property PAPMIMobPhone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 131, SqlFieldName = PAPMI_MobPhone ];

/// Des Ref AuxInsType
Property PAPMIAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 132, SqlFieldName = PAPMI_AuxInsType_DR ];

/// Des Ref IndigStat
Property PAPMIIndigStatDR As PACIndigStatus [ SqlColumnNumber = 133, SqlFieldName = PAPMI_IndigStat_DR ];

/// GP Text
Property PAPMIGPText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 134, SqlFieldName = PAPMI_GPText, SqlListType = SUBNODE ];

/// Des Ref Dentist
Property PAPMIDentistDR As PACRefDoctor [ SqlColumnNumber = 135, SqlFieldName = PAPMI_Dentist_DR ];

/// Des Ref DentistClinic
Property PAPMIDentistClinicDR As PACRefDoctorClinic [ SqlColumnNumber = 136, SqlFieldName = PAPMI_DentistClinic_DR ];

/// VIP Flag
Property PAPMIVIPFlag As %String(DISPLAYLIST = ",Yes,No,Anonymous", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",Y,N,A") [ SqlColumnNumber = 138, SqlFieldName = PAPMI_VIPFlag ];

/// GPOrgAddress
Property PAPMIGPOrgAddress As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 139, SqlFieldName = PAPMI_GPOrgAddress, SqlListType = SUBNODE ];

/// Des Ref CityBirth
Property PAPMICityBirthDR As CTCity [ SqlColumnNumber = 140, SqlFieldName = PAPMI_CityBirth_DR ];

/// Des Ref CT_HCA
Property PAPMICTHCADR As CTHealthCareArea [ SqlColumnNumber = 141, SqlFieldName = PAPMI_CT_HCA_DR ];

/// RequireAssistanceMeal
Property PAPMIRequireAssistanceMeal As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 142, SqlFieldName = PAPMI_RequireAssistanceMeal ];

/// RequireAssistanceMenu
Property PAPMIRequireAssistanceMenu As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 143, SqlFieldName = PAPMI_RequireAssistanceMenu ];

/// Des Ref PensionType
Property PAPMIPensionTypeDR As PACPensionType [ SqlColumnNumber = 144, SqlFieldName = PAPMI_PensionType_DR ];

/// Des Ref Person
Property PAPMIMother1DR As PAPerson [ SqlColumnNumber = 145, SqlFieldName = PAPMI_Mother1_DR ];

/// HealthCardExpiryDate
Property PAPMIHealthCardExpiryDate As %Date [ SqlColumnNumber = 146, SqlFieldName = PAPMI_HealthCardExpiryDate ];

/// Name4
Property PAPMIName4 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 147, SqlFieldName = PAPMI_Name4 ];

/// Name5
Property PAPMIName5 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 148, SqlFieldName = PAPMI_Name5 ];

/// Name6
Property PAPMIName6 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 149, SqlFieldName = PAPMI_Name6 ];

/// Name7
Property PAPMIName7 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 150, SqlFieldName = PAPMI_Name7 ];

/// Name8
Property PAPMIName8 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 151, SqlFieldName = PAPMI_Name8 ];

/// ElecMasterIndex健康卡平台主索引
Property PAPMIElecMasterIndex As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 152, SqlFieldName = PAPMI_ElecMasterIndex ];

/// 妇科信息_孕次
Property PAPMIPregnancyG As %Numeric [ SqlColumnNumber = 153, SqlFieldName = PAPMI_Pregnancy_G ];

/// 妇科信息_产次
Property PAPMIPregnancyP As %Numeric [ SqlColumnNumber = 154, SqlFieldName = PAPMI_Pregnancy_P ];

/// 妇科信息_流次
Property PAPMIPregnancyA As %Numeric [ SqlColumnNumber = 155, SqlFieldName = PAPMI_Pregnancy_A ];

/// 妇科信息_存活
Property PAPMIPregnancyL As %Numeric [ SqlColumnNumber = 156, SqlFieldName = PAPMI_Pregnancy_L ];

/// 语言
Property PAPMIEducation As CTEducation [ SqlColumnNumber = 157, SqlFieldName = PAPMI_Education ];

Index RowIDBasedIDKeyIndex On PAPMIRowId [ IdKey, PrimaryKey, Unique ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPatMas).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPatMas","OnAfterInsert")
 d Table^HL7Outbound("PAPatMas",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPatMas).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPatMas","OnAfterUpdate")
 d Table^HL7Outbound("PAPatMas",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPatMas).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPatMas","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPatMas).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPatMas","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPatMas","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPatMas).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPatMas","OnAfterDelete")
 d Table^HL7Outbound("PAPatMas",%old(1),"Delete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAPER(0))</SqlIdExpression>
<SQLMap name="DataMasterMapPAPMI">
<Data name="PAPMI_Active">
<Delimiter>"^"</Delimiter>
<Node>"PAT",1</Node>
<Piece>6</Piece>
</Data>
<Data name="PAPMI_Alias">
<Delimiter>"^"</Delimiter>
<Node>"PAT",2</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPMI_Allergy">
<Node>"ALLERGY"</Node>
</Data>
<Data name="PAPMI_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>23</Piece>
</Data>
<Data name="PAPMI_Batallion">
<Delimiter>"^"</Delimiter>
<Node>"PAT",3</Node>
<Piece>11</Piece>
</Data>
<Data name="PAPMI_BlackList">
<Delimiter>"^"</Delimiter>
<Node>"PAT",1</Node>
<Piece>19</Piece>
</Data>
<Data name="PAPMI_CHCPatient">
<Delimiter>"^"</Delimiter>
<Node>"PAT",3</Node>
<Piece>9</Piece>
</Data>
<Data name="PAPMI_CT_HCA_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>3</Piece>
</Data>
<Data name="PAPMI_CT_Province_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPMI_CT_Region_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPMI_CardType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PAT",3</Node>
<Piece>7</Piece>
</Data>
<Data name="PAPMI_CityArea_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>9</Piece>
</Data>
<Data name="PAPMI_CityBirth_DR">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>18</Piece>
</Data>
<Data name="PAPMI_ConcessionCardExpDate">
<Delimiter>"^"</Delimiter>
<Node>"PAT",3</Node>
<Piece>3</Piece>
</Data>
<Data name="PAPMI_ConcessionCardNo">
<Delimiter>"^"</Delimiter>
<Node>"PAT",3</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPMI_CountryOfBirth_DR">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>26</Piece>
</Data>
<Data name="PAPMI_DOB">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>6</Piece>
</Data>
<Data name="PAPMI_DVAnumber">
<Delimiter>"^"</Delimiter>
<Node>"PAT",3</Node>
<Piece>6</Piece>
</Data>
<Data name="PAPMI_Deceased">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>12</Piece>
</Data>
<Data name="PAPMI_DeceasedTime">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>8</Piece>
</Data>
<Data name="PAPMI_Deceased_Date">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>13</Piece>
</Data>
<Data name="PAPMI_DentistClinic_DR">
<Delimiter>"^"</Delimiter>
<Node>"PAT",3</Node>
<Piece>14</Piece>
</Data>
<Data name="PAPMI_Dentist_DR">
<Delimiter>"^"</Delimiter>
<Node>"PAT",3</Node>
<Piece>13</Piece>
</Data>
<Data name="PAPMI_Education">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>30</Piece>
</Data>
<Data name="PAPMI_ElecMasterIndex">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>25</Piece>
</Data>
<Data name="PAPMI_Email">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>19</Piece>
</Data>
<Data name="PAPMI_EstAgeMonth">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>16</Piece>
</Data>
<Data name="PAPMI_EstAgeTmStmp">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>17</Piece>
</Data>
<Data name="PAPMI_EstAgeYear">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>15</Piece>
</Data>
<Data name="PAPMI_EstimatedDeathDate">
<Delimiter>"^"</Delimiter>
<Node>"PAT",3</Node>
<Piece>10</Piece>
</Data>
<Data name="PAPMI_ForeignPhoneNo">
<Delimiter>"^"</Delimiter>
<Node>"PAT",2</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPMI_GPOrgAddress">
<Node>"GPA"</Node>
</Data>
<Data name="PAPMI_GPText">
<Node>"GP"</Node>
</Data>
<Data name="PAPMI_GovernCardNo">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>4</Piece>
</Data>
<Data name="PAPMI_HealthCardExpiryDate">
<Delimiter>"^"</Delimiter>
<Node>"PAT",4</Node>
<Piece>5</Piece>
</Data>
<Data name="PAPMI_HealthFundNo">
<Delimiter>"^"</Delimiter>
<Node>"PAT",3</Node>
<Piece>12</Piece>
</Data>
<Data name="PAPMI_HomeClinicNo">
<Delimiter>"^"</Delimiter>
<Node>"PAT",1</Node>
<Piece>17</Piece>
</Data>
<Data name="PAPMI_ID">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>9</Piece>
</Data>
<Data name="PAPMI_IPNo">
<Delimiter>"^"</Delimiter>
<Node>"PAT",1</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPMI_IndigStat_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>22</Piece>
</Data>
<Data name="PAPMI_InsuranceCardHolder">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>5</Piece>
</Data>
<Data name="PAPMI_LangPrim_DR">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>10</Piece>
</Data>
<Data name="PAPMI_LangPrintDR">
<Delimiter>"^"</Delimiter>
<Node>"PAT",2</Node>
<Piece>5</Piece>
</Data>
<Data name="PAPMI_LangSecondDR">
<Delimiter>"^"</Delimiter>
<Node>"PAT",2</Node>
<Piece>4</Piece>
</Data>
<Data name="PAPMI_Medicare">
<Delimiter>"^"</Delimiter>
<Node>"PAT",1</Node>
<Piece>22</Piece>
</Data>
<Data name="PAPMI_MedicareCode">
<Delimiter>"^"</Delimiter>
<Node>"PAT",2</Node>
<Piece>6</Piece>
</Data>
<Data name="PAPMI_MedicareExpDate">
<Delimiter>"^"</Delimiter>
<Node>"PAT",3</Node>
<Piece>8</Piece>
</Data>
<Data name="PAPMI_MedicareSuffix_DR">
<Delimiter>"^"</Delimiter>
<Node>"PAT",3</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPMI_MobPhone">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>21</Piece>
</Data>
<Data name="PAPMI_Mother1_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>13</Piece>
</Data>
<Data name="PAPMI_Mother_DR">
<Delimiter>"^"</Delimiter>
<Node>"PAT",1</Node>
<Piece>20</Piece>
</Data>
<Data name="PAPMI_Name">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPMI_Name2">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPMI_Name3">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>19</Piece>
</Data>
<Data name="PAPMI_Name4">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>20</Piece>
</Data>
<Data name="PAPMI_Name5">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>21</Piece>
</Data>
<Data name="PAPMI_Name6">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>22</Piece>
</Data>
<Data name="PAPMI_Name7">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>23</Piece>
</Data>
<Data name="PAPMI_Name8">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>24</Piece>
</Data>
<Data name="PAPMI_NxtOPAdmNo">
<Delimiter>"^"</Delimiter>
<Node>"PAT",1</Node>
<Piece>18</Piece>
</Data>
<Data name="PAPMI_OPNo">
<Delimiter>"^"</Delimiter>
<Node>"PAT",1</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPMI_PatCategory_DR">
<Delimiter>"^"</Delimiter>
<Node>"PAT",1</Node>
<Piece>8</Piece>
</Data>
<Data name="PAPMI_PensionType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PAT",4</Node>
<Piece>4</Piece>
</Data>
<Data name="PAPMI_PrefLanguage_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>24</Piece>
</Data>
<Data name="PAPMI_Pregnancy_A">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>28</Piece>
</Data>
<Data name="PAPMI_Pregnancy_G">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>26</Piece>
</Data>
<Data name="PAPMI_Pregnancy_L">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>29</Piece>
</Data>
<Data name="PAPMI_Pregnancy_P">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>27</Piece>
</Data>
<Data name="PAPMI_RefDoc_DR">
<Delimiter>"^"</Delimiter>
<Node>"PAT",1</Node>
<Piece>21</Piece>
</Data>
<Data name="PAPMI_Refund">
<Delimiter>"^"</Delimiter>
<Node>"PAT",1</Node>
<Piece>23</Piece>
</Data>
<Data name="PAPMI_Remark">
<Node>"RMK"</Node>
</Data>
<Data name="PAPMI_RequireAssistanceMeal">
<Delimiter>"^"</Delimiter>
<Node>"PAT",4</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPMI_RequireAssistanceMenu">
<Delimiter>"^"</Delimiter>
<Node>"PAT",4</Node>
<Piece>3</Piece>
</Data>
<Data name="PAPMI_ResponsibleForPayment">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>11</Piece>
</Data>
<Data name="PAPMI_SafetyNetCardExpDate">
<Delimiter>"^"</Delimiter>
<Node>"PAT",3</Node>
<Piece>5</Piece>
</Data>
<Data name="PAPMI_SafetyNetCardNo">
<Delimiter>"^"</Delimiter>
<Node>"PAT",3</Node>
<Piece>4</Piece>
</Data>
<Data name="PAPMI_SecondPhone">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>18</Piece>
</Data>
<Data name="PAPMI_Sex_DR">
<Delimiter>"^"</Delimiter>
<Node>"ALL"</Node>
<Piece>7</Piece>
</Data>
<Data name="PAPMI_Soundex">
<Delimiter>"^"</Delimiter>
<Node>"PAT",2</Node>
<Piece>3</Piece>
</Data>
<Data name="PAPMI_Title_DR">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>20</Piece>
</Data>
<Data name="PAPMI_TraceStatus_DR">
<Delimiter>"^"</Delimiter>
<Node>"PAT",1</Node>
<Piece>24</Piece>
</Data>
<Data name="PAPMI_UserUpdate">
<Delimiter>"^"</Delimiter>
<Node>"PER",4</Node>
<Piece>7</Piece>
</Data>
<Data name="PAPMI_VIPFlag">
<Delimiter>"^"</Delimiter>
<Node>"PAT",4</Node>
<Piece>1</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PAPMI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDOB">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DOB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{PAPMI_DOB}</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PAPMI_Name})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDOB2">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DOB2"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPMI_DOB}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDVA">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DVA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPMI_DVAnumber})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexElecMasterIndex">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ElecMI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPMI_ElecMasterIndex})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFullName">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAPER_PatName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPMI_Name})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGovernCardNo">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Govern"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPMI_GovernCardNo})_"Z"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHealthFundNo">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PAPER_HFundNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPMI_HealthFundNo})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexICPPBC">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPMI_ICPPBC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PAPMI_ID})_"Z"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMedicare">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Medicare"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPMI_MedicareString})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMedicare1">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Medicare1"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPMI_Medicare})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMobPhone">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MobPhone"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPMI_MobPhone})_"Z"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPER_PatName"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PAPMI_Name})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAPMI_RowId}</Expression>
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
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAPER_PatName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPMI_Name2})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatNo">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPMI_PatNo"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PAPMI_No})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSafetyNet">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SafetyNet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPMI_SafetyNetCardNo})_"Z"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSurName">
<Data name="PAPMI_IndexMark"/>
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPER_PatName"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PAPMI_SurName})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexYBCode">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAPER_YBCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PAPMI_Name3})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAPMI_RowId</SqlRowIdName>
<StreamLocation>^User.PAPatMasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
