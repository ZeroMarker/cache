/// Creator: 王赢赢
/// CreatDate: 2010-4-5
/// Description: 结余分析表
Class dhc.ca.cache.report.uBalanceAnalysis1and2 Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2010-4-5
/// Description: 
/// Table：ReportResult
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uBalanceAnalysis1and2).Main(1,58,1,23,"1,2,3")
ClassMethod Main(costDistSetDr, mzDeptSetDr, dataSetDr, yyItemSetDr, months) As %Status
{
 n (costDistSetDr,mzDeptSetDr,dataSetDr,yyItemSetDr,months)
 d ..DeleteBalanceAnalysis(costDistSetDr, dataSetDr, months)
 d ..AddZero(costDistSetDr,dataSetDr,months)
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
 .d ##class(dhc.ca.cache.udata.uReportResult).Delete("jyfxb1and2",tmpDMon,costDistSetDr,dataSetDr)
 q $$$OK
}

/// d ##class(dhc.ca.cache.udata.uReportResult).Insert("报表类别","核算周期","分摊方法套","数据分层套","金额^科室名称^科室层级^科室顺序^科室类别^项目名称^项目层级^项目顺序^项目类别^数据类别^科室Dr^项目Dr^来源科室名称^来源科室Dr^来源科室类别名称^来源科室类别Dr^来源科室类别排序")
ClassMethod AddZero(costDistSetDr, dataSetDr, months) As %Status
{
 n (costDistSetDr, dataSetDr, months)
 s tmpRRNum=1
 f  s tmpDMon=$p(months,",",tmpRRNum) q:tmpDMon=""  d
 .s tmpRRNum=tmpRRNum+1
 .d ##class(dhc.ca.cache.udata.uReportResult).Insert("jyfxb1and2",tmpDMon,costDistSetDr,dataSetDr,"0^0^^^^^^^^^门诊^医疗^^^^^")
 .d ##class(dhc.ca.cache.udata.uReportResult).Insert("jyfxb1and2",tmpDMon,costDistSetDr,dataSetDr,"0^0^^^^^^^^^门诊^药品^^^^^")
 .d ##class(dhc.ca.cache.udata.uReportResult).Insert("jyfxb1and2",tmpDMon,costDistSetDr,dataSetDr,"0^0^^^^^^^^^住院^医疗^^^^^")
 .d ##class(dhc.ca.cache.udata.uReportResult).Insert("jyfxb1and2",tmpDMon,costDistSetDr,dataSetDr,"0^0^^^^^^^^^住院^药品^^^^^")
 .d ##class(dhc.ca.cache.udata.uReportResult).Insert("jyfxb1and2",tmpDMon,costDistSetDr,dataSetDr,"0^0^^^^^^^^^科研^医疗^^^^^")
 .d ##class(dhc.ca.cache.udata.uReportResult).Insert("jyfxb1and2",tmpDMon,costDistSetDr,dataSetDr,"0^0^^^^^^^^^科研^药品^^^^^")
 .d ##class(dhc.ca.cache.udata.uReportResult).Insert("jyfxb1and2",tmpDMon,costDistSetDr,dataSetDr,"0^0^^^^^^^^^其它^医疗^^^^^")
 .d ##class(dhc.ca.cache.udata.uReportResult).Insert("jyfxb1and2",tmpDMon,costDistSetDr,dataSetDr,"0^0^^^^^^^^^其它^药品^^^^^")
 q $$$OK
}

