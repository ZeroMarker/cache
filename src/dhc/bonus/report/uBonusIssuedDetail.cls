/// 标题:科室人员奖金调整上报
/// 作者：Zhao LiGuo
/// 日期：2012-03-31
/// 需求：华西医院
Class dhc.bonus.report.uBonusIssuedDetail Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 获取科室登陆人员有权限的科室
/// ------------得到核算单元信息--------------------------------------
/// Creator:赵立国
/// CreatDate:2012-3-31
/// Description:查询核算单元信息
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusIssuedMain","getUnit","fhq")
Query getUnit(sUserCode As %String) As %Query(ROWSPEC = "unitID:%String,unitName:%String") [ SqlProc ]
{
}

ClassMethod getUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getUnitExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:zhao liguo
/// CreatDate:2012-3-31
/// Description:查询科室人员的奖金发放情况
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusIssuedMain","getUnitExecute","2011","M","M02","1")
ClassMethod getUnitExecute(ByRef qHandle As %Binary, sUserCode As %String) As %Status
{
	
	//n (bYear, bPeroidType, bPeroid, bUnitID)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	s result = ##class(%Library.ResultSet).%New()

	s sqlStr = "select a.BonusUnitID,a.BonusUnitName"
	s sqlStr = sqlStr_" from dhc_bonus_data.BonusUnit a ,dhc_bonus_data.BonusEmployeeUnit b ,dhc_bonus_data.BonusEmployee c"
	s sqlStr = sqlStr_"  where a.BonusUnitID = b.BonusUnitID and b.BonusEmployeeID=c.BonusEmployeeID "
	s sqlStr = sqlStr_"  and upper(c.EmployeeCode)=upper('"_sUserCode_"')"


	//w sqlStr,!  
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s bonusUnitID = result.Data("BonusUnitID")
		s bonusUnitName = result.Data("BonusUnitName")
		d OutputUnits
	}

    q $$$OK
OutputUnits
    s Data=$lb(bonusUnitID,bonusUnitName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
	d result.Close()
}

