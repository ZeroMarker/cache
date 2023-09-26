/// 质控规则信息查询
Class web.DHCQCAmendLiquid Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCAmendLiquid","GetAll","","","","")
ClassMethod GetAllExecute(ByRef qHandle As %Binary, code As %String, name As %String, sequence As %String, visible As %String) As %Status
{
	Set code=$Get(code),name=$Get(name),sequence=$Get(sequence),visable=$Get(visable)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set AmendLiCode="" For  Set AmendLiCode=$Order(^DHCQCAL(AmendLiCode)) Quit:AmendLiCode=""  Do
	.Set str=$Get(^DHCQCAL(AmendLiCode))
	.b ;11
	.Set uName=$Piece(str,"^",2)
	.If $Length(code),AmendLiCode'=code Quit
	.If $Length(uName),uName'[name Quit
	.Set Seqenue=$Piece(str,"^",3)
	.Set VisFlag=$Piece(str,"^",4)
	.If $Length(visable),VisFlag'=visable Quit
	.i VisFlag="Y" s VisFlag="true"
	.e  s VisFlag="false"
	.Do OutputRow		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(AmendLiCode,uName,Seqenue,VisFlag)
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
Query GetAll(code As %String, name As %String, sequence As %String, visible As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,Sequence:%String,Visible:%String") [ SqlProc ]
{
}

}
