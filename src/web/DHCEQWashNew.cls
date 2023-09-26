/// 修改:qw0002 2013-12-24
/// 添加类组筛选
/// w ##class(%ResultSet).RunQuery("web.DHCEQWashNew","GetWash","1","on","10","","")
Class web.DHCEQWashNew Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetWash(Status, WaitAD, ApproveRole, WashNo, InvalidFlag As %String = "N") As %Query(ROWSPEC = "TRowID:%String,TWashNo:%String,TWashDate:%String,TWashTime:%String,TWasherDR:%String,TWasher:%String,TWashEquipDR:%String,TWashEquip:%String,TWashType:%String,TWashLocDR:%String,TWashLoc:%String,TStatus:%String,TUpdateUserDR:%String,TUpdateUser:%String,TUpdateDate:%String,TUpdateTime:%String,TSubmitUserDR:%String,TSubmitUser:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditUser:%String,TAuditDate:%String,TAuditTime:%String")
{
}

ClassMethod GetWashExecute(ByRef qHandle As %Binary, Status, WaitAD, ApproveRole, WashNo, InvalidFlag As %String = "N") As %Status
{
 	new repid, index,rowid,ApproveType,CurRole
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("22")
	s EquipTypeValues=##class(web.DHCEQCommon).GetSysInfo("990024")
	s index=1
	s rowid=0
	d BuildDataGetWash
	
	Quit $$$OK
BuildDataGetWash
	f  s rowid=$o(^DHCEQWash(rowid))  quit:rowid=""  d
	.d ResetVariablesGetWash
	.s TRowID = rowid
	.s TWashNo = $p($g(^DHCEQWash(rowid)),"^",1)
	.q:TWashNo="" //2011-07-22 DJ
	.q:(WashNo'="")&&($e(TWashNo,1,$l(WashNo))'=WashNo)
	.s TWashDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQWash(rowid)),"^",2),"date")
	.s TWashTime =$p($g(^DHCEQWash(rowid)),"^",3)
	.s TWasherDR = $p($g(^DHCEQWash(rowid)),"^",4)
	.i TWasherDR '=""  d
	..s TWasher = ##class(web.DHCEQCommon).GetTrakNameByID("user",TWasherDR)
	.s TWashEquipDR = $p($g(^DHCEQWash(rowid)),"^",5)
	.i TWashEquipDR '=""  d
	..s TWashEquip = ##class(web.DHCEQCommon).GetTrakNameByID("equip",TWashEquipDR)
	..s TEquipType=$p($g(^DHCEQEquip(TWashEquipDR)),"^",23)
	.i TEquipType'=""  d
	..q:EquipTypeValues'[TEquipType
	.s TWashType=..GetWashTypeDesc($p($g(^DHCEQWash(rowid)),"^",6))
	.s TWashLocDR = $p($g(^DHCEQWash(rowid)),"^",7)
	.i TWashLocDR '=""  d
	..s TWashLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TWashLocDR)
	.s TStatus = $p($g(^DHCEQWash(rowid)),"^",8)
	.q:(WaitAD="on")&&(TStatus="0")
	.q:(Status'="")&&(Status'=TStatus)
	.s TStatus=..GetWashStatus(TStatus)
	.s TUpdateUserDR = $p($g(^DHCEQWash(rowid)),"^",9)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUser)
	.s TUpdateDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQWash(rowid)),"^",10),"date")
	.s TUpdateTime =$p($g(^DHCEQWash(rowid)),"^",11)
	.s TSubmitUserDR = $p($g(^DHCEQWash(rowid)),"^",12)
	.i TSubmitUserDR '=""  d
	..s TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUser)
	.s TSubmitDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQWash(rowid)),"^",13),"date")
	.s TSubmitTime =$p($g(^DHCEQWash(rowid)),"^",14)
	.s TAuditUserDR = $p($g(^DHCEQWash(rowid)),"^",15)
	.i TAuditUserDR '=""  d
	..s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUser)
	.s TAuditDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQWash(rowid)),"^",16),"date")
	.s TAuditTime =$p($g(^DHCEQWash(rowid)),"^",17)
	.s WFlag=$p($g(^DHCEQWash(rowid)),"^",23)
	.i WFlag="" s WFlag="N"
	.q:(InvalidFlag'="")&&(InvalidFlag'=WFlag)
	.
	.s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.i AIRowID'="" s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	.i ((WaitAD="on")&&(CurRole'="")) q:CurRole'=ApproveRole
	.s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("22",rowid)
	.i ApproveInfo'=""  d
	..s TApproveRole=$p(ApproveInfo,"^",9)
	..s TApproveStep=$p(ApproveInfo,"^",5)
	.d OutputRowGetWash
	quit
	
