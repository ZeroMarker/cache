/// Creator: 李明忠 
/// CreatDate: 2012-2-13
/// Description: 奖金系统操作日志记录
Class dhc.bonus.udata.uBonusLogRecord Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠 
/// CreatDate：2012-2-13
/// Description: 查询
/// Table：dhc_bonus_data.BonusLogRecord
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusLogRecord).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="select BonusLogRecordID,OptionUserID,OptionName,OptionDate from dhc_bonus_data.BonusLogRecord" 
			 
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="BonusLogRecordID"
	.i sortField="userName" s sortField1="OptionUserID"
	.i sortField="name" s sortField1="OptionName"
	.i sortField="date" s sortField1="OptionDate"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY OptionDate"

	s sqlStr=sqlStr_sortStr
	;w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="rowid^userId^userName^name^date"
	

	//取结构
	While(result.Next()){
		s userName=""
		s rowid = result.Data("BonusLogRecordID")
		s userId = result.Data("OptionUserID")
		i userId'="" d
		.i $D(^SSU("SSUSR",userId)) d
		..s userName=$P(^SSU("SSUSR",userId),"^",2)
		
		s name = result.Data("OptionName")
		s date = result.Data("OptionDate")
			
		s tmp=rowid_"^"_userId_"^"_userName_"^"_name_"^"_date
	
		i searchValue'="" d
		.q:(searchField = "userName")&(userName'[searchValue)
		.q:(searchField = "date")&(date'[searchValue)
		
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

/// Creator：李明忠 
/// CreatDate：2012-2-13
/// Description: 插入一条操作数据
/// Table：dhc_bonus_data.BonusLogRecord
/// Input：userID-用户ID;name-操作名称
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusLogRecord).Insert(47,"添加用户")
ClassMethod Insert(userID, name) As %String
{
	n (userID, name)

	s date=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	
	&sql(insert into dhc_bonus_data.BonusLogRecord(OptionUserID,OptionName,OptionDate) values(:userID,:name,:date))
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusLogRec5FDS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
