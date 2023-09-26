Import SQLUser

Class web.DHCEQArgumentation Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "AR_RowID";

Parameter SQLDESCRIPTION = "AR_RowID";

Parameter SQLROWID = "AR_RowID";

/// w ##Class(web.DHCEQArgumentation).UpdateData("2^12^2^ty^",2,"Y")
ClassMethod UpdateData(val, AppType, TransFlag, IsApprove As %String = "0")
{
	new User,Date,Time,ApproveType,BRLRowID,BRRowID,EquipType,PurchaseType
	new YearFlag,MaxPrice,EquipCat,SpecialType,ApproveSet,ApproveFlow
	new AutoAuditFlag,LastFlag,NextStep,NextRole
	new PLIST
	s ARRowID=$p(val,"^",1)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("3")
	i +AppType=0
	{
		/*s PLIST(2) = $p(val,"^",2)	;AuditUserDR
 		s PLIST(3) = $p(val,"^",3)	;AuditDate
 		i $p(val,"^",3)'=""  s PLIST(3) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",3),"date")	;AuditDate
 		s PLIST(4) = $p(val,"^",4)	;AuditTime*/
 		s PLIST(5) = $p(val,"^",5)	;ProductIntroduce
 		s PLIST(6) = $p(val,"^",6)	;Actuality
 		s PLIST(7) = $p(val,"^",7)	;BuyReason
 		s PLIST(8) = $p(val,"^",8)	;UseYearsNum
 		s PLIST(9) = $p(val,"^",9)	;ReclaimYearsNum
 		s PLIST(10) = $p(val,"^",10)	;AffectAnalyse
 		s PLIST(11) = $p(val,"^",11)	;Condicion
 		/*s PLIST(12) = $p(val,"^",12)	;ApproveSetDR
 		s PLIST(13) = $p(val,"^",13)	;NextRoleDR
 		s PLIST(14) = $p(val,"^",14)	;NextFlowStep
 		s PLIST(15) = $p(val,"^",15)	;ApproveStatu
 		s PLIST(16) = $p(val,"^",16)	;ApproveRoleDR*/
 		s PLIST(17) = $p(val,"^",17)	;Service
 		/*s PLIST(18) = $p(val,"^",18)	;RejectReason
 		s PLIST(19) = $p(val,"^",19)	;RejectUserDR
 		s PLIST(20) = $p(val,"^",20)	;RejectDate
 		i $p(val,"^",20)'=""  s PLIST(20) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",20),"date")	;RejectDate
 		s PLIST(21) = $p(val,"^",21)	;RejectTime*/
 		s PLIST(22) = $p(val,"^",22)	;Remark
 		if IsApprove'="1" s PLIST(23) = AppType //$p(val,"^",23)	;Status
 		/*s PLIST(24) = $p(val,"^",24)	;SubmitUserDR
 		s PLIST(25) = $p(val,"^",25)	;SubmitDate
 		i $p(val,"^",25)'=""  s PLIST(25) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",25),"date")	;SubmitDate
 		s PLIST(26) = $p(val,"^",26)	;SubmitTime*/
 		s PLIST(27) = User //$p(val,"^",27)	;AddUserDR
 		s PLIST(28) = Date //$p(val,"^",28)	;AddDate
 		//i $p(val,"^",28)'=""  s PLIST(28) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",28),"date")	;AddDate
 		s PLIST(29) = Time //$p(val,"^",29)	;AddTime
 		s PLIST(30) = $p(val,"^",30)	;CountNum
 		s PLIST(31) = $p(val,"^",31)	;UseRate
 		s PLIST(32) = $p(val,"^",32)	;GoodRate
 		s PLIST(33) = $p(val,"^",33)	;ClinicEffect
 		s PLIST(34) = $p(val,"^",34)	;UsePerWeekNum
 		s PLIST(35) = $p(val,"^",35)	;WorkLoadPerWeekNum
 		s PLIST(36) = $p(val,"^",36)	;UsePriceFee
 		s PLIST(37) = $p(val,"^",37)	;YearIncomeFee
 		s PLIST(38) = $p(val,"^",38)	;CostFee
 		s PLIST(39) = $p(val,"^",39)	;SettleState
 		s PLIST(40) = $p(val,"^",40)	;ResourceState
 		s PLIST(41) = $p(val,"^",41)	;PolluteState
 		s PLIST(42) = $p(val,"^",42)	;OtherState
 		s PLIST(43) = $p(val,"^",43)	;PersonnelState
 		s PLIST(44) = $p(val,"^",44)	;BuyRequestListDR
 		
		s PLIST(45) = $p(val,"^",45)	;Material
		s PLIST(46) = $p(val,"^",46)	;OperatorCount
		s PLIST(47) = $p(val,"^",47)	;MedicalItem
		s PLIST(48) = $p(val,"^",48)	;Consumption
		s PLIST(49) = $p(val,"^",49)	;YearRunTime
		s PLIST(50) = $p(val,"^",50)	;RatingPower
		s PLIST(51) = $p(val,"^",51)	;CountInLoc
		s PLIST(52) = $p(val,"^",52)	;DepreLimitYear
		s PLIST(53) = $p(val,"^",53)	;FeeOfEmployee
		s PLIST(54) = $p(val,"^",54)	;FeeOfDepre
		s PLIST(55) = $p(val,"^",55)	;FeeOfMaterial
		s PLIST(56) = $p(val,"^",56)	;Income1
		s PLIST(57) = $p(val,"^",57)	;Effect1
		s PLIST(58) = $p(val,"^",58)	;Hold1
		s PLIST(59) = $p(val,"^",59)	;Hold2
		s PLIST(60) = $p(val,"^",60)	;Hold3
		s PLIST(61) = $p(val,"^",61)	;Hold4
		s PLIST(62) = $p(val,"^",62)	;Hold5
		 		
 		i TransFlag'="N" TSTART
 		i ARRowID=""
 		{
	 		&SQL(insert into sqluser.DHC_EQArgumentation values :PLIST())
 		}
 		else
 		{
	 		&SQL(update sqluser.DHC_EQArgumentation values :PLIST() where AR_RowID=:ARRowID)
 		}
 		i SQLCODE 
 		{
 			i TransFlag'="N" TROLLBACK
 			q SQLCODE
 		}
 		s ARID=$G(%ROWID)
 		if ARRowID=""
 		{
	 		;&SQL(update sqluser.DHC_EQBuyRequestList set BRL_ArgumentationDR=:ARID where BRL_RowID=:PLIST(44))
 			i SQLCODE 
 			{
 				i TransFlag'="N" TROLLBACK
 				q SQLCODE
 			}
 		}
 		i TransFlag'="N" TCOMMIT
 		q ARID
	}
	if +AppType=1
	{
		s PLIST(23)=AppType
	 	s PLIST(24)=User
	 	s PLIST(25)=Date
	 	s PLIST(26)=Time
	 	s BRLRowID=$p(^DHCEQArgumentation(ARRowID),"^",43)
	 	s BRRowID=$p(^DHCEQBuyRequestList(BRLRowID),"^",1)
	 	s EquipType=$P(^DHCEQBuyRequest(BRRowID),"^",25)
	 	s PurchaseType=$P(^DHCEQBuyRequest(BRRowID),"^",26)
	 	s YearFlag=$P(^DHCEQBuyRequest(BRRowID),"^",3)
	 	s MaxPrice=$p(^DHCEQBuyRequestList(BRLRowID),"^",6) //..GetMaxPrice(BRRowID)
	 	s EquipCat=$p(^DHCEQBuyRequestList(BRLRowID),"^",15) //..GetSpecialType(BRRowID)
	 	s SpecialType=""
	 	i EquipCat'="" s SpecialType=$p(^DHCEQCCode("DHCEQCEquipeCat",EquipCat),"^",5)
	 	//i SpecialType<0 q -4006
	 	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag)
	 	i ApproveSet="" q -4007
	 	i TransFlag'="N" TSTART
	 	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,ARRowID,"3",User)
	 	i SQLCODE
	 	{
		 	i TransFlag'="N" TROLLBACK
		 	q SQLCODE
	 	}
	 	
	 	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, ARRowID, 0, "")
	 	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	 	s LastFlag=$P(ApproveFlow,"^",1)
	 	s NextStep=$P(ApproveFlow,"^",2)
	 	s NextRole=$P(ApproveFlow,"^",3)
	 	i AutoAuditFlag="Y"
	 	{
		 	i NextStep="" s PLIST(23)="2"
		 	i LastFlag="Y" s PLIST(23)="2"
		 	i (NextStep="")||(LastFlag="Y")
		 	{
		 		s PLIST(2)=User
	 			s PLIST(3)=Date
	 			s PLIST(4)=Time
		 	}
	 	}
	 	s PLIST(12)=ApproveSet
	 	s PLIST(13)=NextRole
	 	s PLIST(14)=NextStep
	 	s PLIST(15)=""
	 	s PLIST(16)=""
	 	
	 	&SQL(update sqluser.DHC_EQArgumentation values :PLIST() where AR_RowID=:ARRowID)
	 	i SQLCODE
	 	{
		 	i TransFlag'="N" TROLLBACK
		 	q SQLCODE
	 	}
	 	i TransFlag'="N" TCOMMIT
	 	q ARRowID
	}
	if +AppType=2
	{
		s PLIST(16)=$p(val,"^",2)  //Role
	 	s PLIST(15)=$p(val,"^",3)  //Step
	 	s Opinion=$p(val,"^",4)  //Opinion
	 	s Remark=$p(val,"^",5)
	 	s ApproveSet=$P(^DHCEQArgumentation(ARRowID),"^",11)
	 	s NextApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, ARRowID, PLIST(15), PLIST(16))
 		s LastFlag=$p(NextApproveFlow,"^",1)
 		s PLIST(14)=$p(NextApproveFlow,"^",2)  //NextStep
 		s PLIST(13)=$p(NextApproveFlow,"^",3)  //NextRole
 		s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
 		i AutoAuditFlag="Y"
	 	{
		 	i PLIST(14)="" s PLIST(23)="2"
		 	i LastFlag="Y" s PLIST(23)="2"
		 	i (PLIST(14)="")||(LastFlag="Y")
		 	{
		 		s PLIST(2)=User
	 			s PLIST(3)=Date
	 			s PLIST(4)=Time
		 	}
	 	}
	 	i TransFlag'="N" TSTART
	 	&SQL(update sqluser.DHC_EQArgumentation values :PLIST() where AR_RowID=:ARRowID)
	 	i SQLCODE
	 	{
		 	i TransFlag'="N" TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, ARRowID, Opinion, Remark, PLIST(16), PLIST(15))
	 	if SQLCODE
	 	{
		 	i TransFlag'="N" TROLLBACK
			q SQLCODE
	 	}
	 	i TransFlag'="N" TCOMMIT
	 	q ARRowID
	}
	i +AppType=3
	{
		s PLIST(23)="2"
	 	s PLIST(2)=User
	 	s PLIST(3)=Date
	 	s PLIST(4)=Time
	 	i TransFlag'="N" TSTART
	 	&sql(update sqluser.DHC_EQArgumentation values :PLIST() where AR_RowID=:ARRowID)
	 	if SQLCODE
	 	{
		 	i TransFlag'="N" TROLLBACK
			q SQLCODE
	 	}
	 	i TransFlag'="N" TCOMMIT
	 	q ARRowID
	}
	i +AppType=4
	{
		s BRLID=$P(^DHCEQArgumentation(ARRowID),"^",43)
		s argid=""
		i TransFlag'="N" TSTART
		;&SQL(update sqluser.DHC_EQBuyRequestList set BRL_ArgumentationDR=:argid where BRL_RowID=:BRLID)
		;if SQLCODE
	 	;{
		; 	i TransFlag'="N" TROLLBACK
		;	q SQLCODE
	 	;}
	 	&SQL(delete from sqluser.DHC_EQArgumentation where AR_RowID=:ARRowID)
	 	if SQLCODE
	 	{
		 	i TransFlag'="N" TROLLBACK
			q SQLCODE
	 	}
	 	i TransFlag'="N" TCOMMIT
	 	q ARRowID
	}
	i +AppType=5
		{
			s PLIST(23)="0"
			s PLIST(18)=$p(val,"^",2)
			s PLIST(19)=User
			s PLIST(20)=Date
			s PLIST(21)=Time
			i TransFlag'="N" TSTART
			&sql(update sqluser.DHC_EQArgumentation values :PLIST() where AR_RowID=:ARRowID)
		 	if SQLCODE
		 	{
			 	i TransFlag'="N" TROLLBACK
				q SQLCODE
		 	}
	i TransFlag'="N" TCOMMIT
	 	q ARRowID
	}
}

