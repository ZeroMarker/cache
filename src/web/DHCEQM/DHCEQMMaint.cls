Class web.DHCEQM.DHCEQMMaint Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 90;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MT_RowID";

Parameter SQLDESCRIPTION = "MT_RowID";

Parameter SQLROWID = "MT_RowID";

ClassMethod SubmitMaint(itmjs As %Library.String = "", itmjsex As %Library.String = "", IRowID As %Library.String, IStatus As %Library.String, MaintPlanDR As %Library.String, MaintDate As %Library.String, User As %Library.String)
{
	Tstart
	i MaintPlanDR'=""{
		s PlanCycleNum=$P(^DHCEQMMaintPlan(MaintPlanDR),"^",7)
		s PlanCycleDR=$p(^DHCEQMMaintPlan(MaintPlanDR),"^",8)
		i PlanCycleDR'="" s PlanCycleType=$p(^DHCEQCCode("DHCEQCCycleUnit",PlanCycleDR),"^",4)
		s PlanCycleType=$CASE(PlanCycleType,"1":"yyyy","2":"m","3":"d")
		s NextMaintDate=##Class(web.DHCEQCommon).DateAdd(PlanCycleType,PlanCycleNum,MaintDate)
		;s MaintDate=$ZDH(MaintDate,4)
		;s NextMaintDate=$ZDH(NextMaintDate,4)
		;日期格式统一调整
		s MaintDate=##Class(web.DHCEQCommon).TransValueFromPage(MaintDate,"date")
		s NextMaintDate=##Class(web.DHCEQCommon).TransValueFromPage(NextMaintDate,"date")
		;&sql(Update sqluser.DHC_EQMaintPlan set MP_PreMaintDate=:MaintDate,MP_NextMaintDate=:NextMaintDate where MP_RowID=:MaintPlanDR)
		;i SQLCODE
		;{
		;	TROLLBACK
		;	q SQLCODE
		;}
		}
	s SMDate=+$h
	s SMTime=$p($h,",",2)
	s Fee=$p($G(^DHCEQMMaint(IRowID)),"^",9)
	i (Fee'="")&&(Fee'=0)
	{
		s SQLCODE=..GetValue(User, SMDate, SMTime, IRowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	/*********************************************************/ //2009-08-04 党军 begin
	s LI(2)=$p($g(^DHCEQMMaint(IRowID)),"^",1)  //设备
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
	.s MaintType=$p($g(^DHCEQMMaint(IRowID)),"^",4) //保养类型
	i MaintType'="" s LI(14)=$p($g(^DHCEQCCode("DHCEQMCMaintType",MaintType)),"^",2)  //变动原因
	s LI(15)=$p($g(^DHCEQMMaint(IRowID)),"^",14)  //变动描述
	s LI(16)=SMDate	//变动日期
	s LI(17)=SMTime	//变动时间
	s LI(18)=$p($g(^DHCEQMMaint(IRowID)),"^",24)  //费用
	s LI(19)="P"	//生命周期类型
	s LI(20)=32	//来源类型
	s LI(21)=IRowID	//来源ID
	s LI(23)=$p($g(^DHCEQMMaint(IRowID)),"^",14)  //备注
	s LI(27)=User	//更新人
	s LI(28)=SMDate	//更新日期
	s LI(29)=SMTime	//更新时间
	&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	i SQLCODE <0
	{
		TRollBack
		q SQLCODE
	}
	/*********************************************************/ //2009-08-04 党军 end
	&sql(Update sqluser.DHC_EQMaint set MT_Status=:IStatus,MT_SubmitUserDR=:User,MT_SubmitDate=:SMDate,MT_SubmitTime=:SMTime  where MT_RowID=:IRowID)
	i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	Tcommit
	q SQLCODE
}

ClassMethod UpdateMaint(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String)
{
	k PLIST,IRowID
	s IRowID=$p(val,"^",1)
	s PLIST(1) = $p(val,"^",1)	;RowID
	s PLIST(2) = $p(val,"^",2)	;EquipDR
	s PLIST(3) = $p(val,"^",3)	;MaintRequestDR
	s PLIST(4) = $p(val,"^",4)	;MaintPlanDR
	s PLIST(5) = $p(val,"^",5)	;MaintTypeDR
	s PLIST(6) = $p(val,"^",6)	;MaintDate
	i $p(val,"^",6)'=""  s PLIST(6) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"date")	;MaintDate
	s PLIST(7) = $p(val,"^",7)	;MaintLocDR
	s PLIST(8) = $p(val,"^",8)	;MaintUserDR
	s PLIST(9) = $p(val,"^",9)	;MaintModeDR
	i IRowID'=""
	{
		s PLIST(10)=..GetTotalFee(IRowID,1)+$P(val,"^",17)
	}
	else
	{
		s PLIST(10) = +$p(val,"^",17)	;Total = OtherFee
	}
	s PLIST(11) = $p(val,"^",11)	;InputFlag
	i PLIST(11) = "" s PLIST(11) = "Y"
	//i $p(val,"^",11)'=""  s PLIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"bool")	;InputFlag
	s PLIST(12) = $p(val,"^",12)	;ManageLocDR
	s PLIST(13) = $p(val,"^",13)	;UseLocDR
	s PLIST(14) = $p(val,"^",14)	;Status
	i PLIST(14) = "" s PLIST(14)=0
	s PLIST(15) = $p(val,"^",15)	;Remark
	s PLIST(25) = +$p(val,"^",17)   ;OtherFee
	/*s PLIST(16) = $p(val,"^",16)	;AddUserDR
	s PLIST(17) = $p(val,"^",17)	;AddDate
	i $p(val,"^",17)'=""  s PLIST(17) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",17),"date")	;AddDate
	s PLIST(18) = $p(val,"^",18)	;AddTime
	s PLIST(19) = $p(val,"^",19)	;UpdateUserDR
	s PLIST(20) = $p(val,"^",20)	;UpdateDate
	i $p(val,"^",20)'=""  s PLIST(20) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",20),"date")	;UpdateDate
	s PLIST(21) = $p(val,"^",21)	;UpdateTime
	s PLIST(22) = $p(val,"^",22)	;SubmitUserDR
	s PLIST(23) = $p(val,"^",23)	;SubmitDate
	i $p(val,"^",23)'=""  s PLIST(23) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",23),"date")	;SubmitDate
	s PLIST(24) = $p(val,"^",24)	;SubmitTime*/
	k PLIST(1)
	If IRowID'="" {
		i $p(val,"^",16)'=""  s PLIST(19) = $p(val,"^",16)
		s PLIST(20)=+$H
		s PLIST(21)=$P($H,",",2)
		&sql(Update sqluser.DHC_EQMMaint Values :PLIST() where MT_RowID=:IRowID)
		set return=SQLCODE
		i SQLCODE'=0 TROLLBACK
		q return_"^"_IRowID
	}
	Else {
		i $p(val,"^",16)'=""  s PLIST(16) = $p(val,"^",16)
		s PLIST(17)=+$H
		s PLIST(18)=$P($H,",",2)
		&sql(Insert Into SQLUser.DHC_EQMMaint Values :PLIST())
		set return=SQLCODE
		i SQLCODE'=0 TROLLBACK
		s IRowID=$G(%ROWID)
		q return_"^"_IRowID
	}
}

