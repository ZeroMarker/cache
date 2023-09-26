/// zfb
/// 2018.3.14
/// 建行(联迪-LD)数据处理
Class DHCBILL.MisPos.Adapter.LDMisPos Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：	zfb
/// CreatDate：	2018.3.12
/// Desc:		pos交易入参串整理(LD)
/// Input:		tradeAmt 交易金额
/// 	 		bankTradeType 银行交易类型(C/D/T)
/// 			bankType 银行pos代码
/// 			refPosInfo 退费的原正记录相关参数串
/// 	 		expStr 扩展(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)
/// Return:		posInputInfo 组织的pos交易入参串 
/// Debug：		w ##class(DHCBILL.MisPos.Adapter.LDMisPos).GetPosInputInfo(2.90,"C","LD","","303^238^2^4632^^^223332^^C")
ClassMethod GetPosInputInfo(tradeAmt, bankTradeType, bankType, refPosInfo, expStr)
{
	new (tradeAmt, bankTradeType, bankType ,refPosInfo, expStr)
	s ^zfbtest("GetPosInputInfo")=tradeAmt_","_bankTradeType_","_bankType_","_refPosInfo_","_expStr
	s posInputInfo=""
	i refPosInfo'="" d
	.//**********此处接口来自山东阳光融合联迪接口文档，仅供参考，具体以项目接口文档为主**********
	.//2交易类型:（'00'-签到 '01'-消费 '02'-消费撤销  '03'- 隔日退货  '04'-查询  '05-重打印  '06-结算）
	.s trans=##class(DHCBILL.MisPos.BLL.MisPosLogic).GetTradeCodeByBankTradeType(bankTradeType,bankType)				
	.s CardType=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateArg(2,"")		//2卡类型
	.s amount=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateAmt(tradeAmt)		//12金额（12字节，无小数点，左补0，单位：分）
	.s cardno=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateArg(20,"")			//20卡号	(20字节，左对齐，不足部分补空格)
	.s oldreference=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateArg(12,"")	//12原交易参考号
	.s oldtrace=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateArg(6,"")		//6原交易流水号
	.s UserNO=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateArg(15,"")			//15原交易商户号
	.s TerNO=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateArg(15,"")			//15原交易终端号
	.s Date=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateArg(8,"")			//8原交易日期yyyymmdd
	.s posInputInfo=trans_CardType_amount_cardno_oldreference_oldtrace_UserNO_TerNO_Date
	e  d
	.s trans=##class(DHCBILL.MisPos.BLL.MisPosLogic).GetTradeCodeByBankTradeType(bankTradeType,bankType)				
	.s CardType=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateArg(2,"")		//2卡类型
	.s amount=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateAmt(tradeAmt)		//12金额（12字节，无小数点，左补0，单位：分）
	.s cardno=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateArg(20,"")			//20卡号	(20字节，左对齐，不足部分补空格)
	.s oldreference=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateArg(12,"")	//12原交易参考号
	.s oldtrace=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateArg(6,"")		//6原交易流水号
	.s UserNO=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateArg(15,"")			//15原交易商户号
	.s TerNO=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateArg(15,"")			//15原交易终端号
	.s Date=##class(DHCBILL.MisPos.BLL.MisPosLogic).FormateArg(8,"")			//8原交易日期yyyymmdd
	.s posInputInfo=trans_CardType_amount_cardno_oldreference_oldtrace_UserNO_TerNO_Date
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
	//START
	//此处以山东让光融合项目接口文档举例
	//bankData="006222621066668888123 000000000290123456654321123456123456787654321123456787654321      123455432120180322203535招商银行                                                                   err"
	//0～1位	返回码	( 2字节， "00"成功)
	//卡号	(20字节，左对齐，不足部分补空格)
	//金额（12字节，无小数点，左补0，单位：分）
	//交易参考号12
	//流水号  (6字节，左对齐)
	//商户号15
	//终端号15
	//卡类型2
	//有效期	(4字节)
	//批次号10
	//交易日期yyyymmdd 8
	//交易时间hhmmss 6
	//发卡行中文名20
	//other(88位原交易信息,看着没用不取)
	//错误说明(40字节，左对齐，不足部分补空格)
	//END
	
	s Rc="00"				//交易成功失败标志
	s Rcdetail="交易成功"	//交易描述
	//**********注意：此处需要根据银行返回值的交易结果判断是交易成功还是失败**********
	s judge=$e(bankData,0,2)	//解析数据时先判断银行串是否成功（此处根据银行实际返回值进行修改）
	i judge'="00" s Rc="-1"		//解析数据时先判断银行串是否成功（此处根据银行实际返回值进行修改）
	q:Rc="-1" Rc
	i Rc="00" d
	.s IBPPan=$e(bankData,3,22)			//卡号,账户号
	.s IBPTramt=$e(bankData,23,34)		//交易金额
	.s systrace=""						//系统号
	.s invoiceno=$e(bankData,47,52)		//单据号
	.s IBPRRN=$e(bankData,35,46)		//对账唯一交易流水(一般是参考号)
	.s Authno=""						//授权号
	.s Tid=$e(bankData,68,82)			//终端号
	.s mchid=$e(bankData,53,67)			//商户号
	.s batchno=$e(bankData,89,98)		//批次号
	.s tellerno=""			//凭证号
	.s bankname=""			//收单行
	.s txndate=$zdh($e(bankData,99,106),8)		//银行交易日期
	.s txntime=$e($e(bankData,107,112),0,2)_":"_$e($e(bankData,107,112),3,4)_":"_$e($e(bankData,107,112),5,6)
	.s txntime=$zth(txntime)	//银行交易时间
	.s expdate=""			//结算日
	.s appendinfo=$e(bankData,113,132)	//扩展信息
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
