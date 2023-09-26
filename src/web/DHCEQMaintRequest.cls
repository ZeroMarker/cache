/// 已停用，启用新的维修模块 20150902 JDL After V4.0.0
/// ---------------------------------------------------------
/// 修改:党军 2010-03-04 DJ0038
/// 描述:故障原因,故障现象,故障解决方法自动增加
/// ---------------------------------------------------------
Class web.DHCEQMaintRequest Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 82;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter GlobalLen = 41;

Parameter SQLCODE = "MR_RowID";

Parameter SQLDESCRIPTION = "MR_RowID";

Parameter SQLROWID = "MR_RowID";

ClassMethod UpdateMaintRequest(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String, Flag As %Library.String)
{
	//Flag=0 新增，更新
	//Flag=1 分配
	//Flag=2 受理
	//Flag=3 解决
	k PLIST,IRowID
	s IRowID=$p(val,"^",1)
	s PLIST(1) = $p(val,"^",1)	;RowID
 	s PLIST(2) = $p(val,"^",2)	;EquipDR
 	s PLIST(3) = $p(val,"^",3)	;RequestLocDR
 	s PLIST(4) = $p(val,"^",4)	;FaultCaseDR
 	s PLIST(5) = $p(val,"^",5)	;FaultCaseRemark
 	s PLIST(6) = $p(val,"^",6)	;FaultReasonDR
 	s PLIST(7) = $p(val,"^",7)	;FaultReasonRemark
 	s PLIST(8) = $p(val,"^",8)	;DealMethodDR
 	s PLIST(9) = $p(val,"^",9)	;DealMethodRemark
 	s PLIST(10) = $p(val,"^",10)	;StartDate
 	i $p(val,"^",10)'=""  s PLIST(10) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"date")	;StartDate
 	s PLIST(11) = $p(val,"^",11)	;StartTime
 	s PLIST(12) = $p(val,"^",12)	;EndDate
 	i $p(val,"^",12)'=""  s PLIST(12) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",12),"date")	;EndDate
 	s PLIST(13) = $p(val,"^",13)	;EndTime
 	s PLIST(14) = $p(val,"^",14)	;RequestDate
 	i $p(val,"^",14)'=""  s PLIST(14) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",14),"date")	;RequestDate
 	s PLIST(15) = $p(val,"^",15)	;RequestTime
 	s PLIST(16) = $p(val,"^",16)	;FaultTypeDR
 	s PLIST(17) = $p(val,"^",17)	;AcceptDate
 	i $p(val,"^",17)'=""  s PLIST(17) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",17),"date")	;AcceptDate
 	s PLIST(18) = $p(val,"^",18)	;AcceptTime
 	s PLIST(19) = $p(val,"^",19)	;AcceptUserDR
 	//s PLIST(20) = $p(val,"^",20)	;AssignDR
 	s PLIST(21) = $p(val,"^",21)	;MaintModeDR
 	s PLIST(22) = $p(val,"^",22)	;PayedMaintFlag
 	i $p(val,"^",22)'=""  s PLIST(22) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",22),"bool")	;PayedMaintFlag
 	s PLIST(23) = ..GetTotalFee(IRowID,1)+$P(val,"^",35) ;$p(val,"^",23)	;MaintFee
 	s PLIST(24) = $p(val,"^",24)	;UserSignDR
 	s PLIST(25) = $p(val,"^",25)	;UserOpinion
 	s PLIST(26) = $p(val,"^",26)	;ManageLocDR
 	s PLIST(27) = $p(val,"^",27)	;UseLocDR
 	s PLIST(28) = $p(val,"^",28)	;IsInputFlag
 	//i $p(val,"^",28)'=""  s PLIST(28) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",28),"bool")	;IsInputFlag
 	s PLIST(29) = $p(val,"^",29)	;Remark
 	s PLIST(30) = $p(val,"^",30)	;Status
 	s PLIST(40) = $p(val,"^",32)	;MaintLocDR
 	s PLIST(41) = $p(val,"^",33)	;MaintRemark
 	s PLIST(42) = $p(val,"^",34)	;MaintDept
 	s PLIST(43) = +$P(val,"^",35)   ;OtherFee
 	s PLIST(44) = $P(val,"^",36)    ;RequestNO
 	/*
 	s PLIST(31) = $p(val,"^",31)	;AddUserDR
 	s PLIST(32) = $p(val,"^",32)	;AddDate
 	i $p(val,"^",32)'=""  s PLIST(32) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",32),"date")	;AddDate
 	s PLIST(33) = $p(val,"^",33)	;AddTime
 	s PLIST(34) = $p(val,"^",34)	;UpdateUserDR
 	s PLIST(35) = $p(val,"^",35)	;UpdateDate
 	i $p(val,"^",35)'=""  s PLIST(35) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",35),"date")	;UpdateDate
 	s PLIST(36) = $p(val,"^",36)	;UpdateTime
 	s PLIST(37) = $p(val,"^",37)	;SubmitUserDR
 	s PLIST(38) = $p(val,"^",38)	;SubmitDate
 	i $p(val,"^",38)'=""  s PLIST(38) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",38),"date")	;SubmitDate
 	s PLIST(39) = $p(val,"^",39)	;SubmitTime*/
 	//2010-03-06 党军 begin
 	s FaultCase=$P(val,"^",37)	;FaultCase
 	s FaultReason=$P(val,"^",38)	;FaultReason
 	s DealMethod=$P(val,"^",39)	;DealMethod
 	//2010-03-06 党军 end
	k PLIST(1)
	TSTART //2010-03-06 党军 begin
	s SQLCODE=0
	i ($p(val,"^",4)="")&&($P(val,"^",37)'="") s PLIST(4)=..UpdateFaultCase(FaultCase)
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE_"^"
	}
	i ($p(val,"^",6)="")&&($P(val,"^",38)'="") s PLIST(6)=..UpdateFaultReason(FaultReason)
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE_"^"
	}
	i ($p(val,"^",8)="")&&($P(val,"^",39)'="") s PLIST(8)=..UpdateDealMethod(DealMethod)
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE_"^"
	}
	//2010-03-06 党军 end
 If +Flag=0 {
	If IRowID'="" {
		i $p(val,"^",31)'=""  s PLIST(34) = $p(val,"^",31)
		s PLIST(35)=+$H
		s PLIST(36)=$P($H,",",2)
		&sql(Update sqluser.DHC_EQMaintRequest Values :PLIST() where MR_RowID=:IRowID)
		set return=SQLCODE
		i SQLCODE'=0
		{
			TROLLBACK
			q return_"^"_IRowID
		}
	}
	Else {
		i $p(val,"^",31)'=""  s PLIST(31) = $p(val,"^",31)
		s PLIST(32)=+$H
		s PLIST(33)=$P($H,",",2)
		i PLIST(44)="" s PLIST(44)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQMaintRequest",+$H)
		&sql(Insert Into SQLUser.DHC_EQMaintRequest Values :PLIST())
		set return=SQLCODE
		i SQLCODE'=0
		{
			TROLLBACK
			q return_"^" //2010-03-06 党军
		} 
		s IRowID=$G(%ROWID) //2010-03-06 党军
	}
 }
 If +Flag=1 {
	 i $p(val,"^",31)'=""  s PLIST(20) = $p(val,"^",31)
	 &sql(Update sqluser.DHC_EQMaintRequest Values :PLIST() where MR_RowID=:IRowID)
		set return=SQLCODE
		i SQLCODE'=0
		{
			TROLLBACK
			q return_"^"_IRowID
		}
 }
 //插入Maint记录
 If +Flag=2 {
	 s User=$p(val,"^",31)
	 s Date=+$H
	 s Time=$p($h,",",2)
	 
	 s PL(2)=PLIST(2) //EquipDR
	 s PL(3)=IRowID //MaintRequestDR
	 //s PL(5)=PLIST(21) //MaintType ?
	 s PL(6)=PLIST(17) //MaintDate
	 s PL(7)=PLIST(40) //MaintLoc ?
	 s PL(8)=PLIST(19) //MaintUser
	 s PL(9)=PLIST(21) //MaintMode
	 s PL(10)=..GetTotalFee(IRowID,1)+PLIST(43)   //PLIST(23) //Fee
	 s PL(11)="N" //InputFlag
	 s PL(12)=PLIST(26)  //ManageLoc
	 s PL(13)=PLIST(27)  //UseLoc
	 s PL(25)=PLIST(43)
	 s PL(14)=0
	 
	 s MaintDR=..GetOneMaintDR("","",IRowID)
	 //TStart
	 If MaintDR=""
	 {
		 s PL(16)=User //AddUser
		 s PL(17)=Date
	 	 s PL(18)=Time
	 	 &sql(Insert Into SQLUser.DHC_EQMaint Values :PL())
		set return=SQLCODE
		i SQLCODE'=0 {
			TROLLBACK
			q return_"^"_"21"}
	 }
	 else
	 {
		  s PL(19)=User //AddUser
		  s PL(20)=Date
	 	  s PL(21)=Time
		 &sql(Update sqluser.DHC_EQMaint Values :PL() where MT_RowID=:MaintDR)
		set return=SQLCODE
		i SQLCODE<0 {
			TROLLBACK
			q return_"^"_"22"}
	 }
	  &sql(Update sqluser.DHC_EQMaintRequest Values :PLIST() where MR_RowID=:IRowID)
		set return=SQLCODE
		i SQLCODE'=0 {
			TROLLBACK
			q return_"^"_"2"}
		//TCommit
		//q return_"^"_IRowID
 }
 //提交对应的Maint记录
 If +Flag=3 {
	 s User=$p(val,"^",31)
	 s Date=+$H
	 s Time=$p($h,",",2)
	 
	 s PL(2)=PLIST(2) //EquipDR
	 s PL(3)=IRowID //MaintRequestDR
	 //s PL(5)=PLIST(21) //MaintType ?
	 s PL(6)=PLIST(17) //MaintDate
	 s PL(7)=PLIST(40) //MaintLoc ?
	 s PL(8)=PLIST(19) //MaintUser
	 s PL(9)=PLIST(21) //MaintMode
	 s PL(10)=..GetTotalFee(IRowID,1)+PLIST(43)   //PLIST(23) //Fee
	 s PL(11)="N" //InputFlag
	 s PL(12)=PLIST(26)  //ManageLoc
	 s PL(13)=PLIST(27)  //UseLoc
	 s PL(25)=PLIST(43)
	 s PL(14)=1
	 s MaintDR=..GetOneMaintDR("","",IRowID)
	 
	 /***************************************************/  //2009-07-21 党军 begin
	 s LI(2)=PLIST(2)  //设备
	 i PLIST(2)'="" d
	 .s LI(9)=$p($g(^DHCEQEquip(PLIST(2))),"^",19)   //变动后使用科室
	 .s LI(10)=$p($g(^DHCEQEquip(PLIST(2))),"^",17) //变动后管理科室
	 .s LI(11)=$p($g(^DHCEQEquip(PLIST(2))),"^",67)  //变动后库房
	 .s LI(12)=$p($g(^DHCEQEquip(PLIST(2))),"^",27)  //变动后原值
	 .s LI(13)=$p($g(^DHCEQEquip(PLIST(2))),"^",28)  //变动后净值
	 i PLIST(4)'="" s LI(14)=$p($g(^DHCEQCCode("DHCEQCFaultCase",PLIST(4))),"^",2)  //变动原因
	 s LI(15)=PLIST(5)  //变动描述
	 s LI(16)=Date	//变动日期
	 s LI(17)=Time	//变动时间
	 s LI(18)=PLIST(23)  //费用
	 s LI(19)="P"	//生命周期类型 //2009-08-10 党军
	 s LI(20)=31	//来源类型
	 s LI(21)=IRowID	//来源ID
	 s LI(23)=PLIST(29)  //备注
	 s LI(27)=User	//更新人
	 s LI(28)=Date	//更新日期
	 s LI(29)=Time	//更新时间
	 /***************************************************/  //2009-07-21 党军 end
	 &sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI()) //2009-07-21 党军 begin
	 i SQLCODE <0
	 {
		 TRollBack
		 q SQLCODE
	 } //2009-07-21 党军 end
	  s PL(22)=User //AddUser
	  s PL(23)=Date
	  s PL(24)=Time
	 &sql(Update sqluser.DHC_EQMaint Values :PL() where MT_RowID=:MaintDR)
	 s return=SQLCODE
	 i SQLCODE<0 {
			TROLLBACK
			q return_"^"_"31"}
	s SQLCODE=..GetValue(User,Date,Time,IRowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_"33"
	}
	  &sql(Update sqluser.DHC_EQMaintRequest Values :PLIST() where MR_RowID=:IRowID)
		set return=SQLCODE
		i SQLCODE'=0 {
			TROLLBACK
			q return_"^"_"3"}
		//TCOMMIT
		//q return_"^"_IRowID
 }
 		TCOMMIT //2010-03-06 党军
		q return_"^"_IRowID //2010-03-06 党军
}