OutputRowGetWash
	s Data=$lb(TRowID,TWashNo,TWashDate,TWashTime,TWasherDR,TWasher,TWashEquipDR,TWashEquip,TWashType,TWashLocDR,TWashLoc,TStatus,TUpdateUserDR,TUpdateUser,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitUser,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditUser,TAuditDate,TAuditTime)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetWash
	s (TRowID,TWashNo,TWashDate,TWashTime,TWasherDR,TWasher,TWashEquipDR,TWashEquip,TWashType,TWashLocDR,TWashLoc,TStatus,TUpdateUserDR,TUpdateUser,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitUser,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditUser,TAuditDate,TAuditTime)=""
	quit
}

ClassMethod GetWashFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWashExecute ]
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

ClassMethod GetWashClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWashExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ----------------------------------
/// 修改:qw 
/// 描述:根据洗涤单的状态显示洗涤单明细信息
/// ----------------------------------
/// d ##class(%ResultSet).RunQuery("web.DHCEQWashNew","GetWashListNew","")
Query GetWashListNew(RowID) As %Query(ROWSPEC = "TMasterItemDR:%String,TModelDR:%String,TLocDR:%String,TLocSendUserDR:%String,TReturnUserDR:%String,TReceiveUserDR:%String,TMasterItem:%String,TLoc:%String,TLocSendUser:%String,TReturnUser:%String,TReceiveUser:%String,TRowID:%String,TWashDR:%String,TQuantityNum:%String,TModel:%String,TRow:%String")
{
}

ClassMethod GetWashListNewExecute(ByRef qHandle As %Binary, RowID) As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	new rowid,TRow,TotalFlag,TotalQty,Total,WashDR
	s (TotalQty,Total)=0
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i TotalFlag="1"  s index=2
	s TRow=0
	s WashDR=RowID
	if WashDR'=""  d
	.s rowid=0 
	.f  s rowid=$o(^DHCEQWashList(0,"Wash",WashDR,rowid))  quit:rowid=""  d
	..d ResetVariablesGetWashListNew
	..s TRowID = rowid
	..s TWashDR = $p($g(^DHCEQWashList(rowid)),"^",1)
	..s TMasterItemDR = $p($g(^DHCEQWashList(rowid)),"^",2)
	..i TMasterItemDR '=""  d
	...s TMasterItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TMasterItemDR)),"^",1)
	..s TModelDR = $p($g(^DHCEQWashList(rowid)),"^",3)
	..i TModelDR '=""  d
	...s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..s TQuantityNum = $p($g(^DHCEQWashList(rowid)),"^",4)
	..s TotalQty=TotalQty+TQuantityNum
	..s TLocDR= $p($g(^DHCEQWashList(rowid)),"^",5)
	..i TLocDR '=""  d
	...s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	..s TLocSendUserDR = $p($g(^DHCEQWashList(rowid)),"^",6)
	..i TLocSendUserDR '=""  d
	...s TLocSendUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TLocSendUserDR)
	..s TReturnUserDR = $p($g(^DHCEQWashList(rowid)),"^",7)
	..i TReturnUserDR '=""  d
	...s TReturnUser =##class(web.DHCEQCommon).GetTrakNameByID("user",TReturnUserDR)
	..s TReceiveUserDR = $p($g(^DHCEQWashList(rowid)),"^",8)
	..i TReceiveUserDR '=""  d
	...s TReceiveUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TReceiveUserDR)
	..s THold1 = $p($g(^DHCEQWashList(rowid)),"^",9)
	..s THold2=$p($g(^DHCEQWashList(rowid)),"^",10)
	..s THold3=$p($g(^DHCEQWashList(rowid)),"^",11)
	..s THold4=$p($g(^DHCEQWashList(rowid)),"^",12)
	..s THold5=$p($g(^DHCEQWashList(rowid)),"^",13)
	..s TRow=TRow+1
	..d OutputRowGetWashListNew
	
	;没有数据时,也返回一个空行,用于编辑
	i TRow=0  d
	.d ResetVariablesGetWashListNew
	.s TRow=1
	.d OutputRowGetWashListNew
	
	;处理合计行
	i TotalFlag>0  d
	.d ResetVariablesGetWashListNew
	.s TRowID=-1
	.s TEquipName="合计:"
	.s TQuantityNum=TotalQty
	.i TotalFlag="1"  d
	..s index=1
	.e  d
	..s index=index+1
	.d OutputRowGetWashListNew
	Quit $$$OK
	
