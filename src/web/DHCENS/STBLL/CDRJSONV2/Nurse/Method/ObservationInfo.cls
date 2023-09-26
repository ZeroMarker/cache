Class web.DHCENS.STBLL.CDRJSONV2.Nurse.Method.ObservationInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2020-12-22
/// Description：根据id取生命体征信息表(ACC0023)
/// Table：MR_Observations（体征数据），MRC_ObservationItem（体征项目字典）
/// Input：体征数据表rowid
/// Output：
/// Return：数据中心体征数据(json)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.Nurse.Method.ObservationInfo).GetVitalSign("577363||57")
ClassMethod GetVitalSign(MROBSID As %String) As %String
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.Nurse.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Nurse.Model.PAObservations).%New()
	set MrAdm=$p(MROBSID,"||",1),MrOBSSub=$p(MROBSID,"||",2)
	set AdmDr=$p($g(^MR(MrAdm,"PRO",1)),"^",9)
	set PatDr=$p($g(^PAADM(AdmDr)),"^",1)
	set MRObservations=$g(^MR(MrAdm,"OBS",MrOBSSub))
	if (MROBSID="")||($d(^MR(MrAdm,"OBS",MrOBSSub))=0) {
		d stream.Write("{""theme"":""theme001"",""data"":[]}")
		quit stream	
	}
	set subObj=..GetObservation(MROBSID)
	d obj.paobservationsList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

ClassMethod GetObservation(MROBSID) As web.DHCENS.STBLL.CDRJSONV2.Nurse.Model.PAObservations
{
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Nurse.Model.PAObservations).%New()
	set businessfieldcode=subObj.businessfieldcode
	set MrAdm=$p(MROBSID,"||",1),MrOBSSub=$p(MROBSID,"||",2)
	set AdmDr=$p($g(^MR(MrAdm,"PRO",1)),"^",9)
	set PatDr=$p($g(^PAADM(AdmDr)),"^",1)
	set MRObservations=$g(^MR(MrAdm,"OBS",MrOBSSub))
	//set subObj=##class(%DynamicObject).%New()
	s ItemDr=$p(MRObservations,"^",1)
	s Value=$p(MRObservations,"^",2)
#;	s:ItemDr'="" subObj.paoobsercode=$p($g(^MRC("OBITM",ItemDr)),"^",1) //测量项目代码
	s subObj.paoobsercode=ItemDr
	s OBSDate=$p(MRObservations,"^",3)
	s:OBSDate'="" subObj.paoobserupdatedate=$zd(OBSDate,3) //测量日期
	s OBSTime=$p(MRObservations,"^",4)
	s:OBSTime'="" subObj.paoobserupdatetime=$zt(OBSTime) //测量时间
	s OBSUserDr=$p(MRObservations,"^",5)
#;	s:OBSUserDr'="" subObj.paoobserupdateusercode=$p($g(^SSU("SSUSR",OBSUserDr)),"^",1) //测量人编码
	set subObj.paoobserupdateusercode=OBSUserDr
	set subObj.updatedate=$zd(+$h,3)
	set subObj.updatetime=$zt($p($h,",",2))
	set subObj.paoobservalue=Value //测量项目数值
	set subObj.paohosobserid=MROBSID //医院内部生命体征id
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_AdmDr //全局就诊id
	set:PatDr'="" subObj.papatrelpatientid=businessfieldcode_"_"_$p($g(^PAPER(PatDr,"PAT",1)),"^",1)
	set subObj.paorelobserid=businessfieldcode_"_"_MROBSID
	quit subObj
}

/// Creator：ZhangXinying
/// CreatDate：2020-12-22
/// Description：根据id取生命体征信息表(ACC0023)历史数据Global
/// Table：MR_Observations（体征数据），MRC_ObservationItem（体征项目字典）
/// Input：体征数据表rowid
/// Output：
/// Return：数据中心体征数据(Global)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.Nurse.Method.ObservationInfo).GetVitalSignGlobal("1","6314734")
ClassMethod GetVitalSignGlobal(stradmRowId As %String, endadmRowId As %String) As %String
{
	set $zt="Exception"
	set ^ExportHistoryData("paobservations")=$lb("生命体征id","测量项目代码","测量日期","测量时间","测量人编码","时间戳","时间戳","测量项目数值","全局就诊id","全局患者id")
	if (stradmRowId="")||(endadmRowId="") {
		quit "-1^id不能为空"	
	}
	set admRowId="",con=0,strtime=$zt($p($now(),",",2))
	for admRowId=stradmRowId:1:endadmRowId
	{
		continue:$d(^PAADM(admRowId))=0
		continue:$d(^MR(admRowId,"OBS"))=0
		set OBSsub=""
		for {
			set OBSsub=$o(^MR(admRowId,"OBS",OBSsub))
			q:OBSsub=""
			set MROBSID = admRowId_"||"_OBSsub
			set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Nurse.Model.PAObservations).%New()
			set subObj=..GetObservation(MROBSID)	
			set ^ExportHistoryData("paobservations",MROBSID)=$lb(MROBSID,subObj.paoobsercode,subObj.paoobserupdatedate,subObj.paoobserupdatetime,subObj.paoobserupdateusercode,
															subObj.updatedate,subObj.updatetime,subObj.paoobservalue,subObj.paadmrelvisitnumber,subObj.papatrelpatientid,
															subObj.businessfieldcode,subObj.paorelobserid)
			set con=con+1
			set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(stradmRowId, endadmRowId, con, admRowId)
		}
			
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
