Class web.DHCEQInspectPlan Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 45;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Query GetInspectPlan(PlanName, EquipDR, ModelDR, InspectTypeDR, ManageLocDR, QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TEquipDR:%String,TCycleNum:%String,TCycleUnitDR:%String,TInspectTypeDR:%String,TPreInspectDate:%String,TNextMaintDate:%String,TPreWarnDaysNum:%String,TManageLocDR:%String,TManageUserDR:%String,TOutInspectFlag:%String,TMeasureDeptDR:%String,TIsForcedFlag:%String,TInspectFee:%String,TStatus:%String,TRemark:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TEquip:%String,TCycleUnit:%String,TInspectType:%String,TManageLoc:%String,TManageUser:%String,TMeasureDept:%String,TAddUser:%String,TUpdateUser:%String,TModel:%String,TModelDR:%String")
{
}

Parameter SQLCODE = "IP_RowID";

ClassMethod GetInspectPlanExecute(ByRef qHandle As %Binary, PlanName, EquipDR, ModelDR, InspectTypeDR, ManageLocDR, QXType As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetInspectPlan
	Quit $$$OK
BuildDataGetInspectPlan
	f  s rowid=$o(^DHCEQInspectPlan(rowid))  quit:rowid=""  d
	.d ResetVariablesGetInspectPlan
	.s TRowID = rowid
	.q:(PlanName="")&&(EquipDR="")&&(ModelDR="")&&(InspectTypeDR="")&&(ManageLocDR="")
	.s TName = $p($g(^DHCEQInspectPlan(rowid)),"^",1)
	.q:TName'[PlanName
	.s TEquipDR = $p($g(^DHCEQInspectPlan(rowid)),"^",2)
	.q:(TEquipDR'=EquipDR)&(EquipDR'="")
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	..i TModelDR'="" d
	...s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.//q:TEquip'[Equip
	.q:(TModelDR'=ModelDR)&(ModelDR'="")
	.s TCycleNum = $p($g(^DHCEQInspectPlan(rowid)),"^",3)
	.s TCycleUnitDR = $p($g(^DHCEQInspectPlan(rowid)),"^",4)
	.i TCycleUnitDR '=""  d
	..s TCycleUnit = $p($g(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
	.s TCycleNum=TCycleNum_TCycleUnit
	.s TInspectTypeDR = $p($g(^DHCEQInspectPlan(rowid)),"^",5)
	.q:(TInspectTypeDR'=InspectTypeDR)&(InspectTypeDR'="")
	.i TInspectTypeDR '=""  d
	..s TInspectType = $p($g(^DHCEQCCode("DHCEQCInspectType",TInspectTypeDR)),"^",2)
	.s TPreInspectDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInspectPlan(rowid)),"^",6),"date")
	.s TNextMaintDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInspectPlan(rowid)),"^",7),"date")
	.s TPreWarnDaysNum = $p($g(^DHCEQInspectPlan(rowid)),"^",8)
	.s TManageLocDR = $p($g(^DHCEQInspectPlan(rowid)),"^",9)
	.q:(TManageLocDR'=ManageLocDR)&(ManageLocDR'="")
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TManageLocDR))) //2010-10-28 DJ
	.i TManageLocDR '=""  d
	..s TManageLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	.s TManageUserDR = $p($g(^DHCEQInspectPlan(rowid)),"^",10)
	.i TManageUserDR '=""  d
	..s TManageUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TManageUserDR)
	.s TOutInspectFlag = $p($g(^DHCEQInspectPlan(rowid)),"^",11)
	.s TMeasureDeptDR = $p($g(^DHCEQInspectPlan(rowid)),"^",12)
	.i TMeasureDeptDR '=""  d
	..s TMeasureDept = $p($g(^DHCEQCCode("DHCEQCMeasureDept",TMeasureDeptDR)),"^",1)
	.s TIsForcedFlag = $p($g(^DHCEQInspectPlan(rowid)),"^",13)
	.s TInspectFee = $p($g(^DHCEQInspectPlan(rowid)),"^",14)
	.s TStatus = $p($g(^DHCEQInspectPlan(rowid)),"^",15)
	.s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.//i TStatus=1 s TStatus="提交"
	.//i TStatus=0 s TStatus="新增"
	.s TRemark = $p($g(^DHCEQInspectPlan(rowid)),"^",16)
	.s TAddUserDR = $p($g(^DHCEQInspectPlan(rowid)),"^",17)
	.i TAddUserDR '=""  d
	..s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInspectPlan(rowid)),"^",18),"date")
	.s TAddTime = $p($g(^DHCEQInspectPlan(rowid)),"^",19)
	.s TUpdateUserDR = $p($g(^DHCEQInspectPlan(rowid)),"^",20)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInspectPlan(rowid)),"^",21),"date")
	.s TUpdateTime = $p($g(^DHCEQInspectPlan(rowid)),"^",22)
	.d OutputRowGetInspectPlan
	quit
