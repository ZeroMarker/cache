/// Admission Insurance         (1167)
Class User.PAAdmInsurance Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmInsurance, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INSChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPAAdmInsuranceBGLimits As PAAdmInsuranceBGLimits [ Cardinality = children, Inverse = LIMParRef ];

Relationship ChildPAAdmInsuranceContrOverrid As PAAdmInsuranceContrOverrides [ Cardinality = children, Inverse = COVParRef ];

Relationship ChildPAAdmInsuranceContacts As PAAdmInsuranceContacts [ Cardinality = children, Inverse = CONTACTParRef ];

/// PA_Adm Parent Reference
Relationship INSParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmInsurance, Required, SqlFieldName = INS_ParRef ];

/// Childsub
Property INSChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"INS",0))}, SqlColumnNumber = 2, SqlFieldName = INS_Childsub ];

/// Des Ref to InsType
Property INSInsTypeDR As ARCInsuranceType [ Required, SqlColumnNumber = 3, SqlFieldName = INS_InsType_DR ];

/// Des Ref to InsAssoc
Property INSInsAssocDR As ARCInsurAssociation [ SqlColumnNumber = 4, SqlFieldName = INS_InsAssoc_DR ];

/// Date Valid From
Property INSDateValidFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = INS_DateValidFrom ];

/// Date Valid To
Property INSDateValidTo As %Date [ SqlColumnNumber = 6, SqlFieldName = INS_DateValidTo ];

/// Date First Have Insur
Property INSDateFirstHaveInsur As %Date [ SqlColumnNumber = 7, SqlFieldName = INS_DateFirstHaveInsur ];

/// Insurance Card No
Property INSCardNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = INS_CardNo ];

/// Cardholder Name
Property INSCardholderName As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = INS_CardholderName ];

/// Cardholder Id
Property INSCardholderId As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = INS_CardholderId ];

/// Des Ref to CTREL
Property INSCTRELDR As CTRelation [ SqlColumnNumber = 11, SqlFieldName = INS_CTREL_DR ];

/// Des Ref to AuxInsType
Property INSAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 12, SqlFieldName = INS_AuxInsType_DR ];

/// Contact to Insur.Co
Property INSContactInsurCo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = INS_ContactInsurCo ];

/// Approved Guarant Date
Property INSApprovedGuarDate As %Date [ SqlColumnNumber = 14, SqlFieldName = INS_ApprovedGuarDate ];

/// Accident Date
Property INSAccidentDate As %Date [ SqlColumnNumber = 15, SqlFieldName = INS_AccidentDate ];

/// Car Rego No
Property INSCarRegoNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = INS_CarRegoNo ];

/// Case Claim No
Property INSCaseClaimNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = INS_CaseClaimNo ];

/// Notification Date
Property INSNotificationDate As %Date [ SqlColumnNumber = 18, SqlFieldName = INS_NotificationDate ];

/// Estim InPat Start Date
Property INSEstimIPStartDate As %Date [ SqlColumnNumber = 19, SqlFieldName = INS_EstimIPStartDate ];

/// Estim InPat End Date
Property INSEstimIPEndDate As %Date [ SqlColumnNumber = 20, SqlFieldName = INS_EstimIPEndDate ];

/// Estim OutPat Start Date
Property INSEstimOPStartDate As %Date [ SqlColumnNumber = 21, SqlFieldName = INS_EstimOPStartDate ];

/// Estim OutPat End Date
Property INSEstimOPEndDate As %Date [ SqlColumnNumber = 22, SqlFieldName = INS_EstimOPEndDate ];

/// Date Type From
Property INSDateTypeFrom As %Date [ SqlColumnNumber = 23, SqlFieldName = INS_DateTypeFrom ];

/// Date Type To
Property INSDateTypeTo As %Date [ SqlColumnNumber = 24, SqlFieldName = INS_DateTypeTo ];

/// Main Insurance Flag
Property INSMainInsuranceFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = INS_MainInsuranceFlag ];

/// Cardholder Address
Property INSCardholderAddress As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = INS_CardholderAddress ];

/// Des Ref City
Property INSCardholderCityDR As CTCity [ SqlColumnNumber = 27, SqlFieldName = INS_CardholderCity_DR ];

/// Des Ref Zip
Property INSCardholderZipDR As CTZip [ SqlColumnNumber = 28, SqlFieldName = INS_CardholderZip_DR ];

/// Rank
Property INSRank As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = INS_Rank ];

