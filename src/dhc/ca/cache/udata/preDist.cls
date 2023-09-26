/// Creator: 杨旭
/// CreatDate: 2010-8-11
/// Description: 报表数据准备
Class dhc.ca.cache.udata.preDist Extends (%SerialObject, %Populate, %XML.Adaptor) [ ClassType = serial, Inheritance = right, Not ProcedureBlock ]
{

/// Creator：杨旭
/// CreatDate：2010-8-11
/// Description: 生成科室成本分摊表
/// Table：DeptCostDetial
/// Input：MonthDr-月份; CostSetsDr-成本分摊套D
/// Output：
/// Return：返回 SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.preDist).CreateDetialData(43,1)
ClassMethod CreateDetialData(MonthDr, CostSetsDr) As %String
{
	
	n (MonthDr, CostSetsDr)
	
	
	TSTART
	s flag=0
	s sqlStr="select * from dhc_ca_cache_data.CostResultData where %ID>0 and CostResultData_intervalDr="_MonthDr_" and CostResultData_parRef="_CostSetsDr_" and CostResultData_distFlag='dist' group by CostResultData_distDeptDr"

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		k PLIST
		
		s distDeptDr=result.Data("CostResultData_distDeptDr") //被分摊科室
		s primeCost=0              //直接成本
		s tmpPrimeCost=0 
		s tmpPrimeCost=##class(dhc.ca.cache.udata.uCostResultData).GetDeptTotal(MonthDr,CostSetsDr,distDeptDr)
		i tmpPrimeCost'=0 s primeCost=$p(tmpPrimeCost,"^",1)
		s setsCost1=0              //科室分层第一1层分摊成本 PS:其中参数1为节点ID
		s setsCost1=..TotalDeptByNode(MonthDr, CostSetsDr,1,distDeptDr)
		s setsCost2=0              //科室分层第一2层分摊成本 PS:其中参数1为节点ID
		s setsCost2=..TotalDeptByNode(MonthDr, CostSetsDr,1,distDeptDr)
		s setsCost3=0              //科室分层第一3层分摊成本 PS:其中参数1为节点ID
		s setsCost3=..TotalDeptByNode(MonthDr, CostSetsDr,1,distDeptDr)
		s setsCost4=0              //科室分层第一4层分摊成本 PS:其中参数1为节点ID
		s setsCost4=..TotalDeptByNode(MonthDr, CostSetsDr,1,distDeptDr)
		s setsCost5=0              //科室分层第一5层分摊成本 PS:其中参数1为节点ID
		s setsCost5=..TotalDeptByNode(MonthDr, CostSetsDr,1,distDeptDr)
		s setsCost6=0              //科室分层第一6层分摊成本 PS:其中参数1为节点ID
		s setsCost6=..TotalDeptByNode(MonthDr, CostSetsDr,1,distDeptDr)
		s setsCost7=0              //科室分层第一7层分摊成本 PS:其中参数1为节点ID
		s setsCost7=..TotalDeptByNode(MonthDr, CostSetsDr,1,distDeptDr) 
		s setsCost8=0              //科室分层第一8层分摊成本 PS:其中参数1为节点ID
		s setsCost8=..TotalDeptByNode(MonthDr, CostSetsDr,1,distDeptDr)
		
		s setsItem1=0              //项目分层 PS:其中参数1为节点ID
		s setsItem1=..TotalItemByNode(MonthDr, CostSetsDr,1,distDeptDr)
		s setsItem2=0              //项目分层 PS:其中参数2为节点ID
		s setsItem2=..TotalItemByNode(MonthDr, CostSetsDr,2,distDeptDr)
		s setsItem3=0              //项目分层 PS:其中参数3为节点ID
		s setsItem3=..TotalItemByNode(MonthDr, CostSetsDr,3,distDeptDr)
		s setsItem4=0              //项目分层 PS:其中参数4为节点ID
		s setsItem4=..TotalItemByNode(MonthDr, CostSetsDr,4,distDeptDr)
		s setsItem5=0              //项目分层 PS:其中参数5为节点ID
		s setsItem5=..TotalItemByNode(MonthDr, CostSetsDr,5,distDeptDr)
		s setsItem6=0              //项目分层 PS:其中参数6为节点ID
		s setsItem6=..TotalItemByNode(MonthDr, CostSetsDr,6,distDeptDr)
		s setsItem7=0              //项目分层 PS:其中参数7为节点ID
		s setsItem7=..TotalItemByNode(MonthDr, CostSetsDr,7,distDeptDr)
		s setsItem8=0              //项目分层 PS:其中参数7为节点ID
		s setsItem8=..TotalItemByNode(MonthDr, CostSetsDr,8,distDeptDr)
		s setsItem9=0              //项目分层 PS:其中参数8为节点ID
		s setsItem9=..TotalItemByNode(MonthDr, CostSetsDr,9,distDeptDr)
		s setsItem10=0              //项目分层 PS:其中参数9为节点ID
		s setsItem10=..TotalItemByNode(MonthDr, CostSetsDr,10,distDeptDr)
		s setsItem11=0              //项目分层 PS:其中参数11为节点ID
		s setsItem11=..TotalItemByNode(MonthDr, CostSetsDr,11,distDeptDr)
		
		S PLIST(0)=CostSetsDr
		s PLIST(3)=MonthDr
		s PLIST(4)=distDeptDr
		s PLIST(6)=primeCost
		s PLIST(7)=setsCost1
		s PLIST(8)=setsCost2
		s PLIST(9)=setsCost3
		s PLIST(10)=setsCost4
		s PLIST(11)=setsCost5 
		s PLIST(12)=setsCost6
		s PLIST(13)=setsCost7
		s PLIST(14)=setsCost8
		s PLIST(15)=setsItem1
		s PLIST(16)=setsItem2 
		s PLIST(17)=setsItem3
		s PLIST(18)=setsItem4
		s PLIST(19)=setsItem5
		s PLIST(20)=setsItem6
		s PLIST(21)=setsItem7 
		s PLIST(22)=setsItem8
		s PLIST(23)=setsItem9
		s PLIST(24)=setsItem10
		s PLIST(25)=setsItem11
		
		&SQL(INSERT INTO dhc_ca_cache_data.DeptCostDetial VALUES PLIST())
		i SQLCODE'=0 s flag=SQLCODE
	}
	i flag=0 TCOMMIT
	e  TROLLBACK
	d result.Close()
	q flag
}