ClassMethod SetContrat(EquipDR)
{
	s Flag="0"
	s SignDate=0
	s MaxDate=0
	s StartDate=""
	s EndDate=""
	s rowid=0
	s MaxContractDR=0
	f  s rowid=$o(^DHCEQServiceContract(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
	.s ContractDR=$P(^DHCEQServiceContract(rowid),"^",2)
	.s SignDate=$P(^DHCEQContract(ContractDR),"^",7)
	.s Flag="1"
	.i SignDate>MaxDate d
	..s MaxContractDR=ContractDR
	..s MaxDate=SignDate
	i MaxContractDR>0 s StartDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(MaxContractDR)),"^",11),"date")
	i MaxContractDR>0 s EndDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(MaxContractDR)),"^",12),"date")
	q Flag_"^"_StartDate_"^"_EndDate
}

ClassMethod GetTotalFee(RowID, Type)
{
	s (OtherFee,PartFee)=0
	i RowID="" 
	{
		s OtherFee=0
	}
	else
	{
		s OtherFee=$P($G(^DHCEQMaintRequest(RowID)),"^",42)
	}
	i OtherFee="" s OtherFee=0
	s MaintDR=..GetOneMaintDR("","",RowID)
	i MaintDR=""
	{
		s PartFee=0
	}
	else
	{
		&sql(select sum(MTP_TotalFee) into :PartFee from sqluser.DHC_EQMaintPart where MTP_MaintDR=:MaintDR and MTP_FeeFlag='Y')
	}	
	i PartFee="" s PartFee=0
	i Type=2 q OtherFee+PartFee
	i Type=1 q PartFee
}

