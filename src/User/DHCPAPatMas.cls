/// DHC_PA_PatMas
Class User.DHCPAPatMas Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PAPMI_RowId, SqlTableName = DHC_PA_PatMas, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PAPMI_BirthTime
Property PAPMIBirthTime As %Library.Time [ SqlColumnNumber = 2, SqlFieldName = PAPMI_BirthTime ];

/// PAPMI_BirthPlace
Property PAPMIBirthPlace As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PAPMI_BirthPlace ];

/// PAPMI_Gravida
Property PAPMIGravida As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PAPMI_Gravida ];

/// PAPMI_Para
Property PAPMIPara As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PAPMI_Para ];

/// PAPMI_DrugCell
Property PAPMIDrugCell As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PAPMI_DrugCell ];

/// PAPMI_DrugCellUser_Dr
Property PAPMIDrugCellUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PAPMI_DrugCellUser_Dr ];

/// PAPMI_DrugCellDate
Property PAPMIDrugCellDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PAPMI_DrugCellDate ];

/// PAPMI_DrugCellTime
Property PAPMIDrugCellTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PAPMI_DrugCellTime ];

/// 医保证件类型:蓝本,黄本,红本
Property PAPMIInsurAdmCategory As User.PACAdmCategory [ SqlColumnNumber = 10, SqlFieldName = PAPMI_InsurAdmCategory ];

/// 第二联系电话
Property PAPMISecondMobPhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PAPMI_SecondMobPhone ];

/// 第二联系电话持有人关系
Property PAPMISecondRLTDR As User.CTRelation [ SqlColumnNumber = 12, SqlFieldName = PAPMI_SecondRLT_DR ];

/// 本地联系人姓名
Property PAPMILocalContactName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PAPMI_LocalContactName ];

/// 与本地联系人关系
Property PAPMILocalContactRelationDR As User.CTRelation [ SqlColumnNumber = 14, SqlFieldName = PAPMI_LocalContactRelation_DR ];

/// 本地联系人电话
Property PAPMILocalContactPhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PAPMI_LocalContactPhone ];

/// 是否旅客
Property PAPMITouristFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = PAPMI_TouristFlag ];

/// 酒店名称
Property PAPMITouristHotelName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PAPMI_TouristHotelName ];

/// 到达日期
Property PAPMIArrivalDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = PAPMI_ArrivalDate ];

/// 预计离开日期
Property PAPMILeaveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = PAPMI_LeaveDate ];

/// 身份选择(存入代码)
Property PAPMIChooseIdentity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PAPMI_ChooseIdentity ];

/// 国际联系手机
Property PAPMIForeignMobile As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PAPMI_ForeignMobile ];

/// 本地地址(在华地址)
Property PAPMILocalAddress As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PAPMI_LocalAddress ];

/// 本地电话(在华电话)
Property PAPMILocalPhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PAPMI_LocalPhone ];

/// 本地手机(在华手机)
Property PAPMILocalMobile As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PAPMI_LocalMobile ];

/// 第二电子邮件
Property PAPMISecondEmail As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PAPMI_SecondEmail ];

/// 雇主
Property PAPMIEmployer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PAPMI_Employer ];

/// 雇主地址
Property PAPMIEmployerAddress As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PAPMI_EmployerAddress ];

/// 雇主Email
Property PAPMIEmployerEmail As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PAPMI_EmployerEmail ];

/// 雇主电话
Property PAPMIEmployerPhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = PAPMI_EmployerPhone ];

/// 会员选择(存入代码)
Property PAPMIMembership As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = PAPMI_Membership ];

/// ---------------------------------密级干保相关---------------------------------------------
/// 病人密级
Property PAPMISecretLevelDR As User.DHCSecretLevel [ SqlColumnNumber = 31, SqlFieldName = PAPMI_SecretLevel_DR ];

/// 审批部门
Property PAPMIApprovalDeptDR As User.DHCDocCTDefineData [ SqlColumnNumber = 32, SqlFieldName = PAPMI_ApprovalDept_DR ];

