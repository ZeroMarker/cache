/// 数据中心-医嘱数据处理
Class DHCMA.CPW.SD.DataSrv.OrderInfoSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 同步医嘱明细信息
/// w ##class(DHCMA.CPW.SD.DataSrv.OrderInfoSrv).SynOrdInfo(1,"2897965")
ClassMethod SynOrdInfo(aSYSDr As %String = "1", aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	Set return=""
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aEpisodeID="")&&((aDateFrom="")||(aDateTo="")) return
	Set:aEpisodeID["!!" aEpisodeID=$p(aEpisodeID,"!!",1)
	Set Count=0
	Set AdmStr = $g(^PAADM(aEpisodeID))
	Set AdmType= $p(AdmStr,"^",2)       //就诊类型
	Quit:(AdmType'="I")&(AdmType'="E") $$$OK
	//获取已对照医嘱，只同步对照医嘱信息
	Set LindOrdStr=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr()
	Quit:LindOrdStr="" return
	Set xOrdID=$o(^OEORD(0,"Adm",aEpisodeID,0))
	Quit:xOrdID="" return
	Set xChildID=0
	For {
		Set xChildID=$o(^OEORD(xOrdID,"I",xChildID))
		Quit:xChildID=""
		Set ItemMastID=$p($g(^OEORD(xOrdID,"I",xChildID,1)),"^",2)
		Set xOID=ItemMastID_"!!"_aSYSDr
		Set xOrdMast=##class(DHCMA.Util.EP.OrdMast).xGetByOID(xOID)
		Continue:'$IsObject(xOrdMast)
		Set OrdMastID=xOrdMast.%Id()
		Continue:("^"_LindOrdStr_"^")'[("^"_OrdMastID_"^")
		Set OEItemID=xOrdID_"||"_xChildID
		Set ret=..BuildOEItemInfo(aEpisodeID,OEItemID)
		Set:ret>0 Count=Count+1
	}
	Quit Count
}