ClassMethod GetValue(User, Date, Time, MaintRequestDR)
{
	s val=""
	s val=val_$p($G(^DHCEQMaintRequest(MaintRequestDR)),"^",1)_"^" //EquipDR 1
	s val=val_MaintRequestDR_"^" //MaintRequestDR 2
	s val=val_""_"^" //CostallotDR 3
	s val=val_$p($G(^DHCEQMaintRequest(MaintRequestDR)),"^",22)_"^" //UseFee 4
	s val=val_$p($G(^DHCEQMaintRequest(MaintRequestDR)),"^",16)_"^" //FeeDate 5
	s val=val_$p($G(^DHCEQMaintRequest(MaintRequestDR)),"^",26)_"^" //UseLocDR 6
	s val=val_$p($G(^DHCEQMaintRequest(MaintRequestDR)),"^",25)_"^" //ManageLocDR 7
	s val=val_##class(web.DHCEQMaint).GetFeeType(3)_"^" //FeeTypeDR 8
	s val=val_User_"^" //user 9
	s val=val_Date_"^" //Date 10
	s val=val_Time_"^" //Time 11
	s val=val_"维修记录产生费用" //Remark 12	
	s Return=##class(web.DHCEQMaint).InsertLifeFee(27,val)
	q Return
}

/// w ##Class(web.DHCEQMaintRequest).GetOneMaintDR("","",)
ClassMethod GetOneMaintDR(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String)
{
	;new MTRowID
	;s MTRowID=""
	;&sql(Select MT_RowID into :MTRowID from sqluser.DHC_EqMaint where MT_MaintRequestDR=:RowID)
	;q MTRowID
	q ""
}

Query GetMaintRequest(Status, EquipDR, ModelDR, RequestLocDR, StartDate, EndDate) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TRequestLocDR:%String,TFaultCaseDR:%String,TFaultCaseRemark:%String,TFaultReasonDR:%String,TFaultReasonRemark:%String,TDealMethodDR:%String,TDealMethodRemark:%String,TStartDate:%String,TStartTime:%String,TEndDate:%String,TEndTime:%String,TRequestDate:%String,TRequestTime:%String,TFaultTypeDR:%String,TAcceptDate:%String,TAcceptTime:%String,TAcceptUserDR:%String,TAssignDR:%String,TMaintModeDR:%String,TPayedMaintFlag:%String,TMaintFee:%String,TUserSignDR:%String,TUserOpinion:%String,TManageLocDR:%String,TUseLocDR:%String,TIsInputFlag:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TEquip:%String,TRequestLoc:%String,TFaultCase:%String,TFaultReason:%String,TDealMethod:%String,TFaultType:%String,TAcceptUser:%String,TAssign:%String,TMaintMode:%String,TUserSign:%String,TManageLoc:%String,TUseLoc:%String,TAddUser:%String,TUpdateUser:%String,TSubmitUser:%String,TModel:%String,TMaintLocDR:%String,TMaintRemark:%String,TMaintDept:%String,TOtherFee:%String,TRequestNO:%String")
{
}

