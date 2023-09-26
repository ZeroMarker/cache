/// 名称: DHCWMR.SSService.OperationSrv
/// 描述: 病案流程操作 执行及撤销服务
/// 编写者：zhufei
/// 编写日期: 2014-09-19
Class DHCWMR.SSService.OperationSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     李阳
/// CreatDate：   2014-09-15
/// Description:  验证用户的用户名/密码
/// Table：       无
/// Input：       UserCode : 工号
///               PassWord : 密码
/// Return：      验证成功，返回用户信息，否则返回空
/// w ##class(DHCWMR.SSService.OperationSrv).VerifyUser("245","1")
ClassMethod VerifyUser(aUserCode As %String, aPassWord As %String) As %String
{
	New (aUserCode,aPassWord,%session,%request)
	Set return=-1
	Quit:(aUserCode="")||(aPassWord="") return
	
    //Set flg=$$select^MVBSSUSR(aUserCode,aPassWord)
	//Quit:flg'=0 return
	Set flg=##Class(DHCWMR.IO.FromHisSrv).ValidatePassword(aUserCode,aPassWord)
	Quit:flg<1 return
	
	Set aUserCode=$$ALPHAUP^SSUTIL4(aUserCode)
	Set UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",aUserCode,""))
	Quit:UserId="" return
    Set UserCode=$p($g(^SSU("SSUSR",UserId)),"^",1)
    Set UserName=$p($g(^SSU("SSUSR",UserId)),"^",2)
    Set return=UserId_"/"_UserCode_"/"_UserName
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-17
/// Description:  获取流程操作的【批次号】
/// Table：       无
/// Input：       无
/// Return：      当前批次号
/// w ##class(DHCWMR.SSService.OperationSrv).GetBatchNumber()
ClassMethod GetBatchNumber() As %String
{
	New
	Set return=""
	Set xDate=$zd(+$h,3)
	Set num=$i(^DHCWMR.SS.BatchNumber(xDate))
	If $l(num)<7 {
		Set $p(return,"0",7-$l(num))=num
	} Else {
		Set return=num
	}
	Set xDate=$tr(xDate,"-","")
	Set xDate=$e(xDate,3,$l(xDate))
	Set return="B"_xDate_return
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-17
/// Description:  验证病案卷操作条件
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume
/// Input：       VolID : 病案卷ID
///               WFItemID : 病案流程操作项
///               CatCode : 作废，为了程序兼容性保留此参数
/// Return：      验证成功，返回用户信息，否则返回空
/// w ##class(DHCWMR.SSService.OperationSrv).CheckOperation("8","1||11")
ClassMethod CheckOperation(aVolID As %String, aWFItemID As %String, aCatCode As %String = "") As %String
{
	New (aVolID,aWFItemID,aCatCode)
	Set return=0
	Quit:(aVolID="")||(aWFItemID="") return
	
	Set return="-1^无有效工作流项目"
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetObjById(aWFItemID)
	Quit:'$IsObject(objWFItem) return
	Quit:'$IsObject(objWFItem.WFIItem) return
	Set WFIItemDesc=objWFItem.WFIItem.WIDesc
	Set WFIType=objWFItem.WFIType
	Set WFISubFlow=objWFItem.WFISubFlow
	Set WFIPostStep=objWFItem.WFIPostStep
	Set WFISysOpera=objWFItem.WFISysOpera
	Set WFIPreStep=objWFItem.WFIPreStep
	Set WFIPreItems=objWFItem.WFIPreItems
	
	Set return="-2^无有效病案卷"
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolID)
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return  //卷无效
	Set objMain=objVol.SVMainDr
	Quit:'$IsObject(objMain) return
	Quit:objMain.SMIsActive'=1 return    //病案无效
	Quit:'$IsObject(objMain.SMMrType) return
	Set MrTypeID=objMain.SMMrType.%Id()
	Set OrdStep=objVol.SVOrdStep
	Set QCLock=objVol.SVQCLock
	
	//前置步骤不符不允许顺序操作
	Set return="-3^当前病案卷不允许【"_WFIItemDesc_"】"
	If WFIType="O" {  //顺序操作
		Quit:(WFIPreStep'="")&&(WFIPreStep'[OrdStep) return  //前置步骤错误
		If WFISubFlow="O" {  //顺序操作
			Quit:QCLock>0 return  //质控锁定,不允许当前操作
		} Else {  //质控操作
			If WFISysOpera="H" {
				Quit:QCLock>0 return  //质控锁定，不允许重复锁定
			} ElseIf WFISysOpera="B" {
				Quit:QCLock<1 return  //质控非锁定，不允许重复解锁
			} Else {}
		}
	} Else {  //突发操作
		Set IsHappenStatus=$$GetHappenStatus(aVolID,MrTypeID,WFISubFlow)
		If WFISysOpera="H" {  //突发发生
			Quit:IsHappenStatus=1 return  //有突发发生操作，不允许重复突发发生操作
		} ElseIf WFISysOpera="B" {  //突发还回
			Quit:IsHappenStatus=0 return  //无突发发生操作，不允许突发还回操作
		} Else {}
	}
	
	Set return="-4^当前病案卷不允许【"_WFIItemDesc_"】"
	Set PreItemCnt=0,PassItemCnt=0
	For indItm=1:1:$l(WFIPreItems,"#") {
		Set PreItemID=$p(WFIPreItems,"#",indItm)
		Continue:PreItemID=""
		Set PreItemCnt=PreItemCnt+1
	}
	
	Set WFIPreItems="#"_WFIPreItems_"#"
	
	Set LogStatusList=""
	Set VolCnt=objVol.ChildStatus.Count()
	For indVol=1:1:VolCnt {
		Set objStatus=objVol.ChildStatus.GetAt(indVol)
		Continue:'$IsObject(objStatus)
		Continue:'$IsObject(objStatus.VSStatus)
		Continue:objStatus.VSUpdoOpera'=""  //卷操作撤销标记（B回置、U作废）
		Set StatusID=objStatus.VSStatus.%Id()
		Set LogStatusList=LogStatusList_$lb(StatusID)
	}
	
	Set CheckFlg=1
	For indPre = 1:1:$l(WFIPreItems,"#"){	//逐个检查配置的前提操作
		Set PreItem = $p(WFIPreItems,"#",indPre)
		Continue:PreItem=""
		Continue:$listfind(LogStatusList,PreItem)>0
		Set CheckFlg=0
	}
	Quit:CheckFlg=0 return
	
	//特殊情况检查
	If WFISysOpera="S" { //病案归档操作检查
		//无纸化项目,"病案归档"时检查纸张病历是否"扫描完成"
		Set NoPaperSysSetting = ##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("NoPaperSysSetting","") //无纸化项目设置
		Set IsExPaper=objVol.SVIsExPaper			//该病历是否有纸质病历
		If (NoPaperSysSetting>0)&(IsExPaper=1) {
			Set objSOWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"SO")
			Set:'$IsObject(objSOWFItem) return="-5.1^无纸化病案系统：有纸张病历,请在工作流中配置病案扫描操作项!"
			Quit:'$IsObject(objSOWFItem) return

			Set SOWorkItemID=objSOWFItem.WFIItem.%Id()
			If $listfind(LogStatusList,SOWorkItemID)<1 {
				Set return="-5.2^无纸化病案系统：有纸张病历,未扫描完成,不允许归档!"
				Quit return
			}
		}
	}
	
	Set return=1
	Quit return
	
GetHappenStatus(aVolID,aMrTypeID,aSubFlow)
	New (aVolID,aMrTypeID,aSubFlow)
	Set HasHRecord=0
	Set xCatCode=""
	For {
		Set xCatCode=$o(^DHCWMR.SS.VolumeI("VS","IndexStatusCate",aVolID,xCatCode))
		Quit:xCatCode=""
		Quit:HasHRecord>0  //存在即退出
		
		Set xWorkItemID=0
		For {
			Set xWorkItemID=$o(^DHCWMR.SS.VolumeI("VS","IndexStatusCate",aVolID,xCatCode,xWorkItemID))
			Quit:xWorkItemID=""
			Quit:HasHRecord>0  //存在即退出
			
			Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(aMrTypeID,xWorkItemID)
			Continue:'$IsObject(objWFItem)
			Continue:objWFItem.WFISubFlow'=aSubFlow
			Continue:objWFItem.WFISysOpera'="H"  //突发发生操作
			
			Set xSubID=0
			For {
				Set xSubID=$o(^DHCWMR.SS.VolumeI("VS","IndexStatusCate",aVolID,xCatCode,xWorkItemID,xSubID))
				Quit:xSubID=""
				Quit:HasHRecord>0  //存在即退出
				
				Set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(aVolID_"||"_xSubID)
				Continue:'$IsObject(objStatus)
				Continue:objStatus.VSUpdoOpera="U"
				Continue:objStatus.VSLnkOperaDr'=""
				Set HasHRecord=1
			}
		}
	}
	Quit HasHRecord
}

/// Creator：     zhufei
/// CreatDate：   2014-09-17
/// Description:  病案流程操作主程序（同一份病案）
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume
/// Input：       VolIDs : 病案卷ID列表
///               WFItemID : 工作流项目
///               WFDetail : 附加项目列表
///               UserID : 操作员（SS_User.ID）
///               ToUserID : 接收人员（SS_User.ID）
///               CatCode : 作废，为了程序兼容性保留此参数
/// Return：      return>0:操作成功，return<0:操作失败
/// w ##class(DHCWMR.SSService.OperationSrv).Operation(12,"1||19","",1,"","","","")
ClassMethod Operation(aRecordID As %String, aWFItemID As %String, aWFDetail As %String, aUserID As %String, aToUserID As %String, aCatCode As %String, aBatchNumber As %String, aResume As %String = "") As %String
{
	New (aRecordID,aWFItemID,aWFDetail,aUserID,aToUserID,aCatCode,aBatchNumber,aResume)
	Set return="0^参数错误"
	Quit:(aRecordID="")||(aWFItemID="")||(aUserID="") return
	
	Set:aBatchNumber="" aBatchNumber=##class(DHCWMR.SSService.OperationSrv).GetBatchNumber()
	
	Set aVolID=$p(aRecordID,"-",1)
	Set aStatusID=$p(aRecordID,"-",2)
	Set aRequestID=$p(aRecordID,"-",3)
	Quit:aVolID="" return
	
	//病案卷信息
	Set return="-1^病案卷无效"
	Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(aVolID)
	Quit:VolAdmStr="" return
	Set VolAdmID=$p(VolAdmStr,",",1)
	Set objVolAdm=##Class(DHCWMR.SS.VolPaadm).GetPatObjByAdm("","",VolAdmID)
	Quit:'$IsObject(objVolAdm) return
	Set EpisodeID=objVolAdm.VPEpisodeID
	Set PatientID=objVolAdm.VPPatientID
	Set objVol=objVolAdm.Parref
	Set objMain=objVol.SVMainDr
	Set VolID=objVol.%Id()
	Set MainID=objMain.%Id()
	Set MrTypeID=objMain.SMMrType.%Id()
	
	//工作流项目
	Set return="-2^操作项目无效"
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetObjById(aWFItemID)
	Quit:'$IsObject(objWFItem) return
	Quit:'$IsObject(objWFItem.WFIItem) return
	Set WorkItemID=objWFItem.WFIItem.%Id()
	Set WFIType=objWFItem.WFIType
	Set WFISubFlow=objWFItem.WFISubFlow
	Set WFISysOpera=objWFItem.WFISysOpera
	Set WFIPostStep=objWFItem.WFIPostStep
	
	Set return="-3^状态或申请记录错误"
	Set RequestID=""
	If aStatusID'="" {
		Set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(aStatusID)
		Quit:'$IsObject(objStatus) return
		If $IsObject(objStatus.VSRequestDr){
			Set RequestID=objStatus.VSRequestDr.%Id()
		}
	} Else {
		Set RequestID=aRequestID
	}
	
	TStart
	
	Set return="-4^保存附加项目失败"
	If (aWFDetail'="") {
		Set flg=##class(DHCWMR.SSService.RequestSrv).SaveRequest(RequestID,MrTypeID,WorkItemID,aWFDetail,aUserID,aVolID,aBatchNumber)
		If (+flg)<1 TRollback
		Quit:(+flg)<1 return
		Set RequestID=+flg
	}
	
	Set return="-5^保存病案操作失败"
	Set objOperation=##class(DHCWMR.SS.Operation).GetObjByBatchNumber(aBatchNumber)
	If '$IsObject(objOperation){
		Set InputStr=""
		Set InputStr=InputStr_"^"_MrTypeID
		Set InputStr=InputStr_"^"_WorkItemID
		Set InputStr=InputStr_"^"_aUserID
		Set InputStr=InputStr_"^"_""  //操作日期
		Set InputStr=InputStr_"^"_""  //操作时间
		Set InputStr=InputStr_"^"_aToUserID
		Set InputStr=InputStr_"^"_aBatchNumber
		Set InputStr=InputStr_"^"_1
		Set InputStr=InputStr_"^"_aResume
		Set flg=##class(DHCWMR.SS.Operation).Update(InputStr,"^")
		If (+flg)<1 TRollback
		Quit:(+flg)<1 return
		Set OperationID=+flg
	} Else {
		Set OperationID=objOperation.%Id()
	}
	
	Set return="-6^保存病案卷操作关联记录失败"
	If aStatusID'="" {
		Set flg=##class(DHCWMR.SS.VolStatus).UpdateLnkOpera(aStatusID,OperationID)
		If (+flg)<1 TRollback
		Quit:(+flg)<1 return
	}
	
	Set return="-7^保存病案卷操作记录失败"
	Set InputStr=aVolID
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_WorkItemID
	Set InputStr=InputStr_"^"_aUserID
	Set InputStr=InputStr_"^"_+$h
	Set InputStr=InputStr_"^"_$p($h,",",2)
	Set InputStr=InputStr_"^"_aToUserID
	Set InputStr=InputStr_"^"_aBatchNumber
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_aResume
	Set InputStr=InputStr_"^"_1
	Set InputStr=InputStr_"^"_RequestID
	Set InputStr=InputStr_"^"_""
	Set flg=##class(DHCWMR.SS.VolStatus).Update(InputStr,"^")
	If (+flg)<1 TRollback
	Quit:(+flg)<1 return
	
	Set return="-8^处理病案卷主表状态失败"
	Set InputStr=VolID
	Set InputStr=InputStr_"^"_MainID
	Set InputStr=InputStr_"^"_WorkItemID
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
	If WFISubFlow="O" {
		Quit:WFIPostStep="" return
		Set $p(InputStr,"^",4)=WFIPostStep
		
		If EpisodeID'="" {
			Set flg=##class(DHCWMR.SS.VolPaadm).UpdateByVol(aVolID)	//同步卷首页信息
			If (+flg)<1 TRollback
			Quit:(+flg)<1 return
			
			Set DischDate=##Class(DHCWMR.IO.FromAdmSrv).GetDischDateTime(EpisodeID)
			Set:DischDate'="" DischDate=$p(DischDate,"^",1)
			Set:DischDate["-" DischDate=$zdh(DischDate,3)
			Set $p(InputStr,"^",9)=DischDate //出院日期
		}
		
		If WFISysOpera="DS" { //提交病历
		} ElseIf WFISysOpera="RC" { //病案回收
			Set $p(InputStr,"^",10)=+$h  //回收日期
		} ElseIf WFISysOpera="S" { //归档上架
		} Else {}
	} ElseIf WFISubFlow="Q" {
		Set QCLock=$p(InputStr,"^",8)
		If WFISysOpera="H" { //突发发生
			Set QCLock=1
		} ElseIf WFISysOpera="B" { //突发还回
			Set QCLock=-1
		} Else {}
		Set $p(InputStr,"^",8)=QCLock
	} ElseIf WFISubFlow="L" {
		Set $p(InputStr,"^",5)=1
	} ElseIf WFISubFlow="C" {
		Set $p(InputStr,"^",6)=1
	} ElseIf WFISubFlow="S" {
		Set $p(InputStr,"^",7)=1
	} Else {}
	
	Set flg=##class(DHCWMR.SS.Volume).Update(InputStr,"^")
	If (+flg)<1 TRollback
	Quit:(+flg)<1 return
	
	TCommit
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-17
/// Description:  检查病案/病案卷撤销操作条件
/// Table：       DHCWMR.SS.VolStatus
/// Input：       MStatusID : 病案状态ID
///               VStatusID : 病案卷状态ID
/// Return：      return<0:条件不符  return>0：条件符合
/// w ##class(DHCWMR.SSService.OperationSrv).CheckUpdoOperation("12||8")
ClassMethod CheckUpdoOperation(aVStatusID As %String) As %String
{
	New (aVStatusID)
	Set return=0
	Quit:aVStatusID="" return
	
	Set return="-1^当前病案卷操作记录无效"
	Set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(aVStatusID)
	Quit:'$IsObject(objStatus) return
	Quit:objStatus.VSUpdoOpera'="" return  //作废或撤销的操作不允许重复撤销
	Quit:'$IsObject(objStatus.VSStatus) return
	Set CurrItemID=objStatus.VSStatus.%Id()
	Set objVol=objStatus.Parref
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return  //卷无效
	Set VolID=objVol.%Id()
	Set objMain=objVol.SVMainDr
	Quit:'$IsObject(objMain) return
	Quit:objMain.SMIsActive'=1 return    //病案无效
	Quit:'$IsObject(objMain.SMMrType) return
	Set MainID=objMain.%Id()
	Set MrTypeID=objMain.SMMrType.%Id()
	Quit:(MrTypeID="")||(CurrItemID="") return
	
	Set return="-2^无有效工作流项目"
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(MrTypeID,CurrItemID)
	Quit:'$IsObject(objWFItem) return
	Quit:'$IsObject(objWFItem.WFIItem) return
	Set WFIItemDesc=objWFItem.WFIItem.WIDesc
	Set WFIType=objWFItem.WFIType
	Set WFISubFlow=objWFItem.WFISubFlow
	Set WFISysOpera=objWFItem.WFISysOpera
	Set WFIPostStep=objWFItem.WFIPostStep
	
	Set return="-3^当前病案卷不允许撤销【"_WFIItemDesc_"】"
	Set objVol=objStatus.Parref
	If (WFIType="O")&&(WFIPostStep'=""){
		Quit:objVol.SVOrdStep'=WFIPostStep return
	}
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-17
/// Description:  病案流程操作撤销（同一份病案）
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume
/// Input：       MainStatusIDs : 病案状态ID列表
///               UserID : 操作员（SS_User.ID）
/// Return：      return>0:操作成功，return<0:操作失败
/// w ##class(DHCWMR.SSService.OperationSrv).UpdoOperation("12||8",1,"测试")
ClassMethod UpdoOperation(aVStatusID As %String, aUserID As %String, aUpdoReason As %String) As %String
{
	New (aVStatusID,aUserID,aUpdoReason)
	Set return="0^参数错误"
	Quit:(aVStatusID="")||(aUserID="") return
	
	Set return="-1^病案卷操作记录错误"
	Set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(aVStatusID)
	Quit:'$IsObject(objStatus) return
	Quit:objStatus.VSUpdoOpera'="" return  //作废或撤销的操作不允许重复撤销
	Quit:'$IsObject(objStatus.VSStatus) return
	Set CurrItemID=objStatus.VSStatus.%Id()
	Set objVol=objStatus.Parref
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return
	Set VolID=objVol.%Id()
	Set objMain=objVol.SVMainDr
	Quit:'$IsObject(objMain) return
	Quit:objMain.SMIsActive'=1 return
	Quit:'$IsObject(objMain.SMMrType) return
	Set MainID=objMain.%Id()
	Set MrTypeID=objMain.SMMrType.%Id()
	Quit:(MrTypeID="")||(CurrItemID="") return
	
	Set return="-2^工作流项目错误"
	Set objCurrWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(MrTypeID,CurrItemID)
	Quit:'$IsObject(objCurrWFItem) return
	Set WFIType=objCurrWFItem.WFIType
	Set WFISubFlow=objCurrWFItem.WFISubFlow
	Set WFISysOpera=objCurrWFItem.WFISysOpera
	Set WFIPostStep=objCurrWFItem.WFIPostStep
	Set WFIPreStep=objCurrWFItem.WFIPreStep
	
	TStart
	
	Set return="-3^撤销病案卷操作失败"
	Set flg=##class(DHCWMR.SS.VolStatus).UpdoUpdate(aVStatusID,"U",aUpdoReason,aUserID)
	If flg<1 TRollback
	Quit:flg<1 return
	
	//取卷当前状态
	Set BackItemID=..GetCurrWorkItem(aVStatusID)
	
	Set return="-4^处理病案卷主表状态失败"
	Set InputStr=VolID
	Set InputStr=InputStr_"^"_MainID
	Set InputStr=InputStr_"^"_BackItemID
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
	Set tmpStatus=##class(DHCWMR.SSService.OperationSrv).GetStatusStr(VolID,WFISubFlow,aVStatusID)
	If WFISubFlow="O" {
		Quit:WFIPreStep="" return
		Set $p(InputStr,"^",4)=WFIPreStep
		If WFISysOpera="RC" { //病案回收
			Set $p(InputStr,"^",10)=""
		}
	} ElseIf WFISubFlow="Q" {
		Set $p(InputStr,"^",8)=$p(tmpStatus,",",1)
	} ElseIf WFISubFlow="L" {
		Set $p(InputStr,"^",5)=$p(tmpStatus,",",2)
	} ElseIf WFISubFlow="C" {
		Set $p(InputStr,"^",6)=$p(tmpStatus,",",3)
	} ElseIf WFISubFlow="S" {
		Set $p(InputStr,"^",7)=$p(tmpStatus,",",4)
	} Else {}
	
	Set flg=##class(DHCWMR.SS.Volume).Update(InputStr,"^")
	If flg<1 TRollback
	Quit:flg<1 return
	
	TCommit
	
	Set return=1
	Quit return
}

/// w ##class(DHCWMR.SSService.OperationSrv).GetStatusStr("12||8",1,"测试")
ClassMethod GetStatusStr(aVolID As %String, aSubFlow As %String, aStatusID As %String = "") As %String
{
	New (aVolID,aSubFlow,aStatusID)
	Set return=""
	Quit:(aVolID="")||(aSubFlow="") return
	
	Set (QCLock,QCLock1,IsLend,IsCopy,IsStore)=0
	Set xSubID=0
	For {
		Set xSubID=$o(^DHCWMR.SS.VolumeD(aVolID,"S",xSubID))
		Quit:xSubID=""
		
		Set StatusID=aVolID_"||"_xSubID
		Continue:(aStatusID'="")&&(StatusID=aStatusID)
		Set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(StatusID)
		Continue:'$IsObject(objStatus)
		Continue:objStatus.VSUpdoOpera="U"
		Continue:'$IsObject(objStatus.VSStatus)
		Set WorkItemID=objStatus.VSStatus.%Id()
		Continue:'$IsObject(objStatus.Parref)
		Continue:'$IsObject(objStatus.Parref.SVMainDr)
		Continue:'$IsObject(objStatus.Parref.SVMainDr.SMMrType)
		Set MrTypeID=objStatus.Parref.SVMainDr.SMMrType.%Id()
		
		Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(MrTypeID,WorkItemID)
		Continue:'$IsObject(objWFItem)
		Continue:objWFItem.WFISubFlow'=aSubFlow
		
		If aSubFlow="Q" {
			Set QCLock1=1
			Continue:objWFItem.WFISysOpera'="H"
			Set QCLock=1
		} ElseIf aSubFlow="L" {
			Set IsLend=1
			Quit
		} ElseIf aSubFlow="C" {
			Set IsCopy=1
			Quit
		} ElseIf aSubFlow="S" {
			Set IsStore=1
			Quit
		} Else {}
	}
	Set:(QCLock1=1)&&(QCLock=0) QCLock=-1
	Set return=QCLock_","_IsLend_","_IsCopy_","_IsStore
	Quit return
}

/// 取卷当前有效操作
ClassMethod GetCurrWorkItem(aVStatusID As %String) As %String
{
	New (aVStatusID)
	Set return=""
	Quit:aVStatusID="" return
	
	Set objStatus=..GetLastVolStatus(aVStatusID) //最后操作
	If $IsObject(objStatus){
		Set:$IsObject(objStatus.VSStatus) return=objStatus.VSStatus.%Id()
	}
	Quit:return'="" return
	
	Set objStatus=..GetPreVolStatus(aVStatusID) //前一操作
	If $IsObject(objStatus){
		Set:$IsObject(objStatus.VSStatus) return=objStatus.VSStatus.%Id()
	}
	Quit:return'="" return
	
	Quit return
}

/// 查询前一操作记录
ClassMethod GetPreVolStatus(aVStatusID As %String) As DHCWMR.SS.VolStatus
{
	New (aVStatusID)
	Set return=""
	Quit:aVStatusID="" return
	
	Set VolID=+aVStatusID
	Set xSub=+$p(aVStatusID,"||",2)
	For {
		Set xSub=$o(^DHCWMR.SS.VolumeD(VolID,"S",xSub),-1)
		Quit:(xSub="")||(xSub=0)
		Quit:return'=""
		Set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(VolID_"||"_xSub)
		Continue:'$IsObject(objStatus)
		Continue:objStatus.VSUpdoOpera'=""
		Continue:'$IsObject(objStatus.VSStatus)
		Set return=objStatus
	}
	Quit return
}

/// 查询最后操作记录
ClassMethod GetLastVolStatus(aVStatusID As %String) As DHCWMR.SS.VolStatus
{
	New (aVStatusID)
	Set return=""
	Quit:aVStatusID="" return
	
	Set VolID=+aVStatusID
	Set xSub=+$p(aVStatusID,"||",2)
	For {
		Set xSub=$o(^DHCWMR.SS.VolumeD(VolID,"S",xSub))
		Quit:xSub=""
		Set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(VolID_"||"_xSub)
		Continue:'$IsObject(objStatus)
		Continue:objStatus.VSUpdoOpera'=""
		Continue:'$IsObject(objStatus.VSStatus)
		Set return=objStatus
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-11-26
/// Description:  检查当前卷是否有暂存纸质病历
/// Table：       
/// Input：       aVolID : 卷ID
/// 			  aWFItemID ：当前操作流项目ID
/// Return：      return=1:有，return=0:没有
/// w ##class(DHCWMR.SSService.OperationSrv).IsVolTempstorage(2,"1||11")
ClassMethod IsVolTempstorage(aVolID As %String, aWFItemID As %String) As %String
{
	New (aVolID,aWFItemID)
	Set return = 0
	Set aVolID=+aVolID
	Quit:(aVolID=0)||(aWFItemID="") return
	
	Set objVol = ##class(DHCWMR.SS.Volume).GetObjById(aVolID)
	Quit:'$IsObject(objVol) return
	
	Set MrTypeID = objVol.SVMainDr.SMMrType.%Id()
	Set objWFItem = ##class(DHCWMR.SS.WorkFItem).GetObjById(aWFItemID)
	Quit:'$IsObject(objWFItem) return
	Quit:objWFItem.WFISysOpera'="S" return
	
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"TS")
	Quit:'$IsObject(objWFItem) return
	Quit:'$IsObject(objWFItem.WFIItem) return
	Set WorkItemID=objWFItem.WFIItem.%Id()

	Set CheckFlg = 0
	Set VolCnt=objVol.ChildStatus.Count()
	For indVol=1:1:VolCnt {
		Set objStatus=objVol.ChildStatus.GetAt(indVol)
		Continue:'$IsObject(objStatus)
		Continue:'$IsObject(objStatus.VSStatus)
		Continue:objStatus.VSUpdoOpera'=""  //卷操作撤销标记（B回置、U作废）
		Set StatusID=objStatus.VSStatus.%Id()
		Set:StatusID=WorkItemID CheckFlg=1
	}
	Set return =CheckFlg
	Quit return
}

}
