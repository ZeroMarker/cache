/// Creator: 王赢赢
/// CreatDate: 2009-12-16
/// Description: 科室直接成本汇总
Class dhc.ca.cache.udata.uDeptsDirectCostsReport Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-12-16
/// Description: 生成临时global
/// Table：
/// Input: monthDr:月份, deptSetDr:科室分层套, itemSetDr:数据分层套
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.uDeptsDirectCostsReport).genTmp(2,1,3)
ClassMethod genTmp(monthDr, deptSetDr, itemSetDr) As %String
{
	s job=$j
	k ^tmpDeptItem(job,"DirectCost")
	//生成结构
	d ..nextDeptLevel(job, deptSetDr, itemSetDr)
	
	//遍历^DHCCAVOUCHDATAS,把匹配的加到^tmpDeptItem上
	s tmpVouchid=0
	f  q:tmpVouchid=""  d
	.s tmpVouchid=$o(^DHCCAVOUCHDATAS(tmpVouchid))
	.i tmpVouchid'="" d
	..s tmpMonth=$p(^DHCCAVOUCHDATAS(tmpVouchid),"^",1)
	..s tmpDept=$p(^DHCCAVOUCHDATAS(tmpVouchid),"^",2)
	..s tmpItem=$p(^DHCCAVOUCHDATAS(tmpVouchid),"^",3)
	..s tmpMoney=$p(^DHCCAVOUCHDATAS(tmpVouchid),"^",16)
	..i tmpMonth=monthDr d
	...s ith=0
	...f  q:ith=""  d
	....s ith=$o(^tmpDeptItem(job,"DirectCost",ith))
	....i ith'="" d
	.....s jth=0
	.....f  q:jth=""  d
	......s jth=$o(^tmpDeptItem(job,"DirectCost",ith,jth))
	......i jth'="" d 
	.......i $p(^tmpDeptItem(job,"DirectCost",ith,jth),"^",1)=tmpDept d
	........i $p(^tmpDeptItem(job,"DirectCost",ith,jth),"^",2)=tmpItem d
	.........s tm=$p(^tmpDeptItem(job,"DirectCost",ith,jth),"^",3)
	.........s tm=tm+tmpMoney
	.........s ^tmpDeptItem(job,"DirectCost",ith,jth)=tmpDept_"^"_tmpItem_"^"_tm
	.........d ..sumPar(job,ith, jth, tmpMoney)
	q job
}

/// Others: w ##class(dhc.ca.cache.udata.uDeptsDirectCostsReport).sumPar(1332,"0||39||40^2","0||3||4^5",11)
ClassMethod sumPar(job, ith, jth, mon) As %String
{
	s iLayNum=$p(..countLayers(ith),"^",1)
	s jLayNum=$p(..countLayers(jth),"^",1)
	f  q:jLayNum=0  d
	.s tmpjth=""
	.s tmpjNum=0
	.f  q:tmpjNum=jLayNum  d
	..s tmpjNum=tmpjNum+1
	..i tmpjth'="" d
	...s tmpjth=tmpjth_"||"_$p($p(jth,"^",1),"||",tmpjNum)
	..e  d
	...s tmpjth=$p($p(jth,"^",1),"||",tmpjNum)
	.s jLayNum=jLayNum-1
	.s dept=$p(^tmpDeptItem(job,"DirectCost",ith,tmpjth),"^",1)
	.s item=$p(^tmpDeptItem(job,"DirectCost",ith,tmpjth),"^",2)
	.s money=$p(^tmpDeptItem(job,"DirectCost",ith,tmpjth),"^",3)+mon
	.s ^tmpDeptItem(job,"DirectCost",ith,tmpjth)=dept_"^"_item_"^"_money
	
	s root=0
	s root=$o(^tmpDeptItem(job,"DirectCost",root))
	s rNum=$p(..countLayers(root),"^",1)
	
	f  q:iLayNum=(rNum-1)  d
	.s tmpith=""
	.s tmpiNum=0
	.f  q:tmpiNum=iLayNum  d
	..s tmpiNum=tmpiNum+1
	..i tmpith'="" d
	...s tmpith=tmpith_"||"_$p($p(ith,"^",1),"||",tmpiNum)
	..e  d
	...s tmpith=$p($p(ith,"^",1),"||",tmpiNum)
	.s iLayNum=iLayNum-1
	.s dept=$p(^tmpDeptItem(job,"DirectCost",tmpith,0),"^",1)
	.s item=$p(^tmpDeptItem(job,"DirectCost",tmpith,0),"^",2)
	.s money=$p(^tmpDeptItem(job,"DirectCost",tmpith,0),"^",3)+mon
	.s ^tmpDeptItem(job,"DirectCost",tmpith,0)=dept_"^"_item_"^"_money
}

