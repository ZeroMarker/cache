/// Creator:add by czf
/// CreateDate:2021-08-31
/// Descrition:效益分析数据明细
Class web.DHCEQ.BA.RPTList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by zy 2020-02-18
/// 取效益设备的基本信息清单汇总
/// 入参：vData:参数拼的字符串"^para1=value1^para2=value2^para3=value3"
///       NodeStr:  其他类中调用传入的一个临时golable节点,Node^CurTime^Job
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.RPTList","RunStat","^EquipDR=^ItemDR=^UseLocDR=^EquipCatDR=^EquipName=^Model=^ManuFactory=","RunStat^65993,35948^14740")
Query RunStat(vData As %String = "", NodeStr As %String = "") As %Query(ROWSPEC = "TUseLoc:%String,TTotalNum:%String,TOffNum:%String,TOnWaitNum:%String,TOnNum:%String,TMaintNum:%String,TOtherNum:%String") [ SqlProc ]
{
}

ClassMethod RunStatExecute(ByRef qHandle As %Binary, vData As %String = "", NodeStr As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
	s Node=$p(NodeStr,"^",1)
	s CurTime=$p(NodeStr,"^",2)
	s Job=$p(NodeStr,"^",3)
	
	s result=##Class(web.DHCEQ.BA.RPTCommon).GetBAEquipList(vData,NodeStr)
	i result'=0 Quit $$$OK
	
 	s rowid=0
 	f  s rowid=$o(^TempDHCEQ(Node,CurTime,Job,rowid)) q:rowid=""  d
 	.s TEquipDR=$g(^TempDHCEQ(Node,CurTime,Job,rowid))
	.s UseLocDR=$p($g(^DHCEQEquip(TEquipDR)),"^",67)
 	.s ObjEquip=##class(web.DHCDT3D.OnlineCheck).GetOneEquipOnlineData(TEquipDR,1)
 	.s ObjEquip=ObjEquip.Data
 	.s EquipStatus=ObjEquip.EquipStatus	//"0":"未知","1":"开机","2":"关机",:""
 	.s EQRunState=ObjEquip.EQRunState	//"0":"待机","1":"在用","2":"故障异常","3":"离线",:""
	.s Datalist=$g(^TempDHCEQ(Node,"Sum",CurTime,Job,UseLocDR))
	.s $p(Datalist,"^",1)=$p(Datalist,"^",1)+1
	.i EquipStatus=2 d
	..s $p(Datalist,"^",2)=$p(Datalist,"^",2)+1
	.e  d
	..i EQRunState=0  d
	...s $p(Datalist,"^",3)=$p(Datalist,"^",3)+1
	..e  i EQRunState=1  d
	...s $p(Datalist,"^",4)=$p(Datalist,"^",4)+1
	..e  i EQRunState=2  d
	...s $p(Datalist,"^",5)=$p(Datalist,"^",5)+1
	..e  i EQRunState=3  d
	...s $p(Datalist,"^",6)=$p(Datalist,"^",6)+1
	.s ^TempDHCEQ(Node,"Sum",CurTime,Job,UseLocDR)=Datalist
	
	s UseLocDR=0
	f  s UseLocDR=$o(^TempDHCEQ(Node,"Sum",CurTime,Job,UseLocDR)) q:UseLocDR=""  d
	.s Datalist=$g(^TempDHCEQ(Node,"Sum",CurTime,Job,UseLocDR))
 	.s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
	.s TTotalNum=$p(Datalist,"^",1)
	.s TOffNum=$p(Datalist,"^",2)
	.s TOnWaitNum=$p(Datalist,"^",3)
	.s TOnNum=$p(Datalist,"^",4)
	.s TMaintNum=$p(Datalist,"^",5)
	.s TOtherNum=$p(Datalist,"^",6)
 	.d OutputRowRunStat
 	k ^TempDHCEQ(Node,CurTime,Job)
 	k ^TempDHCEQ(Node,"Sum",CurTime,Job)
 	Quit $$$OK
 	
OutputRowRunStat
	s Data=$lb(TUseLoc,TTotalNum,TOffNum,TOnWaitNum,TOnNum,TMaintNum,TOtherNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod RunStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RunStatExecute ]
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

ClassMethod RunStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RunStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zy 2021-09-03
/// 统计开单医生的检查结果的阳性率
/// 入参：vData:参数拼的字符串"^para1=value1^para2=value2^para3=value3"
///       NodeStr:  其他类中调用传入的一个临时golable节点,Node^CurTime^Job
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.RPTList","DoctorPositiveRate","","DoctorPositiveRate^65988,62871^1532")
Query DoctorPositiveRate(vData As %String = "", NodeStr As %String = "") As %Query(ROWSPEC = "TDoctoreDR:%String,TDoctore:%String,TWorkLoadNum:%String,TPositiveNum:%String,TPositiveRate:%String") [ SqlProc ]
{
}

ClassMethod DoctorPositiveRateExecute(ByRef qHandle As %Binary, vData As %String = "", NodeStr As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s result=##Class(web.DHCEQ.BA.RPTCommon).GetDoctorPositiveNum(vData,NodeStr)
 	i result'=0 Quit $$$OK
 	
	s Node=$p(NodeStr,"^",1)
	s CurTime=$p(NodeStr,"^",2)
	s Job=$p(NodeStr,"^",3)
	
	s TDoctoreDR=0
	f  s TDoctoreDR=$o(^TempDHCEQ(Node,CurTime,Job,TDoctoreDR))  q:TDoctoreDR=""  d
	.s (TmpDataList,TDoctore,TWorkLoadNum,TPositiveNum,TPositiveRate)=""
	.s TmpDataList=$g(^TempDHCEQ(Node,CurTime,Job,TDoctoreDR))
	.s TDoctore=##Class(web.DHCEQCommon).GetTrakNameByID("user",TDoctoreDR)
	.s TWorkLoadNum=+$p(TmpDataList,"^",1)
	.s TPositiveNum=+$p(TmpDataList,"^",2)
	.s TPositiveRate=""
	.i TWorkLoadNum>0 s TPositiveRate=##Class(web.DHCEQCommon).FormatNumber(TPositiveNum/TWorkLoadNum,"")
 	.d OutputRowDoctorPositiveRate
 	k ^TempDHCEQ(Node,CurTime,Job)
 	Quit $$$OK
 	
OutputRowDoctorPositiveRate
	s Data=$lb(TDoctoreDR,TDoctore,TWorkLoadNum,TPositiveNum,TPositiveRate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod DoctorPositiveRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DoctorPositiveRateExecute ]
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

ClassMethod DoctorPositiveRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DoctorPositiveRateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// czf 2020-08-07
/// 获取科室效益分析明细信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.RPTList","GetLocBenefitInfo","3188","12214","5","1")
Query GetLocBenefitInfo(nodestr As %String = "", EJob As %String = "", CurUserID As %String = "", StoreLocDR As %String = "", Type As %String = "", vStartDate As %String = "", vEndDate As %String = "", vPeriodType As %String = "") As %Query(ROWSPEC = "TStoreLocID:%String,TStoreLoc:%String,TFactualWorkLoad:%String,TWorkLoadPerMonth:%String,TInCome:%String,TConsumableFee:%String,TPersonFee:%String,TWEFee:%String,THouseFee:%String,TMaintFee:%String,TMaintainFee:%String,TInSpectFee:%String,TMaintenanceFee:%String,TDepreFee:%String,TOutFee:%String,TOriginalAmount:%String,TEQNum:%String,TMonth:%String,TInComeChainRatio:%String,TOutFeeChainRatio:%String,TInComeYearOnYearRate:%String,TOutFeeYearOnYearRate:%String,TOtherIncome:%String,TOutIncome:%String,TInIncome:%String,TEmergencyIncome:%String,TNewBornIncome:%String,THealthIncome:%String,TPerDayIncome:%String,TPerDayOutFee:%String,TInOutRate:%String,TServeConsumeFee:%String,TConsumeMaterialFee:%String,TTrainFee:%String,TMeasureFee:%String,TQualityControlFee:%String")
{
}

ClassMethod GetLocBenefitInfoExecute(ByRef qHandle As %Binary, nodestr As %String = "", EJob As %String = "", CurUserID As %String = "", StoreLocDR As %String = "", Type As %String = "", vStartDate As %String = "", vEndDate As %String = "", vPeriodType As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Date=+$h
	
	i CurUserID="" s CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i (nodestr="")||(EJob="")||(CurUserID="") Quit $$$OK
	
	;调用方法将数据存储在临时global中	
	//d ##Class(web.DHCEQ.BA.RPTCommon).GetBenefitAnalyInfo(nodestr,EJob,vStartDate,vEndDate,CurUserID,"","")
	
	i (Type="")||(Type=0)		//首页汇总输出
	{
		s EQLocID=""
		f  s EQLocID=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUserID,EQLocID)) q:EQLocID=""  d
		.q:(StoreLocDR'="")&&(StoreLocDR'=EQLocID)
		.d ResetLocBenefitInfo
		.s TStoreLocID=EQLocID
		.s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocID)
		.s Month=""
		.f  s Month=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUserID,EQLocID,Month)) q:Month=""  d
		..s BenefitDetail=$g(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUserID,EQLocID,Month))
		..s TMonthDays=TMonthDays+##class(web.DHCEQCommon).GetMonthEndDate(Month,"1")
		..s TFactualWorkLoad=TFactualWorkLoad+$p(BenefitDetail,"^",1)		//实际工作量
		..s TWorkLoadPerMonth=TWorkLoadPerMonth+$p(BenefitDetail,"^",2)		//工作量
		..s TInCome=TInCome+$p(BenefitDetail,"^",3)					//总收入
		..s TConsumableFee=TConsumableFee+$p(BenefitDetail,"^",4)	//耗材费
		..s TPersonFee=TPersonFee+$p(BenefitDetail,"^",5)			//人员
		..s TWEFee=TWEFee+$p(BenefitDetail,"^",6)					//工资
		..s THouseFee=THouseFee+$p(BenefitDetail,"^",7)				//房屋折旧
		..s TMaintFee=TMaintFee+$p(BenefitDetail,"^",8)				//维修
		..s TMaintainFee=TMaintainFee+$p(BenefitDetail,"^",9)		//保养
		..s TInSpectFee=TInSpectFee+$p(BenefitDetail,"^",10)		//检查
		..s TMaintenanceFee=TMaintenanceFee+$p(BenefitDetail,"^",11)	//维保
		..s TDepreFee=TDepreFee+$p(BenefitDetail,"^",12)	//折旧
		..s TOutFee=TOutFee+$p(BenefitDetail,"^",13)		//总支出
		..s TEQNum=$p(BenefitDetail,"^",15)					//设备数量
		..s TOriginalAmount=$p(BenefitDetail,"^",14)	//总原值
		..s TOtherIncome=TOtherIncome+$p(BenefitDetail,"^",18)		//其他收入
		..s TOutIncome=$p(BenefitDetail,"^",19)						//门诊收入
		..s TInIncome=TOutIncome+$p(BenefitDetail,"^",20)			//住院收入
		..s TEmergencyIncome=TEmergencyIncome+$p(BenefitDetail,"^",21)		//急诊收入
		..s TNewBornIncome=TNewBornIncome+$p(BenefitDetail,"^",22)			//新生儿
		..s THealthIncome=THealthIncome+$p(BenefitDetail,"^",23)			//体检收入
		..s TServeConsumeFee=TServeConsumeFee+$p(BenefitDetail,"^",27)		//服务项消耗
		..s TConsumeMaterialFee=TConsumeMaterialFee+$p(BenefitDetail,"^",28)	//消耗性材料
		..s TTrainFee=TTrainFee+$p(BenefitDetail,"^",29)			//培训费
		..s TMeasureFee=TMeasureFee+$p(BenefitDetail,"^",30)		//计量费
		..s TQualityControlFee=TQualityControlFee+$p(BenefitDetail,"^",31)	//质控费
		.s TStartMonth=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUserID,EQLocID,""))
		.s TEndMonth=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUserID,EQLocID,""),-1)
		.i TStartMonth=TEndMonth s TMonth=TStartMonth
		.e  s TMonth=TStartMonth_"~"_TEndMonth
		.s TInComeAmount=TInComeAmount+TInCome
		.s TOutFeeAmount=TOutFeeAmount+TOutFee
		.s vLocBenefitInfo="^^"_TInComeAmount_"^^^^^^^^^^"_TOutFeeAmount
		.s LocQoQInfo=##Class(web.DHCEQ.BA.RPTCommon).GetBAQoQRate(vStartDate,vEndDate,"",EQLocID,"","","",vLocBenefitInfo,vPeriodType)
		.s LocYoYInfo=##Class(web.DHCEQ.BA.RPTCommon).GetBAYoYRate(vStartDate,vEndDate,"",EQLocID,"","","",vLocBenefitInfo,vPeriodType)
		.s TInComeChainRatio=$p(LocQoQInfo,"^",1)		//收入环比
		.s TOutFeeChainRatio=$p(LocQoQInfo,"^",2)		//支出环比
		.s TInComeYearOnYearRate=$p(LocYoYInfo,"^",1)	//收入同比
		.s TOutFeeYearOnYearRate=$p(LocYoYInfo,"^",2)	//支出同比
		.i TInComeChainRatio'="" s TInComeChainRatio=TInComeChainRatio_% e  s TInComeChainRatio="--"
		.i TOutFeeChainRatio'="" s TOutFeeChainRatio=TOutFeeChainRatio_% e  s TOutFeeChainRatio="--"
		.i TInComeYearOnYearRate'="" s TInComeYearOnYearRate=TInComeYearOnYearRate_% e  s TInComeYearOnYearRate="--"
		.i TOutFeeYearOnYearRate'="" s TOutFeeYearOnYearRate=TOutFeeYearOnYearRate_% e  s TOutFeeYearOnYearRate="--"
		.i +TMonthDays'=0 d
		..s TPerDayIncome=##Class(web.DHCEQCommon).FormatNumber(TInCome/TMonthDays,"",2)	//日均收入
		..s TPerDayOutFee=##Class(web.DHCEQCommon).FormatNumber(TOutFee/TMonthDays,"",2)	//日均支出
		.i +TOutFee'=0 s TInOutRate=##Class(web.DHCEQCommon).FormatNumber(TInCome/TOutFee,"",2)	//收支比
		.d OutPutLocBenefitInfo
	}
	i Type=1	//按月输出
	{
		s EQLocID=""
		f  s EQLocID=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUserID,EQLocID)) q:EQLocID=""  d
		.q:(StoreLocDR'="")&&(StoreLocDR'=EQLocID)
		.s Month=""
		.f  s Month=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUserID,EQLocID,Month)) q:Month=""  d
		..d ResetLocBenefitInfo
		..s TMonthDays=TMonthDays+##class(web.DHCEQCommon).GetMonthEndDate(Month,"1")
		..s TStoreLocID=EQLocID
		..s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocID)
		..s TMonth=Month
		..s BenefitDetail=$g(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUserID,EQLocID,Month))
		..s TFactualWorkLoad=$p(BenefitDetail,"^",1)
		..s TWorkLoadPerMonth=$p(BenefitDetail,"^",2)
		..s TInCome=$p(BenefitDetail,"^",3)
		..s TConsumableFee=$p(BenefitDetail,"^",4)
		..s TPersonFee=$p(BenefitDetail,"^",5)
		..s TWEFee=$p(BenefitDetail,"^",6)
		..s THouseFee=$p(BenefitDetail,"^",7)
		..s TMaintFee=$p(BenefitDetail,"^",8)
		..s TMaintainFee=$p(BenefitDetail,"^",9)
		..s TInSpectFee=$p(BenefitDetail,"^",10)
		..s TMaintenanceFee=$p(BenefitDetail,"^",11)
		..s TDepreFee=$p(BenefitDetail,"^",12)
		..s TOutFee=$p(BenefitDetail,"^",13)
		..s TOriginalAmount=$p(BenefitDetail,"^",14)
		..s TEQNum=$p(BenefitDetail,"^",15)
		..s TOtherIncome=$p(BenefitDetail,"^",18)			//其他收入
		..s TOutIncome=$p(BenefitDetail,"^",19)				//门诊收入
		..s TInIncome=$p(BenefitDetail,"^",20)				//住院收入
		..s TEmergencyIncome=$p(BenefitDetail,"^",21)		//急诊收入
		..s TNewBornIncome=$p(BenefitDetail,"^",22)			//新生儿
		..s THealthIncome=$p(BenefitDetail,"^",23)			//体检收入
		..s TServeConsumeFee=$p(BenefitDetail,"^",27)		//服务项消耗
		..s TConsumeMaterialFee=$p(BenefitDetail,"^",28)	//消耗性材料
		..s TTrainFee=$p(BenefitDetail,"^",29)			//培训费
		..s TMeasureFee=$p(BenefitDetail,"^",30)		//计量费
		..s TQualityControlFee=$p(BenefitDetail,"^",31)	//质控费
		..i +TMonthDays'=0 d
		...s TPerDayIncome=##Class(web.DHCEQCommon).FormatNumber(TInCome/TMonthDays,"",2)	//日均收入
		...s TPerDayOutFee=##Class(web.DHCEQCommon).FormatNumber(TOutFee/TMonthDays,"",2)	//日均支出
		..i +TOutFee'=0 s TInOutRate=##Class(web.DHCEQCommon).FormatNumber(TInCome/TOutFee,"",2)	//收支比
		..;获取环比信息		//CZF0133 2021-02-24 begin
		..s LastPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-1,TMonth)
		..s LastRtnStr=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr(LastPeriod,LastPeriod,"",TStoreLocID,"","","")
		..s LastInCome=+$p(LastRtnStr,"^",3)
		..s LastOutFee=+$p(LastRtnStr,"^",13)
		..i LastInCome'=0 s TInComeChainRatio=##Class(web.DHCEQCommon).FormatNumber(((TInCome-LastInCome)/LastInCome*100),"",2)_"%"
		..e  s TInComeChainRatio="--"
		..i LastOutFee'=0 s TOutFeeChainRatio=##Class(web.DHCEQCommon).FormatNumber(((TOutFee-LastOutFee)/LastOutFee*100),"",2)_"%"
		..e  s TOutFeeChainRatio="--"
		..;获取同比信息
		..s CorrespondingPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,TMonth)
		..s CorrespondingRtnStr=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr(CorrespondingPeriod,CorrespondingPeriod,"",TStoreLocID,"","","")
		..s CorrespondingInCome=+$p(CorrespondingRtnStr,"^",3)
		..s CorrespondingOutFee=+$p(CorrespondingRtnStr,"^",13)
		..i CorrespondingInCome'=0 s TInComeYearOnYearRate=##Class(web.DHCEQCommon).FormatNumber(((TInCome-CorrespondingInCome)/CorrespondingInCome*100),"",2)_"%"
		..e  s TInComeYearOnYearRate="--"
		..i CorrespondingOutFee'=0 s TOutFeeYearOnYearRate=##Class(web.DHCEQCommon).FormatNumber(((TOutFee-CorrespondingOutFee)/CorrespondingOutFee*100),"",2)_"%"
		..e  s TOutFeeYearOnYearRate="--"
		..d OutPutLocBenefitInfo
	}
	Quit $$$OK
