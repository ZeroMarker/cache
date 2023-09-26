/// Creator: zhaoliguo
/// CreatDate: 2011-2-12
/// Description: 科室权限设置
Class dhc.bonus.udata.uBonusEmployeeUnit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhaoliguo
/// CreatDate: 2011-2-12
/// Description: 查询
/// Table：dhc.bonus.data.BonusEmployee
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusEmployeeUnit).List("","","","",0,25)
/// Others:w ##class(dhc.bonus.udata.uBonusEmployeeUnit).List("EmployeeName","李强","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)

	s sqlStr=" select  a.BonusEmployeeUnitID,b.BonusEmployeeID,b.EmployeeName,c.BonusUnitID,c.BonusUnitCode,c.BonusUnitName, c.BonusUnitTypeID->UnitTypeName"
	s sqlStr= sqlStr _" from dhc_bonus_data.BonusEmployeeUnit a, dhc_bonus_data.BonusEmployee b,dhc_bonus_data.BonusUnit c"
	s sqlStr= sqlStr _"  where a.BonusEmployeeID = b.BonusEmployeeID and a.BonusUnitID = c.BonusUnitID"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="BonusEmployeeUnitID"
	.i sortField="EmployeeName" s sortField1=" EmployeeName"
	.i sortField="unitName" s sortField1=" BonusUnitName"
	.i sortField="UnitTypeName" s sortField1=" c.BonusUnitTypeID->UnitTypeName"
	
	
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
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^EmployeeID^EmployeeName^UnitID^unitName^UnitTypeName"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("BonusEmployeeUnitID")
		s BonusEmployeeID = result.Data("BonusEmployeeID")
		s EmployeeName = result.Data("EmployeeName")
		s BonusUnitID = result.Data("BonusUnitID")
		s BonusUnitCode=  result.Data("BonusUnitCode")
		
		s BonusUnitName = result.Data("BonusUnitName")
		s UnitTypeName = result.Data("UnitTypeName")
		
		s tmp=rowid_"^"_BonusEmployeeID_"^"_EmployeeName_"^"_BonusUnitID_"^"_BonusUnitCode_"_"_BonusUnitName_"^"_UnitTypeName
		
		i searchValue'="" d
		.q:(searchField = "EmployeeName")&(EmployeeName'[searchValue)
		.q:(searchField = "BonusUnitName")&(BonusUnitName'[searchValue)
		
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

/// Creator: zhaoliguo
/// CreatDate: 2011-2-12
/// Description: 删除记录
/// Table：dhc.bonus.data.BonusEmployee
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uBonusEmployeeUnit).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_bonus_data.BonusEmployeeUnit WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: zhaoliguo
/// CreatDate: 2011-2-12
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusEmployee
/// Input：code-代码;name-名称;unitDr-单元Dr
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusEmployeeUnit).InsertRec(1,5)
ClassMethod InsertRec(BonusEmployeeID, BonusUnitID) As %String
{
	
	n (BonusEmployeeID, BonusUnitID)
	
	s rowid=0
	s rowid=..IfRepCode(BonusEmployeeID,BonusUnitID)
	q:rowid>0 "RepCode"

	s UpdateDate = $ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)

	&sql(insert into dhc_bonus_data.BonusEmployeeUnit (BonusEmployeeID,BonusUnitID,UpdateDate) values(:BonusEmployeeID,:BonusUnitID,:UpdateDate))
	q SQLCODE
}

/// Creator: zhaoliguo
/// CreatDate: 2011-2-12
/// Description: 代码是否存在
/// Table：dhc.bonus.data.BonusEmployee
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uBonusEmployeeUnit).IfRepCode(1,2)
ClassMethod IfRepCode(BonusEmployeeID, BonusUnitID) As %String
{
	new (BonusEmployeeID,BonusUnitID)
	s rowid=0
	//EmployUnitIndex On (BonusEmployeeID, BonusUnitID);
	s rowid=$o(^dhcbsBonusEmployeeUnitI("EmployUnitIndex",BonusEmployeeID, BonusUnitID,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusEmploy75CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
