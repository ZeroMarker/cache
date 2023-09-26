/// Creator: zhaoliguo
/// CreatDate: 2011-11-17
/// Description: 指标权限设置
Class dhc.bonus.udata.uBonusEmpCalculateType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/*
/// Creator: zhaoliguo
/// CreatDate: 2011-11-17
/// Description: 查询
/// Table：dhc.bonus.data.BonusEmployee
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusEmpCalculateType).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)

 	s sqlStr="select %ID rowid, BonusEmployeeID->EmployeeName,"
		_" BonusCalculateTypeID->CalculateTypeName ,BonusCalculateTypeID->CalculateTypeGroupID->CalculateGroupName"
		;_" ,BonusCalculateTypeID->BonusTargetID->BonusTargetName"
		_", BonusEmployeeID, BonusCalculateTypeID,BonusCalculateTypeID->CalculateTypeGroupID"
		_" from dhc_bonus_data.BonusEmpCalculateType"
 	
 	s sortStr=""
	s sortField1=""
	
	i searchField'="" d
	.i searchValue'=""
	..s sqlStr= sqlStr _" and "_searchField_" like '%"_searchValue_"%' "
	
	i sortField'="" d
	.i sortField="rowid" s sortField1=" %ID "
	.i sortField="EmployeeName" s sortField1=" EmployeeName"
	.i sortField="CalculateTypeName" s sortField1="BonusCalculateTypeID->CalculateTypeName"
	.i sortField="BonusTargetName" s sortField1=" BonusCalculateTypeID->BonusTargetID->BonusTargetName"
	
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
	s jsonTitle="rowid^EmployeeName^CalculateTypeName^CalculateGroupName^BonusTargetName"
				_"^EmployeeID^CalculateTypeID^CalTypeGroupID"

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("rowid")

		s EmployeeName = result.Data("EmployeeName")
		s CalculateGroupName = result.Data("CalculateGroupName")
		s CalculateTypeName = result.Data("CalculateTypeName")
		s BonusTargetName = ""
		
		s EmployeeID = result.Data("BonusEmployeeID")
		s CalculateTypeID = result.Data("BonusCalculateTypeID")
		s CalTypeGroupID = result.Data("BonusCalculateTypeID")
		
		s tmp=rowid_"^"_EmployeeName_"^"_CalculateTypeName_"^"_CalculateGroupName_"^"_BonusTargetName
		_"^"_EmployeeID_"^"_CalculateTypeID_"^"_CalTypeGroupID
		
		//w tmp,!
		i searchValue'="" d
		.q:(searchField = "EmployeeName")&(EmployeeName'[searchValue)
		.q:(searchField = "CalculateTypeName")&(CalculateTypeName'[searchValue)
	
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: zhaoliguo
/// CreatDate: 2011-11-17
/// Description: 删除记录
/// Table：dhc.bonus.data.BonusEmployee
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uBonusEmpCalculateType).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_bonus_data.BonusEmpCalculateType WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: zhaoliguo
/// CreatDate: 2011-11-17
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusEmployee
/// Input：code-代码;name-名称;unitDr-单元Dr
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusEmpCalculateType).InsertRec(1,5)
ClassMethod InsertRec(BonusEmployeeID, CalculateTypeID) As %String
{
	
	n (BonusEmployeeID,CalculateTypeID)
	
	s rowid=0
	s rowid=..IfRepCode(BonusEmployeeID,CalculateTypeID)
	q:rowid>0 "RepCode"

	&sql(insert into dhc_bonus_data.BonusEmpCalculateType(BonusEmployeeID,BonusCalculateTypeID) values(:BonusEmployeeID,:CalculateTypeID))
	q SQLCODE
}

/// Creator: zhaoliguo
/// CreatDate: 2011-11-17
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusEmployee
/// Input：code-代码;name-名称;unitDr-单元Dr
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusEmpCalculateType).UpdateRec(6,1,7)
ClassMethod UpdateRec(rowid, BonusEmployeeID, CalculateTypeID) As %String
{
	
	n (rowid,BonusEmployeeID,CalculateTypeID)
	
	s Rowid=0
	s Rowid=..IfRepCode(BonusEmployeeID,CalculateTypeID)
	q:Rowid>0 "RepCode"

	&sql(update dhc_bonus_data.BonusEmpCalculateType set BonusEmployeeID=:BonusEmployeeID,BonusCalculateTypeID=:CalculateTypeID where %ID=:rowid )
	q SQLCODE
}

/// Creator: zhaoliguo
/// CreatDate: 2011-11-17
/// Description: 代码是否存在
/// Table：dhc.bonus.data.BonusEmployee
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uEmployeeTarget).IfRepCode(1,2)
ClassMethod IfRepCode(BonusEmployeeID, CalculateTypeID) As %String
{
	new (BonusEmployeeID,CalculateTypeID)
	s rowid=0
	s rowid=$o(^dhcbsEmpCalculateTypeI("EmpCalcType",BonusEmployeeID, CalculateTypeID,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：zhaoliguo
/// CreatDate：2011-11-17
/// Description: 获取奖金指标
/// Table：dhc.bonus.data.BonusUnit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.bonus.udata.uBonusEmpCalculateType).CalculateType(0,10,"6","")
ClassMethod CalculateType(start, limit, CalculateTypeGroupID, CalculateTypeName) As %String
{
	n (start, limit, CalculateTypeGroupID, CalculateTypeName)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="select BonusCalculateTypeID rowid ,CalculateTypeCode code , CalculateTypeName name from dhc_bonus_data.BonusCalculateType"
			_"  where %ID>0 and IsValid= 1 and  CalculateTypeGroupID ="_CalculateTypeGroupID

	;i CalculateTypeName'="" s sqlStr = sqlStr_" and CalculateTypeName like '"_CalculateTypeName_"%'"
	s sqlStr=sqlStr_" order by CalculateTypeCode"
	
	//w sqlStr,!
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("rowid")
		s code = result.Data("code")
		s name = result.Data("name")

		s tmp=rowid_"^"_code_"_"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}
*/
Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusEmpCal8CES</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
