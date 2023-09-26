/// Creator: 许立新
/// CreatDate: 2010-3-15
/// Description: 直接成本归集与成本分摊
Class dhc.ca.cache.udata.DoCostDist1 Extends (%SerialObject, %Populate, %XML.Adaptor) [ ClassType = serial, Inheritance = right, Not ProcedureBlock ]
{

/// Part: A-01
/// Creator: 许立新
/// CreatDate: 2010-3-16
/// Description: 成本分摊入口
/// Table: 
/// Input: costDistSetDr-成本分摊套,intervalDr-核算周期
/// Output: 
/// Return: 分摊结果
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).DistStart(1,25)
ClassMethod DistStart(costDistSetDr, intervalDr) As %String
{
	n (costDistSetDr,intervalDr)
	
	s result="OK"
	
	//直接成本归集
	s r1=..SetDirectCost(costDistSetDr, intervalDr)
	
	//成本分摊
	s r2=..CostDist(costDistSetDr,intervalDr)
	
	//分摊结果汇总
	s r3=##class(dhc.ca.cache.udata.uCostResultData).GetAllTotal(intervalDr,costDistSetDr,"")
	
	q "OK"
}

/// Part: B-01
/// Creator: 许立新
/// CreatDate: 2010-3-15
/// Description: 直接成本归集
/// Table: dhc.ca.cache.data.VouchDatas,dhc.ca.cache.data.BaseData,dhc.ca.cache.data.CostResultData
/// Input: costDistSetDr-成本分摊套,intervalDr-核算周期
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).SetDirectCost(1,5)
ClassMethod SetDirectCost(costDistSetDr, intervalDr) As %String
{
	n (costDistSetDr,intervalDr)
	
	//数据来源VouchDatas、BaseData
	
	//清除临时global
	
	k ^TMPDHCCACALCOST("dhc","ca")
	
	//汇总凭证数据
	i costDistSetDr = 1  d 
	.s r1=..GetVouchCost(costDistSetDr,intervalDr)
	e  d 
	.s r2=..GetBaseCost("cost","12",intervalDr,costDistSetDr) 
	//20140923 zjw 屏蔽
	/*
	//汇总人员相关数据,基本成本数据
	s r2=..GetBaseCost("cost","12",intervalDr)    //12为工资数据类
	
	//汇总大额数据
	s r3=..GetLargCost(costDistSetDr,intervalDr)
	*/
	//保存直接成本数据
	s r3=..WriteDirectCost(costDistSetDr, intervalDr)
	
	//清除临时global
	k ^TMPDHCCACALCOST("dhc","ca")
	
	
	q "OK"
}

