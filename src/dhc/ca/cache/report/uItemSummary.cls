/// Creator: 王赢赢
/// CreatDate: 2009-2-2
/// Description: 项目汇总查询
Class dhc.ca.cache.report.uItemSummary Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

//Projection uItemSummary As %Projection.Java(ROOTDIR = "c:\aaa");

/// Creator: 王赢赢
/// CreatDate: 2009-2-2
/// Description: 
/// Table：DeptLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uItemSummary).ListCostResultExecute("",1,1,1)
ClassMethod ListCostResultExecute(ByRef qHandle As %Binary, costDistSetDr, dataSetDr, interval) As %Status
{
 n (qHandle,costDistSetDr,dataSetDr,interval)
 d ##class(dhc.ca.cache.udata.uReportResult).Delete("xmhzcxb",interval,costDistSetDr,dataSetDr)
 s deptSetDr = $p(^DHCCACOSTDISTSETS(costDistSetDr),"^",5)
 Set repid=$I(^CacheTemp1)
 Set ind=1
 k ^tmpdhccadeptleveltree
 k ^tmpdhccadataleveltree
 d ##class(dhc.ca.cache.report.itemSummary).%DeleteExtent()
 s deptCountNum = ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptlevelSetSortedTree(deptSetDr,0)
 s dataCountNum = ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getDatalevelSetSortedTree(dataSetDr,0)
 d ..AddDeptOneLevelLeaf(deptSetDr)
 d ..addDeptNum()
 d ..addDeptActive()
 d ..AddDataOneLevelLeaf(dataSetDr)
 d ..addItemNum()
 d ..addItemActive()
 set ind= ..addZero(repid,ind,costDistSetDr, dataSetDr, interval)
 s tmpSubid=""
 f  s tmpSubid=$o(^DHCCACOSTDISTSETS(0,"DInterval",costDistSetDr,interval,tmpSubid)) q:tmpSubid=""  d
 .s tmpCostDist=^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",tmpSubid)
 .s tmpDeptDr=$p(tmpCostDist,"^",3)
 .s tmpItemDr=$p(tmpCostDist,"^",4)
 .s isSelf=$p(tmpCostDist,"^",6)
 .i (isSelf="self")&&$d(^tmpdhccadeptleveltree($j,"leaf",tmpDeptDr))&&($p(^tmpdhccadeptleveltree($j,"leaf",tmpDeptDr),"||",4)="Y")&&$d(^tmpdhccadataleveltree($j,"leaf",tmpItemDr))&&($p(^tmpdhccadataleveltree($j,"leaf",tmpItemDr),"||",4)="Y")&&$d(^DHCCAUNITDEPTS(tmpDeptDr))&&$d(^DHCCAALLDATAITEMS(tmpItemDr)) d
 ..s tmpMoney=$p(tmpCostDist,"^",5)
 ..s tmpDeptName=$p(^DHCCAUNITDEPTS(tmpDeptDr),"^",2)
 ..s tmpDeptTree=^tmpdhccadeptleveltree($j,"leaf",tmpDeptDr)
 ..s tmpDeptNum=$p(tmpDeptTree,"||",3)
 ..s tmpDeptOrder=$p(tmpDeptTree,"||",1)
 ..s tmpItemName=$p(^DHCCAALLDATAITEMS(tmpItemDr),"^",3)
 ..s tmpItemTree=^tmpdhccadataleveltree($j,"leaf",tmpItemDr)
 ..s tmpItemNum=$p(tmpItemTree,"||",3)
 ..s tmpItemOrder=$p(tmpItemTree,"||",1)
 ..set ind= ..addItemPar(tmpDeptName,tmpDeptNum,tmpDeptOrder,$p(tmpItemTree,"||",2),tmpMoney,$p(tmpDeptTree,"||",2),repid,ind,interval,costDistSetDr,dataSetDr,"leaf",tmpDeptDr)
 ..set ind= ..addDeptPar(tmpItemName,tmpItemNum,tmpItemOrder,$p(tmpDeptTree,"||",2),tmpMoney,repid,ind,interval,costDistSetDr,dataSetDr,"leaf",tmpItemDr)
 ..;s tmpItemSummary = ##class(dhc.ca.cache.report.itemSummary).%New()
 ..;s tmpItemSummary.money=tmpMoney
 ..;s tmpItemSummary.deptName=..getSpace(tmpDeptNum)_tmpDeptName
 ..;s tmpItemSummary.deptNum=tmpDeptNum
 ..;s tmpItemSummary.deptOrder=tmpDeptOrder
 ..;s tmpItemSummary.itemName=..getSpace(tmpItemNum)_tmpItemName
 ..;s tmpItemSummary.itemNum=tmpItemNum
 ..;s tmpItemSummary.itemOrder=tmpItemOrder
 ..s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","xmhzcxb",interval,costDistSetDr,dataSetDr,"leaf_"_tmpDeptDr,"leaf_"_tmpItemDr,""))
 ..s $p(^DHCCAREPORTRESULT(tmpRRid),"^",5)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",5)+tmpMoney
 ..;set Data=$lb(tmpItemSummary.money,tmpItemSummary.deptName,tmpItemSummary.deptNum,tmpItemSummary.deptOrder,tmpItemSummary.itemName,tmpItemSummary.itemNum,tmpItemSummary.itemOrder) ;按顺序对应Query的传出参数
 ..;Set ^CacheTemp1(repid,ind)=Data
 ..;Set ind=ind+1
 ..;s sc = tmpItemSummary.%Save()
 s qHandle=$lb(0,0)
 q $$$OK
}

