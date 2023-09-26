/// 名称：DHCMA.CPW.CPS.ImplementSrv
/// 描述：门诊临床路径相关执行服务
/// 编写者：yankai
/// 编写日期：2019-07-24
Class DHCMA.CPW.OPCPS.ImplementSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2019-07-24
/// Description:  取门诊临床路径状态及操作信息
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       EpisodeID
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.ImplementSrv).GetCPWInfo("711!!1")
ClassMethod GetCPWInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID,%session)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	
	//取该出入径记录的最后有效就诊入径
	Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjByEpisodeID(aEpisodeID)
	Quit:'$IsObject(objVisit) return
	
	Set objPathway=objVisit.CPPathwayDr
	Quit:'$IsObject(objPathway) return
	Set PathwayID=objPathway.%Id()
	
	Set PathFormID=objPathway.CPFormDr.%Id()
	Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc
	Set:CPWDesc'="" CPWDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",CPWDesc,LangID)
	Set CPWStatus=objPathway.CPStatus
	Set CPWStatus=$Case(CPWStatus,"I":"入径","O":"出径","C":"完成","U":"作废","P":"预约","A":"申请","T":"不入径",1:"")
	Quit:CPWStatus="" return
	
	Set CPWUser=""
	Set UserID=objPathway.CPActUserID
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(UserID)
	Set:$IsObject(objUser) CPWUser=objUser.BTDesc
	
	Set ActDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(objPathway.CPActDate)
	Set CPWTime=ActDate_" "_$zt(objPathway.CPActTime,1)
	
	Set CurrEpisID=$p(objPathway.CPEpisDr.%Id(),"||",2)
	Set CurrEpisDesc=objPathway.CPEpisDr.CPFormEpDr.EpDesc
	Set:CurrEpisDesc'="" CurrEpisDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc",CurrEpisDesc,LangID)
	
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
	Set:VarDesc'="" VarDesc= ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.io.oporder.csp",VarDesc,LangID)	
	
	Set FormCost=objPathway.CPFormDr.FormCost
	Set FormDays=objPathway.CPFormDr.FormDays
	
	Set Feestr=##class(web.DHCCPW.MR.Interface).GetAdmCateFee($p(aEpisodeID,"!!",1))
	Set PatCost=$p(Feestr,"^",1)		//住院总费用。。。
	Set CPWDays=0
	Set CPActDate=objPathway.CPActDate
	Set CPInDate=objPathway.CPInDate
	Set CPOutDate=objPathway.CPOutDate
	Set:CPWStatus="入径" CPWDays=+$H-CPInDate					//入径第一天不算
	Set:CPWStatus="完成" CPWDays=CPActDate-CPInDate
	Set:CPWStatus="出径" CPWDays=CPOutDate-CPInDate
	Set:(CPWStatus="完成"||CPWStatus="出径")&&(CPWDays=0) CPWDays=1		//当天入径且当天出径或完成的算1天
	Set:CPWStatus'="" CPWStatus=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",CPWStatus,LangID)
		
	Set Json="{"
	Set Json=Json_"""PathwayID"":"""_PathwayID_""","
	Set Json=Json_"""PathFormID"":"""_PathFormID_""","
	Set Json=Json_"""CPWDesc"":"""_CPWDesc_""","
	Set Json=Json_"""CPWStatus"":"""_CPWStatus_""","
	Set Json=Json_"""CPWEpisID"":"""_CurrEpisID_""","
	Set Json=Json_"""CPWEpisDesc"":"""_CurrEpisDesc_""","
	Set Json=Json_"""CPWUser"":"""_CPWUser_""","
	Set Json=Json_"""CPWTime"":"""_CPWTime_""","
	Set Json=Json_"""SDDesc"":"""_SDDesc_""","
	Set Json=Json_"""VarDesc"":"""_VarDesc_""","
	Set Json=Json_"""FormCost"":"""_FormCost_""","
	Set Json=Json_"""PatCost"":"""_PatCost_""","
	Set Json=Json_"""FormDays"":"""_FormDays_""","
	Set Json=Json_"""CPWDays"":"""_CPWDays_""""
	Set Json=Json_"}"
	
	Set return=Json
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2019-07-26
/// Description:  取临床路径步骤
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       EpisodeID
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.ImplementSrv).GetCPWSteps("718!!1",40)
ClassMethod GetCPWSteps(aEpisodeID As %String, aPathwayID As %String = "") As %String
{
	New (aEpisodeID,aPathwayID,%session)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	
	//取该出入径记录的最后有效就诊入径
	Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjByEpisodeID(aEpisodeID)
	Quit:'$IsObject(objVisit) return
	
	Set objPathway=objVisit.CPPathwayDr
	Set PathwayID=objPathway.%Id()
	Set CurrID=$p(objPathway.CPEpisDr.%Id(),"||",2)
	Set CurrDesc=objPathway.CPEpisDr.CPFormEpDr.EpDesc
	Set:CurrDesc'="" CurrDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc",CurrDesc,LangID)
	Set CurrStep=CurrID_":"_CurrDesc
	
	Set ind=0
	Set PreEndDate=""
	Set (StepList,TimeList,ConfList,SignList)=""
	Set xEpisID=""
	For {
		Set xEpisID=$o(^DHCMA.CPW.CP.PathwayD(PathwayID,"EPIS",xEpisID))
		Quit:xEpisID=""
		Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(PathwayID_"||"_xEpisID)
		Continue:'$IsObject(objEpis)
		
		Set IsActive=objEpis.CPIsActive
		Continue:'IsActive
		
		Set IsConfirm=objEpis.CPIsConfirm
		Set ConfList=ConfList_"^"_IsConfirm
		
		Set ind=ind+1
		Set EpDays=+objEpis.CPEpDays_"天"
		Set SttDate=objEpis.CPSttDate
		Set:(ind=1)&&(SttDate="") SttDate=objPathway.CPInDate	//第一阶段开始日期为入径日期
		Set:(PreEndDate'="")&&(SttDate="") SttDate=PreEndDate+1	//下一阶段的开始日期为上一阶段结束日期+1
		Set SttDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(SttDate)
		Set EndDate=objEpis.CPEndDate
		Set PreEndDate=EndDate
		Set EndDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(EndDate)
		Set StepTime=EpDays_":"_SttDate_":"_EndDate
		Set TimeList=TimeList_"^"_StepTime
		
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
		Set Sign=SignDoc_":"_SignNur_":"_SignDocDate_":"_SignNurDate
		Set SignList=SignList_"^"_Sign
			
		Set StepDesc=objEpis.CPFormEpDr.EpDesc
		Set:StepDesc'="" StepDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc",StepDesc,LangID)
		Set Step=xEpisID_":"_StepDesc
		Set StepList=StepList_"^"_Step
		
	}
	
	Set:StepList'="" StepList=$e(StepList,2,$l(StepList))
	Set:TimeList'="" TimeList=$e(TimeList,2,$l(TimeList))
	Set:ConfList'="" ConfList=$e(ConfList,2,$l(ConfList))
	Set:SignList'="" SignList=$e(SignList,2,$l(SignList))
	Set return=CurrStep_"#"_StepList_"#"_TimeList_"#"_ConfList_"#"_SignList
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-19
/// Description:  临床路径重点医嘱树
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       aPathFormID
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.ImplementSrv).GetOrdItmTree(40,"40||2")
ClassMethod GetOrdItmTree(aPathwayID, aEpisID) As %String
{
	New (aPathwayID,aEpisID)
	Set return="[]"
	Quit:(aPathwayID="")||(aEpisID="") return
	
	Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aEpisID)
	Quit:'$IsObject(objEpis) return
	Set FormEpID=objEpis.CPFormEpDr.%Id()
	
	Set treeJson="["
	Set treeJson=treeJson_"{"
	Set treeJson=treeJson_"""id"":""OrdTree-"_aEpisID_"-"_FormEpID_""","
	Set treeJson=treeJson_"""text"":""重点医嘱"","
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
 		
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 		Continue:TypeDesc'="重点医嘱"
 		
 		Set ItemDesc=objImpl.CPFormItemDr.ItemDesc
 		Set IndexNo=objImpl.CPFormItemDr.ItemIndNo
 		Set IsRequired=+'objImpl.CPFormItemDr.ItemIsOption	//两变量值相反
 		
 		Set IsSystem=objImpl.CPIsSystem
 		Set IsImp=+objImpl.CPIsImp
		
		Set OperInfo="""""" 
		If IsImp=1 {
			Set ActDate=objImpl.CPActDate
 			Set ActDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ActDate)
 			Set ActTime=objImpl.CPActTime
 			Set:ActTime'="" ActTime=$zt(ActTime,1)
 			Set ActUserID=objImpl.CPActUserID
 			Set UserDesc=""
 		
 			Set:ActUserID'["!!" ActUserID=ActUserID_"!!"_1
 			Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
			Set:$IsObject(objUser) UserDesc=objUser.BTDesc
			
			Set OperInfo="""执行信息："_ActDate_" "_ActTime_"，"_UserDesc_""""
		}

		Set FormItemID=objImpl.CPFormItemDr.%Id()
		
 		Set ChildJson=ChildJson_"{"
 		Set ChildJson=ChildJson_"""id"":"""_xImplID_"-"_FormItemID_""","
 		Set ChildJson=ChildJson_"""text"":"""_ItemDesc_""","
 		Set ChildJson=ChildJson_"""attributes"":{""IsImp"":"_IsImp_",""IsRequired"":"_IsRequired_",""OperInfo"":"_OperInfo_"}"
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
/// CreatDate：   2018-08-25
/// Description:  查询阶段里的项目
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aEpisodeID : 就诊号
///               aType : T诊疗N护理O医嘱
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.OPCPS.ImplementSrv","QryCPWStepInfo","2","2||5","O")
Query QryCPWStepInfo(aPathwayID As %String, aEpisID As %String, aType As %String) As %Query(ROWSPEC = "ID:%String,Operation:%String,IndexNo:%String,ItemInfo:%String,IsRequired:%String,OperInfo:%String,IsSystem:%String,IsImp:%String,IsVar:%String") [ SqlProc ]
{
}

ClassMethod QryCPWStepInfoExecute(ByRef qHandle As %Binary, aPathwayID As %String, aEpisID As %String, aType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aPathwayID="")||(aEpisID="") $$$OK
 	Set LangID=20,Languages= "CH"
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
 		
 		Set IsActive=objImpl.CPIsActive
 		Continue:'IsActive
 		
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 		Continue:(aTypeDesc'="")&&(aTypeDesc'=TypeDesc)
 		Set:TypeDesc'="" TypeDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathItemCat","BTDesc",TypeDesc,LangID)
 		
 		Set ItemDesc=objImpl.CPFormItemDr.ItemDesc
 		Set:ItemDesc'="" ItemDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormItem","ItemDesc",ItemDesc,LangID)
 		Set IndexNo=objImpl.CPFormItemDr.ItemIndNo
 		Set IsRequired=+'objImpl.CPFormItemDr.ItemIsOption	//两变量值相反
 		
 		Set IsSystem=objImpl.CPIsSystem
 		Set ActDate=objImpl.CPActDate
 		Set ActDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ActDate)
 		Set ActTime=objImpl.CPActTime
 		Set:ActTime'="" ActTime=$zt(ActTime,1)
 		Set ActUserID=objImpl.CPActUserID
 		Set UserDesc=""
 		
 		Set:ActUserID'["!!" ActUserID=ActUserID_"!!"_1
 		Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
		Set:$IsObject(objUser) UserDesc=objUser.BTDesc
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
 		
 		Set Data=$lb(xImplID,Operation,IndexNo,ItemDesc,IsRequired,OperInfo,IsSystem,IsImp,IsVar)
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-12-13
/// Description:  获取项目关联医嘱执行信息
/// Table：       DHCMA.CPW.CP.PathwayOrd
/// Input：       aFlg
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.ImplementSrv).GetImpOrdInfo("58","1","FJ:16:37||1||10")
ClassMethod GetImpOrdInfo(aCPWID As %String, aEpisID As %String, aFormOrdID As %String) As %String
{
	New (aCPWID,aEpisID,aFormOrdID,%session)
	Set return=""
	Quit:(aCPWID="")||(aEpisID="")||(aFormOrdID="") return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID("",aCPWID,"")
	
	if (aFormOrdID["FJ")
	{
		//Set TCMDr=$p(aFormOrdID,":",2)
		Set PathTCMID=$p(aFormOrdID,":",2)
		//Set aFormItemID=$p(aFormOrdID,":",3)
		Set FormTCMID=$p(aFormOrdID,":",3)
		Set aFormItemID=$p(FormTCMID,"||",1,3)
	}else{
		Set objFormItmOrd = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(aFormOrdID)
		Quit:'$IsObject(objFormItmOrd)
		Set OrdMastID =objFormItmOrd.OrdMastID		//表单项目中关联的医嘱项ID
		Set aFormItemID=$p(aFormOrdID,"||",1)_"||"_$p(aFormOrdID,"||",2)_"||"_$p(aFormOrdID,"||",3)
	}
	Set xImplID=""
 	For {
 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aCPWID,aCPWID_"||"_aEpisID,xImplID))
 		Quit:xImplID=""
 		
 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aCPWID_"||"_xImplID)
 		Continue:'$IsObject(objImpl)
 		Continue:'objImpl.CPIsActive
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 		Continue:TypeDesc'="重点医嘱"
 		Set IsSystem=objImpl.CPIsSystem
 		Set IsImp=+objImpl.CPIsImp
		Continue:'IsImp		//过滤未执行的项目
		Set FormItemID=objImpl.CPFormItemDr.%Id()
		Continue:aFormItemID'=FormItemID
		
		Set IsSame=""
		if (aFormOrdID["FJ") {
			Set xID="",IsSame=1						//方剂默认原医嘱
			For {
				Set xID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","ORD","IdxofFJParRef",aCPWID,xImplID,FormTCMID,xID))
				Quit:xID=""
				Set objCPOrd=##class(DHCMA.CPW.CP.PathwayOrd).GetObjById(aCPWID_"||"_xImplID_"||"_xID)
				Continue:'$IsObject(objCPOrd)
				
				Set IsActive=objCPOrd.CPIsActive
				Continue:'IsActive
				
				Set OrdID=objCPOrd.CPOrdID		//实际执行的医嘱ID
				Continue:OrdID=""
				continue:objCPOrd.CPFormOrdDr'=""
				Set OEORIChildsub=+$p(OrdID,"||",2)
				Set OEORIItmMastDR = $p($g(^OEORD(+OrdID,"I",OEORIChildsub,1)),"^",2) // 医嘱项指针 ARC_ItmMast
				Set ARCIMDesc=$p($g(^ARCIM(+OEORIItmMastDR,1,1)),"^",2)				//医嘱名称
				Set:ARCIMDesc'="" ARCIMDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ARCItmMast","ARCIMDesc",ARCIMDesc,Languages)
				Set OEORISttDat = $p($g(^OEORD(+OrdID,"I",OEORIChildsub,1)),"^",9) // 开始日期 
				Set OEORISttTim = $p($g(^OEORD(+OrdID,"I",OEORIChildsub,1)),"^",10) // 开始时间
				//Set:OEORISttDat'="" OEORISttDat=$zd(OEORISttDat,3)
				Set DateLogRet=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWHISIODateLogicalToHtml",AdmHospID)
			 	Set:(OEORISttDat'="")&(DateLogRet'=1) OEORISttDat = $ZD(OEORISttDat,3)
			 	Set:(OEORISttDat'="")&(DateLogRet=1) OEORISttDat = ##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(OEORISttDat)
				Set:OEORISttTim'="" OEORISttTim=$zt(OEORISttTim,1)
				Set DateTime=OEORISttDat_" "_OEORISttTim
				Set OrdInfo=ARCIMDesc_"("_DateTime_")"
				Set return=return_"<br />"_OrdInfo
			}
			Set:return'="" return=IsSame_"^"_$e(return,7,$l(return))
			
		}else{
			Set xCPOrdID="",IsSame=0
			For {
				Set xCPOrdID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","ORD","IdxofParRef",aCPWID,xImplID,aFormOrdID,xCPOrdID))
				Quit:xCPOrdID=""
				
				Set objCPOrd=##class(DHCMA.CPW.CP.PathwayOrd).GetObjById(aCPWID_"||"_xImplID_"||"_xCPOrdID)
				Continue:'$IsObject(objCPOrd)
				
				Set IsActive=objCPOrd.CPIsActive
				Continue:'IsActive
				
				Set OrdID=objCPOrd.CPOrdID		//实际执行的医嘱ID
				Continue:OrdID=""
				For ind=1:1:$l(OrdID,"^"){
					Set xOrdID=$p(OrdID,"^",ind)
					Continue:xOrdID=""
					Set OEORIChildsub=+$p(xOrdID,"||",2)
					Set OEORIItmMastDR = $p($g(^OEORD(+xOrdID,"I",OEORIChildsub,1)),"^",2) // 医嘱项指针 ARC_ItmMast
					Set ARCIMDesc=$p($g(^ARCIM(+OEORIItmMastDR,1,1)),"^",2)				//医嘱名称
					Set:ARCIMDesc'="" ARCIMDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ARCItmMast","ARCIMDesc",ARCIMDesc,Languages)
					Set OEORISttDat = $p($g(^OEORD(+xOrdID,"I",OEORIChildsub,1)),"^",9) // 开始日期 
					Set OEORISttTim = $p($g(^OEORD(+xOrdID,"I",OEORIChildsub,1)),"^",10) // 开始时间
					//Set:OEORISttDat'="" OEORISttDat=$zd(OEORISttDat,3)
					Set DateLogRet=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWHISIODateLogicalToHtml",AdmHospID)
					Set:(OEORISttDat'="")&(DateLogRet'=1) OEORISttDat = $ZD(OEORISttDat,3)
					Set:(OEORISttDat'="")&(DateLogRet=1) OEORISttDat = ##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(OEORISttDat)
					Set:OEORISttTim'="" OEORISttTim=$zt(OEORISttTim,1)
					Set DateTime=OEORISttDat_" "_OEORISttTim
					Set OrdInfo=ARCIMDesc_"("_DateTime_")"
					Set:OrdMastID=OEORIItmMastDR IsSame=1
					Set return=return_"<br />"_OrdInfo	
				}
				If OrdMastID'["||"{									//医嘱套默认原医嘱
					Set IsSame=1
				}Else{
					Set:OrdMastID=OEORIItmMastDR IsSame=1			//医嘱项检查原医嘱还是替换医嘱
				}
			}
			Set:return'="" return=IsSame_"^"_$e(return,7,$l(return))
		}
		Quit:return'=""
 	}
 	
 	Quit return
}

