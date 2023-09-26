/// 名称: DHCHAI.STAS.HandHySrv
/// 描述: 手卫生统计图相关服务
/// 编写者：蒋朋朋
/// 编写日期: 2018-05-22
Class DHCHAI.STAS.HandHySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-01
/// Description:  计算手卫生数据
/// Input:        
/// w ##class(DHCHAI.STAS.HandHySrv).SyncData("2021-06","2021-06")
ClassMethod SyncData(aFromDate As %String, aToDate As %String) As %String
{
	New (aFromDate,aToDate)
	Set return=""
	Quit:(aFromDate="")||(aToDate="") return
	Set aFromDate=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aFromDate,1)
	Set aFromDate=$p(aFromDate,"^",1)
	Set aToDate=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aToDate,1)
	Set aToDate=$p(aToDate,"^",2)
	Quit:(aFromDate>aToDate) return
	Quit:(aFromDate="")||(aToDate="") return
	//先删除日期内的数据
	Set xHospID=""
	For {
		Set xHospID=$o(^DHCHAI.STA.HandHyI("IdxofLoc",xHospID))
		Quit:xHospID=""
		
		Set xLocID=""
		For {
			Set xLocID=$o(^DHCHAI.STA.HandHyI("IdxofLoc",xHospID,xLocID))
			Quit:xLocID=""
			
			For xECTime=aFromDate:1:aToDate {
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.STA.HandHyI("IdxofLoc",xHospID,xLocID,xECTime,xID))
					Quit:xID=""
					
					Do ##class(DHCHAI.STA.HandHy).DeleteById(xID)
				}
			}
		}
	}

	//生成数据
	Set NIndex="SyncData"
    Kill ^TMP($zn,$j,NIndex)
    s key=0
	For xDate=aFromDate:1:aToDate {
		Set xfirstDay=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay($zd(xDate,3),1)
		Continue:xfirstDay=""
		Set xfirstDay=$p(xfirstDay,"^",1)
		
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
				Continue:'$IsObject(objReg.HHLocDr)
				Set IsActive=objReg.HHIsActive
				Continue:IsActive'=1
				
				Set LocID=objReg.HHLocDr.%Id()
				Continue:'$IsObject(objReg.HHLocDr.BTHospDr)
				Set HospID=objReg.HHLocDr.BTHospDr.%Id()
				
				Set xType=""
				For {
					Set xType=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType))
					Quit:xType=""
						
					Set xTim=""
					For {
						Set xTim=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim))
						Quit:xTim=""
						
						Set xSign=""
						For {
							Set xSign=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim,xSign))
							Quit:xSign=""
						
							Set CountID=$o(^DHCHAI.IR.HandHyRegI("Cnt","IndexType",RegID,xType,xSign,""))
							Continue:CountID=""
							Set objCnt=##class(DHCHAI.IR.HandHyRegCnt).GetObjById(RegID_"||"_CountID)
							Continue:'$IsObject(objCnt)
							Set ObsCount=objCnt.HHObsCount
							If '$d(^TMP($zn,$j,NIndex,xfirstDay,HospID,LocID,xType,"tmp","tmp",RegID,xSign)) {  //不重复累加
								Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,LocID,xType,"tmp","tmp","ObsCount")=$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,LocID,xType,"tmp","tmp","ObsCount"))+ObsCount //调查人数
							}
						    Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,LocID,xType,"tmp","tmp",RegID,xSign)=""
						    
							Set xSubID=""
							For {
								Set xSubID=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim,xSign,xSubID))
								Quit:xSubID=""
								Set ChildTimID=RegID_"||"_xSubID
								Set objRegTim=##class(DHCHAI.IR.HandHyRegTim).GetObjById(ChildTimID)
								Continue:'$IsObject(objRegTim)
								
								Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,LocID,xType,"tmp","tmp","Value1"))	//调查时机数
								
								Set HHObsTime=objRegTim.HHObsTime
								Set IsCorrect=objRegTim.HHIsCorrect
								Set ObsTypeID=objRegTim.HHObsTypeDr.%Id()		//职业
								Set ObsTypeDesc=objRegTim.HHObsTypeDr.BTDesc
								Set FacilitID=objRegTim.HHFacilitDr.%Id()		//行为
								Set FacilitDesc=objRegTim.HHFacilitDr.BTDesc
								Set OpportList=objRegTim.HHOpportList			//指征
								Set OpportDescList=""
								
								If (OpportList'=""){
									For i=1:1:$l(OpportList,",") {
										Set OpportID=$p(OpportList,",",i)
										Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(OpportID)
										Set BTDesc = objDic.BTDesc
										Set OpportDescList=OpportDescList_","_BTDesc
										
										If ((FacilitDesc["手消")||(FacilitDesc["洗手")) {
										
											Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,LocID,ObsTypeID,xDate_"-"_xPage_"-"_HHObsTime_"-"_xSign,OpportID,"Value2"))	//依从数
											If (IsCorrect="1") {
												Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,LocID,ObsTypeID,xDate_"-"_xPage_"-"_HHObsTime_"-"_xSign,OpportID,"Value3"))	//正确数
											}
										} Else {
											//选择“无”(记录一个不依从，方便下面循环取数)
											Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,LocID,ObsTypeID,xDate_"-"_xPage_"-"_HHObsTime_"-"_xSign,OpportID,"Value4"))	//不依从数
										}
									}
								}
							}
						}
					}
				}
			}
 		}
	}
	
	Set xfirstDay=""
	For {
		Set xfirstDay=$o(^TMP($zn,$j,NIndex,xfirstDay))
		Quit:xfirstDay=""
		
		Set xHospID=""
		For {
			Set xHospID=$o(^TMP($zn,$j,NIndex,xfirstDay,xHospID))
			Quit:xHospID=""
			
			Set xLocID=""
			For {
				Set xLocID=$o(^TMP($zn,$j,NIndex,xfirstDay,xHospID,xLocID))
				Quit:xLocID=""
				
				Set xObsTpye=""
				For {
					Set xObsTpye=$o(^TMP($zn,$j,NIndex,xfirstDay,xHospID,xLocID,xObsTpye))
					Quit:xObsTpye=""
					
					Set Value1=$g(^TMP($zn,$j,NIndex,xfirstDay,xHospID,xLocID,xObsTpye,"tmp","tmp","Value1"))	//调查时机数
					Set ObsCount=$g(^TMP($zn,$j,NIndex,xfirstDay,xHospID,xLocID,xObsTpye,"tmp","tmp","ObsCount"))	//调查人数
								
					Set xObsTime=""
					For {
						Set xObsTime=$o(^TMP($zn,$j,NIndex,xfirstDay,xHospID,xLocID,xObsTpye,xObsTime))
						Quit:xObsTime=""
						Continue:xObsTime="tmp"
						
						Set xOpport=""
						For {
							Set xOpport=$o(^TMP($zn,$j,NIndex,xfirstDay,xHospID,xLocID,xObsTpye,xObsTime,xOpport))
							Quit:xOpport=""
							Continue:xOpport="tmp"
						
							Set Value2=$g(^TMP($zn,$j,NIndex,xfirstDay,xHospID,xLocID,xObsTpye,xObsTime,xOpport,"Value2"))	//依从数
							Set Value3=$g(^TMP($zn,$j,NIndex,xfirstDay,xHospID,xLocID,xObsTpye,xObsTime,xOpport,"Value3"))	//正确数
						  
							Set Inputs=""	//ID
							Set Inputs=Inputs_"^"_xHospID
							Set Inputs=Inputs_"^"_xLocID
							Set Inputs=Inputs_"^"_Value1
							Set Inputs=Inputs_"^"_Value2
							Set Inputs=Inputs_"^"_Value3
							Set Inputs=Inputs_"^"_xObsTpye
							Set Inputs=Inputs_"^"_xOpport
							Set Inputs=Inputs_"^"_ObsCount
							Set Inputs=Inputs_"^"_xfirstDay		//每月第一天
							Set Inputs=Inputs_"^"_xObsTime		
							Set flg=##class(DHCHAI.STA.HandHy).Update(Inputs,"^")
							//w Inputs_">"_flg,!
						}
					}
					
				}
			}
		}
	}
	Quit "OK"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-01
