Import SQLUser

Class web.DHCOPBillFindBankTradeInfo Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 316;

/// tangtao
/// 2011-12-05
/// 查询交易明细，补打凭条
/// d ##class(%ResultSet).RunQuery("web.DHCOPBillFindBankTradeInfo","FindTradePay",62421,62430,"","","","")
ClassMethod FindTradePayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTradePayExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindTradePayExecute(ByRef qHandle As %Binary, StDate, EndDate, PapmiName, PapmiNo, BankTradeNo, UserName) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    i StDate="" s StDate=+$h
    i EndDate="" s EndDate=+$h
    
    s ^TMP("tt")=StDate_","_EndDate_","_PapmiName_","_PapmiNo_","_BankTradeNo_","_UserName
    i (PapmiNo'="") d
    .s PapmiNo=##class(web.UDHCJFBaseCommon).regnocon(PapmiNo)
    s Date=""
    f Date=EndDate:-1:StDate  d
    .s Time=""
    .f  s Time=$o(^DHCINVBTPi(0,"HISDTIME",Date,Time),-1) q:Time=""  d
    ..s Rowid=""
    ..f  s Rowid=$o(^DHCINVBTPi(0,"HISDTIME",Date,Time,Rowid),-1) q:Rowid=""  d
    ...s IBPRC=$p(^DHCINVBTP(Rowid),"^",1)
    ...q:IBPRC'="00"
    ...s BankID=$p(^DHCINVBTP(Rowid),"^",39)
    ...q:BankID'="05"
    ...s InvPrtDr=$p(^DHCINVBTP(Rowid),"^",44)
    ...q:InvPrtDr=""
    ...s NInvPrt=$p(InvPrtDr,"|",1)
    ...s AInvPrt=$p(InvPrtDr,"|",2)
    ...s InvPrt="",InvNo=""
    ...i NInvPrt="" s InvPrt=AInvPrt
    ...e  d
    ....s InvPrt=NInvPrt
    ....s InvNo=$p(^DHCINVPRT(InvPrt),"^",14)
    ...s PapmiDr=$p(^DHCINVPRT(InvPrt),"^",15)
    ...s PatNo=$p(^PAPER(PapmiDr,"ALL"),"^",1)
    ...q:((PatNo'=PapmiNo)&(PapmiNo'=""))              ;登记号区别
    ...s PatName=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
    ...q:((PatName'=PapmiName)&(PapmiName'=""))         ;姓名区别
    ...s IBPRRN=$p(^DHCINVBTP(Rowid),"^",7)             
    ...q:((IBPRRN'=BankTradeNo)&(BankTradeNo'=""))      ;交易参考号
    ...s TradeDate=$zd(Date,3)
    ...s TradeTime=$zt(Time,1)
    ...s TradeAmt=$fn($p(^DHCINVBTP(Rowid),"^",23),"",2)
    ...s BankTradeType=$p(^DHCINVBTP(Rowid),"^",24)
    ...i BankTradeType="C" s BankTradeType="收费"
    ...e  i BankTradeType="R" s BankTradeType="当日全退"
    ...e  s BankTradeType="退货"
    ...s IBPUser=$p(^DHCINVBTP(Rowid),"^",25)
    ...s IBPUserName=$p(^SSU("SSUSR",IBPUser),"^",2)
    ...q:((IBPUserName'=UserName)&(UserName'=""))       ;操作员区别
    ...s TSelect=1
    ...Do OutputRowInfo
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowInfo
    set Data=$lb(TSelect,Rowid,TradeDate,TradeTime,PatNo,PatName,IBPRRN,IBPUserName,TradeAmt,BankTradeType,InvNo)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindTradePayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTradePayExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else{           
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

Query FindTradePay(StDate, EndDate, PapmiName, PapmiNo, BankTradeNo, UserName) As %Query(ROWSPEC = "TSelect:%String,TRowid:%String,TTradeDate:%String,TTradeTime:%String,TPatName:%String,TPatNo:%String,TIBPRRN:%String,TIBPUserName:%String,TTradeAmt:%String,TBankTradeType:%String,TInvNo:%String")
{
}

/// tangtao 
/// 2011-12-05
/// 重打小条
/// w ##class(web.DHCOPBillFindBankTradeInfo).RePrintAcert(529)
ClassMethod RePrintAcert(IBPRowid)
{
    s AccName=$p(^DHCINVBTP(IBPRowid),"^",34)             ;商户名称
    s AccNo=$p(^DHCINVBTP(IBPRowid),"^",10)               ;商户编号
    s TerminalNo=$p(^DHCINVBTP(IBPRowid),"^",9)           ;终端编号
    s UserId=$p(^DHCINVBTP(IBPRowid),"^",12)              ;操作员号
    s Bank=$p(^DHCINVBTP(IBPRowid),"^",13)                ;发 卡 行
    s Bank=$tr($e(Bank,23,$l(Bank))," ")
    s CardNo=$p(^DHCINVBTP(IBPRowid),"^",3)               ;卡    号
    s FailDate=$p(^DHCINVBTP(IBPRowid),"^",16)            ;卡有效期
    s TradeType=$p(^DHCINVBTP(IBPRowid),"^",24)           ;交易类型
    s BatchNo=$p(^DHCINVBTP(IBPRowid),"^",11)             ;批 次 号
    s CertNo=$p(^DHCINVBTP(IBPRowid),"^",5)               ;凭 证 号
    s AuthNo=$p(^DHCINVBTP(IBPRowid),"^",8)               ;授 权 码
    s BankTradeDate=$p(^DHCINVBTP(IBPRowid),"^",14)       ;日期
    s BankTradeTime=$p(^DHCINVBTP(IBPRowid),"^",15)       ;时间
    s TransRefNo=$p(^DHCINVBTP(IBPRowid),"^",7)           ;系统参考号
    s TradeAmt=$p(^DHCINVBTP(IBPRowid),"^",23)            ;金额(RMB)
    s TradeAmt=$fn(TradeAmt,"",2)
    s TRemarkInfo=$p(^DHCINVBTP(IBPRowid),"^",17)            ;备注
    i TradeType="C" s TradeType="消费"
    i TradeType="R" s TradeType="消费撤销"
    i TradeType="D" s TradeType="退货"

    s BankTradeDate1=$e(BankTradeDate,1,4)_"/"_$e(BankTradeDate,5,6)_"/"_$e(BankTradeDate,7,8)
    s BankTradeTime1=$e(BankTradeTime,1,2)_":"_$e(BankTradeTime,3,4)_":"_$e(BankTradeTime,5,6)
    s BankTradeDate=BankTradeDate1,BankTradeTime=BankTradeTime1
    
    s STR2="         (商户联)  (重打)",STR11="         (商户联)  (重打)"
    s PrintInfo="AccName"_$c(2)_"商户名称:"_AccName_"^"_"AccNo"_$c(2)_"商户编号:"_AccNo_"^"_"TerminalNo"_$c(2)_"终端编号:"_TerminalNo
    s PrintInfo=PrintInfo_"^"_"UserId"_$c(2)_"操作员号:"_UserId_"^"_"Bank"_$c(2)_"发 卡 行:"_Bank_"^"_"CardNo"_$c(2)_"卡    号:"_CardNo
    s PrintInfo=PrintInfo_"^"_"FailDate"_$c(2)_"卡有效期:"_FailDate_"^"_"TradeType"_$c(2)_"交易类型:"_TradeType_"^"_"BatchNo"_$c(2)_"批 次 号:"_BatchNo
    s PrintInfo=PrintInfo_"^"_"CertNo"_$c(2)_"凭 证 号:"_CertNo_"^"_"AuthNo"_$c(2)_"授 权 码:"_AuthNo_"^"_"BankTradeDate"_$c(2)_"日期时间:"_BankTradeDate_" "_BankTradeTime
    s PrintInfo=PrintInfo_"^"_"TransRefNo"_$c(2)_"系统参考号:"_TransRefNo_"^"_"TradeAmt"_$c(2)_"金额(RMB):"_TradeAmt_"^"_"TRemarkInfo"_$c(2)_"备    注:"_TRemarkInfo
    s PrintInfo=PrintInfo_"^"_"STR1"_$c(2)_""_"^"_"STR2"_$c(2)_STR2_"^"_"STR3"_$c(2)_""
    s PrintInfo=PrintInfo_"^"_"STR4"_$c(2)_""_"^"_"STR5"_$c(2)_""_"^"_"STR6"_$c(2)_""
    s PrintInfo=PrintInfo_"^"_"STR7"_$c(2)_""_"^"_"STR8"_$c(2)_""_"^"_"STR9"_$c(2)_""

    s PrintInfo=PrintInfo_"^"_"STR10"_$c(2)_""_"^"_"STR11"_$c(2)_STR11_"^"_"STR12"_$c(2)_""
    s PrintInfo=PrintInfo_"^"_"STR13"_$c(2)_""_"^"_"STR14"_$c(2)_""_"^"_"STR15"_$c(2)_""
    s PrintInfo=PrintInfo_"^"_"STR16"_$c(2)_""_"^"_"STR17"_$c(2)_""
    
    q PrintInfo
}

ClassMethod JudgeCardCPPTradePayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = JudgeCardCPPTradePayExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPBillFindBankTradeInfo","JudgeCardCPPTradePay","62491","","62491","")
ClassMethod JudgeCardCPPTradePayExecute(ByRef qHandle As %Binary, StDate, StTime, EndDate, EndTime, ChooseBankId) As %Status
{
    s repid=$I(^CacheTemp)
    s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
    s StTime=##class(websys.Conversions).TimeHtmlToLogical(StTime)
    s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)
    
    i (StDate="")!(EndDate="") Set qHandle=$lb(0,repid,0)   Quit $$$OK
    s ind=2
    s Guser=%session.Get("LOGON.USERID")
    s job=$j
    ;s ^TMP("tt")=StDate_","_StTime_","_EndDate_","_EndTime_","_ChooseBankId
    k ^TMPDHCINVBankBalance
    k ^TMP("UDHCJFJudgeBankTradePay",Guser,job)
    ;TimeFlag=1  按HIS交易时间查询
    s ^TMP("UDHCJFJudgeBankTradePay",Guser,job,1)="1^登记号^姓名^银行代码^医院代码^渠道代码^交易操作员^银行卡号^HIS交易时间^HIS交易流水号^交易标志^应收金额^实收金额^银行交易时间^银行交易流水号^银行交易财务日期"
    s TimeFlag="1"
    i TimeFlag="1" s TimeCode="HISDTIME"
    i TimeFlag="2" s TimeCode="BANKTRADETIME"
    i StTime="" s StTime="00000"
    i EndTime="" s EndTime="86399"
    i StTime'="" s IBTSTDATETIME=$tr(##class(websys.Conversions).DateLogicalToHtml(StDate),"-")_$tr(##class(websys.Conversions).TimeLogicalToHtml(StTime,1),":")
    e  s IBTSTDATETIME=$tr(##class(websys.Conversions).DateLogicalToHtml(StDate),"-")_"00001"
    i EndTime'="" s IBTENDDATETIME=$tr(##class(websys.Conversions).DateLogicalToHtml(EndDate),"-")_$tr(##class(websys.Conversions).TimeLogicalToHtml(EndTime,1),":")
    e  s IBTENDDATETIME=$tr(##class(websys.Conversions).DateLogicalToHtml(EndDate),"-")_"86399"
    s InvPrtRowid=0
    s PrtPapmino="",PrtPapminame=""
    s AllSSAmt=0,AllYSAmt=0
    i ((TimeFlag="1")!(TimeFlag="2")) d
    .s Rowid=""
    .f Date=StDate:1:EndDate d
    ..s PrtRowid=""
    ..f  s PrtRowid=$o(^DHCINVPRT(0,"Date",Date,PrtRowid)) q:PrtRowid=""  d
    ...q:PrtRowid="20033891"    ;测试数据
    ...s OldInvDr=$p(^DHCINVPRT(PrtRowid),"^",29)
    ...q:OldInvDr'=""
    ...s PrtFlag=0
    ...s InitInvDr=$p(^DHCINVPRT(PrtRowid),"^",13)
    ...s PrtPapmidr=$p(^DHCINVPRT(PrtRowid),"^",15)
    ...s PrtPapmino=$p(^PAPER(PrtPapmidr,"PAT",1),"^",1)
    ...s PrtPapminame=$p(^PAPER(PrtPapmidr,"ALL"),"^",1)
    ...i InitInvDr'="" d
    ....s InitInvAmt=$p(^DHCINVPRT(InitInvDr),"^",1)
    ....s PrtOldDr=$o(^DHCINVPRT(0,"OldINV",InitInvDr,""))
    ....i PrtOldDr'="" d
    .....s PrtOldDrAmt=$p(^DHCINVPRT(PrtOldDr),"^",1)
    .....i PrtOldDrAmt=InitInvAmt s PrtFlag=1
    ...q:PrtFlag=1
    ...s PaymSub="",Flag=0
    ...f  s PaymSub=$o(^DHCINVPRT(PrtRowid,"P",PaymSub)) q:PaymSub=""  d
    ....q:PaymSub=0
    ....s PaymDr=$p(^DHCINVPRT(PrtRowid,"P",PaymSub),"^",1)
    ....s PaymAmt=$p(^DHCINVPRT(PrtRowid,"P",PaymSub),"^",3)
    ....s HandDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",PaymDr)
    ....i ((HandDr'="")&(PaymDr'=12)) d
    .....i +$g(PaymAmt)'=0 s Flag=1
    ...q:Flag=0
    ...s Rowid=""
    ...i $d(^DHCINVBTPi(0,"S","IPDR",PrtRowid))'=0 d
    ....s Rowid=$o(^DHCINVBTPi(0,"S","IPDR",PrtRowid,Rowid))
    ....s Rc=$p(^DHCINVBTP(Rowid),"^",1)
    ....q:Rc'="0000"
    ....s HISTradeNo=$p(^DHCINVBTP(Rowid),"^",32)
    ....s TradeAmt=$p(^DHCINVBTP(Rowid),"^",4)
    ....s TradeAmt=+$g(TradeAmt)
    ....i HISTradeNo'="" d
    .....s IBTRowID=$o(^User.DHCINVBankBalanceI("TRADENO",HISTradeNo,""))
    .....i IBTRowID'="" d
    ......s IBTAmt=$LIST(^User.DHCINVBankBalanceD(IBTRowID),12)
    ......s IBTBankTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),5)
    ......s THISTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),7)
    ......s ^TMPDHCINVBankBalance(IBTRowID)=IBTRowID
    ......s IBTAmt=$fn(IBTAmt/100,"",2)
    ......s TradeAmt=$fn(TradeAmt/100,"",2)
    ......q:((HISTradeNo=THISTradeNo)&(TradeAmt=IBTAmt))
    ......s TBankNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),4)
    ......q:((ChooseBankId'="99")&(ChooseBankId'=TBankNo))
    ......i TBankNo="01" s TBankNo="中国工商银行"
    ......i TBankNo="02" s TBankNo="中国农业银行"
    ......i TBankNo="03" s TBankNo="中国银行"
    ......i TBankNo="04" s TBankNo="中国建设银行"
    ......s THopDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),9)
    ......i +$g(THopDr)="1001" s THopDr="安徽省立医院"
    ......s TTrannelNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),15)
    ......i TTrannelNo="11" s TTrannelNo="银行柜台"
    ......i TTrannelNo="12" s TTrannelNo="银行自助设备"
    ......i TTrannelNo="13" s TTrannelNo="银行电话银行"
    ......i TTrannelNo="14" s TTrannelNo="银行网银"
    ......i TTrannelNo="25" s TTrannelNo="院内自助设备"
    ......i TTrannelNo="26" s TTrannelNo="医院门诊窗口"
    ......i TTrannelNo="27" s TTrannelNo="医院各执行点"
    ......;s IBTTerminalNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),11)
    ......s IBTUserId=$LIST(^User.DHCINVBankBalanceD(IBTRowID),16)
    ......i $d(^SSU("SSUSR",IBTUserId))'=0 s TUserId=$p(^SSU("SSUSR",IBTUserId),"^",2)
    ......e  d
    .......s TUserId=##class(DHCExternalService.RegInterface.GetRelate).GetUser(IBTUserId)         ;调用挂号返回id
    .......s TUserId=$p(^SSU("SSUSR",TUserId),"^",2)
    ......s TBankCardNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),2)
    ......s THISTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),8)
    ......s THISTradeTime=$e(THISTradeTime1,1,4)_"-"_$e(THISTradeTime1,5,6)_"-"_$e(THISTradeTime1,7,8)
    ......s THISTradeTime=THISTradeTime_" "_$e(THISTradeTime1,9,10)_":"_$e(THISTradeTime1,11,12)_":"_$e(THISTradeTime1,13,14)
    ......s IBTTradeFlag=$LIST(^User.DHCINVBankBalanceD(IBTRowID),13)
    ......s TTradeFlag=""
    ......i IBTTradeFlag=0 s TTradeFlag="扣费"
    ......i IBTTradeFlag=1 s TTradeFlag="退费"
    ......s IBTPaymodeDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),10)
    ......s IBTPaymDesc=""
    ......i IBTPaymodeDr=1 s IBTPaymDesc="银医卡"
    ......s TBankTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),6)
    ......s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
    ......s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
    ......s TBankFinDate=$LIST(^User.DHCINVBankBalanceD(IBTRowID),3)
    ......s TBankFinDate=$e(TBankFinDate,1,4)_"-"_$e(TBankFinDate,5,6)_"-"_$e(TBankFinDate,7,8)
    ......s TTradeAmt=TradeAmt
    ......s TBankTradeNo=IBTBankTradeNo
    ......s TTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),14)
    ......s InvPrtRowid=PrtRowid
    ......s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    ......d outputrowpay
    .....e  d
    ......s TBankNo=$p(^DHCINVBTP(Rowid),"^",39)
    ......q:((ChooseBankId'="99")&(ChooseBankId'=TBankNo))
    ......i TBankNo="01" s TBankNo="中国工商银行"
    ......i TBankNo="02" s TBankNo="中国农业银行"
    ......i TBankNo="03" s TBankNo="中国银行"
    ......i TBankNo="04" s TBankNo="中国建设银行"
    ......s THopDr=$p(^DHCINVBTP(Rowid),"^",28)
    ......i THopDr'="" s THopDr=$p(^CT("HOSP",THopDr),"^",1)
    ......e  s THopDr="1001"
    ......i THopDr="1001" s THopDr="安徽省立医院"
    ......s TTrannelNo=$p(^DHCINVBTP(Rowid),"^",31)
    ......i TTrannelNo="11" s TTrannelNo="银行柜台"
    ......i TTrannelNo="12" s TTrannelNo="银行自助设备"
    ......i TTrannelNo="13" s TTrannelNo="银行电话银行"
    ......i TTrannelNo="14" s TTrannelNo="银行网银"
    ......i TTrannelNo="25" s TTrannelNo="院内自助设备"
    ......i TTrannelNo="26" s TTrannelNo="医院门诊窗口"
    ......i TTrannelNo="27" s TTrannelNo="医院各执行点"
    ......;s IBTTerminalNo=$p(^DHCINVBTP(Rowid),"^",41)
    ......s TUserId=$p(^DHCINVBTP(Rowid),"^",25)
    ......i TUserId'="" d
    .......i $d(^SSU("SSUSR",TUserId))'=0 s TUserId=$p(^SSU("SSUSR",TUserId),"^",2)
    .......e  d
    ........s TUserId=##class(DHCExternalService.RegInterface.GetRelate).GetUser(IBTUserId)    ;;调用挂号返回id
    ........s TUserId=$p(^SSU("SSUSR",TUserId),"^",2)
    ......s TBankCardNo=$p(^DHCINVBTP(Rowid),"^",3)
    ......s THISTradeTime=$p(^DHCINVBTP(Rowid),"^",21)
    ......s THISTradeTime=##class(websys.Conversions).DateLogicalToHtml(THISTradeTime)
    ......s THISTradet=$p(^DHCINVBTP(Rowid),"^",22)
    ......s THISTradet=##class(websys.Conversions).TimeLogicalToHtml(THISTradet,1)
    ......s THISTradeTime=THISTradeTime_" "_THISTradet
    ......s THISTradeNo=$p(^DHCINVBTP(Rowid),"^",32)
    ......s TTradeFlag=$p(^DHCINVBTP(Rowid),"^",24)
    ......i TTradeFlag="C" s TTradeFlag="扣费"
    ......i ((TTradeFlag="R")!(TTradeFlag="D")) s TTradeFlag="退费"
    ......s IBTPaymDesc="银医卡"
    ......s TBankTradeTime1=$p(^DHCINVBTP(Rowid),"^",14)_$p(^DHCINVBTP(Rowid),"^",15)
    ......s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
    ......s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
    ......s TBankFinDate=""
    ......s TTradeAmt=$fn($p(^DHCINVBTP(Rowid),"^",23),"",2)
    ......s IBTAmt="0.00"
    ......s TBankTradeNo=$p(^DHCINVBTP(Rowid),"^",19)
    ......s TTradeNo=$p(^DHCINVBTP(Rowid),"^",41)
    ......s InvPrtRowid=PrtRowid
    ......s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    ......d outputrowpay
    ...e  d
    ....s TBankNo="银医卡"
    ....;s THopDr=1  
    ....s THopDr=$o(^CT("HOSP",""))
    ....s THopDr=$p(^CT("HOSP",THopDr),"^",1)
    ....i THopDr="1001" s THopDr="安徽省立医院"
    ....s CTRowid=$p(^DHCINVPRT(PrtRowid),"^",40)
    ....s GroupRowid=$p(^DHCINVPRT(PrtRowid),"^",39)
    ....s PapmiDr=$p(^DHCINVPRT(PrtRowid),"^",15)
    ....s PrtPapmino=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
    ....s PrtPapminame=$p(^PAPER(PapmiDr,"ALL"),"^",1)
    ....s TBankTradeNo=""
    ....s TTrannelNo=$p(^SSU("SSGRP",GroupRowid),"^",1)
    ....i "118,200,202,123,137,199,201,269"[GroupRowid s TTrannelNo="医院门诊窗口"
    ....i "287"[GroupRowid s TTrannelNo="院内自助设备"
    ....;s IBTTerminalNo=$p(^DHCINVBTP(Rowid),"^",41)
    ....s TUserId=$p(^DHCINVPRT(PrtRowid),"^",21)
    ....s TUserId=$p(^SSU("SSUSR",TUserId),"^",2)
    ....s TBankCardNo=""
    ....i $d(^TMPInsertPrtAndBankNo(PrtRowid))'=0  d
    .....s TBankCardNo=^TMPInsertPrtAndBankNo(PrtRowid)
    ....s THISTradeTime=$p(^DHCINVPRT(PrtRowid),"^",5)
    ....s THISTradeTime=##class(websys.Conversions).DateLogicalToHtml(THISTradeTime)
    ....s THISTradet=$p(^DHCINVPRT(PrtRowid),"^",20)
    ....s THISTradet=##class(websys.Conversions).TimeLogicalToHtml(THISTradet,1)
    ....s THISTradeTime=THISTradeTime_" "_THISTradet
    ....s THISTradeNo=""
    ....i PaymAmt>0 s TTradeFlag="C"
    ....e  s TTradeFlag="R"
    ....i TTradeFlag="C" s TTradeFlag="扣费"
    ....i ((TTradeFlag="R")!(TTradeFlag="D")) s TTradeFlag="退费"
    ....s IBTPaymDesc="银医卡"
    ....s TBankTradeTime=""
    ....s TBankFinDate=""
    ....i PaymAmt<0 d
    .....s InitInvDr=$p(^DHCINVPRT(PrtRowid),"^",13)
    .....i InitInvDr'="" d
    ......s PrtOldDr=$o(^DHCINVPRT(0,"OldINV",InitInvDr,""))
    ......s TTradeAmt=##class(web.DHCBillBankLogic).GetOPInvBankCardAmt(PrtOldDr_"|"_InitInvDr)
    ....e  d
    .....s TTradeAmt=$fn($zabs(PaymAmt),"",2)
    ....s IBTAmt="0.00"
    ....s TTradeNo=""
    ....s InvPrtRowid=PrtRowid
    ....s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    ....d outputrowpay
    .s Date="",PrtPapmino="",PrtPapminame=""
    .i TimeFlag="1" s TimeCode="HISTIME"
    .i TimeFlag="2" s TimeCode="BANKTRADETIME"
    .f Date=IBTSTDATETIME:1:IBTENDDATETIME d
    ..s IBTRowID=""
    ..f  s IBTRowID=$o(^User.DHCINVBankBalanceI(TimeCode,Date,IBTRowID)) q:IBTRowID=""  d
    ...q:IBTRowID=0
    ...q:$d(^TMPDHCINVBankBalance(IBTRowID))=1
    ...s IBTPaymodeDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),10)
    ...s IBTPaymDesc=""
    ...i IBTPaymodeDr=1 s IBTPaymDesc="银医卡"
    ...q:(IBTPaymodeDr'=1)
    ...s IBTAmt=$LIST(^User.DHCINVBankBalanceD(IBTRowID),12)
    ...s IBTBankTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),5)
    ...s THISTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),7)
    ...s IBTAmt=$fn(IBTAmt/100,"",2)
    ...s TradeAmt="0.00"
    ...s TBankNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),4)
    ...q:((ChooseBankId'="99")&(ChooseBankId'=TBankNo))
    ...i TBankNo="01" s TBankNo="中国工商银行"
    ...i TBankNo="02" s TBankNo="中国农业银行"
    ...i TBankNo="03" s TBankNo="中国银行"
    ...i TBankNo="04" s TBankNo="中国建设银行"
    ...s THopDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),9)
    ...i +$g(THopDr)="1001" s THopDr="安徽省立医院"
    ...s TTrannelNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),15)
    ...i TTrannelNo="11" s TTrannelNo="银行柜台"
    ...i TTrannelNo="12" s TTrannelNo="银行自助设备"
    ...i TTrannelNo="13" s TTrannelNo="银行电话银行"
    ...i TTrannelNo="14" s TTrannelNo="银行网银"
    ...i TTrannelNo="25" s TTrannelNo="院内自助设备"
    ...i TTrannelNo="26" s TTrannelNo="医院门诊窗口"
    ...i TTrannelNo="27" s TTrannelNo="医院各执行点"
    ...;s IBTTerminalNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),11)
    ...s IBTUserId=$LIST(^User.DHCINVBankBalanceD(IBTRowID),16)
    ...i $d(^SSU("SSUSR",IBTUserId))'=0 s TUserId=$p(^SSU("SSUSR",IBTUserId),"^",2)
    ...e  d
    ....s TUserId=##class(DHCExternalService.RegInterface.GetRelate).GetUser(IBTUserId)              ;;调用挂号返回id
    ....s TUserId=$p(^SSU("SSUSR",TUserId),"^",2)
    ...s TBankCardNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),2)
    ...s THISTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),8)
    ...s THISTradeTime=$e(THISTradeTime1,1,4)_"-"_$e(THISTradeTime1,5,6)_"-"_$e(THISTradeTime1,7,8)
    ...s THISTradeTime=THISTradeTime_" "_$e(THISTradeTime1,9,10)_":"_$e(THISTradeTime1,11,12)_":"_$e(THISTradeTime1,13,14)
    ...s IBTTradeFlag=$LIST(^User.DHCINVBankBalanceD(IBTRowID),13)
    ...s TTradeFlag=""
    ...i IBTTradeFlag=0 s TTradeFlag="扣费"
    ...i IBTTradeFlag=1 s TTradeFlag="退费"
    ...s TBankTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),6)
    ...s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
    ...s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
    ...s TBankFinDate=$LIST(^User.DHCINVBankBalanceD(IBTRowID),3)
    ...s TBankFinDate=$e(TBankFinDate,1,4)_"-"_$e(TBankFinDate,5,6)_"-"_$e(TBankFinDate,7,8)
    ...s TTradeAmt=TradeAmt
    ...s TBankTradeNo=IBTBankTradeNo
    ...s TTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),14)
    ...s InvPrtRowid=0
    ...s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    ...d outputrowpay
    s (TTradeNo,PrtPapmino,PrtPapminame,TBankNo,THopDr,TTrannelNo,TUserId,TBankCardNo,THISTradeTime,THISTradeNo,TTradeFlag,TTradeAmt,IBTAmt,TBankTradeTime,TBankTradeNo,TBankFinDate)=""
    s PrtPapminame="合计"
    s TTradeAmt=AllSSAmt,IBTAmt=AllYSAmt
    d outputrowpay 
    s qHandle=$lb(0,repid,0)
    quit $$$OK
