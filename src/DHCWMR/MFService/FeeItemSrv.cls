/// 名称: DHCWMR.MFService.FeeItemSrv
/// 描述: 病案收费项相关服务
/// 编写者：李毅
/// 编写日期: 2015-07-23
Class DHCWMR.MFService.FeeItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     李毅
/// CreatDate：   2015-07-23
/// Description:  查询病案收费项
/// Table：       DHCWMR.MF.FeeItem
/// Input：       
/// output:       病案收费项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.MFService.FeeItemSrv","QryFeeItem","")
Query QryFeeItem() As %Query(ROWSPEC = "ID:%String,FICode:%String,FIDesc:%String") [ SqlProc ]
{
}

ClassMethod QryFeeItemExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xID = ""
 	For {
	 	Set xID =$o(^DHCWMR.MF.FeeItemD(xID))
	 	Quit:xID=""
	 	
	 	Set objFeeItem = ##class(DHCWMR.MF.FeeItem).GetObjById(xID)
	 	Continue:'$IsObject(objFeeItem)
	 	
	 	Set FICode = objFeeItem.FICode
	 	Set FIDesc = objFeeItem.FIDesc
	 	Set Data = $lb(xID,FICode,FIDesc)
	 	Set ^CacheTemp(repid,ind)=Data
	    Set ind=ind+1
	 }
 	
	Quit $$$OK
}

ClassMethod QryFeeItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFeeItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFeeItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFeeItemExecute ]
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

/// Creator：     李毅
/// CreatDate：   2015-07-23
/// Description:  通过病案收费项ID查询病案收费项对照
/// Table：       DHCWMR.MF.FeeItemSub
/// Input：       
/// output:       病案收费项对照    
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.MFService.FeeItemSrv","QryFItemSubByPaf","1")
Query QryFItemSubByPaf(aFeeItemID As %String) As %Query(ROWSPEC = "ID:%String,TarItemDr:%String,TarItemDesc:%String,SttDate:%String,EndDate:%String,MrTpIDs:%String,MrTpDescs:%String,HospIDs:%String,HospDescs:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryFItemSubByPafExecute(ByRef qHandle As %Binary, aFeeItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aFeeItemID="" $$$OK
 	
 	Quit:'$d(^DHCWMR.MF.FeeItemD(aFeeItemID)) $$$OK
 	
 	Set xSubID = ""
 	For {
		Set xSubID = $o(^DHCWMR.MF.FeeItemD(aFeeItemID,"FIS",xSubID))
		Quit:xSubID=""
		
		Set FeeItemSub =  $g(^DHCWMR.MF.FeeItemD(aFeeItemID,"FIS",xSubID))
		Set ID = aFeeItemID_"||"_xSubID
		Set objFeeItemSub = ##class(DHCWMR.MF.FeeItemSub).GetObjById(ID)
		Continue:'$IsObject(objFeeItemSub)
		
		Set TarItemDr 	= objFeeItemSub.FISTarItemDr
		Set SttDate 	= objFeeItemSub.FISSttDate
		Set EndDate 	= objFeeItemSub.FISEndDate
		Set MrTpIDs 	= objFeeItemSub.FISMrTpIDs
		Set HospIDs 	= objFeeItemSub.FISHospIDs
		Set Resume 		= objFeeItemSub.FISResume
		
		Set TarItemDesc = $p($g(^DHCTARI(TarItemDr)),"^",2)
		;Set:SttDate'="" SttDate = $zd(SttDate,3)
		;Set:EndDate'="" EndDate = $zd(EndDate,3)
		Set:SttDate'="" SttDate = ##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(SttDate)
		Set:EndDate'="" EndDate = ##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(EndDate)
		
		Set MrTpDescs = ""
		For indMrTp=1:1:$l(MrTpIDs,"#") {
			Set MrTypeID=$p(MrTpIDs,"#",indMrTp)
			Continue:MrTypeID=""
			
			Set objMrType = ##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
			Continue:'$IsObject(objMrType)
			
			Set MrTpDesc=objMrType.MTDesc
			Continue:MrTpDesc=""
			
			Set MrTpDescs=MrTpDescs_","_MrTpDesc
		}
		Set:MrTpDescs'="" MrTpDescs=$e(MrTpDescs,2,$l(MrTpDescs))
		
		Set HospDescs=""
		For indHosp=1:1:$l(HospIDs,"#") {
			Set HospID=$p(HospIDs,"#",indHosp)
			Continue:HospID=""
			
			Set HospDesc=$p($g(^CT("HOSP",HospID)),"^",2)
			Continue:HospDesc=""
			
			Set HospDescs=HospDescs_","_HospDesc
		}
		Set:HospDescs'="" HospDescs=$e(HospDescs,2,$l(HospDescs))
		
		Set Data = $lb(ID,TarItemDr,TarItemDesc,SttDate,EndDate,MrTpIDs,MrTpDescs,HospIDs,HospDescs,Resume)
		Set ^CacheTemp(repid,ind)=Data
	    Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryFItemSubByPafClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFItemSubByPafExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFItemSubByPafFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFItemSubByPafExecute ]
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

/// w ##Class(DHCWMR.MFService.FeeItemSrv).ImportFeeItemSub("FY^A01N008^病历复印费^^^6#7#101^")
ClassMethod ImportFeeItemSub(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:aInputStr="" return
	
	Set FeeItemCode=$p(aInputStr,"^",1)
	Set TarItemCode=$p(aInputStr,"^",2)
	Set TarItemDesc=$p(aInputStr,"^",3)
	Set DateFrom=$p(aInputStr,"^",4)
	Set DateTo=$p(aInputStr,"^",5)
	Set MrTypeIDs=$p(aInputStr,"^",6)
	Set HospIDs=$p(aInputStr,"^",7)
	Quit:(FeeItemCode="")||(TarItemCode="")||(MrTypeIDs="") return
	
	Set objFeeItem=##Class(DHCWMR.MF.FeeItem).GetObjByCode(FeeItemCode)
	Quit:'$IsObject(objFeeItem) return
	Set FeeItemID=objFeeItem.%Id()
	
	Set tmpTarItemCode=$$ALPHAUP^SSUTIL4(TarItemCode)
	Quit:tmpTarItemCode="" return
	Set TarItemID=$o(^DHCTARI(0,"Code",tmpTarItemCode,0))
	Quit:TarItemID="" return
	Quit:'$d(^DHCTARI(TarItemID)) return
	
	Set InputStr=""
	Set $p(InputStr,"^",1)=""
	Set $p(InputStr,"^",2)=FeeItemID
	Set $p(InputStr,"^",3)=TarItemID
	Set $p(InputStr,"^",4)=DateFrom
	Set $p(InputStr,"^",5)=DateTo
	Set $p(InputStr,"^",6)=MrTypeIDs
	Set $p(InputStr,"^",7)=HospIDs
	Set return=##class(DHCWMR.MF.FeeItemSub).Update(InputStr,"^")
	Quit return
}

}