ClassMethod GetMaintRequestExecute(ByRef qHandle As %Binary, Status, EquipDR, ModelDR, RequestLocDR, StartDate, EndDate) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetMaintRequest
	Quit $$$OK
BuildDataGetMaintRequest
	f  s rowid=$o(^DHCEQMaintRequest(rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaintRequest
	.s TRowID = rowid
	.q:(ModelDR="")&&(EquipDR="")&&(Status="")&&(RequestLocDR="")&&(StartDate="")&&(EndDate="")
	.s TEquipDR = $p($g(^DHCEQMaintRequest(rowid)),"^",1)
	.q:(EquipDR'="")&&(TEquipDR'=EquipDR)
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TModelDR = $p($g(^DHCEQEquip(TEquipDR)),"^",3)
	..i TModelDR '= "" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.q:(ModelDR'="")&&(TModelDR'=ModelDR)
	.//q:(Equip'="")&&(TEquip'[Equip)
	.s TRequestLocDR = $p($g(^DHCEQMaintRequest(rowid)),"^",2)
	.q:(RequestLocDR'="")&&(TRequestLocDR'=RequestLocDR)
	.i TRequestLocDR '=""  d
	..s TRequestLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	.s TFaultCaseDR = $p($g(^DHCEQMaintRequest(rowid)),"^",3)
	.i TFaultCaseDR '=""  d
	..s TFaultCase = $p($g(^DHCEQCCode("DHCEQCFaultCase",TFaultCaseDR)),"^",2)
	.s TFaultCaseRemark = $p($g(^DHCEQMaintRequest(rowid)),"^",4)
	.s TFaultReasonDR = $p($g(^DHCEQMaintRequest(rowid)),"^",5)
	.i TFaultReasonDR '=""  d
	..s TFaultReason = $p($g(^DHCEQCCode("DHCEQCFaultReason",TFaultReasonDR)),"^",2)
	.s TFaultReasonRemark = $p($g(^DHCEQMaintRequest(rowid)),"^",6)
	.s TDealMethodDR = $p($g(^DHCEQMaintRequest(rowid)),"^",7)
	.i TDealMethodDR '=""  d
	..s TDealMethod = $p($g(^DHCEQCCode("DHCEQCDealMethod",TDealMethodDR)),"^",2)
	.s TDealMethodRemark = $p($g(^DHCEQMaintRequest(rowid)),"^",8)
	.s TStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintRequest(rowid)),"^",9),"date")
	.s TStartTime = $p($g(^DHCEQMaintRequest(rowid)),"^",10)
	.s TEndDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintRequest(rowid)),"^",11),"date")
	.s TEndTime = $p($g(^DHCEQMaintRequest(rowid)),"^",12)
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$h
	.q:($p($g(^DHCEQMaintRequest(rowid)),"^",13)<StartDate)!($p($g(^DHCEQMaintRequest(rowid)),"^",13)>EndDate)
	.s TRequestDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintRequest(rowid)),"^",13),"date")
	.s TRequestTime = $p($g(^DHCEQMaintRequest(rowid)),"^",14)
	.s TFaultTypeDR = $p($g(^DHCEQMaintRequest(rowid)),"^",15)
	.i TFaultTypeDR '=""  d
	..s TFaultType = $p($g(^DHCEQCCode("DHCEQCFaultType",TFaultTypeDR)),"^",2)
	.s TAcceptDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintRequest(rowid)),"^",16),"date")
	.s TAcceptTime = $p($g(^DHCEQMaintRequest(rowid)),"^",17)
	.s TAcceptUserDR = $p($g(^DHCEQMaintRequest(rowid)),"^",18)
	.i TAcceptUserDR '=""  d
	..s TAcceptUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAcceptUserDR)
	.s TAssignDR = $p($g(^DHCEQMaintRequest(rowid)),"^",19)
	.i TAssignDR '=""  d
	..s TAssign = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAssignDR)
	.s TMaintModeDR = $p($g(^DHCEQMaintRequest(rowid)),"^",20)
	.i TMaintModeDR '=""  d
	..s TMaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",TMaintModeDR)),"^",2)
	.s TPayedMaintFlag = $p($g(^DHCEQMaintRequest(rowid)),"^",21)
	.s TMaintFee = $p($g(^DHCEQMaintRequest(rowid)),"^",22)
	.s TUserSignDR = $p($g(^DHCEQMaintRequest(rowid)),"^",23)
	.i TUserSignDR '=""  d
	..s TUserSign = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUserSignDR)
	.s TUserOpinion = $p($g(^DHCEQMaintRequest(rowid)),"^",24)
	.s TManageLocDR = $p($g(^DHCEQMaintRequest(rowid)),"^",25)
	.i TManageLocDR '=""  d
	..s TManageLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	.s TUseLocDR = $p($g(^DHCEQMaintRequest(rowid)),"^",26)
	.i TUseLocDR '=""  d
	..s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.s TIsInputFlag = $p($g(^DHCEQMaintRequest(rowid)),"^",27)
	.s TRemark = $p($g(^DHCEQMaintRequest(rowid)),"^",28)
	.s TStatus = $p($g(^DHCEQMaintRequest(rowid)),"^",29)
	.s TStatus=..GetStatus(TStatus) 
	.//$CASE(TStatus,0:"新增",1:"提交",2:"分配",3:"受理",4:"解决")
	.q:(Status'="")&&(TStatus'[Status)
	.s TAddUserDR = $p($g(^DHCEQMaintRequest(rowid)),"^",30)
	.i TAddUserDR '=""  d
	..s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintRequest(rowid)),"^",31),"date")
	.s TAddTime = $p($g(^DHCEQMaintRequest(rowid)),"^",32)
	.s TUpdateUserDR = $p($g(^DHCEQMaintRequest(rowid)),"^",33)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintRequest(rowid)),"^",34),"date")
	.s TUpdateTime = $p($g(^DHCEQMaintRequest(rowid)),"^",35)
	.s TSubmitUserDR = $p($g(^DHCEQMaintRequest(rowid)),"^",36)
	.i TSubmitUserDR '=""  d
	..s TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	.s TSubmitDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintRequest(rowid)),"^",37),"date")
	.s TSubmitTime = $p($g(^DHCEQMaintRequest(rowid)),"^",38)
	.s TMaintLocDR = $p($g(^DHCEQMaintRequest(rowid)),"^",39)
	.s TMaintRemark = $p($g(^DHCEQMaintRequest(rowid)),"^",40)
	.s TMaintDept = $p($g(^DHCEQMaintRequest(rowid)),"^",41)
	.s TOtherFee=$p($g(^DHCEQMaintRequest(rowid)),"^",42)
	.s TRequestNO=$p($g(^DHCEQMaintRequest(rowid)),"^",43)
	.d OutputRowGetMaintRequest
	quit
