/// 名称: 	  DHCWMR.IO.ToEmrSrv
/// 描述: 	  To电子病历组接口程序
/// 编写者：  朱飞
/// 编写日期: 2015-11-24
Class DHCWMR.IO.ToEmrSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-11-24
/// Description:  保存科室质控QL/病案扫描SR/扫描分类SC/扫描完成SO操作记录（To电子病历）
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       InputStr ："就诊号^操作员^系统操作"
/// w ##class(DHCWMR.IO.ToEmrSrv).ISaveMRStatus("96^9^QL")
/// w ##class(DHCWMR.IO.ToEmrSrv).ISaveMRStatus("96^9^SR")
/// w ##class(DHCWMR.IO.ToEmrSrv).ISaveMRStatus("96^9^SC")
/// w ##class(DHCWMR.IO.ToEmrSrv).ISaveMRStatus("96^9^SO")
ClassMethod ISaveMRStatus(aInputStr As %String, ByRef ErrMsg As %String = "") As %String
{
	New (aInputStr,ErrMsg)
	Set return="",ErrMsg="-1:参数错误"
	Quit:(aInputStr="") return
	
	Set BatchNumber=##class(DHCWMR.SSService.OperationSrv).GetBatchNumber()
	Set $ZT="ISaveMRStatusErr"

	Set EpisodeID = $p(aInputStr,"^",1)
	Set UserID = $p(aInputStr,"^",2)
	Set SysOperCode = $p(aInputStr,"^",3)
	Quit:(EpisodeID="")||(UserID="")||(SysOperCode="") return
	
	Set ErrMsg="-2:没有有效卷"
	Set objVol = ##Class(DHCWMR.SS.Volume).GetObjByPaadm(EpisodeID)
	Quit:'$IsObject(objVol) return
	
	Set ErrMsg="-3:系统操作无效"
	Set MrTypeID = objVol.SVMainDr.SMMrType.%Id()
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,SysOperCode)
	Quit:'$IsObject(objWFItem) return
	Quit:'$IsObject(objWFItem.WFIItem) return
	Set WorkItemID=objWFItem.WFIItem.%Id()
	//检查操作是否符合流程配置
	Set ret = ##class(DHCWMR.SSService.OperationSrv).CheckOperation(objVol.%Id(),objWFItem.%Id())
	Quit:+ret<0 return
	
	Tstart
	
	Set ErrMsg="-4:保存病案操作记录错误"
	Set InputStr=""
	Set InputStr=InputStr_"^"_MrTypeID
	Set InputStr=InputStr_"^"_WorkItemID
	Set InputStr=InputStr_"^"_UserID
	Set InputStr=InputStr_"^"_""  //操作日期
	Set InputStr=InputStr_"^"_""  //操作时间
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_BatchNumber
	Set InputStr=InputStr_"^"_1
	Set InputStr=InputStr_"^"_""
	Set flg=##class(DHCWMR.SS.Operation).Update(InputStr,"^")
	If (+flg)<1 TRollback
	Quit:(+flg)<1 ErrMsg
	Set OperationID=+flg
	
	Set ErrMsg="-5:保存病案卷操作记录错误"
	Set InputStr=objVol.%Id()
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_WorkItemID
	Set InputStr=InputStr_"^"_UserID
	Set InputStr=InputStr_"^"_+$h
	Set InputStr=InputStr_"^"_$p($h,",",2)
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_BatchNumber
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_1
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set flg=##class(DHCWMR.SS.VolStatus).Update(InputStr,"^")
	If (+flg)<1 TRollback
	Quit:(+flg)<1 ErrMsg
	
	Set ErrMsg="-6:处理病案卷主表状态错误"
	Set OrdStep = objWFItem.WFIPostStep
	Set InputStr=objVol.%Id()
	Set InputStr=InputStr_"^"_objVol.SVMainDr.%Id()
	Set InputStr=InputStr_"^"_WorkItemID
	Set InputStr=InputStr_"^"_OrdStep
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
	If (+flg)<1 TRollback
	Quit:(+flg)<1 ErrMsg
	
	Set return = EpisodeID
	Tcommit
	
	Quit return