ClassMethod GetApproveSet(ARRowID)
{
	i ARRowID="" q ""
	q $P($G(^DHCEQArgumentation(ARRowID)),"^",11)
}

ClassMethod GetOneEquipData(BuyRequestListID)
{
	s (RequestLocID,RequestLoc,EquipName,Model,Manufacturer,EquipCat,priceFee)=""
	s BuyRequest=$P($G(^DHCEQBuyRequestList(BuyRequestListID)),"^",1)
	i BuyRequest'="" s RequestLocID=$P($G(^DHCEQBuyRequest(BuyRequest)),"^",2)
	i RequestLocID'="" s RequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",RequestLocID)
	s EquipName=$P($G(^DHCEQBuyRequestList(BuyRequestListID)),"^",2)
	s ModelID=$P($G(^DHCEQBuyRequestList(BuyRequestListID)),"^",3)
	i ModelID'="" s Model=$P($G(^DHCEQCCode("DHCEQCModel",ModelID)),"^",2)
	s ManuID=$P($G(^DHCEQBuyRequestList(BuyRequestListID)),"^",4)
	i ManuID'="" s Manufacturer=$P($G(^DHCEQCCode("DHCEQCManufacturer",ManuID)),"^",1)
	s EquipCatID=$P($G(^DHCEQBuyRequestList(BuyRequestListID)),"^",15)
	i EquipCatID'="" s EquipCat=$P($G(^DHCEQCCode("DHCEQCEquipeCat",EquipCatID)),"^",2)
	s PriceFee=$P($G(^DHCEQBuyRequestList(BuyRequestListID)),"^",6)
	s Qty=$P($G(^DHCEQBuyRequestList(BuyRequestListID)),"^",7)
	s SumFee=$P($G(^DHCEQBuyRequestList(BuyRequestListID)),"^",8)
	q EquipName_"^"_Model_"^"_Manufacturer_"^"_EquipCat_"^"_PriceFee_"^"_RequestLoc_"^"_Qty_"^"_SumFee
}

