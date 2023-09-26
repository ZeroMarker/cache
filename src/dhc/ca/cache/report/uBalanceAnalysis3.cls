/// Creator: 王赢赢
/// CreatDate: 2010-4-5
/// Description: 结余分析表
Class dhc.ca.cache.report.uBalanceAnalysis3 Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2010-4-5
/// Description: 
/// Table：ReportResulta
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uBalanceAnalysis3).Main(1,58,1,23,"1,2,3",7)7:直接医疗
ClassMethod Main(costDistSetDr, mzDeptSetDr, dataSetDr, yyItemSetDr, months, directDept) As %Status
{
 n (costDistSetDr,mzDeptSetDr,dataSetDr,yyItemSetDr,months,directDept)
 d ..DeleteBalanceAnalysis(costDistSetDr, dataSetDr, months)
 d ..AddZero(costDistSetDr,dataSetDr,months,directDept)
 d ..AddCost(costDistSetDr,mzDeptSetDr,dataSetDr,yyItemSetDr, months)
 d ..AddIncome(costDistSetDr,mzDeptSetDr,dataSetDr,yyItemSetDr, months)
 q $$$OK
}

ClassMethod DeleteBalanceAnalysis(costDistSetDr, dataSetDr, months) As %Status
{
 n (costDistSetDr, dataSetDr, months)
 s tmpRRNum=1
 f  s tmpDMon=$p(months,",",tmpRRNum) q:tmpDMon=""  d
 .s tmpRRNum=tmpRRNum+1
 .d ##class(dhc.ca.cache.udata.uReportResult).Delete("jyfxb3",tmpDMon,costDistSetDr,dataSetDr)
 q $$$OK
}

