/// Creator: Zhao LiGuo
/// CreatDate: 2013-01-17
/// Description: 科室奖金核算计算函数
Class dhc.bonus.udata.uBonusCalcFunction Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Zhao LiGuo
/// CreatDate: 2013-01-18
/// Description：奖金函数调用主窗口
/// Input：sCode：奖金函数,如：  sParam:=#Percent#S102010,210^2012^M01^2 
/// 	#suppTarget#S0301090:872^2013^M03^20  
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFMain("^#GetDays#TLastMonth","742^2013^M04^26")
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFMain("^#Sum#T06040","742^2013^M04^26")
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFMain("^#BonUnitTarget@42#T02008","742^2016^M01^26")
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFMain("^#BonUnitTarget@5#S010101","742^2016^M01^1")
ClassMethod BSFMain(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	q:sCode="" 0
	q:sParam="" 0
	
	s rtn=0
	s fnName=$p(sCode,"#",2)
	s sItem=$p(sCode,"#",3)


    //取核算单元指标或方案项的值
    i $E(fnName,1,13) ="BonUnitTarget"  d 
    .s BonusUnitID = $p(fnName,"@",2)
    .s $p(sParam,"^",1) = BonusUnitID
    .s rtn= ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetFormulaItemVale(sItem,sParam)
	//取上级单位的指标
	i fnName="supTarget" d
	.s rtn= ..BSFsupTarget(sItem,sParam)
	
	//取上上级单位的指标
	i fnName="suppTarget" d
	.s rtn= ..BSFsuppTarget(sItem,sParam)
	
	//取上上上级单位的指标
	i fnName="supppTarget" d
	.s rtn= ..BSFsupppTarget(sItem,sParam)
	
	//取同级指标总和的百分比
	i fnName="Percent" d
	.s rtn= ..BSFPercent(sItem,sParam)
	
	//取同级子指标总和
	i fnName="Sum" d
	.s rtn= ..BSFSum(sItem,sParam)
	//取同级子指标总和(不加限制，特殊的用)
	i fnName="SumSpecial" d
	.s rtn= ..BSFSumSpecial(sItem,sParam)
	//取同级子指标平均值
	i fnName="BSAvg" d
	.s rtn= ..BSFAvg(sItem,sParam)     
	
	
	//取同祖父指标总和(上上级)
	i fnName="SumGrandpa" d
	.s rtn= ..BSFSumGrandpa(sItem,sParam)
	
	//取同父指标总和（下级）
	i fnName="SumChild" d
	.s rtn= ..BSFSumChild(sItem,sParam)
	
	//取同父指标总平均数
	i fnName="BSAvgChild" d
	.s rtn= ..BSFAvgChild(sItem,sParam)
	
	//取指标反值
	i fnName="BSFContrary" d
	.s rtn= ..BSFContrary(sItem,sParam)
	
	//取指标反值（行政后勤病事假天数）
	i fnName="BSFContrary3" d
	.s rtn= ..BSFContrary3(sItem,sParam)
	
	//取指标一致值
	i fnName="BSFConsistent" d
	.s rtn= ..BSFConsistent(sItem,sParam)
	
	//取当月天数
	i fnName="BSDays" d
	.s rtn= ..BSDays(sItem,sParam)
	
	//取病房支援门诊奖金
	i fnName="Bfzymzjj" d
	.s rtn= ..BSBfzymzjj(sItem,sParam)
	
	//取指标全部科室之和
	i fnName="BSFSumAll" d
	.s rtn= ..BSFSumAll(sItem,sParam) 
	
	//取全院临床医生奖金的平均值
	i fnName="BSFSumAllAVG" d
	.s rtn= ..BSFSumAllAVG(sItem,sParam)   
	
	//取科(个别科室)奖金的平均值
	i fnName="BSFSumYJKAVG" d
	.s rtn= ..BSFSumYJKAVG(sItem,sParam)
	
	//取指标前3月平均值
	i fnName="Avg3Month" d
	.s rtn= ..BSFAvg3Month(sItem,sParam)

	//取指标前3月平均值
	i fnName="Avg6Month" d
	.s rtn= ..BSFAvg6Month(sItem,sParam)
		
	//取奖金方案指标求和
	i fnName="SumSchemeTarget" d
	.s rtn= ..SumSchemeTarget(sItem,sParam)
			
		//按指标类别求和
	i fnName="TargetTypeSum" d
	.s rtn= ..GetTargetTypeSum(sItem,sParam)
	
	//计算科室扣税金额（弋矶山专用）
	i fnName="BSFDeptRate" d
	.s rtn= ..BSFDeptRate(sItem,sParam)	
	
	//取正数
	i fnName="BSFPositive" d
	.s rtn= ..BSFPositive(sItem,sParam)	
	
	//取整数
	i fnName="BSFInteger" d
	.s rtn= ..BSFInteger(sItem,sParam)	
	
	//差额累加，（算收支结余）
	i fnName="BSFAddUp" d
	.s rtn= ..BSFAddUp(sItem,sParam)	
	
	//取天数
	i fnName="GetDays" d
	.s Year = $p(sParam,"^",2)
	.s Month= $p(sParam,"^",3)
	.s Month= $E(Month,2,)
	.i sItem="TLastMonth" d
	..i +Month=1 s Month=12
	..e  s Month=Month-1
 	.s rtn= ..GetDayNumbers(Year,Month)
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2016-08-31
/// Description：奖金函数调用主窗口
/// Input：sCode：奖金函数,如：  sParam:=#Percent#S102010,210^2012^M01^2 
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFMainAuto("^#Test#S0101048","742^2016^M01^1")
ClassMethod BSFMainAuto(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	q:sCode="" 0
	q:sParam="" 0
	
	s rtn=0
	s fnName=$p(sCode,"#",2)
	s sItem=$p(sCode,"#",3)
	
	s rowid="",classname=""
	
	s rowid=$o(^dhcbsCalcFunctionI("codeIndex",fnName,rowid)) 
	i rowid'="" d
	.s classname=$list(^dhcbsCalcFunctionD(rowid),5)
	
	s sParam =""""_sItem_""""_","""_sParam_""""
	s classname="##"_classname_"("_sParam_")"
	;w "classname="_classname,!
	
	s rtn= ..ExeStrClass(classname)
	
	q rtn
}

/// 
/// Creator: Zhao LiGuo
/// CreatDate: 2016-08-31
/// Description：反转执行动态命令
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).ExeStrClass("##class(dhc.bonus.udata.uBonusCalcFunction).Test(55)")
ClassMethod ExeStrClass(classStr) As %Integer
{
  n (classStr)
  q:classStr="" 0

  q @classStr
}

/// Others:w ##class(dhc.bonus.udata.uBonusCalcFunction).Test(55)
ClassMethod Test(ss, dd) As %Integer
{
  n (ss,dd)
 // w ss,!
  //w dd,! 
  s aa=120
  q aa
}

