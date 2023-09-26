Class web.DHCQCRuleAppraise Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod GetRuleAppraiseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRuleAppraiseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.DHCQCRuleAppraise","GetRuleAppraise",""C2H7600||63523||902||C0010||1^63523^1"","LABDATA")
ClassMethod GetRuleAppraiseExecute(ByRef qHandle As %Binary, RowId As %String, LabNameSpace As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set RowId=$Get(RowId),LabNameSpace=$Get(LabNameSpace)
	Set RowId=$Piece(RowId,"^",1)
	If $Data(^DHCQCRULEAP(RowId)) Do
	.Set OrdId="" For  Set OrdId=$Order(^DHCQCRULEAP(RowId,OrdId)) Quit:OrdId=""  Do
	..Set ApprContent=$Piece($Get(^DHCQCRULEAP(RowId,OrdId)),"^",4)
	..Set UserDR=$Piece($Get(^DHCQCRULEAP(RowId,OrdId)),"^",3)
	..Set UserName=$Piece(^[LabNameSpace]SSU("SSUSR",1,UserDR),"^",1)
	..Set AppDate=$ZD($Piece($Get(^DHCQCRULEAP(RowId,OrdId)),"^",1),3)
	..Set AppTime=$ZT($Piece($Get(^DHCQCRULEAP(RowId,OrdId)),"^",2))
	..Set Visible=$Piece($Get(^DHCQCRULEAP(RowId,OrdId)),"^",5)
	..i Visible="N" Quit
	..s Visible="true"
	..Do OutputRow
	Else  Do
	.//Set (RowId,OrdId,ApprContent,UserDR,UserName,AppDate,AppTime,Visible)=""
	.//Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(RowId,OrdId,ApprContent,UserDR,UserName,AppDate,AppTime,Visible)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetRuleAppraiseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRuleAppraiseExecute ]
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
/// Description:： 质控处理信息
/// Table：        DHC_IQC_RuleAppraise
/// Input：        RowId:RowId,LabNameSpace:检验名字空间
/// Output：       质控处理
/// Return：       0:无,1:有
/// Others：
Query GetRuleAppraise(RowId As %String, LabNameSpace As %String) As %Query(ROWSPEC = "RowId:%String,OrderId:%String,ApprContent:%String,UserDR:%String,UserName:%String,AppDate:%String,AppTime:%String,Visible:%String") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20120613
/// Description:： 保存失控处理
/// Table：        DHC_IQC_RuleAppraise
/// Input：        RowId:RowId,RecordStr:处理信息 
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCRuleAppraise).InsertRuleAppraise("C2H7600||63523||902||C0010||1^63523^1","312412413141414^demo^2014-12-5^17:31:11^Y")
ClassMethod InsertRuleAppraise(RowId As %String, RecordStr As %String) As %String
{
    Set RowId=$Get(RowId),RecordStr=$Get(RecordStr)
	Set ApprContent=$Piece(RecordStr,"^",1)
	Set UserDR=$Piece(RecordStr,"^",2)
	Set AppDate=$ZDH($Piece(RecordStr,"^",3),3)
	Set AppTime=+$ZTH($Piece(RecordStr,"^",4))
	Set Reported=$Piece(RecordStr,"^",5)

	If $Length(RowId)<1 Quit 100
	//拼成RowId
	Set ParRef=$Piece(RowId,"^",1)
	If $Data(^DHCQCRULEAP(ParRef)) Do 
	.Set OrderId=$Order(^DHCQCRULEAP(ParRef,""),-1)
	.Set OrderId=OrderId+1
	Else  Do
	.Set OrderId=1
	Set PLIST(2)=ParRef,PLIST(3)=OrderId,PLIST(4)=AppDate,PLIST(5)=AppTime,PLIST(6)=UserDR,PLIST(7)=ApprContent
	Set PLIST(8)=Reported,PLIST(9)="",PLIST(10)="",PLIST(11)=""
	//Set PLIST(2)=ParRef,PLIST(3)=OrderId,PLIST(4)=ApprContent,PLIST(5)=UserDR,PLIST(6)=AppDate,PLIST(7)=AppTime
	//Set PLIST(8)=+$h,PLIST(9)=$p($h,",",2),PLIST(10)=Reported,PLIST(11)=""
	&SQL(Insert Into lab.DHC_IQC_RuleAppraise Values :PLIST())
	//b ;11
	Quit SQLCODE
}

