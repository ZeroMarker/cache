Class web.DHCQCAccTotal Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      DaiYi
/// CreatDate：    20130315
/// Description:： 计算当前批号项目结果的统计情况.
/// Table：        DHCQC_Lot,DHCQC_Material,DHCQC_TestCode
/// Input：        MachinCode:仪器代码,MatCode:质控物代码，LotCode:批号,CurDate:当前日期,TCCode:项目代码,LevelNo:浓度
/// Output：       SQLCODE
/// Return：       
/// Others：       
/// d ##class(web.DHCQCAccTotal).AccTCTotal("AC1500","CA1500","CA1500","2014-4-1","A1130","1")
ClassMethod AccTCTotal(MachinCode As %String, MatCode As %String, LotCode As %String, CurDate As %String, TCCode As %String, LevelNo As %String) As %String
{
	Set MatCode=$Get(MatCode),LotCode=$Get(LotCode),CurDate=$Get(CurDate),TCCode=$Get(TCCode),LevelNo=$Get(LevelNo)
	Set MachinCode=$Get(MachinCode)
	//先计算在控数据，下面在计算所有数据
	Set ResultInControl=##class(web.DHCQCAccTotal).AccTCTotalInControl(MachinCode,MatCode,LotCode,CurDate,TCCode,LevelNo)
	Set CurYear=$Piece(CurDate,"-",1)
	Set CurMonth=$Piece(CurDate,"-",2)
	Set StartDay=1
	//计算开始日期,结束日期
	Set StartDate=CurYear_"-"_CurMonth_"-"_StartDay
	Set StartDate=$ZDH(StartDate,3)
	If CurMonth<12 Set EndDate=CurYear_"-"_(CurMonth+1)_"-"_1
	Else  Set EndDate=(CurYear+1)_"-1-1"
	Set EndDate=$ZDH(EndDate,3)-1
	Set Ret=100
	Kill ^TMP($Job)
	If '$Length(MachinCode) Quit 100
	If '$Length(MatCode) Quit 100
	If '$Length(LotCode) Quit 100
	If '$Length(LevelNo) Quit 100
	If '$Length(TCCode) Quit 100
	Set LotParRef=MatCode_"||"_LotCode
	Set Decimal=$Piece($Get(^DHCQCTC(LotParRef,TCCode,LevelNo)),"^",8)
	If Decimal="" Set Decimal=2
	//初始化变量
	Set TCSum=0,QCMean=0,QCSD=0,QCMax="",QCMin="",QCACMax="",QCACMin=""
	Set Num=0,TCTotal=0
	If $Data(^DHCQCIVi(MachinCode)) Do
	.For CurDate=StartDate:1:EndDate Do
	..If $Data(^DHCQCIVi(MachinCode,CurDate)) Do
	...Set LevelNum="" For  Set LevelNum=$Order(^DHCQCIVi(MachinCode,CurDate,LevelNum)) Quit:LevelNum=""  Do
	....Set CurTestCode="" For  Set CurTestCode=$Order(^DHCQCIVi(MachinCode,CurDate,LevelNum,CurTestCode)) Quit:CurTestCode=""  Do
	.....If TCCode'=CurTestCode Quit
	.....Set SeqNo="" For  Set SeqNo=$Order(^DHCQCIVi(MachinCode,CurDate,LevelNum,CurTestCode,SeqNo)) Quit:SeqNo=""  Do
	......Set RowId="" For  Set RowId=$Order(^DHCQCIVi(MachinCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId)) Quit:RowId=""  Do
	.......Set ReceiveDate="" For  Set ReceiveDate=$Order(^DHCQCIVi(MachinCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId,ReceiveDate)) Quit:ReceiveDate=""  Do
	........Set OrdId="" For  Set OrdId=$Order(^DHCQCIVi(MachinCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId,ReceiveDate,OrdId)) Quit:OrdId=""  Do
    .........Set ReceiveData=$Get(^DHCQCIV(RowId,ReceiveDate,OrdId))
    .........Set ParRef=$Piece(ReceiveData,"^",6)
    .........Set TestRemoveData=$Piece($Get(ReceiveData),"^",12)
    .........If TestRemoveData=2 Quit
    .........If $Length(MatCode),MatCode'=$Piece(ParRef,"||",1) Quit
    .........If $Length(LotCode),LotCode'=$Piece(ParRef,"||",2) Quit
    .........If $Length(LevelNo),LevelNo'=$Piece(ParRef,"||",3) Quit
    .........Set Num=Num+1
    .........Set TestResult=$Piece($Get(ReceiveData),"^",3)
    .........Set TCTotal=TCTotal+TestResult
    .........Set ^TMP($Job,Num)=TestResult
    Set TotalResult=0
    Set AccTotalString=""
    Set TotalResult=0
    If Num>1 Do
    .Set TCSum=Num
    .Set QCMean=TCTotal/(Num)
    .For Num=1:1:TCSum Do
    ..Set CurData=$Get( ^TMP($Job,Num))
    ..If Num=1 Set QCMax=CurData,QCMin=CurData
    ..If QCMax<CurData Set QCMax=CurData
    ..If QCMin>CurData Set QCMin=CurData
    ..Set TotalResult=(QCMean-CurData)*(QCMean-CurData)+TotalResult
    .Set QCSD=$Tr($Fn($ZSQR(TotalResult/(Num-1)),",",Decimal),",")
    .Set QCMean=$Tr($FN(TCTotal/(Num),",",Decimal),",")
    .Set AccTotalString=LotParRef_"||"_TCCode_"||"_LevelNo_"^"_CurYear_"^"_CurMonth_"^"_TCSum_"^"_QCMean
    .Set AccTotalString=AccTotalString_"^"_QCSD_"^"_QCMax_"^"_QCMin_"^"_$P(ResultInControl,"^",1)_"^"_$P(ResultInControl,"^",2)_"^"_$P(ResultInControl,"^",3)
    .Set Ret=..SaveAccTotal(AccTotalString)
    Kill ^TMP($Job)
	Quit 0
}

