Class web.DHCQCMatLotTCAll Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.DHCQCMatLotTCAll","GetMetLotTCByMachine","","")
ClassMethod GetMetLotTCByMachineExecute(ByRef qHandle As %Binary, MatCode As %String, LotCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set MatCode=$Get(MatCode),LotCode=$Get(LotCode)
	Set RowId=MatCode_"||"_LotCode
	Set (TCCode,Name,MatName,LotName,QCID,CurMachCode)="" 
	Set Num=0
	Set Visible="false"
	If '$Length(MatCode) Do
	.Do OutputMetLotTC
	.Set qHandle=$lb(0,repid,0)
	If '$Length(LotCode) Do
	.Do OutputMetLotTC
	.Set qHandle=$lb(0,repid,0)
	If '$Length(MatCode) Quit $$$OK
	If '$Length(LotCode) Quit $$$OK
	If $Data(^DHCQCMAT(MatCode)) Do
	.Set MatName=$Piece(^DHCQCMAT(MatCode),"^",2)
	.s CurMachCode=$p($g(^DHCQCMAT(MatCode)),"^",3)
	If $Data(^DHCQCLOT(MatCode,LotCode)) Set LotName=$Piece(^DHCQCLOT(MatCode,LotCode),"^",2)
	If $Data(^DHCQCTC(RowId)) Do
	.Set TCCode="" For  Set TCCode=$Order(^DHCQCTC(RowId,TCCode)) Quit:TCCode=""  Do
	..Set Name=$Piece(^TTAB("TC",TCCode),"\",1)
	..Set QCID=""
	..Set LevNo="" For  Set LevNo=$Order(^DHCQCTC(RowId,TCCode,LevNo)) Quit:LevNo=""  Do
	...If $p($g(^DHCQCTC(RowId,TCCode,1)),"^",3)'="Y" q
	...If QCID'="" Do
	....Set QCID=QCID_","_LevNo
	...Else  Do
	....Set QCID=LevNo
	..i $l(QCID) Do OutputMetLotTC
	..Set Num=Num+1
	If Num<1 Do OutputMetLotTC
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputMetLotTC
	set Data=$lb(TCCode,Name,QCID,MatName,LotName,MatCode,LotCode,CurMachCode,Visible)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetMetLotTCByMachineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMetLotTCByMachineExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{	
 	    // if there are no more rows, finish fetching
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

Query GetMetLotTCByMachine(MatCode As %String, LotCode As %String) As %Query(ROWSPEC = "TCCode,Name,QCID,MatName,LotName,MatCode,LotCode,CurMachCode,Visible") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20120216
/// Description:： 根据质控批号查询仪器项目。
/// Table：        
/// Input：        MatCode：质控物,LotCode:质控批号 
/// Output：       所有项目集合
/// Return：       
/// Others：
ClassMethod GetMetLotTCByMachineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMetLotTCByMachineExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="DHCQCMatLotTCAllDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCMatLotTCAllD</DataLocation>
<DefaultData>DHCQCMatLotTCAllDefaultData</DefaultData>
<IdLocation>^web.DHCQCMatLotTCAllD</IdLocation>
<IndexLocation>^web.DHCQCMatLotTCAllI</IndexLocation>
<StreamLocation>^web.DHCQCMatLotTCAllS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
