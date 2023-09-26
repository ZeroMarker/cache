/// add by zy 2017-04-27 ZY0163
Class web.DHCEQAccountList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQAccountList).SaveData("^1^1^1^1000^5^验收入账^^^^^","")
/// modify by QW0008 增加user参数以及修改返回值格式:"SQLCODE^ID"
ClassMethod SaveData(val, DelIs, User As %String = "")
{
	new RowID,Date,Time,SQLCODE
	k PLIST
	s SQLCODE=0
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	Set RowID=$Piece(val,"^",1)
	if DelIs=1
	{
		i RowID="" q ""
	 	Set PLIST(11) = "Y"	;AL_InvalidFlag
	 	Set PLIST(12) = User	;AL_InvalidUserDR
	 	Set PLIST(13) = Date	;AL_InvalidDate 
	 	Set PLIST(14) = Time	;AL_InvalidTime
	}
	else
	{
		Set PLIST(2) = $Piece(val,"^",2)	;AL_InStockListDR
		Set PLIST(3) = User	;AL_User
		Set PLIST(4) = Date	;AL_Date
		Set PLIST(5) = Time	;AL_Time
		Set PLIST(6) = $Piece(val,"^",3)	;AL_EquipTypeDR
		Set PLIST(7) = $Piece(val,"^",4)	;AL_StatCatDR
	 	Set PLIST(8) = $Piece(val,"^",5)	;AL_EquipCatDR
	 	Set PLIST(9) = $Piece(val,"^",6)	;AL_LimitYearsNum
	 	Set PLIST(10) = $Piece(val,"^",7)	;;AL_Remark
		Set PLIST(11) = "N"	;AL_InvalidFlag
	 	Set PLIST(15) = $Piece(val,"^",8)	;Hold1
	 	Set PLIST(16) = $Piece(val,"^",9)	;Hold2
	 	Set PLIST(17) = $Piece(val,"^",10)	;Hold3
	 	Set PLIST(18) = $Piece(val,"^",11)	;Hold4
	 	Set PLIST(19) = $Piece(val,"^",12)	;Hold5
	}
	
 	if RowID=""
 	{
		&SQL(insert into sqluser.DHC_EQAccountList values :PLIST())
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQAccountList values :PLIST() where AL_RowID=:RowID)
		i SQLCODE=100 s SQLCODE=0
 	}
 	s RowID=$G(%ROWID)
 	Quit SQLCODE_"^"_RowID
}

