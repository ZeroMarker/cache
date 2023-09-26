/// 名称: DHCMA.CPW.BTS.PathFormEpSrv
/// 描述: 维护 服务类
/// 编写者：chenjb
/// 编写日期: 2018-08-28
Class DHCMA.CPW.BTS.PathFormEpSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// ^DHCMA.CPW.BT.PathFormD(1,"EP",1) 
/// Creator：     chenjb
/// CreatDate：   2018-09-07
/// Description:  查询临床
/// Table：       DHCMA.CPW.BT.PathFormEp
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathFormEpSrv","QryPathFormEp","1")
Query QryPathFormEp(aPathFormDr As %String) As %Query(ROWSPEC = "ID:%String,EpDesc:%String,EpDesc2:%String,EpIndNo:%String,EpDays:%String,EpIsKeyStep:%String,EpIsKeyStepD:%String,EpIsOperDay:%String,EpIsOperDayD:%String,EpIsFirstDay:%String,EpIsFirstDayD:%String,EpIsActive:%String,EpIsActiveD:%String")
{
}

ClassMethod QryPathFormEpExecute(ByRef qHandle As %Binary, aPathFormDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Quit:aPathFormDr="" $$$OK
	Set xIndNo=""
 	For {
	 	Set xIndNo = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aPathFormDr,xIndNo))		//直接走顺序号索引,按维护顺序输出阶段 fix by yankai20210302
	 	Quit:xIndNo=""
	 	
	 	Set xChildID=""
	 	For {
		 	Set xChildID = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aPathFormDr,xIndNo,xChildID))
		 	Quit:xChildID=""
		 	
			Set obj = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aPathFormDr_"||"_xChildID)
			Continue:'$isobject(obj)
			
		 	Set EpDesc = obj.EpDesc
		 	Set:EpDesc'="" EpDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc",EpDesc,LangID)
		 	Set EpDesc2 =obj.EpDesc2
		 	Set:EpDesc2'="" EpDesc2=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc2",EpDesc2,LangID)
		 	Set EpIndNo = obj.EpIndNo
		 	Set EpDays = obj.EpDays
			
		 	Set EpIsKeyStep = obj.EpIsKeyStep
		 	Set EpIsOperDay = obj.EpIsOperDay
		 	Set EpIsFirstDay = obj.EpIsFirstDay
		 	Set EpIsActive = obj.EpIsActive
		 	Set (EpIsKeyStepD,EpIsOperDayD,EpIsFirstDayD,EpIsActiveD)="否"
		 	Set:EpIsKeyStep=1 EpIsKeyStepD="是"
		 	Set:EpIsOperDay=1 EpIsOperDayD="是"
		 	Set:EpIsFirstDay=1 EpIsFirstDayD="是"
		 	Set:EpIsActive=1 EpIsActiveD="是"
		 	
		 	Set Data=$lb(aPathFormDr_"||"_xChildID,EpDesc,EpDesc2,EpIndNo,EpDays,EpIsKeyStep,EpIsKeyStepD,EpIsOperDay,EpIsOperDayD,EpIsFirstDay,EpIsFirstDayD,EpIsActive,EpIsActiveD)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	 }
	 
	Quit $$$OK
}

ClassMethod QryPathFormEpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathFormEpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathFormEpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathFormEpExecute ]
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

/// ^DHCMA.CPW.BT.PathFormD(1,"EP",1) 
/// Creator：     chenjb
/// CreatDate：   2018-09-07
/// Description:  查询临床
/// Table：       DHCMA.CPW.BT.PathFormEp
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathFormEpSrv","QryPathFormEpItem","68||1","B")
Query QryPathFormEpItem(aPathFormEpDr As %String, aDicCode As %String = "") As %Query(ROWSPEC = "ID:%String,ItemDesc:%String,ItemCatDr:%String,ItemCatDrDesc:%String,ItemIsOption:%String,ItemIsOptionD:%String,ItemIsActive:%String,ItemIsActiveD:%String,ExeDesc:%String,ItemIndNo:%Integer,IsOrd:%String,RelatedOrd:%String,ItemPowerDesc:%String")
{
}