/// Creator:	  zhuguozhang
/// Description:  阶段确定操作
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       EpisodeID   
/// w ##class(DHCMA.CPW.OPCPS.ImplementSrv).ConfirmStep("15||1","04/01/2019","15/01/2019","5337!!1","2")
ClassMethod ConfirmStep(aEpisID As %String, aSttDate As %String, aEndDate As %String, aUserID As %String, aNextEpisID) As %String
{
	New (aEpisID,aSttDate,aEndDate,aUserID,aNextEpisID)
	Set return=""
	Quit:(aEpisID="")||(aSttDate="")||(aEndDate="")||(aUserID="") return
	
	Set aPathwayID=$p(aEpisID,"||",1)
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Quit:'$IsObject(objPathway) "-1"
	
	Set return=##class(DHCMA.CPW.CP.PathwayEpis).Confirm(aEpisID,aSttDate,aEndDate,aUserID)
	If return<1{
		Quit "-2"	
	}Else{
		//考虑门诊临床路径的及时性，路径只需要每个步骤确认，最后一阶段确认完成自动完成路径
		if (aNextEpisID'="") {
			Set objPathway.CPEpisDr=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aNextEpisID)
		}else{
			Set objPathway.CPStatus="C"
			Set objPathway.CPActDate=+$H
			Set objPathway.CPActTime=$p($H,",",2)
			Set objPathway.CPActUserID=aUserID
		}
		Set sc=objPathway.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功  
   			Set return="-3"
   		}
		Do objPathway.%Close()
	}
	
	Quit return
}

