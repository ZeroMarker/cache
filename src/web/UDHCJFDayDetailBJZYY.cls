Import SQLUser

/// 程序名DHCJFDETAIL,日清明细统计
Class web.UDHCJFDayDetailBJZYY Extends %Library.RegisteredObject
{

Parameter BUILD = 441;

ClassMethod FindWardExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    s rowid="0"
    f  s rowid=$o(^PAWARD(rowid)) q:(rowid="BED_BedType_DR")!(rowid="")  d
    .s usrname=$p(^PAWARD(rowid),"^",2)
    .Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(usrname,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit $$$OK
}

ClassMethod FindWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardExecute ]
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
}

ClassMethod FindWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindWard() As %Query(ROWSPEC = "warddesc:%String,rowid:%String")
{
}

ClassMethod FindTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    s rowid="0"
    for  s rowid=$o(^DHCTarC("TIC",rowid)) q:rowid=""  d
    .s type=$p(^DHCTarC("TIC",rowid),"^",2)
    .Do OutputRow1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(type,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod FindTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTypeExecute ]
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

ClassMethod FindTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindType() As %Query(ROWSPEC = "type:%String,rowid:%String")
{
}

ClassMethod FindDetailExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, wardid As %String, typeid As %String, RegNo As %String, hbflag As %String, orddeptid As %String, orddept As %String, DepGroup As %String, DepGroupid As %String) As %Status
{
   ;d ##class(%ResultSet).RunQuery("web.UDHCJFDayDetail","FindDetail",$zdh("2007-04-24",3),$zdh("2007-04-25",3),"103","","","1","","","","")
	//s hbflag=0
	s gnum=0
	Set repid=$I(^CacheTemp)
    s ind=1
    k ^mtemp($j,"Detail")
    k ^mtemp($j,"PackNum")
    k ^mtemp($j,"PackUom")
    s ^TMP("RegNo",$j)=""
    d ..GetTICInfo()
    f j=1:1:$get(^DHCICGRP) d
    .s ^catefee(+RegNo,$p(^DHCICGRP(j),"#",1))=0
    i RegNo'="" d
    .k ^TMP("Details",$j)
    .s ^tmpdetail("test")=$g(stdate)_","_$g(enddate)_","_$g(typeid)_","_$g(RegNo)_","_$g(orddeptid)_","_$g(DepGroupid)_","_$g(hbflag)
    .d ..GetPatDetail(RegNo,stdate,enddate,typeid,RegNo,orddeptid,DepGroupid)
    i (wardid'="")&(RegNo="") d
    .k ^TMP("Details",$j)
    .s patnostr=..GetDeptPat(wardid,stdate,enddate)
    .s num=$l(patnostr,"^")
    .s no="" f  s no=$o(^TMP("ZYJFBED",$j,no)) q:no=""  d
    ..s RegNo=^TMP("ZYJFBED",$j,no)
    ..f j=1:1:$g(^DHCICGRP) d
    ...s ^catefee(+RegNo,$p(^DHCICGRP(j),"#",1))=0
    ..d ..GetPatDetail(RegNo,stdate,enddate,typeid,wardid,orddeptid)
 k ^TMP("ZYJFBED",$j)  
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
}

ClassMethod FindDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDetailExecute ]
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
}

ClassMethod FindDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindDetail(stdate As %String, enddate As %String, wardid As %String, typeid As %String, RegNo As %String, hbflag As %String, orddeptid As %String, orddept As %String, DepGroup As %String, DepGroupid As %String) As %Query(ROWSPEC = "Tpatname:%String,Ttype:%String,Titm:%String,Tqty:%String,Tuom:%String,Tunitprice:%String,Tsum:%String,Tjob:%String,Tdate:%String,Ttime:%String,Tzfbl:%String")
{
}

ClassMethod FetchLocInfo(LocTypeDesc As %String)
{
 s DATAID=0
 s P1=0
 k PLIST
 &sql(DECLARE LocCur CURSOR	FOR select LOC_CTLOC_DR, LOC_CTLOC_DR->CTLOC_DESC
	    from CT_LocationList_Locations WHERE LOC_PARREF=:TypeRowID)
 s TypeRowID=""
 &sql(SELECT LL_ROWID INTO :TypeRowID FROM CT_LocationList WHERE LL_DESC=:LocTypeDesc)
 if TypeRowID="" q 
 &sql(open LocCur)
 f  &sql(fetch LocCur into :LocID,:Locname ) q:SQLCODE  d  
  .i Locname'=""  d
    ..s DATAID=DATAID+1
    ..s PLIST(DATAID)=LocID_"#"_Locname
 &sql(close LocCur)
 s PLIST=DATAID
 s P1=DATAID
 q
}

ClassMethod GetTICInfo()
{
 k PLIST
 s Num=0
 K ^DHCICGRP
 s rowid=0
 f  s rowid=$o(^DHCTarC("TIC",rowid)) q:rowid=""  d
 .s BillGrpDesc=$p(^DHCTarC("TIC",rowid),"^",2)
 .s BillGrpCode=$p(^DHCTarC("TIC",rowid),"^",1)
 .q:BillGrpDesc=""
 .s Num=Num+1
 .s PLIST(Num)=BillGrpDesc_"#"_BillGrpCode_"#Y"
 .s ^DHCICGRP(Num)=BillGrpDesc_"#"_BillGrpCode_"#Y"
 .s ^DHCICGRP=Num

 s PLIST=Num
 s ^DHCICGRP=Num
 s P1=Num
 q
}

ClassMethod GetName(RegNo As %String)
{
 s P1=""
 &sql(select PAPMI_NAME  into :P1 FROM PA_PATMAS WHERE PAPMI_NO=:RegNo )
 q 0
}

