Class dhc.sync.udata.SyncSystem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//用户维护

/// Creator:Hao Shanshan
/// Description: 代码是否存在
/// Table：dhc_sync_data.Sync_System
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.sync.udata.SyncSystem).IfRepCode("1")
ClassMethod IfRepCode(Code) As %String
{
	new (Code)
	s rowid=0
	s rowid=$o(^dhcsyncSystemI("syncSysCode",Code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Description: 插入一条新数据
/// Table：dhc_sync_data.Sync_System
/// Input：BDEPT_Code-编码,BDEPTT_Name-名称,BDEPTT_Class-分类,BDEPT_DirectDR-科主任
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.SyncSystem).InsertRec("6","aaaa","Y")
ClassMethod InsertRec(userId, uname, Code, Name, Active) As %String
{
	
	n (userId, uname,Code, Name, Active)
	k ^temp
	s ^temp=Code_"^"_Name_"^"_Active
	
	s rowid=0
	s rowid=..IfRepCode(Code)
	q:rowid>0 "RepCode"
	s PublicKey=Code _"_"_ "PublicKey.der"
	s PrivateKey= Code _"_" _ "PKCS8_PrivateKey.pem"
	
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	s TableName="dhc_sync_data.Sync_System"
	s ClassName="dhc.sync.udata.SyncSystem"
	s ClassNameDesc="各系统信息维护"
	s ObjectDesc="增加一条系统记录"
	s NewValue="Code:"_Code_",Name:"_Name_",Active:"_Active
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"code:"_Code,ObjectDesc,"A",NewValue,userId, uname) 
	
	&sql(insert into dhc_sync_data.Sync_System(Code, Name, Active,PublicKey,PrivateKey
) 
	values(:Code, :Name, :Active,:PublicKey,:PrivateKey
))
	q SQLCODE
}

/// Description: 删除记录
/// Table：dhc_sync_data.Sync_System
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.sync.udata.SyncSystem).Delete("9")
ClassMethod Delete(userId, uname, Rowid) As %String
{
	n (userId, uname,Rowid)
	
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	s TableName="dhc_sync_data.Sync_System"
	s ClassName="dhc.sync.udata.SyncSystem"
	s ClassNameDesc="各系统信息维护"
	s ObjectDesc="删除一条系统记录"
	s NewValue="Rowid:"_Rowid
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"id:"_Rowid,ObjectDesc,"D",NewValue,userId, uname) 
		
	&sql(Delete from dhc_sync_data.Sync_System where Rowid=:Rowid)
	q SQLCODE
}

/// Creator：Hao Shanshan
/// CreatDate：2013-06-04
/// Description: 更新记录
/// Table：dhc_sync_data.Sync_System
/// Input：BDEPT_Code-编码,BDEPTT_Name-名称,BDEPTT_Class-分类,BDEPT_DirectDR-科主任
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.SyncSystem).UpdateRec("2","1","","")
ClassMethod UpdateRec(userId, uname, Rowid, code, Name, Active) As %String
{
	n (userId, uname,Rowid,code, Name, Active)
	
	k PLIST
	
	k ^temp
	s ^temp=Rowid_"*"_code_"*"_Name_"*"_Active
	s TableName="dhc_sync_data.Sync_System"
	s ClassName="dhc.sync.udata.SyncSystem"
	s ClassNameDesc="系统维护"
	s ObjectDesc="修改系统即产品组的信息"
	s NewValue="code:"_code_",name:"_Name_",active:"_Active
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"id:"_Rowid,ObjectDesc,"U",NewValue,userId,uname) 
	
	i code="" s code=$list(^dhcsyncSystemD(Rowid),2)	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid>0)&&(tmpRowid'=Rowid) "RepCode"
	
	i code			'="" s Plist(2)= code 
	i Name   		'="" s Plist(3)= Name       	      
	i Active  		'="" s Plist(4)= Active
	i code			'="" s Plist(5)= code_"_PublicKey.der"
	i code			'="" s Plist(6)= code_"_PKCS8_PrivateKey.pem"
	;w Rowid_"*"_code_"*"_Name_"*"_Active,! 
	         	
	&SQL(UPDATE  dhc_sync_data.Sync_System VALUES Plist() where %ID=:Rowid) 
	q SQLCODE
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-06-04
/// Description: 查询符合条件的记录
/// Table: dhc_sync_data.Sync_System
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.SyncSystem).List(0,10)
ClassMethod List(userId, uname, start, limit) As %String
{
	n (userId, uname,start,limit)
	
	s TableName="dhc_sync_data.Sync_System"
	s ClassName="dhc.sync.udata.SyncSystem"
	s ClassNameDesc="系统维护"
	s ObjectDesc="查询系统即产品组的信息"
	s NewValue=""
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"",ObjectDesc,"R",NewValue,userId, uname)
	
	s sqlStr="select Rowid,Code, Name, Active"
	_" from dhc_sync_data.Sync_System "
	_" where %id>0"
	
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^Code^Name^Active"
	While(result.Next())
	{  
		s rowid = result.Data("Rowid")
		s Code=result.Data("Code")
		s Name=result.Data("Name")
		s Active=result.Data("Active")	
		
		s tmp=rowid_"^"_Code_"^"_Name_"^"_Active
		
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
<Data name="SyncSystemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.sync.udata.SyncSystemD</DataLocation>
<DefaultData>SyncSystemDefaultData</DefaultData>
<IdLocation>^dhc.sync.udata.SyncSystemD</IdLocation>
<IndexLocation>^dhc.sync.udata.SyncSystemI</IndexLocation>
<StreamLocation>^dhc.sync.udata.SyncSystemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
