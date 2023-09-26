/// add by zy 2014-12-29
/// 用于预算管理主要涉及两个表:DHC_EQBudget,DHC_EQBudgetUsed
Class web.DHCEQBudget Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 判断当前业务用到的金额是否超过预算金额的同时更新预算表中占用和使用金额
/// 返回值 0  正确
/// 		  -1001 没有预算信息设置
/// 		  -1002 已用和占用金额之和超过预算金额
/// w ##Class(web.DHCEQBudget).UpdateBudgetInfo(7,1,1)
ClassMethod UpdateBudgetInfo(SourceType, SourceID, Status, ContinueFlag As %Library.String = "N")
{
	new User,Date,Time,BudgetYear,SQLCODE
	new UsedType,UsedFee,EquipID,UseLocDR
	new BURowID,BudgetID,BudgetAmount,RemainAmount,FreezeAmount
	s (UsedType,EquipID,UseLocDR,BURowID,BudgetID)=""
	s (UsedFee,BudgetAmount,RemainAmount,FreezeAmount,SQLCODE)=0
	k PLIST
	;s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s User=1
	s Date=+$H
	s Time=$p($H,",",2)
	s BudgetYear=+$p($ZD(Date,3),"-",1)
	if SourceType="7"
	{
		s UsedType="2"
		s UsedFee=$p($g(^DHCEQMaintRequest(SourceID)),"^",42)
		s EquipID=$p($g(^DHCEQMaintRequest(SourceID)),"^",1)
		s UseLocDR=$p($g(^DHCEQequip(EquipID)),"^",19)
	}
	s BURowID=$o(^DHCEQBudgetUsed(0,"Source",SourceType,SourceID,0))
	quit:(BURowID="")&(Status=3) 0 //单据更新完直接删除不需要处理预算信息
	i BURowID'=""
	{
		s BudgetID=$p($g(^DHCEQBudgetUsed(BURowID)),"^",1)
		s BUStatus=$p($g(^DHCEQBudgetUsed(BURowID)),"^",5)
	}
	i BudgetID=""  s BudgetID=##Class(web.DHCEQBudget).JudgeBudgetID(1,BudgetYear,UsedType,"","","")
	//i BudgetID=""  quit -1001 	;没有预算信息设置
	i BudgetID=""  quit 0 	;没有预算信息设置也返回0	//Add By DJ 2015-07-14 DJ0147
	s BudgetAmount=$p($g(^DHCEQBudget(BudgetID)),"^",6)
	s RemainAmount=$p($g(^DHCEQBudget(BudgetID)),"^",11)
	s FreezeAmount=$p($g(^DHCEQBudget(BudgetID)),"^",12)
	
	i BURowID=""
	{
		s FreezeAmount=FreezeAmount+UsedFee
	}
	else
	{
		s FreezeAmount=FreezeAmount+UsedFee-$p($g(^DHCEQBudgetUsed(BURowID)),"^",4)
	}
	i ContinueFlag="N"&(BudgetAmount<(FreezeAmount+RemainAmount)) quit -1002 ;已用和占用金额之和超过预算金额
	
	s PLIST(6)=Status ;BU_Status
	if +Status<2
	{
		s PLIST(2)=BudgetID	;BU_BudgetDR
		s PLIST(3)=SourceType ;BU_SourceType
		s PLIST(4)=SourceID ;BU_SourceID
		s PLIST(5)=UsedFee ;BU_UsedAmount
		s PLIST(7)=User	;BU_AddUserDR
		s PLIST(8)=Date	;BU_AddDate
		s PLIST(9)=Time	;BU_AddTime
	}
	elseif +Status=2
	{
		s PLIST(10)=User	;BU_AuditUserDR
		s PLIST(11)=Date	;BU_AuditDate
		s PLIST(12)=Time	;BU_AuditTime
	}
	elseif +Status=3
	{
		s PLIST(13)=""	;BU_CancelUserDR
		s PLIST(14)=""	;BU_CancelDate
		s PLIST(15)=""	;BU_CancelTime
	}
	s PLIST(16)=""	;BU_Hold1
	s PLIST(17)=""	;BU_Hold2
	s PLIST(18)=""	;BU_Hold3
	s PLIST(19)=""	;BU_Hold4
	s PLIST(20)=""	;BU_Hold5
	if BURowID=""
	{
		&sql(Insert Into SQLUser.DHC_EQBudgetUsed Values :PLIST())
	}
	Else
	{
		&sql(Update sqluser.DHC_EQBudgetUsed Values :PLIST() where BU_RowID=:BURowID)
	}
	If SQLCODE
	{
		Quit SQLCODE
	}
	if Status<2
	{
		&sql(Update sqluser.DHC_EQBudget set B_FreezeAmount=:FreezeAmount where B_RowID=:BudgetID)
	}
	elseif Status=2
	{
		s RemainAmount=RemainAmount+UsedFee
		s FreezeAmount=FreezeAmount-UsedFee
		&sql(Update sqluser.DHC_EQBudget set B_RemainAmount=:RemainAmount,B_FreezeAmount=:FreezeAmount where B_RowID=:BudgetID)
	}
	elseif Status=3
	{
		i BUStatus=2 s RemainAmount=RemainAmount-UsedFee
		s FreezeAmount=FreezeAmount-UsedFee
		&sql(Update sqluser.DHC_EQBudget set B_RemainAmount=:RemainAmount,B_FreezeAmount=:FreezeAmount where B_RowID=:BudgetID)
	}
	If SQLCODE
	{
		Quit SQLCODE
	}
	quit SQLCODE
}

/// 根据相关信息获取审批设置
/// w ##Class(web.DHCEQBudget).JudgeBudgetID(14,1,"","","","","")
ClassMethod JudgeBudgetID(BudgetType, BudgetYear, UsedType, UseLocDR, UsedRangeType, UsedRange)
{
	new presetid,preminnum,minnum
	if (BudgetType="")||(BudgetYear="")||(UsedType="") q ""
	s (BudgetID,presetid)=""
	s preminnum=""
	///模糊匹配数
	s minnum=0
	s rowid=0
	f  s rowid=$o(^DHCEQBudget(0,"YearUsedType",BudgetType,BudgetYear,UsedType,rowid))  q:(rowid="")||(BudgetID'="")   d
	.s minnum=0
	.quit:$p(^DHCEQBudget(rowid),"^",16)'="2"
	.quit:$p(^DHCEQBudget(rowid),"^",18)="Y"
	.q:BudgetID'=""
	.s vUseLocDR=$p(^DHCEQBudget(rowid),"^",7)
	.q:(vUseLocDR'="")&(vUseLocDR'=UseLocDR)
	.i (UseLocDR'="")&(vUseLocDR="")  s minnum=minnum+1
	.s vUsedRangeType=$p(^DHCEQBudget(rowid),"^",9)
	.q:(vUsedRangeType'="")&(vUsedRangeType'=UsedRangeType)
	.i (UsedRangeType'="")&(vUsedRangeType="")  s minnum=minnum+1
	.s vUsedRange=$p(^DHCEQBudget(rowid),"^",10)
	.q:(vUsedRange'="")&(vUsedRange'[UsedRange)
	.i (UsedRange'="")&(vUsedRange="")  s minnum=minnum+1
	.
	.i minnum=0 s BudgetID=rowid
	.i (minnum>0)&((preminnum="")||(minnum<preminnum))  d
	..s preminnum=minnum
	..s presetid=rowid
	
	i (BudgetID="")&(preminnum>0) s approveset=presetid
	q BudgetID
}

}