/// Part: B-02
/// Creator: 许立新
/// CreatDate: 2010-3-15
/// Description: 汇总凭证表成本数据。^TMPDHCCACALCOST("dhc","ca","directCost",deptDr,costItemDr)=金额
/// Table: dhc.ca.cache.data.VouchDatas
/// Input: intervalDr-核算周期
/// Output: 
/// Return: 完成标志
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetVouchCost(1)
ClassMethod GetVouchCost(costDistSetDr, intervalDr) As %String
{
	n (costDistSetDr,intervalDr)
	
	//获取当前分摊套对应的医院的科室全成本分摊分层DR
	s unitrid=$P(^DHCCACOSTDISTSETS(costDistSetDr),"^",5)
	
	s rowid=0
	f  s rowid=$o(^DHCCAVOUCHDATAS(0,"Interval",intervalDr,rowid)) q:rowid=""  d
	.i $d(^DHCCAVOUCHDATAS(rowid)) d
	..s deptDr=$p(^DHCCAVOUCHDATAS(rowid),"^",2)
	..s parent="" f  s parent=$o(^DHCCADEPTLEVELSETS(0,"Parent",unitrid,parent)) q:parent=""  d		//zjw  只取该分摊套对应的医院科室直接成本  
	...q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",parent,deptDr))  
	...s itemDr=$p(^DHCCAVOUCHDATAS(rowid),"^",3)
	...s fee=$p(^DHCCAVOUCHDATAS(rowid),"^",16)-$p(^DHCCAVOUCHDATAS(rowid),"^",17)
	...i (deptDr'="") && (itemDr'="") && (fee'=0) d
	....s tmp=$g(^TMPDHCCACALCOST("dhc","ca","directCost",deptDr,itemDr))
	....i tmp="" s ^TMPDHCCACALCOST("dhc","ca","directCost",deptDr,itemDr)=fee
	....e  s ^TMPDHCCACALCOST("dhc","ca","directCost",deptDr,itemDr)=tmp+fee

	q "OK"
}

/// Part: B-03
/// Creator: 许立新
/// CreatDate: 2010-3-15
/// Description: 汇总基本数据表成本。^TMPDHCCACALCOST("dhc","ca","directCost",deptDr,costItemDr)=金额
/// Table: dhc.ca.cache.data.BaseData
/// Input: sysDataType-系统数据类型,dataTypeDr-数据类别,intervalDr-核算周期
/// Output: 
/// Return: 完成标志
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetBaseCost("cost",12,1)
ClassMethod GetBaseCost(sysDataType, dataTypeDr, intervalDr, costDistSetDr) As %String
{
	n (sysDataType,dataTypeDr,intervalDr,costDistSetDr)
	
	s parent=""
	s unitrid=$P(^DHCCACOSTDISTSETS(costDistSetDr),"^",5)	//20110422卢晓春
	s rowid=0
	f  s rowid=$o(^DHCCABASEDATA(0,"IntSys",intervalDr,sysDataType,rowid)) q:rowid=""  d
	.q:'$d(^DHCCABASEDATA(rowid))
	.s tmpData=^DHCCABASEDATA(rowid)
	.i tmpData'="" d
	..s dataType=$p(tmpData,"^",3)
	..s item=$p(tmpData,"^",5)
	..s fee=$p(tmpData,"^",22)
	..s flag=##class(dhc.ca.cache.udata.DoIncomeDist).IsIn(dataType,dataTypeDr,"^")
	..i flag="Y" d    //人员相关数据处理
	...s person=$p(tmpData,"^",17)
	...i person'="" d
	....s sumRate=0
	....s child=0
	....f  s child=$o(^DHCCAUNITPERSONS(person,"PersonDepts",child)) q:child=""  d
	.....s tmp=$g(^DHCCAUNITPERSONS(person,"PersonDepts",child))
	.....i tmp'="" d
	......s sumRate=sumRate+$p(tmp,"^",2)
	....i sumRate'=0 d
	.....s child=0
	.....f  s child=$o(^DHCCAUNITPERSONS(person,"PersonDepts",child)) q:child=""  d
	......s tmp=$g(^DHCCAUNITPERSONS(person,"PersonDepts",child))
	......i tmp'="" d
	.......s dept=$p(tmp,"^",1) q:dept=""
	.......f  s parent=$o(^DHCCADEPTLEVELSETS(0,"Parent",unitrid,parent)) q:parent=""  d  //20110422卢晓春
	........q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",parent,dept))  
	........s rate=$p(tmp,"^",2)
	........s tmpFee=fee*rate/sumRate
	........i (dept'="") && (item'="") && (tmpFee'=0) d
	.........s t=$g(^TMPDHCCACALCOST("dhc","ca","directCost",dept,item))
	.........i t="" s ^TMPDHCCACALCOST("dhc","ca","directCost",dept,item)=tmpFee
	.........e  s ^TMPDHCCACALCOST("dhc","ca","directCost",dept,item)=t+tmpFee
	..e  d            //科室相关数据处理
	...s dept=$p(tmpData,"^",14) q:dept=""
	...f  s parent=$o(^DHCCADEPTLEVELSETS(0,"Parent",unitrid,parent)) q:parent=""  d  //20110422卢晓春
	....q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",parent,dept))  
	....i (dept'="") && (item'="") && (fee'=0) d 
	.....s tmp=$g(^TMPDHCCACALCOST("dhc","ca","directCost",dept,item))
	.....i tmp="" s ^TMPDHCCACALCOST("dhc","ca","directCost",dept,item)=fee
	.....e  s ^TMPDHCCACALCOST("dhc","ca","directCost",dept,item)=tmp+fee
	
	q "OK"
}

/// Part: B-04
/// Creator: 许立新
/// CreatDate: 2010-3-26
/// Description: 汇总大额成本数据。^TMPDHCCACALCOST("dhc","ca","directCost",deptDr,costItemDr)=金额
/// Table: dhc.ca.cache.data.LargCostDetail
/// Input: intervalDr-核算周期
/// Output: 
/// Return: 完成标志
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetLargCost(1)
ClassMethod GetLargCost(costDistSetDr, intervalDr) As %String
{
	n (costDistSetDr,intervalDr)
	
	q:intervalDr="" "intervalDrErr"
	
	s interval=$g(^DHCCAACCOUNTMONTHS(intervalDr))
	
	q:interval="" "intervalErr"
	
	s parent=""
	s unitrid=$P(^DHCCACOSTDISTSETS(costDistSetDr),"^",5)
	
	s start=$p(interval,"^",4)
	s end=$p(interval,"^",5)
	s pr=0
	f  s pr=$o(^DHCCALARGCOST(0,"DetailDate",pr)) q:pr=""  d
	.s date=""
	.f  s date=$o(^DHCCALARGCOST(0,"DetailDate",pr,date)) q:date=""  d
	..i (date>=start) && (date<=end) d
	...s child=0
	...f  s child=$o(^DHCCALARGCOST(0,"DetailDate",pr,date,child)) q:child=""  d
	....i $d(^DHCCALARGCOST(pr,"Detail",child)) d
	.....s fee=$p(^DHCCALARGCOST(pr,"Detail",child),"^",2)
	.....i (fee'=0) && (fee'="") d
	......i $d(^DHCCALARGCOST(pr)) d
	.......s dept=$p(^DHCCALARGCOST(pr),"^",4)
	.......f  s parent=$o(^DHCCADEPTLEVELSETS(0,"Parent",unitrid,parent)) q:parent=""  d  //20110422卢晓春
	........q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",parent,dept))  //20110422卢晓春
	........s item=$p(^DHCCALARGCOST(pr),"^",5)
	........i (dept'="") && (item'="") d
	.........s tmp=$g(^TMPDHCCACALCOST("dhc","ca","directCost",dept,item))
	.........i tmp="" s ^TMPDHCCACALCOST("dhc","ca","directCost",dept,item)=fee
	.........e  s ^TMPDHCCACALCOST("dhc","ca","directCost",dept,item)=tmp+fee
	
	q "OK"
}

/// Part: C-01
/// Creator: 许立新
/// CreatDate: 2010-3-16
/// Description: 直接成本写入
/// Table: dhc.ca.cache.data.CostResultData
/// Input: costDistSetDr-成本分摊套,intervalDr-核算周期
/// Output: 
/// Return: 完成标志
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).WriteDirectCost(1,1)
ClassMethod WriteDirectCost(costDistSetDr, intervalDr) As %String
{
   
	n (costDistSetDr,intervalDr)
	
	q:costDistSetDr="" "distSetErr"
	q:intervalDr="" "intervalErr"
	
	s result="OK"
	
	s dept=0
	f  s dept=$o(^TMPDHCCACALCOST("dhc","ca","directCost",dept)) q:dept=""  d
	.s item=0
	.f  s item=$o(^TMPDHCCACALCOST("dhc","ca","directCost",dept,item)) q:item=""  d
	..s fee=$g(^TMPDHCCACALCOST("dhc","ca","directCost",dept,item))
	..i (fee'="") && (fee'=0) d
	...s data=intervalDr_"^^"_dept_"^"_item_"^"_fee_"^self^N"
	...s r=..InsertCost(costDistSetDr,data)
	...i r'=0 s result="Err"
	
	q result
}

/// Part: D-01
/// Creator: 许立新
/// CreatDate: 2010-3-16
/// Description: 开始成本分摊
/// Table: dhc.ca.cache.data.CostResultData;dhc.ca.cache.data.CostDistMethods
/// Input: costDistSetDr-成本分摊套,intervalDr-核算周期
/// Output: 
/// Return: 完成标志
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).CostDist(1,5)
ClassMethod CostDist(costDistSetDr, intervalDr) As %String
{
	n (costDistSetDr,intervalDr)

	s deptSetDr=""
	s distFlag=""

	i $d(^DHCCACOSTDISTSETS(costDistSetDr)) d
	.s deptSetDr=$p(^DHCCACOSTDISTSETS(costDistSetDr),"^",5)  //部门分层套
	.s distFlag=$p(^DHCCACOSTDISTSETS(costDistSetDr),"^",8)   //取分摊标志
	
	q:deptSetDr="" "DeptSetErr"
	
	s result1=..GetLayers(deptSetDr)                          //取出按优先级循环的成本科室分层套的每一有效层
															  // zjw 得到^TMPDHCCACALCOST("dhc","ca","layers",order,layerDr)
	s order=""
	f  s order=$o(^TMPDHCCACALCOST("dhc","ca","layers",order)) q:order=""  d  //循环成本分层
	.s layerDr=0                                              //当前核算层
	.f  s layerDr=$o(^TMPDHCCACALCOST("dhc","ca","layers",order,layerDr)) q:layerDr=""  d
	..s lowLayers=..GetLowLayers(order)                       //取当前核算层下的全部枝条  zjw 5^4^3...
	..s curLayerDepts=..GetCurrentLayerDepts(layerDr)         //取当前分层所有科室  zjw 包含枝条下枝条中的科室  depts=depts_"^"_deptDr_"!"_recFlag_"!"_distFlag
	..s lowLayerDepts=..GetLowLayerDepts(lowLayers)           //取当前分层下全部枝条的科室   depts=depts_"^"_deptDr_"!"_recFlag_"!"_distFlag
	..s distDepts=..GetDepts(curLayerDepts,3)                 //取当前分层下允许分摊成本的科室 result=result_"^"_dept
	..s recDepts=..GetDepts(lowLayerDepts,2)                  //取当前分层下层科室中允许接收成本的科室 result=result_"^"_dept
	..i recDepts'="" d                                        //允许接收成本的科室不为空才可以分摊
	...s priority=""                                          //按优先级循环当前分层的有效分摊方法
	...f  s priority=$o(^DHCCACOSTDISTSETS(0,"CDMSLP",costDistSetDr,layerDr,priority)) q:priority=""  d				//zjw取当前科室分层分摊方法优先级
	....s childSub=""
	....f  s childSub=$o(^DHCCACOSTDISTSETS(0,"CDMSLP",costDistSetDr,layerDr,priority,childSub)) q:childSub=""  d	//zjw取当前优先级,<每个优先级唯一,觉得该循环层可以取消>
	.....i $d(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub)) d
	......s name=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub),"^",4)		   //分摊方法名称
	......s outItem=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub),"^",5)     //输出成本项为空按原成本项
	......s paramPeriod=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub),"^",6) //分摊参数区间指针 本期区间的DR
	......s active=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub),"^",7)      //方法有效标志
	......s ioFlag=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub),"^",8)      //收支配比标志
	......i active="Y" d         //方法有效才按该方法进行分摊
	.......//取出被分摊成本定义
	.......s inCostDepts=..GetInCostDepts(costDistSetDr,childSub)                  //当前分摊方法中包含成本科室
	.......s outCostDepts=..GetOutCostDepts(costDistSetDr,childSub)                //当前分摊方法中不包含成本科室
	.......s distDeptStr=..GetDistDepts(distDepts,inCostDepts,outCostDepts)        //确认该方法中分摊成本的科室
	
	.......s distItems=..GetDistItems(costDistSetDr,childSub)                      //当前分摊方法中包含成本项或不包含成本项
	
	.......//取分摊参数
	.......s params=..GetDistParams(costDistSetDr,childSub)                        //分摊参数类别、参数项、当量 distParams=distParams_"^"_type_"!"_item_"!"_right
	
	.......s recCostDepts=..GetRecDepts(costDistSetDr,childSub,recDepts)           //受众科室
	
	.......s distCycles=""                                                         //分摊参数区间<zjw觉得若都取本期无需这么复杂,可调整;若是个别分摊参数的区间不用本期，则...待考虑>
	.......i (intervalDr'="") && (paramPeriod'="") d
	........s perChild=0
	........f  s perChild=$o(^DHCCAACCOUNTMONTHS(0,"Period",intervalDr,paramPeriod,perChild)) q:perChild=""  d
	.........i $d(^DHCCAACCOUNTMONTHS(intervalDr,"Periods",perChild)) d
	..........s tmp=$p(^DHCCAACCOUNTMONTHS(intervalDr,"Periods",perChild),"^",2)
	..........i tmp'="" d
	...........i distCycles="" s distCycles=tmp
	...........e  s distCycles=distCycles_"^"_tmp
	.......//生成被分摊成本数据/行号global
	.......k ^TMPDHCCACALCOST("dhc","ca","distedCost")
	.......s distedCost=..SetDistedCost(costDistSetDr,intervalDr,distDeptStr,distItems,outItem)
	.......//生成分摊比例:科室1!比例1^科室2!比例2^科室3!比例3
	.......s distRate=..GetDistRate(costDistSetDr, distCycles, recCostDepts, params,ioFlag)
	.......//数据分摊并保存
	.......i ioFlag="Y" d
	........s result=..CalcAndSave1(costDistSetDr,intervalDr)
	.......e  d
	........s result=..CalcAndSave(costDistSetDr,intervalDr,distRate)
	.......k ^TMPDHCCACALCOST("dhc","ca","distedCost")

	k ^TMPDHCCACALCOST("dhc","ca","Layer")
	k ^TMPDHCCACALCOST("dhc","ca","layers")
	
	q "OK"
}

