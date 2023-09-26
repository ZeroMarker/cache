Class web.DHCEQBuyRequest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 360;

Parameter SQLCODE = "BR_LocOpinion";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLFILTER = "(BR_Status='2' and BR_YearFlag='N')";

Parameter SQLDESCRIPTION = "BR_PrjName";

Parameter SQLROWID = "BR_RowID";

ClassMethod UpdateBuyRequest(val, AppType)
{
	new PLIST
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s BRRowID = $p(val,"^",1)	;RowID
	s CreatePlanFlag=##class(web.DHCEQCommon).GetSysInfo("101002")
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	if +AppType=0 //新增，更新
 	{
 		s PLIST(2) = $p(val,"^",2)	;PrjName
 		s PLIST(3) = $p(val,"^",3)	;RequestLocDR
 		s PLIST(4) = $p(val,"^",4)	;YearFlag
 		i $p(val,"^",4)'=""  s PLIST(4) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"bool")	;YearFlag
 		s PLIST(5) = $p(val,"^",5)	;UseLocDR
 		s PLIST(6) = $p(val,"^",6)	;Year
 		s PLIST(7) = $p(val,"^",7)	;RequestDate
 		i $p(val,"^",7)'=""  s PLIST(7) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"date")	;RequestDate
 		s PLIST(8) = $p(val,"^",8)	;GatherFlag
 		i $p(val,"^",8)'=""  s PLIST(8) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"bool")	;GatherFlag
 		s PLIST(9) = $p(val,"^",9)	;QuantityNum
 		s PLIST(10) = $p(val,"^",10)	;TotalFee
 		s PLIST(17) = AppType //$p(val,"^",17)	;Status
 		s PLIST(18) = $p(val,"^",18)	;Hold1
 		s PLIST(19) = $p(val,"^",19)	;Hold2
 		s PLIST(20) = $p(val,"^",20)	;Hold3
 		s PLIST(26) = $p(val,"^",26)	;EquipTypeDR
 		s PLIST(27) = $p(val,"^",27)	;PurchaseTypeDR
 		s PLIST(28) = $p(val,"^",28)	;Remark
 		s PLIST(35) = $p(val,"^",35)	;LocOpinion
 		s PLIST(36) = $p(val,"^",36)	;RequestNo
 		s PLIST(37) = $p(val,"^",37)	;UrgencyFlag
 		i $p(val,"^",37)'=""  s PLIST(37) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",37),"bool")	;UrgencyFlag
 		s PLIST(42) = $p(val,"^",42)  ;PurposeTypeDR
 		TSTART
 		if BRRowID=""
 		{
	 		s PLIST(29)=User
	 		s PLIST(30)=+$H
	 		s PLIST(31)=$P($H,",",2)
	 		
	 		//add by jdl 2006-08-23  在新增时自动按规则生成申请单号
	 		s requestno = ##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQBuyRequest",+$H)
	 		if requestno="" 
	 		{TRollBack
	 		 q -2102 
	 		}
 			i PLIST(36)="" s PLIST(36) = requestno
 			//jdl end
	 		
	 		&sql(insert into sqluser.DHC_EQBuyRequest values :PLIST())
	 		if SQLCODE
	 		{
		 		TROLLBACK
		 		q SQLCODE
	 		}
	 		s ID=$G(%ROWID)
 		}
 		else
 		{
	 		s PLIST(32)=User
	 		s PLIST(33)=+$H
	 		s PLIST(34)=$P($H,",",2)
	 		&sql(update sqluser.DHC_EQBuyRequest values :PLIST() where BR_ROWID=:BRRowID)
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
	 	s PLIST(17)=AppType
	 	s PLIST(11)=User
	 	s PLIST(12)=Date
	 	s PLIST(13)=Time
	 	s PLIST(35) = $p(val,"^",2)
	 	
	 	s EquipType=$P(^DHCEQBuyRequest(BRRowID),"^",25)
	 	s PurchaseType=$P(^DHCEQBuyRequest(BRRowID),"^",26)
	 	s YearFlag=$P(^DHCEQBuyRequest(BRRowID),"^",3)
	 	s MaxPrice=..GetMaxPrice(BRRowID)
	 	s SpecialType=..GetSpecialType(BRRowID)
	 	i SpecialType<0 q -4006
	 	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag)
	 	i ApproveSet="" q -4007
	 	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,BRRowID,"1",User)
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
		 	i NextStep="" s PLIST(17)="2"
		 	i LastFlag="Y" s PLIST(17)="2"
		 	i (NextStep="")||(LastFlag="Y")
		 	{
		 		s PLIST(14)=User
	 			s PLIST(15)=Date
	 			s PLIST(16)=Time
		 	}
	 	}
	 	s PLIST(21)=ApproveSet
	 	s PLIST(22)=NextRole
	 	s PLIST(23)=NextStep
	 	s PLIST(24)=""
	 	s PLIST(25)=""
	 	//i YearFlag="Y" s PLIST(37)="Y"
	 	TSTART
	 	&sql(update sqluser.DHC_EQBuyRequest values :PLIST() where BR_ROWID=:BRRowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
	 	i (CreatePlanFlag="1")&&(PLIST(17)="2")&&(YearFlag="N")
	 	{
		 	s SQLCODE=..CreatePlan(BRRowID_"^"_User,"N")
	 	}
	 	i SQLCODE<0
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	TCOMMIT
	 	q ID
 	}
 	if +AppType=2 //审批
 	{
	 	s YearFlag=$P(^DHCEQBuyRequest(BRRowID),"^",3)
	 	s Role=$p(val,"^",2)
	 	s PLIST(25)=Role  //Role
	 	s PLIST(24)=$p(val,"^",3)  //Step
	 	s Opinion=$p(val,"^",4)  //Opinion 	
	 	s Remark=$p(val,"^",5)
	 	s QXType=$p(val,"^",6)
	 	s YearFlag=$P(^DHCEQBuyRequest(BRRowID),"^",3)
	 	s PLIST(17)="1"
	 	s ApproveSet=$P(^DHCEQBuyRequest(BRRowID),"^",20)
	 	s NextApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, BRRowID, PLIST(24), PLIST(25))
 		s LastFlag=$p(NextApproveFlow,"^",1)
 		i (LastFlag="Y")&&(YearFlag="N")
 		{
	 		s ReturnValue=..ApproveFeeHadExceed(BRRowID, Role, QXType)
	 		i ReturnValue q ReturnValue
 		}
 		s PLIST(23)=$p(NextApproveFlow,"^",2)  //NextStep
 		s PLIST(22)=$p(NextApproveFlow,"^",3)  //NextRole
 		s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
 		i AutoAuditFlag="Y"
	 	{
		 	i PLIST(23)="" s PLIST(17)="2"
		 	i LastFlag="Y" s PLIST(17)="2"
		 	i (PLIST(23)="")||(LastFlag="Y")
		 	{
		 		s PLIST(14)=User
	 			s PLIST(15)=Date
	 			s PLIST(16)=Time
		 	}
	 	}
	 	if (PLIST(17)="2")
	 	{
		 	if ..CheckArgumentation(BRRowID, 2)=1 q -1003
		}
	 	TSTART
	 	s ARSubRole=##class(web.DHCEQCommon).GetSysInfo("101004")
	 	i $p(val,"^",2)=ARSubRole
	 	{
		 	s SQLCODE=..SubmitArgumentation(BRRowID)
		 	i SQLCODE
		 	{
			 	TROLLBACK
			 	q SQLCODE
		 	}
	 	}
	 	&sql(update sqluser.DHC_EQBuyRequest values :PLIST() where BR_RowID=:BRRowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	//s ReturnID=$G(%ROWID)
	 	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, BRRowID, Opinion, Remark, PLIST(25), PLIST(24))
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	i (CreatePlanFlag="1")&&(PLIST(17)="2")&&(YearFlag="N")
	 	{
		 	s SQLCODE=..CreatePlan(BRRowID_"^"_User,"N")
	 	}
	 	i SQLCODE<0
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
	 	&sql(delete from sqluser.DHC_EQBuyRequestList where BRL_BuyRequestDR=:BRRowID)
		if (SQLCODE<0)
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	&sql(delete from sqluser.DHC_EQBuyRequest where BR_RowID=:BRRowID)
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
	 	s PLIST(17)="0"
	 	s PLIST(38)=$p(val,"^",2)
	 	s PLIST(39)=User
	 	s PLIST(40)=Date
	 	s PLIST(41)=Time
	 	TSTART
	 	&sql(update sqluser.DHC_EQBuyRequest values :PLIST() where BR_ROWID=:BRRowID)
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
	 	s PLIST(17)="2"
	 	s PLIST(14)=User
	 	s PLIST(15)=Date
	 	s PLIST(16)=Time
	 	s YearFlag=$P(^DHCEQBuyRequest(BRRowID),"^",3)
	 	TSTART
	 	&sql(update sqluser.DHC_EQBuyRequest values :PLIST() where BR_ROWID=:BRRowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
	 	i (CreatePlanFlag="1")&&(PLIST(17)="2")&&(YearFlag="N")
	 	{
		 	s SQLCODE=..CreatePlan(BRRowID_"^"_User,"N")
	 	}
	 	i SQLCODE<0
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	TCOMMIT
	 	q ID
 	}
}

