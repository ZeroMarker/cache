Class EMRservice.Ajax.consult Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s interface = $Get(%request.Data("InterFace",1),"")
	s interface = $zcvt($zcvt(interface,"I","URL"),"I","UTF8")
	s json = ..GetConsult(interface,episodeId)
	w json
	Quit $$$OK
}

/// Desc:		会诊列表
/// Creator:	Lina
/// CreateDate: 2017-2-17
/// Input:      AInterFace 调用接口标识(默认HIS)
///      		AEpisodeId 就诊ID
/// Output:  	json
/// Debug:		w ##Class(EMRservice.Ajax.consult).GetConsult("HIS",194)
ClassMethod GetConsult(AInterFace As %String, AEpisodeIds As %String) As %String
{
	s json = ""
	q:(AEpisodeIds = "") "{""total"":0,""rows"":["_json_"]}"
	s count = 0
	s length = $l(AEpisodeIds,",")
	for I=1:1:length
	{
		s episodeId = $p(AEpisodeIds,",",I)
		s ds = ##Class(%Library.ResultSet).%New("EMRservice.HISInterface.Resource.Consult:ConsultInfo")
		d ds.Execute(episodeId,AInterFace)
		
		While (ds.Next())
		{
			s count = count + 1
			d setJson
		}
	}
	s json = $e(json,1,$l(json)-1)
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
setJson
	s ConSummary = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("ConSummary")) //会诊摘要
	s Diag = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("Diag"))
	s ConDestination = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("ConDestination"))
	s Attitude = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("Attitude"))
	s HISFormatDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("ConsultDate"))
	s HISFormatTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("ConsultTime"))
	s json = json_"{"
	s json = json_"""PatRegNo"":"""_ds.Data("PatRegNo")_""","
	s json = json_"""PatId"":"""_ds.Data("PatId")_""","
	s json = json_"""PatName"":"""_ds.Data("PatName")_"""," 
	s json = json_"""SEX"":"""_ds.Data("SEX")_"""," 
	s json = json_"""AGE"":"""_ds.Data("AGE")_""","
	s json = json_"""PatDep"":"""_ds.Data("PatDep")_""","
	s json = json_"""PatWard"":"""_ds.Data("PatWard")_""","
	s json = json_"""BedCode"":"""_ds.Data("BedCode")_""","
	s json = json_"""Diag"":"""_Diag_""","
    s json = json_"""ConSummary"":"""_ConSummary_""","
	s json = json_"""ConDestination"":"""_ConDestination_""","
	s json = json_"""ConType"":"""_ds.Data("ConType")_"""," 
	s json = json_"""PatDep2"":"""_ds.Data("PatDep2")_"""," 
	s json = json_"""PatDoc"":"""_ds.Data("PatDoc")_""","
	s json = json_"""ConsultDep"":"""_ds.Data("ConsultDep")_""","
	s json = json_"""ConsultDoc"":"""_ds.Data("ConsultDoc")_""","
	s json = json_"""PatDocCarprv"":"""_$g(ds.Data("PatDocCarprv"))_""","
	s json = json_"""condocCarprv"":"""_$g(ds.Data("condocCarprv"))_""","
	s json = json_"""Attitude"":"""_Attitude_""","
	s json = json_"""ConsultDate"":"""_HISFormatDate_""","
	s json = json_"""ConsultTime"":"""_HISFormatTime_""""
	s json = json_"}"	
	s json =json_","
}

/// 入参 EpisodeID(paadm_rowid)
/// 返回值 登记号 病案号 姓名 性别 年龄 科别 病区 床号 诊断 会诊目的 会诊类别 会诊申请科室 申请医生 会诊科室 会诊医生 会诊意见 会诊日期 会诊时间 申请医生职称 会诊医生职称
/// d ##class(%ResultSet).RunQuery("EMRservice.Ajax.consult","ConsultInfo","68279")
Query ConsultInfo(EpisodeID As %String) As %Query(ROWSPEC = "PatRegNo,PatId,PatName,SEX,AGE,PatDep,PatWard,BedCode,Diag,ConDestination,ConType,PatDep2,PatDoc,ConsultDep,ConsultDoc,Attitude,ConsultDate,ConsultTime,PatDocCarprv,condocCarprv")
{
}

ClassMethod ConsultInfoExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	
	s repid=$i(^CacheTemp)
	s EpisodeID=$g(EpisodeID)
	i EpisodeID="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
	s ind=1
 	s patinf=##class(web.DHCMGNurComm).PatInfo(EpisodeID)
 	S PatName=$P(patinf,"^",5)
 	s PatName=$p(PatName,"@",2)
 	s BedCode=$P(patinf,"^",6)
 	s BedCode=$p(BedCode,"@",2)
 	s PatRegNo=$P(patinf,"^",1)
 	s PatRegNo=$p(PatRegNo,"@",2)
 	s PatId=$P(patinf,"^",10)
 	s PatId=$p(PatId,"@",2)
 	s PatWard=$P(patinf,"^",8)
 	s PatWard=$p(PatWard,"@",2)
 	s id="" f  s id=$O(^User.DHCConsultationI("Adm"," "_EpisodeID,id)) q:id=""  d
 	.s a=^User.DHCConsultationD(id)
 	.s status=$listget(a,16)
	.;i status="V" s status="申请"
	.;i status="E" s status="执行"
	.;i status="C" s status="撤销"
 	.q:(status'="V")&(status'="E")
 	.s Diag=$listget(a,30)
    .//s appdate=$listget(a,3)
    .//if appdate'="" s appdate=$ZD(appdate,3)
    .s appdep=$listget(a,4)
    .if appdep'="" d
    ..s appdepDes=$P(^CTLOC(appdep),"^",2)
    ..i $L(appdepDes,"-")>1 s appdepDes=$P(appdepDes,"-",2)
    .e  s appdepDes=""
    .s PatDep=appdepDes
    .s PatDep2=PatDep
    .s appdoc=$listget(a,5)
    .if appdoc'="" s PatDoc=$P(^SSU("SSUSR",appdoc),"^",2)
    .e  s PatDoc=""
    .if appdoc'="" s PatDocCarprv=##class(EMRservice.Ajax.consult).GetUserLevelbyHis(appdoc)
    .e  s PatDocCarprv=""
   
    .s condestinat=$listget(a,8)
    .s condestinat=$tr(condestinat,"*","x")
    .s ConDestination=condestinat
    .s ConType=""
    .s type=$listget(a,9)
    .i type="C" s ConType="普通"
    .i type="E" s ConType="急"
    .if type="M" s ConType="多科"
	.if type="A" s ConType="抗菌药"
    .s condep=$listget(a,11)
    .if condep'=""  d
    ..s condepDes=$P(^CTLOC(condep),"^",2)
    ..i $L(condepDes,"-")>1 s condepDes=$P(condepDes,"-",2)
    .e  s condepDes=""
    .s ConsultDep=condepDes
     .s condoc=$listget(a,12)
    .if condoc'="" s condocDes=$p($g(^CTPCP(condoc,1)),"^",2)
    .e  s condocDes=""
    .if condoc'="" s condocCarprv=$p(^CT("CPT",$p($g(^CTPCP(condoc,1)),"^",4)),"^",2)
    .e  s condocCarprv=""
    .s ConsultDoc=condocDes
    .s consultdate=$listget(a,10)
    .if consultdate'="" s consultdate=$ZD(consultdate,3)
    .s ConsultDate=consultdate
    .s contime=$listget(a,13)
    .if contime'="" s contime=$ZT(contime,2)
    .s ConsultTime=contime
    .s Attitude=$listget(a,7)
    .s Attitude=$tr(Attitude,"*","x")
    .s SEX=$listget(a,28)
    .s AGE=$listget(a,29)
	.d Consult
	s qHandle=$lb(0,repid,0)
	q $$$OK

Consult
	s Data=$lb(PatRegNo,PatId,PatName,SEX,AGE,PatDep,PatWard,BedCode,Diag,ConDestination,ConType,PatDep2,PatDoc,ConsultDep,ConsultDoc,Attitude,ConsultDate,ConsultTime,PatDocCarprv,condocCarprv)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod ConsultInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ConsultInfoExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod ConsultInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ConsultInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Desc:       通过HIS取用户职称
/// Creator:    董璐璐
/// CreateDate: 2019-5-13
/// Input:      parUserID 用户ID
/// Output:     result 用户职称描述
ClassMethod GetUserLevelbyHis(parUserID As %String) As %String
{
	s result = ""
	q:(parUserID = "") result
	s userPvId = $p(^SSU("SSUSR",parUserID),"^",14)
	q:(userPvId = "") result
	s userCarprvtpId = $p(^CTPCP(userPvId,1),"^",4)
	q:(userCarprvtpId = "") result
	q:($p(^CTPCP(userPvId,1),"^",9) '= "Y") result
	s result = $p(^CT("CPT",userCarprvtpId),"^",1)
	q:(result = "") result
	q result
}

}
