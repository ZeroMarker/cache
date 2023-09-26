Class dhc.bonus.report.uEmpBonusSort Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Query SchemePeriod() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where BonusPeriod like 'Y%'
}

/// 调整方案
/// other:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uDeptloadScore","GetScheme")
Query GetScheme() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select  BonusSchemeID BonusSchemeAdjustID,BonusSchemeName from dhc_bonus_data.BonusScheme WHERE IsValid=1 AND SchemeState=1
}

/// 指标
/// other:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uDeptloadScore","GetTarget")
Query GetBonusDept() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
		
select BonusUnitID,BonusUnitName from dhc_bonus_data.BonusUnit where  BonusUnitTypeID=13 AND  UnitFlag=1
}

/// 调整方案
/// other:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmpBonusSort","GetEmpBonusSort","325","2012","M04")
Query GetEmpBonusSort(syear As %String, smonth As %String, sUnitID As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{

select bonusUnitName,BonusUnitCode empcode, empname, sum(IssuedBonus) bq ,sum(hj) hj,sum(pj) pj from (
select  SuperiorUnitID->bonusUnitName,BonusUnitCode,BonusUnitName empname,0 IssuedBonus ,sum(IssuedBonus) hj,avg(IssuedBonus) pj
 from dhc_bonus_data.BonusIssuedDetail
where SuperiorUnitID=:sUnitID AND BonusYear=:syear and BonusPeriod<='M'_:smonth and SchemeItemID->BonusType=1
group by SuperiorUnitID->bonusUnitName,BonusUnitCode,BonusUnitName
union all
select  SuperiorUnitID->bonusUnitName,BonusUnitCode,BonusUnitName empname,IssuedBonus ,0 hj,0 pj
 from dhc_bonus_data.BonusIssuedDetail
where SuperiorUnitID=:sUnitID AND BonusYear=:syear and BonusPeriod='M'_:smonth and SchemeItemID->BonusType=1
group by SuperiorUnitID->bonusUnitName,BonusUnitCode,BonusUnitName,IssuedBonus
) as jj group by empname,BonusUnitCode,BonusUnitName order by hj desc
}

/// 个人奖金报表
/// other:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmpBonusSort","GetEmpBonusSort","325","2012","M04")
Query GetEmpBonus(syear As %String, smonth As %String, sEmpNo As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{

select  SuperiorUnitID->bonusUnitName,BonusUnitCode,BonusUnitName empname,IssuedBonus ,SchemeItemID->SchemeItemName
 from dhc_bonus_data.BonusIssuedDetail
 where SuperiorUnitID=325 AND BonusYear=:syear and BonusPeriod=:smonth and BonusUnitCode='10407'
 order by SchemeItemID->BonusType desc
}

/// 个人奖金占比分析
/// other:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmpBonusSort","GetEmpBonusSort","325","2012","M04")
Query GetEmpBonusRate(syear As %String, smonth As %String, sUserCode As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{

select  SuperiorUnitID->bonusUnitName,BonusUnitCode,BonusUnitName empname,IssuedBonus
 from dhc_bonus_data.BonusIssuedDetail
where SuperiorUnitID=325 AND BonusYear=:syear and BonusPeriod='M'_:smonth and SchemeItemID->BonusType=1
}

/// 科室人员奖金汇总
/// other:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmpBonusSort","GetEmpBonusSort","325","2012","M04")
Query GetEmpBonusSum(syear As %String, smonth As %String, sUserCode As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{

select  BonusYear,right(BonusPeriod,2) BonusPeriod,SuperiorUnitID->bonusUnitName,BonusUnitCode,BonusUnitName empname,SchemeItemID->SchemeItemName,IssuedBonus from dhc_bonus_data.BonusIssuedDetail
where SuperiorUnitID=325 AND BonusYear=:syear and BonusPeriod='M'_:smonth
}

/// 科室人员奖金趋势分析
/// other:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmpBonusSort","GetEmpBonusSort","325","2012","M04")
Query GetEmpBonusQSFX(syear As %String, sUserCode As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{

select BonusYear,bonusUnitName,BonusUnitCode, empname,sum(m1) m1,sum(m2) m2,sum(m3) m3,sum(m4) m4,sum(m5) m5,sum(m6) m6,sum(m7) m7,sum(m8) m8
,sum(m9) m9,sum(m10) m10,sum(m11) m11,sum(m12) m12
from (
select  BonusYear,right(BonusPeriod,2),SuperiorUnitID->bonusUnitName,BonusUnitCode,BonusUnitName empname
,case BonusPeriod when 'M01' then IssuedBonus else 0 end m1
,case BonusPeriod when 'M02' then IssuedBonus else 0 end m2
,case BonusPeriod when 'M03' then IssuedBonus else 0 end m3
,case BonusPeriod when 'M04' then IssuedBonus else 0 end m4
,case BonusPeriod when 'M05' then IssuedBonus else 0 end m5
,case BonusPeriod when 'M06' then IssuedBonus else 0 end m6
,case BonusPeriod when 'M07' then IssuedBonus else 0 end m7
,case BonusPeriod when 'M08' then IssuedBonus else 0 end m8
,case BonusPeriod when 'M09' then IssuedBonus else 0 end m9
,case BonusPeriod when 'M010' then IssuedBonus else 0 end m10
,case BonusPeriod when 'M011' then IssuedBonus else 0 end m11
,case BonusPeriod when 'M012' then IssuedBonus else 0 end m12
 from dhc_bonus_data.BonusIssuedDetail
where SuperiorUnitID=325 AND BonusYear=:syear  and SchemeItemID->BonusType=1 and BonusUnitCode='10516'
) group by BonusYear,bonusUnitName,BonusUnitCode, empname
}

Storage Default
{
<StreamLocation>^dhc.bonus.rep64E.uEmpBonusSortS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