ClassMethod MustIsYear(BRID)
{
	s MaxFee=##class(web.DHCEQCommon).GetSysInfo("101005")
	i MaxFee="" q "0"
	s BRTotalFee=##class(web.DHCEQBuyRequestList).UpdateBuyRequest("","",BRID,"2")
	i +MaxFee<+BRTotalFee q "1"
	q "0"
}

/// 1需提交  2需审核
ClassMethod IsSubmitArg(BRID, Role)
{
	i BRID="" q 1
	i Role="" q 1
	s ARSubRole=##class(web.DHCEQCommon).GetSysInfo("101004")
	s ApproveSet=$p(^DHCEQBuyRequest(BRID),"^",20)
	i ApproveSet="" q 1
	s ApproveFlowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,Role,0))
	i ApproveFlowID="" q 1
	s SubFlowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,ARSubRole,0))
	i SubFlowID="" q 1
	s CurStep=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowID),"^",3)
	i ARSubRole'="" s SubStep=$p(^DHCEQCCode("DHCEQCApproveFlow",SubFlowID),"^",3)
	i ARSubRole="" s SubStep=0
	i CurStep="" s CurStep=0
	i +SubStep>=CurStep q 1
	q 2
}

ClassMethod SubmitArgumentation(BRID)
{
	s SQLCODE=0
	s BRLID=0
	f  s BRLID=$o(^DHCEQBuyRequestList(0,"BuyRequest",BRID,BRLID)) q:(BRLID="")||(SQLCODE<0)  d
	.s ARID=$p(^DHCEQBuyRequestList(BRLID),"^",20)
	.q:ARID=""
	.s SQLCODE=##class(web.DHCEQArgumentation).UpdateData(ARID_"^","1","N")
	i SQLCODE<0 q SQLCODE
	q 0
}