/// Part: D-02
/// Creator: 许立新
/// CreatDate: 2010-3-17
/// Description: 取当前成本分层套的有效层
/// Table: 
/// Input: deptLevelSetsDr
/// Output: 
/// Return: 把当前成本分层套的有效层保存为临时global
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetLayers(1)
ClassMethod GetLayers(deptLevelSetsDr) As %String
{
	n (deptLevelSetsDr)
	
	k ^TMPDHCCACALCOST("dhc","ca","layers")
	
	s order=""
	f  s order=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",deptLevelSetsDr,order)) q:order=""  d
	.s layerDr=""
	.f  s layerDr=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",deptLevelSetsDr,order,layerDr)) q:layerDr=""  d
	..s active=$p(^DHCCADEPTLEVELSETS(layerDr),"^",6)
	..i active="Y" d
	...s ^TMPDHCCACALCOST("dhc","ca","layers",order,layerDr)=""
	
	q "OK"
}

/// Part: D-03
/// Creator: 许立新
/// CreatDate: 2010-3-17
/// Description: 取当前成本分层下的有效层
/// Table: 
/// Input: order
/// Output: 
/// Return: 当前成本分层下的有效层
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetLowLayers(2)
ClassMethod GetLowLayers(order) As %String
{
	n (order)
	
	s lowLayers=""
	f  s order=$o(^TMPDHCCACALCOST("dhc","ca","layers",order)) q:order=""  d
	.s layerDr=""
	.f  s layerDr=$o(^TMPDHCCACALCOST("dhc","ca","layers",order,layerDr)) q:layerDr=""  d
	..i lowLayers="" s lowLayers=layerDr
	..e  s lowLayers=lowLayers_"^"_layerDr

	q lowLayers
}

