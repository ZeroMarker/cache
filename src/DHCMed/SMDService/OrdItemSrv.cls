/// 医嘱查询
/// 创建者：李阳
/// 创建日期：2014-12-12
Class DHCMed.SMDService.OrdItemSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 查询某个Episode下的药品类医嘱
///   参数：
/// 	    EpisodeID:就诊ID
/// w ##class(DHCMed.SMDService.OrdItemSrv).GetDrugOrderItem(33)
ClassMethod GetDrugOrderItem(EpisodeID As %String)
{
	New (EpisodeID)
	Quit:EpisodeID="" $$$OK
	
	Set return = ""
	
	Set OrderID=""
	For {
		Set OrderID=$o(^OEORD(0,"Adm",EpisodeID,OrderID))
		Quit:OrderID=""
		Set ItmMastID=""
		For {
			Set ItmMastID=$o(^OEORDi(0,"ARCIM",OrderID,ItmMastID))
			Quit:ItmMastID=""
			Set objARCIM=##class(DHCMed.Base.Arcim).GetObjById(ItmMastID)
			Do objARCIM.%Close()
			Continue:objARCIM.ARCICOrderType'="R" //只显示药品医嘱
			Set StDate=""
			For {
				Set StDate=$o(^OEORDi(0,"ARCIM",OrderID,ItmMastID,StDate))
				Quit:StDate=""
				Set ChildSub=""
				For {
					Set ChildSub=$o(^OEORDi(0,"ARCIM",OrderID,ItmMastID,StDate,ChildSub))
					Quit:ChildSub=""
					Set OrdID=OrderID_"||"_ChildSub
					Set objItm=##class(DHCMed.Base.OrdItem).GetObjById(OrdID)
					Do objItm.%Close()
					Set OrderItmID  = OrdID
					Set StDate      = $zd(StDate,3)
					Set DrugName    = objARCIM.ARCIMDesc
					Set DrugQty	    = objItm.OEORIDoseQty
					Set DrugUnit	= objItm.CTUOMDesc
					Set DrugInstruc	= objItm.PHCINDesc1
					Set DrugFreq	= objItm.PHCFRDesc1
					Set:return'="" return=return_"#"
					Set return = return_OrderItmID_"^"_DrugName_"^"_DrugQty_"^"_DrugUnit_"^"_DrugInstruc_"^"_DrugFreq
				}
			}
		}
	}
	
	Quit return
}

/// 查询某个Episode下的药品类医嘱
///   参数：
/// 	    EpisodeID:就诊ID
/// 调试: Do ##class(%Library.ResultSet).RunQuery("DHCMed.SMDService.OrdItemSrv","QryDrugOrderItem",68,"")
Query QryDrugOrderItem(EpisodeID As %String, ReportID As %String) As %Query(ROWSPEC = "OrdItmID:%String,OrderDate:%String,OrderName:%String,Num:%String,Unit:%String,Instruc:%String,Freq:%String,Checked:%Integer")
{
}

