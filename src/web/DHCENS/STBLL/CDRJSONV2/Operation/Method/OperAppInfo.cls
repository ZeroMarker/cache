Class web.DHCENS.STBLL.CDRJSONV2.Operation.Method.OperAppInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:liyan
/// CreateDate: 2021-1-4
/// Description: 手术申请信息 获取DHC_AN_OPArrange表手术申请信息
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Method.OperAppInfo).CISANOperApp(3).Read()
ClassMethod CISANOperApp(opRowId As %String = "") As %GlobalCharacterStream
{
	set $ZT="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationApplication).%New()
	set subObj=..GetOperAppDHCANOPArrange(opRowId) //获取DHC_AN_OPArrange表手术申请信息
	d obj.paoperationapplicationList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

/// Creator:liyan
/// CreateDate: 2021-1-4
/// Description: 手术申请信息 历史数据 Global
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Method.OperAppInfo).CISANOperAppGlobalhistory("1","126482")
ClassMethod CISANOperAppGlobalhistory(strRowId As %String, endRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set ^ExportHistoryData("paoperationapplication")=$lb("院内手术申请id","手术开始日期","手术开始时间","手术室","手术类型","是否重返手术","预计时长","拟施麻醉","申请医生代码","申请医生","申请科室代码","申请科室","申请日期","申请时间","术前诊断代码","术前诊断","术前诊断备注","abo血型","rh血型","hbsag","hcvab","hivab","梅毒","时间戳日期","时间戳时间","全局患者id","全局就诊id")
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set sum=endRowId-strRowId+1
	set opRowId="",con=0,strtime=$zt($p($now(),",",2))
	for opRowId=strRowId:1:endRowId{
		continue:$d(^DHCANOPArrange(opRowId))=0
		set operappjson=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationApplication).%New()
		set operappjson=..GetOperAppDHCANOPArrange(opRowId) //获取DHC_AN_OPArrange表手术申请信息
		set ^ExportHistoryData("paoperationapplication",opRowId)=$lb(opRowId,operappjson.paoastartdate,operappjson.paoastarttime,operappjson.paoaoperroom,operappjson.paoaopertype,
																	operappjson.paoaoperagainflag,operappjson.paoaoperlasttime,operappjson.paoaanesmethod,operappjson.paoaappdoccode,operappjson.paoaappdocname,
																	operappjson.paoaappdeptcode,operappjson.paoaappdeptdesc,operappjson.paoaappdate,operappjson.paoaapptime,operappjson.paoaprediagcode,
																	operappjson.paoaprediagdesc,operappjson.paoaprediagremark,operappjson.paoaabo,operappjson.paoarh,operappjson.paoahbsag,
																	operappjson.paoahcvab,operappjson.paoahivab,operappjson.paoasyphilis,operappjson.updatedate,operappjson.updatetime,
																	operappjson.papatrelpatientid,operappjson.paadmrelvisitnumber,operappjson.businessfieldcode,operappjson.paoareloperappid)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strRowId, endRowId, con, opRowId)
	}
	
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

