/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-05
/// Description: 科室奖金核算计算
/// Class dhc.bonus.udata.uBonusSchemeCalculate Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
Class dhc.bonus.udata.uBonusSchemeCalculate Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/*---------公用变量说明--------------------
1、datasource取值：
		'手工录入', : 1
		'公式计算', : 2
		'区间计算', : 3
		'比例系数', : 4
		'辅助处理', : 5
		'差额累加', : 6
		'差率累加', : 7
		'累加求和'  : 8

*/
/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-07
/// Description：奖金方案核算
/// Return: 返回操作结果
/// Input：BonusSchemeCode：奖金方案Code;sBonusPeriod:格式 "BonusYear^BonusPeriod"
/// Others：w ##class(dhc.bonus.udata.uBonusSchemeCalculate).BonusSchemeCalculate("0101","2016^M01")
ClassMethod BonusSchemeCalculate(BonusSchemeCode, sBonusPeriod) As %String
{
	n (BonusSchemeCode,sBonusPeriod)

	
	k ^dhcbsSchemeAvg
	k ^dhcBonusSumST
	s uBonusEmployee= ##class(dhc.bonus.udata.uBonusEmployee).%New()
	
	s sBonusYear = $P(sBonusPeriod,"^",1)
	s sBonusPeriod = $P(sBonusPeriod,"^",2)
		
	&SQL(delete from  dhc_bonus_data.UnitBonusDetail where BonusSchemeID->BonusSchemeCode=:BonusSchemeCode and BonusYear=:sBonusYear and BonusPeriod=:sBonusPeriod)

	s sqlstr="select b.BonusSchemeItemID,a.BonusSchemeID,d.BonusUnitID,b.BonusSchemeItemID,b.BonusType,SchemeItemCode,BonusFormula,a.CalculateWay,a.CalculateMethod "
	s sqlstr=sqlstr_" from dhc_bonus_data.BonusScheme a,dhc_bonus_data.BonusSchemeItem b,dhc_bonus_data.BonusSchemeUnit c,dhc_bonus_data.BonusUnit d"
	s sqlstr=sqlstr_" where a.BonusSchemeID=B.BonusSchemeID and a.BonusSchemeID=c.BonusSchemeID and c.BonusUnitID=d.BonusUnitID and d.IsValid=1"
	s sqlstr=sqlstr_"  and DataSource=2 and a.BonusSchemeCode='"_BonusSchemeCode_"'" _" order by b.SchemeItemCode "
	;q sqlstr
	;w sqlstr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlstr)
	d result.Execute()
	
	s BonusSchemeID =""
	s BonusSchemeItemID =""
	s RealBonus =0
	s DeptPersonNumber = 0
	s sBonusUnitID =0
	s RealBonusID = 0
	s isExist =0 
	
	s idx=0
	;TSTART
	
	While(result.Next()){
		s isExist =1 
		s BonusUnitID =result.Data("BonusUnitID")
		s SchemeItemCode ="S"_result.Data("SchemeItemCode")
		s BonusFormula =result.Data("BonusFormula")
		s sBonusSchemeID = result.Data("BonusSchemeID")
		s CalculateWay = result.Data("CalculateWay")
		s CalculateMethod = result.Data("CalculateMethod")
		s BonusType =result.Data("BonusType")
		s BonusSchemeID =result.Data("BonusSchemeID")
		s BonusSchemeItemID=result.Data("BonusSchemeItemID")
		s idx=idx+1
		s sParam =BonusUnitID_"^"_sBonusYear_"^"_sBonusPeriod_"^"_sBonusSchemeID
		//判断是否有函数
		;w idx_":"_BonusSchemeItemID_":"_SchemeItemCode_":"_BonusFormula_":"_sParam,!
		
		//解析奖金公式，并获取奖金项的值。
		s rtnvalue=..FormulaTranslate(SchemeItemCode,BonusFormula,sParam)
		
		if BonusType=1
		{
			s RealBonusID =result.Data("BonusSchemeItemID")
			s sBonusUnitID =result.Data("BonusUnitID")
			s RealBonus =rtnvalue
			
			//得到科室人员数
			s DeptPersonNumber=0  ;uBonusEmployee.GetUnitEmployeeCount(sBonusUnitID)
			//保存奖金实发情况表
			s uUnitBonusPay= ##class(dhc.bonus.udata.uUnitBonusPay).%New()
			s sdata=BonusSchemeID_"^"_sBonusUnitID_"^"_sBonusYear_"^"_sBonusPeriod_"^"_RealBonusID_"^"_RealBonus_"^"_DeptPersonNumber
			s rtnNo = uUnitBonusPay.SetUnitBonusPay(sdata)
			if (rtnNo'=0) && (rtnNo'=100) s rtn = rtnNo
		}
		
	}
	d result.Close()
	
	s rtnNo=0
	s rtn =0 
	i isExist =0 q "该奖金方案没有设置奖金项，不能核算！"
	
	//TSTART
	s uUnitBonusMain= ##class(dhc.bonus.udata.uUnitBonusMain).%New()
	s rtnNo= uUnitBonusMain.SetUnitBonusMain(BonusSchemeID_"^"_sBonusYear_"^"_sBonusPeriod) 
	if (rtnNo'=0) && (rtnNo'=100)  s rtn = rtnNo
	/*
	if rtn'=0 d 
	.TROLLBACK
	E   d
	.TCOMMIT
		*/	
		
	k ^dhcbsSchemeAvg
	k ^dhcBonusSumST
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-05
/// Description: 获取某个指标或奖金项的值
/// Parmeter: scode:指标编码、奖金项编码或运算符，sParam:"^unitID^BonusYear^PeriodCode"
/// Return: 返回公式项的值value
/// 调用函数：BonusSchemeCalculate()->FormulaTranslate()->GetFormulaItemVale()
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetFormulaItemVale("T0401002","848^2012^M02^9") :
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetFormulaItemVale("T020007","1096^2011^M11^2")
ClassMethod GetFormulaItemVale(scode, sParam As %String) As %String
{
	n (scode,sParam)

	q:scode="" " "
	s rtn="null"
	s Code =$E(scode,2,$L(scode))
		
	///T:奖金指标编码
	if $E(scode,1,1)="T" {
		s rowID = ..GetTargetRowID(Code)
		
		s DataSource= -1
		
		i rowID>0 d
		.s DataSource= $li(^dhcbsBonusTargetD(rowID),7)
	
		if (DataSource= 1) ||(DataSource= 2) ||(DataSource= 9) {
		//指标数据来源:指标采集表BonusTargetCollect (说明 1：录入、2：公式)
	      s rtn = ..GetBonusTargetValue(Code,sParam)
		}elseif (DataSource=3) ||(DataSource= 4){
			//指标数据来源:指标系数设置表 （3： 区间计算、4:比例系数）
	   		s rtn = ..GetBonusTargetRate(Code,sParam)
		}elseif (DataSource=5) {
			//指标数据来源:SH奖金辅助指标汇总表BonusSubMain （5：奖金辅助指标）
	   		s rtn = ..GetBonusSubsValue(Code,sParam)
		}elseif (DataSource=7) {
			//指标数据来源:指标系数设置表 （7：差额比率）
	   		s rtn = ..GetCLLJTargetRate(Code,sParam)
		}elseif (DataSource=8) {
			//指标数据来源:指标采集表BonusTargetCollect （8：累加求和）
	   		s rtn = ..GetTargetSumValue(Code,sParam)
		}/*elseif (DataSource=9) {
			//指标数据来源:指标采集表BonusTargetCollect、指标系数设置表 （9：数量单价）
	   		s rtn = ..GetTargetNumPriceSum(Code,sParam)
	   		}*/
		elseif (DataSource=10) {
			//指标数据来源:收入总表 （10：收入指标）;2015-08-25 zlg
	   		s rtn = ..GetIncValue(Code,sParam)
		}elseif (DataSource=11) {
			//指标数据来源:支出总表 （11：支出指标）;2015-08-28 zlg
	   		s rtn = ..GetExpValue(Code,sParam)
		}			
	//S:奖金项目编码 GetTargetSumValue GetIncValue
	}ElseIf  $E(scode,1,1)="S"{
		
		s rtn= ..GetSchemeItemVale(Code,sParam)
	} else{
		//当scode不是以T或S开头的，如，运算符，+，-等不进行取值，直接返回。
		s rtn = scode
	}
	q rtn
}

