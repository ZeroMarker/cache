Class dhc.bonus.usubs.uBonusSubItemGroupMap Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.bonus.usubs.uBonusSubItemGroupMap).IfExit(1,2)
ClassMethod IfExit(parRef, rowid) As %String
{
	n (parRef,rowid)
		
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubItemGroupMap WHERE %ID>0 and BonusSubItemGroupID ="_parRef_" and BonusSubItemID ="_rowid
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

/// w ##class(dhc.bonus.usubs.uBonusSubItemGroupMap).Insert("1^1")
ClassMethod Insert(data) As %String
{
	n (data)
	q:data="" "dataEmpty"
	
	k PLIST
	
	s BonusItemGroupID=$p(data,"^",2)
	s PLIST(2)=BonusItemGroupID
	
	s BonusUnit=$p(data,"^",1)
	s PLIST(3)=BonusUnit
	
	s flag=..IfExit(BonusUnit,BonusItemGroupID)
	q:flag>0 "rep"
	
	&SQL(INSERT INTO dhc_bonus_subs.BonusSubItemGroupMap VALUES PLIST())
	
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubItemGroupMap).Update(2,"1^6")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	k PLIST
	q:rowid="" "rowidEmpty"
	q:data="" "dataEmpty"
	
	s BonusItemGroupID=$p(data,"^",2)             
	i BonusItemGroupID'="" s PLIST(2)=BonusItemGroupID
	
	s BonusUnit=$p(data,"^",1)
	i BonusUnit'="" s PLIST(3)=BonusUnit
	
	s flag=..IfExit(BonusUnit,BonusItemGroupID)
	q:(flag'=0)&&(flag'=rowid) "rep"
	
	&SQL(UPDATE dhc_bonus_subs.BonusSubItemGroupMap VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubItemGroupMap).Del(2)
ClassMethod Del(rowid) As %String
{
	n (rowid)

	&SQL(delete from dhc_bonus_subs.BonusSubItemGroupMap where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubItemGroupMap).List("","","","",0,25,1)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, parRef)
	
	s sqlStr="SELECT *, BonusSubItemID->SubItemCode ,BonusSubItemID->SubItemName, BonusSubItemID->SubItemType FROM dhc_bonus_subs.BonusSubItemGroupMap"
	s whereStr=" WHERE %ID>0 and BonusSubItemGroupID="_parRef
	
	s sortStr=""		
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField_" ASC"
	e  d
	.s sortStr=" ORDER BY BonusSubItemGroupMapID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="BonusSubItemGroupMapID^BonusSubItemGroupID^BonusSubItemID^SubItemCode^SubItemName^SubItemType^SubItemTypeName"
	
	While(result.Next())
	{
		s BonusSubItemGroupMapID=result.Data("BonusSubItemGroupMapID")
		s BonusSubItemGroupID=result.Data("BonusSubItemGroupID")
		s BonusSubItemID=result.Data("BonusSubItemID")
		s SubItemCode=result.Data("SubItemCode")
		s SubItemName=result.Data("SubItemName")
		s SubItemType=result.Data("SubItemType")
		s SubItemTypeName=""
		i SubItemType=1 s SubItemTypeName="收入"
		i SubItemType=2 s SubItemTypeName="工作量"
		i SubItemType=3 s SubItemTypeName="支出"

		s tmp=BonusSubItemGroupMapID_"^"_BonusSubItemGroupID_"^"_BonusSubItemID_"^"_SubItemCode_"^"_SubItemName_"^"_SubItemType_"^"_SubItemTypeName
		
		i searchValue'="" d
		.q:(searchField="rowid")&(BonusSubItemGroupMapID'[searchValue)
		.q:(searchField="BonusSubItemGroupID")&(BonusSubItemGroupID'[searchValue)
		.q:(searchField="BonusSubItemID")&(BonusSubItemID'[searchValue)
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

/// w ##class(dhc.bonus.usubs.uBonusSubItemGroupMap).ListItemType("","","","",0,25)
ClassMethod ListItemType(searchField, searchValue, sortField, sortDir, start, limit)
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusItemType"
	s whereStr=" WHERE %ID>0 and IsValid=1"
	s sortStr=" ORDER BY BonusItemTypeID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	While(result.Next())
	{
		s rowid=result.Data("BonusItemTypeID")
		s name=result.Data("BonusItemTypeName")

		s tmp=rowid_"^"_name
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.bonus.usubs.uBonusSubItemGroupMap).ListItem("","","","",0,25,"2","3115")
ClassMethod ListItem(searchField, searchValue, sortField, sortDir, start, limit, type, str)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, type,str)
	
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubItem"
	_" WHERE %ID>0 and IsValid=1 and LastStage=1 and SubItemType="_type
	i str'="" d
	.s sqlStr=sqlStr_ " and SubItemCode like '%"_str_"%' or SubItemName like '%"_str_"%'"
	s sortStr=" ORDER BY BonusSubItemID DESC"
	s sqlStr=sqlStr_sortStr

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="BonusSubItemID^SubItemCode^SubItemName"
	
	While(result.Next())
	{
		s BonusUnitID=result.Data("BonusSubItemID")
		s BonusUnitCode=result.Data("SubItemCode")
		s BonusUnitName=result.Data("SubItemName")

		s tmp=BonusUnitID_"^"_BonusUnitCode_"^"_BonusUnitCode_"_"_BonusUnitName
		
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
<StreamLocation>^dhc.bonus.u5E4.uBonusSubIte860S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
