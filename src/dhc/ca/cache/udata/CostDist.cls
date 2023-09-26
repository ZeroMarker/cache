/// Creator: 许立新
/// CreatDate: 2009-12-22
/// Description: 成本分摊
Class dhc.ca.cache.udata.CostDist Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Part: A-01
/// Creator: 许立新
/// CreatDate: 2009-12-24
/// Description: 成本分摊入口
/// Table: 
/// Input: costDistSetDr-成本分摊套,intervalDr-核算周期
/// Output: 
/// Return: 分摊结果
/// Others: w ##class(dhc.ca.cache.udata.CostDist).DistStart(1,1)
ClassMethod DistStart(costDistSetDr, intervalDr) As %String
{
	n (costDistSetDr,intervalDr)
	
	s job=$j
	
	//清除临时global
	k ^TMPDHCCA("dhc","ca","directCost",job)
	//直接成本归集
	//w job_"^"_intervalDr,!
	s result1=..GetDirectCost(job,intervalDr)  //B-01
	//直接成本写入
	//w costDistSetDr_"^"_job_"^"_intervalDr,!
	s result2=..WriteDirectCost(costDistSetDr,job,intervalDr) //B-02
	//清除归集数据
	k ^TMPDHCCA("dhc","ca","directCost",job)
	//成本分摊
	s result3=..CostDist(costDistSetDr,intervalDr)  //C-01
	
	q "OK"
}

/// Part: A-02
/// Creator: 许立新
/// CreatDate: 2009-12-22
/// Description: 插入一条成本数据
/// Table: dhc.ca.cache.data.CostResultData
/// Input: costDistSetDr-成本分摊套,rowdata-数据行,"核算周期Dr^被分摊部门Dr^分摊部门Dr^成本项Dr^成本金额^分摊标志^处理标志"
/// Output: 
/// Return: SQLCode
/// Others: w ##class(dhc.ca.cache.udata.CostDist).InsertCost("")
ClassMethod InsertCost(costDistSetDr, data) As %String
{
	n (costDistSetDr,data)
	
	k PLIST
	
	i costDistSetDr'="" && costDistSetDr'=0 s PLIST(0)=costDistSetDr
	
	s intervalDr=$p(data,"^",1)
	i intervalDr'="" s PLIST(3)=intervalDr            //核算周期
	
	s distedDeptDr=$p(data,"^",2)
	i distedDeptDr'="" s PLIST(4)=distedDeptDr        //被分摊部门
	
	s distDeptDr=$p(data,"^",3)
	i distDeptDr'="" s PLIST(5)=distDeptDr            //分摊部门
	
	s costItemDr=$p(data,"^",4)
	i costItemDr'="" s PLIST(6)=costItemDr            //成本项
	
	s fee=$p(data,"^",5)
	i fee'="" s PLIST(7)=fee                          //成本金额
	
	s distFlag=$p(data,"^",6)
	i distFlag'="" s PLIST(8)=distFlag                //分摊标志
	
	s dealFlag=$p(data,"^",7)
	i dealFlag'="" s PLIST(9)=dealFlag                //处理标志
	
	&SQL(INSERT INTO dhc_ca_cache_data.CostResultData VALUES PLIST())
	q SQLCODE
}

/// Part: A-03
/// Creator: 许立新
/// CreatDate: 2010-1-6
/// Description: 取出按优先级循环的成本科室分层套的所有第一级有效层
/// Table: dhc.ca.cache.data.DeptLevelSets
/// Input: deptSetDr-科室分层套Dr
/// Output: 
/// Return: 按顺序排好的指定科室分层套的所有第一级有效层
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetDeptSetLayers(1)
ClassMethod GetDeptSetLayers(deptSetDr) As %String
{
	n (deptSetDr)
	
	s deptLayers=""
	s order=""
	f  s order=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",deptSetDr,order)) q:order=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",deptSetDr,order,rowid)) q:rowid=""  d
	..i $d(^DHCCADEPTLEVELSETS(rowid)) d
	...s name=$p(^DHCCADEPTLEVELSETS(rowid),"^",2)
	...s active=$p(^DHCCADEPTLEVELSETS(rowid),"^",6)
	...i active="Y" d
	....i deptLayers="" s deptLayers=rowid
	....e  s deptLayers=deptLayers_"^"_rowid
	....//w order_"^"_rowid_"^"_name_"^"_active,!

	q deptLayers
}

/// Part: A-04
/// Creator: 许立新
/// CreatDate: 2009-12-23
/// Description: 取当前枝条下的有效枝条
/// Table: 
/// Input: branchDr
/// Output: 
/// Return: 当前枝条下的有效枝条
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetBranchs(2)
ClassMethod GetBranchs(branchDr) As %String
{
	n (branchDr)
	q:branchDr="" ""
	
	s branchs=""
	f i=1:1:$l(branchDr,"^") d
	.s bDr=$p(branchDr,"^",i)
	.s order=""
	.f  s order=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",bDr,order)) q:order=""  d
	..s rowid=0
	..f  s rowid=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",bDr,order,rowid)) q:rowid=""  d
	...i $d(^DHCCADEPTLEVELSETS(rowid)) d
	....s active=$p(^DHCCADEPTLEVELSETS(rowid),"^",6)
	....i active="Y" d
	.....i branchs="" s branchs=rowid
	.....e  s branchs=branchs_"^"_rowid
	
	s branchs1=..GetBranchs(branchs)
	i branchs1'="" s branchs=branchs_"^"_branchs1
	q branchs
}

/// Part: A-05
/// Creator: 许立新
/// CreatDate: 2009-12-23
/// Description: 取当前枝下的科室
/// Table: 
/// Input: branchDr
/// Output: 
/// Return: 当前枝下的科室
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetBranchDepts(159)
ClassMethod GetBranchDepts(branchDr) As %String
{
	n (branchDr)
	
	s depts=""
	s child=0
	f  s child=$o(^DHCCADEPTLEVELSETS(branchDr,"Depts",child)) q:child=""  d
	.s deptDr=$p(^DHCCADEPTLEVELSETS(branchDr,"Depts",child),"^",1)
	.s recFlag=$p(^DHCCADEPTLEVELSETS(branchDr,"Depts",child),"^",2)
	.s distFlag=$p(^DHCCADEPTLEVELSETS(branchDr,"Depts",child),"^",4)
	.i depts="" s depts=deptDr_"!"_recFlag_"!"_distFlag
	.e  s depts=depts_"^"_deptDr_"!"_recFlag_"!"_distFlag
	
	q depts
}

