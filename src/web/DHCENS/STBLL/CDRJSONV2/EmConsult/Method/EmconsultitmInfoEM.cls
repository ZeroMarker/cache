Class web.DHCENS.STBLL.CDRJSONV2.EmConsult.Method.EmconsultitmInfoEM Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2020-12-22
/// Description：根据id取会诊明细表(ACC0025)
/// Table：DHC_EmConsultItm
/// Input：会诊明细表rowid
/// Output：
/// Return：数据中心DHC_EmConsultItm医嘱(json)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.EmConsult.Method.EmconsultitmInfoEM).GetEMConsultItmJSON("94241||1").Read()
ClassMethod GetEMConsultItmJSON(ECItmRowID As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.Data).%New()
	set ECRowID=$p(ECItmRowID,"||",1),ECItmSub=$p(ECItmRowID,"||",2)
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.DHCEmConsultitm).%New()
	if (ECItmRowID="")||($d(^DHCEMCON(ECRowID,"I",ECItmSub))=0) {
		d stream.Write("{""theme"":""theme001"",""data"":[]}")
		quit stream	
	}
	set subObj=..GetEMConsultItm(ECItmRowID)  //取DHC_EmConsultItm表
	d obj.dhcemconsultList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

/// CreatDate：2020-12-22
/// Description：根据id取会诊明细表(ACC0025)历史数据Global
/// Table：DHC_EmConsultItm
/// Input：会诊明细表rowid
/// Output：
/// Return：数据中心DHC_EmConsultItm医嘱(Global)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.EmConsult.Method.EmconsultitmInfoEM).GetEMConsultItmGlobalhistory("1","95587")
ClassMethod GetEMConsultItmGlobalhistory(strRowId As %String, endRowId As %String) As %String
{
	set $zt="Exception"
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.DHCEmConsultitm).%New()
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set sum=endRowId-strRowId+1
	set ^ExportHistoryData("dhcemconsultitm")=$lb("院内会诊申请明细id","会诊科室","要求会诊医生","实际会诊医生","会诊意见","单位名称","执行状态","会诊日期","会诊时间","申请医嘱描述","会诊医嘱描述","会诊医生职称","会诊小组","亚专业","评价标志","评价内容","时间戳日期","时间戳时间","业务域_院内患者id","业务域_院内就诊号","业务域_院内会诊申请id")
	set ECRowID="",con=0,strtime=$zt($p($now(),",",2))
	for ECRowID=strRowId:1:endRowId
	{
		continue:$d(^DHCEMCON(ECRowID))=0
		set ECItmSub=0
		for {
			set ECItmSub=$o(^DHCEMCON(ECRowID,"I",ECItmSub))
			quit:ECItmSub=""
			set ECItmRowID=ECRowID_"||"_ECItmSub
			set subObj=..GetEMConsultItm(ECItmRowID)  //取DHC_EmConsultItm表
		set ^ExportHistoryData("dhcemconsultitm",ECRowID)=$lb(ECRowID,subObj.eccloccode,subObj.ecndoccode,subObj.eccdoccode,subObj.ecopinion,
															subObj.ecunit,subObj.ecexestatus,subObj.eccdate,subObj.ecctime,subObj.ecroeoridesc,
															subObj.eccoeoridesc,subObj.ecprvtpcode,subObj.ecgrpcode,subObj.ecsubmarcode,subObj.ecevaflag,
															subObj.ecevadesc,subObj.papatrelpatientid,subObj.paadmrelvisitnumber,subObj.ecrelemconsultid,
															subObj.businessfieldcode,subObj.ecrelecconsitmid)
			set con=con+1
			set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strRowId, endRowId, con, ECRowID)		
		}
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

ClassMethod GetEMConsultItm(ECItmRowID) As web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.DHCEmConsultitm
{
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.DHCEmConsultitm).%New()
	set businessfieldcode=subObj.businessfieldcode
	set ECRowID=$p(ECItmRowID,"||",1),ECItmSub=$p(ECItmRowID,"||",2)
	set ConsultItmInfo=$g(^DHCEMCON(ECRowID,"I",ECItmSub))
	set ECCLocDr=$p(ConsultItmInfo,"^",1) 