/// Creator：      DaiYi
/// CreatDate：    20140408
/// Description:： 计算当前批号项目结果在控数据
/// Table：        DHCQC_Lot,DHCQC_Material,DHCQC_TestCode
/// Input：        MatCode:质控物代码，LotCode:批号,CurDate:当前日期,TCCode:项目代码,LevelNo:浓度
/// Output：       SQLCODE
/// Return：       
/// Others：       
/// d ##class(web.DHCQCAccTotal).AccTCTotalInControl("KE601","COBASE601","COBASE601","2014-1-1","K0500","1")
ClassMethod AccTCTotalInControl(MachinCode As %String, MatCode As %String, LotCode As %String, CurDate As %String, TCCode As %String, LevelNo As %String) As %String
{
	New (MachinCode,MatCode,LotCode,CurDate,TCCode,LevelNo)
	Set MatCode=$Get(MatCode),LotCode=$Get(LotCode),CurDate=$Get(CurDate),TCCode=$Get(TCCode),LevelNo=$Get(LevelNo)
	Set MachinCode=$Get(MachinCode)
	Set CurYear=$Piece(CurDate,"-",1)
	Set CurMonth=$Piece(CurDate,"-",2)
	Set StartDay=1
	//计算开始日期,结束日期
	Set StartDate=CurYear_"-"_CurMonth_"-"_StartDay
	Set StartDate=$ZDH(StartDate,3)
	If CurMonth<12 Set EndDate=CurYear_"-"_(CurMonth+1)_"-"_1
	Else  Set EndDate=(CurYear+1)_"-1-1"
	Set EndDate=$ZDH(EndDate,3)-1
	Set Ret=100
	Kill ^TMP($ZN,$Job)
	If '$Length(MachinCode) Quit 100
	If '$Length(MatCode) Quit 100
	If '$Length(LotCode) Quit 100
	If '$Length(LevelNo) Quit 100
	If '$Length(TCCode) Quit 100
	Set LotParRef=MatCode_"||"_LotCode
	Set Decimal=$Piece($Get(^DHCQCTC(LotParRef,TCCode,LevelNo)),"^",8)
	If Decimal="" Set Decimal=2
	//初始化变量
	Set TCSum=0,QCMean=0,QCSD=0,QCMax="",QCMin="",QCACMax="",QCACMin=""
	Set Num=0,TCTotal=0
	If $Data(^DHCQCIVi(MachinCode)) Do
	.For CurDate=StartDate:1:EndDate Do
	..If $Data(^DHCQCIVi(MachinCode,CurDate)) Do
	...Set LevelNum="" For  Set LevelNum=$Order(^DHCQCIVi(MachinCode,CurDate,LevelNum)) Quit:LevelNum=""  Do
	....Set CurTestCode="" For  Set CurTestCode=$Order(^DHCQCIVi(MachinCode,CurDate,LevelNum,CurTestCode)) Quit:CurTestCode=""  Do
	.....If TCCode'=CurTestCode Quit
	.....Set SeqNo="" For  Set SeqNo=$Order(^DHCQCIVi(MachinCode,CurDate,LevelNum,CurTestCode,SeqNo)) Quit:SeqNo=""  Do
	......Set RowId="" For  Set RowId=$Order(^DHCQCIVi(MachinCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId)) Quit:RowId=""  Do
	.......Set ReceiveDate="" For  Set ReceiveDate=$Order(^DHCQCIVi(MachinCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId,ReceiveDate)) Quit:ReceiveDate=""  Do
	........Set OrdId="" For  Set OrdId=$Order(^DHCQCIVi(MachinCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId,ReceiveDate,OrdId)) Quit:OrdId=""  Do
    .........Set ReceiveData=$Get(^DHCQCIV(RowId,ReceiveDate,OrdId))
    .........Set ParRef=$Piece(ReceiveData,"^",6)
    .........Set TestRemoveData=$Piece($Get(ReceiveData),"^",12)
    .........If TestRemoveData=2 Quit
    .........If $Length(MatCode),MatCode'=$Piece(ParRef,"||",1) Quit
    .........If $Length(LotCode),LotCode'=$Piece(ParRef,"||",2) Quit
    .........If $Length(LevelNo),LevelNo'=$Piece(ParRef,"||",3) Quit
    .........Set TestResult=$Piece($Get(ReceiveData),"^",3)
    .........Set TestRuleResult=$Piece($Get(ReceiveData),"^",16)
    .........If TestRuleResult="R" Quit
    .........Set TCTotal=TCTotal+TestResult
    .........Set Num=Num+1
    .........Set ^TMP($ZN,$Job,Num)=TestResult
    Set TotalResult=0
    Set AccTotalString=""
    Set TotalResult=0
    If Num>1 Do
    .Set TCSum=Num
    .Set QCMean=TCTotal/(Num)
    .For Num=1:1:TCSum Do
    ..Set CurData=$Get(^TMP($ZN,$Job,Num))
    ..If Num=1 Set QCMax=CurData,QCMin=CurData
    ..If QCMax<CurData Set QCMax=CurData
    ..If QCMin>CurData Set QCMin=CurData
    ..Set TotalResult=(QCMean-CurData)*(QCMean-CurData)+TotalResult
    .Set QCSD=$tr($Fn($ZSQR(TotalResult/(Num-1)),",",Decimal),",")
    .Set QCMean=$tr($FN(TCTotal/(Num),",",Decimal),",")
    .Set AccTotalString=Num_"^"_QCMean_"^"_QCSD
    Kill ^TMP($ZN,$Job)
	Quit AccTotalString
}