outputrowpay
    s ^TMP("UDHCJFJudgeBankTradePay",Guser,job,ind)=ind_"^"_PrtPapmino_"^"_PrtPapminame_"^"_TBankNo_"^"_THopDr_"^"_TTrannelNo_"^"_TUserId_"^"_TBankCardNo_"^"_THISTradeTime_"^"_THISTradeNo_"^"_TTradeFlag_"^"_TTradeAmt_"^"_IBTAmt_"^"_TBankTradeTime_"^"_TBankTradeNo_"^"_TBankFinDate_"^"_TTradeNo_"^"_InvPrtRowid
    set Data=$lb(ind-1,PrtPapmino,PrtPapminame,TBankNo,THopDr,TTrannelNo,TUserId,TBankCardNo,THISTradeTime,THISTradeNo,TTradeFlag,TTradeAmt,IBTAmt,TBankTradeTime,TBankTradeNo,TBankFinDate,job,TTradeNo)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod JudgeCardCPPTradePayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = JudgeCardCPPTradePayExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

Query JudgeCardCPPTradePay(StDate, StTime, EndDate, EndTime, ChooseBankId) As %Query(ROWSPEC = "Tind:%String,TPrtPapmino:%String,TPrtPapminame:%String,TBankNo:%String,THopDr:%String,TTrannelNo:%String,TUserId:%String,TBankCardNo:%String,THISTradeTime:%String,THISTradeNo:%String,TTradeFlag:%String,TTradeAmt:%String,TIBTAmt:%String,TBankTradeTime:%String,TBankTradeNo:%String,TBankFinDate:%String,Tjob:%String,TTradeNo:%String")
{
}

