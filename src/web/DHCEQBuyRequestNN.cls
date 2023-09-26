Class web.DHCEQBuyRequestNN Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/************************************************************************************************/

/************************************************************************************************/
/// Add By DJ 2013-07-12
/// 描述:采购申请
/// -------------------------------------------------------------------
/// modified by HZY0066 2014-09-30 
/// 修复'设备采购申请查找'里，点击项目名称后没有判断单种与批量的问题
/// 修改位置SaveData()
/// 修改：新增BR_Hold1 批量标志
/// -------------------------------------------------------------------------
/// modified by GR 2014-09-15 begin 缺陷号3127 设备采购申请-设备采购申请-列表中的预计费用显示空
/// 更改内容：SaveData()中增加两个字段
Query GetBuyRequestList(RowID) As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TAdviseModel:%String,TAllOption:%String,TAmount:%String,TApproveNum:%String,TApproveOption:%String,TCommonName:%String,TFundsOrigin:%String,TFundsOriginDR:%String,TItem:%String,TItemDR:%String,TModel:%String,TModelDR:%String,TPriceFee:%String,TPurchaseType:%String,TPurchaseTypeDR:%String,TPurposeType:%String,TPurposeTypeDR:%String,TRemark:%String,TRequestNum:%String,TUnit:%String,TUnitDR:%String,TOptionType:%String")
{
}

ClassMethod GetBuyRequestListExecute(ByRef qHandle As %Binary, RowID) As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	new rowid,TRow,TotalFlag,TotalQty,Total,BuyRequestDR,ApproveQty
	s (TotalQty,Total,ApproveQty)=0
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i TotalFlag="1"  s index=2
	s TRow=0
	if RowID'=""  d
	.s BRLRowID=0 
	.f  s BRLRowID=$o(^DHCEQBuyRequestList(0,"BuyRequest",RowID,BRLRowID))  quit:BRLRowID=""  d
	..d ResetVariablesGetBuyRequestList
	..s TRowID = BRLRowID
	..s TAdviseModel=$p($g(^DHCEQBuyRequestList(TRowID)),"^",16)
	..s AINum=0
	..f  s AINum=$o(^DHCEQBuyRequestList(TRowID,"ApproveInfo",AINum))  q:AINum=""  d
	...s AIUser=$p($g(^DHCEQBuyRequestList(TRowID,"ApproveInfo",AINum)),"^",4)
	...i AIUser'="" s AIUser=##class(web.DHCEQCommon).GetTrakNameByID("user",AIUser)
	...s AIDate=$p($g(^DHCEQBuyRequestList(TRowID,"ApproveInfo",AINum)),"^",2)
	...i AIDate'="" s AIDate=##Class(web.DHCEQCommon).TransValueToPage(AIDate,"date")
	...s AITime=$p($g(^DHCEQBuyRequestList(TRowID,"ApproveInfo",AINum)),"^",3)
	...s AIApproveInfo=$p($g(^DHCEQBuyRequestList(TRowID,"ApproveInfo",AINum)),"^",1)
	...s TAllOption=TAllOption_AIApproveInfo_" "_AIDate_" "_AIUser_"\n"
	..s TAmount=$p($g(^DHCEQBuyRequestList(TRowID)),"^",8)
	..s TApproveNum=$p($g(^DHCEQBuyRequestList(TRowID)),"^",7)
	..s TApproveOption=$p($g(^DHCEQBuyRequestList(TRowID,"RejectReason")),"^",1)
	..s BRStatus=$p($g(^DHCEQBuyRequest(RowID)),"^",16)
	..i BRStatus=0  d
	...s TOptionType="同意"
	...i TApproveOption'="" s TOptionType="不同意"
	..e  d
	...s TOptionType=1
	...i TApproveOption'="" s TOptionType=2
	..s TCommonName=$p($g(^DHCEQBuyRequestList(TRowID)),"^",2)
	..s TFundsOriginDR=$p($g(^DHCEQBuyRequestList(TRowID)),"^",21)
	..i TFundsOriginDR'="" s TFundsOrigin=$p($g(^DHCEQCCode("DHCEQCFundsType",TFundsOriginDR)),"^",2)
	..s TItemDR=$p($g(^DHCEQBuyRequestList(TRowID)),"^",17)
	..i TItemDR'="" s TItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	..s TModelDR=$p($g(^DHCEQBuyRequestList(TRowID)),"^",3)
	..i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..s TPriceFee=$p($g(^DHCEQBuyRequestList(TRowID)),"^",6)
	..s TPurchaseTypeDR=$p($g(^DHCEQBuyRequestList(TRowID)),"^",22)
	..i TPurchaseTypeDR'="" s TPurchaseType=$p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	..s TPurposeTypeDR=$p($g(^DHCEQBuyRequestList(TRowID)),"^",23)
	..i TPurposeTypeDR'="" s TPurposeType=$p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	..s TRemark=$p($g(^DHCEQBuyRequestList(TRowID)),"^",9)
	..s TRequestNum=$p($g(^DHCEQBuyRequestList(TRowID)),"^",20)
	..s TUnitDR=$p($g(^DHCEQBuyRequestList(TRowID)),"^",24)
	..i TUnitDR'="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",(TUnitDR))	;Modified By jdl 20150906 v4.1.0 规范单位取值
	..s TRow=TRow+1
	..s TotalQty=TotalQty+TRequestNum
	..s ApproveQty=ApproveQty+TApproveNum
	..s Total=Total+TAmount
	..d OutputRowGetBuyRequestList
	
	;没有数据时,也返回一个空行,用于编辑
	i TRow=0  d
	.d ResetVariablesGetBuyRequestList
	.s TRow=1
	.d OutputRowGetBuyRequestList
	
	;处理合计行
	i TotalFlag>0  d
	.d ResetVariablesGetBuyRequestList
	.s TRowID=-1
	.s TRequestNum=TotalQty
	.s TApproveNum=ApproveQty
	.s TAmount=##Class(web.DHCEQCommon).FormatNumber(Total,"",2)
	.i TotalFlag="1"  d
	..s index=1
	.e  d
	..s index=index+1
	.d OutputRowGetBuyRequestList
	Quit $$$OK
	
