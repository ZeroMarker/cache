Import sqluser

Class DHCBILL.Diet.DHCIPMealInsertOrder Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Function:插入病人点餐明细表
/// Table   :dhc_ipmealorder,dhc_ipmealorditem
/// d ##class(DHCBILL.Diet.DHCIPMealInsertOrder).InsertOrder(^TMP("wanghc","order","order"),^TMP("wanghc","order","itm"))
/// mealitemrowid+"^"+preStartDate+"^"+time+"^"+"^"+mealNumber+"^"+userRowid+"^"+itmremark+"^^^"+menuitmrowid
/// $c(2)
ClassMethod InsertOrder(OrdInfo, ItmInfo)
{
	s ^TMP("wanghc","order","order")=OrdInfo
	s ^TMP("wanghc","order","itm")=ItmInfo
	Tstart
	s MOAdmStr=$p(OrdInfo,"^",1)	//111112  admRowid1-admRowid2-admRowid3-admRowid4
	s MODate=+$h
	s MOTime=$p($h,",",2)
	s MOUserDr=$p(OrdInfo,"^",2)    //1
	s MORemark=$p(OrdInfo,"^",3)
	s MOComment1=$p(OrdInfo,"^",4)
	s MOComment2=$p(OrdInfo,"^",5)
	s RetVal=0
	b ;000
	s admNum=$l(MOAdmStr,"-")	//add by wanghc 多人点餐
	f admNumIndex=1:1:admNum q:RetVal'=0  d
	.s MOAdm=$p(MOAdmStr,"-",admNumIndex)
	.s MORowID=$o(^DHCIPMEALORDER(0,"Adm",MOAdm,""))
	.i $g(MORowID)="" d
	..k PLIST
	..s PLIST(2)=MOAdm,PLIST(3)=MODate,PLIST(4)=MOTime
	..S PLIST(5)=MOUserDr,PLIST(6)=MORemark,PLIST(7)=MOComment1,PLIST(8)=MOComment2
	..b ;111
	..&sql(INSERT INTO DHC_IPMealOrder Values PLIST())
	..s RetVal=SQLCODE
	..s MORowID=$g(%ROWID)
	..i RetVal=0 D
	...s RetVal=..InsertOrdItem(MOAdm,MORowID,ItmInfo) 
	.e  d
	..b ;444
	..s RetVal=..InsertOrdItem(MOAdm,MORowID,ItmInfo) 
	b ;33333
	i RetVal=0 tcommit
	e  trollback
	q RetVal
}