/// w ##class(web.DHCOPBillFindBankTradeInfo).SaveProcessInfo(23545,2302740,"1^2^3^4^5^6^7")
ClassMethod SaveProcessInfo(Guser, job, IndStr)
{
    q:IndStr=""
    s FailureCount=0
    s IndStrLen=$l(IndStr,"^")
    f i=1:1:IndStrLen d
    .s ind=$p(IndStr,"^",i)
    .q:ind=""
    .q:$d(^TMP("UDHCJFJudgeBankTradePay",Guser,job,ind))=0
    .s BalanceInfo=^TMP("UDHCJFJudgeBankTradePay",Guser,job,ind)
    .k PLIST
    .s BalanceInfoLen=$l(BalanceInfo,"^")
    .f j=2:1:BalanceInfoLen d
    ..q:j>16             ;只取前16位的数据
    ..s PLIST(j)=$p(BalanceInfo,"^",j)
    .s PLIST(17)="Y"
    .s PLIST(18)=Guser
    .s PLIST(19)=+$h
    .s PLIST(20)=$p($h,",",2)
    .b ;ttt1
    .d ..tb()
    .s myRtn=..InsertBalanceSub()
    .s rtn=$p(myRtn,"^",1)
    .b ;tro
    .i +rtn=0 d
    ..d ..tc()
    .e  d
    ..Trollback
    ..s FailureCount=FailureCount+1

    q FailureCount
}

