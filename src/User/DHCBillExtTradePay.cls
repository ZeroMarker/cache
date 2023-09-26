Class User.DHCBillExtTradePay Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ETP_RowID, SqlTableName = DHC_BillExtTradePay, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCBillExtTradeConSub As User.DHCBillExtTradeConSub [ Cardinality = children, Inverse = ETCETPParRef ];

Relationship ChildDHCBillExtTradeOrdSub As User.DHCBillExtTradeOrdSub [ Cardinality = children, Inverse = ETOETPParRef ];

Relationship ChildDHCBillExtTradeTarSub As User.DHCBillExtTradeTarSub [ Cardinality = children, Inverse = ETTETPParRef ];

/// ETP_Rc 交易标志(00:支付/退款成功, 01:待支付, 02:支付/退款失败, 03:待退款, 04:订单作废)
Property ETPRc As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ETP_Rc ];

/// ETP_Rc_Detail 交易描述
Property ETPRcDetail As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ETP_Rc_Detail ];

/// ETP_Pan 卡号,账户号
Property ETPPan As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ETP_Pan ];

/// ETP_Ext_Amt 第三方交易金额
Property ETPExtAmt As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ETP_Ext_Amt ];

/// ETP_Voucher_No POS凭证号
Property ETPVoucherNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ETP_Voucher_No ];

/// ETP_Invoice_No 单据号（POS流水号）
Property ETPInvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ETP_Invoice_No ];

/// ETP_RRN 交易唯一号（POS参考号）
Property ETPRRN As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ETP_RRN ];

/// ETP_Auth_No POS授权号
Property ETPAuthNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ETP_Auth_No ];

/// ETP_Terminal_No 终端号
Property ETPTerminalNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ETP_Terminal_No ];

/// ETP_Merch_No POS商户号
Property ETPMerchNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ETP_Merch_No ];

/// ETP_Batch_No POS批次号
Property ETPBatchNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ETP_Batch_No ];

/// ETP_Teller_No 柜台号
Property ETPTellerNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ETP_Teller_No ];

/// ETP_Bank_Name 收单行
Property ETPBankName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ETP_Bank_Name ];

/// ETP_Ext_Date 第三方交易日期
Property ETPExtDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = ETP_Ext_Date ];

/// ETP_Ext_Time 第三方交易时间
Property ETPExtTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = ETP_Ext_Time ];

/// ETP_Exp_Date 银行结算日期
Property ETPExpDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = ETP_Exp_Date ];

/// ETP_Append_Info 扩展信息
Property ETPAppendInfo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = ETP_Append_Info ];

/// ETP_Status 交易记录状态(Y:HIS业务成功, N:HIS业务失败)
Property ETPStatus As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 19, SqlFieldName = ETP_Status ];

/// ETP_InitTradePay_DR 暂时未用 用于关联 指向本身
Property ETPInitTradePayDR As User.DHCBillExtTradePay [ SqlColumnNumber = 20, SqlFieldName = ETP_InitTradePay_DR ];

/// ETP_OldTradePay_DR 原记录指针
Property ETPOldTradePayDR As User.DHCBillExtTradePay [ SqlColumnNumber = 21, SqlFieldName = ETP_OldTradePay_DR ];

/// ETP_TradeDate  HIS日期
Property ETPTradeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = ETP_TradeDate ];

/// ETP_TradeTime HIS时间
Property ETPTradeTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = ETP_TradeTime ];

/// ETP_TradeAmt HIS金额
Property ETPTradeAmt As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = ETP_TradeAmt ];

/// ETP_TradeType 业务类型(Reg:挂号, OutPatient:门诊收费, InPatient:住院收费, Deposit:住院押金, PreDeposit:门诊预交金, Card:卡费, PhysicalExamination:体检收费, PEDeposit:体检预交金, EPDeposit:留观押金)
Property ETPTradeType As %Library.String(DISPLAYLIST = ",Reg,OutPatient,InPatient,Deposit,PreDeposit,Card,InsuCharge,PhysicalExamination,PEDeposit,EPDeposit", MAXLEN = 30, TRUNCATE = 0, VALUELIST = ",REG,OP,IP,DEP,PRE,CARD,INSU,PE,PEDEP,EPDEP") [ SqlColumnNumber = 25, SqlFieldName = ETP_TradeType ];

/// ETP_TradeUser_DR  HIS操作员 SS_User
Property ETPTradeUserDR As User.SSUser [ SqlColumnNumber = 26, SqlFieldName = ETP_TradeUser_DR ];

/// ETP_ExtTradeType 交易类型 (P:预授权,S:完成预授权,V:撤销预授权,C:支付,D:退费,T:退货,B:批量退货)
Property ETPExtTradeType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = ETP_ExtTradeType ];

/// ETP_CardType 卡类型
Property ETPCardType As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = ETP_CardType ];

/// ETP_Hospital_DR 院区
Property ETPHospitalDR As User.CTHospital [ SqlColumnNumber = 29, SqlFieldName = ETP_Hospital_DR ];

/// ETP_CompleteFlag 预授权完成/撤销标志(空/0:未完成/未撤销,1:完成,2:撤销,3:预授权确认失败)
Property ETPCompleteFlag As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = ETP_CompleteFlag ];

