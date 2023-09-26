Class web.DHCQCQueryStatTCByMouth Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod QueryStatTCByMouthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStatTCByMouthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCQueryStatTCByMouth","QueryStatTCByMouth","CA1500","CA1500","","3|2|1|",2014,7)
ClassMethod QueryStatTCByMouthExecute(ByRef qHandle As %Binary, CurMatCode As %String, CurLotCode As %String, TCCode As %String, QCId As %String, YearId As %String, MouthId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set CurMatCode=$Get(CurMatCode),CurLotCode=$Get(CurLotCode)
	Set (TCode,TCName,TestNum,RejectNum,WarningNum,TestX,TestSD,TestCV,TotalNum,SetUpX,SetUpSD,MatLotCode,LevelNo)=""
	Set (TestXAll,TestSDAll,TestCVAll,TestXByMouth,TestSDMouth,TestCVByMouth)=""
	Set Num=0
	//If $Data(^DHCQCATi(MatCode)) Do
	s MatCode="" f  s MatCode=$o(^DHCQCATi(MatCode)) q:MatCode=""  d
	.i $l(CurMatCode),CurMatCode'=MatCode q
	.s LotCode="" f  s LotCode=$o(^DHCQCATi(MatCode,LotCode)) q:LotCode=""  d
	..i $l(CurLotCode),CurLotCode'=LotCode q
	..//If $Data(^DHCQCATi(MatCode,LotCode)) Do
	..Set TCode="" For  Set TCode=$Order(^DHCQCATi(MatCode,LotCode,TCode)) Quit:TCode=""  Do
	...If $Length(TCCode),TCCode'[TCode Quit
	...Set LevelNo="" For  Set LevelNo=$Order(^DHCQCATi(MatCode,LotCode,TCode,LevelNo)) Quit:LevelNo=""  Do
	....If $Length(QCId),QCId'[LevelNo Quit
	....Set CurYear="" For  Set CurYear=$Order(^DHCQCATi(MatCode,LotCode,TCode,LevelNo,CurYear)) Quit:CurYear=""  Do
	.....If CurYear'=YearId Quit
	.....Set CurMoth="" For  Set CurMoth=$Order(^DHCQCATi(MatCode,LotCode,TCode,LevelNo,CurYear,CurMoth)) Quit:CurMoth=""  Do
	......If CurMoth'= MouthId Quit
	......Set RowId="" For  Set RowId=$Order(^DHCQCATi(MatCode,LotCode,TCode,LevelNo,CurYear,CurMoth,RowId)) Quit:RowId=""  Do
	.......s StrData="",StrData=$Get(^DHCQCAT(RowId,CurYear,CurMoth))
	.......Set TCName=$Piece($Get(^TTAB("TC",TCode)),"\",1)
	.......//取设定的靶值，标准差等信息.
	.......Set LotRowId=MatCode_"||"_LotCode
	.......Set LotStrData=$Get(^DHCQCTC(LotRowId,TCode,LevelNo))
	.......Set SetUpDecimal=+$Piece(LotStrData,"^",8)
	.......If SetUpDecimal="" Set SetUpDecimal=2
	.......s CurDate=$zdh(CurYear_"-"_CurMoth_"-01",3)
	.......s Ret=##class(web.DHCQCMachineDataView).QuerySetUpXSD(LotRowId,TCode,LevelNo,CurDate)
	.......Set SetUpX=$p(Ret,"^",1)     //$Tr($Fn($Piece(LotStrData,"^",6),"",SetUpDecimal),",")
	.......Set SetUpSD=$p(Ret,"^",2),SetUpCV=$p(Ret,"^",6)     //$Tr($Fn($Piece(LotStrData,"^",7),"",SetUpDecimal),",")
	.......Set TestNum=$Piece(StrData,"^",3),TestX=""
	.......Set TestX=$Tr($Fn($Piece(StrData,"^",4),",",SetUpDecimal),",")    //$p(Ret,"^",3)  //$Tr($Fn($Piece(StrData,"^",4),"",SetUpDecimal),",")
	.......Set TestSD=$Tr($Fn($Piece(StrData,"^",5),",",SetUpDecimal),",")   //$p(Ret,"^",4)     //$Tr($Fn($Piece(StrData,"^",5),"",SetUpDecimal),",")
	.......//i TestX>0.00000001 Set TestCV=$Tr($Fn((TestSD/TestX)*100,",",SetUpDecimal),",")
	.......Set TestCV=$Fn((TestSD/TestX)*100,",",SetUpDecimal) //$p(Ret,"^",5) 
	.......Set TestXByMouth=$Tr($Fn($Piece(StrData,"^",11),",",SetUpDecimal),",")
	.......Set TestSDMouth=$Tr($Fn($Piece(StrData,"^",12),",",SetUpDecimal),",")
	.......If TestXByMouth>0.000001 Set TestCVByMouth=$Fn((TestSDMouth/TestXByMouth)*100,",",SetUpDecimal)
	.......//添加同批次汇总的数据
	.......Set TestXAll=$Tr($Fn($Piece(LotStrData,"^",15),",",SetUpDecimal),",")
	.......Set TestSDAll=$Tr($Fn($Piece(LotStrData,"^",16),",",SetUpDecimal),",")
	.......If TestXAll>0.000001 Set TestCVAll=$Fn((TestSDAll/TestXAll)*100,",",SetUpDecimal)
	.......Set TotalNum=$Piece(LotStrData,"^",14)
	.......Set StartDate=YearId_"-"_MouthId_"-1"
	.......Set StartDate=$ZDH(StartDate,3)
	.......If MouthId=12 Set EndDate=(YearId+1)_"-01-01",EndDate=$ZDH(EndDate,3)
	.......If MouthId<12 Set EndDate=(YearId)_"-"_(MouthId+1)_"-01",EndDate=$ZDH(EndDate,3)-1
	.......Set MachineCode=$Piece(^DHCQCMAT(MatCode),"^",3)
    .......Set Ret=..QueryRejWarData(MachineCode,MatCode,LotCode,LevelNo,StartDate,EndDate,TCode)
    .......Set RejectNum=$Piece(Ret,"^",1)
    .......Set WarningNum=$Piece(Ret,"^",2)
    .......Set Num=Num+1
    .......Set MatLotCode=MatCode_","_LotCode
	.......Do OutputRow1
	If (Num<1) Do
	.Do OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow1
	set Data=$lb(TCode,TCName,LevelNo,MatLotCode,TestNum,RejectNum,WarningNum,TestX,TestSD,TestCV,TestXByMouth,TestSDMouth,TestCVByMouth,TotalNum,SetUpX,SetUpSD,SetUpCV,TestXAll,TestSDAll,TestCVAll)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryStatTCByMouthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStatTCByMouthExecute ]
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
/// CreatDate：    20130513
/// Description:： 按月查询质控汇总
/// Table：        DHCQC_AccTotal
/// Input：        MatCode:质控物代码，LotCode：批次代码,TCCode:项目代码集合，QCId:浓度代码，YearId:年份，MouthId:月份
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QueryStatTCByMouth(CurMatCode As %String, CurLotCode As %String, TCCode As %String, QCId As %String, YearId As %String, MouthId As %String) As %Query(ROWSPEC = "TCode,TCName,LevelNo,MatLotCode,TestNum,RejectNum,WarningNum,TestX,TestSD,TestCV,TestXByMouth,TestSDMouth,TestCVByMouth,TotalNum,SetUpX,SetUpSD,SetUpCV,TestXAll,TestSDAll,TestCVAll") [ SqlProc ]
{
}

ClassMethod QueryRejWarData(MachineCode, CurMatCode, LotCode, LevelNo, StartDate, EndDate, TCode)
{
    New (MachineCode, CurMatCode, LotCode, LevelNo, StartDate, EndDate, TCode)
    Set RejWarNum="0^0"
    Set RejNum=0,WarNum=0
	If $Data(^DHCQCIVi(MachineCode)) Do
	.For CurDate=StartDate:1:EndDate Do
	..If $Data(^DHCQCIVi(MachineCode,CurDate)) Do
	...Set LevelNum="" For  Set LevelNum=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum)) Quit:LevelNum=""  Do
	....Set CurTestCode="" For  Set CurTestCode=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode)) Quit:CurTestCode=""  Do
	.....//项目控制
	.....If TCode'=CurTestCode Quit
	.....Set SeqNo="" For  Set SeqNo=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,SeqNo)) Quit:SeqNo=""  Do
	......Set RowId1="" For  Set RowId1=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId1)) Quit:RowId1=""  Do
	.......Set ReceiveDate="" For  Set ReceiveDate=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId1,ReceiveDate)) Quit:ReceiveDate=""  Do
	........Set OrdId="" For  Set OrdId=$Order(^DHCQCIVi(MachineCode,CurDate,LevelNum,CurTestCode,SeqNo,RowId1,ReceiveDate,OrdId)) Quit:OrdId=""  Do
	.........Set ReceiveData=$Get(^DHCQCIV(RowId1,ReceiveDate,OrdId))
	.........//判断流水号根据备注字段判断
	.........Set QCId=$Piece($Piece(ReceiveData,"^",6),"||",3)
	.........If LevelNo'=QCId Quit
	.........If $Length(LotCode),LotCode'=$Piece($Piece(ReceiveData,"^",6),"||",2) Quit
	.........If $Length(CurMatCode),CurMatCode'=$Piece($Piece(ReceiveData,"^",6),"||",1) Quit
	.........Set TestRuleCode=$Piece($Get(ReceiveData),"^",15)
	.........Set TestRuleStatus=$Piece($Get(ReceiveData),"^",16)
	.........Set TestRemoveData=$Piece($Get(ReceiveData),"^",12)
	.........//删除的排除
	.........If TestRemoveData=2 Quit
	.........If TestRemoveData="" Set TestRemoveData="N"
	.........If TestRemoveData="0" Set TestRemoveData="N"
	.........If TestRemoveData="1" Set TestRemoveData="Y"
    .........If TestRuleStatus="R" Set RejNum=RejNum+1
    .........If TestRuleStatus="W" Set WarNum=WarNum+1
    Set RejWarNum=RejNum_"^"_WarNum
    Quit RejWarNum
}

