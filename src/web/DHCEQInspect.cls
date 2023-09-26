Class web.DHCEQInspect Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 43;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "IS_RowID";

ClassMethod AUditInspect(itmjs As %Library.String = "", itmjsex As %Library.String = "", IRowID As %Library.String, IStatus As %Library.String, InspectPlanDR As %Library.String, InspectDate As %Library.String, User)
{
	Tstart
	i InspectPlanDR'=""{
		s PlanCycleNum=$P(^DHCEQInspectPlan(InspectPlanDR),"^",3)
		s PlanCycleDR=$p(^DHCEQInspectPlan(InspectPlanDR),"^",4)
		i PlanCycleDR'="" s PlanCycleType=$p(^DHCEQCCode("DHCEQCCycleUnit",PlanCycleDR),"^",4)
		s PlanCycleType=$CASE(PlanCycleType,"1":"yyyy","2":"m","3":"d")
		s NextInspectDate=##Class(web.DHCEQCommon).DateAdd(PlanCycleType,PlanCycleNum,InspectDate)
		s InspectDate=##Class(web.DHCEQCommon).TransValueFromPage(InspectDate,"date") ;$ZDH(InspectDate,4)
		s NextInspectDate=##Class(web.DHCEQCommon).TransValueFromPage(NextInspectDate,"date") ;$ZDH(NextInspectDate,4)
		&sql(Update sqluser.DHC_EQInspectPlan set IP_PreInspectDate=:InspectDate,IP_NextMaintDate=:NextInspectDate where IP_RowID=:InspectPlanDR)
		s return=SQLCODE
		i SQLCODE'=0 TROLLBACK
		}
	s Date=+$H
	s Time=$P($H,",",2)
	s Fee=$p($G(^DHCEQInspect(IRowID)),"^",10)
	i (Fee'="")&&(Fee'=0)
	{
		s SQLCODE=..GetValue(User,Date,Time,IRowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	/*********************************************************/ //2009-08-04 党军 begin
	s LI(2)=$p($g(^DHCEQInspect(IRowID)),"^",1)  //设备
	i LI(2)'="" d
	.s LI(4)=$p($g(^DHCEQEquip(LI(2))),"^",19)   //原使用科室
	.s LI(5)=$p($g(^DHCEQEquip(LI(2))),"^",17) //原管理科室
	.s LI(6)=$p($g(^DHCEQEquip(LI(2))),"^",67)  //原库房
	.s LI(7)=$p($g(^DHCEQEquip(LI(2))),"^",27)  //原值
	.s LI(8)=$p($g(^DHCEQEquip(LI(2))),"^",28)  //原净值
	.s LI(9)=$p($g(^DHCEQEquip(LI(2))),"^",19)   //变动后使用科室
	.s LI(10)=$p($g(^DHCEQEquip(LI(2))),"^",17) //变动后管理科室
	.s LI(11)=$p($g(^DHCEQEquip(LI(2))),"^",67)  //变动后库房
	.s LI(12)=$p($g(^DHCEQEquip(LI(2))),"^",27)  //变动后原值
	.s LI(13)=$p($g(^DHCEQEquip(LI(2))),"^",28)  //变动后净值
	.s InspectType=$p($g(^DHCEQInspect(IRowID)),"^",3) //检查类型
	i InspectType'="" s LI(14)=$p($g(^DHCEQCCode("DHCEQCInspectType",InspectType)),"^",2)  //变动原因
	s LI(15)=$p($g(^DHCEQInspect(IRowID)),"^",14)  //变动描述
	s LI(16)=Date	//变动日期
	s LI(17)=Time	//变动时间
	s LI(18)=$p($g(^DHCEQInspect(IRowID)),"^",10)  //费用
	s LI(19)="P"	//生命周期类型
	s LI(20)=33	//来源类型
	s LI(21)=IRowID	//来源ID
	s LI(23)=$p($g(^DHCEQInspect(IRowID)),"^",14)  //备注
	s LI(27)=User	//更新人
	s LI(28)=Date	//更新日期
	s LI(29)=Time	//更新时间
	&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	i SQLCODE <0
	{
		TRollBack
		q SQLCODE
	}
	/*********************************************************/ //2009-08-04 党军 end
	&sql(Update sqluser.DHC_EQInspect set IS_Status=:IStatus  where IS_RowID=:IRowID)
	s return=SQLCODE
	i SQLCODE'=0 TROLLBACK
	Tcommit
	q return
}

ClassMethod GetValue(User, Date, Time, InspectDR)
{
	s val=""
	s val=val_$p($G(^DHCEQInspect(InspectDR)),"^",1)_"^" //EquipDR 1
	s val=val_InspectDR_"^" //InspectDR 2
	s val=val_""_"^" //CostallotDR 3
	s val=val_$p($G(^DHCEQInspect(InspectDR)),"^",10)_"^" //UseFee 4
	s val=val_$p($G(^DHCEQInspect(InspectDR)),"^",4)_"^" //FeeDate 5
	s val=val_$p($G(^DHCEQInspect(InspectDR)),"^",7)_"^" //UseLocDR 6
	s val=val_$p($G(^DHCEQInspect(InspectDR)),"^",5)_"^" //ManageLocDR 7
	s val=val_##class(web.DHCEQMaint).GetFeeType(5)_"^" //FeeTypeDR 8
	s val=val_User_"^" //user 9
	s val=val_Date_"^" //Date 10
	s val=val_Time_"^" //Time 11
	s val=val_"检查记录产生费用" //Remark 12
	s Return=##class(web.DHCEQMaint).InsertLifeFee(4,val)
	q Return
}

ClassMethod GetEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
	Quit $$$OK
}

