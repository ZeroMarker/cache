/// PA_Adm Item Extension for DHCC,Created By guorongyong 2014.01.15
/// Global:^PAADM({PAADM_RowID},"DHC")
Class User.PAAdmExt Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = PAADM_RowId, SqlTableName = PA_AdmExt, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCDisHistory As DHCDischargeHistory [ Cardinality = children, Inverse = DHCDisPAADMEXTParRef ];

Relationship ChildDHCDocOPRegPrint As DHCDocOPRegPrintRecord [ Cardinality = children, Inverse = DHCDocOPRegPrintParRef ];

/// 是否医保
Property PAADMCheckInsued As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 2, SqlFieldName = PAADM_CheckInsued ];

/// 核对人
Property PAADMCheckInsuUserDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = PAADM_CheckInsuUser_DR ];

/// 核对日期
Property PAADMCheckInsurDate As %Date [ SqlColumnNumber = 4, SqlFieldName = PAADM_CheckInsurDate ];

/// 核对时间
Property PAADMCheckInsurTime As %Time [ SqlColumnNumber = 5, SqlFieldName = PAADM_CheckInsurTime ];

/// 转诊标识
Property PAADMTransferFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PAADM_TransferFlag ];

/// 送押单位(仅公安医院使用)
Property PAADMCTEscortUnits As %Library.String [ SqlColumnNumber = 7, SqlFieldName = PAADM_CTEscortUnits ];

/// 送押民警(仅公安医院使用)
Property PAADMEscortPerson As %Library.String [ SqlColumnNumber = 8, SqlFieldName = PAADM_EscortPerson ];

/// 不配药标识
Property PAADMNotDistDrugsFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PAADM_NotDistDrugsFlag ];

/// 预约类型(VB版本用)
Property PAADMBregType As RBCApptType [ SqlColumnNumber = 10, SqlFieldName = PAADM_BregType ];

/// 就诊到达科室
Property PAADMArriveDepDR As User.CTLoc [ SqlColumnNumber = 11, SqlFieldName = PAADM_ArriveDep_DR ];

/// 门诊招回标识
Property PAADMRecallFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PAADM_RecallFlag ];

/// 退号申请
Property PAADMReturnFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = PAADM_ReturnFlag ];

/// 流感样
Property PAADMILIFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = PAADM_ILIFlag ];

/// 抗生素申请加急标识(1 加急,其他 不加急)
Property PAADMAntibApplyEm As %String [ SqlColumnNumber = 15, SqlFieldName = PAADM_AntibApplyEm ];

/// 就诊方式代码(初诊/门诊复诊/出院复诊/急诊复诊/转诊/其他/未知CZ/MZFZ/CYFZ/JZFZ/ZZ/QT/WZ现肿瘤使用,用PAADM_ReadmToRehab_DR字段替代)
Property PAADMAdmWay As %String [ SqlColumnNumber = 16, SqlFieldName = PAADM_AdmWay ];

/// 病历申请
Property PAADMMedApplyFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = PAADM_MedApplyFlag ];

/// 特批标识
Property PAADMAusFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = PAADM_AusFlag ];

/// 特批人
Property PAADMAusUserDR As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = PAADM_AusUser_DR ];

/// 特批日期
Property PAADMAusDate As %Date [ SqlColumnNumber = 20, SqlFieldName = PAADM_AusDate ];

/// 特批时间
Property PAADMAusTime As %Time [ SqlColumnNumber = 21, SqlFieldName = PAADM_AusTime ];

/// 特批备注
Property PAADMAusRemark As %String [ SqlColumnNumber = 22, SqlFieldName = PAADM_AusRemark ];

/// 特殊病人就诊标识(1 特殊病人就诊,其他 非特殊病人就诊友谊干保楼,协和用)
Property PAADMSpecPersonFlag As %String [ SqlColumnNumber = 23, SqlFieldName = PAADM_SpecPersonFlag ];

/// 读医保卡所得的医保病人类型
Property PAADMInsuPersonType As %String [ SqlColumnNumber = 24, SqlFieldName = PAADM_InsuPersonType ];

/// 特病类别关联
Property PAADMDiagnosCatDR As User.DHCDiagnosCat [ SqlColumnNumber = 25, SqlFieldName = PAADM_DiagnosCat_DR ];

/// 挂号优惠设置关联
Property PAADMRegConDisDR As User.DHCRegConDisCount [ SqlColumnNumber = 26, SqlFieldName = PAADM_RegConDis_DR ];

/// 先诊疗后付费标志
Property PAADMFirstTreatFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = PAADM_FirstTreatFlag ];

