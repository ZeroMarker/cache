Class dhc.bonus.umodule.uWorkItemType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Weijiangtao
/// CreatDate: 2015-04-14
/// Description: 查询符合条件的记录
/// Table: dhc.bonus.module.WorkItemType
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.umodule.uWorkItemType).ListRec("","","","","",0,2)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (active,searchField, searchValue, sortField, sortDir, start, limit)
		
		s sqlStr="SELECT WorkItemTypeID,ItemTypeCode,ItemTypeName FROM dhc_bonus_module.WorkItemType WHERE %ID>0"
				
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="WorkItemTypeID"
		.i sortField="code" s sortField1="ItemTypeCode"
		.i sortField="name" s sortField1="ItemTypeName"
		
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		e  d
		.s sortStr=" ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		;s ^hhhh=searchValue
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.bonus.comm.JsonObj).%New()
		s jsonTitle="rowid^code^name"
		
		While(result.Next())
		{
			s rowid=result.Data("WorkItemTypeID")
			s code=result.Data("ItemTypeCode")
			s name=result.Data("ItemTypeName")
			
			
			s tmp=rowid_"^"_code_"^"_name
			s count=count+1
			i searchValue'="" d
			.q:(searchField="code")&(code'[searchValue)
			.q:(searchField="name")&(name'[searchValue)
			
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			.
			e  d
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: weijiangtao
/// CreatDate:  2015-04-14
/// Description: 插入新记录
/// Table: dhc.bonus.module.WorkItemType
/// Input: data-待插入的数据(code^name)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.bonus.umodule.uWorkItemType).InsertRec("01^小样")
ClassMethod InsertRec(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s code=$p(data,"^",1)
		s name=$p(data,"^",2)
		
		s rowid=0
		s rowid=..IfRepCode(code)
		q:rowid>0 "RepCode"
		s rowid=..IfRepName(name)
		q:rowid>0 "RepName"
		
		i code'="" s PLIST(2)=code
		i name'="" s PLIST(3)=name
	
		
		&sql(INSERT INTO dhc_bonus_module.WorkItemType VALUES PLIST())
		q SQLCODE
}

/// Creator: weijiangtao
/// CreatDate: 2015-04-14
/// Description: 更新记录
/// Table: dhc.bonus.module.WorkItemType
/// Input: rowid-数据行号;data-待插入的数据(code^name);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.bonus.umodule.uWorkItemType).UpdateRec(3,"01^小样")
ClassMethod UpdateRec(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s code=$p(data,"^",1)
		s name=$p(data,"^",2)
		
		s id=0
		s id=..IfRepCode(code)
		q:(id'=0)&(id'=rowid) "RepCode"
		s id=..IfRepName(name)
		q:(id'=0)&(id'=rowid) "RepName"
	
		
		i code'="" s PLIST(2)=code
		i name'="" s PLIST(3)=name
		
		&SQL(UPDATE dhc_bonus_module.WorkItemType VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

/// Creator: weijiangtao
/// CreatDate: 2015-04-14
/// Description: 代码是否存在
/// Table: dhc.bonus.module.WorkItemType
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.bonus.umodule.uWorkItemType).IfRepCode("201006")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCItemTypeCode(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: weijiangtao
/// CreatDate: 2015-04-14
/// Description: 名称是否存在
/// Table: dhc.bonus.module.WorkItemType
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.bonus.umodule.uWorkItemType).IfRepName("小样")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCItemTypeName(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator:weijiangtao
/// CreatDate:2015-04-14
/// Description:删除数据
/// Table:dhc.bonus.module.WorkItemType
/// Input:rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.bonus.umodule.uWorkItemType).Delete(2)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM dhc_bonus_module.WorkItemType WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.um866B.uWorkItemTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
