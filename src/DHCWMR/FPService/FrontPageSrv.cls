/// 名称: DHCWMR.FPService.FrontPageSrv
/// 描述: 病案编目列表查询
/// 编写者：zhufei
/// 编写日期: 2014-11-06
Class DHCWMR.FPService.FrontPageSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCWMR.FPService.FrontPageSrv).Test()
ClassMethod Test()
{
	New
	Set aFPInfo="27"_$c(1)_"650"_$c(1)_"F"_$c(1)_"1||17"_$c(1)_"1"_$c(1)_"9"_$c(1)
	Set aFPDInfo="27"_$c(2)_"1"_$c(2)_"1"_$c(2)_"8097"_$c(2)_"149"_$c(2)_"403"_$c(2,2)_"238"_$c(2,2)
	Set aFPOInfo=""
	Set aFPEInfo=""
	Set return=##class(DHCWMR.FPService.FrontPageSrv).SaveResult(aFPInfo,aFPDInfo,aFPOInfo,aFPEInfo)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-28
/// Description:  检查编目提交权限
/// Table：       DHCWMR.FP.FrontPage
/// Input：       FrontPageID : 编目主记录ID
///               UserID : 编码员
/// Return：      返回String
/// w ##class(DHCWMR.FPService.FrontPageSrv).CheckSubmitPower(158866,4479)
ClassMethod CheckSubmitPower(aFrontPageID As %String, aUserID As %String) As %String
{
	new (aFrontPageID, aUserID)
	set return=0
	quit:(aFrontPageID="")||(aUserID="") return
	
	set objFP=##class(DHCWMR.FP.FrontPage).GetObjById(aFrontPageID)
	quit:'$IsObject(objFP) return
	set BuildUser=objFP.FPBuildUser
	set tmpFinish=objFP.FPIsFinish
	set tmpFinish=+tmpFinish
	set return=1
	if tmpFinish>0 {
		set:BuildUser'=aUserID return=-1
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-11-11
/// Description:  保存编目录入结果
/// Table：       DHCWMR.FP.FrontPage
/// Input：       FPInfo : 编目主信息
///               FPDInfo : 诊断信息
///               FPOInfo : 手术信息
///               FPEInfo : 附加信息
/// 				  aPathRepInfo : 病理编目信息
/// Return：      返回String
/// w ##class(DHCWMR.FPService.FrontPageSrv).SaveResult()
ClassMethod SaveResult(aFPInfo As %String, aFPDInfo As %String, aFPOInfo As %String, aFPEInfo As %String, aPathRepInfo As %String, aPatInfo As %String = "", aHospitalID As %String = "") As %String
{
	new (aFPInfo, aFPDInfo, aFPOInfo, aFPEInfo,aPathRepInfo,aPatInfo,aHospitalID)
	set return=0
	//quit:(aFPInfo="")||(aFPDInfo="") return
	quit:(aFPInfo="") return
	
	TStart
	
	set return=-101
	set flg=##class(DHCWMR.FPService.FrontPageSrv).SaveFrontPage(aFPInfo)
	if flg<1 TRollback
	quit:flg<1 return
	set FrontPageID=flg
	
	set return=-102
	set flg=##class(DHCWMR.FPService.FrontPageSrv).SaveFPDiagnos(FrontPageID,aFPDInfo)
	if flg<0 TRollback
	quit:flg<0 return
	
	set return=-103
	set flg=##class(DHCWMR.FPService.FrontPageSrv).SaveFPOperation(FrontPageID,aFPOInfo)
	if flg<0 TRollback
	quit:flg<0 return
	
	set return=-104
	set flg=##class(DHCWMR.FPService.FrontPageSrv).SaveFPExtraItem(FrontPageID,aFPEInfo)
	if flg<0 TRollback
	quit:flg<0 return
	
	set return=-105
	set flg=##class(DHCWMR.FPService.FrontPageSrv).SaveVolStatus(FrontPageID,aFPInfo)
	if flg<1 TRollback
	quit:flg<1 return
	
	If (aPathRepInfo'="") {
		set return = -106
		set flg = ##class(DHCWMR.FP.PathologRep).Coding(aPathRepInfo)
		if flg<1 TRollback
		quit:flg<1 return
	}
	
	If aPatInfo'="" {
		set return = -107
		set flg=##Class(DHCWMR.FP.FrontPage).SavePatInfo(FrontPageID,aPatInfo)
		if flg<1 TRollback
		quit:flg<1 return
	}
	
	TCommit
	
	Set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjById(FrontPageID)
	If $IsObject(objFrontPage) {
		Set IsFinish=objFrontPage.FPIsFinish
		If IsFinish=1 {
			Set VolumeID=objFrontPage.FPVolumeDr.%Id()
			Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(VolumeID)
			
			//add by zf 2017-03-06
			Set FPStructuredStorageVer=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("FPStructuredStorageVer",aHospitalID)
			If FPStructuredStorageVer=1 {
				//非首页全编目,同步编目数据到首页结构化存储v1.0中
				Set flg = ##class(DHCWMR.MRService.ImportDataByFP).CodingSave(FrontPageID)
			} ElseIf FPStructuredStorageVer=2 {
				//首页全编目,同步首页数据到首页结构化存储v2.0中
				Set return=##class(DHCWMR.IO.FromMRQSrv).GetWMRDataByAdm(aEpisodeID)
			}
			
			//保存综合查询数据
			d ##class(DHCWMR.MQService.RecordSrv).GetEPRRecords(EpisodeID)
			d ##class(DHCWMR.MQService.RecordSrv).GetFPRecords(FrontPageID)
			If EpisodeID'="" {
				Set flg=##class(DHCWMR.IO.FromEnsSrv).DHCHisInterface(EpisodeID,"SENDADMFIRSTCATALOGINFO")
			}
		}
	}
	
	
	
	set return=FrontPageID
	quit return
}

/// 保存编目主信息
/// w ##class(DHCWMR.FPService.FrontPageSrv).SaveFrontPage()
ClassMethod SaveFrontPage(aInputStr As %String) As %String
{
	new (aInputStr)
	set return=0
	quit:aInputStr="" return
	
	set FrontPageID=$p(aInputStr,$c(1),1)
	set VolumeID=$p(aInputStr,$c(1),2)
	set FPType=$p(aInputStr,$c(1),3)
	set WFItemID=$p(aInputStr,$c(1),4)
	set IsFinish=+$p(aInputStr,$c(1),5)
	set UserID=$p(aInputStr,$c(1),6)
	set Resume=$p(aInputStr,$c(1),7)
	quit:(VolumeID="")||(FPType="") return
	
	if FrontPageID="" {
		set FrontPageID=$o(^DHCWMR.FP.FrontPageI("IndexVolume",VolumeID,FPType,0))
	}
	
	set tmpFinish=0
	if FrontPageID'="" {
		set objFP=##class(DHCWMR.FP.FrontPage).GetObjById(FrontPageID)
		quit:'$IsObject(objFP) return
		set BuildDate=objFP.FPBuildDate
		set BuildTime=objFP.FPBuildTime
		set BuildUser=objFP.FPBuildUser
		set tmpFinish=objFP.FPIsFinish
		set tmpFinish=+tmpFinish
	}
	if (tmpFinish<1){
		set BuildDate=+$h
		set BuildTime=$p($h,",",2)
		set BuildUser=UserID
	}
	
	set inputStr=FrontPageID
	set inputStr=inputStr_$c(1)_VolumeID
	set inputStr=inputStr_$c(1)_FPType
	set inputStr=inputStr_$c(1)_IsFinish
	set inputStr=inputStr_$c(1)_BuildDate
	set inputStr=inputStr_$c(1)_BuildTime
	set inputStr=inputStr_$c(1)_BuildUser
	set inputStr=inputStr_$c(1)_UserID
	set inputStr=inputStr_$c(1)_Resume
	set return=##class(DHCWMR.FP.FrontPage).Update(inputStr,$c(1))
	quit return
}

