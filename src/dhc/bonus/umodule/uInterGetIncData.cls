/// 取人事系统的工资
Class dhc.bonus.umodule.uInterGetIncData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Zhao LIGuo 
/// CreatDate: 2015-07-10
/// Description:得到科室收入
/// Table：
/// Input: 
/// Output: 
/// Return: 
/// Others:d ##class(dhc.bonus.umodule.GetHRWage).GetHRWage("2015","01","2","chenwen")
ClassMethod GetIncData(syear, smonth, user) As %String
{
	new (syear,smonth,user)
	q:syear="" 0
	q:smonth="" 0
	
	s operator=user
	s sdate=syear_"-"_smonth_"-01"
	s smonth=smonth+1
	s edate=syear_"-"_smonth_"-01"
	
	
	
	&sql(delete from dhc_bonus_module.BonusIncomeCollect  where  BonusYear=:syear and BonusPeriod=:month )

	&sql(INSERT INTO dhc_bonus_module.BonusIncomeCollect(
	IncomeItemCode,BonusYear, BonusPeriod,MakeBillDeptCode,ExecuteDeptCode,SickDeptCode,SickType,IncomeMoney, State, UpdateDate,operator)
	SELECT e.ItemCode, LEFT(ChargeDate,4) BonusYear,'M'_ SUBSTR(ChargeDate,6,2) BonusPeriod,
	b.Code0 MakeBillDeptCode,c.Code0 ExecuteDeptCode,d.Code0 SickDeptCode,2 SickType,sum(IncomeMoney) IncomeMoney,0 State,getdate() UpdateDate,:operator
	FROM herp_inter_data.HisChargeDataI a,dhc_sync_data.sync_loc  b,dhc_sync_data.sync_loc  c,dhc_sync_data.sync_loc  d,dhc_bonus_module.BonusIncItem e
	WHERE  a.MakeBillDeptCode =* b.code2 AND a.ItemCode=e.ItemCode 
	AND a.ExecuteDeptCode =* c.code2 AND a.SickDeptCode =* d.code2 AND e.IsValid=1
	and ChargeDate>=:sdate AND  ChargeDate<:edate
	GROUP BY e.ItemCode,LEFT(ChargeDate,4)_'M'_ SUBSTR(ChargeDate,6,2) ,b.code0,c.code0,d.code0
	UNION all
	SELECT e.ItemCode, LEFT(ChargeDate,4) BonusYear,'M'_ SUBSTR(ChargeDate,6,2) BonusPeriod,
	b.Code0 MakeBillDeptCode,c.Code0 ExecuteDeptCode,d.Code0 SickDeptCode,1 SickType,sum(IncomeMoney) IncomeMoney,0 State,getdate() UpdateDate,:operator
	FROM herp_inter_data.HisChargeDataO a,dhc_sync_data.sync_loc  b,dhc_sync_data.sync_loc  c,dhc_sync_data.sync_loc  d,dhc_bonus_module.BonusIncItem e
	WHERE  a.MakeBillDeptCode =* b.code2 AND a.ItemCode=e.ItemCode 
	AND a.ExecuteDeptCode =* c.code2 AND a.SickDeptCode =* d.code2 AND e.IsValid=1
	and ChargeDate>=:sdate AND  ChargeDate<:edate
	GROUP BY e.ItemCode,LEFT(ChargeDate,4)_'M'_ SUBSTR(ChargeDate,6,2) ,b.code0,c.code0,d.code0)
	
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus866B.uInterGetIn6109S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
