Import SQLUser

/// -----------------------------------------
/// 修改人： JDL 2009-06-23
/// 修改目的：解决JDL0018,增加供应商分类的处理。
/// 修改内容：修改方法GetAPCVendor
/// -----------------------------------------
/// 
Class web.DHCEQContract Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 142;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CT_ContractNo";

Parameter SQLDESCRIPTION = "CT_ContractName";

Parameter SQLROWID = "CT_RowID";

ClassMethod GetStatus(RowID)
{
	s Status=""
	i RowID="" q Status
	&sql(select CT_Status into :Status from sqluser.DHC_EQContract where CT_RowID=:RowID)
	q Status
}

ClassMethod UpdateData(itms As %Library.String = "", itmsex As %Library.String = "", val, AppType, RowID, User)
{
	s Date=+$H
	s Time=$P($H,",",2)
	s EquipDR=$p(val,"^",32)  ;EquipDR
	if +AppType=0  //更新，新增
 	{
	 	s PLIST(1) = $p(val,"^",1)	;RowID
	 	s CTRowID=PLIST(1)
 		s PLIST(2) = $p(val,"^",2)	;ContractName
 		s ContractName=$p(val,"^",2) //2011-01-28 DJ
 		s PLIST(3) = $p(val,"^",3)	;ContractNo
 		s ContractNo=$p(val,"^",3) //2011-01-28 DJ
 		s PLIST(4) = $p(val,"^",4)	;QuantityNum
 		s PLIST(5) = $p(val,"^",5)	;TotalFee
 		s PLIST(6) = $p(val,"^",6)	;PreFeeFee
 		s PLIST(7) = PLIST(6) //$p(val,"^",7)	;PayedTotalFee
 		i PLIST(6) = "" s PLIST(7)=0
 		s PLIST(8) = $p(val,"^",8)	;SignDate
 		i $p(val,"^",8)'=""  s PLIST(8) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date")	;SignDate
 		s PLIST(9) = $p(val,"^",9)	;SignLocDR
 		s PLIST(10) = $p(val,"^",10)	;DeliveryDate
 		i $p(val,"^",10)'=""  s PLIST(10) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"date")	;DeliveryDate
 		s PLIST(11) = $p(val,"^",11)	;ArriveDate
 		i $p(val,"^",11)'=""  s PLIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"date")	;ArriveDate
 		s PLIST(12) = $p(val,"^",12)	;StartDate
 		i $p(val,"^",12)'=""  s PLIST(12) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",12),"date")	;StartDate
 		s PLIST(13) = $p(val,"^",13)	;EndDate
 		i $p(val,"^",13)'="" s PLIST(13) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",13),"date")	;EndDate
 		s PLIST(14) = $p(val,"^",14)	;ClaimPeriodNum
 		s PLIST(15) = $p(val,"^",15)	;Service
 		s PLIST(16) = $p(val,"^",16)	;PayTypeDR
 		s PLIST(17) = $p(val,"^",17)	;PayItem
 		s PLIST(18) = $p(val,"^",18)	;CheckStandard
 		s PLIST(19) = $p(val,"^",19)	;ProviderDR
 		s PLIST(20) = $p(val,"^",20)	;ProviderTel
 		s PLIST(21) = $p(val,"^",21)	;ProviderHandler
 		s PLIST(22) = $p(val,"^",22)	;BreakItem
 		s PLIST(23) = $p(val,"^",23)	;NeedHandlerDR
 		s PLIST(24) = $p(val,"^",24)	;GuaranteePeriodNum
 		s PLIST(25) = AppType //$p(val,"^",25)	;Status
 		s PLIST(26) = $p(val,"^",26)	;Remark
 		/*s PLIST(27) = $p(val,"^",27)	;AddUserDR
 		s PLIST(28) = $p(val,"^",28)	;AddDate
 		i $p(val,"^",28)'=""  s PLIST(28) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",28),"date")	;AddDate
 		s PLIST(29) = $p(val,"^",29)	;AddTime
 		s PLIST(30) = $p(val,"^",30)	;UpdateUserDR
 		s PLIST(31) = $p(val,"^",31)	;UpdateDate
 		i $p(val,"^",31)'=""  s PLIST(31) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",31),"date")	;UpdateDate
 		s PLIST(32) = $p(val,"^",32)	;UpdateTime
 		s PLIST(33) = $p(val,"^",33)	;AuditUserDR
 		s PLIST(34) = $p(val,"^",34)	;AuditDate
 		i $p(val,"^",34)'=""  s PLIST(34) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",34),"date")	;AuditDate
 		s PLIST(35) = $p(val,"^",35)	;AuditTime*/
 		
 		s PLIST(36) = $p(val,"^",27)	;ArriveMonthNum
 		s PLIST(37) = $p(val,"^",28)	;ServiceDR
 		s PLIST(38) = $p(val,"^",29)	;ServiceHandler
 		s PLIST(39) = $p(val,"^",30)	;ServiceTel
 		s PLIST(40) = $p(val,"^",31)	;ContractType
 		s PLIST(41) = $p(val,"^",33)	;ArriveItrem
 		s PLIST(42) = $p(val,"^",34)	;QualityItem
 		k PLIST(1)
 		TSTART
	 	//检测是否重复
 		s Find=0
 		&SQL(Select CT_RowID Into :Find From SQLUSER.DHC_EQContract Where (CT_ContractNo=:ContractNo) or (CT_ContractName=:ContractName))	 		
 		if CTRowID=""
 		{
	 		i +Find'=0
 			{
	 			TROLLBACK
	 			q -1009
 			}
	 		s PLIST(27)=User
	 		s PLIST(28)=+$H
	 		s PLIST(29)=$P($H,",",2)
	 		i (PLIST(40)="0")&&(PLIST(3)="") s PLIST(3)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_Contract",+$H)
	 		&sql(insert into sqluser.DHC_EQContract values :PLIST())
	 		if SQLCODE
	 		{
		 		TROLLBACK
		 		q SQLCODE
	 		}
	 		s ID=$G(%ROWID)
	 		if PLIST(40)="1"
	 		{
		 		s EquipDR=$p(val,"^",32)
		 		&SQL(insert into sqluser.DHC_EQServiceContract values (:EquipDR,:ID))
		 		if SQLCODE
	 			{
		 			TROLLBACK
		 			q SQLCODE
	 			}
	 		}
 		}
 		else
 		{
	 		i (+Find'=0)&&(Find'=CTRowID)
	 		{
		 		TROLLBACK
		 		q -1009
	 		}
	 		s PLIST(30)=User
	 		s PLIST(31)=+$H
	 		s PLIST(32)=$P($H,",",2)
	 		&sql(update sqluser.DHC_EQContract values :PLIST() where CT_ROWID=:CTRowID)
	 		if SQLCODE
	 		{
		 		TROLLBACK
		 		q SQLCODE
	 		}
	 		s ID=$G(%ROWID)
 		}
 		s SQLCODE=..SaveContractList(ID,EquipDR)       //add by czf 需求号：358787
 		i SQLCODE
 		{
			TROLLBACK
			q SQLCODE
 		}
 		TCOMMIT
	 	q ID
 	}
 	if +AppType=1 //提交
 	{
	 	s PLIST(25)=AppType
	 	s PLIST(30)=User
	 	s PLIST(31)=+$H
	 	s PLIST(32)=$P($H,",",2)
	 	
	 	
	 	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("8")
	 	s EquipType=""
	 	s PurchaseType=""
	 	s YearFlag=""
	 	s MaxPrice=..GetMaxPrice(RowID)
	 	s SpecialType=""
	 	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag)
	 	i ApproveSet="" q "没有审批设置"
	 	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"8",User)
	 	
	 	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	 	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	 	s LastFlag=$P(ApproveFlow,"^",1)
	 	s NextStep=$P(ApproveFlow,"^",2)
	 	s NextRole=$P(ApproveFlow,"^",3)
	 	i AutoAuditFlag="Y"
	 	{
		 	i (NextStep="")||(LastFlag="Y")
		 	{
			 	s PLIST(25)="2"
		 		s PLIST(33)=User
	 			s PLIST(34)=Date
	 			s PLIST(35)=Time
		 	}
	 	}
	 	s PLIST(43)=ApproveSet
	 	s PLIST(44)=NextRole
	 	s PLIST(45)=NextStep
	 	s PLIST(46)=""
	 	s PLIST(47)=""
	 	
	 	TSTART
	 	&sql(update sqluser.DHC_EQContract values :PLIST() where CT_ROWID=:RowID)
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
	 	s PLIST(25)=AppType
	 	s PLIST(33)=User
	 	s PLIST(34)=+$h
	 	s PLIST(35)=$P($H,",",2)
	 	TSTART
	 	/*//////////更新对应的List中的BuyPlanListDR的ContractFlag标志
	 	&sql(update sqluser.DHC_EQBuyPlanList set BPL_ContractDR=:RowID where BPL_RowID in (select CTL_BuyPlanListDR from sqluser.DHC_EQContractList where CTL_ContractDR=:RowID))
	 	if (SQLCODE'=0)&&(SQLCODE'=100)
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}*/
	 	&sql(update sqluser.DHC_EQContract values :PLIST() where CT_ROWID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
	 	TCOMMIT
	 	q ID
 	}
 	if +AppType=3 //删除
 	{
	 	TSTART
		s ContractType=$P(^DHCEQContract(RowID),"^",39)
		i ContractType="1"
		{
			&SQL(delete from sqluser.DHC_EQServiceContract where SC_ContractDR=:RowID)
			if SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}

	 	&sql(delete from sqluser.DHC_EQContractList where CTL_ContractDR=:RowID)
		if (SQLCODE'=0)&&(SQLCODE'=100)
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	&sql(delete from sqluser.DHC_EQContractPayment where CTP_ContractDR=:RowID)
	 	if (SQLCODE'=0)&&(SQLCODE'=100)
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	&sql(delete from sqluser.DHC_EQContract where CT_RowID=:RowID)
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
	 	s PLIST(25)="0"
	 	s PLIST(30)=User
	 	s PLIST(31)=+$H
	 	s PLIST(32)=$P($H,",",2)
	 	s PLIST(48)=val
	 	TSTART
	 	&sql(update sqluser.DHC_EQContract values :PLIST() where CT_ROWID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
	 	TCOMMIT
	 	q ID
 	}
 	if +AppType=5 //审批
 	{
	 	s PLIST(47)=$p(val,"^",1)  //Role
	 	s PLIST(46)=$p(val,"^",2)  //Step
	 	s Opinion=$p(val,"^",3)  //Opinion 	
	 	s Remark=$p(val,"^",4)
	 		 	
	 	s PLIST(25)="1"	 	
	 	s ApproveSet=$P(^DHCEQContract(RowID),"^",42)
	 	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("8")
	 	s NextApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, PLIST(46), PLIST(47))
 		s LastFlag=$P(NextApproveFlow,"^",1)
	 	s NextStep=$P(NextApproveFlow,"^",2)
	 	s NextRole=$P(NextApproveFlow,"^",3)
	 	s PLIST(45)=NextStep
 		s PLIST(44)=NextRole
 		s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	 	i AutoAuditFlag="Y"
	 	{
		 	i (NextStep="")||(LastFlag="Y")
		 	{
			 	s PLIST(25)="2"
		 		s PLIST(33)=User
	 			s PLIST(34)=Date
	 			s PLIST(35)=Time
		 	}
	 	}		
	 	
	 	TSTART
	 	&sql(update sqluser.DHC_EQContract values :PLIST() where CT_ROWID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, RowID, Opinion, Remark, PLIST(47), PLIST(46))
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

ClassMethod GetMaxPrice(CTID)
{
	s MaxPrice=""
	&SQL(select max(CTL_PriceFee) into :MaxPrice from sqluser.DHC_EQContractList Where CTL_ContractDR=:BRID)
	i MaxPrice="" s MaxPrice=0
	q MaxPrice
}

ClassMethod ISHaveData(itms As %Library.String = "", itmsex As %Library.String = "", RowID)
{
	&sql(select CTL_RowID from sqluser.DHC_EQContractList where CTL_ContractDR=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
}

ClassMethod GetOneContract(itms As %Library.String = "", itmsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQContract(rowid)
	s $p(result,"^",7)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")	;SignDate
	s resultex=resultex_"^"	;SignLocDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",8))
	s $p(result,"^",9)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;DeliveryDate
	s $p(result,"^",10)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date")	;ArriveDate
	s $p(result,"^",11)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;StartDate
	s $p(result,"^",12)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")	;EndDate
	s resultex=resultex_"^"	;PayTypeDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("ctpm",$p(result,"^",15))
	s resultex=resultex_"^"	;ProviderDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",18))
	s resultex=resultex_"^"	;NeedHandlerDR
	i $p(result,"^",22)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",22))
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",26)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",26))
	s $p(result,"^",27)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",27),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",29)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",29))
	s $p(result,"^",30)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",30),"date")	;UpdateDate
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",32)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",32))
	s $p(result,"^",33)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",33),"date")	;AuditDate
	s resultex=resultex_"^"	;ServiceDR
	i $p(result,"^",36)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",$p(result,"^",36))),"^",1)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetSerContract(EquipDR) As %Query(ROWSPEC = "TRowID:%String,TContractName:%String,TContractNo:%String,TQuantityNum:%String,TTotalFee:%String,TPreFeeFee:%String,TPayedTotalFee:%String,TSignDate:%String,TSignLocDR:%String,TDeliveryDate:%String,TArriveDate:%String,TStartDate:%String,TEndDate:%String,TClaimPeriodNum:%String,TService:%String,TPayTypeDR:%String,TPayItem:%String,TCheckStandard:%String,TProviderDR:%String,TProviderTel:%String,TProviderHandler:%String,TBreakItem:%String,TNeedHandlerDR:%String,TGuaranteePeriodNum:%String,TStatus:%String,TRemark:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TSignLoc:%String,TPayType:%String,TProvider:%String,TNeedHandler:%String,TAddUser:%String,TUpdateUser:%String,TAuditUser:%String,TArriveMonthNum:%String,TServiceProDR:%String,TServiceHandler:%String,TServiceTel:%String,TServicePro:%String,TArriveItem:%String,TQualityItem:%String")
{
}

