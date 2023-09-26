/// 名称:绩效核算收入汇总表
/// 描述: 报表打印、导出、展示
/// 编写者：李明忠
/// 编写日期:2010-3-31
Class dhc.ca.cache.report.uPerformanceAccountIncomesReport Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-3-31
/// Description: 获取科室类别
/// Table：
/// Input：SearchField-查询字段;SearchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.report.uPerformanceAccountIncomesReport).GetDeptTypes(0, 10)
ClassMethod GetDeptTypes(Start, Limit) As %String
{
	n (Start, Limit)
	
	s Parent=1,Count=0,ResultString=""
	s Json = ##class(dhc.ca.cache.comm.JsonObj).%New()
	s End = Start+Limit
	s rowid=""
	i $D(^DHCCADEPTLEVELSETS(0,"Parent",Parent)) d
	.f  s rowid=$O(^DHCCADEPTLEVELSETS(0,"Parent",Parent,rowid)) q:rowid=""  d
	..s Curr=$G(^DHCCADEPTLEVELSETS(rowid))
	..s Name=$P(Curr,"^",2)
	..s Tmp=rowid_"^"_Name
	..s Count=Count+1
	..i (Count>=Start)&(Count<=End) d
	...d Json.InsertRowData(Tmp)
	s ResultString = Json.getJsonData("id^name",Count)
 	k Json
	q ResultString
}

/// Creator：李明忠
/// CreatDate：2010-3-31
/// Description: 获取所有的实体科室
/// Table：
/// Input：DeptTypeDrStr-部门类别ID字符串(格式:"6,7")
/// Output：
/// Return：返回所有实体部门ID字符串(格式:"1^2^3^4^5")
/// Others：w ##class(dhc.ca.cache.report.uPerformanceAccountIncomesReport).GetAllEntityDepts("6,7")
ClassMethod GetAllEntityDepts(DeptTypeDrStr) As %String
{
	n (DeptTypeDrStr)
	
	s EntityDeptDrStr=""
	s DeptTypeLen=$L(DeptTypeDrStr,",")
	
	//思路：首先获取叶子部门,其次在获取结构部门下的叶子部门
	f i=1:1:DeptTypeLen d
	.s DeptTypeDr=$P(DeptTypeDrStr,",",i)
	.i EntityDeptDrStr="" s EntityDeptDrStr=..GetLeafDepts(DeptTypeDr)
	.e  s EntityDeptDrStr=EntityDeptDrStr_"^"_..GetLeafDepts(DeptTypeDr)
	.i EntityDeptDrStr="" s EntityDeptDrStr=..GetStuckDepts(DeptTypeDr)
	.e  s EntityDeptDrStr=EntityDeptDrStr_"^"_..GetStuckDepts(DeptTypeDr)
	
	q EntityDeptDrStr
}

/// Creator：李明忠
/// CreatDate：2010-3-31
/// Description: 根据传入的部门类别获取该类别下的实体部门
/// Table：
/// Input：DeptTypeDr-部门类别ID
/// Output：
/// Return：实体科室ID字符串(格式:"59^60^61^62^63")
/// Others：w ##class(dhc.ca.cache.report.uPerformanceAccountIncomesReport).GetStuckDepts(6)
ClassMethod GetStuckDepts(DeptTypeDr) As %String
{
	n (DeptTypeDr)
	
	s rowid="",EntityDeptDrStr=""
	i $D(^DHCCADEPTLEVELSETS(0,"Parent",DeptTypeDr)) d
	.f  s rowid=$O(^DHCCADEPTLEVELSETS(0,"Parent",DeptTypeDr,rowid)) q:rowid=""  d
	..i $D(^DHCCADEPTLEVELSETS(0,"Parent",rowid)) d
	...i EntityDeptDrStr="" s EntityDeptDrStr=..GetLeafDepts(rowid)
	...e  s EntityDeptDrStr=EntityDeptDrStr_"^"_..GetLeafDepts(rowid)
	...i EntityDeptDrStr="" s EntityDeptDrStr=..GetStuckDepts(rowid)
	...e  s EntityDeptDrStr=EntityDeptDrStr_"^"_..GetStuckDepts(rowid)
	..e  d //直接获取实体部门
	...i EntityDeptDrStr="" s EntityDeptDrStr=..GetLeafDepts(rowid)
	...e  s EntityDeptDrStr=EntityDeptDrStr_"^"_..GetLeafDepts(rowid)
	
	q EntityDeptDrStr
}