OutputRowGetMaintRequest
	s Data=$lb(TRowID,TEquipDR,TRequestLocDR,TFaultCaseDR,TFaultCaseRemark,TFaultReasonDR,TFaultReasonRemark,TDealMethodDR,TDealMethodRemark,TStartDate,TStartTime,TEndDate,TEndTime,TRequestDate,TRequestTime,TFaultTypeDR,TAcceptDate,TAcceptTime,TAcceptUserDR,TAssignDR,TMaintModeDR,TPayedMaintFlag,TMaintFee,TUserSignDR,TUserOpinion,TManageLocDR,TUseLocDR,TIsInputFlag,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TEquip,TRequestLoc,TFaultCase,TFaultReason,TDealMethod,TFaultType,TAcceptUser,TAssign,TMaintMode,TUserSign,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TModel,TMaintLocDR,TMaintRemark,TMaintDept,TOtherFee,TRequestNO)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintRequest
	s (TRowID,TEquipDR,TRequestLocDR,TFaultCaseDR,TFaultCaseRemark,TFaultReasonDR,TFaultReasonRemark,TDealMethodDR,TDealMethodRemark,TStartDate,TStartTime,TEndDate,TEndTime,TRequestDate,TRequestTime,TFaultTypeDR,TAcceptDate,TAcceptTime,TAcceptUserDR,TAssignDR,TMaintModeDR,TPayedMaintFlag,TMaintFee,TUserSignDR,TUserOpinion,TManageLocDR,TUseLocDR,TIsInputFlag,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TEquip,TRequestLoc,TFaultCase,TFaultReason,TDealMethod,TFaultType,TAcceptUser,TAssign,TMaintMode,TUserSign,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TModel,TMaintLocDR,TMaintRemark,TMaintDept,TOtherFee,TRequestNO)=""
	quit
}

ClassMethod GetMaintRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintRequestExecute ]
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

ClassMethod GetMaintRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetStatu() As %Query(ROWSPEC = "Status:%String,Code:%String")
{
}

ClassMethod GetStatuClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatuExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetStatuExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)

	If $g(ind)="" Set ind=1
	Set rowid=0
	s Status="新增"
	s Code=0
	d OutputRow
	s Status="提交"
	s Code=1
	d OutputRow
	s Status="分配"
	s Code=2
	d OutputRow
	s Status="受理"
	s Code=3
	d OutputRow
	s Status="解决"
	s Code=4
	d OutputRow
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Status,Code) //顺序和query中的顺序一致
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	quit
}

ClassMethod DeleteMaintRequest(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String)
{
	TSTART
	&sql(Delete from sqluser.DHC_EQMaintRequest where MR_RowID=:RowID)
	s return=SQLCODE
	i SQLCODE'=0 
	{
		TROLLBACK
		q return
	}
	TCOMMIT
	q return
}

ClassMethod SubmitMaintRequest(itmjs As %Library.String = "", itmjsex As %Library.String = "", IRowID As %Library.String, IStatus As %Library.String, User As %Library.String)
{
	Tstart
	s SMDate=+$h
	s SMTime=$p($h,",",2)
	&sql(Update sqluser.DHC_EQMaintRequest set MR_Status=:IStatus,MR_SubmitUserDR=:User,MR_SubmitDate=:SMDate,MR_SubmitTime=:SMTime  where MR_RowID=:IRowID)
	s return=SQLCODE
	i SQLCODE'=0 TROLLBACK
	Tcommit
	q return
}

ClassMethod GetStatuFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatuExecute ]
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

ClassMethod GetOneMaintRequest(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQMaintRequest(rowid)
	set count=..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;RequestLocDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	s resultex=resultex_"^"	;FaultCaseDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFaultCase",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;FaultReasonDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFaultReason",$p(result,"^",5))),"^",2)
	s resultex=resultex_"^"	;DealMethodDR
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDealMethod",$p(result,"^",7))),"^",2)
	s $p(result,"^",9)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;StartDate
	s $p(result,"^",11)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;EndDate
	s $p(result,"^",13)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"date")	;RequestDate
	s resultex=resultex_"^"	;FaultTypeDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFaultType",$p(result,"^",15))),"^",2)
	s $p(result,"^",16)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",16),"date")	;AcceptDate
	s resultex=resultex_"^"	;AcceptUserDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",18))
	s resultex=resultex_"^"	;AssignDR
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",19))
	s resultex=resultex_"^"	;MaintModeDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintMode",$p(result,"^",20))),"^",2)
	s $p(result,"^",21)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",21),"bool")	;PayedMaintFlag
	s resultex=resultex_"^"	;UserSignDR
	i $p(result,"^",23)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",23))
	s resultex=resultex_"^"	;ManageLocDR
	i $p(result,"^",25)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",25))
	s resultex=resultex_"^"	;UseLocDR
	i $p(result,"^",26)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",26))
	s $p(result,"^",27)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",27),"bool")	;IsInputFlag
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",30)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",30))
	s $p(result,"^",31)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",31),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",33)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",33))
	s $p(result,"^",34)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",34),"date")	;UpdateDate
	s resultex=resultex_"^"	;SubmitUserDR
	i $p(result,"^",36)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",36))
	s $p(result,"^",37)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",37),"date")	;SubmitDate
	s result=##Class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

