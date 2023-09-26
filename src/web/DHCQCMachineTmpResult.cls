/// 检验科室查询
Class web.DHCQCMachineTmpResult Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 查询仪器对应的检验结果数据
/// 
ClassMethod GetAllMachineQCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllMachineQCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachineTmpResult","GetAllMachineQC","ACA530","","")
ClassMethod GetAllMachineQCExecute(ByRef qHandle As %Binary, MachCode As %String, StatDate As %String, EndDate As %String) As %Status
{
	//Set MachCode="ACA530",StatDate="2012-03-1",EndDate="2012-03-26"
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	If MachCode="" Quit $$$OK
	Set StatDate=$Get(StatDate),EndDate=$Get(EndDate)
	Set StatDate=$ZDh(StatDate,3),EndDate=$ZDh(EndDate,3)
	Set Num=1
	If $Data(^DHCQCTR(MachCode)) Do
	.For QcDate=StatDate:1:EndDate Do
	..If $Data(^DHCQCTR(MachCode,QcDate)) Do
	...Set QcId="" For  Set QcId=$Order(^DHCQCTR(MachCode,QcDate,QcId)) Quit:QcId=""  Do
	....Set TestCode="" For  Set TestCode=$Order(^DHCQCTR(MachCode,QcDate,QcId,TestCode)) Quit:TestCode=""  Do
	.....Set TestName=$Piece($Get(^TTAB("TC",TestCode)),"\",1)
	.....Set SeqNum="" For  Set SeqNum=$Order(^DHCQCTR(MachCode,QcDate,QcId,TestCode,SeqNum)) Quit:SeqNum=""  Do
	......Set str=$Get(^DHCQCTR(MachCode,QcDate,QcId,TestCode,SeqNum))
	......Set Result=$Piece(str,"^",9)
	......Set ResultFlag=$Piece(str,"^",10)
	......Set ResultNote=""
	......Set ResultQcDate=$ZD($Piece(str,"^",2),3)
	......Set ResultQcTime=$ZT($Piece(str,"^",3))
	......Set RowId=MachCode_"||"_QcDate_"||"_QcId_"||"_TestCode_"||"_SeqNum
	......Do OutputMachineQC
	......Set Num=Num+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
OutputMachineQC
	set Data=$lb(Num,QcId,TestCode,TestName,SeqNum,Result,ResultFlag,ResultNote,ResultQcDate,ResultQcTime,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAllMachineQCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllMachineQCExecute ]
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
/// CreatDate：    20120301
/// Description:： 检验仪器临时数据查询
/// Table：        DHCQC_TmpResult
/// Input：        MachCode:仪器代码,StatDate:开始日期,EndDate：结束日期
/// Output：       仪器质控数据集合
/// Return：       0:无,1:有
/// Others：
Query GetAllMachineQC(MachCode As %String, StatDate As %String, EndDate As %String) As %Query(ROWSPEC = "SeqNum:%String,QcId:%String,TestCode:%String,TestName:%String,TestTimes:%String,Result:%String,ResultFlag:%String,ResultNote:%String,TestDate:%String,TestTime:%String,RowId:%String") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20120301
/// Description:： 保存接收仪器的质控数据到临时表里面
/// Table：        DHCQC_TmpResult
/// Input：        RecordData:仪器结果集合含：仪器代码^结果日期^结果时间^保存日期^保存时间^质控ID号^
///                           显示顺序^质控项目^结果对应量值^结果标示
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCMachineTmpResult).SaveMachineQCData("")
ClassMethod SaveMachineQCData(RecordData As %String) As %String
{
	//Set RecordData="ACA530^2012-03-08^08:23:57^2012-03-03^15:31:57^QC1^A0500^1^4.32^*^"
	Set MachCode=$Piece(RecordData,"^",1)
	Set QcId=$Piece(RecordData,"^",6)
	Set TcCode=$Piece(RecordData,"^",7)
	//仪器结果日期，时间
	Set RecDate=$Tr($Piece(RecordData,"^",2)," ")
	If '$Length(RecDate) Set RecDate=$Piece($H,",",1)
	Else  Set RecDate=$ZDH(RecDate,3)
	Set RecTime=$Piece(RecordData,"^",3)
	If '$Length(RecTime) Set RecTime=+$Piece($H,",",2)
	Else  Set RecTime=$ZTH(RecTime)
	//当前的日期和时间
	Set CurDate=+$H,CurTime=+$Piece($H,",",2)
	Set ResultData=$Piece(RecordData,"^",9)
	Set ResultFlag=$Piece(RecordData,"^",10)
	Set ResultMatLot=$Piece(RecordData,"^",11)
	//序号判断。
	If $Data(^DHCQCTR(MachCode,RecDate,QcId,TcCode)) Do
	.Set OrderId=$Order(^DHCQCTR(MachCode,RecDate,QcId,TcCode,""),-1)+1
	Else  Do
	.Set OrderId=1
	//临时表RowID
	Set ParRef=MachCode_"||"_RecDate_"||"_QcId_"||"_TcCode_"||"_OrderId
	///DHCQC_TmpResult中的ROWID
	Kill PLIST
	Set PLIST(1)=ParRef
	Set PLIST(2)=MachCode
	Set PLIST(3)=RecDate,PLIST(4)=RecTime
    Set PLIST(5)=CurDate,PLIST(6)=CurTime
    Set PLIST(7)=QcId,PLIST(8)=OrderId
	Set PLIST(9)=TcCode,PLIST(10)=ResultData,PLIST(11)=ResultFlag,PLIST(12)=ResultMatLot
	Set Ret=100
	&SQL(Insert Into lab.DHCQC_TmpResult Values :PLIST())
	Set Ret=SQLCODE
	b ;2321
	Quit Ret
}

Storage Default
{
<Data name="DHCQCMachineTmpResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCMachineTmpResultD</DataLocation>
<DefaultData>DHCQCMachineTmpResultDefaultData</DefaultData>
<IdLocation>^web.DHCQCMachineTmpResultD</IdLocation>
<IndexLocation>^web.DHCQCMachineTmpResultI</IndexLocation>
<StreamLocation>^web.DHCQCMachineTmpResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