/// 找出病区所有符合条件的病人登记号
ClassMethod GetDeptPat(wardId As %String, stdate As %String, enddate As %String) As %String
{
  k ^mtemp($j,"DetailRes"),^TMP("Details",$j),^TMP("ZYJFBED",$j)
  s P1=""
  s admId=""
  f  s admId=$o(^PAADMi("PAADM_Type","I",admId)) q:admId=""  d
     .s num=+$g(num)+1
     .q:'$d(^PAADM(admId))
     .s curWardId=$p(^PAADM(admId),"^",70) 
     .q:curWardId=""
     .q:curWardId'=wardId
     .s visit=$p(^PAADM(admId),"^",20)
     .q:visit["C"
     .s admdate=$p(^PAADM(admId),"^",6)
     .q:admdate>enddate
     .s disdate=$p(^PAADM(admId),"^",17)
     .q:(disdate<enddate)&(disdate'="")
     .q:(disdate'="")&(disdate<+$H) 
     .s bedrowid=$p(^PAADM(admId),"^",73)
     .;q:bedrowid=""
     .s bedname=num
     .i $g(bedrowid)'=""  d  
     ..s wardid=$p(bedrowid,"||",1),bedid=$p(bedrowid,"||",2)
     ..s bedname=$p(^PAWARD(wardid,"BED",bedid),"^",1)
     .i $Number(bedname)'=""  s bedname=$Number(bedname)
     .s papno=$p(^PAPER(+^PAADM(admId),"PAT",1),"^",1)
     .s ^TMP("ZYJFBED",$j,bedname)=papno
     .i P1'="" s P1=P1_"^"_papno 
     .e  s P1=papno
    
    s CurrentRoom=""
    f  s CurrentRoom=$o(^PAADMi("CurrWard",wardId,CurrentRoom)) q:CurrentRoom=""  d
    .s admId=""
    .f  s admId=$o(^PAADMi("CurrWard",wardId,CurrentRoom,admId)) q:admId=""  d
    ..s num=+$g(num)+1
    ..q:'$d(^PAADM(admId))
    ..s curWardId=$p(^PAADM(admId),"^",70) 
    ..;q:curWardId=""
    ..;q:curWardId'=wardId
    ..s visit=$p(^PAADM(admId),"^",20)
    ..q:visit["C"
    ..s admdate=$p(^PAADM(admId),"^",6)
    ..q:admdate>enddate
    ..s disdate=$p(^PAADM(admId),"^",17)
    ..q:(disdate<enddate)&(disdate'="")
    ..q:(disdate'="")&(disdate<+$H) 
    ..s bedrowid=$p(^PAADM(admId),"^",73)
    ..;q:bedrowid=""
    ..s bedname=num
    ..i $g(bedrowid)'=""  d  
    ...s wardid=$p(bedrowid,"||",1),bedid=$p(bedrowid,"||",2)
    ...s bedname=$p(^PAWARD(wardid,"BED",bedid),"^",1)
    ..i $Number(bedname)'=""  s bedname=$Number(bedname)
    ..s papno=$p(^PAPER(+^PAADM(admId),"PAT",1),"^",1)
    ..s ^TMP("ZYJFBED",$j,bedname)=papno
    ..i P1'="" s P1=P1_"^"_papno 
    ..e  s P1=papno
 q P1
}

ClassMethod GetPatDetail(RegNo As %String, stdate As %String, enddate As %String, typeid As %String, bq As %String, orddeptid, DepGroupid)
{
 K P1,P3
 s code=##class(web.DHCHospitalCodeSet).GetHospitalCode()
 i code'=""  s code=$p(code,"^",2)
 s RowID=0,sum=0
 q:RegNo=""
 q:'$d(^PAPERi("PAPMI_PatNo",RegNo))
 s papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,"")) ;papmi_rowid
 s papname=$p(^PAPER(papmi,"ALL"),"^",1)      ;病人姓名
 s admIdnew=$o(^PAPERdr(papmi,"ADM","I",""),-1)
 q:'$d(^PAADM(admIdnew))
 s deprowid=$p(^PAADM(admIdnew),"^",4)
 i deprowid'="" s locname=$p(^CTLOC(deprowid),"^",2)
 s bedrowid=$p(^PAADM(admIdnew),"^",73)
 i bedrowid'=""  d  
 .s wardid=$p(bedrowid,"||",1),bedid=$p(bedrowid,"||",2)
 .s bedname=$p(^PAWARD(wardid,"BED",bedid),"^",1)
 .s papname=papname_" 床号:"_bedname
 s admId=0
 s deposit=0
 f  s admId=$o(^PAPERdr(papmi,"ADM","I",admId)) q:admId=""  d  ;取住院病人admId
 .q:'$d(^PAADM(admId))
 .s deprowid=$p(^PAADM(admId),"^",4)
 .i deprowid'="" s locname=$p(^CTLOC(deprowid),"^",2)
 .s bedrowid=$p(^PAADM(admId),"^",73)
 .i bedrowid'=""  d  
 ..s wardid=$p(bedrowid,"||",1),bedid=$p(bedrowid,"||",2)
 ..s bedname=$p(^PAWARD(wardid,"BED",bedid),"^",1)
 ..//s papname=papname_" 床号:"_bedname
 .s visitstatus=$p($g(^PAADM(admId)),"^",20)
 .;q:(visitstatus'="A");yys,去掉后可以查出院病人的日清明细。
 .;s deposit=##class(web.UDHCJFORDCHK).deposit(admId)
 .s bill=0
 .s oeqty=0,patfee=0,patshare=0,paidfee=0
 .f  s bill=$o(^DHCPB(0,"ADM",admId,bill)) q:bill=""  d  
 ..d ..GetPatFeeInfo(admId,bill)  ;根据病人取帐单号
 ..s payedflag=$p(^DHCPB(bill),"^",16)
 ..;q:payedflag="P"
 ..s expflag="",billtot=0,pvtot=0,expamt=0,billflag1=""
 ..s order=0 f  s order=$o(^DHCPB(bill,"O",order)) q:order=""  d        ;帐单医嘱
 ...s prtordflag="N"
 ...s oerowid=$p($g(^DHCPB(+bill,"O",order)),"^",4)   ;YYX增加，判断医嘱不存在，则过滤掉
 ...q:oerowid=""
 ...q:'$d(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2)))
 ...s orddept=$p(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2),7),"^",2)
 ...q:(orddept'=orddeptid)&(orddeptid'="")
 ...i orddept'="" s ordgrp=$p(^CTLOC(orddept),"^",19)
 ...q:($g(DepGroupid)'=$g(ordgrp))&($g(DepGroupid)'="")
 ...;
 ...s PackStr=""
 ...s PackStr=##class(web.DHCNurDrugAudit).GetPackQty(+oerowid,$P(oerowid,"||",2))
 ...;s billdesc=$p(^OEORD(+oerowid,"I",$p(oerowid,"||",2),2),"^",12)
 ...;取收费项目明细
 ...s itm=0 f  s itm=$o(^DHCPB(+bill,"O",order,"D",itm)) q:(itm="")!(prtordflag="Y")  s s=^(itm) d   ;收费项目明细
 ....s tariDesc=""
 ....s itmrowid=bill_"||"_order_"||"_itm
 ....s billdate=$p(s,"^",11),billtime=$p(s,"^",12),billstatus=$p(s,"^",14)  ;yyx 06-12-07
 ....q:((billdate<stdate)!(billdate>enddate))
 ....s taritm=$p(s,"^",3)
 ....s tarinpat=$p(^DHCTARI(taritm),"^",14)
 ....i tarinpat'=""  d
 .....s taric=$p(^DHCTarC("IC",tarinpat),"^",3)  ;收费项目住院分类
 ....q:(typeid'="")&(typeid'=taric)
 ....;判断如果医嘱子类定义了打印医嘱项则按照医嘱项打印，否则打印收费项目
 ....s arcimid=$p($g(^DHCPB(bill,"O",order)),"^",3)
 ....s itemcat=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),1),"^",10)
 ....i $d(^DHCJFORDITEMCATSET(0,"ItemCat",itemcat)) d
 .....d ..GetOrder(bill,order)
 .....s prtordflag="Y"
 ....q:prtordflag="Y"
 ....;
 ....d ..GetDetail(bill,order,itm)
 ....;s taritm=$p(s,"^",3)   ;PBD_TARI_DR,收费项目住院分类
 ....;q:'$d(^DHCTARI(taritm))
 ....;s tariDesc=$p(^DHCTARI(taritm),"^",2)  ;收费项目名称
 ....;i billstatus="P" s tariDesc=tariDesc_"("_"已结算"_")"
 ....;inert by cx 婴儿的收费项目后面加婴儿标志
 ....;i admmotflag'="" s tariDesc=tariDesc_"-----("_"婴儿"_")"
 ....;s ybzfbl="",insustr=""
 ....;i code="ShaoGuan_YueBei"  d
 .....;s insustr=##class(web.INSUDivideSgSvr).GetCont(taritm, admreadesc)
 .....;i insustr=""  s ybzfbl=""
 .....;i insustr'=""  s ybzfbl=+$p(insustr,"^",19)
 ....;s taricode=""
 ....;s taricode=$p(^DHCTARI(taritm),"^",1)  ;收费项目代码
 ....;if PackStr'="" d
 .....;s ^mtemp($j,"PackNum",taritm)=$G(^mtemp($j,"PackNum",taritm))+$P(PackStr,"|")
 .....;s ^mtemp($j,"PackUom",taritm)=$P(PackStr,"|",2)
 ....;i $d(^OEORD(+oerowid,"I",$p(oerowid,"||",2),2)) s billdesc=$p(^OEORD(+oerowid,"I",$p(oerowid,"||",2),2),"^",12)
 ....;i billdesc'=""  d
 .....;s tariDesc=billdesc
 ....;e  d
 .....;s arcim=$p($g(^DHCPB(+bill,"O",order)),"^",3)
 .....;s DrugCommonDesc=""
 .....;s DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(arcim)
 .....;s:DrugCommonDesc'="" tariDesc=DrugCommonDesc
 ....;yyx
 ....;i code="NingBo_MingZhou"  d
 .....;s tariDesc=taricode_" "_tariDesc
 ....;s arcim=$p($g(^DHCPB(+bill,"O",order)),"^",3)
 ....;s arcgrp=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)          ;子类arc_itemcat
 ....;s catgrp=$p(^ARC("IC",arcgrp),"^",8) ;OEC_OrderCategory
 ....;s catgrpdesc=$p(^OEC("ORCAT",catgrp),"^",2)
 ....;i ((catgrpdesc="检验")!(catgrpdesc="医技检查")) d
 .....;s ordstatus=$p(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2),1),"^",13) ;oec_orderstatus
 .....;s ordstatus=$p(^OEC("OSTAT",ordstatus),"^",1)
 .....;i ordstatus="V" s tariDesc=tariDesc_"(预收)"
 .....;i ordstatus="V" s tariDesc=tariDesc
 ....;i code="BEIJING_JSTYY" d
 .....;s:taric=27 taric=26
 ....;s taricdesc=$p(^DHCTarC("TIC",taric),"^",2)  ;收费项目住院分类名称
 ....
 ....;s date=$p(s,"^",11)   ;pbd_billdate
 ....;s qty=$p(s,"^",5)     ;pbd_billqty
 ....;s price=$j($p(s,"^",4),3,4)   ;pbd_unitprice
 ....;s tot=$fn(price*qty,"",2)     ;pbd_totalamount
 ....;s tariUom=$p(^DHCTARI(taritm),"^",3)  ;单位
 ....;i tariUom'="" s uomDesc=$p(^CT("UOM",tariUom),"^",2) ;单位            
 ....;f i=1:1:$g(^DHCICGRP) d    ;每个病人的每个分类的金额
 .....;i $p(taricdesc,$c(1))=$p($p(^DHCICGRP(i),"#",1),$c(1)) d
 ....;s ^catefee(+RegNo,taricdesc)=tot+^catefee(+RegNo,taricdesc)                 
 ....;s sum=sum+tot   ;总计
 
 i hbflag="1" d
 .d ..ListHz(RegNo,sum,hbflag,bq,deposit)
 i hbflag="0" d
 .d ..ListDetail(RegNo,sum,hbflag,bq,deposit)
 q
 ;d ..ListPat(RegNo,sum)
}

