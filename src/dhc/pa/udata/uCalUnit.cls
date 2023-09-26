Class dhc.pa.udata.uCalUnit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-07-14
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Param
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uCalUnit).ListRec("","code","2","","",0,25)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (active,searchField, searchValue, sortField, sortDir, start, limit)
		
		s sqlStr="SELECT CalUnit_rowid,CalUnit_code,CalUnit_name,CalUnit_shortcut,CalUnit_desc,CalUnit_active FROM dhc_pa_data.CalUnit WHERE %ID>0"
				
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="CalUnit_rowid"
		.i sortField="code" s sortField1="CalUnit_code"
		.i sortField="name" s sortField1="CalUnit_name"
		.i sortField="shortcut" s sortField1="CalUnit_shortcut"
		.i sortField="desc" s sortField1="CalUnit_desc"
		.i sortField="active" s sortField1="CalUnit_active"
			
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
			s rowid=result.Data("CalUnit_rowid")
			s code=result.Data("CalUnit_code")
			s name=result.Data("CalUnit_name")
			s shortcut=result.Data("CalUnit_shortcut")
			s desc=result.Data("CalUnit_desc")
			s active=result.Data("CalUnit_active")
			
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

/// Creator: wang ying
/// CreatDate:  2010-07-14
/// Description: 插入新记录
/// Table: dhc.pa.data.CalUnit
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uCalUnit).InsertRec("01^个^个数")
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
	
		
		&sql(INSERT INTO dhc_pa_data.CalUnit VALUES PLIST())
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2010-07-14
/// Description: 更新记录
/// Table: dhc.pa.data.Cycle
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uCalUnit).UpdateRec(1,"01^个^数")
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
		
		&SQL(UPDATE dhc_pa_data.CalUnit VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2010-07-14
/// Description: 代码是否存在
/// Table: dhc.pa.data.CalUnit
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.nca.app.appAAccCycle).IfRepCode("201006")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCJXPACALUNIT(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: wang ying
/// CreatDate: 2010-07-14
/// Description: 名称是否存在
/// Table: dhc.pa.data.CalUnit
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.nca.app.appAAccCycle).IfRepName("工资费用")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCJXPACALUNIT(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uCalUnitS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