OutputRowGetWashListNew
	s Data=$lb(TMasterItemDR,TModelDR,TLocDR,TLocSendUserDR,TReturnUserDR,TReceiveUserDR,TMasterItem,TLoc,TLocSendUser,TReturnUser,TReceiveUser,TRowID,TWashDR,TQuantityNum,TModel,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetWashListNew
	s (TMasterItemDR,TModelDR,TLocDR,TLocSendUserDR,TReturnUserDR,TReceiveUserDR,TMasterItem,TLoc,TLocSendUser,TReturnUser,TReceiveUser,TRowID,TWashDR,TQuantityNum,TModel)=""
	quit
}

ClassMethod GetWashListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWashListNewExecute ]
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

ClassMethod GetWashListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWashListNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 修改:qw 2013-12-24 
/// 描述:新增、更新数据
/// ----------------------------------
/// d ##Class(web.DHCEQWash).SaveData(val, valList, DelRowid)
ClassMethod SaveData(val, valList, DelRowid)
{
	//s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	new (val, valList, DelRowid)
	Set $ZT="ERRORSave"
	s Date=+$H
	s Time=$P($H,",",2)
	s RowID=$P(val,"^",1)
	i RowID'=""
	{
		s InvalidFlag=$p($g(^DHCEQWash(RowID)),"^",23) 
		i InvalidFlag="Y" q -1015 
	}
	s PLWT(2) = $p(val,"^",2)	;WashNo
	s PLWT(3) = $p(val,"^",3)	;WashDate
 	i $p(val,"^",3)'=""  s PLWT(3) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",3),"date")	;WashDate
 	s PLWT(4) = Time       ;$p(val,"^",4)	WashTime
	s PLWT(5) = $p(val,"^",5)	;WasherDR
 	s PLWT(6) = $p(val,"^",6)	;WashEquipDR

 	s PLWT(7) = $p(val,"^",7)	;WashType
 	s PLWT(8) = $p(val,"^",8)	;WashLocDR 	
 	s PLWT(9) = "0"	;Status
 	s PLWT(10) = $p(val,"^",9)	;UpdateUserDR
 	s PLWT(11) = Date	;UpdateDate
 	s PLWT(12) = Time	;UpdateTime 	
 	//s PLWT(13) = $p(val,"^",9)	;SubmitUserDR
 	//s PLWT(14) = Date	;SubmitDate
 	//s PLWT(15) = Time	;SubmitTime
 	//s PLWT(16) = $p(val,"^",13)	;AuditUserDR
 	//s PLWT(17) = $p(val,"^",14)	;AuditDate
 	//s PLWT(18) = $p(val,"^",15)	;AuditTime
 	Set PLWT(19) = $Piece(val,"^",10)	;Hold1
 	Set PLWT(20) = $Piece(val,"^",12)	;Hold2
 	Set PLWT(21) = $Piece(val,"^",13)	;Hold3
 	Set PLWT(22) = $Piece(val,"^",14)	;Hold4
 	Set PLWT(23) = $Piece(val,"^",15)	;Hold5
 	s PLWT(24) = "N"
 	b
 	///产生固定序列号及插入操作：GetNextNo(?)
	TSTART	
 	if RowID=""
 	{
		i PLWT(2)="" s PLWT(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQWash",Date,$p(val,"^",8),$p(val,"^",6))
		b
		&SQL(insert into sqluser.DHC_EQWash values :PLWT())
		b
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s RowID=$G(%ROWID)
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQWash values :PLWT() where W_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
 	}
 	;Modified by jdl 2011-8-17 JDL0090 调整顺序，先删除明细，再保存明细
 	b
 	s SQLCODE=..DeleteWashList(DelRowid)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
 	s SQLCODE=..SaveWashList(RowID,valList)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORSave 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息 ;
}

/// Modified By qw 2013-12-25 HZY0021
/// Desc:删除入库单的同时,删除对应入库明细
/// ----------------------------------------------------------
/// 创建:qw
/// 描述:删除入库单
/// w ##Class(web.DHCEQWashNew).DeleteData("205^^1^^5^1^^")
ClassMethod DeleteData(val)
{
	//s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	;Modified By JDL 2011-10-12 JDL0098 保留变量User
	new (val,User)
	Set $ZT="ERRORDelete"
	s RowID=$P(val,"^",1)
	s Date=+$H
	s Time=$P($H,",",2)
	i RowID="" q ""
	b
	s SQLCODE=0
	TSTART
	&SQL(Update SQLUSER.DHC_EQWash Set W_InvalidFlag='Y' where W_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	b
	//删除对应入库明细 Start Add By HZY 2012-02-07 HZY0021
	s listRowID=0
	f  s listRowID=$o(^DHCEQWashList(0,"Wash",RowID,listRowID))  q:(listRowID="")||(SQLCODE'=0)  d
	.&SQL(delete from sqluser.DHC_EQWashList where WL_RowID=:listRowID)
	if (SQLCODE'=0)
	{
		TROLLBACK
	}
	else
	{
		TCOMMIT
	}
	//End Add By HZY 2012-02-07 HZY0021
 	q SQLCODE
ERRORDelete 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}

ClassMethod SubmitData(val)
{
	new (val)
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	
	s InvalidFlag=$p($g(^DHCEQWash(RowID)),"^",23) //2011-10-31 DJ DJ0098
	i InvalidFlag="Y" q -1015 //2011-10-31 DJ DJ0098
	Set $ZT="ERRORSubmit"
	;s RejectReasonDR=$P(val,"^",2)
	s User=$P(val,"^",2)
	s Date=+$H
	s Time=$P($H,",",2)
	s WashEquipDR=$p($g(^DHCEQWash(RowID)),"^",5)
	i WashEquipDR'="" d
	.s EquipTypeDR=$p($g(^DHCEQEquip(WashEquipDR)),"^",63)
	s PLIST(9)="1"		;Status
 	s PLIST(13) = User	;SubmitUserDR
 	s PLIST(14) = Date	;SubmitDate
 	s PLIST(15) = Time	;SubmitTime
 	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("22")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipTypeDR, "", "", "","")
	i ApproveSet="" q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	
	s ^QW(1)=ApproveType_"^ApproveSet:"_ApproveSet_"^ApproveFlow:"_ApproveFlow_"^AutoAuditFlag:"_AutoAuditFlag
	
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	b
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
		s PLIST(9)="2"		;Status
		s PLIST(16)=User	;AuditUserDR
		s PLIST(17)=Date	;AuditDate
		s PLIST(18)=Time	;AuditDate
		s AppInfo(9)="2"		;Status
	}
	
	s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))	
	TSTART
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"22",User)
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
	&SQL(update sqluser.DHC_EQWash values :PLIST() where W_RowID=:RowID)
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