/// Others: w ##class(dhc.ca.cache.report.uItemSummary).addZero()
ClassMethod addZero(repid, ind, costDistSetDr, dataSetDr, interval) As %String
{
 n (repid,ind,costDistSetDr, dataSetDr, interval)
 s itemType=""
 f  s itemType=$o(^tmpdhccadataleveltree($j,itemType)) q:itemType=""  d
 .s itemDr=""
 .f  s itemDr=$o(^tmpdhccadataleveltree($j,itemType,itemDr)) q:itemDr=""  d
 ..s tmpItemName=""
 ..i (itemType="leaf")&&($d(^DHCCAALLDATAITEMS(itemDr))) d
 ...s tmpItemName=$p(^DHCCAALLDATAITEMS(itemDr),"^",3)
 ..e  i (itemType="trunk")&&($d(^DHCCADATALEVELSETS(itemDr)))   d
 ...s tmpItemName=$p(^DHCCADATALEVELSETS(itemDr),"^",2)
 ..s tmpItemNum=$p(^tmpdhccadataleveltree($j,itemType,itemDr),"||",3)
 ..s tmpItemOrder=$p(^tmpdhccadataleveltree($j,itemType,itemDr),"||",1)
 ..s deptType=""
 ..f  s deptType=$o(^tmpdhccadeptleveltree($j,deptType)) q:deptType=""  d
 ...s deptDr=""
 ...f  s deptDr=$o(^tmpdhccadeptleveltree($j,deptType,deptDr)) q:deptDr=""  d
 ....s tmpDeptName=""
 ....i (deptType="leaf")&&($d(^DHCCAUNITDEPTS(deptDr))) d
 .....s tmpDeptName=$p(^DHCCAUNITDEPTS(deptDr),"^",2)
 ....e  i (deptType="trunk")&&($d(^DHCCADEPTLEVELSETS(deptDr))) d
 .....s tmpDeptName=$p(^DHCCADEPTLEVELSETS(deptDr),"^",2)
 ....s tmpDeptNum=$p(^tmpdhccadeptleveltree($j,deptType,deptDr),"||",3)
 ....s tmpDeptOrder=$p(^tmpdhccadeptleveltree($j,deptType,deptDr),"||",1)
 ....i tmpItemName'="" d
 .....s tmpItemSummary = ##class(dhc.ca.cache.report.itemSummary).%New()
 .....s tmpItemSummary.money=0
 .....s tmpItemSummary.deptName=..getSpace(tmpDeptNum)_tmpDeptName
 .....s tmpItemSummary.deptNum=tmpDeptNum
 .....s tmpItemSummary.deptOrder=tmpDeptOrder
 .....s tmpItemSummary.itemName=..getSpace(tmpItemNum)_tmpItemName
 .....s tmpItemSummary.itemNum=tmpItemNum
 .....s tmpItemSummary.itemOrder=tmpItemOrder
 .....;set Data=$lb(tmpItemSummary.money,tmpItemSummary.deptName,tmpItemSummary.deptNum,tmpItemSummary.deptOrder,tmpItemSummary.itemName,tmpItemSummary.itemNum,tmpItemSummary.itemOrder) ;按顺序对应Query的传出参数
 .....i ($p(^tmpdhccadeptleveltree($j,deptType,deptDr),"||",4)="Y")&&($p(^tmpdhccadataleveltree($j,itemType,itemDr),"||",4)="Y") d
 ......d ##class(dhc.ca.cache.udata.uReportResult).Insert("xmhzcxb",interval,costDistSetDr,dataSetDr,"0^"_tmpItemSummary.deptName_"^"_tmpItemSummary.deptNum_"^"_tmpItemSummary.deptOrder_"^科室类别^"_tmpItemSummary.itemName_"^"_tmpItemSummary.itemNum_"^"_tmpItemSummary.itemOrder_"^项目类别^数据类别^"_deptType_"_"_deptDr_"^"_itemType_"_"_itemDr)
 .....;Set ^CacheTemp1(repid,ind)=Data
 .....;Set ind=ind+1
 .....;s sc = tmpItemSummary.%Save()
 q ind
}

