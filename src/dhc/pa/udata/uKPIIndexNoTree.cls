Class dhc.pa.udata.uKPIIndexNoTree Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-7-21
/// Description: 查询符合条件的指标记录
/// Table：dhc_pa_data.KPIIndex1
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uKPIIndexNoTree).List("name","院","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	;s ^TMPWY(1)=searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	//规整查询条件
	s tmpEnd=""
	
	//SQL
	s sqlStr="SELECT KPIIndex1_rowid,KPIIndex1_code,KPIIndex1_name,KPIIndex1_shortcut,KPIIndex1_py,KPIIndex1_dimTypeDr,KPIIndex1_target,KPIIndex1_desc,KPIIndex1_calUnitDr,KPIIndex1_extreMum,KPIIndex1_expression,KPIIndex1_expDesc,KPIIndex1_colTypeDr,KPIIndex1_scoreMethodCode,KPIIndex1_colDeptDr,KPIIndex1_dataSource,KPIIndex1_isHospKPI,KPIIndex1_isDeptKPI,KPIIndex1_isMedKPI,KPIIndex1_isNurKPI,KPIIndex1_isPostKPI,KPIIndex1_parent,KPIIndex1_level,KPIIndex1_isStop,KPIIndex1_isEnd,KPIIndex1_order,KPIIndex1_isKPI FROM dhc_pa_data.KPIIndex1"
	s whereStr=" WHERE %ID>0"
	
	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="KPIIndex1_rowid"
	.i sortField="code" s sortField1="KPIIndex1_code"
	.i sortField="name" s sortField1="KPIIndex1_name"
	.i sortField="py" s sortField1="KPIIndex1_py"
	.i sortField="shortcut" s sortField1="KPIIndex1_shortcut"
	.i sortField="dimTypeName" s sortField1="KPIIndex1_dimTypeDr"
	.i sortField="target" s sortField1="KPIIndex1_target"
	.i sortField="desc" s sortField1="KPIIndex1_desc"
	.i sortField="calUnitName" s sortField1="KPIIndex1_calUnitDr"
	.i sortField="extreMumName" s sortField1="KPIIndex1_extreMum"
	.i sortField="expName" s sortField1="KPIIndex1_expression"
	.i sortField="expDesc" s sortField1="KPIIndex1_expDesc"
	.i sortField="colTypeName" s sortField1="KPIIndex1_colTypeDr"
	.i sortField="scoreMethodName" s sortField1="KPIIndex1_scoreMethodCode"
	.i sortField="colDeptName" s sortField1="KPIIndex1_colDeptDr"
	.i sortField="dataSource" s sortField1="KPIIndex1_dataSource"
	.i sortField="isHospKPI" s sortField1="KPIIndex1_isHospKPI"
	.i sortField="isDeptKPI" s sortField1="KPIIndex1_isDeptKPI"
	.i sortField="isMedKPI" s sortField1="KPIIndex1_isMedKPI"
	.i sortField="isNurKPI" s sortField1="KPIIndex1_isNurKPI"
	.i sortField="isPostKPI" s sortField1="KPIIndex1_isPostKPI"
	.i sortField="parentName" s sortField1="KPIIndex1_parent"
	.i sortField="level" s sortField1="KPIIndex1_level"
	.i sortField="isStop" s sortField1="KPIIndex1_isStop"
	.i sortField="isEnd" s sortField1="KPIIndex1_isEnd"
	.i sortField="order" s sortField1="KPIIndex1_order"
	.i sortField="isKPI" s sortField1="KPIIndex1_isKPI"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY KPIIndex1_code ASC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s resultString=""
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s end=start+limit-1
		
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="id^code^name^py^shortcut^dimTypeDr^dimTypeName^target^desc^calUnitDr^calUnitName^extreMum^extreMumName^expression^expName^expName2^expDesc^colTypeDr^colTypeName^scoreMethodCode^scoreMethodName^colDeptDr^colDeptName^dataSource^isHospKPI^isDeptKPI^isMedKPI^isNurKPI^isPostKPI^parent^parentName^level^isStop^isEnd^order^isKPI"

	
	
	//取结构
	While(result.Next()){
		//集体初始化
		s dimTypeName="",calUnitName="",expName="",expName2="",colTypeName="",unitName="",scoreMethodName="",colDeptName="",parentName="",extreMumName=""
		
		s rowid = result.Data("KPIIndex1_rowid")
		s code = result.Data("KPIIndex1_code")
		s name = result.Data("KPIIndex1_name")
		s py = result.Data("KPIIndex1_py")
		s shortcut = result.Data("KPIIndex1_shortcut")
		
		//维度
		s dimTypeDr = result.Data("KPIIndex1_dimTypeDr")
		i dimTypeDr'="" d
		.i $D(^DHCCJXPADIMENSTYPE(dimTypeDr)) d
		..i $G(^DHCCJXPADIMENSTYPE(dimTypeDr)) d
		...s dimTypeName=$P(^DHCCJXPADIMENSTYPE(dimTypeDr),"^",2)
		
		s target = result.Data("KPIIndex1_target")
		s desc = result.Data("KPIIndex1_desc")
		
		//计量单位
		s calUnitDr = result.Data("KPIIndex1_calUnitDr")
		i calUnitDr'="" d
		.i $D(^DHCCJXPACALUNIT(calUnitDr)) d
		..i $G(^DHCCJXPACALUNIT(calUnitDr)) d
		...s calUnitName=$P(^DHCCJXPACALUNIT(calUnitDr),"^",2)
		
		//极值
		s extreMum = result.Data("KPIIndex1_extreMum")
		i extreMum="H" s extreMumName="趋高"
		i extreMum="M" s extreMumName="趋中"
		i extreMum="L" s extreMumName="趋低"
		
		//表达式解析
		s expression = result.Data("KPIIndex1_expression")
		i expression'="" d
		.s expression=$E(expression,2,$L(expression)-1)
		.i expression'="" d
		..s expName=##class(dhc.pa.udata.uKPIIndex).TransStr(expression) //解析表达式(用于显示)
		..s expName2=##class(dhc.pa.udata.uKPIIndex).TransStr2(expression) //解析表达式(用于退格)
		
		s expDesc = result.Data("KPIIndex1_expDesc")
		
		//收集方式
		s colTypeDr = result.Data("KPIIndex1_colTypeDr")
		i colTypeDr=1 s colTypeName="录入"
		i colTypeDr=2 s colTypeName="计算"
		i colTypeDr=3 s colTypeName="无实际值"
		i colTypeDr=4 s colTypeName="采集"
		
		//评分方法
		s scoreMethodCode = result.Data("KPIIndex1_scoreMethodCode")
		i scoreMethodCode="I" s scoreMethodName="区间法"
		i scoreMethodCode="C" s scoreMethodName="比较法"
		i scoreMethodCode="D" s scoreMethodName="扣分法"
		i scoreMethodCode="A" s scoreMethodName="加分法"
		i scoreMethodCode="M" s scoreMethodName="目标参照法"
		
		//收集单位
		s colDeptDr = result.Data("KPIIndex1_colDeptDr")
		i colDeptDr'="" d
		.i $D(^DHCCJXPAJXUNIT(colDeptDr)) d
		..i $G(^DHCCJXPAJXUNIT(colDeptDr))'="" d
		...s colDeptName=$P(^DHCCJXPAJXUNIT(colDeptDr),"^",3)
		
		s dataSource = result.Data("KPIIndex1_dataSource")
		s isHospKPI = result.Data("KPIIndex1_isHospKPI")
		s isDeptKPI = result.Data("KPIIndex1_isDeptKPI")
		s isMedKPI = result.Data("KPIIndex1_isMedKPI")
		s isNurKPI = result.Data("KPIIndex1_isNurKPI")
		s isPostKPI = result.Data("KPIIndex1_isPostKPI")
		
		//父级指标
		s parent = result.Data("KPIIndex1_parent")
		i parent'="" d
		.i $D(^DHCCJXPAKPIINDEX1(parent)) d
		..i $G(^DHCCJXPAKPIINDEX1(parent)) d
		...s parentName=$P(^DHCCJXPAKPIINDEX1(parent),"^",2)
		
		s level = result.Data("KPIIndex1_level")
		s isStop = result.Data("KPIIndex1_isStop")
		
		//末端标志
		s isEnd = result.Data("KPIIndex1_isEnd")
		i isEnd="Y" s Flag="true"
		i isEnd="N" s Flag="false"
		
		s order = result.Data("KPIIndex1_order")
		s isKPI = result.Data("KPIIndex1_isKPI")
		
		s tmp=rowid_"^"_code_"^"_name_"^"_py_"^"_shortcut_"^"_dimTypeDr_"^"_dimTypeName_"^"_target_"^"_desc_"^"_calUnitDr_"^"_calUnitName_"^"_extreMum_"^"_extreMumName_"^"_expression_"^"_expName_"^"_expName2_"^"_expDesc_"^"_colTypeDr_"^"_colTypeName_"^"_scoreMethodCode_"^"_scoreMethodName_"^"_colDeptDr_"^"_colDeptName_"^"_dataSource_"^"_isHospKPI_"^"_isDeptKPI_"^"_isMedKPI_"^"_isNurKPI_"^"_isPostKPI_"^"_parent_"^"_parentName_"^"_level_"^"_isStop_"^"_isEnd_"^"_order_"^"_isKPI
		i searchValue'="" d
		.q:(searchField="code")&(code'[searchValue)
		.q:(searchField="name")&(name'[searchValue)
		.q:(searchField="shortcut")&(shortcut'[searchValue)
		.q:(searchField="desc")&(desc'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	d result.Close()
	s resultString=json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uKPIIndexNoTreeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