ClassMethod InsertBalanceSub()
{
    K PLIST(1)

    &sql(INSERT INTO DHC_INVBankBalanceSub Values PLIST())
    
    s myRowID=%ROWID
    q SQLCODE_"^"_myRowID
}

ClassMethod tb()
{
    n SQLCODE
    TSTART  s SQLCODE=$zu(34)
    q
}

ClassMethod tc()
{
    n SQLCODE
    TCOMMIT  s SQLCODE=$zu(34)
    q
}

Query JudgeBankTradePay(StDate, StTime, EndDate, EndTime) As %Query(ROWSPEC = "Tind:%String,TPrtPapmino:%String,TPrtPapminame:%String,TBankNo:%String,THopDr:%String,TTrannelNo:%String,TUserId:%String,TBankCardNo:%String,THISTradeTime:%String,THISTradeNo:%String,TTradeFlag:%String,TTradeAmt:%String,TIBTAmt:%String,TBankTradeTime:%String,TBankTradeNo:%String,TBankFinDate:%String,Tjob:%String")
{
}

/// tangtao
/// 2011-11-21
/// 对账，显示差错交易
/// d ##class(%ResultSet).RunQuery("web.DHCBillBankLogic","JudgeBankTradePay",62471,00000,62471,86399)
ClassMethod JudgeBankTradePayExecute(ByRef qHandle As %Binary, StDate, StTime, EndDate, EndTime) As %Status
{
    s repid=$I(^CacheTemp)
    set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
    set StTime=##class(websys.Conversions).TimeHtmlToLogical(StTime)
 	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	set EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)
    i (StDate="")!(EndDate="") Set qHandle=$lb(0,repid,0)   Quit $$$OK
    s ind=2
    s Guser=%session.Get("LOGON.USERID")
    s job=$j
    k ^TMPDHCINVBankBalance
    k ^TMP("UDHCJFJudgeBankTradePay",Guser,job)
    s ^TMP("UDHCJFJudgeBankTradePay",Guser,job,1)="1^登记号^姓名^银行代码^医院代码^渠道代码^交易操作员^银行卡号^HIS交易时间^HIS交易流水号^交易标志^应收金额^实收金额^银行交易时间^银行交易流水号^银行交易财务日期"
    ;TimeFlag=1  按HIS交易时间查询
    s TimeFlag="1"
    i TimeFlag="1" s TimeCode="HISDTIME"
    i TimeFlag="2" s TimeCode="BANKTRADETIME"
    i StTime="" s StTime="00000"
    i EndTime="" s EndTime="86399"
    ;s ^TMP("tt")=StDate_","_StTime_","_EndDate_","_EndTime
    i StTime'="" s IBTSTDATETIME=$tr(##class(websys.Conversions).DateLogicalToHtml(StDate),"-")_$tr(##class(websys.Conversions).TimeLogicalToHtml(StTime,1),":")
    e  s IBTSTDATETIME=$tr(##class(websys.Conversions).DateLogicalToHtml(StDate),"-")_"00001"
    i EndTime'="" s IBTENDDATETIME=$tr(##class(websys.Conversions).DateLogicalToHtml(EndDate),"-")_$tr(##class(websys.Conversions).TimeLogicalToHtml(EndTime,1),":")
    e  s IBTENDDATETIME=$tr(##class(websys.Conversions).DateLogicalToHtml(EndDate),"-")_"86399"
    
    s AllSSAmt=0,AllYSAmt=0
    i ((TimeFlag="1")!(TimeFlag="2")) d
    .s Rowid=""
    .f Date=StDate:1:EndDate d
    ..s PrtRowid=""
    ..f  s PrtRowid=$o(^DHCINVPRT(0,"Date",Date,PrtRowid)) q:PrtRowid=""  d
    ...s OldInvDr=$p(^DHCINVPRT(PrtRowid),"^",29)
    ...q:OldInvDr'=""
    ...s PrtFlag=0
    ...s InitInvDr=$p(^DHCINVPRT(PrtRowid),"^",13)
    ...i InitInvDr'="" d
    ....s InitInvAmt=$p(^DHCINVPRT(InitInvDr),"^",1)
    ....s PrtOldDr=$o(^DHCINVPRT(0,"OldINV",InitInvDr,""))
    ....i PrtOldDr'="" d
    .....s PrtOldDrAmt=$p(^DHCINVPRT(PrtOldDr),"^",1)
    .....i PrtOldDrAmt=InitInvAmt s PrtFlag=1
    ...q:PrtFlag=1
    ...s PapmiDr=$p(^DHCINVPRT(PrtRowid),"^",15)
    ...s PrtPapmino=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
    ...s PrtPapminame=$p(^PAPER(PapmiDr,"ALL"),"^",1)
    ...s PaymSub="",Flag=0
    ...f  s PaymSub=$o(^DHCINVPRT(PrtRowid,"P",PaymSub)) q:PaymSub=""  d
    ....q:PaymSub=0
    ....s PaymDr=$p(^DHCINVPRT(PrtRowid,"P",PaymSub),"^",1)
    ....s PaymAmt=$p(^DHCINVPRT(PrtRowid,"P",PaymSub),"^",3)
    ....s HandDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",PaymDr)
    ....i ((HandDr'="")&(PaymDr'=13)) d
    .....i +$g(PaymAmt)'=0 s Flag=1
    ...q:Flag=0
    ...s Rowid=""
    ...i $d(^DHCINVBTPi(0,"S","IPDR",PrtRowid))'=0 d
    ....s Rowid=$o(^DHCINVBTPi(0,"S","IPDR",PrtRowid,Rowid))
    ....s Rc=$p(^DHCINVBTP(Rowid),"^",1)
    ....q:Rc'="00"
    ....s HISTradeNo=$p(^DHCINVBTP(Rowid),"^",32)
    ....s TradeAmt=$p(^DHCINVBTP(Rowid),"^",4)
    ....s TradeAmt=+$g(TradeAmt)
    ....i HISTradeNo'="" d
    .....s IBTRowID=$o(^User.DHCINVBankBalanceI("TRADENO",HISTradeNo,""))
    .....i IBTRowID'="" d
    ......s IBTAmt=$LIST(^User.DHCINVBankBalanceD(IBTRowID),12)
    ......s IBTBankTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),5)
    ......s THISTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),7)
    ......s ^TMPDHCINVBankBalance(IBTRowID)=IBTRowID
    ......q:((HISTradeNo=THISTradeNo)&(TradeAmt=IBTAmt))
    ......s IBTAmt=$fn(IBTAmt/100,"",2)
    ......s TradeAmt=$fn(TradeAmt/100,"",2)
    ......s TBankNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),4)
    ......i +$g(TBankNo)=5 s TBankNo="软POS"
    ......s THopDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),9)
    ......i THopDr="1001" s THopDr="安徽省立医院"
    ......s TTrannelNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),15)
    ......i TTrannelNo="26" s TTrannelNo="门诊收费处"
    ......;s IBTTerminalNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),11)
    ......s IBTUserId=$LIST(^User.DHCINVBankBalanceD(IBTRowID),16)
    ......s TUserId=$p(^SSU("SSUSR",IBTUserId),"^",2)
    ......s TBankCardNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),1)
    ......s THISTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),8)
    ......s THISTradeTime=$e(THISTradeTime1,1,4)_"-"_$e(THISTradeTime1,5,6)_"-"_$e(THISTradeTime1,7,8)
    ......s THISTradeTime=THISTradeTime_" "_$e(THISTradeTime1,9,10)_":"_$e(THISTradeTime1,11,12)_":"_$e(THISTradeTime1,13,14)
    ......s IBTTradeFlag=$LIST(^User.DHCINVBankBalanceD(IBTRowID),13)
    ......s TTradeFlag=""
    ......i IBTTradeFlag=0 s TTradeFlag="扣费"
    ......i IBTTradeFlag=1 s TTradeFlag="退费"
    ......s IBTPaymodeDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),10)
    ......;s IBTPaymDesc=$p(^CT("CTPM",IBTPaymodeDr),"^",2)
    ......i IBTPaymodeDr=2 s IBTPaymDesc="软POS"
    ......i IBTPaymodeDr=1 s IBTPaymDesc="银医卡"
    ......s TBankTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),6)
    ......s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
    ......s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
    ......s TBankFinDate=$LIST(^User.DHCINVBankBalanceD(IBTRowID),3)
    ......s TBankFinDate=$e(TBankFinDate,1,4)_"-"_$e(TBankFinDate,5,6)_"-"_$e(TBankFinDate,7,8)
    ......s TTradeAmt=TradeAmt
    ......s TBankTradeNo=IBTBankTradeNo
    ......s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    ......d outputrowpay21
    .....e  d
    ......s TBankNo=$p(^DHCINVBTP(Rowid),"^",41)
    ......i TBankNo="" s TBankNo=05
    ......i +$g(TBankNo)=5 s TBankNo="软POS"
    ......s THopDr=$p(^DHCINVBTP(Rowid),"^",28)
    ......i THopDr'="" s THopDr=$p(^CT("HOSP",THopDr),"^",1)
    ......e  s THopDr="1001"
    ......i THopDr="1001" s THopDr="安徽省立医院"
    ......s TTrannelNo=$p(^DHCINVBTP(Rowid),"^",31)
    ......i TTrannelNo="5" s TTrannelNo="26"
    ......i TTrannelNo="26" s TTrannelNo="门诊收费处"
    ......i TTrannelNo="16" s TTrannelNo="门诊收费处"
    ......;s IBTTerminalNo=$p(^DHCINVBTP(Rowid),"^",41)
    ......s TUserId=$p(^DHCINVBTP(Rowid),"^",25)
    ......i TUserId'="" s TUserId=$p(^SSU("SSUSR",TUserId),"^",2)
    ......s TBankCardNo=$p(^DHCINVBTP(Rowid),"^",3)
    ......s THISTradeTime=$p(^DHCINVBTP(Rowid),"^",21)
    ......s THISTradeTime=##class(websys.Conversions).DateLogicalToHtml(THISTradeTime)
    ......s THISTradet=$p(^DHCINVBTP(Rowid),"^",22)
    ......s THISTradet=##class(websys.Conversions).TimeLogicalToHtml(THISTradet,1)
    ......s THISTradeTime=THISTradeTime_" "_THISTradet
    ......s THISTradeNo=$p(^DHCINVBTP(Rowid),"^",32)
    ......s TTradeFlag=$p(^DHCINVBTP(Rowid),"^",24)
    ......i TTradeFlag="C" s TTradeFlag="扣费"
    ......i ((TTradeFlag="R")!(TTradeFlag="D")) s TTradeFlag="退费"
    ......i TBankNo="05" s IBTPaymDesc="软POS"
    ......i ((+$g(TBankNo)=1)!(+$g(TBankNo)=2)!(+$g(TBankNo)=3)!(+$g(TBankNo)=4)) s IBTPaymDesc="银医卡"
    ......s TBankTradeTime1=$p(^DHCINVBTP(Rowid),"^",14)_$p(^DHCINVBTP(Rowid),"^",15)
    ......s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
    ......s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
    ......s TBankFinDate=""
    ......s TTradeAmt=$fn($p(^DHCINVBTP(Rowid),"^",23),"",2)
    ......s IBTAmt="0.00"
    ......s TBankTradeNo=$p(^DHCINVBTP(Rowid),"^",19)
    ......s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    ......d outputrowpay21
    ...e  d
    ....s TBankNo=""
    ....i TBankNo="" s TBankNo=05
    ....i +$g(TBankNo)=5 s TBankNo=""
    ....i +$g(TBankNo)=2 s TBankNo="中国农业银行"
    ....s THopDr=$o(^CT("HOSP",""))
    ....s THopDr=$p(^CT("HOSP",THopDr),"^",1)
    ....i THopDr="1001" s THopDr="安徽省立医院"
    ....s CTRowid=$p(^DHCINVPRT(PrtRowid),"^",40)
    ....s TTrannelNo=""
    ....i CTRowid'="" d 
    .....s TTrannelNo=$p(^CTLOC(CTRowid),"^",2)
    ....;s IBTTerminalNo=$p(^DHCINVBTP(Rowid),"^",41)
    ....s TUserId=$p(^DHCINVPRT(PrtRowid),"^",21)
    ....s TUserId=$p(^SSU("SSUSR",TUserId),"^",2)
    ....s PapmiDr=$p(^DHCINVPRT(PrtRowid),"^",15)
    ....s PrtPapmino=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
    ....s PrtPapminame=$p(^PAPER(PapmiDr,"ALL"),"^",1)
    ....s TBankCardNo=""
    ....s THISTradeTime=$p(^DHCINVPRT(PrtRowid),"^",5)
    ....s THISTradeTime=##class(websys.Conversions).DateLogicalToHtml(THISTradeTime)
    ....s THISTradet=$p(^DHCINVPRT(PrtRowid),"^",20)
    ....s THISTradet=##class(websys.Conversions).TimeLogicalToHtml(THISTradet,1)
    ....s THISTradeTime=THISTradeTime_" "_THISTradet
    ....s THISTradeNo=""
    ....i PaymAmt>0 s TTradeFlag="C"
    ....e  s TTradeFlag="R"
    ....i TTradeFlag="C" s TTradeFlag="扣费"
    ....i ((TTradeFlag="R")!(TTradeFlag="D")) s TTradeFlag="退费"
    ....i TBankNo="05" s IBTPaymDesc="软POS"
    ....i ((+$g(TBankNo)=1)!(+$g(TBankNo)=2)!(+$g(TBankNo)=3)!(+$g(TBankNo)=4)) s IBTPaymDesc="银医卡"
    ....s TBankTradeTime=""
    ....s TBankFinDate=""
    ....i PaymAmt<0 d
    .....s InitInvDr=$p(^DHCINVPRT(PrtRowid),"^",13)
    .....i InitInvDr'="" d
    ......s PrtOldDr=$o(^DHCINVPRT(0,"OldINV",InitInvDr,""))
    ......s TTradeAmt=..GetOPInvBankCardAmt(PrtOldDr_"|"_PrtRowid)
    ....e  d
    .....s TTradeAmt=$fn($zabs(PaymAmt),"",2)
    ....s IBTAmt="0.00"
    ....s TBankTradeNo=""
    ....s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    ....d outputrowpay21
    .s Date="",PrtPapmino="",PrtPapminame=""
    .i TimeFlag="1" s TimeCode="HISTIME"
    .i TimeFlag="2" s TimeCode="BANKTRADETIME"
    .f Date=IBTSTDATETIME:1:IBTENDDATETIME d
    ..s IBTRowID=""
    ..f  s IBTRowID=$o(^User.DHCINVBankBalanceI(TimeCode,Date,IBTRowID)) q:IBTRowID=""  d
    ...q:IBTRowID=0
    ...q:$d(^TMPDHCINVBankBalance(IBTRowID))=1
    ...s IBTPaymodeDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),10)
    ...;s IBTPaymDesc=$p(^CT("CTPM",IBTPaymodeDr),"^",2)
    ...i IBTPaymodeDr=2 s IBTPaymDesc="软POS"
    ...q:(IBTPaymodeDr'=2)
    ...s IBTAmt=$LIST(^User.DHCINVBankBalanceD(IBTRowID),12)
    ...s IBTBankTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),5)
    ...s THISTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),7)
    ...s IBPRowid=$o(^DHCINVBTPi(0,"PTN",THISTradeNo,""))
    ...s TRADEFlag="INV"
    ...i IBPRowid'="" d
    ....s TRADEFlag=$p(^DHCINVBTP(IBPRowid),"^",38)
    ...q:((TRADEFlag'="INV")&(TRADEFlag'=""))        ;过滤非门诊软POS交易
    ...s IBTAmt=$fn(IBTAmt/100,"",2)
    ...s TradeAmt="0.00"
    ...s TBankNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),4)
    ...i +$g(TBankNo)=5 s TBankNo="软POS"
    ...s THopDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),9)
    ...i THopDr="1001" s THopDr="安徽省立医院"
    ...s TTrannelNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),15)
    ...i TTrannelNo="26" s TTrannelNo="门诊收费处"
    ...i TTrannelNo="16" s TTrannelNo="门诊收费处"
    ...;s IBTTerminalNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),11)
    ...s IBTUserId=$LIST(^User.DHCINVBankBalanceD(IBTRowID),16)
    ...s TUserId=$p(^SSU("SSUSR",IBTUserId),"^",2)
    ...s TBankCardNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),2)
    ...s THISTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),8)
    ...s THISTradeTime=$e(THISTradeTime1,1,4)_"-"_$e(THISTradeTime1,5,6)_"-"_$e(THISTradeTime1,7,8)
    ...s THISTradeTime=THISTradeTime_" "_$e(THISTradeTime1,9,10)_":"_$e(THISTradeTime1,11,12)_":"_$e(THISTradeTime1,13,14)
    ...s IBTTradeFlag=$LIST(^User.DHCINVBankBalanceD(IBTRowID),13)
    ...s TTradeFlag=""
    ...i IBTTradeFlag=0 s TTradeFlag="扣费"
    ...i IBTTradeFlag=1 s TTradeFlag="退费"
    ...s TBankTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),6)
    ...s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
    ...s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
    ...s TBankFinDate=$LIST(^User.DHCINVBankBalanceD(IBTRowID),3)
    ...s TBankFinDate=$e(TBankFinDate,1,4)_"-"_$e(TBankFinDate,5,6)_"-"_$e(TBankFinDate,7,8)
    ...s TTradeAmt=TradeAmt
    ...s TBankTradeNo=IBTBankTradeNo
    ...s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    ...d outputrowpay21
    i StDate="62470" d           ;特殊处理
    .s DateStr=".3201201140857^.3201201140859^.3201201140900^.3201201140900^.3201201140903^.3201201140904^.3201201140950"
    .f i=1:1:7 d
    ..s Date=$p(DateStr,"^",i)
    ..s IBTRowID=$o(^User.DHCINVBankBalanceI("HISTIME",Date,0))
    ..q:IBTRowID=0
    ..q:$d(^TMPDHCINVBankBalance(IBTRowID))=1
    ..s IBTPaymodeDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),10)
    ..s IBTPaymDesc=""
    ..i IBTPaymodeDr=2 s IBTPaymDesc="软POS"
    ..s IBTAmt=$LIST(^User.DHCINVBankBalanceD(IBTRowID),12)
    ..s IBTBankTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),5)
    ..s THISTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),7)
    ..s IBTAmt=$fn(IBTAmt/100,"",2)
    ..s TradeAmt="0.00"
    ..s TBankNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),4)
    ..i +$g(TBankNo)=5 s TBankNo="软POS"
    ..s THopDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),9)
    ..i THopDr="1001" s THopDr="安徽省立医院"
    ..s TTrannelNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),15)
    ..i TTrannelNo="26" s TTrannelNo="门诊收费处"
    ..i TTrannelNo="16" s TTrannelNo="门诊收费处"
    ..;s IBTTerminalNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),11)
    ..s IBTUserId=$LIST(^User.DHCINVBankBalanceD(IBTRowID),16)
    ..s TUserId=$p(^SSU("SSUSR",IBTUserId),"^",2)
    ..s TBankCardNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),2)
    ..s THISTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),8)
    ..s THISTradeTime1=$e(THISTradeTime1,3,$l(THISTradeTime1))
    ..s THISTradeTime=$e(THISTradeTime1,1,4)_"-"_$e(THISTradeTime1,5,6)_"-"_$e(THISTradeTime1,7,8)
    ..s THISTradeTime=THISTradeTime_" "_$e(THISTradeTime1,9,10)_":"_$e(THISTradeTime1,11,12)_":"_$e(THISTradeTime1,13,14)
    ..s IBTTradeFlag=$LIST(^User.DHCINVBankBalanceD(IBTRowID),13)
    ..s TTradeFlag=""
    ..i IBTTradeFlag=0 s TTradeFlag="扣费"
    ..i IBTTradeFlag=1 s TTradeFlag="退费"
    ..s TBankTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),6)
    ..s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
    ..s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
    ..s TBankFinDate=$LIST(^User.DHCINVBankBalanceD(IBTRowID),3)
    ..s TBankFinDate=$e(TBankFinDate,1,4)_"-"_$e(TBankFinDate,5,6)_"-"_$e(TBankFinDate,7,8)
    ..s TTradeAmt=TradeAmt
    ..s TBankTradeNo=IBTBankTradeNo
    ..s THopDr="安徽省立医院"
    ..s TBankNo="软POS"
    ..s THISTradeNo="异常"
    ..s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    ..d outputrowpay21
    s (PrtPapmino,PrtPapminame,TBankNo,THopDr,TTrannelNo,TUserId,TBankCardNo,THISTradeTime,THISTradeNo,TTradeFlag,TTradeAmt,IBTAmt,TBankTradeTime,TBankTradeNo,TBankFinDate)=""
    s PrtPapminame="合计"
    s TTradeAmt=AllSSAmt,IBTAmt=AllYSAmt
    d outputrowpay21
    s qHandle=$lb(0,repid,0)
    quit $$$OK