ResetLocBenefitInfo
	s (TStoreLocID,TStoreLoc,TFactualWorkLoad,TWorkLoadPerMonth,TInCome,TConsumableFee,TPersonFee,TWEFee,THouseFee,TMaintFee,TMaintainFee,TInSpectFee,TMaintenanceFee,TDepreFee,TOutFee,TOriginalAmount,TEQNum,TInComeChainRatio,TOutFeeChainRatio,TInComeYearOnYearRate,TOutFeeYearOnYearRate)=0
	s (TOtherIncome,TOutIncome,TInIncome,TEmergencyIncome,TNewBornIncome,THealthIncome,TPerDayIncome,TPerDayOutFee,TInOutRate,TMonthDays,TInComeAmount,TOutFeeAmount)=0
	s (TServeConsumeFee,TConsumeMaterialFee,TTrainFee,TMeasureFee,TQualityControlFee)=0
	s TMonth=""
	quit
	
OutPutLocBenefitInfo
	s Data=$lb(TStoreLocID,TStoreLoc,TFactualWorkLoad,TWorkLoadPerMonth,TInCome,TConsumableFee,TPersonFee,TWEFee,THouseFee,TMaintFee,TMaintainFee,TInSpectFee,TMaintenanceFee,TDepreFee,TOutFee,TOriginalAmount,TEQNum,TMonth,TInComeChainRatio,TOutFeeChainRatio,TInComeYearOnYearRate,TOutFeeYearOnYearRate,TOtherIncome,TOutIncome,TInIncome,TEmergencyIncome,TNewBornIncome,THealthIncome,TPerDayIncome,TPerDayOutFee,TInOutRate,TServeConsumeFee,TConsumeMaterialFee,TTrainFee,TMeasureFee,TQualityControlFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetLocBenefitInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocBenefitInfoExecute ]
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

