/// 趋势图
Class DHCMed.NINFService.Sta.InfTendencyChart Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 统计医院感染率
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.InfTendencyChart","StaTendency","2008-1-1","2012-12-31",1,1,"","")
/// DateGroup:1--月  2--季度
Query StaTendency(FromDate As %String, ToDate As %String, DateGroup As %Integer, DepType As %Integer, LocList As %String, WardList As %String) As %Query(ROWSPEC = "DepID:%String,DepName:%String:科室,DateName:%String:日期分组,DisNumber:%Integer:出院人数,InfNumber:%Integer:感染人数,InfPercent:%Float:比例") [ SqlProc ]
{
}

ClassMethod StaTendencyExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, DateGroup As %Integer, DepType As %Integer, LocList As %String, WardList As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	
	For tmpDate=FromDate:1:ToDate {
		Set StoreID=##class(DHCMed.CCService.IntegratedCtrl.Common).GetEpisodeList(tmpDate,tmpDate,DepType,"I",LocList,WardList)
		Set CurrDate=$zd(tmpDate,3)
		Set:DateGroup=1 DateName=$Extract(CurrDate,1,7) //按月统计
		Set:DateGroup=2 DateName="第"_($p(CurrDate,"-",2)\4+1)_"季度"
		Set ^CacheTemp(repid,"DateGroup",DateName)=""
		Set locID=""	
		For {
			Set locID=$o(^CacheTemp("EpisodeList",StoreID,"DepWard",locID))
			Quit:locID=""
			Set wardID=""
			For {
				Set wardID=$o(^CacheTemp("EpisodeList",StoreID,"DepWard",locID,wardID))
				Quit:wardID=""
				Set:DepType=1 DepartmentID=locID
				Set:DepType=2 DepartmentID=wardID	
					
				Set EpisodeID=""
				For {
					Set EpisodeID=$o(^CacheTemp("EpisodeList",StoreID,"DepWard",locID,wardID,EpisodeID))
					Quit:EpisodeID=""
					//Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
					//Do objAdm.%Close()
					Set tmpData=$g(^CacheTemp(repid,"tmp",DepartmentID,DateName))
					Set $p(tmpData,"^",1)=$p(tmpData,"^",1)+1 //出院人数
					Set cnt=$$GetInfectionCnt(EpisodeID)
					Set:cnt>0 $p(tmpData,"^",2)=$p(tmpData,"^",2)+1 //感染报告人数
					Set ^CacheTemp(repid,"tmp",DepartmentID,DateName)=tmpData
				}
			}	
		}
		Kill ^CacheTemp("EpisodeList",StoreID)
	}
	
	Set DepartmentID=""
	For {
		Set DepartmentID=$o(^CacheTemp(repid,"tmp",DepartmentID))
		Quit:DepartmentID=""
		Set:DepType=1 objDep=##class(DHCMed.Base.Ctloc).GetObjById(DepartmentID)
		Set:DepType=2 objDep=##class(DHCMed.Base.PacWard).GetObjById(DepartmentID)
		Do objDep.%Close()		
		Set DateName=""
		For {
			Set DateName=$o(^CacheTemp(repid,"DateGroup",DateName))
			Quit:DateName=""
			Set data=$lb("")
			Set tmpData=$g(^CacheTemp(repid,"tmp",DepartmentID,DateName))
			Set $li(data,1)=DepartmentID
			Set $li(data,2)=objDep.Descs //科室或病区
			Set:$li(data,2)["-" $li(data,2)=$p($li(data,2),"-",2)
			Set $li(data,3)=DateName //日期分组
			Set $li(data,4)=+$p(tmpData,"^",1) //出院人数
			Set $li(data,5)=+$p(tmpData,"^",2) //感染人数
			Set $li(data,6)=0
			Set:$li(data,4)'=0 $li(data,6)=$Number($p(tmpData,"^",2)/$p(tmpData,"^",1)*100,2) //感染率
			Set ^CacheTemp(repid,ind)=data
			Set ind=ind+1
		}
	}
	Kill ^CacheTemp(repid,"tmp")
	Kill ^CacheTemp(repid,"DateGroup")
	Quit $$$OK
GetInfectionCnt(EpisodeID)
	n (EpisodeID)
	Set arryReport=##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(EpisodeID)
	Set:$IsObject(arryReport)=0 arryReport=##class(%ListOfObjects).%New()
	Set ret=0
	For i=1:1:arryReport.Count() {
		Set objRep=arryReport.GetAt(i)
		Continue:$IsObject(objRep)=0 //Add By LiYang 2012-09-26 Check if NULL Pointer
		Continue:objRep.ReportType.Code'="COMP" //医院感染报告
		Continue:objRep.ReportStatus.Code'=3 //已审状态
		Set ret=1
	}
	Quit ret
}

ClassMethod StaTendencyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaTendencyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaTendencyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaTendencyExecute ]
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
