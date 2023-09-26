Import SQLUser

Class web.UDHCJFBaseCommon Extends BILL.COM.Abstract
{

/// 是否锁账单表的条数设置
Parameter LimitCount = 3000;

/// Debug: w ##class(web.UDHCJFBaseCommon).Bill("","","364","5816","259057","")
ClassMethod Bill(itmjs As %String = "", itmjsex As %String = "", EpisodeID As %String = "", UserRowID As %String = "", BillNo As %String = "", ComputerName As %String = "") As %String
{
	set BabyFlag=##class(web.UDHCJFORDCHK).getmotheradm(EpisodeID)
    if (BabyFlag="true") {
	    set MotherAdm=$p(^PAADM(EpisodeID),"^",75)
	    set EpisodeID=MotherAdm
    }

 	set BillNum=..JudgeBillNum(EpisodeID)
    quit:(BillNum>1) -1_"^"_"未结算账单数量大于1，不能账单"
    
	set rtnValue=##class(web.UDHCJFBILLIP).BILL(EpisodeID, UserRowID)
 	quit rtnValue
}

ClassMethod JudgeBillNum(Adm)
{
	set count=0
	set pb=0
	while($o(^DHCPB(0,"ADM",Adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",Adm,pb))
		set pbData=$g(^DHCPB(pb))
		set payedFlag=$p(pbData,"^",16)
		continue:(payedFlag="P")
		set count=$i(count)
	}
	quit count
}

ClassMethod JudgeUnPaidBillNum(Adm)
{
	set count=0
	set pb=0
	while($o(^DHCPB(0,"ADM",Adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",Adm,pb))
		set pbData=$g(^DHCPB(pb))
		set payedFlag=$p(pbData,"^",16)
		continue:(payedFlag="P")
		set totoalAmt=$p(pbData,"^",8)
		continue:(+totoalAmt=0)
		set count=$i(count)
	}
	quit count
}

/// Debug: w ##class(web.UDHCJFBaseCommon).regnocon("1")
ClassMethod regnocon(PAPMINo As %String) As %String
{
	quit:(PAPMINo="") ""
	set len=8
	set PATCFid=$o(^CF("PATCF",""))
	if (PATCFid'="") {
		set len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	}
	set PAPMINo=$tr($j(PAPMINo,len)," ","0")
	quit PAPMINo
}

/// Description: 根据就诊ID取患者未结算押金总额
/// Debug: w ##class(web.UDHCJFBaseCommon).deposit(224)
ClassMethod deposit(adm As %String) As %String
{
	set depSum=0
	quit:(+adm=0) depSum
	
	set depRowId=0
	while($o(^DHCSFPRINTDETAIL(0,"adm",adm,depRowId))) {
		set depRowId=$o(^DHCSFPRINTDETAIL(0,"adm",adm,depRowId))
		set depData=$g(^DHCSFPRINTDETAIL(depRowId))
		set prtStatus=$p(depData,"^",8)
		continue:(+prtStatus'=1)
		set depTypeDR=$p(depData,"^",13)
		continue:(+depTypeDR=0)
		set depTypeCode=$p($g(^ARC("ARCDT",depTypeDR)),"^",1)
		continue:(depTypeCode'="01")   //住院押金
		set payedFlag=$p(depData,"^",38)
		continue:(payedFlag="Y")    //过滤参与结算的押金
		set amt=$p(depData,"^",6)
		set depSum=$i(depSum,amt)
	}
	
	quit $fn(depSum,"",2)
}

/// Description: 根据帐单号取患者结算过押金总额
/// Debug: w ##class(web.UDHCJFBaseCommon).arpbldeposit(22624)
ClassMethod arpbldeposit(arpbl As %String) As %String
{
	quit ..GetPaidDeposit(arpbl)
}

/// get current patient's deposits
/// Debug: w ##class(web.UDHCJFBaseCommon).getdeposit(16)
ClassMethod getdeposit(adm As %String) As %String
{
	quit ..deposit(adm)
}

/// 取押金收据号
ClassMethod GetRcptNo(userId As %String, hospId As %String) As %String
{
	set rowId="", endNo="", curNo="", title="", startNo=""
	set myId=0
	while($o(^DHCSFRECEIPT(0,"lquser",userId,myId))&&(rowId="")) {
		set myId=$o(^DHCSFRECEIPT(0,"lquser",userId,myId))
		set data=$g(^DHCSFRECEIPT(myId))
		set hospDR=$p(data,"^",22)
		continue:(hospDR'=hospId)
		set useFlag=$p(data,"^",7)
		continue:(+useFlag'=1)
		set loc=$p(data,"^",15)
		continue:(loc'="I")
		set startNo=$p(data,"^",3)
		set endNo=$p(data,"^",4)
		set curNo=$p(data,"^",5)
		set title=$p(data,"^",9)
		set rowId=myId
	}
	
	set leftNum=+endNo-curNo+1
	set minTipRcptNum=##class(web.DHCBillCommon).GetParamConfigFlag("MinTipRcptNum")
	set tipFlag=$s((leftNum<minTipRcptNum):1, 1:0)  //余票数小于设置值时，界面给予提示(1:提示, 0:不提示)
	
	set rtn=rowId_"^"_endNo_"^"_curNo_"^"_title_"^"_leftNum_"^"_startNo_"^"_tipFlag

	quit rtn
}

/// Description: 发票号自动累加1
/// Debug: w ##class(web.UDHCJFBaseCommon).incre("011")
ClassMethod incre(invno As %String) As %String
{
	set ret=invno+1
	quit ..FormatINVNO(ret, $l(invno))
}

/// Description: 金额大写转换
/// Debug: w ##class(web.UDHCJFBaseCommon).RMBDXXZH("1680.32")
ClassMethod RMBDXXZH(numstr As %String)
{
	s numstr=$tr(numstr," ","")
	s i=0, lendec=0, lenint=0
	S a="", b="", c="", d="", bbak="", bs=""
	s flagzf=""
	s numstr=+numstr
	i (numstr<0) d
	.s numstr=$p(numstr,"-",2)
	.s flagzf=1
	i ($p(numstr,".",1)="")  s numstr="0"_numstr
	s lenint=$l($p(numstr,".",1))
	q:(lenint>13) -1_"^"_"金额过大"
	s lendec=2
	i $p(numstr,".",2)="00" s lendec=0
	s dxint(13)="", dxdec(2)="", sz(13)=""
	s dxstr="万|仟|佰|拾|亿|仟|佰|拾|万|仟|佰|拾|元"
	s szstr="零|壹|贰|叁|肆|伍|陆|柒|捌|玖"
	s lendxstr=$l(dxstr,"|")+1
	s lenszstr=$l(szstr,"|")+1
	f i=1:1:lendxstr d
	.s dxint(i)=$p(dxstr,"|",lendxstr-i)
	.s sz(i)=" "
	.i (i<11)  s sz(i)=$p(szstr,"|",i)
	s dxdec(1)="角", dxdec(2)="分", dxstr=" "
	;**整数部分**
	f i=1:1:lenint d
	.s a=$e($e(numstr,1,lenint),i,i)
	.s b=sz(a+1)
	.s c=dxint(lenint-i+1)
	.s d=" "
	.i (dxstr'=" ")  s d=$e(dxstr,$l(dxstr)-1,($l(dxstr)-1)+2-1)  
	.i (a="0")  s b="",bs="零"
	.i (b="零")&&((d="零")||(b=bbak)||(c="元")||(c="万")||(c="亿"))  s b=""
	.i (a="0")&&(c'="元")&&(c'="万")&&(c'="亿") s c=""
	.i (dxstr["亿")&&($p(dxstr,"亿",2)="")&&(c'="元")&&(a=0) s c=""
	.i (dxstr["万")&&($p(dxstr,"万",2)="")&&(c'="元")&&(a=0) s c=""
	.i ((c="元")||(c="万")||(c="亿"))&&(d="零")&(a="0")  d 
	..s dxstr=$e(dxstr,1,1+($l(dxstr)-2)-1)
	.s d=$e(dxstr,$l(dxstr)-1,($l(dxstr)-1)+2-1)
	.i (c="元")&&(d="万")&&(c="万")&&(d="亿")  s c=""
	.i (bs="零")&&(a'=0)&&(a'="") s b=bs_b, bs=""
	.s dxstr=dxstr_b_c, bbak=b
	;
	;**小数部分**
	i ($p(numstr,".",2)=0)||(lendec=0)||($p(numstr,".",2)="")  s dxstr=dxstr_"整"
	i ($p(numstr,".",2)>0) d
	.f i=1:1:lendec d
	..s a=$e($p(numstr,".",2),i,i)
	..s b=sz(a+1)
	..i ((a="0")&&(dxdec(i)="分"))  s b=""
	..i (a="0")  s dxstr=dxstr_b
	..i (a'="0")  s dxstr=dxstr_b_dxdec(i)
	
	//+2018-06-07 ZhYW
	s dxstr=$tr(dxstr, " ", "")
	i (+numstr=0) d
	.s dxstr="零"_dxstr
	e  i (+numstr<0.1) d
	.s dxstr=$e(dxstr,3,$l(dxstr))
	e  i (+numstr<1)  d
	.s dxstr=$e(dxstr,2,$l(dxstr))
	
	i (flagzf=1)  d
	.s dxstr="负"_dxstr
	.s fudxstr=$p(dxstr," ",1)
	.s dxstrsum=$p(dxstr," ",2)
	.s dxstr=fudxstr_dxstrsum
	e  s dxstr=dxstr
	
	q dxstr
}

/// Description: 取患者基本信息，就诊信息
/// Debug: w ##class(web.UDHCJFBaseCommon).GetPatAdmInfo("123", 12)
ClassMethod GetPatAdmInfo(Adm As %String, PAPMI As %String, BillNo As %String)
{
	set Adm=$g(Adm), PAPMI=$g(PAPMI)
	quit:((Adm="")&&(PAPMI="")) ""
	if (Adm'="")&&(PAPMI="") {
		set PAPMI=$p(^PAADM(Adm),"^",1)
	}
	set PapNo=$p($g(^PAPER(PAPMI,"PAT",1)),"^",1)     //登记号
	set MedicareNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(Adm, "I", "")
	set PatName=$p($g(^PAPER(PAPMI,"ALL")),"^",1)     //姓名
	set PatIDNo=$p($g(^PAPER(PAPMI,"ALL")),"^",9)     //身份证
	set SexDR=$p($g(^PAPER(PAPMI,"ALL")),"^",7)       //性别
	set Sex=$s((+SexDR'=0):$p($g(^CT("SEX",SexDR)),"^",2),1:"")
	set Payibaoshouce=""
	set PapSecondPhone=$p($g(^PAPER(PAPMI,"PER",4)),"^",18)         //工作单位
	set Paplinkman=$p($g(^PAPER(PAPMI,"PER",2)),"^",13)             //联系人姓名
	set Paplinkrelation=$p($g(^PAPER(PAPMI,"ALL")),"^",4)           //联系人关系
	set Paplinkaddress=$p($g(^PAPER(PAPMI,"PER",1)),"^",1)          //联系人地址
	set Paplinkphone=$p($g(^PAPER(PAPMI,"ALL")),"^",4)              //联系人电话
 	set Address=$g(^PAPER(PAPMI,"PER","ADD",1))            //地址
 	//add by wangjian 2015-01-15 增加患者密级和级别
    set PatEncryptLevel=..GetPatEncryptLevel(PAPMI, "")
    set EncryptLevel=$p(PatEncryptLevel,"^",1)
	set PatLevel=$p(PatEncryptLevel,"^",2)
    //end
	set PatInfo=PapNo_"^"_PatName_"^"_MedicareNo_"^"_PatIDNo_"^"_Sex_"^"_Address_"^"_PapSecondPhone_"^"_Paplinkman_"^"_Paplinkrelation_"^"_Paplinkaddress_"^"_Paplinkphone_"^"_Payibaoshouce_"^"_EncryptLevel_"^"_PatLevel
	quit:(Adm="") PatInfo
	
	set AdmInOutDateInfo=..GetAdmInOutDatebyEpisodeID(Adm)
	set AdmDate=$p(AdmInOutDateInfo,"^",1)
	set AdmTime=$p(AdmInOutDateInfo,"^",2)
	set StayDate=$p(AdmInOutDateInfo,"^",3)
	set DisDate=$p(AdmInOutDateInfo,"^",4)
	set DisTime=$p(AdmInOutDateInfo,"^",5)
	set AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
	set AdmTime=##class(websys.Conversions).TimeLogicalToHtml(AdmTime)
	
	set WardDR=$p(^PAADM(Adm),"^",70)
	set WardDesc=$s((+WardDR'=0):$p($g(^PAWARD(WardDR)),"^",2),1:"")
	set LocDR=$p(^PAADM(Adm),"^",4)
	set LocDesc=$s((+LocDR'=0):$p(^CTLOC(LocDR),"^",2),1:"")
	set AdmReaDR=$p(^PAADM(Adm,1),"^",7)
	set AdmReason=$s((AdmReaDR'=""):$p($g(^PAC("ADMREA",AdmReaDR)),"^",2),1:"")
	set BedNo=##class(web.DHCBillCommon).GetPatBedCode(Adm)
	set AdmInDays=..GetPatAdmInDays(Adm, BillNo)
	set BillDateFrom=$p(AdmInDays,"^",1)
	set BillDateTo=$p(AdmInDays,"^",2)
    
	set AdmInfo=BillDateFrom_"^"_BillDateTo_"^"_AdmReason_"^"_LocDesc_"^"_WardDesc_"^"_BedNo_"^"_StayDate_"^"_AdmDate_"^"_AdmTime
	quit PatInfo_"#"_AdmInfo
}

/// Debug: w ##class(web.UDHCJFBaseCommon).FormatINVNO("123", 12)
ClassMethod FormatINVNO(INVNO As %String, len As %String)
{
	if ($l(INVNO)<len) {
		set INVNO=$tr($j(INVNO,len)," ","0")
	}
	quit INVNO
}

Query admreasonlookup() As websys.Query(ROWSPEC = "type:%String,typeid:%String")
{
}

ClassMethod admreasonlookupExecute(ByRef qHandle As %Binary) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set rowid=0
	&sql(declare typec cursor  for 
	select REA_rowid,REA_Desc from PAC_AdmReason)
	&sql(open typec)
	for  &sql(fetch typec into :typerowid,:typedesc) quit:SQLCODE  do
	.&sql(select REA_DateFrom,REA_DateTo into :stdate,:enddate from PAC_AdmReason where REA_RowId=:typerowid)
 	.quit:(((stdate>+$h)&&(stdate'=""))||((enddate<+$h)&&(enddate'="")))  //不在有效期的费别不显示 add zhli  17.9.7
 	.do OutputAdmReason
 	&sql(close typec)
 	
	quit $$$OK
OutputAdmReason
	set Data=$lb(typedesc,typerowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: yyx
/// CreatDate: 2009-02-25
/// Modify: ZhYW 2021-11-25
/// Description: 根据患者的就诊RowId, 账单RowId，取患者本次结算的起始日期，结束日期和住院天数  
/// Input: adm:PA_Adm.RowId, bill:DHC_PatientBill.RowId
/// Return: 账单结算的起始日期，结束日期和本次结算的天数
/// Debug: w ##class(web.UDHCJFBaseCommon).GetPatAdmInDays(55, 76)
ClassMethod GetPatAdmInDays(adm As %String, bill As %String) As %String
{
	quit:(bill="") ""
	
	set fstBill=""   //第一笔账单
	set lstBill=""   //最后一笔账单
	set billDateFrom=999999
	set billDateTo=0
	
	set pb=0
	while($o(^DHCPB(0,"ADM",adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",adm,pb))
		set pbData=$g(^DHCPB(pb))
		set refundFlag=$p(pbData,"^",17)
		continue:(refundFlag="R")        //过滤取消结算负记录
		set pbDateFrom=$p(pbData,"^",6)
		set pbDateTo=$p(pbData,"^",7)
		if (pbDateFrom<billDateFrom) {
			set fstBill=pb
			set billDateFrom=pbDateFrom
		}
		if (pbDateTo>=billDateTo) {
			set lstBill=pb
			set billDateTo=pbDateTo
		}
	}
	
	set admInOutDateInfo=..GetAdmInOutDatebyEpisodeID(adm)   //取入院日期和出院日期
	set admDate=$p(admInOutDateInfo,"^",1)      //入院日期
	set dischDate=$p(admInOutDateInfo,"^",4)    //出院日期
	
	set billData=$g(^DHCPB(bill))
	set dateFrom=$p(billData,"^",6)
	set dateTo=$p(billData,"^",7)
	if (bill=fstBill) {
		set dateFrom=$s((+admDate'=0):admDate,1:dateFrom)   //若该账单是第一笔账单，则账单日期取入院日期
	}
	if (bill=lstBill) {
		set dateTo=$s((+dischDate'=0):dischDate,1:dateTo)   //若该账单是最后一笔账单，则账单日期取出院日期
		set admDays=dateTo-dateFrom       //若该账单是最后一笔账单，则住院天数为结束日期-开始日期
	}else {
		set admDays=dateTo-dateFrom+1     //若该账单不是最后一笔账单，则住院天数为结束日期-开始日期+1
	}
	if (admDays=0) set admDays=1
	
	set dateFromDisplay=##class(websys.Conversions).DateLogicalToHtml(dateFrom)
	set dateToDisplay=##class(websys.Conversions).DateLogicalToHtml(dateTo)
	
	set rtn=dateFromDisplay_"^"_dateToDisplay_"^"_admDays
	
	quit rtn
}

/// Creator: lrl
/// CreatDate: 2009-02-23
/// Description: 根据患者的收费类别和业务类型取收据类型
/// Table: User.DHCSOPADMReasonExp
/// Input: InsType:收费类别rowid;FairType:挂号还是收费的标记,R代表挂号,F代表收费
/// Return: 收据类型
/// Others：w ##class(web.UDHCJFBaseCommon).GetInsInvType(16, "F")
ClassMethod GetInsInvType(InsType As %String, FairType As %String) As %String
{
	set InsInvType=""
	quit:(InsType="") InsInvType
	quit:'$d(^DHCSOPADMRExpi(0,"ADMR",InsType)) InsInvType
	if ((FairType="")||(FairType="F")) {
		set myFairType="O"
	}else {
		set myFairType=FairType
	}
	set myId=0
	while($o(^DHCSOPADMRExpi(0,"ADMR",InsType,myId))'="") {
		set myId=$o(^DHCSOPADMRExpi(0,"ADMR",InsType,myId))
		set myObj=##Class(User.DHCSOPADMReasonExp).%OpenId(myId, 0)
		continue:('$IsObject(myObj))
		set SARENote1=myObj.SARENote1
		if (SARENote1'=myFairType) {
			do myObj.%Close()
			continue
		}
		set InsInvType=myObj.SAREUseFareType
		set InsInvXML=myObj.SARENote2
		do myObj.%Close()
	}
	quit InsInvType
}

/// Creator: 杨艳秀
/// CreateDate: 2009-05-11
/// Description: 根据患者就诊取患者的押金和费用
/// Input: Adm
/// Return: 押金_"^"_费用_"^"_余额
ClassMethod GetAdmDepositAndFee(Adm As %String) As %String
{
	set PatFee=0
	set AdmDeposit=..deposit(Adm)
    set Bill=0
    for  set Bill=$o(^DHCPB(0,"ADM",+Adm,Bill)) quit:(Bill="")  do
    .set PBData=$g(^DHCPB(Bill))
    .set BillFlag=$p(PBData,"^",16)
    .quit:(BillFlag="P")
    .set PBAmount=$p(PBData,"^",8)
    .set PatFee=$i(PatFee, PBAmount)
    
    set RetVal=AdmDeposit_"^"_PatFee_"^"_$fn((AdmDeposit-PatFee),"",2)
    quit RetVal
}

/// Creator: 杨艳秀
/// CreatDate: 2008-2-20
/// Description: 根据账单号返回账单的结账信息
/// Table: dhc_patientbill
/// Input: dhc_patientbill.pb_rowid
/// Return: 账单的结算状态
ClassMethod GetPayFlagByBillNo(BillNo)
{
	quit:'$d(^DHCPB(BillNo)) "P"
	set PaidFlag=$p(^DHCPB(BillNo),"^",16)
	quit PaidFlag
}

ClassMethod GetAdmSource(AdmReaRowID)
{
	set AdmSource=$p(^PAC("ADMREA",AdmReaRowID),"^",9)
	quit AdmSource
}

/// Creator: Lid
/// CreatDate: 2010-07-09
/// Description: 根据账单号获取费用信息
/// Input: billId:DHC_PatientBill.RowId, expStr:扩展字段
/// Return: 押金$c(2)总金额^自付金额^折扣金额^记账金额$c(2)应收/应退金额
/// Debug: w ##class(web.UDHCJFBaseCommon).GetPatFeeByBillNO("281976", "")
ClassMethod GetPatFeeByBillNO(billId As %String, expStr As %String = "") As %String
{
	quit:((+billId=0)||('$d(^DHCPB(billId)))) ""
	
	set BillData=$g(^DHCPB(billId))
	set adm=$p(BillData,"^",1)
	set admReaDR=$p(BillData,"^",4)
	set totalAmt=+$p(BillData,"^",8)     //总金额
	set shareAmt=+$p(BillData,"^",12)    //自付费用
	set discAmt=+$p(BillData,"^",9)      //折扣费用
	set payorAmt=+$p(BillData,"^",11)    //记账费用
	
	set prtRowId=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(billId)
	//获取押金
	if (+prtRowId'=0) {
		set deposit=$p($g(^DHCINVPRTZY(prtRowId)),"^",22)
	}else {
		//set deposit=..getdeposit(adm)
		set deposit=..depositBankBack(adm)
	}
	//+2017-08-09 ZhYW 取医保分解金额
	set insuPayAmt=0
	set nationCode=$p(^PAC("ADMREA",admReaDR),"^",5)
	if (+nationCode>0) {
		set insuInfo=##class(web.DHCINSUPort).GetDivideByPBDr("", billId)
		set DivInfo=$p(insuInfo,"!^",2)
		set insuTotalAmt=$p(DivInfo,"^",7)
		set insuPatSelfAmt=$p(DivInfo,"^",15)
		set insuPayAmt=insuTotalAmt-insuPatSelfAmt
	}
	set stAmt=$fn((shareAmt-deposit-insuPayAmt),"",2)    //应收/应退金额=自付费用-押金-折扣-记账-insu
	set rtn=$fn(deposit,"",2)_$c(2)_$fn(totalAmt,"",2)_"^"_$fn(shareAmt,"",2)_"^"_$fn(discAmt,"",2)_"^"_$fn(payorAmt,"",2)_$c(2)_stAmt
	set rtn=rtn_$c(2)_$fn(insuPayAmt,"",2)
	quit rtn
}

/// Creator: tangtao
/// CreatDate: 2011-01-17
/// Description: 根据账单号取账单金额
/// Debug: w ##class(web.UDHCJFBaseCommon).GetAdmDepositAndFeeByBillNo(13)
ClassMethod GetAdmDepositAndFeeByBillNo(Adm As %String, BillNo As %String) As %String
{
    set PBAmount=$p(^DHCPB(BillNo),"^",8)
    set PrtRowId=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(BillNo)
    if (+PrtRowId=0) {
	    //账单未结算
	    set AdmDeposit=..deposit(Adm)
	    set RetVal=$fn(AdmDeposit,"",2)_"^"_$fn(PBAmount,"",2)_"^"_$fn((AdmDeposit-PBAmount),"",2)
	}else {
		set AdmDeposit=..GetPaidDeposit(BillNo)
		set RetVal=$fn(AdmDeposit,"",2)_"^"_$fn(PBAmount,"",2)_"^"_0.00
	}
    quit RetVal
}

/// Creator: ZhYW
/// CreateDate: 2020-09-16
/// Description: 根据患者就诊取住院大类费用
/// Debug: w ##class(web.UDHCJFBaseCommon).GetAdmCateFee(13) 
ClassMethod GetAdmCateFee(adm As %String) As %String
{
	set hospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	
	kill cateAry
	
	set pb=0
	for  set pb=$o(^DHCPB(0,"ADM",adm,pb)) quit:(pb="")  do
	.set pbo=0
	.for  set pbo=$o(^DHCPB(pb,"O",pbo)) quit:(pbo="")  do
	..set pbd=0
	..for  set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd))  quit:(pbd="")  do
	...set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
	...quit:(pbdData="")
	...set itmDR=$p(pbdData,"^",3)            //收费项目
	...set totalAmt=$p(pbdData,"^",7)         //总金额
	...set discAmt=$p(pbdData,"^",8)          //折扣金额
	...set payorAmt=$p(pbdData,"^",9)         //记帐金额 
    ...set patShareAmt=$p(pbdData,"^",10)     //自付金额
	...set subCateDR=$p($g(^DHCTARI(itmDR)),"^",14)     //住院费用子分类         
	...set cateDR=$p(^DHCTarC("IC",subCateDR),"^",3)     //住院费用大类
	...set cateAry(cateDR)=$g(cateAry(cateDR))+totalAmt
	
	set rtn=""
	set rowId=0
	for  set rowId=$o(^DHCTarC("TIC",rowId))  quit:(rowId="")  do
	.set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarIC", rowId, hospId)
	.quit:(showFlag="N")
	.set data=$g(^DHCTarC("TIC",rowId))
	.quit:(data="")
	.set cateDesc=$p(data,"^",2)
	.set myStr=cateDesc_"^"_$fn($g(cateAry(rowId)),"",2)
	.set rtn=$s((rtn=""):myStr,1:(rtn_"&"_myStr))

	quit rtn
}

/// Creator: Lid
/// CreatDate: 2009-10-23
/// Description: 获取患者诊断信息.
/// Table：        MR_Diagnos(^MR)  患者诊断信息(MR_Adm的子表)
///                MR_Adm(^MR,^MRi)  患者诊断数据（父表）
/// 			   MRC_ICDDx(^MRC("ID")) 诊断描述
/// 			   MRC_DiagnosType(^MRC("DTYPE")) 诊断类型表(MR_Diagnos的子表)
/// DIS	出院诊断
/// M	主诊断
/// PRE	入院诊断
/// C008	次诊断
/// Input：        MR_adm的rowid,diagnosType是MRC_DiagnosType的DTYP_Code的值，如果为空，则取所有类型的诊断
/// Return：       序号^ICD码^ICD名称^(描述)^诊断类型代码^诊断类型描述||序号^ICD码^ICD名称^(描述)^诊断类型代码^诊断类型描述
/// Other：  	   MRAdmRowid=$p(^PAADM(admRowid),"^",61)
/// Debug: w ##class(web.UDHCJFBaseCommon).GetPatDiagnos("758710","M")
ClassMethod GetPatDiagnos(MRAdmRowid As %String, diagnosType As %String) As %String
{
	q:(MRAdmRowid=1) "-1"
	s Childsub=0,i=0,ICDCode="",ICDDesc="",MRCTypeCode="",MRCTypeDesc="",OutStr=""
	f  s Childsub=$o(^MR(MRAdmRowid,"DIA",Childsub))  q:((Childsub="")||(i=Childsub))   d
	.s MRStr=$g(^MR(MRAdmRowid,"DIA",Childsub))
	.s ICDCodeDr=$p(MRStr,"^",1)
	.q:(ICDCodeDr="")
	.s ICDCode=$p(^MRC("ID",ICDCodeDr),"^",4)
	.s ICDDesc=$p(^MRC("ID",ICDCodeDr),"^",2)
	.q:$d(^MR(MRAdmRowid,"DIA",Childsub,"TYP"))=0
	.s MRCDiagnosTypeDr=$g(^MR(MRAdmRowid,"DIA",Childsub,"TYP",1))
	.s MRCTypeCode=$p(^MRC("DTYP",MRCDiagnosTypeDr),"^",1)
	.q:(diagnosType'="")&&(diagnosType'=MRCTypeCode)
	.s MRCTypeDesc=$p(^MRC("DTYP",MRCDiagnosTypeDr),"^",2)
	.s i=Childsub
	.i (OutStr="") s OutStr=Childsub_"^"_ICDCode_"^"_ICDDesc_"^"_MRCTypeCode_"^"_MRCTypeDesc
	.e  s OutStr=OutStr_"||"_Childsub_"^"_ICDCode_"^"_ICDDesc_"^"_MRCTypeCode_"^"_MRCTypeDesc
	
	q OutStr
}

/// Description: 根据ADM取患者未结算押金总额
/// Debug: w ##class(web.UDHCJFBaseCommon).depositBankBack(172)
ClassMethod depositBankBack(adm As %String) As %String
{
	set depSum=0
	quit:(adm="") depSum
	
	set depRowId=0
	while($o(^DHCSFPRINTDETAIL(0,"adm",adm,depRowId))) {
		set depRowId=$o(^DHCSFPRINTDETAIL(0,"adm",adm,depRowId))
		set depData=$g(^DHCSFPRINTDETAIL(depRowId))
		set prtStatus=$p(depData,"^",8)
		continue:(+prtStatus'=1)
		set depTypeDR=$p(depData,"^",13)
		continue:(+depTypeDR=0)
		set depTypeCode=$p($g(^ARC("ARCDT",depTypeDR)),"^",1)
		continue:(depTypeCode'="01")   //住院押金
		set payedFlag=$p(depData,"^",38)
		continue:(payedFlag="Y")    //过滤参与结算的押金
		set rtnValue=##class(BILL.IP.COM.Method).ChkDepCanToPay(depRowId)   //+2023-04-04 ZhYW 判断押金是否能参与结算
		set billFlag=$p(rtnValue,"^",1)
		continue:(billFlag=0)
		set amt=$p(depData,"^",6)
		set depSum=$i(depSum,amt)
	}
	
	quit $fn(depSum,"",2)
}

/// Description: 根据账单Id取患者已结算押金总额
/// Input: billId:DHC_PatientBill.RowId
/// Debug: w ##class(web.UDHCJFBaseCommon).GetPaidDeposit()
ClassMethod GetPaidDeposit(billId As %String) As %String
{
	set deposit=0
	quit:(+billId=0) deposit
	set prtRowId=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(billId)
	quit:(+prtRowId=0) deposit
	set deposit=$p($g(^DHCINVPRTZY(prtRowId)),"^",22)
	quit $fn(deposit,"",2)
}

/// Lid
/// 2011-03-30
/// 通过卡号获取患者登记号
/// CardNO:卡号
/// 返回值:卡号^Pa_patmas表rowid^登记号^卡类型指针^卡类型代码^卡类型描述^收费标志
/// w ##class(web.UDHCJFBaseCommon).GetPapmiByCardNO("9999990103339054")
ClassMethod GetPapmiByCardNO(cardNO)
{
	s activeFlag=1
	s rowid=0
	f  s rowid=$o(^DHCCARDi("CF",0,"CardNo",cardNO,rowid)) q:(rowid="")  d
	.s status=$p(^DHCCARD("CF",rowid),"^",10) ;CF_ActiveFlag Normal||N  正常 Suspend||S  挂失 Reclaim||R  回收 Depose||D  作废	
	.q:(status'="N")
	.s papmiDr=$p(^DHCCARD("CF",rowid),"^",4) ;Pa_patmas Rowid
	.s papmiNO=$p(^DHCCARD("CF",rowid),"^",6) ;登记号
	.s cardTypeDr=$p(^DHCCARD("CF",rowid),"^",16) ;卡类型指针
	.s cardTypeCode=$p(^DHCCARDTYPEDef(cardTypeDr),"^",1) ;卡类型代码
	.s cardTypeDesc=$p(^DHCCARDTYPEDef(cardTypeDr),"^",2) ;卡类型描述
	.s fairType=$p(^DHCCARDTYPEDef(cardTypeDr),"^",18)
	.s Medicare=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(papmiDr, "I", "", "")
	.s activeFlag=0
	
	q:(activeFlag=1) -1   //卡不存在
	
	q $g(cardNO)_"^"_$g(papmiDr)_"^"_$g(papmiNO)_"^"_$g(cardTypeDr)_"^"_$g(cardTypeCode)_"^"_$g(cardTypeDesc)_"^"_$g(fairType)_"^"_$g(Medicare)
}

/// Lid
/// 多字符替换功能
/// w ##class(web.UDHCJFBaseCommon).Replace("FootAAABBBB","AAA","CC")
ClassMethod Replace(Strings, Str, Rep) As %String [ Language = basic ]
{
	return Replace(Strings, Str, Rep)
}

/// Lid
/// 2011-03-03
/// 获取患者的有效卡号
/// patNO:登记号,papmiDr:Pa_patmas表rowid, adm:就诊号
/// 返回值:卡号^Pa_patmas表rowid^登记号^卡类型指针^卡类型代码^卡类型描述^收费标志
/// w ##class(web.UDHCJFBaseCommon).GetCardNOByPAPMI("00638262","","")
ClassMethod GetCardNOByPAPMI(patNO, papmiDr, adm)
{
	q:((+patNO=0)&&(+papmiDr=0)&&(+adm=0)) ""
	s cardNO=""

	i ((papmiDr="")&&(patNO=""))  d
	.s papmiDr=$p(^PAADM(adm),"^",1)

    i ((papmiDr="")&&(adm=""))  d
	.i (patNO'="") d
	..s patNO=##class(web.UDHCJFBaseCommon).regnocon(patNO)
	.i (patNO'="") s papmiDr=$o(^PAPERi("PAPMI_PatNo",patNO,""))
	
	q:(papmiDr="") $g(cardNO)_"^"_$g(papmiDr)_"^"_$g(patNO)_"^"_$g(cardTypeDr)_"^"_$g(cardTypeCode)_"^"_$g(cardTypeDesc)_"^"_$g(fairType)
	
	s rowid=0
	f  s rowid=$o(^DHCCARDi("CF",0,"PAPMIDR",papmiDr,rowid)) q:rowid=""  d
	.s status=$p(^DHCCARD("CF",rowid),"^",10) ;CF_ActiveFlag Normal||N  正常 Suspend||S  挂失 Reclaim||R  回收 Depose||D  作废	
	.q:(status'="N")
	.s cardNO=$p(^DHCCARD("CF",rowid),"^",2) ;卡号
	.s papmiDr=$p(^DHCCARD("CF",rowid),"^",4) ;Pa_patmas Rowid
	.s papmiNO=$p(^DHCCARD("CF",rowid),"^",6) ;登记号
	.s cardTypeDr=$p(^DHCCARD("CF",rowid),"^",16) ;卡类型指针
	.s cardTypeCode=$p(^DHCCARDTYPEDef(cardTypeDr),"^",1) ;卡类型代码
	.s cardTypeDesc=$p(^DHCCARDTYPEDef(cardTypeDr),"^",2) ;卡类型描述
	.s fairType=$p(^DHCCARDTYPEDef(cardTypeDr),"^",18)   ;
	
	q $g(cardNO)_"^"_$g(papmiDr)_"^"_$g(papmiNO)_"^"_$g(cardTypeDr)_"^"_$g(cardTypeCode)_"^"_$g(cardTypeDesc)_"^"_$g(fairType)
}

/// Description: 取转存的预交金
/// Debug: w ##class(web.UDHCJFBaseCommon).GetTransDeposit()
ClassMethod GetTransDeposit(Adm As %String) As %String
{
	s TransDep=0
	s PrtRowID=0
	f  s PrtRowID=$o(^DHCSFPRINTDETAIL(0,"adm",Adm,PrtRowID)) q:(PrtRowID="")  d
	.s PrtData=$g(^DHCSFPRINTDETAIL(PrtRowID))
	.s PrtStatus=$p(PrtData,"^",8)
	.q:(+PrtStatus=2)
	.s TransFlag=$p(PrtData,"^",39)
	.q:(TransFlag'="Y")
	.s PayAmt=$p(PrtData,"^",6)
	.s TransDep=$i(TransDep, PayAmt)
	
	q TransDep
}

ClassMethod GetInvXMLName(InsType As %String) As %String
{
	s XMLName="" 
	q:(InsType="") XMLName
	
	s SareRowid=0
	f  s SareRowid=$o(^DHCSOPADMRExpi(0,"ADMR",InsType,SareRowid)) q:(SareRowid="")  d
	.s XMLName=$p(^DHCSOPADMRExp(SareRowid),"^",4)
	
	q XMLName
}

ClassMethod GetReaQualifStatus(BillNo)
{
	set AdmReason=$p(^DHCPB(BillNo),"^",4)
	quit:(AdmReason="") 0
	set QualifStatus=$p(^PAC("ADMREA",AdmReason),"^",10)
	quit +QualifStatus
}

/// Creator: Lid
/// CreateDate: 2013-11-20
/// Description: 取某个就诊的账单状态取患者的账单费用信息
/// Input: EpisodeID:PA_Adm.RowId(不能为空), PayedFlag:账单状态(可以为空), ExpStr:扩展串(可以为空)
/// Return: 总金额^折扣金额^记账金额^自付金额
/// Debug: w ##class(web.UDHCJFBaseCommon).GetPatFeeByEpisodeID("","","")
ClassMethod GetPatFeeByEpisodeID(EpisodeID As %String, PayedFlag As %String = "", ExpStr As %String = "")
{
	quit:(+EpisodeID=0) "0^0^0^0"
	set totalSum=0, discSum=0, payorSum=0, patShareSum=0
	set pb=0
	while($o(^DHCPB(0,"ADM",EpisodeID,pb))) {
		set pb=$o(^DHCPB(0,"ADM",EpisodeID,pb))
		set pbData=$g(^DHCPB(pb))
	    set pbPayedFlag=$p(pbData,"^",16)
	    continue:((PayedFlag'="")&&(PayedFlag'=pbPayedFlag))
	    set totalAmt=$p(pbData,"^",8)
	    set discAmt=$p(pbData,"^",9)
	    set payorAmt=$p(pbData,"^",11)
		set patShareAmt=$p(pbData,"^",12)
	    set totalSum=$i(totalSum, totalAmt)
	    set discSum=$i(discSum, discAmt)
	    set payorSum=$i(payorSum, payorAmt)
		set patShareSum=$i(patShareSum, patShareAmt)
	}

    set rtn=$fn(totalSum,"",2)_"^"_$fn(discSum,"",2)_"^"_$fn(payorSum,"",2)_"^"_$fn(patShareSum,"",2)
    
    quit rtn
}

/// Debug: w ##class(web.UDHCJFBaseCommon).DelPBONullData(212213)
ClassMethod DelPBONullData(BillNO As %String) As %String
{
	set PBO=0
	for  set PBO=$o(^DHCPB(BillNO,"O",PBO)) quit:(PBO="")  do
	.if $d(^DHCPB(BillNO,"O",PBO))=10 do
	..kill ^DHCPB(BillNO,"O",PBO)
	
	quit 0
}

/// Creator: Lid
/// CreatDate: 2014-06-19
/// Description: 是否锁表标志
/// Input: Adm:就诊号, Bill:账单号
/// Debug: w ##class(web.UDHCJFBaseCommon).IsNoLockTable(605,"","")
ClassMethod IsNoLockTable(Adm As %String, Bill As %String, LimitCount As %String = "") As %String
{
	;优先级：Adm与Bill都不为空时，Bill的优先级高
	;条数：医嘱执行记录表(oe_ordexec)或账单医嘱表(dhc_patbilldetails)的数量大于3000条时，
	;重新账单或取消结算时不锁dhc_patbillorder、dhc_patbilldetails
	
	if (LimitCount="") set LimitCount=..#LimitCount
	
	set num=0
	if (Bill'="") {
		&SQL(SELECT count(*) into:num from SQLUser.dhc_patbilldetails where pbd_pbo_parref->pbo_pb_parref=:Bill)
	}else {
		&SQL(SELECT count(*) into:num from SQLUser.oe_ordexec where oeore_oeori_parref->oeori_oeord_parref->oeord_adm_dr=:Adm)	
	}
	if (+num>+LimitCount) set NoLockFlag="NoLock"
	else  set NoLockFlag="" 
	
	quit NoLockFlag
}

/// Creator: Lid
/// CreateDate: 2012-06-14
/// Description: 根据就诊RowID取患者的留观状态
/// Return: 标志(Y:留观,N:非留观)^值(1:留观出院, 2:正在留观, -1:非留观)
/// Debug: w ##class(web.UDHCJFBaseCommon).GetPatAdmStayStat(655)
ClassMethod GetPatAdmStayStat(Adm As %String) As %String
{
   	set StatCode=##class(web.UDHCJFBaseCommon).GetObsPatYetDisHosp(Adm)
   	set StayFlag=$s((StatCode>0):"Y",1:"N")
   	set rtn=StayFlag_"^"_StatCode
   	quit rtn
}

/// Creator: yyx
/// CreatDate: 2015-08-11
/// Description: 判断患者是否正在留观
/// Return: 0:否, 1:是
/// Debug: w ##class(web.UDHCJFBaseCommon).GetPatStayStat("52")
ClassMethod GetPatStayStat(PatientId As %String) As %String
{
	set rtn=0
	quit:(+PatientId=0) rtn
	
	set Adm=0
	while($o(^PAPERdr(PatientId,"ADM","E",Adm))) {
		set Adm=$o(^PAPERdr(PatientId,"ADM","E",Adm))
		continue:(##class(web.UDHCJFBaseCommon).GetObsPatYetDisHosp(Adm)'=2)  //1:留观出院, 2:正在留观, -1:非留观
		set rtn=1
		quit
	}
	quit rtn
}

/// Description: 取发票的留观标识
/// Debug: w ##class(web.UDHCJFBaseCommon).GetPrtInvStat("")
ClassMethod GetPrtInvStat(PrtRowID As %String) As %String
{
	quit:(+PrtRowID=0) ""
	set PrtInvStatFlag=$p($g(^DHCINVPRT(PrtRowID)),"^",44)  //发票上的急诊留观标志
	quit PrtInvStatFlag
}

/// Creator: wangjian
/// CreatDate: 2015-01-15
/// Description: 取患者密级和患者级别
/// Input: PatientID:患者ID, Adm:就诊号
/// Return: EncryptLevel^PatLevel 或 空
/// Debug: w ##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PatientID)
ClassMethod GetPatEncryptLevel(PatientID As %String, Adm As %String) As %String
{
	if ((+PatientID=0)&&(+Adm'=0)) {
		set PatientID=$p(^PAADM(Adm),"^",1)
	}
	quit:(+PatientID=0) "^"
	set ErrMsg=""
	set EncryptLevelStr=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID, .ErrMsg)
	quit EncryptLevelStr
}

/// Creator: Lid
/// CreatDate: 2010-06-10
/// Description: 通过医嘱RowId判断医嘱录入人是否为医护人员
/// Input: 
/// Return: 0:是, 1:否
/// Debug: w ##class(web.UDHCJFBaseCommon).CheckISCareProvByOeoriDr("1044680||3")
ClassMethod CheckISCareProvByOeoriDr(oeitm As %String) As %String
{
	set ordAddUser=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),7)),"^",1) //医嘱录入人
	set adm=$p(^OEORD(+oeitm),"^",1)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	quit '..CheckISCashier(ordAddUser, hospDR)
}

/// Creator: Lid
/// CreatDate: 2010-06-10
/// Description: 判断用户是否为收费员
/// Input: userId:SS_User.RowId, hospId:CT_Hospital.RowId
/// Return: 0:是, 1:否
/// Debug: w ##class(web.UDHCJFBaseCommon).CheckISCashier(6402, 2)
ClassMethod CheckISCashier(userId As %String, hospId As %String) As %String
{
	set rtn=1
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_RcptGroupUser", hospId)
	
	set rowId=0
	for  set rowId=$o(^DHCJFRcptGroupSet(rowId)) quit:((rowId="")||(+rtn=0))  do
    .set sub=0
    .for  set sub=$o(^DHCJFRcptGroupSet(rowId,"Sub",sub)) quit:(sub="")  do
    ..set data=$g(^DHCJFRcptGroupSet(rowId,"Sub",sub))
    ..quit:(data="")
	..set hospDR=$p(data,"^",5)
	..quit:(hospDR'=defHospId)
	..set userDR=$p(data,"^",4)
	..if (userId=userDR) set rtn=0
	
	quit rtn
}

/// Creator: 杨艳秀
/// CreateDate: 2015-12-12
/// Description: 根据患者就诊取患者的押金和费用
/// Input: Adm
/// Output: 押金_"^"_费用_"^"_医保费用_"^"_押金余额_"^"_待记账费用
/// Debug: w ##class(web.UDHCJFBaseCommon).GetDepositFeeByAdm(5)
ClassMethod GetDepositFeeByAdm(Adm As %String) As %String
{
	s TotalAmount=0, PatFee=0, InsuFee=0
    s Bill=0
    f  s Bill=$o(^DHCPB(0,"ADM",+Adm,Bill)) q:(Bill="")  d
    .s PBData=$g(^DHCPB(Bill))
    .s BillFlag=$p(PBData,"^",16)
    .q:(BillFlag="P")
    .s PBAmount=$p(PBData,"^",8)
    .s PBPatShare=$p(PBData,"^",12)
    .s TotalAmount=$i(TotalAmount, PBAmount)
    .s PatFee=PatFee+PBPatShare
    
	s AdmDeposit=..deposit(Adm)
    //InsuFee  调用医保接口，需要修改
    s PatFee=PatFee-InsuFee      //自费金额
    s PatRemain=AdmDeposit-PatFee
	s PatRemain=$fn(PatRemain,"",2)
    //s PayableInfo=##class(web.DHCIPBillPayableFee).BILL(Adm)   //暂时不考虑
	//s PayablePatFee=$p(PayableInfo,"^",4)
	s NotBillFee=0  //PayablePatFee-PatFee
	s NotBillFee=$fn(NotBillFee,"",2)
	s PatFee=$fn(PatFee,"",2)
    s RetVal=$fn(AdmDeposit,"",2)_"^"_$fn(PatFee,"",2)_"^"_$fn(InsuFee,"",2)_"^"_$fn(PatRemain,"",2)_"^"_$fn(NotBillFee,"",2)_"^"_$fn(TotalAmount,"",2)
    q RetVal
}

/// Creator: 杨艳秀
/// CreateDate: 2015-12-12
/// Descritpion: 取就诊的财务结算日期，时间
ClassMethod GetFinalDateAndUser(Adm As %String) As %String
{
	s FinalFlag="N", PrtDate="", PrtTime="", PrtUser=""
	s PrtRowid=""
	f  s PrtRowid=$o(^DHCINVPRTZY(0,"ADM",Adm,PrtRowid),-1) q:((PrtRowid="")||(FinalFlag="Y"))  d
	.s PrtFlag=$p(^DHCINVPRTZY(PrtRowid),"^",8)
	.i (PrtFlag="N") d
	..s FinalFlag="Y"
	..s PrtDate=$p(^DHCINVPRTZY(PrtRowid),"^",2)
	..s PrtDate=##class(websys.Conversions).DateLogicalToHtml(PrtDate)
	..s PrtTime=$p(^DHCINVPRTZY(PrtRowid),"^",3)
	..s PrtTime=##class(websys.Conversions).TimeLogicalToHtml(PrtTime)
	..s PrtUser=$p(^DHCINVPRTZY(PrtRowid),"^",7)
	..s PrtUser=$p(^SSU("SSUSR",PrtUser),"^",2)
	
	q PrtDate_" "_PrtTime_"^"_PrtUser
}

/// Description: 取入院日期入院时间出院日期出院时间
/// Debug: w ##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(4965)
ClassMethod GetAdmInOutDatebyEpisodeID(EpisodeID)
{
	set AdmDay=""
	set AdmDateInfo=##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID)
	set AdmDate=$p(AdmDateInfo,"^",1)
	set AdmTime=$p(AdmDateInfo,"^",2)
	
	set DisDateInfo=##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID)
	set DisDate=$p(DisDateInfo,"^",1)
	set DisTime=$p(DisDateInfo,"^",2)
	if (DisDate'=""){
		if (AdmDate'=""){
			set AdmDay=DisDate-AdmDate
		}
		if (AdmDay=0){
			set AdmDay=1
		}
	}else {
		if (AdmDate="") {
			set AdmDay=0
		}else {
			set AdmDay=+$h-AdmDate
		}
	}
 
	quit AdmDate_"^"_AdmTime_"^"_AdmDay_"^"_DisDate_"^"_DisTime
}

/// Debug: w ##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(930)
ClassMethod GetOutAdmInOutDateInfo(EpisodeID As %String, LangId As %String = "") As %String
{
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set AdmInOutDateInfo=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(EpisodeID)
	set AdmDate=$p(AdmInOutDateInfo,"^",1)
	set AdmTime=$p(AdmInOutDateInfo,"^",2)
	set AdmDays=$p(AdmInOutDateInfo,"^",3)
	set DischDate=$p(AdmInOutDateInfo,"^",4)
	set DischTime=$p(AdmInOutDateInfo,"^",5)
	set HtmlAdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
	set HtmlAdmTime=##class(websys.Conversions).TimeLogicalToHtml(AdmTime, 1)
	set HtmlDischDate=##class(websys.Conversions).DateLogicalToHtml(DischDate)
	set HtmlDischTime=##class(websys.Conversions).TimeLogicalToHtml(DischTime, 1)
	set HtmlAdmDatTime=HtmlAdmDate_" "_HtmlAdmTime
	set HtmlDischDatTime=HtmlDischDate_" "_HtmlDischTime
	set VisitStatus=$p(^PAADM(EpisodeID),"^",20)
	set AdmStatusCode=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
	if (AdmStatusCode="") set AdmStatusCode=VisitStatus   //为空时取PA_Adm.PAADM_VisitStatus
	set AdmStatus=$case(AdmStatusCode,
						"E": "医生办理出院",
						"C": "医生撤销出院",
						"F": "护士办理出院",
						"R": "护士撤销出院",
						"B": "费用调整",
						"T": "结束费用调整",
						"A": "在院",
						"C": "退院",
						"D": "最终结算",
						"P": "预住院",
						   : "")
	set AdmStatus=##class(websys.Translation).Get("", AdmStatus, LangId)
	
	quit HtmlAdmDatTime_"^"_HtmlDischDatTime_"^"_AdmDays_"^"_AdmStatus_"^"_AdmDate_"^"_AdmTime_"^"_DischDate_"^"_DischTime_"^"_AdmStatusCode
}

/// Debug: w ##class(web.UDHCJFBaseCommon).GetCTZipDesc()
ClassMethod GetCTZipDesc(CityID As %String, CityAreaID As %String) As %String
{
	i ((CityID="")&&(CityAreaID="")) q ""
	s CTZipDesc=""
	i (CityID'="") d
	.s CTZipID=$o(^CT("ZIP",0,"City",CityID,""))
	.s:(CTZipID'="") CTZipDesc=$p($p(^CT("ZIP",CTZipID),"^",1),"-",1)
	i (CityAreaID'="") d
	.s CTZipID=$o(^CT("ZIP",0,"CityArea",CityAreaID,""))
	.s:(CTZipID'="") CTZipDesc=$p($p(^CT("ZIP",CTZipID),"^",1),"-",1)
	q CTZipDesc
}

/// Creator: Lid
/// CreatDate: 2017-03-24
/// Description: 根据账户rowid获取患者有效的卡号
/// Input: accMRowId: 账户rowid, cardTypeDr: 卡类型(预留)
/// Return: 卡号
/// Debug: w ##class(web.UDHCJFBaseCommon).GetCardNoByAccMRowId(111)
ClassMethod GetCardNoByAccMRowId(accMRowId As %String, cardTypeDr As %String = "")
{
	set flag=0, cardNo=""
	set cfRowId=""
	for  set cfRowId=$o(^DHCCARDi("CF",0,"AccNoDR",accMRowId,cfRowId),-1) quit:(cfRowId="")||(flag=1)  do
	.set ss=$g(^DHCCARD("CF",cfRowId))
	.set cardNo=$p(ss,"^",2)
	.set activeFlag=$p(ss,"^",10)
	.quit:(activeFlag'="N")
	.set flag=1
	
	quit cardNo
}

/// 获取系统配置日期格式
/// wangjian
/// 日期不为空返回系统配置格式日期
/// 时间不为空返回系统配置格式时间
/// 日期时间不为空返回系统配置格式日期 配置格式时间
/// 日期时间都为空返回当前日期 时间的系统配置格式
/// Debug: w ##class(web.UDHCJFBaseCommon).FormDateTime("","")
ClassMethod FormDateTime(Date As %String = "", Time As %String = "") As %String
{
	s Rtn=""
	i (Date["/") s Date=$zdh(Date,4)
	i (Date["-") s Date=$zdh(Date,3)
	i ((Time[":")&&($l(Time)=8)) s Time=$zth(Time,1)
	
	i (Date'="")&&(Time="") d
	.s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
	.s Rtn=Date
	
	i (Date="")&&(Time'="") d
	.s Time=##class(websys.Conversions).TimeLogicalToHtml(Time, 1)
	.s Rtn=Time
	
	i ((Date="")&&(Time="")) d
	.s Date=+$h
	.s Time=$p($h,",",2)

	i ((Date'="")&&(Time'="")) d
	.s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
	.s Time=##class(websys.Conversions).TimeLogicalToHtml(Time, 1)
	.s Rtn=Date_" "_Time
	
	q Rtn
}

/// Creator: ZhYW
/// CreatDate: 2017-06-02
/// Description: 根据结算记录的收费类别与发票类型配置取发票模板
/// Input: prtRowID: DHC_INVPRT.RowID / DHC_INVPRTZY.RowID
///        patType: "O":门诊, "I":住院
///        defaultXMLName: 默认XML发票模板
/// Return: prtXMLName: XML发票打印模板名称
/// Debug: w ##class(web.UDHCJFBaseCommon).GetPrtXMLName(486, "I", "DHCJFIPReceipt")
ClassMethod GetPrtXMLName(prtRowID As %String, patType As %String, defaultXMLName As %String) As %String
{
	set prtXMLName=defaultXMLName
	quit:(+prtRowID=0) prtXMLName
	quit:((patType="O")&&($d(^DHCINVPRT(prtRowID))=10)) prtXMLName
	quit:((patType="I")&&('$d(^DHCINVPRTZY(prtRowID)))) prtXMLName
	
	if (patType="O") {
		set insTypeDR=$p(^DHCINVPRT(prtRowID),"^",9)
		set fairType=$p(^DHCINVPRT(prtRowID),"^",34)
		if (fairType="F") set fairType="O"
		set hospId=$p(^DHCINVPRT(prtRowID),"^",39)
	}else {
		set insTypeDR=$p(^DHCINVPRTZY(prtRowID),"^",9)
		set fairType="I"
		set hospId=$p(^DHCINVPRTZY(prtRowID),"^",35)
	}
	quit:(+insTypeDR=0) prtXMLName
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_AdmReaInvType", hospId)
	set sareRowID=0
	while($o(^DHCSOPADMRExpi(0,"ADMR",insTypeDR,sareRowID))) {
		set sareRowID=$o(^DHCSOPADMRExpi(0,"ADMR",insTypeDR,sareRowID))
		set myObj=##class(User.DHCSOPADMReasonExp).%OpenId(sareRowID, 0)
		continue:('$IsObject(myObj))
		set sareHospDR=myObj.SAREHospDR.%Id()
		continue:(sareHospDR'=defHospId)
		set useFairType=myObj.SARENote1
		if (useFairType'=fairType) {
			do myObj.%Close()
			continue
		}
		set prtXMLName=myObj.SARENote2
		do myObj.%Close()
	}

	quit prtXMLName
}

/// Creator: ZhYW
/// CreatDate: 2017-06-28
/// Description: 取医院名称
/// Input: hospitalID, deptID
/// Return: hospitalName: CT_Hospital.HOSP_Desc
/// Other: hospitalID优先级高于deptID
/// Debug: w ##class(web.UDHCJFBaseCommon).GetHospitalName(2)
ClassMethod GetHospitalName(hospitalID As %String, deptID As %String = "") As %String
{
	set hospitalName=""
	if ((+hospitalID=0)&&(+deptID'=0)){
		set hospitalID = ##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(deptID)
	}
	quit:(+hospitalID=0) hospitalName
	
	set hospitalObj=##class(User.CTHospital).%OpenId(hospitalID, 0)
	quit:('$IsObject(hospitalObj)) hospitalName
	set hospitalName=hospitalObj.HOSPDesc
	do hospitalObj.%Close()
	quit hospitalName
}

Query opadmdeplookup(desc As %String, UserDepID As %String) As websys.Query(ROWSPEC = "dep:%String,depid:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFBaseCommon","opadmdeplookup","", "")
ClassMethod opadmdeplookupExecute(ByRef qHandle As %Binary, desc As %String, UserDepID As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
    set desc=$$ALPHAUP^SSUTIL4(desc)
	set UserDepID=$g(UserDepID)
    set UserDepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(UserDepID)
    set AdmTypelist="O^E"
	set Len=$l(AdmTypelist,"^")
	for i=1:1:Len  do
	.set AdmType=$p(AdmTypelist,"^",i)
	.quit:(AdmType="")
	.set rowid=0
	.for  set rowid=$o(^PAC("ADMLOC",0,"AdmType",AdmType,rowid))  quit:(rowid="")  do
	..quit:('$d(^CTLOC(rowid)))
	..set DepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(rowid)
	..quit:((UserDepHosDr'=DepHosDr)&&(UserDepHosDr'="")&&(DepHosDr'=""))
	..set ctdesc=$p(^CTLOC(rowid),"^",2)
	..set ctContactName=$p(^CTLOC(rowid),"^",43)   //科室检索码
	..set ctContactName=$$ALPHAUP^SSUTIL4(ctContactName)
	..set ctdesc=$$ALPHAUP^SSUTIL4(ctdesc)
	..quit:((desc'="")&&(ctContactName'[desc)&&(ctdesc'[desc))
	..do OutputDept
	
	quit $$$OK
OutputDept
	set Data=$lb(ctdesc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// zhli
/// 2017-09-15
/// 通过用户和类型(O,I)来判断该用户是否为收费员
/// 是:0,否:1
/// w ##class(web.UDHCJFBaseCommon).CheckISCashierBytype(1,"O",3)
ClassMethod CheckISCashierBytype(Guser, grp, type)
{
	set rtn=1
    set rowid=$o(^DHCJFRcptGroupSet(0,"Type",grp,type,"0"))
    quit:(+rowid=0) rtn
    set sub=0
    for  set sub=$o(^DHCJFRcptGroupSet(rowid,"Sub",sub)) quit:(sub="")||(rtn=0)  do
    .set userDR=$p(^DHCJFRcptGroupSet(rowid,"Sub",sub),"^",4)
	.if (Guser=userDR) set rtn=0
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2017-09-13
/// Description: 获取医嘱类型
/// Input: oeitm:医嘱rowid或执行记录rowid或医嘱项rowid
/// 	   flag:0:医嘱项Rowid，1：医嘱rowid(默认)，2：执行记录rowid
/// Return: 医嘱类型(R:药品N:诊疗 L:检验P:自定价医嘱，X：检查（与医生站的S区别），M:材料)
/// Debug: w ##class(web.UDHCJFBaseCommon).GetOrdCateType("57||12")
ClassMethod GetOrdCateType(oeitm As %String, flag As %String = 1) As %String
{
	if (" 1 2 "[(" "_flag_" ")) {
		set arcimRowID=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
	}else {
		set arcimRowID=oeitm
	}
	set arcGrp=$p($g(^ARCIM(+arcimRowID,$p(arcimRowID,"||",2),1)),"^",10)    ;子类      
	set ordCateType=$p($g(^ARC("IC",arcGrp)),"^",7)                          ;医嘱类型
	quit ordCateType
}

/// Creator: Lid
/// CreateDate: 2018-12-27
/// Description: 获取留观状态
/// Return: 1:留观出院, 2:正在留观, -1:非留观
/// Debug: w ##class(web.UDHCJFBaseCommon).GetObsPatYetDisHosp(655)
ClassMethod GetObsPatYetDisHosp(episodeID As %String) As %String
{
   	set rtn=##class(web.DHCEMInterfaceCom).GetObsPatYetDisHosp(episodeID)
   	quit rtn
}

/// Creator: Lid
/// CreatDate: 2018-10-11
/// Description: 根据门诊发票rowid获取发票费别信息
/// Input: prtRowId:发票表rowid
/// Return: 发票费别指针^admsource
/// Debug: w ##class(web.UDHCJFBaseCommon).GetInsTypeInfoByPrtRowId("43696379")
ClassMethod GetInsTypeInfoByPrtRowId(prtRowId As %String)
{
	quit:(prtRowId="") "^"
	set prtInsTypeDR=$p($g(^DHCINVPRT(prtRowId)),"^",9)
	set admSource=$s((prtInsTypeDR'=""):$p(^PAC("ADMREA",prtInsTypeDR),"^",9),1:"")
	set rtn=prtInsTypeDR_"^"_admSource
	quit rtn
}

/// Debug: w ##class(web.UDHCJFBaseCommon).GetPrtInsDivDR("","PRT")
ClassMethod GetPrtInsDivDR(PrtRowID As %String, PrtFlag As %String)
{
	set:(PrtFlag="") PrtFlag="PRT"
	set InvDivDR=""
	if (PrtFlag="PRT") {
		set InvDivDR=$p($g(^DHCINVPRT(PrtRowID)),"^",30)    //PRT_InsDiv_DR	
	}else {
		//API
		set InvDivDR=$p($g(^DHCINVPRTAP(PrtRowID)),"^",19)	//API_InsDiv_DR
	}
	quit InvDivDR
}

}