ClassMethod GetLocBenefitInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocBenefitInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// czf 2020-08-07
/// 获取设备类型效益分析明细信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.RPTList","GetStatCatBenefitInfo","web.DHCEQ.BA.RPTEchart_GetBenefitAnaly","18364","78","","0","2019-07","","HalfYear")
Query GetStatCatBenefitInfo(nodestr As %String = "", EJob As %String = "", CurUserID As %String = "", StatCatDR As %String = "", Type As %String = "", vStartDate As %String = "", vEndDate As %String = "", vPeriodType As %String = "") As %Query(ROWSPEC = "TStatCatID:%String,TStatCat:%String,TFactualWorkLoad:%String,TWorkLoadPerMonth:%String,TInCome:%String,TConsumableFee:%String,TPersonFee:%String,TWEFee:%String,THouseFee:%String,TMaintFee:%String,TMaintainFee:%String,TInSpectFee:%String,TMaintenanceFee:%String,TDepreFee:%String,TOutFee:%String,TOriginalAmount:%String,TEQNum:%String,TMonth:%String,TInComeChainRatio:%String,TOutFeeChainRatio:%String,TInComeYearOnYearRate:%String,TOutFeeYearOnYearRate:%String,TOtherIncome:%String,TOutIncome:%String,TInIncome:%String,TEmergencyIncome:%String,TNewBornIncome:%String,THealthIncome:%String,TPerDayIncome:%String,TPerDayOutFee:%String,TInOutRate:%String,TServeConsumeFee:%String,TConsumeMaterialFee:%String,TTrainFee:%String,TMeasureFee:%String,TQualityControlFee:%String")
{
}

