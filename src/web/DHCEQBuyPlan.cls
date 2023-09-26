Class web.DHCEQBuyPlan Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 280;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "BP_Remark";

Parameter SQLFILTER = "(BP_Status = '2' and BP_PlanType <> '1')";

Parameter SQLDESCRIPTION = "BP_PlanName";

Parameter SQLROWID = "BP_RowID";

ClassMethod UpdateData(val, AppType, TransFlag)
{
	new PLIST,BuyPlanType
	s BuyPlanType=""
	s BPRowID=$p(val,"^",1)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("2")
	i BPRowID'="" s BuyPlanType=$p(^DHCEQBuyPlan(BPRowID),"^",26)
	;i BuyPlanType="2" s ApproveType=##class(web.DHCEQApproveList).GetApproveType("8")
	i BuyPlanType="2" s ApproveType=##class(web.DHCEQApproveList).GetApproveType("12")
	s BuyApproveType=##class(web.DHCEQApproveList).GetApproveType("4")
	if +AppType=0 //新增，更新
	{
		s PLIST(2) = $p(val,"^",2)	;PlanName
 		s PLIST(3) = $p(val,"^",3)	;QuantityNum
 		s PLIST(4) = $p(val,"^",4)	;TotalFee
 		s PLIST(5) = $p(val,"^",5)	;Remark
 		s PLIST(6) = $p(val,"^",6)	;PlanDate
 		i $p(val,"^",6)'=""  s PLIST(6) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"date")	;PlanDate
 		s PLIST(7) = AppType //$p(val,"^",7)	;Status
 		/*s PLIST(8) = $p(val,"^",8)	;ApproveSetDR
 		s PLIST(9) = $p(val,"^",9)	;NextRoleDR
 		s PLIST(10) = $p(val,"^",10)	;NextFlowStep
 		s PLIST(11) = $p(val,"^",11)	;ApproveStatu
 		s PLIST(12) = $p(val,"^",12)	;ApproveRoleDR*/
 		s PLIST(13) = $p(val,"^",13)	;EquipTypeDR
 		/*s PLIST(14) = $p(val,"^",14)	;SubmitUserDR
 		s PLIST(15) = $p(val,"^",15)	;SubmitDate
 		i $p(val,"^",15)'=""  s PLIST(15) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",15),"date")	;SubmitDate
 		s PLIST(16) = $p(val,"^",16)	;SubmitTime
 		s PLIST(17) = $p(val,"^",17)	;AuditUserDR
 		s PLIST(18) = $p(val,"^",18)	;AuditDate
 		i $p(val,"^",18)'=""  s PLIST(18) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",18),"date")	;AuditDate
 		s PLIST(19) = $p(val,"^",19)	;AuditTime
 		s PLIST(20) = $p(val,"^",20)	;AddUserDR
 		s PLIST(21) = $p(val,"^",21)	;AddDate
 		i $p(val,"^",21)'=""  s PLIST(21) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",21),"date")	;AddDate
 		s PLIST(22) = $p(val,"^",22)	;AddTime
 		s PLIST(23) = $p(val,"^",23)	;UpdateUserDR
 		s PLIST(24) = $p(val,"^",24)	;UpdateDate
 		i $p(val,"^",24)'=""  s PLIST(24) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",24),"date")	;UpdateDate
 		s PLIST(25) = $p(val,"^",25)	;UpdateTime*/
 		s PLIST(26) = $p(val,"^",26)	;PlanNo
 		s PLIST(27) = $p(val,"^",27)	;PlanType
 		s PLIST(28) = $p(val,"^",28)	;PlanYear
 		s PLIST(29) = $p(val,"^",29)	;PurchaseTypeDR
 		/*s PLIST(30) = $p(val,"^",30)	;RejectReason
 		s PLIST(31) = $p(val,"^",31)	;RejectUserDR
 		s PLIST(32) = $p(val,"^",32)	;RejectDate
 		i $p(val,"^",32)'=""  s PLIST(32) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",32),"date")	;RejectDate
 		s PLIST(33) = $p(val,"^",33)	;RejectTime*/
 		s PLIST(34) = $p(val,"^",34)	;UrgencyFlag
 		i $p(val,"^",34)'=""  s PLIST(34) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",34),"bool")	;UrgencyFlag
 		/*s PLIST(35) = $p(val,"^",35)	;BuyAuditUserDR
 		s PLIST(36) = $p(val,"^",36)	;BuyAuditDate
 		i $p(val,"^",36)'=""  s PLIST(36) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",36),"date")	;BuyAuditDate
 		s PLIST(37) = $p(val,"^",37)	;BuyAuditTime
 		s PLIST(38) = $p(val,"^",38)	;BuyRemark
 		s PLIST(39) = $p(val,"^",39)	;BuyStatus
 		s PLIST(40) = $p(val,"^",40)	;Hold1
 		s PLIST(41) = $p(val,"^",41)	;Hold2*/
 		s PLIST(43) = $p(val,"^",42)
 		i PLIST(27)="1"
 		{
 			s YearNum=..IsUniqueYear(BPRowID, PLIST(28), PLIST(13))
 			i YearNum>0 q -1001
 		}
 		i TransFlag'="N" TSTART
 		if BPRowID=""
 		{
	 		s PLIST(20)=User
	 		s PLIST(21)=Date
	 		s PLIST(22)=Time
	 		i PLIST(26)="" s PLIST(26)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQBuyPlan",+$H,"",$p(val,"^",13))	// Mozy	2016-10-21
	 		&sql(insert into sqluser.DHC_EQBuyPlan values :PLIST())
	 		if SQLCODE
	 		{
		 		i TransFlag'="N" TROLLBACK
		 		q SQLCODE
	 		}
	 		s BPID=$G(%ROWID)
 		}
 		else
 		{
	 		s PLIST(23)=User
	 		s PLIST(24)=Date
	 		s PLIST(25)=Time
	 		&sql(update sqluser.DHC_EQBuyPlan values :PLIST() where BP_ROWID=:BPRowID)
	 		if SQLCODE
	 		{
		 		i TransFlag'="N" TROLLBACK
		 		q SQLCODE
	 		}
	 		s BPID=$G(%ROWID)
 		}
 		i TransFlag'="N" TCOMMIT
	 	q BPID
	}
	if +AppType=1 //提交
	{
		s PLIST(7)=AppType
	 	s PLIST(14)=User
	 	s PLIST(15)=Date
	 	s PLIST(16)=Time
	 	s PlanType=$P(^DHCEQBuyPlan(BPRowID),"^",26)
	 	s YearFlag="N"
	 	i PlanType'="0" s YearFlag="Y"
	 	s EquipType=$P(^DHCEQBuyPlan(BPRowID),"^",12)
	 	s PurchaseType=$P(^DHCEQBuyPlan(BPRowID),"^",28)
	 	s MaxPrice=..GetMaxPrice(BPRowID)
	 	s SpecialType=..GetSpecialType(BPRowID)
	 	i SpecialType<0 q -4006
	 	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag)
	 	i ApproveSet="" q -4007
	 	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,BPRowID,"2",User)
	 	i SQLCODE
	 	{
		 	i TransFlag'="N" TROLLBACK
		 	q SQLCODE
	 	}
	 	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, BPRowID, 0, "")
	 	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	 	s LastFlag=$P(ApproveFlow,"^",1)
	 	s NextStep=$P(ApproveFlow,"^",2)
	 	s NextRole=$P(ApproveFlow,"^",3)
	 	s PLIST(8)=ApproveSet
	 	s PLIST(9)=NextRole
	 	s PLIST(10)=NextStep
	 	s PLIST(11)=""
	 	s PLIST(12)=""
	 	i AutoAuditFlag="Y"
	 	{
		 	i NextStep="" s PLIST(7)="2"
		 	i LastFlag="Y" s PLIST(7)="2"
		 	i (NextStep="")||(LastFlag="Y")
		 	{
			 	//BuyApprove
			 	s BuyApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(BuyApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag)
		 		i BuyApproveSet="" q -4007
		 		s BuyApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(BuyApproveSet, BuyApproveType, BPRowID, 0, "")
		 		s BuyAutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",BuyApproveSet),"^",9)
		 		s BuyLastFlag=$P(BuyApproveFlow,"^",1)
		 		s BuyNextStep=$P(BuyApproveFlow,"^",2)
		 		s BuyNextRole=$P(BuyApproveFlow,"^",3)
		 		s PLIST(17)=User //PlanAudit
	 			s PLIST(18)=Date
	 			s PLIST(19)=Time
	 			s PLIST(39)="1"
	 			i BuyAutoAuditFlag="Y"
	 			{
		 			i BuyNextStep="" s PLIST(39)="2"
		 			i BuyLastFlag="Y" s PLIST(39)="2"
		 			i (BuyNextStep="")||(BuyLastFlag="Y")
		 			{
			 			s PLIST(35)=User //BuyAudit
			 			s PLIST(36)=Date
			 			s PLIST(37)=Time
		 			}
	 			}
	 			s PLIST(9)=BuyNextRole //BuyApprove
	 			s PLIST(10)=BuyNextStep
	 			s PLIST(40)=""
	 			s PLIST(41)=""
	 			s PLIST(42)=BuyApproveSet
		 	}
	 	}
	 	
	 	i TransFlag'="N" TSTART
	 	&sql(update sqluser.DHC_EQBuyPlan values :PLIST() where BP_ROWID=:BPRowID)
	 	if SQLCODE
	 	{
		 	i TransFlag'="N" TROLLBACK
			q SQLCODE
	 	}
	 	s BPID=$G(%ROWID)
	 	i TransFlag'="N" TCOMMIT
	 	q BPID
	}
	if +AppType=2 //审批
	{
		s PLIST(12)=$p(val,"^",2)  //Role
	 	s PLIST(11)=$p(val,"^",3)  //Step
	 	s Opinion=$p(val,"^",4)  //Opinion
	 	s Remark=$p(val,"^",5)
	 	s ApproveSet=$P(^DHCEQBuyPlan(BPRowID),"^",7)
	 	s NextApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, BPRowID, PLIST(11), PLIST(12))
 		s LastFlag=$p(NextApproveFlow,"^",1)
 		s PLIST(10)=$p(NextApproveFlow,"^",2)  //NextStep
 		s PLIST(9)=$p(NextApproveFlow,"^",3)  //NextRole
 		s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
 		i AutoAuditFlag="Y"
	 	{
		 	i PLIST(10)="" s PLIST(7)="2"
		 	i LastFlag="Y" s PLIST(7)="2"
		 	i (PLIST(10)="")||(LastFlag="Y")
		 	{
			 	s EquipType=$P(^DHCEQBuyPlan(BPRowID),"^",13)
			 	s PurchaseType=$P(^DHCEQBuyPlan(BPRowID),"^",29)
			 	s SpecialType=..GetSpecialType(BPRowID)
	 			i SpecialType<0 q -4006
	 			s MaxPrice=..GetMaxPrice(BPRowID)
	 			s PlanType=$P(^DHCEQBuyPlan(BPRowID),"^",26)
	 			s YearFlag="N"
	 			i PlanType'="0" s YearFlag="Y"
		 		s BuyApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(BuyApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag)
		 		i BuyApproveSet="" q -4007_"Buy"
		 		s BuyApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(BuyApproveSet, BuyApproveType, BPRowID, 0, "")
		 		s BuyAutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",BuyApproveSet),"^",9)
		 		s BuyLastFlag=$P(BuyApproveFlow,"^",1)
		 		s BuyNextStep=$P(BuyApproveFlow,"^",2)
		 		s BuyNextRole=$P(BuyApproveFlow,"^",3)
		 		s PLIST(17)=User //PlanAudit
	 			s PLIST(18)=Date
	 			s PLIST(19)=Time
	 			s PLIST(39)="1"
	 			i BuyAutoAuditFlag="Y"
	 			{
		 			i BuyNextStep="" s PLIST(39)="2"
		 			i BuyLastFlag="Y" s PLIST(39)="2"
		 			i (BuyNextStep="")||(BuyLastFlag="Y")
		 			{
			 			s PLIST(35)=User //BuyAudit
			 			s PLIST(36)=Date
			 			s PLIST(37)=Time
		 			}
	 			}
	 			s PLIST(9)=BuyNextRole //BuyApprove
	 			s PLIST(10)=BuyNextStep
	 			s PLIST(40)=""
	 			s PLIST(41)=""
	 			s PLIST(42)=BuyApproveSet
		 	}
	 	}
		i TransFlag'="N" TSTART
	 	&sql(update sqluser.DHC_EQBuyPlan values :PLIST() where BP_ROWID=:BPRowID)
	 	if SQLCODE
	 	{
		 	i TransFlag'="N" TROLLBACK
			q SQLCODE
	 	}
	 	s BPID=$G(%ROWID)
	 	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, BPRowID, Opinion, Remark, PLIST(12), PLIST(11))
	 	if SQLCODE
	 	{
		 	i TransFlag'="N" TROLLBACK
			q SQLCODE
	 	}
	 	i TransFlag'="N" TCOMMIT
	 	q BPID
	}
	if +AppType=3 //删除
	{
		i TransFlag'="N" TSTART
		&sql(delete from sqluser.DHC_EQBuyPlanList where BPL_BuyPlanDR=:BPRowID)
		if (SQLCODE'=0)&&(SQLCODE'=100)
	 	{
		 	i TransFlag'="N" TROLLBACK
			q SQLCODE
	 	}
	 	&sql(delete from sqluser.DHC_EQBuyPlan where BP_ROWID=:BPRowID)
	 	if SQLCODE
	 	{
		 	i TransFlag'="N" TROLLBACK
			q SQLCODE
	 	}
	 	i TransFlag'="N" TCOMMIT
	 	q ""
	}
	if +AppType=4 //反提交
	{
		s PLIST(30)=$p(val,"^",2)
	 	s PLIST(7)="0"
	 	s PLIST(31)=User
	 	s PLIST(32)=Date
	 	s PLIST(33)=Time
	 	s PLIST(39)=""
	 	i TransFlag'="N" TSTART
	 	&sql(update sqluser.DHC_EQBuyPlan values :PLIST() where BP_ROWID=:BPRowID)
	 	if SQLCODE
	 	{
		 	i TransFlag'="N" TROLLBACK
			q SQLCODE
	 	}
	 	s BPID=$G(%ROWID)
	 	i TransFlag'="N" TCOMMIT
	 	q BPID
	}
	if +AppType=5  //审核
 	{
	 	s PLIST(7)="2"
	 	s PLIST(17)=User
	 	s PLIST(18)=Date
	 	s PLIST(19)=Time
	 	s PLIST(39)="1"
	 	//BuyAudit
	 	s EquipType=$P(^DHCEQBuyPlan(BPRowID),"^",13)
		s PurchaseType=$P(^DHCEQBuyPlan(BPRowID),"^",29)
		s SpecialType=..GetSpecialType(BPRowID)
	 	i SpecialType<0 q -4006
	 	s MaxPrice=..GetMaxPrice(BPRowID)
	 	s PlanType=$P(^DHCEQBuyPlan(BPRowID),"^",26)
	 	s YearFlag="N"
	 	i PlanType'="0" s YearFlag="Y"
		i PlanType'="1"
		{
			s BuyApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(BuyApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag)
			i BuyApproveSet="" q -4007
			
			s BuyApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(BuyApproveSet, BuyApproveType, BPRowID, 0, "")
			s BuyAutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",BuyApproveSet),"^",9)
			s BuyLastFlag=$P(BuyApproveFlow,"^",1)
			s BuyNextStep=$P(BuyApproveFlow,"^",2)
			s BuyNextRole=$P(BuyApproveFlow,"^",3)
	 		i BuyAutoAuditFlag="Y"
	 		{
				i BuyNextStep="" s PLIST(39)="2"
				i BuyLastFlag="Y" s PLIST(39)="2"
		 		i (BuyNextStep="")||(BuyLastFlag="Y")
		 		{
					s PLIST(35)=User //BuyAudit
					s PLIST(36)=Date
					s PLIST(37)=Time
		 		}
	 		}
	 		s PLIST(9)=BuyNextRole //BuyApprove
	 		s PLIST(10)=BuyNextStep
	 		s PLIST(40)=""
	 		s PLIST(41)=""
	 		s PLIST(42)=BuyApproveSet
		}
	 	i TransFlag'="N" TSTART
	 	&sql(update sqluser.DHC_EQBuyPlan values :PLIST() where BP_ROWID=:BPRowID)
	 	if SQLCODE
	 	{
		 	i TransFlag'="N" TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
	 	i TransFlag'="N" TCOMMIT
	 	q ID
 	}
}