/// add by zy 2017-05-05 Modifid by zy 2017-08-24
/// 判断入库、转移是否已经入账。
/// 原则上入账之后不能做退货，只能做减少。退货的设备不应该属于已经入账的设备，减少的设备应该都是已经入账的设备。
/// 因此退货加未入账的判断，减少需要加已入账的判断。
/// w ##Class(web.DHCEQAccountList).AccountFlag("1")
ClassMethod AccountFlag(rowid, SourceType As %Library.String = "3", StartDate As %Library.String = "", EndDate As %Library.String = "")
{
	new Flag,SourceID,InStockList,AccountListID,EquipID
	s Flag=0
	i rowid="" q Flag
	s SourceID=0 
	if SourceType="3"
	{
		f  s SourceID=$o(^DHCEQInStockList(0,"InStock",rowid,SourceID))  quit:(SourceID="")||(Flag=1)  d
		.s InStockList=SourceID
		.d IsInAccountList
	}
	elseif SourceType="4"
	{
		f  s SourceID=$o(^DHCEQStoreMoveList(0,"StoreMove",rowid,SourceID))  quit:(SourceID="")||(Flag=1)  d
		.s InStockList=$p($g(^DHCEQStoreMoveList(SourceID)),"^",4)
		.i InStockList=""  d
		..s EquipID=$p($g(^DHCEQStoreMoveList(SourceID)),"^",2)
		..s InStockList=$p($g(^DHCEQEquip(EquipID)),"^",70)
		.d IsInAccountList
	}	
	elseif SourceType="5"
	{
		f  s SourceID=$o(^DHCEQReturnList(0,"Return",rowid,SourceID))  quit:(SourceID="")||(Flag=1)  d
		.s InStockList=$p($g(^DHCEQReturnList(SourceID)),"^",3)
		.i InStockList=""  d
		..s EquipID=$p($g(^DHCEQReturnList(SourceID)),"^",4)
		..s InStockList=$p($g(^DHCEQEquip(EquipID)),"^",70)
		.d IsInAccountList
	}	
	q Flag
	
IsInAccountList
	
	q:'$Data(^DHCEQAccountList(0,"InStockList",InStockList))
	s AccountListID=0
	f  s AccountListID=$o(^DHCEQAccountList(0,"InStockList",InStockList,AccountListID))  q:(AccountListID="")||(Flag=1)  d   ///modify by QW0008 修改for循环退出条件
	.q:$p($g(^DHCEQAccountList(AccountListID)),"^",10)="Y"
	.s AccountDate=$p($g(^DHCEQAccountList(AccountListID)),"^",3)
	.q:(StartDate'="")&&(StartDate>AccountDate)
	.q:(EndDate'="")&&(EndDate<AccountDate)
	.s Flag=1
	q Flag
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQAccountList","GetInStock","","","","","","85")
/// modify by QW0008 前移过滤代码，尽量做到先判断再取值
/// modify by QW0008 修改query输出,输出每条入库明细 TEnableFlag:"N":明细CheckBox不可用,"Y":明细CheckBox不可用
/// modify by QW0008 增加申购科室过滤条件
/// modify by lmm 增加退货，入账数量，金额
Query GetInStock(InStockNo, ProviderDR, StartDate, EndDate, CurAccountFlag As %String = "0", CurGroupID As %String = "", BuyLocDR As %String = "", EquipName As %String = "") As %Query(ROWSPEC = "TRowID:%String,TInDate:%String,TLoc:%String,TLocDR:%String,TEquipTypeDR:%String,TEquipType:%String,TRequestDate:%String,TStatus:%String,TRemark:%String,TBillAuditUser:%String,TBillAuditDate:%String,TInStockNo:%String,TRejectDate:%String,TBillAuditUserDR:%String,TOriginDR:%String,TOrigin:%String,TFromDeptDR:%String,TFromDept:%String,TProviderDR:%String,TProvider:%String,TBuyLocDR:%String,TBuyLoc:%String,TBuyUserDR:%String,TBuyUser:%String,TStatCatDR:%String,TStatCat:%String,TISLRowID:%String,TMasterItem:%String,TQuantityNum:%String,TOriginalFee:%String,TExpenditures:%String,TFunds:%String,TEnableFlag:%String,TRow:%String,TotalFee:%String,TEquipName:%String,TReduceNum:%String,TReduceFee:%String,TAccountNum:%String,TAccountFee:%String")
{
}

ClassMethod GetInStockExecute(ByRef qHandle As %Binary, InStockNo, ProviderDR, StartDate, EndDate, CurAccountFlag As %String = "0", CurGroupID As %String = "", BuyLocDR As %String = "", EquipName As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(+$h)
	
	s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")

	s sDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"1")
	s eDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"2")
	s sDate=##class(web.DHCEQCommon).TransValueFromPage(sDate,"date")
	s eDate=##class(web.DHCEQCommon).TransValueFromPage(eDate,"date")

	if CurAccountFlag="1"
	{
		if StartDate=""  s StartDate=sDate
		if EndDate="" s EndDate=eDate
		if StartDate<sDate Quit $$$OK
		if EndDate>eDate Quit $$$OK
	}
	s TRowID=0
	s rowid=0
	s TRow=0
	f  s rowid=$o(^DHCEQInStock(rowid))  quit:rowid=""  d
	.s AccountFlag=##Class(web.DHCEQAccountList).AccountFlag(rowid,"3",StartDate,EndDate)
	.//AccountFlag 0 :未入账  1：已入账
	.q:(CurAccountFlag'="")&(CurAccountFlag'=AccountFlag)
	.q:$p($g(^DHCEQInStock(rowid)),"^",25)="Y"
	.s TEquipTypeDR=$p($g(^DHCEQInStock(rowid)),"^",20)
	.q:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)'=0
	.s TInStockNo = $p($g(^DHCEQInStock(rowid)),"^",14)
	.q:TInStockNo="" //2011-07-22 DJ
	.q:(InStockNo'="")&&($e(TInStockNo,1,$l(InStockNo))'=InStockNo)
	.s TStatus = $p($g(^DHCEQInStock(rowid)),"^",10)
	.q:TStatus'=2
	.s TStatus=##class(web.DHCEQInStockNew).GetInStockStatus(TStatus)
	.s TProviderDR = $p($g(^DHCEQInStock(rowid)),"^",17)
	.q:(ProviderDR'="")&(ProviderDR'=TProviderDR)
	.s TBuyLocDR = $p($g(^DHCEQInStock(rowid)),"^",18)
	.q:(BuyLocDR'="")&(BuyLocDR'=TBuyLocDR)
	.q:(EquipName'="")&&(##class(web.DHCEQAccountList).FilterFunction(EquipName,rowid)=0)
	.s TISLRowID=0
	.f  s TISLRowID=$o(^DHCEQInStockList(0,"InStock",rowid,TISLRowID))  quit:TISLRowID=""  d
	..d ResetVariablesGetInStock
	..s TEnableFlag="Y"
	..i TRowID'=rowid  s TEnableFlag="N"
	..s TRowID = rowid
	..s TInStockNo = $p($g(^DHCEQInStock(TRowID)),"^",14)
	..s TOriginalFee=$p(^DHCEQInStockList(TISLRowID),"^",7)
	..s TQuantityNum=$p(^DHCEQInStockList(TISLRowID),"^",8)
	..s TotalFee=TOriginalFee*TQuantityNum
	..;add by lmm 2021-03-05
	..s TReduceValue=##Class(web.DHCEQInStockList).GetReturnInfoOfInstockList(TISLRowID)
	..s TReduceNum=$p(TReduceValue,"^",1)
	..s TReduceFee=$p(TReduceValue,"^",2)
	..s TAccountNum=TQuantityNum-TReduceNum
	..s TAccountFee=TotalFee-TReduceFee
	..;add by lmm 2021-03-05
	..s TEquipName=$p($g(^DHCEQInStockList(TISLRowID)),"^",5)   //add by wy 2019-3-14
	..s TMasterItemDR=$p($g(^DHCEQInStockList(TISLRowID)),"^",16)
	..i TMasterItemDR'="" s TMasterItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TMasterItemDR)),"^",1)
	..s TExpendituresDR=$p($g(^DHCEQInStockList(TISLRowID)),"^",23) //经费来源
	..i TExpendituresDR'="" s TExpenditures=$p($g(^DHCEQCCode("DHCEQCExpenditures",TExpendituresDR)),"^",2)
	..Set Funds=##Class(web.DHCEQInStockList).GetFundsTypeInfos(3,TISLRowID)
	..i Funds'="" d
	...Set n=$Length(Funds,",")
	...For i=1:1:n Do
	....If TFunds'="" Set TFunds=TFunds_"/"
	....Set TFunds=TFunds_$Piece($Get(^DHCEQCCode("DHCEQCFundsType",$Piece(Funds,",",i))),"^",2)
	..s TProviderDR = $p($g(^DHCEQInStock(rowid)),"^",17)
	..s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	..s TInDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(rowid)),"^",1),"date")
	..s TLocDR = $p($g(^DHCEQInStock(rowid)),"^",2)
	..s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	..s TEquipType = ##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	..s TRequestDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(rowid)),"^",5),"date")
	..s TRemark = $p(^DHCEQInStockList(TISLRowID),"^",12)
	..s TBillAuditUserDR = $p($g(^DHCEQInStock(rowid)),"^",12)
	..s TBillAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TBillAuditUserDR)
	..s TBillAuditDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(rowid)),"^",13),"date")
	..s TOriginDR = $p($g(^DHCEQInStock(rowid)),"^",15)
	..s TOrigin =##class(web.DHCEQCommon).GetTrakNameByID("origin",TOriginDR)
	..s TFromDeptDR = $p($g(^DHCEQInStock(rowid)),"^",16)
	..i TFromDeptDR '=""  d
	...s TFromDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TFromDeptDR)),"^",2)
	..s TBuyLocDR = $p($g(^DHCEQInStock(rowid)),"^",18)
	..s TBuyLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TBuyLocDR)
	..s TBuyUserDR = $p($g(^DHCEQInStock(rowid)),"^",19)
	..s TBuyUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TBuyUserDR)
	..s TStatCatDR=$p($g(^DHCEQInStock(rowid)),"^",21)
	..s TStatCat = ##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
	..s TRow=TRow+1
	..d OutputRowGetInStock
	Quit $$$OK