/// ETP_CompleteReturnFlag 批量退货完成标志(0/空:未完成,1:已提交,2:完成)
Property ETPCompleteReturnFlag As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = ETP_CompleteReturnFlag ];

/// ETP_TradeChannel 交易途径/渠道(POSLD POSXL ScanPay)
Property ETPTradeChannel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = ETP_TradeChannel ];

/// ETP_HISTradeID	HIS的交易流水号
Property ETPHISTradeID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = ETP_HISTradeID ];

/// ETP_HISOldTradeID	HIS的原交易流水号
Property ETPHISOldTradeID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = ETP_HISOldTradeID ];

/// ETP_CompleteReturnDate 批量退货完成日期
Property ETPCompleteReturnDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 35, SqlFieldName = ETP_CompleteReturnDate ];

/// ETP_CompleteReturnTime 批量退货完成时间
Property ETPCompleteReturnTime As %Library.Time [ SqlColumnNumber = 36, SqlFieldName = ETP_CompleteReturnTime ];

/// ETP_OldExtDate 原交易日期
Property ETPOldExtDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 37, SqlFieldName = ETP_OldExtDate ];

/// ETP_OldVoucher_No 原凭证号
Property ETPOldVoucherNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = ETP_OldVoucher_No ];

/// ETP_OldRRN 原参考号
Property ETPOldRRN As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = ETP_OldRRN ];

/// ETP_OldBatch_No 原批次号
Property ETPOldBatchNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = ETP_OldBatch_No ];

/// ETP_PAPMI_DR 患者主索引
Property ETPPAPMIDR As User.PAPatMas [ SqlColumnNumber = 41, SqlFieldName = ETP_PAPMI_DR ];

/// ETP_Merch_Name 商户名称
Property ETPMerchName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = ETP_Merch_Name ];

/// ETP_ExtCardType 银行卡类型（POS开户行）
Property ETPExtCardType As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = ETP_ExtCardType ];

/// ETP_Adm  就诊号
Property ETPAdm As User.PAAdm [ SqlColumnNumber = 44, SqlFieldName = ETP_Adm ];

/// ETPInsType  费别
Property ETPInsType As User.PACAdmReason [ SqlColumnNumber = 45, SqlFieldName = ETP_InsType ];

/// ETP_PayMode 支付方式
Property ETPPayMode As User.CTPayMode [ SqlColumnNumber = 46, SqlFieldName = ETP_PayMode ];

/// ETP_ExtTradeChannel 第三方交易渠道（app的多种支付渠道）
Property ETPExtTradeChannel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = ETP_ExtTradeChannel ];

/// ETP_ExtTradeNo 第三方订单号
Property ETPExtTradeNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = ETP_ExtTradeNo ];

/// ETP_HisPrtStr 业务表ID
Property ETPHisPrtStr As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = ETP_HisPrtStr ];

/// ETP_ExtOutString 接口返回信息串
Property ETPExtOutString As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = ETP_ExtOutString ];

/// ETP_ScanCode 支付码 ZhYW 2022-09-16
Property ETPScanCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = ETP_ScanCode ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCBILLETP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ETP_Adm">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="ETP_Append_Info">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ETP_Auth_No">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ETP_Bank_Name">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ETP_Batch_No">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ETP_CardType">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ETP_CompleteFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ETP_CompleteReturnDate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ETP_CompleteReturnFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ETP_CompleteReturnTime">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ETP_Exp_Date">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ETP_ExtCardType">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="ETP_ExtOutString">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="ETP_ExtTradeChannel">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="ETP_ExtTradeNo">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="ETP_ExtTradeType">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ETP_Ext_Amt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ETP_Ext_Date">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ETP_Ext_Time">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ETP_HISOldTradeID">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ETP_HISTradeID">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ETP_HisPrtStr">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="ETP_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ETP_InitTradePay_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ETP_InsType">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="ETP_Invoice_No">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ETP_Merch_Name">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="ETP_Merch_No">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ETP_OldBatch_No">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="ETP_OldExtDate">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ETP_OldRRN">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="ETP_OldTradePay_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ETP_OldVoucher_No">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ETP_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="ETP_Pan">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ETP_PayMode">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="ETP_RRN">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ETP_Rc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ETP_Rc_Detail">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ETP_ScanCode">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="ETP_Status">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ETP_Teller_No">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ETP_Terminal_No">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ETP_TradeAmt">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ETP_TradeChannel">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ETP_TradeDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ETP_TradeTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ETP_TradeType">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ETP_TradeUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ETP_Voucher_No">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCBILLETP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ETP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ETP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETP_Adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdmIns">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ETP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMINS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETP_Adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETP_InsType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ETP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExtDate">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExtDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETP_Ext_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHISTradeID">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HISTradeID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETP_HISTradeID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOldTradeDR">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OldTradeDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETP_OldTradePay_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMI">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETP_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRRN">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RRN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETP_RRN}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETP_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTCDate">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ETP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TCDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETP_TradeChannel}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETP_TradeDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ETP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTTypeDate">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ETP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TTypeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETP_TradeType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETP_TradeDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ETP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTradeDate">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TradeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETP_TradeDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTradeType">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TradeType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETP_TradeType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHC_BillExtTradePay</SqlRowIdName>
<StreamLocation>^User.DHCBillExtTradePayS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