OutputRowGetInspectPlan
	s Data=$lb(TRowID,TName,TEquipDR,TCycleNum,TCycleUnitDR,TInspectTypeDR,TPreInspectDate,TNextMaintDate,TPreWarnDaysNum,TManageLocDR,TManageUserDR,TOutInspectFlag,TMeasureDeptDR,TIsForcedFlag,TInspectFee,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TEquip,TCycleUnit,TInspectType,TManageLoc,TManageUser,TMeasureDept,TAddUser,TUpdateUser,TModel,TModelDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInspectPlan
	s (TRowID,TName,TEquipDR,TCycleNum,TCycleUnitDR,TInspectTypeDR,TPreInspectDate,TNextMaintDate,TPreWarnDaysNum,TManageLocDR,TManageUserDR,TOutInspectFlag,TMeasureDeptDR,TIsForcedFlag,TInspectFee,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TEquip,TCycleUnit,TInspectType,TManageLoc,TManageUser,TMeasureDept,TAddUser,TUpdateUser,TModel,TModelDR)=""
	quit
}

ClassMethod GetInspectPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInspectPlanExecute ]
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

ClassMethod GetInspectPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInspectPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Parameter SQLDESCRIPTION = "IP_RowID";

ClassMethod UpdateInspectPlan(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String)
{
	k PLIST,IRowID
	s IRowID=$p(val,"^",1)
	 i $p(val,"^",1)'=""  s PLIST(1) = $p(val,"^",1)	;RowID
	 i $p(val,"^",2)'=""  s PLIST(2) = $p(val,"^",2)	;Name
	 i $p(val,"^",3)'=""  s PLIST(3) = $p(val,"^",3)	;EquipDR
	 i $p(val,"^",4)'=""  s PLIST(4) = $p(val,"^",4)	;CycleNum
	 i $p(val,"^",5)'=""  s PLIST(5) = $p(val,"^",5)	;CycleUnitDR
	 i $p(val,"^",6)'=""  s PLIST(6) = $p(val,"^",6)	;InspectTypeDR
	 i $p(val,"^",7)'=""  s PLIST(7) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"date")	;PreInspectDate
	 s PLIST(8)= ##class(web.DHCEQMaintPlan).GetNextMaintDate($p(val,"^",7),$p(val,"^",4),$p(val,"^",5))
	 //i $p(val,"^",8)'=""  s PLIST(8) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date")	;NextMaintDate
	 i $p(val,"^",9)'=""  s PLIST(9) = $p(val,"^",9)	;PreWarnDaysNum
	 i $p(val,"^",10)'=""  s PLIST(10) = $p(val,"^",10)	;ManageLocDR
	 i $p(val,"^",11)'=""  s PLIST(11) = $p(val,"^",11)	;ManageUserDR
	 i $p(val,"^",12)'=""  s PLIST(12) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",12),"bool")	;OutInspectFlag
	 i $p(val,"^",13)'=""  s PLIST(13) = $p(val,"^",13)	;MeasureDeptDR
	 i $p(val,"^",14)'=""  s PLIST(14) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",14),"bool")	;IsForcedFlag
	 i $p(val,"^",15)'=""  s PLIST(15) = $p(val,"^",15)	;InspectFee
	 i $p(val,"^",16)'=""  s PLIST(16) = $p(val,"^",16)	;Status
	 i $p(val,"^",16)=""  s PLIST(16) = 0 //$p(val,"^",16)	;Status
	 i $p(val,"^",17)'=""  s PLIST(17) = $p(val,"^",17)	;Remark
	 /*i $p(val,"^",18)'=""  s PLIST(18) = $p(val,"^",18)	;AddUserDR
	 i $p(val,"^",19)'=""  s PLIST(19) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",19),"date")	;AddDate
	 i $p(val,"^",20)'=""  s PLIST(20) = $p(val,"^",20)	;AddTime
	 i $p(val,"^",21)'=""  s PLIST(21) = $p(val,"^",21)	;UpdateUserDR
	 i $p(val,"^",22)'=""  s PLIST(22) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",22),"date")	;UpdateDate
	 i $p(val,"^",23)'=""  s PLIST(23) = $p(val,"^",23)	;UpdateTime*/
	 k PLIST(1)
	If IRowID'="" {
		i 
		i $p(val,"^",18)'=""  s PLIST(21) = $p(val,"^",18)
		s PLIST(22)=+$H
		s PLIST(23)=$P($H,",",2)
		&sql(Update sqluser.DHC_EQInspectPlan Values :PLIST() where IP_RowID=:IRowID)
		set return=SQLCODE
		i SQLCODE'=0 TROLLBACK
		q return_"^"_IRowID
	}
	Else {
		i $p(val,"^",18)'=""  s PLIST(18) = $p(val,"^",18)
		s PLIST(19)=+$H
		s PLIST(20)=$P($H,",",2)
		&sql(Insert Into SQLUser.DHC_EQInspectPlan Values :PLIST())
		set return=SQLCODE
		i SQLCODE'=0 TROLLBACK
		s IRowID=$G(%ROWID)
		q return_"^"_IRowID
	}
}