/// Creator:	  zhuguozhang
/// 执行表单项目
/// w ##class(DHCMA.CPW.OPCPS.ImplementSrv).ExecuteItem("8","6","","9!!2","1","0")
ClassMethod ExecuteItem(aPathwayID As %String, aItemID As %String, aOrdID As %String, aUserID As %String, aIsImpl As %String, aIsSystem As %String, aEpisodeID As %String) As %String
{
	New (aPathwayID,aItemID,aOrdID,aUserID,aIsImpl,aIsSystem,aEpisodeID)
	Set return=""
	Quit:(aPathwayID="")||(aItemID="") return	
	Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_aItemID)
	Quit:'$IsObject(objImpl) return
	
	Set objImpl.CPIsSystem=aIsSystem
	Set objImpl.CPOrdDID=""
	Set objImpl.CPIsImp=aIsImpl
	
	Set objImpl.CPActDate=+$H
	Set objImpl.CPActTime=$p($H,",",2)
	Set objImpl.CPActUserID=aUserID
	Set objImpl.CPIsActive=1
	Set objImpl.CPEpisodeID=aEpisodeID
	Set sc=objImpl.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=objImpl.%Id()
	}
	Do objImpl.%Close()
	//如果执行该项目时，没有对应的Visit记录，则新增一条
	Set EpisID=objImpl.CPEpisDr.%Id()
	if ('$d(^DHCMA.CPW.CP.PathwayVisitI("IdxOfEpisodeIDEpisDr"," "_aEpisodeID,EpisID," I"))) {
			d ..AddNewEPVsit(aEpisodeID,EpisID)
		}
	Quit return
}