ClassMethod GetOneArgumentation(rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQArgumentation(rowid)
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",1))
	s $p(result,"^",2)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",2),"date")	;AuditDate
	s resultex=resultex_"^"	;ApproveSetDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCApproveSet",$p(result,"^",11))),"^",2)
	s resultex=resultex_"^"	;NextRoleDR
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCApproveRole",$p(result,"^",12))),"^",2)
	s resultex=resultex_"^"	;ApproveRoleDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCApproveRole",$p(result,"^",15))),"^",2)
	s resultex=resultex_"^"	;RejectUserDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",18))
	s $p(result,"^",19)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",19),"date")	;RejectDate
	s resultex=resultex_"^"	;SubmitUserDR
	i $p(result,"^",23)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",23))
	s $p(result,"^",24)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",24),"date")	;SubmitDate
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",26)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",26))
	s $p(result,"^",27)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",27),"date")	;AddDate
	s resultex=resultex_"^"	;BuyRequestListDR
	i $p(result,"^",43)'=""  d
	.s resultex=resultex_$p($g(^DHCEQBuyRequestList($p(result,"^",43))),"^",1)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetArgumentation(ReplacesAD, QXType, ApproveRole, Type, StatusDR, EquipName, RequestLocDR, EquipTypeDR, PurchaseTypeDR, EquipCatDR, MinPrice, MaxPrice, WaitAD) As %Query(ROWSPEC = "TRowID:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TProductIntroduce:%String,TActuality:%String,TBuyReason:%String,TUseYearsNum:%String,TReclaimYearsNum:%String,TAffectAnalyse:%String,TCondicion:%String,TApproveSetDR:%String,TNextRoleDR:%String,TNextFlowStep:%String,TApproveStatu:%String,TApproveRoleDR:%String,TService:%String,TRejectReason:%String,TRejectUserDR:%String,TRejectDate:%String,TRejectTime:%String,TRemark:%String,TStatus:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TCountNum:%String,TUseRate:%String,TGoodRate:%String,TClinicEffect:%String,TUsePerWeekNum:%String,TWorkLoadPerWeekNum:%String,TUsePriceFee:%String,TYearIncomeFee:%String,TCostFee:%String,TSettleState:%String,TResourceState:%String,TPolluteState:%String,TOtherState:%String,TPersonnelState:%String,TBuyRequestListDR:%String,TAuditUser:%String,TApproveSet:%String,TNextRole:%String,TApproveRole:%String,TRejectUser:%String,TSubmitUser:%String,TAddUser:%String,TBuyRequestList:%String,TRequestListDR:%String,TName:%String,TEquipCatDR:%String,TEquipCat:%String,TModelDR:%String,TModel:%String,TManuFacDR:%String,TManuFac:%String,TPriceFee:%String,TQuantityNum:%String,TTotalFee:%String,TRequestDR:%String,TEquipTypeDR:%String,TEquipType:%String,TPurchaseTypeDR:%String,TPurchaseType:%String,TUrgencyFlag:%String,TRequestLocDR:%String,TRequestLoc:%String,TPurposeTypeDR:%String,TPurposeType:%String,TTestFlag:%String")
{
}