ClassMethod AllExec(RowID)
{
	s BPLID=0
	s SQLCODE=0
	TSTART
	&SQL(Update sqluser.DHC_EQBuyPlan set BP_BuyStatus='4' where BP_RowID=:RowID)
	f  s BPLID=$O(^DHCEQBuyPlanList(0,"BuyPlan",RowID,BPLID)) q:(BPLID="")||(SQLCODE'=0)  d
	.&SQL(Update sqluser.DHC_EQBuyPlanList set BPL_ExecNum=BPL_QuantityNum where BPL_RowID=:BPLID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q RowID
}

ClassMethod PartExec(RowID, Val)
{
	TSTART
	&SQL(Update sqluser.DHC_EQBuyPlan set BP_BuyStatus='3' where BP_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s i=$L(Val,"^")
	for j=1:1:i
	{
		s NumVal=$P(Val,"^",j)
		s BPLID=$P(NumVal,",",1)
		s ExecNum=$P(NumVal,",",2)
		&SQL(Update sqluser.DHC_EQBuyPlanList set BPL_ExecNum=:ExecNum where BPL_RowID=:BPLID)
		q:SQLCODE'=0
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q RowID
}

ClassMethod UpdateBuyData(val, Type)
{
	new PLIST
 	s BPRowID = $p(val,"^",1)
 	s PLIST(38)=$p(val,"^",6)
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	s Date=+$H
 	s Time=$P($H,",",2)
 	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("4")
 	TSTART
 	i +Type=0 //审批
 	{
	 	s PLIST(41)=$p(val,"^",2)  //Role
	 	s PLIST(40)=$p(val,"^",3)  //Step
	 	s Opinion=$p(val,"^",4)  //Opinion
	 	s Remark=$p(val,"^",5) 
	 	s ApproveSet=$P(^DHCEQBuyPlan(BPRowID),"^",41)
	 	s NextApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, BPRowID, PLIST(40), PLIST(41))
 		
 		s LastFlag=$p(NextApproveFlow,"^",1)
 		s PLIST(10)=$p(NextApproveFlow,"^",2)  //NextStep
 		s PLIST(9)=$p(NextApproveFlow,"^",3)  //NextRole
 		s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
 		i AutoAuditFlag="Y"
	 	{
		 	i PLIST(10)="" s PLIST(39)="2"
		 	i LastFlag="Y" s PLIST(39)="2"
		 	i (PLIST(10)="")||(LastFlag="Y")
		 	{
			 	s PLIST(35)=User
			 	s PLIST(36)=Date
			 	s PLIST(37)=Time
		 	}	
	 	}
	 	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, BPRowID, Opinion, Remark, PLIST(41), PLIST(40))
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	&sql(update sqluser.DHC_EQBuyPlan values :PLIST() where BP_ROWID=:BPRowID)
 	}
 	i +Type=1 //审核
 	{
	 	s PLIST(35)=User
		s PLIST(36)=Date
		s PLIST(37)=Time
		s PLIST(39)="2"
	 	&sql(update sqluser.DHC_EQBuyPlan values :PLIST() where BP_ROWID=:BPRowID)
 	}
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	s BPID=$G(%ROWID)
 	TCOMMIT
 	q BPID
}

ClassMethod ISHaveData(itms As %Library.String = "", itmsex As %Library.String = "", RowID)
{
	&sql(select BPL_RowID from sqluser.DHC_EQBuyPlanList where BPL_BuyPlanDR=:RowID)
	q SQLCODE
}

/// ///得到特殊设备的种类
/// ///返回值大于0就一种，返回ID
ClassMethod GetSpecialType(RowID)
{
	s BPLID=0
	s SpecialType=""
	s OtherSpecial=""
	s Flag="N"
	f  s BPLID=$o(^DHCEQBuyPlanList("BuyPlan",0,RowID,BPLID)) q:(BPLID="")||(Flag="Y")  d
	.s EquipCat=$P(^DHCEQBuyRequestList(BPLID),"^",16)
	.i EquipCat'="" s SpecialType=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCat),"^",5)
	.i SpecialType'=""&&OtherSpecial="" s OtherSpecial=SpecialType
	.i SpecialType'=""&&SpecialType'=OtherSpecial s Flag="Y"
	.s SpecialType=""
	i Flag="Y" q -1
	q OtherSpecial
}

ClassMethod GetOneBuyPlan(itms As %Library.String = "", itmsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQBuyPlan(rowid)
	s $p(result,"^",5)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")	;PlanDate
	s resultex=resultex_"^"	;ApproveSetDR
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCApproveSet",$p(result,"^",7))),"^",2)
	s resultex=resultex_"^"	;NextRoleDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCApproveRole",$p(result,"^",8))),"^",2)
	s resultex=resultex_"^"	;ApproveRoleDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCApproveRole",$p(result,"^",11))),"^",2)
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",12))),"^",2)
	s resultex=resultex_"^"	;SubmitUserDR
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",13))
	s $p(result,"^",14)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",14),"date")	;SubmitDate
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",16))
	s $p(result,"^",17)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",17),"date")	;AuditDate
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",19))
	s $p(result,"^",20)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",20),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",22)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",22))
	s $p(result,"^",23)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",23),"date")	;UpdateDate
	s resultex=resultex_"^"	;PurchaseTypeDR
	i $p(result,"^",28)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurchaseType",$p(result,"^",28))),"^",2)
	s resultex=resultex_"^"	;RejectUserDR
	i $p(result,"^",30)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",30))
	s $p(result,"^",31)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",31),"date")	;RejectDate
	s $p(result,"^",33)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",33),"bool")	;UrgencyFlag
	s resultex=resultex_"^"	;BuyAuditUserDR
	i $p(result,"^",34)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",34))
	s $p(result,"^",35)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",35),"date")	;BuyAuditDate
	s resultex=resultex_"^"	;PurposeTypeDR
	i $p(result,"^",42)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurposeType",$p(result,"^",42))),"^",2)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

ClassMethod SumRequest(RowID, User)
{
	s Return=0
	s Year=$P($G(^DHCEQBuyPlan(RowID)),"^",27)
	s PlanEquipType=$P($G(^DHCEQBuyPlan(RowID)),"^",12)
	s RequestDR=0
	TSTART
	f  s RequestDR=$o(^DHCEQBuyRequest(0,"Year",Year,RequestDR)) q:(RequestDR="")||(Return'=0)  d
	.s RequestEquipType=$P($G(^DHCEQBuyRequest(RequestDR)),"^",25)
	.q:PlanEquipType'=RequestEquipType
	.s Status=$P($G(^DHCEQBuyRequest(RequestDR)),"^",16)
	.q:Status'="2"
	.s YearFlag=$P($G(^DHCEQBuyRequest(RequestDR)),"^",3)
	.q:YearFlag="N"
	.s GatherFlag=$P($G(^DHCEQBuyRequest(RequestDR)),"^",7)
	.q:GatherFlag="Y"
	.s Return=..InsertPlanItem(RowID,RequestDR,User)
	.q:Return'=0
	i Return
	{
		TROLLBACK
		q Return
	}
	s SQLCODE=##class(web.DHCEQBuyPlanList).UpdateBuyPlan("","",RowID,"1")
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod InsertPlanItem(RowID, RequestDR, User)
{
	s Date=+$H
	s Time=$P($H,",",2)
	&SQL(update sqluser.DHC_EQBuyRequest set BR_GatherFlag='Y' where BR_RowID=:RequestDR)
	i SQLCODE
	{
		q SQLCODE
	}
	&SQL(update sqluser.DHC_EQBuyRequestList set BRL_BuyPlanDR=:RowID where BRL_BuyRequestDR=:RequestDR)
	i SQLCODE
	{
		q SQLCODE
	}
	&SQL(insert into sqluser.DHC_EQBuyPlanList (BPL_ItemDR,BPL_BuyPlanDR,BPL_Name,BPL_ModelDR,BPL_ManuFacDR,BPL_TestFlag,BPL_PriceFee,BPL_QuantityNum,BPL_TotalFee,BPL_BuyRequestListDR,BPL_UpdateUserDR,BPL_UpdateDate,BPL_UpdateTime,BPL_CurrencyDR,BPL_EquipCatDR,BPL_ArriveDate,BPL_Hold3,BPL_RefuseFlag) 
	select BRL_ItemDR,:RowID,BRL_Name,BRL_ModelDR,BRL_ManuFacDR,BRL_TestFlag,BRL_PriceFee,BRL_QuantityNum,BRL_TotalFee,BRL_RowID,:User,:Date,:Time,BRL_CurrencyDR,BRL_EquipCatDR,BRL_ArriveDate,BRL_Hold2,'N' from sqluser.DHC_EQBuyRequestList where BRL_BuyRequestDR=:RequestDR)
	i SQLCODE
	{
		q SQLCODE
	}
	q SQLCODE
}

ClassMethod GetStatus(BuyPlanDR)
{
	s Status=""
	&sql(select BP_Status into :Status from sqluser.DHC_EQBuyPlan where BP_RowID=:BuyPlanDR)
	q Status
}

Query GetBuyPlan(ReplacesAD, ApproveRole, PlanTypeList, Type, PlanName, StartDate, EndDate, StatusDR, PlanType, WaitAD) As %Query(ROWSPEC = "TRowID:%String,TPlanName:%String,TQuantityNum:%String,TTotalFee:%String,TRemark:%String,TPlanDate:%String,TStatus:%String,TApproveSetDR:%String,TNextRoleDR:%String,TNextFlowStep:%String,TApproveStatu:%String,TApproveRoleDR:%String,TEquipTypeDR:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TPlanNo:%String,TPlanType:%String,TPlanYear:%String,TPurchaseTypeDR:%String,TRejectReason:%String,TRejectUserDR:%String,TRejectDate:%String,TRejectTime:%String,TUrgencyFlag:%String,TBuyAuditUserDR:%String,TBuyAuditDate:%String,TBuyAuditTime:%String,TBuyRemark:%String,TBuyStatus:%String,TBuyApproveStatu:%String,TBuyApproveRoleDR:%String,TApproveSet:%String,TNextRole:%String,TApproveRole:%String,TEquipType:%String,TSubmitUser:%String,TAuditUser:%String,TAddUser:%String,TUpdateUser:%String,TPurchaseType:%String,TRejectUser:%String,TBuyAuditUser:%String,TBuyApproveRole:%String,TPurposeType:%String,TPurposeTypeDR:%String")
{
}

ClassMethod GetBuyPlanExecute(ByRef qHandle As %Binary, ReplacesAD, ApproveRole, PlanTypeList, Type, PlanName, StartDate, EndDate, StatusDR, PlanType, WaitAD) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetBuyPlan
	Quit $$$OK
BuildDataGetBuyPlan
	if WaitAD'="on"
	{
		if ReplacesAD="on"
		{
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("2")
			s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
			s ALRowID=0
			f  s ALRowID=$o(^DHCEQApproveList(0,"Role",ApproveType,ApproveRole,ALRowID)) q:ALRowID=""  d
			.s ADUser=$p(^DHCEQApproveList(ALRowID),"^",6)
			.q:ADUser=CurUser
			.s rowid=$p(^DHCEQApproveList(ALRowID),"^",2)
			.d ResetVariablesGetBuyPlan
			.d GetOnePlan
		}
		else
		{
			f  s rowid=$o(^DHCEQBuyPlan(rowid))  quit:rowid=""  d
			.d ResetVariablesGetBuyPlan
			.d GetOnePlan
		}
	}
	else
	{
		if Type="1"
		{
			f  s rowid=$o(^DHCEQBuyPlan(0,"ApproveRole",1,ApproveRole,rowid))  quit:rowid=""  d
			.d ResetVariablesGetBuyPlan
			.d GetOnePlan
			s rowid=0
			s ApproveSet=0
			s ApproveFlow=0
			s ApproveFlowStep=""
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("2")
			f  s ApproveSet=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveType,ApproveSet))  quit:ApproveSet=""  d
			.f   s ApproveFlow=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,ApproveRole,ApproveFlow))  quit:ApproveFlow=""  d
			..s ApproveFowStep=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlow),"^",3)
			..f   s rowid=$o(^DHCEQBuyPlan(0,"ApproveSet",1,ApproveSet,ApproveFowStep,rowid))  quit:rowid=""  d
			...s Role=$p(^DHCEQBuyPlan(rowid),"^",8)
			...q:Role'=""
			...s Approved=##class(web.DHCEQCApproveSet).HasApprove(ApproveType, rowid, ApproveFowStep, ApproveRole)
			...q:Approved>0
			...d ResetVariablesGetBuyPlan
			...d GetOnePlan
		}
		if Type="2"
		{
			s rowid=0
			s NextStep=""
			f  s rowid=$o(^DHCEQBuyPlan(0,"Status",1,rowid))  quit:rowid=""  d
			.s NextStep=$p(^DHCEQBuyPlan(rowid),"^",9)
			.q:NextStep'=""
			.d ResetVariablesGetBuyPlan
			.d GetOnePlan
		}
	}
	quit
	
