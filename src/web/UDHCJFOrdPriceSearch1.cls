Class web.UDHCJFOrdPriceSearch1 Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 330;

ClassMethod FindOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFOrdPriceSearch1","FindOrd","","cs","","","","","")
ClassMethod FindOrdExecute(ByRef qHandle As %Binary, OrdType As %String, OrdAlias As %String, OrdDesc As %String, OrdSubType As %String, ArcimRowid As %String, AllOrdSets As %String, OrdSetsAlias As %String, OrderStatus As %String) As %Status
{
	;w !,OrdType_","_OrdAlias_","_OrdDesc_","_OrdSubType_","_ArcimRowid_","_AllOrdSets_","_OrdSetsAlias
	;.....s DateTo=$p($g(^ARCIM(+arcitmrow,$p(arcitmrow,"||",2),7)),"^",13)
	;.....q:(DateTo<+$H)
	
	Set repid=$I(^CacheTemp)
	kill ^TMP("UDHCJFOrdPriceSearch")
	If $g(ind)="" Set ind=1
	s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",itmname="",itmnum="",itmprice="",ordchildtype="",OrdAlias1="",DrgGdesc="" ,ordExternalCode="", ordExternalDesc=""
	s ORCATDesc=$$ALPHAUP^SSUTIL4(OrdType)
	s ORSUBCATDesc=$$ALPHAUP^SSUTIL4(OrdSubType)
	s OrdNameDesc=$g(OrdDesc)
	s OrdAliasDesc=$$ALPHAUP^SSUTIL4(OrdAlias)
	
	s DepHospID="" ;  $G(%session.Data("LOGON.HOSPID"))
	k ArrArc
	;s DepHospID=##class(web.UDHCHospitalGroup).GetDefHospitalInfoByLocID(DepID)
	//s OrdAliasDesc=$g(OrdAlias)
	;yyx 2009-09-21 查询医嘱套的所有医嘱项
	if AllOrdSets="on" d
	.s ARCosRowID="0"
	.f  s ARCosRowID=$o(^ARCOS(ARCosRowID)) q:ARCosRowID=""  d
	..Q:$$valarcos(ARCosRowID)
	..s Count=0
	..d ..GetAllOrderSetItem(ARCosRowID)
	;yyx 2009-09-21 如果医嘱套的别名不为空，则按照医嘱套的别名查询医嘱项
    s OrdSetsAlias=$$ALPHAUP^SSUTIL4(OrdSetsAlias)
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
	....q:$d(^ARC("ALIAS",AliasRowID))=0
	....s AliasType=$p(^ARC("ALIAS",AliasRowID),"^",5)
	....q:AliasType'="ARCOS"
	....s ARCOSRowID=$p(^ARC("ALIAS",AliasRowID),"^",2)
	....s Count=0
	....Q:$$valarcos(ARCOSRowID)
	....d ..GetAllOrderSetItem(ARCOSRowID)
	
	//s OrdAliasDesc=$$ALPHAUP^SSUTIL4(OrdAlias)
	if (ORSUBCATDesc'="")&(OrdNameDesc="")&(OrdAliasDesc="") do 
	.s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
	.s arcsubcat=""  f  s arcsubcat=$o(^ARCIM(0,"ARCIC_DR",arcsubcat)) q:arcsubcat=""  d
	..;s oeccat=$p(^ARC("IC",arccat),"^",8)
	..q:(arcsubcat'=ORSUBCATRowId)
	..s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arcsubcat,arcrow)) q:arcrow=""  d
	...s sub=$o(^ARCIM(0,"ARCIC_DR",arcsubcat,arcrow,""))
	...s arcitmrow=arcrow_"||"_sub
	...q:arcitmrow=""
	...s valFlag=$$valrow(arcitmrow)
	...Quit:(valFlag)&&(OrderStatus=1)
	...Quit:('valFlag)&&(OrderStatus=2)
	...q:$d(ArrArc(arcitmrow))
	...s ArrArc(arcitmrow)=arcitmrow
	...s arcitmrow=$g(arcitmrow)
	...s i=0
	...s text=""
	...s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....i text'=""  d
	.....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	....e  d
	.....s text=$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
    ...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....i $d(^PHCD(DrgMastRowid,4)) d
	.....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	.....i DrgGdr'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...q:$d(^ARCIM(arcrow,sub))=0
	...s ordname2=$p(^ARCIM(arcrow,sub,1),"^",2)
	...s ordExternalCode=""
	...;s ordExternalCode=$p($g(^ARCIM(arcrow,sub,"EXT",1)),"^",4)
	...s ordExternalDesc=""
	...;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1) 
	...s chl="" f  s chl=$o(^ARCIM(+arcrow,sub,"EXT",chl)) q:chl=""  d
	....s tod=$p($g(^ARCIM(+arcrow,sub,"EXT",chl)),"^",2)
	....q:(tod'="")&(tod<+$h)
	....s ordExternalCode=$p($g(^ARCIM(+arcrow,sub,"EXT",chl)),"^",4)
	...s ordcode=$p(^ARCIM(arcrow,sub,1),"^",1)
	...s lei=$p(^ARCIM(arcrow,sub,1),"^",10)
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
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	if (ORCATDesc'="")&(OrdNameDesc="")&(OrdAliasDesc="") do 
	.s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,""))
	.s arccat=""  f  s arccat=$o(^ARCIM(0,"ARCIC_DR",arccat)) q:arccat=""  d
	..s oeccat=$p(^ARC("IC",arccat),"^",8)
	..q:(oeccat'=ORCATRowId)
	..s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow)) q:arcrow=""  d
	...s sub=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow,""))
	...s ORSUBCATRowId=""
	...i ORSUBCATDesc'="" s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
	...s arcitmcat=$p(^ARCIM(arcrow,sub,1),"^",10)
	...q:((arcitmcat'=ORSUBCATRowId)&(ORSUBCATRowId'=""))
	...s arcitmrow=arcrow_"||"_sub
	...q:$d(ArrArc(arcitmrow))
	...s valFlag=$$valrow(arcitmrow)
	...Quit:(valFlag)&&(OrderStatus=1)
	...Quit:('valFlag)&&(OrderStatus=2)
	...s ArrArc(arcitmrow)=arcitmrow
	...s arcitmrow=$g(arcitmrow)
	...s i=0
	...s text=""
	...s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....i text'=""  d
	.....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	....e  d
	.....s text=$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
    ...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....i $d(^PHCD(DrgMastRowid,4)) d
	.....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	.....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	...;b ;;
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...s ordname2=$p(^ARCIM(arcrow,1,1),"^",2)
	...s ordOnItOwn=$p(^ARCIM(arcrow,1,7),"^",13)
    ...q:$g(ordOnItOwn)="N"
	...s ordExternalCode=""
	...;s ordExternalCode=$p($g(^ARCIM(arcrow,1,"EXT",1)),"^",4)
	...s ordExternalDesc=""
	...;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	...s chl="" f  s chl=$o(^ARCIM(+arcrow,1,"EXT",chl)) q:chl=""  d
	....s tod=$p($g(^ARCIM(+arcrow,1,"EXT",chl)),"^",2)
	....q:(tod'="")&(tod<+$h)
	....s ordExternalCode=$p($g(^ARCIM(+arcrow,1,"EXT",chl)),"^",4)
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
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	e  if (ORCATDesc="")&(OrdNameDesc'="")&(OrdAliasDesc="") do
	.s OrdNameDesc=$g(OrdNameDesc)
	.s id1="0" f  s id1=$o(^ARCIM(id1)) q:id1=""  d
	..s id2="0" f  s id2=$o(^ARCIM(id1,id2)) q:id2=""  d
	...Q:'($d(^ARCIM(id1,id2,1)))
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
	...q:$d(ArrArc(arcitmrow))
	...s valFlag=$$valrow(arcitmrow)
	...Quit:(valFlag)&&(OrderStatus=1)
	...Quit:('valFlag)&&(OrderStatus=2)
	...s ArrArc(arcitmrow)=arcitmrow
	...s arcitmrow=$g(arcitmrow)
	...s i=0
	...s text=""
	...s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....i text'=""  d
	.....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	....e  d
	.....s text=$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
	...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....i $d(^PHCD(DrgMastRowid,4)) d
	.....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	.....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...s ordExternalCode=""
	...s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	....s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	....q:(tod'="")&(tod<+$h)
	....s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
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
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
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
	..q:arcitmrow=""
	..q:$d(ArrArc(arcitmrow))
	..s valFlag=$$valrow(arcitmrow)
	..Quit:(valFlag)&&(OrderStatus=1)
	..Quit:('valFlag)&&(OrderStatus=2)
	..s ArrArc(arcitmrow)=arcitmrow
	..;s ^lgl("sbo",id)=arcitmrow
	..q:arcitmrow=""
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
	..s ordExternalCode=""
	..;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	..s ordExternalDesc=""
	..;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	..s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	...s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	...q:(tod'="")&(tod<+$h)
	...s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
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
	..s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	...i text'=""  d
	....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	...e  d
	....s text=$p(^ARC("ALIAS",aid),"^",6)
	..s OrdAlias1=$g(text)
	..s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	..s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	..i DrgFormRowid'="" d
	...s DrgMastRowid=$p(DrgFormRowid,"||",1)
	..i DrgMastRowid'="" d
	...i $d(^PHCD(DrgMastRowid,4)) d
	....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	..s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
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
	....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
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
	...q:arcitmrow=""
	...s valFlag=$$valrow(arcitmrow)
	...Quit:(valFlag)&&(OrderStatus=1)
	...Quit:('valFlag)&&(OrderStatus=2)
	...q:$d(ArrArc(arcitmrow))
	...s ArrArc(arcitmrow)=arcitmrow
	...s i=0
	...s text=""
	...s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....i text'=""  d
	.....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	....e  d
	.....s text=$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
    ...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....i $d(^PHCD(DrgMastRowid,4)) d
	.....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	.....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...s ordname2=$p(^ARCIM(arcrow,1,1),"^",2)
	...s ordExternalCode=""
	...;s ordExternalCode=$p($g(^ARCIM(arcrow,1,"EXT",1)),"^",4)
	...s ordExternalDesc=""
	...;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)  
	...s chl="" f  s chl=$o(^ARCIM(+arcrow,1,"EXT",chl)) q:chl=""  d
	....s tod=$p($g(^ARCIM(+arcrow,1,"EXT",chl)),"^",2)
	....q:(tod'="")&(tod<+$h)
	....s ordExternalCode=$p($g(^ARCIM(+arcrow,1,"EXT",chl)),"^",4)
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
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
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
	..s valFlag=$$valrow(arcitmrow)
	..Quit:(valFlag)&&(OrderStatus=1)
	..Quit:('valFlag)&&(OrderStatus=2)
	..q:$d(ArrArc(arcitmrow))
	..s ArrArc(arcitmrow)=arcitmrow
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..s ordExternalCode=""
	..;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	..s ordExternalDesc=""
	..;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	..s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	...s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	...q:(tod'="")&(tod<+$h)
	...s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
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
	..s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	...i text'=""  d
	....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	...e  d
	....s text=$p(^ARC("ALIAS",aid),"^",6)
	..s OrdAlias1=$g(text)
	..s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	..s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	..i DrgFormRowid'="" d
	...s DrgMastRowid=$p(DrgFormRowid,"||",1)
	..i DrgMastRowid'="" d
    ...i $d(^PHCD(DrgMastRowid,4)) d
	....s DrgGdr=$p(^PHCD(DrgMastRowid,4),"^",1)
	....i DrgGdr'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	..s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
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
	....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
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
	..s valFlag=$$valrow(arcitmrow)
	..Quit:(valFlag)&&(OrderStatus=1)
	..Quit:('valFlag)&&(OrderStatus=2)
	..q:$d(ArrArc(arcitmrow))
	..s ArrArc(arcitmrow)=arcitmrow
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..s ordExternalCode=""
	..;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	..s ordExternalDesc=""
	..;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	..s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	...s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	...q:(tod'="")&(tod<+$h)
	...s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
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
	..s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	...i text'=""  d
	....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	...e  d
	....s text=$p(^ARC("ALIAS",aid),"^",6)
	..s OrdAlias1=$g(text)
	..s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	..s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	..i DrgFormRowid'="" d
	...s DrgMastRowid=$p(DrgFormRowid,"||",1)
	..i DrgMastRowid'="" d
	...i $d(^PHCD(DrgMastRowid,4)) d
	....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	..s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
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
	....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	....s flag=flag+1
	....do OutputRow 
	e  if (ArcimRowid'="") do
	.q:$d(ArrArc(ArcimRowid))
	.s ArrArc(ArcimRowid)=ArcimRowid
	.s id1=$p(ArcimRowid,"||",1)
	.s id2=$p(ArcimRowid,"||",2)
	.q:$d(^ARCIM(id1,id2,1))=0
	.s valFlag=$$valrow(arcitmrow)
	.Quit:(valFlag)&&(OrderStatus=1)
	.Quit:('valFlag)&&(OrderStatus=2)
	.s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	.s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	.s ordExternalCode=""
	.;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	.s ordExternalDesc=""
	.;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	.;s ordExternalCode=""
	.s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	..s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	..q:(tod'="")&(tod<+$h)
	..s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
	.s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	.s lei=$p(^ARCIM(id1,id2,1),"^",10)
	.i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	.s daleicode=$p(^ARC("IC",lei),"^",8)
	.i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	.s text=""	
	.s text=""
	.s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",ArcimRowid,aid))  q:aid=""  d
	..i text'=""  d
	...s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	..e  d
	...s text=$p(^ARC("ALIAS",aid),"^",6)
	.s OrdAlias1=$g(text)
	.s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	.s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	.i DrgFormRowid'="" d
	..s DrgMastRowid=$p(DrgFormRowid,"||",1)
	.i DrgMastRowid'="" d
	..i $d(^PHCD(DrgMastRowid,4)) d
	...s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	...i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	.s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimRowid,+$H,"","","","",DepHospID)
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
	...s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	...s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	...s flag=flag+1
	...do OutputRow 
	//e  do OutputRow 

	Set qHandle=$lb(0,repid,0)
    quit $$$OK
OutputRow
	set tjob=$j
    if $g(ordname2)="" {
	    set ordExternalCode="" ,ordExternalDesc=""
    }
    ;set InusTarInfo=##class(web.DHCINSUPort).GetInusTarInfo(TariffDR)
    s InusTarInfo=""
    set InusTarInfo=$case(InusTarInfo,1:"甲",2:"乙",3:"丙","":"")
    if InusTarInfo'="" s itmname="("_InusTarInfo_")"_itmname
    set Data=$lb(ordcode,ordname2,ordtype2,ordprice2,arcitmrow,itmname,itmnum,itmprice,ordchildtype,OrdAlias1,DrgGdesc,itmcode,ordExternalCode,ordExternalDesc,tjob)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ^TMP("UDHCJFOrdPriceSearch",$j,ind)=$g(ordcode)_"^"_$g(ordname2)_"^"_$g(ordtype2)_"^"_$g(ordprice2)_"^"_$g(arcitmrow)_"^"_$g(itmname)_"^"_$g(itmnum)_"^"_$g(itmprice)_"^"_$g(ordchildtype)_"^"_$g(OrdAlias1)_"^"_$g(DrgGdesc)_"^"_$g(itmcode)_"^"_$g(ordExternalCode)_"^"_$g(ordExternalDesc)
 	Set ind=ind+1
	
	quit
valrow(row) ;validate if arcim is active 0-active,1-not active
	 n (row)
	 s datefrom=$p($g(^ARCIM(+row,1,1)),"^",13)
	 s dateto=$p($g(^ARCIM(+row,1,7)),"^",1)
	 i datefrom>$h q 1
	 i dateto,dateto<$h q 1
	 s ordOnItOwn=$p($g(^ARCIM(+row,1,7)),"^",13)
	 Quit:ordOnItOwn="N" 1
	 q 0
valarcos(row) ;validate if arcos is active 0-active,1-not active
	n (row)
	s datefrom=$p($g(^ARCOS(+row)),"^",15)
	s dateto=$p($g(^ARCOS(+row)),"^",16)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	q 0
}

ClassMethod getnum(itmjs As %Library.String = "", itmjsex As %Library.String = "", jj)
{
  s gnum=$o(^TMP("UDHCJFOrdPriceSearch",jj,""),-1)
  q gnum
}

ClassMethod getdata(itmjs As %Library.String = "", itmjsex As %Library.String = "", jj, num)
{
    
	s str=^TMP("UDHCJFOrdPriceSearch",jj,num)
	q str
}

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

Query FindOrd(OrdType As %String, OrdAlias As %String, OrdDesc As %String, OrdSubType As %String, ArcimRowid As %String, AllOrdSets As %String, OrdSetsAlias As %String, OrderStatus As %String) As %Query(ROWSPEC = "TOrdCode:%String,TOrdName:%String,TOrdType:%String,TOrdPrice:%String,TArcim:%String,Titmname:%String,Titmnum:%String,Titmprice:%String,TOrdChildType:%String,TOrdAlias:%String,DrgGdesc:%String,Titmcode:%String,TOrdExternalCode:%String,TOrdExternalDesc:%String,Tjob:%String,TOrdSetName:%String,TARCOSItemQty:%String")
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
	.q:$d(ArrArc(ArcimRowid))
	.s ArrArc(ArcimRowid)=ArcimRowid
	.s arcitmrow=ArcimRowid ;add hujunbin 15.2.11
	.s id1=$p(ArcimRowid,"||",1)
	.s id2=$p(ArcimRowid,"||",2)
	.q:$d(^ARCIM(id1,id2,1))=0
	.s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	.s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	.s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    .;q:$g(ordOnItOwn)="N"  //Hw 2009-09-26
	.s ordExternalCode=""
	.;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	.s ordExternalDesc=""
	.;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	.s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	..s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	..q:(tod'="")&(tod<+$h)
	..s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
	.s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	.s lei=$p(^ARCIM(id1,id2,1),"^",10)
	.i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	.s daleicode=$p(^ARC("IC",lei),"^",8)
	.i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	.s text=""
	.s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",ArcimRowid,aid))  q:aid=""  d
	..i text'=""  d
	...s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	..e  d
	...s text=$p(^ARC("ALIAS",aid),"^",6)
	.s OrdAlias1=$g(text)
	.s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	.s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	.i DrgFormRowid'="" d
	..s DrgMastRowid=$p(DrgFormRowid,"||",1)
	.i DrgMastRowid'="" d
	..i $d(^PHCD(DrgMastRowid,4)) d
	...s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	...i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	.s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimRowid,+$H,"","","","",DepHospID)
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
	...s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	...s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	...s flag=flag+1
	...do OutputRow12
    Set qHandle=$lb(0,repid,0)
    quit $$$OK
OutputRow12
	set tjob=$j
    if $g(ordname2)="" set ordExternalCode="" ,ordExternalDesc=""
    set Data=$lb(ordcode,ordname2,ordtype2,ordprice2,arcitmrow,itmname,itmnum,itmprice,ordchildtype,OrdAlias1,DrgGdesc,itmcode,ordExternalCode,ordExternalDesc,tjob,ARCOSDesc,ARCOSItemQty)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ^TMP("UDHCJFOrdPriceSearch",$j,ind)=$g(ordcode)_"^"_$g(ordname2)_"^"_$g(ordtype2)_"^"_$g(ordprice2)_"^"_$g(arcitmrow)_"^"_$g(itmname)_"^"_$g(itmnum)_"^"_$g(itmprice)_"^"_$g(ordchildtype)_"^"_$g(OrdAlias1)_"^"_$g(DrgGdesc)_"^"_$g(itmcode)_"^"_$g(ordExternalCode)_"^"_$g(ordExternalDesc)_"^"_$g(ARCOSDesc)_"^"_$g(ARCOSItemQty) //Hw
 	Set ind=ind+1
	quit
}

Query FindOrdForHUI(Cat As %String, SubCat As %String, OrderStatus As %String, Alias As %String, Desc As %String, type As %String, HospId As %String = "") As %Query(ROWSPEC = "ordtype2,ordchildtype,ordname2,isARCOS,OrdAlias1,ordprice2,lj,DrgGdesc,ordcode,ordExternalCode,ordExternalDesc,id,tjob")
{
}

ClassMethod FindOrdForHUIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdForHUIExecute ]
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

ClassMethod FindOrdForHUIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdForHUIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFOrdPriceSearch1","FindOrdForHUI","西药[东院]","","0","","","All","10")
ClassMethod FindOrdForHUIExecute(ByRef qHandle As %Binary, Cat As %String, SubCat As %String, OrderStatus As %String, Alias As %String, Desc As %String, type As %String, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	kill ^TMP("UDHCJFOrdPriceSearch")
	kill ^TMP("UDHCJFOrdPriceSearch2",$j)
	If $g(ind)="" Set ind=1
	Set langid=..%LanguageID()
    s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s DefHospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("ARC_ItmMast",HospId)
	s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",itmname="",itmnum="",itmprice="",ordchildtype="",OrdAlias1="",DrgGdesc="" ,ordExternalCode="", ordExternalDesc=""
	s ORCATDesc=$$ALPHAUP^SSUTIL4(Cat)
	s ORSUBCATDesc=$$ALPHAUP^SSUTIL4(SubCat)
	s OrdNameDesc=$$ALPHAUP^SSUTIL4(Desc)
	s OrdAliasDesc=$$ALPHAUP^SSUTIL4(Alias)
	
	s UserID=$G(%session.Data("LOGON.USERID"))
	s LocId=$G(%session.Data("LOGON.CTLOCID"))
	k ArrArc
	if (type="ARCIM"){
		//只查询医嘱项
		d ARCIMList
	}elseif(type="ARCOS"){
		//只查询医嘱套
		d ARCOSList
	}else{
		//查询全部
		d ARCIMList
		d ARCOSList
	}
	kill ^TMP("UDHCJFOrdPriceSearch2",$j)
	Set qHandle=$lb(0,repid,0)
    quit $$$OK
OutputRow1
	set tjob=$j
	q:$d(^TMP("UDHCJFOrdPriceSearch2",$j,arcitmrow))
	s ^TMP("UDHCJFOrdPriceSearch2",$j,arcitmrow)=1
    set Data=$lb(ordtype2,ordchildtype,ordname2,isARCOS,OrdAlias1,ordprice2,"",DrgGdesc,ordcode,ordExternalCode,ordExternalDesc,arcitmrow,tjob)
 	Set ^CacheTemp(repid,ind)=Data
 	//Set ^TMP("UDHCJFOrdPriceSearch",$j,ind)=$g(ordcode)_"^"_$g(ordname2)_"^"_$g(ordtype2)_"^"_$g(ordprice2)_"^"_$g(arcitmrow)_"^"_$g(itmname)_"^"_$g(itmnum)_"^"_$g(itmprice)_"^"_$g(ordchildtype)_"^"_$g(OrdAlias1)_"^"_$g(DrgGdesc)_"^"_$g(itmcode)_"^"_$g(ordExternalCode)_"^"_$g(ordExternalDesc)
 	Set ind=ind+1
	quit
ARCIMList
	if (ORCATDesc'=""){
		s ORSUBCATRowIdStr=""
		i ORSUBCATDesc'="" {
			s ORSUBCATRowId=0
			for {
				s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,ORSUBCATRowId)) Q:ORSUBCATRowId
				i ORSUBCATRowIdStr="" s ORSUBCATRowIdStr=ORSUBCATRowId
				else  s ORSUBCATRowIdStr=ORSUBCATRowIdStr_"^"_ORSUBCATRowId
			}
			i ORSUBCATRowIdStr'="" s ORSUBCATRowIdStr="^"_ORSUBCATRowIdStr_"^"	
		}
		s ORCATRowId=0
		for {
			s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,ORCATRowId)) Q:ORCATRowId=""
			s ARCICRowId=0
			for {
				s ARCICRowId=$o(^ARC("IC",0,"OrdCat",ORCATRowId,ARCICRowId)) Q:ARCICRowId=""
				continue:(ORSUBCATRowIdStr'="")&&(ORSUBCATRowIdStr'[("^"_ARCICRowId_"^"))
				s arcrow="0" 
				for {
					 s arcrow=$o(^ARCIM(0,"ARCIC_DR",ARCICRowId,arcrow)) q:arcrow=""
					 s sub=$o(^ARCIM(0,"ARCIC_DR",ARCICRowId,arcrow,""))
					 s arcitmrow=arcrow_"||"_sub
					 d oneARCIMLIst(arcitmrow)
				}
			}
		}
		/*s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,""))
		s arccat=""  f  s arccat=$o(^ARCIM(0,"ARCIC_DR",arccat)) q:arccat=""  d
		.s oeccat=$p(^ARC("IC",arccat),"^",8)
		.q:(oeccat'=ORCATRowId)
		.s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow)) q:arcrow=""  d
		..s sub=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow,""))
		..s ORSUBCATRowId=""
		..i ORSUBCATDesc'="" s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
		..s arcitmcat=$p(^ARCIM(arcrow,sub,1),"^",10)
		..q:((arcitmcat'=ORSUBCATRowId)&(ORSUBCATRowId'=""))
		..s arcitmrow=arcrow_"||"_sub
		..d oneARCIMLIst(arcitmrow)*/
		quit
	}
	if (ORSUBCATDesc'=""){
		s ARCICRowId=0
		for {
			s ARCICRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,ARCICRowId)) Q:ARCICRowId=""
			s arcrow="0" 
			for {
				 s arcrow=$o(^ARCIM(0,"ARCIC_DR",ARCICRowId,arcrow)) q:arcrow=""
				 s sub=$o(^ARCIM(0,"ARCIC_DR",ARCICRowId,arcrow,""))
				 s arcitmrow=arcrow_"||"_sub
				 d oneARCIMLIst(arcitmrow)
			}
		}
		/*s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
		s arcsubcat=""  f  s arcsubcat=$o(^ARCIM(0,"ARCIC_DR",arcsubcat)) q:arcsubcat=""  d
		.q:(arcsubcat'=ORSUBCATRowId)
		.s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arcsubcat,arcrow)) q:arcrow=""  d
		..s sub=$o(^ARCIM(0,"ARCIC_DR",arcsubcat,arcrow,""))
		..s arcitmrow=arcrow_"||"_sub
		..q:arcitmrow=""
		..d oneARCIMLIst(arcitmrow)*/
		quit
	}
	if (OrdAliasDesc'=""){
		k ^CHHTEMP("ALIASBJ")
		s OrdAliasDesc=$g(OrdAliasDesc)
		s tempOrdAlias=""
		s id="0" f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
		.s symbo=0
		.s text=$p(^ARC("ALIAS",id),"^",6)
		.s text=$$ALPHAUP^SSUTIL4(text)
		.q:(text '[ OrdAliasDesc)
		.s AliasType=$p(^ARC("ALIAS",id),"^",5)
		.q:AliasType'="ARCIM"
		.s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
		.q:arcitmrow=""
		.d oneARCIMLIst(arcitmrow)
		quit
	}
	s id1=0 f  s id1=$o(^ARCIM(id1)) q:id1=""  d
	.s id2=0 f  s id2=$o(^ARCIM(id1,id2)) q:id2=""  d
	..s arcitmrow=id1_"||"_id2
	..d oneARCIMLIst(arcitmrow)
	quit
oneARCIMLIst(arcitmrow)
	Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",arcitmrow,DefHospId)="N"
	Q:'($d(^ARCIM(+arcitmrow,$p(arcitmrow,"||",2),1)))
	q:$d(ArrArc(arcitmrow))
	s valFlag=$$valrownew(arcitmrow)
	Quit:(valFlag)&&(OrderStatus=1)
	Quit:('valFlag)&&(OrderStatus=2)
	s ordname2=$p(^ARCIM(+arcitmrow,1,1),"^",2)
	s ordname2=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ordname2,langid)
	q:(ordname2'[OrdNameDesc)&&(OrdNameDesc'="")
	s ordOnItOwn=$p($g(^ARCIM(+arcitmrow,1,7)),"^",13)
    q:$g(ordOnItOwn)="N"
	s lei=$p(^ARCIM(+arcitmrow,1,1),"^",10)
	if (ORSUBCATDesc'=""){
		s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
		q:(ORSUBCATRowId'="")&&(ORSUBCATRowId'=lei)
	}
	i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	s daleicode=$p(^ARC("IC",lei),"^",8)
	i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	s arcitmrow=$g(arcitmrow)
	s i=0,text="",AllAlias=""
	s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	.s tmpalias=$p(^ARC("ALIAS",aid),"^",6)
	.s tmpalias=$$ALPHAUP^SSUTIL4(tmpalias)
	.i AllAlias="" s AllAlias=tmpalias
	.e  s AllAlias=AllAlias_"/"_tmpalias
	.q:(tmpalias '[ OrdAliasDesc)&&(OrdAliasDesc'="")
	.i text'=""  d
	..s text=text_"/"_tmpalias
	.e  d
	..s text=tmpalias
	q:text=""
	s text=AllAlias
	s ArrArc(arcitmrow)=arcitmrow
	s OrdAlias1=$g(text)
    s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	i DrgFormRowid'="" d
	.s DrgMastRowid=$p(DrgFormRowid,"||",1)
	i DrgMastRowid'="" d
	.i $d(^PHCD(DrgMastRowid,4)) d
	..s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	..i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",HospId)
	s ordprice2=$j($p(tmpprice,"^",1),3,2)
	s ordExternalCode="",ordExternalDesc=""
	s chl="" f  s chl=$o(^ARCIM(+arcitmrow,1,"EXT",chl)) q:chl=""  d
	.s tod=$p($g(^ARCIM(+arcitmrow,1,"EXT",chl)),"^",2)
	.q:(tod'="")&(tod<+$h)
	.s ordExternalCode=$p($g(^ARCIM(+arcitmrow,1,"EXT",chl)),"^",4)
	.s ordExternalDesc=$p($g(^ARCIM(+arcitmrow,1,"EXT",chl)),"^",6)
	s ordcode=$p(^ARCIM(+arcitmrow,1,1),"^",1)
	s isARCOS="No",price=0
	//ordtype2,ordchildtype,ordname2,isARCOS,OrdAlias1,ordprice2,"",DrgGdesc,ordcode,ordExternalCode,ordExternalDesc,arcitmrow
	do OutputRow1
	quit
ARCOSList
	if (ORCATDesc'=""){
		s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,""))
		if (ORCATRowId="") quit
		s ARCOSRowId=0
		f  s ARCOSRowId=$o(^ARCOS(0,"OrdCat",ORCATRowId,ARCOSRowId)) q:ARCOSRowId=""  d
		.d oneARCOSList(ARCOSRowId)
		quit
	}
	if (ORSUBCATDesc'=""){
		s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
		if ORSUBCATRowId="" quit
		s ARCOSRowId=0
		f  s ARCOSRowId=$o(^ARCOS(0,"ItemCat",ORSUBCATRowId,ARCOSRowId)) q:ARCOSRowId=""  d
		.d oneARCOSList(ARCOSRowId)
		quit
	}
	if (OrdAliasDesc'=""){
		s AliasText=$o(^ARC("ALIAS",0,"Desc",OrdAliasDesc),-1)
		f  s AliasText=$o(^ARC("ALIAS",0,"Desc",AliasText)) q:(AliasText="")!(AliasText'[OrdAliasDesc)  d
		.s ALiasDesc=""
		.f  s ALiasDesc=$o(^ARC("ALIAS",0,"Desc",AliasText,ALiasDesc))  q:ALiasDesc=""  d
		..s AliasRowID=""
		..f  s AliasRowID=$o(^ARC("ALIAS",0,"Desc",AliasText,ALiasDesc,AliasRowID))  q:AliasRowID=""  d
		...q:$d(^ARC("ALIAS",AliasRowID))=0
		...s AliasType=$p(^ARC("ALIAS",AliasRowID),"^",5)
		...q:AliasType'="ARCOS"
		...s ARCOSRowID=$p(^ARC("ALIAS",AliasRowID),"^",2)
		...d oneARCOSList(ARCOSRowID)
		quit
	}
	if (OrdNameDesc'=""){
		s desc=$o(^ARCOS(0,"Desc",OrdNameDesc),-1)
		f  s desc=$o(^ARCOS(0,"Desc",desc)) q:(desc="")||(desc'[OrdNameDesc)  d
		.s ARCOSRowID=""
		.f  s ARCOSRowID=$o(^ARCOS(0,"Desc",desc,ARCOSRowID)) q:(ARCOSRowID="")  d
		..d oneARCOSList(ARCOSRowID)
		quit
	}
	s ARCOSRowID=""
	f  s ARCOSRowID=$o(^ARCOS(ARCOSRowID)) q:ARCOSRowID=""  d
	.d oneARCOSList(ARCOSRowID)
	quit
oneARCOSList(ARCOSRowId)
	s FavRowId=$o(^DHCFavItems(0,"ItemRowid",ARCOSRowId,""))
	q:FavRowId=""
	;医嘱套使用院区,非本院区不可见
	s FavUseHospDr=$p($g(^DHCFavItems(FavRowId)),"^",11)
	i (FavUseHospDr'=HospId) s find=1 Q
	s valFlag=$$valarcosnew(ARCOSRowId)
	Quit:((valFlag)&&(OrderStatus=1))
	Quit:((valFlag=0)&&(OrderStatus=2))
	s FavHospDr=$p(^DHCFavItems(FavRowId),"^",9)
	s FavUserDr=$p(^DHCFavItems(FavRowId),"^",2)
	s FavDepDr=$p(^DHCFavItems(FavRowId),"^",4)
	q:(FavHospDr'="")&&(FavHospDr'=HospId)
	q:(FavUserDr'="")&&(FavUserDr'=UserID)
	q:(FavDepDr'="")&&(FavDepDr'=LocId)
	s ARCOSDateRowid=..GetOrderSetDate(ARCOSRowId) 
	q:'ARCOSDateRowid
	s ordname2=$p(^ARCOS(ARCOSRowId),"^",2)
	q:($$ALPHAUP^SSUTIL4(ordname2)'[OrdNameDesc)&&(OrdNameDesc'="")
	s ARCOSPrice=0
	s item=0 f  s item=$o(^ARCOS(ARCOSRowId,"DATE",ARCOSDateRowid,"ITM",item)) q:item=""  s s=^(item) d
	.s ARCIMRowid=$p(s,"^",1)
	.q:..ValARCItem(ARCIMRowid)
	.s ARCOSItemQty=$p(s,"^",2)
	.if ARCOSItemQty="" s ARCOSItemQty=1
	.s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIMRowid,+$H,"","","","",HospId)
	.s ordprice2=$j($p(tmpprice,"^",1),3,2)
	.s ARCOSPrice=ARCOSPrice+(ordprice2*ARCOSItemQty)
	
	//ordtype2,ordchildtype,ordname2,isARCOS,OrdAlias1,ordprice2,"",DrgGdesc,ordcode,ordExternalCode,ordExternalDesc,arcitmrow
	s ARCOSOrdCatDR=$p(^ARCOS(ARCOSRowId),"^",8)
	s ordtype2=$p(^OEC("ORCAT",ARCOSOrdCatDR),"^",2)
	s ARCOSItemTypeDR=$p(^ARCOS(ARCOSRowId),"^",9)
	s ordchildtype=$p(^ARC("IC",ARCOSItemTypeDR),"^",2)
	if (ORSUBCATDesc'=""){
		s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
		q:(ORSUBCATRowId'="")&&(ORSUBCATRowId'=ARCOSItemTypeDR)
	}
	s isARCOS="Yes"
	s i=0,text="",AllAlias=""
	s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCOS",ARCOSRowId,aid))  q:aid=""  d
	.s tmpalias=$p(^ARC("ALIAS",aid),"^",6)
	.s tmpalias=$$ALPHAUP^SSUTIL4(tmpalias)
	.i AllAlias="" s AllAlias=tmpalias
	.e  s AllAlias=AllAlias_"/"_tmpalias
	.q:(tmpalias '[ OrdAliasDesc)&&(OrdAliasDesc'="")
	.i text'=""  d
	..s text=text_"/"_tmpalias
	.e  d
	..s text=tmpalias
	q:text=""
	s text=AllAlias
	s OrdAlias1=$g(text)
	s ordprice2=$fn(ARCOSPrice,"",2)
	s DrgGdesc=""
	s ordcode=$p(^ARCOS(ARCOSRowId),"^",1)
	s ordExternalCode="",ordExternalDesc=""
	s arcitmrow=ARCOSRowId
	do OutputRow1 
valrownew(row) ;validate if arcim is active 0-active,1-not active
	 n (row)
	 s datefrom=$p($g(^ARCIM(+row,1,1)),"^",13)
	 s dateto=$p($g(^ARCIM(+row,1,7)),"^",1)
	 i datefrom>+$h q 1
	 i dateto,dateto<+$h q 1
	 s ordOnItOwn=$p($g(^ARCIM(+row,1,7)),"^",13)
	 Quit:ordOnItOwn="N" 1
	 q 0
valarcosnew(row) ;validate if arcos is active 0-active,1-not active
	n (row)
	s datefrom=$p($g(^ARCOS(+row)),"^",15)
	s dateto=$p($g(^ARCOS(+row)),"^",16)
	i datefrom>+$h q 1
	i dateto,dateto<+$h q 1
	q 0
}

/// w ##class(%ResultSet).RunQuery("web.UDHCJFOrdPriceSearch1","QueryArcimLinkTar","11578||1")
Query QueryArcimLinkTar(arcimrowid = "", HospID = "", LangID As %String = "") As websys.Query(ROWSPEC = "olttariffdr,tarcode,tardesc,tarnum,taruom,tarDate,tarDateTo,OLTBascPriceFlag,OLTBillOnceFlag,tarprice")
{
}

ClassMethod QueryArcimLinkTarExecute(ByRef qHandle As %Binary, arcimrowid = "", HospID = "", LangID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:arcimrowid="" $$$OK
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s ItemCatDR=$p($g(^ARCIM(+arcimrowid,$p(arcimrowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i (OrderType="R") {
		s CNMedItemFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(arcimrowid,HospID) //草药标志
		s INCIrow=0
		f {
			s INCIrow=$o(^INCI(0,"ARCIM_DR",+arcimrowid,INCIrow))
			Q:INCIrow=""
			if (CNMedItemFlag=1){
				s INCIDesc="库存项--"_$p($g(^INCI(INCIrow,1)),"^",2)
				s INCICode=$p($g(^INCI(INCIrow,1)),"^",1)
				s ^CacheTemp(repid,ind)=$lb(INCIrow,INCICode,INCIDesc,"","","","","","","")
				s ind=ind+1
			}
			Set rset=##Class(%ResultSet).%New("web.DHCST.INCLINKTAR:QueryIncLinkTar")
			If rset.QueryIsValid() {
				Set Status=rset.Execute(INCIrow)
				If 'Status Quit
				Set columns = rset.GetColumnCount()
				While (rset.Next()) {
				    //lnkId,tarItmId,tarItmCode,tarItmDesc,uomDesc,qty,sp,lnkStDate,lnkEdDate
					s olttariffdr=rset.Data("tarItmId")
					s tarcode=rset.Data("tarItmCode")
					s tardesc=rset.Data("tarItmDesc")
					s tardesc=$s((tardesc'=""):##class(User.DHCTarItem).GetTranByDesc("TARIDesc",tardesc,LangID),1:"")
					s tarnum=rset.Data("qty")
					s taruom=rset.Data("uomDesc")
					s taruom=$s((taruom'=""):##class(User.CTUOM).GetTranByDesc("CTUOMDesc",taruom,LangID),1:"")
					s tarDate=rset.Data("lnkStDate")
					s tarDateTo=rset.Data("lnkEdDate")
					s OLTBascPriceFlag="N"
					s OLTBillOnceFlag="N"
					s tarprice=rset.Data("sp")
					s ^CacheTemp(repid,ind)=$lb(olttariffdr,tarcode,tardesc,tarnum,taruom,tarDate,tarDateTo,OLTBascPriceFlag,OLTBillOnceFlag,tarprice)
					s ind=ind+1
				}
			}
		}
	}else{
		Set rset=##Class(%ResultSet).%New("web.DHCBL.CT.DHCOrderLinkTar:GetList")
		If rset.QueryIsValid() { 
			Set Status=rset.Execute(arcimrowid,"Y",HospID)
			If 'Status Quit
			Set columns = rset.GetColumnCount()
			While (rset.Next()) {
				s olttariffdr=rset.Data("olttariffdr")
				s tarcode=rset.Data("tarcode")
				s tardesc=rset.Data("tardesc")
				s tardesc=$s((tardesc'=""):##class(User.DHCTarItem).GetTranByDesc("TARIDesc",tardesc,LangID),1:"")
				s tarnum=rset.Data("tarnum")
				s taruom=rset.Data("taruom")
				s taruom=$s((taruom'=""):##class(User.CTUOM).GetTranByDesc("CTUOMDesc",taruom,LangID),1:"")
				s tarDate=rset.Data("tarDate")
				s tarDateTo=rset.Data("tarDateTo")
				s OLTBascPriceFlag=rset.Data("OLTBascPriceFlag")
				s OLTBillOnceFlag=rset.Data("OLTBillOnceFlag")
				s tarprice=rset.Data("tarprice")
				s ^CacheTemp(repid,ind)=$lb(olttariffdr,tarcode,tardesc,tarnum,taruom,tarDate,tarDateTo,OLTBascPriceFlag,OLTBillOnceFlag,tarprice)
				s ind=ind+1
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