Parameter SQLROWID = "IP_RowID";

ClassMethod GetOneInspectPlan(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQInspectPlan(RowID)
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",2))),"^",1)
	s resultex=resultex_"^"	;CycleUnitDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCCycleUnit",$p(result,"^",4))),"^",2)
	s resultex=resultex_"^"	;InspectTypeDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCInspectType",$p(result,"^",5))),"^",2)
	s $p(result,"^",6)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"date")	;PreInspectDate
	s $p(result,"^",7)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")	;NextMaintDate
	s resultex=resultex_"^"	;ManageLocDR
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",9))
	s resultex=resultex_"^"	;ManageUserDR
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",10))
	s $p(result,"^",11)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"bool")	;OutInspectFlag
	s resultex=resultex_"^"	;MeasureDeptDR
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",$p(result,"^",12))),"^",1)
	s $p(result,"^",13)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"bool")	;IsForcedFlag
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",17))
	s $p(result,"^",18)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",18),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",20))
	s $p(result,"^",21)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",21),"date")	;UpdateDate
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

ClassMethod DeleteInspectPlan(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String)
{
	TSTART
	s return=0
	&sql(Delete from sqluser.DHC_EQInspectPlanItem where IPI_InspectPlanDR=:RowID)
	s return=SQLCODE
	i SQLCODE<0 
	{
		TROLLBACK
		q return
	} 
	&sql(Delete from sqluser.DHC_EQInspectPlan where IP_RowID=:RowID)
	s return=SQLCODE
	i SQLCODE'=0 
	{
		TROLLBACK
		q return
	}
	TCOMMIT
	q return
}

ClassMethod SubmitInspectPlan(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String, Val As %Library.String)
{
	&sql(Update sqluser.DHC_EQInspectPlan set IP_Status=:Val where IP_RowID=:RowID)
	set return=SQLCODE
	i SQLCODE'=0 Trollback
	q return
}