ClassMethod GetMaintRequest(MaintDR)
{
	s MaintRequestDR=""
	i MaintDR="" q MaintRequestDR
	;&sql(select MT_MaintRequestDR into :MaintRequestDR from sqluser.DHC_EQMaint where MT_RowID=:MaintDR)
	q MaintRequestDR
}

ClassMethod GetMaintFee(itmjs As %Library.String = "", itmjsex As %Library.String = "", ArgList, ArgDR)
{
	if ArgList="1"{ //MaintPlan ArgDR=MaintPlanDR
		s MaintModeDR=##class(web.DHCEQMaintPlan).GetMaintMode(ArgDR)
		s FeeType=##class(web.DHCEQMaintPlan).GetFeeType("","",MaintModeDR)
		s MaintFee=$p($g(^DHCEQMaintPlan(ArgDR)),"^",9)
		q FeeType_"^"_MaintFee
	}
	if ArgList="2"{ //Maint ArgDR=MaintDR
		s MaintModeDR=##class(web.DHCEQMaint).GetMaintMode(ArgDR)
		s FeeType=##class(web.DHCEQMaintPlan).GetFeeType("","",MaintModeDR)
		s MaintFee=$p($g(^DHCEQMaint(ArgDR)),"^",9)
		q FeeType_"^"_MaintFee
	}
	if ArgList="3"{ //MaintRequest ArgDR=MaintDR
		s MaintRequestDR=..GetMaintRequest(ArgDR)
		s MaintModeDR=$p($g(^DHCEQMaintRequest(MaintRequestDR)),"^",20)
		s FeeType=##class(web.DHCEQMaintPlan).GetFeeType("","",MaintModeDR)
		s MaintFee=$p($g(^DHCEQMaintRequest(MaintRequestDR)),"^",22)
		q FeeType_"^"_MaintFee
	}
}

Query TroubleAnalyze(StartDate, EndDate, FaultCaseDR, FaultReasonDR, DealMethodDR) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TRequestLocDR:%String,TFaultCaseDR:%String,TFaultCaseRemark:%String,TFaultReasonDR:%String,TFaultReasonRemark:%String,TDealMethodDR:%String,TDealMethodRemark:%String,TStartDate:%String,TStartTime:%String,TEndDate:%String,TEndTime:%String,TRequestDate:%String,TRequestTime:%String,TFaultTypeDR:%String,TAcceptDate:%String,TAcceptTime:%String,TAcceptUserDR:%String,TAssignDR:%String,TMaintModeDR:%String,TPayedMaintFlag:%String,TMaintFee:%String,TUserSignDR:%String,TUserOpinion:%String,TManageLocDR:%String,TUseLocDR:%String,TIsInputFlag:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TEquip:%String,TRequestLoc:%String,TFaultCase:%String,TFaultReason:%String,TDealMethod:%String,TFaultType:%String,TAcceptUser:%String,TAssign:%String,TMaintMode:%String,TUserSign:%String,TManageLoc:%String,TUseLoc:%String,TAddUser:%String,TUpdateUser:%String,TSubmitUser:%String,TModel:%String,TMaintLocDR:%String,TMaintRemark:%String,TMaintDept:%String")
{
}

