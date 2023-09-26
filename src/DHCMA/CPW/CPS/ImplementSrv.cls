/// 名称: DHCMA.CPW.CPS.ImplementSrv
/// 描述: 临床路径执行相关服务
/// 编写者：jiangpengpeng
/// 编写日期: 2018-08-25
Class DHCMA.CPW.CPS.ImplementSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-14
/// Description:  取用户类型
/// Table：       DHCMA.Util.EP.CareProv
/// Input：       DHCMA.Util.EP.SSUser.OID
/// Return：      N or D
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).GetUserType("9!!1")
ClassMethod GetUserType(aUserID As %String) As %String
{
	New (aUserID)
	Set return=""
	Quit:aUserID'["!!" return
	
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(aUserID)
	Quit:'$IsObject(objUser) return
	
	Set CareProvID=objUser.BTCareProvID
	Set objCarepP=##class(DHCMA.Util.EP.CareProv).GetObjByOID(CareProvID)
	Quit:'$IsObject(objCarepP) return
	
	Set Type=objCarepP.BTType
	Set return=Type
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-26
/// Description:  取临床路径状态及操作信息
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       EpisodeID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).GetCPWInfo("27!!1","2!!1")
ClassMethod GetCPWInfo(aEpisodeID As %String, aHospID As %String = "") As %String
{
	New (aEpisodeID,aHospID,%session)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Set:(aHospID="")&&($d(%session)) aHospID=$g(%session.Data("LOGON.HOSPID"))
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	Set PathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)	//取最新一条记录
	Quit:PathwayID="" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(objPathway) return
	
	Set PathFormID=objPathway.CPFormDr.%Id()
	Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc
	Set:CPWDesc'="" CPWDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",CPWDesc,LangID)
	Set CPWStatus=objPathway.CPStatus
	Set CPWStatus=$Case(CPWStatus,"I":"入径","O":"出径","C":"完成","U":"作废","P":"预约","A":"申请",:"")
	Quit:CPWStatus="" return
	
	//获取合并症信息
	Set xSubID="",ComplStr=""
	For {
		Set xSubID=$o(^DHCMA.CPW.CP.PathwayD(PathwayID,"COMPL",xSubID))
		Quit:xSubID=""
		
		Set objPwCompl=##class(DHCMA.CPW.CP.PathwayCompl).GetObjById(PathwayID_"||"_xSubID)
		Continue:'$IsObject(objPwCompl)
		Continue:'objPwCompl.CPIsActive
		Continue:'$IsObject(objPwCompl.CPComplFormDr.FormPathDr)
		Set tmpComplDesc=objPwCompl.CPComplFormDr.FormPathDr.BTDesc
		Set:tmpComplDesc'="" tmpComplDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",tmpComplDesc,LangID)
		Set strHB = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.cp.impl.csp","合并",LangID)	
		Set:tmpComplDesc'["合并" tmpComplDesc=strHB_tmpComplDesc
		Set ComplStr=ComplStr_"，"_tmpComplDesc
	}
	Set:ComplStr'="" ComplStr="（"_$e(ComplStr,2,$l(ComplStr))_"）"
	
	Set CPWUser=""
	Set UserID=objPathway.CPActUserID
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(UserID)
	Set:$IsObject(objUser) CPWUser=objUser.BTDesc
	
	//Set CPWTime=$zd(objPathway.CPActDate,3)_" "_$zt(objPathway.CPActTime,1)
	//将日期显示改为统一配置显示
	Set CPWDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical($zd(objPathway.CPActDate,3))
	Set CPWDate = ##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(CPWDate)
	Set CPWTime=CPWDate_" "_$zt(objPathway.CPActTime,1)
	
	Set CurrEpisID=$p(objPathway.CPEpisDr.%Id(),"||",2)
	Set CurrEpisDesc=objPathway.CPEpisDr.CPFormEpDr.EpDesc
	Set:CurrEpisDesc'="" CurrEpisDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc",CurrEpisDesc,LangID)
	Set CurrEpisNo=objPathway.CPEpisDr.CPIndNo
	
	Set SDDesc=objPathway.CPFormDr.FormPathDr.BTEntityDr.BTDesc	//单病种名称
	Set:SDDesc'="" SDDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathEntity","BTDesc",SDDesc,LangID)
	Set VarDesc="本次临床路径暂无变异信息"
	Set IsVar=0
	Set xVarID=""
	For {
		Set xVarID=$o(^DHCMA.CPW.CP.PathwayD(PathwayID,"VAR",xVarID))
		Quit:xVarID=""
		
		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(PathwayID_"||"_xVarID)
 		Continue:'$IsObject(objVar)
	 	Continue:(objVar.CPOrdDID="")&&('$IsObject(objVar.CPImplDr))
	 	
	 	Set IsVar=1
	 	Quit
	}
	Set:IsVar=1 VarDesc="本次临床路径已经发生变异"
	Set:VarDesc'="" VarDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.cp.impl.csp",VarDesc,LangID)	
	
	Set FormCost=objPathway.CPFormDr.FormCost
	Set FormDays=objPathway.CPFormDr.FormDays
	
	Set Feestr = ##class(DHCMA.Util.IO.FromFeeSrv).IGetTarMRCateFee(+aEpisodeID)				// 更新最新住院患者费用接口
	Set PatCost=$p(Feestr,"^",1)						//住院总费用
	Set PatShare=$p($p(Feestr,"^",2),$c(3),1)			// 患者自付金额
	// 根据配置返回是否进行费用提醒标志
	Set IsCostTip=0,LimitCost=""
	If +FormCost'=0{
		Set valTipParam=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWPatCostTipParam",aHospID)
		Set valParam=$p(valTipParam,"||",1)
		Set factParam=$p(valTipParam,"||",2)
		If (valParam="Y") && (factParam>0) && (factParam<=1){
			Set upperFormCost = $s((FormCost["-")&&(+$p(FormCost,"-",2)'=""):+$p(FormCost,"-",2),1:+FormCost)
			Set LimitCost=upperFormCost*factParam
			Set:+PatCost>+LimitCost IsCostTip=1	
		}	
	}
	Set CPWDays=0
	Set CPActDate=objPathway.CPActDate
	Set CPInDate=objPathway.CPInDate
	Set CPOutDate=objPathway.CPOutDate
	Set:CPWStatus="入径" CPWDays=+$H-CPInDate					//入径第一天不算
	Set:CPWStatus="完成" CPWDays=CPActDate-CPInDate
	Set:CPWStatus="出径" CPWDays=CPOutDate-CPInDate
	Set:(CPWStatus="完成"||CPWStatus="出径")&&(CPWDays=0) CPWDays=1		//当天入径且当天出径或完成的算1天
	Set:CPWStatus'="" CPWStatus=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",CPWStatus,LangID)
	Set ARStatus=objPathway.CPRunStatus
		
	Set Json="{"
	Set Json=Json_"""PathwayID"":"""_PathwayID_""","
	Set Json=Json_"""PathFormID"":"""_PathFormID_""","
	Set Json=Json_"""CPWDesc"":"""_CPWDesc_ComplStr_""","
	Set Json=Json_"""CPWStatus"":"""_CPWStatus_""","
	Set Json=Json_"""CPWEpisID"":"""_CurrEpisID_""","
	Set Json=Json_"""CPWEpisDesc"":"""_CurrEpisDesc_""","
	Set Json=Json_"""CPWUser"":"""_CPWUser_""","
	Set Json=Json_"""CPWTime"":"""_CPWTime_""","
	Set Json=Json_"""SDDesc"":"""_SDDesc_""","
	Set Json=Json_"""VarDesc"":"""_VarDesc_""","
	Set Json=Json_"""FormCost"":"""_FormCost_""","
	Set Json=Json_"""PatCost"":"""_PatCost_""","
	Set Json=Json_"""IsCostTip"":"""_IsCostTip_""","
	Set Json=Json_"""LimitCost"":"""_LimitCost_""","
	Set Json=Json_"""FormDays"":"""_FormDays_""","
	Set Json=Json_"""CPWDays"":"""_CPWDays_""","
	Set Json=Json_"""CurrEpisNo"":"""_CurrEpisNo_""","
	Set Json=Json_"""ARStatus"":"""_ARStatus_""""
	Set Json=Json_"}"
	
	Set return=Json
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-26
/// Description:  取临床路径步骤
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       EpisodeID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).GetCPWSteps(3)
ClassMethod GetCPWSteps(aPathwayID As %String) As %String
{
	New (aPathwayID,%session)
	Set return=""
	Quit:aPathwayID="" return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Quit:'$IsObject(objPathway) return
	
	Set CurrID=objPathway.CPEpisDr.%Id()
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set CPWStatus=objPathway.CPStatus
	
	Set PreEndDate="",PreEndTime=""
	Set (CurrStep,StepList,TimeList,ConfList,SignList,NoteList)=""
	
	Set NIndex="GetCPWSteps"
    Kill ^TMP($zn,$j,NIndex)
    
    Set IsExec=0
    Set PreBTFormID=""
	Set xEpisID=""
	For {
		Set xEpisID=$o(^DHCMA.CPW.CP.PathwayD(aPathwayID,"EPIS",xEpisID))
		Quit:xEpisID=""
			
		Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aPathwayID_"||"_xEpisID)
		Continue:'$IsObject(objEpis)
		
		Set IsActive=objEpis.CPIsActive
		Continue:'IsActive
		
		Set IndNo=objEpis.CPIndNo
		Set BTFormEpID=objEpis.CPFormEpDr.%Id()
		Set BTFormID=$p(BTFormEpID,"||",1)
		If (PreBTFormID'=BTFormID) {
			Set IsExec=IsExec+1
			Set PreBTFormID=BTFormID
		}
		Set ^TMP($zn,$j,NIndex,IsExec,IndNo,xEpisID)=""
	}
	
	Set ind=0
	Set PreExec=1
	Set xIsExec=""
	For {
		Set xIsExec=$o(^TMP($zn,$j,NIndex,xIsExec))
		Quit:xIsExec=""
		
		Set xIndNo=""
		For {
			Set xIndNo=$o(^TMP($zn,$j,NIndex,xIsExec,xIndNo))
			Quit:xIndNo=""
			
			Set SetpNote=""
			Set xEpisID=""
			For {
				Set xEpisID=$o(^TMP($zn,$j,NIndex,xIsExec,xIndNo,xEpisID))
				Quit:xEpisID=""
				
				Set xobjEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aPathwayID_"||"_xEpisID)
				Set IsConfirm=xobjEpis.CPIsConfirm
				Set ConfList=ConfList_"^"_IsConfirm
				
				Set ind=ind+1
				Set EpDays=+xobjEpis.CPEpDays_"天"
				Set SttDate=xobjEpis.CPSttDate
				Set SttTime=xobjEpis.CPSttTime
				Set:(ind=1)&&(SttDate="") SttDate=objPathway.CPInDate	//第一阶段开始日期为入径日期
				Set:(ind=1)&&(SttTime="") SttTime=objPathway.CPInTime	//第一阶段开始时间为入径时间
				Set:(PreEndDate'="")&&(SttDate="") SttDate=PreEndDate	//下一阶段的开始日期为上一阶段结束日期
				Set:(PreEndTime'="")&&(SttTime="") SttTime=PreEndTime	//下一阶段的开始时间为上一阶段结束时间
				Set SttDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(SttDate)
				Set SttTime=##Class(DHCMA.Util.IO.FromHisSrv).ChangeTimeFormat(SttTime,1)
				Set EndDate=xobjEpis.CPEndDate
				Set EndTime=xobjEpis.CPEndTime
				Set PreEndDate=EndDate
				Set PreEndTime=EndTime
				Set EndDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(EndDate)
				Set EndTime=##Class(DHCMA.Util.IO.FromHisSrv).ChangeTimeFormat(EndTime,1)
				Set SttDateTime=$s(SttTime="":SttDate,1:SttDate_" "_SttTime)
				Set EndDateTime=$s(EndTime="":EndDate,1:EndDate_" "_EndTime)
				Set StepTime=EpDays_"*"_SttDateTime_"*"_EndDateTime
				Set TimeList=TimeList_"^"_StepTime
				
				Set (SignDoc,SignNur)=""
				Set SignDocID=xobjEpis.CPSignDocID
				Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(SignDocID)
				Set:$IsObject(objUser) SignDoc=objUser.BTDesc
				Set SignNurID=xobjEpis.CPSignNurID
				Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(SignNurID)
				Set:$IsObject(objUser) SignNur=objUser.BTDesc
				Set SignDocDate=xobjEpis.CPSignDocDate
				Set SignDocDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(SignDocDate)
				Set SignNurDate=xobjEpis.CPSignNurDate
				Set SignNurDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(SignNurDate)
				Set Sign=SignDoc_":"_SignNur_":"_SignDocDate_":"_SignNurDate
				Set SignList=SignList_"^"_Sign
				
				Set StepDesc=xobjEpis.CPFormEpDr.EpDesc
				Set:StepDesc'="" StepDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc",StepDesc,LangID)

				Set Step=xEpisID_":"_StepDesc
				Set:xobjEpis.%Id()=CurrID CurrStep=Step
				Set StepList=StepList_"^"_Step
				
				Set CPWDesc=xobjEpis.CPFormEpDr.Parref.FormPathDr.BTDesc
				Set:CPWDesc'="" CPWDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",CPWDesc,LangID)

				Set SetpNote=":"_CPWDesc
				If (SttDate'="") {
					If (ind=1){
						Set SetpNote="F"_SetpNote
					}
					If (CPWStatus="O") {
						Set:xobjEpis.%Id()=CurrID SetpNote="O"_SetpNote
					}
					If (CPWStatus="C") {
						Set:xobjEpis.%Id()=CurrID SetpNote="C"_SetpNote
					}
					If (PreExec'=xIsExec) {
						Set SetpNote="S"_SetpNote
						Set PreExec=xIsExec
					}
					Set:$p(SetpNote,":",1)="" SetpNote="E:"_CPWDesc
				}
				Set NoteList=NoteList_"^"_SetpNote
				
			}
		}
	}

	Set:StepList'="" StepList=$e(StepList,2,$l(StepList))
	Set:TimeList'="" TimeList=$e(TimeList,2,$l(TimeList))
	Set:ConfList'="" ConfList=$e(ConfList,2,$l(ConfList))
	Set:SignList'="" SignList=$e(SignList,2,$l(SignList))
	Set:NoteList'="" NoteList=$e(NoteList,2,$l(NoteList))
	Set return=CurrStep_"#"_StepList_"#"_TimeList_"#"_ConfList_"#"_SignList_"#"_NoteList
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-26
/// Description:  阶段确定操作，更新当前步骤
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       EpisodeID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).ConfirmStep("11||4","2022-11-04","2022-11-05","12175!!1","11||5","2!!1")
ClassMethod ConfirmStep(aEpisID As %String, aSttDate As %String, aEndDate As %String, aUserID As %String, aNextEpisID As %String, aHospID As %String = "") As %String
{
	New (aEpisID,aSttDate,aEndDate,aUserID,aNextEpisID,aHospID,%session)
	Set return=""
	Quit:(aEpisID="")||(aSttDate="")||(aEndDate="")||(aUserID="") return
	
	Set:(aHospID="")&&($d(%session)) aHospID=$g(%session.Data("LOGON.HOSPID"))
	Set aPathwayID=$p(aEpisID,"||",1)
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Quit:'$IsObject(objPathway) -1
	
	Set $ZT="ConfirmStepError"
	TStart
	
	// 根据配置获取是否自动执行诊疗项目
	Set IsAutoExeItem = ##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIsAutoExeClinicItemOnCfmEp",aHospID)
	If IsAutoExeItem="Y"{
		Set xItemID="",retExe=1
		For {
			Set xItemID = $o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aEpisID,xItemID))
			Quit:xItemID=""
			
			Set objItem = ##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xItemID)
			Continue:'$IsObject(objItem)
			Continue:'objItem.CPIsActive
			Continue:objItem.CPIsImp=1
			Continue:'$IsObject(objItem.CPFormItemDr)
			Continue:'$IsObject(objItem.CPFormItemDr.ItemCatDr)
			Continue:objItem.CPFormItemDr.ItemCatDr.BTTypeDr.BTCode'="A"		//只遍历主要诊疗工作
			
			Set retExe=##class(DHCMA.CPW.CP.PathwayImpl).ExecuteItem(aPathwayID,xItemID,"",aUserID,1,1)
			If +retExe<=0{
				TRollBack
				Quit	
			}	
		}
		Quit:+retExe<=0 -2
	}
	
	Set:aNextEpisID'="" objPathway.CPEpisDr=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aNextEpisID)
	Set sc=objPathway.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		//Do $system.OBJ.DisplayError(sc) 
   		TRollBack
   		Quit -3
	}
	Do objPathway.%Close()
	
	Set return=##class(DHCMA.CPW.CP.PathwayEpis).Confirm(aEpisID,aSttDate,aEndDate,aUserID)
	If (+return>0) {
		//处理长期医嘱执行记录
		Do ..CheckOEOrdImplByEpis(aNextEpisID,aHospID)
		//Do ..CheckOEOrdImplByEpis(aEpisID,aHospID)		// 此处有何用？
	}Else{
		TRollBack
		Quit -4	
	}
	
	If $TLevel>0 TCommit
	Quit return
	
