/// Creator: 杨旭
/// CreatDate: 2010-04-15
/// Description: 分摊前检查
Class dhc.ca.cache.udata.DistExamination Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭  zjw 20160128 
/// CreatDate: 2010-04-15
/// Description: 收入数据中开单科室、接收科室、病人科室、项目有空终止执行，提示检查；
/// Table: dhc.ca.cache.data.IncomeDatas
/// Input: intervalDr-核算区间Dr;
/// Output: 
/// Return: 返回提示信息,0为正常.
/// Others: w ##class(dhc.ca.cache.udata.DistExamination).ExaminIncomeDept("1")
ClassMethod ExaminIncomeDept(intervalDr) As %String
{
	n (intervalDr)
	
	s result="0"
	;s num=0
	
	i '$d(^DHCCAINCOMEDATAS(0,"IntervalPattype",intervalDr,"O")) d
	.s result="本核算周期未导入门诊收入数据，请处理后再试!"  //zjw 20160128 
	q:result'="0" result
	
	i '$d(^DHCCAINCOMEDATAS(0,"IntervalPattype",intervalDr,"I")) d
	.s result="本核算周期未导入住院收入数据，请处理后再试!"  //zjw 20160128 
	q:result'="0" result
	
	s rowid="" f  s rowid=$o(^DHCCAINCOMEDATAS(0,"Interval",intervalDr,rowid)) q:rowid=""  d
	.i $d(^DHCCAINCOMEDATAS(rowid)) d
	..;s num=num+1   //zjw 20160120 用以判断当月收入数据是否维护
	..s itemDr=""
	..s fDeptDr=""
	..s tDeptDr=""
	..s patDeptDr=""
	..s itemDr=$p(^DHCCAINCOMEDATAS(rowid),"^",6) //项目ID
	..s fDeptDr=$p(^DHCCAINCOMEDATAS(rowid),"^",11) //开单科室
	..s tDeptDr=$p(^DHCCAINCOMEDATAS(rowid),"^",14)	//接收科室
	..s patDeptDr=$p(^DHCCAINCOMEDATAS(rowid),"^",17)	//病人科室
	..i (itemDr="") d
	...s result="本核算周期收入数据中有HIS收入项未对照，请处理后再试!"
	..e  d
	...i ((fDeptDr="")||(tDeptDr="")||(patDeptDr="")) d
	....s result="本核算周期收入数据中有HIS科室未对照，请处理后再试!"
	
	q result
}

/// Creator: 杨旭
/// CreatDate: 2010-04-15
/// Description: 收入数据的开单科室不为直接医疗科室（写死:6），终止执行，提示检查；
/// Table: dhc.ca.cache.data.IncomeDatas
/// Input: intervalDr-核算区间Dr;
/// Output: 
/// Return: 返回提示信息,0为正常.
/// Others: w ##class(dhc.ca.cache.udata.DistExamination).ExaminIncomeFDeptDr("1",0,10)
ClassMethod ExaminIncomeFDeptDr(intervalDr, start, limit) As %String
{
	n (intervalDr,start,limit)
	s rowid=""
	s result="0"
	s layerDr=6                     //全成本分摊 直接医疗科室
	s costSetsDr=1					//部门分层套 全成本分摊ID
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="deptCode^deptName"
	s count=0
	s resultString=""
	s end=start+limit
	d ##class(dhc.ca.cache.udata.CostDist).GetLayers(costSetsDr)
	s tmpDepts=""
	s tmpDepts=##class(dhc.ca.cache.udata.CostDist).GetCurrentLayerDepts(layerDr)
	s depts=""
	s depts=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tmpDepts)
	s fDeptDr=""
	f  s fDeptDr=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",intervalDr,fDeptDr)) q:fDeptDr=""  d
	.s deptName=""
	.s deptCode=""
	.q:(..ExaminIncludDept(fDeptDr,depts)=0)
	.i fDeptDr'="" d
	..i $d(^DHCCAUNITDEPTS(fDeptDr)) d
	...s deptCode=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",1)
	...s deptName=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",2)
	.s tmp=deptCode_"^"_deptName
	.;i (count>start)&(count<=end) d    //zjw  201601128  屏蔽，修改如下
	.i (count>=start)&(count<end) d
	..d json.InsertRowData(tmp)
	.s count=count+1
	s resultString = json.getJsonData(jsonTitle,count)
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2010-04-15
/// Description: 查看某科室,是否在某科室集合中
/// Table: dhc.ca.cache.data.IncomeDatas
/// Input: dept-待查科室;depts-科室集合;
/// Output: 
/// Return: 如果所查科室被包含在科室结合中,返回0;
/// Others: w ##class(dhc.ca.cache.udata.DistExamination).ExaminIncomeDept("1")
ClassMethod ExaminIncludDept(dept, depts) As %String
{
	n (dept,depts)
	q:dept="" 1 
	q:depts="" 1 
	s result="1"
	s length=0
	s length=$l(depts,",")
	f i=1:1:length d
	.i dept=$p(depts,",",i) s result="0"
	q result
}

