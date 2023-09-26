Class web.DHCEQM.DHCEQMaintForService Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by zx 2015-06-18
/// 根据设备编号获取设备信息
/// w ##class(web.DHCEQMaintForService).GetEquipByEquipNo("322070200025036")
ClassMethod GetEquipByEquipNo(EquipNo)
{
	s (TRowID,TFileNo,TName,TModel,TModelDR,TLeaveFactoryNo,TUseLocDR,TUseLoc,TOriginalFeeTNo,TFileNo,TNo,TEquipTypeDR,TStatCatDR,TStartDate,TManuFactoryDR,TManuFactory)=""
	s EquipNo=$ZCONVERT(EquipNo,"U")
	if EquipNo="" q "-1"
	s rowid=0
	s rowid = $Order(^DHCEQEquip(0,"No",EquipNo,0))
	s TRowID=rowid
	if TRowID="" d
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquip(rowid)) q:rowid=""  d
	..s TFileNo=$p($g(^DHCEQEquip(rowid)),"^",85)
	..q:TFileNo'=EquipNo
	..s TRowID=rowid
	if TRowID=""  q "-2"
	/*
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid)) q:rowid=""  d
	.s TNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	.s TFileNo=$p($g(^DHCEQEquip(rowid)),"^",85)
	.i (TNo=EquipNo)||(TFileNo=EquipNo) s TRowID = rowid
	if TRowID=""  q "-2"*/
	
	s Status = $p($g(^DHCEQEquip(TRowID)),"^",38)
	;;Mozy	2017-11-16	增加设备过滤判断
	q:Status>2 "-2"
	q:$p($g(^DHCEQEquip(TRowID)),"^",59)'="N" "-2"
	s tmpEquiptypedr=","_##class(web.DHCEQCommon).GetSysInfo("990053")_","	;简易设备台账无库房状态,应当过滤
	q:($p($g(^DHCEQEquip(TRowID)),"^",60)'=1)&&(tmpEquiptypedr'[","_$p($g(^DHCEQEquip(TRowID)),"^",63)_",") "-2"
	;q:$p($g(^DHCEQEquip(TRowID)),"^",93)=2 "-2"		;Mozy	2019-2-26	过滤预报废设备
	
	s TName = $p($g(^DHCEQEquip(TRowID)),"^",1)
	s TModelDR = $p($g(^DHCEQEquip(TRowID)),"^",3)
	i TModelDR '=""  d
	.s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TLeaveFactoryNo = $p($g(^DHCEQEquip(TRowID)),"^",10)
	s TUseLocDR = $p($g(^DHCEQEquip(TRowID)),"^",19)
	i TUseLocDR '="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	s TOriginalFee = $p($g(^DHCEQEquip(TRowID)),"^",27)
	s TNo = $p($g(^DHCEQEquip(TRowID)),"^",71)
	s TFileNo=$p($g(^DHCEQEquip(TRowID)),"^",85)
	s TEquipTypeDR=$p($g(^DHCEQEquip(TRowID)),"^",63)
	s TStatCatDR=$p($g(^DHCEQEquip(TRowID)),"^",75)
	s TStartDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(TRowID)),"^",44),"date") ;Add By QW20160805
	s TManuFactoryDR=$p($g(^DHCEQEquip(TRowID)),"^",26)  //add by zx 2016-09-08 获取厂商信息 ZX0036
	i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer", TManuFactoryDR)

    q TRowID_"^"_TName_"^"_TNo_"^"_TModel_"^"_TLeaveFactoryNo_"^"_TUseLoc_"^"_TUseLocDR_"^"_TOriginalFee_"^"_TFileNo_"^"_TEquipTypeDR_"^"_TStatCatDR_"^"_TStartDate_"^"_TManuFactory
}

/// w ##class(web.DHCEQMaintForService).GetMaintRequestInfo(4)
ClassMethod GetMaintRequestInfo(RequestID)
{
	i RequestID="" q:"-1001"
	s RequestNo=""
	s MaintRequestInfo=##class(web.DHCEQM.DHCEQMMaintRequest).GetOneMaintRequest("","",RequestID,"")
	q MaintRequestInfo
}

