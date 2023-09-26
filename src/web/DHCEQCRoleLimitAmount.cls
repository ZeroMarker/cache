Class web.DHCEQCRoleLimitAmount Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod UpdateData(Val, Type)
{
	//Type=0,更新
	//Type＝1，删除
	s RowID=$P(Val,"^",1)
	i +Type=0
	{
		s PLIST(2)=$P(Val,"^",2)
		s PLIST(3)=$P(Val,"^",3)
		s PLIST(4)=$P(Val,"^",4)
		s PLIST(5)=$P(Val,"^",5)
		if RowID=""
		{
			&SQL(insert into sqluser.DHC_EQCRoleLimitAmount values :PLIST())
		}
		else
		{
			&SQL(update sqluser.DHC_EQCRoleLimitAmount values :PLIST() where RLA_RowID=:RowID)
		}
		q SQLCODE
	}
	else
	{
		TSTART
		&SQL(delete from sqluser.DHC_EQCRoleLimitAmount where RLA_RowID=:RowID)
		i SQLCODE 
		{
			TROLLBACK
			q SQLCODE
		}
		TCOMMIT
		q SQLCODE
	}
}

ClassMethod GetOneRoleLimitAmount(UMLID)
{
	s (TRowID,TApproveRoleDR,TApproveRole,TApproveTypeDR,TApproveType,TMonthLimitFee,TYearLimitFee)=""
	s TRowID=UMLID
	s TApproveRoleDR=$p(^DHCEQCCode("DHCEQCRoleLimitAmount",TRowID),"^",1)
	i TApproveRoleDR'="" s TApproveRole=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR),"^",2)
	s TApproveTypeDR=$p(^DHCEQCCode("DHCEQCRoleLimitAmount",TRowID),"^",2)
	i TApproveTypeDR'="" s TApproveType=$p(^DHCEQCCode("DHCEQCApproveType",TApproveTypeDR),"^",2)
	s TMonthLimitFee=$p(^DHCEQCCode("DHCEQCRoleLimitAmount",TRowID),"^",3)
	s TYearLimitFee=$p(^DHCEQCCode("DHCEQCRoleLimitAmount",TRowID),"^",4)
	s ReturnVal=TRowID_"^"_TApproveRoleDR_"^"_TApproveRole_"^"_TApproveTypeDR_"^"_TApproveType_"^"_TMonthLimitFee_"^"_TYearLimitFee
	q ReturnVal
}

ClassMethod GetRoleLimitAmountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoleLimitAmountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRoleLimitAmountExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s TRow=0   //add by lmm 2018-10-25
	d BuildDataGetGetRoleLimitAmount
	Quit $$$OK
BuildDataGetGetRoleLimitAmount
	f  s rowid=$o(^DHCEQCCode("DHCEQCRoleLimitAmount",rowid))  quit:rowid=""  d
	.d ResetVariablesGetGetRoleLimitAmount
	.s TRowID=rowid
	.s TApproveRoleDR=$p(^DHCEQCCode("DHCEQCRoleLimitAmount",TRowID),"^",1)
	.i TApproveRoleDR'="" s TApproveRole=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR),"^",2)
	.s TApproveTypeDR=$p(^DHCEQCCode("DHCEQCRoleLimitAmount",TRowID),"^",2)
	.i TApproveTypeDR'="" s TApproveType=$p(^DHCEQCCode("DHCEQCApproveType",TApproveTypeDR),"^",2)
	.s TMonthLimitFee=$p(^DHCEQCCode("DHCEQCRoleLimitAmount",TRowID),"^",3)
	.s TYearLimitFee=$p(^DHCEQCCode("DHCEQCRoleLimitAmount",TRowID),"^",4)
	.s TRow=TRow+1		//add by lmm 2018-10-25
	.d OutputGetRoleLimitAmount
	quit
OutputGetRoleLimitAmount
   s Data=$lb(TRowID,TApproveRoleDR,TApproveRole,TApproveTypeDR,TApproveType,TMonthLimitFee,TYearLimitFee,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGetRoleLimitAmount
	s (TRowID,TApproveRoleDR,TApproveRole,TApproveTypeDR,TApproveType,TMonthLimitFee,TYearLimitFee)=""
	quit
}

ClassMethod GetRoleLimitAmountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoleLimitAmountExecute ]
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

Query GetRoleLimitAmount() As %Query(ROWSPEC = "TRowID:%String,TApproveRoleDR:%String,TApproveRole:%String,TApproveTypeDR:%String,TApproveType:%String,TMonthLimitFee:%String,TYearLimitFee:%String,TRow:%String")
{
}

ClassMethod IsHad(ApproveRoleID, ApproveTypeID, RLAID)
{
	// Mozy0030	2010-11-11
	q:ApproveRoleID="" "N"
	q:ApproveTypeID="" "N"
	new RLADR
	s RLADR=$o(^DHCEQCCode("DHCEQCRoleLimitAmount",0,"ApproveRole",ApproveRoleID,ApproveTypeID,0))
	i RLADR="" q "N"
	i RLADR'=RLAID q "Y"
	q "N"
}

/// 根据角色、审批类型返回限定金额
ClassMethod GetApproveLimitFee(Role, ApproveType)
{
	new RLADR,MonthLimitFee,YearLimitFee
	s (MonthLimitFee,YearLimitFee)=""
	s RLADR=$o(^DHCEQCCode("DHCEQCRoleLimitAmount",0,"ApproveRole",Role,ApproveType,0))
	i RLADR="" q "^"
	s MonthLimitFee=$p(^DHCEQCCode("DHCEQCRoleLimitAmount",RLADR),"^",3)
	s YearLimitFee=$p(^DHCEQCCode("DHCEQCRoleLimitAmount",RLADR),"^",4)
	q MonthLimitFee_"^"_YearLimitFee
}

///  判断是否超过限定金额
ClassMethod ApproveFeeHadExceed(Role, ApproveType, MonthFee, YearFee)
{
	s ReturnValue=0
	s LimitFee=..GetApproveLimitFee(Role,ApproveType)
	s MonthLimitFee=$p(LimitFee,"^",1)
	s YearLimitFee=$p(LimitFee,"^",2)
	i +MonthLimitFee>0
	{
		i +MonthLimitFee<MonthFee s ReturnValue=-1
	}
	q:ReturnValue<0 ReturnValue
	i +YearLimitFee>0
	{
		i +YearLimitFee<YearFee s ReturnValue=-2
	}
	q ReturnValue
}

}
