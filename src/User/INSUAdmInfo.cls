Class User.INSUAdmInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INADM_Rowid, SqlTableName = INSU_AdmInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INADM_AdmDr
Property INADMAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = INADM_AdmDr ];

/// INADM_InsuId
Property INADMInsuId As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INADM_InsuId ];

/// INADM_CardNo
Property INADMCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INADM_CardNo ];

/// INADM_PatType
Property INADMPatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INADM_PatType ];

/// INADM_CardStatus
Property INADMCardStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INADM_CardStatus ];

/// INADM_Company
Property INADMCompany As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INADM_Company ];

/// INADM_States
Property INADMStates As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INADM_States ];

/// INADM_Center
Property INADMCenter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INADM_Center ];

/// INADM_Account
Property INADMAccount As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INADM_Account ];

/// INADM_AdmSeriNo
Property INADMAdmSeriNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INADM_AdmSeriNo ];

/// INADM_ActiveFlag
Property INADMActiveFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INADM_ActiveFlag ];

/// INADM_AdmDate
Property INADMAdmDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = INADM_AdmDate ];

/// INADM_AdmTime
Property INADMAdmTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = INADM_AdmTime ];

/// INADM_AdmType
Property INADMAdmType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INADM_AdmType ];

/// INADM_DeptDesc
Property INADMDeptDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INADM_DeptDesc ];

/// INADM_InsuUser
Property INADMInsuUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INADM_InsuUser ];

/// INADM_IpTimes
Property INADMIpTimes As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = INADM_IpTimes ];

/// INADM_InsuType
Property INADMInsuType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INADM_InsuType ];

/// INADM_AdmCancelNo
Property INADMAdmCancelNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INADM_AdmCancelNo ];

/// INADM_OutDate
Property INADMOutDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = INADM_OutDate ];

/// INADM_OutTime
Property INADMOutTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = INADM_OutTime ];

/// INADM_OutUser
Property INADMOutUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INADM_OutUser ];

/// INADM_UserDr
Property INADMUserDr As User.SSUser [ SqlColumnNumber = 24, SqlFieldName = INADM_UserDr ];

/// INADM_FunDate
Property INADMFunDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = INADM_FunDate ];

/// INADM_FunTime
Property INADMFunTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = INADM_FunTime ];

/// INADM_XString1
Property INADMXString1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INADM_XString1 ];

/// INADM_XString2
Property INADMXString2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INADM_XString2 ];

/// INADM_XString3
Property INADMXString3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = INADM_XString3 ];

/// INADM_XString4
Property INADMXString4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = INADM_XString4 ];

/// INADM_XFloat1
Property INADMXFloat1 As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = INADM_XFloat1 ];

/// INADM_XFloat2
Property INADMXFloat2 As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = INADM_XFloat2 ];

/// INADM_XFloat3
Property INADMXFloat3 As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = INADM_XFloat3 ];

/// INADM_XFloat4
Property INADMXFloat4 As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = INADM_XFloat4 ];

/// INADM_XString5
Property INADMXString5 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = INADM_XString5 ];

/// INADM_XString6
Property INADMXString6 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = INADM_XString6 ];

/// INADM_XString7
Property INADMXString7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = INADM_XString7 ];

/// INADM_XString8
Property INADMXString8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = INADM_XString8 ];

/// INADM_XString9
Property INADMXString9 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = INADM_XString9 ];

/// INADM_XString10
Property INADMXString10 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = INADM_XString10 ];

/// INADM_XString11
Property INADMXString11 As %Library.String(COLLATION = "Exact", MAXLEN = 100, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = INADM_XString11 ];

/// INADM_XString12
Property INADMXString12 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = INADM_XString12 ];

/// INADM_XString13
Property INADMXString13 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = INADM_XString13 ];

/// INADM_XString14
Property INADMXString14 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = INADM_XString14 ];

/// INADM_XString15
Property INADMXString15 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = INADM_XString15 ];

/// INADM_XString16
Property INADMXString16 As %Library.String(COLLATION = "Exact", MAXLEN = 600, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = INADM_XString16 ];

/// INADM_XString17
Property INADMXString17 As %Library.String(COLLATION = "Exact", MAXLEN = 600, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = INADM_XString17 ];

/// INADM_XString18
Property INADMXString18 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = INADM_XString18 ];

/// INADM_XString19
Property INADMXString19 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = INADM_XString19 ];

/// INADM_XString20
Property INADMXString20 As %Library.String(COLLATION = "Exact", MAXLEN = 800, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = INADM_XString20 ];

/// INADM_InsuAdmInfoDr
Property INADMInsuAdmInfoDr As User.INSUAdmInfo [ SqlColumnNumber = 51, SqlFieldName = INADM_InsuAdmInfoDr ];

/// INADM_HospDr DingSH 20200617
Property INADMHospDr As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = INADM_HospDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINADM)</SqlIdExpression>
<SQLMap name="DateMasterMap">
<Data name="INADM_Account">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INADM_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INADM_AdmCancelNo">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INADM_AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INADM_AdmDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INADM_AdmSeriNo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INADM_AdmTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INADM_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INADM_CardNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INADM_CardStatus">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INADM_Center">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INADM_Company">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INADM_DeptDesc">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INADM_FunDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INADM_FunTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INADM_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="INADM_InsuAdmInfoDr">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="INADM_InsuId">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INADM_InsuType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INADM_InsuUser">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INADM_IpTimes">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INADM_OutDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INADM_OutTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INADM_OutUser">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INADM_PatType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INADM_States">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INADM_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INADM_XFloat1">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INADM_XFloat2">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INADM_XFloat3">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INADM_XFloat4">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INADM_XString1">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INADM_XString10">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INADM_XString11">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INADM_XString12">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INADM_XString13">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="INADM_XString14">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="INADM_XString15">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="INADM_XString16">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="INADM_XString17">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="INADM_XString18">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="INADM_XString19">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="INADM_XString2">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INADM_XString20">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="INADM_XString3">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INADM_XString4">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INADM_XString5">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INADM_XString6">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INADM_XString7">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INADM_XString8">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INADM_XString9">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Global>^DHCINADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INADM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INADM_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofADM">
<Global>^DHCINADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INADM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INADM_AdmDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INADM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofAdmSeriNo">
<Global>^DHCINADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INADM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmSeriNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INADM_AdmSeriNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INADM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofCardNo">
<Global>^DHCINADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INADM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CardNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INADM_CardNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INADM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDate">
<Global>^DHCINADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INADM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ADMDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INADM_AdmDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INADM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofFunDate">
<Global>^DHCINADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INADM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FunDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INADM_FunDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INADM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofInsuId">
<Global>^DHCINADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INADM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InsuId"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INADM_InsuId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INADM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUAdmInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