Parameter SQLDESCRIPTION = "IS_RowID";

ClassMethod GetEquipExecute(ByRef qHandle As %Binary, EquipDR As %String) As %Status
{
	Set repid=$I(^CacheTemp)

	If $g(ind)="" Set ind=1
	Set RowID=0
	f  s RowID=$o(^DHCEQEquip(RowID)) q:(RowID="")!(RowID="0")  d
	  .s EQDR=RowID
	  .s EQName=$p(^DHCEQEquip(RowID),"^",1)
	  .s EQMLoc=$p(^DHCEQEquip(RowID),"^",4)
	  .d EquipOutputRow
	s qHandle=$lb(0,repid,0)
	
	Quit $$$OK
EquipOutputRow
	set Data=$lb(EQDR,EQName,EQMLoc) //顺序和query中的顺序一致
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod GetEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	// if there are no more rows, finish fetching
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetInspectTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInspectTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Parameter SQLROWID = "IS_RowID";

ClassMethod GetInspectTypeExecute(ByRef qHandle As %Binary, EquipName As %String) As %Status
{
	Set repid=$I(^CacheTemp)

	If $g(ind)="" Set ind=1
	Set RowID=0
	
	f  s RowID=$o(^DHCEQCCode("DHCEQCInspectType",RowID)) q:(RowID="")!(RowID="0")  d
	  .s ITNo=RowID
	  .s ITName=$p(^DHCEQCCode("DHCEQCInspectType",RowID),"^",2)
	  .d InspectTypeOutputRow
	s qHandle=$lb(0,repid,0)
	
	Quit $$$OK
InspectTypeOutputRow
	set Data=$lb(ITName,ITNo) //顺序和query中的顺序一致
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	quit
}

ClassMethod GetInspectTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInspectTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	// if there are no more rows, finish fetching
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

ClassMethod GetMeasureDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMeasureDeptExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMeasureDeptExecute(ByRef qHandle As %Binary, MeasureDept As %String) As %Status
{
	Set repid=$I(^CacheTemp)

	If $g(ind)="" Set ind=1
	Set RowID=0
	
	f  s RowID=$o(^DHCEQCCode("DHCEQCMeasureDept",RowID)) q:(RowID="")!(RowID="0")  d
	  .s MDNo=RowID
	  .s MDName=$p(^DHCEQCCode("DHCEQCMeasureDept",RowID),"^",1)
	  .//q:MDName'[MeasureDept
	  .q:MDName'[MeasureDept 
	  .d MeasureDeptOutputRow
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
MeasureDeptOutputRow
	set Data=$lb(MDName,MDNo) //顺序和query中的顺序一致
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	quit
}

ClassMethod GetMeasureDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMeasureDeptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	// if there are no more rows, finish fetching
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod UpdateInspect(itmjs As %Library.String = "", itmjsex As %Library.String = "", IRowID As %Library.String, ValueList As %Library.String)
{
	s IEquipID=$P(ValueList,"^",1)
	s IInspectPlanID=$P(ValueList,"^",2)
	s IInspectTypeID=$P(ValueList,"^",3)
	s IInspectDate=$P(ValueList,"^",4)
	
	IF IInspectDate'="" {
		s IInspectDate=##Class(web.DHCEQCommon).TransValueFromPage(IInspectDate,"date") ;$zdh(IInspectDate,4)
		}
	//s IInspectDate=$zd(IInspectDate)
	
	s IManageLocID=$P(ValueList,"^",5)
	s IManageUserID=$P(ValueList,"^",6)
	s IUseLocID=$P(ValueList,"^",7)
	s IMeasureDeptID=$P(ValueList,"^",8)
	s IInspectUsers=$P(ValueList,"^",9)
	
	s IInspectFee=$NUMBER($p(ValueList,"^",10))
	
	s IInspectResult=$P(ValueList,"^",11)
	s IIsForcedFlag=$P(ValueList,"^",12)
	s IRemark=$P(ValueList,"^",13)
	s IIsOutInspectFlag=$P(ValueList,"^",14)
	s IUserID=$p(ValueList,"^",15)
	s IDate=+$h
	s ITime=$P($h,",",2)
	If IRowID="" {
		&sql(Insert Into SQLUser.DHC_EQInspect
		(IS_EquipDR,IS_InspectPlanDR,IS_InspectTypeDR,IS_InspectDate,IS_ManageLocDR,IS_ManageUserDR,IS_UseLocDR,IS_MeasureDeptDR,IS_InspectUsers,IS_InspectFee,IS_ResultDR,IS_IsForcedFlag,IS_Remark,IS_OutInspectFlag,IS_Status,IS_AddUserDR,IS_AddDate,IS_AddTime) 
		values
		(:IEquipID,:IInspectPlanID,:IInspectTypeID,:IInspectDate,:IManageLocID,:IManageUserID,:IUseLocID,:IMeasureDeptID,:IInspectUsers,:IInspectFee,:IInspectResult,:IIsForcedFlag,:IRemark,:IIsOutInspectFlag,'0',:IUserID,:IDate,:ITime))
		set return=SQLCODE
		i SQLCODE'=0 TROLLBACK
		s IRowID=$G(%ROWID)
		q return_"^"_IRowID
	}
	Else {
		&sql(Update sqluser.DHC_EQInspect set IS_EquipDR=:IEquipID,IS_InspectPlanDR=:IInspectPlanID,IS_InspectTypeDR=:IInspectTypeID,IS_InspectDate=:IInspectDate,IS_ManageLocDR=:IManageLocID,IS_ManageUserDR=:IManageUserID,IS_UseLocDR=:IUseLocID,IS_MeasureDeptDR=:IMeasureDeptID,IS_InspectUsers=:IInspectUsers,IS_InspectFee=:IInspectFee,IS_ResultDR=:IInspectResult,IS_IsForcedFlag=:IIsForcedFlag,IS_Remark=:IRemark,IS_UpdateUserDR=:IUserID,IS_AddDate=:IDate,IS_AddTime=:ITime,IS_OutInspectFlag=:IIsOutInspectFlag where IS_RowID=:IRowID)
		set return=SQLCODE
		i SQLCODE'=0 TROLLBACK
		q return_"^"_IRowID
	}
}