ClassMethod ExecuteInspectPlan(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String, User As %Library.String)
{
	s PLIST(2)=$p($G(^DHCEQInspectPlan(RowID)),"^",2) //EquipDR
	s PLIST(3)=RowID //InspectPlanDR
	s PLIST(4)=$p($G(^DHCEQInspectPlan(RowID)),"^",5) //InspectType
	s PLIST(5)=+$H  //InspectDate
	s PLIST(6)=$p($g(^DHCEQInspectPlan(RowID)),"^",9) //ManageLocDR
	s PLIST(7)=$p($g(^DHCEQInspectPlan(RowID)),"^",10) //ManageUserDR
	s PLIST(8)=$p($g(^DHCEQEquip(PLIST(2))),"^",19) //UseLocDR
	s PLIST(9)=$p($g(^DHCEQInspectPlan(RowID)),"^",12) //MeasureDeptDR
	s PLIST(11)=$p($g(^DHCEQInspectPlan(RowID)),"^",14) //InspectFee
	s PLIST(13)=$p($g(^DHCEQInspectPlan(RowID)),"^",13) //IsForcedFlag
	s PLIST(22)=$p($g(^DHCEQInspectPlan(RowID)),"^",11) //IsOutInspectFlag
	s PLIST(14)=0 //Status
	s PLIST(16)=User //AddUserDR
	s PLIST(17)=PLIST(5) //AddDate
	s PLIST(18)=$p($h,",",2) //AddTime
	TStart
	s return=0
	&sql(Insert Into SQLUser.DHC_EQInspect Values :PLIST())
	i SQLCODE'=0 {
		s return=SQLCODE
		Trollback
		q return_"^"_"1"}
	s IRowID=$g(%ROWID)
	&sql(Insert Into SQLUser.DHC_EQInspectItem (ISI_InspectDR,ISI_InspectpartDR,ISI_InspectItemDR) select :IRowID,IPI_InspectPartDR,IPI_InspectItemDR from SQLUser.DHC_EQInspectPlanItem where IPI_InspectPlanDR=:RowID)

	i (SQLCODE'=0)&&(SQLCODE'=100) {
		s return=SQLCODE
		Trollback
		q return_"^"_"2"}
	Tcommit
	q return_"^"_IRowID
}

ClassMethod CheckInspect(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String)
{
	
	&sql(Select IS_RowID from SQLUser.DHC_EQInspect where IS_InspectPlanDR=:RowID and IS_Status='0')
	//i SQLCODE<=0{
		q SQLCODE
	//}
}

Query GetInspectAlert(OutInspectFlag, IsForcedFlag, EquipDR, ManageLocDR, MeasureDeptDR, InspectTypeDR, StartDate, EndDate) As %Query(ROWSPEC = "TRowID:%String,TName:%String,TEquipDR:%String,TCycleNum:%String,TCycleUnitDR:%String,TInspectTypeDR:%String,TPreInspectDate:%String,TNextMaintDate:%String,TPreWarnDaysNum:%String,TManageLocDR:%String,TManageUserDR:%String,TOutInspectFlag:%String,TMeasureDeptDR:%String,TIsForcedFlag:%String,TInspectFee:%String,TStatus:%String,TRemark:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TEquip:%String,TCycleUnit:%String,TInspectType:%String,TManageLoc:%String,TManageUser:%String,TMeasureDept:%String,TAddUser:%String,TUpdateUser:%String,TModelDR:%String,TModel:%String")
{
}

//OutInspectFlag,IsForcedFlag怎么使用条件

ClassMethod GetInspectAlertExecute(ByRef qHandle As %Binary, OutInspectFlag, IsForcedFlag, EquipDR, ManageLocDR, MeasureDeptDR, InspectTypeDR, StartDate, EndDate) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetInspectAlert
	Quit $$$OK
