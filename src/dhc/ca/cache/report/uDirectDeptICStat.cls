/// 名称:直接医疗科室收入成本收益明细表
/// 描述: 报表打印、导出、展示
/// 编写者：李明忠
/// 编写日期:2010-4-16
Class dhc.ca.cache.report.uDirectDeptICStat Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-4-16
/// Description: 获取所有的实体科室
/// Table：
/// Input：DeptTypeDrStr-部门类别ID字符串(格式:"6,7")
/// Output：
/// Return：返回所有实体部门ID字符串(格式:"1^2^3^4^5")
/// Others：w ##class(dhc.ca.cache.report.uDirectDeptICStat).GetAllEntityDepts("6,7")
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
/// CreatDate：2010-4-16
/// Description: 根据传入的部门类别获取该类别下的实体部门
/// Table：
/// Input：DeptTypeDr-部门类别ID
/// Output：
/// Return：实体科室ID字符串(格式:"59^60^61^62^63")
/// Others：w ##class(dhc.ca.cache.report.uDirectDeptICStat).GetStuckDepts(6)
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
/// CreatDate：2010-4-16
/// Description: 根据传入的部门类别获取该类别下的实体部门
/// Table：
/// Input：DeptTypeDr-部门类别ID
/// Output：
/// Return：实体科室ID字符串(格式:"59^60^61^62^63^68")
/// Others：w ##class(dhc.ca.cache.report.uDirectDeptICStat).GetLeafDepts(6)
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
/// CreatDate：2010-4-16
/// Description: 根据传入的核算月份准备报表数据
/// Table：
/// Input：monthDr-核算月份
/// Output：
/// Return：生成临时Global,暂不返回值
/// Others：w ##class(dhc.ca.cache.report.uDirectDeptICStat).ReadyDatas(1)
ClassMethod ReadyDatas(monthDr) As %String
{
	n (monthDr)
	q:monthDr=""
	
	//1、准备实体科室
	//1.1获取所有公用部门结构下的实体科室(格式:"1^2^3^4^5"),并装入集合
	s PublicDeptDrStr=..GetAllEntityDepts(3) 
	s PublicDeptList=##class(%Library.ListOfDataTypes).%New()
	s PublicDeptDrLen = $L(PublicDeptDrStr,"^")
	f j=1:1:PublicDeptDrLen d
	.s PublicDeptDr=$P(PublicDeptDrStr,"^",j)
	.i PublicDeptDr'="" d
	..d PublicDeptList.Insert(PublicDeptDr)
	//1.2获取直接医疗科室结构下的实体科室(格式:"1^2^3^4^5"),并装入集合
	s DirectDeptDrStr=..GetAllEntityDepts(7)  
	s DirectDeptList=##class(%Library.ListOfDataTypes).%New()
	s DirectDeptDrLen = $L(DirectDeptDrStr,"^")
	f j=1:1:DirectDeptDrLen d
	.s DirectDeptDr=$P(DirectDeptDrStr,"^",j)
	.i DirectDeptDr'="" d
	..d DirectDeptList.Insert(DirectDeptDr)
	
	//2、准备实体科室业务数据
	//2.1根据直接医疗科室准备实体科室收入(开单收入)数据,并写入临时Global,格式^TMP("dhc","ca","direct","income",$j,DirectDeptDr)=Fee
	f i=1:1:DirectDeptList.Count() d
	.s DirectDeptDr=DirectDeptList.GetAt(i)
	.i DirectDeptDr'="" d
	..i $D(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",monthDr,DirectDeptDr)) d
	...s rowid=0
	...f  s rowid=$O(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",monthDr,DirectDeptDr,rowid)) q:rowid=""  d
	....s Curr=$G(^DHCCAINCOMEDATAS(rowid))
	....i Curr'="" d
	.....s Fee=$P(Curr,"^",7) //开单收入金额
	.....i $D(^TMP("dhc","ca","direct","income",$j,DirectDeptDr)) d
	......s ^TMP("dhc","ca","direct","income",$j,DirectDeptDr)=^TMP("dhc","ca","direct","income",$j,DirectDeptDr)+Fee
	.....e  d
	......s ^TMP("dhc","ca","direct","income",$j,DirectDeptDr)=Fee
	
	//2.2根据直接医疗科室准备实体科室成本(直接成本+公用成本)数据,并写入临时Global,格式^TMP("dhc","ca","direct","cost",$j,DirectDeptDr)=Fee
	s cdsRowid=1
	i $D(^DHCCACOSTDISTSETS(0,"DInterval",cdsRowid,monthDr)) d
	.s cRowid=0
	.f  s cRowid=$O(^DHCCACOSTDISTSETS(0,"DInterval",cdsRowid,monthDr,cRowid)) q:cRowid=""  d
	..i $D(^DHCCACOSTDISTSETS(cdsRowid,"CostResultData",cRowid)) d
	...s Curr=$G(^DHCCACOSTDISTSETS(cdsRowid,"CostResultData",cRowid))
	...s DistFlag=$P(Curr,"^",6)
	...i DistFlag="self" d //直接成本标志
	....s DeptDr=$P(Curr,"^",3)
	....i DirectDeptList.Find(DeptDr,1)'="" d
	.....s SelfFee=$P(Curr,"^",5)
	.....i $D(^TMP("dhc","ca","direct","cost",$j,DeptDr)) d
	......s ^TMP("dhc","ca","direct","cost",$j,DeptDr)=^TMP("dhc","ca","direct","cost",$j,DeptDr)+SelfFee
	.....e  d
	......s ^TMP("dhc","ca","direct","cost",$j,DeptDr)=SelfFee
	...i DistFlag="dist" d //公用成本标志
	....s DistDeptDr=$P(Curr,"^",2) //被分摊部门ID
	....i PublicDeptList.Find(DistDeptDr,1)'="" d
	.....s DeptDr=$P(Curr,"^",3)
	.....i DirectDeptList.Find(DeptDr,1)'="" d
	......s DistFee=$P(Curr,"^",5)
	......i $D(^TMP("dhc","ca","direct","cost",$j,DeptDr)) d
	.......s ^TMP("dhc","ca","direct","cost",$j,DeptDr)=^TMP("dhc","ca","direct","cost",$j,DeptDr)+DistFee
	......e  d
	.......s ^TMP("dhc","ca","direct","cost",$j,DeptDr)=DistFee
	
	//生成树状结构的临时Global
	d ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptlevelSetSortedTree(1,0)
	
	//处理各种汇总数据
	d ..HandlDatas(DirectDeptDrStr)
}

/// Creator：李明忠
/// CreatDate：2010-4-16
/// Description: 处理各种汇总数据
/// Table：
/// Input：rowid-实体科室ID
/// Output：
/// Return：生成临时Global,暂不返回值
/// Others：w ##class(dhc.ca.cache.report.uDirectDeptICStat).HandlDatas("59^69^79")
ClassMethod HandlDatas(EntityDeptDrStr) As %String
{
	n (EntityDeptDrStr)
	
	//生成非末端科室的临时Global数据
	s Len=$L(EntityDeptDrStr)
	f i=1:1:Len d
	.s DeptDr=$P(EntityDeptDrStr,"^",i)
	.i DeptDr'="" d 
	..i $D(^tmpdhccadeptleveltree($j,"leaf",DeptDr)) d 
	...s Curr=$G(^tmpdhccadeptleveltree($j,"leaf",DeptDr))
	...i Curr'="" d
	....s Order=$P(Curr,"||",1)
	....s Depth=$L($P(Curr,"||",2),"^")
	....d ..DeptDatas(DeptDr,Order,Depth)
	....f j=1:1:(Depth-1) d //根据树枝结构的深度去遍历节点并做相关数据的汇总处理,去掉顶枝,故减1
	.....s FrameDr=$P($P(Curr,"||",2),"^",j)
	.....d ..DeptsToFrames(FrameDr,DeptDr,Order)
}

/// Creator：李明忠
/// CreatDate：2010-4-16
/// Description: 生成实体科室数据
/// Table：
/// Input：DeptDr-实体科室ID;Order-叶子节点科室的排列序号;Depth-叶子节点科室的深度
/// Output：
/// Return：生成临时Global,暂不返回值
/// Others：w ##class(dhc.ca.cache.report.uDirectDeptICStat).DeptDatas(59,1,3)
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
	...s income=0.00,cost=0.00,fee=0.00
	...i $D(^TMP("dhc","ca","direct","income",$j,DeptDr)) s income=^TMP("dhc","ca","direct","income",$j,DeptDr) //开单收入
	...i $D(^TMP("dhc","ca","direct","cost",$j,DeptDr)) s cost=^TMP("dhc","ca","direct","cost",$j,DeptDr) //接收收入
	...s fee=income-cost //收益
	...s ^TMP("dhc","ca","direct",$j,Order,"leaf",DeptDr)=Str_DeptName_"^"_income_"^"_cost_"^"_fee //叶子节点(即:实体科室)报表数据
}

/// Creator：李明忠
/// CreatDate：2010-4-16
/// Description: 将数据从实体科室汇总到各级父节点
/// Table：
/// Input：FrameDr-父节点ID;DeptDr-实体科室ID;LeafOrder-叶子节点科室的排列序号
/// Output：
/// Return：生成临时Global,暂不返回值
/// Others：w ##class(dhc.ca.cache.report.uDirectDeptICStat).DeptsToFrames(6,59,61)
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
	i $D(^TMP("dhc","ca","direct",$j,LeafOrder,"leaf",DeptDr)) d
	.s Curr=$G(^TMP("dhc","ca","direct",$j,LeafOrder,"leaf",DeptDr))
	.i Curr'="" d
	..s income=0.00,cost=0.00,fee=0.00
	..s income=$P(Curr,"^",2) //开单收入
	..s cost=$P(Curr,"^",3) //成本
	..s fee=$P(Curr,"^",4) //收益
	..i $D(^TMP("dhc","ca","direct",$j,Order,"trunk",FrameDr)) d
	...s CurrRow=$G(^TMP("dhc","ca","direct",$j,Order,"trunk",FrameDr))
	...s ^TMP("dhc","ca","direct",$j,Order,"trunk",FrameDr)=Str_FrameName_" 小计"_"^"_($P(CurrRow,"^",2)+income)_"^"_($P(CurrRow,"^",3)+cost)_"^"_($P(CurrRow,"^",4)+fee) //报表数据
	..e  d
	...s ^TMP("dhc","ca","direct",$j,Order,"trunk",FrameDr)=Str_FrameName_" 小计"_"^"_income_"^"_cost_"^"_fee //报表数据
}

