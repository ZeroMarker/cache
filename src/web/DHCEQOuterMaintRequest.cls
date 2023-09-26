Class web.DHCEQOuterMaintRequest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// ReplacesAD, QXType, ApproveRole, WaitAD, Type, UseLocDR, StartDate, EndDate, StatusDR
Query GetOuterRequest(ReplacesAD, QXType, ApproveRole, WaitAD, Type, UseLocDR, StartDate, EndDate, StatusDR) As %Query(ROWSPEC = "TRowID:%String,TRequestNo:%String,TSourceType:%String,TSourceID:%String,TEquipDR:%String,TUseLocDR:%String,TMaintFee:%String,TRequestDate:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TStatus:%String,TApproveSetDR:%String,TNextRoleDR:%String,TNextFlowStep:%String,TApproveStatu:%String,TApproveRoleDR:%String,TEquipTypeDR:%String,TCondition:%String,TRequestReason:%String,TRemark:%String,TRejectReason:%String,TRejectUserDR:%String,TRejectDate:%String,TRejectTime:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TEquip:%String,TUseLoc:%String,TSubmitUser:%String,TAuditUser:%String,TApproveSet:%String,TNextRole:%String,TApproveRole:%String,TEquipType:%String,TRejectUser:%String")
{
}

ClassMethod GetOuterRequestExecute(ByRef qHandle As %Binary, ReplacesAD, QXType, ApproveRole, WaitAD, Type, UseLocDR, StartDate, EndDate, StatusDR) As %Status
{
	//Type=0一般de
	//Type=1审批
	//Type=2审核
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetOuterRequest
	Quit $$$OK
BuildDataGetOuterRequest
	if WaitAD'="on"
	{
		if ReplacesAD="1"
		{
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("9")
			s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
			s ALRowID=0
			f  s ALRowID=$o(^DHCEQApproveList(0,"Role",ApproveType,ApproveRole,ALRowID)) q:ALRowID=""  d
			.s ADUser=$p(^DHCEQApproveList(ALRowID),"^",6)
			.q:ADUser=CurUser
			.s rowid=$p(^DHCEQApproveList(ALRowID),"^",2)
			.d ResetVariablesGetOuterRequest
			.d GetOneRequest
		}
		else
		{
			f  s rowid=$o(^DHCEQOuterMaintRequest(rowid))  quit:rowid=""  d
			.d ResetVariablesGetOuterRequest
			.d GetOneRequest
		}
	}
	else
	{
		if Type="1"
		{
			f  s rowid=$o(^DHCEQOuterMaintRequest(0,"ApproveRole",1,ApproveRole,rowid))  quit:rowid=""  d
			.d ResetVariablesGetOuterRequest
			.d GetOneRequest
			s rowid=0
			s ApproveSet=0
			s ApproveFlow=0
			s ApproveFlowStep=""
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("9")
			f  s ApproveSet=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveType,ApproveSet))  quit:ApproveSet=""  d
			.f   s ApproveFlow=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,ApproveRole,ApproveFlow))  quit:ApproveFlow=""  d
			..s ApproveFowStep=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlow),"^",3)
			..f   s rowid=$o(^DHCEQOuterMaintRequest(0,"ApproveSet",1,ApproveSet,ApproveFowStep,rowid))  quit:rowid=""  d
			...s Role=$p(^DHCEQOuterMaintRequest(rowid),"^",16)
			...q:Role'=""
			...s Approved=##class(web.DHCEQCApproveSet).HasApprove(ApproveType, rowid, ApproveFowStep, ApproveRole)
			...q:Approved>0
			...d ResetVariablesGetOuterRequest
			...d GetOneRequest
		}
		if Type="2"
		{
			s rowid=0
			s NextStep=""
			f  s rowid=$o(^DHCEQOuterMaintRequest(0,"Status",1,rowid))  quit:rowid=""  d
			.s NextStep=$p(^DHCEQOuterMaintRequest(rowid),"^",17)
			.q:NextStep'=""
			.d ResetVariablesGetOuterRequest
			.d GetOneRequest
		}
	}
	quit