/// Function:插入病人点餐明细表
/// Table   :dhc_ipmealorditem
/// Input    :病人admrowid，dhc_ipmealorder.dhcmo_rowid,
/// ItmInfo  :记录之间以$c(2)分割，单条记录以"^"分割:
/// MItmDr^开始日期^开始时间^用户科室^数量^用户^remark^comment1^comment2
/// w ##class(DHCBILL.Diet.DHCIPMealInsertOrder).InsertOrdItem("111112","114","4292^2011-10-27^^^1^1^^^^24||406")
ClassMethod InsertOrdItem(MOAdm, MORowID, AllItmInfo)
{
	//"5^2010-05-17^^5^876^馒头最多买10个^^"
	s ^TMP("wanghc","item")=MOAdm_","_MORowID_","_AllItmInfo
	b
	//s ^xs111026=AllItmInfo
	q:AllItmInfo="" 0
	s RowNum=$l(AllItmInfo,$c(2)) 
	s tmpItmMealTypeID=0,tmpItmMealModalityID=0
	f i=1:1:RowNum d  q:SQLCODE'=0
	.K PLIST,PLIST(1)
	.s PLIST(0)=MORowID
    .s ItmInfo=$p(AllItmInfo,$c(2),i)
	.s MItmDr=$p(ItmInfo,"^",1),PLIST(3)=MItmDr
	.s StartDate=$p(ItmInfo,"^",2)
	.i StartDate'="" s StartDate=$zdh(StartDate,3),PLIST(4)=StartDate
	.s StartTime=$p(ItmInfo,"^",3)
	.i StartTime'="" s StartTime=$zth(StartTime,1),PLIST(5)=StartTime
	.s UserLocDr=$p(ItmInfo,"^",4),PLIST(6)=UserLocDr
	.s Qty=+$p(ItmInfo,"^",5),PLIST(7)=Qty
	.;q:+Qty'>0   //更新成0
	.s OrdBill="",PLIST(8)=OrdBill
	.s CurLoc=$p(^PAADM(MOAdm),"^",4),PLIST(9)=CurLoc
	.s CurWard=$p(^PAADM(MOAdm),"^",70),PLIST(10)=CurWard
	.s AddDate=+$h,PLIST(11)=AddDate
	.s AddTime=$p($h,",",2),PLIST(12)=AddTime
	.s AddUser=$p(ItmInfo,"^",6),PLIST(20)=AddUser
	.s UpdateDate=+$h,PLIST(14)=UpdateDate
	.s UpdateTime=$p($h,",",2),PLIST(15)=UpdateTime
	.s UpdateUser=$p(ItmInfo,"^",6),PLIST(13)=UpdateUser
	.s PLIST(16)="TB"
	.s Remark=$p(ItmInfo,"^",7),PLIST(17)=Remark
	.s Comment1=$p(ItmInfo,"^",8),PLIST(18)=Comment1
	.s Comment2=$p(ItmInfo,"^",9),PLIST(19)=Comment2
	.s menuItmDr=$p(ItmInfo,"^",10) ;菜谱明细Rowid
	.s itmMMDr=$p(^DHCIPMEALMENU(+menuItmDr,"M",$p(menuItmDr,"||",2)),"^",3) ;餐形态Rowid
	.s itmMTDr=$p(^DHCIPMEALMENU(+menuItmDr,"M",$p(menuItmDr,"||",2)),"^",2) ;餐别Rowid
	.s PLIST(21)=$g(itmMTDr)
	.s PLIST(22)=$g(itmMMDr)
	.;拿同名同态同形的TB状态的医嘱菜
	.s TBSameMOIRowid=0
	.s MOIRowid=0 f  s MOIRowid=$o(^DHCIPMEALORDER(0,StartDate,MItmDr,MORowID,MOIRowid)) q:(MOIRowid="")||(TBSameMOIRowid'=0)  d  
    ..s tmp=$g(^DHCIPMEALORDER(+MORowID,"I",MOIRowid))
    ..s tmpItmMealTypeID=$p(tmp,"^",21) ;菜类型
    ..s tmpItmMealModalityID=$p(tmp,"^",22) ;菜形态
    ..s tmpBillType=$p(tmp,"^",17)
    ..s:(tmpBillType="TB")&&(itmMTDr=tmpItmMealTypeID)&&(itmMMDr=tmpItmMealModalityID) TBSameMOIRowid=MOIRowid
	.i (+TBSameMOIRowid=0) d
	..&sql(insert into DHC_IPMealOrdItem values :PLIST())
	.e  d
	..s moitemRowid=MORowID_"||"_TBSameMOIRowid
	..&sql(update DHC_IPMealOrdItem set DHCMOI_Qty=:Qty where DHCMOI_RowId=:moitemRowid)
    .i SQLCODE=0 d
    ..s menuItmRowid=$p(ItmInfo,"^",10) ;菜谱明细Rowid,设置菜谱使用标志
    ..&sql(update DHC_IPMealMenuDetail set DHCMMD_ItmStatus='Y' where DHCMMD_RowID=:menuItmRowid)
    .i SQLCODE=0 d
    ..s menuRowid=$p($p(ItmInfo,"^",10),"||",1) ;菜谱主表Rowid，子菜谱有一条记录为“Y”，则主菜谱的状态为“A”
    ..&sql(update DHC_IPMealMenu set DHCMM_Status='A' where DHCMM_RowID=:menuRowid)
	b ;22222
	q SQLCODE
}

ClassMethod stopOrderItem(orderItemRowid As %String, userRowid As %String)
{
	s DHCMOIUpdateDate=+$h //"2010-12-18" //$zd(+$h,3)
	s DHCMOIUpdateTime=$p($h,",",2) 
	&sql(update DHC_IPMealOrdItem 
	set DHCMOI_Billed='I',
	DHCMOI_UpdateUser_Dr=:userRowid,
	DHCMOI_UpdateDate=:DHCMOIUpdateDate,
	DHCMOI_UpdateTime=:DHCMOIUpdateTime
	where DHCMOI_RowId=:orderItemRowid)	
	q SQLCODE
}

ClassMethod InsertOrderByOrdItemRowidAndQty(orderItemRowid As %String, qty As %String, userRowid As %String)
{
	;用以前的单价
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_IPMealOrdItem WHERE DHCMOI_RowId= :orderItemRowid) 
	q:SQLCODE'=0 SQLCODE
	s PLIST=$o(PLIST(""),-1)
	K PLIST(1),PLIST(2)
	s PLIST(16)="TB"
	s AddDate=+$h,PLIST(11)=AddDate
	s AddTime=$p($h,",",2),PLIST(12)=AddTime
	s UpdateDate=+$h,PLIST(14)=UpdateDate
	s UpdateTime=$p($h,",",2),PLIST(15)=UpdateTime
	s PLIST(20)=userRowid
	s PLIST(13)=userRowid 
	S OrdBillDr="", PLIST(8)=OrdBillDr
	s PLIST(7)=qty
	s PLIST(23)=orderItemRowid   ;DHCMOI_Init_Dr  wanghc 加一红冲指向
	&sql(INSERT INTO DHC_IPMealOrdItem VALUES :PLIST())
	q SQLCODE
}

ClassMethod InsertOrderByOrdItemRowid(orderItemRowid As %String)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_IPMealOrdItem WHERE DHCMOI_RowId= :orderItemRowid) 
	q:SQLCODE'=0 SQLCODE
	s PLIST=$o(PLIST(""),-1)
	K PLIST(1),PLIST(2)
	s PLIST(16)="TB"
	s AddDate=+$h,PLIST(11)=AddDate
	s AddTime=$p($h,",",2),PLIST(12)=AddTime
	s UpdateDate=+$h,PLIST(14)=UpdateDate
	s UpdateTime=$p($h,",",2),PLIST(15)=UpdateTime
	S OrdBillDr="", PLIST(8)=OrdBillDr
	&sql(INSERT INTO DHC_IPMealOrdItem VALUES :PLIST())
	q SQLCODE
}

