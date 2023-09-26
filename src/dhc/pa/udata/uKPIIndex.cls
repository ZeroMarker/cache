/// Creator: 李明忠
/// CreatDate: 2010-07-21
/// Description: KPI指标维护
Class dhc.pa.udata.uKPIIndex Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-7-21
/// Description: 查询符合条件的指标记录
/// Table：dhc_pa_data.KPIIndex1
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uKPIIndex).List("","","","",0,25,"roo")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, parent) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit, parent)
	
	//规整查询条件
	s tmpEnd=""
	i parent="roo" s parent=0
	i parent'="" d
	.i $D(^DHCCJXPAKPIINDEX1(parent)) d
	..i $G(^DHCCJXPAKPIINDEX1(parent))'="" s tmpEnd=$P(^DHCCJXPAKPIINDEX1(parent),"^",24)
	..e  s tmpEnd="N"
	
	//SQL
	s sqlStr="SELECT KPIIndex1_rowid,KPIIndex1_code,KPIIndex1_name,KPIIndex1_shortcut,KPIIndex1_py,KPIIndex1_dimTypeDr,KPIIndex1_target,KPIIndex1_desc,KPIIndex1_calUnitDr,KPIIndex1_extreMum,KPIIndex1_expression,KPIIndex1_expDesc,KPIIndex1_colTypeDr,KPIIndex1_scoreMethodCode,KPIIndex1_colDeptDr,KPIIndex1_dataSource,KPIIndex1_isHospKPI,KPIIndex1_isDeptKPI,KPIIndex1_isMedKPI,KPIIndex1_isNurKPI,KPIIndex1_isPostKPI,KPIIndex1_parent,KPIIndex1_level,KPIIndex1_isStop,KPIIndex1_isEnd,KPIIndex1_order,KPIIndex1_isKPI ,KPIIndex1_compType FROM dhc_pa_data.KPIIndex1"
	s whereStr=" WHERE %ID>0"
	s whereStr=whereStr_" AND KPIIndex1_parent ='"_parent_"'"
	
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
	s resultString="["
	
	s result=##class(%Library.ResultSet).%New()
	i (tmpEnd="N")||(parent=0) d
	.d result.Prepare(sqlStr)
	.d result.Execute()
	//取结构
	While(result.Next()){
		//集体初始化
		s dimTypeName="",calUnitName="",expName="",expName2="",colTypeName="",unitName="",scoreMethodName="",colDeptName="",parentName="",extreMumName="",importType="",dataSourceName=""
		
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
		..s expName=..TransStr(expression) //解析表达式(用于显示)
		..s expName2=..TransStr2(expression) //解析表达式(用于退格)
		
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
		i scoreMethodCode="K" s scoreMethodName="实际值法"
		
		//收集单位
		s colDeptDr = result.Data("KPIIndex1_colDeptDr")
		i colDeptDr'="" d
		.i $D(^DHCCJXPAJXUNIT(colDeptDr)) d
		..i $G(^DHCCJXPAJXUNIT(colDeptDr))'="" d
		...s colDeptName=$P(^DHCCJXPAJXUNIT(colDeptDr),"^",3)
		
		s dataSource = result.Data("KPIIndex1_dataSource")
		i dataSource=1  s dataSourceName="同期值"
		i dataSource=2  s dataSourceName="去年平均值"
		i dataSource=3  s dataSourceName="定值"
		
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
		i order=1  s importType="自动采集"
		i order=2  s importType="手工采集"
		s isKPI = result.Data("KPIIndex1_isKPI")
		
		
		//计算方式(扣分法)
		s calculationDr= result.Data("KPIIndex1_compType")
		s calculationName="" 
		i calculationDr=1 s calculationName="增长率计算"
		i calculationDr=2 s calculationName="增长量计算"
		i calculationDr=3 s calculationName="差额计算"
		i calculationDr=4 s calculationName="基础值上计算"
		
		;s resultString=resultString_"{id:'"_rowid_"',code:'"_code_"',name:'"_name_"',py:'"_py_"',shortcut:'"_shortcut_"',dimTypeDr:'"_dimTypeDr_"',dimTypeName:'"_dimTypeName_"',target:'"_target_"',desc:'"_desc_"',calUnitDr:'"_calUnitDr_"',calUnitName:'"_calUnitName_"',extreMum:'"_extreMum_"',extreMumName:'"_extreMumName_"',expression:'"_expression_"',expName:'"_expName_"',expName2:'"_expName2_"',expDesc:'"_expDesc_"',colTypeDr:'"_colTypeDr_"',colTypeName:'"_colTypeName_"',scoreMethodCode:'"_scoreMethodCode_"',scoreMethodName:'"_scoreMethodName_"',colDeptDr:'"_colDeptDr_"',colDeptName:'"_colDeptName_"',dataSource:'"_dataSource_"',isHospKPI:'"_isHospKPI_"',isDeptKPI:'"_isDeptKPI_"',isMedKPI:'"_isMedKPI_"',isNurKPI:'"_isNurKPI_"',isPostKPI:'"_isPostKPI_"',parent:'"_parent_"',parentName:'"_parentName_"',level:'"_level_"',isStop:'"_isStop_"',isEnd:'"_isEnd_"',order:'"_order_"',isKPI:'"_isKPI_"',leaf:"_Flag_",uiProvider:'col',calculationDr:'"_calculationDr_"',calculationName:'"_calculationName_"'},"
		;s resultString=resultString_"{id:'"_rowid_"',code:'"_code_"',name:'"_name_"',dimTypeDr:'"_dimTypeDr_"',dimTypeName:'"_dimTypeName_"',calUnitDr:'"_calUnitDr_"',calUnitName:'"_calUnitName_"',extreMum:'"_extreMum_"',extreMumName:'"_extreMumName_"',expression:'"_expression_"',expName:'"_expName_"',expName2:'"_expName2_"',expDesc:'"_expDesc_"',colTypeDr:'"_colTypeDr_"',colTypeName:'"_colTypeName_"',scoreMethodCode:'"_scoreMethodCode_"',scoreMethodName:'"_scoreMethodName_"',colDeptDr:'"_colDeptDr_"',colDeptName:'"_colDeptName_"',dataSource:'"_dataSource_"',isHospKPI:'"_isHospKPI_"',isDeptKPI:'"_isDeptKPI_"',isMedKPI:'"_isMedKPI_"',isNurKPI:'"_isNurKPI_"',isPostKPI:'"_isPostKPI_"',parent:'"_parent_"',leaf:"_Flag_",uiProvider:'col',calculationDr:'"_calculationDr_"',calculationName:'"_calculationName_"'},"

	
		;s resultString=resultString_"{id:'"_rowid_"',code:'"_code_"',name:'"_name_"',dimTypeDr:'"_dimTypeDr_"',dimTypeName:'"_dimTypeName_"',calUnitDr:'"_calUnitDr_"',calUnitName:'"_calUnitName_"',extreMum:'"_extreMum_"',extreMumName:'"_extreMumName_"',expression:'"_expression_"',expName:'"_expName_"',expName2:'"_expName2_"',expDesc:'"_expDesc_"',colTypeDr:'"_colTypeDr_"',colTypeName:'"_colTypeName_"',scoreMethodCode:'"_scoreMethodCode_"',scoreMethodName:'"_scoreMethodName_"',colDeptDr:'"_colDeptDr_"',colDeptName:'"_colDeptName_"',dataSource:'"_dataSource_"',isHospKPI:'"_isHospKPI_"',isDeptKPI:'"_isDeptKPI_"',isMedKPI:'"_isMedKPI_"',isNurKPI:'"_isNurKPI_"',isPostKPI:'"_isPostKPI_"',parent:'"_parent_"',isEnd:'"_isEnd_"',isKPI:'"_isKPI_"',level:'"_level_"',leaf:"_Flag_",uiProvider:'col',calculationDr:'"_calculationDr_"',calculationName:'"_calculationName_"'},"
		s resultString=resultString_"{id:'"_rowid_"',code:'"_code_"',name:'"_name_"',dimTypeDr:'"_dimTypeDr_"',dimTypeName:'"
		_dimTypeName_"',calUnitDr:'"_calUnitDr_"',calUnitName:'"_calUnitName_"',extreMum:'"_extreMum_"',extreMumName:'"_extreMumName_"',expression:'"_expression
		_"',expName:'"_expName_"',expName2:'"_expName2_"',expDesc:'"_expDesc_"',colTypeDr:'"_colTypeDr_"',scoreMethodCode:'"_scoreMethodCode_"',scoreMethodName:'"
		_scoreMethodName_"',colDeptDr:'"_colDeptDr_"',colDeptName:'"_colDeptName_"',dataSource:'"_dataSource_"',isDeptKPI:'"_isDeptKPI
		_"',parent:'"_parent_"',isEnd:'"_isEnd_"',isKPI:'"_isKPI_"',level:'"_level_"',leaf:"_Flag_",uiProvider:'col',calculationDr:'"
		_calculationDr_"',calculationName:'"_calculationName_"',target:'"_target_"',desc:'"_desc_"',order:'"_order_"',importType:'"_importType_"',dataSourceName:'"_dataSourceName_"',isStop:'"_isStop_"'},"
	
	}
		
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-7-21
/// Description: 获取特定字符串并装入字符串集合
/// Table：
/// Input：string-需要转换的计算表达式
/// Output：
/// Return：字符串集合
/// Others:w ##class(dhc.pa.udata.uKPIIndex).GetStrList("{<2>+<42>-<55>/[0.9*(<665>+1+<>)]}")
ClassMethod GetStrList(string) As %Library.ListOfDataTypes
{
	
	n (string)
	
	s StrList=##class(%Library.ListOfDataTypes).%New()
	f i=1:1:$L(string) d
	.i $E(string,i)="<" d
	..s k=..GetNextLocation(string,i)
	..d StrList.Insert($E(string,i,k))
	
	q StrList
}