/// Creator：      DaiYi
/// CreatDate：    20130218
/// Description:： 保存统计数据
/// Table：        DHCQC_AccTotal
/// Input：        PLIST 
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCAccTotal).SaveAccTotal()
ClassMethod SaveAccTotal(AccTotalString As %String) As %String
{
	Set AccTotalString=$Get(AccTotalString)
	Set ParRef=$Piece(AccTotalString,"^",1)
	Set Year=$Piece(AccTotalString,"^",2)
	Set Month=$Piece(AccTotalString,"^",3)
	Set TCSum=$Piece(AccTotalString,"^",4)
	Set QCMean=$Piece(AccTotalString,"^",5)
	Set QCSD=$Piece(AccTotalString,"^",6)
	Set QCMax=$Piece(AccTotalString,"^",7)
	Set QCMin=$Piece(AccTotalString,"^",8)
	Set QCACMax="" //$Piece(AccTotalString,"^",9)
	Set QCACMin="" //$Piece(AccTotalString,"^",10)
	//新修改数据.DaiYi 2014-04-08
	Set ACTCSum=$Piece(AccTotalString,"^",9)
	Set ACTCMean=$Piece(AccTotalString,"^",10)
	Set ACSD=$Piece(AccTotalString,"^",11)
	If '$Data(^DHCQCAT(ParRef,Year,Month)) Do
	.&sql(insert into lab.DHCQC_AccTotal(DHCAT_ParRef,DTAT_Year,DTAT_Month,DTAT_TCSum,DTAT_QCMean,DTAT_QCSD,DTAT_QCMax,DTAT_QCMin,DTAT_QCACMax,DTAT_QCACMin,DTAT_AC_TCSum,DTAT_AC_TCMean,DTAT_AC_SD )
	 values (:ParRef,:Year,:Month,:TCSum,:QCMean,:QCSD,:QCMax,:QCMin,:QCACMax,:QCACMin,:ACTCSum,:ACTCMean,:ACSD))
	Else  Do
	.Set SQLCODE=..UpdateAccTotal(AccTotalString)
	Quit SQLCODE
}

