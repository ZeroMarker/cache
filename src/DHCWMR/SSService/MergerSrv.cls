/// 名称: DHCWMR.SSService.MergerSrv
/// 描述: 病案合并、拆分、修改号码相关服务
/// 编写者：zhufei
/// 编写日期: 2014-12-05
Class DHCWMR.SSService.MergerSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-12-05
/// Description:  通过病案号，病案类型ID，医院ID查看号码下是否有病案卷
/// Input：       MrTypeID：病案类型ID
///               FromMrNo：旧病案号
///               VolumeIDs：卷列表
///               ToMrNo:新病案号
/// Return:		  return>0:成功
/// Debug:		  w ##class(DHCWMR.SSService.MergerSrv).MergerMrNo("7","1071140","265815","732829","4479")
ClassMethod MergerMrNo(aMrTypeID As %String, aFromMrNo As %String, aVolumeIDs As %String, aToMrNo As %String, aUserID As %String) As %String
{
	new (aMrTypeID,aFromMrNo,aVolumeIDs,aToMrNo,aUserID)
	Set return="0^参数错误"
	Quit:(aMrTypeID="")||(aFromMrNo="")||(aVolumeIDs="")||(aToMrNo="")||(aUserID="") return
	
	//Set ^ZF=$lb(aMrTypeID,aFromMrNo,aVolumeIDs,aToMrNo,aUserID)
	
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) return
	Set NoFiled=""
	If $IsObject(objMrType.MTNoFiled) {
		Set NoFiled=objMrType.MTNoFiled.SDCode
	}
	Set RecycleType=objMrType.MTRecycleType
	Set IsBWMrNo=objMrType.MTIsBWMrNo
	//Quit:(RecycleType=0)&&(NoFiled'="") return  //udpate by zf 20150403
	
	Set aFromMrNo=##Class(DHCWMR.SSService.CommonSrv).ChangeMrNo(aFromMrNo)
	Set aToMrNo=##Class(DHCWMR.SSService.CommonSrv).ChangeMrNo(aToMrNo)
	Quit:(aFromMrNo="")||(aToMrNo="") return

	Set VolumeList=""
	Set FromVolumeIDs=""
	For indVol=1:1:$l(aVolumeIDs,",") {
		Set VolumeID=$p(aVolumeIDs,",",indVol)
		Continue:VolumeID=""
		Set VolumeList=VolumeList_$lb(VolumeID)
		Set FromVolumeIDs=FromVolumeIDs_"#"_VolumeID
	}

	Quit:VolumeList="" return
	Set:FromVolumeIDs'="" FromVolumeIDs=$e(FromVolumeIDs,2,$l(FromVolumeIDs))
	
	Set FromMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_aFromMrNo,1,0))
	
	Quit:FromMainID="" return
	Set ToMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_aToMrNo,1,0))
	If ToMainID'="" {
		Set objMain=##Class(DHCWMR.SS.Main).GetObjById(ToMainID)
		Quit:'$IsObject(objMain) return
		Quit:'$IsObject(objMain.SMMrType) return
	}
	
	Set xVolID=0,VolCount=0,SelCount=0
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",FromMainID,xVolID))
		Quit:xVolID=""
		
		Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1  //卷无效
		Set objMain=objVol.SVMainDr
		Continue:'$IsObject(objMain)
		Continue:objMain.SMIsActive'=1  //病案无效
		
		Set VolCount=VolCount+1
		
		Continue:$listfind(VolumeList,xVolID)<1
		Set SelCount=SelCount+1
	}
	Quit:SelCount<$listlength(VolumeList) return
	
	TStart
	
	Set return="-1^作废旧病案错误"
	Set objMain=##Class(DHCWMR.SS.Main).GetObjById(FromMainID)
	Quit:'$IsObject(objMain) return
	Quit:'$IsObject(objMain.SMMrType) return
	Set FromMainStr=""
	Set $p(FromMainStr,"^",1)=objMain.%Id()
	Set $p(FromMainStr,"^",2)=objMain.SMMrType.%Id()
	Set $p(FromMainStr,"^",3)=objMain.SMMrNo
	Set $p(FromMainStr,"^",4)=objMain.SMBuildDate
	Set $p(FromMainStr,"^",5)=objMain.SMBuildTime
	Set $p(FromMainStr,"^",6)=0
	Set $p(FromMainStr,"^",7)=objMain.SMResume
	Set $p(FromMainStr,"^",8)=objMain.SMMarker
	Set $p(FromMainStr,"^",9)=objMain.SMFileNo
	Set $p(FromMainStr,"^",10)=objMain.SMBarcode
	Set $p(FromMainStr,"^",11)=objMain.SMBuildUser
	Set $p(FromMainStr,"^",12)=objMain.SMFirstHosp
	Set $p(FromMainStr,"^",13)=objMain.SMFirstLoc
	Set $p(FromMainStr,"^",14)=objMain.SMFirstDoc
	Set $p(FromMainStr,"^",15)=objMain.SMFirstDate
	Set $p(FromMainStr,"^",16)=objMain.SMFirstAdm
	Set $p(FromMainStr,"^",17)=$s($IsObject(objMain.SMPatFrom):objMain.SMPatFrom.%Id(),1:"")
	Set $p(FromMainStr,"^",18)=$s($IsObject(objMain.SMEPPatFrom):objMain.SMEPPatFrom.%Id(),1:"")
	Set $p(FromMainStr,"^",19)=$s($IsObject(objMain.SMPatAdmStatus):objMain.SMPatAdmStatus.%Id(),1:"")
	Set $p(FromMainStr,"^",20)=objMain.SMInitMainDr
	If VolCount=$listlength(VolumeList) {
		Set InputStr=FromMainStr
		Set flg=##class(DHCWMR.SS.Main).Update(InputStr,"^")
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
	}
	
	Set return="-2^更新新病案错误"
	If ToMainID="" {
		Set InitMainDr=$p(FromMainStr,"^",1)
		Set InputStr=FromMainStr
		Set $p(InputStr,"^",1)=""
		Set $p(InputStr,"^",2)=aMrTypeID
		Set $p(InputStr,"^",3)=aToMrNo
		Set $p(InputStr,"^",6)=1
		Set $p(InputStr,"^",20)=InitMainDr
		Set flg=##class(DHCWMR.SS.Main).Update(InputStr,"^")
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
		Set ToMainID=+flg
	}
	
	Set return="-3^更新病案卷错误"
	Set IsError=0
	Set PatientList=""
	Set ToVolumeIDs=""
	For indVol=1:1:$listlength(VolumeList) {
		Set VolumeID=$list(VolumeList,indVol)
		Continue:VolumeID=""
		Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(VolumeID)
		Continue:'$IsObject(objVol)
		Continue:'$IsObject(objVol.SVStatus)
		
		Set ToVolumeIDs=ToVolumeIDs_"#"_VolumeID
		
		Set InputStr=VolumeID
		Set InputStr=InputStr_"^"_ToMainID
		Set InputStr=InputStr_"^"_objVol.SVStatus.%Id()
		Set InputStr=InputStr_"^"_objVol.SVOrdStep
		Set InputStr=InputStr_"^"_objVol.SVIsLend
		Set InputStr=InputStr_"^"_objVol.SVIsCopy
		Set InputStr=InputStr_"^"_objVol.SVIsStore
		Set InputStr=InputStr_"^"_objVol.SVQCLock
		Set InputStr=InputStr_"^"_objVol.SVDischDate
		Set InputStr=InputStr_"^"_objVol.SVBackDate
		Set InputStr=InputStr_"^"_objVol.SVIPTimes
		Set InputStr=InputStr_"^"_objVol.SVBuildDate
		Set InputStr=InputStr_"^"_objVol.SVBuildTime
		Set InputStr=InputStr_"^"_objVol.SVIsActive
		Set InputStr=InputStr_"^"_objVol.SVResume
		Set InputStr=InputStr_"^"_objVol.SVBarcode
		Set InputStr=InputStr_"^"_objVol.SVIsExPaper			
		Set flg=##class(DHCWMR.SS.Volume).Update(InputStr,"^")
		If (+flg)<1 Trollback
		If (+flg)<1 {
			Set IsError=1
			Quit
		}
		
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCWMR.SS.VolumeD(VolumeID,"P",xSubID))
			Quit:xSubID=""
			
			Set objVolAdm=##Class(DHCWMR.SS.VolPaadm).GetObjById(VolumeID_"||"_xSubID)
			Continue:'$IsObject(objVolAdm)
			Set PatientID=objVolAdm.VPPatientID
			Continue:PatientID=""
			Continue:$listfind(PatientList,PatientID)>0
			Set PatientList=PatientList_$lb(PatientID)
		}
	}
	Quit:IsError=1 return
	Set:ToVolumeIDs'="" ToVolumeIDs=$e(ToVolumeIDs,2,$l(ToVolumeIDs))
	
	Set return="-4^更新病案卷错误"
	Set IsError=0
	If NoFiled'="" {
		If RecycleType=1 {
			If (NoFiled'="")&&(IsBWMrNo=1) {
				For indPat=1:1:$listlength(PatientList) {
					Set PatientID=$list(PatientList,indPat)
					Continue:PatientID=""
					Set flg=##class(DHCWMR.SSService.MrNoSrv).UpdateHisMrNo(PatientID,NoFiled,aToMrNo)
					If (+flg)<1 Trollback
					If (+flg)<1 {
						Set IsError=1
						Quit
					}
				}
			}
		} Else {
			For indPat=1:1:$listlength(PatientList) {
				Set PatientID=$list(PatientList,indPat)
				Continue:PatientID=""
				Set flg=##class(DHCWMR.SSService.MrNoSrv).UpdateHisMrNo(PatientID,NoFiled,aToMrNo)
				If (+flg)<1 Trollback
				If (+flg)<1 {
					Set IsError=1
					Quit
				}
			}
		}
	}
	Quit:IsError=1 return
	
	TCommit
	
	//插入修改日志
	Set InputStr =""
	Set $p(InputStr,"^",1) =""
	Set $p(InputStr,"^",2) =0
	Set $p(InputStr,"^",3) =FromMainID
	Set $p(InputStr,"^",4) =aFromMrNo
	Set $p(InputStr,"^",5) =ToMainID
	Set $p(InputStr,"^",6) =aToMrNo
	Set $p(InputStr,"^",7) =FromVolumeIDs
	Set $p(InputStr,"^",8) =ToVolumeIDs
	Set $p(InputStr,"^",9) =+$h
	Set $p(InputStr,"^",10)=$p($h,",",2)
	Set $p(InputStr,"^",11)=""
	Set $p(InputStr,"^",12)=aUserID
	Do ##class(DHCWMR.SS.MergerLog).Update(InputStr,"^")
	
	Set return="1^修改病案号成功"
	Quit return
}

}
