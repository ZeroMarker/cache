Import sqluser

/// Creator: 	huaxiaoying
/// CreateDate: 2018-05-04
/// Descript: 	急诊病人状态改变
Class web.DHCEMVisitStat Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:    huaxiaoying
/// CreateDate: 2018-05-04
/// Descript:   急诊病区  
/// w ##Class(web.DHCEMVisitStat).GetEmWard("2","急诊留观")
ClassMethod GetEmWard(HospID As %String, q = "") As %String
{
	n (HospID,q,%session)
	S count=0
	
	Set result=##class(%Library.ResultSet).%New("web.DHCCLCom:LookUpWard")
	Set sc=result.Execute(q, "EM", HospID)
	If $$$ISERR(sc) Quit ""
	
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("wardId")
		s LocID=$p(^PAWARD(RowId),"^",5)
		continue:$p(^CTLOC(LocID),"^",14)'="Y"
		continue:$p(^PAWARD(RowId),"^",6)'="Y"
		s Desc = result.Data("wardDesc")
		continue:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("PAC_Ward",RowId,HospID)'="Y" //hxy 2020-05-27 病区绝对私有，不加实际上也能区分
		continue:'+$o(^PAWARD(RowId,"BED",""),-1)
		continue:'+$o(^PAWARD(RowId,"ROOM",""),-1)
		s Desc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",Desc) //hxy 2022-12-06
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	}
	w "]"
	Do result.Close()
	
	q ""
}

/// Creator:    huaxiaoying
/// CreateDate: 2018-05-07
/// Descript:   入院病区  
/// w ##Class(web.DHCEMVisitStat).GetInWard("2","消化")
ClassMethod GetInWard(HospID As %String, q = "") As %String
{
	n (HospID,q,%session)
	S count=0
	s input=$ZCVT(q,"U")
	Set result=##class(%Library.ResultSet).%New("web.DHCCLCom:LookUpWard")
	Set sc=result.Execute(input, "W", HospID)
	If $$$ISERR(sc) Quit ""
	
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("wardId")
		s LocID=$p(^PAWARD(RowId),"^",5)
		continue:$p(^CTLOC(LocID),"^",14)'="Y"

		continue:$p(^PAWARD(RowId),"^",6)'="Y"
		s Desc = result.Data("wardDesc")
		continue:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("PAC_Ward",RowId,HospID)'="Y" //hxy 2020-05-27 病区绝对私有，不加实际上也能区分
		s Desc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",Desc) //hxy 2023-01-31
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	}
	w "]"
	Do result.Close()
	
	q ""
}

/// Creator:    huaxiaoying
/// CreateDate: 2018-05-07
/// Descript:   病人状态  
/// w ##Class(web.DHCEMVisitStat).GetPatStat()
ClassMethod GetPatStat(HospID As %String, q = "") As %String
{
	n (HospID,q)
	S count=0
	
	Set result=##class(%Library.ResultSet).%New("web.DHCADMVisitStat:GetPatStat")
	Set sc=result.Execute()
	If $$$ISERR(sc) Quit ""
	
	w "["
	While(result.Next())
	{	
		s code = result.Data("code")
		s desc = result.Data("desc")
		s tmp=code_"^"_desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	}
	w "]"
	Do result.Close()
	
	q ""
}

