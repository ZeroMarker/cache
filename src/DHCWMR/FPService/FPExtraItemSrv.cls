/// 名称: DHCWMR.FPService.FPExtraItemSrv
/// 描述: 编目附加项目信息相关服务
/// 编写者：zhufei
/// 编写日期: 2014-10-30
Class DHCWMR.FPService.FPExtraItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-10-30
/// Description:  查询附加项列表
/// Table：       DHCWMR.FP.FPExtraItem
/// Input：       aFPId : 编目记录
/// Return：      ROWSPEC=...
/// D ##class(%ResultSet).RunQuery("DHCWMR.FPService.FPExtraItemSrv","QryWFEItemToFP","","2","1")
Query QryWFEItemToFP(aFrontPageID As %String, aVolumeID As %String, aFPItemID As %String) As %Query(ROWSPEC = "EItemID:%String,EItemDesc:%String,EItemTpCode:%String,EItemDicCode:%String,FPEItemID:%String,FPEItemValue:%String,FPEItemText:%String,FPEIIsNeed:%String,FPEIResume:%String") [ SqlProc ]
{
}

ClassMethod QryWFEItemToFPExecute(ByRef qHandle As %Binary, aFrontPageID As %String, aVolumeID As %String, aFPItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aFrontPageID="")&&(aVolumeID="") $$$OK
 	Quit:aFPItemID="" $$$OK
 	
 	//三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
 	Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
 	
 	If aFrontPageID'="" {
		Set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjById(aFrontPageID)
	 	Quit:'$IsObject(objFrontPage) $$$OK
	 	Quit:'$IsObject(objFrontPage.FPVolumeDr) $$$OK
	 	Set VolumeID=objFrontPage.FPVolumeDr.%Id()
	 	Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(VolumeID)
 		Quit:EpisodeID="" $$$OK
 		
 		Set xFPESubID=0
 		For {
 			Set xFPESubID=$o(^DHCWMR.FP.FrontPageD(aFrontPageID,"E",xFPESubID))
 			Quit:xFPESubID=""
 			
 			Set FPEItemID=aFrontPageID_"||"_xFPESubID
 			Set objFPExtra=##class(DHCWMR.FP.FPExtraItem).GetObjById(FPEItemID)
 			Continue:'$IsObject(objFPExtra)
 			Continue:'$IsObject(objFPExtra.EIItem)
 			
	 		Set (EItemID,EItemDesc,EItemTpCode,EItemDicCode)=""
	 		Set (FPEItemValue,FPEItemText,FPEIIsNeed,FPEIResume)=""
	 		
 			Set objEItem=objFPExtra.EIItem
 			Continue:'$IsObject(objEItem)
		 	Set EItemID=objEItem.%Id()
		 	Set EItemDesc=objEItem.EIDesc
		 	Set EItemTpCode=objEItem.EIType
		 	Set EItemDicCode=objEItem.EIDicCode
			
			If EItemTpCode="D" {
				Set FPEItemValue=objFPExtra.EIValue
				Set FPEItemText=objFPExtra.EIText
			} Else {
				Set FPEItemValue=objFPExtra.EIValue
				Set FPEItemText=FPEItemValue
			}
 			Set WFESubID=$o(^DHCWMR.FP.WorkFExtraI("WFE","IndexItemDr",aFPItemID,EItemID,0))
		 	If WFESubID'="" {
			 	Set WFEItemID=aFPItemID_"||"_WFESubID
			 	Set objWFEItem=##class(DHCWMR.FP.WorkFExtra).GetObjById(WFEItemID)
			 	If $IsObject(objWFEItem){
			 		Set FPEIIsNeed=objWFEItem.EIIsNeed
				 	Set FPEIResume=objWFEItem.EIResume
			 	}
		 	}
		 	
	 		Set Data=$lb(EItemID,EItemDesc,EItemTpCode,EItemDicCode)
		 	Set Data=Data_$lb(FPEItemID,FPEItemValue,FPEItemText,FPEIIsNeed,FPEIResume)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
 		}
	} Else {
		Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(aVolumeID)
 		Quit:EpisodeID="" $$$OK
 		
 		Set xIndex=""
 		For {
	 		Set xIndex=$o(^DHCWMR.FP.WorkFExtraI("WFE","IndexItemNo",aFPItemID,xIndex))
	 		Quit:xIndex=""
	 		Set xWFESubID=0
	 		For {
		 		Set xWFESubID=$o(^DHCWMR.FP.WorkFExtraI("WFE","IndexItemNo",aFPItemID,xIndex,xWFESubID))
		 		Quit:xWFESubID=""
		 		
		 		Set objWFEItem=##class(DHCWMR.FP.WorkFExtra).GetObjById(aFPItemID_"||"_xWFESubID)
		 		Continue:'$IsObject(objWFEItem)
		 		Continue:objWFEItem.EIIsActive'=1
		 		
		 		Set (EItemID,EItemDesc,EItemTpCode,EItemDicCode)=""
		 		Set (FPEItemID,FPEItemValue,FPEItemText,FPEIIsNeed,FPEIResume)=""
		 		
			 	Set objEItem=objWFEItem.EIItem
			 	Continue:'$IsObject(objEItem)
			 	Set EItemID=objEItem.%Id()
			 	Set EItemDesc=objEItem.EIDesc
			 	Set EItemTpCode=objEItem.EIType
			 	Set EItemDicCode=objEItem.EIDicCode
			 	
			 	If $IsObject(objWFEItem.EIDataItem){
				 	Set WFEIDataCode=objWFEItem.EIDataItem.DICode
				 	If WFEIDataCode'="" {
					 	If EItemTpCode="D" {
					 		Set FPEItemValue=..GetEPRData(EpisodeID,WFEIDataCode,"C",.ArrGlossary)  //首页数据项值
					 		Set FPEItemText=..GetEPRData(EpisodeID,WFEIDataCode,"",.ArrGlossary)       //首页数据项值
						} Else {
							Set FPEItemValue=..GetEPRData(EpisodeID,WFEIDataCode,"",.ArrGlossary)      //首页数据项值
					 		Set FPEItemText=FPEItemValue
						}
					}
			 		Set:FPEItemValue="" FPEItemValue=objWFEItem.EIInitVal
				}
		 		Set FPEIIsNeed=objWFEItem.EIIsNeed
			 	Set FPEIResume=objWFEItem.EIResume
		 		
		 		Set Data=$lb(EItemID,EItemDesc,EItemTpCode,EItemDicCode)
			 	Set Data=Data_$lb(FPEItemID,FPEItemValue,FPEItemText,FPEIIsNeed,FPEIResume)
			 	Set ^CacheTemp(repid,ind)=Data
			 	Set ind=ind+1
		 	}
	 	}
	}
 		
	Quit $$$OK
}

