/// 2018-7-3 
/// 门诊收费员工作量统计
Class web.DHCOPBillWorkLoad Extends %RegisteredObject
{

/// do ##class(%ResultSet).RunQuery("web.DHCOPBillWorkLoad","GetWorkStat","","2021-06-28","2021-07-08","00:00:00","23:59:59","N","2")
Query GetWorkStat(UserRowId As %String, StDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, DateFlag As %String, HOSPID As %String) As websys.Query(ROWSPEC = "TUserCode:%String,TUserName:%String:收费员,TBuildCardNum:%Integer:建卡数,TBuildCardAmt:%Float:建卡金额,TCancelCardNum:%Integer:退卡数,TCancelCardAmt:%Float:退卡金额,TRegNum:%Integer:挂号数,TRegAmt:%Float:挂号金额,TBackNum:%Integer:退号数,TBackAmt:%Float:退号金额,TAccPayNum:%Integer:收预交金笔数,TAccPayAmt:%Float:收预交金金额,TAccFootNum:%Integer:账户结算笔数,TAccFootAmt:%Float:账户结算金额,TAccTransNum:%Integer:预交金转账笔数,TAccTransAmt:%Float:预交金转账金额,TPayNum:%Integer:收费笔数,TPayAmt:%Float:收费金额,TRefundNum:%Integer:退费笔数,TRefundAmt:%Float:退费金额,TAbortCardNum:%Integer:卡作废笔数,TRecCardNum:%Integer:卡回收笔数,TLossCardNum:%Float:卡挂失笔数,TINSURegNum:%Integer:医保挂号数,TZFRegNum:%Integer:非医保挂号数,TINSURegAmt:%Float:医保挂号金额,TZFRegAmt:%Float:非医保挂号金额,TINSUBackNum:%Integer:医保退号数,TZFBackNum:%Integer:非医保退号数,TINSUBackAmt:%Float:医保退号金额,TZFBackAmt:%Float:非医保退号金额,TPayNum1:%Integer:现金、微信、支付宝、欠费收费笔数,TPayAmt1:%Float:现金、微信、支付宝、欠费收费金额,TRefundNum1:%Integer:现金、微信、支付宝、欠费退费笔数,TRefundAmt1:%Float:现金、微信、支付宝、欠费退费金额,TPayNum2:%Integer:银行卡收费笔数,TPayAmt2:%Float:银行卡收费金额,TRefundNum2:%Integer:银行卡退费笔数,TRefundAmt2:%Float:银行卡退费金额,TPayNum3:%Integer:医保收费笔数,TPayAmt3:%Float:医保收费金额,TRefundNum3:%Integer:医保退费笔数,TRefundAmt3:%Float:医保退费金额,PrintNum:%Integer:打印发票数量,TPayNum4:%Integer:其它收费笔数,TPayAmt4:%Float:其它收费金额,TRefundNum4:%Integer:其它退费笔数,TRefundAmt4:%Float:其它退费金额") [ SqlProc ]
{
}

ClassMethod GetWorkStatExecute(ByRef qHandle As %Binary, UserRowId As %String, StDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, DateFlag As %String, HOSPID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1

    set ^TMP("GetWorkStat")=$lb(UserRowId, StDate, EndDate, StartTime, EndTime, DateFlag, HOSPID)
	if ((StDate="")||(EndDate=""))  quit $$$OK
	s:StDate'="" StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
    s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	set StartTime=##class(websys.Conversions).TimeHtmlToLogical(StartTime)
	set EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)

	for PDate=StDate:1:EndDate {
		do ..GetOPWorkStat(UserRowId, PDate, StDate, EndDate, StartTime, EndTime, DateFlag, HOSPID)    //统计挂号和收费
		do ..GetAccWorkStat(UserRowId, PDate, StDate, EndDate, StartTime, EndTime, DateFlag, HOSPID)   //统计预交金
		do ..GetCardWorkStat(UserRowId, PDate, StDate, EndDate, StartTime, EndTime, DateFlag, HOSPID)  //统计卡
		do ..GetCardStausWorkStat(UserRowId, PDate, StDate, EndDate, StartTime, EndTime, DateFlag, HOSPID)  //统计卡的作废（D）、回收（R）、挂失（S）
	}
	
	set (TBuildCardNum,TCancelCardNum,TRegNum,TBackNum,TAccPayNum,TAccFootNum,TAccFootNum,TAccRefundNum,TAccTransNum,TPayNum,TRefundNum,TAbortCardNum,TRecCardNum,TLossCardNum,TINSURegNum,TINSUBackNum,TZFRegNum,TZFBackNum,TPayNum1,TRefundNum1,TPayNum2,TRefundNum2,TPayNum3,TRefundNum3,PrintNum,TPayNum4,TRefundNum4)=0
	set (TBuildCardAmt,TCancelCardAmt,TRegAmt,TBackAmt,TAccPayAmt,TAccFootAmt,TAccFootAmt,TAccRefundAmt,TAccTransAmt,TPayAmt,TRefundAmt,TINSURegAmt,TINSUBackAmt,TZFRegAmt,TZFBackAmt,TPayAmt1,TRefundAmt1,TPayAmt2,TRefundAmt2,TPayAmt3,TRefundAmt3,TPayAmt4,TRefundAmt4)=0.00
	
	set UserDR=0
	while($o(^||TMP($j,"User",UserDR))) {
		set UserDR=$o(^||TMP($j,"User",UserDR))
		set rtn=##class(web.UDHCJFBaseCommon).CheckISCashierBytype(UserDR, "O", 3)   //非收费员不显示 
		continue:(rtn=1)
		set TUserCode=$p($g(^SSU("SSUSR",UserDR)),"^",1)
		set TUserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
		set TBuildCardNum=+$g(^||TMP($j,"Card_Num",UserDR,"N"))              //建卡数
		set TBuildCardAmt=+$g(^||TMP($j,"Card_Amt",UserDR,"N"))              //建卡金额
		set TCancelCardNum=+$g(^||TMP($j,"Card_Num",UserDR,"A"))             //退卡数
		set TCancelCardAmt=+$g(^||TMP($j,"Card_Num",UserDR,"A"))             //退卡金额
		set TRegNum=+$g(^||TMP($j,"Reg_Num",UserDR,"N"))               //挂号数               
		set TRegAmt=+$g(^||TMP($j,"Reg_Amt",UserDR,"N"))               //挂号金额
		set TBackNum=+$g(^||TMP($j,"Reg_Num",UserDR,"A"))+$g(^||TMP($j,"Reg_Num",UserDR,"S"))    //退号数
		set TBackAmt=+$g(^||TMP($j,"Reg_Amt",UserDR,"A"))+$g(^||TMP($j,"Reg_Amt",UserDR,"S"))    //退号金额
		set TAccPayNum=+$g(^||TMP($j,"Acc_Num",UserDR,"P"))               //收预交金笔数
		set TAccPayAmt=+$g(^||TMP($j,"Acc_Amt",UserDR,"P"))               //收预交金金额
		set TAccFootNum=+$g(^||TMP($j,"Acc_Num",UserDR,"F"))              //账户结算笔数
		set TAccFootAmt=+$g(^||TMP($j,"Acc_Amt",UserDR,"F"))              //账户结算金额
		set TAccRefundNum=+$g(^||TMP($j,"Acc_Num",UserDR,"R"))            //退预交金笔数
		set TAccRefundAmt=+$g(^||TMP($j,"Acc_Amt",UserDR,"R"))            //退预交金金额
		set TAccTransNum=+$g(^||TMP($j,"Acc_Num",UserDR,"T"))             //预交金转账笔数
		set TAccTransAmt=+$g(^||TMP($j,"Acc_Amt",UserDR,"T"))             //预交金转账金额
		set TPayNum=+$g(^||TMP($j,"Inv_Num",UserDR,"N"))               //收费笔数
		set TPayAmt=+$g(^||TMP($j,"Inv_Amt",UserDR,"N"))               //收费金额                 
		set TRefundNum=+$g(^||TMP($j,"Inv_Num",UserDR,"A"))+$g(^||TMP($j,"Inv_Num",UserDR,"S"))  //退费笔数
		set TRefundAmt=+$g(^||TMP($j,"Inv_Amt",UserDR,"A"))+$g(^||TMP($j,"Inv_Amt",UserDR,"S"))  //退费金额
		set TAbortCardNum=+$g(^||TMP($j,"CardStat_Num",UserDR,"D"))      //卡作废张数
		set TRecCardNum=+$g(^||TMP($j,"CardStat_Num",UserDR,"R"))        //卡回收张数
		set TLossCardNum=+$g(^||TMP($j,"CardStat_Num",UserDR,"S"))       //卡挂失张数

		set TINSURegNum=+$g(^||TMP($j,"INSUReg_Num",UserDR,"N"))               //   2023-02-27LUANZH医保挂号数               
		set TINSURegAmt=+$g(^||TMP($j,"INSUReg_Amt",UserDR,"N"))               //医保挂号金额
		set TINSUBackNum=+$g(^||TMP($j,"INSUReg_Num",UserDR,"A"))+$g(^||TMP($j,"INSUReg_Num",UserDR,"S"))    //医保退号数
		set TINSUBackAmt=+$g(^||TMP($j,"INSUReg_Amt",UserDR,"A"))+$g(^||TMP($j,"INSUReg_Amt",UserDR,"S"))    //医保退号金额
		set TZFRegNum=+$g(^||TMP($j,"ZFReg_Num",UserDR,"N"))               //非医保挂号数               
		set TZFRegAmt=+$g(^||TMP($j,"ZFReg_Amt",UserDR,"N"))               //非医保挂号金额
		set TZFBackNum=+$g(^||TMP($j,"ZFReg_Num",UserDR,"A"))+$g(^||TMP($j,"ZFReg_Num",UserDR,"S"))    //非医保退号数
		set TZFBackAmt=+$g(^||TMP($j,"ZFReg_Amt",UserDR,"A"))+$g(^||TMP($j,"ZFReg_Amt",UserDR,"S"))    //非医保退号金额
		set TPayNum1=+$g(^||TMP($j,"Inv_Num1",UserDR,"N"))               ///现金、微信、支付宝、欠费收费笔数
		set TPayAmt1=+$g(^||TMP($j,"Inv_Amt1",UserDR,"N"))               ///现金、微信、支付宝、欠费收费金额 
		set TRefundNum1=+$g(^||TMP($j,"Inv_Num1",UserDR,"A"))+$g(^||TMP($j,"Inv_Num1",UserDR,"S"))  //现金、微信、支付宝、欠费退费笔数
		set TRefundAmt1=+$g(^||TMP($j,"Inv_Amt1",UserDR,"A"))+$g(^||TMP($j,"Inv_Amt1",UserDR,"S"))  //现金、微信、支付宝、欠费退费金额
		set TPayNum2=+$g(^||TMP($j,"Inv_Num2",UserDR,"N"))               ///银行卡收费笔数
		set TPayAmt2=+$g(^||TMP($j,"Inv_Amt2",UserDR,"N"))               ///银行卡收费金额 
		set TRefundNum2=+$g(^||TMP($j,"Inv_Num2",UserDR,"A"))+$g(^||TMP($j,"Inv_Num2",UserDR,"S"))  //银行卡退费笔数
		set TRefundAmt2=+$g(^||TMP($j,"Inv_Amt2",UserDR,"A"))+$g(^||TMP($j,"Inv_Amt2",UserDR,"S"))  //银行卡退费金额
		set TPayNum3=+$g(^||TMP($j,"Inv_Num3",UserDR,"N"))               ///医保收费笔数
		set TPayAmt3=+$g(^||TMP($j,"Inv_Amt3",UserDR,"N"))               ///医保收费金额 
		set TRefundNum3=+$g(^||TMP($j,"Inv_Num3",UserDR,"A"))+$g(^||TMP($j,"Inv_Num3",UserDR,"S"))  //医保退费笔数
		set TRefundAmt3=+$g(^||TMP($j,"Inv_Amt3",UserDR,"A"))+$g(^||TMP($j,"Inv_Amt3",UserDR,"S"))  //医保退费金额
		set PrintNum=+$g(^||TMP($j,"User",UserDR,"P"))           //打印发票数量

		set TPayNum4=+$g(^||TMP($j,"Inv_Num4",UserDR,"N"))               ///其它收费笔数
		set TPayAmt4=+$g(^||TMP($j,"Inv_Amt4",UserDR,"N"))               ///其它收费金额 
		set TRefundNum4=+$g(^||TMP($j,"Inv_Num4",UserDR,"A"))+$g(^||TMP($j,"Inv_Num4",UserDR,"S"))  //其它退费笔数
		set TRefundAmt4=+$g(^||TMP($j,"Inv_Amt4",UserDR,"A"))+$g(^||TMP($j,"Inv_Amt4",UserDR,"S"))  //其它退费金额

		set data=$lb(TUserCode,TUserName,TBuildCardNum,TBuildCardAmt,TCancelCardNum,TCancelCardAmt,TRegNum,TRegAmt,TBackNum,TBackAmt,TAccPayNum,TAccPayAmt,TAccFootNum,TAccFootAmt,TAccTransNum,TAccTransAmt,TPayNum,TPayAmt,TRefundNum,TRefundAmt,TAbortCardNum,TRecCardNum,TLossCardNum,TINSURegNum,TZFRegNum,TINSURegAmt,TZFRegAmt,TINSUBackNum,TZFBackNum,TINSUBackAmt,TZFBackAmt,TPayNum1,TPayAmt1,TRefundNum1,TRefundAmt1,TPayNum2,TPayAmt2,TRefundNum2,TRefundAmt2,TPayNum3,TPayAmt3,TRefundNum3,TRefundAmt3,PrintNum,TPayNum4,TPayAmt4,TRefundNum4,TRefundAmt4)
		set ^CacheTemp(repid,ind)=data
		set ind=ind+1
	}
	
	kill ^||TMP($j)
	quit $$$OK
}

