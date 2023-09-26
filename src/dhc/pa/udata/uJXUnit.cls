/// Creator: 李明忠
/// CreatDate: 2010-07-27
/// Description: 绩效单元设置表维护
Class dhc.pa.udata.uJXUnit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-7-27
/// Description: 查询符合条件的绩效单元设置记录
/// Table：dhc_pa_data.JXUnit
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uJXUnit).List("","","","",0,25,"demo",60)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, parent) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit, parent)
	
	//规整查询条件
	s tmpEnd=""
	i parent="roo" s parent=0
	i parent'="" d
	.i $D(^DHCCJXPAJXUNIT(parent)) d
	..i $G(^DHCCJXPAJXUNIT(parent))'="" s tmpEnd=$P(^DHCCJXPAJXUNIT(parent),"^",13) //非末端
	..e  s tmpEnd="N"
	
	//SQL
	s sqlStr="select JXUnit_rowid,JXUnit_appSysDr,JXUnit_code,JXUnit_name,JXUnit_py,JXUnit_shortcut,JXUnit_type,JXUnit_jxLocTypeDr,JXUnit_isEnd,JXUnit_level,JXUnit_aDeptDr,JXUnit_parent,JXUnit_stratagemDr,JXUnit_End, JXUnit_isStop from dhc_pa_data.JXUnit"
	s whereStr=" where %ID>0"
	s whereStr=whereStr_" and JXUnit_parent ='"_parent_"'"
	
	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="JXUnit_rowid"
	.i sortField="appSysName" s sortField1="JXUnit_appSysDr"
	.i sortField="code" s sortField1="JXUnit_code"
	.i sortField="name" s sortField1="JXUnit_name"
	.i sortField="py" s sortField1="JXUnit_py"
	.i sortField="shortcut" s sortField1="JXUnit_shortcut"
	.i sortField="type" s sortField1="JXUnit_type"
	.i sortField="locTypeName" s sortField1="JXUnit_jxLocTypeDr"
	.i sortField="end" s sortField1="JXUnit_isEnd"
	.i sortField="level" s sortField1="JXUnit_level"
	.i sortField="depeName" s sortField1="JXUnit_aDeptDr"
	.i sortField="parentName" s sortField1="JXUnit_parent"
	.i sortField="stratagemName" s sortField1="JXUnit_stratagemDr"
	.i sortField="End" s sortField1="JXUnit_End"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	e  s sortStr=" order by JXUnit_code asc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s resultString="["
	
	s result=##class(%Library.ResultSet).%New()
	i (tmpEnd="N")||(parent=0) d
	.d result.Prepare(sqlStr)
	.d result.Execute()
	//取结构
	While(result.Next()){
		//集体初始化
		s appSysName="不匹配",locTypeName="",deptName="",unitDr="",unitName="",stratagemName="",parentName="",Flag=""
		
		s rowid = result.Data("JXUnit_rowid")
		//应用系统号
		s appSysDr = result.Data("JXUnit_appSysDr")
		i appSysDr=1 s appSysName="全院"
		i appSysDr=2 s appSysName="科室"
		i appSysDr=3 s appSysName="护理"
		i appSysDr=4 s appSysName="医疗"
		i appSysDr=5 s appSysName="个人"
		s code = result.Data("JXUnit_code")
		s name = result.Data("JXUnit_name")
		s py = result.Data("JXUnit_py")
		s shortcut = result.Data("JXUnit_shortcut")
		s type = result.Data("JXUnit_type")
		//科室类别
		s jxLocTypeDr = result.Data("JXUnit_jxLocTypeDr")
		i jxLocTypeDr'="" d
		.i $D(^DHCCJXPAJXLOCTYPE(jxLocTypeDr)) d
		..i $G(^DHCCJXPAJXLOCTYPE(jxLocTypeDr)) d
		...s locTypeName=$P(^DHCCJXPAJXLOCTYPE(jxLocTypeDr),"^",2)
		//是否参与绩效标志
		s isEnd = result.Data("JXUnit_isEnd")
		
		//末端标志
		s End = result.Data("JXUnit_End")
		i End="Y" s Flag="true"
		i End="N" s Flag="false"
		
		s level = result.Data("JXUnit_level")
		//部门
		s aDeptDr = result.Data("JXUnit_aDeptDr")
		i aDeptDr'="" d
		.i $D(^DHCCAUNITDEPTS(aDeptDr)) d
		..i $G(^DHCCAUNITDEPTS(aDeptDr)) d
		...s deptName=$P(^DHCCAUNITDEPTS(aDeptDr),"^",2)
		...s unitDr=$P(^DHCCAUNITDEPTS(aDeptDr),"^",8)
		...i unitDr'="" d
		....i $D(^DHCCAUNITS(unitDr)) d
		.....i $G(^DHCCAUNITS(unitDr)) d
		......s unitName=$P(^DHCCAUNITS(unitDr),"^",2)
		//单位信息
		s isStop = result.Data("JXUnit_isStop")
		//父级指标
		s parent = result.Data("JXUnit_parent")
		i parent'="" d
		.i $D(^DHCCJXPAJXUNIT(parent)) d
		..i $G(^DHCCJXPAJXUNIT(parent)) d
		...s parentName=$P(^DHCCJXPAJXUNIT(parent),"^",3)
		//战略目标
		
		s stratagemDr = result.Data("JXUnit_stratagemDr")
		
		i stratagemDr'="" d
		.i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
		..i $G(^DHCCJXPASTRATAGEM(stratagemDr)) d
		...s stratagemName=$P(^DHCCJXPASTRATAGEM(stratagemDr),"^",4)
		
		s resultString=resultString_"{id:'"_rowid_"',appSysDr:'"_appSysDr_"',appSysName:'"_appSysName_"',code:'"_code_"',name:'"_name_"',py:'"_py_"',shortcut:'"_shortcut_"',type:'"_type_"',jxLocTypeDr:'"_jxLocTypeDr_"',locTypeName:'"_locTypeName_"',isEnd:'"_isEnd_"',level:'"_level_"',unitDr:'"_unitDr_"',unitName:'"_unitName_"',aDeptDr:'"_aDeptDr_"',deptName:'"_deptName_"',parent:'"_parent_"',parentName:'"_parentName_"',stratagemDr:'"_stratagemDr_"',stratagemName:'"_stratagemName_"',End:'"_End_"',isStop:'"_isStop_"',leaf:"_Flag_",uiProvider:'col'},"
	}
		
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator:李明忠
/// CreatDate:2010-7-27
/// Description:删除绩效单元记录
/// Table:dhc_pa_data.JXUnit
/// Input:rowid-绩效单元记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uJXUnit).Delete(24)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	q:$D(^DHCCJXPAJXUNIT(0,"Parent",rowid)) "childNode"
	
	s str=""
	//寻找上级节点的ID
	s parentID=$P(^DHCCJXPAJXUNIT(rowid),"^",11)
	
	//1.删除本条记录
	&SQL(delete from dhc_pa_data.JXUnit where %ID=:rowid)
	s str=SQLCODE
	
	//2.如果该条记录的上级没有其他子节点,则将上级节点修改成一个子节点
	i $D(^DHCCJXPAJXUNIT(0,"Parent",parentID)) d
	.;不做任何处理
	e  d
	.i parentID'=0 d
	..&SQL(update dhc_pa_data.JXUnit set JXUnit_isEnd = 'Y' where %ID=:parentID)
	..s str=SQLCODE
	
	q str
}

