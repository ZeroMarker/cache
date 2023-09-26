Class web.DHCEQMonthDepreset Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 296;

// 计提折旧

/// 0 没有   1已有
ClassMethod CheckEquipMonthDepred(EquipDR, Month)
{
	s Depreset=..CheckEquipDepreSet(EquipDR)
	i Depreset=0 q 0
	s MonthDepreDR=0
	s Flag="N"
	f  s MonthDepreDR=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipDR,Month,MonthDepreDR)) q:(MonthDepreDR="")||(Flag="Y")  d
	.s DepreSetDR=$p(^DHCEQMonthDepre(MonthDepreDR),"^",2)
	.q:DepreSetDR'=Depreset
	.s MDStatus=$p($g(^DHCEQMonthDepre(MonthDepreDR)),"^",20)	//DJ0136
	.q:MDStatus="3"
	.s Flag="Y"
	i Flag="N" q 0
	q 1
	/*&SQL(select MD_RowID from sqluser.DHC_EQMonthDepre where MD_EquipDR=:EquipDR and MD_DepreMonth=:Month and MD_DepreSetDR=:Depreset)
	i SQLCODE
	{
		q 0 //没有
	}
	q 1 //已有*/
}

ClassMethod CheckEquipDepreSet(EquipDR)
{
	s DepreMehtod=""
	s DepreSetDR=""
	s DepreMethod=$P(^DHCEQEquip(EquipDR),"^",33)
	i DepreMethod="" q 0
	s DepreSetDR=0
	s ReturnDR=""
	s MainFlag="N"
	f  s DepreSetDR=$o(^DHCEQDepreSet(0,"Equip",EquipDR,DepreSetDR)) q:(DepreSetDR="")||(MainFlag="Y")  d
	.s DepreMethodDR=$P(^DHCEQDepreSet(DepreSetDR),"^",2)
	.q:DepreMethodDR'=DepreMethod
	.s MainFlag=$P(^DHCEQDepreSet(DepreSetDR),"^",3)
	.i MainFlag="Y" s ReturnDR=DepreSetDR
	i MainFlag="N" q 0
	q ReturnDR
	/*&SQL(select DS_RowID into :DepreSetDR from sqluser.DHC_EQDepreSet where DS_DepreMethodDR=:DepreMethod and DS_EquipDR=:EquipDR and DS_MainFlag='Y')
	i SQLCODE
	{
		q 0 //没有设置
	}
	q DepreSetDR  //设置*/
}

ClassMethod GetTotalDepreMonth(EquipID, DepreSet)
{
	s Total=0
	&SQL(select Count(MD_RowID) into :Total from sqluser.DHC_EQMonthDepre where MD_EquipDR=:EquipID and MD_DepreSetDR=:DepreSet)
	i Total="" s Total=0
	q Total
}

ClassMethod GetTotalWorkLoad(EquipID, DepreMonth)
{
	s Total=0
	i (DepreMonth="") q 0
	s DepreDate=$ZDH(DepreMonth_"-01",3)
	&sql(select sum(UR_WorkLoadNum) into:Total from SQLUSER.DHC_EQUseRecord 
	where UR_SourceType=1 and UR_SourceID=:EquipID and UR_UseDate>=:DepreDate and UR_UseDate<DateAdd('mm',1,:DepreDate))
	i Total="" s Total=0
	q Total
}

ClassMethod GetEquipNetFee(EquipID, CurFee)
{
	s NetFee=$P(^DHCEQEquip(EquipID),"^",28)
	i NetFee="" s NetFee=0
	q NetFee-CurFee
}

ClassMethod GetEquipDepreTotalFee(EquipID, CurFee)
{
	s DepreFee=$P(^DHCEQEquip(EquipID),"^",35)
	i DepreFee="" s DepreFee=0
	q DepreFee+CurFee
}

ClassMethod GetEquipStatusDisplay(status As %Library.String) As %Status
{
	i status=""  q ""
	i +status=0  q "新增"
	i +status=1  q "启用"
	i +status=2  q "封存"
	i +status=3  q "报废"
	i +status=4  q "其他"
	q "未定义"
}