ClassMethod DeleteInspect(itmjs As %Library.String = "", itmjsex As %Library.String = "", IRowID As %Library.String)
{
	&sql(Delete from sqluser.DHC_EQInspect where IS_RowID=:IRowID)
	set return=SQLCODE
	i SQLCODE'=0 Trollback
	&sql(Delete from sqluser.DHC_EQInspectItem where ISI_InspectDR=:IRowID)
	set return=return+SQLCODE
	i SQLCODE'=0 Trollback
	q return
}

Query GetStatus() As %Query(ROWSPEC = "Status:%String,Code:%String")
{
}

ClassMethod GetStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetStatusExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)

	If $g(ind)="" Set ind=1
	Set RowID=0
	s Code=0
	s Status=##Class(web.DHCEQCommon).GetEditStatusDisplay(Code) //"新增"
	d OutputRow
	s Code=1
	s Status=##Class(web.DHCEQCommon).GetEditStatusDisplay(Code) //"提交"
	d OutputRow
	
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Status,Code) //顺序和query中的顺序一致
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	quit
}

ClassMethod GetStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatusExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	// if there are no more rows, finish fetching
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetEquip(EquipDR As %String) As %Query(ROWSPEC = "EQDR:%String,EQName:%String,EQMLOC:%String")
{
}

