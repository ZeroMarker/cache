/// zfb
/// 2018.3.14
/// 农行(创识-CS)数据处理
Class DHCBILL.MisPos.Adapter.CSMisPos Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：	zfb
/// CreatDate：	2018.3.12
/// Desc:		pos交易入参串整理(CS)
/// Input:		tradeAmt 交易金额
/// 	 		bankTradeType 银行交易类型(C/D/T)
/// 			bankType 银行pos代码
/// 			refPosInfo 退费的原正记录相关参数串
/// 	 		expStr 扩展(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)
/// Return:		posInputInfo 组织的pos交易入参串 
/// Debug：		w ##class().GetPosInputInfo()
ClassMethod GetPosInputInfo(tradeAmt, bankTradeType, bankType, refPosInfo, expStr)
{
	new (tradeAmt, bankTradeType, bankType ,refPosInfo, expStr)
	s posInputInfo=""
	q posInputInfo
}

/// Input:	bankData pos交易返回的数据串
/// 	 	bankType 银行类型(工农中建等,按第三方厂商编码,比如建行联迪-LD,农行创识-CS)
ClassMethod GetOutBankData(bankData, bankType)
{
	new (bankData, bankType)
	s (Rc,Rcdetail,IBPPan,IBPTramt,systrace,invoiceno,IBPRRN,Authno,Tid,mchid)=""
	s (batchno,tellerno,bankname,txndate,txntime,expdate,appendinfo)=""
	s (mchName,bankCardType,extTradeChannel,extOutString)=""
	s outBankData=""
	s extOutString=bankData
	s Rc="00"				//交易成功失败标志
	s Rcdetail="交易成功"	//交易描述
	//**********注意：此处需要根据银行返回值的交易结果判断是交易成功还是失败**********
	s judge=$e(bankData,0,2)	//解析数据时先判断银行串是否成功（此处根据银行实际返回值进行修改）
	i judge'="00" s Rc="-1"		//解析数据时先判断银行串是否成功（此处根据银行实际返回值进行修改）
	q:Rc="-1" Rc
	i Rc="00" d
	.s IBPPan=""			//卡号,账户号
	.s IBPTramt=""			//交易金额
	.s systrace=""			//系统号
	.s invoiceno=""			//单据号
	.s IBPRRN=""			//对账唯一交易流水(一般是参考号)
	.s Authno=""			//授权号
	.s Tid=""				//终端号
	.s mchid=""				//商户号
	.s batchno=""			//批次号
	.s tellerno=""			//凭证号
	.s bankname=""			//收单行
	.s txndate=""			//银行交易日期
	.s txntime=""			//银行交易时间
	.s expdate=""			//结算日
	.s appendinfo=""		//扩展信息
	.s mchName=""			//商户名称
	.s bankCardType=""		//银行卡类型（POS返回）
	.s extTradeChannel=""	//第三方交易渠道（app的多种支付渠道）
	
	
	//银行交易后整理的字段,返回给上层进行保存
	s outBankData=Rc_"^"_Rcdetail_"^"_IBPPan_"^"_IBPTramt_"^"_systrace_"^"_invoiceno_"^"_IBPRRN_"^"_Authno_"^"_Tid_"^"_mchid
	s outBankData=outBankData_"^"_batchno_"^"_tellerno_"^"_bankname_"^"_txndate_"^"_txntime_"^"_expdate_"^"_appendinfo
	s outBankData=outBankData_"^"_mchName_"^"_bankCardType_"^"_extTradeChannel_"^"_extOutString
	q outBankData
}

}
