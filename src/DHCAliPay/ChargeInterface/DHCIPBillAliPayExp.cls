Import SQLUser

/// zhn
/// 2014-07-07
/// 支付宝消息  住院业务类
Class DHCAliPay.ChargeInterface.DHCIPBillAliPayExp Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// wangjian
/// 2014-07-08
/// 支付宝账生成His流水号(账单号)
/// w ##class(DHCAliPay.ChargeInterface.DHCIPBillAliPayExp).SetPayTradeNo("<Request><phoneNo>18511901950</phoneNo><terminalId>zfb_client</terminalId><terminalType>web</terminalType><hospitalId>5</hospitalId><patientCard>000288079134</patientCard><patientId>378464</patientId><admId>1252405</admId><userCode>alipay001</userCode><feeType>IPDEP</feeType></Request>")
ClassMethod SetPayTradeNo(Input As %String) As %GlobalCharacterStream
{
	Set $ZT="AliPaySetTradeNoETForIP"
	New (Input)
	s ^DHCBillAliPay("SetPayTradeNo",+$h,$p($h,",",2),"Input")=Input
    Set err=0
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(DHCAliPay.DHCEntity.PCA.AliPayRequest).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    Set CardNO=inputObj.patientCard
    Set TerminalId=inputObj.terminalId
    Set TerminalType=inputObj.terminalType
    Set HospitalId=inputObj.hospitalId 
    Set PhoneNo=inputObj.phoneNo
    Set PatientId=inputObj.patientId 
    Set AdmInfo=inputObj.admId
    Set UserCode=inputObj.userCode
    Set PatPaySum=inputObj.patAmt
    Set feeType=inputObj.feeType
    Do inputObj.%Close() 
    Set outputObj=##class(DHCAliPay.DHCEntity.PCA.HisTradeNoResponse).%New()
    Set OutputXML=""  
    If (AdmInfo=""){
	   Set outputObj.ResultCode=-1
	   Set outputObj.ErrorMsg="就诊不存在,无法生成订单号"
	   Do outputObj.XMLExportToString(.OutputXML,"Response")
	   Do outputObj.%Close()
	}
	Quit:(AdmInfo="") OutputXML
	If UserCode="" Set UserCode="alipay001"
	Set TradeType="C"
	Set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	Set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	Set gLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)
	Set OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	Set Expstr=Userid_"^3^IP"_"^"_PatPaySum ;user^3^交易来源^金额^原订单号
	If HospitalId="" set HospitalId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(gLoc) ;根据科室取院区 
	;If HospitalId="" set HospitalId=5
	
	//这里先不判断 重复生成订单。
	//Set rtn=..CheckRepeatTrade(AdmInfo,TradeType,Userid)
	s rtn=-1
	If (rtn=-1){
	b	;生成新订单
	Set rtn=..SetHisTradeNoInfoIP(AdmInfo,PatientId,CardNO,TradeType,HospitalId,Expstr)
	}
	Set HisTradeNo=$p(rtn,"^",3)
	Set HisTradeAdm=$p(rtn,"^",4)
	Set HisTradeAmt=$p(rtn,"^",5)
	Set HisTradeAmt=$fn(HisTradeAmt,"",2)
	If (+rtn'=0) {
		 Set outputObj.ResultCode=-2
	   	Set outputObj.ErrorMsg="生成订单号失败!"
	   Do outputObj.XMLExportToString(.OutputXML,"Response")
	   Do outputObj.%Close()
		}
	Quit:(+rtn'=0) OutputXML
	s outputObj.ResultCode=0
	s outputObj.ErrorMsg="生成订单号成功!"
	s outputObj.AdmId=HisTradeAdm
	s outputObj.PatientId=PatientId
	s outputObj.HisTradeNo=HisTradeNo
	s outputObj.HisTradeAmt=HisTradeAmt
	Do outputObj.XMLExportToString(.OutputXML,"Response")
	Do outputObj.%Close()
	b //1
	Quit OutputXML
	;
AliPaySetTradeNoETForIP
   	Set outputObj=##class(DHCAliPay.DHCEntity.PCA.HisTradeNoResponse).%New()
   	b 
   	Set outputObj.ResultCode=-10
   	Set outputObj.ErrorMsg="程序处理出错:"_$ZERROR
  	Set OutputXML=""
   	Do outputObj.XMLExportToString(.OutputXML,"Response")
   	Do outputObj.%Close()
	Quit OutputXML
}

