/// 批次信息查询。
Class web.DHCQCBaseLot Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetMetMachineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMetMachineExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCBaseLot","GetMetMachine","ACA5301")
ClassMethod GetMetMachineExecute(ByRef qHandle As %Binary, MatCode As %String) As %Status
{
	Set MatCode=$Get(MatCode)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	If MatCode="" Quit $$$OK
	s LotCompany=""
	If $Data(^DHCQCLOT(MatCode)) Do
	.Set LotCode="" For  Set LotCode=$Order(^DHCQCLOT(MatCode,LotCode)) Quit:LotCode=""  Do
	..Set str=$Get(^DHCQCLOT(MatCode,LotCode))
	..Set LotDesc=$Piece(str,"^",1)
	..Set StartDate=$ZD($Piece(str,"^",3),3)
	..Set EndDate=$ZD($Piece(str,"^",4),3)
	..Set ProductDate=$ZD($Piece(str,"^",5),3)
	..Set ExpiryDate=$ZD($Piece(str,"^",6),3)
	..Set Comments=$Piece(str,"^",7)
	..Set Visible=$Piece(str,"^",8)
	..Set ProductDr=$p($Piece(str,"^",9),$c(13),1)
	..s LotCompany=$p($Piece(str,"^",9),$c(13),2)
	..//Autstorage:即为CurLot
	..Set Autstorage=$Piece(str,"^",10)
	..Set Time=$Piece(str,"^",11)
	..Set Alias=$Piece(str,"^",12)
	..i Autstorage="Y" s Autstorage="true"
	..e  s Autstorage="false"
	..i Visible="Y" s Visible="true"
	..e  s Visible="false"
	..Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
OutputRow
    Set Data=$lb(MatCode,LotDesc,StartDate,EndDate,ProductDate,ExpiryDate,Comments,Visible,ProductDr,Autstorage,Time,Alias,LotCode,LotCompany)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMetMachineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMetMachineExecute ]
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
/// CreatDate：    20101102
/// Description:： 按照批次，项目信息查询质控设置！。
/// Table：        DHCQC_Lot,DHCQC_Material,DHCQC_TestCode
/// Input：        MatCode:质控物代码
/// Output：       质控物信息。
/// Return：       
/// Others：       
Query GetMetMachine(MatCode As %String) As %Query(ROWSPEC = "MatCode:%String,LotDesc:%String,StartDate:%String,EndDate:%String,ProductDate:%String,ExpiryDate:%String,Comments:%String,Visible:%String,ProductDr:%String,Autstorage:%String,Time:%String,Alias:%String,LotCode:%String,LotCompany") [ SqlProc ]
{
}