/// Creator:    huaxiaoying
/// CreateDate: 2018-05-11
/// Descript:   病人状态走用戶配置  
/// w ##Class(web.DHCEMVisitStat).GetUserAccessStat("4634")
ClassMethod GetUserAccessStat(userId As %String) As %String
{
	n (userId)
	
	s str=##Class(web.DHCADMVisitStat).GetUserAccessStat("E",userId)

	S count=0,i=1
	w "["
	While($P(str,"^",i)'="")
	{	
		s code = $P(($P(str,"^",i)),"!",1)
		s desc = $P(($P(str,"^",i)),"!",2)
		s tmp=code_"^"_desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
		s i=i+1
	}
	w "]"
	
	q ""
}

/// Creator:    huaxiaoying
/// CreateDate: 2018-05-11
/// Descript:   病人状态走用戶配置  
/// w ##Class(web.DHCEMVisitStat).GetUserAccessStatAll()
ClassMethod GetUserAccessStatAll() As %String
{
	s Count=0
	w "["
	s ID=0
	f  s ID=$o(^DHCPACVisitStatus(ID)) q:ID=""  d
	.s Code = $P(^DHCPACVisitStatus(ID),"^",1)
	.s Desc = $P(^DHCPACVisitStatus(ID),"^",2)
	.s Active=$p(^DHCPACVisitStatus(ID),"^",11)
	.q:Active'="Y"
	.s Desc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCPACVisitStatus","PVSDesc","",Desc) //hxy 2022-12-13
	.s Tmp=Code_"^"_Desc
	.s Count = Count+1
	.I Count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("id^text",Tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",Tmp)
	w "]"
	
	q ""
}

/// 撤消最终结算
/// w ##Class(web.DHCEMVisitStat).websysReverseDischarge("89","1","病情变化")
ClassMethod websysReverseDischarge(EpisodeID As %String, userId As %String, reverseDesc As %String)
{
	n (EpisodeID,userId,reverseDesc)
	S reverseReasonId = ##class(web.PACReasonForReverseFinDisch).GetIdFromCodeOrDescription(reverseDesc)
	;P5的wanghcAdd
	s rtn=##class(web.DHCADTDischarge).PAAdmReverseFinalDischarge(EpisodeID, userId, reverseReasonId)
	q rtn //$$$OK_
}

/// Creator:    huaxiaoying
/// CreateDate: 2018-05-10
/// Descript:   撤销结算原因    PAC_ReasonForReverseFinDisch
/// w ##Class(web.DHCEMVisitStat).GetRFDDesc()
ClassMethod GetRFDDesc() As %String
{
	n (%session)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RFD_RowId,RFD_Desc FROM PAC_ReasonForReverseFinDisch"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("RFD_RowId")
		s Desc = result.Data("RFD_Desc")
		s Desc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACReasonForReverseFinDisch","RFDDesc","",Desc) //hxy 2023-01-31
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	}
	w "]"
	Do result.Close()
	
	q ""
}

/// Creator:qqa
/// Date:2018-07-27
/// Descript:病人状态改变核心代码：增加事务
/// w ##class(web.DHCEMVisitStat).InsertVis("1848^Stay^2019-06-28^09:05^11841^^56^0^203")
ClassMethod InsertVis(Params, LgParams = "")
{
	n (Params,LgParams,%session)
	s EpisodeID=$p(Params,"^",1)
	s VisStatCode=$p(Params,"^",2)
	s AvsDateStr=$p(Params,"^",3)   //修改日期
	s AvsTimeStr=$p(Params,"^",4)   //修改时间
	s UserId=$p(Params,"^",5)
	s WardDesc=$p(Params,"^",6)
	s EmWardId=$p(Params,"^",7) 
	s CancelFlag=$p(Params,"^",8)
	s CurLodID=$p(Params,"^",9)
	s VsNote=$p(Params,"^",12)     //备注-转入医院/离院原因
	s LgHospID=$p(LgParams,"^",1)
	s LgCtLocID=$p(LgParams,"^",2)
	s LgGroupID=$p(LgParams,"^",3)
	s LgUserID=$p(LgParams,"^",4)
	s VisStatId=$o(^DHCPACVisitStatus(0,"Code",$$ALPHAUP^SSUTIL4(VisStatCode),""))	//状态id
	q:+VisStatId=0 "系统未找到对应的状态!"
	
	s AutoDis = $p(^DHCPACVisitStatus(VisStatId),"^",10)		//自动离院
	s OBSNEEDAPP=##Class(web.DHCAppComPar).GetAppPropValue("DHCEMDOC","OBSNEEDAPP",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s isTakStayFlag=##Class(web.DHCAppComPar).GetAppPropValue("DHCEMDOC","SETORDERSTAY",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s Ret=0
	s IsPayAss=""
	s:OBSNEEDAPP=1 IsPayAss=##class(web.DHCEMVisitStat).PatIsPayAss(EpisodeID)
	q:(OBSNEEDAPP=1)&&(+IsPayAss=0)&&((VisStatCode="Stay")||(VisStatCode="Salvage")) "请先填写预交金评估信息!"
	
	s retStr = ##class("web.DHCEMPatChange").GetAdmType(EpisodeID)
	q:retStr'="E" "只能对急诊病人操作!"
	
	s retStr = ##class("web.DHCEMPatChange").VerifyUpdDate(EpisodeID,AvsDateStr)
	q:retStr'="0" "改变状态日期不能小于就诊日期!"
	
	
	ts
	
	i VisStatCode="Discharge" d
	.s Ret = ##class(web.DHCEMPatChange).SetPatChargeStatusNew(EpisodeID,AvsDateStr,AvsTimeStr,UserId,"",VsNote)  //现用护士执行离院方法
	tro:Ret'=0
	q:Ret'=0 Ret
	
	///离院方法特殊处理:离院方法中有插入状态
	//s:VisStatCode'="Discharge" Ret = ##class(web.DHCADMVisitStat).InsertVis(EpisodeID,VisStatCode,AvsDateStr,AvsTimeStr,UserId,WardDesc,CancelFlag)  //原护理组插入状态方法：插入状态
	s:VisStatCode'="Discharge" Ret = ##class(web.DHCEMPatChange).InsertVis(EpisodeID,VisStatCode,AvsDateStr,AvsTimeStr,UserId,WardDesc,VsNote,isTakStayFlag)
	tro:Ret'=0
	q:Ret'=0 Ret
	
	///留观
	i (VisStatCode="Stay")||(VisStatCode="Salvage") d
	.s IsObs = ##Class(web.DHCEMVisitStat).IsObsIng(EpisodeID)
	.s:IsObs=1 Ret=##class(web.DHCEMVisitStat).ChangeWard(EpisodeID,UserId,EmWardId)
	.s:IsObs'=1 Ret = ##class(web.DHCADMVisitStat).SetStayStatus(EpisodeID,UserId,CurLodID,EmWardId,"")   //原护理组方法：置病人进留观室
	tro:Ret'=0
	q:Ret'=0 Ret
	
	i (VisStatCode="Death")||(VisStatCode="SalDeath") d
	.s Ret = ##class(web.DHCEMPatChange).SetDeceasedStatus(EpisodeID,AvsDateStr,AvsTimeStr,UserId)   //原护理组方法:修改病人状态为死亡
	tro:Ret'=0
	q:Ret'=0 Ret
	
	i isTakStayFlag = 1 D
	.s visStatId=$o(^DHCPACVisitStatus(0,"Code",$$ALPHAUP^SSUTIL4(VisStatCode),"")) //hxy 2019-12-09 st
	.s:(VisStatCode="Stay")!(VisStatCode="Salvage") Ret=##class(web.DHCEMVisitStat).UpdateOrderItemByAdm(EpisodeID,"1",visStatId) //hxy 2019-12-08 ed

	i AutoDis="Y" d
	.s Ret = ##class(web.DHCEMPatChange).SetPatChargeStatusNew(EpisodeID,AvsDateStr,AvsTimeStr,UserId,"","自动离院")  //现用护士执行离院方法
	tro:Ret'=0
	q:Ret'=0 Ret
	
	tc
	q "0"
}

/// Creator:	   qqa
/// CreateDate:    2021-04-21
/// Descript:	   是否正在留观
/// Return: 1:正在留观/其他:未正在留观
/// w ##Class(web.DHCEMInterfaceCom).IsObsIng("1628")
ClassMethod IsObsIng(EpisodeID As %String)
{
	n (EpisodeID)
	
	s Ret=""
	s:$d(^PAWARDA(0,"WADM",EpisodeID)) Ret=1
	s:$d(^PAWARDA(0,"RADM",EpisodeID)) Ret=1
	s:$d(^PAWARDA(0,"ADM",EpisodeID)) Ret=1
	q Ret
}

ClassMethod ChangeWard(EpisodeID, UserId, EmWardId)
{
	n (EpisodeID,UserId,EmWardId,%session)
	s AdmWardID=$p(^PAADM(EpisodeID),"^",70)
	q:AdmWardID=EmWardId 0
	s Ret=##class(web.DHCADTTransaction).MoveAdm(EpisodeID, UserId, EmWardId)
	q Ret
}

/// 新增方法提供给急诊留观用的，作用是将传进来的就诊ID对应的医嘱中未计费的医嘱更新成传入的字段值
/// w ##class(web.DHCEMVisitStat).UpdateOrderItemByAdm(24957943,"1")
ClassMethod UpdateOrderItemByAdm(Adm As %String = "", Status1 As %String = "", Status2 As %String = "")
{
	n (Adm,Status1,Status2)
	s ret="0"
	Q:Adm="" "-1"
	Q:Status1="" "-2"
	Q:Status1'=1 "0"
	s OEORDRowId =""
	for {
		s OEORDRowId = $O(^OEORD(0,"Adm",Adm,OEORDRowId))
		q:OEORDRowId=""  ;该患者没有查询到医嘱记录
		s OrdItemSub = 0
		for {
			s OrdItemSub = $O(^OEORD(OEORDRowId,"I",OrdItemSub)) q:OrdItemSub=""
			s OEORIItemStat= $p($g(^OEORD(OEORDRowId,"I",OrdItemSub,1)),"^",13)
			continue:OEORIItemStat'=1
			s OEORIBilled = $p($g(^OEORD(OEORDRowId,"I",OrdItemSub,3)),"^",5)
			if (OEORIBilled'="P"){
				s $p(^OEORD(OEORDRowId,"I",OrdItemSub,"DHC"),"^",17)=Status1
				s $p(^OEORD(OEORDRowId,"I",OrdItemSub,"DHC"),"^",58)=Status2
			}
		}
	}
	q ret
}

/// w ##class(web.DHCEMVisitStat).PatIsPayAss(4774)
ClassMethod PatIsPayAss(AdmID)
{
	n (AdmID)
	q:AdmID="" ""
	s EmRowID=$o(^DHCEMADVPA(0,"AdmNo",AdmID,""),-1)
	q EmRowID
}

ClassMethod GetParams(Params)
{
	n (Params)
	s EpisodeID=$p(Params,"^",1)
	s PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
	s DateFormat = ##class(web.DHCEMCommonUtil).DateFormat()
	s DeceasedFlag=$p($g(^PAPER(+PatientID,"ALL")),"^",12)
	s CurDate=+$H,CurTime=$p($H,",",2)
	s CurDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(CurDate)
	s CurTime=$zt(CurTime,2)
	q DateFormat_"^"_DeceasedFlag_"^"_CurDate_"^"_CurTime
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-03-05
/// Descript:    病人状态变更历史列表
/// Input:   	 EpisodeID - 就诊ID
/// w ##Class(web.DHCEMVisitStat).JsonQryVisitHis("165")
ClassMethod JsonQryVisitHis(rows As %String, page As %String, EpisodeID As %String, OtherParams = "") As %String
{
	n (rows, page, EpisodeID,OtherParams,%session)
	w:+EpisodeID=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出json空串
	q:+EpisodeID=0 ""
	s StDate=$p(OtherParams,"^",1)
	s EndDate=$p(OtherParams,"^",2)
	s StateId=$p(OtherParams,"^",3)
	s:StDate'="" StDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(StDate)
	s:EndDate'="" EndDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(EndDate)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpVsArr
	s vsID="", Num=0
	F  s vsID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,vsID)) Q:vsID=""  D
	.s vsPsID=$p($g(^DHCADMVisitStatus(vsID)),"^",2)
	.Q:vsPsID=""
	.q:(StateId'="")&&(StateId'=vsPsID)
	.s vsCode=$p($g(^DHCPACVisitStatus(vsPsID)),"^",1)
	.s vsCode=$zcvt(vsCode,"U")
	.s vsDesc=$p($g(^DHCPACVisitStatus(vsPsID)),"^",2)
	.s VsFlag=""
	.s vsDate=$p(^DHCADMVisitStatus(vsID),"^",5)   /// 状态日期
	.q:(StDate'="")&&(StDate>vsDate)
	.q:(EndDate'="")&&(EndDate<vsDate)
	.s vsDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(vsDate)
    .s vsTime=$p(^DHCADMVisitStatus(vsID),"^",6)   /// 状态时间
    .i vsTime'="" s vsTime=$zt(vsTime,2)
    .s LocID=$p(^DHCADMVisitStatus(vsID),"^",3)    /// 科室
    .s PatLoc=$p($g(^CTLOC(+LocID)),"^",2)
	.s UserID=$p(^DHCADMVisitStatus(vsID),"^",4)   /// 操作人
    .s User=$p($g(^SSU("SSUSR",+UserID)),"^",2)
    .s WardID=$p(^DHCADMVisitStatus(vsID),"^",10)  /// 病区
    .s Ward=$p($g(^PAWARD(+WardID)),"^",2)
    .s vsNote=$p(^DHCADMVisitStatus(vsID),"^",11)  /// 备注
    .s PatLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",PatLoc) //hxy 2023-01-31 st
    .s User=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",User)
    .s Ward=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",Ward)
    .s vsDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCPACVisitStatus","PVSDesc","",vsDesc) //ed
    .s:vsNote="离院召回" vsNote=##class(web.DHCEMCommonUtil).GetTrans("dhcem.visitstat.csp","离院召回")
	.s ListData=vsID_"^"_vsDate_"^"_vsTime_"^"_User_"^"_PatLoc_"^"_Ward_"^"_vsCode_"^"_vsDesc_"^"_vsNote
	.s Num=Num+1
	.s TmpVsArr(Num)=ListData
	.

	s ListTitle="vsID^vsDate^vsTime^User^PatLoc^Ward^vsCode^vsDesc^vsNote"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",Num=0
	F  s index=$o(TmpVsArr(index),-1) Q:index=""  D
	.s ListData=$g(TmpVsArr(index))
	.Q:ListData=""
	.s Num=Num+1
	.Q:(Num<Start)||(Num>End)
	.i Num=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)

	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

/// Creator: 	 qqa
/// CreateDate:  2020-04-16
/// Descript:    
/// Input:   	 EpisodeID - 就诊ID
/// w ##Class(web.DHCEMVisitStat).GetPAADMPriorityDR("124")
ClassMethod GetPAADMPriorityDR(EpisodeID)
{
	n (EpisodeID,%session)
	q:+EpisodeID=0 ""
	s PAADMAdmReasonDR=$p(^PAADM(EpisodeID,1),"^",7)
	s:PAADMAdmReasonDR'="" AdmReason=$p(^PAC("ADMREA",PAADMAdmReasonDR),"^",2)
	s PriorityDR=$p($g(^PAADM(EpisodeID)),"^",33)
	s PAAdmPriority=""
	s:PriorityDR'="" PAAdmPriority=$p($g(^CT("ACU",PriorityDR)),"^",1)
	s CTACUDesc=""
	s:+PAAdmPriority'=0 CTACUDesc=$case(+PAAdmPriority,1:"Ⅰ",2:"Ⅱ",3:"Ⅲ",4:"Ⅳa",5:"Ⅳb")_"("_##class(web.DHCEMCommonUtil).GetTransDesc("User.CTAcuity","CTACUDesc","",$p(^CT("ACU",PriorityDR),"^",2))_")"
	q CTACUDesc
}

/// Creator: 	 qqa
/// CreateDate:  2020-11-11
/// Descript:    撤销留观
/// Input:   	 EpisodeID - 就诊ID
/// w ##Class(web.DHCEMVisitStat).GetPAADMPriorityDR("124")
ClassMethod UndoPatObs(EpisodeID, LgParams)
{
	n (EpisodeID,LgParams)
	s AdmType = ##class("web.DHCEMPatChange").GetAdmType(EpisodeID)
	q:AdmType'="E" "只能对急诊病人操作!"
	s IsHasObsOrd=##Class(web.DHCEMVisitStat).IsHasObsOrd(EpisodeID)
	q:IsHasObsOrd=1 "已经具有留观医嘱,不能撤销留观!"
	s PatObsBedID=$p(^PAADM(EpisodeID),"^",73)
	q:PatObsBedID'="" "已经安排了留观床位,不能撤销留观!"
	s CurWardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
	q:CurWardId'="" "已经安排了留观床位,不能撤销留观!"
	s CurWardId=$o(^PAWARDA(0,"WADM",EpisodeID,""))
	q:CurWardId="" "患者未在留观等候区,不能撤销留观!"
	s VsID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	q:+VsID=0 "患者当前状态非留观和抢救状态,不能撤销留观!"
	s VsPsID=$p($g(^DHCADMVisitStatus(VsID)),"^",2)
	q:+VsPsID=0 "患者当前状态非留观和抢救状态,不能撤销留观!"
	s VsPsCode = $p(^DHCPACVisitStatus(VsPsID),"^",1)
	q:(VsPsCode'="Stay")&&(VsPsCode'="Salvage") "患者当前状态非留观和抢救状态,不能撤销留观!"
	s HasMoreStayLog=##Class(web.DHCEMVisitStat).HasMoreStayLog(EpisodeID)
	q:HasMoreStayLog'="N" "患者已经存在过多的状态操作，无法撤销留观!"
	s Err=0
	ts

	&sql(DELETE DHC_ADMVisitStatus WHERE AVS_RowId=:VsID)
	s Err=SQLCODE
	i Err<0 tro
	q:Err<0 "修改急诊患者状态改变表失败!"
	
	&sql(UPDATE PA_ADM SET PAADM_CurrentWard_Dr=NULL,PAADM_CurrentRoom_DR=NULL where PAADM_RowId=:EpisodeID)
	s Err=SQLCODE
	i Err<0 tro
	q:Err<0 "修改PAADM表中病区和床位字段失败!"
	
	&sql(UPDATE PA_AdmExt SET PAADM_AdminDate=NULL,PAADM_AdminTime=NULL Where PAADM_RowId=:EpisodeID)
	s Err=SQLCODE
	i Err<0 tro
	q:Err<0 "修改就诊扩展表失败!"
	
	s WAdmSub=$o(^PAWARDA(0,"WADM",EpisodeID,CurWardId,""))
	i WAdmSub'="" d
	.s WAdmID=CurWardId_"||"_WAdmSub
	.&sql(DELETE PAC_WardAdm WHERE WADM_RowId=:WAdmID)
	.s Err=SQLCODE
	i Err<0 tro
	q:Err<0 "修改留观等候区信息失败!"
	
	s TransSub=$o(^PAADMi("TransWard",CurWardId,EpisodeID,""),-1)
	i TransSub'="" d
	.s TransID=EpisodeID_"||"_TransSub
	.&sql(DELETE PA_AdmTransaction WHERE TRANS_RowId=:TransID)
	s Err=SQLCODE
	i Err<0 tro
	q:Err<0 "修改就诊变更表失败!"
	
	tc
	
	q Err
}

/// Return:出现留观和抢救状态的数量
/// w ##class(web.DHCEMVisitStat).StayLogNumber(4280)
ClassMethod StayLogNumber(EpisodeID)
{
	n (EpisodeID)
	s HasObsCount=0
	s VsRowId=0
	f  s VsRowId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,VsRowId)) q:VsRowId=""  d
	.s VsPsRowId=$p($g(^DHCADMVisitStatus(VsRowId)),"^",2)
	.q:+VsPsRowId=0
	.s VsPsCode = $p(^DHCPACVisitStatus(VsPsRowId),"^",1)
	.s:(VsPsCode="Stay")||(VsPsCode="Salvage") HasObsCount=HasObsCount+1
	q HasObsCount
}

