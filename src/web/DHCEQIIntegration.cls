Class web.DHCEQIIntegration Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 设备清单查询
/// 参数说明：begindate：2012-01-01
/// 			  enddate：2012-01-01
/// d ##class(%ResultSet).RunQuery("web.DHCEQIIntegration","GetEquipList","","")
Query GetEquipList(begindate, enddate) As %Query(ROWSPEC = "No:%String,Name:%String,StatCatCode:%String,StatCatDesc:%String,EquipTypeCode:%String,EquipTypeDesc:%String,CardNo:%String,BarNo:%String,OriginalFee:%String,Quantity:%String,Unit:%String,TotalFee:%String,Model:%String,LimitYearsNum:%String,AddDate:%String,StartDate:%String,UseLocCode:%String,UseLocDesc:%String,StoreLocCode:%String,StoreLocDesc:%String,Location:%String,HasDepreFlag:%String,PayMode:%String,Funds:%String,Status:%String,Remark:%String")
{
}

ClassMethod GetEquipListExecute(ByRef qHandle As %Binary, begindate, enddate) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	.d CheckEquip
	.q:pass'=0
	.d ResetVariablesGetEquipList
	.s globalInfo=$g(^DHCEQEquip(rowid))
	.s No = $p(globalInfo,"^",71)
	.s Name = $p(globalInfo,"^",1)
	.s StatCatID = $p(globalInfo,"^",75)
	.i StatCatID'=""  d
	..s StatCatCode = $p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",1)
	..s StatCatDesc = $p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",2)
	.s EquipTypeID = $p(globalInfo,"^",63)
	.i EquipTypeID '=""  d
	..s EquipTypeDesc = $p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeID)),"^",2)
	..s EquipTypeCode = $p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeID)),"^",1)
	.s CardNo = No
	.s BarNo = No
	.s OriginalFee = $p(globalInfo,"^",27)
	.s Quantity = 1
	.s UnitID = $p(globalInfo,"^",5)
	.i UnitID '="" s Unit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",(UnitID))	;Modified By jdl 20150906 v4.1.0 规范单位取值
	.s TotalFee = OriginalFee*Quantity
	.s ModelID = $p(globalInfo,"^",3)
	.i ModelID '="" s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelID)),"^",2)
	.s LimitYearsNum = $p(globalInfo,"^",31)
	.i $p(globalInfo,"^",53)'="" s AddDate =##Class(web.DHCEQCommon).TransValueToPage($p(globalInfo,"^",53),"date") ;$ZD($p(globalInfo,"^",53),3)
	.i $p(globalInfo,"^",44)'="" s StartDate =##Class(web.DHCEQCommon).TransValueToPage($p(globalInfo,"^",44),"date") ;$ZD($p(globalInfo,"^",44),3)
	.s UseLocID = $p(globalInfo,"^",19)
	.i UseLocID '=""  d
	..s UseLocCode = ##class(web.DHCEQCommon).GetTrakNameByID("deptcode",UseLocID)
	..s UseLocDesc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocID)
	.s StoreLocID = $p(globalInfo,"^",19)
	.i StoreLocID '=""  d
	..s StoreLocDesc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocID)
	..s StoreLocCode = ##class(web.DHCEQCommon).GetTrakNameByID("deptcode",UseLocID)
	.s Location = $p(globalInfo,"^",72)
	.i Location '="" s Location=$p($g(^DHCEQCCode("DHCEQCLocation",Location)),"^",2)
	.s HasDepreFlag = $p(globalInfo,"^",74)
	.s BuyTypeID = $p(globalInfo,"^",23)
	.i BuyTypeID '="" s BuyType = $p($g(^DHCEQCCode("DHCEQCBuyType",BuyTypeID)),"^",2)
	.s Funds = ##Class(web.DHCEQFunds).GetFundsInfo(1,rowid)
	.s Status = $p(globalInfo,"^",38)
	.i Status '="" s Status=$Case(Status,0:"新增",1:"启用",2:"封存",3:"报废",4:"其他")
	.s Remark = $p(globalInfo,"^",34)
	.d OutputRowGetEquipList
	Quit $$$OK
CheckEquip
	s pass=0
	i $p(^DHCEQEquip(rowid),"^",59)="Y"
	{
		s pass=1 quit
	}
	i $p(^DHCEQEquip(rowid),"^",77)'=""		;验收明细ID,
	{
		i $p(^DHCEQEquip(rowid),"^",70)=""
		{
			s pass=1 quit
		}	;入库明细ID,验收未入库的设备
	}
	quit
OutputRowGetEquipList
   s Data=$lb(No,Name,StatCatCode,StatCatDesc,EquipTypeCode,EquipTypeDesc,CardNo,BarNo,OriginalFee,Quantity,Unit,TotalFee,Model,LimitYearsNum,AddDate,StartDate,UseLocCode,UseLocDesc,StoreLocCode,StoreLocDesc,Location,HasDepreFlag,PayMode,Funds,Status,Remark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipList
	s (No,Name,StatCatID,StatCatCode,StatCatDesc,EquipTypeID,EquipTypeCode,EquipTypeDesc,CardNo,BarNo,Quantity,Unit,TotalFee,Model,LimitYearsNum,AddDate,StartDate,UseLocID,UseLocCode,UseLocDesc,StoreLocID,StoreLocCode,StoreLocDesc,Location,HasDepreFlag,PayMode,Funds,Status,Remark)=""
	quit
}