ClassMethod QryWFEItemToFPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWFEItemToFPExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWFEItemToFPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWFEItemToFPExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-10-30
/// Description:  查询附加项列表
/// Table：       DHCWMR.FP.WorkFExtra、DHCWMR.FP.FPExtraItem
/// Input：       WFItemID ：编目操作项ID
/// Return：      ROWSPEC...
/// D ##class(%ResultSet).RunQuery("DHCWMR.FPService.FPExtraItemSrv","QryWFEItem","1","0")
Query QryWFEItem(aWFItemID As %String, aQryFlag As %String) As %Query(ROWSPEC = "EItemID:%String,EItemDesc:%String,EItemTpDesc:%String,EItemDicDesc:%String,WFEItemID:%String,WFEIIndex:%String,WFEIDataID:%String,WFEIDataCode:%String,WFEIDataDesc:%String,WFEIInitVal:%String,WFEIIsNeed:%String,WFEIIsActive:%String,WFEIResume:%String")
{
}

ClassMethod QryWFEItemExecute(ByRef qHandle As %Binary, aWFItemID As %String, aQryFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aWFItemID="" $$$OK
 	
 	If aQryFlag=1 {
	 	Set xEItemID=""
	 	For {
		 	Set xEItemID=$o(^DHCWMR.FP.ExtraItemD(xEItemID))
		 	Quit:xEItemID=""
	 		
		 	Set objEItem=##class(DHCWMR.FP.ExtraItem).GetObjById(xEItemID)
		 	Continue:'$IsObject(objEItem)
	 		
	 		Set (EItemID,EItemDesc,EItemTpDesc,EItemDicDesc)=""
		 	Set (WFEItemID,WFEIIndex,WFEIDataID,WFEIDataCode,WFEIDataDesc,WFEIInitVal,WFEIIsNeed,WFEIIsActive,WFEIResume)=""
		 	
		 	Set EItemID=objEItem.%Id()
		 	Set EItemDesc=objEItem.EIDesc
		 	Set EItemTpCode=objEItem.EIType
		 	If EItemTpCode'="" {
			 	Set objType=##class(DHCWMR.SS.Dictionary).GetByTypeCode("DATATYPE",EItemTpCode,0)
			 	If $IsObject(objType){
			 		Set EItemTpDesc = objType.SDDesc
			 	}
		 	}
		 	Set EItemDicCode=objEItem.EIDicCode
	 		If EItemDicCode'="" {
		 		Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeCode("SYS",EItemDicCode,0)
			 	If $IsObject(objDic){
				 	Set EItemDicCode = objDic.SDCode
				 	Set EItemDicDesc = objDic.SDDesc
			 	}
		 	}
		 	
		 	Set WFESubID=$o(^DHCWMR.FP.WorkFExtraI("WFE","IndexItemDr",aWFItemID,EItemID,0))
		 	If WFESubID'="" {
			 	Set WFEItemID=aWFItemID_"||"_WFESubID
			 	Set objWFEItem=##class(DHCWMR.FP.WorkFExtra).GetObjById(WFEItemID)
			 	If $IsObject(objWFEItem){
				 	Set WFEIIndex=objWFEItem.EIIndex
				 	If $IsObject(objWFEItem.EIDataItem){
					 	Set WFEIDataID=objWFEItem.EIDataItem.%Id()
					 	Set WFEIDataCode=objWFEItem.EIDataItem.DICode
					 	Set WFEIDataDesc=objWFEItem.EIDataItem.DIDesc
					}
				 	Set WFEIInitVal=objWFEItem.EIInitVal
				 	Set WFEIIsNeed=$s(objWFEItem.EIIsNeed=1:"是",1:"否")
				 	Set WFEIIsActive=$s(objWFEItem.EIIsActive=1:"是",1:"否")
				 	Set WFEIResume=objWFEItem.EIResume
				}
			}
	 		
	 		Set Data=$lb(EItemID,EItemDesc,EItemTpDesc,EItemDicDesc)
		 	Set Data=Data_$lb(WFEItemID,WFEIIndex,WFEIDataID,WFEIDataCode,WFEIDataDesc,WFEIInitVal,WFEIIsNeed,WFEIIsActive,WFEIResume)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
	 	}
	} Else {
		Set xWFESubID=""
	 	For {
		 	Set xWFESubID=$o(^DHCWMR.FP.WorkFItemD(aWFItemID,"E",xWFESubID))
		 	Quit:xWFESubID=""
		 	
		 	Set WFEItemID=aWFItemID_"||"_xWFESubID
		 	Set objWFEItem=##class(DHCWMR.FP.WorkFExtra).GetObjById(WFEItemID)
		 	Continue:'$IsObject(objWFEItem)
		 	
	 		Set (EItemID,EItemDesc,EItemTpDesc,EItemDicDesc)=""
		 	Set (WFEItemID,WFEIIndex,WFEIDataID,WFEIDataCode,WFEIDataDesc,WFEIInitVal,WFEIIsNeed,WFEIIsActive,WFEIResume)=""
		 	
		 	Set WFEItemID=objWFEItem.%Id()
		 	Set objEItem=objWFEItem.EIItem
		 	Continue:'$IsObject(objEItem)
		 	Set EItemID=objEItem.%Id()
		 	Set EItemDesc=objEItem.EIDesc
		 	Set EItemTpCode=objEItem.EIType
		 	If EItemTpCode'="" {
			 	Set objType=##class(DHCWMR.SS.Dictionary).GetByTypeCode("DATATYPE",EItemTpCode,0)
			 	Continue:'$IsObject(objType)
			 	Set EItemTpDesc = objType.SDDesc
		 	}
		 	Set EItemDicCode=objEItem.EIDicCode
	 		If EItemDicCode'="" {
		 		Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeCode("SYS",EItemDicCode,0)
			 	Continue:'$IsObject(objDic)
			 	Set EItemDicCode = objDic.SDCode
			 	Set EItemDicDesc = objDic.SDDesc
		 	}
		 	
		 	Set WFEIIndex=objWFEItem.EIIndex
		 	If $IsObject(objWFEItem.EIDataItem){
			 	Set WFEIDataID=objWFEItem.EIDataItem.%Id()
			 	Set WFEIDataCode=objWFEItem.EIDataItem.DICode
			 	Set WFEIDataDesc=objWFEItem.EIDataItem.DIDesc
			}
		 	Set WFEIInitVal=objWFEItem.EIInitVal
		 	Set WFEIIsNeed=$s(objWFEItem.EIIsNeed=1:"是",1:"否")
		 	Set WFEIIsActive=$s(objWFEItem.EIIsActive=1:"是",1:"否")
		 	Set WFEIResume=objWFEItem.EIResume
		 	
	 		Set Data=$lb(EItemID,EItemDesc,EItemTpDesc,EItemDicDesc)
		 	Set Data=Data_$lb(WFEItemID,WFEIIndex,WFEIDataID,WFEIDataCode,WFEIDataDesc,WFEIInitVal,WFEIIsNeed,WFEIIsActive,WFEIResume)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}
 	
	Quit $$$OK
}

ClassMethod QryWFEItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWFEItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWFEItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWFEItemExecute ]
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

ClassMethod GetEPRData(aEpisodeID As %String, aElCode As %String, aVType As %String = "", ByRef ArrGlossary As %ArrayOfDataTypes) As %String
{
	New (aEpisodeID,aElCode,aVType,ArrGlossary)
	Set return=##Class(DHCWMR.FPService.DataItemSrv).GetEPRData(aEpisodeID,aElCode,aVType,.ArrGlossary)
	Quit return
}

}