/// Creator：      DaiYi
/// CreatDate：    20130218
/// Description:： 更新统计数据
/// Table：        DHCQC_AccTotal
/// Input：        PLIST 
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCAccTotal).UpdateAccTotal()
ClassMethod UpdateAccTotal(AccTotalString As %String) As %String
{
	Set AccTotalString=$Get(AccTotalString)
	Set ParRef=$Piece(AccTotalString,"^",1)
	Set Year=+$Piece(AccTotalString,"^",2)
	Set Month=+$Piece(AccTotalString,"^",3)
	Set TCSum=$Piece(AccTotalString,"^",4)
	Set QCMean=$Piece(AccTotalString,"^",5)
	Set QCSD=$Piece(AccTotalString,"^",6)
	Set QCMax=$Piece(AccTotalString,"^",7)
	Set QCMin=$Piece(AccTotalString,"^",8)
	Set QCACMax="" //$Piece(AccTotalString,"^",9)
	Set QCACMin="" //$Piece(AccTotalString,"^",10)
	//Set ACTCSum=$Piece(AccTotalString,"^",11)
	//Set ACTCMean=$Piece(AccTotalString,"^",12)
	//Set ACSD=$Piece(AccTotalString,"^",13)
	//新修改数据.DaiYi 2014-04-08
	Set ACTCSum=$Piece(AccTotalString,"^",9)
	Set ACTCMean=$Piece(AccTotalString,"^",10)
	Set ACSD=$Piece(AccTotalString,"^",11)
	&sql(Update lab.DHCQC_AccTotal Set DTAT_TCSum=:TCSum,DTAT_QCMean=:QCMean,
	 DTAT_QCSD=:QCSD,DTAT_QCMax=:QCMax,DTAT_QCMin=:QCMin,DTAT_QCACMax=:QCACMax,DTAT_QCACMin=:QCACMin,
	 DTAT_AC_TCSum=:ACTCSum,DTAT_AC_TCMean=:ACTCMean,DTAT_AC_SD=:ACSD 
	 Where DHCAT_ParRef=:ParRef and DTAT_Year=:Year and DTAT_Month=:Month)
	Quit SQLCODE
}