outputrowpay21
    s ^TMP("UDHCJFJudgeBankTradePay",Guser,job,ind)=ind_"^"_PrtPapmino_"^"_PrtPapminame_"^"_TBankNo_"^"_THopDr_"^"_TTrannelNo_"^"_TUserId_"^"_TBankCardNo_"^"_THISTradeTime_"^"_THISTradeNo_"^"_TTradeFlag_"^"_TTradeAmt_"^"_IBTAmt_"^"_TBankTradeTime_"^"_TBankTradeNo_"^"_TBankFinDate
    ;set Data=$lb(ind,TBankNo,THopDr,TTrannelNo,TUserId,TBankCardNo,THISTradeTime,THISTradeNo,TTradeFlag,TBankTradeTime,TBankFinDate,TTradeAmt,TBankTradeNo,job,IBTAmt)
    set Data=$lb(ind-1,PrtPapmino,PrtPapminame,TBankNo,THopDr,TTrannelNo,TUserId,TBankCardNo,THISTradeTime,THISTradeNo,TTradeFlag,TTradeAmt,IBTAmt,TBankTradeTime,TBankTradeNo,TBankFinDate,job)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod JudgeBankTradePayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = JudgeBankTradePayExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod JudgeBankTradePayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = JudgeBankTradePayExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Lid