/// Others: w ##class(dhc.ca.cache.udata.uDeptsDirectCostsReport).nextItemLevel(39,3)
ClassMethod nextItemLevel(job, deptSetDr, itemSetDr) As %String
{
	//生成deptid
	s tmpDeptSet=$p(deptSetDr,"^",1)
	s tmpDeptDr=$p(deptSetDr,"^",2)

	s tmpDeptSetDr=0
	s curs=1
	s tDeptSetDr=0
	f  q:tmpDeptSetDr=""  d
	.s tmpDeptSetDr=$p(tmpDeptSet,"||",curs)
	.i tmpDeptSetDr'="" d
	..s tDeptSetDr=tmpDeptSetDr
	.s curs=curs+1
	s tmpDeptId=$p(^DHCCADEPTLEVELSETS(tDeptSetDr,"Depts",tmpDeptDr),"^",1)
	
	//生成itemDr(tmpItemDr)
	s tmpItemPar=itemSetDr
	s tmpItemDr=itemSetDr
	f  q:tmpItemPar=0  d
	.s tmpItemPar=$p(^DHCCADATALEVELSETS(tmpItemPar),"^",7)
	.s tmpItemDr=tmpItemPar_"||"_tmpItemDr
	
	s tmpItemSetName=$p(^DHCCADATALEVELSETS(itemSetDr),"^",2)
	s ^tmpDeptItem(job,"DirectCost",deptSetDr,tmpItemDr)=tmpDeptId_"^"_tmpItemSetName_" 合计"_"^"_0
	
	i $D(^DHCCADATALEVELSETS(itemSetDr,"Items")) d
	.s tmpNum=^DHCCADATALEVELSETS(itemSetDr,"Items",0)
	.s tmpAItem=0
	.f  q:tmpAItem=tmpNum  d
	..s tmpAItem=$o(^DHCCADATALEVELSETS(itemSetDr,"Items",tmpAItem))
	..s tmpAItemId=$p(^DHCCADATALEVELSETS(itemSetDr,"Items",tmpAItem),"^",3)
	..s ^tmpDeptItem(job,"DirectCost",deptSetDr,tmpItemDr_"^"_tmpAItem)=tmpDeptId_"^"_tmpAItemId_"^"_0
	
	//寻找nextLevel
	i $D(^DHCCADATALEVELSETS(0,"Parent",itemSetDr)) d
	.s tmpItemSetOrder=0
	.s tmpItemSetOrder=$o(^DHCCADATALEVELSETS(0,"Parent",itemSetDr,tmpItemSetOrder))
	.i $D(^DHCCADATALEVELSETS(0,"Parent",itemSetDr,tmpItemSetOrder)) d
	..s tmpSubDr=0
	..f  q:tmpSubDr=""  d
	...s tmpSubDr=$o(^DHCCADATALEVELSETS(0,"Parent",itemSetDr,tmpItemSetOrder,tmpSubDr))
	...i tmpSubDr'="" d ..nextItemLevel(job, deptSetDr,tmpSubDr)
}

