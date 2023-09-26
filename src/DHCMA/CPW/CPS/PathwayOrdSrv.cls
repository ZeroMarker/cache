/// 名称: DHCMA.CPW.CPS.PathwayOrdSrv
/// 描述: 临床路径医嘱查询相关服务
/// 编写者：dengshaopeng
/// 编写日期: 2020-03-31
Class DHCMA.CPW.CPS.PathwayOrdSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     dengshaopeng
/// CreatDate：   2020-03-31
/// Description:  按日期查询病人路径医嘱情况
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
///               
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.PathwayOrdSrv","QryCPWLocOrdByDate","1","2019-02-16","2019-04-02","","","","2,3")
Query QryCPWLocOrdByDate(aDateType As %String, aDateFrom As %String, aDateTo As %String, aStatus As %String, aLocID As %String, aWardID As %String, aHospID As %String) As %Query(ROWSPEC = "ind:%String,CPWID:%String,CPWDesc:%String,EpisDesc:%String,ExecDescList:%String,CPWStatus:%String,InDate:%String,InTime:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutTime:%String,OutUserDesc:%String,OutLocDesc:%String,aEpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate:%String,InHospDate:%Integer,PatCost:%Integer,PAAdmType:%String,reqNum:%Integer,IsOptionNum:%Integer,ecReqNum:%Integer,ecIsOptionNum:%Integer,outCPWOrdNum:%Integer,perEcReqNum:%String,perEcIsOptionNum:%String,peroutCPWOrdNum:%String") [ SqlProc ]
{
}

ClassMethod QryCPWLocOrdByDateExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aStatus As %String, aLocID As %String, aWardID As %String, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateType="")||(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	
 	Set IndexName=$Case(aDateType,"1":"IdxofInLocDate","2":"IdxofOutLocDate")
 	Set xLocID=""
 	For {
	 	Set xLocID=$o(^DHCMA.CPW.CP.PathwayI(IndexName,xLocID))
	 	Quit:xLocID=""
	 	
	 	Continue:(aLocID'="")&&(aLocID'=$p(xLocID,"!!",1))
	 	Set xHospID=+$p($g(^CTLOC(($p(xLocID,"!!",1)))),"^",22)
	 	Continue:(aHospID'="")&&(aHospID'[xHospID)
	 	
	 	Set xDate=aDateFrom-1
	 	For {
		 	Set xDate=$o(^DHCMA.CPW.CP.PathwayI(IndexName,xLocID,xDate))
		 	Quit:xDate=""
		 	Quit:xDate>aDateTo
		 	
		 	Set xCPWID=""
		 	For {
		 		Set xCPWID=$o(^DHCMA.CPW.CP.PathwayI(IndexName,xLocID,xDate,xCPWID))
		 		Quit:xCPWID=""
		 		
		 		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xCPWID)
		 		Continue:'$IsObject(objPathway)
		 		Continue:objPathway.CPFormDr.FormIsActive'=1
		 		Continue:objPathway.CPFormDr.FormIsOpen'=1
		 		Continue:objPathway.CPFormDr.FormVerDate=""
		 		
		 		Set Status=objPathway.CPStatus
		 		Continue:(aStatus'="")&&(aStatus'[Status)
		 		
		 		Set CPWData =  ##class(DHCMA.CPW.CPS.PathwaySrv).GetCPWData(objPathway)
		 		Set EpisodeID=objPathway.CPEpisodeID
		 		Set PatData =  ..GetPatData(EpisodeID)
		 		
		 		//过滤门诊
		 		Set PAAdmType=$lg(PatData,12)
		 		Continue:PAAdmType["O"
		 		//过滤未出院信息
		 		Set DischDate=$lg(PatData,9)
		 		//Continue:DischDate=""
		 		Set OrdData = ..GetOrdData(objPathway)
		 		
				Set Data=$lb(ind)_CPWData_PatData_OrdData
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
		 	}
	 	}
 	}
 	
 	Quit $$$OK
}

ClassMethod QryCPWLocOrdByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWLocOrdByDateExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWLocOrdByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWLocOrdByDateExecute ]
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
/// CreatDate：   2020-03-31
/// Description:  按日期查询单个路径医嘱情况
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
///               
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.PathwayOrdSrv","QryCPWPathOrdByDate","1","2019-02-16","2019-04-02","","","","2,3")
Query QryCPWPathOrdByDate(aDateType As %String, aDateFrom As %String, aDateTo As %String, aStatus As %String, aWardID As %String, aHospID As %String) As %Query(ROWSPEC = "ind:%String,PathDesc:%String,PathPerNum:%Integer,pathInHospDateAvg:%Integer,PathCostAvg:%Integer,PathOrdNumAvg:%Integer,PathReqNumAvg:%Integer,PathEcReqNumAvg:%Integer,PathIsOptionNumAvg:%Integer,PathEcIsOptionNumAvg:%Integer,PathOutCPWOrdNumAvg:%Integer,PerEcReqNum:%String,PerPathOutCPWOrdNum:%String") [ SqlProc ]
{
}

ClassMethod QryCPWPathOrdByDateExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aStatus As %String, aWardID As %String, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateType="")||(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	
 	Set IndexName=$Case(aDateType,"1":"IdxofInLocDate","2":"IdxofOutLocDate")
 	
 	Set apathMastID=""
 	For{
		Set apathMastID=$O(^DHCMA.CPW.BT.PathMastD(apathMastID))
		Quit:apathMastID=""
		
		Set PathDesc=""
		Set PathPerNum=0
		Set pathInHospDate=0
		Set PathCost=0
		//Set pathMedicineCost=0  //药品费用
		//Set pathMedOrdUseNum=0  //路境外医嘱使用率
		Set PathOrdNum=0
		Set PathReqNum=0
		Set PathEcReqNum=0
		Set PathIsOptionNum=0
		Set PathEcIsOptionNum=0
		Set PathOutCPWOrdNum=0
		//Set PathCost=0
		
		
	 	Set xLocID=""
	 	For {
		 	Set xLocID=$o(^DHCMA.CPW.CP.PathwayI(IndexName,xLocID))
		 	Quit:xLocID=""
		 	
		 	//Continue:(aLocID'="")&&(aLocID'=$p(xLocID,"!!",1))
		 	Set xHospID=+$p($g(^CTLOC(($p(xLocID,"!!",1)))),"^",22)
	 		Continue:(aHospID'="")&&(aHospID'[xHospID)
		 	
		 	Set xDate=aDateFrom-1
		 	For {
			 	Set xDate=$o(^DHCMA.CPW.CP.PathwayI(IndexName,xLocID,xDate))
			 	Quit:xDate=""
			 	Quit:xDate>aDateTo
			 	
			 	Set xCPWID=""
			 	For {
			 		Set xCPWID=$o(^DHCMA.CPW.CP.PathwayI(IndexName,xLocID,xDate,xCPWID))
			 		Quit:xCPWID=""
			 		
			 		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xCPWID)
			 		Continue:'$IsObject(objPathway)
			 		Set reqNum=0
					Set IsOptionNum=0
				 	Set ecReqNum=0
					Set ecIsOptionNum=0
					Set outCPWOrdNum=0
			 		
			 		Set Status=objPathway.CPStatus
			 		Continue:(aStatus'="")&&(aStatus'[Status)
			 		
			 		Set CPWData =  ##class(DHCMA.CPW.CPS.PathwaySrv).GetCPWData(objPathway)
			 		Set EpisodeID=objPathway.CPEpisodeID
			 		Set PatData =  ##class(DHCMA.CPW.CPS.PathwaySrv).GetPatData(EpisodeID)
			 		
			 		//过滤门诊
			 		Set PAAdmType=$lg(PatData,12)
			 		Continue:PAAdmType["O"
			 		//过滤未出院信息
			 		Set DischDate=$lg(PatData,9)
			 		//Continue:DischDate=""
			 		
			 		Set PatCosts=$lg(PatData,11)
			 		Set PatCost = $e(PatCosts,0,($l(PatCosts)-1))
			 		
			 		Set InHospDate=$lg(PatData,10)
			 		
			 		Set PathFormOrdID =objPathway.CPFormDr.FormPathDr.%Id()
			 		Continue:PathFormOrdID'=apathMastID
			 		Set PathDesc = objPathway.CPFormDr.FormPathDr.BTDesc
			 		Set BTIsActive = objPathway.CPFormDr.FormPathDr.BTIsActive
			 		Continue:BTIsActive'=1
			 		Set OrdData = ..GetOrdData(objPathway)
			 		
				 	Set pathFormID = objPathway.CPFormDr
				 	
				 	Set reqNum=$lg(OrdData,1)
				 	Set IsOptionNum=$lg(OrdData,2)
				 	Set ecReqNum=$lg(OrdData,3)
				 	Set ecIsOptionNum=$lg(OrdData,4)
				 	Set outCPWOrdNum=$lg(OrdData,5)
				 	
				 	Set PathPerNum=PathPerNum+1
					Set pathInHospDate=pathInHospDate+InHospDate
					Set PathCost=PathCost+PatCost
					Set PathOrdNum=PathOrdNum+(reqNum+IsOptionNum+outCPWOrdNum)
					Set PathReqNum=PathReqNum+reqNum
					Set PathEcReqNum=PathEcReqNum+ecReqNum
					Set PathIsOptionNum=PathIsOptionNum+IsOptionNum
					Set PathEcIsOptionNum=PathEcIsOptionNum+ecIsOptionNum
					Set PathOutCPWOrdNum=PathOutCPWOrdNum+outCPWOrdNum
				 	}
			 	}
		 	}
		 	
	 		Continue:PathDesc=""
	 		Set PerEcReqNum=0.00_"%"
	 		Set PerPathOutCPWOrdNum =0.00_"%"
	 		Set pathInHospDateAvg=$fn(pathInHospDate/PathPerNum,"",2)
	 		Set PathCostAvg = $fn(PathCost/PathPerNum,"",2)
	 		Set PathOrdNumAvg = $fn(PathOrdNum/PathPerNum,"",2)
	 		Set PathReqNumAvg = $fn(PathReqNum/PathPerNum,"",2)
	 		Set PathEcReqNumAvg = $fn(PathEcReqNum/PathPerNum,"",2)
	 		Set PathIsOptionNumAvg = $fn(PathIsOptionNum/PathPerNum,"",2)
	 		Set PathEcIsOptionNumAvg = $fn(PathEcIsOptionNum/PathPerNum,"",2)
	 		Set PathOutCPWOrdNumAvg = $fn(PathOutCPWOrdNum/PathPerNum,"",2)
	 		Set:PathReqNumAvg>0 PerEcReqNum = ($fn((PathEcReqNumAvg/PathReqNumAvg)*100,"",2))_"%"
	 		Set:PathOrdNumAvg>0 PerPathOutCPWOrdNum = ($fn((PathOutCPWOrdNumAvg/PathOrdNumAvg)*100,"",2))_"%"
	 		
	 		
		 	Set Data=$lb(ind,PathDesc,PathPerNum,pathInHospDateAvg,PathCostAvg,PathOrdNumAvg,PathReqNumAvg,PathEcReqNumAvg,PathIsOptionNumAvg,PathEcIsOptionNumAvg,PathOutCPWOrdNumAvg,PerEcReqNum,PerPathOutCPWOrdNum)			
		 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
 		}
 	
 	Quit $$$OK
}

ClassMethod QryCPWPathOrdByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWPathOrdByDateExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWPathOrdByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWPathOrdByDateExecute ]
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
/// CreatDate：   2020-03-31
/// Description:  按日期查询单个路径医嘱情况
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
///               
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.PathwayOrdSrv","QryCPWOrdItemByDate","1")
Query QryCPWOrdItemByDate(aPathwayID As %String) As %Query(ROWSPEC = "ind:%Integer,OrdMastID:%String,OrdMastIDDesc:%String,OrdPriorityID:%String,OrdPriorityIDDesc:%String,OrdIsDefault:%String,OrdIsFluInfu:%String,OrdIsActive:%String,ItemID:%String,ItemDesc:%String,pathFormEpDesc:%String,IsExOrdDesc:%String,ItemIsOption:%String") [ SqlProc ]
{
}

ClassMethod QryCPWOrdItemByDateExecute(ByRef qHandle As %Binary, aPathwayID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aPathwayID="") $$$OK
 	
 	Set objPathway = ##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Set aPathFormID=objPathway.CPFormDr.%Id()
 	
 	
 	Set aPathwayVarID=""
	For{
		 	Set aPathwayVarID=$O(^DHCMA.CPW.CP.PathwayD(aPathwayID,"VAR",aPathwayVarID))
		 	Quit:aPathwayVarID=""
		 	Set objPathwayVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_aPathwayVarID)
		 	Continue:'$IsObject(objPathwayVar)
		 	Set aCPImplDr=objPathwayVar.CPImplDr
		 	Set aCPIsActive=objPathwayVar.CPIsActive
		 	Continue:aCPImplDr'=""
		 	Continue:aCPIsActive=1
		 	Set CPOrdDID=objPathwayVar.CPOrdDID
		 	Set (OrdMastID,OrdMastIDDesc,OrdPriorityID,OrdPriorityIDDesc,OrdIsDefault,OrdIsFluInfu,OrdIsActive,ItemID,ItemDesc,pathFormEpDesc,IsExOrdDesc,ItemIsOption)=""
		 	
		 	Set OrdInfo = ##class(DHCCPW.MRC.FORM.LnkArcimSrv).GetArcimInfoById(CPOrdDID)
		 	Set OrdMastIDDesc = $p(OrdInfo,"^",20)  //医嘱名
			Set OrdGeneID = $p(OrdInfo,"^",15) 
			Set OrdGeneIDDesc = $p(OrdInfo,"^",16)  //通用名
			
			Set OrdIsDefault="否"
			Set ItemIsOption="否"
			Set IsExOrdDesc="已执行"
			
				 	
		 	Set Data=$lb(ind,OrdMastID,OrdMastIDDesc,OrdPriorityID,OrdPriorityIDDesc,OrdIsDefault,OrdIsFluInfu,OrdIsActive,ItemID,ItemDesc,pathFormEpDesc,IsExOrdDesc,ItemIsOption)
		 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	}
 	 	
	Set aPathFormEpisID=""
	For{
			Set aPathFormEpisID=$O(^DHCMA.CPW.BT.PathFormD(aPathFormID,"EP",aPathFormEpisID))
			Quit:aPathFormEpisID=""
			Set aPathFormEpDr=aPathFormID_"||"_aPathFormEpisID
			Set objPathEp = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aPathFormEpDr)
			Quit:'$IsObject(objPathEp)
			Set pathFormEpDesc = objPathEp.EpDesc
			
			Set aPathFormItemID= ""
			For{
				Set aPathFormItemID=$O(^DHCMA.CPW.BT.PathFormD(aPathFormID,"EP",aPathFormEpisID,"ITM",aPathFormItemID))
				Quit:aPathFormEpisID=""
				Set aPathFormEpItemDr=aPathFormID_"||"_aPathFormEpisID_"||"_aPathFormItemID
				
				Set xChildID=""
 	
			 	Set objItm = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aPathFormEpItemDr)
				Quit:'$IsObject(objItm)
			 	Set ItemDesc = objItm.ItemDesc
				Set ItemID = aPathFormEpItemDr
				Set ItemIsOption=objItm.ItemIsOption
				
			 	For {
				 	Set xChildID = $o(^DHCMA.CPW.BT.PathFormD(aPathFormID,"EP",aPathFormEpisID,"ITM",aPathFormItemID,"ORD",xChildID))
				 	Quit:xChildID=""
				 	
					Set obj = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(aPathFormEpItemDr_"||"_xChildID)
					Continue:'$IsObject(obj)
					Set xID = obj.%Id()
					Set (OrdTypeDr,OrdTypeDrDesc,OrdMastID,OrdMastIDDesc,OrdGeneID,OrdGeneIDDesc)=""
					//医嘱类型 指向OEC_Priority  频次 指向PHC_Freq  疗程 指向PHC_Duration 
					Set (OrdPriorityID,OrdPriorityIDDesc,OrdQty,OrdFreqID,OrdFreqIDDesc,OrdDuratID,OrdDuratIDDesc)=""
				 	//用法 指向PHCInstruc  单位 指向CTUOM
				 	Set (OrdInstrucID,OrdInstrucIDDesc,OrdDoseQty,OrdUOMID,OrdUOMIDDesc,OrdNote,OrdChkPosID,OrdLnkOrdDr,OrdIsDefault,OrdIsFluInfu,OrdIsActive)=""
				 	Continue:'$Isobject(obj.OrdTypeDr)
				 	Set OrdTypeDr = obj.OrdTypeDr.%Id()
				 	Set OrdTypeDrDesc = obj.OrdTypeDr.BTDesc
				 	Set OrdMastID =obj.OrdMastID
				 	Continue:OrdMastID=""
				 	//取医嘱信息、通用名
				 	Set OrdInfo = ##class(DHCCPW.MRC.FORM.LnkArcimSrv).GetArcimInfoById(OrdMastID)
				 	Set OrdMastIDDesc = $p(OrdInfo,"^",20)  //医嘱名
				 	Set OrdGeneID = $p(OrdInfo,"^",15) 
				 	//Set:PHCGeneID'="" OrdGeneIDDesc=$p($g(^PHCGE("GE",OrdGeneID)),"^",2)
				 	Set OrdGeneIDDesc = $p(OrdInfo,"^",16)  //通用名
				 	Set OrdPriorityID = obj.OrdPriorityID
				 	Set OrdPriorityIDDesc=$p($g(^OECPR(OrdPriorityID)),"^",2)
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
				 	Set:OrdUOMID'="" OrdUOMIDDesc=$p($g(^CT("UOM",OrdUOMID)),"^",3)
				 	
				 	//dsp 显示医嘱维护的数量单位
				 	Set (OrdQtyUOMDesc,OrdQtyUOMID)=""
				 	if ($p(OrdMastID,"||",2)'=""){
				 		Set OrdQtyUOMID=$p($g(^ARCIM(+OrdMastID,$p(OrdMastID,"||",2),8)),"^",14) 
				 		Set:OrdQtyUOMID'="" OrdQtyUOMDesc = $p($g(^CT("UOM",OrdQtyUOMID)),"^",2)
				 	}
				 	  
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
				 	Set:ItemIsOption=0 ItemIsOption="是"
				 	Set:ItemIsOption=1 ItemIsOption="否"
				 	If (OrdChkPosID'=""){
					 	Set PosDesc = $p(OrdChkPosID,"||",1)
					 	Set OrdMastIDDesc = OrdMastIDDesc_" "_PosDesc
					 }
				 	Set IsExOrd = ..getOrdIsExceFlg(aPathwayID,xID)
				 	Set IsExOrdDesc="未执行"
				 	Set:IsExOrd=1 IsExOrdDesc="已执行"
				 	
				 	Set Data=$lb(ind,OrdMastID,OrdMastIDDesc,OrdPriorityID,OrdPriorityIDDesc,OrdIsDefault,OrdIsFluInfu,OrdIsActive,ItemID,ItemDesc,pathFormEpDesc,IsExOrdDesc,ItemIsOption)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1	
			 	}
				
			}
			
		}
		 
 	Quit $$$OK
}