/// Creator:李明忠
/// CreatDate:2010-7-27
/// Description:获取父节点(删除刷新功能)
/// Table:dhc_pa_data.JXUnit
/// Input:parent-绩效单元记录ID
/// Output: 
/// Return:返回父节点ID
/// Others:w ##class(dhc.pa.udata.uJXUnit).GetFatherNode(5)
ClassMethod GetFatherNode(parent) As %String
{
	n (parent)
	
	q:parent="" 0
	s parentID=0
	i $D(^DHCCJXPAJXUNIT(parent)) d
	.i $G(^DHCCJXPAJXUNIT(parent))'="" d
	..s parentID=$P(^DHCCJXPAJXUNIT(parent),"^",11)
	q parentID
}

/// Creator：李明忠
/// CreatDate：2010-7-27
/// Description: 根据传入的信息自动产生绩效单元代码
/// Table：dhc_pa_data.JXUnit
/// Input：parent-父节点;level-绩效单元级别
/// Output：
/// Return：返回自动生成的绩效单元Code
/// Others：w ##class(dhc.pa.udata.uJXUnit).AutoCode(1,2)
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
	i $D(^DHCCJXPAJXUNIT(0,"Parent",parent)) d
	.s childRow=$O(^DHCCJXPAJXUNIT(0,"Parent",parent,childRow),-1) q:childRow=""  d
	.i $D(^DHCCJXPAJXUNIT(childRow)) d
	..i $G(^DHCCJXPAJXUNIT(childRow))'="" d
	...s code=$P(^DHCCJXPAJXUNIT(childRow),"^",2)
	...s start=total-paramSubValue+1
	...s end=total
	...s len= $l(code)
	...;s nextCode=..GetNextCode($E(code,start,end))
	...s nextCode=..GetNextCode($E(code,len-1,len))
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
	i parent'=0 s parentCode=$P(^DHCCJXPAJXUNIT(parent),"^",2)
	i parent=0 d
	.s length2=$L($P(paramValue,"-",1))
	.f k=1:1:length2-1 d
	..s parentCode=parentCode_"0"
	
	//生成子节点的代码
	s childCode=parentCode_count
	
	q childCode
}

