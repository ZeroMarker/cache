Class web.DHCEQCLRunQian Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQCLRunQian","InUsedReport","2014-12","","","","90","410")
Query InUsedReport(MonthStr As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TUseLoc:%String,TOriginalFee:%String,TQuantityNum:%String,TUseBegin:%String,TMoveIn:%String,TMovetoAdd:%String,TMovetoReduce:%String,TMoveOut:%String,TChangeFeeAdd:%String,TChangeFeeReduce:%String,TAdjustAddto:%String,TAdjustReduce:%String,TAdjustAdd:%String,TAdjustDelete:%String,TAdjustCancle:%String,TDisused:%String,TUseEnd:%String") [ SqlProc ]
{
}

ClassMethod InUsedReportExecute(ByRef qHandle As %Binary, MonthStr As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Status
{
	new repid,index,rowid,vendorid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	
 	n PerMonth,BeginDate,EndDate,TEquipTypeDR
 	i EquipType="" s EquipTypeDR=""
 	i MonthStr="" Quit $$$OK
 	s PerMonth=##class(web.DHCEQReport).GetPreMonth(MonthStr)
 	s BeginDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"1","")
	s EndDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"2","")
	
 	//上期结存
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(PerMonth)
 	s RowID=0
 	i SnapID=""  d
 	.f  s RowID=$o(^DHCEQEquip(RowID))  q:RowID=""  d
 	..d ResetVariablesGetSnapEquip
 	..q:$Piece($Get(^DHCEQEquip(RowID,"OtherInfo")),"^",26)'=""	// Mozy0242	2020-01-02	1156260		过滤附属设备
 	..s InvalidFlag=$p($g(^DHCEQEquip(RowID)),"^",59)
 	..q:InvalidFlag="Y"
 	..s EQStoreLocDR=$p($g(^DHCEQEquip(RowID)),"^",67)	//设备库房
 	..s EQEquipTypeDR=$p($g(^DHCEQEquip(RowID)),"^",63)	
 	..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EQEquipTypeDR,CurGroupID))
 	..s EQStatus=$p($g(^DHCEQEquip(RowID)),"^",38)
 	..q:EQStatus'=1
 	..s EQStartDate=$p($g(^DHCEQEquip(RowID)),"^",44)
 	..q:EQStartDate>BeginDate
 	..s TRowID=RowID
 	..s TUseLocDR=$p($g(^DHCEQEquip(RowID)),"^",19)	//使用科室
 	..q:TUseLocDR=""
 	..s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
 	..s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(RowID)),"^",27),"",2) //设备原值
 	..s TNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(RowID)),"^",28),"",2)		//净值
	..s TQuantityNum="1"
	..s TUseBegin=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee,"",2)
	..d OutputRowGetSnapEquip
 	e  d
 	.f  s RowID=$o(^DHCEQSnapShot(SnapID,"Equip",RowID))  q:RowID=""  d
 	..d ResetVariablesGetSnapEquip
 	..q:$Piece($Get(^DHCEQEquip(RowID,"OtherInfo")),"^",26)'=""	// Mozy0242	2020-01-02	1156260		过滤附属设备
 	..s InvalidFlag=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",59)
 	..q:InvalidFlag="Y"
 	..s EQStoreLocDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",67)	//设备库房
 	..s EQEquipTypeDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",63)	
 	..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EQEquipTypeDR,CurGroupID))
 	..s EQOriginalFee=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",27)	//设备原值
 	..s EQStatus=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",38)
	..q:EQStatus'=1
 	..s TRowID=RowID
 	..s TUseLocDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",19)	//使用科室
 	..q:TUseLocDR="" 
 	..s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
 	..s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",27),"",2) //设备原值
	..s TQuantityNum="1"
	..s TUseBegin=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee,"",2)
	..d OutputRowGetSnapEquip
	
	//本期转移
	s StockDate=BeginDate-1
 	f  s StockDate=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s StatCatDR=""
 	.f  s StatCatDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR)) q:StatCatDR=""  d
 	..s MoveTypeDR=""
 	..f  s MoveTypeDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR,MoveTypeDR))  q:MoveTypeDR=""  d
 	...s SMRowID=0
 	...f  s SMRowID=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR,MoveTypeDR,SMRowID)) q:SMRowID=""  d
 	....s EquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
 	....q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,CurGroupID))
 	....s ActDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
	....s MoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)
	....i MoveType=0  d     //本期出库
	.....d ResetVariablesGetSnapEquip
	.....s TToLoc=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
 	.....;i TToLoc'="" s TToLoc=##Class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^CTLOC(TToLoc)),"^",2),"-")   //modify by jyp 2019-10-18 CTLOC调整
 	.....i TToLoc'="" s TToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLoc)    //modify by jyp 2019-10-18 CTLOC调整
 	.....s SMLRowID=0
 	.....f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
 	......s TRowID=SMLRowID
 	......q:$p($g(^DHCEQStoreMoveList(TRowID)),"^",15)'=""		// Mozy0242	2020-01-02	1156260		过滤附属设备
 	......s TUseLoc=TToLoc
 	......s TQuantity=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
 	......s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
 	......s TMoveIn=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
 	......d OutputRowGetSnapEquip
 	....i MoveType=1  d     //科室调配
 	.....s TToLoc=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
 	.....s TFromLoc=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)
 	.....i TToLoc'=""  d
 	......d ResetVariablesGetSnapEquip
 	......;s TToLoc=##Class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^CTLOC(TToLoc)),"^",2),"-")    //modify by jyp 2019-10-18 CTLOC调整
 	......s TToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLoc)    //modify by jyp 2019-10-18 CTLOC调整
 	......s SMLRowID=0
 	......f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
 	.......s TRowID=SMLRowID
 	.......q:$p($g(^DHCEQStoreMoveList(TRowID)),"^",15)'=""		// Mozy0242	2020-01-02	1156260		过滤附属设备
 	.......s TUseLoc=TToLoc
 	.......s TQuantity=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
 	.......s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
 	.......s TMovetoAdd=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)     //科室调配增加
 	.......d OutputRowGetSnapEquip
 	.....i TFromLoc'=""  d
 	......d ResetVariablesGetSnapEquip
 	......;s TFromLoc=##Class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^CTLOC(TFromLoc)),"^",2),"-")    //modify by jyp 2019-10-18 CTLOC调整
 	......s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLoc)    //modify by jyp 2019-10-18 CTLOC调整
 	......s SMLRowID=0
 	......f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
 	.......s TRowID=SMLRowID
 	.......q:$p($g(^DHCEQStoreMoveList(TRowID)),"^",15)'=""		// Mozy0242	2020-01-02	1156260		过滤附属设备
 	.......s TUseLoc=TFromLoc
 	.......s TQuantity=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
 	.......s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
 	.......s TMovetoReduce=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)     //科室调配减少
 	.......d OutputRowGetSnapEquip
	....i MoveType=3  d     //科室退库
	.....d ResetVariablesGetSnapEquip
 	.....s TFromLoc=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)
 	.....q:TFromLoc=""
 	.....;s TFromLoc=##Class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^CTLOC(TFromLoc)),"^",2),"-")    //modify by jyp 2019-10-18 CTLOC调整
	.....s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLoc)    //modify by jyp 2019-10-18 CTLOC调整
	.....s SMLRowID=0
 	.....f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
 	......s TRowID=SMLRowID
 	......q:$p($g(^DHCEQStoreMoveList(TRowID)),"^",15)'=""		// Mozy0242	2020-01-02	1156260		过滤附属设备
 	......s TUseLoc=TFromLoc
 	......s TQuantity=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
 	......s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
 	......s TMoveOut=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
 	......d OutputRowGetSnapEquip
 
 	//本期调账
 	s TEquipTypeDR=""
 	f  s TEquipTypeDR=$o(^DHCEQChangeAccount(0,"TypeDate",TEquipTypeDR)) q:TEquipTypeDR=""  d
 	.;q:(EquipTypeIDS'="")&&(EquipTypeIDS'[("^"_EquipTypeDR_"^"))
 	.s CAuditDate=BeginDate-1
 	.f  s CAuditDate=$o(^DHCEQChangeAccount(0,"TypeDate",TEquipTypeDR,CAuditDate)) q:((CAuditDate="")||(CAuditDate>EndDate))  d
 	..s CRowID=0
 	..f  s CRowID=$o(^DHCEQChangeAccount(0,"TypeDate",TEquipTypeDR,CAuditDate,CRowID)) q:CRowID=""  d
 	...s Status=$p($g(^DHCEQChangeAccount(CRowID)),"^",11)
 	...q:Status'=2
 	...s EquipTypeDR=$p($g(^DHCEQChangeAccount(CRowID)),"^",30)
 	...q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,CurGroupID))
 	...s TChangeFee=$p($g(^DHCEQChangeAccount(CRowID)),"^",2)  //调整值	
 	...i TChangeFee>0 d
 	....d ResetVariablesGetSnapEquip
 	....s TRowID=CRowID
 	....s TUseLocDR=$p($g(^DHCEQChangeAccount(CRowID)),"^",29)	//使用科室
 	....q:TUseLocDR=""
 	....s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
 	....s TChangeFeeAdd=TChangeFee //增值调账	
 	....d OutputRowGetSnapEquip
 	...e  d
 	....d ResetVariablesGetSnapEquip
 	....s TRowID=CRowID
 	....s TUseLocDR=$p($g(^DHCEQChangeAccount(CRowID)),"^",29)	//使用科室
 	....q:TUseLocDR=""
 	....s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
 	....s TChangeFeeReduce=-TChangeFee	//减值调账
 	....d OutputRowGetSnapEquip
 	
 	//本期报废     modify by mwz 2017-08-11 需求号:369678
 	s DisDate=BeginDate-1
 	f  s DisDate=$o(^DHCEQEquip(0,"DisuseDate",DisDate)) q:((DisDate="")||(DisDate>EndDate))  d
 	.s StoreLocDR=""
	.f  s StoreLocDR=$o(^DHCEQEquip(0,"DisuseDate",DisDate,StoreLocDR)) q:StoreLocDR=""  d
	..s DisRowID=0
 	..f  s DisRowID=$o(^DHCEQEquip(0,"DisuseDate",DisDate,StoreLocDR,DisRowID))  q:DisRowID=""  d
 	...d ResetVariablesGetSnapEquip
 	...q:$Piece($Get(^DHCEQEquip(DisRowID,"OtherInfo")),"^",26)'=""		// Mozy0242	2020-01-02	1156260		过滤附属设备
 	...s InvalidFlag=$p($g(^DHCEQEquip(DisRowID)),"^",59)
 	...q:InvalidFlag="Y"
 	...s EQStoreLocDR=$p($g(^DHCEQEquip(DisRowID)),"^",67)	//设备库房
 	...q:EQStoreLocDR=""
 	...s EQEquipTypeDR=$p($g(^DHCEQEquip(DisRowID)),"^",63)	
 	...q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EQEquipTypeDR,CurGroupID))
 	...s Status=$p($g(^DHCEQEquip(DisRowID)),"^",38)
 	...q:Status'=3
 	...s TRowID=DisRowID
 	...s TUseLocDR=$p($g(^DHCEQEquip(DisRowID)),"^",19)	//使用科室
 	...q:TUseLocDR=""
 	...s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
 	...s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(DisRowID)),"^",27),"",2) 
	...s TQuantityNum="1"
	...s TDisused=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee,"",2)
 	...d OutputRowGetSnapEquip
 	
 	
 	//本期调整
 	s ADType=""
 	f  s ADType=$o(^DHCEQAdjustData(0,"TypeDate",ADType))  q:ADType=""  d
 	.s ADDate=BeginDate-1
 	.f  s ADDate=$o(^DHCEQAdjustData(0,"TypeDate",ADType,ADDate)) q:((ADDate="")||(ADDate>EndDate))  d
 	..s ARowID=0
 	..f  s ARowID=$o(^DHCEQAdjustData(0,"TypeDate",ADType,ADDate,ARowID)) q:(ARowID="")  d
 	...s ADReportFlag=$p($g(^DHCEQAdjustData(ARowID)),"^",2)
 	...q:ADReportFlag'="Y"
 	...s ADStatus=$p($g(^DHCEQAdjustData(ARowID)),"^",11)
 	...q:ADStatus'=1
 	...s ADType=$p($g(^DHCEQAdjustData(ARowID)),"^",1)
 	...i ADType=1  d    //调整数据
 	....s ADLRowID=0
 	....f  s ADLRowID=$o(^DHCEQAdjustDataList(0,"AdjustData",ARowID,ADLRowID)) q:(ADLRowID="")  d
 	.....s EquipID=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",2)
	.....q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0242	2020-01-02	1156260		过滤附属设备
 	.....s TFromLocDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",3)
 	.....s TToLocDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",8)
 	.....i TToLocDR'=""  d
 	......d ResetVariablesGetSnapEquip
 	......s TToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
 	......s TRowID=ADLRowID
 	......s TUseLoc=TToLoc
 	......s ToEquipTypeDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",9)
 	......q:(##Class(web.DHCEQCommon).EquipTypeIsIn(ToEquipTypeDR,CurGroupID))
 	......s TOriginalFee=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",14)
	......s TQuantityNum="1"
	......s TAdjustAddto=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee,"",2)
 	......d OutputRowGetSnapEquip   //调整增加
 	.....i TFromLocDR'=""  d
 	......d ResetVariablesGetSnapEquip
 	......s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
 	......s TRowID=ADLRowID
 	......s TUseLoc=TFromLoc
 	......s FromEquipTypeDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",4)
 	......q:(##Class(web.DHCEQCommon).EquipTypeIsIn(FromEquipTypeDR,CurGroupID))
 	......s TOriginalFee=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",14)
	......s TQuantityNum="1"
	......s TAdjustReduce=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee,"",2)
    ......d OutputRowGetSnapEquip  //调整减少
    ...i ADType=2 d     //新增数据
 	....s ADLRowID=0
 	....f  s ADLRowID=$o(^DHCEQAdjustDataList(0,"AdjustData",ARowID,ADLRowID)) q:(ADLRowID="")  d
 	.....d ResetVariablesGetSnapEquip
 	.....s TRowID=ADLRowID
 	.....s EquipID=$p($g(^DHCEQAdjustDataList(TRowID)),"^",2)
	.....q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0242	2020-01-02	1156260		过滤附属设备
 	.....s TToLocDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",8)
 	.....q:TToLocDR=""
 	.....s TToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
 	.....s TUseLoc=TToLoc
 	.....s ToEquipTypeDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",9)
 	.....q:(##Class(web.DHCEQCommon).EquipTypeIsIn(ToEquipTypeDR,CurGroupID))
 	.....s TOriginalFee=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",14)
	.....s TQuantityNum="1"
	.....s TAdjustAdd=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee,"",2)
 	.....d OutputRowGetSnapEquip 
 	...i ADType=3 d     //删除数据
 	....s ADLRowID=0
 	....f  s ADLRowID=$o(^DHCEQAdjustDataList(0,"AdjustData",ARowID,ADLRowID)) q:(ADLRowID="")  d
 	.....d ResetVariablesGetSnapEquip
 	.....s TRowID=ADLRowID
 	.....s EquipID=$p($g(^DHCEQAdjustDataList(TRowID)),"^",2)
	.....q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0242	2020-01-02	1156260		过滤附属设备
 	.....s TFromLocDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",3)
 	.....q:TFromLocDR=""
 	.....s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
 	.....s TUseLoc=TFromLoc
 	.....s FromEquipTypeDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",4)
 	.....q:(##Class(web.DHCEQCommon).EquipTypeIsIn(FromEquipTypeDR,CurGroupID))
 	.....s TOriginalFee=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",14)
	.....s TQuantityNum="1"
	.....s TAdjustDelete=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee,"",2)
 	.....d OutputRowGetSnapEquip   
 	...i ADType=4 d     //取消报废
 	....s ADLRowID=0
 	....f  s ADLRowID=$o(^DHCEQAdjustDataList(0,"AdjustData",ARowID,ADLRowID)) q:(ADLRowID="")  d
 	.....d ResetVariablesGetSnapEquip
 	.....s TRowID=ADLRowID
 	.....s EquipID=$p($g(^DHCEQAdjustDataList(TRowID)),"^",2)
	.....q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0242	2020-01-02	1156260		过滤附属设备
 	.....s TFromLocDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",3)
 	.....q:TFromLocDR=""
 	.....s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
 	.....s TUseLoc=TFromLoc
 	.....s FromEquipTypeDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",4)
 	.....q:(##Class(web.DHCEQCommon).EquipTypeIsIn(FromEquipTypeDR,CurGroupID))
 	.....s TOriginalFee=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",14)
	.....s TQuantityNum="1"
	.....s TAdjustCancle=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee,"",2)
 	.....d OutputRowGetSnapEquip 
 	
 	//本期结存
 	s snapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
 	s rRowID=0
 	i snapID=""  d
 	.f  s rRowID=$o(^DHCEQEquip(rRowID))  q:rRowID=""  d
 	..d ResetVariablesGetSnapEquip
 	..q:$Piece($Get(^DHCEQEquip(rRowID,"OtherInfo")),"^",26)'=""	// Mozy0242	2020-01-02	1156260		过滤附属设备
 	..s InvalidFlag=$p($g(^DHCEQEquip(rRowID)),"^",59)
 	..q:InvalidFlag="Y"
 	..s EQStoreLocDR=$p($g(^DHCEQEquip(rRowID)),"^",67)	//设备库房
 	..s EQEquipTypeDR=$p($g(^DHCEQEquip(rRowID)),"^",63)	//设备类组
 	..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EQEquipTypeDR,CurGroupID))
 	..s EQStatus=$p($g(^DHCEQEquip(rRowID)),"^",38)
 	..q:EQStatus'=1
 	..s TRowID=rRowID
 	..s TUseLocDR=$p($g(^DHCEQEquip(rRowID)),"^",19)	//使用科室
 	..q:TUseLocDR=""
 	..s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
 	..s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(rRowID)),"^",27),"",2) //设备原值
 	..s TNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(rRowID)),"^",28),"",2)		//净值
	..s TQuantityNum="1"
	..s TUseEnd=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee,"",2)
	..d OutputRowGetSnapEquip
 	e  d
 	.f  s rRowID=$o(^DHCEQSnapShot(snapID,"Equip",rRowID))  q:rRowID=""  d
 	..d ResetVariablesGetSnapEquip
 	..q:$Piece($Get(^DHCEQEquip(rRowID,"OtherInfo")),"^",26)'=""	// Mozy0242	2020-01-02	1156260		过滤附属设备
 	..s InvalidFlag=$p($g(^DHCEQSnapShot(snapID,"Equip",rRowID)),"^",59)
 	..q:InvalidFlag="Y"
 	..s EQStoreLocDR=$p($g(^DHCEQSnapShot(snapID,"Equip",rRowID)),"^",67)	//设备库房
 	..q:EQStoreLocDR=""
 	..s EQEquipTypeDR=$p($g(^DHCEQSnapShot(snapID,"Equip",rRowID)),"^",63)	//设备类组
 	..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EQEquipTypeDR,CurGroupID))
 	..s EQOriginalFee=$p($g(^DHCEQSnapShot(snapID,"Equip",rRowID)),"^",27)	//设备原值
 	..s EQStatus=$p($g(^DHCEQSnapShot(snapID,"Equip",rRowID)),"^",38)
	..q:EQStatus'=1
 	..s TRowID=rRowID
 	..s TUseLocDR=$p($g(^DHCEQSnapShot(snapID,"Equip",rRowID)),"^",19)	//使用科室
 	..q:TUseLocDR=""
 	..s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
 	..s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSnapShot(snapID,"Equip",rRowID)),"^",27),"",2) //设备原值
	..s TQuantityNum="1"
	..s TUseEnd=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee,"",2)
 	..d OutputRowGetSnapEquip
 	
	Quit $$$OK