ClassMethod CreatePlan(val, TransFlag)
{
	new PLIST
	s Date=+$H
	s Time=$P($H,",",2)
	s BRRowID=$P(val,"^",1)
	s User=$P(val,"^",2)
	s SubFlag=##class(web.DHCEQCommon).GetSysInfo("102001")
	s PLIST(2)=$P(^DHCEQBuyRequest(BRRowID),"^",1) //计划名称
	//s PLIST(5)="由采购申请自动生成的采购计划" //2011-02-17 DJ
	s PLIST(6)=Date
	s PLIST(7)="0"
	s PLIST(13)=$P(^DHCEQBuyRequest(BRRowID),"^",25) //设备类型
	s PLIST(29)=$P(^DHCEQBuyRequest(BRRowID),"^",26) //申购类别
	s PLIST(34)=$P(^DHCEQBuyRequest(BRRowID),"^",36) //急购
	s PLIST(43)=$P(^DHCEQBuyRequest(BRRowID),"^",41) //设备用途
	s PLIST(20)=User
	s PLIST(21)=Date
	s PLIST(22)=Time
	s PLIST(26)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQBuyPlan",+$H) //计划单号
	s PLIST(27)="0"
	
	i TransFlag'="N" TSTART
	&SQL(Insert into sqluser.DHC_EQBuyPlan values :PLIST())
	i SQLCODE
	{
		i TransFlag'="N" TROLLBACK
		q SQLCODE
	}
	s BPRowID=$G(%ROWID)
	&sql(Insert Into SQLUser.DHC_EQBuyPlanList (BPL_ItemDR,BPL_BuyPlanDR,BPL_Name,BPL_ModelDR,BPL_ManuFacDR,BPL_TestFlag,BPL_PriceFee,BPL_QuantityNum,BPL_TotalFee,BPL_BuyRequestListDR,BPL_UpdateUserDR,BPL_UpdateDate,BPL_UpdateTime,BPL_CurrencyDR,BPL_EquipCatDR,BPL_Hold3,BPL_RefuseFlag,BPL_ArriveDate) 
	     select BRL_ItemDR,:BPRowID,BRL_Name,BRL_ModelDR, BRL_ManuFacDR,BRL_TestFlag ,BRL_PriceFee,BRL_QuantityNum,BRL_TotalFee,BRL_RowID,:User,:Date,:Time,BRL_CurrencyDR,BRL_EquipCatDR,BRL_Hold2,'N',BRL_ArriveDate from SQLUser.DHC_EQBuyRequestList where BRL_BuyRequestDR=:BRRowID and (BRL_BuyPlanDR is null or {fn LENGTH(BRL_BuyPlanDR)}=0))
	
	i SQLCODE'=0
	{
		i TransFlag'="N" TROLLBACK
		i SQLCODE=100 s SQLCODE=-100
		q SQLCODE
	}
	&SQL(update sqluser.DHC_EQBuyRequestList set BRL_BuyPlanDR=:BPRowID where BRL_BuyRequestDR=:BRRowID and (BRL_BuyPlanDR is null or {fn LENGTH(BRL_BuyPlanDR)}=0))
	i SQLCODE
	{
		i TransFlag'="N" TROLLBACK
		q SQLCODE
	}
	s SQLCODE=##class(web.DHCEQBuyPlanList).UpdateBuyPlan("","",BPRowID,1)
	i SQLCODE
	{
		i TransFlag'="N" TROLLBACK
		q SQLCODE
	}
	i SubFlag="1"
	{
		s SQLCODE=##class(web.DHCEQBuyPlan).UpdateData(BPRowID, "1","N")
	}
	i (SQLCODE<0)
	{
		i TransFlag'="N" TROLLBACK
		q SQLCODE
	}
	i TransFlag'="N" TCOMMIT
	q BPRowID
}

ClassMethod ISHaveData(itms As %Library.String = "", itmsex As %Library.String = "", RowID)
{
	&sql(select BRL_RowID from sqluser.DHC_EQBuyRequestList where BRL_BuyRequestDR=:RowID)
	q SQLCODE
}

ClassMethod GetOneBuyRequest(itms As %Library.String = "", itmsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQBuyRequest(rowid)
	s resultex=resultex_"^"	;RequestLocDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	s $p(result,"^",3)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",3),"bool")	;YearFlag
	s resultex=resultex_"^"	;UseLocDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",4))
	s $p(result,"^",6)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"date")	;RequestDate
	s $p(result,"^",7)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"bool")	;GatherFlag
	s resultex=resultex_"^"	;SubmitUserDR
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",10))
	s $p(result,"^",11)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;SubmitDate
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",13))
	s $p(result,"^",14)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",14),"date")	;AuditDate
	s resultex=resultex_"^"	;ApproveSetDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCApproveSet",$p(result,"^",20))),"^",2)
	s resultex=resultex_"^"	;NextRoleDR
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCApproveRole",$p(result,"^",21))),"^",2)
	s resultex=resultex_"^"	;ApproveRoleDR
	i $p(result,"^",24)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCApproveRole",$p(result,"^",24))),"^",2)
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",25)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",25))),"^",2)
	s resultex=resultex_"^"	;PurchaseTypeDR
	i $p(result,"^",26)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurchaseType",$p(result,"^",26))),"^",2)
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",28)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",28))
	s $p(result,"^",29)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",29),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",31)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",31))
	s $p(result,"^",32)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",32),"date")	;UpdateDate
	s $p(result,"^",36)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",36),"bool")	;UrgencyFlag
	s resultex=resultex_"^"	;RejectUserDR
	i $p(result,"^",38)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",38))
	s $p(result,"^",39)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",39),"date")	;RejectDate
	s resultex=resultex_"^"	;PurposeTypeDR
	i $p(result,"^",41)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurposeType",$p(result,"^",41))),"^",2)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

ClassMethod GetStatus(BuyRequestDR)
{
	i BuyRequestDR="" q ""
	s Status=""
	&sql(select BR_Status into :Status from sqluser.DHC_EQBuyRequest where BR_RowID=:BuyRequestDR)
	q Status
}

Query GetBuyRequest(ReplacesAD, QXType, ApproveRole, WaitAD, Type, RequestLocDR, YearFlag, StartDate, EndDate, StatusDR) As %Query(ROWSPEC = "TRowID:%String,TPrjName:%String,TRequestLocDR:%String,TYearFlag:%String,TUseLocDR:%String,TYear:%String,TRequestDate:%String,TGatherFlag:%String,TQuantityNum:%String,TTotalFee:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,TApproveSetDR:%String,TNextRoleDR:%String,TNextFlowStep:%String,TApproveStatus:%String,TApproveRoleDR:%String,TEquipTypeDR:%String,TPurchaseTypeDR:%String,TRemark:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TLocOpinion:%String,TRequestNo:%String,TUrgencyFlag:%String,TRejectReason:%String,TRejectUserDR:%String,TRejectDate:%String,TRejectTime:%String,TRequestLoc:%String,TUseLoc:%String,TSubmitUser:%String,TAuditUser:%String,TApproveSet:%String,TNextRole:%String,TApproveRole:%String,TEquipType:%String,TPurchaseType:%String,TAddUser:%String,TUpdateUser:%String,TRejectUser:%String,TPurposeTypeDR:%String,TPurposeType:%String")
{
}

