/// 名称: web.DHCIPBillQFPatPrint
/// 描述: 住院欠费病人费用明细打印类
/// 编写者: zhli
/// 编写日期: 2018-07-16
Class web.DHCIPBillQFPatPrint Extends %RegisteredObject
{

/// Creator: Zhli
/// CreatDate: 2018-07-16
/// Description: 获取住院欠费病人在院费用明细
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        papNo:登记号
/// Output: Tind:序号,TPatbedNo:床号,Tzyno:住院号,Tpatregno:登记号,Tpatname:姓名,Tsex:性别,TinPatType:入院性质,Tpatloc:就诊科室,Tadmdate:入院日期,TdischDate:出院日期,Tpatfee:总费用,Tdeposit:预交款,TwarrantAmt:担保金额,Tremain:余额,TadmStatus:收费类型
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillQFPatPrint","GetIPQFPatDetailReport", "2018-08-02","2018-08-07","")
Query GetIPQFPatDetailReport(stDate As %String, endDate As %String, papNo As %String = "", HOSPID) As websys.Query(ROWSPEC = "Tind:%String:序号,TPatbedNo:%String:床号,Tzyno:%String:住院号,Tpatregno:%String:登记号,Tpatname:%String:姓名,Tsex:%String:性别,TinPatType:%String:入院性质,Tpatloc:%String:就诊科室,Tadmdate:%String:入院日期,TdischDate:%String:出院日期,Tpatfee:%Float:总费用,Tdeposit:%Float:预交款,TwarrantAmt:%Float:担保金额,Tremain:%Float:余额,TadmStatus:%String:收费类型") [ SqlProc ]
{
}

ClassMethod GetIPQFPatDetailReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, papNo As %String = "", HOSPID) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	if ((stDate="")||(endDate=""))  quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)

	for prtDate=stDate:1:endDate  do
    .set prtTime=""
    .for  set prtTime=$o(^PAADMi("TypeDate","I",prtDate,prtTime)) quit:(prtTime="")  do
   	..set adm=0
   	..for  set adm=$o(^PAADMi("TypeDate","I",prtDate,prtTime,adm)) quit:(adm="")  do
	...set HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	...quit:(HospDr'=HOSPID)
	...set papmi=$p(^PAADM(adm),"^",1)
	...set patname=$p(^PAPER(papmi,"ALL"),"^",1)
	...set patregno=$p(^PAPER(papmi,"PAT",1),"^",1)
	...set papNo=##class(web.UDHCJFBaseCommon).regnocon(papNo)
	...quit:((patregno'=papNo)&&(papNo'=""))
	...set zyno=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
	...set sexid=$p($g(^PAPER(papmi,"ALL")),"^",7)
	...set sex=$s((+sexid'=0):$p($g(^CT("SEX",sexid)),"^",2),1:"")
	...set dep=$p(^PAADM(adm),"^",4)
	...set patloc=$p(^CTLOC(dep),"^",2)
	...set visitstatus=$p(^PAADM(adm),"^",20)
	...quit:(visitstatus'="A")
	...set bedNo=##class(web.DHCBillCommon).GetPatBedCode(adm)
    ...set patfee=..totalAmount(adm)
    ...quit:(+patfee=0)
	...set deposit=##class(web.UDHCJFBaseCommon).deposit(adm) 
	...set warrantAmt=##class(web.UDHCJFZYDB).GetWarrAmt(adm)
	...set remain=deposit+warrantAmt-patfee
	...quit:(+remain>0)
	...set admStatus="在院"
	...set inPatType=""    ;入院性质
	...set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(adm)
	...set admdate=$p(admInOutDateInfo,"^",1)
	...set dischDate=$p(admInOutDateInfo,"^",2)
    ...set data=$lb(ind,bedNo,zyno,patregno,patname,sex,inPatType,patloc,admdate,dischDate,patfee,deposit,warrantAmt,remain,admStatus)
	...set ^CacheTemp(repid,ind)=data
	...set ind=ind+1
	
	quit $$$OK
}

/// Creator: Zhli
/// CreatDate: 2018-07-17
/// Description: 获取出院欠费病人在院费用明细
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        papNo:登记号
/// Output: Tind:序号,,TPatbedNo:床号,Tzyno:住院号,Tpatregno:登记号,Tpatname:姓名,Tsex:性别,TinPatType:入院性质,Tpatloc:就诊科室,Tadmdate:入院日期,TdischDate:出院日期,Tpatfee:总费用,Tdeposit:预交款,TadmStatus:收费类型,Tinvflag:发票状态,paymodeStr:交款方式
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillQFPatPrint","GetOutPatQFPatDetailReport", "2021-07-07", "2021-07-16","","")
Query GetOutPatQFPatDetailReport(stDate As %String, endDate As %String, papNo As %String = "", HOSPID) As websys.Query(ROWSPEC = "Tind:%String:序号,TPatbedNo:%String:床号,Tzyno:%String:住院号,Tpatregno:%String:登记号,Tpatname:%String:姓名,Tsex:%String:性别,TinPatType:%String:入院性质,Tpatloc:%String:就诊科室,Tadmdate:%String:入院日期,TdischDate:%String:出院日期,Tpatfee:%Float:总费用,Tdeposit:%Float:预交款,TadmStatus:%String:收费类型,Tinvflag:%String:发票状态,paymodeStr:%String:交款方式") [ SqlProc ]
{
}

ClassMethod GetOutPatQFPatDetailReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, papNo As %String = "", HOSPID) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	if ((stDate="")||(endDate=""))  quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set ^TMP("GetOutPatQFPatDetailReport")=$lb(stDate, endDate, papNo)
	
	set initInv=""
	for disdate=stDate:1:endDate  do
    .set prtrowid="" 
	.for  set prtrowid=$o(^DHCINVPRTZY(0,"DATE",disdate,prtrowid),-1)  quit:(prtrowid="")  do
	..set prtData=$g(^DHCINVPRTZY(prtrowid))
	..set HospDr=$p(prtData,"^",35)
	..quit:(HospDr'=HOSPID)
	..quit:((initInv'="")&&(prtrowid=initInv))
	..set adm=$p(prtData,"^",4)
	..set initInv=$p(prtData,"^",13)
	..set invflag=$p(prtData,"^",8)
	..quit:(invflag="A")
	..if (invflag="S")  do
	...set invflag="冲红"
	..if ((invflag="N")||(invflag="I"))  do
	...set invflag="正常"
	..set papmi=$p(^PAADM(adm),"^",1)
	..set patname=$p(^PAPER(papmi,"ALL"),"^",1)
	..set patregno=$p(^PAPER(papmi,"PAT",1),"^",1)
	..set papNo=##class(web.UDHCJFBaseCommon).regnocon(papNo)
	..quit:((patregno'=papNo)&&(papNo'=""))
	..set zyno=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
	..set sexid=$p($g(^PAPER(papmi,"ALL")),"^",7)
	..set sex=$s((+sexid'=0):$p($g(^CT("SEX",sexid)),"^",2),1:"")
	..set dep=$p(^PAADM(adm),"^",4)
	..set patloc=$p(^CTLOC(dep),"^",2)
	..set visitstatus=$p(^PAADM(adm),"^",20)
	..quit:(visitstatus="C")
	..set paymodeStr=""
	..set flag=0
	..set paymSub=0
	..for  set paymSub=$o(^DHCINVPRTZY(prtrowid,"P",paymSub)) quit:(paymSub="")  do
	...set paymSubData=$g(^DHCINVPRTZY(prtrowid,"P",paymSub))
	...set PaymodeDr=$p(paymSubData,"^",1)
	...set PaymodeAmt=$p(paymSubData,"^",3)
	...set PaymodeAmt=$fn(PaymodeAmt,"",2)
	...set PayModeCode=$p(^CT("CTPM",PaymodeDr),"^",1)
	...if (PayModeCode="QF") do
	....set flag=1
	...set PayModeDesc=$p(^CT("CTPM",PaymodeDr),"^",2)
	...if (paymodeStr="") set paymodeStr=PayModeDesc_"："_PaymodeAmt
	...else   set paymodeStr=paymodeStr_"， "_PayModeDesc_"："_PaymodeAmt
	..quit:(flag=0)
	..set bedNo=##class(web.DHCBillCommon).GetPatBedCode(adm)
    ..set patfee=$p(prtData,"^",6)
    ..quit:(+patfee=0)
    ..set arpbl=$p(prtData,"^",5)
	..set deposit=$p(prtData,"^",22)
	..set deposit=$fn(deposit,"",2)
	..;set warrantAmt=##class(web.UDHCJFZYDB).GetWarrAmt(adm)
	..set admStatus="出院"
	..if (visitstatus="A") set admStatus="在院"
	..set inPatType=""    ;入院性质
	..set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(adm)
	..set admdate=$p(admInOutDateInfo,"^",1)
	..set dischDate=$p(admInOutDateInfo,"^",2)
    ..set data=$lb(ind,bedNo,zyno,patregno,patname,sex,inPatType,patloc,admdate,dischDate,patfee,deposit,admStatus,invflag,paymodeStr)
	..set ^CacheTemp(repid,ind)=data
	..set ind=ind+1

	quit $$$OK
}

ClassMethod totalAmount(adm As %String) As %String
{
	set cost=0
	set pb=0
	for  set pb=$o(^DHCPB(0,"ADM",adm,pb))  quit:(pb="")  do
	.set pbData=$g(^DHCPB(pb))
	.set payedFlag=$p(pbData,"^",16)
	.set paidCAcountFlag=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(pb)
	.quit:((payedFlag="P")&&(paidCAcountFlag'="Y"))
	.;(quit:payedFlag="P")
	.;set cost=cost+$p(pbData,"^",8)
	.set cost=cost+$p(pbData,"^",12)
	
	quit cost
}

}