/// 修改:qw
/// 描述:反提交
/// w ##Class(web.DHCEQWashNew).CancelSubmitData("202^^1^^5^1^112^28")
ClassMethod CancelSubmitData(val, CurRole)
{
	new (val,CurRole)
	Set $ZT="ERRORCancel"
	s RowID=$P(val,"^",1)
	q:RowID=""
	;s RejectReasonDR=$P(val,"^",2)
	s User=$P(val,"^",2)
	s Remark=$P(val,"^",3)
	s CancelToFlowDR=$P(val,"^",4)
	s ApproveSet=$P(val,"^",5)
	s Date=+$H
	s Time=$P($H,",",2)
	// Mozy0064	2011-10-24
	;Set RejectReason=$PIECE(val,"^",9)
	;获取取消到上一步的信息
	s Status="0"
	s ApproveRoleDR=""
	s Step=""
	if (CancelToFlowDR'="")
	{
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
	}	 	
	s PLIST(9)=Status		;Status
 	s PLIST(13) = User	;AuditUserDR
 	s PLIST(14) = Date	;AuditDate
 	s PLIST(15) = Time	;AuditTime
	
	TSTART
	s AppInfo(5)=ApproveRoleDR
	s AppInfo(6)=Step
	s AppInfo(7)=""		;ApproveStatus
	s AppInfo(8)=""		;ApproveRoleDR
	s AppInfo(9)=Status	;Status	

	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("22")
	//add by zy 2011-03-16 
	s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))		
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(update sqluser.DHC_EQWash values :PLIST() where W_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	/*else
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
	}*/
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORCancel
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息 ;
}

