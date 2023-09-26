Import sqluser

/// 发药相关统计
/// LiangQiang 
/// 2013-12-03
Class web.DHCSTDISPQUERYTOTAL Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 实时统计发药消耗量
ClassMethod DispStatAll(input) As %String
{

		s stdate=$p(input,"^",1)
		q:stdate="" 0
		s stdate=$zdh(stdate,5)
		s endate=$p(input,"^",2)
		q:endate="" 0
		s endate=$zdh(endate,5)
        
		s typestr="P^F^Y^H"
		s pid=..NewPid()
		s phalocdr=$p($p(input,"^",3),",",1)
		s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(phalocdr)
	    s HospID=$p(CustStr,"^",5)
	    s CustID=$p(CustStr,"^",1)
	    s parinci=$p(input,"^",4)
    
        s n=0
		s cnt=$l(typestr,"^")
		f i=1:1:cnt d
		.s type=$p(typestr,"^",i)
		.f date=stdate:1:endate d
		..s intr=""
		..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	    ...s inclb=$p(^DHCINTR(intr),"^",7)
	    ...q:inclb=""
	    ...S LocID=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
	    ...q:$$chkphaloc(LocID)=0
		...s intrtime=$p(^DHCINTR(intr),"^",3)
	    ...//q:(date=stdate)&(sttime'="")&(intrtime<sttime)
	    ...//q:(date=endate)&(endtime'="")&(intrtime>endtime)
	    ...s inci=+inclb
	    ...q:(parinci'="")&(parinci'=inci)
	    ...s pointer=$p(^DHCINTR(intr),"^",9)  ;pointer
		...s baseuom=$p(^INCI(inci,1),"^",10) ;baseuom
		...s puomdr=$p(^INCI(inci,3),"^",6)
		...s qty=$p(^DHCINTR(intr),"^",6)     ;qty for transaction
		...s uom=$p(^DHCINTR(intr),"^",10)    ;uom
		...s sp=$p(^DHCINTR(intr),"^",14)
		...s spamt=$p(^DHCINTR(intr),"^",8)
		...s rp=$p(^DHCINTR(intr),"^",16)
		...s rpamt=$p(^DHCINTR(intr),"^",17)
		...i +sp=0 d
		....s sp=##class(web.DHCSTPRICE).GetSp(inclb,date,uom,HospID,"") ;sale price of base uom
		...i +rp=0 d
		....s rp=##Class(web.DHCSTPRICE).GetRp(inclb,date,uom,HospID,"")
		...i (+rpamt=0)!(+spamt=0) d
		....s amt=..GetAmt(type,pointer,intr)
		....i +rpamt=0 s rpamt=$p(amt,"^",1)
		....i +spamt=0 s spamt=$p(amt,"^",2)
		...//s sp=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,date,puomdr,HospID) ;sale price of base uom
		...//s amt=..GetAmt(type,pointer,intr)
		...//s rpamt=$p(amt,"^",1)
		...//s spamt=$p(amt,"^",2)
		...s fac=##class(web.DHCSTCOMMONSRV).UOMFac(uom,baseuom) 
		...s qty=qty*fac
		...//s packfac=##class(web.DHCSTCOMMONSRV).UOMFac(puomdr,baseuom)
	    ...//s rp=##class(web.DHCSTPRICE).LastInPrice(inclb,puomdr)
	    ...//S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
		...//S StkTypeDesc=$P(CatGrpStr,"^",4)
		...//S Perv="^^^"_StkTypeDesc_"^"_$G(CustID)_"^DHC"
		...//s rp=##Class(web.DHCSTCOMMPARA).GetNumbDec(rp,Perv,"FmtRP",2)
		...s doclocdr=..GetTransDocLoc(intr)
		...s docloc=$p($g(^CTLOC(doclocdr)),"^",2)  //医生科室
		...s warddr=..GetTransWardDr(intr) //病区
		...s ward=$p($g(^CTLOC(doclocdr)),"^",2)
		...s incicode=$p(^INCI(inci,1),"^",1)
		...s incidesc=$p(^INCI(inci,1),"^",2)
		...s baseuom=$p(^CT("UOM",baseuom),"^",2)
		...s puruom=$p(^CT("UOM",puomdr),"^",2)
		...s n=n+1
		...s index=incicode_"^"_n
        ...s data=incicode_"^"_incidesc_"^"_qty_"^"_rp_"^"_sp_"^"_rpamt_"^"_spamt_"^"_docloc_"^"_ward_"^"_packfac_"^"_inci_"^"_baseuom_"^"_puruom
		...s indextotal=incicode 
		...i '$D(^TMP("dhcpha","DHCSTDISPQUERYTOTAL","DispStatAll",pid,indextotal)) d
		....s ^TMP("dhcpha","DHCSTDISPQUERYTOTAL","DispStatAll",pid,indextotal)=data
		...e  d
		....s $p(^TMP("dhcpha","DHCSTDISPQUERYTOTAL","DispStatAll",pid,indextotal),"^",3)=$p(^TMP("dhcpha","DHCSTDISPQUERYTOTAL","DispStatAll",pid,indextotal),"^",3)+qty
		....s $p(^TMP("dhcpha","DHCSTDISPQUERYTOTAL","DispStatAll",pid,indextotal),"^",6)=$p(^TMP("dhcpha","DHCSTDISPQUERYTOTAL","DispStatAll",pid,indextotal),"^",6)+rpamt 
		....s $p(^TMP("dhcpha","DHCSTDISPQUERYTOTAL","DispStatAll",pid,indextotal),"^",7)=$p(^TMP("dhcpha","DHCSTDISPQUERYTOTAL","DispStatAll",pid,indextotal),"^",7)+spamt
		....
		....
		q pid_"^"_n
		
chkphaloc(LocID) 
    ;检查药房科室
    s chkphalocflag=0
    s tmplocstr=$p(input,"^",3)
    s tmplocstrcnt=$l(tmplocstr,",")
    f l=1:1:tmplocstrcnt q:chkphalocflag=1  d
    .s tmpphalocdr=$p(tmplocstr,",",l)
    .i tmpphalocdr=LocID d
    ..s chkphalocflag=1
    q chkphalocflag
}