ClassMethod GetSerContractExecute(ByRef qHandle As %Binary, EquipDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s SerContractID=0
	d BuildDataGetSerContract
	Quit $$$OK
BuildDataGetSerContract
	f  s SerContractID=$o(^DHCEQServiceContract(0,"Equip",EquipDR,SerContractID))  quit:SerContractID=""  d
	.d ResetVariablesGetSerContract
	.s rowid=$p(^DHCEQServiceContract(SerContractID),"^",2)
	.s TRowID = rowid
	.s TContractName = $p($g(^DHCEQContract(rowid)),"^",1)
	.s TContractNo = $p($g(^DHCEQContract(rowid)),"^",2)
	.s TQuantityNum = $p($g(^DHCEQContract(rowid)),"^",3)
	.s TTotalFee = $p($g(^DHCEQContract(rowid)),"^",4)
	.s TPreFeeFee = $p($g(^DHCEQContract(rowid)),"^",5)
	.s TPayedTotalFee = $p($g(^DHCEQContract(rowid)),"^",6)
	.s TSignDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",7),"date")
	.s TSignLocDR = $p($g(^DHCEQContract(rowid)),"^",8)
	.i TSignLocDR '=""  d
	..s TSignLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TSignLocDR)
	.s TDeliveryDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",9),"date")
	.s TArriveDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",10),"date")
	.s TStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",11),"date")
	.s TEndDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",12),"date")
	.s TClaimPeriodNum = $p($g(^DHCEQContract(rowid)),"^",13)
	.s TService = $p($g(^DHCEQContract(rowid)),"^",14)
	.s TPayTypeDR = $p($g(^DHCEQContract(rowid)),"^",15)
	.i TPayTypeDR '=""  d
	..s TPayType = $p($g(^CT("CTPM",TPayTypeDR)),"^",2)
	.s TPayItem = $p($g(^DHCEQContract(rowid)),"^",16)
	.s TCheckStandard = $p($g(^DHCEQContract(rowid)),"^",17)
	.s TProviderDR = $p($g(^DHCEQContract(rowid)),"^",18)
	.i TProviderDR '=""  d
	..s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2) ;..s TProvider =$P($G(^APC("APCVM",TProviderDR)),"^",3)  //修改 By HHM 20150826  HHM0007
	.s TProviderTel = $p($g(^DHCEQContract(rowid)),"^",19)
	.s TProviderHandler = $p($g(^DHCEQContract(rowid)),"^",20)
	.s TBreakItem = $p($g(^DHCEQContract(rowid)),"^",21)
	.s TNeedHandlerDR = $p($g(^DHCEQContract(rowid)),"^",22)
	.i TNeedHandlerDR '=""  d
	..s TNeedHandler = ##class(web.DHCEQCommon).GetTrakNameByID("user",TNeedHandlerDR)
	.s TGuaranteePeriodNum = $p($g(^DHCEQContract(rowid)),"^",23)
	.s TStatus= $p($g(^DHCEQContract(rowid)),"^",24)
	.s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.s TRemark = $p($g(^DHCEQContract(rowid)),"^",25)
	.s TAddUserDR = $p($g(^DHCEQContract(rowid)),"^",26)
	.i TAddUserDR '=""  d
	..s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",27),"date")
	.s TAddTime = $p($g(^DHCEQContract(rowid)),"^",28)
	.s TUpdateUserDR = $p($g(^DHCEQContract(rowid)),"^",29)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",30),"date")
	.s TUpdateTime = $p($g(^DHCEQContract(rowid)),"^",31)
	.s TAuditUserDR = $p($g(^DHCEQContract(rowid)),"^",32)
	.i TAuditUserDR '=""  d
	..s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.s TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",33),"date")
	.s TAuditTime = $p($g(^DHCEQContract(rowid)),"^",34)
	.s TArriveMonthNum = $p($g(^DHCEQContract(rowid)),"^",35)
	.s TServiceProDR = $p($g(^DHCEQContract(rowid)),"^",36)
	.i TServiceProDR '=""  d
	..s TServicePro = $p($g(^DHCEQCCode("DHCEQCService",TServiceProDR)),"^",1)
	.s TServiceHandler = $p($g(^DHCEQContract(rowid)),"^",37)
	.s TServiceTel = $p($g(^DHCEQContract(rowid)),"^",38)
	.s TContractType=$p($g(^DHCEQContract(rowid)),"^",39)
	.s TArriveItem=$p($g(^DHCEQContract(rowid)),"^",40)
	.s TTQualityItem=$p($g(^DHCEQContract(rowid)),"^",41)
	.d OutputRowGetSerContract
	quit
