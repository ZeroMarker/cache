///     ClsName: web.PMP.PMPRunQianQueryOut
/// Description: 用于需求管理统计报表输出Query
/// 	Creator: liubaoshi
///        Date: 2015-05-19
///        
Class web.PMP.PMPRunQianQueryOut Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

///       InPut: mSDate,mEDate
///      Return: loc,locname,type,TypeDesc,UFNum,FNum
/// Description: 根据需求类型显示未完成与完成数量统计
///     Creator: liubaoshi
///   CreatDate：
///       Table: 
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PmpTypeNum","2015-01-05","2015-03-18")
Query PmpTypeNum(mSDate As %String, mEDate As %String) As %Query(ROWSPEC = "loc:%String,locname:%String,type:%String,typedesc:%String,UFNum:%Float,FNum:%Float") [ SqlProc ]
{
}

ClassMethod PmpTypeNumExecute(ByRef qHandle As %Binary, mSDate As %String, mEDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    k ^TempPMPTypeNum($j)
	i (mSDate="")||(mEDate="" ) Set qHandle=$lb(0,repid,0)
 	i (mSDate="")||(mEDate="" ) Quit $$$OK
 	s mSDate=$zdh(mSDate,3) s mEDate=$zdh(mEDate,3)
 	f mDate=mSDate:1:mEDate d
 	.s Rowid=0 f  s Rowid=$o(^PMPImprovementListi("CreateDate",mDate,Rowid)) q:(Rowid="")  d
 	..s ListStr=$g(^PMPImprovementList(Rowid))
 	..s CreateLoc=$p(ListStr,"^",12)    ;创建科室
	..s Type=$p(ListStr,"^",31)         ;类型
	..s StatusDr=$p(ListStr,"^",28)     ;状态
	..q:'$d(^PMPDictionary(StatusDr))
	..s Status=$p(^PMPDictionary(StatusDr),"^",2)
	..s ^TempPMPTypeNum($j,"PMPTypeTotalNum",CreateLoc,Type)=$g(^TempPMPTypeNum($j,"PMPTypeTotalNum",CreateLoc,Type))+1
	..i Status["完成" d
	...s ^TempPMPTypeNum($j,"PMPTypeFNum",CreateLoc,Type)=$g(^TempPMPTypeNum($j,"PMPTypeFNum",CreateLoc,Type))+1
	..e  d
	...s ^TempPMPTypeNum($j,"PMPTypeUFNum",CreateLoc,Type)=$g(^TempPMPTypeNum($j,"PMPTypeUFNum",CreateLoc,Type))+1
	s loc=0  f  s loc=$o(^TempPMPTypeNum($j,"PMPTypeTotalNum",loc)) q:(loc="")  d
	.s type=0  f  s type=$o(^TempPMPTypeNum($j,"PMPTypeTotalNum",loc,type)) q:(type="")  d
	..s FNum=+$g(^TempPMPTypeNum($j,"PMPTypeFNum",loc,type))
	..s UFNum=+$g(^TempPMPTypeNum($j,"PMPTypeUFNum",loc,type))
	..d PmpTypeNumExecute
	k ^TempPMPTypeNum($j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PmpTypeNumExecute
    Q:(('$d(^CTLOC(loc)))&('$d(^PMPDictionary(type))))
    s locname=$p(^CTLOC(loc),"^",2)
    i locname["-" s locname=$p(locname,"-",2)
    s TypeDesc=$P(^PMPDictionary(type),"^",2)
	set Data=$lb(loc,locname,type,TypeDesc,UFNum,FNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
 	Quit $$$OK
}

ClassMethod PmpTypeNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PmpTypeNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PmpTypeNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PmpTypeNumExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: mSDate,mEDate
///      Return: product,ProductDesc,emergency,EmergencyDesc,num
/// Description: 根据产品组,需求紧急程度,汇总统计需求状态为"完成"情况下数量
///     Creator: liubaoshi
///   CreatDate：
///       Table: 
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PmpProductEmerNum","2015-01-05","2015-03-18")
Query PmpProductEmerNum(mSDate As %String, mEDate As %String) As %Query(ROWSPEC = "Product:%String,ProductDesc:%String,Emergency:%String,EmergencyDesc:%String,Num:%Float") [ SqlProc ]
{
}

ClassMethod PmpProductEmerNumExecute(ByRef qHandle As %Binary, mSDate As %String, mEDate As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    k ^ProductEmer($j)
	i (mSDate="")||(mEDate="" ) Set qHandle=$lb(0,repid,0)
 	i (mSDate="")||(mEDate="" ) Quit $$$OK
 	s mSDate=$zdh(mSDate,3) s mEDate=$zdh(mEDate,3)
 	f mDate=mSDate:1:mEDate d
 	.s Rowid=0 f  s Rowid=$o(^PMPImprovementListi("CreateDate",mDate,Rowid)) q:(Rowid="")  d
 	..s ListStr=$g(^PMPImprovementList(Rowid))
 	..s StatusDr=$p(ListStr,"^",28)               ;需求状态IPML_Status_DR
	..q:'$d(^PMPDictionary(StatusDr))
	..s Status=$p(^PMPDictionary(StatusDr),"^",2)
	..q:Status'="完成"
 	..s ModuleDR=$p(ListStr,"^",23)               ;所属模块 IPML_Module_DR
 	..q:ModuleDR=""                               ;为空没更新,算"未完成"状态下的需求
 	..q:'$d(^PMPModule(ModuleDR))
 	..s ProductDR=$p(^PMPModule(ModuleDR),"^",7)  ;产品组 MODE_Product_DR
 	..s EmergencyDR=$p(ListStr,"^",18)            ;紧急程度 IPML_Emergency_DR
 	..s ^ProductEmer($j,"ProductEmer",ProductDR,EmergencyDR)=$g(^ProductEmer($j,"ProductEmer",ProductDR,EmergencyDR))+1
 	s product=0 f  s product=$o(^ProductEmer($j,"ProductEmer",product)) q:(product="")  d
 	.s emergency=0 f  s emergency=$o(^ProductEmer($j,"ProductEmer",product,emergency)) q:(emergency="")  d
 	..s num=+$g(^ProductEmer($j,"ProductEmer",product,emergency))
 	..d PmpProductEmerNum
	k ^ProductEmer($j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PmpProductEmerNum
    Q:(('$d(^PMPDictionary(product)))&('$d(^PMPDictionary(emergency))))
    s ProductDesc=$p(^PMPDictionary(product),"^",2)
    s EmergencyDesc=$p(^PMPDictionary(emergency),"^",2)
	set Data=$lb(product,ProductDesc,emergency,EmergencyDesc,num)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
 	Quit $$$OK
}

ClassMethod PmpProductEmerNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PmpProductEmerNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PmpProductEmerNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PmpProductEmerNumExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: mSdate,mEdate,eMergency
///      Return: IPMLName,IPMLMenu,CDate,CTime,CLoc,CUser,AssignEngineer,PredictTime,FDate,FTime,IPMDay
/// Description: 产品组完成需求明细
///     Creator: liubaoshi
///   CreatDate：
///       Table: 
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PmpProductEmerDetail","2014-05-01","2015-05-24","","","113","102","","","")
///              d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PmpProductEmerDetail","2014-05-01","2015-05-24","","","113","","","25","")
Query PmpProductEmerDetail(mSdate As %String, mEdate As %String, eMergency As %String, Product As %String, type As %String, loc As %String, Engineer As %String, develop As %String, menu As %String) As %Query(ROWSPEC = "Rowid:%String,IPMLName:%String,IPMLCreateDate:%String,IPMLCreateTime:%String,IPMLCreateLoc:%String,IPMLCreateUser:%String,IPMLMenu:%String,AssignEngineer:%String,IPMLPredictTime:%Float,IPMLFinishDate:%String,IPMLFinishTime:%String,IPMDay:%Float,ProductDesc:%String,EmergencyDesc:%String,DevelopUsername:%String,Status:%String") [ SqlProc ]
{
}

ClassMethod PmpProductEmerDetailExecute(ByRef qHandle As %Binary, mSdate As %String, mEdate As %String, eMergency As %String, Product As %String, type As %String, loc As %String, Engineer As %String, develop As %String, menu As %String) As %Status
{
	;s ^zzp("PmpProductEmerDetail")=mSdate_"^"_mEdate_"^"_eMergency_"^"_Product_"^"_type_"^"_loc
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (mSdate="")||(mEdate="" ) Set qHandle=$lb(0,repid,0)
 	i (mSdate="")||(mEdate="" ) Quit $$$OK
 	s mSdate=$zdh(mSdate,3) s mEdate=$zdh(mEdate,3)
 	s (CDate,CTime,FDate,FTime,IPMDay,DevelopUsername)=""
 	f mDate=mSdate:1:mEdate d
 	.s Rowid=0 f  s Rowid=$o(^PMPImprovementListi("CreateDate",mDate,Rowid)) q:(Rowid="")  d
 	..s ListStr=$g(^PMPImprovementList(Rowid))
 	..s EmergencyDR=$p(ListStr,"^",18)             ;紧急程度 IPML_Emergency_DR
 	..q:EmergencyDR=""
    ..q:(eMergency'="")&(EmergencyDR'=eMergency)
    ..q:'$d(^PMPDictionary(EmergencyDR))
    ..s EmergencyDesc=$p(^PMPDictionary(EmergencyDR),"^",2)
    ..s Type=$p(ListStr,"^",31)                    ;类型
    ..q:(type'="")&(Type'=type)
    ..s StatusDr=$p(ListStr,"^",28)               ;需求状态IPML_Status_DR
	..q:'$d(^PMPDictionary(StatusDr))
	..s Status=$p(^PMPDictionary(StatusDr),"^",2)
	..q:Status'="完成"
    ..s ModuleDR=$p(ListStr,"^",23)                ;所属模块 IPML_Module_DR
 	..;q:ModuleDR=""  
 	..i ModuleDR'=""  d                              ;为空没更新,算"未完成"状态下的需求
 	...q:'$d(^PMPModule(ModuleDR))
 	...s ProductDR=$p(^PMPModule(ModuleDR),"^",7)   ;产品组 MODE_Product_DR
 	...q:(Product'="")&(ProductDR'=Product)
 	...s ProductDesc=$p(^PMPDictionary(ProductDR),"^",2)  
    ..s IPMLName=$p(ListStr,"^",2)              ;需求名称
    ..s CreateDate=$p(ListStr,"^",11)           ;创建日期
    ..i CreateDate'="" s CDate=$zd(CreateDate,3)
    ..s CreateTime=$p(ListStr,"^",14)           ;创建时间
    ..i CreateTime'="" s CTime=$zt(CreateTime,3)
    ..s CreateLoc=$p(ListStr,"^",12)            ;创建科室
    ..;b ;333
    ..q:(loc'="")&(CreateLoc'=loc)
    ..q:'$d(^CTLOC(CreateLoc))
    ..s CLoc=$p($p(^CTLOC(CreateLoc),"^",2),"-",2)
    ..s CreateUser=$p(ListStr,"^",15)           ;创建人
    ..s CUser=##Class(web.PMP.Document).SSUSER(CreateUser)
    ..s DevelopUser=$p(ListStr,"^",17)    	    ;指派开发//
    ..q:(develop'="")&(DevelopUser'=develop)
    ..i DevelopUser'="" s DevelopUsername=##Class(web.PMP.Document).SSUSER(DevelopUser)    
    ..s IPMLMenu=$p(ListStr,"^",21)             ;菜单名称
    ..q:(menu'="")&(IPMLMenu'=menu)
    ..s AssignEngineer=$p(ListStr,"^",4)        ;指派工程师
    ..q:(Engineer'="")&(AssignEngineer'=Engineer)
    ..;q:'$d(^PMPProjectUser(AssignEngineer))
    ..i AssignEngineer'=""  d
    ...;s AssignUserDr=$p(^PMPProjectUser(AssignEngineer),"^",1)
    ...s AssignUser=##Class(web.PMP.Document).SSUSER(AssignEngineer)
    ..s PredictTime=$p(ListStr,"^",24)          ;预计完成时间(天数)
    ..s FinishDate=$p(ListStr,"^",19)           ;完成日期
    ..i FinishDate'="" s FDate=$zd(FinishDate,3)
    ..e  d
    ...s FDate="" 
    ..s FinishTime=$p(ListStr,"^",20)           ;完成时间
    ..i FinishTime'="" s FTime=$zt(FinishTime,3)
    ..e  d
    ...s FTime=""
    ..i FinishDate'="" d
    ...s IPMDay=$g(FinishDate)-$g(CreateDate)   ;用时天数 
    ...i +$g(IPMDay)<1 s IPMDay=1
 	..d PmpProductEmerDetail
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PmpProductEmerDetail
	set Data=$lb(Rowid,IPMLName,CDate,CTime,CLoc,CUser,IPMLMenu,AssignUser,PredictTime,FDate,FTime,IPMDay,ProductDesc,EmergencyDesc,DevelopUsername,Status)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod PmpProductEmerDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PmpProductEmerDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PmpProductEmerDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PmpProductEmerDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: 空
///      Return: Project,ProjectDesc,PJUUser,PJUUserName,FessionDr,Fession,PJUStDate,PJUStTime,PJUEnDate,PJUEnTime,
///              ModuleDesc,MDUStDate,MDUStTime,MDUEnDate,MDUEnTime
/// Description: 成员管理查询
///     Creator: liubaoshi
///   CreatDate：
///       Table: 
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PmpProjectUser")
Query PmpProjectUser() As %Query(ROWSPEC = "ID:%String,Project:%String,ProjectDesc:%String,PJUUser:%String,PJUUserName:%String,PJUProfession:%String,PJUProfessionDesc:%String,PJUStDate:%String,PJUStTime:%String,PJUEnDate:%String,PJUEnTime:%String,Day:%Float") [ SqlProc ]
{
}

ClassMethod PmpProjectUserExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	s (PJUStDate,PJUStTime,PJUEnDate,PJUEnTime)=""
    s ID=0 f  s ID=$o(^PMPProjectUser(ID)) q:(ID="")  d
    .s StrList=$g(^PMPProjectUser(ID))
    .s Project=$p(StrList,"^",12)
    .q:'$d(^PMPProject(Project))
    .s ProjectDesc=$p(^PMPProject(Project),"^",2)
    .s PJUUser=$p(StrList,"^",1)
    .s PJUUserName=##Class(web.PMP.Document).SSUSER(PJUUser)
    .s FessionDr=$p(StrList,"^",2)
    .s Fession=""
    .i FessionDr'=""  d
    ..;q:'$d(^PMPDictionary(FessionDr))
    ..s Fession=$p(^PMPDictionary(FessionDr),"^",2)
    .s PJUStDate1=$p(StrList,"^",4)
    .i PJUStDate1'=""  s PJUStDate=$zd(PJUStDate1,3)
    .s PJUStTime1=$p(StrList,"^",8)
    .i PJUStTime1'=""  s PJUStTime=$zt(PJUStTime1,3)
    .s PJUEnDate1=$p(StrList,"^",5)
    .i PJUEnDate1'=""  s PJUEnDate=$zd(PJUEnDate1,3) 
    .s PJUEnTime1=$p(StrList,"^",9)
    .i PJUEnTime1'=""  s PJUEnTime=$zt(PJUEnTime1,3)
    .i PJUEnDate1="" s PJUEnDate1=+$H
    .i PJUEnTime1="" s PJUEnTime1=$p($h,",",2)
    .s Day=$g(PJUEnDate1)-$g(PJUStDate1)
    .i +$g(Day)<0 s Day=1
    .d PmpProjectUser
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PmpProjectUser
	set Data=$lb(ID,Project,ProjectDesc,PJUUser,PJUUserName,FessionDr,Fession,PJUStDate,PJUStTime,PJUEnDate,PJUEnTime,Day)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
 	Quit $$$OK
}

ClassMethod PmpProjectUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PmpProjectUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PmpProjectUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PmpProjectUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: Rowid
///      Return: SSUserid,TMDUUser,TMDUModuleID,TMDUModule,TMDURemark,TMDUStDate,TMDUStTime,TMDUEnDate,TMDUEnTime,TMDUDate,TMDUTime
/// Description: 成员负责模块明细
///     Creator: liubaoshi
///   CreatDate：
///       Table: 
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","ModuleUserDetail","2")
Query ModuleUserDetail(ProjectRowid As %String) As %Query(ROWSPEC = "MDUUserDR:%String,MDUUserName:%String,ModuleDR:%String,Module:%String,Remark:%String,MDUStDate:%String,MDUStTime:%String,MDUEnDate:%String,MDUEnTime:%String,MDUDate:%String,MDUTime:%String,Day:%Float") [ SqlProc ]
{
}

ClassMethod ModuleUserDetailExecute(ByRef qHandle As %Binary, ProjectRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	s (TMDUStDate,TMDUEnDate,TMDUEnTime)=""
    s Rowid=0 f  s Rowid=$o(^PMPModuleUser(Rowid)) q:(Rowid="")  d
    .s TRowid=Rowid
    .s proUserid=$p(^PMPModuleUser(Rowid),"^",10)
    .q:'$d(^PMPProjectUser(proUserid))
    .s SSUserid=$p(^PMPProjectUser(proUserid),"^",1)
    .s TMDUUser=##Class(web.PMP.Document).SSUSER(SSUserid)
    .i ProjectRowid'=""  q:proUserid'=ProjectRowid
    .q:ProjectRowid=""
    .s TMDUModuleID=$p(^PMPModuleUser(Rowid),"^",5)  
    .s TMDUModule=$P(^PMPModule(TMDUModuleID),"^",2)
    .s TMDURemark=$p(^PMPModuleUser(Rowid),"^",6)
    .s TMDUStDate1=$p(^PMPModuleUser(Rowid),"^",7)   ;开始日期
    .i TMDUStDate1'="" s TMDUStDate=$zd(TMDUStDate1,3)
    .s TMDUEnDate1=$p(^PMPModuleUser(Rowid),"^",2)  ; 结束日期    
    .i TMDUEnDate1'="" s TMDUEnDate=$zd(TMDUEnDate1,4)
    .s TMDUStTime=$zt($p(^PMPModuleUser(Rowid),"^",8))    
    .s TMDUEnTime=$p(^PMPModuleUser(Rowid),"^",3)
    .i TMDUEnTime'="" s TMDUEnTime=$zt(TMDUEnTime)
    .s TMDUDate=$zd($p(^PMPModuleUser(Rowid),"^",1),4)  
    .s TMDUTime=$zt($p(^PMPModuleUser(Rowid),"^",9))
	.i TMDUEnDate1="" s TMDUEnDate1=+$H
	.s Day=$g(TMDUEnDate1)-$g(TMDUStDate1)
    .i +$g(Day)<0 s Day=1
    .d ModuleUserDetail
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ModuleUserDetail
	set Data=$lb(SSUserid,TMDUUser,TMDUModuleID,TMDUModule,TMDURemark,TMDUStDate,TMDUStTime,TMDUEnDate,TMDUEnTime,TMDUDate,TMDUTime,Day)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
 	Quit $$$OK
}

ClassMethod ModuleUserDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ModuleUserDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ModuleUserDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ModuleUserDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: Null
///      Return: Data=$lb()
/// Description: 获取合同详情
///     Creator: liubaoshi
///   	   Date：2015-05-19
///       Table: PMP_Contract,PMP_Dictionary,PMP_Company,SS_User
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PMPContract")
Query PMPContract() As %Query(ROWSPEC = "mRowid:%String,PCTCode:%String,PCTDesc:%String,PCTGroup:%String,PCTType:%String,PCTPrincipal:%String,PCTDepartment:%String,PCTDate:%String,PCTTime:%String,PCTMoney:%String,PCTExecution:%String,PCTConMode:%String,PCTSource:%String,PCTEfDate:%String,PCTEfTime:%String,PCTFDate:%String,PCTFTime:%String,PCTStatus:%String,PCTFirstParty:%String,PCTFirstUser:%String,PCTSecondParty:%String,PCTSecondUser:%String,PCTThirdParty:%String,PCTThirdUser:%String") [ SqlProc ]
{
}

ClassMethod PMPContractExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
    Set mRowid=""
    Set (PctGroup,PctType,PctMoney,PctExecution,PctConMode,PctSource,PCTStatus,PCTFirstParty,PCTFirstUser,PCTSecondParty,PCTSecondUser,PCTThirdParty,PCTThirdUser)=""
    For 	{
	    	Set mRowid=$o(^PMPContract(mRowid)) 
	    	Quit:mRowid=""
	    	b ;
	    	Set ObjectList=##class(User.PMPContract).%OpenId(mRowid)
	    	If $IsObject(ObjectList)
	    		{
		    		Set PctStandby1=ObjectList.PCTStandby1
	    			Set PctCode = ObjectList.PCTCode                    ;合同编码
	    			Set PctDesc = ObjectList.PCTDesc                    ;合同名称
	    			Set PctGroup = ObjectList.PCTGroup.DTYDesc          ;合同分组
	    			Set PctType = ObjectList.PCTType.DTYDesc            ;合同类型
	    			Set PctPrincipal = ObjectList.PCTPrincipal          ;负责人
	    			Set PctDepartment = ObjectList.PCTDepartment        ;部门
					Set PctDate = ObjectList.PCTDate                    ;签订日期
					If (PctDate'=""){
							Set PctDate = $zd(PctDate,3)
						}
						Else{
							Set PctDate =""
							}
			    	Set PctTime = ObjectList.PCTTime                    ;签订时间
			    	If (PctTime'=""){
		    			 		Set PctTime=$zt(PctTime,3)
	    					}
	    				Else{ 
	    			 			Set PctTime=""
	    				}
			    	Set PctMoney = ObjectList.PCTTotalMoney             ;总金额
			    	Set PctExecution = ObjectList.PCTModeExecution.DTYDesc     ;履行方式
			    	Set PctConMode = ObjectList.PCTConcludeMode.DTYDesc        ;订立方式
			    	Set PctSource = ObjectList.PCTSource.DTYDesc               ;采购来源
			    	Set PctEfDate = ObjectList.PCTEffectiveDate        ;生效日期
					If (PctEfDate'=""){
		    			 		Set PctEfDate=$zd(PctEfDate,3)
	    					}
	    				Else{ 
	    			 			Set PctEfDate=""
	    				}
			    	Set PctEfTime = ObjectList.PCTEffectiveTime        ;生效时间
			    	If (PctEfTime'=""){
		    			 		Set PctEfTime=$zt(PctEfTime,3)
	    					}
	    				Else{ 
	    			 			Set PctEfTime=""
	    				}
			    	Set PCTFDate = ObjectList.PCTFinishDate            ;结束日期
			    	If (PCTFDate'=""){
		    			 		Set PCTFDate=$zd(PCTFDate,3)
	    					}
	    				Else{ 
	    			 			Set PCTFDate=""
	    				}
			    	Set PCTFTime = ObjectList.PCTFinishTime            ;结束时间
			    	If (PCTFTime'=""){
		    			 		Set PCTFTime=$zt(PCTFTime,3)
	    					}
	    				Else{ 
	    			 			Set PCTFTime=""
	    				}
			    	Set PCTStatus = ObjectList.PCTStatus.DTYDesc               ;合同状态
			    	Set PCTFirstParty = ObjectList.PCTFirstParty.PCDesc        ;甲方单位
			    	Set PCTFirstUser = ObjectList.PCTFirstUser                 ;甲方负责人
			    	Set PCTSecondParty = ObjectList.PCTSecondParty.PCDesc      ;乙方单位
			    	Set PCTSecondUser = ObjectList.PCTSecondUser               ;乙方负责人
			    	Set PCTThirdParty = ObjectList.PCTThirdParty.PCDesc        ;丙方单位
			    	Set PCTThirdUser = ObjectList.PCTThirdUser                 ;丙方负责人
			    	Do ObjectList.%Close()  
			    	Do PMPContractExecute
	    	}
	    	 
	    	
	    } 
	 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PMPContractExecute
    q:PctStandby1="N"
	set Data=$lb(mRowid,PctCode,PctDesc,PctGroup,PctType,PctPrincipal,PctDepartment,PctDate,PctTime,PctMoney,PctExecution,PctConMode,PctSource,PctEfDate,PctEfTime,PCTFDate,PCTFTime,PCTStatus,PCTFirstParty,PCTFirstUser,PCTSecondParty,PCTSecondUser,PCTThirdParty,PCTThirdUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
 	Quit $$$OK
}

ClassMethod PMPContractClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMPContractExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PMPContractFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMPContractExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: PctRowID
///      Return: Data=$lb()
/// Description: 合同工期(Two Floor)
///     Creator: liubaoshi
///   	   Date：2015-05-19
///       Table: PMP_ContractAging,PMP_Contract,PMP_Dictionary
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PMPContractAging","1")
Query PMPContractAging(PctRowID As %String) As %Query(ROWSPEC = "mRowid:%String,PctAContract:%String,PctAAging:%String,PctACode:%String,PctADesc:%String,PctAStatus:%String,PctPDate:%String,PctPTime:%String,PctEDate:%String,PctETime:%String,PctStDate:%String,PctStTime:%String,PctEnDate:%String,PctEnTime:%String,PctReark:%String,PctPAgoDay:%Float,PctPLaterDay:%Float,PctAAgoDay:%Float,PctALaterDay:%Float") [ SqlProc ]
{
}

ClassMethod PMPContractAgingExecute(ByRef qHandle As %Binary, PctRowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:PctRowID=""
    Set mRowid=""
    Set (PctAContract,PctAAging,PctAStatus)=""
    For 	{
	    	Set mRowid=$o(^PMPContractAgingi("Contract",PctRowID,mRowid)) 
	    	Quit:(mRowid="")
	    	
	    	Set obj=##class(User.PMPContractAging).%OpenId(mRowid)
	    	If $IsObject(obj)
	    		{
		    		
	    			Set PctAContract = obj.PCTAContract.PCTDesc     ;合同
	    			Set PctAAging = obj.PCTAAging.DTYDesc           ;工期
	    			Set PctACode = obj.PCTACode                    ;工期编码
	    			Set PctADesc = obj.PCTADesc                    ;工期描述
	    			Set PctAStatus = obj.PCTAStatus.DTYDesc        ;工期状态
	    			Set PctPDate = obj.PCTAPlanStartDate           ;计划开始日期
	    			If (PctPDate'=""){
		    			 		Set PctPDate1=$zd(PctPDate,3)
	    					}
	    				Else{ 
	    			 			Set PctPDate1=""
	    				}
	    			Set PctPTime = obj.PCTAPlanStartTime      ;计划开始时间
	    			If (PctPTime'="") {
		    					Set PctPTime1=$zt(PctPTime,3)
		    				}
		    			Else{
			    				Set PctPTime1=""
			    			}           
					Set PctEDate = obj.PCTAPlanEndDate        ;计划结束日期
					If (PctEDate'=""){
		    			 		Set PctEDate1=$zd(PctEDate,3)
	    					}
	    				Else{ 
	    			 			Set PctEDate1=""
	    				}
					Set PctETime = obj.PCTAPlanEndTime        ;计划结束时间
					If (PctETime'="") {
		    					Set PctETime1=$zt(PctETime,3)
		    				}
		    			Else{
			    				Set PctETime1=""
			    			}
					Set PctStDate = obj.PCTAStartDate         ;实际开始日期
					If (PctStDate'=""){
		    			 		Set PctStDate1=$zd(PctStDate,3)
	    					}
	    				Else{ 
	    			 			Set PctStDate1=""
	    				}
					Set PctStTime = obj.PCTAStartTime         ;实际开始时间
					If (PctStTime'="") {
		    					Set PctStTime1=$zt(PctStTime,3)
		    				}
		    			Else{
			    				Set PctStTime1=""
			    			}
					Set PctEnDate = obj.PCTAEndDate           ;实际结束日期
					If (PctEnDate'="") {
		    					Set PctEnDate1=$zd(PctEnDate,3)
		    				}
		    			Else{
			    				Set PctStTime1=""
			    			}
					Set PctEnTime = obj.PCTAEndTime           ;实际结束时间
					If (PctEnTime'="") {
		    					Set PctEnTime1=$zt(PctEnTime,3)
		    				}
		    			Else{
			    				Set PctEnTime1=""
			    			}
			    	Set PctReark=obj.PCTARemark
			    	If (PctPDate>PctStDate){ //计划大于实际日期
				    		Set PctPAgoDay=PctPDate-PctStDate     ;算计划开始提前天数
				    	
				    	}
				    	Else{
					    	Set PctPAgoDay=0
					    	}
					If (PctStDate>PctPDate){ //实际大于计划日期
				    		Set PctPLaterDay=PctStDate-PctPDate     ;算计划开始延迟天数
				    	
				    	}
				    	Else{
					    	Set PctPAgoDay=0
					    	}
					If (PctEDate>PctEnDate){//计划结束日期大于实际结束日期
						 	Set PctAAgoDay=PctEDate-PctEnDate    ;算计划结束日期提前天数
						}
						Else{
							Set PctAAgoDay=0
							}
					If (PctEnDate>PctEDate)&(PctEDate'="0")&(PctEDate'=""){   //实际结束日期大于计划结束日期
							Set PctALaterDay=PctEnDate-PctEDate   ;算计划结束延迟天数
						}
						Else{
							Set PctALaterDay=0
							}
			    	Do PMPContractAging 
					
	    	}	
	    	
	    	
	    } 
	Do obj.%Close()  
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PMPContractAging
	set Data=$lb(mRowid,PctAContract,PctAAging,PctACode,PctADesc,PctAStatus,PctPDate1,PctPTime1,PctEDate1,PctETime1,PctStDate1,PctStTime1,PctEnDate1,PctEnTime1,PctReark,PctPAgoDay,PctPLaterDay,PctAAgoDay,PctALaterDay)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
 	Quit $$$OK
}

ClassMethod PMPContractAgingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMPContractAgingExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PMPContractAgingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMPContractAgingExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: PctAgingID 工期表ID
///      Return: Data=$lb()
/// Description: 获取合同工期子表(模块)明细记录(Three Floor)
///     Creator: liubaoshi
///   	   Date：2015-05-19
///       Table: PMP_ContractAging,PMP_Contract,PMP_Dictionary
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PMPContractAgingMode","1")
Query PMPContractAgingMode(PctAgingID As %String) As %Query(ROWSPEC = "Product:%String,ModeID:%String,ModeCode:%String,ModeDesc:%String,ModeStatus:%String,ModePDate:%String,ModeADate:%String,ModeRemark:%String,PAgoDay:%Float,ALaterDay:%Float") [ SqlProc ]
{
}

ClassMethod PMPContractAgingModeExecute(ByRef qHandle As %Binary, PctAgingID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:PctAgingID=""
    Set mSub=""
    Set (Product,ModeCode,ModeDesc,ModeStatus,ModePDate,ModeADate,ModeRemark)=""
    For 	{
	    	Set mSub=$o(^PMPContractAgingMode(PctAgingID,mSub)) 
	    	Quit:(mSub="")
	    	Quit:mSub="Details"
	    	Set mPcamRowid=PctAgingID_"||"_mSub
	    	Set ModeID=$p(^PMPContractAgingMode(PctAgingID,mSub),"^",2)
	    	Set mobj=##class(User.PMPContractAgingMode).%OpenId(mPcamRowid)
	    	If $IsObject(mobj)
	    		{
	    			Set Product = mobj.PCAMMode.MODEProductDR.DTYDesc     ;产品组
	    			Set ModeCode = mobj.PCAMMode.MODECode                 ;模块code
	    			Set ModeDesc = mobj.PCAMMode.MODEDesc                 ;模块desc
	    			Set ModeStatus = mobj.PCAMMode.MODEStatusDR.DTYDesc   ;模块状态
	    			Set ModePDate = mobj.PCAMMode.MODEPlanDate            ;模块计划上线日期
	    			If (ModePDate'=""){
		    			 		Set ModePDate1=$zd(ModePDate,3)
	    					}
	    				Else{ 
	    			 			Set ModePDate1=""
	    				}
	    			Set ModeADate = mobj.PCAMMode.MODEActuclDate           ;模块实际上线日期
	    			If (ModeADate'=""){
		    			 		Set ModeADate1=$zd(ModeADate,3)
	    					}
	    				Else{ 
	    			 			Set ModeADate1=""
	    				}
	    				
	    			If (ModePDate>ModeADate){//计划早于实际
		    			
		    					Set PAgoDay=ModePDate-ModeADate    ;提前天数
		    				}
		    			Else{
			    				Set PAgoDay=0
			    			}
		    		If (ModeADate>ModePDate){//实际晚于计划
			    				Set ALaterDay=ModeADate-ModePDate   ;延迟天数
			    			}
			    		Else{
				    			Set ALaterDay=0
				    		}
	    			Set ModeRemark = mobj.PCAMMode.MODERemark              ;模块备注
	    			Do PMPContractAgingMode 
	    				
	    	}	
	    	
	    	
	    } 
	Do mobj.%Close()  
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PMPContractAgingMode
	set Data=$lb(Product,ModeID,ModeCode,ModeDesc,ModeStatus,ModePDate1,ModeADate1,ModeRemark,PAgoDay,ALaterDay)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
 	Quit $$$OK
}

ClassMethod PMPContractAgingModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMPContractAgingModeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PMPContractAgingModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMPContractAgingModeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: ModuleID 模块表ID
///      Return: Data=$lb()
/// Description: 根据模块汇总完成需求数量(Four Floor)
///     Creator: liubaoshi
///   	   Date：2015-05-19
///       Table: 
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PmpFinishDemand","1")
Query PmpFinishDemand(ModuleID As %String) As %Query(ROWSPEC = "loc:%String,locname:%String,type:%String,typedesc:%String,module:%String,ModuleDesc:%String,fnum:%Float") [ SqlProc ]
{
}

ClassMethod PmpFinishDemandExecute(ByRef qHandle As %Binary, ModuleID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set ^Tempbaoshi("PmpFinishDemand",$zn,$j)=ModuleID
	Kill ^TempPmpFinishDemand($j)
	Quit:ModuleID=""
    Set mRowid=""
    For 	{
	    		Set mRowid=$o(^PMPImprovementListi("Module",ModuleID,mRowid)) 
	    		Quit:(mRowid="")
	    		Set Str=$g(^PMPImprovementList(mRowid))
				Set CreateLoc=$p(Str,"^",12)     ;创建科室
				Set Type=$p(Str,"^",31)          ;类型
				Set StatusDr=$p(Str,"^",28)      ;状态
				Quit:'$d(^PMPDictionary(StatusDr))
				Set ModuleDr=$p(Str,"^",23)        ;模块
				Quit:'$d(^PMPModule(ModuleDr))    ;因为更新需求时才会更新产品组在此只汇总有产品组dr有完成状态
				Set Status=$p(^PMPDictionary(StatusDr),"^",2)
				If (Status["完成"){ 
			
					Set ^TempPmpFinishDemand($j,"PmpFinishDemand",CreateLoc,ModuleDr,Type)=$g(^TempPmpFinishDemand($j,"PmpFinishDemand",CreateLoc,ModuleDr,Type))+1
				
				}			
	    	}
	  
	Set loc=0  
	For	{  
		Set loc=$o(^TempPmpFinishDemand($j,"PmpFinishDemand",loc)) 
		Quit:loc=""  
		Set module=0  
			For { 
					Set module=$o(^TempPmpFinishDemand($j,"PmpFinishDemand",loc,module)) 
					Quit:(module="")
					Set type=0
					For	{
							Set type=$o(^TempPmpFinishDemand($j,"PmpFinishDemand",loc,module,type))
							Quit:type=""
							Set FNum=+$g(^TempPmpFinishDemand($j,"PmpFinishDemand",loc,module,type))
							Do PmpFinishDemand
						}  
 
			}
		
		}
	;Kill ^TempPmpFinishDemand($j)  
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PmpFinishDemand
 	Quit:(('$d(^CTLOC(loc)))&('$d(^PMPDictionary(type))))
    Set locname=$p(^CTLOC(loc),"^",2)
    If locname["-" Set locname=$p(locname,"-",2)
    Set TypeDesc=$P(^PMPDictionary(type),"^",2)
    Set ModuleDesc=$p(^PMPModule(ModuleDr),"^",2)
	set Data=$lb(loc,locname,type,TypeDesc,module,ModuleDesc,FNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
 	Quit $$$OK
}

ClassMethod PmpFinishDemandClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PmpFinishDemandExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PmpFinishDemandFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PmpFinishDemandExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: loc, type
///      Return: Data=$lb()
/// Description: 根据科室,需求类型查询完成需求明细(Five Floor)
///     Creator: liubaoshi
///   	   Date：2015-05-19
///       Table: 
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PmpModuleDetail","102","113")
Query PmpModuleDetail(loc As %String, type As %String, module As %String) As %Query(ROWSPEC = "Rowid:%String,Name:%String,CreateDate:%String,CreateTime:%String,CreateLoc:%String,CreateUser:%String,Menu:%String,AssignEngineer:%String,PredictTime:%Float,FinishDate:%String,FinishTime:%String,IPMDay:%String,ProductDesc:%String,EmergencyDesc:%String") [ SqlProc ]
{
}

ClassMethod PmpModuleDetailExecute(ByRef qHandle As %Binary, loc As %String, type As %String, module As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
 	s (CDate,CTime,FDate,FTime,IPMDay)=""
	
	s Rowid=0 f  s Rowid=$o(^PMPImprovementListi("CreateLoc",loc,Rowid)) q:(Rowid="")  d
 	.s ListStr=$g(^PMPImprovementList(Rowid))
 	.s EmergencyDR=$p(ListStr,"^",18)             ;紧急程度 IPML_Emergency_DR
 	.q:EmergencyDR=""
    .q:'$d(^PMPDictionary(EmergencyDR))
    .s EmergencyDesc=$p(^PMPDictionary(EmergencyDR),"^",2)
    .s Type=$p(ListStr,"^",31)                    ;类型
    .q:Type'=type        //1q
    .s StatusDr=$p(ListStr,"^",28)               ;需求状态IPML_Status_DR
	.q:'$d(^PMPDictionary(StatusDr))
	.s Status=$p(^PMPDictionary(StatusDr),"^",2)
	.q:Status'="完成"
    .s ModuleDR=$p(ListStr,"^",23)                ;所属模块 IPML_Module_DR
    .q:ModuleDR'=module
 	.i ModuleDR'=""  d                              ;为空没更新,算"未完成"状态下的需求
 	..q:'$d(^PMPModule(ModuleDR))
 	..s ProductDR=$p(^PMPModule(ModuleDR),"^",7)   ;产品组 MODE_Product_DR
 	..s ProductDesc=$p(^PMPDictionary(ProductDR),"^",2)  
    .s IPMLName=$p(ListStr,"^",2)              ;需求名称
    .s CreateDate=$p(ListStr,"^",11)           ;创建日期
    .i CreateDate'="" s CDate=$zd(CreateDate,3)
    .s CreateTime=$p(ListStr,"^",14)           ;创建时间
    .i CreateTime'="" s CTime=$zt(CreateTime,3)
    .s CreateLoc=$p(ListStr,"^",12)            ;创建科室
    .q:CreateLoc'=loc     //2q
    .b ;7777
    .q:'$d(^CTLOC(CreateLoc))
    .s CLoc=$p($p(^CTLOC(CreateLoc),"^",2),"-",2)
    .s CreateUser=$p(ListStr,"^",15)           ;创建人
    .s CUser=##Class(web.PMP.Document).SSUSER(CreateUser)
    .s IPMLMenu=$p(ListStr,"^",21)             ;菜单名称
    .s AssignEngineer=$p(ListStr,"^",4)        ;指派工程师
    .i AssignEngineer'=""  d
    ..s AssignUser=##Class(web.PMP.Document).SSUSER(AssignEngineer)
    .s PredictTime=$p(ListStr,"^",24)          ;预计完成时间(天数)
    .s FinishDate=$p(ListStr,"^",19)           ;完成日期
    .i FinishDate'="" s FDate=$zd(FinishDate,3)
    .e  d
    ..s FDate="" 
    .s FinishTime=$p(ListStr,"^",20)           ;完成时间
    .i FinishTime'="" s FTime=$zt(FinishTime,3)
    .e  d
    ..s FTime=""
    .i FinishDate'="" d
    ..s IPMDay=$g(FinishDate)-$g(CreateDate)   ;用时天数 
    ..i +$g(IPMDay)<1 s IPMDay=1
 	.d PmpModuleDetail
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PmpModuleDetail
	set Data=$lb(Rowid,IPMLName,CDate,CTime,CLoc,CUser,IPMLMenu,AssignUser,PredictTime,FDate,FTime,IPMDay,ProductDesc,EmergencyDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod PmpModuleDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PmpModuleDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PmpModuleDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PmpModuleDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: 需求列表IpmID
///      Return: Data=$lb()
/// Description: 根据需求列表ID查询对应需求明细变化记录(Six Floor)
///     Creator: liubaoshi
///   	   Date：2015-05-19
///       Table: PMP_ImprovementDetail
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PmpImprovementDetail","165")
Query PmpImprovementDetail(IpmID As %String) As %Query(ROWSPEC = "IpmFlag:%String,IpmStatus:%String,IpmRemark:%String,IpmUpdate:%String,IpmUptime:%String,IpmUpuser:%String,IpmComCation:%String,IpmComCaUser:%String,IpmComMatter:%String,IpmComDate:%String,IpmComTime:%String") [ SqlProc ]
{
}

ClassMethod PmpImprovementDetailExecute(ByRef qHandle As %Binary, IpmID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	Quit:IpmID=""
	Set (IpmFlag,IpmStatus,IpmComCation)=""
	Set mSub=0 
	For{  
		Set mSub=$o(^PMPImprovementDetail(IpmID,mSub)) 
		Quit:mSub=""
		Q:$G(^PMPImprovementDetail(IpmID,mSub))=""
		Set IpmFlagDr=$p(^PMPImprovementDetail(IpmID,mSub),"^",8)     ;标志
		If (IpmFlagDr'=""){
			
			Set IpmFlag=$p($G(^PMPDictionary(IpmFlagDr)),"^",2) 
			
			}
		Set IpmStatusDr=$p(^PMPImprovementDetail(IpmID,mSub),"^",10)  ;状态
		If (IpmStatusDr'=""){
			
			Set IpmStatus=$p(^PMPDictionary(IpmStatusDr),"^",2) 
			
			}
		Set IpmRemark=$p(^PMPImprovementDetail(IpmID,mSub),"^",9)   ;备注
		Set IpmUpdate=$p(^PMPImprovementDetail(IpmID,mSub),"^",11)  ;更新日期
	    If (IpmUpdate'=""){
		    		Set IpmUpdate=$zd(IpmUpdate,3)
	    			}
	    	Else{ 
	    			 Set IpmUpdate=""
	    			
	    				}
			
		Set IpmUptime=$p(^PMPImprovementDetail(IpmID,mSub),"^",12)  ;更新时间
		If (IpmUptime'=""){
		    		Set IpmUptime=$zt(IpmUptime,3)
	    			}
	    	Else{ 
	    			 Set IpmUptime=""
	    			
	    				}
		Set IpmUpuserDr=$p(^PMPImprovementDetail(IpmID,mSub),"^",13)   ;更新人
    	Set IpmUpuser=##Class(web.PMP.Document).SSUSER(IpmUpuserDr)
		Set IpmComCationDr=$p(^PMPImprovementDetail(IpmID,mSub),"^",2)  ;沟通方式
		If (IpmComCationDr'=""){
			
			Set IpmComCation=$p(^PMPDictionary(IpmComCationDr),"^",2) 
			}
			
		Set IpmComCaUserDr=$p(^PMPImprovementDetail(IpmID,mSub),"^",6)  ;沟通人
		If (IpmComCaUserDr'=""){
			
				Set IpmComCaUser=##Class(web.PMP.Document).SSUSER(IpmComCaUserDr)
			}
			Else {
				
				Set IpmComCaUser=""
				}
		Set IpmComMatter=$p(^PMPImprovementDetail(IpmID,mSub),"^",4)  ;沟通内容
		Set IpmComDate=$p(^PMPImprovementDetail(IpmID,mSub),"^",3)  ;沟通日期
		If (IpmComDate'=""){
		    		Set IpmComDate=$zd(IpmComDate,3)
	    			}
	    	Else{ 
	    			 Set IpmComDate=""
	    			
	    				}
		Set IpmComTime=$p(^PMPImprovementDetail(IpmID,mSub),"^",5)  ;沟通时间
		If (IpmComTime'=""){
		    		Set IpmComTime=$zt(IpmComTime,3)
	    			}
	    	Else{ 
	    			 Set IpmComTime=""
	    			
	    				}
 		Do PmpImprovementDetail
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PmpImprovementDetail
	set Data=$lb(IpmFlag,IpmStatus,IpmRemark,IpmUpdate,IpmUptime,IpmUpuser,IpmComCation,IpmComCaUser,IpmComMatter,IpmComDate,IpmComTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod PmpImprovementDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PmpImprovementDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PmpImprovementDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PmpImprovementDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: Null
///      Return: jectdesc,username,totalnum
/// Description: 统计来过此项目总人次(为了封装csp单独统计总人数,总人次与现有人次)
///     Creator: liubaoshi
///   	   Date：2015-05-19
///       Table: 
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PmpProjectUserNum")
Query PmpProjectUserNum() As %Query(ROWSPEC = "Project:%String,User:%String,TotalNum:%Float") [ SqlProc ]
{
}

ClassMethod PmpProjectUserNumExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill ^TempProjectUserNum($j)
	
    Set mRowid=0 
    For{  
    	Set mRowid=$o(^PMPProjectUser(mRowid)) 
    	Quit:(mRowid="")  
    	Set Project=$p(^PMPProjectUser(mRowid),"^",12)
    	Set PJUUser=$p(^PMPProjectUser(mRowid),"^",1)
		Set ^TempProjectUserNum($j,"ProjectUserNum",Project,PJUUser)=$g(^TempProjectUserNum($j,"ProjectUserNum",Project,PJUUser))+1
    }
	
	Set ject=0 
	For  {
			Set ject=$o(^TempProjectUserNum($j,"ProjectUserNum",ject)) 
			Quit:(ject="")  
			Set user=0 
			For  {
					Set user=$o(^TempProjectUserNum($j,"ProjectUserNum",ject,user)) 
					Quit:(user="")  d
					Set totalnum=+$g(^TempProjectUserNum($j,"ProjectUserNum",ject,user))
    				Do PmpProjectUserNum
    			}
    			
    			
    		}
    Kill ^TempProjectUserNum($j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PmpProjectUserNum
	Quit:'$d(^PMPProject(ject))
	Set jectdesc=$p(^PMPProject(ject),"^",2)
	Set username=##Class(web.PMP.Document).SSUSER(user)
	set Data=$lb(jectdesc,username,totalnum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
 	Quit $$$OK
}

ClassMethod PmpProjectUserNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PmpProjectUserNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PmpProjectUserNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PmpProjectUserNumExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: Null
///      Return: jectdesc,username,totalnum
/// Description: 统计项目当前人数与人次
///     Creator: liubaoshi
///   	   Date：2015-05-19
///       Table: 
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PmpProjeCurrentNum")
Query PmpProjeCurrentNum() As %Query(ROWSPEC = "ProjectName:%String,UserName:%String,CurrentNum:%Float") [ SqlProc ]
{
}

ClassMethod PmpProjeCurrentNumExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill ^TempCurrentNum($j)
	
    Set ID=0 
    For{  
    	Set ID=$o(^PMPProjectUser(ID)) 
    	Quit:(ID="")  
    	Set Project=$p(^PMPProjectUser(ID),"^",12)
    	Set PJUUser=$p(^PMPProjectUser(ID),"^",1)
    	Set EnDate=$p(^PMPProjectUser(ID),"^",5)
    	Quit:EnDate'=""
		Set ^TempCurrentNum($j,"CurrentUserNum",Project,PJUUser)=$g(^TempCurrentNum($j,"CurrentUserNum",Project,PJUUser))+1
    }
	
	Set ject=0 
	For  {
			Set ject=$o(^TempCurrentNum($j,"CurrentUserNum",ject)) 
			Quit:(ject="")  
			Set user=0 
			For  {
					Set user=$o(^TempCurrentNum($j,"CurrentUserNum",ject,user)) 
					Quit:(user="")  d
					Set CurrentNum=+$g(^TempCurrentNum($j,"CurrentUserNum",ject,user))
    				Do PmpProjeCurrentNum
    			}
    			
    			
    		}
    Kill ^TempCurrentNum($j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PmpProjeCurrentNum
	Quit:('$d(^PMPProject(ject)))
	Set jectdesc=$p(^PMPProject(ject),"^",2)
	Set username=##Class(web.PMP.Document).SSUSER(user)
	set Data=$lb(jectdesc,username,CurrentNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
 	Quit $$$OK
}

ClassMethod PmpProjeCurrentNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PmpProjeCurrentNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PmpProjeCurrentNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PmpProjeCurrentNumExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: Stdate,Endate
///      Return: loc,locname,type,TypeDesc,UFNum,FNum
/// Description: 根据指派【工程师】(实施)汇总未完成与完成需求数量
///     Creator: liubaoshi
///   	   Date：2015-05-19
///       Table: 
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","EngineerWork","2015-05-01","2015-05-24")
Query EngineerWork(mSDate As %String, mEDate As %String) As %Query(ROWSPEC = "User:%String,Username:%String,Type:%String,Typedesc:%String,UnNum:%Float,FNum:%Float") [ SqlProc ]
{
}

ClassMethod EngineerWorkExecute(ByRef qHandle As %Binary, mSDate As %String, mEDate As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    k ^TempEngineerWork($j)
	i (mSDate="")||(mEDate="" ) Set qHandle=$lb(0,repid,0)
 	i (mSDate="")||(mEDate="" ) Quit $$$OK
 	s mSDate=$zdh(mSDate,3) s mEDate=$zdh(mEDate,3)
 	f Date=mSDate:1:mEDate d
 	.s Rowid=0 f  s Rowid=$o(^PMPImprovementListi("CreateDate",Date,Rowid)) q:(Rowid="")  d
 	..s Str=$g(^PMPImprovementList(Rowid))
 	..s Engineer=$p(Str,"^",4)    	;指派工程师(指实施)
	..s Type=$p(Str,"^",31)         ;类型
	..s StatusDr=$p(Str,"^",28)     ;状态
	..q:'$d(^PMPDictionary(StatusDr))
	..s Status=$p(^PMPDictionary(StatusDr),"^",2)
	..i Engineer'="" d
	...s ^TempEngineerWork($j,"EngineerWorkTotalNum",Engineer,Type)=$g(^TempEngineerWork($j,"EngineerWorkTotalNum",Engineer,Type))+1
	...i Status["完成" d
	....s ^TempEngineerWork($j,"EngineerWorkFinishNum",Engineer,Type)=$g(^TempEngineerWork($j,"EngineerWorkFinishNum",Engineer,Type))+1
	...e  d
	....s ^TempEngineerWork($j,"EngineerWorkUnFinishNum",Engineer,Type)=$g(^TempEngineerWork($j,"EngineerWorkUnFinishNum",Engineer,Type))+1
	
	s user=0  f  s user=$o(^TempEngineerWork($j,"EngineerWorkTotalNum",user)) q:(user="")  d
	.s type=0  f  s type=$o(^TempEngineerWork($j,"EngineerWorkTotalNum",user,type)) q:(type="")  d
	..s FNum=+$g(^TempEngineerWork($j,"EngineerWorkFinishNum",user,type))
	..s UFNum=+$g(^TempEngineerWork($j,"EngineerWorkUnFinishNum",user,type))
	..d EngineerWorkExecute
	k ^TempEngineerWork($j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
EngineerWorkExecute
    Q:(('$d(^SSU("SSUSR",user)))&('$d(^PMPDictionary(type))))
	s username=##Class(web.PMP.Document).SSUSER(user)
    s TypeDesc=$P(^PMPDictionary(type),"^",2)
	set Data=$lb(user,username,type,TypeDesc,UFNum,FNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
 	Quit $$$OK
}

ClassMethod EngineerWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EngineerWorkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod EngineerWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EngineerWorkExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: Stdate,Endate
///      Return: loc,locname,type,TypeDesc,UFNum,FNum
/// Description: 根据指派【开发】汇总未完成与完成需求数量
///     Creator: liubaoshi
///   	   Date：2015-05-19
///       Table: 
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","DevelopWork","2015-05-01","2015-05-24")
Query DevelopWork(mSDate As %String, mEDate As %String) As %Query(ROWSPEC = "ProjectUser:%String,ProjectUserName:%String,Type:%String,TypeDesc:%String,ProUnNum:%Float,ProFNum:%Float") [ SqlProc ]
{
}

ClassMethod DevelopWorkExecute(ByRef qHandle As %Binary, mSDate As %String, mEDate As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    k ^TempDevelopWork($j)
	i (mSDate="")||(mEDate="" ) Set qHandle=$lb(0,repid,0)
 	i (mSDate="")||(mEDate="" ) Quit $$$OK
 	s mSDate=$zdh(mSDate,3) s mEDate=$zdh(mEDate,3)
 	f Date=mSDate:1:mEDate d
 	.s Rowid=0 f  s Rowid=$o(^PMPImprovementListi("CreateDate",Date,Rowid)) q:(Rowid="")  d
 	..s Str=$g(^PMPImprovementList(Rowid))
 	..s DevelopUser=$p(Str,"^",17)    	;指派开发
	..s Type=$p(Str,"^",31)         ;类型
	..s StatusDr=$p(Str,"^",28)     ;状态
	..q:'$d(^PMPDictionary(StatusDr))
	..s Status=$p(^PMPDictionary(StatusDr),"^",2)
	..i DevelopUser'="" d
	...s ^TempDevelopWork($j,"DevelopWorkTotalNum",DevelopUser,Type)=$g(^TempDevelopWork($j,"DevelopWorkTotalNum",DevelopUser,Type))+1
	...i Status["完成" d
	....s ^TempDevelopWork($j,"DevelopWorkFinishNum",DevelopUser,Type)=$g(^TempDevelopWork($j,"DevelopWorkFinishNum",DevelopUser,Type))+1
	...e  d
	....s ^TempDevelopWork($j,"DevelopWorkUnFinishNum",DevelopUser,Type)=$g(^TempDevelopWork($j,"DevelopWorkUnFinishNum",DevelopUser,Type))+1
	
	s user=0  f  s user=$o(^TempDevelopWork($j,"DevelopWorkTotalNum",user)) q:(user="")  d
	.s type=0  f  s type=$o(^TempDevelopWork($j,"DevelopWorkTotalNum",user,type)) q:(type="")  d
	..s FNum=+$g(^TempDevelopWork($j,"DevelopWorkFinishNum",user,type))
	..s UFNum=+$g(^TempDevelopWork($j,"DevelopWorkUnFinishNum",user,type))
	..d DevelopWorkExecute
	k ^TempDevelopWork($j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DevelopWorkExecute
    Q:(('$d(^SSU("SSUSR",user)))&('$d(^PMPDictionary(type))))
	s username=##Class(web.PMP.Document).SSUSER(user)
    s TypeDesc=$P(^PMPDictionary(type),"^",2)
	set Data=$lb(user,username,type,TypeDesc,UFNum,FNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
 	Quit $$$OK
}

ClassMethod DevelopWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DevelopWorkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DevelopWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DevelopWorkExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: Stdate,Endate
///      Return: loc,locname,type,TypeDesc,UFNum,FNum
/// Description: 根据菜单名称汇总菜单累计次数完成与完成需求数量
///     Creator: liubaoshi
///   	   Date：2015-05-19
///       Table: 
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PmpMenuNum","2015-05-01","2015-05-24")
Query PmpMenuNum(mSDate As %String, mEDate As %String) As %Query(ROWSPEC = "loc:%String,locname:%String,menu:%String,FNum:%Float,UnFNum:%Float") [ SqlProc ]
{
}

ClassMethod PmpMenuNumExecute(ByRef qHandle As %Binary, mSDate As %String, mEDate As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    k ^TempPmpMenuNum($j)
	i (mSDate="")||(mEDate="" ) Set qHandle=$lb(0,repid,0)
 	i (mSDate="")||(mEDate="" ) Quit $$$OK
 	s mSDate=$zdh(mSDate,3) s mEDate=$zdh(mEDate,3)
 	f Date=mSDate:1:mEDate d
 	.s Rowid=0 f  s Rowid=$o(^PMPImprovementListi("CreateDate",Date,Rowid)) q:(Rowid="")  d
 	..s Str=$g(^PMPImprovementList(Rowid))
 	..s Createloc=$p(Str,"^",12)    ;创建科室
	..s Menu=$p(Str,"^",21)         ;菜单名称
	..s StatusDr=$p(Str,"^",28)     ;状态
	..q:'$d(^PMPDictionary(StatusDr))
	..s Status=$p(^PMPDictionary(StatusDr),"^",2)
	..i Menu'="" d
	...s ^TempPmpMenuNum($j,"PmpMenuTotalNum",Createloc,Menu)=$g(^TempPmpMenuNum($j,"PmpMenuTotalNum",Createloc,Menu))+1
	...i Status["完成" d
	....s ^TempPmpMenuNum($j,"PmpMenuFinishNum",Createloc,Menu)=$g(^TempPmpMenuNum($j,"PmpMenuFinishNum",Createloc,Menu))+1
	...e  d
	....s ^TempPmpMenuNum($j,"PmpMenuUnFinishNum",Createloc,Menu)=$g(^TempPmpMenuNum($j,"PmpMenuUnFinishNum",Createloc,Menu))+1
	
	s loc=0  f  s loc=$o(^TempPmpMenuNum($j,"PmpMenuTotalNum",loc)) q:(loc="")  d
	.s menu=0  f  s menu=$o(^TempPmpMenuNum($j,"PmpMenuTotalNum",loc,menu)) q:(menu="")  d
	..s FNum=+$g(^TempPmpMenuNum($j,"PmpMenuFinishNum",loc,menu))
	..s UFNum=+$g(^TempPmpMenuNum($j,"PmpMenuUnFinishNum",loc,menu))
	..d PmpMenuNumExecute
	k ^TempPmpMenuNum($j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PmpMenuNumExecute
	q:'$d(^CTLOC(loc))
    s locname=$p(^CTLOC(loc),"^",2)
    i locname["-" s locname=$p(locname,"-",2)
	set Data=$lb(loc,locname,menu,FNum,UFNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
 	Quit $$$OK
}

ClassMethod PmpMenuNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PmpMenuNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PmpMenuNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PmpMenuNumExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

///       InPut: mSdate,mEdate,eMergency
///      Return: 
/// Description: 产品组未完成需求明细(copy上方完成明细,退出"完成状态")
///     Creator: liubaoshi
///        Date：2015-05-25
///       Table: 
///       Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PmpProductUnFinishDetail","2015-05-01","2015-05-24","","","113","102","","","")
///              d ##class(%ResultSet).RunQuery("web.PMP.PMPRunQianQueryOut","PmpProductUnFinishDetail","2015-05-01","2015-05-24","","","113","","","25","")
Query PmpProductUnFinishDetail(mSdate As %String, mEdate As %String, eMergency As %String, Product As %String, type As %String, loc As %String, Engineer As %String, develop As %String, menu As %String) As %Query(ROWSPEC = "Rowid:%String,IPMLName:%String,IPMLCreateDate:%String,IPMLCreateTime:%String,IPMLCreateLoc:%String,IPMLCreateUser:%String,IPMLMenu:%String,AssignEngineer:%String,IPMLPredictTime:%Float,IPMLFinishDate:%String,IPMLFinishTime:%String,IPMDay:%Float,ProductDesc:%String,EmergencyDesc:%String,DevelopUsername:%String,Status:%String") [ SqlProc ]
{
}

ClassMethod PmpProductUnFinishDetailExecute(ByRef qHandle As %Binary, mSdate As %String, mEdate As %String, eMergency As %String, Product As %String, type As %String, loc As %String, Engineer As %String, develop As %String, menu As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (mSdate="")||(mEdate="" ) Set qHandle=$lb(0,repid,0)
 	i (mSdate="")||(mEdate="" ) Quit $$$OK
 	s mSdate=$zdh(mSdate,3) s mEdate=$zdh(mEdate,3)
 	s (CDate,CTime,FDate,FTime,IPMDay,DevelopUsername)=""
 	f day=mSdate:1:mEdate d
 	.s id=0 f  s id=$o(^PMPImprovementListi("CreateDate",day,id)) q:(id="")  d
 	..s ListStr=$g(^PMPImprovementList(id))
 	..s EmergencyDR=$p(ListStr,"^",18)             ;紧急程度 IPML_Emergency_DR
 	..q:EmergencyDR=""
    ..q:(eMergency'="")&(EmergencyDR'=eMergency)
    ..q:'$d(^PMPDictionary(EmergencyDR))
    ..s EmergencyDesc=$p(^PMPDictionary(EmergencyDR),"^",2)
    ..s Type=$p(ListStr,"^",31)                    ;类型
    ..q:(type'="")&(Type'=type)
    ..s StatusDr=$p(ListStr,"^",28)               ;需求状态IPML_Status_DR
	..q:'$d(^PMPDictionary(StatusDr))
	..s Status=$p(^PMPDictionary(StatusDr),"^",2)
	..q:Status="完成"
    ..s ModuleDR=$p(ListStr,"^",23)                ;所属模块 IPML_Module_DR
 	..;q:ModuleDR=""  
 	..i ModuleDR'=""  d                              ;为空没更新,算"未完成"状态下的需求
 	...q:'$d(^PMPModule(ModuleDR))
 	...s ProductDR=$p(^PMPModule(ModuleDR),"^",7)   ;产品组 MODE_Product_DR
 	...q:(Product'="")&(ProductDR'=Product)
 	...s ProductDesc=$p(^PMPDictionary(ProductDR),"^",2)  
    ..s IPMLName=$p(ListStr,"^",2)              ;需求名称
    ..s CreateDate=$p(ListStr,"^",11)           ;创建日期
    ..i CreateDate'="" s CDate=$zd(CreateDate,3)
    ..s CreateTime=$p(ListStr,"^",14)           ;创建时间
    ..i CreateTime'="" s CTime=$zt(CreateTime,3)
    ..s CreateLoc=$p(ListStr,"^",12)            ;创建科室
    ..q:(loc'="")&(CreateLoc'=loc)
    ..q:'$d(^CTLOC(CreateLoc))
    ..s CLoc=$p($p(^CTLOC(CreateLoc),"^",2),"-",2)
    ..s CreateUser=$p(ListStr,"^",15)           ;创建人
    ..s CUser=##Class(web.PMP.Document).SSUSER(CreateUser)
    ..s DevelopUser=$p(ListStr,"^",17)    	    ;指派开发//
    ..q:(develop'="")&(DevelopUser'=develop)
    ..i DevelopUser'="" s DevelopUsername=##Class(web.PMP.Document).SSUSER(DevelopUser)    
    ..s IPMLMenu=$p(ListStr,"^",21)             ;菜单名称
    ..q:(menu'="")&(IPMLMenu'=menu)
    ..s AssignEngineer=$p(ListStr,"^",4)        ;指派工程师
    ..q:(Engineer'="")&(AssignEngineer'=Engineer)
    ..;q:'$d(^PMPProjectUser(AssignEngineer))
    ..i AssignEngineer'=""  d
    ...;s AssignUserDr=$p(^PMPProjectUser(AssignEngineer),"^",1)
    ...s AssignUser=##Class(web.PMP.Document).SSUSER(AssignEngineer)
    ..s PredictTime=$p(ListStr,"^",24)          ;预计完成时间(天数)
    ..s FinishDate=$p(ListStr,"^",19)           ;完成日期
    ..i FinishDate'="" s FDate=$zd(FinishDate,3)
    ..e  d
    ...s FDate="" 
    ..s FinishTime=$p(ListStr,"^",20)           ;完成时间
    ..i FinishTime'="" s FTime=$zt(FinishTime,3)
    ..e  d
    ...s FTime=""
    ..i FinishDate'="" d
    ...s IPMDay=$g(FinishDate)-$g(CreateDate)   ;用时天数 
    ...i +$g(IPMDay)<1 s IPMDay=1
 	..d PmpProductUnFinishDetail
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PmpProductUnFinishDetail
	set Data=$lb(id,IPMLName,CDate,CTime,CLoc,CUser,IPMLMenu,AssignUser,PredictTime,FDate,FTime,IPMDay,ProductDesc,EmergencyDesc,DevelopUsername,Status)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod PmpProductUnFinishDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PmpProductUnFinishDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PmpProductUnFinishDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PmpProductUnFinishDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

Storage Default
{
<Data name="PMPRunQianQueryOutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.PMP.PMPRunQianQueryOutD</DataLocation>
<DefaultData>PMPRunQianQueryOutDefaultData</DefaultData>
<IdLocation>^web.PMP.PMPRunQianQueryOutD</IdLocation>
<IndexLocation>^web.PMP.PMPRunQianQueryOutI</IndexLocation>
<StreamLocation>^web.PMP.PMPRunQianQueryOutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
