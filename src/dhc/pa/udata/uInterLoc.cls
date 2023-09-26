Class dhc.pa.udata.uInterLoc Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-11-11
/// Description: 查询符合条件的记录
/// Table：dhc.pa.udata.InterLoc 
/// Input: searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uInterLoc).ListRec("Y","","","","DESC",0,25,1)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit, inLocSetDr)
{
	n (active, searchField, searchValue, sortField, sortDir, start, limit,inLocSetDr)
	
	s sqlStr="SELECT InterLoc_rowid,InterLoc_jxUnitDr,InterLoc_order,InterLoc_code,InterLoc_name,InterLoc_patType,InterLoc_inLocSetDr,InterLoc_remark,InterLoc_active FROM dhc_pa_inter.InterLoc"
	
	s whereStr=" WHERE %ID>0"
	
	s whereStr=whereStr_" AND InterLoc_inLocSetDr='"_inLocSetDr_"'"
	s sortStr=""
	s sortField1=""
	
	S sortField="jxUnitDr"
	i sortField'="" d
	.i sortField="rowid" s sortField1="InterLoc_rowid"
	.i sortField="order" s sortField1="InterLoc_order"
	.i sortField="jxUnitDr" s sortField1="InterLoc_jxUnitDr"
	.i sortField="code" s sortField1="InterLoc_code"
	.i sortField="name" s sortField1="InterLoc_name"
	.i sortField="patType" s sortField1="InterLoc_patType"
	.i sortField="inLocSetDr" s sortField1="InterLoc_inLocSetDr"
	.i sortField="remark" s sortField1="InterLoc_remark"
	.i sortField="active" s sortField1="InterLoc_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY InterLoc_order DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
    ;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	
	s jsonTitle="rowid^order^jxUnitDr^jxUnitName^code^name^Type^patType^inLocSetDr^remark^active"
	s patType=""
	s jxUnitName = ""
	While(result.Next())
	{
		
		s rowid=result.Data("InterLoc_rowid")
		s jxUnitDr=result.Data("InterLoc_jxUnitDr")
		;w jxUnitDr,!
		i jxUnitDr'="" d
		.i $d(^DHCCJXPAJXUNIT(jxUnitDr))  d
		..s jxUnitName=$p($g(^DHCCJXPAJXUNIT(jxUnitDr)),"^",3)
		s order=result.Data("InterLoc_order")
		s code=result.Data("InterLoc_code")
		s name=result.Data("InterLoc_name")
		s Type=result.Data("InterLoc_patType")
		i Type="I" s patType="住院"
		i Type="E" s patType="急诊"
		i Type="O" s patType="门诊"
		s inLocSetDr=result.Data("InterLoc_inLocSetDr")
		s remark=result.Data("InterLoc_remark")
		s active=result.Data("InterLoc_active")
		
		s tmp=rowid_"^"_order_"^"_jxUnitDr_"^"_jxUnitName_"^"_code_"^"_name_"^"_Type_"^"_patType_"^"_inLocSetDr_"^"_remark_"^"_active
		
		i searchValue'="" d
		.q:(searchField = "order")&(order'[searchValue)
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "jxUnitName")&(jxUnitName'[searchValue)
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

/// Creator: wang ying
/// CreatDate: 2010-11-11
/// Description: 代码是否存在
/// Table：dhc.pa.udata.InterLoc 
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.pa.udata.uInterLoc).IfRepCode(1,1,"101")
ClassMethod IfRepCode(jxUniteDr, inLocSetDr, code) As %String
{
	n (jxUniteDr,inLocSetDr,code)
	s rowid=0
	s rowid=$o(^DHCCJXPAINTERLOC(0,"JICode",jxUniteDr,inLocSetDr,code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: wang ying
/// CreatDate:  2010-11-11
/// Description: 插入新接口科室记录
/// Table:dhc.pa.udata.InterLoc 
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uInterLoc).InsertRec("102^财务科^2^1^O^2^备注")
ClassMethod InsertRec(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s jxUnitDr=$p(data,"^",4)
		s code=$p(data,"^",1)
		s name=$p(data,"^",2)
		s order = $p(data,"^",3)
		s patType = $p(data,"^",5)
		s inLocSetDr = $p(data,"^",6)
		s remark = $p(data,"^",7)
		
		s rowid=0
		s rowid=..IfRepCode(jxUnitDr,inLocSetDr,code)
		q:rowid>0 "RepCode"
		
		s active = "Y"
		
		i jxUnitDr'="" s PLIST(2)=jxUnitDr
		i order'="" s PLIST(3)=order
		i code'="" s PLIST(4)=code
		i name'="" s PLIST(5)=name
		i inLocSetDr'="" s PLIST(6)=inLocSetDr
		i remark'="" s PLIST(7)=remark
		i active'="" s PLIST(8)=active
		i patType'="" s PLIST(9)=patType
			
		&sql(INSERT INTO dhc_pa_inter.InterLoc VALUES PLIST())
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate:2010-11-11
/// Description: 更新新接口科室记录
/// Table:dhc.pa.udata.InterLoc 
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uInterLoc).UpdataRec("103^监管科^2^财务科^I^1^^Y",1)
ClassMethod UpdataRec(data, id) As %String
{
		n (data,id)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s jxUnitDr = $p(data,"^",4)
		s code = $p(data,"^",1)
		s name = $p(data,"^",2)
		s order = $p(data,"^",3)
		s patType = $p(data,"^",5)
		s inLocSetDr = $p(data,"^",6)
		s remark = $p(data,"^",7)
		s active = $p(data,"^",8)
		s rowid=0
		s rowid=..IfRepCode(jxUnitDr,inLocSetDr,code)
		q:(rowid'=0)&&(rowid'=id) "RepCode"
		
		
		 s PLIST(2)=jxUnitDr
		 s PLIST(3)=order
		 s PLIST(4)=code
		 s PLIST(5)=name
		 s PLIST(6)=inLocSetDr
		 s PLIST(7)=remark
		 s PLIST(8)=active
		 s PLIST(9)=patType
			
		&sql(UPDATE dhc_pa_inter.InterLoc VALUES PLIST() where %ID=:id)
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2010-11-11
/// Description: 查询符合条件的记录
/// Table：dhc.pa.udata.InterLoc 
/// Input: searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uInterLoc).GetJXUnitIsEnd("shortcut","重症","","",0,10)
ClassMethod GetJXUnitIsEnd(searchField, searchValue, sortField, sortDir, start, limit)
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	//SQL
	s sqlStr="select JXUnit_rowid,JXUnit_appSysDr,JXUnit_code,JXUnit_name,JXUnit_py,JXUnit_shortcut,JXUnit_type,JXUnit_jxLocTypeDr,JXUnit_isEnd,JXUnit_level,JXUnit_aDeptDr,JXUnit_parent,JXUnit_stratagemDr from dhc_pa_data.JXUnit"
	s whereStr=" where %ID>0"
	s whereStr=whereStr_" and JXUnit_isEnd ='Y'"
	
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
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	e  s sortStr=" order by %ID desc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	s count=0
	s resultString=""
	s end = start + limit - 1
	s json=##class(dhc.pa.comm.JsonObj).%New()
	
	s jsonTitle="rowid^appSysName^code^name^shortcut^py^locTypeName^unitName^parentName^stratagemName"
	//取结构
	While(result.Next()){
		//集体初始化
		s appSysName="不匹配",locTypeName="",deptName="",unitDr="",unitName="",stratagemName="",parentName=""
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
		//末端标志
		s isEnd = result.Data("JXUnit_isEnd")
		i isEnd="Y" s Flag="true"
		i isEnd="N" s Flag="false"
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
		
		s tmp=rowid_"^"_appSysName_"^"_code_"^"_name_"^"_shortcut_"^"_py_"^"_locTypeName_"^"_unitName_"^"_parentName_"^"_stratagemName
		
		i searchValue'="" d
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "shortcut")&(shortcut'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
		
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:wang ying
/// CreatDate:2010-11-12
/// Description:删除接口科室
/// Table:dhc_pa_inter.OutKpiRule
/// Input:rowid-接口科室rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uInterLoc).Delete(2)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_inter.InterLoc where InterLoc_rowid=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uInterLocS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
