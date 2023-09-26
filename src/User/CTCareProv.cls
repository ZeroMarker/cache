/// CT Care Provider        (CTPCP,111)
Class User.CTCareProv Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = CT_CareProv, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1817;

Relationship ChildCTCareProvHospitals As CTCareProvHospitals [ Cardinality = children, Inverse = HOSPParRef ];

Relationship ChildCTCareProvKeywords As CTCareProvKeywords [ Cardinality = children, Inverse = KEYWParRef ];

Relationship ChildCTCareProvID As CTCareProvID [ Cardinality = children, Inverse = IDParRef ];

Relationship ChildCTCareProvAddress As CTCareProvAddress [ Cardinality = children, Inverse = ADDRParRef ];

Relationship ChildCTCareProvORPref As CTCareProvORPref [ Cardinality = children, Inverse = ORPParRef ];

Relationship ChildCTCareProvPHCPoison As CTCareProvPHCPoison [ Cardinality = children, Inverse = CPPParRef ];

/// 处方权
Relationship ChildCTCareProvPrescriptSet As CTCareProvPrescriptSet [ Cardinality = children, Inverse = CPPSParRef ];

/// 关联标签
Relationship ChildCTCareProvLinkLabel As CTCareProvLinkLabel [ Cardinality = children, Inverse = CPLLParRef ];

/// CTPCP Row ID
Property CTPCPRowId As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ InitialExpression = {$$DEF1^at111}, Required, SqlFieldName = CTPCP_RowId ];

/// Care Provider Code
Property CTPCPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTPCP_Code ];

/// Care Provider Name
Property CTPCPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTPCP_Desc ];

/// Care Provider Id
Property CTPCPId As %String(COLLATION = "AlphaUp", MAXLEN = 16, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CTPCP_Id ];

/// Care Provider Category
Property CTPCPCategory As %String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CTPCP_Category ];

/// Doctor SMC Number
Property CTPCPSMCNo As %String(COLLATION = "AlphaUp", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CTPCP_SMCNo ];

/// Des Ref to CTCPT
Property CTPCPCarPrvTpDR As CTCarPrvTp [ Required, SqlColumnNumber = 7, SqlFieldName = CTPCP_CarPrvTp_DR ];

/// Des Ref to CTADR
Property CTPCPAddrTypeDR As CTAddrType [ SqlColumnNumber = 8, SqlFieldName = CTPCP_AddrType_DR ];

/// Address Block Number
Property CTPCPBlk As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CTPCP_Blk ];

/// Address Street Name
Property CTPCPStName As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 10, SqlFieldName = CTPCP_StName, SqlListType = SUBNODE ];

/// Address Building Level
Property CTPCPLevel As %String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CTPCP_Level ];

/// Address Unit Number
Property CTPCPUnit As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CTPCP_Unit ];

/// Des Ref to CTCIT
Property CTPCPCityDR As CTCity [ SqlColumnNumber = 13, SqlFieldName = CTPCP_City_DR ];

/// Des Ref to CTSTT
Property CTPCPStateDR As CTState [ SqlColumnNumber = 14, SqlFieldName = CTPCP_State_DR ];

/// Des Ref to CTZIP
Property CTPCPZipDR As CTZip [ SqlColumnNumber = 15, SqlFieldName = CTPCP_Zip_DR ];

/// Des Ref to CTSPC
Property CTPCPSpecDR As CTSpec [ SqlColumnNumber = 16, SqlFieldName = CTPCP_Spec_DR ];

/// Des Ref to CTSPC
Property CTPCPSubSpecDR As CTSpec [ SqlColumnNumber = 17, SqlFieldName = CTPCP_SubSpec_DR ];

/// Office Telephone Number
Property CTPCPTelO As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = CTPCP_TelO ];

/// Office Telephone Extension
Property CTPCPTelOExt As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = CTPCP_TelOExt ];

/// Home Telephone Number
Property CTPCPTelH As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = CTPCP_TelH ];

/// Pager Number
Property CTPCPPagerNo As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = CTPCP_PagerNo ];

/// Des Ref to CTRFC
Property CTPCPHospDR As CTRefClin [ SqlColumnNumber = 22, SqlFieldName = CTPCP_Hosp_DR ];

/// Des Ref to ARCIM
Property CTPCPCon1CodeDR As ARCItmMast [ SqlColumnNumber = 23, SqlFieldName = CTPCP_Con1Code_DR ];

/// Des Ref to ARCIM
Property CTPCPCon2CodeDR As ARCItmMast [ SqlColumnNumber = 24, SqlFieldName = CTPCP_Con2Code_DR ];