/// Return:留观之后存在过多的状态操作:日志只有一条留观/抢救状态，最后一条为留观/抢救状态
/// w ##class(web.DHCEMVisitStat).HasMoreStayLog(4280)
ClassMethod HasMoreStayLog(EpisodeID)
{
	n (EpisodeID)
	s Ret="Y"
	s StayLogNumber = ##class(web.DHCEMVisitStat).StayLogNumber(EpisodeID)
	q:StayLogNumber>1 Ret
	
	s VsRowId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1) 
	s VsPsRowId=$p($g(^DHCADMVisitStatus(VsRowId)),"^",2)
	q:+VsPsRowId=0 Ret
	s VsPsCode = $p(^DHCPACVisitStatus(VsPsRowId),"^",1)
	s:(VsPsCode="Stay")||(VsPsCode="Salvage") Ret="N"
	
	q Ret
}

/// Creator: 	 qqa
/// CreateDate:  2020-11-11
/// Descript:    就诊中是否含有留观医嘱
/// Input:   	 EpisodeID - 就诊ID
/// w ##Class(web.DHCEMVisitStat).IsHasObsOrd("4267")
ClassMethod IsHasObsOrd(EpisodeID)
{
	n (EpisodeID)
	
	s Ret=0
	s Ord=0
	f  s Ord=$o(^OEORD(0,"Adm",EpisodeID,Ord)) q:(Ord="")||(Ret=1)  d
	.s Itm=""
	.f  s Itm=$o(^OEORD(Ord,"I",Itm)) q:(Itm="")||(Ret=1)  d
	..s StayFlag=$p($g(^OEORD(Ord,"I",Itm,"DHC")),"^",17)
	..q:StayFlag'=1
	..s OrdStatusId=$p($g(^OEORD(Ord,"I",Itm,1)),"^",13)  
	..s OrdState=$p($g(^OEC("OSTAT",OrdStatusId)),"^",1)
	..q:OrdState="U"
	..q:OrdState="D"
	..q:OrdState="C"
	..s Ret=1
	q Ret
}

}
