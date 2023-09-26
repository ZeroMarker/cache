Class web.UDHCJFBillDetail Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// do ##class(web.UDHCJFBillDetail).SetPBDetail(224373,"","")
ClassMethod SetPBDetail(BillNo As %String, stdate As %String = "", endate As %String = "", tarCateDr = "")
{
	kill ^mtemp($j,"BillDetail")
	set mealTotalAmount=0, AdmRowId=0
  	set motheradm=$p(^DHCPB(BillNo),"^",1)
  	set allsum=0, sum=0
  	set pboSub=0
	for  set pboSub=$o(^DHCPB(BillNo,"O",pboSub)) quit:(+pboSub=0)  do
	.quit:($d(^DHCPB(BillNo,"O",pboSub))=10)
  	.set oerowid=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",4)   //yyx 判断医嘱不存在，则过滤掉
  	.set oeadm=+$p(^OEORD(+oerowid),"^",1)
  	.set oeorderid=$p(oerowid,"||",1)
  	.set AdmRowId=oeadm
  	.set Admreasomdr=$p(^PAADM(AdmRowId,1),"^",7)
  	.set arcimid=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",3)
  	.quit:(arcimid="")
  	.set myItemCat=0
  	.set itemcat=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),1),"^",10)
	.if ($d(^DHCJFORDITEMCATSET(0,"ItemCat",itemcat))) do
  	..set myItemCat=1
  	.set OEExecRowID=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",20)
  	.set OEExcStDate=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",1)
  	.set OEExcXDate=$p(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3)),"^",12)
  	.quit:((myItemCat=1)&&(stdate'="")&&(OEExcStDate<stdate))
  	.quit:((myItemCat=1)&&(endate'="")&&(OEExcStDate>endate))
  	.if tarCateDr'="" set myItemCat=0      //2016-02-03 Lid 如果按住院分类查询时，不按医嘱查，只能按收费项目查
  	.if (myItemCat=1) do
  	..do ..GetOrder(BillNo, pboSub, arcimid, itemcat, AdmRowId, Admreasomdr)
  	.else  do
  	..do ..GetDetail(BillNo, pboSub, arcimid, AdmRowId, stdate, endate, tarCateDr, Admreasomdr, OEExcStDate, OEExcXDate)
  
	quit
}

ClassMethod GetOrder(BillNo, pboSub, arcimid, itemcat, AdmRowId, Admreasomdr)
{
	set ordcatid=$p(^ARC("IC",itemcat),"^",8)
  	set ordcatdesc=$p(^OEC("ORCAT",ordcatid),"^",2)
  	set orddesc=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),1),"^",2)
  	set PhInfo=..getdrginfo(arcimid)
  	set PhcfDesc=$p(PhInfo,"^",1)
  	set PhmnfName=$p(PhInfo,"^",2)
	set oeitm=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",4)
  	set ordbillqty=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",5)
  	set ordrefqty=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",6)
	set ordprice=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",7)
	set ordprice=$fn(ordprice,"",4)
  	set ordqty=ordbillqty+ordrefqty
  	set ordtot=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",8)
	set uomDesc=##class(web.DHCBillCommon).GetBaseUom(arcimid, oeitm)
  	set getinsuStr=##class(web.DHCINSUPort).ArcimLinkInsu(arcimid, Admreasomdr)
  	set XMLB=$p(getinsuStr,"^",1)
  	if (XMLB<0) set XMLB=""
  	if (XMLB=1) set XMLB="甲类"
  	if (XMLB=2) set XMLB="乙类"
  	if (XMLB=3) set XMLB="丙类"
  	
	set $p(^mtemp($j,"BillDetail","itemCat",AdmRowId,itemcat,arcimid,ordprice),"^",1)=$p($g(^mtemp($j,"BillDetail","itemCat",AdmRowId,itemcat,arcimid,ordprice)),"^",1)+ordqty
	set $p(^mtemp($j,"BillDetail","itemCat",AdmRowId,itemcat,arcimid,ordprice),"^",2)=$p($g(^mtemp($j,"BillDetail","itemCat",AdmRowId,itemcat,arcimid,ordprice)),"^",2)+ordtot
	set $p(^mtemp($j,"BillDetail","itemCat",AdmRowId,itemcat,arcimid,ordprice),"^",3)=arcimid
	set $p(^mtemp($j,"BillDetail","itemCat",AdmRowId,itemcat,arcimid,ordprice),"^",4)=uomDesc
	set $p(^mtemp($j,"BillDetail","itemCat",AdmRowId,itemcat,arcimid,ordprice),"^",5)=AdmRowId
	set $p(^mtemp($j,"BillDetail","itemCat",AdmRowId,itemcat,arcimid,ordprice),"^",8)=PhcfDesc
	set $p(^mtemp($j,"BillDetail","itemCat",AdmRowId,itemcat,arcimid,ordprice),"^",9)=PhmnfName
	set $p(^mtemp($j,"BillDetail","itemCat",AdmRowId,itemcat,arcimid,ordprice),"^",10)=XMLB
  
  	quit
}

