/// Creator: Zhao LiGuo
/// CreatDate: 2010-11-15
/// Description: 接口指标表维护
Class dhc.bonus.udata.uInterKPI Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Zhao LiGuo
/// CreatDate: 2010-11-15
/// Description: 查询符合条件的记录
/// Table：dhc.bonus.udata.InterLoc 
/// Input: searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uInterKPI).ListRec("Y","","","","",0,25,121)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit, inKPIDr)
{
	n (active, searchField, searchValue, sortField, sortDir, start, limit,inKPIDr)
	
	s sqlStr="SELECT InterKPI_rowid,InterKPI_kpiDr,InterKPI_kpiDr->BonusTargetName"_
	" ,InterKPI_okrDr,InterKPI_okrDr->OutKpiRule_outKpiCode,InterKPI_okrDr->OutKpiRule_outKpiName"_
	" ,InterKPI_okrDr->OutKpiRule_inLocSetDr,InterKPI_okrDr->OutKpiRule_inLocSetDr->InterLocSet_name"_
	" ,InterKPI_remark,InterKPI_active FROM dhc_bonus_inter.InterKPI"
	s whereStr=" WHERE %ID>0"
	
	s whereStr=whereStr_" AND InterKPI_kpiDr='"_inKPIDr_"'"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InterKPI_rowid"
	.i sortField="kpiDr" s sortField1="InterKPI_kpiDr"
	.i sortField="kpirlue" s sortField1="InterKPI_okrDr"
	.i sortField="remark" s sortField1="InterKPI_remark"
	.i sortField="active" s sortField1="InterKPI_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY InterKPI_rowid DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
   // w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s code="",name=""
	s jsonTitle="rowid^KPIDr^kpirule^KPIName^code^name^locSetDr^locSetName^remark^active"
	s KPIName = ""
	While(result.Next())
	{

		s rowid=result.Data("InterKPI_rowid")
		s KPIDr=result.Data("InterKPI_kpiDr")
		
		s KPIName=result.Data("BonusTargetName")
		
		s kpirule=result.Data("InterKPI_okrDr")
		s code=result.Data("OutKpiRule_outKpiCode")
		s name=result.Data("OutKpiRule_outKpiName")
		
		s locSetDr=result.Data("OutKpiRule_inLocSetDr")
		s locSetName=result.Data("InterLocSet_name")
		
		s remark=result.Data("InterKPI_remark")
		s active=result.Data("InterKPI_active")
		
		
		s tmp=rowid_"^"_KPIDr_"^"_kpirule_"^"_KPIName_"^"_code_"^"_name_"^"_locSetDr_"^"_locSetName_"^"_remark_"^"_active
		
		i searchValue'="" d
		.q:(searchField = "KPIName")&(KPIName'[searchValue)
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

/// Creator: Zhao LiGuo
/// CreatDate: 2010-11-25
/// Description: KPI规则是否存在
/// Table：dhc.bonus.udata.InterLoc 
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uInterKPI).IfRepKPI(2,1)
ClassMethod IfRepKPI(KPIDr, KPIRlueDr) As %String
{
	n (KPIDr,KPIRlueDr)
	s rowid=0
	s rowid=$o(^DHCCJXPAINTERKPI(0,"IKKPICode",KPIDr,KPIRlueDr,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: Zhao LiGuo
/// CreatDate:  2010-11-11
/// Description: 插入新接口科室记录
/// Table:dhc.bonus.udata.InterLoc 
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.bonus.udata.uInterKPI).InsertRec("7^8^备注")
ClassMethod InsertRec(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s KPIDr=$p(data,"^",1)
		s kpiRuleDr=$p(data,"^",2)
		s remark = $p(data,"^",3)
		
		
		s id = 0
		s id = ..IfRepKPI(KPIDr,kpiRuleDr)
		q:id>0 "RepKPI"
		
		s active = "Y"
		
		i KPIDr'="" s PLIST(2)=KPIDr
		i kpiRuleDr'="" s PLIST(3)=kpiRuleDr
		i remark'="" s PLIST(5)=remark
		i active'="" s PLIST(6)=active
			
		&sql(INSERT INTO dhc_bonus_inter.InterKPI VALUES PLIST())
		q SQLCODE
}

/// Creator: Zhao LiGuo
/// CreatDate:  2010-11-11
/// Description: 插入新接口科室记录
/// Table:dhc.bonus.udata.InterLoc 
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.bonus.udata.uInterKPI).UpdataRec("^4^备注",16)
ClassMethod UpdataRec(data, rowid) As %String
{
		n (data,rowid)
		
		k PLIST
		q:data="" "EmptyRecData"
		q:rowid="" "rowidEmpt"
		s KPIDr=$p(data,"^",1)
		s kpiRuleDr=$p(data,"^",2)
		s remark = $p(data,"^",3)
		s active = $p(data,"^",4)
		
		
		//s id = 0
		//s id = ..IfRepKPI(KPIDr,kpiRuleDr)
		//q:((id>0)&&(id'=rowid)) "RepKPI"
		
		i KPIDr'="" d
		.s PLIST(2)=KPIDr
		
		s PLIST(3)=kpiRuleDr
		s PLIST(5)=remark
		s PLIST(6)=active
			
		&sql(UPDATE dhc_bonus_inter.InterKPI VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

/// Creator:Zhao LiGuo
/// CreatDate:2010-11-25
/// Description:删除接口指标
/// Table:dhc_bonus_interOutKpiRule
/// Input:rowid-接口指标rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.bonus.udata.uInterKPI).Delete(1)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(delete from dhc_bonus_inter.InterKPI where %ID=:rowid)
	q SQLCODE
}

/// Creator：Zhao LiGuo
/// CreatDate：2010-11-25
/// Description: 根据指标id获取KPI指标
/// Table：dhc_pa_data.KPIIndex1
/// Input：start:开始记录位置;limit:单页记录条数;
/// Output：
/// Return：有效指标字符串
/// Others：w ##class(dhc.bonus.udata.uInterKPI).GetKPIs("","",0,10,"")
ClassMethod GetKPIs(searchField, searchValue, start, limit, LocSetDr) As %String
{
	n ( searchField, searchValue,start, limit, LocSetDr)
	s result = ##class(%Library.ResultSet).%New()

	s sqlStr = "select InterKPI_rowid KPIIndex1_rowid,b.InterKPI_kpiDr->BonusTargetCode KPIIndex1_code,b.InterKPI_kpiDr->BonusTargetName KPIIndex1_name"
	_" ,b.InterKPI_kpiDr->TargetTypeID,b.InterKPI_kpiDr->TargetTypeID->TargetTypeName"
	_",b.InterKPI_rowid ,b.InterKPI_okrDr,InterKPI_okrDr->OutKpiRule_outKpiCode,b.InterKPI_kpiDr,b.InterKPI_okrDr->OutKpiRule_outKpiName"
	_",b.InterKPI_okrDr->OutKpiRule_inLocSetDr,b.InterKPI_okrDr->OutKpiRule_inLocSetDr->InterLocSet_shortcut InterLocSet_name,b.InterKPI_remark"
	_" from  dhc_bonus_inter.InterKPI b where b.InterKPI_active='Y'"
 
	i LocSetDr'="" s sqlStr = sqlStr_"and b.InterKPI_okrDr->OutKpiRule_inLocSetDr="_LocSetDr
	
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
    s title="rowid^name^code^InterMaprowid^InterTargetDr^InterTargetCode^InterTargetName^inLocSetDr^InterLocSetname^InterTargetemark^okrDr^TargetTypeID^TargetTypeName"


	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
		s name = result.Data("KPIIndex1_name")
		s code = result.Data("KPIIndex1_code")
	    s TargetTypeID = result.Data("TargetTypeID")
		s TargetTypeName = result.Data("TargetTypeName")
		
		s InterMaprowid = result.Data("InterKPI_rowid")
		s InterTargetDr = result.Data("InterKPI_kpiDr")
		s InterTargetCode = result.Data("OutKpiRule_outKpiCode")
		s InterTargetName = result.Data("OutKpiRule_outKpiName")
		s InterTargetemark = result.Data("InterKPI_remark")
		s okrDr = result.Data("InterKPI_okrDr")
			
		s inLocSetDr = result.Data("OutKpiRule_inLocSetDr")
		s InterLocSetname = result.Data("InterLocSet_name")
		
		s tmp=rowid_"^"_name_"^"_code_"^"_InterMaprowid_"^"_InterTargetDr_"^"_InterTargetCode_"^"_InterTargetName_"^"_inLocSetDr_"^"_InterLocSetname_"^"_InterTargetemark_"^"_okrDr_"^"_TargetTypeID_"^"_TargetTypeName
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
	s resultString = json.getJsonData(title,count)
 	k json
	q resultString
}

/// Creator：Zhao LiGuo
/// CreatDate：2010-11-25
/// Description: 根据指标id获取KPI指标
/// Table：dhc_pa_data.KPIIndex1
/// Input：start:开始记录位置;limit:单页记录条数;
/// Output：
/// Return：有效指标字符串
/// Others：w ##class(dhc.bonus.udata.uInterKPI).GetSchemeTarget(8,0,10,"")
ClassMethod GetSchemeTarget(InterLocSetID, start, limit, str) As %String
{
	n ( InterLocSetID,start,limit,str)
	s result = ##class(%Library.ResultSet).%New()

	s sqlStr = "select a.BonusTargetID rowID,a.BonusTargetID->BonusTargetName "
	_" from  dhc_bonus_data.SchemeTarget a, dhc_bonus_inter.InterLocSet b "_
	" where InterLocSet_SchemeID=BonusSchemeID  and a.BonusTargetID->DataSource=1 and InterLocSet_rowid= "_InterLocSetID
 
	i str'="" s sqlStr = sqlStr_"  and a.BonusTargetID->BonusTargetName like '%"_str_"%'"
	
	s sqlStr = sqlStr_" order by BonusTargetID->BonusTargetCode"
	
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
    s title="rowid^name"

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("rowID")
		s name = result.Data("BonusTargetName")
		
		s tmp=rowid_"^"_name
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
		
	}
	d result.Close()
	s resultString = json.getJsonData(title,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uInterKPIS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