/// add by zx 2015-06-23
/// 获取基础数据信息
/// w ##class(web.DHCEQM.DHCEQMaintForService).GetMaintBasisData("DHCEQCFaultCase")
ClassMethod GetMaintBasisData(TableName As %String)
{
	i TableName="" q "-1001"
	s (TRowID,TDesc)=""
	s Info=""
	s rowid=0
	f  s rowid=$o(^DHCEQCCode(TableName,rowid)) q:rowid=""  d
	.q:($p($g(^DHCEQCCode(TableName,rowid)),"^",4)'="N")&&(TableName'="DHCEQMCMaintMode")
	.q:($p($g(^DHCEQCCode(TableName,rowid)),"^",5)'="N")&&(TableName="DHCEQMCMaintMode")
	.s TRowID=rowid
	.s TDesc=$p($g(^DHCEQCCode(TableName,rowid)),"^",2)
	.i Info'="" s Info=Info_"&"
	.s Info=Info_TRowID_"-"_TDesc
	
	q Info
}

/// add by zx 2015-06-29
/// w ##Class(web.DHCEQM.DHCEQMaintForService).UpdateAcceptDate("63721", "1")
ClassMethod UpdateAcceptDate(AcceptDate, MaintRequestID)
{
	i AcceptDate="" q "-1001"
	i MaintRequestID="" q "-1002"
	;s AcceptDate=$zdh(AcceptDate,4)
	;日期格式统一调整
	s AcceptDate=##Class(web.DHCEQCommon).TransValueFromPage(AcceptDate,"date")
	&SQL(Update sqluser.DHC_EQMMaintRequest SET MR_AcceptDate=:AcceptDate Where MR_RowID=:MaintRequestID)
	q SQLCODE
}

/// 库房配件查询放大镜
/// Modify by :qw
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMaintForService","GetAStockDetail","","452","1","","false","1")
/// qw0005-2014-06-05 :增加单台批量显示，增加一个标志位
/// modify by:GBX 2014-8-31 15:13:18 GBX0029 增加一个changetype区分退货减少和转移
/// ChangeType:0: 退货和减少
/// 		   1：转移
/// vMXRowID  转移明细或退货明细RowID	//Add By DJ 2014-09-10                  
Query GetAStockDetail(ASDRowID, LocDR, AccessoryTypeDR, Desc, Flag, ChangeType, vMXRowID As %String = "", ProviderDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String,TCode:%String,TLocDR:%String,TLoc:%String,TAccessoryTypeDR:%String,TAccessoryType:%String,TStatus:%String,THasStockFlag:%String,TItemDR:%String,TItem:%String,TAInStockListDR:%String,TBatchNo:%String,TExpiryDate:%String,TBprice:%String,TSerialNo:%String,TNo:%String,TBaseUOMDR:%String,TBaseUOM:%String,TManuFactoryDR:%String,TManuFactory:%String,TModel:%String,TProviderDR:%String,TProvider:%String,TStock:%String,TFreezeStock:%String,TStartDate:%String,TDisuseDate:%String,TStockDR:%String,TInType:%String,TInSourceID:%String,TToType:%String,TToSourceID:%String,TOriginDR:%String,TOrigin:%String,CanUseNum:%String,FreezeNum:%String,TReturnFee:%String,TTotalFee:%String,TInStockNo:%String,TInDate:%String,TBatchFlag:%String")
{
}

ClassMethod GetAStockDetailExecute(ByRef qHandle As %Binary, ASDRowID, LocDR, AccessoryTypeDR, Desc, Flag, ChangeType, vMXRowID As %String = "", ProviderDR As %String = "") As %Status
{
	new repid, index,rowid,TAStockListDR,TStockSum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s TAStockListDR=0
	s TStockSum=0
	S Desc=$ZCONVERT(Desc,"U")
	i LocDR="" q $$$OK
	i AccessoryTypeDR="" q $$$OK
	i Flag="true" s ASDRowID=""		//Add By DJ 2014-09-10	批量时清空库存明细RowID	
	s TSerialFlag=""
	s TAInStockListDR=""
	//^DHCEQMozy("GetAStockDetail") = ",		  131	,	1				,		 , false  ,		1		 ,			  ," 
	;s ^DHCEQMozy("GetAStockDetail")=ASDRowID_","_LocDR_","_AccessoryTypeDR_","_Desc_","_Flag_","_ChangeType_","_vMXRowID_","_ProviderDR
	if ASDRowID'=""
	{
		d ResetVariablesGetAStockDetail
		s rowid=ASDRowID
		d BuildDataGetAStockDetail
	}
	else
	{		
		if Flag="false"
		{	
			s rowid=0
			f  s rowid=$o(^DHCEQAStockDetail(rowid)) q:rowid=""  d
			.d ResetVariablesGetAStockDetail
			.d BuildDataGetAStockDetail
		}
		else
		{
            s TAInStockListDR=0
			f  s TAInStockListDR=$o(^DHCEQAStockDetail(0,"AInStockList",TAInStockListDR)) q:TAInStockListDR=""  d
			.d ResetVariablesGetAStockDetail
			.s (TStock,rowid,TID)=0
			.s FreezeNumSum=0  //GBX 2014-8-28 16:16:56
			.s FirstID=0	//Modify DJ 2014-09-10
			.f  s rowid=$o(^DHCEQAStockDetail(0,"AInStockList",TAInStockListDR,rowid)) q:rowid=""  d
			..;s TBatchNo=$p($g(^DHCEQAStockDetail(rowid)),"^",6)
			..;i TBatchNo'=""  d
			..s TAInStockListDR=$p($g(^DHCEQAStockDetail(rowid)),"^",3) //modify BY GBX 用批号标志做判断
			..s TSerialFlag=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",15)
			..i TSerialFlag'="Y" d		//Modify DJ 2014-09-10
			...d BuildDataGetAStockDetail	//Modify DJ 2014-09-10
			..e  d
			...s TLocDR=$p($g(^DHCEQAStockDetail(rowid)),"^",1)
		    ...q:(LocDR'=TLocDR) 
			...s TStatus=$p($g(^DHCEQAStockDetail(rowid)),"^",12)
		    ...q:(ChangeType=0)&&(TStatus'=0)
		    ...q:(ChangeType=1)&&(TStatus'=0)&&(TStatus'=1)
		    ...s TStockSum=$p($g(^DHCEQAStockDetail(rowid)),"^",17)
		    ...q:(TStockSum=0)
		    ...s TStock=TStock+TStockSum
		    ...s FreezeNum=##class(web.DHCEQAReduce).CheckAccessoryDR(rowid,LocDR,vMXRowID,ChangeType)      ///被占用的数量  //Modify DJ 2014-09-10
		    ...s FreezeNumSum=FreezeNumSum+FreezeNum
			...i ((FirstID=0)&&(FreezeNum=0))  d	//Modify DJ 2014-09-10
			....s TID=rowid
			....s FirstID=1
			.s TNo=""
			.s TSerialNo=""
			.s rowid=TID
			.q:($p($g(^DHCEQAStockDetail(rowid)),"^",10)="")		//Modify DJ 2014-09-10
			.;s TSerialNo=$e($p($g(^DHCEQAStockDetail(rowid)),"^",9),0,1) //qw0006-2014-08-21
			.d BuildDataGetAStockDetail
		}
	}
	
	Quit $$$OK
	
BuildDataGetAStockDetail
		s TRowID=rowid
		s TLocDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",1)
		q:(LocDR'=TLocDR)
		s TAccessoryTypeDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",11)
		q:(AccessoryTypeDR'="")&&(AccessoryTypeDR'=TAccessoryTypeDR)
		s TCode=$p($g(^DHCEQAStockDetail(TRowID)),"^",4)
		s TDesc=$p($g(^DHCEQAStockDetail(TRowID)),"^",5)
		q:(Desc'="")&&(TCode'[Desc)&&(TDesc'[Desc)
		s TStatus=$p($g(^DHCEQAStockDetail(TRowID)),"^",12)
		q:(ChangeType=0)&&(TStatus'=0)
		q:(ChangeType=1)&&(TStatus'=0)&&(TStatus'=1)
		s THasStockFlag=$p($g(^DHCEQAStockDetail(TRowID)),"^",26)
		q:(THasStockFlag="N")
		s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
		s TAccessoryType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TAccessoryTypeDR)),"^",2)
		s TItemDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",2)
		s TItem=$p($g(^DHCEQCCode("DHCEQCAccessory",TItemDR)),"^",2)
		s TAInStockListDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",3)
		//add By GBX 2014-8-27 15:42:08
		i TAInStockListDR'="" d
		.s TAInStockDR=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",1)
		.s TBatchFlag=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",16)	//Modify DJ 2014-09-10
		.i (Flag="false")&($p($g(^DHCEQAInStockList(TAInStockListDR)),"^",15)="Y")  d  //modify BY：GBX 2014-8-29 11:07:13批量标志
		..s TSerialNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",9)
		..s TNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",10)
		.i TAInStockDR'="" d
		..s TInStockNo=$p($g(^DHCEQAInStock(TAInStockDR)),"^",6)  //入库单号
		..s TInDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStock(TAInStockDR)),"^",1),"date") //入库日期
		s TBatchNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",6)
		s TExpiryDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAStockDetail(TRowID)),"^",7),"date")
		s TBprice=$p($g(^DHCEQAStockDetail(TRowID)),"^",8)
		s TBaseUOMDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",13)
		i TBaseUOMDR'="" s TBaseUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TBaseUOMDR)
		s TManuFactoryDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",14)
		i TManuFactoryDR '="" s TManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
		s TModel=$p($g(^DHCEQAStockDetail(TRowID)),"^",15)
		s TProviderDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",16)
		q:((ProviderDR'="")&&(TProviderDR'=ProviderDR))		//Add By DJ 2014-09-11
		i TProviderDR'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
		
		i TSerialFlag="Y"  d
		.s FreezeNum=FreezeNumSum
		e  d
		.s TStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",17) //modify by GBX:2014-8-27 16:45:15
		.s FreezeNum=##class(web.DHCEQAReduce).CheckAccessoryDR(TRowID,LocDR,vMXRowID,ChangeType)      ///被占用的数量	//Modify DJ 2014-09-10
		/*
		i ((Flag="false")||(TBatchNo'="")) d
		.s TSerialNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",9)
		.s TNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",10)
		.s TStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",17)
		else  d
		.i TStock=""  d
		..s TStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",17) //modify by GBX:2014-8-27 16:45:15
		*/
		q:(TStock=0)           //Modify GBX 2014-4-10 11:50:22
		
		;s FreezeNum=##class(web.DHCEQAReduce).CheckAccessoryDR(TRowID,LocDR)      ///被占用的数量
		s CanUseNum=TStock-FreezeNum                 ///可退数量 
		q:CanUseNum<1 
		
		s TFreezeStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",18)
		s TStartDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAStockDetail(TRowID)),"^",19),"date")
		s TDisuseDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAStockDetail(TRowID)),"^",20),"date")
		s TStockDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",21)
		s TInType=$p($g(^DHCEQAStockDetail(TRowID)),"^",22)
		s TInSourceID=$p($g(^DHCEQAStockDetail(TRowID)),"^",23)
		s TToType=$p($g(^DHCEQAStockDetail(TRowID)),"^",24)
		s TToSourceID=$p($g(^DHCEQAStockDetail(TRowID)),"^",25)
		s THasStockFlag=$p($g(^DHCEQAStockDetail(TRowID)),"^",26)
		s TOriginDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",27)
		i TOriginDR'="" s TOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
		;s StockQtyNum=$p($g(^DHCEQAStockDetail(TRowID)),"^",17)
		
		s TReturnFee=##class(web.DHCEQAReduce).GetAccessoryById("Fee",TRowID)
		s TTotalFee=CanUseNum*TReturnFee
		d OutputRowGetAStockDetail

	quit
