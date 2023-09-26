/// Creator: zhaoliguo
/// CreatDate: 2011-7-9
/// Description: 科室权限设置
Class dhc.bonus.udata.uBonusEmpScheme Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhaoliguo
/// CreatDate: 2011-7-09
/// Description: 查询
/// Table：dhc.bonus.data.BonusEmployee
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusEmpScheme).List("","","","",0,25)
/// Others:w ##class(dhc.bonus.udata.uBonusEmpScheme).List("EmployeeName","李强","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)

	s sqlStr=" select BonusEmpSchemeID ID,BonusEmpID,BonusEmpID->EmployeeName, BonusSchemeID,BonusSchemeID->BonusSchemeCode,BonusSchemeID->BonusSchemeName "
	s sqlStr= sqlStr _" ,BonusSchemeID->SchemeType,BonusSchemeID->SchemeType->SchemeTypeName as SchemeTypeName" 
	s sqlStr= sqlStr _" from dhc_bonus_data.BonusEmpScheme  where %id>0 "
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="BonusEmpSchemeID"
	.i sortField="EmployeeName" s sortField1=" BonusEmpID->EmployeeName"
	.i sortField="SchemeTypeName" s sortField1=" BonusSchemeID->SchemeType"
	.i sortField="BonusSchemeName" s sortField1=" BonusSchemeID->BonusSchemeName"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" order by BonusEmpID->EmployeeName"

	s sqlStr=sqlStr_sortStr
	;w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^EmployeeID^EmployeeName^BonusSchemeID^SchemeName^SchemeTypeName"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("ID")
		s BonusEmployeeID = result.Data("BonusEmpID")
		s EmployeeName = result.Data("EmployeeName")
		s BonusSchemeID = result.Data("BonusSchemeID")
		s BonusSchemeName=  result.Data("BonusSchemeName")
		s SchemeCode=  result.Data("BonusSchemeCode")
		
		s SchemeTypeID = result.Data("SchemeType")
		s SchemeTypeName = result.Data("SchemeTypeName")
		
		s tmp=rowid_"^"_BonusEmployeeID_"^"_EmployeeName_"^"_BonusSchemeID_"^"_SchemeCode_"_"_BonusSchemeName_"^"_SchemeTypeName
		
		i searchValue'="" d
		.q:(searchField = "EmployeeName")&(EmployeeName'[searchValue)
		.q:(searchField = "BonusSchemeName")&(BonusSchemeName'[searchValue)
		
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
/// Others: w ##class(dhc.bonus.udata.uBonusEmpScheme).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_bonus_data.BonusEmpScheme WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: zhaoliguo
/// CreatDate: 2011-2-12
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusEmployee
/// Input：code-代码;name-名称;unitDr-单元Dr
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusEmpScheme).InsertRec(1,5)
ClassMethod InsertRec(BonusEmpID, BonusSchemeID) As %String
{
	
	n (BonusEmpID, BonusSchemeID)
	
	s rowid=0
	s rowid=..IfRepCode(BonusEmpID, BonusSchemeID)
	q:rowid>0 "RepCode"

	s UpdateDate = $ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)

	&sql(insert into dhc_bonus_data.BonusEmpScheme (BonusEmpID,BonusSchemeID,UpdateDate) values(:BonusEmpID,:BonusSchemeID,:UpdateDate))
	q SQLCODE
}

/// Creator: zhaoliguo
/// CreatDate: 2011-7-9
/// Description: 代码是否存在
/// Table：dhc.bonus.data.BonusEmployee
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uBonusEmpScheme).IfRepCode(1,2)
ClassMethod IfRepCode(BonusEmpID, BonusSchemeID) As %String
{
	new (BonusEmpID, BonusSchemeID)
	s rowid=0
	//EmployUnitIndex On (BonusEmployeeID, BonusUnitID);
	s rowid=$o(^dhcbsEmpSchemeI("EmpSchemeIdx",BonusEmpID, BonusSchemeID,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: zhaoliguo
/// CreatDate: 2012-07-10
/// Description: 查询
/// Table：dhc_bonus_data.BonusScheme
/// Input：SchemeTypeID:奖金方案类型,start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusEmpScheme).getScheme(1,0,25)
ClassMethod getScheme(SchemeTypeID, start, limit) As %String
{
	n (SchemeTypeID, start, limit)
	q:SchemeTypeID=""

	s sqlStr="select BonusSchemeID, BonusSchemeCode,BonusSchemeName from dhc_bonus_data.BonusScheme"
		_" where IsValid =1 and  SchemeType=  '"_SchemeTypeID_"'"
		_" order by BonusSchemeCode"


	;w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("BonusSchemeID")
		s code = result.Data("BonusSchemeCode")
		s name = result.Data("BonusSchemeName")
		
		s tmp=rowid_"^"_code_"^"_name
		

		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusEmpSch5F3S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