ClassMethod NewPid() As %String
{
	  	q $I(^DHCSTPID("DispStat"))
}

/// 获取业务金额
ClassMethod GetAmt(type, pointer, dhcintr)
{
		 s oldspamt=0 
		 q:pointer="" "^^" 
		 i type="G" {
		    s INGR=+pointer
		    s CH=$p(pointer,"||",2)
		    s sp=$p(^DHCINGR(INGR,"GRI",CH),"^",32)
		    s qty=$p(^DHCINGR(INGR,"GRI",CH),"^",4)
		    s spamt=sp*qty
		    s rpamt=$p(^DHCINGR(INGR,"GRI",CH),"^",31)
		 }
		 elseif type="R" {
		 s INGRT=+pointer
		    s CH=$p(pointer,"||",2)
		    s rpamt=(-1)*$p(^INGRT(INGRT,"DHCGRR",CH),"^",4)
		    s spamt=(-1)*$p(^INGRT(INGRT,"DHCGRR",CH),"^",9)
		    s oldspamt=(-1)*$p(^INGRT(INGRT,"DHCGRR",CH),"^",16)    
		 }
		 elseif type="T" {
		    s INIT=+pointer
		    s CH=$p(pointer,"||",2)
		    s rpamt=(-1)*$p(^DHCINIT(INIT,"ITI",CH),"^",16)
		    s spamt=(-1)*$p(^DHCINIT(INIT,"ITI",CH),"^",18)
		 }
		 elseif type="K" {
		    s INIT=+pointer
		    s CH=$p(pointer,"||",2)
		    s rpamt=$p(^DHCINIT(INIT,"ITI",CH),"^",16)
		    s spamt=$p(^DHCINIT(INIT,"ITI",CH),"^",18)
		 }
		 elseif type="P" {
		    s rpamt=..GetRpAmt(dhcintr)
		    s spamt=$p(^DHCINTR(dhcintr),"^",8)      
		 }
		 elseif type="Y" {
		    s rpamt=..GetRpAmt(dhcintr)
		    s spamt=$p(^DHCINTR(dhcintr),"^",8)      
		 }
		 elseif type="F" {
		    s rpamt=..GetRpAmt(dhcintr)
		    s spamt=$p(^DHCINTR(dhcintr),"^",8)      
		 } 
		 elseif type="H" {
		    s rpamt=..GetRpAmt(dhcintr)
		    s spamt=$p(^DHCINTR(dhcintr),"^",8)      
		 }
		 elseif type="S" {
		    s rpamt=..GetRpAmt(dhcintr)
		    s spamt=$p(^DHCINTR(dhcintr),"^",8)      
		 }
		 elseif type="Z" {
		    s rpamt=..GetRpAmt(dhcintr)
		    s spamt=$p(^DHCINTR(dhcintr),"^",8)
		 }
		 elseif type="A" {
		    s rpamt=..GetRpAmt(dhcintr)
		    s spamt=$p(^DHCINTR(dhcintr),"^",8)
		 }
		 elseif type="D" {
		    s rpamt=..GetRpAmt(dhcintr)
		    s spamt=$p(^DHCINTR(dhcintr),"^",8)
		 }
		 elseif type="C" {
		    s rpamt=..GetRpAmt(dhcintr)
		    s spamt=$p(^DHCINTR(dhcintr),"^",8)
		 }
		 elseif type="M" {
		    s rpamt=..GetRpAmt(dhcintr)
		    s spamt=$p(^DHCINTR(dhcintr),"^",8)
		 }
		 elseif type="X" {
		    s rpamt=..GetRpAmt(dhcintr)
		    s spamt=$p(^DHCINTR(dhcintr),"^",8)
		 }
		 else {
		 
		 }
		 q $g(rpamt)_"^"_$g(spamt)_"^"_$g(oldspamt)
}

