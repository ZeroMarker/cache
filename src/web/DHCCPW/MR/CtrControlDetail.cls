/// 个人详细信息查询
Class web.DHCCPW.MR.CtrControlDetail Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyang
/// CreatDate：   2011-02-14
/// Description:  获取查询临床路径监控的单个病人详细信息
/// Input：       Paadm(就诊号),PathWayID(出入径记录ID),ItemRowID(路径项目ID)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.CtrControlDetail","QryCPWCtlOrderDetail","73237","2")
Query QryCPWCtlOrderDetail(argPaadm As %String, argPathWayID As %String) As %Query(ROWSPEC = "StepItem:%String:项目,ArcimID:%String,ArcimDesc:%String:医嘱名称,IsComplete:%String:是否完成,IsNumberCorrect:%String:数量是否合适,Index:%String,Qty:%String:数量,StepItemID:%String")
{
}

ClassMethod QryCPWCtlOrderDetailExecute(ByRef qHandle As %Binary, argPaadm As %String, argPathWayID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	//Set Summary=##class(web.DHCCPW.MR.CtrModulePatSummary).GetPathWaySummary(argPathWayID)
	Set flg=##class(web.DHCCPW.MR.CtrModuleOrdControl).ProcessOrderControl(repid,argPathWayID)
	Set Cnt=0
	Set StepItemID=""
	For {
		s StepItemID=$o(^CacheTemp("CPWControl",repid,"paadm",argPaadm,"ARCIM",StepItemID))
		q:StepItemID=""
		Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
		continue:'$IsObject(objItem)
		d objItem.%Close()
		Set ItemDesc=objItem.CPWSIDesc
		s Cnt=""				
		For {
			Set Cnt=$o(^CacheTemp("CPWControl",repid,"paadm",argPaadm,"ARCIM",StepItemID,Cnt))
			Quit:Cnt=""
			
			Set ArcimData=$g(^CacheTemp("CPWControl",repid,"paadm",argPaadm,"ARCIM",StepItemID,Cnt,"Info"))
			Set ResultData=$g(^CacheTemp("CPWControl",repid,"paadm",argPaadm,"ARCIM",StepItemID,Cnt,"Result"))
			Set JudgeData=$g(^CacheTemp("CPWControl",repid,"paadm",argPaadm,"ARCIM",StepItemID,Cnt,"Judge"))
			Set ArcimID=$p(ArcimData,"^",1)   //医嘱项ID
			Set ArcimDesc=$p(ArcimData,"^",2) //医嘱名称
			Set Judge1=$p(JudgeData,"^",1)    //是否完成
			Set Judge2=$p(JudgeData,"^",2)    //数量是否合适
			Set Qty=$p(ResultData,"^",3)      //实际数量
			
			Set Data=$lb(ItemDesc,ArcimID,ArcimDesc,Judge1,Judge2,ind,Qty,StepItemID)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^CacheTemp("CPWControl",repid)
	
	Quit $$$OK
}

ClassMethod QryCPWCtlOrderDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWCtlOrderDetailExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryCPWCtlOrderDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWCtlOrderDetailExecute ]
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

/*
ClassMethod Test()
{
	//w ##class(web.DHCCPW.MR.CtrControlDetail).Test()
	d ##class(%Library.ResultSet).RunQuery("web.DHCCPW.MR.CtrControlDetail","QryCPWCtlOrderDetail",76547,1,"148||1||1||6")
	q "OK"
}
*/
}
