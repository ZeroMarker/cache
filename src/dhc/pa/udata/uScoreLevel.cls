Class dhc.pa.udata.uScoreLevel Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2011-04-28
/// Description: 查询符合条件的记录
/// Table: dhc_pa_data.ScoreLevel
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uScoreLevel).ListRec("Y","","","","",0,25)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (active,searchField, searchValue, sortField, sortDir, start, limit)
		
		s sqlStr="SELECT ScoreLevel_Rowid,ScoreLevel_Code,ScoreLevel_Name,ScoreLevel_Score,ScoreLevel_ShortCut,ScoreLevel_Py,ScoreLevel_Active FROM dhc_pa_data.ScoreLevel WHERE %ID>0"
				
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="ScoreLevel_Rowid"
		.i sortField="sorce" s sortField1="ScoreLevel_Score"
		.i sortField="code" s sortField1="ScoreLevel_Code"
		.i sortField="name" s sortField1="ScoreLevel_Name"
		.i sortField="shortcut" s sortField1="ScoreLevel_ShortCut"
		.i sortField="py" s sortField1="ScoreLevel_Py"
		.i sortField="active" s sortField1="ScoreLevel_Active"
			
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
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^sorce^code^name^shortcut^py^active"
		
		While(result.Next())
		{
			s rowid=result.Data("ScoreLevel_Rowid")
			s score = result.Data("ScoreLevel_Score")
			s code=result.Data("ScoreLevel_Code")
			s name=result.Data("ScoreLevel_Name")
			s shortcut=result.Data("ScoreLevel_ShortCut")
			s py=result.Data("ScoreLevel_Py")
			s active=result.Data("ScoreLevel_Active")
			
			s tmp=rowid_"^"_score_"^"_code_"^"_name_"^"_shortcut_"^"_py_"^"_active
			s count=count+1
			i searchValue'="" d
			.q:(searchField="code")&(code'[searchValue)
			.q:(searchField="name")&(name'[searchValue)
			.q:(searchField="score")&(score'[searchValue)
			.q:(searchField="shortcut")&(shortcut'[searchValue)
			.q:(searchField="py")&(py'[searchValue)
			.q:(searchField="active")&(active'[searchValue)
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: wang ying
/// CreatDate:  2011-04-28
/// Description: 插入新记录
/// Table: dhc_pa_data.ScoreLevel
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uScoreLevel).InsertRec("01^优^you^95")
ClassMethod InsertRec(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s code=$p(data,"^",1)
		s name=$p(data,"^",2)
		s py = $p(data,"^",3)
		s sorce= $p(data,"^",4)
		
		s rowid=0
		s rowid=..IfRepCode(code)
		q:rowid>0 "RepCode"
		;s rowid=..IfRepName(name)
		;q:rowid>0 "RepName"
		
		s shortcut=code_"-"_name
	    s active="Y"
		
		i sorce'="" s PLIST(2)=sorce
		i code'="" s PLIST(3)=code
		i name'="" s PLIST(4)=name
		i shortcut'="" s PLIST(5)=shortcut
		i py'="" s PLIST(6)=py
		i active'="" s PLIST(7)=active
	
		
		&sql(INSERT INTO dhc_pa_data.ScoreLevel VALUES PLIST())
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2011-04-28
/// Description: 更新记录
/// Table: dhc_pa_data.ScoreLevel
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uScoreLevel).UpdateRec(1,"01^优^you^90^Y")
ClassMethod UpdateRec(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s code=$p(data,"^",1)
		s name=$p(data,"^",2)
		s py = $p(data,"^",3)
		s sorce= $p(data,"^",4)
		s active=$p(data,"^",5)
		s shortcut=code_"-"_name
		
		s id=0
		s id=..IfRepCode(code)
		q:(id'=0)&(id'=rowid) "RepCode"
		s id=..IfRepName(name)
		q:(id'=0)&(id'=rowid) "RepName"
	
		
	     s PLIST(2)=sorce
		 s PLIST(3)=code
		 s PLIST(4)=name
		 s PLIST(5)=shortcut
		 s PLIST(6)=py
		 s PLIST(7)=active
		
		&SQL(UPDATE dhc_pa_data.ScoreLevel VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2011-04-28
/// Description: 代码是否存在
/// Table: dhc_pa_data.ScoreLevel
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.nca.app.appAAccCycle).IfRepCode("201006")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCJXPASCORELEVEL(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: wang ying
/// CreatDate: 2011-04-28
/// Description: 名称是否存在
/// Table: dhc_pa_data.ScoreLevel
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.nca.app.appAAccCycle).IfRepName("工资费用")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCJXPASCORELEVEL(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: wang ying
/// CreatDate: 2010-8-5
/// Description: 删除分组记录
/// Table：dhc_pa_data.JXGroup
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.pa.udata.uScoreLevel).Delete(1)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_pa_data.ScoreLevel WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uScoreLevelS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