ClassMethod GetStatCatBenefitInfoExecute(ByRef qHandle As %Binary, nodestr As %String = "", EJob As %String = "", CurUserID As %String = "", StatCatDR As %String = "", Type As %String = "", vStartDate As %String = "", vEndDate As %String = "", vPeriodType As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Date=+$h
	
	i CurUserID="" s CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i (nodestr="")||(EJob="")||(CurUserID="") Quit $$$OK
	
	i (Type="")||(Type=0)
	{
		s StatCatID=""
		f  s StatCatID=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUserID,StatCatID)) q:StatCatID=""  d
		.q:(StatCatDR'="")&&(StatCatDR'=StatCatID)
		.d ResetStatCatBenefitInfo
		.s TStatCatID=StatCatID
		.s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatID)
		.s Month=""
		.f  s Month=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUserID,StatCatID,Month)) q:Month=""  d
		..s BenefitDetail=$g(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUserID,StatCatID,Month))
		..s TMonthDays=TMonthDays+##class(web.DHCEQCommon).GetMonthEndDate(Month,"1")
		..s TFactualWorkLoad=TFactualWorkLoad+$p(BenefitDetail,"^",1)
		..s TWorkLoadPerMonth=TWorkLoadPerMonth+$p(BenefitDetail,"^",2)
		..s TInCome=TInCome+$p(BenefitDetail,"^",3)
		..s TConsumableFee=TConsumableFee+$p(BenefitDetail,"^",4)
		..s TPersonFee=TPersonFee+$p(BenefitDetail,"^",5)
		..s TWEFee=TWEFee+$p(BenefitDetail,"^",6)
		..s THouseFee=THouseFee+$p(BenefitDetail,"^",7)
		..s TMaintFee=TMaintFee+$p(BenefitDetail,"^",8)
		..s TMaintainFee=TMaintainFee+$p(BenefitDetail,"^",9)
		..s TInSpectFee=TInSpectFee+$p(BenefitDetail,"^",10)
		..s TMaintenanceFee=TMaintenanceFee+$p(BenefitDetail,"^",11)
		..s TDepreFee=TDepreFee+$p(BenefitDetail,"^",12)
		..s TOutFee=TOutFee+$p(BenefitDetail,"^",13)
		..s TOriginalAmount=$p(BenefitDetail,"^",14)
		..s TEQNum=$p(BenefitDetail,"^",15)
		..s TOtherIncome=$p(BenefitDetail,"^",18)			//其他收入
		..s TOutIncome=$p(BenefitDetail,"^",19)				//门诊收入
		..s TInIncome=$p(BenefitDetail,"^",20)				//住院收入
		..s TEmergencyIncome=$p(BenefitDetail,"^",21)		//急诊收入
		..s TNewBornIncome=$p(BenefitDetail,"^",22)			//新生儿
		..s THealthIncome=$p(BenefitDetail,"^",23)			//体检收入
		..s TServeConsumeFee=TServeConsumeFee+$p(BenefitDetail,"^",27)		//服务项消耗
		..s TConsumeMaterialFee=TConsumeMaterialFee+$p(BenefitDetail,"^",28)	//消耗性材料
		..s TTrainFee=TTrainFee+$p(BenefitDetail,"^",29)			//培训费
		..s TMeasureFee=TMeasureFee+$p(BenefitDetail,"^",30)		//计量费
		..s TQualityControlFee=TQualityControlFee+$p(BenefitDetail,"^",31)	//质控费
		.s TStartMonth=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUserID,StatCatID,""))
		.s TEndMonth=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUserID,StatCatID,""),-1)
		.i TStartMonth=TEndMonth s TMonth=TStartMonth
		.e  s TMonth=TStartMonth_"~"_TEndMonth
		.s TInComeAmount=TInComeAmount+TInCome
		.s TOutFeeAmount=TOutFeeAmount+TOutFee			//
		.s vLocBenefitInfo="^^"_TInComeAmount_"^^^^^^^^^^"_TOutFeeAmount
		.s LocQoQInfo=##Class(web.DHCEQ.BA.RPTCommon).GetBAQoQRate(vStartDate,vEndDate,"","",StatCatID,"","",vLocBenefitInfo,vPeriodType)
		.s LocYoYInfo=##Class(web.DHCEQ.BA.RPTCommon).GetBAYoYRate(vStartDate,vEndDate,"","",StatCatID,"","",vLocBenefitInfo,vPeriodType)
		.s TInComeChainRatio=$p(LocQoQInfo,"^",1)		//收入环比
		.s TOutFeeChainRatio=$p(LocQoQInfo,"^",2)		//支出环比
		.s TInComeYearOnYearRate=$p(LocYoYInfo,"^",1)	//收入同比
		.s TOutFeeYearOnYearRate=$p(LocYoYInfo,"^",2)	//支出同比
		.i TInComeChainRatio'="" s TInComeChainRatio=TInComeChainRatio_% e  s TInComeChainRatio="--"
		.i TOutFeeChainRatio'="" s TOutFeeChainRatio=TOutFeeChainRatio_% e  s TOutFeeChainRatio="--"
		.i TInComeYearOnYearRate'="" s TInComeYearOnYearRate=TInComeYearOnYearRate_% e  s TInComeYearOnYearRate="--"
		.i TOutFeeYearOnYearRate'="" s TOutFeeYearOnYearRate=TOutFeeYearOnYearRate_% e  s TOutFeeYearOnYearRate="--"
		.i +TMonthDays'=0 d
		..s TPerDayIncome=##Class(web.DHCEQCommon).FormatNumber(TInCome/TMonthDays,"",2)	//日均收入
		..s TPerDayOutFee=##Class(web.DHCEQCommon).FormatNumber(TOutFee/TMonthDays,"",2)	//日均支出
		.i +TOutFee'=0 s TInOutRate=##Class(web.DHCEQCommon).FormatNumber(TInCome/TOutFee,"",2)	//收支比
		.d OutPutStatCatBenefitInfo
	}
	i Type=1
	{
		s StatCatID=""
		f  s StatCatID=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUserID,StatCatID)) q:StatCatID=""  d
		.q:(StatCatDR'="")&&(StatCatDR'=StatCatID)
		.s Month=""
		.f  s Month=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUserID,StatCatID,Month)) q:Month=""  d
		..d ResetStatCatBenefitInfo
		..s TMonthDays=TMonthDays+##class(web.DHCEQCommon).GetMonthEndDate(Month,"1")
		..s TMonth=Month
		..s TStatCatID=StatCatID
		..s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatID)
		..s BenefitDetail=$g(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUserID,StatCatID,Month))
		..s TFactualWorkLoad=$p(BenefitDetail,"^",1)
		..s TWorkLoadPerMonth=$p(BenefitDetail,"^",2)
		..s TInCome=$p(BenefitDetail,"^",3)
		..s TConsumableFee=$p(BenefitDetail,"^",4)
		..s TPersonFee=$p(BenefitDetail,"^",5)
		..s TWEFee=$p(BenefitDetail,"^",6)
		..s THouseFee=$p(BenefitDetail,"^",7)
		..s TMaintFee=$p(BenefitDetail,"^",8)
		..s TMaintainFee=$p(BenefitDetail,"^",9)
		..s TInSpectFee=$p(BenefitDetail,"^",10)
		..s TMaintenanceFee=$p(BenefitDetail,"^",11)
		..s TDepreFee=$p(BenefitDetail,"^",12)
		..s TOutFee=$p(BenefitDetail,"^",13)
		..s TOriginalAmount=$p(BenefitDetail,"^",14)
		..s TEQNum=$p(BenefitDetail,"^",15)
		..s TOtherIncome=$p(BenefitDetail,"^",18)			//其他收入
		..s TOutIncome=$p(BenefitDetail,"^",19)				//门诊收入
		..s TInIncome=$p(BenefitDetail,"^",20)				//住院收入
		..s TEmergencyIncome=$p(BenefitDetail,"^",21)		//急诊收入
		..s TNewBornIncome=$p(BenefitDetail,"^",22)			//新生儿
		..s THealthIncome=$p(BenefitDetail,"^",23)			//体检收入
		..s TServeConsumeFee=$p(BenefitDetail,"^",27)		//服务项消耗
		..s TConsumeMaterialFee=$p(BenefitDetail,"^",28)	//消耗性材料
		..s TTrainFee=$p(BenefitDetail,"^",29)			//培训费
		..s TMeasureFee=$p(BenefitDetail,"^",30)		//计量费
		..s TQualityControlFee=$p(BenefitDetail,"^",31)	//质控费
		..i +TMonthDays'=0 d
		...s TPerDayIncome=##Class(web.DHCEQCommon).FormatNumber(TInCome/TMonthDays,"",2)	//日均收入
		...s TPerDayOutFee=##Class(web.DHCEQCommon).FormatNumber(TOutFee/TMonthDays,"",2)	//日均支出
		..i +TOutFee'=0 s TInOutRate=##Class(web.DHCEQCommon).FormatNumber(TInCome/TOutFee,"",2)	//收支比
		..;获取环比信息
		..s LastPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-1,TMonth)
		..s LastRtnStr=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr(LastPeriod,LastPeriod,"","",TStatCatID,"","")
		..s LastInCome=+$p(LastRtnStr,"^",3)
		..s LastOutFee=+$p(LastRtnStr,"^",13)
		..i LastInCome'=0 d
		...s InComeChainRatio=(TInCome-LastInCome)/LastInCome*100
		...s TInComeChainRatio=##Class(web.DHCEQCommon).FormatNumber(InComeChainRatio,"",2)
		...s TInComeChainRatio=TInComeChainRatio_"%"
		..e  s TInComeChainRatio="--"
		..i LastOutFee'=0 d
		...s OutFeeChainRatio=(TOutFee-LastOutFee)/LastOutFee*100
		...s TOutFeeChainRatio=##Class(web.DHCEQCommon).FormatNumber(OutFeeChainRatio,"",2)
		...s TOutFeeChainRatio=TOutFeeChainRatio_"%"
		..e  s TOutFeeChainRatio="--"
		..;获取同比信息
		..s CorrespondingPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,TMonth)
		..s CorrespondingRtnStr=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr(CorrespondingPeriod,CorrespondingPeriod,"","",TStatCatID,"","")
		..s CorrespondingInCome=+$p(CorrespondingRtnStr,"^",3)
		..s CorrespondingOutFee=+$p(CorrespondingRtnStr,"^",13)
		..i CorrespondingInCome'=0 d
		...s InComeYearOnYearRate=(TInCome-CorrespondingInCome)/CorrespondingInCome*100
		...s TInComeYearOnYearRate=##Class(web.DHCEQCommon).FormatNumber(InComeYearOnYearRate,"",2)
		...s TInComeYearOnYearRate=TInComeYearOnYearRate_"%"
		..e  s TInComeYearOnYearRate="--"
		..i CorrespondingOutFee'=0 d
		...s OutFeeYearOnYearRate=(TOutFee-CorrespondingOutFee)/CorrespondingOutFee*100
		...s TOutFeeYearOnYearRate=##Class(web.DHCEQCommon).FormatNumber(OutFeeYearOnYearRate,"",2)
		...s TOutFeeYearOnYearRate=TOutFeeYearOnYearRate_"%"
		..e  s TOutFeeYearOnYearRate="--"
		..d OutPutStatCatBenefitInfo
	}
	
	Quit $$$OK
