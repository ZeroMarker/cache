Import sqluser

/// Creator:yyx
/// CreateDate:2010-04-29
/// Function:  餐费记账,账单程序
/// Table:dhc_ipmealbill,dhc_ipmealbilldetail,dhc_ipmealorditem
Class DHCBILL.Diet.DHCIPMealFeeBill Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// input:billUser,inDate(yyyy-mm-dd)
/// other:滚今天23:20以前更新的明天及以前的帐(包括明天的)
/// ##class(DHCBILL.Diet.DHCIPMealFeeBill).HospitalCalPatLanchFee(1,"2010-12-21","2010-12-22")
ClassMethod HospitalCalPatLanchFee(BillUser, inputUpdateDate, inputStartDate)
{
	TS
	s bill=1
	s updateDate=$zdh(inputUpdateDate,3) 	//更新日期   
	s moRowid=0 
	f  s moRowid=$o(^DHCIPMEALORDER(0,"UpdateDate",updateDate,moRowid)) q:(moRowid="")||(+bill'>0)  d
	.s admRowid=$p(^DHCIPMEALORDER(moRowid),"^",1)
	.s bill = ..CalPatLanchFee(admRowid,BillUser,inputStartDate)
	
	i +bill>0 TC
	e  TRO
	q bill
}

/// input: date(yyyy-mm-dd) 小于date的orditem才帐单
/// Function:账单程序
/// w ##class(DHCBILL.Diet.DHCIPMealFeeBill).CalPatLanchFee(7,1,"2010-12-22")
ClassMethod CalPatLanchFee(Adm, BillUser, date)
{
    //计算病人未结算的伙食费
    s ^TMP("wanghc","CalPatLanchFee")=Adm_","_BillUser_","_date
    s date=$zdh(date,3)
    k ^TMP("MealBill",$j)
    s Count=0
    s Count=..Orders(Adm,BillUser,date)
    i Count>0 s bill=..InsPatLanchFee(Adm, BillUser,date)
    q $g(bill)
}

ClassMethod Orders(Adm, BillUser, date)
{
    s Ord=$o(^DHCIPMEALORDER(0,"Adm",Adm,""))
    q:Ord="" 0
	s OrdFrom=+$H,OrdEnd=0
	s Itm=0
	f  s Itm=$o(^DHCIPMEALORDER(Ord,"I",Itm)) q:Itm=""  Do
	.s OEItm=Ord_"||"_Itm
	.s BillFlag=$p(^DHCIPMEALORDER(Ord,"I",Itm),"^",17)
	.q:(BillFlag="P")!(BillFlag="B")
	.s MenuItm=$p(^DHCIPMEALORDER(Ord,"I",Itm),"^",1)
	.s StDate=$p(^DHCIPMEALORDER(Ord,"I",Itm),"^",2)
	.s admDr=$p(^DHCIPMEALORDER(Ord),"^",1)
	.s dischgDate = $p(^PAADM(admDr),"^",17)
	.q:StDate>date 		;  add by wanghc 2010-05-26 小于当前时间
	.s flag=0
	.s:dischgDate'="" flag=(StDate>dischgDate)
	.q:flag			;add by wanghc 2010-12-21且小于出院时间的帐单
	.s OrdQty=$p(^DHCIPMEALORDER(Ord,"I",Itm),"^",5)
	.s OrdPrice=..GetMenuItmPrice(MenuItm,StDate)
	.s OrdTot=$j(OrdPrice*OrdQty,3,2)
	.&sql(select * into:PLIST() from dhc_ipmealorditem where DHCMOI_rowid=:OEItm)
	.i $d(PLIST) m ^TMP("MealBill",$j,"ORDER",OEItm)=PLIST
	.s ^TMP("MealBill",$j,"ORDER",OEItm,"PRICE")=OrdPrice
	.s ^TMP("MealBill",$j,"ORDER",OEItm,"QTY")=OrdQty
	.s ^TMP("MealBill",$j,"ORDER",OEItm,"TOT")=OrdTot
	.s OrdDate=$p($g(^DHCIPMEALORDER(+Ord,"I",Itm)),"^",2)
	.s Count=Count+1
	q Count
}

ClassMethod InsPatLanchFee(Adm, BillUser, date)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()   
	s bill="",err=0
	s admbill=""
	f  s admbill=$o(^DHCIPMEALBILL(0,"Adm",Adm,admbill)) q:(admbill="")!(bill'="")  d
	.q:$p(^DHCIPMEALBILL(admbill),"^",8)="P"
	.s bill=admbill
	i bill="" s err=##class(DHCBILL.Diet.DHCIPMealBill).PBINS(Adm,BillUser) s:'err bill=$p(err,"^",2)
	i err trollback
	q:$p(err,"^",1)'=0 err
	q:bill="" ""
	s TotalAmount=0
	s Ord=""
	f  s Ord=$o(^TMP("MealBill",$j,"ORDER",Ord)) q:Ord=""  d
	.s BillFlag=$p($g(^TMP("MealBill",$j,"ORDER",Ord,16)),$c(1))
	.s order="",PBO=""
	.f  s order=$o(^DHCIPMEALBILL(0,"MO",Ord,bill,order)) q:(order="")!(PBO'="")  d
	..s PBO=order
	.i PBO'="" s PBO=bill_"||"_PBO
	.s OrdPrice=^TMP("MealBill",$j,"ORDER",Ord,"PRICE")
	.s OrdQty=^TMP("MealBill",$j,"ORDER",Ord,"QTY")
	.s Ordtot=^TMP("MealBill",$j,"ORDER",Ord,"TOT")
	.;没有计费的医嘱进行计费
	.i (BillFlag="TB")!(BillFlag="") d
	..s err=..PBOINS(bill,Ord,BillUser)
	.;已经计费但又停止的医嘱，做退费处理
	.i (BillFlag="I")&(PBO'="") d 
	..s err=..PBORefund(PBO,BillUser)
	..;s err0=..PBCHG(err,.Tot,.TotDisc,.TotIns,.TotPat)
	;更新DHC_ipmealbill
	s AdmDate=$p(^PAADM(Adm),"^",6)
	s TotalAmount=$p(err,"^",2)
	s err=..PayUpd(AdmDate,bill,BillUser,TotalAmount)
	d ..tc()
	k ^TMP("MealBill",$j)
	q $g(bill)
}

ClassMethod PBOINS(BILL, ORD, USER)
{
    ;插入表DHC_JFPATLANCHDETAIL
	;n (BILL,ORD,USER)
	s UnitPrice=^TMP("MealBill",$j,"ORDER",ORD,"PRICE")
	s Qty=^TMP("MealBill",$j,"ORDER",ORD,"QTY")
	k PLIST,PLIST(1)
	s PLIST(0)=BILL
	s PLIST(3)=ORD
	s PLIST(4)=UnitPrice
	s PLIST(5)=Qty
	s PLIST(6)=+..round(UnitPrice*Qty)
	s PLIST(7)=$p($g(^TMP("MealBill",$j,"ORDER",Ord,9)),$c(1))     ;科室
	S PLIST(8)=$p($g(^TMP("MealBill",$j,"ORDER",Ord,10)),$c(1))     ;病区
	s PLIST(9)=+$h
	s PLIST(10)=$p($h,",",2)
	s PLIST(12)="N"  //表示没有导入到his中 add wanghc 20101207
	s TotalAmount=TotalAmount+PLIST(6)
	s err=##Class(DHCBILL.Diet.DHCIPMealBillDetail).INSERT()   ;dhc_ipmealbilldetail
	s $p(^DHCIPMEALORDER(+Ord,"I",$p(Ord,"||",2)),"^",17)="B"
	s $p(^DHCIPMEALORDER(+Ord,"I",$p(Ord,"||",2)),"^",6)=$g(%ROWID)
	q "0"_"^"_TotalAmount
}

ClassMethod PBORefund(PBO, billuser)
{
    k PLIST
 	&sql(select * Into:PLIST() from dhc_ipmealbilldetail Where dhcmbd_rowid=:PBO)
	s PLIST(5)=0-PLIST(5)
	s PLIST(6)=0-PLIST(6)
	s TotalAmount=TotalAmount+PLIST(6)
	s billItemDr=PLIST(3)
	s PLIST(9)=+$h
	s PLIST(10)=$p($h,",",2)
	K PLIST(1),PLIST(2)
	s err=##Class(DHCBILL.Diet.DHCIPMealBillDetail).INSERT()
	;wanghc 2010-12-15 再帐单后I改成B
	s DHCMOIBilled="B"
	&sql(UPDATE dhc_IPMealOrdItem SET DHCMOI_Billed=:DHCMOIBilled Where DHCMOI_Rowid=:billItemDr)
	q err_"^"_TotalAmount
}

ClassMethod PayUpd(AdmDate, BILL, USER, TotalAmount)
{
   ;更新DHC_JFPATLANCHFEE的总金额
	n (AdmDate,BILL,USER,TotalAmount)
	;
	s TotalAmount=+$g(TotalAmount)
	s err=##class(DHCBILL.Diet.DHCIPMealBill).SELECT(BILL) 
	s PLIST(3)=$g(AdmDate)
	s PLIST(4)=+$h
	s PLIST(5)=+$g(PLIST(5))+TotalAmount
	s PLIST(6)=+$H
	s PLIST(7)=$p($H,",",2)
	s PLIST(8)=USER
	s err=##class(DHCBILL.Diet.DHCIPMealBill).UPDATE(BILL)
	q err
}

ClassMethod GetOrdItemQty(OrdItemRowid As %String) As %String
{
	s qty=0
	s billedFlag=$p(^DHCIPMEALORDER(+OrdItemRowid,"I",$p(OrdItemRowid,"||",2)),"^",17)
	i billedFlag="B" d
	.s qty=..GetBilledOrdItemQty(OrdItemRowid)
	e  d
	.s qty=$p(^DHCIPMEALORDER(+OrdItemRowid,"I",$p(OrdItemRowid,"||",2)),"^",5)
	q qty
}

/// 退过费返回0
ClassMethod GetBilledOrdItemQty(OrdItemRowid As %String) As %String
{
	s ordItemQty1=0
	S billRowid1 =$o(^DHCIPMEALBILL(0,"MO",OrdItemRowid,0))
	q:+billRowid1=0 0
	s billDetailRowid1=0 
	f  s billDetailRowid1=$o(^DHCIPMEALBILL(0,"MO",OrdItemRowid,billRowid1,billDetailRowid1)) q:billDetailRowid1=""  d
	.s billQty1=$p(^DHCIPMEALBILL(billRowid1,"D",billDetailRowid1),"^",3)
	.s ordItemQty1=billQty1+ordItemQty1
	q ordItemQty1
}

/// Function:取菜的单价
ClassMethod GetMenuItmPrice(MenuItm, StDate)
{
	q:MenuItm="" 0
	s:StDate="" StDate=+$H
	s StDate0=StDate+1
	s ExeDate=""
	s ExeDate=$o(^DHCIPMEALITEM(MenuItm,StDate0),-1)
	q:ExeDate="" 0
	s ChildSub=$o(^DHCIPMEALITEM(MenuItm,ExeDate,""),-1)
	s Price=$p(^DHCIPMEALITEM(MenuItm,"P",ChildSub),"^",1)
    q $g(Price)
}

ClassMethod round(Num)
{
	n (Num)
	s NegFlag=0
	q:$g(Num)=""!(Num=0) 0
	i Num<0 s Num=-Num,NegFlag=1
	i Num<0.01 s Num=0.01       
	e  d
	.s Num=+Num+0.0000001
	.s np=$p(Num,".",1)_"."_$e($p(Num,".",2),1,2)
	.s point="0.00"_$e($p(Num,".",2),3,$l($p(Num,".",2)))
	.s Num=np 
	.s:point'<0.005 Num=Num+0.01
	i NegFlag=1 s Num=-Num
	q Num
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

/// @author : wanghc
/// @desc:    拿到病区树节点串
ClassMethod ToBillTreeJson(date)
{
	i date="" d
	.s date=+$h
	e  d
	.s date=$zdh(date,3)
	/*s unbillNodeLeaf="true"
	s billFlag=""
	s moRowid=0 f  s moRowid=$o(^DHCIPMEALORDER(0,"StartDate",date,moRowid)) q:(moRowid="")||(billFlag="TB")  d
	.s billFlag=""
	.s moiRowid=0 f  s moiRowid=$o(^DHCIPMEALORDER(0,"StartDate",date,moRowid,moiRowid)) q:(moiRowid="")||(billFlag="TB")  d
	..s billFlag = $p(^DHCIPMEALORDER(moRowid,"I",moiRowid),"^",17)
	..q:billFlag'="TB"
	..s unbillNodeLeaf="false"
	
	s billFlag=""
	s moRowid=0 f  s moRowid=$o(^DHCIPMEALORDER(0,"StartDate",date,moRowid)) q:(moRowid="")||(billFlag="B")||(billFlag="P")  d
	.s billFlag=""
	.s moiRowid=0 f  s moiRowid=$o(^DHCIPMEALORDER(0,"StartDate",date,moRowid,moiRowid)) q:(moiRowid="")||(billFlag="B")||(billFlag="P")  d
	..s billFlag = $p(^DHCIPMEALORDER(moRowid,"I",moiRowid),"^",17)
	..q:billFlag'="B"
	..q:billFlag'="P"
	..s billNodeLeaf="false"*/
	s unbillNodeLeaf="false"
	s billNodeLeaf="false"
	s billTreeJson="[{id:'unbillNode',text:'未帐单的膳食',leaf:"_unbillNodeLeaf_"},{id:'billNode',text:'已帐单的膳食',leaf:"_billNodeLeaf_"}]"
	//s billTreeJson="[{id:'billNode',text:'已帐单的膳食',leaf:"_billNodeLeaf_"}]"
	q billTreeJson
}

/// @author : wanghc
/// @desc:    拿到未帐单病区树节点串
/// @param:   date "yyyy-mm-dd"
/// @other:  ##class(DHCBILL.Diet.DHCIPMealFeeBill).ToUnhandinWardTreeJson()
ClassMethod ToUnbillWardTreeJson(date)
{
	i date="" d
	.s date=$h
	e  d
	.s date=$zdh(date,3)
	s wardSet = ""
	s wardJson="["
	s moRowid=0 f  s moRowid=$o(^DHCIPMEALORDER(0,"StartDate",date,moRowid)) q:(moRowid="")  d
	.s billFlag=""
	.s moiRowid=0 f  s moiRowid=$o(^DHCIPMEALORDER(0,"StartDate",date,moRowid,moiRowid)) q:(moiRowid="")||(billFlag="TB")  d
	..s billFlag = $p(^DHCIPMEALORDER(moRowid,"I",moiRowid),"^",17)
	..q:billFlag'="TB"
	..s admRowid=$p(^DHCIPMEALORDER(moRowid),"^",1)
	..s wardRowid = $p(^PAADM(admRowid),"^",70)
	..s code=$p($g(^PAWARD(wardRowid)),"^",1)
	..q:$l(wardSet,"^"_wardRowid_"^")>1				//如果病区已经存在就不加入树
	..s wardSet=wardSet_"^"_wardRowid_"^"
	..i wardJson="[" d
	...s wardJson=wardJson_"{id:'UnbillWard-"_wardRowid_"',"_"text:'"_code_"',iconCls:'iconWard',leaf:false}"
	..e  d
	...s wardJson=wardJson_",{id:'UnbillWard-"_wardRowid_"',"_"text:'"_code_"',iconCls:'iconWard',leaf:false}"
	q wardJson_"]"
}

ClassMethod ToBillWardTreeJson(date)
{
	i date="" d
	.s date=$h
	e  d
	.s date=$zdh(date,3)
	s wardSet = ""
	s wardJson="["
	s moRowid=0 f  s moRowid=$o(^DHCIPMEALORDER(0,"StartDate",date,moRowid)) q:(moRowid="")  d
	.s billFlag=""
	.s moiRowid=0 f  s moiRowid=$o(^DHCIPMEALORDER(0,"StartDate",date,moRowid,moiRowid)) q:(moiRowid="")||(billFlag="B")||(billFlag="P")  d
	..s billFlag = $p(^DHCIPMEALORDER(moRowid,"I",moiRowid),"^",17)
	..q:(billFlag'="B")&&(billFlag'="P")
	..s admRowid=$p(^DHCIPMEALORDER(moRowid),"^",1)
	..s wardRowid = $p(^PAADM(admRowid),"^",70)
	..s code=$p($g(^PAWARD(wardRowid)),"^",1)
	..q:$l(wardSet,"^"_wardRowid_"^")>1				//如果病区已经存在就不加入树
	..s wardSet=wardSet_"^"_wardRowid_"^"
	..i wardJson="[" d
	...s wardJson=wardJson_"{id:'BillWard-"_wardRowid_"',"_"text:'"_code_"',iconCls:'iconWard',leaf:false}"
	..e  d
	...s wardJson=wardJson_",{id:'BillWard-"_wardRowid_"',"_"text:'"_code_"',iconCls:'iconWard',leaf:false}"
	q wardJson_"]"
}

/// @author: wanghc
/// @param:  wardRowid(病区rowid)
/// @desc:   通过病区rowid拿到叶子json串
ClassMethod ToUnbillPaadmTreeJson(wardRowid, date)
{
	q:+wardRowid=0 "[]"
	i date="" d
	.s date=$h
	e  d
	.s date=$zdh(date,3)
	s paadmTreeJson="["
	s moRowid=0 f  s moRowid=$o(^DHCIPMEALORDER(0,"StartDate",date,moRowid)) q:(moRowid="")  d
	.s billFlag=""
	.s moiRowid=0 f  s moiRowid=$o(^DHCIPMEALORDER(0,"StartDate",date,moRowid,moiRowid)) q:(moiRowid="")||(billFlag="TB")  d
	..s billFlag = $p(^DHCIPMEALORDER(moRowid,"I",moiRowid),"^",17)
	..q:billFlag'="TB"
	..s admRowid=$p(^DHCIPMEALORDER(moRowid),"^",1) 
	..s wardDR=$p(^PAADM(admRowid),"^",70)
	..q:wardRowid'=wardDR
	..s papmidr=+$p(^PAADM(admRowid),"^",1)
	..s name=$p(^PAPER(papmidr,"ALL"),"^",1)
	..;Lid 2010-05-26 设置男、女的显示图片
	..s sexDr=$p(^PAPER(papmidr,"ALL"),"^",7) 
	..i sexDr'="" s sex=$p(^CT("SEX",sexDr),"2")
	..i ($g(sex)["男") s iconPerson="iconM"
	..e  i ($g(sex)["女") s iconPerson="iconF"
	..e  s iconPerson="iconM"
	..s medicare=$p(^PAPER(papmidr,"PAT",1),"^",22)
	..i medicare'="" d 
	...s info=name_"("_medicare_")"
	..e  d
	...s info=name
	..i paadmTreeJson="[" d
	...s paadmTreeJson=paadmTreeJson_"{id:'UnbillPAPER-"_papmidr_"',text:'"_info_"',iconCls:'"_iconPerson_"',leaf:true}"
	..e  d
	...s paadmTreeJson=paadmTreeJson_",{id:'UnbillPAPER-"_papmidr_"',text:'"_info_"',iconCls:'"_iconPerson_"',leaf:true}"
	q paadmTreeJson_"]"
}

/// @author: wanghc
/// @param:  wardRowid(病区rowid)
/// @desc:   通过病区rowid拿到叶子json串
ClassMethod ToBilledPaadmTreeJson(wardRowid, date)
{
	q:+wardRowid=0 "[]"
	i date="" d
	.s date=$h
	e  d
	.s date=$zdh(date,3)
	s paadmTreeJson="["
	s moRowid=0 f  s moRowid=$o(^DHCIPMEALORDER(0,"StartDate",date,moRowid)) q:(moRowid="")  d
	.s billFlag=""
	.s moiRowid=0 f  s moiRowid=$o(^DHCIPMEALORDER(0,"StartDate",date,moRowid,moiRowid)) q:(moiRowid="")||(billFlag="B")||(billFlag="P")  d
	..s billFlag = $p(^DHCIPMEALORDER(moRowid,"I",moiRowid),"^",17)
	..q:(billFlag'="B")&&(billFlag'="P")
	..s admRowid=$p(^DHCIPMEALORDER(moRowid),"^",1) 
	..s wardDR=$p(^PAADM(admRowid),"^",70)
	..q:wardRowid'=wardDR
	..s papmidr=+$p(^PAADM(admRowid),"^",1)
	..s name=$p(^PAPER(papmidr,"ALL"),"^",1)
	..;Lid 2010-05-26 设置男、女的显示图片
	..s sexDr=$p(^PAPER(papmidr,"ALL"),"^",7) 
	..i sexDr'="" s sex=$p(^CT("SEX",sexDr),"2")
	..i ($g(sex)["男") s iconPerson="iconM"
	..e  i ($g(sex)["女") s iconPerson="iconF"
	..e  s iconPerson="iconM"
	..s medicare=$p(^PAPER(papmidr,"PAT",1),"^",22)
	..i medicare'="" d 
	...s info=name_"("_medicare_")"
	..e  d
	...s info=name
	..i paadmTreeJson="[" d
	...s paadmTreeJson=paadmTreeJson_"{id:'BillPAPER-"_papmidr_"',text:'"_info_"',iconCls:'"_iconPerson_"',leaf:true}"
	..e  d
	...s paadmTreeJson=paadmTreeJson_",{id:'BillPAPER-"_papmidr_"',text:'"_info_"',iconCls:'"_iconPerson_"',leaf:true}"
	q paadmTreeJson_"]"
}

/// Creator:wanghc
/// CreateDate:2010-12-09
/// Function  :根据Adm,日期,菜谱形态，餐别取Adm已点信息
/// Input     :MenuDate：制作日期；MenuModality:餐谱形态rowid(dhc_ipmealmodality) admrowid, billFlag:"B","P","TB"
/// OutPut    :ItmCode:菜代码,ItmDesc：菜名称,ItmMealType：餐别,
/// ItmMealModality：餐谱形态,ItmUom：单位,ItmRemark：备注,ItmPrice：单价,MealItemRowID：菜定义指针（dhc_ipmealitem),ItmMealTypeID:餐别rowid,ItmMealModalityID：餐谱形态rowid,ItmUomID：单位rowid
ClassMethod FindMenuItmByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMenuItmByDateExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 已帐单查询                                                                     2011-01-20^^77078^TB
/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealFeeBill","FindMenuItmByDate","2011-01-20","","","77078","TB")
ClassMethod FindMenuItmByDateExecute(ByRef qHandle As %Binary, MenuDate As %String, MenuModailty As %String, MenuType As %String, Adm As %String, billFlag As %String) As %Status
{
	;"2011-01-20^^77078^TB"
	s ^TMP("wanghc","FeeBillFind")=MenuDate_""_MenuModailty_"^"_MenuType_"^"_Adm_"^"_billFlag
    Set repid=$I(^CacheTemp)
    s ind=1
    s:billFlag="" billFlag="TB"			//默认查询未帐单的
    i MenuDate="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s MenuDate=$zdh(MenuDate,3)
	i Adm=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
	s MealOrdRowID=$o(^DHCIPMEALORDER(0,"Adm",+$g(Adm),"")) 
	i MealOrdRowID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s (Qty,ItmTotalAmount,ItmCode,ItmDesc,ItmMealType,ItmMealModality,ItmUom,ItmRemark,ItmPrice,MealItemRowID,ItmMealTypeID,ItmMealModalityID,ItmUomID,menuItmRowid)=""
	s ItmChildSub=0 f  s ItmChildSub=$o(^DHCIPMEALORDER(0,"StartDate",MenuDate,MealOrdRowID,ItmChildSub)) q:ItmChildSub=""  d
	.s mealOrdItemRowid=MealOrdRowID_"||"_ItmChildSub
	.s tmpOrdItemStr=^DHCIPMEALORDER(MealOrdRowID,"I",ItmChildSub) 
	.s BillFlag=$p(tmpOrdItemStr,"^",17)
	.q:BillFlag'=billFlag ;已经记帐的医嘱才输出
	.s ordItemItmMealTypeDR=$p(tmpOrdItemStr,"^",21) ;医嘱中的餐类型
    .s ordItemItmMealModalityDR=$p(tmpOrdItemStr,"^",22) ;医嘱中的餐态
    .q:(MenuModailty'=ordItemItmMealModalityDR)&&(MenuModailty'="")
    .q:(MenuType'=ordItemItmMealTypeDR)&&(MenuType'="")
    .s MealItemRowID=$p(tmpOrdItemStr,"^",1) ;菜String
    .s tmpMealItemStr=^DHCIPMEALITEM(MealItemRowID) 
    .s ItmCode=$p(tmpMealItemStr,"^",1)
    .s ItmDesc=$p(tmpMealItemStr,"^",2)
    .s ItmMealType=$p($g(^DHCIPMEALTYPE(ordItemItmMealTypeDR)),"^",2)
    .s ItmMealModality=$p($g(^DHCIPMEALMODALITY(ordItemItmMealModalityDR)),"^",2)
    .s ItmUomID=$p(tmpMealItemStr,"^",5)
    .i ItmUomID'="" s ItmUom=$p($g(^DHCIPMEALUOM(ItmUomID)),"^",2)
    .s ItmRemark=$p(^DHCIPMEALITEM(MealItemRowID),"^",12)
    .i BillFlag="B" d
    ..s billDetailRowid=$p(tmpOrdItemStr,"^",6)
    ..S billDetailSubRowid=$P(billDetailRowid,"||",2)
    ..s Qty=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetBilledOrdItemQty(MealOrdRowID_"||"_ItmChildSub)  //拿帐单中的数量
    ..s ItmPrice=$p(^DHCIPMEALBILL(+billDetailRowid,"D",billDetailSubRowid),"^",2)
    ..;s Qty=+$p(tmpOrdItemStr,"^",5)
	..S ItmTotalAmount=ItmPrice*Qty
    .e  d
    ..s Qty=##class(DHCBILL.Diet.DHCIPMealInsertOrder).getOrdItemQtyByAdm(Adm,MenuDate,MealItemRowID,ordItemItmMealTypeDR,ordItemItmMealModalityDR)
    ..s ItmPrice=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetMenuItmPrice(MealItemRowID,+$h)		
    ..s itmTotalAmount=Qty*ItmPrice			
	
    .d OutputRow1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
    
	set Data=$lb(Qty,ItmCode,ItmDesc,ItmMealType,ItmMealModality,ItmUom,ItmRemark,$j(ItmPrice,2,2),$j(ItmTotalAmount,2,2),mealOrdItemRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMenuItmByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMenuItmByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

Query FindMenuItmByDate(MenuDate As %String, MenuModailty As %String, MenuType As %String, Adm As %String, billFlag As %String) As %Query(ROWSPEC = "Qty,itmcode,itmdesc,itmmealtype,itmmealmodality,itmuom,itmremark,itmprice,itmTotalAmount,mealOrdItemRowid")
{
}

}
