Import SQLUser

Class web.DHCDOCPDAENTRY Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 220;

ClassMethod AIMRecLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AIMRecLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod AIMRecLocExecute(ByRef qHandle As %Binary, PAADMRowID As %String, ARCIMRID As %String) As %Status
{
 New repid, index
	Set repid=$I(^CacheTemp)
	 ;
 Set qHandle=$lb(0,repid,0)
 ;Set ind=1
	
	s index=1			;;SubCategory
 s oldnamespace=$ZNSPACE
 s datanamespace=$LIST(^websys.ConfigurationD(1),12)
 zn datanamespace
	
		k tmprecloc
		s nCount=0
		s rtnvalue=$$getall^aOET3a(PAADMRowID,ARCIMRID)
 i rtnvalue=0
 {
	   		s nCount=$o(PLIST(""),-1)
	   		For i=1:1:nCount {
		   		s tmprecloc(i)=PLIST(i)
		   	}
		}
 zn oldnamespace  ; Restore the namespace
	
	;Data Out;
	d BuildData
	
	Quit $$$OK
BuildData
	;PAADMRowID,ARCIMRID
	;就诊科室?医嘱项
	;优先?1?就诊科室?医嘱项 ? 2?默认
	;^ARCIM({ARCIM_Subscript},{ARCIM_Version})
	;^ARC("IC",{ARCIC_RowId})
	;^ARC("IC",{ARC_ItemCat.ARCIC_RowId},"RL",{RL_Childsub})
	s EpisodeID=""
	s myRecdefLoc=""	;Default Location
	s myRecOrdLoc=""	;
	s fflag=0
	;就诊科室
	i PAADMRowID'="" d
	.s EpisodeID=$p($g(^PAADM(PAADMRowID)),"^",4)
	
	s mydeflocid=""	;Default Receive Location;
	;医嘱项默认?
	
	;医嘱子类默认
	s subCatDr=$p($g(^ARCIM(+ARCIMRID,1,1)),"^",10)
	
	s rlSub=""
	f rlSub=$o(^ARC("IC",subCatDr,"RL",rlSub)) q:rlSub=""  d
	.q:myRecOrdLoc=""
	.s OrdLocDR=$p(^ARC("IC",subCatDr,"RL",rlSub),"^",2)
	.s RecLocDR=$p(^ARC("IC",subCatDr,"RL",rlSub),"^",3)
	.s DefaultFlag=$p(^ARC("IC",subCatDr,"RL",rlSub),"^",4)
	.i EpisodeID=OrdLocDR d
	..s myRecOrdLoc=RecLocDR
	.i DefaultFlag="Y" d
	..s myRecdefLoc=RecLocDR
	
	i myRecOrdLoc="" d
	.s myRecOrdLoc=myRecdefLoc
	
	for myindx=1:1:nCount {
		d ResetVariablesRecLoc
		s bDefRecFlag=""
		s bRecLocRID=$p(tmprecloc(myindx),$c(2),1)
		s bRecLocDesc=$p(tmprecloc(myindx),$c(2),2)
		s bDefRecFlag=$p(tmprecloc(myindx),$c(2),3)
		
		;i myRecOrdLoc=bRecLocRID d
		;.s bDefRecFlag=1
		d OutputRowRecLoc
	}
	quit
OutputRowRecLoc
	s Data=$lb(bRecLocDesc,bRecLocRID,bDefRecFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
ResetVariablesRecLoc
	s (bRecLocDesc,bRecLocRID)=""
	s bDefRecFlag=0
	quit
}

ClassMethod AIMRecLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AIMRecLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				
 Set AtEnd=1
 Set Row=""
 }
 Else      {				
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ARCIMastListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ARCIMastListExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod ARCIMastListExecute(ByRef qHandle As %Binary, ARCCATCode As %String, ItemMCode As %String, UGroupRowID As %String) As %Status
{
 New repid, index
	Set repid=$I(^CacheTemp)
	 ;
 Set qHandle=$lb(0,repid,0)
 Set ind=1
	
	s index=1			;;SubCategory
	set retval=$$open(ARCCATCode,ItemMCode,UGroupRowID)
	for  s retval=$$fetch(ARCCATCode,ItemMCode,UGroupRowID) q:retval="100"  d
		.;w index,!
 .Do OutputRow
	set retval=$$close()
	Quit $$$OK
open(CATEG,TEXT,user) 
	k ^TMP($zn,$j)
	;;s ^zleon($zn,"o")=CATEG_"^"_TEXT_"^"_user
	s TEXT=$g(TEXT),CATEG=$g(CATEG)
	s TEXT1=$ZCVT(TEXT,"U")
	s TEXT=$ZCVT(TEXT,"U")
	;
	s DESC=0,ROW=0,TEXT0=TEXT 
	i TEXT,TEXT=+TEXT s TEXT0=TEXT_$c(1)
	s:TEXT0="" TEXT0=0
	;build list of categories for user
	k UserCat
	s ord=0 
	f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  d
		.s s=^(ord)
		.s UserCat(+s)=$p(s,"^",3,4)
	;decide which index to use
	s SubScr=$$subscr(CATEG)
	q 0
fetch(CATEG,TEXT,user) 
	 s TEXT=$g(TEXT),CATEG=$g(CATEG)
	 s TEXT1=$ZCVT(TEXT,"U")
	 s TEXT=$ZCVT(TEXT,"U")
	 s SubScr=$g(SubScr),DESC=$g(DESC),ROW=$g(ROW),TEXT0=$g(TEXT0)
	 k PLIST 
	 i CATEG="" g it3
	 i CATEG'="" g it31
it1 ;
	 s TEXT0=$o(^ARC("ALIAS",0,SubScr,TEXT0)),DESC=""
it2 q:TEXT0="" 100
	 ;i TEXT=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT g it1 ;q 100
	 i $l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT q 100
	 ;i TEXT'=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT q 100
	 s DESC=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC)),ROW=""
	 g:DESC="" it1
