Class web.DHCPE.NetPre.Pay Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter QuestionnaireDR = 1;

/// w ##class(web.DHCPE.NetPre.Pay).Main("166||N","",15.80,37,1) 
/// ExtStr:收费员^第三方订单号^终端ID
ClassMethod Main(NetPreID, RegNo, PayAmount, PayMode, ExtStr, Flag = "1", PayDetails As %ObjectHandle)
{
	s UserID="4647"  ;默认的操作人员
	s InvUserID=$P(ExtStr,"^",1)
	q:NetPreID="" "-1^网上预约ID不能为空"
	s Type=$P(NetPreID,"||",2)
	s:Type="" Type="P"
	s AccNo=""
	s PayCode=$P(^CT("CTPM",PayMode),"^",1)
    i PayCode="CPP"{
        s AccNo=..GetAccNo(RegNo)
        q:AccNo="" "-1^没有门诊账户，不能使用门诊账户结算"
        s AccAmt=$P(^DHCACD("AccM",AccNo),"^",8)
        q:(+AccAmt<PayAmount) "-1^账户余额不足，余额为:"_AccAmt
    }

	s NetPreID=$P(NetPreID,"||",1)
	i Type="N" //网上预约id
	{
	 	s NetRegNo=$LG(^User.DHCPENetPreRecordD(NetPreID),2)
		q:(Flag="1")&&(NetRegNo="")&&(RegNo="") "-1^登记号不能为空"
		s:(NetRegNo'="")&&(RegNo="") RegNo=NetRegNo
		s:(RegNo'="")&&(NetRegNo="") NetRegNo=RegNo
		q:(NetRegNo'="")&&(RegNo'=NetRegNo) "-1^预约记录对应的登记号和传入登记号不一致"
		s PatID=""
		s:NetRegNo'="" PatID=$O(^PAPERi("PAPMI_PatNo",NetRegNo,0))
		q:(NetRegNo'="")&&(PatID="") "-1^登记号不存在" 
		s PreID=$LG(^User.DHCPENetPreRecordD(NetPreID),13)
	}
	elseif Type="A" //paadm
	{
		s IADM=$O(^DHCPEIADM(0,"PAADM",NetPreID,0))
		q:IADM="" "-1^预约记录不存在"
		s PatID=$P(^PAADM(NetPreID),"^",1)
		s NetRegNo=$P(^PAPER(PatID,"PAT",1),"^",1)
		;q:(NetRegNo="")&&(RegNo="") "-1^登记号不能为空"
		q:RegNo'=NetRegNo "-1^预约记录对应的登记号和传入登记号不一致"
		s PreID=$P(^DHCPEIADM(IADM),"^",4)
	}
	elseif Type="P"  //DHC_PE_PreIADM
	{
		s PreID=NetPreID
	}
	
	s $ZT="NetCashierErr"
	TS
	
	//插入his预约记录、套餐
	i PreID=""
	{
		s err=""
		i (Flag="0")&&(Type="N") d
		.s idCard=$lg(^User.DHCPENetPreRecordD(NetPreID),6)
		.s NetRegNo=##class(web.DHCPE.PreIBaseInfo).GetRegNoByIDCard(idCard)
		.q:NetRegNo'=""
		.//根据网上预约信息插入HIS基本信息表
		.s synRet=..SynBaseInfoByNetRecord(NetPreID,UserID)
		.s:+synRet'=0 err="-1^同步网上预约信息失败"
		.q:err'=""
		.s NetRegNo=$P(synRet,"^",3)
		i err'="" tro  q err
		
		s PreIBaseID=$O(^DHCPEPreIBI(0,"PAPMINo",NetRegNo,0))
		i PreIBaseID="" d
		.d ##class(web.DHCPE.PreIBIUpdate).UpdatePEInfoByHis(NetRegNo)   ;需要修改源方法,增加一个用户的参数
		s PreIBaseID=$O(^DHCPEPreIBI(0,"PAPMINo",NetRegNo,0))
		i PreIBaseID=""  tro  q "-1^插入体检基本信息表错误"
		
		s TelphoneNo=$LG(^User.DHCPENetPreRecordD(NetPreID),19)
		i TelphoneNo'=""
		{
			k IBFLIST
			s IBFLIST(7)=TelphoneNo  //tel1
			s IBFLIST(8)=TelphoneNo  //tel2
			s IBFLIST(9)=TelphoneNo  //mobile
			&sql(update sqluser.DHC_PE_PreIBaseInfo values :IBFLIST() where PIBI_RowId=:PreIBaseID)
		}
		
		;"^1261^^^14/10/70^14/10/70^^^PREREG^N^N^N^^N^N^^DC^ID^1^^^^^^^^^0^0^^1^^^6"
		;RowID1^PIBIDR2^PGADMDR3^PGTeam_DR4^PEDateBegin5^PEDateEnd6^PETime7^PEDeskClerk_DR8^Status9^AsCharged10^iAddOrdItem11^iAddOrdItemLimit12^AddOrdItemAmount13^AddPhcItem14^AddPhcItemLimit15^AddPhcItemAmount16^IReportSend17^DisChargedMode18^VIPLevel19^DelayDate20^Remark21^Sales_DR22^Type23^GetReportDate24^GetReportTime25^PayType26^Percent27^DietFlag28^GiftFlag29^InsureUnit30^PatType_DR_Name31^CheckRoom32^Position33^PatFeeType_DR_Name34^ReCheckFlag35^RoomPlace36$$NetPreID
		s PreDate=$LG(^User.DHCPENetPreRecordD(NetPreID),9)
		s:PreDate'="" PreDate=$ZD(PreDate,4) 
		s LocID=$LG(^User.DHCPENetPreRecordD(NetPreID),17)
		s VIPDesc=$LG(^User.DHCPENetPreRecordD(NetPreID),16)
		s VIPLevel=##class(web.DHCPE.VIPLevel).GetVIPIDByDesc(VIPDesc)  ;需要添加
		s InString = PreID_"^"_PreIBaseID_"^^^"_PreDate_"^"_PreDate_"^^^"_"PREREG^N^N^N^^N^N^^DC^ID^"_VIPLevel_"^^^^^^^^^0^0^^1^^^6^N^" ;需要根据具体库确定具体串
		s InString = InString _"$$"_NetPreID
		s ret=##Class(web.DHCPE.PreIADM).Save("","",InString,UserID,LocID)  ;需要增加用户和科室的参数
		i $P(ret,"^",1)'=0 tro  q "-1^插入his预约记录错误"
		s PreID=$P(ret,"^",2)
		s SetID=$LG(^User.DHCPENetPreRecordD(NetPreID),8)
		i SetID'="" 
		{	
			s ret=##class(web.DHCPE.PreItemList).IInsertItem(PreID,"PERSON","PRE","",SetID,UserID)
			i ret'="" tro  q "-1^插入医嘱套错误"
		} 
	}
	else
	{
		s LocID=$P(^DHCPEPreIADM(PreID),"^",26)
	}
	s Status=$P(^DHCPEPreIADM(PreID),"^",8)
	i Status="CANCELPE" tro  q "-1^his已经取消体检"
	//his登记
	i (Status="PREREG")||(Status="PREREGED")
	{
		s ret=##class(web.DHCPE.DHCPEIAdm).UpdateIADMInfo(PreID, "2","",UserID)  ;需要添加(修改)此方法，有可能其中一些用到用户的地方也需要修改
		s ^wgy(1)=ret
		i ret'="0"  tro  q "-1^his登记错误"
	}
	//his结算
	b ;PreID
	s AuditInfo=..GetNoPayedAudit(PreID)
	s PreAuditIDs=$P(AuditInfo,"^",1)
	s AuditAmt=$P(AuditInfo,"^",2)
	i PreAuditIDs=""  tro  q "-1^没有待收费的记录"
	w +AuditAmt_"$$$"_PayAmount,!
	i +AuditAmt'=+PayAmount tro  q "-1^传入金额和his金额不一致"
	s PayModeInfo=PayMode_","_PayAmount_"#"_AccNo    ;需要设置支付宝支付方式id
	s InvInfo=##class(web.DHCPE.DHCPEPAY).getcurinvno(InvUserID)
	s CurInvNo=$P(InvInfo,"^",1)_"^^1"  ;InvNo_"^^1"  需要修改其中^1是控制不打印发票的
	s invId=$P(InvInfo,"^",2)
	s peAdmType="I"
	s peAdmId=$O(^DHCPEIADM(0,"CRMADM",PreID,0))   ;DHCPEIADM
	s listFlag="1"
	
	s peAdmId=$O(^DHCPEIADM(0,"CRMADM",PreID,0))   ;DHCPEIADM
    s paadm=$P(^DHCPEIADM(peAdmId),"^",1)
	s PatID=$P(^PAADM(paadm),"^",1)
    s LocID=$P(^PAADM(paadm),"^",4)
    s HospID=$P(^CTLOC(LocID),"^",22)
	;以下调用需要根据项目实际情况调整参数  方法里面需要再调用计费方法，插入计费发票信息
	;Cashier(itmjs="",itmjs="",preAuditIds="", crmOrderIds="",amount="",payedInfos="",userId="",locId="",InvNo="",InvID="",pAdmType="",pAdmId="", listFlag="", CheckFlg="0")
	/*原结算程序
	s ret=##class(web.DHCPE.Cashier).Cashier("","",PreAuditIDs,"",PayAmount,PayModeInfo,InvUserID,LocID,CurInvNo,invId,peAdmType,peAdmId,listFlag)
	s Flag=$P(ret,"^",1)
	s InvID=$P(ret,"^",3)
	i Flag'="" tro  q "-1^"_ret*/
	
	/*预结算程序*/
	s ret=##class(web.DHCPE.Cashier).Cashier("","",PreAuditIDs,"",PayAmount,PayModeInfo,InvUserID,LocID,CurInvNo,invId,peAdmType,peAdmId,listFlag,1,HospID)
	s Flag=$P(ret,"^",1)
	s InvID=$P(ret,"^",3)
	i Flag'="" tro  q "-1^"_ret
	s ret=##class(web.DHCPE.Cashier).RealCashier(InvID,InvUserID,CurInvNo)
	s Flag=$P(ret,"^",1)
	i Flag'="" tro  q "-1^"_ret
	
	;在这里调用计费订单
	 ;调用计费组方法  插入交易明细
    ;UserID收费员ID^Grup安全组^GLoc默认登录科室^HospDR院区ID^TerminalID^TradeType交易类型(OP,IP,DEP,PRE,CARD,INSU)^PatientID患者主索引
   	s hisOrderNo=""
   	/*
    s GroupID=165
    s TermianlID=$P(ExtStr,"^",3)
    s hisStr=InvUserID_"^"_GroupID_"^"_LocID_"^"_HospID_"^"_TermianlID_"^PE^"_PatID
    s hisTradRet=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SetHISTradeNo("",paadm,"","C",PayAmount,hisStr)
    i $p(hisTradRet,"^",1)'=0  tro  q "-201^生成HIS流水号失败"
	s hisOrderNo=$p(hisTradRet,"^",3)
    s hisCode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(hisOrderNo,$P(ret,"^",5),.PayDetailsObj,hisStr)
	i hisCode'=0  tro  q "-202^保存交易信息失败！"_hisCode*/
	
	
	
	s ^DHCPEDataEx("NetCashier",InvID,"OrderNo")=ExtStr_"^"_+$H_"^"_$P($H,",",2)_"^"_hisOrderNo  ;收费员^第三方订单号^终端ID
	s ^DHCPEDataEx("NetCashier","ExtOrdNo",$P(ExtStr,"^",2))=InvID
	TC
	q "0^"_InvID_"^"_$g(hisOrderNo)
NetCashierErr
	s $ZT=""
	Tro
	s ErrDesc="结算失败"
	s:$ZE'="" ErrDesc=$ZE
	s ^DHCPENetPayErr(NetPreID_"||"_Type,+$H,$P($H,",",2))=ErrDesc
	q "-100^"_ErrDesc
}

// 根据登记号获取门诊账户ID

// w ##class(web.DHCPE.NetPre).GetAccNo("0000176628")

ClassMethod GetAccNo(RegNo)
{
    s ret=""
    s PAPMIRowID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
    q:PAPMIRowID="" ""
    s AccNo=""
    f  s AccNo=$O(^DHCACDi("AccM",0,"PAPMI",PAPMIRowID,AccNo),-1) q:(AccNo="")||(ret'="")  d
    .s ret=AccNo
    q ret
}

ClassMethod GetNoPayedAudit(PreIADM)
{
	s RetAudit=""
	s TotalAmt=0
	s AuditID=""
	f  s AuditID=$O(^DHCPEPreA(0,"CRMADM","I",PreIADM,AuditID)) q:AuditID=""  d
	.s PayFlag=$P(^DHCPEPreA(AuditID),"^",14)
	.q:PayFlag="CHARGED"
	.s Amt=$P(^DHCPEPreA(AuditID),"^",9)
	.q:+Amt=0
	.s UseFlag=$P(^DHCPEPreA(AuditID),"^",21)
	.q:UseFlag="NU"
	.i RetAudit="" d
	..s RetAudit=AuditID
	.e  d
	..s RetAudit=RetAudit_","_AuditID
	.s TotalAmt=TotalAmt+Amt
	s TotalAmt=$J(TotalAmt,"",2)
	q RetAudit_"^"_TotalAmt
}

// w ##class(web.DHCPE.NetPre.Pay).GetHisTradNo("")

// <Response><ResultCode>0</ResultCode><ErrorMsg>生成订单号成功!</ErrorMsg><PatientId>938209</PatientId><HisTradeNo>20150823163719QYFY8725</HisTradeNo><HisTradeAmt>1549.59</HisTradeAmt></Response>

ClassMethod GetHisTradNo(Input As %String)
{
	n (Input)
	s:Input="" Input="<Request><terminalId>010</terminalId><terminalType>01</terminalType><hospitalId>2</hospitalId><patientId>7031797</patientId><admId>356914||P</admId><userCode>01280</userCode><patAmt>641.30</patAmt></Request>"
	s $ZT="GetHisTradNoErr"
	b ;Input
	s inputObj=##class(DHCAliPay.DHCEntity.PCA.AliPayRequest).%New()
    d inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    s TerminalId=inputObj.terminalId
    s TerminalType=inputObj.terminalType
    s HospitalId=inputObj.hospitalId 
    s PatientId=inputObj.patientId 
    s AdmInfo=inputObj.admId
    s admId=AdmInfo
    s UserCode=inputObj.userCode
    s PatPaySum=inputObj.patAmt
    b ;PatPaySum
    //重新计算需要支付金额
    s AdmType=$P(AdmInfo,"||",2)
    i AdmType="P" d //his预约记录
    .s AmontInfo=..GetNoPayedAudit($P(AdmInfo,"||",1))
    .s PatPaySum=$P(AmontInfo,"^",2)
    e  d  //网上预约记录
    .s SetsID=$LG(^User.DHCPENetPreRecordD($P(AdmInfo,"||",1)),8)
    .s NetSetsID=$O(^User.DHCPENetOrdSetsI("HisSetsIndex",SetsID,0))
    .s Amt=0
    .s:NetSetsID'="" Amt=$LG(^User.DHCPENetOrdSetsD(NetSetsID),4)
    .s PatPaySum=Amt
    
    
    d inputObj.%Close() 
    s outputObj=##class(DHCAliPay.DHCEntity.PCA.HisTradeNoResponse).%New()
    s OutputXML=""  
    i UserCode="" s UserCode="alipay"
	s TradeType="C"
	s:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	s:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	s gLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	s Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)
	s OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	s Expstr=Userid_"^3^OP"_"^"_PatPaySum_"^^H" ;user^3^交易来源^金额^原订单号
	b ;Expstr
	i HospitalId="" s HospitalId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(gLoc) ;根据科室取院区 
	i (AdmInfo="")&&(PatientId="")
	{
		s outputObj.ResultCode=-1
		s outputObj.ErrorMsg="就诊不存在,无法生成订单号"
		d outputObj.XMLExportToString(.OutputXML,"Response")
		d outputObj.%Close()
		q OutputXML
	}
	;i PatientId="" s PatientId=$P(^PAADM(AdmInfo),"^",1)
	s AdmInfo="",CardNO=""
	;w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).SetHisTradeNoInfo("","58","","C","2","933^3^HP^200")
	s rtn=##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).SetHisTradeNoInfo(AdmInfo,PatientId,CardNO,TradeType,HospitalId,Expstr)
	b ;rtn
	i (+rtn'=0) {
		s outputObj.ResultCode=-2
	  	s outputObj.ErrorMsg="生成订单号失败!"
		d outputObj.XMLExportToString(.OutputXML,"Response")
		d outputObj.%Close()
		q OutputXML
	}
	s HisTradeNo=$p(rtn,"^",3)
	s HisTradeAdm=$p(rtn,"^",4)
	s HisTradeAmt=$p(rtn,"^",5)
	s HisTradeAmt=$fn(HisTradeAmt,"",2)
	s outputObj.ResultCode=0
	s outputObj.ErrorMsg="生成订单号成功!"
	s outputObj.AdmId=HisTradeAdm
	s outputObj.PatientId=PatientId
	s outputObj.HisTradeNo=HisTradeNo
	s outputObj.HisTradeAmt=HisTradeAmt
	d outputObj.XMLExportToString(.OutputXML,"Response")
	d outputObj.%Close()
	;k ^PEHISTradeNo(+$H-90)	//清除3个月前的数据
	k ^PEHISTradeNo(HisTradeNo)
	s ^PEHISTradeNo(HisTradeNo,admId)=HisTradeAmt
	q OutputXML
GetHisTradNoErr	
	s outputObj=##class(DHCAliPay.DHCEntity.PCA.HisTradeNoResponse).%New()
   	s outputObj.ResultCode=-10
   	s outputObj.ErrorMsg="程序处理出错:"_$ZERROR
  	s OutputXML=""
   	d outputObj.XMLExportToString(.OutputXML,"Response")
   	d outputObj.%Close()
	q OutputXML
}

// w ##class(web.DHCPE.NetPre.Pay).UpdateTradNo("")

// <Response><ResultCode>0</ResultCode><ErrorMsg>结算成功</ErrorMsg><Invoices><Invoice><TransactionId>20150823163719QYFY8725</TransactionId><InvoiceNO>24987046</InvoiceNO><InvoiceAmt>0.00</InvoiceAmt></Invoice></Invoices></Response>

ClassMethod UpdateTradNo(Input As %String)
{
	n (Input)
	i Input=""
	{
		s Input="<Request><phoneNo>18610513055</phoneNo><terminalId>010</terminalId>"
		s Input=Input_"<terminalType>01</terminalType><hospitalId>2</hospitalId>"
		s Input=Input_"<patientCard></patientCard><patientId>7031797</patientId>"
		s Input=Input_"<admId>356914||P</admId><userCode>01280</userCode>"
		s Input=Input_"<patAmt>641.30</patAmt><bankTradeInfo>"
		s Input=Input_"<BankCode></BankCode><BankDate>2015-11-19 17:24</BankDate><BankTradeNo>20151119141144ZGYDYY6576</BankTradeNo>"
		s Input=Input_"<ResultCode>0</ResultCode><ResultContent></ResultContent>"
		s Input=Input_"<PayCardNo></PayCardNo><BankAccDate></BankAccDate><RevTranFlag>0</RevTranFlag>"
		s Input=Input_"<PatientID>7031797</PatientID><PayAmt>641.30</PayAmt><HISTradeNo>20151119141144ZGYDYY6576</HISTradeNo><OrgHISTradeNo>20151119141144ZGYDYY6576</OrgHISTradeNo></bankTradeInfo>"
		s Input=Input_"<hisTradeNo>20151119141144ZGYDYY6576</hisTradeNo></Request>"
	}
	b ;Input
	;s $zt="UpdateTradNoErr"
	s err=0,HospDR=""
    s inputObj=##class(DHCAliPay.DHCEntity.PCA.AliPayRequest).%New()
	s AliTradeInfoObj=##class(DHCAliPay.DHCEntity.PCA.BankPayResult).%New()
    d inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    s CardNO=inputObj.patientCard
    s TerminalId=inputObj.terminalId
    s TerminalType=inputObj.terminalType
    s HospitalId=inputObj.hospitalId 
    s PhoneNo=inputObj.phoneNo
    s PatientId=inputObj.patientId 
    s AdmInfo=inputObj.admId
    s UserCode=inputObj.userCode
    s PatPaySum=inputObj.patAmt 
    s HisTradeNo=inputObj.hisTradeNo
   
    s AliTradeInfoObj=inputObj.bankTradeInfo
    b ;支付宝返回信息
    s AliPayResultCode=AliTradeInfoObj.ResultCode ;交易结果,错误代码表0000：成功
    s AliPayRevTranFlag=AliTradeInfoObj.RevTranFlag ;正反交易标志0-扣费，1-退费
    s AliPayTradeNo=AliTradeInfoObj.BankTradeNo ;支付宝交易流水号
    s AliPayAccountNo=AliTradeInfoObj.PayCardNo ;支付宝账户
    s AliPayPaySum=AliTradeInfoObj.PayAmt ;扣款总金额
    s AliPayHISTradeNo=AliTradeInfoObj.HISTradeNo ;HIS流水号--订单号
    s AliPayPatientID=AliTradeInfoObj.PatientID ;病人登记号
    s AliPayOrgHISTradeNo=AliTradeInfoObj.OrgHISTradeNo ;原交易流水号(暂不用)
    s AliPayTradeDateTime=AliTradeInfoObj.BankDate
    s AliPayTradeDate=$p(AliPayTradeDateTime," ",1)
    s AliPayTradeTime=$p(AliPayTradeDateTime," ",2)
    i AliPayTradeDate'="" Set AliPayTradeDate=$zdh(AliPayTradeDate,3)
    i AliPayTradeTime'="" Set AliPayTradeTime=$zth(AliPayTradeTime,1)
    ;交易信息
 	s AliPayTradeInfo=AliPayHISTradeNo_"^"_AliPayPaySum_"^"_AliPayTradeNo_"^"_AliPayAccountNo_"^^"_AliPayTradeDate_"^"_AliPayTradeTime
    d AliTradeInfoObj.%Close()
    d inputObj.%Close()
    
    //根据HIS交易号获取AdmInfo
    s AdmInfo=$o(^PEHISTradeNo(HisTradeNo,""),-1)
    
    ;获取必要信息
    i UserCode="" Set UserCode="alipay"
    ;Set UserCode="alipay001"
	s TradeType="C"
	s:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	s:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	s gLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	s Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)
	s OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	s Expstr=Userid_"^3^OP"
	i HospitalId="" s HospitalId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(gLoc) ;根据科室取院区 
	
	s ChargeObj=##class(DHCAliPay.DHCEntity.PCA.AutoPayChargeResult).%New()
    s OutputXML=""
    s Paymode=$o(^CT("CTPM",0,"Code","ALIPAY",""))
    s myPayinfo=Paymode_"^^^^"
    If (HisTradeNo=""){
		s ChargeObj.ResultCode=-2
		s ChargeObj.ErrorMsg="订单号不能为空"
		d ChargeObj.XMLExportToString(.OutputXML,"Response")
		d ChargeObj.%Close()
		q OutputXML
    }
    b ;HisTradeNo
    
    //s IBPRowid=$o(^DHCINVALITPi(0,"PTN",HisTradeNo,""))
	s IBPRowid=$o(^DHCINVBTPi(0,"PTN",HisTradeNo,""))
	b ;IBPRowid
	s IBPRc=""
	i (+IBPRowid'=0) {
		;s IBPRc=$p(^DHCINVALITP(IBPRowid),"^",1)
		s IBPRc=$p(^DHCINVBTP(IBPRowid),"^",1)
		i (IBPRc="0000"){
			s ChargeObj.ResultCode=-4
	  		s ChargeObj.ErrorMsg="此订单已经付款成功"
	   		d ChargeObj.XMLExportToString(.OutputXML,"Response")
	   		d ChargeObj.%Close()
	   		q OutputXML
		}
	}else {
		s ChargeObj.ResultCode=-3
	  	s ChargeObj.ErrorMsg="无效订单号"
	  	b ;1
	  	s rollrtn=##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).RollBack(AliPayTradeInfo,Userid,TradeType,"",Paymode,"无效订单号")
	   	d ChargeObj.XMLExportToString(.OutputXML,"Response")
	   	d ChargeObj.%Close()
	   	q OutputXML
	}
	If (+AdmInfo=0) {
		s ChargeObj.ResultCode=-1
		s ChargeObj.ErrorMsg="就诊记录不存在,不能结算"
		b ;2
		s rollrtn=##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).RollBack(AliPayTradeInfo,Userid,TradeType,"",Paymode,"就诊记录不存在")
		d ChargeObj.XMLExportToString(.OutputXML,"Response")
		d ChargeObj.%Close()
		q OutputXML
	}
	;获取订单状态
	Set HisTradeNoStutas=##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).GetHisTradelockInfo(HisTradeNo)
	b ;
	If (HisTradeNoStutas'=""){
		s:HisTradeNoStutas=1 ChargeObj.ResultCode=-5
		s:HisTradeNoStutas=1 ChargeObj.ErrorMsg="此订单在交易中"
		s:HisTradeNoStutas=-1 ChargeObj.ResultCode=-6
		s:HisTradeNoStutas=-1 ChargeObj.ErrorMsg="此订单已交易失败"
		s:HisTradeNoStutas=0 ChargeObj.ResultCode=-4
		s:HisTradeNoStutas=0 ChargeObj.ErrorMsg="此订单已经付款成功"
		s ChargeObj.ErrorMsg="此订单已交易失败"
		d ChargeObj.XMLExportToString(.OutputXML,"Response")
		d ChargeObj.%Close()
		q OutputXML
	}
	s rtn=##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).SetHisTradelockInfo(HisTradeNo,1)
    //结算
   
    s RegNo=$P(^PAPER(PatientId,"PAT",1),"^",1)
    s ExpStr=Grup_"^"_gLoc_"^"_Paymode
    s rtn=##class(web.DHCPE.NetPre.Pay).Main(AdmInfo,RegNo,AliPayPaySum,ExpStr)
    ;s rtn="0^149"
    i $P(rtn,"^",1)'=0
    {
	    s ErrCode=$P(rtn,"^",2)
	    s rollrtn=##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).RollBack(AliPayTradeInfo,Userid,TradeType,"",Paymode,ErrCode)
		s ChargeObj.ResultCode=102
		s ChargeObj.ErrorMsg=$P(rtn,"^",2)
		d ChargeObj.XMLExportToString(.OutputXML,"Response")
		d ChargeObj.%Close()
		q OutputXML
    }
    s InvID=$P(rtn,"^",2)  ;多张发票ID看如何返回，暂时写的&分割
    s AdmInfo=$P(^DHCPEINVPRT(InvID),"^",2)
    s InvRowidStr=""
    f i=1:1:$l(InvID,"&") d
    .s PrtInvRowid=$p(InvID,"&",i)
    .q:+PrtInvRowid=0
    .s PrtInvRowid=$G(^DHCPEDataEx("DHCPEINVPRT","H2O",PrtInvRowid)) //体检发票id转为门诊发票id
    .s InvRowidStr=InvRowidStr_"^"_PrtInvRowid
    .;获取发药窗口
    .s WinInfo=""
    .;Set WinInfo=##class(web.UDHCOPINVPrtData12).GetPrescWinByPrtRowID(PrtInvRowid)
    .s invAmt=##class(DHCAliPay.ChargeInterface.AliPayLogic).GetOPInvAliPayAmt(PrtInvRowid)
    .s HospDR=""
  	.s InvoiceObj=##class(DHCAliPay.DHCEntity.PCA.Invoice).%New()
    .s InvoiceObj.TransactionId=HisTradeNo
 	.s InvoiceObj.InvoiceNO=PrtInvRowid
 	.s InvoiceObj.InvoiceAmt=$J(invAmt,3,2)
 	.s InvoiceObj.PrescWindow=WinInfo
 	.;Set InvoiceObj.InvocieExpStr=""
 	.d ChargeObj.Invoices.Insert(InvoiceObj)
 	.d InvoiceObj.%Close()
    
    Set rtn=##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).UpdateAliPayInfo(AdmInfo,AliPayTradeInfo,Userid,"",InvRowidStr,Paymode,"结算成功")
 	//Set Mesrtn=##class(DHCAliPay.ChargeInterface.AliPayLogic).SendOrderMessageToAli(InvRowidStr)
 	Set rtn1=##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).SetHisTradelockInfo(HisTradeNo,0)
    Set ChargeObj.ResultCode=0
	Set ChargeObj.ErrorMsg="结算成功" 
    ;
    Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	Do ChargeObj.%Close()
    Quit OutputXML
UpdateTradNoErr
	s $zt=""
	s PatOrderObj=##class(DHCAliPay.DHCEntity.PCA.AutoPayChargeResult).%New()
   	s PatOrderObj.ResultCode=-10
   	s PatOrderObj.ErrorMsg="程序处理出错:"_$ZERROR
   	s rollrtn=##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).RollBack(AliPayTradeInfo,Userid,TradeType,"",Paymode,"程序异常")
  	s OutputXML=""
   	d PatOrderObj.XMLExportToString(.OutputXML,"Response")
   	d PatOrderObj.%Close()
	q OutputXML
}

// w ##class(web.DHCPE.NetPre.Pay).Refund(726,725)

ClassMethod Refund(NewPrtRowid As %String, AbortPrtRowid As %String)
{
	//PatType As %String, NewPrtRowid As %String, AbortPrtRowID As %String, BankCardNO As %String, BankTradeType As %String, ExpStr As %String
	n (NewPrtRowid,AbortPrtRowid,%session)
	s ^tmpwgy("Refund","param")=$lb(NewPrtRowid,AbortPrtRowid)
	s PayInfo =  ##class(web.DHCPE.CashierEx).GetPOSRefundPara(NewPrtRowid,AbortPrtRowid,"","^WECHATPAY^ALIPAY^")
	q:PayInfo="" 0
	s refundAmt=$p(PayInfo,"^",3)
	s OriInvID=$p(PayInfo,"^",8)
	b ; bre 1
	s PatType="PE"
	
	s LocID=526 
	s:$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s GroupID=165 
	s:$D(%session) GroupID=%session.Get("LOGON.GROUPID")
	s HospitalID=$P(^CTLOC(LocID),"^",22)
	s UserID=$P(^DHCPEINVPRT(AbortPrtRowid),"^",10)
	s RefundReason=""	
	//操作员ID^安全组^科室^院区^卡号^退费原因
	s ExpStr=UserID_"^"_GroupID_"^"_LocID_"^"_HospitalID_"^^"_RefundReason  
	s ret = ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).RefundAll(PatType,OriInvID,AbortPrtRowid,NewPrtRowid,refundAmt,ExpStr)
	s ^tmpwgy("Refund","ret")=ret
	q ret
}

