Class DHCPM.Audit.PMAudit Extends (%RegisteredObject, DHCPM.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     dongzt
/// CreatDate：   2015-01-20
/// Description:  查询该审核用户的审核列表
/// Class：       DHCPM.Audit.PMAudit
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCPM.Audit.PMAudit","QryAuditorDemInfo","1","2015-05-01","2015-05-06","","","","true")
Query QryAuditorDemInfo(DateType As %String, DateFrom As %String, DateTo As %String, DemName As %String, DemStatus As %String, DemCode As %String, tohandle As %String) As %Query(ROWSPEC = "DemandID:%String,DemandType:%String,MenuName:%String,UserName:%String,UserPhone:%String,LocName:%String,DemondCode:%String,DemandDesc:%String,EmergDegree:%String,DemandStatus:%String,DCreateDate:%String,DCreateTime:%String,DEndDate:%String,DEndTime:%String,AdjunctFlag:%String,PMModule:%String,DemSituation:%String,Serious:%String,DemandResult:%String,Engineer:%String,DemStatusCode:%String")
{
}

ClassMethod QryAuditorDemInfoExecute(ByRef qHandle As %Binary, DateType As %String, DateFrom As %String, DateTo As %String, DemName As %String, DemStatus As %String, DemCode As %String, tohandle As %String) As %Status
{
	
	;s ^Temp("QryAuditorDemInfo",$H)=DateType_"^"_DateFrom_"^"_DateTo_"^"_DemName_"^"_DemStatus_"^"_DemCode_"^"_tohandle
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	if DateType="" Set DateType=1
	Set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	Set:DateTo["-" DateTo=$zdh(DateTo,3)
	s CurrUserId=%session.Data("LOGON.USERID")   ;1933     2761
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(CurrUserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s CurrUserId=CurrUserId_"||"_##Class(web.PMP.Document).ConvertUser(CurrUserId,"")
	s SuperAuthority=""  //超级权限
	s level1ID=-1,level2ID=-1,level3ID=-1,level4ID=-1,level5ID=-1
	s job=$j
	k ^TEMP("GetAuthMode",job)
	/*   edit by zzp 2015-04-19
	s myPerRowID=0
	f  s myPerRowID=$o(^PMPPermission(myPerRowID))  q:(myPerRowID="")  d
	.s myPerStr=$g(^PMPPermission(myPerRowID))
	.q:$P(myPerStr,"^",5)'="Y" //edit by zzp 2015-04-18
	.s myval=""
	.s modeID=$P(myPerStr,"^",6)
	.s ^TEMP("GetAuthMode",0,job,modeID,myPerRowID)=""
	s AuthModeID=""
	s AuthModeID=$o(^TEMP("GetAuthMode",0,job,""))
	q:AuthModeID=""
	s AuthModeCode=$p(^PMPDictionary(AuthModeID),"^",1)
	if AuthModeCode="AM001"  d
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,1))  s level1ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,1,""))
	.else  s level1ID=0
	if AuthModeCode="AM002"  d
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,1))  s level1ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,1,""))
	.else  s level1ID=0
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,2))  s level2ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,2,""))
	.else  s level2ID=0
	
	if AuthModeCode="AM003"  d
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,1))  s level1ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,1,""))
	.else  s level1ID=0
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,2))  s level2ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,2,""))
	.else  s level2ID=0
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,3))  s level3ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,3,""))
	.else  s level3ID=0
	
	if AuthModeCode="AM004"  d
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,1))  s level1ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,1,""))
	.else  s level1ID=0
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,2))  s level2ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,2,""))
	.else  s level2ID=0
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,3))  s level3ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,3,""))
	.else  s level3ID=0
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,4))  s level4ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,4,""))
	.else  s level4ID=0
	
	if AuthModeCode="AM005"  d
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,1))  s level1ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,1,""))
	.else  s level1ID=0
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,2))  s level2ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,2,""))
	.else  s level2ID=0
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,3))  s level3ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,3,""))
	.else  s level3ID=0
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,4))  s level4ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,4,""))
	.else  s level4ID=0
	.if $d(^PMPPermissioni("AuthModeLevel",0,AuthModeID,5))  s level5ID=$O(^PMPPermissioni("AuthModeLevel",0,AuthModeID,5,""))
	.else  s level5ID=0
	b ;;
	if $d(^PMPPermisBusinessi("PERBusUserDr",CurrUserId,level1ID)) s level1=0  
	else  s level1=1 ; 0 为有权限，1 为没有权限
	if $d(^PMPPermisBusinessi("PERBusUserDr",CurrUserId,level2ID)) s level2=0  
	else  s level2=1
	if $d(^PMPPermisBusinessi("PERBusUserDr",CurrUserId,level3ID)) s level3=0  
	else  s level3=1
	if $d(^PMPPermisBusinessi("PERBusUserDr",CurrUserId,level4ID)) s level4=0  
	else  s level4=1
	if $d(^PMPPermisBusinessi("PERBusUserDr",CurrUserId,level5ID)) s level5=0  
	else  s level5=1
	
	s PerRowid="" for  set PerRowid=$o(^PMPPermisBusinessi("PERBusUserDr",CurrUserId,PerRowid)) q:PerRowid=""  d
	.s PerSub="" for  set PerSub=$o(^PMPPermisBusinessi("PERBusUserDr",CurrUserId,PerRowid,PerSub)) q:PerSub=""  d
	..s perStr=$g(^PMPPermisBusiness(PerRowid,"E",PerSub))
	..s SuperAuthority1=$p(perStr,"^",10)
	
	..if SuperAuthority1="Y" S SuperAuthority="Y"
	
	*/
	;add  by zzp 2015-04-19  start
	s idno=0
	s ROWIDD="" F  S ROWIDD=$O(^PMPPermission(ROWIDD)) Q:ROWIDD=""  D
	.s PERLevel=$p(^PMPPermission(ROWIDD),"^",3)   //权限级别
	.s PERSpare2=$p(^PMPPermission(ROWIDD),"^",5)  //权限是否有效 Y/N
	.s PERSpare3=$p(^PMPPermission(ROWIDD),"^",6)  //审核通过结果（将需求置成什么状态）
	.s PERSpare4=$p(^PMPPermission(ROWIDD),"^",7)  //提醒审核id
	.s PERSpare5=$p(^PMPPermission(ROWIDD),"^",8)  //是否必须审核   Y必须审核;N非必须审核;F需求分配;E院长审核
	.s PERType=$p(^PMPPermission(ROWIDD),"^",9)    //审核类型
	.q:PERSpare2'="Y"
	.s idno=idno+1
	.s ^TEMP("GetAuthMode",job,"NewPerBus",PERLevel)=PERSpare3_"^"_PERSpare5_"^"_idno_"^"_PERType_"^"_ROWIDD   ;修改
	.s ^TEMP("GetAuthMode",job,"Per",idno)=PERLevel_"^"_PERSpare3_"^"_PERSpare5_"^"_PERSpare4_"^"_PERType_"^"_ROWIDD
	.;按照顺序存储权限；idno为了避免删除过数据以后；级别有跳跃的现象
	.s ROWID="" F  S ROWID=$O(^PMPPermisBusinessi("PERBusUserDr",ROWIDD,CurrUserId,ROWID)) Q:ROWID=""  D
	..s PERBusIsEffect=$P(^PMPPermisBusiness(ROWIDD,"E",ROWID),"^",3)    //是否有效 Y/N ""
	..q:PERBusIsEffect'="Y"
	..s PERBusSpare1=$P(^PMPPermisBusiness(ROWIDD,"E",ROWID),"^",5)   //审核科室组权限
	..I PERBusSpare1="" S PERBusSpare1="全部"
	..s ^TEMP("GetAuthMode",job,"PerBus",CurrUserId,PERLevel)=PERSpare3_"^"_PERSpare5_"^"_idno_"^"_PERType_"^"_ROWIDD
	..;存储登录用户的所有权限级别
	..s ^TEMP("GetAuthMode",job,"PerBus",CurrUserId,PERLevel,PERBusSpare1)=PERSpare5_"^"_idno_"^"_PERType_"^"_ROWIDD
	..;存储登录用户的所有权限级别下的审核科室组
	s (PERSpare2,PERSpare3,PERSpare4,PERSpare5,PERBusSpare1,PERBusIsEffect)=""
    ;add  by zzp 2015-04-19  end
    
	;按创建日期查询
	If DateType=1 {
		Set xDate=DateTo+1
		For {
			Set xDate=$o(^PMPImprovementListi("CreateDate",xDate),-1)
			Quit:xDate=""
			Quit:xDate<(DateFrom-1)
			
					Set DemandID=""
					For {
						Set DemandID=$o(^PMPImprovementListi("CreateDate",xDate,DemandID),-1)
						Quit:DemandID=""
						
						Do BuildDemandData
					}
				}
			}
	
	//按完成日期查询
	If DateType=2 {
		Set xDate=DateTo+1
		For {
			Set xDate=$o(^PMPImprovementListi("FinlshDate",xDate),-1)
			Quit:xDate=""
			Quit:xDate<(DateFrom-1)
					Set DemandID=""
					For {
						Set DemandID=$o(^PMPImprovementListi("FinlshDate",xDate,DemandID),-1)
						Quit:DemandID=""
						Do BuildDemandData
					}
				}
			}
	Quit $$$OK
	;add by zzp 2015-04-19  start
BuildDemandData
	Do ##class(DHCPM.Query.PMQueryAll).BuildDemData(DemandID)
	;审核权限控制
	s savetypeid=$o(^PMPSysConfigure("Type","savetype",""))   //取后台配置保存状态的id
	i savetypeid'="" s savetype=$p(^PMPSysConfigure("0",savetypeid),"^",2)
	i $g(savetype)="" s savetype="91"
	s submittypeid=$o(^PMPSysConfigure("Type","submittype",""))  //取后台配置 提交状态的id
	i submittypeid'="" s submittype=$p(^PMPSysConfigure("0",submittypeid),"^",2)
	i $g(submittype)="" s submittype="92"
	q:(DemandStatusDr=savetype)   //&(DemStatus'="")   审核界面不允许查询保存状态的需求
	s locAudPriorid=$o(^PMPSysConfigure("Type","locAudPrior",""))   
	//取后台配置科室审核优先级 1为需审核列表优先;2为科室审核优先 ""为未配置（默认需审核有限）
	i locAudPriorid'="" s locAudPrior=$p(^PMPSysConfigure("0",locAudPriorid),"^",2)
	i ($g(locAudPrior)="1")||($g(locAudPrior)="")  d NeedPrior
	i $g(locAudPrior)="2"  d LocPrior
	q
NeedPrior
	i IPMLRevList'=""  d 
	.s AllType="Yes"  //设置是否审核标志
	.s IPRLChildsub="" f  s IPRLChildsub=$O(^PMPImprovementRevListi("User",DemandID,CurrUserId,IPRLChildsub)) q:(IPRLChildsub="")||(AllType="No")    d
	..s IPRLtype=$p(^PMPImprovementRevList(DemandID,IPRLChildsub),"^",6)
	..q:(IPRLtype'="")&(tohandle="true") 
	..q:(IPRLtype="")&(tohandle="false")
	..//判断界面的需处理按钮勾选上的情况 筛选吊需审核列表中已经审核过的数据
	..s AllType="No"
	..d OutPutRow
	.i AllType="Yes"  d
	..s locAuditingid=$o(^PMPSysConfigure("Type","locAuditing",""))   //取后台配置是否需要科室审核Y/N ""
	..i locAuditingid'="" s locAuditingtype=$p(^PMPSysConfigure("0",locAuditingid),"^",2)
	..s locAuditing=$p($g(locAuditingtype),"@",1)   
	..s locAudisuatus=$p($g(locAuditingtype),"@",2)  //审核通过状态
	..s locAudiType=$p($g(locAuditingtype),"@",3)   //审核类型
	..i $g(locAuditing)="Y"  D LocAuditing
	..i ($g(locAuditing)="N")||($g(locAuditing)="")  d Permission  //开始走配置的审核权限
	e  d
	.s locAuditingid=$o(^PMPSysConfigure("Type","locAuditing",""))   
	.i locAuditingid'="" s locAuditingtype=$p(^PMPSysConfigure("0",locAuditingid),"^",2)
	.s locAuditing=$p($g(locAuditingtype),"@",1)   
	.s locAudisuatus=$p($g(locAuditingtype),"@",2) 
	.s locAudiType=$p($g(locAuditingtype),"@",3)   
	.i $g(locAuditing)="Y"  D LocAuditing
	.i ($g(locAuditing)="N")||($g(locAuditing)="")  d Permission  
	q
LocPrior
    s locAuditingid=$o(^PMPSysConfigure("Type","locAuditing",""))   
    i locAuditingid'="" s locAuditingtype=$p(^PMPSysConfigure("0",locAuditingid),"^",2)
	s locAuditing=$p($g(locAuditingtype),"@",1)   
	s locAudisuatus=$p($g(locAuditingtype),"@",2) 
	s locAudiType=$p($g(locAuditingtype),"@",3)
    i $g(locAuditing)="Y"  D LocAuditingPer
    i ($g(locAuditing)="N")||($g(locAuditing)="")  d Permission 
    q
Permission 
    s PerFlag="Yes" //设置审核标志
    q:'$d(^TEMP("GetAuthMode",job,"PerBus",CurrUserId))
    s PERLevel="" f  s PERLevel=$o(^TEMP("GetAuthMode",job,"PerBus",CurrUserId,PERLevel)) q:PERLevel=""  d //遍历登录用户的多有审核权限;
    .s PerNo=$p(^TEMP("GetAuthMode",job,"PerBus",CurrUserId,PERLevel),"^",3)
    .i PerNo="1"  d
    ..s PerType=$p(^TEMP("GetAuthMode",job,"PerBus",CurrUserId,PERLevel),"^",4)
    ..s SubRowod=$o(^PMPImprovementDetaili("Flag",PerType,DemandID,""))
    ..q:(SubRowod="")&(tohandle="false")
    ..q:(SubRowod'="")&(tohandle="true")
    ..s PerFlag="No"
    ..d OutPutRow
    .i PerNo'="1"  d
    ..s PERLevelNew=$p(^TEMP("GetAuthMode",job,"Per",PerNo-1),"^",1)
    ..s PERSpare3=$p(^TEMP("GetAuthMode",job,"Per",PerNo-1),"^",2)
    ..s PERSpare5=$p(^TEMP("GetAuthMode",job,"Per",PerNo-1),"^",3)
    ..;s PerType=$p(^TEMP("GetAuthMode",job,"NewPerBus",PERLevelNew),"^",4)  ;当前审核情况
    ..s BeforeLevel=$p(^TEMP("GetAuthMode",job,"NewPerBus",PERLevelNew),"^",1)  ;上一级别审核情况
    ..s NowPerType=$p(^TEMP("GetAuthMode",job,"PerBus",CurrUserId,PERLevel),"^",4)  ;当前级别操作类型修改
    ..s Perid=$o(^PMPImprovementDetaili("FlagUser",CurrUserId,NowPerType,DemandID,""))
    ..i (PERSpare5'="N")&(PERSpare5'="E")  d
    ...q:(DemandStatusDr'=PERSpare3)&(tohandle="true")
    ...q:(tohandle="false")&(Perid="")
    ...s PerFlag="No"
    ...d OutPutRow
    ..i PERSpare5="N"  d 
    ...s No="1" 
    ...d PriorSub
    ..i PERSpare5="E"  d
    ...s PerPresident=$P($g(^PMPImprovementList(DemandID)),"^",54)
    ...i PerPresident="Y"  d
    ....q:(tohandle="true")&(DemandStatusDr'=PERSpare3New)
    ....q:(tohandle="false")&(Perid="")
    ....d OutPutRow
    ...i PerPresident="N"  d
    ....S No="2" 
    ....d PriorSub
    q
PriorSub
    f PerNoNew=PerNo-No:-1:1  d
    .s (PERSpare3New,PERSpare5New)=""
    .s PERSpare3New=$p(^TEMP("GetAuthMode",job,"Per",PerNoNew),"^",2)
    .s PERSpare5New=$p(^TEMP("GetAuthMode",job,"Per",PerNoNew),"^",3)
    .i (PERSpare5New'="N")&(PERSpare5New'="E")  d
    ..i (DemandStatusDr'=PERSpare3New)&(tohandle="true") s PerNoNew=0
    .i (PERSpare5New="N")&(DemandStatusDr=PERSpare3New) s PerNoNew=0
    .i PERSpare5New="E"  d
    ..s PerPresident=$P($g(^PMPImprovementList(DemandID)),"^",54)
    ..i (PerPresident="Y")&(tohandle="true")&(DemandStatusDr'=PERSpare3New) s PerNoNew=0
    i PerNoNew'="0" s ret="Yes"
    i $g(ret)="Yes" d OutPutRow
    q
LocAuditing
    S PriorFlag="Yes"  //设置是否审核标志
    s PriorType=$o(^PMPImprovementDetaili("Flag",locAudiType,DemandID,""))  
    //检索是否存在科室审核类型的审核记录，如果有返回需求子表（审核记录表）的sub
    i PriorType="" s PriorFlag="No"
    s LocDepType="No"  //设置是否存在科主任的配置
    s Id=0 f  Set Id=$o(^DepartAuditloc(0,"Departloc",LocNameDr,Id)) Q:(Id="")  d
    .Set User=$p(^DepartAudit(Id),"^",2)
    .s LocDepType="Yes"
    .q:User'=CurrUserId
    .q:(PriorType'="")&(tohandle="true") 
    .q:(PriorType="")&(tohandle="false")
    .d OutPutRow
    i (PriorFlag="Yes")||(LocDepType="No")  d Permission
    q
LocAuditingPer
    S PriorFlag="Yes"  //设置是否审核标志
    s PriorType=$o(^PMPImprovementDetaili("Flag",locAudiType,DemandID,""))  
    //检索是否存在科室审核类型的审核记录，如果有返回需求子表（审核记录表）的sub
    i PriorType="" s PriorFlag="No"
    s LocDepType="No"
    s Id=0 f  Set Id=$o(^DepartAuditloc(0,"Departloc",LocNameDr,Id)) Q:(Id="")  d
    .Set User=$p(^DepartAudit(Id),"^",2)
    .s LocDepType="Yes"
    .q:User'=CurrUserId
    .q:(PriorType'="")&(tohandle="true")
    .q:(PriorType="")&(tohandle="false")
    .d OutPutRow
    i PriorFlag="Yes"  d
    .i IPMLRevList'=""  d 
	..s AllType="Yes"  //设置是否审核标志
	..s IPRLChildsub="" f  s IPRLChildsub=$O(^PMPImprovementRevListi("User",DemandID,CurrUserId,IPRLChildsub)) q:(IPRLChildsub="")||(AllType="No")    d
	...s IPRLtype=$p(^PMPImprovementRevList(DemandID,IPRLChildsub),"^",6)
	...q:(IPRLtype'="")&(tohandle="true")  
	...//判断界面的需处理按钮勾选上的情况 筛选吊需审核列表中已经审核过的数据
	...s AllType="No"
	...d OutPutRow
	..i AllType="Yes"  d Permission
	.i IPMLRevList="" d Permission
    q
    ;add  by zzp 2015-04-19  start
OutPutRow
	Quit:(DemName'="")&(DemandDesc'[DemName)
	Quit:(DemCode'="")&(DemondCode'[DemCode)
	Quit:(DemStatus'="")&(DemandStatusDr'=DemStatus)
	Set Data=$lb(DemandID,DemandType,MenuName,UserName,UserPhone,LocName,DemondCode)
	Set Data=Data_$lb(DemandDesc,EmergDegree,DemandStatus,DCreateDate)
	Set Data=Data_$lb(DCreateTime,DEndDate,DEndTime,AdjunctFlag,PMModule,DemSituation,Serious,DemandResult,Engineer,DemStatusCode)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryAuditorDemInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAuditorDemInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAuditorDemInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAuditorDemInfoExecute ]
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

// w ##class(DHCPM.Audit.PMAudit).checktoAudit(2250,110)

/// 判断是不是 申请人指定审核人  信息科指定审核人 被指定科室指定审核人
ClassMethod checktoAudit(CurrUserId, DemandID) As %String
{
	s str=""
	S ret=0
	s Rowid=""
	q:(CurrUserId="")||(DemandID="") ""
	//^PMPImprovementDetaili("toAudiUser",CurrUserId,DemandID)
	if ($d(^PMPImprovementDetaili("toAudiUser",CurrUserId,DemandID)))
	{
	s Rowid=$o(^PMPImprovementDetaili("toAudiUser",CurrUserId,DemandID,""))
	s str=$g(^PMPImprovementDetail(DemandID,Rowid))
	s appflag=$p(str,"^",17)   //申请人指定审核人标志
	s firstlevelfalg=$p(str,"^",18) //信息科指定审核人标志
	s toaudifalg=$p(str,"^",19)    //被指定科室指定审核人
	;b ;;flag
	if (appflag="Y")
	{
		s ret=1 ;申请人指定审核人标志
	}
	if (firstlevelfalg="Y")
	{
		s ret=2 ;//信息科指定审核人标志
	}
	/*if (toaudifalg="Y")
	{
		s ret=3    ;被指定科室指定审核人
	}*/
	}
	q ret
}

//w ##class(DHCPM.Audit.PMAudit).AuditAuthority()

/// 审核查询的权限配置
ClassMethod AuditAuthority() As %String
{
	
	s ret=0
	;k ^TMP($j,"AuditAuthority",)
    s userId=%session.Data("LOGON.USERID")
    s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
    ;s userId=2250
	S ROWIDD="" F  S ROWIDD=$O(^PMPPermission(ROWIDD)) Q:ROWIDD=""  D
	.s myPerStr=$g(^PMPPermission(ROWIDD))
	.s level=$p(myPerStr,"^",3)
	.q:$P(myPerStr,"^",11)'="Y"
	.s ROWID=""
	.S ROWID=$O(^PMPPermisBusinessi("PERBusUserDr",userId,ROWIDD,ROWID)) q:ROWID=""  d
	..s ret=ret_"^"_level
	q ret
}

/// 一级审核 creat by zzp 2015-04-19 
/// 该功能替换原来的 FirLevelSaveOld方法，所有审核均用改方法, FirLevelSaveOld不再使用
/// w ##class(DHCPM.Audit.PMAudit).FirLevelSave("17")
ClassMethod FirLevelSave(Rowid As %String) As %String
{
	s ret=""
	q:(Rowid="") ""
	s (locAudPriorFlag,locAudPriorType,locAudPriorStatus,LocType)=""
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	s locid=%session.Data("LOGON.CTLOCID")
	;s ^zzp("FirLevelSave")=Rowid_"^"_UserId_"^"_locid
	s Status=$p(^PMPImprovementList(Rowid),"^",28)  //需求当前状态
	s LocNameDr=$p(^PMPImprovementList(Rowid),"^",12)  //获取该需求的创建科室
	i LocNameDr'="" s LocType=$o(^DepartAuditloc(0,"Departloc",LocNameDr,""))
	i LocType'="" d
	.s DepartAuditlocid="" f  s DepartAuditlocid=$o(^DepartAuditloc(0,"Departloc",LocNameDr,DepartAuditlocid)) q:DepartAuditlocid=""  d
	..s LocUserid=$p(^DepartAudit(DepartAuditlocid),"^",2)
	..q:LocUserid'=UserId
	..s LocType="Yes"
	s RevType=$O(^PMPSysConfigure("Type","Prpio",""))  //需审核列表审核类型
	s locAudPriorid=$o(^PMPSysConfigure("Type","locAuditing","")) 
	i locAudPriorid'="" s locAudPriorFlag=$p($p(^PMPSysConfigure(0,locAudPriorid),"^",2),"@",1)  //是否科室审核
	i locAudPriorid'="" s locAudPriorType=$p($p(^PMPSysConfigure(0,locAudPriorid),"^",2),"@",3)  //科室审核类型
	i locAudPriorid'="" s locAudPriorStatus=$p($p(^PMPSysConfigure(0,locAudPriorid),"^",2),"@",2)  //科室审核审核以后的状态
	i $d(^PMPImprovementRevListi("User",Rowid))  d   //审核列表不为空的情况
	.s type="Yes"
	.s IPRLChildsub="" f  s IPRLChildsub=$O(^PMPImprovementRevListi("User",Rowid,UserId,IPRLChildsub)) q:IPRLChildsub=""   d
	..s IPRLtype=$p(^PMPImprovementRevList(Rowid,IPRLChildsub),"^",6)
	..i IPRLtype=""  d
	...d updateIPRLtype
	...s type="No"  
	.i type="Yes"  d
	..i locAudPriorFlag="Y"  d   //需要科室审核
	...i LocType="Yes"  d
	....s SubRowid=$o(^PMPImprovementDetaili("Flag",locAudPriorType,Rowid,"")) 
	....i SubRowid="" d
	.....d LocUpdateType
	....e  d PerUpdateType
	...e  d PerUpdateType
	e  d  //审核列表为空的情况
	.i locAudPriorFlag="Y"  d
	.i LocType="Yes"  d
	..s SubRowid=$o(^PMPImprovementDetaili("Flag",locAudPriorType,Rowid,""),-1) 
	..i SubRowid="" d
	...d LocUpdateType
	..e  d PerUpdateType
	.e  d PerUpdateType
	q ret
PerUpdateType
	s ROWIDD="" F  S ROWIDD=$O(^PMPPermission(ROWIDD)) Q:ROWIDD=""  D
	.s PERLevel=$p(^PMPPermission(ROWIDD),"^",3)   //权限级别
	.s PERSpare2=$p(^PMPPermission(ROWIDD),"^",5)  //权限是否有效 Y/N
	.s PERSpare3=$p(^PMPPermission(ROWIDD),"^",6)  //审核通过结果（将需求置成什么状态）
	.s PERSpare4=$p(^PMPPermission(ROWIDD),"^",7)  //提醒审核id
	.s PERSpare5=$p(^PMPPermission(ROWIDD),"^",8)  //是否必须审核   Y必须审核;N非必须审核;F需求分配;E院长审核
	.s PERType=$p(^PMPPermission(ROWIDD),"^",9)   //审核类型
	.q:PERSpare2'="Y"
	.s ROWID="" F  S ROWID=$O(^PMPPermisBusinessi("PERBusUserDr",ROWIDD,UserId,ROWID)) Q:ROWID=""  D
	..s PERBusIsEffect=$P(^PMPPermisBusiness(ROWIDD,"E",ROWID),"^",3)    //是否有效 Y/N ""
	..q:PERBusIsEffect'="Y"
	..s SubRowid=$o(^PMPImprovementDetaili("Flag",PERType,Rowid,""),-1)
	..i SubRowid="" d UpDatePerType
	..i SubRowid'=""  d
	...s OldStatus=$p(^PMPImprovementDetail(Rowid,SubRowid),"^",10)
	...q:OldStatus=PERSpare3
	...d UpDatePerType
    q ret
UpDatePerType
    Ts
    &sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:PERSpare3 where IPML_Rowid=:Rowid)
    if (SQLCODE="0")
    {
	    Tc
	  &sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,:PERType,:PERSpare3,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	    }
	else
	{
		Tro
	}
	s ret=$G(SQLCODE)_"^"_PERLevel
	q ret
updateIPRLtype
    Ts
	&sql(update sqluser.PMP_ImprovmentRevList set IPRL_Type="Y" where PMP_ImprovementRevList_ParRef=:Rowid and IPRL_Childsub=:IPRLChildsub)
	if (SQLCODE=0)
	{&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,:RevType,:Status,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))}
	if (SQLCODE)
	{
		Tro
	}
	else
	{
		Tc
	}
	s ret=$G(SQLCODE)_"^"_"RevList"
	q ret
LocUpdateType
    Ts
    &sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:locAudPriorStatus,IPML_Auditor1=:UserId where IPML_Rowid=:Rowid)
    if (SQLCODE="0")
    {
	  &sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,:locAudPriorType,:locAudPriorStatus,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	    }
	if (SQLCODE)
	{
		Tro
	}
	else
	{
		Tc
	}
	s ret=$G(SQLCODE)_"^"_"loc"
	q ret
}

//一级审核

ClassMethod FirLevelSaveOld(Rowid As %String) As %String
{
	s ret=""
	q:(Rowid="") ""
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	s locid=%session.Data("LOGON.CTLOCID")
	 
	
	Ts
	
	&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR='94' where IPML_Rowid=:Rowid) 
	if (SQLCODE=0)
	{&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,'94',:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))}
	if (SQLCODE)
	{
		Tro
	}
	else
	{
		Tc
	}
	
	
	q $G(SQLCODE)
}

//一级审核 信息科指定相关审核人

//95 	005 	审核2   申请人指定审核人员

//96 	006 	审核3   信息科指定审核人员

//97 	007 	审核4   指定审核人指定审核人员

//

ClassMethod appointAuditor1(Str As %String) As %String
{
	;s ^dongzt("appointAuditor1")=Str
	s Rowid=$p(Str,"^",1)
	s userID=$p(Str,"^",2)
	s note=$p(Str,"^",3)
	s statusCode=$p(Str,"^",4)
	q:(Rowid="")||(userID="") ""
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	s locid=%session.Data("LOGON.CTLOCID")
	s revlist=$p(^PMPImprovementList(Rowid),"^",39)
	i revlist'="" s revlist=revlist_","_userID
	i revlist="" s revlist=userID
	s flag="Y"
	s Dicid=""
	s Dicid=$p(^PMPImprovementList(Rowid),"^",28)  //需求当前状态  edit by zzp 2015-05-07
	;s Dicid=$o(^PMPDictionary(0,"DTY_Code",statusCode,"90"))  //此处查询索引第一个写死为90，索引建的有问题
	q:Dicid="" ""
	Tstart
	; edit by zzp 2015-05-07
	&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:Dicid,IPML_RevList=:revlist
	where IPML_Rowid=:Rowid) 
	;add by zzp 2015-05-07
	&sql(insert into sqluser.PMP_ImprovmentRevList (PMP_ImprovementRevList_ParRef,IPRL_User, IPRL_Date, IPRL_Time, IPRL_UpdateUser) values (:Rowid,:userID,:IPMLCreateDate,:IPMLCreateTime,:UserId))   ;modify 2015-05-06修改需求分配指定人
	if (SQLCODE=0)
	{&sql(insert into sqluser.PMP_ImprovementDetail 
	(PMP_ImprovementList_ParRef,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,
	IPMD_UpdateUser_DR,IPMD_Locid,IPMD_Standby1,IPMD_Remark,IPMD_Standby3) 
	values (:Rowid,:Dicid,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid,
	:userID,:note,:flag))}
	if (SQLCODE)
	{
		Tro
	}
	else
	{
		Tc
	}
	q $G(SQLCODE)
}

ClassMethod InSubmit(Str As %String) As %String
{
	s ^dongzt("InSubmit")=Str
	
	s Rowid=$p(Str,"^",1)
	s userID=$p(Str,"^",2)
	s note=$p(Str,"^",3)
	s statusCode=$p(Str,"^",4)
	q:(Rowid="")||(userID="") ""
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	s locid=%session.Data("LOGON.CTLOCID")
    s Dicid=""
    s Dicid=$o(^PMPDictionary(0,"DTY_Code",statusCode,"90"))  //此处查询索引第一个写死为90，索引建的有问题
    q:Dicid="" ""
	&sql(update sqluser.PMP_ImprovementList SET IPML_HosInHandler=:userID,
	IPML_InNote=:note where IPML_Rowid=:Rowid) 
		
	q $G(SQLCODE)
}

/// 二级审核
/// edited by dongzt 增加了事务处理
ClassMethod SecLevelSave(Rowid As %String) As %String
{
	s ret=""
	q:(Rowid="") " "
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	Tstart
	&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR="99",IPML_Auditor=:UserId where IPML_Rowid=:Rowid) 
	if (SQLCODE=0)
	{&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,'133','99',:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	}
	if (SQLCODE=0)
	{Tcommit}
	else
	{Trollback}
	q $g(SQLCODE)
}

//add by dongzt 

//分配人员

//edit by zzp 2015-06-03  

ClassMethod distribution(objUserId As %String, objRowid As %String, note As %String) As %String
{
	;s ^zzp("111")=objUserId_"^"_objRowid_"^"_note
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	
    q:(objUserId="")||(objRowid="") "请分配需求处理人员"
    s IndependentTypeRet1=##class(web.PMP.Document).IndependentType(objUserId)
    i ((IndependentUserRet="Y")&(IndependentTypeRet1="Y")) S objUserId1=##class(web.PMP.Document).ConvertUser(objUserId,"")
    s date=+$h,time=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")
	s userId=%session.Data("LOGON.USERID") 
	S IPMLfpRet=##Class(web.PMP.Document).IPMLfp()
	s statusid=$p(^PMPImprovementList(objRowid),"^",28)
	S objUserId2=""
	s IndependentTypeRet2=##class(web.PMP.Document).IndependentType(userId)
	i ((IndependentUserRet="Y")&(IndependentTypeRet2="Y")) S objUserId2=##class(web.PMP.Document).ConvertUser(userId,"")
	Ts
	&sql(update sqluser.PMP_ImprovementList set IPML_AssignEngineer_DR=:objUserId WHERE IPML_Rowid=:objRowid)
	
	if (SQLCODE=0)
	{
		Tc
		&SQL(INSERT INTO SQLUSER.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Status_DR,IPMD_Flag,IPMD_Remark, IPMD_UpdateDate, IPMD_UpdateTime, IPMD_UpdateUser_DR,IPMD_Standby5) VALUES (:objRowid,:statusid,:IPMLfpRet,:note,:date,:time,:userId,:objUserId2))
	}
	
	else {Tro}
	
	q $g(SQLCODE)
}

//demid^diccode^other..

/// 调整状态插入 公共
/// add by dongzt 
/// w ##class(DHCPM.Audit.PMAudit).adjustStatusSave(^dongzt("adjustStatusSave"))
ClassMethod adjustStatusSave(input As %String) As %String
{
	s ^dongzt("adjustStatusSave")=input
	q:input=""
	s Note=""
	s Rowid=$P(input,"^")
	S Code=$P(input,"^",2)
	s Note=$P(input,"^",3)
	b  ;;;
	q:(Rowid="")||(Code="") ""
	
	s Dicid=""
	s Dicid=$o(^PMPDictionary(0,"DTY_Code",Code,"90"))  //此处查询索引第一个写死为90，索引建的有问题
	
	q:Dicid="" ""
	
	
	
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	Tstart
	&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:Dicid where IPML_Rowid=:Rowid) 
	if (SQLCODE=0)
	{
		if (Note="")
		{
		&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,:Dicid,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
		}
		else
		{
			&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid,IPMD_Remark) values (:Rowid,:Dicid,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid,:Note))
		}
	
	}
	if (SQLCODE=0)
	{Tcommit}
	else
	{Trollback}
	q $g(SQLCODE)
}

//w ##class(DHCPM.Audit.PMAudit).test(41)

ClassMethod test(objRowid) As %String
{
		
		set dRowid=""
		for  set dRowid=$o(^PMPImprovementDetail(objRowid,dRowid)) q:dRowid=""  d
		
		.q:dRowid="E"
		
		.s lastRowid=dRowid
		.;b ;;
		
		q lastRowid
}

/// add by dongzt
/// 校验是否分配了需求处理人
/// w ##class(DHCPM.Audit.PMAudit).CheckHandler(75)
ClassMethod CheckHandler(DemandID) As %String
{
	    s rett="1"
	    s peiid=""
		s ^dongzt("CheckHandler")=DemandID
		s ProjectTyperet=##Class(web.PMP.Document).ProjectType()
		s pessid=$p(ProjectTyperet,"@",1)
		s id="" f  s id=$o(^PMPPermissioni("PER_Level",pessid,id)) q:id=""  d
		.q:$p(^PMPPermission(id),"^",5)'="Y"
		.s peiid=id
		s statusid=$p(ProjectTyperet,"@",2)
		s userid=%session.Data("LOGON.USERID")
		s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	    s commonTypeRet=##Class(web.PMP.Document).IndependentType(userid)
	    i IndependentUserRet="Y"  d
	    .i commonTypeRet="Y" d
	    ..s userid=userid_"||"_##Class(web.PMP.Document).ConvertUser(userid,"")
		quit:DemandID="" ""
		i $d(^PMPImprovementDetail("Status",DemandID,statusid))  d
		.i $d(^PMPPermisBusinessi("User",userid,peiid)) s rett=""
		S STATUSNAW=$P(^PMPImprovementList(DemandID),"^",28)
		S FinishTyperet=##Class(web.PMP.Document).FinishType()
		I STATUSNAW=FinishTyperet S rett="1"
		;Set DemandStr=$g(^PMPImprovementList(DemandID))
		;Set EngineerDR=$P(DemandStr,"^",4)  //PMP_ProjectUser
		q rett
}

/// add by dongzt
/// 校验是否分配了科室内部需求处理人
/// w ##class(DHCPM.Audit.PMAudit).CheckHandler(114)
ClassMethod CheckInHandler(DemandID) As %String
{
		s ^dongzt("CheckInHandler")=DemandID
		quit:DemandID="" ""
		Set DemandStr=$g(^PMPImprovementList(DemandID))
		Set InDemFlag=$p(DemandStr,"^",42) //区分院内外需求 
		if InDemFlag="Y"  d
		.Set EngineerDR=$P(DemandStr,"^",44)  //PMP_ProjectUser
		else  Set EngineerDR="-1"
		
		q $G(EngineerDR)
}

ClassMethod DisAgreeInsert(Input As %String, Rowid As %String) As %String
{
	s ^dongzt("disagree")=Input_"^"_Rowid
    q:(Input="")||(Rowid="") ""
    
    
    s date=+$h,time=$p($h,",",2)
    s locid=%session.Data("LOGON.CTLOCID")
    s userId=%session.Data("LOGON.USERID")
    s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
    Ts
    &sql(update sqluser.PMP_ImprovementList set IPML_Status_DR="104",IPML_Standby3=:Input WHERE IPML_Rowid=:Rowid)
   	if (SQLCODE=0)
   	{
    	&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Status_DR,IPMD_Remark,IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,"104",:Input,:date,:time,:userId,:locid))
   			
   	}
   	
   	if (SQLCODE) {Tro} else {Tc}
   	
	q $g(SQLCODE)
}

