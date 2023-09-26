/// 名称: DHCPM.Application.PMApply
/// 描述: 项目管理之需求申请
/// 编写者：dongzt
/// 编写日期: 2015-01-18
Class DHCPM.Application.PMApply Extends (%RegisteredObject, DHCPM.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     dongzt
/// CreatDate：   2015-01-18
/// edit by zzp 2015-06-03
/// Description:  查询该用户需求明细
/// Class：       DHCPM.Application.PMApply
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCPM.Application.PMApply","QryUserDemInfo","1","2015-02-05","2015-02-05","","","",1)
Query QryUserDemInfo(DateType As %String, DateFrom As %String, DateTo As %String, DemName As %String, DemStatus As %String, DemCode As %String, DemDirect As %String) As %Query(ROWSPEC = "DemandID:%String,DemandType:%String,MenuName:%String,UserName:%String,UserPhone:%String,LocName:%String,DemondCode:%String,DemandDesc:%String,EmergDegree:%String,DemandStatus:%String,DemandStatusid:%String,DCreateDate:%String,DCreateTime:%String,DEndDate:%String,DEndTime:%String,AdjunctFlag:%String,PMModule:%String,DemSituation:%String,Serious:%String,DemandResult:%String,Engineer:%String,DemStatusCode:%String,InHanderName:%String,EditDemDesc:%String,EditUser:%String,ProjectUser:%String")
{
}

ClassMethod QryUserDemInfoExecute(ByRef qHandle As %Binary, DateType As %String, DateFrom As %String, DateTo As %String, DemName As %String, DemStatus As %String, DemCode As %String, DemDirect As %String) As %Status
{
	
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	if DemDirect="" s DemDirect="1"
	if DateType="" s DateType="1"
	Set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	Set:DateTo["-" DateTo=$zdh(DateTo,3)
	s IndependentUserRet=##Class(web.PMP.Document).IndependentUser()
	s CurrUserId=%session.Data("LOGON.USERID")
	i IndependentUserRet="Y"  d
	.s IndependentTypeRet=##Class(web.PMP.Document).IndependentType(CurrUserId)
	.i IndependentTypeRet="Y"  d
	..s CurrUserId=CurrUserId_"||"_##Class(web.PMP.Document).ConvertUser(CurrUserId,"")
	;s ^Temp("UserDem",$h)=DateType_"^"_DateFrom_"^"_DateTo_"^"_DemName_"^"_DemStatus_"^"_DemCode_"^"_DemDirect_"^"_CurrUserId
	;s CurrUserId=2196
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
	s (DemandType,MenuName,UserName,UserPhone,LocName,DemondCode)=""
	s (DemandDesc,EmergDegree,Engineer,DemandStatus,DCreateDate)=""
	s (DCreateTime,DEndDate,DEndTime,AdjunctFlag,PMModule,DemSituation)=""
	s (Serious,DemandResult,Engineer,EditDemDesc,EditUser,ProjectUser)=""
	Do ##class(DHCPM.Query.PMQueryAll).BuildDemData(DemandID)
	;Quit:(DemType'="")&(DemType'=DemandTypeDr)
	;Quit:(CreateLoc'="")&(LocNameDr'=CreateLoc)
	;Quit:(CreateUser'="")&(CreateUser'=UserNameDr)
	;Quit:(Emergency'="")&(Emergency'=EmergDegreeDr)
	;s ^dongzt("DemDirect")=DemDirect
	if (DemDirect=1)
	{
		quit:(InDemFlag'="N")&(InDemFlag'="")
	}
	else
	{
		quit:(InDemFlag'="Y")
	}
	set InHanderName=""
	if (InDemFlag="Y"){
		set InHandlerID=""
		set inHandLength=$LENGTH(InDemHandler,",")
		set i=""
		;s ^dongzt("inHandLength")=inHandLength_"^"_InDemHandler
		for i=1:1:inHandLength  d
		.set inHandlerID=$p(InDemHandler,",",i)
		.if inHandlerID'=""  d
		..if InHanderName="" set InHanderName=$p(^SSU("SSUSR",inHandlerID),"^",2)
		..else  s InHanderName=InHanderName_","_$p(^SSU("SSUSR",inHandlerID),"^",2)
	}
	
	Quit:CurrUserId'=UserNameDr   //当前登录的用户只能查看自己创建的需求
	Quit:(DemName'="")&(DemandDesc'[DemName)
	Quit:(DemCode'="")&(DemondCode'[DemCode)
	Quit:(DemStatus'="")&(DemandStatusDr'=DemStatus)
	s DemandStatusid=DemandStatusDr
	Set Data=$lb(DemandID,DemandType,MenuName,UserName,UserPhone,LocName,DemondCode)
	Set Data=Data_$lb(DemandDesc,EmergDegree,DemandStatus,DemandStatusid,DCreateDate,DCreateTime,DEndDate)
	Set Data=Data_$lb(DEndTime,AdjunctFlag,PMModule,DemSituation,Serious,DemandResult)
	Set Data=Data_$lb(Engineer,DemStatusCode,InHanderName,EditDemDesc,EditUser,ProjectUser)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryUserDemInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserDemInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryUserDemInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserDemInfoExecute ]
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

//生成编码

ClassMethod CreatePmCode() As %String
{
	s XQCode=""
	s data=$zd($p($h,",",1),3)
	s data=$p(data,"-",1)_$p(data,"-",2)_$p(data,"-",3)
	S Rowid=$o(^PMPImprovementList(""),-1)
	
	if (Rowid="")
		{
		s XQCode=data_"0001"
		}
	else
		{
		s XQCode=$p(^PMPImprovementList(Rowid),"^",1)
	
		i XQCode[data s XQCode=XQCode+1
		i XQCode'[data s XQCode=data_"0001"
		}
	q XQCode
}

/// 新建需求插入数据
/// edit by dongzt 增加事务处理，嵌套提交申请   
/// edit by zzp 2015-06-03
/// w ##class(DHCPM.Application.PMApply).InsertNewApply("2222222222222222222^^18230326251^114^8^^CCCCCCCCCCCCCCCCCCCCCCCCCCCCC^85^125^N^C:\Users\Administrator\Desktop\新建文件夹\n_t0d361fef71777801783e3.jpg^^^VVVVVVVVVVVVVVVVVVVVVVVVV^1^102^Home^^N^^148@@Save@@@@192.168.1.110")
ClassMethod InsertNewApply(input As %String) As %String
{
	q:input="" ""
	;q 0
	;S ^Temp("InsertNewApply")=input
	s UserSavetypeid=##Class(web.PMP.Document).UserSavetype()
	s ApplicationTypeRet=##Class(web.PMP.Document).ApplicationType()
	s input1=$p(input,"@@") //add by dongzt
	s IPMLName=$P(input1,"^",1)   
	;s IPMLCode=$P(input1,"^",2)
	s IPMLCode=..CreatePmCode()
	s IPMLCreateTel=$P(input1,"^",3)
    s IPMLType=$P(input1,"^",4)
	s IPMLStandby2=$P(input1,"^",5) 
	s IPMLStandby4=$P(input1,"^",6)
	s IPMLSituation=$P(input1,"^",7)
	s IPMLEmergencyDR=$P(input1,"^",8)
	s IPMLDegreeDR=$P(input1,"^",9)
	s IPMLStandby5=$P(input1,"^",10)
	s IPMLAdjunctFlag1=$P(input1,"^",11)
	S IPMLStatusDR=##Class(web.PMP.Document).Savetype()
	i IPMLAdjunctFlag1'="" s IPMLAdjunctFlag="Y" 
	i IPMLAdjunctFlag1=""  s IPMLAdjunctFlag="N" 
	s IPMLEngineerDR=$P(input1,"^",12)
	S IPMLStandby3=$P(input1,"^",14)
	s ^dongzt("result")=IPMLStandby3
	S IPMLCreateDate=+$H
	s IPMLCreateLocDR=$P(input1,"^",16)
	S IPMLCreateTime=$P($H,",",2)
	s IPMLCreateUserDR=$P(input1,"^",15)
	s IPMLStandby1="N"
	s IPMLMenu=$p(input1,"^",17)
	s IPMLList=$p(input1,"^",21)
	S XYSHRIDvalue=$p(input1,"^",18)
	s LocDemFlag=$p(input1,"^",19)
	s LocUser=$p(input,"@@",3)
	s ip=$p(input,"@@",4)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	s ConvertUserRet=""
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(IPMLCreateUserDR)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s IPMLCreateUserDR=IPMLCreateUserDR_"||"_##Class(web.PMP.Document).ConvertUser(IPMLCreateUserDR,ip)
	TSTART
	
	i IPMLList=""  d
	.&sql(insert into sqluser.PMP_ImprovementList 
	(IPML_Name,IPML_Code,IPML_CreateTel,IPML_Type,IPML_Standby2,
	IPML_Standby4,IPML_Situation,IPML_Emergency_DR,IPML_Standby5,
	IPML_AdjunctFlag,IPML_Status_DR,IPML_Standby3,IPML_CreateDate,
	IPML_CreateLoc_DR,IPML_CreateTime,IPML_CreateUser_DR,IPML_Standby1,
	IPML_Engineer_DR,IPML_Menu,IPML_RevList,IPML_UpdateType,IPML_Degree_DR,IPML_HosInDem,IPML_Standtb1)
	 values (:IPMLName,:IPMLCode,:IPMLCreateTel,:IPMLType,:IPMLStandby2,
	 :IPMLStandby4,:IPMLSituation,:IPMLEmergencyDR,:IPMLStandby5,'N',
	 :IPMLStatusDR,:IPMLStandby3,:IPMLCreateDate,:IPMLCreateLocDR,:IPMLCreateTime,
	 :IPMLCreateUserDR,:IPMLStandby1,:IPMLEngineerDR,:IPMLMenu,:XYSHRIDvalue,'N',
	 :IPMLDegreeDR,:LocDemFlag,:LocUser))
    i IPMLList'=""  d
    .&sql(insert into sqluser.PMP_ImprovementList 
    (IPML_Name,IPML_Code,IPML_CreateTel,IPML_Type,IPML_Standby2,
    IPML_Standby4,IPML_Situation,IPML_Emergency_DR,IPML_Standby5,
    IPML_AdjunctFlag,IPML_Status_DR,IPML_Standby3,IPML_CreateDate,
    IPML_CreateLoc_DR,IPML_CreateTime,IPML_CreateUser_DR,IPML_Standby1,
    IPML_Engineer_DR,IPML_Menu,IPML_List,IPML_Degree_DR,IPML_RevList,IPML_UpdateType,IPML_HosInDem,IPML_Standtb1)
     values (:IPMLName,:IPMLCode,:IPMLCreateTel,:IPMLType,:IPMLStandby2,
     :IPMLStandby4,:IPMLSituation,:IPMLEmergencyDR,:IPMLStandby5,'N',
     :IPMLStatusDR,:IPMLStandby3,:IPMLCreateDate,:IPMLCreateLocDR,:IPMLCreateTime,
     :IPMLCreateUserDR,:IPMLStandby1,:IPMLEngineerDR,:IPMLMenu,:IPMLList,:IPMLDegreeDR,
     :XYSHRIDvalue,'N',:LocDemFlag,:LocUser))
    if (SQLCODE)
    {
	    TROLLBACK
	}
    s rowid=$o(^PMPImprovementList(""),-1)
	s mark=IPMLStandby3
	i IPMLAdjunctFlag="Y" S IPMLAdjunctFlag="Yes"
	i IPMLAdjunctFlag="N" S IPMLAdjunctFlag="No"
	
	&sql(insert into sqluser.PMP_ImprovementDetail 
	(PMP_ImprovementList_ParRef,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,
	IPMD_UpdateUser_DR,IPMD_Remark,IPMD_Accessory,IPMD_Locid,IPMD_Flag) 
	values (:rowid,:IPMLStatusDR,:IPMLCreateDate,:IPMLCreateTime,:IPMLCreateUserDR,:mark,
	:IPMLAdjunctFlag,:locid,:ApplicationTypeRet))
	if (SQLCODE) TROLLBACK
	s fujian=$P(input1,"^",11)
	/*
	i fujian'=""  d
    .f ii=1:1:$l(fujian,"||")  d
	..s IPAJImprove=rowid
	..s IPAJLocation=$p(fujian,"||",ii)
	..s IPAJName=$p($p(fujian,"||",ii),"\",$l($p(fujian,"||",ii),"\"))
	..s IPAJAffiliation="Improvement"
	..s IPAJDate=+$h
	..s IPAJTime=$p($h,",",2)
	..s IPAJUserDR=$P(input1,"^",15) //add by dongzt 位置不对
	..;s IPAJLocation="c:/ddsd"
	..b ;;err
	..&sql(insert into sqluser.PMP_ImprovementAdjunct 
	(IPAJ_Improve,IPAJ_Name,IPAJ_Location,IPAJ_Affiliation,IPAJ_User_DR,IPAJ_Date,IPAJ_Time)
	 values (:IPAJImprove,:IPAJName,:IPAJLocation,'Improvement',:IPAJUserDR,:IPAJDate,
	 :IPAJTime))
	b ;;05
	if (SQLCODE) 
	{TROLLBACK}
	*/
	;s ret="Insertsuss"
	/*
	s flag=$p(input,"@@",2)
	if (flag="Submit")
	{
		if $d(^PMPImprovementList) set Rowid=$o(^PMPImprovementList(""),-1)
		d ..SubmitApplication(Rowid)
	}
   */
	if (SQLCODE) 
	{TROLLBACK}
	else
	{
		TCOMMIT
	}
	if $d(^PMPImprovementList) set Rowid=$o(^PMPImprovementList(""),-1)
	;{set Rowid=$o(^PMPImprovementList(""),-1)}
	
	
	q $g(SQLCODE)_"^"_$g(Rowid)
}

//edit by dongzt 增加事务处理

ClassMethod SubmitApplication(Input As %String, ip As %String = "") As %String
{
	s UserSavetypeid=##Class(web.PMP.Document).UserSavetype()
	s submittypeid=##Class(web.PMP.Document).submittype()
	s ApplicationTypeRet=##Class(web.PMP.Document).ApplicationType()
	s ret=""
	q:(Input="") ""
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)  //add by dongzt 
	s Rowid=$g(Input)
	s UserId=%session.Data("LOGON.USERID")
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	s ConvertUserRet=""
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,ip)
	TSTART
	&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:submittypeid,IPML_Auditor1=:UserId where IPML_Rowid=:Rowid) 
	if (SQLCODE) 
	{
		TROLLBACK
	}
	else
	{
		&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,:ApplicationTypeRet,:submittypeid,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))	
		if (SQLCODE)
		{
			TROLLBACK
		}
		else
		{
			TCOMMIT
		}

	}
		
	
	q $g(SQLCODE)
}

/// created by dongzt
/// 2015-01-19
/// w ##class(DHCPM.Application.PMApply).DeleteApply(42)
ClassMethod DeleteApply(Input As %String) As %String
{
	;s ^dongzt("delete")=Input
	Set Input=$tr(Input," ")
	q:Input="" ""
	TStart
	&sql(delete from sqluser.PMP_ImprovementList WHERE IPML_Rowid=:Input)
	if ((SQLCODE=0)&($d(^PMPImprovementDetail(Input))))
	{
		b ;;;;
		set dRowid=""
		for  set dRowid=$o(^PMPImprovementDetail(Input,dRowid)) q:(dRowid="")
		.q:dRowid="E"
		.s IPMDRowid=Input_"||"_dRowid
		.&sql(delete from sqluser.PMP_ImprovementDetail WHERE IPMD_Rowid=:IPMDRowid)
		.q:SQLCODE'=0
		
		
		
	}
	/*
	if ((SQLCODE=0)&($d(^PMPImprovementRevList(Input))))
		{
			&sql(delete from sqluser.PMP_ImprovmentRevList  WHERE PMP_ImprovementRevList_ParRef=:Input)
		}
		*/
		if ((SQLCODE=0)&($d(^PMPImproveAdjuncti("Improve",Input))))
		{
			&sql(delete from sqluser.PMP_ImprovementAdjunct  WHERE IPAJ_Improve=:Input)
		}
		
	IF (SQLCODE)
	{TROLLBACK}
	else
	{TCOMMIT}
	
	q $g(SQLCODE)
}

//edit by zzp 2015-06-03

ClassMethod ReceiptInsert(Input As %String, Rowid As %String) As %String
{
	;s ^zzp("ReceiptInsert")=Input_"^"_Rowid
    q:(Input="")||(Rowid="") ""
    
    s IPMLHZZTLXret=##class(web.PMP.Document).IPMLHZZTLX()
    s date=+$h,time=$p($h,",",2)
    s locid=%session.Data("LOGON.CTLOCID")
    s userId=%session.Data("LOGON.USERID")
    s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
    s statusid=$p(IPMLHZZTLXret,"#",1)
    s falfid=$p(IPMLHZZTLXret,"#",2)
    Ts
    &sql(update sqluser.PMP_ImprovementList set IPML_Status_DR=:statusid,IPML_Standby3=:Input WHERE IPML_Rowid=:Rowid)
   	if (SQLCODE=0)
   	{
    	&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Status_DR,IPMD_Flag,IPMD_Remark,IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,:statusid,:falfid,:Input,:date,:time,:userId,:locid))
   	}
   	
   	if (SQLCODE) {
	   	Tro
	   	} 
    else {
	    Tc
	    }
   	
	q $g(SQLCODE)
}