/// 体检微信部分退费
/// add by mjw 2019-11-04
ClassMethod RefundByAmt(NewPrtRowid, AbortPrtRowid)
{
	s PatType="PE"
	
	s OnePayInfo=##class(web.DHCPE.CashierEx).GetPayInfoForWX(OrgPrtRowID)
	s OnePayAmt=+$p(OnePayInfo,"^",2)
	s NextPayInfo=##class(web.DHCPE.CashierEx).GetPayInfoForWX(NewPrtRowid)
	s NextPayAmt=+$p(NextPayInfo,"^",2)
	s payAmt=OnePayAmt-NextPayAmt
	q:+payAmt=0 0
	s AbortPrtRowid=$O(^DHCPEINVPRT(0,"REF",OrgPrtRowID,0))
	s OrgPrtRowID=##class(web.DHCPE.CashierEx).GetSourceID(OrgPrtRowID)
	s ret=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).RefundAll(PatType,"",AbortPrtRowid,NewPrtRowid,payAmt,ExpStr)
	s ^TMPMJW("RefundByAmtret",OrgPrtRowID)=ret
	q ret
}

// d ##class(web.DHCPE.NetPre.Pay).ExportCom()

ClassMethod ExportCom()
{
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEContract","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEPreGADM.Home","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEPreTemplateTime","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEPreManagerList","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEPreTemplate","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEPreManager","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPENetOrdSetsInfo","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPENetOrdSetsItemType","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPENetOrdSetsItem","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPENetOrdSetsItemDetail","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEUpdateCheckDate","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEPreDate","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("MHC.ServiceAction","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEOrdSetsEx.List","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEPreGADM.Edit","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEPreGADM.Find","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEPreIADM.Edit","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEPreIADM.Team","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEVIPLevel","D:/NetPre/")
	d ##Class(web.Util.UtilService).GetExportComponents("DHCPEPreIADM.Find","D:/NetPre/")
}

