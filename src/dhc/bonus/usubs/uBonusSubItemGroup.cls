Class dhc.bonus.usubs.uBonusSubItemGroup Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.bonus.usubs.uBonusSubItemGroup).IfRepCode("Code1")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubItemGroup where IsValid=1 and SubItemGroupCode='"_code_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("BonusSubItemGroupID")
	}
	q rowid
}

/// w ##class(dhc.bonus.usubs.uBonusSubItemGroup).Insert("Code1^Name1")
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

	&SQL(INSERT INTO dhc_bonus_subs.BonusSubItemGroup VALUES PLIST())
	
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubItemGroup).Update(3,"Code1^Name6")
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

	&SQL(UPDATE dhc_bonus_subs.BonusSubItemGroup VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubDeptGroupMap).IfDeptExit(1,2)
ClassMethod IfExit(parRef) As %String
{
	n (parRef)
		
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubItemGroupMap WHERE %ID>0 and BonusSubItemGroupID="_parRef
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s tmpRowid=0
	While(result.Next())
	{
		s tmpRowid=result.Data("BonusSubItemGroupMapID")
	}
	
	q tmpRowid
}

/// w ##class(dhc.bonus.usubs.uBonusSubItemGroup).Del(3)
ClassMethod Del(rowid) As %String
{
	n (rowid)
	k PLIST
	s PLIST(4)=0
	s tmpR=..IfExit(rowid)
	q:tmpR'=0 "exit"
	&SQL(UPDATE dhc_bonus_subs.BonusSubItemGroup VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubItemGroup).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit)
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubItemGroup"
	s whereStr=" WHERE %ID>0 and IsValid=1 "

	s sortStr=""		
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField_" ASC"
	e  d
	.s sortStr=" ORDER BY BonusSubItemGroupID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="BonusSubItemGroupID^SubItemGroupCode^SubItemGroupName^IsValid"
	
	While(result.Next())
	{
		s BonusSubItemGroupID=result.Data("BonusSubItemGroupID")
		s SubItemGroupCode=result.Data("SubItemGroupCode")
		s SubItemGroupName=result.Data("SubItemGroupName")
		s IsValid=result.Data("IsValid")
	
		s tmp=BonusSubItemGroupID_"^"_SubItemGroupCode_"^"_SubItemGroupName_"^"_IsValid
		
		i searchValue'="" d
		.q:(searchField="BonusSubItemGroupID")&(BonusSubItemGroupID'[searchValue)
		.q:(searchField="SubItemGroupCode")&(SubItemGroupCode'[searchValue)
		.q:(searchField="SubItemGroupName")&(SubItemGroupName'[searchValue)
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

/// w ##class(dhc.bonus.usubs.uBonusSubItemGroup).ListBoth("","","","",0,25,1,"310")
ClassMethod ListBoth(searchField, searchValue, sortField, sortDir, start, limit, type, str)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, type,str)
	
	s sqlStr2="SELECT * FROM dhc_bonus_subs.BonusSubItem"
	s whereStr2=" WHERE %ID>0 and LastStage=1 and IsValid=1"
	i str'="" d
	.s whereStr2=whereStr2 _" and (SubItemCode like '%"_str_"%' or SubItemName like '%"_str_"%')"
	
	;i type=1 d
	;.s whereStr2=whereStr2_" and SubItemType = 2 "
	;e  d
	;.s whereStr2=whereStr2_" and SubItemType in (2,3) "
	;s sortStr2=" ORDER BY BonusSubItemID DESC"
	
	s sqlStr2=sqlStr2_whereStr2
	s result2=##class(%Library.ResultSet).%New()
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	d result2.Prepare(sqlStr2)
	d result2.Execute()
	s jsonTitle="ItemID^ItemName"
	d json.InsertRowData("0^全部")
	s count=0
	s resultString=""
	s end=start+limit-1
	While(result2.Next())
	{
		s BonusSubDeptGroupMapID="D"_result2.Data("BonusSubItemID")
		s BonusUnitName=result2.Data("SubItemName")
		s tmp=BonusSubDeptGroupMapID_"^"_BonusUnitName
		
		i searchValue'="" d
		.q:(searchField="BonusSubItemID")&(BonusSubDeptGroupMapID'[searchValue)
		.q:(searchField="SubItemName")&(BonusUnit'[searchValue)
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
<StreamLocation>^dhc.bonus.u5E4.uBonusSubIte742S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