ClassMethod GetEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipListExecute ]
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

ClassMethod GetEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 设备类型表数据
/// d ##class(%ResultSet).RunQuery("web.DHCEQIIntegration","GetStatCat")
Query GetStatCat() As %Query(ROWSPEC = "Code:%String,Desc:%String,UseYear:%String,Decription:%String,Remark:%String")
{
}

ClassMethod GetStatCatExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCStatCat",rowid)) quit:rowid=""  d
	.d ResetVariablesGetStatCat
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",2)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",3)
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",4)
	.q:TInvalidFlag="Y"
	.s TEQType=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",5)
	.s TEQType=$Case(TEQType,"":"","1":"设备","2":"土地","3":"房屋建筑物","4":"交通工具","5":"图书","9":"其他") //EQType
	.s TEQFlag=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",6)
	.s TMinPrice=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",7)
	.s TMaxPrice=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",8)
	.s THold1=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",9)
	.s THold2=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",10)
	.s THold3=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",11)
	.s THold4=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",12)
	.s THold5=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",13)
	.s TDecription=""
	.d OutputRowGetStatCat
	Quit $$$OK
OutputRowGetStatCat
	s Data=$lb(TCode,TDesc,THold1,TDecription,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStatCat
	s (TRowID,TCode,TDesc,TRemark,TInvalidFlag,TEQType,TEQFlag,TMinPrice,TMaxPrice,THold1,THold2,THold3,THold4,THold5,TDecription)=""
	quit
}

ClassMethod GetStatCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatCatExecute ]
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

ClassMethod GetStatCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 设备入库明细查询
/// 参数说明：begindate：2012-01-01
/// 			  enddate：2012-01-01
/// d ##class(%ResultSet).RunQuery("web.DHCEQIIntegration","GetInStock","2012-03-01","2012-03-05")
Query GetInStock(begindate, enddate) As %Query(ROWSPEC = "InStockNo:%String,InDate:%String,AuditDate:%String,Loc:%String,No:%String,Name:%String,StatCatCode:%String,StatCatDesc:%String,EquipTypeCode:%String,EquipTypeDesc:%String,Status:%String,Model:%String,OriginalFee:%String,Qty:%String,Unit:%String,TotalFee:%String,InvoiceNo:%String,LimitYearsNum:%String,Provider:%String")
{
}

ClassMethod GetInStockExecute(ByRef qHandle As %Binary, begindate, enddate) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (begindate="")||(enddate="") Quit $$$OK
	s begindate=##Class(web.DHCEQCommon).TransValueFromPage(begindate,"date") ;$ZDH(begindate,3)
	s enddate=##Class(web.DHCEQCommon).TransValueFromPage(enddate,"date") ;$ZDH(enddate,3)
	
	s rowid=0
	f  s rowid=$o(^DHCEQInStock(rowid))  quit:rowid=""  d
	.d ResetVariablesGetInStock
	.s InvalidFlag=$p($g(^DHCEQInStock(rowid)),"^",25)
	.q:InvalidFlag="Y"
	.s BussStatus=$p($g(^DHCEQInStock(rowid)),"^",10)
	.q:BussStatus'="2"
	.s InStockNo = $p($g(^DHCEQInStock(rowid)),"^",14)
	.s InDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(rowid)),"^",1),"date") ;$ZD($p($g(^DHCEQInStock(rowid)),"^",1),3)
	.s AuditDate = $p($g(^DHCEQInStock(rowid)),"^",7)
	.q:(begindate>AuditDate)||(enddate<AuditDate)
	.s AuditDate =##Class(web.DHCEQCommon).TransValueToPage(AuditDate,"date") ;$ZD(AuditDate,3)
	.s LocID = $p($g(^DHCEQInStock(rowid)),"^",2)
	.i LocID '=""  s Loc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",LocID)
	.s EquipTypeID = $p($g(^DHCEQInStock(rowid)),"^",20)
	.i EquipTypeID '=""  d
	..s EquipTypeCode = $p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeID)),"^",1)
	..s EquipTypeDesc = $p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeID)),"^",2)
	.s StatCatID = $p($g(^DHCEQInStock(rowid)),"^",21)
	.i StatCatID '=""  d
	..s StatCatCode = $p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",1)
	..s StatCatDesc = $p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",2)
	.s ProviderID = $p($g(^DHCEQInStock(rowid)),"^",17)
	.i ProviderID '="" s Provider = $p($g(^DHCEQCCode("DHCEQCVendor",ProviderID)),"^",2)
	.s ISLrowid=0
	.f  s ISLrowid=$o(^DHCEQInStockList(0,"InStock",rowid,ISLrowid))  quit:ISLrowid=""  d
	..s (Name,StatCatID,StatCatCode,StatCatDesc,ModelID,Model,UnitID,Unit)=""
	..s Name = $p($g(^DHCEQInStockList(ISLrowid)),"^",5)
	..s StatCatID = $p($g(^DHCEQInStockList(ISLrowid)),"^",17)
	..i StatCatID '=""  d
	...s StatCatCode = $p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",1)
	...s StatCatDesc = $p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",2)
	..s ModelID = $p($g(^DHCEQInStockList(ISLrowid)),"^",9)
	..i ModelID '="" s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelID)),"^",2)
	..s UnitID = $p($g(^DHCEQInStockList(ISLrowid)),"^",10)
	..i UnitID '="" s Unit = $p($g(^DHCEQCCode("DHCEQCUOM",UnitID)),"^",2)
	..s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source","1",ISLrowid,0))
	..i IUMRowID '=""  d
	...s IUMRowID=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)
	...s InvoiceNo = $p(^DHCEQInvoice(IUMRowID),"^",2)
	..s locid=0
	..f  s locid=$o(^DHCEQEquip(0,"InStockList",ISLrowid,locid))  quit:locid=""  d
	...s EquipID=0
	...f  s EquipID=$o(^DHCEQEquip(0,"InStockList",ISLrowid,locid,EquipID))  quit:EquipID=""  d
	....s (No,Status,OriginalFee,Qty,TotalFee,LimitYearsNum)=""
	....s No = $p($g(^DHCEQEquip(EquipID)),"^",71)
	....s Status = $p($g(^DHCEQEquip(EquipID)),"^",38)
	....i Status '="" s Status=$Case(Status,0:"新增",1:"启用",2:"封存",3:"报废",4:"其他")
	....s OriginalFee = $p($g(^DHCEQEquip(EquipID)),"^",27)
	....s Qty=1
	....s TotalFee=OriginalFee*Qty
	....s LimitYearsNum = $p($g(^DHCEQEquip(EquipID)),"^",31)
	....d OutputRowGetInStock
	Quit $$$OK