/// 保存诊断信息
/// w ##class(DHCWMR.FPService.FrontPageSrv).SaveFPDiagnos()
ClassMethod SaveFPDiagnos(aFrontPageID As %String, aInputDiagnos As %String) As %String
{
	new (aFrontPageID,aInputDiagnos)
	set return=0
	quit:(aFrontPageID="")||(aInputDiagnos="") return
	
	set return="-1^删除诊断记录失败"
	set isError=0
	set SubIdList=""
	for ind=1:1:$l(aInputDiagnos,$c(1)) {
		set tmpDiagnos=$p(aInputDiagnos,$c(1),ind)
		continue:tmpDiagnos=""
		set FPSub=$p(tmpDiagnos,$c(2),2)
		continue:FPSub=""
		set SubIdList=SubIdList_$lb(FPSub)
	}
	if SubIdList'="" {
		set xSub=0
		for {
			set xSub=$o(^DHCWMR.FP.FrontPageD(aFrontPageID,"D",xSub))
			quit:xSub=""
			continue:$listfind(SubIdList,xSub)>0
			set flg=##class(DHCWMR.FP.FPDiagnos).DeleteById(aFrontPageID_"||"_xSub)
			if (+flg)<1 {
				set isError=1
				quit
			}
		}
	}
	quit:isError>0 return
	
	set return="-2^保存诊断记录失败"
	set isError=0
	for ind=1:1:$l(aInputDiagnos,$c(1)) {
		set tmpDiagnos=$p(aInputDiagnos,$c(1),ind)
		continue:tmpDiagnos=""
		
		set FPId=aFrontPageID
		set FPSub=$p(tmpDiagnos,$c(2),2)
		set VCode="" //ICD对应版本
		set RowIndex=$p(tmpDiagnos,$c(2),3)
		set ICDID=$p(tmpDiagnos,$c(2),4)
		set TypeID=$p(tmpDiagnos,$c(2),5)
		set AdmitCondID=$p(tmpDiagnos,$c(2),6)
		set DischCondID=$p(tmpDiagnos,$c(2),7)
		set IsDefiniteID=$p(tmpDiagnos,$c(2),8)
		set DataSource=$p(tmpDiagnos,$c(2),9)
		set TempData=$p(tmpDiagnos,$c(2),10)
		
		set inputDiagnos=FPId
		set inputDiagnos=inputDiagnos_$c(1)_FPSub
		set inputDiagnos=inputDiagnos_$c(1)_VCode
		set inputDiagnos=inputDiagnos_$c(1)_RowIndex
		set inputDiagnos=inputDiagnos_$c(1)_ICDID
		set inputDiagnos=inputDiagnos_$c(1)_TypeID
		set inputDiagnos=inputDiagnos_$c(1)_AdmitCondID
		set inputDiagnos=inputDiagnos_$c(1)_DischCondID
		set inputDiagnos=inputDiagnos_$c(1)_IsDefiniteID
		set inputDiagnos=inputDiagnos_$c(1)_DataSource
		set inputDiagnos=inputDiagnos_$c(1)_TempData
		
		set flg=##class(DHCWMR.FP.FPDiagnos).Update(inputDiagnos,$c(1))
		if flg<1 {
			set isError=1
			quit
		}
	}
	quit:isError>0 return
	
	set return="1^保存诊断记录成功"
	quit return
}

