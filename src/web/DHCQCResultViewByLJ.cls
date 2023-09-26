Class web.DHCQCResultViewByLJ Extends (%Persistent, %XML.Adaptor)
{

ClassMethod QueryQCResultsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryQCResultsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCResultViewByLJ","QueryQCResults","AC1500","CA1500","CA1500","A1130","2014-8-1","2014-8-30","1","")
ClassMethod QueryQCResultsExecute(ByRef qHandle As %Binary, MachineCode As %String, MetCode As %String, LotCode As %String, TCCode As %String, StartDate As %String, EndDate As %String, QCID As %String, MatRuleCode As %String) As %Status
{
	Set MachineCode=$Get(MachineCode),MetCode=$Get(MetCode),LotCode=$Get(LotCode),TCCode=$Get(TCCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
 	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3),QCID=$Get(QCID)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	If $Data(^DHCQCIVi(MachineCode)) Do
	.For CurDate=StartDate:1:EndDate Do
	..//满足条件的执行，这样处理减少查询的数据量.
	..If $Data(^DHCQCIVi(MachineCode,CurDate)) Do
	...Set CurQCId="" For  Set CurQCId=$Order(^DHCQCIVi(MachineCode,CurDate,CurQCId)) Quit:CurQCId=""  Do
	....//判断是否为当前的浓度
	....//Set Ret=##class(web.DHCQCMaterialQuery).MachineLevelNo(MachineCode,CurQCId,$ZD(CurDate,3))
	....//If '$Length(Ret) Quit
	....//If $Length(Ret),QCID'[Ret Quit
	....Set CurTCCode="" For  Set CurTCCode=$Order(^DHCQCIVi(MachineCode,CurDate,CurQCId,CurTCCode)) Quit:CurTCCode=""  Do
	.....If $Length(TCCode),TCCode'=CurTCCode Quit
	.....Set Ordid="" For  Set Ordid=$Order(^DHCQCIVi(MachineCode,CurDate,CurQCId,CurTCCode,Ordid)) Quit:Ordid=""  Do
	......Set Rowid="" For  Set Rowid=$Order(^DHCQCIVi(MachineCode,CurDate,CurQCId,CurTCCode,Ordid,Rowid)) Quit:Rowid=""  Do
	.......Set StrData=$Get(^DHCQCIV(Rowid,CurDate,Ordid))
	.......Set LevelNo=$Piece($Piece(StrData,"^",6),"||",3)
	.......If QCID'[LevelNo Quit
	.......If $Length(LotCode),LotCode'=$Piece($Piece(StrData,"^",6),"||",2) Quit
	.......If $Length(MetCode),MetCode'=$Piece($Piece(StrData,"^",6),"||",1) Quit
	.......Set TestDate=$ZD($Piece(StrData,"^",1),3)
	.......Set TestTime=$ZT($Piece(StrData,"^",11))
	.......Set TestTCName=$Piece($Get(^TTAB("TC",CurTCCode)),"\",1)
	.......//Set TCDecimal=$TR($Piece($Get(^TTAB("TC",CurTCCode)),"\",3),"N")
	.......Set TCDecimal=$TR($Get(^DHCQCTC(MetCode_"||"_LotCode,CurTCCode,$Piece($Piece(StrData,"^",6),"||",3))),"^",8)
	.......Set TestResult=$Fn($Piece(StrData,"^",3),",",TCDecimal)
	.......//取参考范围
	.......Set ParRef=$Piece(StrData,"^",6)
	.......Set TestRejRule=$Piece(StrData,"^",15),TestRejRuleName=""
	.......If $l(TestRejRule),$l(MatRuleCode),((MatRuleCode'[TestRejRule)) Quit
	.......If $Length(TestRejRule) Set TestRejRuleName=$Piece($Get(^DHCQCRL(TestRejRule)),"^",2)
    .......Set TestRemoveData=$Piece($Get(StrData),"^",12)
	.......If TestRemoveData="" Set TestRemoveData="N"
	.......If TestRemoveData="0" Set TestRemoveData="N"
	.......If TestRemoveData="1" Set TestRemoveData="Y"
	.......//删除,排除
	.......If TestRemoveData=2 Quit
    .......If TestRemoveData="1" Quit
	.......Set TestDateTime=TestDate_" "_TestTime
	.......Set RetQCID=LevelNo
	.......//查询失控记录
	.......Set ApprContent=""
	.......Set APPOrd="" For  Set APPOrd=$Order(^DHCQCRULEAP(Rowid,APPOrd)) Quit:APPOrd=""  Do
	........If $Piece($Get(^DHCQCRULEAP(Rowid,APPOrd)),"^",5)="N" Quit
	........Set ApprContent=$Piece($Get(^DHCQCRULEAP(Rowid,APPOrd)),"^",4)_" "_ApprContent
	.......s RowIdOrd=Rowid_"^"_CurDate_"^"_Ordid
	.......//b ;11
	.......Do OutputRow	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
    Set Data=$lb(TestDate,TestTime,CurTCCode,TestTCName,TestResult,Ordid,TestRejRule,RetQCID,TestRejRuleName,ApprContent,RowIdOrd)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryQCResultsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryQCResultsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20120321
/// Description:： 质控数据查询
/// Table：        DHCQC_ItemValue
/// Input：        MachineCode:仪器代码,MetCode:质控物代码,LotCode:质控批号,TCCode:项目代码,StartDate:开始日期,EndDate:结束日期,
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QueryQCResults(MachineCode As %String, MetCode As %String, LotCode As %String, TCCode As %String, StartDate As %String, EndDate As %String, QCID As %String, MatRuleCode As %String) As %Query(ROWSPEC = "TestDate:%String,TestTime:%String,TCCode:%String,TCName:%String,TestResults:%String,TestOrder:%String,RejRul:%String,RetQCID:%String,TestRejRuleName:%String,ApprContent:%String,RowIdOrd") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCQCResultViewByLJDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCResultViewByLJD</DataLocation>
<DefaultData>DHCQCResultViewByLJDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCResultViewByLJD</IdLocation>
<IndexLocation>^web.DHCQCResultViewByLJI</IndexLocation>
<StreamLocation>^web.DHCQCResultViewByLJS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