GetOnePlan
	s TRowID = rowid
	q:(PlanName="")&&(StartDate="")&&(EndDate="")&&(StatusDR="")&&(WaitAD'="on")
	s TPlanName = $p($g(^DHCEQBuyPlan(rowid)),"^",1)
	q:(PlanName'="")&&(TPlanName'[PlanName)
	s TQuantityNum = $p($g(^DHCEQBuyPlan(rowid)),"^",2)
	s TTotalFee = $p($g(^DHCEQBuyPlan(rowid)),"^",3)
	s TRemark = $p($g(^DHCEQBuyPlan(rowid)),"^",4)
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	q:($p($g(^DHCEQBuyPlan(rowid)),"^",5)>EndDate)||($p($g(^DHCEQBuyPlan(rowid)),"^",5)<StartDate)
	s TPlanDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(rowid)),"^",5),"date")
	s TStatus = $p($g(^DHCEQBuyPlan(rowid)),"^",6)
	q:(StatusDR'="")&&(StatusDR'=TStatus)
	q:(Type="1")&&(StatusDR="")&&(TStatus="0")
	s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	s TApproveSetDR = $p($g(^DHCEQBuyPlan(rowid)),"^",7)
	i TApproveSetDR '=""  d
	.s TApproveSet = $p($g(^DHCEQCCode("DHCEQCApproveSet",TApproveSetDR)),"^",2)
	s TNextRoleDR = $p($g(^DHCEQBuyPlan(rowid)),"^",8)
	i TNextRoleDR '=""  d
	.s TNextRole = $p($g(^DHCEQCCode("DHCEQCApproveRole",TNextRoleDR)),"^",2)
	s TNextFlowStep = $p($g(^DHCEQBuyPlan(rowid)),"^",9)
	s TApproveStatu = $p($g(^DHCEQBuyPlan(rowid)),"^",10)
	s TApproveRoleDR = $p($g(^DHCEQBuyPlan(rowid)),"^",11)
	i TApproveRoleDR '=""  d
	.s TApproveRole = $p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR)),"^",2)
	s TEquipTypeDR = $p($g(^DHCEQBuyPlan(rowid)),"^",12)
	q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TSubmitUserDR = $p($g(^DHCEQBuyPlan(rowid)),"^",13)
	i TSubmitUserDR '=""  d
	.s TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	s TSubmitDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(rowid)),"^",14),"date")
	s TSubmitTime = $p($g(^DHCEQBuyPlan(rowid)),"^",15)
	s TAuditUserDR = $p($g(^DHCEQBuyPlan(rowid)),"^",16)
	i TAuditUserDR '=""  d
	.s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	s TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(rowid)),"^",17),"date")
	s TAuditTime = $p($g(^DHCEQBuyPlan(rowid)),"^",18)
	s TAddUserDR = $p($g(^DHCEQBuyPlan(rowid)),"^",19)
	i TAddUserDR '=""  d
	.s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(rowid)),"^",20),"date")
	s TAddTime = $p($g(^DHCEQBuyPlan(rowid)),"^",21)
	s TUpdateUserDR = $p($g(^DHCEQBuyPlan(rowid)),"^",22)
	i TUpdateUserDR '=""  d
	.s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(rowid)),"^",23),"date")
	s TUpdateTime = $p($g(^DHCEQBuyPlan(rowid)),"^",24)
	s TPlanNo = $p($g(^DHCEQBuyPlan(rowid)),"^",25)
	s TPlanType = $p($g(^DHCEQBuyPlan(rowid)),"^",26)
	q:(PlanType'="")&&(TPlanType'=PlanType)
	//q:((Type'="0")&&(WaitAD="on"))&&(TPlanType="1")
	q:(PlanType="")&&(PlanTypeList'="")&&(PlanTypeList'=TPlanType)
	s TPlanYear = $p($g(^DHCEQBuyPlan(rowid)),"^",27)
	s TPurchaseTypeDR = $p($g(^DHCEQBuyPlan(rowid)),"^",28)
	i TPurchaseTypeDR '=""  d
	.s TPurchaseType = $p($g(^DHCEQCCODE("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	s TRejectReason = $p($g(^DHCEQBuyPlan(rowid)),"^",29)
	s TRejectUserDR = $p($g(^DHCEQBuyPlan(rowid)),"^",30)
	i TRejectUserDR '=""  d
	.s TRejectUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRejectUserDR)
	s TRejectDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(rowid)),"^",31),"date")
	s TRejectTime = $p($g(^DHCEQBuyPlan(rowid)),"^",32)
	s TUrgencyFlag = $p($g(^DHCEQBuyPlan(rowid)),"^",33)
	s TBuyAuditUserDR = $p($g(^DHCEQBuyPlan(rowid)),"^",34)
	i TBuyAuditUserDR '=""  d
	.s TBuyAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TBuyAuditUserDR)
	s TBuyAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(rowid)),"^",35),"date")
	s TBuyAuditTime = $p($g(^DHCEQBuyPlan(rowid)),"^",36)
	s TBuyRemark = $p($g(^DHCEQBuyPlan(rowid)),"^",37)
	s TBuyStatus = $p($g(^DHCEQBuyPlan(rowid)),"^",38)
	s TBuyStatus = ..GetBuyStatu(TBuyStatus)
	s TBuyApproveStatu = $p($g(^DHCEQBuyPlan(rowid)),"^",39)
	s TBuyApproveRoleDR = $p($g(^DHCEQBuyPlan(rowid)),"^",40)
	i TBuyApproveRoleDR '=""  d
	.s TBuyApproveRole = $p($g(^DHCEQCCode("DHCEQCApproveRole",TBuyApproveRoleDR)),"^",2)
	s TPurposeTypeDR = $p($g(^DHCEQBuyPlan(rowid)),"^",41)
	i TPurposeTypeDR '="" d
	.s TPurposeType = $p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	d OutputRowGetBuyPlan
	quit

