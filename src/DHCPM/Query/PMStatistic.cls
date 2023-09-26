/// 名称: DHCPM.Query.PMStatistic
/// 描述: 项目管理统计query
/// 编写者：dongzt
/// 编写日期: 2015-01-14
Class DHCPM.Query.PMStatistic Extends (%RegisteredObject, DHCPM.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     dongzt
/// CreatDate：   2015-01-14
/// Description:  统计科室/需求状态数量
/// Class：       DHCPM.Query.PMStatistic
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCPM.Query.PMStatistic","QryLocDemInfo","1","2014-12-01","2015-01-10","208","","","","")
Query QryLocDemInfo(DateType As %String, DateFrom As %String, DateTo As %String, CreateLoc As %String, DemStatus As %String, DemType As %String, Emergency As %String, CreateUser As %String, DemDimension As %String) As %Query(ROWSPEC = "TRowid:%String,TDesc:%String,TNum:%String,TRatio:%String,TFlag:%String")
{
}

ClassMethod QryLocDemInfoExecute(ByRef qHandle As %Binary, DateType As %String, DateFrom As %String, DateTo As %String, CreateLoc As %String, DemStatus As %String, DemType As %String, Emergency As %String, CreateUser As %String, DemDimension As %String) As %Status
{
	s ^dongzt("QryAllDemInfo")=DateType_"^"_DateFrom_"^"_DateTo_"^"_CreateLoc_"^"_DemStatus_"^"_DemType_"^"_Emergency_"^"_CreateUser
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set ZIndex=$zn,JIndex=$j,LocNum=0,StatusNum=0,num=0
	k ^TMP(ZIndex,JIndex,"LocDemByDate")
	
	Quit:(DateFrom="")||(DateTo="")||(DateType="") $$$OK
	
	Set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	Set:DateTo["-" DateTo=$zdh(DateTo,3)
	
	Set ZIndex=$zn,JIndex=$j,DateNum=0,StatusNum=0
	
	//按创建日期查询
	If DateType=1 {
		Set xDate=DateFrom-1
		For {
			Set xDate=$o(^PMPImprovementListi("CreateDate",xDate))
			Quit:xDate=""
			Quit:xDate>DateTo
			
					Set DemandID=0
					For {
						Set DemandID=$o(^PMPImprovementListi("CreateDate",xDate,DemandID))
						Quit:DemandID=""
						Do ##class(DHCPM.Query.PMQueryAll).BuildDemData(DemandID)
						Continue:InDemFlag="Y"  //分析只给HIS需求用
						Continue:(DemType'="")&(DemType'=DemandTypeDr)
						Continue:(CreateLoc'="")&(LocNameDr'=CreateLoc)
						Continue:(CreateUser'="")&(CreateUser'=UserNameDr)
						Continue:(Emergency'="")&(Emergency'=EmergDegreeDr)
						Continue:(DemStatus'="")&(DemandStatusDr'=DemStatus)
						Do BuildDemandData
					}
			}
				
				
				Do CreateGlobal
				
	
		}
	
	//按完成日期查询
	If DateType=2 {
		Set xDate=DateFrom-1
		For {
			Set xDate=$o(^PMPImprovementListi("FinlshDate",xDate))
			Quit:xDate=""
			Quit:xDate>DateTo
			
			
					Set DemandID=0
					For {
						Set DemandID=$o(^PMPImprovementListi("FinlshDate",xDate,DemandID))
						Quit:DemandID=""
						
						Do ##class(DHCPM.Query.PMQueryAll).BuildDemData(DemandID)
						
						Continue:(DemType'="")&(DemType'=DemandTypeDr)
						Continue:(CreateLoc'="")&(LocNameDr'=CreateLoc)
						Continue:(CreateUser'="")&(CreateUser'=UserNameDr)
						Continue:(Emergency'="")&(Emergency'=EmergDegreeDr)
						Continue:(DemStatus'="")&(DemandStatusDr'=DemStatus)
						Do BuildDemandData
					}
				}
				Do CreateGlobal
			}
	
	
	Quit $$$OK
	
BuildDemandData
	
	
	Set num=$i(^TMP(ZIndex,JIndex,"LocDemByDate","PMLoc","合计"))
	Set num=$i(^TMP(ZIndex,JIndex,"LocDemByDate","PMLoc",LocNameDr))
	
	Set num=$i(^TMP(ZIndex,JIndex,"LocDemByDate","PMStaus",DemandStatusDr))
	Set num=$i(^TMP(ZIndex,JIndex,"LocDemByDate","PMStaus","合计"))
	
	Quit
	
CreateGlobal

	if (DemDimension="1")
	
	{	
	Set DemCount=+$g(^TMP(ZIndex,JIndex,"LocDemByDate","PMLoc","合计"))
	/*
	if (DemCount>0)
	{
		Set Data=$lb("","科室需求分析","","","")
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
		Set Data=$lb("","","","","")
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}
	*/
	Set xLocID="",Count=0,DemNum=0
	For {
		Set xLocID=$o(^TMP(ZIndex,JIndex,"LocDemByDate","PMLoc",xLocID))
		Quit:xLocID=""
		
		Set DemNum=+$g(^TMP(ZIndex,JIndex,"LocDemByDate","PMLoc",xLocID))
		
		Set LocDesc=$p($g(^CTLOC(xLocID)),"^",2)
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		if LocDesc'="" Set LocDesc=LocDesc
		If DemNum>0 {
			Set DemRatio=$fn((DemNum/DemCount)*100,"",2)_"%"
		} Else {
			Set DemRatio="0.00%"
			}
			
			
			
		
		if (xLocID="合计")
		
		{
			/*
			Set Data=$lb("","合计",DemNum,DemRatio,"")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
			*/
		}
		
		else
		{
			Set Count=Count+1
			Set Data=$lb(xLocID,LocDesc,DemNum,DemRatio,"LOC")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
		
		
		
	}
	}
	/*
	if (Count>0)
	{
	Set Data=$lb("","","","","")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	}
	*/
	if (DemDimension="2")
	{
	Set StatusCount=+$g(^TMP(ZIndex,JIndex,"LocDemByDate","PMStaus","合计"))
	/*
	if (StatusCount>0)
	{
		Set Data=$lb("","需求状态分析","","","")
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
		Set Data=$lb("","","","","")
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	
	}
	*/
	Set StatusID="",Count=0,StatusNum=0
	For {
		Set StatusID=$o(^TMP(ZIndex,JIndex,"LocDemByDate","PMStaus",StatusID))
		Quit:StatusID=""
		
		Set StatusNum=+$g(^TMP(ZIndex,JIndex,"LocDemByDate","PMStaus",StatusID))
		
		if StatusID'="合计" Set DemandStatus=$p(^PMPDictionary(StatusID),"^",2)
		If StatusNum>0 {
			Set DemRatio=$fn((StatusNum/StatusCount)*100,"",2)_"%"
		} Else {
			Set DemRatio="0.00%"
			}
		
		
		
		if (StatusID="合计")
		
		{
			/*
			Set Data=$lb("","合计",StatusNum,DemRatio,"")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
			*/
		}
		
		else
		{
			Set Count=Count+1
		Set Data=$lb(StatusID,DemandStatus,StatusNum,DemRatio,"STATUS")
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		}
		
		
	}
	}
	;k ^TMP(ZIndex,JIndex,"LocDemByDate")
	Quit
}

ClassMethod QryLocDemInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocDemInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocDemInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocDemInfoExecute ]
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