ClassMethod GetBuyRequestExecute(ByRef qHandle As %Binary, ReplacesAD, QXType, ApproveRole, WaitAD, Type, RequestLocDR, YearFlag, StartDate, EndDate, StatusDR) As %Status
{
	//Type=0一般de
	//Type=1审批
	//Type=2审核
	//Type=3生成计划
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	s rowid=0
	d BuildDataGetBuyRequest
	Quit $$$OK
BuildDataGetBuyRequest
	if WaitAD'="on"
	{
		if ReplacesAD="1"
		{
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
			s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
			s ALRowID=0
			f  s ALRowID=$o(^DHCEQApproveList(0,"Role",ApproveType,ApproveRole,ALRowID)) q:ALRowID=""  d
			.s ADUser=$p(^DHCEQApproveList(ALRowID),"^",6)
			.q:ADUser=CurUser
			.s rowid=$p(^DHCEQApproveList(ALRowID),"^",2)
			.d ResetVariablesGetBuyRequest
			.d GetOneRequest
		}
		else
		{
			f  s rowid=$o(^DHCEQBuyRequest(rowid))  quit:rowid=""  d
			.d ResetVariablesGetBuyRequest
			.d GetOneRequest
		}
	}
	else
	{
		if Type="1"
		{
			f  s rowid=$o(^DHCEQBuyRequest(0,"ApproveRole",1,ApproveRole,rowid))  quit:rowid=""  d
			.d ResetVariablesGetBuyRequest
			.d GetOneRequest
			s rowid=0
			s ApproveSet=0
			s ApproveFlow=0
			s ApproveFlowStep=""
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
			f  s ApproveSet=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveType,ApproveSet))  quit:ApproveSet=""  d
			.f   s ApproveFlow=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,ApproveRole,ApproveFlow))  quit:ApproveFlow=""  d
			..s ApproveFowStep=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlow),"^",3)
			..f   s rowid=$o(^DHCEQBuyRequest(0,"ApproveSet",1,ApproveSet,ApproveFowStep,rowid))  quit:rowid=""  d
			...s Role=$p(^DHCEQBuyRequest(rowid),"^",21)
			...q:Role'=""
			...s Approved=##class(web.DHCEQCApproveSet).HasApprove(ApproveType, rowid, ApproveFowStep, ApproveRole)
			...q:Approved>0
			...d ResetVariablesGetBuyRequest
			...d GetOneRequest
		}
		if Type="2"
		{
			s rowid=0
			s NextStep=""
			f  s rowid=$o(^DHCEQBuyRequest(0,"Status",1,rowid))  quit:rowid=""  d
			.s NextStep=$p(^DHCEQBuyRequest(rowid),"^",22)
			.q:NextStep'=""
			.d ResetVariablesGetBuyRequest
			.d GetOneRequest
		}
		if Type="3"
		{
			s rowid=0
			f  s rowid=$o(^DHCEQBuyRequest(0,"Status",2,rowid))  quit:rowid=""  d
			.q:..IsHaveNoPlanDetail(rowid)
			.s Flag=$p(^DHCEQBuyRequest(rowid),"^",3)
			.q:Flag="Y"
			.d ResetVariablesGetBuyRequest
			.d GetOneRequest
		}	
	}
	quit