ClassMethod TroubleAnalyzeExecute(ByRef qHandle As %Binary, StartDate, EndDate, FaultCaseDR, FaultReasonDR, DealMethodDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataTroubleAnalyze
	Quit $$$OK
BuildDataTroubleAnalyze
	f  s rowid=$o(^DHCEQMaintRequest(rowid))  quit:rowid=""  d
	.d ResetVariablesTroubleAnalyze
	.s TRowID = rowid
	.s TEquipDR = $p($g(^DHCEQMaintRequest(rowid)),"^",1)
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TModelDR = $p($g(^DHCEQEquip(TEquipDR)),"^",3)
	..i TModelDR '= "" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TRequestLocDR = $p($g(^DHCEQMaintRequest(rowid)),"^",2)
	.i TRequestLocDR '=""  d
	..s TRequestLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	.s TFaultCaseDR = $p($g(^DHCEQMaintRequest(rowid)),"^",3)
	.q:(FaultCaseDR'="")&&(FaultCaseDR'=TFaultCaseDR)
	.i TFaultCaseDR '=""  d
	..s TFaultCase = $p($g(^DHCEQCCode("DHCEQCFaultCase",TFaultCaseDR)),"^",2)
	.s TFaultCaseRemark = $p($g(^DHCEQMaintRequest(rowid)),"^",4)
	.s TFaultReasonDR = $p($g(^DHCEQMaintRequest(rowid)),"^",5)
	.q:(FaultReasonDR'="")&&(FaultReasonDR'=TFaultReasonDR)
	.i TFaultReasonDR '=""  d
	..s TFaultReason = $p($g(^DHCEQCCode("DHCEQCFaultReason",TFaultReasonDR)),"^",2)
	.s TFaultReasonRemark = $p($g(^DHCEQMaintRequest(rowid)),"^",6)
	.s TDealMethodDR = $p($g(^DHCEQMaintRequest(rowid)),"^",7)
	.q:(DealMethodDR'="")&&(DealMethodDR'=TDealMethodDR)
	.i TDealMethodDR '=""  d
	..s TDealMethod = $p($g(^DHCEQCCode("DHCEQCDealMethod",TDealMethodDR)),"^",2)
	.s TDealMethodRemark = $p($g(^DHCEQMaintRequest(rowid)),"^",8)
	.s TStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintRequest(rowid)),"^",9),"date")
	.s TStartTime = $p($g(^DHCEQMaintRequest(rowid)),"^",10)
	.s TEndDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintRequest(rowid)),"^",11),"date")
	.s TEndTime = $p($g(^DHCEQMaintRequest(rowid)),"^",12)
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$h
	.q:($p($g(^DHCEQMaintRequest(rowid)),"^",13)<StartDate)!($p($g(^DHCEQMaintRequest(rowid)),"^",13)>EndDate)
	.s TRequestDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintRequest(rowid)),"^",13),"date")
	.s TRequestTime = $p($g(^DHCEQMaintRequest(rowid)),"^",14)
	.s TFaultTypeDR = $p($g(^DHCEQMaintRequest(rowid)),"^",15)
	.i TFaultTypeDR '=""  d
	..s TFaultType = $p($g(^DHCEQCCode("DHCEQCFaultType",TFaultTypeDR)),"^",2)
	.s TAcceptDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintRequest(rowid)),"^",16),"date")
	.s TAcceptTime = $p($g(^DHCEQMaintRequest(rowid)),"^",17)
	.s TAcceptUserDR = $p($g(^DHCEQMaintRequest(rowid)),"^",18)
	.i TAcceptUserDR '=""  d
	..s TAcceptUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAcceptUserDR)
	.s TAssignDR = $p($g(^DHCEQMaintRequest(rowid)),"^",19)
	.i TAssignDR '=""  d
	..s TAssign = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAssignDR)
	.s TMaintModeDR = $p($g(^DHCEQMaintRequest(rowid)),"^",20)
	.i TMaintModeDR '=""  d
	..s TMaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",TMaintModeDR)),"^",2)
	.s TPayedMaintFlag = $p($g(^DHCEQMaintRequest(rowid)),"^",21)
	.s TMaintFee = $p($g(^DHCEQMaintRequest(rowid)),"^",22)
	.s TUserSignDR = $p($g(^DHCEQMaintRequest(rowid)),"^",23)
	.i TUserSignDR '=""  d
	..s TUserSign = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUserSignDR)
	.s TUserOpinion = $p($g(^DHCEQMaintRequest(rowid)),"^",24)
	.s TManageLocDR = $p($g(^DHCEQMaintRequest(rowid)),"^",25)
	.i TManageLocDR '=""  d
	..s TManageLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	.s TUseLocDR = $p($g(^DHCEQMaintRequest(rowid)),"^",26)
	.i TUseLocDR '=""  d
	..s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.s TIsInputFlag = $p($g(^DHCEQMaintRequest(rowid)),"^",27)
	.s TRemark = $p($g(^DHCEQMaintRequest(rowid)),"^",28)
	.s TStatus = $p($g(^DHCEQMaintRequest(rowid)),"^",29)
	.q:(TStatus'=2)
	.d OutputRowTroubleAnalyze
	quit
OutputRowTroubleAnalyze
	s Data=$lb(TRowID,TEquipDR,TRequestLocDR,TFaultCaseDR,TFaultCaseRemark,TFaultReasonDR,TFaultReasonRemark,TDealMethodDR,TDealMethodRemark,TStartDate,TStartTime,TEndDate,TEndTime,TRequestDate,TRequestTime,TFaultTypeDR,TAcceptDate,TAcceptTime,TAcceptUserDR,TAssignDR,TMaintModeDR,TPayedMaintFlag,TMaintFee,TUserSignDR,TUserOpinion,TManageLocDR,TUseLocDR,TIsInputFlag,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TEquip,TRequestLoc,TFaultCase,TFaultReason,TDealMethod,TFaultType,TAcceptUser,TAssign,TMaintMode,TUserSign,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TModel,TMaintLocDR,TMaintRemark,TMaintDept)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesTroubleAnalyze
	s (TRowID,TEquipDR,TRequestLocDR,TFaultCaseDR,TFaultCaseRemark,TFaultReasonDR,TFaultReasonRemark,TDealMethodDR,TDealMethodRemark,TStartDate,TStartTime,TEndDate,TEndTime,TRequestDate,TRequestTime,TFaultTypeDR,TAcceptDate,TAcceptTime,TAcceptUserDR,TAssignDR,TMaintModeDR,TPayedMaintFlag,TMaintFee,TUserSignDR,TUserOpinion,TManageLocDR,TUseLocDR,TIsInputFlag,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TEquip,TRequestLoc,TFaultCase,TFaultReason,TDealMethod,TFaultType,TAcceptUser,TAssign,TMaintMode,TUserSign,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TModel,TMaintLocDR,TMaintRemark,TMaintDept)=""
	quit
}

ClassMethod TroubleAnalyzeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TroubleAnalyzeExecute ]
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

ClassMethod TroubleAnalyzeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TroubleAnalyzeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetStatus(Status)
{
	q $CASE(Status,0:"新增",1:"提交",2:"分配",3:"受理",4:"解决",:"为定义")
}

/***************************************设备维修统计报表*********************************************/
ClassMethod GetOneStoreMoveStat(PNum)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i PNum=0 q $o(^DHCEQTemp("StoreMoveStat",User,""),-1)
	q $g(^DHCEQTemp("StoreMoveStat",User,PNum))
}

