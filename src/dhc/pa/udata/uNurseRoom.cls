/// 病区字典
Class dhc.pa.udata.uNurseRoom Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:  刘洋
/// CreatDate: 2011-12-12
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.DNRRoom
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uNurseRoom).List("","","","","0","25")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (searchField, searchValue, sortField, sortDir, start, limit)
	
		s sqlStr="SELECT * FROM  dhc_pa_data.DNRRoom  WHERE %ID>0  "
		;w name ,!
		
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="DNRRoom_rowid"
		.i sortField="code" s sortField1="DNRRoom_code"
		.i sortField="name" s sortField1="DNRRoom_name"
		
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		e  s sortStr=" ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		;w sqlStr,!
		
		s result=##class(%Library.ResultSet).%New()
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^code^name"
		
		While(result.Next())
		{	
			s rowid=result.Data("DNRRoom_rowid")
			s code=result.Data("DNRRoom_code")
			s name=result.Data("DNRRoom_name")
			
				
			;s newdate = $ZDATETIME($H,8)
			;s newdate = $P(newdate," ",1)
			
			;s string="GT021020111010001"
			;s l=$L(name)
			;w "a:"_$EXTRACT(name,1,1),!
			;s a=$EXTRACT(name,1,1)
			;s name="十"_$EXTRACT(name,2,l)
			
			;w newStr,!

			s tmp=rowid_"^"_code_"^"_name
			s count=count+1
			i searchValue'="" d
			.q:(searchField="code")&(code'[searchValue)
			.q:(searchField="name")&(name'[searchValue)
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

/// Creator: 刘洋
/// CreatDate:  2011-09-23
/// Description: 插入新记录
/// Table:dhc.pa.data.DNRRoom
/// Input: 
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uNurseRoom).InsertRec("111","西")
ClassMethod InsertRec(code, name) As %String
{
		n (code,name)
		;w name_"name"_code ,!
		k PLIST
		q:code="" "EmptyCode"
		q:name="" "EmptyName"

		/**
		s rowid=0
		s rowid=..IfRepCode(code)
		q:rowid>0 "RepCode"
		s rowid=..IfRepName(name)
		q:rowid>0 "RepName"
		**/
		
		i code'="" s PLIST(2)=code
		i name'="" s PLIST(3)=name
		
	
	
		&sql(INSERT INTO  dhc_pa_data.DNRRoom  VALUES PLIST())
		q SQLCODE
}

/// Creator: 刘洋
/// CreatDate: 2010-07-14
/// Description: 代码是否存在
/// Table:dhc.pa.data.DNRRoom
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.pa.udata.uNurseRoom).IfRepCode("001")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^herpboneBoneOrganidx("Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 刘洋
/// CreatDate: 2010-07-14
/// Description: 名称是否存在
/// Table: dhc.pa.data.DNRRoom
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.pa.udata.uNurseRoom).IfRepName("肱骨上段")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^herpboneBoneOrganidx("Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Others: w ##class(dhc.pa.udata.uNurseRoom).Delete(1)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&sql(delete from  dhc_pa_data.DNRRoom  where %ID=:rowid)
	
	q SQLCODE
}

/// Others: w ##class(dhc.pa.udata.uNurseRoom).UpdateRec(1,"002","")
ClassMethod UpdateRec(rowid, code, name) As %String
{
		n (rowid,code,name)
	
		k PLIST
		
		;q:code="" "EmptyCode"
		;q:name="" "EmptyName"
		
		/**
		s crowid=0
		i code'="" s crowid=..IfRepCode(code)
		q:crowid>0 "RepCode"
		
		s nrowid=0
		i name'="" s nrowid=..IfRepName(name)
		q:nrowid>0 "RepName"
		**/
		
		i code'="" s PLIST(2)=code
		i name'="" s PLIST(3)=name
		
		
		&sql(update  dhc_pa_data.DNRRoom VALUES PLIST()  where %ID=:rowid)
	
		q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uNurseRoomS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