GetOneRequest
	s TRowID = rowid
	q:(RequestLocDR="")&&(YearFlag="")&&(StartDate="")&&(EndDate="")&&(StatusDR="")&&(WaitAD'="on")
	s TPrjName = $p($g(^DHCEQBuyRequest(rowid)),"^",1)
	s TRequestLocDR = $p($g(^DHCEQBuyRequest(rowid)),"^",2)
	i TRequestLocDR '=""  d
	.s TRequestLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	q:(RequestLocDR'="")&&(RequestLocDR'=TRequestLocDR)
	s TYearFlag = $p($g(^DHCEQBuyRequest(rowid)),"^",3)
	q:(YearFlag'="")&&(YearFlag'=TYearFlag)
	s TUseLocDR = $p($g(^DHCEQBuyRequest(rowid)),"^",4)
	i TUseLocDR '=""  d
	.s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	s TYear = $p($g(^DHCEQBuyRequest(rowid)),"^",5)
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	q:($p($g(^DHCEQBuyRequest(rowid)),"^",6)>EndDate)||($p($g(^DHCEQBuyRequest(rowid)),"^",6)<StartDate)
	s TRequestDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyRequest(rowid)),"^",6),"date")
	s TGatherFlag = $p($g(^DHCEQBuyRequest(rowid)),"^",7)
	s TQuantityNum = $p($g(^DHCEQBuyRequest(rowid)),"^",8)
	s TTotalFee = $p($g(^DHCEQBuyRequest(rowid)),"^",9)
	s TSubmitUserDR = $p($g(^DHCEQBuyRequest(rowid)),"^",10)
	i TSubmitUserDR '=""  d
	.s TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	s TSubmitDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyRequest(rowid)),"^",11),"date")
	s TSubmitTime = $p($g(^DHCEQBuyRequest(rowid)),"^",12)
	s TAuditUserDR = $p($g(^DHCEQBuyRequest(rowid)),"^",13)
	i TAuditUserDR '=""  d
	.s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	s TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyRequest(rowid)),"^",14),"date")
	s TAuditTime = $p($g(^DHCEQBuyRequest(rowid)),"^",15)
	s TStatus = $p($g(^DHCEQBuyRequest(rowid)),"^",16)
	q:(StatusDR'="")&&(StatusDR'=TStatus)
	q:((Type'="0")&&(StatusDR=""))&&(TStatus="0")
	s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	s THold1 = $p($g(^DHCEQBuyRequest(rowid)),"^",17)
	s THold2 = $p($g(^DHCEQBuyRequest(rowid)),"^",18)
	s THold3 = $p($g(^DHCEQBuyRequest(rowid)),"^",19)
	s TApproveSetDR = $p($g(^DHCEQBuyRequest(rowid)),"^",20)
	i TApproveSetDR '=""  d
	.s TApproveSet = $p($g(^DHCEQCCode("DHCEQCApproveSet",TApproveSetDR)),"^",2)
	s TNextRoleDR = $p($g(^DHCEQBuyRequest(rowid)),"^",21)
	i TNextRoleDR '=""  d
	.s TNextRole = $p($g(^DHCEQCCode("DHCEQCApproveRole",TNextRoleDR)),"^",2)
	s TNextFlowStep = $p($g(^DHCEQBuyRequest(rowid)),"^",22)
	s TApproveStatus = $p($g(^DHCEQBuyRequest(rowid)),"^",23)
	s TApproveRoleDR = $p($g(^DHCEQBuyRequest(rowid)),"^",24)
	i TApproveRoleDR '=""  d
	.s TApproveRole = $p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR)),"^",2)
	s TEquipTypeDR = $p($g(^DHCEQBuyRequest(rowid)),"^",25)
	q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TPurchaseTypeDR = $p($g(^DHCEQBuyRequest(rowid)),"^",26)
	i TPurchaseTypeDR '=""  d
	.s TPurchaseType = $p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	s TRemark = $p($g(^DHCEQBuyRequest(rowid)),"^",27)
	s TAddUserDR = $p($g(^DHCEQBuyRequest(rowid)),"^",28)
	i TAddUserDR '=""  d
	.s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyRequest(rowid)),"^",29),"date")
	s TAddTime = $p($g(^DHCEQBuyRequest(rowid)),"^",30)
	s TUpdateUserDR = $p($g(^DHCEQBuyRequest(rowid)),"^",31)
	i TUpdateUserDR '=""  d
	.s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyRequest(rowid)),"^",32),"date")
	s TUpdateTime = $p($g(^DHCEQBuyRequest(rowid)),"^",33)
	s TLocOpinion = $p($g(^DHCEQBuyRequest(rowid)),"^",34)
	s TRequestNo = $p($g(^DHCEQBuyRequest(rowid)),"^",35)
	s TUrgencyFlag = $p($g(^DHCEQBuyRequest(rowid)),"^",36)
	s TRejectReason = $p($g(^DHCEQBuyRequest(rowid)),"^",37)
	s TRejectUserDR = $p($g(^DHCEQBuyRequest(rowid)),"^",38)
	i TRejectUserDR '=""  d
	.s TRejectUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRejectUserDR)
	s TRejectDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyRequest(rowid)),"^",39),"date")
	s TRejectTime = $p($g(^DHCEQBuyRequest(rowid)),"^",40)
	s TPurposeTypeDR = $p($g(^DHCEQBuyRequest(rowid)),"^",41)
	i TPurposeTypeDR '="" d
	.s TPurposeType = $p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	s TUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s ^DHCEQTemp("jdl","buyrequest")="QXType:"_QXType_"  TRequestLocDR:"_TRequestLocDR_"  TUserID:"_TUserID_"  TPurposeTypeDR:"_TPurposeTypeDR
	q:(1=(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TRequestLocDR)))&&("N"=..GetUserLoc(TUserID,TRequestLocDR,TPurposeTypeDR)) 
	d OutputRowGetBuyRequest
	quit
OutputRowGetBuyRequest
	s Data=$lb(TRowID,TPrjName,TRequestLocDR,TYearFlag,TUseLocDR,TYear,TRequestDate,TGatherFlag,TQuantityNum,TTotalFee,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TStatus,THold1,THold2,THold3,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatus,TApproveRoleDR,TEquipTypeDR,TPurchaseTypeDR,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TLocOpinion,TRequestNo,TUrgencyFlag,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TRequestLoc,TUseLoc,TSubmitUser,TAuditUser,TApproveSet,TNextRole,TApproveRole,TEquipType,TPurchaseType,TAddUser,TUpdateUser,TRejectUser,TPurposeTypeDR,TPurposeType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBuyRequest
	s (TRowID,TPrjName,TRequestLocDR,TYearFlag,TUseLocDR,TYear,TRequestDate,TGatherFlag,TQuantityNum,TTotalFee,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TStatus,THold1,THold2,THold3,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatus,TApproveRoleDR,TEquipTypeDR,TPurchaseTypeDR,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TLocOpinion,TRequestNo,TUrgencyFlag,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TRequestLoc,TUseLoc,TSubmitUser,TAuditUser,TApproveSet,TNextRole,TApproveRole,TEquipType,TPurchaseType,TAddUser,TUpdateUser,TRejectUser,TPurposeTypeDR,TPurposeType)=""
	quit
}

ClassMethod GetBuyRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyRequestExecute ]
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

ClassMethod GetBuyRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modify By QW 2018-08-31 HISUI改造：自定义下拉列表显示格式错误
ClassMethod YearFlagList(name, width) As %String
{
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	;;下拉列表
	w "<option value=></option>"
	w "<option value=Y>是</option>"
	w "<option value=N>否</option>"
	w "</select>",!
}