OutputRowGetSnapEquip
	s Data=$lb(TRowID,TUseLoc,TOriginalFee,TQuantityNum,TUseBegin,TMoveIn,TMovetoAdd,TMovetoReduce,TMoveOut,TChangeFeeAdd,TChangeFeeReduce,TAdjustAddto,TAdjustReduce,TAdjustAdd,TAdjustDelete,TAdjustCancle,TDisused,TUseEnd)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetSnapEquip
	s (TRowID,TUseLoc,TOriginalFee,TQuantityNum,TUseBegin,TMoveIn,TMovetoAdd,TMovetoReduce,TMoveOut,TChangeFeeAdd,TChangeFeeReduce,TAdjustAddto,TAdjustReduce,TAdjustAdd,TAdjustDelete,TAdjustCancle,TDisused,TUseEnd)=""
	quit
}

ClassMethod InUsedReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InUsedReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod InUsedReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InUsedReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCLRunQian","InStockDetail","2014-11","","","2","90","410")
Query InStockDetail(MonthStr As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", EquipTypeIDs As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipName:%String,TModel:%String,TUnit:%String,TProvider:%String,TOriginalFee:%String,TQuantity:%String,TAmount:%String,TInStockNo:%String,TInvoiceNo:%String,TEquipType:%String,TInStockDate:%String,TRemark:%String") [ SqlProc ]
{
}