/// 保存手术信息
/// w ##class(DHCWMR.FPService.FrontPageSrv).SaveFPOperation()
ClassMethod SaveFPOperation(aFrontPageID As %String, aInputOperation As %String) As %String
{
	new (aFrontPageID,aInputOperation)
	set return=0
	quit:(aFrontPageID="") return
	
	if (aInputOperation="")	//update by liuyh 2016-09-20 考虑手术信息为空情况
	{
		set xSub=0
		for {
			set xSub=$o(^DHCWMR.FP.FrontPageD(aFrontPageID,"O",xSub))
			quit:xSub=""
			set flg=##class(DHCWMR.FP.FPOperation).DeleteById(aFrontPageID_"||"_xSub)
			if (+flg)<1 {
				set isError=1
				quit
			}
		}
		
		Quit return
	}
	
	set return="-1^删除手术记录失败"
	set isError=0
	set SubIdList=""
	for ind=1:1:$l(aInputOperation,$c(1)) {
		set tmpOperation=$p(aInputOperation,$c(1),ind)
		continue:tmpOperation=""
		set FPSub=$p(tmpOperation,$c(2),2)
		continue:FPSub=""
		set SubIdList=SubIdList_$lb(FPSub)
	}
	//if SubIdList'="" { //modify by mxp 20171023 修改编目手术 复制一条记录修改后删除原记录再提交后原记录仍存在
		set xSub=0
		for {
			set xSub=$o(^DHCWMR.FP.FrontPageD(aFrontPageID,"O",xSub))
			quit:xSub=""
			continue:$listfind(SubIdList,xSub)>0
			set flg=##class(DHCWMR.FP.FPOperation).DeleteById(aFrontPageID_"||"_xSub)
			if (+flg)<1 {
				set isError=1
				quit
			}
		}
	//}
	quit:isError>0 return
	
	set return="-2^保存手术记录失败"
	set isError=0
	for ind=1:1:$l(aInputOperation,$c(1)) {
		set tmpOperation=$p(aInputOperation,$c(1),ind)
		continue:tmpOperation=""
		
		set FPId=aFrontPageID
		set FPSub=$p(tmpOperation,$c(2),2)
		set VCode="" //ICD对应版本
		set RowIndex=$p(tmpOperation,$c(2),3)
		set ICDID=$p(tmpOperation,$c(2),4)
		set TypeID=$p(tmpOperation,$c(2),5)
		set OperDate=$p(tmpOperation,$c(2),6)
		set OperatorID=$p(tmpOperation,$c(2),7)
		set OperatorName=$p(tmpOperation,$c(2),8)
		set Ass1ID=$p(tmpOperation,$c(2),9)
		set Ass1Name=$p(tmpOperation,$c(2),10)
		set Ass2ID=$p(tmpOperation,$c(2),11)
		set Ass2Name=$p(tmpOperation,$c(2),12)
		set NarTypeID=$p(tmpOperation,$c(2),13)
		set NarDocID=$p(tmpOperation,$c(2),14)
		set NarDocName=$p(tmpOperation,$c(2),15)
		set CutTypeID=$p(tmpOperation,$c(2),16)
		set HealingID=$p(tmpOperation,$c(2),17)
		set OperLevelID=$p(tmpOperation,$c(2),18)
		set DataSource=$p(tmpOperation,$c(2),19)
		set TempData=$p(tmpOperation,$c(2),20)
		
		set inputOperation=FPId
		set inputOperation=inputOperation_$c(1)_FPSub
		set inputOperation=inputOperation_$c(1)_VCode
		set inputOperation=inputOperation_$c(1)_RowIndex
		set inputOperation=inputOperation_$c(1)_ICDID
		set inputOperation=inputOperation_$c(1)_TypeID
		set inputOperation=inputOperation_$c(1)_OperDate
		set inputOperation=inputOperation_$c(1)_""
		set inputOperation=inputOperation_$c(1)_""
		set inputOperation=inputOperation_$c(1)_""
		set inputOperation=inputOperation_$c(1)_OperatorID
		set inputOperation=inputOperation_$c(1)_OperatorName
		set inputOperation=inputOperation_$c(1)_Ass1ID
		set inputOperation=inputOperation_$c(1)_Ass1Name
		set inputOperation=inputOperation_$c(1)_Ass2ID
		set inputOperation=inputOperation_$c(1)_Ass2Name
		set inputOperation=inputOperation_$c(1)_NarTypeID
		set inputOperation=inputOperation_$c(1)_NarDocID
		set inputOperation=inputOperation_$c(1)_NarDocName
		set inputOperation=inputOperation_$c(1)_CutTypeID
		set inputOperation=inputOperation_$c(1)_HealingID
		set inputOperation=inputOperation_$c(1)_OperLevelID
		set inputOperation=inputOperation_$c(1)_DataSource
		set inputOperation=inputOperation_$c(1)_TempData
		
		set flg=##class(DHCWMR.FP.FPOperation).Update(inputOperation,$c(1))
		if flg<1 {
			set isError=1
			quit
		}
	}
	quit:isError>0 return
	
	set return="1^保存手术记录成功"
	quit return
}