/// 判断折旧设备是否本月后入库设备Y是本月后
ClassMethod IsAfterCurMonthInStock(EndDate, rowid)
{
	new CSID,Date
	s CSID=0
	s CSID=$o(^DHCEQChangeStock(0,"Source","0",rowid,0))
	i CSID="" q "N"
	s Date=$p(^DHCEQChangeStock(CSID),"^",9)
	i Date'<EndDate q "Y"
	q "N"
}

/// -------华山月度折旧报表
/// 2009-07-21 党军 增加：EquipTypeDR参数
/// d ##class(%ResultSet).RunQuery("web.DHCEQMonthDepreset","GetDepreReport","")
Query GetDepreReport(BeginDate As %Library.String = "", EndDate As %Library.String = "", UseLocDR As %Library.String = "", IsMainFlag As %Library.String = "Y", EquipTypeIDS As %Library.String = "", QXType As %String = "", FundsTypeDR As %String = "") As %Query(ROWSPEC = "TLocDR:%String,TLocDesc:%String,TEquipType:%String,TEquipTypeDesc:%String,TDepreFee:%String,TJob:%String,TFundsType:%String")
{
}

ClassMethod GetDepreReportExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", UseLocDR As %Library.String = "", IsMainFlag As %Library.String = "Y", EquipTypeIDS As %Library.String = "", QXType As %String = "", FundsTypeDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i EquipTypeIDS'="" s EquipTypeIDS=","_EquipTypeIDS_","
	;s ^TempDHCEQ("jdl")=BeginDate_"^"_EndDate_"^"_UseLocDR_"^"_IsMainFlag
	if ((BeginDate="")&&(EndDate="")) Quit $$$OK	
	s job=$j
	k ^TempDHCEQ("MonthDepreReport",job)
	k ^TempDHCEQ("MonthDepreReport","Out",job)
	s start=0
	i BeginDate'="" s start=BeginDate-1
	s end=+$H
	i EndDate'="" s end=EndDate
	s locdr=0
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	s ETIDS=##Class(web.DHCEQCommon).GetEquipTypesByGroup("")
	s EquipTypeIDS="^"_ETIDS_"^"
	f  s locdr=$o(^DHCEQMonthDepre(0,"Loc",locdr))  quit:locdr=""  d
	.;q:((UseLocDR'="")&&(UseLocDR'=locdr))
	.;q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,locdr))) //2010-10-29 DJ
	.s auditdate=start
	.f  s auditdate=$o(^DHCEQMonthDepre(0,"Loc",locdr,auditdate))  quit:((auditdate="")||(auditdate>end))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQMonthDepre(0,"Loc",locdr,auditdate,rowid))  quit:((rowid=""))  d
	...s depredata=$g(^DHCEQMonthDepre(rowid))
	...q:($p(depredata,"^",3)'=IsMainFlag)
	...s MDStatus=$p($g(^DHCEQMonthDepre(rowid)),"^",20)	//DJ0136
	...q:MDStatus="3"
	...s equipid=$p(depredata,"^",1)
	...s equiptype=$p($g(^DHCEQEquip(equipid)),"^",63)
	...q:(EquipTypeIDS'="")&&(EquipTypeIDS'[("^"_equiptype_"^")) //2009-07-21 党军
	...s deprefee=##Class(web.DHCEQCommon).FormatNumber($p(depredata,"^",14),"")
	...//分摊费用 2010-12-17 党军 begin
	...s CADRowID=0
	...s CADFlag=0
	...f  s CADRowID=$o(^DHCEQCostAllotDetail(0,"SourceID",rowid,CADRowID)) q:CADRowID=""  d
	....s CADFlag=CADFlag+1
	....s CurLocDR=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",3)
	....q:((UseLocDR'="")&&(UseLocDR'=CurLocDR))
	....q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,CurLocDR)))
	....s deprefee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQCostAllotDetail(CADRowID)),"^",5),"")
	....s TFundsType=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",7)
	....i TFundsType="" s TFundsType=SelfFundsFlag
	....q:(FundsTypeDR'="")&&(TFundsType'=FundsTypeDR)
	....s ^TempDHCEQ("MonthDepreReport",job,CurLocDR,equiptype,TFundsType)=deprefee+$g(^TempDHCEQ("MonthDepreReport",job,CurLocDR,equiptype,TFundsType))
	...// 2010-12-17 党军 end
	...i CADFlag=0  d
	....q:((UseLocDR'="")&&(UseLocDR'=locdr))
	....q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,locdr)))
	....q:(FundsTypeDR'="")&&(SelfFundsFlag'=FundsTypeDR)
	....s ^TempDHCEQ("MonthDepreReport",job,locdr,equiptype,SelfFundsFlag)=deprefee+$g(^TempDHCEQ("MonthDepreReport",job,locdr,equiptype,SelfFundsFlag))
	
	s locdr=0
	s num=1
	f  s locdr=$o(^TempDHCEQ("MonthDepreReport",job,locdr))  quit:locdr=""  d
	.s equiptype=0
	.f  s equiptype=$o(^TempDHCEQ("MonthDepreReport",job,locdr,equiptype))  quit:equiptype=""  d
	..s FundsTypeID=0
	..f  s FundsTypeID=$o(^TempDHCEQ("MonthDepreReport",job,locdr,equiptype,FundsTypeID))  quit:FundsTypeID=""  d
	...s deprefee=##Class(web.DHCEQCommon).FormatNumber(+$g(^TempDHCEQ("MonthDepreReport",job,locdr,equiptype,FundsTypeID)),"")
	...s locdesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",LocDR)
	...s locdesc=##Class(web.DHCEQCommon).GetSplitDataByFlag(locdesc,"-")
	...s equiptypedesc=$p($g(^DHCEQCCode("DHCEQCEquipType",equiptype)),"^",2)
	...s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FundsTypeID)),"^",2)
	...d OutputRowGetDepreReport
	...s ^TempDHCEQ("MonthDepreReport","Out",job,0,num)=locdesc_"^"_equiptypedesc_"^"_deprefee_"^"_TFundsType
	...s num=num+1
	
	k ^TempDHCEQ("MonthDepreReport",job)
	Quit $$$OK
	
