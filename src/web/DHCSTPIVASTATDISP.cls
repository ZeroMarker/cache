Import SQLUser

/// 发药统计
Class web.DHCSTPIVASTATDISP Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DispFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispExecute ]
{
	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		S AtEnd=1
 		S Row=""
 	}
 	Else {				
 		S Row=^CacheTemp(repid,ind)
 	}
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

ClassMethod DispClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

ClassMethod DispExecute(ByRef qHandle As %Binary, PID As %String, Ward As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	Q:PID="" $$$OK
	Q:Ward="" $$$OK
	K ^TMP("PIVA",PID,"STATTAMOUNT")
	S inci=""
	F  S inci=$O(^TMP("PIVA",PID,"STATDISP",Ward,inci)) Q:inci=""  D
	.S Data=..GetData(PID,Ward,inci)
	.S ^CacheTemp(repid,ind)=Data	
 	.S ind=ind+1
 	S ^CacheTemp(repid,ind)=$LB(PID,"合计","","","","","","",$G(^TMP("PIVA",PID,"STATTAMOUNT")))
 	S ind=ind+1
 	Q $$$OK
}

Query Disp(PID As %String, Ward As %String) As %Query(ROWSPEC = "tbPID:%String,tbItmDesc:%String,tbQty:%String,tbPrice:%String,tbUom:%String,tbManf:%String,tbDispQty:%String,tbRetQty:%String,tbAmount:%String")
{
}

ClassMethod GetDispWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDispWardExecute ]
{
	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		S AtEnd=1
 		S Row=""
 	}
 	Else {				
 		S Row=^CacheTemp(repid,ind)
 	}
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

ClassMethod GetDispWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDispWardExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

ClassMethod GetDispWardExecute(ByRef qHandle As %Binary, tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tRegNo As %String, tItmID As %String, tStartTime As %String, tEndTime As %String, tPhcCatDr As %String, tPhcSubCatDr As %String, onlypivaflag As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	Q:tPLocID="" $$$OK
	Q:tStartDate="" $$$OK
	Q:tEndDate="" $$$OK
	S PID=""
	S PID=..CollData(tPLocID, tWardID, tRegNo, tStartDate, tEndDate,tItmID,tStartTime,tEndTime,tPhcCatDr,tPhcSubCatDr,onlypivaflag)
	Q:PID="" $$$OK
	K ^TMP("PIVA",PID,"STATTAMOUNT")
	S ward=""
	F  S ward=$O(^TMP("PIVA",PID,"STATDISP",ward)) Q:ward=""  D
	.S warddr=$P(ward,"^",1)
	.S warddesc=$P(ward,"^",2)
	.S Data=$LB(PID,warddr,warddesc)
	.S ^CacheTemp(repid,ind)=Data	
 	.S ind=ind+1
 	S ind=ind+1
 	Q $$$OK
}

Query GetDispWard(tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tRegNo As %String, tItmID As %String, tStartTime As %String, tEndTime As %String, tPhcCatDr As %String, tPhcSubCatDr As %String, onlypivaflag As %String) As %Query(ROWSPEC = "tbPID:%String,tbWardDr:%String,tbWardDesc:%String")
{
}