OutputRowGetSerContract
	s Data=$lb(TRowID,TContractName,TContractNo,TQuantityNum,TTotalFee,TPreFeeFee,TPayedTotalFee,TSignDate,TSignLocDR,TDeliveryDate,TArriveDate,TStartDate,TEndDate,TClaimPeriodNum,TService,TPayTypeDR,TPayItem,TCheckStandard,TProviderDR,TProviderTel,TProviderHandler,TBreakItem,TNeedHandlerDR,TGuaranteePeriodNum,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TSignLoc,TPayType,TProvider,TNeedHandler,TAddUser,TUpdateUser,TAuditUser,TArriveMonthNum,TServiceProDR,TServiceHandler,TServiceTel,TServicePro,TArriveItem,TQualityItem)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetSerContract
	s (TRowID,TContractName,TContractNo,TQuantityNum,TTotalFee,TPreFeeFee,TPayedTotalFee,TSignDate,TSignLocDR,TDeliveryDate,TArriveDate,TStartDate,TEndDate,TClaimPeriodNum,TService,TPayTypeDR,TPayItem,TCheckStandard,TProviderDR,TProviderTel,TProviderHandler,TBreakItem,TNeedHandlerDR,TGuaranteePeriodNum,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TSignLoc,TPayType,TProvider,TNeedHandler,TAddUser,TUpdateUser,TAuditUser,TArriveMonthNum,TServiceProDR,TServiceHandler,TServiceTel,TServicePro,TArriveItem,TQualityItem)=""
	quit
}