ClassMethod QueryTCAccClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTCAccExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……"AXE2100||AXE2100"
/// d ##class(%ResultSet).RunQuery("web.DHCQCAccTotal","QueryTCAcc","ACA1500","528117","A1260","2013-02-01"
ClassMethod QueryTCAccExecute(ByRef qHandle As %Binary, MatCode As %String, LotCode As %String, TCode As %String, StartDate As %String, QCId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set MatCode=$Get(MatCode),LotCode=$Get(LotCode),TCode=$Get(TCode),QCId=$Get(QCId)
	Set StartDate=$Get(StartDate)
	Set CurYear=$Piece(StartDate,"-",1)
	Set CurMonth=+$Piece(StartDate,"-",2)
	Set (QCMatCode,QCLotCode,QCYearMonth,TCSum,QCMean,QCSD,CurCV,QCMin,CurMax,LevelNo)=""
	Set Num=0
	If $Data(^DHCQCATi(MatCode,LotCode,TCode)) Do
	.Set LevelNo="" For  Set LevelNo=$Order(^DHCQCATi(MatCode,LotCode,TCode,LevelNo)) Quit:LevelNo=""  Do
	..If $Length(QCId),QCId'[LevelNo Quit
	..Set QCYear="" For  Set QCYear=$Order(^DHCQCATi(MatCode,LotCode,TCode,LevelNo,QCYear)) Quit:QCYear=""  Do
	...Set QCMonth="" For  Set QCMonth=$Order(^DHCQCATi(MatCode,LotCode,TCode,LevelNo,QCYear,QCMonth)) Quit:QCMonth=""  Do
	....Set RowId="" For  Set RowId=$Order(^DHCQCATi(MatCode,LotCode,TCode,LevelNo,QCYear,QCMonth,RowId)) Quit:RowId=""  Do
	.....Set QCData=$Get(^DHCQCAT(RowId,QCYear,QCMonth))
	.....Set QCMatCode=MatCode,QCLotCode=LotCode,QCYearMonth=QCYear_"-"_QCMonth
	.....Set TCSum=$Piece(QCData,"^",3)
	.....Set QCMean=$Piece(QCData,"^",4)
	.....Set QCSD=$Piece(QCData,"^",5)
	.....Set Decimal=$Length($Piece(QCMean,".",2))
	.....If +QCMean'=0,+QCMean'=0.00,+QCMean'=0.0 Set CurCV=$Fn((QCSD/QCMean)*100,",",Decimal)
	.....Else  Set CurCV=""
	.....Set QCMin=$Fn($Piece(QCData,"^",7),",",Decimal)
	.....Set CurMax=$Fn($Piece(QCData,"^",6),",",Decimal)
	.....Do OutTCACC
	.....Set Num=Num+1
	If Num<1 Do OutTCACC
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutTCACC
	set Data=$lb(QCMatCode,QCLotCode,QCYearMonth,TCSum,QCMean,QCSD,CurCV,QCMin,CurMax,LevelNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryTCAccFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTCAccExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{	// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else     
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20130315
/// Description:： 查询项目的统计信息.
/// Table：        DHCQC_Lot,DHCQC_Material,DHCQC_TestCode,DHCQC_AccTotal
/// Input：        MatCode:质控物,LotCode:批次,TCode:项目代码,StartDate:日期,QCId:浓度
/// Output：       项目浓度设置信息
/// Return：       
/// Others：       Autstorage:MeanType是否使用上月计算值为设定标准差             
Query QueryTCAcc(MatCode As %String, LotCode As %String, TCode As %String, StartDate As %String, QCId = "") As %Query(ROWSPEC = "QCMatCode:%String,QCLotCode:%String,QCYearMonth:%String,TCSum:%String,QCMean:%String,QCSD:%String,CurCV:%String,QCMin:%String,CurMax:%String,LevelNo:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCQCAccTotalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCAccTotalD</DataLocation>
<DefaultData>DHCQCAccTotalDefaultData</DefaultData>
<IdLocation>^web.DHCQCAccTotalD</IdLocation>
<IndexLocation>^web.DHCQCAccTotalI</IndexLocation>
<StreamLocation>^web.DHCQCAccTotalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