ClassMethod GetArgumentationExecute(ByRef qHandle As %Binary, ReplacesAD, QXType, ApproveRole, Type, StatusDR, EquipName, RequestLocDR, EquipTypeDR, PurchaseTypeDR, EquipCatDR, MinPrice, MaxPrice, WaitAD) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetArgumentation
	Quit $$$OK
BuildDataGetArgumentation
	if WaitAD'="on"
	{
		if ReplacesAD="on"
		{
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("3")
			s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
			s ALRowID=0
			f  s ALRowID=$o(^DHCEQApproveList(0,"Role",ApproveType,ApproveRole,ALRowID)) q:ALRowID=""  d
			.s ADUser=$p(^DHCEQApproveList(ALRowID),"^",6)
			.q:ADUser=CurUser
			.s rowid=$p(^DHCEQApproveList(ALRowID),"^",2)
			.d ResetVariablesGetArgumentation
			.d GetOneArgument
		}
		else
		{
			f  s rowid=$o(^DHCEQArgumentation(rowid))  quit:rowid=""  d
			.d ResetVariablesGetArgumentation
			.d GetOneArgument
		}
	}
	else
	{
		if Type="1"
		{
			f  s rowid=$o(^DHCEQArgumentation(0,"ApproveRole",1,ApproveRole,rowid))  quit:rowid=""  d
			.d ResetVariablesGetArgumentation
			.d GetOneArgument
			s rowid=0
			s ApproveSet=0
			s ApproveFlow=0
			s ApproveFlowStep=""
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("3")
			f  s ApproveSet=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveType,ApproveSet))  quit:ApproveSet=""  d
			.f   s ApproveFlow=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,ApproveRole,ApproveFlow))  quit:ApproveFlow=""  d
			..s ApproveFowStep=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlow),"^",3)
			..f   s rowid=$o(^DHCEQArgumentation(0,"ApproveSet",1,ApproveSet,ApproveFowStep,rowid))  quit:rowid=""  d
			...s Role=$p(^DHCEQArgumentation(rowid),"^",12)
			...q:Role'=""
			...s Approved=##class(web.DHCEQCApproveSet).HasApprove(ApproveType, rowid, ApproveFowStep, ApproveRole)
			...q:Approved>0
			...d ResetVariablesGetArgumentation
			...d GetOneArgument
		}
		if Type="2"
		{
			s rowid=0
			s NextStep=""
			f  s rowid=$o(^DHCEQArgumentation(0,"Status",1,rowid))  quit:rowid=""  d
			.s NextStep=$p($G(^DHCEQArgumentation(rowid)),"^",13)
			.q:NextStep'=""
			.d ResetVariablesGetArgumentation
			.d GetOneArgument
		}
	}
	quit