OutputRowGetBuyPlan
	s Data=$lb(TRowID,TPlanName,TQuantityNum,TTotalFee,TRemark,TPlanDate,TStatus,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatu,TApproveRoleDR,TEquipTypeDR,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TPlanNo,TPlanType,TPlanYear,TPurchaseTypeDR,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TUrgencyFlag,TBuyAuditUserDR,TBuyAuditDate,TBuyAuditTime,TBuyRemark,TBuyStatus,TBuyApproveStatu,TBuyApproveRoleDR,TApproveSet,TNextRole,TApproveRole,TEquipType,TSubmitUser,TAuditUser,TAddUser,TUpdateUser,TPurchaseType,TRejectUser,TBuyAuditUser,TBuyApproveRole,TPurposeType,TPurposeTypeDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBuyPlan
	s (TRowID,TPlanName,TQuantityNum,TTotalFee,TRemark,TPlanDate,TStatus,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatu,TApproveRoleDR,TEquipTypeDR,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TPlanNo,TPlanType,TPlanYear,TPurchaseTypeDR,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TUrgencyFlag,TBuyAuditUserDR,TBuyAuditDate,TBuyAuditTime,TBuyRemark,TBuyStatus,TBuyApproveStatu,TBuyApproveRoleDR,TApproveSet,TNextRole,TApproveRole,TEquipType,TSubmitUser,TAuditUser,TAddUser,TUpdateUser,TPurchaseType,TRejectUser,TBuyAuditUser,TBuyApproveRole,TPurposeType,TPurposeTypeDR)=""
	quit
}

