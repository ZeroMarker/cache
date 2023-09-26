/// CF System Defaults      (SMCF,662)
Class User.CFSM Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_SM, StorageStrategy = SQLStorage ]
{

/// SMCF Row ID
Property SMCFRowId As %Float [ InitialExpression = 1, Required, SqlFieldName = SMCF_RowId ];

/// Path for Document Server
Property SMCFPathToDocumentServer As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SMCF_PathToDocumentServer ];

/// Path to Images Server
Property SMCFPathToImagesServer As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SMCF_PathToImagesServer ];

/// Document Counter
Property SMCFDocumentCounter As %Float [ InitialExpression = 1, SqlColumnNumber = 7, SqlFieldName = SMCF_DocumentCounter ];

/// Image Counter
Property SMCFImageCounter As %Float [ SqlColumnNumber = 8, SqlFieldName = SMCF_ImageCounter ];

/// System Name
Property SMCFName1 As %String(COLLATION = "Exact", MAXLEN = 25, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = SMCF_Name1 ];

/// System Name 2
Property SMCFName2 As %String(COLLATION = "Exact", MAXLEN = 25, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = SMCF_Name2 ];

/// Path To Error File Server
Property SMCFPathToErrorFileServer As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = SMCF_PathToErrorFileServer ];

/// Error File Counter
Property SMCFErrorFileCounter As %Float [ SqlColumnNumber = 12, SqlFieldName = SMCF_ErrorFileCounter ];

/// Version of MedTrak
Property SMCFMedTrakVersion As %String(DISPLAYLIST = ",Korean - Inha,European", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",KI,I") [ SqlColumnNumber = 13, SqlFieldName = SMCF_MedTrakVersion ];

/// Default Language Number
Property SMCFLanguageCode As %Float [ SqlColumnNumber = 14, SqlFieldName = SMCF_LanguageCode ];

/// Path To Template Server
Property SMCFPathToTemplateServer As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = SMCF_PathToTemplateServer ];

/// Billing Version
Property SMCFBillingVersion As %String(DISPLAYLIST = ",Korean - Inha,Italian - Brescia,European,Spanish,Brazilian,Bahrain,Greek,Australian,Malaysia,Thailand,UK,Philippines,Taiwan,China,India,Thailand-BGH,Thailand-PHYATHAI,Australia-Queensland,Indonesia,UK Priory,Portugal,Middle East,St George,GPS-Portugal,Hong Kong,Standard", MAXLEN = 20, TRUNCATE = 1, VALUELIST = ",KI,I,E,S,B,BH,GR,A,M,T,UK,PH,TW,CH,IN,TB,TP,QA,INDON,UKP,PORT,ME,STG,GPS,HK,STD") [ SqlColumnNumber = 16, SqlFieldName = SMCF_BillingVersion ];

/// Version of Word
Property SMCFWordVersion As %String(DISPLAYLIST = ",Italian 95,Spanish 95,Office 95,Office 97,Portuguese,German,Finnish,Greek,French", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",I,S,N,O,P,GE,FI,GR,FR") [ SqlColumnNumber = 17, SqlFieldName = SMCF_WordVersion ];

/// Path To Voice File Server
Property SMCFPathToVoiceFileServer As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = SMCF_PathToVoiceFileServer ];

/// Voice File Counter
Property SMCFVoiceFileCounter As %Float [ SqlColumnNumber = 19, SqlFieldName = SMCF_VoiceFileCounter ];

/// Today Nominator
Property SMCFTodayNominator As %String(COLLATION = "AlphaUp", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = SMCF_TodayNominator ];

/// Now Nominator
Property SMCFNowNominator As %String(COLLATION = "AlphaUp", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = SMCF_NowNominator ];

/// Default Number Format
Property SMCFDefNumberFormat As %String(DISPLAYLIST = ",1000,1.000,1000.99,1.000,99,1.000,999", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",1,,4,,1,2,4,2,4,3") [ SqlColumnNumber = 22, SqlFieldName = SMCF_DefNumberFormat ];

/// Default Date Format
Property SMCFDefDateFormat As %String(DISPLAYLIST = ",MM/DD/YY,DD/MM/YY", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",1,4") [ SqlColumnNumber = 23, SqlFieldName = SMCF_DefDateFormat ];

/// Path To DICOM Server
Property SMCFPathToDICOMServer As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = SMCF_PathToDICOMServer ];

/// DICOM Counter
Property SMCFDICOMCounter As %Float [ SqlColumnNumber = 25, SqlFieldName = SMCF_DICOMCounter ];

/// Main Database Server
Property SMCFMainDatabaseServer As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = SMCF_MainDatabaseServer ];