it3 q:$g(TEXT0)="" 100
	 g:$g(DESC)="" it1
	 s ROW=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW))
	 g:ROW="" it2
	 s ind=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW,""))
	 g:ind="" it3
	 s str=$g(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW,ind))
	 s ROW1=$p(str,"^"),type=$p(str,"^",2),genflag=$p(str,"^",3)
	 ;i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y" g it3
	 i $e($ZCVT(TEXT0,"U"),1,$l(TEXT1))'[TEXT1 g it3
	 i type="ARCOS" s subCATEG=$p($g(^ARCOS(+ROW1)),"^",9)
	 e  s subCATEG=$p($g(^ARCIM(+ROW1,1,1)),"^",10)
	 i '$$valord(user,subCATEG,type,ROW1) g it3
	 i type="ARCIM",$$valrow(ROW1) g it3
	 i type="ARCOS",$$valarcos(ROW1) g it3
	 i $d(^TMP($zn,$j,type_"^"_ROW1)) g it3
	 s ^TMP($zn,$j,type_"^"_ROW1)=""
	 s flag=$s(TEXT0=DESC:"",ROW=ROW1:"",$g(^ARC("ALIAS",ROW))'="":$P($G(^ARC("ALIAS",ROW)),"^",6)_"-",type["ARCIM":$p($g(^ARCIM(+ROW1,1,8)),"^",21)_"-",1:"")
	 ;i type="ARCIM",flag="" d
	 i type="ARCIM" d
	 .s generdesc=$p($g(^ARCIM(+ROW,1,8)),"^",21)
	 .i $ZCVT(generdesc,"U")=TEXT0 s flag=generdesc_"-"
	 i type="ARCIM",genflag d
	 .s flag=$p($g(^ARCIM(+ROW1,1,"GEN",genflag)),"^",2)_"-"
	 i type["ARCIM" s err=$$selectarcim(ROW1) g:err it3 s desc=flag_desc q "ARCIM"
	 i type["ARCOS" s err=$$selectarcos(ROW1) g:err it3 s desc=flag_desc q "ARCOS"
	 q 0
 ;
it11 ;
	 s TEXT0=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0)),DESC=""
it21 q:TEXT0="" 100
	 ;i TEXT=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT g it11 ;q 100
	 i $l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT q 100
	 s DESC=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC)),ROW=""
	 g:DESC="" it11
