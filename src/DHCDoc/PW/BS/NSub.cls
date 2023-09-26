/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 医生站交班本业务类
Class DHCDoc.PW.BS.NSub Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 保存明细
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).Save("","1^1")
ClassMethod Save(ID, NID, InAdd, InEdit, InTypeEdit) As %String
{
	s CDate=+$h
	s CTime=$P($H,",",2)
	i ID = "" {
		s LocID=$P(InAdd,$C(1),1)
		s UserID=$P(InAdd,$C(1),2)
		s AdmID=$P(InAdd,$C(1),3)
		s BCDate=$P(InAdd,$C(1),4)
		s PType=$P(InAdd,$C(1),5)
		s mRtn=##class(DHCDoc.PW.BS.NSub).HasAdd(NID,AdmID)
		i mRtn'="" {
			s SID=mRtn
		} else {
			s SaveOBJ = ##class(User.DHCDocPassWorkNSub).%New(NID)
			d SaveOBJ.SParRefSetObjectId(NID)
			d SaveOBJ.SFUserSetObjectId(UserID)
			d SaveOBJ.SAddUserSetObjectId(UserID)
			d SaveOBJ.SAdmIDSetObjectId(AdmID)
			d SaveOBJ.SLocIDSetObjectId(LocID)
			s SaveOBJ.SAddDate=CDate
			s SaveOBJ.SAddTime=CTime
			s SaveOBJ.SFDate=CDate
			S SaveOBJ.SFTime=CTime
			i '$d(^||BS.PW.NSub.Sync("HasSubmit",AdmID)) {
				s BCDate=##class(websys.Conversions).DateHtmlToLogical(BCDate)
				s SaveOBJ.SBCDate=BCDate
			} else {
				s MDATA=$G(^||BS.PW.NSub.Sync("HasSubmit",AdmID))
				s SaveOBJ.SBCDate=$lg(MDATA,5)
				s SaveOBJ.SSubmitDate=$lg(MDATA,6)
				s SaveOBJ.SSubmitTime=$lg(MDATA,7)
				d SaveOBJ.SSubmitUserSetObjectId($lg(MDATA,8))
				s SaveOBJ.SContent=$lg(MDATA,9)
				s SaveOBJ.SAcceptDate=$lg(MDATA,10)
				s SaveOBJ.SAcceptTime=$lg(MDATA,11)
				d SaveOBJ.SAccpetUserSetObjectId($lg(MDATA,12))
				s SaveOBJ.SAcceptContent=$lg(MDATA,13)
			}
			s sc = SaveOBJ.%Save()
			If $$$ISERR(sc) {
				d $system.OBJ.DisplayError(sc) 
				Quit "-1^保存明细失败！"
			}
			s SID=SaveOBJ.%Id()
		}
		s InPara=AdmID_"^"_LocID_"^"_PType_"^"_BCDate
		s mRtn=##class(DHCDoc.PW.BS.NSubType).Save("",SID,InPara)
		i +mRtn'=1 {
			Quit "-1^保存类型失败！"
		}
		s mRtn=##class(DHCDoc.PW.BS.NSubExt).Save("",NID,SID,"","Add")
		i +mRtn'=1 {
			Quit "-1^保存明细扩展失败！"
		}
		Q 1_"^"
	} else {
		s SaveOBJ = ##class(User.DHCDocPassWorkNSub).%OpenId(ID)
		if (InEdit'="") { 
			s UserID=$P(InEdit,$C(1),1)
			s SubmitNote=$P(InEdit,$C(1),2)
			s AccpetNote=$P(InEdit,$C(1),3)
			s AccpetUserID=$P(InEdit,$C(1),4)
			d SaveOBJ.SFUserSetObjectId(UserID)
			d SaveOBJ.SSubmitUserSetObjectId(UserID)
			d SaveOBJ.SAccpetUserSetObjectId(AccpetUserID)
			s SaveOBJ.SContent=SubmitNote
			S SaveOBJ.SAcceptContent=AccpetNote
			S SaveOBJ.SFDate=CDate
			S SaveOBJ.SFTime=CTime
		}
		if (InTypeEdit'="") {
			
		}
		s sc = SaveOBJ.%Save()
		If $$$ISERR(sc) {
			Quit "-1^保存明细失败！"
		}
		Q 1_"^"
	}
	
	Q 1_"^"
}

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 添加患者
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).AddPat("8","0000000115^OutHospNum^2021-07-16^D^113^12175")
ClassMethod AddPat(NID, InAdd, InHosp) As %String
{
	s ^QP("AddPat")=$LB(NID,InAdd,InHosp)
	s PatNo=$p(InAdd,"^",1)
	s PTypeS=$p(InAdd,"^",2)
	s BCDate=$p(InAdd,"^",3)
	s BCCode=$p(InAdd,"^",4)
	s LocID=$p(InAdd,"^",5)
	s UserID=$p(InAdd,"^",6)
	s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocID)
	s AdmID=##class(DHCDoc.PW.COM.Method).GetAdmIdByPatNo(PatNo)
	Q:AdmID="" "-1^无法获取该病人的就诊信息!"
	s SelfHosp=##class(DHCDoc.PW.COM.Method).IsSelfHospPatient(PatNo,InHosp)
	Q:SelfHosp=0 "-1^不能添加非本院患者!"
	s HasID=##class(DHCDoc.PW.BS.NSub).HasAdd(NID,AdmID)
	Q:HasID'="" "-1^该患者已经存在班次中!"
	TS
	f i=1:1:$l(PTypeS,",") {
		s PType=$P(PTypeS,",",i)
		s InAdd=LocID_$C(1)_UserID_$C(1)_AdmID_$C(1)_BCDate_$C(1)_PType
		s mRtn=##class(DHCDoc.PW.BS.NSub).Save("",NID,InAdd)
		i +mRtn<0 {
			Q
		}
	}
	i +mRtn<0 {
		TRO
		Q mRtn
	}
	s NewXML=""
	i HasID="" {
		//新增
		s NewXML=##class(DHCDoc.PW.BS.NMain).OperateXML(NID,PTypeS,"+",1)
	} else {
		s PTypeOld=##class(DHCDoc.PW.BS.NSub).GetPType(HasID,AdmID,MID)
		s AddStr=##class(DHCDoc.PW.COM.Method).HasNoNums(PTypeS,PTypeOld)
		s DelStr=##class(DHCDoc.PW.COM.Method).HasNoNums(PTypeOld,PTypeS)
		s ADDXML=##class(DHCDoc.PW.BS.NMain).OperateXML(NID,AddStr,"+",1)
		s NewXML=##class(DHCDoc.PW.BS.NMain).OperateXML(NID,DelStr,"-",1,ADDXML)
	}
	i NewXML'="" {
		s rtn=##class(DHCDoc.PW.BS.NMain).UpdateXML(NID,NewXML)
		i rtn'=0 {
			TRO
			Q "-1^更新XML失败！"
		}
	}
	
	TC
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 修改患者
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).EditPat("1||421","InWardNum,OperNum,SeverityNum^2021-07-14^113^12175")
ClassMethod EditPat(SID, InTypeEdit) As %String
{
	s ^QP("EditPat")=$lb(SID, InTypeEdit)
	s PTypeS=$p(InTypeEdit,"^",1)
	s BCDate=$p(InTypeEdit,"^",2)
	s LocID=$p(InTypeEdit,"^",3)
	s UserID=$p(InTypeEdit,"^",4)
	s NID=+SID,SUB=$P(SID,"||",2)
	s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocID)
	s AdmID=$lg(^User.DHCDocPassWorkNMainD(NID,"ChildSub",SUB),3)
	Q:AdmID="" "-1^无法获取该病人的就诊信息!"
	s PTypeOld=##class(DHCDoc.PW.BS.NSub).GetPType(SID,AdmID,MID)
	d ##class(DHCDoc.PW.COM.Method).ToList(PTypeOld,.PTOldList)
	TS
	
	s AddStr=##class(DHCDoc.PW.COM.Method).HasNoNums(PTypeS,PTypeOld)
	s DelStr=##class(DHCDoc.PW.COM.Method).HasNoNums(PTypeOld,PTypeS)
	
	s ADDXML=##class(DHCDoc.PW.BS.NMain).OperateXML(NID,AddStr,"+",1)
	s NewXML=##class(DHCDoc.PW.BS.NMain).OperateXML(NID,DelStr,"-",1,ADDXML)
	s rtn=##class(DHCDoc.PW.BS.NMain).UpdateXML(NID,NewXML)
	i rtn'=0 {
		TRO
		Q "-1^更新XML失败！"
	}
	;删除的
	i DelStr'="" {
		s mRtn=0
		f i=1:1:$l(DelStr,",") {
			s Code=$p(DelStr,",",i)
			s mRtn=##class(DHCDoc.PW.BS.NSubType).DeleteByCode(SID,Code)
			Q:mRtn'=0
		}
		i mRtn'=0 {
			TRO
			Q "-1^修改过程中，删除之前的类型失败！"	
		}
	}
	;新增的
	i AddStr'="" {
		f i=1:1:$l(AddStr,",") {
			s Code=$p(AddStr,",",i)
			s InPara=AdmID_"^"_LocID_"^"_Code_"^"_BCDate
			s mRtn=##class(DHCDoc.PW.BS.NSubType).Save("", SID, InPara)
			Q:+mRtn<0
		}
		i +mRtn<0 {
			TRO
			Q "-1^修改过程中，保存新增的类型失败！"	
		}
	}
	
	TC
	Q 1_"^"
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 是否已经添加过患者
/// IN  : 
/// OUT : 返回ID
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).HasAdd("1","164")
ClassMethod HasAdd(NID, AdmID) As %String
{
	s mRtn=""
	Q:'$d(^User.DHCDocPassWorkNSubI("SAdmID",AdmID,NID)) mRtn
	s sub=$o(^User.DHCDocPassWorkNSubI("SAdmID",AdmID,NID,""))
	Q:sub="" mRtn
	s mRtn=NID_"||"_sub
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 判断能否添加
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).IsAdd("","1^1")
ClassMethod IsAdd(NID, AdmID) As %String
{
	s AdmID=$P(InPara,"^",1)
	s Type=$P(InPara,"^",3)
	
	i ID="" {
		i $d(^User.DHCDocPassWorkNSubTypeI("TAdmType",AdmID,Type)) {
			Q "-1^类型已存在！"
		}
	} else {
		s NID=$p(SID,"||",1)
		s sub=$p(SID,"||",2)
		s oldLoc=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildLoc",sub),2)
		i $d(^User.DHCDocPassWorkBCLocI("BLLoc",LocID,MID)) {
			i oldLoc'=LocID {
				Q "-1^类型已存在！"
			}
		}
	}
	
	Q 0
}

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 保存明细
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).SavePWSub("","1^1")
ClassMethod SavePWSub(NID, LocId, BCDate, InBCCode, UserID) As %String
{
	s rtn=1
	s PType=""
	f  s PType=$o(^||BS.PW.NMain("RealCount",LocId,BCDate,InBCCode,PType)) q:(PType="")||(rtn'=1)  d
	.s EpisodeID=""
	.f  s EpisodeID=$o(^||BS.PW.NMain("RealCount",LocId,BCDate,InBCCode,PType,EpisodeID)) q:(EpisodeID="")||(rtn'=1)  d
	..s InAdd=LocId_$C(1)_UserID_$C(1)_EpisodeID_$C(1)_BCDate_$C(1)_PType
	..s rtn=..Save("",NID,InAdd,"")
	..s rtn=+rtn
	..q:rtn'=1 
	Q rtn
}

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 获取病人对应的类型
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).GetPType("1||589","1")
ClassMethod GetPType(SID, AdmID, MID) As %String
{
	s mRtn=""
	Q:SID=""||AdmID="" mRtn
	s NID=+SID,SUB=$P(SID,"||",2)
	s Type=""
	f  s Type=$o(^User.DHCDocPassWorkNSubTypeI("TAdmType",AdmID,Type)) Q:Type=""  d
	.q:'$d(^User.DHCDocPassWorkNSubTypeI("TAdmType",AdmID,Type,NID,SUB))
	.q:##class(DHCDoc.PW.CFG.BCPatType).IsHiddenByCode(MID,Type)=0
	.i mRtn="" s mRtn=Type
	.e  s mRtn=mRtn_","_Type
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 获取病人对应的类型
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).GetPTypeBySID("2||612")
ClassMethod GetPTypeBySID(SID) As %String
{
	s mRtn=""
	Q:SID="" mRtn
	S NID=+SID,SUB=$P(SID,"||",2)
	s Type=""
	f  s Type=$o(^User.DHCDocPassWorkNSubTypeI("TType",Type)) Q:Type=""  d
	.q:'$d(^User.DHCDocPassWorkNSubTypeI("TType",Type,NID,SUB))
	.i mRtn="" s mRtn=Type
	.e  s mRtn=mRtn_","_Type
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 获取病人对应的类型描述
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).GetPTypeDesc("","1^1")
ClassMethod GetPTypeDesc(PType, MID) As %String
{
	s mRtn=""
	s langid=##class(DHCDoc.PW.COM.Method).%LanguageID()
	Q:PType="" mRtn
	f i=1:1:$l(PType,",") {
		s type=$p(PType,",",i)
		continue:##class(DHCDoc.PW.CFG.BCPatType).IsHiddenByCode(MID,type)=0
		s desc=##class(DHCDoc.PW.CFG.BCPatType).GetDescByCode(MID,type)
		s desc= ##class(User.DHCDocPassWorkBCPatType).GetTranByDesc("BPDesc",desc,langid)
		continue:desc=""
		i mRtn="" s mRtn=desc
		e  s mRtn=mRtn_","_desc
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 修改交班内容
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).EditPWContent("1","OutWardNum^2^110^^这是一个测试^4634^")
ClassMethod EditPWContent(UserId = "", SID, BCNote, AcceptNote) As %String
{
	s mRtn=0
	Q:(SID="")||(UserId="") "-1^参数为空"
	//s BCNote=$replace(BCNote,"^","")
	//s tempFlag=..EnableEdit(UserId,+ItemId)
	//q:tempFlag'=1 "-103"
	s CurDate=$p($h,",",1),CurTime=$p($h,",",2)
	&SQL(UPDATE SQLUser.DHCDocPassWorkNSub(S_Content,S_SubmitUser,S_SubmitDate,S_SubmitTime,S_FDate,S_FTime,S_FUser,S_AcceptContent,S_AccpetUser,S_AcceptDate,S_AcceptTime) 
				VALUES(:BCNote,:UserId,:CurDate,:CurTime,:CurDate,:CurTime,:UserId,:AcceptNote,:UserId,:CurDate,:CurTime)
				WHERE ID=:SID)
	i SQLCODE {
		Q "-1^保存失败，SQLCODE为："_SQLCODE
	}
	
	Q 1_"^"
}

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 查询项目明细
/// IN  : 
/// OUT : 
/// TABL: DHC_DocPassWorkBcs
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.BS.NSub","ItemSubQry","","2021-09-08","113","12175","D","PreSum","")
Query ItemSubQry(NID = "", BCDate, LocId, UserId, InBCCode, InPType = "", InPatNo = "", InExt = "", InNoType = "") As %Library.Query(ROWSPEC = "SID,EpisodeID,PType,PatName,PatNo,PatSex,PatAge,AdmDocDesc,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,SubmitContent,SubmitUser,AcceptContent,FillFlag,EZLPlan,EQuestion,EMainAction") [ SqlProc ]
{
}

ClassMethod ItemSubQryExecute(ByRef qHandle As %Library.Binary, NID = "", BCDate, LocId, UserId, InBCCode, InPType = "", InPatNo = "", InExt = "", InNoType = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//s ^QP("ItemSubQry")=$LB(NID, BCDate, LocId, UserId, InBCCode, InPType,InPatNo)
	s langid=##class(DHCDoc.PW.COM.Method).%LanguageID()
	s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocId)
	s FoldBC=##class(DHCDoc.PW.CFG.BCRule).GetRuleValue(LocId,"FoldBC")
	s BCDate=##class(websys.Conversions).DateHtmlToLogical(BCDate)
	s IsSelf=$p(InExt,$C(1),1)	//1是本科室，0是本人
	s InFillFlag=$p(InExt,$C(1),2)	//填写标志
	i IsSelf="" s IsSelf=1
	i NID="" {
		s CTime=$p($h,",",2)
		d ##class(DHCDoc.PW.BS.DataFunc).GetLocItemSummary(LocId, BCDate, BCDate, CTime, "", UserId, InBCCode,.DList)
		s CType=""
		f  s CType=$o(^||BS.PW.NMain("RealCount",LocId,BCDate,InBCCode,CType)) q:CType=""  d
		.;q:(InPType'="")&&(InPType'=CType)
		.q:..ContainPType(InPType,CType)=1
		.q:..FilterNoPType(InNoType,CType)=1
		.s PType=..GetPTypeDesc(CType,MID)
		.q:PType=""
		.s EpisodeID=""
		.f  s EpisodeID=$o(^||BS.PW.NMain("RealCount",LocId,BCDate,InBCCode,CType,EpisodeID)) q:EpisodeID=""  d
		..s SID="",sub=""
		..d OuputRow1
	} else {
		s sub=""
		f  s sub=$o(^User.DHCDocPassWorkNMainD(NID,"ChildSub",sub)) Q:sub=""  d
		.s EpisodeID=$lg(^User.DHCDocPassWorkNMainD(NID,"ChildSub",sub),3)
		.s SID=NID_"||"_sub
		.i FoldBC=1 d	;展开
		..s CHL=""
		..f  s CHL=$O(^User.DHCDocPassWorkNMainD(NID,"ChildSub",sub,"ChildType",CHL)) Q:CHL=""  D
		...S PType=$lg(^User.DHCDocPassWorkNMainD(NID,"ChildSub",sub,"ChildType",CHL),3)
		...Q:##class(DHCDoc.PW.CFG.BCPatType).IsHiddenByCode(MID,PType)=0
		...;Q:(InPType'="")&&(PType'[InPType)
		...q:..ContainPType(InPType,PType)=1
		...q:..FilterNoPType(InNoType,PType)=1
		...s PType=..GetPTypeDesc(PType,MID)
		...q:PType=""
		...d OuputRow1
		.e  d		;合并
		..s PType=..GetPType(SID,EpisodeID,MID)
		..;Q:(InPType'="")&&(PType'[InPType)
		..Q:..ContainPType(InPType,PType)=1
		..Q:..FilterNoPType(InNoType,PType)=1
		..s PType=..GetPTypeDesc(PType,MID)
		..q:PType=""
		..d OuputRow1
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	s AdmDocId=$p(^PAADM(EpisodeID),"^",9)
	s uid=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(AdmDocId)
	q:(IsSelf=0)&&(uid'=UserId)
	s PatWard=$p(^PAADM(EpisodeID),"^",70)
	i PatWard'="" s PatWard=$p(^PAWARD(PatWard),"^",5)
	;q:(FindWard'="")&&(FindWard'=PatWard)
	i PatWard'="" s PatWardDesc=$p(^CTLOC(PatWard),"^",2)
	s AdmDocDesc=""
	i +AdmDocId'=0 s AdmDocDesc=$p(^CTPCP(AdmDocId,1),"^",2)
	s AdmDocDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",AdmDocDesc,langid)
	;q:(USERCareID'="")&&(AdmDocId'=USERCareID)
	;s PatWorkTypeDesc=$p(^CF.OPDoc.PW("WKType",PatWorkType),"^",1)
	;s isNeedDisplay=$p(^CF.OPDoc.PW("WKType",PatWorkType),"^",2)
	;q:isNeedDisplay'=1
	;s PatInfo=##class(web.DHCDocPassWork).GetPatInfo(EpisodeID)
	s PatInfo=##class(DHCDoc.PW.COM.Method).GetPatInfo(EpisodeID)
	s PatNo=$p(PatInfo,"^",2)
	q:(InPatNo'="")&&(InPatNo'=PatNo)
	s PatName=$p(PatInfo,"^",3)
	s PatSex=$p(PatInfo,"^",4)
	s PatSex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PatSex,langid)
	s PatAge=$p(PatInfo,"^",5)
	s PatDiagnos=$p(PatInfo,"^",9)
	s PatOperName=##class(DHCDoc.PW.COM.Method).GetOperNameByAdmid(EpisodeID)
	s PatMedicareNo=$p(PatInfo,"^",6)
	s CurBedCode=$p(PatInfo,"^",14)
	s FillFlag=0,SubmitContent="",AcceptContent=""
	s SubmitUser="",AcceptUser=""
	i SID'="" {
		s SubmitContent=$lg(^User.DHCDocPassWorkNMainD(NID,"ChildSub",sub),9)
		s AcceptContent=$lg(^User.DHCDocPassWorkNMainD(NID,"ChildSub",sub),13)
		i SubmitContent'="" s FillFlag=1
		e  s FillFlag=2
	}
	q:(InFillFlag'="")&&(InFillFlag'=FillFlag)
		
	s EZLPlan="",EQuestion="",EMainAction=""
	s EID=##class(DHCDoc.PW.BS.NSubExt).GetEID(SID)
	;扩展
	i EID'="" {
		s EZLPlan=$lg(^User.DHCDocPassWorkNSubExtD(EID),4)
		s EQuestion=$lg(^User.DHCDocPassWorkNSubExtD(EID),5)
		s EMainAction=$lg(^User.DHCDocPassWorkNSubExtD(EID),6)
	}
	set Data=$lb(SID,EpisodeID,PType,PatName,PatNo,PatSex,PatAge,AdmDocDesc,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,SubmitContent,SubmitUser,AcceptContent,FillFlag,EZLPlan,EQuestion,EMainAction)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod ItemSubQryFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ItemSubQryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod ItemSubQryClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ItemSubQryFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-08-31
/// DESC: 过滤类型:CTypeStr是否包含InPType/InPType是否在CTypeStr中
/// IN  :
/// OUT : 1过滤/0不过滤
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).ContainPType("N,M","D,K")
ClassMethod ContainPType(InPType, CTypeStr) As %String
{
	Q:InPType="" 0
	Q:CTypeStr="" 1
	
	s mRtn=1
	f i=1:1:$l(CTypeStr,",") {
		Q:mRtn=0
		s CType=$p(CTypeStr,",",i)
		;包含:包含一个就退出
		f j=1:1:$l(InPType,",") {
			Q:mRtn=0
			s mt=$p(InPType,",",j)
			i CType=mt {
				s mRtn=0
				Q
			}
		}
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-08-31
/// DESC: 过滤类型: CTypeStr是否包含InNoType/InNoType是否在CTypeStr中
/// IN  : 
/// OUT : 1过滤/0不过滤
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).FilterNoPType("N,M","D,K")
ClassMethod FilterNoPType(InNoType, CTypeStr) As %String
{
	Q:InNoType="" 0
	Q:CTypeStr="" 1
	
	s mRtn=0
	f i=1:1:$l(CTypeStr,",") {
		Q:mRtn=1
		s CType=$p(CTypeStr,",",i)
		;不包含:只要有一个就退出
		f k=1:1:$l(InNoType,",") {
			Q:mRtn=1
			s kt=$p(InNoType,",",k)
			i CType=kt {
				s mRtn=1
				Q
			}
		}
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-08-31
/// DESC: 单独处理：现有和出院。
/// IN  : 
/// OUT : 0成功，失败
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).NowAndOutData("N,M","D,K")
ClassMethod NowAndOutData(NID) As %String
{
	Q:NID="" 0  
	
	K NList,FList
	s PTypeStr="OutHospNum,NowSum"
	f i=1:1:$l(PTypeStr,",") {
		s PType=$p(PTypeStr,",",i)
		s SUB=""
		f  s SUB=$O(^User.DHCDocPassWorkNSubTypeI("TType",PType,NID,SUB)) Q:SUB=""  D
		.s SID=NID_"||"_SUB
		.s CH=$O(^User.DHCDocPassWorkNSubTypeI("TType",PType,NID,SUB,""))
		.Q:CH=""
		.s NList(SID,PType)=SID_"||"_CH
	}
	s SID="",FNum=0
	f  s SID=$o(NList(SID)) Q:SID=""  D
	.s PType="",num=0
	.f  s PType=$o(NList(SID,PType)) Q:PType=""  D
	..s num=num+1
	.q:num'=2
	.s FNum=FNum+1
	.s FList(SID)=NList(SID,"NowSum")
	
	i FNum>0 {
		s NewXML=##class(DHCDoc.PW.BS.NMain).OperateXML(NID,"NowSum","-",FNum)
		&SQL(UPDATE SQLUser.DHCDocPassWorkNMain SET M_XML=:NewXML WHERE ID=:NID)
		Q:SQLCODE'=0 "-1"
		s SID=""
		s mRtn=0
		for {
			s SID=$o(FList(SID))
			q:(SID="")||(mRtn'=0)
			s ID=FList(SID)
			&SQL(DELETE FROM SQLUser.DHCDocPassWorkNSubType WHERE ID=:ID)
			B ;002
			i SQLCODE'=0 {
				s mRtn="-1"
				q	
			}
		}
		Q mRtn
	
	}
	Q 0
}

/// CTOR: QP
/// DATE: 2021-09-07
/// DESC: 得到有交班的记录
/// IN  : 
/// OUT : >=0成功，其余失败
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).GetHasSubmitRecord(1)
ClassMethod GetHasSubmitRecord(NID) As %String
{
	Q:NID="" "-1^参数为空！" 
	K ^||BS.PW.NSub.Sync("HasSubmit")
	S SUB="",Count=0
	f  s SUB=$O(^User.DHCDocPassWorkNMainD(NID,"ChildSub",SUB)) Q:SUB=""  D
	.s CDATA=^User.DHCDocPassWorkNMainD(NID,"ChildSub",SUB)
	.s SubmitContent=$lg(CDATA,9)
	.s AdmID=$lg(CDATA,3)
	.q:SubmitContent=""
	.s SID=NID_"||"_SUB
	.s Count=Count+1
	.s ^||BS.PW.NSub.Sync("HasSubmit",AdmID)=CDATA
	.s EID=##class(DHCDoc.PW.BS.NSubExt).GetEID(SID)
	.i EID'="" D
	..s EDATA=$g(^User.DHCDocPassWorkNSubExtD(EID))
	..s ^||BS.PW.NSub.Sync("HasSubmit",AdmID,"Ext")=EDATA
	
	
	Q Count
}

/// CTOR: QP
/// DATE: 2021-09-07
/// DESC: 删除Sub记录
/// IN  : 
/// OUT : =0成功，其余失败
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).DeleteNSub(1)
ClassMethod DeleteNSub(NID) As %String
{
	Q:NID="" "-1^参数为空！" 
	&SQL(DELETE FROM SQLUser.DHCDocPassWorkNSub WHERE S_ParRef=:NID)
	Q:SQLCODE'=0 "-1^删除子表记录失败！"
	
	Q SQLCODE
}

}
