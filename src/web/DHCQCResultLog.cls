Class web.DHCQCResultLog Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      DaiYi
/// CreatDate：    20130601
/// Description:： 质控日志记录
/// Table：        DHCQC_ResultLog
/// Input：        RowId:唯一标示码,RecordStr:日志记录
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCResultLog).InsertLog("")
ClassMethod InsertLog(RowId As %String, RecordStr As %String) As %String
{
	Set RowId=$Get(RowId)
	Set RecordStr=$Get(RecordStr)
	Set LogRowId=$Order(^DHCQCRLog(""),-1)+1
	Set DoForm=$Piece(RecordStr,"^",1)
	Set NewResult=$Piece(RecordStr,"^",2)
	Set UserDr=$Piece(RecordStr,"^",3)
	Set CurDate=+$H
	Set CurTime=$Piece($H,",",2)
	Set OldResultData=$Get(^DHCQCIV($Piece(RowId,"^",1),$Piece(RowId,"^",2),$Piece(RowId,"^",3)))
	Set OldResult=$Piece(OldResultData,"^",3)
	Set UserDrOther=$Piece(OldResultData,"^",10)
	//------保存---------------
	Set PLIST(2)=LogRowId
	Set PLIST(3)=DoForm
	Set PLIST(4)=CurDate
	Set PLIST(5)=CurTime
	Set PLIST(6)=OldResult
	Set PLIST(7)=NewResult
	Set PLIST(8)=""
	Set PLIST(9)=UserDr
	Set PLIST(10)=UserDrOther
	Set PLIST(11)=$ZU(67,15,$j)
	Set PLIST(12)=RowId,PLIST(13)="",PLIST(14)="",PLIST(15)="",PLIST(16)="",PLIST(17)=""
	//-------------------------
	&SQL(Insert Into lab.DHCQC_ResultLog Values :PLIST())
	Quit SQLCODE
}

/// 查询质控数据日志。
ClassMethod QueryLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCResultLog","QueryLog","2013-06-18","2013-06-18","","|A0310")
ClassMethod QueryLogExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, MachCode As %String, TCCode As %String) As %Status
{
	Set StartDate=$Get(StartDate),EndDate=$Get(EndDate),MachCode=$Get(MachCode),TCCode=$Get(TCCode)
	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set LogNum=1
	Set CurDate="" For  Set CurDate=$Order(^DHCQCRLogi(CurDate)) Quit:CurDate=""  Do
	.If CurDate<StartDate Quit
	.If CurDate>EndDate Quit
	.Set CurTime="" For  Set CurTime=$Order(^DHCQCRLogi(CurDate,CurTime)) Quit:CurTime=""  Do
	..Set RowId="" For  Set RowId=$Order(^DHCQCRLogi(CurDate,CurTime,RowId)) Quit:RowId=""  Do
	...Set StrData=$Get(^DHCQCRLog(RowId))
	...Set FormData=$Piece(StrData,"^",1)
	...Set ModDate=$ZD(CurDate,3),ModTime=$ZT(CurTime)
	...Set NewResult=$Piece(StrData,"^",4),OldResult=$Piece(StrData,"^",5)
	...Set ModUser=$Piece(StrData,"^",7),OldModUser=$Piece(StrData,"^",8)
	...Set ModIp=$Piece(StrData,"^",9)
	...//对仪器及项目进行判断。
	...Set QCRowId=$Piece(StrData,"^",10)
	...Set MatLotRowId="",CurMachCode=""
	...Set CurTCCode=$Piece(QCRowId,"||",4)
	...Set ResultTCName=""
	...If $Length(CurTCCode) Set ResultTCName=$Piece(^TTAB("TC",CurTCCode),"\",1)
	...If $Length(TCCode),TCCode'[CurTCCode Quit
	...If $Length(QCRowId) Set MatLotRowId=$Piece($Get(^DHCQCIV(QCRowId,$Piece(QCRowId,"||",2),$Piece(QCRowId,"||",5))),"^",6)
	...If $Length(MatLotRowId) Set CurMachCode=$Piece($Get(^DHCQCMAT($Piece(MatLotRowId,"||",1))),"^",3)
	...If $Length(MachCode),MachCode'=CurMachCode Quit
	...Set MachName=""
	...If $Length(CurMachCode) Set MachName=$Piece($Get(^TMIF(CurMachCode)),"\",1)
	...//----------------------
	...Do Output
	...Set LogNum=LogNum+1
	If LogNum<2 Do
	.Set (LogNum,ModDate,ModTime,FormData,NewResult,ResultTCName,OldResult,ModUser,OldModUser,ModIp,MachName)=""
	.Do Output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
Output
	set Data=$lb(LogNum,ModDate,ModTime,FormData,MachName,ResultTCName,NewResult,OldResult,ModUser,OldModUser,ModIp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLogExecute ]
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
/// CreatDate：    20130601
/// Description:： 查询日志列表
/// Table：        DHCQC_ResultLog
/// Input：        DepCode:科室代码,MachName:仪器名称,HospCode:医院代码
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
Query QueryLog(StartDate As %String, EndDate As %String, MachCode As %String, TCCode As %String) As %Query(ROWSPEC = "LogNum:%String,ModDate:%String,ModTime:%String,FormData:%String,MachName:%String,ResultTCName:%String,NewResult:%String,OldResult:%String,ModUser:%String,OldModUser:%String,ModIp:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCQCResultLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCResultLogD</DataLocation>
<DefaultData>DHCQCResultLogDefaultData</DefaultData>
<IdLocation>^web.DHCQCResultLogD</IdLocation>
<IndexLocation>^web.DHCQCResultLogI</IndexLocation>
<StreamLocation>^web.DHCQCResultLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
