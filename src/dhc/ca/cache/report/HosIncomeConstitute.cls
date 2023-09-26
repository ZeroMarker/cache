/// Creator: 王赢赢
/// CreatDate: 2010-4-5
/// Description: 科室收入差异分析汇总表
Class dhc.ca.cache.report.HosIncomeConstitute Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2010-4-5
/// Description: 
/// Table：ReportResulta
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.HosIncomeConstitute).Main(1,188,1,63,7,63)
ClassMethod Main(costDistSetDr, mzDeptSetDr, dataSetDr, yyItemSetDr, months, directDept) As %Status
{
 n (costDistSetDr,mzDeptSetDr,dataSetDr,yyItemSetDr,months,directDept)
 d ..DeleteBalanceAnalysis(costDistSetDr, dataSetDr, months)
 d ..AddZero(costDistSetDr,dataSetDr,months,directDept)
 d ..AddIncome(costDistSetDr,mzDeptSetDr,dataSetDr,yyItemSetDr, months)
 q $$$OK
}

ClassMethod DeleteBalanceAnalysis(costDistSetDr, dataSetDr, months) As %Status
{
 n (costDistSetDr, dataSetDr, months)
 s tmpRRNum=1
 f  s tmpDMon=$p(months,",",tmpRRNum) q:tmpDMon=""  d
 .s tmpRRNum=tmpRRNum+1
 .d ##class(dhc.ca.cache.udata.uReportResult).Delete("yysrgcb",tmpDMon,costDistSetDr,dataSetDr)
 q $$$OK
}

/// d ##class(dhc.ca.cache.udata.uReportResult).Insert("报表类别","核算周期","分摊方法套","数据分层套","金额^科室名称^科室层级^科室顺序^科室类别^项目名称^项目层级^项目顺序^项目类别^数据类别^科室Dr^项目Dr^来源科室名称^来源科室Dr^来源科室类别名称^来源科室类别Dr^来源科室类别排序")
ClassMethod AddZero(costDistSetDr, dataSetDr, months, directDept) As %Status
{
 n (costDistSetDr, dataSetDr, months, directDept)
 k ^tmpdhccadataleveltree
 s deptCountNum = ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getDatalevelSetSortedTree(directDept,0)
 d ..addDataNum()
 s tmpRRNum=1
 f  s tmpDMon=$p(months,",",tmpRRNum) q:tmpDMon=""  d
 .s tmpRRNum=tmpRRNum+1
 .s tmpTreeJob=""
 .f  s tmpTreeJob=$o(^tmpdhccadataleveltree(tmpTreeJob)) q:tmpTreeJob=""  d
 ..s tmpTreeType=""
 ..f  s tmpTreeType=$o(^tmpdhccadataleveltree(tmpTreeJob,tmpTreeType)) q:tmpTreeType=""  d
 ...s tmpTreeDr=""
 ...f  s tmpTreeDr=$o(^tmpdhccadataleveltree(tmpTreeJob,tmpTreeType,tmpTreeDr)) q:tmpTreeDr=""  d
 ....i tmpTreeType="trunk" d
 .....i $d(^DHCCADATALEVELSETS(tmpTreeDr)) d
 ......s tmpDeptName=$p(^DHCCADATALEVELSETS(tmpTreeDr),"^",2)
 ......s tmpDeptOrder=$p(^tmpdhccadataleveltree(tmpTreeJob,tmpTreeType,tmpTreeDr),"||",1)
 ......s tmpDeptNum=$p(^tmpdhccadataleveltree(tmpTreeJob,tmpTreeType,tmpTreeDr),"||",3)
 ......d ##class(dhc.ca.cache.udata.uReportResult).Insert("yysrgcb",tmpDMon,costDistSetDr,dataSetDr,"0^"_..getSpace(tmpDeptNum)_tmpDeptName_"^"_tmpDeptNum_"^"_tmpDeptOrder_"^0^0^0^^^^trunk_"_tmpTreeDr_"^-1^^^^^")
 ....i tmpTreeType="leaf" d
 .....i $d(^DHCCAALLDATAITEMS(tmpTreeDr)) d
 ......s tmpDeptName=$p(^DHCCAALLDATAITEMS(tmpTreeDr),"^",3)
 ......s tmpDeptOrder=$p(^tmpdhccadataleveltree(tmpTreeJob,tmpTreeType,tmpTreeDr),"||",1)
 ......s tmpDeptNum=$p(^tmpdhccadataleveltree(tmpTreeJob,tmpTreeType,tmpTreeDr),"||",3)
 ......d ##class(dhc.ca.cache.udata.uReportResult).Insert("yysrgcb",tmpDMon,costDistSetDr,dataSetDr,"0^"_..getSpace(tmpDeptNum)_tmpDeptName_"^"_tmpDeptNum_"^"_tmpDeptOrder_"^0^0^0^^^^leaf_"_tmpTreeDr_"^-1^^^^^")
 q $$$OK
}

