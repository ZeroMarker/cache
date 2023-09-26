/// Next Of Kin               (NOK,102)
Class User.PANok Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Nok, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On NOKChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to PAPMI
Relationship NOKPAPMIParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPANok, Required, SqlFieldName = NOK_PAPMI_ParRef ];

/// NOK ChildSub
Property NOKChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"NOK",0))}, Required, SqlColumnNumber = 2, SqlFieldName = NOK_ChildSub ];

/// Des Ref to CTRLT
Property NOKRelationDR As CTRelation [ SqlColumnNumber = 8, SqlFieldName = NOK_Relation_DR ];

/// Remarks
Property NOKRemarks As %String(COLLATION = "AlphaUp", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = NOK_Remarks ];

/// Archived Flag
Property NOKRcFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = NOK_RcFlag ];

/// Des Ref to PAPER
Property NOKPAPERDR As PAPerson [ SqlColumnNumber = 27, SqlFieldName = NOK_PAPER_DR ];

/// Date From
Property NOKDateFrom As %Date [ SqlColumnNumber = 28, SqlFieldName = NOK_DateFrom ];

/// Date To
Property NOKDateTo As %Date [ SqlColumnNumber = 29, SqlFieldName = NOK_DateTo ];

/// Des Ref ContactType
Property NOKContactTypeDR As PACContactType [ SqlColumnNumber = 30, SqlFieldName = NOK_ContactType_DR ];

/// Des Ref NonGovOrg
Property NOKNonGovOrgDR As PACNonGovOrg [ SqlColumnNumber = 31, SqlFieldName = NOK_NonGovOrg_DR ];

/// Carer Contribution
Property NOKCarerContribution As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = NOK_CarerContribution ];

/// Consent To Share Info
Property NOKConsentToShareInfo As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = NOK_ConsentToShareInfo ];

/// Non Consent Reason
Property NOKNonConsentReason As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = NOK_NonConsentReason ];

/// UpdateDate
Property NOKUpdateDate As %Date [ SqlColumnNumber = 35, SqlFieldName = NOK_UpdateDate ];

/// UpdateTime
Property NOKUpdateTime As %Time [ SqlColumnNumber = 36, SqlFieldName = NOK_UpdateTime ];

/// Des Ref UpdateUser
Property NOKUpdateUserDR As SSUser [ SqlColumnNumber = 37, SqlFieldName = NOK_UpdateUser_DR ];

/// Des Ref UpdateHospital
Property NOKUpdateHospitalDR As CTHospital [ SqlColumnNumber = 38, SqlFieldName = NOK_UpdateHospital_DR ];

/// First Contact
Property NOKFirstContact As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = NOK_FirstContact ];

/// Email
Property NOKEmail As %String(COLLATION = "Exact", MAXLEN = 70, TRUNCATE = 1) [ SqlColumnNumber = 40, SqlFieldName = NOK_Email ];

/// Foreign Address
Property NOKForeignAddress As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = NOK_ForeignAddress ];

/// Mob Phone
Property NOKMobPhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = NOK_MobPhone ];

/// Name
Property NOKName As %String(COLLATION = "AlphaUp", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = NOK_Name ];

/// Name2
Property NOKName2 As %String(COLLATION = "AlphaUp", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = NOK_Name2 ];

/// Name3
Property NOKName3 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = NOK_Name3 ];

/// StNameLine1
Property NOKStNameLine1 As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 46, SqlFieldName = NOK_StNameLine1 ];

/// TelH
Property NOKTelH As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 47, SqlFieldName = NOK_TelH ];

/// TelO
Property NOKTelO As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 48, SqlFieldName = NOK_TelO ];

/// Des Ref Title_DR
Property NOKTitleDR As CTTitle [ SqlColumnNumber = 49, SqlFieldName = NOK_Title_DR ];

/// Des Ref Province
Property NOKProvinceDR As CTProvince [ SqlColumnNumber = 50, SqlFieldName = NOK_Province_DR ];

/// Des Ref Zip
Property NOKZipDR As CTZip [ SqlColumnNumber = 51, SqlFieldName = NOK_Zip_DR ];

/// Des Ref CityCode
Property NOKCityCodeDR As CTCity [ SqlColumnNumber = 52, SqlFieldName = NOK_CityCode_DR ];

