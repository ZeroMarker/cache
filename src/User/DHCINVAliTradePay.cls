Class User.DHCINVAliTradePay Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IAP_RowID, SqlTableName = DHC_INVAliTradePay, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCINVAliConSub As User.DHCINVAliConSub [ Cardinality = children, Inverse = IASIAPParRef ];

Relationship ChildDHCINVAliTradeSub As User.DHCINVAliTradeSub [ Cardinality = children, Inverse = IADIAPParRef ];

/// IAP_Rc
Property IAPRc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IAP_Rc ];

/// IAP_Rc_detail
Property IAPRcdetail As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IAP_Rc_detail ];

/// IAP_Pan
Property IAPPan As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IAP_Pan ];

/// IAP_Tr_amt
Property IAPTramt As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IAP_Tr_amt ];

/// IAP_mer_systrace
Property IAPmersystrace As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IAP_mer_systrace ];

/// IAP_invoice_no
Property IAPinvoiceno As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IAP_invoice_no ];

/// IAP_RRN
Property IAPRRN As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IAP_RRN ];

/// IAP_Auth_no
Property IAPAuthno As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IAP_Auth_no ];

/// IAP_Tid
Property IAPTid As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IAP_Tid ];

/// IAP_mch_id
Property IAPmchid As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IAP_mch_id ];

/// IAP_batch_no
Property IAPbatchno As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IAP_batch_no ];

/// IAP_teller_no
Property IAPtellerno As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IAP_teller_no ];

/// IAP_Bank_name
Property IAPBankname As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IAP_Bank_name ];

/// IAP_txn_date
Property IAPtxndate As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IAP_txn_date ];

/// IAP_txn_time
Property IAPtxntime As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = IAP_txn_time ];

/// IAP_exp_date
Property IAPexpdate As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = IAP_exp_date ];

/// IAP_append_info
Property IAPappendinfo As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = IAP_append_info ];

/// IAP_Status
Property IAPStatus As %Library.String(DISPLAYLIST = ",Normal,Abort", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,A") [ SqlColumnNumber = 19, SqlFieldName = IAP_Status ];

/// IAP_Bank Trade Pay
Property IAPBankTradePayDR As User.DHCINVBankTradePay [ SqlColumnNumber = 20, SqlFieldName = IAP_BankTradePay_DR ];

/// IAP_Old Pay DR
Property IAPOldBankTradePayDR As User.DHCINVBankTradePay [ SqlColumnNumber = 21, SqlFieldName = IAP_OldBankTradePay_DR ];

/// IAP_TradeDate -- bank date
Property IAPTradeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = IAP_TradeDate ];

/// IAP_TradeTime --bank time
Property IAPTradeTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = IAP_TradeTime ];

/// IAP_TradeAmt
Property IAPTradeAmt As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = IAP_TradeAmt ];

Property IAPTradeUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = IAP_TradeUser_DR ];

Property IAPTradeType As %Library.String(DISPLAYLIST = ",OutPatient,InPatient,Deposit", MAXLEN = 130, TRUNCATE = 0, VALUELIST = ",OP,IP,DEP") [ SqlColumnNumber = 25, SqlFieldName = IAP_TradeType ];

/// P:预授权,S:完成预授权,V:撤销预授权,C:支付,D:退费,T:退货,B:批量退货
Property IAPBankTradeType As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = IAP_BankTradeType ];

Property IAPCardType As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = IAP_CardType ];

Property IAPHospitalDr As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = IAP_Hospital_Dr ];

/// IAP_CompleteFlag 预授权完成标志(1:完成,非1:未完成)
Property IAPCompleteFlag As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = IAP_CompleteFlag ];

/// IAP_CompleteReturnFlag 退货完成标志(1:完成,非1:未完成)
Property IAPCompleteReturnFlag As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = IAP_CompleteReturnFlag ];

/// IAP_TradeChannel 交易发起方类型(01-协和自助机具，02-协和收费窗口，03-协和科室 04-114)
Property IAPTradeChannel As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = IAP_TradeChannel ];

/// IAP_HISTradeID	HIS生成的交易流水号
Property IAPHISTradeID As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = IAP_HISTradeID ];

