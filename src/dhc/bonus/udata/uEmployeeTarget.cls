/// Creator: zhaoliguo
/// CreatDate: 2011-2-14
/// Description: 指标权限设置
Class dhc.bonus.udata.uEmployeeTarget Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhaoliguo
/// CreatDate: 2011-2-14
/// Description: 查询
/// Table：dhc.bonus.data.BonusEmployee
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uEmployeeTarget).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)

	s sqlStr=" select a.BonusEmployeeTargetID,b.BonusEmployeeID,b.EmployeeName,c.BonusTargetID ,c.BonusTargetName,c.TargetTypeID->TargetTypeName     "
	s sqlStr= sqlStr _" from dhc_bonus_data.BonusEmployeeTarget a,dhc_bonus_data.BonusEmployee b,dhc_bonus_data.BonusTarget c"
	s sqlStr= sqlStr _"  where a.BonusEmployeeID = b.BonusEmployeeID and a.BonusTargetID = c.BonusTargetID"
 
 	
 	s sortStr=""
	s sortField1=""
	
	i searchField'="" d
	.i searchValue'=""
	..s sqlStr= sqlStr _" and "_searchField_" like '%"_searchValue_"%' "
	
	i sortField'="" d
	.i sortField="rowid" s sortField1=" BonusEmployeeTargetID"
	.i sortField="EmployeeName" s sortField1=" EmployeeName"
	.i sortField="TargetName" s sortField1=" c.BonusTargetName"
	.i sortField="TargetTypeName" s sortField1=" c.TargetTypeID->TargetTypeName"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY a.%ID DESC"

	s sqlStr=sqlStr_sortStr
	//w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^EmployeeID^EmployeeName^TargetID^TargetName^TargetTypeName"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("BonusEmployeeTargetID")
		s BonusEmployeeID = result.Data("BonusEmployeeID")
		s EmployeeName = result.Data("EmployeeName")
		s BonusTargetID = result.Data("BonusTargetID")
		s BonusTargetName = result.Data("BonusTargetName")
		s TargetTypeName = result.Data("TargetTypeName")
		
		
		s tmp=rowid_"^"_BonusEmployeeID_"^"_EmployeeName_"^"_BonusTargetID_"^"_BonusTargetName_"^"_TargetTypeName
		//w tmp,!
		i searchValue'="" d
		.q:(searchField = "EmployeeName")&(EmployeeName'[searchValue)
		.q:(searchField = "BonusTargetName")&(BonusTargetName'[searchValue)
	
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
/// CreatDate: 2011-2-14
/// Description: 删除记录
/// Table：dhc.bonus.data.BonusEmployee
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uEmployeeTarget).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_bonus_data.dhc_bonus_data.BonusEmployeeTarget WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: zhaoliguo
/// CreatDate: 2011-2-14
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusEmployee
/// Input：code-代码;name-名称;unitDr-单元Dr
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uEmployeeTarget).InsertRec(1,5)
ClassMethod InsertRec(BonusEmployeeID, BonusTargetID) As %String
{
	
	n (BonusEmployeeID, BonusTargetID)
	
	s rowid=0
	s rowid=..IfRepCode(BonusEmployeeID,BonusTargetID)
	q:rowid>0 "RepCode"

	s UpdateDate = $ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)

	&sql(insert into dhc_bonus_data.BonusEmployeeTarget (BonusEmployeeID,BonusTargetID,UpdateDate) values(:BonusEmployeeID,:BonusTargetID,:UpdateDate))
	q SQLCODE
}

/// Creator: zhaoliguo
/// CreatDate: 2011-2-14
/// Description: 代码是否存在
/// Table：dhc.bonus.data.BonusEmployee
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uEmployeeTarget).IfRepCode(1,2)
ClassMethod IfRepCode(BonusEmployeeID, BonusTargetID) As %String
{
	new (BonusEmployeeID,BonusTargetID)
	s rowid=0
	s rowid=$o(^dhcbsBonusEmployeeTargetI("EmployeeTargetI",BonusEmployeeID, BonusTargetID,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：zhaoliguo
/// CreatDate：2011-2-14
/// Description: 获取奖金指标
/// Table：dhc.bonus.data.BonusUnit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.bonus.udata.uEmployeeTarget).BonusTarget(0,10,"","1")
ClassMethod BonusTarget(start, limit, targetname, TargetTypeID) As %String
{
	n (start, limit, targetname,TargetTypeID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "  select BonusTargetID ,BonusTargetCode,BonusTargetName from dhc_bonus_data.BonusTarget  where  IsValid=1 and DataSource=1"
	i targetname'="" s sqlStr = sqlStr_" and BonusTargetName like '"_targetname_"%'"
	i TargetTypeID'="" s sqlStr = sqlStr_" and TargetTypeID ="_TargetTypeID
	
	s sqlStr=sqlStr_" order by TargetTypeID,Cast(BonusTargetCode as int)"
	;w sqlStr,!
	
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
<StreamLocation>^dhc.bonus.u5C1.uEmployeeTar61CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
