Class web.DHCEQPlanExecute Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQPlanExecute).GetExecutePlanByID("1")
ClassMethod GetPlanExecuteByID(rowid)
{
	i rowid="" q ""
	new result,resultex,LocCode
	s (result,resultex,LocCode)=""
	s result= ^DHCEQPlanExecute(rowid)
	s resultex=resultex_"^"	;PlanName
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQMaintPlan($p(result,"^",2))),"^",1)
	s resultex=resultex_"^"	;ExecuteLoc
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	.;s LocCode=$p($g(^CTLOC($p(result,"^",2))),"^",1)   //modify by jyp 2019-10-18 CTLOC调整
	.s LocCode=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",$p(result,"^",2))   //modify by jyp 2019-10-18 CTLOC调整
	s resultex=resultex_"^"	;BeginDate
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")
	s resultex=resultex_"^"	;BeginTime
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"time")
	s resultex=resultex_"^"	;User
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",9))
	
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

ClassMethod DeleteData(PERowID)
{
	Set $ZT="ERRORDelete"
	
	TSTART
	&SQL(delete SQLUSER.DHC_EQMaint WHERE MT_RowID IN (SELECT PEL_MaintDR FROM SQLUSER.DHC_EQPlanExecuteList WHERE PEL_PlanExecuteDR=:PERowID) )
	i SQLCODE=100 s SQLCODE=0
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(delete SQLUSER.DHC_EQPlanExecuteList where PEL_PlanExecuteDR=:PERowID )
	i SQLCODE=100 s SQLCODE=0
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(delete SQLUSER.DHC_EQPlanExecute where PE_RowID=:PERowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
ERRORDelete 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}

ClassMethod PlanExeFinish(PlanExeID)
{
	k PLIST
	
	s PLIST(7)=1		;状态
	s PLIST(12)=+$H		;完成日期
	s PLIST(13)=$p(+$H,",",2) ;完成时间
	&SQL(Update sqluser.DHC_EQPlanExecute values :PLIST() Where PE_RowID=:PlanExeID)
	i SQLCODE q SQLCODE
	
	q PlanExeID
}

/// w ##Class(web.DHCEQPlanExecute).ExecutePlan(1,"1^1^1^完好",1)
ClassMethod ExecutePlan(PERowID, valList, BussType)
{
	n Flag,Length
	s $ZE="ERRORExecute"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	s Date=+$H
	s Time=$P($H,",",2)
	TSTART	
 	
	//更新DHC_EQPlanExecute表已执行数量
	s Length=$l(valList,",")
	s ExecuteNum=$p(^DHCEQPlanExecute(PERowID),"^",5)+Length
	&SQL(update sqluser.DHC_EQPlanExecute Set PE_ExecutedNum=:ExecuteNum where PE_RowID=:PERowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s Flag=0
	f i=1:1:Length
	{
		k PLISTMX
		s val=$p(valList,",",i)
		//更新DHC_EQMaint
		s PlanID=$p(val,"^",1)
		s EquipID=$p(val,"^",2)
		s PLISTMX(2)=EquipID
		s PLISTMX(3)=BussType
		s PLISTMX(4)=PlanID
		s PLISTMX(5)=$p($g(^DHCEQMaintPlan(PlanID)),"^",9)	;MaintTypeDR
		s PLISTMX(6)=Date	;MaintDate
		s PLISTMX(7)=$p($g(^DHCEQMaintPlan(PlanID)),"^",14)	;MaintLocDR
		s PLISTMX(8)=$p($g(^DHCEQMaintPlan(PlanID)),"^",15)	;MaintUserDR
		s PLISTMX(9)=$p($g(^DHCEQMaintPlan(PlanID)),"^",16)	;MaintModeDR
		s PLISTMX(10)=##Class(web.DHCEQMaintPlanNew).GetOtherFee(PlanID)
		s PLISTMX(11)=""	;NormalFlag
		s PLISTMX(12)=""	;ManageLocDR
		s PLISTMX(13)=$p($g(^DHCEQEquip(EquipID)),"^",19)	;UseLocDR
		s PLISTMX(14)=2		;Status
		s PLISTMX(15)=$p($g(^DHCEQMaintPlan(PlanID)),"^",25)
		s PLISTMX(16)=User
		s PLISTMX(17) = Date	;UpdateDate
		s PLISTMX(18) = Time	;UpdateTime
		s PLISTMX(19) = User	;AuditUserDR
		s PLISTMX(20) = Date	;AuditDate
		s PLISTMX(21) = Time	;AuditTime
		s PLISTMX(25) = $p($g(^DHCEQMaintPlan(PlanID)),"^",13)   ;OtherFee
		s PLISTMX(26) = ""	;Hold1
		s PLISTMX(27) = ""	;Hold2
		s PLISTMX(28) = ""	;Hold3
		s PLISTMX(29) = ""	;Hold4
		s PLISTMX(30) = ""	;Hold5
		s PLISTMX(31) = $p($g(^DHCEQMaintPlan(PlanID)),"^",18)	;MeasureFlag
		s PLISTMX(32) = $p($g(^DHCEQMaintPlan(PlanID)),"^",19)	;MeasureDeptDR
		s PLISTMX(33) = $p($g(^DHCEQMaintPlan(PlanID)),"^",20)	;MeasureHandler
		s PLISTMX(34) = $p($g(^DHCEQMaintPlan(PlanID)),"^",21)	;MeasureTel
		s PLISTMX(35) = ""	;MeasureUsers
		s PLISTMX(36) = $p($g(^DHCEQMaintPlan(PlanID)),"^",22)	;ServiceDR
		s PLISTMX(37) = $p($g(^DHCEQMaintPlan(PlanID)),"^",23)	;ServiceHandler
		s PLISTMX(38) = $p($g(^DHCEQMaintPlan(PlanID)),"^",24)	;ServiceTel
		s PLISTMX(39) = ""	;ServiceUsers
		s PLISTMX(40) = "N"	;InvalidFlag
		&SQL(insert into sqluser.DHC_EQMaint values :PLISTMX())
		s MaintRowID=$G(%ROWID)
		i SQLCODE s Flag=SQLCODE
		
		//更新DHC_EQPlanExecuteList执行标记,执行结果
		s PELID=$p(val,"^",3)
		s Result=$p(val,"^",4)
		&SQL(update sqluser.DHC_EQPlanExecuteList Set PEL_ExecuteFlag='Y',PEL_ExecuteResult=:Result,PEL_MaintDR=:MaintRowID where PEL_RowID=:PELID)
		i SQLCODE s Flag=SQLCODE
		
		//更新DHC_EQOperateInfo
		s SQLCODE=..SavaOperateInfo(BussType, PELID)
		i SQLCODE s Flag=SQLCODE
	}
	i Flag
	{
		TROLLBACK
		q Flag
	}
	
	TCOMMIT
 	q PERowID
ERRORExecute 
	TRollBack	
	Set ErrorMsg=$ZT	     //得到系统返回的错误消息
 	Quit "<ERRORExecute>"_ErrorMsg     //返回错误消息 ;
}

ClassMethod SavaOperateInfo(SourceType, SourceID)
{
	n valList,TSourceType,TSourceID
	k PLIST
	i SourceType=""||SourceID="" q -1
	s Date=+$H
	s Time=$p($H,",",2)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	s Flag=0
	
	s PLIST(2)=SourceType
	s PLIST(3)=SourceID
	s PLIST(4)=Date
	s PLIST(5)=Time
	s PLIST(6)=User
	s PLIST(9)="N"

	&SQL(Insert Into SQLUSER.DHC_EQOperateInfo Values :PLIST())
	s OIRowID=$G(%ROWID)
	
	i SQLCODE s Flag=SQLCODE

	q Flag
}

/// Creator:CZF 20180423
/// Description:计划执行明细
/// d ##class(%ResultSet).RunQuery("web.DHCEQPlanExecute","GetExecutePlan","1","","","")
Query GetExecutePlan(MaintPlanDR, Status, ExeLocDR As %String = "", ExecuteNo As %String = "") As %Query(ROWSPEC = "TRowID:%String,TExeNo:%String,TExeLocDR:%String,TExeLoc:%String,TStatus:%String,TTotalNum:%String,TExecutedNum:%String,TDisExecuteNum:%String,TExeSchedule:%String,TExeDate:%String,TExecutorDR:%String,TExecutor:%String,TRemark:%String,TFinishDate:%String,TRow:%String,TMaintPlanName:%String,TMaintPlanNo:%String,TCycleNum:%String,TPreWarnDaysNum:%String")
{
}

ClassMethod GetExecutePlanExecute(ByRef qHandle As %Binary, MaintPlanDR, Status, ExeLocDR As %String = "", ExecuteNo As %String = "") As %Status
{
	//s ^CZF("mp")=MaintPlanDR_"^"_Status_"^"_ExeLocDR_"^"_ExecuteNo
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	i MaintPlanDR="" Quit $$$OK
	s rowid=0
	f  s rowid=$o(^DHCEQPlanExecute(0,"MaintPlan",MaintPlanDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetExecutePlan
	.s TRowID = rowid
	.s TExeNo = $p($g(^DHCEQPlanExecute(rowid)),"^",1)
	.q:(ExecuteNo'="")&&(TExeNo'=ExecuteNo)
	.s TExeLocDR = $p($g(^DHCEQPlanExecute(rowid)),"^",3)
	.q:(ExeLocDR'="")&&(TExeLocDR'=ExeLocDR)
	.s TExeLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TExeLocDR)
	.s TStatus = $p($g(^DHCEQPlanExecute(rowid)),"^",6)
	.q:(Status'="")&&(TStatus'=Status)
	.s TTotalNum=$p($g(^DHCEQPlanExecute(rowid)),"^",4)
	.s TExecutedNum=$p($g(^DHCEQPlanExecute(rowid)),"^",5)
	.s TDisExecuteNum=TTotalNum-TExecutedNum
	.i TDisExecuteNum>0 s TExeSchedule=TDisExecuteNum_"台未执行"
	.e  s TExeSchedule="待完成"
	.i TStatus=1 s TExeSchedule="完成"
	.s TExeDate=$p($g(^DHCEQPlanExecute(rowid)),"^",7)
	.s TExeDate=##Class(web.DHCEQCommon).TransValueToPage(TExeDate,"date")
	.s TExecutorDR=$p($g(^DHCEQPlanExecute(rowid)),"^",9)
	.s TExecutor = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TExecutorDR)
	.s TRemark=$p($g(^DHCEQPlanExecute(rowid)),"^",10)
	.s TFinishDate=$p($g(^DHCEQPlanExecute(rowid)),"^",11)
	.s TFinishDate=##Class(web.DHCEQCommon).TransValueToPage(TFinishDate,"date")
	.s TMaintPlanName=$p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",1)
	.s TMaintPlanNo=$p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",50)
	.s TCycleNum = $p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",7)
	.s TCycleUnitDR = $p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",8)
	.i TCycleUnitDR '="" s TCycleUnit = $p($g(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
	.s TCycleNum=TCycleNum_TCycleUnit
	.s TPreWarnDaysNum = $p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",12)
	.d OutputRowGetExecutePlan
	Quit $$$OK
OutputRowGetExecutePlan
	s Data=$lb(TRowID,TExeNo,TExeLocDR,TExeLoc,TStatus,TTotalNum,TExecutedNum,TDisExecuteNum,TExeSchedule,TExeDate,TExecutorDR,TExecutor,TRemark,TFinishDate,TRow,TMaintPlanName,TMaintPlanNo,TCycleNum,TPreWarnDaysNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1  //add by zx 2015-09-17
	quit
ResetVariablesGetExecutePlan
	s (TRowID,TExeNo,TExeLocDR,TExeLoc,TStatus,TTotalNum,TExecutedNum,TDisExecuteNum,TExeSchedule,TExeDate,TExecutorDR,TExecutor,TRemark,TFinishDate,TMaintPlanName,TMaintPlanNo,TCycleNum,TCycleUnitDR,TCycleUnit,TPreWarnDaysNum)=""
	quit
}

ClassMethod GetExecutePlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExecutePlanExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetExecutePlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExecutePlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