/// ActiveFlag
Property CTPCPActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 25, SqlFieldName = CTPCP_ActiveFlag ];

/// Des Ref to Original Version
Property CTPCPVersionOriginDR As CTCareProv [ InitialExpression = {$g(%d(1))}, SqlColumnNumber = 27, SqlFieldName = CTPCP_VersionOrigin_DR ];

/// Version
Property CTPCPVersionNumber As %Float [ InitialExpression = 1, SqlColumnNumber = 28, SqlFieldName = CTPCP_VersionNumber ];

/// Current Version Des Ref
Property CTPCPVersionCurrDR As CTCareProv [ SqlColumnNumber = 29, SqlFieldName = CTPCP_VersionCurr_DR, Transient ];

/// Current
Property CTPCPVersionCurrFlg As %String(COLLATION = "Exact", MAXLEN = 7, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = CTPCP_VersionCurrFlg, Transient ];

/// Effective Date
Property CTPCPVersionDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 32, SqlFieldName = CTPCP_VersionDate ];

/// Effective Time
Property CTPCPVersionTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 33, SqlFieldName = CTPCP_VersionTime ];

/// Effective Date / Time
Property CTPCPVersionDateTime As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlComputeCode = { s {CTPCP_VersionDateTime}=$p({CTPCP_VersionDate},$c(1))_"Z"_$p({CTPCP_VersionTime},$c(2))
}, SqlComputed, SqlComputeOnChange = (CTPCPVersionDate, CTPCPVersionTime), SqlFieldName = CTPCP_VersionDateTime ];

/// Author ID
Property CTPCPAuthorID As %String(COLLATION = "AlphaUp", MAXLEN = 12, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = CTPCP_AuthorID ];

/// Specialist Y/N
Property CTPCPSpecialistYN As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = CTPCP_SpecialistYN ];

/// First Digit of the Queue Number
Property CTPCPFirstDigitInQueue As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = CTPCP_FirstDigitInQueue ];

/// Date Active From
Property CTPCPDateActiveFrom As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 38, SqlFieldName = CTPCP_DateActiveFrom ];

/// Date Active To
Property CTPCPDateActiveTo As %Date [ SqlColumnNumber = 39, SqlFieldName = CTPCP_DateActiveTo ];

/// Des REf Link Doctor
Property CTPCPLinkDoctorDR As CTCareProv [ SqlColumnNumber = 40, SqlFieldName = CTPCP_LinkDoctor_DR ];

/// Allocated Doctor
Property CTPCPAllocatedDoctor As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = CTPCP_AllocatedDoctor ];

/// Surgeon
Property CTPCPSurgeon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = CTPCP_Surgeon ];

/// Anaesthetist
Property CTPCPAnaesthetist As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 43, SqlFieldName = CTPCP_Anaesthetist ];

/// Prescriber Number
Property CTPCPPrescriberNumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = CTPCP_PrescriberNumber ];

/// Des Ref CPGroup
Property CTPCPCPGroupDR As CTCareProvGroup [ SqlColumnNumber = 45, SqlFieldName = CTPCP_CPGroup_DR ];

/// Des Ref RespUnit
Property CTPCPRespUnitDR As CTResponsibleUnit [ SqlColumnNumber = 46, SqlFieldName = CTPCP_RespUnit_DR ];

/// Des Ref CTLOC
Property CTPCPCTLOCDR As CTLoc [ SqlColumnNumber = 48, SqlFieldName = CTPCP_CTLOC_DR ];

/// Title
Property CTPCPTitle As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 49, SqlFieldName = CTPCP_Title ];

/// Date Of Birth
Property CTPCPDOB As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = CTPCP_DOB ];

/// Mobile Phone
Property CTPCPMobilePhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = CTPCP_MobilePhone ];

/// Fax Number
Property CTPCPFax As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 52, SqlFieldName = CTPCP_Fax ];

/// Mail List
Property CTPCPMailList As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 53, SqlFieldName = CTPCP_MailList ];

/// Email
Property CTPCPEmail As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 54, SqlFieldName = CTPCP_Email ];

/// Preferred Contact Method
Property CTPCPPrefConMethod As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 55, SqlFieldName = CTPCP_PrefConMethod ];

/// Text 1
Property CTPCPTextOne As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 56, SqlFieldName = CTPCP_TextOne ];

/// Text 2
Property CTPCPTextTwo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 57, SqlFieldName = CTPCP_TextTwo ];

