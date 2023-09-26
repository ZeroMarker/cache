/// 日常监测 满意度报表后台
Class web.CSSDHUI.Stat.SurveyStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

///  Creator:ban
///  CreatDate:2022-4-28
///  Description:满意度调查结果
///  Table:CSSD_Satisfaction
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.SurveyStat","SelectAllSatisfaction","{""ReportType"":""FlagStatSatisfaction"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""StartDate"":""2022-05-20"",""EndDate"":""2022-05-20""}")
Query SelectAllSatisfaction(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "RowId:%String,SatisfactionDesc,Type,CheckResult:%Float") [ SqlProc ]
{
}

ClassMethod SelectAllSatisfactionExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s gHospId=PJObj.%Get("gHospId")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	q:((PStartDate="")||(PEndDate="")) $$$OK
	s StartDate=..DH2L(PStartDate)
	s EndDate=..DH2L(PEndDate)

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID, S_Code, S_Desc FROM CT_STER_CSSD.Satisfaction WHERE S_Type<>'I' AND S_UseFlag='Y' "
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("ID")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_STER_CSSD.Satisfaction",RowId,gHospId)
		s SatisfactionDesc= Result.Data("S_Desc")
		continue:result="N"
		
		s (CheckResult,SatisfactionQty,Qty)=0
		s SatisfactionId=""
		f  s SatisfactionId=$o(^User.CSSDSatisfactionDetailI("CSSDSDSatisfactionDrIndex",RowId,SatisfactionId)) q:SatisfactionId=""  d
		.s SatisfactionDetailObj=##Class(User.CSSDSatisfactionDetail).%OpenId(SatisfactionId)
		.q:'$IsObject(SatisfactionDetailObj)
		.s ServeyResult=SatisfactionDetailObj.CSSDSDResult
		.s SatisfactionMainObj = SatisfactionDetailObj.CSSDSDMainDr
		.q:'$IsObject(SatisfactionMainObj)
		.
		.s CheckDate=SatisfactionMainObj.CSSDSMSubmitDate
		.s CreateLocObj=SatisfactionMainObj.CSSDSMLoc
		.s CreateHospId=CreateLocObj.CTLOCHospitalDR.%Id()
		.s Flag=SatisfactionMainObj.CSSDSMFlag
		.q:((StartDate'="")&&(CheckDate<StartDate))
		.q:((EndDate'="")&&(CheckDate>EndDate))
		.q:Flag'="Y"
		.s:ServeyResult="S" SatisfactionQty=SatisfactionQty+1
		.s Qty=Qty+1
		s:Qty'=0 CheckResult=SatisfactionQty/Qty
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,SatisfactionDesc,Type,CheckResult)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

///  Creator:ban
///  CreatDate:2022-4-28
///  Description:日常监测调查结果
///  Table:CSSD_DailySurvey
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.SurveyStat","SelectAllDaily",^tmpwhy("321"))
Query SelectAllDaily(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "ResultDesc:%String,ResultQty:%Float") [ SqlProc ]
{
}

ClassMethod SelectAllDailyExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s PgLocId=PJObj.%Get("gLocId")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	q:((PStartDate="")||(PEndDate="")) $$$OK
	s StartDate=..DH2L(PStartDate)
	s EndDate=..DH2L(PEndDate)
	
	s i=0
	s (Qty,PropertyQty,SelectMaterialQty,CheckMaterialQty,PreciseProtectQty,CardoProtectQty,CheCardQty,WidthQty,DistanceQty,TapeTooShortQty)=0
	s (IncompleteCloseQty,SixMarksQty,VolumeQty,WeightInstrusQty,WeightDressQty,PackUserQty,PackChkUserQty,Count,PackCount)=0
	f Date=StartDate:1:EndDate d
	.s DailyId=""
	.f  s DailyId=$o(^User.CSSDDailySurveyI("CSSDSDateIndex",Date,DailyId)) q:DailyId=""  d
	..s DailyObj=##class(User.CSSDDailySurvey).%OpenId(DailyId)
	..d DailyObj.%Reload()
	..s DailyQty=DailyObj.CSSDDSQty
	..s Property=DailyObj.CSSDDSProperty
	..s SelectMaterial=DailyObj.CSSDDSSelectMaterial
	..s CheckMaterial=DailyObj.CSSDDSCheckMaterial
	..s PreciseProtect=DailyObj.CSSDDSPreciseProtect
	..s CardoProtect=DailyObj.CSSDDSCardoProtect
	..s CheCard=DailyObj.CSSDDSCheCard
	..s Width=DailyObj.CSSDDSWidth
	..s Distance=DailyObj.CSSDDSDistance
	..s TapeTooShort=DailyObj.CSSDDSTapeTooShort
	..s IncompleteClose=DailyObj.CSSDDSIncompleteClose
	..s SixMarks=DailyObj.CSSDDSSixMarks
	..s Volume=DailyObj.CSSDDSVolume
	..s WeightInstrus=DailyObj.CSSDDSWeightInstrus
	..s WeightDress=DailyObj.CSSDDSWeightDress
	..s PackUserId=DailyObj.CSSDDSPackDr
	..s PackChkUserId=DailyObj.CSSDDSCheckDr
	..s Count=Count+1
	..s Qty=Qty+DailyQty
	..
	..s str1=Property_":"_PropertyQty_","_SelectMaterial_":"_SelectMaterialQty_","_CheckMaterial_":"_CheckMaterialQty_","_PreciseProtect_":"_PreciseProtectQty
	..s str2=CardoProtect_":"_CardoProtectQty_","_CheCard_":"_CheCardQty_","_Width_":"_WidthQty_","_Distance_":"_DistanceQty
	..s str3=TapeTooShort_":"_TapeTooShortQty_","_IncompleteClose_":"_IncompleteCloseQty_","_SixMarks_":"_SixMarksQty_","_Volume_":"_VolumeQty
	..s str4=WeightInstrus_":"_WeightInstrusQty_","_WeightDress_":"_WeightDressQty_","_PackUserId_":"_PackUserQty_","_PackChkUserId_":"_PackChkUserQty
	..s QtyStr=str1_","_str2_","_str3_","_str4
	..s QtyStrLen=$L(QtyStr,",")
	..f StrIndex=1:1:QtyStrLen  d
	...s Reason=$p(QtyStr,",",StrIndex)
	...s ReasonDesc=$p(Reason,":",1)
	...s ReasonQty=$p(Reason,":",2)
	...s:ReasonDesc'="" ReasonQty=ReasonQty+1
	...
	.s TransRowid="" 
	.f  s TransRowid=$o(^User.CSSDTransI("IndexCSSDTDate",Date,TransRowid)) q:TransRowid=""  d
	..q:'$d(^User.CSSDTransD(TransRowid))
	..s PackCount=PackCount+1
	s ResultDesc="",ResultQty=0
	s Array="数量不合格率"_":"_Qty_","_"性能不合格率"_":"_PropertyQty_","_"包装材料选择不合格率"_":"_SelectMaterialQty_","_"包装材料检查不合格率"_":"_CheckMaterialQty_","_"精密锐利器械保护不合格率"_":"_PreciseProtectQty_","_"轴节器械保养不合格率"_":"_CardoProtectQty_","_"包内化学指示卡不合格率"_":"_CheCardQty_","_"密封宽度不合格率"_":"_WidthQty_","_"密封距离不合格率"_":"_DistanceQty_","_"闭合胶带过短不合格率"_":"_TapeTooShortQty_","_"闭合不全不合格率"_":"_IncompleteCloseQty_","_"六项标识不合格率"_":"_SixMarksQty_","_"体积不合格率"_":"_VolumeQty_","_"器械包重量不合格率"_":"_WeightInstrusQty_","_"非循环包重量不合格率"_":"_WeightDressQty
	s Len=$L(Array,",")
	f j=1:1:Len  d
	.s ResultDescQty=$p(Array,",",j)
	.s ResultDesc=$p(ResultDescQty,":",1)
	.s ResultQty=$p(ResultDescQty,":",2)
	.s:ResultQty="" ResultQty=0
	.s:Count'=0 ResultQty=ResultQty/Count
	.d OutputRowDaily
	Quit $$$OK

OutputRowDaily  
	s Data=$lb(ResultDesc,ResultQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
