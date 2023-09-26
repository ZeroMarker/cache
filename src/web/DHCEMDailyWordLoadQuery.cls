Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2018-11-17
/// Descript: 	急诊分诊区日工作量统计
Class web.DHCEMDailyWordLoadQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetGetEmLocBySQL() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT CTLOC_ROWID ,CTLOC_DESC FROM CT_LOC Where CTLOC_Type = 'EM'
}

/// Descritp:	病区科室
/// W ##Class(web.DHCEMPatCheckLevCom).jsonGetEmLoc("")
ClassMethod jsonGetEmLoc(HospID As %String) As %String
{
	n (HospID)
	s LocType=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTLOC_ROWID as LocDr,CTLOC_DESC as LocDesc,CTLOC_Hospital_DR as lochosp, "
	s sqlStr = sqlStr_"CTLOC_DateActiveFrom as DateFrom,CTLOC_DateActiveTo as DateTo FROM CT_LOC Where CTLOC_Type = 'EM'"

	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s DateFrom = result.Data("DateFrom")
		Continue:DateFrom>+$H
		s lochosp= result.Data("lochosp")
		s DateTo = result.Data("DateTo")
		i DateTo'="" Continue:DateTo<+$H
		s LocDr = result.Data("LocDr")
		s hosp=$p(^CTLOC(LocDr),"^",22)
		Continue:hosp'=HospID
		s LocDesc = result.Data("LocDesc")
		s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		s tmp=LocDr_"^"_LocDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-11-17
/// Descript:     急诊分诊日工作量统计
/// InPut:        StartDate - 开始日期, EndDate - 结束日期
/// OutPut:       字段对照：Schedule-班次
///               DWL01-开放床位;DWL02-期初病人数;DWL03-普通急诊内科病人数;DWL04-普通急诊外科病人数;DWL05-神经内科病人数;DWL06-眼科病人数;DWL07-耳鼻喉科病人数;DWL08-皮肤科病人数;DWL09-腹泻门诊人数;
///               DWL10-胸痛中心人数;DWL11-精神科人数;DWL12-抢救区病人数;DWL13-清创间病人数;DWL14-就诊总数;DWL15-期末病人数;DWL16-全科需入院总人数;DWL17-急诊入院人数;DWL18-等待入院人数;DWL19-院外救护车转入人数;
///               DWL20-外籍;DWL22-上感人数;DWL21-发热人数;DWL23-腹泻人数;DWL24-中毒人数;DWL25-VIP人数;DWL26-VIP时间;DWL27-三无人员;DWL28-疫情报告;DWL29-普诊其他治疗;DWL30-普诊注射人数;
///               DWL31-普诊入院;DWL32-普诊静脉采血;DWL33-群体突发事件;DWL34-危急值报告;DWL35-转分医院;DWL36-转网络医院;DWL37-群体突发事件人数;DWL38-ECG筛查
/// D ##Class(%ResultSet).RunQuery("web.DHCEMDailyWordLoadQuery","QryDailyWorkLoad","2019-09-08","2019-09-08","617")
Query QryDailyWorkLoad(StartDate As %String, EndDate As %String, LocID As %String, HOSPID As %String) As %Query(ROWSPEC = "indexNo:%String,Schedule:%String,DWL01:%Float,DWL02:%Float,DWL03:%Float,DWL04:%Float,DWL05:%Float,DWL06:%Float,DWL07:%Float,DWL08:%Float,DWL09:%Float,DWL10:%Float,DWL11:%Float,DWL12:%Float,DWL13:%Float,DWL14:%Float,DWL15:%Float,DWL16:%Float,DWL17:%Float,DWL18:%Float,DWL19:%Float,DWL20:%Float,DWL21:%Float,DWL22:%Float,DWL23:%Float,DWL24:%Float,DWL25:%Float,DWL26:%Float,DWL27:%Float,DWL28:%Float,DWL29:%Float,DWL30:%Float,DWL31:%Float,DWL32:%Float,DWL33:%Float,DWL34:%Float,DWL35:%Float,DWL36:%Float,DWL37:%Float,DWL38:%Float") [ SqlProc ]
{
}

ClassMethod QryDailyWorkLoadExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocID As %String, HOSPID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Q:(StartDate="")||(EndDate="") $$$OK
    k TmpCstArr
    s HospID=HOSPID ;s HospID=1 //hxy 2020-06-12 1->HOSPID
    /// 急诊分诊日工作量统计
	D ..GetDailyWorkLoad(StartDate, EndDate, HospID, .TmpCstArr)
	
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryDailyWorkLoadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDailyWorkLoadExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryDailyWorkLoadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDailyWorkLoadExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-29
/// Descript:     急诊分诊日工作量统计
/// InPut:        StartDate -开始日期, EndDate - 结束日期
/// OutPut:       字段对照：Schedule-班次
///               DWL01-开放床位;DWL02-期初病人数;DWL03-普通急诊内科病人数;DWL04-普通急诊外科病人数;DWL05-神经内科病人数;DWL06-眼科病人数;DWL07-耳鼻喉科病人数;DWL08-皮肤科病人数;DWL09-腹泻门诊人数;
///               DWL10-胸痛中心人数;DWL11-精神科人数;DWL12-抢救区病人数;DWL13-清创间病人数;DWL14-就诊总数;DWL15-期末病人数;DWL16-全科需入院总人数;DWL17-急诊入院人数;DWL18-等待入院人数;DWL19-院外救护车转入人数;
///               DWL20-外籍;DWL22-上感人数;DWL21-发热人数;DWL23-腹泻人数;DWL24-中毒人数;DWL25-VIP人数;DWL26-VIP时间;DWL27-三无人员;DWL28-疫情报告;DWL29-普诊其他治疗;DWL30-普诊注射人数;
///               DWL31-普诊入院;DWL32-普诊静脉采血;DWL33-群体突发事件;DWL34-危急值报告;DWL35-转分医院;DWL36-转网络医院;DWL37-群体突发事件人数;DWL38-ECG筛查
/// D ##Class(web.DHCEMDailyWordLoadQuery).GetDailyWorkLoad("2018-01-01","2018-12-31",1,.TmpCstArr)
ClassMethod GetDailyWorkLoad(StartDate As %String, EndDate As %String, HospID As %String, TmpCstArr As %String) As %String
{
	n (StartDate, EndDate, HospID, TmpCstArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	s mCode="DWL"
	k TmpItemDet
	s mID=$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:mID="" ""
	
	s Num=0
	F dd=StartDate:1:EndDate D
	.s WLID=""
	.F  s WLID=$o(^DHCEMDWL(0,"WriteDate",dd,WLID)) Q:WLID=""  D
	..s CrLoc=""
	..s CrLocID=$p(^DHCEMDWL(WLID),"^",1)    /// 科室ID
	..s CurHospID=$p($g(^CTLOC(+CrLocID)),"^",22) //hxy 2020-06-12 st
	..q:CurHospID'=HospID //ed
	..Q:$p(^DHCEMDWL(WLID),"^",7)'=mCode     /// 类型
	..s:CrLocID'="" CrLoc=$p(^CTLOC(CrLocID),"^",2)
	..s Schedule=$p(^DHCEMDWL(WLID),"^",5)   /// 班次
	..s indexNo=$s(Schedule="早班":1,Schedule="中班":2,Schedule="夜班":3,1:4)
	..s ListData=indexNo_"^"_Schedule
	..s itmID=""
	..F  s itmID=$o(^DHCEMCDI(0,"Type",mID,itmID)) Q:itmID=""  D
	...Q:$p(^DHCEMCDI(itmID),"^",3)'="Y"
	...s itmVal=0
	...s CH=$o(^DHCEMDWL(0,"ItemDr",itmID,WLID,""))
	...i CH'="" s itmVal=$p(^DHCEMDWL(WLID,"I",CH),"^",2)
	...s ListData=$s(ListData="":itmVal,1:ListData_"^"_itmVal)
	..s Num=Num+1
	..s TmpCstArr(Num)=ListData
	..
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-11-17
/// Descript:     急诊病区日工作量统计
/// InPut:        StartDate - 开始日期, EndDate - 结束日期
/// OutPut:       字段对照：  indexNo-序号,CrLoc-科室,Schedule-班次
/// 			  WWL01-原有病人数;WWL02-就诊人次;WWL03-离开人数;WWL04-现有病人数;WWL05-需入院总人数;WWL06-实际入院人数;WWL07-现等待入院人次;WWL08-出诊人次;WWL09-清创人数;WWL10-换药人数;
/// 			  WWL11-中毒人数（三区）;WWL12-发热人数（三区）;WWL13-上感人数（三区）;WWL14-腹泻人数（三区）;WWL15-外籍病人;WWL16-疫情报告（三区）;WWL17-特级护理;WWL18-一级护理;WWL19-病危人数;WWL20-抢救人数;
/// 			  WWL21-监护人数;WWL22-监护时间;WWL23-有创通气人数;WWL24-无创通气人数;WWL25-机械通气时间;WWL26-心肺复苏人数;WWL27-心肺复苏时间;WWL28-气管插管人数;WWL29-心脏按压人次;WWL30-电击除颤人数;
/// 			  WWL31-电击除颤次数;WWL32-输液人数;WWL33-静脉采血人数;WWL34-注射人数;WWL35-其他治疗;WWL36-院内抢救后死亡;WWL37-院外抢救后死亡;WWL38-来院已死亡;WWL39-抢救转入观察室;WWL40-转分医院（三区）;
/// 			  WWL41-转网络医院（三区）;WWL42-抢救室转EICU;WWL43-普诊区转二抢;WWL44-观察室转抢救室;WWL45-观察室转EICU;WWL46-清创间转抢救室;WWL47-EICU转二抢;WWL48-胸痛转观察室;WWL49-胸痛转抢救室;WWL50-胸痛转EICU;
/// 			  WWL51-总就诊时间;WWL52-复诊;WWL53-重点病种数;WWL54-纳入卒中管理人数;WWL55-抢救室转手术室;WWL56-总就诊人数
/// D ##Class(%ResultSet).RunQuery("web.DHCEMDailyWordLoadQuery","QryWardWorkLoad","2019-08-08","2019-08-08",617)
Query QryWardWorkLoad(StartDate As %String, EndDate As %String, LocID As %String, HOSPID As %String) As %Query(ROWSPEC = "indexNo:%String,CrLoc:%String,Schedule:%String,WWL01:%Float,WWL02:%Float,WWL03:%Float,WWL04:%Float,WWL05:%Float,WWL06:%Float,WWL07:%Float,WWL08:%Float,WWL09:%Float,WWL10:%Float,WWL11:%Float,WWL12:%Float,WWL13:%Float,WWL14:%Float,WWL15:%Float,WWL16:%Float,WWL17:%Float,WWL18:%Float,WWL19:%Float,WWL20:%Float,WWL21:%Float,WWL22:%Float,WWL23:%Float,WWL24:%Float,WWL25:%Float,WWL26:%Float,WWL27:%Float,WWL28:%Float,WWL29:%Float,WWL30:%Float,WWL31:%Float,WWL32:%Float,WWL33:%Float,WWL34:%Float,WWL35:%Float,WWL36:%Float,WWL37:%Float,WWL38:%Float,WWL39:%Float,WWL40:%Float,WWL41:%Float,WWL42:%Float,WWL43:%Float,WWL44:%Float,WWL45:%Float,WWL46:%Float,WWL47:%Float,WWL48:%Float,WWL49:%Float,WWL50:%Float,WWL51:%Float,WWL52:%Float,WWL53:%Float,WWL54:%Float,WWL55:%Float,WWL56:%Float") [ SqlProc ]
{
}

ClassMethod QryWardWorkLoadExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocID As %String, HOSPID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Q:(StartDate="")||(EndDate="") $$$OK
	s HospID=HOSPID ;s HospID=1 //hxy 2020-06-12 1->HOSPID
    k TmpCstArr
    
    /// 急诊病区日工作量统计
	D ..GetWardWorkLoad(StartDate, EndDate, HospID, LocID, .TmpCstArr)
	
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryWardWorkLoadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWardWorkLoadExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryWardWorkLoadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWardWorkLoadExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-29
/// Descript:     急诊分诊日工作量统计
/// InPut:        StartDate -开始日期, EndDate - 结束日期, HospID-医院ID, LocID-科室ID
/// OutPut:       字段对照： indexNo-序号,CrLoc-科室,Schedule-班次
/// 			  WWL01-原有病人数;WWL02-就诊人次;WWL03-离开人数;WWL04-现有病人数;WWL05-需入院总人数;WWL06-实际入院人数;WWL07-现等待入院人次;WWL08-出诊人次;WWL09-清创人数;WWL10-换药人数;
/// 			  WWL11-中毒人数（三区）;WWL12-发热人数（三区）;WWL13-上感人数（三区）;WWL14-腹泻人数（三区）;WWL15-外籍病人;WWL16-疫情报告（三区）;WWL17-特级护理;WWL18-一级护理;WWL19-病危人数;WWL20-抢救人数;
/// 			  WWL21-监护人数;WWL22-监护时间;WWL23-有创通气人数;WWL24-无创通气人数;WWL25-机械通气时间;WWL26-心肺复苏人数;WWL27-心肺复苏时间;WWL28-气管插管人数;WWL29-心脏按压人次;WWL30-电击除颤人数;
/// 			  WWL31-电击除颤次数;WWL32-输液人数;WWL33-静脉采血人数;WWL34-注射人数;WWL35-其他治疗;WWL36-院内抢救后死亡;WWL37-院外抢救后死亡;WWL38-来院已死亡;WWL39-抢救转入观察室;WWL40-转分医院（三区）;
/// 			  WWL41-转网络医院（三区）;WWL42-抢救室转EICU;WWL43-普诊区转二抢;WWL44-观察室转抢救室;WWL45-观察室转EICU;WWL46-清创间转抢救室;WWL47-EICU转二抢;WWL48-胸痛转观察室;WWL49-胸痛转抢救室;WWL50-胸痛转EICU;
/// 			  WWL51-总就诊时间;WWL52-复诊;WWL53-重点病种数;WWL54-纳入卒中管理人数;WWL55-抢救室转手术室;WWL56-总就诊人数
/// D ##Class(web.DHCEMDailyWordLoadQuery).GetWardWorkLoad("2018-01-01","2018-12-31",.TmpCstArr)
ClassMethod GetWardWorkLoad(StartDate As %String, EndDate As %String, HospID As %String, LocID As %String, TmpCstArr As %String) As %String
{
	n (StartDate, EndDate, HospID, LocID, TmpCstArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	s mCode="WWL"
	k TmpItemDet
	s mID=$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:mID="" ""
	
	s Num=0
	F dd=StartDate:1:EndDate D
	.s WLID=""
	.F  s WLID=$o(^DHCEMDWL(0,"WriteDate",dd,WLID)) Q:WLID=""  D
	..s CrLoc=""
	..s CrLocID=$p(^DHCEMDWL(WLID),"^",1)    /// 科室ID
	..s CurHospID=$p($g(^CTLOC(+CrLocID)),"^",22) //hxy 2020-06-12 st
	..q:CurHospID'=HospID //ed
	..Q:(LocID'="")&(LocID'=CrLocID)
	..Q:$p(^DHCEMDWL(WLID),"^",7)'=mCode     /// 类型
	..s:CrLocID'="" CrLoc=$p(^CTLOC(CrLocID),"^",2)
	..s Schedule=$p(^DHCEMDWL(WLID),"^",5)   /// 班次
	..s indexNo=$s(Schedule="早班":1,Schedule="中班":2,Schedule="夜班":3,1:4)
	..s ListData=indexNo_"^"_CrLoc_"^"_Schedule
	..s itmID=""
	..F  s itmID=$o(^DHCEMCDI(0,"Type",mID,itmID)) Q:itmID=""  D
	...Q:$p(^DHCEMCDI(itmID),"^",3)'="Y"
	...s itmVal=0
	...s CH=$o(^DHCEMDWL(0,"ItemDr",itmID,WLID,""))
	...i CH'="" s itmVal=$p(^DHCEMDWL(WLID,"I",CH),"^",2)
	...s ListData=$s(ListData="":itmVal,1:ListData_"^"_itmVal)
	..s Num=Num+1
	..s TmpCstArr(Num)=ListData
	..
	Q ""
}

/// Descript:     取指定类型代码和描述对应列表
/// W ##Class(web.DHCEMDailyWordLoadQuery).GetWorkLoadColumn("DWL")
ClassMethod GetWorkLoadColumn(mCode As %String) As %String
{
	n (mCode)
	s mID=$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),1,""))
	Q:mID="" ""
	s ListTitle=""
	s itmID=""
	F  s itmID=$o(^DHCEMCDI(0,"Type",mID,itmID)) Q:itmID=""  D
	.Q:$p(^DHCEMCDI(itmID),"^",3)'="Y"
	.s itmCode=$p(^DHCEMCDI(itmID),"^",1)  //项目代码
	.s itmDesc=$p(^DHCEMCDI(itmID),"^",2)  //项目描述
	.s ListTitle=$s(ListTitle="":itmCode_"-"_itmDesc,1:ListTitle_";"_itmCode_"-"_itmDesc)
	Q ListTitle
}

}