/// 取每月天数
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).GetDayNumbers(2016,3)
ClassMethod GetDayNumbers(Year, Month) As %Integer
{
  n (Year,Month)
  ;w Year_"^"_Month,!
  s DayNumbers = 0
  s DayNumbers = $Case(+Month,1:31,2:28,3:31,4:30,5:31,6:30,7:31,8:31,9:30,10:31,11:30,12:31)
  i (((Year#4=0)&(Year#100'=0))||(Year#400=0))&(+Month=2) s DayNumbers=DayNumbers+1
  q DayNumbers
}

/// Creator: Zhao LiGuo
/// CreatDate: 2015-11-29
/// Description：差额累加，（算收支结余）
/// Input：sCode：sCode:指标类别编码,Y+指标类别编码，如：Y02，sParam:单位ID^年度^月份^方案ID
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFAddUp("S0101048","579^2015^M08^1")
ClassMethod BSFAddUp(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	;w sCode_":"_sParam,!
	s rtn=""
	s sqlstr =""
	q:sCode="" 0
	q:sParam="" 0
	
	s UnitID=$p(sParam,"^",1)
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeID=$p(sParam,"^",4)
	
	S rtn=0,sjz=0
	
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	s sParam=UnitID_"^"_syear_"^"_sPeriod_"^"_schemeID

	i sType="S" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemid))
	.i itemid>0 d
	..s detailID=0
	..s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitID,itemid,detailID))
	..i detailID>0 d
	...s sjz=$List(^dhcbsUnitBonusDetailD(detailID),8)
	..s sTargetID=268 ;05052	结余提取区间

	..s CollectDr=""
	..f  s CollectDr=$O(^dhcbsTargetCalculateRateI("TargetUnit",sTargetID,UnitID,CollectDr)) q:CollectDr=""  d
	...;w sTargetID_","_UnitID_","_CollectDr,!
	...s startJE= $List(^dhcbsTargetCalculateRateD(CollectDr),6)
	...s endJE= $List(^dhcbsTargetCalculateRateD(CollectDr),7)
	...s sRate= $List(^dhcbsTargetCalculateRateD(CollectDr),11)
	...;w itemid_","_UnitID_","_CollectDr_","_startJE_","_endJE_","_sRate_","_sjz,!
	...i ((sjz>=startJE) &&(sjz<endJE)) d
	....s rtn=rtn+((sjz-startJE)*sRate)
	...e  d
	....i sjz>endJE d
	.....s rtn=rtn+((endJE-startJE)*sRate)

	s rtn=$fn(rtn,"",4)
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2015-11-29
/// Description：取正数，当负数是返回0
/// Input：sCode：sCode:指标类别编码,Y+指标类别编码，如：Y02，sParam:单位ID^年度^月份^方案ID
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFInteger("S0101047","575^2015^M08^1")
ClassMethod BSFInteger(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	;w sCode_":"_sParam,!
	s rtn=""
	s sqlstr =""
	q:sCode="" 0
	q:sParam="" 0
	
	s UnitID=$p(sParam,"^",1)
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeID=$p(sParam,"^",4)
	
	S rtn=0
	
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	s sParam=UnitID_"^"_syear_"^"_sPeriod_"^"_schemeID

	i sType="S" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemid))
	.i itemid>0 d
	..s detailID=0
	..;w syear_":"_sPeriod_":"_supUnitID_":"_itemid,!
	..s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitID,itemid,detailID))
	..i detailID>0 d
	...s rtn= $List(^dhcbsUnitBonusDetailD(detailID),8)

	
	i sType="T" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	..s DataSource=$list(^dhcbsBonusTargetD(itemid),7)
	..;3:区间指标,4:比例系数指标
	..i DataSource=3 d
	...s Code =$E(sCode,2,$L(sCode))
	...s rtn=##class(dhc.bonus.udata.uBonusSchemeCalculate).GetBonusTargetRate(Code,sParam)
	..e  d
	...i DataSource=4  d
	....s CollectDr=""
	....s CollectDr=$O(^dhcbsTargetCalculateRateI("TargetUnit",itemid,UnitID,CollectDr))
	....;w itemid_":"_supUnitID_":"_CollectDr,!
	....i CollectDr>0 d
	.....s rtn= $List(^dhcbsTargetCalculateRateD(CollectDr),11)
	....i CollectDr="" d ;取指标的默认值
	.....s rtn=$list(^dhcbsBonusTargetD(itemid),20)
	...e  d
	....s CollectDr=""
	....s CollectDr=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitID,itemid,syear,sPeriod,CollectDr))
	....i CollectDr>0 d
	.....s rtn= $List(^dhcbsBonusTargetCollectD(CollectDr),8)
	
	s rtn=$fn(rtn,"",0)
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2015-11-29
/// Description：取正数，当负数是返回0
/// Input：sCode：sCode:指标类别编码,Y+指标类别编码，如：Y02，sParam:单位ID^年度^月份^方案ID
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFPositive("S0101047","575^2015^M08^1")
ClassMethod BSFPositive(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	;w sCode_":"_sParam,!
	s rtn=""
	s sqlstr =""
	q:sCode="" 0
	q:sParam="" 0
	
	s UnitID=$p(sParam,"^",1)
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeID=$p(sParam,"^",4)
	
	S rtn=0
	
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	//s supUnitID=UnitID

	s sParam=UnitID_"^"_syear_"^"_sPeriod_"^"_schemeID

	i sType="S" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemid))
	.i itemid>0 d
	..s detailID=0
	..;w syear_":"_sPeriod_":"_supUnitID_":"_itemid,!
	..s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitID,itemid,detailID))
	..i detailID>0 d
	...s rtn= $List(^dhcbsUnitBonusDetailD(detailID),8)

	
	i sType="T" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	..s DataSource=$list(^dhcbsBonusTargetD(itemid),7)
	..;3:区间指标,4:比例系数指标
	..i DataSource=3 d
	...s Code =$E(sCode,2,$L(sCode))
	...s rtn=##class(dhc.bonus.udata.uBonusSchemeCalculate).GetBonusTargetRate(Code,sParam)
	..e  d
	...i DataSource=4  d
	....s CollectDr=""
	....s CollectDr=$O(^dhcbsTargetCalculateRateI("TargetUnit",itemid,UnitID,CollectDr))
	....;w itemid_":"_supUnitID_":"_CollectDr,!
	....i CollectDr>0 d
	.....s rtn= $List(^dhcbsTargetCalculateRateD(CollectDr),11)
	....i CollectDr="" d ;取指标的默认值
	.....s rtn=$list(^dhcbsBonusTargetD(itemid),20)
	...e  d
	....s CollectDr=""
	....s CollectDr=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitID,itemid,syear,sPeriod,CollectDr))
	....i CollectDr>0 d
	.....s rtn= $List(^dhcbsBonusTargetCollectD(CollectDr),8)
	
	i rtn<0 s rtn=0
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2014-12-26
/// Description：计算科室扣税金额（弋矶山专用）
/// 科室扣款=（科室应发奖金+质量考核奖金）大于目标奖金（科室核算平均奖+科室调整平均奖	）*3%，小于目标不扣；
/// Input：sCode：sCode:指标类别编码,Y+指标类别编码，如：Y02，sParam:单位ID^年度^月份^方案ID
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFDeptRate("T01081","570^2015^M08^1")
ClassMethod BSFDeptRate(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	;w sCode_":"_sParam,!
	s rtn=""
	s sqlstr =""
	q:sCode="" 0
	q:sParam="" 0
	
	s UnitID=$p(sParam,"^",1)
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeID=$p(sParam,"^",4)
	
	s ksbl=0,ksjs=0	
	s sf=0,zlkh=0,kspj=0,kstz=0
	s sj=0,mb=0
	
	s itemid=66 //66	0101061	科室应发奖金
	s detailID=""
	s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitID,itemid,detailID))
	i detailID>0 d
	.s sf= $List(^dhcbsUnitBonusDetailD(detailID),8)
	
	s itemid=68 ////68	0101067	质量考核奖金
	s detailID=""
	s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitID,itemid,detailID))
	i detailID>0 d
	.s zlkh= $List(^dhcbsUnitBonusDetailD(detailID),8)
	//实际值=科室应发+质量考核奖金
	s sj=sf+zlkh
	
	s itemid=25 //25	0101071	科室核算平均奖	
	s detailID=""
	s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitID,itemid,detailID))
	i detailID>0 d
	.s kspj= $List(^dhcbsUnitBonusDetailD(detailID),8)
	
	s itemid=52 //52	0101072	科室调整平均奖	
	s detailID=""
	s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitID,itemid,detailID))
	i detailID>0 d
	.s kstz= $List(^dhcbsUnitBonusDetailD(detailID),8)
	//目标值=科室平均奖+科室平均奖调整
	s mb=kspj+kstz
	
	s code="01082" // 01082	扣税基数 默认0.8
	s itemid=0
	s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	i itemid>0 d
	.s ksjs=$list(^dhcbsBonusTargetD(itemid),20)
	//实际值的80%-目标值后扣税
	s sj=sj*ksjs
	
	
	//扣税系数
	s code="01081" //01081	扣税比率 默认0.03
	s itemid=0
	s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	i itemid>0 d
	.s ksbl=$list(^dhcbsBonusTargetD(itemid),20)
		
	s ks=sj-mb
	s ksz=0
	
	i ks>0 d
	.s ksz=ks*ksbl
	
	q ksz
}

/// Creator: Zhao LiGuo
/// CreatDate: 2014-12-26
/// Description：按指标类别求和，如：工作量指标
/// Input：sCode：sCode:指标类别编码,Y+指标类别编码，如：Y02，sParam:单位ID^年度^月份^方案ID
/// Y04,726^2014^M10^2
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).GetTargetTypeSum("Y04","726^2014^M10^2")
ClassMethod GetTargetTypeSum(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
   ; k ^zlgtmp
    ;s ^zlgtmp=sCode_","_sParam
	s rtn=""
	s sqlstr =""
	q:sCode="" 0
	q:sParam="" 0
	
	s UnitID=$p(sParam,"^",1)
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeID=$p(sParam,"^",4)

	
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	s TargetValue=0
	
	
	&sql(SELECT sum(je) INTO:TargetValue FROM ( select  sum(TargetValue*UnitPrice) je	from dhc_bonus_data.BonusTargetCollect
		WHERE  BonusTargetID->DataSource =9 AND BonusTargetID->TargetTypeID->TargetTypeCode =:code
		and BonusYear=:syear and BonusPeriod=:sPeriod and BonusUnitID=:UnitID
		UNION ALL
		select  sum(TargetValue) je	from dhc_bonus_data.BonusTargetCollect	
		WHERE   BonusUnitID=1 AND BonusTargetID->DataSource =1 AND BonusTargetID->TargetTypeID->TargetTypeCode =:code
		and BonusYear=:syear and BonusPeriod=:sPeriod and BonusUnitID=:UnitID) as jj
	)
	i TargetValue="" s TargetValue=0
	;s ^zlgtmp(1)=syear_","_sPeriod_","_UnitID_"^"_TargetValue
	;w syear_","_sPeriod_","_UnitID_"^"_TargetValue,!
	q TargetValue
}

