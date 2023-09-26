/// 名称: CT.IPMR.FPS.ICDDxLogSrv
/// 描述: ICD变更日志服务方法
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.FPS.ICDDxLogSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-20
/// Description:  查询ICD日志
/// Table：       CT.IPMR.FP.ICDDxLog
/// Input：       aICDDxID：ICDDx表ID
/// 			  aDateFrom：操作开始日期
/// 			  aDateTo：操作结束日期
/// 			  aVerID：ICD版本
/// 			  aOperType：操作类型
/// output:       ICD版本列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDDxLogSrv","QryICDLog","758634","2020-03-08","2020-03-08","","A")
Query QryICDLog(aICDDxID As %String, aDateFrom As %String, aDateTo As %String, aVerID As %String, aOperType As %String) As %Query(ROWSPEC = "ID:%String,ICDVerID:%String,ICDVerCode:%String,ICDVerDesc:%String,OperType:%String,OperTypeDesc:%String,OldValue:%String,NewValue:%String,IpAddress:%String,UpdateUserID:%String,UpdateUser:%String,UpdateDate:%String,UpdateTime:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryICDLogExecute(ByRef qHandle As %Binary, aICDDxID As %String, aDateFrom As %String, aDateTo As %String, aVerID As %String, aOperType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set aDateFrom = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(aDateTo)
 	Quit:((aDateFrom="")||(aDateTo=""))&&(aICDDxID="") $$$OK
	
	If aICDDxID'= "" {
		Set xID = ""
		For {
			Set xID = $o(^CT.IPMR.FP.ICDDxLogI("IndexICDDxDr",aICDDxID,xID))
			Quit:xID=""
			d buildlog
		}
	}else{
		For xDate = aDateFrom:1:aDateTo {
			Set xTime = ""
			For {
				Set xTime = $o(^CT.IPMR.FP.ICDDxLogI("IndexDateTime",xDate,xTime))
				Quit:xTime=""
				
				Set xICDDxID = ""
				For {
					Set xICDDxID = $o(^CT.IPMR.FP.ICDDxLogI("IndexDateTime",xDate,xTime,xICDDxID))
					Quit:xICDDxID=""
					
					Set xOperType = ""
					For {
						Set xOperType = $o(^CT.IPMR.FP.ICDDxLogI("IndexDateTime",xDate,xTime,xICDDxID,xOperType))
						Quit:xOperType=""
						Continue:(aOperType'="")&&(xOperType'[aOperType)
						
						Set xID = ""
						For {
							Set xID = $o(^CT.IPMR.FP.ICDDxLogI("IndexDateTime",xDate,xTime,xICDDxID,xOperType,xID))
							Quit:xID=""
							d buildlog
						}
					}
				}
			}
		}
	}
	Quit $$$OK
	
buildlog
	Set objLog = ##class(CT.IPMR.FP.ICDDxLog).GetObjById(xID)
	Quit:'$isobject(objLog)
	
	Set objICDDx 	= objLog.FIICDDxDr
	Quit:'$isobject(objICDDx)
	Set objICDVer = objICDDx.FIICDVerDr
	Quit:'$isobject(objICDVer)
	
	Set ICDVerID = objICDVer.%Id()
	Quit:(aVerID'="")&&(aVerID'=ICDVerID)
	
	Set ICDVerCode = objICDVer.FICode
	//Set ICDVerDesc = objICDVer.FIDesc
	Set ICDVerDesc = objICDVer.FIEdition.BDDesc_" "_objICDVer.FIICDType.BDDesc_" "_objICDVer.FIVersion
	Set OperType 	= objLog.FIOperType
	
	Set OperTypeDesc = $s(OperType="A":"增加",OperType="M":"修改",OperType="M1":"变更映射",1:"")
	
	Set OldValue 	= objLog.FIOldValue
	Set NewValue 	= objLog.FINewValue
	Set:$p($g(OldValue),",",11)'="" $p(OldValue,",",11)=$zd($p(OldValue,",",11),3)	//启用日期（旧）
	Set:$p($g(OldValue),",",12)'="" $p(OldValue,",",12)=$zd($p(OldValue,",",12),3)	//停用日期（旧）
	Set:$p($g(NewValue),",",11)'="" $p(NewValue,",",11)=$zd($p(NewValue,",",11),3)	//启用日期（新）
	Set:$p($g(NewValue),",",12)'="" $p(NewValue,",",12)=$zd($p(NewValue,",",12),3)	//停用日期（新）
	
	Set IpAddress 	= objLog.FIIpAddress
	Set UpdateUserID= objLog.FIUpdateUserID
	Set UpdateUser = ""
	if UpdateUserID'="" {
		Set UserInfo = ##class(MA.IPMR.BTS.SSUserSrv).GetUserStrById(UpdateUserID)
		Set:UserInfo'="" UpdateUser=$p(UserInfo,"^",2)
	}
	Set UpdateDate 	= objLog.FIUpdateDate
	Set UpdateDate=##Class(MA.IPMR.ImedicalSrv).DateLogicalToHtml(UpdateDate)
	Set UpdateTime 	= objLog.FIUpdateTime
	Set:UpdateTime'="" UpdateTime=$zt(UpdateTime)
	Set Resume		= objLog.FIResume
	Set Data=$lb(xID,ICDVerID,ICDVerCode,ICDVerDesc,OperType,OperTypeDesc,OldValue,NewValue,IpAddress,UpdateUserID,UpdateUser,UpdateDate,UpdateTime,Resume)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod QryICDLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDLogExecute ]
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