ClassMethod CollData(tPLocID As %String, tWardID As %String, tRegNo As %String, tStartDate As %String, tEndDate As %String, tItmID As %String, tStartTime As %String, tEndTime As %String, tPhcCatDr As %String, tPhcSubCatDr As %String, onlypivaflag As %String) As %Integer
{
	N (tPLocID, tWardID, tRegNo, tStartDate, tEndDate,tItmID,tStartTime,tEndTime,tPhcCatDr,tPhcSubCatDr, onlypivaflag)
	Q:tPLocID="" ""
	Q:tStartDate="" ""
	Q:tEndDate="" ""
	S PID=..NewPid()
	D ..ClearAllTmp(PID)
	S varhj="0^合计"
	S i=0
	/// 发药
	S inci=""
	F  S inci=$O(^INCI("IL_LOC",tPLocID,inci)) Q:inci=""  D
 	.Q:(tItmID'="")&(tItmID'=inci)
 	.S il=$O(^INCI("IL_LOC",tPLocID,inci,""))
 	.Q:il=""
 	./// 关联医嘱是否包含此药学分类
 	.S phccatdr=""
 	.I tPhcCatDr'="" D
 	..S phccatstr=##Class(web.DHCSTCOMINC).GetPhcCatDesc(inci)
 	..S phccatdr=$P(phccatstr,"^",1)
 	.Q:(tPhcCatDr'="")&(tPhcCatDr'=phccatdr)
 	./// 关联医嘱是否包含此药学子分类
 	.S phcsubcatdr=""
 	.I tPhcSubCatDr'="" D
 	..S phcsubcatstr=##Class(web.DHCSTCOMINC).GetPhcSCDesc(inci)
 	..S phcsubcatdr=$P(phcsubcatstr,"^",1)
 	.Q:(tPhcSubCatDr'="")&(tPhcSubCatDr'=phcsubcatdr)
 	.S incil=inci_"||"_il
 	.F date=tStartDate:1:tEndDate D
 	..S intr=""
 	..F  S intr=$O(^DHCINTR(0,"ILTYPEDATE",incil,"P",date,intr)) Q:intr=""  D
 	...S phaci=$P(^DHCINTR(intr),"^",9)
	...S pha=$P(phaci,"||",1)
	...Q:pha=""
	...Q:($D(^DHCPHAC(pha))=0)!($D(^DHCPHAC(pha))=10)
	.../// 病区
	...S ward=$P(^DHCPHAC(pha),"^",4)
	...Q:(tWardID'="")&(tWardID'=ward)
	...S warddesc="其它"
	...I ward'="" D
	....I $D(^PAWARD(ward)) S warddesc=$P(^PAWARD(ward),"^",2)
	....I $L(warddesc,"-")>1 S warddesc=$P(warddesc,"-",2)
	...//发药时间
	...S collecttime=$P(^DHCPHAC(pha),"^",3)
	...Q:(tStartTime'="")&(collecttime<tStartTime)&(date=tStartDate)
	...Q:(tEndTime'="")&(collecttime>tEndTime)&(date=tEndDate)
	...S sub=$P(phaci,"||",2)
	...Q:'$D(^DHCPHAC(pha,"I",sub))
	...S pdata=^DHCPHAC(pha,"I",sub)
	...S oeori=$P(pdata,"^",7)
	...S ord=$P(oeori,"||",1)
	...//i onlypivaflag="1" Q:##class(web.DHCSTPCHCOLLS2).IfPIVA(oeori)=0
	...s dodis=$p($p(^DHCPHAC(pha,"I",sub),"^",13),",",1)
	...i onlypivaflag="1" Q:$p($g(^DHCOEDISQTY(dodis)),"^",27)'=0	//zhouyg 20150624
	.../// 登记号
	...S adm=$P(^OEORD(ord),"^",1)	/// 病人 PAADM_Rowid
	...S pat=##class(web.DHCSTPIVA).GetPat(adm)
	...S ipno=$P(pat,"^",1)
	...Q:(tRegNo'="")&(tRegNo'=ipno)
	.../// 药品
	...//S inci=+$P(pdata,"^",4)
	...S itmdesc=$P(^INCI(inci,1),"^",2)
	...S uomdr=$P(^INCI(inci,1),"^",10)
	...S uomdesc=$P(^CT("UOM",uomdr),"^",2)
	...S manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci)
	...S:$P(manf,"-",2)'="" manf=$P(manf,"-",2)
	...//S dspqty=+$P(pdata,"^",6)
	...S dspqty=(-1)*$p(^DHCINTR(intr),"^",6)
	...S price=+$P(pdata,"^",9)
	...S wardstr=ward_"^"_warddesc
	...S inprice=0
	...S index=inci_"^"_price_"^"_inprice
	...S i=i+1
	...I '$D(^TMP("PIVA",PID,"STATDISP",wardstr,index)) D
	....S ^TMP("PIVA",PID,"STATDISP",wardstr,index)=itmdesc_"^"_uomdesc_"^"_dspqty_"^"_price_"^"_manf_"^"_"0"
	...E  D
	....S $P(^TMP("PIVA",PID,"STATDISP",wardstr,index),"^",3)=$P(^TMP("PIVA",PID,"STATDISP",wardstr,index),"^",3)+dspqty
	...I '$D(^TMP("PIVA",PID,"STATDISP",varhj,inci)) D
	....S ^TMP("PIVA",PID,"STATDISP",varhj,inci)=itmdesc_"^"_uomdesc_"^"_dspqty_"^"_price_"^"_manf_"^"_"0"
	...E  D
	....S $P(^TMP("PIVA",PID,"STATDISP",varhj,inci),"^",3)=$P(^TMP("PIVA",PID,"STATDISP",varhj,inci),"^",3)+dspqty
	/// 退药
	F date=tStartDate:1:tEndDate D
	.S phar=""
	.F  S phar=$O(^PHARET(0,"RECLOC",tPLocID,date,phar)) Q:phar=""  D
	..Q:($D(^PHARET(phar))=0)!($D(^PHARET(phar))=10)
	..S pdata=^PHARET(phar)
	..//s oeori=$p(pdata,"^",5)
	../// 病区
	..//s retbed=$p(pdata,"^",15)
	..//s retward=$p(retbed,"||",1)
	..//I retward="" D
	..//.S deptloc=$P(pdata,"^",9)
	..//.S:deptloc'="" retward=$O(^PAWARD(0,"WARD_LocationDR",deptloc,""))
	..s retward=""
	..s deptloc=$P(pdata,"^",6)
	..S:deptloc'="" retward=$O(^PAWARD(0,"WARD_LocationDR",deptloc,""))
	..Q:(tWardID'="")&(tWardID'=retward)
	..S warddesc="其它"
	..I retward'="" D
	...I $D(^PAWARD(retward)) S warddesc=$P(^PAWARD(retward),"^",2)
	...I $L(warddesc,"-")>1 S warddesc=$P(warddesc,"-",2)
	..//退药时间
	..S collecttime=$P(pdata,"^",2)
	..Q:(tStartTime'="")&(collecttime<tStartTime)&(date=tStartDate)
	..Q:(tEndTime'="")&(collecttime>tEndTime)&(date=tEndDate)
	../// 药品
	..s pharsub=""
	..f  s pharsub=$o(^PHARET(phar,"I",pharsub)) q:pharsub=""  d
	.../// 登记号
	...S oeori=$P(^PHARET(phar,"I",pharsub),"^",1)
	...//i onlypivaflag="1" Q:##class(web.DHCSTPCHCOLLS2).IfPIVA(oeori)=0
	...s dodis=$P(^PHARET(phar,"I",pharsub),"^",13)
	...i onlypivaflag="1" Q:$p($g(^DHCOEDISQTY(dodis)),"^",27)'=0	//zhouyg 20150624
	...S adm=$P(^OEORD(+oeori),"^",1)
	...S pat=##class(web.DHCSTPIVA).GetPat(adm)
	...S ipno=$P(pat,"^",1)
	...Q:(tRegNo'="")&(tRegNo'=ipno)
	...S inci=+$P(^PHARET(phar,"I",pharsub),"^",11)
	...q:(tItmID'="")&(tItmID'=inci)
	.../// 是否包含此药学分类
 	...S phccatdr=""
 	...I tPhcCatDr'="" D
 	....S phccatstr=##Class(web.DHCSTCOMINC).GetPhcCatDesc(inci)
 	....S phccatdr=$P(phccatstr,"^",1)
 	...Q:(tPhcCatDr'="")&(tPhcCatDr'=phccatdr)
 	.../// 关联医嘱是否包含此药学子分类
 	...S phcsubcatdr=""
 	...I tPhcSubCatDr'="" D
 	....S phcsubcatstr=##Class(web.DHCSTCOMINC).GetPhcSCDesc(inci)
 	....S phcsubcatdr=$P(phcsubcatstr,"^",1)
 	...Q:(tPhcSubCatDr'="")&(tPhcSubCatDr'=phcsubcatdr)
	...S itmdesc=$P(^INCI(inci,1),"^",2)
	...S uomdr=$P(^INCI(inci,1),"^",10)
	...S uomdesc=$P(^CT("UOM",uomdr),"^",2)
	...S manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci)
	...S:$P(manf,"-",2)'="" manf=$P(manf,"-",2)
	...S retqty=+$P(^PHARET(phar,"I",pharsub),"^",2)
	...S price=+$P(^PHARET(phar,"I",pharsub),"^",4)
	...S wardstr=retward_"^"_warddesc
	...S inprice=0
	...S index=inci_"^"_price_"^"_inprice
	...S i=i+1
	...I '$D(^TMP("PIVA",PID,"STATDISP",wardstr,index)) D
	....S ^TMP("PIVA",PID,"STATDISP",wardstr,index)=itmdesc_"^"_uomdesc_"^"_"0"_"^"_price_"^"_manf_"^"_retqty
	...E  D
	....S $P(^TMP("PIVA",PID,"STATDISP",wardstr,index),"^",6)=$P(^TMP("PIVA",PID,"STATDISP",wardstr,index),"^",6)+retqty
	...I '$D(^TMP("PIVA",PID,"STATDISP",varhj,inci)) D
	....S ^TMP("PIVA",PID,"STATDISP",varhj,inci)=itmdesc_"^"_uomdesc_"^"_retqty_"^"_price_"^"_manf_"^"_"0"
	...E  D
	....S $P(^TMP("PIVA",PID,"STATDISP",varhj,inci),"^",6)=$P(^TMP("PIVA",PID,"STATDISP",varhj,inci),"^",6)+retqty
	Q:i=0 ""
	Q PID
}

ClassMethod GetData(pid As %String, ward As %String, inci As %String) As %String
{
	N (pid,ward,inci)
	S str=^TMP("PIVA",pid,"STATDISP",ward,inci)
	S itmdesc=$P(str,"^",1)
	s uomdesc=$P(str,"^",2)
	s dspqty=$P(str,"^",3)
	s price=$P(str,"^",4)
	s manf=$P(str,"^",5)
	s retqty=$P(str,"^",6)
	S tqty=dspqty-retqty
	S tamount=price*tqty
	S ^TMP("PIVA",pid,"STATTAMOUNT")=$G(^TMP("PIVA",pid,"STATTAMOUNT"))+tamount
 	S data=$LB(pid,itmdesc,tqty,price,uomdesc,manf,dspqty,retqty,tamount)
 	Q data
}

ClassMethod NewPid() As %String
{
 	Q $I(^DHCSTPIVA("COLL"))
}

ClassMethod ClearAllTmp(pid As %String) As %String
{
	D ..CLEARTMP(pid,"STATDISP")
	D ..CLEARTMP(pid,"STATTAMOUNT")
}

ClassMethod CLEARTMP(pid As %String, PAR As %String) As %String
{
	K ^TMP("PIVA",pid,PAR)
}

}