/// Creator：杨旭
/// CreatDate：2010-8-11
/// Description: 生成科室成本分摊表-项目
/// Table：DeptCostItem
/// Input：MonthDr-月份; CostSetsDr-成本分摊套DR;
/// Output：
/// Return：返回 SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.preDist).CreateItemData(5,1)
ClassMethod CreateItemData(MonthDr, CostSetsDr) As %String
{
	
	n (MonthDr, CostSetsDr)
	
	
	TSTART
	s flag=0
	s sqlStr="select * from dhc_ca_cache_data.CostResultData where %ID>0 and CostResultData_intervalDr="_MonthDr_" and CostResultData_parRef="_CostSetsDr_"  group by CostResultData_distDeptDr,CostResultData_itemDr"

	s result=##class(%Library.ResultSet).%New()
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		k PLIST
		
		s distDeptDr=result.Data("CostResultData_distDeptDr") //被分摊科室
		s itemDr=result.Data("CostResultData_itemDr") //被分摊科室
		s primeCost=0              //直接成本
		s primeCost=..TotalDeptItem(MonthDr,CostSetsDr,itemDr,distDeptDr)
		s setsCost1=0              //科室分层第一1层分摊成本 PS:其中参数1为节点ID
		s setsCost1=..TotalDeptItemByNode(MonthDr, CostSetsDr,3,itemDr,distDeptDr)
		s setsCost2=0              //科室分层第一2层分摊成本 PS:其中参数2为节点ID
		s setsCost2=..TotalDeptItemByNode(MonthDr, CostSetsDr,4,itemDr,distDeptDr)
		s setsCost3=0              //科室分层第一3层分摊成本 PS:其中参数3为节点ID
		s setsCost3=..TotalDeptItemByNode(MonthDr, CostSetsDr,5,itemDr,distDeptDr)
		s setsCost4=0              //科室分层第一4层分摊成本 PS:其中参数4为节点ID
		s setsCost4=..TotalDeptItemByNode(MonthDr, CostSetsDr,6,itemDr,distDeptDr)
		s setsCost5=0              //科室分层第一5层分摊成本 PS:其中参数5为节点ID
		s setsCost5=..TotalDeptItemByNode(MonthDr, CostSetsDr,7,itemDr,distDeptDr)
		s setsCost6=0              //科室分层第一6层分摊成本 PS:其中参数6为节点ID
		;s setsCost6=..TotalDeptItemByNode(MonthDr, CostSetsDr,6,itemDr,distDeptDr)
		s setsCost7=0              //科室分层第一7层分摊成本 PS:其中参数7为节点ID
		;s setsCost7=..TotalDeptItemByNode(MonthDr, CostSetsDr,7,itemDr,distDeptDr) 
		s setsCost8=0              //科室分层第一8层分摊成本 PS:其中参数8为节点ID
		;s setsCost8=..TotalDeptItemByNode(MonthDr, CostSetsDr,8,itemDr,distDeptDr)
		
		S PLIST(0)=CostSetsDr
		s PLIST(3)=MonthDr
		s PLIST(4)=distDeptDr
		s PLIST(5)=itemDr
		s PLIST(7)=primeCost
		s PLIST(8)=setsCost1
		s PLIST(9)=setsCost2
		s PLIST(10)=setsCost3
		s PLIST(11)=setsCost4
		s PLIST(12)=setsCost5 
		s PLIST(13)=setsCost6
		s PLIST(14)=setsCost7
		s PLIST(15)=setsCost8
		s PLIST(16)=setsCost8+setsCost7+setsCost6+setsCost5+setsCost4+setsCost3+setsCost2+setsCost1+primeCost
		
		&SQL(INSERT INTO dhc_ca_cache_data.DeptCostItem VALUES PLIST())
		i SQLCODE'=0 s flag=SQLCODE
	}
	i flag=0 TCOMMIT
	e  TROLLBACK
	d result.Close()
	q flag
}