ClassMethod BuildOEItemInfo(aEpisodeID As %String, OEORIRowId As %String) As %List
{
	New (aEpisodeID,OEORIRowId)
	Set return=""
	Quit:+OEORIRowId=0 return
	Quit:'$d(^OEORD(+OEORIRowId)) return
	Set OEORIChildsub=+$p(OEORIRowId,"||",2)
	Quit:'$d(^OEORD(+OEORIRowId,"I",OEORIChildsub)) return
	Set xID=$o(^DHCMA.CPW.SD.Data.OrderInfoI("IdxAdmOEItem",aEpisodeID,OEORIRowId,0))
	If (xID="") {
		Set obj=##class(DHCMA.CPW.SD.Data.OrderInfo).%New()
	}else{
		Set obj=##class(DHCMA.CPW.SD.Data.OrderInfo).%OpenId(xID)	
	}
	Set obj.EpisodeID=aEpisodeID
	Set obj.OEItemID=OEORIRowId
	Set obj.ARCMastID = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,1)),"^",2) 	// 医嘱项指针 ARC_ItmMast
	Set obj.OEARCDesc = $p($g(^ARCIM(+obj.ARCMastID,$p(obj.ARCMastID,"||",2),1)),"^",2)	//医嘱名
	Set obj.OESttDate = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,1)),"^",9) 	// 开始日期 
	Set obj.OESttTime = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,1)),"^",10) 	// 开始时间 
	Set obj.OEStatus = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,1)),"^",13) 	// 医嘱状态 OEC_ItemStatus  U：未审核，删除医嘱用;I:未激活,实习医生开医嘱用
	Set obj.OEPriority = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,1)),"^",8) // 医嘱类型 OEC_Priority
	Set obj.OEDoseQty = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,2)),"^",1) 	// 剂量 
	Set obj.OEDoseQtyUom = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,2)),"^",3) // 剂量单位 CT_Unit
	Set obj.OEFreqDesc = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,2)),"^",4) 	// 频率 PHC_Freq
	Set obj.OEInstruc = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,2)),"^",7) 	// 用法 PHC_Instruction
	;Set obj.OEORIDate = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,3)),"^",7) 	// 开医嘱日期 
	;Set obj.OEORITime = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,3)),"^",15) // 开医嘱时间 
	Set obj.OEXDate = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,3)),"^",34) 	// 停止日期 
	Set obj.OEXTime = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,2)),"^",15) 	// 停止时间 
	Set SttDateHtml=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(obj.OESttDate)
	Set xDateHtml=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(obj.OEXDate)
	Set obj.OESttDateT=SttDateHtml_" "_$zt(obj.OESttTime,1)
	Set obj.OEXDateT=xDateHtml_" "_$zt(obj.OEXTime,1)

	//OEORI_ItemStat_DR	医嘱状态 指向 OEC_OrderStatus
	Set:+obj.OEStatus'=0 obj.OEStatus=$p($g(^OEC("OSTAT",+obj.OEStatus)),"^",1)
	//OEORI_Unit_DR	剂量单位 指向 CT_UOM
	Set:+obj.OEDoseQtyUom'=0 obj.OEDoseQtyUom=$p($g(^CT("UOM",+obj.OEDoseQtyUom)),"^",1)
	//OEORI_PHFreq_DR	频率	PHC_Freq
	Set:+obj.OEFreqDesc'=0 obj.OEFreqDesc=$p($g(^PHCFR(+obj.OEFreqDesc)),"^",4)
	//OEORI_Instr_DR	用法 指向 PHC_Instruc
	Set:+obj.OEInstruc'=0 obj.OEInstruc=$p($g(^PHCIN(+obj.OEInstruc)),"^",2)
	Set:+obj.OEPriority'=0 obj.OEPriority=$p($g(^OECPR(+obj.OEPriority)),"^",1)
	/// 药品通用名
	Set obj.OEGeneric=""
	/// 管制分类
	Set obj.OEAntDrgPoison=""
	/// 使用目的
	Set obj.OEAntUsePurpose=""
	/// 是否送检
	Set obj.OEAntIsSubmiss=""
	/// 术前几小时使用抗菌药物
	Set obj.OEAntiAHours=""
	/// 术后几小时停止使用抗菌药物
	Set obj.OEAntiBHours=""
	//获取首末次医嘱执行日期时间
	Set xExcuteID="0",FirstExecDate="",LastExecDate="",FirstExecTime="",LastExecTime=""
	For {
		Set xExcuteID=$o(^OEORD(+OEORIRowId,"I",OEORIChildsub,"X",xExcuteID))
		Quit:xExcuteID=""
		Set ExcuteInfo=$g(^OEORD(+OEORIRowId,"I",OEORIChildsub,"X",xExcuteID))
		Continue:ExcuteInfo=""
		Set OEStatus=$p(ExcuteInfo,"^",16)
		Set OEExcuteDate=$p(ExcuteInfo,"^",19)
		Set OEExcuteTime=$p(ExcuteInfo,"^",20)
		Continue:OEStatus'="1" ;过滤非执行状态医嘱
		Set:FirstExecDate="" FirstExecDate=OEExcuteDate,FirstExecTime=OEExcuteTime
		Set LastExecDate=OEExcuteDate,LastExecTime=OEExcuteTime
	}
	Set obj.FirstExecDate=FirstExecDate
	Set obj.FirstExecTime=FirstExecTime
	Set obj.LastExecDate=LastExecDate
	Set obj.LastExecTime=LastExecTime
	
	Set SkinTest=$p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,5)),"^",2)
	Set obj.SkinTest=$s(SkinTest="Y":1,1:"0")
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SD.DataSrv.OrderInfoSrv","QryLinkOrderItem","1","185","15","1||277")
Query QryLinkOrderItem(aSYSDr As %String = "1", aEpisodeID As %String, aMrlistID As %String = "", aItemID As %String = "") As %Query(ROWSPEC = "ARCMastID,OEPriority,OEARCDesc,OEItemID,OEStatus,OESttDateT,OEXDateT,FirstExecDateT,LastExecDateT")
{
}

