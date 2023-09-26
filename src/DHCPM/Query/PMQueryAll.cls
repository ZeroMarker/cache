/// 名称: DHCPM.Query.PMQueryAll
/// 描述: 项目管理查询query
/// 编写者：dongzt
/// 编写日期: 2015-01-14
Class DHCPM.Query.PMQueryAll Extends (%RegisteredObject, DHCPM.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     dongzt
/// CreatDate：   2015-01-14
/// Description:  查询全部需求明细
/// Class：       DHCPM.Query.PMQueryAll
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryAll","QryAllDemInfo","","","","","","","","")
Query QryAllDemInfo(DateType As %String, DateFrom As %String, DateTo As %String, CreateLoc As %String, DemStatus As %String, DemType As %String, Emergency As %String, CreateUser As %String, DemDirect As %String) As %Query(ROWSPEC = "DemandID:%String,DemandType:%String,MenuName:%String,UserName:%String,UserPhone:%String,LocName:%String,DemondCode:%String,DemandDesc:%String,EmergDegree:%String,DemandStatus:%String,DCreateDate:%String,DCreateTime:%String,DEndDate:%String,DEndTime:%String,AdjunctFlag:%String,PMModule:%String,DemSituation:%String,EditDemDesc:%String,EditUser:%String")
{
}

ClassMethod QryAllDemInfoExecute(ByRef qHandle As %Binary, DateType As %String, DateFrom As %String, DateTo As %String, CreateLoc As %String, DemStatus As %String, DemType As %String, Emergency As %String, CreateUser As %String, DemDirect As %String = "") As %Status
{
	
	s ^dongzt("QryAllDemInfo")=DateType_"^"_DateFrom_"^"_DateTo_"^"_CreateLoc_"^"_DemStatus_"^"_DemType_"^"_Emergency_"^"_CreateUser_"^"_DemDirect
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	if DateType="" s DateType=1
	if DemDirect="" s DemDirect=1
	Set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	Set:DateTo["-" DateTo=$zdh(DateTo,3)
	i DateFrom="" s DateFrom=+$h-15
	i DateTo="" s DateTo=+$H
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
						
						Do BuildDemandData
					}
				}
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
						
						Do BuildDemandData
					}
				}
			}
			
		If ((DateType="")&(CreateLoc'="")) {
			Set DemandID=0
			For {
					Set DemandID=$o(^PMPImprovementListi("CreateLoc",CreateLoc,DemandID))
					Quit:DemandID=""
						
					Do BuildDemandData
				}
			}
			
			If ((DateType="")&(DemStatus'="")) {
			Set DemandID=0
			For {
					Set DemandID=$o(^PMPImprovementListi("IPMLStatusDR",DemStatus,DemandID))
					Quit:DemandID=""
						
					Do BuildDemandData
				}
			}
		
	
	
	Quit $$$OK
	
BuildDemandData
	
	Do ..BuildDemData(DemandID)
	if (DemDirect=1){
		
		s ^dongzt("DemDirect1",DemandID)=DemDirect
		quit:(InDemFlag'="N")&(InDemFlag'="")
		}
		else{
		quit:InDemFlag'="Y"	
		}
		
	Quit:(DemType'="")&(DemType'=DemandTypeDr)
	Quit:(CreateLoc'="")&(LocNameDr'=CreateLoc)
	Quit:(CreateUser'="")&(CreateUser'=UserNameDr)
	Quit:(Emergency'="")&(Emergency'=EmergDegreeDr)
	Quit:(DemStatus'="")&(DemandStatusDr'=DemStatus)
	Set Data=$lb(DemandID,DemandType,MenuName,UserName,UserPhone,LocName,DemondCode)
	Set Data=Data_$lb(DemandDesc,EmergDegree,DemandStatus,DCreateDate)
	Set Data=Data_$lb(DCreateTime,DEndDate,DEndTime,AdjunctFlag,PMModule,DemSituation)
	set Data=Data_$lb(EditDemDesc,EditUser)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit
}

ClassMethod QryAllDemInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAllDemInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAllDemInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAllDemInfoExecute ]
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