GetOneArgument
	s TRowID = rowid
 	s TRequestListDR=$p($g(^DHCEQArgumentation(rowid)),"^",43)
	s TName=$P($G(^DHCEQBuyRequestList(TRequestListDR)),"^",2)
	q:(EquipName'="")&&(TName'[EquipName)
	s TEquipCatDR=$P($G(^DHCEQBuyRequestList(TRequestListDR)),"^",15)
	q:(EquipCatDR'="")&&(EquipCatDR'=TEquipCatDR)
	i TEquipCatDR'="" s TEquipCat=$P($G(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
	s TModelDR=$P($G(^DHCEQBuyRequestList(TRequestListDR)),"^",3)
	i TModelDR'="" s TModel=$P($G(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TManuFacDR=$P($G(^DHCEQBuyRequestList(TRequestListDR)),"^",4)
	i TManuFacDR'="" s TManuFac=$P($G(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR)),"^",1)
	s TTestFlag=$P($G(^DHCEQBuyRequestList(TRequestListDR)),"^",5)
	s TPurposeTypeDR=$P($G(^DHCEQBuyRequestList(TRequestListDR)),"^",21)
	i TPurposeTypeDR'="" s TPurposeType=$P($G(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	s TPriceFee=$P($G(^DHCEQBuyRequestList(TRequestListDR)),"^",6)
	// Mozy	2010-12-30
	q:(MinPrice'="")&&(MaxPrice="")&&(TPriceFee<MinPrice)
	q:(MaxPrice'="")&&(MinPrice="")&&(TPriceFee>MaxPrice)
	q:(MaxPrice'="")&&(MinPrice'="")&&(TPriceFee>MaxPrice)&&(TPriceFee<MinPrice)
	s TQuantityNum=$P($G(^DHCEQBuyRequestList(TRequestListDR)),"^",7)
	s TTotalFee=$P($G(^DHCEQBuyRequestList(TRequestListDR)),"^",8)
	s TRequestDR=$P($G(^DHCEQBuyRequestList(TRequestListDR)),"^",1)
	s TRequestLocDR=$P($G(^DHCEQBuyRequest(TRequestDR)),"^",2)
	q:(RequestLocDR'="")&&(RequestLocDR'=TRequestLocDR)
	.q:(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TRequestLocDR))
	i TRequestLocDR'="" s TRequestLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	s TEquipTypeDR=$P($G(^DHCEQBuyRequest(TRequestDR)),"^",25)
	q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	i TEquipTypeDR'="" s TEquipType=$P($G(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TPurchaseTypeDR=$P($G(^DHCEQBuyRequest(TRequestDR)),"^",26)
	q:(PurchaseTypeDR'="")&&(PurchaseTypeDR'=TPurchaseTypeDR)
	i TPurchaseTypeDR'="" s TPurchaseType=$P($G(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	s TUrgencyFlag=$P($G(^DHCEQBuyRequest(TRequestDR)),"^",36)
	
	s TAuditUserDR = $p($g(^DHCEQArgumentation(rowid)),"^",1)
	i TAuditUserDR '=""  d
	.s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	s TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQArgumentation(rowid)),"^",2),"date")
	s TAuditTime = $p($g(^DHCEQArgumentation(rowid)),"^",3)
	s TProductIntroduce = $p($g(^DHCEQArgumentation(rowid)),"^",4)
	s TActuality = $p($g(^DHCEQArgumentation(rowid)),"^",5)
	s TBuyReason = $p($g(^DHCEQArgumentation(rowid)),"^",6)
	s TUseYearsNum = $p($g(^DHCEQArgumentation(rowid)),"^",7)
	s TReclaimYearsNum = $p($g(^DHCEQArgumentation(rowid)),"^",8)
	s TAffectAnalyse = $p($g(^DHCEQArgumentation(rowid)),"^",9)
	s TCondicion = $p($g(^DHCEQArgumentation(rowid)),"^",10)
	s TApproveSetDR = $p($g(^DHCEQArgumentation(rowid)),"^",11)
	i TApproveSetDR '=""  d
	.s TApproveSet = $p($g(^DHCEQCCode("DHCEQCApproveSet",TApproveSetDR)),"^",2)
	s TNextRoleDR = $p($g(^DHCEQArgumentation(rowid)),"^",12)
	i TNextRoleDR '=""  d
	.s TNextRole = $p($g(^DHCEQCCode("DHCEQCApproveRole",TNextRoleDR)),"^",2)
	s TNextFlowStep = $p($g(^DHCEQArgumentation(rowid)),"^",13)
	s TApproveStatu = $p($g(^DHCEQArgumentation(rowid)),"^",14)
	s TApproveRoleDR = $p($g(^DHCEQArgumentation(rowid)),"^",15)
	i TApproveRoleDR '=""  d
	.s TApproveRole = $p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR)),"^",2)
	s TService = $p($g(^DHCEQArgumentation(rowid)),"^",16)
	s TRejectReason = $p($g(^DHCEQArgumentation(rowid)),"^",17)
	s TRejectUserDR = $p($g(^DHCEQArgumentation(rowid)),"^",18)
	i TRejectUserDR '=""  d
	.s TRejectUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRejectUserDR)
	s TRejectDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQArgumentation(rowid)),"^",19),"date")
	s TRejectTime = $p($g(^DHCEQArgumentation(rowid)),"^",20)
	s TRemark = $p($g(^DHCEQArgumentation(rowid)),"^",21)
	s TStatus = $p($g(^DHCEQArgumentation(rowid)),"^",22)
	q:(StatusDR'="")&&(TStatus'=StatusDR)
	q:TStatus="0"
	s TStatus = ##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	s TSubmitUserDR = $p($g(^DHCEQArgumentation(rowid)),"^",23)
	i TSubmitUserDR '=""  d
	.s TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	s TSubmitDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQArgumentation(rowid)),"^",24),"date")
	s TSubmitTime = $p($g(^DHCEQArgumentation(rowid)),"^",25)
	s TAddUserDR = $p($g(^DHCEQArgumentation(rowid)),"^",26)
	i TAddUserDR '=""  d
	.s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQArgumentation(rowid)),"^",27),"date")
	s TAddTime = $p($g(^DHCEQArgumentation(rowid)),"^",28)
	s TCountNum = $p($g(^DHCEQArgumentation(rowid)),"^",29)
	s TUseRate = $p($g(^DHCEQArgumentation(rowid)),"^",30)
	s TGoodRate = $p($g(^DHCEQArgumentation(rowid)),"^",31)
	s TClinicEffect = $p($g(^DHCEQArgumentation(rowid)),"^",32)
	s TUsePerWeekNum = $p($g(^DHCEQArgumentation(rowid)),"^",33)
	s TWorkLoadPerWeekNum = $p($g(^DHCEQArgumentation(rowid)),"^",34)
	s TUsePriceFee = $p($g(^DHCEQArgumentation(rowid)),"^",35)
	s TYearIncomeFee = $p($g(^DHCEQArgumentation(rowid)),"^",36)
	s TCostFee = $p($g(^DHCEQArgumentation(rowid)),"^",37)
	s TSettleState = $p($g(^DHCEQArgumentation(rowid)),"^",38)
	s TResourceState = $p($g(^DHCEQArgumentation(rowid)),"^",39)
	s TPolluteState = $p($g(^DHCEQArgumentation(rowid)),"^",40)
	s TOtherState = $p($g(^DHCEQArgumentation(rowid)),"^",41)
	s TPersonnelState = $p($g(^DHCEQArgumentation(rowid)),"^",42)
	s TBuyRequestListDR = $p($g(^DHCEQArgumentation(rowid)),"^",43)
	d OutputRowGetArgumentation
	quit
