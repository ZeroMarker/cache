Class ABN.dao.DHCNurPatchTest Extends %RegisteredObject
{

Query FindByPatientID(PatientID, EpisodeID, StDate, EndDate, Flag) As websys.Query(ROWSPEC = "ID:%String:记录ID,Adm:%String,Name:%String:姓名,Diagnosis:%String:诊断,CheckDate:%String:检查日期,CheckUser:%String:检查人,CheckType:%String:检查类型Code,CheckTypeDesc:%String:检查类型,ApplyDoctor:%String:申请医生,ApplyDate:%String:申请日期")
{
}

ClassMethod FindByPatientIDExecute(ByRef qHandle As %Binary, PatientID, EpisodeID, StDate, EndDate, Flag) As %Status
{
		s ^Temp("wanghc","ABN.dao.DHCNurPatchTest","FindByPatientID")=PatientID_"^"_EpisodeID_","_StDate_","_EndDate_","_Flag
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		s:StDate="" StDate=$zd(+$h,4),EndDate=$zd(+$h,4)
		i ($l(StDate,"/")=3) s StDate = $zdh(StDate,4),EndDate=$zdh(EndDate,4)
		f cDate = StDate:1:EndDate d		
		.s ID=0 f  s ID= $O(^ABN.DHCNurPatchTestI("ApplyDate",cDate,ID)) q:ID=""  d
		..s obj=##class(ABN.DHCNurPatchTest).%OpenId(ID)
		..s Adm=obj.PAAdm
		..q:(EpisodeID'="")&&(Adm'=EpisodeID)
		..s Papmi = obj.PapmiID
		..q:(PatientID'="")&&(Papmi'=PatientID)
		..s Name =  $p(^PAPER(Papmi,"ALL"),"^",1)
		..s mradm=$P(^PAADM(Adm),"^",61)
		..s Diagnosis = ##class(web.DHCDocOutPatientList).GetMRAdmDiagnosis(mradm)
		..s CheckDate = obj.CheckDate
		..s:CheckDate'="" CheckDate=$zd(CheckDate,3)
		..s CheckUser = obj.CheckUser
		..s:CheckUser'="" CheckUser = $p(^SSU("SSUSR",CheckUser),"^",2)		
		..s CheckType = "Patch"		
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

ClassMethod SavePatch(reqJson)
{
	s ^Temp("JsonObject","Save","reqJson")=reqJson
	s $zt="ERROR"
	q:reqJson="" "-306^NullInparam"
	s jsonObj = ##class(ext.util.JsonObject).%New()
	s jsonObj.ContainNullValue=1	//删除属性值时用到	
	d jsonObj.FromObject(reqJson)
	d jsonObj.Put("CheckDate",$zd(+$h,3)).Put("CheckTime",$zt($p($h,",",2),1))	
	s obj = jsonObj.Bean("ABN.DHCNurPatchTest")	
	d jsonObj.%Close()
	s jsonObj=""
	s sc = obj.%Save()	
	If $$$ISERR(sc) Quit "-306^"_sc		
	s id = obj.%Id() 
	d obj.%Close()
	s obj = ""	
	q 0_"^"_id
ERROR 
	S ^Temp("JsonObject","ABN.DHCNurPatchTest","Save","Error")=$ze
	s $ze=""
	q "-1^SaveError!"
}

/// 病人ID,就诊ID, SSUser-RowId
ClassMethod CreatePatchBill(PatientID, EpisodeID, User)
{
	s TestId=""
	s TempTestId=""		
	f  s TempTestId = $o(^ABN.DHCNurPatchTestI("papmi"," "_PatientID,TempTestId)) q:TempTestId=""  d
	.s Obj = ##class(ABN.DHCNurPatchTest).%OpenId(TempTestId,0)
	.q:Obj.PAAdm'=EpisodeID
	.q:Obj.ApplyDate'=+$h					;跨天的, 新起一个单子
	.q:Obj.IsExec="Y"						;已置结果, 新起单子
	.d Obj.%Close()
	.s Obj=""	
	.s TestId=TempTestId
	
	i TestId="" d
	.s NewObj = ##class(ABN.DHCNurPatchTest).%New()
	.s NewObj.PapmiID = PatientID
	.s NewObj.PAAdm = EpisodeID	
	.s NewObj.ApplyDoctor = User
	.s NewObj.ApplyDate = +$h
	.s NewObj.ApplyTime = $p($h,",",2)	
	.s sc = NewObj.%Save()
	.s TestId = NewObj.%Id()
	.d NewObj.%Close()
	.s NewObj=""
	
	q TestId
}

/// w ##class(ABN.dao.DHCNurSkinTestRec).RunExecOrder(50,"",194,"ZLDO",3880)
/// 执行单子下的所有医嘱
ClassMethod RunExecOrder(SkinID, SeatNo, CtLocId, QueryTypeCode, userId)
{
	s ^Temp("wanghc","RunExecOrder")=SkinID_","_SeatNo_","_CtLocId_","_QueryTypeCode_","_userId
	q:SkinID="" "0^0"
	s SkinObj = ##class(ABN.DHCNurPatchTest).%OpenId(SkinID)
	s SkinObj.IsExec = "Y"
	d SkinObj.%Save()
	s sub=""
	f  s sub=$o(^ABN.DHCNurPatchTestD(SkinID,"ChildSub",sub)) q:sub=""  d
	.s obj = ##class(ABN.DHCNurPatchTestSub).%OpenId(SkinID_"||"_sub)
	.s OrdRowId = obj.OrdRowId
	.s rtn = ##class(ABN.dao.DHCDocAllergyInterface).RunExecOrdGroup(OrdRowId,SeatNo,CtLocId,QueryTypeCode,userId)
	q 0_"^"_SkinID
}

/// w ##class(ABN.dao.DHCNurSkinTestRec).RunExecOrder(50,"",194,"ZLDO",3880)
/// 执行单子下的所有医嘱
ClassMethod CancelExecOrder(SkinID, userId)
{
	s sub=""
	f  s sub=$o(^ABN.DHCNurSkinTestRecD(SkinID,"ChildSub",sub)) q:sub=""  d
	.d ##class(ABN.dao.DHCNurPatchTestSub).CancelExecOrder(SkinID_"||"_sub,userId)
	q 0_"^"_SkinID
}

}