ClassMethod QryCPWOrdItemByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWOrdItemByDateExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWOrdItemByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWOrdItemByDateExecute ]
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

/// ##class(DHCMA.CPW.CPS.PathwayOrdSrv).GetOrdData()
ClassMethod GetOrdData(objPathway As DHCMA.CPW.CP.Pathway) As %List
{
	New (objPathway)
	Set return=$Lb("")
	Quit:'$IsObject(objPathway) return
	
	Set pathwayId = objPathway.%Id()
	Set pathFormId = objPathway.CPFormDr.%Id()
	set (reqNum,IsOptionNum,ecReqNum,ecIsOptionNum,outCPWOrdNum,perEcReqNum,perEcIsOptionNum,peroutCPWOrdNum)=0
	
	Set aPathEpID=""
	For{
		Set aPathEpID = $O(^DHCMA.CPW.BT.PathFormD(pathFormId,"EP",aPathEpID))
		Quit:aPathEpID=""
		Set objPathEp = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(pathFormId_"||"_aPathEpID)
		Quit:'$IsObject(objPathEp)
		Set PathEpID=objPathEp.%Id()
		
		Set aPathEpItemID =""
		For{
			Set aPathEpItemID = $O(^DHCMA.CPW.BT.PathFormD(pathFormId,"EP",aPathEpID,"ITM",aPathEpItemID))
			Quit:aPathEpItemID=""
			Set objPathEpItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(pathFormId_"||"_aPathEpID_"||"_aPathEpItemID)
			Quit:'$IsObject(objPathEpItem)
			Continue:objPathEpItem.ItemCatDr.BTTypeDr.BTDesc'="重点医嘱"
			Set PathEpItemID = objPathEpItem.%Id()
			
			Set aPathFormOrdID = ""
			For{
				Set aPathFormOrdID= $O(^DHCMA.CPW.BT.PathFormD(pathFormId,"EP",aPathEpID,"ITM",aPathEpItemID,"ORD",aPathFormOrdID))
				Quit:aPathFormOrdID=""
				Set pathFormOrdID =pathFormId_"||"_aPathEpID_"||"_aPathEpItemID_"||"_aPathFormOrdID
				Set objPathFormOrd = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(pathFormOrdID)
				Quit:'$IsObject(objPathFormOrd)

				Set ItemISOption = objPathEpItem.ItemIsOption
				Set:ItemISOption=0 reqNum=reqNum+1
				Set:ItemISOption=1 IsOptionNum=IsOptionNum+1
				Set ecflg=0
				Set ecflg=..getOrdIsExceFlg(pathwayId,pathFormOrdID)

				Set:ItemISOption=0&&ecflg=1 ecReqNum=ecReqNum+1
				Set:ItemISOption=1&&ecflg=1 ecIsOptionNum=ecIsOptionNum+1
				}
			
			}

		}
	Set aOutCPWOrdID=""
	For{
		Set aOutCPWOrdID=$O(^DHCMA.CPW.CP.PathwayD(pathwayId,"VAR",aOutCPWOrdID))
		Quit:aOutCPWOrdID=""
		Set objPathwayVar = ##class(DHCMA.CPW.CP.PathwayVar).GetObjById(pathwayId_"||"_aOutCPWOrdID)
		Quit:'$IsObject(objPathwayVar)
		Set:objPathwayVar.CPImplDr="" outCPWOrdNum=outCPWOrdNum+1
		}
	Set (perEcReqNum,perEcIsOptionNum,peroutCPWOrdNum)=0.00_"%"
	Set:reqNum>0 perEcReqNum =($fn((ecReqNum/reqNum)*100,"",2))_"%"
	Set:IsOptionNum>0 perEcIsOptionNum =($fn((ecIsOptionNum/IsOptionNum)*100,"",2))_"%"
	Set:(reqNum+IsOptionNum)>0 peroutCPWOrdNum=($fn((outCPWOrdNum/(reqNum+IsOptionNum))*100,"",2))_"%"
	
	Set Data=$lb(reqNum,IsOptionNum,ecReqNum,ecIsOptionNum,outCPWOrdNum,perEcReqNum,perEcIsOptionNum,peroutCPWOrdNum)
	
	Set return=Data
	Quit return
}