/// Creator：李明忠
/// CreatDate：2010-3-31
/// Description: 根据传入的部门类别获取该类别下的实体部门
/// Table：
/// Input：DeptTypeDr-部门类别ID
/// Output：
/// Return：实体科室ID字符串(格式:"59^60^61^62^63^68")
/// Others：w ##class(dhc.ca.cache.report.uPerformanceAccountIncomesReport).GetLeafDepts(6)
ClassMethod GetLeafDepts(DeptTypeDr) As %String
{
	n (DeptTypeDr)
	
	s LeafDrStr=""
	s childSubRowid=0 //0是党总支,所以从0以后的记录开始循环
	f  s childSubRowid=$O(^DHCCADEPTLEVELSETS(DeptTypeDr,"Depts",childSubRowid)) q:childSubRowid=""  d
	.i $P(^DHCCADEPTLEVELSETS(DeptTypeDr,"Depts",childSubRowid),"^",1)'="" d
	..s LeafDr=$P(^DHCCADEPTLEVELSETS(DeptTypeDr,"Depts",childSubRowid),"^",1) //获取实体部门的ID
	..i LeafDr'="" d
	...i LeafDrStr="" s LeafDrStr=LeafDr
	...e  s LeafDrStr=LeafDrStr_"^"_LeafDr
	
	q LeafDrStr
}