/// Authorization Code
Property INSAuthorizationCode As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = INS_AuthorizationCode ];

/// Daily Cover
Property INSDailyCover As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = INS_DailyCover ];

/// Total Charge Cover
Property INSTotalChargeCover As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = INS_TotalChargeCover ];

/// Stamp Duty Percentage
Property INSStampDutyPercentage As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = INS_StampDutyPercentage ];

/// Excess
Property INSExcess As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = INS_Excess ];

/// Daily ICU Cover
Property INSDailyICUCover As %Float [ SqlColumnNumber = 35, SqlFieldName = INS_DailyICUCover ];

/// Payor Share
Property INSPayorShare As %Float [ SqlColumnNumber = 36, SqlFieldName = INS_PayorShare ];

/// PayFrom
Property INSPayFrom As %Float [ SqlColumnNumber = 37, SqlFieldName = INS_PayFrom ];

/// PayUntill
Property INSPayUntill As %Float [ SqlColumnNumber = 38, SqlFieldName = INS_PayUntill ];

/// Fixed Pat Share
Property INSFixedPatShare As %Float [ SqlColumnNumber = 39, SqlFieldName = INS_FixedPatShare ];

/// Des Ref CardType
Property INSCardTypeDR As PACCardType [ SqlColumnNumber = 40, SqlFieldName = INS_CardType_DR ];

/// Concession Card No
Property INSConcessionCardNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = INS_ConcessionCardNo ];

/// Concession Card Exp Date
Property INSConcessionCardExpDate As %Date [ SqlColumnNumber = 42, SqlFieldName = INS_ConcessionCardExpDate ];

/// Safety Net Card No
Property INSSafetyNetCardNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = INS_SafetyNetCardNo ];

/// Safety Net Card Exp Date
Property INSSafetyNetCardExpDate As %Date [ SqlColumnNumber = 44, SqlFieldName = INS_SafetyNetCardExpDate ];

/// Des Ref PayorContactType
Property INSPayorContactTypeDR As ARCPayorContactType [ SqlColumnNumber = 45, SqlFieldName = INS_PayorContactType_DR ];

/// DVA number
Property INSDVAnumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 46, SqlFieldName = INS_DVAnumber ];

/// DailyCopaymentAmt
Property INSDailyCopaymentAmt As %Float [ SqlColumnNumber = 47, SqlFieldName = INS_DailyCopaymentAmt ];

/// MaxCopaymentAmt
Property INSMaxCopaymentAmt As %Float [ SqlColumnNumber = 48, SqlFieldName = INS_MaxCopaymentAmt ];

/// Apply GST
Property INSApplyGST As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = INS_ApplyGST ];

/// Shared Room Copayment Amt
Property INSSharedRoomCopaymentAmt As %Float [ SqlColumnNumber = 50, SqlFieldName = INS_SharedRoomCopaymentAmt ];

/// Time From
Property INSTimeFrom As %Time [ SqlColumnNumber = 51, SqlFieldName = INS_TimeFrom ];

/// TimeTo
Property INSTimeTo As %Time [ SqlColumnNumber = 52, SqlFieldName = INS_TimeTo ];

/// UpdateDate
Property INSUpdateDate As %Date [ SqlColumnNumber = 53, SqlFieldName = INS_UpdateDate ];

/// UpdateTime
Property INSUpdateTime As %Time [ SqlColumnNumber = 54, SqlFieldName = INS_UpdateTime ];

/// Des REf UpdateUser
Property INSUpdateUserDR As SSUser [ SqlColumnNumber = 55, SqlFieldName = INS_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property INSUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 56, SqlFieldName = INS_UpdateUserHospital_DR ];

/// Payor Variation Comments
Property INSPayorVariationComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 57, SqlFieldName = INS_PayorVariationComments, SqlListType = subnode ];

/// CardInitDate
Property INSCardInitDate As %Date [ SqlColumnNumber = 58, SqlFieldName = INS_CardInitDate ];

/// UseOwnTariff
Property INSUseOwnTariff As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 59, SqlFieldName = INS_UseOwnTariff ];

/// SurmountingPercentage
Property INSSurmountingPercentage As %Float [ SqlColumnNumber = 60, SqlFieldName = INS_SurmountingPercentage ];

/// SurmountingLimit
Property INSSurmountingLimit As %Float [ SqlColumnNumber = 61, SqlFieldName = INS_SurmountingLimit ];

/// SurmountingAmount
Property INSSurmountingAmount As %Float [ SqlColumnNumber = 62, SqlFieldName = INS_SurmountingAmount ];

