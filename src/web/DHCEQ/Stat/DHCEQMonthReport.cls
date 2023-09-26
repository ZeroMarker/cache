Class web.DHCEQ.Stat.DHCEQMonthReport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 得到结存月报的列表
/// add by jdl 2010-10-27
/// 入参：StartMonth:YYYY-MM  该参数必需
/// 	  EndMonth:YYYY-MM	该参数可选，为空时表示与StartMonth一致
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQMonthReport","MonthReport","2019-01")
Query MonthReport(MonthStr As %String = "", FundsTypeDR As %String = "", HospID As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurUserID As %String = "", AccountShape As %String = "0") As %Query(ROWSPEC = "Loc:%String,LocDesc:%String,EquipType:%String,EquipTypeDesc:%String,StatCat:%String,StatCatDesc:%String,Origin:%String,OriginDesc:%String,FundsType:%String,FundsTypeDesc:%String,FinanceType:%String,FinanceTypeDesc:%String,StockBegin:%String,StockIn:%String,StockReturn:%String,StockReduce:%String,StockMoveOut:%String,StockMoveIn:%String,StockEnd:%String,UsedBegin:%String,UsedIn:%String,UsedReturn:%String,UsedMoveIn:%String,UsedMoveOut:%String,Disused:%String,UsedEnd:%String,ChangeAccount:%String,TotalDepre:%String,Depre:%String,StockDisused:%String,StoreMoveIn:%String,StoreMoveOut:%String,NetFee:%String,StockChangeAccount:%String,UsedReduce:%String,StockOther:%String,UsedOther:%String,StoreLocCode:%String,FinaceItem:%String,FinaceItemDesc:%String,FinaceCat:%String,FinaceCatDesc:%String") [ SqlProc ]
{
}

ClassMethod MonthReportExecute(ByRef qHandle As %Binary, MonthStr As %String = "", FundsTypeDR As %String = "", HospID As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurUserID As %String = "", AccountShape As %String = "0") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
	;月份为空则返回
	q:(MonthStr="") $$$OK
 	//s User=1
 	//s CurGroupID=83
 	s User=CurUserID
 	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	i CurLocID'="" s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",CurLocID)    //Modefied by zc0050  2019-10-19  CTLocID取值对应DHCEQCDepartment表中的值
 	//s AccountShape=1
	s EquipTypeIDs=##Class(web.DHCEQCommon).GetEquipTypesByGroup(CurGroupID)
	s EquipTypeIDs= ##Class(web.DHCEQCommon).Replace(EquipTypeIDs,"^",",")
	i EquipTypeIDs="" s EquipTypeIDs=0
 	s Year=$p(MonthStr,"-",1)
 	s Month=$p(MonthStr,"-",2)
	i '$Data(^DHCEQMonthReportList(0,"Loc",Year,+Month))
	{
		;尚未月结的月份则，到业务表中获取
		s StartDate=##Class(web.DHCEQReport).GetReportDate(Year_"-"_Month,"","")
		s EndDate=$p(StartDate,"^",2)
		s StartDate=$p(StartDate,"^",1)
		
		d ##class(web.DHCEQReport).FillStatListInfo(User,Year,Month,StartDate,EndDate,EquipTypeIDs,FundsTypeDR,AccountShape) 
		
		s EquipType=0
		f  s EquipType=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType)) q:EquipType=""  d
		.s Loc=0
		.f  s Loc=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc)) q:Loc=""  d
		..///modified by zy0174  分院区管理科室过滤
		..q:(1=(##class(web.DHCEQCommon).LocIsInEQ("",Loc,CurLocID,CurGroupID,HospID)))
		..s StatCat=0
		..f  s StatCat=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat)) q:StatCat=""  d
		...
		...s Origin=""
		...f  s Origin=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin)) q:Origin=""  d
		....
		....s FundsType=""
		....f  s FundsType=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType)) q:FundsType=""  d
		.....
		.....s ListInfo=$g(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType))
		.....d OutputRowMonthReport
	}
	else
	{
		;已经月结的月份则，到月结表中获取
		s EquipType=0
		f  s EquipType=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType)) q:EquipType=""  d
		.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
		.s StatCat=0
		.f  s StatCat=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,+Month,StatCat)) q:StatCat=""  d
		..s Loc=0
		..f  s Loc=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,+Month,StatCat,Loc)) q:Loc=""  d
		...///modified by zy0174  分院区管理科室过滤
		...q:(1=(##class(web.DHCEQCommon).LocIsInEQ("",Loc,CurLocID,CurGroupID,HospID)))
		...s rowid=0
		...f  s rowid=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,+Month,StatCat,Loc,rowid)) q:rowid=""  d
		....s ListInfo=$g(^DHCEQMonthReportList(rowid))
		....//增加报表类型的判断,如果AccountShape=1 就查询财务月报的数据
		....s ReportType=+$p(ListInfo,"^",46)
		....q:(AccountShape'="")&(ReportType'=AccountShape)
		....s FundsType=$p(ListInfo,"^",38)
		....q:(FundsTypeDR'="")&&(FundsTypeDR'=FundsType)
		....s Origin=$p(ListInfo,"^",26)
		....s ListInfo=$p(ListInfo,"^",6,19)_"^"_$p(ListInfo,"^",25)_"^"_$p(ListInfo,"^",28,45)
		....d OutputRowMonthReport
	}
	Quit $$$OK
