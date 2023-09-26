/// 服务细项表
/// Mozy	2010-11-22
/// ^DHCEQCCode("DHCEQCServiceDetails",{SDI_RowID})
Class web.DHCEQCServiceDetails Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQCServiceDetails","ServiceDetails","","")
/// modified by czf 397032 增加TRow并输出
Query ServiceDetails(ServiceItem As %String = "", ServDetItem As %String = "") As %Query(ROWSPEC = "TRowID:%String,TServiceItem:%String,TServDetItem:%String,TQuantity:%String,TRemark:%String,TRow:%String")
{
}

ClassMethod ServiceDetailsExecute(ByRef qHandle As %Binary, ServiceItem As %String = "", ServDetItem As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set TRow=1
	set ServiceItem=$ZCONVERT(ServiceItem,"U")
	set ServDetItem=$ZCONVERT(ServDetItem,"U")
	Set rowid=0
	Do BuildDataServDetItemDetail
	Quit $$$OK
BuildDataServDetItemDetail
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCServiceDetails",rowid))  Quit:rowid=""  Do
	.Do ResetVariablesServDetItemDetail
	.Set TRowID = rowid
	.Set InvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCServiceDetails",TRowID)),"^",5)
	.Quit:InvalidFlag="Y"
	.Set TServiceItemDR=$Piece($Get(^DHCEQCCode("DHCEQCServiceDetails",TRowID)),"^",1)
	.If TServiceItemDR'="" Set TServiceItem=$Piece($Get(^DHCEQCCode("DHCEQCServiceItem",TServiceItemDR)),"^",1)
	.set TServiceItem=$ZCONVERT(TServiceItem,"U")
	.Quit:(ServiceItem'="")&&(TServiceItem'[ServiceItem)
	.Set TServDetItemDR=$Piece($Get(^DHCEQCCode("DHCEQCServiceDetails",TRowID)),"^",2)
	.If TServDetItemDR'="" Set TServDetItem=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",TServDetItemDR)),"^",1)
	.set TServDetItem=$ZCONVERT(TServDetItem,"U")
	.Quit:(ServDetItem'="")&&(TServDetItem'[ServDetItem)
	.Set TQuantity=$Piece($Get(^DHCEQCCode("DHCEQCServiceDetails",TRowID)),"^",3)
	.Set TRemark=$Piece($Get(^DHCEQCCode("DHCEQCServiceDetails",TRowID)),"^",4)
	.
	.Do OutputRowServDetItemDetail
	Quit
OutputRowServDetItemDetail
	Set Data=$lb(TRowID,TServiceItem,TServDetItem,TQuantity,TRemark,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	Quit
ResetVariablesServDetItemDetail
	Set (TRowID,TServiceItem,TServDetItem,TQuantity,TRemark)=""
	Quit
}

ClassMethod ServiceDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ServiceDetailsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod ServiceDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ServiceDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCEQCServiceDetails).GetDocByID(1)
ClassMethod GetDocByID(rowid As %Library.String = "")
{
	new result,resultex
	Set (result,resultex)=""
	Set result= $Get(^DHCEQCCode("DHCEQCServiceDetails",rowid))

	Set resultex=resultex_"^"
	If $Piece(result,"^",1)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCServiceItem",$Piece(result,"^",1))),"^",1)
	Set resultex=resultex_"^"
	If $Piece(result,"^",2)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",$Piece(result,"^",2))),"^",1)
	
	Set resultex=result_resultex
	Set resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	
	Quit rowid_"^"_resultex
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	k PLIST,rowid
	Set rowid=$Piece(val,"^",1)
	If (+isDel=1)
	{
	 	Set PLIST(6)="Y" 		// InvalidFlag
	 	&SQL(Update SQLUSER.DHC_EQCServiceDetails Values :PLIST() where SD_RowID = :rowid)
	 	If SQLCODE  Quit SQLCODE
	 	Quit rowid
 	}
 	
 	Set PLIST(2)=$Piece(val,"^",2) 		// ServiceItemDR
 	Set PLIST(3)=$Piece(val,"^",3) 		// ServDetItemDR
 	Set PLIST(4)=$Piece(val,"^",4) 		// Quantity
 	Set PLIST(5)=$Piece(val,"^",5) 		// Remark
	
 	If (rowid="")  //新增按钮操作
 	{
	 	&SQL(Insert Into SQLUSER.DHC_EQCServiceDetails Values :PLIST())
 	}
 	Else  //更新按钮操作
 	{
		&SQL(Update SQLUSER.DHC_EQCServiceDetails Values :PLIST() where SD_RowID = :rowid)
 	}
 	If SQLCODE  Quit SQLCODE
 	Set ID=$Get(%ROWID)
 	Quit ID
}

ClassMethod ExType(name, width, type) As %String
{
	Write "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	Write "<option value=></option>"
	Write "<option value=1>DHC-LIS</option>"
	Write "<option value=2>DHC</option>"
	Write "</select>",!
}

ClassMethod GetEditEXType(Type As %Library.String) As %Status
{
	If Type=""  Quit ""
	If +Type=1  Quit "DHC-LIS"
	If +Type=2  Quit "DHC"
	Quit "未定义"
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCServiceDetails","GetServDetItem","")
Query GetServDetItem(Desc As %String = "") As %Query(ROWSPEC = "TDesc:%String,Hidden,TCode:%String,Hidden,TUnit:%String,TPrice:%String")
{
}

ClassMethod GetServDetItemExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	Do BuildDataGetServDetItem
	Quit $$$OK
BuildDataGetServDetItem
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCServiceDetails",rowid))  Quit:rowid=""  Do
	.Do ResetVariablesGetServDetItem
	.Set TRowID = rowid
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCServiceDetails",rowid)),"^",1)
	.Quit:(Desc'="")&&(TDesc'=Desc)
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCServiceDetails",rowid)),"^",2)
	.Set TUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCServiceDetails",rowid)),"^",3)
	.If TUnitDR'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.Set TPrice=$Piece($Get(^DHCEQCCode("DHCEQCServiceDetails",rowid)),"^",4)
	.
	.Do OutputRowGetServDetItem
	Quit
OutputRowGetServDetItem
	Set Data=$lb(TDesc,TRowID,TCode,TUnitDR,TUnit,TPrice)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetServDetItem
	Set (TDesc,TRowID,TCode,TUnitDR,TUnit,TPrice)=""
	Quit
}

ClassMethod GetServDetItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetServDetItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod GetServDetItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetServDetItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