//完成需求

//edit by zzp 2015-06-03

ClassMethod FinishInsert(Rowid As %String) As %String
{
	s ret=""
	q:(Rowid="") " "
	s FinishHZczRet=##class(web.PMP.Document).FinishHZcz()
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	s FinishTestRet=##class(web.PMP.Document).FinishTest()
    s TestRet=$p(FinishTestRet,",",1)
    s FinishRet=$p(FinishTestRet,",",2)
	Tstart
	&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:FinishRet,IPML_FinishDate=:IPMLCreateDate,IPML_FinishTime=:IPMLCreateTime where IPML_Rowid=:Rowid) 
	if (SQLCODE=0)
	{&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Status_DR,IPMD_Flag, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,:FinishRet,:FinishHZczRet,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	}
	if (SQLCODE=0)
	{Tcommit}
	else
	{Trollback}
	q $g(SQLCODE)
}

/// created by zzp
/// 2015-05-23
/// 插入附件记录(需求附件)
/// input  原文件名,ft服务器上的文件名,关联记录的rowid,附件标志,IP
/// w ##class(DHCPM.Application.PMApply).Adjunct("","","","","")
/// output  1:成功  
ClassMethod Adjunct(OldFileName As %String, NewFileName As %String, Rowid As %String, AdjunctType As %String, IP As %String) As %String
{
	s ret=""
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,IP)
	s Date=+$h,Time=$p($h,",",2)
	q:(OldFileName="")||(NewFileName="")||(Rowid="")||(AdjunctType="") "-1"
	Ts
	s object=##Class(User.PMPImprovementAdjunct).%New()
	s object.IPAJName=$p(OldFileName,"\",$l(OldFileName,"\"))
	s object.IPAJLocation=OldFileName
	s object.IPAJImprove=Rowid
	s object.IPAJAffiliation=AdjunctType
	s object.IPAJStandby3=NewFileName
	s object.IPAJDate=Date
	s object.IPAJTime=Time
	s object.IPAJUserDR=UserId
	s object.IPAJStandby4=$p(OldFileName,".",$l(OldFileName,"."))
	s object.IPAJStandby5=IP
	s sc=object.%Save()
	if sc{
		  Tc
		  s objim=##Class(User.PMPImprovementList).%OpenId(Rowid)
		  s objim.IPMLAdjunctFlag="Y"
		  s ss=objim.%Save()
		}
	else {
		  Tro
		}
	s ret=sc
	q ret
}

