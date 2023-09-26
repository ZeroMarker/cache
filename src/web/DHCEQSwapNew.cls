Class web.DHCEQSwapNew Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 销毁明细
/// d ##class(%ResultSet).RunQuery("web.DHCEQSwapNew","GetSwapList","")
Query GetSwapList(RowID) As %Query(ROWSPEC = "TJob:%String,TRow:%String,TRowID:%String,TMasterItemDR:%String,TMasterItem:%String,TModelDR:%String,TModel:%String,TQuantityNum:%String,TSupplementNum:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetSwapListExecute(ByRef qHandle As %Binary, RowID) As %Status
{
 	new repid, index,rowid,ApproveType
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=2 //让合计显示在首行
	s rowid=0
	s Job=$J
	s (TotalQty,TotalSmt)=0
	d BuildDataGetSwapList
	Quit $$$OK
BuildDataGetSwapList
	s TRow=0
	i RowID '= ""
	{
		f  s rowid=$o(^DHCEQSwapList(0,"Swap",RowID,rowid))  quit:rowid=""  d
		.d ResetVariablesGetSwapList
		.s TRowID = rowid
		.s TMasterItemDR = $p($g(^DHCEQSwapList(rowid)),"^",2)
		.i TMasterItemDR '= ""  s TMasterItem = $P(^DHCEQCCode("DHCEQCMasterItem",TMasterItemDR),"^",1)
		.s TModelDR = $p($g(^DHCEQSwapList(rowid)),"^",3)
		.i TModelDR '= ""  s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		.s TQuantityNum = $p($g(^DHCEQSwapList(rowid)),"^",4)
		.s TotalQty = TotalQty + TQuantityNum
		.s TSupplementNum = $p($g(^DHCEQSwapList(rowid)),"^",5)
		.s TotalSmt = TotalSmt + TSupplementNum
		.s THold1 =  $p($g(^DHCEQSwapList(rowid)),"^",6)
		.s THold2 =  $p($g(^DHCEQSwapList(rowid)),"^",7)
		.s THold3 =  $p($g(^DHCEQSwapList(rowid)),"^",8)
		.s THold4 =  $p($g(^DHCEQSwapList(rowid)),"^",9)
		.s THold5 =  $p($g(^DHCEQSwapList(rowid)),"^",10)
		.s TRow=TRow+1
		.s TJob=Job
		.d OutputRowGetSwapList
	}
	
	;没有数据时,也返回一个空行,用于编辑
	i TRow=0  d
	.d ResetVariablesGetSwapList
	.s TRow=1
	.s TJob=Job
	.d OutputRowGetSwapList
	
	;处理合计行
	d ResetVariablesGetSwapList
	s TRowID=-1
	s TRow="合计:"
	s TQuantityNum=TotalQty
	s TSupplementNum=TotalSmt
	s index=1
	s TJob=Job
	d OutputRowGetSwapList
	
	quit
OutputRowGetSwapList
	s Data=$lb(TJob,TRow,TRowID,TMasterItemDR,TMasterItem,TModelDR,TModel,TQuantityNum,TSupplementNum,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetSwapList
	s (TJob,TRowID,TMasterItemDR,TMasterItem,TModelDR,TModel,TQuantityNum,TSupplementNum,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod GetSwapListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSwapListExecute ]
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

ClassMethod GetSwapListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSwapListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 销毁详细
/// d ##class(%ResultSet).RunQuery("web.DHCEQSwapNew","GetSwapListDetail","")
Query GetSwapListDetail(SwapDR) As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TSwapDR:%String,TMasterItem:%String,TModel:%String,TQuantityNum:%String,TSupplementNum:%String,TLoc:%String,TMasterItemDR:%String,TModelDR:%String,TLocDR:%String,TDamagedAllotQty:%String,TDifference:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetSwapListDetailExecute(ByRef qHandle As %Binary, SwapDR) As %Status
{
 	new repid, index,rowid,ApproveType
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=2 //让合计显示在首行
	s rowid=0
	s (TotalQty,TotalSmt)=0
	d BuildDataGetSwapListDetail
	Quit $$$OK
BuildDataGetSwapListDetail
	s TRow=0
	i SwapDR '= ""
	{
		f  s rowid=$o(^DHCEQSwapListDetail(0,"Swap",SwapDR,rowid))  quit:rowid=""  d
		.d ResetVariablesGetSwapListDetail
		.s TRowID = rowid
		.s TSwapDR= SwapDR
		.s TMasterItemDR = $p($g(^DHCEQSwapListDetail(rowid)),"^",3)
		.i TMasterItemDR '= ""  s TMasterItem = $P(^DHCEQCCode("DHCEQCMasterItem",TMasterItemDR),"^",1)
		.s TModelDR = $p($g(^DHCEQSwapListDetail(rowid)),"^",4)
		.i TModelDR '= ""  s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		.s TQuantityNum = $p($g(^DHCEQSwapListDetail(rowid)),"^",5)
		.s TotalQty = TotalQty + TQuantityNum
		.s TSupplementNum = $p($g(^DHCEQSwapListDetail(rowid)),"^",6)
		.s TotalSmt = TotalSmt + TSupplementNum
		.s TLocDR = $p($g(^DHCEQSwapListDetail(rowid)),"^",7)
		.i TLocDR '= ""  s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
		.s TDamagedAllotQty= $p($g(^DHCEQSwapListDetail(0,"AutoCostAllot",TLocDR,TMasterItemDR)),"^",1)
		.s TDifference= $p($g(^DHCEQSwapListDetail(0,"AutoCostAllot",TLocDR,TMasterItemDR)),"^",2)
		.s THold1 =  $p($g(^DHCEQSwapListDetail(rowid)),"^",8)
		.s THold2 =  $p($g(^DHCEQSwapListDetail(rowid)),"^",9)
		.s THold3 =  $p($g(^DHCEQSwapListDetail(rowid)),"^",10)
		.s THold4 =  $p($g(^DHCEQSwapListDetail(rowid)),"^",11)
		.s THold5 =  $p($g(^DHCEQSwapListDetail(rowid)),"^",12)
		.s TRow=TRow+1
		.d OutputRowGetSwapListDetail
	}
	
	;没有数据时,也返回一个空行,用于编辑
	i TRow=0  d
	.d ResetVariablesGetSwapListDetail
	.s TRow=1
	.d OutputRowGetSwapListDetail
	
	;处理合计行
	d ResetVariablesGetSwapListDetail
	s TRowID=-1
	s TRow="合计:"
	s TMasterItem=""
	s TQuantityNum=TotalQty
	s TSupplementNum=TotalSmt
	s index=1
	d OutputRowGetSwapListDetail
	
	quit
OutputRowGetSwapListDetail
	s Data=$lb(TRow,TRowID,TSwapDR,TMasterItem,TModel,TQuantityNum,TSupplementNum,TLoc,TMasterItemDR,TModelDR,TLocDR,TDamagedAllotQty,TDifference,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetSwapListDetail
	s (TRowID,TSwapDR,TMasterItemDR,TMasterItem,TModelDR,TModel,TQuantityNum,TSupplementNum,TLocDR,TLoc,TDamagedAllotQty,TDifference,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod GetSwapListDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSwapListDetailExecute ]
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

ClassMethod GetSwapListDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSwapListDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 更新操作
ClassMethod SaveData(val, valList, DelRowid)
{
	new RowID
	k PLIST
	Set $ZT="ERRORSave"
	s Date=+$H
	s Time=$P($H,",",2)
	s RowID = $p(val,"^",1)		;RowID
	s User=$p(val,"^",7)
	s PLIST(3) = $p(val,"^",2)	;Type
	s PLIST(4) = $p(val,"^",3)	;LocDR
	s PLIST(5) = $p(val,"^",4)	;RequestLocDR
	s PLIST(6) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date")	;RequestDate
	s PLIST(7) = $p(val,"^",6)	;RequestUserDR
	s PLIST(8) = ""				;QuantityNum
	;s valDate = ..DateToQuarter(Date)
	;获取最近一次相同业务的RowID
	s LastType=""
	s LastRowID=^DHCEQSwap(0)
	f  s LastRowID=$O(^DHCEQSwap(LastRowID),-1) quit:(LastRowID=0)||(LastType=PLIST(3))  d
	.s LastType=$P($G(^DHCEQSwap(LastRowID)),"^",2)
	.s StartDate=$P($G(^DHCEQSwap(LastRowID)),"^",8)
	.s StartDate=StartDate+1
	i ((LastRowID=0)&&(LastType'=PLIST(3)))  s StartDate=Date
	
	;s PLIST(9) = ##class(web.DHCEQCommon).TransValueFromPage($p(valDate,"^",1),"date")	;StartDate
	;s PLIST(10) = ##class(web.DHCEQCommon).TransValueFromPage($p(valDate,"^",2),"date")	;EndDate
	s PLIST(9) = StartDate
	s PLIST(10) = Date
	s PLIST(11) = 0				;Status
	s PLIST(12) = User			;UpdateUserDR
	s PLIST(13) = Date			;UpdateDate
	s PLIST(14) = Time			;UpdateTime
	s PLIST(26) = "N"			;InvalidFlag
	
	
	s Job = $p(val,"^",8) 		;$job
	i RowID'=""
	{
		s InvalidFlag=$p($g(^DHCEQSwap(RowID)),"^",25)
		i InvalidFlag="Y" q -1015
	}
	TSTART
	if RowID=""
	{
		s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQSwap",+$H,"","被服类组","被服类型","被服分类")
		&SQL(insert into sqluser.DHC_EQSwap values :PLIST())
	}
	else
	{
		&SQL(update sqluser.DHC_EQSwap values :PLIST() where S_RowID=:RowID)
	}
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s RowID=$G(%ROWID)	
 	s SQLCODE=..DeleteSwapList(RowID,DelRowid)

 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	s SQLCODE=..SaveSwapList(RowID,valList)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	
 	TCOMMIT
 	q RowID
ERRORSave 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQSwapNew).DeleteSwapList("231",",0,-1")
/// ----------------------------------
ClassMethod DeleteSwapList(SRowID, DelRowid)
{
	new Length,SLRowID,Flag,i
	s Flag=0
	i SRowID="" q -1
	i DelRowid="" q 0
	s Length=$l(DelRowid,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s SLRowID=$p(DelRowid,",",i)
		if (SLRowID>0)
		{
			&SQL(delete from  sqluser.DHC_EQSwapList where SL_RowID=:SLRowID)
			i SQLCODE s Flag=SLRowID_"^更新操作失败"
		}
	}
	q Flag
}

/// w ##Class(web.DHCEQSwapNew).SaveSwapList("241","1^365^^361^担架车^2^30^2^922^1601")
/// ----------------------------------
ClassMethod SaveSwapList(SRowID, val)
{
	new (SRowID, val)
	i SRowID="" q -1
	i val="" q 0
	s Flag=0
	s PLISTMX(2)=SRowID  				;SwapDR
	s Length=$l(val,"&")
	for i=1:1:Length
	{
		q:Flag'=0
		s SQLCODE=0
		s valList=	$p(val,"&",i)
		;TRow+"^"+TRowID+"^"+TMasterItemDR+"^"+TModelDR+"^"+TQuantityNum+"^"+TSupplementNum+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5
		s index= $p(valList,"^",1)  		;index
		s SLRowID= $p(valList,"^",2)  		;SLRowID
		s PLISTMX(3)=$p(valList,"^",3)  	;TMasterItemDR
		s PLISTMX(4)=$p(valList,"^",4)		;TModelDR
		s PLISTMX(5)=$p(valList,"^",5)  	;TQuantityNum
		s PLISTMX(6)=$p(valList,"^",6)  	;TSupplementNum
		s PLISTMX(7)=$p(valList,"^",7)  	;THold1
		s PLISTMX(8)=$p(valList,"^",8)  	;THold2
		s PLISTMX(9)=$p(valList,"^",9)  	;THold3
		s PLISTMX(10)=$p(valList,"^",10)  	;THold4
		s PLISTMX(11)=$p(valList,"^",11)  	;THold5
	
		;s QuantityNum=PLISTMX(5)
		if (SLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQSwapList Values :PLISTMX())
		}
		else
		{
			&SQL(update sqluser.DHC_EQSwapList values :PLISTMX() where SL_RowID=:SLRowID)
		}
		
		i SQLCODE s Flag=index_"^更新明细记录失败!"
	}
	q Flag
}

/// 描述:反提交
/// w ##Class(web.DHCEQSwapNew).CancelSubmitData("202^^1^^5^1^112^28")
ClassMethod CancelSubmitData(val, CurRole)
{
	new (val,CurRole)
	Set $ZT="ERRORCancel"
	s RowID=$P(val,"^",1)
	q:RowID=""
	s User=$P(val,"^",7)
	s CancelToFlowDR=$P(val,"^",9)
	s ApproveSet=$P(val,"^",10)
	s Date=+$H

	s Status="0"
	s ApproveRoleDR=""
	s Step=""
	if (CancelToFlowDR'="")
	{
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
	}	 	

	s PLIST(11)=Status

	TSTART
	s AppInfo(5)=ApproveRoleDR
	s AppInfo(6)=Step
	s AppInfo(7)=""		;ApproveStatus
	s AppInfo(8)=""		;ApproveRoleDR
	s AppInfo(9)=Status	;Status	

	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("23")
	//add by zy 2011-03-16 
	s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))		
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(update sqluser.DHC_EQSwap values :PLIST() where S_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	else
	{
		;Modified by jdl 2011-3-2  jdl0071
		s ApproveFlow=""
		i CancelToFlowDR'=""
		{
			s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)
		}
		s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("21", RowID, User, ApproveFlow, "Y",CurRole)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORCancel
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息 ;
}

/// 描述:提交
/// w ##Class(web.DHCEQSwapNew).SubmitData("174^^1^^9^2","")
ClassMethod SubmitData(val, valList)
{
	new (val, valList)
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	
	s InvalidFlag=$p($g(^DHCEQSwap(RowID)),"^",25)
	i InvalidFlag="Y" q -1015
	
	Set $ZT="ERRORSubmit"
	s User=$P(val,"^",7)
	
	s Date=+$H
	s Time=$P($H,",",2)
  	
  	s PLIST(11)="1"		;Status
	s PLIST(15) = User	;SubmitUserDR
 	s PLIST(16) = Date	;SubmitDate
	s PLIST(17) = Time	;SubmitTime
	
	;判断类组是否一致
	;s EquipTypeDR=$p($g(^DHCEQInStock(RowID)),"^",20)
	;s StatCatDR=$p($g(^DHCEQInStock(RowID)),"^",21)	
	;s ReturnEquipType=..EquipTypeIsUniqueNew(RowID,EquipTypeDR,"InStock")	
	;i ReturnEquipType<0 q ReturnEquipType
	
	;s Flag=##class(web.DHCEQCommon).GetSysInfo("301007")   //单据中设备类型是否需要一致
	;if (Flag=1)
	;{
	;	s ReturnType=..StatCatIsUniqueNew(RowID,StatCatDR)
	;	i ReturnType<0 q ReturnType
	;} 
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("23")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "被服类组", "", "", "","")
	i ApproveSet="" q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)

	s AppInfo(2)=ApproveType
	s AppInfo(3)=RowID
	s AppInfo(4)=ApproveSet
	s AppInfo(5)=NextRole
	s AppInfo(6)=NextStep
	s AppInfo(7)=""			;ApproveStatus  当前审核步骤
	s AppInfo(8)=""			;ApproveRoleDR	
	s AppInfo(9)="1"		;Status
	
	s AuditFlag=0
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s AuditFlag=1
		s PLIST(11)="2"		;Status
		s PLIST(18)=User	;AuditUserDR
		s PLIST(19)=Date	;AuditDate
		s PLIST(20)=Time	;AuditTime
		s AppInfo(9)="2"	;Status
	}
	
	s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))	
	TSTART
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"23",User)
	
	i SQLCODE
	{
		TROLLBACK
	 	q SQLCODE
	}

	if ApproveInfoID=""
 	{
	 	&SQL(insert into sqluser.DHC_EQApproveInfo values :AppInfo())		
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)		
 	}
 	
 	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(update sqluser.DHC_EQSwap values :PLIST() where S_RowID=:RowID)
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	;最后一步,需要调用审核方法
	if AuditFlag=1
	{
		s SQLCODE=..LastAuditAction(RowID, User, Date, val, valList)
		
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	;消息处理
	;s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("21", RowID, User, ApproveFlow, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
 	
ERRORSubmit 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

/// 描述:审核
/// w ##Class(web.DHCEQSwapNew).AuditData("202^^1^^5^1^^28","","23","2","202^,3^,4@455^1111113434,1^11111343434,2")
ClassMethod AuditData(val, valList, CurRole, RoleStep, editFieldsInfo)
{
	;new (val, CurRole,RoleStep, editFieldsInfo)
	n EquipType,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	n User,Date,RowID,AuditFlag
	Set $ZT="ERRORAudit"
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	
	s User=$P(val,"^",7)
	s Date=+$H
	s Time=$P($H,",",2)
	s AppInfo(7)=RoleStep	;ApproveStatus
	s AppInfo(8)=CurRole	;ApproveRoleDR
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("23")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("23", RowID)	
	i ApproveSet="" q -4007	
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)

	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfo(5)=NextRole
	s AppInfo(6)=NextStep	
	s AppInfo(9)="1"	;Status	
	

	TSTART
	s AuditFlag=0
	i ((NextStep="")||(LastFlag="Y"))
	{
		i ($p($g(^DHCEQSwap(RowID)),"^",10)=2)
		{
			TROLLBACK
			q -1010
		}
		s AuditFlag=1
		s PLIST(11)="2"
		s PLIST(18)=User	;AuditUserDR
		s PLIST(19)=Date	;AuditDate
		s PLIST(20)=Time	;AuditTime
		&SQL(update sqluser.DHC_EQSwap values :PLIST() where S_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		
		s AppInfo(9)="2"	;Status
	}
	
	;生成审批记录
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep)
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	;记录单据当前审批状态
	//add by zy 2011-03-16 
	s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))		
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}	
	if editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)		//编辑要修改的字段
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	;最后一步,需要调用审核方法
	if AuditFlag=1
	{
		s SQLCODE=..LastAuditAction(RowID, User, Date, val, valList)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}		
	}

	;s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("23", RowID, User, ApproveFlow, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// 描述：最终审核时需调用此方法,执行审核中需要处理的数据
/// 	在此处，需调用
/// w ##Class(web.DHCEQSwapNew).LastAuditAction(52,1,61963)
/// ----------------------------------
ClassMethod LastAuditAction(RowID, User, Date, val, valList)
{
	s Type=$P($G(^DHCEQSwap(RowID)),"^",2)
	s SQLCODE=##Class(web.DHCEQSwapNew).DamagedCostAllot(RowID, Type)
	i SQLCODE q SQLCODE
	s SQLCODE=##Class(web.DHCEQSwapNew).ChangeStock(RowID, Type, val)
	q SQLCODE
}

/// 在DHC_EQDamaged,DHC_EQEquip中更新相应变动信息
/// by marui 2014-04-04  MR0014
ClassMethod ChangeStock(RowID, Type, val, valList)
{
	;RowID,Type,LocDR,RequestLocDR,RequestDate,RequestUserDR,LOGON.USERID,Job,CancelToFlowDR,ApproveSetDR
	i RowID=""  q
	s SQLCODE=0
	s (SMVal,SMLVal,RLVal)=""
	;val=RowID_"^"_FromLocDR_"^"_ToLocDR_"^"_MoveType_"^"_Remark_"^"_ReciverDR_"^"_EquipTypeDR_"^"_StatCatDR_"^"_LOGON.USERID_"^"_CancelToFlowDR_"^"_ApproveSetDR_"^"_Job
	;先退库
	s FromLocDR=$P(val,"^",4)
	s ToLocDR=$P(val,"^",3)
	s MoveType="3"
	s Remark=""
	s ReciverDR=""
	s EquipTypeDR=""
	s StatCatDR=""
	s UserID=$P(val,"^",7)
	s Job=$P(val,"^",8)
	s SMVal=""_"^"_FromLocDR_"^"_ToLocDR_"^"_MoveType_"^"_Remark_"^"_ReciverDR_"^"_EquipTypeDR_"^"_StatCatDR_"^"_UserID_"^^^"_Job
	;TRow+"^"+TRowID+"^"+TMasterItemDR+"^"+TModelDR+"^"+TQuantityNum+"^"+TSupplementNum+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5;		
	;"^"+TInStockListDR+"^"+TManuFactoryDR+"^"+TOriginalFee+"^"+TUnitDR+"^"+TLocationDR
	s Length=$l(valList,"&")
	for i=1:1:Length
	{
		;i_"^"_TRowID_"^"_TEquipDR_"^"_TInStockListDR_"^"_TEquip_"^"_TManuFactoryDR_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TModelDR_"^"_TUnitDR_"^"_TRemark_"^"_TLocationDR_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5;
		s List=$P(valList,"&",i)
		s TRow=$P(List,"^",1)
		s TRowID=""
		s TEquipDR=$P(List,"^",3)
		s TInStockListDR=$P(List,"^",12)
		s TEquip=$P(List,"^",17)
		s TManuFactoryDR=$P(List,"^",13)
		s TOriginalFee=$P(List,"^",14)
		s TQuantityNum=$P(List,"^",5)
		s TModelDR=$P(List,"^",4)
		s TUnitDR=$P(List,"^",15)
		s TLocationDR=$P(List,"^",16)
		i SMLVal'="" s SMLVal=SMLVal_"&"
		s SMLVal=SMLVal_TRow_"^"_TRowID_"^"_TEquipDR_"^"_TInStockListDR_"^"_TEquip_"^"_TManuFactoryDR_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TModelDR_"^"_TUnitDR_"^^"_TLocationDR_"^^^^^"
		;i RLVal'="" s RLVal=RLVal_"&"
		;s RLVal=RLVal_TRow_"^"_TRowID_"^"_TInStockListDR_"^"_TEquipDR_"^"_TQuantityNum_"^"_TOriginalFee_"^^^^^^^"
	}
	
	
	i Type="2" ;若为更换  则先退库后出库操作
	{	
		s SQLCODE=..StoreMove(SMVal, SMLVal, "Y")  ;先退库
		s (SMValInfo,SMLValInfo)=""
		s FromLocDR=$P(val,"^",3)
		s ToLocDR=$P(val,"^",4)
		s MoveType="0"
		s Remark=""
		s ReciverDR=""
		s EquipTypeDR=""
		s StatCatDR=""
		s UserID=$P(val,"^",7)
		s Job=$J
		s SMValInfo=""_"^"_FromLocDR_"^"_ToLocDR_"^"_MoveType_"^"_Remark_"^"_ReciverDR_"^"_EquipTypeDR_"^"_StatCatDR_"^"_UserID_"^^^"_Job
		s Length=$l(SMLVal,"&")
		s index=1
		for i=1:1:Length
		{
			s SMLInfo=$P(SMLVal,"&",i)
			s InStockListDR=$P(SMLInfo,"^",4)
			s EquipName=$P(SMLInfo,"^",5)
			s QuantityNum=$P(SMLInfo,"^",8)
			s ModelDR=$P(SMLInfo,"^",9)
			s qty=QuantityNum
			s TInStockListDR=0
			f  s TInStockListDR=$o(^DHCEQEquip(0,"StoreInStock",FromLocDR,EquipTypeDR,1,"N",TInStockListDR)) q:(TInStockListDR="")||(qty=0)  d
			.s Num=0
			.s EquipDR=0
			.s RowIDS=""
			.f  s EquipDR=$o(^DHCEQEquip(0,"StoreInStock",FromLocDR,EquipTypeDR,1,"N",TInStockListDR,EquipDR)) q:(EquipDR="")||(qty=Num)  d
			..s TName = $p($g(^DHCEQEquip(EquipDR)),"^",1)
			..q:TName'=EquipName
			..s TModelDR=$p($g(^DHCEQEquip(EquipDR)),"^",3)
			..q:TModelDR'=ModelDR
			..s TStatCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",75)
			..q:TStatCatDR'=StatCatDR
			..s EquipStatus=$p($g(^DHCEQEquip(EquipDR)),"^",38)		;Status
			..q:(EquipStatus="3")||(EquipStatus="4")
			..q:$p($g(^DHCEQEquip(EquipDR)),"^",59)="Y"
			..s TManuFactoryDR=$p($g(^DHCEQEquip(EquipDR)),"^",26)
			..s TOriginalFee=$p($g(^DHCEQEquip(EquipDR)),"^",27)
			..s TUnitDR=$p($g(^DHCEQEquip(EquipDR)),"^",5)
			..;q:##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR(RowID,EquipDR,FromLocDR,"1")'=0 后面有判断
			..i RowIDS'=""  s RowIDS=RowIDS_","
			..s RowIDS=RowIDS_EquipDR
			..s Num=Num+1
			.s qty=qty-Num	;通过差值验证出库数量和退库数量是否一致，一致则退出整个循环，不一致则在下一个InStockListDR继续循环，直到数量一致
			.s TEquipDR=""
			.i Num=1  s TEquipDR=EquipDR
			.i qty'=QuantityNum  d
			..i SMLValInfo'="" s SMLValInfo=SMLValInfo_"&"
			..s SMLValInfo=SMLValInfo_index_"^"_""_"^"_TEquipDR_"^"_TInStockListDR_"^"_TName_"^"_TManuFactoryDR_"^"_TOriginalFee_"^"_Num_"^"_TModelDR_"^"_TUnitDR_"^^^^^^^"
			..s ^TEMPEQ("MXList","EX",Job,index)=RowIDS
			..s index=index+1
			
		}
		s SQLCODE=..StoreMove(SMValInfo, SMLValInfo, "N")  ;出库
	}
	i Type="1" ;若为销毁  则减少操作
	{
		s Date=+$H
		s Time=$P($H,",",2)
		s User= $p(SMVal,"^",7)
 		s PLIST(3) = $p(SMVal,"^",3)	;ReturnLocDR
 		;s PLIST(4) = ""	;ProviderDR
 		s PLIST(5) = Date	;ReturnDate
 		s PLIST(6) = User			;MakerDR
 		s PLIST(7) = Date			;MakeDate
		s PLIST(14)="2"				;Status
 		s PLIST(16) = ""	;EquipTypeDR
 		s PLIST(17) = ""	;StatCatDR
 		;s PLIST(18) = 	;OutTypeDR
 		;s PLIST(19) = ""	;ToDeptDR
 	
 		;s PLIST(20) = $p(SMVal,"^",10)	;Hold1
 		;s PLIST(21) = $p(SMVal,"^",11)	;Hold2
 		;s PLIST(22) = $p(SMVal,"^",12)	;Hold3
		s Job = $p(SMVal,"^",10) 		;$job
		s PLIST(25) = $p(SMVal,"^",2) ;UseLocDR
		s PLIST(29) = "N"
	
	 	s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQReturn",+$H,"","")
	 	&SQL(insert into sqluser.DHC_EQReturn values :PLIST())

		s RowID=$G(%ROWID)

		;i+"^"+TRowID+"^"+TInStockListDR+"^"+TEquipDR+"^"+TReturnQtyNum+"^"+TReturnFee+"^"+TInvoiceNo+"^"+TReturnReasonDR+"^"+TRemark;
		;"^"+TDealFee+"^"+THold1+"^"+THold2+"^"+THold3;
 		
		s Job=$J
		s Length=$l(SMLVal,"&")
		s index=1
		for i=1:1:Length
		{
			s SMLInfo=$P(SMLVal,"&",i)
			s InStockListDR=$P(SMLInfo,"^",4)
			s EquipName=$P(SMLInfo,"^",5)
			s QuantityNum=$P(SMLInfo,"^",8)
			s ModelDR=$P(SMLInfo,"^",9)
			s qty=QuantityNum
			s TInStockListDR=0
			f  s TInStockListDR=$o(^DHCEQEquip(0,"StoreInStock",FromLocDR,EquipTypeDR,1,"N",TInStockListDR)) q:(TInStockListDR="")||(qty=0)  d
			.s Num=0
			.s EquipDR=0
			.s RowIDS=""
			.f  s EquipDR=$o(^DHCEQEquip(0,"StoreInStock",FromLocDR,EquipTypeDR,1,"N",TInStockListDR,EquipDR)) q:(EquipDR="")||(qty=Num)  d
			..s TName = $p($g(^DHCEQEquip(EquipDR)),"^",1)
			..q:TName'=EquipName
			..s TModelDR=$p($g(^DHCEQEquip(EquipDR)),"^",3)
			..q:TModelDR'=ModelDR
			..s TStatCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",75)
			..q:TStatCatDR'=StatCatDR
			..s EquipStatus=$p($g(^DHCEQEquip(EquipDR)),"^",38)		;Status
			..q:(EquipStatus="3")||(EquipStatus="4")
			..q:$p($g(^DHCEQEquip(EquipDR)),"^",59)="Y"
			..s TManuFactoryDR=$p($g(^DHCEQEquip(EquipDR)),"^",26)
			..s TOriginalFee=$p($g(^DHCEQEquip(EquipDR)),"^",27)
			..s TUnitDR=$p($g(^DHCEQEquip(EquipDR)),"^",5)
			..;q:##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR(RowID,EquipDR,FromLocDR,"1")'=0 后面有判断
			..i RowIDS'=""  s RowIDS=RowIDS_","
			..s RowIDS=RowIDS_EquipDR
			..s Num=Num+1
			.s qty=qty-Num	;通过差值验证减少数量和退库数量是否一致，一致则退出整个循环，不一致则在下一个InStockListDR继续循环，直到数量一致
			.s TEquipDR=""
			.i Num=1  s TEquipDR=EquipDR
			.i qty'=QuantityNum  d
			..i RLVal'="" s RLVal=RLVal_"&"
			..s RLVal=RLVal_index_"^"_""_"^"_TInStockListDR_"^"_TEquipDR_"^"_Num_"^"_TOriginalFee_"^^^^^^^"
			..s ^TEMPEQ("MXList","EX",Job,index)=RowIDS
			..s index=index+1
			
		}
 		
 		
 		;s SQLCODE=##Class(web.DHCEQReturnNew).JudgeRLQuantityNum(RowID,Job,RLVal)
 		;i SQLCODE q SQLCODE
 		s SQLCODE=##Class(web.DHCEQReturnNew).SaveReturnList(RowID,Job,RLVal)
 		i SQLCODE q SQLCODE
 		;Modified by JDL 2011-8-25 JDL0094 检查是否设备已经被其他单据占用
 		s SQLCODE=##Class(web.DHCEQStoreMoveNew).CheckOrder(2,RowID)
 		i SQLCODE q SQLCODE
 		s SQLCODE=##Class(web.DHCEQReturnNew).LastAuditAction(RowID, User, Date)
 		i SQLCODE q SQLCODE
	}
	
	q SQLCODE
}

/// RowIDS为空时,表示退库操作，ID串在业务操作中正常选中的
/// RowIDS不为空时,表示为退库之后的相关操作如出库等，ID串是在后台程序中获取的新串，不能包含退库中的设备ID
ClassMethod StoreMove(val, valList, Flag)
{
	
	s Date=+$H
	s Time=$P($H,",",2)
	s RowID = $p(val,"^",1)	;RowID
	s User=$p(val,"^",9)
	s Job = $p(val,"^",12)
	s PLIST(3) = $p(val,"^",2)	;FromLocDR
	s PLIST(4) = $p(val,"^",3)	;ToLocDR
	s PLIST(5) = User			;MakerDR
	s PLIST(6) = Date			;MakeDate
	s PLIST(10)=User
	s PLIST(11)=Date
	s PLIST(13) = $p(val,"^",4)	;MoveType
	s PLIST(14) = "2"			;Status
	s PLIST(15) = $p(val,"^",5)	;Remark
	s PLIST(16) = $p(val,"^",6)	;ReciverDR
	s PLIST(17) = $p(val,"^",7)	;EquipTypeDR
	s PLIST(18) = $p(val,"^",8) ;StatCatDR
	s PLIST(28) = "N"

	s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQStoreMove",+$H,"",$p(val,"^",7))
	&SQL(insert into sqluser.DHC_EQStoreMove values :PLIST())
	s RowID=$G(%ROWID)
	i Falg="Y"
	{	
 		s SQLCODE=##Class(web.DHCEQStoreMoveNew).JudgeSMLQuantityNum(RowID,Job,valList)
		i SQLCODE q SQLCODE
	}
 	;s SQLCODE=##Class(web.DHCEQStoreMoveNew).DeleteStoreMoveList(RowID,DelRowid)
	i SQLCODE q SQLCODE
 	s SQLCODE=##Class(web.DHCEQStoreMoveNew).SaveStoreMoveList(RowID,Job,valList)
	i SQLCODE q SQLCODE
 	;Modified by JDL 2011-8-25 JDL0094 检查是否设备已经被其他单据占用
 	s SQLCODE=##Class(web.DHCEQStoreMoveNew).CheckOrder(1,RowID)
	i SQLCODE q SQLCODE
	s SQLCODE=##Class(web.DHCEQStoreMoveNew).LastStepAction(RowID, User)
	i SQLCODE q SQLCODE
	
	q 0
}

/// w ##Class(web.DHCEQSwapNew).GetOneSwapList("197")
ClassMethod GetOneSwapList(rowid)
{
	new (rowid)
	s (result,resultex,apprInfo)=""
	s result= ^DHCEQSwap(rowid)
	s resultex=resultex_"^" ;LocDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))
	s resultex=resultex_"^"	;RequestLocDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",4))
	s $p(result,"^",5)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")	;RequestDate
	s resultex=resultex_"^"	;RequestUserDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",6))
	s $p(result,"^",8)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")	;StartDate
	i $p(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")	;EndDate

	s apprInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("23",rowid)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex_"^$"_apprInfo
}