/// Creator: Zhao LiGuo
/// CreatDate: 2014-10-10
/// Description：取方案指标的和
/// Input：sCode：奖金方案项目编码或指标编码  
///  S01500 T01030
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).SumSchemeTarget("S01500","267^2014^M03^1")
ClassMethod SumSchemeTarget(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	s rtn=""
	s sqlstr =""
	q:sCode="" 0
	q:sParam="" 0
	
	s UnitID=$p(sParam,"^",1)
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeID=$p(sParam,"^",4)
	
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	s TargetValue=0
	s TargetValue=$g(^dhcBonusSumST($j,sCode,syear,sPeriod))
	q:TargetValue>0 TargetValue

	i sType="S" d	
	.&sql(select sum(BonusValue) into :TargetValue from dhc_bonus_data.UnitBonusDetail 
		WHERE BonusYear=:syear AND BonusPeriod=:sPeriod AND BonusSchemeItemID->SchemeItemCode=:code )
	.s ^dhcBonusSumST($j,sCode,syear,sPeriod)=TargetValue
	
	i sType="T" d	
	.&sql(SELECT SUM(TargetValue) into :TargetValue 
		FROM dhc_bonus_data.BonusTargetCollect a,dhc_bonus_data.BonusSchemeUnit b
		WHERE a.BonusUnitID=b.BonusUnitID AND b.BonusSchemeID=:schemeID
		AND a.BonusTargetID->BonusTargetCode=:code AND a.BonusYear=:syear AND a.BonusPeriod=:sPeriod )
	.s ^dhcBonusSumST($j,sCode,syear,sPeriod)=TargetValue
	
	q TargetValue
}

/// Creator: Zhao LiGuo
/// CreatDate: 2014-06-24
/// Description：取3个月的指标平均值
/// Input：sCode：奖金方案项目编码或指标编码  S10115:208^2010^M01^2 
/// #suppTarget#T010601					"04210","173^2013^M03^16"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFsuppTarget("T90070","267^2013^M05^5")
ClassMethod BSFAvg3Month(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	s rtn=""
	s sqlstr =""
	q:sCode="" 0
	q:sParam="" 0
	
	s UnitID=$p(sParam,"^",1)
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeID=$p(sParam,"^",4)
	s pPeriod="M01"
	i sPeriod="M04" s pPeriod="M02"
	i sPeriod="M05" s pPeriod="M03"
	i sPeriod="M06" s pPeriod="M04"
	i sPeriod="M07" s pPeriod="M05"
	i sPeriod="M08" s pPeriod="M06"
	i sPeriod="M09" s pPeriod="M07"
	i sPeriod="M010" s pPeriod="M08"
	i sPeriod="M011" s pPeriod="M09"
	i sPeriod="M012" s pPeriod="M10"
	
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	s TargetValue=0
	
	&sql(select avg(TargetValue) into :TargetValue
	from dhc_bonus_data.BonusTargetCollect
	where BonusTargetID->BonusTargetCode=:code
	and BonusYear=:syear and BonusPeriod>=:pPeriod and BonusPeriod<=:sPeriod
	and BonusUnitID=:UnitID)
	
	q TargetValue
}

/// Creator: Zhao LiGuo
/// CreatDate: 2014-06-24
/// Description：取6个月的指标平均值
/// Input：sCode：奖金方案项目编码或指标编码  S10115:208^2010^M01^2 
/// #suppTarget#T010601					"04210","173^2013^M03^16"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFsuppTarget("T90070","267^2013^M05^5")
ClassMethod BSFAvg6Month(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	s rtn=""
	s sqlstr =""
	q:sCode="" 0
	q:sParam="" 0
	
	s UnitID=$p(sParam,"^",1)
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeID=$p(sParam,"^",4)
	s pPeriod="M01"
	i sPeriod="M07" s pPeriod="M02"
	i sPeriod="M08" s pPeriod="M03"
	i sPeriod="M09" s pPeriod="M04"
	i sPeriod="M010" s pPeriod="M05"
	i sPeriod="M011" s pPeriod="M06"
	i sPeriod="M012" s pPeriod="M07"
	
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	s TargetValue=0
	
	&sql(select avg(TargetValue) into :TargetValue
	from dhc_bonus_data.BonusTargetCollect
	where BonusTargetID->BonusTargetCode='04010'
	and BonusYear=:syear and BonusPeriod>=:pPeriod and BonusPeriod<=:sPeriod
	and BonusUnitID=:UnitID)
	
	q TargetValue
}

