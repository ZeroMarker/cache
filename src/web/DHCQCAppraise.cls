Class web.DHCQCAppraise Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod GetAppraiseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppraiseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCAppraise","GetAppraise","","","","","","","")
ClassMethod GetAppraiseExecute(ByRef qHandle As %Binary, MachineCode As %String, MatCode As %String, LotCode As %String, TCCode As %String, QCId As %String, StartDate As %String, EndDate As %String, LabNameSpace As %String) As %Status
{
	//Set MachineCode="ACA530",MatCode="ACA530",LotCode="ACA530-1",TCCode="A0490",QCId="23",StartDate="2012-06-01",EndDate="2012-06-30"
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set MachineCode=$Get(MachineCode),MatCode=$Get(MatCode),LotCode=$Get(LotCode)
	Set TCCode=$Get(TCCode),QCId=$Get(QCId),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3),LabNameSpace=$Get(LabNameSpace)
	If $Data(^DHCQCAPPRi(MachineCode)) Do
	.Set CurMatCode="" For  Set CurMatCode=$Order(^DHCQCAPPRi(MachineCode,CurMatCode)) Quit:CurMatCode=""  Do
	..If $Length(MatCode),MatCode'=CurMatCode Quit
	..Set CurLotCode="" For  Set CurLotCode=$Order(^DHCQCAPPRi(MachineCode,CurMatCode,CurLotCode)) Quit:CurLotCode=""  Do
	...If $Length(LotCode),LotCode'=CurLotCode Quit
	...Set CurTCCode="" For  Set CurTCCode=$Order(^DHCQCAPPRi(MachineCode,CurMatCode,CurLotCode,CurTCCode)) Quit:CurTCCode=""  Do
	....If $Length(TCCode),TCCode'=CurTCCode Quit
	....Set CurQCID="" For  Set CurQCID=$Order(^DHCQCAPPRi(MachineCode,CurMatCode,CurLotCode,CurTCCode,CurQCID)) Quit:CurQCID=""  Do
	.....If $Length(QCId),QCId'[CurQCID Quit
	.....Set CurDate="" For  Set CurDate=$Order(^DHCQCAPPRi(MachineCode,CurMatCode,CurLotCode,CurTCCode,CurQCID,CurDate)) Quit:CurDate=""  Do
	......If CurDate<StartDate Quit
	......If CurDate>EndDate Quit
	......Set RowId="" For  Set RowId=$Order(^DHCQCAPPRi(MachineCode,CurMatCode,CurLotCode,CurTCCode,CurQCID,CurDate,RowId)) Quit:RowId=""  Do
	.......Set OrderId="" For  Set OrderId=$Order(^DHCQCAPPRi(MachineCode,CurMatCode,CurLotCode,CurTCCode,CurQCID,CurDate,RowId,OrderId)) Quit:OrderId=""  Do
	........Set StrData=$Get(^DHCQCAPPR(RowId,OrderId))
	........Set ApprContent=$Piece(StrData,"^",1)
	........Set UserDR=$Piece(StrData,"^",2)
	........Set UserName=$Piece(^[LabNameSpace]SSU("SSUSR",1,UserDR),"^",1)
	........Set AppDate=$ZD($Piece(StrData,"^",3),3)
	........Set AppTime=$ZT($Piece(StrData,"^",4))
	........Set Visible=$Piece(StrData,"^",7)
	........If Visible'="Y" Quit
	........i Visible="Y" s Visible="true"
	........Do OutputRow
	........b ;123
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(RowId,OrderId,ApprContent,UserDR,UserName,AppDate,AppTime,Visible)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAppraiseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppraiseExecute ]
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
/// CreatDate：    20120615
/// Description:： 质控评价查询
/// Table：        DHCQC_Appraise
/// Input：        MachineCode：仪器代码,MatCode:质控物,LotCode:批次,TCCode:项目代码,QCId:质控标示,StartDate:日期,EndDate:结束日期
/// Output：       质控评价信息
/// Return：       0:无,1:有
/// Others：
Query GetAppraise(MachineCode As %String, MatCode As %String, LotCode As %String, TCCode As %String, QCId As %String, StartDate As %String, EndDate As %String, LabNameSpace As %String) As %Query(ROWSPEC = "RowId:%String,OrderId:%String,ApprContent:%String,UserDR:%String,UserName:%String,AppDate:%String,AppTime:%String,Visible:%String") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20120613
/// Description:： 保存质控评价
/// Table：        DHCQC_Appraise
/// Input：        MachineCode：仪器代码,MatCode:质控物,LotCode:批次,TCCode:项目代码,QCId:质控标示,QCDate:日期,RecordStr:评价信息 
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCAppraise).InsertAppraise("","","","","","","")
ClassMethod InsertAppraise(MachineCode As %String, MatCode As %String, LotCode As %String, TCCode As %String, QCId As %String, QCDate As %String, RecordStr As %String) As %String
{
	//Set MachineCode="ACA530",MatCode="ACA530",LotCode="ACA530-1",TCCode="A0490",QCId="23",QCDate="2012-6-15"
	//Set RecordStr="合格,试剂过期!^demo^2012-6-15^14:50:54^Y"
	Set MachineCode=$Get(MachineCode),TCCode=$Get(TCCode),QCId=$Get(QCId),RecordStr=$Get(RecordStr)
	Set MatCode=$Get(MatCode),LotCode=$Get(LotCode),QCDate=$ZDH($Get(QCDate),3)
	Set OrderId=""
	Set ApprContent=$Piece(RecordStr,"^",1)
	Set UserDR=$Piece(RecordStr,"^",2)
	Set AppDate=$ZDH($Piece(RecordStr,"^",3),3)
	Set AppTime=+$ZTH($Piece(RecordStr,"^",4))
	Set CurDate=+$H
	Set CurTime=+$Piece($H,",",2)
	Set Reported=$Piece(RecordStr,"^",5)
	If $Find(QCId,"^")>0 Set QCId=$Piece(QCId,"^",1)
	//拼成RowId
	Set ParRef=MachineCode_"||"_MatCode_"||"_LotCode_"||"_TCCode_"||"_QCId_"||"_QCDate
	If $Data(^DHCQCAPPR(ParRef)) Do
	.Set OrderId=$Order(^DHCQCAPPR(ParRef,""),-1)+1
	Else  Do
	.Set OrderId=1
	Set PLIST(2)=ParRef,PLIST(3)=OrderId,PLIST(4)=ApprContent,PLIST(5)=UserDR,PLIST(6)=AppDate,PLIST(7)=AppTime
	Set PLIST(8)=CurDate,PLIST(9)=CurTime,PLIST(10)=Reported
	&SQL(Insert Into lab.DHCQC_Appraise Values :PLIST())
	//&SQL(Insert Into lab.DHCQC_Appraise(DIQA_ParRef,DIQA_Order,DIQA_ApprContent,DIQA_User_DR,DIQA_AppDate,DIQA_AppTime,DIQA_Date,DIQA_Time,DIQA_Reported) 
	//     Values(:ParRef,:OrderId,:ApprContent,:UserDR,:AppDate,:AppTime,:CurDate,:CurTime,:Reported))
	Quit SQLCODE
}