ClassMethod GetSerContractFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSerContractExecute ]
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

ClassMethod GetSerContractClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSerContractExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetContract(QXType, ContractName, SignLocDR, ProviderDR, StartDate, EndDate, StatusDR, ReplacesAD, ApproveRole, Type, WaitAD) As %Query(ROWSPEC = "TRowID:%String,TContractName:%String,TContractNo:%String,TQuantityNum:%String,TTotalFee:%String,TPreFeeFee:%String,TPayedTotalFee:%String,TSignDate:%String,TSignLocDR:%String,TDeliveryDate:%String,TArriveDate:%String,TStartDate:%String,TEndDate:%String,TClaimPeriodNum:%String,TService:%String,TPayTypeDR:%String,TPayItem:%String,TCheckStandard:%String,TProviderDR:%String,TProviderTel:%String,TProviderHandler:%String,TBreakItem:%String,TNeedHandlerDR:%String,TGuaranteePeriodNum:%String,TStatus:%String,TRemark:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TSignLoc:%String,TPayType:%String,TProvider:%String,TNeedHandler:%String,TAddUser:%String,TUpdateUser:%String,TAuditUser:%String,TArriveMonthNum:%String,TServiceProDR:%String,TServiceHandler:%String,TServiceTel:%String,TServicePro:%String,TApproveSetDR:%String")
{
}