ClassMethod getOrdIsExceFlg(pathwayId As %String, pathFormOrdID As %String) As %String
{
	
	new (pathwayId,pathFormOrdID)
	Set ecflg = 0
	Set aPathwayImplID=""
	For{
		Set aPathwayImplID=$O(^DHCMA.CPW.CP.PathwayD(pathwayId,"IMPL",aPathwayImplID))
		Quit:aPathwayImplID=""
		Set aPathwayOrdID=""
		For{
			Set aPathwayOrdID=$O(^DHCMA.CPW.CP.PathwayD(pathwayId,"IMPL",aPathwayImplID,"ORD",aPathwayOrdID))
			Quit:aPathwayOrdID=""

			Set objPathwayOrd = ##class(DHCMA.CPW.CP.PathwayOrd).GetObjById(pathwayId_"||"_aPathwayImplID_"||"_aPathwayOrdID)
			Quit:'$IsObject(objPathwayOrd)
			Quit:objPathwayOrd.CPFormOrdDr=""
			
			Set:objPathwayOrd.CPFormOrdDr.%Id()=pathFormOrdID ecflg=1
			}
		}
	Quit ecflg
}

ClassMethod GetPatData(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=$Lb("")
	Quit:aEpisodeID="" return
	
	set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(aEpisodeID)
	Quit:'$IsObject(objPat) return
	
	Set PatientID=objPat.PAPatientID
	Set PapmiNo=objPat.PAPapmiNo
	Set MrNo=objPat.PAMrNo
	Set PatName=objPat.PAPatName
	Set PatSex=objPat.PASex
	Set PatSex=$Case(PatSex,"F":"女","M":"男",:"")
	Set PatAge=objPat.PAAge
	Set AdmDate=objPat.PAAdmDate
	Set DischDate=objPat.PADischDate
	Set InHospDate=$Case(DischDate'="",1: DischDate-AdmDate,0:+$H-AdmDate)   //住院天数
	Set:InHospDate=0 InHospDate=1
	Set InHospDate=InHospDate
	Set AdmDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set DischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	
	Set paadm=$p(aEpisodeID,"!!",1)
	Set Feestr=##class(web.DHCCPW.MR.Interface).GetAdmCateFee(paadm)
	Set PatCost=$p(Feestr,"^",1)		//住院总费用。。。
	Set PAAdmType=objPat.PAAdmType

	Set Data=$lb(aEpisodeID,PatientID,PapmiNo,MrNo,PatName,PatSex,PatAge,AdmDate,DischDate,InHospDate,PatCost,PAAdmType)
	Set return=Data
	
	Quit return
}

}