OutputRowMonthReport
	q:ListInfo=""
	s LocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",Loc)
	s StoreLocCode=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode",Loc)
	s EquipTypeDesc=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipType)
	s StatCatDesc=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",StatCat)
	s OriginDesc=##Class(web.DHCEQCommon).GetTrakNameByID("origin",Origin)
	
	s FundsTypeDesc=##Class(web.DHCEQCommon).GetTrakNameByID("fundstype",FundsType)
	s FinanceType=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^",12)
	s FinanceTypeDesc=""
	i FinanceType'="" s FinanceTypeDesc=$p($g(^DHCEQCCode("DHCEQCFinanceType",FinanceType)),"^",2)
	
	s StockBegin=$p(ListInfo,"^",1)
	s StockIn=$p(ListInfo,"^",2)
	s StockReturn=$p(ListInfo,"^",3)
	s StockReduce=$p(ListInfo,"^",4)
	s StockMoveOut=$p(ListInfo,"^",5)
	s StockMoveIn=$p(ListInfo,"^",6)
	s StockEnd=$p(ListInfo,"^",7)		
	s UsedBegin=$p(ListInfo,"^",8)
	s UsedIn=$p(ListInfo,"^",9)
	s UsedReturn=$p(ListInfo,"^",10)
	s UsedMoveIn=$p(ListInfo,"^",11)
	s UsedMoveOut=$p(ListInfo,"^",12)
	s Disused=$p(ListInfo,"^",13)
	s UsedEnd=$p(ListInfo,"^",14)
	
	s ChangeAccount=$p(ListInfo,"^",15)

	s TotalDepre=$p(ListInfo,"^",16)
	s Depre=$p(ListInfo,"^",17)
	s StockDisused=$p(ListInfo,"^",18)
	s StoreMoveIn=$p(ListInfo,"^",19)
	s StoreMoveOut=$p(ListInfo,"^",20)
		
	s NetFee=$p(ListInfo,"^",21)	
	
	s StockChangeAccount=$p(ListInfo,"^",22)
	s UsedReduce=$p(ListInfo,"^",23)
	s StockOther=$p(ListInfo,"^",24)
	s UsedOther=$p(ListInfo,"^",25)
	//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	s (FinaceItem,FinaceItemDesc,FinaceCat,FinaceCatDesc)=""
	s FinaceItem=$p(ListInfo,"^",29)
	i FinaceItem'="" s FinaceItemDesc=$p($g(^DHCEQCCode("DHCEQCFinaceItem",FinaceItem)),"^",1)
	s FinaceCat=$p(ListInfo,"^",30)
	i FinaceCat'="" s FinaceCatDesc=$p($g(^DHCEQCCode("DHCEQCFunctionCat",FinaceCat)),"^",1)
	
	s Data=$lb(Loc,LocDesc,EquipType,EquipTypeDesc,StatCat,StatCatDesc,Origin,OriginDesc,FundsType,FundsTypeDesc,FinanceType,FinanceTypeDesc,StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,ChangeAccount,TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut,NetFee,StockChangeAccount,UsedReduce,StockOther,UsedOther,StoreLocCode,FinaceItem,FinaceItemDesc,FinaceCat,FinaceCatDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
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

ClassMethod MonthReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MonthReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 业务资金月结对账查询
/// MZY0068	2021-02-02
/// 入参：	MonthStr:YYYY-MM  	查询开始月份,该参数必需
/// 		BussTypeIDs			业务ID字符串(1:期初 3:入库单增加 4:转移单增加 5:转移单减少 6:退货减少单减少 7:调账单增加 8:调账单减少
/// 										9:数据调整增加 10:数据调整减少 11:报废单减少 12:科室职能增加 13:科室职能减少 14:期末
/// 										2:本月分摊折旧 15:本月预分摊折旧)
/// 		LocDR				查询科室(DHC_EQCDepartment)
/// 		LocGT				科室职能ID字符串(DHC_EQCLocGroupType)
/// 		EquipTypeIDs		管理类组ID字符串(DHC_EQCEquipType)
/// 		StatCode			设备类型编码(DHC_EQCStatCat)
/// 		FundsTypeDR			资金来源类型ID(DHC_EQCFundsType)
/// 		StatusDisplay		设备状态("在用","在库",空则显示全部状态)
/// 		HospID				院区ID(DHC_EQCDepartment)
/// 		BussNo				业务单/设备编号(待定)
/// 		QXType				权限类型(未处理)
/// 		CurGroupID			当前安全组ID
/// 		AccountShape		入账标识(未处理)		1:已经入账
/// 		DisplayType			输出数据类型(空/0："原值"和"累计折旧"    1："原值",2："累计折旧")
/// 		EndMonth:YYYY-MM	查询结束月份(为空默认取开始月份MonthStr)
/// 		FunctionFlag		是否区分科室职能标识
/// 		StockFlag			是否区分库存标识
/// 		MarkStr				数据项串
/// 		StatFlag			统计标识(add:增加,red:减少)
/// 输出：
/// 		TBussType			业务值
/// 		TBussDesc			业务名称
/// 		TBussNo				业务单/设备编号
/// 		TEquipTypeDR,TEquipType	管理类组
/// 		TStatCode,TStatCat	类型编码,类型
/// 		TStoreLoc			科室
/// 		THospital			院区
/// 		TLGTDR				职能组值
/// 		TLocType			科室职能
/// 		TStatusDisplay		设备状态
/// 		FTRowID				资金来源值
/// 		TFundsType			资金类型
/// 		TFundsFee			资金
/// 		TDepreTotalFee		累计折旧
/// 		TDisplayTypeFee		输出数据类型
/// 		TMark:				数据项
/// 			StockBegin:SB:在库期初,StockEnd:SE:在库期末,StockIn:SI:在库增加,StockMoveIn:SMI:在库转入,StockMoveOut:SMO:在库转出,StockReturn:SR:在库退货,StockReduce:SRed:在库减少,
/// 				StoreMoveIn:MI:库房转入,StoreMoveOut:MO:库房转出,StockDisused:SD:在库报废,StockChangeAccount:SCA:在库调账,StockOther:SO:在库其他,
/// 			UsedBegin:UB:在用期初,UsedEnd:UE:在用期末,UsedIn:UI:在用增加,UsedReturn:UR:在用退货,UsedMoveIn:UMI:在用转入,UsedMoveOut:UMO:在用转出,
/// 					Disused:Dis:在用报废,ChangeAccount:CA:在用调账,UsedReduce:URed:在用减少,UsedOther:UO:在用其他
/// 职能科室变化,相关职能科室的月报报表怎么体现科室变化
/// 跨院区怎么出对账报表，跨院转移增加减少逻辑处理（在用在库区分报表情况考虑）
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQMonthReport","BussMonthReportFunds","2021-11","1,3,4,5,6,7,8,9,10,11,14","","","","","","","","","",85,"","","2021-11","","add")
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQMonthReport","BussMonthReportFunds","2021-12",1,"","","","0302",1,"",2,"","",85,"","","","")
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQMonthReport","BussMonthReportFunds","2021-12",14,"","","","0302",1,"",2,"","",85,"","","","")
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQMonthReport","BussMonthReportFunds","2021-09","6,8,10,11,13","","","","0302",1,"",2,"","",85)
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQMonthReport","BussMonthReportFunds","2021-09","14","","","","0302",1,"",2,"","",85,"","原值","2021-09","N","N","UE,SE")
Query BussMonthReportFunds(MonthStr As %String = "", BussTypeIDs As %String = "", LocDR As %String = "", LocGT As %String = "", EquipTypeIDs As %String = "", StatCode As %String = "", FundsTypeDR As %String = "", StatusDisplay As %String = "", HospID As %String = "", BussNo As %String = "", QXType As %String = "", CurGroupID As %String = "", AccountShape As %String = "0", DisplayType As %String = "", EndMonth As %String = "", FunctionFlag As %String = "", StockFlag As %String = "", MarkStr As %String = "", StatFlag As %String = "") As %Query(ROWSPEC = "TBussType:%String,TBussDesc:%String,TBussNo:%String,TEquipTypeDR:%String,TEquipType:%String,TStatCode:%String,TStatCat:%String,TStoreLoc:%String,THospital:%String,TLGTDR:%String,TLocType:%String,TStatusDisplay:%String,TFundsTypeDR:%String,TFundsType:%String,TFundsFee:%String,TDepreTotalFee:%String,TDisplayTypeFee:%String,TMark:%String") [ SqlProc ]
{
}

ClassMethod BussMonthReportFundsExecute(ByRef qHandle As %Binary, MonthStr As %String = "", BussTypeIDs As %String = "", LocDR As %String = "", LocGT As %String = "", EquipTypeIDs As %String = "", pStatCode As %String = "", FundsTypeDR As %String = "", StatusDisplay As %String = "", HospID As %String = "", BussNo As %String = "", QXType As %String = "", CurGroupID As %String = "", AccountShape As %String = "0", DisplayType As %String = "", EndMonth As %String = "", FunctionFlag As %String = "", StockFlag As %String = "", MarkStr As %String = "", StatFlag As %String = "") As %Status
{
 	new repid,index,rowid,TempID,BMRFTempID,tmpMonthStr
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	
 	;s ^DHCEQMozy("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds")=MonthStr_","_BussTypeIDs_","_LocDR_","_LocGT_","_EquipTypeIDs_","_pStatCode_","_FundsTypeDR_","_StatusDisplay_","_HospID_","_BussNo_","_QXType_","_CurGroupID_","_AccountShape_","_DisplayType_","_EndMonth_","_FunctionFlag_","_StockFlag_","_MarkStr_","_StatFlag
 	
	;月份为空则返回
	; MZY0132	2809911		2022-08-24
	;i (MonthStr="")  d
	;.s MonthStr=$zd(+$h,3)
	;.s MonthStr=+$p(MonthStr,"-",1)_"-"_+$p(MonthStr,"-",2)
	q:(MonthStr="") $$$OK
	
	
	s StartMonth=MonthStr
	i EndMonth="" s EndMonth=StartMonth
	;i (StartMonth'="2019-0")&&(##Class(web.DHCEQReport).CheckMonth(StartMonth)="1") q $$$OK
	;i (EndMonth'="2019-0")&&(##Class(web.DHCEQReport).CheckMonth(EndMonth)="1") q $$$OK
	; MZY0132	2809911		2022-08-24
	q:(('$D(^DHCEQSnapShot(0,"Month",StartMonth)))&&('$D(^DHCEQSnapShot(0,"Month",EndMonth)))) $$$OK
	i BussTypeIDs="null" s BussTypeIDs=""
 	i LocGT="null" s LocGT=""
 	i EquipTypeIDs="null" s EquipTypeIDs=""
 	i pStatCode="null" s pStatCode=""
 	i FundsTypeDR="null" s FundsTypeDR=""
 	i StatusDisplay="null" s StatusDisplay=""
	
	s BeginYear=+$p(StartMonth,"-",1)
	s BeginMonthNum=+$p(StartMonth,"-",2)
	s EndYear=+$p(EndMonth,"-",1)
	s EndMonthNum=+$p(EndMonth,"-",2)
	i ((BeginYear_$E("00",1,2-$L(BeginMonthNum))_BeginMonthNum)>(EndYear_$E("00",1,2-$L(EndMonthNum))_EndMonthNum)) q $$$OK
	
	;标准化月份(yyyy-mm)
	s StartMonth=BeginYear_"-"_$E("00",1,2-$L(BeginMonthNum))_BeginMonthNum
	s EndMonth=EndYear_"-"_$E("00",1,2-$L(EndMonthNum))_EndMonthNum
	s StartDate=##Class(web.DHCEQReport).GetReportDate(StartMonth,"","")
	s StartDate=$p(StartDate,"^",1)
	s EndDate=##Class(web.DHCEQReport).GetReportDate(EndMonth,"","")
	s EndDate=$p(EndDate,"^",2)
	Set SnapID=+$G(^DHCEQSnapShot(0,"Month",StartMonth))-1	;期初快照	各业务的设备信息(类组和类型)取自期初快照
	
	/********** i (SnapID<1)&&(+$g(^DHCEQSnapShot(1,"Begin"))>EndDate)
	{
		q $$$OK
	}
	else
	{
		s SnapID=1
	}*/
	Set EndSnapID=$G(^DHCEQSnapShot(0,"Month",EndMonth))		;期末快照
 	;If (StartSnapID<1)||(EndSnapID<1) q $$$OK
	;s User=1
 	;s CurGroupID=85
 	;i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user", %session.Get("LOGON.USERID"))
 	
 	//s AccountShape=1
	i EquipTypeIDs="" s EquipTypeIDs=##Class(web.DHCEQCommon).GetEquipTypesByGroup(CurGroupID)
	s EquipTypeIDs= ##Class(web.DHCEQCommon).Replace(EquipTypeIDs,"^",",")
	i EquipTypeIDs="" s EquipTypeIDs=0
	Set BMRFTempID=$I(^TempDHCEQ("BussMonthReportFunds",+$H))
	Do ##Class(web.DHCEQCommon).KillTempGlobalNew("BussMonthReportFunds", BMRFTempID)
	
 	Do ResetVariablesBussMonthReportFunds
 	Do ResetStatInfoVariant
	Set TBussType=1
	If (##Class(web.DHCEQCommon).IdInIds(TBussType,BussTypeIDs)=1)
	{
		Set TBussDesc="期初"
		Set CheckLocDR=""
		Do SetInfoBySnap
	}
	;w "1:"_TBussDesc,!
	
	// MZY0077	1863622		2021-05-27	修正循环月份
	Do ResetVariablesBussMonthReportFunds
	Set TBussType=2
	If (##Class(web.DHCEQCommon).IdInIds(TBussType,BussTypeIDs)=1)
	{
		Set TBussDesc="本月分摊折旧"
		s Year=BeginYear
		s Month=BeginMonthNum
		while ((Year_$E("00",1,2-$L(Month))_Month)'>(EndYear_$E("00",1,2-$L(EndMonthNum))_EndMonthNum))
		{
			s tmpMonthStr=Year_"-"_$E("-00",1,3-$L(Month))_Month
			
			s MDID=0
			f  s MDID=$o(^DHCEQMonthDepre(0,"Month",tmpMonthStr,MDID)) quit:MDID=""  d
			.Set EquipID=$p($g(^DHCEQMonthDepre(MDID)),"^",1)
			.Quit:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// 过滤设备配置的折旧
			.Set TBussNo=$p($Get(^DHCEQEquip(EquipID)),"^",71)
			.Set BIDR=$o(^DHCEQBillInfo(0,"SourceType",10,MDID,""))
			.Set TEquipTypeDR=$p($g(^DHCEQBillInfo(BIDR)),"^",3)
			.Set TStatCatDR=$p($g(^DHCEQBillInfo(BIDR)),"^",4)
			.;Quit:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR, CurGroupID)
			.Quit:##Class(web.DHCEQCommon).IdInIds(TEquipTypeDR,EquipTypeIDs)=0
			.
			.s CADID=0
			.f  s CADID=$o(^DHCEQCostAllotDetail(0,"SourceID",MDID,CADID)) quit:CADID=""  d
			..Set TStoreLocDR=$p($g(^DHCEQCostAllotDetail(CADID)),"^",3)		;折旧分摊的科室
			..Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
			..;Quit:(HospID'="")&&(THospitalDR'=HospID)
			..s FTRowID=$p($g(^DHCEQCostAllotDetail(CADID)),"^",7)
			..Quit:(FundsTypeDR'="")&&(FTRowID'=FundsTypeDR)
			..s TFundsFee="0.00"
			..s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQCostAllotDetail(CADID)),"^",5),"",2)
			..Set SourceID=CADID
			..Do SnapLocTypeInfo
			..Do AddFundsTempData
			
			s Month=Month+1
			i Month>12
			{
				s Year=Year+1
				s Month=1
			}
		}
	}
	;w "2:"_TBussDesc,!
	
	
	// 入库单
	Do ResetVariablesBussMonthReportFunds
	Set TBussType=3
	Set TMark="SI"
	If (##Class(web.DHCEQCommon).IdInIds(TBussType,BussTypeIDs)=1)
	{
		Set TBussDesc="入库单增加"
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR)) q:TEquipTypeDR=""  d
		.q:##Class(web.DHCEQCommon).IdInIds(TEquipTypeDR,EquipTypeIDs)=0
		.s BillDate=StartDate-1
		.;i AccountShape="1" s BillDate=0	//入账时间可能是在入库之后的跨月,开始日期需要看所有入库单
		.f  s BillDate=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
		..s ISRowID=0
		..f  s ISRowID=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR,BillDate,ISRowID)) q:(ISRowID="")  d
		...q:$p($g(^DHCEQInStock(ISRowID)),"^",25)="Y"
		...q:$p($g(^DHCEQInStock(ISRowID)),"^",14)=""
		...q:$p($g(^DHCEQInStock(ISRowID)),"^",10)=3		;过滤作废
		...s TBussNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
		...//增加入账形式的参数，当AccountShape=1的时候只显示已经入账的入库单
		...;q:(AccountShape=1)&&(##Class(web.DHCEQAccountList).AccountFlag(rowid,BussType,StartDate,EndDate)=0)
		...s TStoreLocDR=$p($g(^DHCEQInStock(ISRowID)),"^",2)
		...s ListRowID=0
		...f  s ListRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ListRowID)) q:(ListRowID="")  d
		....q:$p($g(^DHCEQInStockList(ListRowID)),"^",22)'=""	// 过滤设备配置的入库明细
		....s TStatCatDR=$p($g(^DHCEQInStockList(ListRowID)),"^",17)
		....i TStatCatDR="" s TStatCatDR=$p($g(^DHCEQInStock(ISRowID)),"^",21)
		....
		....// 0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细
		....s FundsID=""
		....f  s FundsID=$o(^DHCEQFunds(0,"Source",3,ListRowID,FundsID)) quit:FundsID=""  d
		.....s FundsData=$g(^DHCEQFunds(FundsID))
		.....s FTRowID=$p(FundsData,"^",2)
		.....Quit:$p(FundsData,"^",10)="Y"		;F_InvalidFlag
		.....Quit:$p(FundsData,"^",6)="2"		;F_OperFlag
		.....Quit:(FundsTypeDR'="")&&(FTRowID'=FundsTypeDR)
		.....Set TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",2)
		.....Set TFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",3),"",2)
		.....Set TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",13),"",2)
		.....Set SourceID=FundsID
		.....Do SnapLocTypeInfo
		.....Do AddFundsTempData
	}
	;w "3:"_TBussDesc,!
	
	
	// 转移单
	If (##Class(web.DHCEQCommon).IdInIds(4,BussTypeIDs)=1)||(##Class(web.DHCEQCommon).IdInIds(5,BussTypeIDs)=1)
	{
		Do ResetVariablesBussMonthReportFunds
		
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQStoreMove(0,"TypeDate",TEquipTypeDR)) quit:TEquipTypeDR=""  d
		.;Quit:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR, CurGroupID)
		.Quit:##Class(web.DHCEQCommon).IdInIds(TEquipTypeDR,EquipTypeIDs)=0
		.s SMInAckDate=StartDate-1
		.f  s SMInAckDate=$o(^DHCEQStoreMove(0,"TypeDate",TEquipTypeDR,SMInAckDate)) quit:(SMInAckDate="")||(SMInAckDate>EndDate)  d
		..s SMRowID=0
		..f  s SMRowID=$o(^DHCEQStoreMove(0,"TypeDate",TEquipTypeDR,SMInAckDate,SMRowID)) quit:(SMRowID="")  d
		...q:$P(^DHCEQStoreMove(SMRowID),"^",27)="Y"
		...q:$P(^DHCEQStoreMove(SMRowID),"^",13)=3		;过滤作废
		...s TBussNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
		...;;;s TStatCatDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",17)
		...
		...s ListRowID=0
		...f  s ListRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,ListRowID)) quit:(ListRowID="")  d
		....q:$p($g(^DHCEQStoreMoveList(ListRowID)),"^",15)'="" 		// 过滤设备配置的转移明细
		....s EquipID=+$G(^DHCEQStoreMoveList(ListRowID,"EX","RowIDs"))
		....;; DHC_EQBillInfo	0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细 9:调整数据 10:折旧
		....Set BIDR=$o(^DHCEQBillInfo(0,"SourceType",4,ListRowID,""))
		....Set TStatCatDR=$p($g(^DHCEQBillInfo(BIDR)),"^",4)
		....;w SnapID_":"_TBussNo_":"_EquipID_"-"_TStatCatDR,!
		....
		....// 0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细
		....s FundsID=""
		....f  s FundsID=$o(^DHCEQFunds(0,"Source",4,ListRowID,FundsID)) quit:FundsID=""  d
		.....s FundsData=$g(^DHCEQFunds(FundsID))
		.....s FTRowID=$p(FundsData,"^",2)
		.....Quit:$p(FundsData,"^",10)="Y"		;F_InvalidFlag
		.....Quit:$p(FundsData,"^",6)="2"		;F_OperFlag
		.....Quit:(FundsTypeDR'="")&&(FTRowID'=FundsTypeDR)
		.....Set TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",2)
		.....Set TFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",3),"",2)
		.....Set TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",13),"",2)
		.....Set TBussType=5
		.....Set TBussDesc="转移单减少"
		.....;不区分院区时  供给部门和接收部门同院区则过滤
		.....Quit:(HospID="")&&(##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID($p($g(^DHCEQStoreMove(SMRowID)),"^",2))=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID($p($g(^DHCEQStoreMove(SMRowID)),"^",3)))&&(FunctionFlag'="Y")&&(StockFlag'="Y")
		.....
		.....;SM_MoveType	"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退库","4":"库房调配"
		.....if $p($g(^DHCEQStoreMove(SMRowID)),"^",12)="0"  d
		......Set TMark="SMO"	;s StockMoveOut=FundsFee
		.....e  i $p($g(^DHCEQStoreMove(SMRowID)),"^",12)="1"  d
		......Set TMark="UMO"	;s UsedMoveOut=FundsFee
		.....e  i $p($g(^DHCEQStoreMove(SMRowID)),"^",12)="3"  d
		......Set TMark="UR"	;s UsedReturn=FundsFee
		.....e  i $p($g(^DHCEQStoreMove(SMRowID)),"^",12)="4"  d
		......Set TMark="MO"	;s StoreMoveOut=FundsFee
		.....
		.....Set TStoreLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)
		.....Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
		.....Set SourceID=FundsID
		.....Do SnapLocTypeInfo
		.....Do AddFundsTempData
		.....
		.....Set TBussType=4
		.....Set TBussDesc="转移单增加"
		.....
		.....;SM_MoveType
		.....if $p($g(^DHCEQStoreMove(SMRowID)),"^",12)="0"  d
		......Set TMark="UI"	;s UsedIn=FundsFee
		.....e  i $p($g(^DHCEQStoreMove(SMRowID)),"^",12)="1"  d
		......Set TMark="UMI"	;s UsedMoveIn=FundsFee
		.....e  i $p($g(^DHCEQStoreMove(SMRowID)),"^",12)="3"  d
		......Set TMark="SMI"	;s StockMoveIn=FundsFee
		.....e  i $p($g(^DHCEQStoreMove(SMRowID)),"^",12)="4"  d
		......Set TMark="MI"	;s StoreMoveIn=FundsFee
		.....
		.....Set TStoreLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
		.....Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
		.....;Quit:(HospID'="")&&(THospitalDR'=HospID)
		.....Do SnapLocTypeInfo
		.....Do AddFundsTempData
	}
	;w "4-5:"_TBussDesc,!
	
	
	// 退货减少单
	Do ResetVariablesBussMonthReportFunds
	Set TBussType=6
	If ##Class(web.DHCEQCommon).IdInIds(TBussType,BussTypeIDs)=1
	{
		Set TBussDesc="退货减少单减少"
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQReturn(0,"TypeDate",TEquipTypeDR)) q:TEquipTypeDR=""  d
		.Quit:##Class(web.DHCEQCommon).IdInIds(TEquipTypeDR,EquipTypeIDs)=0
		.s OutType=0
		.f  s OutType=$o(^DHCEQReturn(0,"TypeDate",TEquipTypeDR,OutType)) q:OutType=""  d
		..s RAckDate=StartDate-1
		..f  s RAckDate=$o(^DHCEQReturn(0,"TypeDate",TEquipTypeDR,OutType,RAckDate)) q:((RAckDate="")||(RAckDate>EndDate))  d
		...s RRowID=0
		...f  s RRowID=$o(^DHCEQReturn(0,"TypeDate",TEquipTypeDR,OutType,RAckDate,RRowID)) q:(RRowID="")  d
		....q:$p($g(^DHCEQReturn(RRowID)),"^",28)="Y"
		....q:$p($g(^DHCEQReturn(RRowID)),"^",13)=3		;过滤作废
		....;当期减少金额
		....Set TStoreLocDR=$p($g(^DHCEQReturn(RRowID)),"^",2)
		....Set TBussNo=$p($g(^DHCEQReturn(RRowID)),"^",1)
		....s OutTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType", $p($g(^DHCEQReturn(RRowID)),"^",17))),"^",1)
		....i OutTypeCode="TH" d
		.....Set TMark="SR"	;s StockReturn=FundsFee	;退货费用
		....e  d
		.....;根据减少单是否有使用科室,来区分是在库减少、在用减少
		.....i $p($g(^DHCEQReturn(RRowID)),"^",24)="" d
		......Set TMark="SRed"	;s StockReduce=FundsFee	;其他减少费用
		.....e  d
		......Set TStoreLocDR=$p($g(^DHCEQReturn(RRowID)),"^",24)
		......Set TMark="URed"	;s UsedReduce=FundsFee	;其他减少费用
		....Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
		....;Quit:(HospID'="")&&(THospitalDR'=HospID)
		....
		....Do SnapLocTypeInfo
		....
		....s ListRowID=0
		....f  s ListRowID=$o(^DHCEQReturnList(0,"Return",RRowID,ListRowID)) q:(ListRowID="")  d
		.....q:($p($g(^DHCEQReturnList(ListRowID)),"^",12)'="")			// 过滤设备配置的退货明细
		.....;s EquipID=$p($g(^DHCEQReturnList(ListRowID)),"^",4)
		.....Set BIDR=$o(^DHCEQBillInfo(0,"SourceType",5,ListRowID,""))
		.....;Set TEquipTypeDR=$p($g(^DHCEQBillInfo(BIDR)),"^",3)
		.....Set TStatCatDR=$p($g(^DHCEQBillInfo(BIDR)),"^",4)
		.....
		.....// 0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细
		.....s FundsID=""
		.....f  s FundsID=$o(^DHCEQFunds(0,"Source",5,ListRowID,FundsID)) quit:FundsID=""  d
		......s FundsData=$g(^DHCEQFunds(FundsID))
		......s FTRowID=$p(FundsData,"^",2)
		......Quit:$p(FundsData,"^",10)="Y"		;F_InvalidFlag
		......Quit:$p(FundsData,"^",6)="2"		;F_OperFlag
		......Quit:(FundsTypeDR'="")&&(FTRowID'=FundsTypeDR)
		......Set TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",2)
		......Set TFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",3),"",2)
		......Set TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",13),"",2)
		......Set SourceID=FundsID
		......Do SnapLocTypeInfo
		......Do AddFundsTempData
	}
	;w "6:"_TBussDesc,!
	
	
	// 调账
	If (##Class(web.DHCEQCommon).IdInIds(7,BussTypeIDs)=1)||(##Class(web.DHCEQCommon).IdInIds(8,BussTypeIDs)=1)
	{
		Do ResetVariablesBussMonthReportFunds
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQChangeAccount(0,"TypeDate",TEquipTypeDR)) q:TEquipTypeDR=""  d
		.q:##Class(web.DHCEQCommon).IdInIds(TEquipTypeDR,EquipTypeIDs)=0
		.s CAAuditDate=StartDate-1
		.f  s CAAuditDate=$o(^DHCEQChangeAccount(0,"TypeDate",TEquipTypeDR,CAAuditDate)) q:((CAAuditDate="")||(CAAuditDate>EndDate))  d
		..s CARowID=0
		..f  s CARowID=$o(^DHCEQChangeAccount(0,"TypeDate",TEquipTypeDR,CAAuditDate,CARowID)) q:CARowID=""  d
		...Quit:$p($g(^DHCEQChangeAccount(CARowID)),"^",8)="退货自动冲减累计折旧"
		...Set EquipID=$p($g(^DHCEQChangeAccount(CARowID)),"^",1)
		...Quit:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// 过滤设备配置的折旧
		...i ($p($g(^DHCEQChangeAccount(CARowID)),"^",32)'="0")  d
		....Set TMark="CA"		;s ChangeAccount=FundsFee
		...e  d
		....Set TMark="SCA"	;s StockChangeAccount=FundsFee
		...
		...Set TStatCatDR=$p($g(^DHCEQChangeAccount(CARowID)),"^",31)
		...Set TStoreLocDR=$p($g(^DHCEQChangeAccount(CARowID)),"^",28)
		...Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
		...;Quit:(HospID'="")&&(THospitalDR'=HospID)
		...Set TBussNo=$p($g(^DHCEQEquip(EquipID)),"^",71)
		...Do SnapLocTypeInfo
		...
		...// 0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细
		...s FundsID=""
		...f  s FundsID=$o(^DHCEQFunds(0,"Source",7,CARowID,FundsID)) quit:FundsID=""  d
		....s FundsData=$g(^DHCEQFunds(FundsID))
		....s FTRowID=$p(FundsData,"^",2)
		....Quit:$p(FundsData,"^",10)="Y"		;F_InvalidFlag
		....Quit:$p(FundsData,"^",6)="2"		;F_OperFlag
		....Quit:(FundsTypeDR'="")&&(FTRowID'=FundsTypeDR)
		....Set TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",2)
		....Set TFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",3),"",2)
		....Set TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",13),"",2)
		....Set SourceID=FundsID
		....i TFundsFee>0 d
		.....Set TBussType=7
		.....Set TBussDesc="调账单增加"
		.....Do AddFundsTempData
		....e  d
		.....Set TBussType=8
		.....Set TDepreTotalFee=0-TDepreTotalFee	;调正
		.....Set TBussDesc="调账单减少"
		.....Do AddFundsTempData
	}
	;w "7-8:"_TBussDesc,!
	
	
	// 数据调整
	If (##Class(web.DHCEQCommon).IdInIds(9,BussTypeIDs)=1)||(##Class(web.DHCEQCommon).IdInIds(10,BussTypeIDs)=1)
	{
		Do ResetVariablesBussMonthReportFunds
		s BillDate=StartDate-1
		f  s BillDate=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
		.s AdjustType=0
		.f  s AdjustType=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate,AdjustType)) q:((AdjustType=""))  d
		..s rowid=0
		..f  s rowid=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate,AdjustType,rowid)) q:((rowid=""))  d
		...q:$p($g(^DHCEQAdjustData(rowid)),"^",11)'="1"
		...s ListRowID=0
		...f  s ListRowID=$o(^DHCEQAdjustDataList(0,"AdjustData",rowid,ListRowID)) q:((ListRowID=""))  d
		....Set EquipID=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",2)
		....Quit:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// 过滤设备配置的折旧
		....Set TBussNo=$p($g(^DHCEQEquip(EquipID)),"^",71)
		....
		....s FundsID=""
		....f  s FundsID=$o(^DHCEQFunds(0,"Source",9,ListRowID,FundsID)) quit:FundsID=""  d
		.....Set FundsData=$g(^DHCEQFunds(FundsID))
		.....Set FTRowID=$p(FundsData,"^",2)
		.....Quit:$p(FundsData,"^",10)="Y"		;F_InvalidFlag
		.....Quit:$p(FundsData,"^",6)="2"		;F_OperFlag
		.....Quit:(FundsTypeDR'="")&&(FTRowID'=FundsTypeDR)
		.....Set TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",2)
		.....
		.....Set SourceID=FundsID
		.....;1:调整数据 2:新增设备 3:删除数据 4:取消报废
		.....i AdjustType=1 d
		......Set TEquipTypeDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",4)
		......Quit:##Class(web.DHCEQCommon).IdInIds(TEquipTypeDR,EquipTypeIDs)=0
		......Set TStatCatDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",5)
		......Set TStoreLocDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",3)
		......Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
		......;Quit:(HospID'="")&&(THospitalDR'=HospID)
		......i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)'="0"  d
		.......Set TMark="UO"		;s UsedOther=-FundsFee
		......e  d
		.......Set TMark="SO"		;s StockOther=-FundsFee
		......Do SnapLocTypeInfo
		......Set TFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",3),"",2)
		......Set TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",13),"",2)
		......Set TBussType=10
		......Set TBussDesc="数据调整减少"
		......Do AddFundsTempData
		.....
		.....i AdjustType=1 d
		......Set TEquipTypeDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",9)
		......Quit:##Class(web.DHCEQCommon).IdInIds(TEquipTypeDR,EquipTypeIDs)=0
		......Set TStatCatDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",10)
		......Set TStoreLocDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",8)
		......Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
		......;Quit:(HospID'="")&&(THospitalDR'=HospID)
		......i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)'="0"  d
		.......Set TMark="UO"		;s UsedOther=FundsFee
		......e  d
		.......Set TMark="SO"		;s StockOther=FundsFee
		......Do SnapLocTypeInfo
		......Set TFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",3),"",2)
		......Set TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",13),"",2)
		......Set TBussType=9
		......Set TBussDesc="数据调整增加"
		......Do AddFundsTempData
		.....
		.....i AdjustType=2 d
		......Set TEquipTypeDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",9)
		......Quit:##Class(web.DHCEQCommon).IdInIds(TEquipTypeDR,EquipTypeIDs)=0
		......Set TStatCatDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",10)
		......Set TStoreLocDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",8)
		......Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
		......;Quit:(HospID'="")&&(THospitalDR'=HospID)
		......i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)'="0"  d
		.......Set TMark="UO"		;s UsedOther=FundsFee
		......e  d
		.......Set TMark="SO"		;s StockOther=FundsFee
		......Do SnapLocTypeInfo
		......Set TFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",3),"",2)
		......Set TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",13),"",2)
		......Set TBussType=9
		......Set TBussDesc="数据调整增加"
		......Do AddFundsTempData
		.....
		.....i AdjustType=3 d
		......Set TEquipTypeDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",4)
		......Quit:##Class(web.DHCEQCommon).IdInIds(TEquipTypeDR,EquipTypeIDs)=0
		......Set TStatCatDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",5)
		......Set TStoreLocDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",3)
		......Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
		......;Quit:(HospID'="")&&(THospitalDR'=HospID)
		......i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)'="0"  d
		.......Set TMark="UO"		;s UsedOther=-FundsFee
		......e  d
		.......Set TMark="SO"		;s StockOther=-FundsFee
		......Do SnapLocTypeInfo
		......Set TFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",3),"",2)
		......Set TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",13),"",2)
		......Set TBussType=10
		......Set TBussDesc="数据调整减少"
		......Do AddFundsTempData
		.....
		.....i AdjustType=4 d
		......Set TEquipTypeDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",9)
		......Quit:##Class(web.DHCEQCommon).IdInIds(TEquipTypeDR,EquipTypeIDs)=0
		......Set TStatCatDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",10)
		......Set TStoreLocDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",8)
		......Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
		......;Quit:(HospID'="")&&(THospitalDR'=HospID)
		......i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)'="0"  d
		.......Set TMark="UO"		;s UsedOther=FundsFee
		......e  d
		.......Set TMark="SO"		;s StockOther=FundsFee
		......Do SnapLocTypeInfo
		......Set TFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",3),"",2)
		......Set TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",13),"",2)
		......Set TBussType=9
		......Set TBussDesc="数据调整增加"
		......Do AddFundsTempData
	}
	;w "9-10:"_TBussDesc,!
	
	
	// 报废单
	Do ResetVariablesBussMonthReportFunds
	Set TBussType=11
	If ##Class(web.DHCEQCommon).IdInIds(TBussType,BussTypeIDs)=1
	{
		Set TBussDesc="报废单减少"
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQDisuseRequest(0,"TypeDate",TEquipTypeDR)) quit:TEquipTypeDR=""  d
		.;Quit:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
		.;Quit:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR, CurGroupID)
		.Quit:##Class(web.DHCEQCommon).IdInIds(TEquipTypeDR,EquipTypeIDs)=0
		.s DRAuditDate=StartDate-1
		.f  s DRAuditDate=$o(^DHCEQDisuseRequest(0,"TypeDate",TEquipTypeDR,DRAuditDate)) quit:(DRAuditDate="")||(DRAuditDate>EndDate)  d
		..s DRRowID=0
		..f  s DRRowID=$o(^DHCEQDisuseRequest(0,"TypeDate",TEquipTypeDR,DRAuditDate,DRRowID)) quit:(DRRowID="")  d
		...Set TBussNo=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",33)
		...s ListRowID=0
		...f  s ListRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DRRowID,ListRowID)) quit:(ListRowID="")  d
		....Set EquipID=$p($g(^DHCEQDisuseRequestList(ListRowID)),"^",2)
		....Quit:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// 过滤设备配置的报废
		....i $p($g(^DHCEQDisuseRequestList(ListRowID)),"^",11)'="0"  d
		.....Set TMark="Dis"
		....e  d
		.....Set TMark="SD"		;报废为在库的
		....Set BIDR=$o(^DHCEQBillInfo(0,"SourceType",6,ListRowID,""))
		....;Set TEquipTypeDR=$p($g(^DHCEQBillInfo(BIDR)),"^",3)
		....Set TStatCatDR=$p($g(^DHCEQBillInfo(BIDR)),"^",4)
		....Set TStoreLocDR=$p($g(^DHCEQBillInfo(BIDR)),"^",6)
		....Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
		....;Quit:(HospID'="")&&(THospitalDR'=HospID)
		....Do SnapLocTypeInfo
		....
		....// 0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细
		....s FundsID=""
		....f  s FundsID=$o(^DHCEQFunds(0,"Source",6,ListRowID,FundsID)) quit:FundsID=""  d
		.....s FundsData=$g(^DHCEQFunds(FundsID))
		.....s FTRowID=$p(FundsData,"^",2)
		.....Quit:$p(FundsData,"^",10)="Y"		;F_InvalidFlag
		.....Quit:$p(FundsData,"^",6)="2"		;F_OperFlag
		.....Quit:(FundsTypeDR'="")&&(FTRowID'=FundsTypeDR)
		.....Set TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",2)
		.....Set TFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",3),"",2)
		.....Set TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",13),"",2)
		.....Set SourceID=FundsID
		.....Do SnapLocTypeInfo
		.....Do AddFundsTempData
	}
	;w "11:"_TBussDesc,!
	
	
	// 科室职能
	If (##Class(web.DHCEQCommon).IdInIds(12,BussTypeIDs)=1)||(##Class(web.DHCEQCommon).IdInIds(13,BussTypeIDs)=1)
	{
		;s ^DHCEQSnapShot(SnapID,"LocType",LTType,LTLocDR,LTRowID)=$g(^DHCEQCCode("DHCEQCLocType",LTRowID))
		Do ResetVariablesBussMonthReportFunds
		// 设置快照科室职能数据
		; d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQMonthReport","BussMonthReportFunds","2020-12","","","","","","","",85,202,12214)
		Set TempID=$I(^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H))
		Do ##Class(web.DHCEQCommon).KillTempGlobalNew("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",TempID)
		;Set ^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H,TempID,AdjustDataDR)=FundsFee
		Set node="Start"
		Do SetTmpLocType
		
		Set node="End"
		i EndSnapID'=""
		{
			Set SnapID=EndSnapID
			Do SetTmpLocType
		}
		else
		{
			s LTType=""
			f  s LTType=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LTType)) quit:LTType=""  d
			.q:$p($g(^DHCEQCCode("DHCEQCLocGroupType",LTType)),"^",5)'="N"		;无效标志
			.;期初快照科室职能类型
			.// MZY0069	1737181		2021-02-18
			.s LTLocDR=0
			.f  s LTLocDR=$o(^DHCEQSnapShot(SnapID,"LocType",LTType,LTLocDR)) quit:LTLocDR=""  d
			..i '$d(^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H,TempID,LTLocDR)) Set ^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H,TempID,LTLocDR)="在用"
			..i ($p($g(^DHCEQCCode("DHCEQCLocGroupType",LTType)),"^",1)=1)&&($p($g(^DHCEQCCode("DHCEQCLocGroupType",LTType)),"^",3)="库房") Set ^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H,TempID,LTLocDR)="在库"
			..
			..q:$p($g(^DHCEQCCode("DHCEQCLocGroupType",LTType)),"^",1)'=2		;过滤非职能科室	 MZY0069	1737181		2021-02-18
			..Set ^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H,TempID,LTLocDR,node)=LTType
		}
		
		s LTLocDR=""
		f  s LTLocDR=$o(^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H,TempID,LTLocDR)) quit:LTLocDR=""  d
		.q:($g(^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H,TempID,LTLocDR,"Start"))=$g(^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H,TempID,LTLocDR,"End")))
		.s SType=$g(^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H,TempID,LTLocDR,"Start"))
		.s EType=$g(^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H,TempID,LTLocDR,"End"))
		.
		.i SType'="" d
		..Set TBussType=13
		..Set TBussDesc="科室职能减少"
		..Set CheckLocDR=LTLocDR
		..Set TLGTDR=SType
		..Quit:(LocGT'="")&&(##Class(web.DHCEQCommon).IdInIds(TLGTDR,LocGT)=0)
		..Do SetInfoBySnap
		.
		.i EType'="" d
		..Set TBussType=12
		..Set TBussDesc="科室职能增加"
		..Set CheckLocDR=LTLocDR
		..Set TLGTDR=EType
		..Quit:(LocGT'="")&&(##Class(web.DHCEQCommon).IdInIds(TLGTDR,LocGT)=0)
		..Do SetInfoBySnap
	}
	;w "12-13:"_TBussDesc,!
	
	Do ResetVariablesBussMonthReportFunds
	Set TBussType=14
	If ##Class(web.DHCEQCommon).IdInIds(TBussType,BussTypeIDs)=1
	{
		Set TBussDesc="期末"
		Set CheckLocDR=""
		i EndSnapID'=""
		{
			Set SnapID=EndSnapID
			Do SetInfoBySnap
		}
		else
		{
			s EquipID=0
			f  s EquipID=$o(^DHCEQEquip(EquipID)) quit:EquipID=""  d
			.Set EquipData=$Get(^DHCEQEquip(EquipID))
			.Quit:$p(EquipData,"^",38)=3
			.Quit:$p(EquipData,"^",59)'="N"
			.Quit:$p(EquipData,"^",60)=0
			.Quit:$p(EquipData,"^",60)=3
			.Set TBussNo=$p(EquipData,"^",71)
			.Set TEquipTypeDR=$p(EquipData,"^",63)
			.;Quit:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
			.;Quit:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR, CurGroupID)
			.Quit:##Class(web.DHCEQCommon).IdInIds(TEquipTypeDR,EquipTypeIDs)=0
			.Set TStatCatDR=$p(EquipData,"^",75)
			.Set TStoreLocDR=$p(EquipData,"^",67)
			.Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
			.;Quit:(HospID'="")&&(THospitalDR'=HospID)
			.
			.;^DHCEQCCode("DHCEQCLocType",0,"LocType",10,202,495)
			.Set TLGTDR=-1
			.s TStatusDisplay="在用"
			.Set TMark="UE"		;UsedEnd:UE:在用期末
			.s LGT=""
			.f  s LGT=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGT)) quit:LGT=""  d
			..q:$p($g(^DHCEQCCode("DHCEQCLocGroupType",LGT)),"^",5)'="N"	;无效标志
			..s LTLocDR=""
			..f  s LTLocDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGT,LTLocDR)) quit:LTLocDR=""  d
			...Quit:LTLocDR'=TStoreLocDR
			...i ($p($g(^DHCEQCCode("DHCEQCLocGroupType",LGT)),"^",2)="0101") d
			....s TStatusDisplay="在库"
			....Set TMark="SE"		;StockEnd:SE:在库期末
			...q:$p($g(^DHCEQCCode("DHCEQCLocGroupType",LGT)),"^",1)'=2		;过滤非职能科室
			...Set TLGTDR=LGT
			.
			.s FundsID=""
			.f  s FundsID=$o(^DHCEQFunds(0,"Equip",EquipID,FundsID)) quit:FundsID=""  d
			..s FundsData=$g(^DHCEQFunds(FundsID))
			..s FTRowID=$p(FundsData,"^",2)
			..Quit:$p(FundsData,"^",10)="Y"		;F_InvalidFlag
			..Quit:$p(FundsData,"^",6)="2"		;F_OperFlag
			..Quit:(FundsTypeDR'="")&&(FTRowID'=FundsTypeDR)
			..s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",2)
			..s TFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",3),"",2)
			..s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",13),"",2)
			..Set SourceID=FundsID
			..
			..Do AddFundsTempData
		}
	}
	;w "14:"_TBussDesc,!
	
	// MZY0077	1863622		2021-05-27	修正循环月份
	// 预折旧
	Do ResetVariablesBussMonthReportFunds
	Do ResetStatInfoVariant
	Set TBussType=15
	If ##Class(web.DHCEQCommon).IdInIds(TBussType,BussTypeIDs)=1
	{
		Set TBussDesc="本月预分摊折旧"
		s Year=BeginYear
		s Month=BeginMonthNum
		while ((Year_$E("00",1,2-$L(Month))_Month)'>(EndYear_$E("00",1,2-$L(EndMonthNum))_EndMonthNum))
		{
			s tmpMonthStr=Year_"-"_$E("-00",1,3-$L(Month))_Month
			
			s MDID=0
			f  s MDID=$o(^DHCEQPreMonthDepre(0,"Month",tmpMonthStr,MDID)) quit:MDID=""  d
			.Set EquipID=$p($g(^DHCEQPreMonthDepre(MDID)),"^",1)
			.Quit:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// 过滤设备配置的折旧
			.Set TBussNo=$p($Get(^DHCEQEquip(EquipID)),"^",71)
			.Set BIDR=$o(^DHCEQBillInfo(0,"SourceType",10,MDID,""))
			.Set TEquipTypeDR=$p($g(^DHCEQBillInfo(BIDR)),"^",3)
			.Set TStatCatDR=$p($g(^DHCEQBillInfo(BIDR)),"^",4)
			.;Quit:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR, CurGroupID)
			.Quit:##Class(web.DHCEQCommon).IdInIds(TEquipTypeDR,EquipTypeIDs)=0
			.
			.s CADID=0
			.f  s CADID=$o(^DHCEQPreCostAllotDetail(0,"SourceID",MDID,CADID)) quit:CADID=""  d
			..Set TStoreLocDR=$p($g(^DHCEQPreCostAllotDetail(CADID)),"^",3)		;折旧分摊的科室
			..Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
			..;Quit:(HospID'="")&&(THospitalDR'=HospID)
			..s FTRowID=$p($g(^DHCEQPreCostAllotDetail(CADID)),"^",7)
			..Quit:(FundsTypeDR'="")&&(FTRowID'=FundsTypeDR)
			..s TFundsFee="0.00"
			..s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQPreCostAllotDetail(CADID)),"^",5),"",2)
			..Set SourceID=CADID
			..Do SnapLocTypeInfo
			..Do AddFundsTempData
			
			s Month=Month+1
			i Month>12
			{
				s Year=Year+1
				s Month=1
			}
		}
	}
	;w "15:"_TBussDesc,!
	
	// 设置转移单统计标识
	;Do SetStatFlag
	
	
	// 输出结果
	Do OutputRowBussMonthReportFunds
	
	Quit $$$OK
	