/// GetBonusSubsValue
/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-05
/// Description: 从指标采集表中获取指标的值
/// Parmeter: targetcode:指标编码，sParam:"^unitID^PeriodCode" 
/// Return: 返回指定指标的值
/// 调用函数：BonusSchemeCalculate()->FormulaTranslate()->GetFormulaItemVale()->GetBonusTargetValue
/// Others:  w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetBonusTargetValue("0800101","91^2011^M01")
ClassMethod GetBonusTargetValue(targetcode, sParam As %String) As %String
{
	n (targetcode,sParam)
	q:targetcode="" "Empty_targetcode"
	
	s unitID=$p(sParam,"^",1)
	s BonusYear=$p(sParam,"^",2)
	s BonusPeriod=$p(sParam,"^",3)
	s targetID=""
	s targetID = ..GetTargetRowID(targetcode)
	
	q:unitID="" 0
	q:targetID="" 0
	q:BonusYear="" 0
	q:BonusPeriod="" 0
	/*
	s sqlStr= ""
	s sqlStr ="select TargetValue from dhc_bonus_data.BonusTargetCollect   "
	s sqlStr = sqlStr_" where BonusTargetID="_targetID
	s sqlStr = sqlStr_"  and BonusUnitID="_unitID
	s sqlStr = sqlStr_"  and  BonusYear='"_BonusYear_"'"
	s sqlStr = sqlStr_"  and  BonusPeriod='"_BonusPeriod_"'"

		
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s svalue=0
	
	//相同指标值取之和
	While(result.Next()){
	
		s svalue =result.Data("TargetValue") ;svalue+
	}
	d result.Close()
	*/
	
	//-------赵立国  20130502 改造-----------------------------
	
	s svalue=0
	s rowid=""
	f  s rowid=$O(^dhcbsBonusTargetCollectI("BsTarget",unitID,targetID,BonusYear,BonusPeriod,rowid)) q:rowid=""  d
	.i rowid'="" d
	..s svalue=svalue+$LI(^dhcbsBonusTargetCollectD(rowid),8)

	q svalue
}

/// GetBonusSubsValue
/// Creator: Zhao LiGuo
/// CreatDate: 2015-08-25
/// Description: 从收入总表中取值
/// Parmeter: targetcode:指标编码，sParam:"^unitID^PeriodCode" 
/// Return: 返回指定指标的值
/// 调用函数：
/// Others:  w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetIncValue("05012","573^2015^M08")
ClassMethod GetIncValue(targetcode, sParam As %String) As %String
{
	n (targetcode,sParam)
	q:targetcode="" "Empty_targetcode"
	
	s unitID=$p(sParam,"^",1)
	s BonusYear=$p(sParam,"^",2)
	s BonusPeriod=$p(sParam,"^",3)
	s targetID=""
	;s targetID = ..GetTargetRowID(targetcode)
	
	q:unitID="" 0
	q:targetcode="" 0
	q:BonusYear="" 0
	q:BonusPeriod="" 0
	
   /*
   ^dhcbsBonusUnitI  zlg666
   */
   
   
	s svalue=0
	s rowid=""
	f  s rowid=$O(^dhcbsmoduleBonusIncMainI("IncMain",BonusYear,BonusPeriod,targetcode, unitID,rowid)) q:rowid=""  d
	.i rowid'="" d
	..s svalue=svalue+$LI(^dhcbsmoduleBonusIncMainD(rowid),6)
	;w "svalue1="_svalue,!
	s supunitID=unitID
	
	;s svalue=0
	s deptid=""
	f  s deptid=$O(^dhcbsBonusUnitI("Parent",supunitID,deptid)) q:deptid=""  d
	.i deptid'="" d
	..s rowid=""
	..f  s rowid=$O(^dhcbsmoduleBonusIncMainI("IncMain",BonusYear,BonusPeriod,targetcode, deptid,rowid)) q:rowid=""  d
	...i rowid'="" d
	....s svalue=svalue+$LI(^dhcbsmoduleBonusIncMainD(rowid),6)
	
	;w "svalue2="_svalue,!

	q svalue
}