#;	set:ECCLocDr'="" subObj.eccloccode=$p($g(^CTLOC(ECCLocDr)),"^",1) //会诊科室代码
	set subObj.eccloccode=ECCLocDr
	set ECNDocDr=$p(ConsultItmInfo,"^",2) 
#;	set:ECNDocDr'="" subObj.ecndoccode=$p($g(^CTPCP(ECNDocDr,1)),"^",1) //要求会诊医生
	set subObj.ecndoccode=ECNDocDr
	set ECCDocDr=$p(ConsultItmInfo,"^",3) 
#;	set:ECCDocDr'="" subObj.eccdoccode=$p($g(^CTPCP(ECCDocDr,1)),"^",1) //要求会诊医生
	set subObj.eccdoccode=ECCDocDr
	set subObj.ecopinion=$p(ConsultItmInfo,"^",4) //会诊意见
	set subObj.ecunit=$p(ConsultItmInfo,"^",5) //单位名称
	set subObj.ecexestatus=$p(ConsultItmInfo,"^",6) //执行状态
	set ECCDate=$p(ConsultItmInfo,"^",7) //会诊日期
	set:ECCDate'="" subObj.eccdate=$zd(ECCDate,3)
	set ECCTime=$p(ConsultItmInfo,"^",8) //会诊时间
	set:ECCTime'="" subObj.ecctime=$zt(ECCTime)
	set ECROeoriDr=$p(ConsultItmInfo,"^",9),ECRArcItmMastDr=""
	set:ECROeoriDr'="" ECRArcItmMastDr=$p($g(^OEORD($p(ECROeoriDr,"||",1),"I",$p(ECROeoriDr,"||",2),1)),"^",2)
	set:ECRArcItmMastDr'="" subObj.ecroeoridesc=$p($g(^ARCIM($p(ECRArcItmMastDr,"||",1),$p(ECRArcItmMastDr,"||",2),1)),"^",2) //申请医嘱描述
	set ECCOeoriDr=$p(ConsultItmInfo,"^",10),ECCArcItmMastDr=""
	set:ECCOeoriDr'="" ECCArcItmMastDr=$p($g(^OEORD($p(ECCOeoriDr,"||",1),"I",$p(ECCOeoriDr,"||",2),1)),"^",2)
	set:ECCArcItmMastDr'="" subObj.eccoeoridesc=$p($g(^ARCIM($p(ECCArcItmMastDr,"||",1),$p(ECCArcItmMastDr,"||",2),1)),"^",2) //会诊医嘱描述
	set ECPrvTpDr=$p(ConsultItmInfo,"^",11)
#;	set:ECPrvTpDr'="" subObj.ecprvtpcode=$p($g(^CT("CPT",ECPrvTpDr)),"^",1) //会诊医生职称
	set subObj.ecprvtpcode=ECPrvTpDr
	set ECGrpDr=$p(ConsultItmInfo,"^",12)
#;	set:ECGrpDr'="" subObj.ecgrpcode=$p($g(^DHCEMCG(ECGrpDr)),"^",1) //会诊小组
	set subObj.ecgrpcode=ECGrpDr
	set ECSubMarDr=$p(ConsultItmInfo,"^",13)
	set:ECSubMarDr'="" subObj.ecsubmarcode=$p($g(^DHCEMCG(ECSubMarDr)),"^",1) //亚专业
	set subObj.ecevaflag=$p(ConsultItmInfo,"^",14) //评价标志
	set subObj.ecevadesc=$p(ConsultItmInfo,"^",15) //评价内容
	set subObj.echositemrowid=ECItmRowID //院内会诊申请明细id
	set subObj.businessfieldcode=businessfieldcode //业务域代码
	set subObj.updatedate=$zd(+$h,3)
	set subObj.updatetime=$zt($p($h,",",2))
	set subObj.ecrelecconsitmid=businessfieldcode_"_"_ECItmRowID
	set AdmDr=$p($g(^DHCEMCON(ECRowID)),"^",1),PatDr="" 
	set PatDr=$p($g(^PAADM(AdmDr)),"^",1)
	set:PatDr'="" subObj.papatrelpatientid=businessfieldcode_"_"_PatDr  //业务域_院内患者id
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_AdmDr         //业务域_院内就诊号
	set subObj.ecrelemconsultid=businessfieldcode_"_"_ECRowID //业务域_院内会诊申请id
	quit subObj
}

}