ClassMethod QryDrugOrderItemExecute(ByRef qHandle As %Binary, EpisodeID As %String, ReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:EpisodeID="" $$$OK
	
	
	Set objRep=##class(DHCMed.SMD.Report).GetObjById(ReportID)
	if ($IsObject(objRep))
	{
		For i=1:1:objRep.SRTreatPharmacy.Count() {
			Set Itm=objRep.SRTreatPharmacy.GetAt(i)
			Set ^CacheTemp(repid,"SRTreatPharmacy",Itm.RPOEItemID)=""
		}
	}
	
	Set OrderID=""
	For {
		Set OrderID=$o(^OEORD(0,"Adm",EpisodeID,OrderID))
		Quit:OrderID=""
		Set ItmMastID=""
		For {
			Set ItmMastID=$o(^OEORDi(0,"ARCIM",OrderID,ItmMastID))
			Quit:ItmMastID=""
			Set objARCIM=##class(DHCMed.Base.Arcim).GetObjById(ItmMastID)
			Do objARCIM.%Close()
			Continue:objARCIM.ARCICOrderType'="R" //只显示药品医嘱
			Set StDate=""
			For {
				Set StDate=$o(^OEORDi(0,"ARCIM",OrderID,ItmMastID,StDate))
				Quit:StDate=""
				Set ChildSub=""
				For {
					Set ChildSub=$o(^OEORDi(0,"ARCIM",OrderID,ItmMastID,StDate,ChildSub))
					Quit:ChildSub=""
					Set OrdID=OrderID_"||"_ChildSub
					Set objItm=##class(DHCMed.Base.OrdItem).GetObjById(OrdID)
					Do objItm.%Close()
					Set data=$lb()
					Set $li(data,1)=OrdID
					Set $li(data,2)=$zd(StDate,3)
					Set $li(data,3)=objARCIM.ARCIMDesc
					Set $li(data,4)=objItm.OEORIDoseQty
					Set $li(data,5)=objItm.CTUOMDesc
					Set $li(data,6)=objItm.PHCINDesc1
					Set $li(data,7)=objItm.PHCFRDesc1
					Set $li(data,8)=$S($d(^CacheTemp(repid,"SRTreatPharmacy",OrdID))>0:1,1:0)
					Set ^CacheTemp(repid,ind)=data
					Set ind=ind+1
				}
			}
		}
	}
	Kill ^CacheTemp(repid,"SRTreatPharmacy")
		
	Quit $$$OK
}

ClassMethod QryDrugOrderItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDrugOrderItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDrugOrderItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDrugOrderItemExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-04-30
/// Description:  根据ARCIM_Desc汉字描述或其别名表的拼音首字母查询
/// Table：       ARC_ItmMast
/// Input：       ARCIMDesc:ARC_ItmMast.ARCIM_Desc汉字描述或ARC_Alias.ARC_Alias首字母别名
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.CommonSrv","QryArcimByAlias","qms")
Query QryArcimByAlias(argAlias As %String) As %Query(ROWSPEC = "ArcimID:%String,ArcimDesc:%String:描述,ARCIMCode:%String:代码,ArcimDR:%String,ARCICOrdCatDR:%String:项目大类Rowid,ORCATDesc:%String:项目大类描述,ARCIMItemCatDR:%String:项目子类Rowid,ARCICDesc:%String:项目子类描述")
{
}

ClassMethod QryArcimByAliasExecute(ByRef qHandle As %Binary, argAlias As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:argAlias="" $$$OK
	Set argAlias=$ZCVT(argAlias,"U")
 	Set ArcimID=0
 	For {
	 	Set ArcimID=$o(^ARCIM(ArcimID))
	 	Quit:ArcimID=""
	 	Set SubID=0
	 	For {
			Set SubID=$o(^ARCIM(ArcimID,SubID))
			Quit:SubID=""
			Set ARCItemID=ArcimID_"||"_SubID
			Set objArcim=##Class(DHCMed.Base.Arcim).GetObjById(ARCItemID)
			If $IsObject(objArcim){
				Set ArcimDesc=objArcim.ARCIMDesc
				Set AliasText=objArcim.ALIASText
				Set ArcimDesc=AliasText_"-"_ArcimDesc
				Continue:ArcimDesc'[argAlias			//按照别名过滤
				Set ArcimDesc=$tr(ArcimDesc,"[","")
				Set ArcimDesc=$tr(ArcimDesc,"]","")
				Set ArcimDesc=$tr(ArcimDesc,")","")
				Set ArcimDesc=$tr(ArcimDesc,")","")
				Set ArcimDesc=$tr(ArcimDesc,"|","")
				Set ArcimDesc=$tr(ArcimDesc,"||","")
				Set ARCIMCode=objArcim.ARCIMCode
				Set ARCICOrdCatDR=objArcim.ARCICOrdCatDR
				Set ORCATDesc=objArcim.ORCATDesc
				Set ARCIMItemCatDR=objArcim.ARCIMItemCatDR
				Set ARCICDesc=objArcim.ARCICDesc
				Set Data=$lb(ArcimID,ArcimDesc,ARCIMCode,ARCItemID,ARCICOrdCatDR,ORCATDesc,ARCIMItemCatDR,ARCICDesc)
 				Set ^CacheTemp(repid,ind)=Data
 				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
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

}
