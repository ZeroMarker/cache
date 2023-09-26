Class web.DHCQCOutOfControlData Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod QueryOutOfControlDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOutOfControlDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCOutOfControlData","QueryOutOfControlData","AC1500","CA1500","CA1500","2014-3-31","2014-3-31","A^B^C^","",0)
ClassMethod QueryOutOfControlDataExecute(ByRef qHandle As %Binary, CurMachineCode As %String, MatCode As %String, LotCode As %String, StartDate As %String, EndDate As %String, RuleCode As %String, TCCode As %String, TCType As %String) As %Status
{
	//Set MachineCode="ACA530",MatCode="ACA5301",StartDate="2013-4-1",EndDate="2013-4-19",RuleCode="A^B^G^",TCCode="",TCType="1"
	Set DeptCode=$Get(DeptCode),CurMachineCode=$Get(CurMachineCode),MatCode=$Get(MatCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
	Set LevelNo=$Get(LevelNo),TCCode =$Get(TCCode)
	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set (TestDate,TestTime,CurTestCode,TestName,CurMatCode,CurLot,LevelNum,TestResult,TestRuleCode,TestRuleName,Note,ApprContent)=""
	Set Num=0
	//If $Data(^DHCQCIVi(MachineCode)) Do
	s MachineCode="" f  s MachineCode=$o(^DHCQCIVi(MachineCode)) q:MachineCode=""  d
	.i $l(CurMachineCode),MachineCode'=CurMachineCode q
	.For CurDate=StartDate:1:EndDate Do
	..If $Data(^DHCQCIVi(MachineCode,CurDate)) Do
	...//浓度水平，只能通过设置ID号判断
	...Set LevelNum="" For  Set LevelNum=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum)) Quit:LevelNum=""  Do
	....Set CurTestCode="" For  Set CurTestCode=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode)) Quit:CurTestCode=""  Do
	.....If $Length(TCCode),TCCode'=CurTestCode Quit
	.....Set SeqNo="" For  Set SeqNo=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,SeqNo)) Quit:SeqNo=""  Do
	......Set RowId="" For  Set RowId=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId)) Quit:RowId=""  Do
	.......Set ReceiveDate="" For  Set ReceiveDate=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId,ReceiveDate)) Quit:ReceiveDate=""  Do
	........Set OrdId="" For  Set OrdId=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId,ReceiveDate,OrdId)) Quit:OrdId=""  Do
	.........Set ReceiveData=$Get(^DHCQCIV(RowId,ReceiveDate,OrdId))
	.........//增加质控评价
	.........Set ApprContent=""
	.........Set APPOrd="" For  Set APPOrd=$Order(^DHCQCRULEAP(RowId,APPOrd)) Quit:APPOrd=""  Do
	..........If $Piece($Get(^DHCQCRULEAP(RowId,APPOrd)),"^",5)="N" Quit
	..........Set ApprContent=ApprContent_$Piece($Get(^DHCQCRULEAP(RowId,APPOrd)),"^",4)_" "
	.........Set RowId=RowId_"^"_ReceiveDate_"^"_OrdId
	.........//判断流水号根据备注字段判断
	.........Set LevelNo=$Piece($Piece(ReceiveData,"^",6),"||",3)
	.........s MatCode1=$Piece($Piece(ReceiveData,"^",6),"||",1)
	.........s MatCode1Name="",LotCode1Name=""  //增加名称叫法
	.........s LotCode1=$Piece($Piece(ReceiveData,"^",6),"||",2)
	.........i $l(MatCode1) s MatCode1Name=$Piece($Get(^DHCQCMAT(MatCode1)),"^",2)
	.........i $l(MatCode1),$l(LotCode1) s LotCode1Name=$Piece($Get(^DHCQCLOT(MatCode1,LotCode1)),"^",12)
	.........If $Length(LotCode),LotCode'=$Piece($Piece(ReceiveData,"^",6),"||",2) Quit
	.........If $Length(MatCode),MatCode'=$Piece($Piece(ReceiveData,"^",6),"||",1) Quit
	.........Set TestName=$Piece($Get(^TTAB("TC",CurTestCode)),"\",1)
	.........Set TestDate=$ZD($Piece(ReceiveData,"^",1),3)
	.........Set TestTime=$ZT($Piece(ReceiveData,"^",11))
	.........Set TestResult=$Piece($Get(ReceiveData),"^",3)
	.........Set UserId=$Piece($Get(ReceiveData),"^",10)
	.........Set TestRuleCode=$Piece($Get(ReceiveData),"^",15)
	.........Set TestRuleResult=$Piece($Get(ReceiveData),"^",16)
	.........//Set RowId=RowId_"^"_ReceiveDate_"^"_OrdId
	.........//失控的数据检索出来
	.........If TestRuleCode="" Quit
	.........If $Length(RuleCode),RuleCode'[TestRuleCode Quit
    .........//If $Length(TestRuleCode),TestRuleResult'="Reject" Quit
	.........Set Note=""
	.........If TestRuleResult="R" Set Note="失控"
	.........If TestRuleResult="W" Set Note="警告"
	.........If TestRuleResult="D" Quit
	.........Set TestRuleName=""
	.........If $Length(TestRuleCode) Set TestRuleName=$Piece($Get(^DHCQCRL(TestRuleCode)),"^",2)
	.........Set TestRemoveData=$Piece($Get(ReceiveData),"^",12)
	.........If TCType=0,TestRemoveData="1" Quit
	.........If TestRemoveData=2 Quit
	.........Set Num=Num+1
	.........//取失控数据后面的在控数据,靶值,偏倚%
	.........Set NextTestResult=##class(web.DHCQCOutOfControlData).QueryNextData(MachineCode,CurDate,LevelNum,CurTestCode,SeqNo) 
	.........s SetUpXString=##class(web.DHCQCMachineDataView).QuerySetUpXSD(MatCode1_"||"_LotCode1,CurTestCode,$Piece($Piece(ReceiveData,"^",6),"||",3), CurDate)
	.........Set SetUpX=$p(SetUpXString,"^",1)   //$P($Get(^DHCQCTC(MatCode1_"||"_LotCode1,CurTestCode,$Piece($Piece(ReceiveData,"^",6),"||",3))),"^",6)
	.........i SetUpX=0.0000001 s SetUpX=""
	.........s CalFH="" i $l(SetUpX) Set CalFH=$Tr($Fn(((TestResult-SetUpX)/SetUpX)*100,",",2),",")
	.........Do OutputRow
	If Num<1  Do 
	.Set (TestDate,TestTime,CurTestCode,TestName,MatCode1Name,LotCode1Name,LevelNo,TestResult,NextTestResult,SetUpX,CalFH,TestRuleCode,TestRuleName,Note,RowId,ApprContent)=""
	.Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(TestDate,TestTime,CurTestCode,TestName,MatCode1Name,LotCode1Name,LevelNo,TestResult,NextTestResult,SetUpX,CalFH,TestRuleCode,TestRuleName,Note,ApprContent,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// 增加查询同一天，取在控点值的函数  
ClassMethod QueryNextData(MachineCode, CurDate, LevelNum, CurTestCode, SeqNo)
{
   
    //New (MachineCode,CurDate,LevelNum,CurTestCode,SeqNo)
    Set TestResult=""
    Set nextSeqNo=SeqNo For  Set nextSeqNo=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,nextSeqNo)) Quit:nextSeqNo=""  Do
    .Set RowId="" For  Set RowId=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,nextSeqNo,RowId)) Quit:RowId=""  Do
    ..Set ReceiveDate="" For  Set ReceiveDate=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,nextSeqNo,RowId,ReceiveDate)) Quit:ReceiveDate=""  Do
    ...Set OrdId="" For  Set OrdId=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,nextSeqNo,RowId,ReceiveDate,OrdId)) Quit:OrdId=""  Do
    ....Set ReceiveData=$Get(^DHCQCIV(RowId,ReceiveDate,OrdId))
    ....Set TestRuleCode=$Piece($Get(ReceiveData),"^",16)
    ....If TestRuleCode="R" Quit
    ....If $Length(TestResult) Quit
    ....Set TestResult=$Piece($Get(ReceiveData),"^",3)
    Quit TestResult
}