/// Date:为DHC_EQSwap表AuditDate
/// w ##Class(web.DHCEQSwapNew).DateToQuarter("")
ClassMethod DateToQuarter(Date)
{
	i Date = "" s Date=+$H
	s Date = ##class(web.DHCEQCommon).TransValueToPage(Date,"date")
	s Year = $P(Date,"/",3)
	s Month = $P(Date,"/",2)
	i Month <= 3  q "01/01/"_Year_"^31/03/"_Year
	i 3 < Month <= 6  q "01/04/"_Year_"^30/06/"_Year
	i 6 < Month <= 9  q "01/07/"_Year_"^30/09/"_Year
	i 9 < Month <= 12 q "01/10/"_Year_"^31/12/"_Year
}

/// 统计各科室各被服的洗涤次数
/// RowID：DHC_EQSwap表RowID
/// 该方法要在销毁更换单审核之后才能调用
ClassMethod GetWashTotal(RowID, job)
{
	n Type,StartDate,EndDate,InvalidFlag
	s (Type,StartDate,EndDate,InvalidFlag)=""
	k ^DHCEQTemp("WashTotal",job)
	k ^DHCEQTemp("MasterItemWashTotal",job)
	i RowID = "" q 1
	s Type = $P($G(^DHCEQSwap(RowID)),"^",2)
	i Type '= "1" q 1
	s StartDate = $P($G(^DHCEQSwap(RowID)),"^",8)
	s EndDate = $P($G(^DHCEQSwap(RowID)),"^",9)
	s AuditDate=StartDate-1
	f  s AuditDate=$o(^DHCEQWash(0,"AuditDate",AuditDate))  quit:AuditDate=""  d
	.q:AuditDate>EndDate
	.s rowid=0
	.f  s rowid=$o(^DHCEQWash(0,"AuditDate",AuditDate,rowid))  quit:rowid=""  d
	..s InvalidFlag=$P($G(^DHCEQWash(rowid)),"^",23)
	..q:InvalidFlag="Y" 
	..s WLRowID=0
	..f  s WLRowID=$o(^DHCEQWashList(0,"Wash",rowid,WLRowID))  quit:WLRowID=""  d
	...s MasterItemDR=$P($G(^DHCEQWashList(WLRowID)),"^",2)
	...s LocDR=$P($G(^DHCEQWashList(WLRowID)),"^",5)
	...s QuantityNum=$P($G(^DHCEQWashList(WLRowID)),"^",4)
	...s ^DHCEQTemp("WashTotal",job,MasterItemDR,LocDR)=+$G(^DHCEQTemp("WashTotal",job,MasterItemDR,LocDR))+QuantityNum
	...s ^DHCEQTemp("MasterItemWashTotal",job,MasterItemDR)=+$G(^DHCEQTemp("MasterItemWashTotal",job,MasterItemDR))+QuantityNum
	q 0
}

