Class dhc.bonus.urbrvs.rvsModuleCalculate Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.bonus.urbrvs.rvsModuleCalculate).MainList("84","201401",0,2)
ClassMethod MainList(templateMainId, yearmonth, start, limit)
{
	
	n (templateMainId,yearmonth,start, limit)
	s ^gjtem1=start_","_limit
	;s sqlStr="SELECT * FROM dhc_bonus_rbrvs.rvsModuleCalcMain"
	s sqlStr="SELECT a.rvsModuleCalcMainID,a.calcNum,b.templateName AS rvsTemplateMainID,a.operatePerson,a.operateDate,a.CalcDesc,a.ItemPrice,a.CalcTotal  FROM dhc_bonus_rbrvs.rvsModuleCalcMain a,dhc_bonus_rbrvs.rvsTemplateMain b WHERE a.rvsTemplateMainID=b.rvsTemplateMainID"
	
	;s whereStr=" WHERE %ID>0"
	;s sqlStr=sqlStr_whereStr
	;i templateMainId'="" s sqlStr=sqlStr_" where rvsTemplateMainID ='"_templateMainId_"'"
	i templateMainId'="" 	s sqlStr=sqlStr_" and a.rvsTemplateMainID ='"_templateMainId_"'"
	;i yearmonth'="" 	s sqlStr=sqlStr_" where operateDate like '%"_yearmonth_"%'"
	i yearmonth'="" 	s sqlStr=sqlStr_" and operateDate like '%"_yearmonth_"%'"
	
	
	;w sqlStr
	;b ; 001
	s ^gjtem=sqlStr

	;w "begin....",!

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^calcNum^rvsTemplateMainID^operatePerson^operateDate^CalcDesc^ItemPrice^CalcTotal"
	;s jsonTitle="calcNum^rvsTemplateMainID^operatePerson^operateDate^CalcDesc^ItemPrice^CalcTotal"
	While(result.Next())
	{
		
	    s rvsModuleCalcMainID     =result.Data("rvsModuleCalcMainID")
	    s calcNum     =result.Data("calcNum")
	    s rvsTemplateMainID     =result.Data("rvsTemplateMainID")
	    s operatePerson     =result.Data("operatePerson")
	    s operateDate      =result.Data("operateDate")
	    s CalcDesc   =result.Data("CalcDesc")
	    s ItemPrice    =result.Data("ItemPrice")
	    s CalcTotal    =result.Data("CalcTotal")
	    
	    s tmp=rvsModuleCalcMainID_"^"_calcNum_"^"_rvsTemplateMainID_"^"_operatePerson_"^"_operateDate_"^"_CalcDesc_"^"_ItemPrice_"^"_CalcTotal
	    ;s tmp=calcNum_"^"_rvsTemplateMainID_"^"_operatePerson_"^"_operateDate_"^"_CalcDesc_"^"_ItemPrice_"^"_CalcTotal
	    
	    i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
		
	    ;w "1111",!
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.bonus.urbrvs.rvsModuleCalculate).MainInset("66^15^demo^2016-5-30^ceshi^23^1100")
ClassMethod MainInsert(data)
{
	n (data) 
	q:data="" "dataEmpt"      //准备插入的数据为空,退出并返回dataEmpt
	
	k PLIST
	
	s calcNum=$p(data,"^",1)
	i calcNum'="" s PLIST(2)=calcNum
	
	s rvsTemplateMainID=$p(data,"^",2)
	i rvsTemplateMainID'="" s PLIST(3)=rvsTemplateMainID
	
	s operatePerson=$p(data,"^",3)
	i operatePerson'="" s PLIST(4)=operatePerson
	
	s operateDate=$p(data,"^",4)
	i operateDate'="" d
	.s operateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	.s PLIST(5)=operateDate
	
	s CalcDesc=$p(data,"^",5)
	i CalcDesc'="" s PLIST(6)=CalcDesc
	
	s ItemPrice=$p(data,"^",6)
	i ItemPrice'="" s PLIST(7)=ItemPrice
	
	s CalcTotal=$p(data,"^",7)
	i CalcTotal'="" s PLIST(8)=CalcTotal
	
	
	&SQL(INSERT INTO dhc_bonus_rbrvs.rvsModuleCalcMain VALUES PLIST())
	q SQLCODE
}

/// w ##class(dhc.bonus.urbrvs.rvsModuleCalculate).MainUpdate("66^15^demo^2016-5-30^ceshi^23^1100")
ClassMethod MainUpdate(data)
{
	n (data) 
	
	q:data="" "dataEmpt"      //准备插入的数据为空,退出并返回dataEmpt
	
	k PLIST
	
	s rowid=$p(data,"^",1)
	
	s calcNum=$p(data,"^",2)
	i calcNum'="" s PLIST(2)=calcNum
	
	s rvsTemplateMainID=$p(data,"^",3)
	i rvsTemplateMainID'="" s PLIST(3)=rvsTemplateMainID
	
	s operatePerson=$p(data,"^",4)
	i operatePerson'="" s PLIST(4)=operatePerson
	
	s operateDate=$p(data,"^",5)
	i operateDate'="" d
	.s operateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	.s PLIST(5)=operateDate
	
	s CalcDesc=$p(data,"^",6)
	i CalcDesc'="" s PLIST(6)=CalcDesc
	
	s ItemPrice=$p(data,"^",7)
	i ItemPrice'="" s PLIST(7)=ItemPrice
	
	s CalcTotal=$p(data,"^",8)
	i CalcTotal'="" s PLIST(8)=CalcTotal
	
	
	&SQL(UPDATE dhc_bonus_rbrvs.rvsModuleCalcMain VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.urbrvs.rvsModuleCalculate).DetailList(0,2)
ClassMethod DetailList(start, limit, ModuleCalcDetailID)
{
	
	n (start, limit,ModuleCalcDetailID)
	s ^gjtem1=start_","_limit
	;s sqlStr="SELECT * FROM dhc_bonus_rbrvs.rvsModuleCalcDetail"
	s sqlStr="SELECT a.rvsModuleCalcDetailID,a.rvsModuleCalcMainID,a.bonusUnitID,b.SubItemCode AS bonusSubItemID,a.makeItemNum,a.makeItemScore,a.execItemNum,a.execItemScore FROM dhc_bonus_rbrvs.rvsModuleCalcDetail a,dhc_bonus_subs.BonusSubItem b WHERE a.bonusSubItemID=b.BonusSubItemID"	
	;s whereStr=" WHERE %ID>0 and rvsModuleCalcMainID="_ModuleCalcDetailID
	s whereStr=" and rvsModuleCalcMainID="_ModuleCalcDetailID
	s sqlStr=sqlStr_whereStr
	;w sqlStr
	;b ; 001
	s ^gjtem=sqlStr

	;w "begin....",!

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^rvsModuleCalcMainID^bonusUnitID^bonusSubItemID^makeItemNum^makeItemScore^execItemNum^execItemScore"
	
	While(result.Next())
	{
		
	    s rvsModuleCalcDetailID     =result.Data("rvsModuleCalcDetailID")
	    s rvsModuleCalcMainID     =result.Data("rvsModuleCalcMainID")
	    s bonusUnitID     =result.Data("bonusUnitID")
	    s bonusSubItemID     =result.Data("bonusSubItemID")
	    s makeItemNum      =result.Data("makeItemNum")
	    s makeItemScore   =result.Data("makeItemScore")
	    s execItemNum    =result.Data("execItemNum")
	    s execItemScore    =result.Data("execItemScore")
	    
	    s tmp=rvsModuleCalcDetailID_"^"_rvsModuleCalcMainID_"^"_bonusUnitID_"^"_bonusSubItemID_"^"_makeItemNum_"^"_makeItemScore_"^"_execItemNum_"^"_execItemScore
	    
	    
	    i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
		
	    ;w "1111",!
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// 测算
/// w ##class(dhc.bonus.urbrvs.rvsModuleCalculate).mainCalc("")
/// w ##class(dhc.bonus.urbrvs.rvsModuleCalculate).mainCalc("啊啊啊^2014-01-01 17:14:36^1")
ClassMethod mainCalc(data) As %String
{
	n (data)
	s rvsTemplateMainID=$p(data,"^",1)
	s operateDate=$p(data,"^",2)
	s year=$P(operateDate,"-",1)
	s month=$P(operateDate,"-",2)
	s YearMonth1=year_month
	s rvsModuleCalcMainID=$p(data,"^",3)
	s RowID=rvsModuleCalcMainID
	i rvsTemplateMainID'="" s rvsTemplateMainID=$list(^dhc.bonus62A0.rvsModuleCa2247D(rvsModuleCalcMainID),3)
	
	;b  ;11
	&SQL(INSERT INTO dhc_bonus_rbrvs.rvsModuleCalcDetail (
    rvsModuleCalcMainID, bonusUnitID, bonusSubItemID, makeItemNum, makeItemScore, execItemNum, execItemScore )
   
   SELECT  :RowID, bonusUnitID, BonusSubItemID, sum(makeItemNum) makeItemNum, makeItemScore, sum(execItemNum) execItemNum, execItemScore  FROM (
   SELECT c.rvsTemplateMainID,b.SuperiorUnitID bonusUnitID,c.BonusSubItemID ,a.TarNums makeItemNum,c.makeItemScore ,0 execItemNum,c. execItemScore
   FROM dhc_bonus_subs.workload a,dhc_bonus_data.bonusUnit b ,dhc_bonus_rbrvs.rvsTemplateDetail c
   WHERE a.PatDepDr=b.BonusUnitCode AND a.ItemCode =c.BonusSubItemID  
   AND a.YearMonth=:YearMonth1 AND c.rvsTemplateMainID =:rvsTemplateMainID
   UNION ALL
   SELECT :RowID,b.SuperiorUnitID,c.BonusSubItemID ,0 AS makeItemNum,c.makeItemScore ,a.TarNums execItemNum,c. execItemScore
   FROM dhc_bonus_subs.workload a,dhc_bonus_data.bonusUnit b ,dhc_bonus_rbrvs.rvsTemplateDetail c
   WHERE a.PatDepDr=b.BonusUnitCode AND a.ItemCode =c.BonusSubItemID  
   AND a.YearMonth=:YearMonth1 AND c.rvsTemplateMainID =:rvsTemplateMainID
   ) AS jj GROUP BY rvsTemplateMainID, bonusUnitID, BonusSubItemID,makeItemScore,execItemScore)
   ;b  ;12
   q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonusB8A5.rvsModuleCaD28BS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