/// Part: A-06
/// Creator: 许立新
/// CreatDate: 2009-12-24
/// Description: 取当前层下科室
/// Table: 
/// Input: layerDr-层ID
/// Output: 
/// Return: 当前层下科室
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetCurrentLayerDepts(3)
ClassMethod GetCurrentLayerDepts(layerDr) As %String
{
	n (layerDr)
	s depts=""
	s depts=..GetBranchDepts(layerDr) //取层科室 A-05
	s branchs=""
	s branchs=..GetBranchs(layerDr)   //取层枝条 A-04
	i branchs'="" d
	f i=1:1:$l(branchs,"^") d         //取枝条科室
	.s branch=$p(branchs,"^",i)
	.i branch'="" d
	..s tmp=..GetBranchDepts(branch)
	..i tmp'="" d
	...i depts="" s depts=tmp
	...e  s depts=depts_"^"_tmp
	
	q depts
}

/// Part: A-07
/// Creator: 许立新
/// CreatDate: 2009-12-24
/// Description: 取当前层的所有下层的科室
/// Table: 
/// Input: deptLevelSetsDr-科室分层套,layerDr-当前层Dr
/// Output: 
/// Return: 当前层的所有下层科室
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetLowerLayerDepts(1,2)
ClassMethod GetLowerLayerDepts(deptLevelSetsDr, layerDr) As %String
{
	n (deptLevelSetsDr,layerDr)
	
	s depts=""
	s order=""
	s order=$p(^DHCCADEPTLEVELSETS(layerDr),"^",8)

	f  s order=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",deptLevelSetsDr,order)) q:order=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",deptLevelSetsDr,order,rowid)) q:rowid=""  d
	..//s name=$p(^DHCCADEPTLEVELSETS(rowid),"^",2)
	..//w name,!
	..s layerDepts=..GetBranchDepts(rowid) //取层科室 A-05
	..//w layerDepts,!
	..i depts="" s depts=layerDepts
	..e  s depts=depts_"^"_layerDepts
	..s branchs=""
	..s branchs=..GetBranchs(rowid)   //取层枝条 A-04
	..i branchs'="" d
	..f i=1:1:$l(branchs,"^") d       //取枝条科室
	...s branch=$p(branchs,"^",i)
	...i branch'="" d
	....s tmp=..GetBranchDepts(branch)
	....i tmp'="" d
	.....i depts="" s depts=tmp
	.....e  s depts=depts_"^"_tmp
	
	q depts
}

/// Part: A-08
/// Creator: 许立新
/// CreatDate: 2010-1-6
/// Description: 取当前成本分层套的有效层
/// Table: 
/// Input: deptLevelSetsDr
/// Output: 
/// Return: 当前成本分层下的有效层存为临时global
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetLayers(1)
ClassMethod GetLayers(deptLevelSetsDr) As %String
{
	n (deptLevelSetsDr)
	k ^TMPDHCCACAL("dhc","ca","Layer")
	s order=""
	f  s order=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",deptLevelSetsDr,order)) q:order=""  d
	.s layerDr=""
	.f  s layerDr=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",deptLevelSetsDr,order,layerDr)) q:layerDr=""  d
	..s active=$p(^DHCCADEPTLEVELSETS(layerDr),"^",6)
	..i active="Y" d
	...//w order_"^"_layerDr_"^"_active,!
	...s ^TMPDHCCACAL("dhc","ca","Layer",order,layerDr)=""
	
	q "OK"
}

/// Part: A-09
/// Creator: 许立新
/// CreatDate: 2010-1-6
/// Description: 取当前成本分层下的有效层
/// Table: 
/// Input: order
/// Output: 
/// Return: 当前成本分层下的有效层
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetLowLayers(2)
ClassMethod GetLowLayers(order) As %String
{
	n (order)
	
	s lowLayers=""
	f  s order=$o(^TMPDHCCACAL("dhc","ca","Layer",order)) q:order=""  d
	.s layerDr=""
	.f  s layerDr=$o(^TMPDHCCACAL("dhc","ca","Layer",order,layerDr)) q:layerDr=""  d
	..i lowLayers="" s lowLayers=layerDr
	..e  s lowLayers=lowLayers_"^"_layerDr

	q lowLayers
}

/// Part: A-10
/// Creator: 许立新
/// CreatDate: 2010-1-7
/// Description: 取当前层的所有下层的科室
/// Table: 
/// Input: lowLayers-所有分层
/// Output: 
/// Return: 所有下层科室
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetLowLayerDepts("2^3^4^5^6^7^157")
ClassMethod GetLowLayerDepts(lowLayers) As %String
{
	n (lowLayers)
	
	s depts=""
	
	q:lowLayers="" ""
	f i=1:1:$l(lowLayers,"^") d
	.s currLayerDr=$p(lowLayers,"^",i)
	.i currLayerDr'="" d
	..s tmp=..GetCurrentLayerDepts(currLayerDr)
	..i tmp'="" d
	...i depts="" s depts=tmp
	...e  s depts=depts_"^"_tmp
	
	q depts
}

/// Part: A-11
/// Creator: 许立新
/// CreatDate: 2010-1-7
/// Description: 当前科室中指定类型的科室
/// Table: 
/// Input: depts-科室,loc-位置:2接收,3分摊
/// Output: 
/// Return: 指定类型科室串
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetDepts("6!Y!N^7!Y!Y")
ClassMethod GetDepts(depts, loc) As %String
{
	n (depts,loc)
	
	s result=""
	q:depts="" ""
	
	f i=1:1:$l(depts,"^") d
	.s tmp=$p(depts,"^",i)
	.i tmp'="" d
	..s dept=$p(tmp,"!",1)
	..s state=$p(tmp,"!",loc)
	..i dept'="" d
	...i state="Y" d
	....i result="" s result=dept
	....e  s result=result_"^"_dept
	
	q result
}

