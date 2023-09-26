/// Creator: Lid
/// CreatDate: 2012-03-28
/// Description: 门诊收费异常处理业务逻辑
/// 	;异常位置判断:
/// 	;1.自费
/// 	;1.1 Admsource不大于0
/// 	;1.2 预结算记录没有第三方支付支付方式
/// 	;2.自费+第三方支付
/// 	;2.1 Admsource不大于0
/// 	;2.2 预结算记录有第三方支付支付方式
/// 	;3.医保
/// 	;3.1 Admsource大于0
/// 	;3.2 DHC_InvPrt表的PRT_InsDiv_DR字段是否有值,如果没有值则认为医保结算失败。(注：异常处理时,需判断
/// 	;	 一下医保结算是否成功,如果医保组结算成功,只是在更新DHC_InvPrt表时出错,那我们可以继续往下结算,
/// 	;	 如果医保组结算也失败了,那就必须撤销重新结算.)
/// 	;		注意：2015年以后的版本医保判断是否结算成功，调用医保组的接口:
/// 	;			set InsuInfo=##class(web.DHCINSUPort).CheckINSUDivFlag(PrtRowId,"","","","N")	;调用医保接口判断医保结算是否成功
/// 	;			set InsuFlag=$p(InsuInfo,"!",1)	;Y:医保结算成功，N:医保结算不成功
/// 	;3.3 预结算记录没有第三方支付支付方式
/// 	;4.医保+第三方支付
/// 	;4.1 Admsource大于0
/// 	;4.2 DHC_InvPrt表的PRT_InsDiv_DR字段是否有值,如果没有值则认为医保结算失败。确定是医保结算失败后，就不用再判断第三方支付了。
/// 	;4.3 预结算记录有第三方支付支付方式
/// 	;
/// 	;异常代码:
///  	;Excepiton=1011:"自费患者,确认完成失败."
///     ;Excepiton=1012:"自费患者,第三方支付交易成功,HIS确认完成失败."
///     ;Excepiton=1013:"自费患者,第三方支付交易失败."
///     ;Excepiton=1014:"医保患者,医保结算失败"
///     ;Excepiton=1015:"医保患者,医保结算成功,HIS确认完成失败."
///     ;Excepiton=1016:"医保患者,医保结算失败,第三方支付不做结算."
///     ;Excepiton=1017:"医保患者,医保结算成功,第三方支付结算成功,HIS确认完成失败."
///     ;Excepiton=1018:"医保患者,医保结算成功,第三方支付结算失败,HIS不做确认完成."
Class web.DHCOPBillChargExcepiton Extends BILL.COM.Abstract
{

/// 其他收费员允许撤销时限(以分钟为单位, 限时内,其余收费员不能撤销, 超过限时,其余收费员可以撤销.)
Parameter RollBackTimeLimit [ Final ] = 10;

/// Creator: Lid
/// CreatDate: 2012-03-29
/// Description: 查询预结算状态的记录
/// Input: StDate:开始日期, EndDate:结束日期, ChgUserId:收费员ID, PatientNO:登记号, PatientName:病人姓名
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillChargExcepiton","QueryTPInv","2022-11-01","2022-11-30","17275","","","","17275^239^3^2^20")
Query QueryTPInv(StDate As %String, EndDate As %String, ChgUserId As %String, PatientNO As %String, PatientName As %String, CardNo As %String, SessionStr As %String) As websys.Query(ROWSPEC = "TPrtRowId:%String:发票ID,TInsuDivDR:%String:医保结算ID,TPAPMIDR:%String:患者基本信息ID,TAccMDR:%String:账户ID,TPatientNO:%String:登记号,TPatName:%String:患者姓名,TInsType:%String:结算费别,TPrtDate:%String:预结日期,TPrtTime:%String:预结时间,TPrtUserName:%String:操作员,TTotalAmt:%Float:总金额,TPatientShare:%Float:自付金额,TDiscAmount:%Float:折扣金额,TPayorShare:%Float:记账金额,TPayMStr:%String:支付方式,TOperatCode:%String:操作代码,TExceptionDesc:%String:异常描述,TEncryptLevel:%String:密级,TPatLevel:%String:级别")
{
}

ClassMethod QueryTPInvExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, ChgUserId As %String, PatientNO As %String, PatientName As %String, CardNo As %String, SessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CTLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)
	set LangId=$p(SessionStr,"^",5)
	
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	kill PatIdAry
	if (CardNo'="") {
		set myPAPMIStr=##class(web.DHCBL.CARD.UCardRefInfo).GetPAPMIBunchByCardNo(CardNo)
		for i=1:1:$l(myPAPMIStr,"^") {
			set myPAPMI=$p(myPAPMIStr,"^",i)
			continue:(+myPAPMI=0)
			set PatIdAry(myPAPMI)=""
		}
	}elseif (PatientNO'="") {
		set PatientNO=##class(web.UDHCJFBaseCommon).regnocon(PatientNO)
		set myPAPMI=$o(^PAPERi("PAPMI_PatNo",$zcvt(PatientNO,"U"),""))
		if (myPAPMI'="") {
			set PatIdAry(myPAPMI)=""
		}
	}elseif (PatientName'="") {
		do ##class(BILL.COM.PAPatMas).GetPatientByName(PatientName, .PatIdAry)
	}
	
	set PrtRowId=""
	while($o(^DHCINVPRT(0,"PRTFlag","TP",PrtRowId),-1)) {
		set PrtRowId=$o(^DHCINVPRT(0,"PRTFlag","TP",PrtRowId),-1)
		set PrtData=$g(^DHCINVPRT(PrtRowId))
		set HospDR=$p(PrtData,"^",39)
		continue:(HospDR'=HospId)
		set PrtDate=$p(PrtData,"^",5)
		continue:((StDate'="")&&(PrtDate<StDate))
		continue:((EndDate'="")&&(PrtDate>EndDate))
		set PrtDate=##class(websys.Conversions).DateLogicalToHtml(PrtDate)
		set PrtTime=$p(PrtData,"^",20)
		set PrtTime=##class(websys.Conversions).TimeLogicalToHtml(PrtTime)
		set PrtUserDR=$p(PrtData,"^",21)
		continue:((ChgUserId'="")&&(ChgUserId'=PrtUserDR))
		set PrtUserName=$s((+PrtUserDR'=0):$p($g(^SSU("SSUSR",PrtUserDR)),"^",2),1:"")
		set PrtUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", PrtUserName, LangId)
		set InsTypeDR=$p(PrtData,"^",9)
		set InsType=$s((+InsTypeDR'=0):$p($g(^PAC("ADMREA",InsTypeDR)),"^",2),1:"")
		set InsType=##class(User.PACAdmReason).GetTranByDesc("READesc", InsType, LangId)
		set PAPMI=$p(PrtData,"^",15)
		continue:($d(PatIdAry)&&('$d(PatIdAry(PAPMI))))
		set RegNo=$p($g(^PAPER(PAPMI,"PAT",1)),"^",2)
		set PatName=$p($g(^PAPER(PAPMI,"ALL")),"^",1)
		//add by wangjian 2015-01-15 增加病人密级和级别
	    set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PAPMI, "")
	    set EncryptLevel=$p(PatEncryptLevel,"^",1)
	    set PatLevel=$p(PatEncryptLevel,"^",2)
	    //end
		set AccMDR=..GetAccMDRByPAPMIDR(PAPMI)
		set TotalAmt=$p(PrtData,"^",1)          //PRT_Acount
		set TotalAmt=$fn(TotalAmt,"",2)		    
		set PatientShare=$p(PrtData,"^",16)     //PRT_PatientShare
		set PatientShare=$fn(PatientShare,"",2)
		set DiscAmount=$p(PrtData,"^",7)        //PRT_DiscAmount
		set DiscAmount=$fn(DiscAmount,"",2)
		set PayorShare=$p(PrtData,"^",18)       //PRT_PayorShare
		set PayorShare=$fn(PayorShare,"",2)
		set InsuDivDR=$p(PrtData,"^",30)	     //PRT_InsDiv_DR
		set InsuInfo=##class(web.DHCINSUPort).CheckINSUDivFlag(PrtRowId, "", "", "", "N")	 //调用医保接口判断医保结算是否成功
		set InsuFlag=$p(InsuInfo,"!",1)	         //Y:医保结算成功，N:医保结算不成功
		set InitInvDR=$p(PrtData,"^",13)	     //PRT_initInv_DR
		set PayMStr=""
		set PayMSub=0
		while($o(^DHCINVPRT(PrtRowId,"P",PayMSub))) {
			set PayMSub=$o(^DHCINVPRT(PrtRowId,"P",PayMSub))
			set PayMSubData=$g(^DHCINVPRT(PrtRowId,"P",PayMSub))
		    continue:(PayMSubData="")
		    set PayMDR=$p(PayMSubData,"^",1)
			continue:(+PayMDR=0)
		    set PayMAmt=$p(PayMSubData,"^",3)
		    set PayMAmt=$fn(PayMAmt,"",2)
		    set PayMDesc=$p($g(^CT("CTPM",PayMDR)),"^",2)
		    set PayMDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", PayMDesc, LangId)
		    set PayMStr=$s((PayMStr=""):(PayMDesc_"："_PayMAmt),1:(PayMStr_" "_PayMDesc_"："_PayMAmt))
		}
	    set ExceptionInfo=..GetExceptionInfo(PrtRowId, UserId)
	    set OperatCode=$p(ExceptionInfo,"^",1)
	    set ExceptionDesc=$p(ExceptionInfo,"^",2)
	    set ExceptionDesc=##class(websys.Translation).Get("", ExceptionDesc, LangId)
		do OutputData
	}
	quit $$$OK

OutputData
	set Data=$lb(PrtRowId,InsuDivDR,PAPMI,AccMDR,RegNo,PatName,InsType,PrtDate,PrtTime,PrtUserName,TotalAmt,PatientShare,DiscAmount,PayorShare,PayMStr,OperatCode,ExceptionDesc,EncryptLevel,PatLevel)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: Lid
/// CreatDate: 2012-03-28
/// Description: 验证就诊记录是否存在预结算状态的发票记录,如果存在,则需先撤销后再结算
/// Input: EpisodeIDStr:需结算的就诊记录RowID串, ExpStr:扩展信息
/// Return: 0:不存在,1:存在
/// Debug: w ##class(web.DHCOPBillChargExcepiton).CheckTPFlagByEpisodeID("74","")
ClassMethod CheckTPFlagByEpisodeID(EpisodeIDStr As %String, ExpStr As %String = "")
{
	set rtn=0
	set myCheckOutMode=$p(ExpStr,"^",1)
	quit:(myCheckOutMode=1) rtn   //+2018-08-31 ZhYW 科室卡消费不弹出界面时不判断预结算
	
	for i=1:1:$l(EpisodeIDStr,"^")  quit:(+rtn=1)  do
	.set EpisodeID=$p(EpisodeIDStr,"^",i)
	.quit:(+EpisodeID=0)
	.set BCIRowID=""
	.for  set BCIRowID=$o(^DHCBCI(0,"ADM",EpisodeID,BCIRowID),-1) quit:((BCIRowID="")||(+rtn=1))  do
	..set PrtInvRowid=$p(^DHCBCI(BCIRowID),"^",1)
	..set PrtFlag=$p(^DHCINVPRT(PrtInvRowid),"^",8)
	..quit:(PrtFlag'="TP")
	..set rtn=1
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2012-03-28
/// Description: 验证医嘱是否是预结算状态,如果是预结算状态则此医嘱不能做任何操作,比如"停医嘱"
/// Input: OEORIDRStr:医嘱RowID, ExpStr:扩展信息
/// Return: 0:不存在, 1:存在
/// Debug: w ##class(web.DHCOPBillChargExcepiton).CheckTPFlagByOEORIDR("","")
ClassMethod CheckTPFlagByOEORIDR(OEORIDRStr As %String, ExpStr As %String = "")
{
	set rtn=0
	for i=1:1:$l(OEORIDRStr,"^")  quit:(+rtn=1)  do
	.set OEORIDR=$p(OEORIDRStr,"^",i)
	.quit:(+OEORIDR=0)
	.set PBODR=$p(^OEORD(+OEORIDR,"I",+$p(OEORIDR,"||",2),1),"^",16)	//OEORI_ARPBLItem_DR
	.quit:(+PBODR=0)
	.set BCIRowID=""
	.for  set BCIRowID=$o(^DHCBCI(0,"Bill",+PBODR,BCIRowID),-1) quit:((BCIRowID="")||(+rtn=1))  do
	..set PrtInvRowid=$p(^DHCBCI(BCIRowID),"^",1)
	..set PrtFlag=$p(^DHCINVPRT(PrtInvRowid),"^",8)
	..quit:(PrtFlag'="TP")
	..set rtn=1
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2012-03-29
/// Description: 验证第三方支付支付是否成功
/// Input: PrtRowID:发票RowID
/// Return: 0:成功,1:不成功
/// Debug: w ##class(web.DHCOPBillChargExcepiton).CheckBankPayFlag("2222")
ClassMethod CheckBankPayFlag(PrtRowID As %String) As %String
{
	set rtn=1
	quit:(+PrtRowID=0) rtn

	set TradeType="OP"
	set ETPRowID=$o(^DHCBILLETPi(0,"TTypePRT",TradeType,"PRT",PrtRowID,""),-1)	 //(取最后一条记录)
	quit:(ETPRowID="") rtn
	set Rc=$p(^DHCBILLETP(ETPRowID),"^",1)	    //ETP_Rc
	if ($MATCH(Rc,"^0+$")) {          //Rc全部为0时表示交易成功
		set rtn=0
	}
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2012-03-30
/// Description: 获取查询开始日期,根据系统配置
/// Debug: w ##class(web.DHCOPBillChargExcepiton).GetStartDate(2)
ClassMethod GetStartDate(hospId As %String) As %String
{
	set myOPBeginDate=+$h
	set myConInfo=##class(web.DHCOPConfig).ReadOPSPConfig(hospId)
	set myOPFlag=+$p(myConInfo,"^",24)     //OPFC_OutTimeRange
	set myOPValue=+$p(myConInfo,"^",25)    //OPFC_EmergencySearchFlag
	//按照日期
	if (+myOPFlag=0) {
		set myOPBeginDate=+$h-myOPValue
	}
	set myOPBeginDate=##class(websys.Conversions).DateLogicalToHtml(myOPBeginDate)
	quit myOPBeginDate
}

/// Creator: Lid
/// CreatDate: 2012-03-31
/// Description: 获取患者账户Rowid
/// Return: 返回激活状态的账户,如果账户挂起或结算状态,则返回空
/// Debug: w ##class(web.DHCOPBillChargExcepiton).GetAccMDRByPAPMIDR("3087")
ClassMethod GetAccMDRByPAPMIDR(PAPMIDR As %String) As %String
{
	set myAccMDR=""
	quit:(+PAPMIDR=0) myAccMDR
	
	set AccMRowID=""
	for  set AccMRowID=$o(^DHCACDi("AccM",0,"PAPMI",PAPMIDR,AccMRowID),-1)	quit:((AccMRowID="")||(myAccMDR'=""))  do
	.set AccStatus=$p(^DHCACD("AccM",AccMRowID),"^",13)	//AccM_AccStatus
	.quit:(AccStatus'="N")
	.set myAccMDR=AccMRowID
	
	quit myAccMDR
}

/// Creator: chenxi
/// CreatDate: 2013-02-04
/// Description: 判断发票的就诊是否有异常发票未处理
ClassMethod JudgeINVTPFlag(PrtRowId As %String, ExpStr As %String) As %String
{
	set rtn=0
	quit:(+PrtRowId=0) rtn
	set AdmStr=""
	set BillConInv=0
	while($o(^DHCBCI(0,"INV",PrtRowId,BillConInv))) {
		set BillConInv=$o(^DHCBCI(0,"INV",PrtRowId,BillConInv))
		set conData=$g(^DHCBCI(BillConInv))
		set Adm=$p(conData,"^",3)
		continue:(("^"_AdmStr_"^")[("^"_Adm_"^"))
		set AdmStr=$s((AdmStr=""):Adm,1:(AdmStr_"^"_Adm))
	}
	set rtn=##class(web.DHCOPBillChargExcepiton).CheckTPFlagByEpisodeID(AdmStr, "")
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2015-08-21
/// Description: 记录异常处理界面“撤销”，“完成”日志
/// Input:  prtRowID:发票rowid
/// 		flag:"完成"/"撤销"
/// 		msg:显示消息
/// Return: 0：保存成功，其他：保存失败
/// Other: 先存到一个Global里：^DHCBillExcepitonLog("ELog")
ClassMethod setExcepitonLog(prtRowID, flag, msg)
{
	set rtn=0
	set ^DHCBillExcepitonLog("ELog",$zd(+$h,3),$zt($p($h,",",2),1),flag,prtRowID)=msg
	quit rtn
}

/// Description: 判断发票中的药品已发药或医嘱已经执行，如果是则不允许撤销异常
/// Debug: w ##class(web.DHCOPBillChargExcepiton).GetOrdStatus()
ClassMethod GetOrdStatus(PrtRowID As %String) As %String
{
	set isExecute=0
	//+2019-01-09 ZhYW 押金模式的急诊留观结算不需要判断
	set stayCharge=##class(web.UDHCJFBaseCommon).GetPrtInvStat(PrtRowID)
	quit:(stayCharge="Y") isExecute
	
	set BillConInv=0
	for  set BillConInv=$o(^DHCBCI(0,"INV",PrtRowID,BillConInv)) quit:((BillConInv="")||(isExecute=1))  do
    .set PB=$p($g(^DHCBCI(BillConInv)),"^",2)
    .set PBO=0
    .for  set PBO=$o(^DHCPB(PB,"O",PBO)) quit:((PBO="")||(isExecute=1))  do
    ..set PBOData=$g(^DHCPB(PB,"O",PBO))
    ..quit:(PBOData="")
    ..set OEORI=$p(PBOData,"^",4)    //DHC_PatBillOrder->PBO_OEORI_DR
    ..quit:(OEORI="")
    ..set Arcim=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",2)
    ..set Inci=$o(^INCI(0,"ARCIM_DR",+Arcim,""))
    ..if (Inci'="") do
    ...set DisQtySum=0
    ...set DspId=0
	...for  set DspId=$o(^DHCOEDISQTY(0,"OEORI",OEORI,DspId)) quit:(DspId="")  do
	....set DispData=$g(^DHCOEDISQTY(DspId))
	....quit:(DispData="")
	....set DspStatus=$p(DispData,"^",7)
	....quit:((" C R ")'[(" "_DspStatus_" "))
	....set DspQty=+$p(DispData,"^",11)
	....if (DspStatus="R") set DspQty=-DspQty
	....set DisQtySum=DisQtySum+DspQty
	...if (DisQtySum'=0) set isExecute=1
	..else  do
	...set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(OEORI)
	...if (isAppRep="Y") do
	....set isPartExec=##class(web.DHCOPBillRefund).IsPartExecut(OEORI)
	....if (isPartExec=1) set isExecute=1
	...else  do
	....set execQty=##class(web.UDHCJFBILL).GetOrdExecQty(OEORI)   //已执行数量
	....if (execQty>0) set isExecute=1

	quit isExecute
}

/// Creator: ZhYW
/// CreatDate: 2019-08-28
/// Description: 返回异常处理代码和异常描述
/// Input: 
/// Return: OperatCode(1:撤销，2:完成, 3:撤销或完成)
/// Debug: w ##class(web.DHCOPBillChargExcepiton).GetExceptionInfo(235925)
ClassMethod GetExceptionInfo(PrtRowId As %String, UserId As %String = "") As %String
{
	set PrtData=$g(^DHCINVPRT(PrtRowId))
	
	set PrtFlag=$p(PrtData,"^",8)
	quit:(PrtFlag'="TP") "^"
	
	set OperatCode="", ExceptionDesc=""

	set InsTypeDR=$p(PrtData,"^",9)
	set AdmSource=$s((+InsTypeDR'=0):$p(^PAC("ADMREA",InsTypeDR),"^",9),1:"")
	
	set InsuInfo=##class(web.DHCINSUPort).CheckINSUDivFlag(PrtRowId, "", "", "", "N")	//调用医保接口判断医保结算是否成功
	set InsuFlag=$p(InsuInfo,"!",1)	   //Y:医保结算成功，N:医保结算不成功
	
	set PrtDate=$p(PrtData,"^",5)
	set InsuDivDR=$p(PrtData,"^",30)	    //PRT_InsDiv_DR
	set InitInvDR=$p(PrtData,"^",13)	    //PRT_initInv_DR
	set OldInvDR=$p(PrtData,"^", 29)       //PRT_OldINV_DR
	set PrtDate=$p(PrtData,"^",5)
	set PrtUserDR=$p(PrtData,"^",21)
	set PayMSub="", HardComm=""
	while($o(^DHCINVPRT(PrtRowId,"P",PayMSub),-1)&&(+HardComm>0)) {
		set PayMSub=$o(^DHCINVPRT(PrtRowId,"P",PayMSub),-1)
		set PayMSubData=$g(^DHCINVPRT(PrtRowId,"P",PayMSub))
		continue:(PayMSubData="")
		set PayMDR=$p(PayMSubData,"^",1)
		continue:(+PayMDR=0)
		set HardComm=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayMDR)
	}
    
	if (+OldInvDR=0) {    //收费
		if (+AdmSource>0) {
			if (+HardComm>0) {    //医保+第三方支付
				if (InsuFlag'="Y") {
					set OperatCode=1			    //撤销
					set ExceptionDesc="医保患者，医保结算失败，第三方支付不做交易"
				}else {
					set BankPayFlag=##class(web.DHCOPBillChargExcepiton).CheckBankPayFlag(PrtRowId)
					set ExceptionDesc="医保患者，医保结算成功"
					if (BankPayFlag=0) {
						set OperatCode=2		    //完成
						set ExceptionDesc=ExceptionDesc_"，第三方支付交易成功，HIS确认完成失败"
					}else {
						set OperatCode=1		    //撤销
						set ExceptionDesc=ExceptionDesc_"，第三方支付交易失败，HIS不做确认完成"
					}
				}
			}else {                //医保
				if (InsuFlag'="Y") {
					set OperatCode=1			//撤销
   					set ExceptionDesc="医保患者，医保结算失败"
   					if (+InsuDivDR'=0) {
	   					set ExceptionDesc=ExceptionDesc_"，发票表有医保结算指针"
	   				}
				}else {
					set OperatCode=3			//撤销或完成
    				set ExceptionDesc="医保患者，医保结算成功，HIS确认完成失败"
				}
			}
		}else {
			if (+HardComm>0) {        //自费+第三方支付
				set BankPayFlag=##class(web.DHCOPBillChargExcepiton).CheckBankPayFlag(PrtRowId)
				if (+BankPayFlag=0) {
					set OperatCode=2			//完成
					if ((PrtUserDR'=UserId)||(PrtDate'=+$h)) {
						set OperatCode=1		//撤销
					}
  					set ExceptionDesc="自费患者，第三方支付交易成功，HIS确认完成失败"
				}else {
					set OperatCode=1			//撤销
    				set ExceptionDesc="自费患者，第三方支付交易失败"
				}
			}else {
				set OperatCode=1			    //撤销
    			set ExceptionDesc="自费患者，确认完成失败"
			}
		}
	}else {              //部分退费重收
		if (+AdmSource>0) {
			if (InsuFlag'="Y") {
				set OperatCode=2			//完成
				set ExceptionDesc="医保患者，医保结算失败"
			}else {
				set OperatCode=2			//完成
				set ExceptionDesc="医保患者，医保结算成功，HIS确认完成失败"
			}
		}else {
			set OperatCode=2			   //完成
    		set ExceptionDesc="自费患者，确认完成失败"
		} 
	}
	
	set Rtn=OperatCode_"^"_ExceptionDesc
	
	quit Rtn
}

/// Creator: ZhYW
/// CreatDate: 2018-07-03
/// Description: 判断能否撤销
/// Input: prtRowId:DHC_INVPRT.RowId, sessionStr:用户^安全组^登陆科室^院区
/// Return: 0:只能原收费员撤销, 1:其他收费员可以撤销
/// Debug: w ##class(web.DHCOPBillChargExcepiton).ValidRollback("14984","5^122^49^2^20")
ClassMethod ValidRollback(prtRowId As %String, sessionStr As %String) As %String
{
	set ^TMP("ValidRollback")=$lb(prtRowId, sessionStr)
	set userId=$p(sessionStr,"^",1)
    set groupId=$p(sessionStr,"^",2)
    set ctLocId=$p(sessionStr,"^",3)
    set hospId=$p(sessionStr,"^",4)
    
	set rtn=0
	quit:(+prtRowId=0) rtn
	set prtData=$g(^DHCINVPRT(prtRowId))
	set prtUserDR=$p(prtData,"^",21)
	quit:(prtUserDR=userId) 1

	if (..GetRolUser(prtUserDR, hospId)) {
		quit 1
	}
	
	set prtDate=$p(prtData,"^",5)
	set prtTime=$p(prtData,"^",20)
	if ($SYSTEM.SQL.DATEDIFF("ss", prtDate_","_prtTime, $h)>(..#RollBackTimeLimit*60)) {
		set rtn=1
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2020-02-17
/// Description: 根据原票获取负票RowId
/// Input: prtRowId: DHC_INVPRT.RowId
/// Return: 
/// Debug: w ##class(web.DHCOPBillChargExcepiton).GetStrikInvRowId(4569)
ClassMethod GetStrikInvRowId(prtRowId As %String) As %String
{
	quit $s((+prtRowId'=0):$o(^DHCINVPRT(0,"InitInvDR",prtRowId,0)),1:"")
}

/// Creator: ZhYW
/// CreatDate 2021-07-15
/// Description: 收费员是否在撤销非本人收费产生的异常人员设置中
/// Input: userId:原支付方式, hospId:CT_Hospital.RowId
/// Return: 1:是, <>1:否
/// Debug: w ##class(web.DHCOPBillChargExcepiton).GetRolUser(1, 2)
ClassMethod GetRolUser(userId As %String, hospId As %String) As %String
{
	set code="ROLUSER"_userId
	quit ##class(web.DHCBillPageConf).GetPageConfValue("dhcbill.opbill.charge.excepiton.csp", code, "", hospId)
}

}
