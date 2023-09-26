/// CTOR: QP
/// DATE: 2020-09-22
/// DESC: 临床药理项目查询操作类
Class web.PilotProject.CFG.FindGCP Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-22
/// DESC: 删除免费医嘱设置
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.CFG.FindGCP).DelFreeOrder("")
ClassMethod DelFreeOrder(ids As %String = "")
{
	s mRtn=0
	Q:ids="" 0
	TS
	f i=1:1:$l(ids,",") {
		Q:mRtn'=0
		s PPFID=$p(ids,",",i)
		&SQL(DELETE FROM SQLUser.DHC_DocPilotProFreeOrd WHERE PPF_RowId=:PPFID)
		i SQLCODE'=0 s mRtn=SQLCODE
	}
	i mRtn'=0 {
		TRO
		Q mRtn	
	}
	TC
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-22
/// DESC: 判断医嘱项是否在药理项目的免费医嘱内
/// IN  : 
/// OUT : 
/// OLD : w ##class(web.PilotProject.DHCDocPilotProject).CheckArcim(1,"11496||1")
/// EXEC: w ##class(web.PilotProject.CFG.FindGCP).CheckArcim(11,"7137||1",26)
ClassMethod CheckArcim(PPRowID, ArcimRowId, EpisodeID) As %String
{
	q:(PPRowID="")||(ArcimRowId="") ""
	s CurrentDate=+$h
	s CurrentTime=$p($h,",",2)
	
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s SUB=$o(^DHCDocPPP("PapmiDr",0,PatientID,PPRowID,""))
	Q:SUB="" ""
	s StageDr=$p(^DHCDocPPP(PPRowID,SUB),"^",18)
	Q:StageDr="" ""
	s PPFChildSub=$o(^DHCDocPPF(0,"PrjStageArcim",PPRowID,StageDr,ArcimRowId,""))
	Q:PPFChildSub="" ""
	s SttDate=$p(^DHCDocPPF(PPRowID,PPFChildSub),"^",1)
	s SttTime=$p(^DHCDocPPF(PPRowID,PPFChildSub),"^",2)
	Q:(SttDate'="")&&(SttDate>CurrentDate) "N"
	Q:(SttDate=CurrentDate)&&(SttTime>CurrentTime)&&(SttTime'="") "N"
	s EndDate=$p(^DHCDocPPF(PPRowID,PPFChildSub),"^",3) 
	s EndTime=$p(^DHCDocPPF(PPRowID,PPFChildSub),"^",4)
	Q:(EndDate'="")&&(EndDate<CurrentDate) "N"
	Q:(EndDate=CurrentDate)&&(EndTime<=CurrentTime)&&(EndTime'="") "N"
	s Num=+$p(^DHCDocPPF(PPRowID,PPFChildSub),"^",6)
	s PPFLimitEntryAfterNoFreeNum=$p(^DHCDocPPF(PPRowID,PPFChildSub),"^",7)
	Q "Y^"_Num_"^"_PPFLimitEntryAfterNoFreeNum
}

/// CTOR: QP
/// DATE: 2021-01-18
/// DESC: 复制免费医嘱设置
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.CFG.FindGCP).CopyFreeOrder("11","11||9",2,1)
ClassMethod CopyFreeOrder(PPRowId = "", ids = "", toStage = "", ExpStr = "")
{
	s mRtn=0
	s PList=##class(web.DHCBL.UDHCCommFunLibary).GetClassPropertyList("web.PilotProject.PPA.DHCDocPilotProFreeOrd")
	f i=1:1:$l(ids,",") {
		q:mRtn'=0
		s fid=$p(ids,",",i)	
		s cobj=##class(User.DHCDocPilotProFreeOrd).%OpenId(fid)
		s ArcimID=cobj.PPFItmMastDRGetObjectId()
		s hasFlag=..HasToArcim(PPRowId,ArcimID,toStage)
		continue:hasFlag=1
		s xml="<DHCDocPilotProFreeOrd>"
		f j=2:1:$l(PList,"^") {
			s name=$p(PList,"^",j)
			continue:(name="PPFItmMastDesc")||(name="PPFBlank")
			s xml=xml_"<"_name_">"
			s value=$ZOBJPROPERTY(cobj,name)
			i ($IsObject(value)) {
				s value=value.%Id()
			}
			i name="PPFPrjStage" {
				s value=toStage
			}
			
			s xml=xml_value_"</"_name_">"
		}
		s xml=xml_"</DHCDocPilotProFreeOrd>"
		s mRtn=##class(web.PilotProject.DHCDocPilotProject).SaveProFreeOrd(PPRowId,"",xml,ExpStr)
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-01-19
/// DESC: 判断某阶段内免费医嘱是否存在
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.CFG.FindGCP).CheckPilotCat("26","3950||1","11")
ClassMethod HasToArcim(PPRowId, ArcimID, toStage) As %String
{
	s mRtn=0
	i $d(^DHCDocPPF(0,"PrjStageArcim",PPRowId,toStage,ArcimID)) {
		s mRtn=1	
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-01-19
/// DESC: 得到某条免费医嘱信息
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.CFG.FindGCP).GetInfo("1",1)
ClassMethod GetInfo(ID, PPRowId) As web.PilotProject.PPA.DHCDocPilotProFreeOrd
{
	S MObj=##class(web.PilotProject.PPA.DHCDocPilotProFreeOrd).%New()
	//Q:ID="" MObj
	i ID'="" {
		S DObj=##class(User.DHCDocPilotProFreeOrd).%OpenId(ID)
		I '$ISObject(DObj) {
			Q MObj
		}
		S MObj.PPFSttDate=DObj.PPFSttDate
		i MObj.PPFSttDate'="" s MObj.PPFSttDate=##class(websys.Conversions).DateLogicalToHtml(MObj.PPFSttDate)
		S MObj.PPFSttTime=DObj.PPFSttTime
		i MObj.PPFSttTime'="" s MObj.PPFSttTime=$zt(MObj.PPFSttTime,1)
		S MObj.PPFEndDate=DObj.PPFEndDate
		i MObj.PPFEndDate'="" s MObj.PPFEndDate=##class(websys.Conversions).DateLogicalToHtml(MObj.PPFEndDate)
		S MObj.PPFEndTime=DObj.PPFEndTime
		i MObj.PPFEndTime'="" s MObj.PPFEndTime=$zt(MObj.PPFEndTime,1)
		S MObj.PPFItmMastDR=DObj.PPFItmMastDRGetObjectId()
		S ARC=+MObj.PPFItmMastDR,VER=$P(MObj.PPFItmMastDR,"||",2)
		S MObj.PPFItmMastDesc=$p(^ARCIM(ARC,VER,1),"^",2)
		S MObj.PPFFreeNum=DObj.PPFFreeNum
		S MObj.PPFLimitEntryAfterNoFreeNum=DObj.PPFLimitEntryAfterNoFreeNum
		S MObj.PPFPrjStage=DObj.PPFPrjStageGetObjectId()
	} else {
		Q:PPRowId="" MObj
		S DObj=##class(User.DHCDocPilotProject).%OpenId(PPRowId)
		i ((DObj.PPStartDate'="")||(DObj.PPEndDate'="")) {
			S MObj.PPFSttDate=##class(websys.Conversions).DateLogicalToHtml(DObj.PPStartDate)
			S MObj.PPFEndDate=##class(websys.Conversions).DateLogicalToHtml(DObj.PPEndDate)
		} else {
			S MObj.PPFSttDate="NULL"
			S MObj.PPFEndDate="NULL"
		}
		
	}
	Q MObj
}

/// CTOR: QP
/// DATE: 2021-02-20
/// DESC: 审核付款记录
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.CFG.FindGCP).CheckPilotCat("26","3950||1","11")
ClassMethod VerifyRem(PPRemId, State = "V") As %String
{
	Q:PPRemId="" 0
	&SQL(UPDATE SQLUser.DHC_DocPilotProRem SET PPR_State=:State WHERE PPR_RowId=:PPRemId)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2022-03-15
/// DESC: 一键复制免费医嘱
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.CFG.FindGCP).CopyAllFreeOrder("11","13^14^15",1)
ClassMethod CopyAllFreeOrder(FromPrj = "", ToPrj, ExpStr = "")
{
	s OK="1",NO="-1"
	;1 按阶段Code组织要Copy的记录串
	k TList
	s sub=0
	for {
		s sub=$o(^DHCDocPPF(FromPrj,sub))
		q:sub=""
		s id=FromPrj_"||"_sub
		s stage=$p(^DHCDocPPF(FromPrj,sub),"^",8)
		q:stage=""
		s stageCode=$p(^CF.DOC.Pilot.OEStageD(stage),"^",2)
		i '$d(TList(stageCode)) s TList(stageCode)=id
		e  s TList(stageCode)=TList(stageCode)_","_id
		
	}
	Q:$O(TList(""))="" OK_"^"
	;2 自动创建阶段
	TS
	s mRtn=0
	f j=1:1:$L(ToPrj,",") {
		s CPrj=$p(ToPrj,",",j)
		s mRtn=..CreateStageDic(CPrj,.TList)
		Q:mRtn<0
		
	}
	i mRtn<0 {
		TRO
		Q NO_"^自动创建阶段失败！"
	}
	;3 按阶段保存免费医嘱
	s Code=""
	s mRtn=0
	for {
		s Code=$o(TList(Code)) 
		q:(Code="")||(+mRtn<0)
		f k=1:1:$L(ToPrj,",") {
			Q:+mRtn<0
			s CPrj=$p(ToPrj,",",k)
			s StageDR=$O(^CF.DOC.Pilot.OEStageI("PrjCode",CPrj,Code,""))
			i StageDR="" {
				s mRtn="-101"
				Q
			}
			s ids=TList(Code)
			s mRtn=..CopyFreeOrder(CPrj,ids,StageDR,ExpStr)
		}
		
	}
	i +mRtn<0 {
		TRO
		Q "-1^保存免费医嘱失败！"	
	}
	TC
	
	Q OK_"^"
}

/// CTOR: QP
/// DATE: 2022-03-15
/// DESC: 自动创建阶段
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.CFG.FindGCP).CopyAllFreeOrder("11","12",2)
ClassMethod CreateStageDic(CPrj = "", ByRef TList)
{
	s Code=""
	s mRtn=0
	for {
		s Code=$o(TList(Code)) 
		q:(Code="")||(mRtn<0)
		i '$d(^CF.DOC.Pilot.OEStageI("PrjCode",CPrj,Code)) {
			// ^6^第6阶段^^11^1^
			s CodeDesc="第"_Code_"阶段"
			s mList="^"_Code_"^"_CodeDesc_"^^"_CPrj_"^1^"
			s mRtn=##class(web.PilotProject.Extend.Stage).SaveDic(mList)
			//zw ^CF.DOC.Pilot.OEStageI("PrjCode",CPrj,Code)
		}
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2022-12-06
/// DESC: 获取主要研究者和立项科室
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.CFG.FindGCP).CopyAllFreeOrder("11","12",2)
ClassMethod GetPI(PPRowId = "")
{
	s dynObj={"user":"","loc":""}
	Q:PPRowId="" dynObj.%ToJSON()
	s PPCreateDepartmentDr=$p(^DHCDocPP(PPRowId),"^",6)
	s PPStartUserDr=$p(^DHCDocPP(PPRowId),"^",10)
	do dynObj.%Set("user",PPStartUserDr)
	do dynObj.%Set("loc",PPCreateDepartmentDr)
	
	Q dynObj.%ToJSON()
}

}