/// d ##class(dhc.ca.cache.udata.uReportResult).Insert("报表类别","核算周期","分摊方法套","数据分层套","金额^科室名称^科室层级^科室顺序^科室类别^项目名称^项目层级^项目顺序^项目类别^数据类别^科室Dr^项目Dr^来源科室名称^来源科室Dr^来源科室类别名称^来源科室类别Dr^来源科室类别排序")
ClassMethod AddZero(costDistSetDr, dataSetDr, months, directDept) As %Status
{
 n (costDistSetDr, dataSetDr, months, directDept)
 k ^tmpdhccadeptleveltree
 s deptCountNum = ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptlevelSetSortedTree(directDept,0)
 d ..addDeptNum()
 s tmpRRNum=1
 f  s tmpDMon=$p(months,",",tmpRRNum) q:tmpDMon=""  d
 .s tmpRRNum=tmpRRNum+1
 .s tmpTreeJob=""
 .f  s tmpTreeJob=$o(^tmpdhccadeptleveltree(tmpTreeJob)) q:tmpTreeJob=""  d
 ..s tmpTreeType=""
 ..f  s tmpTreeType=$o(^tmpdhccadeptleveltree(tmpTreeJob,tmpTreeType)) q:tmpTreeType=""  d
 ...s tmpTreeDr=""
 ...f  s tmpTreeDr=$o(^tmpdhccadeptleveltree(tmpTreeJob,tmpTreeType,tmpTreeDr)) q:tmpTreeDr=""  d
 ....i tmpTreeType="trunk" d
 .....i $d(^DHCCADEPTLEVELSETS(tmpTreeDr)) d
 ......s tmpDeptName=$p(^DHCCADEPTLEVELSETS(tmpTreeDr),"^",2)
 ......s tmpDeptOrder=$p(^tmpdhccadeptleveltree(tmpTreeJob,tmpTreeType,tmpTreeDr),"||",1)
 ......s tmpDeptNum=$p(^tmpdhccadeptleveltree(tmpTreeJob,tmpTreeType,tmpTreeDr),"||",3)
 ......d ##class(dhc.ca.cache.udata.uReportResult).Insert("jyfxb3",tmpDMon,costDistSetDr,dataSetDr,"0^"_..getSpace(tmpDeptNum)_tmpDeptName_"^"_tmpDeptNum_"^"_tmpDeptOrder_"^0^0^0^^^^trunk_"_tmpTreeDr_"^-1^^^^^")
 ......;d ##class(dhc.ca.cache.udata.uReportResult).Insert("jyfxb3",tmpDMon,costDistSetDr,dataSetDr,"0^"_..getSpace(tmpDeptNum)_tmpDeptName_"^"_tmpDeptNum_"^"_tmpDeptOrder_"^0^0^0^^^^trunk_"_tmpTreeDr_"^药品^^^^^")
 ....i tmpTreeType="leaf" d
 .....i $d(^DHCCAUNITDEPTS(tmpTreeDr)) d
 ......s tmpDeptName=$p(^DHCCAUNITDEPTS(tmpTreeDr),"^",2)
 ......s tmpDeptOrder=$p(^tmpdhccadeptleveltree(tmpTreeJob,tmpTreeType,tmpTreeDr),"||",1)
 ......s tmpDeptNum=$p(^tmpdhccadeptleveltree(tmpTreeJob,tmpTreeType,tmpTreeDr),"||",3)
 ......d ##class(dhc.ca.cache.udata.uReportResult).Insert("jyfxb3",tmpDMon,costDistSetDr,dataSetDr,"0^"_..getSpace(tmpDeptNum)_tmpDeptName_"^"_tmpDeptNum_"^"_tmpDeptOrder_"^0^0^0^^^^leaf_"_tmpTreeDr_"^-1^^^^^")
 ......;d ##class(dhc.ca.cache.udata.uReportResult).Insert("jyfxb3",tmpDMon,costDistSetDr,dataSetDr,"0^"_..getSpace(tmpDeptNum)_tmpDeptName_"^"_tmpDeptNum_"^"_tmpDeptOrder_"^0^^^^^^leaf_"_tmpTreeDr_"^药品^^^^^")
 q $$$OK
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

/// Others: w ##class(dhc.ca.cache.report.uBalanceAnalysis1and2).AddCost(1,"1,2,3")
ClassMethod AddCost(costDistSetDr, mzDeptSetDr, dataSetDr, yyItemSetDr, months) As %Status
{
 n (costDistSetDr,mzDeptSetDr,dataSetDr,yyItemSetDr, months)
 s tmpRRNum=1
 f  s tmpDMon=$p(months,",",tmpRRNum) q:tmpDMon=""  d
 .s tmpRRNum=tmpRRNum+1
 .s tmpSubid=""
 .f  s tmpSubid=$o(^DHCCACOSTDISTSETS(0,"DInterval",costDistSetDr,tmpDMon,tmpSubid)) q:tmpSubid=""  d
 ..s tmpCostDist=^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",tmpSubid)
 ..s tmpDeptDr=$p(tmpCostDist,"^",3)
 ..s tmpItemDr=$p(tmpCostDist,"^",4)
 ..;w tmpDeptDr,",",tmpItemDr,";"
 ..i $d(^DHCCAUNITDEPTS(tmpDeptDr))&&$d(^DHCCAALLDATAITEMS(tmpItemDr))&&$d(^DHCCAREPORTRESULT(0,"RTIntDiDa","jyfxb3",tmpDMon,costDistSetDr,dataSetDr,"leaf_"_tmpDeptDr)) d
 ...s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","jyfxb3",tmpDMon,costDistSetDr,dataSetDr,"leaf_"_tmpDeptDr,"-1",""))
 ...i tmpRRid'="" d
 ....s tmpMoney=$p(tmpCostDist,"^",5)
 ....i ..FindItemType(tmpItemDr,yyItemSetDr)="药品" d
 .....s $p(^DHCCAREPORTRESULT(tmpRRid),"^",9)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",9)+tmpMoney
 ....e  d
 .....s $p(^DHCCAREPORTRESULT(tmpRRid),"^",5)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",5)+tmpMoney
 ....d ..AddCostPar(tmpDeptDr,tmpRRid,tmpItemDr,yyItemSetDr,tmpDMon,costDistSetDr,dataSetDr,tmpMoney)
 q $$$OK
}

ClassMethod AddCostPar(deptDr, RRid, itemDr, yyItemSetDr, tmpDMon, costDistSetDr, dataSetDr, money) As %Status
{
 n (deptDr,RRid,itemDr,yyItemSetDr,tmpDMon,costDistSetDr,dataSetDr,money)
 s tmpTreeJob=""
 f  s tmpTreeJob=$o(^tmpdhccadeptleveltree(tmpTreeJob)) q:tmpTreeJob=""  d
 .s par=$p(^tmpdhccadeptleveltree(tmpTreeJob,"leaf",deptDr),"||",2)
 .s tmpNum=1
 .f  s tmpPar=$p(par,"^",tmpNum) q:tmpPar=""  d
 ..s tmpNum=tmpNum+1 
 ..i $d(^tmpdhccadeptleveltree(tmpTreeJob,"trunk",tmpPar)) d
 ...s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","jyfxb3",tmpDMon,costDistSetDr,dataSetDr,"trunk_"_tmpPar,"-1",""))
 ...i ..FindItemType(itemDr,yyItemSetDr)="药品" d
 ....s $p(^DHCCAREPORTRESULT(tmpRRid),"^",9)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",9)+money
 ...e  d
 ....s $p(^DHCCAREPORTRESULT(tmpRRid),"^",5)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",5)+money
 q $$$OK
}

/// Others: w ##class(dhc.ca.cache.report.uBalanceAnalysis1and2).AddIncome(1,58,1,23,"1,2,3")
ClassMethod AddIncome(costDistSetDr, mzDeptSetDr, dataSetDr, yyItemSetDr, months) As %Status
{
 n (costDistSetDr,mzDeptSetDr,dataSetDr,yyItemSetDr, months)
 ;s deptSetDr = $p(^DHCCACOSTDISTSETS(costDistSetDr),"^",5)
 s tmpRRNum=1
 f  s tmpDMon=$p(months,",",tmpRRNum) q:tmpDMon=""  d
 .s tmpRRNum=tmpRRNum+1
 .s tmpRowid=""
 .f  s tmpRowid=$o(^DHCCAINCOMEDATAS(0,"Interval",tmpDMon,tmpRowid)) q:tmpRowid=""  d
 ..s tmpIncome=^DHCCAINCOMEDATAS(tmpRowid)
 ..s tmpIncomeTDeptDr=$p(tmpIncome,"^",11) //开单
 ..;s tmpIncomeFDeptDr=$p(tmpIncome,"^",14) //执行
 ..s tmpIncomeItemDr=$p(tmpIncome,"^",6)
 ..i $d(^DHCCAUNITDEPTS(tmpIncomeTDeptDr))&&$d(^DHCCAALLDATAITEMS(tmpIncomeItemDr)) d
 ...s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","jyfxb3",tmpDMon,costDistSetDr,dataSetDr,"leaf_"_tmpIncomeTDeptDr,"-1",""))
 ...i tmpRRid'="" d
 ....s tmpIncomeMoney=$p(tmpIncome,"^",7)
 ....i ..FindItemType(tmpIncomeItemDr,yyItemSetDr)="药品" d
 .....s $p(^DHCCAREPORTRESULT(tmpRRid),"^",11)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",11)+tmpIncomeMoney
 ....e  d
 .....s $p(^DHCCAREPORTRESULT(tmpRRid),"^",10)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",10)+tmpIncomeMoney 
 ....d ..AddIncomePar(tmpIncomeTDeptDr,tmpRRid,tmpIncomeItemDr,yyItemSetDr,tmpDMon,costDistSetDr,dataSetDr,tmpIncomeMoney)
 q $$$OK
}

ClassMethod AddIncomePar(deptDr, RRid, itemDr, yyItemSetDr, tmpDMon, costDistSetDr, dataSetDr, money) As %Status
{
 n (deptDr,RRid,itemDr,yyItemSetDr,tmpDMon,costDistSetDr,dataSetDr,money)
 s tmpTreeJob=""
 f  s tmpTreeJob=$o(^tmpdhccadeptleveltree(tmpTreeJob)) q:tmpTreeJob=""  d
 .s par=$p(^tmpdhccadeptleveltree(tmpTreeJob,"leaf",deptDr),"||",2)
 .s tmpNum=1
 .f  s tmpPar=$p(par,"^",tmpNum) q:tmpPar=""  d
 ..s tmpNum=tmpNum+1 
 ..i $d(^tmpdhccadeptleveltree(tmpTreeJob,"trunk",tmpPar)) d
 ...s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","jyfxb3",tmpDMon,costDistSetDr,dataSetDr,"trunk_"_tmpPar,"-1",""))
 ...i ..FindItemType(itemDr,yyItemSetDr)="药品" d
 ....s $p(^DHCCAREPORTRESULT(tmpRRid),"^",11)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",11)+money
 ...e  d
 ....s $p(^DHCCAREPORTRESULT(tmpRRid),"^",10)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",10)+money
 q $$$OK
}

/// Others: w ##class(dhc.ca.cache.report.uBalanceAnalysis1and2).FindItemType(144,23)
ClassMethod FindItemType(itemDr, yyItemSetDr) As %String
{
 n (itemDr,yyItemSetDr)
 s tmpChildDr=""
 s tmpPreChildDr=""
 s tmpSubDr=""
 s tmpOrder=""
 f  s tmpOrder=$o(^DHCCADATALEVELSETS(0,"Parent",yyItemSetDr,tmpOrder)) q:(tmpOrder="")||(tmpSubDr'="")  d
 .s tmpChildDr=$o(^DHCCADATALEVELSETS(0,"Parent",yyItemSetDr,tmpOrder,""))
 .s tmpSubDr=$o(^DHCCADATALEVELSETS(0,"Item",tmpChildDr,itemDr,tmpSubDr))
 .s tmpPreChildDr=tmpChildDr
 s tmpType="医疗"
 i tmpSubDr'="" d
 .s tmpType=$p(^DHCCADATALEVELSETS(tmpPreChildDr),"^",2)
 ;w tmpType
 q tmpType
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

Storage Default
{
<Data name="uBalanceAnalysis3DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uBalanceAnalysis3D</DataLocation>
<DefaultData>uBalanceAnalysis3DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uBalanceAnalysis3D</IdLocation>
<IndexLocation>^dhc.ca.c.uBalanceAnalysis3I</IndexLocation>
<StreamLocation>^dhc.ca.c.uBalanceAnalysis3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
