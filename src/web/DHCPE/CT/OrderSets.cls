/// web.DHCPE.CT.OrderSets
/// create by zhongricheng
/// 体检医嘱套
Class web.DHCPE.CT.OrderSets Extends %RegisteredObject
{

/// 获取体检医嘱套 医嘱子类ID 若无体检医嘱套 则获取医嘱套 的医嘱子类ID  返回医嘱子类详情^医嘱子类ID^医嘱大类ID
/// w ##class(web.DHCPE.CT.OrderSets).GetARCItemCatID()
ClassMethod GetARCItemCatID(ARCItemCatID As %String = "")
{
	if ARCItemCatID="" d
	.s ARCItemCatDesc="体检医嘱套"
	.s ARCItemCatID=$o(^ARC("IC",0,"Desc",ARCItemCatDesc,0))
	.i ARCItemCatID="" d
	..s ARCItemCatDesc="医嘱套"
	..s ARCItemCatID=$o(^ARC("IC",0,"Desc",ARCItemCatDesc,0))
	else  d
	.s ARCItemCatDesc=$p($g(^ARC("IC",ARCItemCatID)), "^", 2)
	q "{""ARCItemCatDesc"":"""_ARCItemCatDesc_""",""ARCItemCatID"":"""_ARCItemCatID_""",""Category"":"""_$p($g(^ARC("IC",ARCItemCatID)), "^", 8)_"""}"
	;q ARCItemCatDesc_"^"_ARCItemCatID_"^"_$p($g(^ARC("IC",ARCItemCatID)), "^", 8)
}

/// 医嘱套等级选择  
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.OrderSets","SearchVIPLevel")
Query SearchVIPLevel() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod SearchVIPLevelExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	
	s id=0
	f  s id=$o(^DHCPEVIPLevel("VIP",id)) q:id=""  d
	.q:"N"=$p($g(^DHCPEVIPLevel("VIP",id)),"^",4)  // 不使用的过滤
	.s desc=$p($g(^DHCPEVIPLevel("VIP",id)),"^",2)
 	.d VIPLevelOut
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
VIPLevelOut      
	set Data=$lb(id,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

/// 获取体检医嘱套
/// w ##class(web.DHCPE.CT.OrderSets).GetARCOSData(1836)
ClassMethod GetARCOSData(ARCOSRowid As %String = "")
{
	s Break="",BreakDesc="",Sex="",SexDesc="",Price="",Deit="",DeitDesc=""
	s VIPLevel="",VIPDesc="",LocId="",LocDesc="",PGBId="",PGDesc="",DateBeg="",DateEnd=""
	s Sort="",Frequency="",Disable="",DisableDesc=""
	i ARCOSRowid="" goto OSExError
	S FavRowId=$O(^DHCFavItems(0,"ItemRowid",ARCOSRowid,""))
	S FavHospDr=$p($g(^DHCFavItems(FavRowId)),"^",9)
	S FavUserHospDr=$p($g(^DHCFavItems(FavRowId)),"^",11)

	s OSEx=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowid,""))
	i OSEx="" goto OSExError
	s OSExData=$g(^DHCPEOSE(OSEx))
	s Break=$p(OSExData,"^",2)
	s Sex=$p(OSExData,"^",3)
	s Price=+$p(OSExData,"^",4)
	s Deit=$p(OSExData,"^",5)
	s VIPLevel=$p(OSExData,"^",6)
	s Loc=$p(OSExData,"^",7)
	s DateBeg=$p(OSExData,"^",8)
	s DateEnd=$p(OSExData,"^",9)
	s PGBId=$p(OSExData,"^",10)
	s Sort=$p(OSExData,"^",14)
	s Frequency=$p(OSExData,"^",15)
	s Disable=$p(OSExData,"^",16)		   
	
	// 拆分
	s:Break="Y" BreakDesc="可拆分"
	s:Break="N" BreakDesc="不可拆"
	
	// 性别
	s:Sex="" SexDesc="不限"
	s:Sex'="" SexDesc=$p($g(^CT("SEX",Sex)),"^",2)
	
	// 早餐
	s:Deit="Y" DeitDesc="有早"
	s:Deit="N" DeitDesc="无早"
	
	// VIP等级
	i VIPLevel'="" d
	.f i=1:1:$l(VIPLevel,",") d
	..q:$p(VIPLevel,",",i)=""
	..;s VIP=$p($g(^DHCPEVIPLevel("VIP",$p(VIPLevel,",",i))),"^",2)
	..s VIP=$lg($g(^CT.PE.VIPLevelD($p(VIPLevel,",",i))),3)
	..q:VIP=""
	..s:VIPDesc'="" VIPDesc=VIPDesc_";"_VIP
	..s:VIPDesc="" VIPDesc=VIP
	
	// 可用科室
	i Loc'="" d
	.f i=1:1:$l(Loc,",") d
	..q:$p(Loc,",",i)=""
	..s LocId=$p(Loc,",",i)
	..s LocName=$p($g(^CTLOC(LocId)),"^",2)
	..s:LocName["-" LocName=$p(LocName,"-",2)
	..q:LocName=""
	..s:LocDesc'="" LocDesc=LocDesc_";"_LocName
	..s:LocDesc="" LocDesc=LocName
	
	// 开始/截止日期
	s:DateBeg'="" DateBeg=##class(websys.Conversions).DateLogicalToHtml(DateBeg) 
	s:DateEnd'="" DateEnd=##class(websys.Conversions).DateLogicalToHtml(DateEnd) 
	
	// 可用团体
	i PGBId'="" d
	.s PGDesc=$p($g(^DHCPEPreGBI(PGBId)),"^",2)
	
	// 顺序
	//s:Sort="" Sort=Sort
	
	// 频次
	//s Frequency=""
	
	// 禁用 启用
	s DisableDesc="启用"
	s:Disable="Y" DisableDesc="禁用"
	
	s ret="{"
	s ret=ret_"""FavHospDr"":"""_FavHospDr_""""_","
	s ret=ret_"""FavUserHospDr"":"""_FavUserHospDr_""""_","
	s ret=ret_"""Break"":"""_Break_""""_","
	s ret=ret_"""BreakDesc"":"""_BreakDesc_""""_","
	s ret=ret_"""Sex"":"""_Sex_""""_","
	s ret=ret_"""SexDesc"":"""_SexDesc_""""_","
	s ret=ret_"""Price"":"""_$fn(Price,"",2)_""""_","
	s ret=ret_"""Deit"":"""_Deit_""""_","
	s ret=ret_"""DeitDesc"":"""_DeitDesc_""""_","
	s ret=ret_"""VIPLevel"":"""_VIPLevel_""""_","
	s ret=ret_"""VIPDesc"":"""_VIPDesc_""""_","
	s ret=ret_"""LocId"":"""_LocId_""""_","
	s ret=ret_"""LocDesc"":"""_LocDesc_""""_","
	s ret=ret_"""DateBeg"":"""_DateBeg_""""_","
	s ret=ret_"""DateEnd"":"""_DateEnd_""""_","
	s ret=ret_"""PGBId"":"""_PGBId_""""_","
	s ret=ret_"""PGDesc"":"""_PGDesc_""""_","
	s ret=ret_"""Sort"":"""_Sort_""""_","
	s ret=ret_"""Frequency"":"""_Frequency_""""_","
	s ret=ret_"""Disable"":"""_Disable_""""_","
	s ret=ret_"""DisableDesc"":"""_DisableDesc_""""
	s ret=ret_"}"
	q ret
	
OSExError
	s ret="{"
	s ret=ret_"""FavHospDr"":"""_FavHospDr_""""_","
	s ret=ret_"""FavUserHospDr"":"""_FavUserHospDr_""""_","
	s ret=ret_"""Break"":"""_Break_""""_","
	s ret=ret_"""BreakDesc"":"""_BreakDesc_""""_","
	s ret=ret_"""Sex"":"""_Sex_""""_","
	s ret=ret_"""SexDesc"":"""_SexDesc_""""_","
	s ret=ret_"""Price"":"""_$fn(Price,"",2)_""""_","
	s ret=ret_"""Deit"":"""_Deit_""""_","
	s ret=ret_"""DeitDesc"":"""_DeitDesc_""""_","
	s ret=ret_"""VIPLevel"":"""_VIPLevel_""""_","
	s ret=ret_"""VIPDesc"":"""_VIPDesc_""""_","
	s ret=ret_"""LocId"":"""_LocId_""""_","
	s ret=ret_"""LocDesc"":"""_LocDesc_""""_","
	s ret=ret_"""PGBId"":"""_PGBId_""""_","
	s ret=ret_"""DateBeg"":"""_DateBeg_""""_","
	s ret=ret_"""DateEnd"":"""_DateEnd_""""_","
	s ret=ret_"""PGDesc"":"""_PGDesc_""""_","
	s ret=ret_"""Sort"":"""_Sort_""""_","
	s ret=ret_"""Frequency"":"""_Frequency_""""_","
	s ret=ret_"""Disable"":"""_Disable_""""_","
	s ret=ret_"""DisableDesc"":"""_DisableDesc_""""
	s ret=ret_"}"
	q ret
}

/// 查询体检医嘱套
/// 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.OrderSets","SearchPEOrderSets","13811","83","2","","","","","152")
Query SearchPEOrderSets(UserID As %Library.String = "", subCatID As %Library.String = "", Conditiones As %Library.String = "", Code As %Library.String = "", Desc As %Library.String = "", Alias As %Library.String = "", HospID As %Library.String = "", LocId As %Library.String = "", HospIDByLocID As %Library.String = "") As websys.Query(ROWSPEC = "ARCOSRowid:%String,ARCOSCode:%String,ARCOSDesc:%String,ARCOSOrdCat:%String,ARCOSOrdSubCat:%String,ARCOSEffDateFrom:%String,ARCOSOrdCatDR:%String,ARCOSOrdSubCatDR:%String,FavRowid:%String,ARCOSAlias:%String,FavUserDesc:%String,FavDepDesc:%String,FavUserDr:%String,FavDepDr:%String,MedUnit:%String,MedUnitDesc:%String,OrdSetPrice:%String,OSExBreak:%String,BreakDesc:%String,OSExSex:%String,SexDesc:%String,OSExPrice:%String,OSExDeit:%String,DeitDesc:%String,OSExVIPLevel:%String,VIPDesc:%String,OSExLoc:%String,LocDesc:%String,OSExPGBId:%String,PGDesc:%String,_parentId:%String,FavHospDr:%String,FavUserHospDr:%String,AddUser:%String,Sort:%String,DateBeg:%String,DateEnd:%String,Frequency:%String,Disable:%String,DisableDesc:%String") [ SqlProc ]
{
}

ClassMethod SearchPEOrderSetsExecute(ByRef qHandle As %Binary, UserID As %Library.String = "", subCatID As %Library.String = "", Conditiones As %Library.String = "", Code As %Library.String = "", Desc As %Library.String = "", Alias As %Library.String = "", HospID As %Library.String = "", LocId As %Library.String = "", HospIDByLocID As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	K ^tempdhcpe("SearchPEOrderSets")
	s ^tempdhcpe("SearchPEOrderSets")=$lb(UserID,subCatID,Conditiones,Code,Desc,Alias,HospID,LocId,HospIDByLocID)
	
	i LocId="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	i UserID="" {
		s:$d(%session) UserID=%session.Get("LOGON.USERID")
		s:'$d(%session) UserID=1149
	}
	i subCatID="" {
		s subCatIDStr=##class(web.DHCPE.CT.OrderSets).GetARCItemCatID()
		s subCatIDObj={}.%FromJSON(subCatIDStr)
 		s subCatID=subCatIDObj.ARCItemCatID
	}
	i Conditiones="" s Conditiones=2
	
	if (subCatID=""||Conditiones="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	//s ^zrc=UserID_","_Conditiones_","_subCatID_","_Code_","_Desc_","_Alias
	
	/*
	set rs=##class(%ResultSet).%New("web.DHCPE.CT.OrderSets:QueryPGBI")
	set sc=rs.Execute("")
	If $$$ISERR(sc) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	while rs.%Next() {
		s tPGBI=rs.GetDataByName("id")
		//continue:$o(^DHCPEOSE(0,"GBaseInfo",tPGBI,0))=""
		d SetDefValue
		s ARCOSRowid="PGBId"_rs.GetDataByName("id")
		s ARCOSOrdSubCat=rs.GetDataByName("desc")
		d outOrdSetInfo
	}
	*/
	
	set rs=##class(%ResultSet).%New("web.DHCUserFavItems:FindUserOrderSet")
	set sc=rs.Execute(UserID, "", "", "", "", Conditiones, "", subCatID, Code, Desc, Alias,HospID,"","",HospIDByLocID,LocId)
	If $$$ISERR(sc) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	while rs.%Next() {
		
		d SetDefValue
		
		// ARCOSRowid,ARCOSCode,ARCOSDesc,ARCOSOrdCat,ARCOSOrdSubCat
		s ARCOSRowid=rs.GetDataByName("ARCOSRowid")
		s OSEx=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowid,""))
		continue:OSEx=""
		s OSExData=..GetARCOSData(ARCOSRowid)
		s OSExObj={}.%FromJSON(OSExData)
		continue:OSExObj.LocId'=LocId
		b //1
		s ARCOSCode=rs.GetDataByName("ARCOSCode")
		s ARCOSDesc=rs.GetDataByName("ARCOSDesc")
		s ARCOSOrdCat=rs.GetDataByName("ARCOSOrdCat")
		s ARCOSOrdSubCat=rs.GetDataByName("ARCOSOrdSubCat")
		
		// ARCOSEffDateFrom,ARCOSOrdCatDR,ARCOSOrdSubCatDR,FavRowid,ARCOSAlias
		s ARCOSEffDateFrom=rs.GetDataByName("ARCOSEffDateFrom")
		s ARCOSOrdCatDR=rs.GetDataByName("ARCOSOrdCatDR")
		s ARCOSOrdSubCatDR=rs.GetDataByName("ARCOSOrdSubCatDR")
		s FavRowid=rs.GetDataByName("FavRowid")
		s ARCOSAlias=rs.GetDataByName("ARCOSAlias")
		
		// FavUserDesc,FavDepDesc,FavUserDr,FavDepDr,MedUnit
		s FavUserDesc=rs.GetDataByName("FavUserDesc")
		s FavUserDr=rs.GetDataByName("FavUserDr")
		s FavDepDr=rs.GetDataByName("FavDepDr")
		s MedUnit=rs.GetDataByName("MedUnit")
		
		// MedUnitDesc,OrdSetPrice,Break,BreakDesc,Sex
		s MedUnitDesc=rs.GetDataByName("MedUnitDesc")
		s OrdSetPrice=rs.GetDataByName("OrdSetPrice")
		s AddUser=$p($g(^ARCOS(ARCOSRowid)),"^",29)
		i AddUser'="" s AddUser=$p($g(^SSU("SSUSR",AddUser)),"^",2)

		s Break=OSExObj.Break
		s BreakDesc=OSExObj.BreakDesc
		s Sex=OSExObj.Sex
		
		// SexDesc,Price,Deit,DeitDesc,VIPLevel
		s SexDesc=OSExObj.SexDesc
		s Price=OSExObj.Price_"元"
		s Deit=OSExObj.Deit
		s DeitDesc=OSExObj.DeitDesc
		s VIPLevel=OSExObj.VIPLevel
		
		// VIPDesc,Loc,LocDesc,PGBId,PGDesc
		s VIPDesc=OSExObj.VIPDesc
		s Loc=OSExObj.LocId
		s LocDesc=OSExObj.LocDesc
		s PGBI=OSExObj.PGBId
		s PGDesc=OSExObj.PGDesc
		
		s FavHospDr=OSExObj.FavHospDr
		s FavUserHospDr=OSExObj.FavUserHospDr
		s Sort=OSExObj.Sort
		s DateBeg=OSExObj.DateBeg
		s DateEnd=OSExObj.DateEnd
		
		s Frequency=OSExObj.Frequency
		s Disable=OSExObj.Disable
		s DisableDesc=OSExObj.DisableDesc
		
		s:PGBI'="" pId="PGBId"_PGBI
		s:PGBI="" pId="PGBIdUN"
		d outOrdSetInfo
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

SetDefValue
	s (ARCOSRowid,ARCOSCode,ARCOSDesc,ARCOSOrdCat,ARCOSOrdSubCat,ARCOSEffDateFrom,ARCOSOrdCatDR,ARCOSOrdSubCatDR,AddUser)=""
	s (FavRowid,ARCOSAlias,FavUserDesc,FavDepDesc,FavUserDr,FavDepDr,MedUnit,MedUnitDesc,OrdSetPrice,FavHospDr,FavUserHospDr)=""
	s (Break,BreakDesc,Sex,SexDesc,Price,Deit,DeitDesc,VIPLevel,VIPDesc,Loc,LocDesc,PGBI,PGDesc,Sort,DateBeg,DateEnd,Frequency,Disable,DisableDesc,pId)=""
	
	q
outOrdSetInfo
	set Data=$lb(ARCOSRowid,ARCOSCode,ARCOSDesc,ARCOSOrdCat,ARCOSOrdSubCat,ARCOSEffDateFrom,ARCOSOrdCatDR,ARCOSOrdSubCatDR,FavRowid,ARCOSAlias,FavUserDesc,FavDepDesc,FavUserDr,FavDepDr,MedUnit,MedUnitDesc,OrdSetPrice,Break,BreakDesc,Sex,SexDesc,Price,Deit,DeitDesc,VIPLevel,VIPDesc,Loc,LocDesc,PGBI,PGDesc,pId,FavHospDr,FavUserHospDr,AddUser,Sort,DateBeg,DateEnd,Frequency,Disable,DisableDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 查询可复制的医嘱套
/// 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.OrderSets","SearchPECanCopyOS")
Query SearchPECanCopyOS(ARCOSRowid As %String = "", Desc As %String = "", Type As %String = "", UserID As %String = "", LocID As %String = "", HospID As %String = "") As websys.Query(ROWSPEC = "ARCOSRowid:%String,ARCOSCode:%String,ARCOSDesc:%String,OSExSex:%String,SexDesc:%String,OSExVIPLevel:%String,VIPDesc:%String,OSExLoc:%String,LocDesc:%String,OSExPrice:%String,FavRowid:%String") [ SqlProc ]
{
}

ClassMethod SearchPECanCopyOSExecute(ByRef qHandle As %Binary, ARCOSRowid As %String = "", Desc As %String = "", Type As %String = "", UserID As %String = "", LocID As %String = "", HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	
	if (Type="NoShow") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i UserID="" {
		s:$d(%session) UserID=%session.Get("LOGON.USERID")
		s:'$d(%session) UserID=1149
	}
	
	s Desc=$ZCVT(Desc,"U")
	
	s OSId=0
	f  s OSId=$o(^DHCPEOSE(0,"OrdSets",OSId)) q:OSId=""  d
	.s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_OrdSets",OSId,HospID)
	.q:HOSPshowFlag="N" 
	.q:((ARCOSRowid'="")&&(ARCOSRowid=OSId))
	.s FavRowId=$O(^DHCFavItems(0,"ItemRowid",OSId,""))
	.q:FavRowId=""
	.s FavUserDr=$p($g(^DHCFavItems(FavRowId)),"^",2)
	.s FavDepDr=$p($g(^DHCFavItems(FavRowId)),"^",4)
	.s FavHospDr=$p($g(^DHCFavItems(FavRowId)),"^",9)
	.q:(FavDepDr="")&&(FavUserDr="")
	.s OSExId=$o(^DHCPEOSE(0,"OrdSets",OSId,""))
	.q:OSExId=""
	.s qFlag=0
	.s OSDesc=$p($g(^ARCOS(OSId)),"^",2)
	.s OSAliasRowid=$O(^ARC("ALIAS",0,"ARCOS",OSId,0))
 	.i OSAliasRowid'="" d
 	..s OSAlias=$P(^ARC("ALIAS",OSAliasRowid),"^",6)
 	..s:((""'=Desc)&&($ZCVT(OSAlias,"U")[Desc)) qFlag=1
 	.s:((""'=Desc)&&($ZCVT(OSDesc,"U")[Desc)) qFlag=1
	.q:((""'=Desc)&&(qFlag=0))
	.
	.s OSExData=..GetARCOSData(OSId)
	.s OSExObj={}.%FromJSON(OSExData)
	.s OSSex=OSExObj.Sex
	.s SexDesc=OSExObj.SexDesc
	.s VIPLevel=OSExObj.VIPLevel
	.s VIPDesc=OSExObj.VIPDesc
	.s Loc=OSExObj.LocId
	.q:LocID'=Loc
	.s LocDesc=OSExObj.LocDesc
	.s Price=OSExObj.Price_"元"
	.s FavHospDr=OSExObj.FavHospDr
	.s FavUserHospDr=OSExObj.FavUserHospDr
	.d outCopyOSInfo
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outCopyOSInfo
	set Data=$lb(OSId,OSCode,OSDesc,OSSex,SexDesc,VIPLevel,VIPDesc,Loc,LocDesc,Price,FavRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 查询体检医嘱套明细
/// 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.OrderSets","SearchPEOrderSetsDetail","480","1")
Query SearchPEOrderSetsDetail(ARCOSRowid As %String, QueryFlag As %String, Type As %String = "", LocID As %String = "", hospId As %String = "") As websys.Query(CONTAINID = "", ROWSPEC = "ARCIMDesc:%String,ARCOSItemQty:%String,ARCOSItemBillUOM:%String,ARCOSItemDoseQty:%String,ARCOSItemUOM:%String,ARCOSItemFrequence:%String,ARCOSItemDuration:%String,ARCOSItemInstruction:%String,ARCOSItemRowid:%String,ARCIMRowid:%String,ARCOSItemUOMDR:%String,ARCOSItemFrequenceDR:%String,ARCOSItemDurationDR:%String,ARCOSItemInstructionDR:%String,ARCOSItemCatDR:%String,ARCOSItemSubCatDR:%String,ARCOSItemOrderType:%String,ARCOSItmLinkDoctor:%String,Tremark:%String,ARCOSDHCDocOrderType:%String,ARCOSDHCDocOrderTypeDR:%String,SampleID:%String,SampleDesc:%String,ITMSerialNo:%String,NO:%String,OrderPriorRemarksDR:%String,OrderPriorRemarks:%String,DHCDocOrdRecLoc:%String,ItmPrice:%String") [ SqlProc ]
{
}

ClassMethod SearchPEOrderSetsDetailExecute(ByRef qHandle As %Binary, ARCOSRowid As %String, QueryFlag As %String, Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	
	if (ARCOSRowid="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	set rs=##class(%ResultSet).%New("web.DHCARCOrdSets:FindOSItem")
	set sc=rs.Execute(ARCOSRowid, QueryFlag)
	If $$$ISERR(sc) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	while rs.%Next() {
		
		d SetDefValue1
		
		// ARCIMDesc,ARCOSItemQty,ARCOSItemBillUOM,ARCOSItemDoseQty,ARCOSItemUOM
		s ARCIMDesc=rs.GetDataByName("ARCIMDesc")
		s ARCOSItemQty=rs.GetDataByName("ARCOSItemQty")
		s ARCOSItemBillUOM=rs.GetDataByName("ARCOSItemBillUOM")
		s ARCOSItemDoseQty=rs.GetDataByName("ARCOSItemDoseQty")
		s ARCOSItemUOM=rs.GetDataByName("ARCOSItemUOM")
		
		// ARCOSItemFrequence,ARCOSItemDuration,ARCOSItemInstruction,ARCOSItemRowid,ARCIMRowid
		s ARCOSItemFrequence=rs.GetDataByName("ARCOSItemFrequence")
		s ARCOSItemDuration=rs.GetDataByName("ARCOSItemDuration")
		s ARCOSItemInstruction=rs.GetDataByName("ARCOSItemInstruction")
		s ARCOSItemRowid=rs.GetDataByName("ARCOSItemRowid")
		s ARCIMRowid=rs.GetDataByName("ARCIMRowid")
		s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",ARCIMRowid,Type,LocID)
    	continue:DateShowFlag="Y"
    	s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ARCIMRowid,hospId)
		continue:(HOSPshowFlag="N")

		// ARCOSItemUOMDR,ARCOSItemFrequenceDR,ARCOSItemDurationDR,ARCOSItemInstructionDR,ARCOSItemCatDR
		s ARCOSItemUOMDR=rs.GetDataByName("ARCOSItemUOMDR")
		s ARCOSItemFrequenceDR=rs.GetDataByName("ARCOSItemFrequenceDR")
		s ARCOSItemDurationDR=rs.GetDataByName("ARCOSItemDurationDR")
		s ARCOSItemInstructionDR=rs.GetDataByName("ARCOSItemInstructionDR")
		s ARCOSItemCatDR=rs.GetDataByName("ARCOSItemCatDR")
		
		// ARCOSItemSubCatDR,ARCOSItemOrderType,ARCOSItmLinkDoctor,Tremark,ARCOSDHCDocOrderType
		s ARCOSItemSubCatDR=rs.GetDataByName("ARCOSItemSubCatDR")
		s ARCOSItemOrderType=rs.GetDataByName("ARCOSItemOrderType")
		s ARCOSItmLinkDoctor=rs.GetDataByName("ARCOSItmLinkDoctor")
		s Tremark=rs.GetDataByName("Tremark")
		s ARCOSDHCDocOrderType=rs.GetDataByName("ARCOSDHCDocOrderType")
		
		// ARCOSDHCDocOrderTypeDR,SampleID,SampleDesc,ITMSerialNo,NO
		s ARCOSDHCDocOrderTypeDR=rs.GetDataByName("ARCOSDHCDocOrderTypeDR")
		s SampleID=rs.GetDataByName("SampleID")
		//s SampleDesc=rs.GetDataByName("SampleDesc")
		s SampleDesc=##class(web.DHCPE.PreItemList).GetDefaultSpecName(ARCIMRowid,"1",hospId)
		s SampleDesc=$p(SampleDesc,"^",2)

		s ITMSerialNo=rs.GetDataByName("ITMSerialNo")
		s NO=rs.GetDataByName("NO")
		
		// OrderPriorRemarksDR,OrderPriorRemarks,DHCDocOrdRecLoc
		s OrderPriorRemarksDR=rs.GetDataByName("OrderPriorRemarksDR")
		s OrderPriorRemarks=rs.GetDataByName("OrderPriorRemarks")
		s DHCDocOrdRecLoc=rs.GetDataByName("DHCDocOrdRecLoc")
		
		// 价格
		s CurDate=+$h
		s ItmPrice=##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(ARCIMRowid,CurDate,"","","","","","","","",LocID)
		s priceJsonStr=##class(web.DHCPE.CT.OrderSets).GetOSItemPrice(ARCOSItemRowid, CurDate)
		i priceJsonStr'="" {
			s priceJson={}.%FromJSON(priceJsonStr)
			s ItmPrice=priceJson.price
		}
		
		d outOrdSetDetailInfo
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

SetDefValue1
	s (ARCIMDesc,ARCOSItemQty,ARCOSItemBillUOM,ARCOSItemDoseQty,ARCOSItemUOM,ARCOSItemFrequence,ARCOSItemDuration,ARCOSItemInstruction,ARCOSItemRowid,ARCIMRowid)=""
	s (ARCOSItemUOMDR,ARCOSItemFrequenceDR,ARCOSItemDurationDR,ARCOSItemInstructionDR,ARCOSItemCatDR,ARCOSItemSubCatDR,ARCOSItemOrderType,ARCOSItmLinkDoctor,Tremark,ARCOSDHCDocOrderType)=""
	s (ARCOSDHCDocOrderTypeDR,SampleID,SampleDesc,ITMSerialNo,NO,OrderPriorRemarksDR,OrderPriorRemarks,DHCDocOrdRecLoc)=""
	s (ItmPrice)=""
	q
outOrdSetDetailInfo
	set Data=$lb(ARCIMDesc,ARCOSItemQty,ARCOSItemBillUOM,ARCOSItemDoseQty,ARCOSItemUOM,ARCOSItemFrequence,ARCOSItemDuration,ARCOSItemInstruction,ARCOSItemRowid,ARCIMRowid,ARCOSItemUOMDR,ARCOSItemFrequenceDR,ARCOSItemDurationDR,ARCOSItemInstructionDR,ARCOSItemCatDR,ARCOSItemSubCatDR,ARCOSItemOrderType,ARCOSItmLinkDoctor,Tremark,ARCOSDHCDocOrderType,ARCOSDHCDocOrderTypeDR,SampleID,SampleDesc,ITMSerialNo,NO,OrderPriorRemarksDR,OrderPriorRemarks,DHCDocOrdRecLoc,ItmPrice)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator：      zhongricheng
/// CreatDate：    
/// Description:： 新增体检医嘱套，单独调用医生站插入医嘱套方法，按体检规则插入
/// Table：        ARC_OrdSets  ARC_Alias DHC_PE_OrdSetsEx 
/// Input：        
/// Output：       
/// Return：       -1 则插入失败
/// Others：       d ##Class(web.DHCPE.CT.OrderSets).InsertUserARCOS("","qweqweqwe","112233","13","210","","qwe","000150","","")
ClassMethod InsertUserARCOS(UserRowid As %String, ARCOSCode As %String, ARCOSDesc As %String, ARCOSCatID As %String, ARCOSSubCatID As %String, ARCOSEffectDate As %String, ARCOSAlias As %String, UserID As %String, FavDepList As %String, DocMedUnit As %String, HospID As %String = "", InString As %String, LogonHospID As %String = "") As %String
{
	if ARCOSEffectDate="" s ARCOSEffectDate=+$H
	s err=##Class(web.DHCARCOrdSets).InsertARCOS(ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffectDate,UserID)
	i (err'="-1") d
	.s ARCOSRowid=err
	.s err=##Class(web.DHCUserFavItems).Insert(UserRowid,ARCOSRowid,FavDepList,DocMedUnit,HospID,"",LogonHospID)  //,HospID)  
	.if (err'="-1") d
	..s FavRowid=err
	..s err=FavRowid_$C(1)_ARCOSRowid_$C(1)_ARCOSCode
	.i ARCOSRowid'="-1" d
	..&SQL(Insert Into SQLUser.ARC_Alias (ALIAS_ARCOS_DR,ALIAS_DateFrom,ALIAS_Text,ALIAS_OrderSubCat_dr,ALIAS_Desc) Values(:ARCOSRowid,:ARCOSEffectDate,:ARCOSAlias,:ARCOSSubCatID,:ARCOSDesc))
	..s VIPLevel=$p(InString,"^",1)
	..;s:VIPLevel="" VIPLevel=..GetDefVIP()
	..s Break=$p(InString,"^",2)
	..s SexDr=$p(InString,"^",3)
	..s Deit=$p(InString,"^",4)
	..s PGBId=$p(InString,"^",5)
	..s LocId=$p(InString,"^",6)
	..s ExInfo=$p(InString,"^",7,*)
	..s err=..SetARCOSEx(ARCOSRowid,VIPLevel,Break,SexDr,Deit,PGBId,UserID,LocId,ExInfo)
	.
	q err
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 更新医嘱套扩展信息   VIP等级  是否可拆分  对应性别  价格     ExInfo(扩展字段) 顺序 开始日期 截止日期
/// Table：        DHC_PE_OrdSetsEx
/// Input：        医嘱套ID   VIP等级  是否可拆分  对应性别  价格
/// Output：       
/// Return：       0 则更新成功   非0 则更新失败
/// Others：       w ##Class(web.DHCPE.CT.OrderSets).SetARCOSEx("98","","N","","N","UN",1,105,"5^2022-10-04^2022-10-02")
ClassMethod SetARCOSEx(ARCOSRowid As %String, VIPLevel As %String, Break As %String, SexDr As %String, Deit As %String, PBGId As %String, UserID As %String, LocId As %String, ExInfo As %String = "") As %String
{
	q:ARCOSRowid="" "-1"
	s OSEID=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowid,""))
	
	s Sort=$p(ExInfo,"^",1)
	s DateBeg=$p(ExInfo,"^",2) 
	s:DateBeg'="" DateBeg=##class(websys.Conversions).DateHtmlToLogical(DateBeg) 
	s DateEnd=$p(ExInfo,"^",3) 
	s:DateEnd'="" DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd) 
	
	if OSEID="" {
		TSTART
		&SQL(Insert Into SQLUser.DHC_PE_OrdSetsEx (OSE_OrdSets_DR,OSE_Break,OSE_Sex_DR,OSE_Deit,OSE_VIPlevel,OSE_PGBase_DR,OSE_Loc,OSE_Order,OSE_DateBegin,OSE_DateEnd) Values(:ARCOSRowid,:Break,:SexDr,:Deit,:VIPLevel,:PBGId,:LocId,:Sort,:DateBeg,:DateEnd))
		if SQLCODE'=0 {
			TROLLBACK
			q SQLCODE
		}
		//s ^zrc=$lb("DHC_PE_OrdSetsEx",%ROWID,LocId,UserID)
		s ret=##class(User.DHCPEOrdSetsEx).SaveDataToPowerControl(%ROWID,LocId,UserID)
		i ($p(ret,"^",1)="-1") {
			TROLLBACK
			q "-1"  // "-1^插入记录授权表失败"
		}
		TCommit
	} else {
		&SQL(Update SQLUser.DHC_PE_OrdSetsEx Set OSE_Break=:Break,OSE_Sex_DR=:SexDr,OSE_Deit=:Deit,OSE_VIPlevel=:VIPLevel,OSE_PGBase_DR=:PBGId,OSE_Order=:Sort,OSE_DateBegin=:DateBeg,OSE_DateEnd=:DateEnd Where OSE_RowId=:OSEID)
	}
	q SQLCODE
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 启用/禁用医嘱套
/// Table：        DHC_PE_OrdSetsEx
/// Input：        医嘱套ID   启用N  禁用 Y
/// Output：       
/// Return：       0 则更新成功   非0 则更新失败
/// Others：       w ##Class(web.DHCPE.CT.OrderSets).UpdARCOSDisable("485","Y","1","")
ClassMethod UpdARCOSDisable(ARCOSRowid As %String, Disabled As %String, LocID As %String, UserID As %String) As %String
{
	q:ARCOSRowid="" "-1"
	s OSEID=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowid,""))
	if OSEID="" {
		TSTART
		&SQL(Insert Into SQLUser.DHC_PE_OrdSetsEx (OSE_Disabled) Values(:Disabled))
		if SQLCODE'=0 {
			TROLLBACK
			q SQLCODE
		}
		
		s ret=##class(User.DHCPEOrdSetsEx).SaveDataToPowerControl(%ROWID,LocID,UserID)
		i ($p(ret,"^",1)="-1") {
			TROLLBACK
			q "-1"  // "-1^插入记录授权表失败"
		}
		TCommit
	} else {
		&SQL(Update SQLUser.DHC_PE_OrdSetsEx Set OSE_Disabled=:Disabled Where OSE_RowId=:OSEID)
	}
	q SQLCODE
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 删除医嘱套
/// Table：        
/// Input：        医嘱套ID
/// Output：       
/// Return：       0 则删除成功   非0 则删除失败
/// Others：       w ##Class(web.DHCPE.CT.OrderSets).DeleteUserARCOS()
ClassMethod DeleteUserARCOS(iFavRowid As %String, iARCOSRowid As %String)
{
	q:((iARCOSRowid="")!(iFavRowid="")) "-1"
	s ret=##class(web.DHCUserFavItems).DeleteUserARCOS(iFavRowid)
	q:ret="-1" "-1"
	s ret1=..DelARCOSEx(iARCOSRowid)
	q ret
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 删除医嘱套扩展信息
/// Table：        DHC_PE_OrdSetsEx
/// Input：        医嘱套ID
/// Output：       
/// Return：       0 则删除成功   非0 则删除失败
/// Others：       w ##Class(web.DHCPE.CT.OrderSets).DelARCOSEx("485")
ClassMethod DelARCOSEx(ARCOSRowid As %String)
{
	q:ARCOSRowid="" "-1"
	s OSEID=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowid,""))
	q:OSEID="" "-1"
	
	&sql(Delete From SQLUser.DHC_PE_OrdSetsEx Where OSE_RowId=:OSEID)

	q SQLCODE
}

/// 获取默认客户等级ID
/// w ##class(web.DHCPE.CT.OrderSets).GetDefVIP()
ClassMethod GetDefVIP() As %String
{
	s VipId=0,ret=""
	f  s VipId=$o(^DHCPEVIPLevel("VIP",VipId)) q:(VipId="")||(ret'="")  d    // 多个默认只返回第一个，若有值则退出
	.q:"N"=$p($g(^DHCPEVIPLevel("VIP",VipId)),"^",5)  // Y为默认
	.s ret=VipId

	q ret
}

/// web.DHCUserFavItems   UpdateUserARCOS
/// 更新体检医嘱套明细
/// w ##class(web.DHCPE.CT.OrderSets).UpdateUserARCOS()
ClassMethod UpdateUserARCOS(FavRowid As %String, ARCOSCode As %String, ARCOSDesc As %String, ARCOSCatID As %String, ARCOSSubCatID As %String, ARCOSEffectDate As %String, ARCOSAlias As %String, FavDepList As %String, DocMedUnit As %String, UserDr As %String, InString As %String, FavHospDr As %String) As %String
{
	s ARCOSRowid=$p($g(^DHCFavItems(FavRowid)),"^",3)
	q:ARCOSRowid="" "-1"
	s err=##Class(web.DHCUserFavItems).UpdateUserARCOS(FavRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffectDate,ARCOSAlias,FavDepList,DocMedUnit,UserDr,FavHospDr)

	if err=0 d
	.s VIPLevel=$p(InString,"^",1)
	.;s:VIPLevel="" VIPLevel=..GetDefVIP()
	.s Break=$p(InString,"^",2)
	.s SexDr=$p(InString,"^",3)
	.s Deit=$p(InString,"^",4)
	.s PGBId=$p(InString,"^",5)
	.s LocId=$p(InString,"^",6)
	.s ExInfo=$p(InString,"^",7,*)				   
	.s err=..SetARCOSEx(ARCOSRowid,VIPLevel,Break,SexDr,Deit,PGBId,UserDr,LocId,ExInfo)

	q err
}

/// 批量增加套餐明细
/// w ##class(web.DHCPE.CT.OrderSets).BatchUpdateUserARCOS()
ClassMethod BatchUpdateUserARCOS(ARCOSRowid, ArcimInfo, LocID As %String = "", HospID As %String = "")
{
	s $zt="BatchUpdateUserARCOSErr"
	s flag=0
	q:((ARCOSRowid="")||(ArcimInfo="")) flag
	
	s AmtFlag = ""
	s priceSub=$o(^ARCOS(ARCOSRowid,"PRICE",0))
	i priceSub'="" d
	.s ARCOSPriceType=$p($g(^ARCOS(ARCOSRowid,"PRICE",priceSub)),"^",8)
	.s:ARCOSPriceType="H" AmtFlag=2

	//TSTART
	for iOSItem=1:1:$l(ArcimInfo,"^") {
		s OSItemId=$p(ArcimInfo,"^",iOSItem)
		continue:OSItemId=""
		continue:OSItemId'["||"
		s ARCIMRowId=$p($g(^ARCOS(+OSItemId,"DATE",$p(OSItemId,"||",2),"ITM",$p(OSItemId,"||",3))),"^",1)
		continue:ARCIMRowId=""
		
		// 判断医嘱套中是否有该医嘱
		//s flag=..IsHaveItemInOrdSets(ARCOSRowid,ARCIMRowId)
		//continue:flag=1
		// 项目类型
		s jsonStr=..GetItemTypeAndDesc(ARCIMRowId)
		s jsonData={}.%FromJSON(jsonStr)
		s ItemOrderType=jsonData.ItemOrderType
		
		// 数量
		s ItemQty=$p($g(^ARCOS(+OSItemId,"DATE",$p(OSItemId,"||",2),"ITM",$p(OSItemId,"||",3))),"^",2)
		
		// 剂量
		s ItemDoseQty=$p($g(^ARCOS(+OSItemId,"DATE",$p(OSItemId,"||",2),"ITM",$p(OSItemId,"||",3))),"^",13)
		
		// 剂量单位
		s ItemDoseUOMID=$p($g(^ARCOS(+OSItemId,"DATE",$p(OSItemId,"||",2),"ITM",$p(OSItemId,"||",3))),"^",10)
		
		// 频次
		s ItemFrequenceID=$p($g(^ARCOS(+OSItemId,"DATE",$p(OSItemId,"||",2),"ITM",$p(OSItemId,"||",3))),"^",7)
		
		// 疗程
		s ItemDurationID=$p($g(^ARCOS(+OSItemId,"DATE",$p(OSItemId,"||",2),"ITM",$p(OSItemId,"||",3))),"^",8)
		
		// 用法
		s ItemInstructionID=$p($g(^ARCOS(+OSItemId,"DATE",$p(OSItemId,"||",2),"ITM",$p(OSItemId,"||",3))),"^",9)
		
		// 关联
		s ItmLinkDoctor=$p($g(^ARCOS(+OSItemId,"DATE",$p(OSItemId,"||",2),"ITM",$p(OSItemId,"||",3))),"^",14)
		
		// 备注
		s remark=$p($g(^ARCOS(+OSItemId,"DATE",$p(OSItemId,"||",2),"ITM",$p(OSItemId,"||",3))),"^",9)
		
		// ^OECPR 医嘱类型 
		s DHCDocOrderTypeID=$p($g(^ARCOS(+OSItemId,"DATE",$p(OSItemId,"||",2),"ITM",$p(OSItemId,"||",3),"DHC")),"^",1)
		
		// 标本
		s SampleId=$p($g(^ARCOS(+OSItemId,"DATE",$p(OSItemId,"||",2),"ITM",$p(OSItemId,"||",3),"DHC")),"^",2)
		s:SampleId="" SampleId=..GetDefLabSpecId(ARCIMRowId)
		
		// 序号
		s ARCOSItemNO=""
		
		// 附加说明
		s OrderPriorRemarksDR=$p($g(^ARCOS(+OSItemId,"DATE",$p(OSItemId,"||",2),"ITM",$p(OSItemId,"||",3),"DHC")),"^",3)
		
		// 接收科室
		s RecLoc=$p($g(^ARCOS(+OSItemId,"DATE",$p(OSItemId,"||",2),"ITM",$p(OSItemId,"||",3))),"^",22)
		if RecLoc="" {
			s jsonStr=..GetItemLocIdAndUOMId(ARCIMRowId)
			s jsonData={}.%FromJSON(jsonStr)
			s RecLoc=jsonData.RecLoc
		}
		
		s ExpStr=""
		
		s rtn=##class(web.DHCARCOrdSets).InsertItem(ARCOSRowid,ARCIMRowId,ItemQty,ItemDoseQty,ItemDoseUOMID,ItemFrequenceID,ItemDurationID,ItemInstructionID,ItmLinkDoctor,remark,DHCDocOrderTypeID,SampleId,ARCOSItemNO,OrderPriorRemarksDR,RecLoc,ExpStr)
		if ($l(rtn,"||")'=3) {
			s flag=-1
			q
		}
		if (AmtFlag=2) {
			s UnitPriceJsons=..GetOSItemPrice(OSItemId, +$h)
			i UnitPriceJsons="" d
			.s UnitPrice = ##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(ARCIMRowId)
			e  d
			.s UnitPriceJson={}.%FromJSON(UnitPriceJsons)
			.s UnitPrice = UnitPriceJson.price
			s updRet=..UpdPEOSDetailPrice(rtn, UnitPrice, LocID, HospID)
			if ($p(updRet,"^",1)'=0) { 
	        	s flag=-2
	        	q
			}
		}
		s flag=1
	}
	i flag'=1 {
		//TROLLBACK
		q flag
	}
	
	if (AmtFlag=2) {
		s osType=""
		s osType="H"
		s Tariff=0
		f  s Tariff=$o(^ARC("TAR",Tariff)) q:(Tariff="")||($p($g(^ARC("TAR",Tariff)),"^",2)["体检")  d
		s:Tariff="" Tariff=$o(^ARC("TAR",0))
		
		s (Index,osPrice) = 0
		f  s Index = $o(^ARCOS(ARCOSRowid,"DATE",1,"ITM",Index)) q:Index=""  d
		.s tpriceJson=..GetOSItemPrice(ARCOSRowid_"||1||"_Index)
		.q:tpriceJson=""
		.s tprice={}.%FromJSON(tpriceJson)
		.s osPrice=osPrice+tprice.price
		
		s CurDate=+$h
		if $o(^ARCOS(ARCOSRowid,"PRICE",0))="" d
		.&sql(INSERT INTO sqluser.ARC_OrdSetPrice (PRICE_ParRef,PRICE_DateFrom,PRICE_Tariff_DR,PRICE_Price,PRICE_EpisodeType) VALUES (:ARCOSRowid,:CurDate,:Tariff,:osPrice,:osType))
		e  d
		.&sql(UPDATE sqluser.ARC_OrdSetPrice SET PRICE_DateFrom=:CurDate,PRICE_DateTo=null,PRICE_Tariff_DR=:Tariff,PRICE_Price=:osPrice,PRICE_EpisodeType=:osType WHERE PRICE_ParRef=:ARCOSRowid)
		s:SQLCODE=100 SQLCODE=0
		if (SQLCODE'=0) {
			//TROLLBACK
			s flag=-3
	        q flag
		}
		d ..SetARCOSPriceNew(ARCOSRowid, osPrice)
	}
	//TCommit
	
	q flag
BatchUpdateUserARCOSErr
	//TROLLBACK
	s $zt=""
    q -101
}

/// 获取检验项目对应的默认标本 调用医生站方法 w ##class(web.DHCDocOrderCommon).GetLabSpec("2521||1")
/// w ##class(web.DHCPE.CT.OrderSets).GetDefLabSpecId("4716||1")
ClassMethod GetDefLabSpecId(ArcimRowId As %String)
{
	q:ArcimRowId="" ""
	s SpecData=##class(web.DHCPE.PreItemList).GetDefaultSpecName(ArcimRowId,1)
	
	q $p(SpecData,"^",1)
	
	s SpecNames = ##class(web.DHCDocOrderCommon).GetLabSpec(ArcimRowId)
	s SpecNamelen = $l($g(SpecNames),$c(2))
	q:(SpecNamelen=1)||(SpecNamelen="") ""
	s num=0
	for i=1:1:(SpecNamelen-1) {
		s SpecName=$p($g(SpecNames),$c(2),i)
		if $p($g(SpecName),$c(3),5)="Y" {
			s ret=$p($g(SpecName),$c(3),1)
			break
		}
	}
	q:ret="" $p($g(SpecName),$c(3),1)
	q ret
}

/// 获取接收科室和单位
/// w ##class(web.DHCPE.CT.OrderSets).GetItemLocIdAndUOMId("4716||1")
ClassMethod GetItemLocIdAndUOMId(ArcimRowId As %String)
{
	q:ArcimRowId=""
	// 单位
	s ArcimBillUOMRowid=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	s:ArcimBillUOMRowid="" ArcimBillUOMRowid=63
	
	s LocId=%session.Get("LOGON.CTLOCID")
	s:LocId="" LocId=263
	s LocDesc=$p($p($g(^CTLOC(LocId)),"^",2),"-",2)
	s Flag=0
	s RecLoc=""
	// 根据登陆科室取接收科室，调用医生站程序
	i LocId'="" d
    .s ReturnMesag=##class(web.DHCDocOrderCommon).GetLocRecLoc(LocId,ArcimRowId)
    .s:ReturnMesag[LocDesc Flag=1
    .s:ReturnMesag[LocDesc RecLoc=LocId
	e  d
	.s ReturnMesag=##class(web.DHCARCOrdSets).GetLocRecLoc(ArcimRowId)
	.s:ReturnMesag[LocDesc Flag=1
	.s:ReturnMesag[LocDesc RecLoc=LocId
	
	s LenR=$L(ReturnMesag,$c(2))
	s J=0
	for  s J=J+1 q:(J>LenR)||(Flag=1)  d
	.s SUStr=$P(ReturnMesag,$c(2),J)
	.s SRowID=$P(SUStr,$C(1),1)
	.q:SRowID=""
	.s SDesc=$P(SUStr,$C(1),2)
	.s Default=$P(SUStr,$C(1),3)
	.q:Default'="Y"
	.s:Default="Y" RecLoc=SRowID

	s ret=ArcimBillUOMRowid_"^"_RecLoc
	q "{""ArcimBillUOMRowid"":"""_ArcimBillUOMRowid_""",""RecLoc"":"""_RecLoc_"""}"

	/*
	q:ArcimRowId=""
	// 单位
	s ArcimBillUOMRowid=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	s:ArcimBillUOMRowid="" ArcimBillUOMRowid=63
	
	// 接收科室
	s LocId=""
	s ReturnMesag=##class(web.DHCARCOrdSets).GetLocRecLoc(ArcimRowId)
	s LenR=$L(ReturnMesag,$c(2))
	for J=1:1:LenR{
		s SUStr=$P(ReturnMesag,$c(2),J)
		s SRowID=$P(SUStr,$C(1),1)
		Continue:SRowID=""
		s SDesc=$P(SUStr,$C(1),2)
		s Default=$P(SUStr,$C(1),3)
		s:Default="Y" LocId=SRowID
	}
	s ret=ArcimBillUOMRowid_"^"_LocId
	q ret
	*/
}

/// 判断医嘱套中是否存在该医嘱  1 存在   0 不存在
/// w ##class(web.DHCPE.CT.OrderSets).IsHaveItemInOrdSets(4188,"2521||1")
ClassMethod IsHaveItemInOrdSets(ARCOSRowid As %String, ArcimRowId As %String)
{
	q:(ARCOSRowid="")||(ArcimRowId="")
	s flag=0
	s ItmSub=0
	f  s ItmSub = $o(^ARCOS(ARCOSRowid,"DATE",1,"ITM",ItmSub)) q:ItmSub=""  d
	.s ItmRowId=$p($g(^ARCOS(ARCOSRowid,"DATE",1,"ITM",ItmSub)), "^", 1)
	.q:+$g(^DHCPECTDataEx("DHCPEStationOrder","AlowAddFlag",ItmRowId))=1
	.s:ItmRowId=ArcimRowId flag=1
	q flag
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 增加医嘱套的包装价格
/// Table：        ARC_OrdSetPrice
/// Input：        医嘱套ID    价格开始时间    价格截止时间    价格
/// Output：       
/// Return：       0 则更新成功   非0 则更新失败/.,,.,mm
/// Others：       w ##class(web.DHCPE.CT.OrderSets).UpdateARCOS/,Price("1800","2018-01-01","2018-01-01")
ClassMethod UpdateARCOSPrice(ARCOSRowid As %String = "", DateFrom As %String = "", DateTo As %String = "", Price As %String = "", Hospital As %String = "", Amount As %String = "") As %String
{
	s ^tempdhcpe("UpdateARCOSPrice")=$lb(ARCOSRowid,DateFrom,DateTo, Price,Hospital,Amount)
	q:ARCOSRowid=""
	i DateFrom["-" s DateFrom=$zdh(DateFrom,3)
 	i DateFrom["/" s DateFrom=$zdh(DateFrom,4)
 	i DateTo["-" s DateTo=$zdh(DateTo,3)
 	i DateTo["/" s DateTo=$zdh(DateTo,4)
 	q:DateFrom>DateTo "开始时间大于截止时间"
	s DateTo=$replace(DateTo," ","")
	;s Tariff=73   // 征收方式
	
	if (DateFrom="")&&(DateTo="")&&(Price="") d
	.&sql(DELETE FROM sqluser.ARC_OrdSetPrice WHERE PRICE_ParRef=:ARCOSRowid)
	e  d
	.s Tariff=0
	.f  s Tariff=$o(^ARC("TAR",Tariff)) q:(Tariff="")||($p($g(^ARC("TAR",Tariff)),"^",2)["体检")  d
	.s:Tariff="" Tariff=$o(^ARC("TAR",0))
	.b ;
	.
	.if $o(^ARCOS(ARCOSRowid,"PRICE",0))="" d
	..&sql(INSERT INTO sqluser.ARC_OrdSetPrice (PRICE_ParRef,PRICE_DateFrom,PRICE_DateTo,PRICE_Tariff_DR,PRICE_Price) VALUES (:ARCOSRowid,:DateFrom,:DateTo,:Tariff,:Price))
	.e  d
	..&sql(UPDATE sqluser.ARC_OrdSetPrice SET PRICE_DateFrom=:DateFrom,PRICE_DateTo=:DateTo,PRICE_Tariff_DR=:Tariff,PRICE_Price=:Price WHERE PRICE_ParRef=:ARCOSRowid)
	
	s:SQLCODE="100" SQLCODE="0"
	d:SQLCODE="0" ..SetARCOSPrice(ARCOSRowid, Price)
	
	s rtn=SQLCODE
	q rtn
}

/// 输出套餐价格
/// w ##class(web.DHCPE.CT.OrderSets).GetOrdSetsAmount("1890")
ClassMethod GetOrdSetsAmount(ARCOSRowId As %String, Type As %String = "", LocID As %String = "", hospId As %String = "")
{
	q:ARCOSRowId="" "请选择医嘱套"
	
	s (Index,Amount,Count) = 0
	f  s Index = $o(^ARCOS(ARCOSRowId,"DATE",1,"ITM",Index)) q:Index=""  d
	.s ARCIMRowId = $p($g(^ARCOS(ARCOSRowId,"DATE",1,"ITM",Index)),"^",1)
	.s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",ARCIMRowId,Type,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ARCIMRowId,hospId)
	.q:(HOSPshowFlag="N")
	.s UnitPrice = ##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(ARCIMRowId,"","","","","","","","","")
	.s Amount = Amount + UnitPrice
	.s Count=Count+1
	s ARCOSPrice=##class(web.DHCPE.Handle.ARCOrdSets).GetPrice(ARCOSRowId,"","","",Type,LocID,hospId)
	s:ARCOSPrice="" ARCOSPrice=0
	d ..SetARCOSPrice(ARCOSRowId,ARCOSPrice)
	q "{""Amount"":"""_$fn(Amount,"",2)_""",""ARCOSPrice"":"""_$fn(ARCOSPrice,"",2)_""",""Count"":"""_Count_"""}"
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description：  更新医嘱套扩展表的价格
/// Table：        DHC_PE_OrdSetsEx
/// Input：        医嘱套ID     价格
/// Output：       
/// Return：       0 则更新成功   非0 则更新失败
/// Others：       w ##Class(web.DHCPE.CT.OrderSets).SetARCOSPrice("485","150")
ClassMethod SetARCOSPrice(ARCOSRowid As %String, Price As %String) As %String
{
	q:ARCOSRowid="" "-1"
	
	s OSEID=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowid,""))
	q:OSEID="" "-1"
	i Price="" {
		s OSAmt=..GetOrdSetsAmount(ARCOSRowid)
		s OSAmtObj={}.%FromJSON(OSAmt)
		s Price=OSAmtObj.Amount
	}
	&SQL(Update SQLUser.DHC_PE_OrdSetsEx Set OSE_Price=:Price Where OSE_RowId=:OSEID)
	q SQLCODE
}

/// Creator：      zhongricheng 
/// Description:： 修改医嘱套的包装价格
/// Others：       w ##class(web.DHCPE.CT.OrderSets).UpdateOSExPrice("1800")
ClassMethod UpdateOSExPrice(ARCOSRowid As %String = "") As %String
{
	q:ARCOSRowid=""
	
	d ..SetARCOSPrice(ARCOSRowid, "")
	
	s OSAmt=..GetOrdSetsAmount(ARCOSRowid)
	s OSAmtObj={}.%FromJSON(OSAmt)
	s Price=OSAmtObj.Amount

	q Price
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 判断医嘱套是否有包装价格
/// Table：        ARC_OrdSetPrice
/// Input：        医嘱套ID
/// Output：       
/// Return：       0 则无   1 则有
/// Others：       w ##class(web.DHCPE.CT.OrderSets).IsHaveAmount("1806")
ClassMethod IsHaveAmount(ARCOSRowid As %String = "") As %String
{
	q:ARCOSRowid="" "-1"
	
	s OSEID=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowid,""))
	q:OSEID="" "-1"
	
	s flag="1"
	s id=$o(^ARCOS(ARCOSRowid,"PRICE",0))
	s:id="" flag="0"
	q flag
}

/// 查询团体
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.OrderSets","QueryPGBI","")
Query QueryPGBI(GDesc As %Library.String = "") As websys.Query(ROWSPEC = "id:%String,code:%String,desc:%String") [ SqlProc ]
{
}

ClassMethod QueryPGBIExecute(ByRef qHandle As %Binary, GDesc As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	s id="UN",desc="没有分类",code=""
 	d QueryOutGDesc
 	
 	s:GDesc'="" GDesc=$ZCVT(GDesc,"U")
 	s id=""
 	f  s id=$o(^DHCPEPreGBI(id),-1)  q:(id="")||(id=0)  d
	.s desc=$p($g(^DHCPEPreGBI(id)),"^",2)
	.s code=$p($g(^DHCPEPreGBI(id)),"^",1)
	.s TNamePY=##class(web.DHCINSUPort).GetCNCODE(desc,4,"")
	.q:((""'=GDesc)&('(($ZCVT(desc,"U")[GDesc)||(TNamePY[GDesc))))	
 	.d QueryOutGDesc
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

QueryOutGDesc
	set Data=$lb(id,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 更新医嘱套项目的序号
/// w ##class(web.DHCPE.CT.OrderSets).UpdateItemSerialNo("")
ClassMethod UpdateItemSerialNo(ARCOSItemRowid As %String, ItemSerialNo As %String, ArcimId As %String) As %String
{
	//n (ARCOSItemRowid,ItemSerialNo,ArcimId)
	s SQLCODE=0
	//if (ArcimId["||"){
		&SQL(Update sqluser.ARC_OrdSetDateItem set ITM_SerialNo=:ItemSerialNo Where ITM_Rowid=:ARCOSItemRowid)
	//}else{
		//&SQL(Update sqluser.ARC_OrdSetDateOS set OS_SerialNo=:ItemSerialNo Where OS_RowId=:ARCOSItemRowid)
	//}
	Q SQLCODE
}

/// Creator：      zhongricheng 
/// Description:： 获取医嘱套明细信息
/// Others：       w ##Class(web.DHCPE.CT.OrderSets).GetOSItemData("1858||1||7")
ClassMethod GetOSItemData(OSItemId) As %String
{
	q:((OSItemId="")!($l(OSItemId,"||")'=3)) ""
	;套餐项目ID
	s ARCOSItemRowid=OSItemId
	s OrdSetsRowid=$p(ARCOSItemRowid,"||",1)
	s ItemCub=$p(ARCOSItemRowid,"||",2)
	s ItemSub=$p(ARCOSItemRowid,"||",3)
	s ItemData=$g(^ARCOS(OrdSetsRowid,"DATE",ItemCub,"ITM",ItemSub))
	
	;ARCIM 项目详情
	s ARCIMRowid=$p(ItemData,"^",1)
	s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	;医嘱大类?子类?类型
	s ARCOSItemSubCatDR="",ARCOSItemCatDR="",ARCOSItemOrderType=""
	s ARCOSItemSubCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	i ARCOSItemSubCatDR'="" d
	.s ARCOSItemCatDR=$p($g(^ARC("IC",ARCOSItemSubCatDR)),"^",8)
	.s ARCOSItemOrderType=$p($g(^ARC("IC",ARCOSItemSubCatDR)),"^",7)
	s ItmPrice=##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(ARCIMRowid)
	
	s ArcimClassification=""
	;帐单单位
	s ARCOSItemBillUOM=""
	s BillUOMDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	i (BillUOMDR'="") s ARCOSItemBillUOM=$p($g(^CT("UOM",BillUOMDR)),"^",2) //&&(ArcimClassification="RW")
	
	;数量
	s ARCOSItemQty=$p(ItemData,"^",2)
	
	;疗程
	s ARCOSItemDuration=""
	s ARCOSItemDurationDR=$p(ItemData,"^",7)
	i ARCOSItemDurationDR'="" s ARCOSItemDuration=$p($g(^PHCDU(ARCOSItemDurationDR)),"^",3)
	
	;频率
	s ARCOSItemFrequence=""
	s ARCOSItemFrequenceDR=$p(ItemData,"^",8)
	i ARCOSItemFrequenceDR'="" s ARCOSItemFrequence=$p($g(^PHCFR(ARCOSItemFrequenceDR)),"^",3)

	;用法
	s ARCOSItemInstruction=""
	s ARCOSItemInstructionDR=$p(ItemData,"^",9)
	i ARCOSItemInstructionDR'="" s ARCOSItemInstruction=$p($g(^PHCIN(ARCOSItemInstructionDR)),"^",2)
	
	;剂量单位
	s ARCOSItemUOM=""
	s ARCOSItemUOMDR=$p(ItemData,"^",10)
	i ARCOSItemUOMDR'="" s ARCOSItemUOM=$p($g(^CT("UOM",ARCOSItemUOMDR)),"^",2)
	
	;剂量
	s ARCOSItemDoseQty=$p(ItemData,"^",13)
	
	;关联
	s ARCOSItmLinkDoctor=$p(ItemData,"^",14)
	
	;ITMSerialNo
	s ITMSerialNo=$p(ItemData,"^",20)
	
	;接收科室
	s DHCDocOrdRecLocDR=$p(ItemData,"^",21)
	i DHCDocOrdRecLocDR'="" d
	.s DHCDocOrdRecLoc=$p($g(^CTLOC(DHCDocOrdRecLocDR)),"^",2)
	e  s DHCDocOrdRecLoc=""
	
	;备注
	s Tremark=$g(^ARCOS(OrdSetsRowid,"DATE",ItemCub,"ITM",ItemSub,"NOTES",1))
	
	;医嘱类型
	s OECPRRowId=$p($g(^ARCOS(OrdSetsRowid,"DATE",ItemCub,"ITM",ItemSub,"DHC")),"^",1)
	s ARCOSDHCDocOrderType=""
	s ARCOSDHCDocOrderTypeDR=OECPRRowId
	s:OECPRRowId'="" ARCOSDHCDocOrderType=$p(^OECPR(OECPRRowId),"^",2) 
	
	;标本
	s SampleID=$p($g(^ARCOS(OrdSetsRowid,"DATE",ItemCub,"ITM",ItemSub,"DHC")),"^",2)
	i ($g(HospitalCode)="")&&($d(%session)) s HospitalCode=%session.Get("LOGON.HOSPID")
	s SampleDesc=""
	i $d(^DHCLISBSVersion(1))&&(SampleID'="") d
	.s HospitalCode=$g(HospitalCode)
	.s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",$c(32)_HospitalCode,""))
	.i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	.i $l(HospitalDR) d
	..s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR," "_SampleID,""))
	..s:SpecimenDR'="" SampleDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	e  d
	.s:SampleID'="" SampleDesc=$p($G(^TTAB("SPEC",SampleID)),"\",1)
	.s:SampleID="" SampleDesc=""
	
	;附加说明
	s OrderPriorRemarks=""
	s OrderPriorRemarksDR=$p($g(^ARCOS(OrdSetsRowid,"DATE",ItemCub,"ITM",ItemSub,"DHC")),"^",3)
	s OrderPriorRemarks=$CASE(OrderPriorRemarksDR,"ONE":"取药医嘱","OUT":"出院带药","PRN":"PRN","OM":"自备药","ZT":"嘱托",:"")

	s data="{"
	s data=data_"""ARCOSItemRowid"":"""_ARCOSItemRowid_""","
	s data=data_"""ARCIMRowid"":"""_ARCIMRowid_""","
	s data=data_"""ARCOSItemUOMDR"":"""_ARCOSItemUOMDR_""","
	s data=data_"""ARCOSItemFrequenceDR"":"""_ARCOSItemFrequenceDR_""","
	s data=data_"""ARCOSItemDurationDR"":"""_ARCOSItemDurationDR_""","
	s data=data_"""ARCOSItemInstructionDR"":"""_ARCOSItemInstructionDR_""","
	s data=data_"""ARCOSItemCatDR"":"""_ARCOSItemCatDR_""","
	s data=data_"""ARCOSItemSubCatDR"":"""_ARCOSItemSubCatDR_""","
	s data=data_"""ARCOSItemOrderType"":"""_ARCOSItemOrderType_""","
	s data=data_"""ARCOSDHCDocOrderTypeDR"":"""_ARCOSDHCDocOrderTypeDR_""","
	s data=data_"""SampleID"":"""_SampleID_""","
	s data=data_"""ITMSerialNo"":"""_ITMSerialNo_""","
	s data=data_"""OrderPriorRemarksDR"":"""_OrderPriorRemarksDR_""","
	s data=data_"""NO"":"""_ITMSerialNo_""","
	s data=data_"""ARCIMDesc"":"""_ARCIMDesc_""","
	s data=data_"""ARCOSDHCDocOrderType"":"""_ARCOSDHCDocOrderType_""","
	s data=data_"""DHCDocOrdRecLoc"":"""_DHCDocOrdRecLoc_""","
	s data=data_"""SampleDesc"":"""_SampleDesc_""","
	s data=data_"""ItmPrice"":"""_ItmPrice_""","
	s data=data_"""ARCOSItemQty"":"""_ARCOSItemQty_""","
	s data=data_"""ARCOSItemBillUOM"":"""_ARCOSItemBillUOM_""","
	s data=data_"""ARCOSItemDoseQty"":"""_ARCOSItemDoseQty_""","
	s data=data_"""ARCOSItemUOM"":"""_ARCOSItemUOM_""","
	s data=data_"""ARCOSItemFrequence"":"""_ARCOSItemFrequence_""","
	s data=data_"""ARCOSItemDuration"":"""_ARCOSItemDuration_""","
	s data=data_"""ARCOSItemInstruction"":"""_ARCOSItemInstruction_""","
	s data=data_"""ARCOSItmLinkDoctor"":"""_ARCOSItmLinkDoctor_""","
	s data=data_"""Tremark"":"""_Tremark_""","
	s data=data_"""OrderPriorRemarks"":"""_OrderPriorRemarks_""""
	s data=data_"}"
 
 	q data
}

/// Creator：      zhongricheng 
/// Description:： 药品相关信息控件 参照 web.UDHCFavItemNew.cls CombListFind()
/// Others：       d ##class(%ResultSet).RunQuery("web.DHCPE.CT.OrderSets","OrdSetsDrugsInfo","ItemDoseUOM","","562||1")
Query OrdSetsDrugsInfo(CombName As %String = "", Desc As %String = "", ARCIMRowid As %String = "", PAADM As %String = "") As websys.Query(ROWSPEC = "Id:%String,Desc:%String")
{
}

ClassMethod OrdSetsDrugsInfoExecute(ByRef qHandle As %Binary, CombName As %String = "", Desc As %String = "", ARCIMRowid As %String = "", PAADM As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
	Set qHandle=$lb(0,repid,0)
 	
	// 取草药标志 0 不是,1 是 则返回药学基本单位 g 219
	s CMFlag="N"  // 
	if (ARCIMRowid'="") {
		s CNMedFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowid)
		s:CNMedFlag=1 CMFlag="Y"
	}

 	if (CombName="ItemDoseUOM"){		//剂量单位 PHC_DrgMast, PHC_DrgForm, PHC_DrgFormExt
		if ARCIMRowid'=""{
			s DrgFormRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",12)
			s PHCDRowid=+$P(DrgFormRowid,"||",1)
		    s ChildSub=+$P(DrgFormRowid,"||",2)
			if ((PHCDRowid'=0)&&(ChildSub'=0)) {
		 		s id=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4),desc="",tid=""
		 		if id'="" {
			 		s desc=$P($g(^CT("UOM",id)),"^",2)
			 		if ((Desc="")||(("^"_desc)[("^"_Desc))) {
				 		s tid=id
				 		;s desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTUOM",desc,"CTUOMDesc","cls")
				 		d DrugsInfo
			 		}
		 		}
		  		s leq=0
		  	    f  s leq=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)) Q:leq=""  d
		  		.s info=$g(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq))
		  		.s id=$p(info,"^")
		  		.q:id=""
		  		.q:((tid'="")&&(tid=id))
		 	 	.s desc=$P($g(^CT("UOM",id)),"^",2)
		  		.q:desc=""
		  		.q:((Desc'="")&&(("^"_desc)'[("^"_Desc)))
		  		.;s desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTUOM",desc,"CTUOMDesc","cls")
		  		.d DrugsInfo
			}
		}
 	} elseif (CombName="ItemFreq") {		// 频次  PHC_Freq
		s id=0
		f  s id=$o(^PHCFR(id)) q:(id="")  d
		.s data=$g(^PHCFR(id))
		.q:$p(data,"^",6)'="Y"
	    .s AvailableType=$p(data,"^",7)
	    .q:((AvailableType'="")&&((","_AvailableType_",")'[(",H,"))&&(PAADM'=""))
		.s desc=$p(data,"^",3)
		.q:((Desc'="")&&(("^"_desc)'[("^"_Desc)))
		.;s desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.PHCFreq",desc,"PHCFRDesc1","cls")
		.d DrugsInfo
 	} elseif (CombName="ItemInstruction") {		// 用法  PHC_Instruc
		q:(CMFlag="Y") $$$OK

		s id=0
		f  s id=$o(^PHCIN(id)) q:id=""  d
		.s data=$g(^PHCIN(id))
		.q:$p(data,"^",4)'="Y"
		.s code=$p(data,"^",1)
		.s desc=$p(data,"^",2)
		.s mydes2=$p(data,"^",3)
		.q:((Desc'="")&&((("^"_code)'[("^"_Desc))||(("^"_desc)'[("^"_Desc))))
		.s desc2=$p(data,"^",3)
		.s:desc=mydes2 mydes2=""
		.;s desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.PHCInstruc",desc,"PHCINDesc1","cls")
		.d DrugsInfo
 	} elseif (CombName="ItemDuration") {		// 疗程  PHC_Duration
		q:(CMFlag="Y") $$$OK

	 	s id=0
		f  s id=$o(^PHCDU(id)) q:id=""  d
		.s data=$g(^PHCDU(id))
		.s mydes2=$p(data,"^",4)
		.q:(CMFlag="Y")&&(mydes2'="饮片")  //lxz
		.q:(CMFlag="N")&&(mydes2="饮片")  //lxz
		.q:(CMFlag="Clear")
		.s DateFrom=$p(data,"^",5)
		.q:((DateFrom'="")&&(DateFrom>+$h))
		.s DateTo=$p(data,"^",6)
		.q:((DateTo'="")&&(DateTo<+$h))
		.s code=$p(data,"^",1)
		.s desc=$p(data,"^",3)
		.s:desc=mydes2 mydes2=""
		.q:((Desc'="")&&(("^"_desc)'[("^"_Desc)))
		.;s desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.PHCDuration",desc,"PHCDU_Desc1","cls")
		.d DrugsInfo
 	} elseif (CombName="Remark") {		// 备注信息
		s Infos=""
 		s:CMFlag="Y" Infos=$g(^DHCDocConfig("CNMedItemPhSpecInstr"))
 		f i=1:1:$l(Infos,"^") d
 		.s data=$p(Infos,"^",i)
 		.q:data=""
 		.s id=$p(data,$c(1),1)
 		.s desc=$p(data,$c(1),2)
		.q:((Desc'="")&&(("^"_desc)'[("^"_Desc)))
		.;s desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationordercom.csp",desc)
 		.d DrugsInfo
 	} elseif (CombName="PriorRemarks") {		// 附加说明  "ONE":"取药医嘱"  "OUT":"出院带药"  "PRN":"PRN"  "OM":"自备药"  "ZT":"嘱托"
 		s Infos="ONE"_$c(1)_"取药医嘱^OUT"_$c(1)_"出院带药^PRN"_$c(1)_"PRN^OM"_$c(1)_"自备药^ZT"_$c(1)_"嘱托"
 		f i=1:1:$l(Infos,"^") d
 		.s data=$p(Infos,"^",i)
 		.q:data=""
 		.s id=$p(data,$c(1),1)
 		.s desc=$p(data,$c(1),2)
		.q:((Desc'="")&&(("^"_desc)'[("^"_Desc)))
		.;s desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationordercom.csp",desc)
 		.d DrugsInfo
 	}
	
	Quit $$$OK
DrugsInfo      
	set Data=$lb(id,desc_$g(mydes2))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

/// Creator：      zhongricheng 
/// Description:： 获取医嘱相关信息
/// Others：       w ##Class(web.DHCPE.CT.OrderSets).GetItemTypeAndDesc("1858||1")
ClassMethod GetItemTypeAndDesc(ARCIMRowid) As %String
{
	q:(ARCIMRowid="") ""
	
	;ARCIM 项目详情
	s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	;医嘱大类?子类?类型
	s ItemSubCatDR="",ItemCatDR="",ItemOrderType=""
	s ItemSubCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	i ItemSubCatDR'="" d
	.s ItemCatDR=$p($g(^ARC("IC",ItemSubCatDR)),"^",8)
	.s ItemOrderType=$p($g(^ARC("IC",ItemSubCatDR)),"^",7)
	
	s data="{"
	s data=data_"""ARCIMRowid"":"""_ARCIMRowid_""","
	s data=data_"""ARCIMDesc"":"""_ARCIMDesc_""","
	s data=data_"""ItemSubCatDR"":"""_ItemSubCatDR_""","
	s data=data_"""ItemCatDR"":"""_ItemCatDR_""","
	s data=data_"""ItemOrderType"":"""_ItemOrderType_""""
	s data=data_"}"
 
 	q data
}

/// Creator：      zhongricheng 
/// Description:： 更新医嘱套明细药品信息
/// Others：       w ##Class(web.DHCPE.CT.OrderSets).UpdOSItemData()
ClassMethod UpdOSItemData(OSItemId, Data) As %String
{
	q:((OSItemId="")!($l(OSItemId,"||")'=3)!(Data="")) ""
	;套餐项目ID
	s ARCOSItemRowid=OSItemId
	s ItemDoseQty=$p(Data,"^",1)  // 剂量
	s ItemDoseUOMID=$p(Data,"^",2)  // 剂量单位
	s ItemFrequenceID=$p(Data,"^",3)  // 频次
	s ItemInstructionID=$p(Data,"^",4)  // 用法
	s ItemDurationID=$p(Data,"^",5)  // 疗程
	s ItmLinkDoctor=$p(Data,"^",6)  // 关联
	s Remark=$p(Data,"^",7)  // 备注
	s OrderPriorRemarksDR=$p(Data,"^",8)  // 附加说明
	&SQL(Update sqluser.ARC_OrdSetDateItem set ITM_DoseQty=:ItemDoseQty, ITM_UOM_DR=:ItemDoseUOMID, ITM_Freq_DR=:ItemFrequenceID, ITM_Instruc_DR=:ItemInstructionID, ITM_Durat_DR=:ItemDurationID, ITM_LinkDoctor=:ItmLinkDoctor Where ITM_Rowid=:ARCOSItemRowid)
	i 'SQLCODE {
		s OrdSetsRowid=$p(ARCOSItemRowid,"||",1)
		s ItemCub=$p(ARCOSItemRowid,"||",2)
		s ItemSub=$p(ARCOSItemRowid,"||",3)
		s ^ARCOS(OrdSetsRowid,"DATE",ItemCub,"ITM",ItemSub,"NOTES",1)=Remark
		s $p(^ARCOS(OrdSetsRowid,"DATE",ItemCub,"ITM",ItemSub,"DHC"),"^",3)=OrderPriorRemarksDR
		q SQLCODE
	}
	q -1
}

/// description：判断医嘱套中是否存在排斥项目
/// dubug：w ##class(web.DHCPE.CT.OrderSets).IsExcludeArcItem(4188,"2521||1")
ClassMethod IsExcludeArcItem(ARCOSRowid As %String, ArcimRowId As %String)
{
	s ExcludeFlag=0
	q:(ARCOSRowid="")||(ArcimRowId="") ExcludeFlag
	s flag=0
	s ItmSub=0
	f  s ItmSub = $o(^ARCOS(ARCOSRowid,"DATE",1,"ITM",ItmSub)) q:(ItmSub="")||(ExcludeFlag="1")   d
	.s ItmRowId=$p($g(^ARCOS(ARCOSRowid,"DATE",1,"ITM",ItmSub)), "^", 1)
	.S ExcludeFlag=##class(web.DHCPE.ExcludeArcItem).IsExcludeArcItem(ArcimRowId,ItmRowId)
	q ExcludeFlag
}

/// description：判断医嘱套性别和医嘱项性别是否一致
/// Dubug：w ##class(web.DHCPE.CT.OrderSets).IsCanAddItem(4188,"2521||1")
ClassMethod IsCanAddItem(ARCOSRowid As %String, ArcimRowId As %String, LocID)
{
	q:(ARCOSRowid="")||(ArcimRowId="") "{""code"":""-1"",""msg"":"""_"套餐或项目为空！""}"
    s OSEx=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowid,""))
    q:OSEx="" "{""code"":""-1"",""msg"":"""_"套餐扩展表没维护数据！""}"
    s OSExData=$g(^DHCPEOSE(OSEx))
    s OSExSex=$p(OSExData,"^",3)
    s OSExVIPLevel=$p(OSExData,"^",6)
    s OrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimRowId,LocID)
    q:OrderID="" "{""code"":""-1"",""msg"":"""_"站点项目组合没对照数据！""}"
    s ID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,OrderID,0))
    q:ID="" "{""code"":""-1"",""msg"":"""_"站点项目组合科室项目详情没维护！""}"
    s ItemVIPLevel=$lg($g(^CF.PE.StationOrderSetD(ID)),13) //vip等级
	q:((ItemVIPLevel'="")&&(OSExVIPLevel'="")&&((","_OSExVIPLevel_",")'[(","_ItemVIPLevel_","))) "{""code"":""-1"",""msg"":"""_"项目VIP等级与套餐VIP等级不一致！""}"

    s ItemSex=""
    s ItemSexDR=$lg($g(^CF.PE.StationOrderSetD(ID)),9) //性别
    i ItemSexDR'="" s ItemSex=$P(^CT("SEX",ItemSexDR),"^",2)

	/// 套餐性别项目性别一致 可添加
	/// 套餐性别项目性别不一致 且 项目性别不限或未知性别/未说明性别 也可添加
	/// 套餐性别项目性别不一致 且 套餐性别不为空(即为男/女) 则提示不一致
	/// 套餐性别项目性别不一致 且 套餐性别为空  则提示 是否修改套餐性别
	s Flag = $s(OSExSex=ItemSexDR:"{""code"":""1"",""msg"":""""}",
				((OSExSex'=ItemSexDR)&&((ItemSexDR="")||((ItemSex'="男")&&(ItemSex'="女")))):"{""code"":""1"",""msg"":""""}",
				((OSExSex'=ItemSexDR)&&(OSExSex'="")):"{""code"":""-1"",""msg"":""项目性别与套餐性别不一致！""}",
				((OSExSex'=ItemSexDR)&&(OSExSex="")):"{""code"":""0"",""msg"":""项目性别与套餐性别不一致！是否将套餐性别修改为"_ItemSex_"？"",""data"":"""_ItemSexDR_"""}",
				1:"{""code"":""1"",""msg"":""""}")

	q Flag
}

/// 输出套餐价格
/// Amount原价   ARCOSPrice定价   Count项目数量   ItemPriceFlag定价标志 0无定价 1整包定价 2项目定价
/// w ##class(web.DHCPE.CT.OrderSets).GetOrdSetsAmountNew("2674","B",371,9)
ClassMethod GetOrdSetsAmountNew(ARCOSRowId As %String, Type As %String = "", LocID As %String = "", HospID As %String = "")
{
	q:ARCOSRowId="" ""
	
	s (Index,Amount,ARCOSPrice,Count,ItemPriceFlag) = 0
	f  s Index = $o(^ARCOS(ARCOSRowId,"DATE",1,"ITM",Index)) q:Index=""  d
	.s ARCIMRowId = $p($g(^ARCOS(ARCOSRowId,"DATE",1,"ITM",Index)),"^",1)
	.s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",ARCIMRowId,Type,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ARCIMRowId,HospID)
	.q:(HOSPshowFlag="N")
	.s UnitPrice = ##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(ARCIMRowId)
	.s Amount = Amount + UnitPrice
	.s Count=Count+1
	
	s priceSub=$o(^ARCOS(ARCOSRowId,"PRICE",0))
	i priceSub'="" d
	.s ARCOSPrice=+$p($g(^ARCOS(ARCOSRowId,"PRICE",priceSub)),"^",4)
	.s ARCOSPriceType=$p($g(^ARCOS(ARCOSRowId,"PRICE",priceSub)),"^",8)
	.s ItemPriceFlag=1
	.s:ARCOSPriceType="H" ItemPriceFlag=2
	e  d
	.s ARCOSPrice=Amount
	
	q "{""Amount"":"""_$fn(Amount,"",2)_""",""ARCOSPrice"":"""_$fn(ARCOSPrice,"",2)_""",""Count"":"""_Count_""",""ItemPriceFlag"":"""_ItemPriceFlag_"""}"
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 增加医嘱套的包装价格
/// Table：        ARC_OrdSetPrice
/// Input：        医嘱套ID    价格开始时间    价格截止时间    价格
/// Output：       
/// Return：       0 则更新成功   非0 则更新失败
/// Others：       w ##class(web.DHCPE.CT.OrderSets).UpdateARCOSPrice("1800","2018-01-01","2018-01-01")
ClassMethod UpdateARCOSPriceNew(ARCOSRowid As %String = "", DateFrom As %String = "", DateTo As %String = "", Price As %String = "", Hospital As %String = "", Amount As %String = "") As %String
{
	s $ZT="UpdARCOSPriceNewErr"
	q:ARCOSRowid="" "未获取到医嘱套ID"
	i DateFrom["-" s DateFrom=$zdh(DateFrom,3)
 	i DateFrom["/" s DateFrom=$zdh(DateFrom,4)
 	i DateTo["-" s DateTo=$zdh(DateTo,3)
 	i DateTo["/" s DateTo=$zdh(DateTo,4)
 	q:DateFrom>DateTo "开始时间大于截止时间"
	s DateTo=$replace(DateTo," ","")
	;s Tariff=73   // 征收方式
	
	s rtn=""
	TSTART
	s SQLCODE=0
	s DateSub=0
	f  s DateSub=$o(^ARCOS(ARCOSRowid,"DATE",DateSub)) q:((DateSub="")||(SQLCODE'=0))  d
	.s ItemSub=0
	.f  s ItemSub=$o(^ARCOS(ARCOSRowid,"DATE",DateSub,"ITM",ItemSub)) q:((ItemSub="")||(SQLCODE'=0))  d
	..s osItemId=ARCOSRowid_"||"_DateSub_"||"_ItemSub
	..&sql(DELETE FROM sqluser.ARC_OrdSetDateItemPrice WHERE PRICE_ParRef=:osItemId)
	..s:SQLCODE=100 SQLCODE=0
	..
	..;s PriceSub=0
	..;f  s PriceSub=$o(^ARCOS(ARCOSRowid,"DATE",DateSub,"ITM",ItemSub,"PRICE",PriceSub)) q:((PriceSub="")||(SQLCODE'=0))  d
	..;.s pdateTo=$p($g(^ARCOS(ARCOSRowid,"DATE",DateSub,"ITM",ItemSub,"PRICE",PriceSub)),"^",2)
	..;.q:((pdateTo'="")&&(pdateTo<$h))
	..;.s osItemPriceId=ARCOSRowid_"||"_DateSub_"||"_ItemSub_"||"_PriceSub
	..;.s tDateTo=DateTo-1
	..;.&sql(UPDATE sqluser.ARC_OrdSetDateItemPrice SET PRICE_DateTo=:tDateTo WHERE PRICE_ParRef=:osItemPriceId)
	..;.s:SQLCODE=100 SQLCODE=0
	
	if (SQLCODE'=0) { 
        s rtn="更新套餐项目价格失败"
        goto UpdARCOSPriceNewErr
	}
		
	if (DateFrom="")&&(DateTo="")&&(Price="") {
		&sql(DELETE FROM sqluser.ARC_OrdSetPrice WHERE PRICE_ParRef=:ARCOSRowid)
		s:SQLCODE=100 SQLCODE=0
		if (SQLCODE'=0) { 
	        s rtn="还原套餐价格失败"
	        goto UpdARCOSPriceNewErr
		}
		
	} else {
		s Tariff=0
		f  s Tariff=$o(^ARC("TAR",Tariff)) q:(Tariff="")||($p($g(^ARC("TAR",Tariff)),"^",2)["体检")  d
		s:Tariff="" Tariff=$o(^ARC("TAR",0))
		b ;
		
		if $o(^ARCOS(ARCOSRowid,"PRICE",0))="" d
		.&sql(INSERT INTO sqluser.ARC_OrdSetPrice (PRICE_ParRef,PRICE_DateFrom,PRICE_Tariff_DR,PRICE_Price) VALUES (:ARCOSRowid,:DateFrom,:Tariff,:Price))
		e  d
		.&sql(UPDATE sqluser.ARC_OrdSetPrice SET PRICE_DateFrom=:DateFrom,PRICE_DateTo=null,PRICE_Tariff_DR=:Tariff,PRICE_Price=:Price WHERE PRICE_ParRef=:ARCOSRowid)
		s:SQLCODE=100 SQLCODE=0
		if (SQLCODE'=0) { 
	        s rtn="更新套餐价格失败"
	        goto UpdARCOSPriceNewErr
		}
	}
	d:SQLCODE=0 ..SetARCOSPriceNew(ARCOSRowid, Price)
	
	TCommit
	s rtn=SQLCODE
	q SQLCODE
UpdARCOSPriceNewErr
	s $ZT=""
	TROLLBACK
    q rtn_$ZE
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description：  更新医嘱套扩展表的价格
/// Table：        DHC_PE_OrdSetsEx
/// Input：        医嘱套ID     价格
/// Output：       
/// Return：       0 则更新成功   非0 则更新失败
/// Others：       w ##Class(web.DHCPE.CT.OrderSets).SetARCOSPrice("485","150")
ClassMethod SetARCOSPriceNew(ARCOSRowid As %String, Price As %String) As %String
{
	q:ARCOSRowid="" "-1"
	
	s OSEID=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowid,""))
	q:OSEID="" "-1"
	i Price="" {
		s OSAmt=..GetOrdSetsAmountNew(ARCOSRowid)
		s OSAmtObj={}.%FromJSON(OSAmt)
		s Price=OSAmtObj.Amount
	}
	&SQL(Update SQLUser.DHC_PE_OrdSetsEx Set OSE_Price=:Price Where OSE_RowId=:OSEID)
	q SQLCODE
}

/// Creator：      zhongricheng 
/// Description:： 修改医嘱套的包装价格
/// Others：       w ##class(web.DHCPE.CT.OrderSets).UpdateOSExPrice("1800")
ClassMethod UpdateOSExPriceNew(ARCOSRowid As %String = "") As %String
{
	q:ARCOSRowid=""
	
	d ..SetARCOSPriceNew(ARCOSRowid, "")
	
	s OSAmt=..GetOrdSetsAmountNew(ARCOSRowid)
	s OSAmtObj={}.%FromJSON(OSAmt)
	s Price=OSAmtObj.Amount

	q Price
}

/// 查询体检医嘱套明细的价格
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.OrderSets","SearchPEOSDetailPrice","944","1")
Query SearchPEOSDetailPrice(ARCOSRowid As %String, QueryFlag As %String, Type As %String = "", LocID As %String = "", HospID As %String = "") As websys.Query(CONTAINID = "", ROWSPEC = "ARCOSItemRowid:%String,ARCIMRowid:%String,ARCIMDesc:%String,ARCOSItemQty:%String,ITMSerialNo:%String,NO:%String,ItmPrice:%String,ItemORPrice:%String") [ SqlProc ]
{
}

ClassMethod SearchPEOSDetailPriceExecute(ByRef qHandle As %Binary, ARCOSRowid As %String, QueryFlag As %String, Type As %String = "", LocID As %String = "", HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	
	if (ARCOSRowid="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	set rs=##class(%ResultSet).%New("web.DHCARCOrdSets:FindOSItem")
	set sc=rs.Execute(ARCOSRowid, QueryFlag)
	If $$$ISERR(sc) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	while rs.%Next() {
		s ARCIMRowid=rs.GetDataByName("ARCIMRowid")
		;s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",ARCIMRowid,Type,LocID)
    	;continue:DateShowFlag="Y"
    	;s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ARCIMRowid,HospID)
		;continue:HOSPshowFlag="N"
		
		s ARCOSItemRowid=rs.GetDataByName("ARCOSItemRowid")
		s ARCIMDesc=rs.GetDataByName("ARCIMDesc")
		s ARCOSItemQty=rs.GetDataByName("ARCOSItemQty")
		s ITMSerialNo=rs.GetDataByName("ITMSerialNo")
		s NO=rs.GetDataByName("NO")
		
		s ARCOSRowId=$p(ARCOSItemRowid,"||",1)
		s DateSub=$p(ARCOSItemRowid,"||",2)
		s ItemSub=$p(ARCOSItemRowid,"||",3)
		
		s CurDate=+$h
		s ItmPrice=##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(ARCIMRowid)  //,CurDate,"","","","","","","","",LocID)
		s ItemORPrice=ItmPrice
		s priceJsonStr=..GetOSItemPrice(ARCOSItemRowid, CurDate)
		i priceJsonStr'="" {
			s priceJson={}.%FromJSON(priceJsonStr)
			s ItmPrice=priceJson.price
		}
		
		d outPEOSDetailPrice
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outPEOSDetailPrice
	set Data=$lb(ARCOSItemRowid,ARCIMRowid,ARCIMDesc,ARCOSItemQty,ITMSerialNo,NO,ItmPrice,$fn(ItemORPrice,"",2))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 
/// w ##class(web.DHCPE.CT.OrderSets).HandleItemPrice("434||1||1", "3", 152, 2)
ClassMethod HandleItemPrice(InString, Type, LocID As %String = "", HospID As %String = "")
{
	s $ZT="HandleItemPriceErr"
	q:InString="" ""
	s ret=""
	TSTART
	s osPrice=0,osRowid=""
	f i=1:1:$l(InString,"@") {
		s oneString=$p(InString,"@",i)
		continue:oneString=""
		s ItemRowId=$p(oneString,"^",1)
		s ItemPrice=$p(oneString,"^",2)
		s ret=..UpdPEOSDetailPrice(ItemRowId,ItemPrice,LocID,HospID)
		i +ret'=0 {
			s ret=$p(ret,"^",2)
			goto HandleItemPriceErr
		}
		s osRowid=+ItemRowId
		s osPrice=osPrice+ItemPrice
	}
	if osPrice<0 {
	}
	if osRowid="" {
		s ret="未获取到套餐，无法更新!"
		goto HandleItemPriceErr
	}
	s osType=""
	s:Type="Items" osType="H"
	s Tariff=0
	f  s Tariff=$o(^ARC("TAR",Tariff)) q:(Tariff="")||($p($g(^ARC("TAR",Tariff)),"^",2)["体检")  d
	s:Tariff="" Tariff=$o(^ARC("TAR",0))
	b ;
	s CurDate=+$h
	if $o(^ARCOS(osRowid,"PRICE",0))="" d
	.&sql(INSERT INTO sqluser.ARC_OrdSetPrice (PRICE_ParRef,PRICE_DateFrom,PRICE_Tariff_DR,PRICE_Price,PRICE_EpisodeType) VALUES (:osRowid,:CurDate,:Tariff,:osPrice,:osType))
	e  d
	.&sql(UPDATE sqluser.ARC_OrdSetPrice SET PRICE_DateFrom=:CurDate,PRICE_DateTo=null,PRICE_Tariff_DR=:Tariff,PRICE_Price=:osPrice,PRICE_EpisodeType=:osType WHERE PRICE_ParRef=:osRowid)
	s:SQLCODE=100 SQLCODE=0
	if (SQLCODE'=0) { 
        s ret="更新套餐价格失败"
        goto HandleItemPriceErr
	}
	d:SQLCODE=0 ..SetARCOSPriceNew(osRowid, osPrice)
	
	TCommit
	q 0
HandleItemPriceErr
	s $ZT=""
	TROLLBACK
    q ret_$ZE
}

/// 按原价更新项目的价格
/// w ##class(web.DHCPE.CT.OrderSets).UpdPEOnePrice("ADD", "434||1||1", 152, 2)
ClassMethod UpdPEOnePrice(Type As %String, ItemRowId As %String, LocID As %String = "", HospID As %String = "")
{
	s $ZT="UpdPEOnePriceErr"
	s ret=""
	q:ItemRowId="" "0"
	q:Type="" "0"
	s ARCOSRowId=$p(ItemRowId,"||",1)
	s DateSub=$p(ItemRowId,"||",2)
	s ItemSub=$p(ItemRowId,"||",3)
	
	s id=$o(^ARCOS(ARCOSRowId,"PRICE",0))
	q:id="" "0"
	
	s flag=0
	s jsonStr=..GetOrdSetsAmountNew(ARCOSRowId)
	q:jsonStr="" "0"
	s json={}.%FromJSON(jsonStr)
	s flag=json.ItemPriceFlag
	
	
	TSTART
	if (Type="ADD") {
		i '$d(^ARCOS(ARCOSRowId,"DATE",DateSub,"ITM",ItemSub)) { 
	        goto UpdPEOnePriceErr
		}
		s ARCIMRowId = $p($g(^ARCOS(ARCOSRowId,"DATE",DateSub,"ITM",ItemSub)),"^",1)
		s UnitPrice = ##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(ARCIMRowId)
		s ret=..UpdPEOSDetailPrice(ItemRowId, UnitPrice, LocID, HospID)
		if (+ret'=0) { 
	        goto UpdPEOnePriceErr
		}
	}
	s osType=""
	s osType="H"
	s Tariff=0
	f  s Tariff=$o(^ARC("TAR",Tariff)) q:(Tariff="")||($p($g(^ARC("TAR",Tariff)),"^",2)["体检")  d
	s:Tariff="" Tariff=$o(^ARC("TAR",0))
	
	
	s (Index,osPrice) = 0
	f  s Index = $o(^ARCOS(ARCOSRowId,"DATE",1,"ITM",Index)) q:Index=""  d
	.i flag=1 d
	..s ARCIMRowId = $p($g(^ARCOS(ARCOSRowId,"DATE",1,"ITM",Index)),"^",1)
	..s UnitPrice = ##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(ARCIMRowId)
	..s osPrice=osPrice+UnitPrice
	.e  d
	..s tpriceJson=..GetOSItemPrice(ARCOSRowId_"||1||"_Index)
	..q:tpriceJson=""
	..s tprice={}.%FromJSON(tpriceJson)
	..s osPrice=osPrice+tprice.price
	
	s CurDate=+$h
	if $o(^ARCOS(ARCOSRowId,"PRICE",0))="" d
	.&sql(INSERT INTO sqluser.ARC_OrdSetPrice (PRICE_ParRef,PRICE_DateFrom,PRICE_Tariff_DR,PRICE_Price,PRICE_EpisodeType) VALUES (:ARCOSRowId,:CurDate,:Tariff,:osPrice,:osType))
	e  d
	.&sql(UPDATE sqluser.ARC_OrdSetPrice SET PRICE_DateFrom=:CurDate,PRICE_DateTo=null,PRICE_Tariff_DR=:Tariff,PRICE_Price=:osPrice,PRICE_EpisodeType=:osType WHERE PRICE_ParRef=:ARCOSRowId)
	s:SQLCODE=100 SQLCODE=0
	if (SQLCODE'=0) { 
        s ret="更新套餐价格失败"
        goto UpdPEOnePriceErr
	}
	d:SQLCODE=0 ..SetARCOSPriceNew(ARCOSRowId, osPrice)
	
	TCommit
	q 0
UpdPEOnePriceErr
	s $ZT=""
	TROLLBACK
    q ret_$ZE
}

/// 保存套餐中项目的价格
/// w ##class(web.DHCPE.CT.OrderSets).UpdPEOSDetailPrice("434||1||1", "3", 152, 2)
ClassMethod UpdPEOSDetailPrice(ARCOSItemRowId As %String, ItemPrice As %Float, LocID As %String = "", HospID As %String = "")
{
	s ret=""
	q:ARCOSItemRowId="" ""
	q:$num(ItemPrice)="" ""
	s ARCOSRowId=$p(ARCOSItemRowId,"||",1)
	s DateSub=$p(ARCOSItemRowId,"||",2)
	s ItemSub=$p(ARCOSItemRowId,"||",3)
	q:'$d(^ARCOS(ARCOSRowId,"DATE",DateSub,"ITM",ItemSub)) ""
	
	s PriceSub=""
	s CurDate=+$h
	s priceJsonStr=..GetOSItemPrice(ARCOSItemRowId, CurDate)
	i priceJsonStr'="" {
		s priceJson={}.%FromJSON(priceJsonStr)
		s PriceSub=priceJson.rowid
	}
	
	// 即改即时生效
	if PriceSub'="" {
		&SQL(UPDATE SQLUser.ARC_OrdSetDateItemPrice SET PRICE_Price=:ItemPrice WHERE PRICE_RowId=:PriceSub)
	} else {
		&SQL(INSERT INTO SQLUSER.ARC_OrdSetDateItemPrice (PRICE_ParRef, PRICE_DateFrom, PRICE_Price, PRICE_Hodpital_DR, PRICE_EpisodeType) VALUES (:ARCOSItemRowId, :CurDate, :ItemPrice, :HospID, 'H'))
	}
	s:SQLCODE=100 SQLCODE=0
	if (SQLCODE'=0) { 
        q "-1^保存失败"
	}
	
	
	/*
	// 更新多条记录 可用于延时生效
	
	&SQL(INSERT INTO SQLUSER.ARC_OrdSetDateItemPrice (PRICE_ParRef, PRICE_DateFrom, PRICE_Price, PRICE_Hodpital_DR, PRICE_EpisodeType) VALUES (:ARCOSItemRowId, :CurDate, :ItemPrice, :HospID, 'H'))
	s:SQLCODE=100 SQLCODE=0
	
	If (SQLCODE'=0) { 
        q "-1^保存失败"
	}else{
		if PriceSub'="" {
			s OldRowid=ARCOSItemRowId_"||"_PriceSub
			&SQL(UPDATE SQLUser.ARC_OrdSetDateItemPrice SET PRICE_DateTo=:CurDate WHERE PRICE_RowId=:OldRowid)
			s:SQLCODE=100 SQLCODE=0
			If (SQLCODE'=0) {
				q "-1^保存失败"
			}
		}
   	}
	*/
	
    s ret="0^保存成功"
    q ret
}

/// 获取套餐内项目价格
/// w ##class(web.DHCPE.CT.OrderSets).GetOSItemPrice("434||1||1", +$h)
ClassMethod GetOSItemPrice(ARCOSItemRowId, CurDate = "")
{
	q:ARCOSItemRowId="" ""
	s ARCOSRowId=$p(ARCOSItemRowId,"||",1)
	s DateSub=$p(ARCOSItemRowId,"||",2)
	s ItemSub=$p(ARCOSItemRowId,"||",3)
	q:'$d(^ARCOS(ARCOSRowId,"DATE",DateSub,"ITM",ItemSub)) ""
	
	s PriceSub=$o(^ARCOS(ARCOSRowId,"DATE",DateSub,"ITM",ItemSub,"PRICE",""),-1)
	q:PriceSub="" ""
	q:PriceSub=0 ""
	
	s:CurDate="" CurDate=+$h
	s DateFrom=$p($g(^ARCOS(ARCOSRowId,"DATE",DateSub,"ITM",ItemSub,"PRICE",PriceSub)),"^",1)
	s DateTo=$p($g(^ARCOS(ARCOSRowId,"DATE",DateSub,"ITM",ItemSub,"PRICE",PriceSub)),"^",2)
	q:DateFrom="" ""
	q:DateFrom>CurDate ""
	q:((DateTo'="")&&(DateTo<CurDate)) ""
	
	s json={}
	s price=$p($g(^ARCOS(ARCOSRowId,"DATE",DateSub,"ITM",ItemSub,"PRICE",PriceSub)),"^",4)
	s json."price"=price
	s json."rowid"=ARCOSItemRowId_"||"_PriceSub
	q json.%ToJSON()
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 判断医嘱套是否有包装价格
/// Table：        ARC_OrdSetPrice
/// Input：        医嘱套ID
/// Output：       
/// Return：       -1 无该套餐  0 无定价   1 套餐定价   2 项目定价
/// Others：       w ##class(web.DHCPE.CT.OrderSets).IsHaveAmount("1806")
ClassMethod IsHaveAmountNew(ARCOSRowid As %String = "", Type As %String = "", LocID As %String = "", HospID As %String = "") As %String
{
	q:ARCOSRowid="" "-1"
	
	s OSEID=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowid,""))
	q:OSEID="" "-1"
	
	s flag="1"
	s id=$o(^ARCOS(ARCOSRowid,"PRICE",0))
	s:id="" flag="0"
	
	s jsonStr=..GetOrdSetsAmountNew(ARCOSRowid, Type, LocID, HospID)
	q:jsonStr="" 0
	s json={}.%FromJSON(jsonStr)
	q json.ItemPriceFlag
	
	q flag
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 修改医嘱套权限时 判断其中是否有原权限的项目 有则提示
/// Table：        
/// Input：        医嘱套ID  权限（性别^VIP）
/// Output：       
/// Return：       0 不用判断  1 有项目设置权限
/// Others：       w ##class(web.DHCPE.CT.OrderSets).IsCanUpdateOS("1806")
ClassMethod IsCanUpdateOS(ARCOSRowid As %String = "", UpdData As %String = "", LocID As %String = "", HospID As %String = "") As %String
{
	q:ARCOSRowid="" "{""code"":""0"",""msg"":""""}"
	
    s OSExSex=$p(UpdData,"^",1)
    s OSExVIPLevel=$p(UpdData,"^",2)

	s flag="0", msg=""
	s ItmSub=0
	f  s ItmSub = $o(^ARCOS(ARCOSRowid,"DATE",1,"ITM",ItmSub)) q:ItmSub=""  d
	.s ItmRowId=$p($g(^ARCOS(ARCOSRowid,"DATE",1,"ITM",ItmSub)), "^", 1)
	.s ItmDesc=$p($g(^ARCIM(+ItmRowId,$p(ItmRowId,"||",2),1)),"^",2)
	.s OrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItmRowId,LocID)
    .q:OrderID=""  // 站点项目组合没对照
	.s ID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,OrderID,0))
    .q:ID=""  // 站点项目组合科室项目详情没维护
	.
	.s ItemSex=""
    .s ItemSexDR=$lg($g(^CF.PE.StationOrderSetD(ID)),9) //性别
	.s:ItemSexDR'="" ItemSex=$p($g(^CT("SEX",ItemSexDR)),"^",2)
	.
	.//项目中包含性别
	.i ((ItemSexDR'="")&&("男/女"[ItemSex)) d
	..i ((OSExSex'="")&&(OSExSex'=ItemSexDR)) d
	...s flag="1"
	...s msg=msg_"套餐中存在"_ItemSex_"性项目("_ItmDesc_")，与修改的套餐性别不一致！"
	..e  i OSExSex="" d
	...s flag="1"
	...s msg=msg_"套餐中存在"_ItemSex_"性项目("_ItmDesc_")，套餐性别不能修改为空！"
	.
	.s ItemVIPLevel=$lg($g(^CF.PE.StationOrderSetD(ID)),13) //vip等级
	.i ((OSExVIPLevel'="")&&(ItemVIPLevel'="")&&((","_OSExVIPLevel_",")'[(","_ItemVIPLevel_","))) d
	..s flag="1"
	..s msg=msg_ItmDesc_"对应的VIP等级与修改的套餐VIP等级不一致！"
	
	q "{""code"":"""_flag_""",""msg"":"""_msg_"""}"
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 更新套餐扩展  空数据不更新
/// Table：        DHC_PE_OrdSetsEx
/// Input：        医嘱套ID  权限（性别^VIP）
/// Output：       
/// Return：       0 成功   非0 失败
/// Others：       w ##class(web.DHCPE.CT.OrderSets).UpdateOSData("1806")
ClassMethod UpdateOSData(ARCOSRowid, Data = "")
{
	q:ARCOSRowid="" -1
	q:$tr(Data,"^","")="" 0

	s OSEID=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowid,""))
	//q:OSEID="" "-1"
    s OSExSex=$p(Data,"^",1)
    s OSExVIPLevel=$p(Data,"^",2)

	k PLIST
	s:OSExSex'="" PLIST(4)=OSExSex
	s:OSExVIPLevel'="" PLIST(7)=OSExVIPLevel
	
	s SQLCODE=0
	if $d(PLIST) {
		if OSEID'="" {
			&sql(Update SQLUser.DHC_PE_OrdSetsEx values :PLIST() where OSE_RowId=:OSEID)
		} else {
			s PLIST(2)=ARCOSRowid
			&SQL(Insert into SQLUser.DHC_PE_OrdSetsEx values :PLIST())
		}
		s:SQLCODE=100 SQLCODE=0
	}
	q SQLCODE
}

}
