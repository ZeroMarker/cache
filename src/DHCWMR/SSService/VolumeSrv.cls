/// 名称: DHCWMR.SSService.VolumeSrv
/// 描述: 病案卷相关服务
/// 编写者：zhufei
/// 编写日期: 2014-12-30
Class DHCWMR.SSService.VolumeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2015-03-31
/// Description:  根据身份证号、病案类型ID取已存在的卷信息ID,病人ID
/// Table：       DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       aIdentityCode : 身份证号码
/// 			  aMrTypeID : DHCWMR.SS.MrType.ID
/// return：	  VolumeID^Papmi_dr
/// w ##class(DHCWMR.SSService.VolumeSrv).GetPatByIdentityCode("511024199302012231",6)
ClassMethod GetPatByIdentityCode(aIdentityCode As %String, aMrTypeID As %String) As %String
{
	New (aIdentityCode,aMrTypeID)
	Set return = ""
	Quit:(aIdentityCode="")||(aMrTypeID="") return
	
	Set objMrType = ##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) return
	
	Set ReceiptType=""
	If $IsObject(objMrType.MTReceiptType) {
		Set ReceiptType=objMrType.MTReceiptType.SDCode
	}
	Quit:ReceiptType="" return
	
	If ReceiptType="M"{
		Set xVolID =""
		For {
				Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexIdentityCode"," "_aIdentityCode,xVolID))
				Quit:xVolID=""
				
				Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
				Continue:'$IsObject(objVol)
				Continue:objVol.SVIsActive'=1
				Continue:'$IsObject(objVol.SVMainDr)
				Continue:objVol.SVMainDr.SMIsActive'=1
				Continue:objVol.SVMainDr.SMMrType.%Id()'=aMrTypeID
				
				Set xSubID=$o(^DHCWMR.SS.VolumeI("VP","IndexIdentityCode"," "_aIdentityCode,xVolID,0))
				Continue:xSubID=""
				Set objVolPaadm=##class(DHCWMR.SS.VolPaadm).GetObjById(xVolID_"||"_xSubID)
				Continue:'$IsObject(objVolPaadm)
				Set return = xVolID_"^"_objVolPaadm.VPPatientID
		}
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-11-22
/// Description:  根据EpisodeID取对应第几次住院
/// Table：       DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       EpisodeID : 就诊号
/// w ##class(DHCWMR.SSService.VolumeSrv).GetIPTimes(960366)
ClassMethod GetIPTimes(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set MrTypeID="",MrNo=""
	Set xVolID=""
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexEpisodeID"," "_aEpisodeID,xVolID))
		Quit:xVolID=""
		Quit:MrNo'=""
		
		Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		Set objMain=objVol.SVMainDr
		Continue:'$IsObject(objMain)
		Continue:objMain.SMIsActive'=1
		Set MrTypeID=objMain.SMMrType.%Id()
		Set MrNo=objMain.SMMrNo
	}
	Quit:(MrNo="")||(MrTypeID="") return
	
	Kill arrVolPaadm
	Set IPCount=0,MinTimes=0
	Set xMainID=0
	For {
		Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",MrTypeID," "_MrNo,1,xMainID))
		Quit:xMainID=""
		
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",xMainID,xVolID))
			Quit:xVolID=""
			
			Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
			Continue:'$IsObject(objVol)
			Continue:objVol.SVIsActive'=1
			Continue:'$IsObject(objVol.SVMainDr)
			Continue:objVol.SVMainDr.SMIsActive'=1
			Set VolumeID=objVol.%Id()
			Set IPTimes=objVol.SVIPTimes
			Set IPTimes=+IPTimes
			If (IPTimes>0) {
				Set:MinTimes=0 MinTimes=IPTimes
				Set:IPTimes<MinTimes MinTimes=IPTimes
			}
			Set IPCount=IPCount+1
			
			Set xAdmSub=0
			For {
				Set xAdmSub=$o(^DHCWMR.SS.VolumeD(xVolID,"P",xAdmSub))
				Quit:xAdmSub=""
				
				Set objPaadm=##Class(DHCWMR.SS.VolPaadm).GetObjById(xVolID_"||"_xAdmSub)
				Continue:'$IsObject(objPaadm)
				Set EpisodeID=objPaadm.VPEpisodeID
				Continue:EpisodeID=""
				Set VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
				Continue:VisitStatus="C"	//退院或取消就诊状态
				Set arrVolPaadm(EpisodeID)=VolumeID
			}
		}
	}
	
	If MinTimes>0 {
		Set IPTimes=MinTimes-1
	} Else {
		Set IPTimes=0
	}
	Set tmpVolumeID=""
	Set xEpisodeID=""
	For {
		Set xEpisodeID=$o(arrVolPaadm(xEpisodeID))
		Quit:xEpisodeID=""
		
		If $g(arrVolPaadm(xEpisodeID))'=tmpVolumeID {
			Set IPTimes=IPTimes+1
			Set tmpVolumeID=$g(arrVolPaadm(xEpisodeID))
		}
		Quit:xEpisodeID=aEpisodeID  //计算到当前就诊结束
	}
	Set return=IPTimes
	Kill arrVolPaadm
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据病案号取住院次数
/// Table：       DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       MrTypeID : 病案类型
///               MrNo : 病案号
/// w ##class(DHCWMR.SSService.VolumeSrv).GetIPCount()
ClassMethod GetIPCount(aMrTypeID As %String, aMrNo As %String) As %String
{
	New (aMrTypeID,aMrNo)
	Set return=""
	Quit:(aMrTypeID="")||(aMrNo="") return
	
	Set IPCount=0,MinTimes=0
	Set xMainID=0
	For {
		Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_aMrNo,1,xMainID))
		Quit:xMainID=""
		
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",xMainID,xVolID))
			Quit:xVolID=""
			
			Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
			Continue:'$IsObject(objVol)
			Continue:objVol.SVIsActive'=1
			Continue:'$IsObject(objVol.SVMainDr)
			Continue:objVol.SVMainDr.SMIsActive'=1
			Set VolumeID=objVol.%Id()
			Set IPTimes=objVol.SVIPTimes
			Set IPTimes=+IPTimes
			If (IPTimes>0) {
				Set:MinTimes=0 MinTimes=IPTimes
				Set:IPTimes<MinTimes MinTimes=IPTimes
			}
			Set IPCount=IPCount+1
		}
	}
	If MinTimes>0 {
		Set return=IPCount+MinTimes-1
	} Else {
		Set return=IPCount
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-31
/// Description:  根据EpisodeID取病案卷状态列表
/// Table：       DHCWMR.SS.Volume、DHCWMR.SS.VolStatus
/// Input：       EpisodeID : 就诊号
/// Output:       返回String,$c(1) $c(2)分割
/// w ##class(DHCWMR.SSService.VolumeSrv).GetStatusByEpisodeID()
ClassMethod GetStatusByEpisodeID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
	Quit:'$IsObject(objVol) return
	
	For indStatus=1:1:objVol.ChildStatus.Count() {
		Set objStatus=objVol.ChildStatus.GetAt(indStatus)
		Continue:'$IsObject(objStatus)
		Continue:'$IsObject(objStatus.VSStatus)
		Continue:objStatus.VSUpdoOpera="U"  //作废状态
		
		Set VStatusID=objStatus.%Id()
		Set StatusID=objStatus.VSStatus.%Id()
		Set StatusDesc=objStatus.VSStatus.WIDesc
		Set ActDate=objStatus.VSActDate
		Set:ActDate'="" ActDate=$zd(ActDate,3)
		Set ActTime=objStatus.VSActTime
		Set:ActTime'="" ActTime=$zt(ActTime,2)
		Set UserFrom=objStatus.VSUserFrom
		Set:UserFrom'="" UserFrom=$p($g(^SSU("SSUSR",+UserFrom)),"^",2)
		Set UserTo=objStatus.VSUserTo
		Set:UserTo'="" UserTo=$p($g(^SSU("SSUSR",+UserTo)),"^",2)
		Set BatchNumber=objStatus.VSBatchNumber
		Set UpdoOpera=objStatus.VSUpdoOpera
		Set UpdoDate=objStatus.VSUpdoDate
		Set:UpdoDate'="" UpdoDate=$zd(UpdoDate,3)
		Set UpdoTime=objStatus.VSUpdoTime
		Set:UpdoTime'="" UpdoTime=$zt(UpdoTime,2)
		Set UpdoUser=objStatus.VSUpdoUser
		Set:UpdoUser'="" UpdoUser=$p($g(^SSU("SSUSR",+UpdoUser)),"^",2)
		Set UpdoReason=objStatus.VSUpdoReason
		
		Set:return'="" return=return_$c(1)
		Set return=return_VStatusID
		Set return=return_$c(2)_StatusDesc
		Set return=return_$c(2)_ActDate
		Set return=return_$c(2)_ActTime
		Set return=return_$c(2)_UserFrom
		Set return=return_$c(2)_UserTo
		Set return=return_$c(2)_BatchNumber
		Set return=return_$c(2)_UpdoOpera
		Set return=return_$c(2)_UpdoDate
		Set return=return_$c(2)_UpdoTime
		Set return=return_$c(2)_UpdoUser
		Set return=return_$c(2)_UpdoReason
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据就诊号取病案回收状态
/// Input：       EpisodeID : 就诊号
/// Return：      return=1:回收  return=0:未回收 return<0:其他
/// 替换方法：w ##class(DHCWMR.SSService.VolumeSrv).GetFinishStatus(10072558,"S")
ClassMethod GetFinishStatus(aEpisodeID As %String, aSysOpera As %String) As %String
{
	New (aEpisodeID,aSysOpera)
	Set return=-1
	Quit:(aEpisodeID="")||(aSysOpera="") return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
	Quit:'$IsObject(objVol) return
	Quit:'$IsObject(objVol.SVMainDr) return
	Quit:'$IsObject(objVol.SVMainDr.SMMrType) return
	Set MrTypeID=objVol.SVMainDr.SMMrType.%Id()
	
	Set return=0
	For indStatus=1:1:objVol.ChildStatus.Count() {
		Set objStatus=objVol.ChildStatus.GetAt(indStatus)
		Continue:'$IsObject(objStatus)
		Continue:'$IsObject(objStatus.VSStatus)
		Continue:objStatus.VSUpdoOpera'=""  //作废状态、回置状态
		
		Set StatusID=objStatus.VSStatus.%Id()
		Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(MrTypeID,StatusID)
		Continue:'$IsObject(objWFItem)
		Continue:objWFItem.WFISysOpera'=aSysOpera
		
		//update by zf 20150403 非顺序流程不参与流程控制
		If objWFItem.WFISubFlow="O" {
			//Continue:objWFItem.WFIPostStep'=objVol.SVOrdStep
		}
		Set return=1
		Quit
	}
	
	Quit return
}

/// Creator:      zhufei
/// CreateDate:   2015-01-28
/// Description:  检查卷是否完成某状态
/// Input:        VolID : 卷ID
///               WorkItemID : 操作项目ID
/// Return：      return<=0:失败  return=1:回滚  return=2:执行
/// 替换方法：w ##class(DHCWMR.SSService.VolumeSrv).CheckStatus()
ClassMethod CheckStatus(aVolumeID As %String, aWorkItemID As %String) As %String
{
	new (aVolumeID,aWorkItemID)
	set return=0
	quit:(aVolumeID="")||(aWorkItemID="") return
	
	set xMrCateg=""
	for {
		set xMrCateg=$o(^DHCWMR.SS.VolumeI("VS","IndexStatusCate",aVolumeID,xMrCateg))
		quit:xMrCateg=""
		set xSubID=0
		for {
			set xSubID=$o(^DHCWMR.SS.VolumeI("VS","IndexStatusCate",aVolumeID,xMrCateg,aWorkItemID,xSubID))
			quit:xSubID=""
			
			set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(aVolumeID_"||"_xSubID)
			continue:'$IsObject(objStatus)
			continue:'$IsObject(objStatus.VSStatus)
			continue:objStatus.VSUpdoOpera="U"  //作废状态
			
			if objStatus.VSUpdoOpera="B" {  //回滚状态
				set return=1
			} else {  //正常状态
				set return=2
				quit //退出
			}
		}
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-03-18
/// Description:  根据病案ID或卷ID取条码信息
/// Table：       DHCWMR.SS.Volume、DHCWMR.SS.Volume
/// Input：       
/// w ##class(DHCWMR.SSService.VolumeSrv).GetBarInfo("33326,33327")
ClassMethod GetBarInfo(aVolumeIDs As %String) As %String
{
	New (aVolumeIDs)
	Set return=""
	Quit:(aVolumeIDs="") return
	
	Kill arrBarcodeInfo
	For indVol=1:1:$l(aVolumeIDs,",") {
		Set VolumeID=$p(aVolumeIDs,",",indVol)
		Continue:VolumeID=""
		
		Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(VolumeID)
		Continue:'$IsObject(objVol)
		Continue:'$IsObject(objVol.SVMainDr)
		Continue:'$IsObject(objVol.SVMainDr.SMMrType)
		Set MainID=objVol.SVMainDr.%Id()
		Continue:MainID=""
		Set MrTypeDesc=objVol.SVMainDr.SMMrType.MTDesc
		Set MrNo=objVol.SVMainDr.SMMrNo
		Set Marker=objVol.SVMainDr.SMMarker
		Set:Marker'="" MrNo=MrNo_"("_Marker_")"
		
		Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(VolumeID)
		Continue:VolAdmStr=""
		Set VolAdmID=$p(VolAdmStr,",",1)
		
		Set objVolAdm=##Class(DHCWMR.SS.VolPaadm).GetPatObjByAdm("","",VolAdmID)
		Continue:'$IsObject(objVolAdm)
		Set PatientID=objVolAdm.VPPatientID
		Set EpisodeID=objVolAdm.VPEpisodeID
		If EpisodeID'="" {
			Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
			Set VisitStatus=$p($g(^PAADM(+EpisodeID)),"^",20)
			Continue:VisitStatus="C"
		}
		Set PatName=objVolAdm.VPPatName
		Set Sex=objVolAdm.VPSex
		Set Birthday=objVolAdm.VPBirthday
		Set IdentityCode=objVolAdm.VPIdentityCode
		Set Age=objVolAdm.VPAge
		Set ManName=objVolAdm.VPManName  //男方姓名，门诊病案用
		
		Set AdmitDate=objVolAdm.VPAdmitDate
		Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
		Set DischDate=objVol.SVDischDate  //fix bug 178903 打印在病案操作重写出院日期之前，取卷表的出院日期
		Set:DischDate'="" DischDate=$zd(DischDate,3)
	    Set AdmLoc=objVolAdm.VPAdmitDept
		Set AdmLocDesc=objVolAdm.VPAdmitDeptDesc
		Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
	    Set AdmWard=objVolAdm.VPAdmitWard
		Set AdmWardDesc=objVolAdm.VPAdmitWardDesc
		Set:AdmWardDesc["-" AdmWardDesc=$p(AdmWardDesc,"-",2)
	    Set DischDept=objVolAdm.VPDischDept
		Set DischDeptDesc=objVolAdm.VPDischDeptDesc
		Set:DischDeptDesc["-" DischDeptDesc=$p(DischDeptDesc,"-",2)
	    Set DischWard=objVolAdm.VPDischWard
		Set DischWardDesc=objVolAdm.VPDischWardDesc
		Set:DischWardDesc["-" DischWardDesc=$p(DischWardDesc,"-",2)
		Set:DischDept'="" AdmLoc=DischDept
		Set:DischDeptDesc'="" AdmLocDesc=DischDeptDesc
		Set:DischWard'="" AdmWard=DischWard
		Set:DischWardDesc'="" AdmWardDesc=DischWardDesc
	    
	    Set MBarcode=""
		Set $p(MBarcode,"0",11-$l(MainID)+1)=MainID
		Set MBarcode="01"_MBarcode
		
	    Set VBarcode=""
		Set $p(VBarcode,"0",11-$l(VolumeID)+1)=VolumeID
		Set VBarcode="02"_VBarcode
	    
	    Set MBarcode=MBarcode_"^"_MrTypeDesc_"^"_MrNo_"^"_PatName_"^"_Sex_"^"_Birthday_"^"_Age_"^"_ManName
	    Set VBarcode=VBarcode_"^"_AdmLocDesc_"^"_AdmWardDesc_"^"_DischDate_"^"_AdmitDate
    	
		Set arrBarcodeInfo(MainID)=MBarcode
		Set arrBarcodeInfo(MainID,VolumeID)=VBarcode
	}
	
	Set xMainID=0
	For {
		Set xMainID=$o(arrBarcodeInfo(xMainID))
		Quit:xMainID=""
		
		Set MBarcode=$g(arrBarcodeInfo(xMainID))
		Set VBarcode=""
		Set xVolID=0
		For {
			Set xVolID=$o(arrBarcodeInfo(xMainID,xVolID))
			Quit:xVolID=""
			Set tmpBarcode=$g(arrBarcodeInfo(xMainID,xVolID))
			Continue:tmpBarcode=""
			Set VBarcode=VBarcode_$c(2)_tmpBarcode
		}
		
		Set return=return_$c(1)_MBarcode_VBarcode
	}
	Set:return'="" return=$e(return,2,$l(return))
	Kill arrBarcodeInfo
	
	Quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2016-03-14
/// Description:  根据就诊号取病案回收日期(首次回收)
/// Input：       EpisodeID : 就诊号
/// Return：      return=1:回收  return=0:未回收 return<0:其他
/// w ##class(DHCWMR.SSService.VolumeSrv).GetBackDate(13585285,"RC")
ClassMethod GetBackDate(aEpisodeID As %String, aSysOpera As %String = "RC") As %String
{
	New (aEpisodeID,aSysOpera)
	Set return=""
	Quit:(aEpisodeID="")||(aSysOpera="") return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
	Quit:'$IsObject(objVol) return
	Quit:'$IsObject(objVol.SVMainDr) return
	Quit:'$IsObject(objVol.SVMainDr.SMMrType) return
	Set MrTypeID=objVol.SVMainDr.SMMrType.%Id()
	
	For indStatus=1:1:objVol.ChildStatus.Count() {
		Set objStatus=objVol.ChildStatus.GetAt(indStatus)
		Continue:'$IsObject(objStatus)
		Continue:'$IsObject(objStatus.VSStatus)
		continue:objStatus.VSUpdoOpera'=""  //作废状态
		Quit:return'=""	
		
		Set StatusID=objStatus.VSStatus.%Id()
		Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(MrTypeID,StatusID)
		Continue:'$IsObject(objWFItem)
		
		Continue:objWFItem.WFISubFlow'="O" 
		Continue:objWFItem.WFISysOpera'=aSysOpera
		Set return=objStatus.VSActDate_" "_objStatus.VSActTime	//操作日期
		
	}
	
	Quit return
}

}