/// Creator: 王赢赢
/// CreatDate: 2009-2-2
/// Description: 
/// Table：DeptLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uItemSummary).addDeptPar("itemName", 1, 1,"57^14^7^1",33)
ClassMethod addDeptPar(itemName, itemNum, itemOrder, par, money, repid, ind, interval, costDistSetDr, dataSetDr, itemType, itemDr) As %String
{
 n (itemName, itemNum, itemOrder, par, money,repid,ind,interval,costDistSetDr,dataSetDr,itemType,itemDr)
 s tmpNum=1
 f  s tmpPar=$p(par,"^",tmpNum) q:tmpPar=""  d
 .s tmpNum=tmpNum+1 
 .i $d(^tmpdhccadeptleveltree($j,"trunk",tmpPar)) d
 ..s tmpDept=^tmpdhccadeptleveltree($j,"trunk",tmpPar)
 ..s tmpDeptOrder=$p(tmpDept,"||",1)
 ..s tmpDeptNum=$p(tmpDept,"||",3)
 ..s tmpDeptName=$p(^DHCCADEPTLEVELSETS(tmpPar),"^",2)
 ..;s tmpItemSummary = ##class(dhc.ca.cache.report.itemSummary).%New()
 ..;s tmpItemSummary.money=money
 ..;s tmpItemSummary.deptName=..getSpace(tmpDeptNum)_tmpDeptName
 ..;s tmpItemSummary.deptNum=tmpDeptNum
 ..;s tmpItemSummary.deptOrder=tmpDeptOrder
 ..;s tmpItemSummary.itemName=..getSpace(itemNum)_itemName
 ..;s tmpItemSummary.itemNum=itemNum
 ..;s tmpItemSummary.itemOrder=itemOrder
 ..s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","xmhzcxb",interval,costDistSetDr,dataSetDr,"trunk_"_tmpPar,itemType_"_"_itemDr,""))
 ..s $p(^DHCCAREPORTRESULT(tmpRRid),"^",5)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",5)+money
 ..;set Data=$lb(tmpItemSummary.money,tmpItemSummary.deptName,tmpItemSummary.deptNum,tmpItemSummary.deptOrder,tmpItemSummary.itemName,tmpItemSummary.itemNum,tmpItemSummary.itemOrder) ;按顺序对应Query的传出参数
 ..;Set ^CacheTemp1(repid,ind)=Data
 ..;Set ind=ind+1
 ..;s sc = tmpItemSummary.%Save()
 q ind
}