ClassMethod GetBuyPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyPlanExecute ]
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

ClassMethod GetBuyPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetYearIDByYearDealID(YearDealID)
{
	new YearID,Year,EquipType,PlanID,Statu,PlanType,EquipTypeDR
	i YearDealID="" q ""
	s Year=$P($G(^DHCEQBuyPlan(YearDealID)),"^",27)
	s EquipType=$P($G(^DHCEQBuyPlan(YearDealID)),"^",12)
	s YearID=""
	s PlanID=0
	f  s PlanID=$o(^DHCEQBuyPlan(0,"PlanYear",Year,PlanID)) q:(PlanID="")||(YearID'="")  d
	.s Statu=$p(^DHCEQBuyPlan(PlanID),"^",6)
	.q:Statu'="2"
	.s PlanType=$p(^DHCEQBuyPlan(PlanID),"^",26)
	.q:PlanType'="1"
	.s EquipTypeDR=$p(^DHCEQBuyPlan(PlanID),"^",12)
	.q:EquipType'=EquipTypeDR
	.s YearID=PlanID
	q YearID
}

ClassMethod IsUniqueYear(PlanID, YearStr, EquipType)
{
	s Total=0
	if PlanID=""
	{
		&SQL(select count(BP_RowID) into :Total from sqluser.DHC_EQBuyPlan where BP_PlanType='1' and BP_PlanYear=:YearStr and BP_EquipTypeDR=:EquipType)
	}
	else
	{
		&SQL(select count(BP_RowID) into :Total from sqluser.DHC_EQBuyPlan where BP_PlanType='1' and BP_PlanYear=:YearStr and BP_RowID<>:PlanID and BP_EquipTypeDR=:EquipType)
	}
	i Total="" s Total=0
	q Total
}

ClassMethod PlanTypeList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>日常计划</option>"
	w "<option value=1>年度计划</option>"
	w "<option value=2>年度分配</option>"
	w "</select>",!
}