ConfirmStepError
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     dengshaopeng
/// CreatDate：   2020-07-15
/// Description:  撤销阶段操作，更新当前步骤
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       EpisodeID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).RevokeStep("15||1","04/01/2019","5337!!1","2")
ClassMethod RevokeStep(aEpisID As %String, aUserID As %String, aBackEpisID) As %String
{
	New (aEpisID,aUserID,aBackEpisID)
	Set return=""
	Quit:(aEpisID="")||(aUserID="") return
	
	Set aPathwayID=$p(aEpisID,"||",1)
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Quit:'$IsObject(objPathway) "-1"
	
	Set:aBackEpisID'="" objPathway.CPEpisDr=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aBackEpisID)
	
	Set sc=objPathway.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		//Do $system.OBJ.DisplayError(sc) 
   		Set return=-9
	}Else{
		Set ret=##class(DHCMA.CPW.CP.PathwayEpis).Revoke(aEpisID,aUserID)
		Set return=ret
	}
	Do objPathway.%Close()
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-26
/// Description:  取临床路径阶段签名信息
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       EpisodeID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).GetStepSign("8||1")
ClassMethod GetStepSign(aEpisID As %String) As %String
{
	New (aEpisID)
	Set return=""
	Quit:aEpisID="" return
	
	Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aEpisID)
	Quit:'$IsObject(objEpis) return
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	
	Set (SignDoc,SignNur)=""
	Set SignDocID=objEpis.CPSignDocID
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(SignDocID)
	Set:$IsObject(objUser) SignDoc=objUser.BTDesc
	Set SignNurID=objEpis.CPSignNurID
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(SignNurID)
	Set:$IsObject(objUser) SignNur=objUser.BTDesc
	
	Set SignDocDate=objEpis.CPSignDocDate
	Set SignDocDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(SignDocDate)
	Set SignNurDate=objEpis.CPSignNurDate
	Set SignNurDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(SignNurDate)
	
	Set return=SignDoc_"^"_SignNur_"^"_SignDocDate_"^"_SignNurDate
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-25
/// Description:  查询阶段里的项目
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aEpisodeID : 就诊号
///               aType : T诊疗N护理O医嘱
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.ImplementSrv","QryCPWStepInfo","2","2||5","O")
Query QryCPWStepInfo(aPathwayID As %String, aEpisID As %String, aType As %String) As %Query(ROWSPEC = "ID:%String,Operation:%String,IndexNo:%Integer,ItemInfo:%String,IsRequired:%String,OperInfo:%String,IsSystem:%String,IsImp:%String,IsVar:%String,Node:%String") [ SqlProc ]
{
}