OutputRowGetAStockDetail
	s Data=$lb(TRowID,TDesc,TCode,TLocDR,TLoc,TAccessoryTypeDR,TAccessoryType,TStatus,THasStockFlag,TItemDR,TItem,TAInStockListDR,TBatchNo,TExpiryDate,TBprice,TSerialNo,TNo,TBaseUOMDR,TBaseUOM,TManuFactoryDR,TManuFactory,TModel,TProviderDR,TProvider,TStock,TFreezeStock,TStartDate,TDisuseDate,TStockDR,TInType,TInSourceID,TToType,TToSourceID,TOriginDR,TOrigin,CanUseNum,FreezeNum,TReturnFee,TTotalFee,TInStockNo,TInDate,TBatchFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAStockDetail
	s (TRowID,TDesc,TCode,TLocDR,TLoc,TAccessoryTypeDR,TAccessoryType,TStatus,THasStockFlag,TItemDR,TItem,TBatchNo,TExpiryDate,TBprice,TSerialNo,TNo,TBaseUOMDR,TBaseUOM,TManuFactoryDR,TManuFactory,TModel,TProviderDR,TProvider,TStock,TFreezeStock,TStartDate,TDisuseDate,TStockDR,TInType,TInSourceID,TToType,TToSourceID,TOriginDR,TOrigin,FreezeNum,CanUseNum,TReturnFee,TTotalFee,TAInStockDR,TInStockNo,TInDate,TBatchFlag)=""
	quit
}