/// Creator：      DaiYi
/// CreatDate：    20120614
/// Description:： 删除质控评价
/// Table：        DHCQC_Appraise
/// Input：        RowId:评价ID，OrdId:序号
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCAppraise).UpdateAppraise("","","")
ClassMethod UpdateAppraise(RowId As %String, OrdId As %String, RecordStr As %String) As %String
{
	Set RowId=$Get(RowId),OrdId=$Get(OrdId),RecordStr=$Get(RecordStr)
	Set CurDate=+$H
	Set CurTime=$Piece($H,",",2)
	Set ReportFlag="N"
	If $Data(^DHCQCAPPR(RowId,OrdId)) Do
	.Set $Piece(^DHCQCAPPR(RowId,OrdId),"^",2)=$Piece(RecordStr,"^",2)
	.Set $Piece(^DHCQCAPPR(RowId,OrdId),"^",4)=CurDate
	.Set $Piece(^DHCQCAPPR(RowId,OrdId),"^",5)=CurTime
	.Set $Piece(^DHCQCAPPR(RowId,OrdId),"^",1)=$Piece(RecordStr,"^",1)
	//为什么不能更新？
	//&SQL(Update lab.DHCQC_Appraise Set DIQA_User_DR=:UserId,DIQA_Reported=:ReportFlag,DIQA_Date=:CurDate,DIQA_Time=:CurTime Where DIQA_ParRef=:RowId And DIQA_Order=:OrdId)
	//Quit SQLCODE
	Quit 0
}

