/// 名称: DHCHAI.IRS.CRuleAntiSrv
/// 描述: 抗菌用药筛查标准相关服务
/// 编写者：zhufei
/// 编写日期: 2017-11-26
Class DHCHAI.IRS.CRuleAntiSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-11-28
/// Description:  查询抗菌用药筛查标准列表
/// Table：       DHCHAI.IR.CRuleAnti
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CRuleAntiSrv","QryCRuleAnti")
Query QryCRuleAnti() As %Query(ROWSPEC = "ID:%String,Type:%String,GrpID:%String,GrpDesc:%String,HospID:%String,HospDesc:%String,LocID:%String,LocDesc:%String,AntiCatID:%String,AntiCatDesc:%String,AntiMastID:%String,AntiMastDesc:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserCode:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCRuleAntiExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.IR.CRuleAntiD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.IR.CRuleAnti).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	//类型（1全院、2院区、3科室）
		Set Type = obj.BTType
		If $IsObject(obj.BTHospGrpDr) {
			Set GrpID   = obj.BTHospGrpDr.%Id()  
			Set GrpCode = obj.BTHospGrpDr.BTCode
			Set GrpDesc = obj.BTHospGrpDr.BTDesc
	    }Else {
			Set (GrpID,GrpCode,GrpDesc)=""   
		}
		If $IsObject(obj.BTHospDr) {
			Set HospID   = obj.BTHospDr.%Id()  
			Set HospCode = obj.BTHospDr.BTCode
			Set HospDesc = obj.BTHospDr.BTDesc
	    }Else {
			Set (HospID,HospCode,HospDesc)=""   
		}
		If $IsObject(obj.BTLocDr) {
			Set LocID   = obj.BTLocDr.%Id()  
			Set LocCode = obj.BTLocDr.BTCode
			Set LocDesc = obj.BTLocDr.BTDesc
			Set LocDesc2 = obj.BTLocDr.BTDesc2
			Set:LocDesc2'="" LocDesc=LocDesc2
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	    }Else {
			Set (LocID,LocCode,LocDesc)=""   
		}
		
		//抗菌用药分类
	 	Set AntiCatID="",AntiCatDesc=""
	 	If $IsObject(obj.BTAntiCatDr) {
			Set AntiCatID	= obj.BTAntiCatDr.%Id()
			Set AntiCatDesc	= obj.BTAntiCatDr.BTDesc
		}
		//抗菌用药字典
		If $IsObject(obj.BTAntiMastDr){
			Set AntiMastID=obj.BTAntiMastDr.%Id()
			Set AntiMastDesc=obj.BTAntiMastDr.BTName
		} Else {
			//抗菌用药名称（自定义）
			Set AntiMastID=""
			Set AntiMastDesc=obj.BTAntiDesc
		}
		
	 	Set IsActive    = obj.BTIsActive
		Set ActDate     = obj.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime     = obj.BTActTime
		Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUserID="",ActUserCode="",ActUserDesc=""
		If $IsObject(obj.BTActUser) {
			Set ActUserID   = obj.BTActUser.%Id()
			Set ActUserCode = obj.BTActUser.BTCode
			Set ActUserDesc = obj.BTActUser.BTDesc
		}
		
		Set Data=$lb(xID,Type,GrpID,GrpDesc,HospID,HospDesc,LocID,LocDesc,AntiCatID,AntiCatDesc,AntiMastID,AntiMastDesc,IsActive,ActDate,ActTime,ActUserID,ActUserCode,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCRuleAntiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCRuleAntiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCRuleAntiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCRuleAntiExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2017-12-07
/// Description:  检测药物名称是否存在
/// Table：       DHCHAI.IR.CRuleAnti
/// Input：       抗菌药物名称
/// Return：      返回0不存在或者DHCHAI.IR.CRuleAnti.ID
/// w ##class("DHCHAI.IRS.CRuleAntiSrv").IsExistAntiMast("美罗培南")
ClassMethod IsExistAntiMast(aAntiMast As %String) As %String
{
	New (aAntiMast)
	Set return=0
	Quit:(aAntiMast="") return
	
	Set xType=0
	For {
		Set xType = $o(^DHCHAI.IR.CRuleAntiI("IndexTypeAntiCatMastDr",xType))
		Quit:xType=""
		
		Set xAntiCatId=0
		For {
			Set xAntiCatId = $o(^DHCHAI.IR.CRuleAntiI("IndexTypeAntiCatMastDr",xType,xAntiCatId))
			Quit:xAntiCatId=""
			
			Set xAntiMastId=0
			For {
				Set xAntiMastId = $o(^DHCHAI.IR.CRuleAntiI("IndexTypeAntiCatMastDr",xType,xAntiCatId,xAntiMastId))
				Quit:xAntiMastId=""
				
				Set objAnti = ##class(DHCHAI.DP.OEAntiMast).GetObjById(xAntiMastId)
				Quit:'$IsObject(objAnti)
				Continue:objAnti.BTIsActive'=1
				Set BTName = objAnti.BTName
				Continue:BTName'=aAntiMast
				Set return = $o(^DHCHAI.IR.CRuleAntiI("IndexTypeAntiCatMastDr",xType,xAntiCatId,xAntiMastId,""))
			}
		}
	}
	Quit return
}

}