/// Creator：李明忠
/// CreatDate：2010-4-16
/// Description: 将数据从临时Global写入到将要输出的新的临时Global
/// Table：
/// Input：repid-新生成临时Global的节点变量;ind-新生成临时Global的节点变量
/// Output：
/// Return：返回ind值
/// Others：w ##class(dhc.ca.cache.report.uDirectDeptICStat).OutputReportRow(1,1)
ClassMethod OutputReportRow(repid, ind) As %String
{
	i $D(^TMP("dhc","ca","direct",$j)) d
	.s Order=""
	.f  s Order=$O(^TMP("dhc","ca","direct",$j,Order)) q:Order=""  d
	..s str="" 
	..f  s str=$O(^TMP("dhc","ca","direct",$j,Order,str)) q:str=""  d
	...s Num=""
	...f  s Num=$O(^TMP("dhc","ca","direct",$j,Order,str,Num)) q:Num=""  d
	....s Curr=$G(^TMP("dhc","ca","direct",$j,Order,str,Num))
	....i Curr'="" d
	.....s DeptName=$P(Curr,"^",1) //科室名称
	.....s income=$P(Curr,"^",2) //开单收入
	.....s income=$fn(income,"",4)
	.....s cost=$P(Curr,"^",3) //成本
	.....s cost=$fn(cost,"",4)
	.....s fee=$P(Curr,"^",4) //收益
	.....s fee=$fn(fee,"",4)
	.....i (DeptName'="") d
	......s Data=$lb(DeptName,income,cost,fee) //按顺序对应Query的传出参数
	......s ^CacheTemp(repid,ind)=Data
	......s ind=ind+1
	q ind
}

ClassMethod ListDirectDeptQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListDirectDeptQueryExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

//w ##class(dhc.ca.cache.report.DirectDeptICStat).ListDirectDeptQueryExecute("",1)

ClassMethod ListDirectDeptQueryExecute(ByRef qHandle As %Binary, monthDr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	d ..ReadyDatas(monthDr)
	s ind=..OutputReportRow(repid,ind)
	s qHandle=$lb(0,repid,0)
	
	k ^tmpdhccadeptleveltree($j)
	k ^TMP("dhc","ca","direct","income",$j)
	k ^TMP("dhc","ca","direct","cost",$j)
	k ^TMP("dhc","ca","direct",$j)
	
	q $$$OK
}

ClassMethod ListDirectDeptQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListDirectDeptQueryExecute ]
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

Query ListDirectDeptQuery(monthDr As %String) As %Query(ROWSPEC = "DeptName:%String:科室名称,income:%Float:收入,cost:%Float:成本,fee:%Float:收益")
{
}

}