/// Creator: Zhao LiGuo
/// CreatDate: 2013-01-18
/// Description：取上级单位的指标
/// Input：sCode：奖金方案项目编码或指标编码  S10115:208^2010^M01^2 
/// 					^#Percent#S102030^*^#supTarget#T010500^*^#Percent#S102130
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFsupTarget("T010602","742^2013^M04^26")
ClassMethod BSFsupTarget(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	s rtn="null"
	s sqlstr =""
	s rtn=0
	
	s UnitID=$p(sParam,"^",1)
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeID=$p(sParam,"^",4)
	
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	s supUnitID=0
	s supUnitID=$List(^dhcbsBonusUnitD(UnitID),6)

	s sParam=supUnitID_"^"_syear_"^"_sPeriod_"^"_schemeID

	i sType="S" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemid))
	.i itemid>0 d
	..s detailID=0
	..;w syear_":"_sPeriod_":"_supUnitID_":"_itemid,!
	..s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,supUnitID,itemid,detailID))
	..i detailID>0 d
	...s rtn= $List(^dhcbsUnitBonusDetailD(detailID),8)

	
	i sType="T" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	..s DataSource=$list(^dhcbsBonusTargetD(itemid),7)
	..;3:区间指标,4:比例系数指标
	..i DataSource=3 d
	...s Code =$E(sCode,2,$L(sCode))
	...s rtn=##class(dhc.bonus.udata.uBonusSchemeCalculate).GetBonusTargetRate(Code,sParam)
	..e  d
	...i DataSource=4  d
	....s CollectDr=""
	....s CollectDr=$O(^dhcbsTargetCalculateRateI("TargetUnit",itemid,supUnitID,CollectDr))
	....;w itemid_":"_supUnitID_":"_CollectDr,!
	....i CollectDr>0 d
	.....s rtn= $List(^dhcbsTargetCalculateRateD(CollectDr),11)
	....i CollectDr="" d ;取指标的默认值
	.....s rtn=$list(^dhcbsBonusTargetD(itemid),20)
	...e  d
	....s CollectDr=""
	....s CollectDr=$O(^dhcbsBonusTargetCollectI("BsTarget",supUnitID,itemid,syear,sPeriod,CollectDr))
	....i CollectDr>0 d
	.....s rtn= $List(^dhcbsBonusTargetCollectD(CollectDr),8)
	q:rtn'="" rtn
	
	
		;当有公式时进公式解析
	s formu=""
	s formu=##class(dhc.bonus.udata.uBonusSchemeCalculate).IsExistFormula(sCode)
	i formu='"" d
	.s rtn= ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,formu,sParam) 

	
	//取默认指标
	s targetCode =$E(sCode,2,$L(sCode))
	s stv=""
	i rtn="" d
	.s rowid=""
	.s rowid=$o(^dhcbsBonusTargetI("BonusTargetCode",targetCode,rowid))
	.i rowid'="" d
	..s stv=$list(^dhcbsBonusTargetD(rowid),20) ;取指标默认值
	..i stv'="" d
	...s rtn=stv
	
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2013-01-18
/// Description：取上上级单位的指标
/// Input：sCode：奖金方案项目编码或指标编码  S10115:208^2010^M01^2 
/// #suppTarget#T010601					"04210","173^2013^M03^16"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFsuppTarget("T90070","267^2013^M05^5")
ClassMethod BSFsuppTarget(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	s rtn=""
	s sqlstr =""
	q:sCode="" 0
	q:sParam="" 0
	
	s UnitID=$p(sParam,"^",1)
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeID=$p(sParam,"^",4)
	
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	;w "sType="_sType,!
	;上级单元
	s supUnitID1=""
	s supUnitID1=$List(^dhcbsBonusUnitD(UnitID),6)
	q:supUnitID1="" 0
	
	;上上级单元
	s supUnitID=""
	s supUnitID=$List(^dhcbsBonusUnitD(supUnitID1),6)
	
	s sParam=supUnitID_"^"_syear_"^"_sPeriod_"^"_schemeID
	i sType="S" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemid))
	.i itemid>0 d
	..s detailID=0
	..;w syear_":"_sPeriod_":"_supUnitID_":"_itemid,!
	..s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,supUnitID,itemid,detailID))
	..i detailID>0 d
	...s rtn= $List(^dhcbsUnitBonusDetailD(detailID),8)
		
	i sType="T" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	..s DataSource=$list(^dhcbsBonusTargetD(itemid),7)
	..;w "DataSource="_DataSource,!
	..;3:区间指标,
	..i DataSource=3 d
	...s Code =$E(sCode,2,$L(sCode))
	...s rtn=##class(dhc.bonus.udata.uBonusSchemeCalculate).GetBonusTargetRate(Code,sParam)
	..;6:差额累加法,
	..i DataSource=6 d
	...s Code =$E(sCode,2,$L(sCode))
	...;w Code_":"_sParam,!
	...;s rtn=##class(dhc.bonus.udata.uBonusSchemeCalculate).GetBonusTargetRate(Code,sParam)
	...s rtn=##class(dhc.bonus.udata.uBonusSchemeCalculate).GetCELJTargetRate(Code,sParam)
	..;4:比例系数指标
	..i DataSource=4  d
	...s CollectDr=""
	...s CollectDr=$O(^dhcbsTargetCalculateRateI("TargetUnit",itemid,supUnitID,CollectDr))
	...i CollectDr>0 d
	....s rtn= $List(^dhcbsTargetCalculateRateD(CollectDr),11)
	...i CollectDr="" d ;取指标的默认值
	....s rtn=$list(^dhcbsBonusTargetD(itemid),20)
	..;2:指标内涵有公式
	..i DataSource=2  d 
	...s formu=""
	...s formu=##class(dhc.bonus.udata.uBonusSchemeCalculate).IsExistFormula(sCode)
	...i formu'="" d
	....s rtn= ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,formu,sParam)
	..;1:数据来源为录入
	..i DataSource=1  d 
	...;w supUnitID_":"_itemid_":"_syear_":"_sPeriod,!
	...s CollectDr=""
	...s CollectDr=$O(^dhcbsBonusTargetCollectI("BsTarget",supUnitID,itemid,syear,sPeriod,CollectDr))
	...i CollectDr>0 d
	....s rtn= $List(^dhcbsBonusTargetCollectD(CollectDr),8)
	q:rtn'="" rtn

	;当有公式时进公式解析
	/*
	s formu=""
	s formu=##class(dhc.bonus.udata.uBonusSchemeCalculate).IsExistFormula(sCode)
	w sCode_":"_formu_":"_sParam,!
	i formu='"" d
	.s rtn= ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,formu,sParam) 
    ;w ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate("T010900","^T010904^+^T010905^+^T010903^+^T010902^+^T010901^+^T010906","433^2013^M04^8") 
	*/
	
	//取默认指标
	s targetCode =$E(sCode,2,$L(sCode))
	s stv=""
	i rtn="" d
	.s rowid=""
	.s rowid=$o(^dhcbsBonusTargetI("BonusTargetCode",targetCode,rowid))
	.i rowid'="" d
	..s stv=$list(^dhcbsBonusTargetD(rowid),20) ;取指标默认值
	..i stv'="" d
	...s rtn=stv
	;w "rtn1:"_rtn,!	
	i rtn="" d
	.s rtn=0
	
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2013-01-18
/// Description：取上上上级单位的指标
/// Input：sCode：奖金方案项目编码或指标编码  S10115:208^2010^M01^2 
/// #suppTarget#T010601					"04210","173^2013^M03^16"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFsupppTarget("T010600","795^2013^M05^40")
ClassMethod BSFsupppTarget(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	s rtn=""
	s sqlstr =""
	q:sCode="" 0
	q:sParam="" 0
	
	s UnitID=$p(sParam,"^",1)
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeID=$p(sParam,"^",4)
	
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	;w "sType="_sType,!
	;上级单元
	s supUnitID1=""
	s supUnitID1=$List(^dhcbsBonusUnitD(UnitID),6)
	q:supUnitID1="" 0
	
	;上上级单元
	s supUnitID2=""
	s supUnitID2=$List(^dhcbsBonusUnitD(supUnitID1),6)
	q:supUnitID2="" 0
	
	;上上上级单元
	s supUnitID=""
	s supUnitID=$List(^dhcbsBonusUnitD(supUnitID2),6)
	
	;w supUnitID,!
	
	s sParam=supUnitID_"^"_syear_"^"_sPeriod_"^"_schemeID
	i sType="S" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemid))
	.i itemid>0 d
	..s detailID=0
	..;w syear_":"_sPeriod_":"_supUnitID_":"_itemid,!
	..s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,supUnitID,itemid,detailID))
	..i detailID>0 d
	...s rtn= $List(^dhcbsUnitBonusDetailD(detailID),8)
		
	i sType="T" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	..s DataSource=$list(^dhcbsBonusTargetD(itemid),7)
	..;w "DataSource="_DataSource,!
	..;3:区间指标,
	..i DataSource=3 d
	...s Code =$E(sCode,2,$L(sCode))
	...s rtn=##class(dhc.bonus.udata.uBonusSchemeCalculate).GetBonusTargetRate(Code,sParam)
	..;6:差额累加法,
	..i DataSource=6 d
	...s Code =$E(sCode,2,$L(sCode))
	...;w Code_":"_sParam,!
	...;s rtn=##class(dhc.bonus.udata.uBonusSchemeCalculate).GetBonusTargetRate(Code,sParam)
	...s rtn=##class(dhc.bonus.udata.uBonusSchemeCalculate).GetCELJTargetRate(Code,sParam)
	..;4:比例系数指标
	..i DataSource=4  d
	...s CollectDr=""
	...s CollectDr=$O(^dhcbsTargetCalculateRateI("TargetUnit",itemid,supUnitID,CollectDr))
	...i CollectDr>0 d
	....s rtn= $List(^dhcbsTargetCalculateRateD(CollectDr),11)
	...i CollectDr="" d ;取指标的默认值
	....s rtn=$list(^dhcbsBonusTargetD(itemid),20)
	..;2:指标内涵有公式
	..i DataSource=2  d 
	...s formu=""
	...s formu=##class(dhc.bonus.udata.uBonusSchemeCalculate).IsExistFormula(sCode)
	...i formu'="" d
	....s rtn= ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,formu,sParam)
	..;1:数据来源为录入
	..i DataSource=1  d 
	...;w supUnitID_":"_itemid_":"_syear_":"_sPeriod,!
	...s CollectDr=""
	...s CollectDr=$O(^dhcbsBonusTargetCollectI("BsTarget",supUnitID,itemid,syear,sPeriod,CollectDr))
	...i CollectDr>0 d
	....s rtn= $List(^dhcbsBonusTargetCollectD(CollectDr),8)
	q:rtn'="" rtn

	;当有公式时进公式解析
	/*
	s formu=""
	s formu=##class(dhc.bonus.udata.uBonusSchemeCalculate).IsExistFormula(sCode)
	w sCode_":"_formu_":"_sParam,!
	i formu='"" d
	.s rtn= ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,formu,sParam) 
    ;w ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate("T010900","^T010904^+^T010905^+^T010903^+^T010902^+^T010901^+^T010906","433^2013^M04^8") 
	*/
	
	//取默认指标
	s targetCode =$E(sCode,2,$L(sCode))
	s stv=""
	i rtn="" d
	.s rowid=""
	.s rowid=$o(^dhcbsBonusTargetI("BonusTargetCode",targetCode,rowid))
	.i rowid'="" d
	..s stv=$list(^dhcbsBonusTargetD(rowid),20) ;取指标默认值
	..i stv'="" d
	...s rtn=stv
	;w "rtn1:"_rtn,!	
	i rtn="" d
	.s rtn=0
	
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2013-01-18
/// Description：取上同级指标总和的百分比
/// Input：sCode：奖金方案项目编码或指标编码  S102010 ^#supTarget#S10115^*^#Percent#S102010
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFPercent("S102010","228^2013^M01^2")
ClassMethod BSFPercent(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	s rtn=0
	
	s UnitID=$p(sParam,"^",1)
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	s supUnitID=0
	s supUnitID=$List(^dhcbsBonusUnitD(UnitID),6)
	s UnitType1=$list(^dhcbsBonusUnitD(UnitID),11)	
	
	s sValue=0
	s cValue=0
	
	//判断是否有公式
	s rtnFormula= ##class(dhc.bonus.udata.uBonusSchemeCalculate).IsExistFormula(sCode)
	
	i sType="S" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemid))
	.i itemid>0 d
	..s UnitDr=""
	..f  s UnitDr=$O(^dhcbsBonusUnitI("Parent",supUnitID,UnitDr)) q:UnitDr=""  d
	...q:$D(^dhcbsBonusSchemeUnitI("inxSchemeUnit",schemeDr,UnitDr))=0 ;只取本方案下科室
	...s unitflag=$list(^dhcbsBonusUnitD(UnitDr),5)
	...s UnitType2=$list(^dhcbsBonusUnitD(UnitDr),11)	
	...;q:unitflag=4 ;当his科室时不计算
	...q:UnitType1'=UnitType2
	...s detailID=""
	...s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitDr,itemid,detailID))
	...i detailID>0 d
	....;取当前科室值，即分子值
	....i UnitID=UnitDr d
	.....s cValue=  $List(^dhcbsUnitBonusDetailD(detailID),8)
	....;取同级科室合计，即分母值
	....s sValue=sValue+ $List(^dhcbsUnitBonusDetailD(detailID),8)
	....;当没有取到值时，调用公式解析，然后再一次取值
	...i detailID="" d
	....i rtnFormula'="null" d
	.....s sParam2=UnitDr_"^"_syear_"^"_sPeriod_"^"_schemeDr  
	.....d ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,rtnFormula, sParam2)
	.....s detailID=""
	.....s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitDr,itemid,detailID))
	.....i detailID>0 d
	......s sValue=sValue+ $List(^dhcbsUnitBonusDetailD(detailID),8)
	......i UnitID=UnitDr d
	.......s cValue=  $List(^dhcbsUnitBonusDetailD(detailID),8)
	
	;w cValue_":"_sValue,!
	i sValue>0 d
	.s rtn=cValue/sValue
	
	
	i sType="T" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	..s UnitDr=""
	..f  s UnitDr=$O(^dhcbsBonusUnitI("Parent",supUnitID,UnitDr)) q:UnitDr=""  d
	...s unitflag=$list(^dhcbsBonusUnitD(UnitDr),5)
	...s UnitType2=$list(^dhcbsBonusUnitD(UnitDr),11)
	...;q:unitflag=4 ;当his科室时不计算
	...q:UnitType1'=UnitType2
	...s targetctID=""
	...s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitDr,itemid,syear,sPeriod,targetctID))
	...i targetctID>0 d
	....s sValue=sValue+ $List(^dhcbsBonusTargetCollectD(targetctID),8)
	....i UnitID=UnitDr d
	.....s cValue= $List(^dhcbsBonusTargetCollectD(targetctID),8)
	....;当没有取到值时，调用公式解析，然后再一次取值
	...i targetctID="" d
	....i rtnFormula'="null" d
	.....s sParam2=UnitDr_"^"_syear_"^"_sPeriod_"^"_schemeDr  
	.....d ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,rtnFormula, sParam2)
	.....s targetctID=""
	.....s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitDr,itemid,syear,sPeriod,targetctID))
	.....i targetctID>0 d
	......s sValue=sValue+ $List(^dhcbsBonusTargetCollectD(targetctID),8)
	......i UnitID=UnitDr d
	.......s cValue= $List(^dhcbsBonusTargetCollectD(targetctID),8)
	
	i sValue>0 d
	.s rtn=$fn(cValue/sValue,"",4)
	
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2013-01-18
/// Description：取同级指标总和 grandpa
/// Input：sCode：奖金方案项目编码或指标编码 ;sParam:"单元iD^年份^月份^奖金方案ID",如："888^2012^M02^26"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFSum("S0401030","742^2013^M04^26")
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFSum("T06040","208^2012^M01^2")
/// ^#Sum#S0401030^/^3
ClassMethod BSFSum(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	s rtn=0
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	s UnitID=$p(sParam,"^",1)
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	q:syear="" 0
	q:sPeriod="" 0
	q:UnitID="" 0
	q:code="" 0
	s supUnitID=0
	s supUnitID=$List(^dhcbsBonusUnitD(UnitID),6)
	s UnitType1=$list(^dhcbsBonusUnitD(UnitID),11)
	s sValue=0
	s cValue=0
	
	
	//判断是否有公式
	s rtnFormula= ##class(dhc.bonus.udata.uBonusSchemeCalculate).IsExistFormula(sCode)
	//##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate()
	
	i sType="S" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemid))
	.i itemid>0 d
	..s UnitDr=""
	..f  s UnitDr=$O(^dhcbsBonusUnitI("Parent",supUnitID,UnitDr)) q:UnitDr=""  d
	...;q:$D(^dhcbsBonusSchemeUnitI("inxSchemeUnit",schemeDr,UnitDr))=0 ;只取本方案下科室
	...;判断科室是否在该奖金方案下
	...s rowid=""
	...s rowid=$O(^dhcbsBonusSchemeUnitI("inxSchemeUnit",schemeDr, UnitDr,rowid))
	...q:rowid=""  
	...s unitflag=$list(^dhcbsBonusUnitD(UnitDr),5)
	...;q:unitflag=4 ;当his科室时不计算
	...s UnitType2=$list(^dhcbsBonusUnitD(UnitDr),11)
	...;w UnitType1_":"_UnitType2,!	
	...q:UnitType1'=UnitType2
	...s detailID=""
	...s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitDr,itemid,detailID))
	...i detailID>0 d
	....s sValue=sValue+ $List(^dhcbsUnitBonusDetailD(detailID),8)
	....;w UnitDr_":"_itemid_":"_$List(^dhcbsUnitBonusDetailD(detailID),8),!
	....;当没有取到值时，调用公式解析，然后再一次取值
	...i detailID="" d
	....i rtnFormula'="null" d
	.....s sParam2=UnitDr_"^"_syear_"^"_sPeriod_"^"_schemeDr  
	.....d ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,rtnFormula, sParam2)
	.....s detailID=""
	.....s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitDr,itemid,detailID))
	.....i detailID>0 d
	......s sValue=sValue+ $List(^dhcbsUnitBonusDetailD(detailID),8)
	s rtn=sValue
		
	i sType="T" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	..s UnitDr=""
	..f  s UnitDr=$O(^dhcbsBonusUnitI("Parent",supUnitID,UnitDr)) q:UnitDr=""  d
	...;判断科室是否在该奖金方案下
	...s rowid=""
	...s rowid=$O(^dhcbsBonusSchemeUnitI("inxSchemeUnit",schemeDr, UnitDr,rowid))
	...q:rowid=""  
	...s unitflag=$list(^dhcbsBonusUnitD(UnitDr),5)
	...;q:unitflag=4 ;当his科室时不计算
	...s UnitType2=$list(^dhcbsBonusUnitD(UnitDr),11)
	...;w "-------------"_UnitType1_":"_UnitType2,!		
	...q:UnitType1'=UnitType2
	...s DataSource=$list(^dhcbsBonusTargetD(itemid),7)
	...;w "DataSource="_DataSource,!
	...i ((DataSource=3) || (DataSource=4))  d ;固定指标取值
	....s CollectDr=""
	....s CollectDr=$O(^dhcbsTargetCalculateRateI("TargetUnit",itemid,UnitDr,CollectDr))
	....i CollectDr>0 d
	.....s sValue=sValue+$List(^dhcbsTargetCalculateRateD(CollectDr),11)
	....i CollectDr="" d ;取指标的默认值
	.....s sValue=sValue+$list(^dhcbsBonusTargetD(itemid),20)
	...e  d ;录入指标取值
	....;w "zlg1="_UnitDr_":"_itemid_":"_syear_":"_sPeriod,!
	....s targetctID=""
	....s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitDr,itemid,syear,sPeriod,targetctID))
	....i targetctID>0 d
	.....s sValue=sValue+ $List(^dhcbsBonusTargetCollectD(targetctID),8)
	.....;w UnitDr_":"_itemid_":"_$List(^dhcbsBonusTargetCollectD(targetctID),8),!
	....;当没有取到值时，调用公式解析，然后再一次取值
	....i targetctID="" d
	.....i rtnFormula'="null" d
	......s sParam2=UnitDr_"^"_syear_"^"_sPeriod_"^"_schemeDr 
	......d ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,rtnFormula, sParam2)
	......s targetctID=""
	......s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitDr,itemid,syear,sPeriod,targetctID))
	......i targetctID>0 d
	.......s sValue=sValue+ $List(^dhcbsBonusTargetCollectD(targetctID),8)
	
	s rtn=$fn(sValue,"",4)
	
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2013-01-18
/// Description：取同级指标平均值
/// Input：sCode：奖金方案项目编码或指标编码 ;sParam:"单元iD^年份^月份^奖金方案ID",如："888^2012^M02^9"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFSum("T06040","742^2013^M01^2")
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFAvg("S102030","208^2012^M01^2")
/// S102030 S102030
ClassMethod BSFAvg(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	s rtn=0
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	
	s UnitID=$p(sParam,"^",1)
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	q:syear="" 0
	q:sPeriod="" 0
	q:UnitID="" 0
	q:code="" 0
	
	
	s supUnitID=0
	s supUnitID=$List(^dhcbsBonusUnitD(UnitID),6)
	s UnitType1=$list(^dhcbsBonusUnitD(UnitID),11)
		
	s sValue=0
	s cValue=0
	s personNum=0
	
	//判断是否有公式
	s rtnFormula= ##class(dhc.bonus.udata.uBonusSchemeCalculate).IsExistFormula(sCode)
	
	i sType="S" d
	.s personNum=0
	.s itemid=0
	.s itemid=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemid))
	.i itemid>0 d
	..s UnitDr=""
	..f  s UnitDr=$O(^dhcbsBonusUnitI("Parent",supUnitID,UnitDr)) q:UnitDr=""  d
	...q:$D(^dhcbsBonusSchemeUnitI("inxSchemeUnit",schemeDr,UnitDr))=0 ;只取本方案下科室
	...s unitflag=$list(^dhcbsBonusUnitD(UnitDr),5)
	...;q:unitflag=4 ;当his科室时不计算
	...s UnitType2=$list(^dhcbsBonusUnitD(UnitDr),11)
	...;w UnitType1_":"_UnitType2,!	
	...q:UnitType1'=UnitType2
	...s personNum=personNum+1
	...s detailID=""
	...s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitDr,itemid,detailID))
	...i detailID>0 d
	....s sValue=sValue+ $List(^dhcbsUnitBonusDetailD(detailID),8)
	....;当没有取到值时，调用公式解析，然后再一次取值
	...i detailID="" d
	....i rtnFormula'="null" d
	.....s sParam2=UnitDr_"^"_syear_"^"_sPeriod_"^"_schemeDr  
	.....d ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,rtnFormula, sParam2)
	.....s detailID=""
	.....s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitDr,itemid,detailID))
	.....i detailID>0 d
	......s sValue=sValue+ $List(^dhcbsUnitBonusDetailD(detailID),8)
	s rtn=sValue
	
	i sType="T" d
	.s personNum=0
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	..s UnitDr=""
	..f  s UnitDr=$O(^dhcbsBonusUnitI("Parent",supUnitID,UnitDr)) q:UnitDr=""  d
	...s unitflag=$list(^dhcbsBonusUnitD(UnitDr),5)
	...;q:unitflag=4 ;当his科室时不计算
	...s UnitType2=$list(^dhcbsBonusUnitD(UnitDr),11)
	...;w UnitType1_":"_UnitType2,!		
	...q:UnitType1'=UnitType2
	...s personNum=personNum+1
	...s DataSource=$list(^dhcbsBonusTargetD(itemid),7)
	...i ((DataSource=3) || (DataSource=4))  d
	....s CollectDr=""
	....s CollectDr=$O(^dhcbsTargetCalculateRateI("TargetUnit",itemid,UnitDr,CollectDr))
	....i CollectDr>0 d
	.....s sValue=sValue+$List(^dhcbsTargetCalculateRateD(CollectDr),11)
	...e  d
	....s targetctID=""
	....s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitDr,itemid,syear,sPeriod,targetctID))
	....i targetctID>0 d
	.....s sValue=sValue+ $List(^dhcbsBonusTargetCollectD(targetctID),8)
	....;当没有取到值时，调用公式解析，然后再一次取值
	....i targetctID="" d
	.....i rtnFormula'="null" d
	......s sParam2=UnitDr_"^"_syear_"^"_sPeriod_"^"_schemeDr 
	......d ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,rtnFormula, sParam2)
	......s targetctID=""
	......s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitDr,itemid,syear,sPeriod,targetctID))
	......i targetctID>0 d
	.......s sValue=sValue+ $List(^dhcbsBonusTargetCollectD(targetctID),8)

	
	i personNum'=0 d
	.s rtn=sValue/personNum
	e  d
	.s rtn=sValue
	s rtn=$fn(rtn,"",4)
	
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2013-05-13
/// Description：取当前月指标所有单元的合计
/// Input：sCode：奖金方案项目编码或指标编码 ;sParam:"单元iD^年份^月份^奖金方案ID",如："888^2012^M02^9"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFSumAll("T03061","742^2013^M03^2")
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFSumAll("S102030","208^2012^M01^2")
/// S102030 S102030
ClassMethod BSFSumAll(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	s rtn=0
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	
	s UnitID=$p(sParam,"^",1)
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	q:syear="" 0
	q:sPeriod="" 0
	q:code="" 0
	
	i sType="S" d
	.s rtn=0
		
	i sType="T" d
	.s Rowid=0
	.s Rowid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,Rowid))
	.i Rowid>0 d
    ..&sql(select SUM(TargetValue) into :rtn  from dhc_bonus_data.BonusTargetCollect 
   			 where BonusYear=:syear and BonusPeriod=:sPeriod and BonusTargetID=:Rowid)

	s rtn=$fn(rtn,"",4)
	
	q rtn
}