ClassMethod GetTotalFee(RowID, Type)
{
	//Type=1 返回配件金额
	//Type=2 返回配件金额+其他金额
	s (OtherFee,PartFee)=0
	s OtherFee=$P($G(^DHCEQMMaint(RowID)),"^",24)
	i OtherFee="" s OtherFee=0
	&sql(select sum(MTP_TotalFee) into :PartFee from sqluser.DHC_EQMaintPart where MTP_MaintDR=:RowID and MTP_FeeFlag='Y')
	i PartFee="" s PartFee=0
	i Type=2 q OtherFee+PartFee
	i Type=1 q PartFee
}

ClassMethod DeleteMaint(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String)
{
	TSTART
	s return=0
	&sql(Delete from sqluser.DHC_EQMMaintItem where MTI_MaintDR=:RowID)
	s return=SQLCODE
	i SQLCODE<0 
	{
		TROLLBACK
		q return
	}
	&sql(Delete from sqluser.DHC_EQMMaintPart where MTP_MaintDR=:RowID)
	s return=SQLCODE
	i SQLCODE<0 
	{
		TROLLBACK
		q return
	} 
	&sql(Delete from sqluser.DHC_EQMMaint where MT_RowID=:RowID)
	s return=SQLCODE
	i SQLCODE'=0 
	{
		TROLLBACK
		q return
	}
	TCOMMIT
	q return
}

