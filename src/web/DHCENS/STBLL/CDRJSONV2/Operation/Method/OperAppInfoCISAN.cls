Class web.DHCENS.STBLL.CDRJSONV2.Operation.Method.OperAppInfoCISAN Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:liyan
/// CreateDate: 2021-1-4
/// Description: 手术申请信息
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.OperAppInfo).CISANOperAppJson(3).Read()
ClassMethod CISANOperAppJson(opRowId As %String = "") As %GlobalCharacterStream
{
	set $ZT="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.paoperationapplication).%New()
	set subObj=..GetCISANOperApp(opRowId)  //获取CISAN包下手术申请信息
	d obj.paoperationapplicationList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.common.CommonMethod).ObjToJson(obj,"")
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
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Method.OperAppInfoCISAN).CISANOperAppGlobalhistory("1","18211")
ClassMethod CISANOperAppGlobalhistory(strRowId As %String, endRowId As %String) As %String
{
	set $zt="Exception"
	set operappjson=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationApplication).%New()
	set ^ExportHistoryData("paoperationapplication")=$lb("院内手术申请id","手术开始日期","手术开始时间","手术室","手术类型","是否重返手术","预计时长","拟施麻醉","申请医生代码","申请医生","申请科室代码","申请科室","申请日期","申请时间","术前诊断代码","术前诊断","术前诊断备注","abo血型","rh血型","hbsag","hcvab","hivab","梅毒","时间戳日期","时间戳时间","全局患者id","全局就诊id")
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set sum=endRowId-strRowId+1
	set opRowId="",con=0,strtime=$zt($p($now(),",",2))
	for opRowId=strRowId:1:endRowId{
		continue:$d(^CIS.AN.OperScheduleD(opRowId))=0
		set operappjson=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationApplication).%New()
		set operappjson=..GetCISANOperApp(opRowId) //获取CISAN包下手术申请
		set ^ExportHistoryData("paoperationapplication",opRowId)=$lb(opRowId,operappjson.paoastartdate,operappjson.paoastarttime,operappjson.paoaoperroom,operappjson.paoaopertype,
																	operappjson.paoaoperagainflag,operappjson.paoaoperlasttime,operappjson.paoaanesmethod,operappjson.paoaappdoccode,operappjson.paoaappdocname,
																	operappjson.paoaappdeptcode,operappjson.paoaappdeptdesc,operappjson.paoaappdate,operappjson.paoaapptime,operappjson.paoaprediagcode,
																	operappjson.paoaprediagdesc,operappjson.paoaprediagremark,operappjson.paoaabo,operappjson.paoarh,operappjson.paoahbsag,
																	operappjson.paoahcvab,operappjson.paoahivab,operappjson.paoasyphilis,operappjson.updatedate,operappjson.updatetime,
																	operappjson.papatrelpatientid,operappjson.paadmrelvisitnumber,operappjson.businessfieldcode,operappjson.paoareloperappid)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.common.common).point(strRowId, endRowId, con, opRowId)
	}
	
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

ClassMethod GetCISANOperApp(opRowId) As web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationApplication
{
	s sql="select * from cis_an.operschedule where rowid='"_opRowId_"'"
	s rset=##class(%Library.ResultSet).%New()
	d rset.Prepare(sql)
	s rset.RuntimeMode=1
	s sc=rset.Execute()
	while rset.Next() {
		s operappjson=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationApplication).%New()
		s businessfieldcode=operappjson.businessfieldcode
		s operappjson.paoastartdate=rset.Data("OperDate")
		s operappjson.paoastarttime=rset.Data("OperTime")
		s paoaoperroomdr=rset.Data("OperRoom")
		s operappjson.paoaoperroom=paoaoperroomdr
		s opertype=rset.Data("SourceType")
		s operappjson.paoaopertype=$Case(opertype,"B":"择期","D":"日间","E":"急诊",:"其他")
		s operappjson.paoaoperagainflag=rset.Data("ReentryOperation")
		s operappjson.paoaoperlasttime=rset.Data("OperDuration")
		s paoaanesmethoddr=rset.Data("PrevAnaMethod")
		s operappjson.paoaanesmethod=paoaanesmethoddr
		s operappdocdr=rset.Data("AppCareProvID")
		if +operappdocdr'=0 {
			s operappjson.paoaappdoccode=operappdocdr
			s operappjson.paoaappdocname=$p($g(^CTPCP(operappdocdr,1)),"^",2)
			}
		s operappdeptdr=rset.Data("AppDeptID")
		if +operappdeptdr'=0 {
			s operappjson.paoaappdeptcode=operappdeptdr
			s operappjson.paoaappdeptdesc=$p($g(^CTLOC(operappdeptdr)),"^",2)
		}
		s operappjson.paoaappdate=rset.Data("AppDate")
		s operappjson.paoaapptime=rset.Data("AppTime")
		s operappjson.paoaprediagcode=""
		s operappjson.paoaprediagdesc=""
		s operappjson.paoaprediagremark=rset.Data("PrevDiagnosis")
		s operappjson.paoaabo=rset.Data("BloodType")
		s operappjson.paoarh=rset.Data("RHBloodType")
		s operappjson.paoahbsag=rset.Data("HbsAg")
		s operappjson.paoahcvab=rset.Data("HcvAb")
		s operappjson.paoahivab=rset.Data("HivAb")
		s operappjson.paoasyphilis=rset.Data("Syphilis")
		s operappjson.paoahosoperappid=opRowId
		
		s operappjson.businessfieldcode=businessfieldcode
		s operappjson.updatedate=$zd(+$h,3)
		s operappjson.updatetime=$zt($p($h,",",2),1)
		s operappjson.paoareloperappid=businessfieldcode_"_"_opRowId
		s paadmvisitnumber=rset.Data("EpisodeID")
		s operappjson.paadmrelvisitnumber=businessfieldcode_"_"_paadmvisitnumber
		if +paadmvisitnumber'=0 s operappjson.papatrelpatientid=businessfieldcode_"_"_$p($g(^PAADM(paadmvisitnumber)),"^",1)
	}
	q operappjson
}

}
