Class web.DHCEQBHRunQian Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*************************************************************/
/// Add By DJ 2013-11-28
/// 描述:固定资产月报
/// TColFlag:1表示上月结余，2表示本月增加， 3表示本月减少， 4表示本月出库及退库， 5表示期末结余， 
/// TSourceType:1:不区分业务   2入库   3调账  4调整数据   5退货单   6减少单   7报废
ClassMethod MonthReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MonthReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod MonthReportExecute(ByRef qHandle As %Binary, MonthStr As %String = "", QXType As %String = "", UseLocDR As %String = "", FundsTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set job=$J
 	k ^DHCEQTemp("MonthReport",job)
 	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
 	i ((MonthStr="")||(SelfFundsFlag="")) Quit $$$OK
 	s CurYear=$p(MonthStr,"-",1)
 	s CurMonth=+$p(MonthStr,"-",2)
 	i CurMonth=1
 	{
	 	s PreYear=CurYear-1
	 	s PreMonth=12
 	}
 	else
 	{
	 	s PreYear=CurYear
	 	s PreMonth=CurMonth-1
 	}
 	s PreSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(PreYear_"-"_PreMonth)
	s CurSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	i ((PreSnapID="")||(CurSnapID="")) Quit $$$OK
	s index=1
	
	//期初
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQSnapShot(PreSnapID,"Equip",EQRowID))  q:EQRowID=""  d
	.s InvalidFlag=$p($g(^DHCEQSnapShot(PreSnapID,"Equip",EQRowID)),"^",59)
	.q:InvalidFlag="Y"
	.s EQStatus=$p($g(^DHCEQSnapShot(PreSnapID,"Equip",EQRowID)),"^",38)
	.s EQStockStatus=$p($g(^DHCEQSnapShot(PreSnapID,"Equip",EQRowID)),"^",60)
	.q:((EQStockStatus'=1)||(EQStatus>2))
	.s TEquipTypeDR=$p($g(^DHCEQSnapShot(PreSnapID,"Equip",EQRowID)),"^",63)
	.s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	.q:+result'=0
	.s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSnapShot(PreSnapID,"Equip",EQRowID)),"^",27),"",2)
	.i EQStatus'=1 s EQStatus=2
	.s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,1,EQStatus,1,1)=1+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,1,EQStatus,1,1))
	.s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,1,EQStatus,1,2)=OriginalFee+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,1,EQStatus,1,2))
	
	//本期入库
	s BeginDate=$ZD(MonthStr_"-01",3)-1
	s EndDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"2","")
	
	s TEquipTypeDR=0
	f  s TEquipTypeDR=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR))  q:TEquipTypeDR=""  d
	.s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	.q:+result'=0
	.s BADate=BeginDate
	.f  s BADate=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR,BADate)) q:(BADate="")||(BADate>EndDate)  d
	..s ISRowID=0
	..f  s ISRowID=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR,BADate,ISRowID))  q:ISRowID=""  d
	...s ISNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
	...q:ISNo=""
	...s ISLRowID=0
	...f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID))  q:ISLRowID=""  d
	....s StatCatDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",17)
	....s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQInStockList(ISLRowID)),"^",7),"",2)
	....s Quantity=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
	....s Amount=##Class(web.DHCEQCommon).FormatNumber(OriginalFee*Quantity,"",2)
	....s EQStatus=2
	....s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,2,EQStatus,2,1)=Quantity+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,2,EQStatus,2,1))
	....s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,2,EQStatus,2,2)=Amount+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,2,EQStatus,2,2))
	
	//本期调账
	s TEquipTypeDR=0
	f  s TEquipTypeDR=$o(^DHCEQChangeAccount(0,"TypeDate",TEquipTypeDR))  q:TEquipTypeDR=""  d
	.s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	.q:+result'=0
	.s BADate=BeginDate
	.f  s BADate=$o(^DHCEQChangeAccount(0,"TypeDate",TEquipTypeDR,BADate)) q:(BADate="")||(BADate>EndDate)  d
	..s CARowID=0
	..f  s CARowID=$o(^DHCEQChangeAccount(0,"TypeDate",TEquipTypeDR,BADate,CARowID))  q:CARowID=""  d
	...s CAStatus=$p($g(^DHCEQChangeAccount(CARowID)),"^",32)
	...s ChangeFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQChangeAccount(CARowID)),"^",2),"",2)
	...s PreOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQChangeAccount(CARowID)),"^",24),"",2)
	...s EQRowID=$p($g(^DHCEQChangeAccount(CARowID)),"^",1)
	...s PreStatus=$p($g(^DHCEQSnapShot(PreSnapID,"Equip",EQRowID)),"^",38)
	...s CurStatus=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",38)
	...//根据调账记录设备判断上月和当月状态是否一致
	...i PreStatus=CurStatus  d
	....s EQStatus=1
	....i PreStatus'=1 s EQStatus=2
	....i +ChangeFee>0  d
	.....s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,2,EQStatus,3,2)=ChangeFee+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,2,EQStatus,3,2))
	....e  d
	.....s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,3,EQStatus,3,2)=ChangeFee+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,3,EQStatus,3,2)) 
	...e  d
	....s EQStatus=2
	....i ((CAStatus="1")||(CAStatus="")) s EQStatus=1
	....i PreStatus'=1 s PreStatus=2
	....//调账记录与上月设备状态一致
	....i PreStatus'=EQStatus  d
	.....s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,3,PreStatus,3,2)=PreOriginalFee+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,3,PreStatus,3,2))
	.....s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,2,EQStatus,3,2)=PreOriginalFee+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,2,EQStatus,3,2))
	....i +ChangeFee>0  d
	.....s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,2,EQStatus,3,2)=ChangeFee+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,2,EQStatus,3,2))
	....e  d
	.....s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,3,EQStatus,3,2)=ChangeFee+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,3,EQStatus,3,2))
	
	//本期新增数据(变动数据调整,新增数据调整,恢复数据调整)
	s ADDate=BeginDate
	f  s ADDate=$o(^DHCEQAdjustData(0,"FlagDate","Y",ADDate)) q:(ADDate="")||(ADDate>EndDate)  d
	.s ADType=0
	.f  s ADType=$o(^DHCEQAdjustData(0,"FlagDate","Y",ADDate,ADType)) q:ADType=""  d
	..q:((ADType=3)||(ADType=9))
	..s ADRowID=0
	..f  s ADRowID=$o(^DHCEQAdjustData(0,"FlagDate","Y",ADDate,ADType,ADRowID))  q:ADRowID=""  d
	...s ADLRowID=0
	...f  s ADLRowID=$o(^DHCEQAdjustDataList(0,"AdjustData",ADRowID,ADLRowID))  q:ADLRowID=""  d
	....s ADLEquipDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",2)
	....s FromEquipTypeDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",4)
	....s FromStatCatDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",5)
	....s ToEquipTypeDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",9)
	....s ToStatCatDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",10)
	....q:(FromEquipTypeDR=ToEquipTypeDR)
	....s result=0
	....i ADType=4 s result=##class(web.DHCEQCommon).EquipTypeIsIn(FromEquipTypeDR,CurGroupID)	//取消报废
	....q:+result'=0
	....i ADType<=2 s result=##class(web.DHCEQCommon).EquipTypeIsIn(ToEquipTypeDR,CurGroupID)	//新增、调整
	....q:+result'=0
	....s EQStatus=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",13)
	....s OriginalFee=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",14)
	....//调整数据类组变动
	....i ADType=1  d
	.....i EQStatus'=1 s EQStatus=2
	.....s ^DHCEQTemp("MonthReport",job,FromEquipTypeDR,3,EQStatus,4,1)=1+$g(^DHCEQTemp("MonthReport",job,FromEquipTypeDR,3,EQStatus,4,1))
	.....s ^DHCEQTemp("MonthReport",job,FromEquipTypeDR,3,EQStatus,4,2)=OriginalFee+$g(^DHCEQTemp("MonthReport",job,FromEquipTypeDR,3,EQStatus,4,2))
	.....s ^DHCEQTemp("MonthReport",job,ToEquipTypeDR,2,EQStatus,4,1)=1+$g(^DHCEQTemp("MonthReport",job,ToEquipTypeDR,2,EQStatus,4,1))
	.....s ^DHCEQTemp("MonthReport",job,ToEquipTypeDR,2,EQStatus,4,2)=OriginalFee+$g(^DHCEQTemp("MonthReport",job,ToEquipTypeDR,2,EQStatus,4,2))
	....//新增数据调整
	....i ADType=2  d
	.....i EQStatus'=1 s EQStatus=2
	.....s ^DHCEQTemp("MonthReport",job,ToEquipTypeDR,2,EQStatus,4,1)=1+$g(^DHCEQTemp("MonthReport",job,ToEquipTypeDR,2,EQStatus,4,1))
	.....s ^DHCEQTemp("MonthReport",job,ToEquipTypeDR,2,EQStatus,4,2)=OriginalFee+$g(^DHCEQTemp("MonthReport",job,ToEquipTypeDR,2,EQStatus,4,2))
	....//取消报废
	....i ADType=4  d
	.....i EQStatus'=1 s EQStatus=2
	.....s ^DHCEQTemp("MonthReport",job,FromEquipTypeDR,2,EQStatus,4,1)=1+$g(^DHCEQTemp("MonthReport",job,FromEquipTypeDR,2,EQStatus,4,1))
	.....s ^DHCEQTemp("MonthReport",job,FromEquipTypeDR,2,EQStatus,4,2)=OriginalFee+$g(^DHCEQTemp("MonthReport",job,FromEquipTypeDR,2,EQStatus,4,2))
	
	//调拨--出库，退库
	s TEquipTypeDR=0
	f  s TEquipTypeDR=$o(^DHCEQStoreMove(0,"TypeDate",TEquipTypeDR))  q:TEquipTypeDR=""  d
	.s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	.q:+result'=0
	.s BADate=BeginDate
	.f  s BADate=$o(^DHCEQStoreMove(0,"TypeDate",TEquipTypeDR,BADate)) q:(BADate="")||(BADate>EndDate)  d
	..s SMRowID=0
	..f  s SMRowID=$o(^DHCEQStoreMove(0,"TypeDate",TEquipTypeDR,BADate,SMRowID)) q:SMRowID=""  d
	...s MoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)
	...q:(MoveType'=0)&&(MoveType'=3)
	...i MoveType=0  s EQStatus=1	//出库
	...i MoveType=3  s EQStatus=2	//退库
	...s SMLRowID=0
	...f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
	....s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
	....s Quantity=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
	....s Amount=##Class(web.DHCEQCommon).FormatNumber(OriginalFee*Quantity,"",2)
	....s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,4,EQStatus,1,1)=Quantity+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,4,EQStatus,1,1))
	....s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,4,EQStatus,1,2)=Amount+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,4,EQStatus,1,2))
	
	//退货,减少
	s TEquipTypeDR=0
	f  s TEquipTypeDR=$o(^DHCEQReturn(0,"TypeDate",TEquipTypeDR))  q:TEquipTypeDR=""  d
	.s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	.q:+result'=0
	.s OutTypeDR=0
	.f  s OutTypeDR=$o(^DHCEQReturn(0,"TypeDate",TEquipTypeDR,OutTypeDR))  q:OutTypeDR=""  d
	..s OutTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",OutTypeDR)),"^",1)
	..s OutTypeCode=5
	..i OutTypeCode'="TH" s OutTypeCode=6
	..s BADate=BeginDate
	..f  s BADate=$o(^DHCEQReturn(0,"TypeDate",TEquipTypeDR,OutTypeDR,BADate)) q:(BADate="")||(BADate>EndDate)  d
	...s RRowID=0
	...f  s RRowID=$o(^DHCEQReturn(0,"TypeDate",TEquipTypeDR,OutTypeDR,BADate,RRowID)) q:RRowID=""  d
	....s UseLocDR=$p($g(^DHCEQReturn(RRowID)),"^",24)
	....s EQStatus=1
	....i UseLocDR="" s EQStatus=2
	....s RLRowID=0
	....f  s RLRowID=$o(^DHCEQReturnList(0,"StoreMove",RRowID,RLRowID))  q:RLRowID=""  d
	.....s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQReturnList(RLRowID)),"^",6),"",2)
	.....s Quantity=$p($g(^DHCEQReturnList(RLRowID)),"^",5)
	.....s Amount=##Class(web.DHCEQCommon).FormatNumber(OriginalFee*Quantity,"",2)
	.....s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,3,EQStatus,OutTypeCode,1)=Quantity+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,3,EQStatus,OutTypeCode,1))
	.....s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,3,EQStatus,OutTypeCode,2)=Amount+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,3,EQStatus,OutTypeCode,2))
	
	//报废
	s TEquipTypeDR=0
	f  s TEquipTypeDR=$o(^DHCEQDisuseRequest(0,"TypeDate",TEquipTypeDR)) q:TEquipTypeDR=""  d
	.s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	.q:+result'=0
	.s BADate=BeginDate
	.f  s BADate=$o(^DHCEQDisuseRequest(0,"TypeDate",TEquipTypeDR,BADate)) q:((BADate="")||(BADate>EndDate))  d
	..s DRRowID=0
	..f  s DRRowID=$o(^DHCEQDisuseRequest(0,"TypeDate",TEquipTypeDR,BADate,DRRowID)) q:((DRRowID=""))  d
	...s DRLRowID=0
	...f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DRRowID,DRLRowID)) q:(DRLRowID="")  d
	....s EquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	....s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSnapShot(CurSnapID,"Equip",EquipDR)),"^",27),"",2)
	....s EQStatus=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",11)
	....i EQStatus'=1 s EQStatus=2
	....s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,3,EQStatus,7,1)=1+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,3,EQStatus,7,1))
	....s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,3,EQStatus,7,2)=OriginalFee+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,3,EQStatus,7,2))
	
	//本期减少数据调整
	s ADDate=BeginDate
	f  s ADDate=$o(^DHCEQAdjustData(0,"FlagDate","Y",ADDate)) q:(ADDate="")||(ADDate>EndDate)  d
	.s ADType=0
	.f  s ADType=$o(^DHCEQAdjustData(0,"FlagDate","Y",ADDate,ADType)) q:ADType=""  d
	..q:ADType'=3
	..s ADRowID=0
	..f  s ADRowID=$o(^DHCEQAdjustData(0,"FlagDate","Y",ADDate,ADType,ADRowID))  q:ADRowID=""  d
	...s ADLRowID=0
	...f  s ADLRowID=$o(^DHCEQAdjustDataList(0,"AdjustData",ADRowID,ADLRowID))  q:ADLRowID=""  d
	....s ADLEquipDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",2)
	....s FromEquipTypeDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",4)
	....s FromStatCatDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",5)
	....s ToEquipTypeDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",9)
	....s ToStatCatDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",10)
	....q:(FromEquipTypeDR=ToEquipTypeDR)
	....s result=##class(web.DHCEQCommon).EquipTypeIsIn(FromEquipTypeDR,CurGroupID)	//报废
	....q:+result'=0
	....s EQStatus=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",13)
	....s OriginalFee=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",14)
	....i EQStatus'=1 s EQStatus=2
	....s ^DHCEQTemp("MonthReport",job,FromEquipTypeDR,3,EQStatus,4,1)=1+$g(^DHCEQTemp("MonthReport",job,FromEquipTypeDR,3,EQStatus,4,1))
	....s ^DHCEQTemp("MonthReport",job,FromEquipTypeDR,3,EQStatus,4,2)=OriginalFee+$g(^DHCEQTemp("MonthReport",job,FromEquipTypeDR,3,EQStatus,4,2))
	
	//期末
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID))  q:EQRowID=""  d
	.s InvalidFlag=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",59)
	.q:InvalidFlag="Y"
	.s EQStatus=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",38)
	.s EQStockStatus=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",60)
	.q:((EQStockStatus'=1)||(EQStatus>2))
	.s TEquipTypeDR=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",63)
	.s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	.q:+result'=0
	.s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",27),"",2)
	.i EQStatus'=1 s EQStatus=2
	.s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,5,EQStatus,1,1)=1+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,5,EQStatus,1,1))
	.s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,5,EQStatus,1,2)=OriginalFee+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,5,EQStatus,1,2))
	
	
	//输出明细汇总
	s EquipTypeDR=0
	f  s EquipTypeDR=$o(^DHCEQTemp("MonthReport",job,EquipTypeDR))  q:EquipTypeDR=""  d
	.d ResetVariablesGetMonthReport
	.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	.s ColFlag=0
	.f  s ColFlag=$o(^DHCEQTemp("MonthReport",job,EquipTypeDR,ColFlag))  q:ColFlag=""  d
	..s TColFlag=ColFlag
	..s vStatus=0
	..f  s vStatus=$o(^DHCEQTemp("MonthReport",job,EquipTypeDR,ColFlag,vStatus))  q:vStatus=""  d
	...s TStatus=vStatus
	...s vSourceType=0
	...f  s vSourceType=$o(^DHCEQTemp("MonthReport",job,EquipTypeDR,ColFlag,vStatus,vSourceType))  q:vSourceType=""  d
	....s TSourceType=vSourceType
	....s TQuanitity=$g(^DHCEQTemp("MonthReport",job,EquipTypeDR,ColFlag,vStatus,vSourceType,1))
	....s TAmount=$g(^DHCEQTemp("MonthReport",job,EquipTypeDR,ColFlag,vStatus,vSourceType,2))
	....d OutputRowGetMonthReport
	
	//输出结束删除临时global
	k ^DHCEQTemp("MonthReport",job)
	
	Quit $$$OK
