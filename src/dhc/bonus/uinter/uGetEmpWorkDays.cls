Class dhc.bonus.uinter.uGetEmpWorkDays Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// OA考勤采集
/// w ##class(dhc.bonus.uinter.uGetEmpWorkDays).GetEmpWorkDays("2013","12","11")
ClassMethod GetEmpWorkDays(sYear As %String, sMonth As %String, sMethodDr As %String) As %String
{
	n (sYear,sMonth,sMethodDr)
	s MethodDr=sMethodDr
	
	s YearMonth = sYear_"-"_sMonth
	s sMonth= "M"_sMonth
  	
	//导入数据前清除
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:sYear and 
	     BonusPeriod=:sMonth and InterLocMethodID=:MethodDr 
	     )	
	
  	;插入平时白班天数
    &sql(
          insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,
          BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,
          UnitType,InterLocMethodID)
          select '90100','平时白班天数',b.BonusUnitCode,BonusUnitName,:sYear,:sMonth,
          bbchuqin,getdate(),0,0,:sMethodDr
          from dhc_bonus_data.EmpWorkDays a,dhc_bonus_data.BonusUnit b
          where upper(a.loginname)= upper(b.BonusUnitCode) and a.month =:YearMonth and IsValid = '1'
    )
    ;插入平时大夜班天数
    &sql(
          insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,
          BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,
          UnitType,InterLocMethodID)
          select '90101','平时大夜班天数',b.BonusUnitCode,BonusUnitName,:sYear,:sMonth,
          dychuqin,getdate(),0,0,:sMethodDr
          from dhc_bonus_data.EmpWorkDays a,dhc_bonus_data.BonusUnit b
          where upper(a.loginname)= upper(b.BonusUnitCode) and a.month =:YearMonth and IsValid = '1'
    )
    ;插入平时小夜班天数
    &sql(
          insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,
          BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,
          UnitType,InterLocMethodID)
          select '90102','平时小夜班天数',b.BonusUnitCode,BonusUnitName,:sYear,:sMonth,
          xychuqin,getdate(),0,0,:sMethodDr
          from dhc_bonus_data.EmpWorkDays a,dhc_bonus_data.BonusUnit b
          where upper(a.loginname)= upper(b.BonusUnitCode) and a.month =:YearMonth and IsValid = '1'
    )
    ;插入假日白班天数
    &sql(
          insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,
          BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,
          UnitType,InterLocMethodID)
          select '90103','假日白班天数',b.BonusUnitCode,BonusUnitName,:sYear,:sMonth,
          bbjiari,getdate(),0,0,:sMethodDr
          from dhc_bonus_data.EmpWorkDays a,dhc_bonus_data.BonusUnit b
          where upper(a.loginname)= upper(b.BonusUnitCode) and a.month =:YearMonth and IsValid = '1'
    )
    ;插入假日大夜班天数
    &sql(
          insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,
          BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,
          UnitType,InterLocMethodID)
          select '90104','假日大夜班天数',b.BonusUnitCode,BonusUnitName,:sYear,:sMonth,
          dyjiari,getdate(),0,0,:sMethodDr
          from dhc_bonus_data.EmpWorkDays a,dhc_bonus_data.BonusUnit b
          where upper(a.loginname)= upper(b.BonusUnitCode) and a.month =:YearMonth and IsValid = '1'
    )
    ;插入假日小夜班天数
    &sql(
          insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,
          BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,
          UnitType,InterLocMethodID)
          select '90105','假日小夜班天数',b.BonusUnitCode,BonusUnitName,:sYear,:sMonth,
          xyjiari,getdate(),0,0,:sMethodDr
          from dhc_bonus_data.EmpWorkDays a,dhc_bonus_data.BonusUnit b
          where upper(a.loginname)= upper(b.BonusUnitCode) and a.month =:YearMonth and IsValid = '1'
    )
    ;插入法定假日天数
    &sql(
          insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,
          BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,
          UnitType,InterLocMethodID)
          select '90011','法定假日天数',b.BonusUnitCode,BonusUnitName,:sYear,:sMonth,
          jiejia,getdate(),0,0,:sMethodDr
          from dhc_bonus_data.EmpWorkDays a,dhc_bonus_data.BonusUnit b
          where upper(a.loginname)= upper(b.BonusUnitCode) and a.month =:YearMonth and IsValid = '1'
    )
    ;插入病事假天数
    &sql(
          insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,
          BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,
          UnitType,InterLocMethodID)
          select '90020','病事假天数',b.BonusUnitCode,BonusUnitName,:sYear,:sMonth,
          bingshijia,getdate(),0,0,:sMethodDr
          from dhc_bonus_data.EmpWorkDays a,dhc_bonus_data.BonusUnit b
          where upper(a.loginname)= upper(b.BonusUnitCode) and a.month =:YearMonth and IsValid = '1'
    )
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u649.uGetEmpWorkD5EBS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
