Class DHCMA.VTE.DI.OREDR Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-08-16
/// Description:  查询医嘱信息
/// Table：       
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.VTE.DI.OREDR","QryOrdItemList",88,"2020-08-18","2020-08-18")
Query QryOrdItemList(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "OEItemID:%String,ArcimCode:%String,ArcimDesc:%String,ArcOrdType:%String,ArcCatDesc:%String,ArcSubCatDesc:%String,OrderDate:%String,OrderTime:%String,UpdateDate:%String,UpdateTime:%String,PriorityDr:%String,PriorityDesc:%String,XDate:%String,XTime:%String,OrdStatusDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOrdItemListExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set $ZT="AutoTaskErr"
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set OrdID=$o(^OEORD(0,"Adm",+aEpisodeID,""))
	Quit:OrdID="" $$$OK
	
	If $d(^OEORDi(0,"XDate")) {
		//新开医嘱
		For xSttDate=aDateFrom:1:aDateTo{
			Set xSubID=0
			For {
				Set xSubID=$o(^OEORDi(0,"StDt",xSttDate,OrdID,xSubID))
				Quit:xSubID=""
				
				Set OrdItemInfo=$g(^OEORD(OrdID,"I",xSubID,1))
				Continue:OrdItemInfo=""
				Do BuildQryOrdItemList
			}
		}
		//新停止、作废、撤销医嘱
		For xEndDate=aDateFrom:1:aDateTo{
			Set xSubID=0
			For {
				Set xSubID=$o(^OEORDi(0,"XDate",xEndDate,OrdID,xSubID))
				Quit:xSubID=""
				
				Set OrdItemInfo=$g(^OEORD(OrdID,"I",xSubID,"1"))
				Continue:OrdItemInfo=""
				Do BuildQryOrdItemList
			}
		}
		
	}Else {
	    Set xSubID=0
	    For {
		    Set xSubID=$o(^OEORD(OrdID,"I",xSubID))
		    Quit:xSubID=""
		    Set SttDate = $p($g(^OEORD(OrdID,"I",xSubID,1)),"^",9)  // 开始日期 
		    Continue:(SttDate'="")&&(SttDate>aDateTo)
	    	Set XDate = $p($g(^OEORD(OrdID,"I",xSubID,3)),"^",34)   // 停止日期 
	     	Continue:(XDate'="")&&(XDate<aDateFrom)
	     	Continue:(SttDate<aDateFrom)&&(XDate="")
	     	Set OrdItemInfo=$g(^OEORD(OrdID,"I",xSubID,"1"))
			Continue:OrdItemInfo=""
			Do BuildQryOrdItemList
	    }
	}
	Quit $$$OK
	
BuildQryOrdItemList
	Set ArcimID=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",2)
	//手术申请、会诊申请等具体信息
	Set ArcimDep = $g(^OEORD(OrdID,"I",xSubID,"DEP",1))
	Quit:ArcimID=""
	//医嘱状态（核实、执行、...）
	Set OrdStatusDr=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",13)
	Set OrdStatusCode=$p($g(^OEC("OSTAT",+OrdStatusDr)),"^",1)
	Set OrdStatusDesc=$p($g(^OEC("OSTAT",+OrdStatusDr)),"^",2)
	Quit:(OrdStatusDesc["作废")||(OrdStatusDesc["撤销")    //过滤作废、撤销医嘱
	
	Set OrderDate=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",9)		//开医嘱日期
	Set OrderTime=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",10)		//开医嘱时间
	Set UpdateDate=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",19)		//更新医嘱日期
	Set UpdateTime=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",20)		//更新医嘱时间
	
	//医嘱类型（长期、临时）
	Set PriorityDr=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",8)
	Set PriorityDesc=$p($g(^OECPR(+PriorityDr)),"^",2)
	//停医嘱日期、时间
	Set XDate=$p($g(^OEORD(OrdID,"I",xSubID,3)),"^",34)              //停医嘱日期
	Set XTime=$p($g(^OEORD(OrdID,"I",xSubID,2)),"^",15)		        //停医嘱时间
	//if (XDate = ""){
	//	Set XDate = OrderDate
	//	Set XTime = OrderTime
	//}
	
	Set ArcimCode=$p($g(^ARCIM(+ArcimID,1,1)),"^",1)		//医嘱项代码
	Set ArcimDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)_ArcimDep		//医嘱项名称
	//Quit:(ArcimDesc'["自费药房")&&(ArcimDesc["费")
	Set ArcSubCatDr=$p($g(^ARCIM(+ArcimID,1,1)),"^",10)
	Set ArcSubCatDesc=$p($g(^ARC("IC",+ArcSubCatDr)),"^",2)	//医嘱子类
	Set ArcCatDr=$p($g(^ARC("IC",+ArcSubCatDr)),"^",8)
	Set ArcCatDesc=$p($g(^OEC("ORCAT",+ArcCatDr)),"^",2) 	//医嘱大类
	Set ArcOrdType=$p($g(^ARC("IC",+ArcSubCatDr)),"^",7)	//医嘱类型（药品R、检验L）
	Quit:ArcSubCatDesc=""
	
	//过滤皮试医嘱
	Set PHCInstrID = $p($g(^OEORD(OrdID,"I",xSubID,2)),"^",7)
	If PHCInstrID'=""{
		Set PHCInstrDesc=$p($g(^PHCIN(+PHCInstrID)),"^",2)
		Quit:PHCInstrDesc["皮试"
		Set PHCInstrDesc=$p($g(^PHCIN(+PHCInstrID)),"^",3)
		Quit:PHCInstrDesc["皮试"
	}
	
	
	Set Data=$lb(OrdID_"||"_xSubID,ArcimCode,ArcimDesc,ArcOrdType,ArcCatDesc,ArcSubCatDesc,OrderDate,OrderTime,UpdateDate,UpdateTime,PriorityDr,PriorityDesc,XDate,XTime,OrdStatusDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
AutoTaskErr
	Quit $$$OK
}

ClassMethod QryOrdItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrdItemListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOrdItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrdItemListExecute ]
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

}
