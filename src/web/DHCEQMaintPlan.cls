Class web.DHCEQMaintPlan Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 57;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MP_RowID";

Parameter SQLDESCRIPTION = "MP_RowID";

Parameter SQLROWID = "MP_RowID";

Query GetMaintPlan(Name, EquipDR, ModelDR, MaintLocDR, MaintTypeDR, QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TEquipDR:%String,TCycleNum:%String,TCycleUnitDR:%String,TMaintTypeDR:%String,TPreMaintDate:%String,TNextMaintDate:%String,TPreWarnDaysNum:%String,TMaintFee:%String,TMaintLocDR:%String,TMaintUserDR:%String,TMaintModeDR:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TEquip:%String,TCycleUnit:%String,TMaintType:%String,TMaintLoc:%String,TMaintUser:%String,TMaintMode:%String,TAddUser:%String,TUpdateUser:%String,TModel:%String,TOtherFee:%String")
{
}

ClassMethod GetMaintPlanExecute(ByRef qHandle As %Binary, Name, EquipDR, ModelDR, MaintLocDR, MaintTypeDR, QXType As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetMaintPlan
	Quit $$$OK
BuildDataGetMaintPlan
	f  s rowid=$o(^DHCEQMaintPlan(rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaintPlan
	.s TRowID = rowid
	.q:(ModelDR="")&&(EquipDR="")&&(MaintLocDR="")&&(MaintTypeDR="")&&(Name="")
	.s TName = $p($g(^DHCEQMaintPlan(rowid)),"^",1)
	.q:TName'[Name
	.s TEquipDR = $p($g(^DHCEQMaintPlan(rowid)),"^",2)
	.q:(TEquipDR'=EquipDR)&(EquipDR'="")
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TModelDR = $p($g(^DHCEQEquip(TEquipDR)),"^",3)
	..i TModelDR'="" d
	...s TModel=$p($G(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.//q:(TEquip'[Equip)&(Equip'="")
	.q:(TModelDR'=ModelDR)&(ModelDR'="")
	.s TCycleNum = $p($g(^DHCEQMaintPlan(rowid)),"^",3)
	.s TCycleUnitDR = $p($g(^DHCEQMaintPlan(rowid)),"^",4)
	.i TCycleUnitDR '=""  d
	..s TCycleUnit = $p($g(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
	.s TCycleNum=TCycleNum_TCycleUnit
	.s TMaintTypeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",5)
	.q:(TMaintTypeDR'=MaintTypeDR)&(MaintTypeDR'="")
	.i TMaintTypeDR '=""  d
	..s TMaintType = $p($g(^DHCEQCCode("DHCEQCMaintType",TMaintTypeDR)),"^",2)
	.s TPreMaintDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",6),"date")
	.s TNextMaintDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",7),"date")
	.s TPreWarnDaysNum = $p($g(^DHCEQMaintPlan(rowid)),"^",8)
	.s TMaintFee = $p($g(^DHCEQMaintPlan(rowid)),"^",9)
	.s TMaintLocDR = $p($g(^DHCEQMaintPlan(rowid)),"^",10)
	.q:(TMaintLocDR'=MaintLocDR)&(MaintLocDR'="")
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TMaintLocDR))) //2010-10-28 DJ
	.i TMaintLocDR '=""  d
	..s TMaintLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TMaintLocDR)
	.s TMaintUserDR = $p($g(^DHCEQMaintPlan(rowid)),"^",11)
	.i TMaintUserDR '=""  d
	..s TMaintUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUserDR)
	.s TMaintModeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",12)
	.i TMaintModeDR '=""  d
	..s TMaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",TMaintModeDR)),"^",2)
	.s TRemark = $p($g(^DHCEQMaintPlan(rowid)),"^",13)
	.s TStatus = $p($g(^DHCEQMaintPlan(rowid)),"^",14)
	.s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.s TOtherFee=$p($g(^DHCEQMaintPlan(rowid)),"^",21)
	.//i TStatus = "0" s TStatus = "新增"
	.//i TStatus = "1" s TStatus = "提交"
	.//s TAddUserDR = $p($g(^DHCEQMaintPlan(rowid)),"^",15)
	.//i TAddUserDR '=""  d
	.//.s TAddUser = $p($g(^(TAddUserDR)),"^",XX)
	.//s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",16),"date")
	.//s TAddTime = $p($g(^DHCEQMaintPlan(rowid)),"^",17)
	.//s TUpdateUserDR = $p($g(^DHCEQMaintPlan(rowid)),"^",18)
	.//i TUpdateUserDR '=""  d
	.//.s TUpdateUser = $p($g(^(TUpdateUserDR)),"^",XX)
	.//s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",19),"date")
	.//s TUpdateTime = $p($g(^DHCEQMaintPlan(rowid)),"^",20)
	.d OutputRowGetMaintPlan
	quit
OutputRowGetMaintPlan
	s Data=$lb(TRowID,TName,TEquipDR,TCycleNum,TCycleUnitDR,TMaintTypeDR,TPreMaintDate,TNextMaintDate,TPreWarnDaysNum,TMaintFee,TMaintLocDR,TMaintUserDR,TMaintModeDR,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TEquip,TCycleUnit,TMaintType,TMaintLoc,TMaintUser,TMaintMode,TAddUser,TUpdateUser,TModel,TOtherFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintPlan
	s (TRowID,TName,TEquipDR,TCycleNum,TCycleUnitDR,TMaintTypeDR,TPreMaintDate,TNextMaintDate,TPreWarnDaysNum,TMaintFee,TMaintLocDR,TMaintUserDR,TMaintModeDR,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TEquip,TCycleUnit,TMaintType,TMaintLoc,TMaintUser,TMaintMode,TAddUser,TUpdateUser,TModel,TOtherFee)=""
	quit
}

ClassMethod GetMaintPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintPlanExecute ]
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

ClassMethod GetMaintPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetOneMaintPlan(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQMaintPlan(RowID)
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",2))),"^",1)
	s resultex=resultex_"^"	;CycleUnitDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCCycleUnit",$p(result,"^",4))),"^",2)
	s resultex=resultex_"^"	;MaintTypeDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintType",$p(result,"^",5))),"^",2)
	s $p(result,"^",6)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"date")	;PreMaintDate
	s $p(result,"^",7)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")	;NextMaintDate
	s resultex=resultex_"^"	;MaintLocDR
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",10))
	s resultex=resultex_"^"	;MaintUserDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",11))
	s resultex=resultex_"^"	;MaintModeDR
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintMode",$p(result,"^",12))),"^",2)
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",15))
	s $p(result,"^",16)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",16),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",18))
	s $p(result,"^",19)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",19),"date")	;UpdateDate
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