/// Part: D-04
/// Creator: 许立新
/// CreatDate: 2010-3-17
/// Description: 取当前层包含科室
/// Table: 
/// Input: layerDr-层ID
/// Output: 
/// Return: 当前层包含科室
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(3)
ClassMethod GetCurrentLayerDepts(layerDr) As %String
{
	n (layerDr)
	
	s depts=""
	s depts=..GetBranchDepts(layerDr) //取枝条科室
	s branchs=""
	s branchs=..GetBranchs(layerDr)   //取枝条的所有枝条
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

/// Part: D-05
/// Creator: 许立新
/// CreatDate: 2010-3-17
/// Description: 取当前枝下的科室
/// Table: 
/// Input: branchDr
/// Output: 
/// Return: 当前枝下的科室
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetBranchDepts(159)
ClassMethod GetBranchDepts(branchDr) As %String
{
	n (branchDr)
	
	q:branchDr="" ""
	
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

/// Part: D-06
/// Creator: 许立新
/// CreatDate: 2010-3-17
/// Description: 取枝条下的有效枝条
/// Table: 
/// Input: branchDr
/// Output: 
/// Return: 枝条下的有效枝条
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetBranchs(2)
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

/// Part: D-07
/// Creator: 许立新
/// CreatDate: 2010-3-17
/// Description: 取当前层的所有下层的科室
/// Table: 
/// Input: lowLayers-所有分层
/// Output: 
/// Return: 所有下层科室
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetLowLayerDepts("2^3^4^5^6^7^157")
ClassMethod GetLowLayerDepts(lowLayers) As %String
{
	n (lowLayers)
	
	q:lowLayers="" ""
	
	s depts=""
	
	f i=1:1:$l(lowLayers,"^") d
	.s currLayerDr=$p(lowLayers,"^",i)
	.i currLayerDr'="" d
	..s tmp=..GetCurrentLayerDepts(currLayerDr)
	..i tmp'="" d
	...i depts="" s depts=tmp
	...e  s depts=depts_"^"_tmp
	
	q depts
}

/// Part: D-08
/// Creator: 许立新
/// CreatDate: 2010-3-17
/// Description: 科室串中指定类型的科室
/// Table: 
/// Input: depts-科室,loc-位置:2接收,3分摊
/// Output: 
/// Return: 指定类型科室串
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetDepts("6!Y!N^7!Y!Y")
ClassMethod GetDepts(depts, loc) As %String
{
	n (depts,loc)

	q:depts="" ""
	
	s result=""
	
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

/// Part: D-09
/// Creator: 许立新
/// CreatDate: 2010-3-17
/// Description: 取成本过滤科室中的包含科室
/// Table: dhc.ca.cache.data.InCostDepts
/// Input: costDistSetDr-成本分摊套Dr,childSub-成本分摊方法Dr
/// Output: 包含成本科室
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetInCostDepts(1,1)
ClassMethod GetInCostDepts(costDistSetDr, childSub) As %String
{
	n (costDistSetDr,childSub)
	
	s inCostDepts=""      //当前分摊方法中包含成本科室
	s inCostDeptChildSub=0
	f  s inCostDeptChildSub=$o(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub,"InCostDept",inCostDeptChildSub)) q:inCostDeptChildSub=""  d
	.i $d(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub,"InCostDept",inCostDeptChildSub)) d
	..s tmp=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub,"InCostDept",inCostDeptChildSub),"^",1)
	..i tmp'="" d
	...i inCostDepts="" s inCostDepts=tmp
	...e  s inCostDepts=inCostDepts_"^"_tmp
	
	q inCostDepts
}

/// Part: D-10
/// Creator: 许立新
/// CreatDate: 2010-3-17
/// Description: 取成本过滤科室中的不包含科室
/// Table: dhc.ca.cache.data.OutCostDepts
/// Input: costDistSetDr-成本分摊套Dr,childSub-成本分摊方法Dr
/// Output: 
/// Return: 不包含成本科室
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetOutCostDepts(1,1)
ClassMethod GetOutCostDepts(costDistSetDr, childSub) As %String
{
	n (costDistSetDr,childSub)
	
	s outCostDepts=""     //当前分摊方法中不包含成本科室
	s outCostDeptChildSub=0
	f  s outCostDeptChildSub=$o(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub,"OutCostDept",outCostDeptChildSub)) q:outCostDeptChildSub=""  d
	.i $d(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub,"OutCostDept",outCostDeptChildSub)) d
	..s tmp=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",childSub,"OutCostDept",outCostDeptChildSub),"^",1)
	..i tmp'="" d
	...i outCostDepts="" s outCostDepts=tmp
	...e  s outCostDepts=outCostDepts_"^"_tmp
	
	q outCostDepts
}

/// Part: D-11
/// Creator: 许立新
/// CreatDate: 2010-1-12
/// Description: 计算分摊成本科室
/// Table: 
/// Input: distDepts-当前层可分摊成本科室,inCostDepts-包含成本科室,outCostDepts-不包含成本科室
/// Output: 
/// Return: 筛选出的成本分摊科室
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetDistDepts("1^2^3^4^5","","2^3")
ClassMethod GetDistDepts(distDepts, inCostDepts, outCostDepts) As %String
{
	n (distDepts,inCostDepts,outCostDepts)
	
	q:inCostDepts'="" inCostDepts
	q:outCostDepts="" distDepts
	
	s depts=""
	
	f i=1:1:$l(distDepts,"^") d            //distDepts-outCostDepts
	.s tmp1=$p(distDepts,"^",i)
	.s flag=0
	.f j=1:1:$l(outCostDepts,"^") d
	..s tmp2=$p(outCostDepts,"^",j)
	..i tmp2'="" d
	...i tmp1=tmp2 s flag=1
	.i flag=0 d
	..i depts="" s depts=tmp1
	..e  s depts=depts_"^"_tmp1
	q depts
}

