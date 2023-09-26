Class User.DHCINVBankTradePay Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IBP_RowID, SqlTableName = DHC_INVBankTradePay, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCINVBankConSub As User.DHCINVBankConSub [ Cardinality = children, Inverse = IBSIBPParRef ];

Relationship ChildDHCINVBankTradeSub As User.DHCINVBankTradeSub [ Cardinality = children, Inverse = IBDIBPParRef ];

Relationship ChildDHCINVBankBillDetails As User.DHCINVBankBillDetails [ Cardinality = children, Inverse = IBBIBPParRef ];

/// IBP_Rc 交易成功失败标志 00 唯一
Property IBPRc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IBP_Rc ];

/// IBP_Rc_detail  交易描述
Property IBPRcdetail As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IBP_Rc_detail ];

/// IBP_Pan 卡号,账户号
Property IBPPan As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IBP_Pan ];

/// IBP_Tr_amt 交易金额
Property IBPTramt As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IBP_Tr_amt ];

/// IBP_mer_systrace POS凭证号
Property IBPmersystrace As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IBP_mer_systrace ];

/// IBP_invoice_no  单据号（POS流水号）
Property IBPinvoiceno As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IBP_invoice_no ];

/// IBP_RRN 交易唯一号（POS 12位参考号）
Property IBPRRN As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IBP_RRN ];

/// IBP_Auth_no POS授权号
Property IBPAuthno As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IBP_Auth_no ];

/// IBP_Tid 终端号
Property IBPTid As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IBP_Tid ];

/// IBP_mch_id 商户号
Property IBPmchid As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IBP_mch_id ];

/// IBP_batch_no POS批次号
Property IBPbatchno As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IBP_batch_no ];

/// IBP_teller_no  柜台号
Property IBPtellerno As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IBP_teller_no ];

/// IBP_Bank_name 收单行
Property IBPBankname As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IBP_Bank_name ];

/// IBP_txn_date 银行交易日期
Property IBPtxndate As %Library.Date [ SqlColumnNumber = 15, SqlFieldName = IBP_txn_date ];

/// IBP_txn_time 银行交易时间
Property IBPtxntime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = IBP_txn_time ];

/// IBP_exp_date  银行结算日期
Property IBPexpdate As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = IBP_exp_date ];

/// IBP_append_info 扩展信息(例卡有效期)
Property IBPappendinfo As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = IBP_append_info ];

/// IBP_Status 交易记录状态
Property IBPStatus As %Library.String(DISPLAYLIST = ",Normal,Abort", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,A") [ SqlColumnNumber = 19, SqlFieldName = IBP_Status ];

/// IBP_Bank Trade Pay 暂时未用 用于关联
Property IBPBankTradePayDR As User.DHCINVBankTradePay [ SqlColumnNumber = 20, SqlFieldName = IBP_BankTradePay_DR ];

/// IBP_Old Pay DR  原记录指针
Property IBPOldBankTradePayDR As User.DHCINVBankTradePay [ SqlColumnNumber = 21, SqlFieldName = IBP_OldBankTradePay_DR ];

/// IBP_TradeDate  HIS 日期 
Property IBPTradeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = IBP_TradeDate ];

/// IBP_TradeTime HIS 时间
Property IBPTradeTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = IBP_TradeTime ];

/// IBP_TradeAmt HIS 金额
Property IBPTradeAmt As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = IBP_TradeAmt ];

/// IBP_TradeUser_DR  HIS操作员 SS_user
Property IBPTradeUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = IBP_TradeUser_DR ];

/// IBP_TradeType 业务类型
Property IBPTradeType As %Library.String(DISPLAYLIST = ",OutPatient,InPatient,Deposit,PreDeposit,Card,InsuCharge,Cancel", MAXLEN = 20, TRUNCATE = 0, VALUELIST = ",OP,IP,DEP,PRE,CARD,INSU,CANCEL") [ SqlColumnNumber = 25, SqlFieldName = IBP_TradeType ];

/// IBP_BankTradeType 交易类型 (P:预授权,S:完成预授权,V:撤销预授权,C:支付,D:退费,T:退货,B:批量退货)
Property IBPBankTradeType As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = IBP_BankTradeType ];

/// IBP_CardType 卡类型
Property IBPCardType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = IBP_CardType ];

/// IBP_Hospital_Dr 院区
Property IBPHospitalDr As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = IBP_Hospital_Dr ];

/// IBP_CompleteFlag 预授权完成/撤销标志(空/0:未完成/未撤销,1:完成,2:撤销,3:预授权确认失败)
Property IBPCompleteFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = IBP_CompleteFlag ];

/// IBP_CompleteReturnFlag 批量退货完成标志(0/空:未完成,1:已提交,2:完成)
Property IBPCompleteReturnFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = IBP_CompleteReturnFlag ];