it31 q:$g(TEXT0)="" 100
	 g:$g(DESC)="" it11
	 s ROW=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW))
	 g:ROW="" it21
	 s ind=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW,""))
	 g:ind="" it21
	 s str=$g(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW,ind))
	 s ROW1=$p(str,"^"),type=$p(str,"^",2)
	 ;i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y" g it31
	 i type="ARCIM",$$valrow(ROW1) g it31
	 i type="ARCOS",$$valarcos(ROW1) g it31
	 i $e($ZCVT(TEXT0,"U"),1,$l(TEXT1))'[TEXT1 g it31
	 s flag=$s(TEXT0=DESC:"",1:$P($G(^ARC("ALIAS",ROW)),"^",6)_"-")
	 i type="ARCIM",flag="" d
	 .s generdesc=$p($g(^ARCIM(+ROW,1,8)),"^",21)
	 .i $ZCVT(generdesc,"U")=TEXT0 s flag=generdesc_"-"
	 s err=0
	 i type["ARCIM" s err=$$selectarcim(ROW1) 
	 i type["ARCOS" s err=$$selectarcos(ROW1)
	 g:err it31 
	 s $p(PLIST(1),$c(2),2)=flag_$p(PLIST(1),$c(2),2) 
	 i $l(type),ROW1,$d(^TMP($zn,$j,type,ROW1_"^"_desc)) g it31
	 i $l(type),ROW1 s ^TMP($zn,$j,type,ROW1_"^"_desc)=""
	 i type="ARCIM" q "ARCIM"
	 i type="ARCOS" q "ARCOS"
	 q 0
close() 
	k UserCat,TEXT,TEXT0
	k ^TMP($zn,$j)
	q 0
selectarcim(RowID)	k PLIST
	&SQL(SELECT ARCIM_RowId,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef,ARCIM_PHCDF_DR->PHCDF_PHCF_DR->PHCF_Desc,ARCIM_PHCDF_DR,
			ARCIM_RiceType_DR,ARCIM_RiceType_DR->RIC_Desc,ARCIM_ConsultDept,ARCIM_ConsultDept->CTLOC_Desc,
			ARCIM_ItemCat_DR,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,ARCIM_MealType_DR,ARCIM_MealType_DR->MEALT_Desc,
			ARCIM_PriceCostOnOrdering,ARCIM_InsSubCat_DR,ARCIM_DefPriority_DR,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_Code,
			ARCIM_PHCDF_DR->PHCDF_PHCFR_DR->PHCFR_Code,ARCIM_ItemCat_DR->ARCIC_OrderType,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,
			ARCIM_OEMessage,ARCIM_RangeFrom,ARCIM_RangeTo,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCDU_DR,
			ARCIM_PHCDF_DR->PHCDF_GenRtForm_DR,ARCIM_ItemCat_DR->ARCIC_Desc 
	   INTO :rowid,:desc,:code,:code1,:code2,:rice,:ricedes,:cons,:consdes,
	        :subcat,:categ,:mealt,:mealtdes,:cost,:inssubcat,:prior,:priordesc,
	        :arcimcode,:phfreqcode,:subcatordtype,:ordcatid,
	        :oemessage,:rangefrom,:rangeto,:phuomdesc,:phdurrowid,
	        :generic,:subcatdesc
	   FROM Sqluser.ARC_ItmMast  WHERE ARCIM_RowId=:RowID)
	i 'SQLCODE d adjust1
	q SQLCODE
	;subcatordertype
adjust1	;
	;s cost=$p($g(cost),$c(1)) s:cost="" cost="N"  ,ItemPrice:%Float
	;s PLIST(1)=$p(rowid,$c(1))_$c(2)_desc_$c(2)_$p(code,$c(1))_$c(2)_$p(code1,$c(1))_$c(2)_$p(code2,$c(1))_$c(2)_$p(rice,$c(1))_$c(2)_ricedes_$c(2)_$p(cons,$c(1))_$c(2)_consdes_$c(2)_categ_$c(2)_subcat_$c(2)_$p(mealt,$c(1))_$c(2)_mealtdes_$c(2)_cost_$c(2)_inssubcat_$c(2)_prior_$c(2)_priordesc_$c(2)_$p($g(^ARC("IC",+subcat)),"^",15)_$c(2)_arcimcode
	;s PLIST=$o(PLIST(""),-1)
	s ItemPrice=0
	s rowid=$p(rowid,$c(1))
	s SttDate=+$H
	s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice=""
	s retPrice=..GetOrderPrice(PatType, InsType, rowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	s ItemPrice=$fn($P(retPrice,"^",1),"",6)		;4--->6
	s generic=""
	;s desc=flag_desc
 ;//s Data=$lb(desc,rowid,$p(phfreqcode,$c(1)),type,TEXT0,subcatcode,$p(ordcatid,$C(1)),"",oemessage,rangefrom,rangeto,phuomdesc,$p(phdurrowid,$C(1)),generic,"","","",subcatdesc,ItemPrice)
	i $P(desc,"-",2)'="" s desc=$P(desc,"-",2)
	s Data=$lb(desc,rowid,subcatdesc,subcatordtype,phuomdesc,ItemPrice,$p(phfreqcode,$c(1)),type,TEXT0,$p(ordcatid,$C(1)),"",oemessage,rangefrom,rangeto,$p(phdurrowid,$C(1)),generic,"","","")
	q
selectarcos(RowID)	k PLIST
	;b		;selectarcos
	&SQL(SELECT ARCOS_RowId,ARCOS_Desc,ARCOS_LabTrakTestSet,ARCOS_DefPriority_DR,ARCOS_DurationDR,ARCOS_FrequencyDR,ARCOS_OrdCat_DR,ARCOS_OrdSubCat_DR->ARCIC_Desc
	       INTO :rowid,:desc,:code,:prior,:durrowid,:freqcode,:ordcatid,:subcatdesc
	       FROM SQLUser.ARC_OrdSets WHERE ARCOS_RowId=:RowID)
	;&SQL(SELECT ARCOS_Desc FROM ARC_OrdSets)
	i 'SQLCODE d adjust2
	q SQLCODE
adjust2	;
	;s PLIST(1)=$p(rowid,$c(1))_$c(2)_desc_$c(2)_code_$c(2)_$p($g(prior),$c(1))_$c(1)_$p($g(^OECPR(+$g(prior))),"^",2)
	;s PLIST=$o(PLIST(""),-1)
	s rowid=$p(rowid,$C(1),1)
	s retval=$$getOSItemIDs(rowid)
	s OSItemIDs=$p(retval,$C(4),1)
	s OSPrice=$fn($p(retval,$C(4),2),"",6)		;4--->6
	;s desc=flag_desc			;phFreqCode,ARCType
 ;//s Data=$lb(desc,rowid,"",type,TEXT0,"",$p(ordcatid,$C(1)),"","","","","","","",OSItemIDs,"","",subcatdesc,OSPrice)
	i $P(desc,"-",2)'="" s desc=$P(desc,"-",2)
	s Data=$lb(desc,rowid,subcatdesc,"","",OSPrice,"",type,TEXT0,$p(ordcatid,$C(1)),"","","","","","",OSItemIDs,"","")
	q
	;
valord(user,subCATEG,type,ROW1) ;validate usergroup and CATEGory
	 ;1-valid,0-invalid
	 n (UserCat,user,subCATEG,type,ROW1)
	 s CATEG=$p($g(^ARC("IC",+subCATEG)),"^",8)
	 ;b
	 q:'user 1
	 i '$d(UserCat(+CATEG)) q 0
	 s s=UserCat(+CATEG),vis=$p(s,"^"),os=$p(s,"^",2)
	 i type="ARCOS",os'="Y" q 0
	 i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y",vis'="Y" q 0
	 q 1
	 ;
	 s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  s s=^(ord) d
	 .i '(s-CATEG) s found=1
	 q found
 ;        
ALPHAUP(val,remove)
 s %trans(1)="abcdefghijklmnopqrstuvwxyz !,""#$%&'()*+-./:;<=>@[\]^_`{|},~",%trans(2)="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 q:'$d(remove) $tr(val,%trans(1),%trans(2)) q $tr(val,$tr(%trans(1),remove),%trans(2))
UP(val,remove) 
 s %trans(1)="abcdefghijklmnopqrstuvwxyz",%trans(2)="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 q:'$d(remove) $tr(val,%trans(1),%trans(2)) q $tr(val,$tr(%trans(1),remove),%trans(2))
valrow(row) ;validate if arcim is active 0-active,1-not active
	 n (row)
	 s datefrom=$p($g(^ARCIM(+row,1,1)),"^",13)
	 s dateto=$p($g(^ARCIM(+row,1,7)),"^",1)
	 i datefrom>$h q 1
	 i dateto,dateto<$h q 1
	 q 0
valarcos(row) ;validate if arcos is active 0-active,1-not active
	n (row)
	s datefrom=$p($g(^ARCOS(+row)),"^",15)
	s dateto=$p($g(^ARCOS(+row)),"^",16)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	q 0
checkos(arcos,user) ;check if user is allowed to order os
	 ;0-yes,61-no
	 n (arcos,user)
	 s grp=$p($g(^SSU("SSUSR",+user)),"^",5)
	 s ord=0 f  s ord=$o(^SSU("SSGRP",+grp,"SSORD",ord)) q:ord=""  s s=^(ord),UserCat(+s)=$p(s,"^",3,4)
	 s err=$$getall^MVBARCOI(arcos_"^ALL")
	 s found=0,ind=0
	 f  s ind=$o(PLIST(ind)) q:ind=""  q:found  d
	 .s arcim=$p(PLIST(ind),$c(2))
	 .s subcat=$p($g(^ARCIM(+arcim,1,1)),"^",10)
	 .s orcat=$p($g(^ARC("IC",+subcat)),"^",8)
	 .i '$d(UserCat(+orcat)) s found=61
	 q found
subscr(subCATEG) ;decide which index to use
	n (subCATEG,UserCat)
	;
	;
	s CATEG=$p($g(^ARC("IC",+subCATEG)),"^",8)
	s subscr="NoItems"
	i CATEG,'$d(UserCat(+CATEG)) q subscr
	i CATEG d  q subscr
	.s s=UserCat(+CATEG),vis=$p(s,"^"),os=$p(s,"^",2)
	.i vis="Y",os="Y" s subscr="OrderCat-Desc"
	.i vis'="Y",os="Y" s subscr="OrderCat-DescVIOS"
	.i vis="Y",os'="Y" s subscr="OrderCat-DescI"
	.i vis'="Y",os'="Y" s subscr="OrderCat-DescVI"
	;
	;check what are settings of all order categories
	s vis="N",os="N"
	s cat="" f  s cat=$o(UserCat(cat)) q:cat=""  s s=UserCat(cat) d
	.i $p(s,"^")="Y" s vis="Y"
	.i $p(s,"^",2)="Y" s os="Y"
	i vis="Y",os="Y" s subscr="Desc"
	i vis'="Y",os="Y" s subscr="DescVIOS"
	i vis="Y",os'="Y" s subscr="DescI"
	i vis'="Y",os'="Y" s subscr="DescVI"
	q subscr
getOSItemIDs(ARCOSRowid)
	do ..OpenGetAllOrderSetItem(ARCOSRowid)
	s n=0,ARCOSPrice=0
	s OSItemIDs=""
	s SttDate=+$h
	s PatType="",InsType="",PriorRowid="",InstrRowid="",LinkTo="",OEPrice=""
	s count=0  f  s count=$o(^CacheTemp("ARCOI",$j,count)) q:count=""  d 
	.s item=0 f  s item=$o(^CacheTemp("ARCOI",$j,count,item)) q:item=""  s s=^(item) d
 ..s ARCIMRowid=$p(s,"^",1)
 ..s ARCOSItemQty=$p(s,"^",2)
 ..s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	..s retPrice=..GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	..;w retPrice,!
	..s Price=$P(retPrice,"^",1)
	..s ARCOSPrice=ARCOSPrice+$fn(Price*ARCOSItemQty,"",6)		;;4--->6
 ..s n=n+1
 ..i n=1  s OSItemIDs=ARCIMRowid_$C(14)_ARCIMDesc
 ..e  s OSItemIDs=OSItemIDs_$C(12)_ARCIMRowid_$C(14)_ARCIMDesc
 i OSItemIDs'="" s OSItemIDs=OSItemIDs_$C(4)_ARCOSPrice
 q OSItemIDs
OutputRow
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariables
	///set (repid)=0
	quit
}

ClassMethod ARCIMastListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ARCIMastListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				
 Set AtEnd=1
 Set Row=""
 }
 Else      {				
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CloseGetAllOrderSetItem(ARCOSRowid As %String)
{
	K ^CacheTemp("ARCOI",$j)
}

ClassMethod GetAllOrderSetItem(ARCOSRowid As %String)
{
	q:$g(ARCOSRowid)=""  
	s ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid) 
	q:'ARCOSDateRowid  
	d ..GetOrderSetItem(ARCOSRowid,ARCOSDateRowid)
	;下面是调出医嘱套里的医嘱套?属于嵌套调用
	s it=0 f  s it=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"OS",it)) q:it=""  s s=^(it) d
	.d ..GetAllOrderSetItem(+s)
	Q 0
}

