/// 名称: web.DHCCPW.MR.ClinPathWaysOrderList
/// 描述: 临床路径 医嘱相关内容
/// 编写者：zhufei
/// 编写日期: 2012-05-14
Class web.DHCCPW.MR.ClinPathWaysOrderList Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-05-14
/// Description:  取医嘱列表
/// Input：       EpisodeID
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysOrderList","QryOrderList",77205,"")
Query QryOrderList(aEpisodeID As %String, aType As %String) As %Query(ROWSPEC = "OEItemID:%String,ItmNumber:%String,ItmPriorityID:%String,ItmPriority:%String,ItmStartDate:%String,ItmStartTime:%String,ItmArcimID:%String,ItmArcim:%String,ItmFreqID:%String,ItmFreq:%String,ItmInstrucID:%String,ItmInstruc:%String,ItmQty:%String,ItmPackUomID:%String,ItmPackUom:%String,ItmDoseQty:%String,ItmUnitID:%String,ItmUnit:%String,ItmExecuteTime:%String,ItmResume:%String")
{
}

ClassMethod QryOrderListExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:aEpisodeID="" $$$OK
	Set OrdID=$o(^OEORD(0,"Adm",+aEpisodeID,0))
	Quit:OrdID="" $$$OK
	
	//^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})
	Set ItmNumber=0
	Set SubID=0
	For {
		Set SubID=$o(^OEORD(OrdID,"I",SubID))
		Quit:SubID=""
		
		Set OeoriStatus=""
		Set OeoriStatusID=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",13)
		Set:OeoriStatusID'="" OeoriStatus=$p($g(^OEC("OSTAT",OeoriStatusID)),"^",1)
		Continue:OeoriStatus=""
		Continue:OeoriStatus["D"  //医嘱状态  停止
		Continue:OeoriStatus["I"  //医嘱状态  未审核
		
		Set (OEItemID,ItmPriorityID,ItmPriority,ItmStartDate,ItmStartTime)=""
		Set (ItmArcimID,ItmArcim,ItmFreqID,ItmFreq,ItmInstrucID,ItmInstruc)=""
		Set (ItmQty,ItmPackUomID,ItmPackUom,ItmExecuteTime,ItmResume)=""
		
		Set OEItemID=OrdID_"||"_SubID
		
		Set ItmPriorityID=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",8)
		Set:ItmPriorityID'="" ItmPriority=$p($g(^OECPR(ItmPriorityID)),"^",2)
		
		Set ItmStartDate=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",9)
		Continue:ItmStartDate<(+$h-2)
		Set:ItmStartDate'="" ItmStartDate=$zd(ItmStartDate,3)
		Set ItmStartTime=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",10)
		Set:ItmStartTime'="" ItmStartTime=$zt(ItmStartTime,2)
		
		Set ItmArcimID=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",2)
		Set:ItmArcimID'="" ItmArcim=$p($g(^ARCIM(+ItmArcimID,+$p(ItmArcimID,"||",2),1)),"^",2)
		
		Set ItmFreqID=$p($g(^OEORD(OrdID,"I",SubID,2)),"^",4)
		If ItmFreqID'=""
		{
			Set ItmFreq=$p($g(^PHCFR(ItmFreqID)),"^",3)
			
			Set PHCDTSub=0
			For {
				Set PHCDTSub=$o(^PHCFR(ItmFreqID,"DT",PHCDTSub))
				Quit:PHCDTSub=""
				Set PHCDTTime=$g(^PHCFR(ItmFreqID,"DT",PHCDTSub))
				Set PHCDTTime=$zt(PHCDTTime,2)
				Set:(+$p(PHCDTTime,":",2)=0) PHCDTTime=$p(PHCDTTime,":",1)
				Set ItmExecuteTime=ItmExecuteTime_"，"_PHCDTTime
			}
			Set:ItmExecuteTime'="" ItmExecuteTime=$e(ItmExecuteTime,2,$l(ItmExecuteTime))
		}
		
		Set ItmInstrucID=$p($g(^OEORD(OrdID,"I",SubID,2)),"^",7)
		Set:ItmInstrucID'="" ItmInstruc=$p($g(^PHCIN(ItmInstrucID)),"^",2)
		
		Set ItmQty=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",18)     //数量
		Set ItmPackUomID=$p($g(^ARCIM(+ItmArcimID,+$p(ItmArcimID,"||",2),8)),"^",14)
		Set:ItmPackUomID'="" ItmPackUom=$p($g(^CT("UOM",ItmPackUomID)),"^",2)
		
		Set ItmDoseQty=$p($g(^OEORD(OrdID,"I",SubID,2)),"^",1)  //剂量
		Set ItmUnitID=$p($g(^OEORD(OrdID,"I",SubID,2)),"^",3)   //剂量单位
		Set:ItmUnitID'="" ItmUnit=$p($g(^CT("UOM",ItmUnitID)),"^",2)
		
		Set ItmResume=$g(^OEORD(OrdID,"I",SubID,"DEP"))
		
		Set ItmNumber=ItmNumber+1
		Set Data=$lb(OEItemID,ItmNumber,ItmPriorityID,ItmPriority,ItmStartDate,ItmStartTime,ItmArcimID,ItmArcim,ItmFreqID,ItmFreq,ItmInstrucID,ItmInstruc,ItmQty,ItmPackUomID,ItmPackUom,ItmDoseQty,ItmUnitID,ItmUnit,ItmExecuteTime,ItmResume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrderListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrderListExecute ]
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

/// w ##Class(web.DHCCPW.MR.ClinPathWaysOrderList).GetOEOrdItemRowData("78||1||1||5-78||1||1-2||1^1^1,78||1||1||6-78||1||1-2||1^1^1,78||1||1||7-78||1||1-2||1^1^1,78||1||1||8-78||1||1-2||1^1^1,78||1||1||8-78||1||1-2||1^3^3")
ClassMethod GetOEOrdItemRowData(aStepItemSels As %String) As %String
{
	New (aStepItemSels)
	Set return=""
	Quit:aStepItemSels="" return
	
	Set ItmNumber=0
	For i=1:1:$length(aStepItemSels,",") {
		Set StepItem=$P(aStepItemSels,",",i)
		Set xStepItemID=$P(StepItem,"^",1)
		Set StepItemID=$p(xStepItemID,"-",1)
		Set ArcimSeqNo=$P(StepItem,"^",2)
		Continue:(StepItemID="")||(ArcimSeqNo="")
		
		Set (ItmPriorityID,ItmPriority)=""
		Set (ItmArcimID,ItmArcim,ItmFreqID,ItmFreq,ItmInstrucID,ItmInstruc)=""
		Set (ItmQty,ItmPackUomID,ItmPackUom,ItmExecuteTime,ItmResume)=""
		
		Set ItmInd=ArcimSeqNo
		Set obj=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
		Continue:'$IsObject(obj)
		Set objArcim=obj.CPWSIARCIM.GetAt(ItmInd)
		Continue:'$IsObject(objArcim)
		
		Set ItmPriorityID=objArcim.ITMPriority
		Set:ItmPriorityID'="" ItmPriority=$p($g(^OECPR(ItmPriorityID)),"^",2)
		
		Set ItmArcimID=objArcim.ITMARCIMDR
		If (ItmArcimID'="")
		{
			If ($l(ItmArcimID,"||")=2)
			{
				set ItmArcim=$p($g(^ARCIM(+$p(ItmArcimID,"||",1),+$p(ItmArcimID,"||",2),1)),"^",2)
				set effDateFrom=$p($g(^ARCIM(+$p(ItmArcimID,"||",1),+$p(ItmArcimID,"||",2),1)),"^",13)
				set:effDateFrom'="" effDateFrom=$p(effDateFrom,"Z",1)
				set effDateTo=$p($g(^ARCIM(+$p(ItmArcimID,"||",1),+$p(ItmArcimID,"||",2),7)),"^",1)
			}Else{
				set ItmArcim=$p($g(^ARCOS(+ItmArcimID)),"^",2)
				set ItmArcim="[医嘱套]"_ItmArcim
				set effDateFrom=$p($g(^ARCOS(+ItmArcimID)),"^",15)
				set effDateTo=$p($g(^ARCOS(+ItmArcimID)),"^",16)
			}
		}
		Continue:(ItmArcimID="")||(ItmArcim="")
		Continue:((effDateFrom'="")&&(effDateFrom>(+$h)))
		Continue:((effDateTo'="")&&(effDateTo<(+$h)))
		
		Set ItmFreqID=objArcim.ITMFreqDR
		If ItmFreqID'=""
		{
			Set ItmFreq=$p($g(^PHCFR(ItmFreqID)),"^",3)
			
			Set PHCDTSub=0
			For {
				Set PHCDTSub=$o(^PHCFR(ItmFreqID,"DT",PHCDTSub))
				Quit:PHCDTSub=""
				Set PHCDTTime=$g(^PHCFR(ItmFreqID,"DT",PHCDTSub))
				Set PHCDTTime=$zt(PHCDTTime,2)
				Set:(+$p(PHCDTTime,":",2)=0) PHCDTTime=$p(PHCDTTime,":",1)
				Set ItmExecuteTime=ItmExecuteTime_"，"_PHCDTTime
			}
			Set:ItmExecuteTime'="" ItmExecuteTime=$e(ItmExecuteTime,2,$l(ItmExecuteTime))
		}
		
		Set ItmInstrucID=objArcim.ITMInstrucDR
		Set:ItmInstrucID'="" ItmInstruc=$p($g(^PHCIN(ItmInstrucID)),"^",2)
		
		Set ItmQty=objArcim.ITMQty
		
		Set ItmPackUomID=$p($g(^ARCIM(+ItmArcimID,+$p(ItmArcimID,"||",2),8)),"^",14)
		Set:ItmPackUomID'="" ItmPackUom=$p($g(^CT("UOM",ItmPackUomID)),"^",2)
		
		Set ItmResume=objArcim.ITMResume
		
		Set RowData=ItmPriorityID
		Set RowData=RowData_$c(1)_ItmPriority
		Set RowData=RowData_$c(1)_ItmArcimID
		Set RowData=RowData_$c(1)_ItmArcim
		Set RowData=RowData_$c(1)_ItmFreqID
		Set RowData=RowData_$c(1)_ItmFreq
		Set RowData=RowData_$c(1)_ItmInstrucID
		Set RowData=RowData_$c(1)_ItmInstruc
		Set RowData=RowData_$c(1)_ItmQty
		Set RowData=RowData_$c(1)_ItmPackUomID
		Set RowData=RowData_$c(1)_ItmPackUom
		Set RowData=RowData_$c(1)_ItmExecuteTime
		Set RowData=RowData_$c(1)_ItmResume
		Set RowData=RowData_$c(1)_StepItem
		
		Set return=return_$c(2)_RowData
	}
	
	Quit return
}

}
