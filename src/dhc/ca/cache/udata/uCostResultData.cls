/// 名称: 成本分摊结果维护
/// 描述: 成本分摊结果添加与修改
/// 编写者：杨旭
/// 编写日期:2009-12-17
Class dhc.ca.cache.udata.uCostResultData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：杨旭
/// CreatDate：2009-12-17
/// Description: 等到节点总金额
/// Table：CostResultData
/// Input：MonthDr-月份; CostSetsDr-成本分摊套DR; NodeDr-节点;
/// Output：
/// Return：返回 直接成本^间接成本^分录成本^总成本
/// Others：w ##class(dhc.ca.cache.udata.uCostResultData).GetNodeTotal(1,1,7)
ClassMethod GetNodeTotal(MonthDr, CostSetsDr, NodeDr) As %String
{
	
	n (MonthDr, CostSetsDr,NodeDr)
	//w MonthDr_"^"_CostSetsDr_"^"_NodeDr,!
	s STotal=0
	s DTotal=0
	s CTotal=0
	s DeptDr=0
	s Total=0
	s resultString=""
	f  s DeptDr=$o(^DHCCADEPTLEVELSETS(NodeDr,"Depts",DeptDr)) q:DeptDr=""  d
	.//w DeptDr,!
	.s CostResultDr=""
	.s TmpDeptDr=""
	.s TmpDeptDr=$p($g(^DHCCADEPTLEVELSETS(NodeDr,"Depts",DeptDr)),"^",1)
	.f  s CostResultDr=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",CostSetsDr,MonthDr,TmpDeptDr,CostResultDr)) q:CostResultDr=""  d
	..s DistFlag=""
	..s distFlag=$p(^DHCCACOSTDISTSETS(CostSetsDr,"CostResultData",CostResultDr),"^",6)
	..i distFlag="self" s STotal=STotal+$p(^DHCCACOSTDISTSETS(CostSetsDr,"CostResultData",CostResultDr),"^",5)
	..i distFlag="dist" s DTotal=DTotal+$p(^DHCCACOSTDISTSETS(CostSetsDr,"CostResultData",CostResultDr),"^",5)
	..i distFlag="cat" s CTotal=CTotal+$p(^DHCCACOSTDISTSETS(CostSetsDr,"CostResultData",CostResultDr),"^",5)
	s Total=STotal+DTotal+CTotal
	s resultString=##class(dhc.ca.cache.udata.uCostResultSum).InsertRec(MonthDr, "branch", NodeDr, STotal, DTotal, CTotal, Total)
	//s ^TMP("dhc","ca","tmpTotal","yx","total","layer",NodeDr)=STotal_"^"_DTotal_"^"_CTotal_"^"_Total
	q resultString
}

/// Creator：杨旭
/// CreatDate：2009-12-17
/// Description: 得到某科室总金额
/// Table：CostResultData
/// Input：MonthDr-月份; CostSetsDr-成本分摊套DR; DeptDr-科室ID;
/// Output：
/// Return：返回 直接成本^间接成本^分录成本^总成本
/// Others：w ##class(dhc.ca.cache.udata.uCostResultData).GetDeptTotal(1,2,27)
ClassMethod GetDeptTotal(MonthDr, CostSetsDr, DeptDr) As %String
{
	
	n (MonthDr, CostSetsDr, DeptDr)
	
	s STotal=0
	s DTotal=0
	s CTotal=0
	s Total=0
	s CostResultDr=0
	s resultString=""
	f  s CostResultDr=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",CostSetsDr,MonthDr,DeptDr,CostResultDr)) q:CostResultDr=""  d
	.s DistFlag=""
	.s distFlag=$p(^DHCCACOSTDISTSETS(CostSetsDr,"CostResultData",CostResultDr),"^",6)
	.i distFlag="self" s STotal=STotal+$p(^DHCCACOSTDISTSETS(CostSetsDr,"CostResultData",CostResultDr),"^",5)
	.i distFlag="dist" s DTotal=DTotal+$p(^DHCCACOSTDISTSETS(CostSetsDr,"CostResultData",CostResultDr),"^",5)
	.i distFlag="cat" s CTotal=CTotal+$p(^DHCCACOSTDISTSETS(CostSetsDr,"CostResultData",CostResultDr),"^",5)
	
	s Total=STotal+DTotal+CTotal
	
    s resultString =##class(dhc.ca.cache.udata.uCostResultSum).InsertRec(CostSetsDr,MonthDr,"leaf",DeptDr,STotal,DTotal,CTotal,Total)
	//s ^TMP("dhc","ca","tmpTotal","yx","total","dept",DeptDr)=STotal_"^"_DTotal_"^"_CTotal_"^"_Total
	q STotal_"^"_DTotal_"^"_CTotal_"^"_Total
}