Query GetInspectType(EquipName As %String) As %Query(ROWSPEC = "TypeName:%String,TypeNo:%String")
{
}

Query GetMeasureDept(MeasureDept As %String) As %Query(ROWSPEC = "MDName:%String,MDNo:%String")
{
}

ClassMethod GetOneInspect(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String)
{
	if RowID="" q ""
	s (EquipDR,EquipName,InspectPlanDR,InspectTypeDR,InspectType,InspectDate,ManageLocDR,ManageLoc,ManageUserDR,ManageUser,UseLocDR,UseLoc,MeasureDeptDR,MeasureDept,InspectUsers,InspectFee,Result,IsForcedFlag,Status,Remark)=""
	s EquipDR=$p($g(^DHCEQInspect(RowID)),"^",1)
	i EquipDR'="" s EquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	s InspectPlanDR=$p($g(^DHCEQInspect(RowID)),"^",2)
	s InspectTypeDR=$p($g(^DHCEQInspect(RowID)),"^",3)
	i InspectTypeDR'="" s InspectType=$p($g(^DHCEQCCode("DHCEQCInspectType",InspectTypeDR)),"^",2)
	s InspectDate=$P($g(^DHCEQInspect(RowID)),"^",4)
	s InspectDate=##Class(web.DHCEQCommon).TransValueToPage(InspectDate,"date") ;$zd(InspectDate,4)
	s ManageLocDR=$P($g(^DHCEQInspect(RowID)),"^",5)
	i ManageLocDR'="" s ManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",ManageLocDR) //$P(^DHCEQInspect(RowID),"^",4)
	s ManageUserDR=$P($g(^DHCEQInspect(RowID)),"^",6)
	i ManageUserDR'="" s ManageUser=##class(web.DHCEQCommon).GetTrakNameByID("user",ManageUserDR) //$P(^DHCEQInspect(RowID),"^",4)
	s UseLocDR=$P($g(^DHCEQInspect(RowID)),"^",7)   //modify by jyp 2019-10-18 CTLOC调整
	;i UseLocDR'="" s UseLoc=$P($G(^CTLOC(UseLocDR)),"^",2) //$P(^CTLoc(UseLocDR),"^",4)   //modify by jyp 2019-10-18 CTLOC调整
	i UseLocDR'="" s UseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
	s MeasureDeptDR=$P($g(^DHCEQInspect(RowID)),"^",8)
	i MeasureDeptDR'="" s MeasureDept=$P($g(^DHCEQCCode("DHCEQCMeasureDept",MeasureDeptDR)),"^",1)
	s InspectUsers=$P($g(^DHCEQInspect(RowID)),"^",9)
	s InspectFee=$P($g(^DHCEQInspect(RowID)),"^",10)
	s ResultDR=$P($g(^DHCEQInspect(RowID)),"^",11)
	i ResultDR'="" s Result=$P($g(^DHCEQCCode("DHCEQCInspectResult",ResultDR)),"^",2)
	s IsForcedFlag=$P($g(^DHCEQInspect(RowID)),"^",12)
	s Status=$P($g(^DHCEQInspect(RowID)),"^",13)
	s Remark=$P($g(^DHCEQInspect(RowID)),"^",14)
	s IsOutInspectFlag=$P($g(^DHCEQInspect(RowID)),"^",21)
	s ReturnList=EquipDR_"^"_EquipName_"^"_InspectPlanDR_"^"_InspectTypeDR_"^"_InspectType_"^"_InspectDate_"^"_ManageLocDR
	s ReturnList=ReturnList_"^"_ManageLoc_"^"_ManageUserDR_"^"_ManageUser_"^"_UseLocDR_"^"_UseLoc_"^"_MeasureDeptDR_"^"_MeasureDept
	s ReturnList=ReturnList_"^"_InspectUsers_"^"_InspectFee_"^"_Result_"^"_IsForcedFlag_"^"_Status_"^"_Remark_"^"_RowID_"^"_ResultDR_"^"_IsOutInspectFlag
	s ReturnList=##class(web.DHCEQCommon).Replace(ReturnList,$C(13,10),"\n")
	q ReturnList
}

