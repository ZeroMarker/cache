/// ABN.DHCNurSkinTestRec表的操作类
Class ABN.dao.DHCNurSkinTestRec Extends %RegisteredObject
{

Query FindByPatientID(PatientID, EpisodeID, StDate, EndDate, Flag) As websys.Query(ROWSPEC = "ID:%String:记录ID,Adm:%String,Name:%String:姓名,Diagnosis:%String:诊断,CheckDate:%String:检查日期,CheckUser:%String:检查人,CheckType:%String:检查类型Code,CheckTypeDesc:%String:检查类型,ApplyDoctor:%String:申请医生,ApplyDate:%String:申请日期")
{
}

ClassMethod FindByPatientIDExecute(ByRef qHandle As %Binary, PatientID, EpisodeID, StDate, EndDate, Flag) As %Status
{
		s ^Temp("ABN.dao.DHCNurSkinTestRec","FindByPatientID")=PatientID_"^"_EpisodeID_","_StDate_","_EndDate_","_Flag
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		s:StDate="" StDate=$zd(+$h,4),EndDate=$zd(+$h,4)
		i ($l(StDate,"/")=3) s StDate = $zdh(StDate,4),EndDate=$zdh(EndDate,4)
	
		F cDate = StDate:1:EndDate d		
		.s ID=0 f  s ID= $O(^ABN.DHCNurSkinTestRecI("ApplyDate",cDate,ID)) q:ID=""  d
		..s sub = $o(^ABN.DHCNurSkinTestRecD(ID,"ChildSub",""))
		..s obj = ##class(ABN.DHCNurSkinTestRec).%OpenId(ID)
		..s Adm = obj.PAAdm
		..q:(EpisodeID'="")&&(Adm'=EpisodeID)
		..s Papmi = obj.PapmiID
		..q:(PatientID'="")&&(Papmi'=PatientID)
		..s Name =  $p(^PAPER(Papmi,"ALL"),"^",1)
		..s mradm=$P(^PAADM(Adm),"^",61)
		..s Diagnosis=##class(web.DHCDocOutPatientList).GetMRAdmDiagnosis(mradm)
		..s subObj = ##class(ABN.DHCNurSkinTestRecSub).%OpenId(ID_"||"_sub)
		..s CheckDate = obj.CheckDate
		..s:CheckDate'="" CheckDate=$zd(CheckDate,3)
		..s CheckUser = obj.CheckUser
		..s:CheckUser'="" CheckUser = $p(^SSU("SSUSR",CheckUser),"^",2)
		..s CheckType = "Skin"		
		..s CheckTypeDesc = obj.GetDesc()
		..s ApplyDoctor = obj.ApplyDoctor
		..s:ApplyDoctor'="" ApplyDoctor = $p(^SSU("SSUSR",ApplyDoctor),"^",2)
		..s ApplyDate = obj.ApplyDate
		..s:ApplyDate'="" ApplyDate = $zd(ApplyDate,3)
		..s ind = ind+1
		..s ^CacheTemp(repid,ind) = $lb(ID,Adm,Name,Diagnosis,CheckDate,CheckUser,CheckType,CheckTypeDesc,ApplyDoctor,ApplyDate)
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

/// 病人ID,就诊ID,测试类型(S|P)
/// w ##class(ABN.dao.DHCDocAllergyInterface).CreateSkinBill(5105755,5788,"P")
ClassMethod CreateSkinBill(PatientID, EpisodeID, SkinTestType, User)
{
	s TestId=""
	s TempTestId=""		
	f  s TempTestId = $o(^ABN.DHCNurSkinTestRecI("papmiPaadm"," "_PatientID," "_EpisodeID,TempTestId)) q:TempTestId=""  d
	.s Obj = ##class(ABN.DHCNurSkinTestRec).%OpenId(TempTestId,0)
	.q:Obj.SkinTestType'=SkinTestType		;不同类型,新起单子
	.q:Obj.ApplyDate'=+$h					;跨天的,  新起单子
	.q:Obj.IsExec="Y" 						;已执行,  新起单子
	.d Obj.%Close()
	.s Obj=""
	.s TestId=TempTestId		
	
	i TestId="" d
	.s NewObj = ##class(ABN.DHCNurSkinTestRec).%New()
	.s NewObj.PapmiID = PatientID
	.s NewObj.PAAdm = EpisodeID	
	.s NewObj.SkinTestType = SkinTestType	;Skin,Prick,LabSigE	医嘱的用法
	.s NewObj.ApplyDoctor = User
	.s NewObj.ApplyDate = +$h
	.s NewObj.ApplyTime = $p($h,",",2)	
	.s sc = NewObj.%Save()
	.s TestId = NewObj.%Id()
	.d NewObj.%Close()
	
	q TestId
}

/// w ##class(ABN.dao.DHCNurSkinTestRec).RunExecOrder(50,"",194,"ZLDO",3880)
/// 执行单子下的所有医嘱
ClassMethod RunExecOrder(SkinID, SeatNo, CtLocId, QueryTypeCode, userId)
{
	s ^Temp("wanghc","RunExecOrder")=SkinID_","_SeatNo_","_CtLocId_","_QueryTypeCode_","_userId
	s SkinObj = ##class(ABN.DHCNurSkinTestRec).%OpenId(SkinID)
	s SkinObj.IsExec="Y"
	d SkinObj.%Save()
	s sub=""
	f  s sub=$o(^ABN.DHCNurSkinTestRecD(SkinID,"ChildSub",sub)) q:sub=""  d
	.s obj = ##class(ABN.DHCNurSkinTestRecSub).%OpenId(SkinID_"||"_sub)
	.s OrdRowId = obj.OrdRowId
	.s rtn = ##class(ABN.dao.DHCDocAllergyInterface).RunExecOrdGroup(OrdRowId,SeatNo,CtLocId,QueryTypeCode,userId)
	
	q 0_"^"_SkinID
}

/// w ##class(ABN.dao.DHCNurSkinTestRec).RunExecOrder(50,"",194,"ZLDO",3880)
/// 撤销执行单子下的所有医嘱
ClassMethod CancelExecOrder(SkinID, userId)
{
	s sub=""
	f  s sub=$o(^ABN.DHCNurSkinTestRecD(SkinID,"ChildSub",sub)) q:sub=""  d
	.d ##class(ABN.dao.DHCNurSkinTestRecSub).CancelExecOrder(SkinID_"||"_sub,userId)
	q 0_"^"_SkinID
}

}
