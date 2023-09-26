/// Creator: wang ying
/// CreatDate: 2009-12-17
/// Description: 开单-指向科室报表维护
Class dhc.ca.cache.udata.uComReport Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2009-12-17
/// Description: 用递归算法查找,搭基本的架构
/// Table: dhc.ca.cache.data.AccountMonths
/// Input: deptSetDr-科室分层套dr
/// Output: 
/// Return: 
/// Others:w ##class(dhc.ca.cache.udata.uComReport).fun(1,"",1)
ClassMethod fun(deptSetDr, count, monthDr)
{
    
    i count ="" d
    .S count = ##class(dhc.ca.cache.udata.uCount).%New()
    .s count.num=0
	s tmpDeptDr=deptSetDr //科室分层套
	;w "tmpDeptDr="_tmpDeptDr,!
	s tmp=count.num
	s tmpDeptSetName=$p(^DHCCADEPTLEVELSETS(deptSetDr),"^",2)
	s deptPar=$p(^DHCCADEPTLEVELSETS(deptSetDr),"^",7)
	//顶层临时global的结构
	s ^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,deptSetDr,$J,tmp)=tmpDeptSetName_"^"_"合计"_"^"_0_"^"_0
	;w ^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,deptSetDr,$J,tmp),!
	//找出末端科室id
	i $D(^DHCCADEPTLEVELSETS(deptSetDr,"Depts")) d
	.s tmpNum=^DHCCADEPTLEVELSETS(deptSetDr,"Depts",0)
	.s tmpADept=0
	.f  s tmpADept=$o(^DHCCADEPTLEVELSETS(deptSetDr,"Depts",tmpADept)) q:tmpADept=""  d
	..
	..;w "tmpADept="_tmpADept,!
	..;w "deptSetDr="_deptSetDr_",tmpADept="_tmpADept,!
	..i $d(^DHCCADEPTLEVELSETS(deptSetDr,"Depts",tmpADept))  d
	...s tmpADeptId=$p(^DHCCADEPTLEVELSETS(deptSetDr,"Depts",tmpADept),"^",1) ///////////////
	...i $d(^DHCCAUNITDEPTS(tmpADeptId)) d
	....s tmpADeptName=$p(^DHCCAUNITDEPTS(tmpADeptId),"^",2)
	....d ..Ftemp(monthDr,tmpADeptId)
	....s count.num=count.num+1
	....s tmp=count.num
	....s cost=0
	....;s ^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,0,$j,tmp)=tmpADeptName_" 合计"_"^"_0_"^"_0_"^"_0
	....s sum=-1
	....f  s sum=$o(^tmp(0,"dhc","ca","deptIncom",tmpADeptId,sum)) q:sum=""  d
	.....s temp=^tmp(0,"dhc","ca","deptIncom",tmpADeptId,sum)
	.....s ^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId,$j,tmp)=tmpADeptName_"^"_$p(temp,"^",2)_"^"_$p(temp,"^",3)_"^"_$p(temp,"^",4)
	.....s count.num=count.num+1
	.....s tmp=count.num
	.....s cost=cost+$p(temp,"^",4)
	....s ^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,0,$j,tmp)=tmpADeptName_"^"_"合计"_"^"_0_"^"_cost
	
	//递归
    if $D(^DHCCADEPTLEVELSETS(0,"Parent",deptSetDr)) d
	.s tmpSubDr=0
	.f  q:tmpSubDr=""  d
	..s tmpSubDr=$o(^DHCCADEPTLEVELSETS(0,"Parent",deptSetDr,tmpSubDr))
	..;w "deptSetDr"_deptSetDr_",tmpSubDr="_tmpSubDr,!
	..s count.num=count.num+1
	..s tmp=count.num
	..i tmpSubDr'=""  d 
	...d ..fun(tmpSubDr,count,monthDr)
}

/// Creator: wang ying
/// CreatDate: 2009-12-21
/// Description: 取符合条件的数据
/// Table: dhc.ca.cache.data.AccountMonths
/// Input: deptSetDr-开单科室dr，monthDr-月份dr，cost-金额
/// Output: 
/// Return: 
/// Others:d ##class(dhc.ca.cache.udata.uComReport).Ftemp(2,4)
ClassMethod Ftemp(monthDr, deptSetDr)
{
	s deptSetDr=$G(deptSetDr)
	s monthDr=$G(monthDr)
	s sum=0
	s incomeDr=""
	f  s incomeDr=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",monthDr,deptSetDr,incomeDr)) q:incomeDr=""  d
	.s itemDr=$p(^DHCCAINCOMEDATAS(incomeDr),"^",6)
	.s itemName=$p(^DHCCAALLDATAITEMS(itemDr),"^",3)
	.s incomeCost=$p(^DHCCAINCOMEDATAS(incomeDr),"^",7)
	.s fdeptName=$p(^DHCCAUNITDEPTS(deptSetDr),"^",2)
	.s tdeptDr=$p(^DHCCAINCOMEDATAS(incomeDr),"^",14)
	.s tdeptName=""
	.i tdeptDr'=""  d
	..i $d(^DHCCAUNITDEPTS(tdeptDr)) d
	...s tdeptName=$p(^DHCCAUNITDEPTS(tdeptDr),"^",2)
	.if ($D(^tmp(0,"dhc","ca","deptIncom",deptSetDr))) d
	.s count=0
	.s flag=0
	.f  s count=$o(^tmp(0,"dhc","ca","deptIncom",deptSetDr,count)) q:(count="")||(flag=1)  d
	..if itemName=$p(^tmp(0,"dhc","ca","deptIncom",deptSetDr,count),"^",2) d
	...s flag=1
	.if flag=0 d
	..s ^tmp(0,"dhc","ca","deptIncom",deptSetDr,sum)=fdeptName_"^"_itemName_"^"_"小计"_"^"_0
	..s sum=sum+1
	.s ^tmp(0,"dhc","ca","deptIncom",deptSetDr,sum)=fdeptName_"^"_itemName_"^"_tdeptName_"^"_incomeCost
	.s sum=sum+1
}

