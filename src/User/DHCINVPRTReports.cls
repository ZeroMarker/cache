Class User.DHCINVPRTReports Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = HIS_Rowid, SqlTableName = DHC_INVPRTReports, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCINVPRTReportsPaymode As User.DHCINVPRTReportsPaymode [ Cardinality = children, Inverse = HisPayParRef ];

Relationship ChildDHCINVPRTReportsSub As User.DHCINVPRTReportsSub [ Cardinality = children, Inverse = HisSubParRef ];

Relationship ChildDHCINVPRTReportsInsType As User.DHCINVPRTReportsInsType [ Cardinality = children, Inverse = ITCRepParRef ];

Relationship ChildDHCINVPRTReportsBalanceSub As User.DHCINVPRTReportsBalanceSub [ Cardinality = children, Inverse = HBSParRef ];

Relationship ChildDHCINVPRTReportsINSUType As User.DHCINVPRTReportsINSUType [ Cardinality = children, Inverse = HisInsuParRef ];

/// HIS_Date
Property HISDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = HIS_Date ];

/// HIS_Time
Property HISTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = HIS_Time ];

/// HIS_StartDate
Property HISStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = HIS_StartDate ];

/// HIS_StartTime
Property HISStartTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = HIS_StartTime ];

/// HIS_EndDate
Property HISEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = HIS_EndDate ];

/// HIS_EndTime
Property HISEndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = HIS_EndTime ];

/// HIS_Amount
Property HISAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = HIS_Amount ];

/// HIS_User
Property HISUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = HIS_User ];

/// HIS_Num
Property HISNum As %Library.Integer [ SqlColumnNumber = 10, SqlFieldName = HIS_Num ];

/// HIS_RcptNO
Property HISRcptNO As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = HIS_RcptNO ];

/// HIS_Confirm
Property HISConfirm As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = HIS_Confirm ];

/// HIS_Collect
Property HISCollect As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = HIS_Collect ];

/// HIS_INSFootDate
Property HISINSFootDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = HIS_INSFootDate ];

/// HIS_INSFootTime
Property HISINSFootTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = HIS_INSFootTime ];

/// HIS_INSFootUser
Property HISINSFootUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = HIS_INSFootUser ];

/// HIS_PatSum
Property HISPatSum As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = HIS_PatSum ];

/// HIS_CashNum
Property HISCashNum As %Library.Integer [ SqlColumnNumber = 18, SqlFieldName = HIS_CashNum ];

/// HIS_CashSum
Property HISCashSum As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = HIS_CashSum ];

/// HIS_CheckNum
Property HISCheckNum As %Library.Integer [ SqlColumnNumber = 20, SqlFieldName = HIS_CheckNum ];

/// HIS_CheckSum
Property HISCheckSum As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = HIS_CheckSum ];

/// HIS_RefundNum
Property HISRefundNum As %Library.Integer [ SqlColumnNumber = 22, SqlFieldName = HIS_RefundNum ];

/// HIS_RefundSum
Property HISRefundSum As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = HIS_RefundSum ];

/// HIS_ParkNum
Property HISParkNum As %Library.Integer [ SqlColumnNumber = 24, SqlFieldName = HIS_ParkNum ];

/// HIS_ParkSum
Property HISParkSum As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = HIS_ParkSum ];

/// HIS_ParkINVInfo
Property HISParkINVInfo As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = HIS_ParkINVInfo ];

/// HIS_RefundINVInfo
Property HISRefundINVInfo As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = HIS_RefundINVInfo ];

/// HIS_OterPayNum
Property HISOterPayNum As %Library.Integer [ SqlColumnNumber = 28, SqlFieldName = HIS_OterPayNum ];

/// HIS_OterPaySum
Property HISOterPaySum As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = HIS_OterPaySum ];

/// HIS_INVRoundSum
Property HISINVRoundSum As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = HIS_INVRoundSum ];

///  HIS_YBSum  for DHC_INVPRT table
Property HISYBSum As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = HIS_YBSum ];

/// HIS_CardNum
Property HISCardNum As %Library.Integer [ SqlColumnNumber = 32, SqlFieldName = HIS_CardNum ];

/// HIS_CardSum
Property HISCardSum As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = HIS_CardSum ];

/// HIS_CardYBSum
Property HISCardYBSum As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = HIS_CardYBSum ];

/// HIS_CardRefNum
Property HISCardRefNum As %Library.Integer [ SqlColumnNumber = 35, SqlFieldName = HIS_CardRefNum ];

/// HIS_CardRefSum
Property HISCardRefSum As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = HIS_CardRefSum ];

/// HIS_CardYBRefSum
Property HISCardYBRefSum As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = HIS_CardYBRefSum ];

/// HIS_CardCashRefSum
Property HISCardCashRefSum As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = HIS_CardCashRefSum ];

/// HIS_CardParkNum
Property HISCardParkNum As %Library.Integer [ SqlColumnNumber = 39, SqlFieldName = HIS_CardParkNum ];

