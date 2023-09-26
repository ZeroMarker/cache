/// 名称:临床科室工作量明细表
/// 描述: 报表打印、导出、展示
/// 编写者：李明忠
/// 编写日期:2010-4-2
Class dhc.ca.cache.report.uClinDeptWorkloadDetails Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-4-2
/// Description: 获取科室类别
/// Table：
/// Input：SearchField-查询字段;SearchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.report.uClinDeptWorkloadDetails).GetDeptTypes(0, 10)
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
/// CreatDate：2010-4-2
/// Description: 获取所有的实体科室
/// Table：
/// Input：DeptTypeDrStr-部门类别ID字符串(格式:"6,7")
/// Output：
/// Return：返回所有实体部门ID字符串(格式:"1^2^3^4^5")
/// Others：w ##class(dhc.ca.cache.report.uClinDeptWorkloadDetails).GetAllEntityDepts("6,7")
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
/// CreatDate：2010-4-2
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
/// CreatDate：2010-4-2
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

/*
/// Creator：李明忠
/// CreatDate：2010-4-2
/// Description: 根据传入的核算月份、部门类别准备报表数据
/// Table：
/// Input：monthDr-核算月份;DeptTypeDrStr-部门类别ID字符串(格式:"6,7");ItemDrStr-项目ID字符串(格式:"937^938")
/// Output：
/// Return：生成临时Global,暂不返回值
/// Others：w ##class(dhc.ca.cache.report.uClinDeptWorkloadDetails).ReadyDatas(1,7,"933^934^935^936^937^938")
ClassMethod ReadyDatas(monthDr, DeptTypeDrStr, ItemDrStr) As %String
{
	n (monthDr,DeptTypeDrStr,ItemDrStr)
	
	k ^TMP("dhc","ca","psCount")
	&SQL(delete from dhc_ca_cache_report.ClinDeptWLD)
	//先从单位人员表找科室人数
	//格式：^TMP("dhc","ca","psCount",$j,DeptDr)=Count
	s psrowid=0
	f  s psrowid=$O(^DHCCAUNITPERSONS(psrowid)) q:psrowid=""  d
	.s num=0
	.f  s num=$O(^DHCCAUNITPERSONS(psrowid,"PersonDepts",num)) q:num=""  d
	..s Curr=$G(^DHCCAUNITPERSONS(psrowid,"PersonDepts",num))
	..s Active=$P(Curr,"^",4)
	..i Active="Y" d
	...s DeptDr=$P(Curr,"^",1)
	...i DeptDr'="" d 
	....i $D(^TMP("dhc","ca","psCount",$j,DeptDr)) d
	.....s ^TMP("dhc","ca","psCount",$j,DeptDr)=^TMP("dhc","ca","psCount",$j,DeptDr)+1
	....e  d
	.....s ^TMP("dhc","ca","psCount",$j,DeptDr)=1
	
	//汇总参数数据
	//格式：^TMP("dhc","ca","param","item",$j,DeptDr,ItemName)=Value
	s ItemDrLen=$L(ItemDrStr,"^")
	f k=1:1:ItemDrLen d
	.s ItemDr=$P(ItemDrStr,"^",k)
	.i ItemDr'="" d
	..i $D(^DHCCAPARAMDATAS(0,"IntervalItem",monthDr,ItemDr)) d
	...s paramRowid=0
	...f  s paramRowid=$O(^DHCCAPARAMDATAS(0,"IntervalItem",monthDr,ItemDr,paramRowid)) q:paramRowid=""  d
	....i $D(^DHCCAPARAMDATAS(paramRowid)) d
	.....s Curr=$G(^DHCCAPARAMDATAS(paramRowid))
	.....s ServDeptDr=$P(Curr,"^",10) //服务部门ID
	.....i ServDeptDr'="" d
	......s Value=$P(Curr,"^",11) //参数值(即部分工作量值)
	......i $D(^TMP("dhc","ca","param","item",$j,ServDeptDr,ItemDr)) d
	.......s ^TMP("dhc","ca","param","item",$j,ServDeptDr,ItemDr)=^TMP("dhc","ca","param","item",$j,ServDeptDr,ItemDr)+Value
	......e  d
	.......s ^TMP("dhc","ca","param","item",$j,ServDeptDr,ItemDr)=Value
	
	//获取所有实体部门(格式:"1^2^3^4^5")
	s EntityDeptDrStr=..GetAllEntityDepts(DeptTypeDrStr)
	s EntityDeptDrLen=$L(EntityDeptDrStr,"^")
	s PSItemDr=-1
	f i=1:1:EntityDeptDrLen d
	.s DeptDr=$P(EntityDeptDrStr,"^",i)
	.i $D(^TMP("dhc","ca","psCount",$j,DeptDr)) d
	..s ^TMP("dhc","ca","item",$j,DeptDr,PSItemDr)=^TMP("dhc","ca","psCount",$j,DeptDr)
	.i $D(^TMP("dhc","ca","param","item",$j,DeptDr)) d
	..s ItemDr=""
	..f  s ItemDr=$O(^TMP("dhc","ca","param","item",$j,DeptDr,ItemDr)) q:ItemDr=""  d
	...s ^TMP("dhc","ca","item",$j,DeptDr,ItemDr)=^TMP("dhc","ca","param","item",$j,DeptDr,ItemDr)

	d ..OutputReportRow()
}
*/
/// Creator：李明忠
/// CreatDate：2010-4-2
/// Description: 根据传入的核算月份、部门类别准备报表数据
/// Table：
/// Input：monthDr-核算月份;DeptTypeDrStr-部门类别ID字符串(格式:"6,7");ItemDrStr-项目ID字符串(格式:"937^938")
/// Output：
/// Return：生成临时Global,暂不返回值
/// Others：w ##class(dhc.ca.cache.report.uClinDeptWorkloadDetails).ReadyDatas(1,7,"933^934^935^936^937^938")
ClassMethod ReadyDatas(monthDr, DeptTypeDrStr, ItemDrStr) As %String
{
 n (monthDr,DeptTypeDrStr,ItemDrStr)

 &SQL(delete from dhc_ca_cache_report.ClinDeptWLD)
 //先从单位人员表找科室人数
 //格式：^TMP("dhc","ca","psCount",$j,DeptDr)=Count
 s psrowid=0
 f  s psrowid=$O(^DHCCAUNITPERSONS(psrowid)) q:psrowid=""  d
 .s num=0
 .f  s num=$O(^DHCCAUNITPERSONS(psrowid,"PersonDepts",num)) q:num=""  d
 ..s Curr=$G(^DHCCAUNITPERSONS(psrowid,"PersonDepts",num))
 ..s Active=$P(Curr,"^",4)
 ..i Active="Y" d
 ...s DeptDr=$P(Curr,"^",1)
 ...i DeptDr'="" d 
 ....i $D(^TMP("dhc","ca","psCount",$j,DeptDr)) d
 .....s ^TMP("dhc","ca","psCount",$j,DeptDr)=^TMP("dhc","ca","psCount",$j,DeptDr)+1
 ....e  d
 .....s ^TMP("dhc","ca","psCount",$j,DeptDr)=1

 //汇总参数数据
 //格式：^TMP("dhc","ca","param","item",$j,DeptDr,ItemName)=Value
 s ItemDrLen=$L(ItemDrStr,"^")
 f k=1:1:ItemDrLen d
 .s ItemDr=$P(ItemDrStr,"^",k)
 .i ItemDr'="" d
 ..i $D(^DHCCAPARAMDATAS(0,"IntervalItem",monthDr,ItemDr)) d
 ...s paramRowid=0
 ...f  s paramRowid=$O(^DHCCAPARAMDATAS(0,"IntervalItem",monthDr,ItemDr,paramRowid)) q:paramRowid=""  d
 ....i $D(^DHCCAPARAMDATAS(paramRowid)) d
 .....s Curr=$G(^DHCCAPARAMDATAS(paramRowid))
 .....s ServDeptDr=$P(Curr,"^",10) //服务部门ID
 .....i ServDeptDr'="" d
 ......s Value=$P(Curr,"^",11) //参数值(即部分工作量值)
 ......i $D(^TMP("dhc","ca","param","item",$j,ServDeptDr,ItemDr)) d
 .......s ^TMP("dhc","ca","param","item",$j,ServDeptDr,ItemDr)=^TMP("dhc","ca","param","item",$j,ServDeptDr,ItemDr)+Value
 ......e  d
 .......s ^TMP("dhc","ca","param","item",$j,ServDeptDr,ItemDr)=Value

 //获取所有实体部门(格式:"1^2^3^4^5")
 s EntityDeptDrStr=..GetAllEntityDepts(DeptTypeDrStr)
 s EntityDeptDrLen=$L(EntityDeptDrStr,"^")
 s PSItemDr=-1
 f i=1:1:EntityDeptDrLen d
 .s DeptDr=$P(EntityDeptDrStr,"^",i)
 .i DeptDr'="" d
 ..i $D(^TMP("dhc","ca","psCount",$j,DeptDr)) d
 ...s ^TMP("dhc","ca","item",$j,DeptDr,PSItemDr)=^TMP("dhc","ca","psCount",$j,DeptDr)
 ..i $D(^TMP("dhc","ca","param","item",$j,DeptDr)) d
 ...s ItemDr=""
 ...f  s ItemDr=$O(^TMP("dhc","ca","param","item",$j,DeptDr,ItemDr)) q:ItemDr=""  d
 ....s ^TMP("dhc","ca","item",$j,DeptDr,ItemDr)=^TMP("dhc","ca","param","item",$j,DeptDr,ItemDr)

 d ..OutputReportRow()
}