/// Creator: 杨旭  zjw 20160120
/// CreatDate: 2010-04-15
/// Description: 成本数据中成本科室、成本项目有空，终止执行，提示检查；
/// Table: dhc.ca.cache.data.VouchDatas; dhc.ca.cache.data.BaseData
/// Input: intervalDr-核算区间Dr;
/// Output: 
/// Return:返回提示信息,0为正常.
/// Others: w ##class(dhc.ca.cache.udata.DistExamination).ExaminCostItem(15,1)
ClassMethod ExaminCostItem(intervalDr, costSetsDr) As %String
{
	n (intervalDr,costSetsDr)
	
	s result="0"
	/*
	s num=0
	i costSetsDr=1 d
	.s rowid="" f  s rowid=$o(^DHCCAVOUCHDATAS(0,"Interval",intervalDr,rowid)) q:rowid=""  d
	..i $d(^DHCCAVOUCHDATAS(rowid)) d
	...s num=num+1   //zjw 20160120 判断财务支出数据表是否维护有数据
	e  d
	.s rowid="" f  s rowid=$o(^DHCCABASEDATA(0,"Int",intervalDr,rowid)) q:rowid=""  d
	..i $d(^DHCCABASEDATA(rowid)) d
	...s num=num+1   //zjw 20160120 判断基础成本数据表是否维护有数据
	
	i (costSetsDr=1)&&(num>0)  s result="财务支出数据中未导入数据,请处理后再试!"
	i (costSetsDr>1)&&(num>0)  s result="原始成本数据中未维护数据,请处理后再试!"
	q:num>0 result
	*/
	//优化 zjw 20160128
	
	i (costSetsDr=1)&&('$d(^DHCCAVOUCHDATAS(0,"Interval",intervalDr))) d
	.s result="本核算周期财务支出数据中未导入数据，请处理后再试!"  //zjw 20160128 判断财务支出数据表是否维护有数据

	i (costSetsDr>1)&&('$d(^DHCCABASEDATA(0,"Int",intervalDr))) d
	.s result="本核算周期原始成本数据中未维护数据，请处理后再试!"  //zjw 20160128 判断基础成本数据表是否维护有数据
	q:result'="0" result
	
	i costSetsDr'=1  d
	.s bRowid="" f  s bRowid=$o(^DHCCABASEDATA(0,"Int",intervalDr,bRowid)) q:bRowid=""  d
	..i $d(^DHCCABASEDATA(bRowid)) d
	...s itemDr=""
	...s itemDr=$p(^DHCCABASEDATA(bRowid),"^",5) //项目ID
	...s deptDr=$p(^DHCCABASEDATA(bRowid),"^",14) //科室DR  20160106zjw
	...i itemDr="" d
	....s result="本核算周期原始成本数据中有数据项未对照，请处理后再试!"
	...e  d			//20160106zjw
	....i deptDr="" s result="本核算周期原始成本数据中有科室未对照，请处理后再试!"
	e  d
	.s vRowid="" f  s vRowid=$o(^DHCCAVOUCHDATAS(0,"Interval",intervalDr,vRowid)) q:vRowid=""  d
	..i $d(^DHCCAVOUCHDATAS(vRowid)) d
	...s itemDr=""
	...s itemDr=$p(^DHCCAVOUCHDATAS(vRowid),"^",3) //项目ID
	...s deptDr=$p(^DHCCAVOUCHDATAS(vRowid),"^",2) //科室DR  20160106zjw
	...i itemDr="" d
	....s result="本核算周期财务成本数据中有数据项未对照，请处理后再试!"
	...e  d			//20160106zjw
	....i deptDr="" s result="本核算周期财务成本数据中有科室未对照，请处理后再试!"
	q result
}

/// Creator: 杨旭
/// CreatDate: 2010-04-15
/// Description: 科室有成本但分摊方法未设置分摊参数的，终止执行，提示检查；
/// Table: dhc.ca.cache.data.VouchDatas; dhc.ca.cache.data.BaseData
/// Input: intervalDr-核算区间Dr;
/// Output: 
/// Return:返回提示信息,0为正常.
/// Others: w ##class(dhc.ca.cache.udata.DistExamination).ExaminDistRule(5,1)
ClassMethod ExaminDistRule(intervalDr, deptSet) As %String
{
	n (intervalDr, deptSet)
	s result="0"
	//d ##class(dhc.ca.cache.udata.DoCostDist1).DistStart(deptSet, monthDr)
	s rs1=##class(dhc.ca.cache.udata.uCostResultData).FindRecByLayerDr("","","","",0,10,intervalDr,deptSet,2)
	s rs2=##class(dhc.ca.cache.udata.uCostResultData).FindRecByLayerDr("","","","",0,10,intervalDr,deptSet,3)
	s rs3=##class(dhc.ca.cache.udata.uCostResultData).FindRecByLayerDr("","","","",0,10,intervalDr,deptSet,4)
	s rs4=##class(dhc.ca.cache.udata.uCostResultData).FindRecByLayerDr("","","","",0,10,intervalDr,deptSet,5)
	s rs5=##class(dhc.ca.cache.udata.uCostResultData).FindRecByLayerDr("","","","",0,10,intervalDr,deptSet,6)
	s rs1=$l(rs1)
	s rs2=$l(rs2)
	s rs3=$l(rs3)
	s rs4=$l(rs4)
	s rs5=$l(rs5)
	i rs1>19  d
	.i result'="" d
	..s result=result_","_$p($g(^DHCCADEPTLEVELSETS(3)),"^",2)_"层"
	.e  s result=result_$p($g(^DHCCADEPTLEVELSETS(3)),"^",2)_"层"
	i rs2>19  d
	.i result'="" d
	..s result=result_","_$p($g(^DHCCADEPTLEVELSETS(4)),"^",2)_"层"
	.e  s result=result_$p($g(^DHCCADEPTLEVELSETS(4)),"^",2)_"层"
	i rs3>19  d
	.i result'="" d
	..s result=result_","_$p($g(^DHCCADEPTLEVELSETS(5)),"^",2)_"层"
	.e  s result=result_$p($g(^DHCCADEPTLEVELSETS(5)),"^",2)_"层"
	i rs4>19  d
	.i result'="" d
	..s result=result_","_$p($g(^DHCCADEPTLEVELSETS(6)),"^",2)_"层"
	.e  s result=result_$p($g(^DHCCADEPTLEVELSETS(6)),"^",2)_"层"
	i rs5>19  d
	.i result'="" d
	..s result=result_","_$p($g(^DHCCADEPTLEVELSETS(7)),"^",2)_"层"
	.e  s result=result_$p($g(^DHCCADEPTLEVELSETS(7)),"^",2)_"层"
	i rs1=rs2=rs3=rs4=rs5=19 s result="0"
	e  s result=result_"有数据未分摊,请处理后再试!"
	q result
}

/// Creator: 杨旭
/// CreatDate: 2010-04-15
/// Description: 检查3,4,5,6层所有科室是否有人员和面积的参数
/// Table: dhc.ca.cache.data.VouchDatas; dhc.ca.cache.data.BaseData
/// Input: intervalDr-核算区间Dr;params-参数ID;
/// Output: 
/// Return:返回提示信息,0为正常.
/// Others: w ##class(dhc.ca.cache.udata.DistExamination).ExaminLayersParam(1,"205,206")
ClassMethod ExaminLayersParam(intervalDr, params) As %String
{
	n (intervalDr, params)
	q:intervalDr="" ""
	q:params="" ""
	s pLength=""
	s tmpRs=0
	s pLength=$l(params,",")
	s resultStr="0"
	d ##class(dhc.ca.cache.udata.CostDist).GetLayers(1)
	s tmpDepts2=##class(dhc.ca.cache.udata.CostDist).GetCurrentLayerDepts(3)
	s tmpDepts2=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tmpDepts2)
	s tmpDepts3=##class(dhc.ca.cache.udata.CostDist).GetCurrentLayerDepts(4)
	s tmpDepts3=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tmpDepts3)
	s tmpDepts4=##class(dhc.ca.cache.udata.CostDist).GetCurrentLayerDepts(5)
	s tmpDepts4=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tmpDepts4)
	s tmpDepts5=##class(dhc.ca.cache.udata.CostDist).GetCurrentLayerDepts(6)
	s tmpDepts5=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tmpDepts5)
	;s tmpDepts6=##class(dhc.ca.cache.udata.CostDist).GetCurrentLayerDepts(8)      20140611 zjw 屏蔽
	;s tmpDepts6=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tmpDepts6)    20140611 zjw 屏蔽
	f i=1:1:pLength d
	.s tmpRs=0
	.s param=""
	.s param=$p($g(params),",",i)
	.q:param=""
	.f j=1:1:$l(tmpDepts2,",") d
	..s deptDr=""
	..s deptDr=$p($g(tmpDepts2),",",j)
	..q:deptDr=""
	..i $d(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",intervalDr,deptDr)) d
	...i '$d(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",intervalDr,deptDr,param)) d
	....s tmpRs=1
	....s resultStr=resultStr_$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)_"的参数"_$p($g(^DHCCAALLDATAITEMS(param)),"^",3)_"未被设置;"
	.f j=1:1:$l(tmpDepts3,",") d
	..s deptDr=""
	..s deptDr=$p($g(tmpDepts3),",",j)
	..q:deptDr=""
	..i $d(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",intervalDr,deptDr)) d
	...i '$d(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",intervalDr,deptDr,param)) d
	....s tmpRs=1
	....s resultStr=resultStr_$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)_"的参数"_$p($g(^DHCCAALLDATAITEMS(param)),"^",3)_"未被设置;"   // 20140611 zjw 添加
	.f j=1:1:$l(tmpDepts4,",") d
	..s deptDr=""
	..s deptDr=$p($g(tmpDepts4),",",j)
	..q:deptDr=""
	..i $d(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",intervalDr,deptDr)) d
	...i '$d(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",intervalDr,deptDr,param)) d
	....s tmpRs=1
	....s resultStr=resultStr_$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)_"的参数"_$p($g(^DHCCAALLDATAITEMS(param)),"^",3)_"未被设置;"
	.f j=1:1:$l(tmpDepts5,",") d
	..s deptDr=""
	..s deptDr=$p($g(tmpDepts5),",",j)
	..q:deptDr=""
	..i $d(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",intervalDr,deptDr)) d
	...i '$d(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",intervalDr,deptDr,param)) d
	....s tmpRs=1
	....s resultStr=resultStr_$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)_"的参数"_$p($g(^DHCCAALLDATAITEMS(param)),"^",3)_"未被设置;"
	/*  20140611 zjw 屏蔽
	.f j=1:1:$l(tmpDepts6,",") d
	..s deptDr=""
	..s deptDr=$p($g(tmpDepts6),",",j)
	..q:deptDr=""
	..i $d(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",intervalDr,deptDr)) d
	...i '$d(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",intervalDr,deptDr,param)) d
	....s tmpRs=1
	....s resultStr=resultStr_$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)_"的参数"_$p($g(^DHCCAALLDATAITEMS(param)),"^",3)_"未被设置;"
	.//i tmpRs=1 s resultStr=resultStr_$p($g(^DHCCAALLDATAITEMS(param)),"^",3)_"不存在;"
	*/
	q resultStr
}