/// Others: w ##class(dhc.ca.cache.udata.uDeptsDirectCostsReport).nextDeptLevel(39,3)
ClassMethod nextDeptLevel(job, deptSetDr, itemSetDr) As %String
{
	//生成deptDr(tmpDeptDr)
	s tmpDeptPar=deptSetDr
	s tmpDeptDr=deptSetDr
	f  q:tmpDeptPar=0  d
	.s tmpDeptPar=$p(^DHCCADEPTLEVELSETS(tmpDeptPar),"^",7)
	.s tmpDeptDr=tmpDeptPar_"||"_tmpDeptDr
	
	;s tmpDeptSetName=$p(^DHCCADEPTLEVELSETS(deptSetDr),"^",2)
	s ^tmpDeptItem(job,"DirectCost",tmpDeptDr,0)=deptSetDr_"^"_0_"^"_0
	
	i $D(^DHCCADEPTLEVELSETS(deptSetDr,"Depts")) d
	.s tmpNum=^DHCCADEPTLEVELSETS(deptSetDr,"Depts",0)
	.s tmpADept=0
	.f  s tmpADept=$o(^DHCCADEPTLEVELSETS(deptSetDr,"Depts",tmpADept)) q:tmpADept=""  d
	..;s tmpADept=$o(^DHCCADEPTLEVELSETS(deptSetDr,"Depts",tmpADept))
	..;w deptSetDr,",",tmpADept,!
	..s tmpADeptId=$p(^DHCCADEPTLEVELSETS(deptSetDr,"Depts",tmpADept),"^",1)
	..;s tmpADeptName=$p(^DHCCAUNITDEPTS(tmpADeptId),"^",2)
	..s ^tmpDeptItem(job,"DirectCost",tmpDeptDr_"^"_tmpADept,0)=tmpADeptId_"^"_0_"^"_0
	..d ..nextItemLevel(job, tmpDeptDr_"^"_tmpADept, itemSetDr) 
	
	//d ..nextItemLevel(tmpDeptDr, itemSetDr)
	//寻找nextLevel
	i $D(^DHCCADEPTLEVELSETS(0,"Parent",deptSetDr)) d
	.s tmpSubDr=0
	.f  q:tmpSubDr=""  d
	..s tmpSubDr=$o(^DHCCADEPTLEVELSETS(0,"Parent",deptSetDr,tmpSubDr))
	..i tmpSubDr'="" d ..nextDeptLevel(job,tmpSubDr,itemSetDr)
}

/// Others: w ##class(dhc.ca.cache.udata.uDeptsDirectCostsReport).listForTree("roo",1332)
ClassMethod listForTree(node, curJob) As %String
{
	/*
	q:node=1 "[{dept:'科室2',item:'项目2',money:0.31,uiProvider:'col',id:2,leaf:false},{dept:'科室3',item:'项目3',money:0.42,uiProvider:'col',id:3,leaf:true}]"
	q:node=2 "[{dept:'科室4',item:'项目4',money:0.53,uiProvider:'col',id:4,leaf:true}]"
	q "[{dept:'科室1',item:'项目1',money:0.06,id:1,uiProvider:'col',leaf:false}]"
	*/
	s tmpNodes=""
	i node="roo" d 
	.s fNodeId=0
	.s fNodeId=$o(^tmpDeptItem(curJob,"DirectCost",fNodeId))
	e  d
	.s subNodes=..findSubNodes(curJob,node)
	.s aNodeCur=1
	.s aNode=1
	.f  q:aNode=""  d
	..s aNode=$p(subNodes,"&",aNodeCur)
	..s aNodeCur=aNodeCur+1
	..i aNode'="" d
	...i tmpNodes'="" d
	....i ..isLeaf(aNode) d
	.....s tmpNodes=tmpNodes_","_..genLeaves(curJob,aNode)
	....e  d
	.....s tmpNodes=tmpNodes_","_..genNode(curJob,aNode)
	...e  d
	....i ..isLeaf(aNode) d
	.....s tmpNodes=..genLeaves(curJob,aNode)
	....e  d
	.....s tmpNodes=..genNode(curJob,aNode)
	
	q:node="roo" "["_..genNode(curJob,fNodeId)_"]"
	q "["_tmpNodes_"]"
}

/// Others: w ##class(dhc.ca.cache.udata.uDeptsDirectCostsReport).isLeaf("aa||bb")
ClassMethod isLeaf(nodeId) As %String
{
	s flag=$p(nodeId,"^",2)
	q:flag="" 0
	q 1
}

/// Others: w ##class(dhc.ca.cache.udata.uDeptsDirectCostsReport).findSubNodes(1332,"0||39")
ClassMethod findSubNodes(job, nodeId) As %String
{
	
	s tmpNode=nodeId
	s tmpSubNodes=""
	s oln=..countLayNum(..countLayers(nodeId))
	f  q:tmpNode=""  d
	.s tmpNode=$o(^tmpDeptItem(job,"DirectCost",tmpNode))
	.i tmpNode'="" d
	..i ..countLayNum(..countLayers(tmpNode))=(oln+1) d
	...i $p($p(tmpNode,"^",1),"||",oln)=$p(nodeId,"||",oln) d
	....i tmpSubNodes="" d
	.....s tmpSubNodes=tmpNode
	....e  d
	.....s tmpSubNodes=tmpSubNodes_"&"_tmpNode
	q tmpSubNodes
}