/// 取建/退卡金额/笔数
/// input: PDate(EndDate-StDate+1)UserId:收费员ID, StDate:开始日期,EndDate:结束日期,StTime:开始时间, EndTime:结束时间,DateFlag:(自然日:'N',结账日:'Y')
ClassMethod GetCardWorkStat(UserId, PDate, StDate, EndDate, StTime, EndTime, DateFlag, HospId)
{
	set CIPRowID=""
	if (DateFlag="Y") do
	.//结账日
    .for  set CIPRowID=$o(^DHCCARDINVPRTi(0,"HandDate",PDate,CIPRowID)) quit:(CIPRowID="")  do
	..set CIPData=^DHCCARDINVPRT(CIPRowID)
	..set HospDR=$p(CIPData,"^",20)
	..quit:(HospDR'=HospId)
	..set UserDR=$p(CIPData,"^",6)
	..quit:((UserId'=UserDR)&&(UserId'=""))
	..set CIPFlag=$p(CIPData,"^",2)
	..if ($d(^DHCCARDINVPRTi(0,"INVPAYDR",CIPRowID))) set CIPFlag="N"
	..set CardAmt=$p(CIPData,"^",3)
	..set HandinTime=$p(CIPData,"^",23) 
	..quit:((PDate=StDate)&&(StTime'="")&&(HandinTime<StTime))
	..quit:((PDate=EndDate)&&(EndTime'="")&&(HandinTime>EndTime))
	..set ^||TMP($j,"User",UserDR)=UserDR
	..if (CIPFlag="N") do
	...set ^||TMP($j,"Card_Num",UserDR,"N")=$i(^||TMP($j,"Card_Num",UserDR,"N"))            //建卡数       
	...set ^||TMP($j,"Card_Amt",UserDR,"N")=$i(^||TMP($j,"Card_Amt",UserDR,"N"), CardAmt)   //建卡金额  
	..else  do
	...set ^||TMP($j,"Card_Num",UserDR,"A")=$i(^||TMP($j,"Card_Num",UserDR,"A"))            //退卡数	
	...set ^||TMP($j,"Card_Amt",UserDR,"A")=$i(^||TMP($j,"Card_Amt",UserDR,"A"), CardAmt)   //退卡金额
	else  do
	.//自然日
	.for  set CIPRowID=$o(^DHCCARDINVPRTi(0,"Date",PDate,CIPRowID)) quit:(CIPRowID="")  do
	..set CIPData=^DHCCARDINVPRT(CIPRowID)
	..set HospDR=$p(CIPData,"^",20)
	..quit:(HospDR'=HospId)
	..set UserDR=$p(CIPData,"^",6)
	..quit:((UserId'=UserDR)&&(UserId'=""))
	..set CIPFlag=$p(CIPData,"^",2)
	..if ($d(^DHCCARDINVPRTi(0,"INVPAYDR",CIPRowID))) set CIPFlag="N"
	..set CardAmt=$p(CIPData,"^",3)
	..set PrtTime=$p(CIPData,"^",5)
	..quit:((PDate=StDate)&&(StTime'="")&&(PrtTime<StTime))
	..quit:((PDate=EndDate)&&(EndTime'="")&&(PrtTime>EndTime))
	..set ^||TMP($j,"User",UserDR)=UserDR
	..if (CIPFlag="N")  do
	...set ^||TMP($j,"Card_Num",UserDR,"N")=$i(^||TMP($j,"Card_Num",UserDR,"N"))           //建卡数       
	...set ^||TMP($j,"Card_Amt",UserDR,"N")=$i(^||TMP($j,"Card_Amt",UserDR,"N"), CardAmt)  //建卡金额 
	..else  do
	...set ^||TMP($j,"Card_Num",UserDR,"A")=$i(^||TMP($j,"Card_Num",UserDR,"A"))            //退卡数
	...set ^||TMP($j,"Card_Amt",UserDR,"A")=$i(^||TMP($j,"Card_Amt",UserDR,"A"), CardAmt)   //退卡金额
	
	quit 0
}

/// 取门诊收退金额笔数
/// input: PDate(EndDate-StDate+1)UserId:收费员ID, StDate:开始日期,EndDate:结束日期,StTime:开始时间, EndTime:结束时间,DateFlag:(自然日:'N',结账日:'Y')
ClassMethod GetOPWorkStat(UserId, PDate, StDate, EndDate, StTime, EndTime, DateFlag, HospId)
{
	if (DateFlag="Y") do
	.//结账日
	.set PrtId=0
	.for  set PrtId=$o(^DHCINVPRT(0,"HandDate",PDate,PrtId)) quit:(PrtId="")  do
	..set PrtData=$g(^DHCINVPRT(PrtId))
	..set HospDR=$p(PrtData,"^",39)
	..quit:(HospId'=HospDR)
	..set UserDR=$p(PrtData,"^",21)
	..quit:((UserId'=UserDR)&&(UserId'=""))
	..set HandinTime=$p(PrtData,"^",12)	    //PRT_HandinTime
	..quit:((PDate=StDate)&&(StTime'="")&&(HandinTime<StTime))
	..quit:((PDate=EndDate)&&(EndTime'="")&&(HandinTime>EndTime))
	..set PrtFlag=$p(PrtData,"^",8)	     //PRT_Flag
	..if ($d(^DHCINVPRT(0,"InitInvDR",PrtId))) set PrtFlag="N"   //退费发票算收
	..set Amount=$p(PrtData,"^",1)	     //PRT_Acount
	..set FairType=$p(PrtData,"^",34)
	..set InsTypeDR=$p(PrtData,"^",9)   //PRT_InsType_DR    2023-02-27 LUANZH
	..set AdmSource=$p($g(^PAC("ADMREA",InsTypeDR)),"^",9)
	..set IPMSub=$o(^DHCINVPRT(PrtId,"P",0))  //取支付方式
	..set PMDR=$s((IPMSub'=""):$p($g(^DHCINVPRT(PrtId,"P",IPMSub)),"^",1),1:"")
	..set PrintFlag=$p(PrtData,"^",3)   //取是否打印标志
	..if (FairType="R")  do        //统计挂号
	...set ^||TMP($j,"User",UserDR)=UserDR
	...if (PrintFlag="P") do       //统计打印发票数量
	....set ^||TMP($j,"User",UserDR,PrintFlag)=$i( ^||TMP($j,"User",UserDR,PrintFlag))
	...set ^||TMP($j,"Reg_Num",UserDR,PrtFlag)=$i(^||TMP($j,"Reg_Num",UserDR,PrtFlag))
	...set ^||TMP($j,"Reg_Amt",UserDR,PrtFlag)=$i(^||TMP($j,"Reg_Amt",UserDR,PrtFlag), Amount)

	...if (AdmSource'=1) do
	....set ^||TMP($j,"ZFReg_Num",UserDR,PrtFlag)=$i(^||TMP($j,"ZFReg_Num",UserDR,PrtFlag))  //非医保挂号
	....set ^||TMP($j,"ZFReg_Amt",UserDR,PrtFlag)=$i(^||TMP($j,"ZFReg_Amt",UserDR,PrtFlag), Amount)
    ...else  do
	....set ^||TMP($j,"INSUReg_Num",UserDR,PrtFlag)=$i(^||TMP($j,"INSUReg_Num",UserDR,PrtFlag)) //医保挂号
	....set ^||TMP($j,"INSUReg_Amt",UserDR,PrtFlag)=$i(^||TMP($j,"INSUReg_Amt",UserDR,PrtFlag), Amount)

	..else  do
	...//统计收费
	...set ^||TMP($j,"User",UserDR)=UserDR
	...if (PrintFlag="P") do
	....set ^||TMP($j,"User",UserDR,PrintFlag)=$i( ^||TMP($j,"User",UserDR,PrintFlag))
	...set ^||TMP($j,"Inv_Num",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Num",UserDR,PrtFlag))
	...set ^||TMP($j,"Inv_Amt",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Amt",UserDR,PrtFlag), Amount)

	...if ((PMDR="1")||(PMDR="47")||(PMDR="48")||(PMDR="11")) do    //现金、微信、支付宝、欠费
    ....set ^||TMP($j,"Inv_Num1",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Num1",UserDR,PrtFlag))
	....set ^||TMP($j,"Inv_Amt1",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Amt1",UserDR,PrtFlag), Amount)
	...if (PMDR="4") do   //银行卡
	....set ^||TMP($j,"Inv_Num2",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Num2",UserDR,PrtFlag))
	....set ^||TMP($j,"Inv_Amt2",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Amt2",UserDR,PrtFlag), Amount)

	...if (PMDR="33") do   //医保账户
	....set ^||TMP($j,"Inv_Num3",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Num3",UserDR,PrtFlag))
	....set ^||TMP($j,"Inv_Amt3",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Amt3",UserDR,PrtFlag), Amount)

	...if ((PMDR'="1")&&(PMDR'="47")&&(PMDR'="48")&&(PMDR'="11")&&(PMDR'="4")&&(PMDR'="33"))  do   //其它
	....set ^||TMP($j,"Inv_Num4",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Num4",UserDR,PrtFlag))
	....set ^||TMP($j,"Inv_Amt4",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Amt4",UserDR,PrtFlag), Amount)

	else  do
	.//自然日
	.set PrtId=0
	.for  set PrtId=$o(^DHCINVPRT(0,"Date",PDate,PrtId)) quit:(PrtId="")  do
	..set PrtData=$g(^DHCINVPRT(PrtId))
	..set HospDR=$p(PrtData,"^",39)
	..quit:(HospId'=HospDR)
	..set UserDR=$p(PrtData,"^",21)
	..quit:((UserId'=UserDR)&&(UserId'=""))
	..set PrtTime=$p(PrtData,"^",20)
	..quit:((PDate=StDate)&&(StTime'="")&&(PrtTime<StTime))
	..quit:((PDate=EndDate)&&(EndTime'="")&&(PrtTime>EndTime))
	..set PrtFlag=$p(PrtData,"^",8)	    ;PRT_Flag
	..if ($d(^DHCINVPRT(0,"InitInvDR",PrtId))) set PrtFlag="N"   //退费发票算收
	..set Amount=$p(PrtData,"^",1)	    ;PRT_Acount
	..set FairType=$p(PrtData,"^",34)
	..set InsTypeDR=$p(PrtData,"^",9)   //PRT_InsType_DR    2023-02-27 LUANZH
	..set AdmSource=$p($g(^PAC("ADMREA",InsTypeDR)),"^",9)
	..set IPMSub=$o(^DHCINVPRT(PrtId,"P",0))  //取支付方式
	..set PMDR=$s((IPMSub'=""):$p($g(^DHCINVPRT(PrtId,"P",IPMSub)),"^",1),1:"")
	..set PrintFlag=$p(PrtData,"^",3)   //取是否打印标志
	..if (FairType="R")	do
	...set ^||TMP($j,"User",UserDR)=UserDR
	...if (PrintFlag="P") do
	....set ^||TMP($j,"User",UserDR,PrintFlag)=$i( ^||TMP($j,"User",UserDR,PrintFlag))
	...set ^||TMP($j,"Reg_Num",UserDR,PrtFlag)=$i(^||TMP($j,"Reg_Num",UserDR,PrtFlag))
	...set ^||TMP($j,"Reg_Amt",UserDR,PrtFlag)=$i(^||TMP($j,"Reg_Amt",UserDR,PrtFlag), Amount)

	...if (AdmSource'=1) do
	....set ^||TMP($j,"ZFReg_Num",UserDR,PrtFlag)=$i(^||TMP($j,"ZFReg_Num",UserDR,PrtFlag))  //非医保挂号
	....set ^||TMP($j,"ZFReg_Amt",UserDR,PrtFlag)=$i(^||TMP($j,"ZFReg_Amt",UserDR,PrtFlag), Amount)
    ...else  do
	....set ^||TMP($j,"INSUReg_Num",UserDR,PrtFlag)=$i(^||TMP($j,"INSUReg_Num",UserDR,PrtFlag)) //医保挂号
	....set ^||TMP($j,"INSUReg_Amt",UserDR,PrtFlag)=$i(^||TMP($j,"INSUReg_Amt",UserDR,PrtFlag), Amount)

	..else  do
	...//统计收费
	...set ^||TMP($j,"User",UserDR)=UserDR
	...if (PrintFlag="P") do
	....set ^||TMP($j,"User",UserDR,PrintFlag)=$i( ^||TMP($j,"User",UserDR,PrintFlag))
	...set ^||TMP($j,"Inv_Num",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Num",UserDR,PrtFlag))
	...set ^||TMP($j,"Inv_Amt",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Amt",UserDR,PrtFlag), Amount)

	...if ((PMDR="1")||(PMDR="47")||(PMDR="48")||(PMDR="11")) do    //现金、微信、支付宝、欠费
    ....set ^||TMP($j,"Inv_Num1",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Num1",UserDR,PrtFlag))
	....set ^||TMP($j,"Inv_Amt1",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Amt1",UserDR,PrtFlag), Amount)
	...if (PMDR="4") do   //银行卡
	....set ^||TMP($j,"Inv_Num2",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Num2",UserDR,PrtFlag))
	....set ^||TMP($j,"Inv_Amt2",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Amt2",UserDR,PrtFlag), Amount)

	...if (PMDR="33") do   //医保账户
	....set ^||TMP($j,"Inv_Num3",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Num3",UserDR,PrtFlag))
	....set ^||TMP($j,"Inv_Amt3",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Amt3",UserDR,PrtFlag), Amount)
	
	...if ((PMDR'="1")&&(PMDR'="47")&&(PMDR'="48")&&(PMDR'="11")&&(PMDR'="4")&&(PMDR'="33"))  do   //其它
	....set ^||TMP($j,"Inv_Num4",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Num4",UserDR,PrtFlag))
	....set ^||TMP($j,"Inv_Amt4",UserDR,PrtFlag)=$i(^||TMP($j,"Inv_Amt4",UserDR,PrtFlag), Amount)

	quit 0
}

/// 取预交金收退金额笔数
/// input: PDate(EndDate-StDate+1)UserId:收费员ID, StDate:开始日期,EndDate:结束日期,StTime:开始时间, EndTime:结束时间,DateFlag:(自然日:'N',结账日:'Y')
ClassMethod GetAccWorkStat(UserId, PDate, StDate, EndDate, StTime, EndTime, DateFlag, HospId)
{
	//DHC_AccPreDeposit
	if (DateFlag="Y")  do
	.//结账日
	.set AccId=0
	.for  set AccId=$o(^DHCACDi("AccM",0,"FD",PDate,AccId)) quit:(AccId="")  do
	..set AccPDSub=0
	..for  set AccPDSub=$o(^DHCACDi("AccM",0,"FD",PDate,AccId,"AccPD",AccPDSub)) quit:(AccPDSub="")  do
	...set AccPDData=$g(^DHCACD("AccM",AccId,"AccPD",AccPDSub))
	...set HospDR=$p(AccPDData,"^",15)
	...quit:(HospId'=HospDR)
	...set UserDR=$p(AccPDData,"^",5)
	...quit:((UserId'=UserDR)&&(UserId'=""))
	...set HandinTime=$p(AccPDData,"^",12)	    //AccPD_FootTime
	...quit:((PDate=StDate)&&(StTime'="")&&(HandinTime<StTime))
	...quit:((PDate=EndDate)&&(EndTime'="")&&(HandinTime>EndTime))
	...set Amount=$p(AccPDData,"^",2)	    //AccPD_PreSum
	...set PDType=$p(AccPDData,"^",1)	    //AccPD_Type
	...quit:(PDType="")
	...set ^||TMP($j,"User",UserDR)=UserDR
	...set ^||TMP($j,"Acc_Num",UserDR,PDType)=$i(^||TMP($j,"Acc_Num",UserDR,PDType))
	...set ^||TMP($j,"Acc_Amt",UserDR,PDType)=$i(^||TMP($j,"Acc_Amt",UserDR,PDType), Amount)
	else  do
	.//自然日
	.set AccId=0
	.for  set AccId=$o(^DHCACDi("AccM",0,"APDDate",PDate,AccId)) quit:(AccId="")  do
	..set AccPDSub=0
	..for  set AccPDSub=$o(^DHCACDi("AccM",0,"APDDate",PDate,AccId,"AccPD",AccPDSub)) quit:(AccPDSub="")  do
	...set AccPDData=$g(^DHCACD("AccM",AccId,"AccPD",AccPDSub))
	...set HospDR=$p(AccPDData,"^",15)
	...quit:(HospId'=HospDR)
	...set PreTime=$p(AccPDData,"^",4)
	...quit:((PDate=StDate)&&(StTime'="")&&(PreTime<StTime))
	...quit:((PDate=EndDate)&&(EndTime'="")&&(PreTime>EndTime))
	...set UserDR=$p(AccPDData,"^",5)
	...quit:((UserId'=UserDR)&&(UserId'=""))
	...set Amount=$p(AccPDData,"^",2)	    //AccPD_PreSum
	...set PDType=$p(AccPDData,"^",1)	    //AccPD_Type
	...quit:(PDType="")
	...set ^||TMP($j,"User",UserDR)=UserDR	
	...set ^||TMP($j,"Acc_Num",UserDR,PDType)=$i(^||TMP($j,"Acc_Num",UserDR,PDType))
	...set ^||TMP($j,"Acc_Amt",UserDR,PDType)=$i(^||TMP($j,"Acc_Amt",UserDR,PDType), Amount)
	
	quit 0
}

///  统计卡状态 
/// do ##class(web.DHCOPWorkLoad).GetCardStausWorkStat(5,170,64676,64846,0,86399,"Y")
ClassMethod GetCardStausWorkStat(UserId, PDate, StDate, EndDate, StTime, EndTime, DateFlag, HospId)
{
    //DHC_CardRef
	set CSCId=0
	for  set CSCId=$o(^DHCCARDi("CF",0,"CSDate",PDate,CSCId)) quit:(CSCId="")  do
	.set CSCSub=0
	.for  set CSCSub=$o(^DHCCARDi("CF",0,"CSDate",PDate,CSCId,"CSC",CSCSub))  quit:(CSCSub="")  do
	..set CSCData=$g(^DHCCARD("CF",CSCId,"CSC",CSCSub))
	..quit:(CSCData="")
	..set HospDR=$p(CSCData,"^",18)
	..quit:(HospId'=HospDR)
	..set UserDR=$p(CSCData,"^",4)
	..quit:((UserId'=UserDR)&&(UserId'=""))
	..set CSCDate=$p(CSCData,"^",1)	//CSC_Date
	..set CSCTime=$p(CSCData,"^",2)	//CSC_Time
	..quit:((CSCDate=StDate)&&(StTime'="")&&(CSCTime<StTime))
	..quit:((CSCDate=EndDate)&&(EndTime'="")&&(CSCTime>EndTime))
	..set CStatus=$p(CSCData,"^",3)	//CSC_CurStatus
	..set ^||TMP($j,"User",UserDR)=UserDR
	..set ^||TMP($j,"CardStat_Num",UserDR,CStatus)=$i(^||TMP($j,"CardStat_Num",UserDR,CStatus))
	
	quit 0
}

/// 取门诊收费员
/// do ##class(%ResultSet).RunQuery("web.DHCOPBillWorkLoad","FindUserOP",2)
Query FindUserOP(HOSPID As %String) As websys.Query(ROWSPEC = "UserName:%String,UserId:%String") [ SqlProc ]
{
}

ClassMethod FindUserOPExecute(ByRef qHandle As %Binary, HOSPID As %String) As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
    set rowId=$o(^DHCJFRcptGroupSet(0,"Type","O",3,""))
    if (rowId="")  quit $$$OK
    
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_RcptGroupUser", HOSPID)
	set sub=0
	while($o(^DHCJFRcptGroupSet(rowId,"Sub",sub))) {
		set sub=$o(^DHCJFRcptGroupSet(rowId,"Sub",sub))
		set subData=$g(^DHCJFRcptGroupSet(rowId,"Sub",sub))
		set hospDR=$p(subData,"^",5)
		continue:(hospDR'=defHospId)
		set userDR=$p(subData,"^",4)
		continue:((+userDR=0)||'$d(^SSU("SSUSR",userDR)))
		set userName=$p(^SSU("SSUSR",userDR),"^",2)
		do OutputUser
	}
	
	quit $$$OK
OutputUser
	set Data=$lb(userName,userDR)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

// (UserRowId As %String, StDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, DateFlag As %String, HOSPID As %String)

/// add luochaoyue 2023.5.19
/// 获取门诊工作量
/// d ##class(%ResultSet).RunQuery("web.DHCOPBillWorkLoad","GetWorkLoadDetailnew","","2023-05-01","2023-05-15","00:00:00","23:59:59","N","2")
Query GetWorkLoadDetailnew(UserRowId As %String, StDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, DateFlag As %String, HOSPID As %String) As websys.Query(ROWSPEC = "userCode:%String,accpreNum:%Integer,refaccpreNum:%Integer,refundInvNum:%Integer,qfbhNum:%Integer,READesc:%String,reasonNum:%String") [ SqlProc ]
{
}

ClassMethod GetWorkLoadDetailnewExecute(ByRef qHandle As %Binary, UserRowId As %String, StDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, DateFlag As %String, HOSPID As %String) As %Status
{

	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    
    
    if ((StDate="")||(EndDate=""))  quit $$$OK
	s:StDate'="" StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
    s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    
	set StartTime=##class(websys.Conversions).TimeHtmlToLogical(StartTime)
	set EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)
    set ^TMP("GetWorkLoadDetailnew")=$lb(UserRowId, StDate, EndDate, StartTime, EndTime, DateFlag, HOSPID)
    s job=$j
    k ^TMP("WorkLoadDetail",job)
    b ;1234
    if (DateFlag="Y") do
	.//结账日
	.f PDate=StDate:1:EndDate d
	..set PrtId=0
	..for  set PrtId=$o(^DHCINVPRT(0,"HandDate",PDate,PrtId)) quit:(PrtId="")  do
	...set invInfo=$g(^DHCINVPRT(PrtId))
	...s myHospDr=$p(invInfo,"^",39) ;PRT_Hospital_DR
    ...quit:(myHospDr'=HOSPID)
    ...s prtuser=$p(invInfo,"^",21)
    ...quit:((UserRowId'=prtuser)&&(UserRowId'=""))
    ...s prtfairtype=$p(invInfo,"^",34)  ;prt_fairtype (F:发票，R:挂号)
    ...;q:(prtfairtype'="F")&(prtfairtype'="R") 
    ...s prinvptrflag=$p(invInfo,"^",3)  ;PRT_INVPrintFlag
    ...s insuTypeDr=$p(invInfo,"^",9)    ;PRT_InsType_DR
    ...s amt=$p(invInfo,"^",1)     ;PRT_Acount
    ...s prtdate=$p(invInfo,"^",5) 
    ...s prttime=$p(invInfo,"^",20)
    ...quit:((prtdate=StDate)&&(StartTime'="")&&(prttime<StartTime))
	...quit:((prtdate=EndDate)&&(EndTime'="")&&(prttime>EndTime))
    ...s flag=$p(invInfo,"^",8)  
   	...i amt>0 s ^TMP("WorkLoadDetail",job,prtuser,"AdmReason",insuTypeDr)=$g(^TMP("WorkLoadDetail",job,prtuser,"AdmReason",insuTypeDr))+1
   	...e  s $p(^TMP("WorkLoadDetail",job,prtuser,"Detail"),"^",1)=$p($g(^TMP("WorkLoadDetail",job,prtuser,"Detail")),"^",1)+1
    ...s oldPrtdr=$p(invInfo,"^",29)
    ...i oldPrtdr'=""  d
   	....s invSub=$o(^DHCINVPRT(oldPrtdr,"P",0))  ;dhc_invpaymode
    ....s paym=$p(^DHCINVPRT(oldPrtdr,"P",invSub),"^",1)
    ....s paymsum=+$p(^DHCINVPRT(oldPrtdr,"P",invSub),"^",3)
    ....i (paym=11)&&(paymsum'=0) s $p(^TMP("WorkLoadDetail",job,prtuser,"Detail"),"^",4)=$p($g(^TMP("WorkLoadDetail",job,prtuser,"Detail")),"^",4)+1
	
	else  do
    .b ;门诊收费
   	.f Date=StDate:1:EndDate d
    ..s RowId="0"
    ..f  s RowId=$o(^DHCINVPRT(0,"Date",Date,RowId)) q:RowId=""  d
    ...s invInfo=$g(^DHCINVPRT(RowId))
    ...s myHospDr=$p(invInfo,"^",39) ;PRT_Hospital_DR
    ...quit:(myHospDr'=HOSPID)
    ...s prtuser=$p(invInfo,"^",21)
    ...quit:((UserRowId'=prtuser)&&(UserRowId'=""))
    ...s prtfairtype=$p(invInfo,"^",34)  ;prt_fairtype (F:发票，R:挂号)
    ...;q:(prtfairtype'="F")&(prtfairtype'="R") 
    ...s prinvptrflag=$p(invInfo,"^",3)  ;PRT_INVPrintFlag
    ...s insuTypeDr=$p(invInfo,"^",9)    ;PRT_InsType_DR
    ...s amt=$p(invInfo,"^",1)     ;PRT_Acount
    ...s prtdate=$p(invInfo,"^",5) 
    ...s prttime=$p(invInfo,"^",20)
    ...quit:((prtdate=StDate)&&(StartTime'="")&&(prttime<StartTime))
	...quit:((prtdate=EndDate)&&(EndTime'="")&&(prttime>EndTime))
    ...s flag=$p(invInfo,"^",8)  
   	...i amt>0 s ^TMP("WorkLoadDetail",job,prtuser,"AdmReason",insuTypeDr)=$g(^TMP("WorkLoadDetail",job,prtuser,"AdmReason",insuTypeDr))+1
   	...e  s $p(^TMP("WorkLoadDetail",job,prtuser,"Detail"),"^",1)=$p($g(^TMP("WorkLoadDetail",job,prtuser,"Detail")),"^",1)+1
    ...s oldPrtdr=$p(invInfo,"^",29)
    ...i oldPrtdr'=""  d
   	....s invSub=$o(^DHCINVPRT(oldPrtdr,"P",0))  ;dhc_invpaymode
    ....s paym=$p(^DHCINVPRT(oldPrtdr,"P",invSub),"^",1)
    ....s paymsum=+$p(^DHCINVPRT(oldPrtdr,"P",invSub),"^",3)
    ....i (paym=11)&&(paymsum'=0) s $p(^TMP("WorkLoadDetail",job,prtuser,"Detail"),"^",4)=$p($g(^TMP("WorkLoadDetail",job,prtuser,"Detail")),"^",4)+1
   	 ;预交金
   	if (DateFlag="Y")  do
	.//结账日
	.f PDate=StDate:1:EndDate d
	..set AccId=0
	..for  set AccId=$o(^DHCACDi("AccM",0,"FD",PDate,AccId)) quit:(AccId="")  do
	...set AccPDSub=0
	...for  set AccPDSub=$o(^DHCACDi("AccM",0,"FD",PDate,AccId,"AccPD",AccPDSub)) quit:(AccPDSub="")  do
	....set PrtDepositInfo=$g(^DHCACD("AccM",AccId,"AccPD",AccPDSub))
   	....s myHospDr=$p(PrtDepositInfo,"^",15)
    ....quit:(myHospDr'=HOSPID)
    ....s PrtUser=$p(PrtDepositInfo,"^",5)   ;;;;Guser
    ....quit:((UserRowId'=PrtUser)&&(UserRowId'=""))
	....set PreTime=$p(PrtDepositInfo,"^",4)
	....quit:((PreDate=StDate)&&(StartTime'="")&&(PreTime<StartTime))
	....quit:((PreDate=EndDate)&&(EndTime'="")&&(PreTime>EndTime))    
    ....s PrtStatus=$p(PrtDepositInfo,"^",1)  ;AccPD_Type
   	....i PrtStatus="P" s $p(^TMP("WorkLoadDetail",job,PrtUser,"Detail"),"^",2)=$p($g(^TMP("WorkLoadDetail",job,PrtUser,"Detail")),"^",2)+1
   	....e  s $p(^TMP("WorkLoadDetail",job,PrtUser,"Detail"),"^",3)=$p($g(^TMP("WorkLoadDetail",job,PrtUser,"Detail")),"^",3)+1
   	else  do
   	.f PreDate=StDate:1:EndDate d
   	..s RowId="0"
    ..f  s RowId=$o(^DHCACDi("AccM",0,"APDDate",PreDate,RowId)) q:RowId=""  d  //DHCAccPreDeposit
    ...s ChildSub="0"
    ...f  s ChildSub=$o(^DHCACDi("AccM",0,"APDDate",PreDate,RowId,"AccPD",ChildSub)) q:ChildSub=""  d
    ....s PrtDepositInfo=$g(^DHCACD("AccM",RowId,"AccPD",ChildSub))
    ....s myHospDr=$p(PrtDepositInfo,"^",15)
    ....quit:(myHospDr'=HOSPID)
    ....s PrtUser=$p(PrtDepositInfo,"^",5)   ;;;;Guser
    ....quit:((UserRowId'=PrtUser)&&(UserRowId'=""))
	....set PreTime=$p(PrtDepositInfo,"^",4)
	....quit:((PreDate=StDate)&&(StartTime'="")&&(PreTime<StartTime))
	....quit:((PreDate=EndDate)&&(EndTime'="")&&(PreTime>EndTime))    
    ....s PrtStatus=$p(PrtDepositInfo,"^",1)  ;AccPD_Type
   	....i PrtStatus="P" s $p(^TMP("WorkLoadDetail",job,PrtUser,"Detail"),"^",2)=$p($g(^TMP("WorkLoadDetail",job,PrtUser,"Detail")),"^",2)+1
   	....e  s $p(^TMP("WorkLoadDetail",job,PrtUser,"Detail"),"^",3)=$p($g(^TMP("WorkLoadDetail",job,PrtUser,"Detail")),"^",3)+1
   	
   	
   	set userid=""
   	for  set userid=$o(^TMP("WorkLoadDetail",job,userid)) q:userid=""  d
   	.s userLocStr=##class(web.UDHCJFCOMMON).GetUserLocStr(userid,"238^239^240^241^122^131^119")
 	.q:((("^"_userLocStr_"^")["^92^"))||(userLocStr="") ;&&(("^"_userLocStr_"^")'["^1^")	;去除财务收费的数据
   	.s userCode=$p(^SSU("SSUSR",userid),"^",1)
   	.q:(userCode["自助")
   	.s DetailStr=$g(^TMP("WorkLoadDetail",job,userid,"Detail"))
   	.s refundInvNum=$p(DetailStr,"^",1)
   	.s accpreNum=$p(DetailStr,"^",2)
   	.s refaccpreNum=$p(DetailStr,"^",3)
   	.s qfbhNum=$p(DetailStr,"^",4)
	.s reasonDr="0"
	.f  s reasonDr=$o(^TMP("WorkLoadDetail",job,userid,"AdmReason",reasonDr)) q:reasonDr=""  d
   	..s reasonNum=$g(^TMP("WorkLoadDetail",job,userid,"AdmReason",reasonDr))
   	..quit:(+reasonDr="0")
   	..s READesc=$p(^PAC("ADMREA",reasonDr),"^",2)
   	..do OutputWorkLoadDetailnew
   	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputWorkLoadDetailnew
    
	set Data=$lb(userCode,accpreNum,refaccpreNum,refundInvNum,qfbhNum,READesc,reasonNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

}
