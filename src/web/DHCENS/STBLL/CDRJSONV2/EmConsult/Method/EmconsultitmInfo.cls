Class web.DHCENS.STBLL.CDRJSONV2.EmConsult.Method.EmconsultitmInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2020-12-22
/// Description：根据id取会诊明细表(ACC0025)  //取DHC_Consultation表
/// Table：DHC_EmConsultItm
/// Input：会诊明细表rowid
/// Output：
/// Return：数据中心DHC_EmConsultItm医嘱(json)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.EmConsult.Method.EmconsultitmInfo).GetEMConsultItm("160||1")
ClassMethod GetEMConsultItm(ECItmRowID As %String) As %GlobalCharacterStream
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
	set subObj=..GetDHCConsultationitem(ECRowID) //取DHC_Consultation表
	d obj.dhcemconsultList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

ClassMethod GetDHCConsultationitem(RowID) As web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.DHCEmConsultitm
{
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.DHCEmConsultitm).%New()
	set businessfieldcode=subObj.businessfieldcode
	set allItem=$g(^User.DHCConsultationD(RowID))
	set ECCLocDr=$lg(allItem,11) 
#;	set:ECCLocDr'="" subObj.eccloccode=$p($g(^CTLOC(ECCLocDr)),"^",1) //会诊科室代码
	set subObj.eccloccode=ECCLocDr
	set ECNDocDr=$lg(allItem,12)
#;	set:ECNDocDr'="" subObj.ecndoccode=$p($g(^CTPCP(ECNDocDr,1)),"^",1) //要求会诊医生
	set subObj.ecndoccode=ECNDocDr 
	set eccdocDr=$lg(allItem,20)
#;	set:eccdocDr'="" subObj.eccdoccode=$p($g(^CTPCP(eccdocDr,1)),"^",1) //实际会诊医生
	set subObj.eccdoccode=eccdocDr
	set subObj.ecopinion=$lg(allItem,8) //会诊意见
	set subObj.ecunit="" //单位名称
	set subObj.ecexestatus=$lg(allItem,12) //执行状态
	set ECCDate=$lg(allItem,10)  //会诊日期
	set:ECCDate'="" subObj.eccdate=$zd(ECCDate,3)
	set ECCTime=$lg(allItem,13)  //会诊时间
	set:ECCTime'="" subObj.ecctime=$zt(ECCTime)
	set ECROeoriDr=$lg(allItem,34) ,ECRArcItmMastDr=""
	set:ECROeoriDr'="" ECRArcItmMastDr=$p($g(^OEORD($p(ECROeoriDr,"||",1),"I",$p(ECROeoriDr,"||",2),1)),"^",2)
	set:ECRArcItmMastDr'="" subObj.ecroeoridesc=$p($g(^ARCIM($p(ECRArcItmMastDr,"||",1),$p(ECRArcItmMastDr,"||",2),1)),"^",2) //申请医嘱描述
	set subObj.eccoeoridesc=subObj.ecroeoridesc //会诊医嘱描述
	set ECPrvTpDr=$lg(allItem,21)
	set:ECPrvTpDr'="" subObj.ecprvtpcode=$p($g(^CT("CPT",ECPrvTpDr)),"^",1) //会诊医生职称
	set subObj.ecgrpcode=$lg(allItem,27) //会诊小组
	set subObj.ecsubmarcode="" //亚专业
	set subObj.ecevaflag="" //评价标志
	set subObj.ecevadesc="" //评价内容
	set subObj.echositemrowid=RowID //院内会诊申请明细id

	set subObj.businessfieldcode=businessfieldcode //业务域代码
	set subObj.updatedate=$zd(+$h,3)
	set subObj.updatetime=$zt($p($h,",",2))
	set subObj.ecrelecconsitmid=businessfieldcode_"_"_RowID
	set AdmDr=$lg(allItem,2) ,PatDr="" 
	set:AdmDr'="" PatDr=$p($g(^PAADM(AdmDr)),"^",1)
	set:PatDr'="" subObj.papatrelpatientid=businessfieldcode_"_"_PatDr  //业务域_院内患者id
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_AdmDr         //业务域_院内就诊号
	set subObj.ecrelemconsultid=businessfieldcode_"_"_RowID //业务域_院内会诊申请id
	quit subObj
}

/// CreatDate：2020-12-22
/// Description：根据id取会诊明细表(ACC0025)历史数据Global
/// Table：DHC_EmConsultItm
/// Input：会诊明细表rowid
/// Output：
/// Return：数据中心DHC_EmConsultItm医嘱(Global)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.EmConsult.Method.EmconsultitmInfo).GetEMConsultItmGlobal("","")
ClassMethod GetEMConsultItmGlobal(strRowId As %String, endRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set ^ExportHistoryData("dhcemconsultitm")=$lb("院内会诊申请明细id","会诊科室","要求会诊医生","实际会诊医生","会诊意见","单位名称","执行状态","会诊日期","会诊时间","申请医嘱描述","会诊医嘱描述","会诊医生职称","会诊小组","亚专业","评价标志","评价内容","时间戳日期","时间戳时间","业务域_院内患者id","业务域_院内就诊号","业务域_院内会诊申请id")
	set ECRowID="",con=0,strtime=$zt($p($now(),",",2))
	for ECRowID=strRowId:1:endRowId
	{
		continue:$d(^User.DHCConsultationD(ECRowID))=0
		set subObj=..GetDHCConsultationitem(ECRowID) //取DHC_Consultation表
		set ^ExportHistoryData("dhcemconsultitm",ECRowID)=$lb(ECRowID,subObj.eccloccode,subObj.ecndoccode,subObj.eccdoccode,subObj.ecopinion,
															subObj.ecunit,subObj.ecexestatus,subObj.eccdate,subObj.ecctime,subObj.ecroeoridesc,
															subObj.eccoeoridesc,subObj.ecprvtpcode,subObj.ecgrpcode,subObj.ecsubmarcode,subObj.ecevaflag,
															subObj.ecevadesc,subObj.papatrelpatientid,subObj.paadmrelvisitnumber,subObj.ecrelemconsultid,
															subObj.businessfieldcode,subObj.ecrelecconsitmid)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strRowId, endRowId, con, ECRowID)		
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
