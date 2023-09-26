Class web.DHCENS.STBLL.MDMR2.Method.CTCareProv Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步医护人员字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTCareProv).SendCTCareProv().Read()
ClassMethod SendCTCareProv(input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	s returnStream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s mainJson=##class(%DynamicObject).%New()
	s reqJson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s plist=##class(%ArrayOfDataTypes).%New()
	s businessfieldcode=..#BusinessFieldCode
	s retStream=##class(%GlobalCharacterStream).%New()
	s id=0,num=1
	f {
		s id=$o(^CTPCP(id))
		q:id=""
		d plist.SetAt(id,num)
		s num=num+1
		if num>100
		{
			s datas=..GetCTCareProvByID(plist)
			s reqJson."data"=datas
			s reqJson."tableCode"="ct_careprov"
			s mainJson."request"=reqJson
			s jsonStr=mainJson.%ToJSON()
			d retStream.Write(jsonStr)
			s returnStream=..PostCTCareProvBatch(retStream)
			do plist.Clear()
			s num=1
		}
	}
	
	set length=plist.Count()
	if length>0 
	{
		set datas=..GetCTCareProvByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="ct_careprov"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostCTCareProvBatch(retStream)
	}
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetCTCareProvByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetCTCareProvJson(rowid)
			d dataArr.%Push(json)
		}	
	}
	catch
	{
		s $zt=""	
	}
	q dataArr
}

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：获取医护人员字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTCareProv).GetCTCareProvJson()
ClassMethod GetCTCareProvJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s businessfieldcode=..#BusinessFieldCode
	s ctcpCode=$p($g(^CTPCP(id,1)),"^",1)
	s ctcpDesc=$p($g(^CTPCP(id,1)),"^",2)
	s ctcpOtName=$p($g(^CTPCP(id,3)),"^",28)
	s ctcpDOB=$p($g(^CTPCP(id,3)),"^",5)
	s:ctcpDOB'="" ctcpDOB=$zd(ctcpDOB,3)
	s ctcpTitleDr=$p($g(^CTPCP(id,3)),"^",29),ctcpTitleCode=""
	s:ctcpTitleDr'="" ctcpTitleCode=$p($g(^CT("TTL",ctcpTitleDr)),"^",1)
	s ctcpTpDr=$p($g(^CTPCP(id,1)),"^",4),ctcpTpCode=""
	s:ctcpTpDr'="" ctcpTpCode=$p($g(^CT("CPT",ctcpTpDr)),"^",1)
	s locDr=$p($g(^CTPCP(id,3)),"^",3),deptCode=""
	s:locDr'="" deptCode=$p($g(^CTLOC(locDr)),"^",1)
	s ctcpMobile=$p($g(^CTPCP(id,3)),"^",6)
	s stDate=$p($g(^CTPCP(id,2)),"^",14)
	s:stDate'="" stDate=$zd(stDate,3)
	s edDate=$p($g(^CTPCP(id,2)),"^",15)
	s:edDate'="" edDate=$zd(edDate,3)
	s updDate=$p($g(^CTPCP(id,3)),"^",22)
	s:updDate'="" updDate=$zd(updDate,3)
	s updTime=$p($g(^CTPCP(id,3)),"^",23)
	s:updTime'="" updTime=$zt(updTime)
	s updUserDr=$p($g(^CTPCP(id,3)),"^",24),updUserCode=""
	s:updUserDr'="" updUserCode=$p($g(^SSU("SSUSR",updUserDr)),"^",1)
	s email=$p($g(^CTPCP(id,3)),"^",9)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("ctcp_code",ctcpCode)
	d subjson.%Set("ctcp_jobnumber",ctcpCode)
	d subjson.%Set("ctcp_desc",ctcpDesc)
	d subjson.%Set("ctcp_name",ctcpDesc)
	d subjson.%Set("ctcp_spell",ctcpOtName)
	d subjson.%Set("ctcp_sexcode","")
	d subjson.%Set("ctcp_birthdate",ctcpDOB)
	d subjson.%Set("ctcp_idcardno","")
	d subjson.%Set("ctcp_titleoftechcode",ctcpTitleCode)
	d subjson.%Set("ctcp_stafftypecode","")
	d subjson.%Set("ctcp_careprovpositioncode","")
	d subjson.%Set("ctcp_careprovtypecode",ctcpTpCode)
	d subjson.%Set("ctcp_deptcode",deptCode)
	d subjson.%Set("ctcp_birthplace","")
	d subjson.%Set("ctcp_codesystemcode","ct_careprov")
	d subjson.%Set("ctcp_remarks","")
	d subjson.%Set("ctcp_extraneturl","")
	d subjson.%Set("ctcp_intraneturl","")
	d subjson.%Set("ctcp_extraneturl","")
	d subjson.%Set("ctcp_password","")
	d subjson.%Set("ctcp_startdate",stDate)
	d subjson.%Set("ctcp_enddate",edDate)
	d subjson.%Set("ctcp_creatdate","")
	d subjson.%Set("ctcp_creattime","")
	d subjson.%Set("ctcp_telephone",ctcpMobile)
	d subjson.%Set("ctcp_depthierarchycode","")
	d subjson.%Set("ctcp_updateusercode",updUserCode)
	d subjson.%Set("ctcp_status","1")
	d subjson.%Set("ctcp_imageinfo","")
	d subjson.%Set("ctcp_email",email)
	d subjson.%Set("ctcp_updatedate",updDate)
	d subjson.%Set("ctcp_updatetime",updTime)
	d subjson.%Set("ctcp_nationcode","")
	d subjson.%Set("ctcp_employmentdate","")
	d subjson.%Set("ctcp_educationcode","")
	d subjson.%Set("ctcp_adminiposition","")
	d subjson.%Set("ctcp_praccerticode","")
	d subjson.%Set("ctcp_qualicerticode","")
	d subjson.%Set("ctcp_updateusercode","")
	d subjson.%Set("ctcp_titleemploydate","")
	d subjson.%Set("ctcp_currdeptdate","")
	d subjson.%Set("ctcp_positionseqcode","")
	d subjson.%Set("ctcp_arrivalhosdate","")
	d subjson.%Set("ctcp_retiredate","")
	d subjson.%Set("ctcp_urbanregiresiflag","")
	d subjson.%Set("ctcp_politicalaffiliation","")
	d subjson.%Set("ctcp_politicaljoindate","")
	d subjson.%Set("ctcp_nativeplace","")
	d subjson.%Set("ctcp_registresidence","")
	d subjson.%Set("ctcp_staffcat",ctcpMobile)
	d subjson.%Set("ctcp_titleoftechlevel","")
	d subjson.%Set("ctcp_idcardtypecode","")
	d subjson.%Set("ctcp_workorgcode","")
	d subjson.%Set("ctcp_maritalcode","")
	d subjson.%Set("ctcp_degreecode","")
	d subjson.%Set("ctcp_workyears","")
	d subjson.%Set("ctcp_speccerticode","")
	d subjson.%Set("ctcp_practicearea","")
	d subjson.%Set("ctcp_practicestartdate","")
	d subjson.%Set("ctcp_practiceenddate","")
	d subjson.%Set("ctcp_praccertiregaddress","")
	d subjson.%Set("ctcp_docpraccatcode","")
	d subjson.%Set("ctcp_nurpraccatcode","")
	d subjson.%Set("ctcp_pracstartdateinhos","")
	d subjson.%Set("ctcp_prescriptionflag","")
	d subjson.%Set("ctcp_prescriptionpflag","")
	d subjson.%Set("ctcp_prescriptionaflag","")
	d subjson.%Set("ctcp_prescriptionmflag","")
	d subjson.%Set("ctcp_prescriptionrflag","")
	d subjson.%Set("ctcp_prescriptionsflag","")
	d subjson.%Set("ctcp_subjectcat","")
	d subjson.%Set("ctcp_firstsubject","")
	d subjson.%Set("ctcp_formtype","")
	d subjson.%Set("ctcp_pracstatus","")
	d subjson.%Set("ctcp_specializein","")
	d subjson.%Set("ctcp_familynamespell","")
	d subjson.%Set("ctcp_firstnamespell","")
	d subjson.%Set("ctcp_workinhosreason","")
	d subjson.%Set("ctcp_learnsource","")
	d subjson.%Set("ctcp_adminilevel","")
	d subjson.%Set("ctcp_stafflevel","")
	d subjson.%Set("ctcp_identitytype","")
	d subjson.%Set("ctcp_employmode","")
	d subjson.%Set("ctcp_positionname","")
	d subjson.%Set("ctcp_sourcecat","")
	d subjson.%Set("ctcp_creditlevel","")
	d subjson.%Set("ctcp_violation","")
	d subjson.%Set("ctcp_praclevel","")
	d subjson.%Set("ctcp_positionstatus","")
	
	}
	catch
	{
		s subjson={}
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTCareProv).PostCTCareProvBatch()
ClassMethod PostCTCareProvBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
{
	try
	{
		s httprequest=##class(%Net.HttpRequest).%New()
		d httprequest.SetHeader("Content-Type","application/json;charset=utf-8")
		;s url="http://211.101.232.11:9003/api/dict/general"
		s url=..#DictUrl
		d httprequest.EntityBody.CopyFrom(stream)
		s ret = httprequest.Post(url)
		s rtn = httprequest.HttpResponse.Data
		s returnStream=##class(%Stream.GlobalCharacter).%New()
		d returnStream.CopyFrom(rtn)
	}
	catch
	{
		s $zt=""
	}
	q returnStream
}

}