ClassMethod InsertLifeFee(i, val)
{
	//i=3保养，i=4检查,27=维修，由于表结构改变i现在无用了
	k PUP
	s PUP(2)=$P(val,"^",1) //EquipDR
	s PUP(3)=$P(val,"^",2) //MaintDR,InsepectDR
	s PUP(4)="" //$P(val,"^",3) //CostallotDR
	s PUP(5)=$P(val,"^",4) //UseFee
	i (PUP(5)=0||PUP(5)="") q 0 //如果费用为0，退出
	s PUP(6)=$P(val,"^",5) //FeeDate
	s PUP(7)=$P(val,"^",6) //UseLocDR
	s PUP(8)=$P(val,"^",7) //ManageLocDR
	s PUP(9)=$P(val,"^",8) //FeeTypeDR	
	s PUP(13)="N" //InputFlag
	s PUP(15)=$P(val,"^",9) //AddUser
	s PUP(16)=$P(val,"^",10) //AddDate
	s PUP(17)=$P(val,"^",11) //AddTime
	s PUP(14)=$P(val,"^",12) //Remark
	s PUP(18)=PUP(15) //UpdateUser
	s PUP(19)=PUP(16) //UpdateDate
	s PUP(20)=PUP(17) //UpdateTime
	s PUP(21)=PUP(15) //AduitUser
	s PUP(22)=PUP(16) //AduitDate
	s PUP(23)=PUP(17) //AduitTime
	&sql(insert into sqluser.DHC_EQLifeFee values :PUP())
	q SQLCODE
}

ClassMethod GetValue(User, Date, Time, MaintDR)
{
	s val=""
	s val=val_$p($G(^DHCEQMMaint(MaintDR)),"^",1)_"^" //EquipDR 1
	s val=val_MaintDR_"^" //MaintDR 2
	s val=val_""_"^" //CostallotDR 3
	s val=val_$p($G(^DHCEQMMaint(MaintDR)),"^",9)_"^" //UseFee 4
	s val=val_$p($G(^DHCEQMMaint(MaintDR)),"^",5)_"^" //FeeDate 5
	s val=val_$p($G(^DHCEQMMaint(MaintDR)),"^",12)_"^" //UseLocDR 6
	s val=val_$p($G(^DHCEQMMaint(MaintDR)),"^",11)_"^" //ManageLocDR 7
	s val=val_..GetFeeType(4)_"^" //FeeTypeDR 8
	s val=val_User_"^" //user 9
	s val=val_Date_"^" //Date 10
	s val=val_Time_"^" //Time 11
	s val=val_"保养记录产生费用" //Remark 12
	s Return=..InsertLifeFee(3,val)
	q Return
}

ClassMethod GetFeeType(Type)
{
	q $o(^DHCEQCCode("DHCEQCFeeMode",0,"FMType",Type,0))
}

