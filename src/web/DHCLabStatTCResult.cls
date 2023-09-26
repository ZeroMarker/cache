Class web.DHCLabStatTCResult Extends %Persistent
{

/// Creator：     		 余渊	
/// CreatDate：    		 2014-11-11
/// Description:：       查询某个时间段内所有的标本信息
/// Table：       		 EP_VisitNumber，EP_VisitTestSetData，EP_VisitTestSet
/// Input：              SDate：开始审核时间 EDate：结束审核时间 时间格式：2014-11-11
/// Output：             标本号||医嘱||检验项目代码||名称||审核日期||科室代码||流水号||登记号||病人姓名||性别||年龄||支付类别||申请科室||结果||单位||参考范围
/// Return：             无
/// Others：             无
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTCResult","TestQuery","")
Query TestQuery(SDate As %String, EDate As %String) As %Query(ROWSPEC = "VisitNumber:%String,TestSet:%String,TestCode:%String,TCDesc:%String,DateOfAuthorisation:%String,DepCode:%String,Epis:%String,DebtorNumber:%String,Surname:%String,Sex:%String,Age:%String,CategoryType:%String,CliDep:%String,Result:%String,DHC:%String,Ranges:%String") [ SqlProc ]
{
}

ClassMethod TestQueryExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
 	S repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s SDate=$g(SDate),EDate=$g(EDate)
 	i SDate="",EDate=""    d  s SDate=$zd(+$h,3),EDate=$zd(+$h,3)
 	s SDate=$zdh(SDate,3),EDate=$zdh(EDate,3)
	s (VisitNumber,TestSet,TestCod,TestData,TestSetCounter,TestCode)=""
	f  s VisitNumber=$o(^TEPI(VisitNumber)) q:VisitNumber=""   d
	.f  s TestSet=$o(^TEPI(VisitNumber,1,TestSet)) q:TestSet=""  d
	..f  s TestSetCounter=$o(^TEPI(VisitNumber,1,TestSet,TestSetCounter)) q:TestSetCounter=""  d
	...s DateOfAuthorisation=$p(^TEPI(VisitNumber,1,TestSet,TestSetCounter),"\",4)
	...i DateOfAuthorisation>=SDate,DateOfAuthorisation<=EDate  d    //时间判断
	....f  s TestCode=$o(^TEPI(VisitNumber,1,TestSet,TestSetCounter,"DATA",TestCode)) q:TestCode=""  d
	.....s TestData=^TEPI(VisitNumber,1,TestSet,TestSetCounter,"DATA",TestCode)
	.....d SpecimenInfo
 	s qHandle=$lb(0,repid,0)
	q $$$OK

SpecimenInfo
  // ---------------------------------病人信息
   s DebtorNumber=$p(^TEPI(VisitNumber),"\",18)
   s Surname=$p(^TEPI(VisitNumber),"\")
   s Sex=$p(^TEPI(VisitNumber),"\",3)  
   s Age=$p(^TEPI(VisitNumber),"\",25)
   s PayType=$p(^TEPI(VisitNumber),"\",49) 
   s CliDep=$p(^TEPI(VisitNumber),"\",36)
  // ---------------------------------标本信息
   s TCDesc=$tr($p(^TTAB("TC",TestCode),"\"),"*")  
   s DateOfAuthorisation=$p(^TEPI(VisitNumber,1,TestSet,1),"\",4)
   s DateOfAuthorisation=$zd(DateOfAuthorisation,3)  
   s DepCode=$e(TestCode)
   s Epis=$p(^TEPI(VisitNumber,1,TestSet,TestSetCounter),"\",12)
   s Result=$p(^TEPI(VisitNumber,1,TestSet,TestSetCounter,"DATA",TestCode),"\")
   s DHC=$tr(^TEPI(VisitNumber,1,TestSet,TestSetCounter,"DATA",TestCode,"DHC"),"\")
   s Ranges=^TEPI(VisitNumber,1,TestSet,TestSetCounter,"DATA",TestCode,"Ranges")
   s Data=$lb(VisitNumber,TestSet,TestCode,TCDesc,DateOfAuthorisation,DepCode,Epis,DebtorNumber,Surname,Sex,Age,CategoryType,CliDep,Result,DHC,Ranges)
   d OutputRow6
   s qHandle=$lb(0,repid,0)
   q $$$OK

   
	
OutputRow6
   s Data=$lb(VisitNumber,TestSet,TestCode,TCDesc,DateOfAuthorisation,DepCode,Epis,DebtorNumber,Surname,Sex,Age,PayType,CliDep,Result,DHC,Ranges)
   s ^CacheTemp(repid,ind)=Data
   s ind=ind+1
   q
}

ClassMethod TestQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TestCodeExecute ]
{
 	s AtEnd=$LIST(qHandle,1)
 	s repid=$LIST(qHandle,2)
 	s ind=$LIST(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" 	d		// if there are no more rows, finish fetching
    .s AtEnd=1
 	.s Row=""
 	e  d      			// fetch row
 	.s Row=^CacheTemp(repid,ind)
 	s qHandle=$lb(AtEnd,repid,ind) 	// Save QHandle
	q $$$OK
}

ClassMethod TestQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TestCodeExecute ]
{
	s repid=$LIST(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Storage Default
{
<Data name="DHCLabStatTCResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatTCResultD</DataLocation>
<DefaultData>DHCLabStatTCResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatTCResultD</IdLocation>
<IndexLocation>^web.DHCLabStatTCResultI</IndexLocation>
<StreamLocation>^web.DHCLabStatTCResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
