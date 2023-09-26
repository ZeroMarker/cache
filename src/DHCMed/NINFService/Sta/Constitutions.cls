/// <H3>医院感染部位构成统计</H3>
/// <H4>创建者：李阳</H4>
/// <H4>创建时间：2012-07-30</H4>
Class DHCMed.NINFService.Sta.Constitutions Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 统计医院感染率
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.Constitutions","StaPercent","2008-1-1","2012-12-31",3,"","")
Query StaPercent(FromDate As %String, ToDate As %String, DepType As %Integer, LocList As %String, WardList As %String) As %Query(ROWSPEC = "PosName:%String:部位,InfNumber:%Integer:部位感染人数,Percent:%Float:比例") [ SqlProc ]
{
}

ClassMethod StaPercentExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, DepType As %Integer, LocList As %String, WardList As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	
	Set StoreID=##class(DHCMed.CCService.IntegratedCtrl.Common).GetEpisodeList(FromDate,ToDate,DepType,"I",LocList,WardList)
	Set locID=""	
	For {
		Set locID=$o(^CacheTemp("EpisodeList",StoreID,"DepWard",locID))
		Quit:locID=""
		Set wardID=""
		For {
			Set wardID=$o(^CacheTemp("EpisodeList",StoreID,"DepWard",locID,wardID))
			Quit:wardID=""
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^CacheTemp("EpisodeList",StoreID,"DepWard",locID,wardID,EpisodeID))
				Quit:EpisodeID=""
				Set arryPos=$$GetInfectionData(EpisodeID)
				For i=1:1:arryPos.Count() {
					Set objPos=arryPos.GetAt(i)
					Set ^CacheTemp(repid,"Pos",objPos.InfPos.Desc)=$g(^CacheTemp(repid,"Pos",objPos.InfPos.Desc))+1
					Set ^CacheTemp(repid,"Pos")=$g(^CacheTemp(repid,"Pos"))+1
				}
			}
		}	
	}
	Kill ^CacheTemp("EpisodeList",StoreID)

	Set Desc=""
	Set total=$g(^CacheTemp(repid,"Pos"))
	For {
		Set Desc=$o(^CacheTemp(repid,"Pos",Desc))
		Quit:Desc=""
		Set data=$lb("")
		Set $li(data,1)=Desc
		Set $li(data,2)=$g(^CacheTemp(repid,"Pos",Desc))
		Set $li(data,3)=""
		Set $li(data,3)=$number($li(data,2)/total*100,2)
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	
	Kill ^CacheTemp(repid,"Pos")
	Quit $$$OK
GetInfectionData(EpisodeID)
	n (EpisodeID)
	Set arryReport=##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(EpisodeID)
	Set listPos=##class(%ListOfObjects).%New()
	Quit:$IsObject(arryReport)=0 listPos
	For i=1:1:arryReport.Count() {
		Set objRep=arryReport.GetAt(i)
		Continue:$IsObject(objRep)=0 //Add By LiYang 2012-09-26 Check if NULL Pointer
		Continue:objRep.ReportType.Code'="COMP" //医院感染报告		
		Continue:objRep.ReportStatus.Code'=3 //审核状态
		Set arryPos=objRep.GetInfPos(objRep.ReportID)
		For j=1:1:arryPos.Count() {
			Set objPos=arryPos.GetAt(j)
			Do listPos.Insert(objPos)
		}
	}
	Quit listPos
}

ClassMethod StaPercentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaPercentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaPercentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaPercentExecute ]
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

/// 统计医院感染易感因素构成
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.Constitutions","StaDangerFactor","2008-1-1","2012-12-31",3,"","")
Query StaDangerFactor(FromDate As %String, ToDate As %String, DepType As %Integer, LocList As %String, WardList As %String) As %Query(ROWSPEC = "DangerName:%String:易感因素,InfNumber:%Integer:人数,Percent:%Float:比例") [ SqlProc ]
{
}

ClassMethod StaDangerFactorExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, DepType As %Integer, LocList As %String, WardList As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	
	Set StoreID=##class(DHCMed.CCService.IntegratedCtrl.Common).GetEpisodeList(FromDate,ToDate,DepType,"I",LocList,WardList)
	Set locID=""	
	For {
		Set locID=$o(^CacheTemp("EpisodeList",StoreID,"DepWard",locID))
		Quit:locID=""
		Set wardID=""
		For {
			Set wardID=$o(^CacheTemp("EpisodeList",StoreID,"DepWard",locID,wardID))
			Quit:wardID=""
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^CacheTemp("EpisodeList",StoreID,"DepWard",locID,wardID,EpisodeID))
				Quit:EpisodeID=""
				w EpisodeID,!
				Set arryRep=$$GetInfectionList(EpisodeID)
				For i=1:1:arryRep.Count() {
					Set objRep=arryRep.GetAt(i)
					w objRep.ReportID,!
					Continue:objRep.ReportStatus.Code'=3 //审核状态
					For j=1:1:objRep.InfFactors.Count() {
						Set objDanger=objRep.InfFactors.GetAt(j)
						Set ^CacheTemp(repid,"Danger",objDanger.Desc)=$g(^CacheTemp(repid,"Danger",objDanger.Desc))+1
						Set ^CacheTemp(repid,"Danger")=$g(^CacheTemp(repid,"Danger"))+1
					}
				}
			}
		}	
	}
	Kill ^CacheTemp("EpisodeList",StoreID)

	Set Desc=""
	Set total=$g(^CacheTemp(repid,"Danger"))
	For {
		Set Desc=$o(^CacheTemp(repid,"Danger",Desc))
		Quit:Desc=""
		Set data=$lb("")
		Set $li(data,1)=Desc
		Set $li(data,2)=$g(^CacheTemp(repid,"Danger",Desc))
		Set $li(data,3)=""
		Set $li(data,3)=$number($li(data,2)/total*100,2)
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	
	Kill ^CacheTemp(repid,"Danger")
	Quit $$$OK
GetInfectionList(EpisodeID)
	n (EpisodeID)
	Set arryReport=##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(EpisodeID)
	Set:$IsObject(arryReport)=0 arryReport=##class(%ListOfObjects).%New()
	Quit arryReport
}

ClassMethod StaDangerFactorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaDangerFactorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaDangerFactorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaDangerFactorExecute ]
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