SetInfoBySnap
	;s ^DHCEQSnapShot(SnapID,"Equip",rowid)=$g(^DHCEQEquip(rowid))
	;s ^DHCEQSnapShot(SnapID,"Funds",EquipID,rowid)=$g(^DHCEQFunds(rowid))
	;s ^DHCEQSnapShot(SnapID,"LocType",LTType,LTLocDR,LTRowID)=$g(^DHCEQCCode("DHCEQCLocType",LTRowID))
	q:+SnapID=0
	s EquipID=0
	f  s EquipID=$o(^DHCEQSnapShot(SnapID,"Funds",EquipID)) quit:EquipID=""  d
	.Set EquipData=$Get(^DHCEQSnapShot(SnapID,"Equip",EquipID))
	.Quit:$p(EquipData,"^",38)=3
	.Quit:$p(EquipData,"^",59)'="N"
	.Quit:$p(EquipData,"^",60)=0
	.Quit:$p(EquipData,"^",60)=3
	.;q:EquipID'=15
	.Set TEquipTypeDR=$p(EquipData,"^",63)
	.;Quit:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	.;Quit:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR, CurGroupID)
	.Quit:##Class(web.DHCEQCommon).IdInIds(TEquipTypeDR,EquipTypeIDs)=0
	.Set TStatCatDR=$p(EquipData,"^",75)
	.Set TStatCode=$p($g(^DHCEQCCode("DHCEQCStatCat", +TStatCatDR)),"^", 1)
	.Set TStoreLocDR=$p(EquipData,"^",67)
	.Quit:(CheckLocDR'="")&&(CheckLocDR'=TStoreLocDR)
	.Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
	.;Quit:(HospID'="")&&(THospitalDR'=HospID)
	.i CheckLocDR="" do SnapLocTypeInfo
	.Set TBussNo=$p(EquipData,"^",71)
	.
	.i TBussType=1 d
	..i $p(EquipData,"^",38)=1 d
	...Set TMark="UB"		;UsedBegin:UB:在用期初
	..e  d
	...Set TMark="SB"		;StockBegin:SB:在库期初
	.
	.i TBussType=14 d
	..i $p(EquipData,"^",38)=1 d
	...Set TMark="UE"		;UsedEnd:UE:在用期末
	..e  d
	...Set TMark="SE"		;StockEnd:SE:在库期末
	.
	.i TBussType=12 Set TMark="LAdd"	;Set TBussDesc="科室职能增加"
	.i TBussType=13 Set TMark="LRed"	;Set TBussDesc="科室职能减少"
	.
	.s FundsID=""
	.f  s FundsID=$o(^DHCEQSnapShot(SnapID,"Funds",EquipID,FundsID)) quit:FundsID=""  d
	..s FundsData=$g(^DHCEQSnapShot(SnapID,"Funds",EquipID,FundsID))
	..s FTRowID=$p(FundsData,"^",2)
	..Quit:$p(FundsData,"^",10)="Y"		;F_InvalidFlag
	..Quit:$p(FundsData,"^",6)="2"		;F_OperFlag
	..Quit:(FundsTypeDR'="")&&(FTRowID'=FundsTypeDR)
	..s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",2)
	..s TFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSnapShot(SnapID,"Funds",EquipID,FundsID)),"^",3),"",2)
	..s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSnapShot(SnapID,"Funds",EquipID,FundsID)),"^",13),"",2)
	..Set SourceID=FundsID
	..Do AddFundsTempData
	
	Quit