//w ##class(dhc.ca.cache.udata.uComReport).Ftemptest(1,"",2)

ClassMethod Ftemptest(deptSetDr, count, monthDr)
{
	k ^tmpDeptItem(0,"dhc","ca","deptIncom")
	k ^tmp(0,"dhc","ca","deptIncom")
	d ..fun(deptSetDr,count,monthDr)
	d ..totalTmp()
	d ..totalTmpDeptItem(0)
	s job=$j
	q job
}

/// Creator: wang ying
/// CreatDate: 2009-12-24
/// Description: 根据生成的小计的global汇总
/// Table: dhc.ca.cache.data.AccountMonths
/// Input: deptSetDr-开单科室dr，monthDr-月份dr，cost-金额
/// Output: 
/// Return: 
/// Others:d ##class(dhc.ca.cache.udata.uComReport).totalTmp()
ClassMethod totalTmp()
{
	//^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId,$j,tmp)
	s deptSetDr=""
	f  s deptSetDr=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr)) q:deptSetDr=""  d
	.s tmpADeptId=""
	.f  s tmpADeptId=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId)) q:tmpADeptId=""  d
	..s sum=""
	..s totalSum=0
	..f  s sum=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId,$j,sum))  q:sum=""  d
	...s tmpDeptName=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId,$j,sum),"^",1)
	...s tmpItemName=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId,$j,sum),"^",2)
	...s totalFile=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId,$j,sum),"^",3)
	...s totalCost=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId,$j,sum),"^",4)
	...if totalFile="小计" d
	....;w "tmpDeptName="_tmpDeptName_"sum="_sum,!
	....s totalSum=0
	....f  s totalSum=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId,$j,totalSum)) q:totalSum=""  d
	.....s tmpFile=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId,$j,totalSum),"^",3)
	.....if tmpFile'="小计"  d
	......s deptName=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId,$j,totalSum),"^",1)
	......s itemName=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId,$j,totalSum),"^",2)
	......if (tmpDeptName=deptName)&&(tmpItemName=itemName) d
	.......s cost=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId,$j,totalSum),"^",4)
	.......s totalCost=cost+totalCost
	.......s ^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId,$j,sum)=tmpDeptName_"^"_tmpItemName_"^"_"小计"_"^"_totalCost
}

//d ##class(dhc.ca.cache.udata.uComReport).totalTmpDeptItem()

ClassMethod totalTmpDeptItem(dept)
{
	//^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,deptSetDr,$J,tmp)=tmpDeptSetName_"^"_"合计1"_"^"_0_"^"_0
	//^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,tmpADeptId,$j,tmp)
	//^tmpDeptItem(0,"dhc","ca","deptIncom",deptSetDr,0,$j,tmp)
	
	s flag=""
	s totalFlag=""
	s deptPar=""
	f  s deptPar=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar)) q:deptPar=""  d
	.s sum=""
	.f  s sum=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,0,$j,sum))  q:sum=""  d
	..s itmeName=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,0,$j,sum),"^",2)
	..if itmeName="合计" d
	...s total=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,0,$j,sum),"^",4)
	...d ..DeptPar(deptPar,total)
}

//d ##class(dhc.ca.cache.udata.uComReport).DeptPar(6,0)