/// Creator:	  zhuguozhang
/// 新添加一条Visit记录
/// w ##Class(DHCMA.CPW.OPCPS.ImplementSrv).AddNewEPVsit()
ClassMethod AddNewEPVsit(aEpisodeID As %String, EpisID As %String) As %String
{
	New (EpisID,aEpisodeID)
	Set return=""
	Quit:(EpisID="")||(aEpisodeID="") return
	
	Set ObjVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjByEpisodeID(aEpisodeID)
	Quit:'$IsObject(ObjVisit)
	
	Set ObjNewEPVsit=##class(DHCMA.CPW.CP.PathwayVisit).%New()	
	Set ObjNewEPVsit.CPEpisodeID=ObjVisit.CPEpisodeID
	Set ObjNewEPVsit.CPPatientID=ObjVisit.CPPatientID
	Set ObjNewEPVsit.CPIdentityCode=ObjVisit.CPIdentityCode
	Set ObjNewEPVsit.CPPathwayDr=ObjVisit.CPPathwayDr
	Set ObjNewEPVsit.CPFormDr=ObjVisit.CPFormDr
	Set ObjNewEPVsit.CPEpisDr=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(EpisID)	
	Set ObjNewEPVsit.CPApplyDr=ObjVisit.CPApplyDr
	Set ObjNewEPVsit.CPStatus="I"
	Set ObjNewEPVsit.CPActDate=+$h
	Set ObjNewEPVsit.CPActTime=$p($h,",",2)
	Set ObjNewEPVsit.CPActUserID=ObjVisit.CPActUserID
	Set ObjNewEPVsit.CPInDocID=ObjVisit.CPInDocID
	Set ObjNewEPVsit.CPInDate=+$h
	Set ObjNewEPVsit.CPInTime=$p($h,",",2)
	Set ObjNewEPVsit.CPInUserID=ObjVisit.CPInUserID
	Set ObjNewEPVsit.CPInLocID=ObjVisit.CPInLocID
	Set ObjNewEPVsit.CPInWardID=ObjVisit.CPInWardID
	Set ObjNewEPVsit.CPInDiags=ObjVisit.CPInDiags
	Set sc=ObjNewEPVsit.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=ObjNewEPVsit.%Id()
	}
	Do ObjNewEPVsit.%Close()
	Do ObjVisit.%Close()
	Quit return
}

