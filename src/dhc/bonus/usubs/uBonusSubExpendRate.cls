/// Class dhc.bonus.usubs.uBonusSubExpendRate Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
Class dhc.bonus.usubs.uBonusSubExpendRate Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.bonus.usubs.uBonusSubExpendRate).Insert("G1^G11^qwe^0.7")
ClassMethod Insert(data) As %String
{
	n (data)
	q:data="" "dataEmpty"
	
	k PLIST
	/***
	20140926为修改问题“支出工作量系数-修改除核算科室之外的任意一项，
	保存后，核算科室为空”，修改s BonusUnit=$p(data,"^",6)为
	s BonusUnit=$p(data,"^",1)
	***/
	
	s BonusUnit=$p(data,"^",1)
	i BonusUnit'="" s PLIST(2)=BonusUnit
	
	s BonusSubItem=$p(data,"^",2)
	i BonusSubItem'="" s PLIST(3)=BonusSubItem

	s CalculateUnit=$p(data,"^",3)
	i CalculateUnit'="" s PLIST(4)=CalculateUnit
	
	s CalculateRate=$p(data,"^",4)
	i CalculateRate'="" s PLIST(5)=CalculateRate
	
	s ExecuteRate=$p(data,"^",5)
	i ExecuteRate'="" s PLIST(6)=ExecuteRate
	
	&SQL(INSERT INTO dhc_bonus_subs.BonusSubExpendRate VALUES PLIST())
	
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubExpendRate).Update(2,"1^1^1^1^1^1^7^8^9^10^11^12^13")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	k PLIST
	q:rowid="" "rowidEmpty"
	q:data="" "dataEmpty"
	
	s BonusUnit=$p(data,"^",1)
	i BonusUnit'="" s PLIST(2)=BonusUnit
	
	s BonusSubItem=$p(data,"^",2)
	i BonusSubItem'="" s PLIST(3)=BonusSubItem

	s CalculateUnit=$p(data,"^",3)
	i CalculateUnit'="" s PLIST(4)=CalculateUnit
	
	s CalculateRate=$p(data,"^",4)
	i CalculateRate'="" s PLIST(5)=CalculateRate
	
	s ExecuteRate=$p(data,"^",5)
	i ExecuteRate'="" s PLIST(6)=ExecuteRate
	
	&SQL(UPDATE dhc_bonus_subs.BonusSubExpendRate VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubExpendRate).Del(2)
ClassMethod Del(rowid) As %String
{
	n (rowid)
	&SQL(delete from dhc_bonus_subs.BonusSubExpendRate where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubExpendRate).getDept("G2")
ClassMethod getDept(rowid) As %String
{

	n (rowid)
	s name=""
	i (rowid'="")&&($p(rowid,"G",2)'="") d
	. s tmpDr=$p(rowid,"G",2)
	. s name = $list(^dhcbsSubDeptGroupD(tmpDr),3)
	i (rowid'="")&&($p(rowid,"D",2)'="")  d
	. s tmpDrMap=$p(rowid,"D",2)
	.; s tmpDr = $list(^dhcbsSubDeptGroupMapD(tmpDrMap),3)
	.i $g(^dhcbsBonusUnitD(tmpDrMap))'="" d
	..s name = $list(^dhcbsBonusUnitD(tmpDrMap),3)
	i rowid=0  d
	.s name="全部"
	q name
}

/// w ##class(dhc.bonus.usubs.uBonusSubExpendRate).List("","","","",0,25,"^")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, filter)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, filter)
	
	s tmp1=$p(filter,"^",1)
	s tmp2=$p(filter,"^",2)

	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubExpendRate"
	s whereStr=" WHERE %ID>0 "
	i (tmp1'="")&(tmp1'=0) d
	.s whereStr=whereStr_" and BonusUnit='"_tmp1_"'"
	i tmp2'="" d
	.s whereStr=whereStr_" and BonusSubItem='"_tmp2_"'"

	s sortStr=""		
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField_" ASC"
	e  d
	.s sortStr=" ORDER BY BonusSubExpendRateID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="BonusSubExpendRateID^BonusUnit^BonusSubItem^CalculateUnit^CalculateRate^BonusUnitName^BonusSubItemName^CalculateUnitName^ExecuteRate"
	
	While(result.Next())
	{
		s BonusSubExpendRateID=result.Data("BonusSubExpendRateID")
		s BonusUnit= result.Data("BonusUnit")
		s BonusUnitName=..getDept(BonusUnit)
		s BonusSubItem=result.Data("BonusSubItem")
		s BonusSubItemName=""
		i (BonusSubItem'="")&&($p(BonusSubItem,"G",2)'="") d
		. s tmpDr=$p(BonusSubItem,"G",2)
		. s BonusSubItemName = $list(^dhcbsSubItemGroupD(tmpDr),4)
		e  i (BonusSubItem'="")&&($p(BonusSubItem,"D",2)'="")  d
		. s tmpDr=$p(BonusSubItem,"D",2)
		.; s tmpMap=$list(^dhcbsSubItemGroupMapD(tmpDr),3)
		. s BonusSubItemName = $list(^dhcbsSubItemD(tmpDr),3)
		e  d
		.s BonusSubItemName = "全部"
		s CalculateUnit=result.Data("CalculateUnit")
		s CalculateUnitName=$list(^dhcbsCalUnitD(CalculateUnit),3)
		s CalculateRate=result.Data("CalculateRate")
		s ExecuteRate = result.Data("ExecuteRate")
		s tmp=BonusSubExpendRateID_"^"_BonusUnit_"^"_BonusSubItem_"^"_CalculateUnit_"^"_CalculateRate_"^"_BonusUnitName_"^"_BonusSubItemName_"^"_CalculateUnitName_"^"_ExecuteRate
		
		i searchValue'="" d
		.q:(searchField="BonusSubExpendRateID")&(BonusSubExpendRateID'[searchValue)
		.q:(searchField="BonusUnit")&(BonusUnit'[searchValue)
		.q:(searchField="BonusSubItem")&(BonusSubItem'[searchValue)
		.q:(searchField="CalculateUnit")&(CalculateUnit'[searchValue)
		.q:(searchField="CalculateRate")&(CalculateRate'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5E4.uBonusSubExp796S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