ClassMethod QueryStatTCByYearClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStatTCByMouthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCQueryStatTCByMouth","QueryStatTCByYear","LAB","A","","","","","",2013,"LABDATA")
ClassMethod QueryStatTCByYearExecute(ByRef qHandle As %Binary, HospCode As %String, DeptCode As %String, MachCode As %String, MatCode As %String, LotCode As %String, TCCode As %String, QCId As %String, YearId As %String, LabNameSpace As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set HospCode=$Get(HospCode),DeptCode=$Get(DeptCode),MachCode=$Get(MachCode),TCCode=$Get(TCCode),QCId=$Get(QCId),YearId=$Get(YearId)
	Set MatCode=$Get(MatCode),LotCode=$Get(LotCode),LabNameSpace=$Get(LabNameSpace)
	Set (CurMachineCode,CurMachName,TCode,TCName,MatLotName,LevelNo,JanX,JanSD,FebX,FebSD,MarX,MarSD,AprX,AprSD,MayX,MaySD,JunX,JunSD,JulX,JulSD,AugX,AugSD,SepX,SepSD,OctX,OctSD,NovX,NovSD,DecX,DecSD)=""
	Set Num=0
	Set CurMatCode=""  For  Set CurMatCode=$Order(^DHCQCATi(CurMatCode)) Quit:CurMatCode=""  Do
	.//质控物医院判断。
	.Set MatFlag=0
	.If $Length(MatCode),MatCode'=CurMatCode Set MatFlag=1
	.Set CurMachineCode=$Piece($Get(^DHCQCMAT(CurMatCode)),"^",3)
	.If CurMachineCode="" Quit
	.Set CurMachName=$Piece($Get(^TMIF(CurMachineCode)),"\",1)
	.If $Length(MachCode),CurMachineCode'=MachCode Set MatFlag=1
	.If '$Length(MatCode) Do
	..Set CurHospCode=$Piece($Get(^[LabNameSpace]DHCMachinePara(CurMachineCode)),"\",7)
	..Set MachineDept=$Piece($Get(^[LabNameSpace]DHCMachinePara(CurMachineCode)),"\",1) 
	..If $Length(HospCode),HospCode'=CurHospCode Set MatFlag=1
	..If $Length(MachineDept),DeptCode'=MachineDept Set MatFlag=1
	.If MatFlag=1 Quit
	.//批次处理.
	.Set CurLotCode=""  For  Set CurLotCode=$Order(^DHCQCATi(CurMatCode,CurLotCode)) Quit:CurLotCode=""  Do
	..If $Length(LotCode),LotCode'=CurLotCode Quit
	..Set MatLotCode=CurMatCode_"/"_CurLotCode
	..Set MatLotName=MatLotCode
	..//项目判断
	..Set TCode="" For  Set TCode=$Order(^DHCQCATi(CurMatCode,CurLotCode,TCode)) Quit:TCode=""  Do
	...If $Length(TCCode),TCCode'[TCode Quit
	...//浓度判断
	...Set LevelNo="" For  Set LevelNo=$Order(^DHCQCATi(CurMatCode,CurLotCode,TCode,LevelNo)) Quit:LevelNo=""  Do
	....If $Length(QCId),QCId'[LevelNo Quit
	....Set CurYear="" For  Set CurYear=$Order(^DHCQCATi(CurMatCode,CurLotCode,TCode,LevelNo,CurYear)) Quit:CurYear=""  Do
	.....If CurYear'=YearId Quit
	.....Set (JanX,JanSD,FebX,FebSD,MarX,MarSD,AprX,AprSD,MayX,MaySD,JunX,JunSD,JulX,JulSD,AugX,AugSD,SepX,SepSD,OctX,OctSD,NovX,NovSD,DecX,DecSD)=""
	.....//月份判断
	.....For CurMoth=1:1:12 Do
	......If $Data(^DHCQCATi(CurMatCode,CurLotCode,TCode,LevelNo,CurYear,CurMoth)) Do
	.......Set RowId="" For  Set RowId=$Order(^DHCQCATi(CurMatCode,CurLotCode,TCode,LevelNo,CurYear,CurMoth,RowId)) Quit:RowId=""  Do
	........Set StrData=$Get(^DHCQCAT(RowId,CurYear,CurMoth))
	........Set TCName=$Piece($Get(^TTAB("TC",TCode)),"\",1)
	........//取设定的靶值，标准差等信息.
	........Set LotRowId=CurMatCode_"||"_CurLotCode
	........Set LotStrData=$Get(^DHCQCTC(LotRowId,TCode,LevelNo))
	........Set SetUpDecimal=+$Piece(LotStrData,"^",8)
	........If SetUpDecimal="" Set SetUpDecimal=2
	........Set TestNum=$Piece(StrData,"^",3)
	........Set TestX=$Tr($Fn($Piece(StrData,"^",4),",",SetUpDecimal),",")
	........Set TestSD=$Tr($Fn($Piece(StrData,"^",5),",",SetUpDecimal),",")
    ........If CurMoth=1 Set JanX=TestX,JanSD=TestSD
    ........If CurMoth=2 Set FebX=TestX,FebSD=TestSD
    ........If CurMoth=3 Set MarX=TestX,MarSD=TestSD
    ........If CurMoth=4 Set AprX=TestX,AprSD=TestSD
    ........If CurMoth=5 Set MayX=TestX,MaySD=TestSD
    ........If CurMoth=6 Set JunX=TestX,JunSD=TestSD
    ........If CurMoth=7 Set JulX=TestX,JulSD=TestSD
    ........If CurMoth=8 Set AugX=TestX,AugSD=TestSD
    ........If CurMoth=9 Set SepX=TestX,SepSD=TestSD
    ........If CurMoth=10 Set OctX=TestX,OctSD=TestSD
    ........If CurMoth=11 Set NovX=TestX,NovSD=TestSD
    ........If CurMoth=12 Set DecX=TestX,DecSD=TestSD
	......Else  Do
	.......If CurMoth=1 Set JanX="",JanSD=""
    .......If CurMoth=2 Set FebX="",FebSD=""
    .......If CurMoth=3 Set MarX="",MarSD=""
    .......If CurMoth=4 Set AprX="",AprSD=""
    .......If CurMoth=5 Set MayX="",MaySD=""
    .......If CurMoth=6 Set JunX="",JunSD=""
    .......If CurMoth=7 Set JulX="",JulSD=""
    .......If CurMoth=8 Set AugX="",AugSD=""
    .......If CurMoth=9 Set SepX="",SepSD=""
    .......If CurMoth=10 Set OctX="",OctSD=""
    .......If CurMoth=11 Set NovX="",NovSD=""
    .......If CurMoth=12 Set DecX="",DecSD=""
	.....//按照月份找完之后，在进行统一保存.
	.....Set Num=Num+1
	.....Do OutputRow
	If (Num<1) Do
	.Set (CurMachineCode,CurMachName,TCode,TCName,MatLotName)=""
	.Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	set Data=$lb(CurMachineCode,CurMachName,TCode,TCName,MatLotName,LevelNo,JanX,JanSD,FebX,FebSD,MarX,MarSD,AprX,AprSD,MayX,MaySD,JunX,JunSD,JulX,JulSD,AugX,AugSD,SepX,SepSD,OctX,OctSD,NovX,NovSD,DecX,DecSD)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryStatTCByYearFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStatTCByYearExecute ]
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
/// CreatDate：    20130513
/// Description:： 质控年度报表统计
/// Table：        
/// Input：        HospCode:医院代码,DeptCode:科室代码,MachCode:仪器代码,MatCode:质控物代码,LotCode:批次代码,TCCode:项目代码集合,QCId:浓度代码,YearId:年份,LabNameSpace:LABDATA名字空间
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QueryStatTCByYear(HospCode As %String, DeptCode As %String, MachCode As %String, MatCode As %String, LotCode As %String, TCCode As %String, QCId As %String, YearId As %String, LabNameSpace As %String) As %Query(ROWSPEC = "CurMachineCode,CurMachName,TCode,TCName,MatLotName,LevelNo,JanX,JanSD,FebX,FebSD,MarX,MarSD,AprX,AprSD,MayX,MaySD,JunX,JunSD,JulX,JulSD,AugX,AugSD,SepX,SepSD,OctX,OctSD,NovX,NovSD,DecX,DecSD") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCQCQueryStatTCByMouthDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCQueryStatTCByMouthD</DataLocation>
<DefaultData>DHCQCQueryStatTCByMouthDefaultData</DefaultData>
<IdLocation>^web.DHCQCQueryStatTCByMouthD</IdLocation>
<IndexLocation>^web.DHCQCQueryStatTCByMouthI</IndexLocation>
<StreamLocation>^web.DHCQCQueryStatTCByMouthS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
