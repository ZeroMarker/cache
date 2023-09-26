Import SQLUser

/// Creator:bianshuai
/// CreateDate:2014-03-22
/// Descript:住院药房打印公共类
Class web.DHCSTPCHCOLLDSPPRN Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 住院发药打印明细
/// D ##class(%ResultSet).RunQuery("web.DHCSTPCHCOLLDSPPRN","QueryPhaCollDspDetail","57")
Query QueryPhaCollDspDetail(phac As %String) As websys.Query(ROWSPEC = "PatNo:%String,PatName:%String,PatSex:%String,BedNo:%String,PrescNo:%String,InciDesc:%String,DosQty:%String,Freq:%String,Qty:%String,Uom:%String,Sp:%Float,Instruction:%String,Duration:%String,StDate:%String,Manf:%String,Spec:%String,Amt:%Float,Generic:%String,FreqTime:%String,Confirms:%Float,ArcimUom:%String,DoseQty:%String,DoseUomDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryPhaCollDspDetailExecute(ByRef qHandle As %Binary, phac As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	i phac="" Quit $$$OK
	S result=..GetPhaCollDetailRunQian(phac) //wyx modify 去掉诊断否则对于有多个诊断的润乾打印报错
	s cnt=$p(result,"^",1)
	s pid=$p(result,"^",2) 

    i cnt'>0 Quit $$$OK

	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetail",pid,index))  q:index=""  d
	. s pack=""
	. f  s pack=$o(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetail",pid,index,pack)) q:pack=""  d
	. . s j=""
	. . f  s j=$o(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetail",pid,index,pack,j)) q:j=""  d
	. . . s mdata=^(j)
	. . . s PatNo=$p(mdata,"^",1)
	. . . s PatName=$p(mdata,"^",2)
	. . . s PatSex=$p(mdata,"^",3)
	. . . s BedNo=$p(mdata,"^",6)
	. . . s PrescNo=$p(mdata,"^",8)
	. . . s InciDesc=$p(mdata,"^",11)
	. . . s DosQty=$p(mdata,"^",14)
	. . . i (DosQty<1)&&($p(DosQty,".",1)="") s DosQty=0_DosQty
	. . . s Freq=$p(mdata,"^",15)
	. . . s Qty=$p(mdata,"^",16)
	. . . s Uom=$p(mdata,"^",17)
	. . . s Sp=$p(mdata,"^",18)
	. . . s Amt=$p(mdata,"^",20)
	. . . s Instruction=$p(mdata,"^",22)
	. . . s Duration=$p(mdata,"^",23)
	. . . s StDate=$p(mdata,"^",33)
	. . . s Inci=$p(mdata,"^",27)
	. . . s Manf=$p(mdata,"^",28)
	. . . s Spec=$p(mdata,"^",31)
	. . . s Generic=$p(mdata,"^",36)
	. . . s FreqTime=$p(mdata,"^",43)
	. . . s Confirms=$p(mdata,"^",44)
	. . . s ArcimUom=$p(mdata,"^",45)
	. . . s DoseQty=$p(mdata,"^",40)
	. . . i (DoseQty<1)&&($p(DoseQty,".",1)="") s DoseQty=0_DoseQty
	. . . s DoseUomDesc=$p(mdata,"^",41)
	. . . s Qty=##Class(web.DHCSTPCHCOLLPRN).getPackQty(Inci,Qty)  //大包装 数量+单位
	. . . i (Qty<1)&&($p(Qty,".",1)="") s Qty=0_Qty
	. . . S ListDataStr=PatNo_"^"_PatName_"^"_PatSex_"^"_BedNo_"^"_PrescNo_"^"_InciDesc_"^"_DosQty
    . . . S ListDataStr=ListDataStr_"^"_Freq_"^"_Qty_"^"_Uom_"^"_Sp_"^"_Instruction_"^"_Duration_"^"_StDate_"^"_Manf_"^"_Spec_"^"_Amt
	. . . s ListDataStr=ListDataStr_"^"_Generic_"^"_FreqTime_"^"_Confirms_"^"_ArcimUom_"^"_DoseQty_"^"_DoseUomDesc
	. . . S ListData=$LISTFROMSTRING(ListDataStr,"^")
	. . . Set Data=ListData
	. . . Set ^CacheTemp(repid,ind)=Data	
	. . . Set ind=ind+1
	d ..killTmpGlobal(pid)
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 住院发药打印明细
/// D ##class(%ResultSet).RunQuery("web.DHCSTPCHCOLLDSPPRN","QueryPhaCollDspDetailSum","57")
Query QueryPhaCollDspDetailSum(phac As %String, loguserid As %String = "") As websys.Query(ROWSPEC = "PatNo:%String,PatName:%String,PatSex:%String,BedNo:%String,PrescNo:%String,InciDesc:%String,DosQty:%String,Freq:%String,Qty:%String,Uom:%String,Sp:%Float,Instruction:%String,Duration:%String,StDate:%String,Manf:%String,Spec:%String,Amt:%Float,Generic:%String,FreqTime:%String,Confirms:%Float,ArcimUom:%String,DoseQty:%String,DoseUomDesc:%String,TimeDosingStr:%String,ArcimDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryPhaCollDspDetailSumExecute(ByRef qHandle As %Binary, phac As %String, loguserid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	i phac="" Quit $$$OK
	S result=..GetPhaCollDetailRunQian(phac) //wyx modify 去掉诊断否则对于有多个诊断的润乾打印报错
	s cnt=$p(result,"^",1)
	s pid=$p(result,"^",2) 

    i cnt'>0 Quit $$$OK

	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index))  q:index=""  d
	. s pack=""
	. f  s pack=$o(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,pack)) q:pack=""  d
	. . s oeori=""
	. . f  s oeori=$o(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,pack,oeori)) q:oeori=""  d
	. . .s indexinci=""
	. . .f  s indexinci=$o(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,pack,oeori,indexinci)) q:indexinci=""  d
	. . . .s mdata=^(indexinci)
	. . . .s PatNo=$p(mdata,"^",1)
	. . . .s PatName=$p(mdata,"^",2)
	. . . .s PatSex=$p(mdata,"^",3)
	. . . .s BedNo=$p(mdata,"^",6)
	. . . .s PrescNo=$p(mdata,"^",8)
	. . . .s InciDesc=$p(mdata,"^",11)
	. . . .s DosQty=$p(mdata,"^",14)
	. . . .i (DosQty<1)&&($p(DosQty,".",1)="") s DosQty=0_DosQty
	. . . .s Freq=$p(mdata,"^",15)
	. . . .s Qty=$p(mdata,"^",16)
	. . . .s Uom=$p(mdata,"^",17)
	. . . .s Sp=$p(mdata,"^",18)
	. . . .s Amt=$p(mdata,"^",20)
	. . . .s Instruction=$p(mdata,"^",22)
	. . . .s Duration=$p(mdata,"^",23)
	. . . .s StDate=$p(mdata,"^",33)
	. . . .s Inci=$p(mdata,"^",27)
	. . . .s Manf=$p(mdata,"^",28)
	. . . .s Spec=$p(mdata,"^",31)
	. . . .s Generic=$p(mdata,"^",36)
	. . . .s FreqTime=$p(mdata,"^",43)
	. . . .s Confirms=$p(mdata,"^",44)
	. . . .s ArcimUom=$p(mdata,"^",45)
	. . . .s PatAge=$p(mdata,"^",46)
	. . . .s weight=$p(mdata,"^",47)
	. . . .s DoseQty=$p(mdata,"^",40)
	. . . .i (DoseQty<1)&&($p(DoseQty,".",1)="") s DoseQty=0_DoseQty
	. . . .s DoseUomDesc=$p(mdata,"^",41)
	. . . .s TimeDosingStr=$p(mdata,"^",48)
	. . . .s:weight'="" weight=weight_""_"kg"
	. . . .s PatSex=PatSex_" "_PatAge_" "_weight ;将性别,年龄,体重连起来
	. . . .s Qty=##Class(web.DHCSTPCHCOLLPRN).getPackQty(Inci,Qty)  //大包装 数量+单位
	. . . .i (Qty<1)&&($p(Qty,".",1)="") s Qty=0_Qty
	. . . .s ArcimDesc=$p(mdata,"^",12)
	. . . .s ArcimDesc=$replace(ArcimDesc,Spec,"")
	. . . .s ArcimDesc=$replace(ArcimDesc,"[]","")
	. . . .i DoseQty="" s DoseUomDesc=""
	. . . .S ListDataStr=PatNo_"^"_PatName_"^"_PatSex_"^"_BedNo_"^"_PrescNo_"^"_InciDesc_"^"_DosQty
    . . . .S ListDataStr=ListDataStr_"^"_Freq_"^"_Qty_"^"_Uom_"^"_Sp_"^"_Instruction_"^"_Duration_"^"_StDate_"^"_Manf_"^"_Spec_"^"_Amt
	. . . .s ListDataStr=ListDataStr_"^"_Generic_"^"_FreqTime_"^"_Confirms_"^"_ArcimUom_"^"_DoseQty_"^"_DoseUomDesc_"^"_TimeDosingStr
	. . . .s ListDataStr=ListDataStr_"^"_ArcimDesc
	. . . .S ListData=$LISTFROMSTRING(ListDataStr,"^")
	. . . .Set Data=ListData
	. . . .Set ^CacheTemp(repid,ind)=Data	
	. . . .Set ind=ind+1
	. . . 
	. . 
	. 
	d ..killTmpGlobal(pid)
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 住院发药打印汇总
/// d ##class(%ResultSet).RunQuery("web.DHCSTPCHCOLLDSPPRN","QueryPhaCollDspTotal","159")
Query QueryPhaCollDspTotal(phac As %String) As websys.Query(ROWSPEC = "Code:%String,Desc:%String,Sp:%String,Uom:%String,Qty:%String,Amt:%String,Inci:%String,Manf:%String,DrugForm:%String,ResQty:%String,StkBin:%String,Generic:%String,Spec:%String,FacQty:%String,ArcimUom:%String,ExpDate:%String,BatNo:%String,patinfostr:%String,bedInciTotal:%Text,InciDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryPhaCollDspTotalExecute(ByRef qHandle As %Binary, phac As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	i phac="" Quit $$$OK
	S result=..GetPhaCollDetailRunQian(phac) //wyx modify 去掉诊断否则对于有多个诊断的润乾打印报错
	S cnt=$p(result,"^",1)
	S pid=$p(result,"^",2) 
    s locid=$p(^DHCPHAC(phac),"^",1)
    i cnt'>0 Quit $$$OK

	S index=""
	f  S index=$o(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspTotal",pid,index))  Q:index=""  D
	.s BatNo=""
	.f  S BatNo=$o(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspTotal",pid,index,BatNo))  Q:BatNo=""  D
	..S mdata=^(BatNo)
	..//S InciCode=$p(mdata,"^",1)
	..//S InciDesc=$p(mdata,"^",2)
	..//S Sp=$p(mdata,"^",3)
	..//S Uom=$p(mdata,"^",4)
	..S Qty=$p(mdata,"^",5)
	..//S Amt=$p(mdata,"^",6)
	..S Inci=$p(mdata,"^",7)
	..//S Manf=$p(mdata,"^",8)
	..//S DrugForm=$p(mdata,"^",9)
	..S ResQty=$p(mdata,"^",10)
	..//S StkBin=$p(mdata,"^",11)
	..//S Generic=$p(mdata,"^",12)
	..S Spec=$p(mdata,"^",13)
	..S FacQty=$p(mdata,"^",14)
	..s DoseUomDr=$p(mdata,"^",19)
	..s buom=+$p(^INCI(Inci,1),"^",10)  ; basic uom
    ..s buomdesc=$p(^CT("UOM",buom),"^",2)
    ..s Packflag=0
    ..s Packflag=..GetPackflag(Inci,locid)
    ..S Qty=##Class(web.DHCSTPCHCOLLPRN).getPackQty(Inci,Qty)  //大包装 数量+单位
    ..i (Qty<1)&&($p(Qty,".",1)="") s Qty=0_Qty
    ..S $p(mdata,"^",5)=Qty    //_buomdesc
    ..S ResQty=##Class(web.DHCSTPCHCOLLPRN).getPackQty(Inci,ResQty)  //大包装 数量+单位
    ..i (ResQty<1)&&($p(ResQty,".",1)="") s ResQty=0_ResQty
    ..S $p(mdata,"^",10)=ResQty   //_buomdesc
    ..s FacQty=##Class(web.DHCSTPCHCOLLPRN).getPackQty(Inci,FacQty)  //大包装 数量+单位
    ..i (FacQty<1)&&($p(FacQty,".",1)="") s FacQty=0_FacQty
    ..S $p(mdata,"^",14)=FacQty   //_buomdesc
	..s bedqtyinfo=""
	..s tmpindex=""
	..f  s tmpindex=$o(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","BedInciTotal",pid,Inci,tmpindex)) q:tmpindex=""  d
	...s bedqtydata=^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","BedInciTotal",pid,Inci,tmpindex)
	...s bedqty=$p(bedqtydata,"^",1)
	...//i $l($p(bedqty,".",2))>5 s bedqty=$fn(bedqty,"",5)
	...//床位数量应有单位,汇总为整包,按床可能为散包
	...s bedqty=##Class(web.DHCSTPCHCOLLPRN).getPackQty(Inci,bedqty)
	...s bedqty=..FmtQtyWithUom(bedqty)
	...s bedno=$p(tmpindex,"||",1)
	...i bedno="" s bedno=$p(tmpindex,"||",2)
	...s bedno="("_bedno_")"_bedqty
	...i bedqtyinfo="" s bedqtyinfo=bedno
	...e  s bedqtyinfo=bedqtyinfo_","_bedno
	..s InciDesc=$p(^INCI(Inci,1),"^",2)
	..s InciDesc=$replace(InciDesc,Spec,"")
	..s InciDesc=$replace(InciDesc,"[]","")
	..S ListDataStr=$p(mdata,"^",1,18)_"^"_bedqtyinfo_"^"_InciDesc
	..S ListData=$LISTFROMSTRING(ListDataStr,"^")
	..Set Data=ListData
	..Set ^CacheTemp(repid,ind)=Data	
	..Set ind=ind+1
	d ..killTmpGlobal(pid)
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 住院发药冲减退药打印
/// d ##class(%ResultSet).RunQuery("web.DHCSTPCHCOLLDSPPRN","QueryPhaCollResRetDetail","124")
Query QueryPhaCollResRetDetail(phacin As %String) As websys.Query(ROWSPEC = "PatNo:%String,PatName:%String,PatSex:%String,BedNO:%String,InciDesc:%String,Spec:%String,ReqQty:%String,ResQty:%String,RetReqNo:%String,ReservedPat:%String") [ SqlProc ]
{
}

ClassMethod QueryPhaCollResRetDetailExecute(ByRef qHandle As %Binary, phacin As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	i phacin="" Quit $$$OK

	q:phacin=""
	s pid=..NewPid()
	//d ..killTmpGlobal(pid)
	s i=0
	s main=$p(phacin,"B",1)
	s phactype=$p(^DHCPHAC(phacin),"^",12) 
	s ward=$p(^DHCPHAC(phacin),"^",4)     //病区
	s phaloc=$p(^DHCPHAC(phacin),"^",1)   //发药科室
	s:phaloc'="" phaloc=$p(^CTLOC(phaloc),"^",2)
	s:phaloc["-" phaloc=$p(phaloc,"-",2)
	s User=""
	s UserID=$p(^DHCPHAC(main),"^",5)   //发药人
	s:UserID'="" User=$p(^SSU("SSUSR",UserID),"^",2)
	s phadate=$p(^DHCPHAC(main),"^",2)
	s ch=0
	f  s ch=$o(^DHCPHAC(main,"I",ch))  q:ch=""  d
	.s data=^(ch)
	.s prescno=$p(data,"^",5)  //处方号
	.s bedcode=$p(data,"^",8)  //床号
	.s adm=$p(data,"^",3)
	.s tmp=..getPaNo(adm)
	.s pano=$p(tmp,"^",1)
	.s patname=$p(tmp,"^",2)
	.s patsex=$p(tmp,"^",3)

	.s sub=0
	.f  s sub=$o(^DHCPHAC(main,"I",ch,"B",sub))  q:sub=""  d
	..s phaitm=main_"||"_ch_"||"_sub
	..s Resid=""
	..f  s Resid=$o(^DHCPRES(0,"TypePointer","P",phaitm,Resid)) q:Resid=""  d
	...s phac=+phaitm
	...s phach=$p(phaitm,"||",2)
	...//s inci=$p(^DHCPHAC(phac,"I",phach),"^",4)
	...s inci=+$p(^DHCPHAC(main,"I",ch,"B",sub),"^",1)
	...s incicode=$p(^INCI(inci,1),"^",1)
	...s arcimid=$p(^INCI(inci,1),"^",3)
    ...s incidesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),8),"^",21)   //add by myq 20120522 北京同仁 取医嘱通用名
	...//s incidesc=$p(^INCI(inci,1),"^",2)
	...s spec=##class(web.DHCSTKUTIL).GetSpec(inci)  //规格
	...s ResChl=""
	...f  s ResChl=$o(^DHCPRES(0,"TypePointer","P",phaitm,Resid,ResChl)) q:ResChl=""  d
	....//一个发药记录可能有多个退药申请单
	....s pressub=""
    ....f  s pressub=$o(^DHCPRES(Resid,"DET",ResChl,"SUB",pressub),-1) q:pressub=""  d
    .....s phari=$p(^DHCPRES(Resid,"DET",ResChl,"SUB",pressub),"^",1)
    .....s resqty=$p(^DHCPRES(Resid,"DET",ResChl,"SUB",pressub),"^",2) //冲减数量
    .....S resqty=##Class(web.DHCSTPCHCOLLPRN).getPackQty(inci,resqty)  //大包装 数量+单位
    .....i (resqty<1)&&($p(resqty,".",1)="") s resqty=0_resqty
    .....//s inclb=$p(^PHARET(phar),"^",6)
    .....s phar=+phari
    .....s pharsub=$p(phari,"||",2)
    .....s oeori=$p(^PHARET(phar,"I",pharsub),"^",1)
    .....s dodis=$p(^PHARET(phar,"I",pharsub),"^",13)
    .....s retadm=$p(^OEORD(+oeori),"^",1)
	.....s tmp=..getPaNo(retadm)
	.....s resedpatname=$p(tmp,"^",2)
	.....s phareqdr=$p(^PHARET(phar),"^",4)
    .....//q:'$D(^RETRQ(phareqdr))
    .....q:phareqdr=""
    .....s phareqno=""
	.....//s:phareqdr'="" phareqno=$p(^RETRQ(phareqdr),"^",1) //申请单号
    .....s reqqtys=0
    .....s lenreq=$l(phareqdr,",")	//bug修改，zhouyg 201609222
    .....f numreq=1:1:lenreq d
    ......s reqdr=$p(phareqdr,",",numreq)
    ......q:reqdr=""
    ......q:'$d(^RETRQ(reqdr))
    ......s reqno=$p($g(^RETRQ(reqdr)),"^",1)
    ......i phareqno="" s phareqno=reqno
    ......s phareqno=$s(phareqno[reqno:phareqno,1:phareqno_","_reqno)
	......s phareqch=""
	......f  s phareqch=$o(^RETRQ(reqdr,"I",phareqch)) q:phareqch=""  d
	.......s reqqty=$p(^RETRQ(reqdr,"I",phareqch),"^",3) //申请数量
	.......s reqoeori=$p(^RETRQ(reqdr,"I",phareqch),"^",1)
	.......q:reqoeori'=oeori
	.......s reqdodis=$p(^RETRQ(reqdr,"I",phareqch),"^",11)
	.......q:reqdodis'=dodis
	.......s reqqtys=reqqtys+reqqty
	.......S reqqtys=##Class(web.DHCSTPCHCOLLPRN).getPackQty(inci,reqqtys)  //大包装 数量+单位
	.......i (reqqtys<1)&&($p(reqqtys,".",1)="") s reqqtys=0_reqqtys
	.....i $d(^TMP("web","QueryPhaCollResRetDetail",pid,incicode)) d
	......s $p(^TMP("web","QueryPhaCollResRetDetail",pid,incicode),"^",7)=$p(^TMP("web","QueryPhaCollResRetDetail",pid,incicode),"^",7)+reqqtys
	......s $p(^TMP("web","QueryPhaCollResRetDetail",pid,incicode),"^",8)=$p(^TMP("web","QueryPhaCollResRetDetail",pid,incicode),"^",8)+resqty
	......s $p(^TMP("web","QueryPhaCollResRetDetail",pid,incicode),"^",9)=$p(^TMP("web","QueryPhaCollResRetDetail",pid,incicode),"^",9)_","_phareqno
	......s $p(^TMP("web","QueryPhaCollResRetDetail",pid,incicode),"^",10)=$p(^TMP("web","QueryPhaCollResRetDetail",pid,incicode),"^",10)_","_resedpatname
	.....e  d
	......s ^TMP("web","QueryPhaCollResRetDetail",pid,incicode)=pano_"^"_patname_"^"_patsex_"^"_bedcode_"^"_incidesc_"^"_spec_"^"_reqqtys_"^"_resqty_"^"_phareqno_"^"_resedpatname
	....
	....
    s code=""
    f  s code=$o(^TMP("web","QueryPhaCollResRetDetail",pid,code)) q:code=""  d
    .s ListDataStr=^TMP("web","QueryPhaCollResRetDetail",pid,code)
	.s ListResQty=$p(ListDataStr,"^",8)
	.s ListReqQtyS=$p(ListDataStr,"^",7)
	.i $l($p(ListResQty,".",2))>5 s $p(ListDataStr,"^",8)=$fn(ListResQty,"",5)	
	.i $l($p(ListReqQtyS,".",2))>5 s $p(ListDataStr,"^",7)=$fn(ListReqQtyS,"",5)	
	.S ListData=$LISTFROMSTRING(ListDataStr,"^")
	.Set Data=ListData
	.Set ^CacheTemp(repid,ind)=Data	
	.Set ind=ind+1
	d ..killTmpGlobal(pid)
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 住院发药库存不足药品打印
/// 使用PrintNoStock
/// D ##class(%ResultSet).RunQuery("web.DHCSTPCHCOLLDSPPRN","QueryPhaCollNoStockDetail","846487","10","0000000948","KFBY")
Query QueryPhaCollNoStockDetail(pid As %String, ward As %String, patno As %String, PhaType As %String) As websys.Query(ROWSPEC = "PatNo:%String,PatName:%String,PatSex:%String,BedNO:%String,InciDesc:%String,Spec:%String,Qty:%String,Uom:%String,Ward:%String,LocDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryPhaCollNoStockDetailExecute(ByRef qHandle As %Binary, pid As %String, ward As %String, patno As %String, PhaType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	i pid="" Quit $$$OK

  	q:pid=""
  	q:ward=""
  	q:patno=""
  	q:PhaType=""
  	s inci=""
	f  s inci=$o(^TMP("dhcpha","NOSTOCK","WARDPAT",pid,ward,patno,PhaType,inci)) q:inci=""  d
	.s data=^TMP("dhcpha","NOSTOCK","WARDPAT",pid,ward,patno,PhaType,inci)
	.s warddesc=$p(data,"^",2)
	.s adm=$p(data,"^",11)
    .s locdesc=$p(data,"^",12)
	.s bedcode=$p(data,"^",5)
	.s incidesc=$p(data,"^",4)
	.s qty=$p(data,"^",7)
	.s uomdesc=$p(data,"^",10)
	.s tmp=..getPaNo(adm)
	.s pano=$p(tmp,"^",1)
	.s patname=$p(tmp,"^",2)
	.s patsex=$p(tmp,"^",3)
	.s spec=##class(web.DHCSTKUTIL).GetSpec(inci)  //规格
       .
	.s ListDataStr=pano_"^"_patname_"^"_patsex_"^"_bedcode_"^"_incidesc_"^"_spec_"^"_qty_"^"_uomdesc_"^"_warddesc_"^"_locdesc	
	.S ListData=$LISTFROMSTRING(ListDataStr,"^")
	.Set Data=ListData
	.Set ^CacheTemp(repid,ind)=Data	
	.Set ind=ind+1
	//d ..killTmpGlobal(pid)
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:取发药明细信息(润乾打印组织数据调用去掉了诊断)
/// w ##class(web.DHCSTPCHCOLLDSPPRN).GetPhaCollDetailRunQian("106")
ClassMethod GetPhaCollDetailRunQian(main As %String) As %String
{
	q:main="" ""
	s panostr=""
	s tmpEncryptCode=0
	s phadate=""
	s pid=..NewPid()
	d ..killTmpGlobal(pid)
	s i=0
	s main=$p(main,"B",1)
	s pamstr=$p(main,"B",2)
	s paregno="",longord="",shortord=""
	i pamstr'="" d
	.s paregno=$p(pamstr,"^",1) 
	.s longord=$p(pamstr,"^",2)
	.s shortord=$p(pamstr,"^",3)
	s phactype=$p(^DHCPHAC(main),"^",12) 
	s disgType=$s(phactype="ZCY":"GC",1:"")
	s ward=$p(^DHCPHAC(main),"^",4)     //病区
	s phaloc=$p(^DHCPHAC(main),"^",1)   //发药科室
	s:phaloc'="" phaloc=$p(^CTLOC(phaloc),"^",2)
	s:phaloc["-" phaloc=$p(phaloc,"-",2)
	s User=""
	s UserID=$p(^DHCPHAC(main),"^",5)   //发药人
	s:UserID'="" User=$p(^SSU("SSUSR",UserID),"^",2)
	s phadate=$p(^DHCPHAC(main),"^",2)
	s HospID=$p($g(^CTLOC(phaloc)),"^",22)
	s ch=0
	f  s ch=$o(^DHCPHAC(main,"I",ch))  q:ch=""  d
	.s data=^(ch)
	.s adm=$p(data,"^",3)
	.s papmid=$p(^PAADM(adm),"^",1)
	.s patage=##class(PHA.FACE.IN.Com).GetAge(papmid,adm)
	.s mradmdr=$p(^PAADM(adm),"^",61)
	.s weight=$p(^MR(mradmdr,"PRO",1),"^",27)
	.s oestatus=$p(data,"^",10)
	.s admloc=$p(data,"^",11)
	.s dodis=$p(data,"^",13) //add by myq 20140527
	.s dodisnum=$l(dodis,",")
	.s dodistimestr="" //yunhaibao20161122,实际用药时间
	.s dodisi=0
	.f dodisi=1:1:dodisnum d
	..s tmpdodis=$p(dodis,",",dodisi)
	..q:tmpdodis=""
	..s dodisitime=$p($g(^DHCOEDISQTY(tmpdodis)),"^",20)
	..s dodisdate=$p($g(^DHCOEDISQTY(tmpdodis)),"^",21)
	..s dodisdate=$p($zd(dodisdate,3),"-",3)
	..q:dodisitime=""
	..s dodisitime=$zt(dodisitime,4)
	..i dodisitime["A" s dodisitime=+dodisitime_"a"
	..e  s dodisitime=+dodisitime_"p"
	..i dodistimestr="" s dodistimestr=dodisdate_"日 "_dodisitime
	..e  d
	...i $l(dodistimestr,",")<6 d
	....s dodistimestr=dodistimestr_","_dodisitime
	...e  d
	....i dodistimestr'["..." s dodistimestr=dodistimestr_"..."
	.i +admloc>0 s admloc=$p(^CTLOC(+admloc),"^",2)
	.i $f(admloc,"-") s admloc=$p(admloc,"-",2)
	.s oeori=$p(data,"^",7)
	.s ord=+oeori
	.s itm=$p(oeori,"||",2)
	.s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)
	.s sub=0
	.f  s sub=$o(^DHCPHAC(main,"I",ch,"B",sub))  q:sub=""  d
	..s resqty=$p(^DHCPHAC(main,"I",ch,"B",sub),"^",8)
	..s resqty=..ZeroPad(resqty)
	.s prescno=$p(data,"^",5)  //处方号
	.s bedcode=$p(data,"^",8)  //床号
	.i (ward'="")&&(ward'=$p(^PAADM(adm),"^",70)) s bedcode="转"
	.s warddesc=..getWardDesc(adm)
	.s tmp=..getPaNo(adm)
	.s pano=$p(tmp,"^",1)
	.q:(pano'=paregno)&&(paregno'="")
	.s patname=$p(tmp,"^",2)
	.s patsex=$p(tmp,"^",3)
	.;s patage=$p(tmp,"^",4)
	.s note=..GetNotes(oeori)
	.s tmp=..getOrdItm(oeori)
	.s arcimdesc=$p(tmp,"^",1)
	.s freq=$P(tmp,"^",3)
	.s dosqty=$ZCVT($P(tmp,"^",4),"l")
	.//s doseqty2=$p(tmp,"^",11)
	.s doseqty2=##class(web.DHCSTCOMMONORDER).OeoriDosage(oeori)
	.s doseuom2=$p(tmp,"^",12)
	.s packQty=$p(tmp,"^",13)
	.s doseuomdr=$p(tmp,"^",14)
	.s doctor=$P(tmp,"^",5)
	.s instruction=$P(tmp,"^",6)
	.s duration=$P(tmp,"^",7)
	.s freqRowid=$P(tmp,"^",8) //用药频率rowid
	.s Phcfactor=$p(^PHCFR(freqRowid),"^",2)  //add by myq 20140527 取phc_freq表的factor
	.s confirms=dodisnum/Phcfactor   //add by myq 20140527 取发药天数
	.s freqtime=##class(web.DHCSTKUTIL).GetFreqTimeByFreq(freqRowid) //add by myq 20140527
	.s ordsubcat=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)           //医嘱子类
	.s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcimid)
	.s drugform=$p(##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf(Phcdf),"^",2)	//剂型
	.s generic=$p(##class(web.DHCST.Common.DrugInfoCommon).GetGeneByPhcd(Phcdf),"^",2) 		//通用名
	.s moeori=##class(web.DHCSTKUTIL).GetMainOeori(oeori) //主医嘱
	.s seqno=$p(^OEORD(ord,"I",itm,3),"^",4)   //关联号
	.s orddate=$p(^OEORD(ord,"I",itm,3),"^",7)  //医嘱日期	
	.i orddate'="" s orddate=$zd(orddate,3)
	.s ordtime=$p(^OEORD(ord,"I",itm,1),"^",17) //医嘱时间	
	.i ordtime'="" s ordtime=$zt(ordtime,2)
	.s qtypackuom=$p(^OEORD(ord,"I",itm,9),"^",4)
	.s specinstr=$p(^OEORD(ord,"I",itm,2),"^",8) //草药备注
	.s padiagnose=""
	.s padiagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(adm,",",disgType) //诊断 
	.
	.s priority=..OrdItmPriority(oeori)
	.q:(longord=1)&(priority'="长期医嘱")
	.q:(shortord=1)&(priority="长期医嘱")
	.q:(shortord=1)&(priority="出院带药")
	.s pr=$$PrGrpRQ(oeori) 
	.i phactype="ZCY" d
	..s que=..Getpaque(prescno) //lq 2008-03-05 取中草药处方信息
	..s emergency=..GetEmergency(prescno)
	.;-----------中草药-----------
	.s fac=..getPackUomConFac(ord,itm)
	.s freqfac=$p(^PHCFR(freqRowid),"^",2)
	.
	.i panostr="" d
	..s panostr=pano
	.e  d
	..s panostr=panostr_"&"_pano
	.s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmid,"")
 	.s EncryptCode=$p(EncryptLevelInfo,"^",3)
 	.i tmpEncryptCode<EncryptCode d
 	..s tmpEncryptCode=EncryptCode
 	
 	.s sub=0 
	.f  s sub=$o(^DHCPHAC(main,"I",ch,"B",sub))  q:sub=""  d
	..s inclb=$P(^DHCPHAC(main,"I",ch,"B",sub),"^",1)
	..s inci=+inclb
	..s ArcimUom="" //$p(^CT("UOM",ArcimUomDr),"^",2)
	..s incicode=$p(^INCI(inci,1),"^",1)
	..s incidesc=$p(^INCI(inci,1),"^",2) //取库存项名 psc
    ..s buom=..getUom(inci)
	..s qty=$P(^DHCPHAC(main,"I",ch,"B",sub),"^",2)
    ..s sp=$P(^DHCPHAC(main,"I",ch,"B",sub),"^",5)
    ..s amt=$P(^DHCPHAC(main,"I",ch,"B",sub),"^",6)
	..s puomID=$p($g(^INCI(inci,3)),"^",6)
	..s exStr=oeori_"^"
 	..s puomsp=##Class(web.DHCSTPRICE).GetSp(+inci,+phadate,puomID,HospID,"",exStr)   	//整包装价格 
	..s spec=##class(web.DHCSTKUTIL).GetSpec(inci)  									//规格
 	..s incib=$P(^INCI(inci,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
 	..s manf=$p(##class(web.DHCST.Common.DrugStkCommon).VendManfByIncIb(incib),"^",4)	//批次厂家
 	..s incil=inci_"||"_$p(inclb,"||",2)
 	..s stkbin=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","")	//货位码
 	..s stkbin=$p(stkbin,":",2)
	..s amtsingle=+dosqty*fac*sp
	..i amtsingle<1 s amtsingle=0_amtsingle
	..;------草药单付价格---------
	..i $d(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCYAmt",pid,pano,prescno)) d
	...S Amt=$p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCYAmt",pid,pano,prescno),"^",1)
	...S $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCYAmt",pid,pano,prescno),"^",1)=amtsingle+$p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCYAmt",pid,pano,prescno),"^",1)
	...S $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCYAmt",pid,pano,prescno),"^",2)=amt+$p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCYAmt",pid,pano,prescno),"^",2)
	..e  S ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCYAmt",pid,pano,prescno)=amtsingle_"^"_amt
	..;---------------------------
 	..s qtyfac=qty\freqfac  //数了几顿的药
 	..s i=i+1
 	..; 
	..s s1=pano_"^"_patname_"^"_patsex_"^"_patage_"^"_warddesc
	..s s2=bedcode_"^"_admloc_"^"_prescno_"^"_doctor_"^"_incicode
	..s s3=incidesc_"^"_arcimdesc_"^"_oestatus_"^"_dosqty_"^"_freq  //15
	..s s4=qty_"^"_buom_"^"_sp_"^"_puomsp_"^"_amt_"^"_$g(priority)
	..s s5=instruction_"^"_duration_"^"_moeori_"^"_seqno_"^"_note   //26
	..s s6=inci_"^"_$g(manf)_"^"_$g(drugform)_"^"_+$g(resqty)_"^"_$g(spec)
	..s s7=$g(stkbin)_"^"_$g(orddate)_" "_ordtime_"^"_$g(padiagnose)_"^"_$g(generic)  //36
	..s s8=$g(que)_"^"_ordsubcat_"^"_$g(emergency)_"^"_$g(qtyfac)_"^"_doseqty2_"^"_doseuom2
	..s s9=inci_"^"_freqtime_"^"_confirms_"^"_ArcimUom_"^"_patage_"^"_weight_"^"_dodistimestr
	..s datastr=s1_"^"_s2_"^"_s3_"^"_s4_"^"_s5_"^"_s6_"^"_s7_"^"_s8_"^"_s9
	..//------------------以下是明细 -------------------------
	..s index="BED"_bedcode_"^"_pano_"^"_pr
	..s:$g(packedCat)="" packedCat=##class(web.DHCSTPCHCOLLS).getPackedCat() //需分散整包装打印时,药品类别设置
	..i $f(packedCat,phactype)>0 d 
	...i qtypackuom="" d   //散包装医嘱
	....s ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetail",pid,index,"0",i)=datastr
	....i $d(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"0",oeori,inci)) d
	.....s tmpstr1=^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"0",oeori,inci)
	.....s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"0",oeori,inci),"^",16)=$p(tmpstr1,"^",16)+qty
	.....s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"0",oeori,inci),"^",44)=$p(tmpstr1,"^",44)+confirms
	.....s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"0",oeori,inci),"^",20)=$p(tmpstr1,"^",20)+amt
	.....s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"0",oeori,inci),"^",48)=$p(tmpstr1,"^",48)_$c(13,10)_dodistimestr
	....E  d
	.....s ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"0",oeori,inci)=datastr
	...e  d   //整包装医嘱
	....s ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetail",pid,index,"1",i)=datastr
	....i $d(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"1",oeori,inci)) d
	.....s tmpstr2=^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"1",oeori,inci)
	.....s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"1",oeori,inci),"^",16)=$p(tmpstr2,"^",16)+qty
	.....s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"1",oeori,inci),"^",44)=$p(tmpstr2,"^",44)+confirms
	.....s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"1",oeori,inci),"^",20)=$p(tmpstr2,"^",20)+amt
	.....s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"1",oeori,inci),"^",48)=$p(tmpstr2,"^",48)_$c(13,10)_dodistimestr
	....E  d
	.....s ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"1",oeori,inci)=datastr
	..//不分整散
	..i ($f(packedCat,phactype)=0)&&(phactype'="ZCY") d
	...s ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetail",pid,index,"0",i)=datastr
	...i $d(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"0",oeori,inci)) d
	....s tmpstr3=^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"0",oeori,inci)
	....s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"0",oeori,inci),"^",16)=$p(tmpstr3,"^",16)+qty
	....s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"0",oeori,inci),"^",44)=$p(tmpstr3,"^",44)+confirms
	....s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"0",oeori,inci),"^",20)=$p(tmpstr3,"^",20)+amt
	....s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"0",oeori,inci),"^",48)=$p(tmpstr3,"^",48)_$c(13,10)_dodistimestr
	...E  d
	....s ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid,index,"0",oeori,inci)=datastr
	..//中草药
    ..//wyx add 发药单位 2014-01-08
    ..s newqty=""
    ..s newunitdesc=""
    ..s basuomdr=+$p(^INCI(inci,1),"^",10)
    ..s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
    ..i dispuomdr'="" d
    ...s confac=##class(web.DHCSTCOMMONSRV).UOMFac(dispuomdr,basuomdr)
    ...s dispqty2=qty/confac
    ...s unit=$p($g(^CT("UOM",dispuomdr)),"^",2)
    ...s newqty=dispqty2
    ...s newunitdesc=unit
    ...//wyx add 发药单位 2014-01-08
    ..i (newqty'="")&&(newunitdesc'="") d
    ...s disqty=newqty
    ...s disuom=newunitdesc
    ..e  d
    ...s disqty=qty
    ...s disuom=buom
    ..//中草药
	..i phactype="ZCY" d
	...i $d(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCY",pid,pano,prescno)) d
	....S detailStr=$g(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCY",pid,pano,prescno))
	....S detailStr=detailStr_"&"_incidesc_"^"_disqty_"^"_disuom_"^"_dosqty_" "_specinstr
	....S ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCY",pid,pano,prescno)=detailStr
	...E  d
	....S mainStr=pano_"^"_patname_"^"_patsex_"^"_patage_"^"_warddesc_"^"_phaloc_"^"_User
	....S mainStr=mainStr_"^"_bedcode_"^"_admloc_"^"_prescno_"^"_doctor_"^"_padiagnose_"^"_$g(que)_"^"_$g(qtyfac)
	....S mainStr=mainStr_"||"_incidesc_"^"_disqty_"^"_disuom_"^"_dosqty_" "_specinstr
	....S ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCY",pid,pano,prescno)=mainStr
	..//------------------以下是汇总 -------------------------
	..s incicodetmp=incicode
	..i stkbin'="" s incicode=stkbin_"_"_incicode //汇总按货位排序
	..s patinfostr=bedcode_"||"_patname  
	..i $d(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspTotal",pid,incicode,inci)) d
	...s tempstr=^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspTotal",pid,incicode,inci)
	...s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspTotal",pid,incicode,inci),"^",5)=$p(tempstr,"^",5)+qty
	...s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspTotal",pid,incicode,inci),"^",6)=$p(tempstr,"^",6)+amt
	...s resqty=+$g(resqty)
	...s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspTotal",pid,incicode,inci),"^",10)=$p(tempstr,"^",10)+resqty
	...s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspTotal",pid,incicode,inci),"^",14)=$p(tempstr,"^",14)+qty-resqty
	...s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspTotal",pid,incicode,inci),"^",18)=$p(tempstr,"^",18)_","_patinfostr //add wyx 2014-12-05组织某个药的床号及患者姓名 
	..e  d
	...s facqty=qty-resqty
	...s ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspTotal",pid,incicode,inci)=incicodetmp_"^"_incidesc_"^"_sp_"^"_buom_"^"_qty_"^"_amt_"^"_inci_"^"_$g(manf)_"^"_$g(drugform)_"^"_+$g(resqty)_"^"_$g(stkbin)_"^"_$g(generic)_"^"_$g(spec)_"^"_facqty_"^"_ArcimUom_"^"_""_"^"_""_"^"_patinfostr_"^"_doseuomdr
	..i '$d(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","BedInciTotal",pid,inci,patinfostr)) d
	...s ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","BedInciTotal",pid,inci,patinfostr)=qty_"^"_doseuomdr
	..e  d
	...s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","BedInciTotal",pid,inci,patinfostr),"^",1)=$p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","BedInciTotal",pid,inci,patinfostr),"^",1)+qty
	..
	.
	i phactype="ZCY" s i=$$ListpanoRQ()  ;中草药明细最大值
	q i_"^"_pid
PrGrpRQ(oedis)
	//根据医嘱优先级归类
	//长嘱:0
	//其他:1
	s pr=$p(^OEORD($p(oedis,"||",1),"I",$p(oedis,"||",2),1),"^",8)
	s pr=$P($g(^OECPR(pr)),"^",2)
	i pr="S" s pr=0
	e  s pr=1
	q $g(pr)
ListpanoRQ()
    ///准备草药方打印数据格式
    k ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailDspCY",pid)
	S num=0
	S pano=""
	f  S pano=$o(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCY",pid,pano)) q:pano=""  d
	.S prescno=""
	.f  S prescno=$o(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCY",pid,pano,prescno)) q:prescno=""  d
	..S mdata=$g(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCY",pid,pano,prescno))
	..S main=$p(mdata,"||",1)
	..S detail=$p(mdata,"||",2)
	..S main=main_"^"_$g(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCYAmt",pid,pano,prescno))
	..S num=num+1
	..S ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailDspCY",pid,num)=main_"||"_detail
	d ..killTmpGlobal(pid)
	q num
}

/// Descript:K掉临时Global
ClassMethod killTmpGlobal(pid)
{
	k ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailSum",pid)
	k ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetail",pid)
	k ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspTotal",pid)
	k ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCY",pid)
	k ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailCYAmt",pid)
	k ^TMP("dhcpha","NOSTOCK","WARDPAT",pid)
	k ^TMP("web","QueryPhaCollResRetDetail",pid)
	k ^TMP("dhcpha",pid,"WARD")
	k ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","BedInciTotal",pid)
}

/// Descript:取医嘱子分类ID
ClassMethod GetArcItmSubCat(inci As %String) As %String
{
	q:inci="" ""
	q:'$d(^INCI(inci,1)) ""
	s arcim=$p(^INCI(inci,1),"^",3)
	s sub=$p(arcim,"||",1)
	s ver=$p(arcim,"||",2)
	s arcic=$p(^ARCIM(sub,ver,1),"^",10) q:arcic="" ""
	q arcic
}

/// Descript:取库存项基本单位
ClassMethod getUom(inci As %String) As %String
{
	q:inci'>0 ""
	s uom=$p(^INCI(inci,1),"^",10)
	i +uom>0 s uom=$p(^CT("UOM",+uom),"^",2)
	q uom
}

/// Descript:取病区
ClassMethod getWardDesc(adm As %String) As %String
{
	q:adm="" ""
	q:'$d(^PAADM(+adm)) ""
	s ward=$p(^PAADM(adm),"^",70)
	q:ward="" ""
	q:'$d(^PAWARD(+ward)) ""
	s warddesc=$p(^PAWARD(+ward),"^",2)
	q warddesc
}

/// w ##class(web.DHCSTPCHCOLLDSPPRN).getPaNo("31")
ClassMethod getPaNo(adm As %String) As %String
{
	s papmi=$p(^PAADM(adm),"^",1)
	s papmi=+papmi
	i papmi>0 d
	  . &sql( select papmi_no,papmi_name,papmi_sex_dr->CTSEX_Desc,papmi_dob into :pano,:name,:sex,:dob from  pa_patmas where papmi_rowid=:papmi     )
	  . i $g(dob)>0 s dob=$zd(dob,3)
	s:dob'="" dob=$fn((+$h-$zdh(dob,3))/365,"",0)_"岁" //由出生日期->年龄
	q $g(pano)_"^"_$g(name)_"^"_$g(sex)_"^"_$g(dob)
}

ClassMethod getPackUomConFac(ord, itm)
{
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
	s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
	s phcdf=$p(^ARCIM(sub,ver,1),"^",12)
	s doseunit=$p(^OEORD(ord,"I",itm,2),"^",3)
	i doseunit'="" s doseunit=$p(^CT("UOM",doseunit),"^",2)
	q:phcdf="" ""
	&sql(select PHCDF_CTUOM_DR->ctuom_desc into :buom
		from phc_drgform where phcdf_rowid=:phcdf)
    s fac=##class(web.DHCSTCOMMONSRV).CTUOMFactor(doseunit,buom)
	q $g(fac)
}

/// w ##class(web.DHCSTPCHCOLLDSPPRN).OrdItmPriority("1||128")
ClassMethod OrdItmPriority(oeori As %String) As %String
{
	s ord=+oeori
	s itm=$p(oeori,"||",2)
	q:ord="" ""
	q:itm="" ""
	s pr=$p($g(^OEORD(ord,"I",itm,1)),"^",8)
	q:pr="" ""
	s priority=$P($g(^OECPR(pr)),"^",2)
	q priority
}

ClassMethod getOrdItmSttDate(ord As %String, itm As %String) As %String
{
 q:ord="" ""
 q:itm="" ""
 q:'$d(^OEORD(ord,"I",itm,1)) ""
 s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)
 i sttdate>0 s sttdate=$zd(sttdate,3)
 q sttdate
}

/// Descript:取医嘱时间lq
ClassMethod getOrdTime(oedis As %String) As %String
{
  s ord=$p(oedis,"||",1) q:ord="" ""
  s itm=$p(oedis,"||",2) q:itm="" ""
  q:'$d(^OEORD(ord,"I",itm,3)) ""
  s ordtime=$p(^OEORD(ord,"I",itm,1),"^",17)	
  i ordtime'="" s ordtime=$zt(ordtime,2)
  q $g(ordtime)
}

ClassMethod getOrdDate(oedis As %String) As %String
{
  s ord=$p(oedis,"||",1) q:ord="" ""
  s itm=$p(oedis,"||",2) q:itm="" ""
  q:'$d(^OEORD(ord,"I",itm,3)) ""
  s orddate=$p(^OEORD(ord,"I",itm,3),"^",7)	
  i orddate'="" s orddate=$zd(orddate,3)
  q $g(orddate)
}

/// Descript:zdm,2012-03-05,根据科室和库存项取货位
ClassMethod getItmStkBin(inci As %String, loc As %String) As %String
{
 q:loc="" ""
 q:inci="" ""
 s ch=$o(^INCI("IL_LOC",loc,inci,""))
 q:ch="" ""
 q:'$d(^INCI(inci,"IL",ch)) ""
 s stkbin=+$p(^INCI(inci,"IL",ch),"^",2)
 q:'$d(^INC("SB",stkbin)) ""
 s stkbindesc=$p(^INC("SB",stkbin),"^",2)
 q stkbindesc
}

/// Descript:获得中草药信息:急煎标志 
ClassMethod GetEmergency(prescno As %String) As %String
{
   s queid=""
   s questr=""
   s i=1
   f  s queid=$o(^PAQUE1(0,"PrescNo",prescno,queid)) q:queid=""  d
   .q:'$d(^PAQUE1(queid,"DHC")) 
   .s emergency=$p(^PAQUE1(queid,"DHC"),"^",22)
   .i emergency="Y" s emergency="(急煎)"
   .e  s emergency=""
   .s i=i+1
   q $g(emergency)
}

/// Descript:获得中草药信息 PA_Que1 
ClassMethod Getpaque(prescno As %String) As %String
{
   q:prescno="" ""
   s queid=""
   s questr=""
   s i=1
   f  s queid=$o(^PAQUE1(0,"PrescNo",prescno,queid)) q:queid=""  d
   .q:'$d(^PAQUE1(queid,"DHC")) 
   .s insdr=$p(^PAQUE1(queid,"DHC"),"^",11)
   .s Instruc=$p(^PHCIN(insdr),"^",1) ;用法
   .s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
   .s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
   .s orderqty=$p(^PAQUE1(queid,"DHC"),"^",13) ;用量
   .s quedate=$p(^PAQUE1(queid,"DHC"),"^",6) ;开始时间
   .s quexdate=quedate+facotor-1
   .i $g(quedate)'="" s quedate=$zd(quedate,3)
   .i $g(quexdate)'="" s quexdate=$zd(quexdate,3)
   .s preno=$p(^PAQUE1(queid),"^",14) ;处方号
   .s type=$p(^PAQUE1(queid,"DHC"),"^",15) ;方式
   .s notes=$p(^PAQUE1(queid,"DHC"),"^",21) ;备注
   .
   .s questr=Instruc_"^"_facotor_"^"_orderqty_"^"_$g(quedate)_"^"_$g(quexdate)_"^"_notes_"^"_type
   .s i=i+1
   q $g(questr)
}

ClassMethod GetOeoriAndSeqNo(oeori As %String) As %String
{
 q:oeori="" "^"
 s ord=$p(oeori,"||",1)
 s itm=$p(oeori,"||",2)
 q:ord="" "^"
 q:itm="" "^"
 s moeori=$P(^OEORD(ord,"I",itm,11),"^",39)
 i moeori="" s moeori=ord_"||"_itm
 s seqno=$p(^OEORD(ord,"I",itm,3),"^",4)
 q moeori_"^"_seqno
}

ClassMethod getOrdItm(oedis As %String) As %String
{
    q:oedis="" ""
	s ord=$p(oedis,"||",1),itm=$p(oedis,"||",2) q:ord="" "" q:itm="" ""
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
	s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2) q:sub="" "" q:ver="" ""
	s arcimdesc=$p(^ARCIM(sub,ver,1),"^",2)
	s doseqty=$p(^OEORD(ord,"I",itm,2),"^",1)
	s doseqty=..getPackUomDoseQty(ord,itm)
	;
	s ordstatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2) 
	s freq=$p(^OEORD(ord,"I",itm,2),"^",4)
	s freqRowid=freq
	i +freq>0 s freq=$ZCVT($p(^PHCFR(+freq),"^",3),"L")
	s doctor=$p(^OEORD(ord,"I",itm,1),"^",11)
	i +doctor>0 s doctor=$p(^CTPCP(+doctor,1),"^",2)
	s instruction=$p(^OEORD(ord,"I",itm,2),"^",7)
	i instruction'="" s instruction=$p(^PHCIN(+instruction),"^",2)
	s duration=$p(^OEORD(ord,"I",itm,2),"^",6)
	i duration'="" s duration=$p(^PHCDU(+duration),"^",3)
	s oepresno=$p(^OEORD(ord,"I",itm,"DEP",1),"^")
	s cyjyfs=$p(^OEORD(ord,"I",itm,2),"^",8)
	s doseqtyuom=..getBUomDoseQty(ord,itm)
	s doseuom=$p(^OEORD(ord,"I",itm,2),"^",3)
	s packQty=+$p(^OEORD(ord,"I",itm,9),"^",4)		//整包装数量
	q $g(arcimdesc)_"^"_$g(ordstatus)_"^"_$g(freq)_"^"_$g(doseqty)_"^"_$g(doctor)_"^"_$g(instruction)_"^"_$g(duration)_"^"_$g(freqRowid)_"^"_$g(oepresno)_"^"_$g(cyjyfs)_"^"_doseqtyuom_"^"_packQty_"^"_doseuom
}

ClassMethod getBUomDoseQty(ord, itm)
{
	//zdm,2010-11-12,徐州口服摆药单数量显示为一次用量
	//如果剂量单位和基本单位能够整除，转换为基本单位对应量
	//如果有小数，显示为原始剂
	s doseqty=$p(^OEORD(ord,"I",itm,2),"^",1)
	;get dose-equiv
	q:doseqty="" ""
	s doseqty=##class(web.DHCSTKUTIL).NN(doseqty)  ;调整数字（使小数点前的"0"能够显示）
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
	s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
	s phcdf=$p(^ARCIM(sub,ver,1),"^",12)
	s doseunit=$p(^OEORD(ord,"I",itm,2),"^",3)
	q:phcdf="" ""	
	&sql(select PHCDF_CTUOM_DR into :buom
		from phc_drgform where phcdf_rowid=:phcdf)
	s qty=doseqty
	s uom=doseunit
	i $g(buom)'=doseunit  d
	.s fac=..getEquivQty(phcdf,doseunit)
	.q:fac=""
	.i '$f(doseqty/fac,".") d
	..s qty=doseqty/fac
	..s uom=buom
	.
	s uomdesc=$p(^CT("UOM",uom),"^",2)
	q qty_"^"_uomdesc
}

ClassMethod getEquivQty(phcdf, doseUom)
{
	
	&sql(Select eq_qty into :doseequiv From PHC_FormDoseEquiv
	     Where EQ_ParRef=:phcdf and EQ_CTUOM_DR=:doseUom)
	q:SQLCODE'=0 ""
	s doseequiv=##class(web.DHCSTKUTIL).NN(doseequiv) 
	q $g(doseequiv)
}

/// Descript:取备注
ClassMethod GetNotes(moeori As %String) As %String
{
	Q:moeori="" ""
	s Notes=""
	S ord=$P(moeori,"||",1) Q:ord="" ""
	S itm=$P(moeori,"||",2) Q:itm="" ""
	f rnum=1:1:$G(^OEORD(ord,"I",itm,"DEP",0)) d
    .s Notes=Notes_$G(^OEORD(ord,"I",itm,"DEP",rnum))
    i $G(Notes)="" s Notes=""
    Q Notes
}

/// Creator:Liang Qiang
/// CreatDate:2009-09-0
/// Description:获取频率分发时间
/// Table: PHC_DispensingTime
/// Input: 频率Rowid
/// Output:
/// Return:频率分发时间
/// Othter:
ClassMethod GetFreqDispensingTime(Freqrowid As %String) As %String
{
	s TPHCDTTime=""
	s PHCDTTime=""
	s Plist=""
	s PHCDTChildSub=0
	f  s PHCDTChildSub=$o(^PHCFR(Freqrowid,"DT",PHCDTChildSub)) q:PHCDTChildSub=""  d
	.s TStr=^PHCFR(Freqrowid,"DT",PHCDTChildSub)
	.s TPHCDTTime=$p(TStr,"^",1)
	.s PHCDTTime=$zt(TPHCDTTime,1)
	.s Plist=Plist_","_PHCDTTime
	i Plist'="" s Plist=$p(Plist,",",2,$l(Plist,","))
	;w !,Plist
	q Plist
}

ClassMethod SetDispInfoByFreq(main, freqRowid, dispinfo, pid) As %String
{
	s phcdtimestr=..GetFreqDispensingTime(freqRowid)
	q:phcdtimestr="" ""
	s cnt=$l(phcdtimestr,",")
	s patno=$p(dispinfo,"^",1)
	s bed=$p(dispinfo,"^",6)
	s bed=+$g(bed)
	s name=$p(dispinfo,"^",2)
	s orditem=$p(dispinfo,"^",11)
	s orditem=$p(orditem,"*",1)
	s dispty=$p(dispinfo,"^",14)
	s ordstdate=$p(dispinfo,"^",34)
	s freq=$p(dispinfo,"^",15)
	s freq=$e(freq,2,$l(freq)-1)
	s ward=$p(^DHCPHAC(main),"^",4)
	s ordstr=orditem_"^"_dispty_"^"_freq
	;
	f i=1:1:cnt d
	.s phcdtime=$p(phcdtimestr,",",i)
	.s freqflag="00:00:00" s freqflag="必要时"
	.i phcdtime="08:00:00" s freqflag="早晨"
	.i phcdtime="12:00:00" s freqflag="中午"
	.i phcdtime="16:00:00" s freqflag="下午"
	.i phcdtime="20:00:00" s freqflag="晚间"
	.s adminfo=ward_"^"_patno_"^"_bed_"^"_name_"^"_ordstdate_"  "_freqflag
	.
	.i $d(^TMP("dhcpha",pid,"DispFreq",phcdtime,bed)) d
	..s ^TMP("dhcpha",pid,"DispFreq",phcdtime,bed)=^TMP("dhcpha",pid,"DispFreq",phcdtime,bed)_"@"_ordstr
	.e  d
	..s ^TMP("dhcpha",pid,"DispFreq",phcdtime,bed)=adminfo_"||"_ordstr
	..
	q 0
}

ClassMethod getPackUomDoseQty(ord, itm)
{
	s doseqty=$p(^OEORD(ord,"I",itm,2),"^",1)
	;get dose-equiv
	q:doseqty="" ""
	s doseqty=##class(web.DHCSTKUTIL).NN(doseqty)  ;调整数字（使小数点前的"0"能够显示）
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
	s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
	s phcdf=$p(^ARCIM(sub,ver,1),"^",12)
	s doseunit=$p(^OEORD(ord,"I",itm,2),"^",3)
	i doseunit'="" s doseunit=$p(^CT("UOM",doseunit),"^",2)
	q:phcdf="" ""
	q ..ZeroPad(doseqty)_doseunit
}

/// Descript:获取发药主信息
/// w ##class(web.DHCSTPCHCOLLDSPPRN).GetPhacMainData("84")
ClassMethod GetPhacMainData(phac) As %String
{
	Q:phac="" ""
	s pid=..NewPid()
	Q:'$d(^DHCPHAC(phac))
	S PhacType=$p(^DHCPHAC(phac),"^",12) 
	S WardID=$p(^DHCPHAC(phac),"^",4)     //病区
	s ch=$o(^DHCPHAC(phac,"I","")) 
	s adm=$p(^DHCPHAC(phac,"I",ch),"^",3) 
	s Ward=""
	I WardID'="" D
	.S Ward=$p(^PAWARD(WardID),"^",2)
	e  d
	.S Ward=##class(web.DHCSTPCHCOLLPRN).getUserDepartment(phac)
	.//s Ward=..getWardDesc(adm) //yunhaibao,20160311,取病人当前病区不对
	s:Ward["-" Ward=$p(Ward,"-",2)
	s:Ward["(" Ward=$p(Ward,"(",1)
	S PhaLoc=$p(^DHCPHAC(phac),"^",1)   //发药科室
	S:PhaLoc'="" PhaLoc=$p(^CTLOC(PhaLoc),"^",2)
	S:PhaLoc["-" PhaLoc=$p(PhaLoc,"-",2)
	s:PhaLoc["(" PhaLoc=$p(PhaLoc,"(",1)
	S CollDate=$p(^DHCPHAC(phac),"^",2)
	S:CollDate'="" CollDate=$zd(CollDate,3)
	s CollTime=$p(^DHCPHAC(phac),"^",3)
	s:CollTime'="" CollTime=$zt(CollTime)
	S UserID=$p(^DHCPHAC(phac),"^",5)
	S:UserID'="" CollUser=$p(^SSU("SSUSR",UserID),"^",2)
	S DispNo=$p(^DHCPHAC(phac),"^",14)
	S PhaType=$p(^DHCPHAC(phac),"^",12)
	s PhaTypeDesc=..GetPhaTypeDesc(PhaType)
	s Priority=..getPriority(phac)
	s PrnDate=+$h
	s:PrnDate'="" PrnDate=$zd(PrnDate,3)
	s PrnTime=$p($h,",",2)
	s:PrnTime'="" PrnTime=$zt(PrnTime,1)
	s PrnDateTime=PrnDate_" "_PrnTime
    
    s ch=0
	f  s ch=$o(^DHCPHAC(phac,"I",ch))  q:ch=""  d
	.s sub=0
	.f  s sub=$o(^DHCPHAC(phac,"I",ch,"B",sub)) q:sub=""  d
	..s data=^(sub)
	..s resqty=$p(data,"^",8)
	..s inclb=$p(data,"^",1)
	..s inci=+inclb
	..s incidesc=$p(^INCI(inci,1),"^",2)
	..//q:(resqty=0)||(resqty="") //yunhaibao,判断冲减明细是否需要打印,20160727
	..s exit=1
	..q:'$d(^DHCPRES(0,"TypePointer","P",phac_"||"_ch_"||"_sub))
	..s phaitm=phac_"||"_ch_"||"_sub
	..s Resid=""
	..f  s Resid=$o(^DHCPRES(0,"TypePointer","P",phaitm,Resid)) q:Resid=""  d
	...s ResChl=""
	...f  s ResChl=$o(^DHCPRES(0,"TypePointer","P",phaitm,Resid,ResChl)) q:ResChl=""  d
	....//一个发药记录可能有多个退药申请单
	....s pressub=""
    ....f  s pressub=$o(^DHCPRES(Resid,"DET",ResChl,"SUB",pressub),-1) q:pressub=""  d
    .....q:+pressub=0
    .....s exit=""
	..q:exit=1	
	..i $d(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","GetPhacMainData",pid,inci)) d
	...s $p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","GetPhacMainData",pid,inci),"^",2)=$p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","GetPhacMainData",pid,inci),"^",2)+resqty
	..e  d
	...s ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","GetPhacMainData",pid,inci)=incidesc_"^"_resqty
	
	s ResDetail=""
	s inci=""
	f  s inci=$o(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","GetPhacMainData",pid,inci)) q:inci=""  d
	.s incidesc=$p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","GetPhacMainData",pid,inci),"^",1)
	.s resqty=$p(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","GetPhacMainData",pid,inci),"^",2)
	.s:resqty'=0 resqty=##Class(web.DHCSTPCHCOLLPRN).getPackQty(inci,resqty) 
	.s:ResDetail'="" ResDetail=ResDetail_","_incidesc_"冲减"_resqty
	.s:ResDetail="" ResDetail=incidesc_"冲减"_resqty
	Q $g(Ward)_"^"_DispNo_"^"_CollDate_"^"_$g(CollUser)_"^"_PhaLoc_"^"_PhaTypeDesc_"^"_CollTime_"^"_Priority_"^"_PrnDateTime_"^"_ResDetail
}

/// Descript:获取发药主信息
/// w ##class(web.DHCSTPCHCOLLDSPPRN).CheckNoStock()
ClassMethod CheckNoStock(pid, PhacType) As %String
{
   //s ret=$o(^TMP("dhcpha","NOSTOCK","WARDPAT",pid,""))
   s SubStr=""
   s ret=""
   f  s SubStr=$o(^TMP("dhcpha",pid,"DispCat",PhacType,SubStr))  q:(SubStr="")||(ret'="")  d
   .s adm=$p(SubStr,"^",1)
   .s admward=$p(^PAADM(adm),"^",70)
   .s nameid=$p(^PAADM(adm),"^",1)
   .s name=$p(^PAPER(nameid,"ALL"),"^",1)
   .s patno=$p(^PAPER(nameid,"PAT",1),"^",1)
   .s OrdItmRowid=$p(SubStr,"^",3)
   .s DataStr=^TMP("dhcpha",pid,"DispCat",PhacType,SubStr)
   .s DspIdStr=$p(DataStr,"^",10)
   .q:$d(^TMP("dhcpha",pid,"D","Filter",DspIdStr)) ;过滤没有选择的医嘱
   .s ret=$o(^TMP("dhcpha","NOSTOCK","WARDPAT",pid,admward,patno,PhacType,""))
   .
   .
   q:ret="" 0
   q 1
}

/// Descript:重新获取组织的库存不足的病区
/// pid 组织发药数据的pid
/// w ##class(web.DHCSTPCHCOLLDSPPRN).GetWardDisp()
ClassMethod GetWardDisp(pid) As %String
{
  s ward=""
  f  s ward=$o(^TMP("dhcpha","NOSTOCK","WARDPAT",pid,ward)) q:ward=""  d
  .s patno=""
  .f  s patno=$o(^TMP("dhcpha","NOSTOCK","WARDPAT",pid,ward,patno)) q:patno=""  d
  ..i '$d(^TMP("dhcpha",pid,"WARD",ward)) d
  ...s ^TMP("dhcpha",pid,"WARD",ward)=patno
  ..e  s ^TMP("dhcpha",pid,"WARD",ward)=^TMP("dhcpha",pid,"WARD",ward)_"^"_patno
   s wardid=""
   s wardlist=""
   f  s wardid=$o(^TMP("dhcpha",pid,"WARD",wardid)) q:wardid=""  d
   .i wardlist="" s wardlist=wardid
   .e  s wardlist=wardlist_"^"_wardid
   
   q wardlist
}

/// Descript:重新获取组织的库存不足的病区的病人id串
/// pid 组织发药数据的pid
ClassMethod GetWardDispPatNo(pid, wardid)
{
  q $g(^TMP("dhcpha",pid,"WARD",wardid))
}

/// ///重新获取组织的库存不足的病区的病人id串的发药类别
/// pid 组织发药数据的pid
/// w ##class(web.DHCSTPCHCOLLDSPPRN).GetWardDispPatNoType()
ClassMethod GetWardDispPatNoType(pid, wardid, patnoid) As %String
{
   s type=""
   s catlist=""
   f  s type=$o(^TMP("dhcpha","NOSTOCK","WARDPAT",pid,wardid,patnoid,type)) q:type=""  d
   .i catlist="" s catlist=type
   .e  s catlist=catlist_"^"_type
   q catlist
}

ClassMethod GetPhaTypeDesc(PhaType)
{
	q:PhaType="" ""
	s PhaTypeDesc=""
	s PhaTypeid=$o(^DHCSTDRUGGRP(0,"Code",$$ALPHAUP^SSUTIL4(PhaType),""))
	s:PhaTypeid'="" PhaTypeDesc=$p(^DHCSTDRUGGRP(PhaTypeid),"^",2)
	q PhaTypeDesc
}

/// Descript:获取草药发药处方信息
ClassMethod getListDispDetailCY(pid, num) As %String
{
	Q $g(^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailDspCY",pid,num))
}

/// Descript:k掉临时global
ClassMethod killTmpGlobalCY(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPCHCOLLDSPPRN","DspDetailDspCY",pid)
	q ""
}

/// Descript:计数器
ClassMethod NewPid()
{
	Q $I(^DHCSTPHARMACY("RQPRINTDISP"))
}

ClassMethod getPriority(phac As %String) As %String
{
	///获取优先级  lq
 s tmppriority=""
 s priority=""
 s priorityflag=0
 s ch=""
 f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:(ch="")||(priorityflag=1)  d
 .s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)
 .s:priority'="" tmppriority=priority
 .s priority=..OrdItmPriority(oedis)
 .s:(tmppriority'="")&(tmppriority'=priority) priorityflag=1
 .s:priorityflag=1 priority=""
 
 q priority
}

/// Creator : MYQ
/// CreatDate : 20140613
/// Function : 根据库存项判断药品是否不可拆包装
/// Input : 库存项Id-inci
/// Ourput ： 不可拆包装-1 ； 可拆包装-0
/// w ##class(web.DHCSTPCHCOLLDSPPRN).GetPackflag("1762","484")
ClassMethod GetPackflag(inci, locid)
{
	q:inci="" 0
	q:locid="" 0
    s packflag=0
    s incId=""
    f  s incId=$o(^DHCWHSYPHALOC("LOC",locid,"INCI",incId)) q:(incId="")||(packflag=1)  d
    .s pack=$p(^DHCWHSYPHALOC("LOC",locid,"INCI",incId),"^",1)
    .s:(pack="N")&&(incId=inci) packflag=1
    q packflag
}

/// Lastupdate:yunhaibao20160121,拼串可能存在超长问题,本类中分多次直接传递数据
/// Others:dhcpha.pha.dispprintcom.js该类中根据返回串于js中调用
ClassMethod GetLogInfo(main) As %String
{
	q:main="" ""
	s logret=""
	s panostr=""
	s tmpEncryptCode=0
	s phadate=""
	s phadate=$p(^DHCPHAC(main),"^",2)
	s pid=..NewPid()
	s ch=0
	f  s ch=$o(^DHCPHAC(main,"I",ch))  q:ch=""  d
	.s data=^(ch)
	.s adm=$p(data,"^",3)
	.s papmid=$p(^PAADM(adm),"^",1)
	.s tmp=..getPaNo(adm)
	.s pano=$p(tmp,"^",1)
	.s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmid,"")
 	.s EncryptCode=$p(EncryptLevelInfo,"^",3)
 	.i tmpEncryptCode<EncryptCode d
 	..s tmpEncryptCode=EncryptCode
 	.s ^TMP("DHCSTPCHCOLLDSPPRN","GetLogInfo","PatNo",pid,pano)=""
 	s EncryptFlag=1 //##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
    i EncryptFlag=1 d
    .i $d(^TMP("DHCSTPCHCOLLDSPPRN","GetLogInfo","PatNo",pid)) d
    ..i phadate'="" s phadate=$zd(phadate,3)
	..s condition=##class(web.DHCSTCOMMONSRV).ChangeToJson("发药日期",phadate)
 	..s patno=""
	..s eventnum=##class(web.DHCSTCOMMONSRV).EventLogNum() //这是多少条记录传一次
	..s tmpeventcount=0
	..s patno="",patnostr=""
	..f  s patno=$o(^TMP("DHCSTPCHCOLLDSPPRN","GetLogInfo","PatNo",pid,patno)) q:patno=""  d
	...s tmpeventcount=tmpeventcount+1
	...i patnostr="" s patnostr=patno
	...e  s patnostr=patnostr_","_patno
	...i tmpeventcount#eventnum=0 d 
	....s content=##class(web.DHCSTCOMMONSRV).ChangeToJson("登记号",patnostr)
	....s eventlogret=##class(web.DHCSTCOMMONSRV).CreateEventLog("DHCDISPPHAPRT",condition,content,tmpEncryptCode)   //记录日志
	....s patnostr=""
	..i (tmpeventcount#eventnum'=0)&&(patnostr'="") d 
    ...s content=##class(web.DHCSTCOMMONSRV).ChangeToJson("登记号",patnostr)
    ...s eventlogret=##class(web.DHCSTCOMMONSRV).CreateEventLog("DHCDISPPHAPRT",condition,content,tmpEncryptCode)   //记录日志
 	k ^TMP("DHCSTPCHCOLLDSPPRN","GetLogInfo","PatNo",pid)
 	q ""
}

/// 补零
ClassMethod ZeroPad(enum) As %String
{
	q $j(enum,"",$l($p(enum,".",2)))
}

/// description: 转换发药数量,如果转换整包装为小数则以剂量单位为准
/// input:       库存项id,基本单位数量,剂量单位
/// w ##class(web.DHCSTPCHCOLLDSPPRN).ChangeDspQtyUom(834,0,151)
ClassMethod ChangeDspQtyUom(inciId, baseQty, doseUom) As %String
{
	s retQtyUom=""
	i (+baseQty<1)&&(+baseQty>0)&&(+doseUom'=0) d
	.s baseUom=+$p(^INCI(inciId,1),"^",10)
	.s bdFac=##class(web.DHCSTCOMMONSRV).UOMFac(baseUom,doseUom)
	.s doseUomDesc=$p(^CT("UOM",doseUom),"^",2)
	.s retQtyUom=(bdFac*baseQty)_doseUomDesc
	e  d
	.s retQtyUom=##Class(web.DHCSTPCHCOLLPRN).getPackQty(inciId,baseQty) 
	q retQtyUom
}

/// description:获取需要打印库存不足的发药类别是否存在数据
/// return :	Y(存在)
/// others:		该临时global在住院发药时记录
/// w ##class(web.DHCSTPCHCOLLDSPPRN).CheckPrintNoStock(1)
ClassMethod CheckPrintNoStock(Pid)
{
	k CheckPrintNoStockData
	q:Pid="" ""
	q:'$d(^TMP("DHCST","web.DHCINPHA.Disp.Save","SaveData","NoStock",Pid)) ""
	// 获取需要打印的发药类别的数据
	s drgGrpId=""
	f  s drgGrpId=$o(^DHCSTDRUGGRP(drgGrpId)) q:drgGrpId=""  d
	.q:+drgGrpId=0
	.s prtConfig=$g(^DHCSTPHACONFIG("PrintType",drgGrpId))
	.s prtNoStock=$p(prtConfig,"^",7)
	.q:prtNoStock'=1
	.s drgGrpCode=$p(^DHCSTDRUGGRP(drgGrpId),"^",1)
	.q:drgGrpCode=""
	.s CheckPrintNoStockData(drgGrpCode)=""
	i '$d(CheckPrintNoStockData) d
	.k ^TMP("DHCST","web.DHCINPHA.Disp.Save","SaveData","NoStock",Pid)
	q:'$d(CheckPrintNoStockData) ""
	s chkRet=""
	s dspId=""
	f  s dspId=$o(^TMP("DHCST","web.DHCINPHA.Disp.Save","SaveData","NoStock",Pid,dspId)) q:dspId=""  d
	.s dspCatCode=$p(^DHCOEDISQTY(dspId),"^",27)
	.i $d(CheckPrintNoStockData(dspCatCode)) s chkRet="Y"
	.e  k ^TMP("DHCST","web.DHCINPHA.Disp.Save","SaveData","NoStock",Pid,dspId)
	q chkRet
}

/// description: 打印库存不足
/// w ##class(%ResultSet).RunQuery("web.DHCSTPCHCOLLDSPPRN","PrintNoStock","D20181120P1063")
Query PrintNoStock(Pid) As websys.Query(ROWSPEC = "wardId,wardDesc,patNo,patName,patSex,bedNo,incId,incDesc,qty,uomDesc,spec,recLocDesc") [ SqlProc ]
{
}

ClassMethod PrintNoStockExecute(ByRef qHandle As %Binary, Pid) As %Status
{
	s ^TMPDHCSTPARAMS("web.DHCSTPCHCOLLDSPPRN","PrintNoStock")=$lb(Pid)
	k PrintNoStockData
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:Pid="" $$$OK
	// 汇总
	s dspId="" 
	f  s dspId=$o(^TMP("DHCST","web.DHCINPHA.Disp.Save","SaveData","NoStock",Pid,dspId)) q:dspId=""  d
	.s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
	.s wardLocId=$p(^DHCOEDISQTY(dspId),"^",22)
	.s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
	.s wardDesc=$p(^PAWARD(wardId),"^",2)
	.s admId=$p(^OEORD(+oeori),"^",1)
	.s patId=$p(^PAADM(admId),"^",1)
	.s patName=$p(^PAPER(patId,"ALL"),"^",1) 
	.s patNo=$p(^PAPER(patId,"PAT",1),"^",1) 
	.s bedNo=$p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(admId,wardLocId),"^",2)
	.i bedNo="" s bedNo="*"
	.s patSex=$p($g(^PAPER(patId,"ALL")),"^",7)
 	.s patSex=$p($g(^CT("SEX",+patSex)),"^",2)
	.s recLocId=$p($g(^DHCOEDISQTY(dspId)),"^",24)
	.s recLocDesc=$p(^CTLOC(recLocId),"^",2)
	.s dspSub=""
	.f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	..q:+dspSub=0
	..s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
	..s incId=$p(dspSubData,"^",5)
	..s qty=$p(dspSubData,"^",2)
	..i '$d(PrintNoStockData(wardId,patNo,incId)) d
	...s incDesc=$p(^INCI(incId,1),"^",2)
	...s uomId=$p(^INCI(incId,1),"^",10)
	...s uomDesc=$p(^CT("UOM",uomId),"^",2)
	...s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",incId)
	...s data1=wardId_"^"_wardDesc_"^"_patNo_"^"_patName_"^"_patSex
	...s data2=bedNo_"^"_incId_"^"_incDesc_"^"_qty_"^"_uomDesc
	...s data3=spec_"^"_recLocDesc
	...s data=data1_"^"_data2_"^"_data3
	...s PrintNoStockData(wardId,patNo,incId)=data
	..e  d
	...s $p(PrintNoStockData(wardId,patNo,incId),"^",9)=$p(PrintNoStockData(wardId,patNo,incId),"^",9)+qty
	..
	s wardId=""
	f  s wardId=$o(PrintNoStockData(wardId)) q:wardId=""  d
	.s patNo=""
	.f  s patNo=$o(PrintNoStockData(wardId,patNo)) q:patNo=""  d
	..s incId=""
	..f  s incId=$o(PrintNoStockData(wardId,patNo,incId)) q:incId=""  d
	...s data=PrintNoStockData(wardId,patNo,incId)
	...s ^CacheTemp(repid,ind)=$lfs(data,"^")    
	...s ind=ind+1
	k PrintNoStockData
	k ^TMP("DHCST","web.DHCINPHA.Disp.Save","SaveData","NoStock",Pid)
	Quit $$$OK
}

/// Description: 带单位的数量替换单位内的
/// w ##class(web.DHCSTPCHCOLLDSPPRN).FmtQtyWithUom("2盒(16)15粒(ml)")
ClassMethod FmtQtyWithUom(QtyUom)
{
	i QtyUom["(" d FmtStr("(",")")
	e  i QtyUom["[" d FmtStr("[","]")
	e  i QtyUom["（" d FmtStr("（","）")
	e  i QtyUom["【" d FmtStr("【","】")
	e  i QtyUom["{" d FmtStr("{","}")
	e  i QtyUom["{" d FmtStr("{","}")
	q QtyUom
FmtStr(St,Ed)
	s repStr=St_$p($p(QtyUom,St,2),Ed,1)_Ed
	s QtyUom=$replace(QtyUom,repStr,"")
	q
}

}