/// 描述:审核
/// s Length=$l(1^45^64^1036^20^43^4109^4109^4109^^^^^&,"&")
/// w ##Class(web.DHCEQWashNew).AuditData("41^1^^^32","1^41^64^1036^20^43^3335^3335^4109^^^^^","10","1","")
ClassMethod AuditData(val, List, CurRole, RoleStep, editFieldsInfo)
{
	;new (val, CurRole,RoleStep, editFieldsInfo)
	n EquipType,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	n User,Date,RowID,AuditFlag
	n flag,Length,valList
	k PLWTMX
	
	Set $ZT="ERRORAudit"
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	
	s User=$P(val,"^",2)
	s Date=+$H
	s Time=$P($H,",",2)
	
	s AppInfo(7)=RoleStep	;ApproveStatus
	s AppInfo(8)=CurRole	;ApproveRoleDR
	
	//s EquipType=$p($g(^DHCEQWash(RowID)),"^",6)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("22")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("22", RowID)	
	i ApproveSet="" q -4007	
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfo(5)=NextRole
	s AppInfo(6)=NextStep	
	s AppInfo(9)="1"	;Status	
	s AuditFlag=0		//判断是否是最后一步,0:否;1:是
	i ((NextStep="")||(LastFlag="Y"))
	{
		s AuditFlag=1
		s AppInfo(9)="2"
	}
	
	TSTART
	//20140307
    s Length=$l(List,"&")
    s flag=0
	for i=1:1:Length
	{
		q:flag'=0
		s valList=	$p(List,"&",i)
		s WLRowID= $p(valList,"^",2)
		s PLWTMX(8)=$p(valList,"^",8)  	;ReturnUserDR
		s PLWTMX(9)=$p(valList,"^",9)  	;ReceiveUserDR
		if (WLRowID="")
		{
			TROLLBACK
		}
		else
		{
        	&SQL(update sqluser.DHC_EQWashList values :PLWTMX() where WL_RowID=:WLRowID)
			i SQLCODE
			{	
				s flag=SQLCODE
			}
		}
	}
	i flag
	{
		TROLLBACK
		q flag
	}
	
	s AuditFlag=0
	i ((NextStep="")||(LastFlag="Y"))
	{
		i ($p($g(^DHCEQWash(RowID)),"^",8)=2)
		{
			TROLLBACK
			q -1010
		}
		s AuditFlag=1
		s PLIST(9)="2"
		s PLIST(16)=User	;AuditUserDR
		s PLIST(17)=Date	;AuditDate
		s PLIST(18)=Time	;AuditTime
		&SQL(update sqluser.DHC_EQWash values :PLIST() where W_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		
		s AppInfo(9)="2"	;Status
	}
	//w ##class(web.DHCEQApproveList).UpdateData(19,28,"","",10,1)
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
	//执行当前角色要执行的动作
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
	TCOMMIT
 	q RowID
ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg     //返回错误消息 ;
}

/// --------------------------------
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:写入入库单明细
/// 入参： WRowID：入库单ID
/// w ##Class(web.DHCEQWashNew).SaveWashList("65","1^100^10403&1^100^10403")
ClassMethod SaveWashList(WRowID, val)
{
	new Length,WLRowID,Flag,i
	n valList
	k PLWTMX
	i val="" q 0
	i WRowID="" q -1
	
	s Length=$l(val,"&")
	s PLWTMX(2)=WRowID  				;WashDR
	
	s Flag=0
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=	$p(val,"&",i)
		s WLRowID= $p(valList,"^",2)
		s PLWTMX(3)=$p(valList,"^",3)  	;MasterItemDR
		s PLWTMX(4)=$p(valList,"^",4)					;ModelDR
		s PLWTMX(5)=$p(valList,"^",5)		;QuantityNum
		s PLWTMX(6)=$p(valList,"^",6)  	;LocDR
		s PLWTMX(7)=$p(valList,"^",7)  	;LocSendUserDR
		s PLWTMX(8)=$p(valList,"^",8)  	;ReturnUserDR
		s PLWTMX(9)=$p(valList,"^",9)  	;ReceiveUserDR
		
 		s PLWTMX(10)=$p(valList,"^",10)		;Hold1
 		s PLWTMX(11)=$p(valList,"^",11)		;Hold2
 		s PLWTMX(12)=$p(valList,"^",12)		;Hold3
 		s PLWTMX(13)=$p(valList,"^",13)		;Hold4
 		s PLWTMX(14)=$p(valList,"^",14)		;Hold5
 		;b
		if (WLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQWashList Values :PLWTMX())
			s WLRowID=$G(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQWashList values :PLWTMX() where WL_RowID=:WLRowID)
		}
		i SQLCODE
 		{
			s Flag=SQLCODE
 		}
 		q:Flag'=0
		
 		i SQLCODE
		{
			s Flag=SQLCODE
		}
		
	}
	q Flag
}