ClassMethod GetContractExecute(ByRef qHandle As %Binary, QXType, ContractName, SignLocDR, ProviderDR, StartDate, EndDate, StatusDR, ReplacesAD As %Library.String = "", ApproveRole As %Library.String = "", Type As %Library.String = "", WaitAD As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	if WaitAD'="on"
	{
		if ReplacesAD="on"
		{
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("8")
			s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
			s ALRowID=0
			f  s ALRowID=$o(^DHCEQApproveList(0,"Role",ApproveType,ApproveRole,ALRowID)) q:ALRowID=""  d
			.s ADUser=$p(^DHCEQApproveList(ALRowID),"^",6)
			.q:ADUser=CurUser
			.s rowid=$p(^DHCEQApproveList(ALRowID),"^",2)
			.d ResetVariablesGetContract
			.d BuildDataGetContract
		}
		else
		{
			f  s rowid=$o(^DHCEQContract(rowid))  quit:rowid=""  d
			.d ResetVariablesGetContract
			.d BuildDataGetContract
		}
	}
	else
	{
		if Type="1"
		{
			f  s rowid=$o(^DHCEQContract(0,"ApproveRole",1,ApproveRole,rowid))  quit:rowid=""  d
			.d ResetVariablesGetContract
			.d BuildDataGetContract
			s rowid=0
			s ApproveSet=0
			s ApproveFlow=0
			s ApproveFlowStep=""
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("8")
			f  s ApproveSet=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveType,ApproveSet))  quit:ApproveSet=""  d
			.f   s ApproveFlow=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,ApproveRole,ApproveFlow))  quit:ApproveFlow=""  d
			..s ApproveFowStep=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlow),"^",3)
			..f   s rowid=$o(^DHCEQContract(0,"ApproveSet",1,ApproveSet,ApproveFowStep,rowid))  quit:rowid=""  d
			...s Role=$p(^DHCEQContract(rowid),"^",12)
			...q:Role'=""
			...s Approved=##class(web.DHCEQCApproveSet).HasApprove(ApproveType, rowid, ApproveFowStep, ApproveRole)
			...q:Approved>0
			...d ResetVariablesGetContract
			...d BuildDataGetContract
		}
		if Type="2"
		{
			s rowid=0
			s NextStep=""
			f  s rowid=$o(^DHCEQContract(0,"Status",1,rowid))  quit:rowid=""  d
			.s NextStep=$p($G(^DHCEQContract(rowid)),"^",13)
			.q:NextStep'=""
			.d ResetVariablesGetContract
			.d BuildDataGetContract
		}
	}
	
	Quit $$$OK