OutputRowGetDepreReport
	s Data=$lb(locdr,locdesc,equiptype,equiptypedesc,deprefee,job,TFundsType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetDepreReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepreReportExecute ]
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

ClassMethod GetDepreReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepreReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDepreLoc(num, job As %Library.String = "")
{
	i job="" s job=$j
	q $g(^TempDHCEQ("MonthDepreReport","Out",job,0,num))
}

/// /折旧明细
/// d ##class(%ResultSet).RunQuery("web.DHCEQMonthDepreset","GetDepreList","2014-9","","","Y","0","","410","90")
Query GetDepreList(BeginDate As %Library.String = "", EndDate As %Library.String = "", UseLocDR As %Library.String = "", IsMainFlag As %Library.String = "Y", QXType As %String = "", FundsTypeDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", CTLocID As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TDepreSetDR:%String,TMainFlag:%String,TDepreMethodDR:%String,TOriginalFee:%String,TDepreMonth:%String,TDesignWorkLoadNum:%String,TWorkLoadUnitDR:%String,TLimitYearsNum:%String,TDepreMonthsNum:%String,TPreTotalWorkloadFee:%String,TPreTotalDepreFee:%String,TWorkLoadNum:%String,TDepreFee:%String,TCostAllotType:%String,TCostAllotDR:%String,TNetFee:%String,TNetRemainFee:%String,TAllotFlag:%String,TStatus:%String,TRemark:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TDepreType:%String,TAffixDR:%String,TLocDR:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TEquip:%String,TDepreSet:%String,TDepreMethod:%String,TWorkLoadUnit:%String,TCostAllot:%String,TAddUser:%String,TUpdateUser:%String,TAuditUser:%String,TAffix:%String,TLoc:%String,TEquipNo:%String,TStartDate:%String,TEndDate:%String,TPreFee:%String,TFundsType:%String,TEquipType:%String,TJob:%String") [ SqlProc ]
{
}