/// Creator：杨旭
/// CreatDate：2010-8-11
/// Description: 生成科室成本分摊表-来源
/// Table：DeptCostSrc
/// Input：MonthDr-月份; CostSetsDr-成本分摊套DR
/// Output：
/// Return：返回 SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.preDist).CreateSrcData(1,1)
ClassMethod CreateSrcData(MonthDr, CostSetsDr) As %String
{
	
	n (MonthDr, CostSetsDr)
	TSTART
	s flag=0
	s sqlStr="select *,sum(CostResultData_fee) as amount from dhc_ca_cache_data.CostResultData where %ID>0 and CostResultData_intervalDr="_MonthDr_" and CostResultData_parRef="_CostSetsDr_" and CostResultData_distFlag='dist' group by CostResultData_distDeptDr,CostResultData_distedDeptDr"

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		k PLIST
		s distDeptDr=result.Data("CostResultData_distDeptDr") //被分摊科室
		s distedDeptDr=result.Data("CostResultData_distedDeptDr") //被分摊科室
		s amount=result.Data("amount") //分摊金额
		
		S PLIST(0)=CostSetsDr
		s PLIST(3)=MonthDr
		s PLIST(4)=distDeptDr
		s PLIST(5)=amount
		s PLIST(6)=distedDeptDr
		
		&SQL(INSERT INTO dhc_ca_cache_data.DeptCostSrc VALUES PLIST())
		i SQLCODE'=0 s flag=SQLCODE
	}
	i flag=0 TCOMMIT
	e  TROLLBACK
	d result.Close()
	q flag
}

/// ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑以上为主调用函数↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
/// Creator：杨旭
/// CreatDate：2010-8-11
/// Description: 生成科室成本分摊表
/// Table：DeptCostDetial
/// Input：MonthDr-月份; CostSetsDr-成本分摊套DR; DeptDr-科室ID;
/// Output：
/// Return：返回 直接成本^间接成本^分录成本^总成本
/// Others：w ##class(dhc.ca.cache.udata.preDist).TotalDeptByNode(1,1,1,12)
ClassMethod TotalDeptByNode(MonthDr, CostSetsDr, Node, DeptDr) As %String
{
	
	n (MonthDr, CostSetsDr, Node, DeptDr)
	s distedDept=""          //被分摊科室
	s distedDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(Node)
	q:distedDept="" 0
	s distedDept=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(distedDept)
	
	s sqlStr=" SELECT * FROM dhc_ca_cache_data.CostResultData where CostResultData_distedDeptDr in("_distedDept_") and CostResultData_distDeptDr="_DeptDr_" and CostResultData_intervalDr="_MonthDr_" and CostResultData_parRef="_CostSetsDr_" and CostResultData_distFlag='dist'"
	;q sqlStr
	s amount=0
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		s amount=amount+result.Data("CostResultData_fee")
	}

	d result.Close()
	q amount
}