/// 一条膳食医嘱对应一条明细，对应一条his医嘱,三者一一对应
/// itemInfo="mealOrdItemRowid+"^"+mealNumber+$c(2)+mealOrdItemRowid+"^"+mealNumber"
/// w ##class(DHCBILL.Diet.DHCIPMealInsertOrder).StrikeOrdItem("36||8^",10327,32617)
ClassMethod StrikeOrdItem(itemInfo, userRowid, adm) As %String
{
	;"35||225^1,910,66107"
	s ^TMP("wanghc","StrikeOrdItem")=itemInfo_","_userRowid_","_adm
	TS
	s date=$zd(+$h,3)
	s err=0
	;判断是否在院
	s VisitStatus = $p(^PAADM(adm),"^",20)
	q:VisitStatus'="A" "notAdm"
	q:itemInfo="" "notChange"
	s len=$l(itemInfo,$c(2))

	f i=1:1:len q:(err'=0)||(err="notBill")||(err="qtyTooBig")  d
	.s itemInfoPiece=$p(itemInfo,$c(2),i)
	.s mealOrdItemRowid=$p(itemInfoPiece,"^",1)
	.s newQty=+$p(itemInfoPiece,"^",2)
	.s mealOrdItemSubRowid=$p(mealOrdItemRowid,"||",2)
	.s tmpOrdItemGlobalStr=^DHCIPMEALORDER(+mealOrdItemRowid,"I",mealOrdItemSubRowid)
	.s oldQty=+$p(tmpOrdItemGlobalStr,"^",5)
	.q:newQty=oldQty    //数量没有改变不进行操作
	.s:newQty>oldQty err="qtyTooBig"
	.q:err="qtyTooBig"
	.;判断传入的医嘱有没有帐单
	.s ordItemBilled=$p(tmpOrdItemGlobalStr,"^",17)
	.s:ordItemBilled'="B" err="notBill"
	.q:err="notBill"
	.;判断医嘱是不是已导到his端，导到就停his医嘱
	.s billDetailRowid=$p(tmpOrdItemGlobalStr,"^",6)
	.s subBillRowid=$p(billDetailRowid,"||",2)
	.s hisOrdItemRowid=$p(^DHCIPMEALBILL(+billDetailRowid,"D",subBillRowid),"^",9)
	.;停his医嘱
	.i +hisOrdItemRowid>0 d
	..s hisOrdItemBilled=$p(^OEORD(+hisOrdItemRowid,"I",$p(hisOrdItemRowid,"||",2),3),"^",5)
	..;判断医嘱是不是已结算
	..i hisOrdItemBilled="P" s err="hisOrdItemPaid"
	..q:err="hisOrdItemPaid"
	..;D ##Class(web.DHCOEOrdItem).StopOrderItem(hisOrdItemRowid,userRowid,369)    ;
	..D ##Class(web.DHCOEOrdItem).StopOrderItem(hisOrdItemRowid,10327,369)  //Lid 2012-03-13 华山医院由指定的人停医嘱
	.q:err="hisOrdItemPaid"
	.;再停膳食医嘱
	.S err=##Class(DHCBILL.Diet.DHCIPMealInsertOrder).stopOrderItem(mealOrdItemRowid,userRowid)
	.q:err'=0
	.;写新膳食医嘱
	.if newQty>0 d
	..s err=##class(DHCBILL.Diet.DHCIPMealInsertOrder).InsertOrderByOrdItemRowidAndQty(mealOrdItemRowid,newQty,userRowid)
	..q:err'=0
	
	;b ;calPatLanchFee
	;;帐单膳食医嘱
	;s bill= ##class(DHCBILL.Diet.DHCIPMealFeeBill).CalPatLanchFee(adm,userRowid,date)
	;i $l(bill,"^")>1 s err=$p(bill,"^")
	;e  i +bill>0 s err=0
	;b ;bill
	;;导入his
	;i err=0 d
	;.s err=##class(web.DHCIPMealWorkLoad).billToHisOrdItemByAdm(adm,"")

	i err=0 TC
	e  TRO
	q err
}

/// Function:查询某个就诊的点菜明细
/// Table   :dhc_ipmealorder,dhc_ipmealorditem
ClassMethod FindMealItmByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealItmByAdmExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMealItmByAdmExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s MealOrdRowID=0
    f  s MealOrdRowID=$o(^DHCIPMEALORDER(0,"Adm",Adm,MealOrdRowID)) q:MealOrdRowID=""  d
    .s ChildSub=0
    .f  s ChildSub=$o(^DHCIPMEALORDER(MealOrdRowID,"I",ChildSub)) q:ChildSub=""  d
    ..s MealItmInfo=^DHCIPMEALORDER(MealOrdRowID,"I",ChildSub)
    ..s MealOrdItmRowID=MealOrdRowID_"||"_ChildSub
    ..s MealItmDr=$p(MealItmInfo,"^",1)
    ..s MealItmDesc=$p($g(^DHCIPMEALITEM(MealItmDr)),"^",2)
    ..s MealTypeDr=$p(^DHCIPMEALITEM(MealItmDr),"^",3)
    ..s MealType=$p($g(^DHCIPMEALTYPE(MealTypeDr)),"^",2)
    ..s MealModalityDr=$p(^DHCIPMEALITEM(MealItmDr),"^",4)
    ..s MealModality=$p($g(^DHCIPMEALMODALITY(MealModalityDr)),"^",2)
    ..s MealQty=$p(MealItmInfo,"^",5)
    ..s MealBill=$p(MealItmInfo,"^",17)
    ..s MealOrdBill=$p(MealItmInfo,"^",6)   ;指向账单表的rowid
    ..s MealUnitPrice=""  ;取单价
    ..s MealPayAmt=""    ;取账单表的金额
    ..d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	set Data=$lb(MealItmDesc,MealType,MealModality,MealUnitPrice,MealQty,MealPayAmt,MealBill,MealOrdBill,MealOrdItmRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealItmByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealItmByAdmExecute ]
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

Query FindMealItmByAdm(Adm As %String) As %Query(ROWSPEC = "mealitmdesc,mealtype,mealmodality,mealunitprice,mealqty,mealpayamt,mealbill,mealordbill,mealorditmrowid")
{
}

/// Creator:yyx
/// CreateDate:2010-05-10
/// Function:根据病人的rowid取病人信息
/// Input   :病人信息rowid
/// OutPut:  住院号^病人姓名^入院日期^病人床号^膳食医嘱^病人费别^账户余额^其它备注^AdmID^PapmiID^病区
/// add by wanghc 加病区 加膳食医嘱
/// w ##class(DHCBILL.Diet.DHCIPMealInsertOrder).GetPatInfoByPapmiID(108972,"2012-03-13")
ClassMethod GetPatInfoByPapmiID(PapmiID, bookDate)
{
	 s ^TMP("GetPatInfoByPapmiID")=PapmiID_","_bookDate
	 b ;22
	 q:PapmiID="" ""
	 i bookDate'="" s bookDate=$zdh(bookDate,3)
	 e  s bookDate=+$h
	 s mealOrderDesc=""
	 ;人员基本信息
	 i $d(^PAPER(PapmiID,"PAT",1)) d
	 .s PapNo=$p(^PAPER(PapmiID,"PAT",1),"^",1)   ;登记号
	 .s Medicare=$p(^PAPER(PapmiID,"PAT",1),"^",22)   ;住院号
	 ;
	 i $d(^PAPER(PapmiID,"ALL")) d
	 .s PapName=$p(^PAPER(PapmiID,"ALL"),"^",1)   ;姓名
	 .s SafeCardNo=$p(^PAPER(PapmiID,"ALL"),"^",9)   ;身份证
	 .s Sex=$p(^PAPER(PapmiID,"ALL"),"^",7)       ;性别
	 .i Sex'="" s Sex=$p(^CT("SEX",Sex),"^",2)
	 ;
	 i $d(^PAPER(PapmiID,"PER","ADD",1)) d
	 .s Address=^PAPER(PapmiID,"PER","ADD",1)  ;地址        
	 ;
	 s AdmID=$o(^PAPERdr(PapmiID,"ADM","I",""),-1)
	 s AdmDate=$p(^PAADM(AdmID),"^",6)
	 i +$g(AdmDate)'=0 s AdmDate=$zd(AdmDate,3)
	 s admRoom=$p(^PAADM(AdmID),"^",69)
	 s:admRoom'="" admRoomDesc=$p(^PAROOM(admRoom),"^",2)
	 s BedRowid=$p(^PAADM(AdmID),"^",73)
	 s BedCode=""
	 if BedRowid'="" d
	 .s BedCode=$p(^PAWARD($p(BedRowid,"||",1),"BED",$p(BedRowid,"||",2)),"^",1)
	 ;
	 s admWard=$p(^PAADM(AdmID),"^",70)
	 s:admWard'="" admWardDesc=$p($p(^PAWARD(admWard),"^",2),"-",2)
	 s orderRowid=$o(^OEORD(0,"Adm",AdmID,0)) //^OEORDi(0,"StDtStat",bookDate,1,
	 b ;
	 s mealOrderDesc="无"
	 s oeordId="" 
	 f  s oeordId=$o(^OEORD(0,"Adm",AdmID,oeordId)) q:oeordId=""  d
	 .s oeoriSub=0 
	 .f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
	 ..s SttDate=$p($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
	 ..;q:+SttDate'=+bookDate
	 ..s ArcimDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	 ..s ARCIMRowid=$P(ArcimDR,"||",1)
	 ..s ARCIMSub=$P(ArcimDR,"||",2)
	 ..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)	//oeori_itmmast_dr->arcim_itemcat_dr->ARc_Itemcat				
	 ..s OrdCatDR=$p(^ARC("IC",ItemCatDR),"^",8)
	 ..s OrdCatCode=$p(^OEC("ORCAT",OrdCatDR),"^",1)
	 ..q:(OrdCatCode'="06")
	 ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)
	 ..;q:(ordStatCode'="V")

	 ..s arcItemCatRowid =$p(^ARCIM(+ARCIMRowid,ARCIMSub,1),"^",10)
	 ..s ORCATRowId=$p(^ARC("IC",arcItemCatRowid),"^",8)
	 ..i (ORCATRowId="25")&(+arcItemCatRowid'=1650) s mealOrderDesc="有"
	 ..;s:(arcItemCatRowid=147)||(arcItemCatRowid=200) mealOrderDesc=$p(^ARCIM(+arcItMMastRowid,arcItemSubRowid,1),"^",2)_" "_$g(mealOrderDesc)
	 ;
	 i $d(^PAADM(AdmID,1)) d
	 .s insTypeDr=$p(^PAADM(AdmID,1),"^",7)	
	 .s:insTypeDr'="" insTypeDesc=$p(^PAC("ADMREA",insTypeDr),"^",2)
	 s depositAmount = ##class(web.UDHCJFBaseCommon).getdeposit(AdmID) //押金
	 s pbAmount=0														//adm下的帐单金额	
	 s pbRowid=0  f  s pbRowid=$o(^DHCPB(0,"ADM",AdmID,pbRowid)) q:pbRowid=""  d
	 .s pbAmount=pbAmount+$p($g(^DHCPB(pbRowid)),"^",12)
	 s accRemain=depositAmount-pbAmount					//余额
	 s PatInfo=$g(PapNo)_"^"_$g(PapName)_"^"_$g(AdmDate)_"^"_$g(BedCode)_"^"_$g(mealOrderDesc)_"^"_$g(insTypeDesc)_"^"_$g(accRemain)_"^"_$g(remarkDesc)_"^"_AdmID_"^"_PapmiID_"^"_$g(admWardDesc)_"^"_$g(admWard)
     q PatInfo
}

ClassMethod GetPatInfoByMedicare(inMedicare, bookDate)
{
	;w ##class(DHCBILL.Diet.DHCIPMealInsertOrder).GetPatInfoByMedicare("90004466","")
	q:inMedicare="" ""
	//s PapmiID=$o(^PAPERi("Medicare1",$$ALPHAUP^SSUTIL4(inMedicare),0))
	i $l(inMedicare)<8  d
	.s inMedicare=##class(web.UDHCJFBaseCommon).regnocon(inMedicare)
	s PapmiID=$o(^PAPERi("PAPMI_PatNo",inMedicare,""))
	
	q ..GetPatInfoByPapmiID(PapmiID,bookDate)
}

/// Creator:yyx
/// CreateDate:2010-05-15
/// Function  :根据日期,菜谱形态，餐别取周菜谱信息
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

///                                                                                   ""2011-08-25^^112755^^dsb""
/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealInsertOrder","FindMenuItmByDate","2011-08-25","","","112755","","dsb")
ClassMethod FindMenuItmByDateExecute(ByRef qHandle As %Binary, MenuDate As %String, MenuModailty As %String, MenuType As %String, Adm As %String, billFlag As %String, mealAlias As %String) As %Status
{
	s ^TMP("wanghc","Find")=MenuDate_""_MenuModailty_"^"_MenuType_"^"_Adm_"^"_billFlag_"^"_mealAlias
    Set repid=$I(^CacheTemp)
    s:billFlag="" billFlag="TB"			//默认查询未帐单的
    s ind=1
    i MenuDate="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s MenuDate=$zdh(MenuDate,3)
    
    s sortIndex=0
    f  s sortIndex=$o(^DHCIPMEALMENU(0,"StartDateSort",MenuDate,"Index",sortIndex)) q:sortIndex=""  d
    .s MMRowID=0 f  s MMRowID=$o(^DHCIPMEALMENU(0,"StartDateSort",MenuDate,"Index",sortIndex,MMRowID)) q:MMRowID=""  d
    ..s ChildSub=0
    ..b ;333
    ..s MMstatus=$p(^DHCIPMEALMENU(MMRowID),"^",3)
    ..f  s ChildSub=$o(^DHCIPMEALMENU(0,"StartDateSort",MenuDate,"Index",sortIndex,MMRowID,ChildSub)) q:ChildSub=""  d
    ...s MealItemRowID=$p(^DHCIPMEALMENU(MMRowID,"M",ChildSub),"^",1)   
    ...q:MealItemRowID=""
    ...s ItmActiveFlag=$p(^DHCIPMEALITEM(MealItemRowID),"^",7)
    ...b ;222
    ...q:ItmActiveFlag'="Y"  ;过滤“非可用状态”
    ...s tmp=$g(^DHCIPMEALMENU(MMRowID,"M",ChildSub)) 
    ...s ItmMealTypeID=$p(tmp,"^",2) 							;菜类型 
    ...s ItmMealModalityID=$p(tmp,"^",3)						 ;菜形态
    ...b ;111
    ...q:(MenuType'=ItmMealTypeID)&(MenuType'="")
    ...q:(MenuModailty'=ItmMealModalityID)&(MenuModailty'="")
    ...s ItmEndDate=$p(^DHCIPMEALITEM(MealItemRowID),"^",10)
    ...i +$g(ItmEndDate)'=0 s ItmEndDate=$zd(ItmEndDate,3)
    ...q:(+ItmEndDate'=0)&&($h>ItmEndDate)     ;过滤超过使用日期的菜
    ...b ;000
    ...s ItmCode=$p(^DHCIPMEALITEM(MealItemRowID),"^",1)
    ...s ItmDesc=$p(^DHCIPMEALITEM(MealItemRowID),"^",2)
	...s ItmUomID=$p(^DHCIPMEALITEM(MealItemRowID),"^",5)
    ...i ItmUomID'="" s ItmUom=$p($g(^DHCIPMEALUOM(ItmUomID)),"^",2)
    ...i ItmMealTypeID'="" s ItmMealType=$p(^DHCIPMEALTYPE(ItmMealTypeID),"^",2)
	...i ItmMealModalityID'="" s ItmMealModality=$p($g(^DHCIPMEALMODALITY(ItmMealModalityID)),"^",2)
    ...s aliasFlag=0
    ...i mealAlias'="" d
    ....s AliasRowID=0 ,aliasFlag=1
    ....f  S AliasRowID=$o(^DHCIPMEALITEMALIAS(0,"DHCMI",MealItemRowID,AliasRowID))  q:AliasRowID=""  d
    .....s aliasDesc=$p(^DHCIPMEALITEMALIAS(AliasRowID),"^",2)
    .....s:aliasDesc[$ZCVT(mealAlias,"U") aliasFlag=0
    ...q:aliasFlag'=0
    ...s menuItmRowid=MMRowID_"||"_ChildSub	
    ...s rtn=..getOrdItemQtyByAdm(Adm,MenuDate,MealItemRowID,ItmMealTypeID,ItmMealModalityID)
    ...s Qty=$p(rtn,"^",1)
    ...s ItmPrice=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetMenuItmPrice(MealItemRowID,+$h)		
    ...s itmTotalAmount=Qty*ItmPrice			
	...s ItmRemark=$p(^DHCIPMEALITEM(MealItemRowID),"^",12)	
	...d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    i +$g(Qty)=0 s Qty=""
	set Data=$lb(Qty,ItmCode,ItmDesc,ItmMealType,ItmMealModality,ItmUom,ItmRemark,ItmPrice,itmTotalAmount,MealItemRowID,ItmMealTypeID,ItmMealModalityID,ItmUomID,menuItmRowid,mealOrdItemRowid)
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

Query FindMenuItmByDate(MenuDate As %String, MenuModailty As %String, MenuType As %String, Adm As %String, billFlag As %String) As %Query(ROWSPEC = "Qty,itmcode,itmdesc,itmmealtype,itmmealmodality,itmuom,itmremark,itmprice,itmTotalAmount,mealitemrowid,itmmealtypeid,itmmealmodalityid,itmuomid,menuitmrowid,mealOrdItemRowid")
{
}

ClassMethod getOrdItemQtyByAdm(adm, MenuDate, itemRowid, typeRowid, modRowid) As %String
{
	s tmpOrdItemQty=""
	q:adm="" tmpOrdItemQty
	s MealOrdRowID=$o(^DHCIPMEALORDER(0,"Adm",+$g(adm),""))
	q:MealOrdRowID="" tmpOrdItemQty
	s mealOrdItmDr=""
	s subRowid=0
	f  s subRowid=$o(^DHCIPMEALORDER(0,MenuDate,itemRowid,MealOrdRowID,subRowid)) q:subRowid=""  d
	.s tmpOrdItemMealTypeDR=$p(^DHCIPMEALORDER(MealOrdRowID,"I",subRowid),"^",21) ;医嘱中的餐类型
    .q:(tmpOrdItemMealTypeDR'=typeRowid)&&(typeRowid'="")
    .s tmpOrdItemMealModalityDR=$p(^DHCIPMEALORDER(MealOrdRowID,"I",subRowid),"^",22) ;医嘱中的餐态
    .q:(tmpOrdItemMealModalityDR'=modRowid)&&(modRowid'="")
    .s tmpOrdItemBillFlag=$p(^DHCIPMEALORDER(MealOrdRowID,"I",subRowid),"^",17)
    .q:tmpOrdItemBillFlag'="TB" 
    .s tmpOrdItemQty=$p(^DHCIPMEALORDER(MealOrdRowID,"I",subRowid),"^",5)+tmpOrdItemQty
    .s mealOrdItmDr=MealOrdRowID_"||"_subRowid
    q tmpOrdItemQty
    ;q tmpOrdItemQty_"^"_mealOrdItmDr
}

/// @author : wanghc
/// @desc:    拿到病区树节点串
ClassMethod ToWardTreeJson()
{
	;w ##class().
	s wardJson="["
	s wardRowid=0 f  s wardRowid=$o(^PAWARD(wardRowid)) q:wardRowid=""  d
	.s admType=""
	.s roomRowid="" f  s roomRowid=$o(^PAADMi("CurrWard",wardRowid,roomRowid))  q:(roomRowid="")||(admType="I")  d
	..s admRowid="" f  s admRowid=$o(^PAADMi("CurrWard",wardRowid,roomRowid,admRowid)) q:(admRowid="")||(admType="I")  d
	...s patinfo=$g(^PAADM(admRowid))
	...q:patinfo=""
	...s admType=$p(^PAADM(admRowid),"^",2)
	...q:admType'="I"
	...s info=$g(^PAWARD(wardRowid))
	...q:info=""
	...s code=$p(info,"^",1)
	...i wardJson="[" d
	....s wardJson=wardJson_"{id:'Ward-"_wardRowid_"',"_"text:'"_code_"',iconCls:'iconWard',singleClickExpand:true,leaf:false}"
	...e  d
	....s wardJson=wardJson_",{id:'Ward-"_wardRowid_"',"_"text:'"_code_"',iconCls:'iconWard',singleClickExpand:true,leaf:false}"
	q wardJson_"]"
}

/// @author : Lid
/// @desc:    拿到病区树节点串(过滤病区)
ClassMethod ToWardTreeJsonByCTLoc(CTLocDR)
{
	;w ##class(DHCBILL.Diet.DHCIPMealInsertOrder).ToWardTreeJsonByCTLoc(1183)
	s wardJson="["
	s wardRowid=0 f  s wardRowid=$o(^PAWARD(0,"WARD_LocationDR",CTLocDR,wardRowid)) q:wardRowid=""  d
	.b ;222
	.s admType=""
	.;q:((WardDR'="")&(WardDR'=wardRowid))
	.s roomRowid="" f  s roomRowid=$o(^PAADMi("CurrWard",wardRowid,roomRowid))  q:(roomRowid="")||(admType="I")  d
	..s admRowid="" f  s admRowid=$o(^PAADMi("CurrWard",wardRowid,roomRowid,admRowid)) q:(admRowid="")||(admType="I")  d
	...s patinfo=$g(^PAADM(admRowid))
	...q:patinfo=""
	...s admType=$p(^PAADM(admRowid),"^",2)
	...q:admType'="I"
	...s info=$g(^PAWARD(wardRowid))
	...q:info=""
	...s code=$p(info,"^",1)
	...i wardJson="[" d
	....s wardJson=wardJson_"{id:'Ward-"_wardRowid_"',"_"text:'"_code_"',iconCls:'iconWard',singleClickExpand:true,leaf:false}"
	...e  d
	....s wardJson=wardJson_",{id:'Ward-"_wardRowid_"',"_"text:'"_code_"',iconCls:'iconWard',singleClickExpand:true,leaf:false}"
	q wardJson_"]"
}

/// @author: wanghc
/// @param:  wardRowid(病区rowid)
/// @desc:   通过病区rowid拿到叶子json串  ,按时间拿在院人树,订餐的人会有logo
ClassMethod ToPaadmByWardTreeJson(wardRowid, bookDate)
{
	s bookDate=$zdh(bookDate,3)
	q:+wardRowid=0 "[]"
	//s treeNodeCls="x-tree-node"
	s paadmTreeJson="["
	s roomRowid="" f  s roomRowid=$o(^PAADMi("CurrWard",wardRowid,roomRowid))  q:roomRowid=""  d
	.s rowid="" f  s rowid=$o(^PAADMi("CurrWard",wardRowid,roomRowid,rowid)) q:rowid=""  d
	..s patinfo=$g(^PAADM(rowid))
	..q:patinfo=""
	..s admType=$p(^PAADM(rowid),"^",2)
	..q:admType'="I"
	..s VisitStatus = $p(^PAADM(rowid),"^",20)
	..q:VisitStatus'="A" 
	..s dischgDate = $p(^PAADM(rowid),"^",17)
	..s flag=0
	..s:dischgDate'="" flag=(bookDate>dischgDate)
	..q:flag			;add by wanghc 2010-12-21   小于出院时间
	..s CurrentBedDR=$p(^PAADM(rowid),"^",73)
	..s CurrentBed=""
	..s:CurrentBedDR'="" CurrentBed=$p(^PAWARD(+CurrentBedDR,"BED",$p(CurrentBedDR,"||",2)),"^",1)
	..s mealOrdItem=""
	..s mealOrder=$o(^DHCIPMEALORDER(0,"Adm",rowid,0))
	..s:mealOrder'="" mealOrdItem=$o(^DHCIPMEALORDER(0,"StartDate",bookDate,mealOrder,0))
	..s papmidr=+$p(^PAADM(rowid),"^",1)
	..s name=$p(^PAPER(papmidr,"ALL"),"^",1)
	..;Lid 2010-05-26 设置男、女的显示图片
	..s sexDr=$p(^PAPER(papmidr,"ALL"),"^",7) 
	..i sexDr'="" s sex=$p(^CT("SEX",sexDr),"2")
	..i ($g(sex)["男") s iconPerson="iconM"
	..e  i ($g(sex)["女") s iconPerson="iconF"
	..e  s iconPerson="iconM"
	..s medicare=$p(^PAPER(papmidr,"PAT",1),"^",22)
	..i medicare'="" d 
	...s info=name_"("_CurrentBed_")"
	..e  d
	...s info=name_"("_CurrentBed_")"
	..i mealOrdItem'="" s iconJson="',iconCls:'bookedmeal"  //已点餐的加logo
	..e  s iconJson=""
	..i paadmTreeJson="[" d
	...s paadmTreeJson=paadmTreeJson_"{id:'PAPER-"_papmidr_"',text:'"_info_iconJson_"',singleClickExpand:true,leaf:true}"
	..e  d
	...s paadmTreeJson=paadmTreeJson_",{id:'PAPER-"_papmidr_"',text:'"_info_iconJson_"',singleClickExpand:true,leaf:true}"
	q paadmTreeJson_"]"
}

/// Lid
/// 2012-03-08
/// 判断病人是否有膳食医嘱
ClassMethod CheckDietOrder(EpisodeID, Date)
{
	s rtn=0
	s OEORD=$o(^OEORD(0,"Adm",+EpisodeID,""))
	q:+OEORD=0 1
}

/// *@desc:菜别json
ClassMethod ToMealTypeJson()
{
	s mealTypeJson="{rows:["
	s rowid=0
	f  s rowid=$o(^DHCIPMEALTYPE(rowid)) q:rowid=""  d
	.s desc=$p(^DHCIPMEALTYPE(rowid),"^",2)
	.i mealTypeJson="{rows:[" d
	..s mealTypeJson=mealTypeJson_"{mealTypeRowid:"_rowid_",mealTypeDesc:'"_desc_"'}"
	.e  d
	..s mealTypeJson=mealTypeJson_",{mealTypeRowid:"_rowid_",mealTypeDesc:'"_desc_"'}"
	q mealTypeJson_"]}"
}

/// @desc:餐谱形态json
ClassMethod ToMealModalityJson()
{
	s mealModalityJson = "{rows:["
	s rowid=0 f  s rowid=$o(^DHCIPMEALMODALITY(rowid)) q:rowid=""  d
	.s desc=$p(^DHCIPMEALMODALITY(rowid),"^",2)
	.i mealModalityJson="{rows:[" d
	..s mealModalityJson=mealModalityJson_"{mealModalityRowid:"_rowid_",mealModalityDesc:'"_desc_"'}"
	.e  d
	..s mealModalityJson=mealModalityJson_",{mealModalityRowid:"_rowid_",mealModalityDesc:'"_desc_"'}"
	q mealModalityJson_"]}"
}

/*
/// 只辙消当天的帐单，
/// 没有改变帐单,只是停医嘱，并加入一条TB的新医嘱,当帐单时会自动冲红
ClassMethod cancelBill(admRowid As %String, userRowid As %String, date As %String) As %String
{
	Tstart	
	s err=0
	s date=$zdh(date,3)
	s bill=$o(^DHCIPMEALBILL(0,"Adm",admRowid,"0")) 
	s VisitStatus="B"
	;s hisOrdBilledFlag="I" ///his端没有停
	s subBillRowid=0 f  s subBillRowid=$o(^DHCIPMEALBILL(bill,"D",subBillRowid)) q:(subBillRowid="")||(VisitStatus'="A")  d
	.s updateDate=$p(^DHCIPMEALBILL(bill,"D",subBillRowid),"^",7)
	.q:updateDate'=date
	.s hisOrdItemRowid=$p(^DHCIPMEALBILL(bill,"D",subBillRowid),"^",9)
	.s subRowid=$p(hisOrdItemRowid,"||",2)
	.s hisOrdBilledFlag=$p(^OEORD(+hisOrdItemRowid,"I",subRowid,3),5)
	.s VisitStatus = $p(^PAADM(admRowid),"^",20)
	.q:VisitStatus'="A" 
	.;s:hisOrdBilledFlag'="I" err="111111"  ;his端没有停
	.;q:hisOrdBilledFlag'="I"
	.D ##Class(web.DHCOEOrdItem).Stop(hisOrdItemRowid,userRowid) 
	.d ..cancelBillByHisOrdItem(hisOrdItemRowid)
	.s totalAmount=$p(^DHCIPMEALBILL(bill,"D",subBillRowid),"^",4)
	.q:totalAmount<0
	.//;停医嘱,无论有没有导到his端都停 ，有导到his端，但his端的医嘱没有停时前面跳出
	.s orderItemRowid=$p(^DHCIPMEALBILL(bill,"D",subBillRowid),"^",1)
	.S err=##Class(DHCBILL.Diet.DHCIPMealInsertOrder).stopOrderItem(orderItemRowid)
	..q:err'=0 
	.s err=##class(DHCBILL.Diet.DHCIPMealInsertOrder).InsertOrderByOrdItemRowid(orderItemRowid)
	..q:err'=0
	
	i err'=0 d
	.tro
	e  tcommit
	q err
}

/// his端如果停止伙食费这条医嘱 膳食端也停医嘱，再增加一条一样的医嘱
ClassMethod cancelBillByHisOrdItem(hisOrdItemRowid As %String) As %String
{
	s $ZT="ERROR^DHCSSERR" Tstart	
	q:hisOrdItemRowid="" "11111"
	s subRowid=$p(hisOrdItemRowid,"||",2)
	s hisOrdBilledFlag=$p(^OEORD(+hisOrdItemRowid,"I",subRowid,3),5)
	q:hisOrdBilledFlag'="I" "111111"   ///his端没有停
	s err=0
	s billRowid =$o(^DHCIPMEALBILL(0,"OEORI",hisOrdItemRowid,"0"))
	s billDetailRowid=0 
	f billDetailRowid=$o(^DHCIPMEALBILL(0,"OEORI",hisOrdItemRowid,billRowid,billDetailRowid)) q:(billDetailRowid="")||(err'=0)  d
	.//d ##class(DHCBILL.Diet.DHCIPMealFeeBill).strikeDetail(billRowid_"||"_billDetailRowid) 
	.s totalAmount=$p(^DHCIPMEALBILL(billRowid,"D",billDetailRowid),"^",4)
	.q:totalAmount<0
	.s orderItemRowid=$p(^DHCIPMEALBILL(billRowid,"D",billDetailRowid),"^",1)
	.S err=##Class(DHCBILL.Diet.DHCIPMealInsertOrder).stopOrderItem(orderItemRowid)
	..q:err'=0 
	.s err=##class(DHCBILL.Diet.DHCIPMealInsertOrder).InsertOrderByOrdItemRowid(orderItemRowid)
	..q:err'=0
	i err'=0 d
	.tro
	e   tcommit
	q err
}
*/
}