ClassMethod GetDepreListExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", UseLocDR As %Library.String = "", IsMainFlag As %Library.String = "Y", QXType As %String = "", FundsTypeDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", CTLocID As %String = "", CurGroupID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i CTLocID'="" s CTLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",CTLocID)    //Modefied by zc0050  2019-10-19  CTLocID取值对应DHCEQCDepartment表中的值
	s num=1
	s (OriginalFeeTotal,PreFeeTotal,NetFeeTotal,DepreFeeTotal)=0
	///s ^TempDHCEQ("jdl")=BeginDate_"^"_EndDate_"^"_LocDR_"^"_IsMainFlag
	if ((BeginDate="")&&(EndDate="")) Quit $$$OK	
	s job=$j
	k ^TempDHCEQ("MonthDepreList","Out",job)
	s start=0
	i BeginDate'="" s start=BeginDate-1
	s end=+$H
	i EndDate'="" s end=EndDate
	s locdr=0
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	s ETIDS=##class(web.DHCEQCommon).GetEquipTypesByGroup(CurGroupID) //2009-10-18 党军
	s EquipTypeIDS="^"_ETIDS_"^" //2009-10-18 党军
	f  s locdr=$o(^DHCEQMonthDepre(0,"Loc",locdr))  quit:locdr=""  d
	.;q:((UseLocDR'="")&&(UseLocDR'=locdr))
	.;q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,locdr))) //2010-10-29 DJ
	.s auditdate=start
	.f  s auditdate=$o(^DHCEQMonthDepre(0,"Loc",locdr,auditdate))  quit:((auditdate="")||(auditdate>end))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQMonthDepre(0,"Loc",locdr,auditdate,rowid))  quit:((rowid=""))  d
	...s depredata=$g(^DHCEQMonthDepre(rowid))
	...q:($p(depredata,"^",3)'=IsMainFlag)
	...s MDStatus=$p($g(^DHCEQMonthDepre(rowid)),"^",20)	//DJ0136
	...q:MDStatus="3"
	...s equipid=$p(depredata,"^",1)
	...s equiptype=$p($g(^DHCEQEquip(equipid)),"^",63)
	...s StatCat=$p($g(^DHCEQEquip(equipid)),"^",75)
	...s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(equipid)),"^",27),"")
	...q:(MinValue'="")&&(MinValue>OriginalFee)
	...q:(MaxValue'="")&&(MaxValue<OriginalFee)  //MR 0009
	...q:(EquipTypeIDS'="")&&(EquipTypeIDS'[("^"_equiptype_"^")) //2009-07-21 党军
	...q:(EquipTypeDR'="")&&(EquipTypeDR'=equiptype)
	...q:(StatCatDR'="")&&(StatCatDR'=StatCat)  //MR 0009
	...s CADRowID=0
	...s CADFlag=0
	...f  s CADRowID=$o(^DHCEQCostAllotDetail(0,"SourceID",rowid,CADRowID)) q:CADRowID=""  d
	....s CADType=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",1)
	....q:CADType'=1
	....s CADLoc=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",3)
	....q:((UseLocDR'="")&&(UseLocDR'=CADLoc))
	....q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,CADLoc,CTLocID, CurGroupID)))
	....s TFundsTypeDR=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",7)
	....i TFundsTypeDR="" s TFundsTypeDR=SelfFundsFlag
	....q:(FundsTypeDR'="")&&(TFundsTypeDR'=FundsTypeDR)
	....s DepreFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQCostAllotDetail(CADRowID)),"^",5),"")
	....s CADFlag=1
	....d BuildDataDepreList
	....d OutputRowGetDepreList
	....s ^TempDHCEQ("MonthDepreList","Out",job,0,num)=TRowID_"^"_TEquipDR_"^"_TDepreSetDR_"^"_TMainFlag_"^"_TDepreMethodDR_"^"_TOriginalFee_"^"_TDepreMonth_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnitDR_"^"_TLimitYearsNum_"^"_TDepreMonthsNum_"^"_TPreTotalWorkloadFee_"^"_TPreTotalDepreFee_"^"_TWorkLoadNum_"^"_TDepreFee_"^"_TCostAllotType_"^"_TCostAllotDR_"^"_TNetFee_"^"_TNetRemainFee_"^"_TAllotFlag_"^"_TStatus_"^"_TRemark_"^"_TAddUserDR_"^"_TAddDate_"^"_TAddTime_"^"_TUpdateUserDR_"^"_TUpdateDate_"^"_TUpdateTime_"^"_TAuditUserDR_"^"_TAuditDate_"^"_TAuditTime_"^"_TDepreType_"^"_TAffixDR_"^"_TLocDR_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TEquip_"^"_TDepreSet_"^"_TDepreMethod_"^"_TWorkLoadUnit_"^"_TCostAllot_"^"_TAddUser_"^"_TUpdateUser_"^"_TAuditUser_"^"_TAffix_"^"_TLoc_"^"_TEquipNo_"^"_TStartDate_"^"_TEndDate_"^"_TPreFee_"^"_TFundsType
	....s num=num+1
	...i CADFlag=0  d
	....q:((UseLocDR'="")&&(UseLocDR'=locdr))
	....q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,locdr,CTLocID, CurGroupID)))
	....s TFundsTypeDR=SelfFundsFlag
	....q:(FundsTypeDR'="")&&(TFundsTypeDR'=FundsTypeDR)
	....s DepreFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthDepre(rowid)),"^",14),"")
	....s CADLoc=locdr
	....d BuildDataDepreList
	....d OutputRowGetDepreList
	....s ^TempDHCEQ("MonthDepreList","Out",job,0,num)=TRowID_"^"_TEquipDR_"^"_TDepreSetDR_"^"_TMainFlag_"^"_TDepreMethodDR_"^"_TOriginalFee_"^"_TDepreMonth_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnitDR_"^"_TLimitYearsNum_"^"_TDepreMonthsNum_"^"_TPreTotalWorkloadFee_"^"_TPreTotalDepreFee_"^"_TWorkLoadNum_"^"_TDepreFee_"^"_TCostAllotType_"^"_TCostAllotDR_"^"_TNetFee_"^"_TNetRemainFee_"^"_TAllotFlag_"^"_TStatus_"^"_TRemark_"^"_TAddUserDR_"^"_TAddDate_"^"_TAddTime_"^"_TUpdateUserDR_"^"_TUpdateDate_"^"_TUpdateTime_"^"_TAuditUserDR_"^"_TAuditDate_"^"_TAuditTime_"^"_TDepreType_"^"_TAffixDR_"^"_TLocDR_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TEquip_"^"_TDepreSet_"^"_TDepreMethod_"^"_TWorkLoadUnit_"^"_TCostAllot_"^"_TAddUser_"^"_TUpdateUser_"^"_TAuditUser_"^"_TAffix_"^"_TLoc_"^"_TEquipNo_"^"_TStartDate_"^"_TEndDate_"^"_TPreFee_"^"_TFundsType
	....s num=num+1		
	Quit $$$OK