BuildDataGetContract
	s TRowID = rowid
	q:(ContractName="")&&(SignLocDR="")&&(ProviderDR="")&&(StartDate="")&&(EndDate="")&&(StatusDR="")
	s TContractName = $p($g(^DHCEQContract(rowid)),"^",1)
	q:(ContractName'="")&&(TContractName'[ContractName)
	s TContractNo = $p($g(^DHCEQContract(rowid)),"^",2)
	s TQuantityNum = $p($g(^DHCEQContract(rowid)),"^",3)
	s TTotalFee = $p($g(^DHCEQContract(rowid)),"^",4)
	s TPreFeeFee = $p($g(^DHCEQContract(rowid)),"^",5)
	s TPayedTotalFee = $p($g(^DHCEQContract(rowid)),"^",6)
	s TSignDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",7),"date")
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$H
	q:($p($g(^DHCEQContract(rowid)),"^",7)>EndDate)||($p($g(^DHCEQContract(rowid)),"^",7)<StartDate)
	s TSignLocDR = $p($g(^DHCEQContract(rowid)),"^",8)
	q:(SignLocDR'="")&&(TSignLocDR'=SignLocDR)
	//q:(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TSignLocDR))
	i TSignLocDR '=""  d
	.s TSignLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TSignLocDR)
	s TDeliveryDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",9),"date")
	s TArriveDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",10),"date")
	s TStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",11),"date")
	s TEndDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",12),"date")
	s TClaimPeriodNum = $p($g(^DHCEQContract(rowid)),"^",13)
	s TService = $p($g(^DHCEQContract(rowid)),"^",14)
	s TPayTypeDR = $p($g(^DHCEQContract(rowid)),"^",15)
	i TPayTypeDR '=""  d
	.s TPayType = $p($g(^CT("CTPM",TPayTypeDR)),"^",2)
	s TPayItem = $p($g(^DHCEQContract(rowid)),"^",16)
	s TCheckStandard = $p($g(^DHCEQContract(rowid)),"^",17)
	s TProviderDR = $p($g(^DHCEQContract(rowid)),"^",18)
	q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	i TProviderDR '=""  d
	.s TProvider =$P($G(^APC("APCVM",TProviderDR)),"^",3)
	s TProviderTel = $p($g(^DHCEQContract(rowid)),"^",19)
	s TProviderHandler = $p($g(^DHCEQContract(rowid)),"^",20)
	s TBreakItem = $p($g(^DHCEQContract(rowid)),"^",21)
	s TNeedHandlerDR = $p($g(^DHCEQContract(rowid)),"^",22)
	i TNeedHandlerDR '=""  d
	.s TNeedHandler = ##class(web.DHCEQCommon).GetTrakNameByID("user",TNeedHandlerDR)
	s TGuaranteePeriodNum = $p($g(^DHCEQContract(rowid)),"^",23)
	s TStatus= $p($g(^DHCEQContract(rowid)),"^",24)
	q:(StatusDR'="")&&(TStatus'=StatusDR)
	s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	s TRemark = $p($g(^DHCEQContract(rowid)),"^",25)
	s TAddUserDR = $p($g(^DHCEQContract(rowid)),"^",26)
	i TAddUserDR '=""  d
	.s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",27),"date")
	s TAddTime = $p($g(^DHCEQContract(rowid)),"^",28)
	s TUpdateUserDR = $p($g(^DHCEQContract(rowid)),"^",29)
	i TUpdateUserDR '=""  d
	.s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",30),"date")
	s TUpdateTime = $p($g(^DHCEQContract(rowid)),"^",31)
	s TAuditUserDR = $p($g(^DHCEQContract(rowid)),"^",32)
	i TAuditUserDR '=""  d
	.s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	s TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",33),"date")
	s TAuditTime = $p($g(^DHCEQContract(rowid)),"^",34)
	s TArriveMonthNum = $p($g(^DHCEQContract(rowid)),"^",35)
	s TServiceProDR = $p($g(^DHCEQContract(rowid)),"^",36)
	i TServiceProDR '=""  d
	.s TServicePro = $p($g(^DHCEQCCode("DHCEQCService",TServiceProDR)),"^",1)
	s TServiceHandler = $p($g(^DHCEQContract(rowid)),"^",37)
	s TServiceTel = $p($g(^DHCEQContract(rowid)),"^",38)
	s TContractType=$p($g(^DHCEQContract(rowid)),"^",39)
	q:(TContractType'="0")
	s TApproveSetDR=$p($g(^DHCEQContract(rowid)),"^",42)
	d OutputRowGetContract
	quit
OutputRowGetContract
	s Data=$lb(TRowID,TContractName,TContractNo,TQuantityNum,TTotalFee,TPreFeeFee,TPayedTotalFee,TSignDate,TSignLocDR,TDeliveryDate,TArriveDate,TStartDate,TEndDate,TClaimPeriodNum,TService,TPayTypeDR,TPayItem,TCheckStandard,TProviderDR,TProviderTel,TProviderHandler,TBreakItem,TNeedHandlerDR,TGuaranteePeriodNum,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TSignLoc,TPayType,TProvider,TNeedHandler,TAddUser,TUpdateUser,TAuditUser,TArriveMonthNum,TServiceProDR,TServiceHandler,TServiceTel,TServicePro,TApproveSetDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContract
	s (TRowID,TContractName,TContractNo,TQuantityNum,TTotalFee,TPreFeeFee,TPayedTotalFee,TSignDate,TSignLocDR,TDeliveryDate,TArriveDate,TStartDate,TEndDate,TClaimPeriodNum,TService,TPayTypeDR,TPayItem,TCheckStandard,TProviderDR,TProviderTel,TProviderHandler,TBreakItem,TNeedHandlerDR,TGuaranteePeriodNum,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TSignLoc,TPayType,TProvider,TNeedHandler,TAddUser,TUpdateUser,TAuditUser,TArriveMonthNum,TServiceProDR,TServiceHandler,TServiceTel,TServicePro,TApproveSetDR)=""
	quit
}

/*
ClassMethod GetContractExecuteOld(ByRef qHandle As %Binary, QXType, ContractName, SignLocDR, ProviderDR, StartDate, EndDate, StatusDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetContract
	Quit $$$OK
BuildDataGetContract
	f  s rowid=$o(^DHCEQContract(rowid))  quit:rowid=""  d
	.d ResetVariablesGetContract
	.s TRowID = rowid
	.q:(ContractName="")&&(SignLocDR="")&&(ProviderDR="")&&(StartDate="")&&(EndDate="")&&(StatusDR="")
	.s TContractName = $p($g(^DHCEQContract(rowid)),"^",1)
	.q:(ContractName'="")&&(TContractName'[ContractName)
	.s TContractNo = $p($g(^DHCEQContract(rowid)),"^",2)
	.s TQuantityNum = $p($g(^DHCEQContract(rowid)),"^",3)
	.s TTotalFee = $p($g(^DHCEQContract(rowid)),"^",4)
	.s TPreFeeFee = $p($g(^DHCEQContract(rowid)),"^",5)
	.s TPayedTotalFee = $p($g(^DHCEQContract(rowid)),"^",6)
	.s TSignDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",7),"date")
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$H
	.q:($p($g(^DHCEQContract(rowid)),"^",7)>EndDate)||($p($g(^DHCEQContract(rowid)),"^",7)<StartDate)
	.s TSignLocDR = $p($g(^DHCEQContract(rowid)),"^",8)
	.q:(SignLocDR'="")&&(TSignLocDR'=SignLocDR)
	.//q:(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TSignLocDR))
	.i TSignLocDR '=""  d
	..s TSignLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TSignLocDR)
	.s TDeliveryDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",9),"date")
	.s TArriveDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",10),"date")
	.s TStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",11),"date")
	.s TEndDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",12),"date")
	.s TClaimPeriodNum = $p($g(^DHCEQContract(rowid)),"^",13)
	.s TService = $p($g(^DHCEQContract(rowid)),"^",14)
	.s TPayTypeDR = $p($g(^DHCEQContract(rowid)),"^",15)
	.i TPayTypeDR '=""  d
	..s TPayType = $p($g(^CT("CTPM",TPayTypeDR)),"^",2)
	.s TPayItem = $p($g(^DHCEQContract(rowid)),"^",16)
	.s TCheckStandard = $p($g(^DHCEQContract(rowid)),"^",17)
	.s TProviderDR = $p($g(^DHCEQContract(rowid)),"^",18)
	.q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	.i TProviderDR '=""  d
	..s TProvider =$P($G(^APC("APCVM",TProviderDR)),"^",3)
	.s TProviderTel = $p($g(^DHCEQContract(rowid)),"^",19)
	.s TProviderHandler = $p($g(^DHCEQContract(rowid)),"^",20)
	.s TBreakItem = $p($g(^DHCEQContract(rowid)),"^",21)
	.s TNeedHandlerDR = $p($g(^DHCEQContract(rowid)),"^",22)
	.i TNeedHandlerDR '=""  d
	..s TNeedHandler = ##class(web.DHCEQCommon).GetTrakNameByID("user",TNeedHandlerDR)
	.s TGuaranteePeriodNum = $p($g(^DHCEQContract(rowid)),"^",23)
	.s TStatus= $p($g(^DHCEQContract(rowid)),"^",24)
	.q:(StatusDR'="")&&(TStatus'=StatusDR)
	.s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.s TRemark = $p($g(^DHCEQContract(rowid)),"^",25)
	.s TAddUserDR = $p($g(^DHCEQContract(rowid)),"^",26)
	.i TAddUserDR '=""  d
	..s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",27),"date")
	.s TAddTime = $p($g(^DHCEQContract(rowid)),"^",28)
	.s TUpdateUserDR = $p($g(^DHCEQContract(rowid)),"^",29)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",30),"date")
	.s TUpdateTime = $p($g(^DHCEQContract(rowid)),"^",31)
	.s TAuditUserDR = $p($g(^DHCEQContract(rowid)),"^",32)
	.i TAuditUserDR '=""  d
	..s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.s TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",33),"date")
	.s TAuditTime = $p($g(^DHCEQContract(rowid)),"^",34)
	.s TArriveMonthNum = $p($g(^DHCEQContract(rowid)),"^",35)
	.s TServiceProDR = $p($g(^DHCEQContract(rowid)),"^",36)
	.i TServiceProDR '=""  d
	..s TServicePro = $p($g(^DHCEQCCode("DHCEQCService",TServiceProDR)),"^",1)
	.s TServiceHandler = $p($g(^DHCEQContract(rowid)),"^",37)
	.s TServiceTel = $p($g(^DHCEQContract(rowid)),"^",38)
	.s TContractType=$p($g(^DHCEQContract(rowid)),"^",39)
	.q:(TContractType'="0")
	.d OutputRowGetContract
	quit
OutputRowGetContract
	s Data=$lb(TRowID,TContractName,TContractNo,TQuantityNum,TTotalFee,TPreFeeFee,TPayedTotalFee,TSignDate,TSignLocDR,TDeliveryDate,TArriveDate,TStartDate,TEndDate,TClaimPeriodNum,TService,TPayTypeDR,TPayItem,TCheckStandard,TProviderDR,TProviderTel,TProviderHandler,TBreakItem,TNeedHandlerDR,TGuaranteePeriodNum,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TSignLoc,TPayType,TProvider,TNeedHandler,TAddUser,TUpdateUser,TAuditUser,TArriveMonthNum,TServiceProDR,TServiceHandler,TServiceTel,TServicePro)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContract
	s (TRowID,TContractName,TContractNo,TQuantityNum,TTotalFee,TPreFeeFee,TPayedTotalFee,TSignDate,TSignLocDR,TDeliveryDate,TArriveDate,TStartDate,TEndDate,TClaimPeriodNum,TService,TPayTypeDR,TPayItem,TCheckStandard,TProviderDR,TProviderTel,TProviderHandler,TBreakItem,TNeedHandlerDR,TGuaranteePeriodNum,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TSignLoc,TPayType,TProvider,TNeedHandler,TAddUser,TUpdateUser,TAuditUser,TArriveMonthNum,TServiceProDR,TServiceHandler,TServiceTel,TServicePro)=""
	quit
}
*/
ClassMethod GetContractFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractExecute ]
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

