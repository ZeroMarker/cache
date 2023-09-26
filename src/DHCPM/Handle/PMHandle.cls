Class DHCPM.Handle.PMHandle Extends (%RegisteredObject, DHCPM.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

//问题记录提交

//w ##class(DHCPM.Handle.PMHandle).getRecValByID("91||4||1")

ClassMethod getRecValByID(recordID As %String) As %String
{
	s ^dongzt("recordID")=recordID
	Q:recordID="" ""
	
	s listID=$P(recordID,"||")
	S detailID=$P(recordID,"||",2)
	s childSub=$P(recordID,"||",3)
	s Str=$g(^DHCPMComRecord(listID,detailID,childSub))
	s COmContent=$p(Str,"^",8)
	s COmContent=$tr(COmContent,$c(0))
	s ComDate=$p(Str,"^",2)
	if ComDate'="" s ComDate=$zd(ComDate,3)
	s ComTime=$p(Str,"^",3)
	if ComTime'=""  s ComTime=$zt(ComTime,3)
	s Location=$p(Str,"^",7)
	s HosStr=$p(Str,"^",6)
	s DHCCStr=$p(Str,"^",9)
	s OtherStr=$p(Str,"^",12) 
	s COmMethodDr=$p(Str,"^",1)
	if COmMethodDr'="" Set COmMethod=$p(^PMPDictionary(COmMethodDr),"^",2)
	s ComDuration=$p(Str,"^",5)
    ;s result=11
 	s result=$g(ComDate)_$c(0)_$g(ComTime)_$c(0)_$g(ComDuration)_$c(0)_$g(COmMethod)_$c(0)_$g(HosStr)_$c(0)_$g(DHCCStr)_$c(0)
	s result=result_$g(OtherStr)_$c(0)_$g(Location)_$c(0)_$g(COmContent)		
	q $g(result)
}

/// Creator：     dongzt
/// CreatDate：   2015-01-23
/// Description:  详细界面沟通内容
/// Class：       DHCPM.Handle.PMHandle
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCPM.Handle.PMHandle","QryComContent","91")
Query QryComContent(DemRowid As %String) As %Query(ROWSPEC = "RecRowid:%String,ComDate:%String,ComTime:%String,Location:%String,HosStr:%String,DHCCStr,OtherStr,COmMethod,ComDuration,COmContent")
{
}

ClassMethod QryComContentExecute(ByRef qHandle As %Binary, DemRowid As %String) As %Status
{
	
	;s ^dongzt("Content")=DemRowid
	if DemRowid="" quit $$$OK
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s (RecRowid,ComDate,ComTime,Location,HosStr,DHCCStr,OtherStr,COmMethod,ComDuration)=""
	
	s DetailChildSub="0" 
	for {
		s DetailChildSub=$o(^PMPImprovementDetail(DemRowid,DetailChildSub))
		q:DetailChildSub=""
		s RecChildSub="0"
		For {
			Set RecChildSub=$o(^DHCPMComRecord(DemRowid,DetailChildSub,RecChildSub))
			Quit:RecChildSub=""
			
			s Str=$g(^DHCPMComRecord(DemRowid,DetailChildSub,RecChildSub))
			s COmContent=$p(Str,"^",8)
			s COmContent=$tr(COmContent,$c(0))
			s ComDate=$p(Str,"^",2)
			if ComDate'="" s ComDate=$zd(ComDate,3)
			s ComTime=$p(Str,"^",3)
			if ComTime'=""  s ComTime=$zt(ComTime)
			s Location=$p(Str,"^",7)
			s HosStr=$p(Str,"^",6)
			s DHCCStr=$p(Str,"^",9)
			s OtherStr=$p(Str,"^",12) 
			s COmMethodDr=$p(Str,"^",1)
			if COmMethodDr'="" Set COmMethod=$p(^PMPDictionary(COmMethodDr),"^",2)
	        s ComDuration=$p(Str,"^",5)
			s RecRowid=DemRowid_"||"_DetailChildSub_"||"_RecChildSub
			;s RecRowid=DemRowid
			s ^dongzt("RecRowid")=RecRowid			
		Do BuildComRec
				
				}
			}
	
		
	
	
	Quit $$$OK
	
BuildComRec
	
	Set Data=$lb(RecRowid,ComDate,ComTime,Location,HosStr,DHCCStr,OtherStr,COmMethod,ComDuration,COmContent)
	;Set Data=$lb(RecRowid,ComDate,ComTime)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit
}

ClassMethod QryComContentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryComContentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryComContentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryComContentExecute ]
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
/// CreatDate：   2015-01-22
/// Description:  需求处理界面grid用
/// Class：       DHCPM.Handle.PMHandle
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCPM.Handle.PMHandle","QryHandleDemInfo","1","2015-04-16","2015-04-26","","","","true")
Query QryHandleDemInfo(DateType As %String, DateFrom As %String, DateTo As %String, DemName As %String, DemStatus As %String, DemCode As %String, toHandle As %String) As %Query(ROWSPEC = "DemandID:%String,DemandType:%String,MenuName:%String,UserName:%String,UserPhone:%String,LocName:%String,DemondCode:%String,DemandDesc:%String,EmergDegree:%String,DemandStatus:%String,DCreateDate:%String,DCreateTime:%String,DEndDate:%String,DEndTime:%String,AdjunctFlag:%String,PMModule:%String,DemSituation:%String,Serious:%String,DemandResult:%String,Engineer:%String,InHanderName:%String,EditDemDesc:%String,EditUser:%String")
{
}

