Class User.DHCAuditLogINCI Extends (%Persistent, User.Abstract) [ SqlRowIdName = MALG_INCI_RowId, SqlTableName = DHC_AuditLog_INCI, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MALGINCIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship MALGINCIParref As User.DHCAuditLog [ Cardinality = parent, Inverse = ChildDHCAuditLogINCI, Required, SqlFieldName = MALG_INCI_Parref ];

Property MALGINCIChildSub As %Library.Float [ Required, SqlColumnNumber = 2, SqlFieldName = MALG_INCI_ChildSub ];

Property MALGChangeType As User.DHCItmChargeType [ SqlColumnNumber = 3, SqlFieldName = MALG_ChangeType ];

Property MALGINCIDr As User.INCItm [ Required, SqlColumnNumber = 4, SqlFieldName = MALG_INCI_Dr ];

Property MALGINCICode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 5, SqlFieldName = MALG_INCI_Code ];

Property MALGINCIDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = MALG_INCI_Desc ];

Property MALGINCIINCSCdr As User.INCStkCat [ SqlColumnNumber = 7, SqlFieldName = MALG_INCI_INCSCdr ];

Property MALGINCINotUseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 8, SqlFieldName = MALG_INCI_NotUseFlag ];

Property MALGINCIBuomDr As User.CTUOM [ SqlColumnNumber = 9, SqlFieldName = MALG_INCI_BuomDr ];

Property MALGINCIPuomDr As User.CTUOM [ SqlColumnNumber = 10, SqlFieldName = MALG_INCI_PuomDr ];

Property MALGINCIHighPrice As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = MALG_INCI_HighPrice ];

Property MALGINCIMTDR As User.DHCMarkType [ SqlColumnNumber = 12, SqlFieldName = MALG_INCI_MTDR ];

Property MALGINCIPbVendor As User.APCVendor [ SqlColumnNumber = 13, SqlFieldName = MALG_INCI_PbVendor ];

Property MALGINCIPbManf As User.PHManufacturer [ SqlColumnNumber = 14, SqlFieldName = MALG_INCI_PbManf ];

Property MALGINCISpec As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MALG_INCI_Spec ];

Property MALGINCIModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MALG_INCI_Model ];

Property MALGINCIBrand As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MALG_INCI_Brand ];

Property MALGINCIAbbrev As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = MALG_INCI_Abbrev ];

Property MALGINCIChargeType As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = MALG_INCI_ChargeType ];

Property MALGINCIOrigin As User.DHCSTOrigin [ SqlColumnNumber = 20, SqlFieldName = MALG_INCI_Origin ];

Property MALGINCITransDate As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = MALG_INCI_TransDate ];

Property MALGINCIRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = MALG_INCI_RegNo ];

Property MALGINCIRegDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = MALG_INCI_RegDate ];

Property MALGINCIAuditFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = MALG_INCI_AuditFlag ];

Property MALGINCIChargeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = MALG_INCI_ChargeFlag ];

Property MALGINCISterile As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 26, SqlFieldName = MALG_INCI_Sterile ];

Property MALGINCISterCatDR As INCSterileCategory [ SqlColumnNumber = 27, SqlFieldName = MALG_INCI_SterCatDR ];

Property MALGINCIBarCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = MALG_INCI_BarCode ];

Property MALGINCIReportingDays As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = MALG_INCI_ReportingDays ];

Property MALGINCICTLOCDR As CTLoc [ SqlColumnNumber = 30, SqlFieldName = MALG_INCI_CTLOCDR ];

Property MALGINCIImportFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = MALG_INCI_ImportFlag ];

Property MALGINCIQualityLevel As User.DHCItmQualityLevel [ SqlColumnNumber = 32, SqlFieldName = MALG_INCI_QualityLevel ];

Property MALGINCIComFrom As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = MALG_INCI_ComFrom ];

Property MALGINCIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = MALG_INCI_Remark ];

Property MALGINCIMaxSp As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = MALG_INCI_MaxSp ];

Property MALGINCIInHosFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = MALG_INCI_InHosFlag ];

Property MALGINCIPbRp As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = MALG_INCI_PbRp ];

