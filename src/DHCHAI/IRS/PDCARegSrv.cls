/// 名称: DHCHAI.IRS.PDCARegSrv
/// 描述: PDCA登记服务
/// 编写者：ShenC
/// 编写日期: 2022-08-22
Class DHCHAI.IRS.PDCARegSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2023-03-01
/// Description:  查询PDCA相关信息(用于登记/查询)
/// Table：       DHCHAI.IR.PDCARep
/// Input：		  aHospIDs(院区),aDateType(日期类型),aDateFrom(开始日期),aDateTo(结束日期),aStatus(状态)
/// 				  aLocID(科室),aUserID(用户)		  
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.PDCARegSrv","QryPARepList","","","")
Query QryPARepList(aHospIDs As %String = "", aDateType As %String = "", aDateFrom As %String = "", aDateTo As %String = "", aStatus As %String = "", aLocID As %String = "", aUserID As %String = "", aIsHist As %String = "", aRepID As %String = "") As %Query(ROWSPEC = "RepID:%String,ItemType:%String,ItemDesc:%String,IndexID:%String,IndexDesc:%String,RegDate:%String,RegTime:%String,RegLocID:%String,RegLocDesc:%String,RegUserID:%String,RegUserDesc:%String,TargetVal:%String,ModTypeID:%String,SubID:%String,PlanLocID:%String,PlanLocCode:%String,PlanLocDesc:%String,PlanLocUserID:%String,PlanLocUserCode:%String,PlanLocUserDesc:%String,PlanAdminUserID:%String,PlanAdminUserCode:%String,PlanAdminUserDesc:%String,DoASttDate:%String,DoPEndDate:%String,DoUserID:%String,DoUserCode:%String,DoUserDesc:%String,DoAEndDate:%String,AssessID:%String,AssessDesc:%String,PALocStatus:%String") [ SqlProc ]
{
}

ClassMethod QryPARepListExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateType As %String = "", aDateFrom As %String = "", aDateTo As %String = "", aStatus As %String = "", aLocID As %String = "", aUserID As %String = "", aIsHist As %String = "", aRepID As %String = "") As %Status
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
		//过滤登记日期
		If (aDateType="1"){
			Continue:(RegDate<aDateFrom)||(RegDate>aDateTo)
		}
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
		Set TargetVal=$lg(RepData,9)		//目标值
		Set ModTypeID=$lg(RepData,10)		//模板类型
		//报告基本信息
		Set RepData=$lb(xID,ItemType,ItemDesc,IndexID,IndexDesc,RegDate,RegTime,RegLocID,RegLocDesc,RegUserID,RegUserDesc,TargetVal,ModTypeID)
		
		//循环子表->科室表
		Set xSubID=""
		For{
			Set xSubID=$o(^MA.HAI.IR.PDCARepD(xID,"Loc",xSubID))
			Quit:xSubID=""
				
			Set PALocData=$g(^MA.HAI.IR.PDCARepD(xID,"Loc",xSubID))
			Continue:PALocData=""
			//是否有效
			Set IsActive=$lg(PALocData,17)
			Continue:IsActive'="1"
			
			//P-整改科室/病区	
			Set (PlanLocID,PlanLocCode,PlanLocDesc)=""						
			Set PlanLocID=$lg(PALocData,2)	
			If (PlanLocID'=""){
				Set PlanLocData=$g(^DHCHAI.BT.LocationD(PlanLocID))
				If (PlanLocData'=""){
					Set PlanLocCode=$lg(PlanLocData,2)
					Set PlanLocDesc=$lg(PlanLocData,3)
					
					//过滤院区
					Set PlanHospID=$li(PlanLocData,8)
					Continue:(aHospIDs'="")&&(("|"_aHospIDs_"|")'[("|"_PlanHospID_"|"))		
				}
			}
			//过滤整改科室	
			Continue:(aLocID'="")&&(PlanLocID'=aLocID)							
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
			Continue:((aUserID'="")&&(aUserID'=PlanLocUserID))					//过滤病区负责人
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
			//过滤整改日期
			If (aDateType="2"){
				Continue:(DoASttDate<aDateFrom)||(DoASttDate>aDateTo)
			}
			
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
			//获取状态
			Set (StatusID,StatusCode,StatusDesc)=""
			Set StatusID=$lg(PALocData,16)
			If (StatusID'=""){
				Set StatusData=$g(^DHCHAI.BT.DictionaryD(StatusID))
				If (StatusData'=""){
					Set StatusCode=$lg(StatusData,2)
					Set StatusDesc=$lg(StatusData,3)
				}
			}
		
			//报告状态[取转换后:待整改,正在整改,完成整改]
			Set PALocStatus="待整改"
			Set:(StatusCode="6")||(StatusCode="7")||(StatusCode="8")||(StatusCode="9") PALocStatus="正在整改"
			Set:StatusCode="10" PALocStatus="完成整改"
		
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

}