/// 主报表
ClassMethod DeptIssuedDetailExecute(ByRef qHandle As %Binary, usercode As %String, sDate As %String, BonusUnitID As %String, DataStatus As %Integer) As %Status
{
	
	n (qHandle,sDate,BonusUnitID,DataStatus,usercode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	;s DataStatus=2
	
	;k ^zlgtemp
	;s ^zlgtemp=sDate_"^"_BonusUnitID_"^"_DataStatus_"^"_usercode
	
 	q:sDate="" $$$OK
	;q:BonusUnitID="" $$$OK
  
    s BonusYear =$p(sDate,"-",1)
    s BonusPeriod ="M" _ $p(sDate,"-",2)
	s strSql=""
	s strSql=strSql_" select b.BonusYear,b.BonusPeriod,b.SuperiorUnitID->BonusUnitCode subUnitCode,"
	_"b.BonusUnitID->BonusUnitTypeID->UnitTypeName,b.SuperiorUnitID->BonusUnitName supBonusUnitName,b.BonusUnitName,b.SchemeItemID->SchemeItemName"
		_" ,b.BonusUnitCode EmployeeNo"
		_" ,sum(b.IssuedBonus) IssuedBonus,sum(b.AdjustBonus) AdjustBonus,sum(b.ResultBonus) ResultBonus"
		_" from dhc_bonus_data.BonusIssuedMain a ,dhc_bonus_data.BonusIssuedDetail b,dhc_bonus_data.BonusEmployeeUnit c"
		_" where  b.ResultBonus>0 and b.SuperiorUnitID= c.BonusUnitID"
		_" and upper(c.BonusEmployeeID->EmployeeCode)=upper('"_usercode_"')"
		_" and a.BonusYear=b.BonusYear and  a.BonusPeriod = b.BonusPeriod "
		_" and a.BonusUnitID=b.SuperiorUnitID and a.SchemeItemID= b.SchemeItemID"
		_" and b.BonusYear ='"_BonusYear_"' and b.BonusPeriod ='"_BonusPeriod_"'"
	i BonusUnitID'="" d
	.s strSql=strSql_" and b.SuperiorUnitID = '"_BonusUnitID_"'"

	i DataStatus'="" d
	.s strSql=strSql_" and a.DataStatus="_DataStatus
	
	s strSql=strSql_" group by b.BonusYear,b.BonusPeriod,b.SuperiorUnitID->BonusUnitCode  ,b.BonusUnitID->BonusUnitTypeID->UnitTypeName,b.BonusUnitName  ,b.SchemeItemID->SchemeItemName"

	;s ^zlgtemp=strSql
	k ^zlgtemp
	s ^zlgtemp=strSql
    ;w strSql,!	
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
			
 While(result.Next()){
      s ItemName=result.Data("SchemeItemName")
      s EmployeeNo = result.Data("EmployeeNo")
      s BonusUnitName = result.Data("BonusUnitName")
      s supBonusUnitName = result.Data("supBonusUnitName")
      s subUnitCode =  result.Data("subUnitCode")
      s UnitTypeName= result.Data("UnitTypeName")
      
      s BonusYear=result.Data("BonusYear")
      s BonusPeriod=result.Data("BonusPeriod")
      s IssuedBonus=$fn(result.Data("IssuedBonus"),"",2)
      s AdjustBonus=$fn(result.Data("AdjustBonus"),"",2)
      s ResultBonus=$fn(result.Data("ResultBonus"),"",2)
      
      /// IssuedBonus,AdjustBonus,b. ResultBonus
	  s YearMonthName=BonusYear_"年"_$E(BonusPeriod,2,3)_"月"
	  //w ItemName_":"_BonusUnitName,!
	 d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
  	s Data=$lb(subUnitCode,supBonusUnitName,ItemName,EmployeeNo,UnitTypeName,BonusUnitName,IssuedBonus,AdjustBonus,ResultBonus,YearMonthName)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod DeptIssuedDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptIssuedDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DeptIssuedDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptIssuedDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusIssuedDetail","DeptIssuedDetail","a0063","2013-04","","2")
Query DeptIssuedDetail(usercode As %String, sDate As %String, BonusUnitID As %String, DataStatus As %Integer) As %Query(ROWSPEC = "subUnitCode:%String,supBonusUnitName:%String,ItemName:%String,EmployeeNo:%String,UnitTypeName:%String,BonusUnitName:%String,IssuedBonus:%Float,AdjustBonus:%Float,ResultBonus:%Float,YearMonthName:%String") [ SqlProc ]
{
}

/// 主报表
ClassMethod DeptIssuedDetailExExecute(ByRef qHandle As %Binary, usercode As %String, sDate As %String, BonusUnitID As %String, DataStatus As %Integer) As %Status
{
	
	n (qHandle,sDate,BonusUnitID,DataStatus,usercode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
   // k ^tem
   // s ^tem= usercode
    ;s usercode="fhq"
	
 	q:sDate="" $$$OK
	;q:BonusUnitID="" $$$OK
  
    s BonusYear =$p(sDate,"-",1)
    s BonusPeriod ="M" _ $p(sDate,"-",2)
	s strSql=""
	s strSql=strSql_" select b.BonusYear,b.BonusPeriod,b.SuperiorUnitID->BonusUnitCode subUnitCode,b.SuperiorUnitID->BonusUnitName supBonusUnitName,b.BonusUnitName,b.SchemeItemID->SchemeItemName"
		_" ,b.BonusUnitCode EmployeeNo,b.IssuedBonus,b.AdjustBonus,b.ResultBonus,CalculateTypeID->CalculateTypeName cTypeName,isnull(CalculateTypeID->CalculateTypeGroupID->CalculateGroupName,'其他属性') cGroupName"
		_" ,CalculateTypeID->CalculateTypeGroupID,b.SchemeItemID "
		_" from dhc_bonus_data.BonusIssuedMain a ,dhc_bonus_data.BonusIssuedDetail b,dhc_bonus_data.BonusEmployeeUnit c,dhc_bonus_data.UnitCalculateType d"
		_" where  b.ResultBonus>0 and b.SuperiorUnitID= c.BonusUnitID and b.BonusUnitID=*d.BonusUnitID "
		_" and upper(c.BonusEmployeeID->EmployeeCode)=upper('"_usercode_"')"
		_" and a.BonusYear=b.BonusYear and  a.BonusPeriod = b.BonusPeriod "
		_" and a.BonusUnitID=b.SuperiorUnitID and a.SchemeItemID= b.SchemeItemID"
		_" and b.BonusYear ='"_BonusYear_"' and b.BonusPeriod ='"_BonusPeriod_"'"
		_" and CalculateTypeID->CalculateTypeGroupID=13 "
		
	i BonusUnitID'="" d
	.s strSql=strSql_" and b.SuperiorUnitID = '"_BonusUnitID_"'"

	i DataStatus'="" d
	.s strSql=strSql_" and a.DataStatus="_DataStatus

	s strSql=strSql_"  Order by CalculateTypeID->CalculateTypeName"
   ;; w strSql,!	
   ;s ^zlgtemp =strSql
   
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
			
 While(result.Next()){
      s ItemName=result.Data("SchemeItemName")
      s EmployeeNo = result.Data("EmployeeNo")
      s BonusUnitName = result.Data("BonusUnitName")
      s supBonusUnitName = result.Data("supBonusUnitName")
      s subUnitCode =  result.Data("subUnitCode")
      s cGroupName=  result.Data("cGroupName")
       s cTypeName=  result.Data("cTypeName")
      
      s BonusYear=result.Data("BonusYear")
      s BonusPeriod=result.Data("BonusPeriod")
      s IssuedBonus=$fn(result.Data("IssuedBonus"),"",2)
      s AdjustBonus=$fn(result.Data("AdjustBonus"),"",2)
      s ResultBonus=$fn(result.Data("ResultBonus"),"",2)
      
      /// IssuedBonus,AdjustBonus,b. ResultBonus cGroupName, cTypeName
	  s YearMonthName=BonusYear_"年"_$E(BonusPeriod,2,3)_"月"
	  //w ItemName_":"_BonusUnitName,!
	 d OutputRow29
	  
	} 
   	  
  	q $$$OK
OutputRow29
  	s Data=$lb(subUnitCode,supBonusUnitName,ItemName,EmployeeNo,BonusUnitName,IssuedBonus,AdjustBonus,ResultBonus,YearMonthName,cGroupName,cTypeName)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod DeptIssuedDetailExFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptIssuedDetailExExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DeptIssuedDetailExClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptIssuedDetailExExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusIssuedDetail","DeptIssuedDetailEx","fhq","2012-01","208","")
Query DeptIssuedDetailEx(usercode As %String, sDate As %String, BonusUnitID As %String, DataStatus As %Integer) As %Query(ROWSPEC = "subUnitCode:%String,supBonusUnitName:%String,ItemName:%String,EmployeeNo:%String,BonusUnitName:%String,IssuedBonus:%Float,AdjustBonus:%Float,ResultBonus:%Float,YearMonthName:%String,cGroupName:%String,cTypeName:%String") [ SqlProc ]
{
}

//科室实发奖金占比分析

/// 主报表
ClassMethod DeptIssuedRateExecute(ByRef qHandle As %Binary, sDate As %String) As %Status
{
	
	n (qHandle,sDate)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
		
 	q:sDate="" $$$OK

  
    s BonusYear =$p(sDate,"-",1)
    s BonusPeriod ="M" _ $p(sDate,"-",2)
    /*
	s strSql="select SuperiorUnitID->SuperiorUnitID->BonusUnitName supUnitName,SupUnitName UnitName,Sum(ResultBonus) svalue"
 		_" from  dhc_bonus_data.BonusIssuedDetail "
 		_" where BonusYear='"_BonusYear_"' and BonusPeriod='"_BonusPeriod_"' and ResultBonus>0"
		_" group by SupUnitName,SuperiorUnitID->SuperiorUnitID->BonusUnitName"

	*/	
	
	s strSql=" select supUnitName,UnitName,sum(svalue1) svalue1,sum(svalue2) svalue2,sum(svalue3) svalue3 from ( "
	        _" select SuperiorUnitID->SuperiorUnitID->BonusUnitName supUnitName,SupUnitName UnitName, " 
	        _" Sum(ResultBonus) svalue1,0 svalue2,0 svalue3 "
	        _" from  dhc_bonus_data.BonusIssuedDetail "
	        _" where BonusYear='"_BonusYear_"' and BonusPeriod='"_BonusPeriod_"' and ResultBonus>0 "
	        _" group by SupUnitName,SuperiorUnitID->SuperiorUnitID->BonusUnitName "
	        _" union all "
	        _" select BonusUnitID->SuperiorUnitID->BonusUnitName supUnitName,BonusUnitID->BonusUnitName UnitName, "
	        _" 0 svalue1,TargetValue svalue2,0 svalue3 "
	        _" from dhc_bonus_data.BonusTargetCollect "
	        _" where BonusYear='"_BonusYear_"' and BonusPeriod='"_BonusPeriod_"' "
	        _" and BonusTargetID->BonusTargetCode ='011400' "
	        _" union all "
	        _" select BonusUnitID->SuperiorUnitID->BonusUnitName supUnitName,BonusUnitID->BonusUnitName UnitName, "
	        _" 0 svalue1,0 svalue2,TargetValue svalue3 "
	        _" from dhc_bonus_data.BonusTargetCollect "
	        _" where BonusYear='"_BonusYear_"' and BonusPeriod='"_BonusPeriod_"' "
	        _" and BonusTargetID->BonusTargetCode ='011500' "
	        _" ) group by supUnitName,UnitName "
	        _" order by supUnitName,UnitName "

    ;w strSql,!	
   ;s ^zlgtemp =strSql
   
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
			
 While(result.Next()){
      s supUnitName=result.Data("supUnitName")
      s UnitName = result.Data("UnitName")
      s svalue1=$fn(result.Data("svalue1"),"",2)
      s svalue2=$fn(result.Data("svalue2"),"",2)
      s svalue3=$fn(result.Data("svalue3"),"",2)

	  s YearMonth=BonusYear_"年"_$E(BonusPeriod,2,3)_"月"
	  //w ItemName_":"_BonusUnitName,!
	 d OutputRow2
	  
	} 
   	  
  	q $$$OK
OutputRow2
  	s Data=$lb(supUnitName,UnitName,svalue1,svalue2,svalue3,YearMonth)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod DeptIssuedRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptIssuedRateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DeptIssuedRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptIssuedRateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusIssuedDetail","DeptIssuedRate","fhq","2012-01","208","")
Query DeptIssuedRate(sDate As %String) As %Query(ROWSPEC = "supUnitName:%String,UnitName:%String,svalue1:%Float,svalue2:%Float,svalue3:%Float,YearMonth:%String") [ SqlProc ]
{
}

//科室实发奖金排序

/// 主报表
ClassMethod DeptIssuedSortExecute(ByRef qHandle As %Binary, sDate As %String) As %Status
{
	
	n (qHandle,sDate)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
		
	w sDate,!		
 	q:sDate="" $$$OK

  
    s BonusYear =$p(sDate,"-",1)
    s BonusPeriod ="M" _ $p(sDate,"-",2)
   
    
	/*s strSql="select * from( "
		_" select SuperiorUnitID->SuperiorUnitID->BonusUnitName supUnitName,SupUnitName UnitName,Sum(ResultBonus) svalue"
 		_" from  dhc_bonus_data.BonusIssuedDetail "
 		_" where BonusYear='"_BonusYear_"' and BonusPeriod='"_BonusPeriod_"' and ResultBonus>0"
		_" group by SupUnitName,SuperiorUnitID->SuperiorUnitID->BonusUnitName"
		_" ) where UnitName is not null order by svalue Desc "
	*/	
		
	s strSql=" select BonusUnitID->BonusUnitCode,BonusUnitID->BonusUnitName,BonusValue "
		_" from dhc_bonus_data.UnitBonusDetail"
		_" WHERE  BonusSchemeItemID->BonusItemTypeID=3 and BonusValue>0"
		_" and BonusYear='"_BonusYear_"' and BonusPeriod='"_BonusPeriod_"'"
		_" order by BonusValue desc"
	
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
	s idx=0		
 While(result.Next()){
      s supUnitName=result.Data("BonusUnitCode")
      s UnitName = result.Data("BonusUnitName")
      s svalue=$fn(result.Data("BonusValue"),"",2)
      s idx=idx+1

	  s YearMonth=BonusYear_"年"_$E(BonusPeriod,2,3)_"月"
	  //w ItemName_":"_BonusUnitName,!
	 d OutputRow3
	  
	} 
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(supUnitName,UnitName,svalue,YearMonth,idx)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod DeptIssuedSortFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptIssuedSortExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DeptIssuedSortClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptIssuedSortExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusIssuedDetail","DeptIssuedSort","2014-01")
Query DeptIssuedSort(sDate As %String) As %Query(ROWSPEC = "supUnitName:%String,UnitName:%String,svalue:%Float,YearMonth:%String,idx:%Integer") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uBonusIssued73CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