/// Creator: 杨旭
/// CreatDate: 2010-04-15
/// Description: 检查当月是否有指定参数出现
/// Table: dhc.ca.cache.data.VouchDatas; dhc.ca.cache.data.BaseData
/// Input: intervalDr-核算区间Dr;params-参数;
/// Output: 
/// Return:返回提示信息,0为正常.
/// Others: w ##class(dhc.ca.cache.udata.DistExamination).ExaminParam("1",222)
ClassMethod ExaminParam(intervalDr, params) As %String
{
	n (intervalDr, params)
	s result=""
	s pLength=$l(params,",")
	f i=1:1:pLength d
	.s rowid=""
	.q:$p($g(params),",",i)=""
	.s rowid=$o(^DHCCAPARAMDATAS(0,"IntervalItem",intervalDr,$p($g(params),",",i),rowid))
	.i rowid="" s result=result_$p($g(^DHCCAALLDATAITEMS($p($g(params),",",i))),"^",3)_"数据不存在;"
	q result
}

/// Creator: zjw
/// CreatDate: 2016-01-28
/// Description: 检测核算区间的本期、去年同期、上期、本年首月是否维护
/// Table: dhc.ca.cache.data.Paramdatas
/// Input: intervalDr-核算区间Dr;costSetsDr--成本分摊套ID
/// Output: 
/// Return:返回提示信息,0为正常.
/// Others: w ##class(dhc.ca.cache.udata.DistExamination).ExaminIntervalDr(1)
ClassMethod ExaminIntervalDr(intervalDr) As %String
{
	n (intervalDr)
	
	s result="0"
	
	//17本期、18上期、19去年同期、20本年首月
	
	//首先判断 本期维护、本年首月 是否正确，之后再判断其他区间
	
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.i '$d(^DHCCAACCOUNTMONTHS(0,"Period",intervalDr,17)) d
	..s result="本核算周期的 本期 尚未维护，请到核算周期的编辑区间中维护后再试！"
	.e  d
	..s childsub="",MonthDr=""
	..f  s childsub=$o(^DHCCAACCOUNTMONTHS(0,"Period",intervalDr,17,childsub)) q:childsub=""  d //Only one
	...s MonthDr=$p(^DHCCAACCOUNTMONTHS(intervalDr,"Periods",childsub),"^",2)
	...i intervalDr'=MonthDr  s result="本核算周期的 本期 维护错误，请到核算周期的编辑区间中修正后再试！"
	e  d
	.s result="本核算周期不存在!"
	q:result'="0" result
	
	//首先判断 本年首月
	i '$d(^DHCCAACCOUNTMONTHS(0,"Period",intervalDr,20)) d
	.s result="本核算周期的 本年首月 尚未维护，请到核算周期的编辑区间中维护后再试！"
	q:result'="0" result
	
	// 第1个周期之后要再判断 "上期"
	i intervalDr>1 d	
	.i '$d(^DHCCAACCOUNTMONTHS(0,"Period",intervalDr,18)) d
	..s result="本核算周期的 上期 尚未维护，请到核算周期的编辑区间中维护后再试！"
	q:result'="0" result
	
	//12个周期之后要再判断 "去年同期"
	i intervalDr>12 d						
	.i '$d(^DHCCAACCOUNTMONTHS(0,"Period",intervalDr,19)) d
	..s result="本核算周期的 去年同期 尚未维护，请到核算周期的编辑区间中维护后再试！"
	
	q result
}