/// Creator：李明忠
/// CreatDate：2010-4-9
/// Description: 根据传入的核算月份、部门类别准备报表数据
/// Table：
/// Input：monthDr-核算月份;DeptTypeDrStr-部门类别ID字符串(格式:"6,7")
/// Output：
/// Return：生成临时Global,暂不返回值
/// Others：w ##class(dhc.ca.cache.report.uPerformanceAccountIncomesReport).ReadyDatas(1,"6,7")
ClassMethod ReadyDatas(monthDr, DeptTypeDrStr) As %String
{
	n (monthDr,DeptTypeDrStr)

	
	//对收入数据进行汇总统计,包含药费
	//开单科室收入数据：^TMPJXHSSR("dhc","ca","FJXHSSR",$j,FDeptDr)=FFee
	//接收科室收入数据：^TMPJXHSSR("dhc","ca","TJXHSSR",$j,TDeptDr)=TFee
	i $D(^DHCCAINCOMEDATAS(0,"Interval",monthDr)) d
	.s rowid=0
	.f  s rowid=$O(^DHCCAINCOMEDATAS(0,"Interval",monthDr,rowid)) q:rowid=""  d
	..i $D(^DHCCAINCOMEDATAS(rowid)) d
	...s Curr=$G(^DHCCAINCOMEDATAS(rowid))
	...i Curr'="" d
	....s FDeptDr=$P(Curr,"^",11) //开单科室ID
	....s TDeptDr=$P(Curr,"^",14) //接收科室ID
	....s FFee=$P(Curr,"^",7) //开单收入金额
	....s TFee=$P(Curr,"^",7) //接收收入金额
	....i FDeptDr'="" d
	.....i $D(^TMPJXHSSR("dhc","ca","FJXHSSR",$j,FDeptDr)) d //开单收入临时Global
	......s ^TMPJXHSSR("dhc","ca","FJXHSSR",$j,FDeptDr)=^TMPJXHSSR("dhc","ca","FJXHSSR",$j,FDeptDr)+FFee
	.....e  d
	......s ^TMPJXHSSR("dhc","ca","FJXHSSR",$j,FDeptDr)=FFee
	....i TDeptDr'="" d
	.....i $D(^TMPJXHSSR("dhc","ca","TJXHSSR",$j,TDeptDr)) d //接收收入临时Global
	......s ^TMPJXHSSR("dhc","ca","TJXHSSR",$j,TDeptDr)=^TMPJXHSSR("dhc","ca","TJXHSSR",$j,TDeptDr)+TFee
	.....e  d
	......s ^TMPJXHSSR("dhc","ca","TJXHSSR",$j,TDeptDr)=TFee
	
	//对分成收入数据进行汇总统计,不包含药费
	//开单分成收入数据：^TMPJXHSSR("dhc","ca","FCFJXHSSR",$j,InDeptDr)=FCFee
	//接收分成收入数据：^TMPJXHSSR("dhc","ca","FCTJXHSSR",$j,InDeptDr)=FCFee
	i $D(^DHCCAINDISTDATA(0,"Int",monthDr)) d
	.s Rowid=0
	.f  s Rowid=$O(^DHCCAINDISTDATA(0,"Int",monthDr,Rowid)) q:Rowid=""  d
	..i $D(^DHCCAINDISTDATA(Rowid)) d
	...s Curr=$G(^DHCCAINDISTDATA(Rowid))
	...i Curr'="" d
	....s DataFlag=$P(Curr,"^",2) //数据标示
	....i DataFlag="order" d //开单分成收入标志
	.....s InItemDr=$P(Curr,"^",4) //收入项目ID
	.....i ((InItemDr'=29)&&(InItemDr'=30)) d
	......s InDeptDr=$P(Curr,"^",3) //收入部门ID
	......s FCFee=$P(Curr,"^",5) //分成收入金额
	......i InDeptDr'="" d
	.......i $D(^TMPJXHSSR("dhc","ca","FCFJXHSSR",$j,InDeptDr)) d //开单分成收入临时Global
	........s ^TMPJXHSSR("dhc","ca","FCFJXHSSR",$j,InDeptDr)=^TMPJXHSSR("dhc","ca","FCFJXHSSR",$j,InDeptDr)+FCFee
	.......e  d
	........s ^TMPJXHSSR("dhc","ca","FCFJXHSSR",$j,InDeptDr)=FCFee
	....i DataFlag="do" d //接收分成收入标志
	.....s InItemDr=$P(Curr,"^",4) //收入项目ID
	.....i ((InItemDr'=29)&&(InItemDr'=30)) d
	......s InDeptDr=$P(Curr,"^",3) //收入部门ID
	......s FCFee=$P(Curr,"^",5) //分成收入金额
	......i InDeptDr'="" d
	.......i $D(^TMPJXHSSR("dhc","ca","FCTJXHSSR",$j,InDeptDr)) d //接收分成收入临时Global
	........s ^TMPJXHSSR("dhc","ca","FCTJXHSSR",$j,InDeptDr)=^TMPJXHSSR("dhc","ca","FCTJXHSSR",$j,InDeptDr)+FCFee
	.......e  d
	........s ^TMPJXHSSR("dhc","ca","FCTJXHSSR",$j,InDeptDr)=FCFee
	
	//生成树状结构的临时Global
	d ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptlevelSetSortedTree(1,0)
	
	//获取用户所选科室类别下的所属实体科室
	s EntityDeptDrStr=..GetAllEntityDepts(DeptTypeDrStr)
	//处理各种汇总数据
	d ..HandlDatas(EntityDeptDrStr)
	//按照用户所选科室类别做最后汇总
	d ..Total(DeptTypeDrStr)
}

/// Creator：李明忠
/// CreatDate：2010-4-9
/// Description: 处理各种汇总数据
/// Table：
/// Input：rowid-实体科室ID
/// Output：
/// Return：生成临时Global,暂不返回值
/// Others：w ##class(dhc.ca.cache.report.uPerformanceAccountIncomesReport).HandlDatas("59^69^79")
ClassMethod HandlDatas(EntityDeptDrStr) As %String
{
	n (EntityDeptDrStr)
	
	//生成非末端科室的临时Global数据
	s Len=$L(EntityDeptDrStr)
	f i=1:1:Len d
	.s DeptDr=$P(EntityDeptDrStr,"^",i)
	.i DeptDr'="" d 
	..i $D(^tmpdhccadeptleveltree($j,"leaf",DeptDr)) d 
	...s Order=$P(^tmpdhccadeptleveltree($j,"leaf",DeptDr),"||",1)
	...s Depth=$L($P(^tmpdhccadeptleveltree($j,"leaf",DeptDr),"||",2),"^")
	...d ..DeptDatas(DeptDr,Order,Depth)
	...f j=1:1:(Depth-1) d //根据树枝结构的深度去遍历节点并做相关数据的汇总处理,去掉顶枝
	....s FrameDr=$P($P(^tmpdhccadeptleveltree($j,"leaf",DeptDr),"||",2),"^",j)
	....d ..DeptsToFrames(FrameDr,DeptDr,Order)
}