/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).SetHisTradeNoInfoIP()
ClassMethod SetHisTradeNoInfoIP(Adm, PatientId, BankCardNO, BankTradeType, HospDR, ExpStr)
{
	n (Adm,PatientId, BankCardNO, BankTradeType, HospDR, ExpStr)
	s ^DHCBillAliPay("SetHisTradeNoInfoIP",+$h,$p($h,",",2),"Input")=Adm_"%%"_PatientId_"%%"_BankCardNO_"%%"_BankTradeType_"%%"_HospDR_"%%"_ExpStr
	;user^3^交易来源^金额^原订单号
	// 1.先 生成订单，预交金订单。
	// Set Expstr=Userid_"^3^IP"_"^"_PatPaySum ;user^3^交易来源^金额^原订单号
#;    Set BankRequset=TradeCode_"^"_TerminalID_"^"_HospitalId_"^"_Userid_"^"_PatientCard_"^"_CardTypeCode
#;    Set BankRequset=BankRequset_"^"_Adm_"^"_Amount_"^"_PayMode_"^"_TransactionId_"^"_BankCode
#;    Set BankRequset=BankRequset_"^"_BankAccDate_"^"_BankTransactionId_"^"_BankCardNo_"^"_TradeType_"^"_MchNo_"^"_BankName_"^"_BatchNo_"^"_BankCardType_"^"_RcDetail_"^"_ExpDate_"^"_AuthNo
	s Guser=$p(ExpStr,"^",1)
	s TradeType=$p(ExpStr,"^",3)
	s PatPaySum=$p(ExpStr,"^",4)
	s OldTradeId=$p(ExpStr,"^",5)  ;原订单号 没有传空
	s TradeID=""
	s RetCode=0
	s:$g(OldTradeId)="" OldTradeId=""
	TSTART
	b ;Insert DHCIPAutoDepBankData
	K PLIST	
	//s PLIST(2)=$p(BankRequset,"^",1)	;交易代码
	//s PLIST(3)=$p(BankRequset,"^",2)	;终端编码
    s PLIST(4)=HospDR					;医院唯一编号
    s PLIST(5)=Guser					;操作员代码
	//s PLIST(6)=$p(BankRequset,"^",5)	;卡号
	//s PLIST(7)=$p(BankRequset,"^",6)	;卡类型
    //s PLIST(8)=$p(BankRequset,"^",7)	;就诊号
    s PLIST(9)=28						;支付方式
	//s PLIST(10)=$p(BankRequset,"^",10)	;交易流水号
	//s PLIST(11)=$p(BankRequset,"^",11) 	;交易银行  
    //s PLIST(12)						;银行交易日期
    //s PLIST(13)						;银行交易日期
    s PLIST(14)=+$h
    s PLIST(15)=$p($h,",",2)
    //s PLIST(16)=$p(BankRequset,"^",13)	;银行交易流水号
    //s PLIST(17)=$p(BankRequset,"^",14)	;银行卡号
    s PLIST(18)=PatPaySum			    ;银行交易金额  
    //s PLIST(19)=PrtRowid				;HIS押金表指针
    s PLIST(20)=BankTradeType			;交易类型
    //s PLIST(21)=$p(BankRequset,"^",16)	;商户号
	//    s PLIST(22)						;支付方式主表
    s PLIST(23)=$g(OldTradeId)						;原交易记录
    //s PLIST(27)=$p(BankRequset,"^",17)	;银行，描述
    //s PLIST(28)=$p(BankRequset,"^",18)	;批次号
    s PLIST(29)="DEP"					;类型
    //s PLIST(30)=$p(BankRequset,"^",19)	;银行卡类型
    //s PLIST(31)=$p(BankRequset,"^",20)	;错误描述
    //s PLIST(32)=$p(BankRequset,"^",21)	;卡片有效期
    //s PLIST(33)=$p(BankRequset,"^",22)	;授权号
 	b ;00000000001
	s myRtn=##class(web.DHCIPAutoDepBankData).INSERT()
	s err=$p(myRtn,"^",1)
	s IBPRowID=$p(myRtn,"^",2)
 	s RetCode=RetCode+SQLCODE
 	b ;1
 	i RetCode'=0  d
 	.Trollback
	q:(RetCode'=0) RetCode
 	s IBPRowID=$p($g(%ROWID),$c(1))
	s TradeID=..SetTransactionId(IBPRowID,HospDR)	;生成HIS端交易号
    s TradeID=$p(TradeID,$c(1))
    &sql(update DHCIPAutoDepBankData set TransactionId=:TradeID,Adm=:Adm,PapmiDr=:PatientId where ADBDRowID=:IBPRowID)
	s RetCode=RetCode+SQLCODE
	b ;2
	i RetCode'=0  d
	.Trollback
	q:(RetCode'=0) RetCode
 	If RetCode'=0  Do
 	.Trollback
 	Else  Do
 	.Tcommit
 	s TradeAmt=PatPaySum
	s rtn=RetCode_"^"_IBPRowID_"^"_TradeID_"^"_$g(Adm)_"^"_$g(TradeAmt)
	q rtn
}

ClassMethod SetTransactionId(IBPRowid, HospDR)
{
	n (IBPRowid, HospDR)
	s HospCode="ZZIP"               ;$e($p(^CT("HOSP",HospDR),"^",1)	,0,2)
	s CurrDate=$zd(+$h,8)
	s CurrTime=$tr($zt($p($h,",",2),1),":","")
	s tmp="0000"
	s:$l(IBPRowid)>4 IBPRowid=$e(IBPRowid,$l(IBPRowid)-3,$l(IBPRowid))
	s FormatIBPRowid=$e(tmp,1,$l(tmp)-$l(IBPRowid))_IBPRowid
	s rtn=CurrDate_CurrTime_HospCode_FormatIBPRowid
	;s title=$zd(+$h,8)
	;s rtn=title_rtn
	q rtn
}

/// wangjian
/// 2014-07-08
/// 支付宝账生成His住院预交金退费流水号(账单号)
/// w ##class(DHCAliPay.ChargeInterface.DHCIPBillAliPayExp).SetRefundTradeNo(678320,678322,"D^4^1^276^1")
ClassMethod SetRefundTradeNo(PreDepositRowid As %String, RefDepositRowid As %String, ExpInfo As %String = "") As %GlobalCharacterStream
{
	s ^DHCBillWeChat("SetRefundTradeNoIP",+$h,$p($h,",",2),"Input")=PreDepositRowid_","_RefDepositRowid_","_ExpInfo
	q:($g(PreDepositRowid)="")&&($g(RefDepositRowid)="") "-1^入参为空"
	if ($g(PreDepositRowid)="") {
		s PreDepositRowid=##class(web.UDHCJFDeposit).functionC(RefDepositRowid) ;本类中也有functionA,B,C方法
		//s PreDepositRowid=..functionC(RefDepositRowid) ;本类中也有functionA,B,C方法
		}	
	q:$g(PreDepositRowid)="" "-1^原订单id空"
	//取得订单表所需参数，从原订单生成 就诊号 病人id CardNO  TradeNO
	s PreTradeInfoStr=##class(web.UDHCJFDeposit).functionB(PreDepositRowid,"")
	q:$p(PreTradeInfoStr,"###",1)=-1 PreTradeInfoStr
	s PreTradeInfo=$p(PreTradeInfoStr,"###",2)
	s AdmInfo=$p(PreTradeInfo,"^",7)
	s CardNO=""   ;$p(PreTradeInfo,"^",7)   ;前面没有存。。。TAT
	s TradeNO=$p(PreTradeInfo,"^",9)
	s PatientId=$p(PreTradeInfo,"^",33)
	s TradeId=$p(PreTradeInfoStr,"###",1)
	
	//负押金表中取得 就诊号 ，病人id，操作员id
	s RefDepositInfo=$g(^DHCSFPRINTDETAIL(RefDepositRowid))
	s Adm=$p(RefDepositInfo,"^",4)
	b ;001
	q:Adm'=AdmInfo "-1^his交易记录跟平台交易就诊号不一致"
	s User=$p(RefDepositInfo,"^",14)  ;adduserid
	s PatPaySum=$p(^DHCSFPRINTDETAIL(PreDepositRowid),"^",6)  ;adduserid
	//ExpInfo 传入 TradeType  HospitalId
	s TradeType=$p(ExpInfo,"^",1)
	s HospitalId=$p(ExpInfo,"^",2)
	s Userid=$p(ExpInfo,"^",3)
	s:$g(TradeType)="" TradeType="D"
	s:$g(PatientId)="" PatientId=$p(^PAADM(Adm),"^",1)
	s:$g(HospitalId)="" HospitalId=$g(%session.Data("LOGON.HOSPID"))		;session['LOGON.HOSPID']
	s:$g(Userid)="" Userid=$g(User)		;session['LOGON.HOSPID']
	Set Expstr=Userid_"^3^IP"_"^"_PatPaySum_"^"_TradeId ;user^3^交易来源^金额^原订单号
	Set rtn=..SetHisTradeNoInfoIP(AdmInfo,PatientId,CardNO,TradeType,HospitalId,Expstr)
	b ;iddddddddddddddddd
	Set HisTradeNo=$p(rtn,"^",3)
	Set HisTradeAdm=$p(rtn,"^",4)
	Set HisTradeAmt=$p(rtn,"^",5)
	Set HisTradeAmt=$fn(HisTradeAmt,"",2)
	q:(+rtn'=0) "-1^生成订单号失败:"_rtn
	;q "0^生成订单号成功!"_"###"_rtn
	q rtn
}

/// 交住院预交金
/// Creator:wangjian
/// CreatDate:2013-02-20
/// Desc:住院预交金充值业务
/// Input:
/// Return:
/// w ##class(DHCAliPay.ChargeInterface.DHCIPBillAliPayExp).AddIPPatDeposit("<Request><phoneNo></phoneNo><terminalId>wx_client</terminalId><terminalType>WeChat</terminalType><patAmt>1000</patAmt><hisTradeNo>20150616091909ZZIP0001</hisTradeNo><hospitalId>5</hospitalId><patientCard></patientCard><patientId></patientId><admId></admId><userCode>alipay001</userCode><bankTradeInfo><BankTradeNo>1000080416201506090227856655</BankTradeNo><HISTradeNo>20150616091909ZZIP0001</HISTradeNo><PayCardNo></PayCardNo><PayAmt>1000</PayAmt><BankDate>20150609145058</BankDate></bankTradeInfo></Request>")
ClassMethod AddIPPatDeposit(Input As %String) As %String
{
	//Set $ZT="AddIPPatDepositET"
	Set ^Lid("AddIPPatDeposit")=Input
	New (Input)
	
	/*
	<Request><phoneNo></phoneNo><terminalId>wx_client</terminalId><terminalType>WeChat</terminalType><patAmt>1000</patAmt><hisTradeNo>20150616091909ZZIP0001</hisTradeNo><hospitalId>5</hospitalId><patientCard></patientCard><patientId></patientId><admId></admId><userCode>alipay001</userCode><bankTradeInfo><BankTradeNo>1000080416201506090227856655</BankTradeNo><HISTradeNo>20150616091909ZZIP0001</HISTradeNo><PayCardNo></PayCardNo><PayAmt>1000</PayAmt><BankDate>20150609145058</BankDate></bankTradeInfo></Request>
	
	*/
	b ;	New (Input)
	Set ^DHCBillWeChatPay("OPBillCharge",+$h,$p($h,",",2),"Input")=Input
    Set err=0,HospDR=""
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(DHCAliPay.DHCEntity.PCA.AliPayRequest).%New()
	Set WeChatTradeInfoObj=##class(DHCAliPay.DHCEntity.PCA.BankPayResult).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    Set CardNO=inputObj.patientCard
    Set TerminalId=inputObj.terminalId
    Set TerminalType=inputObj.terminalType
    Set HospitalId=inputObj.hospitalId 
    Set PhoneNo=inputObj.phoneNo
    Set PatientId=inputObj.patientId 
    Set AdmInfo=inputObj.admId
    Set UserCode=inputObj.userCode
    Set PatPaySum=inputObj.patAmt 
    set HisTradeNo=inputObj.hisTradeNo
   
    Set WeChatTradeInfoObj=inputObj.bankTradeInfo
    b ;微信返回信息
    Set WeChatPayResultCode=WeChatTradeInfoObj.ResultCode ;交易结果,错误代码表0000：成功
    Set WeChatPayRevTranFlag=WeChatTradeInfoObj.RevTranFlag ;正反交易标志0-扣费，1-退费
    Set WeChatPayTradeNo=WeChatTradeInfoObj.BankTradeNo ;微信交易流水号
    Set WeChatPayAccountNo=WeChatTradeInfoObj.PayCardNo ;微信账户
    Set WeChatPayPaySum=WeChatTradeInfoObj.PayAmt ;扣款总金额
    Set WeChatPayHISTradeNo=WeChatTradeInfoObj.HISTradeNo ;HIS流水号--订单号
    Set WeChatPayPatientID=WeChatTradeInfoObj.PatientID ;病人登记号
    Set WeChatPayOrgHISTradeNo=WeChatTradeInfoObj.OrgHISTradeNo ;原交易流水号(暂不用)
    Set WeChatPayTradeDateTime=WeChatTradeInfoObj.BankDate
    Set WeChatPayTradeDate=$p(WeChatPayTradeDateTime," ",1)
    Set WeChatPayTradeTime=$p(WeChatPayTradeDateTime," ",2)
    ;Set WeChatPayTradeDate=$e(WeChatPayTradeDateTime,1,10)
    ;Set WeChatPayTradeTime=$e(WeChatPayTradeDateTime,11,12)_":"_$e(WeChatPayTradeDateTime,13,14)_":"_$e(WeChatPayTradeDateTime,15,16)
    If WeChatPayTradeDate'="" Set WeChatPayTradeDate=$zdh(WeChatPayTradeDate,3)
    If WeChatPayTradeTime'="" Set WeChatPayTradeTime=$zth(WeChatPayTradeTime,1)
    b ;交易信息
 	s WeChatPayTradeInfo=WeChatPayHISTradeNo_"^"_WeChatPayPaySum_"^"_WeChatPayTradeNo_"^"_WeChatPayAccountNo_"^^"_WeChatPayTradeDate_"^"_WeChatPayTradeTime
    Do WeChatTradeInfoObj.%Close()
    Do inputObj.%Close()
    b ;获取必要信息
    If UserCode="" Set UserCode="wechatpay001"
    ;Set UserCode="wechatpay001"
	Set TradeType="C"
	Set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	Set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	Set gLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)
	Set OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	Set Expstr=Userid_"^3^IP"
	If HospitalId="" set HospitalId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(gLoc) ;根据科室取院区 
    Set ChargeObj=##class(DHCAliPay.DHCEntity.PCA.AutoPayChargeResult).%New()
    Set OutputXML=""
    If (HisTradeNo=""){
		Set ChargeObj.ResultCode=-2
		Set ChargeObj.ErrorMsg="订单号不能为空"
		Do ChargeObj.XMLExportToString(.OutputXML,"Response")
		Do ChargeObj.%Close()
    }
   Quit:(HisTradeNo="") OutputXML
    b ;根据订单取就诊
	Set IBPRowid=$o(^DHCIPAutoDepBankData(0,"TransactionId",HisTradeNo,""))
	Set IBPRc=""
	If (+IBPRowid'=0) {
		Set AdmInfo=$p(^DHCIPAutoDepBankData(IBPRowid),"^",7)
		Set IBPRc=$p(^DHCIPAutoDepBankData(IBPRowid),"^",30)
	}Else {
		Set AdmInfo="" 
		}
	If (IBPRc["0000"){
		Set ChargeObj.ResultCode=-4
	  	Set ChargeObj.ErrorMsg="此订单已经付款成功"
	   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   	Do ChargeObj.%Close()
		}
	Quit:(IBPRc["0000") OutputXML
	If (+IBPRowid=0) {
	Set ChargeObj.ResultCode=-3
	  	Set ChargeObj.ErrorMsg="无效订单号"
	  	set rollrtn=..RollBack(WeChatPayTradeInfo,Userid,TradeType,"",Paymode,"无效订单号","")
	   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   	Do ChargeObj.%Close()
		}   
	Quit:(+IBPRowid=0) OutputXML
    If (+AdmInfo=0) {
		Set ChargeObj.ResultCode=-1
		Set ChargeObj.ErrorMsg="就诊记录不存在,不能结算"
		set rollrtn=..RollBack(WeChatPayTradeInfo,Userid,TradeType,"",Paymode,"就诊记录不存在","")
		Do ChargeObj.XMLExportToString(.OutputXML,"Response")
		Do ChargeObj.%Close()	
	}
	Quit:(+AdmInfo=0) OutputXML
	b ;获取订单状态
	Set HisTradeNoStutas=..GetHisTradelockInfo(HisTradeNo)
	If (HisTradeNoStutas=1){
		Set ChargeObj.ResultCode=-5
		Set ChargeObj.ErrorMsg="此订单在交易中"
		Do ChargeObj.XMLExportToString(.OutputXML,"Response")
		Do ChargeObj.%Close()
	}
	If (HisTradeNoStutas=-1){
		Set ChargeObj.ResultCode=-6
		Set ChargeObj.ErrorMsg="此订单已交易失败"
		Do ChargeObj.XMLExportToString(.OutputXML,"Response")
		Do ChargeObj.%Close()
	}
	If (HisTradeNoStutas=0){
		Set ChargeObj.ResultCode=-4
		Set ChargeObj.ErrorMsg="此订单已经付款成功"
		Do ChargeObj.XMLExportToString(.OutputXML,"Response")
		Do ChargeObj.%Close()
	}
	Quit:(HisTradeNoStutas'="") OutputXML 
    Set rtn=..SetHisTradelockInfo(HisTradeNo,1)
	b ;转换成his字段
	Set RcptInfo=..GetRcptNo("","",Userid,"住院押金")
	Set CurNo=$p(RcptInfo,"^",3)
	Set EndNo=$p(RcptInfo,"^",2)	
	Set Title=$p(RcptInfo,"^",4)
	Set RcptRowid=$p(RcptInfo,"^",1)
	Set PayMode=28 //##class(RegInterface.GetRelate).GetHisPayModeID(PayModeCode)
	Set Bank=""
    Set myDepType="1"
    Set myPayAmt=WeChatPayPaySum
    Set myPayMode=28
    Set myCompany=""
    Set myBank="WeChat" ;需转换
    Set myCardNo=WeChatPayAccountNo
    Set myAuthNo=WeChatPayAccountNo
    Set myAdm=AdmInfo
    Set myCurNo=CurNo
    Set myGloc=gLoc
    Set myUserid=Userid
    Set myEndNo=EndNo
    Set myTitle=Title
    Set myBanksub=""
    Set myComment=""
    Set myPassword=""
    Set myRcptRowid=RcptRowid
    Set Dep=myDepType_"^"_myPayAmt_"^"_myPayMode_"^"_myCompany_"^"_myBank_"^"_myCardNo_"^"_myAuthNo
    Set Dep=Dep_"^"_myAdm_"^"_myCurNo_"^"_myGloc_"^"_myUserid_"^"_myEndNo_"^"_myTitle_"^"_myBanksub
    Set Dep=Dep_"^"_myComment_"^"_myPassword_"^"_myRcptRowid
    b ;BankRequset    这里开始his交押金
    d ..tb()
    /*
    事务处理
    1.交押金，A成功 B失败
    2.A.1押金成功以后，更新订单表。
    2.A.2更新订单表以后，返回成功消息
    2.B.1失败的话，回滚操作
    2.B.2调用微信退费接口,退掉押金费用
    2.B.3退掉微信费用以后，更新订单表
    2.B.4更新以后，返回失败消息
    */
    Set DepositInfo=..InsertDeposit(Dep,"") ;交押金
    set ResultFlag=$p(DepositInfo,"^",1) ;判断返回值
    if ResultFlag'=0 Trollback
    b ;DepositInfo
    ////这里 his 交押金执行完以后，根据情况来确认，或者回滚。
    If (ResultFlag=0){
		Set PrtRowid=$p(DepositInfo,"^",2)
		Set id=$p(DepositInfo,"^",3)
		Set PatFee=##class(web.UDHCJFCKD).totalamount(myAdm) 
		Set Deposit=##class(web.UDHCJFCKD).deposit(myAdm) 
		Set Remain=Deposit-PatFee
		Set PrtNo=$p($p(^DHCSFPRINTDETAIL(PrtRowid),"^",1),$c(1))
		s retcodestr=..UpdateWeChatPayInfo(myAdm,WeChatPayTradeInfo,Userid,TradeType,PrtRowid,"","结算成功",id)
		b //是否需要提供调用消息回传 提示成功
		s retcode=$P(retcodestr,"^",1)
		Set rtn1=..SetHisTradelockInfo(HisTradeNo,0)
    	Set ChargeObj.ResultCode=+rtn
	    i retcode'=0 Trollback
		d ..tc()
		;
		Set ChargeObj.ResultCode=0
		Set ChargeObj.ErrorMsg="交押金成功"
		Do ChargeObj.XMLExportToString(.OutputXML,"Response")
		Do ChargeObj.%Close()
		Set PatientId=$P(^PAADM(myAdm),"^",1)
		Set MsgToAli="您好,您在"_$ZD(+$H,3)_"在郑州市人民医院给"_$p(^PAPER(PatientId,"ALL"),"^",1)_"缴纳住院预交金"_myPayAmt_"元."
		Do ##Class(MHC.PublicMessage).SendToAli(PatientId,MsgToAli,"InPaid")
	}Else{
		Set OutputObj.ResultCode=ResultFlag
		Set OutputObj.ResultContent="交押金失败."
   		Set rollrtn=..RollBack(WeChatPayTradeInfo,Userid,TradeType,"",Paymode,"缴费失败",$g(AdmInfo))
		Do OutputObj.XMLExportToString(.OutputXML,"Response") 
	 	Do OutputObj.%Close()
		
	}   
	Quit OutputXML
 
	;
AddIPPatDepositET
   	Set PatOrderObj=##class(DHCAliPay.DHCEntity.PCA.AutoPayChargeResult).%New()
   	Set PatOrderObj.ResultCode=-10
   	Set PatOrderObj.ErrorMsg="程序处理出错:"_$ZERROR
   	b ;Set PatOrderObj.ErrorMsg="程序处理出错:"_$ZERROR
   	Set rollrtn=..RollBack(WeChatPayTradeInfo,Userid,TradeType,"",Paymode,"程序异常",$g(AdmInfo))
  	Set OutputXML=""
   	Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
   	Do PatOrderObj.%Close()
	Quit OutputXML
}

/// wangjian
/// 2014-07-16
/// 微信成功,His交易异常后续处理
/// 保存交易号,发起反交易
ClassMethod RollBack(WeChatPayTradeInfo, Userid, TradeType, InvRowidStr, Paymode, Reason, tAdmInfo As %String = "")
{
	
 New (WeChatPayTradeInfo,Userid,TradeType,InvRowidStr,Paymode,Reason,tAdmInfo)
 Set ^DHCBillWeChatPay("RollBack",+$h,$p($h,",",2),"Input")=WeChatPayTradeInfo_"%%%"_Userid_"%%%"_TradeType_"%%%"_InvRowidStr_"%%%"_Paymode_"%%%"_Reason_"%%%"_tAdmInfo
 Set Updatertn=..UpdateWeChatPayInfo(tAdmInfo,WeChatPayTradeInfo,Userid,TradeType,InvRowidStr,Paymode,Reason,"")
 Set HisTradeNo=$p(WeChatPayTradeInfo,"^",1)
 Set Setrtn=..SetHisTradelockInfo(HisTradeNo,-1)	
 Quit 0
}

/// wangjian
/// 2014-07-07
/// 更新交易表
/// w ##class(DHCWeChatPay.ChargeInterface.DHCOPBillWeChatPayExp).InsertWeChatPayInfo(5750278,"BJYY1407041539110063^52.00",3788,"C","5928781","23")
/// ; His交易失败时候 AdmId传空 紧接着生成负交易 
/// ExpStr ：失败原因
ClassMethod UpdateWeChatPayInfo(AdmId, TradeInfo, UserId, TradeFlag, PrtStr, PaymDR, ExpStr, ReceiptID = "")
{

 New (AdmId,TradeInfo,UserId,TradeFlag,PrtStr,PaymDR,ExpStr,ReceiptID)
 Quit:(TradeInfo="") "-1^TradeInfoNull"
 b ;his订单号^交易金额^微信交易流水号^微信账号^原支付流水号
 Set RetCode=0
 Set HisTradeNo=$p(TradeInfo,"^",1) 
 Set IBIRowid=$o(^DHCIPAutoDepBankData(0,"TransactionId",HisTradeNo,""))
 Quit:IBIRowid="" "-1^NoTradeNo"
 Set WeChatTradeNo=$p(TradeInfo,"^",3) 
 Set WeChatAccManager=$p(TradeInfo,"^",4)
 Set WeChatTradeDate=$p(TradeInfo,"^",6) ;可以为空以异步为准
 If WeChatTradeDate="" Set WeChatTradeDate=+$h
 Set WeChatTradeTime=$p(TradeInfo,"^",7) ;可以为空以异步为准
 If WeChatTradeTime="" Set WeChatTradeTime=$p($h,",",2)
 Set WeChatChargeAmt=$p(TradeInfo,"^",2)
 Set RcDetail="0000交易成功"
 b //TSTART   全放到外面的事务里面来处理
 &sql(update DHCIPAutoDepBankData set BankAccDate =:WeChatTradeDate
 				,BankAccTime=:WeChatTradeTime
 				,RcDetail=:RcDetail,PrtDeposit_DR=:PrtStr
               ,BankTransactionId=:WeChatTradeNo,Rcpt_DR=:ReceiptID
               ,BankCardNo=:WeChatAccManager where ADBDRowID=:IBIRowid)
               
 Set RetCode=RetCode+SQLCODE  
 q:RetCode'=0 RetCode_"^"_""_"^"_""_"^"_""
 ;;His 交易失败的话 发起负交易
 Set HospitalId=$p(^DHCIPAutoDepBankData(IBIRowid),"^",3)
 Set Note=$p(ExpStr,"^",1)
 ;If (+AdmId="0")&&(TradeFlag="C") Do
 If (Note'["结算成功")&&(TradeFlag="C") Do
 .;his交易失败生成负交易
 .Set myExpStr=UserId_"^3^IP^"_HospitalId_"^"_Note
 .Set rtn=..RefundWeChatPay(HisTradeNo,WeChatChargeAmt,myExpStr)
 Quit RetCode_"^"_IBIRowid_"^"_""_"^"_RcDetail
}

/// wangjian
/// 2014-07-07
/// His交易失败微信退交易(供内部调用)
/// w ##class(DHCWeChatPay.ChargeInterface.DHCOPBillWeChatPayExp).RefundWeChatPay("20141125181827ZGYDYY5172","0.02","1334^3^OP^2^卡号为空")
/// ExpStr:Userid_"^3^OP^HospitalId^备注信息"
ClassMethod RefundWeChatPay(OldHisTradeNo As %String, RefundAmt As %String, ExpStr As %String) As %String
{
	n (OldHisTradeNo,RefundAmt,ExpStr)
	s ^DHCBillWeChatPay("RefundWeChatPay",+$h,$p($h,",",2),OldHisTradeNo,"Input")=OldHisTradeNo_"|"_RefundAmt_"|"_ExpStr
	s rtn=..RefundWeChatPayNew(OldHisTradeNo,RefundAmt,ExpStr)
	s ^DHCBillWeChatPay("RefundWeChatPay",+$h,$p($h,",",2),OldHisTradeNo,"Output")=rtn
	q rtn
}

/// wangjian
/// 2014-07-07
/// w ##class(DHCWeChatPay.ChargeInterface.DHCOPBillWeChatPayExp).RefundWeChatPayNew("20140910172750KM8791","7.50","2538^3^OP^5^调用异常")
ClassMethod RefundWeChatPayNew(OldHisTradeNo As %String, RefundAmt As %String, ExpStr As %String) As %String
{
	n (OldHisTradeNo,RefundAmt,ExpStr)
	s rtnstr=""	
	
	s TradeType="D"
	s Userid=$p(ExpStr,"^",1)
	s HospitalId=$p(ExpStr,"^",4)
	s gLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	i HospitalId="" set HospitalId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(gLoc) ;根据科室取院区 
	s IbpRowid=$o(^DHCIPAutoDepBankData(0,"TransactionId",OldHisTradeNo,""))	
	s AdmInfo=$p(^DHCIPAutoDepBankData(IbpRowid),"^",7)
	s OldWeChatPayNo=$p(^DHCIPAutoDepBankData(IbpRowid),"^",15)
	s CardNO=""
	s Patientid=$p(^DHCIPAutoDepBankData(IbpRowid),"^",33)
	i Patientid="" s Patientid=$p(^PAADM(AdmInfo),"^",1)
	s PayMode=$p(^DHCIPAutoDepBankData(IbpRowid),"^",8)
	s OldTradeAmt=$p(^DHCIPAutoDepBankData(IbpRowid),"^",17)
	s OldHisTradeNo=$p(^DHCIPAutoDepBankData(IbpRowid),"^",9)
	;user^3^交易来源^金额^
	s myExpstr=Userid_"^3^IP"_"^"_RefundAmt_"^"_IbpRowid
	//update by zza
	s rtn=..SetHisTradeNoInfoIP(AdmInfo,Patientid,CardNO,TradeType,HospitalId,myExpstr)
	q:+rtn'=0 "SetTradeErr"
	s HisTradeNo=$p(rtn,"^",3)
	s NewIbpRowid=$p(rtn,"^",2)
	;b ;;;;;;;;;下面信息待定
	;s inputstr=OldWeChatPayNo_"^"_RefundAmt_"^"_HisTradeNo_"^"_Patientid
	;s obj=DHCWeChatPay.DHCOPBillServiceSoap.%New()
	;s rtnstr=obj.PayReturnToZFB(inputsrt)  ;调用微信退费程序	
	;<?xml version='1.0' encoding='UTF-8'?><OrderPayReturn><trade_no>2014070137493957</trade_no><money>0.01</money><memo>东华退款测试</memo><batch_no>2014070137493959</batch_no><patientid>21341241</patientid></OrderPayReturn>
	;<?xml version='1.0' encoding='UTF-8'?><orderpayreturn><error></error><is_success>T</is_success><trade_no>交易号</trade_no><money>0.01</money><memo>东华退款测试</memo><batch_no>新订单</batch_no><patientid>21341241</patientid></orderpayreturn>
	s Mark=$p(ExpStr,"^",5)
	;b ;input
	s rtnstr=##Class(MHC.PublicPay).ReturnPay(OldWeChatPayNo,HisTradeNo,Patientid,RefundAmt,Mark)
	;s rtnstr=##Class(MHC.PublicPay).SendRefundWxPay(OldHisTradeNo,OldTradeAmt,RefundAmt,Patientid,HisTradeNo)
	s ^DHCBillWeChatPay("RefundWeChatPayNew",+$h,$p($h,",",2),OldHisTradeNo,"Output")=rtnstr
	b ;rtnstr
	s WeChatObj=##class(DHCAliPay.DHCEntity.PCA.orderpayreturn).%New()
    d WeChatObj.XMLNodeDeserialize(.WeChatObj,"orderpayreturn",rtnstr)
    s WeChaterror=WeChatObj.error
    s WeChatssuccess=WeChatObj.issuccess ;T 成功 F 失败
    s WeChattradeno=WeChatObj.tradeno ;交易流水号
    s WeChatmoney=WeChatObj.money
    s WeChatmemo=WeChatObj.memo
    s WeChatbatchno=WeChatObj.batchno ;订单号
    s WeChatpatientid=WeChatObj.patientid
    ;q:WeChatbatchno'=OldHisTradeNo "batchnoErr"
	s PrtStr=""
	i WeChatssuccess="T" d
	.;保存微信返回信息
	.s rtnstr=0
	.s ReTradeInfo=HisTradeNo_"^"_WeChatmoney_"^"_WeChattradeno_"^"_""
	.s InsuFlag=""
	.;his订单号^交易金额^微信交易流水号^微信账号
	.s rtn=..UpdateWeChatPayInfo(AdmInfo,ReTradeInfo,Userid,TradeType,PrtStr,PayMode,"","")
	e  d
	.s rtn=WeChaterror
	
	q rtn
}

/// Creator:wangjian
/// CreatDate:2013-02-20
/// Desc:为不影响正常交押金把自助交押金单独插入押金表
ClassMethod InsertDeposit(Dep, BankRequset) As %String
{
	n (Dep, BankRequset)
	/// BankRequset 不用了
	;向表ar_receipts,ar_rcptalloc,ar_rcptPayMode,dhc_sfprintdetail插入数据
	s retcode=0
    s DepType=$p(Dep,"^",1)
    s PayAmt=$p(Dep,"^",2)
    s PayMode=$p(Dep,"^",3)
    s Company=$p(Dep,"^",4)
    s Bank=$p(Dep,"^",5)
    s CardNo=$p(Dep,"^",6)
    s AuthNo=$p(Dep,"^",7)
    s Adm=$p(Dep,"^",8)
    s CurNo=$p(Dep,"^",9)
    s Gloc=$p(Dep,"^",10)
    s Userid=$p(Dep,"^",11)
    s EndNo=$p(Dep,"^",12)
    s Title=$p(Dep,"^",13)
    s Banksub=$p(Dep,"^",14)
    s Comment=$p(Dep,"^",15)
    s Password=$p(Dep,"^",16)
    s RcptRowid=$p(Dep,"^",17)
    i Adm'="" s Papmi=$p(^PAADM(Adm),"^",1)
    i CurNo&&$d(^DHCSFPRINTDETAIL(0,"RcptNo",CurNo))  d
    .s SameNoDr="",SameFlag="N"
    .f  s SameNoDr=$o(^DHCSFPRINTDETAIL(0,"RcptNo",CurNo,SameNoDr))  q:(SameNoDr="")||(SameFlag="Y")  d
    ..s DataStr=$g(^DHCSFPRINTDETAIL(SameNoDr))
    ..s SameNoTitle=$p(DataStr,"^",29)
    ..i SameNoTitle=Title  s SameFlag="Y"
    
    q:(CurNo)&&($d(^DHCSFPRINTDETAIL(0,"RcptNo",CurNo))'=0)&&($g(SameFlag)="Y") "-2"
    s PayAmt=+PayAmt
    k PLIST(1)
    s PLIST(7)=+$h
    s PLIST(11)=0,PLIST(49)=Userid,PLIST(52)=Papmi,PLIST(3)=Gloc,PLIST(48)=Gloc_"||"
    &sql(insert into ar_receipts values :PLIST())
    i SQLCODE'=0 Trollback
    q:SQLCODE'=0 SQLCODE
    s id=$g(%ROWID)
    k PLIST
    s PLIST(0)=id
    s PLIST(5)=PayAmt,PLIST(3)=PayMode,PLIST(4)=Bank,PLIST(21)=Company,PLIST(6)=CardNo,PLIST(7)=AuthNo
    &sql(insert into ar_rcptpaymode values :PLIST())
    b ;ar_rcptpaymode
   // i SQLCODE'=0 Trollback
    q:SQLCODE'=0 SQLCODE
    K PLIST
    s PLIST(0)=id
    S PLIST(9)=Adm,PLIST(4)=PayAmt,PLIST(17)=DepType
	&sql(insert into ar_rcptalloc values :PLIST())
	b
	//i SQLCODE'=0 Trollback
	q:SQLCODE'=0 SQLCODE	
	k PLSIT(1)
	s PLIST(2)=CurNo
    s PLIST(3)=$p($h,",")
    s PLIST(4)=$p($h,",",2)
    s PLIST(5)=Adm
    s PLIST(6)=id
    s PLIST(7)=PayAmt
    s PLIST(8)=""
    s PLIST(9)="1"
    s PLIST(10)=PayMode
    s PLIST(11)=Bank
    s PLIST(12)=CardNo
    s PLIST(13)=Company
    s PLIST(14)=DepType
    s PLIST(15)=Userid
    s PLIST(21)=Userid
    s PLIST(22)="N"
    s PLIST(30)=""
    s PLIST(30)=Title
    s PLIST(33)=""
    s PLIST(34)=Comment
    s PLIST(35)=Password
    s PLIST(36)=Banksub  
    s PLIST(40)="N"  
    &sql(insert into dhc_sfprintdetail VALUES :PLIST())
    s PrtRowid=$g(%ROWID)
    b //i SQLCODE'=0 Trollback
    q:SQLCODE'=0 SQLCODE
    s DepTypeDesc=$p(^ARC("ARCDT",DepType),"^",2)
    if (RcptRowid){
    s retcode=..Ok(CurNo,EndNo,Userid,RcptRowid)
    }
    //i retcode'=0 Trollback
    q:+$g(retcode)'=0 $g(retcode)   
    b ;add by wangjian 2013-02-20 将请求入参插入DHCIPAutoDepBankData表
	q retcode_"^"_PrtRowid_"^"_id
}

ClassMethod tb()
{
	n SQLCODE
	;TSTART  s SQLCODE=$zu(34)
	TSTART
	q
}

ClassMethod tc()
{
 n SQLCODE
 ;i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
 i $$intp^%qartp TCOMMIT
 q
}

ClassMethod Ok(RcptNo, EndNo, Userid, RcptRowid)
{
   s RcptRowid=$g(RcptRowid)
   q:(RcptRowid="") "-1"
    i RcptNo=EndNo d 
    .s endflag="0"
    e  d
    .s RcptNo=..incre("","",RcptNo)
    .s endflag="1"
    b ;ok
    s retcode=0
    s retcode1=0
    s rcptid=""
    s startno=""
    i endflag="1"  d
    .&sql(update dhc_sfreceipt set Rcpt_currentno=:RcptNo 
          where rcpt_rowid=:RcptRowid)
    .s retcode=retcode+SQLCODE
    e  d
    .&sql(update dhc_sfreceipt set Rcpt_currentno=:RcptNo,
          Rcpt_useflag='2'
          where rcpt_rowid=:RcptRowid)
    .s retcode=retcode+SQLCODE	
	.&sql(select nvl(rcpt_rowid,""),Rcpt_startno 
	      into :rcptid,:startno
	      from dhc_sfreceipt 
	     where (rcpt_useflag is null or rcpt_useflag="") and Rcpt_lquser=:Userid)
	.i (rcptid'="")&(SQLCODE=0)  d
	..&sql(update dhc_sfreceipt set Rcpt_currentno=:startno,
	              Rcpt_useflag='1'
	        where Rcpt_rowid=:rcptid)
	..s retcode=retcode+SQLCODE
	.e  d
	..s retcode1=retcode1+SQLCODE
	q retcode
}

ClassMethod incre(itmjs As %Library.String = "", itmjsex As %Library.String = "", invno As %String) As %String
{
 ;发票号自动累加1
	s lng=$l(invno)
	s ret=invno+1
	s l=$l(ret)
	f i=lng:(-1):(l+1) d
	.s ret="0"_""_ret
	q ret
}

ClassMethod GetRcptNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", Guser As %String, deposittype As %String) As %String
{
	k P1
	s Guser=$g(Guser),deposittype=$g(deposittype)
	s rowid="",EndNo="",CurNo="",Title=""
	i deposittype="" s deposittype="住院押金"
	i (deposittype'="")&&(Guser'="")  d
	.s depttypedr=""
	.i deposittype="住院押金"  s depttypedr="I"
	.i deposittype="病历押金"  s depttypedr="M"
	.i deposittype="门诊押金"  s depttypedr="O"
	.i deposittype="急诊押金"  s depttypedr="E"
	.i deposittype="挂号押金"  s depttypedr="R"
	.i deposittype="注册押金"  s depttypedr="L"
	.s RcptRowid=0
	.f  s RcptRowid=$o(^DHCSFRECEIPT(RcptRowid)) q:RcptRowid=""  d
	..s useflag=$p(^DHCSFRECEIPT(RcptRowid),"^",7)
	..q:useflag'="1"
	..s lquser=$p(^DHCSFRECEIPT(RcptRowid),"^",8)
	..q:Guser'=lquser
	..s loc=$p(^DHCSFRECEIPT(RcptRowid),"^",15)
	..q:(loc'=depttypedr)
	..s EndNo=$p(^DHCSFRECEIPT(RcptRowid),"^",4)
	..s CurNo=$p(^DHCSFRECEIPT(RcptRowid),"^",5)
	..s Title=$p(^DHCSFRECEIPT(RcptRowid),"^",9)
	..s rowid=RcptRowid
	s str=rowid_"^"_EndNo_"^"_CurNo_"^"_Title
	q str
}

/// wangjian
/// 2014-07-16
/// 设置交易状态
/// -1 交易异常 0 已成功 1 交易中
ClassMethod SetHisTradelockInfo(HisTradeNO, Status)
{
	New (HisTradeNO,Status)
	Set ^DHCBillWeChatPay("HisTradeNOLock",HisTradeNO)=Status
	Quit 0
}

/// wangjian
/// 2014-07-16
/// 返回一笔交易的交易状态
/// -1 交易异常 0 已成功 1 交易中
ClassMethod GetHisTradelockInfo(HisTradeNO)
{
	New (HisTradeNO)
	Set rtn=$g(^DHCBillWeChatPay("HisTradeNOLock",HisTradeNO)) 
	Quit rtn
}

/// wangjian
/// 2014-07-16
/// 根据门诊发票表Rowid推送结算的医嘱导诊
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).SendOrderMessageToWeChat(2244739)
ClassMethod SendOrderMessageToWeChat(InvStr)
{
    New (InvStr)
	Set Message="请您到:"_Str_"^检查、检验、治疗或取药.^^注意:如需打印发票或退费请到任意收费窗口办理。"
	Else  Set Message="请您分别到"_Str_"就诊或取药"
	Set rtn=##class(MHC.PublicMessage).SendToWX(PrtPatient,Message,"PAYEDORDER","","")
	Quit 0
}

/// wangjian
/// 2014-07-16
/// 根据门诊发票表Rowid推送结算的医嘱导诊
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).SendOrderMessageToWeChat(2244739)
ClassMethod SendOrderMessageToWeChatbak(InvStr)
{
    New (InvStr)
	Set Message="请您到:"_Str_"^检查、检验、治疗或取药.^^注意:如需打印发票或退费请到任意收费窗口办理。"
	Else  Set Message="请您分别到"_Str_"就诊或取药"
	Set rtn=##class(MHC.PublicMessage).SendToWX(PrtPatient,Message,"PAYEDORDER","","")
	Quit 0
}

/// 	是否需要调用第三方接口来退费
/// w ##class(web.UDHCJFDeposit).functionA(628158,"")
ClassMethod functionA(preYJRowid As %String, refundYJRowid As %String)
{
	//根据原来订单的订单支付方式来判断
	//返回0成功 0^WeChat 0^Ali
	//-1 不xing  -1^
	q:($g(preYJRowid)="")&&($g(refundYJRowid)="") "-1^入参为空"
	if ($g(preYJRowid)="") {
		s preYJRowid=..functionC(refundYJRowid)
		} 
	q:$g(preYJRowid)="" "-1^原订单id空"
	s mode=$p(^DHCSFPRINTDETAIL(preYJRowid),"^",9)   //支付方式
	q:$g(mode)="" "-1^原订单支付方式为空"
	s pmExitFlag=$d(^User.DHCCTPayModeExpI("PMEPayModeDRIndex"," IP"," "_mode))
	b ;q:'$g(pmExitFlag) "-1^不允许退费"
	q:'$g(pmExitFlag) "-1^不允许退费"
	q 0_"^"_mode
}

/// 根据作废或者红冲押金id，去取原来发票的id
ClassMethod functionC(yjrowid As %String)
{
	q:$g(yjrowid)="" ""
	s preYJRowidINVNo=$p(^DHCSFPRINTDETAIL(yjrowid),"^",7)
	q:preYJRowidINVNo="" ""
	s preYJRowid=$o(^DHCSFPRINTDETAIL(0,"RefundRcpt",preYJRowidINVNo,""))
	q $g(preYJRowid)
}

/// 根据作废或者红冲押金id，去取原来发票的id
/// 原来押金对应交易的流水id，流水号。
ClassMethod functionB(preYJRowid As %String, refundYJRowid As %String)
{
	q:($g(preYJRowid)="")&&($g(refundYJRowid)="") "-1^入参为空"
	if ($g(preYJRowid)="") {
		s preYJRowid=..functionC(refundYJRowid)
		}	
	q:$g(preYJRowid)="" "-1^原订单id空"
	s IPBankTradeDepositRowid=$o(^DHCIPAutoDepBankData(0,"PrtDepoistDR",preYJRowid,""))
	q:$g(preYJRowid)="" "-1^押金对应的交易记录不存在"
	
	s IPBankTradeInfo=$g(^DHCIPAutoDepBankData(IPBankTradeDepositRowid))
	q IPBankTradeDepositRowid_"###"_$g(IPBankTradeInfo)
}

/// 退住院预交金
/// Creator:zhn
/// CreatDate:2015-06-20
/// Desc:住院预交金退住院预交金yewu
/// Input:
/// Return:
/// w ##class(DHCAliPay.ChargeInterface.DHCIPBillAliPayExp).RefundIPPatDeposit("IP",678320,678322,"","D","201^97^4^^^1^退押金^37")
ClassMethod RefundIPPatDeposit(PatType As %String = "", PreDepositRowid As %String = "", RefDepositRowid As %String = "", BankCardNO As %String = "", BankTradeType As %String = "", ExpStr As %String = "") As %String
{
	s ^DHCChargeInterFace("WeChatPayIPDeposit",+$h)=PatType_","_PreDepositRowid_","_RefDepositRowid_","_BankCardNO_","_BankTradeType_","_ExpStr
	///判断是否可以调用接口来 退押金
	s RefDepositFlag=..functionA(PreDepositRowid,RefDepositRowid)
	q:$P(RefDepositFlag,"^",1)'=0 RefDepositFlag
	///		新的流水id						新的 流水 his交易号	旧的交易信息
	///		（s rtn=OldAliPayNo_"^"_OldHisTradeNo_"^"_Patientid_"^"_AdmInfo_"^"_PayMode）
	/// 	q err_$c(2)_$g(IBPRowID)_$c(2)_$g(HisTradeNo)_$c(2)_$g(OrgTradeInfo)
	///		
	s PreDepTradeInfo=..functionB(PreDepositRowid,RefDepositRowid)
	q:$p(PreDepTradeInfo,"###",1)<0 PreDepTradeInfo
	s PreDepTradeRowid=$p(PreDepTradeInfo,"###",1)
	s PreDepTradeInfo=$p(PreDepTradeInfo,"###",2)
	s OldWeChatPayNo=$P(PreDepTradeInfo,"^",15)
	s OldHisTradeNo=$P(PreDepTradeInfo,"^",9)
	s Patientid=$P(PreDepTradeInfo,"^",33)
	s AdmInfo=$P(PreDepTradeInfo,"^",7)
	s PayMode=$P(PreDepTradeInfo,"^",8)
	s Mark=$p(ExpStr,"^",7)
	s NewHISTradeID=$p(ExpStr,"^",8)
	s HISTradeNo=$P(^DHCIPAutoDepBankData(NewHISTradeID),"^",9)
	i (Mark="") Set Mark="退押金"
	i Patientid="" s Patientid=$p(^PAADM(AdmInfo),"^",1)
	s OldTradeAmt=$p(PreDepTradeInfo,"^",17)
	s TotalAmt=OldTradeAmt   ;;全退直接这样写
	s ExtUserID=$p(ExpStr,"^",6)
	
	///获取当前流水号
	
	B ;;;
	;s rtnstr="<orderpayreturn><error></error><issuccess>T</issuccess><tradeno>2014071115539223</tradeno><money>0.02</money><memo>é????????·</memo><batchno>KMYK1407111841463434</batchno><patientid>416826</patientid></orderpayreturn>"
	s rtnstr=##Class(MHC.PublicPay).ReturnPay(OldWeChatPayNo,HISTradeNo,Patientid,TotalAmt,Mark)
	;s rtnstr=##Class(MHC.PublicPay).SendRefundWxPay(OldWeChatPayNo,TotalAmt,OldTradeAmt,Patientid,HISTradeNo)
	s ^DHCBillWeChatPay("ZZIP","RefoudInfo",HISTradeNo)=rtnstr ;记录请求退费同步消息
	s WeChatObj=##class(DHCWeChatPay.DHCEntity.PCA.orderpayreturn).%New()
    d WeChatObj.XMLNodeDeserialize(.WeChatObj,"orderpayreturn",rtnstr)
    s WeChaterror=WeChatObj.error
    s WeChatssuccess=WeChatObj.issuccess ;T 成功 F 失败
    s WeChattradeno=WeChatObj.tradeno ;交易流水号
    s WeChatmoney=WeChatObj.money
    s WeChatmemo=WeChatObj.memo
    s WeChatbatchno=WeChatObj.batchno ;订单号
    s WeChatpatientid=WeChatObj.patientid
	s rtn=0
	s RcptId=$P(^DHCSFPRINTDETAIL(RefDepositRowid),"^",5)
	i WeChatssuccess="T" d
	.;保存微信返回信息
	.s ReTradeInfo=HISTradeNo_"^"_WeChatmoney_"^"_WeChattradeno_"^"_"" 
	.;his订单号^交易金额^微信交易流水号^微信账号
	.s ^DHCBillWeChatPay("MZJF","UpdateWeChatPayInfo",HISTradeNo)=AdmInfo_","_ReTradeInfo_","_ExtUserID_","_BankTradeType_","_RefDepositRowid_","_PayMode_","_""
	.s rtn=..UpdateWeChatPayInfo(AdmInfo,ReTradeInfo,ExtUserID,BankTradeType,RefDepositRowid,PayMode,"",RcptId)
	.s rtn="0^调用微信退押金成功"
	.Set MsgToAli="您好,您在"_$ZD(+$H,3)_"在郑州市人民医院给"_$p(^PAPER(PatientId,"ALL"),"^",1)_"退回住院预交金"_TotalAmt_"元."
	.Do ##Class(MHC.PublicMessage).SendToAli(PatientId,MsgToAli,"InPaid")

	e  d
	.s rtn=-1_"^"_WeChaterror_"调用微信退费请求失败"
	q $g(rtn)
}

}