ClassMethod QryLinkOrderItemExecute(ByRef qHandle As %Binary, aSYSDr As %String = "1", aEpisodeID As %String, aMrlistID As %String = "", aItemID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set return="",aDicID="",aOEItemID="",SourceField=""
 	set ^tmpzgz1020=$lb(aSYSDr,aEpisodeID,aMrlistID,aItemID)
 	Quit:(aEpisodeID="") $$$OK
	If (aItemID'="") {
		//获取项目值对应的ObjectID
		Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",aMrlistID,aItemID,""),-1)
 		If (ESubID'="") {
			Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(aMrlistID_"||"_ESubID)
		 	Set ObjectID=ItemExecObj.ObjectID	
		 	set:ObjectID["OE" aOEItemID=$p(ObjectID,":",2)
			//根据配置信息，标记特定信息
		 	Set ConfigID=$o(^DHCMA.CPW.SD.QCItemDataConfigI("IdxItem",aItemID,0))
		 	Set objConfig=##class(DHCMA.CPW.SD.QCItemDataConfig).GetObjById(ConfigID)
		 	If ($IsObject(objConfig)) {
			 	Set StandDic=objConfig.StandDic
			 	Set StandDicSub=objConfig.StandDicSub
			 	Set:$IsObject(StandDic) aDicID=StandDic.%Id()
			 	Set:$IsObject(StandDicSub) aDicID=StandDicSub.%Id()
			 	Set SourceField=objConfig.SourceField
		 	}
		}
 	}
 	Set LinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(aDicID)
 	Quit:LinkOrder="" $$$OK
 	For OrdInd=1:1:$l(LinkOrder,"^") {
		Set EPOrderID=$P(LinkOrder,"^",OrdInd)
		Continue:EPOrderID=""
		Set objEPOrder=##class(DHCMA.Util.EPx.OrdMast).GetObjById(EPOrderID)
		Set ARCMastID=$p(objEPOrder.OID,"!!",1)
		Continue:ARCMastID=""
		Set xRowID=""
		For {
			Set xRowID=$o(^DHCMA.CPW.SD.Data.OrderInfoI("IdxAdmARC",aEpisodeID,ARCMastID,xRowID))
			Quit:xRowID=""
			Set objOrder=##class(DHCMA.CPW.SD.Data.OrderInfo).GetObjById(xRowID)
			Set OEItemID=objOrder.OEItemID
			Set FirstExecDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(objOrder.FirstExecDate)
			Set FirstExecTime=objOrder.FirstExecTime
			Set objOrder.FirstExecDateT=FirstExecDate_" "_$zt(FirstExecTime)
			Set LastExecDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(objOrder.LastExecDate)
			Set LastExecTime=objOrder.LastExecTime
			Set objOrder.LastExecDateT=LastExecDate_" "_$zt(LastExecTime)
			//根据执行医嘱、输出字段，标记输出内容
			If (SourceField'="")&&(aOEItemID=OEItemID) {
				Set $property(objOrder,SourceField)="*"_$property(objOrder,SourceField)	
			}elseif(aOEItemID=OEItemID) {
				//没有输出内容，应当标记整条医嘱记录
				Set OEItemID="*"_OEItemID
			}
			
			Set OESttDate=objOrder.OESttDate
			Set OESttTime=objOrder.OESttTime
			Continue:OESttDate=""
			Set OEStatus=objOrder.OEStatus	
			Set OEPriority=objOrder.OEPriority
			Set:OEPriority="" OEPriority="NORM"
			Set OEARCDesc=objOrder.OEARCDesc
			Set OEStatus=objOrder.OEStatus
			Continue:("CU"[OEStatus)
			//取各医嘱的执行记录
			Set OEORDId=$p(OEItemID,"||",1)
			Set SubId=$p(OEItemID,"||",2)
			Set SkinTest=objOrder.SkinTest
			Continue:SkinTest=1  ;皮试医嘱过滤
			Set OESttDateT=objOrder.OESttDateT
			Set OEXDateT=objOrder.OEXDateT
			Set FirstExecDateT=objOrder.FirstExecDateT
			Set LastExecDateT=objOrder.LastExecDateT
			Set Data=$lb(ARCMastID,OEPriority,OEARCDesc,OEItemID,OEStatus,OESttDateT,OEXDateT,FirstExecDateT,LastExecDateT)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
 	}
	Quit $$$OK
}

ClassMethod QryLinkOrderItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLinkOrderItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLinkOrderItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLinkOrderItemExecute ]
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
