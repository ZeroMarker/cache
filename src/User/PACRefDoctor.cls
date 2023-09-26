/// PAC Refer Doctor(1423)
Class User.PACRefDoctor Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_RefDoctor, StorageStrategy = SQLStorage ]
{

Relationship ChildPACRefDoctorSubstitute As PACRefDoctorSubstitute [ Cardinality = children, Inverse = SUBSParRef ];

Relationship ChildPACRefDoctorServices As PACRefDoctorServices [ Cardinality = children, Inverse = SERParRef ];

Relationship ChildPACRefDoctorClinic As PACRefDoctorClinic [ Cardinality = children, Inverse = CLNParRef ];

Relationship ChildPACRefDoctorKeywords As PACRefDoctorKeywords [ Cardinality = children, Inverse = KEYWParRef ];

Relationship ChildPACRefDoctorOrgChange As PACRefDoctorOrgChange [ Cardinality = children, Inverse = ORGCParRef ];

/// Code
Property REFDCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = REFD_Code ];

/// Description
Property REFDDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = REFD_Desc ];

/// Titolo
Property REFDTitle As %String(COLLATION = "Exact", MAXLEN = 7, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = REFD_Title ];

/// Attivato
Property REFDMailingInfo As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = REFD_MailingInfo ];

/// Indirizo
Property REFDAddress As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = REFD_Address, SqlListType = SUBNODE ];

/// Des Ref CTZIP
Property REFDCTZIPDR As CTZip [ SqlColumnNumber = 7, SqlFieldName = REFD_CTZIP_DR ];

/// Des Ref CITY
Property REFDCITYDR As CTCity [ SqlColumnNumber = 8, SqlFieldName = REFD_CITY_DR ];

/// Des REf Province
Property REFDProvinceDR As CTProvince [ SqlColumnNumber = 9, SqlFieldName = REFD_Province_DR ];

/// Telefono
Property REFDPhone As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = REFD_Phone ];

/// USSL
Property REFDUSSL As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = REFD_USSL ];

/// Gruppo
Property REFDGroup As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = REFD_Group ];

/// Des Ref BillGrp
Property REFDBillGrpDR As ARCBillGrp [ SqlColumnNumber = 13, SqlFieldName = REFD_BillGrp_DR ];

/// Data nascita
Property REFDDate As %Date [ SqlColumnNumber = 14, SqlFieldName = REFD_Date ];

/// Numero mutuati
Property REFDMaximumReferralLimit As %Float [ SqlColumnNumber = 15, SqlFieldName = REFD_MaximumReferralLimit ];

/// Specialist Flag
Property REFDSpecialist As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = REFD_Specialist ];

/// Date Active From
Property REFDDateActiveFrom As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 17, SqlFieldName = REFD_DateActiveFrom ];

/// Date Active To
Property REFDDateActiveTo As %Date [ SqlColumnNumber = 18, SqlFieldName = REFD_DateActiveTo ];

/// Fiscal Code1
Property REFDFiscalCode1 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = REFD_FiscalCode1 ];

/// Fiscal Code2
Property REFDFiscalCode2 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = REFD_FiscalCode2 ];

/// Medical Code
Property REFDMedicalCode As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = REFD_MedicalCode ];

/// Reason To Finish Contract
Property REFDReasonToFinishContract As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = REFD_ReasonToFinishContract ];

/// Reg Number1
Property REFDRegNumber1 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = REFD_RegNumber1 ];

/// Reg Number2
Property REFDRegNumber2 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = REFD_RegNumber2 ];

/// Registration Date
Property REFDRegistrDate As %Date [ SqlColumnNumber = 25, SqlFieldName = REFD_RegistrDate ];

/// Graduation Date
Property REFDGraduationDate As %Date [ SqlColumnNumber = 26, SqlFieldName = REFD_GraduationDate ];

/// Des Ref City
Property REFDGraduationPlaceDR As CTCity [ SqlColumnNumber = 27, SqlFieldName = REFD_GraduationPlace_DR ];

/// Masters Date
Property REFDMastersDate As %Date [ SqlColumnNumber = 28, SqlFieldName = REFD_MastersDate ];

/// Des Ref City
Property REFDMastersPlaceDR As CTCity [ SqlColumnNumber = 29, SqlFieldName = REFD_MastersPlace_DR ];

/// Qualification Date
Property REFDQualificationDate As %Date [ SqlColumnNumber = 30, SqlFieldName = REFD_QualificationDate ];

/// Des Ref City
Property REFDQualificationPlaceDR As CTCity [ SqlColumnNumber = 31, SqlFieldName = REFD_QualificationPlace_DR ];

/// Text1
Property REFDText1 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = REFD_Text1 ];

/// Text2
Property REFDText2 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = REFD_Text2 ];

/// Des Ref Bank
Property REFDBankDR As CMCBankMas [ SqlColumnNumber = 34, SqlFieldName = REFD_Bank_DR ];

/// Des Ref Agency
Property REFDAgencyDR As PACAgency [ SqlColumnNumber = 35, SqlFieldName = REFD_Agency_DR ];

/// Account
Property REFDAccount As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = REFD_Account ];