ClassMethod QryCPWStepInfoExecute(ByRef qHandle As %Binary, aPathwayID As %String, aEpisID As %String, aType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aPathwayID="")||(aEpisID="") $$$OK
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
 	Set aTypeDesc=$Case(aType,"T":"主要诊疗工作","N":"主要护理工作","O":"重点医嘱",:"")
 	Set xImplID=""
 	For {
 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aEpisID,xImplID))
 		Quit:xImplID=""
 		
 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xImplID)
 		Continue:'$IsObject(objImpl)
 		Continue:objImpl.CPPathwayComplDr'=""
 		
 		Set IsActive=objImpl.CPIsActive
 		Continue:'IsActive
 		
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 		Continue:(aTypeDesc'="")&&(aTypeDesc'=TypeDesc)
 		
 		Set ItemDesc=objImpl.CPFormItemDr.ItemDesc
 		Set IndexNo=objImpl.CPFormItemDr.ItemIndNo
 		Set IsRequired=+'objImpl.CPFormItemDr.ItemIsOption	//两变量值相反
 		
 		Set IsSystem=objImpl.CPIsSystem
 		Set Node=objImpl.CPNode
 		Set ActDate=objImpl.CPActDate
 		Set ActDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ActDate)
 		Set ActTime=objImpl.CPActTime
 		Set:ActTime'="" ActTime=$zt(ActTime,1)
 		Set ActUserID=objImpl.CPActUserID
 		Set UserDesc=""
 		If ActUserID="SYS" {
 			Set UserDesc="系统执行"
 			Set:UserDesc'="" UserDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.cp.cpimpl.csp",UserDesc,LangID)	
 		}else{
	 		Set:ActUserID'["!!" ActUserID=ActUserID_"!!"_1
	 		Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
			Set:$IsObject(objUser) UserDesc=objUser.BTDesc
 		}
		Set IsImp=objImpl.CPIsImp
		If (IsImp) {
			Set OperInfo=ActDate_" "_ActTime_","_UserDesc
			Set Operation="0^1"	
			Set:aType="O" Operation="1^1"
		} Else {
			Set Operation="1^0"
 			Set OperInfo=""
		}
		
		Set IsVar=0	//是否变异
		Set xVarID=""
 		For {
			Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEpImpl",aPathwayID,aEpisID,aPathwayID_"||"_xImplID,xVarID))
			Quit:xVarID=""
			
	 		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
	 		Continue:'$IsObject(objVar)
		 	Continue:'objVar.CPIsActive
	 		Set IsVar=1
	 		Quit
	 	}
 		
 		Set:ItemDesc'="" ItemDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormItem","ItemDesc",ItemDesc,LangID)
 		Set Data=$lb(xImplID,Operation,IndexNo,ItemDesc,IsRequired,OperInfo,IsSystem,IsImp,IsVar,Node)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
 	
 	Quit $$$OK
}

ClassMethod QryCPWStepInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWStepInfoExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWStepInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWStepInfoExecute ]
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

