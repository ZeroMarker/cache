/// Class web.UDHCJFOrdPriceSearch1 Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
Class dhc.ca.cache.udata.UDHCJFOrdPriceSearch1 Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 340;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ID";

ClassMethod FindOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOrdExecute(ByRef qHandle As %Binary, OrdType As %String, OrdAlias As %String, OrdDesc As %String, OrdSubType As %String, ArcimRowid As %String, AllOrdSets As %String, OrdSetsAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	kill ^TMP("UDHCJFOrdPriceSearch")
	If $g(ind)="" Set ind=1
	s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",itmname="",itmnum="",itmprice="",ordchildtype="",OrdAlias1="",DrgGdesc="" ,ordExternalCode="", ordExternalDesc=""
	s ORCATDesc=$$ALPHAUP^SSUTIL4(OrdType)
	s ORSUBCATDesc=$$ALPHAUP^SSUTIL4(OrdSubType)
	s OrdNameDesc=$g(OrdDesc)
	s OrdAliasDesc=$$ALPHAUP^SSUTIL4(OrdAlias)
	//s OrdAliasDesc=$g(OrdAlias)
	;yyx 2009-09-21 查询医嘱套的所有医嘱项
	if AllOrdSets="on" d
	.s ARCosRowID="0"
	.f  s ARCosRowID=$o(^ARCOS(ARCosRowID)) q:ARCosRowID=""  d
	..s Count=0
	..d ..GetAllOrderSetItem(ARCosRowID)
	;yyx 2009-09-21 如果医嘱套的别名不为空，则按照医嘱套的别名查询医嘱项
	i OrdSetsAlias'="" d
	.s OrdSetsAlias=OrdSetsAlias
	.s OldOrdSetsAlias=OrdSetsAlias
	.s AliasText=$o(^ARC("ALIAS",0,"Desc",OldOrdSetsAlias),-1)
	.;s LastAlias=LastAlias_" "
	.f  s AliasText=$o(^ARC("ALIAS",0,"Desc",AliasText)) q:(AliasText="")!(AliasText'[OldOrdSetsAlias)  d
	..//B
	..s ALiasDesc=""
	..f  s ALiasDesc=$o(^ARC("ALIAS",0,"Desc",AliasText,ALiasDesc))  q:ALiasDesc=""  d
	...s AliasRowID=""
	...f  s AliasRowID=$o(^ARC("ALIAS",0,"Desc",AliasText,ALiasDesc,AliasRowID))  q:AliasRowID=""  d
	....s AliasType=$p(^ARC("ALIAS",AliasRowID),"^",5)
	....q:AliasType'="ARCOS"
	....s ARCOSRowID=$p(^ARC("ALIAS",AliasRowID),"^",2)
	....s Count=0
	....d ..GetAllOrderSetItem(ARCOSRowID)
	
	//s OrdAliasDesc=$$ALPHAUP^SSUTIL4(OrdAlias)
	if (ORSUBCATDesc'="")&(OrdNameDesc="")&(OrdAliasDesc="") do 
	.s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
	.s arcsubcat=""  f  s arcsubcat=$o(^ARCIM(0,"ARCIC_DR",arcsubcat)) q:arcsubcat=""  d
	..;s oeccat=$p(^ARC("IC",arccat),"^",8)
	..q:(arcsubcat'=ORSUBCATRowId)
	..s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arcsubcat,arcrow)) q:arcrow=""  d
	...s arcitmrow=arcrow_"||"_1
	...s arcitmrow=$g(arcitmrow)
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
	...s ordOnItOwn=$p(^ARCIM(arcrow,1,7),"^",13)
    ...q:$g(ordOnItOwn)="N"
	...s ordExternalCode=""
	...s ordExternalCode=$p($g(^ARCIM(arcrow,1,"EXT",1)),"^",4)
	...s ordExternalDesc=""
	...i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1) 
	...s ordcode=$p(^ARCIM(arcrow,1,1),"^",1)
	...s lei=$p(^ARCIM(arcrow,1,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc=""
	.....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	.....q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	.....s TariffDR=$p($g(^DHCOLT(OLTRowId)),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	.....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","")
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	if (ORCATDesc'="")&(OrdNameDesc="")&(OrdAliasDesc="") do 
	.s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,""))
	.s arccat=""  f  s arccat=$o(^ARCIM(0,"ARCIC_DR",arccat)) q:arccat=""  d
	..s oeccat=$p(^ARC("IC",arccat),"^",8)
	..q:(oeccat'=ORCATRowId)
	..s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow)) q:arcrow=""  d
	...s arcitmrow=arcrow_"||"_1
	...s arcitmrow=$g(arcitmrow)
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
	...s ordOnItOwn=$p(^ARCIM(arcrow,1,7),"^",13)
    ...q:$g(ordOnItOwn)="N"
	...s ordExternalCode=""
	...s ordExternalCode=$p($g(^ARCIM(arcrow,1,"EXT",1)),"^",4)
	...s ordExternalDesc=""
	...i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	...s ordcode=$p(^ARCIM(arcrow,1,1),"^",1)
	...s lei=$p(^ARCIM(arcrow,1,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="" ,ordExternalCode="", ordExternalDesc=""
	.....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	.....q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	.....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	.....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
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
	...s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    ...q:$g(ordOnItOwn)="N"
	...s lei=$p(^ARCIM(id1,id2,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s arcitmrow=id1_"||"_id2
	...s arcitmrow=$g(arcitmrow)
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
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="" ,ordExternalCode="", ordExternalDesc=""
	.....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	.....q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	.....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	.....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
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
	..q:(text '[ OrdAliasDesc)
	..s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
	..s ^lgl("sbo",id)=arcitmrow
	..q:arcitmrow=""
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    ..q:$g(ordOnItOwn)="N"
	..s ordExternalCode=""
	..s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	..s ordExternalDesc=""
	..i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
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
	....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc=""
	....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	....q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	....q:TariffDR=""
	....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
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
	...s ordOnItOwn=$p(^ARCIM(arcrow,1,7),"^",13)
    ...q:$g(ordOnItOwn)="N"
	...s ordExternalCode=""
	...s ordExternalCode=$p($g(^ARCIM(arcrow,1,"EXT",1)),"^",4)
	...s ordExternalDesc=""
	...i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)  
	...q:(ordname2'[OrdNameDesc)
	...s ordcode=$p(^ARCIM(arcrow,1,1),"^",1)
	...s lei=$p(^ARCIM(arcrow,1,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc=""
	.....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	.....q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	.....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	.....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
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
	..q:(text '[ OrdAliasDesc)
	..s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
	..q:arcitmrow=""
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
	..q:$g(ordOnItOwn)="N" 
	..s ordExternalCode=""
	..s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	..s ordExternalDesc=""
	..i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
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
	....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",  ordExternalCode="",ordExternalDesc=""
	....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	....q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	....q:TariffDR=""
	....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
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
	..q:(text '[ OrdAliasDesc)
	..s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
	..q:arcitmrow=""
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    ..q:$g(ordOnItOwn)="N"
	..s ordExternalCode=""
	..s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	..s ordExternalDesc=""
	..i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
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
	....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc=""
	....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	....q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	....q:TariffDR=""
	....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","")
	....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	....s flag=flag+1
	....do OutputRow 
	e  if (ArcimRowid'="") do
	.s id1=$p(ArcimRowid,"||",1)
	.s id2=$p(ArcimRowid,"||",2)
	.q:$d(^ARCIM(id1,id2,1))=0
	.s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	.s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	.s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    .q:$g(ordOnItOwn)="N"
	.s ordExternalCode=""
	.s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	.s ordExternalDesc=""
	.i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	.s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	.s lei=$p(^ARCIM(id1,id2,1),"^",10)
	.i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	.s daleicode=$p(^ARC("IC",lei),"^",8)
	.i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	.s text=""
	.s OrdAlias1=$g(text)
	.s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	.s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	.i DrgFormRowid'="" d
	..s DrgMastRowid=$p(DrgFormRowid,"||",1)
	.i DrgMastRowid'="" d
	..s DrgGdr=$p(^PHCD(DrgMastRowid,4),"^",1)
	..i DrgGdr'="" s DrgGdesc=$p(^PHCGE("GE",DrgGdr),"^",2)
	.s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimRowid,+$H,"","","","")
	.s ordprice2=$j($p(tmpprice,"^",1),3,2)
	.s flag=0
	.s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate)) q:OLTStartDate=""  d
	..s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	...if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc=""
	...s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	...q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	...s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	...s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	...q:TariffDR=""
	...s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	...s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	...s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","")
	...s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	...s flag=flag+1
	...do OutputRow 
	//e  do OutputRow 

	Set qHandle=$lb(0,repid,0)
    quit $$$OK
OutputRow
	set tjob=$j
    if $g(ordname2)="" set ordExternalCode="" ,ordExternalDesc=""
    set Data=$lb(ordcode,ordname2,ordtype2,ordprice2,arcitmrow,itmname,itmnum,itmprice,ordchildtype,OrdAlias1,DrgGdesc,itmcode,ordExternalCode,ordExternalDesc,tjob)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ^TMP("UDHCJFOrdPriceSearch",$j,ind)=$g(ordcode)_"^"_$g(ordname2)_"^"_$g(ordtype2)_"^"_$g(ordprice2)_"^"_$g(arcitmrow)_"^"_$g(itmname)_"^"_$g(itmnum)_"^"_$g(itmprice)_"^"_$g(ordchildtype)_"^"_$g(OrdAlias1)_"^"_$g(DrgGdesc)_"^"_$g(itmcode)_"^"_$g(ordExternalCode)_"^"_$g(ordExternalDesc)
 	Set ind=ind+1
	
	quit
}

ClassMethod getnum(itmjs As %Library.String = "", itmjsex As %Library.String = "", jj)
{
  s gnum=$o(^TMP("UDHCJFOrdPriceSearch",jj,""),-1)
  q gnum
}

Parameter SQLDESCRIPTION = "ID";

ClassMethod getdata(itmjs As %Library.String = "", itmjsex As %Library.String = "", jj, num)
{
    
	s str=^TMP("UDHCJFOrdPriceSearch",jj,num)
	q str
}

Parameter SQLROWID = "ID";

ClassMethod killdata(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
    
	kill ^TMP("UDHCJFOrdPriceSearch")
}

ClassMethod getpath(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
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

Query FindOrd(OrdType As %String, OrdAlias As %String, OrdDesc As %String, OrdSubType As %String, ArcimRowid As %String, AllOrdSets As %String, OrdSetsAlias As %String) As %Query(ROWSPEC = "TOrdCode:%String,TOrdName:%String,TOrdType:%String,TOrdPrice:%String,TArcim:%String,Titmname:%String,Titmnum:%String,Titmprice:%String,TOrdChildType:%String,TOrdAlias:%String,DrgGdesc:%String,Titmcode:%String,TOrdExternalCode:%String,TOrdExternalDesc:%String,Tjob:%String,TOrdSetName:%String,TARCOSItemQty:%String")
{
}

ClassMethod GetAllOrderSetItem(ARCOSRowid As %String)
{
   
	q:$g(ARCOSRowid)=""  
	s ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid) 
	q:'ARCOSDateRowid  
	s ARCOSDesc=$p(^ARCOS(ARCOSRowid),"^",2)
	d ..GetOrderSetItem(ARCOSRowid,ARCOSDateRowid)
	;下面是调出医嘱套里的医嘱套?属于嵌套调用
	;s it=0 f  s it=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"OS",it)) q:it=""  s s=^(it) d
	.;d ..GetAllOrderSetItem(+s)
	Q 0
}

ClassMethod GetOrderSetItem(ARCOSRowid As %String, ARCOSDateRowid As %String) As %String
{
	s allQty=0
	s ARCOSPrice=0
	s item=0 f  s item=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item)) q:item=""  s s=^(item) d
	.s ARCIMRowid=$p(s,"^",1)
	.s Count=Count+1
    .i Count>1 s ARCOSDesc=""
	.q:..ValARCItem(ARCIMRowid)
	.s ARCOSItemQty=$p(s,"^",2)
	.if ARCOSItemQty="" s ARCOSItemQty=1
	.;s count=$o(^TMP("ARCOI",$j,""),-1)+1
	.d ..GetArcimInfo(ARCIMRowid)
	Q 0
}

ClassMethod ValARCItem(ARCIMRowid As %String) As %String
{
	;validate if arcim is active 0-active,1-not active
	s datefrom=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",13)
	s dateto=$p($g(^ARCIM(+ARCIMRowid,1,7)),"^",1)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	q 0
}

ClassMethod GetOrderSetDate(ARCOSRowid As %String)
{
	s DATE=$g(DATE) s:'DATE DATE=+$h
	s ord=+$g(ARCOSRowid) q:'ARCOSRowid 0 
	s dfrom=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",.1+DATE),-1) q:'dfrom 0
	s drow=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",dfrom,"")) q:'drow 0
	s dto=$p($g(^ARCOS(ARCOSRowid,"DATE",drow)),"^",2) i dto,dto<DATE q 0
	q drow
}

ClassMethod GetArcimInfo(ArcimRowid)
{
	if (ArcimRowid'="") do
	.s id1=$p(ArcimRowid,"||",1)
	.s id2=$p(ArcimRowid,"||",2)
	.q:$d(^ARCIM(id1,id2,1))=0
	.s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	.s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	.s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    .;q:$g(ordOnItOwn)="N"  //Hw 2009-09-26
	.s ordExternalCode=""
	.s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	.s ordExternalDesc=""
	.i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	.s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	.s lei=$p(^ARCIM(id1,id2,1),"^",10)
	.i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	.s daleicode=$p(^ARC("IC",lei),"^",8)
	.i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	.s text=""
	.s OrdAlias1=$g(text)
	.s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	.s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	.i DrgFormRowid'="" d
	..s DrgMastRowid=$p(DrgFormRowid,"||",1)
	.i DrgMastRowid'="" d
	..s DrgGdr=$p(^PHCD(DrgMastRowid,4),"^",1)
	..i DrgGdr'="" s DrgGdesc=$p(^PHCGE("GE",DrgGdr),"^",2)
	.s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimRowid,+$H,"","","","")
	.s ordprice2=$j($p(tmpprice,"^",1),3,2)
	.s ARCOSPrice=ARCOSPrice+(ordprice2*ARCOSItemQty) //Hw 
	.s allQty=allQty+1
	.i ($o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item))="")&&(allQty'=1) s ARCOSDesc=ARCOSPrice
	.s flag=0
	.s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate)) q:OLTStartDate=""  d
	..s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	...if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc="",ARCOSDesc="",ARCOSItemQty=""
	...s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	...q:(OLTEndDate<=+$h)&&($g(OLTEndDate)'="")
	...s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	...s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	...q:TariffDR=""
	...s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	...s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	...s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","")
	...s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	...s flag=flag+1
	...do OutputRow1
    Set qHandle=$lb(0,repid,0)
    quit $$$OK
OutputRow1
	set tjob=$j
    if $g(ordname2)="" set ordExternalCode="" ,ordExternalDesc=""
    set Data=$lb(ordcode,ordname2,ordtype2,ordprice2,arcitmrow,itmname,itmnum,itmprice,ordchildtype,OrdAlias1,DrgGdesc,itmcode,ordExternalCode,ordExternalDesc,tjob,ARCOSDesc,ARCOSItemQty)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ^TMP("UDHCJFOrdPriceSearch",$j,ind)=$g(ordcode)_"^"_$g(ordname2)_"^"_$g(ordtype2)_"^"_$g(ordprice2)_"^"_$g(arcitmrow)_"^"_$g(itmname)_"^"_$g(itmnum)_"^"_$g(itmprice)_"^"_$g(ordchildtype)_"^"_$g(OrdAlias1)_"^"_$g(DrgGdesc)_"^"_$g(itmcode)_"^"_$g(ordExternalCode)_"^"_$g(ordExternalDesc)_"^"_$g(ARCOSDesc)_"^"_$g(ARCOSItemQty) //Hw
 	Set ind=ind+1
	quit
}

}