Query GetInspect(EquipDR, ModelDR, ManageLocDR, UseLocDR, InspectTypeDR, Status, StartDate, EndDate, IsForcedFlag, QXType As %String = "") As %Query(ROWSPEC = "RowID:%String,EquipDR:%String,InspectPlanDR:%String,InspectTypeDR:%String,InspectDate:%String,ManageLocDR:%String,ManageUserDR:%String,UseLocDR:%String,MeasureDeptDR:%String,InspectUsers:%String,InspectFee:%String,Result:%String,IsForcedFlag:%String,Status:%String,Remark:%String,AddUserDR:%String,AddDate:%String,AddTime:%String,UpdateUserDR:%String,UpdateDate:%String,UpdateTime:%String,Equip:%String,InspectPlan:%String,InspectType:%String,ManageLoc:%String,ManageUser:%String,UseLoc:%String,MeasureDept:%String,AddUser:%String,UpdateUser:%String,Model:%String,ManuFactory:%String,ResultDR:%String,IsOutInspectFlag:%String")
{
}

ClassMethod GetInspectExecute(ByRef qHandle As %Binary, EquipDR, ModelDR, ManageLocDR, UseLocDR, InspectTypeDR, Status, StartDate, EndDate, IsForcedFlag, QXType As %String = "") As %Status
{
        new repid, index,rowid
        Set repid=$I(^CacheTemp)
        Set qHandle=$lb(0,repid,0)
        s index=1
        s rowid=0
        d BuildDataGetInspect
        Quit $$$OK
BuildDataGetInspect
        f  s rowid=$o(^DHCEQInspect(rowid)) quit:rowid=""  d
        .d ResetVariablesGetInspect
        .s TRowID = rowid
        .q:(EquipDR="")&&(ModelDR="")&&(ManageLocDR="")&&(UseLocDR="")&&(InspectTypeDR="")&&(Status="")&&(StartDate="")&&(EndDate="")&&(IsForcedFlag="")
        .s TEquipDR = $p($g(^DHCEQInspect(rowid)),"^",1)
        .q:(TEquipDR'=EquipDR)&(EquipDR'="")
        .i TEquipDR '=""  d
        ..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
        ..s TEquipModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
        ..i TEquipModelDR '= "" d
        ...s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TEquipModelDR)),"^",2)
        ..s TManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
        ..i TManuFactoryDR '="" d
        ...s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",2) //ManuFactoryDR
        ...//$p($g(^(ManuFactoryDR)),"^",XX)
        .q:(TEquipModelDR'=ModelDR)&(ModelDR'="")
        .s TInspectPlanDR = $p($g(^DHCEQInspect(rowid)),"^",2)
        .i TInspectPlanDR '=""  d
        ..s TInspectPlan = $p($g(^DHCEQInspectPlan(TInspectPlanDR)),"^",1)
        .s TInspectTypeDR = $p($g(^DHCEQInspect(rowid)),"^",3)
        .i TInspectTypeDR '=""  d
        ..s TInspectType = $p($g(^DHCEQCCode("DHCEQCInspectType",TInspectTypeDR)),"^",2)
        .q:(TInspectTypeDR'=InspectTypeDR)&(InspectTypeDR'="")
        .s TInspectDate = $p($g(^DHCEQInspect(rowid)),"^",4)
        .i StartDate="" s StartDate=0
        .i EndDate="" s EndDate=+$H
        .q:(TInspectDate<StartDate)!(TInspectDate>EndDate)
        .i TInspectDate'=0 s TInspectDate=##Class(web.DHCEQCommon).TransValueToPage(TInspectDate,"date") ;$zd(TInspectDate,4)
        .s TManageLocDR = $p($g(^DHCEQInspect(rowid)),"^",5)
        .i TManageLocDR '=""  d
        ..s TManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
        ..//$p($g(^(ManageLocDR)),"^",XX)
        .q:(TManageLocDR'=ManageLocDR)&(ManageLocDR'="")
        .q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TManageLocDR))) //2010-10-28 DJ
        .s TManageUserDR = $p($g(^DHCEQInspect(rowid)),"^",6)
        .i TManageUserDR '=""  d
        ..s TManageUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TManageUserDR)
        ..//$p($g(^(ManageUserDR)),"^",XX)
        .s TUseLocDR = $p($g(^DHCEQInspect(rowid)),"^",7)
        .i TUseLocDR '=""  d
        ..s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
        .q:(TUseLocDR'=UseLocDR)&(UseLocDR'="")
        .s TMeasureDeptDR = $p($g(^DHCEQInspect(rowid)),"^",8)
        .i TMeasureDeptDR '=""  d
        ..s TMeasureDept = $p($g(^DHCEQCCode("DHCEQCMeasureDept",TMeasureDeptDR)),"^",1)
        .s TInspectUsers = $p($g(^DHCEQInspect(rowid)),"^",9)
        .s TInspectFee = $p($g(^DHCEQInspect(rowid)),"^",10)
        .s TResultDR = $P($g(^DHCEQInspect(TRowID)),"^",11)
        .i TResultDR'="" s TResult=$P($g(^DHCEQCCode("DHCEQCInspectResult",TResultDR)),"^",2)
        .s TIsForcedFlag = $p($g(^DHCEQInspect(rowid)),"^",12)
        .q:(IsForcedFlag'="")&&(TIsForcedFlag'=IsForcedFlag)
        .s TStatus = $p($g(^DHCEQInspect(rowid)),"^",13)
        .s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
        .//i TStatus="1" s TStatus="提交"
        .//i TStatus="0" s TStatus="新增"
        .q:(Status'="")&(Status'=TStatus)
        .s TRemark = $p($g(^DHCEQInspect(rowid)),"^",14)
        .s TIsOutInspectFlag=$p($g(^DHCEQInspect(rowid)),"^",21)
        .d OutputRowGetInspect
        quit
