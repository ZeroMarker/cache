/// Creator: 侯勃
/// CreatDate: 2013-03-27
/// Description: 报表管理
Class dhc.bonus.udata.uBonusReportManagement Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 侯勃
/// CreatDate: 2013-03-27
/// Description: 代码是否存在
/// Table：dhc.bonus.data.BonusReport
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uBonusReportManagement).IfRepCode("001")
ClassMethod IfRepCode(code) As %String
{
	new (code)
	s rowid=0
	s rowid=$o(^dhcbsReportI("RpCode",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 侯勃
/// CreatDate: 2013-03-27
/// Description: 名称是否存在
/// Table：dhc.bonus.data.BonusReport
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uBonusReportManagement).IfRepName("")
ClassMethod IfRepName(name) As %String
{
	new (name)
	s rowid=0
	s rowid=$o(^dhcbsReportI("RpName",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：侯勃
/// CreatDate：2013-03-28
/// Description: 查询
/// Table：dhc.bonus.data.BonusReport
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusReportManagement).List("","","","name",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{

	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="select BonusReportID,ReportCode, ReportName, ReportType, IsValid,IsPub "
	_" from dhc_bonus_data.BonusReport  where  IsValid =1"

	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="BonusReportID"
	.i sortField="code" s sortField1="ReportCode"
	.i sortField="name" s sortField1="ReportName"
	.i sortField="rpTypeID" s sortField1="ReportType"
	.i sortField="rpType" s sortField1="ReportType"
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
	s jsonTitle="rowid^code^name^rpTypeID^rpType^IsPub"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("BonusReportID")
		s code = result.Data("ReportCode")
		s name = result.Data("ReportName")
		s rpTypeID= result.Data("ReportType")
		s rpType= result.Data("ReportType")
		s IsPub= result.Data("IsPub")
		i rpType'="" d
		.i rpType="11" s rpType="横向扩展无图"
		.i rpType="21" s rpType="纵向扩展无图"
		.i rpType="22" s rpType="纵向扩展饼图"
		.i rpType="23" s rpType="纵向扩展柱图"
		
	    i IsPub=0 s IsPub="不发布"
		i IsPub=1 s IsPub="发布"
		
		s tmp=rowid_"^"_code_"^"_name_"^"_rpTypeID_"^"_rpType_"^"_ IsPub
		
		i searchValue'="" d
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "rpTypeID")&(rpTypeID'[searchValue)
		.q:(searchField = "rpType")&(rpType'[searchValue)
		
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

/// Creator：侯勃 
/// CreatDate：2013-03-28
/// Description: 查询明细
/// Table：dhc.bonus.data.TargetType
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uBonusReportManagement).ListCell("1","","","","",0,25)
ClassMethod ListCell(rowID, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (rowID,searchField, searchValue, sortField, sortDir, start, limit)
	//SQL
	s sqlStr="SELECT BonusReportCellID, case when BonusSchemeItemID>0 "
	  _" then BonusSchemeItemID->SchemeItemName else BonusTargetID->BonusTargetName end as itemName, "
	  _" CellType,ReportIndex,CellName, BackColor,FontBold"
	  _" from dhc_bonus_data.BonusReportCell "
	  _" where  IsValid= 1 and BonusReportID = '"_rowID_"'"
	  _" order by ReportIndex ASC"

	;w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="rowid^name^celltype^rpindex^cellName^FontBold^BackColor"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("BonusReportCellID")
		s name = result.Data("itemName")
		s celltype = result.Data("CellType")
		s rpindex = result.Data("ReportIndex")
		s cellName = result.Data("CellName")
		s BackColor = result.Data("BackColor")
		s FontBold = result.Data("FontBold")
		
		
		i celltype=1 s celltype="来源采集录入"		
		i celltype=2 s celltype="来源比例系数"	
		i celltype=3 s celltype="来源奖金方案"	
					
		s tmp=rowid_"^"_name_"^"_celltype_"^"_rpindex_"^"_cellName_"^"_ FontBold_"^"_BackColor
		
		i searchValue'="" d
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "celltype")&(celltype'[searchValue)
		.q:(searchField = "rpindex")&(rpindex'[searchValue)
		
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

/*
/// Creator：赵立国
/// CreatDate：2012-07-03
/// Description: 查询
/// Table：dhc.bonus.data.BonusEmployee
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusReportManagement).GetFileConfigList("4","1",0,25)
ClassMethod GetFileConfigList(loadfileID, fileTypeID, start, limit) As %String
{

	n (loadfileID,fileTypeID, start, limit)
	i fileTypeID=2 d
	.s sqlStr="select ImpEmpConfigID rowid,OnloadFileTypeID,OnloadFileTypeID->FileTypeName,CalculateGroupID,"
	.s sqlStr=sqlStr_" case CalculateGroupID when -4 then '科室编码'  when -3 then '科室名称' when -2 then '人员编码'"
	.s sqlStr=sqlStr_" when -1 then '人员名称' when 0 then '入职日期'  else "
	.s sqlStr=sqlStr_" CalculateGroupID->CalculateGroupName end as CalculateGroupName , ColNum, CreateDate"
	.s sqlStr=sqlStr_" from dhc_bonus_data.ImpEmpConfig where OnloadFileTypeID="_loadfileID

	i fileTypeID=1 d
	.s sqlStr="select ImpExcelConfigID rowid,OnloadFileID OnloadFileTypeID,OnloadFileID->FileTypeName,BonusTargetID CalculateGroupID,"
	.s sqlStr=sqlStr_" case BonusTargetID when -4 then '科室编码'  when -3 then '科室名称' when -2 then '人员编码'   when -1 then '人员名称' when 0 then '入职日期'  else "
	.s sqlStr=sqlStr_" BonusTargetID->BonusTargetName end as CalculateGroupName , ColNum, CreateDate "
	.s sqlStr=sqlStr_" from dhc_bonus_data.ImpExcelConfig where OnloadFileID ="_loadfileID
	
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
		s CalGroupName= result.Data("CalculateGroupName")
		s ColNum= result.Data("ColNum")
		
		s fileTypeName=""
		i fileTypeID=1 d
		.s fileTypeName="奖金数据"
		e  d
		.s fileTypeName="人员信息"
		
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
*/
/// Creator: 侯勃
/// CreatDate: 2013-03-27
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusReport
/// Input：code-代码;name-名称;configName-配置文件名称;fileType-配置文件类型，1：科室模板，2：人员模板
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusReportManagement).InsertRec("003","王五","4")
ClassMethod InsertRec(code, name, rpType, IsPub) As %String
{
	
	n (code, name, rpType,IsPub)
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"


	set isValid =1

	&sql(insert into dhc_bonus_data.BonusReport(ReportCode, ReportName, ReportType,IsValid,IsPub) values(:code,:name,:rpType,1,:IsPub))
	q SQLCODE
}

/// Creator: 侯勃
/// CreatDate: 2013-03-27
/// Description: 删除记录
/// Table：dhc.bonus.data.BonusReport
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uBonusReportManagement).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete  from dhc_bonus_data.BonusReportCell  WHERE BonusReportID=:rowid)
	
	&SQL(delete  from dhc_bonus_data.BonusReport  WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 侯勃
/// CreatDate: 2013-03-27
/// Description: 更新记录
/// Table：dhc.bonus.data.BonusReport
/// Input：rowId-所在行号;code-代码;name-名称;valid-有效;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusReportManagement).UpdateRec(8,"2","财务报表3","科室主任报表")
ClassMethod UpdateRec(rowid, code, name, rpType, IsPub) As %String
{
	
	n (rowid, code, name,rpType,IsPub)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepName"
	
	&sql(update dhc_bonus_data.BonusReport 
	  set ReportCode=:code,ReportName=:name,ReportType=:rpType,IsPub=:IsPub 
	   where %ID=:rowid)
	q SQLCODE
}

// Creator: guojing

/// CreatDate: 2016-07-21
/// Description: 判断添加奖金项是否重复
/// w ##class(dhc.bonus.udata.uBonusReportManagement).IfRepScheme(2,4)
ClassMethod IfRepScheme(BonusReportID, BonusSchemeItemID) As %String
{
	n (BonusReportID, BonusSchemeItemID)
	s rowid=0	
	s sdr=0
	s udr=0
	s pre=0	
	f  s rowid=$o(^dhcbsReportCellD(rowid)) q:(rowid="")||((sdr=BonusReportID)&&(udr=BonusSchemeItemID))  d
	.s sdr=$list(^dhcbsReportCellD(rowid),2)
	.s udr=$list(^dhcbsReportCellD(rowid),3)
	.i ((sdr=BonusReportID)&&(udr=BonusSchemeItemID)) s pre=rowid
	.e  s pre=0
	q pre
}

// Creator: guojing

/// CreatDate: 2016-07-21
/// Description: 判断添加指标项是否重复
/// w ##class(dhc.bonus.udata.uBonusReportManagement).IfRepTarget(2,40)
ClassMethod IfRepTarget(BonusReportID, BonusTargetID) As %String
{
	n (BonusReportID, BonusTargetID)
	s rowid=0	
	s sdr=0
	s udr=0
	s pre=0	
	f  s rowid=$o(^dhcbsReportCellD(rowid)) q:(rowid="")||((sdr=BonusReportID)&&(udr=BonusTargetID))  d
	.s sdr=$list(^dhcbsReportCellD(rowid),2)
	.s udr=$list(^dhcbsReportCellD(rowid),6)
	.i ((sdr=BonusReportID)&&(udr=BonusTargetID)) s pre=rowid
	.e  s pre=0
	q pre
}

/// Creator: 侯勃
/// CreatDate: 2013-03-27
/// Description: 添加奖金项目
/// Table： dhc_bonus_data.BonusReportCell
/// Input：
/// Output：
/// Return：
/// Others:w ##class(dhc.bonus.udata.uBonusReportManagement).InsertScheme("70","h19","2","cs")
ClassMethod InsertScheme(schemeid, rpindex, rowId, cellName) As %String
{
	n (schemeid, rpindex, rowId,cellName)
	
	s tmpDr=..IfRepScheme(rowId,schemeid)
	q:tmpDr'=0 "RepScheme"
	
	&sql(insert into dhc_bonus_data.BonusReportCell(BonusReportID, BonusSchemeItemID,ReportIndex,IsValid,BonusTargetID,CellType,cellName) 
	     values(:rowId,:schemeid,:rpindex,1,-1,3,:cellName))
	q SQLCODE
}

/// Creator: 侯勃
/// CreatDate: 2013-03-27
/// Description: 添加指标项目
/// Table： dhc_bonus_data.BonusReportCell
/// Input：
/// Output：
/// Return：
/// Others: w ##class(dhc.bonus.udata.uBonusReportManagement).InsertTarget("19_1","999","1")
ClassMethod InsertTarget(targetid, rpindex, rowId, cellName) As %String
{
	n (targetid, rpindex, rowId,cellName)
	
	s target        =$p(targetid,"_",1)
	s tmpDr=..IfRepTarget(rowId,target)
	q:tmpDr'=0 "RepTarget"
	
	s datasource         =$p(targetid,"_",2)
	
	i datasource = 4 d
	.s celltype = 1
	e  d
	.s celltype = 2
	
	
	
	;s ^gjtem20160722=targetid_","_rpindex_","_rowId_","_cellName_","_target_","_datasource_","_tmpDr
	
	;b ;   111
	&sql(insert into dhc_bonus_data.BonusReportCell(BonusReportID, BonusTargetID,
	ReportIndex,IsValid,BonusSchemeItemID,CellType,CellName) 
	     values(:rowId,:target,:rpindex,1,-1,:celltype,:cellName))
	q SQLCODE
}

/// Creator: 侯勃
/// CreatDate: 2013-03-27
/// Description: 修改明细
/// Table： dhc_bonus_data.BonusReportCell 
/// Input：
/// Output：
/// Return：
/// Others:w ##class(dhc.bonus.udata.uBonusReportManagement).UpdateCell("14","-1",23,12)
ClassMethod UpdateCell(rowId, rpindex, cellName, FontBold, BackColor) As %String
{
	n (rowId,rpindex,cellName,FontBold,BackColor)
	
	&sql(update dhc_bonus_data.BonusReportCell 
	set ReportIndex=:rpindex ,cellName=:cellName 
	,FontBold=:FontBold,BackColor=:BackColor
	where %ID=:rowId)
	
	q SQLCODE
}

/// Creator: 侯勃
/// CreatDate: 2013-03-277
/// Description: 删除明细
/// Table： dhc_bonus_data.BonusReportCell 
/// Input：
/// Output：
/// Return：
/// Others:w ##class(dhc.bonus.udata.uBonusReportManagement).DeleteCell(12)
ClassMethod DeleteCell(rowId) As %String
{
	n (rowId)
	
	&sql(delete from  dhc_bonus_data.BonusReportCell where %ID=:rowId )
	
	q SQLCODE
}

/// Creator：侯勃
/// CreatDate：2013-03-28
/// Description: 取出Combobox所许要的有效单位，获取指标类别
/// Table：
/// Input：
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.bonus.udata.uBonusReportManagement).TargetType(0,25,"")
ClassMethod TargetType(start, limit, str) As %String
{
	
	n (start, limit, str)

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select distinct TargetTypeID,TargetTypeName from dhc_bonus_data.TargetType where IsValid = 1"
	i str'="" s sqlStr = sqlStr_" and (LOWER(TargetTypeName) LIKE '"_str_"%'"_"or UPPER(TargetTypeName) LIKE '"_str_"%'"_"or TargetTypeID LIKE '%"_str_"%')"

	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr ,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("TargetTypeID")
		s name = result.Data("TargetTypeName")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator：侯勃
/// CreatDate：2013-03-28
/// Description: 取出Combobox所许要的有效单位，获取指标名称
/// Table：
/// Input：
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.bonus.udata.uBonusReportManagement).TargetName("2",0,25)
ClassMethod TargetName(targettype, start, limit) As %String
{
	
	n (targettype,start, limit)

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select distinct BonusTargetID,BonusTargetName,DataSource from dhc_bonus_data.BonusTarget "
	
	s whereStr=" where IsValid = 1 and DataSource in (1,4) and TargetTypeID = '"_targettype_"' "
	
	s sqlStr = sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr ,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusTargetID")
		s name = result.Data("BonusTargetName")
		s datasource = result.Data("DataSource")
		s rowid = rowid_"_"_datasource
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator：侯勃
/// CreatDate：2013-03-29
/// Description: 取出Combobox所许要的有效单位，获取奖金方案
/// Table：
/// Input：
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.bonus.udata.uBonusReportManagement).SchemeType(0,25,"")
ClassMethod SchemeType(start, limit, str) As %String
{
	
	n (start, limit, str)

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select distinct BonusSchemeID,BonusSchemeName from dhc_bonus_data.BonusScheme where IsValid = 1"
	i str'="" s sqlStr = sqlStr_" and (LOWER(TargetTypeName) LIKE '"_str_"%'"_"or UPPER(TargetTypeName) LIKE '"_str_"%'"_"or TargetTypeID LIKE '%"_str_"%')"

	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr ,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusSchemeID")
		s name = result.Data("BonusSchemeName")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator：侯勃
/// CreatDate：2013-03-29
/// Description: 取出Combobox所许要的有效单位，获取奖金项目
/// Table：
/// Input：
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.bonus.udata.uBonusReportManagement).SchemeName("1",0,25)
ClassMethod SchemeName(schemetype, start, limit) As %String
{
	
	n (schemetype,start, limit)

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select distinct BonusSchemeItemID,SchemeItemName from dhc_bonus_data.BonusSchemeItem "
	s whereStr=" where IsValid = 1 and BonusSchemeID = '"_schemetype_"' "
	
	s sqlStr = sqlStr_whereStr
	s sqlStr=sqlStr_" ORDER BY SchemeItemCode "
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr ,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusSchemeItemID")
		s name = result.Data("SchemeItemName")
		s tmp=rowid_"^"_name
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
<StreamLocation>^dhc.bonus.u5C1.uBonusReport8F5S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