OutputRowGetBuyRequestList
	s Data=$lb(TRow,TRowID,TAdviseModel,TAllOption,TAmount,TApproveNum,TApproveOption,TCommonName,TFundsOrigin,TFundsOriginDR,TItem,TItemDR,TModel,TModelDR,TPriceFee,TPurchaseType,TPurchaseTypeDR,TPurposeType,TPurposeTypeDR,TRemark,TRequestNum,TUnit,TUnitDR,TOptionType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBuyRequestList
	s (TRowID,TAdviseModel,TAllOption,TAmount,TApproveNum,TApproveOption,TCommonName,TFundsOrigin,TFundsOriginDR,TItem,TItemDR,TModel,TModelDR,TPriceFee,TPurchaseType,TPurchaseTypeDR,TPurposeType,TPurposeTypeDR,TRemark,TRequestNum,TUnit,TUnitDR,TOptionType)=""
	quit
}

ClassMethod GetBuyRequestListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyRequestListExecute ]
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

ClassMethod GetBuyRequestListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyRequestListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/************************************************************************************************/
ClassMethod SaveData(val, valList, DelRowid)
{
	new (val, valList, DelRowid)
	Set $ZT="ERRORSave"
	s Date=+$H
	s Time=$p($H,",",2)
	s RowID=$P(val,"^",1)
	i RowID'=""
	{
		s InvalidFlag=$p($g(^DHCEQBuyRequest(RowID)),"^",45)
		i InvalidFlag="Y" q -1015
	}
	s PLIST(36)=$p(val,"^",2)	//RequestNo
	s PLIST(7)=$p(val,"^",3)	//RequestDate
	s PLIST(3)=$p(val,"^",4)	//RequestLocDR
	s PLIST(5)=$p(val,"^",5)	//UseLocDR
	s PLIST(4)=$p(val,"^",6)	//YearFlag
	s PLIST(6)=$p(val,"^",7)	//Year
	Set PLIST(9)=$Piece(val,"^",11)		//	BR_QuantityNum modified by GR 2014-09-15 begin 缺陷号3127 设备采购申请-设备采购申请-列表中的预计费用显示空
	Set PLIST(10)=$Piece(val,"^",12)	//	BR_TotalFee    modified by GR 2014-09-15 end
	s PLIST(28)=$p(val,"^",8)	//Remark
	s User=$p(val,"^",9)	//User
	s PLIST(29)=User
	s PLIST(30)=Date
	s PLIST(31)=Time
	Set PLIST(26)=$Piece(val,"^",10)	//EquipTypeDR	2013-11-11  Mozy0112
	s PLIST(2)=$p(valList,"^",4)_"申请"		//PrjName默认为第一条明细记录名称
	s PLIST(17)=0		//Status
	s PLIST(18)="Y"	//BR_Hold1 批量标志 2014-9-30 HZY0066 
	s PLIST(46)="N"
	
 	i $p(val,"^",3)'=""  s PLIST(7) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",3),"date")	;RequestDate
	i $p(val,"^",6)'=""  s PLIST(4) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"bool")	;RequestDate
	TSTART	
 	if RowID=""
 	{
		i PLIST(36)="" s PLIST(36)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQBuyRequest",Date,$p(val,"^",4),"")
		
		&SQL(insert into sqluser.DHC_EQBuyRequest values :PLIST())
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s RowID=$G(%ROWID)
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQBuyRequest values :PLIST() where BR_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
 	}
 	s SQLCODE=..DeleteBuyRequestList(DelRowid)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
 	s SQLCODE=..SaveBuyRequestList(RowID,valList)
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

/********************************************************************************/
ClassMethod DeleteBuyRequestList(DelRowIDs)
{
	new Length,BRLRowID,Flag,i
	
	i DelRowIDs="" q 0
	
	s Flag=0
	s Length=$l(DelRowIDs,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s BRLRowID=$p(DelRowIDs,",",i)
		if (BRLRowID>0)
		{
			&SQL(delete from  sqluser.DHC_EQBuyRequestList where BRL_RowID=:BRLRowID)
			i SQLCODE s Flag=SQLCODE
		}
	}
	q Flag
}

/**********************************************************************************/
ClassMethod SaveBuyRequestList(BRRowID, val)
{
	new Length,BRLRowID,Flag,i,valList
	
	k PLISTMX
	i val="" q 0
	i BRRowID="" q -1
	
	s Length=$l(val,"&")
	s PLISTMX(2)=BRRowID  				;BuyRequestDR
	s Flag=0
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=	$p(val,"&",i)
		s BRLRowID= $p(valList,"^",2)
		s PLISTMX(18)=$P(valList,"^",3)		//ItemDR
		s PLISTMX(3)=$P(valList,"^",4)		//TCommonName
		s PLISTMX(17)=$P(valList,"^",5)		//TAdviseModel
		s PLISTMX(4)=$P(valList,"^",6)		//TModelDR
		s PLISTMX(21)=$P(valList,"^",7)		//TRequestNum
		s PLISTMX(7)=$P(valList,"^",8)		//TPriceFee
		s PLISTMX(25)=$P(valList,"^",9)		//TUnitDR
		s PLISTMX(23)=$P(valList,"^",10)	//TPurchaseTypeDR
		s PLISTMX(24)=$P(valList,"^",11)	//TPurposeTypeDR
		s PLISTMX(22)=$P(valList,"^",12)	//TFundsOriginDR
		s PLISTMX(10)=$P(valList,"^",13)	//TRemark
		s PLISTMX(9)=##Class(web.DHCEQCommon).FormatNumber($P(valList,"^",7)*$P(valList,"^",8),"",2)	//TTotalFee
		i $P(valList,"^",3)'=""  d
		.s TCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(valList,"^",3))),"^",4)
		.s TStatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(valList,"^",3))),"^",5)
		.s PLISTMX(26)=TStatCatDR
		.s PLISTMX(27)=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TCatDR,TStatCatDR)
		if (BRLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQBuyRequestList Values :PLISTMX())
			s BRLRowID=$G(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQBuyRequestList values :PLISTMX() where BRL_RowID=:BRLRowID)
		}
		i SQLCODE
 		{
			s Flag=SQLCODE
 		}
	}
	q Flag
}

