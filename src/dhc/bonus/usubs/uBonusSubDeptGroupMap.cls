Class dhc.bonus.usubs.uBonusSubDeptGroupMap Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroupMap).IfDeptExit(1,2)
ClassMethod IfDeptExit(parRef, rowid) As %String
{
	n (parRef,rowid)
		
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubDeptGroupMap WHERE %ID>0 and BonusDeptGroupID="_parRef_" and BonusUnit="_rowid
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s tmpRowid=0
	While(result.Next())
	{
		s tmpRowid=result.Data("BonusSubDeptGroupMapID")
	}
	
	q tmpRowid
}

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroupMap).Insert("1^2")
ClassMethod Insert(data) As %String
{
	n (data)
	q:data="" "dataEmpty"
	
	k PLIST
	
	s BonusDeptGroupID=$p(data,"^",1)
	s PLIST(2)=BonusDeptGroupID
	
	s BonusUnit=$p(data,"^",2)
	s PLIST(3)=BonusUnit
	
	s flag=..IfDeptExit(BonusDeptGroupID,BonusUnit)
	q:flag>0 "rep"
	
	&SQL(INSERT INTO dhc_bonus_subs.BonusSubDeptGroupMap VALUES PLIST())
	
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroupMap).Update(2,"1^6")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	k PLIST
	q:rowid="" "rowidEmpty"
	q:data="" "dataEmpty"
	
	s BonusDeptGroupID=$p(data,"^",1)             
	i BonusDeptGroupID'="" s PLIST(2)=BonusDeptGroupID
	
	s BonusUnit=$p(data,"^",2)
	i BonusUnit'="" s PLIST(3)=BonusUnit
	
	s flag=..IfDeptExit(BonusDeptGroupID,BonusUnit)
	q:(flag'=0)&&(flag'=rowid) "rep"
	
	&SQL(UPDATE dhc_bonus_subs.BonusSubDeptGroupMap VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroupMap).Del(2)
ClassMethod Del(rowid) As %String
{
	n (rowid)

	&SQL(delete from dhc_bonus_subs.BonusSubDeptGroupMap where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroupMap).List("","","","",0,25,1)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	n (searchField, searchValue, sortField, sortDir, start, limit,parRef)
	
	s sqlStr="SELECT *, BonusUnit->BonusUnitCode ,BonusUnit->BonusUnitName,BonusUnit->BonusUnitTypeID, BonusUnit->BonusUnitTypeID->UnitTypeName FROM dhc_bonus_subs.BonusSubDeptGroupMap"
	s whereStr=" WHERE %ID>0 and BonusDeptGroupID="_parRef
	
	s sortStr=""		
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField_" ASC"
	e  d
	.s sortStr=" ORDER BY BonusSubDeptGroupMapID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	;w sqlStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="BonusSubDeptGroupMapID^BonusDeptGroupID^BonusUnit^BonusUnitCode^BonusUnitName^BonusUnitTypeID^UnitTypeName"
	
	While(result.Next())
	{
		s BonusSubDeptGroupMapID=result.Data("BonusSubDeptGroupMapID")
		s BonusDeptGroupID=result.Data("BonusDeptGroupID")
		s BonusUnit=result.Data("BonusUnit")
		s BonusUnitCode=result.Data("BonusUnitCode")
		s BonusUnitName=result.Data("BonusUnitName")
		s BonusUnitTypeID=result.Data("BonusUnitTypeID")
		s UnitTypeName=result.Data("UnitTypeName")

		s tmp=BonusSubDeptGroupMapID_"^"_BonusDeptGroupID_"^"_BonusUnit_"^"_BonusUnitCode_"^"_BonusUnitName_"^"_BonusUnitTypeID_"^"_UnitTypeName
		
		i searchValue'="" d
		.q:(searchField="BonusSubDeptGroupMapID")&(BonusSubDeptGroupMapID'[searchValue)
		.q:(searchField="BonusDeptGroupID")&(BonusDeptGroupID'[searchValue)
		.q:(searchField="BonusUnit")&(BonusUnit'[searchValue)
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

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroupMap).ListUnit("","","","",0,25,13)
ClassMethod ListUnit(searchField, searchValue, sortField, sortDir, start, limit, type)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, type)
	
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusUnit"
	s whereStr=" WHERE %ID>0 and IsValid=1 and UnitFlag=1  and BonusUnitTypeID="_type
	s sortStr=" ORDER BY BonusUnitCode "
	 
	s sqlStr=sqlStr_whereStr_sortStr

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="BonusUnitID^BonusUnitCode^BonusUnitName"
	
	While(result.Next())
	{
		s BonusUnitID=result.Data("BonusUnitID")
		s BonusUnitCode=result.Data("BonusUnitCode")
		s BonusUnitName=result.Data("BonusUnitName")

		s tmp=BonusUnitID_"^"_BonusUnitCode_"^"_BonusUnitName
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5E4.uBonusSubDep85ES</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
