/// 标题:医院人员信息
/// 作者：Zhao LiGuo
/// 日期：2012-04-8
/// 需求：华西医院
Class dhc.bonus.report.uBonusEmpInfo Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Query GetUnit() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
select  BonusUnitID,BonusUnitName from dhc_bonus_data.BonusUnit where  UnitFlag=1 order by BonusUnitTypeID
}

/// 主报表
ClassMethod GetEmpInfoExecute(ByRef qHandle As %Binary, BonusUnitID As %String) As %Status
{
	
	n (qHandle,BonusUnitID)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

	s strSql=""
	s strSql=strSql_"select  a.BonusUnitID,a.BonusUnitID->EmployeeNo,a.BonusUnitID->SuperiorUnitID->bonusUnitName supBonusUnitName"
		_" ,a.BonusUnitID->BonusUnitName,b.CalculateTypeGroupID->CalculateGroupName,CalculateTypeName"
		_" from dhc_bonus_data.UnitCalculateType a,dhc_bonus_data.BonusCalculateType b"
		_" where a.%ID>0 and b.%ID>0 and a.CalculateTypeID= b.%ID"
		_"  and a.BonusUnitID->EmployeeNo<>''"
	i BonusUnitID'="" d
	.s strSql=strSql_" and a.BonusUnitID->SuperiorUnitID="_BonusUnitID

    ;w strSql,!	
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
			
 While(result.Next()){
      s EmployeeNo=result.Data("EmployeeNo")
      s BonusUnitName = result.Data("BonusUnitName")
      s supBonusUnitName = result.Data("supBonusUnitName")
      s CalculateGroupName=result.Data("CalculateGroupName")
      s CalculateTypeName=result.Data("CalculateTypeName")

	 d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
  	s Data=$lb(EmployeeNo,supBonusUnitName,BonusUnitName,CalculateGroupName,CalculateTypeName)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetEmpInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEmpInfoExecute ]
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

ClassMethod GetEmpInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEmpInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录 EmployeeNo,,,,
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusEmpInfo","GetEmpInfo","121")
Query GetEmpInfo(BonusUnitID As %String) As %Query(ROWSPEC = "EmployeeNo:%String,supBonusUnitName:%String,BonusUnitName:%String,CalculateGroupName:%String,CalculateTypeName:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.rep64E.uBonusEmpInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