/// Creator：     liyi
/// CreatDate：   2019-10-20
/// Description:  查询ICD日志明细
/// Table：       CT.IPMR.FP.ICDDxLog
/// Input：       aLogID：日志id
/// output:       ICD版本列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDDxLogSrv","QryICDLogDetail",2)
Query QryICDLogDetail(aLogID As %String) As %Query(ROWSPEC = "Property:%String,oldValue:%String,newValue:%String,changeflg:%String") [ SqlProc ]
{
}

ClassMethod QryICDLogDetailExecute(ByRef qHandle As %Binary, aLogID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aLogID="" $$$OK
 	Set objLog = ##class(CT.IPMR.FP.ICDDxLog).GetObjById(aLogID)
	Quit:'$isobject(objLog) $$$OK
	
	Set OldValue 	= objLog.FIOldValue
	Set NewValue 	= objLog.FINewValue
	
	If objLog.FIOperType="M1" {
		Set Propertys = $lb("","版本","编码","对照版本","对照编码","名称","对照名称","是否有效","备注")
		For inddx = 2:1:$length(NewValue,",") {
			Set newValue = $p(NewValue,",",inddx)
			Set oldValue = $p(OldValue,",",inddx)
			Set Property = $lg(Propertys,inddx)
			Continue:Property=""
			if Property="版本" {
				Set newValue = ##class(CT.IPMR.FP.ICDVer).GetObjById(newValue).FIDesc
				if oldValue'="" {
					Set oldValue = ##class(CT.IPMR.FP.ICDVer).GetObjById(oldValue).FIDesc
				}
			}
			if Property="对照版本" {
				Set newValue = ##class(CT.IPMR.FP.ICDVer).GetObjById(newValue).FIDesc
				if oldValue'="" {
					Set oldValue = ##class(CT.IPMR.FP.ICDVer).GetObjById(oldValue).FIDesc
				}
			}
			if Property="名称" {
				Set newValue = ##class(CT.IPMR.FP.ICDDx).GetObjById(newValue).FIDesc
				if oldValue'="" {
					Set oldValue = ##class(CT.IPMR.FP.ICDDx).GetObjById(oldValue).FIDesc
				}
			}
			if Property="对照名称" {
				Set newValue = ##class(CT.IPMR.FP.ICDDx).GetObjById(newValue).FIDesc
				if oldValue'="" {
					Set oldValue = ##class(CT.IPMR.FP.ICDDx).GetObjById(oldValue).FIDesc
				}
			}
			if Property="是否有效" {
				Set newValue=$s(newValue="1":"是",newValue="0":"否",1:"")
				Set oldValue=$s(oldValue="1":"是",oldValue="0":"否",1:"")
			}
			Set changeflg = $s(newValue=oldValue:0,1:1)
			continue:changeflg=0
			Set Data=$lb(Property,oldValue,newValue,changeflg)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}else{
		Set Propertys = $lb("","代码","名称","版本","主码","副码","肿瘤码","手术类型","HIS诊断库指针","HIS手术库指针","启用日期","停用日期","是否有效","类目","亚目","备注","手术级别","细目","是否分组","诊断并发症或合并症")
		For inddx = 2:1:$length(NewValue,",") {
			Set newValue = $p(NewValue,",",inddx)
			Set oldValue = $p(OldValue,",",inddx)
			Set Property = $lg(Propertys,inddx)
			Continue:Property=""
			if Property="版本" {
				Set newValue = ##class(CT.IPMR.FP.ICDVer).GetObjById(newValue).FIDesc
				if oldValue'="" {
					Set oldValue = ##class(CT.IPMR.FP.ICDVer).GetObjById(oldValue).FIDesc
				}
			}
			if Property="是否有效" {
				Set newValue=$s(newValue="1":"是",newValue="0":"否",1:"")
				Set oldValue=$s(oldValue="1":"是",oldValue="0":"否",1:"")
			}
			if (Property="启用日期")||(Property="停用日期")  {
				Set newValue = $s(newValue="":"",1:##Class(MA.IPMR.ImedicalSrv).DateLogicalToHtml(newValue))
				Set oldValue = $s(oldValue="":"",1:##Class(MA.IPMR.ImedicalSrv).DateLogicalToHtml(oldValue))
			}
			if Property="类目" {
				if newValue'="" {
					Set newValue = ##class(CT.IPMR.FP.ICDCat).GetObjById(newValue).FIICDAlias
				}
				if oldValue'="" {
					Set oldValue = ##class(CT.IPMR.FP.ICDCat).GetObjById(oldValue).FIICDAlias
				}
			}
			if Property="亚目" {
				if newValue'="" {
					Set newValue = ##class(CT.IPMR.FP.ICDCatSub).GetObjById(newValue).FIICDAlias
				}
				if oldValue'="" {
					Set oldValue = ##class(CT.IPMR.FP.ICDCatSub).GetObjById(oldValue).FIICDAlias
				}
			}
			if Property="细目" {
				if newValue'="" {
					Set newValue = ##class(CT.IPMR.FP.ICDDetailCata).GetObjById(newValue).FIICDAlias
				}
				if oldValue'="" {
					Set oldValue = ##class(CT.IPMR.FP.ICDDetailCata).GetObjById(oldValue).FIICDAlias
				}
			}
			if (Property="是否分组")||(Property="诊断并发症或合并症")||(Property="手术级别")||(Property="手术类型") {
				if newValue'="" {
					Set newValue = ##class(CT.IPMR.BT.Dictionary).GetObjById(newValue).BDDesc
				}
				if oldValue'="" {
					Set oldValue = ##class(CT.IPMR.BT.Dictionary).GetObjById(oldValue).BDDesc
				}
			}
			Set changeflg = $s(newValue=oldValue:0,1:1)
			continue:changeflg=0
			Set Data=$lb(Property,oldValue,newValue,changeflg)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryICDLogDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDLogDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDLogDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDLogDetailExecute ]
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