/// 所在部门
Property PAPMIDepartmentOffice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = PAPMI_DepartmentOffice ];

/// 上级单位
Property PAPMISuperiorUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = PAPMI_SuperiorUnit ];

/// 工作年月
Property PAPMIWorkDate As %Library.Date [ SqlColumnNumber = 35, SqlFieldName = PAPMI_WorkDate ];

/// 职务/职称
Property PAPMIPostTitle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = PAPMI_PostTitle ];

/// 在岗状态
Property PAPMIPostTitleState As User.DHCDocCTDefineData [ SqlColumnNumber = 37, SqlFieldName = PAPMI_PostTitleState ];

/// 级别说明
Property PAPMILevelDR As User.DHCDocCTDefineData [ SqlColumnNumber = 38, SqlFieldName = PAPMI_Level_DR ];

/// 合同医院
Property PAPMIContractHospitalDR As User.DHCDocCTDefineData [ SqlColumnNumber = 39, SqlFieldName = PAPMI_ContractHospital_DR ];

/// 批准文号
Property PAPMIApprovalNumber As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = PAPMI_ApprovalNumber ];

/// 办理状态
Property PAPMIHandleState As User.DHCDocCTDefineData [ SqlColumnNumber = 41, SqlFieldName = PAPMI_HandleState ];

/// 办理日期
Property PAPMIHandleDate As %Library.Date [ SqlColumnNumber = 42, SqlFieldName = PAPMI_HandleDate ];

/// 办理时间
Property PAPMIHandleTime As %Library.Time [ SqlColumnNumber = 43, SqlFieldName = PAPMI_HandleTime ];

/// 单位联系人（报批）
Property PAPMICompanyContactPerson As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = PAPMI_CompanyContactPerson ];

/// 单位联系人电话（报批）
Property PAPMICompanyContactTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = PAPMI_CompanyContactTel ];

/// 诊疗/门禁卡号
Property PAPMIAdmCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = PAPMI_AdmCardNo ];

/// 车证
Property PAPMICarCertNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = PAPMI_CarCertNo ];

/// 备注
Property PAPMICadresHealthRemark As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = PAPMI_CadresHealthRemark ];

/// 代办人证件号码
Property PAPMIAgencyCredNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = PAPMI_AgencyCredNo ];

/// 代办人姓名
Property PAPMIAgencyName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = PAPMI_AgencyName ];

/// 代办人电话
Property PAPMIAgencyTel As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = PAPMI_AgencyTel ];

/// ART号,IVF(生殖医学中心)的唯一号
Property PAPMIARTNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = PAPMI_ARTNo ];

/// 街道出生
Property PAPMIStreetBirth As User.CTLocalityType [ SqlColumnNumber = 53, SqlFieldName = PAPMI_StreetBirth ];

/// 街道户口
Property PAPMIStreetHouse As User.CTLocalityType [ SqlColumnNumber = 54, SqlFieldName = PAPMI_StreetHouse ];

/// 街道现住
Property PAPMIStreetNow As User.CTLocalityType [ SqlColumnNumber = 55, SqlFieldName = PAPMI_StreetNow ];

/// 社区出生
Property PAPMICommunityBirth As User.CTCommunity [ SqlColumnNumber = 56, SqlFieldName = PAPMI_CommunityBirth ];

/// 社区户口
Property PAPMICommunityHouse As User.CTCommunity [ SqlColumnNumber = 57, SqlFieldName = PAPMI_CommunityHouse ];