ClassMethod UpdateMaintPlan(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String)
{
	k PLIST,IRowID
	s IRowID=$p(val,"^",1)
	s PLIST(1) = $p(val,"^",1)	;RowID
		s PLIST(2) = $p(val,"^",2)	;Name
		s PLIST(3) = $p(val,"^",3)	;EquipDR
		s PLIST(4) = $p(val,"^",4)	;CycleNum
		s PLIST(5) = $p(val,"^",5)	;CycleUnitDR
		s PLIST(6) = $p(val,"^",6)	;MaintTypeDR
		s PLIST(7) = $p(val,"^",7)	;PreMaintDate
		i $p(val,"^",7)'=""  s PLIST(7) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"date")	;PreMaintDate
		
		s PLIST(8) = ..GetNextMaintDate($p(val,"^",7),$p(val,"^",4),$p(val,"^",5)) // $p(val,"^",8)	;NextMaintDate
		//i $p(val,"^",8)'=""  s PLIST(8) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date")	;NextMaintDate
		s PLIST(9) = $p(val,"^",9)	;PreWarnDaysNum
		i IRowID'=""
		{
			s PLIST(10)=..GetTotalFee(IRowID,1)+$p(val,"^",17)
		}
		else
		{
			s PLIST(10) = +$p(val,"^",17)	;MaintFee=OtherFee
		}
		s PLIST(11) = $p(val,"^",11)	;MaintLocDR
		s PLIST(12) = $p(val,"^",12)	;MaintUserDR
		s PLIST(13) = $p(val,"^",13)	;MaintModeDR
		s PLIST(14) = $p(val,"^",14)	;Remark
		s PLIST(15) = $p(val,"^",15)	;Status
		i PLIST(15) = "" s PLIST(15) = 0
		s PLIST(22) = +$p(val,"^",17)	;OtherFee
		/*s PLIST(16) = $p(val,"^",16)	;AddUserDR
		s PLIST(17) = $p(val,"^",17)	;AddDate
		i $p(val,"^",17)'=""  s PLIST(17) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",17),"date")	;AddDate
		s PLIST(18) = $p(val,"^",18)	;AddTime
		s PLIST(19) = $p(val,"^",19)	;UpdateUserDR
		s PLIST(20) = $p(val,"^",20)	;UpdateDate
		i $p(val,"^",20)'=""  s PLIST(20) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",20),"date")	;UpdateDate
		s PLIST(21) = $p(val,"^",21)	;UpdateTime*/
	k PLIST(1)
	If IRowID'="" {
		i $p(val,"^",16)'=""  s PLIST(19) = $p(val,"^",16)
		s PLIST(20)=+$H
		s PLIST(21)=$P($H,",",2)
		&sql(Update sqluser.DHC_EQMaintPlan Values :PLIST() where MP_RowID=:IRowID)
		set return=SQLCODE
		i SQLCODE'=0 TROLLBACK
		q return_"^"_IRowID
	}
	Else {
		i $p(val,"^",16)'=""  s PLIST(16) = $p(val,"^",16)
		s PLIST(17)=+$H
		s PLIST(18)=$P($H,",",2)
		&sql(Insert Into SQLUser.DHC_EQMaintPlan Values :PLIST())
		set return=SQLCODE
		i SQLCODE'=0 TROLLBACK
		s IRowID=$G(%ROWID)
		q return_"^"_IRowID
	}
}

