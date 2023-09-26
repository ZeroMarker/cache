Class dhc.bonus.udata.uInterLoc Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-11-11
/// Description: 查询符合条件的记录
/// Table：dhc.bonus.udata.InterLoc 
/// Input: searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uInterLoc).ListRec("Y","","","","",0,25,1)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit, inLocSetDr)
{
	n (active, searchField, searchValue, sortField, sortDir, start, limit,inLocSetDr)
	
	s sqlStr="SELECT InterLoc_rowid,InterLoc_jxUnitDr,InterLoc_order,InterLoc_code,InterLoc_name,InterLoc_patType"_
	",InterLoc_inLocSetDr,InterLoc_remark,InterLoc_active,InterLoc_jxUnitDr->BonusUnitName"_
	" ,InterLoc_jxUnitDr->EmployeeNo,InterLoc_jxUnitDr->BonusUnitCode FROM dhc_bonus_inter.InterLoc"
	
	s whereStr=" WHERE %ID>0"
	
	s whereStr=whereStr_" AND InterLoc_jxUnitDr->UnitFlag='"_inLocSetDr_"'"
	s sortStr=""
	s sortField1=""
	
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
	.i sortField="EmployeeNo" s sortField1="InterLoc_jxUnitDr->EmployeeNo"
	.i sortField=">BonusUnitCode" s sortField1="InterLoc_jxUnitDr->BonusUnitCode"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY InterLoc_order DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
    //w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="rowid^order^jxUnitDr^jxUnitName^code^name^Type^patType^inLocSetDr^remark^active^EmployeeNo^BonusUnitCode"
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
		
		s jxUnitName=result.Data("BonusUnitName")
		
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
		s EmployeeNo=result.Data("EmployeeNo")
		s BonusUnitCode=result.Data("BonusUnitCode")
	
		
		s tmp=rowid_"^"_order_"^"_jxUnitDr_"^"_jxUnitName_"^"_code_"^"_name_"^"_Type_"^"_patType_"^"_inLocSetDr_"^"_remark_"^"_active_"^"_EmployeeNo_"^"_BonusUnitCode
		
		i searchValue'="" d
		.q:(searchField = "order")&(order'[searchValue)
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

/// Creator: wang ying
/// CreatDate: 2010-11-11
/// Description: 代码是否存在
/// Table：dhc.bonus.udata.InterLoc 
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uInterLoc).IfRepCode(1,1,"101")
ClassMethod IfRepCode(jxUniteDr, inLocSetDr, code) As %String
{
	n (jxUniteDr,inLocSetDr,code)
	s rowid=0
	s rowid=$o(^dhcbsInterLoc(0,"JICode",jxUniteDr,inLocSetDr,code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: wang ying
/// CreatDate:  2010-11-11
/// Description: 插入新接口科室记录
/// Table:dhc.bonus.udata.InterLoc 
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.bonus.udata.uInterLoc).InsertRec("102^财务科^2^1^O^2^备注")
ClassMethod InsertRec(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s jxUnitDr=$p(data,"^",4)
		s code=$p(data,"^",1)
		s name=$p(data,"^",2)
		s order = $p(data,"^",3)
		s inLocSetDr = $p(data,"^",5)
		s remark = $p(data,"^",6)
		
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
		//i patType'="" s PLIST(9)=patType
			
		&sql(INSERT INTO dhc_bonus_inter.InterLoc VALUES PLIST())
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate:2010-11-11
/// Description: 更新新接口科室记录
/// Table:dhc.bonus.udata.InterLoc 
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.bonus.udata.uInterLoc).UpdataRec("103^监管科^2^财务科^I^1^^Y",1)
ClassMethod UpdataRec(data, id) As %String
{
		n (data,id)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s jxUnitDr = $p(data,"^",4)
		s code = $p(data,"^",1)
		s name = $p(data,"^",2)
		s order = $p(data,"^",3)
		s inLocSetDr = $p(data,"^",5)
		s remark = $p(data,"^",6)
		s active = $p(data,"^",7)
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
		 //s PLIST(9)=patType
			
		&sql(UPDATE dhc_bonus_inter.InterLoc VALUES PLIST() where %ID=:id)
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2010-11-11
/// Description: 查询符合条件的记录
/// Table：dhc.bonus.udata.InterLoc 
/// Input: searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uInterLoc).GetJXUnitIsEnd("","","","",0,25,"王")
ClassMethod GetJXUnitIsEnd(searchField, searchValue, sortField, sortDir, start, limit, str)
{
	n (searchField, searchValue, sortField, sortDir, start, limit,str)
	
	//SQL and UnitFlag=1
	s sqlStr="select BonusUnitID,BonusUnitCode,BonusUnitName from dhc_bonus_data.BonusUnit where %ID>0 and LastStage=1 "
	i str'="" d 
	s sqlStr=sqlStr_" and (BonusUnitCode like '"_str_"%' or BonusUnitName like '"_str_"%')"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	//w sqlStr,!
	s count=0
	s resultString=""
	s end = start + limit - 1
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="rowid^code^name"
	//取结构
	While(result.Next()){
		
		s rowid = result.Data("BonusUnitID")
		s code = result.Data("BonusUnitCode")
		s name = code_"_"_result.Data("BonusUnitName")
		
		s tmp=rowid_"^"_code_"^"_name
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
		
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:wang ying
/// CreatDate:2010-11-12
/// Description:删除接口科室
/// Table:dhc_bonus_inter.OutKpiRule
/// Input:rowid-接口科室rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.bonus.udata.uInterLoc).Delete(2)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_bonus_inter.InterLoc where InterLoc_rowid=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uInterLocS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
