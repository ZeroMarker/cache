Class dhc.bonus.report.uEmpWorkDays Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 主报表
ClassMethod GetEmpWorkDaysExecute(ByRef qHandle As %Binary, sDate As %String) As %Status
{
	
	n (qHandle,sDate)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    //s userCode="register"
    ;k ^zlgtemp
	;s ^zlgtemp="zlg1="_rptCode_":"_ sDate_":"_userCode
	;q:rptCode="" $$$OK
 	q:sDate="" $$$OK
	;q:userCode="" $$$OK
	s smonth=sDate

    ;s yearMoth= $p(sDate,"-",1) _"M"_$p(sDate,"-",2)
    ;s syear=$p(sDate,"-",1) _"年"_$p(sDate,"-",2)_"月"
  
	s strSql=""
	_ " select EmpWorkDaysID,SuperiorUnitID->SuperiorUnitID->BonusUnitName deptname,SuperiorUnitID->BonusUnitName groupName ,BonusUnitCode ,BonusUnitName, "
	_"  bbchuqin,dychuqin,xychuqin,bbjiari,dyjiari,xyjiari,jiejia,bingshijia "
	_"  from dhc_bonus_data.EmpWorkDays a "
	_"  join dhc_bonus_data.BonusUnit b on upper(a.loginname) = upper(b.BonusUnitCode) "
	_"  where month = '"_sDate_"' and IsValid = '1' "
	_" union all "
    _" select ''EmpWorkDaysID,SuperiorUnitID->SuperiorUnitID->BonusUnitName deptname,SuperiorUnitID->BonusUnitName groupName , "
    _" BonusUnitCode ,BonusUnitName,''bbchuqin,''dychuqin,''xychuqin,''bbjiari,''dyjiari,''xyjiari,''jiejia,''bingshijia "
    _" from dhc_bonus_data.BonusUnit "
    _" where upper(BonusUnitCode) not in(select upper(loginname) from dhc_bonus_data.EmpWorkDays where month ='"_sDate_"') "
    _" and UnitFlag='3' and IsValid = '1' "
	;_"  order by SuperiorUnitID->SuperiorUnitID->BonusUnitCode,SuperiorUnitID->BonusUnitCode ASC"

	//k ^zlgtemp
	//s ^zlgtemp=strSql
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
		
 While(result.Next()){
	  
	  s RowNo=result.Data("EmpWorkDaysID")
	  s deptname=result.Data("deptname")
      s groupName=result.Data("groupName")
      s UnitCode =result.Data("BonusUnitCode")
      s UnitName = result.Data("BonusUnitName")
      
      s psbaibam=result.Data("bbchuqin")
      s psdaye=result.Data("dychuqin")
      s psxiaoye =result.Data("xychuqin")
      s jrbaiban = result.Data("bbjiari")
      s jrdaye=result.Data("dyjiari")
      s jrxiaoye=result.Data("xyjiari")
      s fdjiari =result.Data("jiejia")
      s bingshijia = result.Data("bingshijia")
     
	 d OutputRow3
	  
	} 
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(RowNo,deptname,groupName,UnitCode,UnitName,psbaibam,psdaye,psxiaoye,jrbaiban,jrdaye,jrxiaoye,fdjiari,bingshijia,smonth)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetEmpWorkDaysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEmpWorkDaysExecute ]
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

ClassMethod GetEmpWorkDaysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEmpWorkDaysExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmpWorkDays","GetEmpWorkDays","2013-06") 
Query GetEmpWorkDays(sDate As %String) As %Query(ROWSPEC = "RowNo:%Integer,deptname:%String,groupname:%String,UnitCode:%String,UnitName:%String,psbaiban:%String,psdaye:%String,psxiaoye:%String,jrbaiban:%String,jrdaye:%String,jrxiaoye:%String,fdjiari:%String,bingshijia:%String,smonth:%String") [ SqlProc ]
{
}

/*
Query GetYear() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select * from sqlUser.CT_Loc
}
*/
Storage Default
{
<StreamLocation>^dhc.bonus.report.uEmpWorkDaysS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