ClassMethod GetConFac(ARCIMRowid As %String, INCIRowid As %String) As %String
{
	;s convqty=$$ConvFac^ST02(billuom,baseuom)
	s ConFac=""
	s Billuom=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	s Baseuom=$p($g(^INCI(INCIRowid,1)),"^",10)                     ; INCI_CTUOM_DR  库存基本单位
	s ConFacID="" f  s ConFacID=$O(^CT("CTCF",0,"UOM",Billuom,Baseuom,ConFacID)) q:ConFacID=""  d
	.s ConFac=$p(^CT("CTCF",ConFacID),"^",3)
	i ConFac=""  s ConFac=1
	q ConFac
}

ClassMethod GetINCI(ARCIMsub As %String) As %String
{
	;ARCIMsub传入的是ARC_ItmMast表的RowID?
	;在库存表INC_Itm表中的到RowID?
	n INCIrow
	s ARCIMsub=$p(ARCIMsub,$c(1),1)
	s INCIrow=$o(^INCI(0,"ARCIM_DR",ARCIMsub,""))
	q $g(INCIrow)
}

ClassMethod GetOrderPrice(PatType As %String, InsType As %String, ARCIMRowid As %String, SttDate As %String, PriorRowid As %String, InstrRowid As %String, LinkTo As %String, OEPrice As %String) As %String
{
	;医嘱价格?
	;w ##class(web.DHCOPItemMast).GetOrderPrice("","","205||1",+$h,"","","","")
	;w ##class(web.UDHCJFPRICE).GetOrderPrice("","","12051||1",+$h,"","12","","")
	s ARCIMSub=$p(ARCIMRowid,"||",1)
	if SttDate="" s SttDate=+$h
	s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	;w retPrice,!
	;s ^CacheTemp("zzq",1)=SttDate
	s Price=$P(retPrice,"^",1)
	s DiscPrice=$P(retPrice,"^",2)
	s InsPrice=$P(retPrice,"^",3)
	s PatPrice=$P(retPrice,"^",4)
	s INCIRowid=..GetINCI(ARCIMSub)
	s ConFac=1
	if INCIRowid'="" {
		s ConFac=..GetConFac(ARCIMRowid,INCIRowid)
		s Price=$fn(Price*ConFac,"",6)		;4--->6
		s DiscPrice=$fn(DiscPrice*ConFac,"",6)	;4--->6
		s InsPrice=$fn(InsPrice*ConFac,"",6)	;4--->6
		s PatPrice=$fn(PatPrice*ConFac,"",6)	;4--->6
	}
	Q Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice_"^"_ConFac
}

ClassMethod GetOrderPriceBroker(PatType As %String, InsType As %String, OrderType As %String, ItemRowid As %String, SttDate As %String, PriorRowid As %String, InstrRowid As %String, LinkTo As %String, OEPrice As %String) As %String
{
 if OrderType="ARCIM" d
	.s retPrice=..GetOrderPrice(PatType, InsType, ItemRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	e  d
	.s retPrice=..GetOrderSetPrice(PatType, InsType, ItemRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	.;s ^CacheTemp("zzq")=PatType_"^"_InsType_"^"_ItemRowid_"^"_SttDate_"^"_PriorRowid_"^"_InstrRowid_"^"_LinkTo_"^"_OEPrice
	Q retPrice
}

ClassMethod GetOrderSetDate(ARCOSRowid As %String) As %String
{
	n drow
	s DATE=$g(DATE) s:'DATE DATE=+$h
	s ord=+$g(ARCOSRowid) q:'ARCOSRowid 0 
	s dfrom=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",.1+DATE),-1) q:'dfrom 0
	s drow=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",dfrom,"")) q:'drow 0
	s dto=$p($g(^ARCOS(ARCOSRowid,"DATE",drow)),"^",2) i dto,dto<DATE q 0
	q drow
}

ClassMethod GetOrderSetItem(ARCOSRowid As %String, ARCOSDateRowid As %String) As %String
{
	s item=0 f  s item=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item)) q:item=""  s s=^(item) d
	.s ARCIMRowid=$p(s,"^",1)
	.q:..ValARCItem(ARCIMRowid)
	.s ARCOSItemQty=$p(s,"^",2)
	.if ARCOSItemQty="" s ARCOSItemQty=1
	.s count=$o(^TMP("ARCOI",$j,""),-1)+1
	.s ^CacheTemp("ARCOI",$j,count,item)=ARCIMRowid_"^"_ARCOSItemQty
	.;w ^CacheTemp("ARCOI",$j,count,item),!
	Q 0
}