//校验改用是否有超级权限

/// w ##class(DHCPM.Audit.PMAudit).CheckSuperAuth("1")
ClassMethod CheckSuperAuth(CurrUserId As %String) As %String
{
	s SuperAuthority=""
	s PerRowid="" for  set PerRowid=$o(^PMPPermisBusinessi("User",CurrUserId,PerRowid)) q:PerRowid=""  d
	.s PerSub="" for  set PerSub=$o(^PMPPermisBusinessi("User",CurrUserId,PerRowid,PerSub)) q:PerSub=""  d
	..s perStr=$g(^PMPPermisBusiness(PerRowid,"E",PerSub))
	..s SuperAuthority1=$p(perStr,"^",10)
	
	..if SuperAuthority1="Y" S SuperAuthority="Y"
	q $g(SuperAuthority)
}

//校验采用哪种权限模式

/// w ##class(DHCPM.Audit.PMAudit).CheckAuthMode()
ClassMethod CheckAuthMode() As %String
{
	k ^TEMP("CheckAuthMode",0)
	s job=$j
	s AuthModeCode=""
	s myPerRowID=0
	f  s myPerRowID=$o(^PMPPermission(myPerRowID))  q:(myPerRowID="")  d
	.s myPerStr=$g(^PMPPermission(myPerRowID))
	.q:$P(myPerStr,"^",5)'="Y"   //edit by zzp 2015-04-18
	.s myval=""
	.s modeID=$P(myPerStr,"^",6)  //edit by zzp 2015-04-18
	.s ^TEMP("CheckAuthMode",0,job,modeID,myPerRowID)=""
	
	s AuthModeID=""
	s AuthModeID=$o(^TEMP("CheckAuthMode",0,job,""))
	q:AuthModeID=""
	s AuthModeCode=$p(^PMPDictionary(AuthModeID),"^",1)
	
	q AuthModeCode
}

