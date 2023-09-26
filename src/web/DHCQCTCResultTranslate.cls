Class web.DHCQCTCResultTranslate Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod QueryMachTCTranClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMachTCTranExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCTCResultTranslate","QueryMachTCTran","BAX428","B0320")
ClassMethod QueryMachTCTranExecute(ByRef qHandle As %Binary, MachineCode As %String, TCCode As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set (MachResult,MachResultTran,MachRVisible)=""
	Set MachineCode=$Get(MachineCode)
	Set TCCode=$Get(TCCode)
	If '$Length(MachineCode) Do OutputRow
	If '$Length(TCCode) Do OutputRow
    If $Data(^DHCQCTCTran(MachineCode,TCCode)) Do
    .Set TCId="" For  Set TCId=$Order(^DHCQCTCTran(MachineCode,TCCode,TCId)) Quit:TCId=""  Do
    ..Set StrData=$Get(^DHCQCTCTran(MachineCode,TCCode,TCId))
    ..Set MachResult=TCId
    ..Set MachResultTran=$Piece(StrData,"^",2)
    ..Set MachRVisible=$Piece(StrData,"^",3)
    ..If MachRVisible="Y" Set MachRVisible="true"
    ..If MachRVisible="N" Set MachRVisible="false"
    ..Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(MachResult,MachResultTran,MachRVisible)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryMachTCTranFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMachTCTranExecute ]
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
/// CreatDate：    20130614
/// Description:： 查询仪器结果翻译数据
/// Table：        DHCQC_TCTran
/// Input：        MachineCode：仪器代码,TCCode:项目代码
/// Output：       质控评价信息
/// Return：       
/// Others：
Query QueryMachTCTran(MachineCode As %String, TCCode As %String) As %Query(ROWSPEC = "MachResult,MachResultTran,MachRVisible") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20130614
/// Description:： 保存仪器结果翻译数据
/// Table：        DHCQC_TCTran
/// Input：        MachineCode：仪器代码,TCCode:项目代码,TCId:仪器结果,TCDesc:质控描述,TCFlag:质控标示 
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCTCResultTranslate).InsertTCTran("","","","","")
ClassMethod QueryQCTCTranId(MachineCode As %String, TCCode As %String, TCId As %String) As %String
{
	Set MachineCode=$Get(MachineCode),TCCode=$Get(TCCode),TCId=$Get(TCId)
    Set Ret=0
    If $Data(^DHCQCTCTran(MachineCode,TCCode,TCId)) Do
    .Set Ret=1
    Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130614
/// Description:： 保存仪器结果翻译数据
/// Table：        DHCQC_TCTran
/// Input：        MachineCode：仪器代码,TCCode:项目代码,TCId:仪器结果,TCDesc:质控描述,TCFlag:质控标示 
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCTCResultTranslate).InsertTCTran("BAX428","B0320","+-","0.5","Y")
ClassMethod InsertTCTran(MachineCode As %String, TCCode As %String, TCId As %String, TCDesc As %String, TCFlag As %String) As %String
{
	Set MachineCode=$Get(MachineCode),TCCode=$Get(TCCode),TCId=$Get(TCId),TCDesc=$Get(TCDesc),TCFlag=$Get(TCFlag)
    Kill PLIST
    Set RetValue=100
    Set PLIST(2)=MachineCode,PLIST(3)=TCCode,PLIST(4)=TCId,PLIST(5)=TCDesc
    Set PLIST(6)=TCFlag,PLIST(7)="",PLIST(8)="",PLIST(9)="",PLIST(10)="",PLIST(11)="",PLIST(12)=""
	If '$Data(^DHCQCTCTran(MachineCode,TCCode,TCId)) Do
	.&SQL(Insert Into lab.DHCQC_TCTran Values :PLIST())
	.Set RetValue=SQLCODE
	Else  Do
	.Set RowId=MachineCode_"||"_TCCode_"||"_TCId
	.Set RetValue=..UpdateTranslate(RowId,TCDesc)
	Quit RetValue
}

/// Creator：      DaiYi
/// CreatDate：    20130614
/// Description:： 更新仪器结果翻译数据
/// Table：        DHCQC_TCTran
/// Input：        RowId:唯一码ID
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCTCResultTranslate).UpdateTranslate("BAX428||B0320||+-","0.5")
ClassMethod UpdateTranslate(RowId As %String, TCDesc As %String) As %String
{
	Set RowId=$Get(RowId),TCDesc=$Get(TCDesc)
	Set MachCode=$Piece(RowId,"||",1)
	Set TCCode=$Piece(RowId,"||",2)
	Set TCId=$Piece(RowId,"||",3)
	If '$Length(MachCode) Quit 100
	If '$Length(TCCode) Quit 100
	If '$Length(TCId) Quit 100
	Set Ret=100
    If $Data(^DHCQCTCTran(MachCode,TCCode,TCId)) Do
    .&SQL(Update lab.DHCQC_TCTran Set DQCT_TCDesc=:TCDesc Where DQTT_RowId=:RowId)
    .Set Ret=SQLCODE
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130614
/// Description:： 删除仪器结果翻译数据
/// Table：        DHCQC_TCTran
/// Input：        RowId:唯一码ID
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCTCResultTranslate).DeleteTCTran("BAX428||B0320||+-")
ClassMethod DeleteTCTran(RowId As %String) As %String
{
	Set RowId=$Get(RowId)
	Set MachCode=$Piece(RowId,"||",1)
	Set TCCode=$Piece(RowId,"||",2)
	Set TCId=$Piece(RowId,"||",3)
	If '$Length(MachCode) Quit 100
	If '$Length(TCCode) Quit 100
	If '$Length(TCId) Quit 100
	Set Ret=100
    If $Data(^DHCQCTCTran(MachCode,TCCode,TCId)) Do
	.&SQL(Delete From lab.DHCQC_TCTran Where DQTT_RowId=:RowId)
	.Set Ret= SQLCODE
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130614
/// Description:： 删除仪器结果翻译数据
/// Table：        DHCQC_TCTran
/// Input：        RowId:唯一码ID
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCTCResultTranslate).QueryTranResult("AFUS20","A0310","1")
ClassMethod QueryTranResult(MachCode As %String, TCCode As %String, Result As %String) As %String
{
	Set MachCode=$Get(MachCode),TCCode=$Get(TCCode),Result=$Get(Result)
	Set Ret=""
	If '$Length(MachCode) Quit Ret
	If '$Length(TCCode) Quit Ret
	If '$Length(Result) Quit Ret
	If $Data(^DHCQCTCTran(MachCode,TCCode)) Do
	.Set CurResult="" For  Set CurResult=$Order(^DHCQCTCTran(MachCode,TCCode,CurResult)) Quit:CurResult=""  Do
	..Set StrData=$Get(^DHCQCTCTran(MachCode,TCCode,CurResult))
	..Set ResultData=$Piece(StrData,"^",2)
	..If Result=ResultData Set Ret=CurResult
	b ;13
	Quit Ret
}

Storage Default
{
<Data name="DHCQCTCResultTranslateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCTCResultTranslateD</DataLocation>
<DefaultData>DHCQCTCResultTranslateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCTCResultTranslateD</IdLocation>
<IndexLocation>^web.DHCQCTCResultTranslateI</IndexLocation>
<StreamLocation>^web.DHCQCTCResultTranslateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
