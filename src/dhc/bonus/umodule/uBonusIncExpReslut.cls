Class dhc.bonus.umodule.uBonusIncExpReslut Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// others:w ##class(dhc.bonus.umodule.uBonusIncExpReslut).List("","",0,10,"","")
/// others:w ##class(dhc.bonus.umodule.uBonusIncExpReslut).List("","",0,10,"2016-05-01","")
ClassMethod List(sortField, sortDir, start, limit, yearmonth, deptcode) As %String
{
    n (sortField, sortDir, start, limit,yearmonth,deptcode)
    s year=$p(yearmonth,"-",1)
    s month="M"_$p(yearmonth,"-",2)
    
    s yearmonth= year_"-"_$p(yearmonth,"-",2)
    
    s sqlstr="SELECT BonusUnitID,BonusUnitID->BonusUnitCode,BonusUnitID->BonusUnitName, BonusYear, BonusPeriod, BonusUnitID, IncValue, ExpValue"
    _", CalcDate, Operator, CheckDate, CheckMan, State, UpdateDate"
    _" FROM dhc_bonus_module.BonusIncExpResult "
    _" where  BonusYear='"_year_"' and BonusPeriod='"_month_"'"
    i deptcode'="" s sqlstr=sqlstr_" and BonusUnitID->BonusUnitCode='"_deptcode_"'"
    
    s result=##class(%Library.ResultSet).%New()
    
    d result.Prepare(sqlstr)
    d result.Execute()

    s count=0
    s resultString=""
    s end=start+limit-1

    s json=##class(herp.comm.JsonObj).%New()
    s jsonTitle="yearmonth^deptcode^deptname^myin^myout^myleave^checkdate^checkman^state^Operator^CalcDate^BonusUnitID"
    While(result.Next())
    {
    
    s BonusUnitID= result.Data("BonusUnitID")
    s deptcode= result.Data("BonusUnitCode")
    s deptname= result.Data("BonusUnitName")
    s myin= result.Data("IncValue")
    s myout= result.Data("ExpValue")
    
    s myleave= myin-myout
        
    s myout=$fn(myout,",","2")
    s myin=$fn(myin,",","2")

    s myleave=$fn(myleave,",","2")
    ;w !,myin_"："_myout_"："_myleave,!
    
    s checkdate= result.Data("CheckDate")
    //s checkdate=$zd(checkdate,3)
    s checkman= result.Data("CheckMan")
    s state= result.Data("State")
    i state=0 s state="计算完成"
    i state=1 s state="审核完成"
    
    s Operator= result.Data("Operator")
    s CalcDate= result.Data("CalcDate")

    s temp=yearmonth_"^"_deptcode_"^"_deptname_"^"_myin_"^"_myout_"^"_myleave_"^"_checkdate_"^"_checkman_"^"_state_"^"_Operator_"^"_CalcDate_"^"_BonusUnitID
    i (count>=start)&(count<=end) d
    .d json.InsertRowData(temp)
    s count=count+1
    }

    d result.Close()
    s resultString = json.getJsonData(jsonTitle,count)
    k json
    q resultString
}

/// others:w ##class(dhc.bonus.umodule.uBonusIncExpReslut).List("","",0,10,"","")
/// others:w ##class(dhc.bonus.umodule.uBonusIncExpReslut).ListIncomeDetail("","",0,10,"2015-05","11")
ClassMethod ListIncomeDetail(sortField, sortDir, start, limit, yearmonth, BonusUnitID) As %String
{
    n (sortField, sortDir, start, limit,yearmonth,BonusUnitID)
    s year=$E(yearmonth,1,4)
    s month="M" _ $P(yearmonth,"-",2)
    
    s yearmonth= year_"-"_$P(yearmonth,"-",2)
    
    s sqlStr="SELECT BonusYear ,BonusPeriod ,BonusUnitID->BonusUnitName, ItemValue, ItemCode, ItemName"
    _" FROM dhc_bonus_module.BonusIncMain "
    _" WHERE  BonusYear='"_year_"' AND BonusPeriod='"_month_"'"
    _" AND BonusUnitID="_BonusUnitID
    ;W sqlStr,!
    s result=##class(%Library.ResultSet).%New()
    d result.Prepare(sqlStr)
    d result.Execute()
    //w sqlStr,!
    s count=0
    s resultString=""
    s end=start+limit-1
    s hj=0
    s json=##class(herp.comm.JsonObj).%New()
    s jsonTitle="rowid^itemname^itemvalue^deptname^itemtype"
    While(result.Next())
    {
    
    s itemname= result.Data("ItemName")
    s itemvalue= result.Data("ItemValue")
    s hj=hj+itemvalue
    s itemvalue=$fn(itemvalue,",","2")
    s deptname= result.Data("BonusUnitName")
    s itemtype= "收入"
    

    s temp=yearmonth_"^"_itemname_"^"_itemvalue_"^"_deptname_"^"_itemtype
    i (count>=start)&(count<=end) d
    .d json.InsertRowData(temp)
    s count=count+1
    }
    s hj=$fn(hj,",","2")
    d json.InsertRowData("^合计：^"_hj_"^^")
    
    d result.Close()
    s resultString = json.getJsonData(jsonTitle,count)
    k json
    q resultString
}