ClassMethod GetOrderSetPrice(PatType As %String, InsType As %String, ARCOSRowid As %String, SttDate As %String, PriorRowid As %String, InstrRowid As %String, LinkTo As %String, OEPrice As %String) As %String
{
	;//医嘱套价格
	s ARCOSPrice=0
	s ARCOSDiscPrice=0
	s ARCOSInsPrice=0
	s ARCOSPatPrice=0
	do ..OpenGetAllOrderSetItem(ARCOSRowid)
	s count=0  f  s count=$o(^CacheTemp("ARCOI",$j,count)) q:count=""  d 
	.s item=0 f  s item=$o(^CacheTemp("ARCOI",$j,count,item)) q:item=""  s s=^(item) d
 ..s ARCIMRowid=$p(s,"^",1)
 ..s ARCOSItemQty=$p(s,"^",2)
	..s ARCIMSub=$p(ARCIMRowid,"||",1)
	..s retPrice=..GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	..;w retPrice,!
	..s Price=$P(retPrice,"^",1)
	..s DiscPrice=$P(retPrice,"^",2)
	..s InsPrice=$P(retPrice,"^",3)
	..s PatPrice=$P(retPrice,"^",4)
	..s ARCOSPrice=ARCOSPrice+$fn(Price*ARCOSItemQty,"",6)		;4--->6
	..s ARCOSDiscPrice=ARCOSDiscPrice+$fn(DiscPrice*ARCOSItemQty,"",6)	;4--->6
	..s ARCOSInsPrice=ARCOSInsPrice+$fn(InsPrice*ARCOSItemQty,"",6)		;4--->6
	..s ARCOSPatPrice=ARCOSPatPrice+$fn(PatPrice*ARCOSItemQty,"",6)		;4--->6
	;w ARCOSPrice_"^"_ARCOSDiscPrice_"^"_ARCOSInsPrice_"^"_ARCOSPatPrice
	Q ARCOSPrice_"^"_ARCOSDiscPrice_"^"_ARCOSInsPrice_"^"_ARCOSPatPrice
}

ClassMethod IMInfoBroker(JSFunName As %String, bPAAdmRowID As %String, bItmMastRowid As %String, bPatType As %String, bInsType As %String, bOrderType As %String, bOEPrice As %String, bARCType As %String)
{
	Set rset = ##class(%ResultSet).%New("web.DHCOPItemMast:OEItmInfo")
 Set columns = rset.GetColumnCount()
 ;//bPAAdmRowID as %String, bItmMastRowid as %String, bPatType as %String, bInsType as %String
 ;//bOEPrice as %Float,bARCType as %String
 Set rs = rset.Execute(bPAAdmRowID, bItmMastRowid,bPatType,bInsType,bOEPrice,bARCType)
 ;Set rs = rset.Execute("2","8586||1","","","","ARCIM")
	s myIdx=0
 While (rset.Next()) {
	 	s myRowVal=""
	 	For mycol=1:1:columns {
		 	s mydata=rset.GetData(mycol)
 s myRowVal=$g(myRowVal)_$g(mydata)_$C(2)	//行集
	 	}
	 	s myval=$g(myRowVal)		//行集累加?二维表? 
 //注意在这个有回调数据错误?'这个字符需要替换
		s rtnval=JSFunName_"('"_$g(myval)_"');"
		&javascript<#(rtnval)#>
		s myIdx=myIdx+1
 }
 d rset.Close()

	q 0
}

ClassMethod IMListBroker(JSFunName As %String, ListName As %String, bARCCATCode As %String, bItemMCode As %String, bGroupRID As %String)
{
	Set rset = ##class(%ResultSet).%New("web.DHCOPItemMast:ARCIMastList")
 Set columns = rset.GetColumnCount()
 // Execute the query
 Set rs = rset.Execute(bARCCATCode,bItemMCode,bGroupRID)
	s myIdx=0
 While (rset.Next()) {
	 	s myRowVal=""
	 	For mycol=1:1:columns {
		 	s mydata=rset.GetData(mycol)
 if (mycol=1) d
 .q:($l(mydata,"-")=1)
 .;s mydata=$p(mydata,"-",2)	;ARCIMastDesc

 s myRowVal=$g(myRowVal)_$g(mydata)_$C(2)	//行集
	 	}
	 	s mydes=rset.Data("ARCIMastDesc")
	 	
	 	;显示价格
	 	s myPrice=$fn(rset.Data("ItemPrice"),"",6)		;4--->6
	 	s mySubCatDesc=$g(rset.Data("ARCSubCat"))
	 	
	 	s mydes=mydes_"   "_myPrice_"    "_mySubCatDesc
	 	s myval=myRowVal		//行集累加?二维表?
 //注意在这个有回调数据错误?'这个字符需要替换
 //myval.substring()关键字符冲突?
		s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")_"');"
		&javascript<#(rtnval)#>
		s myIdx=myIdx+1
 }

 d rset.Close()

	q 0
}

