Class DHCMA.CPW.SDS.QCItemOptionsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2018-12-25
/// Description:  查询质控病种值域信息
/// Table：       DHCMA.CPW.SD.QCEntityItemOptions      
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCItemOptionsSrv","QryQCItemOptions","9||283")
Query QryQCItemOptions(aItemDr As %String) As %Query(ROWSPEC = "BTID:%String,ItemDr:%String,BTCode:%String,BTDesc:%String,BTDate:%String,BTTime:%String,BTActive:%String,UserName:%String,BTIndNo:%String")
{
}

ClassMethod QryQCItemOptionsExecute(ByRef qHandle As %Binary, aItemDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	For
 	{	
 		Set xRowID=$o(^DHCMA.CPW.SD.QCItemOptionsI("IndexOfItem",aItemDr,xRowID))
 		Quit:xRowID=""
 		Set ObjEntityItemOptions = ##class(DHCMA.CPW.SD.QCItemOptions).GetObjById(xRowID)
 		Set BTCode          = ObjEntityItemOptions.BTCode
 		Set BTDesc         	= ObjEntityItemOptions.BTDesc
 		Set BTDate         	= ObjEntityItemOptions.BTDate
 		Set BTDate			= ##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(BTDate)
 		Set BTTime         	= ObjEntityItemOptions.BTTime
 		Set BTTime         	= ##class(websys.Conversions).TimeLogicalToHtml(BTTime)
 		Set BTActive		= ObjEntityItemOptions.BTActive
 		Set BTUpdateUser	= ObjEntityItemOptions.BTUpdateUser
 		Set UserName		= $P($g(^SSU("SSUSR",BTUpdateUser)),"^",1)
 		Set BTIndNo			= ObjEntityItemOptions.BTIndNo
 		Set BTActive=$s(BTActive=1:"是",1:"否")
 		
		Set Data=$lb(xRowID,aItemDr,BTCode,BTDesc,BTDate,BTTime,BTActive,UserName,BTIndNo)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryQCItemOptionsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCItemOptionsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCItemOptionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCItemOptionsExecute ]
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

/// 根据项目代码获取项目ID
/// w ##class(DHCMA.CPW.SDS.QCItemOptionsSrv).getItemDrByCode("HF-0-1-1-4")
ClassMethod getItemDrByCode(ItemCode As %String) As %String
{
	new (ItemCode)
	Set return=""
	Quit:ItemCode="" return
	Set ItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByCode(ItemCode)
	Quit:'$IsObject(ItemObj) return
	Quit ItemObj.%Id()
}

/// w ##class(DHCMA.CPW.SDS.QCItemOptionsSrv).ImportQCItemOptions()
ClassMethod ImportQCItemOptions(aInputStr As %String) As %String
{
	Set ^tmpzgz123=aInputStr
	New (aInputStr,aSeparete)
	Set return=-1
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set QCItemCode		 = $p(aInputStr,aSeparete,1)
	Set ItemDr=..getItemDrByCode(QCItemCode)
	Quit:ItemDr="" return
	Set Code            	= $p(aInputStr,aSeparete,2)
	Set Desc             	= $p(aInputStr,aSeparete,3)
	Set IndNo             	= $p(aInputStr,aSeparete,4)
	Set AcTive             	= $p(aInputStr,aSeparete,5)
	Set InputStr=ItemDr_"^^"_Code_"^"_Desc_"^"_AcTive_"^1^"_IndNo
	Set return=##class(DHCMA.CPW.SD.QCItemOptions).Update(InputStr)
	Quit return
}

}