/// HIS_CardParkSum
Property HISCardParkSum As %Library.Float [ SqlColumnNumber = 40, SqlFieldName = HIS_CardParkSum ];

/// HIS_CardYBParkSum
Property HISCardYBParkSum As %Library.Float [ SqlColumnNumber = 41, SqlFieldName = HIS_CardYBParkSum ];

/// HIS_CardCashParkSum
Property HISCardCashParkSum As %Library.Float [ SqlColumnNumber = 42, SqlFieldName = HIS_CardCashParkSum ];

/// HIS_CardParkINVInfo
Property HISCardParkINVInfo As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = HIS_CardParkINVInfo ];

/// HIS_CardRefundINVInfo
Property HISCardRefundINVInfo As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = HIS_CardRefundINVInfo ];

/// HIS_CPPNum
Property HISCPPNum As %Library.Integer [ SqlColumnNumber = 45, SqlFieldName = HIS_CPPNum ];

/// HIS_CPPSum
Property HISCPPSum As %Library.Float [ SqlColumnNumber = 46, SqlFieldName = HIS_CPPSum ];

/// HIS_GetTotal
Property HISGetTotal As %Library.Float [ SqlColumnNumber = 47, SqlFieldName = HIS_GetTotal ];

/// HIS_GiveTotal
Property HISGiveTotal As %Library.Float [ SqlColumnNumber = 48, SqlFieldName = HIS_GiveTotal ];

/// HIS_CashTotal
Property HISCashTotal As %Library.Float [ SqlColumnNumber = 49, SqlFieldName = HIS_CashTotal ];

/// HIS_CheckTotal
Property HISCheckTotal As %Library.Float [ SqlColumnNumber = 50, SqlFieldName = HIS_CheckTotal ];

/// HIS_OtherTotal
Property HISOtherTotal As %Library.Float [ SqlColumnNumber = 51, SqlFieldName = HIS_OtherTotal ];

/// HIS_PRDGetNum
Property HISPRDGetNum As %Library.Integer [ SqlColumnNumber = 52, SqlFieldName = HIS_PRDGetNum ];

/// HIS_PRDGetSum
Property HISPRDGetSum As %Library.Float [ SqlColumnNumber = 53, SqlFieldName = HIS_PRDGetSum ];

/// HIS_PRDParkNum
Property HISPRDParkNum As %Library.Integer [ SqlColumnNumber = 54, SqlFieldName = HIS_PRDParkNum ];

/// HIS_PRDParkSum
Property HISPRDParkSum As %Library.Float [ SqlColumnNumber = 55, SqlFieldName = HIS_PRDParkSum ];

/// HIS_PRDCashSum
Property HISPRDCashSum As %Library.Float [ SqlColumnNumber = 56, SqlFieldName = HIS_PRDCashSum ];

/// HIS_PRDCheckSum
Property HISPRDCheckSum As %Library.Float [ SqlColumnNumber = 57, SqlFieldName = HIS_PRDCheckSum ];

/// HIS_PRDOtherPaySum
Property HISPRDOtherPaySum As %Library.Float [ SqlColumnNumber = 58, SqlFieldName = HIS_PRDOtherPaySum ];

/// DHC_AccPFoot
Property HISAccPFootDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 59, SqlFieldName = HIS_AccPFoot_DR ];

/// HIS_AccPaySum
Property HISAccPaySum As %Library.Float [ SqlColumnNumber = 60, SqlFieldName = HIS_AccPaySum ];

/// HIS_ReportType OP, Regi, Registrator
Property HISReportType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 61, SqlFieldName = HIS_ReportType ];

/// HIS_ReportStatus 报表状态
Property HISReportStatus As %Library.String(DISPLAYLIST = ",Normal,Cancel", MAXLEN = 30, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",N,C") [ SqlColumnNumber = 62, SqlFieldName = HIS_ReportStatus ];

/// HIS_NormalSum  操作员收款钱数与红冲作废等平 不运算
Property HISNormalSum As %Library.Float [ SqlColumnNumber = 63, SqlFieldName = HIS_NormalSum ];

/// HIS_INVTotalSum
Property HISINVTotalSum As %Library.Float [ SqlColumnNumber = 64, SqlFieldName = HIS_INVTotalSum ];

/// HIS_IncomeDate 收入日期
Property HISIncomeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 65, SqlFieldName = HIS_IncomeDate ];

/// HIS_OPReceive_DR
Property HISOPReceiveDR As User.DHCOPBillReceive [ SqlColumnNumber = 66, SqlFieldName = HIS_OPReceive_DR ];

/// HIS_Hospital_DR
Property HISHospitalDR As User.CTHospital [ SqlColumnNumber = 67, SqlFieldName = HIS_Hospital_DR ];

/// HIS_ReportNote 报表备注
Property HISReportNote As %String(TRUNCATE = 1) [ SqlColumnNumber = 68, SqlFieldName = HIS_ReportNote ];

/// HIS_PreHandinFlag 预结算标识 
Property HISPreHandinFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 69, SqlFieldName = HIS_PreHandinFlag ];