/// Path To DICOM Archive
Property SMCFPathToDICOMArchive As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = SMCF_PathToDICOMArchive ];

/// Path To DICOM Cache
Property SMCFPathToDICOMCache As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = SMCF_PathToDICOMCache ];

/// DICOM Archive Prefix
Property SMCFDICOMArchivePrefix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = SMCF_DICOMArchivePrefix ];

/// DICOM Arcive Counter
Property SMCFDICOMArciveCounter As %Float [ SqlColumnNumber = 30, SqlFieldName = SMCF_DICOMArciveCounter ];

/// Allow Deletion From Code Tables
Property SMCFAllowDeletionFromCodeTables As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = SMCF_AllowDeletionFromCodeTables ];

/// Path To Crystal Report Server
Property SMCFPathToCrystalReportServer As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = SMCF_PathToCrystalReportServer ];

/// Path To DRG Grouper
Property SMCFPathToDRGGrouper As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = SMCF_PathToDRGGrouper ];

/// Use New LabTrak
Property SMCFNewLabTrak As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = SMCF_NewLabTrak ];

/// Des Ref HCA
Property SMCFHCADR As CTHealthCareArea [ SqlColumnNumber = 35, SqlFieldName = SMCF_HCA_DR ];

/// Des Ref City
Property SMCFCityDR As CTCity [ SqlColumnNumber = 36, SqlFieldName = SMCF_City_DR ];

/// Des Ref Province
Property SMCFProvinceDR As CTProvince [ SqlColumnNumber = 37, SqlFieldName = SMCF_Province_DR ];

/// DSN
Property SMCFCrystalRepDSN As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = SMCF_CrystalRepDSN ];

/// User ID
Property SMCFCrystalRepUserID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 39, SqlFieldName = SMCF_CrystalRepUserID ];

/// Password
Property SMCFCrystRepPassword As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 40, SqlFieldName = SMCF_CrystRepPassword ];

/// Licensed Number of Users
Property SMCFLicenseUsersMax As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = SMCF_LicenseUsersMax ];

/// Current Number of Users
Property SMCFLicenseUsersCurrent As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = SMCF_LicenseUsersCurrent ];

/// Inactivity Timeout (mins)
Property SMCFInactivityTimeout As %Float [ SqlColumnNumber = 43, SqlFieldName = SMCF_InactivityTimeout ];

/// Close All Forms On Exit
Property SMCFCloseAllFormsOnExit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 44, SqlFieldName = SMCF_CloseAllFormsOnExit ];

/// Labtrak User ID
Property SMCFLabtrakUserID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = SMCF_LabtrakUserID ];

/// Labtrak User Password
Property SMCFLabtrakUserPassword As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 46, SqlFieldName = SMCF_LabtrakUserPassword ];

/// License Site ID
Property SMCFLicenseSiteID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 47, SqlFieldName = SMCF_LicenseSiteID ];

/// License Key
Property SMCFLicenseKey As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 48, SqlFieldName = SMCF_LicenseKey ];

/// Invalid Login Attempts
Property SMCFInvalidLoginAttempts As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 49, SqlFieldName = SMCF_InvalidLoginAttempts ];

/// License Expiry Date
Property SMCFLicenseExpires As %Date [ SqlColumnNumber = 50, SqlFieldName = SMCF_LicenseExpires ];

/// Enable System CT
Property SMCFEnableSystemCT As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 51, SqlFieldName = SMCF_EnableSystemCT ];

/// Password Days To Expire
Property SMCFPasswordDaysToExpire As %Float [ SqlColumnNumber = 52, SqlFieldName = SMCF_PasswordDaysToExpire ];

/// Password Min Length
Property SMCFPasswordMinLength As %Float [ SqlColumnNumber = 53, SqlFieldName = SMCF_PasswordMinLength ];

/// Audit User Login
Property SMCFAuditUserLogin As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = SMCF_AuditUserLogin ];

/// Explore Path
Property SMCFExplorePath As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 55, SqlFieldName = SMCF_ExplorePath ];

/// Link to External Lab system
Property SMCFLinkExtLab As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = SMCF_LinkExtLab ];

/// CSPPath
Property SMCFCSPPath As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 57, SqlFieldName = SMCF_CSPPath ];

/// Enable Access NT Logon
Property SMCFEnableAccessNTLogon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 58, SqlFieldName = SMCF_EnableAccessNTLogon ];

/// Path To Unix Grouper
Property SMCFPathToUnixGrouper As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 59, SqlFieldName = SMCF_PathToUnixGrouper ];