/// Creator：杨旭
/// CreatDate：2010-8-11
/// Description: 生成科室项目成本分摊表
/// Table：DeptCostDetial
/// Input：MonthDr-月份; CostSetsDr-成本分摊套DR; DeptDr-科室ID;
/// Output：
/// Return：返回 直接成本^间接成本^分录成本^总成本
/// Others：w ##class(dhc.ca.cache.udata.preDist).TotalItemByNode(1,1,5,12)
ClassMethod TotalItemByNode(MonthDr, CostSetsDr, Node, DeptDr) As %String
{
	
	n (MonthDr, CostSetsDr, Node, DeptDr)
	s items=""          //被分摊科室
	s items = ..GetCurrentLayerItems(Node)
	q:items="" 0
	s items=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(items)
	
	s sqlStr=" SELECT * FROM dhc_ca_cache_data.CostResultData where CostResultData_itemDr in("_items_") and CostResultData_distDeptDr="_DeptDr_" and CostResultData_intervalDr="_MonthDr_" and CostResultData_parRef="_CostSetsDr_" and CostResultData_distFlag='dist'"
	;q sqlStr
	s amount=0
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		s amount=amount+result.Data("CostResultData_fee")
	}

	d result.Close()
	q amount
}

/// Creator：杨旭
/// CreatDate：2010-8-11
/// Description: 生成科室项目直接成本
/// Table：DeptCostDetial
/// Input：MonthDr-月份; CostSetsDr-成本分摊套DR; DeptDr-科室ID;
/// Output：
/// Return：返回科室项目直接成本
/// Others：w ##class(dhc.ca.cache.udata.preDist).TotalDeptItem(1,1,1,12)
ClassMethod TotalDeptItem(MonthDr, CostSetsDr, ItemDr, DeptDr) As %String
{
	
	n (MonthDr, CostSetsDr, ItemDr, DeptDr)

	s sqlStr=" SELECT * FROM dhc_ca_cache_data.CostResultData where CostResultData_itemDr in("_ItemDr_") and CostResultData_distDeptDr="_DeptDr_" and CostResultData_distFlag='self' and CostResultData_intervalDr="_MonthDr_" and CostResultData_parRef="_CostSetsDr
	;q sqlStr
	s amount=0
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		s amount=amount+result.Data("CostResultData_fee")
	}

	d result.Close()
	q amount
}

/// Creator: 杨旭
/// CreatDate: 2010-08-11
/// Description: 取当前枝下的项目
/// Table: 
/// Input: branchDr
/// Output: 
/// Return: 当前枝下的科室
/// Others: w ##class(dhc.ca.cache.udata.preDist).GetBranchItems(3)
ClassMethod GetBranchItems(branchDr) As %String
{
	n (branchDr)
	
	q:branchDr="" ""
	
	s Items=""
	
	s child=0
	f  s child=$o(^DHCCADATALEVELSETS(branchDr,"Items",child)) q:child=""  d
	.s itemDr=$p(^DHCCADATALEVELSETS(branchDr,"Items",child),"^",3)
	.i Items="" s Items=itemDr
	.e  s Items=Items_","_itemDr
	q Items
}