/// Creator：      DaiYi
/// CreatDate：    20120614
/// Description:： 删除质控评价
/// Table：        DHCQC_Appraise
/// Input：        RowId:评价ID，OrdId:序号
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCAppraise).DeleteAppraise("","","")
ClassMethod DeleteAppraise(RowId As %String, OrdId As %String, UserId As %String) As %String
{
	//Set MachineCode="ACA530",MatCode="ACA530",LotCode="ACA530-1",TCCode="A0490",QCId="QC1",QCDate="2012-03-05",RecordStr="质控规^demo^2012-03-05^22:10:10^Y"
	//Set RowId="ACA530||ACA530||ACA530-1||A0490||QC1||62521",OrdId=1,UserId="demo"
	Set RowId=$Get(RowId),OrdId=$Get(OrdId),UserId=$Get(UserId)
	Set CurDate=+$H
	Set CurTime=$Piece($H,",",2)
	Set ReportFlag="N"
	If $Data(^DHCQCAPPR(RowId,OrdId)) Do
	.Set $Piece(^DHCQCAPPR(RowId,OrdId),"^",7)="N"
	.Set $Piece(^DHCQCAPPR(RowId,OrdId),"^",2)=UserId
	.Set $Piece(^DHCQCAPPR(RowId,OrdId),"^",4)=CurDate
	.Set $Piece(^DHCQCAPPR(RowId,OrdId),"^",5)=CurTime
	//为什么不能更新？
	//&SQL(Update lab.DHCQC_Appraise Set DIQA_User_DR=:UserId,DIQA_Reported=:ReportFlag,DIQA_Date=:CurDate,DIQA_Time=:CurTime Where DIQA_ParRef=:RowId And DIQA_Order=:OrdId)
	//Quit SQLCODE
	Quit 0
}

/// Creator：      DaiYi
/// CreatDate：    20121014
/// Description:： 查询质控评价
/// Table：        DHCQC_Appraise
/// Input：        RowId:评价ID，OrdId:序号
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCAppraise).QueryAppraise("ASCA15","ACA1500","548129","A1260","1,2,3","2013-3-1","2013-3-31")
ClassMethod QueryAppraise(MachineCode As %String, MatCode As %String, LotCode As %String, TCCode As %String, QCId As %String, StartDate As %String, EndDate As %String) As %String
{
    Set MachineCode=$Get(MachineCode),MatCode=$Get(MatCode),LotCode=$Get(LotCode)
    Set TCCode=$Get(TCCode),QCId=$Get(QCId),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
    Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
    Set Ret=""
    If '$Length(MachineCode) Quit ""
    If '$Length(MatCode) Quit ""
    If '$Length(LotCode) Quit ""
    If '$Length(TCCode) Quit ""
	If $Data(^DHCQCAPPRi(MachineCode)) Do
	.Set CurMatCode="" For  Set CurMatCode=$Order(^DHCQCAPPRi(MachineCode,CurMatCode)) Quit:CurMatCode=""  Do
	..If $Length(MatCode),MatCode'=CurMatCode Quit
	..Set CurLotCode="" For  Set CurLotCode=$Order(^DHCQCAPPRi(MachineCode,CurMatCode,CurLotCode)) Quit:CurLotCode=""  Do
	...If $Length(LotCode),LotCode'=CurLotCode Quit
	...Set CurTCCode="" For  Set CurTCCode=$Order(^DHCQCAPPRi(MachineCode,CurMatCode,CurLotCode,CurTCCode)) Quit:CurTCCode=""  Do
	....If $Length(TCCode),TCCode'=CurTCCode Quit
	....Set CurQCID="" For  Set CurQCID=$Order(^DHCQCAPPRi(MachineCode,CurMatCode,CurLotCode,CurTCCode,CurQCID)) Quit:CurQCID=""  Do
	.....If $Length(QCId),QCId'[CurQCID Quit
	.....Set CurDate="" For  Set CurDate=$Order(^DHCQCAPPRi(MachineCode,CurMatCode,CurLotCode,CurTCCode,CurQCID,CurDate)) Quit:CurDate=""  Do
	......If CurDate<StartDate Quit
	......If CurDate>EndDate Quit
	......Set RowId="" For  Set RowId=$Order(^DHCQCAPPRi(MachineCode,CurMatCode,CurLotCode,CurTCCode,CurQCID,CurDate,RowId)) Quit:RowId=""  Do
	.......Set OrderId="" For  Set OrderId=$Order(^DHCQCAPPRi(MachineCode,CurMatCode,CurLotCode,CurTCCode,CurQCID,CurDate,RowId,OrderId)) Quit:OrderId=""  Do
	........Set StrData=$Get(^DHCQCAPPR(RowId,OrderId))
	........Set ApprContent=$Piece(StrData,"^",1)
	........Set Visible=$Piece(StrData,"^",7)
	........If Visible'="Y" Quit
	........Set Ret=Ret_" "_ApprContent
	Quit Ret
}

Storage Default
{
<Data name="DHCQCAppraiseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCAppraiseD</DataLocation>
<DefaultData>DHCQCAppraiseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCAppraiseD</IdLocation>
<IndexLocation>^web.DHCQCAppraiseI</IndexLocation>
<StreamLocation>^web.DHCQCAppraiseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
