/// 医保转诊信息表
Class User.INSUReferralInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INREF_Rowid, SqlTableName = INSU_ReferralInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INREF_AdmDr
Property INREFAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = INREF_AdmDr ];

/// INREF_InsuAdmInfoDr
Property INREFInsuAdmInfoDr As User.INSUAdmInfo [ SqlColumnNumber = 3, SqlFieldName = INREF_InsuAdmInfoDr ];

/// INREF_TurnCode 转诊单编号
Property INREFTurnCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INREF_TurnCode ];

/// INREF_CenterNo 农合中心编码
Property INREFCenterNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INREF_CenterNo ];

/// INREF_MemberNo 成员编码
Property INREFMemberNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INREF_MemberNo ];

/// INREF_InsuType 医保类型
Property INREFInsuType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INREF_InsuType ];

/// INREF_IdcardNo 身份证号
Property INREFIdcardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INREF_IdcardNo ];

/// INREF_Name 姓名
Property INREFName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INREF_Name ];

/// INREF_Sex 性别
Property INREFSex As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INREF_Sex ];

/// INREF_Birthday 出生日期
Property INREFBirthday As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = INREF_Birthday ];

/// INREF_BookCardNo 医疗证卡号
Property INREFBookCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INREF_BookCardNo ];

/// INREF_BookNo 医疗证号
Property INREFBookNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INREF_BookNo ];

/// INREF_ActiveFlag 生效标志
Property INREFActiveFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INREF_ActiveFlag ];

/// INREF_Relation 与户主关系
Property INREFRelation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INREF_Relation ];

/// INREF_Isrelief 是否民政救助对象
Property INREFIsrelief As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INREF_Isrelief ];

/// INREF_TurnType 转诊类型
Property INREFTurnType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INREF_TurnType ];

/// INREF_IcdCode 转诊诊断编码
Property INREFIcdCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INREF_IcdCode ];

/// INREF_IcdName 转诊诊断名称
Property INREFIcdName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INREF_IcdName ];

/// INREF_TurnDate 转诊日期
Property INREFTurnDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INREF_TurnDate ];

/// INREF_iDate 操作日期
Property INREFiDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = INREF_iDate ];

/// INREF_iTime 操作时间
Property INREFiTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = INREF_iTime ];

/// INREF_UserDr 操作员
Property INREFUserDr As User.SSUser [ SqlColumnNumber = 23, SqlFieldName = INREF_UserDr ];

/// INREF_FromHospCode 转来医院代码
Property INREFFromHospCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INREF_FromHospCode ];

/// INREF_FromHospName 传来医院名称
Property INREFFromHospName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INREF_FromHospName ];

/// INREF_ToHospCode 转入医院代码
Property INREFToHospCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INREF_ToHospCode ];

/// INREF_ToHospName 转入医院名称
Property INREFToHospName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INREF_ToHospName ];

/// INREF_JoinType 参合属性
Property INREFJoinType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INREF_JoinType ];

/// INREF_FamilyType 户属性
Property INREFFamilyType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = INREF_FamilyType ];

/// INREF_TownCode 乡镇编码  6位(县市)+3位(乡镇)+3位(村)
Property INREFTownCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = INREF_TownCode ];

/// INREF_TownName 乡镇名称
Property INREFTownName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = INREF_TownName ];

/// INREF_VillageCode 村编码
Property INREFVillageCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = INREF_VillageCode ];

/// INREF_VillageName 村名称
Property INREFVillageName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = INREF_VillageName ];

/// INREF_GroupCode 组编码
Property INREFGroupCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = INREF_GroupCode ];

/// INREF_GroupName 组名称
Property INREFGroupName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = INREF_GroupName ];

/// INREF_Demo1
Property INREFDemo1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = INREF_Demo1 ];

/// INREF_Demo2
Property INREFDemo2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = INREF_Demo2 ];

/// INREF_Demo3
Property INREFDemo3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = INREF_Demo3 ];

/// INREF_Demo4
Property INREFDemo4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = INREF_Demo4 ];

/// INREF_Demo5
Property INREFDemo5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = INREF_Demo5 ];

/// INREF_Demo6
Property INREFDemo6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = INREF_Demo6 ];

/// INREF_Demo7
Property INREFDemo7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = INREF_Demo7 ];

/// INREF_Demo8
Property INREFDemo8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = INREF_Demo8 ];

/// INREF_Demo9
Property INREFDemo9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = INREF_Demo9 ];

/// INREF_Demo10
Property INREFDemo10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = INREF_Demo10 ];

/// INREF_InRefDr
Property INREFInRefDr As User.INSUReferralInfo [ SqlColumnNumber = 46, SqlFieldName = INREF_InRefDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINREFER)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INREF_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INREF_AdmDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INREF_Birthday">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INREF_BookCardNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INREF_BookNo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INREF_CenterNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INREF_Demo1">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INREF_Demo10">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="INREF_Demo2">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INREF_Demo3">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INREF_Demo4">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INREF_Demo5">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INREF_Demo6">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INREF_Demo7">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INREF_Demo8">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="INREF_Demo9">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="INREF_FamilyType">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INREF_FromHospCode">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INREF_FromHospName">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INREF_GroupCode">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INREF_GroupName">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INREF_IcdCode">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INREF_IcdName">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INREF_IdcardNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INREF_InRefDr">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="INREF_InsuAdmInfoDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INREF_InsuType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INREF_Isrelief">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INREF_JoinType">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INREF_MemberNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INREF_Name">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INREF_Relation">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INREF_Sex">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INREF_ToHospCode">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INREF_ToHospName">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INREF_TownCode">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INREF_TownName">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INREF_TurnCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INREF_TurnDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INREF_TurnType">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INREF_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INREF_VillageCode">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INREF_VillageName">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INREF_iDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INREF_iTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Global>^DHCINREFER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INREF_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INREF_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexofAdmDr">
<Global>^DHCINREFER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INREF_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INREF_AdmDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INREF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexofInAdmDr">
<Global>^DHCINREFER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INREF_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InAdmDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INREF_InsuAdmInfoDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INREF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexofTurnCode">
<Global>^DHCINREFER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INREF_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TurnCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INREF_TurnCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INREF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexofiDate">
<Global>^DHCINREFER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INREF_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"iDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INREF_iDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INREF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUReferralInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