/// IAP_HISOldTradeID	HIS生成的原交易流水号
Property IAPHISOldTradeID As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = IAP_HISOldTradeID ];

/// IAP_Bank_Code	发卡行代码
Property IAPBankCode As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = IAP_Bank_Code ];

/// IAP_AccountingDate	银行记账日期
Property IAPAccountingDate As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = IAP_AccountingDate ];

/// IAP_mch_Name	商户名称
Property IAPmchName As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = IAP_mch_Name ];

/// IAP_oldbatch_no	原交易批次号
Property IAPoldbatchno As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = IAP_oldbatch_no ];

/// IAP_BankCardType	原交易批次号
Property IAPBankCardType As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = IAP_BankCardType ];

/// IAP_InvPrt_DR
Property IAPInvPrtDR As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = IAP_InvPrt_DR ];

/// IAP_Note1	
Property IAPNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = IAP_Note1 ];

/// IAP_Note2	
Property IAPNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = IAP_Note2 ];

/// IAP_Note3	
Property IAPNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = IAP_Note3 ];

/// IAP_Note4	
Property IAPNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = IAP_Note4 ];

/// IAP_Note5	
Property IAPNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = IAP_Note5 ];

/// IAP_Adm_DR
Property IAPAdmDR As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = IAP_Adm_DR ];

/// IAP_Paymode
Property IAPPaymode As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = IAP_Paymode ];

/// IAP_ChargeNo
Property IAPChargeNo As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = IAP_ChargeNo ];

/// IAP_Papmi_Dr
Property IAPPapmiDr As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = IAP_Papmi_Dr ];

/// IAPAsynNum
Property IAPAsynNum As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = IAP_AsynNum ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINVALITP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IAP_AccountingDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="IAP_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="IAP_AsynNum">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="IAP_Auth_no">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IAP_BankCardType">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="IAP_BankTradePay_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IAP_BankTradeType">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IAP_Bank_Code">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="IAP_Bank_name">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IAP_CardType">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="IAP_ChargeNo">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="IAP_CompleteFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="IAP_CompleteReturnFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="IAP_HISOldTradeID">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="IAP_HISTradeID">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="IAP_Hospital_Dr">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="IAP_InvPrt_DR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="IAP_Note1">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="IAP_Note2">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="IAP_Note3">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="IAP_Note4">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="IAP_Note5">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="IAP_OldBankTradePay_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IAP_Pan">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IAP_Papmi_Dr">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="IAP_Paymode">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="IAP_RRN">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IAP_Rc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IAP_Rc_detail">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IAP_Status">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IAP_Tid">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IAP_Tr_amt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IAP_TradeAmt">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IAP_TradeChannel">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="IAP_TradeDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IAP_TradeTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IAP_TradeType">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="IAP_TradeUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="IAP_append_info">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IAP_batch_no">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IAP_exp_date">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IAP_invoice_no">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IAP_mch_Name">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="IAP_mch_id">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IAP_mer_systrace">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IAP_oldbatch_no">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="IAP_teller_no">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IAP_txn_date">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IAP_txn_time">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCINVALITP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IAP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{IAP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCINVALITPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IAP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IAP_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IAP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBankTradeTime">
<Global>^DHCINVALITPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IAP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BANKTRADETIME"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IAP_txn_date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IAP_txn_time}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IAP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDatePos">
<Global>^DHCINVALITPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>IAP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PDPA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IAP_TradeDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IAP_TradeType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IAP_Tid}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IAP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHISDateTime">
<Global>^DHCINVALITPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IAP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HISDTIME"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IAP_TradeDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IAP_TradeTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IAP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOldTraceNo">
<Global>^DHCINVALITPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IAP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"POTN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IAP_HISOldTradeID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IAP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPapmi">
<Global>^DHCINVALITPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IAP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IAP_Papmi_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IAP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTradeNo">
<Global>^DHCINVALITPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IAP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PTN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IAP_HISTradeID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IAP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTradeType">
<Global>^DHCINVALITPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IAP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PBPDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IAP_TradeType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IAP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCINVALITPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IAP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IAP_TradeDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IAP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINVAliTradePayS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