ClassMethod MaintStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod MaintStatisticsExecute(ByRef qHandle As %Binary, UseLocDR, EquipDR, MaintUserDR, StartDate, EndDate) As %Status
{
	new repid, index, rowid, Maintcount, MaintFee
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^DHCEQTemp("StoreMoveStat",User)
	s index=1
	s rowid=0
	s PNum=1
	s Maintcount=0 //维修总次数
	s MaintFee=0 //维护总费用
	d BuildDataGetMaintStatistics
	Quit $$$OK
BuildDataGetMaintStatistics
	f  s rowid=$o(^DHCEQMaint(rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaintStatistics
	.s TRowID=rowid
	.s TRequestLocDR=$p($g(^DHCEQMaint(rowid)),"^",2)
	.q:(TRequestLocDR="")              //不为空的记录是维修记录,为空的是保养记录
	.s TStatus=$p($g(^DHCEQMaint(rowid)),"^",13)
	.q:(TStatus'="1")                  //0为新增记录状态,1为已提交记录状态
	.s TRequestNo=$p($g(^DHCEQMaintRequest(TRequestLocDR)),"^",43)
	.s TRequestDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintRequest(TRequestLocDR)),"^",13),"date")
	.s TRequestLocDR=$p($g(^DHCEQMaintRequest(TRequestLocDR)),"^",2)
	.s TRequestLocDR=##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	.s TEquipDR=$p($g(^DHCEQMaint(rowid)),"^",1)
	.q:(EquipDR'="")&&(EquipDR'=TEquipDR)
	.s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	.s TModelDR=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TMaintDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaint(rowid)),"^",5),"date")
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$H
	.q:($p($g(^DHCEQMaint(rowid)),"^",5)>EndDate)||($p($g(^DHCEQMaint(rowid)),"^",5)<StartDate)
	.s TMaintUserDR=$p($g(^DHCEQMaint(rowid)),"^",7)
	.q:(MaintUserDR'="")&&(MaintUserDR'=TMaintUserDR)
	.s TMaintUserDR=##class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUserDR)
	.s TUseLocDR=$p($g(^DHCEQMaint(rowid)),"^",12)
	.q:(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
	.s TUseLocDR=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.s TMaintFee=$p($g(^DHCEQMaint(rowid)),"^",9)
	.s Maintcount=Maintcount + 1
	.s MaintFee=MaintFee + TMaintFee
	.d OutputRowGetMaintStatistics
	
	d ResetVariablesGetMaintStatistics
	s TRowID="-1"
	s TRequestLocDR="合计"
	s TMaintDate="维修总次数:"
	s TMaintUserDR=Maintcount
	s TUseLocDR="维修总费用:"
	s TMaintFee=MaintFee
	d OutputRowGetMaintStatistics
	quit
OutputRowGetMaintStatistics
	s Data=$lb(TRowID,TRequestLocDR,TRequestNo,TEquip,TEquipDR,TModelDR,TRequestDate,TMaintDate,TMaintUserDR,TUseLocDR,TMaintFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set ^DHCEQTemp("StoreMoveStat",User,PNum)=TRowID_"^"_TRequestLocDR_"^"_TRequestNo_"^"_TEquip_"^"_TEquipDR_"^"_TModelDR_"^"_TRequestDate_"^"_TMaintDate_"^"_TMaintUserDR_"^"_TUseLocDR_"^"_TMaintFee
	s PNum=PNum+1
	quit
ResetVariablesGetMaintStatistics
	s (TRowID,TRequestLocDR,TRequestNo,TEquip,TEquipDR,TModelDR,TRequestDate,TMaintDate,TMaintUserDR,TUseLocDR,TMaintFee)=""
	quit
}

ClassMethod MaintStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintStatisticsExecute ]
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

Query MaintStatistics(UseLocDR, EquipDR, MaintUserDR, StartDate, EndDate) As %Query(ROWSPEC = "TRowID:%String,TRequestLocDR:%String,TRequestNo:%String,TEquip:%String,TEquipDR:%String,TModelDR:%String,TRequestDate:%String,TMaintDate:%String,TMaintUserDR:%String,TUseLocDR:%String,TMaintFee:%String")
{
}

/****************************维修员*******************************************/
ClassMethod EQMaintUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQMaintUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod EQMaintUserExecute(ByRef qHandle As %Binary, name As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
	.s username=$p(^SSU("SSUSR",rowid),"^",2)
	.s usergroup=$p(^SSU("SSUSR",rowid),"^",5)
	.q:username'[name
	.s rowid0=rowid
 	.Do OutputRowEQMaintUser	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowEQMaintUser
	set Data=$lb(username,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EQMaintUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EQMaintUserExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query EQMaintUser(name As %String) As %Query(ROWSPEC = "UserName:%String,UserID:%String")
{
}

/*******************************************************************************************/
ClassMethod GetPath(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

/**************************************************************************************************/
/// 2010-03-06 党军 begin
/// 故障现象，故障原因，故障解决方法自动检测新增
ClassMethod UpdateFaultCase(FaultCase)
{
	s ID=""
	&SQL(Select FC_RowID Into :ID From SQLUSER.DHC_EQCFaultCase Where FC_Desc=:FaultCase)
	if ID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQCFaultCase(FC_desc,FC_InvalidFlag) Values(:FaultCase,'N'))
		if SQLCODE 
		{
			q SQLCODE
		}
		s ID=$G(%ROWID)
	}
	q ID
}

ClassMethod UpdateFaultReason(FaultReason)
{
	s ID=""
	&SQL(Select FR_RowID Into :ID From SQLUSER.DHC_EQCFaultReason Where FR_Desc=:FaultReason)
	if ID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQCFaultReason(FR_desc,FR_InvalidFlag) Values(:FaultReason,'N'))
		if SQLCODE 
		{
			q SQLCODE
		}
		s ID=$G(%ROWID)
	}
	q ID
}

ClassMethod UpdateDealMethod(DealMethod)
{
	s ID=""
	&SQL(Select DM_RowID Into :ID From SQLUSER.DHC_EQCDealMethod Where DM_Desc=:DealMethod)
	if ID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQCDealMethod(DM_desc,DM_InvalidFlag) Values(:DealMethod,'N'))
		if SQLCODE 
		{
			q SQLCODE
		}
		s ID=$G(%ROWID)
	}
	q ID
}

///            2010-03-06 党军 end

Storage Default
{
<Data name="DHCEQMaintRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQMaintRequestD</DataLocation>
<DefaultData>DHCEQMaintRequestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCEQMaintRequestD</IdLocation>
<IndexLocation>^web.DHCEQMaintRequestI</IndexLocation>
<StreamLocation>^web.DHCEQMaintRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
