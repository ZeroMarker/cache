Class dhc.bonus.usubs.uBonusSubDeptGroup Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroup).IfRepCode(code1)
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubDeptGroup where IsValid=1 and DeptGroupCode='"_code_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("BonusSubDeptGroupID")
	}
	q rowid
}

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroup).Insert("Code1^Name1^1")
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
	
	s Type=$p(data,"^",3)
	s PLIST(4)=Type
	
	s PLIST(5)="1"

	&SQL(INSERT INTO dhc_bonus_subs.BonusSubDeptGroup VALUES PLIST())
	
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroup).Update(2,"Code1^Name6^")
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
	
	s Type=$p(data,"^",3)
	i Type'="" s PLIST(4)=Type
	
	&SQL(UPDATE dhc_bonus_subs.BonusSubDeptGroup VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroupMap).IfDeptExit(1,2)
ClassMethod IfExit(parRef) As %String
{
	n (parRef)
		
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubDeptGroupMap WHERE %ID>0 and BonusDeptGroupID="_parRef
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

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroup).Del(3)
ClassMethod Del(rowid) As %String
{
	n (rowid)
	k PLIST
	s PLIST(5)=0
	s tmpR=..IfExit(rowid)
	q:tmpR'=0 "exit"
	&SQL(UPDATE dhc_bonus_subs.BonusSubDeptGroup VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroup).List("","","code","ASC",0,25,"")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, type)
{
	n (searchField, searchValue, sortField, sortDir, start, limit,type)
	
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubDeptGroup"
	s whereStr=" WHERE %ID>0 and IsValid=1 "
	i type'="" d
	.s whereStr=whereStr_" and DeptGroupType="_type

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
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="BonusSubDeptGroupID^DeptGroupCode^DeptGroupName^DeptGroupType^IsValid"
	
	While(result.Next())
	{
		s BonusSubDeptGroupID=result.Data("BonusSubDeptGroupID")
		s DeptGroupCode=result.Data("DeptGroupCode")
		s DeptGroupName=result.Data("DeptGroupName")
		s DeptGroupType=result.Data("DeptGroupType")
		s IsValid=result.Data("IsValid")
	
		s tmp=BonusSubDeptGroupID_"^"_DeptGroupCode_"^"_DeptGroupName_"^"_DeptGroupType_"^"_IsValid
		
		i searchValue'="" d
		.q:(searchField="rowid")&(BonusSubDeptGroupID'[searchValue)
		.q:(searchField="code")&(DeptGroupCode'[searchValue)
		.q:(searchField="name")&(DeptGroupName'[searchValue)
		.q:(searchField="type")&(DeptGroupType'[searchValue)
		.q:(searchField="isValid")&(IsValid'[searchValue)
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

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroup).ListBoth("","","","",0,25)
ClassMethod ListBoth(searchField, searchValue, sortField, sortDir, start, limit)
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	////////////////////////////////////////////////////////////////
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubDeptGroup"
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
	s jsonTitle="DeptID^DeptName"
	d json.InsertRowData("0^全部")
	While(result.Next())
	{
		s BonusSubDeptGroupID="G"_result.Data("BonusSubDeptGroupID")
		s DeptGroupName=result.Data("DeptGroupName")
		
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
	s whereStr2=" WHERE %ID>0 and LastStage=1 and UnitFlag=1 and IsValid=1"
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
		.q:(searchField="BonusUnit")&(BonusSubDeptGroupMapID'[searchValue)
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
<StreamLocation>^dhc.bonus.u5E4.uBonusSubDep740S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