OutputRowGetInStock
	s Data=$lb(InStockNo,InDate,AuditDate,Loc,No,Name,StatCatCode,StatCatDesc,EquipTypeCode,EquipTypeDesc,Status,Model,OriginalFee,Qty,Unit,TotalFee,InvoiceNo,LimitYearsNum,Provider)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStock
	s (InvalidFlag,BussStatus,InStockNo,InDate,AuditDate,LocID,Loc,EquipTypeID,EquipTypeCode,EquipTypeName,ProviderID,Provider)=""
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

/// 设备转移明细查询
/// 参数说明：begindate：2012-01-01
/// 			  enddate：2012-01-01
/// d ##class(%ResultSet).RunQuery("web.DHCEQIIntegration","GetStoreMove","2012-02-01","2012-03-10")
Query GetStoreMove(begindate, enddate) As %Query(ROWSPEC = "StoreMoveNo:%String,MoveType:%String,StoreMoveDate:%String,AuditDate:%String,No:%String,Name:%String,StatCatCode:%String,StatCatDesc:%String,EquipTypeCode:%String,EquipTypeDesc:%String,FromLocCode:%String,FromLocDesc:%String,ToLocCode:%String,ToLocDesc:%String,StoreMoveDate:%String,Receive:%String,Remark:%String")
{
}

ClassMethod GetStoreMoveExecute(ByRef qHandle As %Binary, begindate, enddate) As %Status
{
 	new repid, index,rowid,ApproveType
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (begindate="")||(enddate="") Quit $$$OK
	s begindate=##Class(web.DHCEQCommon).TransValueFromPage(begindate,"date") ;$ZDH(begindate,3)
	s enddate=##Class(web.DHCEQCommon).TransValueFromPage(enddate,"date") ; $ZDH(enddate,3)
	
	s rowid=0
	f  s rowid=$o(^DHCEQStoreMove(rowid))  quit:rowid=""  d
	.d ResetVariablesGetStoreMove
	.s InvalidFlag=$p($g(^DHCEQStoreMove(rowid)),"^",27)
	.q:InvalidFlag="Y"
	.s BussStatus=$p($g(^DHCEQStoreMove(rowid)),"^",13)
	.q:BussStatus'="2"
	.s StoreMoveNo = $p($g(^DHCEQStoreMove(rowid)),"^",1)
	.s StoreMoveDate =##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(rowid)),"^",5),"date") ;$ZD($p($g(^DHCEQStoreMove(rowid)),"^",5),3)
	.s AuditDate = $p($g(^DHCEQStoreMove(rowid)),"^",10)
	.q:(begindate>AuditDate)||(enddate<AuditDate)
	.s AuditDate =##Class(web.DHCEQCommon).TransValueToPage(AuditDate,"date") ; $ZD(AuditDate,3)
	.s FromLocID = $p($g(^DHCEQStoreMove(rowid)),"^",2)
	.i FromLocID '=""  d
	..s FromLocCode = ##class(web.DHCEQCommon).GetTrakNameByID("deptcode",FromLocID)
	..s FromLocDesc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",FromLocID)
	.s ToLocID = $p($g(^DHCEQStoreMove(rowid)),"^",3)	//modified by zy 2012-04-05	
	.i ToLocID '=""  d
	..s ToLocCode = ##class(web.DHCEQCommon).GetTrakNameByID("deptcode",ToLocID)
	..s ToLocDesc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",ToLocID)
	.s MoveType = $p($g(^DHCEQStoreMove(rowid)),"^",12)
	.i MoveType '="" s MoveType=$Case(MoveType,0:"库房分配",1:"科室调配",3:"科室退库",4:"库房调配")
	.s ReceiveID = $p($g(^DHCEQStoreMove(rowid)),"^",15)
	.i ReceiveID'="" s Receive = ##class(web.DHCEQCommon).GetTrakNameByID("user",ReceiveID)
	.s EquipTypeID = $p($g(^DHCEQStoreMove(rowid)),"^",16)
	.i EquipTypeID '=""  d
	..s EquipTypeCode = $p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeID)),"^",1)
	..s EquipTypeDesc = $p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeID)),"^",2)
	.s StatCatID = $p($g(^DHCEQStoreMove(rowid)),"^",17)	//modified by zy 2012-04-05	
	.i StatCatID '=""  d
	..s StatCatCode = $p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",1)
	..s StatCatDesc = $p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",2)
	.s SMLrowid=0
	.f  s SMLrowid=$o(^DHCEQStoreMoveList(0,"StoreMove",rowid,SMLrowid))  quit:SMLrowid=""  d
	..s (Name,Remark)=""
	..s Name = $p($g(^DHCEQStoreMoveList(SMLrowid)),"^",5)
	..s Remark = $p($g(^DHCEQStoreMoveList(SMLrowid)),"^",11)
	..s EquipID=0
	..f  s EquipID=$o(^DHCEQLifeInfo(0,"EquipSource","22",EquipID))  quit:EquipID=""  d
	...s Flag=0
	...s SourceID=0
	...f  s SourceID=$o(^DHCEQLifeInfo(0,"EquipSource","22",EquipID,SourceID))  quit:SourceID=""  d
	....i SourceID=SMLrowid s Flag=1
	...q:Flag=0
	...s No = $p($g(^DHCEQEquip(EquipID)),"^",71)
	...d OutputRowGetStoreMove
	Quit $$$OK