/// Creator：李明忠
/// CreatDate：2010-7-21
/// Description: 转换给定的计算表达式(用于显示)
/// Table：
/// Input：string-需要转换的计算表达式
/// Output：
/// Return：返回新的计算表达式
/// Others:w ##class(dhc.pa.udata.uKPIIndex).TransStr("{<2>+<42>-<55>/[0.9*(<665>+1)]}")
ClassMethod TransStr(string) As %String
{
	s newStr=""
	
	s StrList=..GetStrList(string)
	q:StrList.Count()=0 string
	
	//遍历StrList
	s str=StrList.GetAt(1)
	s strLength=$L(str)
	s KPIName="不存在的指标" //默认初始化
	
	//"<45>"情况
	i strLength>2 d
	.s KPIDr=$E(str,2,strLength-1)
	.i KPIDr'="" d
	..i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
	...i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
	....s KPIName=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2)
	s length=$L(string,str)
	f m=1:1:length d
	.i m<length d
	..i newStr="" s newStr=$P(string,str,m)_KPIName
	..e  s newStr=newStr_$P(string,str,m)_KPIName
	.e  d
	..i newStr="" s newStr=$P(string,str,m)
	..e  s newStr=newStr_$P(string,str,m)
	s newStr=..TransStr(newStr)
	
	q newStr
}