/// Creator：     zqy
/// CreatDate：   2022-5-13
/// Description:  查询当前病区下入径患者
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.ImplementSrv","QryAdmByWard","3")
Query QryAdmByWard(aWard As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatName:%String,Bed:%String,Flag:%String,Nurse:%String")
{
}

ClassMethod QryAdmByWardExecute(ByRef qHandle As %Binary, aWard As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
 	Set CurrentWard=""
 	For{
	 	Set CurrentWard=$o(^PAADMi("CurrWard",CurrentWard))
		Quit:CurrentWard=""	
		
		Continue:(aWard'="")&&(CurrentWard'=aWard)
		Set CurrentRoom=""
		For{
			Set CurrentRoom=$o(^PAADMi("CurrWard",CurrentWard,CurrentRoom))
			Quit:CurrentRoom=""	
			
			Set AdmID=""
			For{
				Set AdmID=$o(^PAADMi("CurrWard",CurrentWard,CurrentRoom,AdmID))
				Quit:AdmID=""	
				
				Set EpisodeID=AdmID_"!!"_SYSDr
				Set LocID=$p($g(^PAADM(AdmID)),"^",4)  //就诊科室
		 		Set AdmLocID=LocID_"!!"_SYSDr
		 		Set HospID=$p($g(^CTLOC(LocID)),"^",22)
		 		Set AdmHospID=HospID_"!!"_SYSDr
		 		//检查是否强制签名
		 		Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWCheckSignBeforeClose",AdmHospID)
		 		Set SignFlag=0	//0:不需要签名;1:需要签名
		 		Set:(($p(ret,"||",1)="Y")&&($p(ret,"||",2)'=1)) SignFlag=1
				if $d(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID)){
					Set PathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)	//取最新一条记录
					Quit:PathwayID=""
					Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
					Continue:'$IsObject(objPathway)
					Set CPWStatus=objPathway.CPStatus
					Continue:CPWStatus'="I"  //"I":"入径","O":"出径","C":"完成","U":"作废","P":"预约","A":"申请"
					//S a=##Class(DHCMA.Util.EPy.EpisodeSrv).SetEpisInfo(EpisodeID)同步信息
					Set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
					Set Step=##class(DHCMA.CPW.CPS.ImplementSrv).GetCPWSteps(PathwayID)
					Set StepID=$p(Step,":",1)	//已经执行到当前步骤的ID
					Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(PathwayID_"||"_StepID)
					Continue:'$IsObject(objPat)
					Continue:'$IsObject(objEpis)
					Set PatName=objPat.PAPatName
					Set Bed=$p($g(^PAADM(AdmID)),"^",73)		//床号实时获取
					Set:Bed'="" Bed=$p($g(^PAWARD(+Bed,"BED",$p(Bed,"||",2))),"^",1)
					Set SignNurDate=objEpis.CPSignNurDate	//签名时间
					Set Flag=0 
					//0:不需要提醒签名;1:需要提醒签名,2:不必强制提醒签名
					Set:((SignNurDate'="")&&(SignFlag=1)) Flag=0
					Set:((SignNurDate="")&&(SignFlag=1)) Flag=1
					Set:((SignNurDate'="")&&(SignFlag=0)) Flag=0
					Set:((SignNurDate="")&&(SignFlag=0)) Flag=2
					Set SignNurDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(SignNurDate)
					Set Array=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("DHCMA.CPW.CPS.ImplementSrv","QryCPWStepInfo",PathwayID,PathwayID_"||"_StepID,"N")
					For Index=1:1:Array.Count() {
						Set Info=Array.GetAt(Index)
						Set OperInfo=Info.GetAt("OperInfo")
						Set Nurse=0		//护士未执行护理
						Quit:OperInfo=""
						Set Nurse=1
					}
					//Set Flag=$s(Flag=1:"待签名",Flag=2:"需签名",1:"已签名")
					//Set Nurse=$s(Nurse=1:"已执行",1:"待执行")
					Set Data=$lb(EpisodeID,PatName,Bed,Flag,Nurse)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}	
	Quit $$$OK
}

ClassMethod QryAdmByWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmByWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmByWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmByWardExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-10-17
/// Description:  变异原因树
/// Table：       DHCMA.CPW.BT.PathVariat
/// Input：       aPathFormID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).GetVariatTree("01","")
ClassMethod GetVariatTree(aTypeCode As %String, aCatCode As %String) As %String
{
	New (aTypeCode,aCatCode,%session)
	Set return="[]"
	Quit:aTypeCode="" return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Set xTypeID=""
	For {
		Set xTypeID=$o(^DHCMA.CPW.BT.PathVariatI("IdxofTypeCat",xTypeID))
		Quit:xTypeID=""
		
		Set objType=##class(DHCMA.Util.BT.Dictionary).GetObjById(xTypeID)
		Continue:'$IsObject(objType)
		Continue:(aTypeCode'="")&&(objType.BTCode'=aTypeCode)
		Set TypeDesc=objType.BTDesc
		Set:TypeDesc'="" TypeDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.DicType","BTDesc",TypeDesc,LangID)
		
		Set treeJson="["
		Set treeJson=treeJson_"{"
		Set treeJson=treeJson_"""id"":""VarTree"","
		Set treeJson=treeJson_"""text"":"""_TypeDesc_""","
		Set treeJson=treeJson_"""state"":""open"","
		Set treeJson=treeJson_"""children"":["
		
		Set CatJson=""
		Set xCatID=""
		For {
			Set xCatID=$o(^DHCMA.CPW.BT.PathVariatI("IdxofTypeCat",xTypeID,xCatID))
			Quit:xCatID=""
			
			Set objCat=##class(DHCMA.CPW.BT.PathVarCat).GetObjById(xCatID)
			Continue:'$IsObject(objCat)
			Continue:(aCatCode'="")&&(objCat.BTCode'=aCatCode)
			Set CatDesc=objCat.BTDesc
			Set:CatDesc'="" CatDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathVarCat","BTDesc",CatDesc,LangID)
			
			Set CatJson=CatJson_"{"
	 		Set CatJson=CatJson_"""id"":""CAT-"_xCatID_""","
	 		Set CatJson=CatJson_"""text"":"""_CatDesc_""","
	 		Set CatJson=CatJson_"""state"":""open"","
	 		Set CatJson=CatJson_"""children"":["
	 		
	 		Set VarJson=""
			Set xVarID=""
		 	For {
		 		Set xVarID=$o(^DHCMA.CPW.BT.PathVariatI("IdxofTypeCat",xTypeID,xCatID,xVarID))
		 		Quit:xVarID=""
		 		
		 		Set obj=##class(DHCMA.CPW.BT.PathVariat).GetObjById(xVarID)
			 	Continue:'$IsObject(obj)
		 		Continue:'obj.BTIsActive
		 		
		 		Set VarDesc=obj.BTDesc
		 		Set:VarDesc'="" VarDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathVariat","BTDesc",VarDesc,LangID)
		 		
		 		Set VarJson=VarJson_"{"
		 		Set VarJson=VarJson_"""id"":""VAR-"_xVarID_""","
		 		Set VarJson=VarJson_"""text"":"""_VarDesc_""""
		 		Set VarJson=VarJson_"},"
		 	}
		 	Set:VarJson'="" VarJson=$e(VarJson,1,$l(VarJson)-1)	//去掉最后一个逗号
		 	Set CatJson=CatJson_VarJson_"]"
	 		Set CatJson=CatJson_"},"
		}
	 	Set:CatJson'="" CatJson=$e(CatJson,1,$l(CatJson)-1)	//去掉最后一个逗号
		Set treeJson=treeJson_CatJson_"]"
		Set treeJson=treeJson_"}"
		Set treeJson=treeJson_"]"
	}
	
 	Set return=treeJson
 	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-11
/// Description:  查询一个阶段里的路径外医嘱
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aEpisodeID : 就诊号
///               aStepID : 阶段ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.ImplementSrv","QryCPWVarOrder","21","21||2")
Query QryCPWVarOrder(aPathwayID As %String, aEpisID As %String) As %Query(ROWSPEC = "ind:%String,VarID:%String,OrdDID:%String,ARCIMDesc:%String,VariatCat:%String,VariatTxt:%String") [ SqlProc ]
{
}

ClassMethod QryCPWVarOrderExecute(ByRef qHandle As %Binary, aPathwayID As %String, aEpisID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aPathwayID="")||(aEpisID="") $$$OK
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
	Set xVarID=""
	For {
		Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEp",aPathwayID,aEpisID,xVarID))
		Quit:xVarID=""
		
		Set (VariatTxt,VariatCat)=""
		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
 		Continue:'$IsObject(objVar)
	 	Continue:'objVar.CPIsActive	//对医嘱而言，CPIsActive=0表示未回写orderID
	 	Continue:objVar.CPOrdDID=""
	 	Continue:$IsObject(objVar.CPImplDr)		//路径外医嘱没有项目指针
	 	
 		Set VariatTxt=objVar.CPVariatTxt
 		Set VariatCat=objVar.CPVariatDr.BTDesc
 		Set:VariatCat'="" VariatCat=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathVariat","BTDesc",VariatCat,LangID)
 		
 		Set xOrdDID=objVar.CPOrdDID
 		Set:xOrdDID["^" xOrdDID=$p(xOrdDID,"^",1)
 		Set OESubID=$p(xOrdDID,"||",2)
		Set OEItmMastID = $p($g(^OEORD(+xOrdDID,"I",OESubID,1)),"^",2) // 医嘱项指针 ARC_ItmMast
 		Set ARCIMDesc=$p($g(^ARCIM(+OEItmMastID,1,1)),"^",2)
 		
 		Set:'objVar.CPIsActive ARCIMDesc=$p($g(^ARCIM(+objVar.CPOrdDID,1,1)),"^",2)	//未回写orderID
 		Set:ARCIMDesc'="" ARCIMDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ARCItmMast","ARCIMDesc",ARCIMDesc,Languages)
		Set Data=$lb(ind,xVarID,xOrdDID,ARCIMDesc,VariatCat,VariatTxt)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
 	
 	Quit $$$OK
}

ClassMethod QryCPWVarOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWVarOrderExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWVarOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWVarOrderExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-11
/// Description:  查询一个阶段里的未执行项目
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aEpisodeID : 就诊号
///               aStepID : 阶段ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.ImplementSrv","QryCPWVarItem","77","77||1")
Query QryCPWVarItem(aPathwayID As %String, aEpisID As %String, aHospID As %String = "", aUserType As %String = "") As %Query(ROWSPEC = "ind:%String,VarID:%String,ImplID:%String,IndexNo:%String,ItemDesc:%String,TypeDesc:%String,VariatTxt:%String,VariatCat:%String") [ SqlProc ]
{
}

ClassMethod QryCPWVarItemExecute(ByRef qHandle As %Binary, aPathwayID As %String, aEpisID As %String, aHospID As %String = "", aUserType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aPathwayID="")||(aEpisID="") $$$OK
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
 	Set xImplID=""
 	For {
 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aEpisID,xImplID))
 		Quit:xImplID=""
 		
 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xImplID)
 		Continue:'$IsObject(objImpl)
 		Continue:objImpl.CPPathwayComplDr'=""
 		Set IsActive=objImpl.CPIsActive
 		Continue:'IsActive
 		Set IsRequired=+'objImpl.CPFormItemDr.ItemIsOption	//两变量值相反
 		Continue:'IsRequired	//是否可选
 		Set IsImp=objImpl.CPIsImp
 		Continue:IsImp
 		
 		//如医嘱项目其下所关联医嘱全部属于转科/出院医嘱，则不进行变异检查（产品部标版需求）				add by yankai 20220712
	 	Set retFlg=..IsIgnoreOrdItem(aPathwayID_"||"_xImplID,aHospID)
	 	Continue:retFlg
 		
 		Set ItemDesc=objImpl.CPFormItemDr.ItemDesc
 		Set:ItemDesc'="" ItemDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormItem","ItemDesc",ItemDesc,LangID)
 		Set IndexNo=objImpl.CPFormItemDr.ItemIndNo
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 		Set:TypeDesc'="" TypeDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",TypeDesc,LangID)
 		Continue:(aUserType="D")&&(TypeDesc["护理")
 		Continue:(aUserType="N")&&(TypeDesc'["护理")
 		
 		Set (VariatTxt,VariatCat)=""
 		Set xVarID=""
 		For {
			Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEpImpl",aPathwayID,aEpisID,aPathwayID_"||"_xImplID,xVarID))
			Quit:xVarID=""
			
	 		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
	 		If ($IsObject(objVar)) {
		 		Continue:'objVar.CPIsActive
		 		
	 			Set VariatTxt=objVar.CPVariatTxt
	 			Set VariatCat=objVar.CPVariatDr.BTDesc
	 			Set:VariatCat'="" VariatCat=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathVariat","BTDesc",VariatCat,LangID)
	 		}
			Quit
		}
	 	Set Data=$lb(ind,xVarID,xImplID,IndexNo,ItemDesc,TypeDesc,VariatTxt,VariatCat)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
			
 	}
 	
 	Quit $$$OK
}

ClassMethod QryCPWVarItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWVarItemExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWVarItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWVarItemExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-10
/// Description:  取符合切换要求的临床路径表单列表
/// 				  初步要求同病种
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       aPathFormID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).GetCPWList(1)
ClassMethod GetCPWList(aPathFormID As %String, aAdmLocID As %String) As %String
{
	New (aPathFormID,aAdmLocID,%session)
	Set return=""
	Quit:(aPathFormID="")||(aAdmLocID="") return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Set CPWList=""
	Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(aPathFormID)
	Quit:'$IsObject(objForm) return
	Quit:'$IsObject(objForm.FormPathDr) return
	Quit:'$IsObject(objForm.FormPathDr.BTEntityDr) return
	
	Set EntityID=objForm.FormPathDr.BTEntityDr.%Id()	//单病种ID
	Quit:EntityID="" return
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:aAdmLocID'["!!" aAdmLocID=aAdmLocID_"!!"_SYSDr
	
	Set xMastID=""
	For {
		Set xMastID=$o(^DHCMA.CPW.BT.PathMastI("IdxofEntity",EntityID,xMastID))
		Quit:xMastID=""
		//判断是否是科室常用路径，非常用路径不展示
		Continue:'$d(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_$zcvt(aAdmLocID,"U"),xMastID))		
		
		Set objMast=##class(DHCMA.CPW.BT.PathMast).GetObjById(xMastID)
		Continue:'$IsObject(objMast)
		Continue:'objMast.BTIsActive
		
		Set PathDesc=objMast.BTDesc
		Set:PathDesc'="" PathDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",PathDesc,LangID)
		Set PathForm=##class(DHCMA.CPW.BTS.PathFormSrv).GetFormByMast(xMastID,1)
		Continue:PathForm=""
		
		Set FormID=$p(PathForm,"^",1)
		Continue:FormID=aPathFormID
		
		Set Data=FormID_":"_PathDesc
		Set CPWList=CPWList_"^"_Data
	}
	
	Set:CPWList'="" CPWList=$e(CPWList,2,$l(CPWList))
	Set return=CPWList
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-10
/// Description:  (切换)取临床路径步骤列表
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       aPathFormID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).GetStepList(5,40)
ClassMethod GetStepList(aPathFormID As %String, aPathwayID As %String) As %String
{
	New (aPathFormID,aPathwayID,%session)
	Set return=""
	Quit:(aPathFormID="")||(aPathwayID="") return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
		
	Set StepList=""
	//检查当前出入径记录对目标路径已执行的最新阶段
	Set xSubPwEpisID="",MaxIndNo=0
	For{
		Set xSubPwEpisID=$o(^DHCMA.CPW.CP.PathwayD(aPathwayID,"EPIS",xSubPwEpisID))
		Quit:xSubPwEpisID=""
		
		Set objPwEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aPathwayID_"||"_xSubPwEpisID)
		Continue:'$IsObject(objPwEpis)
		Continue:'objPwEpis.CPIsActive
		Continue:objPwEpis.CPFormEpDr.Parref.%Id()'=aPathFormID		//只检查目标路径对应阶段
		Continue:'objPwEpis.CPIsConfirm
		Set BTEpisIndNo=objPwEpis.CPFormEpDr.EpIndNo
		Set:MaxIndNo<BTEpisIndNo MaxIndNo=BTEpisIndNo
	}
	
	//Modified by yankai 20211013 阶段获取按顺序号返回
	Set xIndNo=""
	For {
	 	Set xIndNo = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aPathFormID,xIndNo))
	 	Quit:xIndNo=""
	 	
	 	Set xFormEpID="",isAvail=1
	 	For {
		 	Set xFormEpID = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aPathFormID,xIndNo,xFormEpID))
		 	Quit:xFormEpID=""
		
			Set objFormEp=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aPathFormID_"||"_xFormEpID)
			Continue:'$IsObject(objFormEp)
			
			Set IsActive=objFormEp.EpIsActive
			Continue:'IsActive
			Set:xIndNo<=MaxIndNo isAvail=0
			
			Set FormEpDesc=objFormEp.EpDesc
			Set:FormEpDesc'="" FormEpDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc",FormEpDesc,LangID)
			Set FormEp=xFormEpID_":"_FormEpDesc_":"_isAvail
			
			Set StepList=StepList_"^"_FormEp
	 	}
	}
	
	Set:StepList'="" StepList=$e(StepList,2,$l(StepList))
	Set return=StepList
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-10
/// Description:  (切换)取临床路径步骤详细信息
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       aPathFormID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).GetStepDetail("1||2")
ClassMethod GetStepDetail(aFormEpID As %String) As %String
{
	New (aFormEpID,%session)
	Set return=""
	Quit:aFormEpID="" return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Set FormID=$p(aFormEpID,"||",1)
	Set FormEpID=$p(aFormEpID,"||",2)
	Kill ^tmpStepDetail
	Set xItemID=""
	For {
		Set xItemID=$o(^DHCMA.CPW.BT.PathFormD(FormID,"EP",FormEpID,"ITM",xItemID))
		Quit:xItemID=""
		
		Set objItem=##class(DHCMA.CPW.BT.PathFormItem).GetObjById(FormID_"||"_FormEpID_"||"_xItemID)
		Continue:'$IsObject(objItem)
		
		Set IsActive=objItem.ItemIsActive
		Continue:'IsActive
		Set ItemDesc=objItem.ItemDesc
		Set:ItemDesc'="" ItemDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormItem","ItemDesc",ItemDesc,LangID)
		Set ItemIndNo=objItem.ItemIndNo
		Set ItemCatDesc=objItem.ItemCatDr.BTTypeDr.BTDesc
		Set:ItemCatDesc'="" ItemCatDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",ItemCatDesc,LangID)
		
		Set ^tmpStepDetail(ItemCatDesc,+ItemIndNo,xItemID)=ItemDesc
	}
	
	Set SetpInfo=""
	Set xCatDesc=""
	For {
		Set xCatDesc=$o(^tmpStepDetail(xCatDesc))
		Quit:xCatDesc=""
		
		Set SetpInfo=SetpInfo_"<P><span class='ItemCatDesc' style='padding-bottom:10px;display:inline-block'>"_xCatDesc_"</span><br />"
		Set xIndNo=""
		For {
			Set xIndNo=$o(^tmpStepDetail(xCatDesc,xIndNo))
			Quit:xIndNo=""
			
			Set xItemID=""
			For {
				Set xItemID=$o(^tmpStepDetail(xCatDesc,xIndNo,xItemID))
				Quit:xItemID=""
				Set ItemDesc=$g(^tmpStepDetail(xCatDesc,xIndNo,xItemID))
				
				Set SetpInfo=SetpInfo_"<span class='ItemDesc'>"_xIndNo_"."_ItemDesc_"</span>"
				Set SetpInfo=SetpInfo_"<br />"
			}
		}
		Set SetpInfo=SetpInfo_"</p>"
	}
	
	Set return=SetpInfo
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-19
/// Description:  临床路径重点医嘱树
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       aPathFormID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).GetOrdItmTree(8,"8||1")
ClassMethod GetOrdItmTree(aPathwayID As %String, aEpisID As %String, aUserType As %String = "") As %String
{
	New (aPathwayID,aEpisID,aUserType,%session)
	Set return="[]"
	Quit:(aPathwayID="")||(aEpisID="") return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	Set strZDYKDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.io.order.csp","重点医嘱",LangID)	
	
	Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aEpisID)
	Quit:'$IsObject(objEpis) return
	Set FormEpID=objEpis.CPFormEpDr.%Id()
	
	Set treeJson="["
	Set treeJson=treeJson_"{"
	Set treeJson=treeJson_"""id"":""OrdTree-"_aEpisID_"-"_FormEpID_""","
	Set treeJson=treeJson_"""text"":"""_strZDYKDesc_""","
	Set treeJson=treeJson_"""state"":""open"","
	Set treeJson=treeJson_"""children"":["
	Set ChildJson=""
	Set xImplID=""
 	For {
 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aEpisID,xImplID))
 		Quit:xImplID=""
 		
 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xImplID)
 		Continue:'$IsObject(objImpl)
 		Continue:'objImpl.CPIsActive
 		Continue:objImpl.CPPathwayComplDr'=""
 		
 		Set objItemCat=objImpl.CPFormItemDr.ItemCatDr
		Continue:'$IsObject(objItemCat)
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 		Continue:TypeDesc'="重点医嘱"
 		 		
		Set ItemPower=""
		Set:$IsObject(objItemCat.BTPowerDr) ItemPower=objItemCat.BTPowerDr.BTCode
		Continue:(aUserType="D")&&((ItemPower'="D")&&(ItemPower'="OE")) 			//医生返回诊疗、医嘱
		Continue:(aUserType="N")&&((ItemPower'="N")&&(ItemPower'="NE")) 			//护士返回护理、护嘱
 		
 		Set ItemDesc=objImpl.CPFormItemDr.ItemDesc
 		Set:ItemDesc'="" ItemDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormItem","ItemDesc",ItemDesc,LangID)
 		Set ItemDesc=##class(DHCMA.Util.IO.FromHisSrv).ReplaceSpecialChar(ItemDesc)
 		
 		Set IndexNo=objImpl.CPFormItemDr.ItemIndNo
 		Set IsRequired=+'objImpl.CPFormItemDr.ItemIsOption	//两变量值相反
 		
 		Set IsSystem=objImpl.CPIsSystem
 		Set IsImp=+objImpl.CPIsImp
 		Continue:'$IsObject(objImpl.CPFormItemDr)
		Set FormItemID=objImpl.CPFormItemDr.%Id()
		
 		Set ChildJson=ChildJson_"{"
 		Set ChildJson=ChildJson_"""id"":"""_xImplID_"-"_FormItemID_""","
 		Set ChildJson=ChildJson_"""text"":"""_ItemDesc_""","
		Set ChildJson=ChildJson_"""attributes"":{""IsImp"":"_IsImp_",""IsRequired"":"_IsRequired_"}"
 		Set ChildJson=ChildJson_"},"
 	}
 	Set:ChildJson'="" ChildJson=$e(ChildJson,1,$l(ChildJson)-1)	//去掉最后一个逗号
	Set treeJson=treeJson_ChildJson_"]"
	Set treeJson=treeJson_"}"
	Set treeJson=treeJson_"]"
	
 	Set return=treeJson
 	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-20
/// Description:  判断是否允许签名
/// Table：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).CheckVarToSign(8,"8||2","D")
ClassMethod CheckVarToSign(aPathwayID As %String, aEpisID As %String, aSignType As %String, aHospID As %String = "") As %String
{
	New (aPathwayID,aEpisID,aSignType,aHospID,%session)
	Set return=""
	Quit:(aPathwayID="")||(aEpisID="")||(aSignType="") return
	Set:(aHospID="")&&($d(%session)) aHospID=$g(%session.Data("LOGON.HOSPID"))
	
	// 根据配置如设置默认，则检查变异时对未处理的变异自动保存变异原因
	Set DefItemRsnID="",DefOrdRsnID=""
	Set IsAutoSave=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIsDefaultVarRsn",aHospID)
	If IsAutoSave["Y"{
		Set DefItemRsnID=$p($p(IsAutoSave,"||",2),"-",1)
		Set DefOrdRsnID=$p($p(IsAutoSave,"||",2),"-",2)
		Set objItemRsn=##class(DHCMA.CPW.BT.PathVariat).GetObjById(DefItemRsnID)
		Set:'$IsObject(objItemRsn) DefItemRsnID=""
		Set objOrdRsn=##class(DHCMA.CPW.BT.PathVariat).GetObjById(DefOrdRsnID)
		Set:'$IsObject(objOrdRsn) DefOrdRsnID=""	
	}
	
	Set Count=0
	If (aSignType["D") {
		//检查未添加变异原因的未执行项目
	 	Set xImplID=""
	 	For {
	 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aEpisID,xImplID))
	 		Quit:xImplID=""
	 		
	 		Set xPwImplID=aPathwayID_"||"_xImplID
	 		//如医嘱项目其下所关联医嘱全部属于转科/出院医嘱，则不进行变异检查（产品部标版需求）				add by yankai 20220712
	 		Set retFlg=..IsIgnoreOrdItem(xPwImplID,aHospID)
	 		Continue:retFlg
	 		
	 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(xPwImplID)
	 		Continue:'$IsObject(objImpl)
	 		Continue:objImpl.CPPathwayComplDr'=""
	 		Continue:'$IsObject(objImpl.CPFormItemDr)
	 		Set ItemDesc=objImpl.CPFormItemDr.ItemDesc
	 		Continue:(ItemDesc["今日出院")||(ItemDesc["明日出院")||(ItemDesc="出院")		// 为避免出院项目造成操作死循环，变异检查时不进行出院项目的检查
	 		
	 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 			Continue:(TypeDesc="主要护理工作")
 			
	 		Set IsActive=objImpl.CPIsActive
	 		Continue:'IsActive
	 		Set IsRequired=+'objImpl.CPFormItemDr.ItemIsOption	//两变量值相反
	 		Continue:'IsRequired	//是否可选
	 		Set IsImp=objImpl.CPIsImp
	 		Continue:IsImp
	 		If '$d(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEpImpl",aPathwayID,aEpisID,xPwImplID)){
		 		If DefItemRsnID'=""{
			 		Set strUpd=aPathwayID_$c(1)_$c(1)_DefItemRsnID_$c(1)_$c(1)_aEpisID_$c(1)_xPwImplID_$c(1)_$c(1)_"SYS"_$c(1)_"1"
			 		Set retUpd=##class(DHCMA.CPW.CP.PathwayVar).Update(strUpd,$c(1))
			 		Set:+retUpd<=0 Count=Count+1	//自动保存原因失败,未执行项目计数+1
				}Else{
					Set Count=Count+1 
				}		
		 	}
			
	 		Set xVarID=""
	 		For {
				Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEpImpl",aPathwayID,aEpisID,xPwImplID,xVarID))
				Quit:xVarID=""
				
		 		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
		 		If ($IsObject(objVar)) {
			 		Continue:(objVar.CPIsActive=1)&&($IsObject(objVar.CPVariatDr))
			 		
			 		If DefItemRsnID'=""{
				 		Set strUpd=aPathwayID_$c(1)_xVarID_$c(1)_DefItemRsnID_$c(1)_$c(1)_aEpisID_$c(1)_xPwImplID_$c(1)_$c(1)_"SYS"_$c(1)_"1"
				 		Set retUpd=##class(DHCMA.CPW.CP.PathwayVar).Update(strUpd,$c(1))
				 		Set:+retUpd<=0 Count=Count+1	//自动保存原因失败,未执行项目计数+1	
				 	}Else{
					 	Set Count=Count+1				//无默认原因直接+1
					}
		 		}
			}	
	 	}
	 	
 		Set xVarID=""
		For {
			Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEp",aPathwayID,aEpisID,xVarID))
			Quit:xVarID=""
			
			Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
	 		Continue:'$IsObject(objVar)
	 		Continue:(objVar.CPIsActive=1)&&($IsObject(objVar.CPVariatDr))
		 	Continue:(objVar.CPOrdDID="")||($IsObject(objVar.CPImplDr))		//路径外医嘱没有项目指针
		 	
		 	If DefOrdRsnID'=""{
		 		Set strUpd=aPathwayID_$c(1)_xVarID_$c(1)_DefOrdRsnID_$c(1)_$c(1)_aEpisID_$c(1)_$c(1)_objVar.CPOrdDID_$c(1)_"SYS"_$c(1)_"1"
		 		Set retUpd=##class(DHCMA.CPW.CP.PathwayVar).Update(strUpd,$c(1))
		 		Set:+retUpd<=0 Count=Count+1	//自动保存原因失败,未执行项目计数+1	
		 	}Else{
			 	Set Count=Count+1				//无默认原因直接+1
			}	
		}
		Set return=Count
	} ElseIf (aSignType["N"){
		//检查未添加变异原因的未执行项目
	 	Set xImplID=""
	 	For {
	 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aEpisID,xImplID))
	 		Quit:xImplID=""
	 		
	 		Set xPwImplID=aPathwayID_"||"_xImplID
	 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(xPwImplID)
	 		Continue:'$IsObject(objImpl)
	 		Continue:objImpl.CPPathwayComplDr'=""
	 		
	 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 			Continue:(TypeDesc'="主要护理工作")
 			
	 		Set IsActive=objImpl.CPIsActive
	 		Continue:'IsActive
	 		Set IsRequired=+'objImpl.CPFormItemDr.ItemIsOption	//两变量值相反
	 		Continue:'IsRequired	//是否可选
	 		Set IsImp=objImpl.CPIsImp
	 		Continue:IsImp
	 		
	 		If '$d(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEpImpl",aPathwayID,aEpisID,xPwImplID)){
		 		If DefItemRsnID'=""{
		 			Set strUpd=aPathwayID_$c(1)_$c(1)_DefItemRsnID_$c(1)_$c(1)_aEpisID_$c(1)_xPwImplID_$c(1)_$c(1)_"SYS"_$c(1)_"1"
		 			Set retUpd=##class(DHCMA.CPW.CP.PathwayVar).Update(strUpd,$c(1))
		 			Set:+retUpd<=0 Count=Count+1	//自动保存原因失败,未执行项目计数+1	
		 		}Else{
					Set Count=Count+1	//未执行项目计数+1 	
				}
		 	}
	 		
	 		Set xVarID=""
	 		For {
				Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEpImpl",aPathwayID,aEpisID,xPwImplID,xVarID))
				Quit:xVarID=""
				
		 		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
		 		If ($IsObject(objVar)) {
			 		Continue:(objVar.CPIsActive=1)&&($IsObject(objVar.CPVariatDr))
			 		If DefItemRsnID'=""{
				 		Set strUpd=aPathwayID_$c(1)_xVarID_$c(1)_DefItemRsnID_$c(1)_$c(1)_aEpisID_$c(1)_xPwImplID_$c(1)_$c(1)_"SYS"_$c(1)_"1"
				 		Set retUpd=##class(DHCMA.CPW.CP.PathwayVar).Update(strUpd,$c(1))
				 		Set:+retUpd<=0 Count=Count+1	//自动保存原因失败,未执行项目计数+1			
				 	}Else{
					 	Set Count=Count+1			//未执行项目添加了变异原因-1
					}
		 		}
			}
				
	 	}
	 	Set return=Count
	} Else {
		Set return=Count
	}
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-30
/// Description:  判断当前阶段是否有未执行的非必选项目
/// Input：       aEpisodeID : 就诊ID
/// Return:		  返回String: 1是
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).CheckHaveUnExItm(1,"1||1")
ClassMethod CheckHaveUnExItm(aPathwayID As %String, aEpisID As %String, aUserType As %String, aHospID As %String = "") As %String
{
	New (aPathwayID,aEpisID,aUserType,aHospID,%session)
	Set return=""
	Quit:(aPathwayID="")||(aEpisID="") return
	Set:(aHospID="")&&($d(%session)) aHospID=$g(%session.Data("LOGON.HOSPID"))
	
	Set xImplID=""
 	For {
 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aEpisID,xImplID))
 		Quit:xImplID=""
 		
 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xImplID)
 		Continue:'$IsObject(objImpl)
 		Continue:objImpl.CPPathwayComplDr'=""
 		
 		Set IsActive=objImpl.CPIsActive
 		Continue:'IsActive
 		
 		//如医嘱项目其下所关联医嘱全部属于转科/出院医嘱，则不进行变异检查（产品部标版需求）				add by yankai 20220712
	 	Set retFlg=..IsIgnoreOrdItem(aPathwayID_"||"_xImplID,aHospID)
	 	Continue:retFlg
 		
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 		Continue:(aUserType="D")&&(TypeDesc="主要护理工作")
 		Continue:(aUserType="N")&&(TypeDesc'="主要护理工作")
 		
 		Set IsRequired=+'objImpl.CPFormItemDr.ItemIsOption	
 		Continue:IsRequired		//过滤必选项
 		
		Set IsImp=objImpl.CPIsImp
		Continue:IsImp		//过滤已执行
		
		Set IsVar=0	//是否变异
		Set xVarID=""
 		For {
			Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEpImpl",aPathwayID,aEpisID,aPathwayID_"||"_xImplID,xVarID))
			Quit:xVarID=""
			
	 		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
	 		Continue:'$IsObject(objVar)
		 	Continue:'objVar.CPIsActive
	 		Set IsVar=1
	 		Quit
	 	}
	 	Continue:IsVar		//过滤已添加变异
	 	
	 	Set return=1
	 	Quit
 	}

	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-01-10
/// Description:  遍历长期医嘱与本阶段内关联项目，匹配执行记录
/// Input：       aEpisID : 阶段ID
/// Return:		  返回String: 1是
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).CheckOEOrdImplByEpis("21||2")
ClassMethod CheckOEOrdImplByEpis(aEpisID As %String, aHospID As %String = "") As %String
{
	New (aEpisID,aHospID,%session)
	Set return=""
	Quit:aEpisID="" return
	
	Set:(aHospID="")&&($d(%session)) aHospID=$g(%session.Data("LOGON.HOSPID"))
	Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aEpisID)
	Quit:'$IsObject(objEpis) return
	Set EpisSttDate=objEpis.CPSttDate
	Set:EpisSttDate="" EpisSttDate=+$H
	Set EpisEndDate=objEpis.CPEndDate
	Set:EpisEndDate="" EpisEndDate=+$H
	
	Set aPathwayID=$p(aEpisID,"||",1)
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Quit:'$IsObject(objPathway) return
	
	Set IsFirstEp=0
	Set PreEpisID=##class(DHCMA.CPW.CPS.EpisSrv).GetPreEpisID(aEpisID)		// 检查传入阶段是否首阶段
	Set:PreEpisID="" IsFirstEp=1
	
	Set EpisodeID=objPathway.CPEpisodeID
	Set AdmID=$p(EpisodeID,"!!",1)
	
	Set OrdID=$o(^OEORD(0,"Adm",AdmID,0))
	Quit:OrdID="" return
	
	Set xImplID=""
 	For {
 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aEpisID,xImplID))
 		Quit:xImplID=""
 		
 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xImplID)
 		Continue:'$IsObject(objImpl)
 		Continue:'objImpl.CPIsActive
 		Continue:objImpl.CPPathwayComplDr'=""
 		
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 		Continue:TypeDesc'="重点医嘱"
 		
 		Set IsImp=+objImpl.CPIsImp
		Set FormItemID=objImpl.CPFormItemDr.%Id()
		
		Set PathFormDr=$p(FormItemID,"||",1)
		Set PathFormEpDr=$p(FormItemID,"||",2)
		Set PathFormEpItemDr=$p(FormItemID,"||",3)
		Set xFormOrdID=""
	 	For {
		 	Set xFormOrdID = $o(^DHCMA.CPW.BT.PathFormD(PathFormDr,"EP",PathFormEpDr,"ITM",PathFormEpItemDr,"ORD",xFormOrdID))
		 	Quit:xFormOrdID=""
		 	
			Set objFormOrd = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(FormItemID_"||"_xFormOrdID)
			Continue:'$IsObject(objFormOrd)
		 	Continue:'objFormOrd.OrdIsActive
		 	
		 	Set IsExe=0	//项目是否执行
			Set IsMainord=objFormOrd.OrdIsFluInfu	//是否主医嘱
			Set:IsMainord IsExe=1	//只有主医嘱执行，此项目才算是执行
		 	
		 	Set xOrdMastID =objFormOrd.OrdMastID
		 	If $l(xOrdMastID,"||")'=2 {	//医嘱套
				Set xOrdMastID=##class(DHCMA.CPW.CPS.InterfaceSrv).GetOSItems(xOrdMastID)
			}
			
		 	For OrdInd=1:1:$l(xOrdMastID,"^") {
				Set OrdMastID=$p(xOrdMastID,"^",OrdInd)
				Continue:OrdMastID=""
				
			 	Continue:'$d(^OEORDi(0,"ARCIM",OrdID,OrdMastID))
			 	Set xSttDate=""
			 	For {
			 		Set xSttDate=$o(^OEORDi(0,"ARCIM",OrdID,OrdMastID,xSttDate))
			 		Quit:xSttDate=""
			 		
			 		Set xSubID=0
					For {
						Set xSubID=$o(^OEORDi(0,"ARCIM",OrdID,OrdMastID,xSttDate,xSubID))
						Quit:xSubID=""
						
					 	Set OEItemID=OrdID_"||"_xSubID
					 	Set IsValid=..IsValidOEItem(OEItemID)
					 	Continue:+IsValid=0				//过滤无效或已停止长期医嘱
					 	
						//检查开始时间和结束时间
						If IsFirstEp=0{ 				// 非首阶段时只检查本阶段时间段内临时医嘱
							Set flg=..CheckDateRange(EpisSttDate,EpisEndDate,OEItemID)  
							Continue:flg<1	
						}Else{							// 首阶段时按配置前移检查天数
							Set ChkDays=+##class(DHCMA.Util.BT.Config).GetValueByCode("CPWChkBefInTmpOrdDays",aHospID)
							Set flg=..CheckDateRange(EpisSttDate-ChkDays,EpisEndDate,OEItemID)
							Continue:flg<1
						}
						//添加此项目的执行记录
						Set input=aPathwayID_"||"_xImplID_"^^"_FormItemID_"||"_xFormOrdID_"^"_OEItemID_"^"_"SYS"
						Set return=##class(DHCMA.CPW.CP.PathwayOrd).Update(input)
						If (+return>0) {
							//未执行项目更新执行状态
							If (+IsImp<1)&&(+IsExe>0) {
								Set return=##class(DHCMA.CPW.CP.PathwayImpl).ExecuteItem(aPathwayID,xImplID,"","SYS",IsExe,1)
							}
						}
					}
			 	}
		 	}
	 	}
 	}
 	
 	Quit return
}