/// CreatDate: 2013-07-05
/// Description：取全院临床医生奖金的平均值
/// Input：sCode：奖金方案项目编码或指标编码 ;sParam:"单元iD^年份^月份^奖金方案ID",如："888^2012^M02^9"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFSumAllAVG("T24010","1007^2013^M05^44")
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFSumAllAVG("S0101061","575^2015^M08^1")
ClassMethod BSFSumAllAVG(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	;w sCode_","_sParam,!
	q:sCode="" 0
	q:sParam="" 0
	
	s rtn=0
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	s UnitID=$p(sParam,"^",1)
	s code = $E(sCode,2,$L(sCode))
	
	s itemid=0
	s itemid=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemid))
	i itemid>0 d
	
	.i $G(^dhcbsSchemeAvg)="" d
    ..&sql(select AVG(BonusValue) Into:AvgBonus from dhc_bonus_data.UnitBonusDetail 
   			 where BonusSchemeItemID =:itemid and BonusYear=:syear and BonusPeriod=:sPeriod 
   			 and BonusUnitID->SuperiorUnitID->BonusUnitCode IN (1,2))
	..s rtn=$fn(AvgBonus,"",4)
	..s ^dhcbsSchemeAvg=rtn
	.e  d
	.. s rtn=^dhcbsSchemeAvg
	
	
	
	q rtn
}

