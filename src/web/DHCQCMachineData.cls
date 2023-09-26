Class web.DHCQCMachineData Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator：      DaiYi
/// CreatDate：    20110531
/// Description:： 保存接收的仪器
/// Table：        DHCQC_ItemValue
/// Input：        RecordData:仪器结果集合 
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCMachineData).SaveMachineQCData("")
ClassMethod SaveMachineQCData(RecordData As %String) As %String
{
	//Set RecordData="ASCA15^2013-03-18^901^A1260^1^17.6^^^^^^1^demo^16:58:52^^^^^^ACA1500||548129||1"
	Set MachCode=$Piece(RecordData,"^",1),QcId=$Piece(RecordData,"^",3),TcCode=$Piece(RecordData,"^",4)
	Set RecDate=$ZDH($Piece(RecordData,"^",2),3),OrderId=$Piece(RecordData,"^",5)
	If OrderId="" Set OrderId=1
	If $Data(^DHCQCIVi(MachCode,RecDate,QcId,TcCode)) Set OrderId=$Order(^DHCQCIVi(MachCode,RecDate,QcId,TcCode,""),-1)+1
	Set ParRef=MachCode_"||"_RecDate_"||"_QcId_"||"_TcCode_"||"_OrderId
	Set (MachineCode,DateRev,QCID,TestCode,OrderId)=""
	Kill PLIST
	Set MachineCode=$Piece(ParRef,"||",1),DateRev=$Piece(ParRef,"||",2),QCID=$Piece(ParRef,"||",3)
	Set TestCode=$Piece(ParRef,"||",4),OrderId=$Piece(ParRef,"||",5)
	Set SetUpDecimal=+$TR($TR($Piece($Get(^TTAB("TC",TestCode)),"\",3),"N")," ")
	If SetUpDecimal="" Set SetUpDecimal=2
	If SetUpDecimal<1 Set SetUpDecimal=2
	///保存参数,说明：TestValue：仪器结果定性值,Result:仪器结果定量值
	Set Result=$Fn($Piece(RecordData,"^",6),"",SetUpDecimal),TestValue=$Piece(RecordData,"^",7),TestFlag=$Piece(RecordData,"^",8)
	Set Comments=$Piece(RecordData,"^",9),(ModDate,ModTime)=""
	If Comments="" Set Comments=$Piece(RecordData,"^",20)
	Set ResultFrom=1,UserDR=$Piece(RecordData,"^",13)
	Set RecTime=$ZTH($Piece(RecordData,"^",14),3),Rul="",(Exclude,Stute)="",SerDate=$P($h,",",1),SerTime=$P($h,",",2)
	//计算项目的靶值标准差
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
	.Set Ret=##class(web.DHCQCCalRules).AddQCRule(ParRef_"^"_RecDate_"^"_OrderId,"DHC-DATA","DHC-APP")
	Else  Do
	.Set PLIST(2)=ParRef,PLIST(3)=RecDate,PLIST(4)=OrderId,PLIST(5)=Result,PLIST(6)=TestValue
	.Set PLIST(7)=TestFlag,PLIST(8)=$Piece(RecordData,"^",20),PLIST(9)=ModDate,PLIST(10)=ModTime,PLIST(11)=ResultFrom
	.Set PLIST(12)=UserDR,PLIST(13)=RecTime,PLIST(14)=Exclude,PLIST(15)=SerDate,PLIST(16)=SerTime
	.Set PLIST(17)=Rul,PLIST(18)=Stute
	.Set PLIST(1)=ParRef_"||"_PLIST(3)_"||"_PLIST(4)
	.Set Ret=0
	.&SQL(Update lab.DHCQC_ItemValue Values :PLIST() where DQIV_ParRef=:PLIST(1) )
	.Set Ret=SQLCODE
    .//计算质控规则
	.Set Ret=##class(web.DHCQCCalRules).AddQCRule(ParRef_"||"_"^"_RecDate_"^"_OrderId)
	//&SQL(INSERT INTO lab.DHCQC_ItemValue(DQIV_ParRef,DQIV_Date,DQIV_Order,DQIV_TestResult,DQIV_TestValue,DQIV_TestFlag,DQIV_Comments,DQIV_ModDate,DQIV_ModTime,DQIV_ResultFrom,DQIV_User_DR,
	//                                     DQIV_Time,DQIV_Exclude,DQIV_SerDate,DQIV_SerTime,DQIV_Rul,DQIV_Stute)
	//     Values(:ParRef,:RecDate,:OrderQcId,:Result,:TestValue,:TestFlag,:Comments,:ModDate,:ModTime,:ResultFrom,:UserDR,
	//            :RecTime,:Exclude,:SerDate,:SerTime,:Rul,:Stute)
	//     )
	// 
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20110531
/// Description:： 手工录入数据保存，总是保存成为新数据。
/// Table：        DHCQC_ItemValue
/// Input：        RecordData:仪器结果集合 
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCMachineData).SaveQCDataByPerson("")
ClassMethod SaveQCDataByPerson(RecordData As %String, sDataNameSpace As %String, sNameSpace As %String) As %String
{
	//Set RecordData="AHL750^2013-4-5^884600^A0010^^6.3^^^^^^1^demo^10:28:49^^^^^"
	Set RecordData=$Get(RecordData),sDataNameSpace=$Get(sDataNameSpace),sNameSpace=$Get(sNameSpace)
	Set MachCode=$Piece(RecordData,"^",1),QcId=$Piece(RecordData,"^",3),TcCode=$Piece(RecordData,"^",4)
	Set RecDateData=$Piece(RecordData,"^",2)
	If $Length(RecDateData) Set RecDate=$ZDH($Piece(RecordData,"^",2),3)
	If '$Length(RecDateData) Quit 200
	Set OrderId=$Piece(RecordData,"^",5)
	If OrderId="" Set OrderId=1
	If $Data(^DHCQCIVi(MachCode,RecDate,QcId,TcCode)) Set OrderId=$Order(^DHCQCIVi(MachCode,RecDate,QcId,TcCode,""),-1)+1
	Set ParRef=MachCode_"||"_RecDate_"||"_QcId_"||"_TcCode_"||"_OrderId
	Set (MachineCode,DateRev,QCID,TestCode,OrderId)=""
	Kill PLIST
	Set MachineCode=$Piece(ParRef,"||",1),DateRev=$Piece(ParRef,"||",2),QCID=$Piece(ParRef,"||",3)
	Set TestCode=$Piece(ParRef,"||",4),OrderId=$Piece(ParRef,"||",5)
	///保存参数
	Set Result=$Piece(RecordData,"^",6),TestValue="",TestFlag=$Piece(RecordData,"^",8)
	Set Comments=$Piece(RecordData,"^",9),(ModDate,ModTime)=""
	//备注该为了保存质控RowId
	Set QCDate=$ZD(RecDate,3)
	Set RowId=##class(web.DHCQCMaterialQuery).MachMatLot(MachineCode,QcId,QCDate)
	Set Comments=$Piece(RowId,"||",2,4)
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
	.Set Ret=##class(web.DHCQCCalRules).AddQCRule(ParRef_"||"_RecDate_"||"_OrderId_"^"_RecDate_"^"_OrderId,sDataNameSpace,sNameSpace)
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20110602
/// Description:： 删除仪器数据
/// Table：        DHCQC_ItemValue
/// Input：        RowId 
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCMachineData).DeleteMachineQCData("")
ClassMethod DeleteMachineQCData(QCRowId As %String) As %String
{
	//Set QCRowId="ACA530^2011-05-24^QC1^A0490^1"
	Set QCRowId=$Get(QCRowId)
	Set RecDate=$ZDH($Piece(QCRowId,"^",2),3)
	Set QCRowId=$Piece(QCRowId,"^",1)_"||"_RecDate_"||"_$Piece(QCRowId,"^",3)_"||"_$Piece(QCRowId,"^",4)_"||"_$Piece(QCRowId,"^",5)
	&SQL(Delete From lab.DHCQC_TmpResult Where DHCQC_RowId=:QCRowId )
	Quit SQLCODE
}

/// Creator：      DaiYi
/// CreatDate：    20110602
/// Description:： 删除仪器数据
/// Table：        DHCQC_TmpResult
/// Input：        RowId 
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCMachineData).UpdateMachineQCData("","","","","","")
ClassMethod UpdateMachineQCData(MachCode As %String, RecDate As %String, QCId As %String, TCCode As %String, OrderId As %String, Result As %String) As %String
{
	//Set MachCode="ACA530",RecDate="2012-03-01",QCId="QC1",TCCode="A0490",OrderId="1",Result="2.88"
	Set MachCode=$Get(MachCode),RecDate=$Get(RecDate),QCId=$Get(QCId),TCCode=$Get(TCCode),OrderId=$Get(OrderId),Result=$Get(Result)
	Set RecDate=$ZDH(RecDate,3)
	Set QCRowId=MachCode_"||"_RecDate_"||"_QCId_"||"_TCCode_"||"_OrderId
	Set Ret="0"
	If $Data(^DHCQCTR(MachCode,RecDate,QCId,TCCode,OrderId)) Do
	.Set $Piece(^DHCQCTR(MachCode,RecDate,QCId,TCCode,OrderId),"^",9)=Result
	.&SQL(Update lab.DHCQC_TmpResult  Set DQIV_TestValue=:Result Where DHCQC_RowId=:QCRowId )
	.Set Ret=SQLCODE
	Else  Set Ret="1"
	Quit Ret
}

ClassMethod GetId(code As %String) As %String
{
	&sql(select DQAML_Code into :Id from lab.DHCQC_AmendLiquid where DQAML_Code=:code)
	If SQLCODE="0" Quit Id
	Quit ""
}

/// Creator：      DaiYi
/// CreatDate：    20110615
/// Description:： 删除仪器数据
/// Table：        DHCQC_ItemValue
/// Input：        MachCode:仪器代码，MatCode:质控物,StartDate:开始日期,EndDate:结束日期,TimesStr:浓度
/// Output：       仪器数据
/// Return：       0
/// Others：
/// d ##class(web.DHCQCMachineData).QueryMatData("")
ClassMethod QueryMatData(MachCode As %String, MatCode As %String, StartDate As %String, EndDate As %String, TimesStr As %String) As %String
{
	Set Num=""
	Set MachCode=$Get(MachCode),MatCode=$Get(MatCode),StartDate=$Get(StartDate)
	Set EndDate=$Get(EndDate),TimesStr=$Get(TimesStr)
	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
	Set CurMach="" For  Set CurMach=$Order(^DHCQCIVi(CurMach)) Quit:CurMach=""  Do
	.If $Length(MachCode),MachCode'=CurMach Quit
    .Set CurDate="" For  Set CurDate=$Order(^DHCQCIVi(CurMach,CurDate)) Quit:CurDate=""  Do
    ..If CurDate<StartDate Quit
    ..If CurDate>EndDate Quit
    ..Set QcId="" For  Set QcId=$Order(^DHCQCIVi(CurMach,CurDate,QcId)) Quit:QcId=""  Do
    ...Set TCCode="" For  Set TCCode=$Order(^DHCQCIVi(CurMach,CurDate,QcId,TCCode)) Quit:TCCode=""  Do
    ....Set TCCount="" For  Set TCCode=$Order(^DHCQCIVi(CurMach,CurDate,QcId,TCCode,TCCount)) Quit:TCCount=""  Do
    .....Set RowId="" For  Set TCCode=$Order(^DHCQCIVi(CurMach,CurDate,QcId,TCCode,TCCount,RowId)) Quit:RowId=""  Do
	Quit Num
}

/// 查询仪器质控物对应的批号
ClassMethod QueryMachineQCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMachineQCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachineData","QueryMachineQC","","","","","")
ClassMethod QueryMachineQCExecute(ByRef qHandle As %Binary, MachineCode As %String, QCID As %String, TCCode As %String, StartDate As %String, EndDate As %String, LabNameSpace As %String) As %Status
{
	
    //Set MachineCode="ACA530",QCID="QC1",TCCode="A0490",StartDate="2012-03-01",EndDate="2012-03-31"
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set MachineCode=$Get(MachineCode),QCID=$Get(QCID),TCCode=$Get(TCCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
	Set ID=0
	If $Data(^DHCQCIVi(MachineCode)) Do
	.For CurDate=StartDate:1:EndDate Do
	..If $Data(^DHCQCIVi(MachineCode,CurDate)) Do
	...If $Length(QCID),$Data(^DHCQCIVi(MachineCode,CurDate,QCID)) Do
	....If $Length(TCCode),$Data(^DHCQCIVi(MachineCode,CurDate,QCID,TCCode)) Do
	.....Set Count="" For  Set Count=$Order(^DHCQCIVi(MachineCode,CurDate,QCID,TCCode,Count)) Quit:Count=""  Do
	......Set RowId="" For  Set RowId=$Order(^DHCQCIVi(MachineCode,CurDate,QCID,TCCode,Count,RowId)) Quit:RowId=""  Do
	.......Set StrData=$Get(^DHCQCIV(RowId,CurDate,Count))
	.......Set TestName=$Piece($Get(^TTAB("TC",TCCode)),"\",1)
	.......Set QCDate=$ZD(CurDate,3)
	.......Set QCTime=$ZT($Piece(StrData,"^",11))
	.......Set TestQCID=QCID
	.......Set TestResult=$Piece(StrData,"^",3)
	.......Set TestFlag=$Piece(StrData,"^",5)
	.......Set ResultFrom=$Piece(StrData,"^",9)
	.......Set ResultFromName="",UserName=""
	.......If ResultFrom=1 Set ResultFromName="仪器接收"
	.......If ResultFrom=2 Set ResultFromName="手工录入"
	.......Set ResultFrom=ResultFromName
	.......Set UserDr=$Piece(StrData,"^",10)
	.......Set TestRemoveData=$Piece(StrData,"^",12)
    .......If TestRemoveData=2 Quit
	.......//ZN "LABDATA"
	.......If $Length(UserDr) Set UserName=$Piece($Get(^[LabNameSpace]SSU("SSUSR",1,UserDr)),"^",2)
	.......//ZN "DHC-DATA"
	.......Set ID=ID+1
	.......Do Output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
Output
	set Data=$lb(ID,TestName,QCDate,QCTime,TestQCID,TestResult,TestFlag,ResultFrom,UserName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryMachineQCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMachineQCExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
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
/// CreatDate：    20120612
/// Description:： 按照日期时间查询仪器质控数据
/// Table：        DHCQC_ItemValue
/// Input：        MachineCode:仪器代码,QCID:质控标示,TCCode:项目代码,StartDate:开始日期,EndDate:结束日期
/// Output：       
/// Return：       质控结果结合
/// Others：       无
Query QueryMachineQC(MachineCode As %String, QCID As %String, TCCode As %String, StartDate As %String, EndDate As %String, LabNameSpace As %String) As %Query(ROWSPEC = "ID:%String,TestName:%String,QCDate:%String,QCTime:%String,TestQCID:%String,TestResult:%String,TestFlag:%String,ResultFrom:%String,UserName:%String") [ SqlProc ]
{
}

/// 查询仪器原始数据集合
ClassMethod QueryMachResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMachResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachineData","QueryMachResult","AC1500","","2009-01-12","2009-01-12","LABDATA")
ClassMethod QueryMachResultExecute(ByRef qHandle As %Binary, MachineCode As %String, Epis As %String, StartDate As %String, EndDate As %String, LabNameSpace As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1

	Set MachineCode=$Get(MachineCode),Epis=$Get(Epis),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
	s LabNameSpace=$g(LabNameSpace)
	i '$l(LabNameSpace) s LabNameSpace="LABDATA"
	Set ID=0

	f CurDate=StartDate:1:EndDate d
	.i $d(^[LabNameSpace]issaak07(MachineCode,CurDate)) d
	..s CurEpis="" f  s CurEpis=$o(^[LabNameSpace]issaak07(MachineCode,CurDate,CurEpis)) q:CurEpis=""  d
	...i $l(Epis),Epis'=CurEpis q
	...s ID="" f  s ID=$o(^[LabNameSpace]issaak07(MachineCode,CurDate,CurEpis,ID)) q:ID=""  d
	....s StrData=$g(^[LabNameSpace]issaak07(MachineCode,CurDate,CurEpis,ID))
	....s MachResult=$p(StrData,"^",6)
	....s TestDate=$p(StrData,"^",7)
	....s TestTime=$p(StrData,"^",8)
	....//取当天读的日期好
	....//i $l(TestDate) s TestDate=$zd(TestDate,3)
	....//e  s TestDate=$zd(CurDate,3)
	....s TestDate=$zd(CurDate,3)
	....i $l(TestTime) s TestTime=$zt(TestTime)
	....e  s TestTime=$zt($p($h,",",2))
	....Do Output
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
Output
	set Data=$lb(TestDate,TestTime,CurEpis,ID,MachResult)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryMachResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMachResultExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
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
/// CreatDate：    20140505
/// Description:： 查询仪器原始数据集合
/// Table：        访问LABDATA下的：^issaak07
/// Input：        MachineCode:仪器代码,Epis:质控标示,StartDate:开始日期,EndDate:结束日期
/// Output：       
/// Return：       质控结果结合
/// Others：       无
Query QueryMachResult(MachineCode As %String, Epis As %String, StartDate As %String, EndDate As %String, LabNameSpace As %String) As %Query(ROWSPEC = "TestDate,TestTime,CurEpis,ID,MachResult") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20131105
/// Description:： 手工查询保存质控数据
/// Table：        DHCQC_ItemValue
/// Input：        mi:仪器代码,epis:质控编号,sNameSpace:WebSrc空间,sLABDATA:检验空间
/// Output：       
/// Return：       质控结果结合
/// Others：       无
/// d ##class(web.DHCQCMachineData).InsertQC("AC1500",9001,9001,"","","2009-01-28","09:03:00",9001,"","dhc-app","labdata")
ClassMethod InsertQC(mi, sample, epis, surname, result, date, time, QC, miOverwrite = "", sNameSpace = "DHC-APP", sLabData = "LABDATA") As %String
{
	//s result="041\11.9,042\88.6,043\.98,044\.98,046\.98,047\.98,051\29.9,056\29.9,057\29.9,061\5.2,062\439.3,066\439.3,067\439.3,"
	s sNameSpace=$g(sNameSpace),sLabData=$g(sLabData)
	i '$l(sLabData) s sLabData="LABDATA"
	i '$l(sNameSpace) s sLabData="DHC-APP"
	s date=$zdh(date,3),time=$zth(time)
	zn sLabData
	s QC=$g(QC)
    If $Length(QC) Do file^DHCLtkQCInterface(mi,sample,epis,surname,result,date,time,QC)
    zn sNameSpace
    q 0
}

Storage Default
{
<Data name="DHCQCMachineDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCMachineDataD</DataLocation>
<DefaultData>DHCQCMachineDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCMachineDataD</IdLocation>
<IndexLocation>^web.DHCQCMachineDataI</IndexLocation>
<StreamLocation>^web.DHCQCMachineDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