ClassMethod GetOneMaint(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQMaint(rowid)
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;MaintRequestDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQMMaintRequest($p(result,"^",2))),"^",1)
	s resultex=resultex_"^"	;MaintPlanDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQMMaintPlan($p(result,"^",3))),"^",1)
	s resultex=resultex_"^"	;MaintTypeDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCMaintType",$p(result,"^",4))),"^",2)
	s $p(result,"^",5)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")	;MaintDate
	s resultex=resultex_"^"	;MaintLocDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",6))
	s resultex=resultex_"^"	;MaintUserDR
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",7))
	s resultex=resultex_"^"	;MaintModeDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCMaintMode",$p(result,"^",8))),"^",2)
	s $p(result,"^",10)=$p(result,"^",10) //##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"bool")	;InputFlag
	s resultex=resultex_"^"	;ManageLocDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",11))
	s resultex=resultex_"^"	;UseLocDR
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",12))
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",15))
	s $p(result,"^",16)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",16),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",18))
	s $p(result,"^",19)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",19),"date")	;UpdateDate
	s resultex=resultex_"^"	;SubmitUserDR
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",21))
	s $p(result,"^",22)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",22),"date")	;SubmitDate
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetMaint(ModelDR, EquipDR, MaintLocDR, MaintUserDR, MaintTypeDR, StartDate, EndDate, QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TMaintRequestDR:%String,TMaintPlanDR:%String,TMaintTypeDR:%String,TMaintDate:%String,TMaintLocDR:%String,TMaintUserDR:%String,TMaintModeDR:%String,TTotal:%String,TInputFlag:%String,TManageLocDR:%String,TUseLocDR:%String,TStatus:%String,TRemark:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TEquip:%String,TMaintRequest:%String,TMaintPlan:%String,TMaintType:%String,TMaintLoc:%String,TMaintUser:%String,TMaintMode:%String,TManageLoc:%String,TUseLoc:%String,TAddUser:%String,TUpdateUser:%String,TSubmitUser:%String,TModel:%String,TOtherFee:%String")
{
}

//ModelDR

ClassMethod GetMaintExecute(ByRef qHandle As %Binary, ModelDR, EquipDR, MaintLocDR, MaintUserDR, MaintTypeDR, StartDate, EndDate, QXType As %String = "") As %Status
{
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetMaint
	Quit $$$OK
BuildDataGetMaint
	f  s rowid=$o(^DHCEQMMaint(rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaint
	.s TRowID = rowid
	.q:(ModelDR="")&&(EquipDR="")&&(MaintLocDR="")&&(MaintUserDR="")&&(MaintTypeDR="")&&(StartDate="")&&(EndDate="")
	.s TEquipDR = $p($g(^DHCEQMMaint(rowid)),"^",1)
	.q:(TEquipDR '= EquipDR)&(EquipDR '= "")
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TModelDR = $p($g(^DHCEQEquip(TEquipDR)),"^",3)
	..i TModelDR '= "" d
	...s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.//q:(TEquip '[ Equip)&(Equip '= "")
	.q:(TModelDR '= ModelDR)&(ModelDR '= "")
	.s TMaintRequestDR = $p($g(^DHCEQMMaint(rowid)),"^",2)
	.q:$L(TMaintRequestDR)>0
	.i TMaintRequestDR '=""  d
	..s TMaintRequest = $p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",36)
	..s TMaintRequest = $CASE(+TMaintRequest,0:"新增",1:"提交",2:"分配",3:"受理",4:"解决")
	.s TMaintPlanDR = $p($g(^DHCEQMMaint(rowid)),"^",3)
	.i TMaintPlanDR '=""  d
	..s TMaintPlan = $p($g(^DHCEQMMaintPlan(TMaintPlanDR)),"^",1)
	.s TMaintTypeDR = $p($g(^DHCEQMMaint(rowid)),"^",4)
	.q:(TMaintTypeDR '= MaintTypeDR)&(MaintTypeDR '= "")
	.i TMaintTypeDR '=""  d
	..s TMaintType = $p($g(^DHCEQCCode("DHCEQMCMaintType",TMaintTypeDR)),"^",2)
	.s TMaintDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMMaint(rowid)),"^",5),"date")
	.q:($p($g(^DHCEQMMaint(rowid)),"^",5)<StartDate)!($p($g(^DHCEQMMaint(rowid)),"^",5)>EndDate)
	.s TMaintLocDR = $p($g(^DHCEQMMaint(rowid)),"^",6)
	.q:(TMaintLocDR '= MaintLocDR)&(MaintLocDR '= "")
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TMaintLocDR))) //2010-10-28 DJ
	.i TMaintLocDR '=""  d
	..s TMaintLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TMaintLocDR)
	.s TMaintUserDR = $p($g(^DHCEQMMaint(rowid)),"^",7)
	.q:(TMaintUserDR '= MaintUserDR)&(MaintUserDR '= "")
	.i TMaintUserDR '=""  d
	..s TMaintUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUserDR)
	.s TMaintModeDR = $p($g(^DHCEQMMaint(rowid)),"^",8)
	.i TMaintModeDR '=""  d
	..s TMaintMode = $p($g(^DHCEQCCode("DHCEQMCMaintMode",TMaintModeDR)),"^",2)
	.s TTotal = $p($g(^DHCEQMMaint(rowid)),"^",9)
	.s TInputFlag = $p($g(^DHCEQMMaint(rowid)),"^",10)
	.s TManageLocDR = $p($g(^DHCEQMMaint(rowid)),"^",11)
	.i TManageLocDR '=""  d
	..s TManageLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	.s TUseLocDR = $p($g(^DHCEQMMaint(rowid)),"^",12)
	.i TUseLocDR '=""  d
	..s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.s TStatus = $p($g(^DHCEQMMaint(rowid)),"^",13)
	.s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.//i TStatus = "0" s TStatus="新增"
	.//i TStatus = "1" s TStatus="提交"
	.s TRemark = $p($g(^DHCEQMMaint(rowid)),"^",14)
	.s TAddUserDR = $p($g(^DHCEQMMaint(rowid)),"^",15)
	.i TAddUserDR '=""  d
	..s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMMaint(rowid)),"^",16),"date")
	.s TAddTime = $p($g(^DHCEQMMaint(rowid)),"^",17)
	.s TUpdateUserDR = $p($g(^DHCEQMMaint(rowid)),"^",18)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMMaint(rowid)),"^",19),"date")
	.s TUpdateTime = $p($g(^DHCEQMMaint(rowid)),"^",20)
	.s TSubmitUserDR = $p($g(^DHCEQMMaint(rowid)),"^",21)
	.i TSubmitUserDR '=""  d
	..s TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	.s TSubmitDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMMaint(rowid)),"^",22),"date")
	.s TSubmitTime = $p($g(^DHCEQMMaint(rowid)),"^",23)
	.s TOtherFee=$p($g(^DHCEQMMaint(rowid)),"^",24)
	.d OutputRowGetMaint
	quit
