Class web.DHCEQCheck Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 116;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CH_RowID";

Parameter SQLDESCRIPTION = "CH_RowID";

Parameter SQLROWID = "CH_RowID";

ClassMethod GetStatus(CheckDR)
{
	s Status=""
	i CheckDR="" q ""
	&sql(select CH_Status into :Status from sqluser.DHC_EQCheck where CH_RowID=:CheckDR)
	q Status
}

ClassMethod UpdateCheck(itms As %Library.String = "", itmsex As %Library.String = "", val, AppType, RowID, EquipDR, User)
{
	//+AppType=0 插入，更新
	//+AppType=1 提交
	//+AppType=2 审核
	//+AppType=3 删除
	//RowID 为Check记录的ID
	//EquipDR 为Equip的ID
	//User 为操作员ID
	s Date=+$H
	s Time=$P($H,",",2)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("6")
 	if +AppType=0 
 	{
	 	s PLIST(1) = $p(val,"^",1)	;RowID
		s CHRowID=$p(val,"^",1)	;RowID
 		s PLIST(2) = $p(val,"^",2)	;EquipDR
 		s ContractListID=$p($G(^DHCEQEquip(PLIST(2))),"^",32)
 		s PLIST(3) = $p(val,"^",3)	;InstallLocDR
 		s PLIST(4) = $p(val,"^",4)	;InstallDate
 		i $p(val,"^",4)'=""  s PLIST(4) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"date")	;InstallDate
 		s PLIST(5) = $p(val,"^",5)	;InstallUser
 		s PLIST(6) = $p(val,"^",6)	;StartDate
 		i $p(val,"^",6)'=""  s PLIST(6) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"date")	;StartDate
 		s PLIST(7) = $p(val,"^",7)	;EndDate
 		i $p(val,"^",7)'=""  s PLIST(7) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"date")	;EndDate
 		s PLIST(8) = $p(val,"^",8)	;CheckContent
 		s PLIST(9) = $p(val,"^",9)	;CheckResultDR
 		s PLIST(10) = $p(val,"^",10)	;CheckResultRemark
 		s PLIST(11) = $p(val,"^",11)	;CheckType
 		s PLIST(12) = AppType //$p(val,"^",12)	;Status
 		s PLIST(13) = $p(val,"^",13)	;Remark
 		s PLIST(24) = "N" //$p(val,"^",24)	;InvalidFlag
 		k PLIST(1)
 		TSTART
 		if CHRowID=""
 		{
	 		s PLIST(25)=User
	 		s PLIST(26)=Date
	 		s PLIST(27)=Time
	 		i ContractListID'=""
	 		{
	 			s SQLCODE=..InsertConfigByContract(PLIST(2),ContractListID)
	 			if SQLCODE<0
	 			{
		 			TROLLBACK
		 			q SQLCODE
	 			}
	 		}
	 		&sql(insert into sqluser.DHC_EQCheck values :PLIST())
	 		if SQLCODE
	 		{
		 		TROLLBACK
		 		q SQLCODE
	 		}
	 		s ID=$G(%ROWID)
 		}
 		else
 		{
	 		s PLIST(28)=User
	 		s PLIST(29)=Date
	 		s PLIST(30)=Time
	 		&sql(update sqluser.DHC_EQCheck values :PLIST() where CH_ROWID=:CHRowID)
	 		if SQLCODE
	 		{
		 		TROLLBACK
		 		q SQLCODE
	 		}
	 		s ID=$G(%ROWID)
 		}
 		TCOMMIT
	 	q ID_"^"_PLIST(2)
 	}
 	if +AppType=1
 	{
	 	s PLIST(12)=AppType
	 	s PLIST(28)=User
	 	s PLIST(29)=Date
	 	s PLIST(30)=Time
	 	s EQRowID=EquipDR
	 	TSTART
	 	s EquipType=$P(^DHCEQEquip(EQRowID),"^",63)
	 	s PurchaseType=$P(^DHCEQEquip(EQRowID),"^",64)
	 	s YearFlag=""
	 	s MaxPrice=$P(^DHCEQEquip(EQRowID),"^",27)
	 	s SpecialType=##class(web.DHCEQDisuseRequest).GetSpecialType(EQRowID)
	 	i SpecialType<0 q -4006
	 	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag)
	 	i ApproveSet="" q -4007
	 	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"6",User)
	 	i SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	
	 	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	 	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	 	
	 	s LastFlag=$P(ApproveFlow,"^",1)
	 	s NextStep=$P(ApproveFlow,"^",2)
	 	s NextRole=$P(ApproveFlow,"^",3)
	 	i AutoAuditFlag="Y"
	 	{
		 	i NextStep="" s PLIST(12)="2"
		 	i LastFlag="Y" s PLIST(12)="2"
		 	i (NextStep="")||(LastFlag="Y")
		 	{
		 		s PLIST(31)=User
	 			s PLIST(32)=updDate
	 			s PLIST(33)=updTime
	 			s SQLCODE=..UpdateEquip(val,EquipDR,Date,Time)
	 			if SQLCODE
	 			{
		 			TROLLBACK
		 			q SQLCODE
	 			}
		 	}
	 	}
	 	s PLIST(18)=ApproveSet
	 	s PLIST(19)=NextRole
	 	s PLIST(20)=NextStep
	 	s PLIST(21)=""
	 	s PLIST(22)=""
	 	&sql(update sqluser.DHC_EQCheck values :PLIST() where CH_ROWID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
	 	TCOMMIT
	 	q ID
 	}
 	if +AppType=2 //审核
 	{
	 	s PLIST(12)=AppType
	 	s PLIST(31)=User
	 	s PLIST(32)=Date
	 	s PLIST(33)=Time
	 	TSTART
	 	&sql(update sqluser.DHC_EQCheck values :PLIST() where CH_ROWID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
	 	s SQLCODE=..UpdateEquip(val,EquipDR,Date,Time)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	TCOMMIT
	 	q ID
 	}
 	if +AppType=3 //删除
 	{
	 	s PLIST(24)="Y"
	 	s PLIST(28)=User
	 	s PLIST(29)=+$H
	 	s PLIST(30)=$P($H,",",2)
	 	TSTART
	 	&sql(update sqluser.DHC_EQCheck values :PLIST() where CH_ROWID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	TCOMMIT
	 	q ""
 	}
 	if +AppType=4  //凡提交
 	{
	 	s PLIST(12)="0"
	 	s PLIST(14)=val
	 	s PLIST(15)=User
	 	s PLIST(16)=Date
	 	s PLIST(17)=Time
	 	TSTART
	 	&sql(update sqluser.DHC_EQCheck values :PLIST() where CH_ROWID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	TCOMMIT
	 	q RowID
 	}
 	if +AppType=5 //审批
 	{
	 	s AuditVal="^"_$p(val,";",2)
	 	s EquipVal=$p(val,";",1)
	 	s PLIST(22)=$p(AuditVal,"^",2)  //Role
		s PLIST(21)=$p(AuditVal,"^",3)  //Step
		s Opinion=$p(AuditVal,"^",4)  //Opinion
		s Remark=$p(AuditVal,"^",5)
		s ApproveSet=$P(^DHCEQCheck(RowID),"^",17)
		s NextApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, PLIST(21), PLIST(22))
 		s LastFlag=$p(NextApproveFlow,"^",1)
 		s PLIST(20)=$p(NextApproveFlow,"^",2)  //NextStep
 		s PLIST(19)=$p(NextApproveFlow,"^",3)  //NextRole
 		s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
 		TSTART
 		i AutoAuditFlag="Y"
	 	{
		 	i PLIST(20)="" s PLIST(12)="2"
		 	i LastFlag="Y" s PLIST(12)="2"
		 	i (PLIST(20)="")||(LastFlag="Y")
		 	{
		 		s PLIST(31)=User
	 			s PLIST(32)=Date
	 			s PLIST(33)=Time
	 			s SQLCODE=..UpdateEquip(EquipVal,EquipDR,Date,Time)
	 			if SQLCODE
	 			{
		 			TROLLBACK
		 			q SQLCODE
	 			}
		 	}
	 	}
	 	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, RowID, Opinion, Remark, PLIST(22), PLIST(21))
		if SQLCODE
		{
	 		TROLLBACK
			q SQLCODE
		}
	 	&sql(update sqluser.DHC_EQCheck values :PLIST() where CH_ROWID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	TCOMMIT
	 	q RowID
 	}
}

ClassMethod UpdateEquip(val, EquipDR, Date, Time)
{
	s PI(10)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",1),"date")
 	s PI(9)=$P(val,"^",2)
 	s PI(56)=User
	s PI(57)=Date
	s PI(58)=Time
	&sql(update sqluser.DHC_EQEquip values :PI() where EQ_RowID=:EquipDR)
	q SQLCODE
}

/// 	Mozy0220		2019-3-7	修正赋值
ClassMethod InsertConfigByContract(EquipID, ContractListID)
{
	new User,Date,Time
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s CCRowID=0
	s CID=""
	s SQLCODE=0
	f  s CCRowID=$O(^DHCEQContractConfig(0,"ContractList",ContractListID,CCRowID))  q:(CCRowID="")||(SQLCODE<0)  d
	.;&SQL(Insert Into SQLUser.DHC_EQConfig (C_Type,C_SourceType,C_SourceID,C_ItemDR,C_Parameters,C_Remark,C_Status,C_UpdateUserDR,C_UpdateDate,C_UpdateTime) select 3,2,:EquipID,CC_ItemDR,CC_Parameters,CC_Remark,'0',:User,:Date,:Time from SQLUser.DHC_EQContractConfig where CC_RowID=:CCRowID)
	.q:SQLCODE<0
	q SQLCODE
}

ClassMethod GetOneCheck(itms As %Library.String = "", itmsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCheck(rowid)
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;InstallLocDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	s $p(result,"^",3)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",3),"date")	;InstallDate
	s $p(result,"^",5)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")	;StartDate
	s $p(result,"^",6)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"date")	;EndDate
	s resultex=resultex_"^"	;CheckResultDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCCheckResult",$p(result,"^",8))),"^",2)
	s resultex=resultex_"^"	;CheckTypeDR
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCCheckType",$p(result,"^",10))),"^",2)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetCheck(ReplacesAD, ApproveRole, Type, WaitAD, EquipDR, ManageLocDR, UseLocDR, StatusDR, StartDate, EndDate) As %Query(ROWSPEC = "TManuFactory:%String,TModel:%String,TManuFactoryDR:%String,TModelDR:%String,TRowID:%String,TEquipDR:%String,TInstallLocDR:%String,TInstallDate:%String,TInstallUser:%String,TStartDate:%String,TEndDate:%String,TCheckContent:%String,TCheckResultDR:%String,TCheckResultRemark:%String,TCheckType:%String,TStatus:%String,TRemark:%String,TInvalidFlag:%String,TEquip:%String,TInstallLoc:%String,TCheckResult:%String,TApproveSetDR:%String,TRejectReason:%String")
{
}

ClassMethod GetCheckExecute(ByRef qHandle As %Binary, ReplacesAD, ApproveRole, Type, WaitAD, EquipDR, ManageLocDR, UseLocDR, StatusDR, StartDate, EndDate) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetCheck
	Quit $$$OK
BuildDataGetCheck
	if WaitAD'="on"
	{
		if ReplacesAD="on"
		{
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("6")
			s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
			s ALRowID=0
			f  s ALRowID=$o(^DHCEQApproveList(0,"Role",ApproveType,ApproveRole,ALRowID)) q:ALRowID=""  d
			.s ADUser=$p(^DHCEQApproveList(ALRowID),"^",6)
			.q:ADUser=CurUser
			.s rowid=$p(^DHCEQApproveList(ALRowID),"^",2)
			.d ResetVariablesGetCheck
			.d GetOneCheck
		}
		else
		{
			f  s rowid=$o(^DHCEQCheck(rowid))  quit:rowid=""  d
			.d ResetVariablesGetCheck
			.d GetOneCheck
		}
	}
	else
	{
		if Type="1"
		{
			f  s rowid=$o(^DHCEQCheck(0,"ApproveRole",1,ApproveRole,rowid))  quit:rowid=""  d
			.d ResetVariablesGetCheck
			.d GetOneCheck
			s rowid=0
			s ApproveSet=0
			s ApproveFlow=0
			s ApproveFlowStep=""
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("6")
			f  s ApproveSet=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveType,ApproveSet))  quit:ApproveSet=""  d
			.f   s ApproveFlow=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,ApproveRole,ApproveFlow))  quit:ApproveFlow=""  d
			..s ApproveFowStep=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlow),"^",3)
			..f   s rowid=$o(^DHCEQCheck(0,"ApproveSet",1,ApproveSet,ApproveFowStep,rowid))  quit:rowid=""  d
			...s Role=$p(^DHCEQCheck(rowid),"^",18)
			...q:Role'=""
			...s Approved=##class(web.DHCEQCApproveSet).HasApprove(ApproveType, rowid, ApproveFowStep, ApproveRole)
			...q:Approved>0
			...d ResetVariablesGetCheck
			...d GetOneCheck
		}
		if Type="2"
		{
			s rowid=0
			s NextStep=""
			f  s rowid=$o(^DHCEQCheck(0,"Status",1,rowid))  quit:rowid=""  d
			.s NextStep=$p($G(^DHCEQCheck(rowid)),"^",19)
			.q:NextStep'=""
			.d ResetVariablesGetCheck
			.d GetOneCheck
		}
	}
	quit