/// 检查医嘱状态是否有效（滚执行记录模式）
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).IsValidOEItem("")
ClassMethod IsValidOEItem(aOEItemID As %String) As %String
{
	New (aOEItemID)
	Set return=0
	Quit:aOEItemID="" return
	
	Set $ZT="IsValidOEItemErr"
	
	Set StatusID=$p($g(^OEORD(+aOEItemID,"I",+$p(aOEItemID,"||",2),1)),"^",13)
	Set StatusCode=$p($g(^OEC("OSTAT",+StatusID)),"^",1)
	Set StatusDesc=$p($g(^OEC("OSTAT",+StatusID)),"^",2)
	Quit:(StatusCode="")||(StatusDesc="") return
	
	//作废,未审核,撤销,预开医嘱
	Set StatusList=$lb("U","I","C","P")
	Quit:($listfind(StatusList,StatusCode)>0) return
	Quit:(StatusDesc["作废") return
	
	//停止医嘱
	If (StatusCode="D") {
		Set PriorityID=$p($g(^OEORD(+aOEItemID,"I",+$p(aOEItemID,"||",2),1)),"^",8)
		Set PriorityCode=$p($g(^OECPR(+PriorityID)),"^",1)
		Set PriorityDesc=$p($g(^OECPR(+PriorityID)),"^",2)
		Set Priority=PriorityCode_","_PriorityDesc
		Quit:(Priority'["长期")&&(Priority'["PRN")&&(Priority'["持续") return
	}
	
	Set return=1
	Quit return
	
IsValidOEItemErr
	Quit 0
}

/// 检查执行记录是否有效
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).IsValidOEExec("")
ClassMethod IsValidOEExec(aOEExecID As %String) As %String
{
	New (aOEExecID)
	Set return=0
	Quit:aOEExecID="" return
	
	Set OrdID=$p(aOEExecID,"||",1)
	Set SubID=$p(aOEExecID,"||",2)
	Set ChildID=$p(aOEExecID,"||",3)
	Quit:(OrdID="")||(SubID="")||(ChildID="") return
	
	Set $ZT="IsValidOEExecErr"
	
	Set StatusID=$p($g(^OEORD(OrdID,"I",SubID,"X",ChildID)),"^",16)
	Set StatusCode=$p($g(^OEC("STAT",+StatusID)),"^",1)
	Set StatusDesc=$p($g(^OEC("STAT",+StatusID)),"^",2)
	Quit:(StatusCode="")||(StatusDesc="") return
	
	Set StatusList=$lb("D","R","C")	//停止、拒绝、撤销
	Quit:($listfind(StatusList,StatusCode)>0) return
	Quit:(StatusDesc["作废") return
	
	Set return=1
	Quit return
	
IsValidOEExecErr
	Quit 0
}

/// 检查日期范围
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).CheckDateRange()
ClassMethod CheckDateRange(aFromDate As %String, aToDate As %String, aID As %String) As %String
{
	New (aFromDate,aToDate,aID)
	Set return=0
	Quit:(aFromDate="")||(aToDate="")||(aID="") return
	
	Set OrdID=$p(aID,"||",1)
	Set SubID=$p(aID,"||",2)
	Set ChildID=$p(aID,"||",3)
	
	If ChildID="" {
		Set FillerNo=$p($g(^OEORD(OrdID,"I",SubID,9)),"^",12)
		Set:FillerNo="" FillerNo=OrdID_"||"_SubID
	} Else {
		Set FillerNo=OrdID_"||"_SubID
	}
	
	//是否是长期类医嘱
	Set isLongOrder=""
	Set PriorID=$p($g(^OEORD(+FillerNo,"I",$p(FillerNo,"||",2),1)),"^",8)
	Set PriorCode=$p($g(^OECPR(PriorID)),"^",1)
	Set:(PriorCode="S")||(PriorCode="OMST")||(PriorCode="OMCQZT") isLongOrder=1
	
	If isLongOrder=1{																		// 长期医嘱
		Set OEORISttDat = $p($g(^OEORD(+FillerNo,"I",$p(FillerNo,"||",2),1)),"^",9) 		// 开始日期
		Set OEORIEndDate = $p($g(^OEORD(+FillerNo,"I",$p(FillerNo,"||",2),3)),"^",34) 		// 停止日期
		If (OEORIEndDate'="") {
			Set:(OEORISttDat'>aToDate)&&(OEORIEndDate'<aFromDate) return=1
		} Else {
			Set return=1
		}		
	}else{																					// 其他医嘱
		Set OEORISttDat = $p($g(^OEORD(+FillerNo,"I",$p(FillerNo,"||",2),1)),"^",9) 		// 开始日期
		Set:(OEORISttDat'>aToDate)&&(OEORISttDat'<aFromDate) return=1
	}

	Quit return
}

/// Creator：     yankai
/// CreatDate：   2019-04-04
/// Description:  阶段确认前检查日期是否合法
/// Input：       aEpisID : 阶段ID,aSttDate : 当前阶段开始日期
/// Return:		  返回String: 
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).CheckStepDate("37||2","2022-03-28")
ClassMethod CheckStepDate(aEpisID As %String, aSttDate As %String) As %String
{
	New (aEpisID,aSttDate)
	Set return=""
	Quit:(aEpisID="")||(aSttDate="") return
	
	Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aEpisID)
	Quit:'$IsObject(objEpis) return
	Set PathwayID=$p(aEpisID,"||",1)
	Set IndNo=objEpis.CPIndNo
	Set xIndNo=IndNo,PreEpisID=""
	For {
		Set xIndNo = $o(^DHCMA.CPW.CP.PathwayI("EPIS","IdxofParIndNo",PathwayID,xIndNo),-1)
		Quit:xIndNo=""
		Quit:PreEpisID'=""
		
		Set xEpisID=""
		For {
			Set xEpisID = $o(^DHCMA.CPW.CP.PathwayI("EPIS","IdxofParIndNo",PathwayID,xIndNo,xEpisID))
			Quit:xEpisID=""
			Quit:PreEpisID'=""
			
			Set xObjEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(PathwayID_"||"_xEpisID)
			Continue:'$IsObject(xObjEpis)
			Continue:'xObjEpis.CPIsActive
			Set PreEpisID=xEpisID	
		}	
	}
	
	Set objPreEpis = ##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(PathwayID_"||"_PreEpisID)
	Quit:'$IsObject(objPreEpis) return
	
	Set PreStepEndDate=objPreEpis.CPEndDate
	Set PreStepSttDate=objPreEpis.CPSttDate
	Set CurrSttDate=##class(DHCMA.Util.IO.FromHisSrv).GetDateHtmlToLogical(aSttDate)
	Set:CurrSttDate-PreStepEndDate<0 return="当前阶段开始日期不允许小于上一阶段结束日期;"
	Set:(PreStepEndDate'="")&&(CurrSttDate-PreStepEndDate>1) return=return_"相邻阶段间时间不连续"
	
	Quit return
}

/// Creator: yankai
/// CreateDate: 2020-04-03
/// Description: 表单总览修改阶段日期
/// Input: aPathwayID:出入径记录ID
///        aInDateStr:日期串[格式：EpisID1^DateFrom1^DateEnd1#EpisID2^DateFrom2^DateEnd2#...]
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).ChangeEpisDate(14,"1^2019-02-15^2019-02-16#2^2019-02-17^2019-02-20#3^2019-02-21^2019-02-21#","10209!!1")
ClassMethod ChangeEpisDate(aPathwayID As %String, aInDateStr As %String, aUserID As %String) As %String
{
	New (aPathwayID,aInDateStr,aUserID)
	Set return=0
	Quit:(aPathwayID="")||(aInDateStr="") return
	
	Set $ZT="ChangeEpisDateError"
	Tstart
	
	For i=1:1:$l(aInDateStr,"#"){
		Set tmpDateStr = $p(aInDateStr,"#",i)
		Continue:tmpDateStr=""
		For j=1:1:$l(tmpDateStr,"^"){
			Set xEpisID = $p(tmpDateStr,"^",1)
			Set xDateFrom = $p(tmpDateStr,"^",2)
			Set xDateEnd = $p(tmpDateStr,"^",3)
			Set ret=##class(DHCMA.CPW.CP.PathwayEpis).Confirm(aPathwayID_"||"_xEpisID,xDateFrom,xDateEnd,aUserID)
			If +ret<1{
				Set return=0
				TRollBack
				Quit
			}Else{
				Set return=1	
			}			 	
		}
	}
	Quit:+return=0 return
	
	If $TLevel>0 TCommit
	Quit return
	
ChangeEpisDateError
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator: jiangpengpeng
/// CreateDate: 2020-9-18
/// Description: 按日期计算当前阶段（此方法已弃用 add by yankai 20230426）
/// Input: aPathwayID:出入径记录ID
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).GetCurrEpisByDate(38,"2!!1")
ClassMethod GetCurrEpisByDate(aPathwayID As %String, aHospID As %String = "") As %String
{
	New (aPathwayID,aHospID)
	Set return=""
	Quit:aPathwayID="" return
	
	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWShowCurrEpisByDate",aHospID)	 //是否按日期计算当前阶段
	Quit:ret'="Y" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Quit:'$IsObject(objPathway) return
	
	Set CPInDate=objPathway.CPInDate
	
	Set NIndex="GetCurrEpisByDate"
	Kill ^TMP($zn,$j,NIndex)

	Set IsExec=0
	Set PreBTFormID=""
	Set xEpisID=""
	For {
		Set xEpisID=$o(^DHCMA.CPW.CP.PathwayD(aPathwayID,"EPIS",xEpisID))
		Quit:xEpisID=""
			
		Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aPathwayID_"||"_xEpisID)
		Continue:'$IsObject(objEpis)
		
		Set IsActive=objEpis.CPIsActive
		Continue:'IsActive
		
		Set IndNo=objEpis.CPIndNo
		Set BTFormEpID=objEpis.CPFormEpDr.%Id()
		Set BTFormID=$p(BTFormEpID,"||",1)
		If (PreBTFormID'=BTFormID) {
			Set IsExec=IsExec+1
			Set PreBTFormID=BTFormID
		}
		Set ^TMP($zn,$j,NIndex,IsExec,IndNo,xEpisID)=""
	}
	
	Set objTheEpis=""	//按日期计算的当前阶段
	Set isDone="False"
	Set EpDays=0
	Set xIsExec=""
	For {
		Set xIsExec=$o(^TMP($zn,$j,NIndex,xIsExec))
		Quit:xIsExec=""
		Quit:isDone="True"
		
		Set xIndNo=""
		For {
			Set xIndNo=$o(^TMP($zn,$j,NIndex,xIsExec,xIndNo))
			Quit:xIndNo=""
			Quit:isDone="True"
			
			Set xEpisID=""
			For {
				Set xEpisID=$o(^TMP($zn,$j,NIndex,xIsExec,xIndNo,xEpisID))
				Quit:xEpisID=""
				
				Set xobjEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aPathwayID_"||"_xEpisID)
				
				Set EpDays=EpDays+xobjEpis.CPEpDays
				Set objTheEpis=xobjEpis
				If (CPInDate+EpDays>+$H) {
					Set isDone="True"
					Quit
				}
				
			}
		}
	}
	Set return=$p(objTheEpis.%Id(),"||",2)_":"_objTheEpis.CPFormEpDr.EpDesc
	Quit return
}