/// CoPaymentPercentage
Property INSCoPaymentPercentage As %Float [ SqlColumnNumber = 63, SqlFieldName = INS_CoPaymentPercentage ];

/// MaxAmountPercentage
Property INSMaxAmountPercentage As %Float [ SqlColumnNumber = 64, SqlFieldName = INS_MaxAmountPercentage ];

/// Min Surmount Amt
Property INSMinSurmountAmt As %Float [ SqlColumnNumber = 65, SqlFieldName = INS_MinSurmountAmt ];

/// OfficeNo
Property INSOfficeNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 66, SqlFieldName = INS_OfficeNo ];

/// RoyalOrderNo
Property INSRoyalOrderNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 67, SqlFieldName = INS_RoyalOrderNo ];

/// Des Ref RoyalOrder
Property INSRoyalOrderDR As PAPersonRoyalOrder [ SqlColumnNumber = 68, SqlFieldName = INS_RoyalOrder_DR ];

/// AccomRate
Property INSAccomRate As %Float [ SqlColumnNumber = 69, SqlFieldName = INS_AccomRate ];

/// VCFeeRate
Property INSVCFeeRate As %Float [ SqlColumnNumber = 70, SqlFieldName = INS_VCFeeRate ];

/// MaxDailyAmount
Property INSMaxDailyAmount As %Float [ SqlColumnNumber = 71, SqlFieldName = INS_MaxDailyAmount ];

/// Apply Share of TotalAmount
Property INSApplyShareTotalAmount As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 72, SqlFieldName = INS_ApplyShareTotalAmount ];

/// Des Ref CopiedIns
Property INSCopiedInsDR As PAAdmInsurance [ SqlColumnNumber = 73, SqlFieldName = INS_CopiedIns_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAAdmInsurance).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsurance","OnAfterInsert")
 d Table^HL7Outbound("PAAdmInsurance",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAAdmInsurance).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsurance","OnAfterUpdate")
 d Table^HL7Outbound("PAAdmInsurance",%d(1),"Update")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAAdmInsurance).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsurance","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAAdmInsurance).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsurance","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsurance","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAAdmInsurance).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsurance","OnAfterDelete")
 d Table^HL7Outbound("PAAdmInsurance",%old(1),"Delete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INS_AccidentDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INS_AccomRate">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="INS_ApplyGST">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="INS_ApplyShareTotalAmount">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="INS_ApprovedGuarDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INS_AuthorizationCode">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INS_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INS_CTREL_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INS_CarRegoNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INS_CardInitDate">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="INS_CardNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INS_CardType_DR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INS_CardholderAddress">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INS_CardholderCity_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INS_CardholderId">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INS_CardholderName">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INS_CardholderZip_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INS_CaseClaimNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INS_CoPaymentPercentage">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="INS_ConcessionCardExpDate">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INS_ConcessionCardNo">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INS_ContactInsurCo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INS_CopiedIns_DR">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="INS_DVAnumber">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="INS_DailyCopaymentAmt">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="INS_DailyCover">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INS_DailyICUCover">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INS_DateFirstHaveInsur">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INS_DateTypeFrom">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INS_DateTypeTo">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INS_DateValidFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INS_DateValidTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INS_EstimIPEndDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INS_EstimIPStartDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INS_EstimOPEndDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INS_EstimOPStartDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INS_Excess">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INS_FixedPatShare">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INS_InsAssoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INS_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INS_MainInsuranceFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INS_MaxAmountPercentage">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="INS_MaxCopaymentAmt">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="INS_MaxDailyAmount">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="INS_MinSurmountAmt">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="INS_NotificationDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INS_OfficeNo">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="INS_PayFrom">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INS_PayUntill">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INS_PayorContactType_DR">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="INS_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INS_PayorVariationComments">
<Node>"VAR"</Node>
</Data>
<Data name="INS_Rank">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INS_RoyalOrderNo">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="INS_RoyalOrder_DR">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="INS_SafetyNetCardExpDate">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="INS_SafetyNetCardNo">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INS_SharedRoomCopaymentAmt">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="INS_StampDutyPercentage">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INS_SurmountingAmount">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="INS_SurmountingLimit">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="INS_SurmountingPercentage">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="INS_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="INS_TimeTo">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="INS_TotalChargeCover">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="INS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="INS_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="INS_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="INS_UseOwnTariff">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="INS_VCFeeRate">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INS_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmInsuranceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