/*************************************************************************/
ClassMethod SubmitData(val)
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	s Status=$Piece($G(^DHCEQBuyRequest(RowID)),"^",16)
	if Status'="0" q -2015   //该记录状态不符合,不能执行操作!
	
	s InvalidFlag=$Piece($G(^DHCEQBuyRequest(RowID)),"^",45)
	if InvalidFlag="Y" q -1015
	
	Set $ZT="ERRORSubmitData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	
 	Set EquipType=$Piece(^DHCEQBuyRequest(RowID),"^",25)
	Set PurchaseType=$Piece(^DHCEQBuyRequest(RowID),"^",26)
	Set YearFlag=$Piece(^DHCEQBuyRequest(RowID),"^",3)
	
	s ReturnEquipType=##Class(web.DHCEQInStockNew).EquipTypeIsUniqueNew(RowID,EquipType,"BuyRequest")	
	i ReturnEquipType<0 q ReturnEquipType
	
	Set MaxPrice=0
 	Set ListRowID=0
 	For  Set ListRowID=$Order(^DHCEQBuyRequestList(0,"BuyRequest",RowID,ListRowID))  Quit:ListRowID=""  Do
 	.If +$p(^DHCEQBuyRequestList(ListRowID),"^",6)>MaxPrice  Do
 	..Set MaxPrice=+$p(^DHCEQBuyRequestList(ListRowID),"^",6)	;BRL_PriceFee
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, "", MaxPrice, YearFlag, "")
	If ApproveSet="" Quit -4007
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	
	Set AppInfo(2)=ApproveType
	Set AppInfo(3)=RowID
	Set AppInfo(4)=ApproveSet
	Set AppInfo(5)=NextRole
	Set AppInfo(6)=NextStep
	Set AppInfo(7)=""			;ApproveStatus  当前审核步骤
	Set AppInfo(8)=""			;ApproveRoleDR
	Set AppInfo(9)="1"			;Status
	
	Set AuditFlag=0
	If (AutoAuditFlag="Y")&&(NextStep="") Set AuditFlag=1
	Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))
	
	TSTART
	//清空明细拒绝原因
 	Set ListRowID=0
 	For  Set ListRowID=$Order(^DHCEQBuyRequestList(0,"BuyRequest",RowID,ListRowID))  Quit:ListRowID=""  Do
 	.K ^DHCEQBuyRequestList(ListRowID,"RejectReason")
 	
	Set SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"1",User)
	If SQLCODE
	{
		TROLLBACK
	 	Quit SQLCODE
	}
	If ApproveInfoID=""
	{
		&SQL(insert into sqluser.DHC_EQApproveInfo values :AppInfo())
	}
	Else
	{
		&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)
 	}
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	Set PLIST(17)=	1		// BR_Status
 	Set PLIST(11)=	User	// BR_SubmitUserDR
	Set PLIST(12)=	updDate	// BR_SubmitDate
	Set PLIST(13)=	updTime	// BR_SubmitTime
	If AuditFlag=1 Set PLIST(17)=	2		// BR_Status
	&SQL(Update SQLUSER.DHC_EQBuyRequest Values :PLIST() where BR_RowID=:RowID)
	if SQLCODE
	{
	 	TROLLBACK
		Quit SQLCODE
	}
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set SQLCODE=##Class(web.DHCEQBuyRequestNew).LastAuditAction(RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}		
	}
	;Modified by jdl 2011-3-17  jdl0073
 	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("91", RowID, User, ApproveFlow, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	Quit RowID
	
ERRORSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORSubmitData"_ErrorMsg     //返回错误消息
}

