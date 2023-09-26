/// 名称: DHCHAI.IRS.HandHyConsumsSrv
/// 描述: 手卫生消耗登记信息服务
/// 编写者：zhoubo
/// 编写日期: 2017-12-28
Class DHCHAI.IRS.HandHyConsumsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-12-28
/// Description:  查询手卫生消耗用品列表
/// Table：       DHCHAI.IR.HandHyConsums
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.HandHyConsumsSrv","QryHHConsums","","","2018-02-01","2018-02-06")
Query QryHHConsums(aHospID As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ID:%String,LocDr:%String,LocCode:%String,LocDesc:%String,ObsDate:%String,ProductDr:%String,ProductCode:%String,ProductDesc:%String,Consumption:%String,Recipient:%String,RepDate:%String,RepTime:%String,IsActive:%String,Resume:%String,RegUserDr:%String,RegUserCode:%String,RegUserDesc:%String,ObsDateYM:%String,ConsuSum:%String,ProIsActive:%String,IsActiveDesc:%String") [ SqlProc ]
{
}

ClassMethod QryHHConsumsExecute(ByRef qHandle As %Binary, aHospID As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set:aDateFrom'="" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo'="" aDateTo=$zdh(aDateTo,3)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospID,"|")
	Set xLoc=""
	For {
		Set xLoc=$o(^DHCHAI.IR.HandHyConsumsI("IndexLocDate",xLoc))
	 	Quit:xLoc=""
	 	Continue:(aLocID'="")&&(aLocID'=xLoc)
	 	
	 	For xDate=aDateFrom:1:aDateTo {
		 	Set xID=""
		 	For {
				Set xID=$o(^DHCHAI.IR.HandHyConsumsI("IndexLocDate",xLoc,xDate,xID))
			 	Quit:xID=""
			 	
			 	Set obj=##class(DHCHAI.IR.HandHyConsums).GetObjById(xID)
			 	Continue:'$IsObject(obj)
			 	
				Set ObsDate = obj.HHCObsDate
				Set ObsDateYM = $p($zd(ObsDate,3),"-",1)_"-"_$p($zd(ObsDate,3),"-",2)
				Set:ObsDate'="" ObsDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ObsDate)
				Set Consumption = obj.HHCConsumption
				Set Recipient = obj.HHCRecipient
				Set RepDate   = obj.HHCRepDate
				Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
				Set RepTime   = obj.HHCRepTime
				Set:RepTime'="" RepTime=$zt(RepTime,1)
				Set IsActive  = +obj.HHCActive
				Set Resume    = obj.HHCResume
				
				If $IsObject(obj.HHCLocDr) {
					Set LocDr   = obj.HHCLocDr.%Id()
					Set LocCode = obj.HHCLocDr.BTCode
					Set LocDesc = obj.HHCLocDr.BTDesc2
					Set:LocDesc="" LocDesc=obj.HHCLocDr.BTDesc
				} Else{
					Set (LocDr,LocCode,LocDesc)=""
				}
				Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(LocDr)
				Set HospID=$p(HospInfo,"^",1)
				Continue:(aHospID'="")&&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
			
				If $IsObject(obj.HHCProduct) {
					Set ProductDr   = obj.HHCProduct.%Id()
					Set ProductCode = obj.HHCProduct.HHPCode
					Set ProductDesc = obj.HHCProduct.HHPDesc
					Set HHPSpec     = obj.HHCProduct.HHPSpec
					//add for 627983:手卫生用品消耗量-某科室只有一条手卫生消耗记录时，将对应的手卫生用品置为无效，该科室所有项目均为0，但仍统计
					Set ProIsActive     = obj.HHCProduct.HHPActive
					If (aHospID=""){	//手卫生用品消耗量统计,入参没有aHospID
						Continue:ProIsActive=0
						Continue:IsActive=0		//bug:627961,能够统计到无效的手卫生用品消耗的记录
					}
					//end
					Set (UnitDr,UnitCode,UnitDesc)=""
					If $IsObject(obj.HHCProduct.HHPUnit) {
						Set UnitDr   = obj.HHCProduct.HHPUnit.%Id()
						Set UnitCode = obj.HHCProduct.HHPUnit.BTCode
						Set UnitDesc = obj.HHCProduct.HHPUnit.BTDesc
					}
					Set ProductDesc=ProductDesc_" "_HHPSpec_UnitDesc
		
				} Else{
					Set (ProductDr,ProductCode,ProductDesc)=""
				}
				//Set ConsuSum  = Consumption*HHPSpec
				Set ConsuSum = +Consumption
				If $IsObject(obj.HHCRegUserDr) {
					Set RegUserDr   = obj.HHCRegUserDr.%Id()
					Set RegUserCode = obj.HHCRegUserDr.BTCode
					Set RegUserDesc = obj.HHCRegUserDr.BTDesc
				} Else{
					Set (RegUserDr,RegUserCode,RegUserDesc)=""
				}
				Set IsActiveDesc=$s(IsActive=1:"是",1:"否")
				Set Data=$lb(xID,LocDr,LocCode,LocDesc,ObsDate,ProductDr,ProductCode,ProductDesc,Consumption,Recipient,RepDate,RepTime,IsActive,Resume,RegUserDr,RegUserCode,RegUserDesc,ObsDateYM,ConsuSum,ProIsActive,IsActiveDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryHHConsumsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHHConsumsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHHConsumsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHHConsumsExecute ]
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
