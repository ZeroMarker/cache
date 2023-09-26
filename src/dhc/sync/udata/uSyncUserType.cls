Class dhc.sync.udata.uSyncUserType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//科室类别维护

/// Creator: Hao Shanshan
/// CreatDate: 2012-11-27
/// Description: 代码是否存在
/// Table：dhc.sync.udata.uSyncUserType
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(herp.budg.udata.uBudgDeptType).IfRepCode("2")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^dhcsyncUserTypeI("SyncUserTypeCode",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Description: 名称是否存在
/// Table：dhc.sync.udata.uSyncUserType
/// Input: name-名称 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(herp.budg.udata.uBudgDeptType).IfRepName("门诊")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^dhcsyncUserTypeI("SyncUserTypeName",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Description: 插入一条新数据
/// Table：dhc.sync.udata.uSyncUserType
/// Input：BDT_Code-编码,BDT_Name-名称,BDT_IsValid-是否有效
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(herp.budg.udata.uBudgDeptType).InsertRec("543","非官方")
ClassMethod InsertRec(userId, uname, code, name) As %String
{
	
	n (userId, uname,code, name)
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	
	s rowid=0
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	
	set isValid ="Y"
	
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	s TableName="herp.budg.udata.Sync_UserType"
	s ClassName="dhc.sync.udata.uSyncUserType"
	s ClassNameDesc="用户类别维护"
	s ObjectDesc="增加一条类别记录"
	s NewValue="Code:"_code_",Name:"_name
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"code:"_code,ObjectDesc,"A",NewValue,userId, uname) 

	&sql(insert into dhc_sync_data.Sync_UserType(SUT_Code,SUT_Name,SUT_IsValid) values(:code,:name,:isValid))
	q SQLCODE
}

/// Description: 删除记录
/// Table： dhc.sync.udata.uSyncUserType
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(herp.budg.udata.uBudgDeptType).Delete("7")
ClassMethod Delete(userId, uname, rowid) As %String
{
	n (userId, uname,rowid)
	
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	s TableName="herp.budg.udata.Sync_UserType"
	s ClassName="dhc.sync.udata.uSyncUserType"
	s ClassNameDesc="用户类别维护"
	s ObjectDesc="删除一条类别记录"
	s NewValue=""
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"rowid:"_rowid,ObjectDesc,"D",NewValue,userId, uname)
		
	&sql(Delete from dhc_sync_data.Sync_UserType where SUT_Rowid=:rowid)
	
	q SQLCODE
}

/// Creator：Hao Shanshan
/// CreatDate：2013-8-9
/// Description: 更新记录
/// Table：dhc.sync.udata.uSyncUserType
/// Input：rowid-所在行号;code-参数代码, name-参数名称,visvalid-是否有效
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(herp.budg.udata.uBudgDeptType).UpdateRec("4","3","发放")
ClassMethod UpdateRec(userId, uname, rowid, code, name) As %String
{
	n (userId, uname,rowid, code, name)
	k PLIST
	
	i code="" s code=$list(^dhcsyncUserTypeD(rowid),2)
	i name="" s name=$list(^dhcsyncUserTypeD(rowid),3)
	
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepName"
	
	i code      '="" s Plist(2)= code       
	i name      '="" s Plist(3)= name
	
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	s TableName="herp.budg.udata.Sync_UserType"
	s ClassName="dhc.sync.udata.uSyncUserType"
	s ClassNameDesc="用户类别维护"
	s ObjectDesc="更新一条类别记录"
	s NewValue=""
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"id:"_rowid,ObjectDesc,"U",NewValue,userId, uname)  
	
	&SQL(UPDATE  dhc_sync_data.Sync_UserType VALUES Plist() where %ID=:rowid) 
	q SQLCODE
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-8-9
/// Description: 查询符合条件的记录
/// Table: dhc.sync.udata.uSyncUserType
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.uSyncUserType).List(0,15)
ClassMethod List(userId, uname, start, limit) As %String
{
	n (userId, uname,start,limit)
	
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	s TableName="dhc_sync_data.Sync_UserType"
	s ClassName="dhc.sync.udata.uSyncUserType"
	s ClassNameDesc="用户类别维护"
	s ObjectDesc="查询类别信息"
	s NewValue=""
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"",ObjectDesc,"R",NewValue,userId, uname)
	
	s sqlStr="select SUT_Rowid,SUT_Code,SUT_Name,SUT_IsValid from dhc_sync_data.Sync_UserType where  SUT_IsValid ='Y'"
		
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	;w start,"^",limit,!
	s end=start+limit-1
	
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name^isValid"
	While(result.Next())
	{   
		s rowid = result.Data("SUT_Rowid")
		s code=result.Data("SUT_Code")
		s name=result.Data("SUT_Name")
		s isValid=result.Data("SUT_IsValid")		
		
		s tmp=rowid_"^"_code_"^"_name_"^"_isValid
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
<StreamLocation>^dhc.sync.udata.uSyncUserTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
