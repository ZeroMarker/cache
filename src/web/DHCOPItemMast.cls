Import SQLUser

Class web.DHCOPItemMast Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// do ##class(%ResultSet).RunQuery("web.DHCOPItemMast","AIMRecLoc",2583,"3739||1",3)
Query AIMRecLoc(PAADMRowID As %String, ARCIMRID As %String, LocRowID As %String, LangId As %String = "") As websys.Query(ROWSPEC = "RecLocDesc:%String,RecLocRID:%String,DefRecFlag:%String")
{
}

ClassMethod AIMRecLocExecute(ByRef qHandle As %Binary, PAADMRowID As %String, ARCIMRID As %String, LocRowID As %String, LangId As %String = "") As %Status
{
	new repid, ind
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("AIMRecLoc")=$lb(PAADMRowID, ARCIMRID, LocRowID, LangId)
	
	if (LangId="")&&($d(%session)) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	//根据登陆科室取接收科室，调用医生站程序
	if (LocRowID'="") {
		set FindRecLocByLogonLoc=##class(web.DHCDocConfig).GetDHCCTLOCFieldValue(LocRowID, 1)
	    if (FindRecLocByLogonLoc=1) {
			set myRecLocStr=##class(web.DHCDocOrderCommon).GetLocRecLoc(LocRowID, ARCIMRID)
	    }else {
	    	set myRecLocStr=##class(web.DHCDocOrderCommon).GetRecloc(PAADMRowID, ARCIMRID)
	    }
	}else {
		set myRecLocStr=##class(web.DHCDocOrderCommon).GetRecloc(PAADMRowID, ARCIMRID)
	}
	
	do BuildDataCommOrder(myRecLocStr)
	
	quit $$$OK
	
BuildDataCommOrder(RecLocStr)
	set nCount=$l(RecLocStr,$c(2))
	for myindx=1:1:nCount {
		do ResetVariablesRecLoc
		set tmprecloc=$p(RecLocStr,$c(2),myindx)
		continue:(tmprecloc="")
		set bDefRecFlag=""
		set bRecLocRID=$p(tmprecloc,$c(1),1)
		set bRecLocDesc=$p(tmprecloc,$c(1),2)
		set bRecLocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", bRecLocDesc, LangId)
		set bDefRecFlag=$p(tmprecloc,$c(1),3)
		/*
		if (myRecOrdLoc=bRecLocRID) {
			set bDefRecFlag=1
		}
		*/
		do OutputRowRecLoc
	}
	quit
OutputRowRecLoc
	set Data=$lb(bRecLocDesc,bRecLocRID,bDefRecFlag)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
ResetVariablesRecLoc
	set (bRecLocDesc, bRecLocRID)=""
	set bDefRecFlag=0
	quit
}

/// Read ARC_ItemMast by Code for List;
/// do ##class(%ResultSet).RunQuery("web.DHCOPItemMast","ARCIMastList","ycx","","5711","5^122^49^2^1")
Query ARCIMastList(ItemMCode As %String, ARCCATCode As %String, EpisodeID As %String = "", SessionStr As %String) As websys.Query(ROWSPEC = "ARCIMastDesc:%String,ARCIMastRowID:%String,ARCSubCat:%String,SubCatOrderType:%String,UOMID:%String,UOMDesc:%String,ItemPrice:%Float,phFreqCode:%String,ARCType:%String")
{
}

