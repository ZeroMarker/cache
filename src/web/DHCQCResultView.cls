/// 质控规则信息查询
Class web.DHCQCResultView Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod QueryQCResultsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryQCResultsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCResultView","QueryQCResults","AHL750","AHL750","884600","A0010","2013-4-1","2013-4-30","1")
ClassMethod QueryQCResultsExecute(ByRef qHandle As %Binary, MachineCode As %String, MetCode As %String, LotCode As %String, TCCode As %String, StartDate As %String, EndDate As %String, QCID As %String) As %Status
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
	.......Do OutputRow	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
    Set Data=$lb(TestDate,TestTime,CurTCCode,TestTCName,TestResult,Ordid,TestRejRule,RetQCID,TestRejRuleName,ApprContent)
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
Query QueryQCResults(MachineCode As %String, MetCode As %String, LotCode As %String, TCCode As %String, StartDate As %String, EndDate As %String, QCID As %String) As %Query(ROWSPEC = "TestDate:%String,TestTime:%String,TCCode:%String,TCName:%String,TestResults:%String,TestOrder:%String,RejRul:%String,RetQCID:%String,TestRejRuleName:%String,ApprContent:%String") [ SqlProc ]
{
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCResultView","QueryQCResults","","","","","","","")
ClassMethod QueryQCResultsZExecute(ByRef qHandle As %Binary, MachineCode As %String, MetCode As %String, LotCode As %String, TCCode As %String, StartDate As %String, EndDate As %String, QCID As %String, PointType As %String) As %Status
{
	///Set MachineCode="BSKDXC",MetCode="BDXC600",LotCode="1234567",TCCode="B1160",StartDate="2013-3-1",EndDate="2013-3-14",QCID="1,2,3"
	Set MachineCode=$Get(MachineCode),MetCode=$Get(MetCode),LotCode=$Get(LotCode),TCCode=$Get(TCCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
 	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3),QCID=$Get(QCID),PointType=$Get(PointType)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set Num=0
	If $Data(^DHCQCIVi(MachineCode)) Do
	.For CurDate=StartDate:1:EndDate Do
	..//满足条件的执行，这样处理减少查询的数据量.
	..Set Num=0
	..If $Data(^DHCQCIVi(MachineCode,CurDate)) Do
	...Set CurQCId="" For  Set CurQCId=$Order(^DHCQCIVi(MachineCode,CurDate,CurQCId)) Quit:CurQCId=""  Do
	....Set Num=0
	....Set CurTCCode="" For  Set CurTCCode=$Order(^DHCQCIVi(MachineCode,CurDate,CurQCId,CurTCCode)) Quit:CurTCCode=""  Do
	.....If $Length(TCCode),TCCode'=CurTCCode Quit
	.....Set Ordid="" For  Set Ordid=$Order(^DHCQCIVi(MachineCode,CurDate,CurQCId,CurTCCode,Ordid)) Quit:Ordid=""  Do
	......Set Rowid="" For  Set Rowid=$Order(^DHCQCIVi(MachineCode,CurDate,CurQCId,CurTCCode,Ordid,Rowid)) Quit:Rowid=""  Do
	.......If (Num>0),(PointType=0) Quit
	.......Set StrData=$Get(^DHCQCIV(Rowid,CurDate,Ordid))
	.......Set LevelNo=$Piece($Piece(StrData,"^",6),"||",3)
	.......If QCID'[LevelNo Quit
	.......If $Length(LotCode),LotCode'=$Piece($Piece(StrData,"^",6),"||",2) Quit
	.......If $Length(MetCode),MetCode'=$Piece($Piece(StrData,"^",6),"||",1) Quit
	.......Set TestDate=$ZD($Piece(StrData,"^",1),3)
	.......Set TestTime=$ZT($Piece(StrData,"^",11))
	.......Set TestTCName=$Piece($Get(^TTAB("TC",CurTCCode)),"\",1)
	.......Set TestResult=$Piece(StrData,"^",3)
	.......Set TestRejRule=$Piece(StrData,"^",15)
	.......If $Length(TestRejRule) Set TestRejRule=$Piece($Get(^DHCQCRL(TestRejRule)),"^",2)
    .......Set TestRemoveData=$Piece($Get(StrData),"^",12)
	.......If TestRemoveData="" Set TestRemoveData="N"
	.......If TestRemoveData="0" Set TestRemoveData="N"
	.......If TestRemoveData="1" Set TestRemoveData="Y"
	.......//删除的排除
	.......If TestRemoveData=2 Quit
	.......If TestRemoveData="1" Quit
	.......Set TestDateTime=TestDate_" "_TestTime
	.......Set RetQCID=LevelNo
	.......Set Num=Num+1
	.......Do OutputRowZ	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRowZ
    Set Data=$lb(TestDate,TestTime,CurTCCode,TestTCName,TestResult,Ordid,TestRejRule,RetQCID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryQCResultsZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryQCResultsZExecute ]
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
/// CreatDate：    20130321
/// Description:： Z图质控数据查询
/// Table：        DHCQC_ItemValue
/// Input：        MachineCode:仪器代码,MetCode:质控物代码,LotCode:质控批号,TCCode:项目代码,StartDate:开始日期,EndDate:结束日期,
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QueryQCResultsZ(MachineCode As %String, MetCode As %String, LotCode As %String, TCCode As %String, StartDate As %String, EndDate As %String, QCID As %String, PointType As %String) As %Query(ROWSPEC = "TestDate:%String,TestTime:%String,TCCode:%String,TCName:%String,TestResults:%String,TestOrder:%String,RejRul:%String,RetQCID:%String") [ SqlProc ]
{
}

ClassMethod QueryQCResultsZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryQCResultsZExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryFrequencyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFrequencyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.DHCQCResultView","QueryFrequency","AHL750","AHL750","884600","A0010","2013-04-01","2013-04-30","1,2")
ClassMethod QueryFrequencyExecute(ByRef qHandle As %Binary, MachineCode As %String, MetCode As %String, LotCode As %String, TCCode As %String, StartDate As %String, EndDate As %String, QCID As %String) As %Status
{
	Set MachineCode=$Get(MachineCode),MetCode=$Get(MetCode),LotCode=$Get(LotCode),TCCode=$Get(TCCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
 	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3),QCID=$Get(QCID)

 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1

	For iNum=1:1:$Length(QCID,",") Do
	.Set CurQCID=$Piece(QCID,",",iNum)
	.If CurQCID="" Quit 
	.Set Ret=##class(web.DHCQCResultView).QueryFrequencyData(MachineCode,MetCode,LotCode,TCCode,StartDate,EndDate,CurQCID)
	.If $Data(^TMP($ZN,$Job)) Do
    ..//输出值给外面
	..Set ResultSD="靶值:"_$Piece(Ret,"^",1)
	..Set ResultNum="标准差:"_$Piece(Ret,"^",2)
	..Set ResultRange=""
	..Do OutputFrequency	
	..Set LevelNo="" For   Set LevelNo=$Order(^TMP($ZN,$Job,LevelNo)) Quit:LevelNo=""  Do
	...Set ResultId="" For  Set ResultId=$Order(^TMP($ZN,$Job,LevelNo,ResultId)) Quit:ResultId=""  Do
	....Set ResultSD="" For  Set ResultSD=$Order(^TMP($ZN,$Job,LevelNo,ResultId,ResultSD)) Quit:ResultSD=""  Do
	.....Set ResultRange="" For  Set ResultRange=$Order(^TMP($ZN,$Job,LevelNo,ResultId,ResultSD,ResultRange)) Quit:ResultRange=""  Do
	......Set ResultNum=$Get(^TMP($ZN,$Job,LevelNo,ResultId,ResultSD,ResultRange))
	......Kill ^TMP($ZN,$Job,ResultSD)
	......Do OutputFrequency
	.Else  Do
	..//输出值给外面
	..Set ResultSD="靶值:"_$Piece(Ret,"^",1)
	..Set ResultNum="标准差:"_$Piece(Ret,"^",2)
	..Set ResultRange=""
	..Do OutputFrequency	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputFrequency
    Set Data=$lb(ResultRange,ResultNum,ResultSD)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryFrequencyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFrequencyExecute ]
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
/// CreatDate：    20120420
/// Description:： 频谱数据查询
/// Table：        DHCQC_ItemValue
/// Input：        MachineCode:仪器代码,MetCode:质控物代码,LotCode:质控批号,TCCode:项目代码,StartDate:开始日期,EndDate:结束日期,QCID:浓度
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QueryFrequency(MachineCode As %String, MetCode As %String, LotCode As %String, TCCode As %String, StartDate As %String, EndDate As %String, QCID As %String) As %Query(ROWSPEC = "ResultRange:%String,ResultNum:%String,ResultSD:%String") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20120420
/// Description:： 频谱数据查询
/// Table：        DHCQC_ItemValue
/// Input：        MachineCode:仪器代码,MetCode:质控物代码,LotCode:质控批号,TCCode:项目代码,StartDate:开始日期,EndDate:结束日期,QCID:浓度
/// Output：       
/// Return：       0:无,1:有
/// Others：
/// d ##class(web.DHCQCResultView).QueryFrequencyData("AHL750","AHL750","884600","A0010","2013-04-01","2013-04-31","1")
ClassMethod QueryFrequencyData(MachineCode As %String, MetCode As %String, LotCode As %String, TCCode As %String, StartDate As %String, EndDate As %String, QCID As %String) As %String
{
	Set MachineCode=$Get(MachineCode),MetCode=$Get(MetCode),LotCode=$Get(LotCode),TCCode=$Get(TCCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
 	Set StartDate=$Get(StartDate),EndDate=$Get(EndDate),QCID=$Get(QCID)
 	Kill ^TMP($ZN,$Job)
 	Set Num=0
 	Set XSD=""
 	//提前初始化信息
 	//取项目的靶值，标准差.
	Set MetLotRowId=MetCode_"||"_LotCode
	Set SetUpX=$Piece($Get(^DHCQCTC(MetLotRowId,TCCode,QCID)),"^",6)
	Set SetUpSD=$Piece($Get(^DHCQCTC(MetLotRowId,TCCode,QCID)),"^",7)
	Set CalX=$Piece($Get(^DHCQCTC(MetLotRowId,TCCode,QCID)),"^",9)
	Set CalSD=$Piece($Get(^DHCQCTC(MetLotRowId,TCCode,QCID)),"^",10)
	Set SetUpDecimal=$Piece($Get(^DHCQCTC(MetLotRowId,TCCode,QCID)),"^",8) //小数点位
	Set CalFlag=$Piece($Get(^DHCQCTC(MetLotRowId,TCCode,QCID)),"^",12)
	If CalFlag="Y" Set SetUpX=CalX,SetUpSD=CalSD
	Set SDNum=0
	//参考范围----------------------------
	Set ResultRange3=$Fn((SetUpX+3*SetUpSD),",",SetUpDecimal)
	Set ResultRange2=$Fn((SetUpX+2*SetUpSD),",",SetUpDecimal)
	Set ResultRange1=$Fn((SetUpX+SetUpSD),",",SetUpDecimal)
	Set ResultRange0=$Fn((SetUpX),",",SetUpDecimal)
	Set ResultRangeF1=$Fn((SetUpX+(-1)*SetUpSD),",",SetUpDecimal)
	Set ResultRangeF2=$Fn((SetUpX+(-2)*SetUpSD),",",SetUpDecimal)
	Set ResultRangeF3=$Fn((SetUpX+(-3)*SetUpSD),",",SetUpDecimal)
	Set ^TMP($ZN,$Job,QCID,1,">3SD",">"_ResultRange3)=0
	Set ^TMP($ZN,$Job,QCID,2,"2SD-3SD",ResultRange2_"-"_ResultRange3)=0
	Set ^TMP($ZN,$Job,QCID,3,"1SD-2SD",ResultRange1_"-"_ResultRange2)=0
	Set ^TMP($ZN,$Job,QCID,4,"0-1SD",ResultRange0_"-"_ResultRangeF1)=0
	Set ^TMP($ZN,$Job,QCID,5,"0-(-1)SD",ResultRange0_"-"_ResultRange1)=0
	Set ^TMP($ZN,$Job,QCID,6,"(-1)SD-(-2)SD",ResultRangeF1_"-"_ResultRangeF2)=0
	Set ^TMP($ZN,$Job,QCID,7,"(-2)SD-(-3)SD",ResultRangeF2_"-"_ResultRangeF3)=0
	Set ^TMP($ZN,$Job,QCID,8,"<-3SD","<"_ResultRangeF3)=0
	Set XSD="^"_SetUpX_"^"_SetUpSD
	//-------------------------------------------------------
	If $Data(^DHCQCIVi(MachineCode)) Do
	.For CurDate=StartDate:1:EndDate Do
	..//满足条件的执行，这样处理减少查询的数据量.
	..If $Data(^DHCQCIVi(MachineCode,CurDate)) Do
	...Set CurQCId="" For  Set CurQCId=$Order(^DHCQCIVi(MachineCode,CurDate,CurQCId)) Quit:CurQCId=""  Do
	....//判断是否为当前的浓度
	....Set CurTCCode="" For  Set CurTCCode=$Order(^DHCQCIVi(MachineCode,CurDate,CurQCId,CurTCCode)) Quit:CurTCCode=""  Do
	.....If $Length(TCCode),TCCode'=CurTCCode Quit
	.....Set Ordid="" For  Set Ordid=$Order(^DHCQCIVi(MachineCode,CurDate,CurQCId,CurTCCode,Ordid)) Quit:Ordid=""  Do
	......Set Rowid="" For  Set Rowid=$Order(^DHCQCIVi(MachineCode,CurDate,CurQCId,CurTCCode,Ordid,Rowid)) Quit:Rowid=""  Do
	.......Set StrData=$Get(^DHCQCIV(Rowid,CurDate,Ordid))
	.......Set TestRemoveData=$Piece($Get(StrData),"^",12)
	.......Set TestResult=$Piece(StrData,"^",3)
	.......If TestRemoveData="" Set TestRemoveData="N"
	.......If TestRemoveData="0" Set TestRemoveData="N"
	.......If TestRemoveData="1" Set TestRemoveData="Y"
	.......//删除,排除
	.......If TestRemoveData=2 Quit
    .......If TestRemoveData="1" Quit
	.......Set LevelNo=$Piece($Piece(StrData,"^",6),"||",3)
	.......If QCID'=LevelNo Quit
	.......If $Length(LotCode),LotCode'=$Piece($Piece(StrData,"^",6),"||",2) Quit
	.......If $Length(MetCode),MetCode'=$Piece($Piece(StrData,"^",6),"||",1) Quit
	.......//取项目的靶值，标准差.
	.......Set MetLotRowId=MetCode_"||"_LotCode
	.......Set SetUpX=$Piece($Get(^DHCQCTC(MetLotRowId,CurTCCode,LevelNo)),"^",6)
	.......Set SetUpSD=$Piece($Get(^DHCQCTC(MetLotRowId,CurTCCode,LevelNo)),"^",7)
	.......Set CalX=$Piece($Get(^DHCQCTC(MetLotRowId,CurTCCode,LevelNo)),"^",9)
	.......Set CalSD=$Piece($Get(^DHCQCTC(MetLotRowId,CurTCCode,LevelNo)),"^",10)
	.......Set SetUpDecimal=$Piece($Get(^DHCQCTC(MetLotRowId,CurTCCode,LevelNo)),"^",8) //小数点位
	.......Set CalFlag=$Piece($Get(^DHCQCTC(MetLotRowId,CurTCCode,LevelNo)),"^",12)
	.......If CalFlag="Y" Set SetUpX=CalX,SetUpSD=CalSD
	.......Set SDNum=0
	.......If SetUpSD>0.0000001 Set SDNum=(TestResult-SetUpX)/SetUpSD
	.......//参考范围
	.......Set ResultRange3=$Fn((SetUpX+3*SetUpSD),",",SetUpDecimal)
	.......Set ResultRange2=$Fn((SetUpX+2*SetUpSD),",",SetUpDecimal)
	.......Set ResultRange1=$Fn((SetUpX+SetUpSD),",",SetUpDecimal)
	.......Set ResultRange0=$Fn((SetUpX),",",SetUpDecimal)
	.......Set ResultRangeF1=$Fn((SetUpX+(-1)*SetUpSD),",",SetUpDecimal)
	.......Set ResultRangeF2=$Fn((SetUpX+(-2)*SetUpSD),",",SetUpDecimal)
	.......Set ResultRangeF3=$Fn((SetUpX+(-3)*SetUpSD),",",SetUpDecimal)
	.......If SDNum>3 Set ^TMP($ZN,$Job,LevelNo,1,">3SD",">"_ResultRange3)=$Get(^TMP($ZN,$Job,LevelNo,1,">3SD",">"_ResultRange3))+1
	.......If 2<SDNum,SDNum<3.00000001 Set ^TMP($ZN,$Job,LevelNo,2,"2SD-3SD",ResultRange2_"-"_ResultRange3)=$Get(^TMP($ZN,$Job,LevelNo,2,"2SD-3SD",ResultRange2_"-"_ResultRange3))+1
	.......If 1<SDNum,SDNum<2.00000001 Set ^TMP($ZN,$Job,LevelNo,3,"1SD-2SD",ResultRange1_"-"_ResultRange2)=$Get(^TMP($ZN,$Job,LevelNo,3,"1SD-2SD",ResultRange1_"-"_ResultRange2))+1
	.......If 0<SDNum,SDNum<1.00000001 Set ^TMP($ZN,$Job,LevelNo,4,"0-1SD",ResultRange0_"-"_ResultRangeF1)=$Get(^TMP($ZN,$Job,LevelNo,4,"0-1SD",ResultRange0_"-"_ResultRangeF1))+1
	.......If (-1)<SDNum,SDNum<0.00000001 Set ^TMP($ZN,$Job,LevelNo,5,"0-(-1)SD",ResultRange0_"-"_ResultRange1)=$Get(^TMP($ZN,$Job,LevelNo,5,"0-(-1)SD",ResultRange0_"-"_ResultRange1))+1
	.......If (-2)<SDNum,SDNum<-1.0000001 Set ^TMP($ZN,$Job,LevelNo,6,"(-1)SD-(-2)SD",ResultRangeF1_"-"_ResultRangeF2)=$Get(^TMP($ZN,$Job,LevelNo,6,"(-1)SD-(-2)SD",ResultRangeF1_"-"_ResultRangeF2))+1
	.......If (-3)<SDNum,SDNum<-2.0000001 Set ^TMP($ZN,$Job,LevelNo,7,"(-2)SD-(-3)SD",ResultRangeF2_"-"_ResultRangeF3)=$Get(^TMP($ZN,$Job,LevelNo,7,"(-2)SD-(-3)SD",ResultRangeF2_"-"_ResultRangeF3))+1
	.......If (-3)>SDNum Set ^TMP($ZN,$Job,LevelNo,8,"<-3SD","<"_ResultRangeF3)=$Get(^TMP($ZN,$Job,LevelNo,8,"<-3SD","<"_ResultRangeF3))+1
	.......Set Num=Num+1
	.......Set XSD=SetUpX_"^"_SetUpSD
	Quit XSD
}

Storage Default
{
<Data name="DHCQCResultViewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCResultViewD</DataLocation>
<DefaultData>DHCQCResultViewDefaultData</DefaultData>
<IdLocation>^web.DHCQCResultViewD</IdLocation>
<IndexLocation>^web.DHCQCResultViewI</IndexLocation>
<StreamLocation>^web.DHCQCResultViewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