/// others:w ##class(dhc.bonus.umodule.uBonusIncExpReslut).List("","",0,10,"","")
/// others:w ##class(dhc.bonus.umodule.uBonusIncExpReslut).ListExpendDetail("","",0,10,"2015-06","580")
ClassMethod ListExpendDetail(sortField, sortDir, start, limit, yearmonth, deptcode) As %String
{
    n (sortField, sortDir, start, limit,yearmonth,deptcode)
    s year=$E(yearmonth,1,4)
    s month="M" _ $P(yearmonth,"-",2)
    
    s yearmonth= year_$P(yearmonth,"-",2)
    
    s sqlStr="SELECT BonusYear||BonusPeriod AS yearmonth, ItemName, ItemValue, DeptName"
    _" FROM dhc_bonus_module.BonusIncExpResult WHERE DeptCode='"_deptcode_"' AND BonusYear='"_year_"' AND BonusPeriod='"_month_"' AND ItemType=2"
    
    s sqlStr=" SELECT BonusYear ,BonusPeriod ,BonusUnitID->BonusUnitName, ItemCode, ItemName, ItemValue"
    _" FROM dhc_bonus_module.BonusExpMain "
    _" WHERE  BonusYear='"_year_"' AND BonusPeriod='"_month_"'"
    _" AND BonusUnitID='"_deptcode_"'"
    ;w sqlStr,!
    ;S ^zlgtem111=sqlStr
    s result=##class(%Library.ResultSet).%New()
    d result.Prepare(sqlStr)
    d result.Execute()
    //w sqlStr,!
    s count=0
    s resultString=""
    s end=start+limit-1
    s hj=0
    s json=##class(herp.comm.JsonObj).%New()
    s jsonTitle="rowid^itemname^itemvalue^deptname^itemtype"
    While(result.Next())
    {
    
    s itemname= result.Data("ItemName")
    s itemvalue= result.Data("ItemValue")
    s hj=hj+itemvalue
    s itemvalue=$fn(itemvalue,",","2")
    s deptname= result.Data("BonusUnitName")
    s itemtype= "支出"
    ;w "hj="_hj,!
    s temp=yearmonth_"^"_itemname_"^"_itemvalue_"^"_deptname_"^"_itemtype
    i (count>=start)&(count<=end) d
    .d json.InsertRowData(temp)
    s count=count+1
    }
    s hj=$fn(hj,",","2")
    s temp1="^合计：^"_hj_"^^"
    d json.InsertRowData(temp1)

    d result.Close()
    s resultString = json.getJsonData(jsonTitle,count)
    k json
    q resultString
}