OutputRowGetMonthReport
	s Data=$lb(TEquipType,TColFlag,TStatus,TSourceType,TQuanitity,TAmount)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMonthReport
	s (TEquipType,TColFlag,TStatus,TSourceType,TQuanitity,TAmount)=""
	quit
}

ClassMethod MonthReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MonthReportExecute ]
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

Query MonthReport(MonthStr As %String = "", QXType As %String = "", UseLocDR As %String = "", FundsTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TEquipType:%String,TColFlag:%String,TStatus:%String,TSourceType:%String,TQuanitity:%String,TAmount:%String") [ SqlProc ]
{
}

/// ADD By DJ 2014-04-19
/// 转移明细
ClassMethod StoreMoveDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StoreMoveDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod StoreMoveDetailExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "", MoveType As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1

 	i EquipType="" s EquipTypeDR=""
 	i vStartDate=""  d
 	.s BeginDate=0
 	e  d
 	.s BeginDate=$ZDH(vStartDate,3)-1
 	i vEndDate=""  d
 	.s EndDate=+$H
 	e  d
 	.s EndDate=$ZDH(vEndDate,3)
 	
 	s StockDate=BeginDate
 	f  s StockDate=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s StatCatDR=""
 	.f  s StatCatDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR)) q:StatCatDR=""  d
 	..s MoveTypeDR=""
 	..f  s MoveTypeDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR,MoveTypeDR))  q:MoveTypeDR=""  d
 	...q:(MoveType'="")&&(MoveType'=MoveTypeDR)
 	...s SMRowID=0
 	...f  s SMRowID=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR,MoveTypeDR,SMRowID)) q:SMRowID=""  d
 	....d ResetVariablesGetStoreMoveDetail
 	....s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
 	....q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
 	....s TStoreMoveNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
 	....s TFromLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)
 	....i TFromLocDR'="" s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
 	....s TToLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
 	....i TToLocDR'="" s TToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
 	....s TInDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",5)
 	....;i TInDate'="" s TInDate=$ZD(TInDate,3)
 	....;日期格式统一调整
	....s TInDate=##Class(web.DHCEQCommon).TransValueFromPage(TInDate,"date")
 	....s TActDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
 	....;i TActDate'="" s TActDate=$ZD(TActDate,3)
 	....;日期格式统一调整
	....s TActDate=##Class(web.DHCEQCommon).TransValueFromPage(TActDate,"date")
 	....s TReciverDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",15)
 	....i TReciverDR'="" s TReciver=##Class(web.DHCEQCommon).GetTrakNameByID("user",TReciverDR)
	....i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
 	....s SMLRowID=0
 	....f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
 	.....s TRowID=SMLRowID
 	.....s TEquipName=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",5)
 	.....s TModelDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",9)
 	.....i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
 	.....s TUnitDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",10)
 	.....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
 	.....s EquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
 	.....s InStockListDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
 	.....i EquipDR'=""  d
 	......s TStatCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",75)
 	......s TEquipCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",4)
 	.....e  d
 	......s TStatCatDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",17)
 	......s TEquipCatDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",14)
 	.....i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
 	.....i TEquipCatDR'=""  d
 	......s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
 	......s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
 	.....s TQuantity=1
 	.....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
 	.....s TAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
 	.....s RowIDs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
 	.....s CurCount=$L(RowIDs,",")
 	.....f i=1:1:CurCount  d
 	......s CurRowID=$p(RowIDs,",",i)
 	......s TEquipNo=$p($g(^DHCEQEquip(CurRowID)),"^",71)
 	......s TLimitYearsNum=$p($g(^DHCEQEquip(CurRowID)),"^",31)
 	......s TLocationDR=$p($g(^DHCEQEquip(CurRowID)),"^",72)
 	......s TLocation=""
 	......i TLocationDR'="" s TLocation=$p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)
 	......s TFristDate=##Class(web.DHCEQCommon).GetFirstMoveDate(CurRowID)
 	......;i TFristDate'="" s TFristDate=$ZD(TFristDate,3)
 	......;日期格式统一调整
	......s TFristDate=##Class(web.DHCEQCommon).TransValueFromPage(TFristDate,"date")
 	......s TType=-1
 	......d OutputRowGetStoreMoveDetail
 	......s TType=1
 	......d OutputRowGetStoreMoveDetail
 	
	Quit $$$OK
OutputRowGetStoreMoveDetail
	s Data=$lb(TRowID,TStoreMoveNo,TFromLoc,TToLoc,TInDate,TActDate,TReciver,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TEquipCatCode,TEquipType,TStatCat,TEquipCat,TEquipNo,TLimitYearsNum,TType,TLocation,TFristDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreMoveDetail
	s (TRowID,TStoreMoveNo,TFromLoc,TToLoc,TInDate,TActDate,TReciver,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TEquipCatCode,TEquipType,TStatCat,TEquipCat,TEquipNo,TLimitYearsNum,TType,TLocation,TFristDate)=""
	quit
}

ClassMethod StoreMoveDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StoreMoveDetailExecute ]
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

Query StoreMoveDetail(vStartDate As %String = "", vEndDate As %String = "", MoveType As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TStoreMoveNo:%String,TFromLoc:%String,TToLoc:%String,TInDate:%String,TActDate:%String,TReciver:%String,TEquipName:%String,TModel:%String,TUnit:%String,TOriginalFee:%String,TQuantity:%String,TAmount:%String,TEquipCatCode:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TEquipNo:%String,TLimitYearsNum:%String,TType:%String,TLocation:%String,TFristDate:%String") [ SqlProc ]
{
}

}