ClassMethod GetPatFeeInfo(admId, bill)
{
  s admreason=$p($g(^PAADM(admId,1)),"^",7)
  s InsTyperowid=$o(^PAC("ADMREA",0,"Code",admreason,0))
  s admreason=InsTyperowid
  i admreason'="" d
  .s admreasondesc=$P(^PAC("ADMREA",admreason),"^",2)
  i code="ShaoGuan_YueBei"  d
  .i admreason=""  s admreadesc="SG"
  .i admreason'=""  d
  ..i $d(^PAC("ADMREA",admreason))=0  d
  ...s admreadesc="SG"
  ..e  d
  ...s admreadesc=$p(^PAC("ADMREA",admreason),"^",2)
  ...i admreadesc="广铁医保"  s admreadesc="GT"
  ...i admreadesc'="广铁医保"  s admreadesc="SG" 
  i code="NingBo_MingZhou"  d
  .i (admreason="鄞州农保")||(admreason="宁波市保")  d
  ..s coststr=##class(web.UDHCJFCKD).getybstr(admId,enddate)
  ..s patshare=+$j($p(coststr,"^",2),3,2)
  ..s deposit=+$j($p(coststr,"^",4),3,2)
  ..s ybye=+$j($p(coststr,"^",3),3,2)
  ..s patfee=+$j($p(coststr,"^",1),3,2)
  .e  d
  ..s deposit=##class(web.UDHCJFORDCHK).deposit(admId)
  ..s patfee1=0,patshare1=0
  ..s feestr=..Computing(bill,"",enddate)
  ..s patfee1=+$p(feestr,"^",1)
  ..s patshare1=+$p(feestr,"^",4)
  ..s patfee=patfee+patfee1
  ..s patshare=patshare+patshare1
  i code'="NingBo_MingZhou"  d
  .s deposit=##class(web.UDHCJFORDCHK).deposit(admId)
  .s patfee1=0,patshare1=0
  .s feestr=..Computing(bill,"",enddate)
  .s patfee1=+$p(feestr,"^",1)
  .s patshare1=+$p(feestr,"^",4)
  .s patfee=patfee+patfee1
  .s patshare=patshare+patshare1
  i admreason=""  s admreason="自费" 
 q
}