ClassMethod GetNextMaintDate(MaintDate, CycleNum, CycleUnit)
{
	i (CycleNum="")||(CycleUnit="")||(MaintDate="") q ""
	i CycleUnit'="" s PlanCycleType=$p(^DHCEQCCode("DHCEQCCycleUnit",CycleUnit),"^",4)
	s PlanCycleType=$CASE(PlanCycleType,"1":"yyyy","2":"m","3":"d")
	s NextMaintDate=##Class(web.DHCEQCommon).DateAdd(PlanCycleType,CycleNum,MaintDate)
	q ##Class(web.DHCEQCommon).TransValueFromPage(NextMaintDate,"date")
}

ClassMethod DeleteMaintPlan(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String)
{
	TSTART
	s return=0
	&sql(Delete from sqluser.DHC_EQMaintPlanItem where MPI_MaintPlanDR=:RowID)
	s return=SQLCODE
	i SQLCODE<0 
	{
		TROLLBACK
		q return
	}
	&sql(Delete from sqluser.DHC_EQMaintPlanPart where MPP_MaintPlanDR=:RowID)
	s return=SQLCODE
	i SQLCODE<0 
	{
		TROLLBACK
		q return
	} 
	&sql(Delete from sqluser.DHC_EQMaintPlan where MP_RowID=:RowID)
	s return=SQLCODE
	i SQLCODE'=0 
	{
		TROLLBACK
		q return
	}
	TCOMMIT
	q return
}

ClassMethod SubmitMaintPlan(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String, Val As %Library.String)
{
	&sql(Update sqluser.DHC_EQMaintPlan set MP_Status=:Val where MP_RowID=:RowID)
	set return=SQLCODE
	i SQLCODE'=0 Trollback
	q return
}

ClassMethod GetTotalFee(RowID, Type)
{
	//Type=1 返回配件金额
	//Type=2 返回配件金额+其他金额
	s (OtherFee,PartFee)=0
	s OtherFee=$P($G(^DHCEQMaintPlan(RowID)),"^",21)
	i OtherFee="" s OtherFee=0
	&sql(select sum(MPP_TotalFee) into :PartFee from sqluser.DHC_EQMaintPlanPart where MPP_MaintPlanDR=:RowID and MPP_FeeFlag='Y')
	i PartFee="" s PartFee=0
	i Type=1 q PartFee
	i Type=2 q OtherFee+PartFee
}