/// IBP_TradeChannel 交易发起方类型(01-一卡通自助机具，02-一卡通收费窗口，03-一卡通科室,04-移动端)
Property IBPTradeChannel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = IBP_TradeChannel ];

/// IBP_HISTradeID	HIS的交易流水号
Property IBPHISTradeID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = IBP_HISTradeID ];

/// IBP_HISOldTradeID	HIS的原交易流水号(存ID)
Property IBPHISOldTradeID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = IBP_HISOldTradeID ];

/// IBP_CompleteReturnDate 批量退货完成日期
Property IBPCompleteReturnDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 35, SqlFieldName = IBP_CompleteReturnDate ];

/// IBP_CompleteReturnTime 批量退货完成时间
Property IBPCompleteReturnTime As %Library.Time [ SqlColumnNumber = 36, SqlFieldName = IBP_CompleteReturnTime ];

/// IBP_oldtxndate 原交易日期
Property IBPoldtxndate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 37, SqlFieldName = IBP_oldtxndate ];

/// IBP_oldmer_systrace 原凭证号
Property IBPoldmersystrace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = IBP_oldmer_systrace ];

/// IBP_oldRRN 原参考号
Property IBPoldRRN As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = IBP_oldRRN ];

/// IBP_oldbatch_no 原批次号
Property IBPoldbatchno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = IBP_oldbatch_no ];

/// IBP_papmi_dr 患者主索引
Property IBPpapmidr As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = IBP_papmi_dr ];

/// IBP_mch_Name 商户名称
Property IBPmchName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = IBP_mch_Name ];

/// IBP_BankCardType 银行卡类型（POS开户行）
Property IBPBankCardType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = IBP_BankCardType ];

/// IBP_Adm  就诊号
Property IBPAdm As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = IBP_Adm ];

/// IBPInsType  费别
Property IBPInsType As User.PACAdmReason [ SqlColumnNumber = 45, SqlFieldName = IBP_InsType ];

/// IBP_PayMode 支付方式
Property IBPPayMode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = IBP_PayMode ];

/// IBP_ExtTradeChannel 第三方交易渠道（app的多种支付渠道）
Property IBPExtTradeChannel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = IBP_ExtTradeChannel ];

/// IBP_ExtTradeNo 第三方订单号
Property IBPExtTradeNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = IBP_ExtTradeNo ];

/// IBP_HisPrtStr 业务表ID
Property IBPHisPrtStr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = IBP_HisPrtStr ];

/// IBP_ExtOutString 接口返回信息串
Property IBPExtOutString As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = IBP_ExtOutString ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINVBTP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IBP_Adm">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="IBP_Auth_no">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IBP_BankCardType">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="IBP_BankTradePay_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IBP_BankTradeType">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IBP_Bank_name">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IBP_CardType">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="IBP_CompleteFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="IBP_CompleteReturnDate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="IBP_CompleteReturnFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="IBP_CompleteReturnTime">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="IBP_ExtOutString">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="IBP_ExtTradeChannel">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="IBP_ExtTradeNo">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="IBP_HISOldTradeID">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="IBP_HISTradeID">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="IBP_HisPrtStr">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="IBP_Hospital_Dr">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="IBP_InsType">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="IBP_OldBankTradePay_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IBP_Pan">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IBP_PayMode">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="IBP_RRN">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IBP_Rc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IBP_Rc_detail">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IBP_Status">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IBP_Tid">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IBP_Tr_amt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IBP_TradeAmt">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IBP_TradeChannel">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="IBP_TradeDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IBP_TradeTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IBP_TradeType">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="IBP_TradeUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="IBP_append_info">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IBP_batch_no">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IBP_exp_date">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IBP_invoice_no">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IBP_mch_Name">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="IBP_mch_id">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IBP_mer_systrace">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IBP_oldRRN">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="IBP_oldbatch_no">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="IBP_oldmer_systrace">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="IBP_oldtxndate">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="IBP_papmi_dr">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="IBP_teller_no">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IBP_txn_date">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IBP_txn_time">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCINVBTP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IBP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IBP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCINVBTPi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IBP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBP_Adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdmIns">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IBP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMINS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBP_Adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IBP_InsType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCompleteFlag">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IBP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CompleteFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBP_CompleteFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOldTradDR">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IBP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"POBPDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IBP_OldBankTradePay_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOldTradeID">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IBP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"POTN"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IBP_HISOldTradeID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMIDR">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IBP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBP_papmi_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRRN">
<Global>^DHCINVBTPi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IBP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RRN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBP_RRN}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTradeDate">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IBP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TradeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBP_TradeDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTradeDatePayM">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IBP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DatePayM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBP_TradeDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IBP_PayMode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTradeDateType">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IBP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBP_TradeDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IBP_BankTradeType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTradeNo">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IBP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PTN"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IBP_HISTradeID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTradeType">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IBP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TradeType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IBP_TradeType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTxnDate">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IBP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TxnDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBP_txn_date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINVBankTradePayS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
