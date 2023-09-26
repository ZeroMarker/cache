/// 名称: DHCMA.CPW.BTS.PathTCMExtSrv
/// 描述: 路径中药方剂 服务类
/// 编写者：liuzhenhe
/// 编写日期: 2018-08-28
Class DHCMA.CPW.BTS.PathTCMExtSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-27
/// Description:  查询临床路径方剂字典
/// Table：       DHCMA.CPW.BT.PathTCMExt
/// Input：     
/// BTOrdMastID As %String  BTTypeDr As DHCMA.Util.BT.Dictionary  
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathTCMExtSrv","QryPathTCMExt")
Query QryPathTCMExt(aParRef As %String) As %Query(ROWSPEC = "BTSID:%Integer,ExtID:%String,BTOrdMastID:%String,BTTypeID:%String,BTTypeDesc:%String,DoseQty:%String,CTUnit:%String,SPriority:%String,ArcResume:%String,ArcResumeDesc:%String")
{
}

ClassMethod QryPathTCMExtExecute(ByRef qHandle As %Binary, aParRef As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aParRef="" $$$OK
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
	Set xOrdMastID=""
 	For {
	 	Set xOrdMastID=$o(^DHCMA.CPW.BT.PathTCMI("EXT","IdxofOrdMastID",xOrdMastID))
	 	Quit:xOrdMastID=""
	 	
		Set xSub=""
	 	For {	
	 		Set xSub=$o(^DHCMA.CPW.BT.PathTCMI("EXT","IdxofOrdMastID",xOrdMastID,aParRef,xSub))
	 		Quit:xSub=""
	 		
	 		Set ID=aParRef_"||"_xSub
	 		Set obj=##class(DHCMA.CPW.BT.PathTCMExt).GetObjById(ID)
	 		Continue:'$IsObject(obj)
	 		
	 		Set OrdMastID      = obj.BTOrdMastID		// 存的医嘱项名称
	 		Set:OrdMastID'="" OrdMastID=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ARCItmMast","ARCIMDesc",OrdMastID,Languages)
	 		Set TypeID="",TypeDesc=""
	 		If $IsObject(obj.BTTypeDr){
			 	Set TypeID         = obj.BTTypeDr.%Id()
		 		Set TypeDesc       = obj.BTTypeDr.BTDesc
		 		Set:TypeDesc'="" TypeDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",TypeDesc,LangID)
	 		}
	 		Set DoseQty		= obj.DoseQty
	 		Set CTUnit      = obj.CTUnit
	 		Set:CTUnit'="" CTUnit=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTUOM","CTUOMDesc",CTUnit,Languages)
	 		Set SPriority	= obj.SPriority
	 		Set:SPriority=1 SPriority="是"
	 		Set:SPriority=0 SPriority="否"
	 		Set ArcResume	= obj.ArcResume
	 		Set ArcResumeDesc=""
	 		Set DocConfigstr = $g(^DHCDocConfig("CNMedItemPhSpecInstr"))
			For inds=0:1:$l(DocConfigstr,"^"){
				Set DocConfigInfo=$p(DocConfigstr,"^",inds)
				Set DocConfigID = $p(DocConfigInfo,$c(1),1)
				Set DocConfigDesc = $p(DocConfigInfo,$c(1),2)
				Set:DocConfigID=ArcResume ArcResumeDesc=DocConfigDesc
				Quit:ArcResumeDesc'=""
			}
			
			Set Data=$lb(xSub,ID,OrdMastID,TypeID,TypeDesc,DoseQty,CTUnit,SPriority,ArcResume,ArcResumeDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
 	}	
	Quit $$$OK
}

ClassMethod QryPathTCMExtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathTCMExtExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathTCMExtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathTCMExtExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     chenjb
/// CreatDate：   2018-06-11
/// Description:  别名检索医嘱项修改为中草药医嘱检索
/// Table:        SQLUSER.ARC_ItmMast
/// Input：       aAlias ：别名
/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathTCMExtSrv","QryArcimByAliasAndItemCat","党参","","10!!1")
Query QryArcimByAliasAndItemCat(q As %String, aArcItemCat As %String, aHospID As %String) As %Query(ROWSPEC = "ArcimID:%String,ArcimCode:%String,ArcimDesc:%String")
{
}

ClassMethod QryArcimByAliasAndItemCatExecute(ByRef qHandle As %Binary, q As %String, aArcItemCat As %String, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	Set aAlias = q
	Set aHospID=$p(aHospID,"!!",1)
	Quit:(aHospID="")||(q="") $$$OK
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	//Set IsLinkLabARCOS="N" //##class(User.DHCMRCBaseConfig).GetValueByCode("IsLinkLabARCOS")
	
	s JIndex=$j,ZIndex=$zn
	
	Set ArcItemCatStr = ##class(DHCMA.CPW.IO.FromDoc).GetCPWCNMedItemCatStr(aHospID)
	Set ArcItemCatList =""
	Set:ArcItemCatStr'="" ArcItemCatList =$lfs(ArcItemCatStr,"^")
	
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
	Set aAlias=$$ALPHAUP^SSUTIL4(q)
	//s Alias=$o(^ARCIM(0,"Desc",aAlias),-1)
	s Alias=""
	f  s Alias=$o(^ARCIM(0,"Desc",Alias)) q:(Alias="")  d
	.q:Alias'[aAlias
	.s ItemSub=0
	.f  s ItemSub=$o(^ARCIM(0,"Desc",Alias,ItemSub)) q:ItemSub=""  d
	..s ItemVer=0
	..f  s ItemVer=$o(^ARCIM(0,"Desc",Alias,ItemSub,ItemVer)) q:ItemVer=""  d
	...s ARCItemID=ItemSub_"||"_ItemVer
	...q:$d(^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID))
	...d BuildDataToARCIM
	...s ^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID)=""
	
	k ^TMP(ZIndex,JIndex,"ARCItemMast")
	
	Quit $$$OK
	
BuildDataToARCIM
	s showFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("ARC_ItmMast",ARCItemID,aHospID)	////调用封装的基础数据平台组检查院区显示权限接口
	q:showFlg'="Y"
	s ARCItemSub=$p(ARCItemID,"||",1)
	s ARCItemVer=$p(ARCItemID,"||",2)

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
	s eArcItemCat=$p($g(^ARCIM(ARCItemSub,ARCItemVer,1)),"^",10)
	q:(aArcItemCat'="")&&(aArcItemCat'=eArcItemCat)
	Set ret =$listfind(ArcItemCatList,eArcItemCat)
	q:ret<1
    //检查临床路径与航天HIS医嘱项数据一致性
	s flg=##Class(web.DHCCPW.MR.InterfaceToPrj).CheckArcimConsistency(ARCItemID)
	//s:flg'="" ARCItemDesc="(!)"_ARCItemDesc_","_flg
	q:flg'=""
	//**********************************************
	Set:ARCItemDesc'="" ARCItemDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ARCItmMast","ARCIMDesc",ARCItemDesc,Languages)
	s Data=$lb(ARCItemID,ARCItemCode,ARCItemDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QryArcimByAliasAndItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryArcimByAliasAndItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryArcimByAliasAndItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryArcimByAliasAndItemCatExecute ]
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

/// Creator：     dengshaopeng
/// CreatDate：   2019-12-18
/// Description:  中草药医嘱备注获取
/// Table:        ^DHCDocConfig("CNMedItemPhSpecInstr")
/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathTCMExtSrv","QryDocConfig")
Query QryDocConfig() As %Query(ROWSPEC = "ID:%String,DocConfigDesc:%String")
{
}

ClassMethod QryDocConfigExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	Set ID="",DocConfigDesc =""
	
	Set DocConfigstr = $g(^DHCDocConfig("CNMedItemPhSpecInstr"))
	For inds=0:1:$l(DocConfigstr,"^"){
		Set DocConfigInfo=$p(DocConfigstr,"^",inds)
		Set ID = $p(DocConfigInfo,$c(1),1)
		Set DocConfigDesc = $p(DocConfigInfo,$c(1),2)
		//b ;
		s Data=$lb(ID,DocConfigDesc)
		s ^CacheTemp(repid,ind)=Data
		s ind=ind+1
	}
	q $$$OK
}

ClassMethod QryDocConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDocConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDocConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDocConfigExecute ]
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
