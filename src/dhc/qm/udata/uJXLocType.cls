Class dhc.qm.udata.uJXLocType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

///  Creator: 刘小明
///  CreatDare: 2015-6-15
///  Description: 添加功能
///  Table: dhc_qm_data.JXLocType
///  Input: Code-条件编码，Name-条件名称，Shortcut-缩写 ，Desc-描述 ，IsActive-是否有效
///  Output: 
///  Return: 0-不重复，添加成功   rowid-记录行号，重复
///  Others: w ##class(dhc.qm.udata.uJXLocType).InsertRec("0002^科室分类一^按科室一分类")
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
		i desc'="" s PLIST(4)=desc
		i active'="" s PLIST(5)=active
	
		
		&sql(INSERT INTO dhc_qm_data.JXLocType VALUES PLIST())
		q SQLCODE
}

///  Creator: 刘小明
///  CreatDare: 2015-6-15
///  Description: 修改功能
///  Table: dhc_qm_data.JXLocType
///  Input: rowid-数据行号;data-待插入的数据(code^name^shortcut^desc^active);
///  Output: 
///  Return: SQLCODE
///  Others: w ##class(dhc.qm.udata.uJXLocType).UpdateRec("2","0002^科室分类二^按科室二分类")
ClassMethod UpdateRec(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s code=$p(data,"^",1)
		s name=$p(data,"^",2)
		s desc = $p(data,"^",3)
				
		s id=0
		s id=..IfRepCode(code)
		q:(id'=0)&(id'=rowid) "RepCode"
		s id=..IfRepName(name)
		q:(id'=0)&(id'=rowid) "RepName"
	
		
		i code'="" s PLIST(2)=code
		i name'="" s PLIST(3)=name
		i desc'="" s PLIST(4)=desc
		
		&SQL(UPDATE dhc_qm_data.JXLocType VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

///  Creator: 刘小明
///  CreatDare: 2014-11-12
///  Description: 物理删除功能
///  Table: dhc_qm_data.JXLocType
///  Input: RowId-行号
///  Output: 
///  Return: SQLCODE
///  Others:w ##class(dhc.qm.udata.uJXLocType).Delete("1")
ClassMethod Delete(RowId) As %String
{
	n (RowId)	
	
	&sql(delete from dhc_qm_data.JXLocType where %ID=:RowId)
	q SQLCODE
}

/// Creator: liu xiao ming
/// CreatDate: 2015-06-15
/// Description: 查询符合条件的记录
/// Table: dhc_qm_data.JXLocType
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.qm.udata.uJXLocType).ListRec("","code","2","","",0,25)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (active,searchField, searchValue, sortField, sortDir, start, limit)
		
		s sqlStr="SELECT JXLocType_rowid,JXLocType_code,JXLocType_name,JXLocType_desc,JXLocType_active FROM dhc_qm_data.JXLocType WHERE %ID>0"
				
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="JXLocType_rowid"
		.i sortField="code" s sortField1="JXLocType_code"
		.i sortField="name" s sortField1="JXLocType_name"
		.i sortField="desc" s sortField1="JXLocType_desc"
		.i sortField="active" s sortField1="JXLocType_active"
			
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
		s jsonTitle="rowid^code^name^desc^active"
		;w sqlStr ,!
		While(result.Next())
		{
			s rowid=result.Data("JXLocType_rowid")
			s code=result.Data("JXLocType_code")
			s name=result.Data("JXLocType_name")
			s desc=result.Data("JXLocType_desc")
			s active=result.Data("JXLocType_active")
			
			s tmp=rowid_"^"_code_"^"_name_"^"_desc_"^"_active
			
			i searchValue'="" d
			.q:(searchField="code")&(code'[searchValue)
			.q:(searchField="name")&(name'[searchValue)
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
/// Table: dhc_qm_data.JXLocType
/// Input: Code-条件代码 
/// Output:
/// Return: 0-不重复  rowid-重复
/// Others: w ##class(dhc.qm.udata.uJXLocType).IfRepCode("0002")
ClassMethod IfRepCode(Code) As %String
{
	n (Code)
	s rowid=0
	s rowid=$o(^DHCCJXQMJXLocTypeI("JXLocTypeCode",Code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 刘小明
/// CreatDate: 2015-6-15
/// Description: 判断名称是否重复
/// Table: dhc_qm_data.JXLocType
/// Input: Name-条件名称
/// Output:
/// Return: 0-不重复  rowid-重复
/// Others: w ##class(dhc.qm.udata.uJXLocType).IsRepName("")
ClassMethod IfRepName(Name) As %String
{
	n (Name)
	s rowid=0
	s rowid=$o(^DHCCJXQMJXLocTypeI("JXLocTypeName",Name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

Storage Default
{
<StreamLocation>^dhc.qm.udata.uJXLocTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