/// Creator：ban
/// CreatDate：205-07-21
/// Description: 根据父code，寻找子code
/// Table：dhc_pa_data.JXUnit
/// Input：Code-本级代码
/// Output：
/// Return：返回自动生成的绩效单元有效代码Code
/// Others：w ##class(dhc.pa.udata.uJXUnit).GetNextCodeByParent("1")
ClassMethod GetNextCodeByParent(parentId) As %String
{
	n (parentId)
	s code=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT max(JXUnit_Code) as code FROM dhc_pa_data.JXUnit WHERE JXUnit_parent='"_parentId_"'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s code = result.Data("code")
	}
	q code+1
}

/// Creator：李明忠
/// CreatDate：2010-7-29
/// Description: 根据下一个记录的有效代码
/// Table：dhc_pa_data.JXUnit
/// Input：Code-本级代码
/// Output：
/// Return：返回自动生成的绩效单元有效代码Code
/// Others：w ##class(dhc.pa.udata.uJXUnit).GetNextCode("1000")
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
/// CreatDate：2010-7-27
/// Description: 获取战略目标
/// Table：dhc_pa_data.CalUnit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效战略目标字符串
/// Others：w ##class(dhc.pa.udata.uJXUnit).GetStratagem(0,10,"")
ClassMethod GetStratagem(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Stratagem_rowid,Stratagem_name,Stratagem_shortcut from dhc_pa_data.Stratagem where %ID>0 and Stratagem_currStratagem='Y'"
	i str'="" s sqlStr = sqlStr_" and Stratagem_shortcut LIKE '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("Stratagem_rowid")
		s name = result.Data("Stratagem_name")
		s shortcut = result.Data("Stratagem_shortcut")
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
/// CreatDate：2010-7-27
/// Description: 获取科室类别
/// Table：dhc_pa_data.JXLocType
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效科室类别字符串
/// Others：w ##class(dhc.pa.udata.uJXUnit).GetLocType(0,10,"")
ClassMethod GetLocType(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXLocType_rowid,JXLocType_name,JXLocType_shortcut from dhc_pa_data.JXLocType where %ID>0 and JXLocType_active='Y'"
	i str'="" s sqlStr = sqlStr_" and JXLocType_shortcut like '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("JXLocType_rowid")
		s name = result.Data("JXLocType_name")
		s shortcut = result.Data("JXLocType_shortcut")
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
/// CreatDate：2010-7-27
/// Description: 获取单位
/// Table：dhc_ca_cache_data.Units
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.pa.udata.uJXUnit).GetUnit(0,10,"")
ClassMethod GetUnit(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Units_rowid,Units_name,Units_shortcut from dhc_ca_cache_data.Units where %ID>0 and Units_active='Y'"
	i str'="" s sqlStr = sqlStr_" and Units_shortcut like '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("Units_rowid")
		s name = result.Data("Units_name")
		s shortcut = result.Data("Units_shortcut")
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
/// CreatDate：2010-7-27
/// Description: 获取部门
/// Table：dhc_ca_cache_data.UnitDepts
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串;unitDr-单位ID
/// Output：
/// Return：有效部门字符串
/// Others：w ##class(dhc.pa.udata.uJXUnit).GetDept(0,10,"",1)
ClassMethod GetDept(start, limit, str, unitDr) As %String
{
	n (start, limit, str, unitDr)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitDepts_rowid,UnitDepts_name,UnitDepts_shortcut from dhc_ca_cache_data.UnitDepts where %ID>0 and UnitDepts_active='Y' and UnitDepts_unitDr="_unitDr
	i str'="" s sqlStr = sqlStr_" and UnitDepts_shortcut like '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("UnitDepts_rowid")
		s name = result.Data("UnitDepts_name")
		s shortcut = result.Data("UnitDepts_shortcut")
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
/// CreatDate：2010-7-27
/// Description: 判断绩效单元名称是否存在
/// Table：dhc_pa_data.JXUnit
/// Input：name-绩效单元名称
/// Output：
/// Return：返回rowid
/// Others：w ##class(dhc.pa.udata.uJXUnit).IfRepName("心内科")
ClassMethod IfRepName(name) As %String
{
	n (name)
	
	s rowid=0
	s rowid = $O(^DHCCJXPAJXUNIT(0,"Name",name,rowid))
	i rowid="" s rowid=0
	q rowid
}

/// Creator：李明忠
/// CreatDate：2010-7-27
/// Description: 添加绩效单元记录
/// Table：dhc_pa_data.JXUnit
/// Input：data-待插入数据(name^py^appSysDr^type^jxLocTypeDr^isEnd^level^deptDr^parent^stratagemDr^code^end);
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXUnit).Insert("4000^^2^^^N^0^^0^^住院科室^N")
ClassMethod Insert(data) As %String
{
	n (data)
	;w data,!
	q:data="" "dataEmpt"      				//空数据dataEmpt
	k PLIST
	
	s name=$p(data,"^",1)        
	s RowId=..IfRepName(name)
	q:RowId'=0 "RepName"
	i name'="" s PLIST(4)=name				//名称
	
	s parent=$p(data,"^",9)	
	s level=$p(data,"^",7)	
	s level=level+1
	
	s code=$p(data,"^",11)			//代码
	i code="" d
	.s code=..GetNextCodeByParent(parent)
	q:code="ParamErr" "ParamErr"
	q:code="null" "null"
	i code'="" s PLIST(3)=code 
			
	
	s py=$p(data,"^",2)                   	//拼音码
	i py'="" s PLIST(5)=py
	
	s shortcut=code_"-"_name				//快捷键
	i shortcut'="" s PLIST(6)=shortcut 
	
	s appSysDr=$p(data,"^",3)               //应用系统号
	i appSysDr'="" s PLIST(2)=appSysDr
	
	s type=$p(data,"^",4)					//类别编码
	i type'="" s PLIST(7)=type
	
	s jxLocTypeDr=$p(data,"^",5)			//科室类别
	i jxLocTypeDr'="" s PLIST(8)=jxLocTypeDr
	
	s isEnd=$p(data,"^",6)					//核算标志
	i isEnd'="" s PLIST(9)=isEnd
	
	i level'="" s PLIST(10)=level	
	
	s deptDr=$p(data,"^",8)					//科室
	i deptDr'="" s PLIST(11)=deptDr
	
	i parent'="" s PLIST(12)=parent	
	
	s stratagemDr=$p(data,"^",10)			//战略目标	
	
	s curreStratagem = stratagemDr
	i stratagemDr = "" d
	.f  s stratagemDr=$o(^DHCCJXPASTRATAGEM(stratagemDr)) q:stratagemDr=""  d
	..i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	...i $g(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	....s curreStratagem = $p(^DHCCJXPASTRATAGEM(stratagemDr),"^",14)
	....i curreStratagem="Y" d
	.....s curreStratagem = stratagemDr
	i curreStratagem'="" s PLIST(13)=curreStratagem

	s end=$p(data,"^",12)			//末端标志
	i end'="" s PLIST(14)=end
			
	&SQL(insert into dhc_pa_data.JXUnit VALUES PLIST())
	&sql(update dhc_pa_data.JXUnit  SET JXUnit_isStop ="N" where %ID=:%ROWID)
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-7-27
/// Description: 更新绩效单元记录
/// Table：dhc_pa_data.JXUnit
/// Input：rowid-所在行号;data-数据字符串(code^name^py^appSysDr^type^jxLocTypeDr^isEnd^level^deptDr^parent^stratagemDr);
/// Output：
/// Return：返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXUnit).Update(9,"003^单元三^dy3^1^1^1^N^0^1^0^1")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	
	q:rowid="" "rowidEmpt"					//错误数据
	q:data="" "dataEmpt"      				//空数据dataEmpt
	k PLIST
	
	s appSysDr=$p(data,"^",4) 				//应用系统号
	s PLIST(2)=appSysDr
	
	s code=$p(data,"^",1) 
	s PLIST(3)=code				//代码
	
	s name=$p(data,"^",2)        
	s RowId=..IfRepName(name)
	q:(RowId'=0)&(RowId'=rowid) "RepName"
	s PLIST(4)=name				//名称
	
	s py=$p(data,"^",3)                   	//拼音码
	s PLIST(5)=py
	
	s shortcut=code_"-"_name				//快捷键
	s PLIST(6)=shortcut
	
	s type=$p(data,"^",5)					//类别编码
	s PLIST(7)=type
	
	s jxLocTypeDr=$p(data,"^",6)			//科室类别
	s PLIST(8)=jxLocTypeDr
	
	s isEnd=$p(data,"^",7)					//核算标志
	s PLIST(9)=isEnd
	
	s level=$p(data,"^",8)	
	s PLIST(10)=level
	
	s deptDr=$p(data,"^",9)					//科室
	s PLIST(11)=deptDr
	
	s parent=$p(data,"^",10)
	s PLIST(12)=parent	
	
	s stratagemDr=$p(data,"^",11)			//战略目标
	
	s curreStratagem = stratagemDr
	i stratagemDr = "" d
	.f  s stratagemDr=$o(^DHCCJXPASTRATAGEM(stratagemDr)) q:stratagemDr=""  d
	..i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	...i $g(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	....s curreStratagem = $p(^DHCCJXPASTRATAGEM(stratagemDr),"^",14)
	....i curreStratagem="Y" d
	.....s curreStratagem = stratagemDr
	
	s PLIST(13)=curreStratagem
		
	
	s end=$p(data,"^",12)					//末端标志
	s PLIST(14)=end
	s isStop=$p(data,"^",13)					//末端标志
	
	&sql(update dhc_pa_data.JXUnit values PLIST() where %ID=:rowid)
	&sql(update dhc_pa_data.JXUnit  SET JXUnit_isStop =:isStop where %ID=:rowid)
	q SQLCODE
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
	&SQL(SELECT count(*) into:count FROM dhc_pa_data.JXUnit WHERE JXUnit_parent=:rowid AND JXUnit_isStop="N")
	if (count=0){
	&SQL(UPDATE dhc_pa_data.JXUnit SET JXUnit_isStop = 'Y' WHERE JXUnit_rowid =:rowid)
		s str=SQLCODE
	}else{
	   	s str="childNode"
	}

	
	q str
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uJXUnitS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