ClassMethod GetDetail(BillNo, pboSub, arcimid, AdmRowId, stdate, endate, tarCateDr = "", Admreasomdr, ExcStDate, ExcXDate)
{
	set PhInfo=..getdrginfo(arcimid)
	set PhcfDesc=$p(PhInfo,"^",1)
 	set PhmnfName=$p(PhInfo,"^",2)
  	
	set oeitm=$p($g(^DHCPB(+BillNo,"O",pboSub)),"^",4)
	set CP=##class(web.UDHCJFDayDetail).GetCP(oeitm)
  
	set pbdSub=0
	for  set pbdSub=$o(^DHCPB(BillNo,"O",pboSub,"D",pbdSub)) quit:(+pbdSub=0)  do
	.set pbdstr=$G(^DHCPB(BillNo,"O",pboSub,"D",pbdSub))
	.set billdate=$p(pbdstr,"^",11), billtime=$p(pbdstr,"^",12), billstatus=$p(pbdstr,"^",14)  //yyx 06-12-07
	.if ((CP="OD")&&(ExcStDate>ExcXDate)&&(+ExcXDate'=0)) set billdate=ExcStDate 
	.quit:((stdate'="")&&(billdate<stdate))
 	.quit:((endate'="")&&(billdate>endate))
	.set tariId=$p($g(pbdstr),"^",3)    //PBD_TARI_DR,指向DHC_TarItem
	.quit:(+tariId=0)||('$d(^DHCTARI(tariId)))
  	.set tariUom=$p($g(^DHCTARI(tariId)),"^",3)
  	.if (tariUom="") set uomDesc=""
  	.else  set uomDesc=$p($g(^CT("UOM",tariUom)),"^",2)
  	.set taridesc=$p(^DHCTARI(tariId),"^",2)
  	.set price=$p(pbdstr,"^",4)           //PBD_UnitPrice
  	.set qty=$p(pbdstr,"^",5)             //PBD_BillQty
  	.set total=$p(pbdstr,"^",7)
  	.quit:(+total=0)
  	.set tarcId=$p($g(^DHCTARI(tariId)),"^",14)       //TARI_InpatCate,指向DHC_TarInpatCate
  	.set taricId=$p($g(^DHCTarC("IC",tarcId)),"^",3)  //TARIC_TARTIC_DR
  	.set taricDesc=$p(^DHCTarC("TIC",taricId),"^",2)
  	.quit:((tarCateDr'="")&&(tarCateDr'=taricId))
  	.set admReasonDr=$p(^DHCPB(BillNo),"^",4)
  	.set nationalCode=+$p(^PAC("ADMREA",admReasonDr),"^",5)
  	.set zfbl=0, grzf=0
  	.if (+nationalCode>0) do
  	..set ybInfo=##class(web.DHCINSUPort).PBDLinkInsu(BillNo_"||"_pboSub_"||"_pbdSub)
  	..set zfbl=$p($g(ybInfo),"^",1)      //自付比例
  	..set grzf=+$p($g(ybInfo),"^",2)     //个人自费
  	.set getinsustr=##class(web.DHCINSUPort).TarItmLinkInsu(tariId, Admreasomdr, "", AdmRowId, price)
  	.set XMLB=$p(getinsustr,"^",1)
  	.if (XMLB=1) set XMLB="甲类"
  	.if (XMLB=2) set XMLB="乙类"
  	.if (XMLB=3) set XMLB="丙类"
  	.set price=$fn(price,"",4)
	.set $p(^mtemp($j,"BillDetail","IPCat",AdmRowId,taricId,tariId,price),"^",1)=$p($g(^mtemp($j,"BillDetail","IPCat",AdmRowId,taricId,tariId,price)),"^",1)+qty
	.set $p(^mtemp($j,"BillDetail","IPCat",AdmRowId,taricId,tariId,price),"^",2)=$p($g(^mtemp($j,"BillDetail","IPCat",AdmRowId,taricId,tariId,price)),"^",2)+total
	.set $p(^mtemp($j,"BillDetail","IPCat",AdmRowId,taricId,tariId,price),"^",3)=arcimid
 	.set $p(^mtemp($j,"BillDetail","IPCat",AdmRowId,taricId,tariId,price),"^",4)=uomDesc
	.set $p(^mtemp($j,"BillDetail","IPCat",AdmRowId,taricId,tariId,price),"^",5)=AdmRowId
	.set $p(^mtemp($j,"BillDetail","IPCat",AdmRowId,taricId,tariId,price),"^",6)=$p($g(^mtemp($j,"BillDetail","IPCat",AdmRowId,taricId,tariId,price)),"^",6)+zfbl
	.set $p(^mtemp($j,"BillDetail","IPCat",AdmRowId,taricId,tariId,price),"^",7)=$p($g(^mtemp($j,"BillDetail","IPCat",AdmRowId,taricId,tariId,price)),"^",7)+grzf
	.set $p(^mtemp($j,"BillDetail","IPCat",AdmRowId,taricId,tariId,price),"^",8)=PhcfDesc
	.set $p(^mtemp($j,"BillDetail","IPCat",AdmRowId,taricId,tariId,price),"^",9)=PhmnfName
	.set $p(^mtemp($j,"BillDetail","IPCat",AdmRowId,taricId,tariId,price),"^",10)=XMLB
  
  	quit
}

Query FindBillDetail(BillNo As %String, stdate As %String, endate As %String, traic As %String = "") As websys.Query(ROWSPEC = "Ttaridesc:%String,Torder:%String,Tuom:%String,Tunitprice:%String,Tqty:%String,Tprice:%String,Tjob:%String,Tybdesc:%String,PhcfDesc:%String,PhmnfName:%String,BillNo:%String,tariID:%String,TtariChargeBasis:%String")
{
}

/// do ##class(%ResultSet).RunQuery("web.UDHCJFBillDetail","FindBillDetail","253061","","","")
ClassMethod FindBillDetailExecute(ByRef qHandle As %Binary, BillNo As %String, stdate As %String, endate As %String, traic As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindBillDetail")=$lb(BillNo, stdate, endate, traic)
	set sum=0, discount=0, payorshare=0, patshare=0, tarisum=0
	kill ^TMP("ZYJF",BillNo,$j)
	
	set ^TMP("ZYJF",BillNo,$j)=##class(websys.Conversions).DateLogicalToHtml(stdate)_"至"_##class(websys.Conversions).DateLogicalToHtml($s((endate=""):+$h,1:endate))
	
	do ..SetPBDetail(BillNo, stdate, endate, traic)
	set motheradm=$p(^DHCPB(BillNo),"^",1)
	set Conf=$O(^DHCTarC("CF",""))
	if (($d(^PAADMi("Mother",motheradm))'=0)&&($p(^DHCTarC("CF",Conf),"^",5)="Y")) do
	.do ..OutPutBillDetailInBaby(BillNo, motheradm)
	.//do ..OutPutBillDetail(BillNo)
	else  do
	.do ..OutPutBillDetail(BillNo)
	
	quit $$$OK
}

ClassMethod GetAge(curDate, dob)
{
	;根据时间和出生时间计算年龄?不满1岁显示月数?不满1月的显示日数?
	q:dob="" ""
	i curDate="" q ""
	s age=curDate-dob
	s months=$p(curDate,"-",2)-$p(dob,"-",2)
	s days=$p(curDate,"-",3)-$p(dob,"-",3)
	i months*100+days<0 s age=age-1
	i age>0 q age
	i age<0 q ""
	i days<0 s months=months-1
	i (curDate-dob=1)&(months<0) s months=months+12
	i months>0 q months_"月"
	i months<0 q ""
	s days= $zdh(curDate,3)-$zdh(dob,3)
	i days>0 q days_"日"
	q ""
}

ClassMethod getpatinfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
	set err=..GetBillInfo(val) 
	quit err
}

ClassMethod GetBillInfo(pbId)
{
	q:pbId="" ""
	s admId=$p(^DHCPB(pbId),"^",1)
	s papmiId=$p(^PAADM(admId),"^",1)
	s disDeptId=$p(^PAADM(admId),"^",4)
	s admDate=$p(^PAADM(admId),"^",6)
	s disDate=$p(^PAADM(admId),"^",17)
	s regNo=$p(^PAPER(papmiId,"PAT",1),"^",1)
	s name=$p(^PAPER(papmiId,"ALL"),"^",1)
	s dob=$p(^PAPER(papmiId,"ALL"),"^",6)
	s sex=$p(^PAPER(papmiId,"ALL"),"^",7)
	i sex'="" s sex=$p(^CT("SEX",sex),"^",2)
	s stname=^PAPER(papmiId,"PER","ADD",1) 
	s transSub="",stime=1,regLocId=""
	f  s transSub=$o(^PAADM(admId,"TRANS",transSub)) q:transSub=""  d
	.s transStr=^PAADM(admId,"TRANS",transSub)
	.q:($p(transStr,"^",12)>5)!($p(transStr,"^",12)<3)
	.q:$p(transStr,"^",6)=""
	.s ctime=$p(transStr,"^",1)_$p(transStr,"^",2)
	.i ctime>stime s stime=ctime,regLocId=$p(transStr,"^",6)
	s durDates=disDate-admDate
	i dob'="" s dob=$zd(dob,3)
	s dateTo=$zd(+$h,3) ;i dateTo'="" s dateTo=$zd(dateTo,3)
	i admDate'="" s admDate=$zd(admDate,3)
	i disDate'="" s disDate=$zd(disDate,3)
	i disDate'="" s age=..GetAge(disDate,dob)
	e  s age=..GetAge(admDate,dob)
	i dob="" s dob="未登记"
	i disDate="" s disDate=$zd(+$h,3)
	s indays=$zdh(disDate,3)-$zdh(admDate,3)
	s regLocDesc=..GetLocDesc(regLocId)
	s disDeptDesc=..GetLocDesc(disDeptId)
	i disDeptDesc["-" s disDeptDesc=$p(disDeptDesc,"-",2)
	s resStr=regNo_"^"_name_"^"_sex_"^"_dob_"^"_age_"^"_regLocDesc_"^"_admDate_"^"_disDeptDesc_"^"_disDate_"^"_dateTo_"^"_stname_"^"_indays
	q resStr
}

/// 根据科室ID取科室名称
ClassMethod GetLocDesc(locId)
{
	new (locId)
	quit:(locId="") ""
	set locDesc=$p(^CTLOC(locId),"^",2)
	if (locDesc["-") set locDesc=$p(locDesc,"-",2)
	quit locDesc
}

ClassMethod GetNum(itmjs As %Library.String = "", itmjsex As %Library.String = "", BillNo, job)
{
	set admrowid=$p(^DHCPB(BillNo),"^",1)
	set gnum=$o(^TMP("ZYJF",BillNo,job,admrowid,""),-1)
	quit gnum
}

ClassMethod List(itmjs As %Library.String = "", itmjsex As %Library.String = "", BillNo, job, gnum)
{
	set admrowid=$p(^DHCPB(BillNo),"^",1)
	set str=^TMP("ZYJF",BillNo,job,admrowid,gnum)
	quit str
}

ClassMethod getpatinfodetail(itmjs As %Library.String = "", itmjsex As %Library.String = "", BillNo)
{
  	quit:(BillNo="") ""
  	set admId=$p(^DHCPB(BillNo),"^",1)
  	set papmiId=$p(^PAADM(admId),"^",1)
  	set painfo=##class(web.UDHCJFBaseCommon).GetPatAdmInfo(admId,papmiId,BillNo)
  	set patfee=##class(web.UDHCJFBaseCommon).GetAdmDepositAndFeeByBillNo(admId,BillNo)
  	quit painfo_"^"_patfee
}

/// CreatDate: 2011-09-06
/// Creator: wangjian
/// Description: 新需求要在打印费用明细里添加剂型和产地
/// Input: 医嘱项Rowid
ClassMethod getdrginfo(itemrowid As %String) As %String
{
 	s Subscript=+itemrowid
 	s Version=$p(itemrowid,"||",2)
 	s PhcdfDr=$p(^ARCIM(Subscript,Version,1),"^",12)
 	q:(PhcdfDr="") "^"
 	s DrgMast=+PhcdfDr
 	s PHCDFSub=$p(PhcdfDr,"||",2)
 	s PhcfDr=$p($g(^PHCD(DrgMast,"DF",PHCDFSub,1)),"^",1)          //指向表phc_form
 	s PhcfDesc=$s((+PhcfDr'=0):$p($g(^PHCF(PhcfDr)),"^",2),1:"")
 	s PhmnfDr=$p($g(^PHCD(DrgMast,2)),"^",4)                       //phc_drgmast
	s PhmnfName=$s((+PhmnfDr'=0):$p(^PHMNF(PhmnfDr),"^",2),1:"")   //产地
	 	
 	q PhcfDesc_"^"_PhmnfName
}

ClassMethod OutPutBillDetail(BillNo)
{
	s admReasonmydr=$p(^DHCPB(BillNo),"^",4)
	s gnum=0,curid=0,all=0,blzfSum=0,grzfSum=0
	s count=0,sumall=0,count1=0
	s cat=""
	f  s cat=$o(^mtemp($j,"BillDetail",cat)) q:(cat="")  d   //区分是打印收费项目还是医嘱项
	.s AdmRowId=""
	.f  s AdmRowId=$o(^mtemp($j,"BillDetail",cat,AdmRowId)) q:(AdmRowId="")  d
	..s taricID=""
	..f  s taricID=$o(^mtemp($j,"BillDetail",cat,AdmRowId,taricID)) q:(taricID="")  d  //分类Id
	...s oldtaricDesc="",tarisum=0,tariblzfSum=0,tarigrzfSum=0
	...s tariID=""
	...f  s tariID=$o(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID)) q:(tariID="")  d        //项目ID
	....s price=""
	....f  s price=$o(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price)) q:(price="")  d   //金额
	.....i (cat="IPCat") d
	......s taricDesc=$p(^DHCTarC("TIC",taricID),"^",2)
	......s tariDesc=$p(^DHCTARI(tariID),"^",2)
	......s tariChargeBasis=$p(^DHCTARI(tariID),"^",20)    //取物价编码
	.....i (cat="itemCat") d
	......s taricDesc=$p(^ARC("IC",taricID),"^",2)
	......//s taricDesc=$p(^OEC("ORCAT",ordcatid),"^",2)
	......s tariDesc=$p(^ARCIM(+tariID,$p(tariID,"||",2),1),"^",2)
	......s tariChargeBasis=""
	.....s uomDesc=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",4)          //单位
	.....s qty=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",1)
	.....q:(+qty=0)
	.....s sum=$fn($p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",2),"",2)
	.....s tarisum=tarisum+sum
	.....s all=all+sum
	.....s sumall=sumall+$fn($p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",2),"",2)
	.....s myArcimId=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",3)
	.....s myArcimId=$p(myArcimId,$c(1))
	.....s DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(myArcimId)
	.....s:(DrugCommonDesc'="") tariDesc=DrugCommonDesc
	.....s drugspec=##class(web.UDHCJFCOMMON).GetDrugSpec(myArcimId)
	.....i (drugspec'="")  d
	......s tariDesc=tariDesc_"("_drugspec_")"
	.....s myblzf=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",6)
	.....s mygrzf=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",7)
	.....s tariblzfSum=tariblzfSum+myblzf,tarigrzfSum=tarigrzfSum+mygrzf
	.....s blzfSum=blzfSum+myblzf,grzfSum=grzfSum+mygrzf
	.....s PhcfDesc=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",8)
	.....s PhcfDesc=$p(PhcfDesc,$c(13))
	.....s PhmnfName=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",9)
	.....s ybdesc=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",10)
	.....d OutputRow
	.....s gnum=gnum+1
	...s taricDesc="小计",tariDesc="",uomDesc="",price="",qty="",sum=$fn(tarisum,"",2),ybdesc="",PhcfDesc="",PhmnfName="",tariChargeBasis=""
	...s myblzf=$fn(tariblzfSum,"",2),mygrzf=$fn(tarigrzfSum,"",2)
	...q:(+sum=0)
	...d OutputRow
	s taricDesc="合计",tariDesc="",uomDesc="",price="",qty="",sum=$fn(sumall,"",2),ybdesc="" ,PhcfDesc="",PhmnfName="",tariChargeBasis=""
	s myblzf=$fn(blzfSum,"",2),mygrzf=$fn(grzfSum,"",2)  ;医保比例自负，个人自费
	s gnum=gnum+1                                                               
	d OutputRow
	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow
	set:(+myblzf=0) myblzf=""
	set:(+mygrzf=0) mygrzf=""
	if ((taricDesc'="小计")&&(taricDesc'="合计")) do
	.set count=count+1
	.set ^TMP("ZYJF",BillNo,$j,AdmRowId,count)=taricDesc_"^"_tariDesc_"^"_uomDesc_"^"_price_"^"_qty_"^"_sum_"^"_myblzf_"^"_mygrzf_"^"_PhcfDesc_"^"_PhmnfName_"^"_taricID
	//set ^TMP("ZYJF",BillNo,$j,ind)=taricDesc_"^"_tariDesc_"^"_uomDesc_"^"_price_"^"_qty_"^"_sum_"^"_myblzf_"^"_mygrzf_"^"_PhcfDesc_"^"_PhmnfName
	set Data=$lb(taricDesc,tariDesc,uomDesc,price,qty,sum,$j,ybdesc,PhcfDesc,PhmnfName,BillNo,tariID,tariChargeBasis)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

ClassMethod OutPutBillDetailInBaby(BillNo, motheradm)
{
	s admReasonmydr=$p(^DHCPB(BillNo),"^",4)
	s curid=0,all=0,blzfSum=0,grzfSum=0
	s count=0,sumall=0,count1=0
	s cat=""
	f  s cat=$o(^mtemp($j,"BillDetail",cat)) q:(cat="")  d   //区分是打印收费项目还是医嘱项
	.s AdmRowId=""
	.f  s AdmRowId=$o(^mtemp($j,"BillDetail",cat,AdmRowId)) q:(AdmRowId="")  d
	..q:(AdmRowId'=motheradm)
	..s taricID=""
	..f  s taricID=$o(^mtemp($j,"BillDetail",cat,AdmRowId,taricID)) q:(taricID="")  d  //分类Id
	...s oldtaricDesc="",tarisum=0,tariblzfSum=0,tarigrzfSum=0
	...s tariID=""
	...f  s tariID=$o(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID)) q:(tariID="")  d  //项目ID
	....s price=""
	....f  s price=$o(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price)) q:(price="")  d  //金额
	.....s ExternalCode=""
	.....i (cat="IPCat") d
	......s taricDesc=$p(^DHCTarC("TIC",taricID),"^",2)
	......s tariID1=$p(tariID,"*",1)
	......s tariDesc=$p(^DHCTARI(tariID1),"^",2)
	......s tariCode=$p(^DHCTARI(tariID1),"^",1)
	......s InsuName=$p(^DHCTARI(tariID1),"^",18)	      //取医保名称
	......s ExternalCode=$p(^DHCTARI(tariID1),"^",13)
	......s ybdesc=$p(tariID,"*",2)
	......s tariChargeBasis=$p(^DHCTARI(tariID),"^",20)    //取物价编码
	.....i (cat="itemCat") d
	......s tariID1=$p(tariID,"*",1)
	......s taricDesc=$p(^ARC("IC",taricID),"^",2)
	......s tariDesc=$p(^ARCIM(+tariID1,$p(tariID1,"||",2),1),"^",2)
	......s tariCode=$p(^ARCIM(+tariID1,$p(tariID1,"||",2),1),"^",1)
	......s ybdesc=$p(tariID,"*",2)
	......s InsuName=""
	......s tariChargeBasis=""
	.....s uomDesc=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",4)          //单位
	.....s qty=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",1)
	.....q:(+qty=0)
	.....s sum=$fn($p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",2),"",2)
	.....s tarisum=tarisum+sum
	.....s all=all+sum
	.....s sumall=sumall+$fn($p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",2),"",2)
	.....s myArcimId=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",3)
	.....s myArcimId=$p(myArcimId,$c(1))
	.....s DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(myArcimId)
	.....s:(DrugCommonDesc'="") tariDesc=DrugCommonDesc
	.....s drugspec=##class(web.UDHCJFCOMMON).GetDrugSpec(myArcimId)
	.....i (drugspec'="")  d
	......s tariDesc=tariDesc_"("_drugspec_")"
	.....s myblzf=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",6)
	.....s mygrzf=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",7)
	.....s tariblzfSum=tariblzfSum+myblzf,tarigrzfSum=tarigrzfSum+mygrzf
	.....s blzfSum=blzfSum+myblzf,grzfSum=grzfSum+mygrzf
	.....s PhcfDesc=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",8)
	.....s PhcfDesc=$p(PhcfDesc,$c(13))
	.....s PhmnfName=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",9)
	.....s ybdesc=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",10)
	.....d OutputRowInBaby
	...s taricDesc="小计",tariDesc="",uomDesc="",price="",qty="",sum=$fn(tarisum,"",2),ybdesc="",PhcfDesc="",PhmnfName="",tariCode="",ExternalCode="",tariChargeBasis=""
	...s myblzf=$fn(tariblzfSum,"",2),mygrzf=$fn(tarigrzfSum,"",2)
	...q:(+sum=0)
	...d OutputRowInBaby
	s taricDesc="母亲合计",tariDesc="",uomDesc="",price="",qty="",sum=$fn(sumall,"",2) ,PhcfDesc="",PhmnfName="",tariCode="",ExternalCode="",tariChargeBasis=""
	s myblzf=$fn(blzfSum,"",2),mygrzf=$fn(grzfSum,"",2),ybdesc="" ;医保比例自负，个人自费
	d OutputRowInBaby
	
	s count=0,sumall=0,count1=0
	s cat=""
	f  s cat=$o(^mtemp($j,"BillDetail",cat)) q:(cat="")  d       //区分是打印收费项目还是医嘱项
	.s AdmRowId=""
	.f  s AdmRowId=$o(^mtemp($j,"BillDetail",cat,AdmRowId)) q:(AdmRowId="")  d
	..q:$d(^DHCOPIPADMCON("OPAdm",AdmRowId))
	..q:(AdmRowId=motheradm)
	..q:'$d(^PAADMi("Mother",motheradm,AdmRowId))
	..s taricID=""
	..f  s taricID=$o(^mtemp($j,"BillDetail",cat,AdmRowId,taricID)) q:(taricID="")  d  ;分类Id
	...s oldtaricDesc="",tarisum=0,tariblzfSum=0,tarigrzfSum=0
	...s tariID=""
	...f  s tariID=$o(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID)) q:tariID=""  d  ;项目ID
	....s price=""
	....f  s price=$o(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price)) q:price=""  d  ;金额
	.....i (cat="IPCat") d
	......s taricDesc=$p(^DHCTarC("TIC",taricID),"^",2)
	......s tariID1=$p(tariID,"*",1)
	......s tariDesc=$p(^DHCTARI(tariID1),"^",2)
	......s tariCode=$p(^DHCTARI(tariID1),"^",1)
	......s InsuName=$p(^DHCTARI(tariID1),"^",18)	;取医保名称
	......s ybdesc=$p(tariID,"*",2)
	.....i (cat="itemCat") d
	......s tariID1=$p(tariID,"*",1)
	......s taricDesc=$p(^ARC("IC",taricID),"^",2)
	......s tariDesc=$p(^ARCIM(+tariID1,$p(tariID1,"||",2),1),"^",2)
	......s tariCode=$p(^ARCIM(+tariID1,$p(tariID1,"||",2),1),"^",1)
	......s ybdesc=$p(tariID,"*",2)
	......s InsuName=""
	.....s uomDesc=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",4)          //单位
	.....s qty=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",1)
	.....q:(+qty=0)
	.....s sum=$fn($p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",2),"",2)
	.....s tarisum=tarisum+sum
	.....s all=all+sum
	.....s sumall=sumall+$fn($p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",2),"",2)
	.....s myArcimId=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",3) ;
	.....s myArcimId=$p(myArcimId,$c(1))
	.....s DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(myArcimId)
	.....s:(DrugCommonDesc'="") tariDesc=DrugCommonDesc 
	.....s drugspec=##class(web.UDHCJFCOMMON).GetDrugSpec(myArcimId)
	.....i (drugspec'="") d
	......s tariDesc=tariDesc_"("_drugspec_")"
	.....s myblzf=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",6)
	.....s mygrzf=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",7)
	.....s tariblzfSum=tariblzfSum+myblzf,tarigrzfSum=tarigrzfSum+mygrzf
	.....s blzfSum=blzfSum+myblzf,grzfSum=grzfSum+mygrzf
	.....s PhcfDesc=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",8)
	.....s PhcfDesc=$p(PhcfDesc,$c(13))
	.....s PhmnfName=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",9)
	.....s ybdesc=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",10)
	.....d OutputRowInBaby
	...s taricDesc="小计",tariDesc="",uomDesc="",price="",qty="",sum=$fn(tarisum,"",2),ybdesc="",PhcfDesc="",PhmnfName="",tariCode="",ExternalCode="",tariChargeBasis=""
	...s myblzf=$fn(tariblzfSum,"",2),mygrzf=$fn(tarigrzfSum,"",2)
	...q:(+sum=0)
	...d OutputRowInBaby
	s taricDesc="婴儿合计",tariDesc="",uomDesc="",price="",qty="",sum=$fn(sumall,"",2) ,PhcfDesc="",PhmnfName="",tariCode="",ExternalCode="",tariChargeBasis=""
	s myblzf=$fn(blzfSum,"",2),mygrzf=$fn(grzfSum,"",2),ybdesc="" ;医保比例自负，个人自费
	d OutputRowInBaby
	s count=0,sumall=0,count1=0
	s cat=""
	f  s cat=$o(^mtemp($j,"BillDetail",cat)) q:(cat="")  d   //区分是打印收费项目还是医嘱项
	.s AdmRowId=""
	.f  s AdmRowId=$o(^mtemp($j,"BillDetail",cat,AdmRowId)) q:(AdmRowId="")  d
	..q:(AdmRowId=motheradm)
	..q:$d(^PAADMi("Mother",motheradm,AdmRowId))
	..s taricID=""
	..f  s taricID=$o(^mtemp($j,"BillDetail",cat,AdmRowId,taricID)) q:(taricID="")  d  //分类Id
	...s oldtaricDesc="",tarisum=0,tariblzfSum=0,tarigrzfSum=0
	...s tariID=""
	...f  s tariID=$o(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID)) q:(tariID="")  d  //项目ID
	....s price=""
	....f  s price=$o(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price)) q:(price="")  d  //金额
	.....i (cat="IPCat") d
	......s taricDesc=$p(^DHCTarC("TIC",taricID),"^",2)
	......s tariID1=$p(tariID,"*",1)
	......s tariDesc=$p(^DHCTARI(tariID1),"^",2)
	......s tariCode=$p(^DHCTARI(tariID1),"^",1)
	......s InsuName=$p(^DHCTARI(tariID1),"^",18)	//取医保名称
	......s ybdesc=$p(tariID,"*",2)
	.....i (cat="itemCat") d
	......s tariID1=$p(tariID,"*",1)
	......s taricDesc=$p(^ARC("IC",taricID),"^",2)
	......s tariDesc=$p(^ARCIM(+tariID1,$p(tariID1,"||",2),1),"^",2)
	......s tariCode=$p(^ARCIM(+tariID1,$p(tariID1,"||",2),1),"^",1)
	......s ybdesc=$p(tariID,"*",2)
	......s InsuName=""
	.....s uomDesc=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",4)          //单位
	.....s qty=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",1)
	.....q:(+qty=0)
	.....s sum=$fn($p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",2),"",2)
	.....s tarisum=tarisum+sum
	.....s all=all+sum
	.....s sumall=sumall+$fn($p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",2),"",2)
	.....s myArcimId=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",3) ;
	.....s myArcimId=$p(myArcimId,$c(1))
	.....s DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(myArcimId)
	.....s:(DrugCommonDesc'="") tariDesc=DrugCommonDesc 
	.....s drugspec=##class(web.UDHCJFCOMMON).GetDrugSpec(myArcimId)
	.....i (drugspec'="") d
	......s tariDesc=tariDesc_"("_drugspec_")"
	.....s myblzf=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",6)
	.....s mygrzf=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",7)
	.....s tariblzfSum=tariblzfSum+myblzf,tarigrzfSum=tarigrzfSum+mygrzf
	.....s blzfSum=blzfSum+myblzf,grzfSum=grzfSum+mygrzf
	.....s PhcfDesc=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",8)
	.....s PhcfDesc=$p(PhcfDesc,$c(13))
	.....s PhmnfName=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",9)
	.....s ybdesc=$p(^mtemp($j,"BillDetail",cat,AdmRowId,taricID,tariID,price),"^",10)
	.....do OutputRowInBaby
	...set taricDesc="小计",tariDesc="",uomDesc="",price="",qty="",sum=$fn(tarisum,"",2),ybdesc="",PhcfDesc="",PhmnfName="",tariCode="",ExternalCode="",tariChargeBasis=""
	...set myblzf=$fn(tariblzfSum,"",2),mygrzf=$fn(tarigrzfSum,"",2)
	...quit:(+sum=0)
	...do OutputRowInBaby

	set taricDesc="门诊转住院合计",tariDesc="",uomDesc="",price="",qty="",sum=$fn(sumall,"",2) ,PhcfDesc="",PhmnfName="",tariCode="",ExternalCode="",tariChargeBasis=""
	set myblzf=$fn(blzfSum,"",2),mygrzf=$fn(grzfSum,"",2),ybdesc="" ;医保比例自负，个人自费
	do OutputRowInBaby
	set taricDesc="合计",tariDesc="",uomDesc="",price="",qty="",sum=$fn(all,"",2) ,PhcfDesc="",PhmnfName="",tariCode="",ExternalCode="",tariChargeBasis=""
	set myblzf=$fn(blzfSum,"",2),mygrzf=$fn(grzfSum,"",2), ybdesc="" ;医保比例自负，个人自费
	do OutputRowInBaby
	quit
OutputRowInBaby
	set:(+myblzf=0) myblzf=""
	set:(+mygrzf=0) mygrzf=""
	if ((taricDesc'["小计")&&(taricDesc'["合计")) do
	.set count=count+1
	.set ^TMP("ZYJF",BillNo,$j,AdmRowId,count)=taricDesc_"^"_tariDesc_"^"_uomDesc_"^"_price_"^"_qty_"^"_sum_"^"_ybdesc_"^"_mygrzf_"^"_PhcfDesc_"^"_PhmnfName_"^"_taricID
	//set Data=$lb(taricDesc,tariDesc,uomDesc,price,qty,sum,$j,ybdesc,PhcfDesc,PhmnfName,BillNo,tariID,tariCode,ExternalCode)
	set Data=$lb(taricDesc,tariDesc,uomDesc,price,qty,sum,$j,ybdesc,PhcfDesc,PhmnfName,BillNo,tariID,tariChargeBasis)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator:yq
/// CreateTime:20140420
/// 获取账单打印信息
/// d ##class(%ResultSet).RunQuery("web.UDHCJFBillDetail","FindBillInfo","255897","25476")
Query FindBillInfo(BillNo, job) As websys.Query(ROWSPEC = "Name:%String,taricDesc:%String,tariCode:%String,tariDesc:%String,ybDesc:%String,yblb:%String,uomDesc:%String,price:%Float,qty:%String,sum:%Float,taricId:%String,Admid:%String") [ SqlProc ]
{
}

ClassMethod FindBillInfoExecute(ByRef qHandle As %Binary, BillNo, job) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set qHandle=$lb(0,repid,0)
	if (BillNo="")  quit $$$OK
	set Admid="0"
	for  set Admid=$o(^TMP("ZYJF",BillNo,job,Admid)) quit:(Admid="")  do
	.set Papmi=$p(^PAADM(Admid),"^",1)
 	.set Name=$p(^PAPER(Papmi,"ALL"),"^",1)
	.set RowId="0"
	.for  set RowId=$o(^TMP("ZYJF",BillNo,job,Admid,RowId)) quit:(RowId="")  do
	..set PatTarInfo=$g(^TMP("ZYJF",BillNo,job,Admid,RowId))
	..set taricDesc=$p(PatTarInfo,"^",1)
	..set tariCode=""  //$p(PatTarInfo,"^",2)
	..set tariDesc=$p(PatTarInfo,"^",2)
	..set ybDesc=""    //$p(PatTarInfo,"^",4)
	..set yblb=""      //$p(PatTarInfo,"^",5)
	..set uomDesc=$p(PatTarInfo,"^",3)
	..set price=$p(PatTarInfo,"^",4)
	..set qty=$p(PatTarInfo,"^",5)
	..set sum=$p(PatTarInfo,"^",6)
	..set taricId=$p(PatTarInfo,"^",11)
	..do OutputRowBillInfo
	
	quit $$$OK
OutputRowBillInfo
 	set Data=$lb(Name,taricDesc,tariCode,tariDesc,ybDesc,yblb,uomDesc,price,qty,sum,taricId,Admid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator:yq
/// CreateTime:20140420
/// 获取账单头
/// d ##class(%ResultSet).RunQuery("web.UDHCJFBillDetail","FindBillInfoTitle",249201,7544)
Query FindBillInfoTitle(BillNo, job) As websys.Query(ROWSPEC = "Medicare:%String,PatName:%String,Address:%String,AdmReason:%String,LocDesc:%String,Bedinfo:%String,AdmDate:%String,DisDate:%String,StayDate:%String,BillFromDateTo:%String,PBAmount:%String,ICDDesc:%String,FindFromDateTo:%String,HospDesc:%String") [ SqlProc ]
{
}

ClassMethod FindBillInfoTitleExecute(ByRef qHandle As %Binary, BillNo, job) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	if (BillNo="")  quit $$$OK 
	set (LocDesc, WardDesc, RoomDesc, BedCode, Bedinfo)=""
	set Adm=$p(^DHCPB(BillNo),"^",1)
	set HospID=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	set HospDesc=""
	if (HospID'="") set HospDesc=$p(^CT("HOSP",HospID),"^",2)
	
	set InOutDate=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(Adm)
	set AdmDate=$p(InOutDate,"^",1)
	set DisDate=$p(InOutDate,"^",4)
	set StayDate=$p(InOutDate,"^",3)
	if (AdmDate'="") set AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
	if (DisDate'="") set DisDate=##class(websys.Conversions).DateLogicalToHtml(DisDate)
	set CurrDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	set FindFromDateTo=AdmDate_" 至 "_CurrDate
	set LocId=$p(^PAADM(Adm),"^",4)
	if (LocId'="") set LocDesc=$p(^CTLOC(LocId),"^",2)
	if (LocDesc["-") set LocDesc=$p(LocDesc,"-",2)	   //科室
	set WardId=$p(^PAADM(Adm),"^",70)
	if (WardId'="")  do
	.if ($d(^PAWARD(WardId))) set WardDesc=$p(^PAWARD(WardId),"^",2)
	.if (WardDesc["-") set WardDesc=$p(WardDesc,"-",2)	     //病区
	set RoomId=$p(^PAADM(Adm),"^",69)
	if (RoomId'="") set RoomDesc=$p(^PAROOM(RoomId),"^",2)	 //房号
	set BedRowid=$p(^PAADM(Adm),"^",73)
	if (BedRowid'="") do
	.set BedCode=$p(^PAWARD($p(BedRowid,"||",1),"BED",$p(BedRowid,"||",2)),"^",1)	//床号
	set Bedinfo=WardDesc_"/"_RoomDesc_"/"_BedCode
	set AdmReasonId=$p(^PAADM(Adm,1),"^",7)
	set AdmReason="自费"
	if ((AdmReasonId'="")&&($d(^PAC("ADMREA",AdmReasonId)))) do
	.set AdmReason=$p(^PAC("ADMREA",AdmReasonId),"^",2)	                //就诊类型

	set Medicare=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(Adm, "I", "")	//病案号
	
	set AdmInDays=##class(UDHCJFBaseCommon).GetPatAdmInDays(Adm, BillNo)
    set BillStDate=$p(AdmInDays,"^",1)	;账单开始日期
    set BillEndDate=$p(AdmInDays,"^",2)	;账单结束日期
	set BillFromDateTo=BillStDate_" 至 "_BillEndDate
	set PaperId=$p(^PAADM(Adm),"^",1)
	set PatName=$p(^PAPER(PaperId,"ALL"),"^",1)   //姓名
	set Address=$g(^PAPER(PaperId,"PER","ADD",1))     //地址
	set company=$p($g(^PAPER(PaperId,"PER",4)),"^",18)
	
	set patfee=##class(web.UDHCJFBaseCommon).GetAdmDepositAndFeeByBillNo(Adm, BillNo)	//预交金^总费用^余额
	set AdmDeposit=$p(patfee,"^",1)
	set PBAmount=$p(patfee,"^",2)
	set MRAdmRowid=$p(^PAADM(Adm),"^",61)
	set ICDDesc=##class(web.UDHCJFBaseCommon).GetMRDiagnosDesc(MRAdmRowid,"","","/")
	if ($g(^TMP("ZYJF",BillNo,job))'="") set FindFromDateTo=$g(^TMP("ZYJF",BillNo,job))
	if ($p(FindFromDateTo,"至",1)="") set FindFromDateTo=AdmDate_" 至 "_$p(FindFromDateTo,"至",2)
	do OutputRow1
	
	quit $$$OK
OutputRow1
 	set Data=$lb(Medicare,PatName,company,AdmReason,LocDesc,Bedinfo,AdmDate,DisDate,StayDate,BillFromDateTo,PBAmount,ICDDesc,$g(FindFromDateTo),HospDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 获取转科记录 wk 2013-12-24
/// d ##class(%ResultSet).RunQuery("web.UDHCJFBillDetail","gettransloc","","")
Query gettransloc(admloc, Adm As %String) As websys.Query(ROWSPEC = "depdesc:%String,depno:%String")
{
}

ClassMethod gettranslocExecute(ByRef qHandle As %Binary, admloc, Adm As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
    if (Adm="")  quit $$$OK
  	kill ^||TMP($j)
  	set chl=""
  	for  set chl=$o(^PAADM(Adm,"TRANS",chl)) quit:(chl="")  do
  	.set deptDR=$p(^PAADM(Adm,"TRANS",chl),"^",6)
    .quit:(deptDR="")
    .quit:($d(^||TMP($j,deptDR)))      //去重
    .set ^||TMP($j,deptDR)=""
    .set deptDesc=$p(^CTLOC(deptDR),"^",2)
    .if (deptDesc["-") do
    ..set deptDesc=$p(deptDesc,"-",2)
    .do OutputRowTransloc
  	
	kill ^||TMP($j)
	quit $$$OK
OutputRowTransloc
	set Data=$lb(deptDesc,locDR)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

ClassMethod GetBillNum(BillNo, job)
{
	set Admid="", sum=0
	for  set Admid=$o(^TMP("ZYJF",BillNo,job,Admid)) quit:(Admid="")  do
	.set num1=$o(^TMP("ZYJF",BillNo,job,Admid,""),-1)
	.set sum=sum+num1
	quit sum
}

}