/// Part: D-12
/// Creator: 许立新
/// CreatDate: 2010-1-13
/// Description: 计算分摊成本项、不包含分摊成本项
/// Table: 
/// Input: costDistSetDr-成本分摊套,methodDr-分摊方法
/// Output: 
/// Return: 筛选出的成本项
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetDistItems(3,1)
ClassMethod GetDistItems(costDistSetDr, methodDr) As %String
{
	n (costDistSetDr,methodDr)
	
	q:costDistSetDr="" ""
	q:methodDr="" ""
	
	s inItems=""
	s outItems=""
	
	s inItemChild=0
	f  s inItemChild=$o(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"InCostItem",inItemChild)) q:inItemChild=""  d
	.s itemDr=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"InCostItem",inItemChild),"^",1)
	.i inItems="" s inItems=itemDr
	.e  s inItems=inItems_"^"_itemDr
	
	s outItemChild=0
	f  s outItemChild=$o(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"OutCostItem",outItemChild)) q:outItemChild=""  d
	.s itemDr=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"OutCostItem",outItemChild),"^",1)
	.i outItems="" s outItems=itemDr
	.e  s outItems=outItems_"^"_itemDr
	
	q:inItems'="" "I"_"!"_inItems
	q:outItems'="" "O"_"!"_outItems
	
	q ""
}

/// Part: D-13
/// Creator: 许立新
/// CreatDate: 2010-1-13
/// Description: 取分摊参数类型、分摊参数项、分摊参数当量
/// Table: 
/// Input: costDistSetDr-成本分摊套,methodDr-分摊方法
/// Output: 
/// Return: 筛选出的分摊参数类型、分摊参数项、分摊参数当量
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetDistParams(3,1)
ClassMethod GetDistParams(costDistSetDr, methodDr) As %String
{
	n (costDistSetDr,methodDr)
	
	q:costDistSetDr="" ""
	q:methodDr="" ""
	
	s distParams=""
	
	s distParamChild=0
	f  s distParamChild=$o(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"DistParams",distParamChild)) q:distParamChild=""  d
	.s type=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"DistParams",distParamChild),"^",1)
	.s item=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"DistParams",distParamChild),"^",2)
	.s right=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"DistParams",distParamChild),"^",3)
	.s tmp=type_"!"_item_"!"_right
	.i distParams="" s distParams=tmp
	.e  s distParams=distParams_"^"_tmp
	
	q distParams
}

/// Part: D-14
/// Creator: 许立新
/// CreatDate: 2010-1-13
/// Description: 取成本接收科室
/// Table: 
/// Input: costDistSetDr-成本分摊套,methodDr-分摊方法,lowLayerDepts-下层科室
/// Output: 
/// Return: 筛选出的成本接收科室,I开头表示受众为指定科室并且有可能指定比例，N开头表示剔除不包含科室后的科室列表
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetRecDepts(1,1,"1^2^3^4^5")
ClassMethod GetRecDepts(costDistSetDr, methodDr, lowLayerDepts) As %String
{
	n (costDistSetDr,methodDr,lowLayerDepts)
	
	//包含受众
	s inRecDepts=""
	s inRecDeptDr=0
	f  s inRecDeptDr=$o(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"InRecDept",inRecDeptDr)) q:inRecDeptDr=""  d
	.s dept=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"InRecDept",inRecDeptDr),"^",1)
	.s rate=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"InRecDept",inRecDeptDr),"^",2)
	.i (rate="") || (rate=0) d
	..i inRecDepts="" s inRecDepts=dept
	..e  s inRecDepts=inRecDepts_"^"_dept
	.e  d
	..i inRecDepts="" s inRecDepts=dept_"!"_rate
	..e  s inRecDepts=inRecDepts_"^"_dept_"!"_rate
	
	//不包含受众
	s outRecDepts=""
	s outRecDeptDr=0
	f  s outRecDeptDr=$o(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"OutRecDept",outRecDeptDr)) q:outRecDeptDr=""  d
	.s dept=$p(^DHCCACOSTDISTSETS(costDistSetDr,"CDM",methodDr,"OutRecDept",outRecDeptDr),"^",1)
	.i outRecDepts="" s outRecDepts=dept
	.e  s outRecDepts=outRecDepts_"^"_dept
	
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

