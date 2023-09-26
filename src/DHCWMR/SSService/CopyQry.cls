/// 名称: DHCWMR.SSService.CopyQry
/// 描述: 病案复印相关查询
/// 编写者：liyi
/// 编写日期: 2015-11-16
Class DHCWMR.SSService.CopyQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2015-11-16
/// Description:  病案复印查询明细
/// Table：       
/// Input：       
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.CopyQry","QryCopyDeail","2",7,"2016-01-10","2016-12-12")
Query QryCopyDeail(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,ID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,HospDesc:%String,RegDate:%String,PaperNumber:%String,Money:%String,CreateUser:%String")
{
}

ClassMethod QryCopyDeailExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	;Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	
	Quit:(aHospID="")||(aMrTypeID="")||(aDateFrom="")||(aDateTo="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	Set SumPaper=0,SumMoney=0
	For xDate = aDateFrom:1:aDateTo{
		Set xCopyID =""
		For {
			Set xCopyID = $o(^DHCWMR.MO.CopyRecordI("IndexMrTypeRegDate",aMrTypeID,xDate,xCopyID))
			Quit:xCopyID=""
			
			Set objCopy = ##class(DHCWMR.MO.CopyRecord).GetObjById(xCopyID)
			Continue:'$IsObject(objCopy)
			
			Set FirstHosp = objCopy.CRMainDr.SMFirstHosp
			Continue:(aHospID'="")&&(FirstHosp'="")&&(aHospID'[(","_FirstHosp_","))
			
			Set HospCode = ##class(DHCWMR.SSService.HospitalSrv).GetSSHospCode(FirstHosp)
			Set SSHospID = $o(^DHCWMR.SS.HospitalI("IndexCode"," "_HospCode," "_FirstHosp,""))
			Set objSSHosp = ##class(DHCWMR.SS.Hospital).GetObjById(SSHospID)
			//Quit:'$IsObject(objSSHosp)&&(FirstHosp'="")
			
			Set HospDesc="",PatientID=""
			Set MrNo = objCopy.CRMainDr.SMMrNo
			Set xCopyVolID=""
			For {
				Set xCopyVolID=$o(^DHCWMR.MO.CopyRecordD(xCopyID,"VOL",xCopyVolID))
				Quit:xCopyVolID=""
				Set objCopyVol = ##class(DHCWMR.MO.CopyRecordVol).GetObjById(xCopyID_"||"_xCopyVolID)
				Continue:'$IsObject(objCopyVol)
				Set objVolume = objCopyVol.RVolumeDr
				Continue:'$IsObject(objVolume)
				Set VolumeID = objVolume.%Id()
				Set xSubID=$o(^DHCWMR.SS.VolumeD(VolumeID,"P",0))
				Continue:xSubID=""
				Set objVolPaadm=##class(DHCWMR.SS.VolPaadm).GetObjById(VolumeID_"||"_xSubID)
				Continue:'$IsObject(objVolPaadm)
				If (aHospID'="")&&(FirstHosp="") {
					Set AdmHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(objVolPaadm.VPAdmitDept)
					Continue:(aHospID'[(","_AdmHospID_","))  //检查院区是否符合
					Set HospCode = ##class(DHCWMR.SSService.HospitalSrv).GetSSHospCode(AdmHospID)
					Set SSHospID = $o(^DHCWMR.SS.HospitalI("IndexCode"," "_HospCode," "_AdmHospID,""))
					Set objSSHosp = ##class(DHCWMR.SS.Hospital).GetObjById(SSHospID)
				}
				Set:$IsObject(objSSHosp) HospDesc=objSSHosp.SHDesc
				Set PatName   = objVolPaadm.VPPatName
				Set PatientID = objVolPaadm.VPPatientID
				Set PapmiNo   = $p($g(^PAPER(PatientID,"PAT",1)),"^",1)
				Set Sex = objVolPaadm.VPSex
				Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,"","","")  //年龄
			}
			Continue:PatientID=""
			
			Set RegDate = objCopy.CRRegDate
			;Set:RegDate'="" RegDate=$zd(RegDate,3)
			Set:RegDate'="" RegDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(RegDate)
			Set PaperNumber = objCopy.CRPaperNumber
			Set CreateUser = objCopy.CRCreateUser
			Set:CreateUser'="" CreateUser=$p($g(^SSU("SSUSR",CreateUser)),"^",2)
			Set Money=0.00
			For indFee=1:1:objCopy.ChildFee.Count() {
				Set objCopyFee=objCopy.ChildFee.GetAt(indFee)
				Continue:'$IsObject(objCopyFee)
				Set objFRecord=objCopyFee.CRFRecordDr
				Continue:'$IsObject(objFRecord)
				Continue:objFRecord.FRStatus="C"			//退费
				Set Money = objFRecord.FRMoney
			}
			Set Money = $fn(Money,"",2)
			Set SumPaper = SumPaper+PaperNumber
			Set SumMoney = SumMoney+Money
			
			Set Data=$lb(ind,xCopyID,PapmiNo,MrNo,PatName,Sex,Age,HospDesc,RegDate,PaperNumber,Money,CreateUser)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	if (ind>1){
		Set SumMoney = $fn(SumMoney,"",2)
		Set Data=$lb(ind,"","","合计：","","","","","",SumPaper,SumMoney,"")
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCopyDeailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCopyDeailExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCopyDeailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCopyDeailExecute ]
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