OutputRowGetArgumentation
	s Data=$lb(TRowID,TAuditUserDR,TAuditDate,TAuditTime,TProductIntroduce,TActuality,TBuyReason,TUseYearsNum,TReclaimYearsNum,TAffectAnalyse,TCondicion,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatu,TApproveRoleDR,TService,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TRemark,TStatus,TSubmitUserDR,TSubmitDate,TSubmitTime,TAddUserDR,TAddDate,TAddTime,TCountNum,TUseRate,TGoodRate,TClinicEffect,TUsePerWeekNum,TWorkLoadPerWeekNum,TUsePriceFee,TYearIncomeFee,TCostFee,TSettleState,TResourceState,TPolluteState,TOtherState,TPersonnelState,TBuyRequestListDR,TAuditUser,TApproveSet,TNextRole,TApproveRole,TRejectUser,TSubmitUser,TAddUser,TBuyRequestList,TRequestListDR,TName,TEquipCatDR,TEquipCat,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TTotalFee,TRequestDR,TEquipTypeDR,TEquipType,TPurchaseTypeDR,TPurchaseType,TUrgencyFlag,TRequestLocDR,TRequestLoc,TPurposeTypeDR,TPurposeType,TTestFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetArgumentation
	s (TRowID,TAuditUserDR,TAuditDate,TAuditTime,TProductIntroduce,TActuality,TBuyReason,TUseYearsNum,TReclaimYearsNum,TAffectAnalyse,TCondicion,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatu,TApproveRoleDR,TService,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TRemark,TStatus,TSubmitUserDR,TSubmitDate,TSubmitTime,TAddUserDR,TAddDate,TAddTime,TCountNum,TUseRate,TGoodRate,TClinicEffect,TUsePerWeekNum,TWorkLoadPerWeekNum,TUsePriceFee,TYearIncomeFee,TCostFee,TSettleState,TResourceState,TPolluteState,TOtherState,TPersonnelState,TBuyRequestListDR,TAuditUser,TApproveSet,TNextRole,TApproveRole,TRejectUser,TSubmitUser,TAddUser,TBuyRequestList,TRequestListDR,TName,TEquipCatDR,TEquipCat,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TTotalFee,TRequestDR,TEquipTypeDR,TEquipType,TPurchaseTypeDR,TPurchaseType,TUrgencyFlag,TRequestLocDR,TRequestLoc,TPurposeTypeDR,TPurposeType,TTestFlag)=""
	quit
}