ClassMethod InStockDetailExecute(ByRef qHandle As %Binary, MonthStr As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", EquipTypeIDs As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
	i EquipType="" s EquipTypeDR=""
 	i MonthStr="" Quit $$$OK
 	s BeginDate=$ZDH(MonthStr_"-01",3)-1
	s EndDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"2","")
	i EquipTypeIDs'="" s EquipTypeIDs=","_EquipTypeIDs_","
	
	//入库
 	s StockDate=BeginDate
 	f  s StockDate=$o(^DHCEQInStock(0,"BillDate",StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s StatCatDR=""
 	.f  s StatCatDR=$o(^DHCEQInStock(0,"BillDate",StockDate,StatCatDR)) q:StatCatDR=""  d
 	..s ISRowID=0		//入库单rowID
 	..f  s ISRowID=$o(^DHCEQInStock(0,"BillDate",StockDate,StatCatDR,ISRowID)) q:ISRowID=""  d
 	...d ResetVariablesGetInStockDetail
 	...s vendorid=$p($g(^DHCEQInStock(ISRowID)),"^",17)
 	...q:vendorid=""
 	...s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
 	...s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
 	...q:ISStatus'=2
 	...s TEquipTypeDR=$p($g(^DHCEQInStock(ISRowID)),"^",20)
 	...q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
 	...
	...q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	...q:(EquipTypeIDs'="")&&(EquipTypeIDs'[(","_TEquipTypeDR_","))
 	...s ISLRowID=0
 	...f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID))  q:ISLRowID=""  d
 	....s TRowID=ISLRowID
 	....s TEquipName=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)
 	....s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQInStockList(ISLRowID)),"^",9))
 	....s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p($g(^DHCEQInStockList(ISLRowID)),"^",10))
 	....s TQuantity=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
 	....s TReduceValue=##Class(web.DHCEQInStockList).GetReturnInfoOfInstockList(ISLRowID)
	....s TReduceNum=$p(TReduceValue,"^",1)
	....s TQuantity=TQuantity-TReduceNum
	....q:TQuantity=0
 	....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQInStockList(ISLRowID)),"^",7),"",2)
 	....s TAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
 	....s TInStockNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)		//czf 2022-06-08 begin
 	....s TInvoiceNo=##class(web.DHCEQCommon).GetInvoiceNo(1,ISRowID,"Y")
	....s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)		//czf 2022-06-08 end
 	....s TInStockDate=##class(web.DHCEQCommon).TransValueToPage(StockDate,"date")
 	....s TRemark=$p($g(^DHCEQInStock(ISRowID)),"^",11)
 	....d OutputRowGetInStockDetail
 	
 	/*
 	//退货
 	s StockDate=BeginDate
 	f  s StockDate=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s StatCatDR=""
 	.f  s StatCatDR=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,StatCatDR)) q:StatCatDR=""  d
 	..s RRowID=0
 	..f  s RRowID=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,StatCatDR,RRowID)) q:RRowID=""  d
 	...d ResetVariablesGetInStockDetail
 	...s InvalidFlag=$p($g(^DHCEQReturn(RRowID)),"^",28)
 	...q:InvalidFlag="Y"
 	...s ReturnType=$p($g(^DHCEQReturn(RRowID)),"^",17)
 	...i ReturnType'="" s ReturnType=$p($g(^DHCEQCCode("DHCEQCOutType",ReturnType)),"^",1)
 	...q:ReturnType'="TH"
 	...s TEquipTypeDR=$p($g(^DHCEQReturn(RRowID)),"^",15)
 	...q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
 	...s TProvider=$p($g(^DHCEQReturn(RRowID)),"^",3)
 	...i TProvider'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
 	...s RLRowID=0
 	...f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID))  q:RLRowID=""  d
 	....s TRowID=$p($g(^DHCEQReturnList(RLRowID)),"^",3)
 	....i TRowID=""  d
 	.....s EQRowID=$p($g(^DHCEQReturnList(RLRowID)),"^",4)
 	.....s TRowID=$p($g(^DHCEQEquip(EQRowID)),"^",70)
 	.....s TEquipName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
 	.....s TModelDR=$p($g(^DHCEQEquip(EQRowID)),"^",3)
 	.....i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
 	.....s TUnitDR=$p($g(^DHCEQEquip(EQRowID)),"^",5)
 	.....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
 	....e  d
 	.....s TEquipName=$p($g(^DHCEQInStockList(TRowID)),"^",5)
 	.....s TModelDR=$p($g(^DHCEQInStockList(TRowID)),"^",9)
 	.....i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
 	.....s TUnitDR=$p($g(^DHCEQInStockList(TRowID)),"^",10)
	.....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
 	....i TRowID="" s TRowID=0
 	....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQReturnList(RLRowID)),"^",6),"",2)
 	....s TQuantity=0-$p($g(^DHCEQReturnList(RLRowID)),"^",5)
 	....s TAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
 	....s ISRowID=$p($g(^DHCEQInStockList(TRowID)),"^",1)	//czf 2022-06-08 begin
 	....i ISRowID'="" d
 	.....s TInStockNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)	
 	.....s TInvoiceNo=##class(web.DHCEQCommon).GetInvoiceNo(1,ISRowID,"Y")
 	.....s TInStockDate=$p($g(^DHCEQInStock(ISRowID)),"^",7)
 	.....s TInStockDate=##class(web.DHCEQCommon).TransValueToPage(TInStockDate,"date")
 	.....s TRemark=$p($g(^DHCEQInStock(ISRowID)),"^",11)
	....s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)		//czf 2022-06-08 end
 	....d OutputRowGetInStockDetail
 	*/
 	
	Quit $$$OK