/// Description:  门诊阶段确认前检查日期是否合法
/// Input：       aEpisID : 阶段ID,aSttDate : 当前阶段开始日期
/// Return:		  返回String: 
/// w ##class(DHCMA.CPW.OPCPS.ImplementSrv).CheckStepDate("52||2","2019-10-24")
ClassMethod CheckStepDate(aEpisID As %String, aSttDate As %String) As %String
{
	New (aEpisID,aSttDate)
	Set return=""
	Quit:(aEpisID="")||(aSttDate="") return
	
	Set PathwayID=$p(aEpisID,"||",1)
	Set xEpisID=$p(aEpisID,"||",2)
	Set PreEpisID=$o(^DHCMA.CPW.CP.PathwayD(PathwayID,"EPIS",xEpisID),-1)
	Set objPreEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(PathwayID_"||"_PreEpisID)
	Quit:'$IsObject(objPreEpis) return
	Set PreStepEndDate=objPreEpis.CPEndDate
	Set CurrSttDate=##class(DHCMA.Util.IO.FromHisSrv).GetDateHtmlToLogical(aSttDate)
	Set:CurrSttDate-PreStepEndDate<0 return="当前阶段开始日期不允许早于前一阶段结束日期"
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-10-17
/// Description:  变异原因树
/// Table：       DHCMA.CPW.BT.PathVariat
/// Input：       aPathFormID
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.ImplementSrv).GetVariatTree("01","")
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
		Set:TypeDesc'="" TypeDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",TypeDesc,LangID)
		
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