ClassMethod IsVaildYear(Str)
{
	i ('(Str?4N)) q 1
	i (+Str > 2100) q 1
	i (+Str < 1900) q 1
	q 0
}

/// 审核时判断申请单是否已通过相关审批,通过返回0
ClassMethod CheckAudit(reqid)
{
	s maxfee="",addvalue="",opinion="",argvalue=""
	///取最高单价设备
	//&SQL(select max(BRL_PriceFee) into :maxfee from sqluser.DHC_EQBuyRequestList Where BRL_BuyRequestDR=:reqid)
	//if SQLCODE q SQLCODE
	//s maxfee=..GetMaxPrice(reqid)
	//if (maxfee=0) q 0
	///取该单价设备的审批层次
	s addvalue=..GetMaxAudit(reqid)
	q addvalue
	/*s pos=15+(2*addvalue)
	s opinion=$p($g(^DHCEQBuyRequest(reqid)),"^",pos)
	if (opinion="") q 1*/
}

ClassMethod IsEndAudit(Type, BRID)
{
	S EndAudit=..GetMaxAudit(BRID)
	i Type=EndAudit q 1
	q 0
}

ClassMethod IsHaveNoPlanDetail(BRID)
{
	&sql(select BRL_RowID from SQLUser.DHC_EQBuyRequestList where BRL_BuyRequestDR=:BRID and (BRL_BuyPlanDR is null or {fn LENGTH(BRL_BuyPlanDR)}=0))
	i SQLCODE'=0 q 1
	q 0
}

ClassMethod AuditStard(ApproveRole, Type, BRID, WaitAD)
{
	//Type=0新增
	//Type=1审批
	//Type=2审核
	//Type=3生成计划
	s ApproveSet=$P($G(^DHCEQBuyRequest(BRID)),"^",20)
	s CurStep=$P($G(^DHCEQBuyRequest(BRID)),"^",22) //待操作步骤
	s PStep=$P($G(^DHCEQBuyRequest(BRID)),"^",23) //已操作步骤
	s Status=$P($G(^DHCEQBuyRequest(BRID)),"^",16)
	i WaitAD'="on" q 0
	i Type="0" q 0
	i Type="3" 
	{
		i Status'="2" q 1
		q ..IsHaveNoPlanDetail(BRID)
	}
	i Type="1"
	{
		i Status'="1" q 1
		q ..IsApproveByRole(ApproveRole,ApproveSet,BRID,CurStep)
	}
	i Type="2"
	{
		
	}
}

ClassMethod IsApproveByRole(ApproveRole, ApproveSet, Source, CurStep)
{
	s ApproveType=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",1)
	s ^DHCEQTemp("jdl","Approve")="ApproveSet:"_ApproveSet_"  ApproveRole:"_ApproveRole_"  ApproveType:"_ApproveType_"  Source:"_Source
	s RoleStep=..GetRoleStep(ApproveSet,ApproveRole)
	i RoleStep="" q 1
	i CurStep'=RoleStep q 1
	q ..IsInApproveList(ApproveRole,ApproveType,Source,RoleStep)
}

ClassMethod IsInApproveList(ApproveRole, ApproveType, Source, RoleStep)
{
	s hasFlag=0
	s approvelistid=0
	f  s approvelistid=$o(^DHCEQApproveList(0,"Step",ApproveType,Source,RoleStep,approvelistid))  q:(approvelistid="")||(hasFlag="1")  d
	.i ApproveRole=$p(^DHCEQApproveList(approvelistid),"^",5) d
	..s hasFlag=1
	q hasFlag
}

ClassMethod GetRoleStep(ApproveSet, ApproveRole)
{
	s ApproveFlow=""
	s RoleStep=""
	s ApproveFLow=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,ApproveRole,ApproveFLow))
	i ApproveFlow'="" s RoleStep=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlow),"^",3)
	q RoleStep
}

ClassMethod GetMaxAudit(BRID)
{
	i BRID="" q 0
	s PriceFee=..GetMaxPrice(BRID)
	s addvalue=0
	&SQL(select max(SS_AddValue) into :addvalue from sqluser.DHC_EQCSysSet 
	Where SS_Value<=:PriceFee and SS_Code>='101001' and SS_Code<='101005')	
	if (addvalue="") q 0
	q addvalue
}

ClassMethod GetMaxPrice(BRID)
{
	s MaxPrice=""
	&SQL(select max(BRL_PriceFee) into :MaxPrice from sqluser.DHC_EQBuyRequestList Where BRL_BuyRequestDR=:BRID)
	i MaxPrice="" s MaxPrice=0
	q MaxPrice
}

ClassMethod CheckArgumentation(reqid, Statu)
{
	///检查是否有需要填写论证表但没有填写,填写的论证还需已通过审核
	///ReturnValue为0不需要或者已有论证 为1没有论证
	///Statu为1需有论证  为2论证需审核
	s ReturnValue=0
	s rowid=$o(^DHCEQCCode("DHCEQCSysSet",0,"Code","101001",0))
	i rowid="" q ReturnValue
	s argvalue=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",2)
	i (argvalue="") q ReturnValue
	s BRLID=0
	f  s BRLID=$o(^DHCEQBuyRequestList(0,"BuyRequest",reqid,BRLID)) q:(BRLID="")||(ReturnValue=1)  d
	.s Price=$p(^DHCEQBuyRequestList(BRLID),"^",6)
	.w Price,!
	.q:Price<argvalue
	.s ARID=$o(^DHCEQArgumentation(0,"BuyRequestList",BRLID,0))
	.i ARID="" s ReturnValue=1
	.q:ReturnValue=1
	.q:Statu="1"
	.s ARStatus=$p(^DHCEQArgumentation(ARID),"^",22)
	.i ARStatus'="2" s ReturnValue=1
	q ReturnValue
}

Query GetStatus(Type) As %Query(ROWSPEC = "Status:%String:状态,ID:%String:编码")
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

ClassMethod GetSpecialType(RowID)
{
	s BRLID=0
	s SpecialType=""
	s OtherSpecial=""
	s Flag="N"
	f  s BRLID=$o(^DHCEQBuyRequestList("BuyRequest",0,RowID,BRLID)) q:(BRLID="")||(Flag="Y")  d
	.s EquipCat=$P(^DHCEQBuyRequestList(BRLID),"^",15)
	.i EquipCat'="" s SpecialType=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCat),"^",5)
	.i SpecialType'=""&&OtherSpecial="" s OtherSpecial=SpecialType
	.i SpecialType'=""&&SpecialType'=OtherSpecial s Flag="Y"
	.s SpecialType=""
	i Flag="Y" q -1
	q OtherSpecial
}