Property MALGINCIPBLDR As User.DHCPublicBiddingList [ SqlColumnNumber = 38, SqlFieldName = MALG_INCI_PBLDR ];

Property MALGINCIPbCarrierDR As User.DHCCarrier [ SqlColumnNumber = 39, SqlFieldName = MALG_INCI_PbCarrierDR ];

Property MALGINCIBAflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = MALG_INCI_BAflag ];

Property MALGINCIPBLevel As User.DHCItmPBLevel [ SqlColumnNumber = 41, SqlFieldName = MALG_INCI_PBLevel ];

Property MALGINCIEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 42, SqlFieldName = MALG_INCI_EndDate ];

Property MALGINCIExpireLen As %Library.Float [ SqlColumnNumber = 43, SqlFieldName = MALG_INCI_ExpireLen ];

Property MALGINCIPrcFile As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = MALG_INCI_PrcFile ];

Property MALGINCIPrcFileD As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 45, SqlFieldName = MALG_INCI_PrcFileD ];

Property MALGINCIBCDr As User.DHCSTBookCat [ SqlColumnNumber = 46, SqlFieldName = MALG_INCI_BCDr ];

Property MALGINCIStandardCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = MALG_INCI_StandardCode ];

Property MALGINCINotUseReasonDr As User.DHCItmNotUseReason [ SqlColumnNumber = 48, SqlFieldName = MALG_INCI_NotUseReasonDr ];

Property MALGINCIInsuCatDR As User.DHCItmInsuCategory [ SqlColumnNumber = 49, SqlFieldName = MALG_INCI_InsuCatDR ];

Property MALGINCIHighRiskFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 50, SqlFieldName = MALG_INCI_HighRiskFlag ];

Property MALGINCIPackUom As User.CTUOM [ SqlColumnNumber = 51, SqlFieldName = MALG_INCI_PackUom ];

Property MALGINCIPackUomFactor As %Library.Float [ SqlColumnNumber = 52, SqlFieldName = MALG_INCI_PackUomFactor ];

Property MALGINCIPackPicPath As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = MALG_INCI_PackPicPath ];

Property MALGINCIMaxPurAmt As %Library.Float [ SqlColumnNumber = 54, SqlFieldName = MALG_INCI_MaxPurAmt ];

Property MALGINCIDistribFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 55, SqlFieldName = MALG_INCI_DistribFlag ];

Property MALGINCISupervision As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = MALG_INCI_Supervision ];

Property MALGINCIImplantationMat As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = MALG_INCI_ImplantationMat ];

Property MALGINCIPbno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 58, SqlFieldName = MALG_INCI_Pbno ];

Property MALGINCIChangeRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = MALG_INCI_ChangeRate ];

Property MALGINCIMatQuality As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 60, SqlFieldName = MALG_INCI_MatQuality ];

///  限制请求方式 ( "O" - 临时请求 "C" - 请领计划 )
Property MALGINCIReqModeLimited As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 61, SqlFieldName = MALG_INCI_ReqModeLimited ];

Property MALGINCINoLocReq As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 62, SqlFieldName = MALG_INCI_NoLocReq ];

/// 特殊标志
Property MALGINCISpeFlag As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 63, SqlFieldName = MALG_INCI_SpeFlag ];

/// 灭菌时间长度
Property MALGINCISterileDateLen As %Library.Float [ SqlColumnNumber = 64, SqlFieldName = MALG_INCI_SterileDateLen ];

/// 医疗器械分类(68)
Property MALGINCIMedEqptCatDR As User.DHCMedEqptCat [ SqlColumnNumber = 65, SqlFieldName = MALG_INCI_MedEqptCatDR ];

/// 零库存标志
Property MALGINCIZeroStk As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 66, SqlFieldName = MALG_INCI_ZeroStk ];

/// 具体规格是否可以录入标志 
Property MALGINCISpecFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 67, SqlFieldName = MALG_INCI_SpecFlag ];

/// 招标日期
Property MALGINCIBidDate As %Library.Date [ SqlColumnNumber = 68, SqlFieldName = MALG_INCI_BidDate ];

/// 首请部门
Property MALGINCIFirstReqDept As User.CTLoc [ SqlColumnNumber = 69, SqlFieldName = MALG_INCI_FirstReqDept ];