/// Creator: zjw
/// CreatDate: 2016-01-28
/// Description: 检测参数数据是否维护、是否有科未对照；检测分摊方法设置的分摊指标是否维护  zjw 20160128
/// Table: dhc.ca.cache.data.Paramdatas;dhc_ca_cache_data.CostDistMethods;dhc_ca_cache_data.DistParams
/// Input: intervalDr-核算区间Dr;costSetsDr--成本分摊套ID
/// Output: 
/// Return:返回提示信息,0为正常.
/// Others: w ##class(dhc.ca.cache.udata.DistExamination).ExaminDistParam(1,1)
ClassMethod ExaminDistParam(intervalDr, costSetsDr) As %String
{
	n (intervalDr,costSetsDr)
	s result="0"
	////检测参数数据是否维护、是否有科未对照
	i '$d(^DHCCAPARAMDATAS(0,"Interval",intervalDr)) d
	.s result="本核算周期参数数据未维护，请处理后再试!"
	e  d
	.s itemDr="" f  s itemDr=$o(^DHCCAPARAMDATAS(0,"IntervalItem",intervalDr,itemDr)) q:itemDr=""  d	//查找当期已维护的参数数据
	..s itemName=$p(^DHCCAALLDATAITEMS(itemDr),"^",3)		//数据项名称
	..s itemActive=$p(^DHCCAALLDATAITEMS(itemDr),"^",6)		//数据项有效性
	..q:itemActive'="Y"
	..s ParamRowid="" f  s ParamRowid=$o(^DHCCAPARAMDATAS(0,"IntervalItem",intervalDr,itemDr,ParamRowid)) q:ParamRowid=""  d
	...s DeptDr=$p(^DHCCAPARAMDATAS(ParamRowid),"^",10)		//核算科室DR
	...i DeptDr="" s result="本核算周期参数数据中 "_itemName_" 有未对照科室，请处理后再试!"
	q:result'="0" result
	
	////检测分摊方法设置的分摊指标是否维护
	//(1)根据分摊套搜索对应的各分摊层，
	//(2)再由各分摊层查找各优先级分摊方法，
	//(3)根据有效的优先级分摊方法查找包含的分摊指标"param"、"income"、"cost"
	//^DHCCACOSTDISTSETS(0,"CDMSLP",{CostDistSets.CostDistSets_rowid},{CostDistSets.CostDistSets_layerDr},{CostDistMethods_priority},{CostDistMethods_childSub})
	s costSetsName=$p(^DHCCACOSTDISTSETS(costSetsDr),"^",3)		//分摊套名称
	s layerDr="" f  s layerDr=$o(^DHCCACOSTDISTSETS(0,"CDMSLP",costSetsDr,layerDr)) q:layerDr=""  d
	.s layerName=$p(^DHCCADEPTLEVELSETS(layerDr),"^",2)			//分摊科室层名称
	.s layerActive=$p(^DHCCADEPTLEVELSETS(layerDr),"^",6)		//分摊科室层有效性
	.q:layerActive'="Y"
	.s priority="" f  s priority=$o(^DHCCACOSTDISTSETS(0,"CDMSLP",costSetsDr,layerDr,priority)) q:priority=""  d
	..s DistMethodSub=0 f  s DistMethodSub=$o(^DHCCACOSTDISTSETS(0,"CDMSLP",costSetsDr,layerDr,priority,DistMethodSub)) q:DistMethodSub=""  d
	...s PriorityActive=$p(^DHCCACOSTDISTSETS(costSetsDr,"CDM",DistMethodSub),"^",7)  			//优先级的有效性
	...q:PriorityActive'="Y"
	...s DistParamsSub=0 f  s DistParamsSub=$o(^DHCCACOSTDISTSETS(costSetsDr,"CDM",DistMethodSub,"DistParams",DistParamsSub)) q:DistParamsSub=""  d
	....s DistParamType=$p(^DHCCACOSTDISTSETS(costSetsDr,"CDM",DistMethodSub,"DistParams",DistParamsSub),"^",1)	//分摊指标类型"param"、"income"、"cost"
	....s DistParamDr=$p(^DHCCACOSTDISTSETS(costSetsDr,"CDM",DistMethodSub,"DistParams",DistParamsSub),"^",2)		//分摊指标DR
	....s DistParamName=$p(^DHCCAALLDATAITEMS(DistParamDr),"^",3)		//分摊指标名称
	....;s DistParamRight=$p(^DHCCACOSTDISTSETS(costSetsDr,"CDM",DistMethodSub,"DistParams",DistParamsSub),"^",3)	//分摊指标权重
	....i (DistParamType="param")&&('$d(^DHCCAPARAMDATAS(0,"IntervalItem",intervalDr,DistParamDr)))  d
	.....s result=costSetsName_"的分摊方法设置中，"_layerName_"分层的第"_priority_"优先级设置的分摊参数 "_DistParamName_" 未在参数数据中维护，请处理后再试!"
	....i (DistParamType="income")&&('$d(^DHCCAINCOMEDATAS(0,"IntervalItemdr",intervalDr,DistParamDr)))  d
	.....s result=costSetsName_"的分摊方法设置中，"_layerName_"分层中第"_priority_"优先级设置的分摊参数 "_DistParamName_" 在收入数据中不存在，请处理后再试!"
	....i (DistParamType="cost")&&('$d(^DHCCAVOUCHDATAS(0,"IntervalItem",intervalDr,DistParamDr)))  d
	.....s result=costSetsName_"的分摊方法设置中，"_layerName_"分层中第"_priority_"优先级设置的分摊参数 "_DistParamName_" 在财务支出数据中不存在，请处理后再试!"
	
	q result
}

/// Creator: zjw
/// CreatDate: 2016-03-29
/// Description: 检查参数、收入、成本数据中某科室是大科或未维护到全成本分摊科室配置中
/// Table: dhc.ca.cache.data.Paramdatas;dhc_ca_cache_data.Incomedatas;dhc_ca_cache_data.Vouchdatas
/// Input: intervalDr-核算区间Dr;costSetsDr--成本分摊套ID
/// Output: 
/// Return:返回提示信息,0为正常.
/// Others: w ##class(dhc.ca.cache.udata.DistExamination).ExaminHSDepts(1,1)
ClassMethod ExaminHSDepts(intervalDr, costSetsDr) As %String
{
	n (intervalDr,costSetsDr)
	s result="0"
	
	//根据分摊套DR找对应部门分层设置DR
	s deptSetDr=$p(^DHCCACOSTDISTSETS(costSetsDr),"^",5)
	s deptSetCode=$p(^DHCCADEPTLEVELSETS(deptSetDr),"^",1)
	s deptSetName=$p(^DHCCADEPTLEVELSETS(deptSetDr),"^",2)
	
	s deptStr="",DKdeptStr="",costdistsetDrs=""
	
	//2^3^4^5^6
	s costdistsetDrs=##class(dhc.ca.cache.udata.DoCostDist1).GetBranchs(deptSetDr)				//获取全成本分摊分层下的枝条子层
	
	//236!Y!Y^238!Y!Y^239!Y!Y^240!Y!Y^252!Y!Y^254!Y!Y^255!N!N
	s deptStr=##class(dhc.ca.cache.udata.DoCostDist1).GetLowLayerDepts(costdistsetDrs)	//获取全成本分摊配置中的科室DR
	
	s DKdeptStr=##class(dhc.ca.cache.udata.DoCostDist1).GetBranchDepts(11)				//获取大科拆分中的大科配置科室DR
	
	s deptStr="^"_deptStr
	s DKdeptStr="^"_DKdeptStr
	//判断当期参数表中的科室DR
	s ParamDr="" f  s ParamDr=$o(^DHCCAPARAMDATAS(0,"Interval",intervalDr,ParamDr)) q:(ParamDr="")||(result'="0")  d
	.s ParamDeptDr=$p(^DHCCAPARAMDATAS(ParamDr),"^",10)
	.i $F(DKdeptStr,"^"_ParamDeptDr_"!")>0 d			//判断参数数据中是否有对照到核算大科的数据
	..s DeptName=$p(^DHCCAUNITDEPTS(ParamDeptDr),"^",2)
	..s ItemDr=$p(^DHCCAPARAMDATAS(ParamDr),"^",4)
	..s ItemName=$p(^DHCCAALLDATAITEMS(ItemDr),"^",3)
	..s result= "参数数据维护的"_ItemName_"含有核算大科 "_DeptName_" 的数据，请处理后再试!"
	.e  d
	..i $F(deptStr,"^"_ParamDeptDr_"!")=0 d				//判断参数数据中是否有未配置的核算科室数据!
	...s DeptName=$p(^DHCCAUNITDEPTS(ParamDeptDr),"^",2)
	...s ItemDr=$p(^DHCCAPARAMDATAS(ParamDr),"^",4)
	...s ItemName=$p(^DHCCAALLDATAITEMS(ItemDr),"^",3)
	...s result= "参数数据维护的"_ItemName_"中 "_DeptName_" 未添加到"_deptSetName_"分层配置，请处理后再试!"
	..e  d
	...i $F(deptStr,"^"_ParamDeptDr_"!N!N")>0 d			//判断参数数据中是否有被置为无效的核算科室数据
	....s DeptName=$p(^DHCCAUNITDEPTS(ParamDeptDr),"^",2)
	....s ItemDr=$p(^DHCCAPARAMDATAS(ParamDr),"^",4)
	....s ItemName=$p(^DHCCAALLDATAITEMS(ItemDr),"^",3)
	....s result= "参数数据维护的"_ItemName_"中 "_DeptName_" 已被置为无效科室，请处理后再试!"
	q:result'="0" result
	
	//判断当期收入表中的科室DR
	s IncomeDr=0 f  s IncomeDr=$o(^DHCCAINCOMEDATAS(0,"Interval",intervalDr,IncomeDr)) q:(IncomeDr="")||(result'="0")  d
	.s fDeptDr=$p(^DHCCAINCOMEDATAS(IncomeDr),"^",11)
	.i $F(DKdeptStr,"^"_fDeptDr_"!")>0 d			//判断收入数据中是否有对照到核算大科的数据
	..s result= "收入数据维护中含有核算大科 "_$p(^DHCCAUNITDEPTS(fDeptDr),"^",2)_" 的数据，请处理后再试!"
	.e  d
	..i $F(deptStr,"^"_fDeptDr_"!")=0 d				//判断收入数据中是否有未配置的核算科室数据
	...s result= "收入数据维护中核算开单科室 "_$p(^DHCCAUNITDEPTS(fDeptDr),"^",2)_" 未添加到"_deptSetName_"分层配置，请处理后再试!"
	..e  d
	...i $F(deptStr,"^"_fDeptDr_"!N!N")>0 d			//判断收入数据中是否有被置为无效的核算科室数据
	....s result="收入数据维护中核算开单科室 "_$p(^DHCCAUNITDEPTS(fDeptDr),"^",2)_" 已被置为无效科室，请处理后再试!"
	q:result'="0" result

	//判断当期凭证支出表中的科室DR
	//i costSetsDr=1   不用加判断了，如果未分摊，则财务凭证表无数据即VouchDr为空
	s VouchDr="" f  s VouchDr=$o(^DHCCAVOUCHDATAS(0,"Interval",intervalDr,VouchDr)) q:(VouchDr="")||(result'="0")  d
	.s DeptDr=$p(^DHCCAVOUCHDATAS(VouchDr),"^",2)
	.i $F(DKdeptStr,"^"_DeptDr_"!")>0 d			//判断支出数据中是否有对照到核算大科的数据
	..s result= "财务支出数据中含有核算大科 "_$p(^DHCCAUNITDEPTS(DeptDr),"^",2)_" 的数据，请处理后再试!"
	.e  d
	..i $F(deptStr,"^"_DeptDr_"!")=0 d				//判断支出数据中是否有未配置的核算科室数据
	...s result= "财务支出数据维护中核算科室 "_$p(^DHCCAUNITDEPTS(DeptDr),"^",2)_" 未添加到"_deptSetName_"分层配置，请处理后再试!"
	..e  d
	...i $F(deptStr,"^"_DeptDr_"!N!N")>0 d			//判断支出数据中是否有被置为无效的核算科室数据
	....s result= "财务支出数据维护中核算科室 "_$p(^DHCCAUNITDEPTS(DeptDr),"^",2)_" 已被置为无效科室，请处理后再试!"
	q:result'="0" result
	
	//判断当期原始成本表中的科室DR
	i deptSetCode'="c101" d
	.s BaseDr="" f  s BaseDr=$o(^DHCCABASEDATA(0,"Int",intervalDr,BaseDr)) q:(BaseDr="")||(result'="0")  d
	..s DeptDr=$p(^DHCCABASEDATA(BaseDr),"^",14)
	..i $F(deptStr,"^"_DeptDr_"!")=0 d				//判断原始成本数据中是否有未配置的核算科室数据
	...s result= "原始成本数据维护中核算科室 "_$p(^DHCCAUNITDEPTS(DeptDr),"^",2)_" 未添加到"_deptSetName_"分层配置，请处理后再试!"
	..e  d
	...i $F(deptStr,"^"_DeptDr_"!N!N")>0 d			//判断原始成本数据中是否有被置为无效的核算科室数据
	....s result= "原始成本数据维护中核算科室 "_$p(^DHCCAUNITDEPTS(DeptDr),"^",2)_" 已被置为无效科室，请处理后再试!"
	
	q result
}

/// Creator: zjw
/// CreatDate: 2016-3-31
/// Description: 查看数据是否已经分摊过
/// Table: dhc.ca.cache.data.CostResultData
/// Input：intervalDr-月份ID;CostDistSetsDr-分层套;
/// Output: 
/// Return: 如果不存在返回0,存在返回执行结果
/// Others: w ##class(dhc.ca.cache.udata.uCostResultData).CheckResuitRec(1,1)
ClassMethod CheckResuitRec(intervalDr, CostDistSetsDr) As %String
{
	n (intervalDr,CostDistSetsDr)
	q:intervalDr="" "emptyIntervalDr"
	q:CostDistSetsDr="" "CostDistSetsDr"
	s rowId=0 ,result=0
  
	s rowId=$o(^DHCCACOSTDISTSETS(0,"DInterval",CostDistSetsDr,intervalDr,rowId))
	i rowId>0 d
	.s costsetName=$P(^DHCCACOSTDISTSETS(CostDistSetsDr),"^",3)
	.s result="<font color=#FF0000 size=2>"_"本期"_costsetName_"的数据已分摊，请处理后再试!"_"</font>"
	q result
}

/// Creator: 杨旭  zjw 20160128
/// CreatDate: 2010-04-26
/// Description: 检测数据是否正常
/// Table: dhc.ca.cache.data.VouchDatas; dhc.ca.cache.data.BaseData
/// Input: intervalDr-核算区间Dr;params-参数;costSetsDr--成本分摊套ID
/// Output: 
/// Return:返回提示信息,0为正常.
/// Others: w ##class(dhc.ca.cache.udata.DistExamination).ExaminMain(13,1)
ClassMethod ExaminMain(intervalDr, costSetsDr) As %String
{
	n (intervalDr,costSetsDr)
	s result="0"
	
	s result=..ExaminIntervalDr(intervalDr)		//检测核算周期的本期、上期、去年同期、本年首月是否维护 zjw 20160128
	q:result'="0" 1_","_result
	s result=..CheckResuitRec(intervalDr, costSetsDr)	//检测拆分、分摊结果是否存在
	q:result'="0" 3_","_result
	s result=..ExaminIncomeDept(intervalDr)		//检测收入是否维护  是否有科室、项目未对照  zjw 20160128
	q:result'="0" 4_","_result
	s result=..ExaminCostItem(intervalDr,costSetsDr)	//检测成本数据是否维护、是否有科室、成本项目未对照  zjw 20160128
	q:result'="0" 5_","_result
	s result=..ExaminDistParam(intervalDr, costSetsDr)	//检测参数数据是否维护、是否有科室未对照；分摊方法设置的分摊指标是否维护或存在  zjw 20160128
	q:result'="0" 6_","_result
	s result=..ExaminHSDepts(intervalDr,costSetsDr)		//检查参数、收入、成本数据中某科室是大科或未维护到全成本分摊科室配置中 zjw 20160329
	q:result'="0" 7_","_result
	;s result=..ExaminLayersParam(intervalDr, params)	//检查3,4,5,6层所有科室是否有人员和面积的参数
	;q:result'="0" 5_","_result
	;s result=..ExaminDistRule(intervalDr, costSetsDr)	//科室有成本但分摊方法未设置分摊参数的，终止执行，提示检查--待检测，暂时屏蔽
	;q:result'="0" 4_","_result
	s result=..ExaminIncomeFDeptDr(intervalDr,0,0)		//检测收入数据的开单科室不为直接医疗科室
	q:result'="0" 2_","_result
	
	q result    //q:result="0"
}

Storage Default
{
<StreamLocation>^dhc.ca.c.DistExaminationS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