/// Description:  手卫生统计图(按月份)
/// Table：       DHCHAI.STA.HandHy
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.STAS.HandHySrv","QryHDForCharts","","2018-11","2018-11","676")
Query QryHDForCharts(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aType As %String = "", aOpport As %String = "") As %Query(ROWSPEC = "ind:%String,HospID:%String,LocID:%String,ECTime:%String,Value1:%String,Value2:%String,Value3:%String,Radio1:%String,Radio2:%String,ECPatCount:%String") [ SqlProc ]
{
}

ClassMethod QryHDForChartsExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aType As %String = "", aOpport As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set NIndex="QryHDForCharts"
    Kill ^TMP($zn,$j,NIndex)
	
	Set HospID=""
	For {
		Set HospID=$o(^DHCHAI.STA.HandHyI("IdxofObsOpp",HospID))
		Quit:HospID=""
		Continue:(aHospIDs'="")&&(("|"_aHospIDs_"|")'[("|"_HospID_"|"))
	
		Set xLocID=""
		For {
			Set xLocID=$o(^DHCHAI.STA.HandHyI("IdxofObsOpp",HospID,xLocID))
			Quit:xLocID=""
			Continue:(aLocID'="")&&(aLocID'=xLocID)
			
			Set xType=""
			For xDate=$zdh(aDateFrom_"-01",3):1:$zdh(aDateTo_"-01",3) {
				Set ECTime=$zd(xDate,3)
				If ($e(ECTime,8,10)="-01") {
					Set ^TMP($zn,$j,NIndex,xDate,xLocID,"Value1")=0
					Set ^TMP($zn,$j,NIndex,xDate,xLocID,"Value2")=0
					Set ^TMP($zn,$j,NIndex,xDate,xLocID,"Value3")=0
					Set ^TMP($zn,$j,NIndex,xDate,xLocID,"PatCount")=0
				}
				Set xType=""
				For {
					Set xType=$o(^DHCHAI.STA.HandHyI("IdxofObsOpp",HospID,xLocID,xDate,xType))
					Quit:xType=""
					Continue:(aType'="")&&(aType'=xType)
					
					Set xObsTime=""
					For {
						Set xObsTime=$o(^DHCHAI.STA.HandHyI("IdxofObsOpp",HospID,xLocID,xDate,xType,xObsTime))
						Quit:xObsTime=""
						
						Set xOpport=""
						For {
							Set xOpport=$o(^DHCHAI.STA.HandHyI("IdxofObsOpp",HospID,xLocID,xDate,xType,xObsTime,xOpport))
							Quit:xOpport=""
							Continue:(aOpport'="")&&(aOpport'=xOpport)
							
							Set xID=$o(^DHCHAI.STA.HandHyI("IdxofObsOpp",HospID,xLocID,xDate,xType,xObsTime,xOpport,""))
							Continue:xID=""
							
							Set obj=##class(DHCHAI.STA.HandHy).GetObjById(xID)
							Continue:'$IsObject(obj)
							//w xType_","_xObsTime_","_obj.ECValue1_","_obj.ECValue2_","_obj.ECValue3,!
							//Set PageID=$p(xObsTime,"-",1)
							If ('$d(^TMP($zn,$j,NIndex,xDate,xLocID,xType))) {
								Set ^TMP($zn,$j,NIndex,xDate,xLocID,"Value1")=$g(^TMP($zn,$j,NIndex,xDate,xLocID,"Value1"))+obj.ECValue1
								Set ^TMP($zn,$j,NIndex,xDate,xLocID,"PatCount")=$g(^TMP($zn,$j,NIndex,xDate,xLocID,"PatCount"))+obj.ECPatCount
								Set ^TMP($zn,$j,NIndex,xDate,xLocID,xType)=""
							}
							If ('$d(^TMP($zn,$j,NIndex,xDate,xLocID,xType,xObsTime))) {
								Set ^TMP($zn,$j,NIndex,xDate,xLocID,"Value2")=$g(^TMP($zn,$j,NIndex,xDate,xLocID,"Value2"))+obj.ECValue2
								Set ^TMP($zn,$j,NIndex,xDate,xLocID,"Value3")=$g(^TMP($zn,$j,NIndex,xDate,xLocID,"Value3"))+obj.ECValue3
								
								Set ^TMP($zn,$j,NIndex,xDate,xLocID,xType,xObsTime)=""
							}
						}
					}
				}
			}
		}
	}
	
	Set xxDate=""
	For {
		Set xxDate=$o(^TMP($zn,$j,NIndex,xxDate))
		Quit:xxDate=""
		
		Set (Value1,Value2,Value3,PatCount,Radio1,Radio2)=0
		Set ECTime=$zd(xxDate,3)
		Set xxLocID=""
		For {
			Set xxLocID=$o(^TMP($zn,$j,NIndex,xxDate,xxLocID))
			Quit:xxLocID=""
			
			Set Value1=Value1+$g(^TMP($zn,$j,NIndex,xxDate,xxLocID,"Value1"))
			Set Value2=Value2+$g(^TMP($zn,$j,NIndex,xxDate,xxLocID,"Value2"))
			Set Value3=Value3+$g(^TMP($zn,$j,NIndex,xxDate,xxLocID,"Value3"))
			Set PatCount=PatCount+$g(^TMP($zn,$j,NIndex,xxDate,xxLocID,"PatCount"))
		}
		Set:Value1'=0 Radio1=$fn((Value2/Value1)*100,"",2)	//依从率
		Set:Value2'=0 Radio2=$fn((Value3/Value2)*100,"",2)	//正确率
		Set Data=$lb(ind,HospID,xLocID,$e(ECTime,1,7),Value1,Value2,Value3,Radio1,Radio2,PatCount)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryHDForChartsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHDForChartsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHDForChartsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHDForChartsExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-01
/// Description:  手卫生统计图(按科室)
/// Table：       DHCHAI.STA.HandHy
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.STAS.HandHySrv","QryHDForChartsH","","2018-11","2018-11")
Query QryHDForChartsH(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aType As %String = "", aOpport As %String = "") As %Query(ROWSPEC = "ind:%String,HospID:%String,CatDesc:%String,Value1:%String,Value2:%String,Value3:%String,Radio1:%String,Radio2:%String,ECPatCount:%String") [ SqlProc ]
{
}

ClassMethod QryHDForChartsHExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aType As %String = "", aOpport As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set NIndex="QryHDForChartsH"
    Kill ^TMP($zn,$j,NIndex)
    
	Set HospID=""
	For {
		Set HospID=$o(^DHCHAI.STA.HandHyI("IdxofObsOpp",HospID))
		Quit:HospID=""
		Continue:(aHospIDs'="")&&(("|"_aHospIDs_"|")'[("|"_HospID_"|"))
		
		Set xLocID=""
		For {
			Set xLocID=$o(^DHCHAI.STA.HandHyI("IdxofObsOpp",HospID,xLocID))
			Quit:xLocID=""
			
			Set (Value1,Value2,Value3,Radio1,Radio2,ECPatCount)=0
			For xDate=$zdh(aDateFrom_"-01",3):1:$zdh(aDateTo_"-01",3) {
				Set xType=""
				For {
					Set xType=$o(^DHCHAI.STA.HandHyI("IdxofObsOpp",HospID,xLocID,xDate,xType))
					Quit:xType=""
					Continue:(aType'="")&&(aType'=xType)
					
					Set xObsTime=""
					For {
						Set xObsTime=$o(^DHCHAI.STA.HandHyI("IdxofObsOpp",HospID,xLocID,xDate,xType,xObsTime))
						Quit:xObsTime=""
						
						Set xOpport=""
						For {
							Set xOpport=$o(^DHCHAI.STA.HandHyI("IdxofObsOpp",HospID,xLocID,xDate,xType,xObsTime,xOpport))
							Quit:xOpport=""
							Continue:(aOpport'="")&&(aOpport'=xOpport)
							
							Set xID=$o(^DHCHAI.STA.HandHyI("IdxofObsOpp",HospID,xLocID,xDate,xType,xObsTime,xOpport,""))
							Continue:xID=""
							
							Set obj=##class(DHCHAI.STA.HandHy).GetObjById(xID)
							Continue:'$IsObject(obj)
							//Set PageID=$p(xObsTime,"-",1)
							If ('$d(^TMP($zn,$j,NIndex,xLocID,xDate,xType))) {
								Set Value1=Value1+obj.ECValue1 //时机数
								Set ECPatCount=ECPatCount+obj.ECPatCount //调查人数
								Set ^TMP($zn,$j,NIndex,xLocID,xDate,xType)=""
							}
							If ('$d(^TMP($zn,$j,NIndex,xLocID,xType,xObsTime))) {
								Set Value2=Value2+obj.ECValue2 //依从数
								Set Value3=Value3+obj.ECValue3 //正确数
								Set ^TMP($zn,$j,NIndex,xLocID,xType,xObsTime)=""
							}
						}
					}
				}
			}
			
			Continue:Value1=0
			
			Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
			Set LocDesc=objLoc.BTDesc
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
			Set:Value1'=0 Radio1=$fn((Value2/Value1)*100,"",2)	//依从率
			Set:Value2'=0 Radio2=$fn((Value3/Value2)*100,"",2)	//正确率
			Set Data=$lb(ind,HospID,LocDesc,Value1,Value2,Value3,Radio1,Radio2,ECPatCount)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}

	Quit $$$OK
}

ClassMethod QryHDForChartsHClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHDForChartsHExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHDForChartsHFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHDForChartsHExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-01
/// Description:  手卫生统计图(按职业)
/// Table：       DHCHAI.STA.HandHy
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.STAS.HandHySrv","QryHDForChartsT","","2018-09","2018-09","6")
Query QryHDForChartsT(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aOpport As %String = "") As %Query(ROWSPEC = "ind:%String,HospID:%String,CatDesc:%String,Value1:%String,Value2:%String,Value3:%String,Radio1:%String,Radio2:%String,ECPatCount:%String") [ SqlProc ]
{
}

ClassMethod QryHDForChartsTExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aOpport As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set NIndex="QryHDForChartsT"
    Kill ^TMP($zn,$j,NIndex)
    
	Set HospID=""
	For {
		Set HospID=$o(^DHCHAI.STA.HandHyI("IdxofLoc",HospID))
		Quit:HospID=""
		Continue:(aHospIDs'="")&&(("|"_aHospIDs_"|")'[("|"_HospID_"|"))
	
		Set xLocID=""
		For {
			Set xLocID=$o(^DHCHAI.STA.HandHyI("IdxofLoc",HospID,xLocID))
			Quit:xLocID=""
			Continue:(aLocID'="")&&(aLocID'=xLocID)
			
			For xDate=$zdh(aDateFrom_"-01",3):1:$zdh(aDateTo_"-01",3) {
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.STA.HandHyI("IdxofLoc",HospID,xLocID,xDate,xID))
					Quit:xID=""
					
					Set obj=##class(DHCHAI.STA.HandHy).GetObjById(xID)
					Continue:'$IsObject(obj)
					Continue:'$IsObject(obj.ECObsTypeDr)
					Continue:'$IsObject(obj.ECOpportunityDr)
					Set TypeDesc=obj.ECObsTypeDr.BTDesc
					Set OpportDesc=obj.ECOpportunityDr.BTDesc
					Continue:(aOpport'="")&&(aOpport'=OpportDesc)
					Set ObsTime=obj.ObsTime_"*"_xLocID
					//Set PageID=$p(ObsTime,"-",1)_"*"_xLocID
					
					If ('$d(^TMP($zn,$j,NIndex,"Type",TypeDesc,OpportDesc,ObsTime))) {
						Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"Value1"))
						Set ^TMP($zn,$j,NIndex,TypeDesc,"Value2")=$g(^TMP($zn,$j,NIndex,TypeDesc,"Value2"))+obj.ECValue2
						Set ^TMP($zn,$j,NIndex,TypeDesc,"Value3")=$g(^TMP($zn,$j,NIndex,TypeDesc,"Value3"))+obj.ECValue3
						Set ^TMP($zn,$j,NIndex,"Type",TypeDesc,OpportDesc,ObsTime)=""
					}
				}
				
			}
		}
	}
	Set ObsTypeList=##class(DHCHAI.BTS.DictionarySrv).GetDicList("HandHyObsType")
	Set TypeListLen = $l(ObsTypeList,$c(1))
	For xxind=1:1:TypeListLen {
		Set xxType=$p($p(ObsTypeList,$c(1),xxind),$c(2),2)
		
		Set (Value1,Value2,Value3,Radio1,Radio2,PatCount)=0
		Set Value1=+$g(^TMP($zn,$j,NIndex,xxType,"Value1"))
		Set Value2=+$g(^TMP($zn,$j,NIndex,xxType,"Value2"))
		Set Value3=+$g(^TMP($zn,$j,NIndex,xxType,"Value3"))
		Set PatCount=""
		
		Set:Value1'=0 Radio1=$fn((Value2/Value1)*100,"",2)	//依从率
		Set:Value2'=0 Radio2=$fn((Value3/Value2)*100,"",2)	//正确率
		Set Data=$lb(ind,HospID,xxType,Value1,Value2,Value3,Radio1,Radio2,PatCount)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
			
	}
	Quit $$$OK
}

