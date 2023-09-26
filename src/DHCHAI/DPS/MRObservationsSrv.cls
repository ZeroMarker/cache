/// 名称: DHCHAI.DPS.MRObservationsSrv
/// 描述: 护理记录相关服务
/// 编写者：liyi
/// 编写日期: 2017-10-10
Class DHCHAI.DPS.MRObservationsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-08-09
/// Description:  病人体温查询-体温单(按2、6、10、14、18、22六个时间点)、固定输出
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.MRObservationsSrv","QryObservations",64858,"2016-10-01","2016-10-05")
Query QryObservations(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ID:%String,ItemCode:%String,ItemDesc:%String,ItemValue:%String,EntryDate:%String,EntryTime:%String,EntryUserID:%String,EntryUserCode:%String,EntryUserDesc:%String,SCode:%String,XCode:%String,TimeInd:%String") [ SqlProc ]
{
}

ClassMethod QryObservationsExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aDateFrom = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aEpisodeID="")||(aDateFrom="")||(aDateTo="") $$$OK
 	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
 	Quit:'$isobject(objPaadm) $$$OK
 	
 	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryObservations")
	
	// 2、6、10、14、18、22
	Set TimeArray(2)=$zth("02:00:00")
 	Set TimeArray(6)=$zth("06:00:00")
 	Set TimeArray(10)=$zth("10:00:00")
 	Set TimeArray(14)=$zth("14:00:00")
 	Set TimeArray(18)=$zth("18:00:00")
 	Set TimeArray(22)=$zth("22:00:00")
	For xDate = aDateFrom:1:aDateTo{
		Set xTimeInd = ""
		For {
			Set xTimeInd = $o(TimeArray(xTimeInd))
			Quit:xTimeInd=""
			Set ^TMP(ZIndex,JIndex,"QryObservations",xDate,xTimeInd)=""
		}
	}
 	Set xSCode = ""
 	For {
		Set xSCode = $o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode))
		Quit:xSCode=""
		
		Set xItemDesc = ""
		For {
			Set xItemDesc = $o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode,xItemDesc))
			Quit:xItemDesc=""
			
			Set xEntryDate = ""
			For {
				Set xEntryDate = $o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode,xItemDesc,xEntryDate))
				Quit:xEntryDate=""
				
				Continue:(aDateFrom'="")&&(xEntryDate<aDateFrom)
				Continue:(aDateTo'="")&&(xEntryDate>aDateTo)
				
				Set xID = ""
				For {
					Set xID = $o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode,xItemDesc,xEntryDate,xID),-1)  //倒序查找体温，一个时刻多个体温，取最后一个
					Quit:xID=""
					
					Set objObservation = ##class(DHCHAI.DP.MRObservations).GetObjById(xID)
					Continue:'$isobject(objObservation)
					
					Set IsActive  = objObservation.OBIsActive
					Set ItemDesc  = objObservation.OBItemDesc
					Set EntryDate = objObservation.OBEntryDate
					Set EntryTime = objObservation.OBEntryTime
					Set SCode  	  = objObservation.OBSCode
					Set XCode  	  = objObservation.OBXCode
					Continue:IsActive=0		//无效
					Continue:(EntryDate="")||(EntryTime="")
					
					Set objItemMap = ##class(DHCHAI.DP.MROBSItemMap).GetObjByItemDesc(SCode,ItemDesc)
					
					Continue:'$isobject(objItemMap)
					Continue:'$isobject(objItemMap.BTMapItemDr)
					Continue:'$isobject(objItemMap.BTMapItemDr.BTCatDr)
					Set OBSItemCatBTDesc=objItemMap.BTMapItemDr.BTCatDr.BTDesc
					Continue:(OBSItemCatBTDesc'="体温")
					
					// 确定记录在哪个时间点
					// 2点到22点之间的数据,记录时间超过时间点认为是前一个时间点记录
					// 2点之前、22点之后数据记为2点、22点数据
					Set FisrtTimeInd = $o(TimeArray(""))
					Set LastTimeInd = $o(TimeArray(""),-1)
					Set xTimeInd = "",TimeInd=""
					For {
						Set xTimeInd = $o(TimeArray(xTimeInd))
						Quit:xTimeInd=""
						
						Set xTime = $g(TimeArray(xTimeInd))
						If xTimeInd=FisrtTimeInd{
							If EntryTime<=xTime{	// 2点之前数据记为2点
								Set TimeInd = xTimeInd
								Quit
							}
						}
						If xTimeInd=LastTimeInd{
							If EntryTime>=xTime{	// 22点之后数据记为22点
								Set TimeInd = xTimeInd
								Quit
							}
						}
						If EntryTime>=xTime{
							Set TimeInd = xTimeInd
						}
					}
					Continue:TimeInd=""
					Set tmpID = $g(^TMP(ZIndex,JIndex,"QryObservations",xEntryDate,TimeInd))
					Set ^TMP(ZIndex,JIndex,"QryObservations",xEntryDate,TimeInd)=xID_"^"_tmpID
				}
			}
		}
	}
	// 组织数据输出
	Set xDate = ""
	For {
		Set xDate = $o(^TMP(ZIndex,JIndex,"QryObservations",xDate))
		Quit:xDate=""
		
		Set xTimeInd=""
		For {
			Set xTimeInd = $o(^TMP(ZIndex,JIndex,"QryObservations",xDate,xTimeInd))
			Quit:xTimeInd=""
			
			Set EntryDate = xDate
			Set (ID,ItemCode,ItemDesc,ItemValue,EntryTime,
			EntryUserID,EntryUserCode,EntryUserDesc,SCode,XCode)=""
			Set IDs = $g(^TMP(ZIndex,JIndex,"QryObservations",xDate,xTimeInd))
			
			// 只采用最大的一个记录值
			Set objObservation = ""
			For xIDind = 1:1:$l(IDs,"^"){
				Set xID = $p(IDs,"^",xIDind)
				Continue:xID=""
				Set tmpObjObservation = ##class(DHCHAI.DP.MRObservations).GetObjById(xID)
				Continue:'$IsObject(tmpObjObservation)
				Continue:tmpObjObservation.OBIsActive'=1
				
				Set Value = tmpObjObservation.OBItemValue
				if Value>+ItemValue{
					Set objObservation = tmpObjObservation
				}
			}
			If $IsObject(objObservation){
				Set ItemCode  = objObservation.OBItemCode
				Set ItemDesc  = objObservation.OBItemDesc
				Set ItemValue = objObservation.OBItemValue
				Set EntryTime = objObservation.OBEntryTime
				Set EntryUser = objObservation.OBEntryUser
				Set EntryUserID = $p(EntryUser,"|",1)
				Set EntryUserCode = $p(EntryUser,"|",2)
				Set EntryUserDesc = $p(EntryUser,"|",3)
				Set SCode  	  = objObservation.OBSCode
				Set XCode  	  = objObservation.OBXCode
				Set EntryTime = $zt(EntryTime)
			}
			Set EntryDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EntryDate)
			Set Data=$lb(ID,ItemCode,ItemDesc,ItemValue,EntryDate,EntryTime,EntryUserID,EntryUserCode,EntryUserDesc,SCode,XCode,xTimeInd)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}		
	Kill ^TMP(ZIndex,JIndex,"QryObservations")
	Quit $$$OK
}

ClassMethod QryObservationsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryObservationsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryObservationsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryObservationsExecute ]
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

}
