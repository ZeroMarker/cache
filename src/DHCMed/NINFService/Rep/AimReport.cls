/// 名称: DHCMed.NINFService.Rep.AimReport
/// 描述: 目标性监测报告
/// 编写者：zhufei
/// 编写日期: 2011-05-26
Class DHCMed.NINFService.Rep.AimReport Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.NINFService.Rep.AimReport).SaveReport("1^1^76475^76475||3^^^^^^5000^117^9^","^")
ClassMethod SaveReport(aInput As %String, aSeparase As %String) As %String
{
	New (aInput,aSeparase)
	Set return=0
	Set $ZT="SaveReportErr"
	
	Set RepID=$p(aInput,aSeparase,1)
	Set RepType=$p(aInput,aSeparase,2)     //报告类型代码
	Set RepTypeID=""
	Set objRepType=##Class(DHCMed.SS.Dictionary).GetByTypeCode("NINFAimReportType",RepType,"")
	If $IsObject(objRepType) {
		Set RepTypeID=objRepType.%Id()
	}
	Quit:RepTypeID="" return
	
	Set EpisodeID=$p(aInput,aSeparase,3)
	Set TransID=$p(aInput,aSeparase,4)
	Quit:(EpisodeID="")||(TransID="") return
	Set TransLoc=$p(aInput,aSeparase,5)
	Quit:TransLoc="" return
	Set TransFromLoc=$p(aInput,aSeparase,6)
	Set TransToLoc=$p(aInput,aSeparase,7)
	Set TransInDate=$p(aInput,aSeparase,8)
	Set:TransInDate["-" TransInDate=$zdh(TransInDate,3)
	Set TransOutDate=$p(aInput,aSeparase,9)
	Set:TransOutDate["-" TransOutDate=$zdh(TransOutDate,3)
	Set BornWeight=$p(aInput,aSeparase,10)
	Set RepLoc=$p(aInput,aSeparase,11)
	Set RepUser=$p(aInput,aSeparase,12)
	Set RepStatus=""
	Set RepStatusCode=$p(aInput,aSeparase,13)
	Set objRepStatus=##Class(DHCMed.SS.Dictionary).GetByTypeCode("NINFAimReportStatus",RepStatusCode,"")
	If $IsObject(objRepStatus){
		Set RepStatus=objRepStatus.%Id()
	}
	
	If RepID="" {
		Set RepID=$o(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",RepTypeID,EpisodeID,TransID,0))
	}
	
	Set InputReport=RepID
	Set InputReport=InputReport_aSeparase_EpisodeID
	Set InputReport=InputReport_aSeparase_RepTypeID
	Set InputReport=InputReport_aSeparase_TransID
	Set InputReport=InputReport_aSeparase_TransLoc
	Set InputReport=InputReport_aSeparase_TransFromLoc
	Set InputReport=InputReport_aSeparase_TransToLoc
	Set InputReport=InputReport_aSeparase_TransInDate
	Set InputReport=InputReport_aSeparase_TransOutDate
	Set InputReport=InputReport_aSeparase_BornWeight
	Set InputReport=InputReport_aSeparase_RepLoc_","_RepUser_","_RepStatus
	
	Set return=##Class(DHCMed.NINF.Rep.AimReport).Update(InputReport,aSeparase)
	Quit return
	
SaveReportErr
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2012-06-11
/// Description:  查询日期类型
/// Table：       
/// Input:        ModuleCode : 模块代码
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReport","QryDateType","MDR")
Query QryDateType(aModuleCode As %String) As %Query(ROWSPEC = "TypeCode:%String,TypeDesc:%String")
{
}

ClassMethod QryDateTypeExecute(ByRef qHandle As %Binary, aModuleCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If aModuleCode="UC" {
		Set DateTypeList=$lb($lb(1,"插管日期"),$lb(2,"拔管日期"),$lb(3,"报告日期"))
	} ElseIf aModuleCode="PICC" {
		Set DateTypeList=$lb($lb(1,"置管日期"),$lb(2,"拔管日期"),$lb(3,"报告日期"))
	} ElseIf aModuleCode="VAP" {
		Set DateTypeList=$lb($lb(1,"上机日期"),$lb(2,"脱机日期"),$lb(3,"报告日期"))
	} ElseIf aModuleCode="OPR" {
		Set DateTypeList=$lb($lb(1,"手术日期"),$lb(3,"报告日期"))
	} ElseIf aModuleCode="MDR" {
		Set DateTypeList=$lb($lb(1,"送检日期"),$lb(3,"报告日期"))
	} ElseIf aModuleCode="NUC" {
		Set DateTypeList=$lb($lb(1,"置管日期"),$lb(2,"拔管日期"),$lb(3,"报告日期"))
	} ElseIf aModuleCode="NPICC" {
		Set DateTypeList=$lb($lb(1,"置管日期"),$lb(2,"拔管日期"),$lb(3,"报告日期"))
	} ElseIf aModuleCode="NVNT" {
		Set DateTypeList=$lb($lb(1,"上机日期"),$lb(2,"脱机日期"),$lb(3,"报告日期"))
	} Else {
		Set DateTypeList=$lb($lb(3,"报告日期"))
	}
	
	For indType=1:1:$listlength(DateTypeList)
	{
		Set Data=$list(DateTypeList,indType)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryDateTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDateTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDateTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDateTypeExecute ]
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
/// CreatDate：   2013-07-09
/// Description:  查询医嘱信息
/// Table：       
/// Input:        OEDesc
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReport","QueryOEInfo","2370167","")
Query QueryOEInfo(aEpisodeID As %String, aTypeCode As %String) As %Query(ROWSPEC = "ind:%String,ArcimID:%String,ArcimName:%String,StartDate:%String,StartTime:%String,EndDate:%String,EndTime:%String")
{
}

ClassMethod QueryOEInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aTypeCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aEpisodeID="" $$$OK
	
	Set return=##class(%ListOfObjects).%New()
	Set return=##class(DHCMed.NINF.Srv.ICUIntubate).GetICUResults(aEpisodeID,aTypeCode)
	For ind=1:1:return.Count() {
		Set obj=return.GetAt(ind)
		Quit:'$IsObject(obj)
		Set xOEDesc=obj.IntubateDesc
	
		Set OrderID=0
		For {
			Set OrderID=$o(^OEORD(0,"Adm",aEpisodeID,OrderID))
			Quit:OrderID=""
			Set ArcimID=""
			For {
				Set ArcimID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID))
				Quit:ArcimID=""
			
				Set ArcimName=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
				Continue:(ArcimName'[xOEDesc)&&(xOEDesc'="")
				Set SttDate=0,flg=0
				For {
					Set SttDate=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate))
					Quit:SttDate=""
				
					Set SubID=0
					For {
						Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
						Quit:SubID=""
					
						Set flg=1
						Set StartDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
						Set:StartDate'="" StartDate=$zd(StartDate,3)
						Set StartTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) //医嘱开始时间
						Set:StartTime'="" StartTime=$zt(StartTime,2)
						Set Doctor=$p($g(^OEORD(+OrderID,"I",SubID,1)),"^",11)   //开医嘱医生
						Set DoctorName=$p($g(^CTPCP(+Doctor,1)),"^",2)
						Set:Doctor'="" Doctor=$o(^SSU("SSUSR",0,"CTPCP",+Doctor,0))
					
						Set EndDate=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",34) // 停止日期 	
						Set EndTime=$p($g(^OEORD(OrderID,"I",SubID,2)),"^",15) // 停止时间
					
						Set OEORIFillerNo=$p($g(^OEORD(OrderID,"I",SubID,9)),"^",12) 
					
						Set:EndDate'="" EndDate=$zd(EndDate,3)
						Set:EndTime'="" EndTime=$zt(EndTime,2)	
					
						Continue:(OEORIFillerNo'="")&&(EndDate="")
						Continue:ind>20
						Set Data=$lb(ind,ArcimID,ArcimName,StartDate,StartTime,EndDate,EndTime)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QueryOEInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOEInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOEInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOEInfoExecute ]
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