ClassMethod GetOperAppDHCANOPArrange(opRowId) As web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationApplication
{
	Try
	{
		s operappjson=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationApplication).%New()
		s businessfieldcode=operappjson.businessfieldcode
		s ANARowId=$P(^DHCANOPArrange(opRowId),"^",2) 
		s EpisodeID=+ANARowId
		s anaSub=$p(ANARowId,"||",2)
		s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP", ""),-1)
		s operappjson.paoastartdate=$P(^DHCANOPArrange(opRowId),"^",14)  //手术开始日期
		s:operappjson.paoastartdate'="" operappjson.paoastartdate=$zd(operappjson.paoastartdate,3)
		s operappjson.paoastarttime=$P(^DHCANOPArrange(opRowId),"^",15)  //手术开始时间
		s:operappjson.paoastarttime'="" operappjson.paoastarttime=$zt(operappjson.paoastarttime)
		s OPAOpRoom=$P(^DHCANOPArrange(opRowId),"^",20)        
	#;	s:OPAOpRoom'="" OPAOpRoom=$p(^DHCANC("OPRoom",OPAOpRoom),"^",1) 
		s operappjson.paoaoperroom=OPAOpRoom //手术间
		s opertype=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)
		s operappjson.paoaopertype=$Case(opertype,"B":"择期","D":"日间","E":"急诊",:"其他")  //手术类型
		s operappjson.paoaoperagainflag=""   //是否重返手术
		s operappjson.paoaoperlasttime=""  //预计时长
		s paoaanesmethod=$P($g(^OR(EpisodeID,"ANA",anaSub)),"^",5)
	#;	s:paoaanesmethod'="" paoaanesmethod=$p($g(^ORC("ANMET",paoaanesmethod)),"^",2)
		s operappjson.paoaanesmethod=paoaanesmethod   //拟施麻醉
		s operappdocdr=$P(^DHCANOPArrange(opRowId),"^",6)
		s operappjson.paoaappdoccode=""
		s operappjson.paoaappdocname=""
		if +operappdocdr'=0 {
	#;		s operappjson.paoaappdoccode=$p($g(^CTPCP(operappdocdr,1)),"^",1)  //申请医生代码
			s operappjson.paoaappdoccode=operappdocdr
			s operappjson.paoaappdocname=$p($g(^CTPCP(operappdocdr,1)),"^",2)  //申请医生
			}
		s operappdeptdr=$P(^PAADM(EpisodeID),"^",4)
		s operappjson.paoaappdeptcode=""
		s operappjson.paoaappdeptdesc=""
		if +operappdeptdr'=0 {
	#;		s operappjson.paoaappdeptcode=$p($g(^CTLOC(operappdeptdr)),"^",1)  //申请科室代码
			s operappjson.paoaappdeptcode=operappdeptdr
			s operappjson.paoaappdeptdesc=$p($g(^CTLOC(operappdeptdr)),"^",2)  //申请科室
		}
		s operappjson.paoaappdate=$P(^DHCANOPArrange(opRowId),"^",3)
		s:operappjson.paoaappdate'="" operappjson.paoaappdate=$zd(operappjson.paoaappdate,3)
		s operappjson.paoaapptime=$P(^DHCANOPArrange(opRowId),"^",5)
		s:operappjson.paoaapptime'="" operappjson.paoaapptime=$zt(operappjson.paoaapptime)
		s paoaprediag=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub)),"^",4) 
		s operappjson.paoaprediagcode=""
		s operappjson.paoaprediagdesc=""
		s operappjson.paoaprediagremark=$g(^OR(EpisodeID,"ANA", anaSub,"TXT",2)) //术前诊断备注
		if +paoaprediag'=0 {
	#;		s operappjson.paoaprediagcode=$p($g(^MRC("ID",paoaprediag)),"^",1)  //术前诊断代码
			s operappjson.paoaprediagcode=paoaprediag
			s operappjson.paoaprediagdesc=$p($g(^MRC("ID",paoaprediag)),"^",2)  //术前诊断
			}
		s paoaabo=$P(^DHCANOPArrange(opRowId),"^",11) 
	#;	s:paoaabo='"" paoaabo=$p(^PAC("BLDT",paoaabo),"^",2)
		s operappjson.paoaabo=paoaabo  //abo血型
		s operappjson.paoarh=$P(^DHCANOPArrange(opRowId),"^",25)   //Rh血型
		s operappjson.paoahbsag=$P($g(^DHCANOPArrange("PALab",opRowId)),"^",29)
		s operappjson.paoahcvab=$P($g(^DHCANOPArrange("PALab",opRowId)),"^",34)
		s operappjson.paoahivab=$P($g(^DHCANOPArrange("PALab",opRowId)),"^",35)
		s operappjson.paoasyphilis=$P($g(^DHCANOPArrange("PALab",opRowId)),"^",36)
		s operappjson.paoahosoperappid=opRowId
		
		s operappjson.businessfieldcode=businessfieldcode
		s operappjson.updatedate=$zd(+$h,3)
		s operappjson.updatetime=$zt($p($h,",",2),1)
		s operappjson.paoareloperappid=businessfieldcode_"_"_opRowId
		s paadmvisitnumber=EpisodeID
		s operappjson.paadmrelvisitnumber=businessfieldcode_"_"_paadmvisitnumber
		if +paadmvisitnumber'=0 s operappjson.papatrelpatientid=businessfieldcode_"_"_$p($g(^PAADM(paadmvisitnumber)),"^",1)
	}
	catch
	{
		s operappjson=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationApplication).%New()
	}
	q operappjson
}

}