/// Creator: 王赢赢
/// CreatDate: 2009-2-2
/// Description: 
/// Table：DeptLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uItemSummary).addDataNum()
ClassMethod addDataNum() As %String
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

/// Others: w ##class(dhc.ca.cache.report.uBalanceAnalysis1and2).AddIncome(1,58,1,23,"1,2,3")
ClassMethod AddIncome(costDistSetDr, mzDeptSetDr, dataSetDr, yyItemSetDr, months) As %Status
{
 n (costDistSetDr,mzDeptSetDr,dataSetDr,yyItemSetDr, months)
 s tmpRRNum=1
 f  s tmpDMon=$p(months,",",tmpRRNum) q:tmpDMon=""  d
 .s tmpRRNum=tmpRRNum+1
 .s tmpRowid=""
 .f  s tmpRowid=$o(^DHCCAINCOMEDATAS(0,"Interval",tmpDMon,tmpRowid)) q:tmpRowid=""  d
 ..s tmpIncome=^DHCCAINCOMEDATAS(tmpRowid)
 ..s tmpIncomeTDeptDr=$p(tmpIncome,"^",11) //开单
 ..s tmpIncomeItemDr=$p(tmpIncome,"^",6)
 ..s tmpIncomeType=$p(tmpIncome,"^",3) //门诊 O 住院 I 体检 E
 ..i (tmpIncomeTDeptDr'="")&&(tmpIncomeItemDr'="")&&$d(^DHCCAUNITDEPTS(tmpIncomeTDeptDr))&&$d(^DHCCAALLDATAITEMS(tmpIncomeItemDr)) d
 ...s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","yysrgcb",tmpDMon,costDistSetDr,dataSetDr,"leaf_"_tmpIncomeItemDr,"-1",""))
 ...i tmpRRid'="" d
 ....s tmpIncomeMoney=$p(tmpIncome,"^",7)
 ....i (tmpIncomeType="O")||(tmpIncomeType="E") d   // ..FindDeptType(tmpIncomeTDeptDr,mzDeptSetDr)="门诊" d
 .....s $p(^DHCCAREPORTRESULT(tmpRRid),"^",10)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",10)+tmpIncomeMoney
 ....e  d
 .....s $p(^DHCCAREPORTRESULT(tmpRRid),"^",11)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",11)+tmpIncomeMoney
 ....d ..AddIncomePar(tmpIncomeItemDr,tmpRRid,tmpIncomeItemDr,yyItemSetDr,tmpDMon,costDistSetDr,dataSetDr,tmpIncomeMoney,tmpIncomeType)
 q $$$OK
}

ClassMethod AddIncomePar(deptDr, RRid, itemDr, yyItemSetDr, tmpDMon, costDistSetDr, dataSetDr, money, incomeType) As %Status
{
 n (deptDr,RRid,itemDr,yyItemSetDr,tmpDMon,costDistSetDr,dataSetDr,money,incomeType)
 s tmpTreeJob=""
 f  s tmpTreeJob=$o(^tmpdhccadataleveltree(tmpTreeJob)) q:tmpTreeJob=""  d
 .s par=$p(^tmpdhccadataleveltree(tmpTreeJob,"leaf",deptDr),"||",2)
 .s tmpNum=1
 .f  s tmpPar=$p(par,"^",tmpNum) q:tmpPar=""  d
 ..s tmpNum=tmpNum+1 
 ..i $d(^tmpdhccadataleveltree(tmpTreeJob,"trunk",tmpPar)) d
 ...s tmpRRid=$o(^DHCCAREPORTRESULT(0,"RTIntDiDa","yysrgcb",tmpDMon,costDistSetDr,dataSetDr,"trunk_"_tmpPar,"-1",""))
 ...i (incomeType="O")||(incomeType="E") d
 ....s $p(^DHCCAREPORTRESULT(tmpRRid),"^",10)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",10)+money
 ...e  d
 ....s $p(^DHCCAREPORTRESULT(tmpRRid),"^",11)=$p(^DHCCAREPORTRESULT(tmpRRid),"^",11)+money
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

Storage Default
{
<Data name="HosIncomeConstituteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.HosIncomeConstituteD</DataLocation>
<DefaultData>HosIncomeConstituteDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.HosIncomeConstituteD</IdLocation>
<IndexLocation>^dhc.ca.c.HosIncomeConstituteI</IndexLocation>
<StreamLocation>^dhc.ca.c.HosIncomeConstituteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