/// 2011-03-03
/// 根据门诊发票表Rowid获取银医卡支付金
ClassMethod GetOPInvBankCardAmt(rowidStr)
{
    ;
    n (rowidStr)
    s amt=0.00
    s num=$l(rowidStr,"|")
    f i=1:1:num d
    .s rowid=$p(rowidStr,"|",i)
    .q:rowid=""
    .s IPM="0"
    .q:'$d(^DHCINVPRT(rowid,"P",IPM))
    .f  s IPM=$o(^DHCINVPRT(rowid,"P",IPM)) q:IPM=""  d
    ..s s=$g(^DHCINVPRT(rowid,"P",IPM))
    ..s payMDr=$p(s,"^",1)
    ..s payMCode=$p(^CT("CTPM",payMDr),"^",1)
    ..s payMAmt=+$p(s,"^",3)
    ..s handDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",payMDr)
    ..i handDr'="" d
    ...s amt=amt+payMAmt
    s amt=$fn($zabs(amt),"",2)
    
    q amt
}

ClassMethod JudgeBankTradePayIPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = JudgeBankTradePayIPExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod JudgeBankTradePayIPExecute(ByRef qHandle As %Binary, StDate, StTime, EndDate, EndTime) As %Status
{
    s repid=$I(^CacheTemp)
    s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
    s StTime=##class(websys.Conversions).TimeHtmlToLogical(StTime)
    s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)
    
    i (StDate="")!(EndDate="") Set qHandle=$lb(0,repid,0)   Quit $$$OK
    s ind=2
    s Guser=%session.Get("LOGON.USERID")
    s job=$j
    ;d ##class(%ResultSet).RunQuery("web.DHCOPBillFindBankTradeInfo","JudgeBankTradePayIP",62508,00000,62508,86399)
    ;d ##class(%ResultSet).RunQuery("web.DHCOPBillFindBankTradeInfo","JudgeBankTradePayIP",62509,00000,62509,86399)
    k ^TMPDHCINVBankBalance
    k ^TMP("UDHCJFJudgeBankTradePay",Guser,job)
    s ^TMP("UDHCJFJudgeBankTradePay",Guser,job,1)="1^登记号^姓名^银行代码^医院代码^渠道代码^交易操作员^银行卡号^HIS交易时间^HIS交易流水号^交易标志^应收金额^实收金额^银行交易时间^银行交易流水号^银行交易财务日期"
    ;TimeFlag=1  按HIS交易时间查询
    s TimeFlag="1"
    i TimeFlag="1" s TimeCode="HISDTIME"
    i TimeFlag="2" s TimeCode="BANKTRADETIME"
    i StTime="" s StTime="00000"
    i EndTime="" s EndTime="86399"
    s ^TMP("tt")=StDate_","_StTime_","_EndDate_","_EndTime
    i StTime'="" s IBTSTDATETIME=$tr(##class(websys.Conversions).DateLogicalToHtml(StDate),"-")_$tr(##class(websys.Conversions).TimeLogicalToHtml(StTime,1),":")
    e  s IBTSTDATETIME=$tr(##class(websys.Conversions).DateLogicalToHtml(StDate),"-")_"00001"
    i EndTime'="" s IBTENDDATETIME=$tr(##class(websys.Conversions).DateLogicalToHtml(EndDate),"-")_$tr(##class(websys.Conversions).TimeLogicalToHtml(EndTime,1),":")
    e  s IBTENDDATETIME=$tr(##class(websys.Conversions).DateLogicalToHtml(EndDate),"-")_"86399"
    
    s AllSSAmt=0,AllYSAmt=0
    i ((TimeFlag="1")!(TimeFlag="2")) d
    .s Rowid=""
    .f Date=StDate:1:EndDate d
    ..;住院发票
    ..s PrtRowid=""
    ..f  s PrtRowid=$o(^DHCINVPRTZY(0,"DATE",Date,PrtRowid)) q:PrtRowid=""  d
    ...s InitInvDr=$p(^DHCINVPRTZY(PrtRowid),"^",13)
    ...q:InitInvDr'=""
    ...s PBRowid=$p(^DHCINVPRTZY(PrtRowid),"^",5)
    ...s Paadm=$p(^DHCINVPRTZY(PrtRowid),"^",4)
    ...s Papmidr=$p(^PAADM(Paadm),"^",1)
    ...s PrtPapmino=$p(^PAPER(Papmidr,"PAT",1),"^",1)
    ...s PrtPapminame=$p(^PAPER(Papmidr,"ALL"),"^",1)
    ...s ARRcptrowid=$o(^ARRCP("ARPBL",PBRowid,""))
    ...s RcptSub="",Flag=0,ARPayMStr=""
    ...f  s RcptSub=$o(^ARRCP(ARRcptrowid,"PAYM",RcptSub)) q:RcptSub=""  d
    ....q:RcptSub=0
    ....s PaymDr=$p(^ARRCP(ARRcptrowid,"PAYM",RcptSub),"^",1)
    ....s PaymAmt=$p(^ARRCP(ARRcptrowid,"PAYM",RcptSub),"^",3)
    ....s HandDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("IP",PaymDr)
    ....i ((HandDr'="")&(PaymDr'=13)) d
    .....i +$g(PaymAmt)'=0 d
    ......s Flag=1
    ......i ARPayMStr="" s ARPayMStr=ARRcptrowid_"||"_RcptSub
    ......e  s ARPayMStr=ARPayMStr_"^"_ARRcptrowid_"||"_RcptSub     ;关键,保存住院支付方式
    ...q:((Flag=0)!(ARPayMStr=""))
    ...s ARPayMLen=$l(ARPayMStr,"^")
    ...f x=1:1:ARPayMLen d
    ....s RcptRowid=$p(ARPayMStr,"^",x)
    ....s Rowid=""
    ....i $d(^DHCIPINVBANKTRADESUB(0,"ARPayM",RcptRowid))'=0 d
    .....s Rowid=$o(^DHCIPINVBANKTRADESUB(0,"ARPayM",RcptRowid,Rowid))
    .....s Rc=$p(^DHCINVBTP(Rowid),"^",1)
    .....q:Rc'="00"
    .....s HISTradeNo=$p(^DHCINVBTP(Rowid),"^",32)
    .....s TradeAmt=$p(^DHCINVBTP(Rowid),"^",4)
    .....s TradeAmt=+$g(TradeAmt)
    .....i HISTradeNo'="" d
    ......s IBTRowID=$o(^User.DHCINVBankBalanceI("TRADENO",HISTradeNo,""))
    ......i IBTRowID'="" d
    .......s IBTAmt=$LIST(^User.DHCINVBankBalanceD(IBTRowID),12)
    .......s IBTBankTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),5)
    .......s THISTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),7)
    .......s ^TMPDHCINVBankBalance(IBTRowID)=IBTRowID
    .......q:((HISTradeNo=THISTradeNo)&(TradeAmt=IBTAmt))
    .......s IBTAmt=$fn(IBTAmt/100,"",2)
    .......s TradeAmt=$fn(TradeAmt/100,"",2)
    .......s TBankNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),4)
    .......i +$g(TBankNo)=5 s TBankNo="软POS"
    .......s THopDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),9)
    .......i THopDr="1001" s THopDr="安徽省立医院"
    .......s TTrannelNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),15)
    .......s TTrannelNo="出院处"
    .......;s IBTTerminalNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),11)
    .......s IBTUserId=$LIST(^User.DHCINVBankBalanceD(IBTRowID),16)
    .......s TUserId=$p(^SSU("SSUSR",IBTUserId),"^",2)
    .......s TBankCardNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),1)
    .......s THISTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),8)
    .......s THISTradeTime=$e(THISTradeTime1,1,4)_"-"_$e(THISTradeTime1,5,6)_"-"_$e(THISTradeTime1,7,8)
    .......s THISTradeTime=THISTradeTime_" "_$e(THISTradeTime1,9,10)_":"_$e(THISTradeTime1,11,12)_":"_$e(THISTradeTime1,13,14)
    .......s IBTTradeFlag=$LIST(^User.DHCINVBankBalanceD(IBTRowID),13)
    .......s TTradeFlag=""
    .......i IBTTradeFlag=0 s TTradeFlag="扣费"
    .......i IBTTradeFlag=1 s TTradeFlag="退费"
    .......s IBTPaymodeDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),10)
    .......;s IBTPaymDesc=$p(^CT("CTPM",IBTPaymodeDr),"^",2)
    .......i IBTPaymodeDr=2 s IBTPaymDesc="软POS"
    .......i IBTPaymodeDr=1 s IBTPaymDesc="银医卡"
    .......s TBankTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),6)
    .......s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
    .......s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
    .......s TBankFinDate=$LIST(^User.DHCINVBankBalanceD(IBTRowID),3)
    .......s TBankFinDate=$e(TBankFinDate,1,4)_"-"_$e(TBankFinDate,5,6)_"-"_$e(TBankFinDate,7,8)
    .......s TTradeAmt=TradeAmt
    .......s TBankTradeNo=IBTBankTradeNo
    .......s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    .......d outputrowpay22
    ......e  d
    .......s TBankNo=$p(^DHCINVBTP(Rowid),"^",41)
    .......i TBankNo="" s TBankNo=05
    .......i +$g(TBankNo)=5 s TBankNo="软POS"
    .......s THopDr=$p(^DHCINVBTP(Rowid),"^",28)
    .......i THopDr'="" s THopDr=$p(^CT("HOSP",THopDr),"^",1)
    .......e  s THopDr="1001"
    .......i THopDr="1001" s THopDr="安徽省立医院"
    .......s TTrannelNo="出院处"
    .......;s IBTTerminalNo=$p(^DHCINVBTP(Rowid),"^",41)
    .......s TUserId=$p(^DHCINVBTP(Rowid),"^",25)
    .......i TUserId'="" s TUserId=$p(^SSU("SSUSR",TUserId),"^",2)
    .......s TBankCardNo=$p(^DHCINVBTP(Rowid),"^",3)
    .......s THISTradeTime=$p(^DHCINVBTP(Rowid),"^",21)
    .......s THISTradeTime=##class(websys.Conversions).DateLogicalToHtml(THISTradeTime)
    .......s THISTradet=$p(^DHCINVBTP(Rowid),"^",22)
    .......s THISTradet=##class(websys.Conversions).TimeLogicalToHtml(THISTradet,1)
    .......s THISTradeTime=THISTradeTime_" "_THISTradet
    .......s THISTradeNo=$p(^DHCINVBTP(Rowid),"^",32)
    .......s TTradeFlag=$p(^DHCINVBTP(Rowid),"^",24)
    .......i TTradeFlag="C" s TTradeFlag="扣费"
    .......i ((TTradeFlag="R")!(TTradeFlag="D")) s TTradeFlag="退费"
    .......i TBankNo="05" s IBTPaymDesc="软POS"
    .......i ((+$g(TBankNo)=1)!(+$g(TBankNo)=2)!(+$g(TBankNo)=3)!(+$g(TBankNo)=4)) s IBTPaymDesc="银医卡"
    .......s TBankTradeTime1=$p(^DHCINVBTP(Rowid),"^",14)_$p(^DHCINVBTP(Rowid),"^",15)
    .......s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
    .......s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
    .......s TBankFinDate=""
    .......s TTradeAmt=$fn($p(^DHCINVBTP(Rowid),"^",23),"",2)
    .......s IBTAmt="0.00"
    .......s TBankTradeNo=$p(^DHCINVBTP(Rowid),"^",19)
    .......s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    .......d outputrowpay22
    ....e  d
    .....s TBankNo=05
    .....i +$g(TBankNo)=5 s TBankNo=""
    .....i +$g(TBankNo)=2 s TBankNo="中国农业银行"
    .....s THopDr=1
    .....s THopDr=$p(^CT("HOSP",THopDr),"^",1)
    .....i THopDr="1001" s THopDr="安徽省立医院"
    .....s TTrannelNo="出院处"
    .....;s IBTTerminalNo=$p(^DHCINVBTP(Rowid),"^",41)
    .....s TUserId=$p(^DHCINVPRTZY(PrtRowid),"^",7)
    .....s TUserId=$p(^SSU("SSUSR",TUserId),"^",2)
    .....s TBankCardNo=""
    .....s THISTradeTime=$p(^DHCINVPRTZY(PrtRowid),"^",2)
    .....s THISTradeTime=##class(websys.Conversions).DateLogicalToHtml(THISTradeTime)
    .....s THISTradet=$p(^DHCINVPRTZY(PrtRowid),"^",3)
    .....s THISTradet=##class(websys.Conversions).TimeLogicalToHtml(THISTradet,1)
    .....s THISTradeTime=THISTradeTime_" "_THISTradet
    .....s THISTradeNo=""
    .....s ARPayMLen=$l(ARPayMStr,"^")
    .....f x=1:1:ARPayMLen d
    ......s RcptRowid=$p(ARPayMStr,"^",x)
    ......s PaymAmt=$p(^ARRCP($p(RcptRowid,"||",1),"PAYM",$p(RcptRowid,"||",2)),"^",3)
    ......i PaymAmt>0 s TTradeFlag="C"
    ......e  s TTradeFlag="R"
    ......i TTradeFlag="C" s TTradeFlag="扣费"
    ......i ((TTradeFlag="R")!(TTradeFlag="D")) s TTradeFlag="退费"
    ......i TBankNo="05" s IBTPaymDesc="软POS"
    ......s TBankTradeTime=""
    ......s TBankFinDate=""
    ......s TTradeAmt=$fn($zabs(PaymAmt),"",2)
    ......s IBTAmt="0.00"
    ......s TBankTradeNo=""
    ......s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    ......d outputrowpay22
    ..;预交金
    ..s PrtRowid=""
    ..f  s PrtRowid=$o(^DHCSFPRINTDETAIL(0,"PrtDate",Date,PrtRowid)) q:PrtRowid=""  d
    ...q:((PrtRowid="774140")!(PrtRowid="774142"))
    ...q:((PrtRowid="775708")!(PrtRowid="775709"))
    ...s PaymDr=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",9)
    ...s PaymAmt=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",6)
    ...s PrtFlag=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",8)
    ...s Paadm=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",4)
    ...s Papmidr=$p(^PAADM(Paadm),"^",1)
    ...s PrtPapmino=$p(^PAPER(Papmidr,"PAT",1),"^",1)
    ...s PrtPapminame=$p(^PAPER(Papmidr,"ALL"),"^",1)
    ...s Flag=0
    ...s HandDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("IP",PaymDr)
    ...i ((HandDr'="")&(PaymDr'=13)) d
    ....i +$g(PaymAmt)'=0 d
    .....s Flag=1
    ...q:(Flag=0)
    ...q:PrtFlag="2"
    ...s Rowid=""
    ...i $d(^DHCIPRCPTBANKTRADESUB(0,"DepositDr",PrtRowid))'=0 d
    ....s Rowid=$o(^DHCIPRCPTBANKTRADESUB(0,"DepositDr",PrtRowid,Rowid))
    ....s Rc=$p(^DHCINVBTP(Rowid),"^",1)
    ....q:Rc'="00"
    ....s HISTradeNo=$p(^DHCINVBTP(Rowid),"^",32)
    ....s TradeAmt=$p(^DHCINVBTP(Rowid),"^",4)
    ....s TradeAmt=+$g(TradeAmt)
    ....i HISTradeNo'="" d
    .....s IBTRowID=$o(^User.DHCINVBankBalanceI("TRADENO",HISTradeNo,""))
    .....i IBTRowID'="" d
    ......s IBTAmt=$LIST(^User.DHCINVBankBalanceD(IBTRowID),12)
    ......s IBTBankTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),5)
    ......s THISTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),7)
    ......s ^TMPDHCINVBankBalance(IBTRowID)=IBTRowID
    ......q:((HISTradeNo=THISTradeNo)&(TradeAmt=IBTAmt))
    ......s IBTAmt=$fn(IBTAmt/100,"",2)
    ......s TradeAmt=$fn(TradeAmt/100,"",2)
    ......s TBankNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),4)
    ......i +$g(TBankNo)=5 s TBankNo="软POS"
    ......s THopDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),9)
    ......i THopDr="1001" s THopDr="安徽省立医院"
    ......s TTrannelNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),15)
    ......s TTrannelNo="住院处"
    ......;s IBTTerminalNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),11)
    ......s IBTUserId=$LIST(^User.DHCINVBankBalanceD(IBTRowID),16)
    ......s TUserId=$p(^SSU("SSUSR",IBTUserId),"^",2)
    ......s TBankCardNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),1)
    ......s THISTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),8)
    ......s THISTradeTime=$e(THISTradeTime1,1,4)_"-"_$e(THISTradeTime1,5,6)_"-"_$e(THISTradeTime1,7,8)
    ......s THISTradeTime=THISTradeTime_" "_$e(THISTradeTime1,9,10)_":"_$e(THISTradeTime1,11,12)_":"_$e(THISTradeTime1,13,14)
    ......s IBTTradeFlag=$LIST(^User.DHCINVBankBalanceD(IBTRowID),13)
    ......s TTradeFlag=""
    ......i IBTTradeFlag=0 s TTradeFlag="扣费"
    ......i IBTTradeFlag=1 s TTradeFlag="退费"
    ......s IBTPaymodeDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),10)
    ......;s IBTPaymDesc=$p(^CT("CTPM",IBTPaymodeDr),"^",2)
    ......i IBTPaymodeDr=2 s IBTPaymDesc="软POS"
    ......i IBTPaymodeDr=1 s IBTPaymDesc="银医卡"
    ......s TBankTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),6)
    ......s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
    ......s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
    ......s TBankFinDate=$LIST(^User.DHCINVBankBalanceD(IBTRowID),3)
    ......s TBankFinDate=$e(TBankFinDate,1,4)_"-"_$e(TBankFinDate,5,6)_"-"_$e(TBankFinDate,7,8)
    ......s TTradeAmt=TradeAmt
    ......s TBankTradeNo=IBTBankTradeNo
    ......s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    ......d outputrowpay22
    .....e  d
    ......s TBankNo=$p(^DHCINVBTP(Rowid),"^",41)
    ......i TBankNo="" s TBankNo=05
    ......i +$g(TBankNo)=5 s TBankNo="软POS"
    ......s THopDr=$p(^DHCINVBTP(Rowid),"^",28)
    ......i THopDr'="" s THopDr=$p(^CT("HOSP",THopDr),"^",1)
    ......e  s THopDr="1001"
    ......i THopDr="1001" s THopDr="安徽省立医院"
    ......s TTrannelNo="住院处"
    ......;s IBTTerminalNo=$p(^DHCINVBTP(Rowid),"^",41)
    ......s TUserId=$p(^DHCINVBTP(Rowid),"^",25)
    ......i TUserId'="" s TUserId=$p(^SSU("SSUSR",TUserId),"^",2)
    ......s TBankCardNo=$p(^DHCINVBTP(Rowid),"^",3)
    ......s THISTradeTime=$p(^DHCINVBTP(Rowid),"^",21)
    ......s THISTradeTime=##class(websys.Conversions).DateLogicalToHtml(THISTradeTime)
    ......s THISTradet=$p(^DHCINVBTP(Rowid),"^",22)
    ......s THISTradet=##class(websys.Conversions).TimeLogicalToHtml(THISTradet,1)
    ......s THISTradeTime=THISTradeTime_" "_THISTradet
    ......s THISTradeNo=$p(^DHCINVBTP(Rowid),"^",32)
    ......s TTradeFlag=$p(^DHCINVBTP(Rowid),"^",24)
    ......i TTradeFlag="C" s TTradeFlag="扣费"
    ......i ((TTradeFlag="R")!(TTradeFlag="D")) s TTradeFlag="退费"
    ......i TBankNo="05" s IBTPaymDesc="软POS"
    ......i ((+$g(TBankNo)=1)!(+$g(TBankNo)=2)!(+$g(TBankNo)=3)!(+$g(TBankNo)=4)) s IBTPaymDesc="银医卡"
    ......s TBankTradeTime1=$p(^DHCINVBTP(Rowid),"^",14)_$p(^DHCINVBTP(Rowid),"^",15)
    ......s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
    ......s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
    ......s TBankFinDate=""
    ......s TTradeAmt=$fn($p(^DHCINVBTP(Rowid),"^",23),"",2)
    ......s IBTAmt="0.00"
    ......s TBankTradeNo=$p(^DHCINVBTP(Rowid),"^",19)
    ......s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    ......d outputrowpay22
    ...e  d
    ....s TBankNo=05
    ....i +$g(TBankNo)=5 s TBankNo=""
    ....i +$g(TBankNo)=2 s TBankNo="中国农业银行"
    ....s THopDr=1
    ....s THopDr=$p(^CT("HOSP",THopDr),"^",1)
    ....i THopDr="1001" s THopDr="安徽省立医院"
    ....s TTrannelNo="住院处"
    ....;s IBTTerminalNo=$p(^DHCINVBTP(Rowid),"^",41)
    ....s TUserId=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",14)
    ....s TUserId=$p(^SSU("SSUSR",TUserId),"^",2)
    ....s TBankCardNo=""
    ....s THISTradeTime=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",2)
    ....s THISTradeTime=##class(websys.Conversions).DateLogicalToHtml(THISTradeTime)
    ....s THISTradet=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",3)
    ....s THISTradet=##class(websys.Conversions).TimeLogicalToHtml(THISTradet,1)
    ....s THISTradeTime=THISTradeTime_" "_THISTradet
    ....s THISTradeNo=""
    ....i PaymAmt>0 s TTradeFlag="C"
    ....e  s TTradeFlag="R"
    ....i TTradeFlag="C" s TTradeFlag="扣费"
    ....i ((TTradeFlag="R")!(TTradeFlag="D")) s TTradeFlag="退费"
    ....i TBankNo="05" s IBTPaymDesc="软POS"
    ....s TBankTradeTime=""
    ....s TBankFinDate=""
    ....s TTradeAmt=$fn($zabs(PaymAmt),"",2)
    ....s IBTAmt="0.00"
    ....s TBankTradeNo=""
    ....s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    ....d outputrowpay22
    .s Date="",PrtPapmino="",PrtPapminame=""
    .i TimeFlag="1" s TimeCode="HISTIME"
    .i TimeFlag="2" s TimeCode="BANKTRADETIME"
    .f Date=IBTSTDATETIME:1:IBTENDDATETIME d
    ..s IBTRowID=""
    ..f  s IBTRowID=$o(^User.DHCINVBankBalanceI(TimeCode,Date,IBTRowID)) q:IBTRowID=""  d
    ...q:IBTRowID=0
    ...q:$d(^TMPDHCINVBankBalance(IBTRowID))=1
    ...s IBTPaymodeDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),10)
    ...;s IBTPaymDesc=$p(^CT("CTPM",IBTPaymodeDr),"^",2)
    ...i IBTPaymodeDr=2 s IBTPaymDesc="软POS"
    ...q:(IBTPaymodeDr'=2)
    ...s IBTAmt=$LIST(^User.DHCINVBankBalanceD(IBTRowID),12)
    ...s IBTBankTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),5)
    ...s THISTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),7)
    ...s IBPRowid=$o(^DHCINVBTPi(0,"PTN",THISTradeNo,""))
    ...s TRADEFlag=""
    ...i IBPRowid'="" d
    ....s TRADEFlag=$p(^DHCINVBTP(IBPRowid),"^",38)
    ...q:((TRADEFlag="INV")&(TRADEFlag'=""))        ;过滤非住院软POS交易
    ...s Rc=$p(^DHCINVBTP(IBPRowid),"^",1)
    ...q:Rc'="00"
    ...s IBTAmt=$fn(IBTAmt/100,"",2)
    ...s TradeAmt="0.00"
    ...s TBankNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),4)
    ...i +$g(TBankNo)=5 s TBankNo="软POS"
    ...s THopDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),9)
    ...i THopDr="1001" s THopDr="安徽省立医院"
    ...s TTrannelNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),15)
    ...s TTrannelNo=""
    ...;s IBTTerminalNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),11)
    ...s IBTUserId=$LIST(^User.DHCINVBankBalanceD(IBTRowID),16)
    ...s TUserId=$p(^SSU("SSUSR",IBTUserId),"^",2)
    ...s TBankCardNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),2)
    ...s THISTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),8)
    ...s THISTradeTime=$e(THISTradeTime1,1,4)_"-"_$e(THISTradeTime1,5,6)_"-"_$e(THISTradeTime1,7,8)
    ...s THISTradeTime=THISTradeTime_" "_$e(THISTradeTime1,9,10)_":"_$e(THISTradeTime1,11,12)_":"_$e(THISTradeTime1,13,14)
    ...s IBTTradeFlag=$LIST(^User.DHCINVBankBalanceD(IBTRowID),13)
    ...s TTradeFlag=""
    ...i IBTTradeFlag=0 s TTradeFlag="扣费"
    ...i IBTTradeFlag=1 s TTradeFlag="退费"
    ...s TBankTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),6)
    ...s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
    ...s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
    ...s TBankFinDate=$LIST(^User.DHCINVBankBalanceD(IBTRowID),3)
    ...s TBankFinDate=$e(TBankFinDate,1,4)_"-"_$e(TBankFinDate,5,6)_"-"_$e(TBankFinDate,7,8)
    ...s TTradeAmt=TradeAmt
    ...s TBankTradeNo=IBTBankTradeNo
    ...s AllSSAmt=AllSSAmt+$g(TTradeAmt),AllYSAmt=AllYSAmt+$g(IBTAmt)
    ...d outputrowpay22
    s (PrtPapmino,PrtPapminame,TBankNo,THopDr,TTrannelNo,TUserId,TBankCardNo,THISTradeTime,THISTradeNo,TTradeFlag,TTradeAmt,IBTAmt,TBankTradeTime,TBankTradeNo,TBankFinDate)=""
    s PrtPapminame="合计"
    s TTradeAmt=AllSSAmt,IBTAmt=AllYSAmt
    d outputrowpay22
    s qHandle=$lb(0,repid,0)
    quit $$$OK