ISaveMRStatusErr
	Set ErrMsg="-999:"_$ZE
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-11-24
/// Description:  保存病案复核操作记录（To电子病历）
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       InputStr ："就诊号^操作员"
/// w ##class(DHCWMR.IO.ToEmrSrv).ISaveMRStatusRV("96^9")
ClassMethod ISaveMRStatusRV(aInputStr As %String, ByRef ErrMsg As %String = "") As %String
{
	New (aInputStr,ErrMsg)
	Set return="",ErrMsg="-1:参数错误"
	Quit:(aInputStr="") return
	
	Set $ZT="ISaveMRStatusRVErr"
	
	Set BatchNumber=##class(DHCWMR.SSService.OperationSrv).GetBatchNumber()
	Set EpisodeID = $p(aInputStr,"^",1)
	Set UserID = $p(aInputStr,"^",2)
	Set SysOperCode ="RV" //病案复核 系统操作
	Quit:(EpisodeID="")||(UserID="")||(SysOperCode="") return
	
	Set ErrMsg="-2:没有有效卷"
	Set objVol = ##Class(DHCWMR.SS.Volume).GetObjByPaadm(EpisodeID)
	Quit:'$IsObject(objVol) return
	
	Set ErrMsg="-3:系统操作无效"
	Set MrTypeID = objVol.SVMainDr.SMMrType.%Id()
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,SysOperCode)
	Quit:'$IsObject(objWFItem) return
	Quit:'$IsObject(objWFItem.WFIItem) return
	Set WorkItemID=objWFItem.WFIItem.%Id()
	//检查操作是否符合流程配置
	Set ret = ##class(DHCWMR.SSService.OperationSrv).CheckOperation(objVol.%Id(),objWFItem.%Id())
	Quit:+ret<0 return
	
	Tstart
	
	Set ErrMsg="-4:保存病案操作记录错误"
	Set InputStr=""
	Set InputStr=InputStr_"^"_MrTypeID
	Set InputStr=InputStr_"^"_WorkItemID
	Set InputStr=InputStr_"^"_UserID
	Set InputStr=InputStr_"^"_""  //操作日期
	Set InputStr=InputStr_"^"_""  //操作时间
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_BatchNumber
	Set InputStr=InputStr_"^"_1
	Set InputStr=InputStr_"^"_""
	Set flg=##class(DHCWMR.SS.Operation).Update(InputStr,"^")
	If (+flg)<1 TRollback
	Quit:(+flg)<1 ErrMsg
	Set OperationID=+flg
	
	Set ErrMsg="-5:保存病案卷操作记录错误"
	Set InputStr=objVol.%Id()
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_WorkItemID
	Set InputStr=InputStr_"^"_UserID
	Set InputStr=InputStr_"^"_+$h
	Set InputStr=InputStr_"^"_$p($h,",",2)
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_BatchNumber
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_1
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set flg=##class(DHCWMR.SS.VolStatus).Update(InputStr,"^")
	If (+flg)<1 TRollback
	Quit:(+flg)<1 ErrMsg
	
	Set ErrMsg="-6:处理病案卷主表状态错误"
	Set OrdStep = objWFItem.WFIPostStep
	Set InputStr=objVol.%Id()
	Set InputStr=InputStr_"^"_objVol.SVMainDr.%Id()
	Set InputStr=InputStr_"^"_WorkItemID
	Set InputStr=InputStr_"^"_OrdStep
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
	If (+flg)<1 TRollback
	Quit:(+flg)<1 ErrMsg
	
	Set return = EpisodeID
	Tcommit
	
	Quit return	
ISaveMRStatusRVErr
	 Set ErrMsg="-999:"_$ZE
     Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-11-24
