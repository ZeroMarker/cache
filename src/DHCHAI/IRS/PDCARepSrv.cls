/// 名称: DHCHAI.IRS.PDCARepSrv
/// 描述: PDCA报告服务
/// 编写者：ShenC
/// 编写日期: 2022-08-22
Class DHCHAI.IRS.PDCARepSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2022-09-26
/// Description:  查询PDCA项目类型
/// Table：       DHCHAI.IR.PDCARep
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.PDCARepSrv","QryPAItemType")
Query QryPAItemType(aItemType As %String = "") As %Query(ROWSPEC = "ID:%String,ItemType:%String") [ SqlProc ]
{
}

ClassMethod QryPAItemTypeExecute(ByRef qHandle As %Binary, aItemType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set Count=0
	Set xItemType=""
	For{
		Set xItemType=$o(^MA.HAI.IR.PDCARepI("IndexItemType",xItemType))
		Quit:xItemType=""
		Continue:(aItemType'="")&&(aItemType'=xItemType)
		
		Set Count=Count+1
		Set Data=$lb(Count,xItemType)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryPAItemTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPAItemTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPAItemTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPAItemTypeExecute ]
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

/// Creator：     SehnC
/// CreatDate：   2022-09-26
/// Description:  保存PDCA报告
/// Input：       aPARep：主表信息
/// 			  aPARepExt：扩展表
/// 			  aPARepLoc：科室
/// 			  aPARepLog：日志
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.PDCARepSrv).SavePAReport()
ClassMethod SavePAReport(aPARep As %String, aPARepExts As %Text, aPARepLocs As %String, aPARepLog As %String, aSaveType As %String)
{
	Set return = ""
	New (aPARep,aPARepExts,aPARepLocs,aPARepLog,aSaveType)
	TStart
	// 主表信息
	Set return = -1
	Set ReportID  = $p(aPARep,$c(1),1)
	
    Set Flag=##Class(DHCHAI.IR.PDCARep).Update(aPARep,$c(1))
	If Flag=-1 TRollback				//失败回滚
	Quit:(+Flag)<1 return
	Set ReportID=+Flag
	//保存扩展表
	Set return = -2
	For ind = 1:1:$length(aPARepExts,$c(2)){
		Set aPARepExt = $p(aPARepExts,$c(2),ind)
		Continue:aPARepExt="" 
		s ^dd1=aPARepExt
	    Set $p(aPARepExt,$c(1),1)= ReportID
	    s ^dd2=aPARepExt
		Set Flag=##Class(DHCHAI.IR.PDCARepExt).Update(aPARepExt,$c(1))
		If Flag=-1 TRollback
		Quit:(+Flag)<1  
	}
	//保存科室表
	Set return = -3
	For ind = 1:1:$length(aPARepLocs,$c(2)){
		Set aPARepLoc = $p(aPARepLocs,$c(2),ind)
		Continue:aPARepLoc="" 
		
	    Set $p(aPARepLoc,$c(1),1)= ReportID
	    //保存P
	    Set:aSaveType="1" Flag=##Class(DHCHAI.IR.PDCARepLoc).UpdateP(aPARepLoc,$c(1))
	    //保存D
	    Set:aSaveType="2" Flag=##Class(DHCHAI.IR.PDCARepLoc).UpdateDo(aPARepLoc,$c(1))
	    //保存CA
	    Set:aSaveType="3" Flag=##Class(DHCHAI.IR.PDCARepLoc).UpdateCA(aPARepLoc,$c(1))
		
		If Flag=-1 TRollback
		Quit:(+Flag)<1  
	}
	// 保存日志表
	Set return = -4
	Set $p(aPARepLog,$c(1),1)=ReportID
	
	Set Flag=##Class(DHCHAI.IR.PDCARepLog).Update(aPARepLog,$c(1))
	If Flag=-1 TRollback
	Quit:(+Flag)<1 return
    
    TCommit
    
	Set return = ReportID	
	Quit return
}

