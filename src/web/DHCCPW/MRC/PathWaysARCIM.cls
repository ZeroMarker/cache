/// 名称: web.DHCCPW.MRC.PathWaysARCIM
/// 描述：对临床路径可选医嘱项的各种操作分别有添加，删除，修改，查询等操作
/// 编写者：李宇峰
/// 编写日期：2010-05-05
Class web.DHCCPW.MRC.PathWaysARCIM Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:李宇峰
/// CreatDate:2010-05-05
/// Description:此Query是用来得到临床路径可选医嘱项的所有记录。
/// Table:User.DHCMRCClinPathWaysARCIM
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWaysARCIM","GetPathWaysARCIM","2||2||1||9")
Query GetPathWaysARCIM(argItemID As %String) As %Query(ROWSPEC = "Rowid:%String,itmNo:%String,itmLinkNo:%String,itmARCIMDR:%String,ARCIMDesc:%String,itmDoseQty:%String,itmUomDr:%String,UomDesc:%String,itmDuratDR:%String,DuratDesc:%String,itmFreqDR:%String,FreqDesc:%String,itmInstrucDR:%String,InstrucDesc:%String,itmQty:%String,itmDefault:%String,itmPriorityRowid:%String,itmPriority:%String,itmIsMain:%String,itmGroupNo:%String,itmResume:%String,itmIsActive:%String")
{
}

