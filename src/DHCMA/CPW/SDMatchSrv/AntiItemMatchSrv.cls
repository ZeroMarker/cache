Class DHCMA.CPW.SDMatchSrv.AntiItemMatchSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:  别名检索医嘱项
/// Table:        SQLUSER.ARC_ItmMast
/// Input：       aAlias ：别名
/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.SDMatchSrv.AntiItemMatchSrv","QryArcimByAlias","tbtd","2!!1")
Query QryArcimByAlias(q As %String, aHospID As %String = "") As %Query(ROWSPEC = "ArcimID:%String,ArcimCode:%String,ArcimDesc:%String")
{
}

ClassMethod QryArcimByAliasExecute(ByRef qHandle As %Binary, q As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	Set aAlias = q
	
	Set IsLinkLabARCOS=##class(User.DHCMRCBaseConfig).GetValueByCode("IsLinkLabARCOS")
	
	s JIndex=$j,ZIndex=$zn
	
	//关联医嘱项
	k ^TMP(ZIndex,JIndex,"ARCItemMast")
	
	//医嘱别名查询医嘱项
	//^ARC("ALIAS",0,"Desc",$$ALPHAUP({ALIAS_Text})_" ",$$ALPHAUP({ALIAS_Desc}),{ALIAS_RowId},1)
	s aAlias=$$ALPHAUP^SSUTIL4(aAlias)
	s Alias=$o(^ARC("ALIAS",0,"Desc",aAlias),-1)
	f  s Alias=$o(^ARC("ALIAS",0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(aAlias))'=aAlias)  d
	.s ARCDesc=""
	.f  s ARCDesc=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc)) q:ARCDesc=""  d
	..s ARCRowid=0
	..f  s ARCRowid=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc,ARCRowid)) q:ARCRowid=""  d
	...q:'$d(^ARC("ALIAS",ARCRowid))
	...s ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
	...q:ARCType'="ARCIM"
	...s ARCAlias=$p(^ARC("ALIAS",ARCRowid),"^",6)
	...s ARCAlias=$$ALPHAUP^SSUTIL4(ARCAlias)
	...q:$e(ARCAlias,1,$l(aAlias))'=aAlias
	...s ARCItemID=$p(^ARC("ALIAS",ARCRowid),"^",1)
	...q:ARCItemID=""
	...q:$d(^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID))
	...d BuildDataToARCIM
	...s ^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID)=""
	
	//医嘱名称查询医嘱项
	//^ARCIM(0,"Desc",$$ALPHAUP({ARCIM_Desc}),{ARCIM_Subscript},{ARCIM_Version})
	Set aAlias = q
	s Alias=$o(^ARCIM(0,"Desc",aAlias),-1)
	f  s Alias=$o(^ARCIM(0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(aAlias))'=aAlias)  d
	.s ItemSub=0
	.f  s ItemSub=$o(^ARCIM(0,"Desc",Alias,ItemSub)) q:ItemSub=""  d
	..s ItemVer=0
	..f  s ItemVer=$o(^ARCIM(0,"Desc",Alias,ItemSub,ItemVer)) q:ItemVer=""  d
	...s ARCItemID=ItemSub_"||"_ItemVer
	...q:$d(^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID))
	...d BuildDataToARCIM
	...s ^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID)=""
	
	k ^TMP(ZIndex,JIndex,"ARCItemMast")
	
	//根据配置判断是否允许关联检验医嘱套
	//只有Medtrak程序才允许关联医嘱套(安贞、友谊、复兴等)
	If IsLinkLabARCOS="Y" {
		k ^TMP(ZIndex,JIndex,"ARCOrdSet")
		
		//医嘱套别名查询
		//^ARC("ALIAS",0,"Desc",$$ALPHAUP({ALIAS_Text})_" ",$$ALPHAUP({ALIAS_Desc}),{ALIAS_RowId},1)
		Set aAlias = q
		s aAlias=$$ALPHAUP^SSUTIL4(aAlias)
		s Alias=$o(^ARC("ALIAS",0,"Desc",aAlias),-1)
		f  s Alias=$o(^ARC("ALIAS",0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(aAlias))'=aAlias)  d
		.s ARCDesc=""
		.f  s ARCDesc=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc)) q:ARCDesc=""  d
		..s ARCRowid=0
		..f  s ARCRowid=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc,ARCRowid)) q:ARCRowid=""  d
		...q:'$d(^ARC("ALIAS",ARCRowid))
		...//s ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
		...//q:ARCType'="ARCIM"
		...s ARCAlias=$p(^ARC("ALIAS",ARCRowid),"^",6)
		...s ARCAlias=$$ALPHAUP^SSUTIL4(ARCAlias)
		...q:$e(ARCAlias,1,$l(aAlias))'=aAlias
		...s ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
		...q:ARCType'="ARCOS"
		...s ARCOrdSetID=$p(^ARC("ALIAS",ARCRowid),"^",2)
		...q:ARCOrdSetID=""
		...q:$d(^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID))
		...d BuildDataToARCOS
		...s ^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID)=""
		
		//医嘱套名称查询
		//^ARCOS(0,"Desc",$$ALPHAUP({ARCOS_Desc}),{ARCOS_RowId})
		Set aAlias = q
		s Alias=$o(^ARCOS(0,"Desc",aAlias),-1)
		f  s Alias=$o(^ARCOS(0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(aAlias))'=aAlias)  d
		.s ARCOrdSetID=0
		.f  s ARCOrdSetID=$o(^ARCOS(0,"Desc",Alias,ARCOrdSetID)) q:ARCOrdSetID=""  d
		..q:$d(^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID))
		..d BuildDataToARCOS
		..s ^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID)=""
		
		k ^TMP(ZIndex,JIndex,"ARCOrdSet")
	}
	
	Quit $$$OK
	
