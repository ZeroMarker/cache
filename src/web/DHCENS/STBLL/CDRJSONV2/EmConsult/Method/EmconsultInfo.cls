Class web.DHCENS.STBLL.CDRJSONV2.EmConsult.Method.EmconsultInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2020-12-22
/// Description：根据id取会诊记录表(ACC0024) //取DHC_Consultation表
/// Table：DHC_EmConsult
/// Input：会诊记录rowid
/// Output：
/// Return：数据中心DHC_EmConsult会诊(json)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.EmConsult.Method.EmconsultInfo).GetEMConsult("160")
ClassMethod GetEMConsult(ECRowID As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.Data).%New()
	set obj.theme="theme001"
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.DHCEmConsult).%New()
	if (ECRowID="")||($d(^DHCEMCON(ECRowID))=0) {
		d stream.Write("{""theme"":""theme001"",""data"":[]}")
		quit stream	
	}
	set subObj=..GetDHCConsultation(ECRowID) //取DHC_Consultation表
	d obj.dhcemconsultList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

ClassMethod GetDHCConsultation(ECRowID) As web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.DHCEmConsult
{
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.DHCEmConsult).%New()
	set ConsultationInfo=$g(^User.DHCConsultationD(ECRowID))
	set AdmDr=$lg(ConsultationInfo,2),PatDr=""
	set:AdmDr'="" PatDr=$p($g(^PAADM(AdmDr)),"^",1)
	set ECRLocDr=$lg(ConsultationInfo,4)
#;	set:ECRLocDr'="" subObj.ecrloccode=$p($g(^CTLOC(ECRLocDr)),"^",1) //申请科室代码
	set subObj.ecrloccode=ECRLocDr
	set ECRDate=$lg(ConsultationInfo,3) 
	set:ECRDate'="" ECRDate=$zd(ECRDate,3)
	set subObj.ecrdate=ECRDate //申请日期
	set ECRTime=$lg(ConsultationInfo,6)
	set:ECRTime'="" ECRTime=$zt(ECRTime)
	set subObj.ecrtime=ECRTime
	set ECRUserDr=$lg(ConsultationInfo,5)
#;	set:ECRUserDr'="" subObj.ecrusercode=$p($g(^SSU("SSUSR",ECRUserDr)),"^",1) //申请医生
	set subObj.ecrusercode=ECRUserDr
	set ECTrePro=$p(ConsultationInfo,"^",6) 
	set subObj.ectrepro="" //病情及诊疗经过
	set ECPurpose=$lg(ConsultationInfo,36)
	set subObj.ecpurpose=ECPurpose //会诊的理由和目的
	set ECCategory=$lg(ConsultationInfo,9)
	set ECCategory=$case(ECCategory,"C":"普通","E":"急","M":"多科","A":"抗菌药",:"")
	set subObj.eccategory=ECCategory //会诊类别
	set ECDocLev=$lg(ConsultationInfo,21)
	set subObj.ecdoclev=ECDocLev //医生级别
	set ECNDate=$lg(ConsultationInfo,10)
	set:ECNDate'="" ECNDate=$zd(ECNDate,3)
	set subObj.ecndate=ECNDate //会诊日期
	set ECNTime=$lg(ConsultationInfo,13)
	set:ECNTime'="" ECNTime=$zt(ECNTime)
	set subObj.ecntime=ECNTime //会诊时间
	set ECNPlace=$lg(ConsultationInfo,31)
	set subObj.ecnplace=ECNPlace //会诊地点
	set subObj.ecaloccode="" //审核科室
	set subObj.ecausercode="" //审核人
	set subObj.ecadate=""        //审核日期
	set subObj.ecatime=""    //审核时间
	set subObj.ectremeasures=""   //最终治疗措施
	set subObj.ecrstatus=$lg(ConsultationInfo,16) //申请状态
	set subObj.ectype=ECCategory //会诊类型
	set ECCDate=$lg(ConsultationInfo,17)
	set:ECCDate'="" ECCDate=$zd(ECCDate,3)
	set subObj.eccdate=ECCDate //完成日期
	set ECCTime=$lg(ConsultationInfo,18)
	set:ECCTime'="" ECCTime=$zt(ECCTime)
	set subObj.ecctime=ECCTime //完成时间
	set ECCUserDr=$lg(ConsultationInfo,19)
	set subObj.eccusercode=ECCUserDr
	set subObj.ecemflag="" //是否加急
	set:ECCategory="急" subObj.ecemflag="Y"
	set ECOutFlag=$lg(ConsultationInfo,14) 
	set ECOutFlag=$case(ECOutFlag,"I":"院内","O":"院外",:"")
	set subObj.ecoutflag=ECOutFlag  //是否院外
	set subObj.ecunit="" //外院名称
	set subObj.ecdocname="" //外院医师
	set subObj.ecremark="" //备注
	set subObj.ecconsuser="" //联系人
	set subObj.ecconsphone="" //联系电话
	set subObj.ecshareflag="" //是否共享
	set subObj.ecmoredepflag="" //是否多科
	set:ECCategory="多科" subObj.ecmoredepflag="Y"
	set subObj.ecmedcaltangle="" //是否有医疗纠纷
	set subObj.eccurquestion="" //目前存在问题
	set subObj.ecopintion=$lg(ConsultationInfo,8)  //会诊意见
	set subObj.ecconsentanti="" //是否同意使用抗生素
	set subObj.ecordwriteflag="" //是否开启医嘱录入
	set subObj.ecprintflag="" //打印标志
	set subObj.ecunitdept="" //外院科室
	set subObj.ecevaflag="" //评价标志
	set subObj.ecevadesc="" //评价内容
	set subObj.echosemconsultid=ECRowID //
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode //业务域代码
	set subObj.updatedate=$zd(+$h,3)
	set subObj.updatetime=$zt($p($h,",",2))
	
	set subObj.ecrelemconsultid=businessfieldcode_"_"_ECRowID
	set:PatDr'="" subObj.papatrelpatientid=businessfieldcode_"_"_PatDr //业务域_院内患者id
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_AdmDr         //业务域_院内就诊号
	quit subObj
}