ClassMethod OEItmInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OEItmInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod OEItmInfoExecute(ByRef qHandle As %Binary, qPAAdmRowID As %String, qItmMastRowid As %String, qPatType As %String, qInsType As %String, qOEPrice As %Float, qARCType As %String) As %Status
{
 New repid, index
	Set repid=$I(^CacheTemp)
	;
 Set qHandle=$lb(0,repid,0)
 ;Set ind=1
	s index=1			;;SubCategory
	//sure qPAAdmRowID!=""

	if (qInsType="")&&(qPAAdmRowID'="")
	{
		s qInsType= $p($g(^PAADM(qPAAdmRowID,1)),"^",7)
	}
	;;各种价格?
	;PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice
	d ResetVariablesInfo
 if qARCType="ARCIM" {
		s retPrice=..GetOrderPrice(qPatType,qInsType,qItmMastRowid,+$h,"","","",qOEPrice)
		s myPrice=$p(retPrice,"^",1)
		s myDiscPrice=$p(retPrice,"^",2)
		s myInsPrice=$p(retPrice,"^",3)
		s myPatPrice=$p(retPrice,"^",4)
		;s myConFac=$p(retPrice,"^",5)
		;s myPrice=$fn(myPrice*myConFac,"",6)	;4--->6
		;s myDiscPrice=$fn(myDiscPrice*myConFac,"",6)	;4--->6
		;s myInsPrice=$fn(myInsPrice*myConFac,"",6)		;4--->6
		;s myPatPrice=$fn(myPatPrice*myConFac,"",6)		;4--->6
	 }else{
		s retPrice=..GetOrderSetPrice(qPatType,qInsType,qItmMastRowid,+$h,"","","","") 
		s myPrice=    $fn($p(retPrice,"^",1),"",6)		;4--->6
		s myDiscPrice=$fn($p(retPrice,"^",2),"",6)		;4--->6
		s myInsPrice= $fn($p(retPrice,"^",3),"",6)		;4--->6
		s myPatPrice= $fn($p(retPrice,"^",4),"",6)		;4--->6
	 }
	
	d OutputRowInfo
	
	Quit $$$OK
OutputRowInfo
	s Data=$lb(myPrice,myDiscPrice,myInsPrice,myPatPrice)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesInfo
	///set (repid)=0
	s (retPrice,myPrice,myDiscPrice,myInsPrice,myPatPrice)=""
	quit
}

ClassMethod OEItmInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OEItmInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				
 Set AtEnd=1
 Set Row=""
 }
 Else      {				
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OpenGetAllOrderSetItem(ARCOSRowid As %String)
{
	;不应该直接调用GetAllOrderSetItem?因为它没有删除^CacheTemp("ARCOI",$j)
	d ..CloseGetAllOrderSetItem(ARCOSRowid)
	d ..GetAllOrderSetItem(ARCOSRowid)
}

ClassMethod ReadPAInsTypeBroker(JSFunName As %String, ListName As %String)
{
	Set rset = ##class(%ResultSet).%New("web.DHCOPItemMast:ReadInsType")
 Set columns = rset.GetColumnCount()
 // Execute the query
 Set rs = rset.Execute()
	s myIdx=0
 While (rset.Next()) {
	 	s mydes=$g(rset.Data("REA_Desc"))
	 	s myRowVal=""
	 	s myRowVal=$g(rset.Data("REA_RowId"))
	 	s myval=myRowVal		//行集累加?二维表?
		s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")_"');"
		&javascript<#(rtnval)#>
		s myIdx=myIdx+1
 }
	q 0
}

ClassMethod RecLocBroker(JSFunName As %String, ListName As %String, bPAADMRowID As %String, bARCIMRID As %String)
{
	;;w ##class(web.DHCOPItemMast).RecLocBroker("","","160","926||1")
	Set rset = ##class(%ResultSet).%New("web.DHCOPItemMast:AIMRecLoc")
 Set columns = rset.GetColumnCount()
 // Execute the query
 Set rs = rset.Execute(bPAADMRowID,bARCIMRID)
	s myIdx=0
 While (rset.Next()) {
	 	s myRowVal=""
	 	s defflag=0
	 	i rset.Data("DefRecFlag")="Y" d
	 	.s defflag=1
	 	
	 	s myRowVal=$g(rset.Data("RecLocRID"))_$c(2)_defflag
	 	s mydes=rset.Data("RecLocDesc")
	 	i $l(rset.Data("RecLocDesc"),"-")>1 d
	 		.s mydes=$p($p(rset.Data("RecLocDesc"),"'"),"-",2)
	 	s myval=myRowVal		//行集累加?二维表?
		s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")_"');"
		&javascript<#(rtnval)#>
		s myIdx=myIdx+1
 }
 d rset.Close()
	q 0
}

ClassMethod StopOrdItmBroker(OrdItmRID As %String, SOrdInfo As %String) As %String
{
	;w ##class(web.DHCOPItemMast).StopOrdItmBroker("1642||14","5^^^")
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	ZN MEDDATA	
	;b  ;;	StopOrdItmBroker
	Set Ret=$$StopOrdItem^DHCOrdItem(OrdItmRID,SOrdInfo)
	
	;如果此医嘱已经生成账单?要撤销账单
 ;Set PharmStatus=$$phstat^DHCOrdItem(OrdItmRID)
 ;If PharmStatus="P" {
	; 	Set Ret=$$collect^DHCOrdItem(OrdItmRID)
	; 	Set Ret=$$returnal^DHCOrdItem(OrdItmRID)
	;}
	
	ZN CurrentNS
	
	
 QUIT Ret
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

ClassMethod myTest()
{
	;;w ##class(web.DHCOPItemMast).myTest()
	Set rset = ##class(%ResultSet).%New("web.DHCOPItemMast:AIMRecLoc")
 Set columns = rset.GetColumnCount()
 // Execute the query
 Set rs = rset.Execute("160","926||1")
	s myIdx=0
 While (rset.Next()) {
	 	s myRowVal=""
	 	i (rset.Data("DefRecFlag")="Y") d
	 	.b		;;;
	 	s myRowVal=$g(rset.Data("RecLocRID"))_$c(2)_""_rset.Data("DefRecFlag")
	 	w rset.Data("DefRecFlag"),!
	 	w $g(rset.Data("RecLocRID"))_$c(2)_""_rset.Data("DefRecFlag")
	 	s mydes=rset.Data("RecLocDesc")
	 	i $l(rset.Data("RecLocDesc"),"-")>1 d
	 		.s mydes=$p($p(rset.Data("RecLocDesc"),"'"),"-",2)
	 	s myval=myRowVal		//行集累加?二维表?
		;s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")_"');"
		b	;;
 }
}

Query AIMRecLoc(PAADMRowID As %String, ARCIMRID As %String) As %Query(ROWSPEC = "RecLocDesc:%String,RecLocRID:%String,DefRecFlag:%String")
{
}

/// Read ARC_ItemMast by Code for List;
Query ARCIMastList(ARCCATCode As %String, ItemMCode As %String, UGroupRowID As %String) As %Query(ROWSPEC = "ARCIMastDesc:%String,ARCIMastRowID:%String,ARCSubCat:%String,subcatordtype:%String,phuomdesc:%String,ItemPrice:%Float,phFreqCode:%String,ARCType:%String")
{
}

Query OEItmInfo(qPAAdmRowID As %String, qItmMastRowid As %String, qPatType As %String, qInsType As %String, qOEPrice As %Float, qARCType As %String) As %Query(ROWSPEC = "oPrice:%Float,oDiscPrice:%Float,oInsPrice:%Float,oPatPrice:%Float")
{
}

Query QueryTest(mycode As %String) As %SQLQuery(ROWSPEC = "ARCIMastDesc:%String,ARCIMastRowID:%String,ARCSubCat:%String")
{
	select ARCIM_Desc,ARCIM_RowId,ARCIM_Code from SQLUser.ARC_ItmMast
	WHERE ARCIM_Code %STARTSWITH :mycode
}

Query ReadInsType() As %SQLQuery(ROWSPEC = "REA_Desc:%String,REA_RowId:%String,REA_Code:%String")
{
	select REA_Desc,REA_RowId,REA_Code from PAC_AdmReason
}

ClassMethod SaveTempOrdStr(Adm, OrdStr) As %String
{
  n (Adm,OrdStr)
  s rw=$I(^TMP("PDATEMPORD",Adm))
  s ^TMP("PDATEMPORD",Adm,rw)=OrdStr
  s $P(^TMP("PDATEMPORD",Adm,rw),"^",20)=rw
  q 0
}

ClassMethod clearTempOrd(Adm)
{
	 k ^TMP("PDATEMPORD")
}

ClassMethod GetTemOrd(Adm, Id) As %String
{
  q ^TMP("PDATEMPORD",Adm,Id)
}

ClassMethod deltempord(Adm, Id) As %String
{
   n (Adm,Id)
   k ^TMP("PDATEMPORD",Adm,Id)
   q 0
}

ClassMethod UpdateTempOrd(Adm As %String, Id As %String, OrdItem As %String) As %String
{
	n (Adm,Id,OrdItem)
	s ^TMP("PDATEMPORD",Adm,Id)=OrdItem
	q 0
}

ClassMethod GetOrdInfo(orw As %String) As %String
{
	n (orw)
	s Oew=+orw,OrdSub=$P(orw,"||",2)
 //优先级，备注，剂量（单位数量），用法，频次，数量，整包单位，接收科室
 	s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
    //s pacunit=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,8)),"^",14)
	s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
    s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3  ) ;CT_UOM                      OEORI_Unit_DR
	s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
	//if DoseQty'="" s ARCIMDesc=$P(ARCIMDesc,"(")
	s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
	i DoseQty'="" d
	.s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",4)
	s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	s Notes=""
	i $G(Notes)="" s Notes=""
    f rnum=1:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	.s Notes=Notes_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
	s RecLoc=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",6)
	q PriorDR_"^"_PHFreqDR_"^"_UOMDR_"^"_DoseQty_"^"_PhQtyOrd_"^"_MethDR_"^"_Notes_"^"_RecLoc
}

ClassMethod GetTempOrdItemExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    Set qHandle=$lb(0,repid,0)
	if Adm="" Quit $$$OK
	
	//  OrderItem=OrderARCIMRowid+"^"+OrderType+"^"+OrderPriorRowid+"^"+OrderStartDate+"^"+OrderStartTime+"^"+OrderPackQty+"^"+OrderPrice;
	//	    OrderItem=OrderItem+"^"+OrderRecDepRowid+"^"+BillTypeRowid+"^"+OrderDrugFormRowid+"^"+OrderDepProcNotes;
	//	    OrderItem=OrderItem+"^"+OrderDoseQty+"^"+OrderDoseUOMRowid+"^"+OrderQtySum+"^"+OrderFreqRowid+"^"+OrderDurRowid+"^"+OrderInstrRowid;
	//	    OrderItem=OrderItem+"^"+PHPrescType+"^"+OrderMasterSeqNo+"^"+OrderSeqNo+"^"+OrderSkinTest+"^"+OrderPhSpecInstr+"^"+OrderCoverMainIns+"^"+OrderActionRowid+"^"+OrderARCOSRowid;

	
	
	s i=""  f  s i=$O(^TMP("PDATEMPORD",Adm,i)) q:i=""  d
	.s str=^TMP("PDATEMPORD",Adm,i)
	.s ArcimId="",PriorDr="",DoseUom="",DoseQty="",Freq="",Meth="",Price="",SeqNo=""
	.s ArcimId=$P(str,"^",1)
	.s PriorDr=$P(str,"^",3)
	.s DoseDr=$P(str,"^",13)
	.s DoseQty=$P(str,"^",12)
   	.s FreqDr=$P(str,"^",15)
   	.s MethDr=$P(str,"^",17)
   	.s Num=$P(str,"^",6)
   	.s Price=$P(str,"^",7)
   	.s No=i
   	.s SeqNo=$P(str,"^",19) 
   	.if DoseDr'="" s DoseUom=$P(^CT("UOM",DoseDr),"^",2)
   	.if PriorDr'="" s Priority=$P(^OECPR(PriorDr),"^",2) 
   	.if MethDr'="" s Meth=$P(^PHCIN(MethDr),"^",2)
   	.if FreqDr'="" s Freq=$P(^PHCFR(FreqDr),"^",3)
   	.s ArcimDes=$P(str,"^",3)
   	.s ARCIMRowid=$P(ArcimId,"||",1)
	.s ARCIMSub=$P(ArcimId,"||",2)  
	.s ArcimDes=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name
   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(ArcimId,ArcimDes,DoseQty_DoseUom,Meth,Freq,Num,Priority,Price,SeqNo,No)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTempOrdItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTempOrdItemExecute ]
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