/// Creator：     dongzt
/// CreatDate：   2015-01-14
/// Description:  查询全部需求明细
/// Class：       DHCPM.Query.PMQueryAll
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryAll","QryDemList","96")
Query QryDemList(DemRowid As %String) As %Query(ROWSPEC = "DemStatus:%String,Operator:%String,OperaDate:%String,OperaTime:%String,OperarorLoc:%String,toAudiUser:%String,toAudiUserLoc:%String,note:%String")
{
}

ClassMethod QryDemListExecute(ByRef qHandle As %Binary, DemRowid As %String) As %Status
{
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	;s ^dongzt("QryDemList")=DemRowid
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	if DemRowid=""   quit $$$OK
	
	
		Set Childsub=""
		For {
			Set Childsub=$o(^PMPImprovementDetail(DemRowid,Childsub),-1)
			Quit:(Childsub=0)
			if (Childsub'="E")
			{
			Set str=$g(^PMPImprovementDetail(DemRowid,Childsub))
			set DemStatusDr=$p(str,"^",10)
			if DemStatusDr'=""  Set DemStatus=$p(^PMPDictionary(DemStatusDr),"^",2)
			s DemoFlag=$p(str,"^",8)
			s DemoFlagDesc=""
			i (DemoFlag'="")&&($d(^PMPDictionary(DemoFlag)))  d
			.S DemoFlagDesc=$p(^PMPDictionary(DemoFlag),"^",2)
			i $g(DemoFlagDesc)'="" s DemStatus=$g(DemStatus)_"("_$g(DemoFlagDesc)_")"
			Set OperatorDr=$p(str,"^",13)
			i OperatorDr["||" s Operator=$p(^PMPProjectUser($p(OperatorDr,"||",2)),"^",22)
			if OperatorDr'["||" set Operator=$p(^SSU("SSUSR",+OperatorDr),"^",2)
			i IndependentUserRet="Y" s OperatorDr=+OperatorDr
			set OperaDate=$p(str,"^",11)
			if OperaDate'="" set OperaDate=$zd(OperaDate,3)
			set OperaTime=$p(str,"^",12)
			if OperaTime'="" set OperaTime=$zt(OperaTime)
			Set OperarorLocDr=$p(str,"^",20)
			if OperarorLocDr'="" s OperarorLoc=$p(^CTLOC(OperarorLocDr),"^",1)
			Set toAudiUserDr=$p(str,"^",15)  //指定审核人
			i toAudiUserDr["||" s toAudiUser=$p(^PMPProjectUser($p(toAudiUserDr,"||",2)),"^",22)
			if toAudiUserDr'["||" set toAudiUser=$p(^SSU("SSUSR",+toAudiUserDr),"^",2)
			i IndependentUserRet="Y" s toAudiUserDr=+toAudiUserDr
			Set toAudiUserLocDr=$p(str,"^",16)
			if toAudiUserLocDr'="" s toAudiUserLoc=$p(^CTLOC(toAudiUserLocDr),"^",1)
			Set note=$p(str,"^",9) 
			Do BuildDemandList
			}
			}
	Quit $$$OK
	
BuildDemandList
	
	Set Data=$lb(DemStatus,Operator,OperaDate,OperaTime,OperarorLoc,toAudiUser,toAudiUserLoc,note)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit
}

ClassMethod QryDemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDemListExecute ]
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

/// Creator：     dongzt
/// CreatDate：   2015-01-14
/// Description:  查询全部需求明细
/// Class：       DHCPM.Query.PMQueryAll
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryAll","QryDownLoadList","","75")
Query QryDownLoadList(external As %String, DemRowid As %String) As %Query(ROWSPEC = "attachment:%String,UpDate:%String,UpUser:%String,DownLoadFlag:%String,ADRowid:%String,Filename:%String")
{
}

ClassMethod QryDownLoadListExecute(ByRef qHandle As %Binary, external As %String, DemRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	if DemRowid=""   quit $$$OK
	
	
		Set Childsub=""
		For {
			Set Childsub=$o(^PMPImproveAdjuncti("Improve",DemRowid,"Improvement",Childsub))
			Quit:(Childsub="")
			
			Set str=$g(^PMPImprovementAdjunct(Childsub))
			Set attachName=$p(str,"^",4)
			
			Set attachDate=$p(str,"^",11)
			
			Set:attachDate'="" attachDate=$zd(attachDate,3)
			
			Set attachTime=$p(str,"^",12)
			
			Set:attachTime'="" attachTime=$zt(attachTime,3)
			
			Set attachUserid=$p(str,"^",13)
			i attachUserid["||" s attachUser=$p(^PMPProjectUser($p(attachUserid,"||",2)),"^",22)
			if attachUserid'["||" set attachUser=$p(^SSU("SSUSR",+attachUserid),"^",2)
			i IndependentUserRet="Y" s attachUserid=+attachUserid
			s ADRowid=DemRowid_"||"_Childsub
			s Filename=$p(str,"^",7)
			
			//Set:attachUser'="" attachUser=$p(^SSU("SSUSR",attachUser),"^",2)
			
			Do BuildDemandDown
			
					}
	
	
	
	Quit $$$OK
	
BuildDemandDown
	
	Set Data=$lb(attachName,attachDate,attachUser,"下载",ADRowid,Filename)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit
}

ClassMethod QryDownLoadListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDownLoadListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDownLoadListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDownLoadListExecute ]
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

//菜单名称 21  

//需求类型 31

//紧急程度 

/// w ##class(DHCPM.Query.PMQueryAll).BuildDataByRowid(1)
ClassMethod BuildDataByRowid(DemandID) As %String
{
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	Quit:DemandID="" "0"
	Set DemandStr=$g(^PMPImprovementList(DemandID))
	Set DemandTypeDr=$p(DemandStr,"^",31)  //需求类型
	if DemandTypeDr'="" Set DemandType=$p(^PMPDictionary(DemandTypeDr),"^",2)
	Set MenuName=$p(DemandStr,"^",21)   //菜单名称
	Set UserNameDr=$p(DemandStr,"^",15)   //创建者姓名
	if UserNameDr'="" Set UserName=##Class(web.PMP.Document).SSUSER(UserNameDr)
	i IndependentUserRet'="Y" s UserNameDr=+UserNameDr
	Set UserPhone=$p(DemandStr,"^",13)   //创建者电话
	Set LocNameDr=$p(DemandStr,"^",12)   //科室
	if LocNameDr'="" Set LocName=$p(^CTLOC(LocNameDr),"^",2)
	if LocName'="" Set LocName=$p(LocName,"-",2)
	Set DemondCode=$p(DemandStr,"^",1)   //需求代码
	Set DemandDesc=$p(DemandStr,"^",2)   //需求名称
	Set EmergDegreeDr=$p(DemandStr,"^",18)   //紧急程度  16 严重程度
	if EmergDegreeDr'="" Set EmergDegree=$p(^PMPDictionary(EmergDegreeDr),"^",2)
	Set DemandStatusDr=$p(DemandStr,"^",28)   //状态
	if DemandStatusDr'="" Set DemandStatus=$p(^PMPDictionary(DemandStatusDr),"^",2)
	Set DCreateDate=$p(DemandStr,"^",11)   //需求创建日期
	if DCreateDate'="" Set DCreateDate=$zd(DCreateDate,3)
	Set DCreateTime=$p(DemandStr,"^",14)   //创建时间
	if DCreateTime'="" Set DCreateTime=$zt(DCreateTime,3)
	Set DEndDate=$p(DemandStr,"^",19)   // 需求完成日期
	if DEndDate'="" Set DEndDate=$zd(DEndDate,3)
	Set DEndTime=$p(DemandStr,"^",20)   // 完成时间
	if DEndTime'="" Set DEndTime=$zt(DEndTime,3)
	Set AdjunctFlag=$p(DemandStr,"^",3)   //附件标志
	Set PMModuleDr=$p(DemandStr,"^",23)   //所属模块
	if (PMModuleDr'="") Set PMModule=$p(^PMPModule(PMModuleDr),"^",2)
	Set DemSituation=$p(DemandStr,"^",26)   //需求现状
	Set Str=DemandID_"^"_$g(MenuName)_"^"_$g(DemandType)_"^"_$g(EmergDegree)_"^"_$g(PMModule)_"^"_LocName
	Set Str=Str_UserName_"^"_$g(UserPhone)_"^"_$g(DemSituation)
	quit $g(Str)
}

ClassMethod BuildDemData(DemandID) As %String
{
	S (DemandType,ProjectUser,LocName,EmergDegree,DemandStatus,DemStatusCode,DCreateDate,DCreateTime,DEndDate,DEndTime,PMModule,Serious,Engineer,EditUser)=""
	s IndependentUserRet=##Class(web.PMP.Document).IndependentUser()
	Set DemandStr=$g(^PMPImprovementList(DemandID))
	Set DemandTypeDr=$p(DemandStr,"^",31)  //需求类型
	if DemandTypeDr'="" Set DemandType=$p(^PMPDictionary(DemandTypeDr),"^",2)
	Set MenuName=$p(DemandStr,"^",21)   //菜单名称
	Set UserNameDr=$p(DemandStr,"^",15)   //创建者姓名
	i UserNameDr["||" s UserName=$p(^PMPProjectUser($p(UserNameDr,"||",2)),"^",22)
	if UserNameDr'["||" Set UserName=$p(^SSU("SSUSR",+UserNameDr),"^",2)
	i IndependentUserRet'="Y" s UserNameDr=+UserNameDr
	Set UserPhone=$p(DemandStr,"^",13)   //创建者电话
	Set LocNameDr=$p(DemandStr,"^",12)   //科室
	if LocNameDr'="" d
	.i $d(^CTLOC(LocNameDr)) d
	..Set LocName=$p(^CTLOC(LocNameDr),"^",2)
	if LocName'="" Set LocName=$p(LocName,"-",2)
	Set DemondCode=$p(DemandStr,"^",1)   //需求代码
	Set DemandDesc=$p(DemandStr,"^",2)   //需求名称
	Set EmergDegreeDr=$p(DemandStr,"^",18)   //紧急程度  16 严重程度
	if EmergDegreeDr'="" Set EmergDegree=$p(^PMPDictionary(EmergDegreeDr),"^",2)
	Set DemandStatusDr=$p(DemandStr,"^",28)   //状态
	if (DemandStatusDr'="")
	{
	 Set DemandStatus=$p(^PMPDictionary(DemandStatusDr),"^",2)
	 set DemStatusCode=$p(^PMPDictionary(DemandStatusDr),"^",1)  //code
	}
	Set DCreateDate=$p(DemandStr,"^",11)   //需求创建日期
	if DCreateDate'="" Set DCreateDate=$zd(DCreateDate,3)
	Set DCreateTime=$p(DemandStr,"^",14)   //创建时间
	if DCreateTime'="" Set DCreateTime=$zt(DCreateTime,3)
	Set DEndDate=$p(DemandStr,"^",19)   // 需求完成日期
	if DEndDate'="" Set DEndDate=$zd(DEndDate,3)
	Set DEndTime=$p(DemandStr,"^",20)   // 完成时间
	if DEndTime'="" Set DEndTime=$zt(DEndTime,3)
	Set AdjunctFlag=$p(DemandStr,"^",3)   //附件标志
	Set PMModuleDr=$p(DemandStr,"^",23)   //所属模块
	if (PMModuleDr'="") Set PMModule=$p(^PMPModule(PMModuleDr),"^",2)
	Set DemSituation=$p(DemandStr,"^",26)   //需求现状
	Set SeriousDr=$p(DemandStr,"^",16)   //严重程度
	if SeriousDr'="" Set Serious=$p(^PMPDictionary(SeriousDr),"^",2)
	Set DemandResult=$p(DemandStr,"^",34) //要求结果
	Set EngineerDR=$p(DemandStr,"^",4) //指定工程师
	if (EngineerDR'="")  d
	.if ($d(^PMPProjectUser(EngineerDR)))  d
	..Set Engineer=$p(^PMPProjectUser(EngineerDR),"^",22)
	Set InDemFlag=$p(DemandStr,"^",42) //区分院内外需求
	Set InDemNote=$p(DemandStr,"^",43) //需求说明
	Set InDemHandler=$p(DemandStr,"^",44) //指定院内需求处理人
	Set EditDemDesc=$p(DemandStr,"^",45)  //修改的需求
	Set EditUserID=$p(DemandStr,"^",46)     //需求修改人ID
	i EditUserID["||" s EditUser=$p(^PMPProjectUser($p(EditUserID,"||",2)),"^",22)
	if EditUserID'["||" Set EditUser=$p(^SSU("SSUSR",+EditUserID),"^",2)
	i IndependentUserRet'="Y" s EditUserID=+EditUserID
	s IPMLRevList=$p(DemandStr,"^",39)  //需审核人标致
	s IPMLRevListIMP=$p(DemandStr,"^",40) //项目办分配需审核人标志
	s AssignEngineer=$p(DemandStr,"^",4)  //项目组分配人员
	if (AssignEngineer'="")  d
	.if ($d(^PMPProjectUser(AssignEngineer)))  d
	..Set ProjectUser=$p(^PMPProjectUser(AssignEngineer),"^",22)
	quit
}

/// Creator：     zzp
/// CreatDate：   2015-05-23
/// Description:  查询附件明细
/// Class：       DHCPM.Query.PMQueryAll
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryAll","ContracAdjunctStore","Improvement","75")
Query ContracAdjunctStore(Type As %String, Contract As %String) As websys.Query(ROWSPEC = "ConAdRowid:%String,ConAdName:%String,ConAdFileType:%String,ConAdDate:%String,ConAdUser:%String,ConAdType:%String,ConAdFtpName:%String,ConAdFalg:%String,ConAdAll:%String")
{
}

ClassMethod ContracAdjunctStoreExecute(ByRef qHandle As %Binary, Type As %String, Contract As %String) As %Status
{
	;s ^Temp("ContracAdjunctStore")=Type_"^"_Contract
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    q:Contract="" $$$OK
    q:Type="" $$$OK
    s id="" f  s id=$o(^PMPImproveAdjuncti("Improve",Contract,Type,id)) q:id=""  d
    .s (ConAdRowid,ConAdName,ConAdFileType,ConAdDate,ConAdUser,ConAdType,ConAdFtpName,ConAdFalg,ConAdAll)=""
    .s conid=$p(^PMPImprovementAdjunct(id),"^",2)
    .s ConAdFalg="Y"
    .S ConAdFtpName=$p(^PMPImprovementAdjunct(id),"^",7)
    .S ConAdType=$p(^PMPImprovementAdjunct(id),"^",1)
    .S ConAdUser=##Class(web.PMP.Document).SSUSER($p(^PMPImprovementAdjunct(id),"^",13))
    .S ConAdDate=##Class(web.PMP.Document).Date($p(^PMPImprovementAdjunct(id),"^",11))_" "_##Class(web.PMP.Document).Time($p(^PMPImprovementAdjunct(id),"^",12))
    .s ConAdName=$p(^PMPImprovementAdjunct(id),"^",4)
    .s ConAdFileType=$p(ConAdName,".",$l(ConAdName,"."))
    .s ConAdRowid=Contract_"||"_id
    .s ConAdAll=$p(^PMPImprovementAdjunct(id),"^",3)
    .d OutputRow8
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow8
    s Data=$lb(ConAdRowid,ConAdName,ConAdFileType,ConAdDate,ConAdUser,ConAdType,ConAdFtpName,ConAdFalg,ConAdAll)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

}