/// CreatDate: 2013-07-27
/// Description：取药剂科奖金的平均值（药库、门诊西药房、住院西药房、中药房、制剂室、炮制室）
/// Input：sCode：奖金方案项目编码或指标编码 ;sParam:"单元iD^年份^月份^奖金方案ID",如："888^2012^M02^9"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFSumYJKAVG("T24010","1007^2013^M05^44")
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFSumYJKAVG("S102030","208^2012^M05^2")
/// S102030 S102030
ClassMethod BSFSumYJKAVG(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	s rtn=0
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	s UnitID=$p(sParam,"^",1)
	
	i $G(^dhcbsSchemeAvg)="" d
    .&sql(select AVG(BonusValue) Into:AvgBonus from dhc_bonus_data.UnitBonusDetail 
   			 where BonusYear=:syear and BonusPeriod=:sPeriod 
   			 and BonusSchemeItemID->BonusItemTypeID = '4'
   			 and BonusUnitID->SuperiorUnitID->BonusUnitCode in 
   			 ('D2070','D2071','D2073','D2075','D20771','D20772'))  
	.s rtn=$fn(AvgBonus,"",4)
	.s ^dhcbsSchemeAvg=rtn
	e  d
	. s rtn=^dhcbsSchemeAvg
	
	
	
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2013-01-18
/// Description：取同级指标总和 grandpa
/// Input：sCode：奖金方案项目编码或指标编码 ;sParam:"单元iD^年份^月份^奖金方案ID",如："888^2012^M02^9"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFSumChild("T03100","208^2012^M02^2")
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFSumChild("S102030","208^2012^M01^2")
/// S102030 S102030
ClassMethod BSFSumChild(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	s rtn=0
	
	s code = $E(sCode,2,$L(sCode))
	s supUnitID=$p(sParam,"^",1)
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	

	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	q:syear="" 0
	q:sPeriod="" 0
	q:supUnitID="" 0
	q:code="" 0
	
	;w "aaa",!
	//s supUnitID=0
	//s supUnitID=$List(^dhcbsBonusUnitD(UnitID),6)
	s UnitType1=$list(^dhcbsBonusUnitD(supUnitID),11)
	s sValue=0
	s cValue=0

	//判断是否有公式
	s rtnFormula= ##class(dhc.bonus.udata.uBonusSchemeCalculate).IsExistFormula(sCode)
	
	i sType="S" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemid))
	.i itemid>0 d
	..s UnitDr=""
	..f  s UnitDr=$O(^dhcbsBonusUnitI("Parent",supUnitID,UnitDr)) q:UnitDr=""  d
	...s unitflag=$list(^dhcbsBonusUnitD(UnitDr),5)
	...q:unitflag=4 ;当his科室时不计算
	...s UnitType2=$list(^dhcbsBonusUnitD(UnitDr),11)	
	...;q:UnitType1'=UnitType2
	...s detailID=""
	...s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitDr,itemid,detailID))
	...i detailID>0 d
	....s sValue=sValue+ $List(^dhcbsUnitBonusDetailD(detailID),8)
	....;当没有取到值时，调用公式解析，然后再一次取值
	...i detailID="" d
	....i rtnFormula'="null" d
	.....s sParam2=UnitDr_"^"_syear_"^"_sPeriod_"^"_schemeDr  
	.....d ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,rtnFormula, sParam2)
	.....s detailID=""
	.....s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitDr,itemid,detailID))
	.....i detailID>0 d
	......s sValue=sValue+ $List(^dhcbsUnitBonusDetailD(detailID),8)
	s rtn=sValue
		
	i sType="T" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	..s UnitDr=""
	..f  s UnitDr=$O(^dhcbsBonusUnitI("Parent",supUnitID,UnitDr)) q:UnitDr=""  d
	...s unitflag=$list(^dhcbsBonusUnitD(UnitDr),5)
	...q:unitflag=4 ;当his科室时不计算
	...s UnitType2=$list(^dhcbsBonusUnitD(UnitDr),11)	
	...;q:UnitType1'=UnitType2
	...;w UnitDr,!
	...s DataSource=$list(^dhcbsBonusTargetD(itemid),7)
	...i ((DataSource=3) || (DataSource=4))  d
	....s CollectDr=""
	....s CollectDr=$O(^dhcbsTargetCalculateRateI("TargetUnit",itemid,UnitDr,CollectDr))
	....i CollectDr>0 d
	.....s sValue=sValue+$List(^dhcbsTargetCalculateRateD(CollectDr),11)
	...e  d
	....s targetctID=""
	....s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitDr,itemid,syear,sPeriod,targetctID))
	....i targetctID>0 d
	.....s sValue=sValue+ $List(^dhcbsBonusTargetCollectD(targetctID),8)
	....;当没有取到值时，调用公式解析，然后再一次取值
	....i targetctID="" d
	.....i rtnFormula'="null" d
	......s sParam2=UnitDr_"^"_syear_"^"_sPeriod_"^"_schemeDr 
	......d ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,rtnFormula, sParam2)
	......s targetctID=""
	......s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitDr,itemid,syear,sPeriod,targetctID))
	......i targetctID>0 d
	.......s sValue=sValue+ $List(^dhcbsBonusTargetCollectD(targetctID),8)
	
	s rtn=$fn(sValue,"",4)
	
	q rtn
}