/// 找到病区的所有病人
ClassMethod List(num As %String, jj As %String)
{
 s P2=$g(^mtemp(jj,"DetailRes",num))
 i num=$o(^mtemp(jj,"DetailRes",""),-1) k ^mtemp(jj)
 q P2
}

ClassMethod ListPat(RegNo As %String, sum As %String, hbflag As %String)
{
 i hbflag="0" d
 .d ..ListHz()
 i hbflag="1" d
 .d ..ListDetail()
 q
 ;Quit $$$OK
}

ClassMethod getpatno(jj)
{
 s patstr=^TMP("RegNo",jj)
 q patstr
}

ClassMethod getnum(itmjs As %Library.String = "", itmjsex As %Library.String = "", jj, bq, regno)
{
  
   i $g(bq)="" s bq=regno
  s gnum=$o(^TMP("Details",jj,bq,regno,""),-1)
  q gnum
}

ClassMethod getdata(itmjs As %Library.String = "", itmjsex As %Library.String = "", jj, bq, regno, num)
{
 
   i $g(bq)="" s bq=regno
	s str=^TMP("Details",jj,bq,regno,num)
	q str
}

ClassMethod ListHz(regNo, sum, hbflag, bq, deposit)
{
 s gnum=0
 i $d(^mtemp($j,"Detail",+regNo)) d
 .i ^TMP("RegNo",$j)="" d
 ..i sum'=0 s ^TMP("RegNo",$j)=regNo
 .e  d
 ..i sum'=0 s ^TMP("RegNo",$j)=^TMP("RegNo",$j)_"^"_regNo
 s curid=0,oerowid=""   
 s type=""
 i bq="" s bq=regNo
 s job=$j
 s papno=regNo
 s discount="0",regNo=+regNo
 
 s ^TMP("Details",$j,bq,regNo,gnum)="发票类型"_"^"_"项目"_"^"_"数量"_"^"_"单位"_"^"_"单价"_"^"_"金额"_"^"_"自负"_"^"_"病历号"_"^"_"姓名"
 s cat=""
 s (date,time)=""
 f  s cat=$o(^mtemp($j,"Detail",regNo,cat)) q:cat=""  d 
  .s taricID=""
  .f  s taricID=$o(^mtemp($j,"Detail",regNo,cat,taricID)) q:taricID=""  d  ;分类Id
  ..s oldtaricDesc="",tarisum=0
  ..s tariID=""
  ..f  s tariID=$o(^mtemp($j,"Detail",regNo,cat,taricID,tariID)) q:tariID=""  d  ;项目ID
  ...s price=""
  ...f  s price=$o(^mtemp($j,"Detail",regNo,cat,taricID,tariID,price)) q:price=""  d  ;金额
  ....;s gnum=gnum+1
  ....i cat="IPCat" d
  .....i $d(^DHCTarC("TIC",taricID)) d
  ......s taricDesc=$p(^DHCTarC("TIC",taricID),"^",2)
  .....;e  s taricDesc=""
  .....s tariDesc=$p(^DHCTARI(tariID),"^",2)
  ....i cat="itemCat" d
  .....s taricDesc=$p(^ARC("IC",taricID),"^",2)
  .....s tariDesc=$p(^ARCIM(+tariID,$p(tariID,"||",2),1),"^",2)
  ....s babyflag=$p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,price),"^",6)
  ....s billstatus=$p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,price),"^",7)
  ....s qty=$p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,price),"^",1)
  ....s total=$j($p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,price),"^",2),3,2)
  ....s uomDesc=$p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,price),"^",3)
  ....;s time=$p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,price),"^",4)
  ....s tarisum=tarisum+total
  ....s ybzfbl=$p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,price),"^",5)
  ....i (oldtaricDesc'=taricDesc) d  
  .....s oldtaricDesc=taricDesc
  ....e  s taricDesc=""
  ....d OutputRow3
  ....s papname=""  
  q:+sum=0 gnum
  s papname="",taricDesc="总计",taricode="",tariDesc="",qty="",uomDesc="",price="",total=$j(sum,3,2)
  s ybzfbl=""
  Do OutputRow3
  s papname="",taricDesc="预缴款",tariDesc=$j(deposit,3,2),qty="费用",uomDesc=$j(patfee,3,2)_"(其中已结算)"_paidfee
  s ybzfbl=""
  i code="NingBo_MingZhou" d 
  .i (admreason="鄞州农保")||(admreason="宁波市保")  d
  ..s price="统筹费用",total=$j(patshare,3,2),date="余额",time=$j(ybye,3,2),discount=""
  .e  d
  ..s price="自付费用",total=$j(patfee,3,2),date="余额",time=$j((deposit-patfee),3,2),discount=""
  e  d
  .s price="自付费用",total=$j(patfee,3,2),date="余额",time=$j((deposit-patfee),3,2),discount=""
OutputRow3
	i code="NingBo_MingZhou" d 
	.i (admreason="鄞州农保")||(admreason="宁波市保")  d
	..i (price'="统筹费用")&(price'="") s price=$j(price,6,4)
	.e  d
	..i (price'="自付费用")&(price'="") s price=$j(price,6,4)
	//e  d
	//.i (price'="自付费用")&(price'="") s price=$j(price,6,4)
	set Data=$lb(papname,taricDesc,tariDesc,qty,uomDesc,price,total,job,date,time,ybzfbl)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	s gnum=gnum+1 	
 	i gnum=1 d
 	.i code="NingBo_MingZhou" d
 	..i (admreason="鄞州农保")||(admreason="宁波市保")  d
 	...s ^TMP("Details",$j,bq,papno,gnum)=taricDesc_"^"_tariDesc_"^"_qty_"^"_uomDesc_"^"_price_"^"_total_"^"_discount_"^"_papno_"^"_$g(papname)_"^"_$j(deposit,3,2)_"^"_$j(patfee,3,2)_"^"_$j(ybye,3,2)_"^"_"统筹金额:"_$j(patshare,3,2)_"^"_admreason
 	..e  d
 	...s ^TMP("Details",$j,bq,papno,gnum)=taricDesc_"^"_tariDesc_"^"_qty_"^"_uomDesc_"^"_price_"^"_total_"^"_discount_"^"_papno_"^"_$g(papname)_"^"_$j(deposit,3,2)_"^"_$j(patfee,3,2)_"^"_$j(deposit-patfee,3,2)_"^"_"自付金额:"_$j(patfee,3,2)_"^"_admreason
	.e  d
	..s ^TMP("Details",$j,bq,papno,gnum)=taricDesc_"^"_tariDesc_"^"_qty_"^"_uomDesc_"^"_price_"^"_total_"^"_discount_"^"_papno_"^"_$g(papname)_"^"_$j(deposit,3,2)_"^"_$j(patfee,3,2)_"^"_$j(deposit-patfee,3,2)_"^"_ybzfbl
	e  d
	.s ^TMP("Details",$j,bq,papno,gnum)=taricDesc_"^"_tariDesc_"^"_qty_"^"_uomDesc_"^"_price_"^"_total_"^"_discount_"^"_papno_"^"_$g(papname)_"^"_""_"^"_""_"^"_""_"^"_ybzfbl
	quit
}