/// Creator：     yankai
/// CreatDate：   2019-11-08
/// Description:  批量进行主要诊疗项目执行，供就诊入径时调用（江苏省中个性化需求）
/// Table：       DHCMA.CPW.CP.PathwayImpl
/// Input：       aFlg
/// Return:
/// w ##class(DHCMA.CPW.OPCPS.ImplementSrv).ExecuteAllItem("733!!1","61","61||1")
ClassMethod ExecuteAllItem(aEpisodeID As %String, aPathwayID As %String, aEpisID As %String) As %String
{
	New (aEpisodeID,aPathwayID,aEpisID)
	Set return=""
	Quit:(aEpisodeID="")||(aPathwayID="")||(aEpisID="") return
	
	Set xImplID=""
 	For {
 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aEpisID,xImplID))
 		Quit:+return<0
 		Quit:xImplID=""
 		
 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xImplID)
 		Continue:'$IsObject(objImpl)
 		Continue:'objImpl.CPIsActive
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 		Continue:TypeDesc'="主要诊疗工作"
		Continue:+objImpl.CPIsImp=1									//过滤已执行的项目
			
		Set objImpl.CPIsImp=1
		Set objImpl.CPActDate=+$H
		Set objImpl.CPActTime=$p($H,",",2)
		Set objImpl.CPActUserID=""
		Set objImpl.CPIsActive=1
		Set objImpl.CPEpisodeID=aEpisodeID
		Set sc=objImpl.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
   			Do $system.OBJ.DisplayError(sc) 
   			Set return=-1
		}Else{
			Set return=objImpl.%Id()
		}
		Do objImpl.%Close()
	}
	
	Quit return
}

}