/// Description：取同级指标平均数 grandpa
/// Input：sCode：奖金方案项目编码或指标编码 ;sParam:"单元iD^年份^月份^奖金方案ID",如："888^2012^M02^9"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFAvgChild("T03100","208^2012^M02^2")
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFAvgChild("S102030","208^2015^M08^1")
ClassMethod BSFAvgChild(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	s rtn=0
	
	s code = $E(sCode,2,$L(sCode))
	s supUnitID=$p(sParam,"^",1)
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	

	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	q:syear="" 0
	q:sPeriod="" 0
	q:supUnitID="" 0
	q:code="" 0
	
	;w "aaa",!
	//s supUnitID=0
	//s supUnitID=$List(^dhcbsBonusUnitD(UnitID),6)
	s UnitType1=$list(^dhcbsBonusUnitD(supUnitID),11)
	s sValue=0
	s cValue=0
	s personNum=0


	//判断是否有公式
	s rtnFormula= ##class(dhc.bonus.udata.uBonusSchemeCalculate).IsExistFormula(sCode)
	
	i sType="S" d
	.s personNum=0
	.s itemid=0
	.s itemid=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemid))
	.i itemid>0 d
	..s UnitDr=""
	..f  s UnitDr=$O(^dhcbsBonusUnitI("Parent",supUnitID,UnitDr)) q:UnitDr=""  d
	...s unitflag=$list(^dhcbsBonusUnitD(UnitDr),5)
	...q:unitflag=4 ;当his科室时不计算
	...s UnitType2=$list(^dhcbsBonusUnitD(UnitDr),11)	
	...;q:UnitType1'=UnitType2
	...s personNum=personNum+1
	...s detailID=""
	...s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitDr,itemid,detailID))
	...i detailID>0 d
	....s sValue=sValue+ $List(^dhcbsUnitBonusDetailD(detailID),8)
	....;当没有取到值时，调用公式解析，然后再一次取值
	...i detailID="" d
	....i rtnFormula'="null" d
	.....s sParam2=UnitDr_"^"_syear_"^"_sPeriod_"^"_schemeDr  
	.....d ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,rtnFormula, sParam2)
	.....s detailID=""
	.....s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitDr,itemid,detailID))
	.....i detailID>0 d
	......s sValue=sValue+ $List(^dhcbsUnitBonusDetailD(detailID),8)
	s rtn=sValue
		
	i sType="T" d
	.s personNum=0
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	..s UnitDr=""
	..f  s UnitDr=$O(^dhcbsBonusUnitI("Parent",supUnitID,UnitDr)) q:UnitDr=""  d
	...s unitflag=$list(^dhcbsBonusUnitD(UnitDr),5)
	...q:unitflag=4 ;当his科室时不计算
	...s UnitType2=$list(^dhcbsBonusUnitD(UnitDr),11)	
	...;q:UnitType1'=UnitType2
	...;w UnitDr,!
	...s personNum=personNum+1
	...s DataSource=$list(^dhcbsBonusTargetD(itemid),7)
	...i ((DataSource=3) || (DataSource=4))  d
	....s CollectDr=""
	....s CollectDr=$O(^dhcbsTargetCalculateRateI("TargetUnit",itemid,UnitDr,CollectDr))
	....i CollectDr>0 d
	.....s sValue=sValue+$List(^dhcbsTargetCalculateRateD(CollectDr),11)
	...e  d
	....s targetctID=""
	....s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitDr,itemid,syear,sPeriod,targetctID))
	....i targetctID>0 d
	.....s sValue=sValue+ $List(^dhcbsBonusTargetCollectD(targetctID),8)
	....;当没有取到值时，调用公式解析，然后再一次取值
	....i targetctID="" d
	.....i rtnFormula'="null" d
	......s sParam2=UnitDr_"^"_syear_"^"_sPeriod_"^"_schemeDr 
	......d ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,rtnFormula, sParam2)
	......s targetctID=""
	......s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitDr,itemid,syear,sPeriod,targetctID))
	......i targetctID>0 d
	.......s sValue=sValue+ $List(^dhcbsBonusTargetCollectD(targetctID),8)
	
	i personNum'=0 d
	.s rtn=sValue/personNum
	e  d
	.s rtn=sValue
	
	s rtn=$fn(rtn,"",4)
	
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2013-01-18
/// Description：取上同祖父指标总和 grandpa
/// Input：sCode：奖金方案项目编码或指标编码 ;sParam:"单元iD^年份^月份^奖金方案ID",如："888^2012^M02^9"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFGrandpaSum("T03503","234^2012^M01^2")
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFGrandpaSum("S102030","208^2012^M01^2")
/// S102030 S102030
ClassMethod BSFSumGrandpa(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	q:sCode="" 0
	q:sParam="" 0 
	
	s rtn=0
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	
	s UnitID=$p(sParam,"^",1)
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	

	s supUnitID="" //父亲级别
	s supUnitID=$List(^dhcbsBonusUnitD(UnitID),6)
	
	s supUnitID2="" //祖父级别
	s supUnitID2=$List(^dhcbsBonusUnitD(supUnitID),6)
	q:supUnitID2="" 0
	
	s sValue=0
	s cValue=0
	
	//判断是否有公式
	s rtnFormula= ##class(dhc.bonus.udata.uBonusSchemeCalculate).IsExistFormula(sCode)
	//##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate()
	
	i sType="S" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemid))
	.i itemid>0 d
	
	..s Unit2Dr=""
	..f  s Unit2Dr=$O(^dhcbsBonusUnitI("Parent",supUnitID2,Unit2Dr)) q:Unit2Dr=""  d
	...s UnitDr=""
	...f  s UnitDr=$O(^dhcbsBonusUnitI("Parent",Unit2Dr,UnitDr)) q:UnitDr=""  d
	....s unitflag=$list(^dhcbsBonusUnitD(UnitDr),5)
	....q:unitflag=4 ;当his科室时不计算
	....s detailID=""
	....s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitDr,itemid,detailID))
	....i detailID>0 d
	.....s sValue=sValue+ $List(^dhcbsUnitBonusDetailD(detailID),8)
	.....;当没有取到值时，调用公式解析，然后再一次取值
	....i detailID="" d
	.....i rtnFormula'="null" d
	......s sParam2=UnitDr_"^"_syear_"^"_sPeriod_"^"_schemeDr  
	......d ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,rtnFormula, sParam2)
	......s detailID=""
	......s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitDr,itemid,detailID))
	......i detailID>0 d
	.......s sValue=sValue+ $List(^dhcbsUnitBonusDetailD(detailID),8)
	s rtn=sValue
		
	i sType="T" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	
	..s Unit2Dr=""
	..f  s Unit2Dr=$O(^dhcbsBonusUnitI("Parent",supUnitID2,Unit2Dr)) q:Unit2Dr=""  d

	...s UnitDr=""
	...f  s UnitDr=$O(^dhcbsBonusUnitI("Parent",Unit2Dr,UnitDr)) q:UnitDr=""  d
	....s unitflag=$list(^dhcbsBonusUnitD(UnitDr),5)
	....q:unitflag=4 ;当his科室时不计算
	
	....s DataSource=$list(^dhcbsBonusTargetD(itemid),7)
	....i ((DataSource=3) || (DataSource=4))  d
	.....s CollectDr=""
	.....s CollectDr=$O(^dhcbsTargetCalculateRateI("TargetUnit",itemid,UnitDr,CollectDr))
	.....i CollectDr>0 d
	......s sValue=sValue+$List(^dhcbsTargetCalculateRateD(CollectDr),11)
	....e  d
	.....s targetctID=""
	.....s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitDr,itemid,syear,sPeriod,targetctID))
	.....i targetctID>0 d
	......s sValue=sValue+ $List(^dhcbsBonusTargetCollectD(targetctID),8)
	.....;当没有取到值时，调用公式解析，然后再一次取值
	.....i targetctID="" d
	......i rtnFormula'="null" d
	.......s sParam2=UnitDr_"^"_syear_"^"_sPeriod_"^"_schemeDr 
	.......d ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,rtnFormula, sParam2)
	.......s targetctID=""
	.......s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitDr,itemid,syear,sPeriod,targetctID))
	.......i targetctID>0 d
	........s sValue=sValue+ $List(^dhcbsBonusTargetCollectD(targetctID),8)
	
	s rtn=$fn(sValue,"",4)
	
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2013-05-2
/// Description：取指标反值，当指标值大于等1时返回0，小于等0时返回1.
/// Input：sCode：指标编码 ;sParam:"单元iD^年份^月份^奖金方案ID",如："888^2012^M02^9"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFContrary("T90020","111^2012^M01^3")
/// S102030 S102030
ClassMethod BSFContrary(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	q:sCode="" 0
	q:sParam="" 0 
	s sValue=0
	
	s rtn=1
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	s UnitID=$p(sParam,"^",1)
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	i sType="T" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	..;w UnitID_":"_itemid_":"_syear_":"_sPeriod,!
	..s targetctID=""
	..s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitID,itemid,syear,sPeriod,targetctID))
	..i targetctID>0 d
	...s sValue= $List(^dhcbsBonusTargetCollectD(targetctID),8)
	...i sValue>0  d
	....s rtn=0
	...e  d
	....s rtn=1
	
	q rtn
}

/// CreatDate: 2013-07-05
/// Description：取指标反值，当指标值大于3时返回0，小于等3时返回1.
/// Input：sCode：指标编码 ;sParam:"单元iD^年份^月份^奖金方案ID",如："888^2012^M02^9"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFContrary3("T90020","111^2012^M01^3")
/// S102030 S102030
ClassMethod BSFContrary3(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	q:sCode="" 0
	q:sParam="" 0 
	s sValue=0
	
	s rtn=1
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	s UnitID=$p(sParam,"^",1)
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	i sType="T" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	..;w UnitID_":"_itemid_":"_syear_":"_sPeriod,!
	..s targetctID=""
	..s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitID,itemid,syear,sPeriod,targetctID))
	..i targetctID>0 d
	...s sValue= $List(^dhcbsBonusTargetCollectD(targetctID),8)
	...i sValue>=3  d
	....s rtn=0
	...e  d
	....s rtn=1
	
	q rtn
}