ClassMethod QryHandleDemInfoExecute(ByRef qHandle As %Binary, DateType As %String, DateFrom As %String, DateTo As %String, DemName As %String, DemStatus As %String, DemCode As %String, toHandle As %String) As %Status
{
	
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    s CurrUserId=%session.Data("LOGON.USERID")
	if DateType="" Set DateType=1
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s IndependentTypeRet=##class(web.PMP.Document).IndependentType(CurrUserId) 
	i ((IndependentUserRet="Y")&(IndependentTypeRet="Y")) S CurrUserId=##class(web.PMP.Document).ConvertUser(CurrUserId,"")
	Set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	Set:DateTo["-" DateTo=$zdh(DateTo,3)
	;s ^Temp("Handle",$h)=DateType_"^"_DateFrom_"^"_DateTo_"^"_DemName_"^"_DemStatus_"^"_DemCode_"^"_toHandle_"^"_CurrUserId_"^"_DateFrom_"^"_DateTo_"^"_%session.Data("LOGON.USERID")_"^"_IndependentUserRet_"^"_IndependentTypeRet
	//edit  by  zzp 2015-04-26************strat
	/*
	s level1ID=-1
	s level2ID=-1
	s level3ID=-1
	s level4ID=-1
	s level5ID=-1
	k ^TEMP("GetAuthMode",0)
	s job=$j
	s myPerRowID=0
	f  s myPerRowID=$o(^PMPPermission(myPerRowID))  q:(myPerRowID="")  d
	.s myPerStr=$g(^PMPPermission(myPerRowID))
	.;b ;;
	.q:$P(myPerStr,"^",11)'="Y"
	.s myval=""
	.s modeID=$P(myPerStr,"^",7)
	.s ^TEMP("GetAuthMode",0,job,modeID,myPerRowID)=""
	.;i ModeID'="" s mydes=$p(^PMPDictionary(ModeID),"^",2)
	s AuthModeID=""
	s AuthModeID=$o(^TEMP("GetAuthMode",0,job,""))
	q:AuthModeID=""
	s AuthModeCode=$p(^PMPDictionary(AuthModeID),"^",1)
	;s PerRowID="" f  s PerRowID=$o(^TEMP("GetAuthMode",0,job,AuthModeID,PerRowID)) q:PerRowID=""  d
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
	
	*/
	//edit  by  zzp 2015-04-26************end
	//按创建日期查询
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
	
BuildDemandData
	
	s (DemandType,MenuName,UserName,UserPhone,LocName,DemondCode,DemandDesc)=""
	s (EmergDegree,DemandStatus,DCreateDate,DCreateTime,DEndDate,DEndTime,AdjunctFlag)=""
	s (PMModule,DemSituation,Serious,DemandResult,Engineer,InHanderName,EditDemDesc,EditUser)=""
	Do ##class(DHCPM.Query.PMQueryAll).BuildDemData(DemandID)
	;Quit:(DemType'="")&(DemType'=DemandTypeDr)
	;Quit:(CreateLoc'="")&(LocNameDr'=CreateLoc)
	;Quit:(CreateUser'="")&(CreateUser'=UserNameDr)
	;Quit:(Emergency'="")&(Emergency'=EmergDegreeDr)
	Quit:(DemName'="")&(DemandDesc'[DemName)
	Quit:(DemCode'="")&(DemondCode'[DemCode)
	
	
	set InHanderName=""
	if (InDemFlag="Y"){
		set InHandlerID=""
		set inHandLength=$LENGTH(InDemHandler,",")
		
		set i=""
		;s ^dongzt("inHandLength")=inHandLength_"^"_InDemHandler
		for i=1:1:inHandLength  d
		.set inHandlerID=$p(InDemHandler,",",i)
		.if inHandlerID'=""  d
		..if InHanderName="" set InHanderName=##Class(web.PMP.Document).SSUSER(inHandlerID)
		..else  s InHanderName=InHanderName_","_##Class(web.PMP.Document).SSUSER(inHandlerID)
		
		.if inHandlerID=CurrUserId  s InHandlerID=CurrUserId
		;.;s ^dongzt("inHandlerID")=InDemHandler_"^"_inHandlerID_"^"_UserId
		
		Quit:InHandlerID'=CurrUserId
		if (toHandle="true"){
		q:DemStatusCode'="002"
		}
		
		
		}
		else{
			s ProjectTypeid=$o(^PMPSysConfigure("Type","ProjectType",""))  //取审核通过标志
			i ProjectTypeid'="" s ProjectType=$p(^PMPSysConfigure(0,ProjectTypeid),"^",2)
			i $g(ProjectType)'="" s ProjectType=$p(ProjectType,"@",2)
			q:'$d(^PMPImprovementDetail("Status",DemandID,ProjectType))
			s FinishTypeid=$o(^PMPSysConfigure("Type","FinishType",""))  //取完成标志
			i FinishTypeid'="" s FinishType=$p(^PMPSysConfigure(0,FinishTypeid),"^",2)
			q:(toHandle="true")&(FinishType=DemandStatusDr)
			s ImproUserid=$o(^PMPSysConfigure("Type","ImproUser",""))  //获取后台配置 检索需求是否只能检索分配给本人的需求;
			i ImproUserid'="" s ImproUser=$p(^PMPSysConfigure(0,ImproUserid),"^",2)
			;s ^Temp("IndependentTypeRet",DemandID)=IndependentUserRet_"^"_IndependentTypeRet_"^"_CurrUserId_"^"_$g(CurrUserId1)_"^"_$g(ImproUser)_"^"_AssignEngineer
			Q:(AssignEngineer'=$G(CurrUserId))&(($g(ImproUser)="Y"))
			
		}
	
	Quit:(DemStatus'="")&(DemandStatusDr'=DemStatus)
	Set Data=$lb(DemandID,DemandType,MenuName,UserName,UserPhone,LocName,DemondCode)
	Set Data=Data_$lb(DemandDesc,EmergDegree,DemandStatus,DCreateDate)
	Set Data=Data_$lb(DCreateTime,DEndDate,DEndTime,AdjunctFlag,PMModule,DemSituation)
	Set Data=Data_$lb(Serious,DemandResult,Engineer,InHanderName,EditDemDesc,EditUser)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit
}

ClassMethod QryHandleDemInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHandleDemInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHandleDemInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHandleDemInfoExecute ]
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

//问题记录提交

//w ##class(DHCPM.Handle.PMHandle).HanRecSubmit("84^8^^^")

ClassMethod HanRecSubmit(str As %String) As %String
{
	s ModuleDr=""
	q:str="" ""
	
	set Rowid=$p(str,"^")
	quit:Rowid="" ""
	s ProcessLoggning=##Class(web.PMP.Document).ProcessLoggning()
	set Module=$p(str,"^",2)
	i Module'="" d
	.if $d(^PMPModule(Module))  d
	..s ModuleDr=Module
	//set StatusDr=$p(str1,"^",3)
	set PreDuration=$p(str,"^",3)
	set Developer=$p(str,"^",4)
	set HandRec=$p(str,"^",5)
	s status=$p(^PMPImprovementList(Rowid),"^",28)
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s IndependentTypeRet2=##class(web.PMP.Document).IndependentType(UserId)
	i ((IndependentUserRet="Y")&(IndependentTypeRet2="Y")) S UserId=UserId_"||"_##class(web.PMP.Document).ConvertUser(UserId,"")
	Ts
	s object=##Class(User.PMPImprovementList).%OpenId(Rowid)
	i ModuleDr'=""  d
	.s objectmode=##Class(User.PMPModule).%OpenId(ModuleDr)
	.s object.IPMLModuleDR=objectmode
	i PreDuration'="" s object.IPMLPredictTime=PreDuration
    i Developer'=""  d
    .s Developerold=object.IPMLDevelopUser
    .i (Developerold'="")&(Developerold'[Developer) s Developerold=Developerold_","_Developer
    .i Developerold="" s Developerold=Developer
    .i (Developer<1)&&('$d(^PMPImpDevelopi("DevelopDesc",Developer)))  d AddDevelopDesc
    .i (Developer>0)&&('$d(^PMPImpDevelopi("DevelopDR",Developer)))  d AddDevelopDR
    .s object.IPMLDevelopUser=Developerold
    s sc=object.%Save()
    i sc{
	    Tc
	    &sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR,IPMD_Remark, IPMD_UpdateDate, IPMD_UpdateTime, IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,:ProcessLoggning,:status,:HandRec,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	    }
	else{
		Tro
		}
	q $g(SQLCODE)
AddDevelopDesc
    s objectdev=##Class(User.PMPImpDevelop).%New()
    s objectssuser=UserId
    s objectdev.PIDCreatDate=IPMLCreateDate
    s objectdev.PIDCreatTime=IPMLCreateTime
    s objectdev.PIDCreatUserDR=objectssuser
    s objectdev.PIDUpdateDate=IPMLCreateDate
    s objectdev.PIDUpdateTime=IPMLCreateTime
    s objectdev.PIDUpdateUserDR=objectssuser
    s objectdev.PIDFlag="Y"
    s objectdev.PIDIPMLDR=object
    s objectdev.PIDDevelopDesc=Developer
    s devdesc=objectdev.%Save()
    q
AddDevelopDR
    s objectdev=##Class(User.PMPImpDevelop).%New()
    s objectssuser=UserId
    s objectdev.PIDCreatDate=IPMLCreateDate
    s objectdev.PIDCreatTime=IPMLCreateTime
    s objectdev.PIDCreatUserDR=objectssuser
    s objectdev.PIDUpdateDate=IPMLCreateDate
    s objectdev.PIDUpdateTime=IPMLCreateTime
    s objectdev.PIDUpdateUserDR=objectssuser
    s objectdev.PIDFlag="Y"
    s objectdev.PIDIPMLDR=object
    S objectdevelop=##Class(User.PMPDevelop).%OpenId(Developer)
    s objectdev.PIDDevelopDR=objectdevelop
    s devdesc=objectdev.%Save()
    q
}

/// w ##class(DHCPM.Handle.PMHandle).checkModule("8")
ClassMethod checkModule(Module As %String) As %String
{
	set ret=""
	q:Module="" ""
	i Module<1  D
	.I $D(^PMPModulei("Desc",Module)) S ret=$o(^PMPModulei("Desc",Module,""))
	i Module>0  d
	if $d(^PMPModule(Module)) d
	.s ret=Module
	q ret
}

//沟通记录提交

/// w ##class(DHCPM.Handle.PMHandle).InsertPMCom(^dongzt("InsertPMCom"))
ClassMethod InsertPMCom(str As %String) As %String
{
	;s ^dongzt("InsertPMCom")=str
	q:str="" ""
	set Rowid=$p(str,"^",1)
	set ComDate=$p(str,"^",2)
	if ComDate["-" s ComDate=$zdh(ComDate,3)
	set ComTime=$p($p(str,"^",3)," ")
	if ComTime[":" s ComTime=$zth(ComTime)
	
	set ComDuration=$p(str,"^",4)
	set ComWayDr=$p(str,"^",5)
	set HosStr=$p(str,"^",6)
	set PrjStr=$p(str,"^",7)
	set OtherStr=$p(str,"^",8)
	set ComNote=$p(str,"^",9)
	set Location=$p(str,"^",10)
	
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	s DetailRowid=""
	s DetailRowid=$o(^PMPImprovementDetail(Rowid,""),-1)
	b ;;
	q:DetailRowid="" ""
	set DRowid=Rowid_"||"_DetailRowid
	
	&sql(insert into sqluser.DHC_PMComRecord (PM_De_ParRef,CR_Note,CR_Update,CR_UpTime,CR_Creater,CR_Com_DR,CR_Prject_UserDR,CR_Hos_UserDR,extStr1,CR_Location,CR_Comdate,CR_ComTime,CR_Duration) VALUES (:DRowid,:ComNote,:IPMLCreateDate,:IPMLCreateTime,:UserId,:ComWayDr,:PrjStr,:HosStr,:OtherStr,:Location,:ComDate,:ComTime,:ComDuration))
	
	q $g(SQLCODE)
}

/// w ##class(DHCPM.Handle.PMHandle).checkStatus("141")
ClassMethod checkStatus(demStatus As %String) As %String
{
	;s ^dongzt("demStatus")=demStatus
	set ret=0
	q:demStatus="" ""
	
	if $d(^PMPDictionary(demStatus)) d
	.s ret=0
	else  d
	.s ret=1
	
	q ret
}

/// d ##class(DHCPM.Handle.PMHandle).UpdateStatus("84^101")
ClassMethod UpdateStatus(paraStr As %String) As %String
{

	q:paraStr="" ""
	s StatusDr=""
	set Rowid=$p(paraStr,"^")
	quit:Rowid="" ""
	set Status=$p(paraStr,"^",2)
	q:Status="" ""
	if $d(^PMPDictionary(Status)) d
	.s StatusDr=Status
	q:StatusDr="" ""
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	s UserId=%session.Data("LOGON.USERID") 
    s FinishTestRet=##class(web.PMP.Document).FinishTest()
    s TestRet=$p(FinishTestRet,",",1)
    s FinishRet=$p(FinishTestRet,",",1)
    S UserId2=""
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s IndependentTypeRet2=##class(web.PMP.Document).IndependentType(UserId)
	i ((IndependentUserRet="Y")&(IndependentTypeRet2="Y")) S UserId=UserId_"||"_##class(web.PMP.Document).ConvertUser(UserId,"")
	Tstart
	i StatusDr=TestRet  d
	.&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:StatusDr,IPML_TestDate=:IPMLCreateDate,IPML_TestTime=:IPMLCreateTime where IPML_Rowid=:Rowid)
	i StatusDr=FinishRet  d
	.&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:StatusDr,IPML_FinishDate=:IPMLCreateDate,IPML_FinishTime=:IPMLCreateTime where IPML_Rowid=:Rowid) 
	i (StatusDr'=TestRet)&(StatusDr'=FinishRet)  d
	.&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:StatusDr where IPML_Rowid=:Rowid)
	if (SQLCODE=0)
	{&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) VALUES (:Rowid,:StatusDr,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	}
	if (SQLCODE=0)
	{Tcommit}
	else
	{Trollback}
	q $g(SQLCODE)
}

/// Created by dongzt
/// 项目组修改需求内容
/// d ##class(DHCPM.Handle.PMHandle)editDemDesc("84^101")
ClassMethod editDemDesc(input As %Text, winfDemDesc As %Text) As %String
{
	
	q:input="" ""
	s ^Temp("editDemDesc")=input_"@@"_winfDemDesc
	set Rowid=$p(input,"^")
	quit:Rowid="" ""
	set EditDemDesc=$p(input,"^",2)
	q:EditDemDesc="" ""
	set userId=$p(input,"^",3)
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	&sql(update sqluser.PMP_ImprovementList 
	SET IPML_EidtedSituation=:winfDemDesc,IPML_Situation=:EditDemDesc,IPML_EidtUser=:userId 
	where IPML_Rowid=:Rowid)
	q $g(SQLCODE)
}

/// Created by dongzt
/// 只有项目部可以修改需求内容
/// d ##class(DHCPM.Handle.PMHandle).buttonVisible("1")
ClassMethod buttonVisible(rowid As %String = "") As %String
{
	set ret=0
	;s ^Temp("buttonVisible")=rowid
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	i UserId["||" s ret="1"
	;i UserId'["||"  d
	q $g(ret)
}

}