ClassMethod GetTempOrdItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTempOrdItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetTempOrdItem(EpisodeID As %String) As %Query(ROWSPEC = "ArcimRowId,ArcimDes,Dose,Meth,Freq,Num,Priority,Price,SeqNo,No,update,del")
{
}

ClassMethod gettempordstr(Adm) As %String
{
	n (Adm)
	s ret=""
   	s i=""  f  s i=$O(^TMP("PDATEMPORD",Adm,i)) q:i=""  d
	.s str=^TMP("PDATEMPORD",Adm,i)
	.s ret=ret_str_$c(1)
	k ^TMP("PDATEMPORD",Adm)
    q ret
}

ClassMethod SetRelationOrd(Adm, subno, masterno) As %String
{
 //设置关联医嘱
   n (Adm, subno, masterno) 
    if subno=masterno q 0
    if '$D(^TMP("PDATEMPORD",Adm,masterno)) q 0
    
	s MastPriorDr=$P(^TMP("PDATEMPORD",Adm,masterno),"^",3)
	s MastFreqDr=$P(^TMP("PDATEMPORD",Adm,masterno),"^",15)
	s MastDurDr=$P(^TMP("PDATEMPORD",Adm,masterno),"^",16)
	s MastInstrDr=$P(^TMP("PDATEMPORD",Adm,masterno),"^",17)
	s $P(^TMP("PDATEMPORD",Adm,subno),"^",3) =MastPriorDr
	s $P(^TMP("PDATEMPORD",Adm,subno),"^",15)=MastFreqDr
	s $P(^TMP("PDATEMPORD",Adm,subno),"^",16)=MastDurDr
	s $P(^TMP("PDATEMPORD",Adm,subno),"^",17)=MastInstrDr
	s $P(^TMP("PDATEMPORD",Adm,subno),"^",19)=masterno
 q 0
}