ClassMethod GetPathWaysARCIMExecute(ByRef qHandle As %Binary, argItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(argItemID)
	If $IsObject(objItem){
		Set ARCIMLen=objItem.CPWSIARCIM.Count()
		For Ind=1:1:ARCIMLen {
			Set objARCIM=objItem.CPWSIARCIM.GetAt(Ind)
			Continue:objARCIM=""  //update by zf 20120330
			Set RowID=Ind
			Set ItmNo=objARCIM.ITMNo
			Continue:ItmNo=""
			Set ItmLinkNo=objARCIM.ITMLinkNo
			
			Set ItmARCIMDR=objARCIM.ITMARCIMDR
			If $l(ItmARCIMDR,"||")=2 {  //医嘱项
				Set ARCIMDesc=$p($g(^ARCIM(+$p(ItmARCIMDR,"||",1),+$p(ItmARCIMDR,"||",2),1)),"^",2)
				Set:ARCIMDesc="" ItmARCIMDR=""
				Set effDateFrom=$p($g(^ARCIM(+$p(ItmARCIMDR,"||",1),+$p(ItmARCIMDR,"||",2),1)),"^",13)
				Set:effDateFrom'="" effDateFrom=$p(effDateFrom,"Z",1)
				Set effDateTo=$p($g(^ARCIM(+$p(ItmARCIMDR,"||",1),+$p(ItmARCIMDR,"||",2),7)),"^",1)
			} Else {    //医嘱套
				Set ARCIMDesc=$p($g(^ARCOS(+ItmARCIMDR)),"^",2)
				Set:ARCIMDesc="" ItmARCIMDR=""
				Set:ARCIMDesc'="" ARCIMDesc="[医嘱套]"_ARCIMDesc
				Set effDateFrom=$p($g(^ARCOS(+ItmARCIMDR)),"^",15)
				Set effDateTo=$p($g(^ARCOS(+ItmARCIMDR)),"^",16)
			}
			Set currDate=+$h,effInfo=""
			Set:((effDateFrom'="")&&(effDateFrom>currDate)) effInfo="无效医嘱"
			Set:((effDateTo'="")&&(effDateTo<currDate)) effInfo="无效医嘱"
			//检查临床路径与航天HIS医嘱项数据一致性
			Set IsCheckCons=##Class(web.DHCCPW.MR.InterfaceToPrj).CheckArcimConsistency(ItmARCIMDR)
			Set:IsCheckCons'="" ARCIMDesc=ARCIMDesc_"("_IsCheckCons_")"
			
			Set ItmDoseQty=objARCIM.ITMDoseQty
			Set ItmUOMDR=objARCIM.ITMUOMDR
			Set objItmUOM=##class(User.CTUOM).%OpenId(ItmUOMDR)
			If $IsObject(objItmUOM){
				Set UomDesc=$p($g(^CT("UOM",ItmUOMDR)),"^",2)
			}Else{
				Set ItmUOMDR="",UomDesc=""
			}
			If objItmUOM'="" Do objItmUOM.%Close()
			
			Set ItmDuratDR=objARCIM.ITMDuratDR
			Set objItmDurat=##class(User.PHCDuration).%OpenId(ItmDuratDR)
			If $IsObject(objItmDurat){
				Set DuratDesc=$p($g(^PHCDU(ItmDuratDR)),"^",3)
			}Else{
				Set ItmDuratDR="",DuratDesc=""
			}
			If objItmDurat'="" Do objItmDurat.%Close()
			
			Set ItmFreqDR=objARCIM.ITMFreqDR
			Set objItmFreq=##class(User.PHCFreq).%OpenId(ItmFreqDR)
			If $IsObject(objItmFreq){
				Set FreqDesc=$p($g(^PHCFR(ItmFreqDR)),"^",3)
			}Else{
				Set ItmFreqDR="",FreqDesc=""
			}
			If objItmFreq'="" Do objItmFreq.%Close()
			
			Set ItmInstrucDR=objARCIM.ITMInstrucDR
			Set objItmInstruc=##class(User.PHCInstruc).%OpenId(ItmInstrucDR)
			If $IsObject(objItmInstruc){
				Set InstrucDesc=$p($g(^PHCIN(ItmInstrucDR)),"^",2)
			}Else{
				Set ItmInstrucDR="",InstrucDesc=""
			}
			If objItmInstruc'="" Do objItmInstruc.%Close()
			
			Set ItmQty=objARCIM.ITMQty
			Set ItmDefault=objARCIM.ITMDefault
			Set ItmDefault=$s(ItmDefault["Y":"Yes",1:"No")
			
			Set ItmPriorityRoiwd=objARCIM.ITMPriority
			Set ItmPriority=$p($g(^OECPR(+ItmPriorityRoiwd)),"^",2)
			Set ItmIsMain=objARCIM.ITMIsMain
			Set ItmIsMain=$s(ItmIsMain["Y":"Yes",1:"No")
			Set ItmGroupNo=objARCIM.ITMGroupNo
			Set ItmResume=objARCIM.ITMResume
			Set ItmIsActive=objARCIM.ITMIsActive
			Set ItmIsActive=$s(ItmIsActive["N":"No",1:"Yes")
			
			Set Data=$lb(RowID,ItmNo,ItmLinkNo,ItmARCIMDR,ARCIMDesc,ItmDoseQty,ItmUOMDR,UomDesc,ItmDuratDR,DuratDesc,ItmFreqDR,FreqDesc,ItmInstrucDR,InstrucDesc,ItmQty,ItmDefault,ItmPriorityRoiwd,ItmPriority,ItmIsMain,ItmGroupNo,ItmResume,ItmIsActive)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod GetPathWaysARCIMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPathWaysARCIMExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPathWaysARCIMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPathWaysARCIMExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// zhaoyu 2014-05-28 医嘱项检索
/// w ##class(web.DHCCPW.MRC.PathWaysARCIM).GetAllItemGBL()
ClassMethod GetAllItemGBL(argAlias As %String, ZIndex As %String, JIndex As %String) As %String
{
	New (argAlias,ZIndex,JIndex)
	Quit:(argAlias="")!(ZIndex="")!(JIndex="") "Error"
	Set tmpGBLID=0
	Set rs=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	Do rs.Execute(argAlias,"","","","","","","","","","","","","","","")
	While (rs.Next()) {
		Set ArcimID=rs.GetData(2)	// RowId
		Set ArcimCode=rs.GetData(16)	// Code
		Set ArcimDesc=rs.Get("ARCIMDesc")	// Desc
		Set tmpGBLID=tmpGBLID+1
		Set ^CacheTemp(ZIndex,JIndex,"QryGetAllItem",tmpGBLID)=ArcimID_"^"_ArcimCode_"^"_ArcimDesc
	}
	Do rs.Close()
	Quit "Finish"
}

/// Creator：     李宇峰
/// CreatDate：   2010-05-05
/// Description:  此Query是用来按照医嘱项的别名进行查找医嘱项
/// Table:        SQLUSER.ARC_ItmMast
/// Input：       argDesc(医嘱项别名)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWaysARCIM","GetAllItem","青霉素")
Query GetAllItem(argAlias As %String) As %Query(ROWSPEC = "rowid:%String,ordCode:%String,ordSetDesc:%String")
{
}

ClassMethod GetAllItemExecute(ByRef qHandle As %Binary, argAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	/*Quit:(argAlias="") $$$OK
	Set ZIndex=$zn,JIndex=$j
	Kill ^CacheTemp(ZIndex,JIndex,"QryGetAllItem")
	Set flg=..GetAllItemGBL(argAlias,ZIndex,JIndex)
	Quit:(flg="Error") $$$OK
	Set tmpGBLID=""
	For {
		Set tmpGBLID=$o(^CacheTemp(ZIndex,JIndex,"QryGetAllItem",tmpGBLID))
		Quit:(tmpGBLID="")
		Set Info=$g(^CacheTemp(ZIndex,JIndex,"QryGetAllItem",tmpGBLID))
		Set rowid=$p(Info,"^",1)
		Set ordCode=$p(Info,"^",2)
		Set ordSetDesc=$p(Info,"^",3)
		Set Data=$lb(rowid,ordCode,ordSetDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^CacheTemp(ZIndex,JIndex,"QryGetAllItem")
	Quit $$$OK*/
	
	Set IsLinkLabARCOS=""
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("IsLinkLabARCOS")
	If $IsObject(objConfig) {
		Set IsLinkLabARCOS=objConfig.BCValue
	}
	
	s JIndex=$j,ZIndex=$zn
	
	//关联医嘱项
	k ^TMP(ZIndex,JIndex,"ARCItemMast")
	
	//医嘱别名查询医嘱项
	//^ARC("ALIAS",0,"Desc",$$ALPHAUP({ALIAS_Text})_" ",$$ALPHAUP({ALIAS_Desc}),{ALIAS_RowId},1)
	s argAlias=$$ALPHAUP^SSUTIL4(argAlias)
	s Alias=$o(^ARC("ALIAS",0,"Desc",argAlias),-1)
	f  s Alias=$o(^ARC("ALIAS",0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(argAlias))'=argAlias)  d
	.s ARCDesc=""
	.f  s ARCDesc=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc)) q:ARCDesc=""  d
	..s ARCRowid=0
	..f  s ARCRowid=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc,ARCRowid)) q:ARCRowid=""  d
	...q:'$d(^ARC("ALIAS",ARCRowid))
	...s ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
	...q:ARCType'="ARCIM"
	...s ARCAlias=$p(^ARC("ALIAS",ARCRowid),"^",6)
	...s ARCAlias=$$ALPHAUP^SSUTIL4(ARCAlias)
	...q:$e(ARCAlias,1,$l(argAlias))'=argAlias
	...s ARCItemID=$p(^ARC("ALIAS",ARCRowid),"^",1)
	...q:ARCItemID=""
	...q:$d(^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID))
	...d BuildDataToARCIM
	...s ^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID)=""
	
	//医嘱名称查询医嘱项
	//^ARCIM(0,"Desc",$$ALPHAUP({ARCIM_Desc}),{ARCIM_Subscript},{ARCIM_Version})
	s Alias=$o(^ARCIM(0,"Desc",argAlias),-1)
	f  s Alias=$o(^ARCIM(0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(argAlias))'=argAlias)  d
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
		s argAlias=$$ALPHAUP^SSUTIL4(argAlias)
		s Alias=$o(^ARC("ALIAS",0,"Desc",argAlias),-1)
		f  s Alias=$o(^ARC("ALIAS",0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(argAlias))'=argAlias)  d
		.s ARCDesc=""
		.f  s ARCDesc=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc)) q:ARCDesc=""  d
		..s ARCRowid=0
		..f  s ARCRowid=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc,ARCRowid)) q:ARCRowid=""  d
		...q:'$d(^ARC("ALIAS",ARCRowid))
		...//s ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
		...//q:ARCType'="ARCIM"
		...s ARCAlias=$p(^ARC("ALIAS",ARCRowid),"^",6)
		...s ARCAlias=$$ALPHAUP^SSUTIL4(ARCAlias)
		...q:$e(ARCAlias,1,$l(argAlias))'=argAlias
		...s ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
		...q:ARCType'="ARCOS"
		...s ARCOrdSetID=$p(^ARC("ALIAS",ARCRowid),"^",2)
		...q:ARCOrdSetID=""
		...q:$d(^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID))
		...d BuildDataToARCOS
		...s ^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID)=""
		
		//医嘱套名称查询
		//^ARCOS(0,"Desc",$$ALPHAUP({ARCOS_Desc}),{ARCOS_RowId})
		s Alias=$o(^ARCOS(0,"Desc",argAlias),-1)
		f  s Alias=$o(^ARCOS(0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(argAlias))'=argAlias)  d
		.s ARCOrdSetID=0
		.f  s ARCOrdSetID=$o(^ARCOS(0,"Desc",Alias,ARCOrdSetID)) q:ARCOrdSetID=""  d
		...q:$d(^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID))
		...d BuildDataToARCOS
		...s ^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID)=""
		
		k ^TMP(ZIndex,JIndex,"ARCOrdSet")
	}
	
	Quit $$$OK
	