OutputRowGetStoreMove
	s Data=$lb(StoreMoveNo,MoveType,StoreMoveDate,AuditDate,No,Name,StatCatCode,StatCatDesc,EquipTypeCode,EquipTypeDesc,FromLocCode,FromLocDesc,ToLocCode,ToLocDesc,StoreMoveDate,Receive,Remark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreMove
	s (InvalidFlag,BussStatus,StoreMoveNo,MoveType,StoreMoveDate,AuditDate,No,Name,StatCatID,StatCatCode,StatCatDesc,EquipTypeID,EquipTypeCode,EquipTypeDesc,FromLocID,FromLocCode,FromLocDesc,ToLocID,ToLocCode,ToLocDesc,StoreMoveDate,ReceiveID,Receive,Remark)=""
	quit
}

ClassMethod GetStoreMoveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveExecute ]
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

ClassMethod GetStoreMoveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 设备退货明细查询
/// 参数说明：begindate：2012-01-01
/// 			  enddate：2012-01-01
/// d ##class(%ResultSet).RunQuery("web.DHCEQIIntegration","GetReturn","2012-03-01","2012-03-10")
Query GetReturn(begindate, enddate) As %Query(ROWSPEC = "ReturnType:%String,ReturnNo:%String,ReturnDate:%String,AuditDate:%String,Loc:%String,No:%String,Name:%String,StatCatCode:%String,StatCatDesc:%String,EquipTypeCode:%String,EquipTypeDesc:%String,Status:%String,Model:%String,OriginalFee:%String,Quantity:%String,Unit:%String,TotalFee:%String,InvoiceNo:%String,LimitYearsNum:%String,Provider:%String,Remark:%String")
{
}