ClassMethod GetContractClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetAPCVendor(Provider, VendCatDR As %String = "") As %Query(ROWSPEC = "Name:%String,ID:%String")
{
}

ClassMethod GetAPCVendorExecute(ByRef qHandle As %Binary, Provider, VendCatDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set Provider=$ZCONVERT(Provider ,"U")
	s index=1
	s rowid=0
	d BuildDataGetAPCVendor
	Quit $$$OK
BuildDataGetAPCVendor
	f  s rowid=$o(^APC("APCVM",rowid))  quit:rowid=""  d
	.d ResetVariablesGetAPCVendor
	.s TRowID = rowid
	.s TName=$ZCONVERT($P($g(^APC("APCVM",TRowID)),"^",3) ,"U")
	.q:(Provider'="")&&(TName'[Provider)
	.s VendCatDR=##class(web.DHCEQCommon).GetSysInfo("990008")
	.q:(VendCatDR'="")&&($P($g(^APC("APCVM",TRowID,1)),"^",1)'="")&&($P($g(^APC("APCVM",TRowID,1)),"^",1)'=VendCatDR)
	.d OutputRowGetAPCVendor
	quit
OutputRowGetAPCVendor
	s TShortName=##class(web.DHCEQCommon).GetSplitDataByFlag(TName,"-")
	;s Data=$lb(TName,TRowID)
	s Data=$lb(TShortName,TRowID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAPCVendor
	s (TRowID,TName)=""
	quit
}

ClassMethod GetAPCVendorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAPCVendorExecute ]
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

ClassMethod GetAPCVendorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAPCVendorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Type=1，返回ID，Type=2返回名称
ClassMethod GetProviderIDByCode(Code)
{
	i Code="" q "^"
   	s Code=$ZCONVERT(Code ,"U")
    s AproviderID=$o(^APC("APCVM",0,"APCVM_Code",Code,0))
	i AproviderID=""
	{
		s Aprovider="" 
	}
	else
	{
		s Aprovider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",AproviderID)	
	}
	q AproviderID_"^"_Aprovider
}

/// add by czf 2017-04-05 需求号：358787
/// 台账新增设备保修合同时保存到合同明细中
ClassMethod SaveContractList(rowid, EquipID)
{
	new Flag,CTLRowID,SQLCODE,User,Date,Time
	k PLISTMX
	i rowid="" q -1
	i EquipID="" q 0
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s Flag=0
	s PLISTMX(2)=rowid  				;ContractDR
	s Length=$l(val,"&")
	q:Flag'=0
	s valList=$g(^DHCEQEquip(EquipID))
	s PLISTMX(3)=$p(valList,"^",1)  	;CTL_Name	//2013-06-24 DJ0118
	s PLISTMX(4)=$p(valList,"^",3)		;CTL_ModelDR
	s PLISTMX(5)=$p(valList,"^",26)		;CTL_ManuFacDR
	s PLISTMX(6)=2 	                    ;CTL_SourceType 设备
	s PLISTMX(7)=$p(valList,"^",27)  	;CTL_PriceFee
	s PLISTMX(8)=1  	                ;CTL_QuantityNum
	s PLISTMX(9)=$p(valList,"^",27)  	;CTL_TotalFee
	s PLISTMX(10)=$p(valList,"^",34)  	;CTL_Remark
	;s PLISTMX(11)=$p(valList,"^",12)
	;i PLISTMX(11)'=""  s PLISTMX(11)=##Class(web.DHCEQCommon).TransValueFromPage($p(valList,"^",12),"date")	;CTL_ContractArriveDate
	//s PLISTMX(12)=$p(valList,"^",11)  ;CTL_ArriveDate
	//s PLISTMX(13)=$p(valList,"^",11)  ;CTL_ArriveQuantityNum
	s PLISTMX(14)=User  				;CTL_UpdateUserDR
	s PLISTMX(15)=Date  				;CTL_UpdateDate
	s PLISTMX(16)=Time				  	;CTL_UpdateTime
	s PLISTMX(18)=EquipID 				;CTL_SourceID
	s PLISTMX(19)=$p(valList,"^",7)  	;CTL_ItemDR	
	
	&SQL(Insert Into SQLUSER.DHC_EQContractList Values :PLISTMX())
	i SQLCODE s Flag="^更新明细记录失败!"
	q Flag
}

}