/// N不可用  Y可用
ClassMethod GetUserLoc(UserID, LocID, PurposeTypeID)
{
	new Flag,UMLID
	s Flag="N"
	s UMLID=0
	f  s UMLID=$o(^DHCEQCCode("DHCEQCUserManagerLoc",0,"UserLoc",UserID,LocID,UMLID)) q:(UMLID="")||(Flag="Y")  d
	.s PurposeTypes=$p(^DHCEQCCode("DHCEQCUserManagerLoc",UMLID),"^",3)
	.s Flag=..StringIsIn(PurposeTypes,PurposeTypeID)
	q Flag
}

/// Y在里面  N不在里面
ClassMethod StringIsIn(Strings, String)
{
	new i,Flag
	i Strings="" q "Y"
	s i=$l(Strings,",")
	s Flag="N"
	for j=1:1:i
	{
		s Str=$p(Strings,",",j)
		i Str=String s Flag="Y"
		q:Flag="Y"
	}
	q Flag
}

/// 判断是否超过审批限额
/// 返回0没超过  －1月度超过  －2年度超过
ClassMethod ApproveFeeHadExceed(BRID, CurRole, QXType)
{
	new ApproveType,ReturnValue,MonthFee,YearFee,MaskDate,CurFee,Date,ApproveMonthFee,ApproveYearFee,MonthStartDate,YearStartDate
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	s Date=+$h
	s MaskDate=$ZD(Date,4)
	s $p(MaskDate,"/",1)=1
	s MonthStartDate=$ZDH(MaskDate,4)
	s $p(MaskDate,"/",2)=1
	s YearStartDate=$ZDH(MaskDate,4)
	s ApproveMonthFee=..GetHadApprovedFee(MonthStartDate,Date,CurRole,QXType)
	s ApproveYearFee=..GetHadApprovedFee(YearStartDate,Date,CurRole,QXType)
	s CurFee=$p(^DHCEQBuyRequest(BRID),"^",9)
	s MonthFee=ApproveMonthFee+CurFee
	s YearFee=ApproveYearFee+CurFee
	s ReturnValue=##class(web.DHCEQCRoleLimitAmount).ApproveFeeHadExceed(CurRole, ApproveType, MonthFee, YearFee)
	i ReturnValue<0 s ReturnValue=ReturnValue-1000
	q ReturnValue
}