/// 取台帐业务中的医生科室
ClassMethod GetTransDocLoc(intr) As %String
{
	s orditm=..GetTransOrdItem(intr)
	q:orditm="" "不详"
	s ord=$p(orditm,"||",1)
	s chl=$p(orditm,"||",2)
	s doclocdr=$p($g(^OEORD(ord,"I",chl,7)),"^",2)
    q doclocdr
}

/// 获取台帐中的医嘱ID
ClassMethod GetTransOrdItem(intr) As %String
{
	s orditm=""
	s type=$p(^DHCINTR(intr),"^",1)
	s pointer=$p(^DHCINTR(intr),"^",9) 
	i type="P" d
	.q:'$d(^DHCPHAC($p(pointer,"||",1),"I",$p(pointer,"||",2)))
	.s orditm=$p(^DHCPHAC($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",7)
	i type="Y" d
	.q:'$d(^PHARET($p(pointer,"||",1),"I",$p(pointer,"||",2)))
	.s orditm=$p(^PHARET($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",1)
	i type="F" d
	.s orditm=$p(^DHCPHDI($p(pointer,"||",1),"PHDI",$p(pointer,"||",2)),"^",5)
	i type="H" d
	.s orditm=$p(^DHCPHRTI($p(pointer,"||",1),"RTI",$p(pointer,"||",2)),"^",2)
	q orditm
}

/// 取进价金额
ClassMethod GetRpAmt(dhcintr)
{
	 s rpamt=$p(^DHCINTR(dhcintr),"^",17)
	 q:+rpamt'=0 rpamt
	 s qty=$p(^DHCINTR(dhcintr),"^",6)
	 s inclb=$p(^DHCINTR(dhcintr),"^",7)
	 s uom=$p(^DHCINTR(dhcintr),"^",10)
	 s date=$p(^DHCINTR(dhcintr),"^",2)
	 s inci=+inclb
	 s baseuom=$p(^INCI(inci,1),"^",10)
	 ///格式化
	 S LocID=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
	 s CustStr=##class(DHCSTCOMMO).GetLocCust(LocID)
	 s CustID=$p(CustStr,"^",1)
	 s HospID=$p(CustStr,"^",5)
	 S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
	 S StkTypeDesc=$P(CatGrpStr,"^",4)
	 //S Perv="^^^"_StkTypeDesc_"^"_$G(CustID)_"^DHC"	//CS药库版
	 S Perv="^^^"_StkTypeDesc_"^"_$G(HospID)_"^DHC"	//BS药库版，zhouyg 20141208
	 s rp=$p(^DHCINTR(dhcintr),"^",16)
	 i +rp=0 d
	 .s rp=##Class(web.DHCSTPRICE).GetRp(inclb,date,uom,HospID,"")
	 s rpamt=rp*qty
	 //zhouyg 20141208
	 //S LocID=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
	 //s CustStr=##class(web.DHCSTCOMMO).GetLocCust(LocID)
	 //s CustID=$p(CustStr,"^",1)
	 //s HospID=$p(CustStr,"^",5)
	 //S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
	 //S StkTypeDesc=$P(CatGrpStr,"^",4)
	 //S Perv="^^^"_StkTypeDesc_"^"_$G(CustID)_"^DHC"
	 //;s rp=##class(DHCSTPRICE).GetInciBasicRp(+inclb,date,baseuom,HospID)
	 //s rp=##class(web.DHCSTPRICE).LastInPrice(inclb,baseuom)
     //s rp=##Class(web.DHCSTCOMMPARA).GetNumbDec(rp,Perv,"FmtRP",2)
	 //s rpamt=rp*qty
	 S rpamt=+##Class(web.DHCSTCOMMPARA).GetNumbDec(rpamt,Perv,"FmtRA",1)
	 q rpamt
}

/// 取台帐业务中的病区科室
ClassMethod GetTransWardDr(intr) As %String
{
	//7.0
	s wardlocdr=""
    s pointer=$p(^DHCINTR(intr),"^",9)
    s inclb=$p(^DHCINTR(intr),"^",7)
    s type=$p(^DHCINTR(intr),"^",1)
    i type="P" d
    .q:'$d(^DHCPHAC($p(pointer,"||",1),"I",$p(pointer,"||",2)))
	.s orditm=$p(^DHCPHAC($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",7)
	.s ord=$p(orditm,"||",1)
    .S itm=$p(orditm,"||",2)
	.S phalocdr=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
    .s doclocdr=$p($g(^OEORD(ord,"I",itm,7)),"^",2)   
    .i ##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(phalocdr,doclocdr)=1 S wardlocdr=$P($G(^OEORD(ord,"I",itm,7)),"^",2)
    .e  d
    ..s warddr=$p(^DHCPHAC(+pointer),"^",4)
    ..s wardlocdr=$p(^PAWARD(warddr),"^",5)
 
	i type="Y" d
	.s orditm=$p(^PHARET($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",1)
	.s ord=$p(orditm,"||",1)
    .S itm=$p(orditm,"||",2)
	.S dodis=$p(^PHARET($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",13)
	.S phalocdr=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
    .s doclocdr=$p($g(^OEORD(ord,"I",itm,7)),"^",2)   
    .i ##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(phalocdr,doclocdr)=1 S wardlocdr=$P($G(^OEORD(ord,"I",itm,7)),"^",2)
    .e  d
    ..s wardlocdr=$p(^DHCOEDISQTY(dodis),"^",22)
	
	i type="F" d
	.s orditm=$p(^DHCPHDI($p(pointer,"||",1),"PHDI",$p(pointer,"||",2)),"^",5)
	.s ord=$p(orditm,"||",1)
    .S itm=$p(orditm,"||",2)
	.S wardlocdr=$P($G(^OEORD(ord,"I",itm,7)),"^",2)
	
	i type="H" d
	.s orditm=$p(^DHCPHRTI($p(pointer,"||",1),"RTI",$p(pointer,"||",2)),"^",2)
	.s ord=$p(orditm,"||",1)
    .S itm=$p(orditm,"||",2)
	.S wardlocdr=$P($G(^OEORD(ord,"I",itm,7)),"^",2)
	
	
	q wardlocdr
}

//d ##class(%ResultSet).RunQuery("web.DHCSTDISPQUERYTOTAL","GetDispStatData","98^63096^^63161^^1")

ClassMethod GetDispStatDataExecute(ByRef qHandle As %Binary, input) As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    q:input="" $$$OK
    s phalocdr=$p(input,"^",3)
    i phalocdr="" d
    .s locstr=""
    .s ctlocdr=""
    .f  s ctlocdr=$o(^CTLOC(0,"LocType","D",ctlocdr)) q:ctlocdr=""  d
    ..i locstr="" d
    ...s locstr=ctlocdr
    ..e  d
    ...s locstr=locstr_","_ctlocdr
    .s $p(input,"^",3)=locstr
    
    s ret=..DispStatAll(input)
    
    s pid=$p(ret,"^",1)
    s cnt=$p(ret,"^",2)
    
    s n=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTDISPQUERYTOTAL","DispStatAll",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTDISPQUERYTOTAL","DispStatAll",pid,h)
    .s incicode=$p(data,"^",1)
    .s incidesc=$p(data,"^",2)
    .s qty=$p(data,"^",3)
    .s rp=$p(data,"^",4)
    .s sp=$p(data,"^",5)
    .s rpamt=$p(data,"^",6)
    .s spamt=$p(data,"^",7)
    .s docloc=$p(data,"^",8)
    .s ward=$p(data,"^",9)
    .s packfac=$p(data,"^",10)
    .s inci=$p(data,"^",11)
    .s puomqty=$fn(qty/packfac,"",2)
    .s packuomqty=..getPackQty(inci,qty)
    .s buomdesc=$p(data,"^",12)
    .s puomdesc=$p(data,"^",13)
    .s n=n+1
    .d OutRowItm
	Quit $$$OK
OutRowItm
	set Data=$lb(n,incicode,incidesc,qty,rp,sp,rpamt,spamt,docloc,ward,puomqty,packuomqty,buomdesc,puomdesc)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetDispStatDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDispStatDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish 
fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetDispStatData(input As %String) As %Query(ROWSPEC = "n,incicode,incidesc,qty:%Float,rp:%Float,sp:%Float,rpamt:%Float,spamt:%Float,docloc,ward,puomqty:%Float,packuomqty,buomdesc,puomdesc") [ SqlProc ]
{
}

ClassMethod GetDispStatDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDispStatDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:Liang Qiang  
/// CreatDate:2009-01-04
/// Description:转换成整包装数量 
/// Input: inci:inc_itmRowid   qty:基本单位数量
/// Output: XX合xx片
/// Return: XX合xx片
/// Others:
ClassMethod getPackQty(inci, qty) As %String
{
	
	;s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incicode)
	q:+qty=0 0
	s result=""
	s buom=+$p(^INCI(inci,1),"^",10)  ; basic uom
	s puom=+$p(^INCI(inci,3),"^",6)  ; 
	i puom="" s puom=buom
	s buomdesc=$p(^CT("UOM",buom),"^",2)
	s puomdesc=$p(^CT("UOM",puom),"^",2)
	;i $f(puomdesc,"(") s puomdesc=$p(puomdesc,"(",1)
	;
	s fac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
	s packqty=qty\fac
	s restqty=qty-(packqty*fac)
	
	i packqty'=0 d
	. s result=packqty_""_puomdesc
	
	i (packqty<0)&(restqty<0) s restqty=-restqty
	i restqty'=0 d
	. i result'="" d
	. . s result=result_""_restqty_""_buomdesc
	. e  d
	. . s result=restqty_""_buomdesc
	
	q result
}

Storage Default
{
<Data name="DHCSTDISPQUERYTOTALDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTDISPQUERYTOTALD</DataLocation>
<DefaultData>DHCSTDISPQUERYTOTALDefaultData</DefaultData>
<IdLocation>^web.DHCSTDISPQUERYTOTALD</IdLocation>
<IndexLocation>^web.DHCSTDISPQUERYTOTALI</IndexLocation>
<StreamLocation>^web.DHCSTDISPQUERYTOTALS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
