/// 名称: DHCWMR.MFService.FeeRecordSrv
/// 描述: 病案收费相关服务
/// 编写者：liyi
/// 编写日期: 2015-08-29
Class DHCWMR.MFService.FeeRecordSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-10-11
/// Description:  检查用户能否收费(计费收费)
/// Table：       DHCWMR.MF.FeeRecord
/// Input：       
/// Return：      返回%Id()值
/// w ##class(DHCWMR.MFService.FeeRecordSrv).CheckInsertMedical("","")
ClassMethod CheckInsertMedical(FeeItemCode As %String, aFeeInfo As %String) As %String
{
	New (FeeItemCode,aFeeInfo)
	Set return=1
	Quit:(FeeItemCode="")||(aFeeInfo="") return
		
	Set PayModeID=$p(aFeeInfo,"^",1)   //支付方式
	Set UserID=$p(aFeeInfo,"^",2)      //用户ID
	Set LocID=$p(aFeeInfo,"^",3)       //科室ID
	Set GroupID=$p(aFeeInfo,"^",4)     //安全组ID
	Quit:(PayModeID="")||(UserID="")||(LocID="")||(GroupID="") return
	
	//收费方式，0不收费、1病案收费、2计费收费
	Set HospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(LocID)
	If FeeItemCode="FY" {
		Set MFFeeType=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MFFeeTypeByCopy",HospID)
		Set MFFeeType=+MFFeeType
	} ElseIf FeeItemCode="JD" {
		Set MFFeeType=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MFFeeTypeByReceipt",HospID)
		Set MFFeeType=+MFFeeType
	}
	
	if MFFeeType=2 {
		Set InvNo=##class(DHCWMR.IO.FromFeeSrv).GetReceiptNOByUser(UserID,HospID)
		Set:InvNo="" return=0 //该用户没有可用的发票号
	}
	set:return=0 return=0_"^您没有可用的收费发票号,请联系相关管理员发放发票号！"
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-10-11
/// Description:  保存病案收费记录
/// Table：       DHCWMR.MF.FeeRecord
/// Input：       aMainInfo ：病案类型^病案号^收费代码^总金额^支付方式^用户^科室^安全组^医院ID
///               aDtlInfo  ：收费项^单项总金额^数量
/// Return：      返回%Id()值
/// w ##class(DHCWMR.MFService.FeeRecordSrv).SaveFeeInfo("","")
ClassMethod SaveFeeInfo(aMainInfo As %String, aDtlInfo As %String, aIsPrtBill As %String = 0) As %String
{
	New (aMainInfo,aDtlInfo,aIsPrtBill)
	Set return=0,flg=1
	Quit:(aMainInfo="")||(aDtlInfo="")||(aIsPrtBill="") return
	
	Set $ZT="SaveFeeRecordErr"
	
	Set MainID=$p(aMainInfo,"^",1)      //病案ID
	Set FeeItemID=$p(aMainInfo,"^",2)   //收费项
	Set Price=+$p(aMainInfo,"^",3)      //总金额
	Set PayModeID=$p(aMainInfo,"^",4)   //支付方式
	Set UserID=$p(aMainInfo,"^",5)      //用户ID
	Set LocID=$p(aMainInfo,"^",6)       //科室ID
	Set GroupID=$p(aMainInfo,"^",7)     //安全组ID
	Quit:(MainID="")||(PayModeID="") return
	Quit:(UserID="")||(LocID="")||(GroupID="") return
	
	Set objMain=##class(DHCWMR.SS.Main).GetObjById(MainID)
	Quit:'$IsObject(objMain) return
	Quit:'$IsObject(objMain.SMMrType) return
	Set MrTypeID=objMain.SMMrType.%Id()
	Set MrNo = objMain.SMMrNo
	
	//如果总金额为0，通过明细算合计
	If Price=0 {
		For indD=1:1:$l(aDtlInfo,"$") {
			Set xFeeSub=$p(aDtlInfo,"$",indD)
			Continue:xFeeSub=""
			Set SubPrice=+$p(xFeeSub,"^",2)
			Set Price=Price+SubPrice
		}
	}
	
	Set objFeeItem=##Class(DHCWMR.MF.FeeItem).GetObjById(FeeItemID)
	Quit:'$IsObject(objFeeItem) return
	Set FeeItemCode=objFeeItem.FICode
	
	//收费方式，0不收费、1病案收费、2计费收费
	Set HospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(LocID)
	If FeeItemCode="FY" {
		Set MFFeeType=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MFFeeTypeByCopy",HospID)
		Set MFFeeType=+MFFeeType
	} ElseIf FeeItemCode="JD" {
		Set MFFeeType=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MFFeeTypeByReceipt",HospID)
		Set MFFeeType=+MFFeeType
	}
	
	TStart
	
	Set InvprtDr=""
	Set return="-1^保存收费记录错误"
	If (MFFeeType=2) {
		Set PatientID=##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(MrNo,MrTypeID)
		Quit:PatientID="" return
		
		//保存计费表
		Set PrtInfo=PatientID				//病人信息表ID
		Set PrtInfo=PrtInfo_"^"_Price		//收据金额
		Set PrtInfo=PrtInfo_"^"_PayModeID	//支付方式指针(默认现金1)
		Set PrtInfo=PrtInfo_"^"_UserID	    //收费员
		Set PrtInfo=PrtInfo_"^"_"P"			//票据打印标志
		Set PrtInfo=PrtInfo_"^"_LocID		//用户所在科室
		Set PrtInfo=PrtInfo_"^"_GroupID		//安全组
		
		Set DtlInfo=""
		For indD=1:1:$l(aDtlInfo,"$") {
			Set xFeeSub=$p(aDtlInfo,"$",indD)
			Continue:xFeeSub=""
			Set TarItemDr=$p(xFeeSub,"^",1)
			Set SubPrice=+$p(xFeeSub,"^",2)
			Set SubNumber=+$p(xFeeSub,"^",3)
			Set DtlInfo=DtlInfo_"$"_TarItemDr_"^"_SubPrice_"^"_SubNumber
		}
		Set:DtlInfo'="" DtlInfo=$e(DtlInfo,2,$l(DtlInfo))
		Quit:DtlInfo="" return
		
		Set flg=##class(DHCWMR.IO.FromFeeSrv).InsertMedical(PrtInfo,DtlInfo,HospID)
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
		Set InvprtDr=+flg
	} Else {
		Set InvprtDr=""
	}
	
	//病案收费表
	Set return="-2^保存病案收费主表错误"
	Set InputStr=""
	Set InputStr=InputStr_"^"_MrTypeID
	Set InputStr=InputStr_"^"_MainID
	Set InputStr=InputStr_"^"_FeeItemID
	Set InputStr=InputStr_"^"_InvprtDr
	Set InputStr=InputStr_"^"_"N"
	Set InputStr=InputStr_"^"_+$h
	Set InputStr=InputStr_"^"_+$p($h,",",2)
	Set InputStr=InputStr_"^"_UserID
	Set InputStr=InputStr_"^"_LocID
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_Price
	Set flg=##class(DHCWMR.MF.FeeRecord).Update(InputStr,"^")
	If (+flg)<1 Trollback
	Quit:(+flg)<1 return
	Set FRecordID=+flg
	
	Set return="-3^保存病案收费子表错误"
	Set IsError=0
	For indD=1:1:$l(aDtlInfo,"$") {
		Set xFeeSub=$p(aDtlInfo,"$",indD)
		Continue:xFeeSub=""
		Set TarItemDr=$p(xFeeSub,"^",1)
		Set SubPrice=+$p(xFeeSub,"^",2)
		Set SubNumber=+$p(xFeeSub,"^",3)
		Set InputStr=FRecordID_"^"_""_"^"_TarItemDr_"^"_SubPrice_"^"_SubNumber
		Set flg=##class(DHCWMR.MF.FeeRecordDtl).Update(InputStr,"^")
		If (+flg)<1 {
			Set IsError=1
			Trollback
			Quit
		}
	}
	Quit:IsError>0 return
	
	TCommit
	
	Set return=FRecordID
	Quit return
	
SaveFeeRecordErr
	If (+flg)<1 Trollback
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-10-11
/// Description:  保存病案收费退费记录
/// Table：       DHCWMR.MF.FeeRecord
/// Input：       aFRecordID ：收费记录
///               aUserID  ：操作员
///               aLocID  ：操作员科室
/// Return：      return>0:成功   return<=0:失败
/// w ##class(DHCWMR.MFService.FeeRecordSrv).RetFeeInfo("","","")
ClassMethod RetFeeInfo(aFRecordID As %String, aUserID As %String, aLocID As %String) As %String
{
	New (aFRecordID,aUserID,aLocID)
	Set return=0,flg=1
	Quit:(aFRecordID="")||(aUserID="")||(aLocID="") return
	
	Set $ZT="RetFeeInfoErr"
	
	Set objFRecord=##Class(DHCWMR.MF.FeeRecord).GetObjById(aFRecordID)
	Quit:'$IsObject(objFRecord) return
	Quit:'$IsObject(objFRecord.FRMainDr) return
	Quit:objFRecord.FRStatus'="N" return
	Set InvprtDr=objFRecord.FRInvprtDr
	Quit:'$IsObject(objFRecord.FRFeeItemDr) return
	Set FeeItemDr=objFRecord.FRFeeItemDr.%Id()
	
	TStart
	
	If InvprtDr'="" {
		Set return="-1^保存退费记录错误"
		Set flg=##class(DHCWMR.IO.FromFeeSrv).Refund(InvprtDr,aUserID)
		If flg'=0 Trollback
		Quit:flg'=0 return
	}
	
	Set return="-2^保存病案退费记录错误"
	Set InputStr=objFRecord.%Id()
	Set InputStr=InputStr_"^"_objFRecord.FRMrTypeDr.%Id()
	Set InputStr=InputStr_"^"_objFRecord.FRMainDr.%Id()
	Set InputStr=InputStr_"^"_FeeItemDr
	Set InputStr=InputStr_"^"_objFRecord.FRInvprtDr
	Set InputStr=InputStr_"^"_"C"
	Set InputStr=InputStr_"^"_objFRecord.FRFeeDate
	Set InputStr=InputStr_"^"_objFRecord.FRFeeTime
	Set InputStr=InputStr_"^"_objFRecord.FRFeeUserID
	Set InputStr=InputStr_"^"_objFRecord.FRFeeLocID
	Set InputStr=InputStr_"^"_+$h
	Set InputStr=InputStr_"^"_$p($h,",",2)
	Set InputStr=InputStr_"^"_aUserID
	Set InputStr=InputStr_"^"_aLocID
	Set InputStr=InputStr_"^"_objFRecord.FRMoney
	Set flg=##class(DHCWMR.MF.FeeRecord).Update(InputStr,"^")
	If (+flg)<1 Trollback
	Quit:(+flg)<1 return
	Set FRecordID=+flg
	
	TCommit
	
	Set return=1
	Quit return
	
RetFeeInfoErr
	If (+flg)<1 Trollback
	Quit return
}

/// Creator：     李毅
/// CreatDate：   2015-08-31
/// Description:  通过医院，病案类型，病案收费项查询收费信息
/// Table：       DHCWMR.MF.FeeRecord
/// Input：       aHospID,aMrType,aFeeItemID,aDateFrom,aDateTo
/// output:       收费列表
/// D ##class(%ResultSet).RunQuery("DHCWMR.MFService.FeeRecordSrv","QryFeeRecord","2","6","1","2015-11-25","2015-11-25")
Query QryFeeRecord(aHospID As %String, aMrType As %String, aFeeItemID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ID:%String,PatName:%String,MrTypeID:%String,MrTypeDesc:%String,MrNo:%String,FeeItemID:%String,FeeItemCode:%String,FeeItemDesc:%String,Status:%String,StatusDesc:%String,FeeDate:%String,FeeTime:%String,FeeUserDesc:%String,FeeLocDesc:%String,RetDate:%String,RetTime:%String,RetUserDesc:%String,RetLocDesc:%String,Money:%String,InvNo:%String")
{
}

ClassMethod QryFeeRecordExecute(ByRef qHandle As %Binary, aHospID As %String, aMrType As %String, aFeeItemID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	//Set ^LIYI=$lb(aHospID,aMrType,aFeeItemID,aDateFrom,aDateTo)
	
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aHospID="")||(aMrType="")||(aDateFrom="")||(aDateTo="") $$$OK
	
	Set:aHospID'="" aHospID=","_aHospID_","
	
	For xDate=aDateFrom:1:aDateTo {
		Set xID=""
		For {
			Set xID=$o(^DHCWMR.MF.FeeRecordI("IndexFeeDate",xDate,xID))
			Quit:xID=""
			
			Set Data=..BuildFeeData(xID)
			Continue:Data=""
			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryFeeRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFeeRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryFeeRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFeeRecordExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2015-12-9
/// Description:  查询复印记录对应收费记录
/// Table：       DHCWMR.MO.CopyRecord、DHCWMR.MF.FeeRecord
/// Input：       aCopyID ：复印记录ID
/// output:       收费列表
/// D ##class(%ResultSet).RunQuery("DHCWMR.MFService.FeeRecordSrv","QryFeeByCopyID","")
Query QryFeeByCopyID(aCopyID As %String) As %Query(ROWSPEC = "ID:%String,PatName:%String,MrTypeID:%String,MrTypeDesc:%String,MrNo:%String,FeeItemID:%String,FeeItemCode:%String,FeeItemDesc:%String,Status:%String,StatusDesc:%String,FeeDate:%String,FeeTime:%String,FeeUserDesc:%String,FeeLocDesc:%String,RetDate:%String,RetTime:%String,RetUserDesc:%String,RetLocDesc:%String,Money:%String,InvNo:%String")
{
}

ClassMethod QryFeeByCopyIDExecute(ByRef qHandle As %Binary, aCopyID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Set objCopy=##class(DHCWMR.MO.CopyRecord).GetObjById(aCopyID)
	Quit:'$IsObject(objCopy) $$$OK
	
	Set aMrType=objCopy.CRMrType.%Id()
	Set aFeeItemID=""
	Set xFeeSub=""
	For {
		Set xFeeSub=$o(^DHCWMR.MO.CopyRecordD(aCopyID,"FEE",xFeeSub))
		Quit:xFeeSub=""
		
		Set objCopyFee=##class(DHCWMR.MO.CopyRecordFee).GetObjById(aCopyID_"||"_xFeeSub)
		Continue:'$IsObject(objCopyFee)
		
		Set MFRecordID=objCopyFee.CRFRecordDr.%Id()
		Set Data = ..BuildFeeData(MFRecordID)
		Continue:Data=""
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryFeeByCopyIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFeeByCopyIDExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryFeeByCopyIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFeeByCopyIDExecute ]
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

ClassMethod BuildFeeData(aMFRecordID As %String) As %List
{
	Set return=""
	Quit:aMFRecordID="" return
	
	Set objFeeRecord = ##class(DHCWMR.MF.FeeRecord).GetObjById(aMFRecordID)
	Quit:'$IsObject(objFeeRecord) return
	Quit:'$IsObject(objFeeRecord.FRMainDr) return
	Quit:'$IsObject(objFeeRecord.FRFeeItemDr) return
	
	Set MrTypeID=objFeeRecord.FRMrTypeDr.%Id()
	Quit:(aMrType'="")&&(aMrType'=MrTypeID) return
	Set MrTypeDesc=objFeeRecord.FRMrTypeDr.MTDesc
	Set MrNo=objFeeRecord.FRMainDr.SMMrNo
	
	Set FeeItemID=objFeeRecord.FRFeeItemDr.%Id()
	Quit:(aFeeItemID'="")&&(aFeeItemID'=FeeItemID) return
	Set FeeItemCode=objFeeRecord.FRFeeItemDr.FICode
	Set FeeItemDesc=objFeeRecord.FRFeeItemDr.FIDesc
	
	Set Status 		= objFeeRecord.FRStatus
	Set StatusDesc  = ""
	Set:Status="N" StatusDesc = "收费"
	Set:Status="C" StatusDesc = "退费"
	Set FeeDate		= objFeeRecord.FRFeeDate
	Set:FeeDate'="" FeeDate = ##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(FeeDate)
	Set FeeTime		= objFeeRecord.FRFeeTime
	Set:FeeTime'="" FeeTime = $zt(FeeTime)
	Set FeeUserID	= objFeeRecord.FRFeeUserID
	Set FeeUserDesc = ""
	Set:FeeUserID'="" FeeUserDesc = $p($g(^SSU("SSUSR",+FeeUserID)),"^",2)
	Set FeeLocID	= objFeeRecord.FRFeeLocID,FeeLocDesc = ""
	Set objLoc=##class(DHCWMR.Base.Ctloc).GetObjById(+FeeLocID)
	Set:$IsObject(objLoc) FeeLocDesc=objLoc.Descs
	Set:FeeLocDesc["-" FeeLocDesc=$p(FeeLocDesc,"-",2)
	Set RetDate		= objFeeRecord.FRRetDate
	Set:RetDate'="" RetDate = ##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(RetDate)
	Set RetTime		= objFeeRecord.FRRetTime
	Set:RetTime'="" RetTime = $zt(RetTime)
	Set RetUserID	= objFeeRecord.FRRetUserID
	Set RetUserDesc = ""
	Set:RetUserID'="" RetUserDesc = $p($g(^SSU("SSUSR",+RetUserID)),"^",2)
	Set RetLocID	= objFeeRecord.FRRetLocID
	Set objLoc = ##class(DHCWMR.Base.Ctloc).GetObjById(+RetLocID)
	Set RetLocDesc = ""
	Set:$IsObject(objLoc) RetLocDesc=objLoc.Descs
	Set Money		= $fn(objFeeRecord.FRMoney,"",2)
	Set PatientID = ##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(MrNo,aMrType)
	Set PatName = ""
	If PatientID'=""{
		Set objPat = ##class(DHCWMR.Base.Patient).GetObjById(PatientID)
		Set:$IsObject(objPat) PatName=objPat.PatientName
	}
	Else {
		Set FRMainID = objFeeRecord.FRMainDr.%Id()
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",FRMainID,xVolID))
			Quit:xVolID=""
			Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
			Continue:'$IsObject(objVol)
			Set xSubID=$o(^DHCWMR.SS.VolumeD(xVolID,"P",0))
			Continue:xSubID=""
			Set objVolPaadm=##class(DHCWMR.SS.VolPaadm).GetObjById(xVolID_"||"_xSubID)
			Continue:'$IsObject(objVolPaadm)
			Set PatName = objVolPaadm.VPPatName
		}
	}
	Set InvNo=""
	Set InvprtDr=objFeeRecord.FRInvprtDr
	Set:+InvprtDr'=0 InvNo=$p($g(^DHCINVPRTMEDICAL(InvprtDr)),"^",3) 	//发票号
	
	Set return = $lb(aMFRecordID,PatName,MrTypeID,MrTypeDesc,MrNo,FeeItemID,FeeItemCode,FeeItemDesc,Status,StatusDesc,FeeDate,FeeTime,FeeUserDesc,FeeLocDesc,RetDate,RetTime,RetUserDesc,RetLocDesc,Money,InvNo)
	Quit return
}

}