ClassMethod ExecuteMaintPlan(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String, User As %Library.String)
{
	s PLIST(2)=$p($G(^DHCEQMaintPlan(RowID)),"^",2) //EquipDR
	s PLIST(4)=RowID //MaintPlanDR
	s PLIST(5)=$p($G(^DHCEQMaintPlan(RowID)),"^",5) //MaintType
	s PLIST(6)=+$H  //MaintDate
	s PLIST(7)=$p($g(^DHCEQMaintPlan(RowID)),"^",10) //MaintLocDR
	s PLIST(8)=$p($g(^DHCEQMaintPlan(RowID)),"^",11) //MaintUserDR
	s PLIST(9)=$p($g(^DHCEQMaintPlan(RowID)),"^",12) //MaintModeDR
	s PLIST(10)=$p($g(^DHCEQMaintPlan(RowID)),"^",9) //MaintTotal
	s PLIST(11)="N" //$p($g(^DHCEQInspectPlan(RowID)),"^",14) //InputFlag
	s PLIST(12)=$p($g(^DHCEQEquip(PLIST(2))),"^",17) //ManageLocDR
	s PLIST(13)=$p($g(^DHCEQEquip(PLIST(2))),"^",19) //UseLocDR
	s PLIST(25)=$p($g(^DHCEQMaintPlan(RowID)),"^",21) //OtherFee
	s PLIST(14)=0 //Status
	s PLIST(16)=User //AddUserDR
	s PLIST(17)=+$H //AddDate
	s PLIST(18)=$p($h,",",2) //AddTime
	TSTART
	s return=0
	&sql(Insert Into SQLUser.DHC_EQMaint Values :PLIST())
	i SQLCODE'=0 {
		s return=SQLCODE
		TROLLBACK
		q return_"^"_"1"}
	s IRowID=$g(%ROWID)
	
	&sql(Insert Into SQLUser.DHC_EQMaintItem (MTI_MaintDR,MTI_MaintpartDR,MTI_MaintItemDR) select :IRowID,MPI_MaintPartDR,MPI_MaintItemDR from SQLUser.DHC_EQMaintPlanItem where MPI_MaintPlanDR=:RowID)

	i (SQLCODE'=0)&&(SQLCODE'=100) {
		s return=SQLCODE
		TROLLBACK
		q return_"^"_"2"}
		
	&sql(Insert Into SQLUser.DHC_EQMaintPart (MTP_MaintDR,MTP_FittingsDR,MTP_QuantityNum,MTP_PriceFee,MTP_TotalFee) select :IRowID,MPP_FittingsDR,MPP_QuantityNum,MPP_PriceFee,MPP_TotalFee from SQLUser.DHC_EQMaintPlanPart where MPP_MaintPlanDR=:RowID)

	i (SQLCODE'=0)&&(SQLCODE'=100) {
		s return=SQLCODE
		TROLLBACK
		q return_"^"_"3"}
	
	TCOMMIT
	q return_"^"_IRowID
}

ClassMethod CheckMaint(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String)
{
	
	;&sql(Select MT_RowID from SQLUser.DHC_EQMaint where MT_MaintPlanDR=:RowID and MT_Status='0')
	//i SQLCODE<=0{
		q SQLCODE
	//}
}

Query GetMaintAlert(StartDate, EndDate, EquipDR, MaintLocDR, MaintTypeDR) As %Query(ROWSPEC = "TRowID:%String,TName:%String,TEquipDR:%String,TCycleNum:%String,TCycleUnitDR:%String,TMaintTypeDR:%String,TPreMaintDate:%String,TNextMaintDate:%String,TPreWarnDaysNum:%String,TMaintFee:%String,TMaintLocDR:%String,TMaintUserDR:%String,TMaintModeDR:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TEquip:%String,TCycleUnit:%String,TMaintType:%String,TMaintLoc:%String,TMaintUser:%String,TMaintMode:%String,TAddUser:%String,TUpdateUser:%String,TModelDR:%String,TModel:%String")
{
}

//,StartDate,EndDate

