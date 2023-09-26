Class web.DHCQCDataAddByPerson Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod AddQCDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AddQCDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCDataAddByPerson","AddQCData","2014-7-23","2014-7-23","^901^902^903","|A1130","^1^2^3^","CA1500","CA1500")
ClassMethod AddQCDataExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LevelNo As %String, TestCode As %String, LevelNum1, MatCode, LotCode) As %Status
{
	Set StartDate=$Get(StartDate),EndDate=$Get(EndDate)
	Set LevelNo=$Get(LevelNo),TestCode=$Get(TestCode)
	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
	If StartDate="" Quit
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set (CurTestCode,TestName,TestDate,TestTime,LevelNum,OrdId,TestResult,TestResultPosNeg,UserId,TestRuleCode,RowIdOrd,TestRuleName,SetUpX,SetUpSD,MatLotRowId)=""
	Set Visible="False",OrdId=1
	Set CheckFlag="True"
	//增加录入医嘱信息。
	For QCNum=1:1:$Length(LevelNo,"^") Do
	.Set QCId=$Piece(LevelNo,"^",QCNum)
	.If QCId="" Quit
	.Set LevelNum=QCId
	.For TestCodeNum=2:1:$Length(TestCode,"|") Do
	..Set CurTestCode=$Piece(TestCode,"|",TestCodeNum)
	..Set TestName=$Piece($Get(^TTAB("TC",CurTestCode)),"\",1)
	..For CurDate=StartDate:1:EndDate Do
	...Set TestDate=$ZD(CurDate,3)
	...Set TestTime=$ZT($Piece($H,",",2))
	...s levelNumId=$p(LevelNum1,"^",QCNum)
	...s MatLotRowId=MatCode_"||"_LotCode
	...s Ret=..QueryMeanSD(MatLotRowId,CurTestCode,levelNumId,CurDate)
	...s SetUpX=$p(Ret,"^",1),SetUpSD=$p(Ret,"^",2)
	...i SetUpX=0.0000001 s SetUpX=""
	...i SetUpSD=0.0000001 s SetUpSD=""
	...s MatLotRowId=MatLotRowId_"||"_levelNumId
	...Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(CheckFlag,CurTestCode,TestName,TestDate,TestTime,LevelNum,OrdId,TestResult,TestResultPosNeg,UserId,TestRuleCode,Visible,RowIdOrd,TestRuleName,SetUpX,SetUpSD,MatLotRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod AddQCDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AddQCDataExecute ]
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
/// CreatDate：    20130301
/// Description:： 手工添加仪器录入结果。
/// Table：        DHCQC_ItemValue
/// Input：        StartDate：开始日期，EndDate：结束日期，LevelNo：标示号，TestCode：测试项目,CurMatCode:质控物代码
/// Output：       生成满足条件质控数据集合。
/// Return：       
/// Others：       
Query AddQCData(StartDate As %String, EndDate As %String, LevelNo As %String, TestCode As %String, LevelNum1, MatCode, LotCode) As %Query(ROWSPEC = "CheckFlag:%String,testCode:%String,testName:%String,testdate:%String,testtime:%String,testId:%String,OrderId:%String,testResult:%String,TestResultPosNeg:%String,userID:%String,testrulecode:%String,Visible:%String,RowIdOrd:%String,testrulename:%String,SetUpX:%String,SetUpSD:%String,MatLotRowId") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20110531
/// Description:： 手工录入数据保存，总是保存成为新数据。
/// Table：        DHCQC_ItemValue
/// Input：        RecordData:仪器结果集合 
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCDataAddByPerson).SaveQCDataByPerson("")
ClassMethod SaveQCDataByPerson(RecordData As %String) As %String
{
	//Set RecordData="AC1500^2014-06-29^9001^A1130^^3.90^^^^^^2^demo^11:18:09^^^^^CA1500^CA1500^DHC-DATA^DHC-APP^RowId"
	Set MachCode=$Piece(RecordData,"^",1),QcId=$Piece(RecordData,"^",3),TcCode=$Piece(RecordData,"^",4)
	Set RecDate=$ZDH($Piece(RecordData,"^",2),3),OrderId=$Piece(RecordData,"^",5)
	If OrderId="" Set OrderId=1
	If $Data(^DHCQCIVi(MachCode,RecDate,QcId,TcCode)) Set OrderId=$Order(^DHCQCIVi(MachCode,RecDate,QcId,TcCode,""),-1)+1
	Set ParRef=MachCode_"||"_RecDate_"||"_QcId_"||"_TcCode_"||"_OrderId
	Set (MachineCode,DateRev,QCID,TestCode,OrderId)=""
	Kill PLIST
	Set MachineCode=$Piece(ParRef,"||",1),DateRev=$Piece(ParRef,"||",2),QCID=$Piece(ParRef,"||",3)
	Set TestCode=$Piece(ParRef,"||",4),OrderId=$Piece(ParRef,"||",5)
	///保存参数
	Set Result=$Piece(RecordData,"^",6),TestValue="",TestFlag=$Piece(RecordData,"^",8)
	//增加定性值换算。
	Set TestValue=##class(web.DHCQCTCResultTranslate).QueryTranResult(MachCode,TcCode,Result)
	Set Comments=$Piece(RecordData,"^",9),(ModDate,ModTime)=""
	//备注该为了保存质控RowId
	Set QCDate=$ZD(RecDate,3)
	Set RowId=##class(web.DHCQCMaterialQuery).MachMatLot(MachineCode,QcId,QCDate)
	Set DHCAPP=$Piece(RecordData,"^",21),DHCDATA=$Piece(RecordData,"^",22)
	//前台传上来的RowId
	s RowIdNew=$Piece(RecordData,"^",23)
	//取不到质控物及批次代码，自动退出。
	//If RowId="" Quit 0
	i $l(RowIdNew) s Comments=RowIdNew
	e  d
	.Set Comments=$Piece(RowId,"||",2,4)
	i '$l(Comments) q 0
	Set ResultFrom=2,UserDR=$Piece(RecordData,"^",13)
	Set RecTime=$ZTH($Piece(RecordData,"^",14),3),Rul="",(Exclude,Stute)="",SerDate=$P($h,",",1),SerTime=$P($h,",",2)
	Kill PLIST
	If '$Data(^DHCQCIV(ParRef,RecDate,OrderId)) Do
	.Set PLIST(2)=ParRef,PLIST(3)=RecDate,PLIST(4)=OrderId,PLIST(5)=Result,PLIST(6)=TestValue
	.Set PLIST(7)=TestFlag,PLIST(8)=Comments,PLIST(9)=ModDate,PLIST(10)=ModTime,PLIST(11)=ResultFrom
	.Set PLIST(12)=UserDR,PLIST(13)=RecTime,PLIST(14)=Exclude,PLIST(15)=SerDate,PLIST(16)=SerTime
	.Set PLIST(17)=Rul,PLIST(18)=Stute
	.Set PLIST(1)=ParRef_"||"_PLIST(3)_"||"_PLIST(4)
	.Set Ret=0
	.&SQL(Insert Into lab.DHCQC_ItemValue Values :PLIST())
	.Set Ret=SQLCODE
	.//计算质控规则
	.Set Ret=##class(web.DHCQCCalRules).AddQCRule(ParRef_"||"_RecDate_"||"_OrderId_"^"_RecDate_"^"_OrderId,DHCAPP,DHCDATA)
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20140619
/// Description:： 查询批次项目的靶值,标准差
/// Table：        QC_MaterialLot
/// Input：        MatLotRowId:批次代码,TCCode:项目代码,LevNo:浓度,QCDate:质控日期
///                
/// Output：       MEAN:标准差，SD：SD
/// Return：       0
/// Others：
/// d ##class(web.DHCQCDataAddByPerson).QueryMeanSD("")
ClassMethod QueryMeanSD(MatLotRowId, TCCode, LevNo, QCDate)
{
  Set MatLotData=$Get(^DHCQCTC(MatLotRowId,TCCode,LevNo))
  Set XSDFlag=$Piece(MatLotData,"^",12)
  Set MouthXSDFlag=$Piece(MatLotData,"^",13)
  Set (MEAN,SD)=""
  //If XSDFlag="Y" Do
  //.Set MEAN=$Piece(MatLotData,"^",9),SD=$Piece(MatLotData,"^",10)
  //Else  Do
  //.Set MEAN=$Piece(MatLotData,"^",6),SD=$Piece(MatLotData,"^",7)
  s SetUpXString=##class(web.DHCQCMachineDataView).QuerySetUpXSD(MatLotRowId, TCCode, LevNo, QCDate)
  Set MEAN=$Piece(SetUpXString,"^",1),SD=$Piece(SetUpXString,"^",2)
  If MouthXSDFlag="Y" Do
  .Set AccQCDate=$ZD(QCDate,3)
  .Set AccQCDateYear=$Piece(AccQCDate,"-",1),AccQCDateMouth=$Piece(AccQCDate,"-",2)
  .Set AccRowId=MatLotRowId_"||"_TCCode_"||"_LevNo
  .Set AccRet=..QueryAccXSD(AccRowId,AccQCDateYear,AccQCDateMouth)
  .Set MEAN=$Piece(AccRet,"^",1),SD=$Piece(AccRet,"^",2)
  Q MEAN_"^"_SD
}

/// Creator：      DaiYi
/// CreatDate：    20130301
/// Description:： 更新质控规则
/// Table：        DHCQC_itemvalue,^DHCQCLOT
/// Input：        QCRowId:RowId,QCDate:质控日期,QCOrdId：序号,RuleCode：质控规则,RuleStatus：质控状态
/// Output：       ""
/// Return：       0
/// Others： 
ClassMethod QueryAccXSD(RowId, QCYear, QCMouth)
{
	Set RowId=$Get(RowId),QCYear=$Get(QCYear),QCMouth=$Get(QCMouth)
	Set AccRet="^^"
	Set CurQCYear=QCYear,CurQCMouth=""
	//使用上一个月的靶值,标准差
	If QCMouth=1 Do
	.Set CurQCMouth=12,CurQCYear=CurQCYear-1
	Else  Do
	.Set CurQCMouth=QCMouth-1,CurQCYear=QCYear
	If $Data(^DHCQCAT(RowId,CurQCYear,CurQCMouth)) Do
	.Set StrAccData=$Get(^DHCQCAT(RowId,CurQCYear,CurQCMouth))
	.Set AccRet=$Piece(StrAccData,"^",4)_"^"_$Piece(StrAccData,"^",5)
	Else  Do
	.Set StrAccData=$Get(^DHCQCAT(RowId,QCYear,QCMouth))
	.Set AccRet=$Piece(StrAccData,"^",4)_"^"_$Piece(StrAccData,"^",5)
	Quit AccRet
}

Storage Default
{
<Data name="DHCQCDataAddByPersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCDataAddByPersonD</DataLocation>
<DefaultData>DHCQCDataAddByPersonDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCDataAddByPersonD</IdLocation>
<IndexLocation>^web.DHCQCDataAddByPersonI</IndexLocation>
<StreamLocation>^web.DHCQCDataAddByPersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
