Class web.DHCIPMealWorkLoad Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 每天晚上调用该方法,把今天所有发生的帐单写到his的医嘱中
/// d ##class(web.DHCIPMealWorkLoad).toHisBill()
ClassMethod toHisBill()
{
	//控制时间
	s err=0
	s inputUpdateDate=$zd(+$h-1,3)  	//昨天更新order了的adm下的
	s inputStartDate=$zd(+$h,3)			//开始日期小于今天的order--为了ordItem_stdate==bill_date==oe_stDate
	s bill = ##class(DHCBILL.DHCIPMealFeeBill).HospitalCalPatLanchFee("1",inputUpdateDate,inputStartDate)
	s inputUpdateDate=$zdh(inputUpdateDate,3)
	B ;0
	i $l(bill,"^")>1 s err=$p(bill,"^")
	e  i +bill>0 s err=0
	i err=0 d
	.s moRowid=0 
	.f  s moRowid=$o(^DHCIPMEALORDER(0,"UpdateDate",inputUpdateDate,moRowid)) q:(moRowid="")||(err'=0)  d
	..s adm=$p(^DHCIPMEALORDER(moRowid),"^",1)
	..s err=..billToHisOrdItemByAdm(adm,"")
	B ;1
	d ##class(DHCBILL.DHCIPMealPrintComm).writePrecent(+$h+1-1)   //把昨天的就餐率写到global中
	q err
}

/// 出院结算时调用该方法, 
/// 1,帐单adm的膳食，
/// 2,把伙食医嘱写到his中
/// 3,回写膳食帐单明细中的关联和标志
ClassMethod toHisBillByAdm(adm As %String)
{
	;w ##class(web.DHCIPMealWorkLoad).toHisBillByAdm(32617)
	//控制时间
	s err=0
	s date=$zd(+$h,3)

	s bill=##class(DHCBILL.DHCIPMealFeeBill).CalPatLanchFee(adm,"1",date)  
	i +bill>0 d
	.s err=..billToHisOrdItemByAdm(adm,"")
	q err
}

/// date:   2010-12-10
/// author: wanghc
/// param:  adm , MBRowid=DHC_IPMealBill的rowid=$o(^DHCIPMEALBILL(0,"Adm",adm,"0"))
/// desc:   把meal中的账单一条明细金额作为一条医嘱写到his的orditem表中,一对一的
/// other:  Adm对应的帐单下的明细ImportFlag=N的就导入;如果MBRowid="" MBRowid=$o(^DHCIPMEALBILL(0,"Adm",adm,"0"))
ClassMethod billToHisOrdItemByAdm(adm As %String, MBRowid As %String) As %String
{
	TS
	s err=0
	s:MBRowid="" MBRowid=$o(^DHCIPMEALBILL(0,"Adm",adm,"0"))
	;导入没有导入到his中的明细
	s billDetailRowid=0 f  s billDetailRowid=$o(^DHCIPMEALBILL(0,"ImportFlag","N",MBRowid,billDetailRowid)) q:(billDetailRowid="")||(err'=0)  d
	.s billDetailStr = $g(^DHCIPMEALBILL(MBRowid,"D",billDetailRowid))
	.s billTotalAmount=0
	.s billTotalAmount=+$p(billDetailStr,"^",4) 
	.s patLoc=$p(billDetailStr,"^",5)
	.;把金额绑到特定的医嘱项上写到医嘱表中
	.i +billTotalAmount>0 d
	..s num=1
	..s arcItmMastDr="15338||1"  //伙食费
	..s recDepDr="1198"           //接收科室
	..s ordItemStr=arcItmMastDr_"^"_num_"^"_recDepDr_"^"_billTotalAmount_"^^"_num_"^"
	..s User=1 
	..s Loc=patLoc
	..s ordItemRowid=##class(web.DHCOPCashier).CashierInsertOrdItem(adm,ordItemStr, User, Loc,"","")
	..s err=$p(ordItemRowid,"^",1)
	..q:err'=0
	..s hisOrdItemRowid=$p(ordItemRowid,"^",2)
	..;拿到OE_Orditemrowid再来写明细表
	..s err=##class(DHCBILL.DHCIPMealBillDetail).SELECT(MBRowid_"||"_billDetailRowid)
	..q:err'=0 
	..s PLIST(11)=hisOrdItemRowid
	..s PLIST(12)="Y"
	..s err=##class(DHCBILL.DHCIPMealBillDetail).UPDATE(MBRowid_"||"_billDetailRowid)
	..q:err'=0
	i err=0 TC
	e  TRO
	q err
}

ClassMethod getVisitStatusByAdm(admRowid As %String) As %String
{
	q "D"
	q:admRowid="" ""
	s admGlobalStr=^PAADM(admRowid)
	s visitStatus=$p(admGlobalStr,"^",20)
	q $p(visitStatus,$c(1))
}

}