OutputRowGetInStock
 	;s ^DHCEQTemp("QW","GetInStock",TRowID)=TInDate_":"_TLoc_":"_TLocDR_":"_TEquipTypeDR
	s Data=$lb(TRowID,TInDate,TLoc,TLocDR,TEquipTypeDR,TEquipType,TRequestDate,TStatus,TRemark,TBillAuditUser,TBillAuditDate,TInStockNo,TRejectDate,TBillAuditUserDR,TOriginDR,TOrigin,TFromDeptDR,TFromDept,TProviderDR,TProvider,TBuyLocDR,TBuyLoc,TBuyUserDR,TBuyUser,TStatCatDR,TStatCat,TISLRowID,TMasterItem,TQuantityNum,TOriginalFee,TExpenditures,TFunds,TEnableFlag,TRow,TotalFee,TEquipName,TReduceNum,TReduceFee,TAccountNum,TAccountFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStock
	s (TInDate,TLoc,TLocDR,TEquipTypeDR,TEquipType,TRequestDate,TStatus,TRemark,TBillAuditUser,TBillAuditDate,TInStockNo,TRejectDate,TBillAuditUserDR,TOriginDR,TOrigin,TFromDeptDR,TFromDept,TProviderDR,TProvider,TBuyLocDR,TBuyLoc,TBuyUserDR,TBuyUser,TStatCatDR,TStatCatTISLRowID,TMasterItem,TMasterItemDR,TQuantityNum,TOriginalFee,TExpenditures,TExpendituresDR,Funds,TFunds,TEnableFlag,TotalFee,TEquipName,TReduceValue,TReduceNum,TReduceFee,TAccountNum,TAccountFee)=""
	quit
}