/// 计算被服科室分摊销毁数
/// RowID：DHC_EQSwap表RowID
/// 该方法要在销毁更换单审核之后才能调用
/// Type:1.销毁  2.更换
/// w ##Class(web.DHCEQSwapNew).DamagedCostAllot("")
ClassMethod DamagedCostAllot(RowID, Type As %String = "2")
{
	n (RowID, Type)
	s (StartDate,EndDate,AuditDate,InvalidFlag)=""
	s job=$j
	s StartDate = $P($G(^DHCEQSwap(RowID)),"^",8)
	s EndDate = $P($G(^DHCEQSwap(RowID)),"^",9)
	i Type="1"
	{
		s Flag=..GetWashTotal(RowID, job)
		i Flag=0
		{
			s AuditDate=StartDate-1
			f  s AuditDate=$O(^DHCEQSwap(0,"AuditDate",AuditDate))  quit:AuditDate=""  d
			.q:AuditDate>EndDate
			.s rowid=0
			.f  s rowid=$O(^DHCEQSwap(0,"AuditDate",AuditDate,rowid))  quit:rowid=""  d
			..s InvalidFlag=$P($G(^DHCEQSwap(rowid)),"^",25)
			..s Type=$P($G(^DHCEQSwap(rowid)),"^",2)
			..q:(InvalidFlag="Y")||(Type'="1")
			..s SLRowID=0
			..f  s SLRowID=$O(^DHCEQSwapList(0,"Swap",rowid,SLRowID))  quit:SLRowID=""  d
			...s MasterItemDR=$P($G(^DHCEQSwapList(SLRowID)),"^",2)
			...s ModelDR=$P($G(^DHCEQSwapList(SLRowID)),"^",3)
			...s DamagedQty=$P($G(^DHCEQSwapList(SLRowID)),"^",4) ;销毁数量
			...;科室分摊计算
			...s LocID=0
			...f  s LocID=$O(^DHCEQTemp("WashTotal",job,MasterItemDR,LocID))  quit:LocID=""  d
			....s QuantityNum=+$G(^DHCEQTemp("WashTotal",job,MasterItemDR,LocID))
			....s WashTotal=+$G(^DHCEQTemp("MasterItemWashTotal",job,MasterItemDR))
			....s DamagedAllotQty=DamagedQty*QuantityNum/WashTotal
			....s num=+$P($G(^DHCEQSwapListDetail(0,"AutoCostAllot",LocID,MasterItemDR)),"^",2)+DamagedAllotQty
			....s AutoQty=..AutoCostAllot(num)
			....s Difference=num-AutoQty
			....s AutoQtystring=DamagedAllotQty_"^"_Difference
			....s val=rowid_"^"_SLRowID_"^"_MasterItemDR_"^"_ModelDR_"^"_AutoQty_"^"_AutoQty_"^"_LocID
			....s SaveFlag=..SaveSwapListDetail("", val, AutoQtystring) ;第一个参数默认传空
			....q:SaveFlag=1
		}
	}
	else{
		s SLRowID=0
		f  s SLRowID=$O(^DHCEQSwapList(0,"Swap",RowID,SLRowID))  quit:SLRowID=""  d
		..s LocID=$P($G(^DHCEQSwap(RowID)),"^",4)
		..s val=$G(^DHCEQSwapList(SLRowID))
		..s $p(val,"^",1)=$p(val,"^",1)_"^"_SLRowID
		..s $p(val,"^",6)=$p(val,"^",6)_"^"_LocID
		..s SaveFlag=..SaveSwapListDetail("", val, "") ;第一第三参数默认传空
		..q:SaveFlag=1
	}
	k ^DHCEQTemp("WashTotal",job)
	k ^DHCEQTemp("MasterItemWashTotal",job)
	q 0
}

/// 四舍五入
/// w ##Class(web.DHCEQSwapNew).AutoCostAllot("")
ClassMethod AutoCostAllot(num) As %String [ Language = basic ]
{
	return Round(num)
}

/// 保存分摊之后的被服销毁数据
/// RowID：DHC_EQSwapListDetail表RowID
/// 该方法要在销毁更换单审核之后才能调用
ClassMethod SaveSwapListDetail(RowID, val, numstring)
{
	s Flag=0
	k PLIST
	s PLIST(2)=$P(val,"^",1) ;SwapDR
	s PLIST(3)=$P(val,"^",2) ;SwapListDR
	s PLIST(4)=$P(val,"^",3) ;MasterItemDR
	s PLIST(5)=$P(val,"^",4) ;ModelDR
	s PLIST(6)=$P(val,"^",5) ;QuantityNum
	s PLIST(7)=$P(val,"^",6) ;SupplementNum
	s PLIST(8)=$P(val,"^",7) ;LocDR
	;s PLIST(9)=$P(val,"^",9) ;Hold1
	;s PLIST(10)=$P(val,"^",10) ;Hold2
	;s PLIST(11)=$P(val,"^",11) ;Hold3
	;s PLIST(12)=$P(val,"^",12) ;Hold4
	;s PLIST(13)=$P(val,"^",13) ;Hold5
	i RowID = ""{
		&SQL(insert into sqluser.DHC_EQSwapListDetail values :PLIST())
		i ((numstring'="")&&($P(^DHCEQSwap(PLIST(2)),"^",2))="1")
		{
			s ^DHCEQSwapListDetail(0,"AutoCostAllot",PLIST(8),PLIST(4))=numstring	
		}
	}else{
		;&SQL(update sqluser.DHC_EQSwapListDetail values :PLIST() where SLD_RowID=:RowID)
		;i ((numstring'="")&&($P(^DHCEQSwap(PLIST(2)),"^",2))="1")
		;{
		;	s ^DHCEQSwapListDetail(RowID,"AutoCostAllot")=numstring	
		;}
	}
	i SQLCODE  s Flag=1
	q Flag
}

}