ClassMethod DeptPar(deptPar, total)
{
 s tmpDeptPar=""
 f  s tmpDeptPar=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",tmpDeptPar)) q:tmpDeptPar=""  d
 .s sum1=""
 .f  s sum1=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",tmpDeptPar,deptPar,$j,sum1))  q:sum1=""  d
 ..s tmpItem=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",tmpDeptPar,deptPar,$j,sum1),"^",2) 
 ..if (tmpItem="合计") d
 ...s amont=total+$p(^tmpDeptItem(0,"dhc","ca","deptIncom",tmpDeptPar,deptPar,$j,sum1),"^",4)
 ...s tdeptName=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",tmpDeptPar,deptPar,$j,sum1),"^",1)
 ...s ^tmpDeptItem(0,"dhc","ca","deptIncom",tmpDeptPar,deptPar,$j,sum1)=tdeptName_"^"_"合计"_"^"_0_"^"_amont
 ...if (tmpDeptPar'=0) d
 ....d ..DeptPar(tmpDeptPar,total)
}

//d ##class(dhc.ca.cache.udata.uComReport).listTree("roo",3832)

ClassMethod listTree(node, job) As %String
{
  s tmpNode=""
  if node="roo" d
  .s fNodeId=0
  .s fNodeId=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",0,fNodeId))
  else  d
  .s subNode=..findSubNode(node,job)
  .if subNode'="" d
  ..s count=$l(subNode,",")
  ..s num=1
  ..f  q:num>count  d
  ...s tmpSubNode=$p(subNode,",",num)
  ...s node1=$p(tmpSubNode,"&",1)
  ...s node2=$p(tmpSubNode,"&",2)
  ...s node3=$p(tmpSubNode,"&",3) 
  ...;w "node2="_node2_"node3="_node3,!
  ...s num=num+1
  ...s fdept=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",node1,node2,job,node3),"^",1)
  ...s item=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",node1,node2,job,node3),"^",2)
  ...s tdept=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",node1,node2,job,node3),"^",3)
  ...s money=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",node1,node2,job,node3),"^",4)
  ...;w "item="_item_"fdept="_fdept,!
  ...;w tmpNode,!
  ...if item'="合计" d
  ....if tmpNode="" d
  .....s tmpNode=..genANode(fdept,item,tdept,money,node1_"&"_node2_"&"_node3,"true")
  ....else  d
  .....s tmpNode=tmpNode_","_..genANode(fdept,item,tdept,money,node1_"&"_node2_"&"_node3,"true")
  ...if item="合计" d
  ....if tmpNode="" d
  .....s tmpNode=..genANode(fdept,item,tdept,money,node1_"&"_node2_"&"_node3,"false")
  ....else  d
  .....;w "tmpNode="_tmpNode,!
  .....s tmpNode=tmpNode_","_..genANode(fdept,item,tdept,money,node1_"&"_node2_"&"_node3,"false")
  q:node="roo" "["_..genNode(job,fNodeId)_"]"
  q:subNode'="" "["_tmpNode_"]"
}

//d ##class(dhc.ca.cache.udata.uComReport).findSubNode("1&6",3832)

ClassMethod findSubNode(node, job)
{
  s tmpnode=""
  s depttmp=""
  s deptPar=""
  s node1=$p(node,"&",1)
  s node2=$p(node,"&",2)
  s node3=$p(node,"&",3)
  s deptName=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",node1,node2,job,node3),"^",1)
  if node2=0 d
  .s tmpdept=""
  .f  s tmpdept=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",node1,tmpdept)) q:tmpdept=""  d
  ..if tmpdept'=0 d
  ...s sum=""
  ...f  s sum=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",node1,tmpdept,job,sum))  q:sum=""  d
  ....s item=$P(^tmpDeptItem(0,"dhc","ca","deptIncom",node1,tmpdept,job,sum),"^",2)
  ....s tmpDeptName=$P(^tmpDeptItem(0,"dhc","ca","deptIncom",node1,tmpdept,job,sum),"^",1)
  ....if (item'="合计")&&(tmpDeptName=deptName) d
  .....if tmpnode="" d
  ......s tmpnode=node1_"&"_tmpdept_"&"_sum
  .....else  d
  ......s tmpnode=tmpnode_","_node1_"&"_tmpdept_"&"_sum
  else  d
  .f  s deptPar=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar)) q:deptPar=""  d
  ..if deptPar=node2 d
  ...s dept=""
  ...f  s dept=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,dept)) q:dept=""  d
  ....s num=""
  ....f  s num=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,dept,job,num))  q:num=""  d
  .....s item=$P(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,dept,job,num),"^",2)
  .....if item="合计" d
  ......if tmpnode=""  d
  .......s tmpnode=deptPar_"&"_dept_"&"_num
  ......else  d
  .......s tmpnode=tmpnode_","_deptPar_"&"_dept_"&"_num
  q tmpnode
}

ClassMethod genANode(fdept, item, tdept, money, id, leaf) As %String
{
	q "{fdept:'"_fdept_"',item:'"_item_"',tdept:'"_tdept_"',money:'"_money_"',id:'"_id_"',uiProvider:'col',leaf:"_leaf_"}"
}

ClassMethod genNode(job, Node) As %String
{
	
	s sum=""
	f  s sum=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",0,Node,job,sum)) q:sum=""  d
	.s fdept=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",0,Node,job,sum),"^",1)
	.s item=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",0,Node,job,sum),"^",2)
	.s tdept=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",0,Node,job,sum),"^",3)
	.s money=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",0,Node,job,sum),"^",4)
	q ..genANode(fdept,item,tdept,money,0_"&"_Node_"&"_0,"false")
}

}