BuildDataGetInspectAlert
	f  s rowid=$o(^DHCEQInspectPlan(rowid))  quit:rowid=""  d
	.d ResetVariablesGetInspectAlert
	.s TRowID = rowid
	.s TName = $p($g(^DHCEQInspectPlan(rowid)),"^",1)
	.s TEquipDR = $p($g(^DHCEQInspectPlan(rowid)),"^",2)
	.q:(EquipDR'="")&&(TEquipDR'=EquipDR)
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TModelDR = $p($g(^DHCEQEquip(TEquipDR)),"^",3)
	..i TModelDR '="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TCycleNum = $p($g(^DHCEQInspectPlan(rowid)),"^",3)
	.s TCycleUnitDR = $p($g(^DHCEQInspectPlan(rowid)),"^",4)
	.i TCycleUnitDR '=""  d
	..s TCycleUnit = $p($g(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
	.s TInspectTypeDR = $p($g(^DHCEQInspectPlan(rowid)),"^",5)
	.q:(InspectTypeDR'="")&&(TInspectTypeDR'=InspectTypeDR)
	.i TInspectTypeDR '=""  d
	..s TInspectType = $p($g(^DHCEQCCode("DHCEQCInspectType",TInspectTypeDR)),"^",2)
	.s TPreInspectDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInspectPlan(rowid)),"^",6),"date")
	.s TNextMaintDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInspectPlan(rowid)),"^",7),"date")
	.s TPreWarnDaysNum = $p($g(^DHCEQInspectPlan(rowid)),"^",8)
	.i (+StartDate=0)&&(+EndDate=0) q:(+$h+TPreWarnDaysNum)<$p($g(^DHCEQInspectPlan(rowid)),"^",7)
	.i (StartDate'="")||(EndDate'="")  d 
	..i StartDate="" s StartDate=0
	..i EndDate="" s EndDate=+$h
	.i (+StartDate'=0)||(+EndDate'=0) q:($p($g(^DHCEQInspectPlan(rowid)),"^",7)<StartDate)!($p($g(^DHCEQInspectPlan(rowid)),"^",7)>EndDate)
	.s TManageLocDR = $p($g(^DHCEQInspectPlan(rowid)),"^",9)
	.q:(ManageLocDR'="")&&(TManageLocDR'=ManageLocDR)
	.i TManageLocDR '=""  d
	..s TManageLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	.s TManageUserDR = $p($g(^DHCEQInspectPlan(rowid)),"^",10)
	.i TManageUserDR '=""  d
	..s TManageUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TManageUserDR)
	.s TOutInspectFlag = $p($g(^DHCEQInspectPlan(rowid)),"^",11)
	.q:(OutInspectFlag'="")&&(TOutInspectFlag'=OutInspectFlag)
	.s TMeasureDeptDR = $p($g(^DHCEQInspectPlan(rowid)),"^",12)
	.q:(MeasureDeptDR'="")&&(TMeasureDeptDR'=MeasureDeptDR)
	.i TMeasureDeptDR '=""  d
	..s TMeasureDept = $p($g(^DHCEQCCode("DHCEQCMeasureDept",TMeasureDeptDR)),"^",1)
	.s TIsForcedFlag =$p($g(^DHCEQInspectPlan(rowid)),"^",13)
	.q:(IsForcedFlag'="")&&(TIsForcedFlag'=IsForcedFlag)
	.s TInspectFee = $p($g(^DHCEQInspectPlan(rowid)),"^",14)
	.s TStatus = $p($g(^DHCEQInspectPlan(rowid)),"^",15)
	.q:TStatus'="1"
	.s TRemark = $p($g(^DHCEQInspectPlan(rowid)),"^",16)
	.s TAddUserDR = $p($g(^DHCEQInspectPlan(rowid)),"^",17)
	.i TAddUserDR '=""  d
	..s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInspectPlan(rowid)),"^",18),"date")
	.s TAddTime = $p($g(^DHCEQInspectPlan(rowid)),"^",19)
	.s TUpdateUserDR = $p($g(^DHCEQInspectPlan(rowid)),"^",20)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInspectPlan(rowid)),"^",21),"date")
	.s TUpdateTime = $p($g(^DHCEQInspectPlan(rowid)),"^",22)
	.s TCycleNum=TCycleNum_TCycleUnit
	
	.d OutputRowGetInspectAlert
	quit
OutputRowGetInspectAlert
	s Data=$lb(TRowID,TName,TEquipDR,TCycleNum,TCycleUnitDR,TInspectTypeDR,TPreInspectDate,TNextMaintDate,TPreWarnDaysNum,TManageLocDR,TManageUserDR,TOutInspectFlag,TMeasureDeptDR,TIsForcedFlag,TInspectFee,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TEquip,TCycleUnit,TInspectType,TManageLoc,TManageUser,TMeasureDept,TAddUser,TUpdateUser,TModelDR,TModel)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInspectAlert
	s (TRowID,TName,TEquipDR,TCycleNum,TCycleUnitDR,TInspectTypeDR,TPreInspectDate,TNextMaintDate,TPreWarnDaysNum,TManageLocDR,TManageUserDR,TOutInspectFlag,TMeasureDeptDR,TIsForcedFlag,TInspectFee,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TEquip,TCycleUnit,TInspectType,TManageLoc,TManageUser,TMeasureDept,TAddUser,TUpdateUser,TModelDR,TModel)=""
	quit
}

ClassMethod GetInspectAlertFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInspectAlertExecute ]
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

ClassMethod GetInspectAlertClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInspectAlertExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetStatus(InspectPlanDR As %Library.String)
{
	i InspectPlanDR="" q ""
	q $p($g(^DHCEQInspectPlan(InspectPlanDR)),"^",15)
}

}