ClassMethod BuyStatusList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>"_##Class(web.DHCEQCommon).GetEditStatusDisplay("0")_"</option>"
	w "<option value=1>"_##Class(web.DHCEQCommon).GetEditStatusDisplay("1")_"</option>"
	w "<option value=2>"_##Class(web.DHCEQCommon).GetEditStatusDisplay("21")_"</option>"
	w "</select>",!
}

Query GetBuy(ReplacesAD, Type, PlanTypeList, PlanName, StartDate, EndDate, StatusDR, WaitAD, ApproveRole) As %Query(ROWSPEC = "TRowID:%String,TPlanName:%String,TQuantityNum:%String,TTotalFee:%String,TRemark:%String,TPlanDate:%String,TEquipTypeDR:%String,TPlanNo:%String,TPlanType:%String,TPlanYear:%String,TPurchaseTypeDR:%String,TRejectReason:%String,TUrgencyFlag:%String,TBuyRemark:%String,TBuyStatus:%String,TBuyApproveSetDR:%String,TEquipType:%String,TPurchaseType:%String")
{
}

ClassMethod GetBuyExecute(ByRef qHandle As %Binary, ReplacesAD, Type, PlanTypeList, PlanName, StartDate, EndDate, StatusDR, WaitAD, ApproveRole) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetBuy
	Quit $$$OK