/// 根据日期得到已审批金额
ClassMethod GetHadApprovedFee(StartDate, EndDate, CurRole, QXType)
{
	new BRID,Fee,OneFee,Date,Status,Role,RequestLocDR,User,YearFlag,PurposeTypeDR
	s Fee=0,OneFee=0
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	f Date=StartDate:1:EndDate
	{
		s BRID=0
		f  s BRID=$o(^DHCEQBuyRequest(0,"AuditDate",Date,BRID))  q:BRID=""  d
		.s Status=$p(^DHCEQBuyRequest(BRID),"^",16)
		.q:Status'="2"
		.s Role=$p(^DHCEQBuyRequest(BRID),"^",24)
		.q:Role'=CurRole
		.s YearFlag=$p(^DHCEQBuyRequest(BRID),"^",3)
		.q:YearFlag="Y"
		.s RequestLocDR=$p(^DHCEQBuyRequest(BRID),"^",2)
		.s PurposeTypeDR=$p(^DHCEQBuyRequest(BRID),"^",26)
		.q:(1=(##Class(web.DHCEQCommon).LocIsInEQ(QXType,RequestLocDR)))&&("N"=..GetUserLoc(User,RequestLocDR,PurposeTypeDR))
		.s OneFee=$p(^DHCEQBuyRequest(BRID),"^",9)
		.s Fee=Fee+OneFee
	}
	q Fee
}

ClassMethod GetDetail(BRID)
{
	new BRLID,BRLIDs
	s BRLID=0
	s BRLIDs=""
	f  s BRLID=$o(^DHCEQBuyRequestList(0,"BuyRequest",BRID,BRLID)) q:BRLID=""  d
	.i BRLIDs="" d
	..s BRLIDs=BRLID
	.e  d
	..s BRLIDs=BRLIDs_"^"_BRLID
	q BRLIDs
}

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT Distinct BR_PrjName,
	   BR_RowID,
	   BR_RequestNo
FROM sqluser.DHC_EQBuyRequest, sqluser.DHC_EQBuyRequestList
where BR_Status='2' and BR_YearFlag='N' and BRL_BuyRequestDR=BR_RowID and BR_PrjName like nvl(:para,'')||'%' 
 and BRL_RowID Not in (Select BPL_BuyRequestListDR from sqluser.DHC_EQBuyPlanList)
}

/// add by czf 20190110
/// 获取采购申请单审批进度信息
/// w ##Class(web.DHCEQBuyRequest).GetBuyReqProcess(1)
ClassMethod GetBuyReqProcess(BRID)
{
	new BRLID,BRLIDs,BRProcess
	s (BRISORNot,BPISORNot,IFBISORNot,CTISORNot,OCRISORNot,ISISORNot,SMISORNot)=0
	s (BRInfo,BPInfo,IFBInfo,CTInfo,OCRInfo,ISInfo,SMInfo)=""
	i BRID="" q ""
	;采购申请
	s BRStatus=$p(^DHCEQBuyRequest(BRID),"^",16)
	s BussType=91
	s BRInfo=BRID_","_BRStatus_","_BussType
	s BRISORNot=1
	s BRLID=""
	f  s BRLID=$o(^DHCEQBuyRequestList(0,"BuyRequest",BRID,BRLID)) q:BRLID=""  d
	.s BPLID=""		;采购计划
	.f  s BPLID=$o(^DHCEQBuyPlanList(0,"BuyRequestList",BRLID,BPLID)) q:BPLID=""  d
	..s BPID=$p(^DHCEQBuyPlanList(BPLID),"^",1)
	..s BPInvalidFlag=$p(^DHCEQBuyPlan(BPID),"^",46)
	..q:BPInvalidFlag="Y"
	..s BPStatus=$p(^DHCEQBuyPlan(BPID),"^",6)
	..s BPName=$p(^DHCEQBuyPlan(BPID),"^",6)
	..s BPNo=$p(^DHCEQBuyPlan(BPID),"^",25)
	..s BussType=92
	..s BPInfo=BPID_","_BPStatus_","_BussType
	..s BPISORNot=1
	..;根据计划招标
	..i $d(^DHCEQIFBBag(0,"Extend",2,BPLID)) d
	...s IFBGID=""
	...f  s IFBGID=$o(^DHCEQIFBBag(0,"Extend",2,BPLID,IFBGID)) q:IFBGID=""  d
	....s IFBID=$p(^DHCEQIFBBag(IFBGID),"^",1)
	....s IFBStatus=$p(^DHCEQIFB(IFBID),"^",43)
	....s BussType=93
	....s IFBInfo=IFBID_","_IFBStatus_","_BussType
	....s IFBISORNot=1
	....i $d(^DHCEQContractList(0,"SourceID",2,IFBGID)) d
	.....s CTLSourceType=2,CTLSourceID=IFBGID
	.....d GetContractProcess
	..;根据计划录入合同
	..e  i $d(^DHCEQContractList(0,"SourceID",1,BPLID)) d
	...s CTLSourceType=1,CTLSourceID=BPLID
	...d GetContractProcess
	..;根据计划验收
	..e  i $d(^DHCEQOpenCheckList(0,"Source",3,BPLID)) d
	...s OCLSourceType=3,OCLSourceID=BPLID
	...d GetOpenCheckProcess
	
	s OffBussIDs=##class(web.DHCEQCommon).GetSysInfo("990067")
	s BRProcess="验收="_OCRISORNot_"#"_OCRInfo_"^入库="_ISISORNot_"#"_ISInfo_"^转移="_SMISORNot_"#"_SMInfo
	i (OffBussIDs_",")[("92,")	d	;采购申请进度不包含采购计划
	.s BRProcess="采购申请="_BRISORNot_"#"_BRInfo_"^合同="_CTISORNot_"#"_CTInfo_"^"_BRProcess
	e  i (OffBussIDs_",")[("93,")	d	;采购申请进度不包含招标
	.i (OffBussIDs_",")[("94,")	d	;采购申请进度不包含合同
	..s BRProcess="采购申请="_BRISORNot_"#"_BRInfo_"^采购计划="_BPISORNot_"#"_BPInfo_"^"_BRProcess
	.e  d
	..s BRProcess="采购申请="_BRISORNot_"#"_BRInfo_"^采购计划="_BPISORNot_"#"_BPInfo_"^合同="_CTISORNot_"#"_CTInfo_"^"_BRProcess
	e  d		//modified by CZF0106 20200414 begin
	.s BRProcess="采购申请="_BRISORNot_"#"_BRInfo_"^采购计划="_BPISORNot_"#"_BPInfo_"^招标="_IFBISORNot_"#"_IFBInfo_"^合同="_CTISORNot_"#"_CTInfo_"^"_BRProcess
	//i (OffBussIDs=$c(0)) s OffBussIDs=""	//modified by czf 20190219
	//i (OffBussIDs="") d
	
	q BRProcess
	
GetContractProcess
	s CTLID=""		;合同
	f  s CTLID=$o(^DHCEQContractList(0,"SourceID",CTLSourceType,CTLSourceID,CTLID)) q:CTLID=""  d
	.s CTID=$p(^DHCEQContractList(CTLID),"^",1)
	.s CTStatus=$p(^DHCEQContract(CTID),"^",24)
	.s BussType=94
	.s CTInfo=CTID_","_CTStatus_","_BussType
	.s CTISORNot=1
	.i $d(^DHCEQOpenCheckList(0,"Source",1,CTLID)) d
	..s OCLSourceType=1,OCLSourceID=CTLID
	..d GetOpenCheckProcess
	quit
	
GetOpenCheckProcess
	s OCLID=""		;验收
	f  s OCLID=$o(^DHCEQOpenCheckList(0,"Source",OCLSourceType,OCLSourceID,OCLID)) q:OCLID=""  d
	.s OCRID=$p(^DHCEQOpenCheckList(OCLID),"^",1)
	.q:$p(^DHCEQOpenCheckRequest(OCRID),"^",45)="Y"
	.s OCRStatus=$p(^DHCEQOpenCheckRequest(OCRID),"^",20)
	.s BussType=11
	.s OCRInfo=OCRID_","_OCRStatus_","_BussType
	.s OCRISORNot=1
	.s ISLID=""
	.f  s ISLID=$o(^DHCEQInStockList(0,"Source",2,OCLID,ISLID)) q:ISLID=""  d
	..s ISID=$p(^DHCEQInStockList(ISLID),"^",1)
	..q:$p(^DHCEQInStock(ISID),"^",25)="Y"
	..s ISStatus=$p(^DHCEQInStock(ISID),"^",10)
	..s BussType=21
	..s ISInfo=ISID_","_ISStatus_","_BussType
	..s ISISORNot=1
	..s SMLID=""
	..f  s SMLID=$o(^DHCEQStoreMoveList(0,"InStockList",ISLID,SMLID)) q:SMLID=""  d
	...s SMID=$p(^DHCEQStoreMoveList(SMLID),"^",1)
	...q:$p(^DHCEQStoreMove(SMID),"^",27)="Y"
	...s SMStatus=$p(^DHCEQStoreMove(SMID),"^",13)
	...s BussType=22
	...s SMInfo=SMID_","_SMStatus_","_BussType
	...s SMISORNot=1
	quit
}

}