ClassMethod genANode(dept, item, money, id, leaf) As %String
{
	q "{dept:'"_dept_"',item:'"_item_"',money:'"_money_"',id:'"_id_"',uiProvider:'col',leaf:"_leaf_"}"
}

/// Others: w ##class(dhc.ca.cache.udata.uDeptsDirectCostsReport).countLayers("0||39")
ClassMethod countLayers(nodeId) As %String
{
	
	s t2=""
	s t2=$p(nodeId,"^",2)
	i t2'="" d
	.s t2=1
	e  d
	.s t2=0
	s tmpNum=1
	s t=1
	f  q:t=""  d
	.s t=$p(nodeId,"||",tmpNum)
	.s tmpNum=tmpNum+1
	.i t'=""
	s tn=tmpNum-2
	q tn_"^"_t2
}

ClassMethod countLayNum(cl) As %String
{
	
	s t1=$p(cl,"^",1)
	s t2=$p(cl,"^",2)
	q t1+t2
}

/// Others: w ##class(dhc.ca.cache.udata.uDeptsDirectCostsReport).genLeaves(1332,"","0||39||41^7")
ClassMethod genLeaves(job, leafNode) As %String
{
	s dept0=$p(^tmpDeptItem(job,"DirectCost",leafNode,0),"^",1)
	s item0="小计"
	s money0=$p(^tmpDeptItem(job,"DirectCost",leafNode,0),"^",3)
	s dept0=$p(^DHCCAUNITDEPTS(dept0),"^",2)

	s tmpNodes=..genANode(dept0,item0,money0,leafNode_"&"_0,"true")
	
	s secondSubId=0
	
	f  q:secondSubId=""  d
	.s secondSubId=$o(^tmpDeptItem(job,"DirectCost",leafNode,secondSubId))
	.i secondSubId'="" d
	..i ..isLeaf(secondSubId) d
	...s dept=$p(^tmpDeptItem(job,"DirectCost",leafNode,secondSubId),"^",1)
	...s item=$p(^tmpDeptItem(job,"DirectCost",leafNode,secondSubId),"^",2)
	...s money=$p(^tmpDeptItem(job,"DirectCost",leafNode,secondSubId),"^",3)
	...i money>0 d
	....s dept=$p(^DHCCAUNITDEPTS(dept),"^",2)
	....s item=$p(^DHCCAALLDATAITEMS(item),"^",3)
	....i tmpNodes="" d
	.....s tmpNodes=..genANode(dept,item,money,leafNode_"&"_secondSubId,"true")
	....e  d
	.....s tmpNodes=tmpNodes_","_..genANode(dept,item,money,leafNode_"&"_secondSubId,"true")
	q tmpNodes
}

/// Others: w ##class(dhc.ca.cache.udata.uDeptsDirectCostsReport).genNode(1332,"0||39||41")
ClassMethod genNode(job, Node) As %String
{
	
	s dept=$p(^tmpDeptItem(job,"DirectCost",Node,0),"^",1)
	s item=$p(^tmpDeptItem(job,"DirectCost",Node,0),"^",2)
	s money=$p(^tmpDeptItem(job,"DirectCost",Node,0),"^",3)
	s dept=$p(^DHCCADEPTLEVELSETS(dept),"^",2)
	//s item=$p(^DHCCADATALEVELSETS(item),"^",2)
	s item="合计"
	q ..genANode(dept,item,money,Node,"false")
}

Storage Default
{
<Data name="uDeptsDirectCostsReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uDeptsDirectCostsRepoD</DataLocation>
<DefaultData>uDeptsDirectCostsReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uDeptsDirectCostsRepoD</IdLocation>
<IndexLocation>^dhc.ca.c.uDeptsDirectCostsRepoI</IndexLocation>
<StreamLocation>^dhc.ca.c.uDeptsDirectCostsRepoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
