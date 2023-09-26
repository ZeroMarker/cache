/// Creator: 刘洋
/// CreatDate: 2011-1-24
/// Description: 奖金人员设置
Class dhc.bonus.udata.uBonusEmployee Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 刘洋
/// CreatDate: 2011-1-24
/// Description: 代码是否存在
/// Table：dhc.bonus.data.BonusEmployee
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uBonusEmployee).IfRepCode("001")
ClassMethod IfRepCode(code) As %String
{
	new (code)
	s rowid=0
	&sql(SELECT count(*) into :rowid FROM dhc_bonus_data.BonusEmployee WHERE EmployeeCode=:code AND IsValid=1)
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 刘洋
/// CreatDate: 2011-1-17
/// Description: 名称是否存在
/// Table：dhc.bonus.data.BonusEmployee
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uBonusEmployee).IfRepName("")
ClassMethod IfRepName(name) As %String
{
	new (name)
	s rowid=0
	&sql(SELECT count(*) into :rowid FROM dhc_bonus_data.BonusEmployee WHERE EmployeeName=:name AND IsValid=1)
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：刘洋
/// CreatDate：2011-1-24
/// Description: 查询
/// Table：dhc.bonus.data.BonusEmployee
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusEmployee).List("","","","name",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{

	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT BonusEmployeeID,EmployeeCode,EmployeeName,BonusUnitID ,BonusUnitID->BonusUnitName "
	_" from dhc_bonus_data.BonusEmployee where  IsValid =1 "
	s sortStr=""
	s sortField1=""

	
	i sortField'="" d
	.i sortField="rowid" s sortField1="BonusEmployeeID"
	.i sortField="code" s sortField1="EmployeeCode"
	.i sortField="name" s sortField1="EmployeeName"
	.;i sortField="isValid" s sortField1="IsValid"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY %ID DESC"

	s sqlStr=sqlStr_sortStr
	
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name^unitDr^unitName"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("BonusEmployeeID")
		s code = result.Data("EmployeeCode")
		s name = result.Data("EmployeeName")
		
		s unitDr = result.Data("BonusUnitID")
		s unitName = result.Data("BonusUnitName")
		
		s tmp=rowid_"^"_code_"^"_name_"^"_unitDr_"^"_unitName
		
		i searchValue'="" d
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		
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

/// Creator：刘洋
/// CreatDate：2011-1-24
/// Description: 获取核算单元
/// Table：dhc.bonus.data.BonusUnit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.bonus.udata.uBonusEmployee).BonusUnit(0,10,"",9)
ClassMethod BonusUnit(start, limit, str, BonusUnitTypeID) As %String
{
	n (start, limit, str,BonusUnitTypeID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT BonusUnitID,BonusUnitCode,BonusUnitName ,SuperiorUnitID->BonusUnitName supUnitName"
	_" from dhc_bonus_data.BonusUnit where IsValid=1 " // and UnitFlag=1 and LastStage=1
	
	i BonusUnitTypeID'="" d
	.s sqlStr =sqlStr_	"  and BonusUnitTypeID="_BonusUnitTypeID
	
	i str'="" s sqlStr = sqlStr_" and BonusUnitName like '"_str_"%'"
	s sqlStr=sqlStr_" order by cast(BonusUnitTypeID->UnitTypeCode as int),SuperiorUnitID->BonusUnitCode,BonusUnitCode"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusUnitID")
		s code = result.Data("BonusUnitCode")
		s name = result.Data("BonusUnitName")
		s supUnitName = result.Data("supUnitName")
		
		s tmp=rowid_"^"_supUnitName_"__"_name ;_"_"_code
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
/// CreatDate：2011-1-24
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusEmployee
/// Input：code-代码;name-名称;unitDr-单元Dr
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusEmployee).InsertRec("003","王五","4")
ClassMethod InsertRec(code, name, unitDr) As %String
{
	
	n (code, name,unitDr)
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	//s rowid=..IfRepName(name)
	//q:rowid>0 "RepName"


	set isValid =1

	&sql(insert into dhc_bonus_data.BonusEmployee (EmployeeCode,EmployeeName,IsValid,BonusUnitID) values(:code,:name,:isValid,:unitDr))
	q SQLCODE
}

/// Creator: 刘洋
/// CreatDate: 2011-1-24
/// Description: 删除记录
/// Table：dhc.bonus.data.BonusEmployee
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uBonusEmployee).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(update  dhc_bonus_data.BonusEmployee set IsValid=0 WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator：刘洋
/// CreatDate：2011-1-24
/// Description: 更新记录
/// Table：dhc.bonus.data.BonusEmployee
/// Input：rowId-所在行号;code-代码;name-名称;valid-有效;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusEmployee).UpdateRec(1,"","",1,"")
ClassMethod UpdateRec(rowId, code, name, unitdr) As %String
{
	
	n (rowId, code, name,unitdr)
	/*
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	*/
	//s ^zlgtemp6=name
	
	&sql(update dhc_bonus_data.BonusEmployee set EmployeeCode=:code,EmployeeName=:name,BonusUnitID=:unitdr where %ID=:rowId)
	q SQLCODE
}

/*
n (rowId, code, name,unitdr)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	//s ^zlgtemp6=name
	
	&sql(update dhc_bonus_data.BonusEmployee set EmployeeCode=:code,EmployeeName=:name,BonusUnitID=:unitdr where %ID=:rowId)
	q SQLCODE
*/
/// Creator：zhao liguo
/// CreatDate：2011-1-25
/// Description: 查询单位内的职工
/// Table：dhc_bonus_data.BonusEmployee
/// Input：sUnitID-核算单元ID;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusEmployee).GetUnitEmp(1)
ClassMethod GetUnitEmp(sUnitID) As %String
{
	n (sUnitID)
	//SQL select BonusEmployeeID,EmployeeCode,EmployeeName
	//
	s sqlStr="select BonusEmployeeID,EmployeeCode,EmployeeName "
	s sqlStr = sqlStr_" from dhc_bonus_data.BonusEmployee where BonusUnitID="_sUnitID
	;w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0

	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("BonusEmployeeID")
		s code = result.Data("EmployeeCode")
		s name = result.Data("EmployeeName")
		s tmp=rowid_"^"_name
		
		d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: zhao liguo
/// CreatDate: 2011-01-14
/// Description: 获取核算单元的职工人数
/// Table: dhc.bonus.data.UnitBonusPay
/// Input: sUnitID-核算单元的ID
/// Output: 
/// Return: 核算单元内职工的人数
/// Others: w ##class(dhc.bonus.udata.uBonusEmployee).GetUnitEmployeeCount("1")       
ClassMethod GetUnitEmployeeCount(sUnitID) As %Integer
{
	n (sUnitID)
		
	s sqlStr="select count(EmployeeCode) as EmployeeCount from  dhc_bonus_data.BonusEmployee"
	s sqlStr=sqlStr_" where BonusUnitID="_sUnitID
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s sCount=0	
	While(result.Next())
	{
		s sCount=result.Data("EmployeeCount")
	}
	
	d result.Close()
	q sCount
}

Storage Default
{
<StreamLocation>^dhc.bonus.ud5C1.uBonusEmployeeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
