/// 科室所属病区
Class dhc.pa.udata.uDeptNurseRoom Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：刘洋
/// CreatDate：2011-12-12
/// Description: 获取绩效单元
/// Table：dhc_pa_data.JXUnit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uDeptNurseRoom).GetJXUnit(0,10,"神")
ClassMethod GetJXUnit(start, limit, str) As %String
{
	n (start, limit, str)

	//是否参与核算标志
	s isEnd="Y"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXUnit_rowid,JXUnit_name,JXUnit_shortcut from dhc_pa_data.JXUnit where %ID>0 and JXUnit_appSysDr=2"
	s whereStr=" and JXUnit_isEnd='"_isEnd_"'"
	i str '="" s whereStr=" and JXUnit_name  like '"_str_"%'" 
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("JXUnit_rowid")
		s name = result.Data("JXUnit_name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator：刘洋
/// CreatDate：2011-12-12
/// Description: 获取病区
/// Table：dhc.pa.data.DNRRoom
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uDeptNurseRoom).GetJXNurseRoom(0,10,"二")
ClassMethod GetJXNurseRoom(start, limit, str) As %String
{
	n (start, limit, str)

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select *  from  dhc_pa_data.JXUnit  where %ID>0 and JXUnit_End='Y' and JXUnit_appSysDr=3 "
	s whereStr=""
	i str '="" s whereStr=" and JXUnit_name  like '"_str_"%'" 
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("JXUnit_rowid")
		s name = result.Data("JXUnit_name")
		
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator:  刘洋
/// CreatDate: 2011-12-12
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.DeptNurseRoom
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uDeptNurseRoom).List("","","","","0","25")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (searchField, searchValue, sortField, sortDir, start, limit)
	
		s sqlStr="SELECT * from dhc_pa_data.DeptNurseRoom  WHERE %ID>0  "
		;w name ,!
		
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="DeptNurseRoom_rowid"

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
		s jsonTitle="rowid^dept^nurseroom"
		
		While(result.Next())
		{	
			s rowid=result.Data("DeptNurseRoom_rowid")
			
			s deptDr=result.Data("DNR_DeptDr")
			s dept=""
			i deptDr'="" d
			.i $D(^DHCCJXPAJXUNIT(deptDr)) d
			..i $G(^DHCCJXPAJXUNIT(deptDr))'="" d
			...s dept=$P(^DHCCJXPAJXUNIT(deptDr),"^",3)
			
			i deptDr'="" d
			.i $D(^DHCCJXPAJXUNIT(deptDr)) d
			..i $G(^DHCCJXPAJXUNIT(deptDr))'="" d
			...s dept=$P(^DHCCJXPAJXUNIT(deptDr),"^",3)
			
			
			s nurseroom=""
			s nurseroomDr=result.Data("DNR_RoomDr")
			i nurseroomDr'="" d
			.i $D(^DHCCJXPAJXUNIT(nurseroomDr)) d
			..i $G(^DHCCJXPAJXUNIT(nurseroomDr))'="" d
			...s nurseroom=$P(^DHCCJXPAJXUNIT(nurseroomDr),"^",3)

			s tmp=rowid_"^"_dept_"^"_nurseroom
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
/// CreatDate:  2011-12-12
/// Description: 插入新记录
/// Table:dhc.pa.data.DeptNurseRoom 
/// Others: w ##class(dhc.pa.udata.uDeptNurseRoom).InsertRec("111","西")
ClassMethod InsertRec(dept, nurseroom) As %String
{
		n (dept,nurseroom)
		;w name_"name"_code ,!
		k PLIST

		i dept'="" s PLIST(2)=dept
		i nurseroom'="" s PLIST(3)=nurseroom

		&sql(INSERT INTO  dhc_pa_data.DeptNurseRoom  VALUES PLIST())
		q SQLCODE
}

/// Creator：刘洋
/// CreatDate：2011-12-12
/// Description: 获取病区名称
/// Table：dhc.pa.data.DNRRoom
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uDeptNurseRoom).GetNurseRoomName()
ClassMethod GetNurseRoomName(Id) As %String
{
	n (Id)

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select *  from  dhc_pa_data.DNRRoom   "
	s whereStr=""
	i Id '="" s whereStr=" where  DNRRoom_rowid  = '"_Id_"'" 
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
	
		s name = result.Data("DNRRoom_name")
	}
	d result.Close()

	q name
}

/// Others: w ##class(dhc.pa.udata.uNurseRoom).Delete(1)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&sql(delete from  dhc_pa_data.DeptNurseRoom   where %ID=:rowid)
	
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uDeptNurseRoomS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