GetOneRequest
	s TRowID = rowid
	s TRequestNo = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",1)
	s TSourceType = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",2)
	s TSourceID = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",3)
	s TEquipDR = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",4)
	i TEquipDR '=""  d
	.s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	s TUseLocDR = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",5)
	q:((UseLocDR'="")&&(UseLocDR'=TUseLocDR))
	i TUseLocDR '=""  d
	.s TUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	s TMaintFee = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",6)
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	q:($p($g(^DHCEQOuterMaintRequest(rowid)),"^",7)>EndDate)||($p($g(^DHCEQOuterMaintRequest(rowid)),"^",7)<StartDate)
	
	s TRequestDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOuterMaintRequest(rowid)),"^",7),"date")
	s TSubmitUserDR = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",8)
	i TSubmitUserDR '=""  d
	.s TSubmitUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	s TSubmitDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOuterMaintRequest(rowid)),"^",9),"date")
	s TSubmitTime = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",10)
	s TAuditUserDR = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",11)
	i TAuditUserDR '=""  d
	.s TAuditUser =##Class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	s TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOuterMaintRequest(rowid)),"^",12),"date")
	s TAuditTime = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",13)
	s TStatus = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",14)
	
	q:(StatusDR'="")&&(StatusDR'=TStatus)
	q:((Type'="0")&&(StatusDR=""))&&(TStatus="0")
	s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	
	s TApproveSetDR = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",15)
	//i TApproveSetDR '=""  d
	//.s TApproveSet = $p($g(^DHCEQCApproveSet(TApproveSetDR)),"^",XX)
	s TNextRoleDR = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",16)
	i TNextRoleDR '=""  d
	.s TNextRole = $p($g(^DHCEQCApproveRole(TNextRoleDR)),"^",3)
	s TNextFlowStep = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",17)
	s TApproveStatu = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",18)
	s TApproveRoleDR = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",19)
	i TApproveRoleDR '=""  d
	.s TApproveRole = $p($g(^DHCEQCApproveRole(TApproveRoleDR)),"^",3)
	s TEquipTypeDR = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",20)
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCEquipType(TEquipTypeDR)),"^",2)
	s TCondition = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",21)
	s TRequestReason = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",22)
	s TRemark = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",23)
	s TRejectReason = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",24)
	s TRejectUserDR = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",25)
	i TRejectUserDR '=""  d
	.s TRejectUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TRejectUserDR)
	s TRejectDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOuterMaintRequest(rowid)),"^",26),"date")
	s TRejectTime = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",27)
	s THold1 = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",28)
	s THold2 = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",29)
	s THold3 = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",30)
	s THold4 = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",31)
	s THold5 = $p($g(^DHCEQOuterMaintRequest(rowid)),"^",32)
	d OutputRowGetOuterRequest
	quit
OutputRowGetOuterRequest
	s Data=$lb(TRowID,TRequestNo,TSourceType,TSourceID,TEquipDR,TUseLocDR,TMaintFee,TRequestDate,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TStatus,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatu,TApproveRoleDR,TEquipTypeDR,TCondition,TRequestReason,TRemark,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,THold1,THold2,THold3,THold4,THold5,TEquip,TUseLoc,TSubmitUser,TAuditUser,TApproveSet,TNextRole,TApproveRole,TEquipType,TRejectUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOuterRequest
	s (TRowID,TRequestNo,TSourceType,TSourceID,TEquipDR,TUseLocDR,TMaintFee,TRequestDate,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TStatus,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatu,TApproveRoleDR,TEquipTypeDR,TCondition,TRequestReason,TRemark,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,THold1,THold2,THold3,THold4,THold5,TEquip,TUseLoc,TSubmitUser,TAuditUser,TApproveSet,TNextRole,TApproveRole,TEquipType,TRejectUser)=""
	quit
}

ClassMethod GetOuterRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOuterRequestExecute ]
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

ClassMethod GetOuterRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOuterRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetOneRequest(itms As %Library.String = "", itmsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQOuterMaintRequest(rowid)
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",4))),"^",1)
	s resultex=resultex_"^"	;UseLocDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",5))
	s $p(result,"^",7)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")	;RequestDate
	s resultex=resultex_"^"	;SubmitUserDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",8))
	s $p(result,"^",9)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;SubmitDate
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",11))
	s $p(result,"^",12)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")	;AuditDate
	s resultex=resultex_"^"	;ApproveSetDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCApproveSet($p(result,"^",15))),"^",1)
	s resultex=resultex_"^"	;NextRoleDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCApproveRole($p(result,"^",16))),"^",3)
	s resultex=resultex_"^"	;ApproveRoleDR
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCApproveRole($p(result,"^",19))),"^",3)
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCEquipType($p(result,"^",20))),"^",2)
	s resultex=resultex_"^"	;RejectUserDR
	i $p(result,"^",25)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",25))
	s $p(result,"^",26)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",26),"date")	;RejectDate

	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