/// GetBonusSubsValue
/// Creator: Zhao LiGuo
/// CreatDate: 2015-08-25
/// Description: 从收入总表中取值
/// Parmeter: targetcode:指标编码，sParam:"^unitID^PeriodCode" 
/// Return: 返回指定指标的值
/// 调用函数：
/// Others:  w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetExpValue("05023","571^2015^M06")
ClassMethod GetExpValue(targetcode, sParam As %String) As %String
{
	n (targetcode,sParam)
	q:targetcode="" "Empty_targetcode"
	
	s unitID=$p(sParam,"^",1)
	s BonusYear=$p(sParam,"^",2)
	s BonusPeriod=$p(sParam,"^",3)
	s targetID=""
	;s targetID = ..GetTargetRowID(targetcode)
	
	q:unitID="" 0
	q:targetcode="" 0
	q:BonusYear="" 0
	q:BonusPeriod="" 0
	

	s svalue=0
	s rowid=""
	f  s rowid=$O(^dhcbsmoduleBonusExpMainI("expData",BonusYear,BonusPeriod,targetcode, unitID,rowid)) q:rowid=""  d
	.i rowid'="" d
	..s svalue=svalue+$LI(^dhcbsmoduleBonusExpMainD(rowid),6)

	q svalue
}

/// GetBonusSubsValue
/// Creator: Zhao LiGuo
/// CreatDate: 2014-12-24 平安夜 于芜湖
/// Description:  增加 数量、单价类指标，该类指标集数量与单价于一体
/// Description: 取值原则：指标采集表、系数指标表、指标字典表
/// Parmeter: targetcode:指标编码，sParam:"^unitID^PeriodCode" 
/// Return: 返回指定指标的值=数量*单价
/// 调用函数：
/// Others:  w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetTargetNumPriceSum("0800101","91^2011^M01")
ClassMethod GetTargetNumPriceSum(targetcode, sParam As %String) As %String
{
	n (targetcode,sParam)
	q:targetcode="" "Empty_targetcode"
	
	s unitID=$p(sParam,"^",1)
	s BonusYear=$p(sParam,"^",2)
	s BonusPeriod=$p(sParam,"^",3)
	s targetID=""
	s targetID = ..GetTargetRowID(targetcode)
	
	q:unitID="" 0
	q:targetID="" 0
	q:BonusYear="" 0
	q:BonusPeriod="" 0

	
	s svalue=0
	s sPrice=""
	s rowid=""
	f  s rowid=$O(^dhcbsBonusTargetCollectI("BsTarget",unitID,targetID,BonusYear,BonusPeriod,rowid)) q:rowid=""  d
	.i rowid'="" d
	..s snum=$LI(^dhcbsBonusTargetCollectD(rowid),8)
	..s sPrice=svalue+$LI(^dhcbsBonusTargetCollectD(rowid),13)
	..i sPrice'="" d
	...s sPrice=..GetBonusTargetRate(targetcode, sParam) ;取指标系数维护表
	..i sPrice'="" d
	...s sPrice=$list(^dhcbsBonusTargetD(rowid),20) ;取指标默认值
	..i sPrice'="" s sPrice=1
	..s sSum=snum*sPrice
	..s svalue=svalue+sSum
	q svalue
}

