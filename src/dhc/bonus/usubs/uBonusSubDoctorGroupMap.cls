Class dhc.bonus.usubs.uBonusSubDoctorGroupMap Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroupMap).IfExit(1,2)
ClassMethod IfExit(parRef, rowid) As %String
{
	n (parRef,rowid)
		
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubDoctorGroupMap WHERE %ID>0 and BonusSubDoctorGroupID="_parRef_" and BonusUnitID="_rowid
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s tmpRowid=0
	While(result.Next())
	{
		s tmpRowid=result.Data("BonusSubDoctorGroupMapID")
	}
	
	q tmpRowid
}

/// w ##class(dhc.bonus.usubs.uBonusSubDoctorGroupMap).Insert("1^1")
ClassMethod Insert(data) As %String
{
	n (data)
	q:data="" "dataEmpty"
	
	k PLIST
	
	s BonusDoctorGroupID=$p(data,"^",1)
	s PLIST(2)=BonusDoctorGroupID
	
	s BonusUnit=$p(data,"^",2)
	s PLIST(3)=BonusUnit
	
	s flag=..IfExit(BonusDoctorGroupID,BonusUnit)
	q:flag>0 "rep"

	
	&SQL(INSERT INTO dhc_bonus_subs.BonusSubDoctorGroupMap VALUES PLIST())
	
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubDoctorGroupMap).Update(2,"1^6")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	k PLIST
	q:rowid="" "rowidEmpty"
	q:data="" "dataEmpty"
	
	s BonusDoctorGroupID=$p(data,"^",1)             
	i BonusDoctorGroupID'="" s PLIST(2)=BonusDoctorGroupID
	
	s BonusUnit=$p(data,"^",2)
	i BonusUnit'="" s PLIST(3)=BonusUnit
	
	s flag=..IfExit(BonusDoctorGroupID,BonusUnit)
	q:(flag'=0)&&(flag'=rowid) "rep"
	
	&SQL(UPDATE dhc_bonus_subs.BonusSubDoctorGroupMap VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubDoctorGroupMap).Del(2)
ClassMethod Del(rowid) As %String
{
	n (rowid)

	&SQL(delete from dhc_bonus_subs.BonusSubDoctorGroupMap where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubDoctorGroupMap).List("","","","",0,25,1)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	n (searchField, searchValue, sortField, sortDir, start, limit,parRef)
	
	s sqlStr="SELECT *, BonusUnitID->BonusUnitCode ,BonusUnitID->BonusUnitName, BonusUnitID->BonusUnitTypeID, BonusUnitID->BonusUnitTypeID->UnitTypeName FROM dhc_bonus_subs.BonusSubDoctorGroupMap"
	s whereStr=" WHERE %ID>0 and BonusSubDoctorGroupID="_parRef
	
	s sortStr=""		
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField_" ASC"
	e  d
	.s sortStr=" ORDER BY BonusSubDoctorGroupMapID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="BonusSubDoctorGroupMapID^BonusSubDoctorGroupID^BonusUnitID^BonusUnitCode^BonusUnitName^BonusUnitTypeID^UnitTypeName"
	
	While(result.Next())
	{
		s BonusSubDoctorGroupMapID=result.Data("BonusSubDoctorGroupMapID")
		s BonusSubDoctorGroupID=result.Data("BonusSubDoctorGroupID")
		s BonusUnitID=result.Data("BonusUnitID")
		s BonusUnitCode=result.Data("BonusUnitCode")
		s BonusUnitName=result.Data("BonusUnitName")
		s BonusUnitTypeID=result.Data("BonusUnitTypeID")
		s UnitTypeName=result.Data("UnitTypeName")
		
		s tmp=BonusSubDoctorGroupMapID_"^"_BonusSubDoctorGroupID_"^"_BonusUnitID_"^"_BonusUnitCode_"^"_BonusUnitName_"^"_BonusUnitTypeID_"^"_UnitTypeName
		
		i searchValue'="" d
		.q:(searchField="BonusSubDoctorGroupMapID")&(BonusSubDoctorGroupMapID'[searchValue)
		.q:(searchField="BonusSubDoctorGroupID")&(BonusSubDoctorGroupID'[searchValue)
		.q:(searchField="BonusUnitID")&(BonusUnit'[searchValue)
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

/// w ##class(dhc.bonus.usubs.uBonusSubDoctorGroupMap).ListUnit("","","","",0,25)
ClassMethod ListUnit(searchField, searchValue, sortField, sortDir, start, limit, type)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, type)
	
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusUnit"
	s whereStr=" WHERE %ID>0 and IsValid=1 and UnitFlag= 3 and LastStage=1 and BonusUnitTypeID="_type
	s sortStr=" ORDER BY BonusUnitID DESC"
	
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
<StreamLocation>^dhc.bonus.u5E4.uBonusSubDoc93CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