ClassMethod QryPathFormEpItemExecute(ByRef qHandle As %Binary, aPathFormEpDr As %String, aDicCode As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

	Quit:aPathFormEpDr="" $$$OK	
	Set iPathFormDr =$p(aPathFormEpDr,"||",1)
	Set iPathFormEpDr =$p(aPathFormEpDr,"||",2)
 	Set xChildID=""
 	
 	For {
	 	Set xChildID = $o(^DHCMA.CPW.BT.PathFormD(iPathFormDr,"EP",iPathFormEpDr,"ITM",xChildID))
	 	Quit:xChildID=""
	 	
		Set obj = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aPathFormEpDr_"||"_xChildID)
		Continue:'$IsObject(obj)
		
	 	Set ItemDesc = obj.ItemDesc
	 	Set objItemC =obj.ItemCatDr
	 	Continue:'$Isobject(objItemC) 	
	 	Set ItemCatDr = objItemC.%Id()
	 	Set ItemCatDrDesc = objItemC.BTDesc
	 	Continue:'$Isobject(objItemC.BTTypeDr)
	 	Continue:(aDicCode'="")&(aDicCode'=objItemC.BTTypeDr.BTCode) 	
	 	Set ItemIndNo = obj.ItemIndNo
	 	Set ItemPowerDesc=""
	 	Set:$IsObject(objItemC.BTPowerDr) ItemPowerDesc=objItemC.BTPowerDr.BTDesc  
	 	
	 	Set IsOrd=0,RelatedOrd=""
	 	If (aDicCode="B") {
		 	Set xOrdID=""
		 	For {
	 			Set xOrdID = $o(^DHCMA.CPW.BT.PathFormD(iPathFormDr,"EP",iPathFormEpDr,"ITM",xChildID,"ORD",xOrdID))
	 			Quit:xOrdID=""
	 	
				Set objOrd = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(aPathFormEpDr_"||"_xChildID_"||"_xOrdID)
				Continue:'$IsObject(objOrd)
				Continue:'objOrd.OrdIsActive
				Set:IsOrd=0 IsOrd=1
				Set OrdType=objOrd.OrdTypeDr.BTDesc				
				Set:(OrdType["项")&&(RelatedOrd'["项") RelatedOrd=RelatedOrd_",项"
				Set:(OrdType["套")&&(RelatedOrd'["套") RelatedOrd=RelatedOrd_",套"
				Set:(OrdType["协")&&(RelatedOrd'["协") RelatedOrd=RelatedOrd_",协"				
		 	}
		 	//如果关联了方剂，显示已关联医嘱
			If $d(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",iPathFormDr,iPathFormEpDr,xChildID)) {
			 	Set:IsOrd=0 IsOrd=1
			 	Set:RelatedOrd'["自" RelatedOrd=RelatedOrd_",自"
			 }
			 Set:RelatedOrd'="" RelatedOrd=$e(RelatedOrd,2,$l(RelatedOrd))
	 	}
	 	
	 	Set ItemIsOption = obj.ItemIsOption
	 	Set ItemIsActive = obj.ItemIsActive
	 	Set (ItemIsOptionD,ItemIsActiveD)="否"
	 	Set:ItemIsOption=0 ItemIsOptionD="是"
	 	Set:ItemIsActive=1 ItemIsActiveD="是"
	 	Set ExeDesc = obj.ExeDesc
	 	
	 	Set Data=$lb(aPathFormEpDr_"||"_xChildID,ItemDesc,ItemCatDr,ItemCatDrDesc,ItemIsOption,ItemIsOptionD,ItemIsActive,ItemIsActiveD,ExeDesc,ItemIndNo,IsOrd,RelatedOrd,ItemPowerDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
 	}	
	Quit $$$OK
}

ClassMethod QryPathFormEpItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathFormEpItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathFormEpItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathFormEpItemExecute ]
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

/// ^DHCMA.CPW.BT.PathFormD(1,"EP",1) 
/// Creator：     chenjb
/// CreatDate：   2018-09-07
/// Description:  查询临床
/// Table：       DHCMA.CPW.BT.PathFormEp
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathFormEpSrv","QryPathFormEpItemMR","1||1||1")
Query QryPathFormEpItemMR(aPathFormEpItemDr As %String) As %Query(ROWSPEC = "ID:%String,MRTypeID:%String,MRTypeDrCode:%String,MRTypeDrDesc:%String,MRIsActive:%String,MRIsActiveD:%String,MRTempID:%String")
{
}

ClassMethod QryPathFormEpItemMRExecute(ByRef qHandle As %Binary, aPathFormEpItemDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

	Quit:aPathFormEpItemDr="" $$$OK	
	Set iPathFormDr =$p(aPathFormEpItemDr,"||",1)
	Set iPathFormEpDr =$p(aPathFormEpItemDr,"||",2)
	Set iPathFormEpItemDr =$p(aPathFormEpItemDr,"||",3)
 	Set xChildID=""
 	
 	For {
	 	Set xChildID = $o(^DHCMA.CPW.BT.PathFormD(iPathFormDr,"EP",iPathFormEpDr,"ITM",iPathFormEpItemDr,"MR",xChildID))
	 	Quit:xChildID=""
	 	
		Set obj = ##class(DHCMA.CPW.BT.PathFormMR).GetObjById(aPathFormEpItemDr_"||"_xChildID)
		Continue:'$IsObject(obj)
		
	 	Set MRTypeDr = obj.MRTypeDr
	 	Set MRTypeDr =obj.MRTypeDr
	 	Continue:'$Isobject(MRTypeDr)
	 	Set MRTypeID = MRTypeDr.%Id()
	 	Set MRTypeDrCode = MRTypeDr.BTCode
	 	Set MRTypeDrDesc = MRTypeDr.BTDesc
	 	Set MRIsActive = obj.MRIsActive
	 	Set (MRIsActiveD)="否"
	 	Set:MRIsActive=1 MRIsActiveD="是"
	 	Set MRTempID = obj.MRTempID
	 	
	 	Set Data=$lb(aPathFormEpItemDr_"||"_xChildID,MRTypeID,MRTypeDrCode,MRTypeDrDesc,MRIsActive,MRIsActiveD,MRTempID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
 	}	
	Quit $$$OK
}

ClassMethod QryPathFormEpItemMRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathFormEpItemMRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathFormEpItemMRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathFormEpItemMRExecute ]
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

/// ^DHCMA.CPW.BT.PathFormD(1,"EP",1) 
/// Creator：     chenjb
/// CreatDate：   2018-09-07
/// Description:  查询临床
/// Table：       DHCMA.CPW.BT.PathFormEp
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathFormEpSrv","QryPathFormEpItemOrd","1||1||9")
Query QryPathFormEpItemOrd(aPathFormEpItemDr As %String) As %Query(ROWSPEC = "xID:%String,ID:%String,OrdTypeDr:%String,OrdTypeDrDesc:%String,OrdMastID:%String,OrdMastIDDesc:%String,OrdGeneID:%String,OrdGeneIDDesc:%String,OrdPriorityID:%String,OrdPriorityIDDesc:%String,OrdQty:%String,OrdQtyUOMDesc:%String,OrdFreqID:%String,OrdFreqIDDesc:%String,OrdDuratID:%String,OrdDuratIDDesc:%String,OrdInstrucID:%String,OrdInstrucIDDesc:%String,OrdDoseQty:%String,OrdUOMID:%String,OrdUOMIDDesc:%String,OrdNote:%String,OrdChkPosID:%String,OrdLnkOrdDr:%String,OrdIsDefault:%String,OrdIsFluInfu:%String,OrdIsActive:%String,ItemID:%String,ItemDesc:%String,SeqCode:%Integer,OrdUseDays:%String")
{
}

ClassMethod QryPathFormEpItemOrdExecute(ByRef qHandle As %Binary, aPathFormEpItemDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

	Quit:aPathFormEpItemDr="" $$$OK	
	Set iPathFormDr =$p(aPathFormEpItemDr,"||",1)
	Set iPathFormEpDr =$p(aPathFormEpItemDr,"||",2)
	Set iPathFormEpItemDr =$p(aPathFormEpItemDr,"||",3)
 	Set xChildID=""
 	
 	Set objItm = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aPathFormEpItemDr)
	Quit:'$IsObject(objItm) $$$OK
 	Set ItemDesc = objItm.ItemDesc
	Set ItemID = aPathFormEpItemDr
	
 	For {
	 	Set xChildID = $o(^DHCMA.CPW.BT.PathFormD(iPathFormDr,"EP",iPathFormEpDr,"ITM",iPathFormEpItemDr,"ORD",xChildID))
	 	Quit:xChildID=""
	 	
		Set obj = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(aPathFormEpItemDr_"||"_xChildID)
		Continue:'$IsObject(obj)
		Set xID = obj.%Id()
		Set SeqCode = obj.SeqCode
		Set (OrdTypeDr,OrdTypeDrDesc,OrdMastID,OrdMastIDDesc,OrdGeneID,OrdGeneIDDesc)=""
		//医嘱类型 指向OEC_Priority  频次 指向PHC_Freq  疗程 指向PHC_Duration 
		Set (OrdPriorityID,OrdPriorityIDDesc,OrdQty,OrdFreqID,OrdFreqIDDesc,OrdDuratID,OrdDuratIDDesc)=""
	 	//用法 指向PHCInstruc  单位 指向CTUOM
	 	Set (OrdInstrucID,OrdInstrucIDDesc,OrdDoseQty,OrdUOMID,OrdUOMIDDesc,OrdNote,OrdChkPosID,OrdLnkOrdDr,OrdIsDefault,OrdIsFluInfu,OrdIsActive,OrdUseDays)=""
	 	Continue:'$Isobject(obj.OrdTypeDr)
	 	Set OrdTypeDr = obj.OrdTypeDr.%Id()
	 	Set OrdTypeDrDesc = obj.OrdTypeDr.BTDesc
	 	Set OrdMastID =obj.OrdMastID
	 	Continue:OrdMastID=""
	 	//取医嘱信息、通用名
	 	Set OrdInfo = ##class(DHCMA.CPW.BTS.LinkArcimSrv).GetArcimInfoById(OrdMastID)
	 	Set OrdMastIDDesc = $p(OrdInfo,"^",20)  //医嘱名
	 	Set OrdGeneID = $p(OrdInfo,"^",15) 
	 	//Set:PHCGeneID'="" OrdGeneIDDesc=$p($g(^PHCGE("GE",OrdGeneID)),"^",2)
	 	Set OrdGeneIDDesc = $p(OrdInfo,"^",16)  //通用名
	 	Set OrdPriorityID = obj.OrdPriorityID
	 	Set:OrdPriorityID'="" OrdPriorityIDDesc=$p($g(^OECPR(OrdPriorityID)),"^",2)
	 	Set OrdQty = obj.OrdQty
	 	Set OrdFreqID = obj.OrdFreqID
	 	Set:OrdFreqID'="" OrdFreqIDDesc=$p($g(^PHCFR(OrdFreqID)),"^",3)
	 	Set OrdDuratID = obj.OrdDuratID 
	 	Set:OrdDuratID'="" OrdDuratIDDesc=$p($g(^PHCDU(OrdDuratID)),"^",3)
	 	Set OrdInstrucID = obj.OrdInstrucID
	 	Set:OrdInstrucID'="" OrdInstrucIDDesc=$p($g(^PHCIN(OrdInstrucID)),"^",2)
	 	Set OrdDoseQty = obj.OrdDoseQty
	 	If (OrdDoseQty'="")&(OrdDoseQty<1)&(OrdDoseQty'=0){
			Set OrdDoseQty="0"_OrdDoseQty
		} 
	 	Set OrdUOMID = obj.OrdUOMID
	 	Set:OrdUOMID'="" OrdUOMIDDesc=$p($g(^CT("UOM",OrdUOMID)),"^",2)
	 	
	 	Set (OrdQtyUOMID,OrdQtyUOMDesc)=""
	 	Set OrdQtyUOMID=$p(OrdInfo,"^",18)
	 	Set OrdQtyUOMDesc=$p(OrdInfo,"^",19)
	 	
	 	Set OrdNote = obj.OrdNote
		Set OrdLnkOrdDr  = obj.OrdLnkOrdDr
	 	Set OrdChkPosID = obj.OrdChkPosID
	 	Set:$Isobject(obj.OrdLnkOrdDr) OrdLnkOrdDr = obj.OrdLnkOrdDr
	 	Set OrdIsDefault =obj.OrdIsDefault
	 	Set OrdIsFluInfu =obj.OrdIsFluInfu
	 	Set OrdIsActive  =obj.OrdIsActive
	 	//转为可编辑 是否描述
	 	Set:OrdIsDefault=1 OrdIsDefault="是"
	 	Set:OrdIsDefault=0 OrdIsDefault="否"
	 	Set:OrdIsFluInfu=1 OrdIsFluInfu="是"
	 	Set:OrdIsFluInfu=0 OrdIsFluInfu="否"
	 	Set:OrdIsActive=1 OrdIsActive="是"
	 	Set:OrdIsActive=0 OrdIsActive="否"
	 	If (OrdChkPosID'=""){
		 	Set PosDesc = $p(OrdChkPosID,"||",1)
		 	Set OrdMastIDDesc = OrdMastIDDesc_" "_PosDesc
		 }
		 Set OrdUseDays=obj.OrdUseDays
	 	
	 	Set Data=$lb(xID,xChildID,OrdTypeDr,OrdTypeDrDesc,OrdMastID,OrdMastIDDesc,OrdGeneID,OrdGeneIDDesc,OrdPriorityID,OrdPriorityIDDesc,OrdQty,OrdQtyUOMDesc,OrdFreqID,OrdFreqIDDesc,OrdDuratID,OrdDuratIDDesc,OrdInstrucID,OrdInstrucIDDesc,OrdDoseQty,OrdUOMID,OrdUOMIDDesc,OrdNote,OrdChkPosID,OrdLnkOrdDr,OrdIsDefault,OrdIsFluInfu,OrdIsActive,ItemID,ItemDesc,SeqCode,OrdUseDays)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
 	}	
	Quit $$$OK
}

ClassMethod QryPathFormEpItemOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathFormEpItemOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathFormEpItemOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathFormEpItemOrdExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-12-07
/// Description:  查询一个阶段的所有关联医嘱
/// Table：       DHCMA.CPW.BT.PathFormEp
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathFormEpSrv","QryPathFormEpItemOrdAll","17||1","","2!!1","")
Query QryPathFormEpItemOrdAll(aPathFormEpDr As %String, aPathFormEpItemDr As %String, aHospID As %String = "", aOrdDesc As %String = "", aOrdGroupID As %String = "", aUserType As %String = "", aEpisodeID As %String = "", aLgnLocID As %String = "") As %Query(ROWSPEC = "xID:%String,ID:%String,OrdTypeDr:%String,OrdTypeDrDesc:%String,OrdMastID:%String,OrdMastIDDesc:%String,OrdGeneID:%String,OrdGeneIDDesc:%String,OrdPriorityID:%String,OrdPriorityIDDesc:%String,OrdQty:%String,OrdFreqID:%String,OrdFreqIDDesc:%String,OrdDuratID:%String,OrdDuratIDDesc:%String,OrdInstrucID:%String,OrdInstrucIDDesc:%String,OrdDoseQty:%String,OrdUOMID:%String,OrdUOMIDDesc:%String,OrdNote:%String,OrdChkPosID:%String,OrdLnkOrdDr:%String,OrdIsDefault:%String,OrdIsFluInfu:%String,OrdCatCode:%String,ItemID:%String,ItemDesc:%String,OrdGroupID:%String,SeqCode:%String,OrdQtyUomDesc:%String,OrdIncilQty:%String,IsSensitive:%String,IsDefSensitive:%String")
{
}

ClassMethod QryPathFormEpItemOrdAllExecute(ByRef qHandle As %Binary, aPathFormEpDr As %String, aPathFormEpItemDr As %String, aHospID As %String = "", aOrdDesc As %String = "", aOrdGroupID As %String = "", aUserType As %String = "", aEpisodeID As %String = "", aLgnLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Quit:aPathFormEpDr="" $$$OK	
	Set iPathFormDr =$p(aPathFormEpDr,"||",1)
	Set iPathFormEpDr =$p(aPathFormEpDr,"||",2)
	
	Set iPathFormEpItemDr=""
	For {
		Set iPathFormEpItemDr=$o(^DHCMA.CPW.BT.PathFormD(iPathFormDr,"EP",iPathFormEpDr,"ITM",iPathFormEpItemDr))
		Quit:iPathFormEpItemDr=""
		Continue:(aPathFormEpItemDr'="")&&(aPathFormEpItemDr'=(aPathFormEpDr_"||"_iPathFormEpItemDr))
		
		Set objItm = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aPathFormEpDr_"||"_iPathFormEpItemDr)
		Continue:'$IsObject(objItm)
	 	Set ItemDesc = objItm.ItemDesc
	 	Set:ItemDesc'="" ItemDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormItem","ItemDesc",ItemDesc,LangID)
		Set ItemID = aPathFormEpDr_"||"_iPathFormEpItemDr
		
		Set ItemPower=""
		Set objItemCat=objItm.ItemCatDr
		Continue:'$IsObject(objItemCat)
		Set:$IsObject(objItemCat.BTPowerDr) ItemPower=objItemCat.BTPowerDr.BTCode
		Continue:(aUserType="D")&&((ItemPower'="D")&&(ItemPower'="OE")) 			//医生返回诊疗、医嘱
		Continue:(aUserType="N")&&((ItemPower'="N")&&(ItemPower'="NE")) 			//护士返回护理、护嘱
		
		Set SortSttInd=ind
	 	Set xChildID=""
	 	For {
		 	Set xChildID = $o(^DHCMA.CPW.BT.PathFormD(iPathFormDr,"EP",iPathFormEpDr,"ITM",iPathFormEpItemDr,"ORD",xChildID))
		 	Quit:xChildID=""
		 	
			Set obj = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(aPathFormEpDr_"||"_iPathFormEpItemDr_"||"_xChildID)
			Continue:'$IsObject(obj)
			Set OrdIsActive  =obj.OrdIsActive
		 	Continue:'OrdIsActive
		 	
			Set xID = obj.%Id()
			Set (OrdTypeDr,OrdTypeDrDesc,OrdMastID,OrdMastIDDesc,OrdGeneID,OrdGeneIDDesc,OrdCatCode,OrdCatVal)=""
			//医嘱类型 指向OEC_Priority  频次 指向PHC_Freq  疗程 指向PHC_Duration 
			Set (OrdPriorityID,OrdPriorityIDDesc,OrdQty,OrdQtyUomDesc,OrdFreqID,OrdFreqIDDesc,OrdDuratID,OrdDuratIDDesc)=""
		 	//用法 指向PHCInstruc  单位 指向CTUOM
		 	Set (OrdInstrucID,OrdInstrucIDDesc,OrdDoseQty,OrdUOMID,OrdUOMIDDesc,OrdNote,OrdChkPosID,OrdLnkOrdDr,OrdIsDefault,OrdIsFluInfu,OrdIsActive)=""
		 	Set (IsSensitive,IsDefSensitive)=""		// 是否加急、是否默认加急
		 	Continue:'$Isobject(obj.OrdTypeDr)
		 	Set OrdTypeDr = obj.OrdTypeDr.%Id()
		 	Set OrdTypeDrDesc = obj.OrdTypeDr.BTDesc
		 	Set:OrdTypeDrDesc'="" OrdTypeDrDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",OrdTypeDrDesc,LangID)
		 	/*
		 	If ((OrdTypeDrDesc="医嘱项")||(OrdTypeDrDesc="医嘱套")) {
			 	Set OrdCatCode="W"	//医嘱录入
			} Else {
				Set OrdCatCode="C"	//中草药录入
			}
			*/
		 	Set OrdMastID =obj.OrdMastID
		 	Continue:OrdMastID=""
		 	
		 	//调用医生站接口区分草药类医嘱与非草药类医嘱 
		 	Set:(aHospID="")&&($d(%session)) aHospID=%session.Get("LOGON.HOSPID")
		 	Set OrdCatVal=##class(DHCMA.CPW.IO.FromDoc).IsCPWCNMedItem(OrdMastID,aHospID)
		 	Set OrdCatCode=$s(OrdCatVal=0:"W",1:"C")
		 	
		 	//取医嘱信息、通用名
		 	Set OrdInfo = ##class(DHCMA.CPW.BTS.LinkArcimSrv).GetArcimInfoById(OrdMastID)
		 	Set OrdMastIDDesc = $p(OrdInfo,"^",20)  //医嘱名
		 	Continue:(aOrdDesc'="")&&(OrdMastIDDesc'[aOrdDesc)
		 	
		 	Set OrdGeneID = $p(OrdInfo,"^",15) 
		 	//Set:PHCGeneID'="" OrdGeneIDDesc=$p($g(^PHCGE("GE",OrdGeneID)),"^",2)
		 	Set OrdGeneIDDesc = $p(OrdInfo,"^",16)  //通用名
		 	Set OrdPriorityID = obj.OrdPriorityID
		 	Set OrdPriorityIDDesc=$p($g(^OECPR(OrdPriorityID)),"^",2)
		 	Set:OrdPriorityIDDesc'="" OrdPriorityIDDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.OECPriority","OECPRDesc",OrdPriorityIDDesc,Languages)
		 	Set OrdQty = obj.OrdQty
		 	Set OrdQtyUomDesc = $p(OrdInfo,"^",19)
		 	Set OrdFreqID = obj.OrdFreqID
		 	Set:OrdFreqID'="" OrdFreqIDDesc=$p($g(^PHCFR(OrdFreqID)),"^",3)
		 	Set:OrdFreqIDDesc'="" OrdFreqIDDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.PHCFreq","PHCFRDesc2",OrdFreqIDDesc,Languages)
		 	Set OrdDuratID = obj.OrdDuratID 
		 	Set:OrdDuratID'="" OrdDuratIDDesc=$p($g(^PHCDU(OrdDuratID)),"^",3)
		 	Set:OrdDuratIDDesc'="" OrdDuratIDDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.PHCDuration","PHCDUDesc1",OrdDuratIDDesc,Languages)
		 	Set OrdInstrucID = obj.OrdInstrucID
		 	Set:OrdInstrucID'="" OrdInstrucIDDesc=$p($g(^PHCIN(OrdInstrucID)),"^",2)
		 	Set:OrdInstrucIDDesc'="" OrdInstrucIDDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.PHCInstruc","PHCINDesc1",OrdInstrucIDDesc,Languages)
		 	Set OrdDoseQty = obj.OrdDoseQty
		 	If (OrdDoseQty'="")&(OrdDoseQty<1)&(OrdDoseQty'=0){
				Set OrdDoseQty="0"_OrdDoseQty
			} 
		 	Set OrdUOMID = obj.OrdUOMID
		 	Set:OrdUOMID'="" OrdUOMIDDesc=$p($g(^CT("UOM",OrdUOMID)),"^",2)
		 	Set:OrdUOMIDDesc'="" OrdUOMIDDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTUOM","CTUOMDesc",OrdUOMIDDesc,Languages)
		 	Set OrdNote = obj.OrdNote
		 	Set OrdChkPosID = obj.OrdChkPosID
		 	Set:OrdChkPosID'="" OrdChkPosID=..GetTransOfChkPost(OrdChkPosID)		// 检查部位的翻译
		 	Set OrdLnkOrdDr =obj.OrdLnkOrdDr
		 	Set OrdIsDefault =obj.OrdIsDefault
		 	Set OrdIsFluInfu =obj.OrdIsFluInfu
		 	Set OrdGroupID = obj.OrdGroupID
		 	Continue:(aOrdGroupID'="")&&($lf($lfs(OrdGroupID,","),aOrdGroupID)<=0)
		 	Set SeqCode = obj.SeqCode
		 	
		 	//取医嘱项药品库存数量
		 	Set OrdIncilQty=""
		 	If OrdMastID["||"{
				 Set RecLocStr=##class(DHCMA.CPW.IO.FromDoc).GetRecLocByDoc(aEpisodeID,aLgnLocID,OrdMastID)		//接收科室
				 Set IncilInfo=##Class(DHCMA.CPW.IO.FromDoc).GetIncilQtyListByPHA(OrdMastID,$p(RecLocStr,$c(1),1),"I")
				 Set IncilInfo=$p(IncilInfo,$c(2),1)		//取第一条库存信息
				 If IncilInfo'=""{
					 Set IncilQty=$p(IncilInfo,"^",9),IncilUomDesc=$p(IncilInfo,"^",6)
					 Set:IncilUomDesc'="" IncilUomDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTUOM","CTUOMDesc",IncilUomDesc,Languages)
					 Set:IncilInfo'="" OrdIncilQty=IncilQty_"("_IncilUomDesc_")"
				 }
				 
			}
			If OrdMastID["||"{
				Set IsSensitive=$p($g(^ARCIM(+OrdMastID,$p(OrdMastID,"||",2),9)),"^",18)			// 是否加急医嘱
				Set IsDefSensitive=$p($g(^ARCIM(+OrdMastID,$p(OrdMastID,"||",2),9)),"^",41)			// 是否默认加急医嘱
			}
		 	 	
		 	Set Data=$lb(xID,xChildID,OrdTypeDr,OrdTypeDrDesc,OrdMastID,OrdMastIDDesc,OrdGeneID,OrdGeneIDDesc,OrdPriorityID,OrdPriorityIDDesc,OrdQty,OrdFreqID,OrdFreqIDDesc,OrdDuratID,OrdDuratIDDesc,OrdInstrucID,OrdInstrucIDDesc,OrdDoseQty,OrdUOMID,OrdUOMIDDesc,OrdNote,OrdChkPosID,OrdLnkOrdDr,OrdIsDefault,OrdIsFluInfu,OrdCatCode,ItemID,ItemDesc,OrdGroupID,SeqCode,OrdQtyUomDesc,OrdIncilQty,IsSensitive,IsDefSensitive)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	
	 	}	
	 	if ($d(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",iPathFormDr,iPathFormEpDr,iPathFormEpItemDr))) {
		 	Set TCMID=""
		 	
		 	For {
			 	Set TCMID=$o(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",iPathFormDr,iPathFormEpDr,iPathFormEpItemDr,TCMID))
			 	Quit:TCMID=""
			 	Set (TCMDesc,OrdGeneID,OrdGeneIDDesc,OrdPriorityID,OrdPriorityIDDesc,OrdQty,OrdQtyUomDesc,OrdFreqID,OrdFreqIDDesc,OrdDuratID,OrdDuratIDDesc,OrdInstrucID,OrdInstrucIDDesc,OrdDoseQty,OrdUOMID,OrdUOMIDDesc,OrdNote,OrdChkPosID,OrdLnkOrdDr,OrdIsDefault,OrdIsFluInfu,OrdCatCode,SeqCode,OrdIncilQty,IsSensitive,IsDefSensitive)=""
			 	Set ObjTCM=##class(DHCMA.CPW.BT.PathTCM).GetObjById(TCMID)
			 	Continue:'$IsObject(ObjTCM)
			 	Set TCMDesc=ObjTCM.BTDesc
			 	Set:TCMDesc'="" TCMDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathTCM","BTDesc",TCMDesc,LangID)
			 	
			 	Continue:(aOrdDesc'="")&&(TCMDesc'[aOrdDesc)
			 	Set FormTCMID=$o(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",iPathFormDr,iPathFormEpDr,iPathFormEpItemDr,TCMID,""))
			 	Set RowID="FJ:"_TCMID_":"_aPathFormEpDr_"||"_iPathFormEpItemDr_"||"_FormTCMID
			 	Set OrdCatCode="C" //走中草药录入
			 	Set OrdIsDefault="1",OrdIsFluInfu="1",OrdTypeDrDesc="自定义方剂"
			 	Set:OrdTypeDrDesc'="" OrdTypeDrDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",OrdTypeDrDesc,LangID)
			 	
			 	Set objFormTCM = ##class(DHCMA.CPW.BT.PathFormTCM).GetObjById(ItemID_"||"_FormTCMID)
			 	Set OrdGroupID = objFormTCM.TCMGroupID
			 	Continue:(aOrdGroupID'="")&&($lf($lfs(OrdGroupID,","),aOrdGroupID)<=0)
			 	Set Data=$lb(RowID,"","",OrdTypeDrDesc,RowID,TCMDesc,OrdGeneID,OrdGeneIDDesc,OrdPriorityID,OrdPriorityIDDesc,OrdQty,OrdFreqID,OrdFreqIDDesc,OrdDuratID,OrdDuratIDDesc,OrdInstrucID,OrdInstrucIDDesc,OrdDoseQty,OrdUOMID,OrdUOMIDDesc,OrdNote,OrdChkPosID,OrdLnkOrdDr,OrdIsDefault,OrdIsFluInfu,OrdCatCode,ItemID,ItemDesc,OrdGroupID,SeqCode,OrdQtyUomDesc,OrdIncilQty,IsSensitive,IsDefSensitive)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			 }
		}
		
		//对本项目下所有医嘱进行插入排序 add by yankai20210824
		Set SortEndInd=ind
		For xInd=SortSttInd:1:SortEndInd{
			Continue:'$d(^CacheTemp(repid,xInd))
			Set tempData=$g(^CacheTemp(repid,xInd))
			Set xSeqCode=$li($g(^CacheTemp(repid,xInd)),30)
			Set yInd=xInd
			While (yInd>SortSttInd)&&($li($g(^CacheTemp(repid,yInd-1)),30)>xSeqCode){
				Set ^CacheTemp(repid,yInd)=$g(^CacheTemp(repid,yInd-1))
				Set yInd=yInd-1	
			}
			Set ^CacheTemp(repid,yInd)=tempData
		}
				
	}
	Quit $$$OK
}

ClassMethod QryPathFormEpItemOrdAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathFormEpItemOrdAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathFormEpItemOrdAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathFormEpItemOrdAllExecute ]
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

/// Creator：     yankai
/// CreatDate：   2023-01-17
/// Description:  获取检查部位信息对应语言翻译
/// Table：       
/// Input：       aOrdChkPostID
/// Return：  
/// w ##class(DHCMA.CPW.BTS.PathFormEpSrv).GetTransOfChkPost("CTA减影、造影[MRCP胰胆管(侧位,正侧位)，MRU泌尿系(正侧位,正位)]||15B2,3A1")   
ClassMethod GetTransOfChkPost(aOrdChkPostID As %String) As %String
{
	New (aOrdChkPostID,%session)
	Set return = ""
	Quit:aOrdChkPostID="" return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Set ChkPostDesc=$p(aOrdChkPostID,"||",1)
	Set ChkPostID=$p(aOrdChkPostID,"||",2)
	Set AftHdlType = $p(ChkPostDesc,"[",1)
	Set PartAndPostions = $p(ChkPostDesc,"[",2)
	Set TransResult=""
	
	If AftHdlType'="" {
		For indx=1:1:$l(AftHdlType,"、"){
			Set tmpAftHdlType=$p(AftHdlType,"、",indx)
			Continue:tmpAftHdlType=""
			Set tmpAftHdlType=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.DHCAppDispMedthod","ADDesc",tmpAftHdlType,Languages)
			Set:TransResult'="" TransResult=TransResult_"、"_tmpAftHdlType
			Set:TransResult="" TransResult=tmpAftHdlType
		}
	}
	
	Set TransPartAndPost="["
	If $tr(PartAndPostions,"]")'=""{
		Set PartAndPostions=$tr(PartAndPostions,"]")
		For indx=1:1:$l(PartAndPostions,"，"){
			Set tmpPartAndPosts=$p(PartAndPostions,"，",indx)
			Set tmpPart=$p(tmpPartAndPosts,"(",1)
			Set:tmpPart'="" tmpPart=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.DHCAppPart","APDesc",tmpPart,Languages)
			Set TransPartAndPost=TransPartAndPost_tmpPart_"("
			Set tmpPosts=$tr($p(tmpPartAndPosts,"(",2),")")
			If tmpPosts'=""{
				For indy=1:1:$l(tmpPosts,","){
					Set tmpPost=$p(tmpPosts,",",indy)
					Set:tmpPost'="" tmpPost=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.DHCAppPosition","APDesc",tmpPost,Languages)
					Set TransPartAndPost=TransPartAndPost_tmpPost_","
				}
				Set:$e(TransPartAndPost,$l(TransPartAndPost),$l(TransPartAndPost))="," TransPartAndPost=$e(TransPartAndPost,1,$l(TransPartAndPost)-1)
			}
			Set TransPartAndPost=TransPartAndPost_")"_"，"
		}
	}
	If TransPartAndPost="["{
		Set TransPartAndPost=TransPartAndPost_"]"
	}Else{
		Set TransPartAndPost=$e(TransPartAndPost,1,$l(TransPartAndPost)-1)_"]"
	}
	
	Set TransResult = TransResult_TransPartAndPost_"||"_ChkPostID
	Quit TransResult
}

/// Creator：     zhufei
/// CreatDate：   2015-06-17
/// Description:  通用名查询医嘱项
/// Table：       
/// Input：       ItemID : 表单项目
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.CPW.BTS.PathFormEpSrv","QryOrderListByGene","3451","2655||1")
Query QryOrderListByGene(aEpisodeID As %String, aArcimID As %String, aHospID As %String = "") As %Query(ROWSPEC = "ArcimID:%String,ArcimDesc:%String,OrderType:%String,PrescType:%String,FreqDR:%String,FreqDesc:%String,DuratDR:%String,DuratDesc:%String,InstrucDR:%String,InstrucDesc:%String,DoseQty:%String,DoseUomDR:%String,DoseUomDesc:%String,PHCGeneDesc:%String,PHCSpecDesc:%String,PHCFormDesc:%String")
{
}

ClassMethod QryOrderListByGeneExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aArcimID As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Quit:(aEpisodeID="")||(aArcimID="") $$$OK
	Quit:$l(aArcimID,"||")=1 $$$OK
	
	If aHospID=""{
		Set AdmLocID=$p($g(^PAADM(aEpisodeID)),"^",4)  //就诊科室
 		Set aHospID=$p($g(^CTLOC(AdmLocID)),"^",22)	
	}
	
	Set ArcimInfo=##class(DHCMA.CPW.BTS.LinkArcimSrv).GetArcimInfoById(aArcimID)
	Quit:ArcimInfo="" return
	Set tOrderType=$p(ArcimInfo,"^",2)
	Set tPrescType=$p(ArcimInfo,"^",3)
	Set tPHCFormDR=$p(ArcimInfo,"^",13)
	Set tPHCFormDesc=$p(ArcimInfo,"^",14)
	Set tPHCGeneDR=$p(ArcimInfo,"^",15)
	Set tPHCGeneDesc=$p(ArcimInfo,"^",16)
	Set tPHCSpecDesc=$p(ArcimInfo,"^",17)
	Set tArcimDesc=$p(ArcimInfo,"^",20)
	
	Set tmpGeneDesc=$zcvt(tPHCGeneDesc,"U")
	Set xArcimID=""
	For {
		Set xArcimID=$o(^ARCIM(0,"Gener",tPHCGeneDR,xArcimID))
		Quit:xArcimID=""
		
		Set ArcimID=xArcimID_"||1"
		Continue:ArcimID=aArcimID
		Set showFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("ARC_ItmMast",ArcimID,aHospID)	////调用封装的基础数据平台组检查院区显示权限接口
		Continue:showFlg'="Y"
		
		Set ArcimInfo=##class(DHCMA.CPW.BTS.LinkArcimSrv).GetArcimInfoById(ArcimID)
		Continue:ArcimInfo=""
		Set OrderType=$p(ArcimInfo,"^",2)
		Set PrescType=$p(ArcimInfo,"^",3)
		Set DoseQty=$p(ArcimInfo,"^",4)
		Set DoseUomDR=$p(ArcimInfo,"^",5)
		Set DoseUomDesc=$p(ArcimInfo,"^",6)
		Set DuratDR=$p(ArcimInfo,"^",7)
		Set DuratDesc=$p(ArcimInfo,"^",8)
		Set FreqDR=$p(ArcimInfo,"^",9)
		Set FreqDesc=$p(ArcimInfo,"^",10)
		Set InstrucDR=$p(ArcimInfo,"^",11)
		Set InstrucDesc=$p(ArcimInfo,"^",12)
		Set PHCFormDR=$p(ArcimInfo,"^",13)
		Set PHCFormDesc=$p(ArcimInfo,"^",14)
		Set PHCGeneDR=$p(ArcimInfo,"^",15)
		Set PHCGeneDesc=$p(ArcimInfo,"^",16)
		Set PHCSpecDesc=$p(ArcimInfo,"^",17)
		Set ArcimDesc=$p(ArcimInfo,"^",20)
		//Continue:(tPHCFormDesc'="")&&(tPHCFormDesc'=PHCSpecDesc)	//规格
		//Continue:(tPHCGeneDesc'="")&&(tPHCGeneDesc'=PHCFormDesc)	//剂型
		
		If OrderType="R" {
			Set IsArcInci=##class(DHCMA.CPW.BTS.LinkArcimSrv).CheckArcimInci(aEpisodeID,ArcimID)
			Continue:IsArcInci<1 //无库存,主要是针对药品和材料
		}
		
		Set Data=$lb(ArcimID,ArcimDesc,OrderType,PrescType,FreqDR,FreqDesc,DuratDR,DuratDesc,InstrucDR,InstrucDesc,DoseQty,DoseUomDR,DoseUomDesc)
		Set Data=Data_$lb(PHCGeneDesc,PHCSpecDesc,PHCFormDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
		
	
	Quit $$$OK
}

ClassMethod QryOrderListByGeneClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrderListByGeneExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOrderListByGeneFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrderListByGeneExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-03-12
/// Description:  根据项目描述同步关联的医嘱（追加数据，不会删掉已经关联的医嘱）
/// Table：       DHCMA.CPW.BT.PathFormItem
/// Input：       
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BTS.PathFormEpSrv).SyncOrdByItmDesc("7||1")
ClassMethod SyncOrdByItmDesc(aFormEpID As %String) As %String
{
	New (aFormEpID)
	Set return="0"
	Quit:(aFormEpID="") return
	
	Set aFormID=$p(aFormEpID,"||",1)
	Set aFormEpSubID=$p(aFormEpID,"||",2)
	//Set FormEpID=$o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",aFormEpSubID))
	//Quit:FormEpID="" -2 // 最后一个阶段的医嘱无法进行同步关联医嘱操作
	
	Set objCurEpis=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aFormEpID)
	Quit:'$IsObject(objCurEpis) -1
	Set curEpIndNo=objCurEpis.EpIndNo
	
	Set xFormItmID=""
 	For {
	 	Set xFormItmID = $o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",aFormEpSubID,"ITM",xFormItmID))
	 	Quit:xFormItmID=""
	 	
		Set obj = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aFormEpID_"||"_xFormItmID)
		Continue:'$IsObject(obj)
		Continue:'obj.ItemIsActive
		
	 	Set ItemDesc = obj.ItemDesc
	 	Continue:obj.ItemCatDr.BTTypeDr.BTCode'="B"	//重点医嘱	
	 	
	 	Set xIndNo=curEpIndNo-1
	 	For {
		 	Set xIndNo = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aFormID,xIndNo))		//直接走顺序号索引,按维护顺序输出阶段 fix by yankai20210302
		 	Quit:xIndNo=""
		 	
		 	Set xFormEpID=$s(xIndNo=curEpIndNo:aFormEpSubID,1:"")
		 	For {
			 	Set xFormEpID = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aFormID,xIndNo,xFormEpID))
			 	Quit:xFormEpID=""
			 	
			 	Set xxFormItmID=""
			 	For {
				 	Set xxFormItmID=$o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xFormEpID,"ITM",xxFormItmID))
				 	Quit:xxFormItmID=""
				 	
				 	Set objItm = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aFormID_"||"_xFormEpID_"||"_xxFormItmID)
					Continue:'$IsObject(objItm)
					Continue:'objItm.ItemIsActive
					
				 	Set xItemDesc = objItm.ItemDesc
		 			Continue:objItm.ItemCatDr.BTTypeDr.BTCode'="B"	//重点医嘱
		 			
				 	If (ItemDesc=xItemDesc) {
						Set deleteRow=aFormID_"||"_xFormEpID_"||"_xxFormItmID
						&sql(delete DHCMA_CPW_BT.PathFormOrd where Parref=:deleteRow)	//清除已经关联的医嘱
						
					 	Set xOrdID=""
						For {
					 		Set xOrdID = $o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",aFormEpSubID,"ITM",xFormItmID,"ORD",xOrdID))
					 		Quit:xOrdID=""
					 		
					 		Set objOrd=##class(DHCMA.CPW.BT.PathFormOrd).%New()
				 			Set objOrd.Parref=objItm
				 			
				 			Set sc=objOrd.%Save()
				 			if $system.Status.IsError(sc) {        //检查Save是否成功
						   		//Do $system.OBJ.DisplayError(sc) 
						   		Set return=-1
							}else{
								Set NewOrdID=$p(objOrd.%Id(),"||",4)
								M ^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xFormEpID,"ITM",xxFormItmID,"ORD",NewOrdID)=^DHCMA.CPW.BT.PathFormD(aFormID,"EP",aFormEpSubID,"ITM",xFormItmID,"ORD",xOrdID)
								Set return=1
							}
						}
						
						Set deleteRow=aFormID_"||"_xFormEpID_"||"_xxFormItmID
						&sql(delete DHCMA_CPW_BT.PathFormTCM where Parref=:deleteRow)   //清除已经关联的方剂
						If $d(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xFormEpID,"ITM",xxFormItmID,"TCM")){		//未知原因，delete执行后，相关global有时清理不干净，这里执行下
							Kill ^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xFormEpID,"ITM",xxFormItmID,"TCM")
						}
						If $d(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",aFormID,xFormEpID,xxFormItmID)){
							Kill ^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",aFormID,xFormEpID,xxFormItmID)	
						}
						
						Set xFormTCMID=""
						For {
							
							Set xFormTCMID = $o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",aFormEpSubID,"ITM",xFormItmID,"TCM",xFormTCMID))
					 		Quit:xFormTCMID=""
					 		Set xObjFormTCM=##class(DHCMA.CPW.BT.PathFormTCM).GetObjById(aFormID_"||"_aFormEpSubID_"||"_xFormItmID_"||"_xFormTCMID)
					 		Continue:'$IsObject(xObjFormTCM)
					 		
					 		Set xObjTCMDic = xObjFormTCM.TCMDic
					 		Continue:'$IsObject(xObjTCMDic)
					 		
					 		Set xTCMID=xObjTCMDic.%Id()
							Set objFormTCM=##class(DHCMA.CPW.BT.PathFormTCM).%New()
							Set objFormTCM.Parref=objItm
							
							Set sc=objFormTCM.%Save()
							if $system.Status.IsError(sc){
								Set return=-1
							}else{
								
								Set NewFormTCMID=$p(objFormTCM.%Id(),"||",4)
								M ^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xFormEpID,"ITM",xxFormItmID,"TCM",NewFormTCMID)=^DHCMA.CPW.BT.PathFormD(aFormID,"EP",aFormEpSubID,"ITM",xFormItmID,"TCM",xFormTCMID)
								M ^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",aFormID,xFormEpID,xxFormItmID,xTCMID,NewFormTCMID)=^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",aFormID,aFormEpSubID,xFormItmID,xTCMID,xFormTCMID)
								Set return=1
							}
							
						}
						
						Quit	//进入下一个阶段
				 	}
			 	}
		 	}
	 	}
 	}
	 
 	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2020-04-04
