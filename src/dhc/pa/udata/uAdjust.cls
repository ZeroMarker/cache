Class dhc.pa.udata.uAdjust Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-07-20
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Adjust
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uAdjust).ListRec("1","","","rowid","DESC",0,10)
ClassMethod ListRec(stratagem, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (stratagem,searchField, searchValue, sortField, sortDir, start, limit)
		
		s sqlStr="SELECT Adjust_rowid,Adjust_parRef,Adjust_userDr,Adjust_date,Adjust_info FROM dhc_pa_data.Adjust WHERE Adjust_childSub>0"
		i stratagem'="" s sqlStr = sqlStr_"and Adjust_parRef="_stratagem
				
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="Adjust_rowid"
		.i sortField="parRef" s sortField1="Adjust_parRef"
		.i sortField="user" s sortField1="Adjust_userDr"
		.i sortField="date" s sortField1="Adjust_date"
		.i sortField="info" s sortField1="Adjust_info"
			
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
		s jsonTitle="rowid^parRef^user^date^info^parId^userId^yearName"
		
		While(result.Next())
		{
			s rowid=result.Data("Adjust_rowid")
			s parRef=result.Data("Adjust_parRef")
			s parId = parRef
			i parRef'=""  s parRef = $p($g(^DHCCJXPASTRATAGEM(parRef)),"^",4)
			s year = $p($g(^DHCCJXPASTRATAGEM(parId)),"^",2)
			s yearName = $p($g(^DHCCJXPACYCLE(year)),"^",2)
			s user=result.Data("Adjust_userDr")
			s userId = user
			i user'=""  s user = $p($g(^SSU("SSUSR",user)),"^",2)
			s date=result.Data("Adjust_date")
			s date = $zd(date,3)
			s info=result.Data("Adjust_info")
			
			s tmp=rowid_"^"_parRef_"^"_user_"^"_date_"^"_info_"^"_parId_"^"_userId_"^"_yearName
			s count=count+1
			i searchValue'="" d
			.q:(searchField="parRef")&(code'[searchValue)
			.q:(searchField="user")&(name'[searchValue)
			.q:(searchField="date")&(shortcut'[searchValue)
			.q:(searchField="info")&(desc'[searchValue)
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
/// CreatDate:  2010-07-20
/// Description: 插入新记录
/// Table: dhc.pa.data.Adjust
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return:执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uAdjust).InsertRec("7^demo^调整")
ClassMethod InsertRec(data) As %String
{
		n (data)
		k PLIST
		q:data="" "EmptyRecData"
		
		Set $ZT="ERROR"	
		
		s perRef=$p(data,"^",1)
	    s flag = "new"
		s user=$p(data,"^",2)
		s user = $$ALPHAUP^SSUTIL4(user)
		s userId = ""
		s userId = $o(^SSU("SSUSR",0,"SSUSR_Name",user,userId))
		s date = $p($h,",",1)
		s info = $p(data,"^",3)
	
		i perRef'="" s PLIST(0)=perRef
		i userId'="" s PLIST(3)=userId
		i date'="" s PLIST(4)=date
		i info'="" s PLIST(5)=info
		
	    TSTART	
		&sql(UPDATE dhc_pa_data.Stratagem Set Stratagem_stateFlag='new' WHERE  Stratagem_rowid=:perRef)
		//If SQLCODE TROLLBACK  q SQLCODE
		&sql(INSERT INTO dhc_pa_data.Adjust VALUES PLIST())
		If SQLCODE TROLLBACK  q SQLCODE
		TCOMMIT	

ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit SQLCODE     //返回错误消息 ;
}

/// Creator: wang ying
/// CreatDate: 2010-07-20
/// Description: 更新记录
/// Table: dhc.pa.data.Adjust
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uAdjust).UpdateRec("1||1","1^1^调整")
ClassMethod UpdateRec(rowid, data) As %String
{
		n (rowid,data)
		k PLIST
		q:data="" "EmptyRecData"
		
		Set $ZT="ERR"	
				
		s perRef=$p(data,"^",1)
		s user=$p(data,"^",2)
		s user = $$ALPHAUP^SSUTIL4(user)
		s userId = ""
		s userId = $o(^SSU("SSUSR",0,"SSUSR_Name",user,userId))
		;s userName = $p($g(^SSU("SSUSR",user)),"^",2)
		s date = $p($h,",",1)
		s info = $p(data,"^",3)
			
		
		i perRef'="" s PLIST(0)=perRef
		i userId'="" s PLIST(3)=userId
		i userId = "" s PLIST(3)= ""
		i date'="" s PLIST(4)=date
		i info'="" s PLIST(5)=info
		i info = "" s PLIST(5)=""
		
		TSTART		
		&sql(UPDATE dhc_pa_data.Stratagem Set Stratagem_stateFlag='new' WHERE  Stratagem_rowid=:perRef)
		//If SQLCODE TROLLBACK  q SQLCODE
		&SQL(UPDATE dhc_pa_data.Adjust VALUES PLIST() where %ID=:rowid)
		If SQLCODE TROLLBACK  q SQLCODE
		TCOMMIT	
		q SQLCODE
ERR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit SQLCODE     //返回错误消息 ;
}

/// Creator：李明忠
/// CreatDate：2010-7-15
/// Description: 取出Combobox所许要的有效单位
/// Table：dhc_pa_data.Stratagem
/// Input：start:开始记录位置;limit:记录条数;str:模糊查询字段
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.pa.udata.uAdjust).UnitList("","",2)
ClassMethod UnitList(start, limit, str) As %String
{
	n (start, limit, str)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Stratagem_rowid,Stratagem_name from dhc_pa_data.Stratagem where %ID>0 "
	i str '="" s sqlStr=sqlStr_"and Stratagem_cycleDr="_str
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	;s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("Stratagem_rowid")
		s name = result.Data("Stratagem_name")
		s tmp=rowid_"^"_name
		s count = count+1
		;i (count>start)&(count<=end) d
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-7-15
/// Description: 取出Combobox所许要的有效单位
/// Table：dhc_pa_data.Stratagem
/// Input：start:开始记录位置;limit:记录条数;str:模糊查询字段
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.pa.udata.uAdjust).serviceTest("10101","<Request><period>201501</period><checkDr>1</checkDr><status>1</status></Request>")
ClassMethod serviceTest(code, request) As %String
{
	s ret=##class(dhc.qm.server.PublicServiceSoap).%New("")
	s result=ret.RequestMethod(code,request)
	q result
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uAdjustS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