/// 保存附加信息
/// w ##class(DHCWMR.FPService.FrontPageSrv).SaveFPExtraItem()
ClassMethod SaveFPExtraItem(aFrontPageID As %String, aInputExtra As %String) As %String
{
	new (aFrontPageID,aInputExtra)
	set return=0
	quit:(aFrontPageID="")||(aInputExtra="") return
	
	for ind=1:1:$l(aInputExtra,$c(1)) {
		set tmpExtra=$p(aInputExtra,$c(1),ind)
		continue:tmpExtra=""
		
		set FPId=aFrontPageID
		set FPSub=$p(tmpExtra,$c(2),2)
		set EItemID=$p(tmpExtra,$c(2),3)
		set ItemValue=$p(tmpExtra,$c(2),4)
		set ItemText=$p(tmpExtra,$c(2),5)
		
		set inputExtra=FPId
		set inputExtra=inputExtra_$c(1)_FPSub
		set inputExtra=inputExtra_$c(1)_EItemID
		set inputExtra=inputExtra_$c(1)_ItemValue
		set inputExtra=inputExtra_$c(1)_ItemText
		set flg=##class(DHCWMR.FP.FPExtraItem).Update(inputExtra,$c(1))
		if flg<0 {
			set return=-1
			continue:flg<0
		}
	}
	quit:return<0 return
	
	set return=1
	quit return
}