BuildDataToARCIM
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
    //检查临床路径与航天HIS医嘱项数据一致性
	s flg=##Class(web.DHCCPW.MR.InterfaceToPrj).CheckArcimConsistency(ARCItemID)
	//s:flg'="" ARCItemDesc="(!)"_ARCItemDesc_","_flg
	q:flg'=""
	//**********************************************
	s Data=$lb(ARCItemID,ARCItemCode,ARCItemDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
	
BuildDataToARCOS
	s ARCOrdSetCode=$p($g(^ARCOS(ARCOrdSetID)),"^",1)
	s ARCOrdSetDesc=$p($g(^ARCOS(ARCOrdSetID)),"^",2)
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

ClassMethod GetAllItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAllItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllItemExecute ]
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

/// Creator:李宇峰
/// CreatDate:2010-05-05
/// Description:此Query是用来按照医嘱项的Id查找剂量单位
/// Table:SQLUSER.ARC_ItmMast
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWaysARCIM","GetUnit","1000||1")
Query GetUnit(argARCIMID As %String) As %Query(ROWSPEC = "FormDoseUOMRowid:%String,FormDoseUOMDesc:%String")
{
}

ClassMethod GetUnitExecute(ByRef qHandle As %Binary, argARCIMID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set (UOMRowid,UOMDesc)=""
	Set DrgFormRowid=$p($g(^ARCIM(+argARCIMID,$p(argARCIMID,"||",2),1)),"^",12)  //剂量
	Set:DrgFormRowid=-1 DrgFormRowid=""
	If DrgFormRowid'="" {
		Set PHCDRowid=$P(DrgFormRowid,"||",1)
		Set ChildSub=$P(DrgFormRowid,"||",2)
		Set UserLanguage=""
		Set UOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
		If UserLanguage="EN" {
			Set UOMDesc=$p($g(^CT("UOM",UOMRowid)),"^",3)
		}Else{
			Set UOMDesc=$p($g(^CT("UOM",UOMRowid)),"^",2)
		}
		
		Set Data=$lb(UOMRowid,UOMDesc)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	 	
		Set leq=0
		For {
			Set leq=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq))
			Quit:leq=""
			Set eqrec=$g(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq))
			Set UOMRowid=$p(eqrec,"^",1)
			If UserLanguage="EN" {
				Set UOMDesc=$p($g(^CT("UOM",UOMRowid)),"^",3)
			}Else{
				Set UOMDesc=$p($g(^CT("UOM",UOMRowid)),"^",2)
			}
			
			Set Data=$lb(UOMRowid,UOMDesc)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}Else{
		Set Data=$lb(UOMRowid,UOMDesc)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod GetUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnitExecute ]
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
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnitExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// zhaoyu 2014-05-28	疗程
ClassMethod GetDuratGBL(argDesc As %String, ZIndex As %String, JIndex As %String) As %String
{
	New (argDesc,ZIndex,JIndex)
	Quit:(argDesc="")!(ZIndex="")!(JIndex="") "Error"
	Set tmpGBLID=0
	Set rs=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpDuration")
	Do rs.Execute(argDesc)
	While (rs.Next()) {
		Set DuratID=rs.GetData(1)	// RowId
		Set DuratDesc=rs.Get("CTPCPDesc")	// Desc
		Set tmpGBLID=tmpGBLID+1
		Set ^CacheTemp(ZIndex,JIndex,"QryGetDurat",tmpGBLID)=DuratID_"^"_DuratDesc
	}
	Do rs.Close()
	Quit "Finish"
}