/// description : 查找科室
/// w ##class(dhc.bonus.umodule.uBonusIncExpReslut).getDept(0,15,"CK")
ClassMethod getDept(start, limit, str) As %String
{
    n (start, limit, str)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT BonusUnitID, BonusUnitCode, BonusUnitName FROM dhc_bonus_data.BonusUnit WHERE LastStage=0"
    i str'="" s sqlStr = sqlStr_" and BonusUnitCode  LIKE '%"_str_"%'"_" OR BonusUnitName LIKE '%"_str_"%'"
    d result.Prepare(sqlStr)
    d result.Execute()
    //w sqlStr,!
    s count = 0
    s resultString = ""
    s end = start+limit
    s json = ##class(herp.comm.JsonObj).%New()
    While(result.Next()){
        s rowid = result.Data("BonusUnitCode")
        s name = result.Data("BonusUnitName")
        s tmp=rowid_"^"_name
        s count = count+1
        i (count>start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("rowid^name",count)
    k json
    q resultString
}

/// Creator: Zhao LIGuo 
/// CreatDate: 2015-5-26
/// Description: 奖金收入支出结余计算
/// Input: code-年月、操作员
/// Output: 
/// Return: 
/// w ##class(dhc.bonus.umodule.uBonusIncExpReslut).Calculator("2016-01-01","demo")
ClassMethod Calculator(yearmonth, userCode) As %String
{
    n (yearmonth,userCode)
    s year=$p(yearmonth,"-",1)
    s month="M"_$p(yearmonth,"-",2)

    s caldate=$p($h,",",1)
    s user=userCode
    ;w year_","_month,!
    &sql(delete from dhc_bonus_module.BonusIncExpResult where BonusYear=:year AND BonusPeriod=:month)
    // 计算科室收入
    d ..uGetIncDataCal(year,month,userCode)
    //计算科室支出
    d ..uGetExpDataCal(year,month,userCode)
    
    //插入收支结余表
    &sql(INSERT INTO dhc_bonus_module.BonusIncExpResult
    (BonusYear ,BonusPeriod ,BonusUnitID ,IncValue ,ExpValue ,CalcDate ,Operator  ,State ,UpdateDate )
    SELECT BonusYear ,BonusPeriod ,BonusUnitID, sum(sr) sr,sum(zc) zc  ,getdate() CalcDate ,:user   ,0 State ,getdate()  UpdateDate
    from (
    SELECT BonusYear ,BonusPeriod ,BonusUnitID, 0 sr,sum(ItemValue) zc  
    FROM dhc_bonus_module.BonusExpMain a
    WHERE  BonusYear=:year AND BonusPeriod=:month 
    GROUP BY BonusYear ,BonusPeriod ,BonusUnitID
    UNION all
    SELECT BonusYear ,BonusPeriod ,BonusUnitID, sum(ItemValue) sr,0 zc
    FROM dhc_bonus_module.BonusIncMain
    WHERE  BonusYear=:year AND BonusPeriod=:month 
    GROUP BY BonusYear ,BonusPeriod ,BonusUnitID
    ) AS hh
    GROUP BY BonusYear ,BonusPeriod ,BonusUnitID)
    
    q 0
}

ClassMethod Calculator2bak(yearmonth, user) As %String
{
    n (yearmonth,user)
    s year=$p(yearmonth,"-",1)
    s month="M"_$p(yearmonth,"-",2)
    s caldate=$p($h,",",1)
    w year_","_month,!
    &sql(delete from dhc_bonus_module.BonusIncExpResult where BonusYear=:year AND BonusPeriod=:month)
    &sql(delete from dhc_bonus_module.BonusIncDetail where BonusYear=:year AND BonusPeriod=:month)
    &sql(delete from dhc_bonus_module.BonusIncMain where BonusYear=:year AND BonusPeriod=:month)
    &sql(delete from dhc_bonus_module.BonusExpDetail where BonusYear=:year AND BonusPeriod=:month)
    &sql(delete from dhc_bonus_module.BonusExpMain where BonusYear=:year AND BonusPeriod=:month)
    /*

    //科室开单收入明细
    &sql(INSERT INTO dhc_bonus_module.BonusIncDetail(BonusYear ,BonusPeriod ,ItemCode ,ItemName ,ItemValue ,BonusUnitID ,Operator ,State ,DataType,UpdateDate,ItemRate)
    SELECT BonusYear ,BonusPeriod, IncomeItemCode,b.TAREC_Desc,sum(IncomeMoney*MakeBillDeptRate),c.SuperiorUnitID,:user Operator,0 State,1 DataType,getdate(),MakeBillDeptRate ItemRate
    FROM dhc_bonus_module.BonusIncomeCollect a,SQLUSER.DHC_TarEMCCate b,dhc_bonus_data.bonusUnit c,dhc_bonus_module.BonusIncomeRate d
    WHERE  a.IncomeItemCode=b.TAREC_RowId AND a.MakeBillDeptCode =c.BonusUnitCode 
    AND a.IncomeItemCode=d.IncItemCode AND a.SickType=d.SickType
    AND a.BonusYear=:year AND a.BonusPeriod=:month
    GROUP BY BonusYear ,BonusPeriod, IncomeItemCode,b.TAREC_Desc,c.BonusUnitID)
    //科室开单收入汇总
    &sql(INSERT INTO dhc_bonus_module.BonusIncMain
    (BonusYear ,BonusPeriod ,ItemCode , ItemName ,  ItemValue , BonusUnitID ,Operator , State ,UpdateDate,DataType )
    SELECT BonusYear ,BonusPeriod ,'G0101' ItemCode ,'开单科室收入' ItemName ,SUM(ItemValue*ItemRate) ItemValue,BonusUnitID ,:user ,0 State ,getdate() UpdateDate,DataType
    FROM dhc_bonus_module.BonusIncDetail 
    WHERE DataType=1 AND BonusYear=:year AND BonusPeriod=:month 
    GROUP BY BonusYear ,BonusPeriod , BonusUnitID )


    //科室执行收入
    &sql(INSERT INTO dhc_bonus_module.BonusIncDetail(BonusYear ,BonusPeriod ,ItemCode ,ItemName ,ItemValue ,BonusUnitID ,Operator ,State ,DataType,UpdateDate,ItemRate)
    SELECT BonusYear ,BonusPeriod, IncomeItemCode,b.TAREC_Desc,sum(IncomeMoney*ExecuteDeptRate),c.SuperiorUnitID,:user,0 State,2 DataType,getdate(),ExecuteDeptRate ItemRate
    FROM dhc_bonus_module.BonusIncomeCollect a,SQLUSER.DHC_TarEMCCate b,dhc_bonus_data.bonusUnit c,dhc_bonus_module.BonusIncomeRate d
    WHERE  a.IncomeItemCode=b.TAREC_RowId AND a.ExecuteDeptCode =c.BonusUnitCode 
    AND a.IncomeItemCode=d.IncItemCode AND a.SickType=d.SickType
    AND a.BonusYear=:year AND a.BonusPeriod=:month
    GROUP BY BonusYear ,BonusPeriod, IncomeItemCode,b.TAREC_Desc,c.BonusUnitID)
    //科室开单收入汇总
    &sql(INSERT INTO dhc_bonus_module.BonusIncMain
    (BonusYear ,BonusPeriod ,ItemCode , ItemName ,  ItemValue , BonusUnitID ,Operator , State ,UpdateDate,DataType )
    SELECT BonusYear ,BonusPeriod ,'G0102' ItemCode ,'执行科室收入' ItemName ,SUM(ItemValue*ItemRate) ItemValue,BonusUnitID ,:user ,0 State ,getdate() UpdateDate,DataType
    FROM dhc_bonus_module.BonusIncDetail 
    WHERE DataType=2 AND BonusYear=:year AND BonusPeriod=:month 
    GROUP BY BonusYear ,BonusPeriod , BonusUnitID )

    //科室病人收入
    &sql(INSERT INTO dhc_bonus_module.BonusIncDetail(BonusYear ,BonusPeriod ,ItemCode ,ItemName ,ItemValue ,BonusUnitID ,Operator ,State ,DataType,UpdateDate,ItemRate)
    SELECT BonusYear ,BonusPeriod, IncomeItemCode,b.TAREC_Desc,sum(IncomeMoney*SickDeptRate),c.SuperiorUnitID,:user ,0 State,3 DataType,getdate(),SickDeptRate ItemRate
    FROM dhc_bonus_module.BonusIncomeCollect a,SQLUSER.DHC_TarEMCCate b,dhc_bonus_data.bonusUnit c,dhc_bonus_module.BonusIncomeRate d
    WHERE  a.IncomeItemCode=b.TAREC_RowId AND a.SickDeptCode =c.BonusUnitCode 
    AND a.IncomeItemCode=d.IncItemCode AND a.SickType=d.SickType
    AND a.BonusYear=:year AND a.BonusPeriod=:month
    GROUP BY BonusYear ,BonusPeriod, IncomeItemCode,b.TAREC_Desc,c.BonusUnitID)
    //科室开单收入汇总
    &sql(INSERT INTO dhc_bonus_module.BonusIncMain
    (BonusYear ,BonusPeriod ,ItemCode , ItemName ,  ItemValue , BonusUnitID ,Operator , State ,UpdateDate,DataType )
    SELECT BonusYear ,BonusPeriod ,'G0103' ItemCode ,'病人科室收入' ItemName ,SUM(ItemValue*ItemRate) ItemValue,BonusUnitID ,:user ,0 State ,getdate() UpdateDate,DataType
    FROM dhc_bonus_module.BonusIncDetail 
    WHERE DataType=3 AND BonusYear=:year AND BonusPeriod=:month 
    GROUP BY BonusYear ,BonusPeriod , BonusUnitID )
    */
    //科室支出明细
    &SQL(INSERT INTO dhc_bonus_module.BonusExpDetail(BonusYear, BonusPeriod,ItemCode ,ItemName, ItemValue,ItemRate ,BonusUnitID ,Operator , State , UpdateDate)
    select BonusYear,BonusPeriod,a.ItemCode ,c.ItemName,sum(a.ItemValue) ItemValue,c.ItemRate ,b.SuperiorUnitID ,:user  ,0 State ,getdate() UpdateDate
    FROM dhc_bonus_module.BonusExpendCollect a,dhc_bonus_data.bonusUnit b ,dhc_bonus_module.BonusExpendItem c
    WHERE  a.DeptCode =b.BonusUnitCode AND a.ItemCode =c.ItemCode 
    and BonusYear=:year AND BonusPeriod=:month 
    GROUP BY BonusYear,BonusPeriod,a.ItemCode ,c.ItemName,c.ItemRate ,SuperiorUnitID)
    //科室支出汇总
    &sql(iNSERT INTO dhc_bonus_module.BonusExpMain(BonusYear,BonusPeriod,ItemCode ,ItemName,    ItemValue ,BonusUnitID ,Operator ,  State , UpdateDate)
    SELECT BonusYear,BonusPeriod,b.SuperItemID->ItemCode ItemCode ,b.SuperItemID->ItemName ItemName,sum(ItemValue*a.ItemRate) ,BonusUnitID ,:user , 0 State ,getdate() UpdateDate
    FROM dhc_bonus_module.BonusExpDetail a,dhc_bonus_module.BonusExpendItem b
    WHERE a.ItemCode=b.ItemCode and BonusYear=:year AND BonusPeriod=:month 
    group by BonusYear,BonusPeriod,b.SuperItemID->ItemCode  ,b.SuperItemID->ItemName ,ItemValue ,BonusUnitID
    )
    //插入收支结余表
    &sql(INSERT INTO dhc_bonus_module.BonusIncExpResult
    (BonusYear ,BonusPeriod ,BonusUnitID ,IncValue ,ExpValue ,CalcDate ,Operator  ,State ,UpdateDate )
    SELECT BonusYear ,BonusPeriod ,BonusUnitID, sum(sr) sr,sum(zc) zc  ,getdate() CalcDate ,:user   ,0 State ,getdate()  UpdateDate
    from (
    SELECT BonusYear ,BonusPeriod ,BonusUnitID, 0 sr,sum(ItemValue) zc  
    FROM dhc_bonus_module.BonusExpMain a,dhc_bonus_module.BonusExpendItem b
    WHERE  BonusYear=:year AND BonusPeriod=:month 
    GROUP BY BonusYear ,BonusPeriod ,BonusUnitID
    UNION all
    SELECT BonusYear ,BonusPeriod ,BonusUnitID, sum(ItemValue) sr,0 zc
    FROM dhc_bonus_module.BonusIncMain
    WHERE  BonusYear=:year AND BonusPeriod=:month 
    GROUP BY BonusYear ,BonusPeriod ,BonusUnitID
    ) AS hh
    GROUP BY BonusYear ,BonusPeriod ,BonusUnitID)
    
    q 0
}

/// Others:w ##class(dhc.bonus.umodule.uBonusIncExpReslut).Audit("2015-05-01","demo")
ClassMethod Audit(yearmonth, checker) As %String
{
    n (yearmonth,checker)
    s year=$p(yearmonth,"-",1)
    s month="M"_$p(yearmonth,"-",2)
    //w year,month,!
    &sql(DELETE FROM dhc_bonus_data.BonusTargetCollect 
        WHERE Remark in('收入模块','成本模块') AND BonusYear=:year and BonusPeriod=:month)
        
    &sql(INSERT INTO dhc_bonus_data.BonusTargetCollect (BonusTargetID, BonusUnitID,  BonusYear, BonusPeriod,
     DataSource, TargetValue,  UpdateDate, Remark)
    SELECT BonusTargetID, BonusUnitID,  BonusYear, BonusPeriod,
    2 DataSource,sum(a.ItemValue*a.ItemRate*b.MakeBillRate) AS jj ,getdate() UpdateDate,'收入模块' Remark
    FROM dhc_bonus_module.BonusIncDetail  a,dhc_bonus_module.BonusIncItemMap b
    WHERE a.ItemCode= b.%id AND a.dataType=1 AND a.BonusYear=:year  AND a.BonusPeriod=:month
    GROUP BY BonusTargetID, BonusUnitID,  BonusYear, BonusPeriod
  UNION all
    SELECT BonusTargetID, BonusUnitID,  BonusYear, BonusPeriod,
     2 DataSource,sum(a.ItemValue*a.ItemRate*b.ExecuteRate) AS jj ,getdate() UpdateDate,'收入模块' Remark
    FROM dhc_bonus_module.BonusIncDetail  a,dhc_bonus_module.BonusIncItemMap b
    WHERE a.ItemCode= b.%id AND a.dataType=2 AND  a.BonusYear=:year AND a.BonusPeriod=:month
    GROUP BY BonusTargetID, BonusUnitID,  BonusYear, BonusPeriod
  UNION all
    SELECT BonusTargetID, BonusUnitID,  BonusYear, BonusPeriod,
    2 DataSource,sum(a.ItemValue*a.ItemRate*b.SickRate) AS jj ,getdate() UpdateDate,'收入模块' Remark
    FROM dhc_bonus_module.BonusIncDetail  a,dhc_bonus_module.BonusIncItemMap b
    WHERE a.ItemCode= b.%id AND a.dataType=3 AND a.BonusYear=:year  AND a.BonusPeriod=:month
    GROUP BY BonusTargetID, BonusUnitID,  BonusYear, BonusPeriod)

    &sql(INSERT INTO dhc_bonus_data.BonusTargetCollect (BonusTargetID, BonusUnitID,  BonusYear, BonusPeriod,
        DataSource, TargetValue,  UpdateDate, Remark)
        SELECT BonusTargetID, BonusUnitID,  BonusYear, BonusPeriod,
        2 DataSource,sum(a.ItemValue*a.ItemRate*b.ItemRate) AS jj ,getdate() UpdateDate,'成本模块' Remark
        FROM dhc_bonus_module.BonusExpDetail a,dhc_bonus_module.BonusExpItemMap b
        WHERE a.ItemCode =b.BonusExpendItemID->ItemCode  
        AND a.BonusYear=:year   AND a.BonusPeriod=:month
    )   

    s updatedate=$p($h,",",1)
    &sql( UPDATE dhc_bonus_module.BonusIncExpResult
        SET CheckDate = getdate(),  CheckMan = :checker,State = 1   
        WHERE BonusYear=:year   AND BonusPeriod=:month  )
    IF SQLCODE=11 {S SQLCODE=0}
    q SQLCODE
}

/// 作者：赵立国
/// 日期：2015-08-28
/// 功能：计算支出数据
/// 参数：sYear：yyyy, sMonth：M06,userCode:demo
/// 用例: w ##class(dhc.bonus.umodule.uBonusIncExpReslut).uGetExpDataCal("2016","M05","zlg")
ClassMethod uGetExpDataCal(sYear, sMonth, userCode) As %String
{
    n (sYear, sMonth,userCode)
    
    &sql(delete from dhc_bonus_module.BonusExpDetail where BonusYear=:sYear AND BonusPeriod=:sMonth)
    &sql(delete from dhc_bonus_module.BonusExpMain where BonusYear=:sYear AND BonusPeriod=:sMonth)
    //科室支出明细
    &SQL(INSERT INTO dhc_bonus_module.BonusExpDetail(BonusYear, BonusPeriod,ItemCode ,ItemName, ItemValue,ItemRate ,BonusUnitID ,Operator , State , UpdateDate,MethordDr)
        SELECT  BonusYear, BonusPeriod, ItemCode, ItemName, sum(ItemValue) ItemValue, ItemRate, BonusUnitID,:user
        ,0 State,getdate() UpdateDate,Methord FROM(
        select BonusYear,BonusPeriod,a.ItemCode ,c.ItemName,sum(a.ItemValue+isnull(a.adjustMoney,0)) ItemValue,c.ItemRate ,b.SuperiorUnitID BonusUnitID,Methord
        FROM dhc_bonus_module.BonusExpendCollect a,dhc_bonus_data.bonusUnit b ,dhc_bonus_module.BonusExpendItem c
        WHERE  a.DeptCode =b.BonusUnitCode AND a.ItemCode =c.ItemCode  AND b.LastStage=1 and a.IsValue="Y"
        and BonusYear=:sYear AND BonusPeriod=:sMonth 
        GROUP BY BonusYear,BonusPeriod,a.ItemCode ,c.ItemName,c.ItemRate ,SuperiorUnitID
        union all
            select BonusYear,BonusPeriod,a.ItemCode ,c.ItemName,sum(a.ItemValue+isnull(a.adjustMoney,0)) ItemValue,c.ItemRate ,b.BonusUnitID ,Methord
        FROM dhc_bonus_module.BonusExpendCollect a,dhc_bonus_data.bonusUnit b ,dhc_bonus_module.BonusExpendItem c
        WHERE  a.DeptCode =b.BonusUnitCode AND a.ItemCode =c.ItemCode  AND b.LastStage=0  and a.IsValue="Y"
        and BonusYear=:sYear AND BonusPeriod=:sMonth 
        GROUP BY BonusYear,BonusPeriod,a.ItemCode ,c.ItemName,c.ItemRate ,b.BonusUnitID
        ) as jj GROUP BY     BonusYear, BonusPeriod, ItemCode, ItemName,  ItemRate, BonusUnitID
    )
        //科室支出明细(预算报销单独处理)
    &SQL(INSERT INTO dhc_bonus_module.BonusExpDetail(BonusYear, BonusPeriod,ItemCode ,ItemName, ItemValue,ItemRate ,BonusUnitID ,Operator , State , UpdateDate,MethordDr)
    SELECT  BonusYear, BonusPeriod, ItemCode, ItemName, sum(ItemValue) ItemValue, ItemRate, BonusUnitID,:user
        ,0 State,getdate() UpdateDate,Methord FROM(
        select BonusYear,BonusPeriod, '500101' ItemCode ,'预算报销成本' ItemName,sum(a.ItemValue+isnull(a.adjustMoney,0)) ItemValue,1 ItemRate ,b.SuperiorUnitID BonusUnitID,b.SuperiorUnitID->BonusUnitName,Methord
        FROM dhc_bonus_module.BonusExpendCollect a,dhc_bonus_data.bonusUnit b 
        WHERE  a.DeptCode =b.BonusUnitCode  AND b.LastStage=1
        and BonusYear=:sYear AND BonusPeriod=:sMonth AND Methord=4  and a.IsValue="Y"
        GROUP BY BonusYear,BonusPeriod,SuperiorUnitID
        union all
            select BonusYear,BonusPeriod,'500101' ItemCode ,'预算报销成本' ItemName,sum(a.ItemValue+isnull(a.adjustMoney,0)) ItemValue,1 ItemRate ,b.BonusUnitID ,b.BonusUnitName ,Methord
        FROM dhc_bonus_module.BonusExpendCollect a,dhc_bonus_data.bonusUnit b 
        WHERE  a.DeptCode =b.BonusUnitCode  AND b.LastStage=0
        and BonusYear=:sYear AND BonusPeriod=:sMonth AND Methord=4  and a.IsValue="Y"
        GROUP BY BonusYear,BonusPeriod ,b.BonusUnitID 
        ) as jj GROUP BY     BonusYear, BonusPeriod, BonusUnitID

    )
    
    ;W SQLCODE,!
    //科室支出汇总
    &sql(iNSERT INTO dhc_bonus_module.BonusExpMain(BonusYear,BonusPeriod,ItemCode ,ItemName,    ItemValue ,BonusUnitID ,Operator ,  State , UpdateDate)
        SELECT BonusYear,BonusPeriod,b.BonusTargetID->BonusTargetCode ItemCode ,b.BonusTargetID->BonusTargetName ItemName,sum(ItemValue*a.ItemRate) ,BonusUnitID ,:user , 0 State ,getdate() UpdateDate
    FROM dhc_bonus_module.BonusExpDetail a,dhc_bonus_module.BonusExpItemMap b
    WHERE a.ItemCode=b.BonusExpendItemID->ItemCode and BonusYear=:sYear AND BonusPeriod=:sMonth
    group by BonusYear,BonusPeriod,BonusTargetID->BonusTargetCode  ,BonusUnitID
    )
    Q 0
}

/// 作者：赵立国
/// 日期：2015-08-24
/// 功能：计算收入数据
/// 参数：startdate, enddate
/// others:w ##class(dhc.bonus.umodule.uBonusIncExpReslut).uGetIncDataCal("2016","M03","demo")
ClassMethod uGetIncDataCal(sYear, sMonth, userCode) As %String
{
    n (sYear, sMonth,userCode)

    
    q:sYear="" ""
    q:sMonth="" ""
    k ^BonusYjsTemp
    s sPeriod=sMonth
    ;w sYear_","_sPeriod,!
    d ..uCreateTempRate() ;初始化收入计提系数临时global
    &sql(delete from  dhc_bonus_module.BonusIncDetail  where BonusYear=:sYear AND BonusPeriod=:sPeriod )
    &sql(delete dhc_bonus_module.BonusIncMain where BonusYear=:sYear AND BonusPeriod=:sPeriod )
    s num=0 
    s ItemType=""
    f  s ItemType=$o(^dhcbsmdBonusIncomeCollectI("IncCollect",sYear,sPeriod,ItemType)) q:ItemType=""  d
    .s ItemCode=""
    .f  s ItemCode=$o(^dhcbsmdBonusIncomeCollectI("IncCollect",sYear,sPeriod,ItemType,ItemCode)) q:ItemCode=""  d
    ..s mkDeptCode=""
    ..f  s mkDeptCode=$o(^dhcbsmdBonusIncomeCollectI("IncCollect",sYear,sPeriod,ItemType,ItemCode,mkDeptCode)) q:mkDeptCode=""  d
    ...s mkDeptID=..uGetDetpID(mkDeptCode)
    ...s exDeptCode=""
    ...f  s exDeptCode=$o(^dhcbsmdBonusIncomeCollectI("IncCollect",sYear,sPeriod,ItemType,ItemCode,mkDeptCode,exDeptCode)) q:exDeptCode=""  d
    ....s exDeptID=..uGetDetpID(exDeptCode)
    ....;只有开以下科室做的项目才给开单科室计提
    ....;执行科室包括：影像中心（CT、MRI、放射科）、检验科、核医学科、超声医学科、心功能科（心电图室）、细胞室、内镜中心、病理科
    ....s IsExc= ..uIsExcDept(1,exDeptID)
    ....s IsSSExc=..uIsExcDept(2,exDeptID) //判断执行科室是否是手术科室（741, '麻醉科',758, '病区手术室'）
    ....s skDeptCode=""
    ....f  s skDeptCode=$o(^dhcbsmdBonusIncomeCollectI("IncCollect",sYear,sPeriod,ItemType,ItemCode,mkDeptCode,exDeptCode,skDeptCode)) q:skDeptCode=""  d
    .....s skDeptID=..uGetDetpID(skDeptCode)
    .....s rowid=""
    .....f  s rowid=$o(^dhcbsmdBonusIncomeCollectI("IncCollect",sYear,sPeriod,ItemType,ItemCode,mkDeptCode,exDeptCode,skDeptCode,rowid)) q:rowid=""  d
    ......s IncSum=$li(^dhcbsmdBonusIncomeCollectD(rowid),12)
    ......s IncSum1=0
    ......i $D(^dhcbsmdBonusIncomeCollectD(rowid)) d
    .......i $G(^dhcbsmdBonusIncomeCollectD(rowid))'=""  d
    ........s IncSum1=$li(^dhcbsmdBonusIncomeCollectD(rowid),17)
    ........;i IncSum1'=0 w IncSum1,!
    
    ......s mkRate=..uGetItemRate("MK",ItemCode,exDeptID)
    ......;w "MK="_ItemCode_","_mkDeptID_","_mkRate_","_IsExc,!
    ......i ((mkRate'=0)&&(IsExc=1)) d
    .......;s ^BonusYjsTemp("MK",ItemCode,mkDeptID,mkRate)=$G(^BonusYjsTemp("MK",ItemCode,mkDeptID,mkRate))+IncSum
    .......s ^BonusYjsTemp("MK",ItemCode,mkDeptID,mkRate)=$G(^BonusYjsTemp("MK",ItemCode,mkDeptID,mkRate))+IncSum+IncSum1
    
    ......i ((mkRate'=0)&&(IsSSExc=1)) d //计算手术收入
    .......;s ^zlg520("MK",ItemCode,mkDeptID,mkRate)=$G(^zlg520("MK",ItemCode,mkDeptID,mkRate))+IncSum
    .......;s ^zlg520("MK",ItemCode,mkDeptID,mkRate)=$G(^zlg520("MK",ItemCode,mkDeptID,mkRate))+IncSum+IncSum1
    .......;s ^BonusYjsTemp("MK",ItemCode,mkDeptID,mkRate)=$G(^BonusYjsTemp("MK",ItemCode,mkDeptID,mkRate))+IncSum
    .......s ^BonusYjsTemp("MK",ItemCode,mkDeptID,mkRate)=$G(^BonusYjsTemp("MK",ItemCode,mkDeptID,mkRate))+IncSum+IncSum1
    
    ......s exRate=..uGetItemRate("EX",ItemCode,exDeptID)
    ......i exRate'=0 d
    
    .......;s ^BonusYjsTemp("EX",ItemCode,exDeptID,exRate)=$G(^BonusYjsTemp("EX",ItemCode,exDeptID,exRate))+IncSum
    .......s ^BonusYjsTemp("EX",ItemCode,exDeptID,exRate)=$G(^BonusYjsTemp("EX",ItemCode,exDeptID,exRate))+IncSum+IncSum1

    s ItemType=""
    f  s ItemType=$o(^BonusYjsTemp(ItemType)) q:ItemType=""  d
    .s ItemCode=""
    .f  s ItemCode=$o(^BonusYjsTemp(ItemType,ItemCode)) q:ItemCode=""  d
    ..s DeptID=""
    ..f  s DeptID=$o(^BonusYjsTemp(ItemType,ItemCode,DeptID)) q:DeptID=""  d
    ...s sRate=""
    ...f  s sRate=$o(^BonusYjsTemp(ItemType,ItemCode,DeptID,sRate)) q:sRate=""  d
    ....s sValue=$g(^BonusYjsTemp(ItemType,ItemCode,DeptID,sRate))
    ....s ItemName =""
    ....i DeptID>0 d
    .....s SJValue=sValue*sRate
    .....s SJValue=$fn(SJValue,"-",2)
    .....;i ItemCode=11 d
    ......;w sYear_"^"_sPeriod_"^"_ItemCode_"^"_ItemName_"^"_SJValue_"^"_DeptID_"^"_userCode_"^"_ItemType_"^"_sRate_"^"_sValue,!
    .....&sql(INSERT INTO dhc_bonus_module.BonusIncDetail(BonusYear ,BonusPeriod ,ItemCode ,ItemName ,ItemValue ,BonusUnitID ,Operator ,State ,DataType,UpdateDate,ItemRate,IncValue)
     values(:sYear ,:sPeriod ,:ItemCode ,:ItemName ,:SJValue ,:DeptID ,:userCode ,0 ,:ItemType,getdate(),:sRate,:sValue))
    
    //科室收入汇总
    &sql(INSERT INTO dhc_bonus_module.BonusIncMain
    (BonusYear ,BonusPeriod ,ItemCode , ItemName ,  ItemValue , BonusUnitID ,Operator , State ,UpdateDate,DataType )
        SELECT BonusYear ,BonusPeriod ,b.BonusTargetID->BonusTargetCode,b.BonusTargetID->BonusTargetName ItemName 
    ,SUM(ItemValue) ItemValue,BonusUnitID ,:userCode ,0 State ,getdate() UpdateDate,DataType
    FROM dhc_bonus_module.BonusIncDetail a,dhc_bonus_module.BonusIncItemMap b
    WHERE a.DataType=b.ItemType AND  a.ItemCode=b.BonusIncItemID->ItemCode 
    and BonusYear=:sYear AND BonusPeriod=:sPeriod 
    GROUP BY BonusYear ,BonusPeriod , BonusUnitID ,b.BonusTargetID
        
 )
    ;
    q 0
}

/// 作者：赵立国
/// 日期：2015-08-20
/// 功能：创建收入项目计提系统临时golbal
/// 参数：
/// others:d ##class(dhc.bonus.umodule.uBonusIncExpReslut).uCreateTempRate()
ClassMethod uCreateTempRate() As %String
{
    s sqlstr=" SELECT a.BonusIncItemID ,c.BonusUnitID,a.SickType,a.MakeBillDeptRate,a.ExecuteDeptRate,a.SickDeptRate "
    _" FROM dhc_bonus_module.BonusIncomeRate a,dhc_bonus_subs.BonusSubDeptGroupMap b,dhc_bonus_data.BonusUnit c"
    _" WHERE a.DeptGroupID=b.BonusDeptGroupID  AND b.BonusUnit =c.%ID"
    s result=##class(%Library.ResultSet).%New()
    d result.Prepare(sqlstr)
    d result.Execute()
    ;w sqlstr,!
    k ^BonusTempRate
    While(result.Next()){
        s ItemID = result.Data("BonusIncItemID")
        s UnitID = result.Data("BonusUnitID")
        s mkRate = result.Data("MakeBillDeptRate")
        s exRate = result.Data("ExecuteDeptRate")
        s skRate = result.Data("SickDeptRate")
        s ^BonusTempRate("MK",ItemID,UnitID)=mkRate
        s ^BonusTempRate("EX",ItemID,UnitID)=exRate
        s ^BonusTempRate("SK",ItemID,UnitID)=skRate
        
    }
    d result.Close()
}

/// 作者：赵立国
/// 日期：2015-08-20
/// 功能：转换His科室编码为标准的9位科室编码
/// 参数：DeptCode:his科室编码
/// others:w ##class(dhc.bonus.umodule.uBonusIncExpReslut).uGetDetpID("100412300")
ClassMethod uGetDetpID(DeptCode) As %String
{
  n (DeptCode)
  q:DeptCode="" "-1"

  s UnitDr1=""
  s UnitDr1=$O(^dhcbsBonusUnitI("BonusUnitCode",DeptCode,UnitDr1))
  i UnitDr1="" d
  .s UnitDr1="-1"
  
  q UnitDr1
}

/// 作者：赵立国 
/// 日期：2015-08-19
/// 功能：获得收入项目的计提系数
/// 参数：ItemType：MK=开单、EX=执行、SK=病人, ItemID：项目ID, UnitDr：科室ID
/// others:w ##class(dhc.bonus.umodule.uBonusIncExpReslut).uIsExcDept(735)
ClassMethod uIsExcDept(grouID, UnitDr) As %String
{
    n (grouID,UnitDr)
    q:UnitDr="" 0
    
    s ItemID="",rtn=0
    s ItemID=$o(^dhcbsSubDeptGroupMapI("Parent",grouID,UnitDr,ItemID))
    
    i ItemID="" d
    .s rtn=0
    e  d
    .;w $list(^dhcbsBonusUnitD(UnitDr),2),!
    .;w $list(^dhcbsBonusUnitD(UnitDr),3),!
    .s rtn=1
    
    ;s sPrice=$list(^dhcbsBonusTargetD(rowid),20) ;取指标默认值
    q rtn
}

/// 作者：赵立国 
/// 日期：2015-08-19 zlg111
/// 功能：获得收入项目的计提系数 10,11,13,16
/// 参数：ItemType：MK=开单、EX=执行、SK=病人, ItemID：项目ID, UnitDr：科室ID
/// others:w ##class(dhc.bonus.umodule.uBonusIncExpReslut).uGetItemRate("EX","10",732)
ClassMethod uGetItemRate(ItemType, ItemCode, UnitDr) As %String
{
    n (ItemType,ItemCode,UnitDr)
    q:ItemCode="" 0
    q:ItemType="" 0
    
    s mkrate=0
    S sRate=0
    s IsValid=0
    ;W "---Begin-----",!
    s ItemID=""
    s ItemID=$o(^dhcbsmodule.BonusIncItemI("BonusIncItemIdx",ItemCode,ItemID))
    ;W "ItemID="_ItemID,!
    i ItemID'="" d
    .s IsValid=$Li(^dhcbsmodule.BonusIncItemD(ItemID),4)
    e  d
    .s ItemID=-1
    ;s itemcode=$LI(^dhcbsSubItemD(rowid),2)
    ;W "IsValid="_IsValid,! ^dhcbsmodule.BonusIncItemI
    
    
    q:IsValid=0 0 ;当指标无效时返回0
    
    ;w ItemType_"^"_ItemID_"^"_UnitDr,!     
    s sRate=$G(^BonusTempRate(ItemType,ItemID,UnitDr))
    ;w "sRate="_sRate_"",!
    q:sRate'="" sRate
    

    s exrate=0,mkrate=0,skrate=0
    s rowid=""
    s rowid=$o(^dhcbsmdBonusIncomeRateI("IncItemCodeSickType",ItemID,"-1",rowid))
    i rowid'=""  d
    .;W "ROWID="_rowid,!
    .s mkrate= $LI(^dhcbsmdBonusIncomeRateD(rowid),4)
    .s exrate= $LI(^dhcbsmdBonusIncomeRateD(rowid),5)
    .s skrate= $LI(^dhcbsmdBonusIncomeRateD(rowid),6)   
    
    ;W ItemType_","_mkrate,!
    i ItemType="MK" s sRate=mkrate
    i ItemType="EX" s sRate=exrate
    i ItemType="SK" s sRate=skrate
    
    q sRate
}

Storage Default
{
<StreamLocation>^dhc.bonus866B.uBonusIncEx2D37S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