ClassMethod GetReturnExecute(ByRef qHandle As %Binary, begindate, enddate) As %Status
{
 	new repid, index,rowid,ApproveType
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (begindate="")||(enddate="") Quit $$$OK
	s begindate=##Class(web.DHCEQCommon).TransValueFromPage(begindate,"date") ;$ZDH(begindate,3)
	s enddate=##Class(web.DHCEQCommon).TransValueFromPage(enddate,"date") ;$ZDH(enddate,3)
	
	s rowid=0
	f  s rowid=$o(^DHCEQReturn(rowid))  quit:rowid=""  d
	.d ResetVariablesGetReturn
	.s InvalidFlag=$p($g(^DHCEQReturn(rowid)),"^",28)
	.q:InvalidFlag="Y"
	.s BussStatus=$p($g(^DHCEQReturn(rowid)),"^",13)
	.q:BussStatus'="2"
	.s ReturnNo = $p($g(^DHCEQReturn(rowid)),"^",1)
	.s ProviderID = $p($g(^DHCEQReturn(rowid)),"^",3)
	.i ProviderID '="" s Provider = $p($g(^DHCEQCCode("DHCEQCVendor",ProviderID)),"^",2)
	.s ReturnDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQReturn(rowid)),"^",6),"date") ;$ZD($p($g(^DHCEQReturn(rowid)),"^",6),3)
	.s AuditDate = $p($g(^DHCEQReturn(rowid)),"^",8)
	.q:(begindate>AuditDate)||(enddate<AuditDate)
	.s AuditDate = ##Class(web.DHCEQCommon).TransValueToPage(AuditDate,"date") ; $ZD(AuditDate,3)
	.s LocID = $p($g(^DHCEQReturn(rowid)),"^",2)
	.i LocID '="" s Loc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",LocID)
	.s ReturnType = $p($g(^DHCEQReturn(rowid)),"^",17)
	.i ReturnType '="" s ReturnType=$p($g(^DHCEQCCode("DHCEQCOutType",ReturnType)),"^",2)
	.s EquipTypeID = $p($g(^DHCEQReturn(rowid)),"^",15)
	.i EquipTypeID '=""  d
	..s EquipTypeCode = $p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeID)),"^",1)
	..s EquipTypeDesc = $p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeID)),"^",2)
	.s RLrowid=0
	.f  s RLrowid=$o(^DHCEQReturnList(0,"Return",rowid,RLrowid))  quit:RLrowid=""  d
	..s Remark = $p($g(^DHCEQReturnList(RLrowid)),"^",9)
	..s InvoiceNo =$p($g(^DHCEQReturnList(RLrowid)),"^",7)
	..s EquipID=0
	..f  s EquipID=$o(^DHCEQLifeInfo(0,"EquipSource","23",EquipID))  quit:EquipID=""  d
	...s Flag=0
	...s SourceID=0
	...f  s SourceID=$o(^DHCEQLifeInfo(0,"EquipSource","23",EquipID,SourceID))  quit:SourceID=""  d
	....i SourceID=RLrowid s Flag=1
	...q:Flag=0
	...s (StatCatID,StatCatCode,StatCatDesc,Name,No,OriginalFee,Quantity,UnitID,Unit,TotalFee,ModelID,Model,LimitYearsNum,Status)=""
	...s StatCatID = $p($g(^DHCEQEquip(EquipID)),"^",75)
	...i StatCatID '=""  d
	....s StatCatCode = $p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",1)
	....s StatCatDesc = $p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",2)
	...s Name = $p($g(^DHCEQEquip(EquipID)),"^",1)
	...s No = $p($g(^DHCEQEquip(EquipID)),"^",71)
	...s OriginalFee = $p($g(^DHCEQEquip(EquipID)),"^",27)
	...s Quantity = 1
	...s UnitID = $p($g(^DHCEQEquip(EquipID)),"^",5)
	...i UnitID '="" s Unit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",(UnitID))	;Modified By jdl 20150906 v4.1.0 规范单位取值
	...s TotalFee = OriginalFee*Quantity
	...s ModelID = $p($g(^DHCEQEquip(EquipID)),"^",3)
	...i ModelID '="" s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelID)),"^",2)
	...s LimitYearsNum = $p($g(^DHCEQEquip(EquipID)),"^",31)
	...s Status = $p($g(^DHCEQEquip(EquipID)),"^",38)
	...i Status '="" s Status=$Case(Status,0:"新增",1:"启用",2:"封存",3:"报废",4:"其他")
	...d OutputRowGetReturn
	Quit $$$OK
OutputRowGetReturn
	s Data=$lb(ReturnType,ReturnNo,ReturnDate,AuditDate,Loc,No,Name,StatCatCode,StatCatDesc,EquipTypeCode,EquipTypeDesc,Status,Model,OriginalFee,Quantity,Unit,TotalFee,InvoiceNo,LimitYearsNum,Provider,Remark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetReturn
	s (InvalidFlag,BussStatus,ReturnNo,ProviderID,Provider,ReturnDate,AuditDate,LocID,Loc,ReturnType,EquipTypeID,EquipTypeCode,EquipTypeDesc)=""
	quit
}

ClassMethod GetReturnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReturnExecute ]
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

ClassMethod GetReturnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReturnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 设备调账明细查询
/// 参数说明：begindate：2012-01-01
/// 			  enddate：2012-01-01
/// d ##class(%ResultSet).RunQuery("web.DHCEQIIntegration","GetChangeAccount","2012-03-01","2012-03-10")
Query GetChangeAccount(begindate, enddate) As %Query(ROWSPEC = "No:%String,Name:%String,StatCatCode:%String,StatCatDesc:%String,EquipTypeCode:%String,EquipTypeDesc:%String,OriginalFee:%String,NetFee:%String,ChangeFee:%String,ChangedOriginalFee:%String,ChangedNetFee:%String,ChangeDate:%String,AuditDate:%String,Funds:%String,Remark:%String")
{
}

