Class dhc.bonus.uinter.uGetJXScore Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 绩效考核得分采集
/// w ##class(dhc.bonus.uinter.uGetJXScore).GetJXScore("2013","03","9")
ClassMethod GetJXScore(sYear As %String, sMonth As %String, sMethodDr As %String) As %String
{
	n (sYear,sMonth,sMethodDr)
	s MethodDr=sMethodDr
	s Period=sYear_sMonth
	s sMonth= "M"_sMonth
  	
	//导入数据前清除
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:sYear and 
	     BonusPeriod=:sMonth and InterLocMethodID=:MethodDr 
	     )	
	
  	;插入科室绩效考核分(查体中心、口腔科和麻醉科取管理分)	
    &sql(
          insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,
          BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,
          UnitType,InterLocMethodID)
          select '01050' BonusTargetCode,'绩效考核分' BonusTargetName,UnitResult_jxUnitDr->JXUnit_code,UnitResult_jxUnitDr->JXUnit_name,
		  :sYear,:sMonth,UnitResult_totalScore,getdate(),0,0,:MethodDr
          from dhc_pa_data.UnitResult a,dhc_bonus_data.BonusUnit b
          where UnitResult_jxUnitDr->JXUnit_code=b.BonusUnitCode and UnitResult_schemDr->Schem_level='1' and UnitResult_period=:Period
      
    )
   
    
	q SQLCODE
}

/*
ClassMethod GetJXScore(sYear As %String, sMonth As %String, sMethodDr As %String) As %String
{
	n (sYear,sMonth,sMethodDr)
	s MethodDr=sMethodDr
	
	s sMonth= "M"_sMonth
  	
	//导入数据前清除
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:sYear and 
	     BonusPeriod=:sMonth and InterLocMethodID=:MethodDr 
	     )	
	
  	;插入科室绩效考核分(查体中心、口腔科和麻醉科取管理分)	
    &sql(
          insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,
          BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,
          UnitType,InterLocMethodID)
          select BonusTargetID->BonusTargetCode,BonusTargetID->BonusTargetName,UnitCode,
          BonusUnitName,Year,Period,YewuValue,getdate(),0,0,:sMethodDr
          from dhc_pa_data.JXScoreForBonus a,dhc_bonus_data.BonusUnit b 
          where a.UnitCode=b.BonusUnitCode and Year=:sYear and Period=:sMonth and 
          BonusTargetID='6' and a.UnitCode not in ('D123','D2063','D126')
          
          union all
          select BonusTargetID->BonusTargetCode,BonusTargetID->BonusTargetName,UnitCode,
          BonusUnitName,Year,Period,GuanliValue,getdate(),0,0,:sMethodDr
          from dhc_pa_data.JXScoreForBonus a,dhc_bonus_data.BonusUnit b 
          where a.UnitCode=b.BonusUnitCode and Year=:sYear and Period=:sMonth and 
          BonusTargetID='6' and a.UnitCode in ('D123','D2063','D126')
           union all
          select distinct CostResultData_itemDr->AllDataItems_code,CostResultData_itemDr->AllDataItems_name,
		  CostResultData_distDeptDr->UnitDepts_code,CostResultData_distDeptDr->UnitDepts_shortcut,
          :year,:month,CostResultData_fee,getdate(),0,0,:sMethodDr from dhc_ca_cache_data.costResultData,
          dhc_ca_cache_data.unitdepts,dhc_ca_cache_data.AllDataItems,dhc_bonus_subs.BonusSubItem where CostResultData_distFlag='self' and
          CostResultData_itemDr in (SELECT AllDataItems_rowid FROM dhc_ca_cache_data.AllDataItems,
          dhc_bonus_subs.BonusSubItem a,dhc_bonus_subs.BonusSubItemGroupMap b WHERE AllDataItems_remark LIKE '%成本项目分类%' and
          AllDataItems_active = 'Y' and b.BonusSubItemID=a.BonusSubItemID and b.BonusSubItemGroupID=2 and SubItemCode=AllDataItems_code )
          and :year=:sYear and :month=:sMonth
         
    )
   
    
	q SQLCODE
}
*/
Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uGetJXScoreS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