OutputRowGetInspect
        s Data=$lb(TRowID,TEquipDR,TInspectPlanDR,TInspectTypeDR,TInspectDate,TManageLocDR,TManageUserDR,TUseLocDR,TMeasureDeptDR,TInspectUsers,TInspectFee,TResult,TIsForcedFlag,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TEquip,TInspectPlan,TInspectType,TManageLoc,TManageUser,TUseLoc,TMeasureDept,TAddUser,TUpdateUser,TModel,TManuFactory,TResultDR,TIsOutInspectFlag)
        s (TRowID,TEquipDR,TInspectPlanDR,TInspectTypeDR,TInspectDate,TManageLocDR,TManageUserDR,TUseLocDR,TMeasureDeptDR,TInspectUsers,TInspectFee,TResult,TIsForcedFlag,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TEquip,TInspectPlan,TInspectType,TManageLoc,TManageUser,TUseLoc,TMeasureDept,TAddUser,TUpdateUser,TModel,TManuFactory,TIsOutInspectFlag,TResultDR)=""
        Set ^CacheTemp(repid,index)=Data
        Set index=index+1
        quit
ResetVariablesGetInspect
        quit
}

ClassMethod GetInspectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRefAtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInspectExecute ]
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

ClassMethod GetInspectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInspectExecute ]
{
        Set repid=$LIST(qHandle,2)
        Kill ^CacheTemp(repid)
        Quit $$$OK
}

ClassMethod GetStatus(InspectDR As %Library.String)
{
	i InspectDR="" q ""
	q $p($g(^DHCEQInspect(InspectDR)),"^",13)
}

ClassMethod GetWarnIcon(nextdate As %Library.String, TPreWarnDaysNum As %Library.String)
{
	i ##Class(web.DHCEQCommon).TransValueFromPage(nextdate,"date")<=+$H  q "websys/sys_warning.gif"
	i ##Class(web.DHCEQCommon).TransValueFromPage(nextdate,"date")<=+$H+TPreWarnDaysNum  q "websys/sys_information.gif"
	q ""
}

Storage Default
{
<Data name="DHCEQInspectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQInspectD</DataLocation>
<DefaultData>DHCEQInspectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCEQInspectD</IdLocation>
<IndexLocation>^web.DHCEQInspectI</IndexLocation>
<StreamLocation>^web.DHCEQInspectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