/// 是否医保支付
Property MALGINCIInsuPay As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 70, SqlFieldName = MALG_INCI_InsuPay ];

/// 医保支付价格
Property MALGINCIInsuPrice As %Library.Float [ SqlColumnNumber = 71, SqlFieldName = MALG_INCI_InsuPrice ];

/// 官方分类
Property MALGINCIMatCatOfficialDR As User.DHCMatCatOfficial [ SqlColumnNumber = 72, SqlFieldName = MALG_INCI_MatCatOfficialDR ];

/// 临床分类
Property MALGINCIMatCatClinicalDR As User.DHCMatCatClinical [ SqlColumnNumber = 73, SqlFieldName = MALG_INCI_MatCatClinicalDR ];

/// 特殊分类
Property MALGINCIMatCatSpecialDR As User.DHCMatCatSpecial [ SqlColumnNumber = 74, SqlFieldName = MALG_INCI_MatCatSpecialDR ];

Storage SQLStorage
{
<SQLMap name="IndexInciAudit">
<Global>^DHCMALG</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_AuditLog.MALG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>MALG_INCI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCIAUDIT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MALG_INCI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MALG_INCI_AuditFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_AuditLog.MALG_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MALG_INCI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MALG_ChangeType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MALG_INCI_Abbrev">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MALG_INCI_AuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MALG_INCI_BAflag">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="MALG_INCI_BCDr">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="MALG_INCI_BarCode">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MALG_INCI_BidDate">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="MALG_INCI_Brand">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MALG_INCI_BuomDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MALG_INCI_CTLOCDR">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="MALG_INCI_ChangeRate">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MALG_INCI_ChargeFlag">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="MALG_INCI_ChargeType">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MALG_INCI_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MALG_INCI_ComFrom">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MALG_INCI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MALG_INCI_DistribFlag">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="MALG_INCI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MALG_INCI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="MALG_INCI_ExpireLen">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="MALG_INCI_FirstReqDept">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="MALG_INCI_HighPrice">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MALG_INCI_HighRiskFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MALG_INCI_INCSCdr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MALG_INCI_ImplantationMat">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MALG_INCI_ImportFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MALG_INCI_InHosFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MALG_INCI_InsuCatDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MALG_INCI_InsuPay">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MALG_INCI_InsuPrice">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MALG_INCI_MTDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MALG_INCI_MatCatClinicalDR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MALG_INCI_MatCatOfficialDR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MALG_INCI_MatCatSpecialDR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MALG_INCI_MatQuality">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MALG_INCI_MaxPurAmt">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MALG_INCI_MaxSp">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MALG_INCI_MedEqptCatDR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MALG_INCI_Model">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MALG_INCI_NoLocReq">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="MALG_INCI_NotUseFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MALG_INCI_NotUseReasonDr">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="MALG_INCI_Origin">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MALG_INCI_PBLDR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="MALG_INCI_PBLevel">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="MALG_INCI_PackPicPath">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="MALG_INCI_PackUom">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="MALG_INCI_PackUomFactor">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="MALG_INCI_PbCarrierDR">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="MALG_INCI_PbManf">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MALG_INCI_PbRp">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="MALG_INCI_PbVendor">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MALG_INCI_Pbno">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="MALG_INCI_PrcFile">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="MALG_INCI_PrcFileD">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="MALG_INCI_PuomDr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MALG_INCI_QualityLevel">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="MALG_INCI_RegDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MALG_INCI_RegNo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MALG_INCI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="MALG_INCI_ReportingDays">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="MALG_INCI_ReqModeLimited">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="MALG_INCI_SpeFlag">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="MALG_INCI_Spec">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MALG_INCI_SpecFlag">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="MALG_INCI_StandardCode">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="MALG_INCI_SterCatDR">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="MALG_INCI_Sterile">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="MALG_INCI_SterileDateLen">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="MALG_INCI_Supervision">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="MALG_INCI_TransDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MALG_INCI_ZeroStk">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Global>^DHCMALG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AuditLog.MALG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MALG_INCI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_AuditLog.MALG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{MALG_INCI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MALG_INCI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCAuditLogINCIS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