/// 保存病案卷状态信息（编目）
/// w ##class(DHCWMR.FPService.FrontPageSrv).SaveVolStatus()
ClassMethod SaveVolStatus(aFrontPageID As %String, aInputStr As %String) As %String
{
	new (aFrontPageID,aInputStr)
	set return="0^参数错误"
	quit:(aFrontPageID="")||(aInputStr="") return
	
	set FrontPageID=aFrontPageID
	set VolumeID=$p(aInputStr,$c(1),2)
	set FPType=$p(aInputStr,$c(1),3)
	set WFItemID=$p(aInputStr,$c(1),4)
	set IsFinish=+$p(aInputStr,$c(1),5)
	set UserID=$p(aInputStr,$c(1),6)
	set Resume=$p(aInputStr,$c(1),7)
	quit:(FrontPageID="")||(VolumeID="")||(WFItemID="") return
	
	set objWFItem=##class(DHCWMR.SS.WorkFItem).GetObjById(WFItemID)
	quit:'$IsObject(objWFItem) return
	quit:'$IsObject(objWFItem.WFIItem) return
	set WorkItemID=objWFItem.WFIItem.%Id()
	
	set return="1^编目暂存状态,不记录操作日志"
	quit:IsFinish<1 return  //未完成编目，不提交
	
	set return="2^已完成编目操作,不再重复记录操作日志"
	set fpStatus=0
	set objVol=##Class(DHCWMR.SS.Volume).GetObjById(VolumeID)
	quit:'$IsObject(objVol) return
	quit:objVol.SVIsActive'=1 return  //卷无效
	for indStatus=1:1:objVol.ChildStatus.Count() {
		quit:fpStatus=1
		set objStatus=objVol.ChildStatus.GetAt(indStatus)
		continue:'$IsObject(objStatus)
		continue:objStatus.VSUpdoOpera="U"
		continue:'$IsObject(objStatus.VSStatus)
		continue:objStatus.VSStatus.%Id()'=WorkItemID
		set fpStatus=1
	}
	quit:fpStatus=1 return
	
	set return="-1^当前卷状态不允许编目操作"
	set flg=##class(DHCWMR.SSService.OperationSrv).CheckOperation(VolumeID,WFItemID)
	quit:(+flg)<1 return
	
	//插入编目操作记录
	set flg=##class(DHCWMR.SSService.OperationSrv).Operation(VolumeID,WFItemID,"",UserID,"","","")
	if (+flg)>0 {
		set return="3^保存编目操作成功"
	} else {
		set return="-3^保存编目操作失败"
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-16
/// Description:  检查是否符合当前编目操作
/// Table：       DHCWMR.FP.FrontPage、DHCWMR.SS.Volume、DHCWMR.SS.VolStatus
/// Input：       VolumeID : 卷ID
///               FPType : 编目类型
/// Return：      返回String
/// w ##class(DHCWMR.FPService.FrontPageSrv).CheckOperation(643,"F")
ClassMethod CheckOperation(aVolumeID As %String, aFPType As %String) As %String
{
	new (aVolumeID, aFPType)
	set return=0
	quit:(aVolumeID="")||(aFPType="") return
	
	set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjByVolId(aVolumeID,aFPType)
	if $IsObject(objFrontPage){
		set objVolume=objFrontPage.FPVolumeDr
		set IsFinish=objFrontPage.FPIsFinish
	} else {
		set objVolume=##Class(DHCWMR.SS.Volume).GetObjById(aVolumeID)
		set IsFinish=0
	}
	quit:'$IsObject(objVolume) return
	quit:objVolume.SVIsActive'=1 return  //卷无效
	quit:'$IsObject(objVolume.SVMainDr) return
	quit:'$IsObject(objVolume.SVMainDr.SMMrType) return
	set MrTypeID=objVolume.SVMainDr.SMMrType.%Id()
	
	set objFPItem=##class(DHCWMR.FP.WorkFItem).GetObjByMrType(MrTypeID,aFPType)
 	quit:'$IsObject(objFPItem) return
	quit:'$IsObject(objFPItem.WIItemDr) return
	quit:'$IsObject(objFPItem.WIItemDr.WFIItem) return
 	set FPItemID=objFPItem.%Id()
 	set WFItemID=objFPItem.WIItemDr.%Id()
	set WorkItemID=objFPItem.WIItemDr.WFIItem.%Id()
	
	set return="1^已完成编目,不再检查状态"
	quit:IsFinish>0 return
	
	set return="2^已完成编目,不再检查状态"
	set fpStatus=0
	for indStatus=1:1:objVolume.ChildStatus.Count() {
		quit:fpStatus=1
		set objStatus=objVolume.ChildStatus.GetAt(indStatus)
		continue:'$IsObject(objStatus)
		continue:objStatus.VSUpdoOpera="U"
		continue:'$IsObject(objStatus.VSStatus)
		continue:objStatus.VSStatus.%Id()'=WorkItemID
		set fpStatus=1
	}
	quit:fpStatus=1 return
	
	set return="-1^当前卷状态不允许编目操作"
	set flg=##class(DHCWMR.SSService.OperationSrv).CheckOperation(aVolumeID,WFItemID)
	quit:(+flg)<1 return
	
	set return="3^未完成编目,当前状态允许编目操作"
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据就诊号取编目主记录
/// Input：       EpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCWMR.FPService.FrontPageSrv).GetFPObjByAdm(5920325)
ClassMethod GetFPObjByAdm(aEpisodeID As %String, aFPCode As %String = "F") As DHCWMR.FP.FrontPage
{
	New (aEpisodeID,aFPCode)
	Set return=""
	Quit:(aEpisodeID="")||(aFPCode="") return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
	Quit:'$IsObject(objVol) return
	Set VolumeID=objVol.%Id()
	
	Set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjByVolId(VolumeID,aFPCode)
	Quit:'$IsObject(objFrontPage) return
	Set return=objFrontPage
	Quit return
}

}