/// Modified By QW 2013-12-25 QW05102213
/// Desc:修改函数,删除入库单明细.
/// ----------------------------------
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:删除入库单明细
/// w ##Class(web.DHCEQWashNew).DeleteWashList("65"," ,0,0,0")
ClassMethod DeleteWashList(DelRowIDs)
{
	new Length,WLRowID,Flag,i
	
	i DelRowIDs="" q 0
	
	s Flag=0
	s Length=$l(DelRowIDs,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s WLRowID=$p(DelRowIDs,",",i)
		if (WLRowID>0)
		{
			&SQL(delete from  sqluser.DHC_EQWashList where WL_RowID=:WLRowID)
			i SQLCODE s Flag=SQLCODE
			q:Flag'=0
		}
	}
	q Flag
}

/// w ##Class(web.DHCEQWashNew).GetOneWash("187")
ClassMethod GetOneWash(rowid)
{
	new result,resultex,LocCode,AppInfo,Total
	s (result,resultex,LocCode,AppInfo,Total)=""
	s result= ^DHCEQWash(rowid)
	s $p(result,"^",2)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",2),"date")	;WashDate
	;s $p(result,"^",3)=$ZT($p(result,"^",3),1)
	;日期格式统一调整    Modify by CSY 2017-03-02
	s $p(result,"^",3)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",3),"time")
	s resultex=resultex_"^"	;WasherDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",4))
	s resultex=resultex_"^"	;WashEquipDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("equip",$p(result,"^",5))
	s resultex=resultex_"^"	;WashLocDR
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",7))
	.s LocCode=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",$p(result,"^",7))
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",9))
	s $p(result,"^",10)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date")	;UpdateDate
	;s $p(result,"^",11)=$ZT($p(result,"^",11),1)
	;日期格式统一调整    Modify by CSY 2017-03-02
	s $p(result,"^",11)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"time")
	s resultex=resultex_"^"	;SubmitUserDR
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",12))
	s $p(result,"^",13)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"date")	;SubmitDate
	;s $p(result,"^",14)=$ZT($p(result,"^",14),1)
	;日期格式统一调整    Modify by CSY 2017-03-02
	s $p(result,"^",14)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",14),"time")
	s resultex=resultex_"^%%%"	;AuditUserDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",15))
	s $p(result,"^",16)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",16),"date")	;AuditDate
	;s $p(result,"^",17)=$ZT($p(result,"^",17),1)
	;日期格式统一调整    Modify by CSY 2017-03-02
	s $p(result,"^",17)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",17),"time")
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("22",rowid)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex_"^"_AppInfo
}