/// Description:  保存病案复核不通过操作记录（To电子病历）
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       InputStr ："就诊号^操作员^复核不通过原因"
/// w ##class(DHCWMR.IO.ToEmrSrv).ISaveMRStatusUR("96^9^病历缺页")
ClassMethod ISaveMRStatusUR(aInputStr As %String, ByRef ErrMsg As %String = "") As %String
{
	New (aInputStr,ErrMsg)
	Set return="",ErrMsg="-1:参数错误"
	Quit:(aInputStr="") return
	
	Set $ZT="ISaveMRStatusURErr"
	
	Set BatchNumber=##class(DHCWMR.SSService.OperationSrv).GetBatchNumber()
	Set EpisodeID = $p(aInputStr,"^",1)
	Set UserID = $p(aInputStr,"^",2)
	Set Reason = $p(aInputStr,"^",3)
	Set SysOperCode="UR"  //病案复核不通过 系统操作
	Quit:(EpisodeID="")||(UserID="")||(SysOperCode="") return
	
	Set ErrMsg="-2:没有有效卷"
	Set objVol = ##Class(DHCWMR.SS.Volume).GetObjByPaadm(EpisodeID)
	Quit:'$IsObject(objVol) return
	
	Set ErrMsg="-3:系统操作无效"
	Set MrTypeID = objVol.SVMainDr.SMMrType.%Id()
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,SysOperCode)
	Quit:'$IsObject(objWFItem) return
	Quit:'$IsObject(objWFItem.WFIItem) return
	Set WorkItemID=objWFItem.WFIItem.%Id()
	//检查操作是否符合流程配置
	Set ret = ##class(DHCWMR.SSService.OperationSrv).CheckOperation(objVol.%Id(),objWFItem.%Id())
	Quit:+ret<0 return
	
	Tstart
	
	Set ErrMsg="-4:保存病案操作记录错误"
	Set InputStr=""
	Set InputStr=InputStr_"^"_MrTypeID
	Set InputStr=InputStr_"^"_WorkItemID
	Set InputStr=InputStr_"^"_UserID
	Set InputStr=InputStr_"^"_""  //操作日期
	Set InputStr=InputStr_"^"_""  //操作时间
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_BatchNumber
	Set InputStr=InputStr_"^"_1
	Set InputStr=InputStr_"^"_""
	Set flg=##class(DHCWMR.SS.Operation).Update(InputStr,"^")
	If (+flg)<1 TRollback
	Quit:(+flg)<1 ErrMsg
	Set OperationID=+flg
	
	Set ErrMsg="-5:保存病案卷操作记录错误"
	Set InputStr=objVol.%Id()
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_WorkItemID
	Set InputStr=InputStr_"^"_UserID
	Set InputStr=InputStr_"^"_+$h
	Set InputStr=InputStr_"^"_$p($h,",",2)
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_BatchNumber
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_Reason
	Set InputStr=InputStr_"^"_1
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set flg=##class(DHCWMR.SS.VolStatus).Update(InputStr,"^")
	If (+flg)<1 TRollback
	Quit:(+flg)<1 ErrMsg
	
	Set ErrMsg="-6:处理病案卷主表状态错误"
	Set OrdStep = objWFItem.WFIPostStep
	Set InputStr=objVol.%Id()
	Set InputStr=InputStr_"^"_objVol.SVMainDr.%Id()
	Set InputStr=InputStr_"^"_WorkItemID
	Set InputStr=InputStr_"^"_OrdStep
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
	If (+flg)<1 TRollback
	Quit:(+flg)<1 ErrMsg
	
	//回执病历到初始状态
	Set ErrMsg="-7:病历回执初始状态错误"
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"I")
	Quit:'$IsObject(objWFItem) return
	Quit:'$IsObject(objWFItem.WFIItem) return
	Set WorkItemID=objWFItem.WFIItem.%Id()
	Set ret=##class(DHCWMR.SSService.ReviseSrv).ReviseInsert(objVol.%Id(),WorkItemID,UserID)
	If (+flg)<1 TRollback
	Quit:(+flg)<1 ErrMsg
	
	Set return = EpisodeID
	Tcommit
	
	Quit return	
	
ISaveMRStatusURErr
	 Set ErrMsg="-999:"_$ZE
     Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-11-24