/// Description:  查询医嘱套明细
/// Table：       
/// Input：       ItemID : 表单项目
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.CPW.BTS.PathFormEpSrv","QryOrderByARCOS","3506")
Query QryOrderByARCOS(ARCOSRowid As %String, aHospID As %String, aEpisodeID As %String = "") As %Query(ROWSPEC = "ind:%String,ARCIMRowid:%String,ARCIMDesc:%String,DoseQty:%String,DoseUOMDesc:%String,DurDesc:%String,FreqDesc:%String,InstrDesc:%String,SeqNo:%Float,ARCItemData:%String,ARCOrdType:%String")
{
}

ClassMethod QryOrderByARCOSExecute(ByRef qHandlex As %Binary, ARCOSRowid As %String, aHospID As %String, aEpisodeID As %String = "") As %Status
{
	Set repidx=$I(^CacheTemp)
	Set indx=1
	Set qHandlex=$lb(0,repidx,0)
	
	Quit:(ARCOSRowid="") $$$OK
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Set rs1=##Class(%ResultSet).%New("web.DHCDocOrderCommon:FindOSItems")			//医生站医嘱套明细query
	Do rs1.Execute(ARCOSRowid,$p(aHospID,"!!",1),$p(aEpisodeID,"!!",1))
	Set columns = rs1.GetColumnCount()
	While (rs1.Next()) {
		Set ARCIMRowid=rs1.Data("ItemRowid")		//医嘱项ID
		Set ARCIMDesc=rs1.Data("Item")				//名称
		Set:ARCIMDesc'="" ARCIMDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ARCItmMast","ARCIMDesc",ARCIMDesc,Languages)
		Set DoseQty=rs1.Data("ItemDoseQty")			//剂量
		Set DoseUOMDesc=rs1.Data("ItemDoseUOM")		//剂量单位
		Set:DoseUOMDesc'="" DoseUOMDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTUOM","CTUOMDesc",DoseUOMDesc,Languages)
		Set DurDesc	=rs1.Data("ItemDur")			//疗程
		Set:DurDesc'="" DurDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.PHCDuration","PHCDUDesc1",DurDesc,Languages)
		Set FreqDesc=rs1.Data("ItemFreq")			//频次
		Set:FreqDesc'="" FreqDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.PHCFreq","PHCFRDesc2",FreqDesc,Languages)
		Set InstrDesc=rs1.Data("ItemInstr")			//用法
		Set:InstrDesc'="" InstrDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.PHCInstruc","PHCINDesc1",InstrDesc,Languages)
		Set SeqNo=rs1.Data("ItemSeqNo")				//序号
		
		Set ARCItemData=rs1.Data("ItemData")		//医嘱信息串	
		//Set $p(ARCItemData,"^",24)=##class(ext.util.String).Replace($p(ARCItemData,"^",24),"@", $C(2))
		Set ARCOrdType=rs1.Data("ItemOrderType")
		
		// ---------update 20230331 由医生站袁工修改，取医嘱套内维护加急标志来判断医嘱录入界面加急是否勾选 
		Set NotifyClinician=rs1.Data("NotifyClinician")		// 医嘱套内是否默认加急
		If (($p(ARCItemData,"^",13)="Y") && (NotifyClinician="Y")){
			Set $p(ARCItemData,"^",13)="Y"		
		}else{
			Set $p(ARCItemData,"^",13)="N"	
		}
		// ------------------------------
		
		Set Data=$lb(indx,ARCIMRowid,ARCIMDesc,DoseQty,DoseUOMDesc,DurDesc,FreqDesc,InstrDesc,SeqNo,ARCItemData,ARCOrdType)
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1
	}

	Quit $$$OK
	
	/*
	Set ARCOSDateRowid=##class(web.DHCDocOrderEntry).GetOrderSetDate(ARCOSRowid)
	Quit:ARCOSDateRowid=""
	
	Set ^||TempMaxSeqNo($j)=0		//初始为0
	
	// 获取直属该医嘱套的医嘱项信息
	Do GetDataOrdSetItem(ARCOSRowid,ARCOSDateRowid,"SubItem")
	
	// 获取嵌套医嘱套医嘱项信息，如序号与其他关联医嘱序号重复，则返回新序号（只支持两层医嘱套）
	Set xSubOSId=""
	For {
		Set xSubOSId=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"OS",xSubOSId))
		Quit:xSubOSId=""
		
		Set strOS=$g(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"OS",xSubOSId))
		Set inSetRowid=$p(strOS,"^",1)
		
		Set inDateRowid=##class(web.DHCDocOrderEntry).GetOrderSetDate(inSetRowid)
		Continue:inDateRowid=""
		Do GetDataOrdSetItem(inSetRowid,inDateRowid,"SubOS")
	}
	
	Kill ^||TempMaxSeqNo($j)
	Quit $$$OK
	
GetDataOrdSetItem(ARCOSRowid,ARCOSDateRowid,Type)
	Set xID=0
	For {
		Set xID=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",xID))
		Quit:xID=""
		
		Set Itmstr=$g(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",xID))
		Continue:Itmstr=""
		
		Set ARCIMRowid=$p(Itmstr,"^",1)
		//Set ArcimInfo=##class(DHCMA.CPW.BTS.LinkArcimSrv).GetArcimInfoById(ARCIMRowid)
		//Continue:ArcimInfo=""
		
		//update by liuyh 2021-03-23 
		Set (DoseUOMDesc,DurDesc,FreqDesc,InstrDesc)=""
		Set DoseQty=$p(Itmstr,"^",13) //单次剂量
		Set FormDoseUOMID=$p(Itmstr,"^",10)	//单位
		Set:FormDoseUOMID'="" DoseUOMDesc=$p($g(^CT("UOM",FormDoseUOMID)),"^",2)
		Set FormDurID=$p(Itmstr,"^",7)	//疗程
		Set:FormDurID'="" DurDesc=$p($g(^PHCDU(FormDurID)),"^",3)
		Set FormFreqID=$p(Itmstr,"^",8)	//频次
		Set:FormFreqID'="" FreqDesc=$p($g(^PHCFR(FormFreqID)),"^",3)
		Set FormInstrID=$p(Itmstr,"^",9)	//用法
		Set:FormInstrID'="" InstrDesc=$p($g(^PHCIN(FormInstrID)),"^",2)
		Set ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,+$p(ARCIMRowid,"||",2),1)),"^",2)    //医嘱名称
		Set SeqNo=$p(Itmstr,"^",14)			//关联序号
	
		If SeqNo'=""{
			Set curIntBit=$SYSTEM.SQL.FLOOR(SeqNo)
			Set MaxSeqNoVal=$g(^||TempMaxSeqNo($j))		
			If Type="SubItem"{
				Set:MaxSeqNoVal<curIntBit ^||TempMaxSeqNo($j)=curIntBit		//始终存储明细中设置的序号整数位最大值
			}ElseIf Type="SubOS"{
				If $d(^||TempMaxSeqNo($j,curIntBit)){
					Set newSeqNo=$g(^||TempMaxSeqNo($j,curIntBit))
					Set:SeqNo'["." SeqNo=newSeqNo
					Set:SeqNo["." SeqNo=newSeqNo_"."_$p(SeqNo,".",2)	
				}else{
					Set newSeqNo=MaxSeqNoVal+1
					Set:SeqNo'["." SeqNo=newSeqNo
					Set:SeqNo["." SeqNo=newSeqNo_"."_$p(SeqNo,".",2)
					Set ^||TempMaxSeqNo($j)=MaxSeqNoVal+1
					Set ^||TempMaxSeqNo($j,curIntBit)=MaxSeqNoVal+1	
				}
			}	
		}
		Set Data=$lb(ind,ARCIMRowid,ARCIMDesc,DoseQty,DoseUOMDesc,DurDesc,FreqDesc,InstrDesc,SeqNo)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	*/
}

