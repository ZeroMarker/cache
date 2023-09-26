Import SQLUser

/// 发药统计
Class web.DHCSTPIVASTATDISPbak Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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

ClassMethod DispExecute(ByRef qHandle As %Binary, tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tRegNo As %String, tItmID As %String, tStartTime As %String, tEndTime As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	Q:tPLocID="" $$$OK
	Q:tStartDate="" $$$OK
	Q:tEndDate="" $$$OK
	S PID=""
	S PID=..CollData(tPLocID, tWardID, tRegNo, tStartDate, tEndDate,tItmID,tStartTime,tEndTime)
	Q:PID="" $$$OK
	K ^TMP("PIVA",PID,"STATTAMOUNT")
	S inci=""
	F  S inci=$O(^TMP("PIVA",PID,"STATDISP",inci)) Q:inci=""  D
	.S Data=..GetData(PID,inci)
	.S ^CacheTemp(repid,ind)=Data	
 	.S ind=ind+1
 	S ^CacheTemp(repid,ind)=$LB(PID,"合计","","","","","","",$G(^TMP("PIVA",PID,"STATTAMOUNT")))
 	S ind=ind+1
 	Q $$$OK
}

Query Disp(tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tRegNo As %String, tItmID As %String, tStartTime As %String, tEndTime As %String) As %Query(ROWSPEC = "tbPID:%String,tbItmDesc:%String,tbQty:%String,tbPrice:%String,tbUom:%String,tbManf:%String,tbDispQty:%String,tbRetQty:%String,tbAmount:%String")
{
}

ClassMethod CollData(tPLocID As %String, tWardID As %String, tRegNo As %String, tStartDate As %String, tEndDate As %String, tItmID As %String, tStartTime As %String, tEndTime As %String) As %Integer
{
	N (tPLocID, tWardID, tRegNo, tStartDate, tEndDate,tItmID,tStartTime,tEndTime)
	Q:tPLocID="" ""
	Q:tStartDate="" ""
	Q:tEndDate="" ""
	S PID=..NewPid()
	D ..ClearAllTmp(PID)
	S i=0
	/// 发药
	S inci=""
	F  S inci=$O(^INCI("IL_LOC",tPLocID,inci)) Q:inci=""  D
 	.Q:(tItmID'="")&(tItmID'=inci)
 	.S il=$O(^INCI("IL_LOC",tPLocID,inci,""))
 	.Q:il=""
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
	...//发药时间
	...S collecttime=$P(^DHCPHAC(pha),"^",3)
	...Q:(tStartTime'="")&(collecttime<tStartTime)&(date=tStartDate)
	...Q:(tEndTime'="")&(collecttime>tEndTime)&(date=tEndDate)
	...S sub=$P(phaci,"||",2)
	...Q:'$D(^DHCPHAC(pha,"I",sub))
	...S pdata=^DHCPHAC(pha,"I",sub)
	...S oeori=$P(pdata,"^",7)
	...S ord=$P(oeori,"||",1)
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
	...S dspqty=+$P(pdata,"^",6)
	...S price=+$P(pdata,"^",9)
	...S i=i+1
	...I '$D(^TMP("PIVA",PID,"STATDISP",inci)) D
	....S ^TMP("PIVA",PID,"STATDISP",inci)=itmdesc_"^"_uomdesc_"^"_dspqty_"^"_price_"^"_manf_"^"_"0"
	...E  D
	....S $P(^TMP("PIVA",PID,"STATDISP",inci),"^",3)=$P(^TMP("PIVA",PID,"STATDISP",inci),"^",3)+dspqty
	/// 退药
	F date=tStartDate:1:tEndDate D
	.S phar=""
	.F  S phar=$O(^PHARET(0,"RECLOC",tPLocID,date,phar)) Q:phar=""  D
	..Q:($D(^PHARET(phar))=0)!($D(^PHARET(phar))=10)
	..S pdata=^PHARET(phar)
	../// 病区
	..s retbed=$p(pdata,"^",15)
	..s retward=$p(retbed,"||",1)
	..Q:(tWardID'="")&(tWardID'=retward)
	../// 登记号
	..S adm=$p(pdata,"^",10)
	..S pat=##class(web.DHCSTPIVA).GetPat(adm)
	..S ipno=$P(pat,"^",1)
	..Q:(tRegNo'="")&(tRegNo'=ipno)
	../// 药品
	..S inci=+$P(pdata,"^",6)
	..Q:(tItmID'="")&(tItmID'=inci)
	..S itmdesc=$P(^INCI(inci,1),"^",2)
	..S uomdr=$P(^INCI(inci,1),"^",10)
	..S uomdesc=$P(^CT("UOM",uomdr),"^",2)
	..S manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci)
	..S:$P(manf,"-",2)'="" manf=$P(manf,"-",2)
	..S retqty=+$P(pdata,"^",12)
	..S price=+$P(pdata,"^",13)
	..S i=i+1
	..I '$D(^TMP("PIVA",PID,"STATDISP",inci)) D
	...S ^TMP("PIVA",PID,"STATDISP",inci)=itmdesc_"^"_uomdesc_"^"_"0"_"^"_price_"^"_manf_"^"_retqty
	..E  D
	...S $P(^TMP("PIVA",PID,"STATDISP",inci),"^",6)=$P(^TMP("PIVA",PID,"STATDISP",inci),"^",6)+retqty
	Q:i=0 ""
	Q PID
}

ClassMethod GetData(pid As %String, inci As %String) As %String
{
	N (pid,inci)
	S str=^TMP("PIVA",pid,"STATDISP",inci)
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