OutputRowGetInStockDetail
	s Data=$lb(TRowID,TEquipName,TModel,TUnit,TProvider,TOriginalFee,TQuantity,TAmount,TInStockNo,TInvoiceNo,TEquipType,TInStockDate,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStockDetail
	s (TRowID,TEquipName,TModel,TUnit,TProvider,TOriginalFee,TQuantity,TAmount,TInStockNo,TInvoiceNo,TEquipType,TInStockDate,TRemark)=""
	quit
}

ClassMethod InStockDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InStockDetailExecute ]
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

ClassMethod InStockDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InStockDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// MZY0130	2785971		2022-07-27	调整结构,增加入参ToLoc,vStartDate,vEndDate
/// d ##class(%ResultSet).RunQuery("web.DHCEQCLRunQian","StoreMoveDetail","2014-11","0","","90","410")
/// d ##class(%ResultSet).RunQuery("web.DHCEQCLRunQian","StoreMoveDetail","","","","","",85,202,"","2022-05-01")
Query StoreMoveDetail(MonthStr As %String = "", MoveType As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", ToLoc As %String = "", vStartDate As %String = "", vEndDate As %String = "") As %Query(ROWSPEC = "TRowID:%String,TFromLoc:%String,TToLoc:%String,TEquipName:%String,TModel:%String,TUnit:%String,TOriginalFee:%String,TQuantity:%String,TAmount:%String,TMoveTypeDR:%String,TMoveType:%String,TEquipType:%String,TNetFeeAll:%String") [ SqlProc ]
{
}

ClassMethod StoreMoveDetailExecute(ByRef qHandle As %Binary, MonthStr As %String = "", MoveType As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", ToLoc As %String = "", vStartDate As %String = "", vEndDate As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	i EquipType="" s EquipTypeDR=""
	// MZY0130	2785971		2022-07-27
 	i ((vStartDate="")&&(vEndDate="")&&(MonthStr="")) Quit $$$OK
  	i (MonthStr'="")
	 {
	 	//会计周期
		s Date=##Class(web.DHCEQReport).GetReportDate(MonthStr,"3","")
		s BeginDate=$p(Date,"^",1)
		s EndDate=$p(Date,"^",2)
	 }
	 else
	 {
		i vStartDate="" d
		.s BeginDate=1
		e  d
		.s BeginDate=$ZDH(vStartDate,3)
		i vEndDate="" d
		.s EndDate=+$H 
		e  d
		.s EndDate=$ZDH(vEndDate,3)
	 }
	k ^DHCEQTempSMTKList("TKList")
 	s StockDate=BeginDate-1
	f  s StockDate=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s StatCatDR=""
 	.f  s StatCatDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR)) q:StatCatDR=""  d
 	..s MoveTypeDR=""
 	..f  s MoveTypeDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR,MoveTypeDR))  q:MoveTypeDR=""  d
 	...q:(MoveType'="")&&(MoveType'=MoveTypeDR)
	...// MZY0130	2785971		2022-07-27
 	...s TMoveTypeDR=MoveTypeDR
 	...s TMoveType=$CASE(TMoveTypeDR,"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退库","4":"库房调配",:"没有定义")		// MZY0130	2785971		2022-07-27	增加转移类型
 	...s SMRowID=0
 	...f  s SMRowID=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR,MoveTypeDR,SMRowID)) q:SMRowID=""  d
 	....d ResetVariablesGetStoreMoveDetail
 	....s EquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
 	....q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,CurGroupID))
 	....s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)	// MZY0130	2785971		2022-07-27  //modified by LMH 20220920 设备类型取值错误
 	....s TFromLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)
 	....i TFromLocDR'="" s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
 	....s TToLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
	....q:(ToLoc'="")&&(TToLoc'=ToLoc)	// MZY0130	2785971		2022-07-27
 	....i TToLocDR'="" s TToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
 	....s SMLRowID=0
 	....f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
 	.....s TRowID=SMLRowID
 	.....s TEquipName=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",5)
 	.....s TModelDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",9)
 	.....i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
 	.....s TUnitDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",10)
 	.....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
 	.....s TQuantity=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
 	.....;s TReduceValue=##Class(web.DHCEQStoreMoveNew).GetStoreMoveListLinkTKID(SMLRowID)
	.....;s TReduceNum=$p(TReduceValue,"^",1)
	.....s TReduceNum=0
	.....s SMLEQRowIDs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	.....d ##Class(web.DHCEQStoreMoveNew).GetStoreMoveListLinkTKID(SMLRowID)	//获取当前明细的退库设备
	.....f j=1:1:$l(SMLEQRowIDs,",") d
	......s TEquipDR=$p(SMLEQRowIDs,",",j)
 	......s TKListID=$g(^DHCEQTempSMTKList("TKList",SMLRowID,TEquipDR))
 	......i TKListID'="" s TReduceNum=TReduceNum+1
 	.....s TQuantity=TQuantity-TReduceNum
	.....q:TQuantity=0
 	.....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
 	.....s TAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
 	.....;MZY0130	2785971		2022-07-27
 	.....s TNetFeeAll=+$G(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
 	.....s TNetFeeAll=$p($g(^DHCEQEquip(TNetFeeAll)),"^",28)
 	.....s TNetFeeAll=##Class(web.DHCEQCommon).FormatNumber(TNetFeeAll*TQuantity,"",2)
 	.....d OutputRowGetStoreMoveDetail
	
	k ^DHCEQTempSMTKList("TKList")
	Quit $$$OK
OutputRowGetStoreMoveDetail
	Set Data=$lb(TRowID,TFromLoc,TToLoc,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TMoveTypeDR,TMoveType,TEquipType,TNetFeeAll)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreMoveDetail
	s (TRowID,TFromLoc,TToLoc,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TEquipType,TNetFeeAll)=""
	quit
}