BuildDataToARCIM
	s ARCItemSub=$p(ARCItemID,"||",1)
	s ARCItemVer=$p(ARCItemID,"||",2)
	Set ExistFlg=##class(%Dictionary.CompiledClass).%OpenId("web.DHCBL.BDP.BDPMappingHOSP")
	If (ExistFlg'="") {
		s ShowFlg=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",ARCItemID,$p(aHospID,"!!",1),+$h)
		q:ShowFlg'="Y"
	}
	q:(ARCItemSub="")||(ARCItemVer="")
	s ARCItemCode=$p($g(^ARCIM(ARCItemSub,ARCItemVer,1)),"^",1)
	s ARCItemDesc=$p($g(^ARCIM(ARCItemSub,ARCItemVer,1)),"^",2)
	s ARCItemCode=$tr(ARCItemCode,$c(13),"")
	s ARCItemCode=$tr(ARCItemCode,$c(13),"")
	s ARCItemDesc=$tr(ARCItemDesc,$c(13),"")
	s ARCItemDesc=$tr(ARCItemDesc,$c(10),"")
	q:ARCItemDesc=""
	s OrderOnItsOwn=$p($g(^ARCIM(ARCItemSub,ARCItemVer,7)),"^",13)
	//q:(IsLinkLabARCOS="Y")&&(OrderOnItsOwn'["Y")
	q:(OrderOnItsOwn'["Y")
	s ARCItemEffDateTo=$p($g(^ARCIM(ARCItemSub,ARCItemVer,7)),"^",1)
	q:(ARCItemEffDateTo'="")&(ARCItemEffDateTo<=$p($h,",",1))
	//**********************************************
	//update by zf 20110902
	//判断医嘱项是否有效(有效日期,截止日期)
	s effDateFrom=$p($g(^ARCIM(ARCItemSub,ARCItemVer,1)),"^",13)
	s:effDateFrom'="" effDateFrom=$p(effDateFrom,"Z",1)
	s effDateTo=$p($g(^ARCIM(ARCItemSub,ARCItemVer,7)),"^",1)
	s currDate=+$h
	q:((effDateFrom'="")&&(effDateFrom>currDate))
	q:((effDateTo'="")&&(effDateTo<currDate))
	s Data=$lb(ARCItemID,ARCItemCode,ARCItemDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
	
BuildDataToARCOS
	s ARCOrdSetCode=$p($g(^ARCOS(ARCOrdSetID)),"^",1)
	s ARCOrdSetDesc=$p($g(^ARCOS(ARCOrdSetID)),"^",2)
	Set ExistFlg=##class(%Dictionary.CompiledClass).%OpenId("web.DHCBL.BDP.BDPMappingHOSP")
	If (ExistFlg'="") {
		s ShowFlg=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_OrdSets",ARCOrdSetID,aHospID,+$h)
		q:ShowFlg'="Y"
	}
	s ARCOrdSetCode=$tr(ARCOrdSetCode,$c(13),"")
	s ARCOrdSetCode=$tr(ARCOrdSetCode,$c(13),"")
	s ARCOrdSetDesc=$tr(ARCOrdSetDesc,$c(13),"")
	s ARCOrdSetDesc=$tr(ARCOrdSetDesc,$c(10),"")
	q:ARCOrdSetDesc=""
	s ARCOrdSetDesc="[医嘱套]"_ARCOrdSetDesc
	;s LabSetNo=$p($g(^ARCOS(+ARCOrdSetID)),"^",11)
	;q:LabSetNo=""
	//**********************************************
	//update by zf 20110902
	//判断医嘱套是否有效(有效日期,截止日期)
	s effDateFrom=$p($g(^ARCOS(ARCOrdSetID)),"^",15)
	s effDateTo=$p($g(^ARCOS(ARCOrdSetID)),"^",16)
	s currDate=+$h
	q:((effDateFrom'="")&&(effDateFrom>currDate))
	q:((effDateTo'="")&&(effDateTo<currDate))
	//**********************************************
	s Data=$lb(ARCOrdSetID,ARCOrdSetCode,ARCOrdSetDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QryArcimByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryArcimByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryArcimByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryArcimByAliasExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhugz
/// CreatDate：   2019-07-08
/// Description:  查询抗菌药物医嘱对照HIS医嘱信息
/// Table：       DHCMA.CPW.SDMatch.AntiItemMatch      
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDMatchSrv.AntiItemMatchSrv","QryAntiItemMatch","258")
Query QryAntiItemMatch(aAntiItemDr As %String, aHospID As %String = "") As %Query(ROWSPEC = "AntiItemDr:%String,RowID:%String,OMType:%String,OMTypeDesc:%String,OMArcimID:%String,OMArcimDesc:%String,OMPHCGeneric:%String")
{
}

ClassMethod QryAntiItemMatchExecute(ByRef qHandle As %Binary, aAntiItemDr As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aAntiItemDr="" $$$OK
 	Set xRowID=0
 	For
 	{	
 		Set xRowID=$o(^DHCMA.CPW.SDM.AntiMatchI("IndexOfItemDr",aAntiItemDr,xRowID))
 		Quit:xRowID=""
 		Set ObjItemMatch = ##class(DHCMA.CPW.SDMatch.AntiItemMatch).GetObjById(xRowID)
 		Set OMType          = ObjItemMatch.OMType
 		Set OMArcimID       = ObjItemMatch.OMArcimID
 		Set OMArcimDesc     = ObjItemMatch.OMArcimDesc
 		Set OMPHCGeneric    = ObjItemMatch.OMPHCGeneric
 		Set OMTypeDesc=$Case(OMType,1:"按医嘱",2:"按通用名",1:"")	
 		Set ExistFlg=##class(%Dictionary.CompiledClass).%OpenId("web.DHCBL.BDP.BDPMappingHOSP")
		If (ExistFlg'="")&&(OMArcimID["||") {
			s ShowFlg=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",OMArcimID,$p(aHospID,"!!",1),+$h)
			Continue:ShowFlg'="Y"
		}elseif(ExistFlg'=""){
			s ShowFlg=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_OrdSets",OMArcimID,$p(aHospID,"!!",1),+$h)
			Continue:ShowFlg'="Y"
		}
		Set Data=$lb(aAntiItemDr,xRowID,OMType,OMTypeDesc,OMArcimID,OMArcimDesc,OMPHCGeneric)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryAntiItemMatchClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiItemMatchExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntiItemMatchFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiItemMatchExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