/// 取配置表中的不同意返回类型，不配置默认为Y
/// 不通过Y/直接返回给体需求用户 N/逐级返回; 可以配置用户
/// add by zzp 2015-04-20
/// w ##class(DHCPM.Audit.PMAudit).BatchNotType()
ClassMethod BatchNotType() As %String
{
	s BatchNotType="Y"
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	s BatchNotTypeid=$o(^PMPSysConfigure("Type","BatchNotType",""))   //取后台配置保存状态的id
	i BatchNotTypeid'="" s BatchNotType=$p(^PMPSysConfigure("0",BatchNotTypeid),"^",2)
	q BatchNotType
}

/// 审核不通过数据处理
/// add by zzp 2015-04-20
/// Input :Rowid(需求Rowid) Menu:(原因) Type:(^PMPSysConfigure("Type","BatchNotType")中的不同意返回类型Y/直接返回给体需求用户 N/逐级返回)
/// w ##class(DHCPM.Audit.PMAudit).FirLevelSaveNot("10","不同意","Y")
ClassMethod FirLevelSaveNot(Rowid As %String, Menu As %Text, Type As %String) As %String
{
	s UserId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	q:(Rowid="")||(Type="")||(Menu="") -1   //无数据
	s BatchNotStatus=$o(^PMPSysConfigure("Type","BatchNotStatus",""))
	i BatchNotStatus'="" s Status=$p(^PMPSysConfigure("0",BatchNotStatus),"^",2)
	q:$g(Status)="" -2  //未配置审核不通过状态
	s (locAudPriorFlag,locAudPriorType,locAudPriorStatus,LocType)=""
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")
	;s Status=$p(^PMPImprovementList(Rowid),"^",28)  //需求当前状态
	s LocNameDr=$p(^PMPImprovementList(Rowid),"^",12)  //获取该需求的创建科室
	i LocNameDr'="" s LocType=$o(^DepartAuditloc(0,"Departloc",LocNameDr,""))
	i Type="Y"  d
	.i LocType'="" d
	..s DepartAuditlocid="" f  s DepartAuditlocid=$o(^DepartAuditloc(0,"Departloc",LocNameDr,DepartAuditlocid)) q:DepartAuditlocid=""  d
	...s LocUserid=$p(^DepartAudit(DepartAuditlocid),"^",2)
	...q:LocUserid'=UserId
	...s LocType="Yes"
	.s RevType=$O(^PMPSysConfigure("Type","Prpio",""))  //需审核列表审核类型
	.s locAudPriorid=$o(^PMPSysConfigure("Type","locAuditing","")) 
	.i locAudPriorid'="" s locAudPriorFlag=$p($p(^PMPSysConfigure(0,locAudPriorid),"^",2),"@",1)  //是否科室审核
	.i locAudPriorid'="" s locAudPriorType=$p($p(^PMPSysConfigure(0,locAudPriorid),"^",2),"@",3)  //科室审核类型
	.i locAudPriorid'="" s locAudPriorStatus=$p($p(^PMPSysConfigure(0,locAudPriorid),"^",2),"@",4)  //科室审核审核以后的状态
	.i $d(^PMPImprovementRevListi("User",Rowid))  d   //审核列表不为空的情况
	..s type="Yes"
	..s IPRLChildsub="" f  s IPRLChildsub=$O(^PMPImprovementRevListi("User",Rowid,UserId,IPRLChildsub)) q:IPRLChildsub=""   d
	...s IPRLtype=$p(^PMPImprovementRevList(Rowid,IPRLChildsub),"^",6)
	...i IPRLtype=""  d
	....d updateIPRLtypeNot
	....s type="No"  
	..i type="Yes"  d
	...i locAudPriorFlag="Y"  d   //需要科室审核
	....i LocType="Yes"  d
	.....s SubRowid=$o(^PMPImprovementDetaili("Flag",locAudPriorType,Rowid,"")) 
	.....i SubRowid="" d
	......d LocUpdateTypeNot
	.....e  d PerUpdateTypeNot
	....e  d PerUpdateTypeNot
	.e  d  //审核列表为空的情况
	..i locAudPriorFlag="Y"  d
	..i LocType="Yes"  d
	...s SubRowid=$o(^PMPImprovementDetaili("Flag",locAudPriorType,Rowid,""),-1) 
	...i SubRowid="" d
	....d LocUpdateTypeNot
	...e  d PerUpdateTypeNot
	..e  d PerUpdateTypeNot
	e  q -3
	q $G(SQLCODE)
PerUpdateTypeNot
	s ROWIDD="" F  S ROWIDD=$O(^PMPPermission(ROWIDD)) Q:ROWIDD=""  D
	.s PERLevel=$p(^PMPPermission(ROWIDD),"^",3)   //权限级别
	.s PERSpare2=$p(^PMPPermission(ROWIDD),"^",5)  //权限是否有效 Y/N
	.s PERSpare3=$p(^PMPPermission(ROWIDD),"^",6)  //审核通过结果（将需求置成什么状态）
	.s PERSpare4=$p(^PMPPermission(ROWIDD),"^",7)  //提醒审核id
	.s PERSpare5=$p(^PMPPermission(ROWIDD),"^",8)  //是否必须审核   Y必须审核;N非必须审核;F需求分配;E院长审核
	.s PERType=$p(^PMPPermission(ROWIDD),"^",9)   //审核类型
	.q:PERSpare2'="Y"
	.s ROWID="" F  S ROWID=$O(^PMPPermisBusinessi("PERBusUserDr",ROWIDD,UserId,ROWID)) Q:ROWID=""  D
	..s PERBusIsEffect=$P(^PMPPermisBusiness(ROWIDD,"E",ROWID),"^",3)    //是否有效 Y/N ""
	..q:PERBusIsEffect'="Y"
	..s SubRowid=$o(^PMPImprovementDetaili("Flag",PERType,Rowid,""),-1)
	..i SubRowid="" d UpDatePerTypeNot
	..i SubRowid'=""  d
	...s OldStatus=$p(^PMPImprovementDetail(Rowid,SubRowid),"^",10)
	...q:OldStatus=PERSpare3
	...d UpDatePerTypeNot
    q $g(SQLCODE)
UpDatePerTypeNot
    Ts
    &sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:Status where IPML_Rowid=:Rowid)
    if (SQLCODE="0")
    {
	  &sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid,IPMD_Remark) values (:Rowid,:PERType,:Status,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid,:Menu))
	    }
	if (SQLCODE)
	{
		Tro
	}
	else
	{
		Tc
	}
	q $G(SQLCODE)