/// Part: B-01
/// Creator: 许立新
/// CreatDate: 2009-12-22
/// Description: 直接成本归集：汇总凭证表数据。^TMP("dhc","ca","directCost",job,intervalDr,deptDr,costItemDr)=金额
/// Table: dhc.ca.cache.data.VouchDatas
/// Input: job-线程号,intervalDr-核算周期
/// Output: 
/// Return: 完成标志
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetDirectCost(1,1)
ClassMethod GetDirectCost(job, intervalDr) As %String
{
	n (job,intervalDr)
	//w job_"^"_intervalDr,!
	s rowid=0
	f  s rowid=$o(^DHCCAVOUCHDATAS(0,"Interval",intervalDr,rowid)) q:rowid=""  d
	.s deptdr=""
	.s itemDr=""
	.s fee=0
	.i $d(^DHCCAVOUCHDATAS(rowid)) d
	..s deptDr=$p(^DHCCAVOUCHDATAS(rowid),"^",2)
	..s itemDr=$p(^DHCCAVOUCHDATAS(rowid),"^",3)
	..s fee=$p(^DHCCAVOUCHDATAS(rowid),"^",16)-$p(^DHCCAVOUCHDATAS(rowid),"^",17)
	..i $d(^TMPDHCCA("dhc","ca","directCost",job,intervalDr,deptDr,itemDr)) d
	...s ^TMPDHCCA("dhc","ca","directCost",job,intervalDr,deptDr,itemDr)=^TMPDHCCA("dhc","ca","directCost",job,intervalDr,deptDr,itemDr)+fee
	..e  d
	...s ^TMPDHCCA("dhc","ca","directCost",job,intervalDr,deptDr,itemDr)=fee

	q "OK"
}

/// Part: B-02
/// Creator: 许立新
/// CreatDate: 2009-12-22
/// Description: 直接成本写入
/// Table: dhc.ca.cache.data.CostResultData
/// Input: costDistSetDr-成本分摊套,job-线程号,intervalDr-核算周期
/// Output: 
/// Return: 完成标志
/// Others: w ##class(dhc.ca.cache.udata.CostDist).WriteDirectCost(1,1,1)
ClassMethod WriteDirectCost(costDistSetDr, job, intervalDr) As %String
{
	n (costDistSetDr,job,intervalDr)
	//w costDistSetDr_"^"_job_"^"_intervalDr,!
	s deptDr=0
	f  s deptDr=$o(^TMPDHCCA("dhc","ca","directCost",job,intervalDr,deptDr)) q:deptDr=""  d
	.//w deptDr,!
	.i $d(^TMPDHCCA("dhc","ca","directCost",job,intervalDr,deptDr)) d
	..s costItemDr=0
	..f  s costItemDr=$o(^TMPDHCCA("dhc","ca","directCost",job,intervalDr,deptDr,costItemDr)) q:costItemDr=""  d
	...i $d(^TMPDHCCA("dhc","ca","directCost",job,intervalDr,deptDr,costItemDr)) d
	....s fee=^TMPDHCCA("dhc","ca","directCost",job,intervalDr,deptDr,costItemDr)
	....s data=intervalDr_"^^"_deptDr_"^"_costItemDr_"^"_fee_"^self^N"
	....s result=..InsertCost(costDistSetDr,data)   //A-02
	
	q "OK"
}