ClassMethod ListDetail(RegNo, sum, hbflag, bq, deposit)
{
 s gnum=0
 s patno=RegNo

 s papno=RegNo
 i $d(^mtemp($j,"Detail",+RegNo)) d
 .i ^TMP("RegNo",$j)="" d
 ..i sum'=0 s ^TMP("RegNo",$j)=RegNo
 .e  d
 ..i sum'=0 s ^TMP("RegNo",$j)=^TMP("RegNo",$j)_"^"_RegNo
 s regNo=+RegNo
 s curid=0,oerowid=""
 i bq="" s bq=RegNo
 s job=$j
 s discount=0
 ;s ^TMP("Details",$j,bq,RegNo,gnum)="发票类型"_"^"_"项目"_"^"_"数量"_"^"_"单位"_"^"_"单价"_"^"_"金额"_"^"_"自负"_"^"_"病历号"_"^"_"姓名"
  s cat=""
  f  s cat=$o(^mtemp($j,"Detail",regNo,cat)) q:cat=""  d 
  .s taricID=""
  .f  s taricID=$o(^mtemp($j,"Detail",regNo,cat,taricID)) q:taricID=""  d  ;分类Id
  ..s oldtaricDesc="",tarisum=0
  ..s tariID=""
  ..f  s tariID=$o(^mtemp($j,"Detail",regNo,cat,taricID,tariID)) q:tariID=""  d  ;项目ID
  ...s oerowid=""
  ...f  s oerowid=$o(^mtemp($j,"Detail",regNo,cat,taricID,tariID,oerowid)) q:oerowid=""  d
  ....s price=""
  ....f  s price=$o(^mtemp($j,"Detail",regNo,cat,taricID,tariID,oerowid,price)) q:price=""  d  ;金额
  .....s datenw=""
  .....f  s datenw=$o(^mtemp($j,"Detail",regNo,cat,taricID,tariID,oerowid,price,datenw)) q:datenw=""  d
  ......;s gnum=gnum+1
  ......i cat="IPCat" d
  .......i $d(^DHCTarC("TIC",taricID)) d
  ........s taricDesc=$p(^DHCTarC("TIC",taricID),"^",2)
  .......e  s taricDesc=""
  .......s tariDesc=$p(^DHCTARI(tariID),"^",2)
  ......i cat="ItemCat" d
  .......s taricDesc=$p(^ARC("IC",taricID),"^",2)
  .......s tariDesc=$p(^ARCIM(+tariID,$p(tariID,"||",2),1),"^",2)
  ......s babyflag=$p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,oerowid,price,datenw),"^",6)
  ......s billstatus=$p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,oerowid,price,datenw),"^",7)
  ......s qty=$p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,oerowid,price,datenw),"^",1)
  ......q:qty=0
  ......s total=$j($p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,oerowid,price,datenw),"^",2),3,2)
  ......s date=$p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,oerowid,price,datenw),"^",3)
  ......s time=$p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,oerowid,price,datenw),"^",4)
  ......s tarisum=tarisum+total
  ......if $G(packnum)'=""  s qty=qty_"-"_packnum
  ......s ybzfbl=$p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,oerowid,price,datenw),"^",5)
  ......s uomDesc=$p(^mtemp($j,"Detail",regNo,cat,taricID,tariID,oerowid,price,datenw),"^",6)
  ......;i (oldtaricDesc'=taricDesc) d  
  ......;.s oldtaricDesc=taricDesc
  ......;e  s taricDesc=""
  ......s ^TMP("DHCIPBill","DailyDetail",$j,date,cat,taricID,tariID,oerowid)=papname_"^"_taricDesc_"^"_tariDesc_"^"_qty_"^"_price_"^"_total_"^"_job_"^"_date_"^"_time_"^"_ybzfbl_"^"_uomDesc
  s daten="",olddate="",ZAllZfSum="",ZAllQZFSum=""
  f  s daten=$o(^TMP("DHCIPBill","DailyDetail",$j,daten)) q:daten=""  d
  .i (daten'=olddate) d 
  ..s olddate=daten
  ..s taricDesc="-----------",tariDesc="-------------"_daten_"--------------",qty="----------",price="------",total="------------",time="------",ybzfbl="-----",date="------",uomDesc="------"
  ..d OutputRow4
  ..s papname="",price=""
  ..s taricDesc="分类",tariDesc="收费项目名称",qty="数量",uomDesc="单位",price="单价 ",total="金额  ",time="时间",ybzfbl="-----",date="日期",ybzfbl="自付"
  ..d OutputRow4
  ..s papname=""
  .s catn=""
  .f  s catn=$o(^TMP("DHCIPBill","DailyDetail",$j,daten,catn)) q:catn=""  d
  ..s taricIDn="",oldtaricDesc="",XJSum="",AllZfSum="",AllQZFSum=""
  ..f  s taricIDn=$o(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn)) q:taricIDn=""  d
  ...s tariIDn="",catsum=0,catzfsum="",catallzfsum=""
  ...f  s tariIDn=$o(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn,tariIDn)) q:tariIDn=""  d
  ....;s papname=$p(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn,tariIDn),"^",1)
  ....s oerowidn=""
  ....f  s oerowidn=$o(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn,tariIDn,oerowidn)) q:oerowidn=""  d
  .....s taricDesc=$p(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn,tariIDn,oerowidn),"^",2)
  .....s tariDesc=$p(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn,tariIDn,oerowidn),"^",3)
  .....s qty=$p(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn,tariIDn,oerowidn),"^",4)
  .....s uomDesc=$p(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn,tariIDn,oerowidn),"^",11)
  .....s price=$p(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn,tariIDn,oerowidn),"^",5)
  .....s total=$p(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn,tariIDn,oerowidn),"^",6)
  .....s job=$p(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn,tariIDn,oerowidn),"^",7)
  .....s date=$p(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn,tariIDn,oerowidn),"^",8)
  .....s time=$p(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn,tariIDn,oerowidn),"^",9)
  .....s ybzfbl=$p(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn,tariIDn,oerowidn),"^",10)
  .....//s allybzfbl=$p(^TMP("DHCIPBill","DailyDetail",$j,daten,catn,taricIDn,tariIDn,oerowidn),"^",12)
  .....s catsum=catsum+total
  .....s XJSum=+XJSum+total
  .....s catzfsum=catzfsum+ybzfbl
  .....s catallzfsum=0  //catallzfsum+allybzfbl
  .....s AllZfSum=+$g(AllZfSum)+ybzfbl
  .....s AllQZFSum=0  //+$g(AllQZFSum)+allybzfbl
  .....s ZAllZfSum=+$g(ZAllZfSum)+ybzfbl
  .....s ZAllQZFSum=0  //+$g(ZAllQZFSum)+allybzfbl 
  .....s ybzfbl=$j(ybzfbl,3,2)
  .....s allybzfbl=0  //$j(allybzfbl,3,2)
  .....s AllZfSum=$j(AllZfSum,3,2)
  .....s AllQZFSum=$j(AllQZFSum,3,2)
  .....s ZAllZfSum=$j(ZAllZfSum,3,2)
  .....s ZAllQZFSum=$j(ZAllQZFSum,3,2)
  .....s catzfsum=$j(catzfsum,3,2)
  .....s catallzfsum=$j(catallzfsum,3,2)
  .....i (oldtaricDesc'=taricDesc) d  
  ......s oldtaricDesc=taricDesc
  .....e  s taricDesc=""
  .....d OutputRow4
  ....s papname=""  ; 2005-12-22
 ...s papname="",taricDesc="",taricode="",tariDesc="",qty="[小计]",uomDesc="------",price="",total=$j(catsum,3,2),discount="",ybzfbl=catzfsum,date="",time=""
 ...Do OutputRow4
 .s papname="",taricDesc="合计",taricode="",tariDesc="",qty="",uomDesc="",price="",total=$j(XJSum,3,2),discount="",ybzfbl=AllZfSum,date="",time=""
 .Do OutputRow4
 q:+sum=0 gnum
 s papname="",taricDesc="-----------",taricode="",tariDesc="------------------------------------------------",qty="----------",uomDesc="------",price="------",total="------------",discount="",time="------",ybzfbl="-----",date="------"
 Do OutputRow4
 s papname="",taricDesc="总计",taricode="",tariDesc="",qty="",uomDesc="",price="",total=$j(sum,3,2),discount="",time="",ybzfbl=ZAllZfSum,date="" ,allybzfbl=""  //ZAllQZFSum
 k ^TMP("DHCIPBill","DailyDetail",$j)
 Do OutputRow4
 s papname="",taricDesc="预缴款",tariDesc=$j(deposit,3,2)_"("_"总费用"_$j(patfee,3,2)_" 已结算:"_$j(paidfee,3,2)_")",qty="押金余额",uomDesc=$j((deposit-patfee+paidfee),3,2),ybzfbl="" ,allybzfbl=""
 s price="",total="",date="",time="",discount="" 
 ;s papname="",taricDesc="预缴款",tariDesc=$j(deposit,3,2),qty="费用",uomDesc=$j(patfee,3,2)_"(已结算"_$j(paidfee,3,2)_")",ybzfbl="",allybzfbl=""
 ;s price="",total="",date="余额",time=$j((deposit-patfee+paidfee),3,2),discount="" 
OutputRow4
	i code="NingBo_MingZhou" d
	.i (admreason="鄞州农保")||(admreason="宁波市保")  d
	..i (price'="统筹费用")&(price'="") s price=$j(price,6,4)
	.e  d
	..i (price'="自付费用")&(price'="") s price=$j(price,6,4)
	e  d
	.i (price'["--")&(price'="")&(price'="单价")  s price=$j(price,6,4)
	set Data=$lb(papname,taricDesc,tariDesc,qty,uomDesc,price,total,job,date,time,ybzfbl)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1 	
 	s gnum=gnum+1
 	i gnum=1 d
 	.i code="NingBo_MingZhou" d
 	..i (admreason="鄞州农保")||(admreason="宁波市保")  d
 	...s ^TMP("Details",$j,bq,papno,gnum)=taricDesc_"^"_tariDesc_"^"_qty_"^"_uomDesc_"^"_price_"^"_total_"^"_discount_"^"_papno_"^"_papname_"^"_$j(deposit,3,2)_"^"_$j(patfee,3,2)_"^"_$j(ybye,3,2)_"^"_"统筹金额:"_$j(patshare,3,2)_"^"_admreason
 	..e  d
 	...s ^TMP("Details",$j,bq,papno,gnum)=taricDesc_"^"_tariDesc_"^"_qty_"^"_uomDesc_"^"_price_"^"_total_"^"_discount_"^"_papno_"^"_papname_"^"_$j(deposit,3,2)_"^"_$j(patfee,3,2)_"^"_$j(deposit-patfee,3,2)_"^"_"自付金额:"_$j(patfee,3,2)_"^"_admreason
	.e  d
	..s ^TMP("Details",$j,bq,papno,gnum)=taricDesc_"^"_tariDesc_"^"_qty_"^"_uomDesc_"^"_price_"^"_total_"^"_date_"^"_time_"^"_discount_"^"_papno_"^"_papname_"^"_$j(deposit,3,2)_"^"_$j(patfee,3,2)_"^"_$j(deposit-patfee,3,2)_"^"_ybzfbl
	e  d
	.i code="NingBo_MingZhou" d
 	..s ^TMP("Details",$j,bq,papno,gnum)=taricDesc_"^"_tariDesc_"^"_qty_"^"_uomDesc_"^"_price_"^"_total_"^"_discount_"^"_papno_"^"_papname_"^"_""_"^"_""_"^"_""_"^"_ybzfbl
 	.e  d
 	..s ^TMP("Details",$j,bq,papno,gnum)=taricDesc_"^"_tariDesc_"^"_qty_"^"_uomDesc_"^"_price_"^"_total_"^"_date_"^"_time_"^"_discount_"^"_papno_"^"_papname_"^"_""_"^"_""_"^"_""_"^"_ybzfbl
 	quit
}

ClassMethod FindpapnameExecute(ByRef qHandle As %Binary, getwardid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s num=0
    s ind=1
    s admId=""      
    f  s admId=$o(^PAADMi("PAADM_Type","I",admId)) q:admId=""  d
     .q:'$d(^PAADM(admId))
     .s curWardId=$p(^PAADM(admId),"^",70)      
     .q:curWardId=""
     .q:curWardId'=getwardid     
     .;s admdate=$p(^PAADM(admId),"^",6)     
     .;q:admdate>enddate     
     .;s disdate=$p(^PAADM(admId),"^",17)     
     .;q:(disdate<enddate)&(disdate'="")     
     .s visitstatus=$p(^PAADM(admId),"^",20)
     .q:visitstatus=""
     .q:visitstatus'="A"
     .s papno=$p(^PAPER(+^PAADM(admId),"PAT",1),"^",1)
     .s papname=$p(^PAPER(+^PAADM(admId),"ALL"),"^",1)       
     .Do OutputRow5
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
OutputRow5
	set Data=$lb(papno,papname)
 	Set ^CacheTemp(repid,ind)=Data
 	s num=num+1
 	Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod FindpapnameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardExecute ]
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
}

ClassMethod FindpapnameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query Findpapname(getwardid As %String) As %Query(ROWSPEC = "papno:%String,papname:%String")
{
}

ClassMethod Computing(billno, frmdat, todat)
{
	;n (frmdat,todat,billno)
	i billno="" q 100
	i todat="" s todat=+$h
	i frmdat="" s frmdat=0
	s billno=+$g(billno),frmdat=$g(frmdat),todat=$g(todat)
	s pat=0,totsum=0,discsum=0,patsum=0,payorsum=0 
	f  s pat=$o(^DHCPB(billno,"O",pat)) q:pat=""  d
	.s detailid=0
	.f  s detailid=$o(^DHCPB(billno,"O",pat,"D",detailid)) q:detailid=""  s s=^(detailid) d
	..s totfee=0,discfee=0,patientfee=0,payorfee=0 
	..;yyx
	..s paidflag=$p(s,"^",14)
	..s totfee=$p(s,"^",7),dat=$p(s,"^",11)
	..s discfee=$p(s,"^",8)
	..s patientfee=$p(s,"^",10)
	..s payorfee=$p(s,"^",9)
	..i dat'>todat,dat'<frmdat  d
	...s totsum=totsum+totfee
	...s discsum=discsum+discfee
	...s patsum=patsum+patientfee
	...s payorsum=payorsum+payorfee 
	...i paidflag="P" s paidfee=paidfee+totfee
	q totsum_"^"_discsum_"^"_payorsum_"^"_patsum
}

ClassMethod FindpatExecute(ByRef qHandle As %Binary, getwardid As %String, stdate As %String, enddate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	i getwardid="" Set qHandle=$lb(0,repid,0) Quit $$$OK   //lrl
    i stdate["/" s stdate=$zdh(stdate,4)
    i enddate["/" s enddate=$zdh(enddate,4)
    s num=0
    s ind=1
    k ^TMP("IPBED",$j)
    s admId=""      
    f  s admId=$o(^PAADMi("PAADM_Type","I",admId)) q:admId=""  d
     .q:'$d(^PAADM(admId))
     .s curWardId=$p(^PAADM(admId),"^",70)      
     .q:curWardId=""
     .q:curWardId'=getwardid     
     .s admdate=$p(^PAADM(admId),"^",6)     
     .q:admdate>enddate     
     .s disdate=$p(^PAADM(admId),"^",17)     
     .q:(disdate<enddate)&(disdate'="") 
     .q:(disdate'="")&(disdate<+$H)    
     .s visitstatus=$p(^PAADM(admId),"^",20)
     .q:visitstatus=""
     .q:visitstatus="C"
     .s papno=$p(^PAPER(+^PAADM(admId),"PAT",1),"^",1)
     .s papname=$p(^PAPER(+^PAADM(admId),"ALL"),"^",1)
     .s bedrowid=$p(^PAADM(admId),"^",73)
     .q:bedrowid=""
     .i bedrowid'=""  d  
     ..s wardid=$p(bedrowid,"||",1),bedid=$p(bedrowid,"||",2)
     ..s bedname=$p(^PAWARD(wardid,"BED",bedid),"^",1)
     .i $Number(bedname)'=""  s bedname=$Number(bedname)
     .s ^TMP("IPBED",$j,bedname)=papno_"^"_papname_"^"_bedname
     i $d(^TMP("IPBED",$j)) d
     .s bedname=""
     .f  s bedname=$o(^TMP("IPBED",$j,bedname)) q:bedname=""  d
     ..s str=^TMP("IPBED",$j,bedname)
     ..Do OutputRowpat
     k ^TMP("IPBED",$j)
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
OutputRowpat
	set Data=$lb(str)
 	Set ^CacheTemp(repid,ind)=Data
 	s num=num+1
 	Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod FindpatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindpatExecute ]
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
}

ClassMethod FindpatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindpatExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query Findpat(getwardid As %String, stdate As %String, enddate As %String) As %Query(ROWSPEC = "papno:%String")
{
}

ClassMethod DepgroupExecute(ByRef qHandle As %Binary, DepGroup) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    s rowid="0"
    for  s rowid=$o(^RBC("DEP",rowid)) q:rowid=""  d
    .s type=$p(^RBC("DEP",rowid),"^",2)
    .q:(type'[DepGroup)&(DepGroup'="")
    .Do OutputRowDe
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDe
	set Data=$lb(type,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod DepgroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DepgroupExecute ]
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

ClassMethod DepgroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DepgroupExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query Depgroup(DepGroup) As %Query(ROWSPEC = "type:%String,rowid:%String")
{
}

ClassMethod getwarddesc(itmjs As %Library.String = "", itmjsex As %Library.String = "", wardid)
{
  s wardid=$g(wardid)
  q:(wardid="") "^"
  s rowid=""
  s rowid=$o(^PAWARD(0,"WARD_LocationDR",wardid,rowid))
  q:(rowid="") "^"
  s warddesc=$p(^PAWARD(rowid),"^",2)
  i $f(warddesc,"-")'=0  d
  .s warddesc=$p(warddesc,"-",2)
  s str=rowid_"^"_warddesc
  q str
}

ClassMethod get3859(papno)
{
  s papmi=$o(^PAPERi("PAPMI_PatNo","385900","")) ;papmi_rowid
   s papname=$p(^PAPER(papmi,"ALL"),"^",1)      ;病人姓名
   s admId=0
 
  f  s admId=$o(^PAPERdr(papmi,"ADM","I",admId)) q:admId=""  d  ;取住院病人admId
  .q:'$d(^PAADM(admId))
  .s bill=0
  .s oeqty=0,patfee=0,patshare=0,paidfee=0
  .f  s bill=$o(^DHCPB(0,"ADM",admId,bill)) q:bill=""  d  ;根据病人取帐单号
  ..s sub="0"
  ..f  s sub=$o(^DHCPB(bill,"O",sub)) q:sub=""  d
  ...s arcim=$p(^DHCPB(bill,"O",sub),"^",3)
  ...s order=$p(^ARCIM(arcim,1),"^",2)
  ...s billqty=$p(^DHCPB(bill,"O",sub),"^",5)
  q
}

ClassMethod GetOrder(BillNo, pboSub)
{
    s arcimid=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",3)
    s DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(arcimid)
    s:DrugCommonDesc'="" orddesc=$g(DrugCommonDesc)
    s itemcat=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),1),"^",10)
	s ordcatid=$p(^ARC("IC",itemcat),"^",8)
	s ordcatdesc=$p(^OEC("ORCAT",ordcatid),"^",2)
	s orddesc=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),1),"^",2)
	s ordprice=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",7)
	s ordbillqty=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",5)
	s ordrefqty=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",6)
	s ordqty=ordbillqty+ordrefqty
	s ordtot=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",8)
	s uomId=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),8),"^",14)
	s uomDesc=$p(^CT("UOM",uomId),"^",2)
	s oerowid=$p($g(^DHCPB(+bill,"O",order)),"^",4)
    d ..GetBabyFlag(oerowid)
	i admmotflag'="" s orddesc=orddesc_"("_"婴儿"_")"
    i billstatus="P" s orddesc=orddesc_"("_"已结算"_")"
	i (hbflag="1") d
     .i $d(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice)) d
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice),"^",1)=$p($g(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice)),"^",1)+ordqty
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice),"^",2)=$p($g(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice)),"^",2)+ordtot
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice),"^",3)=uomDesc
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice),"^",4)=""
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice),"^",5)=ybzfbl
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice),"^",6)=admmotflag
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice),"^",7)=billstatus
    e  d
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice),"^",1)=ordqty
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice),"^",2)=ordtot
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice),"^",3)=uomDesc
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice),"^",4)=""
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice),"^",5)=ybzfbl
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice),"^",6)=admmotflag
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,ordprice),"^",7)=billstatus
   i (hbflag="0") d
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,oerowid,+ordprice),"^",1)=ordqty
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,oerowid,+ordprice),"^",2)=ordtot
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,oerowid,+ordprice),"^",3)=$zd(billdate,3)
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,oerowid,+ordprice),"^",4)=$zt(billtime,1)
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,oerowid,+ordprice),"^",5)=ybzfbl
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,oerowid,ordprice),"^",5)=ybzfbl
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,oerowid,ordprice),"^",6)=admmotflag
     ..s $p(^mtemp($j,"Detail",+RegNo,"ItemCat",ordcatid,arcimid,oerowid,ordprice),"^",7)=billstatus

  q
}