ClassMethod MultiSetRel(Adm, nostr) As %String
{
   s num=$Length(nostr,"|")
   for i=1:1:num
   {
	   s no1=$P(nostr,"|",i)
	   s no=$P(no1,"^")
	   s mastno=$P(no1,"^",2)
	   s ret=..SetRelationOrd(Adm,no,mastno)
   }
   q 0
}

ClassMethod InsertOrderItem(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, Doc As %String) As %String
{
	//w ##class(web.DHCDOCPDAENTRY).InsertOrderItem("8008","","5293","52","537")
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	s OrdItemStr=..gettempordstr(Adm)
	//s ^TMPQSE=MEDDATA_"^"_LABDATA
	ZN MEDDATA
	Set Ret=$$InsertMultiple^DHCDocOrderCommon(Adm,OrdItemStr,User,Loc,Doc,LABDATA)
	ZN CurrentNS
	QUIT Ret
}

ClassMethod GetOrdStat(Oew, OrdSub) As %String
{
   //取医嘱装态
    n (Oew,OrdSub)
	s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	s OrdStatCode=$P(^OEC("OSTAT",OrdStatDR),"^",1) 
	q OrdStatCode
}

ClassMethod GetCurrOrdItemExecute(ByRef qHandle As %Binary, OrdStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    Set qHandle=$lb(0,repid,0)
   // Quit $$$OK  //
    // w OrdStr
    //s OrdStr="1246||1*336||331*V^595||1*336||332*V^995||1*336||333*V^"
	s num=$L(OrdStr,"^") 
	s str=$P(OrdStr,"^",1)
	s RowId=$P(str,"*",2)
	s Oew=+RowId
	s schl=$P(RowId,"||",2)
    s schl=schl-1
	s OrdSub=schl  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub)) q:OrdSub=""  d
 	.s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
 	.s stat=..GetOrdStat(Oew,OrdSub)
 	.if stat="I" s upstat=..updateorditem(Oew_"||"_OrdSub,user)
 	.s RelatOeori=$P($G(^OEORD(Oew,"I",OrdSub,11)),"^",39)
 	.d getorditem(Oew,OrdSub,RelatOeori)
 	Quit $$$OK

getorditem(Oew,OrdSub,RelOeori)
	s ArcimId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
 	s ARCIMRowid=$P(ArcimId,"||",1)
	s ARCIMSub=$P(ArcimId,"||",2)
	s Meth=""
	s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",2) 
	e  s OrdStat=""  ;ord status
	s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
    s Priority=$P(^OECPR(PriorDR),"^",2)  
	s ArcimDes=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name
	i RelOeori'=""  s ArcimDes="●"_ArcimDes
	s pacunit=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,8)),"^",14)
	if pacunit'="" s pacunit=$P(^CT("UOM",pacunit),"^",2) 
    s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
    i (PHFreqDR'="") d
	.if $D(^PHCFR(PHFreqDR)) s PHFreq=$P(^PHCFR(PHFreqDR),"^",3) 
	.e  s PHFreq=""
	e  s PHFreq=""  ;table       PHC_Freq
	s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3  ) ;CT_UOM                      OEORI_Unit_DR
	i UOMDR'="" s UOM=$P(^CT("UOM",UOMDR),"^",2)  
	e  s UOM="" 
	s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
	if (DoseQty'="")&($P(DoseQty,"."))="" s DoseQty="0"_DoseQty
	//if DoseQty'="" s ARCIMDesc=$P(ARCIMDesc,"(")
	s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
	s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",4)
	s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	i MethDR'="" s Meth=$P(^PHCIN(MethDR),"^",2)  
	s RowId=Oew_"||"_OrdSub
	d OutwardRow11
reloeord(oeori,oew)
      s sub=""  f  s sub=$O(^OEORDi(0,"OEORI",oew,oeori,sub)) q:sub=""  d
      .d getorditem(oew,sub,oeori)    
	
	//Set qHandle=$lb(0,repid,0)

OutwardRow11
	set Data=$lb(ArcimDes,$G(DoseQty)_$G(UOM),$G(Meth),$G(PHFreq),$G(PhQtyOrd),$G(pacunit),OrdStat,RowId,RelOeori,Priority)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCurrOrdItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCurrOrdItemExecute ]
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

ClassMethod GetCurrOrdItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCurrOrdItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetCurrOrdItem(OrdStr As %String) As %Query(ROWSPEC = "ArcimDes,DoseQty,Meth,PHFreq,PhQtyOrd,pacunit,OrdStat,RowId,RelOeori,Priority")
{
}

ClassMethod updateorditem(rowid, user)
{
  //s user=%session.Get("LOGON.USERID")
  n (rowid,user)
 &sql(update oe_orditem set OEORI_ItemStat_DR=1 where oeori_rowid=:rowid)
 s PLIST(0)=rowid
 s PLIST(3)=+$H
 s PLIST(4)=$P($H,",",2)
 s PLIST(5)=1
 s PLIST(6)=user
 s PLIST(7)=""
 &sql(insert into OE_OrdStatus values PLIST())
 q SQLCODE
}

ClassMethod GetOrderOS(ArcOsRowid) As %String
{
    
	 //       OrderItem = OrderARCIMRowid + "^" + OrderType + "^" + OrderPriorRowid + "^" + OrderStartDate + "^" + OrderStartTime + "^" + OrderPackQty + "^" + OrderPrice;
     //       OrderItem = OrderItem + "^" + OrderRecDepRowid + "^" + BillTypeRowid + "^" + OrderDrugFormRowid + "^" + OrderDepProcNotes;
    //        OrderItem = OrderItem + "^" + OrderDoseQty + "^" + OrderDoseUOMRowid + "^" + OrderQtySum + "^" + OrderFreqRowid + "^" + OrderDurRowid + "^" + OrderInstrRowid;
    //        OrderItem = OrderItem + "^" + PHPrescType + "^" + OrderMasterSeqNo + "^" + OrderSeqNo + "^" + OrderSkinTest + "^" + OrderPhSpecInstr + "^" + OrderCoverMainIns + "^" + OrderActionRowid + "^" + OrderARCOSRowid;
}

ClassMethod IfExistSameOrder(Adm, ArcitemRowId) As %String
{
  n (Adm,ArcitemRowId)
  s ifExist=0
  q:(Adm="")||(ArcitemRowId="") ifExist
  s orderId=$O(^OEORD(0,"Adm",Adm,""))
  q:orderId="" ifExist
  i $O(^OEORDi(0,"ARCIM",orderId,ArcitemRowId,+$H,""))'="" s ifExist=1
  q ifExist
}

}