ClassMethod GetAStockDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAStockDetailExecute ]
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

ClassMethod GetAStockDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAStockDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By ZX 2015-07-20
/// 描述:工程师月工作量统计
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMaintForService","MaintEngineerWorkNum","1","2015-06","2015-07")
Query MaintEngineerWorkNum(EngineerDR As %String = "", StartMonth As %String = "", EndMonth As %String = "") As %Query(ROWSPEC = "Month:%String, WorkNum:%String") [ SqlProc ]
{
}

ClassMethod MaintEngineerWorkNumExecute(ByRef qHandle As %Binary, EngineerDR As %String = "", StartMonth As %String = "", EndMonth As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (StartMonth="")||(EndMonth="") Quit $$$OK
	i ($ZDH(StartMonth_"-01",3)>$ZDH(EndMonth_"-01",3)) Quit $$$OK
	s vstartYear=+$p(StartMonth,"-",1)
	s vstartMonth=+$p(StartMonth,"-",2)
	s vendYear=+$p(EndMonth,"-",1)
	s vendMonth=+$p(EndMonth,"-",2)
	s MonthNum=(vendYear*12+vendMonth)-(vstartYear*12+vstartMonth)
	for monthnum=0:1:MonthNum d
	.s WorkNum=0
	.s Month=##Class(web.DHCEQCommon).MonthStrAdd("M",monthnum,StartMonth)
	.s BeginDate=##Class(web.DHCEQReport).GetReportDate(Month,"1","")
	.s EndDate=##Class(web.DHCEQReport).GetReportDate(Month,"2","")
	.s rowid=0
	.f  s rowid=$o(^DHCEQMMaintRequest(rowid)) q:rowid=""  d
	..s TInvalidFlag=$p($g(^DHCEQMMaintRequest(rowid)),"^",57)
	..q:TInvalidFlag'="N"
	..;begin add by jyp 2020-03-12 JYP0023
	..s TStatus=$p($g(^DHCEQMMaintRequest(rowid)),"^",41)
	..q:TStatus=3
	..;end add by jyp 2020-03-12 JYP0023
	..s TAcceptUserDR=$p($g(^DHCEQMMaintRequest(rowid)),"^",26)
	..q:(EngineerDR'="")&&(EngineerDR'=TAcceptUserDR)
	..s TAuditDate=$p($g(^DHCEQMMaintRequest(rowid)),"^",52)
	..q:(TAuditDate<BeginDate)||(TAuditDate>EndDate)
	..s WorkNum=WorkNum+1
	.d OutputRowGetMaintEngineerWorkNum

	Quit $$$OK
OutputRowGetMaintEngineerWorkNum

	s Data=$lb(Month,WorkNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintEngineerWorkNum
	s (Month,BeginDate,EndDate,TInvalidFlag,TAcceptUserDR,TAuditDate)=""
	quit
}

ClassMethod MaintEngineerWorkNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintEngineerWorkNumExecute ]
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