SnapLocTypeInfo
	; 快照的科室类型--库房和科室
	Set TLGTDR=-1
	s TStatusDisplay="在用"
	s LGT=""
	f  s LGT=$o(^DHCEQSnapShot(SnapID,"LocType",LGT)) quit:LGT=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCLocGroupType",LGT)),"^",5)'="N"		;无效标志
	.q:+$p($g(^DHCEQCCode("DHCEQCLocGroup",$p($g(^DHCEQCCode("DHCEQCLocGroupType",LGT)),"^",1))),"^",1)>2
	.
	.s LTLocDR=""
	.f  s LTLocDR=$o(^DHCEQSnapShot(SnapID,"LocType",LGT,LTLocDR)) quit:LTLocDR=""  d
	..q:LTLocDR'=TStoreLocDR
	..i ($p($g(^DHCEQCCode("DHCEQCLocGroupType",LGT)),"^",2)="0101") s TStatusDisplay="在库"
	..i $p($g(^DHCEQCCode("DHCEQCLocGroupType",LGT)),"^",1)=2 Set TLGTDR=LGT	;过滤非职能科室
	..Set TLGTDR=LGT
	Quit
SetTmpLocType
	; s ^DHCEQSnapShot(SnapID,"LocType",LTType,LTLocDR,LTRowID)
	s LTType=""
	f  s LTType=$o(^DHCEQSnapShot(SnapID,"LocType",LTType)) quit:LTType=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCLocGroupType",LTType)),"^",5)'="N"		;无效标志
	.q:+$p($g(^DHCEQCCode("DHCEQCLocGroup",$p($g(^DHCEQCCode("DHCEQCLocGroupType",LTType)),"^",1))),"^",1)>2
	.
	.s LTLocDR=""
	.f  s LTLocDR=$o(^DHCEQSnapShot(SnapID,"LocType",LTType,LTLocDR)) quit:LTLocDR=""  d
	..i '$d(^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H,TempID,LTLocDR)) Set ^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H,TempID,LTLocDR)="在用"
	..i ($p($g(^DHCEQCCode("DHCEQCLocGroupType",LTType)),"^",1)=1)&&($p($g(^DHCEQCCode("DHCEQCLocGroupType",LTType)),"^",3)="库房") Set ^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H,TempID,LTLocDR)="在库"
	..Quit:(LocGT'="")&&(##Class(web.DHCEQCommon).IdInIds(LTType,LocGT)=0)
	..q:$p($g(^DHCEQCCode("DHCEQCLocGroupType",LTType)),"^",1)'=2		;过滤非职能科室
	..Set ^TempDHCEQ("web.DHCEQ.Stat.DHCEQMonthReport.BussMonthReportFunds",+$H,TempID,LTLocDR,node)=LTType
	
	Quit

AddFundsTempData
	Set TDisplayTypeFee=TFundsFee	; 默认原值
	;w "AddFundsTempData"
	If DisplayType="累计折旧" Set TDisplayTypeFee=TDepreTotalFee
	Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
	Quit:(StatusDisplay'="")&&(TStatusDisplay'=StatusDisplay)
	Quit:(BussNo'="")&&(TBussNo'[BussNo)
	Quit:(HospID'="")&&(THospitalDR'=HospID)
	Quit:(BussTypeIDs'="")&&(##Class(web.DHCEQCommon).IdInIds(TBussType,BussTypeIDs)=0)
	Quit:(LocDR'="")&&(LocDR'=TStoreLocDR)
	Quit:(LocGT'="")&&(##Class(web.DHCEQCommon).IdInIds(TLGTDR,LocGT)=0)
	Set TStatCode=$p($g(^DHCEQCCode("DHCEQCStatCat", +TStatCatDR)),"^", 1)
	Quit:(pStatCode'="")&&(TStatCode'=pStatCode)
	Quit:(MarkStr'="")&&(##Class(web.DHCEQCommon).IdInIds(TMark,MarkStr)=0)
	
	;月结表输出
	; s ^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,StoreLoc,StatCat,Origin,FundsType,FinaceItem,FunctionCat)=listInfo
	; s FundsType=$o(^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType,StatCat,FundsType)) q:FundsType=""  d
	Set ^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR,TStatCatDR,TStoreLocDR,FTRowID,TMark,TFundsFee,TBussDesc,TBussNo,TLGTDR,TStatusDisplay,TDepreTotalFee,TDisplayTypeFee,SourceID)=""
	
	Quit
	
SetStatFlag
	; StatFlag=add		统计标识(add:增加,red:减少)
	s TotalAdd=+StockIn+StoreMoveIn	;库房转移入
	i ChangeAccount>0 s TotalAdd=TotalAdd+ChangeAccount
	i StockChangeAccount>0 s TotalAdd=TotalAdd+StockChangeAccount
	i StockOther>0 s TotalAdd=TotalAdd+StockOther
	i UsedOther>0 s TotalAdd=TotalAdd+UsedOther
	
	
	; StatFlag=red
	s TotalReduce=+StockReturn+StockReduce+Disused+StockDisused+UsedReduce+StoreMoveOut ;库房转移出

	i ChangeAccount<0 s TotalReduce=TotalReduce-ChangeAccount
	i StockChangeAccount<0 s TotalReduce=TotalReduce-StockChangeAccount
	i StockOther<0 s TotalReduce=TotalReduce-StockOther
	i UsedOther<0 s TotalReduce=TotalReduce-UsedOther
	
	
	; UsedIn>StockMoveOut
	; UsedMoveIn>UsedMoveOut
	; StockMoveIn>UsedReturn
	Set TMark="MO"	;s StoreMoveOut=FundsFee
	Set TMark="MI"	;s StoreMoveIn=FundsFee
	
	
	; ^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TBussDesc,TBussNo,TEquipTypeDR,TEquipType,TStatCode,TStatCat,TStoreLoc,THospital,TLGTDR,TLocType,TStatusDisplay,FTRowID,TFundsType,TFundsFee,TDepreTotalFee,TDisplayTypeFee,TMark)=""
	
	q
OutputRowBussMonthReportFunds
	
	; ^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR,TStatCatDR,TStoreLocDR,FTRowID,TMark,TFundsFee,TBussDesc,TBussNo,TLGTDR,TStatusDisplay,TDepreTotalFee,TDisplayTypeFee)=""
	s TBussType=""
	f  s TBussType=$o(^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType)) quit:TBussType=""  d
	.s TEquipTypeDR=""
	.f  s TEquipTypeDR=$o(^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR)) quit:TEquipTypeDR=""  d
	..Set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
	..s TStatCatDR=""
	..f  s TStatCatDR=$o(^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR,TStatCatDR)) quit:TStatCatDR=""  d
	...Set TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat", TStatCatDR)
	...Set TStatCode=$p($g(^DHCEQCCode("DHCEQCStatCat", +TStatCatDR)),"^", 1)
	...s TStoreLocDR=""
	...f  s TStoreLocDR=$o(^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR,TStatCatDR,TStoreLocDR)) quit:TStoreLocDR=""  d
	....Set TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TStoreLocDR)
	....Set THospital=##Class(web.DHCEQCommon).GetHospitalDesc(TStoreLocDR)
	....s FTRowID=""
	....f  s FTRowID=$o(^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR,TStatCatDR,TStoreLocDR,FTRowID)) quit:FTRowID=""  d
	.....Set TFundsType=##Class(web.DHCEQCommon).GetTrakNameByID("fundstype", FTRowID)
	.....s TMark=""
	.....f  s TMark=$o(^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR,TStatCatDR,TStoreLocDR,FTRowID,TMark)) quit:TMark=""  d
	......s TFundsFee=""
	......f  s TFundsFee=$o(^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR,TStatCatDR,TStoreLocDR,FTRowID,TMark,TFundsFee)) quit:TFundsFee=""  d
	.......s TBussDesc=""
	.......f  s TBussDesc=$o(^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR,TStatCatDR,TStoreLocDR,FTRowID,TMark,TFundsFee,TBussDesc)) quit:TBussDesc=""  d
	........s TBussNo=""
	........f  s TBussNo=$o(^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR,TStatCatDR,TStoreLocDR,FTRowID,TMark,TFundsFee,TBussDesc,TBussNo)) quit:TBussNo=""  d
	.........s tmpTLGTDR=""
	.........f  s tmpTLGTDR=$o(^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR,TStatCatDR,TStoreLocDR,FTRowID,TMark,TFundsFee,TBussDesc,TBussNo,tmpTLGTDR)) quit:tmpTLGTDR=""  d
	..........Set TLGTDR=tmpTLGTDR
	..........Set TLocType=$p($g(^DHCEQCCode("DHCEQCLocGroupType",TLGTDR)),"^",3)	;职能科室
	..........If TLocType="" Do
	...........Set TLocType="未划分科室职能"
	...........Set TLocType="--"
	...........Set TLGTDR=-1
	..........s TStatusDisplay=""
	..........f  s TStatusDisplay=$o(^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR,TStatCatDR,TStoreLocDR,FTRowID,TMark,TFundsFee,TBussDesc,TBussNo,TLGTDR,TStatusDisplay)) quit:TStatusDisplay=""  d
	...........s TDepreTotalFee=""
	...........f  s TDepreTotalFee=$o(^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR,TStatCatDR,TStoreLocDR,FTRowID,TMark,TFundsFee,TBussDesc,TBussNo,TLGTDR,TStatusDisplay,TDepreTotalFee)) quit:TDepreTotalFee=""  d
	............s TDisplayTypeFee=""
	............f  s TDisplayTypeFee=$o(^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR,TStatCatDR,TStoreLocDR,FTRowID,TMark,TFundsFee,TBussDesc,TBussNo,TLGTDR,TStatusDisplay,TDepreTotalFee,TDisplayTypeFee)) quit:TDisplayTypeFee=""  d
	.............s SourceID=""
	.............f  s SourceID=$o(^TempDHCEQ("BussMonthReportFunds",+$H,BMRFTempID,TBussType,TEquipTypeDR,TStatCatDR,TStoreLocDR,FTRowID,TMark,TFundsFee,TBussDesc,TBussNo,TLGTDR,TStatusDisplay,TDepreTotalFee,TDisplayTypeFee,SourceID)) quit:SourceID=""  d
	..............Set Data=$lb(TBussType,TBussDesc,TBussNo,TEquipTypeDR,TEquipType,TStatCode,TStatCat,TStoreLoc,THospital,TLGTDR,TLocType,TStatusDisplay,FTRowID,TFundsType,TFundsFee,TDepreTotalFee,TDisplayTypeFee,TMark)
	..............Set ^CacheTemp(repid,index)=Data
	..............Set index=index+1
	Quit