/// 退号原因
Property PAADMOPReturnReasonDR As User.DHCOPReturnReason [ SqlColumnNumber = 28, SqlFieldName = PAADM_OPReturnReason_DR ];

/// 出院关联医嘱ID
Property PAADMDischgOrderId As OEOrdItem [ SqlColumnNumber = 29, SqlFieldName = PAADM_DischgOrderId ];

/// 出院日期
Property PAADMDischargeDate As %Date [ SqlColumnNumber = 30, SqlFieldName = PAADM_DischargeDate ];

/// 出院时间
Property PAADMDischargeTime As %Time [ SqlColumnNumber = 31, SqlFieldName = PAADM_DischargeTime ];

/// 入院日期
Property PAADMAdminDate As %Date [ SqlColumnNumber = 32, SqlFieldName = PAADM_AdminDate ];

/// 入院时间
Property PAADMAdminTime As %Time [ SqlColumnNumber = 33, SqlFieldName = PAADM_AdminTime ];

/// 入院病区
Property PAADMAdminLoc As User.CTLoc [ SqlColumnNumber = 34, SqlFieldName = PAADM_AdminLoc ];

/// 入院科室
Property PAADMAdminWard As User.PACWard [ SqlColumnNumber = 35, SqlFieldName = PAADM_AdminWard ];

/// 代办人证件号码
Property PAADMAgencyCredNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = PAADM_AgencyCredNo ];

/// 代办人姓名
Property PAADMAgencyName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = PAADM_AgencyName ];

/// 代办人电话
Property PAADMAgencyTel As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = PAADM_AgencyTel ];

/// 退号申请人
Property PAADMReturnApplyUserDR As User.SSUser [ SqlColumnNumber = 39, SqlFieldName = PAADM_ReturnApplyUser_DR ];

/// 退号申请日期
Property PAADMReturnApplyDate As %Library.Date [ SqlColumnNumber = 40, SqlFieldName = PAADM_ReturnApplyDate ];

/// 预约(用于统计)
Property PAADMBookFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = PAADM_BookFlag ];

/// 随访(用于统计)
Property PAADMFollowFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = PAADM_FollowFlag ];

/// 绿色通道类型
Property PAADMGreenType As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = PAADM_GreenType ];

/// 绿色通道类型
Property PAADMGreenFlag As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = PAADM_GreenFlag ];

/// 绿色通道类型
Property PAADMGreenStartDate As %Date [ SqlColumnNumber = 45, SqlFieldName = PAADM_GreenStartDate ];

/// 绿色通道类型
Property PAADMGreenStartTime As %Time [ SqlColumnNumber = 46, SqlFieldName = PAADM_GreenStartTime ];

/// 绿色通道类型
Property PAADMGreenEndDate As %Date [ SqlColumnNumber = 47, SqlFieldName = PAADM_GreenEndDate ];

/// 绿色通道类型
Property PAADMGreenEndTime As %Time [ SqlColumnNumber = 48, SqlFieldName = PAADM_GreenEndTime ];

/// 来源方式
Property PAADMInComeType As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = PAADM_InComeType ];

/// 住院证代码表收治原则（DHCDocIPBDictory）关联
Property PAADMIPBTreatedPrincipleDR As User.DHCDocIPBDictory [ SqlColumnNumber = 50, SqlFieldName = PAADM_IPBTreatedPrinciple_DR ];

/// 此就诊需押金结算标识(Y 为押金结算模式, 其他 未押金结算模式)
Property PAADMDepositBillFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 51, SqlFieldName = PAADM_DepositBillFlag ];

/// 罪犯就诊方式
Property PAADMAdmMethodDR As User.DHCPrisonAdmMethod [ SqlColumnNumber = 52, SqlFieldName = PAADM_AdmMethodDR ];

/// 关联罪犯信息表
Property PAADMPAIDR As User.PAPersonImprison [ SqlColumnNumber = 53, SqlFieldName = PAADM_PAI_DR ];

/// 外院转诊、双向转诊标示
Property PAADMExtHosFlag As %String(DISPLAYLIST = ",RollIn,RollOut,Other", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",RI,RO,O") [ SqlColumnNumber = 54, SqlFieldName = PAADM_ExtHosFlag ];

/// 转诊来源信息
Property PAADMExtHosInfo As %String [ SqlColumnNumber = 55, SqlFieldName = PAADM_ExtHosInfo ];

/// 代办人证件类型
Property PAADMAgencyCredTypeDR As PACCardType [ SqlColumnNumber = 56, SqlFieldName = PAADM_AgencyCredType_DR ];

/// 患者便签
Property PAADMRemarks As list Of %String(COLLATION = "Exact", MAXLEN = 50000, TRUNCATE = 1) [ SqlColumnNumber = 57, SqlFieldName = PAADM_Remarks, SqlListType = SUBNODE ];

