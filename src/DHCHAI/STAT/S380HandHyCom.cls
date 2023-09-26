/// 名称: DHCHAI.STAT.S380HandHyCom
/// 描述: 医务人员手卫生依从率统计表统计表
/// 编写者：zhoubo
/// 编写日期: 2018-10-23
Class DHCHAI.STAT.S380HandHyCom Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2018-10-23
/// Description:  医务人员手卫生依从率
/// Table：       DHCHAI.IR.HandHyReg
/// Input：       aLocID    : 检查病区
///               aDateFrom ：开始日期
///               aDateTo   ：结束日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S380HandHyCom","QryHandHyRegSta","14","2018-10-01","2018-10-23")
Query QryHandHyRegSta(aLocID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "WardID:%String,WardDesc:%String,LinkLocID:%String,LinkLocDesc:%String,GroupDr:%String,GroupDesc:%String,TypeID:%String,TypeDesc:%String,OpportList:%String,FacID:%String,FacDesc:%String,IsGloving:%String,IsCorrect:%String,ObsPatCount:%Integer") [ SqlProc ]
{
}

ClassMethod QryHandHyRegStaExecute(ByRef qHandle As %Binary, aLocID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set NIndex="QryHandHyRegSta"
	Kill ^TMP($zn,$j,NIndex)
	
 	For xDate=aDateFrom:1:aDateTo {	
 		Set xPage=""
 		For {
			Set xPage=$o(^DHCHAI.IR.HandHyRegI("IndexDatePage",xDate,xPage))
			Quit:xPage=""
			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.HandHyRegI("IndexDatePage",xDate,xPage,xID))
				Quit:xID=""
				Set RegID=xID
				Set objReg=##class(DHCHAI.IR.HandHyReg).GetObjById(RegID)
				Continue:'$IsObject(objReg)
				
				If $IsObject(objReg.HHLocDr) {
					Set WardID    = objReg.HHLocDr.%Id()
					Set WardDesc  = objReg.HHLocDr.BTDesc
					Set WardDesc2 = objReg.HHLocDr.BTDesc2
					Set:WardDesc2'="" WardDesc=WardDesc2
					Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
			    }Else {
					Set (WardID,WardDesc)=""   
				}
				Continue:(aLocID'="")&&(aLocID'=WardID)
				Set IsActive=objReg.HHIsActive
				Continue:IsActive'=1
				// 根据病区找关联科室
			 	Set xWLID = $o(^DHCHAI.BT.LocationD(WardID,"Link",""))
				Continue:xWLID=""  // 无关联科室过滤
				
				Set xLinkID = WardID_"||"_xWLID
				Set objLocLink = ##class(DHCHAI.BT.LocationLink).GetObjById(xLinkID)
				Continue:'$IsObject(objLocLink)
				Continue:'$IsObject(objLocLink.BTLinkLocDr)
				Continue:(+objLocLink.BTIsActive)'=1
				
				Set LinkLocID = objLocLink.BTLinkLocDr.%Id()
				Set LinkLocDesc = objLocLink.BTLinkLocDr.BTDesc2
				Set:LinkLocDesc="" LinkLocDesc = objLocLink.BTLinkLocDr.BTDesc
			    Set:$p(LinkLocDesc,"-",2)'="" LinkLocDesc=$p(LinkLocDesc,"-",2)
				
				Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LinkLocID)
				Continue:'$IsObject(objLoc)
				Set GroupDr="",GroupCode="",GroupDesc=""
				If $IsObject(objLoc.BTGroupDr) {
					Set GroupDr 	= objLoc.BTGroupDr.%Id()
					Set GroupCode	= objLoc.BTGroupDr.BTCode
					Set GroupDesc	= objLoc.BTGroupDr.BTDesc	
				}Else {
					Set GroupDesc="其他科"
					Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
					If $IsObject(objGroup) {
						Set GroupDr 	= objGroup.%Id()
						Set GroupCode	= objGroup.BTCode
						Set GroupDesc	= objGroup.BTDesc
					}
				}
				
				Set xType=""
				For {
					Set xType=$o(^DHCHAI.IR.HandHyRegI("Cnt","IndexType",RegID,xType))
					Quit:xType=""
					// 计算调查人数
					Set ObsPatCount=0
					Set xSubID=""
					For {
						Set xSubID=$o(^DHCHAI.IR.HandHyRegI("Cnt","IndexType",RegID,xType,xSubID))
						Quit:xSubID=""
						Set ChildCntID=RegID_"||"_xSubID
						Set objRegCnt=##class(DHCHAI.IR.HandHyRegCnt).GetObjById(ChildCntID)
						Continue:'$IsObject(objRegCnt)
						Set tmpPatCount = objRegCnt.HHObsCount
						Set ObsPatCount = ObsPatCount+tmpPatCount
					}
					Set num=+$g(^TMP($zn,$j,NIndex,WardID,xType,"ObsPatCount"))
					Set ^TMP($zn,$j,NIndex,WardID,xType,"ObsPatCount")=num+ObsPatCount
				}
 			}
 		}
 	}
 	For xDate=aDateFrom:1:aDateTo {	
 		Set xPage=""
 		For {
			Set xPage=$o(^DHCHAI.IR.HandHyRegI("IndexDatePage",xDate,xPage))
			Quit:xPage=""
			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.HandHyRegI("IndexDatePage",xDate,xPage,xID))
				Quit:xID=""
				Set RegID=xID
				Set objReg=##class(DHCHAI.IR.HandHyReg).GetObjById(RegID)
				Continue:'$IsObject(objReg)
				
				If $IsObject(objReg.HHLocDr) {
					Set WardID    = objReg.HHLocDr.%Id()
					Set WardDesc  = objReg.HHLocDr.BTDesc
					Set WardDesc2 = objReg.HHLocDr.BTDesc2
					Set:WardDesc2'="" WardDesc=WardDesc2
					Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
			    }Else {
					Set (WardID,WardDesc)=""   
				}
				Continue:(aLocID'="")&&(aLocID'=WardID)
				Set IsActive=objReg.HHIsActive
				Continue:IsActive'=1
				// 根据病区找关联科室
			 	Set xWLID = $o(^DHCHAI.BT.LocationD(WardID,"Link",""))
				Continue:xWLID=""  // 无关联科室过滤
				
				Set xLinkID = WardID_"||"_xWLID
				Set objLocLink = ##class(DHCHAI.BT.LocationLink).GetObjById(xLinkID)
				Continue:'$IsObject(objLocLink)
				Continue:'$IsObject(objLocLink.BTLinkLocDr)
				Continue:(+objLocLink.BTIsActive)'=1
				
				Set LinkLocID = objLocLink.BTLinkLocDr.%Id()
				Set LinkLocDesc = objLocLink.BTLinkLocDr.BTDesc2
				Set:LinkLocDesc="" LinkLocDesc = objLocLink.BTLinkLocDr.BTDesc
			    Set:$p(LinkLocDesc,"-",2)'="" LinkLocDesc=$p(LinkLocDesc,"-",2)
				
				Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LinkLocID)
				Continue:'$IsObject(objLoc)
				Set GroupDr="",GroupCode="",GroupDesc=""
				If $IsObject(objLoc.BTGroupDr) {
					Set GroupDr 	= objLoc.BTGroupDr.%Id()
					Set GroupCode	= objLoc.BTGroupDr.BTCode
					Set GroupDesc	= objLoc.BTGroupDr.BTDesc	
				}Else {
					Set GroupDesc="其他科"
					Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
					If $IsObject(objGroup) {
						Set GroupDr 	= objGroup.%Id()
						Set GroupCode	= objGroup.BTCode
						Set GroupDesc	= objGroup.BTDesc
					}
				}
				
				Set xType=""
				For {
					Set xType=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType))
					Quit:xType=""
					
					Set xTim=""
					For {
						Set xTim=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim))
						Quit:xTim=""
						
						Set xSubID=""
						For {
							Set xSubID=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim,xSubID))
							Quit:xSubID=""
							Set ChildTimID=RegID_"||"_xSubID
							Set objRegTim=##class(DHCHAI.IR.HandHyRegTim).GetObjById(ChildTimID)
							Continue:'$IsObject(objRegTim)
							
							If $IsObject(objRegTim.HHObsTypeDr) {
								Set TypeID   = objRegTim.HHObsTypeDr.%Id()  
								Set TypeCode = objRegTim.HHObsTypeDr.BTCode
								Set TypeDesc = objRegTim.HHObsTypeDr.BTDesc
						    }Else {
								Set (TypeID,TypeCode,TypeDesc)=""   
							}
							Set OpportListDesc=""
							Set OpportList = objRegTim.HHOpportList
							If (OpportList'=""){
								For i=1:1:$l(OpportList,",") {
									Set OpportID=$p(OpportList,",",i)
									Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(OpportID)
									Set BTDesc = objDic.BTDesc
									Set:BTDesc'="" OpportListDesc=OpportListDesc_","_BTDesc
								}
							}
							Set OpportList=OpportListDesc
							If $IsObject(objRegTim.HHFacilitDr) {
								Set FacID    = objRegTim.HHFacilitDr.%Id()
								Set FacDesc  = objRegTim.HHFacilitDr.BTDesc
						    }Else {
								Set (FacID,FacDesc)=""   
							}
							Set IsGloving = objRegTim.HHIsGloving
							Set IsCorrect = objRegTim.HHIsCorrect
							Set ObsPatCount=+$g(^TMP($zn,$j,NIndex,WardID,TypeID,"ObsPatCount"))
							
							Set Data=$lb(WardID,WardDesc,LinkLocID,LinkLocDesc,GroupDr,GroupDesc,TypeID,TypeDesc,OpportList,FacID,FacDesc,IsGloving,IsCorrect,ObsPatCount)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
		
						}
					}
				}
 			}
 		}
 	}
 	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryHandHyRegStaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHandHyRegStaExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHandHyRegStaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHandHyRegStaExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
