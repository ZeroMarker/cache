/// 名称: DHCHAI.IRS.EnviHyLocItemsSrv
/// 描述: 环境卫生学科室监测项目计划服务
/// 编写者：zhangdc
/// 编写日期: 2019-09-20
Class DHCHAI.IRS.EnviHyLocItemsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2021-06-03
/// Description:  根据日期查询科室监测项目计划是否完成
///               入参是当月的开始和结束日期
/// Table：       DHCHAI.IR.EnviHyLocItems
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyLocItemsSrv","QryLocMissItems","2021-06-01","2021-06-01")
Query QryLocMissItems(aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ID:%String,LocID:%String,LocDesc:%String,EHItemDr:%String,EHItemDesc:%String,DateUnitDesc:%String,EHItemMax:%String,MonitSum:%String,NotMonitSum:%String,MessageInfo:%String,EHActDate:%String,ToUser:%String") [ SqlProc ]
{
}

ClassMethod QryLocMissItemsExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set IsCheckFlag = ##class(DHCHAI.BT.Config).GetValByCode("IREnviAItemConfig")  // 0：全部，1：环境卫生学监测项目走科室计划
	Quit:IsCheckFlag'=1 $$$OK
	Set IsMangePlanFlag=##class(DHCHAI.BT.Config).GetValByCode("EnviHyMangePlan")  //0：否 院感科申请的项目是否计算到监测计划数量限制
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.EnviHyLocItemsD(xID))
		Quit:xID=""
		
		Set objItem = ##class(DHCHAI.IR.EnviHyLocItems).GetObjById(xID)
		Continue:'$IsObject(objItem)
		Set IsActive = objItem.EHIsActive
		Continue:(IsActive'=1)
		Set ObjLoc = objItem.EHLocationDr
		Continue:'$IsObject(ObjLoc)
		Set LocID=ObjLoc.%Id()             // 监测科室
		Set LocDesc=ObjLoc.BTDesc2
		Set:LocDesc="" LocDesc=ObjLoc.BTDesc
		Continue:'$IsObject(objItem.EHItemDr)
		// 监测项目
		Set EHItemDr   = objItem.EHItemDr.%Id()
		Set EHItemDesc = objItem.EHItemDr.EHItemDesc
		Continue:'$IsObject(objItem.EHItemUnit)
		// 限定单位（项/月、项/季度、项/半年、项/年）
		Set ItemUnitDr     = objItem.EHItemUnit.%Id()
		Set EHItemUnitDesc = objItem.EHItemUnit.BTDesc
		Set EHPlanDate = objItem.EHPlanDate   // 计划安排日期
		Continue:(EHPlanDate="")
		Set:EHPlanDate'="" EHPlanDate=$zd(EHPlanDate,3)
		Set EHItemMax = +objItem.EHItemMax
		Set Month=$p(EHPlanDate,"-",2)
		Set DateUnitDesc=""
		Set Year=$p($zd(+$h,3),"-",1)
		Set CurrMonth=$p($zd(aDateFrom,3),"-",2)
		Set DateFrom="",DateTo=""
		If (EHItemUnitDesc["月"){
			Set DateUnitDesc=Year_"年"_Month_"月"
			Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-"_CurrMonth,1)
			Set DateFrom    = $p(StartEndDate,"^",1)
			Set DateTo      = $p(StartEndDate,"^",2)
			Continue:((objItem.EHPlanDate<DateFrom)||(objItem.EHPlanDate>DateTo))
		}
		If (EHItemUnitDesc["季度"){
			If (Month<4){ //一季度
				Set DateUnitDesc=Year_"年1季度"
				Continue:(CurrMonth'="03")
				Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-03",1)
				Set DateFrom    = $zdh(Year_"-01-01",3)
				Set DateTo      = $p(StartEndDate,"^",2)
			}ElseIf (Month<7){
				Set DateUnitDesc=Year_"年2季度"
				Continue:(CurrMonth'="06")
				Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-06",1)
				Set DateFrom    = $zdh(Year_"-04-01",3)
				Set DateTo      = $p(StartEndDate,"^",2)
			}ElseIf (Month<10){
				Set DateUnitDesc=Year_"年3季度"
				Continue:(CurrMonth'="09")
				Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-09",1)
				Set DateFrom    = $zdh(Year_"-07-01",3)
				Set DateTo      = $p(StartEndDate,"^",2)
			}Else{
				Set DateUnitDesc=Year_"年4季度"
				Continue:(CurrMonth'="12")
				Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-12",1)
				Set DateFrom    = $zdh(Year_"-10-01",3)
				Set DateTo      = $p(StartEndDate,"^",2)
			}
		}
		If (EHItemUnitDesc["半年"){
			If (Month<6){
				Set DateUnitDesc=Year_"年上半年"
				Continue:(CurrMonth'="06")
				Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-06",1)
				Set DateFrom    = $zdh(Year_"-01-01",3)
				Set DateTo      = $p(StartEndDate,"^",2)
			}Else{
				Set DateUnitDesc=Year_"年下半年"
				Continue:(CurrMonth'="12")
				Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-12",1)
				Set DateFrom    = $zdh(Year_"-07-01",3)
				Set DateTo      = $p(StartEndDate,"^",2)
			}
		}
		If (EHItemUnitDesc="项/年"){
			Set DateUnitDesc=Year_"年全年"
			Continue:(CurrMonth'="12")
			Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-12",1)
			Set DateFrom    = $zdh(Year_"-01-01",3)
			Set DateTo      = $p(StartEndDate,"^",2)
		}
		Set MLogID=$o(^DHCHAI.IR.EnviLocMLogI("IdxLocItemDr",LocID,EHItemDr," "_DateUnitDesc,""))
		Set objMLog=##class(DHCHAI.IR.EnviLocMLog).GetObjById(MLogID)
		Set ToUser="",MessageInfo="",EHActDate=""
		If ($IsObject(objMLog)){
			Set MessageInfo = objMLog.MessageInfo
			Set EHActDate = objMLog.EHActDate
			Set:EHActDate'="" EHActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EHActDate)
			Set objHISUser  = objMLog.HISUser
			If ($IsObject(objHISUser)){
				Set ToUser = objHISUser.BTDesc
			}
		}
		Set MonitSum=0
		//获取该科室该项目本月监测的次数
		For xDate = DateFrom:1:DateTo{
		 	Set xxID = ""
		 	For {
				Set xxID = $o(^DHCHAI.IR.EnviHyReportI("IndexOnApplyDate",xDate,xxID))
				Quit:xxID=""
				Set objRep=##class(DHCHAI.IR.EnviHyReport).GetObjById(xxID)
				Continue:'$IsObject(objRep)
				Continue:'$IsObject(objRep.EHItemDr)       //监测项目不允许为空
				Continue:'$IsObject(objRep.EHRepStatus)    //状态不允许为空
				Continue:(objRep.EHIsReCheck=1) // 过滤复查的报告
				Set ItemDr=objRep.EHItemDr.%Id()      //项目名称
				Continue:(EHItemDr'=ItemDr)
				//报告状态
				Set StatusCode=objRep.EHRepStatus.BTCode
				Set StatusDesc=objRep.EHRepStatus.BTDesc
				Continue:(StatusDesc="删除")
				Set MonitLocDr=""
				If $IsObject(objRep.EHMonitorLocDr){
					Set MonitLocDr=objRep.EHMonitorLocDr.%Id()
				}
				Continue:(LocID'=MonitLocDr)
				Set ApplyLocDr=""
				If $IsObject(objRep.EHApplyLocDr){
					Set ApplyLocDr=objRep.EHApplyLocDr.%Id()
				}
				Continue:(IsMangePlanFlag=0)&&(ApplyLocDr'=MonitLocDr) // 过滤院感科给临床科室开的项目
				Set MonitSum=MonitSum+1
			}
		}
		Continue:(MonitSum>=EHItemMax)
		
		Set NotMonitSum = EHItemMax-MonitSum  // 未检测数量
		
		Set Data=$lb(xID,LocID,LocDesc,EHItemDr,EHItemDesc,DateUnitDesc,EHItemMax,MonitSum,NotMonitSum,MessageInfo,EHActDate,ToUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	Quit $$$OK
}

ClassMethod QryLocMissItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocMissItemsExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocMissItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocMissItemsExecute ]
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

/// 获得未检测项目数量
/// w ##class(DHCHAI.IRS.EnviHyLocItemsSrv).GetRemindEnvRt()
ClassMethod GetRemindEnvRt() As %String
{
	Set return=0
	Set Count=0
 	Set rs=##Class(%ResultSet).%New("DHCHAI.IRS.EnviHyLocItemsSrv:QryLocMissItems")
  	Set sc=rs.Execute(+$h,+$h)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	While (rs.Next()){
		//计数
		Set Count=Count+1
	}
    Set return = Count
    Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-29
/// Description:  保存科室计划数据
/// Table：       DHCHAI.IR.EnviHyLocItems
/// Input：       
/// w ##class(DHCHAI.IRS.EnviHyLocItemsSrv).SaveLocItems("^1^73^^^880,881,882,883^^1","^")
ClassMethod SaveLocItems(inputStr As %String, aSeparete As %String = "^") As %String
{
	New (inputStr,aSeparete)
	Set return=""
	
	Set ID			 = $p(inputStr,aSeparete,1)
	Set LocationID	 = $p(inputStr,aSeparete,2)
	Set ItemID       = $p(inputStr,aSeparete,3)
	Set ItemMax      = $p(inputStr,aSeparete,4)
	Set ItemMin      = $p(inputStr,aSeparete,5)
	Set DateItemIDs  = $p(inputStr,aSeparete,6)
	Set Note         = $p(inputStr,aSeparete,7)
	Set IsActive	 = +$p(inputStr,aSeparete,8)
	Quit:(LocationID="")||(ItemID="")||(DateItemIDs="") return
	Set xID = ""
 	For {
		Set xID = $o(^DHCHAI.IR.EnviHyLocItemsI("IdxLocItemDr",LocationID,ItemID,xID))
		Quit:xID=""
		Set objItm=##class(DHCHAI.IR.EnviHyLocItems).GetObjById(xID)
		Continue:'$IsObject(objItm)
		Set ret=##class(DHCHAI.IR.EnviHyLocItems).DeleteById(xID)
 	}
	Set aCurrDate=$zd(+$h,3)
	Set aYear=+$p(aCurrDate,"-",1)
	
	For i=1:1:$l(DateItemIDs,","){
		Set DateItemID = $p(DateItemIDs,",",i)
		Set objItem = ##class(DHCHAI.BT.Dictionary).GetObjById(DateItemID)
		Continue:'$IsObject(objItem)
		// 1-12为月份;13-16为季度;17上半年18上半年19全年
		Set ItemCode =+objItem.BTCode
		Continue:ItemCode<1
		If (ItemCode<13){ //（1项/月、2项/季度、3项/半年、4项/年） EHItemUnit
			Set ItemUnitCode=1
			Set:ItemCode<10 PlanDate = aYear_"-0"_ItemCode_"-01"
			Set:ItemCode>=10 PlanDate = aYear_"-"_ItemCode_"-01"
		}ElseIf (ItemCode<17){
			Set ItemUnitCode=2
			Set:ItemCode="13" PlanDate = aYear_"-01-01"
			Set:ItemCode="14" PlanDate = aYear_"-04-01"
			Set:ItemCode="15" PlanDate = aYear_"-07-01"
			Set:ItemCode="16" PlanDate = aYear_"-10-01"
		}ElseIf (ItemCode<19){
			Set ItemUnitCode=3
			Set:ItemCode="17" PlanDate = aYear_"-01-01"
			Set:ItemCode="18" PlanDate = aYear_"-07-01"
		}Else{
			Set ItemUnitCode=4
			Set PlanDate = aYear_"-01-01"
		}
		Set aPlanMonth=+$p(PlanDate,"-",2)
		Set ObjDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("EHItemUnit",ItemUnitCode)
		Set ItemUnitID = ObjDic.%Id()
		Set RepID=""
		Set xID = ""
	 	For {
			Set xID = $o(^DHCHAI.IR.EnviHyLocItemsI("IdxLocItemDr",LocationID,ItemID,xID))
			Quit:xID=""
			Set objItm=##class(DHCHAI.IR.EnviHyLocItems).GetObjById(xID)
			Continue:'$IsObject(objItm)
			Set tmpIsActive=objItm.EHIsActive
			Continue:(tmpIsActive'=1)
			Set objUnit = objItm.EHItemUnit
			Continue:'$IsObject(objUnit)
			Set UnitCode = objUnit.BTCode // （1项/月、2项/季度、3项/半年、4项/年）EHItemUnit
			Continue:(ItemUnitCode'=UnitCode)
			Set EHPlanDate=objItm.EHPlanDate
			Set EHPlanDate=$zd(EHPlanDate,3)
			Set PlanMonth=+$p(EHPlanDate,"-",2)
			
			If (UnitCode=1){
				Set:PlanMonth=ItemCode RepID=xID
			}ElseIf (UnitCode=2){
				If (aPlanMonth<4){ //一季度
					Continue:'(PlanMonth<4)
					Set RepID=xID
				}ElseIf (aPlanMonth<7){
					Continue:'((4<=PlanMonth)&&(PlanMonth<7))
					Set RepID=xID
				}ElseIf (aPlanMonth<10){
					Continue:'((7<=PlanMonth)&&(PlanMonth<7))
					Set RepID=xID
				}Else{
					Continue:'((10<=PlanMonth))
					Set RepID=xID
				}
			}ElseIf (UnitCode=3){
				If (aPlanMonth<7){ //上半年
					Continue:'(PlanMonth<7)
					Set RepID=xID
				}Else{
					Continue:(PlanMonth<7)
					Set RepID=xID
				}
			}Else{ // 4
				Set RepID=xID	
			}
			Quit:RepID'=""
		}
		Set inputStr=RepID_"^"_LocationID_"^"_ItemID_"^"_ItemMax_"^"_ItemMin_"^"_ItemUnitID_"^"_PlanDate_"^"_Note_"^"_IsActive
		
		Set return=##class(DHCHAI.IR.EnviHyLocItems).Update(inputStr,"^")
	}
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2021-10-26
/// Description:  保存科室计划数据
/// Table：       DHCHAI.IR.EnviHyLocItems
/// Input：       
/// w ##class(DHCHAI.IRS.EnviHyLocItemsSrv).SaveLocItemsByItem("^1^73^^^880,881,882,883^^1","^")
ClassMethod SaveLocItemsByItem(inputStr As %String, aSeparete As %String = "^") As %String
{
	New (inputStr,aSeparete)
	Set return=""
	
	Set ID			 = $p(inputStr,aSeparete,1)
	Set aSubLocIDs	 = $p(inputStr,aSeparete,2)
	Set ItemID       = $p(inputStr,aSeparete,3)
	Set ItemMax      = $p(inputStr,aSeparete,4)
	Set ItemMin      = $p(inputStr,aSeparete,5)
	Set DateItemIDs  = $p(inputStr,aSeparete,6)
	Set Note         = $p(inputStr,aSeparete,7)
	Set IsActive	 = +$p(inputStr,aSeparete,8)
	Quit:(aSubLocIDs="")||(ItemID="")||(DateItemIDs="") return
	
	For xi=2:1:$l(aSubLocIDs,","){      //取出的第一位是空，所以从第二位开始
		Set LocationID = $p(aSubLocIDs,",",xi)
		Set xID = ""
	 	For {
			Set xID = $o(^DHCHAI.IR.EnviHyLocItemsI("IdxLocItemDr",LocationID,ItemID,xID))
			Quit:xID=""
			Set objItm=##class(DHCHAI.IR.EnviHyLocItems).GetObjById(xID)
			Continue:'$IsObject(objItm)
			Set ret=##class(DHCHAI.IR.EnviHyLocItems).DeleteById(xID)
	 	}
		Set aCurrDate=$zd(+$h,3)
		Set aYear=+$p(aCurrDate,"-",1)
		
		For i=1:1:$l(DateItemIDs,","){
			Set DateItemID = $p(DateItemIDs,",",i)
			Set objItem = ##class(DHCHAI.BT.Dictionary).GetObjById(DateItemID)
			Continue:'$IsObject(objItem)
			// 1-12为月份;13-16为季度;17上半年18上半年19全年
			Set ItemCode =+objItem.BTCode
			Continue:ItemCode<1
			If (ItemCode<13){ //（1项/月、2项/季度、3项/半年、4项/年） EHItemUnit
				Set ItemUnitCode=1
				Set:ItemCode<10 PlanDate = aYear_"-0"_ItemCode_"-01"
				Set:ItemCode>=10 PlanDate = aYear_"-"_ItemCode_"-01"
			}ElseIf (ItemCode<17){
				Set ItemUnitCode=2
				Set:ItemCode="13" PlanDate = aYear_"-01-01"
				Set:ItemCode="14" PlanDate = aYear_"-04-01"
				Set:ItemCode="15" PlanDate = aYear_"-07-01"
				Set:ItemCode="16" PlanDate = aYear_"-10-01"
			}ElseIf (ItemCode<19){
				Set ItemUnitCode=3
				Set:ItemCode="17" PlanDate = aYear_"-01-01"
				Set:ItemCode="18" PlanDate = aYear_"-07-01"
			}Else{
				Set ItemUnitCode=4
				Set PlanDate = aYear_"-01-01"
			}
			Set aPlanMonth=+$p(PlanDate,"-",2)
			Set ObjDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("EHItemUnit",ItemUnitCode)
			Set ItemUnitID = ObjDic.%Id()
			Set RepID=""
			Set xID = ""
		 	For {
				Set xID = $o(^DHCHAI.IR.EnviHyLocItemsI("IdxLocItemDr",LocationID,ItemID,xID))
				Quit:xID=""
				Set objItm=##class(DHCHAI.IR.EnviHyLocItems).GetObjById(xID)
				Continue:'$IsObject(objItm)
				Set tmpIsActive=objItm.EHIsActive
				Continue:(tmpIsActive'=1)
				Set objUnit = objItm.EHItemUnit
				Continue:'$IsObject(objUnit)
				Set UnitCode = objUnit.BTCode // （1项/月、2项/季度、3项/半年、4项/年）EHItemUnit
				Continue:(ItemUnitCode'=UnitCode)
				Set EHPlanDate=objItm.EHPlanDate
				Set EHPlanDate=$zd(EHPlanDate,3)
				Set PlanMonth=+$p(EHPlanDate,"-",2)
				
				If (UnitCode=1){
					Set:PlanMonth=ItemCode RepID=xID
				}ElseIf (UnitCode=2){
					If (aPlanMonth<4){ //一季度
						Continue:'(PlanMonth<4)
						Set RepID=xID
					}ElseIf (aPlanMonth<7){
						Continue:'((4<=PlanMonth)&&(PlanMonth<7))
						Set RepID=xID
					}ElseIf (aPlanMonth<10){
						Continue:'((7<=PlanMonth)&&(PlanMonth<7))
						Set RepID=xID
					}Else{
						Continue:'((10<=PlanMonth))
						Set RepID=xID
					}
				}ElseIf (UnitCode=3){
					If (aPlanMonth<7){ //上半年
						Continue:'(PlanMonth<7)
						Set RepID=xID
					}Else{
						Continue:(PlanMonth<7)
						Set RepID=xID
					}
				}Else{ // 4
					Set RepID=xID	
				}
				Quit:RepID'=""
			}
			Set inputStr=RepID_"^"_LocationID_"^"_ItemID_"^"_ItemMax_"^"_ItemMin_"^"_ItemUnitID_"^"_PlanDate_"^"_Note_"^"_IsActive
			
			Set return=##class(DHCHAI.IR.EnviHyLocItems).Update(inputStr,"^")
		}
	
	}
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-29
/// Description:  删除科室计划数据
/// Table：       DHCHAI.IR.EnviHyLocItems
/// Input：       
/// w ##class(DHCHAI.IRS.EnviHyLocItemsSrv).DeleteLocItems("")
ClassMethod DeleteLocItems(aLocItemIDs As %String) As %String
{
	New (aLocItemIDs)
	
	Set return=""
	Quit:(aLocItemIDs="") return
	
	For i=1:1:$l(aLocItemIDs,","){
		Set LocItemID = $p(aLocItemIDs,",",i)
		Set return=##class(DHCHAI.IR.EnviHyLocItems).DeleteById(LocItemID)
	}
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-29
/// Description:  根据科室id查询科室监测项目计划
/// Table：       DHCHAI.IR.EnviHyLocItems
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyLocItemsSrv","QryLocItems","",569)
Query QryLocItems(aLocID As %String = "", aEvItemFL As %String = "") As %Query(ROWSPEC = "ID:%String,ItemDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLocItemsExecute(ByRef qHandle As %Binary, aLocID As %String = "", aEvItemFL As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set IsCheckFlag=##class(DHCHAI.BT.Config).GetValByCode("IREnviAItemConfig")  //0：全部，1：环境卫生学监测项目走科室计划
	Set ItemList=$lb()
	If (IsCheckFlag=1){
		If (aLocID'=""){
			Set xID = ""
		 	For {
				Set xID = $o(^DHCHAI.IR.EnviHyLocItemsI("IdxLocationDr",aLocID,xID))
				Quit:xID=""
				Set obj=##class(DHCHAI.IR.EnviHyLocItems).GetObjById(xID)
				Continue:'$IsObject(obj)
				Set IsActive=obj.EHIsActive
				Continue:(IsActive'=1)
				//监测项目
				Set EvItemID="",EvItemDesc=""
				If $IsObject(obj.EHItemDr){
					Set EvItemID   = obj.EHItemDr.%Id()
					Set EvItemDesc = obj.EHItemDr.EHItemDesc
				}
				Set ItemTypeID="",ItemTypeDesc=""
				If $IsObject(obj.EHItemDr.EHItemTypeDr){
					Set ItemTypeID=obj.EHItemDr.EHItemTypeDr.%Id()
					Set ItemTypeDesc=obj.EHItemDr.EHItemTypeDr.BTDesc
				}
				Continue:(aEvItemFL'="")&&(aEvItemFL'=ItemTypeID)
				Continue:($lf(ItemList,EvItemID)>0)
				Set ItemList=ItemList_$lb(EvItemID)
				Set EHPlanDate=+obj.EHPlanDate
				Set UnitID="",UnitDesc=""
				If $IsObject(obj.EHItemUnit){
					Set UnitID=obj.EHItemUnit.%Id()
					Set UnitDesc=obj.EHItemUnit.BTDesc
				}
				/*Continue:((+$h)<EHPlanDate)
				//项/月、项/季度
				If (UnitDesc="项/月"){
					Set PlanDate=$zd(EHPlanDate,3)
					Set CUurDate=$zd(+$h,3)
					Continue:(($p(PlanDate,"-",2))'=($p(CUurDate,"-",2)))
				}ElseIf (UnitDesc="项/季度"){
					Set PlanDate=$zd(EHPlanDate,3)
					Set CUurDate=$zd(+$h,3)
					Continue:(((+$p(CUurDate,"-",2))-(+$p(PlanDate,"-",2)))>3)
				}*/
				//多语言处理
				Set EvItemDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("EHItemDesc",EvItemDesc,"DHCHAI.IR.EnviHyItem")
				Set Data=$lb(EvItemID,EvItemDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1	
			}
		}Else{
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.IR.EnviHyItemD(xID))
				Quit:xID=""
				
				Set objItem = ##class(DHCHAI.IR.EnviHyItem).GetObjById(xID)
				Continue:'$IsObject(objItem)
				
				Set ItemDesc  = objItem.EHItemDesc
				Set IsActive  = objItem.EHIsActive
				Set ItemTypeID="",ItemTypeDesc=""
				If $IsObject(objItem.EHItemTypeDr){
					Set ItemTypeID=objItem.EHItemTypeDr.%Id()
					Set ItemTypeDesc=objItem.EHItemTypeDr.BTDesc
				}
				Continue:(aEvItemFL'="")&&(aEvItemFL'=ItemTypeID)
				Continue:(IsActive'=1)
				Set ItemDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("EHItemDesc",ItemDesc,"DHCHAI.IR.EnviHyItem")
				Set Data=$lb(xID,ItemDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1	
			}
		}
	}Else{
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.IR.EnviHyItemD(xID))
			Quit:xID=""
			
			Set objItem = ##class(DHCHAI.IR.EnviHyItem).GetObjById(xID)
			Continue:'$IsObject(objItem)
			
			Set ItemDesc  = objItem.EHItemDesc
			Set IsActive  = objItem.EHIsActive
			Set ItemTypeID="",ItemTypeDesc=""
			If $IsObject(objItem.EHItemTypeDr){
				Set ItemTypeID=objItem.EHItemTypeDr.%Id()
				Set ItemTypeDesc=objItem.EHItemTypeDr.BTDesc
			}
			Continue:(aEvItemFL'="")&&(aEvItemFL'=ItemTypeID)
			Continue:(IsActive'=1)
			Set ItemDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("EHItemDesc",ItemDesc,"DHCHAI.IR.EnviHyItem")
			Set Data=$lb(xID,ItemDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	
		}
	}
	Quit $$$OK
}

ClassMethod QryLocItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocItemsExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocItemsExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2020-12-29
/// Description:  根据申请科室+检验项目+日期判断是否允许申请
/// Table：       
/// Input：       aLocDr  : 申请科室
///               aItemDr : 检验项目ID
///               aDate   : 监测日期
/// Return：      返回1：允许申请
/// w ##class(DHCHAI.IRS.EnviHyLocItemsSrv).CheckIsAllowApply("117","49","2021-01-15")
ClassMethod CheckIsAllowApply(aLocDr As %String, aItemDr As %String, aDate As %String) As %String
{
	New (aLocDr,aItemDr,aDate)
	Set return=""
	Quit:(aLocDr="")||(aItemDr="")||(aDate="") return
	Set:aDate'="" aDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDate)
	Set aCurrDate=$zd(+$h,3)
	Set IsCheckFlag=##class(DHCHAI.BT.Config).GetValByCode("IREnviAItemConfig")  //0：全部，1：环境卫生学监测项目走科室计划
	Quit:IsCheckFlag'="1" 1
	// 获取科室计划信息
	Set EHItemMax=0  //先按最新的计算
	Set xID = ""
 	For {
		Set xID = $o(^DHCHAI.IR.EnviHyLocItemsI("IdxLocItemDr",aLocDr,aItemDr,xID))
		Quit:xID=""
		Set objItm=##class(DHCHAI.IR.EnviHyLocItems).GetObjById(xID)
		Continue:'$IsObject(objItm)
		Set IsActive=objItm.EHIsActive
		Continue:(IsActive'=1)
		Set objUnit = objItm.EHItemUnit
		Continue:'$IsObject(objUnit)
		Set UnitCode = objUnit.BTCode // （1项/月、2项/季度、3项/半年、4项/年）EHItemUnit
		Set EHPlanDate = objItm.EHPlanDate
		Set:EHPlanDate'="" aCurrDate=$zd(EHPlanDate,3)
		If (UnitCode=1){
			Set aMonth=+$p(aCurrDate,"-",2)
			Set aDateFrom=$p(aCurrDate,"-",1)_"-"_$p(aCurrDate,"-",2)_"-01"
			Set aDateTo=$zdh(aDateFrom,3)+32
			Set aDateTo=$zd(aDateTo,3)
			Set aDateTo=$p(aDateTo,"-",1)_"-"_$p(aDateTo,"-",2)_"-01"
			Set aDateTo=$zdh(aDateTo,3)-1
			Set aDateTo=$zd(aDateTo,3)
		}ElseIf (UnitCode=2){
			Set aMonth=+$p(aCurrDate,"-",2)
			If (aMonth<4){ //一季度
				Set aDateFrom=$p(aCurrDate,"-",1)_"-01-01"
				Set aDateTo=$p(aCurrDate,"-",1)_"-03-31"
			}ElseIf (aMonth<7){
				Set aDateFrom=$p(aCurrDate,"-",1)_"-04-01"
				Set aDateTo=$p(aCurrDate,"-",1)_"-06-30"
			}ElseIf (aMonth<10){
				Set aDateFrom=$p(aCurrDate,"-",1)_"-07-01"
				Set aDateTo=$p(aCurrDate,"-",1)_"-09-30"
			}Else{
				Set aDateFrom=$p(aCurrDate,"-",1)_"-10-01"
				Set aDateTo=$p(aCurrDate,"-",1)_"-12-31"
			}
		}ElseIf (UnitCode=3){
			Set aMonth=+$p(aDate,"-",2)
			If (aMonth<7){ //上半年
				Set aDateFrom=$p(aCurrDate,"-",1)_"-01-01"
				Set aDateTo=$p(aCurrDate,"-",1)_"-06-30"
			}Else{
				Set aDateFrom=$p(aCurrDate,"-",1)_"-07-01"
				Set aDateTo=$p(aCurrDate,"-",1)_"-12-31"
			}
		}Else{ // 4
			Set aYear=+$p(aCurrDate,"-",1)
			Set aDateFrom=$p(aCurrDate,"-",1)_"-01-01"
			Set aDateTo=$p(aCurrDate,"-",1)_"-12-31"	
		}
		Set aDateFrom=$zdh(aDateFrom,3)
		Set aDateTo=$zdh(aDateTo,3)
		
		If ((aDate>=aDateFrom) &(aDate<=aDateTo)){
			Set return=1
		}Else{
			Set return=2
		}
		Quit:return=1
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-29
/// Description:  根据申请科室+检验项目+日期判断是否超过科室计划限制次数
/// Table：       
/// Input：       aLocDr  : 申请科室
///               aItemDr : 检验项目ID
///               aDate   : 监测日期
/// Return：      返回1：超过限制次数 "2"：还可以申请
/// w ##class(DHCHAI.IRS.EnviHyLocItemsSrv).CheckIsApply("49","86","2021-05-07")
ClassMethod CheckIsApply(aLocDr As %String, aItemDr As %String, aDate As %String) As %String
{
	New (aLocDr,aItemDr,aDate)
	Set return=""
	Quit:(aLocDr="")||(aItemDr="")||(aDate="") return
	Set IsCheckFlag=##class(DHCHAI.BT.Config).GetValByCode("IREnviAItemConfig")  //0：全部，1：环境卫生学监测项目走科室计划
	Quit:IsCheckFlag'="1" return
	Set IsMangePlanFlag=##class(DHCHAI.BT.Config).GetValByCode("EnviHyMangePlan")  //0：否 院感科申请的项目是否计算到监测计划数量限制
	// 获取科室计划信息
	Set EHItemMax=0  //先按最新的计算
	Set xID = ""
 	For {
		Set xID = $o(^DHCHAI.IR.EnviHyLocItemsI("IdxLocItemDr",aLocDr,aItemDr,xID))
		Quit:xID=""
		Set objItm=##class(DHCHAI.IR.EnviHyLocItems).GetObjById(xID)
		Continue:'$IsObject(objItm)
		Set IsActive=objItm.EHIsActive
		Continue:(IsActive'=1)
		Set objUnit = objItm.EHItemUnit
		Continue:'$IsObject(objUnit)
		Set PlanDate=objItm.EHPlanDate
		Set PlanDate=$zd(PlanDate,3)
		Set PlanDate=$p(aDate,"-",1)_"-"_$p(PlanDate,"-",2)_"-"_$p(PlanDate,"-",3)
		Set PlanDate=$zdh(PlanDate,3)
		Set UnitCode = objUnit.BTCode // （1项/月、2项/季度、3项/半年、4项/年）EHItemUnit
		If (UnitCode=1){
			Set aMonth=+$p(aDate,"-",2)
			Set aDateFrom=$p(aDate,"-",1)_"-"_$p(aDate,"-",2)_"-01"
			Set aDateTo=$zdh(aDateFrom,3)+32
			Set aDateTo=$zd(aDateTo,3)
			Set aDateTo=$p(aDateTo,"-",1)_"-"_$p(aDateTo,"-",2)_"-01"
			Set aDateTo=$zdh(aDateTo,3)-1
			Set aDateTo=$zd(aDateTo,3)
		}ElseIf (UnitCode=2){
			Set aMonth=+$p(aDate,"-",2)
			If (aMonth<4){ //一季度
				Set aDateFrom=$p(aDate,"-",1)_"-01-01"
				Set aDateTo=$p(aDate,"-",1)_"-03-31"
			}ElseIf (aMonth<7){
				Set aDateFrom=$p(aDate,"-",1)_"-04-01"
				Set aDateTo=$p(aDate,"-",1)_"-06-30"
			}ElseIf (aMonth<10){
				Set aDateFrom=$p(aDate,"-",1)_"-07-01"
				Set aDateTo=$p(aDate,"-",1)_"-09-30"
			}Else{
				Set aDateFrom=$p(aDate,"-",1)_"-10-01"
				Set aDateTo=$p(aDate,"-",1)_"-12-31"
			}
		}ElseIf (UnitCode=3){
			Set aMonth=+$p(aDate,"-",2)
			If (aMonth<7){ //上半年
				Set aDateFrom=$p(aDate,"-",1)_"-01-01"
				Set aDateTo=$p(aDate,"-",1)_"-06-30"
			}Else{
				Set aDateFrom=$p(aDate,"-",1)_"-07-01"
				Set aDateTo=$p(aDate,"-",1)_"-12-31"
			}
		}Else{ // 4
			Set aYear=+$p(aDate,"-",1)
			Set aDateFrom=$p(aDate,"-",1)_"-01-01"
			Set aDateTo=$p(aDate,"-",1)_"-12-31"	
		}
		Set aDateFrom=$zdh(aDateFrom,3)
		Set aDateTo=$zdh(aDateTo,3)
		Set MonitSum=0
		//获取该科室该项目本月监测的次数
		For xDate = aDateFrom:1:aDateTo{
		 	Set xxID = ""
		 	For {
				Set xxID = $o(^DHCHAI.IR.EnviHyReportI("IndexOnMonitorDate",xDate,xxID))
				Quit:xxID=""
				Set objRep=##class(DHCHAI.IR.EnviHyReport).GetObjById(xxID)
				Continue:'$IsObject(objRep)
				Continue:'$IsObject(objRep.EHItemDr)       //监测项目不允许为空
				Continue:'$IsObject(objRep.EHRepStatus)    //状态不允许为空
				Continue:(objRep.EHIsReCheck=1) // 过滤复查的报告
				Set ItemDr=objRep.EHItemDr.%Id()      //项目名称
				Continue:(aItemDr'=ItemDr)
				//报告状态
				Set StatusCode=objRep.EHRepStatus.BTCode
				Set StatusDesc=objRep.EHRepStatus.BTDesc
				Continue:(StatusDesc="删除")
				Set MonitLocDr=""
				If $IsObject(objRep.EHMonitorLocDr){
					Set MonitLocDr=objRep.EHMonitorLocDr.%Id()
				}
				Continue:(aLocDr'=MonitLocDr)
				Set ApplyLocDr=""
				If $IsObject(objRep.EHApplyLocDr){
					Set ApplyLocDr=objRep.EHApplyLocDr.%Id()
				}
				Continue:(IsMangePlanFlag=0)&&(ApplyLocDr'=MonitLocDr) // 过滤院感科给临床科室开的项目
				Set MonitSum=MonitSum+1
			}
		}
		Set EHItemMax = +objItm.EHItemMax
		Set EHItemMin = +objItm.EHItemMin
		If ((PlanDate>=aDateFrom)&&(PlanDate<=aDateTo)){
			If (MonitSum>=EHItemMax){
				Set return=1
			}Else{
				Set return=2
			}
		}Else{
			Set return=1	
		}
		Quit:return=2
	}
	Quit return
}

/// Creator：     liutao
/// CreatDate：   2022-04-28
/// Description:  根据申请科室+检验项目+日期查询科室本月监测项目申请次数
/// Table：       
/// Input：       aLocDr  : 申请科室
///               aItemDr : 检验项目ID
///               aDate   : 监测日期
/// w ##class(DHCHAI.IRS.EnviHyLocItemsSrv).ApplyCount("49","86","2021-05-07")
ClassMethod ApplyCount(aLocDr As %String, aItemDr As %String, aDate As %String) As %String
{
	New (aLocDr,aItemDr,aDate)
	Set return=0
	Quit:(aLocDr="")||(aItemDr="")||(aDate="") return
	// 获取科室计划信息
	Set EHItemMax=0  //先按最新的计算
	Set xID = ""
 	For {
		Set xID = $o(^DHCHAI.IR.EnviHyLocItemsI("IdxLocItemDr",aLocDr,aItemDr,xID))
		Quit:xID=""
		Set objItm=##class(DHCHAI.IR.EnviHyLocItems).GetObjById(xID)
		Continue:'$IsObject(objItm)
		Set IsActive=objItm.EHIsActive
		Continue:(IsActive'=1)
		Set objUnit = objItm.EHItemUnit
		Continue:'$IsObject(objUnit)
		Set UnitCode = objUnit.BTCode // （1项/月、2项/季度、3项/半年、4项/年）EHItemUnit
		
		If (UnitCode=1){
			Set aMonth=+$p(aDate,"-",2)
			Set aDateFrom=$p(aDate,"-",1)_"-"_$p(aDate,"-",2)_"-01"
			Set aDateTo=$zdh(aDateFrom,3)+32
			Set aDateTo=$zd(aDateTo,3)
			Set aDateTo=$p(aDateTo,"-",1)_"-"_$p(aDateTo,"-",2)_"-01"
			Set aDateTo=$zdh(aDateTo,3)-1
			Set aDateTo=$zd(aDateTo,3)
		}ElseIf (UnitCode=2){
			Set aMonth=+$p(aDate,"-",2)
			If (aMonth<4){ //一季度
				Set aDateFrom=$p(aDate,"-",1)_"-01-01"
				Set aDateTo=$p(aDate,"-",1)_"-03-31"
			}ElseIf (aMonth<7){
				Set aDateFrom=$p(aDate,"-",1)_"-04-01"
				Set aDateTo=$p(aDate,"-",1)_"-06-30"
			}ElseIf (aMonth<10){
				Set aDateFrom=$p(aDate,"-",1)_"-07-01"
				Set aDateTo=$p(aDate,"-",1)_"-09-30"
			}Else{
				Set aDateFrom=$p(aDate,"-",1)_"-10-01"
				Set aDateTo=$p(aDate,"-",1)_"-12-31"
			}
		}ElseIf (UnitCode=3){
			Set aMonth=+$p(aDate,"-",2)
			If (aMonth<7){ //上半年
				Set aDateFrom=$p(aDate,"-",1)_"-01-01"
				Set aDateTo=$p(aDate,"-",1)_"-06-30"
			}Else{
				Set aDateFrom=$p(aDate,"-",1)_"-07-01"
				Set aDateTo=$p(aDate,"-",1)_"-12-31"
			}
		}Else{ // 4
			Set aYear=+$p(aDate,"-",1)
			Set aDateFrom=$p(aDate,"-",1)_"-01-01"
			Set aDateTo=$p(aDate,"-",1)_"-12-31"	
		}
		Set aDateFrom=$zdh(aDateFrom,3)
		Set aDateTo=$zdh(aDateTo,3)
		Set MonitSum=0
		//获取该科室该项目本月监测的次数
		For xDate = aDateFrom:1:aDateTo{
		 	Set xxID = ""
		 	For {
				Set xxID = $o(^DHCHAI.IR.EnviHyReportI("IndexOnApplyDate",xDate,xxID))
				Quit:xxID=""
				Set objRep=##class(DHCHAI.IR.EnviHyReport).GetObjById(xxID)
				Continue:'$IsObject(objRep)
				Continue:'$IsObject(objRep.EHItemDr)       //监测项目不允许为空
				Continue:'$IsObject(objRep.EHRepStatus)    //状态不允许为空
				Continue:(objRep.EHIsReCheck=1) // 过滤复查的报告
				Set ItemDr=objRep.EHItemDr.%Id()      //项目名称
				Continue:(aItemDr'=ItemDr)
				//报告状态
				Set StatusCode=objRep.EHRepStatus.BTCode
				Set StatusDesc=objRep.EHRepStatus.BTDesc
				Continue:(StatusDesc="删除")
				Set MonitLocDr=""
				If $IsObject(objRep.EHMonitorLocDr){
					Set MonitLocDr=objRep.EHMonitorLocDr.%Id()
				}
				Continue:(aLocDr'=MonitLocDr)
				Set ApplyLocDr=""
				If $IsObject(objRep.EHApplyLocDr){
					Set ApplyLocDr=objRep.EHApplyLocDr.%Id()
				}
				Set MonitSum=MonitSum+1
		
			}
		}
		Set return=MonitSum
	}
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2019-09-20
/// Description:  根据科室id查询科室监测项目计划
/// Table：       DHCHAI.IR.EnviHyLocItems
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyLocItemsSrv","QryEnviHyLocItems","","73")
Query QryEnviHyLocItems(locId As %String, ItemID As %String = "") As %Query(ROWSPEC = "LoID:%String,EvItemID:%String,EvItemDesc:%String,EHPlanDate:%String,ApplyLocID:%String,ApplyLocDesc:%String,EHItemMax:%String,EHItemMin:%String,EHItemUnitID:%String,EHItemUnitDesc:%String,EHNote:%String,IsActive:%String,IsActiveDesc:%String,IDList:%String,DescList:%String,DescIDList:%String") [ SqlProc ]
{
}

ClassMethod QryEnviHyLocItemsExecute(ByRef qHandle As %Binary, locId As %String, ItemID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set NIndex="QryEnviHyLocItems"
	Kill ^TMP($zn,$j,NIndex)
	Set IDList=""
	Set DescList="",DescIDList=""
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.EnviHyLocItemsD(xID))
		Quit:xID=""
		
		Set obj = ##class(DHCHAI.IR.EnviHyLocItems).GetObjById(xID)
		Continue:'$IsObject(obj)
		
		//申请科室
		Set ApplyLocID="",ApplyLocDesc="",ApplyLocID1="",ApplyLocDesc2=""
		If $IsObject(obj.EHLocationDr){
			Set ApplyLocID1   = obj.EHLocationDr.%Id()
			Set ApplyLocDesc1 = obj.EHLocationDr.BTDesc

			if (locId = ApplyLocID1){
				Set ApplyLocID = ApplyLocID1
				Set ApplyLocDesc = ApplyLocDesc1
			}
			Continue:(locId'="")&&(ApplyLocDesc="")
		}
		
		//监测项目
		Set EvItemID="",EvItemDesc=""
		If $IsObject(obj.EHItemDr){
			Set EvItemID   = obj.EHItemDr.%Id()
			Set EvItemDesc = obj.EHItemDr.EHItemDesc
		}
		Continue:(ItemID'="")&&(ItemID'=EvItemID)
		//限定单位
		Set EHItemUnitID="",EHItemUnitDesc=""
		If $IsObject(obj.EHItemUnit){
			Set EHItemUnitID   = obj.EHItemUnit.%Id()
			Set EHItemUnitDesc = obj.EHItemUnit.BTDesc
		}
		
		Set EHPlanDate="",EHItemMax="",EHItemMin="",EHNote=""
		Set EHPlanDate  = obj.EHPlanDate
		Set:EHPlanDate'="" EHPlanDate=$zd(EHPlanDate,3)
		Set EHItemMax   = obj.EHItemMax
		Set EHItemMin   = obj.EHItemMin
		Set EHNote      = obj.EHNote
		Set IsActive 	= obj.EHIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set Month=+$p(EHPlanDate,"-",2)
		Set DateItemCode="",DateUnitDesc=""
		If (EHItemUnitDesc["月"){
			Set DateUnitDesc=Month_"月("_EHItemMax_"次)"
			Set DateItemCode=Month
		}
		If (EHItemUnitDesc["季度"){
			If (Month<4){ //一季度
				Set DateUnitDesc="1季度("_EHItemMax_"次)"
				Set DateItemCode=13
			}ElseIf (Month<7){
				Set DateUnitDesc="2季度("_EHItemMax_"次)"
				Set DateItemCode=14
			}ElseIf (Month<10){
				Set DateUnitDesc="3季度("_EHItemMax_"次)"
				Set DateItemCode=15
			}Else{
				Set DateUnitDesc="4季度("_EHItemMax_"次)"
				Set DateItemCode=16
			}
		}
		If (EHItemUnitDesc["半年"){
			If (Month<6){
				Set DateUnitDesc="上半年("_EHItemMax_"次)"
				Set DateItemCode=17
			}Else{
				Set DateUnitDesc="下半年("_EHItemMax_"次)"
				Set DateItemCode=18
			}
		}
		If (EHItemUnitDesc="项/年"){
			Set DateUnitDesc="全年("_EHItemMax_"次)"
			Set DateItemCode=19
		}
		//Set DateItemID = ##Class(DHCHAI.BTS.DictionarySrv).GetIDByCode("EHPlanDateItem",DateItemCode,"")
		Set DateItemID = ##class(DHCHAI.BT.Dictionary).GetIDByCode("EHPlanDateItem",DateItemCode)
		
		Set DescList=$g(^TMP($zn,$j,NIndex,ApplyLocID1,EvItemID,"DescList"))
		Set ^TMP($zn,$j,NIndex,ApplyLocID1,EvItemID,"DescList")=DescList_","_DateUnitDesc
		
		Set DescIDList=$g(^TMP($zn,$j,NIndex,ApplyLocID1,EvItemID,"DescIDList"))
		Set ^TMP($zn,$j,NIndex,ApplyLocID1,EvItemID,"DescIDList")=DescIDList_","_DateItemID
		
		Set IDList=$g(^TMP($zn,$j,NIndex,ApplyLocID1,EvItemID,"IDList"))
		Set ^TMP($zn,$j,NIndex,ApplyLocID1,EvItemID,"IDList")=IDList_","_xID
		
		Set ^TMP($zn,$j,NIndex,ApplyLocID1,EvItemID)=$lb(xID,EvItemID,EvItemDesc,EHPlanDate,ApplyLocID1,ApplyLocDesc1,EHItemMax,EHItemMin,EHItemUnitID,EHItemUnitDesc,EHNote,IsActive,IsActDesc)	
	}
	Set xLoc=""
	For {
		Set xLoc=$o(^TMP($zn,$j,NIndex,xLoc))
		Quit:xLoc=""
		Set xItem=""
		For {
			Set xItem=$o(^TMP($zn,$j,NIndex,xLoc,xItem))
			Quit:xItem=""
			Set Data=$g(^TMP($zn,$j,NIndex,xLoc,xItem))
			Continue:Data=""
			Set IDList=$g(^TMP($zn,$j,NIndex,xLoc,xItem,"IDList"))
			Set:IDList'="" IDList=$e(IDList,2,$l(IDList))
			Set DescList=$g(^TMP($zn,$j,NIndex,xLoc,xItem,"DescList"))
			Set:DescList'="" DescList=$e(DescList,2,$l(DescList))
			Set DescIDList=$g(^TMP($zn,$j,NIndex,xLoc,xItem,"DescIDList"))
			Set:DescIDList'="" DescIDList=$e(DescIDList,2,$l(DescIDList))
			
			Set ^CacheTemp(repid,ind)=Data_$lb(IDList,DescList,DescIDList)
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryEnviHyLocItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyLocItemsExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEnviHyLocItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyLocItemsExecute ]
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

/// Creator：     zhangdc
/// CreatDate：   2019-11-06
/// Description:  根据科室名称查询科室列表
/// Table：       DHCHAI.BT.Location
/// Input：       aHospIDs:DHCHAI.BT.Hospital.ID串，多个医院用"|"连接
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyLocItemsSrv","QryLoc","","","","","","","")
Query QryLoc(aHospIDs As %String, aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "", aIsActive As %String = "", aLocID As %String = "", locDesc As %String = "") As %Query(ROWSPEC = "ID:%String,LocCode:%String,LocDesc:%String,LocDesc2:%String,LocTypeDr:%String,LocTypeCode:%String,LocTypeDesc:%String,LocCateDr:%String,LocCateCode:%String,LocCateDesc:%String,GroupDr:%String,GroupCode:%String,GroupDesc:%String,HospDr:%String,HospCode:%String,HospDesc:%String,IsOPER:%String,IsICU:%String,IsNICU:%String,ICUTpDr:%String,ICUTpCode:%String,ICUTpDesc:%String,XCode:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUserDesc:%String,ParLocDr:%String") [ SqlProc ]
{
}

ClassMethod QryLocExecute(ByRef qHandle As %Binary, aHospIDs As %String, aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "", aIsActive As %String = "", aLocID As %String = "", locDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")	 
	Set aLocCate=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocCate,"|")	 
	Set xHospID=0
	For {
		Set xHospID=$o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID))
		Quit:xHospID=""
	    Continue:(aHospIDs'="")&($listfind(aHospIDs,xHospID)<1)
	    
		Set xID=0
		For {
			Set xID = $o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID,xID))
			Quit:xID=""
			Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xID)
			Continue:'$isobject(objLoc)
			Continue:(aLocID'="")&&(xID'=aLocID)	//增加科室过滤
			Set (LocCode,LocDesc,LocDesc2,LocTypeCode,LocTypeDesc,LocCateCode,LocCateDesc,GroupCode,GroupDesc)=""
			Set (HospCode,HospDesc,IsICU,IsNICU,ICUTpCode,ICUTpDesc,IsActive,ActDate,ActTime,ActUserCode,ActUserDesc)=""
			Set LocCode	    = objLoc.BTCode
			Set LocDesc	    = ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(objLoc.BTDesc)
			Set LocDesc2	= ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(objLoc.BTDesc2)
			Continue:(aIsActive'="")&&((LocDesc["停用")||(LocDesc2["停用"))		
			Set:LocDesc2="" LocDesc2 = LocDesc
			Set:$p(LocDesc2,"-",2)'="" LocDesc2=$p(LocDesc2,"-",2)
			Continue:(aAlias'="")&&((LocCode'[aAlias)&&(LocDesc'[aAlias)&&(LocDesc2'[aAlias))
			Continue:(locDesc'="")&&((LocDesc2[$tr(locDesc," ",""))=0)
		
			Set LocTypeDr="",LocTypeCode="",LocTypeDesc=""
			If $IsObject(objLoc.BTTypeDr) {
				Set LocTypeDr 	= objLoc.BTTypeDr.%Id()
				Set LocTypeCode	= objLoc.BTTypeDr.BTCode
				Set LocTypeDesc	= objLoc.BTTypeDr.BTDesc
			}
			Continue:(aLocType'="")&&(aLocType'=LocTypeCode)
			Set LocCateDr="",LocCateCode="",LocCateDesc=""
			If $IsObject(objLoc.BTCateDr) {
				Set LocCateDr 	= objLoc.BTCateDr.%Id()
				Set LocCateCode	= objLoc.BTCateDr.BTCode
				Set LocCateDesc	= objLoc.BTCateDr.BTDesc
			}
			Continue:(aLocCate'="")&&($listfind(aLocCate,LocCateCode)<1)
			Set GroupDr="",GroupCode="",GroupDesc=""
			If $IsObject(objLoc.BTGroupDr) {
				Set GroupDr 	= objLoc.BTGroupDr.%Id()
				Set GroupCode	= objLoc.BTGroupDr.BTCode
				Set GroupDesc	= objLoc.BTGroupDr.BTDesc	
			}
			
		    Set LocHospDr="",HospCode="",HospDesc=""
			If $IsObject(objLoc.BTHospDr) {
				Set LocHospDr 	= objLoc.BTHospDr.%Id()
				Set HospCode	= objLoc.BTHospDr.BTCode
				Set HospDesc	= objLoc.BTHospDr.BTDesc
			}
			
			Set IsOPER	    = objLoc.BTIsOPER
			Set IsOPER=$s(IsOPER=1:"是",IsOPER=0:"否",1:"是")
			Set IsICU	    = objLoc.BTIsICU
			Set IsICU=$s(IsICU=1:"是",IsICU=0:"否",1:"是")
			Set IsNICU	    = objLoc.BTIsNICU
			Set IsNICU=$s(IsNICU=1:"是",IsNICU=0:"否",1:"是")
			
		    Set ICUTpDr="",ICUTpCode="",ICUTpDesc=""
			If $IsObject(objLoc.BTICUTpDr) {
				Set ICUTpDr = objLoc.BTICUTpDr.%Id()
				Set ICUTpCode	= objLoc.BTICUTpDr.BTCode
				Set ICUTpDesc	= objLoc.BTICUTpDr.BTDesc
			}
			Set XCode = objLoc.BTXCode
			Set IsActive	= objLoc.BTIsActive
			Continue:(aIsActive'="")&&(IsActive'=aIsActive)
			Set IsActive=$s(IsActive=1:"是",IsActive=0:"否",1:"是")	
			Set ActDate     = objLoc.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime     = objLoc.BTActTime
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			
		    Set ActUserCode="",ActUserDesc=""
			If $IsObject(objLoc.BTActUserDr) {
				Set ActUserCode = objLoc.BTActUserDr.BTCode
				Set ActUserDesc = objLoc.BTActUserDr.BTDesc
			}
			Set ParLocDr=""
			If $IsObject(objLoc.BTParLocDr) {
				Set ParLocDr=objLoc.BTParLocDr.%Id()
			}
			
			Set Data=$lb(xID,LocCode,LocDesc,LocDesc2,LocTypeDr,LocTypeCode,LocTypeDesc,LocCateDr,LocCateCode,LocCateDesc,GroupDr,GroupCode,GroupDesc,LocHospDr,HospCode,HospDesc,IsOPER,IsICU,IsNICU,ICUTpDr,ICUTpCode,ICUTpDesc,XCode,IsActive,ActDate,ActTime,ActUserCode,ActUserDesc,ParLocDr)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2021-01-08
/// Description:  导入基础字典
/// w ##Class(DHCHAI.IRS.EnviHyLocItemsSrv).ImportDic("^1^儿外创伤科医疗单元^Ⅱ类环境(<=30㎡)空气监测^Ⅰ类环境^项/季度^1^1^2020-01-01^2020-04-01^2020-07-01^2020-10-01","^")
ClassMethod ImportDic(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return

	Set strLocDr      = $p(aInputStr,aSeparate,2)
	Set strLocDesc    = $p(aInputStr,aSeparate,3)
	Set strItem       = $p(aInputStr,aSeparate,4)
	Set strItemType   = $p(aInputStr,aSeparate,5)
	Set strMontiTimes = $p(aInputStr,aSeparate,6)
	Set strItemMin    = $p(aInputStr,aSeparate,7)
	Set strItemMax    = $p(aInputStr,aSeparate,8)
	Set str1MDate     = +$p(aInputStr,aSeparate,9)
	Set str2MDate     = +$p(aInputStr,aSeparate,10)
	Set str3MDate     = +$p(aInputStr,aSeparate,11)
	Set str4MDate     = +$p(aInputStr,aSeparate,12)
	Set str5MDate     = +$p(aInputStr,aSeparate,13)
	Set str6MDate     = +$p(aInputStr,aSeparate,14)
	Set str7MDate     = +$p(aInputStr,aSeparate,15)
	Set str8MDate     = +$p(aInputStr,aSeparate,16)
	Set str9MDate     = +$p(aInputStr,aSeparate,17)
	Set str10MDate    = +$p(aInputStr,aSeparate,18)
	Set str11MDate    = +$p(aInputStr,aSeparate,19)
	Set str12MDate    = +$p(aInputStr,aSeparate,20)
	Set strResume     = $p(aInputStr,aSeparate,21)
	
	Quit:strLocDr="" return
	Set ItemID =$o(^DHCHAI.IR.EnviHyItemI("IndexOnItemDesc",strItem,0)) 
	Quit:ItemID="" return
    Set TypeID=""
	Set xTypeID = ""
	For {
		Set xTypeID = $o(^DHCHAI.BT.DicTypeI("IdxofCode","EHItemUnit",xTypeID))
		Quit:xTypeID=""
		Set objDicType=##class(DHCHAI.BT.DicType).GetObjById(xTypeID)
		Continue:'$IsObject(objDicType)
		Set TypeID=xTypeID
	}
  	Quit:TypeID="" return
	Set MontiTimeID=""
	Set DicID=0
	For {
		Set DicID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrDesc",TypeID,strMontiTimes,DicID))
		Quit:DicID=""

		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set MontiTimeID=DicID
	}
	Quit:MontiTimeID="" return
	If (str1MDate>0){
		If (str1MDate<10){
			Set strDate=$p($zd(+$H,3),"-",1)_"-01-0"_str1MDate
		}Else{
			Set strDate=$p($zd(+$H,3),"-",1)_"-01-"_str1MDate
		}
		Set InputStr=""_aSeparate_strLocDr_aSeparate_ItemID_aSeparate_strItemMax_aSeparate_strItemMin_aSeparate_MontiTimeID_aSeparate_strDate_aSeparate_strResume_aSeparate_1
		Set return=##Class(DHCHAI.IR.EnviHyLocItems).Update(InputStr,aSeparate)
	}
	If (str2MDate>0){
		If (str2MDate<10){
			Set strDate=$p($zd(+$H,3),"-",1)_"-02-0"_str2MDate
		}Else{
			Set strDate=$p($zd(+$H,3),"-",1)_"-02-"_str2MDate
		}
		Set InputStr=""_aSeparate_strLocDr_aSeparate_ItemID_aSeparate_strItemMax_aSeparate_strItemMin_aSeparate_MontiTimeID_aSeparate_strDate_aSeparate_strResume_aSeparate_1
		Set return=##Class(DHCHAI.IR.EnviHyLocItems).Update(InputStr,aSeparate)
	}
	If (str3MDate>0){
		If (str3MDate<10){
			Set strDate=$p($zd(+$H,3),"-",1)_"-03-0"_str3MDate
		}Else{
			Set strDate=$p($zd(+$H,3),"-",1)_"-03-"_str3MDate
		}
		Set InputStr=""_aSeparate_strLocDr_aSeparate_ItemID_aSeparate_strItemMax_aSeparate_strItemMin_aSeparate_MontiTimeID_aSeparate_strDate_aSeparate_strResume_aSeparate_1
		Set return=##Class(DHCHAI.IR.EnviHyLocItems).Update(InputStr,aSeparate)
	}
	If (str4MDate>0){
		If (str4MDate<10){
			Set strDate=$p($zd(+$H,3),"-",1)_"-04-0"_str4MDate
		}Else{
			Set strDate=$p($zd(+$H,3),"-",1)_"-04-"_str4MDate
		}
		Set InputStr=""_aSeparate_strLocDr_aSeparate_ItemID_aSeparate_strItemMax_aSeparate_strItemMin_aSeparate_MontiTimeID_aSeparate_strDate_aSeparate_strResume_aSeparate_1
		Set return=##Class(DHCHAI.IR.EnviHyLocItems).Update(InputStr,aSeparate)
	}
	If (str5MDate>0){
		If (str5MDate<10){
			Set strDate=$p($zd(+$H,3),"-",1)_"-05-0"_str5MDate
		}Else{
			Set strDate=$p($zd(+$H,3),"-",1)_"-05-"_str5MDate
		}
		Set InputStr=""_aSeparate_strLocDr_aSeparate_ItemID_aSeparate_strItemMax_aSeparate_strItemMin_aSeparate_MontiTimeID_aSeparate_strDate_aSeparate_strResume_aSeparate_1
		Set return=##Class(DHCHAI.IR.EnviHyLocItems).Update(InputStr,aSeparate)
	}
	If (str6MDate>0){
		If (str6MDate<10){
			Set strDate=$p($zd(+$H,3),"-",1)_"-06-0"_str6MDate
		}Else{
			Set strDate=$p($zd(+$H,3),"-",1)_"-06-"_str6MDate
		}
		Set InputStr=""_aSeparate_strLocDr_aSeparate_ItemID_aSeparate_strItemMax_aSeparate_strItemMin_aSeparate_MontiTimeID_aSeparate_strDate_aSeparate_strResume_aSeparate_1
		Set return=##Class(DHCHAI.IR.EnviHyLocItems).Update(InputStr,aSeparate)
	}
	If (str7MDate>0){
		If (str7MDate<10){
			Set strDate=$p($zd(+$H,3),"-",1)_"-07-0"_str7MDate
		}Else{
			Set strDate=$p($zd(+$H,3),"-",1)_"-07-"_str7MDate
		}
		Set InputStr=""_aSeparate_strLocDr_aSeparate_ItemID_aSeparate_strItemMax_aSeparate_strItemMin_aSeparate_MontiTimeID_aSeparate_strDate_aSeparate_strResume_aSeparate_1
		Set return=##Class(DHCHAI.IR.EnviHyLocItems).Update(InputStr,aSeparate)
	}
	If (str8MDate>0){
		If (str8MDate<10){
			Set strDate=$p($zd(+$H,3),"-",1)_"-08-0"_str8MDate
		}Else{
			Set strDate=$p($zd(+$H,3),"-",1)_"-08-"_str8MDate
		}
		Set InputStr=""_aSeparate_strLocDr_aSeparate_ItemID_aSeparate_strItemMax_aSeparate_strItemMin_aSeparate_MontiTimeID_aSeparate_strDate_aSeparate_strResume_aSeparate_1
		Set return=##Class(DHCHAI.IR.EnviHyLocItems).Update(InputStr,aSeparate)
	}
	If (str9MDate>0){
		If (str9MDate<10){
			Set strDate=$p($zd(+$H,3),"-",1)_"-09-0"_str9MDate
		}Else{
			Set strDate=$p($zd(+$H,3),"-",1)_"-09-"_str9MDate
		}
		Set InputStr=""_aSeparate_strLocDr_aSeparate_ItemID_aSeparate_strItemMax_aSeparate_strItemMin_aSeparate_MontiTimeID_aSeparate_strDate_aSeparate_strResume_aSeparate_1
		Set return=##Class(DHCHAI.IR.EnviHyLocItems).Update(InputStr,aSeparate)
	}
	If (str10MDate>0){
		If (str10MDate<10){
			Set strDate=$p($zd(+$H,3),"-",1)_"-10-0"_str10MDate
		}Else{
			Set strDate=$p($zd(+$H,3),"-",1)_"-10-"_str10MDate
		}
		Set InputStr=""_aSeparate_strLocDr_aSeparate_ItemID_aSeparate_strItemMax_aSeparate_strItemMin_aSeparate_MontiTimeID_aSeparate_strDate_aSeparate_strResume_aSeparate_1
		Set return=##Class(DHCHAI.IR.EnviHyLocItems).Update(InputStr,aSeparate)
	}
	If (str11MDate>0){
		If (str11MDate<10){
			Set strDate=$p($zd(+$H,3),"-",1)_"-11-0"_str11MDate
		}Else{
			Set strDate=$p($zd(+$H,3),"-",1)_"-11-"_str11MDate
		}
		Set InputStr=""_aSeparate_strLocDr_aSeparate_ItemID_aSeparate_strItemMax_aSeparate_strItemMin_aSeparate_MontiTimeID_aSeparate_strDate_aSeparate_strResume_aSeparate_1
		Set return=##Class(DHCHAI.IR.EnviHyLocItems).Update(InputStr,aSeparate)
	}
	If (str12MDate>0){
		If (str12MDate<10){
			Set strDate=$p($zd(+$H,3),"-",1)_"-12-0"_str12MDate
		}Else{
			Set strDate=$p($zd(+$H,3),"-",1)_"-12-"_str12MDate
		}
		Set InputStr=""_aSeparate_strLocDr_aSeparate_ItemID_aSeparate_strItemMax_aSeparate_strItemMin_aSeparate_MontiTimeID_aSeparate_strDate_aSeparate_strResume_aSeparate_1
		Set return=##Class(DHCHAI.IR.EnviHyLocItems).Update(InputStr,aSeparate)
	}
	
	Quit return
}

/// Creator：     liutao
/// CreatDate：   2022-04-08
/// Description:  根据科室id和检测日期批量查询科室监测项目计划
/// Table：       DHCHAI.IR.EnviHyLocItems
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyLocItemsSrv","QryBatchEnviHyLocItems","1","2022-04-08","")
Query QryBatchEnviHyLocItems(locId As %String, aDate As %String, ItemID As %String = "") As %Query(ROWSPEC = "xID:%String,EvItemID:%String,EvItemDesc:%String,EHPlanDate:%String,ApplyLocID:%String,ApplyLocDesc:%String,EHIsObjNull:%String,EHItemMax:%String,EHItemMin:%String,EHItemUnitID:%String,EHItemUnitDesc:%String,EHNote:%String,IsActive:%String,IsActiveDesc:%String,EHCenterNum:%String,EHSurroundNum:%String,EHReferToNum:%String,IDList:%String,DescList:%String,DescIDList:%String") [ SqlProc ]
{
}

ClassMethod QryBatchEnviHyLocItemsExecute(ByRef qHandle As %Binary, locId As %String, aDate As %String, ItemID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	
	Set NIndex="QryBatchEnviHyLocItems"
	Kill ^TMP($zn,$j,NIndex)
	Set IDList=""
	Set DescList="",DescIDList=""
	
	
	Set xID = ""
	For {
		Set xID =$o(^DHCHAI.IR.EnviHyLocItemsI("IdxLocationDr",locId,xID))
		Quit:xID=""
		
		Set obj = ##class(DHCHAI.IR.EnviHyLocItems).GetObjById(xID)
		Continue:'$IsObject(obj)
		
		//申请科室
		Set ApplyLocID="",ApplyLocDesc="",ApplyLocID1="",ApplyLocDesc2=""
		If $IsObject(obj.EHLocationDr){
			Set ApplyLocID1   = obj.EHLocationDr.%Id()
			Set ApplyLocDesc1 = obj.EHLocationDr.BTDesc

			if (locId = ApplyLocID1){
				Set ApplyLocID = ApplyLocID1
				Set ApplyLocDesc = ApplyLocDesc1
			}
			Continue:(locId'="")&&(ApplyLocDesc="")
		}
		Continue:'$IsObject(obj.EHItemDr)
		//监测项目
		Set EvItemID="",EvItemDesc="",EHIsObjNull=""
		If $IsObject(obj.EHItemDr){
			Set EvItemID   = obj.EHItemDr.%Id()
			Set EvItemDesc = obj.EHItemDr.EHItemDesc
			Set EHIsObjNull= obj.EHItemDr.EHIsObjNull
		}
		Continue:(ItemID'="")&&(ItemID'=EvItemID)
		//限定单位
		Set EHItemUnitID="",EHItemUnitDesc=""
		If $IsObject(obj.EHItemUnit){
			Set EHItemUnitID   = obj.EHItemUnit.%Id()
			Set EHItemUnitDesc = obj.EHItemUnit.BTDesc
		}
		Continue:EHItemUnitDesc=""
		If $IsObject(obj.EHItemDr){
			Set EHCenterNum = obj.EHItemDr.EHCenterNum
			Set EHSurroundNum = obj.EHItemDr.EHSurroundNum
			Set EHReferToNum = obj.EHItemDr.EHReferToNum
		}
		Continue:(EHCenterNum="")||(EHSurroundNum="")||(EHReferToNum="")
		Set EHPlanDate="",EHItemMax="",EHItemMin="",EHNote=""
		Set EHPlanDate  = obj.EHPlanDate
		Set:EHPlanDate'="" EHPlanDate=$zd(EHPlanDate,3)
		Set EHItemMax   = obj.EHItemMax
		Set EHItemMin   = obj.EHItemMin
		Set EHNote      = obj.EHNote
		Set IsActive 	= obj.EHIsActive
		
		
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set Month=+$p(EHPlanDate,"-",2)
		Set aMonth=+$p(aDate,"-",2)
		Set DateItemCode="",DateUnitDesc=""
		If (EHItemUnitDesc["月"){
			Set DateUnitDesc=Month_"月("_EHItemMax_"次)"
			Set DateItemCode=Month
			Continue:aMonth'=Month
		}
		If (EHItemUnitDesc["季度"){
			If (Month<4){ //一季度
				Set DateUnitDesc="1季度("_EHItemMax_"次)"
				Set DateItemCode=13
				Continue:(aMonth>3)
				
			}ElseIf (Month<7){
				Set DateUnitDesc="2季度("_EHItemMax_"次)"
				Set DateItemCode=14
				Continue:(aMonth<4)||(aMonth>6)
				
			}ElseIf (Month<10){
				Set DateUnitDesc="3季度("_EHItemMax_"次)"
				Set DateItemCode=15
				Continue:(aMonth<7)||(aMonth>9)
				
			}Else{
				Set DateUnitDesc="4季度("_EHItemMax_"次)"
				Set DateItemCode=16
				Continue:(aMonth<10)||(aMonth>12)
			}
		}
		If (EHItemUnitDesc["半年"){
			If (Month<7){
				Set DateUnitDesc="上半年("_EHItemMax_"次)"
				Set DateItemCode=17
				Continue:(aMonth<1)||(aMonth>6)
			}Else{
				Set DateUnitDesc="下半年("_EHItemMax_"次)"
				Set DateItemCode=18
				Continue:(aMonth<7)||(aMonth>12)
			}
		}
		If (EHItemUnitDesc="项/年"){
			Set DateUnitDesc="全年("_EHItemMax_"次)"
			Set DateItemCode=19
			Continue:(aMonth<1)||(aMonth>12)
		}
		//Set DateItemID = ##Class(DHCHAI.BTS.DictionarySrv).GetIDByCode("EHPlanDateItem",DateItemCode,"")
		Set DateItemID = ##class(DHCHAI.BT.Dictionary).GetIDByCode("EHPlanDateItem",DateItemCode)
		
		Set DescList=$g(^TMP($zn,$j,NIndex,ApplyLocID1,EvItemID,"DescList"))
		Set ^TMP($zn,$j,NIndex,ApplyLocID1,EvItemID,"DescList")=DescList_","_DateUnitDesc
		
		Set DescIDList=$g(^TMP($zn,$j,NIndex,ApplyLocID1,EvItemID,"DescIDList"))
		Set ^TMP($zn,$j,NIndex,ApplyLocID1,EvItemID,"DescIDList")=DescIDList_","_DateItemID
		
		Set IDList=$g(^TMP($zn,$j,NIndex,ApplyLocID1,EvItemID,"IDList"))
		Set ^TMP($zn,$j,NIndex,ApplyLocID1,EvItemID,"IDList")=IDList_","_xID
		
		Set ^TMP($zn,$j,NIndex,ApplyLocID1,EvItemID)=$lb(xID,EvItemID,EvItemDesc,EHPlanDate,ApplyLocID1,ApplyLocDesc1,EHIsObjNull,EHItemMax,EHItemMin,EHItemUnitID,EHItemUnitDesc,EHNote,IsActive,IsActDesc,EHCenterNum,EHSurroundNum,EHReferToNum)	
		
	}
	Set xLoc=""
	For {
		Set xLoc=$o(^TMP($zn,$j,NIndex,xLoc))
		Quit:xLoc=""
		Set xItem=""
		For {
			Set xItem=$o(^TMP($zn,$j,NIndex,xLoc,xItem))
			Quit:xItem=""
			Set Data=$g(^TMP($zn,$j,NIndex,xLoc,xItem))
			Continue:Data=""
			Set IDList=$g(^TMP($zn,$j,NIndex,xLoc,xItem,"IDList"))
			Set:IDList'="" IDList=$e(IDList,2,$l(IDList))
			Set DescList=$g(^TMP($zn,$j,NIndex,xLoc,xItem,"DescList"))
			Set:DescList'="" DescList=$e(DescList,2,$l(DescList))
			Set DescIDList=$g(^TMP($zn,$j,NIndex,xLoc,xItem,"DescIDList"))
			Set:DescIDList'="" DescIDList=$e(DescIDList,2,$l(DescIDList))
			
			Set ^CacheTemp(repid,ind)=Data_$lb(IDList,DescList,DescIDList)
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryBatchEnviHyLocItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyLocItemsExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBatchEnviHyLocItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyLocItemsExecute ]
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
