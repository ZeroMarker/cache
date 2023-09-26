Class dhc.qm.udata.uCondition Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

///  Creator: 刘小明
///  CreatDare: 2015-6-15
///  Description: 添加功能
///  Table: dhc_qm_data.Condition
///  Input: Code-条件编码，Name-条件名称，Shortcut-缩写 ，Desc-描述 ，IsActive-是否有效
///  Output: 
///  Return: 0-不重复，添加成功   rowid-记录行号，重复
///  Others: w ##class(dhc.qm.udata.uCondition).InsertRec("0003^条件三^按条件三查询")
ClassMethod InsertRec(data) As %String
{
	    n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s code=$p(data,"^",1)
		s name=$p(data,"^",2)
		s desc = $p(data,"^",3)
		
		s rowid=0
		s rowid=..IfRepCode(code)
		q:rowid>0 "RepCode"
		s rowid=..IfRepName(name)
		q:rowid>0 "RepName"
		
		s shortcut=code_"-"_name
	    s active="Y"
		
		i code'="" s PLIST(2)=code
		i name'="" s PLIST(3)=name
		i shortcut'="" s PLIST(4)=shortcut
		i desc'="" s PLIST(5)=desc
		i active'="" s PLIST(6)=active
	
		
		&sql(INSERT INTO dhc_qm_data.Condition VALUES PLIST())
		q SQLCODE
}

///  Creator: 刘小明
///  CreatDare: 2015-6-15
///  Description: 修改功能
///  Table: dhc_qm_data.Condition
///  Input: rowid-数据行号;data-待插入的数据(code^name^shortcut^desc^active);
///  Output: 
///  Return: SQLCODE
///  Others: w ##class(dhc.qm.udata.uCondition).UpdateRec("2","0002^条件二^按条件二查询")
ClassMethod UpdateRec(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s code=$p(data,"^",1)
		s name=$p(data,"^",2)
		s desc = $p(data,"^",3)
		
		s shortcut=code_"-"_name
		
		s id=0
		s id=..IfRepCode(code)
		q:(id'=0)&(id'=rowid) "RepCode"
		s id=..IfRepName(name)
		q:(id'=0)&(id'=rowid) "RepName"
	
		
		i code'="" s PLIST(2)=code
		i name'="" s PLIST(3)=name
		i shortcut'="" s PLIST(4)=shortcut
		i desc'="" s PLIST(5)=desc
		
		&SQL(UPDATE dhc_qm_data.Condition VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

///  Creator: 刘小明
///  CreatDare: 2014-11-12
///  Description: 物理删除功能
///  Table: dhc_qm_data.Condition
///  Input: RowId-行号
///  Output: 
///  Return: SQLCODE
///  Others:w ##class(dhc.qm.udata.uCondition).Delete("1")
ClassMethod Delete(RowId) As %String
{
	n (RowId)	
	
	&sql(delete from dhc_qm_data.Condition where %ID=:RowId)
	q SQLCODE
}

/// Creator: liu xiao ming
/// CreatDate: 2015-06-15
/// Description: 查询符合条件的记录
/// Table: dhc_qm_data.Condition
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.qm.udata.uCondition).ListRec("","code","2","","",0,25)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (active,searchField, searchValue, sortField, sortDir, start, limit)
		
		s sqlStr="SELECT Condition_rowid,Condition_code,Condition_name,Condition_shortcut,Condition_desc,Condition_active FROM dhc_qm_data.Condition WHERE %ID>0"
				
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="Condition_rowid"
		.i sortField="code" s sortField1="Condition_code"
		.i sortField="name" s sortField1="Condition_name"
		.i sortField="shortcut" s sortField1="Condition_shortcut"
		.i sortField="desc" s sortField1="Condition_desc"
		.i sortField="active" s sortField1="Condition_active"
			
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		e  d
		.s sortStr="ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0,num=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^code^name^shortcut^desc^active"
		;w sqlStr ,!
		While(result.Next())
		{
			s rowid=result.Data("Condition_rowid")
			s code=result.Data("Condition_code")
			s name=result.Data("Condition_name")
			s shortcut=result.Data("Condition_shortcut")
			s desc=result.Data("Condition_desc")
			s active=result.Data("Condition_active")
			
			s tmp=rowid_"^"_code_"^"_name_"^"_shortcut_"^"_desc_"^"_active
			
			i searchValue'="" d
			.q:(searchField="code")&(code'[searchValue)
			.q:(searchField="name")&(name'[searchValue)
			.q:(searchField="shortcut")&(shortcut'[searchValue)
			.q:(searchField="desc")&(desc'[searchValue)
			.q:(searchField="active")&(active'[searchValue)
			.s count=count+1
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.s count=count+1
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: 刘小明
/// CreatDate: 2015-6-15
/// Description: 判断编码是否重复
/// Table: dhc_qm_data.Condition
/// Input: Code-条件代码 
/// Output:
/// Return: 0-不重复  rowid-重复
/// Others: w ##class(dhc.qm.udata.uCondition).IfRepCode("0001")
ClassMethod IfRepCode(Code) As %String
{
	n (Code)
	s rowid=0
	s rowid=$o(^DHCCJXQMConditionI("ConditionCode",Code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 刘小明
/// CreatDate: 2015-6-15
/// Description: 判断名称是否重复
/// Table: dhc_qm_data.Condition
/// Input: Name-条件名称
/// Output:
/// Return: 0-不重复  rowid-重复
/// Others: w ##class(dhc.qm.udata.uCondition).IfRepName("条件一")
ClassMethod IfRepName(Name) As %String
{
	n (Name)
	s rowid=0
	s rowid=$o(^DHCCJXQMConditionI("ConditionName",Name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

Storage Default
{
<StreamLocation>^dhc.qm.udata.uConditionS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
