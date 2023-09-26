/// 取人事系统的工资
Class dhc.bonus.umodule.GetHRWage Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Zhao LIGuo 
/// CreatDate: 2015-01-07
/// Description:得到人事工资，（人事市场化人员工资后发一个月）
/// Table：
/// Input: 
/// Output: 
/// Return: 
/// Others:d ##class(dhc.bonus.umodule.GetHRWage).GetHRWage("2015","01","2","chenwen")
ClassMethod GetHRWage(syear, smonth, Methord, user) As %String
{
	new (syear,smonth,Methord,user)
	s month="M"_smonth
	&sql(delete from dhc_bonus_module.BonusExpendCollect  where Methord=2 and BonusYear=:syear and BonusPeriod=:month )
	
	s sqlStr="SELECT * FROM dhc_bonus_module.BonusExpendItem WHERE ItemLevel=1 and ExpendType=1 "
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
	    
        s ItemCode=result.Data("BonusExpendItemID")
        s code=result.Data("ItemCode")
        s ItemName=result.Data("ItemName")

             s sqlStr1="select * from dhc_bonus_module.BonusExpendItem where SuperItemID='"_ItemCode_"' "
	        
	        s result1=##class(%Library.ResultSet).%New()
	        d result1.Prepare(sqlStr1)
	        d result1.Execute()
	         While(result1.Next())
	        {   
	            s code=result1.Data("ItemCode")
	            s sql="isNull(a."_code_",0)"
	           
	            s name=result1.Data("ItemName")
	           d ..GetHRWageDetail(code,name,sql,syear,smonth,Methord,user)
	            //s Items= " isNull(a."_Item_",0) + "_ Items
	        }
	        d result1.Close()
	      // s sql=Items_" 0"
	      // d ..GetHRWageDetail(code,ItemName,sql,syear,smonth,Methord,user)
	       
	  
	    
        }
  d result.Close()
}

ClassMethod GetHRWageDetail(ItemCode, ItemName, sql, syear, smonth, Methord, user) As %String
{
	n (ItemCode,ItemName, sql,syear,smonth,Methord,user)

	s month1="M"_smonth
	s date=$zd($h,3)
	s date=$zdh(date,3)
	s sqlStr="SELECT FinanceStatName DeptCode,b.DeptName  DeptName ,Convert(decimal(18,2),sum("_sql_")) as je from HISHR.PSWagesHistoryInfo a,hishr.DeptInfo b"
   _" WHERE a.DeptCode = b.DeptCode AND Year ='"_syear_"' AND Month ='"_smonth_"'"
   _" GROUP BY FinanceStatName,b.DeptName"
   k ^cwtemp
   s ^cwtemp=sqlStr
   
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{   
        s DeptCode=result.Data("DeptCode")
        s DeptName=result.Data("DeptName")
        s je=result.Data("je")
      
        i je>0 d
        .&sql(insert into dhc_bonus_module.BonusExpendCollect (DeptCode,DeptName,BonusYear,
		BonusPeriod,ItemCode,ItemName,ItemValue,CollectDate,Operator,state,Methord,IsValue)
		values(:DeptCode,:DeptName,:syear,:month1,:ItemCode,:ItemName,:je,:date,:user,0,:Methord,"Y"))
    }
  d result.Close()
}

Storage Default
{
<StreamLocation>^dhc.bonus.umodule.GetHRWageS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