/// Des Ref Sex
Property NOKSexDR As CTSex [ SqlColumnNumber = 53, SqlFieldName = NOK_Sex_DR ];

/// Des Ref Country
Property NOKCountryDR As CTCountry [ SqlColumnNumber = 54, SqlFieldName = NOK_Country_DR ];

/// ForeignCity
Property NOKForeignCity As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 55, SqlFieldName = NOK_ForeignCity ];

/// ForeignPostCode
Property NOKForeignPostCode As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 56, SqlFieldName = NOK_ForeignPostCode ];

/// Des Ref CityArea
Property NOKCityAreaDR As CTCityArea [ SqlColumnNumber = 57, SqlFieldName = NOK_CityArea_DR ];

/// DateOfBirth
Property NOKDateOfBirth As %Date [ SqlColumnNumber = 58, SqlFieldName = NOK_DateOfBirth ];

/// Address2
Property NOKAddress2 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 59, SqlFieldName = NOK_Address2 ];

/// Des Ref SSUser
Property NOKFirstEnteredByDR As SSUser [ SqlColumnNumber = 60, SqlFieldName = NOK_FirstEnteredBy_DR ];

/// FirstEnteredDate
Property NOKFirstEnteredDate As %Date [ SqlColumnNumber = 61, SqlFieldName = NOK_FirstEnteredDate ];

/// FirstEnteredTime
Property NOKFirstEnteredTime As %Time [ SqlColumnNumber = 62, SqlFieldName = NOK_FirstEnteredTime ];

/// Rank
Property NOKRank As %Float [ SqlColumnNumber = 63, SqlFieldName = NOK_Rank ];

/// ReasonForEndDate
Property NOKReasonForEndDate As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 64, SqlFieldName = NOK_ReasonForEndDate ];

/// PreferredContactMethod
Property NOKPreferredContactMethod As %String(DISPLAYLIST = ",Post,Email,Fax,Phone", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",P,E,F,M") [ SqlColumnNumber = 65, SqlFieldName = NOK_PreferredContactMethod ];

/// Des Ref City
Property NOKPayorCityBirthDR As CTCity [ SqlColumnNumber = 66, SqlFieldName = NOK_PayorCityBirth_DR ];

/// Email2
Property NOKEmail2 As %String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 1) [ SqlColumnNumber = 67, SqlFieldName = NOK_Email2 ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PANok).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PANok","OnAfterInsert")
 d Table^HL7Outbound("PANok",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PANok).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PANok","OnAfterUpdate")
 d Table^HL7Outbound("PANok",%d(1),"Update")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PANok).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PANok","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PANok).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PANok","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PANok","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PANok).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PANok","OnAfterDelete")
 d Table^HL7Outbound("PANok",%old(1),"Delete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterMapNOK">
<Data name="NOK_Address2">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="NOK_CarerContribution">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NOK_CityArea_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="NOK_CityCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="NOK_ConsentToShareInfo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NOK_ContactType_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NOK_Country_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="NOK_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NOK_DateOfBirth">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="NOK_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NOK_Email">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="NOK_Email2">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="NOK_FirstContact">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="NOK_FirstEnteredBy_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="NOK_FirstEnteredDate">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="NOK_FirstEnteredTime">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="NOK_ForeignAddress">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="NOK_ForeignCity">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="NOK_ForeignPostCode">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="NOK_MobPhone">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="NOK_Name">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="NOK_Name2">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="NOK_Name3">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="NOK_NonConsentReason">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="NOK_NonGovOrg_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NOK_PAPER_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NOK_PayorCityBirth_DR">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="NOK_PreferredContactMethod">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="NOK_Province_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="NOK_Rank">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="NOK_RcFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NOK_ReasonForEndDate">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="NOK_Relation_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NOK_Remarks">
<Node>"RMK"</Node>
</Data>
<Data name="NOK_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="NOK_StNameLine1">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="NOK_TelH">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="NOK_TelO">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="NOK_Title_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="NOK_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="NOK_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="NOK_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="NOK_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="NOK_Zip_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>NOK_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"NOK"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{NOK_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPaperDR">
<Global>^PAPERDR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>NOK_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{NOK_PAPER_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"NOK"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{NOK_PAPMI_ParRef}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{NOK_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NOK_RowId</SqlRowIdName>
<StreamLocation>^User.PANokS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