ClassMethod GetChangeAccountExecute(ByRef qHandle As %Binary, begindate, enddate) As %Status
{
 	new repid, index,rowid,ApproveType
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (begindate="")||(enddate="") Quit $$$OK
	s begindate=##Class(web.DHCEQCommon).TransValueFromPage(begindate,"date") ;$ZDH(begindate,3)
	s enddate=##Class(web.DHCEQCommon).TransValueFromPage(enddate,"date") ;$ZDH(enddate,3)
	
	s EquipID=0
	f  s EquipID=$o(^DHCEQChangeAccount(0,"Equip",EquipID))  quit:EquipID=""  d
	.s (No,Name,StatCatID,StatCatCode,StatCatDesc,EquipTypeID,EquipTypeCode,EquipTypeDesc)=""
	.s Name = $p($g(^DHCEQEquip(EquipID)),"^",1)
	.s No = $p($g(^DHCEQEquip(EquipID)),"^",71)
	.s EquipTypeID = $p($g(^DHCEQEquip(EquipID)),"^",63)
	.i EquipTypeID '=""  d
	..s EquipTypeCode = $p($g(^DHCEQCCode("DHCEQCStatCat",EquipTypeID)),"^",1)
	..s EquipTypeDesc = $p($g(^DHCEQCCode("DHCEQCStatCat",EquipTypeID)),"^",2)
	.s StatCatID = $p($g(^DHCEQEquip(EquipID)),"^",75)
	.i StatCatID '=""  d
	..s StatCatCode = $p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",1)
	..s StatCatDesc = $p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",2)
	.s rowid=0
	.f  s rowid=$o(^DHCEQChangeAccount(0,"Equip",EquipID,rowid))  quit:rowid=""  d
	..s BussStatus = $p($g(^DHCEQChangeAccount(rowid)),"^",11)
	..q:BussStatus'="2"
	..d ResetVariablesGetChangeAccount
	..s ChangeDate=$p($g(^DHCEQChangeAccount(rowid)),"^",13)
	..s ChangeDate=##Class(web.DHCEQCommon).TransValueToPage(ChangeDate,"date") ; $ZD(ChangeDate,3)
	..s AuditDate=$p($g(^DHCEQChangeAccount(rowid)),"^",22)
	..q:(begindate>AuditDate)||(enddate<AuditDate)
	..s AuditDate =##Class(web.DHCEQCommon).TransValueToPage(AuditDate,"date") ; $ZD(AuditDate,3)
	..s ChangeFee = $p($g(^DHCEQChangeAccount(rowid)),"^",2)
	..s ChangedOriginalFee = $p($g(^DHCEQChangeAccount(rowid)),"^",3)
	..s ChangedNetFee = $p($g(^DHCEQChangeAccount(rowid)),"^",4)
	..s OriginalFee = ChangedOriginalFee-ChangeFee
	..s NetFee = ChangedNetFee-ChangeFee
	..s Remark = $p($g(^DHCEQChangeAccount(rowid)),"^",10)
	..s Funds = ##Class(web.DHCEQFunds).GetFundsInfo(1,EquipID)
	..d OutputRowGetChangeAccount
	Quit $$$OK
OutputRowGetChangeAccount
	s Data=$lb(No,Name,StatCatCode,StatCatDesc,EquipTypeCode,EquipTypeDesc,OriginalFee,NetFee,ChangeFee,ChangedOriginalFee,ChangedNetFee,ChangeDate,AuditDate,Funds,Remark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetChangeAccount
	s (OriginalFee,NetFee,ChangeFee,ChangedOriginalFee,ChangedNetFee,ChangeDate,AuditDate,Funds,Remark)=""
	quit
}

ClassMethod GetChangeAccountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChangeAccountExecute ]
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

ClassMethod GetChangeAccountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChangeAccountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 设备报废明细查询
/// 参数说明：begindate：2012-01-01
/// 			  enddate：2012-01-01
/// d ##class(%ResultSet).RunQuery("web.DHCEQIIntegration","GetDisuse","2012-03-01","2012-03-10")
Query GetDisuse(begindate, enddate) As %Query(ROWSPEC = "No:%String,Name:%String,StatCatCode:%String,StatCatDesc:%String,EquipTypeCode:%String,EquipTypeDesc:%String,LocCode:%String,LocDesc:%String,RequestDate:%String,AuditDate:%String,Remar:%String")
{
}

ClassMethod GetDisuseExecute(ByRef qHandle As %Binary, begindate, enddate) As %Status
{
 	new repid, index,rowid,ApproveType
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (begindate="")||(enddate="") Quit $$$OK
	s begindate=##Class(web.DHCEQCommon).TransValueFromPage(begindate,"date") ;$ZDH(begindate,3)
	s enddate=##Class(web.DHCEQCommon).TransValueFromPage(enddate,"date") ;$ZDH(enddate,3)
	
	s rowid=0
	f  s rowid=$o(^DHCEQDisuseRequest(0,"Status",2,rowid))  quit:rowid=""  d
	.s (InvalidFlag,BussStatus,LocID,LocCode,LocDesc,RequestDate,AuditDate)=""
	.s InvalidFlag=$p($g(^DHCEQDisuseRequest(rowid)),"^",53)
	.q:InvalidFlag="Y"
	.s BussStatus=$p($g(^DHCEQDisuseRequest(rowid)),"^",10)
	.q:BussStatus'="2"
	.s LocID = $p($g(^DHCEQDisuseRequest(rowid)),"^",34)
	.i LocID '="" d
	..s LocCode = ##class(web.DHCEQCommon).GetTrakNameByID("deptcode",LocID)
	..s LocDesc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",LocID)
	.s RequestDate = $p($g(^DHCEQDisuseRequest(rowid)),"^",4)
	.s RequestDate=##Class(web.DHCEQCommon).TransValueToPage(RequestDate,"date") ;$ZD(RequestDate,3)
	.s AuditDate = $p($g(^DHCEQDisuseRequest(rowid)),"^",21)
	.q:(begindate>AuditDate)||(enddate<AuditDate)
	.s AuditDate=##Class(web.DHCEQCommon).TransValueToPage(AuditDate,"date") ;$ZD(AuditDate,3)
	.s DRLRowID=0
	.f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",rowid,DRLRowID))  quit:DRLRowID=""  d
	..d ResetVariablesGetDisuse
	..s Remark = $p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",7)
	..s EquipID = $p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	..q:EquipID=""
	..s Name = $p($g(^DHCEQEquip(EquipID)),"^",1)
	..s No = $p($g(^DHCEQEquip(EquipID)),"^",71)
	..s EquipTypeID = $p($g(^DHCEQEquip(EquipID)),"^",63)
	..i EquipTypeID '=""  d
	...s EquipTypeCode = $p($g(^DHCEQCCode("DHCEQCStatCat",EquipTypeID)),"^",1)
	...s EquipTypeDesc = $p($g(^DHCEQCCode("DHCEQCStatCat",EquipTypeID)),"^",2)
	..s StatCatID = $p($g(^DHCEQEquip(EquipID)),"^",75)
	..i StatCatID '=""  d
	...s StatCatCode = $p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",1)
	...s StatCatDesc = $p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",2)
	..d OutputRowGetDisuse
	Quit $$$OK
OutputRowGetDisuse
	s Data=$lb(No,Name,StatCatCode,StatCatDesc,EquipTypeCode,EquipTypeDesc,LocCode,LocDesc,RequestDate,AuditDate,Remark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDisuse
	s (No,Name,StatCatID,StatCatCode,StatCatDesc,EquipTypeID,EquipTypeCode,EquipTypeDesc)=""
	quit
}

ClassMethod GetDisuseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisuseExecute ]
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

