/// 名称: web.DHCEQ.EM.CTFinaceItem
/// 描述: 核算项目
/// 编写者：QW
/// 编写日期: 2019-03-25
/// 产品组：设备管理
Class web.DHCEQ.EM.CTFinaceItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      QW
/// CreatDate：    2019-03-25
/// Description:   核算项目LookUp所需Query
/// Table：        DHC_EQCFinaceItem
/// Input：        Name:单位描述
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.CTFinaceItem","GetFinaceItem","")
Query GetFinaceItem(Name As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String") [ SqlProc ]
{
}

ClassMethod GetFinaceItemExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set Name=$ZCONVERT(Name ,"U")
 	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId("","")	//CZF0138 2021-05-26
	
	Set index=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCFinaceItem",rowid)) Quit:rowid=""  Do
	.q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCFinaceItem",rowid,sHospID)'="Y"		//CZF0138 2021-05-26
	.Do ResetVariablesGetFinaceItem
	.Set TRowID = rowid	//rowid
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCFinaceItem",TRowID)),"^",1) //代码
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCFinaceItem",TRowID)),"^",2) //描述
	.Set TInvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCFinaceItem",TRowID)),"^",4) //无符号标志
	.Quit:TInvalidFlag="Y"
	.Quit:($ZCONVERT(TCode,"U")'[Name)&($ZCONVERT(TDesc,"U")'[Name)&(Name'="")
	.Do OutputRowGetFinaceItem
	Quit $$$OK
OutputRowGetFinaceItem
   	Set Data=$lb(TDesc,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetFinaceItem
	Set (TDesc,TRowID,TCode)=""
	Quit
}

ClassMethod GetFinaceItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFinaceItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetFinaceItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFinaceItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
