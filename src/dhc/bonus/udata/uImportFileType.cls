/// Creator: 赵立国
/// CreatDate: 2012-07-03
/// Description: 奖金数据导入模板配置
Class dhc.bonus.udata.uImportFileType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 赵立国
/// CreatDate: 2012-07-03
/// Description: 代码是否存在
/// Table：dhc.bonus.data.BonusEmployee
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uImportFileType).IfRepCode("001")
ClassMethod IfRepCode(code) As %String
{
	new (code)
	s rowid=0
	s rowid=$o(^dhcbsOnloadFileTypeI("Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 赵立国
/// CreatDate: 2012-7-3
/// Description: 名称是否存在
/// Table：dhc.bonus.data.BonusEmployee
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uImportFileType).IfRepName("")
ClassMethod IfRepName(name) As %String
{
	new (name)
	s rowid=0
	s rowid=$o(^dhcbsOnloadFileTypeI("ConfigName",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：赵立国
/// CreatDate：2012-07-03
/// Description: 查询
/// Table：dhc.bonus.data.BonusEmployee
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uImportFileType).List("","","","name",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{

	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="select OnloadFileTypeID,FileTypeCode, FileTypeName, FileTypeDesc, ConfigName,IsValid, FileType,TargetTable"
	_" from dhc_bonus_data.OnloadFileType  where  IsValid =1"

	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="OnloadFileTypeID"
	.i sortField="code" s sortField1="FileTypeCode"
	.i sortField="name" s sortField1="FileTypeName"
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
	s jsonTitle="rowid^code^name^configName^fileTypeID^fileTypeName^TargetTableName^TargetTable"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("OnloadFileTypeID")
		s code = result.Data("FileTypeCode")
		s name = result.Data("FileTypeName")
		s configName= result.Data("ConfigName")
		s fileTypeID= result.Data("FileType")
		s TargetTable= result.Data("TargetTable")
		
		s fileTypeName=""
		i fileTypeID=1 d
		.s fileTypeName="指标横向扩展"
		e  d
		.s fileTypeName="指标纵向扩展"
		s TargetTableName=""
		i TargetTable="dhc_bonus_data.BonusTargetCollect" s TargetTableName="奖金指标采集表"
		i TargetTable="dhc_bonus_module.BonusExpendCollect" s TargetTableName="支出项目采集表"
		i TargetTable="dhc_bonus_module.BonusIncomeCollect" s TargetTableName="收入项目采集表"
		i TargetTable="dhc_bonus_module.WorkItemCollect" s TargetTableName="工作量采集表"
		i TargetTable="dhc_bonus_module.DrgsItemCollect" s TargetTableName="Drgs数据采集表"
		i TargetTable="dhc_bonus_data.EmpBonusPay" s TargetTableName="人员工资发放表"
		
		s tmp=rowid_"^"_code_"^"_name_"^"_configName_"^"_fileTypeID_"^"_fileTypeName_"^"_TargetTableName_"^"_TargetTable
		
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

/// Creator：赵立国
/// CreatDate：2012-07-03
/// Description: 查询
/// Table：dhc.bonus.data.BonusEmployee
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uImportFileType).GetFileConfigList("4","1",0,25)
ClassMethod GetFileConfigList(loadfileID, fileTypeID, start, limit) As %String
{

	n (loadfileID,fileTypeID, start, limit)
	/*
	i fileTypeID=2 d
	.s sqlStr="select ImpEmpConfigID rowid,OnloadFileTypeID,OnloadFileTypeID->FileTypeName,CalculateGroupID,"
	.s sqlStr=sqlStr_" case CalculateGroupID when -4 then '科室编码'  when -3 then '科室名称' when -2 then '指标编码'"
	.s sqlStr=sqlStr_" when -1 then '指标名称' when 0 then '备注说明'  else "
	.s sqlStr=sqlStr_" CalculateGroupID->CalculateGroupName end as CalculateGroupName , ColNum, CreateDate"
	.s sqlStr=sqlStr_" from dhc_bonus_data.ImpEmpConfig where OnloadFileTypeID="_loadfileID
	*/
	;i fileTypeID=1 d
	s sqlStr="select ImpExcelConfigID rowid,OnloadFileID OnloadFileTypeID,OnloadFileID->FileTypeName,ItemCode CalculateGroupID,"
	s sqlStr=sqlStr_" ItemName , ColNum, CreateDate "
	s sqlStr=sqlStr_" from dhc_bonus_data.ImpExcelConfig where OnloadFileID ="_loadfileID
	s sqlStr=sqlStr_" order by ColNum"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^loadFileID^loadFileName^CalGroupID^CalGroupName^ColNum"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("rowid")
		s loadFileID = result.Data("OnloadFileTypeID")
		s loadFileName = result.Data("FileTypeName")
		s CalGroupID= result.Data("CalculateGroupID")
		s CalGroupName= result.Data("ItemName")
		s ColNum= result.Data("ColNum")

		
		i fileTypeID=1 d
		.s fileTypeName="指标横向扩展"
		i fileTypeID=2 d
		.s fileTypeName="指标纵向扩展"
		
		i fileTypeID=3 d
		.s fileTypeName="科室横向扩展"
		
		s tmp=rowid_"^"_loadFileID_"^"_loadFileName_"^"_CalGroupID_"^"_CalGroupName_"^"_ColNum
	
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1

	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：赵立国 
/// CreatDate：2012-07-03
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusEmployee
/// Input：code-代码;name-名称;configName-配置文件名称;fileType-配置文件类型，1：科室模板，2：人员模板
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uImportFileType).InsertRec("003","王五","4")
ClassMethod InsertRec(code, name, configName, fileType, TargetTable) As %String
{
	
	n (code,name,configName,fileType,TargetTable)
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"


	set isValid =1

	&sql(insert into dhc_bonus_data.OnloadFileType(FileTypeCode, FileTypeName, ConfigName,IsValid, FileType,TargetTable) values(:code,:name,:configName,1,:fileType,:TargetTable))
	q SQLCODE
}

/// Creator: 赵立国
/// CreatDate: 2012-07-03
/// Description: 删除记录
/// Table：dhc.bonus.data.BonusEmployee
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uImportFileType).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete  from dhc_bonus_data.OnloadFileType  WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator：赵立国
/// CreatDate：2012-07-03
/// Description: 更新记录
/// Table：dhc.bonus.data.BonusEmployee
/// Input：rowId-所在行号;code-代码;name-名称;valid-有效;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uImportFileType).UpdateRec(1,"","",1,"")
ClassMethod UpdateRec(rowId, code, name, configName, fileType, TargetTable) As %String
{
	
	n (rowId, code, name, configName,fileType,TargetTable)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(configName)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	// FileTypeCode, FileTypeName, FileTypeDesc, ConfigName,IsValid FileType
	
	&sql(update dhc_bonus_data.OnloadFileType set FileTypeCode=:code,FileTypeName=:name,ConfigName=:configName,FileType=:fileType,TargetTable=:TargetTable where %ID=:rowId)
	q SQLCODE
}

/// Creator：Zhao LIGuo 
/// CreatDate：2012-8-17
/// Description: 数据导入配置类型
/// Table： dhc_bonus_data.BonusCalculateTypeGroup 
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uImportFileType).GetFileConfig("1","dhc_bonus_module.DrgsItemCollect","",0,25)
ClassMethod GetFileConfig(fileTypeID, Target, str, start, limit) As %String
{
	n (fileTypeID,Target,str, start, limit)
	//q:fileTypeID="" 

	i Target="dhc_bonus_data.BonusTargetCollect" d
	.s sqlStr="SELECT BonusTargetID as rowid,BonusTargetCode as code,BonusTargetName as name FROM dhc_bonus_data.BonusTarget where 1=1"
	.s sqlStr=sqlStr _ " and BonusTargetName like '%"_str_"%'"
	
	i Target="dhc_bonus_module.BonusExpendCollect" d 
	.s sqlStr="SELECT %ID  as rowid,ItemCode as code,ItemName as name FROM dhc_bonus_module.BonusExpendItem WHERE IsLast=1 "
	.s sqlStr=sqlStr _ " and ItemName like '%"_str_"%'"
	
	i Target="dhc_bonus_module.BonusIncomeCollect" d 
	.s sqlStr="SELECT  TAREC_RowId as rowid,TAREC_Code as code,TAREC_Desc as name FROM DHC_TarEMCCate where 1=1"
	.s sqlStr=sqlStr _ " and TAREC_Desc like '%"_str_"%'"
	
	i Target="dhc_bonus_module.WorkItemCollect"  d 
    .s sqlStr="SELECT BonusWorkItemID as rowid,WorkItemCode as code,WorkItemName as name FROM dhc_bonus_module.BonusWorkItem where 1=1"
	.s sqlStr=sqlStr _" and WorkItemName	like '%"_str_"%' "	
	
	i Target="dhc_bonus_module.DrgsItemCollect"  d 
    .s sqlStr="SELECT %ID as rowid,DrgsCode as code,DrgsName as name FROM dhc_bonus_module.DrgsItem where IsLast =1 "
	.s sqlStr=sqlStr _" and (DrgsCode like '%"_str_"%' or DrgsName like '%"_str_"%')"	
	
	i Target="dhc_bonus_data.EmpBonusPay" d
	.s sqlStr="SELECT BonusTargetID as rowid,BonusTargetCode as code,BonusTargetName as name"
	.s sqlStr=sqlStr _" FROM dhc_bonus_data.BonusTarget where DataSource=1 "
	.s sqlStr=sqlStr _ " and BonusTargetName like '%"_str_"%'"
	
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	;k ^cwtemp
	;s ^cwtemp=sqlStr
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="rowid^code^name"
	
	i Target="dhc_bonus_data.EmpBonusPay" d
	.s fileTypeID=""
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-1^G1^员工工号")
	.s count=count+1
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-2^G2^员工姓名")
	.s count=count+1
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-3^G3^归属科室")
	.s count=count+1
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-4^G4^发放科室")
	.s count=count+1	
	
	
	i fileTypeID=1 d
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-2^G2^科室编码")
	.s count=count+1
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-1^G1^科室名称")
	.s count=count+1
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-7^G7^科室类别")
	.s count=count+1
	
	i fileTypeID=2 d
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-2^G2^科室编码")
	.s count=count+1
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-1^G1^科室名称")
	.s count=count+1
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-4^G4^指标编码")
	.s count=count+1
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-3^G3^指标名称")
	.s count=count+1
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-5^G5^指标数量")
	.s count=count+1
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-6^G6^指标单价")
	.s count=count+1
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-7^G7^科室类别")
	.s count=count+1

	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-99^G99^备注说明")
	.s count=count+1
	
	i fileTypeID=3 d
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-4^G4^指标编码")
	.s count=count+1
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-3^G3^指标名称")
	.s count=count+1
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData("-5^G5^科室扩展")
	.s count=count+1
	
	//取结构
	While(result.Next()){
		
		s rowid = result.Data("rowid")
		s code = result.Data("code")
		s name = result.Data("name")
					
		s tmp=code_"^"_code_"^"_name
		

		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：Zhao LIGuo 
/// CreatDate：2012-8-17
/// Description: 添加数据导入配置类型
/// Table： dhc_bonus_data.BonusCalculateTypeGroup 
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uImportFileType).InsertFileConfig(2,8,-2,9)
ClassMethod InsertFileConfig(fileType, OnloadFileTypeID, CalculateGroupID, CalculateGroupName, ColNum) As %String
{
	n (fileType,OnloadFileTypeID,CalculateGroupID,CalculateGroupName,ColNum)
	
	;k ^zlgtem
	;s ^zlgtem=fileType_"^"_OnloadFileTypeID_"^"_CalculateGroupID_","
	
	s s=0	
	s s1=""
	&sql(select count(*) into :s1 from  dhc_bonus_data.ImpExcelConfig where OnloadFileID=:OnloadFileTypeID and  ItemCode=:CalculateGroupID)
	q:s1>0 "RepCode"
	s s1=""	
	&sql(select count(*) into :s1 from  dhc_bonus_data.ImpExcelConfig where OnloadFileID=:OnloadFileTypeID and  ColNum=:ColNum)
	q:s1>0 "RepCol"
	s s1=0
	s s1=$p(ColNum,".",2)
	q:s1>0 "RepColNum"
	
	&sql(insert into dhc_bonus_data.ImpExcelConfig(OnloadFileID, ItemCode,ItemName,ColNum, CreateDate) 
	values(:OnloadFileTypeID,:CalculateGroupID,:CalculateGroupName,:ColNum,getdate())
		)
	q SQLCODE
}

/// 判断表里面是否存在，存在返回id，不存在返回0
/// w ##class(dhc.bonus.udata.uImportFileType).RepCode("7","02001")
ClassMethod RepCode(OnloadFileID, ItemCode) As %String
{
	n (OnloadFileID,ItemCode)
	s sqlStr="SELECT * from  dhc_bonus_data.ImpExcelConfig WHERE  OnloadFileID ='"_OnloadFileID_"' AND ItemCode ='"_ItemCode_"' "
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("ImpExcelConfigID")
	}
	q rowid
}

/// Creator：Zhao LIGuo 
/// CreatDate：2012-8-17
/// Description: 添加数据导入配置类型
/// Table： dhc_bonus_data.BonusCalculateTypeGroup 
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uImportFileType).UpdateFileConfig(2,3,"101","234",12,50)
ClassMethod UpdateFileConfig(fileType, OnloadFileTypeID, CalculateGroupID, CalculateGroupName, ColNum, rowID) As %String
{
	n (fileType, OnloadFileTypeID, CalculateGroupID,CalculateGroupName, ColNum, rowID)
	/*
	i fileType=2 d
	.&sql(update dhc_bonus_data.ImpEmpConfig set OnloadFileTypeID=:OnloadFileTypeID,CalculateGroupID=:CalculateGroupID where %ID=:rowID)
	*/
	s tmpRowid =..RepCode(OnloadFileTypeID,CalculateGroupID)
	q:(tmpRowid'=0)&(tmpRowid'=rowID) "RepCode"
	
	&sql(update dhc_bonus_data.ImpExcelConfig set OnloadFileID=:OnloadFileTypeID,ItemCode=:CalculateGroupID,ItemName=:CalculateGroupName,ColNum=:ColNum,CreateDate=getdate() where %ID=:rowID)
	q SQLCODE
}

/// Creator：Zhao LIGuo 
/// CreatDate：2012-8-17
/// Description: 添加数据导入配置类型
/// Table： dhc_bonus_data.BonusCalculateTypeGroup 
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uImportFileType).DeleteFileConfig(12)
ClassMethod DeleteFileConfig(fileType, rowID) As %String
{
	n (fileType,rowID)
	
	;i fileType=2 d
	;&sql(delete from  dhc_bonus_data.ImpEmpConfig  where %ID=:rowID)
	
	;i fileType=1 d
	&sql(delete from  dhc_bonus_data.ImpExcelConfig where %ID=:rowID )
	
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uImportFileT612S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