BuildDataDepreList
	s (TRowID,TEquipDR,TDepreSetDR,TMainFlag,TDepreMethodDR,TOriginalFee,TDepreMonth,TDesignWorkLoadNum,TWorkLoadUnitDR,TLimitYearsNum,TDepreMonthsNum,TPreTotalWorkloadFee,TPreTotalDepreFee,TWorkLoadNum,TDepreFee,TCostAllotType,TCostAllotDR,TNetFee,TNetRemainFee,TAllotFlag,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TDepreType,TAffixDR,TLocDR,THold1,THold2,THold3,THold4,THold5,TEquip,TDepreSet,TDepreMethod,TWorkLoadUnit,TCostAllot,TAddUser,TUpdateUser,TAuditUser,TAffix,TLoc,TEquipNo,TStartDate,TEndDate,TPreFee,TFundsType,TEquipType)=""
	s TRowID = rowid
	s TEquipDR = $p($g(^DHCEQMonthDepre(rowid)),"^",1)
	i TEquipDR '=""  d
	.s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TEquipTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",63)	//Add 2013-12-5 HZY 
	.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2) //Modify DJ 2015-07-14 DJ0147 
	.s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.s TStartDate=$p($g(^DHCEQEquip(TEquipDR)),"^",45)
	.i TStartDate=""  d
	..s TStartDate=$p($g(^DHCEQEquip(TEquipDR)),"^",70)
	..i TStartDate'="" s TStartDate=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(TStartDate)),"^",1))),"^",13)
	.i TStartDate'=""  d
	..
	..s limitYears=$p($g(^DHCEQEquip(TEquipDR)),"^",31)
	..i limitYears'=""  d
	...//s ^TempDHCEQ("jdl")="&"_limitYears_"&"_$zd(TStartDate,4)
	...s TEndDate=##Class(web.DHCEQCommon).DateAdd("d",-1,$zd(TStartDate,4))
	...s TEndDate=##Class(web.DHCEQCommon).DateAddApp("yyyy",limitYears,TEndDate)
	...///s TEndDate=$zd(TStartDate,4)
	..///s TStartDate=##Class(web.DHCEQCommon).DateAdd("d",0,$zd(TStartDate,4))
	..s TStartDate=##Class(web.DHCEQCommon).DateAddApp("yyyy",0,$zd(TStartDate,4))
	..///s TStartDate=##Class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	
	
	s TDepreSetDR = $p($g(^DHCEQMonthDepre(rowid)),"^",2)
	///i TDepreSetDR '=""  d
	///.s TDepreSet = $p($g(^DHCEQDepreSet(TDepreSetDR)),"^",XX)
	s TMainFlag = $p($g(^DHCEQMonthDepre(rowid)),"^",3)
	s TDepreMethodDR = $p($g(^DHCEQMonthDepre(rowid)),"^",4)
	i TDepreMethodDR '=""  d
	.s TDepreMethod = $p($g(^DHCEQCDepreMethod(TDepreMethodDR)),"^",2)
	s TOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthDepre(rowid)),"^",5),"")
	s TDepreMonth = $p($g(^DHCEQMonthDepre(rowid)),"^",6)
	s TDesignWorkLoadNum = $p($g(^DHCEQMonthDepre(rowid)),"^",7)
	s TWorkLoadUnitDR = $p($g(^DHCEQMonthDepre(rowid)),"^",8)
	i TWorkLoadUnitDR '=""  d
	.s TWorkLoadUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",(TWorkLoadUnitDR))	;Modified By jdl 20150906 v4.1.0 规范单位取值
	s TLimitYearsNum = $p($g(^DHCEQMonthDepre(rowid)),"^",9)
	s TDepreMonthsNum = $p($g(^DHCEQMonthDepre(rowid)),"^",10)
	s TPreTotalWorkloadFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthDepre(rowid)),"^",11),"")
	s TPreTotalDepreFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthDepre(rowid)),"^",12),"")
	s TWorkLoadNum = $p($g(^DHCEQMonthDepre(rowid)),"^",13)
	s TDepreFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthDepre(rowid)),"^",14),"")
	s TCostAllotType = $p($g(^DHCEQMonthDepre(rowid)),"^",15)
	s TCostAllotDR = $p($g(^DHCEQMonthDepre(rowid)),"^",16)
	///i TCostAllotDR '=""  d
	///.s TCostAllot = $p($g(^DHCEQCostAllot(TCostAllotDR)),"^",XX)
	s TNetFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthDepre(rowid)),"^",17),"")
	s TNetFee = ##Class(web.DHCEQCommon).FormatNumber(TNetFee-TDepreFee,"")
	s TDepreFee=##Class(web.DHCEQCommon).FormatNumber(DepreFee,"")
	s TNetRemainFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthDepre(rowid)),"^",18),"")
	s TAllotFlag = $p($g(^DHCEQMonthDepre(rowid)),"^",19)
	s TStatus = $p($g(^DHCEQMonthDepre(rowid)),"^",20)
	s TRemark = $p($g(^DHCEQMonthDepre(rowid)),"^",21)
	s TAddUserDR = $p($g(^DHCEQMonthDepre(rowid)),"^",22)
	i TAddUserDR '=""  d
	.s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMonthDepre(rowid)),"^",23),"date")
	s TAddTime = $p($g(^DHCEQMonthDepre(rowid)),"^",24)
	s TUpdateUserDR = $p($g(^DHCEQMonthDepre(rowid)),"^",25)
	i TUpdateUserDR '=""  d
	.s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMonthDepre(rowid)),"^",26),"date")
	s TUpdateTime = $p($g(^DHCEQMonthDepre(rowid)),"^",27)
	s TAuditUserDR = $p($g(^DHCEQMonthDepre(rowid)),"^",28)
	i TAuditUserDR '=""  d
	.s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	s TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMonthDepre(rowid)),"^",29),"date")
	s TAuditTime = $p($g(^DHCEQMonthDepre(rowid)),"^",30)
	s TDepreType = $p($g(^DHCEQMonthDepre(rowid)),"^",31)
	s TDepreType=$CASE(TDepreType,"0":"正常按月计提","1":"报废一次性计提","9":"初始化数据",:"没有定义")
	s TAffixDR = $p($g(^DHCEQMonthDepre(rowid)),"^",32)
	i TAffixDR '=""  d
	.s TAffix = $p($g(^DHCEQAffix(TAffixDR)),"^",2)
	s TLocDR = CADLoc
	i CADLoc '=""  d
	.s TLoc = $p($g(^CTLOC(CADLoc)),"^",2)
	.s TLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",CADLoc)
	s THold1 = $p($g(^DHCEQMonthDepre(rowid)),"^",34)
	s THold2 = $p($g(^DHCEQMonthDepre(rowid)),"^",35)
	s THold3 = $p($g(^DHCEQMonthDepre(rowid)),"^",36)
	s THold4 = $p($g(^DHCEQMonthDepre(rowid)),"^",37)
	s THold5 = $p($g(^DHCEQMonthDepre(rowid)),"^",38)
	
	///TEquipNo,TStartDate,TEndDate,TPreFee
	s preData=..GetPreMonthDepreInfo(TEquipDR,TDepreMonth)
	s TPreFee=##Class(web.DHCEQCommon).FormatNumber($p(preData,"^",14),"")
	s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",TFundsTypeDR)),"^",2)
	s OriginalFeeTotal=##Class(web.DHCEQCommon).FormatNumber(OriginalFeeTotal+TOriginalFee,"")
	s PreFeeTotal=##Class(web.DHCEQCommon).FormatNumber(PreFeeTotal+TPreFee,"")
	s NetFeeTotal=##Class(web.DHCEQCommon).FormatNumber(NetFeeTotal+TNetFee,"")
	s DepreFeeTotal=##Class(web.DHCEQCommon).FormatNumber(DepreFeeTotal+TDepreFee,"")
	quit