/// Part: C-01
/// Creator: 许立新
/// CreatDate: 2010-1-6
/// Description: 开始成本分摊
/// Table: dhc.ca.cache.data.CostResultData;dhc.ca.cache.data.CostDistMethods
/// Input: costDistSetDr-成本分摊套,intervalDr-核算周期
/// Output: 
/// Return: 完成标志
/// Others: w ##class(dhc.ca.cache.udata.CostDist).CostDist(1,1) 
ClassMethod CostDist(costDistSetDr, intervalDr) As %String
{
	n (costDistSetDr,intervalDr)
	//                   D
	
	//取部门分层套
	s deptSetDr=""
	i $d(^DHCCACOSTDISTSETS(costDistSetDr)) s deptSetDr=$p(^DHCCACOSTDISTSETS(costDistSetDr),"^",5)
	q:deptSetDr="" "DeptSetErr"
	//w deptSetDr,!
	
	//取分摊标志
	s distFlag=""
	i $d(^DHCCACOSTDISTSETS(costDistSetDr)) s distFlag=$p(^DHCCACOSTDISTSETS(costDistSetDr),"^",8)
	//w distFlag,!
	
	//取出按优先级循环的成本科室分层套的每一有效层
	s result1=..GetLayers(deptSetDr)  //A-08
	//w result1,!
	
	//循环成本分层
	s order=""
	f  s order=$o(^TMPDHCCACAL("dhc","ca","Layer",order)) q:order=""  d
	.s layerDr=0       //当前核算层
	.f  s layerDr=$o(^TMPDHCCACAL("dhc","ca","Layer",order,layerDr)) q:layerDr=""  d
	..//w order_"^"_layerDr,!
	..//取当前核算层下的分层
	..s lowLayers=..GetLowLayers(order)  //A-09
	..//w layerDr_"-->"_lowLayers,!
	..//取当前分层下所有科室
	..s curLayerDepts=..GetCurrentLayerDepts(layerDr)  //A-06
	..//w "curLayerDepts:"
	..//w curLayerDepts,!
	..//取当前分层下层的所有科室
	..s lowLayerDepts=..GetLowLayerDepts(lowLayers)  //A-10
	..//w "lowLayerDepts:"
	..//w lowLayerDepts,!
	..//取当前分层中允许分摊成本的科室
	..s distDepts=..GetDepts(curLayerDepts,3)
	..//w "distDepts:"_distDepts,!
	..//取下层科室中允许接收成本的科室
	..s recDepts=..GetDepts(lowLayerDepts,2)
	..//w "recDepts:"_recDepts,!
	..//按优先级循环当前分层下的有效分摊方法
	..s priority=""
	..//w costDistSetDr_"^"_layerDr,!
	..f  s priority=$o(^DHCCACOSTDISTSETS(0,"CDMSLP",costDistSetDr,layerDr,priority)) q:priority=""  d
	...s childSub=""
	...//w priority,!
	...f  s childSub=$o(^DHCCACOSTDISTSETS(0,"CDMSLP",costDistSetDr,layerDr,priority,childSub)) q:childSub=""  d
	....//读方法名、分摊后成本项、有效标志、收支配比标志
	....//w "a---"_^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub),!
	....i $d(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub)) d
	.....s name=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub),"^",4)
	.....s outItem=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub),"^",5) //输出成本项为空按原成本项  C
	.....s paramPeriod=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub),"^",6) //取分摊参数区间        N
	.....s active=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub),"^",7)  //方法有效标志
	.....s ioFlag=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub),"^",8)  //收支配比标志
	.....//w "b---"_"name:"_name_"^"_"outItem:"_outItem_"^"_"ioFlag:"_ioFlag_"^"_"paramPeriod:"_paramPeriod_"^"_"active:"_active,!
	.....i active="Y" d   //方法有效才按该方法进行分摊
	......//取当前分摊方法中包含成本科室
	......//w "b---"_"name:"_name_"^"_"outItem:"_outItem_"^"_"ioFlag:"_ioFlag_"^"_"paramPeriod:"_paramPeriod_"^"_"active:"_active,!
	......s inCostDepts=""
	......s inCostDeptChildSub=0
	......f  s inCostDeptChildSub=$o(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub,"InCostDept",inCostDeptChildSub)) q:inCostDeptChildSub=""  d
	.......s tmp=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub,"InCostDept",inCostDeptChildSub),"^",1)
	.......i tmp'="" d
	........i inCostDepts="" s inCostDepts=tmp
	........e  s inCostDepts=inCostDepts_"^"_tmp
	......//w inCostDepts,!
	......//取当前分摊方法中不包含成本科室
	......s outCostDepts=""
	......s outCostDeptChildSub=0
	......f  s outCostDeptChildSub=$o(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub,"OutCostDept",outCostDeptChildSub)) q:outCostDeptChildSub=""  d
	.......s tmp=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub,"OutCostDept",outCostDeptChildSub),"^",1)
	.......i tmp'="" d
	........i outCostDepts="" s outCostDepts=tmp
	........e  s outCostDepts=outCostDepts_"^"_tmp
	......//w outCostDepts,!
	......//确认该方法中分摊成本科室
	......s distDeptStr=..GetDistDepts(distDepts,inCostDepts,outCostDepts)  //C-02   R1
	......//w distDeptStr,!
	......//取当前分摊方法中包含成本项或不包含成本项
	......s distItems=..GetDistItems(costDistSetDr,childSub)                //C-03   R2+R3
	......//w distItems,!
	......//取参数类别O、参数项P、当量Q
	......s params=..GetDistParams(costDistSetDr,childSub)                  //C-04   OPQ
	......//w params,!
	......//取受众科室R7
	......s recCostDepts=..GetRecDepts(costDistSetDr,childSub,recDepts)     //C-05   R7
	......//w recCostDepts,!
	......//取分摊参数区间
	......s distCycles=""
	......//w intervalDr,!
	......//w paramPeriod,!
	......i intervalDr'="" && paramPeriod'="" d
	.......s perChild=0
	.......f  s perChild=$o(^DHCCAACCOUNTMONTHS(0,"Period",intervalDr,paramPeriod,perChild)) q:perChild=""  d
	........i $d(^DHCCAACCOUNTMONTHS(intervalDr,"Periods",perChild)) d
	.........s tmp=$p(^DHCCAACCOUNTMONTHS(intervalDr,"Periods",perChild),"^",2)
	.........i tmp'="" d
	..........i distCycles="" s distCycles=tmp
	..........e  s distCycles=distCycles_"^"_tmp
	......//w distCycles,!
	......//判断分摊方式
	......//w ioFlag,!
	......i ioFlag="Y" d  //收支配比-------------------------------
	.......//w ioFlag,!
	......e  d            //比例
	.......//w ioFlag,!
	.......//计算分摊比例
	.......s distRate=..GetDistRate(costDistSetDr,distCycles,recCostDepts,params)           //C-06
	.......//w distRate,!
	.......i distRate'="" d
	........//执行分摊成本计算、置标志、保存数据
	........s distResult=..DoDist(costDistSetDr,intervalDr,distDeptStr,distItems,distRate,outItem)  //C-07

	q "OK"
}

/// Part: C-02
/// Creator: 许立新
/// CreatDate: 2010-1-12
/// Description: 计算分摊成本科室
/// Table: 
/// Input: distDepts-当前层可分摊成本科室,inCostDepts-包含成本科室,outCostDepts-不包含成本科室
/// Output: 
/// Return: 筛选出的成本分摊科室
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetDistDepts("1^2^3^4^5","","2^3")
ClassMethod GetDistDepts(distDepts, inCostDepts, outCostDepts) As %String
{
	n (distDepts,inCostDepts,outCostDepts)
	
	q:inCostDepts'="" inCostDepts
	q:outCostDepts="" distDepts
	
	s depts=""
	//distDepts-outCostDepts
	f i=1:1:$l(distDepts,"^") d
	.s tmp1=$p(distDepts,"^",i)
	.s flag=0
	.f j=1:1:$l(outCostDepts,"^") d
	..s tmp2=$p(outCostDepts,"^",j)
	..i tmp2'="" d
	..i tmp1=tmp2 s flag=1
	.i flag=0 d
	..i depts="" s depts=tmp1
	..e  s depts=depts_"^"_tmp1
	q depts
}

/// Part: C-03
/// Creator: 许立新
/// CreatDate: 2010-1-13
/// Description: 计算分摊成本项、不包含分摊成本项
/// Table: 
/// Input: costDistSetDr-成本分摊套,methodDr-分摊方法
/// Output: 
/// Return: 筛选出的成本项
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetDistItems(3,1)
ClassMethod GetDistItems(costDistSetDr, methodDr) As %String
{
	n (costDistSetDr,methodDr)
	
	q:costDistSetDr="" ""
	q:methodDr="" ""
	
	s inItems=""
	s outItems=""
	
	s inItemChild=0
	f  s inItemChild=$o(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"InCostItem",inItemChild)) q:inItemChild=""  d
	.i $d(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"InCostItem",inItemChild)) d
	..s itemDr=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"InCostItem",inItemChild),"^",1)
	..//w itemDr,!
	..i inItems="" s inItems=itemDr
	..e  s inItems=inItems_"^"_itemDr
	
	s outItemChild=0
	f  s outItemChild=$o(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"OutCostItem",outItemChild)) q:outItemChild=""  d
	.i $d(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"OutCostItem",outItemChild)) d
	..s itemDr=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"OutCostItem",outItemChild),"^",1)
	..//w itemDr,!
	..i outItems="" s outItems=itemDr
	..e  s outItems=outItems_"^"_itemDr
	
	q:inItems'="" "I"_"!"_inItems
	q:outItems'="" "O"_"!"_outItems
	q ""
}