/// Creator：杨旭
/// CreatDate：2009-12-17
/// Description: 查询符合条件的记录
/// Table：CostResultData
/// Input：MonthDr-月份; CostSetsDr-成本分摊套DR; Parent-父ID;LayerDr-所查层ID;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.udata.uCostResultData).ListRec(1,1,"roo",1)
ClassMethod ListRec(MonthDr, CostSetsDr, Parent, LayerDr)
{
	//w $zt($p($h,",",2),1),!
	n (MonthDr, CostSetsDr, Parent, LayerDr)
	Set SqlStr=""
	i Parent="roo"  d
	.s Parent=0
	.Set SqlStr = "select DeptLevelSets_rowid,DeptLevelSets_code,DeptLevelSets_name,DeptLevelSets_order,DeptLevelSets_shortcut,DeptLevelSets_remark,DeptLevelSets_end,DeptLevelSets_active,DeptLevelSets_parent from dhc_ca_cache_data.DeptLevelSets where %ID>0 and DeptLevelSets_active = 'Y' and %ID='"_LayerDr_"' ORDER BY DeptLevelSets_order asc"
	e  d
	.Set SqlStr = "select DeptLevelSets_rowid,DeptLevelSets_code,DeptLevelSets_name,DeptLevelSets_order,DeptLevelSets_shortcut,DeptLevelSets_remark,DeptLevelSets_end,DeptLevelSets_active,DeptLevelSets_parent from dhc_ca_cache_data.DeptLevelSets where %ID>0 and DeptLevelSets_active = 'Y' and DeptLevelSets_parent='"_Parent_"' ORDER BY DeptLevelSets_order asc"
	Set Result = ##class(%Library.ResultSet).%New()
	
	s LocDr=""
	s LocName=""
	s DeptLevelSets=""
	s ResultString="["
	s TmpEnd=""
	i Parent'="" d
	.i $d(^DHCCADEPTLEVELSETS(Parent)) d
	..s TmpEnd=$p(^DHCCADEPTLEVELSETS(Parent),"^",5)
	
	i (TmpEnd="N")||(Parent=0) d
	.//w SqlStr
	.d Result.Prepare(SqlStr)
	.d Result.Execute()

	While(Result.Next())
	{
		s tmpStrings=""
		s rowid = Result.Data("DeptLevelSets_rowid")
		s code = Result.Data("DeptLevelSets_code")
		s name = Result.Data("DeptLevelSets_name")
		s desc = Result.Data("DeptLevelSets_shortcut")
		s remark = Result.Data("DeptLevelSets_remark")
		s end = Result.Data("DeptLevelSets_end")
		s active = Result.Data("DeptLevelSets_active")
		s parent = Result.Data("DeptLevelSets_parent")
		k ^TMP("dhc","ca","tmpTotal","yx","total")
		s tmpStrings=##class(dhc.ca.cache.udata.uCostResultSum).ListRec(CostSetsDr,MonthDr, "branch", rowid)
		s self=0
		s dist=0
		s cat=0
		s total=0
		i tmpStrings'="" d
		.s self=$p(tmpStrings,"^",1)
		.s dist=$p(tmpStrings,"^",2)
		.s cat=$p(tmpStrings,"^",3)
		.s total=$p(tmpStrings,"^",4)
		s ResultString=ResultString_"{id:'"_rowid_"',code:'"_code_"',name:'"_name_"',desc:'"_desc_"',remark:'"_remark_"',leaf:false,end:'"_end_"',active:'"_active_"',parent:'"_parent_"',uiProvider:'col',self:'"_self_"',dist:'"_dist_"',cat:'"_cat_"',total:'"_total_"'},"
	}
	//^DHCCADEPTLEVELSETS(0,"DeptOrder",{DeptLevelSets.DeptLevelSets_rowid},{LevelDepts_order},{LevelDepts_childSub})
	s Order=""
	i Parent'="" d
	.f  s Order=$o(^DHCCADEPTLEVELSETS(0,"DeptOrder",Parent,Order)) q:Order=""  d
	..f  s DeptLevelSets=$o(^DHCCADEPTLEVELSETS(0,"DeptOrder",Parent,Order,DeptLevelSets)) q:DeptLevelSets=""  d
	...q:DeptLevelSets=0
	...s LocDr=$p(^DHCCADEPTLEVELSETS(Parent,"Depts",DeptLevelSets),"^",1)
	...i LocDr'="" d
	....i $d(^DHCCAUNITDEPTS(LocDr)) d
	.....s LocName=$p(^DHCCAUNITDEPTS(LocDr),"^",2)
	.....s self=0
	.....s dist=0
	.....s cat=0
	.....s total=0
	.....s tmpStrings=""
	.....s tmpStrings=##class(dhc.ca.cache.udata.uCostResultSum).ListRec(CostSetsDr,MonthDr, "leaf", LocDr)
	.....i tmpStrings'="" d
	......s self=$p(tmpStrings,"^",1)
	......s dist=$p(tmpStrings,"^",2)
	......s cat=$p(tmpStrings,"^",3)
	......s total=$p(tmpStrings,"^",4)
	.....s ResultString=ResultString_"{id:'"_LocDr_"||"_LocDr_"',code:'',name:'"_LocName_"',desc:'',remark:'',leaf:'true',end:'',active:'Y',parent:'"_$p(^DHCCADEPTLEVELSETS(Parent,"Depts",DeptLevelSets),"^",2)_"',uiProvider:'col',self:'"_self_"',dist:'"_dist_"',cat:'"_cat_"',total:'"_total_"'},"
	
	s ResultString=ResultString_"]"
	d Result.Close()
	//w $zt($p($h,",",2),1),!
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-12-17
/// Description: 查看某科室成本分摊结果
/// Table：CostResultData
/// Input：searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数;MonthDr-月份; CostSetsDr-成本分摊套DR; DeptDr-部门ID; ItemDr-项目ID; Type-查找类型;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uCostResultData).CheckExist(11,1,38,0,0,0,0)
ClassMethod FindRecByDeptDr(searchField, searchValue, sortField, sortDir, start, limit, MonthDr, CostSetsDr, DeptDr, ItemDr, Type, parRef)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, MonthDr, CostSetsDr, DeptDr, ItemDr, Type ,parRef)
	
	s sqlStr="SELECT CostResultData_rowid,CostResultData_intervalDr,CostResultData_distedDeptDr,CostResultData_distDeptDr,CostResultData_itemDr,CostResultData_fee,CostResultData_distFlag,CostResultData_dealFlag FROM dhc_ca_cache_data.CostResultData"
	
	s whereStr=" WHERE %ID>0"
	i DeptDr'="" s DeptDr=$p(DeptDr,"||",1)
	i MonthDr'="" s whereStr=whereStr_" AND CostResultData_intervalDr='"_MonthDr_"'"
	i parRef'="" s whereStr=whereStr_" AND CostResultData_parRef='"_parRef_"'"
	i CostSetsDr'="" s whereStr=whereStr_" AND CostResultData_parRef='"_CostSetsDr_"'"
	i Type="disted" s whereStr=whereStr_" AND CostResultData_distedDeptDr='"_DeptDr_"'"
	i Type="dist" s whereStr=whereStr_" AND CostResultData_distDeptDr='"_DeptDr_"'"
	i ItemDr'="" s whereStr=whereStr_" AND CostResultData_itemDr='"_ItemDr_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="CostResultData_rowid"
	.i sortField="distedDeptName" s sortField1="CostResultData_distedDeptDr"
	.i sortField="distDeptName" s sortField1="CostResultData_distDeptDr"
	..i sortField="itemName" s sortField1="CostResultData_itemDr"
	.i sortField="fee" s sortField1="CostResultData_fee"
	.i sortField="distFlag" s sortField1="CostResultData_distFlag"
	.i sortField="dealFlag" s sortField1="CostResultData_dealFlag"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^distedDeptDr^distedDeptName^distDeptDr^distDeptName^itemDr^itemName^fee^distFlag^dealFlag"
	
	While(result.Next())
	{
		s rowid=result.Data("CostResultData_rowid")
		s distedDeptDr=result.Data("CostResultData_distedDeptDr")
		s distedDeptName=""
		i distedDeptDr'="" d
		.s distedDeptName=$p($g(^DHCCAUNITDEPTS(distedDeptDr)),"^",2)
		
		s distDeptDr=result.Data("CostResultData_distDeptDr")
		s distDeptName=""
		i distDeptDr'="" d
		.s distDeptName=$p($g(^DHCCAUNITDEPTS(distDeptDr)),"^",2)
		
		s itemDr=result.Data("CostResultData_itemDr")
		s itemName=""
		i itemDr'="" d
		.s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s fee=result.Data("CostResultData_fee")
		s distFlag=result.Data("CostResultData_distFlag")
		i distFlag="self" s distFlag="直接成本"
		i distFlag="dist" s distFlag="分摊成本"
		i distFlag="cat" s distFlag="分录成本"
		
		s dealFlag=result.Data("CostResultData_dealFlag")
		
		s tmp=rowid_"^"_distedDeptDr_"^"_distedDeptName_"^"_distDeptDr_"^"_distDeptName_"^"_itemDr_"^"_itemName_"^"_fee_"^"_distFlag_"^"_dealFlag
		
		i searchValue'="" d
		.i (searchField="dealFlag") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"

		.q:(searchField="distedDeptName")&(distedDeptName'[searchValue)
		.q:(searchField="distDeptName")&(distDeptName'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="fee")&(fee'[searchValue)
		.q:(searchField="distFlag")&(distFlag'[searchValue)
		.q:(searchField="dealFlag")&(dealFlag'[searchValue)
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

/// Creator: 杨旭
/// CreatDate: 2010-1-20
/// Description: 删除记录
/// Table: dhc.ca.cache.data.CostResultData
/// Input：intervalDr-月份ID;CostDistSetsDr-分层套;
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uCostResultData).DelRec(1,1)
ClassMethod DelRec(intervalDr, CostDistSetsDr) As %String
{
	n (intervalDr,CostDistSetsDr)
	d ##class(dhc.ca.cache.udata.uCostResultSum).DelRec(intervalDr,CostDistSetsDr)
	&SQL(DELETE FROM dhc_ca_cache_data.CostResultData WHERE CostResultData_intervalDr=:intervalDr and CostResultData_parRef=:CostDistSetsDr)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-1-20
/// Description: 查看数据是否已经分摊过
/// Table: dhc.ca.cache.data.CostResultData
/// Input：intervalDr-月份ID;CostDistSetsDr-分层套;
/// Output: 
/// Return: 如果不存在返回0,存在返回行号
/// Others: w ##class(dhc.ca.cache.udata.uCostResultData).CheckRec(1,1)
ClassMethod CheckRec(intervalDr, CostDistSetsDr) As %String
{
	n (intervalDr,CostDistSetsDr)
	q:intervalDr="" "emptyIntervalDr"
	q:CostDistSetsDr="" "emptyCostDistSetsDr"
	s rowId=1
	s rowId=$o(^DHCCACOSTDISTSETS(0,"DInterval",CostDistSetsDr,intervalDr,rowId))
	i rowId="" s rowId=0
	q rowId
}

/// Creator: 杨旭
/// CreatDate: 2010-1-20
/// Description: 生成成本分摊汇总数据
/// Table：CostResultSum
/// Input：MonthDr-月份; CostSetsDr-成本分摊套DR; NodeDr-节点;
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.uCostResultData).CreateData(1,1,"")
ClassMethod CreateData(MonthDr, CostSetsDr, NodeDr) As %String
{
	n (MonthDr, CostSetsDr, NodeDr)
	d ##class(dhc.ca.cache.udata.uCostResultSum).DelRec(MonthDr, CostSetsDr)	
	q ..GetAllTotal(MonthDr, CostSetsDr, NodeDr)
}

/// Creator：杨旭
/// CreatDate：2010-03-22
/// Description: 生成此节点下的成本分摊汇总
/// Table：CostResultSum
/// Input：MonthDr-月份; CostSetsDr-成本分摊套DR; NodeDr-节点;
/// Output：
/// Others：w ##class(dhc.ca.cache.udata.uCostResultData).GetAllTotal(1,1)
ClassMethod GetAllTotal(MonthDr, CostSetsDr, NodeDr) As %String
{
	
	n (MonthDr, CostSetsDr, NodeDr)
	q:CostSetsDr="" ""
	q:MonthDr="" ""
	
	i NodeDr="" d
	.s NodeDr=$p($g(^DHCCACOSTDISTSETS(CostSetsDr)),"^",5)
	
	s STotal=0
	s DTotal=0
	s CTotal=0
	s DeptDr=0
	s Total=0
	s resultString=""
	f  s DeptDr=$o(^DHCCADEPTLEVELSETS(NodeDr,"Depts",DeptDr)) q:DeptDr=""  d
	.//w DeptDr,!
	.s CostResultDr=""
	.s TmpDeptDr=""
	.s TmpDeptDr=$p($g(^DHCCADEPTLEVELSETS(NodeDr,"Depts",DeptDr)),"^",1)
	.d ..GetDeptTotal(MonthDr, CostSetsDr, TmpDeptDr)
	.f  s CostResultDr=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",CostSetsDr,MonthDr,TmpDeptDr,CostResultDr)) q:CostResultDr=""  d
	..s DistFlag=""
	..s distFlag=$p(^DHCCACOSTDISTSETS(CostSetsDr,"CostResultData",CostResultDr),"^",6)
	..i distFlag="self" s STotal=STotal+$p(^DHCCACOSTDISTSETS(CostSetsDr,"CostResultData",CostResultDr),"^",5)
	..i distFlag="dist" s DTotal=DTotal+$p(^DHCCACOSTDISTSETS(CostSetsDr,"CostResultData",CostResultDr),"^",5)
	..i distFlag="cat" s CTotal=CTotal+$p(^DHCCACOSTDISTSETS(CostSetsDr,"CostResultData",CostResultDr),"^",5)
	
	s TmpOrder=""
	f  s TmpOrder=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",NodeDr,TmpOrder)) q:TmpOrder=""  d
	.s LevelSetsDr=""
	.f  s LevelSetsDr=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",NodeDr,TmpOrder,LevelSetsDr)) q:LevelSetsDr=""  d
	..s ResultStrings =..GetAllTotal(MonthDr, CostSetsDr, LevelSetsDr)
	..i ResultStrings'="" d
	...s STotal=STotal+$p(ResultStrings,"^",1)
	...s DTotal=DTotal+$p(ResultStrings,"^",2)
	...s CTotal=CTotal+$p(ResultStrings,"^",3)
	...//s Total=STotal+DTotal+CTotal
	s Total=STotal+DTotal+CTotal
	d ##class(dhc.ca.cache.udata.uCostResultSum).InsertRec(CostSetsDr, MonthDr, "branch", NodeDr, STotal, DTotal, CTotal, Total)	
	q STotal_"^"_DTotal_"^"_CTotal_"^"_Total
}

/// Creator：杨旭
/// CreatDate：2009-12-17
/// Description: 查看某层下未分摊科室成本
/// Table：CostResultData
/// Input：searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数;MonthDr-月份; CostSetsDr-成本分摊套DR; DeptDr-部门ID; ItemDr-项目ID; Type-查找类型;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uCostResultData).FindRecByLayerDr("","","","",0,10,1,1,6)
ClassMethod FindRecByLayerDr(searchField, searchValue, sortField, sortDir, start, limit, MonthDr, CostSetsDr, LayerDr)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, MonthDr, CostSetsDr, LayerDr)
	q:CostSetsDr="" ""
	
	i (LayerDr="")||(LayerDr="roo") s LayerDr=CostSetsDr
	d ##class(dhc.ca.cache.udata.CostDist).GetLayers(CostSetsDr)
	s tmpDepts=""
	s depts=""
	i $p(LayerDr,"||",2)="" d 
	.s tmpDepts=##class(dhc.ca.cache.udata.CostDist).GetCurrentLayerDepts(LayerDr)
	.s depts=..GetDepts(tmpDepts)
	e  d
	.s depts=$p(LayerDr,"||",2)
	q:depts="" 0
	s sqlStr="SELECT CostResultData_rowid,CostResultData_intervalDr,CostResultData_distedDeptDr,CostResultData_distDeptDr,CostResultData_itemDr,CostResultData_fee,CostResultData_distFlag,CostResultData_dealFlag FROM dhc_ca_cache_data.CostResultData"
	
	s whereStr=" WHERE %ID>0 AND CostResultData_dealFlag='N'"
	i MonthDr'="" s whereStr=whereStr_" AND CostResultData_intervalDr='"_MonthDr_"'"
	i CostSetsDr'="" s whereStr=whereStr_" AND CostResultData_parRef='"_CostSetsDr_"'"
	s whereStr=whereStr_" AND CostResultData_distDeptDr in ("_depts_")"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="CostResultData_rowid"
	.i sortField="distedDeptName" s sortField1="CostResultData_distedDeptDr"
	.i sortField="distDeptName" s sortField1="CostResultData_distDeptDr"
	..i sortField="itemName" s sortField1="CostResultData_itemDr"
	.i sortField="fee" s sortField1="CostResultData_fee"
	.i sortField="distFlag" s sortField1="CostResultData_distFlag"
	.i sortField="dealFlag" s sortField1="CostResultData_dealFlag"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^distedDeptDr^distedDeptName^distDeptDr^distDeptName^itemDr^itemName^fee^distFlag^dealFlag"
	
	While(result.Next())
	{
		s rowid=result.Data("CostResultData_rowid")
		s distedDeptDr=result.Data("CostResultData_distedDeptDr")
		s distedDeptName=""
		i distedDeptDr'="" d
		.s distedDeptName=$p($g(^DHCCAUNITDEPTS(distedDeptDr)),"^",2)
		
		s distDeptDr=result.Data("CostResultData_distDeptDr")
		s distDeptName=""
		i distDeptDr'="" d
		.s distDeptName=$p($g(^DHCCAUNITDEPTS(distDeptDr)),"^",2)
		
		s itemDr=result.Data("CostResultData_itemDr")
		s itemName=""
		i itemDr'="" d
		.s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s fee=result.Data("CostResultData_fee")
		s distFlag=result.Data("CostResultData_distFlag")
		i distFlag="self" s distFlag="直接成本"
		i distFlag="dist" s distFlag="分摊成本"
		i distFlag="cat" s distFlag="分录成本"
		
		s dealFlag=result.Data("CostResultData_dealFlag")
		
		s tmp=rowid_"^"_distedDeptDr_"^"_distedDeptName_"^"_distDeptDr_"^"_distDeptName_"^"_itemDr_"^"_itemName_"^"_fee_"^"_distFlag_"^"_dealFlag
		
		i searchValue'="" d
		.i (searchField="dealFlag") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="distedDeptName")&(distedDeptName'[searchValue)
		.q:(searchField="distDeptName")&(distDeptName'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="fee")&(fee'[searchValue)
		.q:(searchField="distFlag")&(distFlag'[searchValue)
		.q:(searchField="dealFlag")&(dealFlag'[searchValue)
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

/// Creator：杨旭
/// CreatDate: 2010-4-13
/// Description: 返回科室ID串
/// Table: 
/// Input: depts-科室;
/// Output: 
/// Return: 指定类型科室串
/// Others: 
ClassMethod GetDepts(depts) As %String
{
	n (depts)
	s result=""
	q:depts="" ""
	
	f i=1:1:$l(depts,"^") d
	.s tmp=$p(depts,"^",i)
	.i tmp'="" d
	..s dept=$p(tmp,"!",1)
	..i dept'="" d
	...i result="" s result=dept
	...e  s result=result_","_dept
	
	q result
}

/// Creator：杨旭
/// CreatDate：2012-2-20
/// Description: 将结果数据插入到凭证数据
/// Table：CostResultData
/// Input：MonthDr-月份; CostSetsDr-成本分摊套DR; PersonDr-录入人;
/// Output：
/// Return：返回执行SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uCostResultData).importToVouch(1,2,1)
ClassMethod importToVouch(MonthDr, CostSetsDr, PersonDr)
{
    //w $zt($p($h,",",2),1),!
	n (MonthDr, CostSetsDr, PersonDr) 
	q:MonthDr="" "emptyMonthDr"
	q:CostSetsDr="" "emptyCostSetsDr"
	q:PersonDr="" "emptyPersonDr"
	
	TSTART
	
	//导入前先删除历史数据，避免重复导入  zjw  20160129
	s remark="拆分导入"
	s PersonCODE=$p(^SSU("SSUSR",PersonDr),"^",1),unitPersonDr=""
	s unitPersonDr=$o(^DHCCAUNITPERSONS(0,"Code",PersonCODE,unitPersonDr))   // only one
	i $d(^DHCCAACCOUNTMONTHS(MonthDr)) d
	.&sql(DELETE FROM dhc_ca_cache_data.VouchDatas WHERE VouchDatas_intervalDr=:MonthDr and VouchDatas_remark=:remark)
	
	Set SqlStr=""
	Set SqlStr = "select * from dhc_ca_cache_data.CostResultData where CostResultData_intervalDr='"_MonthDr_"' and CostResultData_parRef='"_CostSetsDr_"' and CostResultData_distDeptDr IN (SELECT LevelDepts_deptDr FROM dhc_ca_cache_data.LevelDepts WHERE LevelDepts_parRef = '12' AND LevelDepts_childSub <>0) "
	//Set Result = ##class(%Library.ResultSet).%New()
	s ResultString=0
	s Result= ##class(%Library.ResultSet).%New()
	//w SqlStr,!
	
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		
		//w $zt($p($h,",",2),1),!
		s distedDeptDr=Result.Data("CostResultData_distedDeptDr")
		s distedDeptName=""
		i distedDeptDr'="" d
		.s distedDeptName=$p($g(^DHCCAUNITDEPTS(distedDeptDr)),"^",2)
		
		s distDeptDr=Result.Data("CostResultData_distDeptDr")
		s distDeptName=""
		i distDeptDr'="" d
		.s distDeptName=$p($g(^DHCCAUNITDEPTS(distDeptDr)),"^",2)
		
		s itemDr=Result.Data("CostResultData_itemDr")
		s itemName=""
		i itemDr'="" d
		.s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s fee=Result.Data("CostResultData_fee")
		s distFlag=Result.Data("CostResultData_distFlag")
		//w MonthDr_"^"_distDeptDr_"^"_itemDr_"^"_PersonDr_"^"_fee,!
		
		s tmpFlag=0
		//intervalDr-月份ID; deptDr-部门ID; itemDr-数据项ID; inType-录入类型; personDr-录入人ID;remark-备注;debit-借方;loans-贷方;
	    s tmpFlag= ##class(dhc.ca.cache.udata.uVouchDatas).InsertRec(MonthDr,distDeptDr,itemDr,"divide",unitPersonDr,remark,fee,0)
	    i tmpFlag'=0 s ResultString=tmpFlag
	    ;w tmpFlag_"^"_num,!
		
	}
	//w $zt($p($h,",",2),1),!
	d Result.Close()
	i ResultString =0 d
  	.TCOMMIT
	e  d
 	.TROLLBACK
	
	q ResultString
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uCostResultDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