ClassMethod GetArgumentationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArgumentationExecute ]
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

ClassMethod GetArgumentationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArgumentationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQArgumentation).GetOpinionByRole(1,1)
ClassMethod GetOpinionByRole(buyreqlistid, role)
{
	new Opinion,AproveType,SourceID
	s Opinion=""
	s SourceID=$p($g(^DHCEQBuyRequestList(buyreqlistid)),"^",20)
	if SourceID'=""  d
	.s Opinion=##class(web.DHCEQApproveList).GetOpinionByRole("3",SourceID,role)
	i Opinion=""  d
	.s SourceID=$o(^DHCEQBuyPlanList(0,"BuyRequestList",buyreqlistid,0))
	.i SourceID'=""  d
	..s SourceID=$p($g(^DHCEQBuyPlanList(SourceID)),"^",1)
	..s Opinion=##class(web.DHCEQApproveList).GetOpinionByRole("2",SourceID,role)
	
	q Opinion
}

Storage Default
{
<Data name="DHCEQArgumentationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQArgumentationD</DataLocation>
<DefaultData>DHCEQArgumentationDefaultData</DefaultData>
<IdLocation>^web.DHCEQArgumentationD</IdLocation>
<IndexLocation>^web.DHCEQArgumentationI</IndexLocation>
<StreamLocation>^web.DHCEQArgumentationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