/// 预住院患者标志，插入住院证时，如果是预住院患者则为Y
Property PAADMPreInPatient As %String [ SqlColumnNumber = 58, SqlFieldName = PAADM_PreInPatient ];

/// 实际离院日期
Property PAADMRealLeaveDate As %Date [ SqlColumnNumber = 59, SqlFieldName = PAADM_RealLeaveDate ];

/// 实际离院时间
Property PAADMRealLeaveTime As %Time [ SqlColumnNumber = 60, SqlFieldName = PAADM_RealLeaveTime ];

/// 陪护人员姓名
Property PAADMAccompanyName As %String [ SqlColumnNumber = 61, SqlFieldName = PAADM_AccompanyName ];

/// 陪护人员性别
Property PAADMAccompanySex As CTSex [ SqlColumnNumber = 62, SqlFieldName = PAADM_AccompanySex ];

/// 陪护人员出生日期
Property PAADMAccompanyDob As %Date [ SqlColumnNumber = 63, SqlFieldName = PAADM_AccompanyDob ];

/// 陪护人员证件类型
Property PAADMAccompanyCredType As PACCardType [ SqlColumnNumber = 64, SqlFieldName = PAADM_AccompanyCredType ];

/// 陪护人员证件号码
Property PAADMAccompanyCredNo As %String [ SqlColumnNumber = 65, SqlFieldName = PAADM_AccompanyCredNo ];

/// 陪护人员手机号码
Property PAADMAccompanyTelPhone As %String [ SqlColumnNumber = 66, SqlFieldName = PAADM_AccompanyTelPhone ];

/// 外伤字段
Property PAADMTrauma As %String [ SqlColumnNumber = 67, SqlFieldName = PAADM_Trauma ];

/// 推荐医生指针
Property PAADMAdviseDocDr As CTCareProv [ SqlColumnNumber = 68, SqlFieldName = PAADM_AdviseDocDr ];

/// 推荐医生String
Property PAADMAdviseDocName As %String [ SqlColumnNumber = 69, SqlFieldName = PAADM_AdviseDocName ];

/// 挂号时所用的就诊卡类型
Property PAADMRegCardTypeDR As DHCCardTypeDef [ SqlColumnNumber = 70, SqlFieldName = PAADM_RegCardType_DR ];

/// 挂号时所用的就诊卡卡号
Property PAADMRegCardNo As %String [ SqlColumnNumber = 71, SqlFieldName = PAADM_RegCardNo ];

/// 离院方式
Property PAADMDischargeMethodDR As CT.BDP.CT.DischargeMethod [ SqlColumnNumber = 72, SqlFieldName = PAADM_DischargeMethod_DR ];

/// 人脸识别
Property PAADMFacialRecognition As %String [ SqlColumnNumber = 73, SqlFieldName = PAADM_FacialRecognition ];

/// 退号原因
Property PAADMOPReturnReason As %String [ SqlColumnNumber = 74, SqlFieldName = PAADM_OPReturnReason ];