/// Creator：李明忠
/// CreatDate：2010-4-9
/// Description: 生成实体科室数据
/// Table：
/// Input：DeptDr-实体科室ID;Order-叶子节点科室的排列序号;Depth-叶子节点科室的深度
/// Output：
/// Return：生成临时Global,暂不返回值
/// Others：w ##class(dhc.ca.cache.report.uPerformanceAccountIncomesReport).DeptDatas(59,1,3)
ClassMethod DeptDatas(DeptDr, Order, Depth) As %String
{
	n (DeptDr,Order,Depth)
	
	i Depth=0 s Str="" 			//根据深度决定科室级别
	i Depth=1 s Str=" " 				
	i Depth=2 s Str="    "
	i Depth=3 s Str="       "
	i Depth=4 s Str="          "
	i Depth=5 s Str="             "
	//取叶子节点的顺序号及节点深度
	i $D(^tmpdhccadeptleveltree($j,"leaf",DeptDr)) d
	.i $D(^DHCCAUNITDEPTS(DeptDr)) d
	..s DeptName=$P(^DHCCAUNITDEPTS(DeptDr),"^",2) //获取实体科室的科室名称
	..i DeptName'="" d
	...s fFee=0.00,tFee=0.00,fcfFee=0.00,fctFee=0.00,fcFee=0.00
	...i $D(^TMPJXHSSR("dhc","ca","FJXHSSR",$j,DeptDr)) s fFee=^TMPJXHSSR("dhc","ca","FJXHSSR",$j,DeptDr) //开单收入
	...i $D(^TMPJXHSSR("dhc","ca","TJXHSSR",$j,DeptDr)) s tFee=^TMPJXHSSR("dhc","ca","TJXHSSR",$j,DeptDr) //接收收入
	...i $D(^TMPJXHSSR("dhc","ca","FCFJXHSSR",$j,DeptDr)) s fcfFee=^TMPJXHSSR("dhc","ca","FCFJXHSSR",$j,DeptDr) //开单分成收入(不包含药费)
	...i $D(^TMPJXHSSR("dhc","ca","FCTJXHSSR",$j,DeptDr)) s fctFee=^TMPJXHSSR("dhc","ca","FCTJXHSSR",$j,DeptDr) //接收分成收入(不包含药费)
	...s fcFee=fcfFee+fctFee //核算收入(不包含药费)
	...s ^TMPJXHSSR("dhc","ca","JXHSSR",$j,Order,"leaf",DeptDr)=Str_DeptName_"^"_fFee_"^"_tFee_"^"_fcfFee_"^"_fctFee_"^"_fcFee //叶子节点(即:实体科室)报表数据
}