// d ##class(web.DHCPE.NetPre.Pay).UpdateCom()

ClassMethod UpdateCom()
{
	s path="D:/DHCPE/"
	//d ##Class(web.Util.UtilService).PutComponent(XMLName,"True")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPEPreIADMExInfo"_".xml")
	q
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPEPreGADM.Home"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPEPreTemplateTime"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPEPreManagerList"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPEPreTemplate"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPEPreManager"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPENetOrdSetsInfo"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPENetOrdSetsItem"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPENetOrdSetsItemType"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPENetOrdSetsItemDetail"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPEUpdateCheckDate"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPEPreDate"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"MHC.ServiceAction"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPEOrdSetsEx.List"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPEPreGADM.Edit"_".xml")
	d ##Class(web.Util.UtilService).PutComponent("/temp/tj/DHCPEPreGADM.Find.xml","True")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPEPreIADM.Edit"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPEPreIADM.Team"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPEVIPLevel"_".xml")
	d ##Class(web.Util.UtilService).PutComponent(path_"DHCPEPreIADM.Find"_".xml")
}

// w ##class(web.DHCPE.NetPre.Pay).GetNeedPayedRecord(7031797)

ClassMethod GetNeedPayedRecord(PatientID, PreID = "")
{
	n (PatientID,PreID)
	s RegNo=$P(^PAPER(PatientID,"PAT",1),"^",1)
	s IDCard=$P(^PAPER(PatientID,"PAT",3),"^",6)	
	s Name=$P(^PAPER(PatientID,"ALL"),"^",1)
	s Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	s:Sex'="" Sex=$P(^CT("SEX",Sex),"^",2)
	s obj=##class(web.DHCPE.NetPre.Entity.NeedPayRecord).%New()
	s obj.Name=Name
	s obj.Sex=Sex
	
	s SetsDesc=""
	s NetPreID=""
	i IDCard'="" d
	.s NetPreID=..GetNetPreRecordByIDCard(IDCard)
	i (NetPreID="")&&(RegNo'="") d
	.s NetPreID=..GetNetPreRecordByRegNo(RegNo)
	i NetPreID'=""
	{
		s OPUser=1   ;后台预约登记人员
		s TransRet=..TransPENetToRegister(NetPreID,OPUser)
		q:TransRet'=0 TransRet 
	}	
	s IBI=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	i IBI'=""
	{
		s PreIADM=0
 		f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",IBI,PreIADM)) q:PreIADM=""  d
 		.q:(PreID'="")&&(PreIADM'=PreID)
 		.s Status=$P(^DHCPEPreIADM(PreIADM),"^",8)
 		.q:(Status'="REGISTERED")&&(Status'="ARRIVED")
 		.s Amt=0
 		.s AuditID=0
 		.f  s AuditID=$O(^DHCPEPreA(0,"CRMADM","I",PreIADM,AuditID)) q:AuditID=""  d
 		..s Status=$P(^DHCPEPreA(AuditID),"^",21)
 		..q:Status="NU"
 		..s ChargedStatus=$P(^DHCPEPreA(AuditID),"^",14)
 		..q:ChargedStatus="CHARGED"
 		..s OneAmt=$P(^DHCPEPreA(AuditID),"^",9)
 		..s Amt=Amt+OneAmt
 		.q:+Amt=0
 		.s CheckDate=$P(^DHCPEPreIADM(PreIADM),"^",4)
 		.s:CheckDate'="" CheckDate=$ZD(CheckDate,3)
 		.s netid=$O(^User.DHCPENetPreRecordI("NPRPreIADMIndex",$C(32)_PreIADM,""))
 		.s SetsDesc=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(PreIADM)
 		.s childObj=##class(web.DHCPE.NetPre.Entity.PayRecord).%New()
 		.s childObj.Amt=$j(Amt,"",2)
 		.s childObj.CheckDate=CheckDate
 		.s childObj.SetsDesc=SetsDesc
 		.s childObj.RecordID=PreIADM_"||P"
 		.s childObj.NetPreID=netid
 		.//s childObj.QRCode="http://www.baidu.com"
 		.s TotalFee=##class(web.DHCPE.PreItemList).IGetOrdAmount(PreIADM,"PERSON")
 		
 		
 		.s evaluationID=$G(^DHCPEDataNewEx("PreIADMToHM",PreIADM))
		.i evaluationID'="" d
		..s questionChl=$o(^User.DHCHMOQEQuestionI("QEQCQuestionnaireDRIndex",..#QuestionnaireDR,evaluationID,""),-1)
		..i questionChl'=""  d
		...s qeqsStatus = $lg(^User.DHCHMOQEQuestionD(evaluationID,questionChl),15)
		...s childObj.evaluationStat=qeqsStatus
 		
 		
 		
		.s childObj.TotalFee=$p(TotalFee,$C(13),4)
 		.d obj.PayRecords.Insert(childObj)
	}
	s OutputXML=""
	d obj.XMLExportToString(.OutputXML,"Response")
	d obj.%Close()
	q OutputXML
}

/// Descript:通过身份证号取状态为0的网上预约记录(每个患者只有一条记录)
/// Creater:	王国营
/// CreateDate:	2018-08-22
/// Return:NetPreID  
/// w ##class(web.DHCPE.NetPre.Pay).GetNetPreRecordByIDCard(IDCard)
ClassMethod GetNetPreRecordByIDCard(IDCard)
{
	n (IDCard)
	q:IDCard="" ""
	s NetPreID=""
	s ID=""
	f  s ID=$O(^User.DHCPENetPreRecordI("IDCardIndex",$$ALPHAUP^SSUTIL4(IDCard),ID)) q:(ID="")||(NetPreID'="")  d
	.s Status=$LG(^User.DHCPENetPreRecordD(ID),7)
	.q:Status'="0"
	.s NetPreID=ID
	q NetPreID
}

/// Descript:通过登记号取状态为0的网上预约记录(每个患者只有一条记录)
/// Creater:	王国营
/// CreateDate:	2018-08-22
/// Return:NetPreID  
/// w ##class(web.DHCPE.NetPre.Pay).GetNetPreRecordByRegNo(RegNo)
ClassMethod GetNetPreRecordByRegNo(RegNo)
{
	n (RegNo)
	q:RegNo="" ""
	s NetPreID=""
	s ID=""
	f  s ID=$O(^User.DHCPENetPreRecordI("RegNoIndex",$$ALPHAUP^SSUTIL4(RegNo),ID)) q:(ID="")||(NetPreID'="")  d
	.s Status=$LG(^User.DHCPENetPreRecordD(ID),7)
	.q:Status'="0"
	.s NetPreID=ID
	q NetPreID
}

/// Descript:判断网上预约状态是否可同步至HIS
/// Creater:	王国营
/// CreateDate:	2018-08-22
/// Return:0  成功  非0 失败   
/// w ##class(web.DHCPE.NetPre.Pay).IsCanTransToHis(1)
ClassMethod IsCanTransToHis(NetPreID)
{
	n (NetPreID)
	q:'$D(^User.DHCPENetPreRecordD(NetPreID)) "-1^预约ID不存在"
	s status=$LG(^User.DHCPENetPreRecordD(NetPreID),7)
	s pmType=$LG(^User.DHCPENetPreRecordD(NetPreID),22)
	q:(pmType'="I")&&(status'=0) "-2^团体已处理"
	q:status="2" "-2^已取消预约"
	q:status="4" "-4^已缴费"
	q:status="5" "-12^已体检"
	q:status="6" "-13^已取消体检"
	q 0
}

/// Descript:将网上预约信息同步至体检登记状态
/// Creater:	王国营
/// CreateDate:	2018-08-22
/// Input:
/// 				NetPreID：DHC_PE_NetPreRecord
/// Return:0  成功  非0 失败   
/// w ##class(web.DHCPE.NetPre.Pay).TransPENetToRegister(1)
ClassMethod TransPENetToRegister(NetPreID, OPUser = "")
{
	new (NetPreID,OPUser)
	s isCanTrans=..IsCanTransToHis(NetPreID)
	q:isCanTrans'=0 isCanTrans
	s NetRegNo=$lg(^User.DHCPENetPreRecordD(NetPreID),2)
	s idCard=$lg(^User.DHCPENetPreRecordD(NetPreID),6)
	s CardType=$lg(^User.DHCPENetPreRecordD(NetPreID),21)
	s SynFlag=0 ;网上信息是否同步至HIS标记
	S $ZT="ErrHandle"
	TS
	i NetRegNo="" 
	{
		s RegNoErr=""
		s NetRegNo=##class(HS.BL.PECommon).GetRegNoByCardNo(idCard,CardType)
		i NetRegNo'="" d
		.s NetRegNo=$P(NetRegNo,"^",1)
		e  d
		.s synRet=..SynBaseInfoByNetRecord(NetPreID,OPUser)
		.i +synRet'=0 d
		..s RegNoErr="-1^同步网上基本信息失败"
		.e  d
		..s SynFlag=1
		..s NetRegNo=$P(synRet,"^",3)	
		i RegNoErr'="" tro  q RegNoErr 
		;更新网上预约记录表的登记号  和评估人员基本信息表的登记号
		&sql(Update sqluser.DHC_PE_NetPreRecord set NPR_RegNo=:NetRegNo where ID=:NetPreID)
		i SQLCODE'=0 tro  q "-5^更新网上预约登记号失败"
		s OevaluationDR=$lg(^User.DHCPENetPreRecordD(NetPreID),14)
		i OevaluationDR'="" d
		.s OBaseDR=$LG(^User.DHCHMOEvaluationRecordD(OevaluationDR),10)
		.&sql(update sqluser.DHC_HM_OBaseInfo set BIPAPMINo=:NetRegNo where ID=:OBaseDR)
		.s:SQLCODE'=0 RegNoErr="-8^更新评估记录失败"
		i RegNoErr'="" tro  q RegNoErr 
	}
	s PreIBaseID=$O(^DHCPEPreIBI(0,"PAPMINo",NetRegNo,0))
	i PreIBaseID="" d
	.d ##class(web.DHCPE.PreIBIUpdate).UpdatePEInfoByHis(NetRegNo,OPUser)   ;需要修改源方法,增加一个用户的参数
	.s PreIBaseID=$O(^DHCPEPreIBI(0,"PAPMINo",NetRegNo,0))
	i PreIBaseID="" tro   q "-2^插入体检基本信息表错误"
	i SynFlag=0 
	{
		s TelphoneNo=$LG(^User.DHCPENetPreRecordD(NetPreID),19)
		i TelphoneNo'=""
		{
			k IBFLIST
			s IBFLIST(7)=TelphoneNo  //tel1
			s IBFLIST(8)=TelphoneNo  //tel2
			s IBFLIST(9)=TelphoneNo  //mobile
			&sql(update sqluser.DHC_PE_PreIBaseInfo values :IBFLIST() where PIBI_RowId=:PreIBaseID)
		}
	}
	s PreID=$LG(^User.DHCPENetPreRecordD(NetPreID),13)
	i PreID=""
	{
		;"^1261^^^14/10/70^14/10/70^^^PREREG^N^N^N^^N^N^^DC^ID^1^^^^^^^^^0^0^^1^^^6"
		;RowID1^PIBIDR2^PGADMDR3^PGTeam_DR4^PEDateBegin5^PEDateEnd6^PETime7^PEDeskClerk_DR8^Status9^AsCharged10^iAddOrdItem11^iAddOrdItemLimit12^AddOrdItemAmount13^AddPhcItem14^AddPhcItemLimit15^AddPhcItemAmount16^IReportSend17^DisChargedMode18^VIPLevel19^DelayDate20^Remark21^Sales_DR22^Type23^GetReportDate24^GetReportTime25^PayType26^Percent27^DietFlag28^GiftFlag29^InsureUnit30^PatType_DR_Name31^CheckRoom32^Position33^PatFeeType_DR_Name34^ReCheckFlag35^RoomPlace36$$NetPreID
		s PreDate=$LG(^User.DHCPENetPreRecordD(NetPreID),9)
		s:PreDate'="" PreDate=$ZD(PreDate,4) 
		
		
		s preTimeDr=$LG(^User.DHCPENetPreRecordD(NetPreID),20)
		s homeTimeDr=$LG(^User.DHCPENetPreRecordD(NetPreID),23)
		i preTimeDr'=""
		{
			s examTime=$LG(^User.DHCPEPreManagerD(+preTimeDr,"PMTimeChild",$P(preTimeDr,"||",2)),2)
		}
		i homeTimeDr'=""
		{
			s examTime=$LG(^User.DHCPEPreHomeInfoD(+homeTimeDr,"PGTimeInfo",$P(homeTimeDr,"||",2)),2)
		}
		s:$G(examTime)'="" examTime=$ZT(examTime)	
		s LocID=$LG(^User.DHCPENetPreRecordD(NetPreID),17)
		s VIPDesc=$LG(^User.DHCPENetPreRecordD(NetPreID),16)
		s VIPLevel=##class(web.DHCPE.CT.VIPLevel).GetVIPIDByDesc(VIPDesc)  
		s FeeType = "" //$P($G(^DHCPEVIPLevel("VIP",VIPLevel)),"^",7)
		s DietFlag=0,RoomPlace=""
		s InString = PreID_"^"_PreIBaseID_"^^^"_PreDate_"^"_PreDate_"^"_$G(examTime)_"^^"_"PREREG^N^N^N^^N^N^^DC^ID^"_VIPLevel_"^^^^^^^^^"_DietFlag_"^0^^1^^^"_FeeType_"^N^"_RoomPlace ;需要根据具体库确定具体串
		s InString = InString _"$$"_NetPreID
		s ret=##Class(web.DHCPE.PreIADM).Save("","",InString,OPUser,LocID)  ;需要增加用户和科室的参数
		i $P(ret,"^",1)'=0 tro  q "-3^插入his预约记录错误"
		s PreID=$P(ret,"^",2)
		s InsertItemRet=..InserNetItem(NetPreID,OPUser)
		i +InsertItemRet'=0 tro  q InsertItemRet	
	}
	//关联评估记录与体检记录
	s OevaluationDR=$lg(^User.DHCPENetPreRecordD(NetPreID),14)
	i OevaluationDR'=""
	{
		s ^DHCPEDataNewEx("HMToPreIADM",OevaluationDR)=PreID
		s ^DHCPEDataNewEx("PreIADMToHM",PreID)=OevaluationDR
	}
	s Status=$P(^DHCPEPreIADM(PreID),"^",8)
	i Status="CANCELPE" tro  q "-5^his已经取消体检"
	
	i (Status="PREREG")||(Status="PREREGED")
	{
		s ret=##class(web.DHCPE.DHCPEIAdm).UpdateIADMInfo(PreID, "2","",OPUser)  ;需要添加(修改)此方法，有可能其中一些用到用户的地方也需要修改
		b ;登记  ret
		i ret'="0" tro  q "-6^his登记错误"_ret
	}
	Tc
	q 0
ErrHandle
	s $ZT=""
	TRO
	s rtn="-100^同步网上预约记录失败："_$ZE	
	q rtn
}

/// Descript:插入网上预约套餐项目
/// Input：
/// 				
/// Return:0^成功  非0^失败  
/// Creater:	王国营
/// CreateDate:	2019-02-27
/// Debug：w ##class(web.DHCPE.NetPre.Pay).InserNetItem(1306,1305)
ClassMethod InserNetItem(NetPreID As %String, OPUser As %String = "", PmType = "I")
{
	new (NetPreID,OPUser,PmType)
	s NetPreIADM=$LG(^User.DHCPENetPreRecordD(NetPreID),13)
	q:NetPreIADM="" "0^成功"
	s ErrMsg=""
	
	b ;套餐
	s Sub=""
	f  s Sub=$O(^User.DHCPENetPreRecordD(NetPreID,"NPRPreOrdSetsRec",Sub)) q:(Sub="")||(ErrMsg'="")  d
	.s break=$LG(^User.DHCPENetPreRecordD(NetPreID,"NPRPreOrdSetsRec",Sub),4)
	.q:break="Y"  ;已拆分的通过下面项目插入
	.s preType=$LG(^User.DHCPENetPreRecordD(NetPreID,"NPRPreOrdSetsRec",Sub),5)
	.s OrdSetsId=$LG(^User.DHCPENetPreRecordD(NetPreID,"NPRPreOrdSetsRec",Sub),2)
	.s ErrMsg=##class(web.DHCPE.PreItemList).IInsertItem(NetPreIADM,"PERSON",preType,"",OrdSetsId,OPUser)
	.q:ErrMsg'=""
	.s PreIEntSub=$O(^DHCPEPreIADM(0,"OrderSets",OrdSetsId,NetPreIADM,""),-1)
	.i PreIEntSub="" s ErrMsg="-3^插入自选套餐失败"  q
	.s NetOrdSObj=##class(User.DHCPENetPreOrdSetsRec).%OpenId(NetPreID_"||"_Sub)
	.d NetOrdSObj.NPORPreEntDRSetObjectId(NetPreIADM_"||"_PreIEntSub)
	.s sc=NetOrdSObj.%Save()
	.i $$$ISERR(sc) s ErrMsg="-3^更新网上自选套餐失败："_$System.Status.GetErrorText(sc) q
		
	b ;项目
	s NetSub=""
	f  s NetSub=$O(^User.DHCPENetPreRecordD(NetPreID,"NPRPreItemRecord",NetSub)) q:(NetSub="")||(ErrMsg'="")  d
	.s ItemID=$LG(^User.DHCPENetPreRecordD(NetPreID,"NPRPreItemRecord",NetSub),2)
	.q:ItemID=""
	.s preType=$LG(^User.DHCPENetPreRecordD(NetPreID,"NPRPreItemRecord",NetSub),5)
	.s ErrMsg=##class(web.DHCPE.PreItemList).IInsertItem(NetPreIADM,"PERSON",preType,ItemID,"",OPUser)
	.q:ErrMsg'=""
	.s PreIordSub=$O(^DHCPEPreIADM(0,"ItmMast",ItemID,NetPreIADM,""),-1)
	.i PreIordSub="" s ErrMsg="-3^插入自选项目失败" q
	.s NetItmObj=##class(User.DHCPENetPreItemRecord).%OpenId(NetPreID_"||"_NetSub)
	.d NetItmObj.NPIRPreIOrdDRSetObjectId(NetPreIADM_"||"_PreIordSub)
	.s sc=NetItmObj.%Save()
	.i $$$ISERR(sc) s ErrMsg="-3^更新网上自选项目失败："_$System.Status.GetErrorText(sc) q
	
	q:ErrMsg'="" "-2^同步项目至体检系统失败："_ErrMsg
	q "0^成功"
}

/// Descript:网上退费
/// Creater:	王国营
/// CreateDate:	2018-08-24
/// Return:0  成功  非0 失败  
/// w ##class(web.DHCPE.NetPre.Pay).NetRefund(1306,1305)
ClassMethod NetRefund(NewInvID As %String, AbortInvID As %String, UserID)
{
	
	q:AbortInvID="" 0
	
	s OriginInvID=$P(^DHCPEINVPRT(AbortInvID),"^",9)
	q:OriginInvID="" "-1^未检索到被退发票"
	s NetPayInfo=$G(^DHCPEDataEx("NetCashier",OriginInvID,"OrderNo"))
	q:NetPayInfo="" 0 ;第三方订单号为空时  默认不走此退费程序
	
	//根据作废发票和新发票计算退费金额
	s Amount=0
	s AbortAmount=0-$P(^DHCPEINVPRT(AbortInvID),"^",7)
	s NewAmount=0
	s:NewInvID'="" NewAmount=$P(^DHCPEINVPRT(NewInvID),"^",7)
	s Amount=AbortAmount-NewAmount
	q:Amount=0 0 ;应退金额为0
	q ..KingdeeRefund(OrderNo,Amount,AbortInvID)
}

/// Descript:调用金蝶微信退费接口
/// Creater:	王国营
/// CreateDate:	2018-08-24
/// Input: OrderNo 金蝶平台订单号  RefundFee 退费金额 AbortInvID 体检退费发票
/// Return:0  成功  非0 失败  
/// w ##class(web.DHCPE.NetPre.Pay).KingdeeRefund()
ClassMethod KingdeeRefund(OrderNo, RefundFee, AbortInvID)
{
	n (OrderNo,RefundNo,RefundFee,AbortInvID)
	s CurDate=$ZD(+$H,3)
	s CurTime=$zt($P($H,",",2))
	s PAADM=$P(^DHCPEINVPRT(AbortInvID),"^",2)
	s HospID=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADM)
	s RefundNo=..GenerateTradeNo(1,AbortInvID)
	s RequestObj=##class(web.DHCPE.NetPre.Entity.KingdeeRequest).%New()
	s RequestObj.orderId=OrderNo
	s RequestObj.refundTime=CurDate_" "_CurTime
	s RequestObj.refundFee=RefundFee
	s RequestObj.refundNo=RefundNo
	s sc=RequestObj.XMLExportToString(.XML,"req")
	i $$$ISERR(sc)
	{
		q "-2^"_$System.Status.GetErrorText(sc)
	}
	d RequestObj.%Close()
	s ParamXML="<?xml version=""1.0"" encoding=""UTF-8""?>"_XML
	Set httpRequest=##class(%Net.HttpRequest).%New()		
	Set httpRequest.Server="10.243.1.100"
	Set httpRequest.Port="8080"
	Set httpRequest.Timeout=5 ;超过一秒即为不可访问
	
	Set ParamXML=$zcvt(ParamXML,"O","UTF8")
	s sc=httpRequest.EntityBody.Write(ParamXML)
	s reqPath="/kingdee-service/webService?service=getDeptInfo&user=xxx&password=xxx"
	Set flg=httpRequest.Post(reqPath)	
	if $system.Status.IsError(flg)
	{
		q -100_"^"_$system.Status.GetErrorText(flg)
	}
	Set statusCode=httpRequest.HttpResponse.Data
	q statusCode
	i "退费成功" s ^DHCPEDataEx("NetRefund",AbortInvID,"OrderNo")=RefundNo
}

/// Descript:生成交易流水号
/// 生成规则：前缀+时间(YYYYMMDDHHMISS)+发票ID(八位)+流水(六位）
/// Creater:	王国营
/// CreateDate:	2018-08-24
/// Input:0 收费 1 退费
/// Return:
/// w ##class(web.DHCPE.NetPre.Pay).GenerateTradeNo(0)
ClassMethod GenerateTradeNo(Flag, InvID = "")
{
	s TradeNo=""
	s prefix=""
	i Flag=0 s prefix="S"
	i Flag=1 s prefix="T"
	s CurDate=$Replace($ZD(+$H,3),"-","")
	s CurTime=$Replace($zt($P($H,",",2)),":","")
	
	s ZeroStr="00000000" ;8位
	i InvID="" d
	.s InvID=ZeroStr
	e  i $L(InvID)>=8 d
	.s InvID=$E(InvID,$L(InvID)-7,$L(InvID))
	e  d
	.s InvID=$E(ZeroStr,1,8-$l(InvID))_InvID
	s TradeIndex=$I(^DHCPEDataEx("Cashier","TradeIndex"))
	s ZeroStr="000000"  ;6位
	i $L(TradeIndex)>=6 d
	.s TradeIndex=$E(TradeIndex,$L(TradeIndex)-7,$L(TradeIndex))
	e  d
	.s TradeIndex=$E(ZeroStr,1,6-$l(TradeIndex))_TradeIndex
	s TradeNo=prefix_CurDate_CurTime_InvID_TradeIndex	
	q TradeNo
}

// w ##class(web.DHCPE.NetPre.Pay).GetNeedPayItem("417||P")

ClassMethod GetNeedPayItem(AdmID)
{
	n (AdmID)
	s Type=$P(AdmID,"||",2)
	s AdmID=$P(AdmID,"||",1)
	s obj=##class(web.DHCPE.NetPre.Entity.PayItem).%New()
	i Type="N"
	{
		s SetsID=$LG(^User.DHCPENetPreRecordD(AdmID),8)
		s ArcimDesc=$P(^ARCOS(SetsID),"^",2)
		s NetSetsID=$O(^User.DHCPENetOrdSetsI("HisSetsIndex",SetsID,0))
		s Amt=0
		s:NetSetsID'="" Amt=$LG(^User.DHCPENetOrdSetsD(NetSetsID),4)
		s childobj=##class(web.DHCPE.NetPre.Entity.Item).%New()
		s childobj.ArcmiDesc=ArcimDesc
		s childobj.Amt=$j(Amt,"",2)
		d obj.Items.Insert(childobj)
	}
	elseif Type="P"
	;f i=1:1:8
	{
		s AuditID=0
 		f  s AuditID=$O(^DHCPEPreA(0,"CRMADM","I",AdmID,AuditID)) q:AuditID=""  d
 		.s Status=$P(^DHCPEPreA(AuditID),"^",21)
 		.q:Status="NU"
 		.s ChargedStatus=$P(^DHCPEPreA(AuditID),"^",14)
 		.q:ChargedStatus="CHARGED"
 		.s OrdEntSub=0
 		.f  s OrdEntSub=$O(^DHCPEPreIADM(0,"PAORDENT",AuditID,AdmID,OrdEntSub)) q:OrdEntSub=""  d
 		..s SetsID=$P(^DHCPEPreIADM(AdmID,"ORDENT",OrdEntSub),"^",1)
 		..s ArcimDesc=$P(^ARCOS(SetsID),"^",2)
 		..s Amt=0
 		..s FeeSub=0
 		..f  s FeeSub=$O(^DHCPEPreIADM(0,"PAORDENT",AuditID,AdmID,OrdEntSub,FeeSub)) q:FeeSub=""  d
 		...s OneAmt=$P(^DHCPEPreIADM(AdmID,"ORDENT",OrdEntSub,"FEE",FeeSub),"^",2)
 		...s Amt=Amt+OneAmt
 		..s childobj=##class(web.DHCPE.NetPre.Entity.Item).%New()
 		..s childobj.ArcmiDesc=ArcimDesc
 		..s childobj.Amt=$j(Amt,"",2)
 		..d obj.Items.Insert(childobj)
 		
 		.s OrdItemSub=0
 		.f  s OrdItemSub=$O(^DHCPEPreIADM(0,"PAORDITEM",AuditID,AdmID,OrdItemSub)) q:OrdItemSub=""  d
 		..s SetsID=$P(^DHCPEPreIADM(AdmID,"ORDITEM",OrdItemSub),"^",1)
 		..s ArcimDesc=$P(^ARCIM(+SetsID,1,1),"^",2)
 		..s Amt=0
 		..s FeeSub=0
 		..f  s FeeSub=$O(^DHCPEPreIADM(0,"PAORDITEM",AuditID,AdmID,OrdItemSub,FeeSub)) q:FeeSub=""  d
 		...s OneAmt=$P(^DHCPEPreIADM(AdmID,"ORDITEM",OrdItemSub,"FEE",FeeSub),"^",2)
 		...s Amt=Amt+OneAmt
 		..s childobj=##class(web.DHCPE.NetPre.Entity.Item).%New()
 		..s childobj.ArcmiDesc=ArcimDesc
 		..s childobj.Amt=$j(Amt,"",2)
 		..d obj.Items.Insert(childobj)
	}
	
	s OutputXML=""
	d obj.XMLExportToString(.OutputXML,"Response")
	d obj.%Close()
	q OutputXML
}

/// w ##class(web.DHCPE.NetPre.Pay).CancelPre("1||N")
ClassMethod CancelPre(NetPreID)
{
	s Type=$P(NetPreID,"||",2)
	s:Type="" Type="N"
	s NetPreID=$P(NetPreID,"||",1)
	i Type="N" //网上预约id
	{
		s PreID=$LG(^User.DHCPENetPreRecordD(NetPreID),13)
	}
	elseif Type="A" //paadm
	{
		s IADM=$O(^DHCPEIADM(0,"PAADM",NetPreID,0))
		q:IADM="" "-1^预约记录不存在"
		s PatID=$P(^PAADM(NetPreID),"^",1)
		s NetRegNo=$P(^PAPER(PatID,"PAT",1),"^",1)
		;q:(NetRegNo="")&&(RegNo="") "-1^登记号不能为空"
		q:RegNo'=NetRegNo "-1^预约记录对应的登记号和传入登记号不一致"
		s PreID=$P(^DHCPEIADM(IADM),"^",4)
	}
	elseif Type="P"  //DHC_PE_PreIADM
	{
		s PreID=NetPreID
	}
	s ret=0
	i PreID=""{
		s ret=##class(web.DHCPE.NetPre.GetPreInfo).UpdateStatus(NetPreID,"2^^")	
	}else{
		s ret="-1^体检系统已处理，请到前台取消体检"
	}
	q ret
}

/// 将网上预约信息同步到HIS基本信息表、体检基本信息表
/// w ##class(web.DHCPE.NetPre.Pay).SynBaseInfoByNetRecord(162)
ClassMethod SynBaseInfoByNetRecord(NetPreID, UpdateUser = "")
{
	n (NetPreID,UpdateUser)
	s RegNo=$LG(^User.DHCPENetPreRecordD(NetPreID),2)
	s IDCard=$LG(^User.DHCPENetPreRecordD(NetPreID),6)
	s CardType=$LG(^User.DHCPENetPreRecordD(NetPreID),21)
	s:(CardType="")||(CardType="身份证") CardType="01"
	s CardTypeDr=$O(^PAC("CARD",0,"Code",CardType,""),-1)
	s PIBIDR=$O(^DHCPEPreIBI(0,"IDCard",IDCard,""),-1)
	i RegNo="" d
	.s:PIBIDR'="" RegNo=$P(^DHCPEPreIBI(PIBIDR),"^",1)
	.i RegNo="" d
	..s RegNo=##class(HS.BL.PECommon).GetRegNoByCardNo(IDCard,CardType)
	..s:RegNo'="" RegNo=$P(RegNo,"^",1) 
	i (RegNo'="")&&(PIBIDR="") 
	{
		d ##class(web.DHCPE.PreIBIUpdate).UpdatePEInfoByHis(RegNo,UpdateUser) 
		s PIBIDR=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,""),-1)
	}
	s LocID=$LG(^User.DHCPENetPreRecordD(NetPreID),17)
	s Name=$LG(^User.DHCPENetPreRecordD(NetPreID),3)
	s SexDR=$LG(^User.DHCPENetPreRecordD(NetPreID),4)
	s DOB=$LG(^User.DHCPENetPreRecordD(NetPreID),26)
	s:(PIBIDR'="")&(DOB="") DOB=$P(^DHCPEPreIBI(PIBIDR),"^",4)
	s:DOB'="" DOB=##class(websys.Conversions).DateLogicalToHtml(DOB)
	s Tel=$LG(^User.DHCPENetPreRecordD(NetPreID),19)
	s VIPDesc=$LG(^User.DHCPENetPreRecordD(NetPreID),16)
	s VIPDR=##class(web.DHCPE.VIPLevel).GetVIPIDByDesc(VIPDesc)
	s FIBIUpdateModel=##class(web.DHCPE.Public.Setting).GetPAPMINoGenModel()	
	s department = $LG(^User.DHCPENetPreRecordD(NetPreID),27)  //港大该字段存的是部门
	s employeeNo = $LG(^User.DHCPENetPreRecordD(NetPreID),28)
	b ;wgy123
	s Instring=PIBIDR_"^"_RegNo_"^"_Name_"^"_SexDR_"^"_DOB_"^1^"_Tel_"^"_Tel_"^"_Tel_"^"_IDCard_"^^"_department_"^^^^^^^^^"_UpdateUser_"^^^^^"_VIPDR_"^^"_CardTypeDr_";"_FIBIUpdateModel
	s saveRet=##class(web.DHCPE.PreIBIUpdate).Save("","",Instring)
	b ;saveRet
	q saveRet
}

/// Descripiton:网上退费
/// Input:
/// 		TransactionId:支付平台流水号
/// 		TerminalID:支付终端
/// 		RefundAmount:退款金额
///         RefundReason:退款原因
/// Return:	0^成功  非0^失败
/// Creater:	wangguoying
/// CreateDate:	2018-12-25
/// Debug:w ##class(web.DHCPE.NetPre.Pay).NetRefundJDF("1^N",'0000000057',263)
ClassMethod NetRefundJDF(TransactionId, TerminalID, RefundAmount, RefundReason)
{
	new (TransactionId, TerminalID, RefundAmount, RefundReason)
	s InvUserID="1" ;默认收费员
	s TradeOrder=##class(web.DHCPE.ScanPay.Handler.JDFHandler).GetTraOrdIDByTrsactID(TransactionId,TerminalID) ;获取支付时交易订单
	q:TradeOrder="" "-1^未检索到有效的交易流水"
	s TrdOrdAmt=$LG(^User.DHCPETradeOrderD(TradeOrder),4)
	s Chanel=$LG(^User.DHCPETradeOrderD(TradeOrder),7)
	s NetPreID=$LG(^User.DHCPETradeOrderD(TradeOrder),19)
	s OrderNo=$LG(^User.DHCPETradeOrderD(TradeOrder),10)
	///NetPayInfo:网上支付ID^APP支付订单号^支付中心订单号^终端号^扫码付Chanel
	s NetPayInfo=NetPreID_"^"_OrderNo_"^"_TransactionId_"^"_TerminalID_"^"_Chanel
	s TrdOrdAmt = $fn(TrdOrdAmt,"",2)
	q:TrdOrdAmt'=RefundAmount "-2^退款金额与实收金额不符"
	s PEInvID=$LG(^User.DHCPETradeOrderD(TradeOrder),11)
	s InvAmt=$P(^DHCPEINVPRT(PEInvID),"^",7)
	s InvAmt = $fn(InvAmt,"",2)
	q:InvAmt'=RefundAmount "-2^收费发票金额与退款金额不符"
	
	s FocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex",PEInvID,""))	
	q:FocusPrintID'="" "-2^已打印发票，请到窗口退费"
	
	s PAADM=$P(^DHCPEINVPRT(PEInvID),"^",2)
	s LocID=$p(^PAADM(PAADM),"^",4)
	s SelectIds=..GetRefundSelectIds(PEInvID)
	q:+SelectIds<0 SelectIds
	q:SelectIds="" "-3^未检索到需要退费的项目"
	q:$fn($p(SelectIds,";",2),"",2)'=RefundAmount "-4^退款金额不正确"
	s InvInfo=##class(web.DHCPE.DHCPEPAY).getcurinvno(InvUserID)
	s CurInvNo=$P(InvInfo,"^",1)_"^^1"  ;InvNo_"^^1"  需要修改其中^1是控制不打印发票的
	s invId=$P(InvInfo,"^",2)
	s peAdmType="I"
	s peAdmId=$O(^DHCPEIADM(0,"PAADM",PAADM,0))   ;DHCPEIADM
	q:peAdmId="" "-5^未登记"
	s listFlag="1"
	
	TS
	s $ZT="NetRefundErr"
	
	//网上全退  payModeInfos为空
	s ret=##class(web.DHCPE.Cashier).DropInvPrt(PEInvID,InvUserID,LocID,SelectIds,"",0,CurInvNo,invId,peAdmType,peAdmId,0,listFlag,1,"",NetPayInfo)
	i ret'="" tro  q "-99^退费失败&"_ret
	
	TC
	q "0^退费成功"
	
NetRefundErr
	s $ZT=""
	TRO
	s rtn="-100^退费失败"
	q:$ze="" rtn
	q rtn_"&"_$ze
}

/// Descripiton:根据收费发票获取退费信息
/// Input:
/// 		PEInvID:体检发票ID
/// Return:	 ,类型（1、项目 2、套餐）^DHC_PE_PreIOrdItemFee(RowID),;退费金额  或 小于0^错误信息
/// Creater:	wangguoying
/// CreateDate:	2018-12-25
/// Debug:w ##class(web.DHCPE.NetPre.Pay).GetRefundSelectIds(263)
ClassMethod GetRefundSelectIds(PEInvID)
{
	new (PEInvID)
	q:PEInvID="" ""
	q:'$D(^DHCPEINVPRT(PEInvID)) ""
	s SelectIds=""
	s Err=""
	s PBDR=$p(^DHCPEINVPRT(PEInvID),"^",3)  ;DHC_PatientBill
	s RefundAmt=0
	s PAPBRelate="" ;对照表
	f  s PAPBRelate=$O(^DHCPEPAPBR(0,"PBDR",PBDR,PAPBRelate)) q:(PAPBRelate="")||(Err'="")  d
	.s PreAudit=$P(^DHCPEPAPBR(PAPBRelate),"^",1) ;审核表 
	.s PreAuditIdStatus=$p($G(^DHCPEPreA(PreAudit)),"^",21)
	.q:PreAuditIdStatus="NU"
	.//取项目
	.s PreAdmId=""
	.f  s PreAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",PreAudit,PreAdmId)) q:(PreAdmId="")||(Err'="")  d
	..s childsub=""
	..f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",PreAudit,PreAdmId,childsub)) q:(childsub="")||(Err'="")  d
	...;i $p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1  s Err="-90^项目已执行"
	...s ItemStat=##class(web.DHCPE.ItemFeeList).GetOrdItemStatus(PreAdmId_"||"_childsub,1)
	...i ItemStat="1" s Err="90^存在已执行的项目"  q
	...s feesub=$o(^DHCPEPreIADM(0,"PAORDITEM",PreAudit,PreAdmId,childsub,""))
	...s Fee=$P($G(^DHCPEPreIADM(PreAdmId,"ORDITEM",childsub,"FEE",feesub)),"^",2)
	...s:SelectIds'="" SelectIds=SelectIds_"1^"_PreAdmId_"||"_childsub_"||"_feesub_","
	...s:SelectIds="" SelectIds=",1"_PreAdmId_"||"_childsub_"||"_feesub_","
	...s RefundAmt=RefundAmt+Fee
	
	.//取套餐
	.s PreAdmId=""
	.f  s PreAdmId=$o(^DHCPEPreIADM(0,"PAORDENT",PreAudit,PreAdmId)) q:(PreAdmId="")||(Err'="")  d
	..s childsub=""
	..f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",PreAudit,PreAdmId,childsub)) q:(childsub="")||(Err'="")  d
	...;q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
	...s EntStat=##class(web.DHCPE.ItemFeeList).GetOrdItemStatus(PreAdmId_"||"_childsub,2)
	...i EntStat="1" s Err="91^存在已执行的套餐"  q
	...s feesub=$o(^DHCPEPreIADM(0,"PAORDENT",PreAudit,PreAdmId,childsub,""))
	...s Fee=$P($G(^DHCPEPreIADM(PreAdmId,"ORDENT",childsub,"FEE",feesub)),"^",2)
	...s:SelectIds'="" SelectIds=SelectIds_"2^"_PreAdmId_"||"_childsub_"||"_feesub_","
	...s:SelectIds="" SelectIds=",2"_PreAdmId_"||"_childsub_"||"_feesub_","
	...s RefundAmt=RefundAmt+Fee
	q:SelectIds="" ""
	q SelectIds_";"_RefundAmt
}

/// Descript:淘乐思退费接口
/// Creater:	王国营
/// CreateDate:	2019-08-16
ClassMethod TLSRefund(NewInvID As %String, AbortInvID As %String, UserID)
{
	q:AbortInvID="" 0	
	s OriginInvID=$P(^DHCPEINVPRT(AbortInvID),"^",9)
	q:OriginInvID="" "-1^未检索到被退发票"
	s NetPayInfo=$G(^DHCPEDataEx("NetCashier",OriginInvID,"OrderNo"))
	q:NetPayInfo="" 0 ;第三方订单号为空时  默认不走此退费程序
	
	;不管成功失败都要记录下新发票与第三方订单的关联
	i NewInvID'=""
	{
		s ^DHCPEDataEx("NetCashier",NewInvID,"OrderNo")=$G(^DHCPEDataEx("NetCashier",OriginInvID,"OrderNo"))  ;收费员^第三方订单号^终端ID
	}
	
	
	//根据作废发票和新发票计算退费金额
	s Amount=0
	s AbortAmount=0-$P(^DHCPEINVPRT(AbortInvID),"^",7)
	s NewAmount=0
	s:NewInvID'="" NewAmount=$P(^DHCPEINVPRT(NewInvID),"^",7)
	s Amount=AbortAmount-NewAmount
	q:Amount=0 0 ;应退金额为0
	
	s $ZT="TLSRefundErr"
	s Param=..GetTLSRefundParam(OriginInvID,AbortInvID,NewInvID, Amount)
	q:Param="" "-1^未获取到有效的退费参数"
	
	s ^DHCPENetPayLog("DHCPE","Refund",AbortInvID,+$h,$P($H,",",2),"Input")=Param
	s SoapObj=##class(web.DHCPE.NetPre.SoapExt.OphiuxDataServicePort).%New()
	s Ret=SoapObj.getHaveRefund(Param)
	s ^DHCPENetPayLog("DHCPE","Refund",AbortInvID,+$h,$P($H,",",2),"Output")=Ret
	s Ret=$Replace(Ret,"<OPHIUX>","")
	s Ret=$Replace(Ret,"</OPHIUX>","")
	s RetObj=##class(web.DHCPE.NetPre.Entity.TLSRfdResponse).%New()
	d RetObj.XMLNodeDeserialize(.RetObj,"MESSAGE",Ret)
	i RetObj.RESULTCODE=100
	{
		s ^DHCPEDataEx("NetRefund",AbortInvID,"OrderNo")=RefundNo
		s ^DHCPEDataEx("NetRefund","ExtOrdNo",RetObj.REFUNDNO)=AbortInvID
	}
	q RetObj.RESULTCODE_"^"_RetObj.RESULTDESC
TLSRefundErr
	s $zt=""
	s ^DHCPENetPayLog("DHCPE","Refund",AbortInvID,+$h,$P($H,",",2),"Err")=$ZE
	q "-100"
}

/// Descript:获取淘乐思退费接口参数
/// Creater:	王国营
/// CreateDate:	2019-08-16
/// Return:
/// Debug：w ##class(web.DHCPE.NetPre.Pay).GetTLSRefundParam(21155,100.00,"",100)
ClassMethod GetTLSRefundParam(OriInvID As %String, AbortInvID As %String, NewInvID As %String, RefundFee)
{
	s PAADM=$P(^DHCPEINVPRT(OriInvID),"^",2)
	s PEIAMD=$O(^DHCPEIADM(0,"PAADM",PAADM,""))
	s PreIAMD=$P(^DHCPEIADM(PEIAMD),"^",4)
	s PIBI=$P(^DHCPEPreIADM(PreIAMD),"^",1)
	s PatName=$P(^DHCPEPreIBI(PIBI),"^",2)
	s IDCard=$P(^DHCPEPreIBI(PIBI),"^",9)
	s ParaObj=##class(web.DHCPE.NetPre.Entity.TLSRefundPara).%New()
	s ParaObj.HOSPITALCODE="001"
	s ParaObj.IDCARDNUMBER=IDCard
	s ParaObj.NAME=PatName
	s ParaObj.RECIPETID=AbortInvID
	s ParaObj.REFUNDTYPE=7
	s ExtOrderNo=$P(^DHCPEDataEx("NetCashier",OriInvID,"OrderNo"),"^",2)
	s:NewInvID'="" ExtOrderNo=ExtOrderNo_"_"_AbortInvID
	s ParaObj.FLOWNO=_ExtOrderNo
	s ParaObj.APPLYTIME=$ZD($P(^DHCPEDataEx("NetCashier",OriInvID,"OrderNo"),"^",4),3)
	s ParaObj.REFUND=RefundFee*100
	s ParaObj.REFUNDREASON="HIS主动退费"
	s sc=ParaObj.XMLExportToString(.XML,"PARAM")
	q "<OPHIUX><HEAD><USER_NAME>cyfy</USER_NAME><USER_PWD>123456</USER_PWD><TOKEN>c20161010141946</TOKEN><R_FORM>XML</R_FORM></HEAD>"_XML_"</OPHIUX>"
}

/// Descript:获取顺能退费接口参数
/// Creater:	王国营
/// CreateDate:	2019-04-04
/// Input: 
/// 					AbortInvID:退费发票ID
/// 					NewInvID：新发票ID
/// 					UserID:操作员
/// 						RefundFee:退费金额
/// Return:
/// Debug：w ##class(web.DHCPE.NetPre.Pay).GetSNRefundParam(21155,100.00,"",100)
ClassMethod GetSNRefundParam(NewInvID As %String, AbortInvID As %String, UserID, RefundFee)
{
	s OriginInvID=$P(^DHCPEINVPRT(AbortInvID),"^",9)
	q:OriginInvID="" ""
	s NetPayInfo=$G(^DHCPEDataEx("NetCashier",OriginInvID,"OrderNo"))
	q:NetPayInfo="" ""
	s RefundNo=$P(NetPayInfo,"^",2)
	s exTradeNo=$P(NetPayInfo,"^",4)
	s PayType=$P(NetPayInfo,"^",5)
	s BiType=5  ;5代表体检
	s Remark="HIS主动发起退款"
	
	s PAADM=$P(^DHCPEINVPRT(OriginInvID),"^",2)
	s LocID=$P(^PAADM(PAADM),"^",4)
	s HOSPID=$P(^CTLOC(LocID),"^",22)
	s PatID=$P(^PAADM(PAADM),"^",1)
	s RegNo=$P(^PAPER(PatID,"PAT",1),"^",1)
	s PatName=$P(^PAPER(PatID,"ALL"),"^",1)
	s SNRefundParam=##class(web.DHCPE.NetPre.Entity.SNRefundParam).%New()
	s SNRefundParam.PayType=PayType
	s SNRefundParam.BizType=BiType
	s SNRefundParam.RefundFee="0.01"   ;RefundFee
	s SNRefundParam.RefundTradeNo=RefundNo
	s SNRefundParam.StreamNo=exTradeNo
	s SNRefundParam.Remark=Remark
	s SNRefundParam.CardNo=RegNo
	s SNRefundParam.PatName=PatName
	s SNRefundParam.HisTradeNo=OriginInvID
	s SNRefundParam.OperatorId=UserID
	s SNRefundParam.RefundAccount=1
	s SNRefundParam.hosArea=##class(HS.BL.PECommon).HOSPRelate(HOSPID,"H2S")
	s sc=SNRefundParam.XMLExportToString(.ParamXml,"Request")
	i $$$ISERR(sc)  q ""
	q ParamXml
}

/// Descript:调用顺能退费接口
/// Creater:	王国营
/// CreateDate:	2019-04-04
/// Input: 
/// 					AbortInvID:退费发票ID
/// 					NewInvID：新发票ID
/// 					UserID:操作员
/// Return:0  成功  非0 失败  
/// Debug：w ##class(web.DHCPE.NetPre.Pay).SNRefund("",59898,8021)
ClassMethod SNRefund(NewInvID As %String, AbortInvID As %String, UserID)
{
	
	q:AbortInvID="" 0	
	s OriginInvID=$P(^DHCPEINVPRT(AbortInvID),"^",9)
	q:OriginInvID="" "-1^未检索到被退发票"
	s NetPayInfo=$G(^DHCPEDataEx("NetCashier",OriginInvID,"OrderNo"))
	q:NetPayInfo="" 0 ;第三方订单号为空时  默认不走此退费程序
	
	;不管成功失败都要记录下新发票与第三方订单的关联
	i NewInvID'=""
	{
		s ^DHCPEDataEx("NetCashier",NewInvID,"OrderNo")=$G(^DHCPEDataEx("NetCashier",OriginInvID,"OrderNo"))  ;收费员^第三方订单号^终端ID
	}
	
	
	//根据作废发票和新发票计算退费金额
	s Amount=0
	s AbortAmount=0-$P(^DHCPEINVPRT(AbortInvID),"^",7)
	s NewAmount=0
	s:NewInvID'="" NewAmount=$P(^DHCPEINVPRT(NewInvID),"^",7)
	s Amount=AbortAmount-NewAmount
	q:Amount=0 0 ;应退金额为0
	
	s $ZT="SNRefundErr"
	s Param=..GetSNRefundParam(NewAmount, AbortInvID, UserID,Amount)
	q:Param="" "-1^未获取到有效的退费参数"
	s Soap=##class(web.DHCPE.NetPay.Soap.MicroWebserviceImplPort).%New()
	s ^DHCPENetPayLog("DHCPE","Refund",AbortInvID,+$h,$P($H,",",2),"Input")=Param
	s Ret=Soap.methodInvoke("hisActiveRefund",Param)   ;调用顺能接口
	s ^DHCPENetPayLog("DHCPE","Refund",AbortInvID,+$h,$P($H,",",2),"Output")=Ret
	s RetObj=##class(web.DHCPE.NetPre.Entity.SNRefundRet).%New()
	d RetObj.XMLNodeDeserialize(.RetObj,"Response",Ret)
	i RetObj.ResultCode=0
	{
		s ^DHCPEDataEx("NetRefund",AbortInvID,"OrderNo")=RetObj.RefundNo
		s ^DHCPEDataEx("NetRefund","ExtOrdNo",RetObj.RefundNo)=AbortInvID
	}
	q RetObj.ResultCode
SNRefundErr
	s $zt=""
	s ^DHCPENetPayLog("DHCPE","Refund",AbortInvID,+$h,$P($H,",",2),"Err")=$ZE
	q "-100"
}

/// Descript:调用远途退费接口
/// Creater:	王国营
/// CreateDate:	2020-12-25
/// Input: 
/// 					AbortInvID:退费发票ID
/// 					NewInvID：新发票ID
/// 					UserID:操作员
/// Return:0  成功  非0 失败  
/// Debug：w ##class(web.DHCPE.NetPre.Pay).SNRefund("",59898,8021)
ClassMethod YTRefundWebService(NewInvID As %String, AbortInvID As %String, UserID)
{
	
	q:AbortInvID="" 0	
	s OriginInvID=$P(^DHCPEINVPRT(AbortInvID),"^",9)
	q:OriginInvID="" "-1^未检索到被退发票"
	s NetPayInfo=$G(^DHCPEDataEx("NetCashier",OriginInvID,"OrderNo"))
	q:NetPayInfo="" 0 ;第三方订单号为空时  默认不走此退费程序
	
	s TermianID=$P(NetPayInfo,"^",3)
	q:TermianID'="ZZJ" 0 ;非远途自助机
	
	;不管成功失败都要记录下新发票与第三方订单的关联
	i NewInvID'=""
	{
		s ^DHCPEDataEx("NetCashier",NewInvID,"OrderNo")=$G(^DHCPEDataEx("NetCashier",OriginInvID,"OrderNo"))  ;收费员^第三方订单号^终端ID
	}
	
	
	//根据作废发票和新发票计算退费金额
	s Amount=0
	s AbortAmount=0-$P(^DHCPEINVPRT(AbortInvID),"^",7)
	s NewAmount=0
	s:NewInvID'="" NewAmount=$P(^DHCPEINVPRT(NewInvID),"^",7)
	s Amount=AbortAmount-NewAmount
	q:Amount=0 0 ;应退金额为0
	
	s $ZT="YTWsRefundErr"
	s InputObj=##class(web.DHCPE.NetPre.Entity.YTRefundParam).%New()
	s InputObj.outTradeNo=$P(NetPayInfo,"^",2)
	s InputObj.outRefundNo=AbortInvID
	s InputObj.fee=Amount
	s InputObj.reason="HIS主动退款"
	s InputObj.outPayNo=AbortInvID
	s InputObj.element=$P(NetPayInfo,"^",4)
	s InputObj.tradeMode=$P(NetPayInfo,"^",5)
	s sc=InputObj.XMLExportToString(.InuputXML,"Request")
	i $$$ISERR(sc)
	{
		q "-100^"_$System.Status.GetErrorText(sc)
	}
	s Soap=##class(web.DHCPE.NetPay.Soap.MicroWebserviceImplPort).%New()   //需要远途提供webservice
	s ^DHCPENetPayLog("DHCPE","Refund",AbortInvID,+$h,$P($H,",",2),"Input")=Param
	s Ret=Soap.methodInvoke("hisActiveRefund",Param)   ;调用远途接口
	s ^DHCPENetPayLog("DHCPE","Refund",AbortInvID,+$h,$P($H,",",2),"Output")=Ret
	s RetObj=##class(web.DHCPE.NetPre.Entity.YTRefundRet).%New()
	d RetObj.XMLNodeDeserialize(.RetObj,"Response",Ret)
	i RetObj.ResultCode=0
	{
		s ^DHCPEDataEx("NetRefund",AbortInvID,"OrderNo")=RetObj.RefundNo
		s ^DHCPEDataEx("NetRefund","ExtOrdNo",RetObj.RefundNo)=AbortInvID
	}
	q RetObj.ResultCode
YTWsRefundErr
	s $zt=""
	s ^DHCPENetPayLog("DHCPE","Refund",AbortInvID,+$h,$P($H,",",2),"Err")=$ZE
	q "-100"
}

/// Descript:调用远途退费接口
/// Creater:	王国营
/// CreateDate:	2020-12-25
/// Input: 
/// 					AbortInvID:退费发票ID
/// 					NewInvID：新发票ID
/// 					UserID:操作员
/// Return:0  成功  非0 失败  
/// Debug：w ##class(web.DHCPE.NetPre.Pay).SNRefund("",59898,8021)
ClassMethod YTRefund(NewInvID As %String, AbortInvID As %String, UserID)
{
	
	q:AbortInvID="" 0	
	s OriginInvID=$P(^DHCPEINVPRT(AbortInvID),"^",9)
	q:OriginInvID="" "-1^未检索到被退发票"
	s NetPayInfo=$G(^DHCPEDataEx("NetCashier",OriginInvID,"OrderNo"))
	q:NetPayInfo="" 0 ;第三方订单号为空时  默认不走此退费程序
	
	s TermianID=$P(NetPayInfo,"^",3)
	q:TermianID'="ZZJ" 0 ;非远途自助机
	
	;不管成功失败都要记录下新发票与第三方订单的关联
	i NewInvID'=""
	{
		s ^DHCPEDataEx("NetCashier",NewInvID,"OrderNo")=$G(^DHCPEDataEx("NetCashier",OriginInvID,"OrderNo"))  ;收费员^第三方订单号^终端ID
	}
	
	
	//根据作废发票和新发票计算退费金额
	s Amount=0
	s AbortAmount=0-$P(^DHCPEINVPRT(AbortInvID),"^",7)
	s NewAmount=0
	s:NewInvID'="" NewAmount=$P(^DHCPEINVPRT(NewInvID),"^",7)
	s Amount=AbortAmount-NewAmount
	q:Amount=0 0 ;应退金额为0
	
	s $ZT="YTRefundErr"
	s InputObj=##class(%ArrayOfDataTypes).%New()
	d InputObj.SetAt($P(NetPayInfo,"^",2),"outTradeNo")
	d InputObj.SetAt(AbortInvID,"outRefundNo")
	d InputObj.SetAt(Amount,"fee")
	d InputObj.SetAt("HIS主动退款","reason")
	d InputObj.SetAt(AbortInvID,"outPayNo")
	d InputObj.SetAt($P(NetPayInfo,"^",4),"element")
	d InputObj.SetAt($P(NetPayInfo,"^",5),"tradeMode")
	s InputJson=##class(ext.util.JsonObject).ObjToJson(InputObj)
	s ^DHCPENetPayLog("DHCPE","Refund",AbortInvID,+$h,$P($H,",",2),"Input")=InputJson
	Set httpRequest=##class(%Net.HttpRequest).%New()		
	Set httpRequest.Server="10.17.100.210"
	Set httpRequest.Port="8072"
	Set httpRequest.Timeout=5 ;超过5秒即为不可访问
	
	Set ParamXML=$zcvt("params={"_InputJson_"}","O","UTF8")
	s sc=httpRequest.EntityBody.Write(ParamXML)
	s reqPath="/frontgateway/gateway.do"
	Set flg=httpRequest.Post(reqPath)	
	if $system.Status.IsError(flg)
	{
		q -100_"^"_$system.Status.GetErrorText(flg)
	}
	Set Ret=httpRequest.HttpResponse.Data
	s ^DHCPENetPayLog("DHCPE","Refund",AbortInvID,+$h,$P($H,",",2),"Output")=Ret
	s RetObj={}.%FromJSON(Ret)
	i RetObj.ResultCode=0
	{
		s ^DHCPEDataEx("NetRefund",AbortInvID,"OrderNo")=RetObj.RefundNo
		s ^DHCPEDataEx("NetRefund","ExtOrdNo",RetObj.RefundNo)=AbortInvID
	}
	q RetObj.ResultCode
YTRefundErr
	s $zt=""
	s ^DHCPENetPayLog("DHCPE","Refund",AbortInvID,+$h,$P($H,",",2),"Err")=$ZE
	q "-100"
}

/// Descript:生成支付二维码Url（易联众易惠支付）
/// Creater:	王国营
/// CreateDate:	2019-09-25
/// Input: 
/// 					EpisodeID：PA_Adm
/// Return:支付二维码Url
/// Debug：w ##class(web.DHCPE.NetPre.Pay).BuildQrCodeInfo(10097)
ClassMethod BuildQrCodeInfo(EpisodeID)
{
	set IADM=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
	Quit:IADM="" ""
	set PreIADM=$P(^DHCPEIADM(IADM),"^",4)
	set CardNo=""
	set PatDr=$P(^PAADM(EpisodeID),"^")
	set RegNo=$p(^PAPER(PatDr,"PAT",1),"^",1)
	set CardNo=$p(^PAPER(PatDr,"PAT",1),"^",2)	
	
	set TradeInputObj=##class(web.DHCPE.NetPre.Entity.tsinput).%New()
	set parmObj=##class(web.DHCPE.NetPre.Entity.inputinfo).%New()	
	set Appsecret="1CVQFSFOK0190100007F0000270D44CF"   //约定的密文，项目上确定
	set Appid="1CVQFSF5N00Q0100007F0000268C4A86"	 //支付平台的APAPID
	set Appidstr=$e(Appid,1,16)    //截取appId前16位作为AES密钥
	set PYL="0102030405060708"    //约定的密钥偏移量
	set appkey=##class(%SYSTEM.Encryption).AESCBCEncrypt(Appsecret,Appidstr,PYL) // CBC加密链块模式  AES加密算法
	set appkey = ##class(web.Util.Encryption).Byte2Hex(appkey)   //转16进制
	set TradeInputObj.cardNo=CardNo
	set parmObj.admId=PreIADM
	set parmObj.regNo=RegNo
	set Stream =##class(%GlobalCharacterStream).%New()
	do ##class(ext.util.JsonObject).ObjectToJSONStream(parmObj,.Stream)
	set parmstr=Stream.Read()
	set TradeInputObj.extra=parmstr
	
	do ##class(ext.util.JsonObject).ObjectToJSONStream(TradeInputObj,.Stream)
	set str=Stream.Read()
	b ; str
	set appkey=$e(appkey,1,16)   //再取加密内容的前16位作为秘钥
	set rtnstr=##class(%SYSTEM.Encryption).AESCBCEncrypt(str,appkey,PYL)	
	set aesdata = ##class(web.Util.Encryption).Byte2Hex(rtnstr)
	set onepayUrl = "http://xmxa.ylzpay.com:8060/onepay-web"
    set urlstr = onepayUrl_"/h5/noOpenIdPay?appId="_Appid_"&aesdata="_aesdata
	
	q urlstr
}

/// Description:预结算
/// Input: 
/// 					PayID：	DHC_PE_NetPreRecord||N    或  DHC_PE_PreIADM||P  或 PA_Adm||A
/// 					RegNo：		登记号
/// 					PayAmount:	支付金额
/// 					PayMode:    支付方式ID
/// 						UserID:		收费员ID 
/// 					ExtStr：    拓展串：备用
/// 					Flag:		网上预约是否绑定了登记号 
/// Return:
/// Creater:	王国营
/// CreateDate:	2020-09-23
/// Debug：w ##class(web.DHCPE.NetPre.Pay).PretreatmentPay(10097)
ClassMethod PretreatmentPay(PayID, RegNo, PayAmount, PayMode, UserID, ExtStr, Flag = "1")
{
	q:PayID="" "-1^支付ID不能为空"
	s Type=$P(PayID,"||",2)
	s:Type="" Type="P"
	
	s AccNo=""
	s PayCode=$P(^CT("CTPM",PayMode),"^",1)
    i PayCode="CPP"{
        s AccNo=..GetAccNo(RegNo)
        q:AccNo="" "-1^没有门诊账户，不能使用门诊账户结算"
        s AccAmt=$P(^DHCACD("AccM",AccNo),"^",8)
        q:(+AccAmt<PayAmount) "-1^账户余额不足，余额为:"_AccAmt
    }

	s PayID=$P(PayID,"||",1)
	i Type="N" //网上预约
	{
	 	s NetRegNo=$LG(^User.DHCPENetPreRecordD(PayID),2)
		q:(Flag="1")&&(NetRegNo="")&&(RegNo="") "-1^登记号不能为空"
		s:(NetRegNo'="")&&(RegNo="") RegNo=NetRegNo
		s:(RegNo'="")&&(NetRegNo="") NetRegNo=RegNo
		q:(NetRegNo'="")&&(RegNo'=NetRegNo) "-1^预约记录对应的登记号和传入登记号不一致"
		s PatID=""
		s:NetRegNo'="" PatID=$O(^PAPERi("PAPMI_PatNo",NetRegNo,0))
		q:(NetRegNo'="")&&(PatID="") "-1^登记号不存在" 
		s PreID=$LG(^User.DHCPENetPreRecordD(PayID),13)
	}
	elseif Type="A" //paadm
	{
		s IADM=$O(^DHCPEIADM(0,"PAADM",PayID,0))
		q:IADM="" "-1^预约记录不存在"
		s PatID=$P(^PAADM(PayID),"^",1)
		s NetRegNo=$P(^PAPER(PatID,"PAT",1),"^",1)
		;q:(NetRegNo="")&&(RegNo="") "-1^登记号不能为空"
		q:RegNo'=NetRegNo "-1^预约记录对应的登记号和传入登记号不一致"
		s PreID=$P(^DHCPEIADM(IADM),"^",4)
	}
	elseif Type="P"  //DHC_PE_PreIADM
	{
		s PreID=PayID
	}
	
	s $ZT="YJSErr"
	TStart
	
	//插入his预约记录、套餐
	i PreID=""  //网上预约不插入HIS时走这里，下面的项目和套餐需要更新
	{
	}
	s LocID=$P(^DHCPEPreIADM(PreID),"^",26)
	s peAdmId=$O(^DHCPEIADM(0,"CRMADM",PreID,0))   ;DHCPEIADM
    s paadm=$P(^DHCPEIADM(peAdmId),"^",1)
	s PatID=$P(^PAADM(paadm),"^",1)
    s HospID=$P(^CTLOC(LocID),"^",22)
	
	
	
	s Status=$P(^DHCPEPreIADM(PreID),"^",8)
	i Status="CANCELPE" tro  q "-1^his已经取消体检"
	//his登记
	i (Status="PREREG")||(Status="PREREGED")
	{
		s ret=##class(web.DHCPE.DHCPEIAdm).UpdateIADMInfo(PreID, "2","",UserID)  ;需要添加(修改)此方法，有可能其中一些用到用户的地方也需要修改
		i ret'="0"  tro  q "-1^his登记错误"
	}
	//his结算
	b ;PreID
	s AuditInfo=..GetNoPayedAudit(PreID)
	s PreAuditIDs=$P(AuditInfo,"^",1)
	s AuditAmt=$P(AuditInfo,"^",2)
	i PreAuditIDs=""  tro  q "-1^没有待收费的记录"
	i +AuditAmt'=+PayAmount tro  q "-1^传入金额和his金额不一致"
	s PayModeInfo=PayMode_","_PayAmount_"#"_AccNo    ;需要设置支付宝支付方式id
	s InvInfo=##class(web.DHCPE.DHCPEPAY).getcurinvno(UserID)
	s CurInvNo=$P(InvInfo,"^",1)_"^^1"  ;InvNo_"^^1"  需要修改其中^1是控制不打印发票的
	s invId=$P(InvInfo,"^",2)
	s peAdmType="I"
	s listFlag="1"
	
	/*预结算程序*/
	s ret=##class(web.DHCPE.Cashier).Cashier("","",PreAuditIDs,"",PayAmount,PayModeInfo,UserID,LocID,CurInvNo,invId,peAdmType,peAdmId,listFlag,1,HospID)
	s Flag=$P(ret,"^",1)
	s InvID=$P(ret,"^",3)
	i Flag'="" tro  q "-1^"_ret
	
	TC
	q "0^"_InvID
YJSErr
	s $ZT=""
	Tro
	s ErrDesc="预结算失败"
	s:$ZE'="" ErrDesc=$ZE
	s ^DHCPENetPayErr("YJS",PayID_"||"_Type,+$H,$P($H,",",2))=ErrDesc
	q "-100^"_ErrDesc
}

/// Description:真正结算
/// Input: 
/// 					InvID：			DHC_PE_INVPRT
/// 					InvUserID:		收费员ID 
/// 					PayAmount:		支付金额
/// 					ExtStr：    	第三方订单号^终端ID
/// Return:
/// Creater:	王国营
/// CreateDate:	2020-09-23
/// Debug：w ##class(web.DHCPE.NetPre.Pay).PretreatmentPay(10097)
ClassMethod RealPay(InvID, InvUserID, PayAmount, ExtStr)
{
	TStart
	s $ZT="RealErr"
	s ret=##class(web.DHCPE.Cashier).RealCashier(InvID,InvUserID,"^^1")
	s Flag=$P(ret,"^",1)
	i Flag'="" tro  q "-1^"_ret
	
	s hisOrderNo=""
	/**
	调用计费组方法  插入交易明细
    UserID收费员ID^Grup安全组^GLoc默认登录科室^HospDR院区ID^TerminalID^TradeType交易类型(OP,IP,DEP,PRE,CARD,INSU)^PatientID患者主索引
   
    s paadm=$P(^DHCPEINVPRT(InvID),"^",2)
	s PatID=$P(^PAADM(paadm),"^",1)
    s LocID=$P(^PAADM(paadm),"^",4)
    s HospID=$P(^CTLOC(LocID),"^",22)
    s GroupID=165
    s TermianlID=$P(ExtStr,"^",2)
    s hisStr=InvUserID_"^"_GroupID_"^"_LocID_"^"_HospID_"^"_TermianlID_"^PE^"_PatID
    s hisTradRet=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SetHISTradeNo("",paadm,"","C",PayAmount,hisStr)
    i $p(hisTradRet,"^",1)'=0  tro  q "-201^生成HIS流水号失败"
	s hisOrderNo=$p(hisTradRet,"^",3)
    s hisCode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(hisOrderNo,$P(ret,"^",5),.PayDetailsObj,hisStr)
	i hisCode'=0  tro  q "-202^保存交易信息失败！"_hisCode
	 **/
	 
	 	
	s ^DHCPEDataEx("NetCashier",InvID,"OrderNo")=InvUserID_"^"_hisOrderNo_"^"_+$H_"^"_$P($H,",",2)_"^"_ExtStr  ;收费员^第三方订单号^终端ID
	s ^DHCPEDataEx("NetCashier","ExtOrdNo",$P(ExtStr,"^",1))=InvID
	TC
	q 0
RealErr
	s $ZT=""
	Tro
	s ErrDesc="结算失败"
	s:$ZE'="" ErrDesc=$ZE
	s ^DHCPENetPayErr("Real",InvID,+$H,$P($H,",",2))=ErrDesc
	q "-100^"_ErrDesc
}

/// Descript:将团体网上预约信息同步至体检登记状态
/// Creater:	王国营
/// CreateDate:	2020-10-09
/// Input:
/// 				NetPreID：	DHC_PE_NetPreRecord
/// 				
/// Return:0  成功  非0 失败   
/// w ##class(web.DHCPE.NetPre.Pay).TransGroupNetToRegister(1)
ClassMethod TransGroupNetToRegister(NetPreID, ExtGObj As HS.Entity.ExtGroupInfo, OPUser = "")
{
	new (NetPreID,ExtGObj,OPUser)
	s isCanTrans=..IsCanTransToHis(NetPreID)
	q:isCanTrans'=0 isCanTrans
	s NetRegNo=$lg(^User.DHCPENetPreRecordD(NetPreID),2)
	s idCard=$lg(^User.DHCPENetPreRecordD(NetPreID),6)
	s VIPDesc=$lg(^User.DHCPENetPreRecordD(NetPreID),16)
	s CardType=$lg(^User.DHCPENetPreRecordD(NetPreID),21)
	s SynFlag=0 ;网上信息是否同步至HIS标记
	S $ZT="ErrGroupHandle"
	TS
	i NetRegNo="" 
	{
		s RegNoErr=""
		s NetRegNo=##class(HS.BL.PECommon).GetRegNoByCardNo(idCard,CardType)
		i NetRegNo'="" d
		.s NetRegNo=$P(NetRegNo,"^",1)
		e  d
		.s synRet=..SynBaseInfoByNetRecord(NetPreID,OPUser)
		.i +synRet'=0 d
		..s RegNoErr="-1^同步网上基本信息失败"
		.e  d
		..s SynFlag=1
		..s NetRegNo=$P(synRet,"^",3)	
		i RegNoErr'="" tro  q RegNoErr 
		;更新网上预约记录表的登记号  和评估人员基本信息表的登记号
		&sql(Update sqluser.DHC_PE_NetPreRecord set NPR_RegNo=:NetRegNo where ID=:NetPreID)
		i SQLCODE'=0 tro  q "-5^更新网上预约登记号失败"
		s OevaluationDR=$lg(^User.DHCPENetPreRecordD(NetPreID),14)
		i OevaluationDR'="" d
		.s OBaseDR=$LG(^User.DHCHMOEvaluationRecordD(OevaluationDR),10)
		.&sql(update sqluser.DHC_HM_OBaseInfo set BIPAPMINo=:NetRegNo where ID=:OBaseDR)
		.s:SQLCODE'=0 RegNoErr="-8^更新评估记录失败"
		i RegNoErr'="" tro  q RegNoErr 
	}
	s PreIBaseID=$O(^DHCPEPreIBI(0,"PAPMINo",NetRegNo,0))
	i PreIBaseID="" d
	.d ##class(web.DHCPE.PreIBIUpdate).UpdatePEInfoByHis(NetRegNo,OPUser)   ;需要修改源方法,增加一个用户的参数
	.s PreIBaseID=$O(^DHCPEPreIBI(0,"PAPMINo",NetRegNo,0))
	i PreIBaseID="" tro   q "-2^插入体检基本信息表错误"
	i SynFlag=0 
	{
		s TelphoneNo=$LG(^User.DHCPENetPreRecordD(NetPreID),19)
		s Department=$LG(^User.DHCPENetPreRecordD(NetPreID),27)
		s EmployeeNo=$LG(^User.DHCPENetPreRecordD(NetPreID),28)
		i (TelphoneNo'="")||(Department'="")||(EmployeeNo'="")
		{
			k IBFLIST
			i TelphoneNo'=""  d
			.s IBFLIST(7)=TelphoneNo  //tel1
			.s IBFLIST(8)=TelphoneNo  //tel2
			.s IBFLIST(9)=TelphoneNo  //mobile
			i Department'=""  d
			.s IBFLIST(12)=Department  //
			i EmployeeNo'=""  d
			.s IBFLIST(22)=EmployeeNo
			&sql(update sqluser.DHC_PE_PreIBaseInfo values :IBFLIST() where PIBI_RowId=:PreIBaseID)
		}
	}
	s PreID=$LG(^User.DHCPENetPreRecordD(NetPreID),13)
	s LocID=$LG(^User.DHCPENetPreRecordD(NetPreID),17)
	i PreID=""
	{
		s teamId=..GetExtGroupTeam(ExtGObj,OPUser,LocID,VIPDesc)
		i +teamId'=0 tro  q teamId
		s teamId=$P(teamId,"^",2)
		s insertTeamRet=##Class(web.DHCPE.PreIADM).InsertIADMInGTeam(PreIBaseID,+teamId,teamId,"",NetPreID,OPUser,LocID)
		i (insertTeamRet'="")&&($p(insertTeamRet,"^",1)'=0) s rtn="-2^插入预约记录失败"_insertTeamRet tro  q rtn 
		s PreID=$p(insertTeamRet,"^",2)
		s InsertItemRet=..InserNetItem(NetPreID,OPUser)
		i +InsertItemRet'=0 tro  q InsertItemRet
		
		s ^DHCPEDataEx("OnlinePre",PreID) = 1 //记录该预约是从线上预约过来的	
	}
	s Status=$P(^DHCPEPreIADM(PreID),"^",8)
	i Status="CANCELPE" tro  q "-5^his已经取消体检"
	
	i (Status="PREREG")||(Status="PREREGED")
	{
		s ret=##class(web.DHCPE.DHCPEIAdm).UpdateIADMInfo(PreID, "2","",OPUser)  ;需要添加(修改)此方法，有可能其中一些用到用户的地方也需要修改
		b ;登记  ret
		i ret'="0" tro  q "-6^his登记错误"_ret
	}
	Tc
	q 0
ErrGroupHandle
	s $ZT=""
	TRO
	s rtn="-100^同步网上预约记录失败："_$ZE	
	q rtn
}

/// Description:创建团体及分组记录
/// Input:   
/// 				ExtGObj As HS.Entity.ExtGroupInfo
/// Return:		0^分组ID  DHC_PE_PreGTeam  非0 ^错误信息
/// Creater:	wangguoying
/// CreateDate:	2020-10-12
/// Debug: w ##class(web.DHCPE.NetPre.Pay).GetGroupTeam(1)
ClassMethod GetExtGroupTeam(ExtGObj As HS.Entity.ExtGroupInfo, UserID = "", LocID = "", VIPDesc = "")
{
	s ExtGObj.ExtGAsCharged="Y"
	s vipLevel=$G(^DHCPEVIPLevel("VIPapprove"))
	i VIPDesc'=""
	{
		s vipLevel=##class(web.DHCPE.VIPLevel).GetVIPIDByDesc(VIPDesc)
	}
	;先判断分组是否存在
	s teamId=$G(^DHCPEDataEx("PreTeamID","ExtToHIS",ExtGObj.ExtGBaseId_"-"_ExtGObj.ExtGid_"-"_ExtGObj.ExtTeamId))
	q:teamId'="" 0_"^"_teamId
	s err=""
	;再判断团体预约记录是否存在
	s gid=$G(^DHCPEDataEx("PreGID","ExtToHIS",ExtGObj.ExtGBaseId_"-"_ExtGObj.ExtGid))
	i gid="" d
	.s gBaseId=$G(^DHCPEDataEx("BaseGID","ExtToHIS",ExtGObj.ExtGBaseId))
	.i gBaseId="" d
	..;创建团体基本信息
	..s param=gBaseId_"^"_ExtGObj.ExtGBaseCode_"^"_ExtGObj.ExtGDesc_"^"_ExtGObj.ExtGAdress_"^"_ExtGObj.ExtGPostalcode  ;1-5
	..s bank="",account="",email="",fax="",gRegNo="",rebate="",cardNo=""
	..s param=param_"^"_ExtGObj.ExtGLinkman1_"^"_bank_"^"_account_"^"_ExtGObj.ExtGTel1_"^"_ExtGObj.ExtGTel2 ;6-10
	..s param=param_"^"_email_"^"_ExtGObj.ExtGLinkman2_"^"_fax_"^"_gRegNo_"^"_rebate_"^"_cardNo 	;11-16
	..s createRet=##class(web.DHCPE.PreGBaseInfo).Save("","",param)
	..b ;createRet
	..i $P(createRet,"^",1)'=0 s err="-1^创建团体失败:"_createRet	q
	..s gBaseId=$P(createRet,"^",2)
	..s ^DHCPEDataEx("BaseGID","ExtToHIS",ExtGObj.ExtGBaseId)=gBaseId
	..s ^DHCPEDataEx("BaseGID","HISToExt",gBaseId)=ExtGObj.ExtGBaseId
	.q:err'=""
	.;创建团体预约记录
	.s inString=gid_"^"_gBaseId_"^"_ExtGObj.ExtGBeginDate_"^"_ExtGObj.ExtGEndDate_"^"_$ZT($P($h,",",2))	;1-5
	.s deskClerkDR="",staus="",addOrdItem="N",addOrdItemLimit="N",addOrdItemAmt="",addPhcItem="N",addPhcItemLimit="N",addPhcItemAmt=""
	.s gReportSend="AC"  ;团体报告领取方式 AC：挂账可取 DC：结账取
	.s iReportSend="IS"	 ;个人报告领取方式 IS：自取 GS：统取
	.s dischargeMode="GD" ;结算方式 GD：统结 ID：自结 
	.s delayDate="",remark="",sales="",type="",reportDate="",reportTime="",payType="",percent="",dietFlag="Y",giftFlag="N",patFeeType=$P($G(^DHCPEVIPLevel("VIP",vipLevel)),"^",7),contract=""
	.s inString=inString_"^"_deskClerkDR_"^"_staus_"^"_ExtGObj.ExtGAsCharged_"^"_addOrdItem_"^"_addOrdItemLimit	;6-10
	.s inString=inString_"^"_addOrdItemAmt_"^"_addPhcItem_"^"_addPhcItemLimit_"^"_addPhcItemAmt_"^"_gReportSend	;11-15
	.s inString=inString_"^"_iReportSend_"^"_dischargeMode_"^"_delayDate_"^"_remark_"^"_sales  ;16-20
	.s inString=inString_"^"_type_"^"_reportDate_"^"_reportTime_"^"_payType_"^"_percent	;21-25
	.s inString=inString_"^"_dietFlag_"^"_giftFlag_"^"_patFeeType_"^"_contract	;26-29
	.s createRet=##class(web.DHCPE.PreGADM).Save2("","",inString,UserID,LocID)
	.i $p(createRet,"^",1)'=0  s err="-1^创建团体预约记录失败:"_createRet q
	.s gid=$p(createRet,"^",2)
	.s ^DHCPEDataEx("PreGID","ExtToHIS",ExtGObj.ExtGBaseId_"-"_ExtGObj.ExtGid)=gid
	.s ^DHCPEDataEx("PreGID","HISToExt",gid)=ExtGObj.ExtGBaseId_"-"_ExtGObj.ExtGid
	q:err'="" err
	;创建分组
	s teamSub="",teamTime="",deskClerkDR="",addOrdItem="N",addOrdItemLimit="N",addOrdItemAmt="",addPhcItem="N",addPhcItemLimit="N",addPhcItemAmt=""
	s sexLimit="N",ageMax="",ageMin="",marriedLimit="N"
	s vipLevel=$G(^DHCPEVIPLevel("VIPapprove"))
	i VIPDesc'=""
	{
		s vipLevel=##class(web.DHCPE.VIPLevel).GetVIPIDByDesc(VIPDesc)
	}
	s teamLevel="",patFeeType="",noIncloudGrp=""
	s dischargeMode="GD" ;结算方式 GD：统结 ID：自结 
	s harmInfo="",OMEtype="",roomPlace=""
	s dataStr=gid_"^"_teamId_"^"_teamSub_"^"_ExtGObj.ExtTeamDesc_"^"_ExtGObj.ExtGBeginDate ;1-5
	s dataStr=dataStr_"^"_ExtGObj.ExtGEndDate_"^"_teamTime_"^"_deskClerkDR_"^"_addOrdItem_"^"_addOrdItemLimit	;6-10
	s dataStr=dataStr_"^"_addOrdItemAmt_"^"_addPhcItem_"^"_addPhcItemLimit_"^"_addPhcItemAmt_"^"_sexLimit	;11-15
	s dataStr=dataStr_"^"_ageMax_"^"_ageMin_"^"_marriedLimit_"^"_vipLevel_"^"_teamLevel	;16-20
	s dataStr=dataStr_"^"_patFeeType_"^"_noIncloudGrp_"^"_dischargeMode_"^"_harmInfo_"^"_OMEtype ;21-25
	s dataStr=dataStr_"^"_roomPlace ;26
	s createRet=##class(web.DHCPE.PreGTeam).Save2("","",dataStr)
	i createRet'=0 q "-1^创建分组失败:"_createRet
	s sub=""
	f  s sub=$O(^DHCPEPreGADM(gid,"Team",sub)) q:(sub="")||(teamSub'="")  d
	.s curTeamDesc=$P(^DHCPEPreGADM(gid,"Team",sub),"^",1)
	.q:curTeamDesc'=ExtGObj.ExtTeamDesc
	.s teamSub=sub
	s teamId=gid_"||"_teamSub
	s ^DHCPEDataEx("PreTeamID","ExtToHIS",ExtGObj.ExtGBaseId_"-"_ExtGObj.ExtGid_"-"_ExtGObj.ExtTeamId)=teamId
	s ^DHCPEDataEx("PreTeamID","HISToExt",teamId)=ExtGObj.ExtGBaseId_"-"_ExtGObj.ExtGid_"-"_ExtGObj.ExtTeamId
	q 0_"^"_teamId
}

Storage Default
{
<Data name="PayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.NetPre.PayD</DataLocation>
<DefaultData>PayDefaultData</DefaultData>
<IdLocation>^web.DHCPE.NetPre.PayD</IdLocation>
<IndexLocation>^web.DHCPE.NetPre.PayI</IndexLocation>
<StreamLocation>^web.DHCPE.NetPre.PayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
