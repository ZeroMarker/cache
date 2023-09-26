/// 名称: DHCHAI.DI.DHS.SyncCSSDInfo
/// 描述: 同步东华消毒供应中心数据
/// 编写者：ShenChao
/// 编写日期: 2019-04-18
Class DHCHAI.DI.DHS.SyncCSSDInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：	ShenC
/// CreatDate:	2019-05-24
/// Description:同步消毒器械接口
/// Table：		DHCHAI.DI.DHS.SyncCSSDInfo
/// Input：		就诊号(aEpisodeIDX),开始日期(aDateFrom),结束日期(aDateTo)
/// Return： 	处理数
/// debug:      w ##class(DHCHAI.DI.DHS.SyncCSSDInfo).SyncCSSDByDateAdm("CSSD01","HIS01||35","2018-03-01","2018-03-01")
ClassMethod SyncCSSDByDateAdm(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return="",Count=0
	Quit:aSCode="" return
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return
	
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="CSSD" return  //消毒供应中心
	
	Set:aDateFrom'="" aDateFrom=##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set:aDateTo'="" aDateTo=##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	//就诊记录检查
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	//根据HIS下的就诊号调用消毒中心接口
	Set rs=##class(DHCHAI.DI.DIO.FromCSSDSrv).GetPkgInfoByPation(EpisodeID,"")
	quit:rs="" ""
	Set Count=1
	For
	{
		Set rsData = $p(rs,"#",Count)
		quit:rsData=""
		//更新数据
		Set CSSDDr = ##class(DHCHAI.DP.CSSDRecord).Update(rsData,"^")
		//记录错误
		If (+CSSDDr)<0 
		{
			//记录错误日志
			Set ErrClass  = "DHCHAI.DI.DHS.SyncCSSDInfo"
			Set ErrMethod = "SyncCSSDByDateAdm"
			Set ErrArgStr = $lb(CSSDDr)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}	
		//计数
		Set Count=Count+1
	}
	Set return=Count
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2019-05-20
/// Description:  查询消毒器械预警
/// Table：       DHCHAI.DP.CSSDRecord
/// Input:			DateFrom,DateTo,BatchNumberS  
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DHS.SyncCSSDInfo","QryCssdListLoc","1","2020-04-01","2020-06-01","")
Query QryCssdListLoc(iHospIDs As %String, iDateFrom As %String, iDateTo As %String, iBatchNumberS As %String) As %Query(ROWSPEC = "Desc:%String,BarCode:%String,LocDr:%String") [ SqlProc ]
{
}

ClassMethod QryCssdListLocExecute(ByRef qHandle As %Binary, iHospIDs As %String, iDateFrom As %String, iDateTo As %String, iBatchNumberS As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(iDateFrom="")||(iDateTo="") $$$OK
	//转化日期
	Set:iDateFrom'="" iDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(iDateFrom)
	Set:iDateTo'="" iDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(iDateTo) 	
 	Quit:(iDateFrom>iDateTo) $$$OK
 	//去重临时glb
 	Set NIndex = "QryCssdListLoc"
 	Kill ^TMP($zn,$j,NIndex)
	Set LocId=0
	For {
		Set LocId=$o(^DHCHAI.DP.CSSDRecordI("IndexLocDr",LocId))
		Quit:LocId=""
		
		Set LocCount=0,InfCount=0	//科室人数,科室感染人数
		Set CSSDId=0
		For{
			Set CSSDId=$o(^DHCHAI.DP.CSSDRecordI("IndexLocDr",LocId,CSSDId))
			Quit:CSSDId=""
			Set obj = ##class(DHCHAI.DP.CSSDRecord).GetObjById(CSSDId)
			Continue:'$Isobject(obj)
			
	   		Set EpisodeDr=obj.CSSDEpisodeDr								
	   		Continue:'$ISObject(EpisodeDr)
	   		Set EpisodeID=EpisodeDr.%Id()									//获取病人Id
	   		//院区过滤
			Set LocDr=EpisodeDr.PAAdmLocDr
			Set:$ISObject(LocDr) LocID=LocDr.%Id()
			Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
			Set HospDr=$li(LocData,8)
			Continue:(iHospIDs'="")&&(iHospIDs'[HospDr)		//过滤院区
			
	   		Set BatchNumberS=obj.CSSDBatchNumberS		//获取obj的灭菌批次
	   		Set SterilDate = obj.CSSDSterilDate			//获取灭菌日期
	   		Continue:(SterilDate>iDateTo)||(SterilDate<iDateFrom)	//过滤日期
	   		Continue:((iBatchNumberS'="")&(BatchNumberS'=iBatchNumberS))	//灭菌批次不同跳过
	   		if '$d(^TMP($zn,$j,NIndex,LocId,"PatAdm",EpisodeID)){
		   		Set LocCount=LocCount+1		//记录科室人数
		   		Set ^TMP($zn,$j,NIndex,LocId,"PatAdm",EpisodeID)=""
	   		}
	   		if '$d(^TMP($zn,$j,NIndex,LocId,"PatAdmInf",EpisodeID)){
		   		//判断是否感染
		   		Set LinkDiags=""
		  		Set RepType=""
		   		For 
		   		{
					Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",EpisodeID,RepType))
					Quit:RepType=""
					Continue:(RepType'="1")
					Set xID = ""
					For
					{
						Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",EpisodeID,RepType,xID))
						Quit:xID=""
						Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
						Continue:'$IsObject(objINFRep)
						Set RepStatus=objINFRep.IRStatusDr
						Continue:'$IsObject(RepStatus)       
						Continue:(RepStatus.BTCode'="2")&(RepStatus.BTCode'="3")	 //2 提交 3 审核
						// 感染诊断信息
						Set LinkDiags=objINFRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
					}
				}			
				Set:LinkDiags'="" InfCount=InfCount+1		//记录科室感染人数
				Set ^TMP($zn,$j,NIndex,LocId,"PatAdmInf",EpisodeID)=""
	   		}
		}
		//Continue:(LocCount=0)&&(InfCount=0)
		Continue:(InfCount=0)
		Set LocDr= ##class(DHCHAI.BT.Location).GetObjById(LocId) 
		Continue:'$ISObject(LocDr) 	
		Set LocDesc=LocDr.BTDesc_"("_LocDr.BTCode_")"							//根据科室Id取科室名称
		Set Data=$lb(LocDesc,LocCount,InfCount)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryCssdListLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCssdListLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCssdListLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCssdListLocExecute ]
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

// w ##class(DHCHAI.BT.Location).GetObjByLocCode("ZYMZ003","血液内科门诊")

/// Creator：	ShenC
/// CreatDate:	2019-07-29
/// Description:查询科室人员
/// Table：		DHCHAI.DI.DHS.SyncCSSDInfo
/// Input：		科室信息(iLocInfo),开始日期(iDateFrom),结束日期(iDateTo),灭菌批次(iBatNumS)
/// Return： 	处理数
/// debug:      d ##class(%ResultSet).RunQuery("DHCHAI.DI.DHS.SyncCSSDInfo","LocInfoTracking","血液(ZYMZ043)","2020-04-21","2020-08-02","")
Query LocInfoTracking(iLocInfo As %String, iDateFrom As %String, iDateTo As %String, iBatNumS As %String) As %Query(ROWSPEC = "PatName:%String,PatBedNo:%String,CssdDesc:%String,CssdBarCode:%String,CssdClean:%String,CssdCleanUser:%String,CssdStril:%String,CssdStrilUser:%String,CssdSend:%String,CssdSendUser:%String,CssdBack:%String,CssdBackUser:%String,CssdInfDiagnos:%String") [ SqlProc ]
{
}

ClassMethod LocInfoTrackingExecute(ByRef qHandle As %Binary, iLocInfo As %String, iDateFrom As %String, iDateTo As %String, iBatNumS As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:iLocInfo="" $$$OK
	Set LocCode=$p($p(iLocInfo,"(",2),")",1)
	Set LocId=$o(^DHCHAI.BT.LocationI("IndexLocCode",LocCode,0))		//获取科室id
	Quit:(iDateFrom="")||(iDateTo="") $$$OK
	//转化日期
	Set:iDateFrom'="" iDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(iDateFrom)
	Set:iDateTo'="" iDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(iDateTo) 	
 	Quit:(iDateFrom>iDateTo) $$$OK
	
	Set CssdId=0
	For
	{
		Set CssdId=$o(^DHCHAI.DP.CSSDRecordI("IndexLocDr",LocId,CssdId))
		Quit:CssdId=""
		Set obj = ##class(DHCHAI.DP.CSSDRecord).GetObjById(CssdId)
		Continue:'$Isobject(obj)
		
		Set SterilDate = obj.CSSDSterilDate			//获取灭菌日期
	   	continue:((SterilDate'="")&((SterilDate>iDateTo)||(SterilDate<iDateFrom)))	//灭菌日期为空默认输出
	   	Set BatNumS=obj.CSSDBatchNumberS								//获取obj的灭菌批次
	   	continue:((iBatNumS'="")&(BatNumS'=iBatNumS))					//灭菌批次不同跳过
	   	
	   	Set CssdDesc=obj.CSSDDesc
	   	Set CssdBarCode=obj.CSSDBarCode_"&nbsp;"
	   	Set Patobj=obj.CSSDEpisodeDr									//查找病人obj							
	   	Set aEpisodeID=Patobj.%Id()										//获取病人Id
	   	Set PatName=Patobj.PAPatName									//获取病人姓名	 
	   	Set PatBedNo=Patobj.PAAdmBedDr.BTDesc_"&nbsp"							//获取病人床位号
	   	Set CssdSend=obj.CSSDSendDate
	   	Set CssdSendUser=obj.CSSDSendUser
	   	Set:CssdSendUser["|" CssdSendUser=$p(CssdSendUser,"|",3)
	   	Set CssdClean=obj.CSSDCleanDate
	   	Set CssdCleanUser=obj.CSSDCleanUser
	   	Set:CssdCleanUser["|" CssdCleanUser=$p(CssdCleanUser,"|",3)
	   	Set CssdStril=obj.CSSDSterilDate
	   	Set CssdStrilUser =obj.CSSDSterilUser
	   	Set:CssdStrilUser["|" CssdStrilUser=$p(CssdStrilUser,"|",3)
	   	Set CssdBack=obj.CSSDBackDate
	   	Set CssdBackUser=obj.CSSDBackUser
	   	Set:CssdBackUser["|" CssdBackUser=$p(CssdBackUser,"|",3)
	   	
	   	Set CssdInfDiagnos=obj.CSSDInfDiagnos
	   	//获取感染信息
		Set RepType=0
		Set LinkDiags=""
	   	For 
	   	{
			Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
			Quit:RepType=""
			Continue:(RepType'="1")
			Set xID = ""
			For
			{
				Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
				Quit:xID=""
				
				Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
				Continue:'$IsObject(objINFRep)
				Set RepStatus=objINFRep.IRStatusDr
				Continue:'$IsObject(RepStatus)        
				Continue:(RepStatus.BTCode'=2)&(RepStatus.BTCode'=3)	//2 提交 3 审核
				// 感染诊断信息
				Set LinkDiagID=objINFRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
				Set LinkDiagDr=##class(DHCHAI.IR.INFDiagnos).GetObjById(LinkDiagID)
				Continue:'$IsObject(LinkDiagDr)
				Set IRInfDesc=LinkDiagDr.IRInfPosDr.BTDesc
				Set:LinkDiags'="" LinkDiags=LinkDiags_";"_IRInfDesc
				Set:LinkDiags="" LinkDiags=IRInfDesc
			}
		}
		Set CssdInfDiagnos=LinkDiags
		
	   	Set obj= ##class(DHCHAI.BT.Location).GetObjById(LocId)  	
		Set LocName=obj.BTDesc_"("_obj.BTCode_")"										//根据科室Id取科室名称
		
		Set:CssdClean'="" CssdClean=$zd(CssdClean,3)_"&nbsp"
		Set:CssdStril'="" CssdStril=$zd(CssdStril,3)_"&nbsp"
		Set:CssdSend'="" CssdSend=$zd(CssdSend,3)_"&nbsp"
		Set:CssdBack'="" CssdBack=$zd(CssdBack,3)_"&nbsp"
		
		Set Data=$lb(PatName,PatBedNo,CssdDesc,CssdBarCode,CssdClean,CssdCleanUser,CssdStril,CssdStrilUser,CssdSend,CssdSendUser,CssdBack,CssdBackUser,CssdInfDiagnos)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	Quit $$$OK
}

ClassMethod LocInfoTrackingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocInfoTrackingExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LocInfoTrackingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocInfoTrackingExecute ]
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

/// 库存请求
/// Author: lihui
/// Date: 20200721
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DHS.SyncCSSDInfo","QueryMatReq","2019-01-01","2020-07-21")
Query QueryMatReq(StartDate, EndDate) As %Query(ROWSPEC = "reqitmid:%String,ReqLocid:%String,ReqLoc:%String,ssuserid:%String,ssuser:%String,date:%String,Incsc:%String,InciCode:%String,InciDesc:%String,Spec:%String,Uom:%String,qty:%String,regUser:%String,regDate:%String,remark:%String") [ SqlProc ]
{
}

ClassMethod QueryMatReqExecute(ByRef qHandle As %Binary, StartDate, EndDate) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 s StartDate=$zdh(StartDate,3)
 s EndDate=$zdh(EndDate,3)
 f date=StartDate:1:EndDate   d
 .s ReqId=""
 .f  s ReqId=$O(^INRQ(0,"Date",date,ReqId)) q:ReqId=""  d
 ..q:'$d(^INRQ(ReqId))
 ..s reginfo=^INRQ(ReqId)
 ..s ReqLocid=$p(reginfo,"^",6)
 ..s ReqLoc=$p(^CTLOC(ReqLocid),"^",2)
 ..s ssuserid=$p(reginfo,"^",4)
 ..s ssuser=""
 ..s:ssuserid'="" ssuser=$p(^SSU("SSUSR",ssuserid),"^",2)
 ..s chl=0
 ..f  s chl=$o(^INRQ(ReqId,"RQI",chl)) q:chl=""  d
 ...q:'$d(^INRQ(ReqId,"RQI",chl))
 ...s reqitmid=ReqId_"||"_chl
 ...s reqitminfo=^INRQ(ReqId,"RQI",chl)
 ...s inci=$p(reqitminfo,"^",4)
 ...s dhcid=$o(^DHCITMINFO(0,"INCI",inci,""))
 ...q:dhcid=""
 ...s incscid=$p(^INCI(inci,2),"^",2)
 ...q:incscid=""
 ...s Incsc=$s(incscid'="":$p(^INC("SC",incscid),"^",2),1:"")
 ...s Spec=$p(^DHCITMINFO(dhcid),"^",27)
 ...s InciCode=$p(^INCI(inci,1),"^",1)
 ...s InciDesc=$p(^INCI(inci,1),"^",2)
 ...s qty=$p(reqitminfo,"^",3)
 ...s Uomid=$p(reqitminfo,"^",5)
 ...s Uom=$p(^CT("UOM",Uomid),"^",2)
 ...s dhcinreqitmid=$o(^DHCINRQI(0,"INRQI",reqitmid,""))
 ...i dhcinreqitmid'="" d
 ....s remark=$p(^DHCINRQI(dhcinreqitmid),"^",2)
 ...s regUser=""
 ...s regDate=""
 ...d OutputRowMatReq
 Quit $$$OK
 
OutputRowMatReq	
 s Data=$lb(reqitmid,ReqLocid,ReqLoc,ssuserid,ssuser,date,Incsc,InciCode,InciDesc,Spec,Uom,qty,regUser,regDate,remark)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
}

ClassMethod QueryMatReqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMatReqExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryMatReqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMatReqExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 出库数据 医政
/// Author: lihui
/// Date: 20200922
/// OutPut：唯一ID,科室ID,科室名称,出库审核人ID,审核人,日期,物资代码,物资名称,规格,单位,数量,,,备注,库存分类ID,库存分类代码,库存分类名称,医院
/// 参考 d ##class(%ResultSet).RunQuery("web.DHCSTMService.ServiceForOthHRP.QueryAllMatInfoUI","QueryMatTrf","2020-01-01","2022-11-07",181,"")
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DHS.SyncCSSDInfo","QueryMatTrf","2022-06-01","2022-07-01",106,"")
Query QueryMatTrf(StartDate, EndDate, LocStr, IncscIdStr) As web.DHCSTMHUI.Query(ROWSPEC = "TrId:%String,Loc:%String,LocDesc:%String,AuditUserid:%String,AuditUser:%String,Date:%String,InciCode:%String,InciDesc:%String,Spec:%String,BUomDesc:%String,TrQtyB:%String,regUser:%String,regDate:%String,remark:%String,Incsc:%String,IncscDesc:%String,IncscCode:%String,Hospital:%String,TrNo:%String") [ SqlProc ]
{
}

ClassMethod QueryMatTrfExecute(ByRef qHandle As %Binary, StartDate, EndDate, LocStr, IncscIdStr) As %Status
{
	n (qHandle,StartDate,EndDate,LocStr,IncscIdStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:LocStr="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	f Date=StartDate:1:EndDate d
	.s len=$l(LocStr,"^")
	.f i=1:1:len  d
	..s Loc=$p(LocStr,"^",i)
	..q:'$d(^CTLOC(Loc))
	..s LocDesc=$p(^CTLOC(Loc),"^",2) 	
	..s ItmDr=0
	..f  s ItmDr=$o(^INCI("IL_LOC",Loc,ItmDr)) q:ItmDr=""  d
	...q:$o(^DHCLOCTOT(0,"LOCITMDATE",Loc,ItmDr,Date+1),-1)=""
	...s Chl=$o(^INCI("IL_LOC",Loc,ItmDr,0))
	...s Incil=ItmDr_"||"_Chl
	...s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(ItmDr)
	...s ScgDesc=$p(StkGrpInfo,"^",2)
	...s Scg=$p(StkGrpInfo,"^",5)
	...s ScgType=$p(StkGrpInfo,"^",3)
	...q:ScgType'=##class(web.DHCSTMHUI.StkTypeM).sssCode()
	...s Incsc=$p(^INCI(ItmDr,2),"^",2)
	...q:(IncscIdStr'="")&&(("^"_IncscIdStr_"^")'[("^"_Incsc_"^"))
	...s IncscDesc=$p($g(^INC("SC",Incsc)),"^",2) 
	...s IncscCode=$p($g(^INC("SC",Incsc)),"^",1)
	...s InciCode = $p(^INCI(ItmDr,1),"^",1)
	...s InciDesc = $p(^INCI(ItmDr,1),"^",2)
	...s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",ItmDr)
	...s BillUomStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcBuomByInc(ItmDr)
	...s BillUomDr=$P(BillUomStr,"^",1)
	...s BillUomDesc=$P(BillUomStr,"^",2)
	...s BUomId=$p(^INCI(ItmDr,1),"^",10)
	...s BUomDesc=$s(BUomId'="":$p(^CT("UOM",BUomId),"^",2),1:"")
	...s PurUomId=$p(^INCI(ItmDr,3),"^",6)
	...s PurUomDesc=$s(PurUomId'="":$p(^CT("UOM",PurUomId),"^",2),1:"")
	...s Factor=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	...s HospId=$p(^CTLOC(Loc),"^",22)
	...s Hospital=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	...s TrId="" 
	...f  s TrId=$o(^DHCINTR(0,"INCI",ItmDr,Date,TrId)) q:TrId=""  d
	....q:'$d(^DHCINTR(TrId))
	....s Inclb=$p(^DHCINTR(TrId),"^",7)
	....q:Inclb=""
	....s TmpIncil=$p(Inclb,"||",1,2)
	....q:Incil'=TmpIncil           ;非统计科室库存
	....s Incib=$p(^INCI(ItmDr,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1) ;批次指针
	....s (BatNo,ExpDate)=""
	....i Incib'=""  d
	.....s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	.....s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	.....s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	....s TrType=$p(^DHCINTR(TrId),"^",1)                                         ;交易类型
	....q:(TrType'="T")&&(TrType'="K")
	....s TrPointer=$p(^DHCINTR(TrId),"^",9)                                         ;交易指针
	....s InIstrfinfo=^DHCINIT(+TrPointer)
	....s inititminfo=^DHCINIT(+TrPointer,"ITI",$p(TrPointer,"||",2))
	....s reqitmid=$p(inititminfo,"^",2)  ;申请单ID
	....s (OperLoc,AuditUserid,AuditUser)=""
	....i TrType="T" d
	.....s OperLoc=$p(InIstrfinfo,"^",5)
	.....s AuditUserid=$p(InIstrfinfo,"^",11)
	.....s AuditUser=$p(^SSU("SSUSR",AuditUserid),"^",2)
	....i TrType="K" d
	.....s OperLoc=$p(InIstrfinfo,"^",6)
	....q:OperLoc'=Loc
	....s TrUom=$p(^DHCINTR(TrId),"^",10)                                        ;交易单位
	....s TrQty=$p(^DHCINTR(TrId),"^",6)                                         ;交易数量
	....s TrNo=$p(^DHCINTR(TrId),"^",13)                                        ;交易号
	....s TrUser=$p(^DHCINTR(TrId),"^",11)                                     ;交易人
	....s OperateUser=""
	....s:TrUser'="" OperateUser=$p(^SSU("SSUSR",TrUser),"^",2)
	....s TrTime=$p(^DHCINTR(TrId),"^",3)
	....s TrSp=$p(^DHCINTR(TrId),"^",14)        ;业务发生的售价
	....s TrRp=$p(^DHCINTR(TrId),"^",16)        ;业务发生的进价
	....s TrSpAmt=$p(^DHCINTR(TrId),"^",8)        ;售价金额
	....s TrRpAmt=$p(^DHCINTR(TrId),"^",17)        ;进价金额
	....s StkQty=$p(^DHCINTR(TrId),"^",18)        ;结余库存量
	....s StkLbQty=$p(^DHCINTR(TrId),"^",19)        ;结余库存量(批次)
	....s FacTr=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,BUomId)
	....s TrQtyB=TrQty*FacTr              ;基本单位数量
	....s BUomSp=TrSp/FacTr               ;基本单位售价
	....s PurUomSp=BUomSp*Factor          ;包装单位售价
	....s BUomRp=TrRp/FacTr    //##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId) ;批次进价(基本单位)
	....s PurUomRp=BUomRp*Factor            ;批次进价(包装单位)
	....s PurUomRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PurUomRp,HospId,1)
	....s Manf=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	....i Manf'=""  s Manf=$p(Manf,"^",2)
	....s VendorInfo=""   //##class(web.DHCSTMHUI.Common.DrugStkCommon).GetInclbVend(Inclb,Date)  ;该批次对应的最后一次入库的供应商
	....s Vendor=$p(VendorInfo,"^",2)
	....s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(TrType,TrPointer)
	....s (regUserid,regUser,regDate)=""
	....i reqitmid'="" d
	.....s reqinfo=^INRQ(+reqitmid)
	.....s regUserid=$p(reqinfo,"^",4)
	.....s regUser=$s(regUserid'="":$p(^SSU("SSUSR",regUserid),"^",2),1:"")
	.....s regDate=$p(reqinfo,"^",2)
	.....s:regDate'="" regDate=$zd(regDate,3)
	....d OutputRowQueryMatTrf
	Quit $$$OK
OutputRowQueryMatTrf
	s Data=$lb(TrId,Loc,LocDesc,AuditUserid,AuditUser,Date,InciCode,InciDesc,Spec,BUomDesc,TrQtyB,regUser,regDate,remark,Incsc,IncscDesc,IncscCode,Hospital,TrNo)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

}