/// HIS_ReceiveFlag
Property HISReceiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 70, SqlFieldName = HIS_ReceiveFlag ];

/// HIS_PEParkINV
Property HISPEParkINV As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 71, SqlFieldName = HIS_PEParkINV ];

/// HIS_PERefundINV
Property HISPERefundINV As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = HIS_PERefundINV ];

/// HIS_PEINVRoundSum
Property HISPEINVRoundSum As %Library.Float [ SqlColumnNumber = 73, SqlFieldName = HIS_PEINVRoundSum ];

/// HIS_VoidINVInfo
Property HISVoidINVInfo As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 74, SqlFieldName = HIS_VoidINVInfo ];

/// HIS_PEINVRoundIntSum 体检凑整金额
Property HISPEINVRoundIntSum As %Library.Float [ SqlColumnNumber = 75, SqlFieldName = HIS_PEINVRoundIntSum ];

/// HIS_VerifyDate 核销日期 Add XiaoShuai 2022-07-05
Property HISVerifyDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 76, SqlFieldName = HIS_VerifyDate ];

/// HIS_VerifyTime 核销时间 Add XiaoShuai 2022-07-05
Property HISVerifyTime As %Library.Time [ SqlColumnNumber = 77, SqlFieldName = HIS_VerifyTime ];

/// HIS_VerifyUser 核销人 Add XiaoShuai 2022-07-05
Property HISVerifyUser As User.SSUser [ SqlColumnNumber = 78, SqlFieldName = HIS_VerifyUser ];

/// HIS_VerifyStatus 核销状态 Add XiaoShuai 2022-07-05
Property HISVerifyStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 79, SqlFieldName = HIS_VerifyStatus ];

Index HISHospitalDRIndex On HISHospitalDR;

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOPInsFoot)</SqlIdExpression>
<SQLMap name="DHCOPInsFoot">
<Data name="HIS_AccPFoot_DR">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="HIS_AccPaySum">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="HIS_Amount">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HIS_CPPNum">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="HIS_CPPSum">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="HIS_CardCashParkSum">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="HIS_CardCashRefSum">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="HIS_CardNum">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="HIS_CardParkINVInfo">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="HIS_CardParkNum">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="HIS_CardParkSum">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="HIS_CardRefNum">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="HIS_CardRefSum">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="HIS_CardRefundINVInfo">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="HIS_CardSum">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="HIS_CardYBParkSum">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="HIS_CardYBRefSum">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="HIS_CardYBSum">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="HIS_CashNum">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="HIS_CashSum">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="HIS_CashTotal">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="HIS_CheckNum">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="HIS_CheckSum">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="HIS_CheckTotal">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="HIS_Collect">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="HIS_Confirm">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HIS_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HIS_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HIS_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HIS_GetTotal">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="HIS_GiveTotal">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="HIS_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="HIS_INSFootDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="HIS_INSFootTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="HIS_INSFootUser">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="HIS_INVRoundSum">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="HIS_INVTotalSum">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="HIS_IncomeDate">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="HIS_NormalSum">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="HIS_Num">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HIS_OPReceive_DR">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="HIS_OterPayNum">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="HIS_OterPaySum">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="HIS_OtherTotal">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="HIS_PEINVRoundIntSum">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="HIS_PEINVRoundSum">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="HIS_PEParkINV">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="HIS_PERefundINV">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="HIS_PRDCashSum">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="HIS_PRDCheckSum">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="HIS_PRDGetNum">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="HIS_PRDGetSum">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="HIS_PRDOtherPaySum">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="HIS_PRDParkNum">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="HIS_PRDParkSum">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="HIS_ParkINVInfo">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="HIS_ParkNum">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="HIS_ParkSum">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="HIS_PatSum">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="HIS_PreHandinFlag">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="HIS_RcptNO">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HIS_ReceiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="HIS_RefundINVInfo">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="HIS_RefundNum">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="HIS_RefundSum">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="HIS_ReportNote">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="HIS_ReportStatus">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="HIS_ReportType">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="HIS_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HIS_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HIS_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HIS_User">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HIS_VerifyDate">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="HIS_VerifyStatus">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="HIS_VerifyTime">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="HIS_VerifyUser">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="HIS_VoidINVInfo">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="HIS_YBSum">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Global>^DHCOPInsFoot</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>HIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{HIS_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINSFootDate">
<Global>^DHCOPInsFootI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INSFDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{HIS_INSFootDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{HIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIncomeDate">
<Global>^DHCOPInsFootI</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IncomeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HIS_IncomeDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReceiveDR">
<Global>^DHCOPInsFootI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HIS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RECEIVEDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HIS_OPReceive_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReceiveFlag">
<Global>^DHCOPInsFootI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HIS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RECEIVEFLAG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HIS_ReceiveFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserFootDate">
<Global>^DHCOPInsFootI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UserFD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HIS_User}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{HIS_INSFootDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{HIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDate">
<Global>^DHCOPInsFootI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HIS_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{HIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexUser">
<Global>^DHCOPInsFootI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HIS_User}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{HIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINVPRTReportsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