ClassMethod GetDisuseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisuseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 设备维修明细查询
/// 参数说明：begindate：2012-01-01
/// 			  enddate：2012-01-01
/// d ##class(%ResultSet).RunQuery("web.DHCEQIIntegration","GetMaint","2012-03-01","2012-03-10")
Query GetMaint(begindate, enddate) As %Query(ROWSPEC = "RequestNo:%String,RequestDate:%String,AuditDate:%String,No:%String,Name:%String,RequestLocCode:%String,RequestLocDesc:%String,UseLocCode:%String,UseLocDesc:%String,UserSign:%String,StartDate:%String,FaultCase:%String,MaintFee:%String,EndDate:%String,AcceptUser:%String,FaultType:%String,MaintMode:%String,FaultReason:%String,DealMethod:%String,SettlementDate:%String,Remark:%String")
{
}

ClassMethod GetMaintExecute(ByRef qHandle As %Binary, begindate, enddate) As %Status
{
 	new repid, index,rowid,ApproveType
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (begindate="")||(enddate="") Quit $$$OK
	s begindate=##Class(web.DHCEQCommon).TransValueFromPage(begindate,"date") ;$ZDH(begindate,3)
	s enddate=##Class(web.DHCEQCommon).TransValueFromPage(enddate,"date") ;$ZDH(enddate,3)
	
	s EquipID=0
	f  s EquipID=$o(^DHCEQMaintRequest(0,"Equip",EquipID))  quit:EquipID=""  d
	.s rowid = 0
	.f  s rowid=$o(^DHCEQMaintRequest(0,"Equip",EquipID,rowid))  quit:rowid=""  d
	..d ResetVariablesGetMaint
	..s InvalidFlag=$p($g(^DHCEQMaintRequest(rowid)),"^",47)
	..q:InvalidFlag="Y"
	..s BussStatus=$p($g(^DHCEQMaintRequest(rowid)),"^",29)
	..q:BussStatus'="2"
	..s RequestNo=$p($g(^DHCEQMaintRequest(rowid)),"^",43)
	..s RequestDate=$p($g(^DHCEQMaintRequest(rowid)),"^",13)
	..s RequestDate=##Class(web.DHCEQCommon).TransValueToPage(RequestDate,"date") ;$ZD(RequestDate,3)
	..s MTRowID=$o(^DHCEQMaint(0,"SourceID",3,rowid,EquipID,0))
	..i MTRowID'="" s AuditDate=$p($g(^DHCEQMaint(MTRowID)),"^",19)
	..q:AuditDate=""
	..q:(begindate>AuditDate)||(enddate<AuditDate)
	..s AuditDate=##Class(web.DHCEQCommon).TransValueToPage(AuditDate,"date") ;$ZD(AuditDate,3)
	..s Name = $p($g(^DHCEQEquip(EquipID)),"^",1)
	..s No = $p($g(^DHCEQEquip(EquipID)),"^",71)
	..s RequestLocID=$p($g(^DHCEQMaintRequest(rowid)),"^",2)
	..i RequestLocID '="" d
	...s RequestLocCode = ##class(web.DHCEQCommon).GetTrakNameByID("deptcode",RequestLocID)
	...s RequestLocDesc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",RequestLocID)
	..s UseLocID =$p($g(^DHCEQMaintRequest(rowid)),"^",26)
	..i UseLocID '="" d
	...s UseLocCode = ##class(web.DHCEQCommon).GetTrakNameByID("deptcode",UseLocID)
	...s UseLocDesc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocID)
	..s UserSignID=$p($g(^DHCEQMaintRequest(rowid)),"^",23)
	..i UserSignID'="" s UserSign = ##class(web.DHCEQCommon).GetTrakNameByID("user",UserSignID)
	..s StartDate=$p($g(^DHCEQMaintRequest(rowid)),"^",9)
	..s StartDate=##Class(web.DHCEQCommon).TransValueToPage(StartDate,"date") ;$ZD(StartDate,3)
	..s FaultCaseID =$p($g(^DHCEQMaintRequest(rowid)),"^",3)
	..i FaultCaseID '="" s FaultCase=$p($g(^DHCEQCCode("DHCEQCFaultCase",FaultCaseID)),"^",2)
	..s FaultTypeID = $p($g(^DHCEQMaintRequest(rowid)),"^",15)
	..i FaultTypeID '="" s FaultType=$p($g(^DHCEQCCode("DHCEQCFaultType",FaultTypeID)),"^",2)
	..s MaintFee= $p($g(^DHCEQMaintRequest(rowid)),"^",22)
	..s EndDate=$p($g(^DHCEQMaintRequest(rowid)),"^",11)
	..s EndDate=##Class(web.DHCEQCommon).TransValueToPage(EndDate,"date") ;$ZD(EndDate,3)
	..s AcceptUserID =$p($g(^DHCEQMaintRequest(rowid)),"^",18)
	..i AcceptUserID'="" s AcceptUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",AcceptUserID)
	..s MaintModeID =$p($g(^DHCEQMaintRequest(rowid)),"^",20)
	..i MaintModeID'="" s MaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",MaintModeID)),"^",2)
	..s FaultReasonID =$p($g(^DHCEQMaintRequest(rowid)),"^",5)
	..i FaultReasonID'="" s FaultReason = $p($g(^DHCEQCCode("DHCEQCFaultReason",FaultReasonID)),"^",2)
	..s DealMethodID =$p($g(^DHCEQMaintRequest(rowid)),"^",7)
	..i DealMethodID'="" s DealMethod = $p($g(^DHCEQCCode("DHCEQCDealMethod",DealMethodID)),"^",2)
	..s SettlementDate=EndDate
	..s Remark=$p($g(^DHCEQMaintRequest(rowid)),"^",28)
	..d OutputRowGetMaint
	Quit $$$OK