OutputRowGetMaint
	s Data=$lb(TRowID,TEquipDR,TMaintRequestDR,TMaintPlanDR,TMaintTypeDR,TMaintDate,TMaintLocDR,TMaintUserDR,TMaintModeDR,TTotal,TInputFlag,TManageLocDR,TUseLocDR,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TEquip,TMaintRequest,TMaintPlan,TMaintType,TMaintLoc,TMaintUser,TMaintMode,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TModel,TOtherFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaint
	s (TRowID,TEquipDR,TMaintRequestDR,TMaintPlanDR,TMaintTypeDR,TMaintDate,TMaintLocDR,TMaintUserDR,TMaintModeDR,TTotal,TInputFlag,TManageLocDR,TUseLocDR,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TEquip,TMaintRequest,TMaintPlan,TMaintType,TMaintLoc,TMaintUser,TMaintMode,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TModel,TOtherFee)=""
	quit
}

ClassMethod GetMaintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintExecute ]
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

ClassMethod GetMaintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetStatus(MaintDR As %Library.String)
{
	i MaintDR="" q ""
	q $p($g(^DHCEQMMaint(MaintDR)),"^",13)
}

ClassMethod GetMaintMode(MaintDR)
{
	i MaintDR="" q ""
	q $p($g(^DHCEQMMaint(MaintDR)),"^",8)
}

}