ClassMethod GetDetail(BillNo, pboSub, Itm)
{
   
    s oerowid=$p($g(^DHCPB(+bill,"O",order)),"^",4)
    d ..GetBabyFlag(oerowid)
    s Tmp=^DHCPB(+BillNo,"O",pboSub,"D",Itm)
    s taritm=$p(Tmp,"^",3)   ;PBD_TARI_DR,收费项目住院分类
    q:'$d(^DHCTARI(taritm))
    s tariDesc=$p(^DHCTARI(taritm),"^",2)  ;收费项目名称
    i admmotflag'="" s tariDesc=tariDesc_"("_"婴儿"_")"
    i billstatus="P" s tariDesc=tariDesc_"("_"已结算"_")"
    s ybzfbl="",insustr=""
    i code="ShaoGuan_YueBei"  d
     .s insustr=##class(web.INSUDivideSgSvr).GetCont(taritm, admreadesc)
     .i insustr=""  s ybzfbl=""
     .i insustr'=""  s ybzfbl=+$p(insustr,"^",19)
     .s taricode=""
     .s taricode=$p(^DHCTARI(taritm),"^",1)  ;收费项目代码
     .if PackStr'="" d
     ..s ^mtemp($j,"PackNum",taritm)=$G(^mtemp($j,"PackNum",taritm))+$P(PackStr,"|")
     ..s ^mtemp($j,"PackUom",taritm)=$P(PackStr,"|",2)
    i $d(^OEORD(+oerowid,"I",$p(oerowid,"||",2),2)) s billdesc=$p(^OEORD(+oerowid,"I",$p(oerowid,"||",2),2),"^",12)
    i billdesc'=""  d
    .s tariDesc=billdesc
    e  d
    .s arcim=$p($g(^DHCPB(+bill,"O",order)),"^",3)
    .s DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(arcim)
    .s:DrugCommonDesc'="" tariDesc=$g(DrugCommonDesc)
    .i code="NingBo_MingZhou"  d
    ..s tariDesc=taricode_" "_tariDesc
    .s arcgrp=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)          ;子类arc_itemcat
    .s catgrp=$p(^ARC("IC",arcgrp),"^",8) ;OEC_OrderCategory
    .s catgrpdesc=$p(^OEC("ORCAT",catgrp),"^",2)
    .i ((catgrpdesc="检验")!(catgrpdesc="医技检查")) d
    ..s ordstatus=$p(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2),1),"^",13) ;oec_orderstatus
    ..s ordstatus=$p(^OEC("OSTAT",ordstatus),"^",1)
    ..;i ordstatus="V" s tariDesc=tariDesc_"(预收)"
    ..i ordstatus="V" s tariDesc=tariDesc
    i code="BEIJING_JSTYY" d
    .s:taric=27 taric=26
    s taricdesc=$p(^DHCTarC("TIC",taric),"^",2)  ;收费项目住院分类名称
    s date=$p(s,"^",11)   ;pbd_billdate
    s qty=$p(s,"^",5)     ;pbd_billqty
    s price=$j($p(s,"^",4),3,4)   ;pbd_unitprice
    s tot=$fn(price*qty,"",2)     ;pbd_totalamount
    s tariUom=$p(^DHCTARI(taritm),"^",3)  ;单位
    i tariUom'="" s uomDesc=$p(^CT("UOM",tariUom),"^",2) ;单位            
    ;f i=1:1:$g(^DHCICGRP) d    ;每个病人的每个分类的金额
    .;i $p(taricdesc,$c(1))=$p($p(^DHCICGRP(i),"#",1),$c(1)) d
    s ^catefee(+RegNo,taricdesc)=tot+^catefee(+RegNo,taricdesc)                 
    s sum=sum+tot   ;总计
    i (hbflag="1") d
     .i $d(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,price)) d
     ..s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,price),"^",1)=$p($g(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,price)),"^",1)+qty
     ..s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,price),"^",2)=$p($g(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,price)),"^",2)+tot
     ..s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,price),"^",3)=uomDesc
     ..s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,price),"^",4)=""
     ..s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,price),"^",5)=ybzfbl
     .e  d
     ..s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,price),"^",1)=qty
     ..s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,price),"^",2)=tot
     ..s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,price),"^",3)=uomDesc
     ..s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,price),"^",4)=""
     ..s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,price),"^",5)=ybzfbl
   i (hbflag="0") d
     .s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,oerowid,+price,billdate),"^",1)=+$p($g(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,oerowid,+price,billdate)),"^",1)+qty
     .s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,oerowid,+price,billdate),"^",2)=+$p($g(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,oerowid,+price,billdate)),"^",2)+tot
     .s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,oerowid,+price,billdate),"^",3)=$zd(billdate,3)
     .s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,oerowid,+price,billdate),"^",4)=$zt(billtime,1)
     .s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,oerowid,+price,billdate),"^",5)=ybzfbl
     .s $p(^mtemp($j,"Detail",+RegNo,"IPCat",taric,taritm,oerowid,+price,billdate),"^",6)=uomDesc
    q
}

ClassMethod GetBabyFlag(oerowid)
{
   s admmotflag=""
    s admorddr=$p(oerowid,"||",1)
    s admmotdr=$p(^OEORD(admorddr),"^",1)
    s admmotflag=$p(^PAADM(admmotdr),"^",75)
    q
}

}