/// Creator：李明忠
/// CreatDate：2010-4-9
/// Description: 将数据从实体科室汇总到各级父节点
/// Table：
/// Input：FrameDr-父节点ID;DeptDr-实体科室ID;LeafOrder-叶子节点科室的排列序号
/// Output：
/// Return：生成临时Global,暂不返回值
/// Others：w ##class(dhc.ca.cache.report.uPerformanceAccountIncomesReport).DeptsToFrames(6,59)
ClassMethod DeptsToFrames(FrameDr, DeptDr, LeafOrder) As %String
{
	n (FrameDr,DeptDr,LeafOrder)
	
	//获取父节点科室的科室名称
	i $D(^DHCCADEPTLEVELSETS(FrameDr)) s FrameName=$P(^DHCCADEPTLEVELSETS(FrameDr),"^",2)
	e  s FrameName=""
	//根据父节点的ID取父节点的顺序号及节点深度
	i $D(^tmpdhccadeptleveltree($j,"trunk",FrameDr)) d
	.s Order=$P(^tmpdhccadeptleveltree($j,"trunk",FrameDr),"||",1)
	.s Depth=$L($P(^tmpdhccadeptleveltree($j,"trunk",FrameDr),"||",2),"^")-1
	.i Depth=0 s Str=""				//根据深度决定科室级别
	.i Depth=1 s Str=" "            
	.i Depth=2 s Str="    "
	.i Depth=3 s Str="       "
	.i Depth=4 s Str="          "
	.i Depth=5 s Str="             "
	//生成非末端科室的临时Global数据
	i $D(^TMPJXHSSR("dhc","ca","JXHSSR",$j,LeafOrder,"leaf",DeptDr)) d
	.s Curr=$G(^TMPJXHSSR("dhc","ca","JXHSSR",$j,LeafOrder,"leaf",DeptDr))
	.i Curr'="" d
	..s fFee=0.00,tFee=0.00,fcfFee=0.00,fctFee=0.00,fcFee=0.00
	..s fFee=$P(Curr,"^",2) //开单收入
	..s tFee=$P(Curr,"^",3) //接收收入
	..s fcfFee=$P(Curr,"^",4) //开单分成收入(不包含药费)
	..s fctFee=$P(Curr,"^",5) //接收分成收入(不包含药费)
	..s fcFee=$P(Curr,"^",6) //核算收入(不包含药费)
	..i $D(^TMPJXHSSR("dhc","ca","JXHSSR",$j,Order,"trunk",FrameDr)) d
	...s CurrRow=$G(^TMPJXHSSR("dhc","ca","JXHSSR",$j,Order,"trunk",FrameDr))
	...s ^TMPJXHSSR("dhc","ca","JXHSSR",$j,Order,"trunk",FrameDr)=Str_FrameName_" 小计"_"^"_($P(CurrRow,"^",2)+fFee)_"^"_($P(CurrRow,"^",3)+tFee)_"^"_($P(CurrRow,"^",4)+fcfFee)_"^"_($P(CurrRow,"^",5)+fctFee)_"^"_($P(CurrRow,"^",6)+fcFee) //报表数据
	..e  d
	...s ^TMPJXHSSR("dhc","ca","JXHSSR",$j,Order,"trunk",FrameDr)=Str_FrameName_" 小计"_"^"_fFee_"^"_tFee_"^"_fcfFee_"^"_fctFee_"^"_fcFee //报表数据
}

/// Creator：李明忠
/// CreatDate：2010-4-9
/// Description: 最终统计用户所选择科室类别下所属实体科室的各项数据
/// Table：
/// Input：TypeDrStr-用户所选择的科室类别ID字符串
/// Output：
/// Return：生成临时Global,暂不返回值
/// Others：w ##class(dhc.ca.cache.report.uPerformanceAccountIncomesReport).Total("6,7")
ClassMethod Total(TypeDrStr) As %String
{
	n (TypeDrStr)
	
	s Len=$L(TypeDrStr,",")
	f k=1:1:Len d
	.s typeDr=$P(TypeDrStr,",",k)
	.i typeDr'="" d
	..i $D(^TMPJXHSSR("dhc","ca","JXHSSR",$j)) d
	...s order="" 
	...f  s order=$O(^TMPJXHSSR("dhc","ca","JXHSSR",$j,order)) q:order=""  d
	....i $D(^TMPJXHSSR("dhc","ca","JXHSSR",$j,order,"trunk")) d
	.....s frameDr=""
	.....f  s frameDr=$O(^TMPJXHSSR("dhc","ca","JXHSSR",$j,order,"trunk",frameDr)) q:frameDr'=typeDr  d
	......s Curr=$G(^TMPJXHSSR("dhc","ca","JXHSSR",$j,order,"trunk",frameDr))
	......i Curr'="" d
	.......s fFee=0.00,tFee=0.00,fcfFee=0.00,fctFee=0.00,fcFee=0.00
	.......s fFee=$P(Curr,"^",2) //开单总收入
	.......s tFee=$P(Curr,"^",3) //接收总收入
	.......s fcfFee=$P(Curr,"^",4) //开单分成总收入(不包含药费)
	.......s fctFee=$P(Curr,"^",5) //接收分成总收入(不包含药费)
	.......s fcFee=$P(Curr,"^",6) //核算总收入(不包含药费)
	.......i $D(^TMPJXHSSR("dhc","ca","JXHSSR",$j,$j,"Total",0)) d
	........s CurrRow=$G(^TMPJXHSSR("dhc","ca","JXHSSR",$j,$j,"Total",0))
	........s ^TMPJXHSSR("dhc","ca","JXHSSR",$j,$j,"Total",0)="绩效核算收入合计"_"^"_($P(CurrRow,"^",2)+fFee)_"^"_($P(CurrRow,"^",3)+tFee)_"^"_($P(CurrRow,"^",4)+fcfFee)_"^"_($P(CurrRow,"^",5)+fctFee)_"^"_($P(CurrRow,"^",6)+fcFee)
	.......e  d
	........s ^TMPJXHSSR("dhc","ca","JXHSSR",$j,$j,"Total",0)="绩效核算收入合计"_"^"_fFee_"^"_tFee_"^"_fcfFee_"^"_fctFee_"^"_fcFee
}