/// 联合门诊主号别关联
Property PAADMUniteMainAdmDR As User.PAAdm [ SqlColumnNumber = 75, SqlFieldName = PAADM_UniteMainAdmDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PAADM_AccompanyCredNo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>63</Piece>
</Data>
<Data name="PAADM_AccompanyCredType">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>62</Piece>
</Data>
<Data name="PAADM_AccompanyDob">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>61</Piece>
</Data>
<Data name="PAADM_AccompanyName">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>59</Piece>
</Data>
<Data name="PAADM_AccompanySex">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>60</Piece>
</Data>
<Data name="PAADM_AccompanyTelPhone">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>64</Piece>
</Data>
<Data name="PAADM_AdmMethodDR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>51</Piece>
</Data>
<Data name="PAADM_AdmWay">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>15</Piece>
</Data>
<Data name="PAADM_AdminDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>31</Piece>
</Data>
<Data name="PAADM_AdminLoc">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>33</Piece>
</Data>
<Data name="PAADM_AdminTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>32</Piece>
</Data>
<Data name="PAADM_AdminWard">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>34</Piece>
</Data>
<Data name="PAADM_AdviseDocDr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>66</Piece>
</Data>
<Data name="PAADM_AdviseDocName">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>67</Piece>
</Data>
<Data name="PAADM_AgencyCredNo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>35</Piece>
</Data>
<Data name="PAADM_AgencyCredType_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>55</Piece>
</Data>
<Data name="PAADM_AgencyName">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>36</Piece>
</Data>
<Data name="PAADM_AgencyTel">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>37</Piece>
</Data>
<Data name="PAADM_AntibApplyEm">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>14</Piece>
</Data>
<Data name="PAADM_ArriveDep_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>10</Piece>
</Data>
<Data name="PAADM_AusDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>19</Piece>
</Data>
<Data name="PAADM_AusFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>17</Piece>
</Data>
<Data name="PAADM_AusRemark">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>21</Piece>
</Data>
<Data name="PAADM_AusTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>20</Piece>
</Data>
<Data name="PAADM_AusUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>18</Piece>
</Data>
<Data name="PAADM_BookFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>40</Piece>
</Data>
<Data name="PAADM_BregType">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>9</Piece>
</Data>
<Data name="PAADM_CTEscortUnits">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="PAADM_CheckInsuUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="PAADM_CheckInsued">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="PAADM_CheckInsurDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="PAADM_CheckInsurTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="PAADM_DepositBillFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>50</Piece>
</Data>
<Data name="PAADM_DiagnosCat_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>24</Piece>
</Data>
<Data name="PAADM_DischargeDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>29</Piece>
</Data>
<Data name="PAADM_DischargeMethod_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>70</Piece>
</Data>
<Data name="PAADM_DischargeTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>30</Piece>
</Data>
<Data name="PAADM_DischgOrderId">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>28</Piece>
</Data>
<Data name="PAADM_EscortPerson">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>7</Piece>
</Data>
<Data name="PAADM_ExtHosFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>53</Piece>
</Data>
<Data name="PAADM_ExtHosInfo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>54</Piece>
</Data>
<Data name="PAADM_FacialRecognition">
<Node>"FacialRecognition"</Node>
</Data>
<Data name="PAADM_FirstTreatFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>26</Piece>
</Data>
<Data name="PAADM_FollowFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>41</Piece>
</Data>
<Data name="PAADM_GreenEndDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>46</Piece>
</Data>
<Data name="PAADM_GreenEndTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>47</Piece>
</Data>
<Data name="PAADM_GreenFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>43</Piece>
</Data>
<Data name="PAADM_GreenStartDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>44</Piece>
</Data>
<Data name="PAADM_GreenStartTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>45</Piece>
</Data>
<Data name="PAADM_GreenType">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>42</Piece>
</Data>
<Data name="PAADM_ILIFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>13</Piece>
</Data>
<Data name="PAADM_IPBTreatedPrinciple_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>49</Piece>
</Data>
<Data name="PAADM_InComeType">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>48</Piece>
</Data>
<Data name="PAADM_InsuPersonType">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>23</Piece>
</Data>
<Data name="PAADM_MedApplyFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>16</Piece>
</Data>
<Data name="PAADM_NotDistDrugsFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>8</Piece>
</Data>
<Data name="PAADM_OPReturnReason">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>71</Piece>
</Data>
<Data name="PAADM_OPReturnReason_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>27</Piece>
</Data>
<Data name="PAADM_PAI_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>52</Piece>
</Data>
<Data name="PAADM_PreInPatient">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>56</Piece>
</Data>
<Data name="PAADM_RealLeaveDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>57</Piece>
</Data>
<Data name="PAADM_RealLeaveTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>58</Piece>
</Data>
<Data name="PAADM_RecallFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>11</Piece>
</Data>
<Data name="PAADM_RegCardNo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>69</Piece>
</Data>
<Data name="PAADM_RegCardType_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>68</Piece>
</Data>
<Data name="PAADM_RegConDis_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>25</Piece>
</Data>
<Data name="PAADM_Remarks">
<Node>"DHCReMark"</Node>
</Data>
<Data name="PAADM_ReturnApplyDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>39</Piece>
</Data>
<Data name="PAADM_ReturnApplyUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>38</Piece>
</Data>
<Data name="PAADM_ReturnFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>12</Piece>
</Data>
<Data name="PAADM_SpecPersonFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>22</Piece>
</Data>
<Data name="PAADM_TransferFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="PAADM_Trauma">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>65</Piece>
</Data>
<Data name="PAADM_UniteMainAdmDR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>72</Piece>
</Data>
<Global>^PAADM</Global>
<PopulationType>full</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAADM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PAADM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdminDate">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAADM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AdminDateExt"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAADM_AdminDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAADM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdminDateTime">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAADM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AdminDateTimeExt"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAADM_AdminDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAADM_AdminTime}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAADM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDischargeDate">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAADM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DischargeDateExt"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAADM_DischargeDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAADM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDischargeDateTime">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAADM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DischargeDateTimeExt"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAADM_DischargeDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAADM_DischargeTime}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAADM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUniteMain">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAADM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UniteMain"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAADM_UniteMainAdmDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAADM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAADM_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmExtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