/// Creator: 		yankai
/// CreateDate:		2023-05-05
/// Description: 	自动确认阶段，按设置处理签名及变异
/// Inputs:			aPathwayID:指定出入径记录，aHospID:院区ID
/// Return:			
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).AutoConfirmStep(47)
ClassMethod AutoConfirmStep(aPathwayID As %String = "", aHospID As %String = "") As %String
{
	New (aPathwayID,aHospID)
	Set return=""
	
	Set $ZT="AutoConfirmStepError"
	Set NIndex="AutoConfirmStep"
	Kill ^TEMPCPWErrLOG(NIndex,$zd(+$h,3))
	
	//处理入径状态下所有路径
	Set xCPActDate=""
	For {
		Set xCPActDate=$o(^DHCMA.CPW.CP.PathwayI("IdxofActDateStatus","I",xCPActDate))
		Quit:xCPActDate=""
		
		Set xPathwayID=""
		For {
			Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofActDateStatus","I",xCPActDate,xPathwayID))
			Quit:xPathwayID=""
			
			Continue:(aPathwayID'="")&&(aPathwayID'=xPathwayID)
			Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
			Continue:'$IsObject(objPathway)
			Continue:'$IsObject(objPathway.CPEpisDr)
			Continue:objPathway.CPEpisDr.CPIsConfirm=1		// 当前阶段已确认需过滤
			Continue:objPathway.CPRunStatus=1				// 自动模式下处于暂停的需过滤
			
			Set EpisodeID=objPathway.CPEpisodeID
			Set CPInDate=objPathway.CPInDate 				// 入径日期
			Set CPInTime=objPathway.CPInTime 				// 入径时间
			Set UserID=objPathway.CPInUserID
			
			Set (InLocID,InHospID)=""
			Set InLocID=objPathway.CPInLocID
			Set:InLocID'="" InHospID=$p($g(^CTLOC(+InLocID)),"^",22)
			Continue:(aHospID'="")&&(+aHospID'=InHospID)	// 院区过滤
			If (InHospID'="")&&(InHospID'["!!"){
				Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
				Set InHospID=InHospID_"!!"_SYSDr	
			}
			
			Set CurCPEpID=objPathway.CPEpisDr.%Id()
			Set EpDays=objPathway.CPEpisDr.CPEpDays
			Set:$p(EpDays,"-",2)'="" EpDays=+$p(EpDays,"-",2)
			Set CurCPEpSttDate=objPathway.CPEpisDr.CPSttDate
			Set CurCPEpSttTime=objPathway.CPEpisDr.CPSttTime
			If CurCPEpSttDate=""{
				Set PreEpisID=##class(DHCMA.CPW.CPS.EpisSrv).GetPreEpisID(CurCPEpID)
				If PreEpisID="" {
					Set CurCPEpSttDate = CPInDate			// 首阶段设置开始日期为入径日期
					Set CurCPEpSttTime = CPInTime			// 首阶段设置开始时间为入径时间
				}Else{
					Set objPreEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(PreEpisID)
					Set CurCPEpSttDate=objPreEpis.CPEndDate
					Set CurCPEpSttTime=objPreEpis.CPEndTime	
				}	
			}ElseIf CurCPEpSttTime=""{
				Set CurCPEpSttTime=0						// 有日期无时间的设置为0点	
			}
			
			If (+$h-CurCPEpSttDate>EpDays)||((+$h-CurCPEpSttDate=EpDays)&&($p($h,",",2)>=CurCPEpSttTime)){	// 天数超出最大参考天数或相等但时间晚于开始时间
				Set chkVar=..CheckVarToSign(xPathwayID,CurCPEpID,"DN",aHospID) 								// 检查变异并根据配置决定是否自动保存变异原因
				Set xSttDateTime=$zd(CurCPEpSttDate,3)_" "_$zt(CurCPEpSttTime,1)
				Set xEndDateTime=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
				Set NextEpID=##class(DHCMA.CPW.CPS.EpisSrv).GetNextEpisID(CurCPEpID)
				Set retCfm=..ConfirmStep(CurCPEpID,xSttDateTime,xEndDateTime,"SYS",NextEpID,InHospID)
				If +retCfm<0{
					Set ^TEMPCPWErrLOG(NIndex,$zd(+$h,3),"NUM")=$i(^TEMPCPWErrLOG(NIndex,$zd(+$h,3),"NUM"))
					Set ^TEMPCPWErrLOG(NIndex,$zd(+$h,3),"EPLIST")=$g(^TEMPCPWErrLOG(NIndex,$zd(+$h,3),"EPLIST"))_$lb(CurCPEpID)	
					Continue:+retCfm<0
				}	
			}
		}
	}
	
	Quit "OK"

AutoConfirmStepError
	Quit "Error="_$ZE
}

/// Creator: 		yankai
/// CreateDate: 	2022-07-11
/// Description: 	通过医嘱项目id检查其下医嘱是否完全属于出院转科类医嘱，是则变异检查时忽略该项目，否则不可忽略
/// Input:			aItemID:出入径记录中项目ID,	aHospID:登录院区ID
/// Return:			1:可忽略；0：不可忽略			
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).IsIgnoreOrdItem("13||21","2!!1")
ClassMethod IsIgnoreOrdItem(aItemID As %String, aHospID As %String = "") As %String
{
	New (aItemID,aHospID,%session)
	Set return=0
	Quit:aItemID="" return
	Set:(aHospID="")&&($d(%session)) aHospID=$g(%session.Data("LOGON.HOSPID"))
	
	Set strDischArcims=##class(DHCMA.Util.IO.FromHisSrv).GetDischNeedArcim(aHospID)
	Set strTransArcims=##class(DHCMA.Util.IO.FromHisSrv).GetTransNeedArcim(aHospID)
	Quit:(strDischArcims="")&&(strTransArcims="") return
	
	Set listDischArcims=$lfs(strDischArcims,"^")
	Set listTransArcims=$lfs(strTransArcims,"^")
	
	Set objOrdItem=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aItemID)
	Quit:'$IsObject(objOrdItem) return
	Quit:objOrdItem.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc'="重点医嘱" return
	
	Quit:'$IsObject(objOrdItem.CPFormItemDr)
	Set FormItemDr=objOrdItem.CPFormItemDr.%Id()
	
	Set PathFormDr=$p(FormItemDr,"||",1)
	Set PathFormEpDr=$p(FormItemDr,"||",2)
	Set PathFormEpItemDr=$p(FormItemDr,"||",3)
	
	Set xFormOrdID="",chkFlg=1
 	For {
	 	Set xFormOrdID = $o(^DHCMA.CPW.BT.PathFormD(PathFormDr,"EP",PathFormEpDr,"ITM",PathFormEpItemDr,"ORD",xFormOrdID))
	 	Quit:xFormOrdID=""
	 	Quit:chkFlg=0
	 	
	 	Set xOrdID=PathFormDr_"||"_PathFormEpDr_"||"_PathFormEpItemDr_"||"_xFormOrdID
	 	Set objFormOrd=##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(xOrdID)
	 	Continue:'$IsObject(objFormOrd)
	 	Continue:'objFormOrd.OrdIsActive
	 	Continue:'objFormOrd.OrdIsFluInfu		//非主医嘱不检查（主医嘱执行项目才执行）
	 	Set OrdMastID=objFormOrd.OrdMastID
	 	Set:($lf(listDischArcims,OrdMastID)<1)&&($lf(listTransArcims,OrdMastID)<1) chkFlg=0
 	}
 	
 	Quit chkFlg
}