/// Description:  记录是否纸质病历（To电子病历）
///               在科室质控页面，记录无纸化病历后，一份病历是否有纸质病历
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume
/// Input：       InputStr ："就诊号^操作员^是否存在纸质病历标志"
/// w ##class(DHCWMR.IO.ToEmrSrv).ISaveIsExPaper("96^9^0")
ClassMethod ISaveIsExPaper(aInputStr As %String, ByRef ErrMsg As %String = "") As %String
{
	New (aInputStr,ErrMsg)
	Set return="",ErrMsg="-1:参数错误"
	Quit:(aInputStr="") return
	
	Set $ZT="ISaveIsExPaperErr"
	Set EpisodeID = $p(aInputStr,"^",1)
	Set UserID = $p(aInputStr,"^",2)
	Set Marker = $p(aInputStr,"^",3)
	Set ErrMsg="-2:没有有效卷"
	Set objVol = ##Class(DHCWMR.SS.Volume).GetObjByPaadm(EpisodeID)
	Quit:'$IsObject(objVol) return
	
	Set ErrMsg="-3:保存标识错误"
	Set flg = ##class(DHCWMR.SS.Volume).UpdateIsExPaper(objVol.%Id(),Marker)
	Quit:(+flg)<1 return
	
	Quit EpisodeID
ISaveIsExPaperErr
	 Set ErrMsg="-999:"_$ZE
     Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-12-03
/// Description:  根据就诊号取病案操作列表（To电子病历）
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolStatus
/// Input：       EpisodeID ："就诊号"
/// Output：	  状态名称^操作日期^操作时间^操作人$c(1)状态名称^操作日期^操作时间^操作人
/// w ##class(DHCWMR.IO.ToEmrSrv).GetMrStatusString(96)
ClassMethod GetMrStatusString(aEpisodeID As %String, ByRef ErrMsg As %String = "") As %String
{
	New (aEpisodeID,ErrMsg)
	Set return="",ErrMsg="-1:参数错误"
	Quit:(aEpisodeID="") return
	
	Set $ZT="GetMrStatusStringErr"
	
	Set ErrMsg="-2:没有有效卷"
	Set objVol = ##class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
	Quit:'$IsObject(objVol) return
	
	For indSta=1:1:objVol.ChildStatus.Count() {
		Set objVolSta=objVol.ChildStatus.GetAt(indSta)
		Continue:'$IsObject(objVolSta)
		
		Set objStatus= objVolSta.VSStatus
		Set ActDate  = objVolSta.VSActDate
		Set ActTime  = objVolSta.VSActTime
		Set UserFrom = objVolSta.VSUserFrom
		Set WorkItemDesc = objStatus.WIDesc
		Set:ActDate'="" ActDate=$zd(ActDate,3)
		Set:ActTime'="" ActTime=$zt(ActTime)
		Set:UserFrom'="" UserFrom=$p($g(^SSU("SSUSR",+UserFrom)),"^",2)
		If (return = ""){
			Set return = WorkItemDesc_"^"_ActDate_"^"_ActTime_"^"_UserFrom
		}else{
			Set return=return_$c(1)_WorkItemDesc_"^"_ActDate_"^"_ActTime_"^"_UserFrom
		}
	}
	Quit return
	
GetMrStatusStringErr
	 Set ErrMsg="-999:"_$ZE
     Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-12-03
/// Description:  根据病案号取病案就诊记录（To电子病历）
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       MrNo ："病案号"
/// 				  aMrClass：病案分类 （住院病案：I 门诊病案：O 急诊病历：E 留观病历：L）
/// Output：      历次就诊号List
/// w ##class(DHCWMR.IO.ToEmrSrv).IGetEpisodeIDsByMrNo(96,"I")
ClassMethod IGetEpisodeIDsByMrNo(aMrNo As %String, aMrClass As %String, ByRef ErrMsg As %String = "") As %String
{
	New (aMrNo,aMrClass,ErrMsg)
	Set return="",ErrMsg="-1:参数错误"
	Quit:(aMrNo="") return
	
	Set $ZT="IGetEpisodeIDsByMrNoErr"
	
	Set xMrTypeID = "",aMrNo=$ZCVT(aMrNo,"U")
	For {
		Set xMrTypeID = $o(^DHCWMR.SS.MainI("IndexTypeNoAct",xMrTypeID))
		Quit:xMrTypeID=""
		
		Set objMrType = ##class(DHCWMR.SS.MrType).GetObjById(xMrTypeID)
		Continue:'$IsObject(objMrType)
		Continue:objMrType.MTMrClass.MCCode'=aMrClass
		Continue:'$d(^DHCWMR.SS.MainI("IndexTypeNoAct",xMrTypeID," "_aMrNo,1))
		
		Set xMainID = $o(^DHCWMR.SS.MainI("IndexTypeNoAct",xMrTypeID," "_aMrNo,1,""))
		Set xVolumeID =""
		For {
			Set xVolumeID=$o(^DHCWMR.SS.VolumeI("IndexMainDrAct",xMainID,1,xVolumeID))
			Quit:xVolumeID=""
			Set objVol = ##class(DHCWMR.SS.Volume).GetObjById(xVolumeID)
			Continue:'$IsObject(objVol)
			Set VolID = objVol.%Id()
			Set xSub=""
			For {
				Set xSub=$o(^DHCWMR.SS.VolumeD(VolID,"P",xSub),-1)
				Quit:xSub=""
		
				Set VolPaadmID=VolID_"||"_xSub
				Set objVolPaadm=##Class(DHCWMR.SS.VolPaadm).GetObjById(VolPaadmID)
				Continue:'$IsObject(objVolPaadm)
				Set EpisodeID=objVolPaadm.VPEpisodeID
				Continue:EpisodeID=""
				
				Set return = return_$lb(EpisodeID)
			}
		}
	}
	Quit return
	
IGetEpisodeIDsByMrNoErr
	 Set ErrMsg="-999:"_$ZE
     Quit return
}

}