GetOneCheck
	s TRowID = rowid
	q:(EquipDR="")&&(ManageLocDR="")&&(UseLocDR="")&&(StartDate="")&&(EndDate="")&&(StatusDR="")
	s TEquipDR = $p($g(^DHCEQCheck(rowid)),"^",1)
	q:(EquipDR'="")&&(TEquipDR'=EquipDR)
	i TEquipDR '=""  d
	.s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
	.i TManuFactoryDR'="" s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	.s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	.i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TManageLocDR=$p($g(^DHCEQEquip(TEquipDR)),"^",17)
	.s TUseLocDR=$p($g(^DHCEQEquip(TEquipDR)),"^",19)
	q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
	s TInstallLocDR = $p($g(^DHCEQCheck(rowid)),"^",2)
	q:(ManageLocDR'="")&&(TInstallLocDR'=ManageLocDR)
	i TInstallLocDR '=""  d
	.s TInstallLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TInstallLocDR)
	s TInstallDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCheck(rowid)),"^",3),"date")
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$H
	q:($p($g(^DHCEQCheck(rowid)),"^",3)>EndDate)||($p($g(^DHCEQCheck(rowid)),"^",3)<StartDate)
	s TInstallUser = $p($g(^DHCEQCheck(rowid)),"^",4)
	s TStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCheck(rowid)),"^",5),"date")
	s TEndDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCheck(rowid)),"^",6),"date")
	s TCheckContent = $p($g(^DHCEQCheck(rowid)),"^",7)
	s TCheckResultDR = $p($g(^DHCEQCheck(rowid)),"^",8)
	i TCheckResultDR '=""  d
	.s TCheckResult = $p($g(^DHCEQCCode("DHCEQCCheckResult",TCheckResultDR)),"^",2)
	s TCheckResultRemark = $p($g(^DHCEQCheck(rowid)),"^",9)
	s TCheckType = $p($g(^DHCEQCheck(rowid)),"^",10)
	s TStatus = $p($g(^DHCEQCheck(rowid)),"^",11)
	q:(StatusDR'="")&&(TStatus'=StatusDR)
	s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	s TRemark = $p($g(^DHCEQCheck(rowid)),"^",12)
	s TRejectReason=$p($g(^DHCEQCheck(rowid)),"^",16)
	s TApproveSetDR=$p($g(^DHCEQCheck(rowid)),"^",17)
	s TInvalidFlag = $p($g(^DHCEQCheck(rowid)),"^",23)
	q:TInvalidFlag="Y" 
	d OutputRowGetCheck
	quit
