/// 名称: DHCMA.IMP.IPS.IMPRegisterSrv
/// 描述: 重点患者登记服务
/// 编写者：zhufei
/// 编写日期: 2020-9-25
Class DHCMA.IMP.IPS.IMPRegisterSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     dengshaopeng
/// CreatDate：   2022-05-19
/// Description:  查询重点患者允许操作的患者类型
/// Table：       DHCMA.IMP.BT.IMPCategory
/// Input：       aIsActive：是否有效
///               aIsOper：是否允许操作
/// Others:  	  返回ROWSPEC
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPRegisterSrv","QryReportTypeList","1","1")
Query QryReportTypeList(aIsActive As %String, aIsOper As %String) As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTIsActive:%String,aIsOper:%String")
{
}

ClassMethod QryReportTypeListExecute(ByRef qHandle As %Binary, aIsActive As %String, aIsOper As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	For {
	 	Set xID = $o(^CT.MA.IMP.BTIMPCategoryD(xID))
	 	Quit:xID=""

	 	Set obj = ##class(DHCMA.IMP.BT.IMPCategory).GetObjById(xID)
		Continue:'$IsObject(obj)
	 	Set BTCode      = obj.BTCode
	 	Set BTDesc      = obj.BTDesc
		Set BTIsActive  = obj.BTIsActive
	 	Set BTIsOper     = obj.BTIsOper
	 	
	 	Set BTIsActive  = $s(BTIsActive=1:"是",1:"否")
	 	Continue:BTIsActive="否"&aIsActive="1" //区分列表与维护查询状态为否的查询
	 	Continue:BTIsOper="0"&aIsOper="1"
	 	
		Set Data=$lb(xID,BTCode,BTDesc,BTIsActive,aIsOper)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
 	
 	Quit $$$OK
}

ClassMethod QryReportTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportTypeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     dengshaopeng
/// CreatDate：   2022-05-19
/// Description:  查询重点患者报告
/// Table：       DHCMA.IMP.IP.IMPRecord
/// Input：       aReportType：报告类型患者分类
///               aSubType：报告提交状态
/// 				  
/// Others:  	  返回ROWSPEC
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPRegisterSrv","QryReportList","","","","2020-06-10","2020-09-08")
Query QryReportList(aReportType As %String, aSubType As %String, aHospID As %String, aLodID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "xID:%String,RegDate:%String,RegUserDesc:%String,CheckDate:%String,StatusDesc:%String,CheckUserDesc:%String,IMPCateDesc:%String,LocDesc:%String,PatientName:%String,MrNo:%String,Ward:%String,Sex:%String,Age:%String,EpisodeID:%String,IMPCateDr:%String,IMPOrdNo:%String")
{
}

ClassMethod QryReportListExecute(ByRef qHandle As %Binary, aReportType As %String, aSubType As %String, aHospID As %String, aLodID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set:aDateFrom'="" aDateFrom =##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set:aDateTo'="" aDateTo =##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
 	
 	
 	
 	Set xID=""
 	For {
	 	Set xID = $o(^MA.IMP.IPIMPRegisterD(xID))
	 	Quit:xID=""

	 	Set obj = ##class(DHCMA.IMP.IP.IMPRegister).GetObjById(xID)
		Continue:'$IsObject(obj)
		Set (RegDate,RegUserID,RegUserDesc,CheckDate,StatusDesc,CheckUserID,CheckUserDesc,IMPCateDesc,LocDesc,PatientName,MrNo,Ward,Sex,Age,EpisodeID,IMPCateDr,IMPOrdNo)=""
		
	 	Set RegDate = obj.RegDate
	 	Continue:(RegDate>aDateTo)||(RegDate<aDateFrom)
	 	Set:RegDate'="" RegDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RegDate)
	 	Set RegType = obj.RegType
	 	Set IMPCateDr = obj.IMPRecordDr.IMPCateDr
	 	Set IMPCatteID = IMPCateDr.%Id()
	 		 	
	 	Continue:(aReportType'="")&(IMPCatteID'=aReportType)
	 	Set StatusID = obj.StatusDr.%Id()
	 	Continue:(aSubType'="")&(aSubType'=StatusID)
	 	Set StatusDesc = obj.StatusDr.BTDesc
	 	
	 	Set:obj.RegUserID'="" RegUserID = obj.RegUserID
	 	Set:RegUserID'="" RegUserID = RegUserID_"!!1"
	 	Set RegUserObj = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(RegUserID)
	 	Continue:('$IsObject(RegUserObj))&(RegUserID'="")
	 	Set:RegUserID'="" RegUserDesc =RegUserObj.BTDesc
	 	
	 	Set:obj.CheckDate'="" CheckDate = obj.CheckDate
	 	Set:CheckDate'="" CheckDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
	 	
	 	Set:obj.CheckUserID'="" CheckUserID = obj.CheckUserID
	 	Set:CheckUserID'="" CheckUserID = CheckUserID_"!!1"
	 	Set CheckUserObj = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(CheckUserID)
	 	Continue:('$IsObject(CheckUserObj))&(CheckUserID'="")
	 	Set:CheckUserID'="" CheckUserDesc =CheckUserObj.BTDesc
	 	
	 	Set IMPRecordDr = obj.IMPRecordDr.%Id()
	 	Set IMPRecordObj = ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(IMPRecordDr)
	 	Continue:'$IsObject(IMPRecordObj)
	 	Set IMPOrdNo = IMPRecordObj.IMPOrdNo
	 	Set IMPCateDr =obj.IMPRecordDr.IMPCateDr.%Id()
	 	Set IMPCateDesc = IMPRecordObj.IMPCateDr.BTDesc
	 	Set EpisodeID = obj.EpisodeID
	 	Set objPaadm = ##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	 	Continue:'$IsObject(objPaadm)
	 	Set PatientID = objPaadm.PatientID
	 	Set LocDesc = objPaadm.Department
	 	Set LocID = objPaadm.DepartmentID
	 	Set MrNo = objPaadm.MrNo
	 	Set Ward = objPaadm.Ward
	 	
	 	Continue:(aLodID'="")&(aLodID'=LocID)
	 	
	 	Set objPatient = ##class(DHCMed.Base.Patient).GetObjById(PatientID)
	 	Continue:'$IsObject(objPatient) 
	 	Set PatientName = objPatient.PatientName
	 	Set Sex = objPatient.Sex
	 	Set Age = objPatient.Age
	 	
	 	
	 	
		Set Data=$lb(xID,RegDate,RegUserDesc,CheckDate,StatusDesc,CheckUserDesc,IMPCateDesc,LocDesc,PatientName,MrNo,Ward,Sex,Age,EpisodeID,IMPCateDr,IMPOrdNo)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
 	
 	Quit $$$OK
}

ClassMethod QryReportListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     dengshaopeng
/// CreatDate：   2022-05-19
/// Description:  查询重点患者报告提交状态
/// Table：       DHCMA.IMP.BT.IMPCategory
/// Input：       aIsActive：是否有效
///               aIsOper：是否允许操作
/// Others:  	  返回ROWSPEC
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPRegisterSrv","QryReportSubType","1")
Query QryReportSubType(aTypeCode As %String) As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String")
{
}

ClassMethod QryReportSubTypeExecute(ByRef qHandle As %Binary, aTypeCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set objType=##class(DHCMA.Util.BT.DicType).GetObjByCode(aTypeCode)
	Quit:'$IsObject(objType) ""
	Set TypeDr=objType.%Id()
 	Set xID=""
 	For { //^DHCMA.Util.BT.DictionaryI("IdxofTypeDrCode"
		Set xID=$o(^DHCMA.Util.BT.DictionaryD(xID))
		Quit:xID=""
	 	Set objDcitionry =##class(DHCMA.Util.BT.Dictionary).GetObjById(xID)
	 	Continue:'$IsObject(objDcitionry)
	 	Set BTCode = objDcitionry.BTCode
	 	Set BTDesc = objDcitionry.BTDesc
	 	Set BTTypeDr = objDcitionry.BTTypeDr.%Id()
	 	Continue:TypeDr'=BTTypeDr
	 	
		Set Data=$lb(xID,BTCode,BTDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
 	
 	Quit $$$OK
}

ClassMethod QryReportSubTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportSubTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportSubTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportSubTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