ResetVariablesBussMonthReportFunds
	Set (TBussType,TBussDesc,TBussNo,TEquipTypeDR,TEquipType,TStatCode,TStatCat,TStoreLoc,THospital,TLGTDR,TLocType,TStatusDisplay,FTRowID,TFundsType,TFundsFee,TDepreTotalFee,TDisplayTypeFee)=""
	Quit
ResetStatInfoVariant
	s (StockIn,StockReturn,StockReduce,StockMoveOut,Disused,ChangeAccount)=0
	s (StockDisused,StoreMoveIn,StoreMoveOut)=0
	s (StockChangeAccount,UsedReduce,StockOther,UsedOther)=0
}

ClassMethod BussMonthReportFundsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BussMonthReportFundsExecute ]
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

ClassMethod BussMonthReportFundsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BussMonthReportFundsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 业务对账类型列表
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQMonthReport","BussTypeList")
Query BussTypeList(BussType As %String = "") As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod BussTypeListExecute(ByRef qHandle As %Binary, BussType As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	;s ^DHCEQMozy("BussTypeList")=BussType
	s rowid=1
	s Code="01"
	s Desc="期初"
	d OutputRowBussTypeList
	s rowid=2
	s Code="02"
	s Desc="本月分摊折旧"
	d OutputRowBussTypeList
	s rowid=3
	s Code="03"
	s Desc="入库单增加"
	d OutputRowBussTypeList
	s rowid=4
	s Code="04"
	s Desc="转移单增加"
	d OutputRowBussTypeList
	s rowid=5
	s Code="05"
	s Desc="转移单减少"
	d OutputRowBussTypeList
	s rowid=6
	s Code="06"
	s Desc="退货减少单减少"
	d OutputRowBussTypeList
	s rowid=7
	s Code="07"
	s Desc="调账单增加"
	d OutputRowBussTypeList
	s rowid=8
	s Code="08"
	s Desc="调账单减少"
	d OutputRowBussTypeList
	s rowid=9
	s Code="09"
	s Desc="数据调整增加"
	d OutputRowBussTypeList
	s rowid=10
	s Code="10"
	s Desc="数据调整减少"
	d OutputRowBussTypeList
	s rowid=11
	s Code="11"
	s Desc="报废单减少"
	d OutputRowBussTypeList
	s rowid=12
	s Code="12"
	s Desc="科室职能增加"
	d OutputRowBussTypeList
	s rowid=13
	s Code="13"
	s Desc="科室职能减少"
	d OutputRowBussTypeList
	s rowid=14
	s Code="14"
	s Desc="期末"
	d OutputRowBussTypeList
	s rowid=15
	s Code="15"
	s Desc="本月预分摊折旧"
	d OutputRowBussTypeList
	
	Quit $$$OK
OutputRowBussTypeList
	Quit:(BussType'="")&&(BussType'=rowid)
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod BussTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BussTypeListExecute ]
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

ClassMethod BussTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BussTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="DHCEQMonthReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQ30C4.DHCEQMonthR30EFD</DataLocation>
<DefaultData>DHCEQMonthReportDefaultData</DefaultData>
<IdLocation>^web.DHCEQ30C4.DHCEQMonthR30EFD</IdLocation>
<IndexLocation>^web.DHCEQ30C4.DHCEQMonthR30EFI</IndexLocation>
<StreamLocation>^web.DHCEQ30C4.DHCEQMonthR30EFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