/// Contact First On
Property CTPCPContactFirstOn As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 58, SqlFieldName = CTPCP_ContactFirstOn ];

/// Radiologist
Property CTPCPRadiologist As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 59, SqlFieldName = CTPCP_Radiologist ];

/// AdmittingRights
Property CTPCPAdmittingRights As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 60, SqlFieldName = CTPCP_AdmittingRights ];

/// Acceptance
Property CTPCPAcceptance As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 61, SqlFieldName = CTPCP_Acceptance ];

/// Previous
Property CTPCPPrevious As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 62, SqlFieldName = CTPCP_Previous ];

/// MantouxTest
Property CTPCPMantouxTest As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 63, SqlFieldName = CTPCP_MantouxTest ];

/// Continuing
Property CTPCPContinuing As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 64, SqlFieldName = CTPCP_Continuing ];

/// New
Property CTPCPNew As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 65, SqlFieldName = CTPCP_New ];

/// PrefMailAddFlad
Property CTPCPPrefMailAddFlad As %String(DISPLAYLIST = ",Home,Internal,Room", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",H,I,R") [ SqlColumnNumber = 66, SqlFieldName = CTPCP_PrefMailAddFlad ];

/// UpdateDate
Property CTPCPUpdateDate As %Date [ SqlColumnNumber = 67, SqlFieldName = CTPCP_UpdateDate ];

/// UpdateTime
Property CTPCPUpdateTime As %Time [ SqlColumnNumber = 68, SqlFieldName = CTPCP_UpdateTime ];

/// Des Ref UpdateUser
Property CTPCPUpdateUserDR As SSUser [ SqlColumnNumber = 69, SqlFieldName = CTPCP_UpdateUser_DR ];

/// Best Contact Time
Property CTPCPBestContactTime As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 70, SqlFieldName = CTPCP_BestContactTime ];

/// Des Ref ReferralDoctor
Property CTPCPReferralDoctorDR As PACRefDoctor [ SqlColumnNumber = 71, SqlFieldName = CTPCP_ReferralDoctor_DR ];

/// First Name
Property CTPCPFirstName As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 72, SqlFieldName = CTPCP_FirstName ];

/// Other Name
Property CTPCPOtherName As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 73, SqlFieldName = CTPCP_OtherName ];

/// Des Ref Title
Property CTPCPTitleDR As CTTitle [ SqlColumnNumber = 74, SqlFieldName = CTPCP_Title_DR ];

/// Surname
Property CTPCPSurname As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 75, SqlFieldName = CTPCP_Surname ];

/// HICApproved
Property CTPCPHICApproved As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 76, SqlFieldName = CTPCP_HICApproved ];

/// Practitioner Flag1
Property CTPCPPractitionerFlag1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 77, SqlFieldName = CTPCP_PractitionerFlag1 ];

/// Mental  精神类药物处方权
Property CTPCPMentalFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 78, SqlFieldName = CTPCP_MentalFlag ];

Index CTPCPCodeUnqIdx1 On CTPCPCode [ Unique ];

Index RowIDBasedIDKeyIndex On CTPCPRowId [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTCareProv).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProv","OnAfterDelete")
 
            d valid1^MVBSSVAL("Base Table Triggers",111,"POFILDEL")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTCareProv).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProv","OnAfterInsert")
 
 d POFILINS^at111
            d valid1^MVBSSVAL("Base Table Triggers",111,"POFILINS")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTCareProv).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProv","OnAfterUpdate")
 
             d POFILUPD^at111
            d valid1^MVBSSVAL("Base Table Triggers",111,"POFILUPD")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTCareProv).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProv","OnBeforeDelete")
 
 d VALDEL^at111
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
	d VALINS^at111
            d valid1^MVBSSVAL("Base Table Triggers",111,"VALINS")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTCareProv).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProv","OnBeforeUpdate")
 
 d VALUPD^at111
            d valid1^MVBSSVAL("Base Table Triggers",111,"VALUPD")
}

