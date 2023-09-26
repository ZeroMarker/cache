Class dhc.bonus.urbrvs.rvsSubsWorkLoad Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 20116-05-24 guojing
/// 查询   加载数据	
/// w ##class(dhc.bonus.urbrvs.rvsSubsWorkLoad).List("","","","",0,10)	
ClassMethod List(cnfield, PatDepDr, RecDepDr, yearMonth, start, limit)
{
	n (cnfield,PatDepDr,RecDepDr,yearMonth,start, limit)
	//n (start, limit)
	s ^gjtem1=cnfield_","_PatDepDr_","_RecDepDr_","_yearMonth_","_ start_","_limit
	;s sqlStr="SELECT ItemCode, ItemName , PatDepDr, RecDepDr, TarNums , UpdateDate,YearMonth FROM dhc_bonus_subs.workload"
	;s sqlStr="SELECT a.ItemCode, a.ItemName , c.BonusUnitName AS PatDepDr, b.BonusUnitName AS RecDepDr, a.TarNums , a.UpdateDate,a.YearMonth FROM dhc_bonus_subs.workload a,dhc_bonus_data.bonusUnit b,dhc_bonus_data.bonusUnit c WHERE a.RecDepDr = b.BonusUnitID AND a.PatDepDr =c.BonusUnitID"
	s sqlStr="SELECT a.ItemCode, a.ItemName , c.BonusUnitName AS PatDepDr, b.BonusUnitName AS RecDepDr,"
	_" a.TarNums , a.UpdateDate,a.YearMonth"
	_" FROM dhc_bonus_subs.workload a,dhc_bonus_data.bonusUnit b,dhc_bonus_data.bonusUnit c"
	_" WHERE a.RecDepDr = b.BonusUnitCode AND a.PatDepDr =c.BonusUnitCode"
	;w sqlStr
	;s whereStr=" WHERE %ID>0"
	;s sqlStr=sqlStr_whereStr
	i cnfield'="" 	s sqlStr=sqlStr_" and ItemCode||ItemName like '%"_cnfield_"%'"
	i PatDepDr'=""	 s sqlStr=sqlStr_" and PatDepDr ='"_PatDepDr_"'"
	i RecDepDr'=""	 s sqlStr=sqlStr_" and RecDepDr ='"_RecDepDr_"'"
	i yearMonth'=""	 s sqlStr=sqlStr_" and YearMonth ='"_yearMonth_"'"
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
	s jsonTitle="ItemCode^ItemName^PatDepDr^RecDepDr^TarNums^UpdateDate^YearMonth"
	While(result.Next())
	{
		
	    s ItemCode     =result.Data("ItemCode")
	    s ItemName     =result.Data("ItemName")
	    s PatDepDr     =result.Data("PatDepDr")
	    s RecDepDr     =result.Data("RecDepDr")
	    s TarNums      =result.Data("TarNums")
	    i TarNums'="" d
	    .s TarNums=$fn(TarNums,"",2)

	    s UpdateDate   =result.Data("UpdateDate")
	    s YearMonth    =result.Data("YearMonth")
	   
	    
	    
	    s tmp=ItemCode_"^"_ItemName_"^"_PatDepDr_"^"_RecDepDr_"^"_TarNums_"^"_UpdateDate_"^"_YearMonth
	   // w count_","_start_","_end,!
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

/// 20116-05-24 guojing
/// 获取科室
/// w ##class(dhc.bonus.rbrvs.rvsSubsWorkLoad).GetBonusUnit(0,5)
ClassMethod GetBonusUnit(start, limit)
{
	n (start, limit)
	;s ^gjtem1=start_","_limit
	s result=##class(%Library.ResultSet).%New()
	s sqlStr="SELECT BonusUnitID,BonusUnitName FROM dhc_bonus_data.bonusUnit"
	s whereStr=" WHERE %ID>0"
	s sqlStr=sqlStr_whereStr
	;w sqlStr
	;b ; 001
	;s ^gjtem=sqlStr

	;w "begin....",!
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="BonusUnitID^BonusUnitName"
	While(result.Next())
	{
		s BonusUnitID    =result.Data("BonusUnitID")
	    s BonusUnitName       =result.Data("BonusUnitName")
	    s tmp=BonusUnitID_"^"_BonusUnitName
	    s count=count+1
	    i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		
		
	    ;w "1111",!
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonusB8A5.rvsSubsWorkDE69S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