/// Creator: 杨旭
/// CreatDate: 2010-08-11
/// Description: 取枝条下的有效枝条
/// Table: 
/// Input: branchDr
/// Output: 
/// Return: 枝条下的有效枝条
/// Others: w ##class(dhc.ca.cache.udata.preDist).GetBranchs(3)
ClassMethod GetBranchs(branchDr) As %String
{
	n (branchDr)
	
	q:branchDr="" ""
	
	s branchs=""
	f i=1:1:$l(branchDr,"^") d
	.s bDr=$p(branchDr,"^",i)
	.s order=""
	.f  s order=$o(^DHCCADATALEVELSETS(0,"Parent",bDr,order)) q:order=""  d
	..s rowid=0
	..f  s rowid=$o(^DHCCADATALEVELSETS(0,"Parent",bDr,order,rowid)) q:rowid=""  d
	...i $d(^DHCCADATALEVELSETS(rowid)) d
	....s active=$p(^DHCCADATALEVELSETS(rowid),"^",6)
	....i active="Y" d
	.....i branchs="" s branchs=rowid
	.....e  s branchs=branchs_"^"_rowid
	
	s branchs1=..GetBranchs(branchs)
	i branchs1'="" s branchs=branchs_"^"_branchs1
	
	q branchs
}

/// Creator：杨旭
/// CreatDate：2010-8-11
/// Description: 生成科室成本分摊表
/// Table：DeptCostDetial
/// Input：MonthDr-月份; CostSetsDr-成本分摊套DR; DeptDr-科室ID;
/// Output：
/// Return：返回 直接成本^间接成本^分录成本^总成本
/// Others：w ##class(dhc.ca.cache.udata.preDist).TotalDeptByNode(1,1,1,12)
ClassMethod TotalDeptItemByNode(MonthDr, CostSetsDr, Node, ItemDr, DeptDr) As %String
{
	
	n (MonthDr, CostSetsDr, Node, ItemDr, DeptDr)
	s distedDept=""          //被分摊科室
	s distedDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(Node)
	q:distedDept="" 0
	s distedDept=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(distedDept)
	
	s sqlStr=" SELECT * FROM dhc_ca_cache_data.CostResultData where CostResultData_distedDeptDr in("_distedDept_") and CostResultData_distDeptDr="_DeptDr_" and CostResultData_itemDr="_ItemDr_" and CostResultData_intervalDr="_MonthDr_" and CostResultData_parRef="_CostSetsDr_" and CostResultData_distFlag='dist'"
	;q sqlStr
	s amount=0
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		s amount=amount+result.Data("CostResultData_fee")
	}

	d result.Close()
	q amount
}

/// Creator: 杨旭
/// CreatDate: 2010-08-11
/// Description: 取当前层包含项目
/// Table: 
/// Input: layerDr-层ID
/// Output: 
/// Return: 当前层包含科室
/// Others: w ##class(dhc.ca.cache.udata.preDist).GetCurrentLayerItems(3)
ClassMethod GetCurrentLayerItems(layerDr) As %String
{
	n (layerDr)
	
	s depts=""
	s depts=..GetBranchItems(layerDr) //取枝条项目
	s branchs=""
	s branchs=..GetBranchs(layerDr)   //取枝条的所有项目
	i branchs'="" d
	f i=1:1:$l(branchs,"^") d         //取枝条项目
	.s branch=$p(branchs,"^",i)
	.i branch'="" d
	..s tmp=..GetBranchItems(branch)
	..i tmp'="" d
	...i depts="" s depts=tmp
	...e  s depts=depts_","_tmp
	
	q depts
}

/// Creator：杨旭
/// CreatDate：2010-8-11
/// Description: 生成科室成本分摊表
/// Table：DeptCostDetial
/// Input：MonthDr-月份; CostSetsDr-成本分摊套DR; DeptDr-科室ID;
/// Output：
/// Return：返回 直接成本^间接成本^分录成本^总成本
/// Others：w ##class(dhc.ca.cache.udata.preDist).TotalDeptByNode(1,1,1,12)
ClassMethod TotalDept(MonthDr, CostSetsDr, distedDept, DeptDr) As %String
{
	n (MonthDr, CostSetsDr, distedDept, DeptDr)
	s sqlStr=" SELECT * FROM dhc_ca_cache_data.CostResultData where CostResultData_distedDeptDr in("_distedDept_") and CostResultData_distDeptDr="_DeptDr_" and CostResultData_intervalDr="_MonthDr_" and CostResultData_parRef="_CostSetsDr_" and CostResultData_distFlag='dist'"
	;q sqlStr
	s amount=0
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		s amount=amount+result.Data("CostResultData_fee")
	}

	d result.Close()
	q amount
}

Storage Default
{
<StreamLocation>^dhc.ca.c.preDistS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
