Import sqluser

Class web.DHCOutPhOweList Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod QueryLocPatPYClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocPatPYExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocPatPYExecute(ByRef QHandle As %Binary, CDateSt, CDateEnd, ctloc, GPhw, CPmiNo, CPrint, CDisped, CRetruened, CPrescNo, CPatName, inci) As %Status
{

    Set repid=$I(^CacheTemp)
	s ind=1
	i ctloc=""	Set QHandle=$lb(0,repid,0)
	i ctloc=""  Quit $$$OK  
	//s phlloc=ctloc
	s phlloc=""
	f  s phlloc=$o(^DHCPHOWi("0","LOC",phlloc)) q:phlloc=""  d
	.q:ctloc'=phlloc
	.s papmi=""
	.f  s papmi=$o(^DHCPHOWi("0","LOC",phlloc,papmi)) q:papmi=""  d
	..s phorowid=""
	..f  s phorowid=$o(^DHCPHOWi("0","LOC",phlloc,papmi,phorowid)) q:phorowid=""  d
	...s owedate=$p(^DHCPHOW(phorowid),"^",3)
	...q:(CDateSt>owedate)!(CDateEnd<owedate)
	...i owedate'="" s owedate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(owedate)
	...s owetime=$p(^DHCPHOW(phorowid),"^",4)
	...i owetime'="" s owetime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(owetime)
	...s owedate=owedate_" "_owetime
	...s prescno=$p(^DHCPHOW(phorowid),"^",6)
	...q:(prescno'=CPrescNo)&&(CPrescNo'="")
	...s oweuser=""
	...s userdr=$p(^DHCPHOW(phorowid),"^",5)
	...s userdr=$p(^DHCPHPER(userdr),"^",5) 
	...i userdr'="" s oweuser=$p(^SSU("SSUSR",userdr),"^",2)
	...
	...s Str=##class(web.DHCOutPhCommon).GetHandTime(prescno)    //发票的日期时间
	...s prt=$p(Str,"^",4)
	...s invno=$p(Str,"^",5)
	...
	...s owestatus=$p(^DHCPHOW(phorowid),"^",8)
	...i owestatus="" s owestatusdesc="欠药"
	...i owestatus=1  s owestatusdesc="已配药"
	...i owestatus=2  s owestatusdesc="已发药"
	...i owestatus'="" s owestatusdesc="已发药"
	...q:(owestatus'="")&(CDisped'="1")
	...//q:(owestatus'=1)&(CPrint="1")
	...//q:(owestatus'=2)&(CDisped="1")
	...//q:(owestatus'="")&(CPrint'="1")&(CDisped'="1")
	...q:(owestatus="")&(CDisped="1")
	...s oweretdate=$p(^DHCPHOW(phorowid),"^",10)
	...i oweretdate'="" s owestatusdesc="已退药"
	...q:(CRetruened=0)&(oweretdate'="")&(CPrint'="1")&(CDisped'="1")
	...q:(CRetruened=1)&(oweretdate="")
	...
	...s phowsub="",iniflag=0
	...i inci'="" d
	....f  s phowsub=$o(^DHCPHOW(phorowid,"I",phowsub)) q:phowsub=""  d
	.....s orderid=$p(^DHCPHOW(phorowid,"I",phowsub),"^",1)
	.....s inc=$p(^DHCPHOW(phorowid,"I",phowsub),"^",4)
	.....i (inci'="")&(inci=$p(inc,"||",1)) s iniflag=1
	...q:(inci'="")&(iniflag=0)
	...
	...s ord=$o(^OEORD(0,"PrescNo",prescno,""))  q:ord=""
	...s adm=$p(^OEORD(ord),"^",1)
	...s papmidr=$p(^PAADM(adm),"^",1)
	...s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	...q:(papmino'=CPmiNo)&(CPmiNo'="")
	...s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
	...q:(patienname'[CPatName)&(CPatName'="")   
	...s patid=$p(^PAPER(papmidr,"ALL"),"^",9)
	...s patsex=""
	...s patsexdr=+$p(^PAPER(papmidr,"ALL"),"^",7)
	...i patsexdr'="" s patsex=$p(^CT("SEX",patsexdr),"^",2)
	...s patold=##class(web.DHCOutPhCommon).GetPatientAgeDesc(papmidr,adm)
	...s prtdate=""
	...s phar=$o(^DHCPHARi("PRESCNO",prescno,"")) 
	...s:phar'="" prtdate=$p(^DHCPHARW(phar),"^",2)
	...i prtdate'="" s prtdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(prtdate)
	...s prescmoney=##class(web.DHCOutPhCommon).GetOweListMoney(phorowid)
	...s money=$p(prescmoney,"^",1)
	...s presctype=$p(prescmoney,"^",2)
	...s patloc="",patlocdesc=""
	...s patloc=+$p(^PAADM(adm),"^",4)
	...s patlocdesc=$p(^CTLOC(patloc),"^",2)
	...i patlocdesc["-" s patlocdesc=$p(patlocdesc,"-",2)
	...s warddesc=""
	...s currwarddr=$p(^PAADM(adm),"^",70)
	...i currwarddr'="" d
	....s ctlocdr=$p(^PAWARD(currwarddr),"^",5)
	....s warddesc=$p(^CTLOC(ctlocdr),"^",2)
	....i warddesc["-" s warddesc=$p(warddesc,"-",2)
	....s patlocdesc=patlocdesc_"["_warddesc_"]"
	...s presctype=##class(web.DHCOutPhDisp).GetPrescType(prescno)
	...s pericd=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",")
	...s telno=$p(^PAPER(papmidr,"PER",1),"^",11)
	...s owedr=phorowid
	...s oweretdate=""
	...s oweretdate=$p(^DHCPHOW(owedr),"^",10)
    ...i oweretdate'="" s oweretdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(oweretdate)
    ...s owerettime=$p(^DHCPHOW(owedr),"^",11)
    ...i owerettime'="" s owerettime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(owerettime)
    ...s oweretuser=""
    ...s oweretuser=$p(^DHCPHOW(owedr),"^",12)
    ...i oweretuser'="" s oweretuser=$p(^DHCPHPER(oweretuser) ,"^",2)
    ...s phdrowid=""
    ...s phdrow=""
    ...f  s phdrow=$o(^DHCPHDISPi("PRESCNO",prescno,phdrow)) q:phdrow=""  d
    ....s tmpowedr=$p(^DHCPHDISP(phdrow,2),"^",2)
    ....q:tmpowedr'=phorowid
    ....s phdrowid=phdrow
    ...s EncryptLevelInfo=""
    ...s EncryptLevel=""
    ...s PatLevel=""
    ...s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
    ...i EncryptFlag=1 d
    ....s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,"")
 	....s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	....s PatLevel=$p(EncryptLevelInfo,"^",2)
	...d getdata
	..
	    
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK    
	    
getdata
    	     
    set Data=$lb(patienname,papmino,prtdate,invno,prt,prescno,money,patsex,patold,pericd,patlocdesc,presctype,telno,owedate,oweuser,owestatusdesc,owestatus,owedr,oweretdate,oweretuser,phdrowid,EncryptLevel,PatLevel)
    Set ^CacheTemp(repid,ind)=Data	
    Set ind=ind+1
    q
}

ClassMethod QueryLocPatPYFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocPatPYExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryLocPatPY(CDateSt, CDateEnd, ctloc, GPhw, CPmiNo, CPrint, CDisped, CRetruened, CPrescNo, CPatName, inci) As %Query(ROWSPEC = "TPatName:%String,TPmiNo:%String,TPrtDate:%String,TPrtInv:%String,TPrt:%String,TPrescNo:%String,TPrescMoney:%String,TPerSex:%String,TPerAge:%String,TMR:%String,TPerLoc:%String,TPrescType:%String,TCallCode:%String,TOweDate:%String,TOweUser:%String,TOweStatusdesc:%String,TOweStatus:%String,TOwedr:%String,TOweretdate:%String,TOweretuser:%String,Tphdrowid:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod QueryLocOutPatItmClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocOutPatItmExecute ]
{
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocOutPatItmExecute(ByRef QHandle As %Binary, GPhl, pho = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s HospitalCode=""
	s str=$g(^DHCDocConfig("CurrentHospital"))
	s HospitalCode=$p(str,"^",1)
	s ind=1
	s sysdate=""
	s phl=GPhl
	k QueryLocOutPatItmData
	i phl="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
	i pho="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s PID=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()
	s loginloc=$p(^DHCPHLOC(phl),"^",1)
	s phosub=""
	f  s phosub=$o(^DHCPHOW(pho,"I",phosub)) q:phosub=""  d
	.s orditem=$p(^DHCPHOW(pho,"I",phosub),"^",1)
	.s dispqty=$p(^DHCPHOW(pho,"I",phosub),"^",2)
	.s price=$p(^DHCPHOW(pho,"I",phosub),"^",3)
	.s dspsubid=$p(^DHCPHOW(pho,"I",phosub),"^",6)
	.q:dspsubid=""
	.s inci=$p(^DHCPHOW(pho,"I",phosub),"^",5)
	.s spamt=dispqty*price
	.s uniqueIndex=orditem_"^"_inci
	.i $d(QueryLocOutPatItmData(uniqueIndex)) d
	..s $p(QueryLocOutPatItmData(uniqueIndex),"^",2)=dispqty+$p(QueryLocOutPatItmData(uniqueIndex),"^",2)
	..s $p(QueryLocOutPatItmData(uniqueIndex),"^",3)=spamt+$p(QueryLocOutPatItmData(uniqueIndex),"^",3)
	.e  d
	..s QueryLocOutPatItmData(uniqueIndex)=orditem_"^"_dispqty_"^"_spamt_"^"_inci
	s uniqueIndex=""
	f  s uniqueIndex=$o(QueryLocOutPatItmData(uniqueIndex)) q:uniqueIndex=""  d
	.s uniqueData=QueryLocOutPatItmData(uniqueIndex)
	.s orditem=$p(uniqueData,"^",1)
	.s dispmoney=$p(uniqueData,"^",3)
	.s inci=$p(uniqueData,"^",4)
	.s dispqty=$p(uniqueData,"^",2)
	.s itm=$p(orditem,"||",2)
	.s ord=$p(orditem,"||",1)
	.s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	.s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2)       
	.s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditem,""))
	.s dspstate=$p(^DHCOEDISQTY(dsp),"^",7)
	.//q:oeflag["停"
	.s orddoctco=""
	.s orduser="",ordusertypedr="",ordusercare="",careprovtype="",userdoctype=""
	.s orddoctco=+$p($g(^OEORD(ord,"I",itm,1)),"^",11) ;??
	.s orduser=+$p($g(^OEORD(ord,"I",itm,7)),"^",1)
	.s username=""
	.s username=$p(^SSU("SSUSR",orduser),"^",2)
	.i orduser'=""  s ordusercare=$p(^SSU("SSUSR",orduser),"^",14)
	.i ordusercare'="" s careprovtype=$p(^CTPCP(ordusercare,1),"^",4)
	.i careprovtype'="" s userdoctype=$p(^CT("CPT",careprovtype),"^",4)
	.s doseqty="" s doseqty=##class(web.DHCSTCOMMONORDER).OeoriDosage(orditem) //$p($g(^OEORD(ord,"I",itm,2)),"^",1)
	.s unitdr="" s unitdr=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
	.s phfragdr="" s phfragdr=$p($g(^OEORD(ord,"I",itm,2)),"^",4)
	.s duratdr="" s duratdr=$p($g(^OEORD(ord,"I",itm,2)),"^",6)
	.s instrdr="" s instrdr=$p($g(^OEORD(ord,"I",itm,2)),"^",7)
	.s skinflag="",skintest=""
	.s skintest=$p(^OEORD(ord,"I",itm,5),"^",2)
	.i skintest["Y"  d
	..s skintest="Y"
	..s Abnormal=""
	..s Abnormal=$p(^OEORD(ord,"I",itm,11),"^",3)
	..i Abnormal["Y"  s skinflag="2"
	..i Abnormal["N"  s skinflag="1"
	.s unitdesc=""
	.i unitdr'="" s unitdesc=$p($g(^CT("UOM",unitdr)),"^",2)
	.s phuomid="",phuomdesc="",itmmastid="",itmmastver=""
	.s itmmastid=$p(itmmast,"||",1)
	.s itmmastver=$p(itmmast,"||",2)
	.s itmcat="",itmcatdesc="",syflag=""
	.s itmcat=+$p(^ARCIM(itmmastid,itmmastver,1),"^",10)
	.s itmcatdesc=$p(^ARC("IC",itmcat),"^",2)
	.i itmcatdesc["输液"  s syflag="1"
	.s drgform="",drgmast="",phtype=""
	.s drgform=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
	.s phcform="",phfact="",factdesc=""
	.i drgform'=""  d
	..s phcform=$p(^PHCD($p(drgform,"||",1),"DF",$p(drgform,"||",2),1),"^",1)
	..s phfact=$p(^PHCD($p(drgform,"||",1),2),"^",4)
	.e  d
	..s phcform="",phfact=""
	.i phfact="" d
	..s factdesc="" 
	.e  d
	..i '$d(^PHMNF(phfact)) d
	...s factdesc="" 
	..e  d
	...s factdesc=$p(^PHMNF(phfact),"^",2)  
	.i factdesc["-" s factdesc=$p(factdesc,"-",2)  
	.i drgform'="" s drgmast=$p(drgform,"||",1)
	.s jrflag=""
	.s ybcode=""
	.i drgmast'=""  d
	..s phtype=$p($g(^PHCD(drgmast,1)),"^",4)
	..s ybcode=$p(^PHCD(drgmast,4),"^",2)
	..i (ybcode'="")&&($d(^DHCITMIC(ybcode))) s ybcode=$p($g(^DHCITMIC(ybcode)),"^",2)
	.i phtype'="" d
	..s phtype=+phtype
	..s phtypedesc=""
	..q:'$d(^PHCPO(phtype))
	..s phtypedesc=$p(^PHCPO(phtype),"^",1)
	..
	..i phtypedesc["J2" s jrflag="2"
	..i phtypedesc["J1" s jrflag="1"
	.s dxsl="",dxunit=""
	.s dxrowid="0"
	.s dxrowid=$o(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid))
	.s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	.q:phuomid=""
	.s phuomid=$p(phuomid,$c(1),1)
	.s genric=""
	.s genric=$p(^ARCIM(itmmastid,itmmastver,8),"^",20)
	.s incTYdesc=""
	.i genric'="" s incTYdesc=$p(^PHCGE("GE",genric),"^",2)
	.s phbz="",bz=0,bb=0
	.s bz=$g(^OEORD(ord,"I",itm,"DEP",0))
	.f bb=1:1:bz  d
	..s phbz0=""
	..s phbz0=$g(^OEORD(ord,"I",itm,"DEP",bb))
	..s phbz=phbz_phbz0
	.i phbz="" s phbz=$p($g(^OEORD(ord,"I",itm,2)),"^",8)
	.s currdate=""
	.s cyyf=""
	.s cyyf=$p($g(^OEORD(ord,"I",itm,2)),"^",8)
	.s currdate=$p($h,",",1)
	.s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	.s sendflag=""
	.s reclocdr=loginloc // 检查登陆科室的库存,使用接受科实下面分组库存
	.s yppc="",inclb="",incib=""
	.s newclb="",bb=0,qtyend=0
	.s sdate="",qtyend=0,ldtrow=""
	.s qtyend=##class(web.DHCSTSTKQTY).GetIncilValidQty(inci,reclocdr,1)
	.i qtyend<dispqty s unflag="不够"
	.s incil="",yphw="",incstb=""
	.s incil=$o(^INCI("IL_LOC",reclocdr,inci,""))
	.s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(inci_"||"_incil,",","","") //可多货位
	.s stkchkflag=$p(stkbinret,":",1)
	.s yphw=$p(stkbinret,":",2)
	.s puruom="",puruomdesc="",basuom="",basuomdesc=""
	.s puruom=+$p(^INCI(inci,3),"^",6)
	.s puruomdesc=$p($g(^CT("UOM",puruom)),"^",2)
	.s basuom=+$p(^INCI(inci,1),"^",10)
	.s dxts=""
	.s basuomdesc=$p($g(^CT("UOM",basuom)),"^",2)
	.s jlflag=doseqty //_unitdesc
	.i dxrowid'=""  d
	..s dxsl=+$p(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid),"^",2) 
	..s dxunit=+$p(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid),"^",1) 
	..s dxundesc=""
	..//i dxunit'=0  d
	...//s dxundesc=$p($g(^CT("UOM",dxunit)),"^",2)
	...//s dxts=dxsl_dxundesc
	..//i unitdr=dxunit  d
	...//s doseqty=doseqty/dxsl
	...//i doseqty'["."  s jlflag=doseqty_basuomdesc
	.s phgg=##class(web.DHCOutPhDisp).GetPhgg(inci)
	.s confac=1,conrow=""
	.i basuom=phuomid s confac=1
	.e  d
	..s conrow=$o(^CT("CTCF",0,"UOM",phuomid,basuom,conrow))
	..i conrow'="" s confac=+$p(^CT("CTCF",conrow),"^",3)
	.s kcqty=0
	.s kcqty=qtyend/confac
	.s qty=0,newunit="",getnum=0,newunitdesc="",newprice=0
	.s getnum=$p((dispqty/confac),".",1)
	.i getnum="" s getnum=0
	.
	.s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
	.; 发药单位显示
	.i (dispuomdr'="")&(dispuomdr'=phuomid)&(dispuomdr'=basuom)  d
	..;w "发药单位",!
	..s Fac=##class(web.DHCSTCOMMONSRV).UOMFac(dispuomdr,basuom)
	..s newunit=dispuomdr
	..s newunitdesc=$p($g(^CT("UOM",dispuomdr)),"^",2)
	..s qty=dispqty/Fac
	..s newprice=price*Fac
	.e  d
	..i getnum=(dispqty/confac)  d
	...;w "入库单位",!
	...s newunit=phuomid
	...s newunitdesc=phuomdesc
	...s qty=getnum
	...s newprice=price*confac
	..e  d
	...;w "基本单位",!
	...s newunit=basuom
	...s newunitdesc=basuomdesc
	...s qty=dispqty
	...s newprice=price
	.s newprice=dispmoney/qty
	.s phdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
	.q:phdesc="" 
	.s duratdesc=""
	.i duratdr'="" s duratdesc=$p($g(^PHCDU(duratdr)),"^",3)
	.s phfragdesc=""
	.i phfragdr'="" s phfragdesc=$p($g(^PHCFR(phfragdr)),"^",3)
	.s instrdesc=""
	.i instrdr'="" s instrdesc=$p($g(^PHCIN(instrdr)),"^",2)
	.s orddoctnam=""
	.i orduser'="" s orddoctnam=$p(^SSU("SSUSR",orduser),"^",2)
	.s doctype=""
	.i userdoctype'["DOC"  d
	..;s jlflag="",phfragdesc="",instrdesc="",duratdesc="",orddoctnam="",username=""
	.s error="",t=0,cc=0,notes=""
	.s notes=$p(^OEORD(ord,"I",itm,2),"^",8)
	.s inclbid="",disstatu=""
	.//i newunitdesc["(" s newunitdesc=$p(newunitdesc,"(",1)
	.i t=0 s error="1"
	.s newprice=$fn(newprice,"",2)
	.s dispmoney=$fn(dispmoney,"",2)
	.i instrdesc["遵医嘱" s instrdesc=phbz
	.s doctcode=""
	.i (orddoctco'=0)&(orddoctco'="") d
	..s doctcode=$p(^CTPCP(orddoctco,1),"^",1)
	..s username=$p(^CTPCP(orddoctco,1),"^",2)
	.i HospitalCode["BJZLYY"  d
	..i phdesc["(" s phdesc=$p(phdesc,"(",1)
	..i phdesc["[" s phdesc=$p(phdesc,"[",1)
	.s ypmc=""
	.s ypmc=phdesc
	.i $g(cyflag)="1"  d
	..i ypmc["("  d
	...s ypmc=$p(ypmc,"(",1)
	..i ypmc["["   d
	...s ypmc=$p(ypmc,"[",1)
	.;s ypmc=phdesc_"("_incTYdesc_")"
	.s realqty=qty //实发数量
	.s dispedqty=""
	.s dispedqtyinfo=""
	.s dispedqtyinfo=..GetOwdDispedQty(pho,orditem,inci) //欠药已发数量
	.i dispedqtyinfo'="" d
	..s dispedqty=$p(dispedqtyinfo,"^",1)
	..s dispmoney=$p(dispedqtyinfo,"^",2)
	.i (dispedqty<1)&&(dispedqty[".")&&($p(dispedqty,".",1)="") s dispedqty=0_dispedqty
	.i (qty<1)&&(qty[".")&&($p(qty,".",1)="") s qty=0_qty
	.i (realqty<1)&&(realqty[".")&&($p(realqty,".",1)="") s realqty=0_realqty
	.set Data=$lb(ypmc,newunitdesc,qty,newprice,dispmoney,oeflag,jlflag,phfragdesc,instrdesc,duratdesc,username,ord_"||"_itm,newunit,yppc,yphw,phtype,phgg,phbz,unflag,skintest,syflag,factdesc,doctcode,jrflag,cyyf,kcqty,ybcode,dxts,realqty,dispedqty,inci)
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1

	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryLocOutPatItmFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocOutPatItmExecute ]
{
	 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryLocOutPatItm(GPhl, pho) As %Query(ROWSPEC = "TPhDesc:%String,TPhUom:%String,TPhQty:%String,TPrice:%String,TMoney:%String,TOrdStatus:%String,TJL:%String,TPC:%String,TYF:%String,TLC:%String,TDoctor:%String,TOrditm:%String,TUnit:%String,TIncPC:%String,TIncHW:%String,TPhType:%String,TPhgg:%String,TPhbz:%String,TKCFlag:%String,TSkinTest:%String,TSyFlag:%String,TPhFact:%String,TDoctCode:%String,TJRFlag:%String,TCyyf:%String,TKCQty:%String,TYBType:%String,TDX:%String,TRealQty:%String,TDispedqty:%String,TInci:%String")
{
}

/// Description: 获取欠药单实际发药数量
ClassMethod GetOwdDispedQty(owedr, oeori, Inc)
{
	s phqty=""
	s ord=+oeori
	s itm=$p(oeori,"||",2)
    s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
    s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)		//发药单位显示

    s phdrowid="",phtotalqty=0,pmount=0
    f  s phdrowid=$o(^DHCPHDISPi("PRESCNO",prescno,phdrowid)) q:phdrowid=""  d
    .s tmpowedr=$p(^DHCPHDISP(phdrowid,2),"^",2)
    .q:owedr'=tmpowedr
    .s fyflag=$p(^DHCPHDISP(phdrowid),"^",4)
    .q:fyflag'=1 //过滤未发药
    .s phdsub="",phqty=""
    .f  s phdsub=$o(^DHCPHDI(phdrowid,"PHDI",phdsub)) q:(phdsub="")!(phqty'="")  d
    ..s phoeori=$p(^DHCPHDI(phdrowid,"PHDI",phdsub),"^",5)
    ..q:phoeori'=oeori
    ..s phdclb=0
    ..f  s phdclb=$o(^DHCPHDI(phdrowid,"PHDI",phdsub,"INCLB",phdclb))  q:phdclb=""  d
	...s inclb=$p(^DHCPHDI(phdrowid,"PHDI",phdsub,"INCLB",phdclb),"^",3)
	...s inci=+inclb
	...q:Inc'=inci
	...s phqty=$p(^DHCPHDI(phdrowid,"PHDI",phdsub,"INCLB",phdclb),"^",1)   //
    ...s phtotalqty=phtotalqty+phqty
    ...s money=$p(^DHCPHDI(phdrowid,"PHDI",phdsub,"INCLB",phdclb),"^",8)
    ...s pmount=pmount+money
    .
    q:phtotalqty=0 ""
    s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)  
    s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
    s puruom=+$p(^INCI(inci,3),"^",6)
    //s puruom=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),8),"^",14)
    s buomdr=$p(^INCI(inci,1),"^",10)
    s confac=##class(web.DHCSTCOMMONSRV).UOMFac(puruom,buomdr)
    s getnum=$p((phtotalqty/confac),".",1)
    i getnum="" s getnum=0
    i (dispuomdr'="")&(dispuomdr'=puruom)&(dispuomdr'=buomdr)  d
	.;w "发药单位",!
    .s Fac=##class(web.DHCSTCOMMONSRV).UOMFac(dispuomdr,buomdr)
    .s phqty=phtotalqty/Fac
    e  d
    .i getnum=(phtotalqty/confac)  d
    ..;w "入库单位",!
    ..s phqty=phtotalqty/confac
    .e  d
    ..;w "基本单位",!
    ..s phqty=phtotalqty
    s:phqty'="" phqty=phqty_"^"_pmount
    q phqty
}

/// Description: 欠药单转成退药 ,只有处方医嘱是发药状态才能退药 ,否则只能取消配药
/// w ##class(web.DHCOutPhOweList).ExcRetrun(50,"O181108000011","960")
ClassMethod ExcRetrun(pydr, prescno, phow)
{
	tstart
	s owestatus=$p(^DHCPHOW(phow),"^",8)
	i owestatus=2  tro
	q:owestatus=2 -1  //已发药
	s oweretdate=$p(^DHCPHOW(phow),"^",10)
	i oweretdate'="" tro
    q:oweretdate'="" -2 //已退过
    s retdate=+$h
    s rettime=$p($h,",",2)
    s retuser=pydr 
    s phowsub=$o(^DHCPHOW(phow,"I",""))
    s oeori=$p(^DHCPHOW(phow,"I",phowsub),"^",1)
    s recloc=$p(^DHCPHOW(phow),"^",2)
    s hospdr=$p(^CTLOC(recloc),"^",22)
    s retprt=##class(web.udhcOPRefund).GetPrtRowIDByOERowID(oeori)  //如果是先发药后收费,退药时再补一次最新发票id liangqiang 2014-01-16 和yyx沟通

    s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
    s dspstate=$p(^DHCOEDISQTY(dsp),"^",7)
    i dspstate'="C" tro
	q:dspstate'="C" -4  //处方医嘱是未发状态,请取消配药单
    
	&sql(update DHC_PHOweList set PHO_RetDate=:retdate,PHO_RetTime=:rettime,PHO_RetUser_Dr=:retuser,PHO_RetPrt_Dr=:retprt where PHO_RowID=:phow)
	i SQLCODE'=0 tro
	i SQLCODE'=0 Q -3
	s user=$p(^DHCPHPER(pydr),"^",5)
	s pointer="O"_phow
	s phowsub="" 
	f  s phowsub=$o(^DHCPHOW(phow,"I",phowsub)) q:(phowsub="")  d
	.s oeori=$p(^DHCPHOW(phow,"I",phowsub),"^",1)
	.s qty=$p(^DHCPHOW(phow,"I",phowsub),"^",2) // 基本单位
	.s sp=$p(^DHCPHOW(phow,"I",phowsub),"^",3) 
	.s inci=$p(^DHCPHOW(phow,"I",phowsub),"^",5) 
	.s dspSubId=$p(^DHCPHOW(phow,"I",phowsub),"^",6) 
	.s dsp=+dspSubId
	.s bUomId=$p(^INCI(inci,1),"^",10)
	.s retstr=##CLASS(web.DHCOutPhDisp).InsertDHCOEDisp(oeori,qty,bUomId,pointer,"R","H",user)
	.s ret=$p(retstr,"^",1)
	.i ret'=0 tro
	.q:ret'=0
	.s retdsp=$p(retstr,"^",2)
	.s inclb=""
	.s rp=##class(web.DHCSTPRICE).GetRp(+inci,+$h,bUomId,hospdr,"")
	.s DspbStr=retdsp_"^"_inclb_"^"_qty_"^"_sp_"^"_rp_"^"_inci_"^R"
	.s retstr=##Class(web.DHCSTOEDispBatch).InsDspBatch(DspbStr)
	.s ret=$p(retstr,"^",1)
	.q:ret'=0
	.s ret=..HandlAvailQtyByOwe(phow,dsp,qty,oeori)
	.i ret'=0 tro
	i ret'=0 tro
	q:ret'=0 -99
	tcommit
	Q 0
}

/// 控制如果是部分欠药,必须在配药单发药后,才能确认欠药单
/// 返回1 不可以确认欠药单  0可以确认
ClassMethod ChkIsDisped(prescno, phow)
{
   
    /*
	//exit:1 部分欠药  ,0 全部欠药
	s exit=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:(ord="")||(exit=1)   d
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:(itm="" )||(exit=1)  d
	..s oeori=ord_"||"_itm
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	..s qty=$p(^DHCOEDISQTY(dsp),"^",5)
	..s chkflag=0
	..s phowsub=""
	..f  s phowsub=$o(^DHCPHOW(phow,"I",phowsub)) q:(phowsub="")||(exit=1)  d
	...s orditem=$p(^DHCPHOW(phow,"I",phowsub),"^",1)
	...s dispqty=$p(^DHCPHOW(phow,"I",phowsub),"^",2)
	...i (oeori=orditem)&(dsp=dispqty) s chkflag=1
	..i chkflag=0 s exit=1
	.
	
	i exit=1  d
	.//如果是部分欠药,判断是已发状态,则可以确认欠药单
	.s ret=##class(web.DHCOutPhDisp).CheckBeforUpdate(prescno)   
	.i ret=1  s exit=0
	q exit
	*/
	
	s ret=##class(web.DHCOutPhDisp).CheckBeforUpdate(prescno)
	i ret=1  q 0
	q 1
}

/// add wyx 2015-02-14 欠药退药处理医嘱在途数
/// lastupdate:yunhaibao,20160308,修正批次价在途数
ClassMethod HandlAvailQtyByOwe(phow, dsp, qty, oeori, inci = "")
{
	q 0 // 发药时直接处理了在途
  //n (phow,dsp,qty)
  s recLoc=$p(^DHCPHOW(phow),"^",2)
  s HospID=$p($g(^CTLOC(recLoc)),"^",22)
  s ord=+oeori
  s itm=$p(oeori,"||",2)
  i HospID="" d
  .s RuleFlag=1
  e  d
  .s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
  i RuleFlag=3 d
  .s ownretqty=##class(web.DHCOUTPHA.Common.CommonDisp).GetOwnRetQty(oeori,inci)		//欠药退药数量
  .s dispdsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
  .s dispqty=0
  .s dspSub=0
  .f  s dspSub=$o(^DHCOEDISQTY(dispdsp,"I",dspSub),-1) q:(dspSub="")||(+errCode<0)  d
  ..s dspbBatchId=dspId_"||"_dspSub
  ..s dspInclb=$p(^DHCOEDISQTY(dispdsp,"I",dspSub),"^",1)
  ..s dspInci=$p(^DHCOEDISQTY(dispdsp,"I",dspSub),"^",5) 
  ..s dspInci=$s(dspInclb'="":+dspInclb,1:+dspInci)
  ..q:dspInci'=inci
  ..q:ownretqty=0
  ..s dspqty=$p(^DHCOEDISQTY(dispdsp,"I",dspSub),"^",2) 
  ..i dspqty>ownretqty d 			
  ...s dspqty=ownretqty    
  ...s ownretqty=0
  ..e  d
  ...s ownretqty=ownretqty-dspqty
  ..q:dspqty=0
  ..d ##class(web.DHCST01).UpdInclbResQty(dspInclb,-dspqty) 	
  e  d
  .s inci=##class(web.DHCOutPhCommon).GetInciByOrditm(ord_"||"_itm)
  .s incsub=$o(^INCI("IL_LOC",recLoc,inci,""))
  .s $p(^INCI(inci,"IL",incsub),"^",10)=$p(^INCI(inci,"IL",incsub),"^",10)-qty
 q 0
}

/// creator:yunhaibao
/// createdate:2016-03-01
/// description:欠药发药前判断是否需要确认发药的提示,可统一此处
/// output:为空不做提示
ClassMethod IfDispWarn(oeori, qty)
{
	q:+qty=0 ""
	s ord=+oeori
	s itm=$p(oeori,"||",2)
	q:(ord="")||(itm="") ""
	q:'$d(^OEORD(ord,"I",itm,1)) ""
	s warn=""
	s ordstatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)
	i (ordstatus'="V")&&(ordstatus'="E") s warn="-1"
	q warn
}

}