/// Others: w ##class(dhc.ca.cache.report.uItemSummary).addItemPar("itemName", 1, 1,"3^2",33,"57^14^7^1")
ClassMethod addItemPar(deptName, deptNum, deptOrder, par, money, deptPar, repid, ind, interval, costDistSetDr, dataSetDr, deptType, deptDr) As %String
{
 n (deptName, deptNum, deptOrder, par, money,deptPar,repid,ind,interval,costDistSetDr,dataSetDr,deptType,deptDr)
 s tmpNum=1
 f  s tmpPar=$p(par,"^",tmpNum) q:tmpPar=""  d
 .s tmpNum=tmpNum+1 
 .i $d(^tmpdhccadataleveltree($j,"trunk",tmpPar)) d
 ..s tmpItem=^tmpdhccadataleveltree($j,"trunk",tmpPar)
 ..s tmpItemOrder=$p(tmpItem,"||",1)
 ..s tmpItemNum=$p(tmpItem,"||",3)
 ..s tmpItemName=$p(^DHCCADATALEVELSETS(tmpPar),"^",2)
 ..set ind= ..addDeptPar(tmpItemName,tmpItemNum,tmpItemOrder,deptPar,money,repid,ind,interval,costDistSetDr,dataSetDr,"trunk",tmpPar)
 ..;s tmpItemSummary = ##class(dhc.ca.cache.report.itemSummary).%New()
 ..;s tmpItemSummary.money=money
 ..;s tmpItemSummary.itemName=..getSpace(tmpItemNum)_tmpItemName
 ..;s tmpItemSummary.itemNum=tmpItemNum
 ..;s tmpItemSummary.itemOrder=tmpItemOrder
 ..;s tmpItemSummary.deptName=..getSpace(deptNum)_deptName
 ..;s tmpItemSummary.deptNum=deptNum
 ..;s tmpItemSummary.deptOrder=deptOrder
 ..s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","xmhzcxb",interval,costDistSetDr,dataSetDr,deptType_"_"_deptDr,"trunk_"_tmpPar,""))
 ..s $p(^DHCCAREPORTRESULT(tmpRRid),"^",5)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",5)+money
 ..;set Data=$lb(tmpItemSummary.money,tmpItemSummary.deptName,tmpItemSummary.deptNum,tmpItemSummary.deptOrder,tmpItemSummary.itemName,tmpItemSummary.itemNum,tmpItemSummary.itemOrder) ;按顺序对应Query的传出参数
 ..;Set ^CacheTemp1(repid,ind)=Data
 ..;Set ind=ind+1
 ..;s sc = tmpItemSummary.%Save()
 q ind
}

/// Creator: 王赢赢
/// CreatDate: 2009-2-2
/// Description: 
/// Table：DeptLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uItemSummary).addDeptNum()
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

/// Creator: 王赢赢
/// CreatDate: 2009-2-2
/// Description: 
/// Table：DeptLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uItemSummary).addItemNum()
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

ClassMethod saveAData(repid, ind, money, deptName, deptNum, deptOrder, itemName, itemNum, itemOrder) As %String
{
 n (repid,ind,money,deptName,deptNum,deptOrder,itemName,itemNum,itemOrder)
 s ^CacheTemp1(repid,ind)=$lb(money,deptName,deptNum,deptOrder,itemName,itemNum,itemOrder)
 s ind=ind+1
 q ind
}

/// Others: w ##class(dhc.ca.cache.report.uItemSummary).findLocation()
ClassMethod findLocation(repid, deptName, itemName) As %String
{
 n (repid,deptName,itemName)

 q ind
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
	;Set AtEnd=$LIST(qHandle,1)
	;Set repid=$LIST(qHandle,2)
	;Set ind=$LIST(qHandle,3)
	Set AtEnd=$LIST(qHandle,1)
	Set ind=$LIST(qHandle,2)
	;w AtEnd,",",repid,",",ind,!
	Set ind=$o(^DHCCAREPORTRESULT(ind))
	If ind="" {			// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^DHCCAREPORTRESULT(ind)
	}
	// Save Qhandle
	s qHandle=$lb(AtEnd,ind)
	
	Quit $$$OK
}

//Query ListCostResult(costDistSetDr, dataSetDr, interval) As %Query(ROWSPEC = "money:%String,deptName:%String,deptNum:%String,deptOrder:%String,itemName:%String,itemNum:%String,itemOrder:%String")

/// Others: d ##class(%ResultSet).RunQuery("dhc.ca.cache.report.uItemSummary","ListCostResult",1,1,1)
Query ListCostResult(costDistSetDr, dataSetDr, interval) As %Query(ROWSPEC = "repType:%String,intervalDr:%String,distSetDr:%String,dataSetDr:%String,fee:%String,deptName:%String,deptLayer:%String,deptOrder:%String,deptType:%String,itemName:%String,itemLayer:%String,itemOrder:%String,itemType:%String,dataType:%String,deptDr:%String,itemDr:%String")
{
}

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

Storage Default
{
<Data name="uItemSummaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uItemSummaryD</DataLocation>
<DefaultData>uItemSummaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uItemSummaryD</IdLocation>
<IndexLocation>^dhc.ca.c.uItemSummaryI</IndexLocation>
<StreamLocation>^dhc.ca.c.uItemSummaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