ResetStatCatBenefitInfo
	s (TStatCatID,TStatCat,TFactualWorkLoad,TWorkLoadPerMonth,TInCome,TConsumableFee,TPersonFee,TWEFee,THouseFee,TMaintFee,TMaintainFee,TInSpectFee,TMaintenanceFee,TDepreFee,TOutFee,TOriginalAmount,TEQNum,TInComeChainRatio,TOutFeeChainRatio,TInComeYearOnYearRate,TOutFeeYearOnYearRate)=0
	s (TOtherIncome,TOutIncome,TInIncome,TEmergencyIncome,TNewBornIncome,THealthIncome,TPerDayIncome,TPerDayOutFee,TInOutRate,TMonthDays,TInComeAmount,TOutFeeAmount)=0
	s (TServeConsumeFee,TConsumeMaterialFee,TTrainFee,TMeasureFee,TQualityControlFee)=0
	s TMonth=""
	quit
	
OutPutStatCatBenefitInfo
	s Data=$lb(TStatCatID,TStatCat,TFactualWorkLoad,TWorkLoadPerMonth,TInCome,TConsumableFee,TPersonFee,TWEFee,THouseFee,TMaintFee,TMaintainFee,TInSpectFee,TMaintenanceFee,TDepreFee,TOutFee,TOriginalAmount,TEQNum,TMonth,TInComeChainRatio,TOutFeeChainRatio,TInComeYearOnYearRate,TOutFeeYearOnYearRate,TOtherIncome,TOutIncome,TInIncome,TEmergencyIncome,TNewBornIncome,THealthIncome,TPerDayIncome,TPerDayOutFee,TInOutRate,TServeConsumeFee,TConsumeMaterialFee,TTrainFee,TMeasureFee,TQualityControlFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetStatCatBenefitInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatCatBenefitInfoExecute ]
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

ClassMethod GetStatCatBenefitInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatCatBenefitInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
