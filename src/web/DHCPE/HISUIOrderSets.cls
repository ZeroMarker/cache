/// web.DHCPE.HISUIOrderSets
/// create by zhongricheng
/// 体检医嘱套（HISUI）
Class web.DHCPE.HISUIOrderSets Extends %RegisteredObject
{

/// 获取体检医嘱套 医嘱子类ID 若无体检医嘱套 则获取医嘱套 的医嘱子类ID  返回医嘱子类详情^医嘱子类ID^医嘱大类ID
/// w ##class(web.DHCPE.HISUIOrderSets).GetARCItemCatID()
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
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUIOrderSets","SearchVIPLevel")
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
/// w ##class(web.DHCPE.HISUIOrderSets).GetARCOSData(1836)
ClassMethod GetARCOSData(ARCOSRowid As %String = "")
{
	s Break="",BreakDesc="",Sex="",SexDesc="",Price="",Deit="",DeitDesc="",VIPLevel="",VIPDesc="",LocId="",LocDesc="",PGBId="",PGDesc="",BDate="",EDate=""
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
	s PGBId=$p(OSExData,"^",10)
	
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
	..s VIP=$p($g(^DHCPEVIPLevel("VIP",$p(VIPLevel,",",i))),"^",2)
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
	
	// 可用团体
	i PGBId'="" d
	.s PGDesc=$p($g(^DHCPEPreGBI(PGBId)),"^",2)
	
	q "{""FavHospDr"":"""_FavHospDr_""",""FavUserHospDr"":"""_FavUserHospDr_""",""Break"":"""_Break_""",""BreakDesc"":"""_BreakDesc_""",""Sex"":"""_Sex_""",""SexDesc"":"""_SexDesc_""",""Price"":"""_$fn(Price,"",2)_""",""Deit"":"""_Deit_""",""DeitDesc"":"""_DeitDesc_""",""VIPLevel"":"""_VIPLevel_""",""VIPDesc"":"""_VIPDesc_""",""LocId"":"""_LocId_""",""LocDesc"":"""_LocDesc_""",""PGBId"":"""_PGBId_""",""PGDesc"":"""_PGDesc_"""}"
OSExError
	q "{""FavHospDr"":"""_FavHospDr_""",""FavUserHospDr"":"""_FavUserHospDr_""",""Break"":"""_Break_""",""BreakDesc"":"""_BreakDesc_""",""Sex"":"""_Sex_""",""SexDesc"":"""_SexDesc_""",""Price"":"""_$fn(Price,"",2)_""",""Deit"":"""_Deit_""",""DeitDesc"":"""_DeitDesc_""",""VIPLevel"":"""_VIPLevel_""",""VIPDesc"":"""_VIPDesc_""",""LocId"":"""_LocId_""",""LocDesc"":"""_LocDesc_""",""PGBId"":"""_PGBId_""",""PGDesc"":"""_PGDesc_"""}"
}

/// 查询体检医嘱套
/// 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUIOrderSets","SearchPEOrderSets","1","480","2")
Query SearchPEOrderSets(UserID As %Library.String = "", subCatID As %Library.String = "", Conditiones As %Library.String = "", Code As %Library.String = "", Desc As %Library.String = "", Alias As %Library.String = "", HospID As %Library.String = "") As websys.Query(ROWSPEC = "ARCOSRowid:%String,ARCOSCode:%String,ARCOSDesc:%String,ARCOSOrdCat:%String,ARCOSOrdSubCat:%String,ARCOSEffDateFrom:%String,ARCOSOrdCatDR:%String,ARCOSOrdSubCatDR:%String,FavRowid:%String,ARCOSAlias:%String,FavUserDesc:%String,FavDepDesc:%String,FavUserDr:%String,FavDepDr:%String,MedUnit:%String,MedUnitDesc:%String,OrdSetPrice:%String,OSExBreak:%String,BreakDesc:%String,OSExSex:%String,SexDesc:%String,OSExPrice:%String,OSExDeit:%String,DeitDesc:%String,OSExVIPLevel:%String,VIPDesc:%String,OSExLoc:%String,LocDesc:%String,OSExPGBId:%String,PGDesc:%String,_parentId:%String,FavHospDr:%String,FavUserHospDr:%String,AddUser:%String") [ SqlProc ]
{
}

ClassMethod SearchPEOrderSetsExecute(ByRef qHandle As %Binary, UserID As %Library.String = "", subCatID As %Library.String = "", Conditiones As %Library.String = "", Code As %Library.String = "", Desc As %Library.String = "", Alias As %Library.String = "", HospID As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	K ^tempdhcpe("SearchPEOrderSets")
	s ^tempdhcpe("SearchPEOrderSets")=$lb(UserID,subCatID,Conditiones,Code,Desc,Alias,HospID)

	i UserID="" {
		s:$d(%session) UserID=%session.Get("LOGON.USERID")
		s:'$d(%session) UserID=1149
	}
	i subCatID="" {
		s subCatIDStr=##class(web.DHCPE.HISUIOrderSets).GetARCItemCatID()
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
	set rs=##class(%ResultSet).%New("web.DHCPE.HISUIOrderSets:QueryPGBI")
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
	set sc=rs.Execute(UserID, "", "", "", "", Conditiones, "", subCatID, Code, Desc, Alias,HospID)
	If $$$ISERR(sc) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	while rs.%Next() {
		
		d SetDefValue
		
		// ARCOSRowid,ARCOSCode,ARCOSDesc,ARCOSOrdCat,ARCOSOrdSubCat
		s ARCOSRowid=rs.GetDataByName("ARCOSRowid")
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

		s OSExData=..GetARCOSData(ARCOSRowid)
		//q:'$d(^DHCPEOSE(0,"OrdSets",ARCOSRowid))		
		continue:'$d(^DHCPEOSE(0,"OrdSets",ARCOSRowid))
		s OSExObj={}.%FromJSON(OSExData)
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
		s Loc=OSExObj.Loc
		s LocDesc=OSExObj.LocDesc
		s PGBI=OSExObj.PGBId
		s PGDesc=OSExObj.PGDesc
		
		s FavHospDr=OSExObj.FavHospDr
		s FavUserHospDr=OSExObj.FavUserHospDr

		
		s:PGBI'="" pId="PGBId"_PGBI
		s:PGBI="" pId="PGBIdUN"
		d outOrdSetInfo
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

SetDefValue
	s (ARCOSRowid,ARCOSCode,ARCOSDesc,ARCOSOrdCat,ARCOSOrdSubCat,ARCOSEffDateFrom,ARCOSOrdCatDR,ARCOSOrdSubCatDR,AddUser)=""
	s (FavRowid,ARCOSAlias,FavUserDesc,FavDepDesc,FavUserDr,FavDepDr,MedUnit,MedUnitDesc,OrdSetPrice,FavHospDr,FavUserHospDr)=""
	s (Break,BreakDesc,Sex,SexDesc,Price,Deit,DeitDesc,VIPLevel,VIPDesc,Loc,LocDesc,PGBI,PGDesc,pId)=""
	
	q
outOrdSetInfo
	set Data=$lb(ARCOSRowid,ARCOSCode,ARCOSDesc,ARCOSOrdCat,ARCOSOrdSubCat,ARCOSEffDateFrom,ARCOSOrdCatDR,ARCOSOrdSubCatDR,FavRowid,ARCOSAlias,FavUserDesc,FavDepDesc,FavUserDr,FavDepDr,MedUnit,MedUnitDesc,OrdSetPrice,Break,BreakDesc,Sex,SexDesc,Price,Deit,DeitDesc,VIPLevel,VIPDesc,Loc,LocDesc,PGBI,PGDesc,pId,FavHospDr,FavUserHospDr,AddUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 查询可复制的医嘱套
/// 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUIOrderSets","SearchPECanCopyOS")
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
	.s LocId=OSExObj.LocId
	.s LocDesc=OSExObj.LocDesc
	.s Price=OSExObj.Price_"元"
	.s FavHospDr=OSExObj.FavHospDr
	.s FavUserHospDr=OSExObj.FavUserHospDr
	.d outCopyOSInfo
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outCopyOSInfo
	set Data=$lb(OSId,OSCode,OSDesc,OSSex,SexDesc,VIPLevel,VIPDesc,LocId,LocDesc,Price,FavRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 查询体检医嘱套明细
/// 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUIOrderSets","SearchPEOrderSetsDetail","480","1")
Query SearchPEOrderSetsDetail(ARCOSRowid As %String, QueryFlag As %String, Type As %String = "", LocID As %String = "", hospId As %String = "") As websys.Query(CONTAINID = "", ROWSPEC = "ARCIMDesc:%String,ARCOSItemQty:%String,ARCOSItemBillUOM:%String,ARCOSItemDoseQty:%String,ARCOSItemUOM:%String,ARCOSItemFrequence:%String,ARCOSItemDuration:%String,ARCOSItemInstruction:%String,ARCOSItemRowid:%String,ARCIMRowid:%String,ARCOSItemUOMDR:%String,ARCOSItemFrequenceDR:%String,ARCOSItemDurationDR:%String,ARCOSItemInstructionDR:%String,ARCOSItemCatDR:%String,ARCOSItemSubCatDR:%String,ARCOSItemOrderType:%String,ARCOSItmLinkDoctor:%String,Tremark:%String,ARCOSDHCDocOrderType:%String,ARCOSDHCDocOrderTypeDR:%String,SampleID:%String,SampleDesc:%String,ITMSerialNo:%String,NO:%String,OrderPriorRemarksDR:%String,OrderPriorRemarks:%String,DHCDocOrdRecLoc:%String") [ SqlProc ]
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
		
		d outOrdSetDetailInfo
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

SetDefValue1
	s (ARCIMDesc,ARCOSItemQty,ARCOSItemBillUOM,ARCOSItemDoseQty,ARCOSItemUOM,ARCOSItemFrequence,ARCOSItemDuration,ARCOSItemInstruction,ARCOSItemRowid,ARCIMRowid)=""
	s (ARCOSItemUOMDR,ARCOSItemFrequenceDR,ARCOSItemDurationDR,ARCOSItemInstructionDR,ARCOSItemCatDR,ARCOSItemSubCatDR,ARCOSItemOrderType,ARCOSItmLinkDoctor,Tremark,ARCOSDHCDocOrderType)=""
	s (ARCOSDHCDocOrderTypeDR,SampleID,SampleDesc,ITMSerialNo,NO,OrderPriorRemarksDR,OrderPriorRemarks,DHCDocOrdRecLoc)=""
	
	q
outOrdSetDetailInfo
	set Data=$lb(ARCIMDesc,ARCOSItemQty,ARCOSItemBillUOM,ARCOSItemDoseQty,ARCOSItemUOM,ARCOSItemFrequence,ARCOSItemDuration,ARCOSItemInstruction,ARCOSItemRowid,ARCIMRowid,ARCOSItemUOMDR,ARCOSItemFrequenceDR,ARCOSItemDurationDR,ARCOSItemInstructionDR,ARCOSItemCatDR,ARCOSItemSubCatDR,ARCOSItemOrderType,ARCOSItmLinkDoctor,Tremark,ARCOSDHCDocOrderType,ARCOSDHCDocOrderTypeDR,SampleID,SampleDesc,ITMSerialNo,NO,OrderPriorRemarksDR,OrderPriorRemarks,DHCDocOrdRecLoc)
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
/// Others：       d ##Class(web.DHCPE.HISUIOrderSets).InsertUserARCOS("","qweqweqwe","112233","13","210","","qwe","000150","","")
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
	..d ..SetARCOSEx(ARCOSRowid,VIPLevel,Break,SexDr,Deit,PGBId)
	.
	q err
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 更新医嘱套扩展信息   VIP等级  是否可拆分  对应性别  价格
/// Table：        DHC_PE_OrdSetsEx
/// Input：        医嘱套ID   VIP等级  是否可拆分  对应性别  价格
/// Output：       
/// Return：       0 则更新成功   非0 则更新失败
/// Others：       w ##Class(web.DHCPE.HISUIOrderSets).SetARCOSEx("485","2,3","Y","1","")
ClassMethod SetARCOSEx(ARCOSRowid As %String, VIPLevel As %String, Break As %String, SexDr As %String, Deit As %String, PBGId As %String) As %String
{
	q:ARCOSRowid="" "-1"
	s OSEID=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowid,""))
	if OSEID="" d
	.&SQL(Insert Into SQLUser.DHC_PE_OrdSetsEx (OSE_OrdSets_DR,OSE_Break,OSE_Sex_DR,OSE_Deit,OSE_VIPlevel,OSE_PGBase_DR) Values(:ARCOSRowid,:Break,:SexDr,:Deit,:VIPLevel,:PBGId))
	else  d
	.&SQL(Update SQLUser.DHC_PE_OrdSetsEx Set OSE_Break=:Break,OSE_Sex_DR=:SexDr,OSE_Deit=:Deit,OSE_VIPlevel=:VIPLevel,OSE_PGBase_DR=:PBGId Where OSE_RowId=:OSEID)
	
	q SQLCODE
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 删除医嘱套
/// Table：        
/// Input：        医嘱套ID
/// Output：       
/// Return：       0 则删除成功   非0 则删除失败
/// Others：       w ##Class(web.DHCPE.HISUIOrderSets).DeleteUserARCOS()
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
/// Others：       w ##Class(web.DHCPE.HISUIOrderSets).DelARCOSEx("485")
ClassMethod DelARCOSEx(ARCOSRowid As %String)
{
	q:ARCOSRowid="" "-1"
	s OSEID=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowid,""))
	q:OSEID="" "-1"
	
	&sql(Delete From SQLUser.DHC_PE_OrdSetsEx Where OSE_RowId=:OSEID)

	q SQLCODE
}

/// 获取默认客户等级ID
/// w ##class(web.DHCPE.HISUIOrderSets).GetDefVIP()
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
/// w ##class(web.DHCPE.HISUIOrderSets).UpdateUserARCOS()
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
	.s err=..SetARCOSEx(ARCOSRowid,VIPLevel,Break,SexDr,Deit,PGBId)

	q err
}

/// 批量增加套餐明细
/// w ##class(web.DHCPE.HISUIOrderSets).BatchUpdateUserARCOS()
ClassMethod BatchUpdateUserARCOS(ARCOSRowid, ArcimInfo)
{
	s flag=0
	q:((ARCOSRowid="")||(ArcimInfo="")) flag
	
	for iOSItem=1:1:$l(ArcimInfo,"^") {
		s OSItemId=$p(ArcimInfo,"^",iOSItem)
		continue:OSItemId=""
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
		s flag=1
	}
	q flag
}

/// 获取检验项目对应的默认标本 调用医生站方法 w ##class(web.DHCDocOrderCommon).GetLabSpec("2521||1")
/// w ##class(web.DHCPE.HISUIOrderSets).GetDefLabSpecId("4716||1")
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
/// w ##class(web.DHCPE.HISUIOrderSets).GetItemLocIdAndUOMId("4716||1")
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
/// w ##class(web.DHCPE.HISUIOrderSets).IsHaveItemInOrdSets(4188,"2521||1")
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
/// Return：       0 则更新成功   非0 则更新失败
/// Others：       w ##class(web.DHCPE.HISUIOrderSets).UpdateARCOSPrice("1800","2018-01-01","2018-01-01")
ClassMethod UpdateARCOSPrice(ARCOSRowid As %String = "", DateFrom As %String = "", DateTo As %String = "", Price As %String = "", Hospital As %String = "", Amount As %String = "") As %String
{
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
/// w ##class(web.DHCPE.HISUIOrderSets).GetOrdSetsAmount("1890")
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
/// Others：       w ##Class(web.DHCPE.HISUIOrderSets).SetARCOSPrice("485","150")
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
/// Others：       w ##class(web.DHCPE.HISUIOrderSets).UpdateOSExPrice("1800")
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
/// Others：       w ##class(web.DHCPE.HISUIOrderSets).IsHaveAmount("1806")
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

/// 医嘱套对应的使用科室
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUIOrderSets","OrdSetsLocs",1810)
Query OrdSetsLocs(ARCOSRowId As %String) As websys.Query(ROWSPEC = "LocDesc:%String,LocId:%String")
{
}

ClassMethod OrdSetsLocsExecute(ByRef qHandle As %Binary, ARCOSRowId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	if (ARCOSRowId="") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
	s OSEID=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowId,""))
	if (OSEID="") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
	
	s LocStr=$p($g(^DHCPEOSE(OSEID)),"^",7)
	s len=$l(LocStr,",")
	f i=1:1:len d
	.q:$p(LocStr,",",i)=""
	.s LocId=$p(LocStr,",",i)
    .s LocDesc=$p(^CTLOC(LocId),"^",2)
    .s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
 	.d SearchOut
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchOut      
	set Data=$lb(LocDesc,LocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

/// 查询科室
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUIOrderSets","QueryLoc","1","")
Query QueryLoc(LocText As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As websys.Query(ROWSPEC = "id:%String,code:%String,desc:%String") [ SqlProc ]
{
}

ClassMethod QueryLocExecute(ByRef qHandle As %Binary, LocText As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	i ""'=LocText  d 
 	.i LocText["-"  s LocText=$p(LocText,"-",1)   //add by zl 20100204
	.s LocText=$zcvt(LocText,"U")                                         //进行大小写转换
	.s idesc=$o(^CTLOC(0,"Desc",LocText),-1)  
	.f  s idesc=$o(^CTLOC(0,"Desc",idesc)) q:(idesc="")||(idesc'[LocText)  d     //从输入的别名开始对结点进行遍历
    ..s id=0
    ..f  s id=$o(^CTLOC(0,"Desc",desc,id)) q:id=""  d
	...s code=$p(^CTLOC(id),"^",1)
	...s desc=idesc
	...s:desc["-" desc=$p(desc,"-",2)
	...s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("CT_Loc",id,Type,LocID)
    ...q:DateShowFlag="Y"
	...s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("CT_Loc",id,hospId)
	...q:HOSPshowFlag="N"
	...d QueryOut
	
 	i ""=LocText  d 
	.s id=0
	.f  s id=$o(^CTLOC(id)) q:id=""  d
	..s code=$p(^CTLOC(id),"^",1)
	..s desc=$p(^CTLOC(id),"^",2)
	..s:desc["-" desc=$p(desc,"-",2)
	..s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("CT_Loc",id,Type,LocID)
    ..q:DateShowFlag="Y"
	..s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("CT_Loc",id,hospId)
	..q:HOSPshowFlag="N"
    ..d QueryOut
 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

QueryOut     
	set Data=$lb(id,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 更新医嘱套扩展表的可用科室
/// Table：        DHC_PE_OrdSetsEx
/// Input：        医嘱套ID     科室ID    flag 1 增加  0 删除
/// Output：       
/// Return：       0 则更新成功   非0 则更新失败
/// Others：       w ##Class(web.DHCPE.HISUIOrderSets).SetARCOSLocInfo("485","150")
ClassMethod SetARCOSLocInfo(ARCOSRowid As %String, LocId As %String, flag As %String) As %String
{
	q:((ARCOSRowid="")!(LocId="")!(flag="")) "-1^数据不能为空"	
	s OSEID=$o(^DHCPEOSE(0,"OrdSets",ARCOSRowid,""))
	q:OSEID="" "-1^请更新体检医嘱套"
	
	s LocStr=$p($g(^DHCPEOSE(OSEID)),"^",7)
	q:((LocStr'="")&&((","_LocStr_",")[(","_LocId_","))&&(flag=1)) "-1^已存在该科室"  // 已存在则不添加
	q:(((","_LocStr_",")'[(","_LocId_","))&&(flag=0)) "-1^已删除该科室"  // 不存在则不删除
	if flag=1 d
	.s:LocStr'="" LocStr=LocStr_","_LocId
	.s:LocStr="" LocStr=LocId
	e  i flag=0 d
	.s Temp=""
	.s len=$l(LocStr,",")
	.f i=1:1:len d
	..q:$p(LocStr,",",i)=""
	..i $p(LocStr,",",i)'=LocId d
	...s:Temp'="" Temp=Temp_","_$p(LocStr,",",i)
	...s:Temp="" Temp=$p(LocStr,",",i)
	.s LocStr=Temp
	
	&SQL(Update SQLUser.DHC_PE_OrdSetsEx Set OSE_Loc=:LocStr Where OSE_RowId=:OSEID)
	q SQLCODE
}

/// 查询团体
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUIOrderSets","QueryPGBI","")
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
/// w ##class(web.DHCPE.HISUIOrderSets).UpdateItemSerialNo("")
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
/// Others：       w ##Class(web.DHCPE.HISUIOrderSets).GetOSItemData("1858||1||7")
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
	.;s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",$c(32)_HospitalCode,""))
	.s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##class(web.DHCPE.DHCPECommon).LisIndexData(HospitalCode),""))
	.i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	.i $l(HospitalDR) d
	..;s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR," "_SampleID,""))
	..s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,##class(web.DHCPE.DHCPECommon).LisIndexData(SampleID),""))
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
/// Others：       d ##class(%ResultSet).RunQuery("web.DHCPE.HISUIOrderSets","OrdSetsDrugsInfo","ItemDoseUOM","","562||1")
Query OrdSetsDrugsInfo(CombName As %String = "", Desc As %String = "", ARCIMRowid As %String = "", PAADM As %String = "") As websys.Query(ROWSPEC = "Id:%String,Desc:%String")
{
}

ClassMethod OrdSetsDrugsInfoExecute(ByRef qHandle As %Binary, CombName As %String = "", Desc As %String = "", ARCIMRowid As %String = "", PAADM As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
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
		.d DrugsInfo
 	} elseif (CombName="ItemInstruction") {		// 用法  PHC_Instruc
		s id=0
		f  s id=$o(^PHCIN(id)) q:id=""  d
		.s data=$g(^PHCIN(id))
		.q:$p(data,"^",4)'="Y"
		.s code=$p(data,"^",1)
		.s desc=$p(data,"^",2)
		.q:((Desc'="")&&((("^"_code)'[("^"_Desc))||(("^"_desc)'[("^"_Desc))))
		.s desc2=$p(data,"^",3)
		.d DrugsInfo
 	} elseif (CombName="ItemDuration") {		// 疗程  PHC_Duration
	 	s id=0
		f  s id=$o(^PHCDU(id)) q:id=""  d
		.s data=$g(^PHCDU(id))
		.s DateFrom=$p(data,"^",5)
		.q:((DateFrom'="")&&(DateFrom>+$h))
		.s DateTo=$p(data,"^",6)
		.q:((DateTo'="")&&(DateTo<+$h))
		.s code=$p(data,"^",1)
		.s desc=$p(data,"^",3)
		.q:((Desc'="")&&(("^"_desc)'[("^"_Desc)))
		.d DrugsInfo
 	} elseif (CombName="Remark") {		// 备注信息
 		s Infos=$g(^DHCDocConfig("CNMedItemPhSpecInstr"))
 		f i=1:1:$l(Infos,"^") d
 		.s data=$p(Infos,"^",i)
 		.q:data=""
 		.s id=$p(data,$c(1),1)
 		.s desc=$p(data,$c(1),2)
		.q:((Desc'="")&&(("^"_desc)'[("^"_Desc)))
 		.d DrugsInfo
 	} elseif (CombName="PriorRemarks") {		// 附加说明  "ONE":"取药医嘱"  "OUT":"出院带药"  "PRN":"PRN"  "OM":"自备药"  "ZT":"嘱托"
 		s Infos="ONE"_$c(1)_"取药医嘱^OUT"_$c(1)_"出院带药^PRN"_$c(1)_"PRN^OM"_$c(1)_"自备药^ZT"_$c(1)_"嘱托"
 		f i=1:1:$l(Infos,"^") d
 		.s data=$p(Infos,"^",i)
 		.q:data=""
 		.s id=$p(data,$c(1),1)
 		.s desc=$p(data,$c(1),2)
		.q:((Desc'="")&&(("^"_desc)'[("^"_Desc)))
 		.d DrugsInfo
 	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DrugsInfo      
	set Data=$lb(id,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

/// Creator：      zhongricheng 
/// Description:： 获取医嘱相关信息
/// Others：       w ##Class(web.DHCPE.HISUIOrderSets).GetItemTypeAndDesc("1858||1")
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
/// Others：       w ##Class(web.DHCPE.HISUIOrderSets).UpdOSItemData()
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
/// dubug：w ##class(web.DHCPE.HISUIOrderSets).IsExcludeArcItem(4188,"2521||1")
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

}