/// Part: C-04
/// Creator: 许立新
/// CreatDate: 2010-1-13
/// Description: 取分摊参数类型、分摊参数项、分摊参数当量
/// Table: 
/// Input: costDistSetDr-成本分摊套,methodDr-分摊方法
/// Output: 
/// Return: 筛选出的分摊参数类型、分摊参数项、分摊参数当量
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetDistParams(3,1)
ClassMethod GetDistParams(costDistSetDr, methodDr) As %String
{
	n (costDistSetDr,methodDr)
	
	q:costDistSetDr="" ""
	q:methodDr="" ""
	
	s distParams=""
	
	s distParamChild=0
	f  s distParamChild=$o(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"DistParams",distParamChild)) q:distParamChild=""  d
	.i $d(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"DistParams",distParamChild)) d
	..s type=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"DistParams",distParamChild),"^",1)
	..s item=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"DistParams",distParamChild),"^",2)
	..s right=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"DistParams",distParamChild),"^",3)
	..s tmp=type_"!"_item_"!"_right
	..i distParams="" s distParams=tmp
	..e  s distParams=distParams_"^"_tmp
	
	q distParams
}

/// Part: C-05
/// Creator: 许立新
/// CreatDate: 2010-1-13
/// Description: 取成本接收科室
/// Table: 
/// Input: costDistSetDr-成本分摊套,methodDr-分摊方法,lowLayerDepts-下层科室
/// Output: 
/// Return: 筛选出的成本接收科室
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetRecDepts(1,1,"1^2^3^4^5")
ClassMethod GetRecDepts(costDistSetDr, methodDr, lowLayerDepts) As %String
{
	n (costDistSetDr,methodDr,lowLayerDepts)
	
	//包含受众
	s inRecDepts=""
	s inRecDeptDr=0
	f  s inRecDeptDr=$o(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"InRecDept",inRecDeptDr)) q:inRecDeptDr=""  d
	.i $d(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"InRecDept",inRecDeptDr)) d
	..s dept=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"InRecDept",inRecDeptDr),"^",1)
	..s rate=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"InRecDept",inRecDeptDr),"^",2)
	..i rate="" || rate=0 d
	...i inRecDepts="" s inRecDepts=dept
	...e  s inRecDepts=inRecDepts_"^"_dept
	..e  d
	...i inRecDepts="" s inRecDepts=dept_"!"_rate
	...e  s inRecDepts=inRecDepts_"^"_dept_"!"_rate
	//w inRecDepts,!
	
	//不包含受众
	s outRecDepts=""
	s outRecDeptDr=0
	f  s outRecDeptDr=$o(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"OutRecDept",outRecDeptDr)) q:outRecDeptDr=""  d
	.i $d(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"OutRecDept",outRecDeptDr)) d
	..s dept=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"OutRecDept",outRecDeptDr),"^",1)
	..i outRecDepts="" s outRecDepts=dept
	..e  s outRecDepts=outRecDepts_"^"_dept
	//w outRecDepts,!
	
	//s lowLayerDepts="11^12^14^15^16^17^18^19^20^21^22^23^24^25^26^27^28^29^30^31^33^35^36^37^38^190^2"
	//s inRecDepts="11!0.2^12!0.8"
	//s outRecDepts="11^12^14"
	
	q:inRecDepts'="" "I"_":"_inRecDepts
	q:outRecDepts="" "N"_":"_lowLayerDepts
	
	s depts=""
	f i=1:1:$l(lowLayerDepts,"^") d
	.s dept=$p(lowLayerDepts,"^",i)
	.s flag=0
	.f j=1:1:$l(outRecDepts,"^") d
	..s dept1=$p(outRecDepts,"^",j)
	..i dept=dept1 s flag=1
	.i flag=0 d
	..i depts="" s depts=dept
	..e  s depts=depts_"^"_dept
	
	s depts="N"_":"_depts
	
	q depts
}

//d ##class(dhc.ca.cache.udata.CostDist).a()

ClassMethod a()
{
	d ..GetDistRate("1","1","N:12^13^14^106","param!877!0.2^cost!139!0.3^income!55!0.5")
}