/// GetBonusSubsValue
/// Creator: Zhao LiGuo
/// CreatDate: 2012-08-11
/// Description: 取方案下指标值的和，来源指标采集表
/// Parmeter: targetcode:指标编码，sParam:"^unitID^BonusYear^PeriodCode" 
/// Return: 返回指定指标的值
/// 调用函数：BonusSchemeCalculate()->FormulaTranslate()->GetFormulaItemVale()->GetTargetSumValue
/// Others:  w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetTargetSumValue("1411","91^2012^M01^18")
ClassMethod GetTargetSumValue(targetcode, sParam As %String) As %String
{
	n (targetcode,sParam)
	q:targetcode="" "Empty_targetcode"
	
	s unitID=$p(sParam,"^",1)
	s BonusYear=$p(sParam,"^",2)
	s BonusPeriod=$p(sParam,"^",3)
	s schemeID=$p(sParam,"^",4)
	s targetID=0

	;s targetID = ..GetTargetRowID(targetcode)
	s sqlStr= ""
	s sqlStr ="select  b.BonusUnitID,b.BonusUnitID->BonusUnitName,BonusTargetID,"
	s sqlStr =sqlStr_" ParameterTarget->BonusTargetCode,ParameterTarget->DataSource,ParameterTarget->CalculateFormula"
	s sqlStr =sqlStr_" from dhc_bonus_data.BonusTarget a,dhc_bonus_data.BonusSchemeUnit b"
	s sqlStr =sqlStr_" where BonusTargetCode='"_targetcode_"' AND b.BonusSchemeID='"_schemeID_"'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s svalue=0
	
	//相同指标值取之和
	While(result.Next()){
	s paramTargetCode =result.Data("BonusTargetCode")
	s sCalculateFormula =result.Data("CalculateFormula")
	s sDataSource =result.Data("DataSource")
	s BonusUnitID=result.Data("BonusUnitID")
	s sParam=BonusUnitID_"^"_BonusYear_"^"_BonusPeriod_"^"_schemeID
     
	if (sDataSource=2) && (sCalculateFormula'="") {
		s svalue =svalue+ ..FormulaTranslate("T"_paramTargetCode,sCalculateFormula,sParam)
	}else {

		s svalue =svalue+ ..GetFormulaItemVale("T"_paramTargetCode,sParam)
	}

	}
	d result.Close()

	q svalue
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-06-16
/// Description: 从指标采集表中获取指标的值
/// Parmeter: targetcode:指标编码，sParam:"^unitID^PeriodCode" 
/// Return: 返回指定指标的值
/// 调用函数：BonusSchemeCalculate()->FormulaTranslate()->GetFormulaItemVale()->GetBonusSubsValue
/// Others:  w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetBonusSubsValue("3001","822^2011^M01")
ClassMethod GetBonusSubsValue(targetcode, sParam As %String) As %String
{
	n (targetcode,sParam)
	q:targetcode="" "Empty_targetcode"
	
	s unitID=$p(sParam,"^",1)
	s BonusYear=$p(sParam,"^",2)
	s BonusPeriod=$p(sParam,"^",3)
	s targetID=0

	s targetID = ..GetTargetRowID(targetcode)
	s sqlStr= ""
	s sqlStr ="select  BonusValue  from dhc_bonus_subs.BonusSubMain   "
	s sqlStr = sqlStr_" where BonusTargetID="_targetID
	s sqlStr = sqlStr_"  and BonusUnitID="_unitID
	s sqlStr = sqlStr_"  and  BonusYear='"_BonusYear_"'"
	s sqlStr = sqlStr_"  and  BonusPeriod='"_BonusPeriod_"'"

	//w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s svalue=0
	
	//相同指标值取之和
	While(result.Next()){
	
		s svalue =svalue+result.Data("BonusValue")
	}
	d result.Close()

	q svalue
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-05
/// Description: 获取奖金项的值
/// Parmeter: code:指标编码，sParam:"BonusUnitID^BonusYear^BonusPeriod"
/// Return: 返回奖项公式的值
/// Others:   w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetSchemeItemVale("501101","458^2013^M03")
ClassMethod GetSchemeItemVale(code, sParam) As %String
{
	n (code, sParam)
	q:code="" "Empty_SchemeItemcode"
	q:sParam="" "Empty_SchemeItemsParam"


	s SchemeItemsRowID=0

	s SchemeItemsRowID = ..GetBonusItemRowID(code)		
	s unitID=$p(sParam,"^",1)
	s BonusYear=$p(sParam,"^",2)
	s BonusPeriod=$p(sParam,"^",3)
	
	q:BonusYear="" 0
	q:BonusPeriod="" 0
	q:unitID="" 0
	q:SchemeItemsRowID="" 0
	
	/*
	s sqlStr= ""
	s sqlStr ="select BonusValue from dhc_bonus_data.UnitBonusDetail  "
	s sqlStr = sqlStr_" where BonusSchemeItemID="_SchemeItemsRowID
	s sqlStr = sqlStr_"  and BonusUnitID="_unitID
	s sqlStr = sqlStr_"  and  BonusYear='"_BonusYear_"'"
	s sqlStr = sqlStr_"  and  BonusPeriod='"_BonusPeriod_"'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s svalue=0
	
	//相同指标值取之和
	While(result.Next()){

		s svalue =svalue+result.Data("BonusValue")
	}
	d result.Close()
 	 */
	//-------赵立国  20130503 改造-----------------------------
	//Index YearPeriodItem On (BonusYear, BonusPeriod, BonusUnitID, BonusSchemeItemID);
	
	s svalue=0
	s rowid=""
	f  s rowid=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",BonusYear,BonusPeriod,unitID,SchemeItemsRowID,rowid)) q:rowid=""  d
	.i rowid'="" d
	..s svalue=svalue+$LI(^dhcbsUnitBonusDetailD(rowid),8)
	

	q svalue
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-05
/// Description：解析指标公式  102030  ^S102010^+^S102020
/// 调用函数：BonusSchemeCalculate()->FormulaTranslate()
/// Input：sFormula：计算公式，格式(a+b*c):^a^+^b^*^c;sParam:取值参数，格式："UnitID^BonusYear^BonusPeriod^BonusSchemeID"
///  S0602090:^T08010^+^T08020^+^T08030^+^T08040^+^T08050^+^T08060^+^T08070^+^T08080^:832^2013^M04^31
/// Others：w ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate("S0602090","^T010901","2^2013^M04^1")
/// Others w ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaTranslate("S2021040","^(^T203101^+^T203102^+^T203103^+^T203104^+^T203105^+^T203106^+^T203107^+^T203108^+^T203109^+^T203110^)^*^T04504","519^2013^M05^7") 
ClassMethod FormulaTranslate(sCode As %String, sFormula As %String, sParam As %String) As %String
{
	n (sCode,sFormula,sParam)
	
	//##class(dhc.bonus.udata.uBonusCalcFunction).BSFMain()	
	q:sCode="" "FormulaTranslate:Empty_sCode"
	q:sFormula="" "FormulaTranslate:Empty_sFormulae"
	q:sParam="" "FormulaTranslate:Empty_sParam"
	
	s code = $E(sCode,2,$L(sCode))
	s sType=$E(sCode,1,1) //T:指标，S:方案项
	
	s sUnitID=0
	s sDate=""
	s sUnitID =$P(sParam,"^",1)
	s sBonusYear =$P(sParam,"^",2)
	s sBonusPeriod =$P(sParam,"^",3)
	s BonusSchemeID =$P(sParam,"^",4)
	
	k sList 
	k ListValue
	s rtn =""
	s count=0

	//解析公式并且循环取值
	for i=2:1:$L(sFormula,"^") {
		s sList(i)= $P(sFormula,"^",i)
 		s tpy=$E(sList(i),1,1)
 		i (tpy="#") {
	 		//s ListValue(i)= ##class(dhc.bonus.udata.uBonusCalcFunction).BSFMain(sList(i),sParam)
	 		//zhaoliguo 2016-8-31 函数调用表配置的类
	 		s ListValue(i)= ##class(dhc.bonus.udata.uBonusCalcFunction).BSFMainAuto(sList(i),sParam)
			s rtn=rtn_ListValue(i)
 		} else{	
 			;w "c="_sList(i),!
			 //假如sCode没公式，则直接取值
			if (sType="T")||(sType="S") {
				
				s count=count+1
				s sItem = sList(i)
				s tpy=$E(sItem,1,1)
				if tpy ="S" {
					s cde = $E(sItem,2,$L(sItem))
					s schemeItemid = ..GetBonusItemRowID(cde)
					;w "cde="_cde,!
					s schemeid = $LI(^dhcbsBonusSchemeItemD(schemeItemid),2)
					//假如奖金项目关联另一个奖金方案的奖金项（该项目有公式也不循环取值，直接取方案核算完成的。），
					i schemeid'= BonusSchemeID  d
					 .s rtnFormula ="null"
					e  d
					 .s rtnFormula= ..IsExistFormula(sList(i)) 
				}Else{
					s rtnFormula= ..IsExistFormula(sList(i))
				}
				//假如指标内还含有公式，则循环调用公式解析函数
						
				if rtnFormula'="null" {
					;w sList(i)_":"_rtnFormula_":"_ sParam,!
				 	d ..FormulaTranslate(sList(i),rtnFormula, sParam)
				}
				//得到公式内每个项目或指标的值
				s ListValue(i) =..GetFormulaItemVale(sList(i),sParam)
				
				s rtn=rtn_ListValue(i)
				
			}Else{
				s rtn=rtn_sList(i)	
			}
		}
	}
	
	//公式表达式间接@计算 w "公式表达式:"_rtn
	;q "zlg 公式表达式:="_rtn
	s formula=rtn
	s svalue = ..FormulaCalculate(rtn)
	;w sCode_" :="_svalue_",Desc="_rtn_",sParam="_sParam,!
	//处理奖金指标
	if (sType="T"){
		
		s RowID = ..GetTargetRowID(code)
		//删除上次核算的结果
		s sDelete =RowID_"^"_sUnitID_"^"_sBonusYear_"^"_sBonusPeriod
		d ..DeleteBonusTarget(sDelete)
		
		//保存指标的结果
		s sInsert=RowID_"^"_sUnitID_"^^"_sBonusYear_"^"_sBonusPeriod_"^2^"_svalue_"^0^"
		d ..SaveBonusTarget(sInsert)

	}
	
	//处理奖金项
	if (sType="S"){
		
		//删除上次保存的结果
	
		s RowID = ..GetBonusItemRowID(code)
		s sDelete =RowID_"^"_sUnitID_"^"_sBonusYear_"^"_sBonusPeriod
		d ..DeleteBonusItem(sDelete)
	
		//保存奖金项的结果
		s sBonusType =$li(^dhcbsBonusSchemeItemD(RowID),9)
		s sInsert=RowID_"^"_sUnitID_"^"_sBonusYear_"^"_sBonusPeriod_"^"_sBonusType_"^2^"_svalue_"^0^"_BonusSchemeID_"^"_formula
		d ..SaveBonusItem(sInsert)
	}	
	
	q svalue
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-05
/// Description：判断指标是否含有公式
/// Input：sCode：指标编码，首字母T,奖金指标；首字母S，奖金项目
/// Others：w ##class(dhc.bonus.udata.uBonusSchemeCalculate).IsExistFormula("T020500")
ClassMethod IsExistFormula(sCode As %String) As %String
{
	n (sCode)
	s rtn="null"
	s code =$E(sCode,2,$L(sCode))
	s sqlstr =""
	i $E(sCode,1,1)="T" d
	.s targetDr=""
	.s targetDr=$O(^dhcbsBonusTargetI("BonusTargetCode",code,targetDr))
	.i targetDr>0 d
	..s rtn= $List(^dhcbsBonusTargetD(targetDr),9)
	e  d
	.i $E(sCode,1,1)="S" d
	..s itemDr=""
	..s itemDr=$O(^dhcbsBonusSchemeItemI("SchemeItemCode",code,itemDr))
	..i itemDr>0 d
	...s rtn= $List(^dhcbsBonusSchemeItemD(itemDr),7)
	
	/*	
	
	  .s sqlstr="select CalculateFormula AS Formula  from dhc_bonus_data.BonusTarget where DataSource=2 and IsValid=1 and  BonusTargetCode='"_code_"'"
	 Else  d
	   .If $E(sCode,1,1)="S"  d
	   ..s sqlstr=" select BonusFormula AS Formula  from dhc_bonus_data.BonusSchemeItem  where DataSource=2 and IsValid=1 and SchemeItemCode= '"_code_"'"
	 
	q:sqlstr="" "null"
		
	s result=##class(%Library.ResultSet).%New()

	d result.Prepare(sqlstr)
	d result.Execute()
	
	While(result.Next()){
		s rtn =result.Data("Formula")
	}
	d result.Close()
	*/
	
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-05
/// Description：保存公式结果
/// Input：sData:存储的数据，格式："aa^bb^cc^dd^ee"
/// Others：w ##class(dhc.bonus.udata.BonusSchemeCalculate).SaveBonusTarget("8^1^^2010^2^1^100^0^")
ClassMethod SaveBonusTarget(sdata As %String) As %String
{
	n (sdata)
	k PLIST
	q:sdata="" "EmptyRecData"
	
	s BonusTargetID=$p(sdata,"^",1) 
	s BonusUnitID=$p(sdata,"^",2)
	s DataCollectionMainID=$p(sdata,"^",3)
	s BonusYear=$p(sdata,"^",4)
	s BonusPeriod=$p(sdata,"^",5)
	s DataSource=$p(sdata,"^",6)
	s TargetValue=$p(sdata,"^",7)
	s AuditingState=$p(sdata,"^",8)
	s AuditingDate=$p(sdata,"^",9)

		
	i BonusTargetID'="" s PLIST(2)=BonusTargetID
	i BonusUnitID'="" s PLIST(3)=BonusUnitID
	i DataCollectionMainID'="" s PLIST(4)=DataCollectionMainID
	i BonusYear'="" s PLIST(5)=BonusYear
	i BonusPeriod'="" s PLIST(6)=BonusPeriod
	i DataSource'="" s PLIST(7)=DataSource
	i TargetValue'="" s PLIST(8)=TargetValue
	i AuditingState'="" s PLIST(9)=AuditingState
	i AuditingDate'="" s PLIST(10)=AuditingDate
	s PLIST(11)=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	
	&sql(insert into dhc_bonus_data.BonusTargetCollect  VALUES PLIST())
	q SQLCODE
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-05
/// Description：保存奖金项计算结果
/// Input：sData:存储的数据，格式："BonusSchemeItemID^BonusUnitID^BonusYear^BonusPeriod^BonusType^DataSource^BonusValue^AuditingState^BonusSchemeID"
/// Others：w ##class(dhc.bonus.udata.uBonusSchemeCalculate).SaveBonusItem("147^888^2012^M02^3^2^1.0000^0^9")
ClassMethod SaveBonusItem(sdata As %String) As %String
{
	n (sdata)
	k PLIST
	q:sdata="" "EmptyRecData"

	TSTART			          
	s BonusSchemeItemID=$p(sdata,"^",1)
	s BonusUnitID=$p(sdata,"^",2)
	s BonusYear =$p(sdata,"^",3)
	s BonusPeriod=$p(sdata,"^",4)
	s BonusType =$p(sdata,"^",5)
	s DataSource=$p(sdata,"^",6)
	s BonusValue =$p(sdata,"^",7)
	s AuditingState =$p(sdata,"^",8)
	s AuditingDate =""
	s BonusSchemeID =$p(sdata,"^",9)
	
	s BonusFormula =$p(sdata,"^",10)
		
	i BonusSchemeItemID'="" s PLIST(2)=BonusSchemeItemID
	i BonusUnitID'="" s PLIST(3)=BonusUnitID
	i BonusYear'="" s PLIST(4)=BonusYear
	i BonusPeriod'="" s PLIST(5)=BonusPeriod
	i BonusType'="" s PLIST(6)=BonusType
	i DataSource'="" s PLIST(7)=DataSource
	i BonusValue'="" s PLIST(8)=BonusValue
	i AuditingState'="" s PLIST(9)=AuditingState
	i AuditingDate'="" s PLIST(10)=AuditingDate
	i BonusSchemeID'="" s PLIST(12)=BonusSchemeID
	i BonusFormula'="" s PLIST(14)=BonusFormula
	
	
	s PLIST(11)=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	&sql(insert into dhc_bonus_data.UnitBonusDetail  VALUES PLIST())
	
	if SQLCODE'=0
	{	w "SQLCODE:"_SQLCODE,!
		TROLLBACK
		} ELSE{
			TCOMMIT
			}


	q SQLCODE
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-05
/// Description：获取编码的ID
/// Return: 返回指标的ID
/// Input：code：数据编码
/// Others：w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetTargetRowID("01072")
ClassMethod GetTargetRowID(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^dhcbsBonusTargetI("BonusTargetCode",code,rowid))
	
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-05
/// Description：获取奖金项的ID
/// Return: 返回奖金项的ID
/// Input：code：奖金项编码
/// Others：w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetBonusItemRowID("010106")
ClassMethod GetBonusItemRowID(code) As %String
{
	n (code)
 	
	s rowid=0
	s rowid=$o(^dhcbsBonusSchemeItemI("SchemeItemCode",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-05
/// Description：公式计算
/// Return: 返回表达式的值
/// Input：sFormula：数学表达式，如："12+110*0.98"
/// Others：w ##class(dhc.bonus.udata.uBonusSchemeCalculate).FormulaCalculate("87430.04+5+0")
ClassMethod FormulaCalculate(sFormula) As %String
{
	n (sFormula)
	
	;w sFormula,!
	s sExp=$$GetCalcExpression^dhcBonusCalculate(sFormula)
	if (sExp="DIVIDE"){ 
		q sExp}
	ELSE
	{
		q $fn(sExp,"",6)
		}
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-07
/// Description：删除已存在的指标数据
/// Return: 返回操作结果
/// Input：sParam：删除条件(奖金指标ID^核算单元ID^核算年度^核算期间)
/// Others：w ##class(dhc.bonus.udata.BonusSchemeCalculate).DeleteBonusTarget("3^1^2010^2")
ClassMethod DeleteBonusTarget(sParam) As %String
{
	n (sParam)
	s BonusTargetID= $P(sParam,"^",1)
	s BonusUnitID= $P(sParam,"^",2)
	s BonusYear= $P(sParam,"^",3)
	s BonusPeriod= $P(sParam,"^",4)
	&SQL(delete from  dhc_bonus_data.BonusTargetCollect where BonusTargetID=:BonusTargetID and BonusUnitID=:BonusUnitID and BonusYear=:BonusYear  and BonusPeriod=:BonusPeriod )
	q SQLCODE
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-07
/// Description：删除已存在的奖金项数据
/// Return: 返回操作结果
/// Input：sParam：删除条件,格式：BonusSchemeItemID^BonusUnitID^BonusYear^BonusPeriod
/// Others：w ##class(dhc.bonus.udata.BonusSchemeCalculate).DeleteBonusItem("221^1^2013^M01")
ClassMethod DeleteBonusItem(sParam) As %String
{
	n (sParam)
	s BonusSchemeItemID= $P(sParam,"^",1)
	s BonusUnitID= $P(sParam,"^",2)
	s BonusYear= $P(sParam,"^",3)
	s BonusPeriod= $P(sParam,"^",4)
	&SQL(delete from  dhc_bonus_data.UnitBonusDetail where BonusSchemeItemID=:BonusSchemeItemID and BonusUnitID=:BonusUnitID and BonusYear=:BonusYear  and BonusPeriod=:BonusPeriod )
    q SQLCODE
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-05
/// Description: 从指标系数设置表中获取指标的系数
/// Parmeter: targetcode:指标编码，sParam:"unitID^BonusYear^BonusPeriod^BonusSchemeID"
/// Return: 返回指定指标的值 
/// 调用函数： 010601:433^2013^M01^8
/// Others:  w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetBonusTargetRate("05051","588^2015^M08^1")
ClassMethod GetBonusTargetRate(targetcode As %String, sParam As %String) As %String
{
	n (targetcode,sParam)
	
	q:targetcode="" "Empty_targetcode"

	s unitID=$p(sParam,"^",1)
	s BonusYear= $P(sParam,"^",2)
	s BonusPeriod= $P(sParam,"^",3)
	s BonusSchemeID= $P(sParam,"^",4)
	
	s targetID=0
    s sqlStr= "",gdRate="",sParmValue=0

 	s targetID = ..GetTargetRowID(targetcode)
 	i targetID>0 d
	.s dataSource = $List(^dhcbsBonusTargetD(targetID),7)
	e  d
	.s dataSource=0
	
	/*
	//得到参数指标的值
	i (dataSource=3) d
	.s sParmValue = ..GetParamTargetValue(targetcode, sParam)

	s rtn=0,sRate=0
	;w dataSource,!
	;w BonusSchemeID_","_targetID_","_ unitID_",",!
	s detailID=""
	f  s detailID=$O(^dhcbsTargetCalculateRateI("SchemeTargetUnit",BonusSchemeID, targetID, unitID,detailID)) q:detailID=""  d
	.s sStart=$List(^dhcbsTargetCalculateRateD(detailID),6)
	.s sEnd=$List(^dhcbsTargetCalculateRateD(detailID),7)
	.s sStep=$List(^dhcbsTargetCalculateRateD(detailID),9)
	.s sBase=$List(^dhcbsTargetCalculateRateD(detailID),10)
	.s sRate=$List(^dhcbsTargetCalculateRateD(detailID),11)
	.s sTrend=$List(^dhcbsTargetCalculateRateD(detailID),21)
	.;w sParmValue_","_sStart_","_sEnd_","_sStep_","_sBase_","_sRate_","_sTrend_"",!
	.i (dataSource=3)  d // 区间指标
	..i ((sParmValue>sStart) &&(sParmValue<sEnd)) d
	...s je=0
	...i sTrend=1 d
	....s je=(sEnd-sParmValue)/sStep*sRate+1
	...i sTrend=0 d
	....s je=sParmValue/sStep*sRate
	...i sTrend=-1 d
	....s je=(sParmValue-sStart)/sStep*sRate+1
	...s rtn=je
	.i ((dataSource=4)||(dataSource=9)) d
	..;w "sRate="_sRate,!
	..s gdRate=sRate
	..s rtn=sRate
	
	;w "gdRate="_gdRate,!
	s stv=""
	i gdRate="" d
	.i dataSource=4 d
	..s rowid=""
	..s rowid=$o(^dhcbsBonusTargetI("BonusTargetCode",targetcode,rowid))
	..i rowid'="" d
	...s stv=$list(^dhcbsBonusTargetD(rowid),20) ;取指标默认值
	...i stv'="" d
	....s rtn=stv

	i rtn="" s rtn=0
	
	q rtn
	*/
	
	//------以上2015-12-01 赵立国 改-----------------------------------
	
	if (dataSource=3) { // 区间指标
		
		//得到参数指标的值
		;w targetcode_":"_sParam,!
		s BaseValue = ..GetParamTargetValue(targetcode, sParam)
		;w "BaseValue:"_BaseValue,!
		s sqlStr =" SELECT TargetTrend,BonusTargetID,AccountBase,case when (StepSize = null or StepSize='' or StepSize=0) then TargetRate else TargetRate/StepSize end as TargetRate "
    	s sqlStr = sqlStr_" from dhc_bonus_data.TargetCalculateRate"
   		s sqlStr = sqlStr_" where ("_BaseValue_"-AccountBase) >= (case  StartLimit when null then -900000000000 else  StartLimit end ) "
   		_" and  ("_BaseValue_"-AccountBase) <(case  EndLimit when null then 900000000000 else  EndLimit end )"
    	s sqlStr = sqlStr_" and BonusTargetID="_targetID_" and  BonusUnitID="_unitID_" and IsValid=1 " 

	} elseif ((dataSource=4)||(dataSource=9)){ //比例系数指标
		
	   	//指标 数据来源为设置（DataSource=4）时直接取TargetRate
		s sqlStr=" select BonusTargetID,TargetRate from dhc_bonus_data.TargetCalculateRate  "
		s sqlStr = sqlStr_" where BonusTargetID="_targetID_" and BonusUnitID="_unitID_" and IsValid=1 "
		;s sqlStr = sqlStr_" and BonusSchemeID="_BonusSchemeID
		
	}else{ 
	
		s sqlStr="  select 0 TargetRate from dhc_bonus_data.TargetCalculateRate   where BonusTargetID=0"
			
	}
	
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s svalue=""
	s tRate=""
	
	While(result.Next()){
		s tRate =result.Data("TargetRate")
		i dataSource=3 d
		.s AccountBase=result.Data("AccountBase")
		
	}
	
	if (dataSource=3){
		//s svalue =tRate*(BaseValue-AccountBase)
		s svalue=tRate
	}elseif (dataSource=4) {
		s svalue = tRate
	}

	d result.Close()
	
	s stv=""
	i svalue="" d
	.i dataSource=4 d
	..s rowid=""
	..s rowid=$o(^dhcbsBonusTargetI("BonusTargetCode",targetcode,rowid))
	..i rowid'="" d
	...s stv=$list(^dhcbsBonusTargetD(rowid),20) ;取指标默认值
	...i stv'="" d
	....s svalue=stv

	i svalue="" s svalue=0
	
	;w targetcode_":"_stv,!

	q svalue
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-05
/// Description: 获取差率累加指标的值
/// Parmeter: targetcode:指标编码，sParam:"unitID^BonusYear^BonusPeriod^BonusSchemeID"
/// Return: 返回指定指标的值
/// 调用函数：BonusSchemeCalculate()->FormulaTranslate()->GetFormulaItemVale()->GetBonusTargetRate
/// Others:  w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetCLLJTargetRate("1301","838^2012^M01^16")
ClassMethod GetCLLJTargetRate(targetcode As %String, sParam As %String) As %String
{
	n (targetcode,sParam)
	
	q:targetcode="" "Empty_targetcode"

	s unitID=$p(sParam,"^",1)
	s BonusYear= $P(sParam,"^",2)
	s BonusPeriod= $P(sParam,"^",3)
	s BonusSchemeID= $P(sParam,"^",4)
	
	s targetID=0
    s sqlStr= ""
		
	//得到参数指标的值
	s curValue = ..GetParamTargetValue(targetcode, sParam)
	q:curValue=0 0
	 
	s sqlStr =" select  BonusUnitID,BonusTargetID,RateType,StartLimit,EndLimit,StepSize, AccountBase,TargetRate,IsValid,ParameterTarget, BonusSchemeID"
		_" from dhc_bonus_data.TargetCalculateRate "
		_" where IsValid=0 and BonusUnitID='"_unitID_"' AND BonusSchemeID="_BonusSchemeID_" AND BonusTargetID->BonusTargetCode='"_targetcode_"'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s tRate=0
	
	s sum=0
	While(result.Next()){
		s stv=result.Data("StartLimit")
		i stv="" s stv=-99999999
		s stv=$fn(stv,"",6)
		s etv=result.Data("EndLimit")
		i etv="" s etv=99999999
		s etv=$fn(etv,"",6)
		
		s abv=result.Data("AccountBase")
		s drate=result.Data("TargetRate")
		s dfRate=$fn((curValue-abv)/abv,"",6)
		
		i ((dfRate>stv) && (dfRate<=etv)) d
		.i (stv'="-99999999.0000") d
		..s sum=sum+(abv*(dfRate-stv)*drate)
		
		i stv="-99999999.0000" d
		.s sum=sum+(abv*drate)
		i ((dfRate>etv)&& (stv'="-99999999.0000")) d
		.s sum=sum+(abv*(etv-stv)*drate) 

	
	}

	d result.Close()
	q sum
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-05
/// Description: 获取差额累加指标的值
/// Parmeter: targetcode:指标编码，sParam:"unitID^BonusYear^BonusPeriod^BonusSchemeID"
/// Return: 返回指定指标的值
/// 调用函数：BonusSchemeCalculate()->FormulaTranslate()->GetFormulaItemVale()->GetBonusTargetRate
/// 04210:173^2013^M04^10
/// Others:  w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetCELJTargetRate("04210","173^2013^M04^16")
ClassMethod GetCELJTargetRate(targetcode As %String, sParam As %String) As %String
{
	n (targetcode,sParam)
	
	q:targetcode="" "Empty_targetcode"

	s unitID=$p(sParam,"^",1)
	s BonusYear= $P(sParam,"^",2)
	s BonusPeriod= $P(sParam,"^",3)
	s BonusSchemeID= $P(sParam,"^",4)
	
	s targetID=0
    s sqlStr= ""
		
	//得到参数指标的值
	s curValue = ..GetParamTargetValue(targetcode, sParam)
	;q:curValue=0 0
	;s curValue =400.85
	s sqlStr =" select  BonusUnitID,BonusTargetID,RateType,StartLimit,EndLimit,StepSize, AccountBase,TargetRate,IsValid,ParameterTarget, BonusSchemeID"
		_" from dhc_bonus_data.TargetCalculateRate "
		_" where IsValid=0 and BonusUnitID='"_unitID_"'  AND BonusTargetID->BonusTargetCode='"_targetcode_"'"
	;w curValue_":"_sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s tRate=0
	
	s sum=0
	While(result.Next()){
		s stv=result.Data("StartLimit")
		i stv="" s stv=0
		s stv=$fn(stv,"",6)
		s etv=result.Data("EndLimit")
		i etv="" s etv=99999999
		s etv=$fn(etv,"",6)
		
		s abv=result.Data("AccountBase")
		s drate=result.Data("TargetRate")
		s cValue=curValue-abv
		
		i ((cValue>stv) && (cValue<=etv)) d
		.s sum=(cValue-stv)*drate+sum
		.;w "sum1=" _cValue_":"_stv_":"_drate,!
		
		i cValue>etv d
		.s sum=(etv-stv)*drate+sum
		.;w "sum2=" _etv_":"_stv_":"_drate,!

	
	}

	d result.Close()
	q sum
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-10
/// Description: 获取某带参数指标的该参数指标的值
/// Parmeter: targetcode:带参数指标编码，sParam:"unitID^BonusYear^BonusPeriod"
/// Return: 返回参数指标的值
/// Others:  w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetParamTargetValue("03056","137^2012^M01^3")
ClassMethod GetParamTargetValue(targetcode As %String, sParam As %String) As %String
{
	n (targetcode,sParam)
	q:targetcode="" "GetParamTargetValue:Empty_targetcode"
	
	s unitID=$p(sParam,"^",1)
	s BonusYear= $P(sParam,"^",2)
	s BonusPeriod= $P(sParam,"^",3)
	s targetID=0
	s paramTargetCode=""
	s targetID = ..GetTargetRowID(targetcode)
	s sqlStr= ""
	s BaseValue = 0

	s sqlStr =" select b.BonusTargetCode,b.CalculateFormula,b.DataSource from dhc_bonus_data.BonusTarget a,dhc_bonus_data.BonusTarget b "
    s sqlStr = sqlStr_" where b.BonusTargetID= a.ParameterTarget AND a.BonusTargetCode='"_targetcode_"'"
  
   	s result=##class(%Library.ResultSet).%New()

	d result.Prepare(sqlStr)
	d result.Execute()
	
	s sCalculateFormula =""
	s sDataSource =""
	While(result.Next()){
		s paramTargetCode = result.Data("BonusTargetCode")
		s sCalculateFormula = result.Data("CalculateFormula")
		s sDataSource = result.Data("DataSource")
		
		;w "rtn="_paramTargetCode_"^"_sCalculateFormula_"^"_sDataSource,!
	}
	d result.Close()
	
	if (sDataSource=2) && (sCalculateFormula'="") {
		s BaseValue = ..FormulaTranslate("T"_paramTargetCode,sCalculateFormula,sParam)
	}else {

		s BaseValue = ..GetFormulaItemVale("T"_paramTargetCode,sParam)
	}
	
	q BaseValue
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-08-18
/// Description：判断奖金方案的核算方式是否为标准，CalculateWay=0或空 为标准；CalculateWay=1为扩展，调用扩展方法CalculateMethod
/// Input：sCode：奖金方案编码
/// Others：w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GeteCalculateWay("0150")
ClassMethod GeteCalculateWay(schemeCode As %String) As %String
{
	n (schemeCode)
	s rtn="null"
	s sqlstr =""
	
	s sqlstr="select CalculateWay,CalculateMethod  from   dhc_bonus_data.BonusScheme where BonusSchemeCode='"_schemeCode_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlstr)
	d result.Execute()
	
	s CalculateWay=""
	s CalculateMethod=""
	
	While(result.Next()){
		s CalculateWay =result.Data("CalculateWay")
		s CalculateMethod =result.Data("CalculateMethod")
	}
	s rtn=CalculateWay_"^"_CalculateMethod
	d result.Close()

	q rtn
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusScheme85FS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
