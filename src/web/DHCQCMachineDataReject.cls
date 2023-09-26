Class web.DHCQCMachineDataReject Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod QueryQCDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryQCDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachineDataView","QueryQCData","","","","","","")
ClassMethod QueryQCDataExecute(ByRef qHandle As %Binary, MachineCode As %String, StartDate As %String, EndDate As %String, LevelNo As %String, TestCode As %String, TCType As %String) As %Status
{
	//Set MachineCode="ACA530",StartDate="2012-6-19",EndDate="2012-6-19",LevelNo="^1^2^3",TestCode="|A0490|A0500|A0510|A0520|A0530|A0540",TCType="1"
	Set MachineCode=$Get(MachineCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
	Set LevelNo=$Get(LevelNo),TestCode=$Get(TestCode)
	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
	If MachineCode="" Quit
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	If $Data(^DHCQCIVi(MachineCode)) Do
	.For CurDate=StartDate:1:EndDate Do
	..If $Data(^DHCQCIVi(MachineCode,CurDate)) Do
	...//浓度水平，只能通过设置ID号判断。
	...Set LevelNum="" For  Set LevelNum=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum)) Quit:LevelNum=""  Do
	....Set CurTestCode="" For  Set CurTestCode=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode)) Quit:CurTestCode=""  Do
	.....Set SeqNo="" For  Set SeqNo=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,SeqNo)) Quit:SeqNo=""  Do
	......Set RowId="" For  Set RowId=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId)) Quit:RowId=""  Do
	.......Set ReceiveDate="" For  Set ReceiveDate=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId,ReceiveDate)) Quit:ReceiveDate=""  Do
	........Set OrdId="" For  Set OrdId=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId,ReceiveDate,OrdId)) Quit:OrdId=""  Do
	.........Set ReceiveData=$Get(^DHCQCIV(RowId,ReceiveDate,OrdId))
	.........Set TestName=$Piece($Get(^TTAB("TC",CurTestCode)),"\",1)
	.........Set TestDate=$ZD($Piece(ReceiveData,"^",1),3)
	.........Set TestTime=$ZT($Piece(ReceiveData,"^",11))
	.........Set TestResult=$Piece($Get(ReceiveData),"^",3)
	.........Set UserId=$Piece($Get(ReceiveData),"^",10)
	.........Set TestRuleCode=$Piece($Get(ReceiveData),"^",15)
	.........Set TestRuleName=""
	.........If $Length(TestRuleCode) Set TestRuleName=$Piece($Get(^DHCQCRL(TestRuleCode)),"^",2)
	.........Set TestRemoveData=$Piece($Get(ReceiveData),"^",12)
	.........If TestRemoveData="" Set TestRemoveData="N"
	.........If TestRemoveData="0" Set TestRemoveData="N"
	.........If TestRemoveData="1" Set TestRemoveData="Y"
	.........//删除的排除
	.........If TestRemoveData=2 Quit
	.........Set Visible=TestRemoveData
	.........Set RowId=RowId_"^"_ReceiveDate_"^"_OrdId
	.........Do OutputRow	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(CurTestCode,TestName,TestDate,TestTime,LevelNum,OrdId,TestResult,UserId,TestRuleCode,Visible,RowId,TestRuleName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryQCDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryQCDataExecute ]
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
/// CreatDate：    20120619
/// Description:： 失控数据查询
/// Table：        DHCQC_ItemValue
/// Input：        MachineCode:仪器代码，StartDate：开始日期，EndDate：结束日期，LevelNo：标示号，TestCode：测试项目
/// Output：       满足条件质控数据集合。
/// Return：       
/// Others：       LevelNo:浓度水平还需考虑进去
Query QueryQCData(MachineCode As %String, StartDate As %String, EndDate As %String, LevelNo As %String, TestCode As %String, TCType As %String) As %Query(ROWSPEC = "testCode:%String,testName:%String,testdate:%String,testtime:%String,testId:%String,OrderId:%String,testResult:%String,userID:%String,testrulecode:%String,Visible:%String,RowId:%String,testrulename:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCQCMachineDataRejectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCMachineDataRejectD</DataLocation>
<DefaultData>DHCQCMachineDataRejectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCMachineDataRejectD</IdLocation>
<IndexLocation>^web.DHCQCMachineDataRejectI</IndexLocation>
<StreamLocation>^web.DHCQCMachineDataRejectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