/// ----------------------------------
/// 修改:qw
/// 描述:通过审核的入库单自动生成转移单
/// ----------------------------------
ClassMethod TransInToMove(WashId, UserID)
{
	new CurDate,StoreMoveNo,RowID,Qty,WashListID,EquipID,LocID
	if WashId="" q ""
	s CurDate=+$H
	s StoreMoveNo=""
	s WashEquipDR=$P($G(^DHCEQWash(WashId)),"^",5)
	s EquipTypeDR=$P($G(^DHCEQEquip(WashEquipDR)),"^",63)
	if EquipTypeDR="" q ""
	s StatCatDR=$P($G(^DHCEQEquip(WashEquipDR)),"^",75)
	if StatCatDR="" q ""

	TStart
	if StoreMoveNo="" s StoreMoveNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQStoreMove",+$H,"",EquipTypeDR)
	&SQL(insert into sqluser.DHC_EQStoreMove
		(SM_StoreMoveNo,SM_FromLocDR,SM_ToLocDR,SM_MakerDR,SM_MakeDate,SM_MoveType,SM_Status,SM_EquipTypeDR,SM_StatCatDR,SM_InvalidFlag) 
	select :StoreMoveNo,W_WashLocDR,0,:UserID,:CurDate,0,0,:EquipTypeDR,:StatCatDR,'N' from sqluser.DHC_EQWash where W_RowID=:WashId)
	if SQLCODE'=0 
	{	
		TRollBack 
		quit SQLCODE
	}
	s RowID=$G(%ROWID)
	s WashListID=0
	f  s WashListID=$o(^DHCEQWashList(0,"Wash",WashId,WashListID)) q:((WashListID="")||(SQLCODE'=0))  d
	.s WashDR=$p($g(^DHCEQWashList(WashListID)),"^",1)
	.i WashDR'="" d
	..s WashEquipDR=$p($g(^DHCEQWash(WashDR)),"^",5)
	..s WashEquipName=$p($g(^DHCEQEquip(WashEquipDR)),"^",1)
	.&SQL(insert into sqluser.DHC_EQStoreMoveList(SML_StoreMoveDR,SML_EquipDR,SML_EquipName,SML_QuantityNum,SML_ModelDR) select :RowID,:WashDR,:WashEquipName,WL_QuantityNum,WL_ModelDR from sqluser.DHC_EQWashlist where WL_RowID=:WashListID)
	if SQLCODE'=0 
	{	TRollBack 
		quit SQLCODE}
	
	TCommit
	quit RowID
}

/// ----------------------------------
/// 描述：最终审核时需调用此方法,执行审核中需要处理的数据
/// 	在此处，需调用
/// w ##Class(web.DHCEQInStorckNew).LastAuditAction(52,1,61963)
/// ----------------------------------
ClassMethod LastAuditAction(RowID, User, Date)
{
	s SQLCODE=##class(web.DHCEQInStockNew).ChangeStock(RowID,User,Date)
	i SQLCODE q SQLCODE
	
	s SQLCODE=##class(web.DHCEQInStockNew).CreateFundsInfoByEquip(RowID, Date)		//Mozy75	2011-12-27
	q SQLCODE
}

ClassMethod GetWashStatus(Status)
{
	q $CASE(Status,"0":"新增","1":"提交","2":"审核","3":"作废",:"没有定义")
}

// Mozy0030	2010-11-11

ClassMethod StatusList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	i (Type="")||(Type="0")||(Type="4") w "<option value=0>"_..GetWashStatus(0)_"</option>"
	i Type'="2" w "<option value=1>"_..GetWashStatus(1)_"</option>"
	w "<option value=2>"_..GetWashStatus(2)_"</option>"
	w "<option value=3>"_..GetWashStatus(3)_"</option>"
	w "</select>",!
}

ClassMethod GetWashTypeDesc(WashType As %Library.String) As %Status
{
	i WashType="" q ""
	i +WashType=1 q "工作服洗涤"
	i +WashType=2 q "普通被服"
	i +WashType=3 q "传染性被服"
	i +WashType=4 q "被血液痰液等污染被服"
	q "未定义"
}

ClassMethod CreateCbo(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=1>工作服洗涤</option>"
	w "<option value=2>普通被服</option>"
	w "<option value=3>传染性被服</option>"
	w "<option value=4>被血液痰液等污染被服</option>"
	w "</select>",!
}

//20140305

//qw003

//根据科室获得设备项

/// /d ##class(%Library.ResultSet).RunQuery("web.DHCEQWashNew","GetMasterItemByLoc","","","","")
Query GetMasterItemByLoc(EquipTypeDR, LocDR, StatCatDR, Name) As %Query(ROWSPEC = "Name:%String,Hidden:%String,Code:%String,Hidden:%String,Cat:%String,Hidden:%String,Unit:%String,Hidden:%String,EquipType:%String,Hidden:%String,StatCat:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String")
{
}

ClassMethod GetMasterItemByLocExecute(ByRef qHandle As %Binary, EquipTypeDR, LocDR, StatCatDR, Name) As %Status
{
 	new repid, index,rowid,EquipTypeValues
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s EquipTypeValues=##class(web.DHCEQCommon).GetSysInfo("990024")
	s EquipTypeValues=","_EquipTypeValues_","
	i LocDR'=""
    {
		s rowid=0
		f  s rowid=$o(^DHCEQEquip(0,"LocItem",LocDR,rowid))  quit:rowid=""  d
		.s TEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",3)
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
		.q:(EquipTypeValues'="")&&(EquipTypeValues'[(","_TEquipTypeDR_","))
	    .;add by jdl 2010-3-17  JDL0048
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
		.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
		.d ResetVariablesGetItemByLoc
		.d BuildDataGetItemByLoc
     }
	else
	{
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR))  quit:TEquipTypeDR=""  d
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
		.q:(EquipTypeValues'="")&&(EquipTypeValues'[(","_TEquipTypeDR_","))
		.;add by jdl 2010-3-17  JDL0048
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
		.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR,rowid))  quit:rowid=""  d
		..d ResetVariablesGetItemByLoc
		..d BuildDataGetItemByLoc
	}
	
	Quit $$$OK
	