ClassMethod MaintEngineerWorkNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintEngineerWorkNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by zx 2015-06-18
/// 根据编号获取设备ID
ClassMethod GetEquipIDByNoNew(EquipNo)
{
	n rowid, TRowID, TFileNo
	s (rowid, TRowID, TFileNo)=""
	s EquipNo=$ZCONVERT(EquipNo,"U")
	if EquipNo="" q "-1"
	s rowid=0
	s rowid = $Order(^DHCEQEquip(0,"No",EquipNo,0))
	s TRowID=rowid
	if TRowID="" d
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquip(rowid)) q:rowid=""  d
	..s TFileNo=$p($g(^DHCEQEquip(rowid)),"^",85)
	..q:TFileNo'=EquipNo
	..s TRowID=rowid
	if TRowID=""  q "-2"
	
	q TRowID
}

/// add by zx 2017-01-10 ZX0036
/// 微信端轮播通知信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMaintForService","WeChatNotice")
Query WeChatNotice(UserID As %String = "") As %Query(ROWSPEC = "TTitle:%String,TContent:%String,TPictureURL:%String,TContentURL:%String")
{
}

ClassMethod WeChatNoticeExecute(ByRef qHandle As %Binary, UserID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Date=+$h
	s rowid=0
	f  s rowid=$o(^DHCEQNotice(rowid)) q:rowid=""  d
	.d ResetWeChatNotice
	.s TStartDate=$p($g(^DHCEQNotice(rowid)),"^",6)
	.q:(TStartDate'="")&&(Date<TStartDate)
	.s TEndDate=$p($g(^DHCEQNotice(rowid)),"^",8)
	.q:(TEndDate'="")&&(Date>TEndDate)
	.s TTitle=$p($g(^DHCEQNotice(rowid)),"^",1)
	.s TContent=$p($g(^DHCEQNotice(rowid)),"^",2)
	.s TPictureURL=$p($g(^DHCEQNotice(rowid)),"^",3)
	.s TContentURL=$p($g(^DHCEQNotice(rowid)),"^",4)
	.d OutputRowWeChatNotice

	Quit $$$OK
OutputRowWeChatNotice

	s Data=$lb(TTitle,TContent,TPictureURL,TContentURL)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetWeChatNotice
	s (TStartDate,TEndDate,TTitle,TContent,TPictureURL,TContentURL)=""
	quit
}

ClassMethod WeChatNoticeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WeChatNoticeExecute ]
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

ClassMethod WeChatNoticeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WeChatNoticeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod AutoSaveBaseCodeByTable(TableName, Desc, Type)
{
	n ctrowid
	i TableName="" q -1
	k CPlist
	s ctrowid=""
	s code=##class(web.DHCEQCHanZiEncoding).GetEncoding(Desc,4,"","U")
	s CPlist(2)=code
	s CPlist(3)=Desc
	s CPlist(5)="N"
	i TableName="FaultType"
	{
		&SQL(Select FT_RowID Into :ctrowid from SQLUSER.DHC_EQMCFaultType Where FT_Desc=:Desc and FT_InvalidFlag<>'Y')
		i ctrowid=""
		{
			
			&sql(Insert Into SQLUser.DHC_EQMCFaultType Values :CPlist())
			s ctrowid=$Get(%ROWID) 
		}
	}
	i TableName="FaultCase"
	{
		&SQL(Select FC_RowID Into :ctrowid from SQLUSER.DHC_EQMCFaultCase Where FC_Desc=:Desc and FC_InvalidFlag<>'Y')
		i ctrowid=""
		{
			&sql(Insert Into SQLUser.DHC_EQMCFaultCase Values :CPlist())
			s ctrowid=$Get(%ROWID) 
		}
	}
	i TableName="FaultReason"
	{
		&SQL(Select FR_RowID Into :ctrowid from SQLUSER.DHC_EQMCFaultReason Where FR_Desc=:Desc and FR_InvalidFlag<>'Y')
		i ctrowid=""
		{
			&sql(Insert Into SQLUser.DHC_EQMCFaultReason Values :CPlist())
			s ctrowid=$Get(%ROWID) 
		}
	}
	i TableName="DealMethod"
	{
		&SQL(Select DM_RowID Into :ctrowid from SQLUSER.DHC_EQMCDealMethod Where DM_Desc=:Desc and DM_InvalidFlag<>'Y')
		i ctrowid=""
		{
			&sql(Insert Into SQLUser.DHC_EQMCDealMethod Values :CPlist())
			s ctrowid=$Get(%ROWID) 
		}
	}
	i TableName="MaintResults"
	{
		&SQL(Select MR_RowID Into :ctrowid from SQLUSER.DHC_EQMCMaintResults Where MR_Desc=:Desc and MR_InvalidFlag<>'Y')
		i ctrowid=""
		{
			&sql(Insert Into SQLUser.DHC_EQMCMaintResults Values :CPlist())
			s ctrowid=$Get(%ROWID) 
		}
	}
	i TableName="MaintProcess"
	{
		&SQL(Select MP_RowID Into :ctrowid from SQLUSER.DHC_EQMCMaintProcess Where MP_Desc=:Desc and MP_InvalidFlag<>'Y')
		i ctrowid=""
		{
			&sql(Insert Into SQLUser.DHC_EQMCMaintProcess Values :CPlist())
			s ctrowid=$Get(%ROWID) 
		}
	}
	i TableName="Service"
	{
		s ctrowid=##Class(web.DHCEQCService).UpdService(code_"^"_Desc)
	}
	q ctrowid
}

}