ClassMethod GetInStockFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockExecute ]
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

ClassMethod GetInStockClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQAccountList).SaveDataByStockDR("509","1")
/// Add By QW20170602 根据入库单主单id处理入账明细表
/// modify by QW0008 增加user参数以及修改返回值格式:"ID^SQLCODE"
ClassMethod SaveDataByStockDR(StockIDS As %String = "", DelIs As %String = "", User As %String = "")
{
	new (StockIDS,DelIs,User)
	s Length=$l(StockIDS,",")
	s CSSQLCODE=-1
	s rowid=""
	Set $ZT="ERRORSave"
	TSTART	
	for i=1:1:Length 
	{
		s rowid=$p(StockIDS,",",i)
		s ilrowid=0
		f  s ilrowid=$o(^DHCEQInStockList(0,"InStock",rowid,ilrowid))  quit:ilrowid=""  d
		.s AccountListID=0
		.f  s AccountListID=$o(^DHCEQAccountList(0,"InStockList",ilrowid,AccountListID))  q:AccountListID=""  d
		..q:$p($g(^DHCEQAccountList(AccountListID)),"^",10)="Y"
		..s AcountList=AccountListID
		.k EQPL
		.i DelIs'=1 d
		..s AcountList=""
		.s AcountList=AcountList_"^"_ilrowid
		.s AcountList=AcountList_"^"_$P(^DHCEQInStock(rowid),"^",20)
		.s AcountList=AcountList_"^"_$P(^DHCEQInStockList(ilrowid),"^",17)
		.s AcountList=AcountList_"^"_$P(^DHCEQInStockList(ilrowid),"^",14)
		.s AcountList=AcountList_"^"_$P(^DHCEQInStockList(ilrowid),"^",15)
		.s AcountList=AcountList_"^"_"手工入账"
		.s AcountList=AcountList_"^"
		.s AcountList=AcountList_"^"
		.s AcountList=AcountList_"^"
		.s AcountList=AcountList_"^"
		.s AcountList=AcountList_"^"
		.s CSSQLCODE=##Class(web.DHCEQAccountList).SaveData(AcountList,DelIs,User)
		.q:+CSSQLCODE'=0
		.i DelIs=1 d
		..s EQPL(46)=""
		..s EQPL(112)="0"
		.e  d
		..s EQPL(46)=+$H
		..s EQPL(112)="1"
		.&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_InStockListDR=:ilrowid)	/// Mozy0145	20141017
		.s CSSQLCODE=SQLCODE
		.q:CSSQLCODE'=0
	}
	i CSSQLCODE
	{
		TROLLBACK
		q CSSQLCODE_"^"_rowid
	}
	TCOMMIT
 	q CSSQLCODE_"^"_rowid
ERRORSave 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息 ;
}

/*****
*Add By QW0008 
*入单id统计所有数量及金额
*返回数量总计和金额总计:TotalNum_"^"_TotalFee
******/
ClassMethod CalculaTotal(StockIDS As %String = "")
{
	new TotalFee,TotalNum
	i StockIDS="" q ""
	s Length=$l(StockIDS,",")
	s (TotalFee,TotalNum)=0
	for i=1:1:Length 
	{
		s rowid=$p(StockIDS,",",i)
		s TTotal=##class(web.DHCEQInStockNew).GetOneInStockTotalFeeNum(rowid)
		s TotalNum=TotalNum+$P(TTotal,"^",1)
		s TotalFee=TotalFee+$P(TTotal,"^",2)
	}
	q TotalNum_"^"_TotalFee
}

/*****
*Add By QW0008 
*判断入库明细中是否有对应名称设备,有则输出入库单所有明细
*返回值:1:包含,0:不包含
******/
ClassMethod FilterFunction(EquipName As %String = "", StockID As %String = "")
{
	new Flag,TName,TISLRowID
	if EquipName="" q 1
	s Flag=0
	s TISLRowID=0
	f  s TISLRowID=$o(^DHCEQInStockList(0,"InStock",StockID,TISLRowID))  quit:(TISLRowID="")||(Flag=1)  d
	.s TName = $p($g(^DHCEQInStockList(TISLRowID)),"^",5)
	.q:((EquipName'="")&&(TName'[EquipName))
	.s Flag=1
	 q Flag
}

Storage Default
{
<Data name="DHCEQAccountListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQAccountListD</DataLocation>
<DefaultData>DHCEQAccountListDefaultData</DefaultData>
<IdLocation>^web.DHCEQAccountListD</IdLocation>
<IndexLocation>^web.DHCEQAccountListI</IndexLocation>
<StreamLocation>^web.DHCEQAccountListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