Storage SQLStorage
{
<ExtentSize>1817</ExtentSize>
<Property name="CTPCPAcceptance">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPActiveFlag">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CTPCPAddrTypeDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPAdmittingRights">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPAllocatedDoctor">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPAnaesthetist">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPAuthorID">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPBestContactTime">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPBlk">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CTPCPCPGroupDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPCTLOCDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPCarPrvTpDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CTPCPCategory">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPCityDR">
<Selectivity>4.1475%</Selectivity>
</Property>
<Property name="CTPCPCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="CTPCPCon1CodeDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPCon2CodeDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPContactFirstOn">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="CTPCPContinuing">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPDOB">
<Selectivity>1.4567%</Selectivity>
</Property>
<Property name="CTPCPDateActiveFrom">
<Selectivity>5.2576%</Selectivity>
</Property>
<Property name="CTPCPDateActiveTo">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CTPCPDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="CTPCPEmail">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CTPCPFax">
<Selectivity>4.1475%</Selectivity>
</Property>
<Property name="CTPCPFirstDigitInQueue">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="CTPCPFirstName">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPHICApproved">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPHospDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPId">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPLevel">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CTPCPLinkDoctorDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPMailList">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPMantouxTest">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPMobilePhone">
<Selectivity>2.3832%</Selectivity>
</Property>
<Property name="CTPCPNew">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPOtherName">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="CTPCPPagerNo">
<Selectivity>4.7521%</Selectivity>
</Property>
<Property name="CTPCPPractitionerFlag1">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPPrefConMethod">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="CTPCPPrefMailAddFlad">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="CTPCPPrescriberNumber">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="CTPCPPrevious">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPRadiologist">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPReferralDoctorDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPRespUnitDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPRowId">
<Selectivity>1</Selectivity>
</Property>
<Property name="CTPCPSMCNo">
<Selectivity>4.7521%</Selectivity>
</Property>
<Property name="CTPCPSpecDR">
<Selectivity>4.3321%</Selectivity>
</Property>
<Property name="CTPCPSpecialistYN">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPStName">
<Selectivity>1.3821%</Selectivity>
</Property>
<Property name="CTPCPStateDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPSubSpecDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CTPCPSurgeon">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPSurname">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="CTPCPTelH">
<Selectivity>1.4956%</Selectivity>
</Property>
<Property name="CTPCPTelO">
<Selectivity>1.6188%</Selectivity>
</Property>
<Property name="CTPCPTelOExt">
<Selectivity>2.3832%</Selectivity>
</Property>
<Property name="CTPCPTextOne">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="CTPCPTextTwo">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTPCPTitle">
<Selectivity>4.3321%</Selectivity>
</Property>
<Property name="CTPCPTitleDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="CTPCPUnit">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPUpdateDate">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPUpdateTime">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPUpdateUserDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="CTPCPVersionDate">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="CTPCPVersionDateTime">
<Selectivity>0.2817%</Selectivity>
</Property>
<Property name="CTPCPVersionNumber">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="CTPCPVersionOriginDR">
<Selectivity>0.2665%</Selectivity>
</Property>
<Property name="CTPCPVersionTime">
<Selectivity>0.2972%</Selectivity>
</Property>
<Property name="CTPCPZipDR">
<Selectivity>5.5516%</Selectivity>
</Property>
<SqlIdExpression>$$DEF1^at111</SqlIdExpression>
<SQLMap name="DataMasterCTPCP">
<Data name="CTPCP_Acceptance">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>16</Piece>
</Data>
<Data name="CTPCP_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="CTPCP_AddrType_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>5</Piece>
</Data>
<Data name="CTPCP_AdmittingRights">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>15</Piece>
</Data>
<Data name="CTPCP_AllocatedDoctor">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>17</Piece>
</Data>
<Data name="CTPCP_Anaesthetist">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>19</Piece>
</Data>
<Data name="CTPCP_AuthorID">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>12</Piece>
</Data>
<Data name="CTPCP_BestContactTime">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>25</Piece>
</Data>
<Data name="CTPCP_Blk">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>6</Piece>
</Data>
<Data name="CTPCP_CPGroup_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>1</Piece>
</Data>
<Data name="CTPCP_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>3</Piece>
</Data>
<Data name="CTPCP_CarPrvTp_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="CTPCP_Category">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="CTPCP_City_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>9</Piece>
</Data>
<Data name="CTPCP_Code">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="CTPCP_Con1Code_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="CTPCP_Con2Code_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="CTPCP_ContactFirstOn">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>13</Piece>
</Data>
<Data name="CTPCP_Continuing">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>19</Piece>
</Data>
<Data name="CTPCP_DOB">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>5</Piece>
</Data>
<Data name="CTPCP_DateActiveFrom">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>14</Piece>
</Data>
<Data name="CTPCP_DateActiveTo">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>15</Piece>
</Data>
<Data name="CTPCP_Desc">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="CTPCP_Email">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>9</Piece>
</Data>
<Data name="CTPCP_Fax">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>7</Piece>
</Data>
<Data name="CTPCP_FirstDigitInQueue">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>13</Piece>
</Data>
<Data name="CTPCP_FirstName">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>27</Piece>
</Data>
<Data name="CTPCP_HICApproved">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>31</Piece>
</Data>
<Data name="CTPCP_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="CTPCP_Id">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="CTPCP_Level">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>7</Piece>
</Data>
<Data name="CTPCP_LinkDoctor_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>16</Piece>
</Data>
<Data name="CTPCP_MailList">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>8</Piece>
</Data>
<Data name="CTPCP_MantouxTest">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>18</Piece>
</Data>
<Data name="CTPCP_MentalFlag">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>33</Piece>
</Data>
<Data name="CTPCP_MobilePhone">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>6</Piece>
</Data>
<Data name="CTPCP_New">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>20</Piece>
</Data>
<Data name="CTPCP_OtherName">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>28</Piece>
</Data>
<Data name="CTPCP_PagerNo">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>4</Piece>
</Data>
<Data name="CTPCP_PractitionerFlag1">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>32</Piece>
</Data>
<Data name="CTPCP_PrefConMethod">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>10</Piece>
</Data>
<Data name="CTPCP_PrefMailAddFlad">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>21</Piece>
</Data>
<Data name="CTPCP_PrescriberNumber">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>20</Piece>
</Data>
<Data name="CTPCP_Previous">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>17</Piece>
</Data>
<Data name="CTPCP_Radiologist">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>14</Piece>
</Data>
<Data name="CTPCP_ReferralDoctor_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>26</Piece>
</Data>
<Data name="CTPCP_RespUnit_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>2</Piece>
</Data>
<Data name="CTPCP_SMCNo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="CTPCP_Spec_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="CTPCP_SpecialistYN">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>16</Piece>
</Data>
<Data name="CTPCP_StName">
<Node>"Add"</Node>
</Data>
<Data name="CTPCP_State_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>10</Piece>
</Data>
<Data name="CTPCP_SubSpec_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="CTPCP_Surgeon">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>18</Piece>
</Data>
<Data name="CTPCP_Surname">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>30</Piece>
</Data>
<Data name="CTPCP_TelH">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="CTPCP_TelO">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="CTPCP_TelOExt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="CTPCP_TextOne">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>11</Piece>
</Data>
<Data name="CTPCP_TextTwo">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>12</Piece>
</Data>
<Data name="CTPCP_Title">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>4</Piece>
</Data>
<Data name="CTPCP_Title_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>29</Piece>
</Data>
<Data name="CTPCP_Unit">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>8</Piece>
</Data>
<Data name="CTPCP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>22</Piece>
</Data>
<Data name="CTPCP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>23</Piece>
</Data>
<Data name="CTPCP_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>24</Piece>
</Data>
<Data name="CTPCP_VersionDate">
<Delimiter>"^","Z"</Delimiter>
<Node>1</Node>
<Piece>15,1</Piece>
</Data>
<Data name="CTPCP_VersionDateTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>15</Piece>
</Data>
<Data name="CTPCP_VersionNumber">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="CTPCP_VersionOrigin_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>14</Piece>
</Data>
<Data name="CTPCP_VersionTime">
<Delimiter>"^","Z"</Delimiter>
<Node>1</Node>
<Piece>15,2</Piece>
</Data>
<Data name="CTPCP_Zip_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>11</Piece>
</Data>
<Global>^CTPCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CTPCP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAnaest">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Anaest"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTPCP_Anaesthetist}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTPCP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTPCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTPCP_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CTPCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Decs"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTPCP_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CTPCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHICDesc">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTPCP_HICApproved}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTPCP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTPCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexId">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({CTPCP_Id})</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTPCP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTPCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLinkDoctor">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LinkDoctor"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTPCP_LinkDoctor_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTPCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescriber">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrescriberNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTPCP_PrescriberNumber}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTPCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRadiologist">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Radio"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTPCP_Radiologist}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTPCP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTPCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSMCNo">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SMCNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({CTPCP_SMCNo})</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTPCP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTPCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSpecDesc">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Spec"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTPCP_SpecialistYN}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTPCP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTPCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSpecialtyDesc">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SpecDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTPCP_Spec_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTPCP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTPCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSurgeon">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Surg"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTPCP_Surgeon}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTPCP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTPCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CareProvType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTPCP_CarPrvTp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTPCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDesc">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTPCP_CarPrvTp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTPCP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTPCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVersion">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CTPCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Version"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CTPCP_VersionOrigin_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CTPCP_VersionDateTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTPCP_ActiveFlag}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{CTPCP_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTPCP_RowId</SqlRowIdName>
<StreamLocation>^User.CTCareProvS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
