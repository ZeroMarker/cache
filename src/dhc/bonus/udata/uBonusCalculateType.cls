/// Creator: Zhao LIGuo 
/// CreatDate: 2011-11-15
/// Description: 奖金指标类别维护
Class dhc.bonus.udata.uBonusCalculateType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Zhao LIGuo 
/// CreatDate: 2011-11-15
/// Description: 代码是否存在
/// Table：dhc.bonus.data.TargetType
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uTargetType).IfRepCode("001")
ClassMethod IfRepCode(code) As %String
{
	new (code)
	s rowid=0
	s rowid=$o(^dhcbsCalculateTypeGroupI("Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: Zhao LIGuo 
/// CreatDate: 2011-11-15
/// Description: 名称是否存在
/// Table：dhc.bonus.data.TargetType
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uTargetType).IfRepName("医疗收入类")
ClassMethod IfRepName(name) As %String
{
	new (name)
	s rowid=0
	s rowid=$o(^dhcbsCalculateTypeGroupI("Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：Zhao LIGuo 
/// CreatDate：2011-11-15
/// Description: 查询
/// Table：dhc.bonus.data.TargetType
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusCalculateType).List("","","","",2,0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, CalcTypeGroupID, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir,CalcTypeGroupID, start, limit)
	//SQL
	s sqlStr="select BonusCalculateTypeID rowid,CalculateTypeCode,CalculateTypeName,"
			_"  CalculateTypeGroupID,CalculateTypeGroupID->CalculateGroupName,IsValid"
			_" from dhc_bonus_data.BonusCalculateType where  IsValid= 1"
	i CalcTypeGroupID'="" d
	.s sqlStr=sqlStr_" and CalculateTypeGroupID="_CalcTypeGroupID	 
			 
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="code" s sortField1="CalculateTypeCode"
	.i sortField="name" s sortField1="CalculateTypeName"
	.i sortField="CalculateGroupName" s sortField1="CalculateTypeGroupID->CalculateGroupName"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY CalculateTypeGroupID->CalculateGrouupCode "

	s sqlStr=sqlStr_sortStr
	//w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="rowid^code^name^svalue^targetID^targetName^ctypeGroupID^cTypeGroupName"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("rowid")
		s code = result.Data("CalculateTypeCode")
		s name = result.Data("CalculateTypeName")
		
		s svalue =0
		s targetID = 0
		s targetName = 0
		
		s ctypeGroupID = result.Data("CalculateTypeGroupID")
		s cTypeGroupName = result.Data("CalculateGroupName")
		
			
		s tmp=rowid_"^"_code_"^"_name_"^"_svalue_"^"_targetID_"^"_targetName_"^"_ctypeGroupID_"^"_cTypeGroupName
				;_"^"_EmployeeID_"^"_CalculateTypeID
		
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

/// Creator：Zhao LIGuo 
/// CreatDate：2011-11-15
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.TargetType
/// Input：code-代码;name-名称;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusCalculateType).InsertRec("2234","多少",2)
ClassMethod InsertRec(code, name, typeID) As %String
{
	
	n (code, name,typeID)
	/*
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	*/
	//w code_":"_name_":"_typeID,!
	
	set isValid =1

	&sql(insert into dhc_bonus_data.BonusCalculateType(CalculateTypeCode,CalculateTypeName, CalculateTypeGroupID,IsValid) values(:code,:name,:typeID,:isValid))
	q SQLCODE
}

/// Creator：Zhao LIGuo 
/// CreatDate：2011-11-15
/// Description: 更新记录
/// Table：dhc.bonus.data.TargetType
/// Input：rowId-所在行号;code-代码;name-名称;valid-有效;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusCalculateType).UpdateRec(3,"03","点撒大法师",45,2,2)
ClassMethod UpdateRec(rowid, code, name, svalue, targetID, typeID) As %String
{
	
	n (rowid, code, name,svalue,targetID,typeID)
	
	//w rowId_"^"_code_"^"_name,!
	/*
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	*/
	&sql(UPDATE dhc_bonus_data.BonusCalculateType SET CalculateTypeCode=:code ,CalculateTypeName=:name,CalculateTypeGroupID=:typeID WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: Zhao LIGuo 
/// CreatDate: 2011-11-15
/// Description: 删除记录
/// Table：dhc.bonus.data.TargetType
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uTargetType).Delete(1)
ClassMethod Delete(rowId) As %String
{
	&sql(update dhc_bonus_data.BonusCalculateType set IsValid=0 where %ID=:rowId)
	q SQLCODE
}

/// Creator：zhaoliguo
/// CreatDate：2011-2-14
/// Description: 获取奖金指标
/// Table：dhc.bonus.data.BonusUnit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.bonus.udata.uBonusCalculateType).BonusTarget(0,10,"")
ClassMethod BonusTarget(start, limit, targetname) As %String
{
	n (start, limit, targetname)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "  select BonusTargetID ,BonusTargetCode,BonusTargetName from dhc_bonus_data.BonusTarget  where  IsValid=1 and DataSource=4"
	i targetname'="" s sqlStr = sqlStr_" and BonusTargetName like '"_targetname_"%'"

	
	s sqlStr=sqlStr_" order by TargetTypeID,Cast(BonusTargetCode as int)"
	//w sqlStr,!
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusTargetID")
		s code = result.Data("BonusTargetCode")
		s name = result.Data("BonusTargetName")

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

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusCalcul7ACS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
