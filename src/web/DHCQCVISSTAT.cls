Class web.DHCQCVISSTAT Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 查询检验科室对应的设备项目的VIS值
ClassMethod QueryItemQCVISClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemQCVISExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCVISSTAT","QueryItemQCVIS","","","","","","","","")
ClassMethod QueryItemQCVISExecute(ByRef qHandle As %Binary, CurMachineCode As %String, StartDate As %String, EndDate As %String, QCLevel As %String, TCCode As %String, MatCode As %String, LotCode As %String, TCType As %String, DeptCode) As %Status
{
	//Set MachineCode="ACA530",StartDate="2013-01-01",EndDate="2013-2-20",QCLevel="2013-2-22",QCLevel="1^2^3^",TCCode="",MatCode="ACA5301",LotCode="548136",TCType="0"
    Set CurMachineCode=$Get(CurMachineCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
    Set QCId=$Get(QCId),TCCode=$Get(TCCode),MatCode=$Get(MatCode),LotCode=$Get(LotCode),TCType=$Get(TCType)
    Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3),DeptCode=$g(DeptCode)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set (Flag,avgVIS,cleVIS,tmpNum)=0
    Set Num=1 
    //通过仪器查询质控物
    //If $Data(^DHCQCIVi(MachineCode)) Do
    s MachineCode="" f  s MachineCode=$o(^DHCQCIVi(MachineCode)) q:MachineCode=""  d
    .//i $l(CurMachineCode),CurMachineCode'=MachineCode
    .For CurDate=StartDate:1:EndDate Do
    ..If $Data(^DHCQCIVi(MachineCode,CurDate)) Do
    ...Set QCId="" For  Set QCId=$Order(^DHCQCIVi(MachineCode,CurDate,QCId)) Quit:QCId=""  Do
    ....Set CurTCCode="" For  Set CurTCCode=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode)) Quit:CurTCCode=""  Do
    .....If $Length(TCCode),TCCode'=CurTCCode Quit
    .....Set OrdId="" For  Set OrdId=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,OrdId)) Quit:OrdId=""  Do
    ......Set RowId="" For  Set RowId=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,OrdId,RowId)) Quit:RowId=""  Do
    .......Set ReceiveDate="" For  Set ReceiveDate=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,OrdId,RowId,ReceiveDate)) Quit:ReceiveDate=""  Do
    ........Set SeqNo="" For  Set SeqNo=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,OrdId,RowId,ReceiveDate,SeqNo)) Quit:SeqNo=""  Do
    .........//取的结果值
    .........Set ReceiveData=$Get(^DHCQCIV(RowId,ReceiveDate,SeqNo))
    .........Set TestRemoveData=$Piece($Get(ReceiveData),"^",12)
    .........If TestRemoveData=2 Quit
    .........Set ParRef=$Piece(ReceiveData,"^",6)
    .........If $Length(MatCode),MatCode'=$Piece(ParRef,"||",1) Quit
    .........If $Length(LotCode),LotCode'=$Piece(ParRef,"||",2) Quit
    .........s MachineCode=$p($g(^DHCQCMAT($p(ParRef,"||",1))),"^",3)
    .........i $l(CurMachineCode),MachineCode'=CurMachineCode q 
    .........i $l(DeptCode),DeptCode'=$p($g(^DHCQCMAT($p(ParRef,"||",1))),"^",4) q
    .........Set LevelNo=$Piece(ParRef,"||",3)
    .........If $Length(QCLevel),QCLevel'[LevelNo Quit
    .........Set Result=$Piece(ReceiveData,"^",3)
    .........Set TestDateTime=$ZD($Piece(ReceiveData,"^",1),3)_" "_$ZT($Piece(ReceiveData,"^",11))
    .........Set MatRowId=$Piece(ParRef,"||",1)_"||"_$Piece(ParRef,"||",2)
    .........s StrSetUp=##class(web.DHCQCMachineDataView).QuerySetUpXSD(MatRowId,CurTCCode,LevelNo,CurDate)
    .........Set SetUpX=$p(StrSetUp,"^",1)   //$Piece($Get(^DHCQCTC(MatRowId,CurTCCode,LevelNo)),"^",6)
    .........Set SetUpSD=$p(StrSetUp,"^",2)   //$Piece($Get(^DHCQCTC(MatRowId,CurTCCode,LevelNo)),"^",7)
    .........Set CalX=$p(StrSetUp,"^",3)   //$Piece($Get(^DHCQCTC(MatRowId,CurTCCode,LevelNo)),"^",9)
    .........Set CalSD=$p(StrSetUp,"^",4)   //$Piece($Get(^DHCQCTC(MatRowId,CurTCCode,LevelNo)),"^",10)
    .........Set CalCV=""
    .........If +CalX'=0 Set CalCV=$p(StrSetUp,"^",5)   //$FNUMBER((CalSD/CalX),"",2)
    .........If SetUpX="" Quit
    .........Set TCName=$Piece($Get(^TTAB("TC",CurTCCode)),"\",1)
    .........Set CalVIS=""
    .........If SetUpX'="",SetUpSD>"0.00001" Set CalVIS=$TR($FNUMBER(((Result-SetUpX)/SetUpSD)*100,"",0),",","")
    .........Set avgVIS=avgVIS+(CalVIS)
    .........If (CalVIS)<400 Do
    ..........Set cleVIS=cleVIS+(CalVIS)
    ..........Set tmpNum=tmpNum+1
    .........If CalVIS>(-400) Do 
    ..........Set cleVIS=cleVIS+(CalVIS)
    ..........Set tmpNum=tmpNum+1
    .........If 150<CalVIS Set Flag=1
    .........If (-150)>CalVIS Set Flag=2
    .........Set TotalVIS=$FNUMBER((avgVIS)/(Num+1),"",0)
    .........Set ClearTotalVIS=$FNUMBER((cleVIS)/(tmpNum+1),"",0)
    .........If SetUpSD<"0.00001" Set SetUpSD=""
    .........If SetUpX<"0.00001" Set SetUpX=""
    .........If CalX<"0.00001" Set CalX=""
    .........If CalSD<"0.00001" Set CalSD=""
    .........If CalCV<"0.00001" Set CalCV=""
    .........//质控规则
    .........Set TestRuleCode=$Piece($Get(ReceiveData),"^",15),TestRuleName=""
    .........If $Length(TestRuleCode) Set TestRuleName=$Piece($Get(^DHCQCRL(TestRuleCode)),"^",2)
    .........Do Output
    .........Set Num=Num+1
    .........Set Flag=0
    .........//Set P0=$FNUMBER(avgVIS/num+1,"",0),P1=$FNUMBER(cleVIS/tmpNum+1,",",0)
    If (Num<1) Do
    .Set (Num,TestDateTime,CurTCCode,TCName,LevelNo,Result,CalVIS,SetUpX,SetUpSD,CalX,CalSD,CalCV,Flag,TotalVIS,ClearTotalVIS,TestRuleCode,TestRuleName,MatRowId)=""
    .Do Output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
Output
	Set Data=$lb(Num,TestDateTime,CurTCCode,TCName,LevelNo,Result,CalVIS,SetUpX,SetUpSD,CalX,CalSD,CalCV,Flag,TotalVIS,ClearTotalVIS,TestRuleCode,TestRuleName,MatRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryItemQCVISFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemQCVISExecute ]
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
/// CreatDate：    20120216
/// Description:： 查询质控数据以及VIS值.此查询只能查询有固定参数设置的质控品进行计算。
/// Table：        lab.DHCQC_ItemValue
/// Input：        MachineCode:仪器代码,StartDate:开始日期,EndDate:结束日期,QCId:质控浓度,TCCode:项目代码,MatCode:质控物,LotCode:质控批号
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
Query QueryItemQCVIS(MachineCode As %String, StartDate As %String, EndDate As %String, QCLevel As %String, TCCode As %String, MatCode As %String, LotCode As %String, TCType As %String, DeptCode) As %Query(ROWSPEC = "sequence:%String,testdatetime:%String,tccode:%String,tcname:%String,qclevel:%String,testdata:%String,visdata:%String,setupX:%String,setupSD:%String,calX:%String,calSD:%String,calCV:%String,Flag:%String,TotalVIS:%String,ClearTotalVIS:%String,TestRuleCode:%String,TestRuleName:%String,MatRowId") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCQCVISSTATDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCVISSTATD</DataLocation>
<DefaultData>DHCQCVISSTATDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCVISSTATD</IdLocation>
<IndexLocation>^web.DHCQCVISSTATI</IndexLocation>
<StreamLocation>^web.DHCQCVISSTATS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