ClassMethod StoreMoveDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StoreMoveDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod StoreMoveDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StoreMoveDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// HISUI改造需重新调整 曾超
/// add by kdf 卡片反面打印
/// d ##class(%ResultSet).RunQuery("web.DHCEQCLRunQian","GetAffixsInfoPrint","2")
Query GetAffixsInfoPrint(RowID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TModel:%String,TQuantity:%String,TOriginalFee:%String,TNo:%String,TRow:%String") [ SqlProc ]
{
}

ClassMethod GetAffixsInfoPrintExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    s index=1
    
    s TRow=1
    i RowID="" Quit $$$OK
	d ResetVariablesGetAffixsInfoPrint
	S ocldr=$P($g(^DHCEQEquip(RowID)),"^",77)
	I ocldr'="" d
	.I $Data(^DHCEQAffix(0,"CheckListDR",ocldr)) d
	..S affixRowId=""
	..For  Set affixRowId=$Order(^DHCEQAffix(0,"CheckListDR",ocldr,affixRowId))  Quit:affixRowId=""  d
	...q:($p($g(^DHCEQEquip(RowID,"OtherInfo")),"^",24))'=""   //add by wl 2020-03-02 WL0060 
	...q:$P($g(^DHCEQAffix(affixRowId)),"^",15)'="N"
	...q:$o(^DHCEQAffix(0,"OldRowID",RowID,affixRowId,0))>0
	...s TRowID=affixRowId
	...s TName=$P($g(^DHCEQAffix(affixRowId)),"^",4)
    ...s TModel=$P($g(^DHCEQAffix(affixRowId)),"^",5)
	...s TQuantity=$P($g(^DHCEQAffix(affixRowId)),"^",7)
	...s TOriginalFee=$P($g(^DHCEQAffix(affixRowId)),"^",11)
	...i $d(^DHCEQAffix(TRowID,"EX")) s TNo=$g(^DHCEQAffix(TRowID,"EX"))
 	...d OutputRowGetAffixsInfoPrint
 	s affixRowId=0
	f  s affixRowId=$o(^DHCEQAffix(0,"Equip",RowID,affixRowId))  quit:affixRowId=""  d
	.q:$p($g(^DHCEQAffix(affixRowId)),"^",15)'="N"
	.s TRowID=affixRowId
	.s TName=$P($g(^DHCEQAffix(affixRowId)),"^",4)
    .s TModel=$P($g(^DHCEQAffix(affixRowId)),"^",5)
	.s TQuantity=$P($g(^DHCEQAffix(affixRowId)),"^",7)
	.s TOriginalFee=$P($g(^DHCEQAffix(affixRowId)),"^",11)
	.i $d(^DHCEQAffix(TRowID,"EX")) s TNo=$g(^DHCEQAffix(TRowID,"EX"))
	.d OutputRowGetAffixsInfoPrint
 	Quit $$$OK	
OutputRowGetAffixsInfoPrint
	s Data=$lb(TRowID,TName,TModel,TQuantity,TOriginalFee,TNo,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetAffixsInfoPrint
	s (TRowID,TName,TModel,TQuantity,TOriginalFee,TNo)=""
	quit
}

ClassMethod GetAffixsInfoPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAffixsInfoPrintExecute ]
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