/// Creator：ZhangXinying
/// CreatDate：2020-12-22
/// Description：根据id取会诊记录表(ACC0024)历史数据 Global
/// Table：DHC_EmConsult
/// Input：会诊记录rowid
/// Output：
/// Return：数据中心DHC_EmConsult会诊(Global)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.EmConsult.Method.EmconsultInfo).GetEMConsultGlobal("1","3895")
ClassMethod GetEMConsultGlobal(strRowId As %String, endRowId As %String) As %String
{
	set $zt="Exception"
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set sum=endRowId-strRowId+1
	set ^ExportHistoryData("dhcemconsult")=$lb("院内会诊申请id","申请科室代码","申请日期","申请时间","申请医生","病情及诊疗经过","会诊的理由和目的","会诊类别","医生级别","会诊日期","会诊时间","会诊地点","审核科室","审核人","审核日期","审核时间","最终治疗措施","申请状态","会诊类型","完成日期","完成时间","完成人","是否加急","是否院外","外院名称","外院医师","备注","联系人","联系电话","是否共享","是否多科","是否有医疗纠纷","目前存在问题","会诊意见","是否同意使用抗生素","是否开启医嘱录入","打印标志","外院科室","评价标志","评价内容","时间戳日期","时间戳时间","业务域_院内患者id","业务域_院内就诊号")
	set ECRowID="",con=0,strtime=$zt($p($now(),",",2))
	for ECRowID=strRowId:1:endRowId
	{
		continue:$d(^User.DHCConsultationD(ECRowID))=0
		set subObj=..GetDHCConsultation(ECRowID) //取DHC_Consultation表
		set ^ExportHistoryData("dhcemconsult",ECRowID)=$lb(ECRowID,subObj.ecrloccode,subObj.ecrdate,subObj.ecrtime,subObj.ecrusercode,
														subObj.ectrepro,subObj.ecpurpose,subObj.eccategory,subObj.ecdoclev,subObj.ecndate,
														subObj.ecntime,subObj.ecnplace,subObj.ecaloccode,subObj.ecausercode,subObj.ecadate,
														subObj.ecatime,subObj.ectremeasures,subObj.ecrstatus,subObj.ectype,subObj.eccdate,
														subObj.ecctime,subObj.eccusercode,subObj.ecemflag,subObj.ecoutflag,subObj.ecunit,
														subObj.ecdocname,subObj.ecremark,subObj.ecconsuser,subObj.ecconsphone,subObj.ecshareflag,
														subObj.ecmoredepflag,subObj.ecmedcaltangle,subObj.eccurquestion,subObj.ecopintion,subObj.ecconsentanti,
														subObj.ecordwriteflag,subObj.ecprintflag,subObj.ecunitdept,subObj.ecevaflag,subObj.ecevadesc,
														subObj.papatrelpatientid,subObj.paadmrelvisitnumber,subObj.businessfieldcode,subObj.ecrelemconsultid)
														
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strRowId, endRowId, con, ECRowID)		
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