OutputRowGetMaint
	s Data=$lb(RequestNo,RequestDate,AuditDate,No,Name,RequestLocCode,RequestLocDesc,UseLocCode,UseLocDesc,UserSign,StartDate,FaultCase,MaintFee,EndDate,AcceptUser,FaultType,MaintMode,FaultReason,DealMethod,SettlementDate,Remark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaint
	s (InvalidFlag,BussStatus,RequestNo,RequestDate,AuditDate,No,Name,RequestLocID,RequestLocCode,RequestLocDesc,UseLocID,UseLocCode,UseLocDesc,UserSignID,UserSign,StartDate,FaultCaseID,FaultCase,MaintFee,EndDate,AcceptUserID,AcceptUser,FaultTypeID,FaultType,MaintModeID,MaintMode,FaultReasonID,FaultReason,DealMethodID,DealMethod,SettlementDate,Remark)=""
	quit
}

ClassMethod GetMaintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintExecute ]
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

ClassMethod GetMaintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 设备附件明细查询
/// 参数说明：begindate：2012-01-01
/// 			  enddate：2012-01-01
/// d ##class(%ResultSet).RunQuery("web.DHCEQIIntegration","GetAffix")
Query GetAffix() As %Query(ROWSPEC = "No:%String,Affix:%String,ManuFactory:%String,LeaveFacNo:%String,AddDate:%String,Price:%String,Qty:%String,Unit:%String,TotalFee:%String,Model:%String,Funds:%String,Remark:%String,Provider:%String")
{
}

ClassMethod GetAffixExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid,ApproveType
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s EquipID=0
	f  s EquipID=$o(^DHCEQAffix(0,"Equip",EquipID))  quit:EquipID=""  d
	.s rowid = 0
	.f  s rowid=$o(^DHCEQAffix(0,"Equip",EquipID,rowid))  quit:rowid=""  d
	..d ResetVariablesGetAffix
	..s InvalidFlag=$p($g(^DHCEQAffix(rowid)),"^",15)
	..q:InvalidFlag="Y"
	..s No = $p($g(^DHCEQEquip(EquipID)),"^",71)
	..s Affix=$p($g(^DHCEQAffix(rowid)),"^",4)
	..s Model=$p($g(^DHCEQAffix(rowid)),"^",6)
	..s ManuFactoryID=$p($g(^DHCEQAffix(rowid)),"^",6)
	..i ManuFactoryID '="" s ManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryID)),"^",1)
	..s Qty=$p($g(^DHCEQAffix(rowid)),"^",7)
	..s LeaveFacNo=$p($g(^DHCEQAffix(rowid)),"^",9)
	..s AddDate=""
	..s Price=$p($g(^DHCEQAffix(rowid)),"^",11)
	..s UnitID=$p($g(^DHCEQAffix(rowid)),"^",13)
	..i UnitID '="" s Unit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",(UnitID))	;Modified By jdl 20150906 v4.1.0 规范单位取值
	..s TotalFee=Price*Qty
	..s Funds = ##Class(web.DHCEQFunds).GetFundsInfo(2,rowid)
	..s Remark=$p($g(^DHCEQAffix(rowid)),"^",12)
	..s ProviderID=$p($g(^DHCEQAffix(rowid)),"^",12)
	..i ProviderID ="" s Provider=$p($g(^DHCEQCCode("DHCEQCVendor",ProviderID)),"^",2)
	..d OutputRowGetAffix
	Quit $$$OK
OutputRowGetAffix
	s Data=$lb(No,Affix,ManuFactory,LeaveFacNo,AddDate,Price,Qty,Unit,TotalFee,Model,Funds,Remark,Provider)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAffix
	s (InvalidFlag,No,Affix,ManuFactoryID,ManuFactory,LeaveFacNo,AddDate,Price,Qty,Unit,TotalFee,Model,Funds,Remark,ProviderID,Provider)=""
	quit
}

ClassMethod GetAffixFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAffixExecute ]
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

ClassMethod GetAffixClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAffixExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
