Import sqluser

/// Creator: 	qqa
/// CreateDate: 2018-07-10
/// Descript: 	会诊明细
Class web.DHCEMFindConsult Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCEMFindConsult).GetConsultList(12,1,"^^^^")
ClassMethod GetConsultList(rows, page, Params)
{
	n (rows,page,Params,%session)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	i StartDate="" s StartDate=+$H-7   //为空默认查七天
    i EndDate="" s EndDate=+$H
	s ICstRLocID=$p(Params,"^",3) /// 申请科室
	s ICstLocID=$p(Params,"^",4)  /// 会诊科室
	s ICstLocDesc=""
	s:ICstLocID'="" ICstLocDesc = $p(^CTLOC(ICstLocID),"^",2)
	s ICstStatusID=$p(Params,"^",5)  /// 会诊状态
	i ICstStatusID'="" s ICstStatusID=$p($g(^DHCEMCONS(+ICstStatusID)),"^",2)
	s UserID = $p(Params,"^",6)  /// 当前用户ID
	s OverTime = $p(Params,"^",7)  /// 超时
	s LgHospID= $p(Params,"^",8)
	s ConsNature=$p(Params,"^",9)   //会诊性质
	s PatNameHtml=$p(Params,"^",10) //患者姓名检索
	s PatNoHtml=$p(Params,"^",11)   //登记号检索
	s TypeHtml=$p(Params,"^",12)    //会诊类型检索
	s DOCAHtml=$p(Params,"^",13)     //特抗
	s DOCAResHtml=$p(Params,"^",14)  //同意用药
	s AdmTypeOEI=$p(Params,"^",15)   //OEI

	k ^TMP("DHCEM","web.DHCEMFindConsult","GetConsultList",+UserID)
	s Count=0
	k TMPListData
	F dd=StartDate:1:EndDate D
	.s CstID=0
	.F  s CstID=$o(^DHCEMCON(0,"ReqDateIndex",dd,CstID)) Q:CstID=""  D
	..s EpisodeID=$p(^DHCEMCON(CstID),"^",1)		/// 就诊ID
	..q:'$d(^PAADM(EpisodeID))
	..s AdmHospID=##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
	..q:(AdmHospID'=LgHospID)
	..s DOCAnti=$P(^DHCEMCON(CstID),"^",19) //hxy 2022-09-01 st
    ..q:(DOCAHtml="Y")&&(DOCAnti'="DOCA") 
    ..s AgreeFlag=$p(^DHCEMCON(CstID),"^",35)
    ..q:(DOCAResHtml="Y")&&(AgreeFlag'="Y") //ed
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..q:(PatNameHtml'="")&&(PatName'[PatNameHtml)
	..q:(PatNoHtml'="")&&(PatNo'[PatNoHtml)
	..s AdmType=$p(^PAADM(EpisodeID),"^",2) //hxy 2022-11-17 st
	..q:(AdmTypeOEI'="")&(AdmTypeOEI'[AdmType) //ed
	..s AdmType=$s(AdmType="O":"门诊",AdmType="E":"急诊",AdmType="I":"住院",1:"")
	..s PatSex=""
	..s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	..s PatWard=""
	..s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	           /// 病区ID
	..s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	..s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	..s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	..s BedId=$p(^PAADM(EpisodeID),"^",73) 				/// 床号ID
    ..S PatBed=""
    ..;s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
    ..s PatBed = ##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID)
    ..i (PatBed'="")&(PatBed'["床") s PatBed=PatBed_"床"
    ..;s PatDiagDesc=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)   /// 诊断
    ..s PatDiagDesc = ##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.diag.GetAdmDiagDesc",EpisodeID, "", "")
	..s CstDate = $p(^DHCEMCON(CstID),"^",3)
	..s CstTime = $p(^DHCEMCON(CstID),"^",4)
	..s CstStatusID = $p(^DHCEMCON(CstID),"^",18)
	..;q:(ICstStatusID'="")&&(ICstStatusID'=CstStatusID)   //过滤状态:不能过滤主表
	..s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	..q:(+ICstRLocID'=0)&&(ICstRLocID'=CstRLocID) //(ICstRLocID'="")&&(ICstRLocID'=CstRLocID)
	..s AdmHospID=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(CstRLocID) //hxy 2020-09-24 st
	..q:(AdmHospID'=LgHospID) //ed
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s CstUser="",CstUserJobNum=""
	..s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	..s:CstUserID'="" CstUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	..s CstUser=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.SSUser","SSUSRName","",CstUser)
	..s:CstUserID'="" CstUserJobNum=$p(^SSU("SSUSR",CstUserID),"^",1) //申请人工号
	..s CstDateDesc = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstDate)
	..s CstTimeDesc = $zt(CstTime,1)
	..s CstStatus=""							  ///当前状态
	..s:CstStatusID'="" CstStatus=$p($g(^DHCEMCONS(+CstStatusID)),"^",2)
	..s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	..s OneOrMore=$p(^DHCEMCON(CstID),"^",31)  /// 是否多科
	..s CstType=""
	..s CstCatDr = $p(^DHCEMCON(CstID),"^",8)
	..q:(TypeHtml'="")&&(CstCatDr'=TypeHtml)
	..s:CstCatDr'="" CstType = $p(^DHCEMCDI(CstCatDr),"^",2)
	..s CstUnit=$p(^DHCEMCON(CstID),"^",25)    /// 外院名称
	..s CstDocName=$p(^DHCEMCON(CstID),"^",26) /// 外院医师
	..s CstNDate=$p(^DHCEMCON(CstID),"^",10)   /// 会诊日期
	..s:CstNDate'="" CstNDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)
	..s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	..s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	..s CstLoc = ##Class(web.DHCEMConsultQuery).GetConsultLocs(CstID)
	..Q:(ICstLocDesc'="")&&(CstLoc'[ICstLocDesc)
	..s CstPurpose=$p(^DHCEMCON(CstID),"^",7)   //会诊目的
	..s CstTrePro=$p(^DHCEMCON(CstID),"^",6)    /// 病情及诊疗经过
	..s CareProv=""      						///会诊医生
	..s CsTreMea=$p(^DHCEMCON(CstID),"^",17)   ///会诊意见
	..s CsPropID=$p(^DHCEMCON(CstID),"^",45)      /// 会诊性质 //hxy 2021-03-18 st
	..q:(ConsNature'="")&(ConsNature'=CsPropID)
	..s CsProp=$p($g(^DHCEMCDI(+CsPropID)),"^",2) /// 会诊性质 //ed
	..s CsProp=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmConsDicItem","ECDesc","",CsProp)
	..s PatMrNo=##Class(web.DHCEMConsultCom).GetMrNo(EpisodeID) //hxy 2021-07-09 病案号
	..s CstNPlace=$p(^DHCEMCON(CstID),"^",12)     /// 会诊地点
	..s CstNPlace=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",CstNPlace)
	..s CH=0
	..F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	...s CsOpinion = $p($g(^DHCEMCON(CstID,"I",CH)),"^",4)
	...s:(CsOpinion="")&&(CsTreMea'="") CsOpinion=CsTreMea
	...s LocDesc=""
	...s LocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)          /// 科室ID
	...s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	...Q:(ICstLocID'="")&(LocID'=ICstLocID)
	...s CareProv="",CareProvJobNum=""
	...s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",3)     /// 医生
	...s:CareProvID="" CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 医生
	...s:CareProvID'="" CareProv=$p(^CTPCP(CareProvID,1),"^",2)
	...s:CareProvID'="" CareProvJobNum=$p(^CTPCP(CareProvID,1),"^",1) //会诊人工号
	...s CareProv=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.SSUser","SSUSRName","",CareProv)
	...s LocDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
	...s PrvTpID="",PrvTp=""
	...s PrvTpID=$p(^DHCEMCON(CstID,"I",CH),"^",11)       /// 职称
	...i PrvTpID'="" s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	...s PrvTp=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",PrvTp)
	...s CstLoc = LocDesc_$s(PrvTp'="":"【"_PrvTp_"】",1:"")
	...i CstOutFlag="Y" s CstLoc=CstUnit_"【"_CstDocName_"】"
	...
	...s Oeori=$p(^DHCEMCON(CstID,"I",CH),"^",9)          /// 医嘱ID
	...i Oeori=""  s Oeori=$p(^DHCEMCON(CstID,"I",CH),"^",10)
	...//s ECExeStatus = $p(^DHCEMCON(CstID,"I",CH),"^",6)
	...s ECExeStatus=##Class(web.DHCEMConsultQuery).GetCstCurStat(CstID_"||"_CH) /// 取会诊记录的当前状态值
	...q:((ICstStatusID'="")&&(ICstStatusID'="到达"))&&(ECExeStatus'="")&&(ICstStatusID'=ECExeStatus)   //过滤状态 //2021-05-11 add(ICstStatusID'="到达")
	...q:(ICstStatusID'="")&&(ECExeStatus="")&&(ICstStatusID'=CstStatusID)    //过滤状态
	...s:ECExeStatus'="" CstStatus=ECExeStatus
	...s CstItmID=CstID_"||"_CH
	...s CstRLoc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",CstRLoc)
	...s CstUser=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.SSUser","SSUSRName","",CstUser)
	...s PatName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.PAPatMas","PAPMIName","",PatName)
	...s PatSex=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	...s PatWard=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.PACWard","WARDDesc","",PatWard)
	...s CstStatus=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmConsStatus","ECSDesc","",CstStatus)
	...s CstType=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmConsDicItem","ECDesc","",CstType)
	...q:(+ICstRLocID=0)&&(ICstRLocID'="")&&(CstRLoc'[ICstRLocID) //hxy 2022-12-06
	...s TypeCode=$p(^DHCEMCON(CstID),"^",19)
	...s CsSurTime=##class(web.DHCEMConsultQuery).GetCsSurTime(CstID_"||"_CH) ///会诊剩余时间 hxy 2021-03-18
	...s CsOverTime=..GetCsOverTime(CstID_"||"_CH) //会诊超时时间 hxy 2021-03-19
	...q:(OverTime="Y")&(CsOverTime="") //hxy 2021-03-23
	...s ArrDate=$p(^DHCEMCON(CstID,"I",CH),"^",18) //hxy 2021-04-02 st
	...s ArrTime=$p(^DHCEMCON(CstID,"I",CH),"^",19) 
	...s:ArrDate'="" ArrDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(ArrDate)
	...s:ArrTime'="" ArrTime=$zt(ArrTime,1) //ed
	...q:(ICstStatusID="到达")&&(ArrDate="")  //hxy 2021-05-11过滤到达状态（到达独立出了流程，有到达日期的视为到达）
	...s ComDateTime=##Class(web.DHCEMConsultQuery).GetCstNodeTime(CstID_"||"_CH,"50") //hxy 2021-04-13 st 完成日期、完成时间
	...s ComDate=$p(ComDateTime," ",1)
	...s ComTime=$p(ComDateTime," ",2) //ed
	...s REva=##class(web.DHCEMConsAppTable).GetAllSc(CstItmID,"SHR",LgHospID) //申请评价表
	...s CEva=##class(web.DHCEMConsAppTable).GetAllSc(CstItmID,"SHP",LgHospID) //会诊评价表
	...s ListData = CstID_"^"_CstItmID_"^"_CstRLoc_"^"_CstLoc_"^"_CstUser_"^"_CstDateDesc_"^"_CstTimeDesc_"^"_CstStatus_"^"_CstType
	...s ListData = ListData_"^"_EpisodeID_"^"_PatName_"^"_PatSex_"^"_PatWard_"^"_PatBed_"^"_PatDiagDesc_"^"_CstPurpose
	...s ListData = ListData_"^"_CstTrePro_"^"_CareProv_"^"_CstNDate_"^"_CstNTime_"^"_CsOpinion_"^"_TypeCode_"^"_CsProp_"^"_CsSurTime_"^"_CsOverTime
	...s ListData = ListData_"^"_ArrDate_"^"_ArrTime_"^"_ComDate_"^"_ComTime_"^"_REva_"^"_CEva_"^"_PatNo_"^"_CstUserJobNum_"^"_CareProvJobNum
	...s ListData = ListData_"^"_PatMrNo_"^"_CstNPlace_"^"_Oeori_"^"_AdmType
	...s Count=Count+1
	...s TMPListData(CstDate,CstRLoc,Count) = ListData
	
	
	s Count = 0
	s ListString = "CstID^CstItmID^CstRLoc^CstLoc^CstUser^CstDate^CstTime^CstStatus^CstType^EpisodeID^PatName^PatSex^PatWard^PatBed^PatDiagDesc"
	s ListString = ListString_"^CstPurpose^CstTrePro^CareProv^CstNDate^CstNTime^CsOpinion^TypeCode^CsProp^CsSurTime^CsOverTime^ArrDate^ArrTime^ComDate^ComTime^REva^CEva^PatNo"
	s ListString = ListString_"^CstUserJobNum^CareProvJobNum^PatMrNo^CstNPlace^Oeori^AdmType"
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s CstDate=""
	f  s CstDate = $o(TMPListData(CstDate),-1) q:CstDate=""  d
	.s CstRLoc=""
	.f  s CstRLoc = $o(TMPListData(CstDate,CstRLoc)) q:CstRLoc=""  d 
	..s Num=""
	..f  s Num = $o(TMPListData(CstDate,CstRLoc,Num)) q:Num=""  d 
	...s ListData= TMPListData(CstDate,CstRLoc,Num)
	...s Count = Count+1
	...s ^TMP("DHCEM","web.DHCEMFindConsult","GetConsultList",+UserID,Count) = ListData  //打印获取数据 
	...Q:(Count<Start)||(Count>End)
	...w $s(Count=Start:"",1:",")
	...w ##class(web.DHCAPPJsonCommon).getJsonData(ListString,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	q ""
}

/// w ##class(web.DHCEMFindConsult).GetExportDate("662")
ClassMethod GetExportDate(UserID)
{
	n (UserID)
	q:+UserID=0 "[]"
	
	s ListString = "CstID^CstItmID^CstRLoc^CstLoc^CstUser^CstDate^CstTime^CstStatus^CstType^EpisodeID^PatName^PatSex^PatWard^PatBed^PatDiagDesc"
	s ListString = ListString_"^CstPurpose^CstTrePro^CareProv^CstNDate^CstNTime^CsOpinion^TypeCode^CsProp^CsSurTime^CsOverTime^ArrDate^ArrTime^ComDate^ComTime^REva^CEva^PatNo"
	s ListString = ListString_"^CstUserJobNum^CareProvJobNum^PatMrNo^CstNPlace^Oeori^AdmType"
	w "["
	s Count=""
	f  s Count = $o(^TMP("DHCEM","web.DHCEMFindConsult","GetConsultList",+UserID,Count)) q:Count=""  d
	.s ListData = ^TMP("DHCEM","web.DHCEMFindConsult","GetConsultList",+UserID,Count)
	.w $case(Count,1:"",Count:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(ListString,ListData)
	w "]"
	q ""
}

/// Creator:      hxy
/// CreateDate:   2021-03-18
/// Descript:     会诊超时时间（完成时间/当前时间-会诊申请时间）未超时显示空，超时显示超时时间；
/// InPut:        itmID - 会诊子表ID
/// OutPut:       时间
/// w ##Class(web.DHCEMFindConsult).GetCsOverTime("78||1")
ClassMethod GetCsOverTime(itmID As %String) As %String
{
	n (itmID)
	q:+itmID=0 ""
	s ID=+itmID
	s Child=$p(itmID,"||",2)	
	s State=$p($g(^DHCEMCON(ID,"I",Child)),"^",6)    /// 会诊状态
	i State="" s State=$p(^DHCEMCON(ID),"^",18)  /// 会诊状态
	q:State="" ""
	s StateCode=$p($g(^DHCEMCONS(+State)),"^",1)
	q:(StateCode=5)||(StateCode=25)||(StateCode=22) ""  /// 取消||拒绝||驳回
	s CstEmFlag=$p(^DHCEMCON(ID),"^",23)       /// 是否加急
	s CsRDate=$p(^DHCEMCON(ID),"^",3)          /// 申请日期
	s CsRTime=$p(^DHCEMCON(ID),"^",4)          /// 申请时间
	s CsPropID=$p(^DHCEMCON(ID),"^",45)        /// 会诊性质
	s CmpDate=$p($g(^DHCEMCON(ID,"I",Child)),"^",16) ///完成日期
	s CmpTime=$p($g(^DHCEMCON(ID,"I",Child)),"^",17) ///完成时间
	s ArrDate=$p($g(^DHCEMCON(ID,"I",Child)),"^",18) ///到达日期 2021-04-02 st
	s ArrTime=$p($g(^DHCEMCON(ID,"I",Child)),"^",19) ///到达时间 //ed
	s:CmpDate="" CmpDate=+$H
	s:CmpTime="" CmpTime=$p($H,",",2)
	s Hours=24
	i CstEmFlag="Y" s Hours=2
	s HoursConfig=##Class(web.DHCEMConsultQuery).GetHoursConfig(CsPropID,"OVERTIEMHOUR")
	s:+HoursConfig'=0 Hours=HoursConfig
	s CstRLocID=$p(^DHCEMCON(ID),"^",2)    /// 申请科室 
	s HospID=##Class(web.DHCEMCommonUtil).GetHospitalIDByLocID(CstRLocID)
	s EmArrMin=##class(web.DHCEMConsultCom).GetEmSysConfig("EMARRMIN",HospID) //2021-04-02 st 急会诊要求到达分钟数
	s ConsUseStatusCode = ##Class(web.DHCEMConsultCom).GetConsUseStatusCode(HospID) //当前启用的状态code
	s:ConsUseStatusCode'["^40^" EmArrMin=0 //状态到达启用为前提
	i (+EmArrMin'=0)&&(CstEmFlag="Y") d
	.s Hours=EmArrMin/60 
	.s:(ArrDate'="")&&(ArrTime'="") CmpDate=ArrDate
	.s:(ArrDate'="")&&(ArrTime'="") CmpTime=ArrTime //ed
	s OverTimeFilter=##class(web.DHCEMConsultCom).GetEmSysConfig("OVERTIMEFILTER",HospID)
	i (OverTimeFilter=1)!(OverTimeFilter=2) d
	.s SSCut=##Class(web.DHCEMConsultQuery).GetDateDiff(CsRDate,CsRTime,CmpDate,CmpTime,OverTimeFilter)
	e  d
	.s SSCut= $SYSTEM.SQL.DATEDIFF("ss",CsRDate_","_CsRTime,CmpDate_","_CmpTime) //ed
	q:SSCut<=0 "" 
	s CrTime=SSCut-(Hours*3600)
	q:CrTime<0 ""
	;s CrTime=(CrTime\3600)_":"_$p($zt(CrTime#3600,2),":",2)
	s CrTime=(CrTime\3600)_":"_$p($zt(CrTime#3600,1),":",2)_":"_$p($zt(CrTime#3600,1),":",3)
	q CrTime
}

}
