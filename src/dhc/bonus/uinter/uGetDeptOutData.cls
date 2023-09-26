Class dhc.bonus.uinter.uGetDeptOutData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 科室支出数据采集
/// w ##class(dhc.bonus.uinter.uGetDeptOutData).GetDeptOutData("2013","03","9")
ClassMethod GetDeptOutData(sYear As %String, sMonth As %String, sMethodDr As %String) As %String
{
	n (sYear,sMonth,sMethodDr)
	s MethodDr=sMethodDr
	s ym=sYear_"-"_sMonth
	s sMonth= "M"_sMonth
  	
	//导入数据前清除
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:sYear and 
	     BonusPeriod=:sMonth and InterLocMethodID=:MethodDr 
	     )	
	
  	;插入科室支出数据
    &sql(
          insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,
          BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,
          UnitType,InterLocMethodID)
          select distinct CostResultData_itemDr->AllDataItems_code,CostResultData_itemDr->AllDataItems_name,
		  CostResultData_distDeptDr->UnitDepts_code,CostResultData_distDeptDr->UnitDepts_name,
          :sYear,:sMonth,CostResultData_fee,getdate(),0,0,:sMethodDr 
          from dhc_ca_cache_data.costResultData a,
          dhc_ca_cache_data.unitdepts b,dhc_ca_cache_data.AllDataItems c,dhc_bonus_subs.BonusSubItem d,
          dhc_bonus_subs.BonusSubItemGroupMap e,dhc_ca_cache_data.accountmonths f 
          where a.CostResultData_distFlag='self' and a.CostResultData_itemDr=c.AllDataItems_rowid 
          and a.CostResultData_distDeptDr=b.UnitDepts_rowid and d.IsValid=1 
          and e.BonusSubItemID=d.BonusSubItemID and e.BonusSubItemGroupID=2 and d.SubItemCode=c.AllDataItems_code
          and a.CostResultData_intervalDr=f.AccountMonths_code and f.AccountMonths_name=:ym
         
         
    )
    
          
    
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus1BEE.uGetDeptOut5359S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