/// CreatDate: 2013-12-12
/// Description：取指标正值，当指标值大于0时返回1，小于等0时返回0.
/// Input：sCode：指标编码 ;sParam:"单元iD^年份^月份^奖金方案ID",如："888^2012^M02^9"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFConsistent("T90020","111^2012^M01^3")
/// S102030 S102030
ClassMethod BSFConsistent(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	q:sCode="" 0
	q:sParam="" 0 
	s sValue=0
	
	s rtn=1
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	s UnitID=$p(sParam,"^",1)
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	i sType="T" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	..;w UnitID_":"_itemid_":"_syear_":"_sPeriod,!
	..s targetctID=""
	..s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitID,itemid,syear,sPeriod,targetctID))
	..i targetctID>0 d
	...s sValue= $List(^dhcbsBonusTargetCollectD(targetctID),8)
	...i sValue>0  d
	....s rtn=1
	...e  d
	....s rtn=0
	..e  d
	...s rtn=0
	
	q rtn
}

/// CreatDate: 2013-08-2
/// Description：取当月天数.
/// Input：sCode：指标编码 ;sParam:"单元iD^年份^月份^奖金方案ID",如："888^2012^M02^9"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSDays("T90020","111^2012^M01^3")
/// S102030 S102030
ClassMethod BSDays(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	;q:sCode="" 0
	q:sParam="" 0 
	s sValue=0
	
	s rtn=1
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	s UnitID=$p(sParam,"^",1)
	;s code = $E(sCode,2,$L(sCode))
	;s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	s sValue= 0
	i (sPeriod = "M02") d
	.i (((syear/4)-(syear\4)=0)&&((syear/100)-(syear\100)'=0))||((syear/400)-(syear\400)=0) d 
	..s sValue = "29"
	.e  d
	..s sValue = "28"
	e  i (sPeriod = "M01")||(sPeriod = "M03")||(sPeriod = "M05")||(sPeriod = "M07")||(sPeriod = "M08")||(sPeriod = "M10")||(sPeriod = "M12") d
	.s sValue = "31"
	e  d
	.s sValue = "30"
	
    s rtn = sValue
	
	q rtn
}

/// CreatDate: 2013-08-30
/// Description：取病房支援门诊奖金.
/// Input：sCode：指标编码 ;sParam:"单元iD^年份^月份^奖金方案ID",如："888^2012^M02^9"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSBfzymzjj("T90020","111^2012^M01^3")
/// S102030 S102030
ClassMethod BSBfzymzjj(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	;q:sCode="" 0
	q:sParam="" 0 
	s sValue=0
	
	s rtn=1
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	s UnitID=$p(sParam,"^",1)
	;s code = $E(sCode,2,$L(sCode))
	;s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	s sValue= 0
	&sql( select AVG(BonusValue) Into:sValue from dhc_bonus_data.UnitBonusDetail 
	      where BonusYear =:syear and BonusPeriod =:sPeriod 
	      and BonusSchemeItemID->SchemeItemCode = '2031040')
	
    s rtn = sValue
	
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2013-01-18
/// Description：取同级指标总和 grandpa
/// Input：sCode：奖金方案项目编码或指标编码 ;sParam:"单元iD^年份^月份^奖金方案ID",如："888^2012^M02^26"
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFSumSpecial("S0401030","742^2013^M04^26")
/// Others：w ##class(dhc.bonus.udata.uBonusCalcFunction).BSFSumSpecial("T06040","208^2012^M01^2")
/// ^#Sum#S0401030^/^3
ClassMethod BSFSumSpecial(sCode As %String, sParam As %String) As %String
{
	n (sCode,sParam)
	
	s rtn=0
	s syear=$p(sParam,"^",2)
	s sPeriod=$p(sParam,"^",3)
	s schemeDr=$p(sParam,"^",4)
	s UnitID=$p(sParam,"^",1)
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	q:syear="" 0
	q:sPeriod="" 0
	q:UnitID="" 0
	q:code="" 0
	s supUnitID=0
	s supUnitID=$List(^dhcbsBonusUnitD(UnitID),6)
	s UnitType1=$list(^dhcbsBonusUnitD(UnitID),11)
	s sValue=0
	s cValue=0
	
	
	//判断是否有公式
	s rtnFormula= ##class(dhc.bonus.udata.uBonusSchemeCalculate).IsExistFormula(sCode)
	//##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate()
	
	i sType="S" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemid))
	.i itemid>0 d
	..s UnitDr=""
	..f  s UnitDr=$O(^dhcbsBonusUnitI("Parent",supUnitID,UnitDr)) q:UnitDr=""  d
	...;q:$D(^dhcbsBonusSchemeUnitI("inxSchemeUnit",schemeDr,UnitDr))=0 ;只取本方案下科室
	
	...;判断科室是否在该奖金方案下
	...;s rowid=""
	...;s rowid=$O(^dhcbsBonusSchemeUnitI("inxSchemeUnit",schemeDr, UnitDr,rowid))
	...;q:rowid=""  

	...s unitflag=$list(^dhcbsBonusUnitD(UnitDr),5)
	...;q:unitflag=4 ;当his科室时不计算
	...s UnitType2=$list(^dhcbsBonusUnitD(UnitDr),11)
	...;w UnitType1_":"_UnitType2,!	
	...q:UnitType1'=UnitType2
	...s detailID=""
	...s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitDr,itemid,detailID))
	...i detailID>0 d
	....s sValue=sValue+ $List(^dhcbsUnitBonusDetailD(detailID),8)
	....;w UnitDr_":"_itemid_":"_$List(^dhcbsUnitBonusDetailD(detailID),8),!
	....;当没有取到值时，调用公式解析，然后再一次取值
	...i detailID="" d
	....i rtnFormula'="null" d
	.....s sParam2=UnitDr_"^"_syear_"^"_sPeriod_"^"_schemeDr  
	.....d ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,rtnFormula, sParam2)
	.....s detailID=""
	.....s detailID=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",syear,sPeriod,UnitDr,itemid,detailID))
	.....i detailID>0 d
	......s sValue=sValue+ $List(^dhcbsUnitBonusDetailD(detailID),8)
	s rtn=sValue
		
	i sType="T" d
	.s itemid=0
	.s itemid=$O(^dhcbsBonusTargetI("BonusTargetCode",code,itemid))
	.i itemid>0 d
	..s UnitDr=""
	..f  s UnitDr=$O(^dhcbsBonusUnitI("Parent",supUnitID,UnitDr)) q:UnitDr=""  d
	
	...;判断科室是否在该奖金方案下
	...;s rowid=""
	...;s rowid=$O(^dhcbsBonusSchemeUnitI("inxSchemeUnit",schemeDr, UnitDr,rowid))
	...;q:rowid=""  
	
	...s unitflag=$list(^dhcbsBonusUnitD(UnitDr),5)
	...;q:unitflag=4 ;当his科室时不计算
	...s UnitType2=$list(^dhcbsBonusUnitD(UnitDr),11)
	...;w "-------------"_UnitType1_":"_UnitType2,!		
	...q:UnitType1'=UnitType2
	...s DataSource=$list(^dhcbsBonusTargetD(itemid),7)
	...;w "DataSource="_DataSource,!
	...i ((DataSource=3) || (DataSource=4))  d ;固定指标取值
	....s CollectDr=""
	....s CollectDr=$O(^dhcbsTargetCalculateRateI("TargetUnit",itemid,UnitDr,CollectDr))
	....i CollectDr>0 d
	.....s sValue=sValue+$List(^dhcbsTargetCalculateRateD(CollectDr),11)
	....i CollectDr="" d ;取指标的默认值
	.....s sValue=sValue+$list(^dhcbsBonusTargetD(itemid),20)
	...e  d ;录入指标取值
	....;w "zlg1="_UnitDr_":"_itemid_":"_syear_":"_sPeriod,!
	....s targetctID=""
	....s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitDr,itemid,syear,sPeriod,targetctID))
	....i targetctID>0 d
	.....s sValue=sValue+ $List(^dhcbsBonusTargetCollectD(targetctID),8)
	.....;w UnitDr_":"_itemid_":"_$List(^dhcbsBonusTargetCollectD(targetctID),8),!
	....;当没有取到值时，调用公式解析，然后再一次取值
	....i targetctID="" d
	.....i rtnFormula'="null" d
	......s sParam2=UnitDr_"^"_syear_"^"_sPeriod_"^"_schemeDr 
	......d ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate(sCode,rtnFormula, sParam2)
	......s targetctID=""
	......s targetctID=$O(^dhcbsBonusTargetCollectI("BsTarget",UnitDr,itemid,syear,sPeriod,targetctID))
	......i targetctID>0 d
	.......s sValue=sValue+ $List(^dhcbsBonusTargetCollectD(targetctID),8)
	
	s rtn=$fn(sValue,"",4)
	
	q rtn
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusCalcFu735S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
