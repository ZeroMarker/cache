/// 名称: DHCMA.CPW.BTS.PathMultiQuerySrv
/// 描述: 路径条件查询服务类
/// 编写者：yankai
/// 编写日期: 2022-10-24
Class DHCMA.CPW.BTS.PathMultiQuerySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathMultiQuerySrv","QryMultiCondPath","2!!1","","","I","","","-1","","^NoApply^")
Query QryMultiCondPath(aHospID As %String = "", aLocID As %String = "", aPathType As %String = "", aAdmType As %String = "", aPathIsActive As %String = "-1", aNameKeyWord As %String = "", aFlagVer As %String = "0", aPathKeyIDs As %String = "", aFormKeyIDs As %String = "") As %Query(ROWSPEC = "PathCode:%String, PathName:%String, PathType:%String, PathIsActive:%String, PathEty:%String, PathPCEty:%String, PathQCEty:%String, PathCompl:%String, AdmType:%String, IsOper:%String, StaCategory:%String, FormVer:%String, FormIsActive:%String, ApplyStatus:%String, FormCost:%String, FormDays:%String,ApplyDoc:%String, AdmitDoc:%String, FormUser:%String, FormVerDate:%String")
{
}

ClassMethod QryMultiCondPathExecute(ByRef qHandle As %Binary, aHospID As %String = "", aLocID As %String = "", aPathType As %String = "", aAdmType As %String = "", aPathIsActive As %String = "-1", aNameKeyWord As %String = "", aFlagVer As %String = "0", aPathKeyIDs As %String = "", aFormKeyIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	//Set ^TEMPYK("QryMultiCondPath")=$LB(aHospID,aLocID,aPathType,aAdmType,aPathIsActive,aNameKeyWord,aFlagVer,aPathKeyIDs,aFormKeyIDs)
	
	Set xPathID = ""
	For {
		Set xPathID = $o(^DHCMA.CPW.BT.PathMastD(xPathID))
		Quit:xPathID=""
		
		Set objPath = ##class(DHCMA.CPW.BT.PathMast).GetObjById(xPathID)
		Continue:'$IsObject(objPath)
		Continue:'$IsObject(objPath.BTTypeDr)
		
		Set PathTypeID=objPath.BTTypeDr.%Id()
		Continue:(aPathType'="")&&(PathTypeID'=aPathType)							// 路径类型过滤
		Set PathName = objPath.BTDesc
		Continue:(aNameKeyWord'="")&&(PathName'[aNameKeyWord)
		Set PathAdmType=objPath.BTAdmType
		Continue:(aAdmType'="")&&(PathAdmType'="")&&(PathAdmType'[aAdmType)			// 就诊类型过滤
		Set PathIsActive = objPath.BTIsActive
		Continue:(aPathIsActive'="")&&(aPathIsActive'=PathIsActive)					// 过滤路径有效性
		Set IsCrtFinish=##class(DHCMA.CPW.BTS.PathFormSrv).CheckFormIC(xPathID)		// 如果是图形化创建的路径需检查是否完成，未完成不显示
		Continue:IsCrtFinish'=1
		
		// 科室关联路径参数过滤
		If aLocID'="" {
			Continue:'$d(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_aLocID,xPathID))
			Set PathLocID=$o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_aLocID,xPathID,""))
			Set objPathLoc=##class(DHCMA.CPW.BT.PathLoc).GetObjById(PathLocID)
			Continue:'$IsObject(objPathLoc)
			Continue:'objPathLoc.PDIsActive
		}
		
		// 按关联医院过滤
		Set IsHosp=##class(DHCMA.CPW.BTS.PathFormSrv).CheckPathHospOID(xPathID,aHospID)
		Continue:'IsHosp
		
		// 路径特征过滤
		If aPathKeyIDs'=""{
			Set retPathFilter = ##class(DHCMA.CPW.BTS.PathFormSrv).FilterPathKeyIDs(xPathID,aPathKeyIDs)
			Continue:retPathFilter'=1
		}
		
		Set PathCode = objPath.BTCode
		Set PathName = objPath.BTDesc
		Set PathType = objPath.BTTypeDr.BTDesc
		Set PathIsActive = objPath.BTIsActive
		Set PathEty = ""									// 路径病种
		Set:$IsObject(objPath.BTEntityDr) PathEty = objPath.BTEntityDr.BTDesc
		Set PathPCEty = ""
		Set PathPCEty = objPath.BTPCEntityDr				// 付费病种
		Set PathQCEty = ""
		Set PathQCEty = objPath.BTQCEntityDr				// 质控病种
		Set PathCompl = objPath.BTIsAsCompl					// 合并症路径
		Set AdmTypeCode = objPath.BTAdmType
		Set AdmType = $s(AdmTypeCode="O":"门诊",AdmTypeCode="I":"住院",1:"")
		Set IsOper = objPath.BTIsOper		// 手术路径
		Set StaCategory = ""
		Set:$IsObject(objPath.BTStaCategoryDr) StaCategory = objPath.BTStaCategoryDr.BTDesc
		
		
		// 表单过滤
		If aFlagVer = "-1"{									// 查询全部表单
			If '$d(^DHCMA.CPW.BT.PathFormI("IdxofVersion",xPathID))&&($tr(aFormKeyIDs,"^")=""){								// 新建路径无版本
				Set (FormVer,FormIsActive,ApplyStatus,FormCost,FormDays,ApplyDoc,AdmitDoc,FormUser,FormVerDate)=""
				
				Set Data=$lb(PathCode,PathName,PathType,PathIsActive,PathEty,PathPCEty,PathQCEty,PathCompl,AdmType,IsOper,StaCategory,FormVer,FormIsActive,ApplyStatus,FormCost,FormDays,ApplyDoc,AdmitDoc,FormUser,FormVerDate)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1												// 全部查询时无版本的也返回	
			}Else{
				Set VerNum=0
				For {
					Set VerNum=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",xPathID,VerNum))
					Quit:VerNum=""
					
					Set FormID=0
					For {
						Set FormID=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",xPathID,VerNum,FormID))
						Quit:FormID=""			
						
						Set retFilter = ##class(DHCMA.CPW.BTS.PathFormSrv).FilterVerKeyIDs(FormID,aFormKeyIDs)
						Continue:retFilter'=1
						Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(FormID)
						Continue:'$IsObject(objForm)
						Set Version=+objForm.FormVersion
						Set FormIsOpen = +objForm.FormIsOpen
				 		Set FormIsActive=+objForm.FormIsActive
				 		If (FormIsActive) {
							If FormIsOpen {
								Set FormVer="V"_Version_".0 正使用"
							}Else{
								Set FormVer="V"_Version_".0 未发布"	
							}
						} Else {
							Set FormVer="V"_Version_".0 (作废)"
						}
						Set FormCost = objForm.FormCost
						Set FormDays = objForm.FormDays
						Set FormUser = "",FormUserID = objForm.FormVerUserID
						Set objFormUser = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(FormUserID)
						Set:$IsObject(objFormUser) FormUser = objFormUser.BTDesc 
						Set FormVerDate = objForm.FormVerDate
						Set FormVerDate = ##class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(FormVerDate)
						Set ApplyDoc = objForm.FormApply
						Set AdmitDoc = objForm.FormHelpDoc 
					
						Set retApply = ##class(DHCMA.CPW.BTS.ApplyExamRecSrv).GetLastExamResult(FormID)
						Set ApplyStatus = $case(retApply,"1":"申请通过","0":"未通过","-1":"申请中",:"未申请") 
					
						Set Data=$lb(PathCode,PathName,PathType,PathIsActive,PathEty,PathPCEty,PathQCEty,PathCompl,AdmType,IsOper,StaCategory,FormVer,FormIsActive,ApplyStatus,FormCost,FormDays,ApplyDoc,AdmitDoc,FormUser,FormVerDate)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}ElseIf aFlagVer = "-2" {
			If '$d(^DHCMA.CPW.BT.PathFormI("IdxofVersion",xPathID)){								// 新建路径无版本
				Set (FormVer,FormIsActive,ApplyStatus,FormCost,FormDays,ApplyDoc,AdmitDoc,FormUser,FormVerDate)=""
				
				Set Data=$lb(PathCode,PathName,PathType,PathIsActive,PathEty,PathPCEty,PathQCEty,PathCompl,AdmType,IsOper,StaCategory,FormVer,FormIsActive,ApplyStatus,FormCost,FormDays,ApplyDoc,AdmitDoc,FormUser,FormVerDate)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}else{
				Continue	
			}
		}Else{												// 查询指定表单
			Set IsFormActive=1
			Set:aFlagVer=2 IsFormActive=""
			Set FormStr=##class(DHCMA.CPW.BTS.PathFormSrv).GetFormByMast(xPathID,aFlagVer,IsFormActive)	//FormID_"^"_Version
			Set FormID=$p(FormStr,"^",1)
			
			Set retFilter = ##class(DHCMA.CPW.BTS.PathFormSrv).FilterVerKeyIDs(FormID,aFormKeyIDs)
			Continue:retFilter'=1
			
			Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(FormID)
			Continue:'$IsObject(objForm)
			Set Version=+objForm.FormVersion
			Set FormIsOpen = +objForm.FormIsOpen
	 		Set FormIsActive=+objForm.FormIsActive
	 		If (FormIsActive) {
				If FormIsOpen {
					Set FormVer="V"_Version_".0 正使用"
				}Else{
					Set FormVer="V"_Version_".0 未发布"	
				}
			} Else {
				Set FormVer="V"_Version_".0 (作废)"
			}
			Set FormCost = objForm.FormCost
			Set FormDays = objForm.FormDays
			Set FormUser = "",FormUserID = objForm.FormVerUserID
			Set objFormUser = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(FormUserID)
			Set:$IsObject(objFormUser) FormUser = objFormUser.BTDesc 
			Set FormVerDate = objForm.FormVerDate
			Set FormVerDate = ##class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(FormVerDate)
			Set ApplyDoc = objForm.FormApply
			Set AdmitDoc = objForm.FormHelpDoc 
		
			Set retApply = ##class(DHCMA.CPW.BTS.ApplyExamRecSrv).GetLastExamResult(FormID)
			Set ApplyStatus = $case(retApply,"1":"申请通过","0":"未通过","-1":"申请中",:"未申请") 
			
			Set Data=$lb(PathCode,PathName,PathType,PathIsActive,PathEty,PathPCEty,PathQCEty,PathCompl,AdmType,IsOper,StaCategory,FormVer,FormIsActive,ApplyStatus,FormCost,FormDays,ApplyDoc,AdmitDoc,FormUser,FormVerDate)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	
		}
	}
	
	Quit $$$OK
}

ClassMethod QryMultiCondPathClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMultiCondPathExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMultiCondPathFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMultiCondPathExecute ]
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