OutputRowGetCheck
	s Data=$lb(TManuFactory,TModel,TManuFactoryDR,TModelDR,TRowID,TEquipDR,TInstallLocDR,TInstallDate,TInstallUser,TStartDate,TEndDate,TCheckContent,TCheckResultDR,TCheckResultRemark,TCheckType,TStatus,TRemark,TInvalidFlag,TEquip,TInstallLoc,TCheckResult,TApproveSetDR,TRejectReason)
			// TManuFactory,TModel,TManuFactoryDR,TModelDR,TRowID,TEquipDR,TInstallLocDR,TInstallDate,TInstallUser,TStartDate,TEndDate,TCheckContent,TCheckResultDR,TCheckResultRemark,TCheckType,TStatus,TRemark,Topinion1,TSign1DR,TOpinion2,TSign2DR,TOpinion3,TSign3DR,TOpinion4,TSign4DR,TOpinion5,TSign5DR,TInvalidFlag,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TEquip,TInstallLoc,TCheckResult,TSign1,TSign2,TSign3,TSign4,TSign5,TAddUser,TUpdateUser,TAuditUser
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCheck
	s (TUseLocDR,TManageLocDR,TManuFactory,TModel,TManuFactoryDR,TModelDR,TRowID,TEquipDR,TInstallLocDR,TInstallDate,TInstallUser,TStartDate,TEndDate,TCheckContent,TCheckResultDR,TCheckResultRemark,TCheckType,TStatus,TRemark,TInvalidFlag,TEquip,TInstallLoc,TCheckResult,TApproveSetDR,TRejectReason)=""
	quit
}

ClassMethod GetCheckFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckExecute ]
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

ClassMethod GetCheckClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