outputrowpay22
    ;"1^登记号^姓名^银行代码^医院代码^渠道代码^交易操作员^银行卡号^HIS交易时间^HIS交易流水号^交易标志^应收金额^实收金额^银行交易时间^银行交易流水号^银行交易财务日期"
    s ^TMP("UDHCJFJudgeBankTradePay",Guser,job,ind)=ind_"^"_PrtPapmino_"^"_PrtPapminame_"^"_TBankNo_"^"_THopDr_"^"_TTrannelNo_"^"_TUserId_"^"_TBankCardNo_"^"_THISTradeTime_"^"_THISTradeNo_"^"_TTradeFlag_"^"_TTradeAmt_"^"_IBTAmt_"^"_TBankTradeTime_"^"_TBankTradeNo_"^"_TBankFinDate
    ;set Data=$lb(ind,TBankNo,THopDr,TTrannelNo,TUserId,TBankCardNo,THISTradeTime,THISTradeNo,TTradeFlag,TBankTradeTime,TBankFinDate,TTradeAmt,TBankTradeNo,job,IBTAmt)
    set Data=$lb(ind-1,PrtPapmino,PrtPapminame,TBankNo,THopDr,TTrannelNo,TUserId,TBankCardNo,THISTradeTime,THISTradeNo,TTradeFlag,TTradeAmt,IBTAmt,TBankTradeTime,TBankTradeNo,TBankFinDate,job)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod JudgeBankTradePayIPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = JudgeBankTradePayIPExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

Query JudgeBankTradePayIP(StDate, StTime, EndDate, EndTime) As %Query(ROWSPEC = "Tind:%String,TPrtPapmino:%String,TPrtPapminame:%String,TBankNo:%String,THopDr:%String,TTrannelNo:%String,TUserId:%String,TBankCardNo:%String,THISTradeTime:%String,THISTradeNo:%String,TTradeFlag:%String,TTradeAmt:%String,TIBTAmt:%String,TBankTradeTime:%String,TBankTradeNo:%String,TBankFinDate:%String,Tjob:%String")
{
}

ClassMethod GetNowTime()
{
    s PreTime="00:00:00"
    ;s NowTime=$zt($p($h,",",2),1)
    s NowTime="23:59:59"
    q PreTime_"^"_NowTime
}

ClassMethod GetNum(Guser, job)
{
    q:$d(^TMP("UDHCJFJudgeBankTradePay",Guser,job))=0 "0"
    s num=$o(^TMP("UDHCJFJudgeBankTradePay",Guser,job,""),-1)
    q num
}

ClassMethod GetStr(Guser, job, num)
{
    s str=^TMP("UDHCJFJudgeBankTradePay",Guser,job,num)
    q str
}

}
