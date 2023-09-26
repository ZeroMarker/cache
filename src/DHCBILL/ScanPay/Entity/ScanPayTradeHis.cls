Class DHCBILL.ScanPay.Entity.ScanPayTradeHis Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

// =0 XML属性不按照顺序解析；=1 XML元素和类的属性顺序必须一致，否则解析时将被忽略。

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

// =1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

// =0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = 1;

/// ETPRc 交易标志
Property ETPRc As %String(TRUNCATE = 1);

/// ETPRcDetail 交易描述
Property ETPRcDetail As %String(TRUNCATE = 1);

/// ETPPan 卡号,账户号
Property ETPPan As %String(TRUNCATE = 1);

/// ETPExtAmt 第三方交易金额
Property ETPExtAmt As %String(TRUNCATE = 1);

/// ETPVoucherNo POS凭证号
Property ETPVoucherNo As %String(TRUNCATE = 1);

/// ETPInvoiceNo 单据号（POS流水号）
Property ETPInvoiceNo As %String(TRUNCATE = 1);

/// ETPRRN 交易唯一号（POS参考号）
Property ETPRRN As %String(TRUNCATE = 1);

/// ETPAuthNo POS授权号
Property ETPAuthNo As %String(TRUNCATE = 1);

/// ETPTerminalNo 终端号
Property ETPTerminalNo As %String(TRUNCATE = 1);

/// ETPMerchNo POS商户号
Property ETPMerchNo As %String(TRUNCATE = 1);

/// ETPBatchNo POS批次号
Property ETPBatchNo As %String(TRUNCATE = 1);

/// ETPTellerNo 柜台号
Property ETPTellerNo As %String(TRUNCATE = 1);

/// ETPBankName 收单行
Property ETPBankName As %String(TRUNCATE = 1);

/// ETPExtDate 第三方交易日期
Property ETPExtDate As %String(TRUNCATE = 1);

/// ETPExtTime 第三方交易时间
Property ETPExtTime As %String(TRUNCATE = 1);

/// ETPExpDate 银行结算日期
Property ETPExpDate As %String(TRUNCATE = 1);

/// ETPAppendInfo 扩展信息
Property ETPAppendInfo As %String(TRUNCATE = 1);

/// ETPStatus 交易记录状态
Property ETPStatus As %String(TRUNCATE = 1);

/// ETPInitTradePayDR 暂时未用 用于关联 指向本身
Property ETPInitTradePayDR As %String(TRUNCATE = 1);

/// ETPOldTradePayDR  原记录指针
Property ETPOldTradePayDR As %String(TRUNCATE = 1);

/// ETPTradeDate  HIS日期 
Property ETPTradeDate As %String(TRUNCATE = 1);

/// ETPTradeTime HIS时间
Property ETPTradeTime As %String(TRUNCATE = 1);

/// ETPTradeAmt HIS金额
Property ETPTradeAmt As %String(TRUNCATE = 1);

/// ETPTradeUserDR  HIS操作员 SS_user
Property ETPTradeUserDR As %String(TRUNCATE = 1);

/// ETPTradeType 业务类型
Property ETPTradeType As %String(TRUNCATE = 1);

/// ETPExtTradeType 交易类型 (P:预授权,S:完成预授权,V:撤销预授权,C:支付,D:退费,T:退货,B:批量退货)
Property ETPExtTradeType As %String(TRUNCATE = 1);

/// ETPCardType 卡类型
Property ETPCardType As %String(TRUNCATE = 1);

/// ETPHospitalDR 院区
Property ETPHospitalDR As %String(TRUNCATE = 1);

/// ETPCompleteFlag 预授权完成/撤销标志(空/0:未完成/未撤销,1:完成,2:撤销,3:预授权确认失败)
Property ETPCompleteFlag As %String(TRUNCATE = 1);

/// ETPCompleteReturnFlag 批量退货完成标志(0/空:未完成,1:已提交,2:完成)
Property ETPCompleteReturnFlag As %String(TRUNCATE = 1);

/// ETPTradeChannel 交易途径/渠道(POSLD POSXL ScanPay)
Property ETPTradeChannel As %String(TRUNCATE = 1);

/// ETPHISTradeID	HIS的交易流水号
Property ETPHISTradeID As %String(TRUNCATE = 1);

/// ETPHISOldTradeID	HIS的原交易流水号
Property ETPHISOldTradeID As %String(TRUNCATE = 1);

/// ETPCompleteReturnDate 批量退货完成日期
Property ETPCompleteReturnDate As %String(TRUNCATE = 1);

/// ETPCompleteReturnTime 批量退货完成时间
Property ETPCompleteReturnTime As %String(TRUNCATE = 1);

/// ETPOldExtDate 原交易日期
Property ETPOldExtDate As %String(TRUNCATE = 1);

/// ETPOldVoucherNo 原凭证号
Property ETPOldVoucherNo As %String(TRUNCATE = 1);

/// ETPOldRRN 原参考号
Property ETPOldRRN As %String(TRUNCATE = 1);

/// ETPOldBatchNo 原批次号
Property ETPOldBatchNo As %String(TRUNCATE = 1);

/// ETPPAPMIDR 患者主索引
Property ETPPAPMIDR As %String(TRUNCATE = 1);

/// ETPMerchName 商户名称
Property ETPMerchName As %String(TRUNCATE = 1);

/// ETPExtCardType 银行卡类型（POS开户行）
Property ETPExtCardType As %String(TRUNCATE = 1);

/// ETPAdm  就诊号
Property ETPAdm As %String(TRUNCATE = 1);

/// ETPInsType  费别
Property ETPInsType As %String(TRUNCATE = 1);

/// ETPPayMode 支付方式
Property ETPPayMode As %String(TRUNCATE = 1);

/// ETPExtTradeChannel 第三方交易渠道（app的多种支付渠道）
Property ETPExtTradeChannel As %String(TRUNCATE = 1);

/// ETPExtTradeNo 第三方订单号
Property ETPExtTradeNo As %String(TRUNCATE = 1);

/// ETPHisPrtStr 业务表ID
Property ETPHisPrtStr As %String(TRUNCATE = 1);

/// ETPExtOutString 接口返回信息串
Property ETPExtOutString As %String(MAXLEN = 2000, TRUNCATE = 1);

}
