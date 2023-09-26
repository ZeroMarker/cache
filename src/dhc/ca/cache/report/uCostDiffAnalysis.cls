/// Creator: 王赢赢
/// CreatDate: 2009-2-8
/// Description: 成本差异分析
Class dhc.ca.cache.report.uCostDiffAnalysis Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

//ClassMethod genCostDiffAnalysis(ByRef qHandle As %Binary, costDistSetDr, dataSetDr, months, doiDr) As %String

/// Creator: 王赢赢
/// CreatDate: 2009-2-2
/// Description: 
/// Table：DeptLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uCostDiffAnalysis).ListCostResultExecute("",1,"","1,2,3","",880,879)
ClassMethod ListCostResultExecute(ByRef qHandle As %Binary, costDistSetDr, dataSetDr, months, doiDr, itemDr, itemDr2, doi) As %Status
{
 n (qHandle,costDistSetDr,dataSetDr,months,doiDr,itemDr,itemDr2,doi)
 s start = $ZH 
 
 s deptSetDr = $p(^DHCCACOSTDISTSETS(costDistSetDr),"^",5)
 Set repid=$I(^CacheTemp1)
 Set ind=1
 k ^tmpdhccadeptleveltree
 k ^tmpdhccadataleveltree
 s tmpRRNum=1
 f  s tmpDMon=$p(months,",",tmpRRNum) q:tmpDMon=""  d
 .s tmpRRNum=tmpRRNum+1
 .i dataSetDr="" d
 ..d ##class(dhc.ca.cache.udata.uReportResult).Delete("cbcyfxb",tmpDMon,costDistSetDr,-1)
 .e  d
 ..d ##class(dhc.ca.cache.udata.uReportResult).Delete("cbcyfxb",tmpDMon,costDistSetDr,dataSetDr)
 d ##class(dhc.ca.cache.report.costDiffAnalysis).%DeleteExtent()
 s deptCountNum = ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptlevelSetSortedTree(deptSetDr,0)
 d ..AddDeptOneLevelLeaf(deptSetDr)
 d ..addDeptNum()
 d ..addDeptActive()
 i ((dataSetDr'="")&&(doi="dept"))||((doiDr="")&&(doi="item")) d //////////////change
 .s dataCountNum = ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getDatalevelSetSortedTree(dataSetDr,0)
 .d ..AddDataOneLevelLeaf(dataSetDr)
 .d ..addItemNum()
 .d ..addItemActive()
 .set ind= ..addDeptOrItemZero("item",months, repid, ind,costDistSetDr,dataSetDr)
 e  d
 .set ind= ..addDeptOrItemZero("dept",months, repid, ind,costDistSetDr,dataSetDr)
 
 s tmpNum=1
 f  s tmpMon=$p(months,",",tmpNum) q:tmpMon=""  d
 .s tmpNum=tmpNum+1
 .s tmpSubid=""
 .f  s tmpSubid=$o(^DHCCACOSTDISTSETS(0,"DInterval",costDistSetDr,tmpMon,tmpSubid)) q:tmpSubid=""  d
 ..s tmpCostDist=^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",tmpSubid)
 ..s tmpDeptDr=$p(tmpCostDist,"^",3)
 ..s tmpItemDr=$p(tmpCostDist,"^",4)
 ..s tmpMoney=$p(tmpCostDist,"^",5)
 ..;s tmpItemFlag=1
 ..;s tmpDeptFlag=1
 ..;i doiDr'="" d
 ..;.i dataSetDr'="" d
 ..;..i tmpDeptDr'=doiDr d
 ..;...s tmpItemFlag=0
 ..;.e  d
 ..;..i tmpItemDr'=doiDr d
 ..;...s tmpDeptFlag=0
 ..s flag=1
 ..i (doiDr'="")&&(doi="dept")&&(tmpDeptDr'=doiDr) d
 ...s flag=0
 ..e  i (doiDr'="")&&(doi="item")&&(tmpItemDr'=doiDr) d
 ...s flag=0
 ..i (((doi="item")&&(doiDr=""))||((doi="dept")&&(doiDr'="")))&&$d(^tmpdhccadataleveltree($j,"leaf",tmpItemDr))&&($p(^tmpdhccadataleveltree($j,"leaf",tmpItemDr),"||",4)="Y")&&$d(^DHCCAALLDATAITEMS(tmpItemDr))&&flag d
 ...s tmpItemName=$p(^DHCCAALLDATAITEMS(tmpItemDr),"^",3)
 ...s tmpItemTree=^tmpdhccadataleveltree($j,"leaf",tmpItemDr)
 ...s tmpItemNum=$p(tmpItemTree,"||",3)
 ...s tmpItemOrder=$p(tmpItemTree,"||",1)
 ...s ind= ..addItemPar($p(tmpItemTree,"||",2),tmpMoney,tmpMon,repid,ind,costDistSetDr,dataSetDr)
 ...s tmpCostDiffAnalysis = ##class(dhc.ca.cache.report.costDiffAnalysis).%New()
 ...s tmpCostDiffAnalysis.money=tmpMoney
 ...s tmpCostDiffAnalysis.deptName=""
 ...s tmpCostDiffAnalysis.deptNum=""
 ...s tmpCostDiffAnalysis.deptOrder=""
 ...s tmpCostDiffAnalysis.month=tmpMon
 ...s tmps=..getSpace(tmpItemNum)
 ...s tmpCostDiffAnalysis.itemName=tmps_tmpItemName
 ...s tmpCostDiffAnalysis.itemNum=tmpItemNum
 ...s tmpCostDiffAnalysis.itemOrder=tmpItemOrder
 ...s tmpCostDiffAnalysis.bedNum=0
 ...i dataSetDr="" d ///no use
 ....s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","cbcyfxb",tmpMon,costDistSetDr,-1,-1,"leaf_"_tmpItemDr,"")) ///no use
 ...e  d
 ....s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","cbcyfxb",tmpMon,costDistSetDr,dataSetDr,-1,"leaf_"_tmpItemDr,""))
 ...s $p(^DHCCAREPORTRESULT(tmpRRid),"^",5)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",5)+tmpMoney
 ...set Data=$lb(tmpCostDiffAnalysis.money,tmpCostDiffAnalysis.deptName,tmpCostDiffAnalysis.deptNum,tmpCostDiffAnalysis.deptOrder,tmpCostDiffAnalysis.month,tmpCostDiffAnalysis.itemName,tmpCostDiffAnalysis.itemNum,tmpCostDiffAnalysis.itemOrder,tmpCostDiffAnalysis.bedNum) ;按顺序对应Query的传出参数
 ...Set ^CacheTemp1(repid,ind)=Data
 ...Set ind=ind+1
 ...;s sc = tmpCostDiffAnalysis.%Save()
 ..e  i (((doi="item")&&(doiDr'=""))||((doi="dept")&&(doiDr="")))&&$d(^tmpdhccadeptleveltree($j,"leaf",tmpDeptDr))&&($p(^tmpdhccadeptleveltree($j,"leaf",tmpDeptDr),"||",4)="Y")&&$d(^DHCCAUNITDEPTS(tmpDeptDr))&&flag d
 ...s tmpDeptName=$p(^DHCCAUNITDEPTS(tmpDeptDr),"^",2)
 ...s tmpDeptTree=^tmpdhccadeptleveltree($j,"leaf",tmpDeptDr)
 ...s tmpDeptNum=$p(tmpDeptTree,"||",3)
 ...s tmpDeptOrder=$p(tmpDeptTree,"||",1)
 ...s ind= ..addDeptPar($p(tmpDeptTree,"||",2),tmpMoney,tmpMon,repid,ind,costDistSetDr,dataSetDr)
 ...s tmpCostDiffAnalysis = ##class(dhc.ca.cache.report.costDiffAnalysis).%New()
 ...s tmpCostDiffAnalysis.money=tmpMoney
 ...s tmps=..getSpace(tmpDeptNum)
 ...s tmpCostDiffAnalysis.deptName=tmps_tmpDeptName
 ...s tmpCostDiffAnalysis.deptNum=tmpDeptNum
 ...s tmpCostDiffAnalysis.deptOrder=tmpDeptOrder
 ...s tmpCostDiffAnalysis.month=tmpMon
 ...s tmpCostDiffAnalysis.itemName=""
 ...s tmpCostDiffAnalysis.itemNum=""
 ...s tmpCostDiffAnalysis.itemOrder=""
 ...s tmpCostDiffAnalysis.bedNum=0
 ...i (itemDr'="")&&$d(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",tmpMon,tmpDeptDr,itemDr)) d
 ....s tmpId=$o(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",tmpMon,tmpDeptDr,itemDr,""))
 ....s tmpBedNum=$p(^DHCCAPARAMDATAS(tmpId),"^",11)
 ....s tmpCostDiffAnalysis.bedNum=tmpBedNum
 ...i (itemDr2'="")&&$d(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",tmpMon,tmpDeptDr,itemDr2)) d
 ....s tmpId=$o(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",tmpMon,tmpDeptDr,itemDr2,""))
 ....s tmpBedNum=$p(^DHCCAPARAMDATAS(tmpId),"^",11)
 ....s tmpCostDiffAnalysis.bedNum=tmpBedNum
 ...i dataSetDr="" d
 ....s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","cbcyfxb",tmpMon,costDistSetDr,-1,"leaf_"_tmpDeptDr,-1,""))
 ...e  d
 ....s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","cbcyfxb",tmpMon,costDistSetDr,dataSetDr,"leaf_"_tmpDeptDr,-1,""))
 ...s $p(^DHCCAREPORTRESULT(tmpRRid),"^",5)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",5)+tmpMoney
 ...set Data=$lb(tmpCostDiffAnalysis.money,tmpCostDiffAnalysis.deptName,tmpCostDiffAnalysis.deptNum,tmpCostDiffAnalysis.deptOrder,tmpCostDiffAnalysis.month,tmpCostDiffAnalysis.itemName,tmpCostDiffAnalysis.itemNum,tmpCostDiffAnalysis.itemOrder,tmpCostDiffAnalysis.bedNum) ;按顺序对应Query的传出参数
 ...Set ^CacheTemp1(repid,ind)=Data
 ...Set ind=ind+1
 ...;s sc = tmpCostDiffAnalysis.%Save()
 s qHandle=$lb(0,repid,0)
 ;w repid
 s elap = $ZH - start  
 Quit $$$OK
}

/// Others: w ##class(dhc.ca.cache.report.uCostDiffAnalysis).getSpace(3)
ClassMethod getSpace(num) As %String
{
 n (num)
 s tmpSp=""
 s ser=0
 f  q:ser=num  d
 .s ser=ser+1
 .s tmpSp=tmpSp_"    "
 q tmpSp
}

/// Creator: 王赢赢
/// CreatDate: 2009-2-2
/// Description: 
/// Table：DeptLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uItemSummary).addDeptPar("itemName", 1, 1,"57^14^7^1",33)
ClassMethod addDeptPar(par, money, month, repid, ind, costDistSetDr, dataSetDr) As %String
{
 n (par, money,month,repid,ind,costDistSetDr,dataSetDr)
 s tmpNum=1
 f  s tmpPar=$p(par,"^",tmpNum) q:tmpPar=""  d
 .s tmpNum=tmpNum+1 
 .i $d(^tmpdhccadeptleveltree($j,"trunk",tmpPar)) d
 ..s tmpDept=^tmpdhccadeptleveltree($j,"trunk",tmpPar)
 ..s tmpDeptOrder=$p(tmpDept,"||",1)
 ..s tmpDeptNum=$p(tmpDept,"||",3)
 ..s tmpDeptName=$p(^DHCCADEPTLEVELSETS(tmpPar),"^",2)
 ..s tmpCostDiffAnalysis = ##class(dhc.ca.cache.report.costDiffAnalysis).%New()
 ..s tmpCostDiffAnalysis.money=money
 ..s tmps=..getSpace(tmpDeptNum)
 ..s tmpCostDiffAnalysis.deptName=tmps_tmpDeptName
 ..s tmpCostDiffAnalysis.deptNum=tmpDeptNum
 ..s tmpCostDiffAnalysis.deptOrder=tmpDeptOrder
 ..s tmpCostDiffAnalysis.month=month
 ..s tmpCostDiffAnalysis.itemName=""
 ..s tmpCostDiffAnalysis.itemNum=""
 ..s tmpCostDiffAnalysis.itemOrder=""
 ..s tmpCostDiffAnalysis.bedNum=0
 ..i dataSetDr="" d
 ...s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","cbcyfxb",month,costDistSetDr,-1,"trunk_"_tmpPar,-1,""))
 ..e  d
 ...s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","cbcyfxb",month,costDistSetDr,dataSetDr,"trunk_"_tmpPar,-1,""))
 ..s $p(^DHCCAREPORTRESULT(tmpRRid),"^",5)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",5)+money
 ..set Data=$lb(tmpCostDiffAnalysis.money,tmpCostDiffAnalysis.deptName,tmpCostDiffAnalysis.deptNum,tmpCostDiffAnalysis.deptOrder,tmpCostDiffAnalysis.month,tmpCostDiffAnalysis.itemName,tmpCostDiffAnalysis.itemNum,tmpCostDiffAnalysis.itemOrder,tmpCostDiffAnalysis.bedNum) ;按顺序对应Query的传出参数
 ..Set ^CacheTemp1(repid,ind)=Data
 ..Set ind=ind+1
 ..;s sc = tmpCostDiffAnalysis.%Save()
 q ind
}

/// Others: w ##class(dhc.ca.cache.report.uItemSummary).addItemPar("itemName", 1, 1,"3^2",33,"57^14^7^1")
ClassMethod addItemPar(par, money, month, repid, ind, costDistSetDr, dataSetDr) As %String
{
 n (par, money,month,repid,ind,costDistSetDr,dataSetDr)
 s tmpNum=1
 f  s tmpPar=$p(par,"^",tmpNum) q:tmpPar=""  d
 .s tmpNum=tmpNum+1 
 .i $d(^tmpdhccadataleveltree($j,"trunk",tmpPar)) d
 ..s tmpItem=^tmpdhccadataleveltree($j,"trunk",tmpPar)
 ..s tmpItemOrder=$p(tmpItem,"||",1)
 ..s tmpItemNum=$p(tmpItem,"||",3)
 ..s tmpItemName=$p(^DHCCADATALEVELSETS(tmpPar),"^",2)
 ..s tmpCostDiffAnalysis = ##class(dhc.ca.cache.report.costDiffAnalysis).%New()
 ..s tmpCostDiffAnalysis.money=money
 ..s tmps=..getSpace(tmpItemNum)
 ..s tmpCostDiffAnalysis.itemName=tmps_tmpItemName
 ..s tmpCostDiffAnalysis.itemNum=tmpItemNum
 ..s tmpCostDiffAnalysis.itemOrder=tmpItemOrder
 ..s tmpCostDiffAnalysis.month=month
 ..s tmpCostDiffAnalysis.deptName=""
 ..s tmpCostDiffAnalysis.deptNum=""
 ..s tmpCostDiffAnalysis.deptOrder=""
 ..s tmpCostDiffAnalysis.bedNum=0
 ..i dataSetDr="" d
 ...s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","cbcyfxb",month,costDistSetDr,-1,-1,"trunk_"_tmpPar,""))
 ..e  d
 ...s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","cbcyfxb",month,costDistSetDr,dataSetDr,-1,"trunk_"_tmpPar,""))
 ..s $p(^DHCCAREPORTRESULT(tmpRRid),"^",5)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",5)+money
 ..set Data=$lb(tmpCostDiffAnalysis.money,tmpCostDiffAnalysis.deptName,tmpCostDiffAnalysis.deptNum,tmpCostDiffAnalysis.deptOrder,tmpCostDiffAnalysis.month,tmpCostDiffAnalysis.itemName,tmpCostDiffAnalysis.itemNum,tmpCostDiffAnalysis.itemOrder,tmpCostDiffAnalysis.bedNum) ;按顺序对应Query的传出参数
 ..Set ^CacheTemp1(repid,ind)=Data
 ..Set ind=ind+1
 ..;s sc = tmpCostDiffAnalysis.%Save()
 q ind
}

/// Creator: 王赢赢
/// CreatDate: 2009-2-2
/// Description: 
/// Table：DeptLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uCostDiffAnalysis).addDeptNum()
ClassMethod addDeptNum() As %String
{
 s i=""
 f  s i=$o(^tmpdhccadeptleveltree($j,i)) q:i=""  d
 .s j=""
 .f  s j=$o(^tmpdhccadeptleveltree($j,i,j)) q:j=""  d
 ..s tmpDept=^tmpdhccadeptleveltree($j,i,j)
 ..s tmpPars=$p(tmpDept,"||",2)
 ..s num=1
 ..f  s tmpPar=$p(tmpPars,"^",num) q:tmpPar=""  d
 ...s num=num+1
 ..i i="leaf" d
 ...s num=num-2
 ..e  d
 ...s num=num-3
 ..s ^tmpdhccadeptleveltree($j,i,j)=tmpDept_"||"_num
 q "OK"
}

/// Creator: 王赢赢
/// CreatDate: 2009-2-2
/// Description: 
/// Table：DeptLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uCostDiffAnalysis).addItemNum()
ClassMethod addItemNum() As %String
{
 s i=""
 f  s i=$o(^tmpdhccadataleveltree($j,i)) q:i=""  d
 .s j=""
 .f  s j=$o(^tmpdhccadataleveltree($j,i,j)) q:j=""  d
 ..s tmpDept=^tmpdhccadataleveltree($j,i,j)
 ..s tmpPars=$p(tmpDept,"||",2)
 ..s num=1
 ..f  s tmpPar=$p(tmpPars,"^",num) q:tmpPar=""  d
 ...s num=num+1
 ..i i="leaf" d
 ...s num=num-2
 ..e  d
 ...s num=num-3
 ..s ^tmpdhccadataleveltree($j,i,j)=tmpDept_"||"_num
 q "OK"
}

/// Others: w ##class(dhc.ca.cache.report.uCostDiffAnalysis).addDeptOrItemZero("dept","1,2,3")
ClassMethod addDeptOrItemZero(doi, months, repid, ind, costDistSetDr, dataSetDr) As %String
{
 n (doi,months, repid, ind, costDistSetDr,dataSetDr)
 s start = $ZH 
 
 i doi="item" d
 .s itemType=""
 .f  s itemType=$o(^tmpdhccadataleveltree($j,itemType)) q:itemType=""  d
 ..s itemDr=""
 ..f  s itemDr=$o(^tmpdhccadataleveltree($j,itemType,itemDr)) q:itemDr=""  d
 ...s tmpItemName=""
 ...i (itemType="leaf")&&($d(^DHCCAALLDATAITEMS(itemDr))) d
 ....s tmpItemName=$p(^DHCCAALLDATAITEMS(itemDr),"^",3)
 ...e  i (itemType="trunk")&&($d(^DHCCADATALEVELSETS(itemDr)))   d
 ....s tmpItemName=$p(^DHCCADATALEVELSETS(itemDr),"^",2)
 ...s tmpItemNum=$p(^tmpdhccadataleveltree($j,itemType,itemDr),"||",3)
 ...s tmpItemOrder=$p(^tmpdhccadataleveltree($j,itemType,itemDr),"||",1)
 ...s tmpNum=1
 ...f  s tmpMon=$p(months,",",tmpNum) q:tmpMon=""  d
 ....s tmpNum=tmpNum+1
 ....s tmpCostDiffAnalysis = ##class(dhc.ca.cache.report.costDiffAnalysis).%New()
 ....s tmpCostDiffAnalysis.month=tmpMon
 ....s tmpCostDiffAnalysis.money=0
 ....s tmpCostDiffAnalysis.deptName=""
 ....s tmpCostDiffAnalysis.deptNum=""
 ....s tmpCostDiffAnalysis.deptOrder=""
 ....s tmps=..getSpace(tmpItemNum)
 ....s tmpCostDiffAnalysis.itemName=tmps_tmpItemName
 ....s tmpCostDiffAnalysis.itemNum=tmpItemNum
 ....s tmpCostDiffAnalysis.itemOrder=tmpItemOrder
 ....s tmpCostDiffAnalysis.bedNum=0
 ....i ($p(^tmpdhccadataleveltree($j,itemType,itemDr),"||",4)="Y")  d
 .....i dataSetDr="" d
 ......d ##class(dhc.ca.cache.udata.uReportResult).Insert("cbcyfxb",tmpCostDiffAnalysis.month,costDistSetDr,-1,"0^"_tmpCostDiffAnalysis.deptName_"^"_tmpCostDiffAnalysis.deptNum_"^"_tmpCostDiffAnalysis.deptOrder_"^科室类别^"_tmpCostDiffAnalysis.itemName_"^"_tmpCostDiffAnalysis.itemNum_"^"_tmpCostDiffAnalysis.itemOrder_"^项目类别^"_tmpCostDiffAnalysis.bedNum_"^-1^"_itemType_"_"_itemDr)
 .....e  d
 ......d ##class(dhc.ca.cache.udata.uReportResult).Insert("cbcyfxb",tmpCostDiffAnalysis.month,costDistSetDr,dataSetDr,"0^"_tmpCostDiffAnalysis.deptName_"^"_tmpCostDiffAnalysis.deptNum_"^"_tmpCostDiffAnalysis.deptOrder_"^科室类别^"_tmpCostDiffAnalysis.itemName_"^"_tmpCostDiffAnalysis.itemNum_"^"_tmpCostDiffAnalysis.itemOrder_"^项目类别^"_tmpCostDiffAnalysis.bedNum_"^-1^"_itemType_"_"_itemDr)
 .....set Data=$lb(tmpCostDiffAnalysis.money,tmpCostDiffAnalysis.deptName,tmpCostDiffAnalysis.deptNum,tmpCostDiffAnalysis.deptOrder,tmpCostDiffAnalysis.month,tmpCostDiffAnalysis.itemName,tmpCostDiffAnalysis.itemNum,tmpCostDiffAnalysis.itemOrder,tmpCostDiffAnalysis.bedNum) ;按顺序对应Query的传出参数
 .....Set ^CacheTemp1(repid,ind)=Data
 .....Set ind=ind+1
 e  i doi="dept" d
 .s deptType=""
 .f  s deptType=$o(^tmpdhccadeptleveltree($j,deptType)) q:deptType=""  d
 ..s deptDr=""
 ..f  s deptDr=$o(^tmpdhccadeptleveltree($j,deptType,deptDr)) q:deptDr=""  d
 ...s tmpDeptName=""
 ...i (deptType="leaf")&&($d(^DHCCAUNITDEPTS(deptDr))) d
 ....s tmpDeptName=$p(^DHCCAUNITDEPTS(deptDr),"^",2)
 ...e  i (deptType="trunk")&&($d(^DHCCADEPTLEVELSETS(deptDr))) d
 ....s tmpDeptName=$p(^DHCCADEPTLEVELSETS(deptDr),"^",2)
 ...s tmpDeptNum=$p(^tmpdhccadeptleveltree($j,deptType,deptDr),"||",3)
 ...s tmpDeptOrder=$p(^tmpdhccadeptleveltree($j,deptType,deptDr),"||",1)
 ...s tmpNum=1
 ...f  s tmpMon=$p(months,",",tmpNum) q:tmpMon=""  d
 ....s tmpNum=tmpNum+1
 ....s tmpCostDiffAnalysis = ##class(dhc.ca.cache.report.costDiffAnalysis).%New()
 ....s tmpCostDiffAnalysis.month=tmpMon
 ....s tmpCostDiffAnalysis.money=0
 ....s tmps=..getSpace(tmpDeptNum)
 ....s tmpCostDiffAnalysis.deptName=tmps_tmpDeptName
 ....s tmpCostDiffAnalysis.deptNum=tmpDeptNum
 ....s tmpCostDiffAnalysis.deptOrder=tmpDeptOrder
 ....s tmpCostDiffAnalysis.itemName=""
 ....s tmpCostDiffAnalysis.itemNum=""
 ....s tmpCostDiffAnalysis.itemOrder=""
 ....s tmpCostDiffAnalysis.bedNum=0
 ....i ($p(^tmpdhccadeptleveltree($j,deptType,deptDr),"||",4)="Y") d
 .....i dataSetDr="" d
 ......d ##class(dhc.ca.cache.udata.uReportResult).Insert("cbcyfxb",tmpCostDiffAnalysis.month,costDistSetDr,-1,"0^"_tmpCostDiffAnalysis.deptName_"^"_tmpCostDiffAnalysis.deptNum_"^"_tmpCostDiffAnalysis.deptOrder_"^科室类别^"_tmpCostDiffAnalysis.itemName_"^"_tmpCostDiffAnalysis.itemNum_"^"_tmpCostDiffAnalysis.itemOrder_"^项目类别^"_tmpCostDiffAnalysis.bedNum_"^"_deptType_"_"_deptDr_"^-1")
 .....e  d
 ......d ##class(dhc.ca.cache.udata.uReportResult).Insert("cbcyfxb",tmpCostDiffAnalysis.month,costDistSetDr,dataSetDr,"0^"_tmpCostDiffAnalysis.deptName_"^"_tmpCostDiffAnalysis.deptNum_"^"_tmpCostDiffAnalysis.deptOrder_"^科室类别^"_tmpCostDiffAnalysis.itemName_"^"_tmpCostDiffAnalysis.itemNum_"^"_tmpCostDiffAnalysis.itemOrder_"^项目类别^"_tmpCostDiffAnalysis.bedNum_"^"_deptType_"_"_deptDr_"^-1")
 .....set Data=$lb(tmpCostDiffAnalysis.money,tmpCostDiffAnalysis.deptName,tmpCostDiffAnalysis.deptNum,tmpCostDiffAnalysis.deptOrder,tmpCostDiffAnalysis.month,tmpCostDiffAnalysis.itemName,tmpCostDiffAnalysis.itemNum,tmpCostDiffAnalysis.itemOrder,tmpCostDiffAnalysis.bedNum) ;按顺序对应Query的传出参数
 .....Set ^CacheTemp1(repid,ind)=Data
 .....Set ind=ind+1

 s elap = $ZH - start  
 Quit $$$OK
}

ClassMethod ListCostResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListCostResultExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp1 global
	n (qHandle)
	;w "close",!
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp1(repid)
	
	Quit $$$OK
}

ClassMethod ListCostResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListCostResultExecute ]
{
	// This fetch method should never have to change.
	// repid - Report ID
	// ind - sequence index which represents each row
	// Restore QHandle
	n (qHandle,Row,AtEnd)
	;w "fetch",!
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	;w AtEnd,",",repid,",",ind,!
	Set ind=$o(^CacheTemp1(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^CacheTemp1(repid,ind)
	}
	// Save Qhandle
	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// Others: d ##class(%ResultSet).RunQuery("dhc.ca.cache.report.uCostDiffAnalysis","ListCostResult",1,1,"1,2,3","",880,879)
Query ListCostResult(costDistSetDr, dataSetDr, months, doiDr, itemDr, itemDr2) As %Query(ROWSPEC = "money:%String,deptName:%String,deptNum:%String,deptOrder:%String,month:%String,itemName:%String,itemNum:%String,itemOrder:%String,bedNum:%String")
{
}

/// Others: w ##class(dhc.ca.cache.report.uCostDiffAnalysis).getCurrentClass(1,1)
ClassMethod getCurrentClass(setid, rowid) As %String
{
 n (setid,rowid)
 s tmpid=##class(dhc.ca.cache.report.comm.itemLevelSetTree).getParentid(rowid)
 s tmpUnleafRowids=rowid_##class(dhc.ca.cache.report.comm.itemLevelSetTree).getOffspringUnleaf(rowid)
 s tmpRowids=""
 s tmpCur=1
 f  s tmpUnleafRowid=$p(tmpUnleafRowids,"^",tmpCur) q:tmpUnleafRowid=""  d
 .s tmpCur=tmpCur+1
 .i tmpRowids="" d
 ..s tmpRowids=tmpUnleafRowid_"^0"
 .e  d
 ..s tmpRowids=tmpRowids_"||"_tmpUnleafRowid_"^0"
 .i $d(^DHCCADATALEVELSETS(tmpUnleafRowid,"Items",0)) d
 ..s tmpSubNum=^DHCCADATALEVELSETS(tmpUnleafRowid,"Items",0)
 ..s tmpSubCur=0
 ..f  q:tmpSubCur=tmpSubNum  d
 ...s tmpSubCur=tmpSubCur+1
 ...i $d(^DHCCADATALEVELSETS(tmpUnleafRowid,"Items",tmpSubCur)) d
 ....i tmpRowids="" d
 .....s tmpRowids=tmpUnleafRowid_"^"_tmpSubCur
 ....e  d
 .....s tmpRowids=tmpRowids_"||"_tmpUnleafRowid_"^"_tmpSubCur
 q tmpRowids
}

/// Others: w ##class(dhc.ca.cache.report.uCostDiffAnalysis).getLeaf(1)
ClassMethod getLeaf(itemDr) As %String
{
	n (itemDr)
	s tmpDepts=..getCurrentClass(itemDr,itemDr)
	s num=1
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^Name"
	f  s tmpDept=$p(tmpDepts,"||",num) q:tmpDept=""  d
	.s num=num+1
	.s tmpDeptId=$p(tmpDept,"^",1)
	.s tmpDeptSub=$p(tmpDept,"^",2)
	.i tmpDeptSub'=0 d
	..s tmpDeptDr=$p(^DHCCADATALEVELSETS(tmpDeptId,"Items",tmpDeptSub),"^",3)
	..i $d(^DHCCAALLDATAITEMS(tmpDeptDr)) d
	...s tmpDeptName=$p(^DHCCAALLDATAITEMS(tmpDeptDr),"^",3)
	...d json.InsertRowData(tmpDeptDr_"^"_tmpDeptName)
	s num=num-1
	s resultString = json.getJsonData(jsonTitle,num)
 	k json
	q resultString
}

ClassMethod AddDeptOneLevelLeaf(deptSetDr) As %Status
{
 n (deptSetDr)
 s subDeptDr=0
 f  s subDeptDr=$o(^DHCCADEPTLEVELSETS(deptSetDr,"Depts",subDeptDr)) q:subDeptDr=""  d
 .s tmpDeptDr=$p(^DHCCADEPTLEVELSETS(deptSetDr,"Depts",subDeptDr),"^",1)
 .s ^tmpdhccadeptleveltree($j,"leaf",tmpDeptDr)=1000+subDeptDr_"||"_deptSetDr
 q $$$OK
}

ClassMethod AddDataOneLevelLeaf(dataSetDr) As %Status
{
 n (dataSetDr)
 s subDeptDr=0
 f  s subDeptDr=$o(^DHCCADATALEVELSETS(dataSetDr,"Items",subDeptDr)) q:subDeptDr=""  d
 .s tmpDeptDr=$p(^DHCCADATALEVELSETS(dataSetDr,"Items",subDeptDr),"^",3)
 .s ^tmpdhccadataleveltree($j,"leaf",tmpDeptDr)=1000+subDeptDr_"||"_dataSetDr
 q $$$OK
}

ClassMethod addDeptActive() As %String
{
 s i=""
 f  s i=$o(^tmpdhccadeptleveltree($j,i)) q:i=""  d
 .s j=""
 .f  s j=$o(^tmpdhccadeptleveltree($j,i,j)) q:j=""  d
 ..s tmpDept=^tmpdhccadeptleveltree($j,i,j)
 ..i i="trunk"  d
 ...s tmpAct=$p(^DHCCADEPTLEVELSETS(j),"^",6)
 ...s ^tmpdhccadeptleveltree($j,i,j)=tmpDept_"||"_tmpAct
 s i=""
 f  s i=$o(^tmpdhccadeptleveltree($j,i)) q:i=""  d
 .s j=""
 .f  s j=$o(^tmpdhccadeptleveltree($j,i,j)) q:j=""  d
 ..s tmpDept=^tmpdhccadeptleveltree($j,i,j)
 ..i i="leaf"  d
 ...s tmpAct=$p(^DHCCADEPTLEVELSETS($p($p(tmpDept,"||",2),"^",1)),"^",6)
 ...s ^tmpdhccadeptleveltree($j,i,j)=tmpDept_"||"_tmpAct
 q "OK"
}

ClassMethod addItemActive() As %String
{
 s i=""
 f  s i=$o(^tmpdhccadataleveltree($j,i)) q:i=""  d
 .s j=""
 .f  s j=$o(^tmpdhccadataleveltree($j,i,j)) q:j=""  d
 ..s tmpDept=^tmpdhccadataleveltree($j,i,j)
 ..i i="trunk"  d
 ...s tmpAct=$p(^DHCCADATALEVELSETS(j),"^",6)
 ...s ^tmpdhccadataleveltree($j,i,j)=tmpDept_"||"_tmpAct
 s i=""
 f  s i=$o(^tmpdhccadataleveltree($j,i)) q:i=""  d
 .s j=""
 .f  s j=$o(^tmpdhccadataleveltree($j,i,j)) q:j=""  d
 ..s tmpDept=^tmpdhccadataleveltree($j,i,j)
 ..i i="leaf"  d
 ...s tmpAct=$p(^DHCCADATALEVELSETS($p($p(tmpDept,"||",2),"^",1)),"^",6)
 ...s ^tmpdhccadataleveltree($j,i,j)=tmpDept_"||"_tmpAct
 q "OK"
}

Storage Default
{
<Data name="uCostDiffAnalysisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uCostDiffAnalysisD</DataLocation>
<DefaultData>uCostDiffAnalysisDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uCostDiffAnalysisD</IdLocation>
<IndexLocation>^dhc.ca.c.uCostDiffAnalysisI</IndexLocation>
<StreamLocation>^dhc.ca.c.uCostDiffAnalysisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