ClassMethod GetMaintAlertExecute(ByRef qHandle As %Binary, StartDate, EndDate, EquipDR, MaintLocDR, MaintTypeDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetMaintAlert
	Quit $$$OK
BuildDataGetMaintAlert
	f  s rowid=$o(^DHCEQMaintPlan(rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaintAlert
	.s TRowID = rowid
	.s TName = $p($g(^DHCEQMaintPlan(rowid)),"^",1)
	.s TEquipDR = $p($g(^DHCEQMaintPlan(rowid)),"^",2)
	.q:(EquipDR'="")&&(TEquipDR'=EquipDR)
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TModelDR = $p($g(^DHCEQEquip(TEquipDR)),"^",3)
	..i TModelDR '="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TCycleNum = $p($g(^DHCEQMaintPlan(rowid)),"^",3)
	.s TCycleUnitDR = $p($g(^DHCEQMaintPlan(rowid)),"^",4)
	.i TCycleUnitDR '=""  d
	..s TCycleUnit = $p($g(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
	.s TMaintTypeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",5)
	.q:(MaintTypeDR'="")&&(TMaintTypeDR'=MaintTypeDR)
	.i TMaintTypeDR '=""  d
	..s TMaintType = $p($g(^DHCEQCCode("DHCEQCMaintType",TMaintTypeDR)),"^",2)
	.s TPreMaintDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",6),"date")
	.s TNextMaintDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",7),"date")
	.s TPreWarnDaysNum = $p($g(^DHCEQMaintPlan(rowid)),"^",8)
	.i (StartDate="")&&(EndDate="") q:(+$h+TPreWarnDaysNum)<$p($g(^DHCEQMaintPlan(rowid)),"^",7)
	.i (StartDate'="")||(EndDate'="")  d 
	..i StartDate="" s StartDate=0
	..i EndDate="" s EndDate=+$h
	.i (StartDate'="")||(EndDate'="") q:($p($g(^DHCEQMaintPlan(rowid)),"^",7)<StartDate)!($p($g(^DHCEQMaintPlan(rowid)),"^",7)>EndDate)
	.s TMaintFee = $p($g(^DHCEQMaintPlan(rowid)),"^",9)
	.s TMaintLocDR = $p($g(^DHCEQMaintPlan(rowid)),"^",10)
	.q:(MaintLocDR'="")&&(TMaintLocDR'=MaintLocDR)
	.i TMaintLocDR '=""  d
	..s TMaintLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TMaintLocDR)
	.s TMaintUserDR = $p($g(^DHCEQMaintPlan(rowid)),"^",11)
	.i TMaintUserDR '=""  d
	..s TMaintUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUserDR)
	.s TMaintModeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",12)
	.i TMaintModeDR '=""  d
	..s TMaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",TMaintModeDR)),"^",2)
	.s TRemark = $p($g(^DHCEQMaintPlan(rowid)),"^",13)
	.s TStatus = $p($g(^DHCEQMaintPlan(rowid)),"^",14)
	.q:TStatus'="1"
	.s TAddUserDR = $p($g(^DHCEQMaintPlan(rowid)),"^",15)
	.i TAddUserDR '=""  d
	..s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",16),"date")
	.s TAddTime = $p($g(^DHCEQMaintPlan(rowid)),"^",17)
	.s TUpdateUserDR = $p($g(^DHCEQMaintPlan(rowid)),"^",18)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",19),"date")
	.s TUpdateTime = $p($g(^DHCEQMaintPlan(rowid)),"^",20)
	.s TCycleNum=TCycleNum_TCycleUnit
	.d OutputRowGetMaintAlert
	quit
OutputRowGetMaintAlert
	s Data=$lb(TRowID,TName,TEquipDR,TCycleNum,TCycleUnitDR,TMaintTypeDR,TPreMaintDate,TNextMaintDate,TPreWarnDaysNum,TMaintFee,TMaintLocDR,TMaintUserDR,TMaintModeDR,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TEquip,TCycleUnit,TMaintType,TMaintLoc,TMaintUser,TMaintMode,TAddUser,TUpdateUser,TModelDR,TModel)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintAlert
	s (TRowID,TName,TEquipDR,TCycleNum,TCycleUnitDR,TMaintTypeDR,TPreMaintDate,TNextMaintDate,TPreWarnDaysNum,TMaintFee,TMaintLocDR,TMaintUserDR,TMaintModeDR,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TEquip,TCycleUnit,TMaintType,TMaintLoc,TMaintUser,TMaintMode,TAddUser,TUpdateUser,TModelDR,TModel)=""
	quit
}

ClassMethod GetMaintAlertFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintAlertExecute ]
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

ClassMethod GetMaintAlertClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintAlertExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetStatus(MaintPlanDR As %Library.String)
{
	i MaintPlanDR="" q ""
	q $p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",14)
}

ClassMethod GetFeeType(itmjs As %Library.String = "", itmjsex As %Library.String = "", MaintModeDR)
{
	i MaintModeDR="" q ""
	q $p($g(^DHCEQCCode("DHCEQCMaintMode",MaintModeDR)),"^",4)
}

ClassMethod GetMaintMode(MaintPlanDR)
{
	i MaintPlanDR="" q ""
	q $p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",12)
}

}