ClassMethod QueryOutOfControlDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOutOfControlDataExecute ]
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
/// CreatDate：    20120301
/// Description:： 查询仪器失控数据
/// Table：        DHCQC_ItemValue
/// Input：        MachineCode:仪器代码，MatCode:质控批号,StartDate：开始日期，EndDate：结束日期，LevelNo：标示号，TestCode：测试项目
/// Output：       满足条件质控数据集合。
/// Return：       
/// Others：       LevelNo:浓度水平还需考虑进去
Query QueryOutOfControlData(MachineCode As %String, MatCode As %String, LotCode As %String, StartDate As %String, EndDate As %String, RuleCode As %String, TCCode As %String, TCType As %String) As %Query(ROWSPEC = "testdate:%String,testtime:%String,testcode:%String,testname:%String,matcode:%String,lotcode:%String,levelno:%String,testresult:%String,NextTestResult:%String,SetUpX:%String,CalFH:%String,testrulecode:%String,testrulename:%String,rulenote:%String,ApprContent:%String,RowId:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCQCOutOfControlDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCOutOfControlDataD</DataLocation>
<DefaultData>DHCQCOutOfControlDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCOutOfControlDataD</IdLocation>
<IndexLocation>^web.DHCQCOutOfControlDataI</IndexLocation>
<StreamLocation>^web.DHCQCOutOfControlDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