/// Creator:李宇峰
/// CreatDate:2010-05-05
/// Description:此Query是用来查找疗程。
/// Table:SQLUSER.PHC_Durqtion
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWaysARCIM","GetDurat","")
Query GetDurat(argDesc As %String) As %Query(ROWSPEC = "Rowid:%String,desc:%String")
{
}

ClassMethod GetDuratExecute(ByRef qHandle As %Binary, argDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:(argDesc="") $$$OK
	Set ZIndex=$zn,JIndex=$j
	Kill ^CacheTemp(ZIndex,JIndex,"QryGetDurat")
	Set flg=..GetDuratGBL(argDesc,ZIndex,JIndex)
	Quit:(flg="Error") $$$OK
	Set tmpGBLID=""
	For {
		Set tmpGBLID=$o(^CacheTemp(ZIndex,JIndex,"QryGetDurat",tmpGBLID))
		Quit:(tmpGBLID="")
		Set Info=$g(^CacheTemp(ZIndex,JIndex,"QryGetDurat",tmpGBLID))
		Set Rowid=$p(Info,"^",1)
		Set desc=$p(Info,"^",2)
		Set Data=$lb(Rowid,desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^CacheTemp(ZIndex,JIndex,"QryGetDurat")
	
	/*Set argDesc=$ZCVT(argDesc,"U")
	Set RowID=0
	For {
		Set RowID=$o(^PHCDU(RowID))
		Quit:RowID=""
		Set Desc=$p((^PHCDU(RowID)),"^",3)
		Continue:(argDesc'="")&&(Desc'[argDesc)
		Set Data=$lb(RowID,Desc)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
	*/
	Quit $$$OK
}

ClassMethod GetDuratFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDuratExecute ]
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
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDuratClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDuratExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// zhaoyu 2014-05-28	频次
ClassMethod GetFreqGBL(argDesc As %String, ZIndex As %String, JIndex As %String) As %String
{
	New (argDesc,ZIndex,JIndex)
	Quit:(argDesc="")!(ZIndex="")!(JIndex="") "Error"
	Set tmpGBLID=0
	Set rs=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpFrequency")
	Do rs.Execute(argDesc)
	While (rs.Next()) {
		Set FreqID=rs.GetData(5)	// RowId
		Set FreqDesc=rs.Get("CTPCPDesc")	// Desc
		Set tmpGBLID=tmpGBLID+1
		Set ^CacheTemp(ZIndex,JIndex,"QryGetFreq",tmpGBLID)=FreqID_"^"_FreqDesc
	}
	Do rs.Close()
	Quit "Finish"
}

/// Creator:李宇峰
/// CreatDate:2010-05-05
/// Description:此Query是用来查找频次。
/// Table:SQLUSER.PHC_Freq
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWaysARCIM","GetFreq","")
Query GetFreq(argDesc As %String) As %Query(ROWSPEC = "Rowid:%String,desc1:%String")
{
}

ClassMethod GetFreqExecute(ByRef qHandle As %Binary, argDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:(argDesc="") $$$OK
	Set ZIndex=$zn,JIndex=$j
	Kill ^CacheTemp(ZIndex,JIndex,"QryGetFreq")
	Set flg=..GetFreqGBL(argDesc,ZIndex,JIndex)
	Quit:(flg="Error") $$$OK
	Set tmpGBLID=""
	For {
		Set tmpGBLID=$o(^CacheTemp(ZIndex,JIndex,"QryGetFreq",tmpGBLID))
		Quit:(tmpGBLID="")
		Set Info=$g(^CacheTemp(ZIndex,JIndex,"QryGetFreq",tmpGBLID))
		Set Rowid=$p(Info,"^",1)
		Set desc1=$p(Info,"^",2)
		Set Data=$lb(Rowid,desc1)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^CacheTemp(ZIndex,JIndex,"QryGetFreq")
	
	/*Set argDesc=$ZCVT(argDesc,"U")
	Set tmpDesc=0
	For {
		Set tmpDesc=$o(^PHCFR(0,"Desc1",tmpDesc))
		Quit:tmpDesc=""
		Continue:(argDesc'="")&&(tmpDesc'[argDesc)
		Set RowID=0
		For {
			Set RowID=$o(^PHCFR(0,"Desc1",tmpDesc,RowID))
			Quit:RowID=""
			Set Desc=$p($g(^PHCFR(RowID)),"^",3)
			Set Data=$lb(RowID,Desc)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}
	*/
	Quit $$$OK
}

ClassMethod GetFreqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFreqExecute ]
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
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetFreqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFreqExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// zhaoyu 2014-05-28	用法
ClassMethod GetInstrucGBL(argDesc As %String, ZIndex As %String, JIndex As %String) As %String
{
	New (argDesc,ZIndex,JIndex)
	Quit:(argDesc="")!(ZIndex="")!(JIndex="") "Error"
	Set tmpGBLID=0
	Set rs=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpInstr")
	Do rs.Execute(argDesc)
	While (rs.Next()) {
		Set InstrucID=rs.GetData(1)	// RowId
		Set InstrucDesc=rs.Get("Desc")	// Desc
		Set tmpGBLID=tmpGBLID+1
		Set ^CacheTemp(ZIndex,JIndex,"QryGetInstruc",tmpGBLID)=InstrucID_"^"_InstrucDesc
	}
	Do rs.Close()
	Quit "Finish"
}

/// Creator:李宇峰
/// CreatDate:2010-05-05
/// Description:此Query是用来查找用法。
/// Table:SQLUSER.PHC_Instruc
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWaysARCIM","GetInstruc","")
Query GetInstruc(argDesc As %String) As %Query(ROWSPEC = "Rowid:%String,desc:%String")
{
}

ClassMethod GetInstrucExecute(ByRef qHandle As %Binary, argDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:(argDesc="") $$$OK
	Set ZIndex=$zn,JIndex=$j
	Kill ^CacheTemp(ZIndex,JIndex,"QryGetInstruc")
	Set flg=..GetInstrucGBL(argDesc,ZIndex,JIndex)
	Quit:(flg="Error") $$$OK
	Set tmpGBLID=""
	For {
		Set tmpGBLID=$o(^CacheTemp(ZIndex,JIndex,"QryGetInstruc",tmpGBLID))
		Quit:(tmpGBLID="")
		Set Info=$g(^CacheTemp(ZIndex,JIndex,"QryGetInstruc",tmpGBLID))
		Set Rowid=$p(Info,"^",1)
		Set desc=$p(Info,"^",2)
		Set Data=$lb(Rowid,desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^CacheTemp(ZIndex,JIndex,"QryGetInstruc")
	
	/*Set RowID=0
	For {
		Set RowID=$o(^PHCIN(RowID))
		Quit:RowID=""
		Set Desc=$p($g(^PHCIN(RowID)),"^",2)
		Continue:(argDesc'="")&&($ZCVT(Desc,"U")'[$ZCVT(argDesc,"U"))
		Set:$p(Desc,"-",2)'="" Desc=$p(Desc,"-",2)
		Set Data=$lb(RowID,Desc)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}*/
	Quit $$$OK
}

ClassMethod GetInstrucFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstrucExecute ]
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
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetInstrucClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstrucExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2011-04-19
/// Description:  取医嘱类型（长期医嘱、临时医嘱、自备要医嘱等）
/// Input：       
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWaysARCIM","QryOECPriority")
Query QryOECPriority() As %Query(ROWSPEC = "OECPRID:%String,OECPRCode:%String,OECPRDesc:%String")
{
}

ClassMethod QryOECPriorityExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set OECPRID=""
	For {
		Set OECPRID=$o(^OECPR(OECPRID))
		Quit:OECPRID=""
		Set OECPRCode=$p($g(^OECPR(OECPRID)),"^",1)
		Set OECPRDesc=$p($g(^OECPR(OECPRID)),"^",2)
		Set Data=$lb(OECPRID,OECPRCode,OECPRDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOECPriorityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOECPriorityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOECPriorityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOECPriorityExecute ]
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