ClassMethod GetAffixsInfoPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAffixsInfoPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// HISUI改造需重新调整 曾超
/// add by kdf end 卡片反面打印
/// add by kdf 2018-01-03 
/// 用于卡片润乾打印（正面）
/// 根据设备RowId，获取设备详细信息 
/// d ##class(%ResultSet).RunQuery("web.DHCEQCLRunQian","GetEquipList","14")
Query GetEquipList(RowId As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipName:%String,TOriginalFee:%String,TCountry:%String,TQuantity:%String,TModel:%String,TPurposeType:%String,TLeaveFactoryNo:%String,TOrigin:%String,TManuFactory:%String,TContractNo:%String,TProvider:%String,TCheckDate:%String,TUseLoc:%String,TStartDate:%String,TRemark:%String,TEquipNo:%String,TFileNo:%String") [ SqlProc ]
{
}

ClassMethod GetEquipListExecute(ByRef qHandle As %Binary, RowId As %String = "") As %Status
{
	
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	 	
 	i RowId="" Quit $$$OK
 	d ResetVariablesGetEquipList 
 	
 	 s EquipData=$g(^DHCEQEquip(RowId))
 	 s TRowID=RowId 
 	 s TEquipName=$p(EquipData,"^",1)  
 	 s TOriginalFee=+$p(EquipData,"^",27) 
 	 s CountryDR=$p(EquipData,"^",16) 
 	 i CountryDR '=""  s TCountry=##class(web.DHCEQCommon).GetTrakNameByID("cou",CountryDR) 
 	 s TQuantity="壹台"
 	 s ModelDR = $p(EquipData,"^",3)
	 i ModelDR '=""  s TModel = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2) ;TModel
 	 s PurposeTypeDR = $p(EquipData,"^",65)
	 i PurposeTypeDR '=""  s TPurposeType = $p($g(^DHCEQCCode("DHCEQCPurposeType",PurposeTypeDR)),"^",2)
 	 s TLeaveFactoryNo = $p(EquipData,"^",10)
 	 s OriginDR = $p(EquipData,"^",20)
	 i OriginDR '=""  s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",OriginDR)),"^",2) 
 	 s ManuFactoryDR = $p(EquipData,"^",26)
	 i ManuFactoryDR '=""  s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR)),"^",1)  ;TManuFactory //CZF0093
 	 s TContractNo=$p(EquipData,"^",76)
 	 s ProviderDR = $p(EquipData,"^",25)
	 i ProviderDR '=""  s TProvider =##class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
 	 s TCheckDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",12),"date")
 	 s UseLocDR = $p(EquipData,"^",19)
 	 i UseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)  ;TUseLoc
 	 s TStartDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",44),"date")
 	 s TRemark = $p(EquipData,"^",34)  
 	 s TEquipNo = $p(EquipData,"^",71) 
 	 s TFileNo = $p(EquipData,"^",85)              
 	d OutputRowGetEquipList
	Quit $$$OK
	
OutputRowGetEquipList
	s Data=$lb(TRowID,TEquipName,TOriginalFee,TCountry,TQuantity,TModel,TPurposeType,TLeaveFactoryNo,TOrigin,TManuFactory,TContractNo,TProvider,TCheckDate,TUseLoc,TStartDate,TRemark,TEquipNo,TFileNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipList
	s (TRowID,TEquipName,TOriginalFee,TCountry,TQuantity,TModel,TPurposeType,TLeaveFactoryNo,TOrigin,TManuFactory,TContractNo,TProvider,TCheckDate,TUseLoc,TStartDate,TRemark,TEquipNo,TFileNo)=""
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

}