/// Creator：      DaiYi
/// CreatDate：    20120614
/// Description:： 更新质控处理内容
/// Table：        DHC_IQC_RuleAppraise
/// Input：        RowId:评价ID，OrdId:序号,RecordStr：评价内容
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.InsertRuleAppraise).UpdateAppraise("","","")
ClassMethod UpdateRuleAppraise(RowId As %String, OrdId As %String, RecordStr As %String) As %String
{
	//Set RowId="AHL750||62913||874000||A0010||1",OrdId=1
	//Set RecordStr="质控在控，符合预定规则23。^demo^2013-5-15^16:48:47^Y"
	Set RowId=$Get(RowId),OrdId=$Get(OrdId),RecordStr=$Get(RecordStr)
	Set CurDate=+$H
	Set CurTime=$Piece($H,",",2)
	Set ReportFlag="N"
	If $Data(^DHCQCRULEAP(RowId,OrdId)) Do
	.Set $Piece(^DHCQCRULEAP(RowId,OrdId),"^",1)=CurDate
	.Set $Piece(^DHCQCRULEAP(RowId,OrdId),"^",2)=CurTime
	.Set $Piece(^DHCQCRULEAP(RowId,OrdId),"^",3)=$Piece(RecordStr,"^",2)
	.Set $Piece(^DHCQCRULEAP(RowId,OrdId),"^",4)=$Piece(RecordStr,"^",1)
	.Set $Piece(^DHCQCRULEAP(RowId,OrdId),"^",5)=$Piece(RecordStr,"^",5)
	//为什么不能更新？
	//&SQL(Update lab.DHCQC_Appraise Set DIQA_User_DR=:UserId,DIQA_Reported=:ReportFlag,DIQA_Date=:CurDate,DIQA_Time=:CurTime Where DIQA_ParRef=:RowId And DIQA_Order=:OrdId)
	//Quit SQLCODE
	Quit 0
}

/// Creator：      DaiYi
/// CreatDate：    20120614
/// Description:： 删除质控处理
/// Table：        DHC_IQC_RuleAppraise
/// Input：        RowId:评价ID，OrdId:序号
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCRuleAppraise).DeleteAppraise("","","")
ClassMethod DeleteRuleAppraise(RowId As %String, OrdId As %String, UserId As %String) As %String
{
	Set RowId=$Get(RowId),OrdId=$Get(OrdId),UserId=$Get(UserId)
	Set CurDate=+$H
	Set CurTime=$Piece($H,",",2)
	Set ReportFlag="N"
	If $Data(^DHCQCRULEAP(RowId,OrdId)) Do
	.Set $Piece(^DHCQCRULEAP(RowId,OrdId),"^",5)="N"
	.Set $Piece(^DHCQCRULEAP(RowId,OrdId),"^",3)=UserId
	.Set $Piece(^DHCQCRULEAP(RowId,OrdId),"^",1)=CurDate
	.Set $Piece(^DHCQCRULEAP(RowId,OrdId),"^",2)=CurTime
	//为什么不能更新？
	//&SQL(Update lab.DHC_IQC_RuleAppraise Set DIQA_User_DR=:UserId,DIQA_Reported=:ReportFlag,DIQA_Date=:CurDate,DIQA_Time=:CurTime Where DIQA_ParRef=:RowId And DIQA_Order=:OrdId)
	//Quit SQLCODE
	Quit 0
}

/// Creator：      DaiYi
/// CreatDate：    20121014
/// Description:： 查询质控评价
/// Table：        DHC_IQC_RuleAppraise
/// Input：        RowId:评价ID，OrdId:序号
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCAppraise).QueryAppraise("ASCA15","ACA1500","548129","A1260","1,2,3","2013-3-1","2013-3-31")
ClassMethod QueryRuleAppraise(MachineCode As %String, MatCode As %String, LotCode As %String, TCCode As %String, QCId As %String, StartDate As %String, EndDate As %String) As %String
{
    Set MachineCode=$Get(MachineCode),MatCode=$Get(MatCode),LotCode=$Get(LotCode)
    Set TCCode=$Get(TCCode),QCId=$Get(QCId),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
    Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
    Set Ret=""
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

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCBaseAppraise","GetAll","","","","Y")
ClassMethod GetAllExecute(ByRef qHandle As %Binary, code As %String, name As %String, sequence As %String, visable As %String) As %Status
{
	Set code=$Get(code),name=$Get(name),sequence=$Get(sequence),visable=$Get(visable)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set BaseApprCode="" For  Set BaseApprCode=$Order(^DHCQCAP(BaseApprCode)) Quit:BaseApprCode=""  Do
	.Set str=$Get(^DHCQCAP(BaseApprCode))
	.Set uName=$Piece(str,"^",2)
	.If $Length(code),BaseApprCode'=code Quit
	.If $Length(uName),uName'[name Quit
	.Set CurSeqenue=$Piece(str,"^",3)
	.If $Length(sequence),sequence'=CurSeqenue Quit
	.Set VisFlag=$Piece(str,"^",4)
	.If $Length(visable),VisFlag'=visable Quit
	.i VisFlag="N" s VisFlag="false"
	.i VisFlag="Y" s VisFlag="true"
	.Do OutputRow		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(BaseApprCode,uName,CurSeqenue,VisFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllExecute ]
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
/// CreatDate：    20100712
/// Description:： 质控规则查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll(code As %String, name As %String, sequence As %String, visable As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,Sequence:%String,Visible:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCQCRuleAppraiseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCRuleAppraiseD</DataLocation>
<DefaultData>DHCQCRuleAppraiseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCRuleAppraiseD</IdLocation>
<IndexLocation>^web.DHCQCRuleAppraiseI</IndexLocation>
<StreamLocation>^web.DHCQCRuleAppraiseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
