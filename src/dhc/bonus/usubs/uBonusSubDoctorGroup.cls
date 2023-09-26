Class dhc.bonus.usubs.uBonusSubDoctorGroup Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.bonus.usubs.uBonusSubDoctorGroup).IfRepCode("Code1")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubDoctorGroup where IsValid=1 and DoctorGroupCode='"_code_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("BonusSubDoctorGroupID")
	}
	q rowid
}

/// w ##class(dhc.bonus.usubs.uBonusSubDoctorGroup).Insert("Code1^Name1")
ClassMethod Insert(data) As %String
{
	n (data)
	q:data="" "dataEmpty"
	
	k PLIST
	
	s Code=$p(data,"^",1)
	s tmpDr=..IfRepCode(Code)
	q:tmpDr'=0 "repCode"     
	s PLIST(2)=Code
	
	s Name=$p(data,"^",2)
	s PLIST(3)=Name

	s PLIST(4)="1"

	&SQL(INSERT INTO dhc_bonus_subs.BonusSubDoctorGroup VALUES PLIST())
	
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubDoctorGroup).Update(2,"Code1^Name6")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	k PLIST
	q:rowid="" "rowidEmpty"
	q:data="" "dataEmpty"
	
	s Code=$p(data,"^",1)    
	s tmpDr=..IfRepCode(Code)
	q:(tmpDr'=0)&&(tmpDr'=rowid) "repCode"               
	i Code'="" s PLIST(2)=Code
	
	s Name=$p(data,"^",2)
	i Name'="" s PLIST(3)=Name

	&SQL(UPDATE dhc_bonus_subs.BonusSubDoctorGroup VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroupMap).IfDeptExit(1,2)
ClassMethod IfExit(parRef) As %String
{
	n (parRef)
		
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubDoctorGroupMap WHERE %ID>0 and BonusSubDoctorGroupID="_parRef
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

/// w ##class(dhc.bonus.usubs.uBonusSubDoctorGroup).Del(3)
ClassMethod Del(rowid) As %String
{
	n (rowid)
	k PLIST
	s PLIST(4)=0
	s tmpR=..IfExit(rowid)
	q:tmpR'=0 "exit"
	&SQL(UPDATE dhc_bonus_subs.BonusSubDoctorGroup VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubDoctorGroup).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit)
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubDoctorGroup"
	s whereStr=" WHERE %ID>0 and IsValid=1 "

	s sortStr=""		
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField_" ASC"
	e  d
	.s sortStr=" ORDER BY BonusSubDoctorGroupID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="BonusSubDoctorGroupID^DoctorGroupCode^DoctorGroupName^IsValid"
	
	While(result.Next())
	{
		s BonusSubDoctorGroupID=result.Data("BonusSubDoctorGroupID")
		s DoctorGroupCode=result.Data("DoctorGroupCode")
		s DoctorGroupName=result.Data("DoctorGroupName")
		s IsValid=result.Data("IsValid")
	
		s tmp=BonusSubDoctorGroupID_"^"_DoctorGroupCode_"^"_DoctorGroupName_"^"_IsValid
		
		i searchValue'="" d
		.q:(searchField="BonusSubDoctorGroupID")&(BonusSubDoctorGroupID'[searchValue)
		.q:(searchField="DoctorGroupCode")&(DoctorGroupCode'[searchValue)
		.q:(searchField="DoctorGroupName")&(DoctorGroupName'[searchValue)
		.q:(searchField="IsValid")&(IsValid'[searchValue)
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

/// w ##class(dhc.bonus.usubs.uBonusSubDoctorGroup).ListBoth("","","","",0,25)
ClassMethod ListBoth(searchField, searchValue, sortField, sortDir, start, limit)
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	////////////////////////////////////////////////////////////////
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubDoctorGroup"
	s whereStr=" WHERE %ID>0 and IsValid=1 "

	s sortStr=""		
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	//w sqlStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=1
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="DoctorID^DoctorName"
	d json.InsertRowData("0^全部")
	While(result.Next())
	{
		s BonusSubDeptGroupID="G"_result.Data("BonusSubDoctorGroupID")
		s DeptGroupName=result.Data("DoctorGroupName")
		
		s tmp=BonusSubDeptGroupID_"^"_DeptGroupName
		
		i searchValue'="" d
		.q:(searchField="rowid")&(BonusSubDeptGroupID'[searchValue)
		.q:(searchField="name")&(DeptGroupName'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	
	d result.Close()
	
	/////////////////////////////////////////////
	s sqlStr2="SELECT * FROM dhc_bonus_data.BonusUnit "
	s whereStr2=" WHERE %ID>0 and LastStage=1 and UnitFlag=3 and IsValid=1"
	s sortStr2=" ORDER BY BonusUnitID DESC"
	s sqlStr2=sqlStr2_whereStr2_sortStr2
	s result2=##class(%Library.ResultSet).%New()
	d result2.Prepare(sqlStr2)
	d result2.Execute()
	
	While(result2.Next())
	{
		s BonusSubDeptGroupMapID="D"_result2.Data("BonusUnitID")
		s BonusUnitName=result2.Data("BonusUnitName")

		s tmp=BonusSubDeptGroupMapID_"^"_BonusUnitName
		
		i searchValue'="" d
		.q:(searchField="BonusUnitID")&(BonusSubDeptGroupMapID'[searchValue)
		.q:(searchField="BonusUnit")&(BonusUnit'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	
	d result2.Close()
	
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5E4.uBonusSubDoc81ES</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
