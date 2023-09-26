/// Creator:		yankai
/// CreateData:		2021-05-07
/// Description:	批处理关联医嘱服务类
Class DHCMA.CPW.BTS.BatHandleOrd Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2021-05-07
/// Description:  查询某路径类型下涉及某医嘱的所有关联记录
/// Table：       
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.BatHandleOrd","QryRelPathOrds",6,"10052||1","2!!1")
Query QryRelPathOrds(aPathTypeID As %String, aArcimID As %String, aHospID As %String = "") As %Query(ROWSPEC = "xMastID:%String,xPathMastDesc:%String,xFormOrdID:%String,OrdTypeDr:%String,OrdTypeDesc:%String,OrdMastID:%String,OrdMastDesc:%String,OrdGeneID:%String,OrdGeneDesc:%String,OrdPriorityID:%String,OrdPriorityDesc:%String,OrdQty:%String,OrdFreqID:%String,OrdFreqDesc:%String,OrdDuratID:%String,OrdDuratDesc:%String,OrdInstrucID:%String,OrdInstrucDesc:%String,OrdDoseQty:%String,OrdUOMID:%String,OrdUOMDesc:%String,OrdNote:%String,OrdChkPosID:%String,OrdLnkOrdDr:%String,OrdIsDefault:%String,OrdIsFluInfu:%String,ItemID:%String,ItemDesc:%String,OrdGroupID:%String,OrdParfID:%String,OrdOID:%String,OrdIsActive:%String,EpDesc:%String,ActUserName:%String")
{
}

