/// 统计单病种上报指标信息
Class DHCMA.CPW.SDS.Stat.CAPStaService Extends DHCMA.CPW.SDS.Stat.CommonSrv [ Not ProcedureBlock ]
{

/// CAP（Cap-Adult-1）相关统计指标统计
/// 包含CRB-65 CURB-65 PSI SMART-COP
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.Stat.CAPStaService","QryIndexStat01","2","1","2019","","","","","4")
Query QryIndexStat01(aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String, aDateTo As %String, aLocID As %String, aQCEntityID As %String) As %Query(ROWSPEC = "DimenDesc:%String,LocDesc:%String,EntityDesc:%String,ValType:%String,Value:%Integer,MrID:%String,year:%String") [ SqlProc ]
{
}

ClassMethod QryIndexStat01Execute(ByRef qHandle As %Binary, aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String, aDateTo As %String, aLocID As %String, aQCEntityID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//获取统计类别和开始结束日期
	Set Params=..GetStatParams(aStaType,ayear,aQuarter,aDateFrom,aDateTo)
	Set DimenMark	= $p(Params,"^",1)
	Set aDateFrom	= $p(Params,"^",2)
	Set aDateTo		= $p(Params,"^",3)
	Set ArrayStatDimens=..GetArrayStatDimens(DimenMark,aDateFrom,aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")||(aQCEntityID="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
 	Set xCount=1
	//获取各个项目值
	For xDate=aDateFrom:1:aDateTo{
		Set xID=""
		For{
			Set xID=$o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xDate,xID))
			Quit:xID=""
			Set obj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set QCState=obj.QCState
			Continue:QCState="O"
			Set QCEntity=obj.QCEntityDr
			Continue:'$IsObject(QCEntity)
			Continue:(QCEntity.BTIsActive'=1)
			Set QCEntityID=QCEntity.%Id()
			Continue:(aQCEntityID'="")&&(aQCEntityID'=QCEntityID)
			Set QCEntityCode=QCEntity.BTCode
			Set QCEntityName=QCEntity.BTDesc
			Set EpisodeID=obj.QCEpisodeID
			Set InLocOID=obj.QCInLocID
			Set objInLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocOID)
			Set InLocDesc="",InLocID=""
			If ($IsObject(objInLoc)){
				Set InLocID=+InLocOID
				Set InLocDesc=objInLoc.BTDesc
			}
			Continue:(aLocID'="")&&(aLocID'=InLocID)
			Set objPaadm=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
			Continue:'$IsObject(objPaadm)
			Set Paadm=$P(EpisodeID,"!!",1)
			Set xSubRowID="",ValType="",Value=""
			For
		 	{	
		 		Set xSubRowID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfParref",aQCEntityID,xSubRowID))
		 		Quit:xSubRowID=""
		 		Set xRowID = aQCEntityID_"||"_xSubRowID
		 		Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(xRowID)
		 		continue:ObjEntityItem.BTCode'["Cap-Adult-1"
		 		Set ExecRowID="",ExecResult="",ExecResultText=""
		 		Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",xID,xRowID,""),-1)
				Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(xID_"||"_ESubID)
				Continue:'$IsObject(ItemExecObj)
				Set:ObjEntityItem.BTCode="Cap-Adult-1" ValType=ItemExecObj.ExecResult
				Set:ObjEntityItem.BTCode["Cap-Adult-1-1-" Value=+ItemExecObj.ExecResult
		 	}	
		 	Set DimenDesc=..GetDimenDesc(xDate,DimenMark)
		 	Set:DimenDesc="" DimenDesc=InLocDesc
		 	//如果统计维护不是标准年季度，则按照实际科室输出（暂不考虑全科室输出）
		 	if (ArrayStatDimens.Find(DimenDesc)="") {
			 		d ArrayStatDimens.SetAt(DimenDesc,xCount)
			 		Set xCount=xCount+1
			 	}
		 	Set ResultArr(DimenDesc,xID)=$lb(DimenDesc,InLocDesc,QCEntityName,ValType,Value,xID,year)
		}
	}
	for xind=1:1:ArrayStatDimens.Count()
	{
		Set xDimenDesc=ArrayStatDimens.GetAt(xind)
		Set xID=""
		if '$d(ResultArr(xDimenDesc)) {
				Set ^CacheTemp(repid,ind)=$lb(xDimenDesc)
				Set ind=ind+1
		}else{
			for {
					Set xID=$o(ResultArr(xDimenDesc,xID))
					Quit:xID=""
					Set Data=$g(ResultArr(xDimenDesc,xID))
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
		}
	}
	k ResultArr
	Quit $$$OK
}

ClassMethod QryIndexStat01Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIndexStat01Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIndexStat01Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIndexStat01Execute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.Stat.CAPStaService","QryIndexStat02","2","2019-06-01","2019-06-15","","4")
Query QryIndexStat02(aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String, aDateTo As %String, aLocID As %String, aQCEntityID As %String) As %Query(ROWSPEC = "DimenDesc:%String,LocDesc:%String,EntityDesc:%String,IsSPne:%Integer,IsLab:%Integer,AntiTime:%String,MrID:%String,year:%String") [ SqlProc ]
{
}

ClassMethod QryIndexStat02Execute(ByRef qHandle As %Binary, aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String, aDateTo As %String, aLocID As %String, aQCEntityID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//获取统计类别和开始结束日期
	Set Params=..GetStatParams(aStaType,ayear,aQuarter,aDateFrom,aDateTo)
	Set DimenMark	= $p(Params,"^",1)
	Set aDateFrom	= $p(Params,"^",2)
	Set aDateTo		= $p(Params,"^",3)
	Set ArrayStatDimens=..GetArrayStatDimens(DimenMark,aDateFrom,aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")||(aQCEntityID="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
 	Set xCount=1
	//获取各个项目值
	For xDate=aDateFrom:1:aDateTo{
		Set xID=""
		For{
			Set xID=$o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xDate,xID))
			Quit:xID=""
			Set obj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set QCState=obj.QCState
			Continue:QCState="O"
			Set QCEntity=obj.QCEntityDr
			Continue:'$IsObject(QCEntity)
			Continue:(QCEntity.BTIsActive'=1)
			Set QCEntityID=QCEntity.%Id()
			Continue:(aQCEntityID'="")&&(aQCEntityID'=QCEntityID)
			Set QCEntityCode=QCEntity.BTCode
			Set QCEntityName=QCEntity.BTDesc
			Set EpisodeID=obj.QCEpisodeID
			Set InLocOID=obj.QCInLocID
			Set objInLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocOID)
			Set InLocDesc="",InLocID=""
			If ($IsObject(objInLoc)){
				Set InLocID=+InLocOID
				Set InLocDesc=objInLoc.BTDesc
			}
			Continue:(aLocID'="")&&(aLocID'=InLocID)
			Set objPaadm=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
			Continue:'$IsObject(objPaadm)
			Set Paadm=$P(EpisodeID,"!!",1)
			Set xSubRowID="",IsSPne=0,IsLab=0,AntiTime="" //IsSPne 重症肺炎、IsLab 采集标本 、AntiTime治疗时机
			For
		 	{	
		 		Set xSubRowID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfParref",aQCEntityID,xSubRowID))
		 		Quit:xSubRowID=""
		 		Set xRowID = aQCEntityID_"||"_xSubRowID
		 		Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(xRowID)
		 		//重症肺炎、采集标本 、治疗时机对应单元格Code Cap-Adult-1-2-1 、Cap-Adult-3-1-1、Cap-Adult-3-1-2
		 		continue:((ObjEntityItem.BTCode'="Cap-Adult-1-2-1")&&(ObjEntityItem.BTCode'="Cap-Adult-3-1-1")&&(ObjEntityItem.BTCode'="Cap-Adult-3-1-2"))
		 		Set ExecRowID="",ExecResult="",ExecResultText=""
		 		Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",xID,xRowID,""),-1)
				Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(xID_"||"_ESubID)
				Continue:'$IsObject(ItemExecObj)
				Set:((ObjEntityItem.BTCode="Cap-Adult-1-2-1")&&(ItemExecObj.ExecResult="y")) IsSPne=1
				Set:((ObjEntityItem.BTCode="Cap-Adult-3-1-1")&&(ItemExecObj.ExecResult="y")) IsLab=1
				Set:(ObjEntityItem.BTCode="Cap-Adult-3-1-2") AntiTime=ItemExecObj.ExecResult
		 	}
		 	Set:IsSPne=0 IsLab=0,AntiTime="" //非重症肺炎，其他指标不统计
		 	Set DimenDesc=..GetDimenDesc(xDate,DimenMark)
		 	Set:DimenDesc="" DimenDesc=InLocDesc
		 	//如果统计维护不是标准年季度，则按照实际科室输出（暂不考虑全科室输出）
		 	if (ArrayStatDimens.Find(DimenDesc)="") {
			 		d ArrayStatDimens.SetAt(DimenDesc,xCount)
			 		Set xCount=xCount+1
			 	}
		 	Set ResultArr(DimenDesc,xID)=$lb(DimenDesc,InLocDesc,QCEntityName,IsSPne,IsLab,AntiTime,xID,year)
		}
	}
	for xind=1:1:ArrayStatDimens.Count()
	{
		Set xDimenDesc=ArrayStatDimens.GetAt(xind)
		Set xID=""
		if '$d(ResultArr(xDimenDesc)) {
				Set ^CacheTemp(repid,ind)=$lb(xDimenDesc)
				Set ind=ind+1
		}else{
			for {
					Set xID=$o(ResultArr(xDimenDesc,xID))
					Quit:xID=""
					Set Data=$g(ResultArr(xDimenDesc,xID))
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
		}
	}
	k ResultArr
	Quit $$$OK
}

ClassMethod QryIndexStat02Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIndexStat02Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIndexStat02Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIndexStat02Execute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.Stat.CAPStaService","QryIndexStat03","2","2019-06-01","2019-06-15","","4")
Query QryIndexStat03(aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String, aDateTo As %String, aLocID As %String, aQCEntityID As %String) As %Query(ROWSPEC = "DimenDesc:%String,LocDesc:%String,EntityDesc:%String,IsSPne:%Integer,IsO2Value:%Integer,SPScore:%Integer,MrID:%String,year:%String") [ SqlProc ]
{
}

ClassMethod QryIndexStat03Execute(ByRef qHandle As %Binary, aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String, aDateTo As %String, aLocID As %String, aQCEntityID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//获取统计类别和开始结束日期
	Set Params=..GetStatParams(aStaType,ayear,aQuarter,aDateFrom,aDateTo)
	Set DimenMark	= $p(Params,"^",1)
	Set aDateFrom	= $p(Params,"^",2)
	Set aDateTo		= $p(Params,"^",3)
	Set ArrayStatDimens=..GetArrayStatDimens(DimenMark,aDateFrom,aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")||(aQCEntityID="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
 	Set xCount=1
	//获取各个项目值
	For xDate=aDateFrom:1:aDateTo{
		Set xID=""
		For{
			Set xID=$o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xDate,xID))
			Quit:xID=""
			Set obj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set QCState=obj.QCState
			Continue:QCState="O"
			Set QCEntity=obj.QCEntityDr
			Continue:'$IsObject(QCEntity)
			Continue:(QCEntity.BTIsActive'=1)
			Set QCEntityID=QCEntity.%Id()
			Continue:(aQCEntityID'="")&&(aQCEntityID'=QCEntityID)
			Set QCEntityCode=QCEntity.BTCode
			Set QCEntityName=QCEntity.BTDesc
			Set EpisodeID=obj.QCEpisodeID
			Set InLocOID=obj.QCInLocID
			Set objInLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocOID)
			Set InLocDesc="",InLocID=""
			If ($IsObject(objInLoc)){
				Set InLocID=+InLocOID
				Set InLocDesc=objInLoc.BTDesc
			}
			Continue:(aLocID'="")&&(aLocID'=InLocID)
			Set objPaadm=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
			Continue:'$IsObject(objPaadm)
			Set Paadm=$P(EpisodeID,"!!",1)
			Set xSubRowID="",IsSPne=0,IsO2Value=0,SPScore=0 //重症肺炎、氧合评估、重症分值重症情况、
			For
		 	{	
		 		Set xSubRowID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfParref",aQCEntityID,xSubRowID))
		 		Quit:xSubRowID=""
		 		Set xRowID = aQCEntityID_"||"_xSubRowID
		 		Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(xRowID)
		 		//重症肺炎、氧合评估 、CURB-65 PSI评分 对应单元格Code Cap-Adult-1-2-1 、Cap-Adult-2-1、Cap-Adult-1-1-A、Cap-Adult-1-1-B
		 		continue:((ObjEntityItem.BTCode'="Cap-Adult-1-2-1")&&(ObjEntityItem.BTCode'="Cap-Adult-2-1")&&(ObjEntityItem.BTCode'["Cap-Adult-1-1-"))
		 		Set ExecRowID="",ExecResult="",ExecResultText=""
		 		Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",xID,xRowID,""),-1)
				Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(xID_"||"_ESubID)
				Continue:'$IsObject(ItemExecObj)
				Set:((ObjEntityItem.BTCode="Cap-Adult-1-2-1")&&(ItemExecObj.ExecResult="y")) IsSPne=1
				Set:((ObjEntityItem.BTCode="Cap-Adult-2-1")&&(ItemExecObj.ExecResult="y")) IsO2Value=1
				Set:((ObjEntityItem.BTCode="Cap-Adult-1-1-A")&&(ItemExecObj.ExecResult>2)) SPScore=1
				Set:((ObjEntityItem.BTCode="Cap-Adult-1-1-B")&&(ItemExecObj.ExecResult>90)) SPScore=1
		 	}
		 	Set DimenDesc=..GetDimenDesc(xDate,DimenMark)
		 	Set:DimenDesc="" DimenDesc=InLocDesc
		 	//如果统计维护不是标准年季度，则按照实际科室输出（暂不考虑全科室输出）
		 	if (ArrayStatDimens.Find(DimenDesc)="") {
			 		d ArrayStatDimens.SetAt(DimenDesc,xCount)
			 		Set xCount=xCount+1
			 	}
		 	Set ResultArr(DimenDesc,xID)=$lb(DimenDesc,InLocDesc,QCEntityName,IsSPne,IsO2Value,SPScore,xID,year)
		}
	}
	for xind=1:1:ArrayStatDimens.Count()
	{
		Set xDimenDesc=ArrayStatDimens.GetAt(xind)
		Set xID=""
		if '$d(ResultArr(xDimenDesc)) {
				Set ^CacheTemp(repid,ind)=$lb(xDimenDesc)
				Set ind=ind+1
		}else{
			for {
					Set xID=$o(ResultArr(xDimenDesc,xID))
					Quit:xID=""
					Set Data=$g(ResultArr(xDimenDesc,xID))
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
		}
	}
	k ResultArr
	Quit $$$OK
}

ClassMethod QryIndexStat03Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIndexStat03Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIndexStat03Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIndexStat03Execute ]
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