OutputRowGetDepreList
	s Data=$lb(TRowID,TEquipDR,TDepreSetDR,TMainFlag,TDepreMethodDR,TOriginalFee,TDepreMonth,TDesignWorkLoadNum,TWorkLoadUnitDR,TLimitYearsNum,TDepreMonthsNum,TPreTotalWorkloadFee,TPreTotalDepreFee,TWorkLoadNum,TDepreFee,TCostAllotType,TCostAllotDR,TNetFee,TNetRemainFee,TAllotFlag,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TDepreType,TAffixDR,TLocDR,THold1,THold2,THold3,THold4,THold5,TEquip,TDepreSet,TDepreMethod,TWorkLoadUnit,TCostAllot,TAddUser,TUpdateUser,TAuditUser,TAffix,TLoc,TEquipNo,TStartDate,TEndDate,TPreFee,TFundsType,TEquipType,job)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetDepreListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepreListExecute ]
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

ClassMethod GetDepreListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepreListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetOneDepreList(num, job)
{
	//s job=$j
	q $g(^TempDHCEQ("MonthDepreList","Out",job,0,num))
}

ClassMethod GetPreMonthDepreInfo(Equipid, Month)
{
	s preMonth=$o(^DHCEQMonthDepre(0,"EquipMonth",Equipid,Month),-1)
	if preMonth="" q ""
	s preId=$o(^DHCEQMonthDepre(0,"EquipMonth",Equipid,Month,0))
	if preId="" q ""
	q $g(^DHCEQMonthDepre(preId))
}

ClassMethod GetOverDueFlag(rowid)
{
	n TransassetDate,InStockListDR,ISRowID,MonthNum,LimitYearsNum
	s TransassetDate = $p($g(^DHCEQEquip(rowid)),"^",45)
	s LimitYearsNum = $p($g(^DHCEQEquip(rowid)),"^",31)
	i TransassetDate=""
	{
		s InStockListDR = $p($g(^DHCEQEquip(rowid)),"^",70)
		i InStockListDR'=""
		{
			s ISRowID=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
			s TransassetDate=$p(^DHCEQInStock(ISRowID),"^",13)
		}
	}
	s MonthNum=..GetMonthNum(TransassetDate,+$H)
	q LimitYearsNum*12-MonthNum
}

ClassMethod GetMonthNum(StartDate, EndDate)
{
	s StartDate=$ZD(StartDate,3)
	s EndDate=$ZD(EndDate,3)
	s SYear=+$p(StartDate,"-",1)
	s SMonth=+$p(StartDate,"-",2)
	s EYear=+$p(EndDate,"-",1)
	s EMonth=+$p(EndDate,"-",2)
	s Return=(EYear-SYear)*12+EMonth-SMonth
	q Return
}

}