BuildDataGetBuy
	if WaitAD'="on"
	{
		if ReplacesAD="on"
		{
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("4")
			s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
			s ALRowID=0
			f  s ALRowID=$o(^DHCEQApproveList(0,"Role",ApproveType,ApproveRole,ALRowID)) q:ALRowID=""  d
			.s ADUser=$p(^DHCEQApproveList(ALRowID),"^",6)
			.q:ADUser=CurUser
			.s rowid=$p(^DHCEQApproveList(ALRowID),"^",2)
			.d ResetVariablesGetBuy
			.d GetOneBuy
		}
		else
		{
			f  s rowid=$o(^DHCEQBuyPlan(0,"Status",2,rowid))  quit:rowid=""  d
			.d ResetVariablesGetBuy
			.d GetOneBuy
		}
	}
	else
	{
		if Type="1"
		{
			f  s rowid=$o(^DHCEQBuyPlan(0,"BuyApproveRole",1,ApproveRole,rowid))  quit:rowid=""  d
			.d ResetVariablesGetBuy
			.d GetOneBuy
			s rowid=0
			s ApproveSet=0
			s ApproveFlow=0
			s ApproveFlowStep=""
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("4")
			f  s ApproveSet=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveType,ApproveSet))  quit:ApproveSet=""  d
			.f   s ApproveFlow=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,ApproveRole,ApproveFlow))  quit:ApproveFlow=""  d
			..s ApproveFowStep=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlow),"^",3)
			..f   s rowid=$o(^DHCEQBuyPlan(0,"BuyApproveSet",1,ApproveSet,ApproveFowStep,rowid))  quit:rowid=""  d
			...s Role=$p(^DHCEQBuyPlan(rowid),"^",8)
			...q:Role'=""
			...s Approved=##class(web.DHCEQCApproveSet).HasApprove(ApproveType, rowid, ApproveFowStep, ApproveRole)
			...q:Approved>0
			...d ResetVariablesGetBuy
			...d GetOneBuy
		}
		if Type="2"
		{
			s rowid=0
			s NextStep=""
			f  s rowid=$o(^DHCEQBuyPlan(0,"BuyStatus",1,rowid))  quit:rowid=""  d
			.s NextStep=$p(^DHCEQBuyPlan(rowid),"^",9)
			.q:NextStep'=""
			.d ResetVariablesGetBuy
			.d GetOneBuy
		}
		if Type="3"
		{
			s rowid=0
			f  s rowid=$o(^DHCEQBuyPlan(0,"BuyStatus",2,rowid))  quit:rowid=""  d
			.d ResetVariablesGetBuy
			.d GetOneBuy
		}
	}
	quit
GetOneBuy
	s TRowID = rowid
	q:(PlanName="")&&(StartDate="")&&(EndDate="")&&(StatusDR="")&&(PlanTypeList="")&&(WaitAD'="on")
	s TPlanName = $p($g(^DHCEQBuyPlan(rowid)),"^",1)
	q:(PlanName'="")&&(TPlanName'[PlanName)
	s TQuantityNum = $p($g(^DHCEQBuyPlan(rowid)),"^",2)
	s TTotalFee = $p($g(^DHCEQBuyPlan(rowid)),"^",3)
	s TRemark = $p($g(^DHCEQBuyPlan(rowid)),"^",4)
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	q:($p($g(^DHCEQBuyPlan(rowid)),"^",5)>EndDate)||($p($g(^DHCEQBuyPlan(rowid)),"^",5)<StartDate)
	s TPlanDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(rowid)),"^",5),"date")
	s TEquipTypeDR = $p($g(^DHCEQBuyPlan(rowid)),"^",12)
	q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TPlanNo = $p($g(^DHCEQBuyPlan(rowid)),"^",25)
	s TPlanType = $p($g(^DHCEQBuyPlan(rowid)),"^",26)
	q:TPlanType="1"
	q:(PlanTypeList'="")&&(PlanTypeList'=TPlanType)
	s TPlanYear = $p($g(^DHCEQBuyPlan(rowid)),"^",27)
	s TPurchaseTypeDR = $p($g(^DHCEQBuyPlan(rowid)),"^",28)
	i TPurchaseTypeDR '=""  d
	.s TPurchaseType = $p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	s TUrgencyFlag = $p($g(^DHCEQBuyPlan(rowid)),"^",33)
	s TBuyRemark = $p($g(^DHCEQBuyPlan(rowid)),"^",37)
	s TBuyStatus = $p($g(^DHCEQBuyPlan(rowid)),"^",38)
	q:(StatusDR'="")&&(StatusDR'=TBuyStatus)
	q:(Type="3")&&(+TBuyStatus<2)
	s TBuyStatus = ..GetBuyStatu(TBuyStatus)
	s TBuyApproveSetDR = $p($g(^DHCEQBuyPlan(rowid)),"^",41)
	d OutputRowGetBuy
	quit
OutputRowGetBuy
	s Data=$lb(TRowID,TPlanName,TQuantityNum,TTotalFee,TRemark,TPlanDate,TEquipTypeDR,TPlanNo,TPlanType,TPlanYear,TPurchaseTypeDR,TRejectReason,TUrgencyFlag,TBuyRemark,TBuyStatus,TBuyApproveSetDR,TEquipType,TPurchaseType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBuy
	s (TRowID,TPlanName,TQuantityNum,TTotalFee,TRemark,TPlanDate,TEquipTypeDR,TPlanNo,TPlanType,TPlanYear,TPurchaseTypeDR,TRejectReason,TUrgencyFlag,TBuyRemark,TBuyStatus,TBuyApproveSetDR,TEquipType,TPurchaseType)=""
	quit
}

