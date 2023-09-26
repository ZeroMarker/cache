/// 宁医大总院护理病历指标
Class web.NurSensNurMpComm Extends %RegisteredObject
{

Parameter TemplateGUID As Sting = "4BFA9FA706E24D7493E60A990F080F49^B1D6B11C59F34CFE98A9B7FB3DBA918B^765DE6C9B0D0483B90B5126177CB9E33^EFC8DD7B0AFE402AAE38121071CEE6CF^54BB265852594A8FA6A25F235F9D8E13";

/// createdate:    2021-12-22
/// creater:	   yf
/// input:         
/// description:   首次评估率生活自理能力/压疮/跌倒/疼痛/早期预警入院6小时内完成（急诊手术24h内完成）
/// other:         w ##class(web.NurSensNurMpComm).getFirstEvaluationRateNew("2022-05-17","4860f83ba28f4dcd9a2e2f39df37ac26")
ClassMethod getFirstEvaluationRateNew(date As %String = "", templateGuid) As %String
{
	//^PAADMi("AdminDateExt",{PAADM_AdminDate},{PAADM_RowID})
	s StatTime=$P($H,",",2)
	q:((date="")||(templateGuid="")) ""
	s templateGuid=$ZCVT(templateGuid,"U")
	;s TemplateGUID="4BFA9FA706E24D7493E60A990F080F49^B1D6B11C59F34CFE98A9B7FB3DBA918B^765DE6C9B0D0483B90B5126177CB9E33^EFC8DD7B0AFE402AAE38121071CEE6CF^54BB265852594A8FA6A25F235F9D8E13"
	s episodeID="" f  s episodeID=$O(^PAADMi("AdminDateExt",date,episodeID)) q:episodeID=""  d
	.s pavisit=$p($g(^PAADM(episodeID)),"^",20)
    .q:pavisit="C" 
    .s admType=$p(^PAADM(episodeID),"^",2)
	.q:admType="O"
	.s PatientID=$p($g(^PAADM(episodeID)),"^",1)
	.s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	.s regNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	.s firstBedFlag=0,wardId="",bedSub=""
	.s transID = ""
	.f  s transID=$o(^PAADM(episodeID,"TRANS",transID)) q:((transID="")!(firstBedFlag=1))  d
	..s transGlobal=^PAADM(episodeID,"TRANS",transID)
	..s transBedDr = $p(transGlobal,"^",8)
	..q:$g(transBedDr)=""
	..s wardId=+transBedDr
	..s bedSub=transBedDr
	..s InHospDate = $p(transGlobal,"^",1)
	..s InHospTime = $p(transGlobal,"^",2)
	..s:wardId'="" firstBedFlag=1
	.q:wardId=""
	.s CTLocId=$P($G(^PAWARD(wardId)),"^",5)
	.s SourceType=..GetSourceTypeByAdm(episodeID)
	.s TempMultDataFlag=0
	.s ID="" f  s ID=$o(^NurMp.DHCTempMultDataI("EmrCode"," "_templateGuid," "_episodeID,ID)) q:(ID="")||(TempMultDataFlag=1)  d
	..s OBJ=##class(NurMp.DHCTempMultData).%OpenId(ID)
	..q:OBJ.RecCancelUser'=""
	..s TempMultDataFlag=1
	..s CareDate=OBJ.CareDate
	..s CareTime=OBJ.CareTime
	..s Difference=..GetTimeDifference($zd(InHospDate,3), $zt(InHospTime,2), CareDate, CareTime)
	..i (Difference<=6)&&(SourceType'="E") s ^tmpWardData(CTLocId)=$g(^tmpWardData(CTLocId))+1,^tmpWardData(CTLocId,episodeID)="床号:"_$p($g(^PAWARD($p(bedSub,"||",1),"BED",$p(bedSub,"||",2))),"^",1)_" 姓名:"_patName
	..i (Difference<=24)&&(SourceType="E") s ^tmpWardData(CTLocId)=$g(^tmpWardData(CTLocId))+1,^tmpWardData(CTLocId,episodeID)="床号:"_$p($g(^PAWARD($p(bedSub,"||",1),"BED",$p(bedSub,"||",2))),"^",1)_" 姓名:"_patName
	s EndTime=$P($H,",",2)
	q ""
}

ClassMethod getFirstEvaluationRate(date As %String = "") As %String
{
	///^NurMp.DHCTempMultDataI("EmrCode",EmrCode,EpisodeId,ID)
	s StatTime=$P($H,",",2)
	s TemplateGUID="4BFA9FA706E24D7493E60A990F080F49^B1D6B11C59F34CFE98A9B7FB3DBA918B^765DE6C9B0D0483B90B5126177CB9E33^EFC8DD7B0AFE402AAE38121071CEE6CF^54BB265852594A8FA6A25F235F9D8E13"
	;s Ward=53
	s Ward="" f  s Ward=$O(^PAADMi("CurrWard",Ward)) q:Ward=""  d
	.s PAADMCurrentRoomDR="" f  s PAADMCurrentRoomDR=$O(^PAADMi("CurrWard",Ward,PAADMCurrentRoomDR)) q:PAADMCurrentRoomDR=""  d
	..s episodeID="" f  s episodeID=$O(^PAADMi("CurrWard",Ward,PAADMCurrentRoomDR,episodeID)) q:episodeID=""  d
	...s pavisit=$p($g(^PAADM(episodeID)),"^",20)
    ...q:pavisit'="A" 
    ...s admType=$p(^PAADM(episodeID),"^",2)
	...q:admType="O"
	...s bedSub=$p($g(^PAADM(episodeID)),"^",73)
	...q:bedSub=""
	...s CTLocId=$P($G(^PAWARD(Ward)),"^",5)
	...s InHospDateTime=##class(Nur.NIS.Service.Base.Patient).GetInHospDateTime(episodeID)
	...s InHospDate=$P($G(InHospDateTime)," ",1)
	...s InHospTime=$P($G(InHospDateTime)," ",2)
	...q:(date'="")&&($zdh(InHospDate,3)'=date)
	...s PatientID=$p($g(^PAADM(episodeID)),"^",1)
	...s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	...s regNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	...s SourceType=..GetSourceTypeByAdm(episodeID)
	...s TemplateGUIDLength=$L(TemplateGUID,"^"),count=0
	...f i=1:1:TemplateGUIDLength  d
	....s Template=$P(TemplateGUID,"^",i),TempMultDataFlag=0
	....s ID="" f  s ID=$o(^NurMp.DHCTempMultDataI("EmrCode"," "_Template," "_episodeID,ID)) q:(ID="")||(TempMultDataFlag=1)  d
	.....s OBJ=##class(NurMp.DHCTempMultData).%OpenId(ID)
	.....q:OBJ.RecCancelUser'=""
	.....s TempMultDataFlag=1
	.....s CareDate=OBJ.CareDate
	.....s CareTime=OBJ.CareTime
	.....s Difference=..GetTimeDifference(InHospDate, InHospTime, CareDate, CareTime)
	.....i (Difference<=6)&&(SourceType'="E") s count=count+1
	.....i (Difference<=24)&&(SourceType="E") s count=count+1
	...s TemplateList="2034FE5F2AE94338B60B0E53E2DA33AE^F946529CD5934943B9B8D72F3C4A5857"
	...s IfSaved=..getIfSaved($P(TemplateGUID,"^",5),episodeID)  ;早期预警评分是否存在有效记录
	...i IfSaved'=1  d
	....s TemplateListSubFlag=0
	....s TemplateListSubID="" f  s TemplateListSubID=$o(^NurMp.DHCTempMultDataI("EmrCode"," "_$P(TemplateList,"^",1)," "_episodeID,TemplateListSubID)) q:(TemplateListSubID="")||(TemplateListSubFlag=1)  d 
	.....s TemplateListOBJ=##class(NurMp.DHCTempMultData).%OpenId(TemplateListSubID)
	.....q:TemplateListOBJ.RecCancelUser'=""
	.....s TemplateListSubFlag=1
	.....s CareDate=TemplateListOBJ.CareDate
	.....s CareTime=TemplateListOBJ.CareTime
	.....s Difference=..GetTimeDifference(InHospDate, InHospTime, CareDate, CareTime)
	.....i (Difference<=6)&&(SourceType'="E") s count=count+1
	.....i (Difference<=24)&&(SourceType="E") s count=count+1
	...i (IfSaved'=1)&&(..getIfSaved($P(TemplateList,"^",1),episodeID)'=1)  d
	....s TemplateFlag=0
	....s TemplateSubID="" f  s TemplateSubID=$o(^NurMp.DHCTempMultDataI("EmrCode"," "_$P(TemplateList,"^",2)," "_episodeID,TemplateSubID)) q:(TemplateSubID="")||(TemplateFlag=1)  d 
	.....s TemplateOBJ=##class(NurMp.DHCTempMultData).%OpenId(TemplateSubID)
	.....q:TemplateOBJ.RecCancelUser'=""
	.....s TemplateFlag=1
	.....s CareDate=TemplateOBJ.CareDate
	.....s CareTime=TemplateOBJ.CareTime
	.....s Difference=..GetTimeDifference(InHospDate, InHospTime, CareDate, CareTime)
	.....i (Difference<=8)&&(SourceType'="E") s count=count+1
	.....i (Difference<=24)&&(SourceType="E") s count=count+1
	...s:count=TemplateGUIDLength ^tmpWardData(CTLocId)=$g(^tmpWardData(CTLocId))+1
	...s:count=TemplateGUIDLength ^tmpWardData(CTLocId,episodeID)=$p($g(^PAWARD($p(bedSub,"||",1),"BED",$p(bedSub,"||",2))),"^",1)_" 姓名:"_patName
	s EndTime=$P($H,",",2)
	q ""
}

/// 时间差
/// w ##class(web.NurSensNurMpComm).GetTimeDifference("2021-12-22","09:35","2021-12-22","11:45")
ClassMethod GetTimeDifference(InHospDate, InHospTime, CareDate, CareTime)
{
	q:(InHospDate="")||(InHospTime="")||(CareDate="")||(CareTime="") ""
	s:InHospDate'="" InHospDate=$zdh(InHospDate,3)
	s:CareDate'="" CareDate=$zdh(CareDate,3)
	s:InHospTime'="" InHospTime=$zth(InHospTime)
	s:CareTime'="" CareTime=$zth(CareTime)
	i CareDate>InHospDate s Difference=((CareDate-InHospDate) * 86400 + CareTime - InHospTime)/3600
	i CareDate=InHospDate s Difference=(CareTime - InHospTime)/3600
	i CareDate<InHospDate s Difference=""
	q $G(Difference)
}

/// 手术类型
/// w ##class(web.NurSensNurMpComm).GetSourceTypeByAdm(34152400)
ClassMethod GetSourceTypeByAdm(EpisodeID)
{
	s objList=##class(CIS.AN.SRV.OperService).GetOperInfoByEpisode(EpisodeID,"")
	s length=objList.Count(),result=""
	f index=1:1:length
	{
		s item=objList.GetAt(index)
		s OpsId=item.OPSID
		s operInfo=##class(CIS.AN.SRV.OperService).GetOperInfoByID(OpsId)
		s sourceType=operInfo.SourceType   ;急诊E，择期B，日间D
		s OperDate=operInfo.OperDate
		if (index>1)
			  {
				s result=result_"\"	
			  }
		set result=result_sourceType
	}
	q result
}

/// 是否保存过数据
ClassMethod getIfSaved(Guid, EpisodeID)
{
	s ret=0
	s ^TMPYJN("getIfSaved")=$lb(Guid, EpisodeID)
	q:(Guid="")||(EpisodeID="") ret
	s id="" f  s id=$o(^NurMp.DHCTempMultDataI("EmrCode"," "_Guid," "_EpisodeID,id)) q:(id="")||(ret=1)  d
	.q:##class(NurMp.DHCTempMultData).%OpenId(id).RecCancelUser'=""
	.s ret=1
	q ret
}

/// createdate:    2021-12-23
/// creater:	   yf
/// input:         
/// description:   生活自理能力评估再评估率
/// other: 		   w ##class(web.NurSensNurMpComm).ZLNLReassessmentRate(66106)
ClassMethod ZLNLReassessmentRate(date As %String = "", flag As %String = "") As %String
{
	s Ward="" f  s Ward=$O(^PAADMi("CurrWard",Ward)) q:Ward=""  d
	.s PAADMCurrentRoomDR="" f  s PAADMCurrentRoomDR=$O(^PAADMi("CurrWard",Ward,PAADMCurrentRoomDR)) q:PAADMCurrentRoomDR=""  d
	..s episodeID="" f  s episodeID=$O(^PAADMi("CurrWard",Ward,PAADMCurrentRoomDR,episodeID)) q:episodeID=""  d
	...s pavisit=$p($g(^PAADM(episodeID)),"^",20)
    ...q:pavisit'="A" 
    ...s admType=$p(^PAADM(episodeID),"^",2)
	...q:admType="O"
	...s bedSub=$p($g(^PAADM(episodeID)),"^",73)
	...q:bedSub=""
	...s CTLocId=$P($G(^PAWARD(Ward)),"^",5)
	...s PatientID=$p($g(^PAADM(episodeID)),"^",1)
	...s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	...s regNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	...s ruleIDS="32^33^34"
	...s ruleIDLength=$l(ruleIDS,"^")
	...f ruleID=1:1:ruleIDLength  d
	....s ValueResult=##class(Nur.NIS.Service.VitalSign.TemperatureMeasureV2).GetNeedEmr(episodeID, date, CTLocId, Ward,"",$P(ruleIDS,"^",ruleID))
	....f i=1:1:ValueResult.Count()  d
	.....s ValueList=ValueResult.GetAt(i)
	.....s ValueID=ValueList.GetAt("recordList")
	.....f l=1:1:ValueID.Count()  d
	......s Value=ValueID.GetAt(l)
	......s ValueScore=Value.GetAt("recordScore")
	......f k=1:1:ValueScore.Count()  d
	.......s Score=ValueScore.GetAt(k)
	.......s score=Score.GetAt("score")
	.......s ^tmpWardData(CTLocId)=$G(^tmpWardData(CTLocId))+1  ;当天需要评估自理能力
	.......s ^tmpWardData(CTLocId,episodeID)=patName
	.......i ((flag="F")&&(score'="true")) d
	........s ^tmpWardData(CTLocId)=$g(^tmpWardData(CTLocId))+1   ;已评估自理能力
	........s ^tmpWardData(CTLocId,episodeID)=patName_"评估总分:"_score
	q ""
}

/// createdate:    2021-12-23
/// creater:	   yf
/// input:         
/// description:   压疮评估再评估率
/// other: 		   w ##class(web.NurSensNurMpComm).YCReassessmentRate(66101)
ClassMethod YCReassessmentRate(date As %String = "", flag As %String = "") As %String
{
	s Ward="" f  s Ward=$O(^PAADMi("CurrWard",Ward)) q:Ward=""  d
	.s PAADMCurrentRoomDR="" f  s PAADMCurrentRoomDR=$O(^PAADMi("CurrWard",Ward,PAADMCurrentRoomDR)) q:PAADMCurrentRoomDR=""  d
	..s episodeID="" f  s episodeID=$O(^PAADMi("CurrWard",Ward,PAADMCurrentRoomDR,episodeID)) q:episodeID=""  d
	...s pavisit=$p($g(^PAADM(episodeID)),"^",20)
    ...q:pavisit'="A" 
    ...s admType=$p(^PAADM(episodeID),"^",2)
	...q:admType="O"
	...s bedSub=$p($g(^PAADM(episodeID)),"^",73)
	...q:bedSub=""
	...s CTLocId=$P($G(^PAWARD(Ward)),"^",5)
	...s PatientID=$p($g(^PAADM(episodeID)),"^",1)
	...s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	...s regNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	...s ruleIDS="35^36"
	...s ruleIDLength=$l(ruleIDS,"^")
	...f ruleID=1:1:ruleIDLength  d
	....s ValueResult=##class(Nur.NIS.Service.VitalSign.TemperatureMeasureV2).GetNeedEmr(episodeID, date, CTLocId, Ward,"",$P(ruleIDS,"^",ruleID))
	....f i=1:1:ValueResult.Count()  d
	.....s ValueList=ValueResult.GetAt(i)
	.....s ValueID=ValueList.GetAt("recordList")
	.....f l=1:1:ValueID.Count()  d
	......s Value=ValueID.GetAt(l)
	......s ValueScore=Value.GetAt("recordScore")
	......f k=1:1:ValueScore.Count()  d
	.......s Score=ValueScore.GetAt(k)
	.......s score=Score.GetAt("score")
	.......s ^tmpWardData(CTLocId)=$G(^tmpWardData(CTLocId))+1  ;当天需要评估压疮
	.......s ^tmpWardData(CTLocId,episodeID)=patName
	.......i ((flag="F")&&(score'="true")) d
	........s ^tmpWardData(CTLocId)=$g(^tmpWardData(CTLocId))+1   ;已评估压疮
	........s ^tmpWardData(CTLocId,episodeID)=patName_"评估总分:"_score
	q ""
}

/// createdate:    2021-12-23
/// creater:	   yf
/// input:         
/// description:   跌倒评估再评估率
/// other: 		   w ##class(web.NurSensNurMpComm).DDReassessmentRate(66101)
ClassMethod DDReassessmentRate(date As %String = "", flag As %String = "") As %String
{
	s Ward="" f  s Ward=$O(^PAADMi("CurrWard",Ward)) q:Ward=""  d
	.s PAADMCurrentRoomDR="" f  s PAADMCurrentRoomDR=$O(^PAADMi("CurrWard",Ward,PAADMCurrentRoomDR)) q:PAADMCurrentRoomDR=""  d
	..s episodeID="" f  s episodeID=$O(^PAADMi("CurrWard",Ward,PAADMCurrentRoomDR,episodeID)) q:episodeID=""  d
	...s pavisit=$p($g(^PAADM(episodeID)),"^",20)
    ...q:pavisit'="A" 
    ...s admType=$p(^PAADM(episodeID),"^",2)
	...q:admType="O"
	...s bedSub=$p($g(^PAADM(episodeID)),"^",73)
	...q:bedSub=""
	...s CTLocId=$P($G(^PAWARD(Ward)),"^",5)
	...s PatientID=$p($g(^PAADM(episodeID)),"^",1)
	...s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	...s regNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	...s ruleIDS="37^38^39"
	...s ruleIDLength=$l(ruleIDS,"^")
	...f ruleID=1:1:ruleIDLength  d
	....s ValueResult=##class(Nur.NIS.Service.VitalSign.TemperatureMeasureV2).GetNeedEmr(episodeID, date, CTLocId, Ward,"",$P(ruleIDS,"^",ruleID))
	....f i=1:1:ValueResult.Count()  d
	.....s ValueList=ValueResult.GetAt(i)
	.....s ValueID=ValueList.GetAt("recordList")
	.....f l=1:1:ValueID.Count()  d
	......s Value=ValueID.GetAt(l)
	......s ValueScore=Value.GetAt("recordScore")
	......f k=1:1:ValueScore.Count()  d
	.......s Score=ValueScore.GetAt(k)
	.......s score=Score.GetAt("score")
	.......s ^tmpWardData(CTLocId)=$G(^tmpWardData(CTLocId))+1  ;当天需要评估跌倒
	.......s ^tmpWardData(CTLocId,episodeID)=patName
	.......i ((flag="F")&&(score'="true")) d
	........s ^tmpWardData(CTLocId)=$g(^tmpWardData(CTLocId))+1   ;已评估跌倒
	........s ^tmpWardData(CTLocId,episodeID)=patName_"评估总分:"_score
	q ""
}

}
