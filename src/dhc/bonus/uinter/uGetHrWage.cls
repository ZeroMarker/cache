/// 取人事系统的工资
Class dhc.bonus.uinter.uGetHrWage Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Zhao LIGuo 
/// CreatDate: 2015-01-07
/// Description:得到人事工资，（人事市场化人员工资后发一个月）
/// Table：
/// Input: 
/// Output: 
/// Return: 
/// Others:w ##class(dhc.bonus.uinter.uGetHrWage).GetHRWage("2014","M11","12")
ClassMethod GetHRWage(syear, smonth, MethodDr) As %String
{
	new (syear,smonth,MethodDr)

	s yearmoth=syear_smonth
	;zn "hisDB"
	;d ##class(web.HRWagesToBonus).GetHRWage(syear,smonth)
	;zn "dhc-app"
	
	s je=0
	s deptcode=""
	s ItemCode="04010",ItemDesc="人员经费支出"
	;s MethodDr=12
	s smonth="M"_smonth
	&sql(delete from  dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:syear and BonusPeriod=:smonth and InterLocMethodID=:MethodDr)
	;w SQLCODE,!
	f  s deptcode=$O(^tempHRToBonus(yearmoth,deptcode)) q:deptcode=""  d
	.s DeptName =$p($G(^tempHRToBonus(yearmoth,deptcode)),"^",1)
	.s deptcode="HR" _deptcode
	.s je =$p($G(^tempHRToBonus(yearmoth,deptcode)),"^",2)
	.;w syear_"^"_smonth_"^"_deptcode_"^"_DeptName_"^"_je,!
	.&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:deptcode,:DeptName,:syear, :smonth,:je,getdate(), 0,0,:MethodDr)	)
	
	q 0
}

Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uGetHrWageS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
