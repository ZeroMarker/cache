Class User.DHCWorkRegReport Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, StorageStrategy = SQLStorage ]
{

/// WR_PAADM_DR
Property WRPAADMDR As PAAdm [ SqlColumnNumber = 2, SqlFieldName = WR_PAADM_DR ];

/// WR_SQINV_DR
Property WRSQINVDR As %String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WR_SQINV_DR ];

/// WR_ADMDoc_DR
Property WRADMDocDR As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = WR_ADMDoc_DR ];

/// WR_ADMDEP_DR
Property WRADMDEPDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = WR_ADMDEP_DR ];

/// WR_ADMReason_DR
Property WRADMReasonDR As PACAdmReason [ SqlColumnNumber = 6, SqlFieldName = WR_ADMReason_DR ];

/// WR_RegUser
Property WRRegUser As SSUser [ SqlColumnNumber = 7, SqlFieldName = WR_RegUser ];

/// WR_ADMDate
Property WRADMDate As %Date [ SqlColumnNumber = 8, SqlFieldName = WR_ADMDate ];

/// WR_RegType_Dr
Property WRRegTypeDr As CTLoc [ SqlColumnNumber = 9, SqlFieldName = WR_RegType_Dr ];

/// WR_AAMT
Property WRAAMT As %Float [ SqlColumnNumber = 10, SqlFieldName = WR_AAMT ];

/// WR_Abook
Property WRAbook As %Float [ SqlColumnNumber = 11, SqlFieldName = WR_Abook ];

/// WR_Areg
Property WRAreg As %Float [ SqlColumnNumber = 12, SqlFieldName = WR_Areg ];

/// WR_Adia
Property WRAdia As %Float [ SqlColumnNumber = 13, SqlFieldName = WR_Adia ];

/// WR_Status
Property WRStatus As %String(MAXLEN = 8, VALUELIST = ",Normal||N,Withdraw||W") [ SqlColumnNumber = 14, SqlFieldName = WR_Status ];

/// WR_HandDate
Property WRHandDate As %Date [ SqlColumnNumber = 15, SqlFieldName = WR_HandDate ];

/// WR_Flag1
Property WRFlag1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = WR_Flag1 ];

/// WR_Flag2
Property WRFlag2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = WR_Flag2 ];

/// WR_Flag3
Property WRFlag3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = WR_Flag3 ];

/// WR_Flag4
Property WRFlag4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = WR_Flag4 ];

/// WR_StatDate
Property WRStatDate As %Date [ SqlColumnNumber = 20, SqlFieldName = WR_StatDate ];

/// WR_StatTime
Property WRStatTime As %Time [ SqlColumnNumber = 21, SqlFieldName = WR_StatTime ];

/// WR_text1
Property WRtext1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = WR_text1 ];

/// WR_text2
Property WRtext2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = WR_text2 ];

/// WR_Flag5
Property WRFlag5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = WR_Flag5 ];

/// WR_PAPMI_DR
Property WRPAPMIDR As PAPatMas [ SqlColumnNumber = 25, SqlFieldName = WR_PAPMI_DR ];

/// WR_DateMonFlag
Property WRDateMonFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = WR_DateMonFlag ];

/// WR_SundayServer
Property WRSundayServer As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = WR_SundayServer ];

/// WR_ AAMTRatio
Property WRAAMTRatio As %Float [ SqlColumnNumber = 28, SqlFieldName = WR_AAMTRatio ];

/// WR_NumberFlag
Property WRNumberFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = WR_NumberFlag ];

/// WR_ADMTime
Property WRADMTime As %Time [ SqlColumnNumber = 30, SqlFieldName = WR_ADMTime ];

/// WR_CountFlag
Property WRCountFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = WR_CountFlag ];

/// WR_HolidayServer
Property WRHolidayServer As %Numeric(SCALE = 2) [ SqlColumnNumber = 32, SqlFieldName = WR_HolidayServer ];

/// WR_Text3_
Property WRText3 As %Numeric(SCALE = 2) [ SqlColumnNumber = 33, SqlFieldName = WR_Text3 ];

///  WR_Text4
Property WRText4 As RBCSessionType [ SqlColumnNumber = 34, SqlFieldName = WR_Text4 ];

