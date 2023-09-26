/// 质控数据浏览
Class web.DHCQCMachineDataView Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator：      DaiYi
/// CreatDate：    20150129
/// Description:： 仪器项目是否存在判断.
/// Table：        ct_testcode
/// Input：        TestCode,CurTestCode
/// Output：       0：不存在  1:存在
/// Return：       Levels:浓度个数
/// Others：
/// d ##class(web.DHCQCMachineDataView).QueryTCIsFlag("|A1130|A1140|A1150|A1160|A1170|A1180","A11800")
ClassMethod QueryTCIsFlag(TestCode As %String(MAXLEN=32767), CurTestCode) As %String
{
 s IsFlag=0
 i '$l(TestCode) q 1
 i $l(CurTestCode) d
 .f i=1:1:$l(TestCode,"|") d
 ..i $p(TestCode,"|",i)=CurTestCode s IsFlag=1
 ..i IsFlag=1 s i=$l(TestCode,"|")
 e  d
 .s IsFlag=1
 q IsFlag
}

/// Creator：      DaiYi
/// CreatDate：    20150421
/// Description:： 根据项目代码查询名称和缩写
/// Table：        ct_testcode
/// Input：        TestCode
/// Output：       项目名称和缩写
/// Return：       
/// Others：
/// d ##class(web.DHCQCMachineDataView).QueryTCNameUnit("A0010")
ClassMethod QueryTCNameUnit(TestCode) As %String
{
 s TestCode=$g(TestCode)
 i '$l(TestCode) q $c(9,9)
 s TCName=$tr($tr($P($g(^TTAB("TC",TestCode)),"\",1),$c(13)),$c(10))
 s TCUnit=$tr($tr($P($g(^TTAB("TC",TestCode)),"\",12),$c(13)),$c(10))
 q $c(9)_TCName_$c(9)_TCUnit
}

ClassMethod QueryQCDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryQCDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachineDataView","QueryQCData","AOMNIS","2015-6-1","2015-6-30","","","","","","")
ClassMethod QueryQCDataExecute(ByRef qHandle As %Binary, MatCode, StartDate, EndDate, LevelNo, TestCode As %String(MAXLEN=32767), TCType, LotCode, CurMatCode, RuleCode) As %Status
{
	Set MatCode=$Get(MatCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
	Set LevelNo=$Get(LevelNo),TestCode=$Get(TestCode),CurMatCode=$Get(CurMatCode)
	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3),RuleCode=$Get(RuleCode)

	If MatCode="" Quit
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set CheckFlag="False"
	
	If $Data(^DHCQCIVi(MatCode)) Do
	.For CurDate=StartDate:1:EndDate Do
	..If $Data(^DHCQCIVi(MatCode,CurDate)) Do
	...//浓度水平，只能通过设置ID号判断
	...Set LevelNum="" For  Set LevelNum=$Order(^DHCQCIVi(MatCode,CurDate,LevelNum)) Quit:LevelNum=""  Do
	....Set CurTestCode="" For  Set CurTestCode=$Order(^DHCQCIVi(MatCode,CurDate,LevelNum,CurTestCode)) Quit:CurTestCode=""  Do
	.....//项目控制
	.....b ;3
	.....s Ret=##class(web.DHCQCMachineDataView).QueryTCIsFlag(TestCode,CurTestCode)
	.....b ;4
	.....i Ret=0 q
	.....Set SeqNo="" For  Set SeqNo=$Order(^DHCQCIVi(MatCode,CurDate,LevelNum,CurTestCode,SeqNo)) Quit:SeqNo=""  Do
	......Set RowId="" For  Set RowId=$Order(^DHCQCIVi(MatCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId)) Quit:RowId=""  Do
	.......Set ReceiveDate="" For  Set ReceiveDate=$Order(^DHCQCIVi(MatCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId,ReceiveDate)) Quit:ReceiveDate=""  Do
	........Set OrdId="" For  Set OrdId=$Order(^DHCQCIVi(MatCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId,ReceiveDate,OrdId)) Quit:OrdId=""  Do
	.........Set ReceiveData=$Get(^DHCQCIV(RowId,ReceiveDate,OrdId))
	.........//判断流水号根据备注字段判断
	.........b ;1
	.........Set QCId=$Piece($Piece(ReceiveData,"^",6),"||",3)
	.........i $l(LevelNo),LevelNo'[QCId Quit
	.........If $l(LotCode),LotCode'=$Piece($Piece(ReceiveData,"^",6),"||",2) Quit
	.........If $l(CurMatCode),CurMatCode'=$Piece($Piece(ReceiveData,"^",6),"||",1) Quit
	.........//查询设定或者计算的靶值标准差。DaiYi 2013-04-07
	.........Set QCIVRowId=$Piece($Piece(ReceiveData,"^",6),"||",1,2)
	.........//Set SetUpXString=$Get(^DHCQCTC(QCIVRowId,CurTestCode,QCId))
	.........s SetUpXString=##class(web.DHCQCMachineDataView).QuerySetUpXSD(QCIVRowId,CurTestCode,QCId,CurDate)
	.........//Set CalDecimal=+$Tr($Piece(SetUpXString,"^",8)," ")
	.........//If CalDecimal="" Set CalDecimal=2
	.........Set SetUpX="",SetUpSD=""
	.........//Set XSDFlag=$Piece($Get(SetUpXString),"^",12)
	.........//If XSDFlag="N" Set SetUpX=$Fn(+$Piece(SetUpXString,"^",6),",",CalDecimal),SetUpSD=$Fn(+$Piece(SetUpXString,"^",7),",",CalDecimal)
	.........//If XSDFlag="Y" Set SetUpX=$Fn(+$Piece(SetUpXString,"^",9),",",CalDecimal),SetUpSD=$Fn(+$Piece(SetUpXString,"^",10),",",CalDecimal)
    .........s SetUpX=$p(SetUpXString,"^",1),SetUpSD=$p(SetUpXString,"^",2)
	.........If SetUpX="0.00"||SetUpX="0.0"||SetUpX="0"||(SetUpX<0.0000002) Set SetUpX=""
	.........If SetUpSD="0.00"||SetUpSD="0.0"||SetUpSD="0"||(SetUpX<0.0000002) Set SetUpSD=""
	.........//增加按月靶值计算显示
	.........Set MouthXSDFlag=$Piece($Get(SetUpXString),"^",13)
	.........If MouthXSDFlag="Y" Do
	..........Set AccRowId=QCIVRowId_"||"_CurTestCode_"||"_QCId
	..........Set AccQCDate=$ZD(CurDate,3),AccYear=$Piece(AccQCDate,"-",1),AccMouth=$Piece(AccQCDate,"-",2)
	..........Set AccMouthRet=##class(web.DHCQCLotInformation).QueryAccXSD(AccRowId,AccYear,AccMouth)
	..........Set SetUpX=$Piece(AccMouthRet,"^",1),SetUpSD=$Piece(AccMouthRet,"^",2)
	.........Set TestName=$Piece($Get(^TTAB("TC",CurTestCode)),"\",1)
	.........Set TestDate=$ZD($Piece(ReceiveData,"^",1),3)
	.........Set TestTime=$ZT($Piece(ReceiveData,"^",11))
	.........Set TestResult=$Piece($Get(ReceiveData),"^",3)
	.........//增加定性值结果显示 DaiYi 2013-06-15
	.........Set TestResultPosNeg=$Piece($Get(ReceiveData),"^",4)
	.........Set UserId=$Piece($Get(ReceiveData),"^",10)
	.........Set TestRuleCode=$Piece($Get(ReceiveData),"^",15)
	.........If $l(RuleCode),RuleCode'[TestRuleCode Quit 
	.........Set TestRuleName=""
	.........If $Length(TestRuleCode) Set TestRuleName=$Piece($Get(^DHCQCRL(TestRuleCode)),"^",2)
	.........Set TestRemoveData=$Piece($Get(ReceiveData),"^",12)
	.........If TestRemoveData="" Set TestRemoveData="false"
	.........If TestRemoveData="0" Set TestRemoveData="false"
	.........If TestRemoveData="1" Set TestRemoveData="true"
	.........//删除的排除
	.........If TestRemoveData=2 Quit
	.........Set Visible=TestRemoveData
	.........//i TestRemoveData=1 s Visible="true"
	.........Set RowIdOrd=RowId_"^"_ReceiveDate_"^"_OrdId
	.........//增加批次维护信息。如果维护了批次，就按照总的批次。
	.........s LotName=$p($g(^DHCQCLOT($p($p(ReceiveData,"^",6),"||",1),$p($p(ReceiveData,"^",6),"||",2))),"^",12),LotNameLevel=""
	.........Set CurData=^DHCQCTC($p($p(ReceiveData,"^",6),"||",1,2),CurTestCode,$p($p(ReceiveData,"^",6),"||",3))
    .........s LotNameLevel=$p(CurData,"^",5)
    .........i LotNameLevel="" s LotNameLevel=LotName
	.........Do OutputRow	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(CheckFlag,CurTestCode,TestName,TestDate,TestTime,LevelNum,OrdId,TestResult,TestRuleName,UserId,TestRuleCode,Visible,RowIdOrd,SetUpX,SetUpSD,TestResultPosNeg,LotNameLevel)
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
/// CreatDate：    20120301
/// Description:： 仪器质控数据查询
/// Table：        DHCQC_ItemValue
/// Input：        MatCode:仪器代码，StartDate：开始日期，EndDate：结束日期，LevelNo：标示号，TestCode：测试项目,CurMatCode:质控物代码
/// Output：       满足条件质控数据集合。
/// Return：       
/// Others：       LevelNo:浓度水平还需考虑进去
Query QueryQCData(MatCode, StartDate, EndDate, LevelNo, TestCode As %String(MAXLEN=32767), TCType, LotCode, CurMatCode, RuleCode) As %Query(ROWSPEC = "CheckFlag:%String,testCode:%String,testName:%String,testdate:%String,testtime:%String,testId:%String,OrderId:%String,testResult:%String,testrulename:%String,userID:%String,testrulecode:%String,Visible:%String,RowIdOrd:%String,SetUpX:%String,SetUpSD:%String,TestResultPosNeg:%String,LotNameLevel") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20140905
/// Description:： 查询按月或者默认设置的靶值标准差
/// Table：        DHCQC_ItemValue
/// Input：        MatCode:仪器代码，StartDate：开始日期，EndDate：结束日期，LevelNo：标示号，TestCode：测试项目,CurMatCode:质控物代码
/// Output：       满足条件质控数据集合。
/// Return：       
/// Others：       LevelNo:浓度水平还需考虑进去
/// d ##class(web.DHCQCMachineDataView).QuerySetUpXSD("CA1500||CA1500","A1150",1,63369)
ClassMethod QuerySetUpXSD(QCIVRowId, CurTestCode, QCId, QCDate)
{
	s Ret=""
	s SetUpXSDStrData=$Get(^DHCQCTC(QCIVRowId,CurTestCode,QCId))
	Set Decimal=$Tr($Piece(SetUpXSDStrData,"^",8)," ")
	i Decimal="" s Decimal=2
	//s CalX=$Fn(+$Piece(SetUpXSDStrData,"^",9),"",Decimal)
	s CalX=$Piece(SetUpXSDStrData,"^",9)
	i CalX="" s CalX="0.0000001"
	i CalX>0.0000001 s CalX=$fn(CalX,"",Decimal)
	//s CalSD=$Fn(+$Piece(SetUpXSDStrData,"^",10),"",Decimal)
	s CalSD=+$Piece(SetUpXSDStrData,"^",10)
	i CalSD>0.0000001 s CalSD=$fn(CalSD,"",Decimal)
	i CalSD="" s CalSD="0.0000001"
	s CalCV=0.0000001,SetUpCV=0.0000001
	i CalX>0.0000001 s CalCV=$fn(100*(CalSD/CalX),"",Decimal)
	Set XSDFlag=$Piece($Get(SetUpXSDStrData),"^",12)
	i XSDFlag="N" d
	.s SetUpX=$Piece(SetUpXSDStrData,"^",6),SetUpSD=$Piece(SetUpXSDStrData,"^",7)
	.i SetUpX="" s SetUpX="0.0000001"
	.i SetUpSD="" s SetUpSD="0.0000001"
	.i SetUpX'="0.0000001" s Ret=$Fn(+SetUpX,"",Decimal)_"^"_$Fn(+SetUpSD,"",Decimal)
	.e  s Ret=0.0000001_"^"_0.0000001
	.i +SetUpX>0.000001 s SetUpCV=$Fn(100*($Piece(SetUpXSDStrData,"^",7)/$Piece(SetUpXSDStrData,"^",6)),"",Decimal)
	e  d
	.i $Piece(SetUpXSDStrData,"^",9)'="" s Ret=CalX_"^"_CalSD
	.e  s Ret=0.0000001_"^"_0.0000001
	.i $Fn(+$Piece(SetUpXSDStrData,"^",9),"",Decimal)>0 s SetUpCV=$fn(100*($Piece(SetUpXSDStrData,"^",10)/$Piece(SetUpXSDStrData,"^",9)),"",Decimal)
	s CurQCDate=$zd(QCDate,3)
	s CurYear=+$p(CurQCDate,"-",1),CurMouth=+$p(CurQCDate,"-",2)
	i (XSDFlag="N"),($d(^DHCQCTCM(QCIVRowId_"||"_CurTestCode,QCId,CurYear,CurMouth))) d
	.s RetData=$g(^DHCQCTCM(QCIVRowId_"||"_CurTestCode,QCId,CurYear,CurMouth))
	.i ($p(RetData,"^",2)="") s Ret=0.0000001_"^"_0.0000001
	.e  s Ret=$Fn($p(RetData,"^",2),"",Decimal)_"^"_$Fn($p(RetData,"^",3),"",Decimal)
	.i $Fn($p(RetData,"^",3),"",Decimal)>0 s SetUpCV=$Fn((100*$p(RetData,"^",3))/($p(RetData,"^",2)),"",Decimal)
	s Ret=Ret_"^"_CalX_"^"_CalSD_"^"_CalCV_"^"_SetUpCV
	q Ret
}

/// Creator：      DaiYi
/// CreatDate：    20110802
/// Description:： 更新仪器质控数据
/// Table：        DHCQC_ItemValue
/// Input：        RowId:记录唯一代码,ExcludeFlag:排除标志:是否排除数据点(0:正常,1:排除,2:删除)
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCMachineDataView).UpdateMachineQCData("AOMNIS||63706||1||A0910||1^63706^1","234^21:07:24","demo")
ClassMethod UpdateMachineQCData(RowId As %String, Result As %String, UserId As %String) As %String
{
	Set RowId=$Get(RowId),Result=$Get(Result),UserId=$Get(UserId)
	s DQIVTime=$p(Result,"^",2)
	s Result=$p(Result,"^",1)
	i $l(DQIVTime) s DQIVTime=$zth(DQIVTime)
	Set ParRef=$Piece(RowId,"^",1),DQIVDate=+$Piece(RowId,"^",2),OrderId=+$Piece(RowId,"^",3)
	Set Ret="1"
	If $Data(^DHCQCIV(ParRef,DQIVDate,OrderId)) Do
	.//保存日志 2013-06-07 DaiYi
	.Set RecordStr="数据浏览^"_Result_"^"_UserId_"^"
	.If $Piece(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",3)'=Result,$Piece(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",10)'=UserId Do
	..Set Ret=##class(web.DHCQCResultLog).InsertLog(RowId,RecordStr)
	.Set $Piece(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",3)=Result
	.Set $Piece(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",10)=UserId
	.i $l(DQIVTime) s $p(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",11)=DQIVTime
	.//s ^TMP("DHCC11")=Result_"!"_UserId_"!"_DQIVTime
	.//判断是否有定性的结果，如果有定性结果，就把原始结果给保存进来
	.Set CurTCCode=$Piece(ParRef,"||",4)  //项目代码
	.Set MatLotRowId="",CurMachCode=""
	.If $Length(ParRef) Set MatLotRowId=$Piece($Get(^DHCQCIV(ParRef,$Piece(ParRef,"||",2),$Piece(ParRef,"||",5))),"^",6)
	.If $Length(MatLotRowId) Set CurMachCode=$Piece($Get(^DHCQCMAT($Piece(MatLotRowId,"||",1))),"^",3)
    .Set Ret=##class(web.DHCQCTCResultTranslate).QueryTranResult(CurMachCode,CurTCCode,Result)
    .Set $Piece(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",4)=Ret
	.//&SQL(Update lab.DHCQC_ItemValue  Set DQIV_Exclude=:ExcludeFlag Where DQIV_ParRef=:ParRef And DQIV_Date=:DQIVDate And DQIV_Order=:OrderId )
	.//Set Ret=SQLCODE
	.Set Ret=0
	.//增加计算当前批号项目结果的统计情况 DaiYi 2015-06-03
	.s MatCode=$p(MatLotRowId,"||",1)
	.s LotCode=$p(MatLotRowId,"||",2)
	.s epis=$p(MatLotRowId,"||",3)
	.Set Ret=##class(web.DHCQCAccTotal).AccTCTotal(CurMachCode,MatCode,LotCode,$zd(DQIVDate,3),CurTCCode,epis)
	Else  Set Ret="1"
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20110802
/// Description:： 更新质控数据排除点。
/// Table：        DHCQC_ItemValue : DQIV_Exclude 改为1
/// Input：        RowId:记录唯一代码
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCMachineDataView).UpdateQCExcludeFlag("AC1500||63474||9001||A1130||2^63474^2","1","demo")
ClassMethod UpdateQCExcludeFlag(RowId As %String, ExcludeFlag As %String, UserId As %String) As %String
{
	Set RowId=$Get(RowId),ExcludeFlag=$Get(ExcludeFlag)
	Set ParRef=$PIece(RowId,"^",1),DQIVDate=+$Piece(RowId,"^",2),OrderId=+$Piece(RowId,"^",3)
	Set Ret="1"
	//"ASK530||62841||902||A2010||6^62841^6"
	If $Data(^DHCQCIV(ParRef,DQIVDate,OrderId)) Do
	.//保存日志 2013-06-07 DaiYi
	.If ExcludeFlag="0" Set RecordStr="数据浏览/录入^去除排除"_"^"_UserId_"^"
	.If ExcludeFlag="1" Set RecordStr="数据浏览/录入^排除"_"^"_UserId_"^"
	.If ExcludeFlag="2" Set RecordStr="数据浏览/录入^删除"_"^"_UserId_"^"
	.Set Ret=##class(web.DHCQCResultLog).InsertLog(RowId,RecordStr)
	.//增加反排除功能 DY 2014-08-07
	.//i $p(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",12)=1,ExcludeFlag=1 s $Piece(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",12)=0
	.//i $p(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",12)=0,ExcludeFlag=1  s $Piece(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",12)=1
	.//i $p(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",12)="",ExcludeFlag=1  s $Piece(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",12)=1
	.s $Piece(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",12)=ExcludeFlag
	.i ExcludeFlag=2 Set $Piece(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",12)=ExcludeFlag
	.Set $Piece(^DHCQCIV(ParRef,DQIVDate,OrderId),"^",10)=UserId
	.//&SQL(Update lab.DHCQC_ItemValue  Set DQIV_Exclude=:Result Where DQIV_ParRef=:ParRef And DQIV_Date=:DQIVDate And DQIV_Order=:OrderId )
	.//Set Ret=SQLCODE
	.//增加计算当前批号项目结果的统计情况 DaiYi 2015-06-03
	.If $Length(ParRef) Set MatLotRowId=$Piece($Get(^DHCQCIV(ParRef,$Piece(ParRef,"||",2),$Piece(ParRef,"||",5))),"^",6)
	.Set CurTCCode=$Piece(ParRef,"||",4) 
	.s MatCode=$p(MatLotRowId,"||",1)
	.s LotCode=$p(MatLotRowId,"||",2)
	.s epis=$p(MatLotRowId,"||",3)
	.i $l(MatLotRowId) Set CurMachCode=$p($g(^DHCQCMAT($p(MatLotRowId,"||",1))),"^",3)
	.s Ret=##class(web.DHCQCAccTotal).AccTCTotal(CurMachCode,MatCode,LotCode,$zd(DQIVDate,3),CurTCCode,epis)
	.s Ret=0
	
	Else  Set Ret="1"
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20120313
/// Description:： 仪器质控物浓度个数
/// Table：        DHCQC_Material
/// Input：        MatCode:质控代码
/// Output：       满足条件质控数据集合。
/// Return：       Levels:浓度个数
/// Others：
/// d ##class(web.DHCQCMachineDataView).QueryQCLevelData("")
ClassMethod QueryQCLevelData(MatCode As %String) As %String
{
  Set MatCode=$Get(MatCode)
  Set Levels=0
  If $Data(^DHCQCMAT(MatCode)) Do
  .Set Levels=$Piece($Get(^DHCQCMAT(MatCode)),"^",8)
  Quit Levels
}

ClassMethod QueryTCXSDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTCXSDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachineDataView","QueryQCData","","","","","","")
ClassMethod QueryTCXSDExecute(ByRef qHandle As %Binary, MachineCode As %String, TCCode As %String, MatCode As %String, StartDate As %String, EndDate As %String, LevelNo As %String) As %Status
{
	//Set MachineCode="ACA530",StartDate="2012-03-01",EndDate="2012-03-10",LevelNo="",TestCode="",TCType=""
	Set MachineCode=$Get(MachineCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
	Set LevelNo=$Get(LevelNo),TestCode=$Get(TestCode)
	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
	If MachineCode="" Quit
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
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
	.........Set TestRule=$Piece($Get(ReceiveData),"^",16)
	.........Set TestRemoveData=$Piece($Get(ReceiveData),"^",17)
	.........If TestRemoveData="" Set TestRemoveData="N"
	.........If TestRemoveData="1" Set TestRemoveData="Y"
	.........Set Visible=TestRemoveData
	.........Set RowId=RowId_"^"_ReceiveDate_"^"_OrdId
	.........Do OutputRow	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(CurTestCode,TestName,TestDate,TestTime,LevelNum,OrdId,TestResult,UserId,TestRule,Visible,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryTCXSDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTCXSDExecute ]
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
/// Description:： 仪器质控数据查询
/// Table：        DHCQC_TestCode
/// Input：        MachineCode:仪器代码，TCCode:项目代码,MatCode:质控物代码,StartDate：开始日期，EndDate：结束日期，LevelNo：标示号
/// Output：       满足条件质控数据集合。
/// Return：       
/// Others：
Query QueryTCXSD(MachineCode As %String, TCCode As %String, MatCode As %String, StartDate As %String, EndDate As %String, LevelNo As %String) As %Query(ROWSPEC = "testCode:%String,testName:%String,testdate:%String,testtime:%String,testId:%String,OrderId:%String,testResult:%String,userID:%String,testrule:%String,Visible:%String,RowId:%String") [ SqlProc ]
{
}

ClassMethod QueryTCSetUpInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTCSetUpInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachineDataView","QueryQCData","","","","","","")
ClassMethod QueryTCSetUpInfExecute(ByRef qHandle As %Binary, MachineCode As %String, TCCode As %String, MatCode As %String, StartDate As %String, EndDate As %String, LevelNo As %String) As %Status
{
	//Set MachineCode="ACA530",StartDate="2012-03-01",EndDate="2012-03-10",LevelNo="",TestCode="",TCType=""
	Set MachineCode=$Get(MachineCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
	Set LevelNo=$Get(LevelNo),TestCode=$Get(TestCode)
	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
	If MachineCode="" Quit
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
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
	.........Set TestRule=$Piece($Get(ReceiveData),"^",16)
	.........Set TestRemoveData=$Piece($Get(ReceiveData),"^",17)
	.........If TestRemoveData="" Set TestRemoveData="N"
	.........If TestRemoveData="1" Set TestRemoveData="Y"
	.........Set Visible=TestRemoveData
	.........Set RowId=RowId_"^"_ReceiveDate_"^"_OrdId
	.........Do OutputRow	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(CurTestCode,TestName,TestDate,TestTime,LevelNum,OrdId,TestResult,UserId,TestRule,Visible,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryTCSetUpInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTCSetUpInfExecute ]
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
/// CreatDate：    20120626
/// Description:： 查询质控物对应批次信息
/// Table：        DHCQC_TestCode
/// Input：        MachineCode:仪器代码，TCCode:项目代码,MatCode:质控物代码,StartDate：开始日期，EndDate：结束日期，LevelNo：标示号
/// Output：       满足条件质控数据集合。
/// Return：       
/// Others：
Query QueryTCSetUpInf(MachineCode As %String, TCCode As %String, MatCode As %String, StartDate As %String, EndDate As %String, LevelNo As %String) As %Query(ROWSPEC = "testCode:%String,testName:%String,testdate:%String,testtime:%String,testId:%String,OrderId:%String,testResult:%String,userID:%String,testrule:%String,Visible:%String,RowId:%String") [ SqlProc ]
{
}

ClassMethod QCDataStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryQCDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachineDataView","QCDataStat","AC1500","CA1500","CA1500","2014-6-1","2014-6-30","^9001^9002^9003","|A1130|A1140|A1150|A1160|A1170|A1180")
ClassMethod QCDataStatExecute(ByRef qHandle As %Binary, MachCode, MatCode, LotCode, StartDate, EndDate, LevelNo, TestCode) As %Status
{
	s MachCode=$g(MachCode),MatCode=$Get(MatCode),LotCode=$g(LotCode)
	s StartDate=$Get(StartDate),EndDate=$Get(EndDate)
	s LevelNo=$Get(LevelNo),TestCode=$Get(TestCode)
	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
	If MachCode="" Quit
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	s QcIdNum=$l(LevelNo,"^")-1
	//当前项目信息
	f TCNum=2:1:$l(TestCode,"|") d
	.s CurTestCode=$p(TestCode,"|",TCNum)
	.i '$l(CurTestCode) q
	.s TestName=$p($g(^TTAB("TC",CurTestCode)),"\",1)
	.f CurDate=StartDate:1:EndDate d
	..//当前浓度
	..s QcResult1="",QcResult2="",QcResult3="",QcResult4="",QcResult5="",QcResult6=""
	..f LevelNum=2:1:$l(LevelNo,"^") d
	...s LevelId=$p(LevelNo,"^",LevelNum)
	...i '$l(LevelId) q
	...i $d(^DHCQCIVTCi(MachCode,CurTestCode,CurDate,LevelId)) d
	....s QCOrdId="" f  s QCOrdId=$o(^DHCQCIVTCi(MachCode,CurTestCode,CurDate,LevelId,QCOrdId)) q:QCOrdId=""  d
	.....s RowId="" f  s RowId=$o(^DHCQCIVTCi(MachCode,CurTestCode,CurDate,LevelId,QCOrdId,RowId)) q:RowId=""  d
	......s RetData=$g(^DHCQCIV(RowId,CurDate,QCOrdId))
	......i ($p($g(RetData),"^",12)=2) q
	......i ($p($g(RetData),"^",12)=1) q
	......i MatCode_"||"_LotCode'=$p($Piece(RetData,"^",6),"||",1,2) Quit
	......i LevelNum=2 s QcResult1=QcResult1_" "_$p(RetData,"^",3)
	......i LevelNum=3 s QcResult2=QcResult2_" "_$p(RetData,"^",3)
	......i LevelNum=4 s QcResult3=QcResult3_" "_$p(RetData,"^",3)
	......i LevelNum=5 s QcResult4=QcResult4_" "_$p(RetData,"^",3)
	......i LevelNum=6 s QcResult5=QcResult5_" "_$p(RetData,"^",3)
	......i LevelNum=7 s QcResult6=QcResult6_" "_$p(RetData,"^",3)
	..i (QcResult1'="")||(QcResult2'="")||(QcResult3'="")||(QcResult4'="")||(QcResult5'="")||(QcResult6'="") d OutputRow
   	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb($zd(CurDate,3),CurTestCode,TestName,QcIdNum,QcResult1,QcResult2,QcResult3,QcResult4,QcResult5,QcResult6)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QCDataStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QCDataStatExecute ]
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
/// CreatDate：    20140723
/// Description:： 仪器质控数据汇总查询
/// Table：        DHCQC_ItemValue
/// Input：        MachCode:仪器代码,MatCode:质控物代码,LotCode:批次代码,StartDate:开始日期,EndDate:结束日期,LevelNo:浓度标示号,TestCode:测试汇总项目
/// Output：       满足条件质控数据集合。
/// Return：       
/// Others：       按照结果汇总模式输出
Query QCDataStat(MachCode, MatCode, LotCode, StartDate, EndDate, LevelNo, TestCode) As %Query(ROWSPEC = "CurDate,CurTestCode,TestName,QcIdNum,QcResult1,QcResult2,QcResult3,QcResult4,QcResult5,QcResult6") [ SqlProc ]
{
}

ClassMethod QCMachResultStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QCMachResultStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachineDataView","QCMachResultStat","AC1500","CA1500","CA1500","2015-3-1","2015-3-30","^901^902^903","|A1130|A1140|A1150|A1160|A1170","^1^2^3")
ClassMethod QCMachResultStatExecute(ByRef qHandle As %Binary, MachCode, MatCode, LotCode, StartDate, EndDate, LevelNo, TestCode, QCLevel) As %Status
{
	s MachCode=$g(MachCode),MatCode=$Get(MatCode),LotCode=$g(LotCode)
	s StartDate=$Get(StartDate),EndDate=$Get(EndDate)
	s LevelNo=$Get(LevelNo),TestCode=$Get(TestCode),QCLevel=$g(QCLevel)
	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
	If MachCode="" Quit $$$OK
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	s QcIdNum=$l(LevelNo,"^")-1
	k ^TMP($ZU(67,15,$j),$J)

	f CurDate=StartDate:1:EndDate d
	.f TCNum=2:1:$l(TestCode,"|") d
	..s CurTestCode=$p(TestCode,"|",TCNum)
	..s TestName=$p($g(^TTAB("TC",CurTestCode)),"\",1)
	..i '$l(CurTestCode) q
	..f LevelNum=2:1:$l(LevelNo,"^") d
	...s LevelId=$p(LevelNo,"^",LevelNum)
	...i '$l(LevelId) q
	...i $d(^DHCQCIVTCi(MachCode,CurTestCode,CurDate,LevelId)) d
	....s QCOrdId="" f  s QCOrdId=$o(^DHCQCIVTCi(MachCode,CurTestCode,CurDate,LevelId,QCOrdId)) q:QCOrdId=""  d
	.....s RowId="" f  s RowId=$o(^DHCQCIVTCi(MachCode,CurTestCode,CurDate,LevelId,QCOrdId,RowId)) q:RowId=""  d
	......s RetData=$g(^DHCQCIV(RowId,CurDate,QCOrdId))
	......i ($p($g(RetData),"^",12)=2) q
	......i ($p($g(RetData),"^",12)=1) q
	......s Level=$p($p(RetData,"^",6),"||",3)
	......s TestResult=$p($Get(RetData),"^",3)
	......i MatCode_"||"_LotCode'=$p($Piece(RetData,"^",6),"||",1,2) Quit
	......s ^TMP($ZU(67,15,$j),$J,CurDate,Level,CurTestCode)=TestResult
	
	//输出抬头
	f TCNum=2:1:$l(TestCode,"|") d
	.s CurTestCode=$p(TestCode,"|",TCNum)
	.i '$l(CurTestCode) q
	.s TestName=$p($g(^TTAB("TC",CurTestCode)),"\",12)
	.i '$l(TestName) s TestName=$p($g(^TTAB("TC",CurTestCode)),"\",1)
    .s CurResult=$lb(TestName)
	..f Level=1:1:$l(QCLevel,"^") d

	i $d(^TMP($ZU(67,15,$j),$J)) d
	.f CurDate=StartDate:1:EndDate d
	..s CurResult=""
	..f TCNum=2:1:$l(TestCode,"|") d
	...s CurTestCode=$p(TestCode,"|",TCNum)
	...i '$l(CurTestCode) q
	...s TestName=$p($g(^TTAB("TC",CurTestCode)),"\",12)
	...i '$l(TestName) s TestName=$p($g(^TTAB("TC",CurTestCode)),"\",1)
	...s CurResult=""
	...f Level1=2:1:$l(QCLevel,"^") d
	....s Result=""
	....s Level=$p(QCLevel,"^",Level1)
	....i $d(^TMP($ZU(67,15,$j),$J,CurDate,Level)) d
	.....i $d(^TMP($ZU(67,15,$j),$J,CurDate,Level,CurTestCode)) d
	......s Result=$g(^TMP($ZU(67,15,$j),$J,CurDate,Level,CurTestCode))
	....s CurResult=CurResult_$lb(Result)
	..d OutputRow
	
	..//s Ret=##class(web.DHCQCLotInformation).CalTCStatXSD(MatCode,LotCode,CurTestCode,LevelNum,StartDate,EndDate)
	..//d OutputRow 
	b ;098  	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=CurResult
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QCMachResultStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QCMachResultStatExecute ]
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
/// CreatDate：    20140723
/// Description:： 仪器质控数据汇总查询
/// Table：        DHCQC_ItemValue
/// Input：        MachCode:仪器代码,MatCode:质控物代码,LotCode:批次代码,StartDate:开始日期,EndDate:结束日期,LevelNo:浓度标示号,TestCode:测试汇总项目,QCLevel:浓度代码
/// Output：       满足条件质控数据集合。
/// Return：       
/// Others：       按照结果汇总模式输出
Query QCMachResultStat(MachCode, MatCode, LotCode, StartDate, EndDate, LevelNo, TestCode, QCLevel) As %Query(ROWSPEC = "CurDate,CurTestCode,TestName,QcIdNum,QcResult1,QcResult2,QcResult3,QcResult4,QcResult5,QcResult6") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCQCMachineDataViewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCMachineDataViewD</DataLocation>
<DefaultData>DHCQCMachineDataViewDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCMachineDataViewD</IdLocation>
<IndexLocation>^web.DHCQCMachineDataViewI</IndexLocation>
<StreamLocation>^web.DHCQCMachineDataViewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