/// created by zzp
/// 2015-05-23
/// 插入下载记录
/// input  附件来源id,表名,IP
/// w ##class(DHCPM.Application.PMApply).PMPDownloads("","","")
/// output  1:成功 
ClassMethod PMPDownloads(Rowid As %String, TabName As %String, IP As %String) As %String
{
	s ret=""
	q:(Rowid="")||(TabName="") ""
	s Date=+$h,Time=$p($h,",",2)
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,IP) 
	Ts
	s object=##Class(User.PMPDownloads).%New()
	S object.PDMDDate=Date
	s object.PDMDTime=Time
	s object.PDMDIP=IP
	s object.PDMDSourceDocument=Rowid
	s object.PDMDType=TabName
	s object.PDMDUser=UserId
	s sc=object.%Save()
	if sc{
		Tc
		}
	else {
		Tro
		}
	s ret=sc
	q ret
}

/// created by zzp
/// 2015-05-23
/// 插入附件记录(非需求)
/// input  原文件名,ft服务器上的文件名,关联记录的rowid,附件标志,IP
/// w ##class(DHCPM.Application.PMApply).AdjunctAll("C:\Users\Administrator\Desktop\新建文件夹\n_t0d36249fd2085801783de.jpg","637263224012A8OY6.jpg","","","")
/// output  1:成功  
ClassMethod AdjunctAll(OldFileName As %String, NewFileName As %String, Rowid As %String, AdjunctType As %String, IP As %String) As %String
{
	s ret=""
	;s ^Temp("AdjunctAll")=OldFileName_"^"_NewFileName_"^"_Rowid_"^"_AdjunctType_"^"_IP
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,IP)
	s Date=+$h,Time=$p($h,",",2)
	q:(OldFileName="")||(NewFileName="")||(Rowid="")||(AdjunctType="") "-1"
	Ts
	s object=##Class(User.PMPImprovementAdjunct).%New()
	s object.IPAJName=$p(OldFileName,"\",$l(OldFileName,"\"))
	s object.IPAJLocation=OldFileName
	s object.IPAJImprove=Rowid
	s object.IPAJAffiliation=AdjunctType
	s object.IPAJStandby3=NewFileName
	s object.IPAJDate=Date
	s object.IPAJTime=Time
	s object.IPAJUserDR=UserId
	s object.IPAJStandby4=$p(OldFileName,".",$l(OldFileName,"."))
	s object.IPAJStandby5=IP
	s sc=object.%Save()
	if sc{
		  Tc
		  i AdjunctType="Improvement"  d
		  .s objim=##Class(User.PMPImprovementList).%OpenId(Rowid)
		  .s objim.IPMLAdjunctFlag="Y"
		  .s ss=objim.%Save()
		}
	else {
		  Tro
		}
	s ret=sc
	q ret
}

}