ClassMethod QryOrderByARCOSClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryOrderByARCOSExecute ]
{
	set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
	Quit $$$OK
}

ClassMethod QryOrderByARCOSFetch(ByRef qHandlex As %Binary, ByRef Rowx As %List, ByRef AtEndx As %Integer = 0) As %Status [ PlaceAfter = QryOrderByARCOSExecute ]
{
	set AtEndx=$LIST(qHandlex,1)
 	set repidx=$LIST(qHandlex,2)
 	set indx=$LIST(qHandlex,3)
 	set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		set AtEndx=1
 		set Rowx=""
 	}
 	Else {				// fetch row
 		set Rowx=^CacheTemp(repidx,indx)
 	}
 	// Save QHandle
 	s qHandlex=$lb(AtEndx,repidx,indx)
	Quit $$$OK
}

/// Creator：     yankai
/// CreatDate：   2021-03-04
/// Description:  表单预览展现内容
/// Table：       
/// Input：       PathFormID : 表单ID
/// Return：      返回{rows: [{"K1":"V1","K2":"V2","K3":"V3"},{},...,{}], total: n, curPage: 1}
/// w ##class(DHCMA.CPW.BTS.PathFormEpSrv).GetViewFormItems(17)
ClassMethod GetViewFormItems(aPathFormID As %String) As %String
{
	New (aPathFormID,%session)
	Set return=""
	Quit:aPathFormID="" return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Set NIndex="GetViewFormItems"
    Kill ^TMP($zn,$j,NIndex)
	Set objPathForm = ##class(DHCMA.CPW.BT.PathForm).GetObjById(aPathFormID)
	Quit:'$IsObject(objPathForm) return
	Set FormDesc=objPathForm.FormPathDr.BTDesc
	Set:FormDesc'="" FormDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",FormDesc,LangID)
	Set FormVersion=objPathForm.FormVersion_".0"
	Set FormName=FormDesc_"(v"_FormVersion_")"
	Set FormCost=objPathForm.FormCost
	Set FormDays=objPathForm.FormDays
	
	// 约定描述多语言处理
	Set DayDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","天",LangID)	
	Set CQYZDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","长期医嘱",LangID)	
	Set LSYZDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","临时医嘱",LangID)	
	Set YZDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","医嘱",LangID)	
	Set YouDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","有",LangID)	
	Set WuDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","无",LangID)	
	Set YuanYinDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","原因",LangID)	
	Set QianMingDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","签名",LangID)	
	Set CKSJDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","参考时间",LangID)	
	Set ZYZLGZDesc= ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","主要诊疗工作",LangID)	
	Set ZDYZGZDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","重点医嘱工作",LangID)	
	Set ZYHLGZDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","主要护理工作",LangID)	
	Set BQBYJLDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","病情变异记录",LangID)	
	Set HSQMDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","护士签名",LangID)	
	Set YSQMDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.viewform.csp","医生签名",LangID)	
	
	//主要诊疗项目(A),重点医嘱项目(B),主要护理项目(C)
	Set strRowArr="",strRowStepDays=""	
	Set xIndNo="",strDaysJson="",strZLJson="",strYZJson="",strHLJson="",strVarJson="",strNurSignJson="",strDocSignJson=""
 	For {
	 	Set xIndNo = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aPathFormID,xIndNo))
	 	Quit:xIndNo=""
	 	
	 	Set xSubEpID="",tmpDaysKV="",tmpZLKV="",tmpYZKV="",tmpHLKV="",tmpVarKV="",tmpNurSignKV="",tmpDocSignKV=""
	 	For {
		 	Set xSubEpID = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aPathFormID,xIndNo,xSubEpID))
		 	Quit:xSubEpID=""
		 	
		 	Set xFormEpID = aPathFormID_"||"_xSubEpID
			Set objFormEP = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(xFormEpID)
			Continue:'$IsObject(objFormEP)
			Set EpDays = objFormEP.EpDays_DayDesc
			
			Set xItemID = "",xColZLValue="",xColYZValue="",xColHLValue="",tmpCQYZValue="",tmpLSYZValue="",tmpQTYZValue=""
			For {
			 	Set xItemID = $o(^DHCMA.CPW.BT.PathFormD(aPathFormID,"EP",xSubEpID,"ITM",xItemID))
			 	Quit:xItemID=""
			 	
				Set objItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aPathFormID_"||"_xSubEpID_"||"_xItemID)
				Continue:'$IsObject(objItem)
				Set ItemID = objItem.%Id()
			 	Set ItemDesc = objItem.ItemDesc
			 	Continue:'$IsObject(objItem.ItemCatDr) 	
				
				Set ItemIndNo=objItem.ItemIndNo	//顺序号	
				If '$d(^TMP($zn,$j,NIndex,ItemIndNo,ItemID)){
					Set ^TMP($zn,$j,NIndex,ItemIndNo,ItemID)=ItemIndNo
				}
				
			}
			Set IndNo=""
			For {
				Set IndNo = $o(^TMP($zn,$j,NIndex,IndNo))
				Quit:IndNo=""
				Set tID=""
				For {
					Set tID = $o(^TMP($zn,$j,NIndex,IndNo,tID))
					Quit:tID=""
					Set objItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(tID)
					Continue:'$IsObject(objItem)
					Set ItemID = objItem.%Id()
					Set ItemDesc = objItem.ItemDesc
					Set ItemDesc=$Replace(ItemDesc,"""","“")
					Set ItemDesc=$Replace(ItemDesc,"\","/")
					Set ItemDesc=$Replace(ItemDesc,$char(10),"")
					Set ItemDesc=$Replace(ItemDesc,$char(13),"")
					Set:ItemDesc'="" ItemDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormItem","ItemDesc",ItemDesc,LangID)
					Continue:'$IsObject(objItem.ItemCatDr) 	
					If objItem.ItemCatDr.BTCode["A"	{				//主要诊疗工作
						Set:xColZLValue'="" xColZLValue=xColZLValue_"</br>"
				 		Set xColZLValue=xColZLValue_"<input class='hisui-checkbox' type='checkbox' id='chk-"_ItemID_"'></input><label for='chk-"_ItemID_"'>"_ItemDesc_"</label>"
					}
					If objItem.ItemCatDr.BTCode["B"	{				//重点医嘱工作
						//只输出医嘱项目
						//Set:xColYZValue'="" xColYZValue=xColYZValue_"</br>"
					 	//Set xColYZValue=xColYZValue_"<input class='hisui-checkbox' type='checkbox' label='"_ItemDesc_"' id='chk-"_ItemID_"'></input>"
					 	
						//输出医嘱类别和项目
						If (objItem.ItemCatDr.BTCode["B01"){		//长期医嘱
							Set:tmpCQYZValue'="" tmpCQYZValue=tmpCQYZValue_"</br><input class='hisui-checkbox' type='checkbox'  id='chk-"_ItemID_"'></input><label for='chk-"_ItemID_"'>"_ItemDesc_"</label>"
							Set:tmpCQYZValue="" tmpCQYZValue="<b>"_CQYZDesc_"</b><br/><input class='hisui-checkbox' type='checkbox'  id='chk-"_ItemID_"'></input><label for='chk-"_ItemID_"'>"_ItemDesc_"</label>"	
						}
						If (objItem.ItemCatDr.BTCode["B02"){		//临时医嘱（含出院医嘱）
							Set:tmpLSYZValue'="" tmpLSYZValue=tmpLSYZValue_"</br><input class='hisui-checkbox' type='checkbox'  id='chk-"_ItemID_"'></input><label for='chk-"_ItemID_"'>"_ItemDesc_"</label>"
							Set:tmpLSYZValue="" tmpLSYZValue="<b>"_LSYZDesc_"</b><br/><input class='hisui-checkbox' type='checkbox'  id='chk-"_ItemID_"'></input><label for='chk-"_ItemID_"'>"_ItemDesc_"</label>"
						}
						If (objItem.ItemCatDr.BTCode["B00"){		//医嘱（未区分医嘱）
							Set:tmpQTYZValue'="" tmpQTYZValue=tmpQTYZValue_"</br><input class='hisui-checkbox' type='checkbox'  id='chk-"_ItemID_"'></input><label for='chk-"_ItemID_"'>"_ItemDesc_"</label>"
							Set:tmpQTYZValue="" tmpQTYZValue="<b>"_YZDesc_"</b><br/><input class='hisui-checkbox' type='checkbox'  id='chk-"_ItemID_"'></input><label for='chk-"_ItemID_"'>"_ItemDesc_"</label>"
 						}
						//Set:tmpQTYZValue'="" xColYZValue=tmpQTYZValue
						//Set:tmpCQYZValue'="" xColYZValue=xColYZValue_"</br></br>"_tmpCQYZValue
						//Set:tmpLSYZValue'="" xColYZValue=xColYZValue_"</br></br>"_tmpLSYZValue
						//Set xColYZValue=tmpCQYZValue_"</br></br>"_tmpLSYZValue_"</br></br>"_tmpQTYZValue
					}
					If objItem.ItemCatDr.BTCode["C"	{				//主要护理工作
						Set:xColHLValue'="" xColHLValue=xColHLValue_"</br>"
					 	Set xColHLValue=xColHLValue_"<input class='hisui-checkbox' type='checkbox'  id='chk-"_ItemID_"'></input><label for='chk-"_ItemID_"'>"_ItemDesc_"</label>"
					}
				}
				Kill ^TMP($zn,$j,NIndex,IndNo)
			}
			
			//医嘱项目
			Set:tmpQTYZValue'="" xColYZValue=tmpQTYZValue
			Set:tmpCQYZValue'="" xColYZValue=xColYZValue_"</br>"_tmpCQYZValue
			Set:tmpLSYZValue'="" xColYZValue=xColYZValue_"</br>"_tmpLSYZValue
			
			//参考时间
			Set:tmpDaysKV'="" tmpDaysKV=tmpDaysKV_",""FLD-"_xFormEpID_""":"""_EpDays_""""
			Set:tmpDaysKV="" tmpDaysKV="""FLD-"_xFormEpID_""":"""_EpDays_""""
			
			//诊疗内容
			Set:tmpZLKV'="" tmpZLKV=tmpZLKV_",""FLD-"_xFormEpID_""":"""_xColZLValue_""""	
			Set:tmpZLKV="" tmpZLKV="""FLD-"_xFormEpID_""":"""_xColZLValue_""""
			
			//重点医嘱
			Set:tmpYZKV'="" tmpYZKV=tmpYZKV_",""FLD-"_xFormEpID_""":"""_xColYZValue_""""
			Set:tmpYZKV="" tmpYZKV="""FLD-"_xFormEpID_""":"""_xColYZValue_""""
			
			//护理工作
			Set:tmpHLKV'="" tmpHLKV=tmpHLKV_",""FLD-"_xFormEpID_""":"""_xColHLValue_""""	
			Set:tmpHLKV="" tmpHLKV="""FLD-"_xFormEpID_""":"""_xColHLValue_""""	
			
			//病情变异
			Set:tmpVarKV'="" tmpVarKV=tmpVarKV_",""FLD-"_xFormEpID_""":""<input class='hisui-radio' type='radio' label='"_YouDesc_"' name='isVar-_'"_xFormEpID_" value='1' data-options=\""radioClass:'hischeckbox_square'\""/>&nbsp;&nbsp;&nbsp;&nbsp<input class='hisui-radio' type='radio' label='"_WuDesc_"' name='isVar-_'"_xFormEpID_" value='0' data-options=\""radioClass:'hischeckbox_square'\""/></br>"_YuanYinDesc_"："""
			Set:tmpVarKV="" tmpVarKV="""FLD-"_xFormEpID_""":""<input class='hisui-radio' type='radio' label='"_YouDesc_"' name='isVar-_'"_xFormEpID_" value='1' data-options=\""radioClass:'hischeckbox_square'\""/>&nbsp;&nbsp;&nbsp;&nbsp<input class='hisui-radio' type='radio' label='"_WuDesc_"' name='isVar-_'"_xFormEpID_" value='0' data-options=\""radioClass:'hischeckbox_square'\""/></br>"_YuanYinDesc_"："""
			
			//护士签名
			Set:tmpNurSignKV'="" tmpNurSignKV=tmpNurSignKV_",""FLD-"_xFormEpID_""":"""""
			Set:tmpNurSignKV="" tmpNurSignKV="""FLD-"_xFormEpID_""":"""_QianMingDesc_"："""
			
			//医生签名
			Set:tmpDocSignKV'="" tmpDocSignKV=tmpDocSignKV_",""FLD-"_xFormEpID_""":"""""
			Set:tmpDocSignKV="" tmpDocSignKV="""FLD-"_xFormEpID_""":"""_QianMingDesc_"："""
			
		}
		Set:strDaysJson'="" strDaysJson=strDaysJson_","
		Set:strDaysJson="" strDaysJson="{""step"":"""_CKSJDesc_""","
		Set strDaysJson=strDaysJson_tmpDaysKV
		
		Set:strZLJson'="" strZLJson=strZLJson_","
		Set:strZLJson="" strZLJson="{""step"":"""_ZYZLGZDesc_""","
		Set strZLJson=strZLJson_tmpZLKV
		 
		Set:strYZJson'="" strYZJson=strYZJson_","	
		Set:strYZJson="" strYZJson="{""step"":"""_ZDYZGZDesc_""","
		Set strYZJson=strYZJson_tmpYZKV
		
		Set:strHLJson'="" strHLJson=strHLJson_","
		Set:strHLJson="" strHLJson="{""step"":"""_ZYHLGZDesc_""","	
		Set strHLJson=strHLJson_tmpHLKV
		
		Set:strVarJson'="" strVarJson=strVarJson_","
		Set:strVarJson="" strVarJson="{""step"":"""_BQBYJLDesc_""","		
		Set strVarJson=strVarJson_tmpVarKV
		
		Set:strNurSignJson'="" strNurSignJson=strNurSignJson_","
		Set:strNurSignJson="" strNurSignJson="{""step"":"""_HSQMDesc_""","
		Set strNurSignJson=strNurSignJson_tmpNurSignKV
		
		Set:strDocSignJson'="" strDocSignJson=strDocSignJson_","
		Set:strDocSignJson="" strDocSignJson="{""step"":"""_YSQMDesc_""","
		Set strDocSignJson=strDocSignJson_tmpDocSignKV
	 }
	 
	 Set strRowVar="["_strDaysJson_"},"_strZLJson_"},"_strYZJson_"},"_strHLJson_"},"_strVarJson_"},"_strNurSignJson_"},"_strDocSignJson_"}]"
	 Set return="{""rows"":"_strRowVar_",""total"":5,""curPage"":1,""name"":"""_FormName_""",""cost"":"""_FormCost_""",""days"":"""_FormDays_"""}"
	 
	Quit return
}

/// Creator:	yankai
/// CreatDate:	2022-04-04
/// Desc:		查询阶段顺序号是否已定义
/// Inputs:		aFormID：被检查的表单ID,
/// 			aIndNo:被检查的表单顺序号,
/// 				aSubEpID:要排除的阶段ID
/// Return:		1:已被定义；0：无
/// w ##class(DHCMA.CPW.BTS.PathFormEpSrv).IsDefBtEpIndNo(17,2,1)
ClassMethod IsDefBtEpIndNo(aFormID As %String, aIndNo As %String, aSubEpID As %String = "") As %String
{
	New (aFormID,aIndNo,aSubEpID)
	Set return=0
	Quit:(aFormID="")&&(aIndNo="") return
	
	Set xFormEpID=""
	For {
		Set xFormEpID=$o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aFormID,aIndNo,xFormEpID))
		Quit:return=1
		Quit:xFormEpID=""
		
		Continue:(aSubEpID'="")&&(xFormEpID=aSubEpID)
		Set return=1
	}
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2021-01-05
/// Description:  由表单项目获取所属阶段天数
/// Table：       
/// Input：       PathFormItemID : 表单项目ID
/// Return：      返回阶段天数
/// w ##class(DHCMA.CPW.BTS.PathFormEpSrv).GetCurFormEpDays("50||1||7")
ClassMethod GetCurFormEpDays(aFormItemID As %String) As %String
{
	New (aFormItemID)
	Set return = ""
	Quit:aFormItemID="" return
	
	Set objFormItem=##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aFormItemID)
	Quit:'$IsObject(objFormItem) return
	Quit:'$IsObject(objFormItem.Parref) return
	
	Set return=objFormItem.Parref.EpDays
	Quit return
}

}
