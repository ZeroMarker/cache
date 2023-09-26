Class dhc.bonus.udata.uBonusEmpReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: lwh
/// CreatDate: 2014-08-20
/// Description: 判断是否已存在
/// Table: dhc_bonus_data.BonusEmpReport
/// Input: BonusEmployeeID-人员ID; BonusReportID-报表ID;
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.bonus.udata.uBonusEmpReport).IfRepEmpReportDr("1","2")
ClassMethod IfRepEmpReportDr(BonusEmployeeID, BonusReportID) As %String
{
	n (BonusEmployeeID, BonusReportID)
	s rowid=0
	s rowid=$o(^dhcbsdataBonusEmpReportI("EmployUnitIndex",BonusEmployeeID,BonusReportID,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: lwh
/// CreatDate: 2014-08-20
/// Description: 增加报表权限
/// Table: dhc_bonus_data.BonusEmpReport
/// Input: BonusEmployeeID-人员ID; BonusReportID-报表ID;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others:w ##class(dhc.bonus.udata.uBonusEmpReport).InsertRec("1","2")
ClassMethod InsertRec(BonusEmployeeID, BonusReportID) As %String
{
	n (BonusEmployeeID, BonusReportID)
	
	//判断是否重复
	s rowid=0
	s rowid=..IfRepEmpReportDr(BonusEmployeeID, BonusReportID)
	q:rowid>0 "RepName"	
	
	&SQL(INSERT INTO dhc_bonus_data.BonusEmpReport (BonusEmployeeID,BonusReportID,UpdateDate) VALUES (:BonusEmployeeID, :BonusReportID,getdate()))
	
	q SQLCODE
}

/// Creator: lwh
/// CreatDate: 2014-08-20
/// Description: 更改某人员报表权限
/// Table: dhc_bonus_data.BonusEmpReport
/// Input: RowID-人员报表权限ID;BonusEmployeeID-人员ID; BonusReportID-报表ID;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusEmpReport).UpdateRec("1","","3")
ClassMethod UpdateRec(RowID, BonusEmployeeID, BonusReportID) As %String
{
	n (RowID, BonusEmployeeID, BonusReportID)
	
	//数组
	k PLIST	
	i BonusEmployeeID="" s BonusEmployeeID=$list(^dhcbsdataBonusEmpReportD(RowID),2)
	i BonusReportID=""      s BonusReportID=$list(^dhcbsdataBonusEmpReportD(RowID),3)
	
	//判断是否重复	
	s rowid=0
	s rowid=..IfRepEmpReportDr(BonusEmployeeID, BonusReportID)
	q:(rowid>0)&(rowid '=RowID) "RepName"
	
	i BonusEmployeeID'="" s Plist(2)= BonusEmployeeID 
	i BonusReportID'=""      s Plist(3)= BonusReportID 	
	 
    &SQL(UPDATE  dhc_bonus_data.BonusEmpReport VALUES Plist() where %ID=:RowID)
    &SQL(UPDATE  dhc_bonus_data.BonusEmpReport(UpdateDate) VALUES(getdate()) where %ID=:RowID)
	
	q SQLCODE
}

/// Creator: lwh
/// CreatDate: 2014-08-20
/// Description: 删除某人员报表权限
/// Table: dhc_bonus_data.BonusEmpReport
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uBonusEmpReport).Delete("26")
ClassMethod Delete(RowID) As %String
{
	&SQL(DELETE FROM dhc_bonus_data.BonusEmpReport WHERE BonusEmpReportID=:RowID)
	q SQLCODE
}

/// Creator: lwh
/// CreatDate: 2014-08-20
/// Description: 查询所有人员报表权限
/// Table：dhc_bonus_data.BonusEmpReport
/// Input: searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uBonusEmpReport).ListRec("","","","",0,25)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
		
	s result=##class(%Library.ResultSet).%New()
	s sqlStr="SELECT BonusEmpReportID,BonusEmployeeID,BonusEmployeeID->EmployeeName as BonusEmployeeName,BonusReportID,BonusReportID->ReportName as BonusReportName,UpdateDate from dhc_bonus_data.BonusEmpReport where %ID>0"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end = start + limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="RowId^BonusEmployeeID^EmployeeName^BonusReportID^ReportName^UpdateDate"
	While(result.Next())
	{
		s RowID=result.Data("BonusEmpReportID")
		s BonusEmployeeID=result.Data("BonusEmployeeID")
		s EmployeeName=result.Data("BonusEmployeeName")
		s BonusReportID=result.Data("BonusReportID")
		s ReportName=result.Data("BonusReportName")
		s UpdateDate=result.Data("UpdateDate")
		
		
		s tmp=RowID_"^"_BonusEmployeeID_"^"_EmployeeName_"^"_BonusReportID_"^"_ReportName_"^"_UpdateDate
	    i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1		
	}	
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: lwh
/// CreatDate: 2014-08-20
/// Description: 列出所有有效的人员
/// Table：dhc_bonus_data.BonusEmployee
/// Return： 人员id,人员name
/// Others: w ##class(dhc.bonus.udata.uBonusEmpReport).listEmployee("0","10","1")
ClassMethod listEmployee(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT BonusEmployeeID,EmployeeCode,EmployeeName FROM dhc_bonus_data.BonusEmployee WHERE IsValid =1"
	i str'="" s sqlStr = sqlStr_" and (EmployeeCode LIKE '%"_str_"%'"_" or EmployeeName LIKE '%"_str_"%') "
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusEmployeeID")
		s name = result.Data("EmployeeName")
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

/// Creator: lwh
/// CreatDate: 2014-08-20
/// Description: 列出所有有效的报表
/// Table：dhc_bonus_data.BonusReport
/// Return： 报表id,报表name
/// Others: w ##class(dhc.bonus.udata.uBonusEmpReport).listReport("0","10","1")
ClassMethod listReport(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select BonusReportID,ReportCode, ReportName from dhc_bonus_data.BonusReport  where  IsValid =1"
	i str'="" s sqlStr = sqlStr_" and (ReportCode LIKE '%"_str_"%'"_" or ReportName LIKE '%"_str_"%') "
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusReportID")
		s name = result.Data("ReportName")
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
<StreamLocation>^dhc.bonus8265.uBonusEmpReB1B5S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
