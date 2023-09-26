Class web.DHCENS.STBLL.MDMR2.Method.CTDoseForms Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步剂型字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTDoseForms).SendCTDoseForms().Read()
ClassMethod SendCTDoseForms(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^PHCF(id))
		q:id=""
		d plist.SetAt(id,num)
		s num=num+1
		if num>100
		{
			s datas=..GetCTDoseFormsByID(plist)
			s reqJson."data"=datas
			s reqJson."tableCode"="ct_doseforms"
			s mainJson."request"=reqJson
			s jsonStr=mainJson.%ToJSON()
			d retStream.Write(jsonStr)
			s returnStream=..PostCTDoseFormsBatch(retStream)
			do plist.Clear()
			s num=1
		}
	}
	
	set length=plist.Count()
	if length>0 
	{
		set datas=..GetCTDoseFormsByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="ct_doseforms"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostCTDoseFormsBatch(retStream)
	}
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetCTDoseFormsByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetCTDoseFormsJson(rowid)
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
/// Description：获取剂型字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTDoseForms).GetCTDoseFormsJson()
ClassMethod GetCTDoseFormsJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s businessfieldcode=..#BusinessFieldCode
	s dfCode=$p($g(^PHCF(id)),"^",1)
	s dfDesc=$p($g(^PHCF(id)),"^",2)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("ctdf_code",dfCode)
	d subjson.%Set("ctdf_desc",dfDesc)
	d subjson.%Set("ctdf_codesystemcode","ct_doseforms")
	d subjson.%Set("ctdf_status","1")
	d subjson.%Set("ctdf_startdate","")
	d subjson.%Set("ctdf_enddate","")
	d subjson.%Set("ctdf_creatdate","")
	d subjson.%Set("ctdf_creattime","")
	d subjson.%Set("ctdf_updatedate","")
	d subjson.%Set("ctdf_updatetime","")
	d subjson.%Set("ctdf_updateusercode","")
	d subjson.%Set("ctdf_remarks","")
	d subjson.%Set("version","")
	}
	catch
	{
		s subjson={}
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTDoseForms).PostCTDoseFormsBatch()
ClassMethod PostCTDoseFormsBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