///  Part: E-1
///  Creator: 许立新
///  CreatDate: 2010-2-6
///  Description: 生成被分摊成本的临时global
///  Table: 
///  Input: costDistSetDr-成本分摊套,intervalDr-核算周期,distDeptStr-成本科室,distItems-成本项目,outItem-输出成本项
///  Output: 
///  Return: 
///  Others: w ##class(dhc.ca.cache.udata.DoCostDist1).SetDistedCost(costDistSetDr,intervalDr,distDeptStr,distItems,outItem)
ClassMethod SetDistedCost(costDistSetDr, intervalDr, distDeptStr, distItems, outItem) As %String
{
	n (costDistSetDr,intervalDr,distDeptStr,distItems,outItem)
	
	
	
	q:costDistSetDr="" "diatSetErr"
	q:intervalDr="" "intervalErr"
	q:distDeptStr="" "distDeptErr"
	
	s type=""
	s items=""
	
	i distItems'="" d
	.s type=$p(distItems,"!",1)
	.s items=$p(distItems,"!",2)
	
	f iDistDept=1:1:$l(distDeptStr,"^") d
	.s distDept=$p(distDeptStr,"^",iDistDept)
	.i distDept'="" d
	..i type="I" d
	...f iCostItem=1:1:$l(items,"^") d
	....s costItem=$p(items,"^",iCostItem)
	....i costItem'="" d
	.....s tmpItem=""
	.....i outItem'="" s tmpItem=outItem
	.....e  s tmpItem=costItem
	.....s childSub=0
	.....f  s childSub=$o(^DHCCACOSTDISTSETS(0,"DIntDistdeptItem",costDistSetDr,intervalDr,distDept,costItem,childSub)) q:childSub=""  d
	......s tmpStr=$g(^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",childSub))
	......i tmpStr'="" d
	.......;w tmpStr,!
	.......s res=..SetCostGlobal(distDept,tmpItem,tmpStr,childSub)
	..e  d
	...s itemDr=0
	...f  s itemDr=$o(^DHCCACOSTDISTSETS(0,"DIntDistdeptItem",costDistSetDr,intervalDr,distDept,itemDr)) q:itemDr=""  d
	....s r="N"
	....i items'="" d
	.....s r=..In(itemDr,items)
	....q:r="Y"
	....s tmpItem=""
	....i outItem'="" s tmpItem=outItem
	....e  s tmpItem=itemDr
	....s childSub=0
	....f  s childSub=$o(^DHCCACOSTDISTSETS(0,"DIntDistdeptItem",costDistSetDr,intervalDr,distDept,itemDr,childSub)) q:childSub=""  d
	.....s tmpStr=$g(^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",childSub))
	.....i tmpStr'="" d
	......s res=..SetCostGlobal(distDept,tmpItem,tmpStr,childSub)
	
	q "OK"
}

///  Part: E-2
///  Creator: 许立新
///  CreatDate: 2010-2-7
///  Description: 生成被分摊成本临时global
///  Table: 
///  Input: distDept-成本科室,costItem-成本项目,str-被分摊成本记录,childSub-被分摊成本行号
///  Output: 
///  Return: 
///  Others: w ##class(dhc.ca.cache.udata.DoCostDist1).SetCostGlobal(distDept,tmpItem,tmpStr,childSub)
ClassMethod SetCostGlobal(distDept, costItem, str, childSub) As %String
{
	n (distDept,costItem,str,childSub)
	
	s fee=$p(str,"^",5)
	s dealFlag=$p(str,"^",7)
	
	i dealFlag'="Y" d  //数据未处理则执行处理
	.i (fee'="") && (fee'=0) d
	..s tmp=$g(^TMPDHCCACALCOST("dhc","ca","distedCost","Values",distDept,costItem))
	..i tmp="" s ^TMPDHCCACALCOST("dhc","ca","distedCost","Values",distDept,costItem)=fee
	..e  s ^TMPDHCCACALCOST("dhc","ca","distedCost","Values",distDept,costItem)=tmp+fee
	..s tmp=$g(^TMPDHCCACALCOST("dhc","ca","distedCost","Rows",distDept,costItem))
	..i tmp="" s ^TMPDHCCACALCOST("dhc","ca","distedCost","Rows",distDept,costItem)=childSub
	..e  s ^TMPDHCCACALCOST("dhc","ca","distedCost","Rows",distDept,costItem)=tmp_"^"_childSub
	
	q "OK"
}

/// Part: E-3
/// Creator: 许立新
/// CreatDate: 2010-1-17
/// Description: 计算科室分摊比例
/// Table: 
/// Input: costDistSetDr-成本分摊套,distCycles-分摊参数区间,recCostDepts-受众科室,param-分摊参数,ioFlag-分摊类型标志
/// Output: 
/// Return: 接收科室分摊比例
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).GetDistRate("1","1^2","I:12!0.2^13!0.3^14!0.5","param!877!0.2^cost!139!0.3^income!133!0.5","N")
ClassMethod GetDistRate(costDistSetDr, distCycles, recCostDepts, params, ioFlag) As %String
{
	n (costDistSetDr, distCycles, recCostDepts, params,ioFlag)
	
	s rate=""
	
	q:costDistSetDr="" rate
	q:distCycles="" rate
	q:recCostDepts="" rate
	
	//接收科室标志为"I"时，有比例直接返回比例
	s flag=$p(recCostDepts,":",1)
	s depts=$p(recCostDepts,":",2)
	
	q:depts="" rate
	
	s rateFlag=0
	
	i flag="I" d //判断是否包含比例
	.i depts'="" d
	..f i=1:1:$l(depts,"^") d
	...s tmpStr=$p(depts,"^",i)
	...s r=$p(tmpStr,"!",2)
	...i r>0 s rateFlag=1

	i rateFlag=1 d
	.s sum=0
	.f i=1:1:$l(depts,"^") d
	..s tempStr=$p(depts,"^",i)
	..s dep=$p(tempStr,"!",1)
	..s num=$p(tempStr,"!",2)
	..s sum=sum+num
	.i sum>0 d
	..f i=1:1:$l(depts,"^") d
	...s tempStr=$p(depts,"^",i)
	...s dep=$p(tempStr,"!",1)
	...s num=$p(tempStr,"!",2)
	...s r=num/sum
	...i r>0 d
	....i rate="" s rate=dep_"!"_r
	....e  s rate=rate_"^"_dep_"!"_r
	
	q:rateFlag=1 rate
	
	s distFlag=""
	i ioFlag="Y" d   //收支配比开始
	.s distDept="" ,tDeptDr=""
	.f  s tDeptDr=$o(^TMPDHCCACALCOST("dhc","ca","distedCost","Values",tDeptDr)) q:tDeptDr=""  d
	..//计算收入数据中的,指定核算区间的,执行科室为distDept的,开单科室的收入
	..f mi=1:1:$l(distCycles,"^") d
	...s interval=$p(distCycles,"^",mi)
	...i interval'="" d
	....s unitdr="",setid="",childsub="", rowid=0
	....f  s rowid=$o(^DHCCAINCOMEDATAS(0,"IntervalTdeptdr",interval,tDeptDr,rowid)) q:rowid=""  d  		
	.....q:'$d(^DHCCAINCOMEDATAS(rowid)) 
	.....s fDeptDr=$p(^DHCCAINCOMEDATAS(rowid),"^",11) 
	.....q:$F("^"_depts_",","^"_fDeptDr_"^")=0
	.....q:$p(^DHCCAUNITDEPTS(fDeptDr),"^",8)'=$p(^DHCCAUNITDEPTS(tDeptDr),"^",8)   //zjw 20160707 开单科室和执行科室必须为同一所医院的科室 
	.....s fee=$p(^DHCCAINCOMEDATAS(rowid),"^",7)
	.....q:(fee=0)||(fee="")
	.....s ^TMPDHCCACALCOST("dhc","ca","distedCost","szpbs",tDeptDr)=$g(^TMPDHCCACALCOST("dhc","ca","distedCost","szpbs",tDeptDr))+fee	//获取执行科室的总收入
	.....s ^TMPDHCCACALCOST("dhc","ca","distedCost","szpb",tDeptDr,fDeptDr)=$g(^TMPDHCCACALCOST("dhc","ca","distedCost","szpb",tDeptDr,fDeptDr))+fee
	
	.s tDeptDr="" //获取开单科室在各执行科室的总收入中对应的开单收入比例
	.f  s tDeptDr=$o(^TMPDHCCACALCOST("dhc","ca","distedCost","szpbs",tDeptDr)) q:tDeptDr=""  d
	..s sum=^TMPDHCCACALCOST("dhc","ca","distedCost","szpbs",tDeptDr)
	..i (sum'="") && (sum'=0) d
	...s fDeptDr=""
	...f  s fDeptDr=$o(^TMPDHCCACALCOST("dhc","ca","distedCost","szpb",tDeptDr,fDeptDr)) q:fDeptDr=""  d
	....s fee=^TMPDHCCACALCOST("dhc","ca","distedCost","szpb",tDeptDr,fDeptDr)
	....i (fee'="") && (fee'=0) d
	.....s tmpRate=fee/sum
	.....i tmpRate'=0 d
	......s ^TMPDHCCACALCOST("dhc","ca","distedCost","szpbr",tDeptDr,fDeptDr)=tmpRate
	.//收支配比结束-----------------------------------------------------
	e  d             //非收支配比
	.i params'="" d  //非收支配比必须指定分摊参数
	..k ^TMPDHCCACALCOST("dhc","ca","distParam")   //循环参数
	..f i=1:1:$l(params,"^") d
	...s paramStr=$p(params,"^",i)
	...s paramType=$p(paramStr,"!",1)
	...s paramItem=$p(paramStr,"!",2)
	...s paramRight=$p(paramStr,"!",3)
	...i paramType'="" d
	....i paramItem'="" d
	.....i paramRight="" s paramRight=1
	.....i paramType="cost" d             //不同参数类型数据来源不同
	......f mi=1:1:$l(distCycles,"^") d
	.......s interval=$p(distCycles,"^",mi)
	.......i interval'="" d
	........f di=1:1:$l(depts,"^") d
	.........s recDept=$p(depts,"^",di)
	.........i recDept'="" d
	..........s child=0
	..........f  s child=$o(^DHCCACOSTDISTSETS(0,"DIntDistdeptItem",costDistSetDr,interval,recDept,paramItem,child)) q:child=""  d
	...........i $d(^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",child)) d
	............s tmp=$g(^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",child))
	............s fee=$p(tmp,"^",5)
	............s distFlag=$p(tmp,"^",6)
	............i distFlag="self" d
	.............s rightFee=fee*paramRight
	.............i rightFee'=0 d
	..............s tmpValue=$g(^TMPDHCCACALCOST("dhc","ca","distParam",recDept))
	..............i tmpValue="" s ^TMPDHCCACALCOST("dhc","ca","distParam",recDept)=tmpValue
	..............e  s ^TMPDHCCACALCOST("dhc","ca","distParam",recDept)=tmpValue+rightFee
	.....i paramType="param" d
	......f mi=1:1:$l(distCycles,"^") d
	.......s interval=$p(distCycles,"^",mi)
	.......i interval'="" d
	........f di=1:1:$l(depts,"^") d
	.........s recDept=$p(depts,"^",di)
	.........i recDept'="" d
	..........s paramDataDr=0
	..........f  s paramDataDr=$o(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",interval,recDept,paramItem,paramDataDr)) q:paramDataDr=""  d
	...........i $d(^DHCCAPARAMDATAS(paramDataDr)) d
	............s tmp=^DHCCAPARAMDATAS(paramDataDr)
	............s fee=$p(tmp,"^",11)
	............s rightFee=fee*paramRight
	............i rightFee'=0 d
	.............s tmpValue=$g(^TMPDHCCACALCOST("dhc","ca","distParam",recDept))
	.............i tmpValue="" s ^TMPDHCCACALCOST("dhc","ca","distParam",recDept)=rightFee
	.............e  s ^TMPDHCCACALCOST("dhc","ca","distParam",recDept)=tmpValue+rightFee
	.....i paramType="income" d
	......f mi=1:1:$l(distCycles,"^") d
	.......s interval=$p(distCycles,"^",mi)
	.......i interval'="" d
	........f di=1:1:$l(depts,"^") d
	.........s recDept=$p(depts,"^",di)
	.........i recDept'="" d
	..........s incomeDataDr=0
	..........f  s incomeDataDr=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptItem",interval,recDept,paramItem,incomeDataDr)) q:incomeDataDr=""  d
	...........i $d(^DHCCAINCOMEDATAS(incomeDataDr)) d
	............s tmp=^DHCCAINCOMEDATAS(incomeDataDr)
	............s fee=$p(tmp,"^",7)
	............s rightFee=fee*paramRight
	............i rightFee'=0 d
	.............s tmpValue=$g(^TMPDHCCACALCOST("dhc","ca","distParam",recDept))
	.............i tmpValue="" s ^TMPDHCCACALCOST("dhc","ca","distParam",recDept)=rightFee
	.............e  s ^TMPDHCCACALCOST("dhc","ca","distParam",recDept)=tmpValue+rightFee
	..s sum=0   //计算分母
	..s recDept=0
	..f  s recDept=$o(^TMPDHCCACALCOST("dhc","ca","distParam",recDept)) q:recDept=""  d
	...i $d(^TMPDHCCACALCOST("dhc","ca","distParam",recDept)) d
	....s sum=sum+^TMPDHCCACALCOST("dhc","ca","distParam",recDept)
	..i sum>0 d //计算比例
	...s recDept=0
	...f  s recDept=$o(^TMPDHCCACALCOST("dhc","ca","distParam",recDept)) q:recDept=""  d
	....i $d(^TMPDHCCACALCOST("dhc","ca","distParam",recDept)) d
	.....s vol=^TMPDHCCACALCOST("dhc","ca","distParam",recDept)
	.....s rat=vol/sum
	.....i rat>0 d  //生成字符串
	......i rate="" s rate=recDept_"!"_rat
	......e  s rate=rate_"^"_recDept_"!"_rat
	..k ^TMPDHCCACALCOST("dhc","ca","distParam")
	
	q rate
}

/// Part: E-4
///  Creator: 许立新
///  CreatDate: 2010-2-7
///  Description: 计算成本分摊数值、保存数据、设置标志
///  Table: 
///  Input: costDistSetDr-成本分摊套,intervalDr-核算周期,distRate-分摊比例
///  Output: 
///  Return: 执行情况信息
///  Others: w ##class(dhc.ca.cache.udata.DoCostDist1).CalcAndSave(costDistSetDr,intervalDr,distRate)
ClassMethod CalcAndSave(costDistSetDr, intervalDr, distRate) As %String
{
	n (costDistSetDr,intervalDr,distRate)

	//^TMPDHCCACAL("dhc","ca","distedCost","Values",3,139)=23144
	//^TMPDHCCACAL("dhc","ca","distedCost","Rows",3,139)=211070
	s distedDept=0
	f  s distedDept=$o(^TMPDHCCACALCOST("dhc","ca","distedCost","Values",distedDept)) q:distedDept=""  d
	.s distedItem=0
	.f  s distedItem=$o(^TMPDHCCACALCOST("dhc","ca","distedCost","Values",distedDept,distedItem)) q:distedItem=""  d
	..s distFlag=0
	..s fee=^TMPDHCCACALCOST("dhc","ca","distedCost","Values",distedDept,distedItem)
	..i fee'=0 d
	...i distRate'="" d
	....s SQLflag=0
	....TSTART
	....f i=1:1:$l(distRate,"^") d
	.....s tmp=$p(distRate,"^",i)
	.....i tmp'="" d
	......s recDept=$p(tmp,"!",1)
	......s recRate=$p(tmp,"!",2)
	......i recDept'="" && recRate'=0 d
	.......s recFee=fee*recRate
	.......i recFee'=0 d
	........s distFlag=1
	........//"核算周期Dr^被分摊部门Dr^分摊部门Dr^成本项Dr^成本金额^分摊标志^处理标志"
	........s data=intervalDr_"^"_distedDept_"^"_recDept_"^"_distedItem_"^"_recFee_"^dist^N"
	........s result=..InsertCost(costDistSetDr, data)
	........i result'=0 s SQLflag=result
	....i distFlag=1 d
	.....s rows=^TMPDHCCACALCOST("dhc","ca","distedCost","Rows",distedDept,distedItem)
	.....i rows'="" d
	......f j=1:1:$l(rows,"^") d
	.......s row=$p(rows,"^",j)
	.......i row'="" d
	........&SQL(UPDATE dhc_ca_cache_data.CostResultData SET CostResultData_dealFlag='Y' WHERE CostResultData_parRef=:costDistSetDr AND CostResultData_childSub=:row)
	........i SQLCODE'=0 s SQLflag=SQLCODE
	....i SQLflag=0 TCOMMIT
	....e  TROLLBACK
	
	q "OK"
}

///  Part: E-5
///  Creator: 许立新
///  CreatDate: 2010-2-7
///  Description: 计算收支配比成本分摊数值、保存数据、设置标志
///  Table: 
///  Input: costDistSetDr-成本分摊套,intervalDr-核算周期
///  Output: 
///  Return: 执行情况信息
///  Others: w ##class(dhc.ca.cache.udata.DoCostDist1).CalcAndSave1(1,5)
ClassMethod CalcAndSave1(costDistSetDr, intervalDr) As %String
{
	n (costDistSetDr,intervalDr)
	
	//被分摊成本：   ^TMPDHCCACALCOST("dhc","ca","distedCost","Values",distDept,costItem)
    //被分摊成本行： ^TMPDHCCACALCOST("dhc","ca","distedCost","Rows",distDept,costItem)
    //收支配比科室的分摊比例：^TMPDHCCACALCOST("dhc","ca","distedCost","szpbr",tDeptDr,fDeptDr)
    
    s tDeptDr=""
    f  s tDeptDr=$o(^TMPDHCCACALCOST("dhc","ca","distedCost","szpbr",tDeptDr)) q:tDeptDr=""  d
    .s itemDr=0
    .f  s itemDr=$o(^TMPDHCCACALCOST("dhc","ca","distedCost","Values",tDeptDr,itemDr)) q:itemDr=""  d
    ..s distFlag=0
    ..s SQLFlag=0
    ..TSTART
    ..s sumFee=^TMPDHCCACALCOST("dhc","ca","distedCost","Values",tDeptDr,itemDr)
    ..s fDeptDr=""
    ..f  s fDeptDr=$o(^TMPDHCCACALCOST("dhc","ca","distedCost","szpbr",tDeptDr,fDeptDr)) q:fDeptDr=""  d
    ...s rate=^TMPDHCCACALCOST("dhc","ca","distedCost","szpbr",tDeptDr,fDeptDr)
    ...i rate'=0 d
    ....s fee=sumFee*rate
    ....i fee'=0 d
    .....s distFlag=1  //确认数据至少被分配一次
    .....//"核算周期Dr^被分摊部门Dr^分摊部门Dr^成本项Dr^成本金额^分摊标志^处理标志"
    .....s data=intervalDr_"^"_tDeptDr_"^"_fDeptDr_"^"_itemDr_"^"_fee_"^dist^N"
    .....s result=..InsertCost(costDistSetDr, data)
    .....i result'=0 s SQLFlag=result
    ..i distFlag=1 d   //设置标志
    ...s rows=^TMPDHCCACALCOST("dhc","ca","distedCost","Rows",tDeptDr,itemDr)
    ...i rows'="" d
    ....f j=1:1:$l(rows,"^") d
    .....s row=$p(rows,"^",j)
    .....i row'="" d
    ......&SQL(UPDATE dhc_ca_cache_data.CostResultData SET CostResultData_dealFlag='Y' WHERE CostResultData_parRef=:costDistSetDr AND CostResultData_childSub=:row)
    ......i SQLCODE'=0 s SQLFlag=SQLCODE
    ..i SQLFlag=0 TCOMMIT
    ..e  TROLLBACK
    
    q "OK"
}

///  Part: Y-01
///  Creator: 许立新
///  CreatDate: 2010-1-17
///  Description: 判断传入id是否在指定列表中
///  Table: 
///  Input: id,ids
///  Output: 
///  Return: 
///  Others: w ##class(dhc.ca.cache.udata.DoCostDist1).In(id,ids)
ClassMethod In(id, ids) As %String
{
	n (id,ids)
	
	s result="N"

	f i=1:1:$l(ids,"^") d
	.s tmp=$p(ids,"^",i)
	.i tmp=id  s result="Y"
	
	q result
}

/// Part: Z-01
/// Creator: 许立新
/// CreatDate: 2010-3-16
/// Description: 插入一条成本数据
/// Table: dhc.ca.cache.data.CostResultData
/// Input: costDistSetDr-成本分摊套,data-数据行,"核算周期Dr^被分摊部门Dr^分摊部门Dr^成本项Dr^成本金额^分摊标志^处理标志"
/// Output: 
/// Return: SQLCode
/// Others: w ##class(dhc.ca.cache.udata.DoCostDist1).InsertCost(1,"")
ClassMethod InsertCost(costDistSetDr, data) As %String
{
	n (costDistSetDr,data)
	
	q:costDistSetDr="" "setErr"
	q:data="" "dataErr"
	
	k PLIST
	
	i costDistSetDr'=0 s PLIST(0)=costDistSetDr
	
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

Storage Default
{
<StreamLocation>^dhc.ca.c.DoCostDist1S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