/// 社区现住
Property PAPMICommunityNow As User.CTCommunity [ SqlColumnNumber = 58, SqlFieldName = PAPMI_CommunityNow ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPAPER(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PAPMI_ARTNo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>51</Piece>
</Data>
<Data name="PAPMI_AdmCardNo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>45</Piece>
</Data>
<Data name="PAPMI_AgencyCredNo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>48</Piece>
</Data>
<Data name="PAPMI_AgencyName">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>49</Piece>
</Data>
<Data name="PAPMI_AgencyTel">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>50</Piece>
</Data>
<Data name="PAPMI_ApprovalDept_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>31</Piece>
</Data>
<Data name="PAPMI_ApprovalNumber">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>39</Piece>
</Data>
<Data name="PAPMI_ArrivalDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>17</Piece>
</Data>
<Data name="PAPMI_BirthPlace">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="PAPMI_BirthTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="PAPMI_CadresHealthRemark">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>47</Piece>
</Data>
<Data name="PAPMI_CarCertNo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>46</Piece>
</Data>
<Data name="PAPMI_ChooseIdentity">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>19</Piece>
</Data>
<Data name="PAPMI_CommunityBirth">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>55</Piece>
</Data>
<Data name="PAPMI_CommunityHouse">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>56</Piece>
</Data>
<Data name="PAPMI_CommunityNow">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>57</Piece>
</Data>
<Data name="PAPMI_CompanyContactPerson">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>43</Piece>
</Data>
<Data name="PAPMI_CompanyContactTel">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>44</Piece>
</Data>
<Data name="PAPMI_ContractHospital_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>38</Piece>
</Data>
<Data name="PAPMI_DepartmentOffice">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>32</Piece>
</Data>
<Data name="PAPMI_DrugCell">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="PAPMI_DrugCellDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>7</Piece>
</Data>
<Data name="PAPMI_DrugCellTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>8</Piece>
</Data>
<Data name="PAPMI_DrugCellUser_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="PAPMI_Employer">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>25</Piece>
</Data>
<Data name="PAPMI_EmployerAddress">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>26</Piece>
</Data>
<Data name="PAPMI_EmployerEmail">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>27</Piece>
</Data>
<Data name="PAPMI_EmployerPhone">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>28</Piece>
</Data>
<Data name="PAPMI_ForeignMobile">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>20</Piece>
</Data>
<Data name="PAPMI_Gravida">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="PAPMI_HandleDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>41</Piece>
</Data>
<Data name="PAPMI_HandleState">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>40</Piece>
</Data>
<Data name="PAPMI_HandleTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>42</Piece>
</Data>
<Data name="PAPMI_InsurAdmCategory">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>9</Piece>
</Data>
<Data name="PAPMI_LeaveDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>18</Piece>
</Data>
<Data name="PAPMI_Level_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>37</Piece>
</Data>
<Data name="PAPMI_LocalAddress">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>21</Piece>
</Data>
<Data name="PAPMI_LocalContactName">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>12</Piece>
</Data>
<Data name="PAPMI_LocalContactPhone">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>14</Piece>
</Data>
<Data name="PAPMI_LocalContactRelation_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>13</Piece>
</Data>
<Data name="PAPMI_LocalMobile">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>23</Piece>
</Data>
<Data name="PAPMI_LocalPhone">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>22</Piece>
</Data>
<Data name="PAPMI_Membership">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>29</Piece>
</Data>
<Data name="PAPMI_Para">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="PAPMI_PostTitle">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>35</Piece>
</Data>
<Data name="PAPMI_PostTitleState">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>36</Piece>
</Data>
<Data name="PAPMI_SecondEmail">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>24</Piece>
</Data>
<Data name="PAPMI_SecondMobPhone">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>10</Piece>
</Data>
<Data name="PAPMI_SecondRLT_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>11</Piece>
</Data>
<Data name="PAPMI_SecretLevel_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>30</Piece>
</Data>
<Data name="PAPMI_StreetBirth">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>52</Piece>
</Data>
<Data name="PAPMI_StreetHouse">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>53</Piece>
</Data>
<Data name="PAPMI_StreetNow">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>54</Piece>
</Data>
<Data name="PAPMI_SuperiorUnit">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>33</Piece>
</Data>
<Data name="PAPMI_TouristFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>15</Piece>
</Data>
<Data name="PAPMI_TouristHotelName">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>16</Piece>
</Data>
<Data name="PAPMI_WorkDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>34</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PAPMI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARTNo">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAPMI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ARTNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAPMI_ARTNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPAPatMasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