ClassMethod GetTCSetUpXSDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTCSetUpXSDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……"AXE2100||AXE2100"
/// d ##class(%ResultSet).RunQuery("web.DHCQCBaseLot","GetTCSetUpXSD","CA1500","CA1500","A0580")
ClassMethod GetTCSetUpXSDExecute(ByRef qHandle As %Binary, MatCode As %String, LotCode As %String, TCCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set MatCode=$Get(MatCode),LotCode=$Get(LotCode),TCCode=$Get(TCCode)
	Set LotParRef=MatCode_"||"_LotCode
	If $Data(^DHCQCTC(LotParRef)) Do
	.//增加对浓度的提示
	.s LevelsNum=$p($g(^DHCQCMAT($p(LotParRef,"||",1))),"^",8)
	.If $Data(^DHCQCTC(LotParRef,TCCode)) Do
	..Set Seq="" For  Set Seq=$Order(^DHCQCTC(LotParRef,TCCode,Seq)) Quit:Seq=""  Do
	...i Seq>LevelsNum q
	...Set str=$Get(^DHCQCTC(LotParRef,TCCode,Seq))
	...Set Visible=$Piece(str,"^",3)
	...If Visible="N" Quit
	...Set Dilutes=$Piece(str,"^",2)
	...Set TargetDesc=$Piece(str,"^",5)
	...Set TargetValue=$Piece(str,"^",6)
	...If TargetValue="0" Set TargetValue=""
	...Set TargetSD=$Piece(str,"^",7)
	...If TargetSD="0" Set TargetSD=""
	...Set Decimal=$Piece(str,"^",8)
	...Set CALCMean=$Piece(str,"^",9)
	...If CALCMean="0" Set CALCMean=""
	...Set CALCSD=$Piece(str,"^",10)
	...If CALCSD="0" Set CALCSD=""
	...Set CalcCV=$Piece(str,"^",11)
	...If CalcCV="0" Set CalcCV=""
	...//AutstFlag:MeanType
	...Set Autstorage=$Piece(str,"^",12)
	...i Autstorage="Y" s Autstorage="true"
	...e  s Autstorage="false"
	...//此字段改为取月计算值来绘图.
	...//Set Comments="false"
	...Set Comments=$Piece(str,"^",13)
	...If Comments="Y" Set Comments="true"
	...e  s Comments="false"
	...Set ACTCSum =$Piece(str,"^",14)
	...If ACTCSum="0" Set ACTCSum=""
	...Set ACTCMean =$Piece(str,"^",15)
	...If ACTCMean="0" Set ACTCMean=""
	...Set ACSD=$Piece(str,"^",16)
	...If ACSD="0" Set ACSD=""
	...Set RowId=MatCode_"||"_LotCode_"||"_TCCode_"||"_Seq
	...Do OutTCXSD
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutTCXSD
	set Data=$lb(Seq,Dilutes,TargetDesc,TargetValue,TargetSD,Decimal,CALCMean,CALCSD,CalcCV,Autstorage,Comments,ACTCSum,ACTCMean,ACSD,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetTCSetUpXSDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTCSetUpXSDExecute ]
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
/// CreatDate：    20101102
/// Description:： 按照批次，项目信息查询质控设置！。
/// Table：        DHCQC_Lot,DHCQC_Material,DHCQC_TestCode
/// Input：        LotParRef:质控批号,MatCode:质控物代码，TCCode：项目代码
/// Output：       项目浓度设置信息
/// Return：       
/// Others：       Autstorage:MeanType是否使用上月计算值为设定标准差             
Query GetTCSetUpXSD(MatCode As %String, LotCode As %String, TCCode As %String) As %Query(ROWSPEC = "Seq:%String,Dilutes:%String,TargetDesc:%String,TargetValue:%String,TargetSD:%String,Decimal:%String,CALCMean:%String,CALCSD:%String,CalcCV:%String,Autstorage:%String,Comments:%String,ACTCSum:%String,ACTCMean:%String,ACSD:%String,RowId:%String") [ SqlProc ]
{
}

ClassMethod UpdateVisible(MatCode As %String, LotCode As %String, TCCode As %String) As %String
{
	s RowId=""
	&sql(Update lab.DHCQC_Lot Set DQCL_LotDesc=:LotDesc,DQCL_StartDate=:StartDate,DQCL_EndDate=:EndDate,DQCL_ProductDate=:ProductDate,DQCL_ExpiryDate=:ExpiryDate,DQCL_Comments=:Comments,DQCL_Visible=:Visible,DQCL_ProductDr=:ProductDr,DQCL_CurLot=:CurLot,DQCI_Time=:Time,DTCL_Alias=:Alias Where DHCQC_RowId=:RowId )
	q SQLCODE
}

Storage Default
{
<Data name="DHCQCBaseLotDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCBaseLotD</DataLocation>
<DefaultData>DHCQCBaseLotDefaultData</DefaultData>
<IdLocation>^web.DHCQCBaseLotD</IdLocation>
<IndexLocation>^web.DHCQCBaseLotI</IndexLocation>
<StreamLocation>^web.DHCQCBaseLotS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
