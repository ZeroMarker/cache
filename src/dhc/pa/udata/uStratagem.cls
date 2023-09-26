/// Creator: 李明忠
/// CreatDate: 2010-07-15
/// Description: 战略目标维护
Class dhc.pa.udata.uStratagem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2010-07-15
/// Description:根据绩效考核周期、单元、战略标示查询战略目标记录
/// Table:dhc_pa_data.Stratagem
/// Input:currStratagem-战略状态(Y-当前战略,N-非当前战略);unitDr-单元;cycleDr-考核周期ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uStratagem).List(1,1,"","name","2010","rowid","DESC",0,25)
/// Others:w ##class(dhc.pa.udata.uStratagem).List("Y","","","","","rowid","DESC",0,25)
ClassMethod List(currStratagem, unitDr, cycleDr, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (currStratagem, unitDr, cycleDr, searchField, searchValue, sortField, sortDir, start, limit)
			
	s sqlStr="select Stratagem_rowid,Stratagem_unitDr,Stratagem_cycleDr,Stratagem_code,Stratagem_name,Stratagem_shortcut,Stratagem_isVFlag,Stratagem_stateFlag,Stratagem_month,Stratagem_desc,Stratagem_linkFile,Stratagem_nurFlag,Stratagem_medFlag,Stratagem_postFlag,Stratagem_currStratagem from dhc_pa_data.Stratagem"
	s whereStr=" where %ID>0 and Stratagem_currStratagem='"_currStratagem_"'"
	i unitDr'="" s whereStr=whereStr_" and Stratagem_unitDr='"_unitDr_"'"
	i cycleDr'="" s whereStr=whereStr_" and Stratagem_cycleDr='"_cycleDr_"'"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="Stratagem_rowid"
	.i sortField="unitName" s sortField1="Stratagem_unitDr"
	.i sortField="cycleName" s sortField1="Stratagem_cycleDr"
	.i sortField="code" s sortField1="Stratagem_code"
	.i sortField="name" s sortField1="Stratagem_name"
	.i sortField="shortcut" s sortField1="Stratagem_shortcut"
	.i sortField="isVFlag" s sortField1="Stratagem_isVFlag"
	.i sortField="stateName" s sortField1="Stratagem_stateFlag"
	.i sortField="monthName" s sortField1="Stratagem_month"
	.i sortField="desc" s sortField1="Stratagem_desc"
	.i sortField="linkFile" s sortField1="Stratagem_linkFile"
	.i sortField="nurFlag" s sortField1="Stratagem_nurFlag"
	.i sortField="medFlag" s sortField1="Stratagem_medFlag"
	.i sortField="postFlag" s sortField1="Stratagem_postFile"
	.i sortField="currStratagem" s sortField1="Stratagem_currStratagem"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	e  s sortStr=" order by %ID desc"
	
	s sqlStr=sqlStr_whereStr_sortStr	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^unitDr^unitName^cycleDr^cycleName^code^name^shortcut^isVFlag^state^stateName^monthDr^monthName^desc^linkFile^nurFlag^medFlag^postFlag^currStratagem"
	
	While(result.Next()){
		;统一初始化
		s unitName="",cycleName="非法年份",stateName="非法状态标示",monthName="非法月份"
		s rowid=result.Data("Stratagem_rowid")
		s unitDr=result.Data("Stratagem_unitDr")
		i unitDr'="" d
		.i $D(^DHCCAUNITS(unitDr)) d
		..i $G(^DHCCAUNITS(unitDr))'="" d
		...s unitName=$P(^DHCCAUNITS(unitDr),"^",2)
	
		s cycleDr=result.Data("Stratagem_cycleDr")
		i cycleDr'="" d
		.i $D(^DHCCJXPACYCLE(cycleDr)) d
		..i $G(^DHCCJXPACYCLE(cycleDr))'="" d
		...s cycleName=$P(^DHCCJXPACYCLE(cycleDr),"^",2)
		s code=result.Data("Stratagem_code")
		s name=result.Data("Stratagem_name")
		s shortcut=result.Data("Stratagem_shortcut")
		s isVFlag=result.Data("Stratagem_isVFlag")
		s state=result.Data("Stratagem_stateFlag")
		i state="close" s stateName="已关闭"
		i state="new" s stateName="新增"
		i state="confirm" s stateName="已下达"
		s monthDr=result.Data("Stratagem_month")
		i (monthDr<12)&&(monthDr>0) d
		.s monthName=monthDr_"月"
		s desc=result.Data("Stratagem_desc")
		s linkFile=result.Data("Stratagem_linkFile")
		s nurFlag=result.Data("Stratagem_nurFlag")
		s medFlag=result.Data("Stratagem_medFlag")
		s postFlag=result.Data("Stratagem_postFlag")
		s currStratagem=result.Data("Stratagem_currStratagem")
		
		s tmp=rowid_"^"_unitDr_"^"_unitName_"^"_cycleDr_"^"_cycleName_"^"_code_"^"_name_"^"_shortcut_"^"_isVFlag_"^"_state_"^"_stateName_"^"_monthDr_"^"_monthName_"^"_desc_"^"_linkFile_"^"_nurFlag_"^"_medFlag_"^"_postFlag_"^"_currStratagem
		
		i searchValue'="" d
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "monthName")&(monthName'[searchValue)
		.q:(searchField = "stateName")&(stateName'[searchValue)
		.q:(searchField = "cycleName")&(cycleName'[searchValue)
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

/// Creator：李明忠
/// CreatDate：2010-7-15
/// Description: 取出Combobox所许要的有效单位
/// Table：dhc_nca_data.AUnit
/// Input：start:开始记录位置;limit:记录条数;str:模糊查询字段
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.pa.udata.uStratagem).UnitList(0,10,"")
ClassMethod UnitList(start, limit, str) As %String
{
	n (start, limit, str)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Units_rowid,Units_name from dhc_ca_cache_data.Units where %ID>0 and Units_active='Y'"
	i str'="" s sqlStr = sqlStr_" and Units_shortcut LIKE '"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("Units_rowid")
		s name = result.Data("Units_name")
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
/// CreatDate：2010-7-15
/// Description: 更新当前月份
/// Table：dhc_pa_data.Stratagem
/// Input：rowid:更新记录的ID;monthDr:月份ID
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.pa.udata.uStratagem).Refresh(0,10,"")
ClassMethod Refresh(rowid, monthDr) As %String
{
	n (rowid,monthDr)
	
	&SQL(update dhc_pa_data.Stratagem set Stratagem_month=:monthDr where %ID=:rowid)
	q SQLCODE
}

/// Creator: 李明忠
/// CreatDate: 2010-7-15
/// Description: 删除战略目标记录
/// Table：dhc_pa_data.Stratagem
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.pa.udata.uStratagem).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	/*
	&SQL(DELETE FROM dhc_pa_data.Stratagem WHERE %ID=:rowid)
	q SQLCODE
	*/
	
	q "0"
}

/// Creator：李明忠
/// CreatDate：2010-7-15
/// Description: 判断战略目标代码是否存在
/// Table：dhc_pa_data.Stratagem
/// Input：Code-战略目标代码
/// Output：
/// Return：如果为空就返回“0”，否则返回RowId值
/// Others：
ClassMethod IfRepCode(Code) As %String
{
	n (Code)
	s RowId=0
	s RowId=$o(^DHCCJXPASTRATAGEM(0,"Code",Code,RowId))
	i RowId="" d  s RowId=0
	q RowId
}

/// Creator：李明忠
/// CreatDate：2010-7-15
/// Description: 判断战略目标名称是否存在
/// Table：dhc_pa_data.Stratagem
/// Input：Name-战略目标名称
/// Output：
/// Return：如果为空就返回“0”，否则返回RowId值
/// Others：
ClassMethod IfRepName(Name) As %String
{
	n (Name)
	s RowId=0
	s RowId=$o(^DHCCJXPASTRATAGEM(0,"Name",Name,RowId))
	i RowId="" d  s RowId=0
	q RowId
}

/// Creator：李明忠
/// CreatDate：2010-7-15
/// Description: 添加战略目标记录
/// Table：dhc_pa_data.Stratagem
/// Input：UnitDr-单元ID;CycleDr-考核周期ID;Code-战略目标代码;Name-战略目标名称;State-科室绩效标示;MonthDr-当前核算月ID;Desc-目标概要;CurrStratagem-当前战略状态
/// Output：
/// Return：代码重复返回RepCode,名称重复返回RepName,否则返回执行插入语句后的SQLCODE
/// Others：
ClassMethod Insert(UnitDr, CycleDr, Code, Name, State, MonthDr, Desc, CurrStratagem) As %String
{
	n (UnitDr,CycleDr,Code,Name,State,MonthDr,Desc,CurrStratagem)
	
	s RowId=""
	s RowId=..IfRepCode(Code)
	q:RowId'=0 "RepCode"
	s RowId=..IfRepName(Name)
	q:RowId'=0 "RepName"
	
	s isVFlag="N" //虚拟标志
	s NurFlag="N" //护理标示
	s MedFlag="N" //医疗标示
	s PostFlag="N" //岗位标示
	s LinkFile="" //说明文件路径
	
	s ShortCut=Code_"-"_Name //快捷键
	
	&SQL(Insert Into dhc_pa_data.Stratagem(Stratagem_unitDr,Stratagem_cycleDr,Stratagem_code,Stratagem_name,Stratagem_shortcut,Stratagem_isVFlag,Stratagem_stateFlag,Stratagem_month,Stratagem_desc,Stratagem_linkFile,Stratagem_nurFlag,Stratagem_medFlag,Stratagem_postFlag,Stratagem_currStratagem) VAlUES(:UnitDr,:CycleDr,:Code,:Name,:ShortCut,:isVFlag,:State,:MonthDr,:Desc,:LinkFile,:NurFlag,:MedFlag,:PostFlag,:CurrStratagem))
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-7-16
/// Description: 更新战略目标记录
/// Table：dhc_pa_data.Stratagem
/// Input：Rowid-记录的ID;UnitDr-单元ID;CycleDr-考核周期ID;Code-战略目标代码;Name-战略目标名称;State-科室绩效标示;MonthDr-当前核算月ID;Desc-目标概要;CurrStratagem-当前战略状态;isVFlag-虚拟标志
/// Output：
/// Return：代码重复返回RepCode，名称重复返回RepName,否则返回执行更新语句后的SQLCODE
/// Others：
ClassMethod Update(Rowid, UnitDr, CycleDr, Code, Name, isVFlag, State, MonthDr, Desc, CurrStratagem) As %String
{
	n (Rowid, UnitDr, CycleDr, Code, Name, isVFlag, State, MonthDr, Desc, CurrStratagem)
	
	s RowId=""
	s RowId=..IfRepCode(Code)
	q:(RowId'=0)&(RowId'=Rowid) "RepCode"    
	s RowId=..IfRepName(Name)
	q:(RowId'=0)&(RowId'=Rowid) "RepName"
	
	s NurFlag="N" //护理标示
	s MedFlag="N" //医疗标示
	s PostFlag="N" //岗位标示
	s LinkFile="" //说明文件路径
	
	s ShortCut=Code_"-"_Name //快捷键
	
	&SQL(update dhc_pa_data.Stratagem set Stratagem_unitDr=:UnitDr,Stratagem_cycleDr=:CycleDr,Stratagem_code=:Code,Stratagem_name=:Name,Stratagem_shortcut=:ShortCut,Stratagem_isVFlag=:isVFlag,Stratagem_stateFlag=:State,Stratagem_month=:MonthDr,Stratagem_desc=:Desc,Stratagem_linkFile=:LinkFile,Stratagem_nurFlag=:NurFlag,Stratagem_medFlag=:MedFlag,Stratagem_postFlag=:PostFlag,Stratagem_currStratagem=:CurrStratagem where %ID=:Rowid)
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2011-9-20
/// Description: 更新战略目标记录
/// Table：dhc_pa_data.Stratagem
/// Input：Rowid-记录的ID;UnitDr-单元ID;CycleDr-考核周期ID;Code-战略目标代码;Name-战略目标名称;State-科室绩效标示;MonthDr-当前核算月ID;Desc-目标概要;CurrStratagem-当前战略状态;isVFlag-虚拟标志
/// Output：
/// Return：代码重复返回RepCode，名称重复返回RepName,否则返回执行更新语句后的SQLCODE
/// Others：
ClassMethod UpdateStragem() As %String
{
		
	&SQL(update dhc_pa_data.Stratagem set Stratagem_currStratagem='N' where Stratagem_rowid>0)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uStratagemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