/// Creator：     SehnC
/// CreatDate：   2022-09-26
/// Description:  获取PDCA报告关联科室
/// Input：       aRepID：报告ID
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.PDCARepSrv","QryRARepLocList","")
Query QryRARepLocList(aRepID As %String) As %Query(ROWSPEC = "SubID:%String,ID:%String,LocCode:%String,LocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRARepLocListExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aRepID="" $$$OK
	
	Set xIndex=""
	For{
		Set xIndex=$o(^MA.HAI.IR.PDCARepI("Loc","IndexHistIndex",aRepID,0,xIndex))
		Quit:xIndex=""
		
		
		Set xID=""
		For{
			Set xID=$o(^MA.HAI.IR.PDCARepI("Loc","IndexHistIndex",aRepID,0,xIndex,xID))
			Quit:xID=""
			
			Set RepData=$g(^MA.HAI.IR.PDCARepD(aRepID,"Loc",xID))
			Continue:RepData=""
			Set (LocID,LocCode,LocDesc)=""
			Set LocID=$lg(RepData,2)
			If (LocID'=""){
				Set LocData=$g(^DHCHAI.BT.LocationD(LocID))
				If (LocData'=""){
					Set LocCode=$lg(LocData,2)
					Set LocDesc=$lg(LocData,3)
				}
			}	
		
			Set Data=$lb(xID,LocID,LocCode,LocDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	
		}
	}
	Quit $$$OK
}

ClassMethod QryRARepLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRARepLocListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRARepLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRARepLocListExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2022-09-19
/// Description:  5->查询PDCA报告列表
/// Table：       DHCHAI.BT.Location
///               aUserID  : 用户ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.PDCARepSrv","QryPARepList","1","1","2022-10-01","2022-10-17","1")
Query QryPARepList(aHospIDs As %String = "", aDateType As %String = "", aDateFrom As %String = "", aDateTo As %String = "", aStatus As %String = "") As %Query(ROWSPEC = "RepID:%String,ItemType:%String,ItemDesc:%String,IndexID:%String,IndexDesc:%String,RegDate:%String,RegTime:%String,RegLocID:%String,RegLocDesc:%String,RegUserID:%String,RegUserDesc:%String,TargetVal:%String,ModTypeID:%String,SubID:%String,PlanLocID:%String,PlanLocCode:%String,PlanLocDesc:%String,PlanLocUserID:%String,PlanLocUserCode:%String,PlanLocUserDesc:%String,PlanAdminUserID:%String,PlanAdminUserCode:%String,PlanAdminUserDesc:%String,DoASttDate:%String,DoPEndDate:%String,DoUserID:%String,DoUserCode:%String,DoUserDesc:%String,DoAEndDate:%String,AssessID:%String,AssessDesc:%String,PALocStatus:%String") [ SqlProc ]
{
}

ClassMethod QryPARepListExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateType As %String = "", aDateFrom As %String = "", aDateTo As %String = "", aStatus As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	//循环PDCA报告表
 	Set xID=""
 	For{
		Set xID=$o(^MA.HAI.IR.PDCARepD(xID))
		Quit:xID=""
		
		//取报告基本信息
		Set RepData=$g(^MA.HAI.IR.PDCARepD(xID))
		Continue:RepData=""
		
		Set ItemType=$lg(RepData,2)			//项目类型
		Set ItemDesc=$lg(RepData,3)			//项目名称
		Set (IndexID,IndexDesc)=""			//指标类型
		Set IndexID=$lg(RepData,4)			
		If (IndexID'=""){
			Set IndexData=$g(^CT.MA.HAI.IR.PDCAIndexBaseD(IndexID))
			If (IndexData'=""){
				Set IndexDesc=$lg(IndexData,3)
			}
		}
		Set RegDate=$lg(RepData,5)			//登记日期
		//过滤开始结束日期[按登记日期]
		Continue:(aDateType="1")&&(RegDate<aDateFrom)||(RegDate>aDateTo)
		
		Set:RegDate'="" RegDate=$zd(RegDate,3)
		Set RegTime=$lg(RepData,6)			//登记时间
		Set:RegTime'="" RegTime=$zt(RegTime,1)
		Set (RegLocID,RegLocDesc)=""		//登记科室
		Set RegLocID=$lg(RepData,7)			
		If (RegLocID'=""){
			Set RegLocData=$g(^DHCHAI.BT.LocationD(RegLocID))
			If (RegLocData'=""){
				Set RegLocDesc=$lg(RegLocData,3)
			}
		}
		Set (RegUserID,RegUserDesc)=""		//登记人
		Set RegUserID=$lg(RepData,8)
		If (RegUserID'=""){
			Set RegUserData=$g(^DHCHAI.BT.SysUserD(RegUserID))
			If (RegUserData'=""){
				Set RegUserDesc=$lg(RegUserData,3)
			}
		}
		Set StatusID=$lg(RepData,9)			//报告状态
		If (StatusID'=""){
			Set DicData=$g(^DHCHAI.BT.DictionaryD(StatusID))
			If (DicData'=""){
				Set DicDesc=$lg(DicData,3)
				Continue:DicDesc["删除"
			}
		}
		
		Set TargetVal=$lg(RepData,10)		//目标值
		Set ModTypeID=$lg(RepData,11)		//模板类型
		//报告基本信息
		Set RepData=$lb(xID,ItemType,ItemDesc,IndexID,IndexDesc,RegDate,RegTime,RegLocID,RegLocDesc,RegUserID,RegUserDesc,TargetVal,ModTypeID)
		
		//循环子表->科室表
		Set xSubID=""
		For{
			Set xSubID=$o(^MA.HAI.IR.PDCARepD(xID,"Loc",xSubID))
			Quit:xSubID=""
				
			Set PALocData=$g(^MA.HAI.IR.PDCARepD(xID,"Loc",xSubID))
			Continue:PALocData=""
			//是否历史报告
			Set IsHist=$lg(PALocData,16)
			Continue:IsHist'=0
			//P-整改科室/病区	
			Set (PlanLocID,PlanLocCode,PlanLocDesc)=""						
			Set PlanLocID=$lg(PALocData,2)	
			If (PlanLocID'=""){
				Set PlanLocData=$g(^DHCHAI.BT.LocationD(PlanLocID))
				If (PlanLocData'=""){
					Set PlanLocCode=$lg(PlanLocData,2)
					Set PlanLocDesc=$lg(PlanLocData,3)
					
					Set PlanHospID=$li(PlanLocData,8)
					Continue:(aHospIDs'="")&&(("|"_aHospIDs_"|")'[("|"_PlanHospID_"|"))		//过滤院区
				}
			}	
			//P-整改科室/病区负责人	
			Set (PlanLocUserID,PlanLocUserCode,PlanLocUserDesc)=""			
			Set PlanLocUserID=$lg(PALocData,3)
			If (PlanLocUserID'=""){
				Set PlanLocUserData=$g(^DHCHAI.BT.SysUserD(PlanLocUserID))
				If (PlanLocUserData'=""){
					Set PlanLocUserCode=$lg(PlanLocUserData,2)
					Set PlanLocUserDesc=$lg(PlanLocUserData,3)
				}
			}	
			//P-院感科负责人
			Set (PlanAdminUserID,PlanAdminUserCode,PlanAdminUserDesc)=""	
			Set PlanAdminUserID=$lg(PALocData,4)
			If (PlanAdminUserID'=""){
				Set PlanAdminUserData=$g(^DHCHAI.BT.SysUserD(PlanAdminUserID))
				If (PlanAdminUserData'=""){
					Set PlanAdminUserCode=$lg(PlanAdminUserData,2)
					Set PlanAdminUserDesc=$lg(PlanAdminUserData,3)
				}
			}
			//D-整改实际开始日期
			Set DoASttDate=$lg(PALocData,6)
			//过滤开始结束日期[按整改日期]
			Continue:(aDateType="2")&&(DoASttDate<aDateFrom)||(DoASttDate>aDateTo)
			Set:DoASttDate'="" DoASttDate=$zd(DoASttDate,3)
			//D-整改预计结束日期
			Set DoPEndDate=$lg(PALocData,7)
			Set:DoPEndDate'="" DoPEndDate=$zd(DoPEndDate,3)
			//D-提交人
			Set (DoUserID,DoUserCode,DoUserDesc)=""	
			Set DoUserID=$lg(PALocData,8)
			If (DoUserID'=""){
				Set DoUserData=$g(^DHCHAI.BT.SysUserD(DoUserID))
				If (DoUserData'=""){
					Set DoUserCode=$lg(DoUserData,2)
					Set DoUserDesc=$lg(DoUserData,3)
				}
			}
			//D-整改实际结束日期
			Set DoAEndDate=$lg(PALocData,10)
			Set:DoAEndDate'="" DoAEndDate=$zd(DoAEndDate,3)
			//A-效果评价
			Set (AssessID,AssessDesc)=""
			Set AssessID=$lg(PALocData,14)
			If (AssessID'=""){
				Set AssessData=$g(^DHCHAI.BT.DictionaryD(AssessID))
				If (AssessData'=""){
					Set AssessDesc=$lg(AssessData,3)
				}
			}
			Set PALocStatus="待整改"
			Set:DoASttDate'="" PALocStatus="正在整改"
			Set:AssessID'="" PALocStatus="完成整改"
			//过滤报告状态
			Continue:(aStatus="1")&&(PALocStatus'="待整改")
			Continue:(aStatus="2")&&(PALocStatus'="正在整改")
			Continue:(aStatus="3")&&(PALocStatus'="完成整改")
				
			Set Data=RepData_$lb(xSubID,PlanLocID,PlanLocCode,PlanLocDesc,PlanLocUserID,PlanLocUserCode,PlanLocUserDesc,PlanAdminUserID,PlanAdminUserCode,PlanAdminUserDesc,DoASttDate,DoPEndDate,DoUserID,DoUserCode,DoUserDesc,DoAEndDate,AssessID,AssessDesc,PALocStatus)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}
 	
	Quit $$$OK
}

ClassMethod QryPARepListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPARepListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPARepListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPARepListExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  1->取PDCA报告基本信息
/// Table：       DHCHAI.IR.PDCARepLoc
/// Input：       aRepID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.PDCARepSrv).GetPARep(13)
ClassMethod GetPARep(aRepID As %String) As %String
{
	New (aRepID)
	Quit:aRepID="" ""
	
	//取报告基本信息
	Set RepData=$g(^MA.HAI.IR.PDCARepD(aRepID))
	Quit:RepData="" ""
	
	Set ItemType=$lg(RepData,2)								//项目类型->ID
	Set ItemDesc=$lg(RepData,3)								//项目类型->名称
	Set ItemIndexID=$lg(RepData,4)							//关联指标->ID
	Quit:ItemIndexID="" ""
	Set IndexData=$g(^CT.MA.HAI.IR.PDCAIndexBaseD(ItemIndexID))	
	Quit:IndexData="" ""										
	Set IndexDesc=$lg(IndexData,3)							//关联指标->名称
	Set TargetVal=$lg(RepData,10)							//目标值
	Set RepName=$lg(IndexData,6)
	Set RepCsp=$lg(IndexData,9)
	
	Set RegDate=$lg(RepData,5)								//登记日期
	Set:RegDate'="" RegDate=$zd(RegDate,3)						
	Set RegTime=$lg(RepData,6)								//登记时间
	Set:RegTime'="" RegTime=$zt(RegTime,1)
	Set (RegLocID,RegLocDesc)=""							//登记科室
	Set RegLocID=$lg(RepData,7)		
	Set RegLocData=$g(^DHCHAI.BT.LocationD(RegLocID))
	If (RegLocData'=""){
		Set RegLocDesc=$lg(RegLocData,3)
		Set RegLocDesc2=$lg(RegLocData,4)
		Set:RegLocDesc2'="" RegLocDesc=RegLocDesc2
	}
	Set (RegUserID,RegUserDesc)=""							//登记人
	Set RegUserID=$lg(RepData,8)								
	Set RepUserData=$g(^DHCHAI.BT.SysUserD(RegUserID))
	If (RepUserData'=""){
		Set RegUserDesc=$lg(RepUserData,3)
	}
	Set (StatusID,StatusCode,StatusDesc)=""
	Set StatusID=$lg(RepData,9)								//报告状态
	If (StatusID'=""){
		Set StatusData=$g(^DHCHAI.BT.DictionaryD(StatusID))
		If (StatusData'=""){
			Set StatusCode=$lg(StatusData,2)
			Set StatusDesc=$lg(StatusData,3)
		}
	}
	
	Quit ItemType_"^"_ItemDesc_"^"_ItemIndexID_"^"_IndexDesc_"^"_TargetVal_"^"_RegDate_"^"_RegTime_"^"_RegLocID_"^"_RegLocDesc_"^"_RegUserID_"^"_RegUserDesc_"^"_StatusID_"^"_StatusCode_"^"_StatusDesc_"^"_RepName_"^"_RepCsp
}

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  2->取PDCA报告扩展信息
/// Table：       DHCHAI.IR.PDCARepExt
/// Input：       aRepID
/// Return：      成功：返回0，失败：返回<0的代码
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.PDCARepSrv","QryPARepExt","1")
Query QryPARepExt(aRepID As %String) As %Query(ROWSPEC = "ID:%String,ItemID:%String,ItemCode:%String,ItemDesc:%String,ResultDr:%String,ResultList:%String,ResultTxt:%String,DatCode:%String") [ SqlProc ]
{
}

ClassMethod QryPARepExtExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aRepID="" $$$OK
	
	Set xID=""
	For{  
		Set xID=$o(^MA.HAI.IR.PDCARepD(aRepID,"Ext",xID))
		Quit:xID=""
		
		Set ExtData=$g(^MA.HAI.IR.PDCARepD(aRepID,"Ext",xID))
		Continue:ExtData=""
		
		Set ItemID=$lg(ExtData,2)				//关联项目->ID
		Set ItemData=$g(^CT.MA.HAI.IR.PDCAModD($p(ItemID,"||",1),"Ext",$p(ItemID,"||",2)))
		Continue:ItemData=""
		Set ItemCode=$lg(ItemData,2)			//关联项目->Code
		Set DatID 	= $lg(ItemData,5)	   		//数据格式->ID
		Set DatCode = ""						//项目分类->Code
		If (DatID'=""){	
			Set DicData=$g(^DHCHAI.BT.DictionaryD(DatID))
	   		If (DicData'=""){ 
	   			Set DatCode = $lg(DicData,2)		//项目分类->Code
	   		}
	    }
		
		Set ItemDesc=$lg(ExtData,3)				//项目名称
		Set ResultDr=$lg(ExtData,5)				//项目值(字典、是/否、有/无)
		Set ResultList=$lg(ExtData,6)			//项目值（列表）
		Set ResultTxt=$lg(ExtData,7)			//项目值（文本、数值）
		
		Set Data=$lb(xID,ItemID,ItemCode,ItemDesc,ResultDr,ResultList,ResultTxt,DatCode)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1		
	}
	Quit $$$OK
}

ClassMethod QryPARepExtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPARepExtExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPARepExtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPARepExtExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  3->取PDCA报告科室信息
/// Table：       DHCHAI.IR.PDCARepLoc
/// Input：       aRepID
/// Return：      成功：返回0，失败：返回<0的代码
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.PDCARepSrv","QryPARepLoc","1","")
Query QryPARepLoc(aRepID As %String, aIsHist As %String = "0", aSubID As %String = "") As %Query(ROWSPEC = "ID:%String,PlanLocID:%String,PlanLocCode:%String,PlanLocDesc:%String,PlanLocUserID:%String,PlanLocUserCode:%String,PlanLocUserDesc:%String,PlanAdminUserID:%String,PlanAdminUserCode:%String,PlanAdminUserDesc:%String,PlanData:%String,DoASttDate:%String,DoPEndDate:%String,DoUserID:%String,DoUserCode:%String,DoUserDesc:%String,DoData:%String,DoAEndDate:%String,DoLocAssess:%String,CheckDate:%String,CheckUserID:%String,CheckUserCode:%String,CheckUserDesc:%String,AssessID:%String,AssessCode:%String,AssessDesc:%String,AssessIMP:%String,IsHist:%String,Index:%String,Status:%String") [ SqlProc ]
{
}

ClassMethod QryPARepLocExecute(ByRef qHandle As %Binary, aRepID As %String, aIsHist As %String = "0", aSubID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aRepID="" $$$OK
	
	Set xID=""
	For{  
		Set xID=$o(^MA.HAI.IR.PDCARepD(aRepID,"Loc",xID))
		Quit:xID=""
		Continue:(aSubID'="")&&(aSubID'=xID)
		
		Set PALocData=$g(^MA.HAI.IR.PDCARepD(aRepID,"Loc",xID))
		Continue:PALocData=""
		
		Set (PlanLocID,PlanLocCode,PlanLocDesc)=""						//P-整改科室/病区
		Set PlanLocID=$lg(PALocData,2)	
		If (PlanLocID'=""){
			Set PlanLocData=$g(^DHCHAI.BT.LocationD(PlanLocID))
			If (PlanLocData'=""){
				Set PlanLocCode=$lg(PlanLocData,2)
				Set PlanLocDesc=$lg(PlanLocData,3)
			}
		}	
		Set (PlanLocUserID,PlanLocUserCode,PlanLocUserDesc)=""			//P-整改科室/病区负责人
		Set PlanLocUserID=$lg(PALocData,3)
		If (PlanLocUserID'=""){
			Set PlanLocUserData=$g(^DHCHAI.BT.SysUserD(PlanLocUserID))
			If (PlanLocUserData'=""){
				Set PlanLocUserCode=$lg(PlanLocUserData,2)
				Set PlanLocUserDesc=$lg(PlanLocUserData,3)
			}
		}	
		Set (PlanAdminUserID,PlanAdminUserCode,PlanAdminUserDesc)=""	//P-院感科负责人
		Set PlanAdminUserID=$lg(PALocData,4)
		If (PlanAdminUserID'=""){
			Set PlanAdminUserData=$g(^DHCHAI.BT.SysUserD(PlanAdminUserID))
			If (PlanAdminUserData'=""){
				Set PlanAdminUserCode=$lg(PlanAdminUserData,2)
				Set PlanAdminUserDesc=$lg(PlanAdminUserData,3)
			}
		}	
		Set PlanData=$lg(PALocData,5)									//P-描述
		Set DoASttDate=$lg(PALocData,6)									//D-整改实际开始日期
		Set:DoASttDate'="" DoASttDate=$zd(DoASttDate,3)
		Set DoPEndDate=$lg(PALocData,7)									//D-整改预计结束日期
		Set:DoPEndDate'="" DoPEndDate=$zd(DoPEndDate,3)
		Set (DoUserID,DoUserCode,DoUserDesc)=""							//D-提交人
		Set DoUserID=$lg(PALocData,8)
		If (DoUserID'=""){
			Set DoUserData=$g(^DHCHAI.BT.SysUserD(DoUserID))
			If (DoUserData'=""){
				Set DoUserCode=$lg(DoUserData,2)
				Set DoUserDesc=$lg(DoUserData,3)
			}
		}	
		Set DoData=$lg(PALocData,9)										//D-描述
		Set DoAEndDate=$lg(PALocData,10)								//D-整改实际开始日期
		Set:DoAEndDate'="" DoAEndDate=$zd(DoAEndDate,3)
		Set DoLocAssess=$lg(PALocData,11)								//D-科室自评
		Set CheckDate=$lg(PALocData,12)									//C-检查日期
		Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
		Set (CheckUserID,CheckUserCode,CheckUserDesc)=""				//C-检查人
		Set CheckUserID=$lg(PALocData,13)
		If (CheckUserID'=""){
			Set CheckUserData=$g(^DHCHAI.BT.SysUserD(CheckUserID))
			If (CheckUserData'=""){
				Set CheckUserCode=$lg(CheckUserData,2)
				Set CheckUserDesc=$lg(CheckUserData,3)
			}
		}	
		Set (AssessID,AssessCode,AssessDesc)=""							//A-效果评价
		Set AssessID=$lg(PALocData,14)									
		If (AssessID'=""){
			Set AssessData=$g(^DHCHAI.BT.DictionaryD(AssessID))
			If (AssessData'=""){
				Set AssessCode=$lg(AssessData,2)
				Set AssessDesc=$lg(AssessData,3)
			}
		}	
		Set AssessIMP=$lg(PALocData,15)									//A-持续改进
		Set IsHist=$lg(PALocData,16)									//是否历史记录
		Continue:(aIsHist'="")&&(IsHist'=aIsHist)
		Set Index=$lg(PALocData,17)										//顺序ID
		//多语言改造
		Set:PlanLocDesc'="" PlanLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",PlanLocDesc,"User.CTLoc")
		Set PlanLocUserDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PlanLocUserDesc,"User.SSUser")
		Set PlanAdminUserDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PlanAdminUserDesc,"User.SSUser")
		Set CheckUserDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",CheckUserDesc,"User.SSUser")
		//状态(待整改,正在整改,完成整改)
		Set Status="待整改"
		Set:DoASttDate'="" Status="正在整改"
		Set:AssessID'="" Status="完成整改"
		Set Data=$lb(xID,PlanLocID,PlanLocCode,PlanLocDesc,PlanLocUserID,PlanLocUserCode,PlanLocUserDesc,PlanAdminUserID,PlanAdminUserCode,PlanAdminUserDesc,PlanData,DoASttDate,DoPEndDate,DoUserID,DoUserCode,DoUserDesc,DoData,DoAEndDate,DoLocAssess,CheckDate,CheckUserID,CheckUserCode,CheckUserDesc,AssessID,AssessCode,AssessDesc,AssessIMP,IsHist,Index,Status)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1		
	}
	Quit $$$OK
}

ClassMethod QryPARepLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPARepLocExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPARepLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPARepLocExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  4->取PDCA报告日志信息
/// Table：       DHCHAI.IR.PDCARepLog
/// Input：       aRepID
/// Return：      成功：返回0，失败：返回<0的代码
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.PDCARepSrv","QryPARepLog","1")
Query QryPARepLog(aRepID As %String) As %Query(ROWSPEC = "ID:%String,Status:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUserCode:%String,UpdateUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryPARepLogExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aRepID="" $$$OK
	
	Set xID=""
	For{  
		Set xID=$o(^MA.HAI.IR.PDCARepD(aRepID,"Log",xID))
		Quit:xID=""
		
		Set PALogData=$g(^MA.HAI.IR.PDCARepD(aRepID,"Log",xID))
		Continue:PALogData=""
		
		Set Status=$lg(PALogData,2)										//操作状态
		Set UpdateDate=$lg(PALogData,3)									//更新日期
		Set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
		Set UpdateTime=$lg(PALogData,4)									//更新时间
		Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
		Set (UpdateUserID,UpdateUserCode,UpdateUserDesc)=""				//更新人
		Set UpdateUserID=$lg(PALocData,2)	
		If (UpdateUserID'=""){
			Set UpdateUserData=$g(^DHCHAI.BT.LocationD(UpdateUserID))
			If (UpdateUserData'=""){
				Set UpdateUserCode=$lg(UpdateUserData,2)
				Set UpdateUserDesc=$lg(UpdateUserData,3)
			}
		}
		
		Set Data=$lb(xID,Status,UpdateDate,UpdateTime,UpdateUserID,UpdateUserCode,UpdateUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1		
	}
	Quit $$$OK
}

ClassMethod QryPARepLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPARepLogExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPARepLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPARepLogExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  PDCA'整改科室'重新整改
/// Table：       DHCHAI.IR.PDCARepLoc
/// Input：       aLocID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.PDCARepSrv).SetHistReg(1,23)
ClassMethod SetHistReg(aRepID As %String, aLocID As %String) As %String
{
	New (aRepID,aLocID)
	Quit:(aRepID="")||(aLocID="") ""
	
	Set xID=$o(^MA.HAI.IR.PDCARepI("Loc","IndexPlanLoc",aRepID,aLocID,"0",""))
	Quit:xID="" ""
	Set Data=$g(^MA.HAI.IR.PDCARepD(aRepID,"LOG",xID))
	Quit:Data="" ""
	Set Parref       	= aRepID
	Set Sub     	= ""
	Set PlanLocDr    	= $lg(Data,2)
	Set PlanLocUser  	= $lg(Data,3)
	Set PlanAdminUser	= $lg(Data,4)
	Set PlanData   		= $lg(Data,5)
	Set DoASttDate 		= ""
	Set DoPEndDate 		= ""
	Set DoUser 			= ""
	Set DoData 			= ""
	Set DoAEndDate		= ""
	Set DoLocAssess		= ""
	Set CheckDate		= ""
	Set CheckUse		= ""
	Set Assess			= ""
	Set AssessIMP		= ""
	Set IsHist			= "0"
	Set InputStr=Parref_"^"_Sub_"^"_PlanLocDr_"^"_PlanLocUser_"^"_PlanAdminUser_"^"_PlanData_"^"_DoASttDate_"^"_DoPEndDate
	_"^"_DoUser_"^"_DoData_"^"_DoAEndDate_"^"_DoLocAssess_"^"_CheckDate_"^"_CheckUse_"^"_Assess_"^"_AssessIMP_"^"_IsHist
	Set Flag1=##class(DHCHAI.IR.PDCARepLoc).Update(InputStr)
	Quit:Flag1<0 ""
	//将原记录置为历史记录
	Set Flag2=##class(DHCHAI.IR.PDCARepLoc).SetIsHist(aRepID_"||"_xID,"1")
	
	Quit Flag1
}

/// Creator：     ShenC
/// CreatDate：   2022-09-19
/// Description:  5->查询PDCA报告列表
/// Table：       DHCHAI.BT.Location
///               aUserID  : 用户ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.PDCARepSrv","QryPARepChart","1","1","2022-11-01","2022-11-30","","")
Query QryPARepChart(aHospIDs As %String = "", aDateType As %String = "", aDateFrom As %String = "", aDateTo As %String = "", aStatus As %String = "", aLocID As %String = "") As %Query(ROWSPEC = "ItemDesc:%String,ItemCNum:%String,ItemNum:%String,ItemRatio:%String,ItemNumCAll:%String,ItemNumAll:%String,ItemAllRatio:%String") [ SqlProc ]
{
}

ClassMethod QryPARepChartExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateType As %String = "", aDateFrom As %String = "", aDateTo As %String = "", aStatus As %String = "", aLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set NIndex="QryPARepChart"
	Kill ^TMP($zn,$j,NIndex)
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	//循环PDCA报告表
 	Set xID=""
 	For{
		Set xID=$o(^MA.HAI.IR.PDCARepD(xID))
		Quit:xID=""
		
		//取报告基本信息
		Set RepData=$g(^MA.HAI.IR.PDCARepD(xID))
		Continue:RepData=""
		
		Set ItemType=$lg(RepData,2)			//项目类型
		Set ItemDesc=$lg(RepData,3)			//项目名称
		Set (IndexID,IndexDesc)=""			//指标类型
		Set IndexID=$lg(RepData,4)			
		If (IndexID'=""){
			Set IndexData=$g(^CT.MA.HAI.IR.PDCAIndexBaseD(IndexID))
			If (IndexData'=""){
				Set IndexDesc=$lg(IndexData,3)
			}
		}
		Set RegDate=$lg(RepData,5)			//登记日期
		//过滤开始结束日期[按登记日期]
		Continue:(aDateType="1")&&(RegDate<aDateFrom)||(RegDate>aDateTo)
		
		Set:RegDate'="" RegDate=$zd(RegDate,3)
		Set RegTime=$lg(RepData,6)			//登记时间
		Set:RegTime'="" RegTime=$zt(RegTime,1)
		Set (RegLocID,RegLocDesc)=""		//登记科室
		Set RegLocID=$lg(RepData,7)			
		If (RegLocID'=""){
			Set RegLocData=$g(^DHCHAI.BT.LocationD(RegLocID))
			If (RegLocData'=""){
				Set RegLocDesc=$lg(RegLocData,3)
			}
		}
		Set (RegUserID,RegUserDesc)=""		//登记人
		Set RegUserID=$lg(RepData,8)
		If (RegUserID'=""){
			Set RegUserData=$g(^DHCHAI.BT.SysUserD(RegUserID))
			If (RegUserData'=""){
				Set RegUserDesc=$lg(RegUserData,3)
			}
		}
		Set StatusID=$lg(RepData,9)			//报告状态
		If (StatusID'=""){
			Set DicData=$g(^DHCHAI.BT.DictionaryD(StatusID))
			If (DicData'=""){
				Set DicDesc=$lg(DicData,3)
				Continue:DicDesc["删除"
			}
		}
		Set TargetVal=$lg(RepData,10)		//目标值
		Set ModTypeID=$lg(RepData,11)		//模板类型
		
		//循环子表->科室表
		Set xSubID=""
		For{
			Set xSubID=$o(^MA.HAI.IR.PDCARepD(xID,"Loc",xSubID))
			Quit:xSubID=""
				
			Set PALocData=$g(^MA.HAI.IR.PDCARepD(xID,"Loc",xSubID))
			Continue:PALocData=""
			//是否历史报告
			Set IsHist=$lg(PALocData,16)
			Continue:IsHist'=0
			//P-整改科室/病区	
			Set (PlanLocID,PlanLocCode,PlanLocDesc)=""
			Set HospID=""		//整改院区						
			Set PlanLocID=$lg(PALocData,2)	
			If (PlanLocID'=""){
				Set PlanLocData=$g(^DHCHAI.BT.LocationD(PlanLocID))
				If (PlanLocData'=""){
					Set PlanLocCode=$lg(PlanLocData,2)
					Set PlanLocDesc=$lg(PlanLocData,3)
					
					Set HospID=$lg(PlanLocData,8)
				}
			}	
			//过滤院区
			Continue:(aHospIDs'="")&&(("|"_aHospIDs_"|")'[("|"_HospID_"|"))		//过滤院区
			
			//P-整改科室/病区负责人	
			Set (PlanLocUserID,PlanLocUserCode,PlanLocUserDesc)=""			
			Set PlanLocUserID=$lg(PALocData,3)
			If (PlanLocUserID'=""){
				Set PlanLocUserData=$g(^DHCHAI.BT.SysUserD(PlanLocUserID))
				If (PlanLocUserData'=""){
					Set PlanLocUserCode=$lg(PlanLocUserData,2)
					Set PlanLocUserDesc=$lg(PlanLocUserData,3)
				}
			}	
			//P-院感科负责人
			Set (PlanAdminUserID,PlanAdminUserCode,PlanAdminUserDesc)=""	
			Set PlanAdminUserID=$lg(PALocData,4)
			If (PlanAdminUserID'=""){
				Set PlanAdminUserData=$g(^DHCHAI.BT.SysUserD(PlanAdminUserID))
				If (PlanAdminUserData'=""){
					Set PlanAdminUserCode=$lg(PlanAdminUserData,2)
					Set PlanAdminUserDesc=$lg(PlanAdminUserData,3)
				}
			}
			//D-整改实际开始日期
			Set DoASttDate=$lg(PALocData,6)
			//过滤开始结束日期[按整改日期]
			Continue:(aDateType="2")&&(DoASttDate<aDateFrom)||(DoASttDate>aDateTo)
			Set:DoASttDate'="" DoASttDate=$zd(DoASttDate,3)
			//D-整改预计结束日期
			Set DoPEndDate=$lg(PALocData,7)
			Set:DoPEndDate'="" DoPEndDate=$zd(DoPEndDate,3)
			//D-提交人
			Set (DoUserID,DoUserCode,DoUserDesc)=""	
			Set DoUserID=$lg(PALocData,8)
			If (DoUserID'=""){
				Set DoUserData=$g(^DHCHAI.BT.SysUserD(DoUserID))
				If (DoUserData'=""){
					Set DoUserCode=$lg(DoUserData,2)
					Set DoUserDesc=$lg(DoUserData,3)
				}
			}
			//D-整改实际结束日期
			Set DoAEndDate=$lg(PALocData,10)
			Set:DoAEndDate'="" DoAEndDate=$zd(DoAEndDate,3)
			//A-效果评价
			Set (AssessID,AssessDesc)=""
			Set AssessID=$lg(PALocData,14)
			If (AssessID'=""){
				Set AssessData=$g(^DHCHAI.BT.DictionaryD(AssessID))
				If (AssessData'=""){
					Set AssessDesc=$lg(AssessData,3)
				}
			}
			Set PALocStatus="待整改"
			Set:DoASttDate'="" PALocStatus="正在整改"
			Set:AssessID'="" PALocStatus="完成整改"
			//过滤报告状态
			Continue:(aStatus="1")&&(PALocStatus'="待整改")
			Continue:(aStatus="2")&&(PALocStatus'="正在整改")
			Continue:(aStatus="3")&&(PALocStatus'="完成整改")
				
			//记录数据
			Set num=$i(^TMP($zn,$j,NIndex,"ItemType",ItemType)) 		
			Set:PALocStatus="完成整改" num=$i(^TMP($zn,$j,NIndex,"ItemTypeC",ItemType)) 
			Set num=$i(^TMP($zn,$j,NIndex,"ItemTypeALL"))		//全部	
			Set:PALocStatus="完成整改" num=$i(^TMP($zn,$j,NIndex,"ItemTypeCALL")) 
		}	
	}
	Set xItemDesc=""
	For{
		Set xItemDesc=$o(^TMP($zn,$j,NIndex,"ItemType",xItemDesc))
		Quit:xItemDesc=""
		
		Set ItemNum=+$g(^TMP($zn,$j,NIndex,"ItemType",xItemDesc))
		Set ItemCNum=+$g(^TMP($zn,$j,NIndex,"ItemTypeC",xItemDesc))
		Set ItemRatio="0.00%"
		Set:ItemNum>0 ItemRatio=$fn((ItemCNum/ItemNum)*100,"",2)_"%"
		//全部
		Set ItemNumAll=+$g(^TMP($zn,$j,NIndex,"ItemTypeALL"))
		Set ItemNumCAll=+$g(^TMP($zn,$j,NIndex,"ItemTypeCALL"))
		Set ItemAllRatio="0.00%"
		Set:ItemNumAll>0 ItemAllRatio=$fn((ItemNumCAll/ItemNumAll)*100,"",2)_"%"
		
		Set Data=$lb(xItemDesc,ItemCNum,ItemNum,ItemRatio,ItemNumCAll,ItemNumAll,ItemAllRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}
 	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryPARepChartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPARepChartExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPARepChartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPARepChartExecute ]
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
