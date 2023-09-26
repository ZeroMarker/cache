Class dhc.bonus.module.WorkItem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others: w ##class(dhc.bonus.module.WorkItem).List("","","","",0,25,"医保")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, str)
{
	n (searchField, searchValue, sortField, sortDir, start, limit,str)
	
	s sqlStr="SELECT BonusWorkItemID,WorkItemTypeID,WorkItemCode,WorkItemName FROM dhc_bonus_module.BonusWorkItem"
	
	s whereStr=" WHERE %ID>0 and IsValid=1"
	i str'="" s whereStr = whereStr_" and WorkItemName like '%"_str_"%'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="code" s sortField1="WorkItemCode"
	.i sortField="name" s sortField1="WorkItemName"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY BonusWorkItemID"

	
	
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^type^code^name"
	
	While(result.Next())
	{
		s rowid=result.Data("BonusWorkItemID")
		s type=result.Data("WorkItemTypeID")
		s code=result.Data("WorkItemCode")
		s name=result.Data("WorkItemName")
		
		s tmp=rowid_"^"_type_"^"_code_"^"_name
		
		i searchValue'="" d
		.q:(searchField="rowid")&(rowid'[searchValue)
		.q:(searchField="type")&(type'[searchValue)
		.q:(searchField="code")&(code'[searchValue)
		.q:(searchField="name")&(name'[searchValue)
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

Storage Default
{
<StreamLocation>^dhc.bonus.module.WorkItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
