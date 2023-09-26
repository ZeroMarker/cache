Class web.UDHCJFOrdPriceSearch Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 283;

ClassMethod FindOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOrdExecute(ByRef qHandle As %Binary, OrdType As %String, OrdAlias As %String, OrdDesc As %String) As %Status
{
	s EpLoc=%session.Get("LOGON.CTLOCID")
	s UserRowId=%session.Get("LOGON.USERID")
	s GroupRowId=%session.Get("LOGON.GROUPID")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",itmname="",itmnum="",itmprice="",ordchildtype="",OrdAlias1="",DrgGdesc=""
	s ORCATDesc=$$ALPHAUP^SSUTIL4(OrdType)
	s OrdAliasDesc=$$ALPHAUP^SSUTIL4(OrdAlias)	
	s ORCATDesc=$g(ORCATDesc),OrdNameDesc=$g(OrdDesc),OrdAliasDesc=$g(OrdAliasDesc)
	i (ORCATDesc="")&(OrdAliasDesc="")&(OrdNameDesc="") Set qHandle=$lb(0,repid,0) quit $$$OK
	s ORCATRowId=""
	i $g(ORCATDesc)'="" s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,""))
	s n=0
	//s OrdAliasDesc=$$ALPHAUP^SSUTIL4(OrdAlias)
	//lgl重写
	s OrdAliasDesc=$g(OrdAliasDesc)
	i (OrdAliasDesc'="") d
	.k ^CHHTEMP("ALIASBJ")
	.s tempOrdAlias=""
	.s id="0" f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
	..s symbo=0
	..s text=$p(^ARC("ALIAS",id),"^",6)
	..s text=$$ALPHAUP^SSUTIL4(text)
	..q:(("^"_text) '[ ("^"_OrdAliasDesc))    ;lgl+左匹配
	..s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
	..q:arcitmrow=""
	..q:'$d(^ARCIM(+arcitmrow))
	..s found=##class(web.DHCDocOrderEntry).ValOrd("ARCIM",GroupRowId,arcitmrow,"","",UserRowId,GroupRowId)
	..q:found'=1
	..s arccat=$p(^ARCIM(+arcitmrow,1,1),"^",10) 
	..s oeccat=$p(^ARC("IC",arccat),"^",8)
	..q:(ORCATRowId'="")&(oeccat'=ORCATRowId)   ;lgl:大类
	..s enddate=$p(^ARCIM(+arcitmrow,1,7),"^",1)    ;lgl+截止日期3
	..q:(enddate'="")&(enddate<(+$H+1))
	..s own=$p(^ARCIM(+arcitmrow,1,7),"^",13)     ;lgl+独立医嘱属性3
	..q:own="N"
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..q:(OrdNameDesc'="")&(ordname2 '[ OrdNameDesc)     ;lgl:医嘱名称
	..s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	...//s ^CHHTEMP("ALIASBJ",id,i)=arcitmrow_"^"_$p(^CHHTEMP("ALIASBJ",i),"^",1)
	...i arcitmrow=$p(^CHHTEMP("ALIASBJ",i),"^",1)  s symbo=1  
	..q:symbo=1 
	..s ^CHHTEMP("ALIASBJ",id)=arcitmrow_"^"_ordname2
	..s lei=$p(^ARCIM(id1,id2,1),"^",10)
	..i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	..s daleicode=$p(^ARC("IC",lei),"^",8)
	..i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	..s text=""
	..s aid="" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	...s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	..s OrdAlias1=$g(text)
	..s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	..s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	..i DrgFormRowid'="" d
	...s DrgMastRowid=$p(DrgFormRowid,"||",1)
	..i DrgMastRowid'="" d
	...s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	...i DrgGdr'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	..s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","")
	..s ordprice2=$j($p(tmpprice,"^",1),3,2)
	..s flag=0
	..s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	...s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc=""
	....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	....q:TariffDR=""
	....s itmname=$p(^DHCTARI(TariffDR),"^",2)
	....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","")
	....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	....s flag=flag+1
	....do OutputRow  	
	else  d
	.s OrdNameDesc=$g(OrdNameDesc)
	.s id1="0" f  s id1=$o(^ARCIM(id1)) q:id1=""  d
	..s id2="0" f  s id2=$o(^ARCIM(id1,id2)) q:id2=""  d
	...s arccat=$p(^ARCIM(id1,id2,1),"^",10) 
	...s oeccat=$p(^ARC("IC",arccat),"^",8)
	...q:(ORCATRowId'="")&(oeccat'=ORCATRowId)   ;lgl:大类
	...s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	...q:(ordname2'[OrdNameDesc)
	...s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	...s lei=$p(^ARCIM(id1,id2,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s arcitmrow=id1_"||"_id2
	...s arcitmrow=$g(arcitmrow)
	...s enddate=$p(^ARCIM(id1,1,7),"^",1)    ;lgl+截止日期2
	...q:(enddate'="")&(enddate<(+$H+1))
	...s own=$p(^ARCIM(id1,1,7),"^",13)     ;lgl+独立医嘱属性2
	...q:own="N"
	...s i=0
	...s text=""
	...s aid="" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
	...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	....;i DrgGdr'="" s DrgGdesc=$p(^PHCGE("GE",DrgGdr),"^",2)
	....i DrgGdr'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","")
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc=""
	.....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p(^DHCTARI(TariffDR),"^",2)
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","")
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	//原偶德俊代码 留作对比
	/*
	if (ORCATDesc'="")&(OrdNameDesc="")&(OrdAliasDesc="") do 
	.s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,""))
	.s arccat=""  f  s arccat=$o(^ARCIM(0,"ARCIC_DR",arccat)) q:arccat=""  d
	..s oeccat=$p(^ARC("IC",arccat),"^",8)
	..q:(oeccat'=ORCATRowId)
	..s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow)) q:arcrow=""  d
	...s arcitmrow=arcrow_"||"_1
	...s arcitmrow=$g(arcitmrow)
	...s enddate=$p(^ARCIM(arcrow,1,7),"^",1)    ;lgl+截止日期1
	...q:(enddate'="")&(enddate<(+$H+1))
	...s own=$p(^ARCIM(arcrow,1,7),"^",13)     ;lgl+独立医嘱属性1
	...q:own="N"
	...s i=0
	...s text=""
	...s aid="" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
    ...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....s DrgGdr=$p(^PHCD(DrgMastRowid,4),"^",1)
	....i DrgGdr'="" s DrgGdesc=$p(^PHCGE("GE",DrgGdr),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","")
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...s ordname2=$p(^ARCIM(arcrow,1,1),"^",2)
	...s ordcode=$p(^ARCIM(arcrow,1,1),"^",1)
	...s lei=$p(^ARCIM(arcrow,1,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc=""
	.....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p(^DHCTARI(TariffDR),"^",2)
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","")
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	e  if (ORCATDesc="")&(OrdNameDesc'="")&(OrdAliasDesc="") do
	.s OrdNameDesc=$g(OrdNameDesc)
	.s id1="0" f  s id1=$o(^ARCIM(id1)) q:id1=""  d
	..s id2="0" f  s id2=$o(^ARCIM(id1,id2)) q:id2=""  d
	...s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	...q:(ordname2'[OrdNameDesc)
	...s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	...s lei=$p(^ARCIM(id1,id2,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s arcitmrow=id1_"||"_id2
	...s arcitmrow=$g(arcitmrow)
	...q:id1=""
	...q:'$d(^ARCIM(id1))
	...s enddate=$p(^ARCIM(id1,1,7),"^",1)    ;lgl+截止日期2
	...q:(enddate'="")&(enddate<(+$H+1))
	...s own=$p(^ARCIM(id1,1,7),"^",13)     ;lgl+独立医嘱属性2
	...q:own="N"
	...s i=0
	...s text=""
	...s aid="" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
	...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....s DrgGdr=$p(^PHCD(DrgMastRowid,4),"^",1)
	....i DrgGdr'="" s DrgGdesc=$p(^PHCGE("GE",DrgGdr),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","")
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc=""
	.....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p(^DHCTARI(TariffDR),"^",2)
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","")
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	e  if (ORCATDesc="")&(OrdNameDesc="")&(OrdAliasDesc'="") do 
	.k ^CHHTEMP("ALIASBJ")
	.s OrdAliasDesc=$g(OrdAliasDesc)
	.s tempOrdAlias=""
	.s id="0" f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
	..s symbo=0
	..s text=$p(^ARC("ALIAS",id),"^",6)
	..s text=$$ALPHAUP^SSUTIL4(text)
	..q:("^"_text '[ "^"_OrdAliasDesc)    ;lgl+左匹配
	..s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
	..q:arcitmrow=""
	..q:'$d(^ARCIM(+arcitmrow))
	..s enddate=$p(^ARCIM(+arcitmrow,1,7),"^",1)    ;lgl+截止日期3
	..q:(enddate'="")&(enddate<(+$H+1))
	..s own=$p(^ARCIM(+arcitmrow,1,7),"^",13)     ;lgl+独立医嘱属性3
	..q:own="N"
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	...//s ^CHHTEMP("ALIASBJ",id,i)=arcitmrow_"^"_$p(^CHHTEMP("ALIASBJ",i),"^",1)
	...i arcitmrow=$p(^CHHTEMP("ALIASBJ",i),"^",1)  s symbo=1  
	..q:symbo=1 
	..s ^CHHTEMP("ALIASBJ",id)=arcitmrow_"^"_ordname2
	..s lei=$p(^ARCIM(id1,id2,1),"^",10)
	..i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	..s daleicode=$p(^ARC("IC",lei),"^",8)
	..i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	..s text=""
	..s aid="" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	...s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	..s OrdAlias1=$g(text)
	..s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	..s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	..i DrgFormRowid'="" d
	...s DrgMastRowid=$p(DrgFormRowid,"||",1)
	..i DrgMastRowid'="" d
	...s DrgGdr=$p(^PHCD(DrgMastRowid,4),"^",1)
	...i DrgGdr'="" s DrgGdesc=$p(^PHCGE("GE",DrgGdr),"^",2)
	..s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","")
	..s ordprice2=$j($p(tmpprice,"^",1),3,2)
	..s flag=0
	..s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	...s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc=""
	....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	....q:TariffDR=""
	....s itmname=$p(^DHCTARI(TariffDR),"^",2)
	....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","")
	....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	....s flag=flag+1
	....do OutputRow  	
	e  if (ORCATDesc'="")&(OrdNameDesc'="")&(OrdAliasDesc="") do
    .s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,""))
	.s arccat=""  f  s arccat=$o(^ARCIM(0,"ARCIC_DR",arccat)) q:arccat=""  d
	..s oeccat=$p(^ARC("IC",arccat),"^",8)
	..q:(oeccat'=ORCATRowId)
	..s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow)) q:arcrow=""  d
	...s arcitmrow=arcrow_"||"_1
	...s arcitmrow=$g(arcitmrow)
	...s enddate=$p(^ARCIM(arcrow,1,7),"^",1)    ;lgl+截止日期4
	...q:(enddate'="")&(enddate<(+$H+1))
	...s own=$p(^ARCIM(arcrow,1,7),"^",13)     ;lgl+独立医嘱属性4
	...q:own="N"
	...s i=0
	...s text=""
	...s aid="" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
    ...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....s DrgGdr=$p(^PHCD(DrgMastRowid,4),"^",1)
	....i DrgGdr'="" s DrgGdesc=$p(^PHCGE("GE",DrgGdr),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","")
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...s ordname2=$p(^ARCIM(arcrow,1,1),"^",2)
	...q:(ordname2'[OrdNameDesc)
	...s ordcode=$p(^ARCIM(arcrow,1,1),"^",1)
	...s lei=$p(^ARCIM(arcrow,1,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc=""
	.....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p(^DHCTARI(TariffDR),"^",2)
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","")
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	e  if (ORCATDesc'="")&(OrdNameDesc="")&(OrdAliasDesc'="") do 
    .k ^CHHTEMP("ALIASBJ")
	.s OrdAliasDesc=$g(OrdAliasDesc)
	.s tempOrdAlias=""
	.s id="0" f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
	..s symbo=0
	..s text=$p(^ARC("ALIAS",id),"^",6)
	..s text=$$ALPHAUP^SSUTIL4(text)
	..q:("^"_text '[ "^"_OrdAliasDesc)
	..s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
	..q:arcitmrow=""
	..s n=n+1
	..//s ^lgltest("0803",n)=id_"^"_arcitmrow
	..q:'$d(^ARCIM(+arcitmrow))
	..s enddate=$p(^ARCIM(+arcitmrow,1,7),"^",1)    ;lgl+截止日期5  6768||1 没有;被删除了 查一下；
	..q:(enddate'="")&(enddate<(+$H+1))
	..s own=$p(^ARCIM(+arcitmrow,1,7),"^",13)     ;lgl+独立医嘱属性5
	..q:own="N"
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	...//s ^CHHTEMP("ALIASBJ",id,i)=arcitmrow_"^"_$p(^CHHTEMP("ALIASBJ",i),"^",1)
	...i arcitmrow=$p(^CHHTEMP("ALIASBJ",i),"^",1)  s symbo=1  
	..q:symbo=1 
	..s ^CHHTEMP("ALIASBJ",id)=arcitmrow_"^"_ordname2
	..s lei=$p(^ARCIM(id1,id2,1),"^",10)
	..i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	..s daleicode=$p(^ARC("IC",lei),"^",8)
	..i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	..q:ordtype2'=ORCATDesc
	..s text=""
	..s aid="" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	...s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	..s OrdAlias1=$g(text)
	..s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	..s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	..i DrgFormRowid'="" d
	...s DrgMastRowid=$p(DrgFormRowid,"||",1)
	..i DrgMastRowid'="" d
	...s DrgGdr=$p(^PHCD(DrgMastRowid,4),"^",1)
	...i DrgGdr'="" s DrgGdesc=$p(^PHCGE("GE",DrgGdr),"^",2)
	..s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","")
	..s ordprice2=$j($p(tmpprice,"^",1),3,2)
	..s flag=0
	..s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	...s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc=""
	....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	....q:TariffDR=""
	....s itmname=$p(^DHCTARI(TariffDR),"^",2)
	....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","")
	....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	....s flag=flag+1
	....do OutputRow    
	e  if (ORCATDesc'="")&(OrdNameDesc'="")&(OrdAliasDesc'="") do 
    .k ^CHHTEMP("ALIASBJ")
	.s OrdAliasDesc=$g(OrdAliasDesc)
	.s tempOrdAlias=""
	.s id="0" f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
	..s symbo=0
	..s text=$p(^ARC("ALIAS",id),"^",6)
	..s text=$$ALPHAUP^SSUTIL4(text)
	..q:("^"_text '[ "^"_OrdAliasDesc)
	..s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
	..q:arcitmrow=""
	..q:'$d(^ARCIM(+arcitmrow))
	..s enddate=$p(^ARCIM(+arcitmrow,1,7),"^",1)    ;lgl+截止日期6
	..q:(enddate'="")&(enddate<(+$H+1))
	..s own=$p(^ARCIM(+arcitmrow,1,7),"^",13)     ;lgl+独立医嘱属性6
	..q:own="N"
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..q:(ordname2'[OrdNameDesc)
	..s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	...//s ^CHHTEMP("ALIASBJ",id,i)=arcitmrow_"^"_$p(^CHHTEMP("ALIASBJ",i),"^",1)
	...i arcitmrow=$p(^CHHTEMP("ALIASBJ",i),"^",1)  s symbo=1  
	..q:symbo=1 
	..s ^CHHTEMP("ALIASBJ",id)=arcitmrow_"^"_ordname2
	..s lei=$p(^ARCIM(id1,id2,1),"^",10)
	..i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	..s daleicode=$p(^ARC("IC",lei),"^",8)
	..i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	..q:ordtype2'=ORCATDesc
	..s text=""
	..s aid="" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	...s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	..s OrdAlias1=$g(text)
	..s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	..s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	..i DrgFormRowid'="" d
	...s DrgMastRowid=$p(DrgFormRowid,"||",1)
	..i DrgMastRowid'="" d
	...s DrgGdr=$p(^PHCD(DrgMastRowid,4),"^",1)
	...i DrgGdr'="" s DrgGdesc=$p(^PHCGE("GE",DrgGdr),"^",2)
	..s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","")
	..s ordprice2=$j($p(tmpprice,"^",1),3,2)
	..s flag=0
	..s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	...s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc=""
	....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	....q:TariffDR=""
	....s itmname=$p(^DHCTARI(TariffDR),"^",2)
	....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","")
	....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	....s flag=flag+1
	....do OutputRow 
	e  do OutputRow 
    */

	Set qHandle=$lb(0,repid,0)
    quit $$$OK
OutputRow
   
    set Data=$lb(ordcode,ordname2,ordtype2,ordprice2,arcitmrow,itmname,itmnum,itmprice,ordchildtype,OrdAlias1,DrgGdesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	
	quit
}

ClassMethod FindOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdExecute ]
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

Query FindOrd(OrdType As %String, OrdAlias As %String, OrdDesc As %String) As %Query(ROWSPEC = "TOrdCode:%String,TOrdName:%String,TOrdType:%String,TOrdPrice:%String,TArcim:%String,Titmname:%String,Titmnum:%String,Titmprice:%String,TOrdChildType:%String,TOrdAlias:%String,DrgGdesc:%String")
{
}

}
