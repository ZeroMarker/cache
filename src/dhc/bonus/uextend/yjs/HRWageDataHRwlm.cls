Import SQLUser

/// HR报表中科室应发工资汇总表（王良名）
Class dhc.bonus.uextend.yjs.HRWageDataHRwlm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query GetDeptYingFa(sYear As %String, sMonth As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select a.DeptCode,sum(a.OtherBonusThree) as OtherBonusThree,b.FlexStrField4,b.DeptName
	from hishr.PSWagesHistoryInfo as a left join dhc_bonus_extend_yjs.EmpWorkDay as h on
	a.EmpCardID=h.EmpCardID left join hishr.DeptInfo as b on b.FinanceStatName=h.DeptCode
 	where a.Year=:sYear and a.Month=:sMonth
 	and h.BonusYear=:sYear and h.BonusPeriod='M'||right('00'||:sMonth,2) and a.DeptCode<>''
	group by b.FlexStrField4
	order by b.FlexStrField4
}

Query GetPSYingFa(sYear As %String, sMonth As %String, sDept As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select a.EmpCardID,a.PSName,a.OtherBonusThree,b.FlexStrField4 as DeptCode,d.CONTEXT,e.ApplealDays
	from hishr.PSWagesHistoryInfo as a left join dhc_bonus_extend_yjs.EmpWorkDay as h on
        (a.EmpCardID=h.EmpCardID and h.BonusYear=:sYear and h.BonusPeriod='M'||right('00'||:sMonth,2))
	left join hishr.DeptInfo as b on h.DeptCode=b.FinanceStatName
	left join HISHR.PersonInfo as c on a.EmpCardID=c.EmpCardID
	left join HISHR.PersonDroitTypeInfo as d on c.PersonDroit=d.PersonDroitType
	left join hishr.TimeLeaveInfo as e on (a.EmpCardID=e.EmpCardID and e.Year=:sYear and e.Month=:sMonth)
	where b.FlexStrField4=:sDept and a.Year=:sYear and a.Month=:sMonth
	order by a.EmpCardID
}

}