updateIPRLtypeNot
    Ts
	&sql(update sqluser.PMP_ImprovmentRevList set IPRL_Type="N" where PMP_ImprovementRevList_ParRef=:Rowid and IPRL_Childsub=:IPRLChildsub)
	if (SQLCODE=0)
	{&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid,IPMD_Remark) values (:Rowid,:RevType,:Status,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid,:Menu))}
	if (SQLCODE)
	{
		Tro
	}
	else
	{
		Tc
	}
	q $G(SQLCODE)
LocUpdateTypeNot
    Ts
    &sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:Status,IPML_Auditor1=:UserId where IPML_Rowid=:Rowid)
    if (SQLCODE="0")
    {
	  &sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid,IPMD_Remark) values (:Rowid,:locAudPriorType,:Status,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid,:Menu))
	    }
	if (SQLCODE)
	{
		Tro
	}
	else
	{
		Tc
	}
	q $G(SQLCODE)
}

/// 判断当前级别是否需要别的操作
/// add by zzp 2015-04-20
/// Input lev  权限级别
/// w ##class(DHCPM.Audit.PMAudit).FirLevelev("4")
ClassMethod FirLevelev(lev As %String) As %String
{
	s ret=""
	s rowid=$o(^PMPPermissioni("PER_Level",lev,""))
	q:$g(rowid)="" ret
	s Spare4=$p(^PMPPermission(rowid),"^",7)  //是否存在提醒审核
	i Spare4'="" s ret="txsh"_"@"_Spare4_"@"_$p(^PMPPermission(Spare4),"^",2)
	s Spare5=$p(^PMPPermission(rowid),"^",8)   //是否必须审核
	s ret=$G(ret)_"^"_$g(Spare5)
	s ProjectTypeid=$o(^PMPSysConfigure("Type","ProjectType",""))
	i ProjectTypeid'="" s ProjectType=$p(^PMPSysConfigure("0",ProjectTypeid),"^",2)
	i ProjectType'="" s ProjectType=$p(ProjectType,"@",1)
	s ret=$G(ret)_"^"_$g(ProjectType)
	s ProjectWindid=$o(^PMPSysConfigure("Type","ProjectWind",""))
	i ProjectWindid'="" s ProjectWind=$p(^PMPSysConfigure("0",ProjectWindid),"^",2)
	s ret=$G(ret)_"^"_$g(ProjectWind)
	q ret
}

/// 需要院长审核操作
/// add by zzp 2015-04-26
/// Input Rowid  需求Rowid
/// w ##class(DHCPM.Audit.PMAudit).SetYzshY("2")
ClassMethod SetYzshY(Rowid As %String) As %String
{
	s ret=""
	q:(Rowid="") ret
	&sql(update sqluser.PMP_ImprovementList set IPML_President="Y" WHERE IPML_Rowid=:Rowid)
    s ret=$G(SQLCODE)
    q ret
}

}