/// CurrentNumberOfPatients
Property REFDCurrentNumberOfPatients As %Float [ SqlColumnNumber = 37, SqlFieldName = REFD_CurrentNumberOfPatients ];

/// Check Refrerral Limit
Property REFDCheckRefrerralLimit As %Float [ SqlColumnNumber = 38, SqlFieldName = REFD_CheckRefrerralLimit ];

/// Des Ref Specialty
Property REFDSpecialtyDR As CTSpec [ SqlColumnNumber = 39, SqlFieldName = REFD_Specialty_DR ];

/// Des Ref HCA
Property REFDHCADR As CTHealthCareArea [ SqlColumnNumber = 40, SqlFieldName = REFD_HCA_DR ];

/// ZipCode
Property REFDZipCode As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = REFD_ZipCode ];

/// Bus Phone
Property REFDBusPhone As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = REFD_BusPhone ];

/// Fax
Property REFDFax As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = REFD_Fax ];

/// Mobile Phone
Property REFDMobilePhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = REFD_MobilePhone ];

/// Email
Property REFDEmail As %String(COLLATION = "Exact", MAXLEN = 70, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = REFD_Email ];

/// Preferred Contact
Property REFDPreferredContact As %String(DISPLAYLIST = ",Post,Email,Fax,Phone", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",P,E,F,M") [ SqlColumnNumber = 46, SqlFieldName = REFD_PreferredContact ];

/// Type
Property REFDType As %String(DISPLAYLIST = ",Doctor,Consultant,Dentist,CareProvider,OTHERS,SNSProfessional", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",GP,RD,DENT,CP,O,SNS") [ SqlColumnNumber = 47, SqlFieldName = REFD_Type ];

/// Reason For Non Consent
Property REFDReasonForNonConsent As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 48, SqlFieldName = REFD_ReasonForNonConsent ];

/// Des Ref HCR
Property REFDHCRDR As CTHealthCareRegion [ SqlColumnNumber = 49, SqlFieldName = REFD_HCR_DR ];

/// Org Change Date
Property REFDOrgChangeDate As %Date [ SqlColumnNumber = 50, SqlFieldName = REFD_OrgChangeDate ];

/// Forename
Property REFDForename As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = REFD_Forename ];

/// Pager
Property REFDPager As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 52, SqlFieldName = REFD_Pager ];

/// Des Ref Title
Property REFDTitleDR As CTTitle [ SqlColumnNumber = 53, SqlFieldName = REFD_Title_DR ];

/// Middle Name
Property REFDMiddleName As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 54, SqlFieldName = REFD_MiddleName ];

Index REFDCodeUnqIdx1 On REFDCode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACRefDoctor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRefDoctor","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d keyw^at1423($g(%d(1)))

 d ##Class(User.PACRefDoctor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRefDoctor","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d keyw^at1423($g(%d(1)))

 d ##Class(User.PACRefDoctor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRefDoctor","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACRefDoctor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRefDoctor","OnBeforeDelete")

 d VALDEL^at1423
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACRefDoctor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRefDoctor","OnBeforeUpdate")

 d VALUPD^at1423
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ClassName","OnBeforeInsert")

 d VALINS^at1423
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("REFD",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="REFD_Account">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="REFD_Address">
<Node>"ADDR"</Node>
</Data>
<Data name="REFD_Agency_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="REFD_Bank_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="REFD_BillGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="REFD_BusPhone">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="REFD_CITY_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REFD_CTZIP_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REFD_CheckRefrerralLimit">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="REFD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REFD_CurrentNumberOfPatients">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="REFD_Date">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="REFD_DateActiveFrom">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="REFD_DateActiveTo">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="REFD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REFD_Email">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="REFD_Fax">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="REFD_FiscalCode1">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="REFD_FiscalCode2">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="REFD_Forename">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="REFD_GraduationDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="REFD_GraduationPlace_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="REFD_Group">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="REFD_HCA_DR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="REFD_HCR_DR">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="REFD_MailingInfo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REFD_MastersDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="REFD_MastersPlace_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="REFD_MaximumReferralLimit">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="REFD_MedicalCode">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="REFD_MiddleName">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="REFD_MobilePhone">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="REFD_OrgChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="REFD_Pager">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="REFD_Phone">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="REFD_PreferredContact">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="REFD_Province_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REFD_QualificationDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="REFD_QualificationPlace_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="REFD_ReasonForNonConsent">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="REFD_ReasonToFinishContract">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="REFD_RegNumber1">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="REFD_RegNumber2">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="REFD_RegistrDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="REFD_Specialist">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="REFD_Specialty_DR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="REFD_Text1">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="REFD_Text2">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="REFD_Title">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REFD_Title_DR">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="REFD_Type">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="REFD_USSL">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="REFD_ZipCode">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>REFD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{REFD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REFD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REFD_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REFD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REFD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REFD_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REFD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REFD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REFD_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REFD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>REFD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TypeDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REFD_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({REFD_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{REFD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexZip">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REFD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Zip"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REFD_CTZIP_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REFD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexZipCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>REFD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ZipCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REFD_ZipCode})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({REFD_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{REFD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REFD_RowId</SqlRowIdName>
<StreamLocation>^User.PACRefDoctorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