/********************************************************************************/
ClassMethod AuditData(val As %Library.String = "", CurRole As %Library.String = "", RoleStep As %Library.String = "", editFieldsInfo As %Library.String = "", valList As %Library.String = "")
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	s Status=$Piece($G(^DHCEQBuyRequest(RowID)),"^",16)
	if Status'="1" q -2015   //该记录状态不符合,不能执行操作!
	
	Set $ZT="ERRORAuditData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	Set Opinion=$Piece(val,"^",4)
	Set Remark=$Piece(val,"^",5)
	
	Set AppInfo(7)=RoleStep	;ApproveStatus
	Set AppInfo(8)=CurRole	;ApproveRoleDR
	
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("1", RowID)	
	If ApproveSet="" Quit -4007	
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	Set AppInfo(5)=NextRole
	Set AppInfo(6)=NextStep	
	Set AppInfo(9)="1"	;Status	
	
	TSTART
	Set AuditFlag=0
	If ((NextStep="")||(LastFlag="Y"))
	{
		Set AuditFlag=1
		
		Set PLIST(14)=	User	// BR_AuditUserDR
		Set PLIST(15)=	updDate	// BR_AuditDate
		Set PLIST(16)=	updTime	// BR_AuditTime
		Set PLIST(17)=	2		// BR_Status
		&sql(Update SQLUSER.DHC_EQBuyRequest Values :PLIST() where BR_RowID=:RowID)
		If SQLCODE
		{
		 	TROLLBACK
			Quit SQLCODE
		}
		Set AppInfo(9)="2"	;Status
	}
	;总单审批信息
	s Opinion="同意"
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,Opinion,Remark,CurRole,RoleStep)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	;生成明细审批记录
	s Length=$L(valList,"&")
	f i=1:1:Length  d
	.s ListInfo=$p(valList,"&",i)
	.s ListRowID=$p(ListInfo,"^",1)
	.s Opinion=$p(ListInfo,"^",2)
	.s CurNum=+$o(^DHCEQBuyRequestList(ListRowID,"ApproveInfo",""),-1)+1
	.s ^DHCEQBuyRequestList(ListRowID,"ApproveInfo",CurNum)=Opinion_"^"_updDate_"^"_updTime_"^"_User_"^"_RoleStep_"^"_ApproveType_"^"_CurRole
	
	;记录单据当前审批状态
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_SourceID=:RowID and  AI_ApproveSetDR=:ApproveSet)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	;编辑要修改的字段
	If editFieldsInfo'=""
	{
		Set SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	;执行当前角色要执行的动作
	Set Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	If Actions'=""
	{
		Set SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set SQLCODE=##Class(web.DHCEQBuyRequestNew).LastAuditAction(RowID)
		If SQLCODE<0	//Modified By HZY 2012-04-25
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	
	;Modified by jdl 2011-3-17  jdl0073
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("91", RowID, User, ApproveFlow, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	TCOMMIT
	
	Quit RowID
ERRORAuditData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORAuditData"_ErrorMsg		//返回错误消息
}

/*************************************************************************************/
ClassMethod CancelSubmitData(val As %Library.String = "", CurRole, valList As %Library.String = "")
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	
	Set $ZT="ERRORCancelSubmitData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
	Set CancelToFlowDR=$Piece(val,"^",3)
	Set RejectReason=$Piece(val,"^",6)
	
	;获取取消到上一步的信息
	Set Status="0"
	Set ApproveRoleDR=""
	Set Step=""
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	if (CancelToFlowDR'="")
	{
		Set ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		Set Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		Set Status="1"
	}
	Set AppInfo(5)=ApproveRoleDR
	Set AppInfo(6)=Step
	Set AppInfo(7)=""		;ApproveStatus
	Set AppInfo(8)=""		;ApproveRoleDR
	Set AppInfo(9)=Status	;Status	
	TSTART
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_SourceID=:RowID and AI_ApproveTypeDR=:ApproveType)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	Set PLIST(17)=	Status	// BR_Status
	// BR_RejectReason
	Set PLIST(38)=	RejectReason	;_"  "_##class(web.DHCEQCommon).GetTrakNameByID("user",User)_"  "_$ZD(updDate,3)	;取消人及取消日期
	Set PLIST(39)=	User	// BR_RejectUserDR
	Set PLIST(40)=	updDate	// BR_RejectDate
	Set PLIST(41)=	updTime	// BR_RejectTime
	&sql(Update SQLUSER.DHC_EQBuyRequest Values :PLIST() where BR_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	//取消拒绝原因登记
	i valList'=""
	{
		s Length=$L(valList,"&")
		f i=1:1:Length  d
		.s ListInfo=$p(valList,"&",i)
		.s ListRowID=$p(ListInfo,"^",1)
		.s Opinion=$p(ListInfo,"^",2)
		.s ^DHCEQBuyRequestList(ListRowID,"RejectReason")=Opinion_"^"_updDate_"^"_updTime_"^"_User_"^"_CancelToFlowDR
	}
	;Modified by jdl 2011-3-17  jdl0073
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("91", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	Quit RowID
ERRORCancelSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     				//得到系统返回的错误消息
 	Quit "ERRORCancelSubmitData"_ErrorMsg   //返回错误消息
}

/************************************************************/
/// Add By DJ 2013-07-22
/// 描述:检查明细记录是否需要论证,可行性分析,会议记录,效益分析
/// 返回值:0:表示不需要  1:表示需要 
ClassMethod CheckAnalyandArgu(RowID As %String = "", UserDefinedCode As %String = "")
{
	s Flag=0
	i ((RowID="")||(UserDefinedCode="")) q 0
	s OriginalFee=$p($g(^DHCEQBuyRequestList(RowID)),"^",6)
	s UDRowID=$o(^DHCEQCCode("DHCEQCUserDefined",0,"Code",UserDefinedCode,0))
	s Flag='$D(^DHCEQUserDefinedInfo(0,"SourceType","BuyRequest",RowID,UDRowID))
	i ((OriginalFee<500000)&&(UserDefinedCode'="DHCEQ0001")) q 0	//广西医科大学第一附属医院500000以下论证
	i ((OriginalFee>=500000)&&(UserDefinedCode="DHCEQ0001")) q 0	//广西医科大学第一附属医院500000以上论证
	q Flag
}

/************************************************************/
ClassMethod GetListOriginalFee(vBRLRowID As %String = "")
{
	i vBRLRowID="" q 0
	s OriginalFee=$p($g(^DHCEQBuyRequestList(vBRLRowID)),"^",6)
	i OriginalFee<500000 q 0
	q 1
}

}