/// Creator：李明忠
/// CreatDate：2010-7-21
/// Description: 根据给定的字符串和字符位置查询指定字符的位置
/// Table：
/// Input：string-指定字符的位置;num-"<"的占位位置
/// Output：
/// Return：返回指定字符的位置
/// Others:w ##class(dhc.pa.udata.uKPIIndex).GetNextLocation("(<1>+<2>*<3>/<>)",2)
ClassMethod GetNextLocation(string, num) As %String
{
	s flag="false"
	//定义">"位置
	s k=0 

	i $E(string,num+1)=">" d
	.s flag="true"
	.s k=num+1
	.q:flag="true"
	e  d
	.s k=..GetNextLocation(string,num+1)
	//.q:flag="true"
	
	q k
}

/// Creator：李明忠
/// CreatDate：2010-9-1
/// Description: 获取KPI指标
/// Table：dhc_pa_data.KPIIndex1
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效指标字符串
/// Others：w ##class(dhc.pa.udata.uKPIIndex).GetKPIs2(0,10,"")
ClassMethod GetKPIs2(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT KPIIndex1_rowid,KPIIndex1_name FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_colTypeDr<>2 and KPIIndex1_isEnd='Y'"
	i str'="" s sqlStr = sqlStr_" and KPIIndex1_shortcut LIKE '%"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
		s name = result.Data("KPIIndex1_name")
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

/// Creator：李明忠
/// CreatDate：2010-7-22
/// Description: 获取KPI指标
/// Table：dhc_pa_data.KPIIndex1
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效指标字符串
/// Others：w ##class(dhc.pa.udata.uKPIIndex).GetKPIs(0,10,"")
ClassMethod GetKPIs(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT KPIIndex1_rowid,KPIIndex1_name FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y'"
	i str'="" s sqlStr = sqlStr_" and KPIIndex1_shortcut LIKE '%"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
		s name = result.Data("KPIIndex1_name")
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

/// Creator:李明忠
/// CreatDate:2010-7-23
/// Description:删除指标记录
/// Table:dhc_pa_data.KPIIndex1
/// Input:rowid-指标记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uKPIIndex).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	q:$D(^DHCCJXPAKPIINDEX1(0,"Parent",rowid)) "childNode"
	
	s str=""
	//寻找上级节点的ID
	s parentID=$P(^DHCCJXPAKPIINDEX1(rowid),"^",21)
	
	//1.删除本条记录
	&SQL(delete from dhc_pa_data.KPIIndex1 where %ID=:rowid)
	;&SQL(delete dhc_pa_data.KPIIndex1 where %ID=:rowid)
	s str=SQLCODE
	
	//2.如果该条记录的上级没有其他子节点,则将上级节点修改成一个子节点
	i $D(^DHCCJXPAKPIINDEX1(0,"Parent",parentID)) d
	.;不做任何处理
	e  d
	.i parentID'=0 d
	..&SQL(update dhc_pa_data.KPIIndex1 set KPIIndex1_isEnd = 'Y' where %ID=:parentID)
	..s str=SQLCODE
	
	q str
}

/// Creator:李明忠
/// CreatDate:2010-7-25
/// Description:获取父节点(删除刷新功能)
/// Table:dhc_pa_data.KPIIndex1
/// Input:parent-指标记录ID
/// Output: 
/// Return:返回父节点ID
/// Others:w ##class(dhc.pa.udata.uKPIIndex).GetFatherNode(5)
ClassMethod GetFatherNode(parent) As %String
{
	n (parent)
	
	q:parent="" 0
	s parentID=0
	i $D(^DHCCJXPAKPIINDEX1(parent)) d
	.i $G(^DHCCJXPAKPIINDEX1(parent))'="" d
	..s parentID=$P(^DHCCJXPAKPIINDEX1(parent),"^",21)
	q parentID
}

/// Creator：李明忠
/// CreatDate：2010-7-23
/// Description: 获取维度
/// Table：dhc_pa_data.DimensType
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效指标字符串
/// Others：w ##class(dhc.pa.udata.uKPIIndex).GetDimType(0,10,"财务")
ClassMethod GetDimType(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DimensType_rowid,DimensType_name,DimensType_shortcut from dhc_pa_data.DimensType where %ID>0 and DimensType_active='Y'"
	i str'="" s sqlStr = sqlStr_" and DimensType_shortcut LIKE '%"_str_"%'"
	
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("DimensType_rowid")
		s name = result.Data("DimensType_name")
		s shortcut = result.Data("DimensType_shortcut")
		s tmp=rowid_"^"_name_"^"_shortcut
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name^shortcut",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-7-23
/// Description: 获取计量单位
/// Table：dhc_pa_data.CalUnit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效计量单位字符串
/// Others：w ##class(dhc.pa.udata.uKPIIndex).GetCalUnit(0,10,"")
ClassMethod GetCalUnit(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select CalUnit_rowid,CalUnit_name,CalUnit_shortcut from dhc_pa_data.CalUnit where %ID>0 and CalUnit_active='Y'"
	i str'="" s sqlStr = sqlStr_" and CalUnit_shortcut LIKE '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("CalUnit_rowid")
		s name = result.Data("CalUnit_name")
		s shortcut = result.Data("CalUnit_shortcut")
		s tmp=rowid_"^"_name_"^"_shortcut
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name^shortcut",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-7-23
/// Description: 获取单位
/// Table：dhc_nca_data.AUnit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.pa.udata.uKPIIndex).GetUnit(0,10,"")
ClassMethod GetUnit(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select AUnit_rowid,AUnit_name,AUnit_shortcut from dhc_nca_data.AUnit where %ID>0 and AUnit_active='Y'"
	i str'="" s sqlStr = sqlStr_" and AUnit_shortcut LIKE '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("AUnit_rowid")
		s name = result.Data("AUnit_name")
		s shortcut = result.Data("AUnit_shortcut")
		s tmp=rowid_"^"_name_"^"_shortcut
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name^shortcut",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-7-23
/// Description: 获取部门
/// Table：dhc_nca_data.ADept
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效部门字符串
/// Others：w ##class(dhc.pa.udata.uKPIIndex).GetDept(0,10,"")
ClassMethod GetDept(start, limit, str) As %String
{
	n (start, limit, str)
	
	s Stratagem = ""
	s curreStratagemDr = ""
	f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
	.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
	..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
	...s curreStratagem = $p(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
	...i curreStratagem="Y" d
	....s curreStratagemDr = Stratagem
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXUnit_rowid,JXUnit_name,JXUnit_shortcut from dhc_pa_data.JXUnit where %ID>0 and JXUnit_appSysDr=2 and JXUnit_isEnd='Y' and JXUnit_stratagemDr='"_curreStratagemDr_"'"
	i str'="" s sqlStr = sqlStr_" and JXUnit_shortcut LIKE '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("JXUnit_rowid")
		s name = result.Data("JXUnit_name")
		s shortcut = result.Data("JXUnit_shortcut")
		s tmp=rowid_"^"_name_"^"_shortcut
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name^shortcut",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-7-23
/// Description: 添加指标记录
/// Table：dhc_pa_data.KPIIndex1
/// Input：data-待插入数据(name^py^dimTypeDr^target^desc^calUnitDr^extreMum^expre^expreDesc^colTypeDr^scoreMethodCode^colDeptDr^dataSource^isHospKPI^isDeptKPI^isMedKPI^isNurKPI^isPostKPI^parent^level^isStop^isEnd^order^isKPI);
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPIIndex).Insert("33^^1^^^^^""""^^1^I^^^N^Y^N^N^N^0^0^N^N^^Y^020^")
ClassMethod Insert(data) As %String
{
	n (data)

	q:data="" "dataEmpt"      				//空数据dataEmpt
	k PLIST
	
	s name=$p(data,"^",1)        
	s RowId=..IfRepName(name)
	q:RowId'=0 "RepName"
	i name'="" s PLIST(3)=name				//名称
	
	s parent=$p(data,"^",19)	
	s level=$p(data,"^",20)	
	s level=level+1
	
	s code=$p(data,"^",25)				//是否是KPI
	s ret=0
    //先判断code是否为空，为空自动生成code，不为空就判断是否重复
    //q不能在if条件下，所以判重（RowIds'=0）后设置一个标志（ret ="1"）表示code重复
    i code'="" d
    .s RowIds=..IfRepCode(code)
    .i RowIds'=0  d
    ..s ret ="1"
    q:ret="1" "RepCode"
	i code="" d
	.s code=..AutoCode(parent,level)
	q:code="ParamErr" "ParamErr"
	q:code="null" "null"
	i code'="" s PLIST(2)=code  //代码
	
	s shortcut=code_"-"_name				//快捷键
	i shortcut'="" s PLIST(4)=shortcut 
	
	i parent'="" s PLIST(22)=parent			
	i level'="" s PLIST(23)=level			
	
	s py=$p(data,"^",2)                   	//拼音码
	i py'="" s PLIST(5)=py
	
	s dimTypeDr=$p(data,"^",3)				//维度类别
	i dimTypeDr'="" s PLIST(6)=dimTypeDr
	
	s target=$p(data,"^",4)					//评测目标
	i target'="" s PLIST(7)=target
	
	s desc=$p(data,"^",5)					//记录描述
	i desc'="" s PLIST(8)=desc
	
	s calUnitDr=$p(data,"^",6)				//计量单位
	i calUnitDr'="" s PLIST(9)=calUnitDr
	
	s extreMum=$p(data,"^",7)				//极值
	i extreMum'="" s PLIST(10)=extreMum
	
	s expre=$p(data,"^",8)					//表达式
	i expre'="" s PLIST(11)=expre
	
	s expreDesc=$p(data,"^",9)				//表达式描述
	i expreDesc'="" s PLIST(12)=expreDesc
	
	s colTypeDr=$p(data,"^",10)				//收集类型
	i colTypeDr'="" s PLIST(13)=colTypeDr
	
	s scoreMethodCode=$p(data,"^",11)		//评分方式
	i scoreMethodCode'="" s PLIST(14)=scoreMethodCode
	
	s colDeptDr=$p(data,"^",12)				//收集部门
	i colDeptDr'="" s PLIST(15)=colDeptDr
	
	s dataSource=$p(data,"^",13)			//数据源
	i dataSource'="" s PLIST(16)=dataSource
	
	s isHospKPI=$p(data,"^",14)				//医院KPI标志
	i isHospKPI'="" s PLIST(17)=isHospKPI
	
	s isDeptKPI=$p(data,"^",15)				//科室KPI标志
	i isDeptKPI'="" s PLIST(18)=isDeptKPI
	
	s isMedKPI=$p(data,"^",16)				//医疗KPI标志
	i isMedKPI'="" s PLIST(19)=isMedKPI
	
	s isNurKPI=$p(data,"^",17)				//护理KPI标志
	i isNurKPI'="" s PLIST(20)=isNurKPI
	
	s isPostKPI=$p(data,"^",18)				//岗位KPI标志
	i isPostKPI'="" s PLIST(21)=isPostKPI
	
	s isStop=$p(data,"^",21)			//是否停用标志
	i isStop'="" s PLIST(24)=isStop
	
	s isEnd=$p(data,"^",22)				//末端标志
	i isEnd'="" s PLIST(25)=isEnd
	
	s order=$p(data,"^",23)				//顺序号码
	i order'="" s PLIST(26)=order
	
	s isKPI=$p(data,"^",24)				//是否是KPI
	i isKPI'="" s PLIST(27)=isKPI
	
	s calculation=$p(data,"^",26)		//计算方式
	i calculation'="" s PLIST(29)=calculation

	&SQL(insert into dhc_pa_data.KPIIndex1 VALUES PLIST())

	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-7-23
/// Description: 判断指标名称是否存在
/// Table：dhc_pa_data.KPIIndex1
/// Input：name-指标名称
/// Output：
/// Return：返回rowid
/// Others：w ##class(dhc.pa.udata.uKPIIndex).IfRepName("101")
ClassMethod IfRepName(name) As %String
{
	n (name)
	
	s rowid=0
	s rowid = $O(^DHCCJXPAKPIINDEX1(0,"Name",name,rowid))
	i rowid="" s rowid=0
	q rowid
}

/// Creator：赵娜
/// CreatDate：2016-6-16
/// Description: 判断指标代码是否存在
/// Table：dhc_pa_data.KPIIndex1
/// Input：code-指标名称
/// Output：
/// Return：返回rowid
/// Others：w ##class(dhc.pa.udata.uKPIIndex).IfRepCode("890")
ClassMethod IfRepCode(code) As %String
{
    n (code)
    s rowid=0
    s rowid = $O(^DHCCJXPAKPIINDEX1(0,"Code",code,rowid))
    i rowid="" s rowid=0
    q rowid
}

/// Creator：李明忠
/// CreatDate：2010-7-23
/// Description: 根据传入的信息自动产生指标代码
/// Table：dhc_pa_data.KPIIndex1
/// Input：parent-父节点;level-指标级别
/// Output：
/// Return：返回自动生成的指标Code
/// Others：w ##class(dhc.pa.udata.uKPIIndex).AutoCode(22,1)
ClassMethod AutoCode(parent, level) As %String
{
	n (parent,level)
	
	q:parent="" "null"
	//取参数值
	s paramName="指标级别",paramValue=""
	s paramRow=0
	s paramRow=$O(^DHCCJXPAPARAM(0,"Name",paramName,paramRow))
	s Curr=$G(^DHCCJXPAPARAM(paramRow))
	i Curr'="" d
	.s paramValue=$P(Curr,"^",4)
	q:paramValue="" "ParamErr"
	//判断用分隔符隔开的参数值的深度
	s length=$L(paramValue,"-")
	q:(level>length) "ParamErr"
	//根据传入的指标级别取相应的参数值
	s paramSubValue=$P(paramValue,"-",level) 	//3:表示指标级别为3位数
	
	//位数总数
	s total=0
	f k=1:1:level d
	.s total=total+$P(paramValue,"-",k)
	
	//查询本条记录的代码并生成下条记录的部分子代码
	s childRow="",code="",count=0
	i $D(^DHCCJXPAKPIINDEX1(0,"Parent",parent)) d
	.s childRow=$O(^DHCCJXPAKPIINDEX1(0,"Parent",parent,childRow),-1) q:childRow=""  d
	.i $D(^DHCCJXPAKPIINDEX1(childRow)) d
	..i $G(^DHCCJXPAKPIINDEX1(childRow))'="" d
	...s code=$P(^DHCCJXPAKPIINDEX1(childRow),"^",1)
	...s start=total-paramSubValue+1
	...s end=total
	...s nextCode=..GetNextCode($E(code,start,end))
	...s count=nextCode+1
	e  d
	.s count=count+1
	
	s countLength=$L(count)
	//判断并生成子节点的部分代码
	q:(countLength>paramSubValue) "ParamErr"   //数量已经超过了3位数
	s lengthDiff=paramSubValue-countLength
	i lengthDiff>0 d
	.f i=1:1:lengthDiff d
	..s count="0"_count
	
	//查找父节点code
	s parentCode=""
	i parent'=0 s parentCode=$P(^DHCCJXPAKPIINDEX1(parent),"^",1)
	i parent=0 d
	.s length2=$L($P(paramValue,"-",1))
	.f k=1:1:length2-1 d
	..s parentCode=parentCode_"0"
	
	//生成子节点的代码
	s childCode=parentCode_count
	
	q childCode
}

/// Creator：李明忠
/// CreatDate：2010-7-29
/// Description: 根据下一个记录的有效代码
/// Table：dhc_pa_data.KPIIndex1
/// Input：Code-本级代码
/// Output：
/// Return：返回自动生成的有效代码Code
/// Others：w ##class(dhc.pa.udata.uKPIIndex).GetNextCode("004443")
ClassMethod GetNextCode(Code) As %String
{
	n (Code)
	s nextCode="",flag="false",k=0
	
	s Length = $L(Code)
	f i = 1:1:Length q:flag="true"  d
	.s subCode = $E(Code,i)
	.i subCode'=0 d
	..s flag="true"
	..s k = i
	
	s nextCode=$E(Code,k,$L(Code))
	q nextCode
}

/// Creator：李明忠
/// CreatDate：2010-7-23
/// Description: 转换给定的计算表达式(用于退格)
/// Table：
/// Input：string-需要转换的计算表达式
/// Output：
/// Return：返回新的计算表达式
/// Others:w ##class(dhc.pa.udata.uKPIIndex).TransStr2("<3>*{<2>+<42>-<55>/[0.9*(<665>+1)]}+<5>")
/// Others:w ##class(dhc.pa.udata.uKPIIndex).TransStr2("{2+42-55/[0.9*(665+1)]}")
/// Others:w ##class(dhc.pa.udata.uKPIIndex).TransStr2("不存在的指标!2+不存在的指标!42-不存在的指标!55/[0.9*(不存在的指标!665+1)]")
ClassMethod TransStr2(string) As %String
{
	s newStr=""
	
	s StrList=..GetStrList(string)
	
	//表示全部是数字和运算符,不包含指标在内
	i StrList.Count()=0 d 
	.i $L(string,"!")=1 d
	..f i=1:1:$L(string)-1 d
	...i newStr="" s newStr=$E(string,i)_"||"
	...e  s newStr=newStr_$E(string,i)_"||"
	..s newStr=newStr_$E(string,$L(string))
	.e  d
	..s length=$L(string,"||")
	..f k=1:1:length d
	...s subStr=$P(string,"||",k)
	...i subStr'="" d 
	....s subLength=$L(subStr,"!")
	....i subLength>1 d //表示指标
	.....i newStr="" s newStr=subStr
	.....e  s newStr=newStr_"||"_subStr
	....e  d //表示非指标
	.....s subLength2=$L(subStr)
	.....f m=1:1:subLength2 d
	......i newStr="" s newStr=$E(subStr,m)
	......e  s newStr=newStr_"||"_$E(subStr,m)
	
	//表示包含指标在内
	i StrList.Count()'=0 d 
	.;遍历StrList
	.s str=StrList.GetAt(1)
	.s strLength=$L(str)
	.s KPIName="不存在的指标" //默认初始化
	.s KPINameID="||"_KPIName_"!?||"
	.;"<45>"情况
	.i strLength>2 d
	..s KPIDr=$E(str,2,strLength-1)
	..i KPIDr'="" d
	...i $D(^DHCCJXPAKPIINDEX1(KPIDr)) s KPIName=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2)
	...s KPINameID="||"_KPIName_"!"_KPIDr_"||"
	.s length=$L(string,str)
	.f m=1:1:length d
	..i m<length d
	...i newStr="" s newStr=$P(string,str,m)_KPINameID
	...e  s newStr=newStr_$P(string,str,m)_KPINameID
	..e  d
	...i newStr="" s newStr=$P(string,str,m)
	...e  s newStr=newStr_$P(string,str,m)
	.s newStr=..TransStr2(newStr)
	
	q newStr
}

/// Creator：李明忠
/// CreatDate：2010-7-24
/// Description: 更新指标记录
/// Table：dhc_pa_data.KPIIndex1
/// Input：rowid-所在行号;data-数据字符串(code^name^py^dimTypeDr^target^desc^calUnitDr^extreMum^expre^expreDesc^colTypeDr^scoreMethodCode^colDeptDr^dataSource^isHospKPI^isDeptKPI^isMedKPI^isNurKPI^isPostKPI^parent^level^isStop^isEnd^order^isKPI);
/// Output：
/// Return：返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPIIndex).Update(97,"019^啊啊^^1^^^1^H^22%2^^2^D^^^N^Y^N^N^N^0^1^Y^Y^2^Y^2")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)

	q:rowid="" "rowidEmpt"					//错误数据
	q:data="" "dataEmpt"      				//空数据dataEmpt
	k PLIST
	
	s code=$p(data,"^",1) 
	i code'="" s PLIST(2)=code				//代码
	s RowId=..IfRepCode(code)
    q:(RowId'=0)&(RowId'=rowid) "RepCode"

	
	s name=$p(data,"^",2)        
	s RowId=..IfRepName(name)
	q:(RowId'=0)&(RowId'=rowid) "RepName"
	i name'="" s PLIST(3)=name				//名称
	
	s shortcut=code_"-"_name				//快捷键
	i shortcut'="" s PLIST(4)=shortcut
	
	s py=$p(data,"^",3)                   	//拼音码
	s PLIST(5)=py
	
	s dimTypeDr=$p(data,"^",4)				//维度类别
	s PLIST(6)=dimTypeDr
	
	s target=$p(data,"^",5)					//评测目标
	s PLIST(7)=target
	
	s desc=$p(data,"^",6)					//记录描述
	s PLIST(8)=desc
	
	s calUnitDr=$p(data,"^",7)				//计量单位
	s PLIST(9)=calUnitDr
	
	s extreMum=$p(data,"^",8)				//极值
	s PLIST(10)=extreMum
	
	s expre=$p(data,"^",9)					//表达式
	s PLIST(11)=""""_expre_""""				//2012-02-20 加""
	
	s expreDesc=$p(data,"^",10)				//表达式描述
	s PLIST(12)=expreDesc
	
	s colTypeDr=$p(data,"^",11)				//收集类型
	s PLIST(13)=colTypeDr

	s scoreMethodCode=$p(data,"^",12)		//评分方式
	s PLIST(14)=scoreMethodCode
	
	s colDeptDr=$p(data,"^",13)				//收集部门
	s PLIST(15)=colDeptDr
	
	s dataSource=$p(data,"^",14)			//数据源
	s PLIST(16)=dataSource
	
	s isHospKPI=$p(data,"^",15)				//医院KPI标志
	s PLIST(17)=isHospKPI
	
	s isDeptKPI=$p(data,"^",16)				//科室KPI标志
	s PLIST(18)=isDeptKPI
	
	s isMedKPI=$p(data,"^",17)				//医疗KPI标志
	s PLIST(19)=isMedKPI
	
	s isNurKPI=$p(data,"^",18)				//护理KPI标志
	s PLIST(20)=isNurKPI
	
	s isPostKPI=$p(data,"^",19)				//岗位KPI标志
	s PLIST(21)=isPostKPI
	
	s parent=$p(data,"^",20)
	s PLIST(22)=parent			//上级指标	
	
	s level=$p(data,"^",21)	
	s PLIST(23)=level			//指标级别
	
	s isStop=$p(data,"^",22)				//是否停用标志
	s PLIST(24)=isStop
	
	s isEnd=$p(data,"^",23)					//末端标志
	s PLIST(25)=isEnd
	
	s order=$p(data,"^",24)					//顺序号码
	s PLIST(26)=order
	
	s isKPI=$p(data,"^",25)					//是否是KPI
	s PLIST(27)=isKPI
	
	
	s calculation=$p(data,"^",26)		//计算方式
	
	i calculation'="" s PLIST(29)=calculation
	
	&sql(update dhc_pa_data.KPIIndex1 values PLIST() where %ID=:rowid)
	
	q SQLCODE
}

/// Creator：初雅莉
/// CreatDate：2016-7-20
/// Description: 自动生成KPI编码
/// Table：  dhc_pa_data.KPIIndex1
/// Others： w ##class(dhc.pa.udata.uKPIIndex).Lastcode("roo")
ClassMethod Lastcode(parent) As %String
{
	n (parent)
	s code=""
	/*&sql(select top 1 KPIIndex1_code into:code from dhc_pa_data.KPIIndex1 where KPIIndex1_parent=:parent order by KPIIndex1_code desc )
	s code=code+1
	s code="00"_code*/

	if (parent="roo"){
		&sql(select top 1 KPIIndex1_code into:code from dhc_pa_data.KPIIndex1 where KPIIndex1_parent=0 order by KPIIndex1_code desc )
	   s code=code+1
		if code>9 s code="0"_code
		if code<10 s code="00"_code
	}else{
		&sql(select  KPIIndex1_level into:level from dhc_pa_data.KPIIndex1 where KPIIndex1_rowid=:parent )
		s code= ..AutoCode(parent,level+1)
	}
	
	q code
}

/// Creator：初雅莉
/// CreatDate：2016-7-20
/// Description: 自动生成KPI编码
/// Table：  dhc_pa_data.KPIIndex1
/// Others： w ##class(dhc.pa.udata.uKPIIndex).StopKPI("roo")
ClassMethod StopKPI(rowid) As %String
{
	n (rowid)
	//停用的时候，要是非末级几点，要判断他下面的指标是否都为停用
	//如果都为停用，才能停用非末级指标
	s count=""
	&SQL(SELECT count(*) into:count FROM dhc_pa_data.KPIIndex1 WHERE KPIIndex1_parent=:rowid AND KPIIndex1_isStop="N")
	if (count=0){
	&SQL(UPDATE dhc_pa_data.KPIIndex1 SET KPIIndex1_isStop = 'Y' WHERE KPIIndex1_rowid =:rowid)
		s str=SQLCODE
	}else{
	   	s str="childNode"
	}

	
	q str
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uKPIIndexS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