//w ##class(dhc.ca.cache.report.uClinDeptWorkloadDetails).OutputReportRow()

ClassMethod OutputReportRow() As %String
{
	s deptDr=""
	f  s deptDr=$O(^TMP("dhc","ca","item",$j,deptDr)) q:deptDr=""  d
	.i $D(^DHCCAUNITDEPTS(deptDr)) d
	..s DeptName=$P(^DHCCAUNITDEPTS(deptDr),"^",2)
	..s ItemDr="" 
	..f  s ItemDr=$O(^TMP("dhc","ca","item",$j,deptDr,ItemDr)) q:ItemDr=""  d
	...i ItemDr=-1 d
	....s ItemName="科室人数"
	...e  d
	....i $D(^DHCCAALLDATAITEMS(ItemDr)) d
	.....s ItemName=$P(^DHCCAALLDATAITEMS(ItemDr),"^",3)
	....e  d
	.....s ItemName="未知项目"
	...s ItemValue=^TMP("dhc","ca","item",$j,deptDr,ItemDr)
	...i (DeptName'="") d
	....s obj = ##class(dhc.ca.cache.report.ClinDeptWLD).%New()
	....s obj.DeptName=DeptName
	....s obj.ItemName=ItemName
	....s obj.ItemValue=$fn(ItemValue,"",2)
	....d obj.%Save()
}

}
