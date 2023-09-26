Import SQLUser

Class web.UDHCJFREBILL Extends BILL.COM.Abstract
{

/// Debug: w ##class(web.UDHCJFREBILL).REBILL("4467","8540","17275")
ClassMethod REBILL(adm As %String, bill As %String, user As %String) As %String
{
	set ^TMP("REBILL")=$lb(adm, bill, user)
	quit:(+bill=0) -1_"^"_"参数错误"
	
	set isCloseAcount=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(bill)
	quit:(isCloseAcount="Y") -1_"^"_"账单已封账，不能重新生成账单"
	
	set payedFlag=$p(^DHCPB(bill),"^",16)
	quit:(payedFlag="P") -1_"^"_"账单已结算，不能重新生成账单"
	
	do ##class(web.UDHCJFBaseCommon).DelPBONullData(bill)
	
	do ##class(web.UDHCJFBILLIP).BILL(adm, user, "", 0)	  //2017-04-13 Lid 重新账单前，先账单一下
	
	set rtn=..GetExtralItmFlag(bill)
	quit:(+rtn) -1_"^"_"账单中执行记录有附加的收费项目，不能重新生成账单"
    
	set BabyFlag=##class(web.UDHCJFORDCHK).getmotheradm(adm)
	quit:(BabyFlag="true") -1_"^"_"请选择母亲账单进行重新生成账单"
	
	set rtn=..BILL(bill, adm, user)
	quit:(+rtn) rtn
	
	//处理母亲账单与婴儿账单合并后分开时，重新生成母亲账单时，婴儿账单不能计费的问题 2015-03-11 tangt
	set rtn=..REBILLBABY(adm, user)
	
	quit rtn
}

/// w ##class(web.UDHCJFREBILL).BILL(216570, 1, 639)
ClassMethod BILL(bill, adm, user)
{
	set $zt="ERROR"
	set rtn=0
	quit:(adm="") rtn
	
	//Lid 2014-06-19 根据DHC_PatBillDetails表的条数判断是否锁表
	set NoLockFlag=##class(web.UDHCJFBaseCommon).IsNoLockTable(adm, bill, "")
	
	ts
    
   	set rtnValue=..PBDEL(adm, NoLockFlag)    //删除账单
    set rtn=$p(rtnValue,"^",1)
    set DelBillStr=$p(rtnValue,"^",2)
    if (+rtn) tro  quit rtn

    if (NoLockFlag'="NoLock") {
	    set rtnValue=##class(web.UDHCJFREBILL2).BILL(adm, user)    //yyx 2009-03-31 把医嘱重新生成账单
	}else {
		set rtnValue=##class(web.UDHCJFREBILL2NoLock).BILL(adm, user)
	}
   	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue

	if (bill'="") set ^DHCBILLDEL(+$h,bill)=adm_"^"_bill_"^"_$zdt($zdth($zts,-3),3,1,3)_"^"_"web.UDHCJFREBILL.BILL()--1"
 	for i=1:1:$l(DelBillStr,$c(2)) {
	 	set DelBill=$p(DelBillStr,$c(2),i)
	 	continue:(+DelBill=0)
	 	set ^DHCBILLDEL(+$h,DelBill)=adm_"^"_DelBill_"^"_$zdt($zdth($zts,-3),3,1,3)_"^"_"web.UDHCJFREBILL.BILL()--2"
	}
    
	do ..SetOEBillFlag(adm)
	
    if ($tl>0) tc
    
    quit rtn

ERROR
	quit ..AppException()
}

ClassMethod PBDEL(adm, NoLock = "")
{
    set rtn=0
    set DelBillStr=""
    set pb=0
	for  set pb=$o(^DHCPB(0,"ADM",adm,pb)) quit:((pb="")||(+rtn))  do
	.set payedFlag=$p(^DHCPB(pb),"^",16)
	.quit:(payedFlag="P")
	.if (NoLock'="NoLock") do
	..set rtnValue=##class(UDHCJFPB).PBDEL(pb)
	.else  do
	..set rtnValue=##class(web.UDHCJFPBNoLock).PBDEL(pb)
	.set rtn=+rtnValue
	.quit:(+rtn)
	.set DelBillStr=$s((DelBillStr=""):pb,1:(DelBillStr_$c(2)_pb))
	quit:(+rtn) rtn_"^"_DelBillStr
	
	set rtnValue=..DelBabyPB(adm, NoLock)    //2016-03-05 tangt
	set rtn=+rtnValue
	if (rtn=0) do
	.set babyBillStr=$p(rtnValue,"^",2)
	.quit:(babyBillStr="")
	.set DelBillStr=$s((DelBillStr=""):babyBillStr,1:(DelBillStr_$c(2)_babyBillStr))
	
	quit rtn_"^"_DelBillStr
}

/// Creator: tangt
/// CreatDate: 2015-03-11
/// Description: 通过母亲就诊找到婴儿就诊及账单进行重新生成账单
/// Input: adm：母亲就诊，user：账单用户
ClassMethod REBILLBABY(adm, user)
{
	set rtn=0
	
	set HospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	set Conf=##class(web.DHCBillCommon).GetTarParaId(HospDR)
	set NewBornToMother=$s((+Conf'=0):$p(^DHCTarC("CF",Conf),"^",5),1:"Y")
	quit:(NewBornToMother="Y") rtn	  //合并账单的不对婴儿进行账单
	
	set BabyAdmStr=##class(web.DHCIPBillCashier).GetBabyAdm(adm)
	for i=1:1:$l(BabyAdmStr,"^") {
		set BabyAdm=$p(BabyAdmStr,"^",i)
		continue:(+BabyAdm=0)
		//set AdmStatus=$p(^PAADM(BabyAdm),"^",20)
		//continue:(AdmStatus'="A")
		//此处账单传空，不循环就诊取账单是因为如果是母婴合并的，婴儿无账单就不会进入重新生成账单程序，见下面注释
		set rtn=..BILL("", BabyAdm, user)
		quit:(+rtn)
	}
	quit rtn
}

/// Creator: yyx
/// CreateDate: 2012-09-21
/// Description: 账单里有附加收费项目的时候不能重新账单
/// Debug: w ##class(web.UDHCJFREBILL).GetExtralItmFlag(216570, 1, 639)
ClassMethod GetExtralItmFlag(BillNo)
{
	set rtn=0
	set pbo=0
	for  set pbo=$o(^DHCPB(BillNo,"O",pbo)) quit:((pbo="")||(+rtn))  do
	.set pbd=0
	.for  set pbd=$o(^DHCPB(BillNo,"O",pbo,"D",pbd)) quit:((pbd="")||(+rtn))  do
	..set pbdData=$g(^DHCPB(BillNo,"O",pbo,"D",pbd))
	..set extralFlag=$p(pbdData,"^",22)    //PBD_ExtralFlag
	..quit:(extralFlag'="Y")
	..set rtn=$i(rtn)
	
	quit rtn
}

/// Creator: tangt
/// CreateDate: 2015-06-16
/// Description: 处理医嘱执行后计费取消登记不退费，直接重新生产账单后再登记不能收费的问题
ClassMethod SetOEBillFlag(adm)
{
	quit:(adm="") 0
	
    set ord=$o(^OEORD(0,"Adm",adm,""))
    quit:(ord="") 0
    
	set itm=0
	for  set itm=$o(^OEORD(ord,"I",itm)) quit:(itm="")  do
	.quit:('$d(^OEORD(ord,"I",itm,1)))
	.set oeitm=ord_"||"_itm
	.set statDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
	.set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
	.set CP=##class(BILL.IP.COM.Method).GetBillPoint(oeitm)
	.if ((CP="OE")&&(statCode="V")) do
	..set exec=0
	..for  set exec=$o(^OEORD(ord,"I",itm,"X",exec)) quit:(exec="")  do
	...set OEOREBillFlag=$p(^OEORD(ord,"I",itm,"X",exec),"^",6)  //OEORE_Billed
	...quit:(OEOREBillFlag'="B")
	...set $p(^OEORD(ord,"I",itm,"X",exec),"^",6)="TB"	          //字段没有索引可以直接set

	quit 0
}

/// 2016-03-05 tangt 处理母婴账单分开，系统配置改为合并时对母亲进行重新生成账单时，婴儿账单未删除的问题
ClassMethod DelBabyPB(MotherAdm, NoLock = "")
{
	set rtn=0
	set BabyAdmStr=##class(web.DHCIPBillCashier).GetBabyAdm(MotherAdm)
	quit:(BabyAdmStr="") rtn
	set delStr=""
	for i=1:1:$l(BabyAdmStr,"^") quit:(+rtn)  do
	.set BabyAdm=$p(BabyAdmStr,"^",i)
	.quit:(BabyAdm="")
	.set pb=0
	.for  set pb=$o(^DHCPB(0,"ADM",BabyAdm,pb))  quit:((pb="")||(+rtn))  do
	..set payedFlag=$p(^DHCPB(pb),"^",16)
	..quit:(payedFlag="P")
	..if (NoLock'="NoLock") do
	...set rtn=##class(web.UDHCJFPB).PBDEL(pb)
	..else  do
	...set rtn=##class(web.UDHCJFPBNoLock).PBDEL(pb)
	..quit:(+rtn)
	..set delStr=$s((delStr=""):pb,1:(delStr_$c(2)_pb))
	
	quit rtn_"^"_delStr
}

}