/// Passw to Contain Up,Low,Spec,Num Chars
Property SMCFPasswContainULSNChars As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 60, SqlFieldName = SMCF_PasswContainULSNChars ];

/// CTNamespace
Property SMCFCTNamespace As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 61, SqlFieldName = SMCF_CTNamespace ];

/// CreateWebIndexes
Property SMCFCreateWebIndexes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 62, SqlFieldName = SMCF_CreateWebIndexes ];

/// RestrictUserSameGroup
Property SMCFRestrictUserSameGroup As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 63, SqlFieldName = SMCF_RestrictUserSameGroup ];

/// NoRestrictUserSameGroupOE
Property SMCFNoRestrictUserSameGroupOE As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 64, SqlFieldName = SMCF_NoRestrictUserSameGroupOE ];

/// InvokeUserCacheAuditDLL
Property SMCFInvokeUserCacheAuditDLL As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 65, SqlFieldName = SMCF_InvokeUserCacheAuditDLL ];

/// HL7QueryTimeoutInSecs
Property SMCFHL7QueryTimeoutInSecs As %Float [ SqlColumnNumber = 66, SqlFieldName = SMCF_HL7QueryTimeoutInSecs ];

/// DoNotDeleteGrouperFile
Property SMCFDoNotDeleteGrouperFile As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 67, SqlFieldName = SMCF_DoNotDeleteGrouperFile ];

/// TrakCareURL
Property SMCFTrakCareURL As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 68, SqlFieldName = SMCF_TrakCareURL ];

/// IEPathName
Property SMCFIEPathName As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 69, SqlFieldName = SMCF_IEPathName ];

Index RowIDBasedIDKeyIndex On SMCFRowId [ IdKey, PrimaryKey, Unique ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFSM).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSM","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFSM).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSM","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFSM).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSM","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFSM).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSM","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSM","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFSM).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSM","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>1</SqlIdExpression>
<SQLMap name="DataMasterSMCF">
<Data name="SMCF_AllowDeletionFromCodeTables">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="SMCF_AuditUserLogin">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="SMCF_BillingVersion">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SMCF_CSPPath">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="SMCF_CTNamespace">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="SMCF_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="SMCF_CloseAllFormsOnExit">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="SMCF_CreateWebIndexes">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="SMCF_CrystRepPassword">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="SMCF_CrystalRepDSN">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="SMCF_CrystalRepUserID">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="SMCF_DICOMArchivePrefix">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="SMCF_DICOMArciveCounter">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="SMCF_DICOMCounter">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SMCF_DefDateFormat">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SMCF_DefNumberFormat">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SMCF_DoNotDeleteGrouperFile">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="SMCF_DocumentCounter">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SMCF_EnableAccessNTLogon">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="SMCF_EnableSystemCT">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="SMCF_ErrorFileCounter">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SMCF_ExplorePath">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="SMCF_HCA_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="SMCF_HL7QueryTimeoutInSecs">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="SMCF_IEPathName">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="SMCF_ImageCounter">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SMCF_InactivityTimeout">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="SMCF_InvalidLoginAttempts">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="SMCF_InvokeUserCacheAuditDLL">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="SMCF_LabtrakUserID">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="SMCF_LabtrakUserPassword">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="SMCF_LanguageCode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SMCF_LicenseExpires">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="SMCF_LicenseKey">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="SMCF_LicenseSiteID">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="SMCF_LicenseUsersCurrent">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="SMCF_LicenseUsersMax">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="SMCF_LinkExtLab">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="SMCF_MainDatabaseServer">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SMCF_MedTrakVersion">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SMCF_Name1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SMCF_Name2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SMCF_NewLabTrak">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="SMCF_NoRestrictUserSameGroupOE">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="SMCF_NowNominator">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SMCF_PasswContainULSNChars">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="SMCF_PasswordDaysToExpire">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="SMCF_PasswordMinLength">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="SMCF_PathToCrystalReportServer">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="SMCF_PathToDICOMArchive">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SMCF_PathToDICOMCache">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SMCF_PathToDICOMServer">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SMCF_PathToDRGGrouper">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="SMCF_PathToDocumentServer">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SMCF_PathToErrorFileServer">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SMCF_PathToImagesServer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SMCF_PathToTemplateServer">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SMCF_PathToUnixGrouper">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="SMCF_PathToVoiceFileServer">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SMCF_Province_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="SMCF_RestrictUserSameGroup">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="SMCF_TodayNominator">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SMCF_TrakCareURL">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="SMCF_VoiceFileCounter">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SMCF_WordVersion">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^CF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SMCF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{SMCF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SMCF_RowId</SqlRowIdName>
<StreamLocation>^User.CFSMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