BuildDataGetItemByLoc
	s TRowID = rowid
	s TFlag = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",8)
	q:TFlag="Y"
	s TName = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1)
	s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2)
	q:(Name'="")&&(($ZCONVERT(TName ,"U")'[$ZCONVERT(Name,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Name,"U")))
	
	s TStatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",5)
	q:(StatCatDR'="")&&(TStatCatDR'="")&&(TStatCatDR'=StatCatDR)
	i TStatCatDR'="" s TStatCat=$P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
	s TCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",4)
	i TCatDR'="" d
	.s TCat=$P(^DHCEQCCode("DHCEQCEquipeCat",TCatDR),"^",2)
	.s TLimitYearsNum=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TCatDR,TStatCatDR)	;Modified by jdl 2012-3-7 JDL0120
	.s TDepreMethodDR=##Class(web.DHCEQCEquipeCat).GetDepreMethodByCatID(TCatDR)
	.i TDepreMethodDR'="" d
	..s TDepreMethod=$p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7)
	i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	
	s THold2=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",11)
	i THold2'="" s THold2Desc=$P($g(^CT("HOSP",THold2)),"^",2)
	
	d OutputRowGetItemByLoc
	quit
OutputRowGetItemByLoc
	s Data=$lb(TName,TRowID,TCode,TCatDR,TCat,TUnitDR,TUnit,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TDepreMethodDR,TDepreMethod,TLimitYearsNum,THold2,THold2Desc) //,ModelDR,ManageLocDR,UseLocDR,GroupDR,ManageUserDR,Model,ManageLoc,UseLoc,ManageUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetItemByLoc
	s (TName,TRowID,TCode,TCatDR,TCat,TUnitDR,TUnit,TStatCatDR,TStatCat,TDepreMethodDR,TDepreMethod,TLimitYearsNum,THold2,THold2Desc)=""
	quit
}

ClassMethod GetMasterItemByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMasterItemByLocExecute ]
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

ClassMethod GetMasterItemByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMasterItemByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