/// WR_ADMSource_DR
Property WRADMSourceDR As PACAdmSource [ SqlColumnNumber = 35, SqlFieldName = WR_ADMSource_DR ];

/// WR_AdmReadm
Property WRAdmReadm As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = WR_AdmReadm ];

/// WR_AppMethod
Property WRAppMethod As RBCAppointMethod [ SqlColumnNumber = 37, SqlFieldName = WR_AppMethod ];

/// WR_AppFee
Property WRAppFee As %Float [ SqlColumnNumber = 38, SqlFieldName = WR_AppFee ];

/// WR_AdmAge
Property WRAdmAge As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = WR_AdmAge ];

/// WR_AdmAddress
Property WRAdmAddress As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = WR_AdmAddress ];

/// WR_AdmCity
Property WRAdmCity As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = WR_AdmCity ];

/// WR_AdmCityarea
Property WRAdmCityarea As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = WR_AdmCityarea ];

/// WR_DocAMTRatio
Property WRDocAMTRatio As %Float [ SqlColumnNumber = 43, SqlFieldName = WR_DocAMTRatio ];

/// WR_MedicareFee
Property WRMedicareFee As %Float [ SqlColumnNumber = 44, SqlFieldName = WR_MedicareFee ];

/// WR_CityFlag
Property WRCityFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = WR_CityFlag ];

/// WR_SocialStatus_DR
Property WRSocialStatusDR As CTSocialStatus [ SqlColumnNumber = 46, SqlFieldName = WR_SocialStatus_DR ];

/// WR_ADMType
Property WRADMType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = WR_ADMType ];

/// WR_TimeRange
Property WRTimeRange As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = WR_TimeRange ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWorkRegReport(0))</SqlIdExpression>
<SQLMap name="IndexADMDate">
<Global>^DHCWorkRegReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WR_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WR_ADMDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WR_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdmDateSocial">
<Global>^DHCWorkRegReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WR_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmDateSocial"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WR_ADMDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WR_SocialStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WR_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdmDateType">
<Global>^DHCWorkRegReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WR_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmDateType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WR_ADMDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WR_ADMType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WR_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdmType">
<Global>^DHCWorkRegReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WR_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WR_ADMType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WR_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateMonFlag">
<Global>^DHCWorkRegReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WR_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateMonFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WR_DateMonFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WR_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHandDate">
<Global>^DHCWorkRegReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WR_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HANDDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WR_HandDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WR_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^DHCWorkRegReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WR_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WR_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WR_rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMI">
<Global>^DHCWorkRegReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WR_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WR_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WR_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSocialStatus">
<Global>^DHCWorkRegReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WR_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SocialStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WR_SocialStatus_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WR_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSqinv">
<Global>^DHCWorkRegReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WR_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Sqinv"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WR_SQINV_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WR_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatDate">
<Global>^DHCWorkRegReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WR_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STATDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WR_StatDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WR_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="datamaster">
<Data name="WR_AAMT">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WR_AAMTRatio">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="WR_ADMDEP_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WR_ADMDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WR_ADMDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WR_ADMReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WR_ADMSource_DR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="WR_ADMTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="WR_ADMType">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="WR_Abook">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WR_Adia">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WR_AdmAddress">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="WR_AdmAge">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="WR_AdmCity">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="WR_AdmCityarea">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="WR_AdmReadm">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="WR_AppFee">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="WR_AppMethod">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="WR_Areg">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WR_CityFlag">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="WR_CountFlag">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="WR_DateMonFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="WR_DocAMTRatio">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="WR_Flag1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WR_Flag2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WR_Flag3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WR_Flag4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WR_Flag5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WR_HandDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="WR_HolidayServer">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="WR_MedicareFee">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="WR_NumberFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="WR_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="WR_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="WR_RegType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="WR_RegUser">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="WR_SQINV_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="WR_SocialStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="WR_StatDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="WR_StatTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="WR_Status">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="WR_SundayServer">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="WR_Text3">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="WR_Text4">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="WR_TimeRange">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="WR_rowid">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="WR_text1">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="WR_text2">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Global>^DHCWorkRegReport</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WR_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{WR_rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>WR_rowid</SqlRowIdName>
<StreamLocation>^User.DHCWorkRegReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
