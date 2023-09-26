/// Creator: 李明忠 
/// CreatDate: 2012-2-14
/// Description: 奖金系统文件管理
Class dhc.bonus.udata.uFileManager Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 李明忠
/// CreatDate: 2012-2-14
/// Description: 文件是否存在
/// Table：dhc_bonus_data.FileManager
/// Input: fileName-文件名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uFileManager).IfRepRec("abc.txt")
ClassMethod IfRepRec(fileName) As %String
{
	n (fileName)
	
	s rowid=0
	s rowid=$o(^dhc.bonus.data.FileManagerI("FileName",fileName,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：李明忠
/// CreatDate：2012-2-14
/// Description: 插入一条新数据
/// Table：dhc_bonus_data.FileManager
/// Input：code-代码;name-名称;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uFileManager).Insert(47,"abcd.txt")
ClassMethod Insert(userId, fileName) As %String
{
	n (userId,fileName)
	
	s rs =0
	
	s rowid=0
	s rowid=..IfRepRec(fileName)
	q:rowid>0 "RepRec"
	
	s obj = ##Class(dhc.bonus.data.FileManager).%New()
	d obj.UpLoadUserIDSetObjectId(userId)
	s obj.FileName=fileName
	s obj.UpLoadDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	
	s rs = obj.%Save()
	
	q rs
}

/// Creator：李明忠
/// CreatDate：2012-2-14
/// Description: 查询文件信息
/// Table：dhc_bonus_data.FileManager
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uFileManager).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT UpLoadFileID,UpLoadUserID,FileName,UpLoadDate from dhc_bonus_data.FileManager"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="UpLoadFileID"
	.i sortField="userName" s sortField1="UpLoadUserID"
	.i sortField="fileName" s sortField1="FileName"
	.i sortField="date" s sortField1="UpLoadDate"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" DESC"
	e  s sortStr=" ORDER BY UpLoadDate DESC"

	s sqlStr=sqlStr_sortStr
	;w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^userId^userName^fileName^date"
	

	//取结构
	While(result.Next()){
		s userName="未知者"
		s rowid = result.Data("UpLoadFileID")
		s userId = result.Data("UpLoadUserID")
		i userId'="" d
		.i $D(^SSU("SSUSR",userId)) d
		..s userName=$P(^SSU("SSUSR",userId),"^",2)
		
		s fileName = result.Data("FileName")
		s date = result.Data("UpLoadDate")
		s tmp=rowid_"^"_userId_"^"_userName_"^"_fileName_"^"_date
		
		i searchValue'="" d
		.q:(searchField = "userName")&(userName'[searchValue)
		.q:(searchField = "fileName")&(fileName'[searchValue)
		
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
/// CreatDate：2012-2-15
/// Description: 删除一条数据
/// Table：dhc_bonus_data.FileManager
/// Input：fileName-文件名称;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uFileManager).Delete("ab.txt")
ClassMethod Delete(fileName) As %String
{
	n (fileName)
	
	&sql(delete from dhc_bonus_data.FileManager where FileName=:fileName)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uFileManagerS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