/// Creator：李明忠
/// CreatDate：2010-4-9
/// Description: 将数据从临时Global写入到将要输出的新的临时Global
/// Table：
/// Input：repid-新生成临时Global的节点变量;ind-新生成临时Global的节点变量
/// Output：
/// Return：返回ind值
/// Others：w ##class(dhc.ca.cache.report.uPerformanceAccountIncomesReport).OutputReportRow(1,1)
ClassMethod OutputReportRow(repid, ind) As %String
{
	i $D(^TMPJXHSSR("dhc","ca","JXHSSR",$j)) d
	.s Order=""
	.f  s Order=$O(^TMPJXHSSR("dhc","ca","JXHSSR",$j,Order)) q:Order=""  d
	..s str="" 
	..f  s str=$O(^TMPJXHSSR("dhc","ca","JXHSSR",$j,Order,str)) q:str=""  d
	...s Num=""
	...f  s Num=$O(^TMPJXHSSR("dhc","ca","JXHSSR",$j,Order,str,Num)) q:Num=""  d
	....s Curr=$G(^TMPJXHSSR("dhc","ca","JXHSSR",$j,Order,str,Num))
	....i Curr'="" d
	.....s DeptName=$P(Curr,"^",1) //科室名称
	.....s FIncome=$P(Curr,"^",2) //开单收入
	.....s TIncome=$P(Curr,"^",3) //接收收入
	.....s FCFIncome=$P(Curr,"^",4) //开单分成收入
	.....s FCTIncome=$P(Curr,"^",5) //接收分成收入
	.....s AccountIncome=$P(Curr,"^",6) //核算收入(不包含药费)
	.....i (DeptName'="") d
	......s Data=$lb(DeptName,FIncome,TIncome,FCFIncome,FCTIncome,AccountIncome) //按顺序对应Query的传出参数
	......s ^CacheTemp(repid,ind)=Data
	......s ind=ind+1
	q ind
}

ClassMethod ListPerforAccountQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListPerforAccountQueryExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

//w ##class(dhc.ca.cache.report.uPerformanceAccountIncomesReport).ListPerforAccountQueryExecute("",5,6)

ClassMethod ListPerforAccountQueryExecute(ByRef qHandle As %Binary, monthDr As %String, DeptTypeDrStr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	d ..ReadyDatas(monthDr,DeptTypeDrStr)
	s ind=..OutputReportRow(repid,ind)
	s qHandle=$lb(0,repid,0)
	k ^tmpdhccadeptleveltree($j)
	k ^TMPJXHSSR("dhc","ca","FCTJXHSSR",$j)
	k ^TMPJXHSSR("dhc","ca","FCFJXHSSR",$j)
	k ^TMPJXHSSR("dhc","ca","FJXHSSR",$j)
	k ^TMPJXHSSR("dhc","ca","TJXHSSR",$j)
	k ^TMPJXHSSR("dhc","ca","JXHSSR",$j)
	
	q $$$OK
}

ClassMethod ListPerforAccountQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListPerforAccountQueryExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {			
		s AtEnd=1
		s Row=""
	}
	Else {				
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query ListPerforAccountQuery(monthDr As %String, DeptTypeDrStr As %String) As %Query(ROWSPEC = "DeptName:%String:科室名称,FIncome:%Float:开单收入,TIncome:%Float:接收收入,FCFIncome:%Float:开单分成收入,FCTIncome:%Float:接收分成收入,AccountIncome:%Float:核算收入")
{
}

Storage Default
{
<Data name="uPerformanceAccountIncomesReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.cach70D.uPerformanceCFED</DataLocation>
<DefaultData>uPerformanceAccountIncomesReportDefaultData</DefaultData>
<IdLocation>^dhc.ca.cach70D.uPerformanceCFED</IdLocation>
<IndexLocation>^dhc.ca.cach70D.uPerformanceCFEI</IndexLocation>
<StreamLocation>^dhc.ca.cach70D.uPerformanceCFES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