ClassMethod ARCIMastListExecute(ByRef qHandle As %Binary, ItemMCode As %String, ARCCATCode As %String, EpisodeID As %String = "", SessionStr As %String = "") As %Status
{
	new repid, index
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set index=1
	set ^TMP("ARCIMastList")=$lb(ItemMCode, ARCCATCode, EpisodeID, SessionStr)
	
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CTLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)
	set LangId=$p(SessionStr,"^",5)
	
	kill RecordList, ItemList
	set RowCountIndex=0
	set ItemMCode=##class(BILL.Util.String).Trim(ItemMCode)
	set len1=$l(ItemMCode)
  	set control=$e(ItemMCode,len1)
  	if (control="#") set ItemMCode=$e(ItemMCode,1,len1-1), len2=$l(ItemMCode)
	//精确或者模糊查询
	set findMode=0
	/*
	if ($e(ItemMCode,1,1)="%") {
		set findMode=1
		set ItemMCode=$e(ItemMCode,2,$l(ItemMCode))
	}
	*/
	if ($e(ItemMCode,$l(ItemMCode))=".")||($e(ItemMCode,$l(ItemMCode))="。"){
		set findMode=1
		set ItemMCode=$e(ItemMCode,1,len1-1)
	}
	set ItemMCode2=""
	//空格分割 多项匹配
	if (ItemMCode[" ") set ItemMCode2=ItemMCode,ItemMCode=$p(ItemMCode," ",1)
	if (ItemMCode="") quit $$$OK
	
	set retval=$$open(ARCCATCode, ItemMCode, GroupId)
	for  set retval=$$fetch(ARCCATCode, ItemMCode, GroupId) quit:(retval=100)  do
	.do RecordSortTmpData
	do close()
	do OutputRecordSortData
	quit $$$OK
OutputRecordSortData
	//代码表数据使用次数排序
	set RecordCount=""
	while($o(RecordList(RecordCount),-1)'="") {
		set RecordCount=$o(RecordList(RecordCount),-1)
		set Num=""
		while($o(RecordList(RecordCount,Num))'="") {
			set Num=$o(RecordList(RecordCount,Num))
			set id=""
			while($o(RecordList(RecordCount,Num,id))'="") {
				set id=$o(RecordList(RecordCount,Num,id))
				set type=$g(RecordList(RecordCount,Num,id))
				if (type="ARCIM") set err=$$selectarcim(id) continue:err
				if (type="ARCOS") set err=$$selectarcos(id) continue:err
				do OutputIMastList
			}
		}
	}
	quit 0
RecordSortTmpData
	set OutRecordId=ROW1
	quit:$d(ItemList(OutRecordId))
    set TableName=$s((type="ARCIM"):"User.ARCItmMast",1:"User.ARCOrdSets")
	set RecordCount=##class(DHCDoc.Log.DHCDocCTUseCount).GetCount(TableName, OutRecordId, UserId, "U")
	set RecordList(RecordCount,$i(RowCountIndex),OutRecordId)=type
	set ItemList(OutRecordId)=""
	quit
open(CATEG, TEXT, user)
	k ^TMP($zn,$j)
	s TEXT=$g(TEXT),CATEG=$g(CATEG)
	s TEXT1=$zcvt(TEXT,"U")
	s TEXT=$zcvt(TEXT,"U")
	
	s DESC=0, ROW=0
	i (findMode=0) s TEXT0=TEXT
	e  s TEXT0=0 
	i TEXT,TEXT=+TEXT s TEXT0=TEXT_$c(1)
	s:(TEXT0="") TEXT0=0
	;build list of categories for user
	k UserCat, UserSubCat
	s ord=0 
	f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:(ord="")  d
	.s s=^(ord)
	.s UserCat(+s)=$p(s,"^",3,4)
	.i ($p(s,"^",5)'="") d
	..s UserSubCat(+s,$p(s,"^",5))=$p(s,"^",3,4)
	;decide which index to use
	s SubScr=$$subscr(CATEG)
	q 0
fetch(CATEG, TEXT, user)
	s TEXT=$g(TEXT), CATEG=$g(CATEG)
	s TEXT1=$zcvt(TEXT,"U")
	s TEXT=$zcvt(TEXT,"U")
	s SubScr=$g(SubScr),DESC=$g(DESC),ROW=$g(ROW),TEXT0=$g(TEXT0)
	k PLIST
	i (CATEG="") g it3
	i (CATEG'="") g it31
it1
	s TEXT0=$o(^ARC("ALIAS",0,SubScr,TEXT0)), DESC=""
it2 q:(TEXT0="") 100
	i findMode=0,$l(TEXT),$e($zcvt(TEXT0,"U"),1,$l(TEXT))'[TEXT g it1	 
	i ($zcvt(TEXT0,"U")'[TEXT) g it1
	s DESC=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC)),ROW=""

	s boolean=1
	i (ItemMCode2'="") d
	.f tmpindex=1:1:$l(ItemMCode2," ") d
	..s tmpItem2=$zcvt($p(ItemMCode2," ",tmpindex),"U")
	..q:(tmpItem2="")||(TEXT0="")||(DESC="")
	..q:($zcvt(TEXT0,"U")[(tmpItem2))||($zcvt(DESC,"U")[(tmpItem2))
	..s boolean=0
	g:(boolean=0) it1

	g:(DESC="") it1
it3 q:$g(TEXT0)="" 100
	g:$g(DESC)="" it1
	s ROW=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW))
	g:(ROW="") it2
	s ind=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW,""))
	g:(ind="") it3
	s str=$g(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW,ind))
	s ROW1=$p(str,"^"), type=$p(str,"^",2), genflag=$p(str,"^",3)
	i (type="ARCOS") s subCATEG=$p($g(^ARCOS(+ROW1)),"^",9)
	e  s subCATEG=$p($g(^ARCIM(+ROW1,1,1)),"^",10)
	i '$$valord(user,subCATEG,type,ROW1) g it3
	i type="ARCIM",$$valrow(ROW1) g it3
	i type="ARCOS",$$valarcos(ROW1) g it3
	i $d(^TMP($zn,$j,type_"^"_ROW1)) g it3
	s ^TMP($zn,$j,type_"^"_ROW1)=""
	s flag=$s((TEXT0=DESC):"",(ROW=ROW1):"",($g(^ARC("ALIAS",ROW))'=""):$p($g(^ARC("ALIAS",ROW)),"^",6)_"-",type["ARCIM":$p($g(^ARCIM(+ROW1,1,8)),"^",21)_"-",1:"")

	i (type="ARCIM") d
	.s generdesc=$p($g(^ARCIM(+ROW,1,8)),"^",21)
	.i $zcvt(generdesc,"U")=TEXT0 s flag=generdesc_"-"
	i type="ARCIM",genflag d
	.s flag=$p($g(^ARCIM(+ROW1,1,"GEN",genflag)),"^",2)_"-"
	//+2017-07-19 ZhYW
	s limitFlag=$$GetARCIMLimitFlag(type, ROW1)
	q:(limitFlag'=0) 100

	//完全匹配模式下，强制验证通用名
	i (control="#") {
		s getcontrol=$p(flag,"-",1) 
		s len3=$l(getcontrol)
		s getcontrol=$$ALPHAUP^SSUTIL4(getcontrol)
		//g:(len3'=len2) it3
		g:getcontrol'=$$ALPHAUP^SSUTIL4(TEXT) it3
	}

	i (type["ARCIM") s err=$$selectarcim(ROW1) g:err it3 s desc=flag_desc q "ARCIM"
	i (type["ARCOS") s err=$$selectarcos(ROW1) g:err it3 s desc=flag_desc q "ARCOS"
	q 0

it11
	s TEXT0=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0)),DESC=""
it21 q:(TEXT0="") 100
	;i TEXT=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT g it11 ;q 100
	i findMode=0,$l(TEXT),$e($zcvt(TEXT0,"U"),1,$l(TEXT))'[TEXT q 100
	s DESC=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC)), ROW=""

	s boolean=1
	i (ItemMCode2'="") d
	.f tmpindex=1:1:$l(ItemMCode2," ") d
	..s tmpItem2=$zcvt($p(ItemMCode2," ",tmpindex),"U")
	..q:(tmpItem2="")||(TEXT0="")||(DESC="")
	..q:($zcvt(TEXT0,"U")[(tmpItem2))||($zcvt(DESC,"U")[(tmpItem2))
	..s boolean=0
	g:(boolean=0) it11

	g:(DESC="") it11
it31 q:$g(TEXT0)="" 100
	g:$g(DESC)="" it11
	s ROW=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW))
	g:(ROW="") it21
	s ind=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW,""))
	g:(ind="") it21
	s str=$g(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW,ind))
	s ROW1=$p(str,"^",1), type=$p(str,"^",2)
	i (type="ARCIM"),$$valrow(ROW1) g it31
	i (type="ARCOS"),$$valarcos(ROW1) g it31
	i $e($zcvt(TEXT0,"U"),1,$l(TEXT1))'[TEXT1 g it31
	s flag=$s(TEXT0=DESC:"",1:$p($g(^ARC("ALIAS",ROW)),"^",6)_"-")
	i type="ARCIM",flag="" d
	.s generdesc=$p($g(^ARCIM(+ROW,1,8)),"^",21)
	.i $zcvt(generdesc,"U")=TEXT0 s flag=generdesc_"-"
	//+2017-07-19 ZhYW
	s limitFlag=$$GetARCIMLimitFlag(type, ROW1)
	q:(limitFlag'=0) 100
	//
	s err=0
	i (type["ARCIM") s err=$$selectarcim(ROW1)
	i (type["ARCOS") s err=$$selectarcos(ROW1)
	g:(err) it31
	s $p(PLIST(1),$c(2),2)=flag_$p(PLIST(1),$c(2),2) 
	i $l(type),ROW1,$d(^TMP($zn,$j,type,ROW1_"^"_desc)) g it31
	i $l(type),ROW1 s ^TMP($zn,$j,type,ROW1_"^"_desc)=""
	i (type="ARCIM") q "ARCIM"
	i (type="ARCOS") q "ARCOS"
	q 0
GetARCIMLimitFlag(type, row)
	n (type, row)
	s limitFlag=0
	q:((type'["ARCIM")||(row="")) limitFlag
	s arcimEffDateTo=$p(^ARCIM(+row,$p(row,"||",2),7),"^",1)       //截止日期
	s arcimOrderOnItsOwn=$p(^ARCIM(+row,$p(row,"||",2),7),"^",13)  //独立医嘱标志,"Y"是, "N":否
	i (((+arcimEffDateTo'=0)&&(+arcimEffDateTo<=+$h))||(arcimOrderOnItsOwn'="Y")) d
	.s limitFlag=1
	q limitFlag
close() 
	k UserCat,TEXT,TEXT0,UserSubCat
	k ^TMP($zn,$j)
	q 0
selectarcim(RowID)	k PLIST
	quit:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast", RowID, HospId)="N") 100
	
	&SQL(
		SELECT ARCIM_RowId, ARCIM_Desc, ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef, ARCIM_PHCDF_DR->PHCDF_PHCF_DR->PHCF_Desc, ARCIM_PHCDF_DR,
			ARCIM_RiceType_DR, ARCIM_RiceType_DR->RIC_Desc, ARCIM_ConsultDept, ARCIM_ConsultDept->CTLOC_Desc,
			ARCIM_ItemCat_DR, ARCIM_ItemCat_DR->ARCIC_OrdCat_DR, ARCIM_MealType_DR, ARCIM_MealType_DR->MEALT_Desc,
			ARCIM_PriceCostOnOrdering, ARCIM_InsSubCat_DR, ARCIM_DefPriority_DR, ARCIM_DefPriority_DR->OECPR_Desc, ARCIM_Code,
			ARCIM_PHCDF_DR->PHCDF_PHCFR_DR->PHCFR_Code, ARCIM_ItemCat_DR->ARCIC_OrderType, ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,
			ARCIM_OEMessage, ARCIM_RangeFrom, ARCIM_RangeTo, ARCIM_BillingUOM_DR, ARCIM_BillingUOM_DR->CTUOM_Desc,
			ARCIM_PHCDF_DR->PHCDF_PHCDU_DR, ARCIM_PHCDF_DR->PHCDF_GenRtForm_DR, ARCIM_ItemCat_DR->ARCIC_Desc
		INTO :rowid, :desc, :code, :code1, :code2,
             :rice, :ricedes, :cons, :consdes,
			 :subcat, :categ, :mealt, :mealtdes,
	         :cost, :inssubcat, :prior, :priordesc, :arcimcode,
	         :phfreqcode, :subcatordtype, :ordcatid,
	         :oemessage, :rangefrom, :rangeto, :phuomdr, :phuomdesc,
	         :phdurrowid, :generic, :subcatdesc
		FROM ARC_ItmMast
		WHERE %ID = :RowID
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn
	//+2022-04-15 ZhYW 药品单位应取门诊发药单位
	if ((rowid'="")&&(subcatordtype="R")) {
		set phuomdr=##class(web.DHCDocOrderCommon).GetPhDispUom(rowid, "O")   //药品取门诊发药单位
		set phuomdesc=$s((+phuomdr'=0):$p(^CT("UOM",phuomdr),"^",2),1:"")
	}
	do adjust1
	quit 0

adjust1
	s SttDate=+$h
	s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice=""
	s retPrice=..GetOrderPrice(PatType, InsType, rowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice, HospId, EpisodeID)
	s ItemPrice=$fn($p(retPrice,"^",1),"",6)		;4--->6
	s generic=""
	s desc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", desc, LangId)
	s subcatdesc=##class(User.ARCItemCat).GetTranByDesc("ARCICDesc", subcatdesc, LangId)
	s phuomdesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", phuomdesc, LangId)
	s Data=$lb(desc,rowid,subcatdesc,subcatordtype,phuomdr,phuomdesc,ItemPrice,phfreqcode,type,TEXT0,ordcatid,"",oemessage,rangefrom,rangeto,phdurrowid,generic,"","","")
	q
selectarcos(RowID)	k PLIST
	q:(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_OrdSets", RowID, HospId)="N") 100
	
	&SQL(
		SELECT ARCOS_RowId, ARCOS_Desc, ARCOS_LabTrakTestSet, ARCOS_DefPriority_DR, ARCOS_DurationDR, ARCOS_FrequencyDR, ARCOS_OrdCat_DR, ARCOS_OrdSubCat_DR->ARCIC_Desc
		INTO :rowid,:desc,:code,:prior,:durrowid,:freqcode,:ordcatid,:subcatdesc
		FROM ARC_OrdSets
		WHERE %ID = :RowID
	)
	i 'SQLCODE d adjust2
	q SQLCODE
adjust2
	s retval=$$getOSItemIDs(rowid)
	s OSItemIDs=$p(retval,$c(4),1)
	s OSPrice=$fn($p(retval,$c(4),2),"",6)		//4--->6
	s desc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", desc, LangId)
	s Data=$lb(desc,rowid,subcatdesc,"","","",OSPrice,"",type,TEXT0,ordcatid,"","","","","","",OSItemIDs,"","")
	q
valord(user, subCATEG, type, ROW1) ;validate usergroup and CATEGory
	 ;1-valid,0-invalid
	 n (UserCat,user,subCATEG,type,ROW1,UserSubCat)
	 s CATEG=$p($g(^ARC("IC",+subCATEG)),"^",8)
	 q:'user 1
	 i '$d(UserCat(+CATEG)) q 0
	 q:$d(UserSubCat(+CATEG))&&'$d(UserSubCat(+CATEG,subCATEG)) 0
	 s s=UserCat(+CATEG),vis=$p(s,"^"),os=$p(s,"^",2)
	 i type="ARCOS",os'="Y" q 0
	 i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y",vis'="Y" q 0
	 q 1
	 ;
	 s found=0, ord=0
	 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:(ord="")  q:found  s s=^(ord) d
	 .i '(s-CATEG) s found=1
	 q found
ALPHAUP(val, remove)
	s %trans(1)="abcdefghijklmnopqrstuvwxyz !,""#$%&'()*+-./:;<=>@[\]^_`{|},~", %trans(2)="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	q:'$d(remove) $tr(val,%trans(1),%trans(2)) q $tr(val,$tr(%trans(1),remove),%trans(2))
UP(val, remove) 
	s %trans(1)="abcdefghijklmnopqrstuvwxyz", %trans(2)="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	q:'$d(remove) $tr(val,%trans(1),%trans(2)) q $tr(val,$tr(%trans(1),remove),%trans(2))
valrow(row) ;validate if arcim is active 0-active,1-not active
	 n (row)
	 s datefrom=$p($g(^ARCIM(+row,1,1)),"^",13)
	 s dateto=$p($g(^ARCIM(+row,1,7)),"^",1)
	 s OrderOnItsOwn=$p($g(^ARCIM(+row,1,7)),"^",13)
	 i datefrom>$h q 1
	 i dateto,dateto<$h q 1
	 i OrderOnItsOwn'="Y" q 1
	 q 0
valarcos(row) ;validate if arcos is active 0-active,1-not active
	n (row)
	s datefrom=$p($g(^ARCOS(+row)),"^",15)
	s dateto=$p($g(^ARCOS(+row)),"^",16)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	q 0
checkos(arcos, user) ;check if user is allowed to order os
	 ;0-yes,61-no
	 n (arcos, user)
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
	n (subCATEG, UserCat, UserSubCat)
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
	s cat=""
	f  s cat=$o(UserCat(cat)) q:(cat="")  s s=UserCat(cat) d
	.i $p(s,"^")="Y" s vis="Y"
	.i $p(s,"^",2)="Y" s os="Y"
	i vis="Y",os="Y" s subscr="Desc"
	i vis'="Y",os="Y" s subscr="DescVIOS"
	i vis="Y",os'="Y" s subscr="DescI"
	i vis'="Y",os'="Y" s subscr="DescVI"
	q subscr
getOSItemIDs(ARCOSRowid)
	d ..OpenGetAllOrderSetItem(ARCOSRowid)
	s n=0,ARCOSPrice=0
	s OSItemIDs=""
	s SttDate=+$h
	s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice=""
	s count=0
	f  s count=$o(^CacheTemp("ARCOI",$j,count)) q:(count="")  d 
	.s item=0 
	.f  s item=$o(^CacheTemp("ARCOI",$j,count,item)) q:(item="")  s s=^(item) d
	..s ARCIMRowid=$p(s,"^",1)
	..s ARCOSItemQty=$p(s,"^",2)
	..s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	..s retPrice=..GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice, HospId, EpisodeID)
	..s Price=$P(retPrice,"^",1)
	..s ARCOSPrice=ARCOSPrice+$fn(Price*ARCOSItemQty,"",6)		;4--->6
 	..s n=n+1
 	..i (n=1) s OSItemIDs=ARCIMRowid_$c(14)_ARCIMDesc
 	..e  s OSItemIDs=OSItemIDs_$c(12)_ARCIMRowid_$c(14)_ARCIMDesc
 	i (OSItemIDs'="") s OSItemIDs=OSItemIDs_$c(4)_ARCOSPrice
 	q OSItemIDs
OutputIMastList
	set ^CacheTemp(repid,index)=Data
	set index=index+1
	quit
}

ClassMethod CloseGetAllOrderSetItem(ARCOSRowid As %String)
{
	kill ^CacheTemp("ARCOI",$j)
}

ClassMethod GetAllOrderSetItem(ARCOSRowid As %String)
{
	n (ARCOSRowid)
	q:(ARCOSRowid="") 0
	s ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid) 
	q:'ARCOSDateRowid  
	d ..GetOrderSetItem(ARCOSRowid,ARCOSDateRowid)
	;下面是调出医嘱套里的医嘱套?属于嵌套调用
	s it=0 
	f  s it=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"OS",it)) q:it=""  s s=^(it) d
	.d ..GetAllOrderSetItem(+s)
	
	q 0
}

/// w ##class(web.DHCOPItemMast).GetConFac("149||1", "149")
ClassMethod GetConFac(ARCIMRowid As %String, INCIRowid As %String) As %String
{
	n (ARCIMRowid, INCIRowid)
	//s convqty=$$ConvFac^ST02(billuom, baseuom)
	s ConFac=""
	s Billuom=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14)  ;ARCIM_BillingUOM_DR
	s Baseuom=$p($g(^INCI(INCIRowid,1)),"^",10)                           ;INCI_CTUOM_DR  库存基本单位
	s ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(ARCIMRowid, 0)
	i (ordCateType="R") {
		s Billuom=##class(web.DHCDocOrderCommon).GetPhDispUom(ARCIMRowid, "O")
	}
	q:(ordCateType="R") ##class(PHA.FACE.OUT.Com).UOMFac(Billuom, Baseuom)
	
	s ConFacID=$o(^CT("CTCF",0,"UOM",Billuom,Baseuom,""))
	q:(ConFacID="") 1
	
	s ConFac=+$p(^CT("CTCF",ConFacID),"^",3)
	q:(+ConFac=0) 1
	
	q ConFac
}

/// ARCIMsub传入的是ARC_ItmMast表的RowID?
/// 在库存表INC_Itm表中的到RowID?
ClassMethod GetINCI(ARCIMsub As %String) As %String
{
	n (ARCIMsub)
	s ARCIMsub=$p(ARCIMsub,$c(1),1)
	s INCIrow=$o(^INCI(0,"ARCIM_DR",ARCIMsub,""))
	q INCIrow
}

/// 获取医嘱价格
/// w ##class(web.DHCOPItemMast).GetOrderPrice("","","205||1",+$h,"","","","")
ClassMethod GetOrderPrice(PatType As %String, InsType As %String, ARCIMRowid As %String, SttDate As %String, PriorRowid As %String, InstrRowid As %String, LinkTo As %String, OEPrice As %String, HospID = "", adm = "") As %String
{
	s ARCIMSub=$p(ARCIMRowid,"||",1)
	i (SttDate="") s SttDate=+$h
	s RCDRowID=$p($g(^PAADM(adm,"DHC")),"^",25)
	s oeitm=""
	s oeore=""
	s regLoc=""
	s itmPriceExpStr=RCDRowID_"^"_oeitm_"^"_oeore_"^"_adm_"^"_regLoc_"^"_ARCIMRowid
	s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice, HospID, itmPriceExpStr)
	s Price=$P(retPrice,"^",1)
	s DiscPrice=$P(retPrice,"^",2)
	s InsPrice=$P(retPrice,"^",3)
	s PatPrice=$P(retPrice,"^",4)
	s INCIRowid=..GetINCI(ARCIMSub)
	s ConFac=1
	if (INCIRowid'="") {
		s ConFac=..GetConFac(ARCIMRowid, INCIRowid)
		s Price=$fn(Price*ConFac,"",6)		    ;4--->6
		s DiscPrice=$fn(DiscPrice*ConFac,"",6)	;4--->6
		s InsPrice=$fn(InsPrice*ConFac,"",6)	;4--->6
		s PatPrice=$fn(PatPrice*ConFac,"",6)	;4--->6
	}
	q Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice_"^"_ConFac
}

ClassMethod GetOrderPriceBroker(PatType As %String, InsType As %String, OrderType As %String, ItemRowid As %String, SttDate As %String, PriorRowid As %String, InstrRowid As %String, LinkTo As %String, OEPrice As %String) As %String
{
 	if (OrderType="ARCIM") {
	 	set retPrice=..GetOrderPrice(PatType, InsType, ItemRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	}else {
		set retPrice=..GetOrderSetPrice(PatType, InsType, ItemRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	}
	quit retPrice
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
	s item=0 
	f  s item=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item)) q:item=""  s s=^(item) d
	.s ARCIMRowid=$p(s,"^",1)
	.q:..ValARCItem(ARCIMRowid)
	.s ARCOSItemQty=$p(s,"^",2)
	.i (ARCOSItemQty="") s ARCOSItemQty=1
	.s count=$o(^TMP("ARCOI",$j,""),-1)+1
	.s ^CacheTemp("ARCOI",$j,count,item)=ARCIMRowid_"^"_ARCOSItemQty
	q 0
}

/// 获取医嘱套价格
ClassMethod GetOrderSetPrice(PatType As %String, InsType As %String, ARCOSRowid As %String, SttDate As %String, PriorRowid As %String, InstrRowid As %String, LinkTo As %String, OEPrice As %String, HospID, adm) As %String
{
	s ARCOSPrice=0
	s ARCOSDiscPrice=0
	s ARCOSInsPrice=0
	s ARCOSPatPrice=0
	do ..OpenGetAllOrderSetItem(ARCOSRowid)
	s count=0  
	f  s count=$o(^CacheTemp("ARCOI",$j,count)) q:count=""  d 
	.s item=0 
	.f  s item=$o(^CacheTemp("ARCOI",$j,count,item)) q:item=""  s s=^(item) d
 	..s ARCIMRowid=$p(s,"^",1)
 	..s ARCOSItemQty=$p(s,"^",2)
	..s ARCIMSub=$p(ARCIMRowid,"||",1)
	..s retPrice=..GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice, HospID, adm)
	..s Price=$P(retPrice,"^",1)
	..s DiscPrice=$P(retPrice,"^",2)
	..s InsPrice=$P(retPrice,"^",3)
	..s PatPrice=$P(retPrice,"^",4)
	..s ARCOSPrice=ARCOSPrice+$fn(Price*ARCOSItemQty,"",6)		;4--->6
	..s ARCOSDiscPrice=ARCOSDiscPrice+$fn(DiscPrice*ARCOSItemQty,"",6)	;4--->6
	..s ARCOSInsPrice=ARCOSInsPrice+$fn(InsPrice*ARCOSItemQty,"",6)		;4--->6
	..s ARCOSPatPrice=ARCOSPatPrice+$fn(PatPrice*ARCOSItemQty,"",6)		;4--->6

	q ARCOSPrice_"^"_ARCOSDiscPrice_"^"_ARCOSInsPrice_"^"_ARCOSPatPrice
}

ClassMethod IMInfoBroker(JSFunName As %String, bPAAdmRowID As %String, bItmMastRowid As %String, bPatType As %String, bInsType As %String, bOrderType As %String, bOEPrice As %String, bARCType As %String, HospID As %String)
{
	set ^TMPIMInfoBroker("IMInfoBroker")=$lb(JSFunName , bPAAdmRowID , bItmMastRowid , bPatType , bInsType , bOrderType , bOEPrice, bARCType , HospID)
	set rset=##class(%ResultSet).%New("web.DHCOPItemMast:OEItmInfo")
 	set columns=rset.GetColumnCount()
 	set rs=rset.Execute(bPAAdmRowID, bItmMastRowid, bPatType, bInsType, bOEPrice, bARCType, HospID)
	set myIdx=0
 	while (rset.Next()) {
	 	set myRowVal=""
	 	for mycol=1:1:columns {
		 	set mydata=rset.GetData(mycol)
 			set myRowVal=$g(myRowVal)_$g(mydata)_$c(2)	//行集
	 	}
	 	set myval=$g(myRowVal)		//行集累加?二维表? 
 		//注意在这个有回调数据错误?'这个字符需要替换
		set rtnval=JSFunName_"('"_$g(myval)_"');"
		&javascript<#(rtnval)#>
		set myIdx=myIdx+1
 	}
 	do rset.Close()

	quit 0
}

ClassMethod IMListBroker(JSFunName As %String, ListName As %String, bARCCATCode As %String, bItemMCode As %String, bGroupRID As %String, HospID As %String = "", adm As %String = "")
{
	set ^TMP("tt")=JSFunName_","_ListName_","_bARCCATCode_","_bItemMCode_","_bGroupRID_","_HospID_","_adm
	set rset = ##class(%ResultSet).%New("web.DHCOPItemMast:ARCIMastList")
 	set columns = rset.GetColumnCount()
 	// Execute the query
 	set rs = rset.Execute(bARCCATCode, bItemMCode, bGroupRID, HospID, adm)
	set myIdx=0
 	while (rset.Next()) {
	 	set myRowVal=""
	 	for mycol=1:1:columns {
		 	set mydata=rset.GetData(mycol)
 			if (mycol=1) do
 			.quit:($l(mydata,"-")=1)
 			.;set mydata=$p(mydata,"-",2)	;ARCIMastDesc

 			set myRowVal=$g(myRowVal)_$g(mydata)_$c(2)	//行集
	 	}
	 	set mydes=rset.Get("ARCIMastDesc")
	 	
	 	;显示价格
	 	set myPrice=$fn(rset.Get("ItemPrice"),"",6)		;4--->6
	 	set mySubCatDesc=rset.Get("ARCSubCat")
	 	
	 	set mydes=mydes_"   "_myPrice_"    "_mySubCatDesc
	 	set myval=myRowVal		//行集累加?二维表?
 		//注意在这个有回调数据错误?'这个字符需要替换
 		//myval.substring()关键字符冲突?
		set rtnval=JSFunName_"('"_ListName_"','"_$zcvt($g(mydes),"O","JS")_"','"_$zcvt($g(myval),"O","JS")_"','"_$zcvt($g(myIdx),"O","JS")_"');"
		&javascript<#(rtnval)#>
		set myIdx=myIdx+1
 	}
 	do rset.Close()
	quit 0
}

Query OEItmInfo(qPAAdmRowID As %String, qItmMastRowid As %String, qPatType As %String, qInsType As %String, qOEPrice As %Float, qARCType As %String, HospID As %String) As websys.Query(ROWSPEC = "oPrice:%Float,oDiscPrice:%Float,oInsPrice:%Float,oPatPrice:%Float")
{
}

ClassMethod OEItmInfoExecute(ByRef qHandle As %Binary, qPAAdmRowID As %String, qItmMastRowid As %String, qPatType As %String, qInsType As %String, qOEPrice As %Float, qARCType As %String, HospID As %String) As %Status
{
	new repid, index
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set index=1

	if ((qInsType="")&&(qPAAdmRowID'="")) {
		s qInsType=$p($g(^PAADM(qPAAdmRowID,1)),"^",7)
	}
	;;各种价格?
	;PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice
	d ResetVariablesInfo
	;取Adm保存的挂号优惠类别
	s RCDRowID=$p($g(^PAADM(qPAAdmRowID,"DHC")),"^",25)	
	i (qARCType="ARCIM") {
		s retPrice=..GetOrderPrice(qPatType, qInsType, qItmMastRowid, +$h, "", "", "", qOEPrice, HospID, qPAAdmRowID)
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
		s retPrice=..GetOrderSetPrice(qPatType, qInsType, qItmMastRowid, +$h, "", "", "", "", HospID, qPAAdmRowID) 
		s myPrice=$fn($p(retPrice,"^",1),"",6)		;4--->6
		s myDiscPrice=$fn($p(retPrice,"^",2),"",6)		;4--->6
		s myInsPrice=$fn($p(retPrice,"^",3),"",6)		;4--->6
		s myPatPrice=$fn($p(retPrice,"^",4),"",6)		;4--->6
	}
	
	d OutputRowInfo
	
	quit $$$OK
OutputRowInfo
	set Data=$lb(myPrice,myDiscPrice,myInsPrice,myPatPrice)
	set ^CacheTemp(repid,index)=Data
	set index=index+1
	quit
ResetVariablesInfo
	set (retPrice,myPrice,myDiscPrice,myInsPrice,myPatPrice)=""
	quit
}

ClassMethod OpenGetAllOrderSetItem(ARCOSRowid As %String)
{
	//不应该直接调用GetAllOrderSetItem?因为它没有删除^CacheTemp("ARCOI",$j)
	do ..CloseGetAllOrderSetItem(ARCOSRowid)
	do ..GetAllOrderSetItem(ARCOSRowid)
}

ClassMethod ReadPAInsTypeBroker(JSFunName As %String, ListName As %String)
{
	set rset=##class(%ResultSet).%New("web.DHCOPItemMast:ReadInsType")
	set columns=rset.GetColumnCount()
	set rs=rset.Execute()
	set myIdx=0
	while (rset.Next()) {
	 	set mydes=rset.Get("REA_Desc")
	 	set myRowVal=""
	 	set myRowVal=rset.Get("REA_RowId")
	 	set myval=myRowVal		//行集累加?二维表?
		set rtnval=JSFunName_"('"_ListName_"','"_$zcvt($g(mydes),"O","JS")_"','"_$zcvt($g(myval),"O","JS")_"','"_$zcvt($g(myIdx),"O","JS")_"');"
		&javascript<#(rtnval)#>
		set myIdx=myIdx+1
	}
	quit 0
}

/// w ##class(web.DHCOPItemMast).RecLocBroker("","","160","926||1")
ClassMethod RecLocBroker(JSFunName As %String, ListName As %String, bPAADMRowID As %String, bARCIMRID As %String, LocRowID As %String)
{
	set rset=##class(%ResultSet).%New("web.DHCOPItemMast:AIMRecLoc")
	set columns=rset.GetColumnCount()
	set rs=rset.Execute(bPAADMRowID,bARCIMRID,LocRowID)
	set myIdx=0
	while (rset.Next()) {
	 	set myRowVal=""
	 	set defflag=0
	 	if (rset.Get("DefRecFlag")="Y") {
		 	set defflag=1
		}
	 	set myRowVal=rset.Get("RecLocRID")_$c(2)_defflag
	 	set mydes=rset.Get("RecLocDesc")
	 	if $l(rset.Get("RecLocDesc"),"-")>1 {
		 	set mydes=$p($p(rset.Get("RecLocDesc"),"'"),"-",2)
		}
	 	set myval=myRowVal		//行集累加?二维表?
		set rtnval=JSFunName_"('"_ListName_"','"_$zcvt($g(mydes),"O","JS")_"','"_$zcvt($g(myval),"O","JS")_"','"_$zcvt($g(myIdx),"O","JS")_"');"
		&javascript<#(rtnval)#>
		set myIdx=myIdx+1
	}
	Do rset.Close()
	quit 0
}

/// w ##class(web.DHCOPItemMast).StopOrdItmBroker("1642||14","5^^^")
ClassMethod StopOrdItmBroker(OrdItmRID As %String, SOrdInfo As %String) As %String
{
	n (OrdItmRID, SOrdInfo)
	s OrdItmBilled=$p($g(^OEORD(+OrdItmRID,"I",$p(OrdItmRID,"||",2),3)),"^",5)
	q:(OrdItmBilled="P") "-100"
	s userRowId=$p(SOrdInfo,"^",1)	;停医嘱人ss_user
	
	s currDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	s currTime=$zt($p($h,",",2),1)
	//2016-01-29 Lid 统一调用医生站组接口实现停医嘱
	s singleOrdItmStr=OrdItmRID_"!"_currDate_"!"_currTime
	s ret=##class(appcom.OEOrdItem).StopMulti(singleOrdItmStr, userRowId, "", "N")
	s myrtn=ret
	
	q myrtn
}

/// validate if arcim is active 0-active,1-not active
ClassMethod ValARCItem(ARCIMRowid As %String) As %String
{
	n (ARCIMRowid)
	s datefrom=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",13)
	s dateto=$p($g(^ARCIM(+ARCIMRowid,1,7)),"^",1)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	q 0
}

Query QueryTest(mycode As %String) As %SQLQuery(ROWSPEC = "ARCIMastDesc:%String,ARCIMastRowID:%String,ARCSubCat:%String")
{
	SELECT ARCIM_Desc, ARCIM_RowId, ARCIM_Code
	FROM ARC_ItmMast
	WHERE ARCIM_Code %STARTSWITH :mycode
}

Query ReadInsType() As %SQLQuery(ROWSPEC = "REA_Desc:%String,REA_RowId:%String,REA_Code:%String")
{
	SELECT REA_Desc, REA_RowId, REA_Code
	FROM PAC_AdmReason
}

ClassMethod GetOrdUser(OrdItem, NewUserRowId)
{
    s myVer=##class(web.DHCOPConfig).GetVersion()
	q:(+myVer=9) NewUserRowId
    i (OrdItem="") s OldUserRowid=NewUserRowId
    e  s OldUserRowid=$p(^OEORD(+OrdItem,"I",$p(OrdItem,"||",2),7),"^",1)
    q OldUserRowid
}

}
