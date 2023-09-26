Class web.DHCENS.STBLL.EMPI.METHOD.GetVitalSignInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lipan
/// CreatDate：2016—08-01
/// Description：获取生命体征信息
/// Table：
/// Input：就诊rowid
/// Return：生命体征信息集合
/// Others: 
/// w ##class(web.DHCENS.STBLL.EMPI.METHOD.GetVitalSignInfo).SaveVitalSignInfo()
ClassMethod SaveVitalSignInfo(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set response=##class(web.DHCENS.STBLL.EMPI.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set response.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Respbody).%New()
	
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	
	if $$$ISERR(tSC) {
		set body.ResultCode="-1"
		set body.ResultContent=tSC
		set response.Respbody=body
	}else{
		set PAADMVisitNumber=""
		set HosCode="DHSZHYYZY"	
		set tSC=tDocument.EvaluateExpression("/Request/Body/VitalSignInfoRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}
		if PAADMVisitNumber=""{
				set body.ResultCode="-1"
				set body.ResultContent="PAADMVisitNumber不能为空"
				set response.Respbody=body
				d response.XMLExportToStream(stream)
				q stream
		}
		set AdmDate= $zd($P($G(^PAADM(PAADMVisitNumber)),"^",6),3)
		set CurrentDate=$zd(+$h,3)
		set streamStr=##class(%GlobalCharacterStream).%New()
		s streamStr=##class(web.DHCThreeNew).GetOBSDateValue(PAADMVisitNumber,AdmDate,CurrentDate)
		while 'streamStr.AtEnd{
			s substr=streamStr.ReadLine()
			s date=$p(substr,"^",1)
			s time=$p(substr,"^",2)
			s item=$p(substr,"^",3)
			s TMPDHCENS("SaveVitalSignInfo",date,time,item)=substr
		}
	
		s date="" f  s date=$o(TMPDHCENS("SaveVitalSignInfo",date)) q:date=""  d
		.s time="" f  s time=$o(TMPDHCENS("SaveVitalSignInfo",date,time)) q:time=""  d
		..set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.VitalSignInfo).%New()
		..set Obj.InputQuantity=""
		..set Obj.OutputQuantity=""
		..set Obj.MeasureUserCode="demo"
		..set Obj.MeasureDate=date
		..set Obj.MeasureTime=time
		..set item="" f  s item=$o(TMPDHCENS("SaveVitalSignInfo",date,time,item)) q:item=""  d
		...set substring=$g(TMPDHCENS("SaveVitalSignInfo",date,time,item))
		...set:item="Item2" Obj.Weight=$p(substring,"^",5)
		...set:item="Item7" Obj.Pulse=$p(substring,"^",5)
		...set:item="Item5" Obj.SystolicBP=$p(substring,"^",5)
		...set:item="Item6" Obj.DiastolicBP=$p(substring,"^",5)
		...set:item="Item1" Obj.Temperature=$p(substring,"^",5)
	
		..q:((Obj.Weight="")&&(Obj.Pulse="")&&(Obj.SystolicBP="")&&(Obj.DiastolicBP="")&&(Obj.Temperature=""))
		..d body.VitalSignInfos.Insert(Obj)
		s response.Respbody=body
	}
	
	d response.XMLExportToStream(stream)
	q stream
	
	
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：Huangzhao
/// CreatDate：2019—07-02
/// Description：获取生命体征信息
/// Table：MR_Observations（体征数据），MRC_ObservationItem（体征项目字典）
/// Input：就诊rowid，采集体征开始结束日期（为空时取最后一天的）
/// Return：生命体征信息集合
/// Others: 参考了护理组方法##class(web.DHCMGNurComm).GetPatValueStr()
/// Debug：w ##class(web.DHCENS.STBLL.EMPI.METHOD.GetVitalSignInfo).GetVitalSignInfo(16367974,65196,65196)
ClassMethod GetVitalSignInfo(admID As %String, DateS As %String = "", DateE As %String = "") As %GlobalCharacterStream
{
	s $zt="Exception"
	s admData=$g(^PAADM(admID))
	s Mradm=$p(admData,"^",61)
	i Mradm="" q "-1^就诊号错误"
	s patID=$p(admData,"^",1)
	i patID="" q "-1^就诊号错误"
	s stream=##class(%GlobalCharacterStream).%New()
	s:DateS="" DateS=+$h-1
	s:DateE="" DateE=+$h-1
	//              体温,脉搏,呼吸,血压(高压(收缩压)、低压(舒张压)),身高,体重(体重项可能附带身高，以/分隔)
	s ItemDrList=$lb(69,67,68,70,71,74,73)	//-->MRC_ObservationItem的rowid，以院内实际值为准
	s len=$ll(ItemDrList)
	s VitalSignInfoRt=##class(web.DHCENS.STBLL.EMPI.MODEL.VitalSignInfoRt).%New()
	i (DateS="")||(DateE=""){
		s date=$o(^MR(Mradm,"OBS",0,"DateTime",""),-1)
		q:date="" stream.Write("-1^就诊号未采集生命体征")
		d Inse
	}else{
		f date=DateS:1:DateE{
			d Inse
		}
	}
	i VitalSignInfoRt.VitalSignInfoList.Count()=0{
		d stream.Write("-1^就诊号在指定日期内未采集体征信息")
		q stream
	}
	s VitalSignInfoRt.PATPatientID=$p($g(^PAPER(patID,"PAT",1)),"^")
	s VitalSignInfoRt.PAADMVisitNumber=admID
	s AdmDeptRowID=$P(admData,"^",4)    
	s hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
	s:hopitalId'="" VitalSignInfoRt.HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
	
	s Request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	s header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	s header.SourceSystem="02"
	s MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	s header.MessageID=MessageID
	s Request.header=header
	s body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	s body.VitalSignInfoRt=VitalSignInfoRt
	s Request.body=body
	d Request.XMLExportToStream(stream)
	q stream
Inse
	s time=""
	f{
		s time=$o(^MR(Mradm,"OBS",0,"DateTime",date,time))
		q:time=""
		s userCode=""
		s valueList=$lb("","","","","","","")
		s chl=""
		f{
			s chl=$O(^MR(Mradm,"OBS",0,"DateTime",date,time,chl))	//->MR_Observations
			q:chl=""
			s MRObservations=$g(^MR(Mradm,"OBS",chl))
			s ItemDr=$p(MRObservations,"^",1)
			s Value=$p(MRObservations,"^",2)
			s listNum=$lf(ItemDrList,ItemDr)
			s:listNum'=0 $list(valueList,listNum)=Value
			i userCode=""{
				s userDR=$p(MRObservations,"^",5)
				s userCode=$p($g(^SSU("SSUSR",userDR)),"^",1)
			}
		}
		s obj=##class(web.DHCENS.STBLL.EMPI.MODEL.VitalSignInfo).%New()
		s obj.Weight=$lg(valueList,7)
		s obj.Pulse=$lg(valueList,2)
		s obj.SystolicBP=$lg(valueList,4)
		s obj.DiastolicBP=$lg(valueList,5)
		s obj.Temperature=$lg(valueList,1)
		s obj.MeasureUserCode=userCode
		s obj.MeasureDate=$zd(date,3)
		s obj.MeasureTime=$zt(time)
		s obj.Height=$lg(valueList,6)
		d VitalSignInfoRt.VitalSignInfoList.Insert(obj)
	}
	q
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
