Class DHCMed.EPDService.DicMapping Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.DicMapping","QryDicMapInfo",8604)
Query QryDicMapInfo(argDicID As %String) As %Query(ROWSPEC = "ind:%String,argDicID:%String,DicName:%String,MappingID:%String,TargetDesc:%String")
{
}

ClassMethod QryDicMapInfoExecute(ByRef qHandle As %Binary, argDicID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:argDicID="" $$$OK
	
	Set DicObj=##class(DHCMed.SS.Dictionary).GetObjById(argDicID)
	Quit:'$IsObject(DicObj) $$$OK
	Set Code=DicObj.Code
	Quit:Code="" $$$OK
	
	if (Code="EPDInfection")
	{
		Set rowid=0
		For {
			Set rowid=$o(^DHCMed.EPDC("IF",rowid))
			Quit:rowid=""
			Set objInf=##Class(DHCMed.EPD.Infection).GetObjById(rowid)
			Continue:'$IsObject(objInf)
			
			Set (MappingID,TargetDesc)=""
			if ($d(^DHCMed.EPD.CDCDicMappingI("IndexCategorySrcID"," "_argDicID," "_rowid)))
			{
				Set MappingID=$o(^DHCMed.EPD.CDCDicMappingI("IndexCategorySrcID"," "_argDicID," "_rowid,""))
				Set MapObj=##class(DHCMed.EPD.CDCDicMapping).GetObjById(MappingID)
				if ($IsObject(MapObj))
				{
					Set TargetDesc=MapObj.TargetDesc
				}
			}
			Set IFName=objInf.MIFDisease
			Set Data=$lb(ind,rowid,IFName,MappingID,TargetDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
	}else{
		Set Code = $ZCVT(Code,"U")
		Set argCode=""
		For {
			Set argCode=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," "_Code,argCode))
			Quit:argCode=""
			
			Set rowid = ""
			For {
				Set rowid = $o(^DHCMed.SS.DictionaryI("IndexTypeCode"," "_Code,argCode,rowid))
				Quit:rowid=""
		
				Set objDic = ##class(DHCMed.SS.Dictionary).%OpenId(rowid)
				Continue:'$IsObject(objDic)
				
				Set (MappingID,TargetDesc)=""
				if ($d(^DHCMed.EPD.CDCDicMappingI("IndexCategorySrcID"," "_argDicID," "_rowid)))
				{
					Set MappingID=$o(^DHCMed.EPD.CDCDicMappingI("IndexCategorySrcID"," "_argDicID," "_rowid,""))
					Set MapObj=##class(DHCMed.EPD.CDCDicMapping).GetObjById(MappingID)
					if ($IsObject(MapObj))
					{
						Set TargetDesc=MapObj.TargetDesc
					}
				}
				Set DicName=objDic.Description
				Set Data=$lb(ind,rowid,DicName,MappingID,TargetDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		
	} 
	Quit $$$OK
}

ClassMethod QryDicMapInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicMapInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDicMapInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicMapInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	// if there are no more rows, finish fetching
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	// fetch row
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
