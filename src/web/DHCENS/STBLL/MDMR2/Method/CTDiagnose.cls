Class web.DHCENS.STBLL.MDMR2.Method.CTDiagnose Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步诊断字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTDiagnose).SendCTDiagnose().Read()
ClassMethod SendCTDiagnose(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^MRC("ID",id))
		q:id=""
		d plist.SetAt(id,num)
		s num=num+1
		if num>100
		{
			s datas=..GetCTDiagnoseByID(plist)
			s reqJson."data"=datas
			s reqJson."tableCode"="ct_diagnose"
			s mainJson."request"=reqJson
			s jsonStr=mainJson.%ToJSON()
			d retStream.Write(jsonStr)
			s returnStream=..PostCTDiagnoseBatch(retStream)
			do plist.Clear()
			s num=1
		}
	}
	
	set length=plist.Count()
	if length>0 
	{
		set datas=..GetCTDiagnoseByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="ct_diagnose"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostCTDiagnoseBatch(retStream)
	}
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetCTDiagnoseByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetCTDiagnoseJson(rowid)
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
/// Description：获取诊断字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTDiagnose).GetCTDiagnoseJson()
ClassMethod GetCTDiagnoseJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s businessfieldcode=..#BusinessFieldCode
	s catCode=$p($g(^MRC("ID",id)),"^",1)
	s catDesc=$p($g(^MRC("ID",id)),"^",2)
	s icdCode=$p($g(^MRC("ID",id)),"^",5)
	s stDate=$p($g(^MRC("ID",id)),"^",6)
	s:stDate'="" stDate=$zd(stDate,3)
	s edDate=$p($g(^MRC("ID",id)),"^",7)
	s:edDate'="" stDate=$zd(edDate,3)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("ctd_code",catCode)
	d subjson.%Set("ctd_desc",catDesc)
	d subjson.%Set("ctd_icdcode",icdCode)
	d subjson.%Set("ctd_codesystemcode","ct_diagnose")
	d subjson.%Set("ctd_status","1")
	d subjson.%Set("ctd_startdate",stDate)
	d subjson.%Set("ctd_enddate",edDate)
	d subjson.%Set("ctd_creatdate","")
	d subjson.%Set("ctd_creattime","")
	d subjson.%Set("ctd_updatedate","")
	d subjson.%Set("ctd_updatetime","")
	d subjson.%Set("ctd_updateusercode","")
	d subjson.%Set("ctd_remarks","")
	}
	catch
	{
		s subjson={}
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTDiagnose).PostCTDiagnoseBatch()
ClassMethod PostCTDiagnoseBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