ClassMethod UpdateRequest(val, AppType)
{
	new PLIST
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s BRRowID = $p(val,"^",1)	;RowID
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("9")
	if +AppType=0 //新增，更新
 	{
	 	s PLIST(1) = $p(val,"^",1)	;RowID
		s PLIST(2) = $p(val,"^",2)	;RequestNo
		s PLIST(3) = $p(val,"^",3)	;SourceType
		s PLIST(4) = $p(val,"^",4)	;SourceID
		s PLIST(5) = $p(val,"^",5)	;EquipDR
		s PLIST(6) = $p(val,"^",6)	;UseLocDR
		s PLIST(7) = $p(val,"^",7)	;MaintFee
		s PLIST(8) = $p(val,"^",8)	;RequestDate
		i $p(val,"^",8)'=""  s PLIST(8) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date")	;RequestDate
		;s PLIST(9) = $p(val,"^",9)	;SubmitUserDR
		;s PLIST(10) = $p(val,"^",10)	;SubmitDate
		;i $p(val,"^",10)'=""  s PLIST(10) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"date")	;SubmitDate
		;s PLIST(11) = $p(val,"^",11)	;SubmitTime
		;s PLIST(12) = $p(val,"^",12)	;AuditUserDR
		;s PLIST(13) = $p(val,"^",13)	;AuditDate
		;i $p(val,"^",13)'=""  s PLIST(13) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",13),"date")	;AuditDate
		;s PLIST(14) = $p(val,"^",14)	;AuditTime
		s PLIST(15) = AppType	;Status
		;s PLIST(16) = $p(val,"^",16)	;ApproveSetDR
		;s PLIST(17) = $p(val,"^",17)	;NextRoleDR
		;s PLIST(18) = $p(val,"^",18)	;NextFlowStep
		;s PLIST(19) = $p(val,"^",19)	;ApproveStatu
		;s PLIST(20) = $p(val,"^",20)	;ApproveRoleDR
		s PLIST(21) = $p(val,"^",21)	;EquipTypeDR
		s PLIST(22) = $p(val,"^",22)	;Condition
		s PLIST(23) = $p(val,"^",23)	;RequestReason
		s PLIST(24) = $p(val,"^",24)	;Remark
		;s PLIST(25) = $p(val,"^",25)	;RejectReason
		;s PLIST(26) = $p(val,"^",26)	;RejectUserDR
		;s PLIST(27) = $p(val,"^",27)	;RejectDate
		;i $p(val,"^",27)'=""  s PLIST(27) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",27),"date")	;RejectDate
		;s PLIST(28) = $p(val,"^",28)	;RejectTime
		 
		s PLIST(29) = $p(val,"^",29)	;Hold1
		s PLIST(30) = $p(val,"^",30)	;Hold2
		s PLIST(31) = $p(val,"^",31)	;Hold3
		s PLIST(32) = $p(val,"^",32)	;Hold4
		s PLIST(33) = $p(val,"^",33)	;Hold5
		k PLIST(1)
 
	 	
 		TSTART
 		if BRRowID=""
 		{
	 		;s PLIST(29)=User
	 		;s PLIST(30)=+$H
	 		;s PLIST(31)=$P($H,",",2)
	 		
	 		s requestno = ##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQOuterMaintRequest",+$H)
	 		if requestno="" 
	 		{TRollBack
	 		 q -2102 
	 		}
 			i PLIST(2)="" s PLIST(2) = requestno
	 		
	 		&sql(insert into sqluser.DHC_EQOuterMaintRequest values :PLIST())
	 		if SQLCODE
	 		{
		 		TROLLBACK
		 		q SQLCODE
	 		}
	 		s ID=$G(%ROWID)
 		}
 		else
 		{
	 		;s PLIST(32)=User
	 		;s PLIST(33)=+$H
	 		;s PLIST(34)=$P($H,",",2)
	 		&sql(update sqluser.DHC_EQOuterMaintRequest values :PLIST() where OMR_ROWID=:BRRowID)
	 		if SQLCODE
	 		{
		 		TROLLBACK
		 		q SQLCODE
	 		}
	 		s ID=$G(%ROWID)
 		}
 		TCOMMIT
	 	q ID
 	}
 	if +AppType=1 //提交
 	{
	 	s PLIST(15)=AppType
	 	s PLIST(9)=User
	 	s PLIST(10)=Date
	 	s PLIST(11)=Time
	 	
	 	s equipdr=$P(^DHCEQOuterMaintRequest(BRRowID),"^",4)	 	
	 	s EquipType=$p($g(^DHCEQEquip(equipdr)),"^",63)
	 	s PurchaseType=""
	 	s YearFlag=""
	 	s MaxPrice=$p($g(^DHCEQEquip(equipdr)),"^",27)
	 	s SpecialType=""
	 	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag)
	 	
	 	i ApproveSet="" q -4007
	 	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,BRRowID,"9",User)
	 	i SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	
	 	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, BRRowID, 0, "")
	 	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	 	s LastFlag=$P(ApproveFlow,"^",1)
	 	s NextStep=$P(ApproveFlow,"^",2)
	 	s NextRole=$P(ApproveFlow,"^",3)
	 	i AutoAuditFlag="Y"
	 	{
		 	i NextStep="" s PLIST(15)="2"
		 	i LastFlag="Y" s PLIST(15)="2"
		 	i (NextStep="")||(LastFlag="Y")
		 	{
		 		s PLIST(12)=User
	 			s PLIST(13)=Date
	 			s PLIST(14)=Time
		 	}
	 	}
	 	s PLIST(16)=ApproveSet
	 	s PLIST(17)=NextRole
	 	s PLIST(18)=NextStep
	 	s PLIST(19)=""
	 	s PLIST(20)=""
	 	//i YearFlag="Y" s PLIST(37)="Y"
	 	TSTART
	 	&sql(update sqluser.DHC_EQOuterMaintRequest values :PLIST() where OMR_ROWID=:BRRowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
	 	TCOMMIT
	 	q ID
 	}
 	if +AppType=2 //审批
 	{
	 	s PLIST(20)=$p(val,"^",2)  //Role
	 	s PLIST(19)=$p(val,"^",3)  //Step
	 	s Opinion=$p(val,"^",4)  //Opinion 	
	 	s Remark=$p(val,"^",5)
	 	s QXType=$p(val,"^",6)
	 	s PLIST(15)="1"
	 	s ApproveSet=$P(^DHCEQOuterMaintRequest(BRRowID),"^",15)
	 	s NextApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, BRRowID, PLIST(19), PLIST(20))
 		s LastFlag=$p(NextApproveFlow,"^",1)
 		s PLIST(18)=$p(NextApproveFlow,"^",2)  //NextStep
 		s PLIST(17)=$p(NextApproveFlow,"^",3)  //NextRole
 		s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
 		i AutoAuditFlag="Y"
	 	{
		 	i PLIST(18)=""
		 	{
			 	s PLIST(15)="2"
		 		s PLIST(12)=User
	 			s PLIST(13)=Date
	 			s PLIST(14)=Time
		 	}
	 	}
	 	
	 	TSTART
	 	&sql(update sqluser.DHC_EQOuterMaintRequest values :PLIST() where OMR_RowID=:BRRowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	//s ReturnID=$G(%ROWID)
	 	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, BRRowID, Opinion, Remark, PLIST(20), PLIST(19))
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	TCOMMIT
	 	q BRRowID
 	}
 	if +AppType=3 //删除
 	{
	 	TSTART
	 	&sql(delete from sqluser.DHC_EQOuterMaintRequest where OMR_RowID=:BRRowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	TCOMMIT
	 	q ""
 	}
 	if +AppType=4 //反提交
 	{
	 	s PLIST(15)="0"
	 	s PLIST(25)=$p(val,"^",2)
	 	s PLIST(26)=User
	 	s PLIST(27)=Date
	 	s PLIST(28)=Time
	 	TSTART
	 	&sql(update sqluser.DHC_EQOuterMaintRequest values :PLIST() where OMR_ROWID=:BRRowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
	 	TCOMMIT
	 	q ID
 	}
 	if +AppType=5  //审核
 	{
	 	s PLIST(15)="2"
	 	s PLIST(12)=User
	 	s PLIST(13)=Date
	 	s PLIST(14)=Time
	 	TSTART
	 	&sql(update sqluser.DHC_EQOuterMaintRequest values :PLIST() where OMR_ROWID=:BRRowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
	 	TCOMMIT
	 	q ID
 	}
}

ClassMethod MaintRequestToOuterRequest(maintRequestId)
{
	new val,AppType,equipdr
	
	if maintRequestId="" q ""
	s OuterId=$o(^DHCEQOuterMaintRequest(0,"Source",0,maintRequestId,0))
	if OuterId'="" q OuterId
	
	s AppType="0"	;add
	s val=""		;RowID
	s val=val_"^"	;RequestNo
	s val=val_"^"_"0"	;SourceType  0:维修申请
	s val=val_"^"_maintRequestId	;SourceID
	s equipdr=$p($g(^DHCEQMaintRequest(maintRequestId)),"^",1)
	s val=val_"^"_equipdr	;EquipDR
	s val=val_"^"_$p($g(^DHCEQMaintRequest(maintRequestId)),"^",26)	;UseLocDR
	s val=val_"^"_$p($g(^DHCEQMaintRequest(maintRequestId)),"^",22)	;MaintFee
	s val=val_"^"_$ZD(+$H,4)	;RequestDate
	s val=val_"^"	;SubmitUserDR
	s val=val_"^"	;SubmitDate
	s val=val_"^"	;SubmitTime
	s val=val_"^"	;AuditUserDR
	s val=val_"^"	;AuditDate
	s val=val_"^"	;AuditTime
	s val=val_"^"_AppType	;Status
	s val=val_"^"	;ApproveSetDR
	s val=val_"^"	;NextRoleDR
	s val=val_"^"	;NextFlowStep
	s val=val_"^"	;ApproveStatu
	s val=val_"^"	;ApproveRoleDR
	s val=val_"^"	;EquipTypeDR
	if equipdr'="" s val=val_$p($g(^DHCEQEquip(equipdr)),"^",63)
	
	s val=val_"^"_..GetMaintRequestInfo(maintRequestId)	;Condition
	s val=val_"^"	;RequestReason
	s val=val_"^"	;Remark
	
	s val=val_"^"	;RejectReason
	s val=val_"^"	;RejectUserDR
	s val=val_"^"	;RejectDate
	s val=val_"^"	;RejectTime
		 
	s val=val_"^"	;Hold1
	s val=val_"^"	;Hold2
	s val=val_"^"	;Hold3
	s val=val_"^"	;Hold4
	s val=val_"^"	;Hold5
	
	q ..UpdateRequest(val, AppType)
}

ClassMethod GetMaintRequestInfo(maintRequestId)
{
	new info,result
	
	s result=$g(^DHCEQMaintRequest(maintRequestId))
	
	s info="故障现象:"
	;FaultCaseDR
	if ($p(result,"^",3)'="")
	{
		s info=info_$p($g(^DHCEQCCode("DHCEQCFaultCase",$p(result,"^",3))),"^",2)_":"
	}
	;FaultCaseRemark
	if $p(result,"^",4)'=""
	{
		s info=info_$p(result,"^",4)_"; "
	}
	s info=info_"故障原因:"
	;;FaultReasonDR
	if ($p(result,"^",5)'="")
	{	s info=info_$p($g(^DHCEQCCode("DHCEQCFaultReason",$p(result,"^",5))),"^",2)_":"	}
	if ($p(result,"^",6)'="")
	{
		s info=info_$p(result,"^",6)_"; "
	}
	s info=info_"解决方式:"
	;;DealMethodDR	
	if ($p(result,"^",7)'="")
	{
		s info=info_$p($g(^DHCEQCCode("DHCEQCDealMethod",$p(result,"^",7))),"^",2)_":"	
	}
	if ($p(result,"^",8)'="")
	{
		s info=info_$p(result,"^",8)_"; "
	}
	
	q info
}

}