/// Others: w ##class(dhc.ca.cache.report.uBalanceAnalysis1and2).AddCost(1,"1,2,3")
ClassMethod AddCost(costDistSetDr, mzDeptSetDr, dataSetDr, yyItemSetDr, months) As %Status
{
 n (costDistSetDr,mzDeptSetDr,dataSetDr,yyItemSetDr, months)
 ;s deptSetDr = $p(^DHCCACOSTDISTSETS(costDistSetDr),"^",5)
 s tmpRRNum=1
 f  s tmpDMon=$p(months,",",tmpRRNum) q:tmpDMon=""  d
 .s tmpRRNum=tmpRRNum+1
 .s tmpSubid=""
 .f  s tmpSubid=$o(^DHCCACOSTDISTSETS(0,"DInterval",costDistSetDr,tmpDMon,tmpSubid)) q:tmpSubid=""  d
 ..s tmpCostDist=^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",tmpSubid)
 ..s tmpDeptDr=$p(tmpCostDist,"^",3)
 ..s tmpItemDr=$p(tmpCostDist,"^",4)
 ..;w tmpDeptDr,",",tmpItemDr,";"
 ..i $d(^DHCCAUNITDEPTS(tmpDeptDr))&&$d(^DHCCAALLDATAITEMS(tmpItemDr)) d
 ...s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","jyfxb1and2",tmpDMon,costDistSetDr,dataSetDr,..FindDeptType(tmpDeptDr,mzDeptSetDr),..FindItemType(tmpItemDr,yyItemSetDr),""))
 ...i tmpRRid'="" d
 ....s tmpMoney=$p(tmpCostDist,"^",5)
 ....s $p(^DHCCAREPORTRESULT(tmpRRid),"^",5)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",5)+tmpMoney
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
 ..;w tmpIncome,!
 ..s tmpIncomeTDeptDr=$p(tmpIncome,"^",11) //开单
 ..;s tmpIncomeFDeptDr=$p(tmpIncome,"^",14) //执行
 ..s tmpIncomeItemDr=$p(tmpIncome,"^",6)
 ..i $d(^DHCCAUNITDEPTS(tmpIncomeTDeptDr))&&$d(^DHCCAALLDATAITEMS(tmpIncomeItemDr)) d
 ...s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","jyfxb1and2",tmpDMon,costDistSetDr,dataSetDr,..FindDeptType(tmpIncomeTDeptDr,mzDeptSetDr),..FindItemType(tmpIncomeItemDr,yyItemSetDr),""))
 ...i tmpRRid'="" d
 ....;w ..FindDeptType(tmpIncomeTDeptDr,mzDeptSetDr),",",..FindItemType(tmpIncomeItemDr,yyItemSetDr),",",$p(tmpIncome,"^",7),"     "
 ....s tmpIncomeMoney=$p(tmpIncome,"^",7)
 ....s $p(^DHCCAREPORTRESULT(tmpRRid),"^",6)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",6)+tmpIncomeMoney
 q $$$OK
}

/// Others: w ##class(dhc.ca.cache.report.uBalanceAnalysis1and2).FindDeptType(186,58)
ClassMethod FindDeptType(deptDr, mzDeptSetDr) As %String
{
 n (deptDr,mzDeptSetDr)
 s tmpChildDr=""
 s tmpPreChildDr=""
 s tmpSubDr=""
 f  s tmpChildDr=$o(^DHCCADEPTLEVELSETS(0,"Parent",mzDeptSetDr,tmpChildDr)) q:(tmpChildDr="")||(tmpSubDr'="")  d
 .s tmpSubDr=$o(^DHCCADEPTLEVELSETS(0,"Dept",tmpChildDr,deptDr,tmpSubDr))
 .s tmpPreChildDr=tmpChildDr
 s tmpType=-1
 i tmpSubDr'="" d
 .s tmpType=$p(^DHCCADEPTLEVELSETS(tmpPreChildDr),"^",2)
 q tmpType
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

Storage Default
{
<Data name="uBalanceAnalysis1and2DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uBalanceAnalysis1and2D</DataLocation>
<DefaultData>uBalanceAnalysis1and2DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uBalanceAnalysis1and2D</IdLocation>
<IndexLocation>^dhc.ca.c.uBalanceAnalysis1and2I</IndexLocation>
<StreamLocation>^dhc.ca.c.uBalanceAnalysis1and2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