ClassMethod QryHDForChartsTClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHDForChartsTExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHDForChartsTFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHDForChartsTExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-01
/// Description:  手卫生统计图(按指征)
/// Table：       DHCHAI.STA.HandHy
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.STAS.HandHySrv","QryHDForChartsO","","2021-06","2021-06","1")
Query QryHDForChartsO(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aType As %String = "") As %Query(ROWSPEC = "ind:%String,HospID:%String,CatDesc:%String,Value1:%String,Value2:%String,Value3:%String,Radio1:%String,Radio2:%String,ECPatCount:%String") [ SqlProc ]
{
}

ClassMethod QryHDForChartsOExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set NIndex="QryHDForChartsO"
    Kill ^TMP($zn,$j,NIndex)
	
	Set HospID=""
	For {
		Set HospID=$o(^DHCHAI.STA.HandHyI("IdxofLoc",HospID))
		Quit:HospID=""
		Continue:(aHospIDs'="")&&(("|"_aHospIDs_"|")'[("|"_HospID_"|"))
	
		Set xLocID=""
		For {
			Set xLocID=$o(^DHCHAI.STA.HandHyI("IdxofLoc",HospID,xLocID))
			Quit:xLocID=""
			Continue:(aLocID'="")&&(aLocID'=xLocID)
			
			For xDate=$zdh(aDateFrom_"-01",3):1:$zdh(aDateTo_"-01",3) {
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.STA.HandHyI("IdxofLoc",HospID,xLocID,xDate,xID))
					Quit:xID=""
					
					Set obj=##class(DHCHAI.STA.HandHy).GetObjById(xID)
					Continue:'$IsObject(obj)
					Set TypeDesc=obj.ECObsTypeDr.BTDesc
					Set OpportDesc=obj.ECOpportunityDr.BTDesc
					
					Continue:(aType'="")&&(aType'=TypeDesc)
					Set ObsTime=obj.ObsTime_"*"_xLocID
					Set PageID=$p(ObsTime,"-",1)_"*"_xLocID
					
					If ('$d(^TMP($zn,$j,NIndex,"Type",TypeDesc,OpportDesc,ObsTime))) {
						Set num=$i(^TMP($zn,$j,NIndex,OpportDesc,"Value1"))
						Set ^TMP($zn,$j,NIndex,OpportDesc,"Value2")=$g(^TMP($zn,$j,NIndex,OpportDesc,"Value2"))+obj.ECValue2
						Set ^TMP($zn,$j,NIndex,OpportDesc,"Value3")=$g(^TMP($zn,$j,NIndex,OpportDesc,"Value3"))+obj.ECValue3
						Set ^TMP($zn,$j,NIndex,"Type",TypeDesc,OpportDesc,ObsTime)=""   //加入指征
					}
				}
				
			}
		}
	}
	
	Set ObsOpportlist=##class(DHCHAI.BTS.DictionarySrv).GetDicList("HandHyOpportunity")
	Set OpportlistLen = $l(ObsOpportlist,$c(1))
	For xxind=1:1:OpportlistLen{
		Set xxOpport=$p($p(ObsOpportlist,$c(1),xxind),$c(2),2)
		
		Set (Value1,Value2,Value3,Radio1,Radio2)=0
		Set Value1=+$g(^TMP($zn,$j,NIndex,xxOpport,"Value1"))
		Set Value2=+$g(^TMP($zn,$j,NIndex,xxOpport,"Value2"))
		Set Value3=+$g(^TMP($zn,$j,NIndex,xxOpport,"Value3"))
		Set PatCount="*"
		
		Set:Value1'=0 Radio1=$fn((Value2/Value1)*100,"",2)	//依从率
		Set:Value2'=0 Radio2=$fn((Value3/Value2)*100,"",2)	//正确率
		Set Data=$lb(ind,HospID,xxOpport,Value1,Value2,Value3,Radio1,Radio2,PatCount)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
			
	}
	Quit $$$OK
}

ClassMethod QryHDForChartsOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHDForChartsOExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHDForChartsOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHDForChartsOExecute ]
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