ClassMethod QryRelPathOrdsExecute(ByRef qHandle As %Binary, aPathTypeID As %String, aArcimID As %String, aHospID As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	if (aPathTypeID=""){
		Set xPathTypeID=""
	 	For {
		 	Set xPathTypeID = $o(^DHCMA.CPW.BT.PathMastI("IdxofPathType",xPathTypeID))
		 	Quit:xPathTypeID=""
		 	Set aPathTypeID=xPathTypeID
		 	d RelPathOrds
		 }
	}else{
		d RelPathOrds
	}
	Quit $$$OK
	
RelPathOrds
 	Set xMastID=""
 	For {
	 	Set xMastID = $o(^DHCMA.CPW.BT.PathMastI("IdxofPathType",aPathTypeID,xMastID))
	 	Quit:xMastID=""

	 	Set objPathMast = ##class(DHCMA.CPW.BT.PathMast).GetObjById(xMastID)
	 	Continue:'$IsObject(objPathMast)
	 	Continue:'objPathMast.BTIsActive
	 	Set flgChkHosp = ##class(DHCMA.CPW.BTS.PathFormSrv).CheckPathHospOID(xMastID,aHospID)
	 	Continue:'flgChkHosp
	 	
	 	Set formStr = ##class(DHCMA.CPW.BTS.PathFormSrv).GetFormByMast(xMastID)		//获取已发布正使用版本或未发布最新版本
	 	Continue:formStr=""
	 	Set xFormID = $p(formStr,"^",1)
	 	Set xVersion = $p(formStr,"^",2)
	 	Set xPathMastDesc = objPathMast.BTDesc_"("_xVersion_")"
	 	Set objForm = ##class(DHCMA.CPW.BT.PathForm).GetObjById(xFormID)
	 	Continue:'$IsObject(objForm)
	 	Continue:'objForm.FormIsActive
	 	
	 	Set xIndNo=""
	 	For {
		 	Set xIndNo = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",xFormID,xIndNo))
		 	Quit:xIndNo=""
		 	
			Set xSubEpID=""
		 	For {
			 	Set xSubEpID = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",xFormID,xIndNo,xSubEpID))
			 	Quit:xSubEpID=""
			 	
			 	Set xObjEP = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(xFormID_"||"_xSubEpID)
			 	Continue:'$IsObject(xObjEP)
			 	Set EpDesc = xObjEP.EpDesc
			 	
			 	Set xSubItemID = ""
			 	For {
				 	Set xSubItemID = $o(^DHCMA.CPW.BT.PathFormD(xFormID,"EP",xSubEpID,"ITM",xSubItemID))
				 	Quit:xSubItemID=""
				 	
				 	Set ItemID = xFormID_"||"_xSubEpID_"||"_xSubItemID
				 	Set xObjItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(ItemID)
				 	Continue:'$IsObject(xObjItem)
				 	;w objForm.FormPathDr.BTDesc_","_xObjEP.EpDesc_","_xObjItem.ItemDesc,!
				 	Set ItemDesc = xObjItem.ItemDesc
				 	
				 	Set xSubOrdID = ""
				 	For {
					 	Set xSubOrdID = $o(^DHCMA.CPW.BT.PathFormD(xFormID,"EP",xSubEpID,"ITM",xSubItemID,"ORD",xSubOrdID))
					 	Quit:xSubOrdID=""
					 	
					 	Set xFormOrdID=xFormID_"||"_xSubEpID_"||"_xSubItemID_"||"_xSubOrdID
					 	Set objFormOrd = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(xFormOrdID)
					 	Continue:'$IsObject(objFormOrd)
					 	Continue:aArcimID'=objFormOrd.OrdMastID
					 	Set OrdParfID=objFormOrd.Parref.%Id()
					 	
					 	Set (OrdTypeDr,OrdTypeDesc,OrdMastID,OrdMastDesc,OrdGeneID,OrdGeneDesc)=""
						//医嘱类型 指向OEC_Priority  频次 指向PHC_Freq  疗程 指向PHC_Duration 
						Set (OrdPriorityID,OrdPriorityDesc,OrdQty,OrdFreqID,OrdFreqDesc,OrdDuratID,OrdDuratDesc)=""
					 	//用法 指向PHCInstruc  单位 指向CTUOM
					 	Set (OrdInstrucID,OrdInstrucDesc,OrdDoseQty,OrdUOMID,OrdUOMDesc,OrdNote,OrdChkPosID,OrdLnkOrdDr,OrdIsDefault,OrdIsFluInfu,OrdIsActive)=""
					 	Continue:'$Isobject(objFormOrd.OrdTypeDr)
					 	Set OrdTypeDr = objFormOrd.OrdTypeDr.%Id()
					 	Set OrdTypeDesc = objFormOrd.OrdTypeDr.BTDesc
					 	
					 	//取医嘱信息、通用名
					 	Set OrdMastID =objFormOrd.OrdMastID
					 	Set OrdInfo = ##class(DHCMA.CPW.BTS.LinkArcimSrv).GetArcimInfoById(OrdMastID)
					 	Set OrdMastDesc = $p(OrdInfo,"^",20)  //医嘱名
					 	
					 	Set OrdGeneID = $p(OrdInfo,"^",15) 
					 	//Set:PHCGeneID'="" OrdGeneDesc=$p($g(^PHCGE("GE",OrdGeneID)),"^",2)
					 	Set OrdGeneDesc = $p(OrdInfo,"^",16)  //通用名
					 	Set OrdPriorityID = objFormOrd.OrdPriorityID
					 	Set OrdPriorityDesc=$p($g(^OECPR(OrdPriorityID)),"^",2)
					 	Set OrdQty = objFormOrd.OrdQty
					 	Set OrdFreqID = objFormOrd.OrdFreqID
					 	Set:OrdFreqID'="" OrdFreqDesc=$p($g(^PHCFR(OrdFreqID)),"^",3)
					 	Set OrdDuratID = objFormOrd.OrdDuratID 
					 	Set:OrdDuratID'="" OrdDuratDesc=$p($g(^PHCDU(OrdDuratID)),"^",3)
					 	Set OrdInstrucID = objFormOrd.OrdInstrucID
					 	Set:OrdInstrucID'="" OrdInstrucDesc=$p($g(^PHCIN(OrdInstrucID)),"^",2)
					 	Set OrdDoseQty = objFormOrd.OrdDoseQty
					 	If (OrdDoseQty'="")&(OrdDoseQty<1)&(OrdDoseQty'=0){
							Set OrdDoseQty="0"_OrdDoseQty
						} 
					 	Set OrdUOMID = objFormOrd.OrdUOMID
					 	Set:OrdUOMID'="" OrdUOMDesc=$p($g(^CT("UOM",OrdUOMID)),"^",3)
					 	Set OrdNote = objFormOrd.OrdNote
					 	Set OrdChkPosID = objFormOrd.OrdChkPosID
					 	Set OrdLnkOrdDr =objFormOrd.OrdLnkOrdDr
					 	Set OrdIsDefault =objFormOrd.OrdIsDefault
					 	Set OrdIsFluInfu =objFormOrd.OrdIsFluInfu
					 	Set OrdIsActive = objFormOrd.OrdIsActive
					 	Continue:OrdIsActive'=1
					 	Set OrdGroupID = objFormOrd.OrdGroupID
					 	Set OrdOID = objFormOrd.OrdOID
					 	Set OrdActUserID = objFormOrd.OrdActUserID
					 	Set (objActUser,ActUserName)=""
					 	Set:OrdActUserID'="" objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(OrdActUserID)
					 	Set ActUserName = objActUser.BTDesc
					 	//转为可编辑 是否描述
					 	Set:OrdIsDefault=1 OrdIsDefault="是"
					 	Set:OrdIsDefault=0 OrdIsDefault="否"
					 	Set:OrdIsFluInfu=1 OrdIsFluInfu="是"
					 	Set:OrdIsFluInfu=0 OrdIsFluInfu="否"
					 	Set:OrdIsActive=1 OrdIsActive="是"
					 	Set:OrdIsActive=0 OrdIsActive="否"
					 	
					 	
					 	Set Data=$lb(xMastID,xPathMastDesc,xFormOrdID,OrdTypeDr,OrdTypeDesc,OrdMastID,OrdMastDesc,OrdGeneID,OrdGeneDesc,OrdPriorityID,OrdPriorityDesc,OrdQty,OrdFreqID,OrdFreqDesc,OrdDuratID,OrdDuratDesc,OrdInstrucID,OrdInstrucDesc,OrdDoseQty,OrdUOMID,OrdUOMDesc,OrdNote,OrdChkPosID,OrdLnkOrdDr,OrdIsDefault,OrdIsFluInfu,ItemID,ItemDesc,OrdGroupID,OrdParfID,OrdOID,OrdIsActive,EpDesc,ActUserName)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					 }
				 }
			 	
			}
		 	
	 	}
	 	 
	 }
}

ClassMethod QryRelPathOrdsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRelPathOrdsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRelPathOrdsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRelPathOrdsExecute ]
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

}
