Class dhc.pa.udata.uNYearsKPITarget Extends %Persistent [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2016-04-28
/// Description:查询KPITarget中维护的数据
/// Table:dhc_pa_data.KPITarget
/// Input:searchField-查询字段;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uNYearsKPITarget).List("","","",0,25)
ClassMethod List(searchField, sortField, sortDir, start, limit) As %String
{
	n (searchField,sortField, sortDir, start, limit)
	s sqlStr="SELECT KPITarget_rowid, KPITarget_KPIDr->KPIIndex1_name as kpiName, KPITarget_Name, KPITarget_Code, KPITarget_Coefficient, KPITarget_ChangeNum FROM dhc_pa_data.KPITarget"
	
	s whereStr=" WHERE %ID>0"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="KPITarget_rowid"
	.i sortField="kpiDr" s sortField1="KPITarget_KPIDr"
	.i sortField="targetName" s sortField1="KPITarget_Name"
	.i sortField="targetCode" s sortField1="KPITarget_Code"
	.i sortField="coefficient" s sortField1="KPITarget_Coefficient"
	.i sortField="changeNum" s sortField1="KPITarget_ChangeNum"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^kpiDr^targetName^targetCode^coefficient^changeNum"
	
	While(result.Next()){
		s rowid=result.Data("KPITarget_rowid")
		s kpiDr=result.Data("kpiName")
		s targetId=result.Data("KPITarget_Name")
		i targetId=1  s targetName="同期均值"
		e  i targetId=2  s targetName="年平均"
		e  s targetName=targetId
		s targetCode=result.Data("KPITarget_Code")
		s coefficient=result.Data("KPITarget_Coefficient")
		s changeNum=result.Data("KPITarget_ChangeNum")
		i (changeNum'="") s changeNum = $fn(changeNum,"",2)
		;i (changeNum<1)&&(changeNum>0)  s changeNum="0"_changeNum
		;i (changeNum<0)&&((changeNum>-1))  d
		.;s changeNum = "-0"_$zabs(changeNum)
		
		s tmp=rowid_"^"_kpiDr_"^"_targetName_"^"_targetCode_"^"_coefficient_"^"_changeNum
		
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:ban
/// CreatDate:2016-05-04
/// Description:根据指标判重复操作
/// Table:dhc_pa_data.KPITarget
/// Input:
/// Output:
/// Return:返回查询到的记录的Json串
/// Others：w ##class(dhc.pa.udata.uNYearsKPITarget).IfRepCode(2)
ClassMethod IfRepCode(code) As %String
{
	n (targetCode,code)
	s RowId=0
	s RowId=$o(^DHCCJXPAKPITargetI("IndexTargetKpiDr",code,RowId))
	i RowId="" d  s RowId=0
	q RowId
}

/// Creator：ban
/// CreatDate：2016-04-29
/// Description: 添加目标分类记录
/// Table：Table:dhc_pa_data.KPITarget
/// Input：Code-指标名称; targetName-目标分类名称; targetCode-目标分类代码; coefficient-年数; changeNum-增长率
/// Output：
/// Return：代码重复返回ReptargetName,名称重复返回ReptargetCode,否则返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uNYearsKPITarget).Insert("2","同期平均","1",3,0.25)
ClassMethod Insert(code, targetName, targetCode, coefficient, changeNum) As %String
{
	n (code,targetName,targetCode,coefficient,changeNum)
	;s ^sshjgfhgfjh = code
	s RowId=""
	s RowId=..IfRepCode(code)
	q:RowId'=0 "RepkpiDr"
	&SQL(INSERT INTO dhc_pa_data.KPITarget (KPITarget_KPIDr, KPITarget_Name, KPITarget_Code, KPITarget_Coefficient, KPITarget_ChangeNum) VALUES (:code,:targetName,:targetCode,:coefficient,:changeNum))
	q SQLCODE
}

/// Creator：ban
/// CreatDate：2016-04-29
/// Description: 添加目标分类记录
/// Table：Table:dhc_pa_data.KPITarget
/// Input：rowid-id;Code-指标名称; targetName-目标分类名称; targetCode-目标分类代码; coefficient-年数; changeNum-增长率
/// Output：
/// Return：代码重复返回ReptargetName,名称重复返回ReptargetCode,否则返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uNYearsKPITarget).Update(26,"59","","1",3,0.25)
ClassMethod Update(rowid, code, targetName, targetCode, coefficient, changeNum) As %String
{
	n (rowid,code, targetName, targetCode, coefficient, changeNum)
	
	i code="" d
	.s code=$list(^DHCCJXPAKPITargetD(rowid),2)
	i targetName="" d
	.s targetName=$list(^DHCCJXPAKPITargetD(rowid),3)
	s rowids=""
	s rowids=..IfRepCode(code)
	q:(rowids'=0)&(rowids'=rowid) "RepkpiDr"    
	
	&SQL(UPDATE dhc_pa_data.KPITarget SET KPITarget_KPIDr = :code,KPITarget_Name = :targetName,KPITarget_Code = :targetCode,KPITarget_Coefficient = :coefficient,KPITarget_ChangeNum = :changeNum where KPITarget_rowid = :rowid)
	q SQLCODE
}

/// Creator：ban
/// CreatDate：2016-04-29
/// Description: 添加目标分类记录
/// Table：Table:dhc_pa_data.KPITarget
/// Input：rowid-数据id
/// Output：
/// Return：代码重复返回ReptargetName,名称重复返回ReptargetCode,否则返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uNYearsKPITarget).unUseData(2)
ClassMethod unUseData(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_pa_data.KPITarget WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^dhc.pa.udata.uNYearsKPITargetS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