/// Part: C-06
/// Creator: 许立新
/// CreatDate: 2010-1-17
/// Description: 计算科室分摊比例
/// Table: 
/// Input: distCycles-分摊参数区间,recCostDepts-受众科室,param-分摊参数
/// Output: 
/// Return: 接收科室分摊比例
/// Others: w ##class(dhc.ca.cache.udata.CostDist).GetDistRate("1","1^2","I:12!0.2^13!0.3^14!0.5","param!877!0.2^cost!139!0.3^income!133!0.5")
ClassMethod GetDistRate(costDistSetDr, distCycles, recCostDepts, params) As %String
{
	n (costDistSetDr,distCycles,recCostDepts,params)
	
	s rate=""
	
	q:costDistSetDr="" rate
	q:distCycles="" rate
	q:recCostDepts="" rate
	q:params="" rate
	
	//接收科室标志I，有比例直接返回比例
	s flag=$p(recCostDepts,":",1)
	s depts=$p(recCostDepts,":",2)
	//w deps
	q:depts="" rate
	
	s rateFlag=0
	
	i flag="I" d //判断包含比例
	.i depts'="" d
	..f i=1:1:$l(depts,"^") d
	...s tmpStr=$p(depts,"^",i)
	...//w tmpStr,"----"
	...s rate=$p(tmpStr,"!",2)
	...//w rate,"--------"
	...i rate>0 s rateFlag=1
	...//w rateFlag,!
	
	i rateFlag=1 d
	.f i=1:1:$l(depts,"^") d
	..s tempStr=$p(depts,"^",i)
	..//w tempStr,"--------"
	..s dep=$p(tempStr,"!",1)
	..s rat=$p(tempStr,"!",2)
	..s out=dep_"!"_rat
	..//w out,!
	..i dep'="" d
	...i rat'="" d
	....i rate="" s rate=out
	....e  s rate=rate_"^"_out
	
	q:rateFlag=1 rate
	
	//没有比例，计算比例
	//w distCycles,"---",depts,"---",params,!
	q:depts="" rate
	
	//循环参数
	k ^TMPDHCCACAL("dhc","ca","distParam")
	
	f i=1:1:$l(params,"^") d
	.s paramStr=$p(params,"^",i)
	.//w paramStr,!
	.s paramType=$p(paramStr,"!",1)
	.s paramItem=$p(paramStr,"!",2)
	.s paramRight=$p(paramStr,"!",3)
	.//w paramType_"^"_paramItem_"^"_paramRight,!
	.i paramType'="" d
	..i paramItem'="" d
	...i paramRight="" s paramRight=1
	...//不同参数类型数据来源不同
	...i paramType="cost" d
	....f mi=1:1:$l(distCycles,"^") d
	.....s interval=$p(distCycles,"^",mi)
	.....i interval'="" d
	......f di=1:1:$l(depts,"^") d
	.......s recDept=$p(depts,"^",di)
	.......//w interval_"^"_recDept,!
	.......i recDept'="" d
	........s child=0
	........f  s child=$o(^DHCCACOSTDISTSETS(0,"DIntDistdeptItem",costDistSetDr,interval,recDept,paramItem,child)) q:child=""  d
	.........//w "^DHCCACOSTDISTSETS(0,DIntDistdeptItem,"_costDistSetDr_","_interval_","_recDept_","_paramItem_","_child_")",!
	.........i $d(^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",child)) d
	..........s tmp=$g(^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",child))
	..........//w "^DHCCACOSTDISTSETS("_costDistSetDr_",""CostResultData"","_child_")"_"="_tmp,!
	..........s fee=$p(tmp,"^",5)
	..........s distFlag=$p(tmp,"^",6)
	..........//w distFlag_"^"_fee,!
	..........i distFlag="self" d
	...........s rightFee=fee*paramRight
	...........//w fee_"*"_paramRight_"="_rightFee,!
	...........i $d(^TMPDHCCACAL("dhc","ca","distParam",recDept)) d
	............s ^TMPDHCCACAL("dhc","ca","distParam",recDept)=^TMPDHCCACAL("dhc","ca","distParam",recDept)+rightFee
	...........e  s ^TMPDHCCACAL("dhc","ca","distParam",recDept)=rightFee
	...i paramType="param" d
	....f mi=1:1:$l(distCycles,"^") d
	.....s interval=$p(distCycles,"^",mi)
	.....i interval'="" d
	.....f di=1:1:$l(depts,"^") d
	......s recDept=$p(depts,"^",di)
	......//w interval_"^"_recDept,!
	......i recDept'="" d
	.......s paramDataDr=0
	.......f  s paramDataDr=$o(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",interval,recDept,paramItem,paramDataDr)) q:paramDataDr=""  d
	........i $d(^DHCCAPARAMDATAS(paramDataDr)) d
	.........//w interval_"^"_recDept_"^"_paramItem_"^"_^DHCCAPARAMDATAS(paramDataDr),!
	.........s tmp=^DHCCAPARAMDATAS(paramDataDr)
	.........s fee=$p(tmp,"^",11)
	.........s rightFee=fee*paramRight
	.........//w fee_"*"_paramRight_"="_rightFee,!
	.........i $d(^TMPDHCCACAL("dhc","ca","distParam",recDept)) d
	..........s ^TMPDHCCACAL("dhc","ca","distParam",recDept)=^TMPDHCCACAL("dhc","ca","distParam",recDept)+rightFee
	.........e  s ^TMPDHCCACAL("dhc","ca","distParam",recDept)=rightFee
	...i paramType="income" d
	....f mi=1:1:$l(distCycles,"^") d
	.....s interval=$p(distCycles,"^",mi)
	.....i interval'="" d
	.....f di=1:1:$l(depts,"^") d
	......s recDept=$p(depts,"^",di)
	......//w interval_"^"_recDept,!
	......i recDept'="" d
	.......s incomeDataDr=0
	.......f  s incomeDataDr=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptItem",interval,recDept,paramItem,incomeDataDr)) q:incomeDataDr=""  d
	........i $d(^DHCCAINCOMEDATAS(incomeDataDr)) d
	.........//w interval_"^"_recDept_"^"_paramItem_"^"_^DHCCAINCOMEDATAS(incomeDataDr),!
	.........s tmp=^DHCCAINCOMEDATAS(incomeDataDr)
	.........s fee=$p(tmp,"^",7)
	.........s rightFee=fee*paramRight
	.........//w fee_"*"_paramRight_"="_rightFee,!
	.........i $d(^TMPDHCCACAL("dhc","ca","distParam",recDept)) d
	..........s ^TMPDHCCACAL("dhc","ca","distParam",recDept)=^TMPDHCCACAL("dhc","ca","distParam",recDept)+rightFee
	.........e  s ^TMPDHCCACAL("dhc","ca","distParam",recDept)=rightFee
	//计算分母
	s sum=0
	s recDept=0
	f  s recDept=$o(^TMPDHCCACAL("dhc","ca","distParam",recDept)) q:recDept=""  d
	.i $d(^TMPDHCCACAL("dhc","ca","distParam",recDept)) d
	..s sum=sum+^TMPDHCCACAL("dhc","ca","distParam",recDept)
	//w sum,!
	//计算比例
	i sum>0 d
	.s recDept=0
	.f  s recDept=$o(^TMPDHCCACAL("dhc","ca","distParam",recDept)) q:recDept=""  d
	..i $d(^TMPDHCCACAL("dhc","ca","distParam",recDept)) d
	...s vol=^TMPDHCCACAL("dhc","ca","distParam",recDept)
	...//w recDept_"^"_vol,!
	...s rat=vol/sum
	...//w rat,!
	...//生成字符串
	...i rat>0 d
	....i rate="" s rate=recDept_"!"_rat
	....e  s rate=rate_"^"_recDept_"!"_rat
	
	q rate
}

///  Part: C-07
///  Creator: 许立新
///  CreatDate: 2010-1-17
///  Description: 执行普通成本分摊、保存数据、设置标志
///  Table: 
///  Input: costDistSetDr-成本分摊套,intervalDr-核算周期,distDeptStr-成本科室,distItems-成本项目,distRate-分摊比例,outItem-输出成本项
///  Output: 
///  Return: 
///  Others: w ##class(dhc.ca.cache.udata.CostDist).DoDist(costDistSetDr,intervalDr,distDeptStr,distItems,distRate)
ClassMethod DoDist(costDistSetDr, intervalDr, distDeptStr, distItems, distRate, outItem) As %String
{
	//q ""
	n (costDistSetDr,intervalDr,distDeptStr,distItems,distRate,outItem)
	
	//w costDistSetDr_"^"_intervalDr_"^"_distDeptStr_"^"_distItems_"^"_outItem,!
	//w distRate,!
	
	i distItems="" d  //成本项无限制
	.f depts=1:1:$l(distDeptStr,"^") d
	..s dept=$p(distDeptStr,"^",depts)
	..i dept'="" d
	...s sumFee=0
	...s itemDr=""
	...f  s itemDr=$o(^DHCCACOSTDISTSETS(0,"DIntDistdeptItem",costDistSetDr,intervalDr,dept,itemDr)) q:itemDr=""  d
	....i $d(^DHCCACOSTDISTSETS(0,"DIntDistdeptItem",costDistSetDr,intervalDr,dept,itemDr)) d
	.....s childSub=0
	.....f  s childSub=$o(^DHCCACOSTDISTSETS(0,"DIntDistdeptItem",costDistSetDr,intervalDr,dept,itemDr,childSub)) q:childSub=""  d
	......i $d(^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",childSub)) d
	.......s tmp=^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",childSub)
	.......//w tmp ,!
	.......s fee=$p(tmp,"^",5)
	.......//w fee,!
	.......s dealFlag=$p(tmp,"^",7)
	.......i dealFlag'="Y" d          //未分摊成本才可以分摊
	........i fee'=0 d                //本条费用不为0就执行分摊
	.........s sumFee=sumFee+fee
	.........//w sumFee,!
	.........//costDistSetDr-成本分摊套,intervalDr-核算周期,dept-来源科室,itemDr-成本项,outItem-输出成本项
	.........f i=1:1:$l(distRate,"^") d
	..........s tmpStr=$p(distRate,"^",i)
	..........i tmpStr'="" d
	...........s tmpDept=$p(tmpStr,"!",1)
	...........s tmpRate=$p(tmpStr,"!",2)
	...........i tmpDept'="" && tmpRate'="" d
	............s tmpFee=fee*tmpRate
	............//"核算周期Dr^被分摊部门Dr^分摊部门Dr^成本项Dr^成本金额^分摊标志^处理标志"
	............i outItem="" d
	.............s data=intervalDr_"^"_dept_"^"_tmpDept_"^"_itemDr_"^"_tmpFee_"^"_"dist"_"^"_"N"
	.............//w data,!
	.............d ..InsertCost(costDistSetDr,data)
	........&SQL(UPDATE dhc_ca_cache_data.CostResultData SET CostResultData_dealFlag='Y' WHERE CostResultData_parRef=:costDistSetDr AND CostResultData_childSub=:childSub)
	...i outItem'="" d
	....i sumFee'=0 d
	.....//w outItem_":"_sumFee,!
	.....f i=1:1:$l(distRate,"^") d
	......s tmpStr=$p(distRate,"^",i)
	......i tmpStr'="" d
	.......s tmpDept=$p(tmpStr,"!",1)
	.......s tmpRate=$p(tmpStr,"!",2)
	.......i tmpDept'="" && tmpRate'="" d
	........s tmpFee=sumFee*tmpRate
	........//w tmpDept_":"_tmpFee,!
	........//"核算周期Dr^被分摊部门Dr^分摊部门Dr^成本项Dr^成本金额^分摊标志^处理标志"
	........s data=intervalDr_"^"_dept_"^"_tmpDept_"^"_outItem_"^"_tmpFee_"^"_"dist"_"^"_"N"
	........//w data,!
	........d ..InsertCost(costDistSetDr,data)
	e  d              //成本项有限制 I!2^3 or O!5^9
	.s flag=$p(distItems,"!",1)
	.s items=$p(distItems,"!",2)
	.//w flag_"^"_items,!
	.i flag="I" d
	..//只分摊指定成本项数据
	..//w flag,!
	..f depts=1:1:$l(distDeptStr,"^") d
	...s dept=$p(distDeptStr,"^",depts)
	...i dept'="" d
	....//w dept,!
	....s sumFee=0
	....//w dept_":"_items,!
	....f i=1:1:$l(items,"^") d
	.....s itemDr=$p(items,"^",i)
	.....//w itemDr,!
	.....s childSub=0
	.....f  s childSub=$o(^DHCCACOSTDISTSETS(0,"DIntDistdeptItem",costDistSetDr,intervalDr,dept,itemDr,childSub)) q:childSub=""  d
	......i $d(^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",childSub)) d
	.......s tmp=^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",childSub)
	.......//w tmp,!
	.......s fee=$p(tmp,"^",5)
	.......//w fee,!
	.......s dealFlag=$p(tmp,"^",7)
	.......//w dealFlag,!
	.......i dealFlag'="Y" d       //未分摊成本才可以分摊
	........i fee'=0 d             //本条费用不为0就执行分摊
	.........s sumFee=sumFee+fee   //指定输出成本项时的被分摊成本汇总
	.........//w dept_":"_itemDr_":"_sumFee,!
	.........//costDistSetDr-成本分摊套,intervalDr-核算周期,dept-来源科室,itemDr-成本项,outItem-输出成本项
	.........i outItem="" d
	..........//w dept_":"_itemDr_":"_fee,!
	..........f rates=1:1:$l(distRate,"^") d
	...........s tmpStr=$p(distRate,"^",rates)
	...........//w itemDr_":"_tmpStr,!
	...........i tmpStr'="" d
	............s tmpDept=$p(tmpStr,"!",1)
	............s tmpRate=$p(tmpStr,"!",2)
	............i tmpDept'="" && tmpRate'="" d
	.............s tmpFee=fee*tmpRate
	.............//w itemDr_":"_tmpDept_":"_tmpFee,!
	.............//"核算周期Dr^被分摊部门Dr^分摊部门Dr^成本项Dr^成本金额^分摊标志^处理标志"
	.............s data=intervalDr_"^"_dept_"^"_tmpDept_"^"_itemDr_"^"_tmpFee_"^"_"dist"_"^"_"N"
	.............//w data,!
	.............d ..InsertCost(costDistSetDr,data)
	........&SQL(UPDATE dhc_ca_cache_data.CostResultData SET CostResultData_dealFlag='Y' WHERE CostResultData_parRef=:costDistSetDr AND CostResultData_childSub=:childSub)
	....i outItem'="" d
	.....i sumFee'=0 d
	......//w dept_":"_sumFee,!
	......//costDistSetDr-成本分摊套,intervalDr-核算周期,dept-来源科室,itemDr-成本项,outItem-输出成本项
	......//w distRate,!
	......f rates=1:1:$l(distRate,"^") d
	.......s tmpStr=$p(distRate,"^",rates)
	.......i tmpStr'="" d
	........//w tmpStr,!
	........s tmpDept=$p(tmpStr,"!",1)
	........s tmpRate=$p(tmpStr,"!",2)
	........//w tmpDept_"^"_tmpRate,!
	........i tmpDept'="" && tmpRate'="" d
	.........s tmpFee=sumFee*tmpRate
	.........//w tmpFee,!
	.........//"核算周期Dr^被分摊部门Dr^分摊部门Dr^成本项Dr^成本金额^分摊标志^处理标志"
	.........s data=intervalDr_"^"_dept_"^"_tmpDept_"^"_outItem_"^"_tmpFee_"^"_"dist"_"^"_"N"
	.........//w data,!
	.........d ..InsertCost(costDistSetDr,data)
	.i flag="O" d
	..//只分摊指定成本项以外数据
	..//w flag,!
	..f depts=1:1:$l(distDeptStr,"^") d
	...s sumFee=0
	...s dept=$p(distDeptStr,"^",depts)
	...i dept'="" d
	....//w dept,!
	....s itemDr=""
	....f  s itemDr=$o(^DHCCACOSTDISTSETS(0,"DIntDistdeptItem",costDistSetDr,intervalDr,dept,itemDr)) q:itemDr=""  d
	.....//w itemDr,!
	.....//w items,!
	.....s inFlag=..In(itemDr,items)
	.....i inFlag'="Y" d
	......i $d(^DHCCACOSTDISTSETS(0,"DIntDistdeptItem",costDistSetDr,intervalDr,dept,itemDr)) d
	.......s childSub=0
	.......f  s childSub=$o(^DHCCACOSTDISTSETS(0,"DIntDistdeptItem",costDistSetDr,intervalDr,dept,itemDr,childSub)) q:childSub=""  d
	........i $d(^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",childSub)) d
	.........s tmp=^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",childSub)
	.........//w tmp,!
	.........s fee=$p(tmp,"^",5)
	.........//w fee,!
	.........s dealFlag=$p(tmp,"^",7)
	.........//w dealFlag,!
	.........i dealFlag'="Y" d       //未分摊成本才可以分摊
	..........i fee'=0 d             //本条费用不为0就执行分摊
	...........s sumFee=sumFee+fee   //指定输出成本项时的被分摊成本汇总
	...........//w sumFee,!
	...........//costDistSetDr-成本分摊套,intervalDr-核算周期,dept-来源科室,itemDr-成本项,outItem-输出成本项
	...........i outItem="" d
	............f i=1:1:$l(distRate,"^") d
	.............s tmpStr=$p(distRate,"^",i)
	.............i tmpStr'="" d
	..............s tmpDept=$p(tmpStr,"!",1)
	..............s tmpRate=$p(tmpStr,"!",2)
	..............i tmpDept'="" && tmpRate'="" d
	...............s tmpFee=fee*tmpRate
	...............//w tmpFee,!
	...............//"核算周期Dr^被分摊部门Dr^分摊部门Dr^成本项Dr^成本金额^分摊标志^处理标志"
	...............s data=intervalDr_"^"_dept_"^"_tmpDept_"^"_itemDr_"^"_tmpFee_"^"_"dist"_"^"_"N"
	...............//w data,!
	...............d ..InsertCost(costDistSetDr,data)
	..........&SQL(UPDATE dhc_ca_cache_data.CostResultData SET CostResultData_dealFlag='Y' WHERE CostResultData_parRef=:costDistSetDr AND CostResultData_childSub=:childSub)
	....//w dept_":"_sumFee,!
	....i outItem'="" d
	.....i sumFee'=0 d
	......//costDistSetDr-成本分摊套,intervalDr-核算周期,dept-来源科室,itemDr-成本项,outItem-输出成本项
	......//w distRate,!
	......f i=1:1:$l(distRate,"^") d
	.......s tmpStr=$p(distRate,"^",i)
	.......i tmpStr'="" d
	........//w tmpStr,!
	........s tmpDept=$p(tmpStr,"!",1)
	........s tmpRate=$p(tmpStr,"!",2)
	........//w tmpDept_"^"_tmpRate,!
	........i tmpDept'="" && tmpRate'="" d
	.........s tmpFee=sumFee*tmpRate
	.........//w tmpFee,!
	.........//"核算周期Dr^被分摊部门Dr^分摊部门Dr^成本项Dr^成本金额^分摊标志^处理标志"
	.........s data=intervalDr_"^"_dept_"^"_tmpDept_"^"_outItem_"^"_tmpFee_"^"_"dist"_"^"_"N"
	.........//w data,!
	.........d ..InsertCost(costDistSetDr,data)
	
	q "OK"
}

///  Part: C-08
///  Creator: 许立新
///  CreatDate: 2010-1-17
///  Description: 判断传入id是否在指定列表中
///  Table: 
///  Input: id,ids
///  Output: 
///  Return: 
///  Others: w ##class(dhc.ca.cache.udata.CostDist).In(id,ids)
ClassMethod In(id, ids) As %String
{
	n (id,ids)
	
	s result="N"

	f i=1:1:$l(ids,"^") d
	.s tmp=$p(ids,"^",i)
	.i tmp=id  s result="Y"
	
	q result
}

Storage Default
{
<StreamLocation>^dhc.ca.c.CostDistS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