ClassMethod GetBuyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyExecute ]
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

ClassMethod GetBuyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CheckAudit(bpid)
{
	s maxfee="",addvalue="",opinion="",argvalue=""
	///取最高单价设备
	s maxfee=..GetMaxPrice(bpid)
	///取该单价设备的审批层次
	&SQL(select max(SS_AddValue) into :addvalue from sqluser.DHC_EQCSysSet 
	Where SS_Value<=:maxfee and SS_Code>='102001' and SS_Code<='102005')	
	if (addvalue="") q 0
	q addvalue
	/*s pos=15+(2*addvalue)
	s opinion=$p($g(^DHCEQBuyRequest(reqid)),"^",pos)
	if (opinion="") q 1*/
}

ClassMethod GetMaxPrice(bpid)
{
	s maxfee=""
	&SQL(select max(BPL_PriceFee) into :maxfee from sqluser.DHC_EQBuyPlanList Where BPL_BuyPlanDR=:bpid and BPL_RefuseFlag='N')
	q maxfee
}

Query GetStatus(Type) As %Query(ROWSPEC = "Status:%String:状态,ID:%String")
{
}

ClassMethod GetStatusExecute(ByRef qHandle As %Binary, Type) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	//s rowid=0
	d BuildDataGetStatus
	Quit $$$OK
BuildDataGetStatus
	i Type="0" d
	.s ID="0"
	.s Status=##Class(web.DHCEQCommon).GetEditStatusDisplay(ID)
	.d OutputRowGetStatus
	s ID="1"
	s Status=##Class(web.DHCEQCommon).GetEditStatusDisplay(ID)
	d OutputRowGetStatus
	s ID="2"
	s Status=##Class(web.DHCEQCommon).GetEditStatusDisplay(ID)
	d OutputRowGetStatus
	
	quit
OutputRowGetStatus
	s Data=$lb(Status,ID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStatus
	s (Status,ID)=""
	quit
}

ClassMethod GetStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatusExecute ]
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

ClassMethod GetStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod IsEndAudit(Type, BPID)
{
	S EndAudit=..CheckAudit(BPID)
	i Type=EndAudit q 1
	q 0
}

Query GetBuyStatus(Type) As %Query(ROWSPEC = "Status:%String,ID:%String")
{
}

ClassMethod GetBuyStatusExecute(ByRef qHandle As %Binary, Type) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	//s rowid=0
	d BuildDataGetBuyStatus
	Quit $$$OK
BuildDataGetBuyStatus
	i Type'="3" d
	.s ID="1"
	.s Status=..GetBuyStatu(ID)
	.d OutputRowGetBuyStatus
	s ID="2"
	s Status=..GetBuyStatu(ID)
	d OutputRowGetBuyStatus
	s ID="3"
	s Status=..GetBuyStatu(ID)
	d OutputRowGetBuyStatus
	s ID="4"
	s Status=..GetBuyStatu(ID)
	d OutputRowGetBuyStatus
	quit
OutputRowGetBuyStatus
	s Data=$lb(Status,ID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBuyStatus
	s (Status,ID)=""
	quit
}

ClassMethod GetBuyStatu(ID)
{
	i ID="" q ""
	q $CASE(ID,"0":"新增","1":"提交","2":"审核","3":"部分执行","4":"全部执行",:"没有定义")
}

ClassMethod GetBuyStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyStatusExecute ]
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

ClassMethod GetBuyStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CancelSumRequest(RowID)
{
	s Year=$P($G(^DHCEQBuyPlan(RowID)),"^",27)
	s PlanEquipType=$P($G(^DHCEQBuyPlan(RowID)),"^",12)
	s RequestDR=0
	s SQLCODE=0
	TSTART
	f  s RequestDR=$o(^DHCEQBuyRequest(0,"Year",Year,RequestDR)) q:(RequestDR="")||(SQLCODE'=0)  d
	.s RequestEquipType=$P($G(^DHCEQBuyRequest(RequestDR)),"^",25)
	.q:PlanEquipType'=RequestEquipType
	.s Status=$P($G(^DHCEQBuyRequest(RequestDR)),"^",16)
	.q:Status'="2"
	.s YearFlag=$P($G(^DHCEQBuyRequest(RequestDR)),"^",3)
	.q:YearFlag="N"
	.s GatherFlag=$P($G(^DHCEQBuyRequest(RequestDR)),"^",7)
	.q:GatherFlag="N"
	.&SQL(update sqluser.DHC_EQBuyRequest set BR_GatherFlag='N' where BR_RowID=:RequestDR)
	.q:SQLCODE'=0
	.&SQL(update sqluser.DHC_EQBuyRequestList set BRL_BuyPlanDR="" where BRL_BuyRequestDR=:RequestDR)
	.q:SQLCODE'=0
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(delete from sqluser.DHC_EQBuyPlanList where BPL_BuyPlanDR=:RowID)
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod GetDetail(BPID)
{
	new PlanType,BPLIDs
	s BPLIDs=""
	s PlanType=$p(^DHCEQBuyPlan(BPID),"^",26)
	i PlanType="1"
	{
		s Year=$p(^DHCEQBuyPlan(BPID),"^",27)
		s BPid=0
		f  s BPid=$o(^DHCEQBuyPlan(0,"PlanYear",Year,BPid)) q:BPid=""  d
		.d GetOneDetails(BPid)
	}
	else
	{
		d GetOneDetails(BPID)
	}
	q BPLIDs
GetOneDetails(BPid)
	new BPLID,Flag
	s BPLID=0
	f  s BPLID=$o(^DHCEQBuyPlanList(0,"BuyPlan",BPid,BPLID)) q:BPLID=""  d
	.s Flag=$p(^DHCEQBuyPlanList(BPLID),"^",21)
	.q:Flag="Y"
	.i BPLIDs="" d
	..s BPLIDs=BPLID
	.e  d
	..s BPLIDs=BPLIDs_"^"_BPLID
}

/// Mozy	2011-1-21
Query LookUpBuyPlan(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Remark:%String")
{
SELECT BP_PlanName,
	   BP_RowID,
	   BP_Remark
FROM sqluser.DHC_EQBuyPlan
where BP_Status = '2' and BP_PlanType <> '1' and BP_PlanName like nvl(:para,'')||'%'
}

}