/// Creator: 		yankai
/// CreateDate: 	2022-12-06
/// Description: 	用于打印前调用，根据配置检查出院患者末阶段未执行的出院项目（含“今日出院”或“明日出院”）由系统自动为其标记执行
/// Input:			
/// Return:			
/// w ##class(DHCMA.CPW.CPS.ImplementSrv).AutoExeDischItem(11,"195!!1","2!!1")
ClassMethod AutoExeDischItem(aPathwayID As %String, aEpisodeID As %String, aHospID As %String = "") As %String
{
	New (aPathwayID,aEpisodeID,aHospID,%session)
	Set return=0
	Quit:(aPathwayID="")||(aEpisodeID="") return
	
	Set:(aHospID="")&&($d(%session)) aHospID=$g(%session.Data("LOGON.HOSPID"))
	Set valConfig=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWAutoExeDischItemBeforePrint",aHospID)
	Quit:valConfig'="Y" 1
	
	Set VistStatus=$p($g(^PAADM(+aEpisodeID)),"^",20)
 	Quit:VistStatus'="D" 1
	
	Set objPathway = ##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Quit:'$IsObject(objPathway) -1
	Quit:objPathway.CPStatus'="C" 1
	
	Set lastEpIndNo=$o(^DHCMA.CPW.CP.PathwayI("EPIS","IdxofParIndNo",aPathwayID,""),-1)
	Set lastEpSubID=$o(^DHCMA.CPW.CP.PathwayI("EPIS","IdxofParIndNo",aPathwayID,lastEpIndNo,""),-1)
	Set lastEpisID=aPathwayID_"||"_lastEpSubID
	Set objLastEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(lastEpisID)
	Quit:'$IsObject(objLastEpis) -2
	Quit:'objLastEpis.CPIsConfirm 1
	
	Set xImplID=""
 	For {
 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,lastEpisID,xImplID))
 		Quit:xImplID=""
 		
 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xImplID)
 		Continue:'$IsObject(objImpl)
 		Continue:'objImpl.CPIsActive				// 过滤无效项目
 		Continue:objImpl.CPPathwayComplDr'=""		// 过滤合并症项目
 		Continue:objImpl.CPIsImp					// 过滤已执行项目
 		
 		Set ItemDesc=objImpl.CPFormItemDr.ItemDesc	// 项目描述
 		Continue:(ItemDesc'["今日出院")&&(ItemDesc'["明日出院")&&(ItemDesc'="出院")
 		
 		Do ##class(DHCMA.CPW.CP.PathwayImpl).ExecuteItem(aPathwayID,xImplID,"","","1","1")
 	}
	
	Quit 1
}

}
