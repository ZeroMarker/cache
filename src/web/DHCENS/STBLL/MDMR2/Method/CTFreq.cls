Class web.DHCENS.STBLL.MDMR2.Method.CTFreq Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步频次字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTFreq).SendCTFreq().Read()
ClassMethod SendCTFreq(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^PHCFR(id))
		q:id=""
		d plist.SetAt(id,num)
		s num=num+1
		if num>100
		{
			s datas=..GetCTFreqByID(plist)
			s reqJson."data"=datas
			s reqJson."tableCode"="ct_freq"
			s mainJson."request"=reqJson
			s jsonStr=mainJson.%ToJSON()
			d retStream.Write(jsonStr)
			s returnStream=..PostCTFreqBatch(retStream)
			do plist.Clear()
			s num=1
		}
	}
	
	set length=plist.Count()
	if length>0 
	{
		set datas=..GetCTFreqByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="ct_freq"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostCTFreqBatch(retStream)
	}
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetCTFreqByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetCTFreqJson(rowid)
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
/// Description：获取频次字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTFreq).GetCTFreqJson()
ClassMethod GetCTFreqJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s businessfieldcode=..#BusinessFieldCode
	s catCode=$p($g(^PHCFR(id)),"^",1)
	s catDesc=$p($g(^PHCFR(id)),"^",3)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("ctf_code",catCode)
	d subjson.%Set("ctf_desc",catDesc)
	d subjson.%Set("ctf_codesystemcode","ct_freq")
	d subjson.%Set("ctf_status","1")
	d subjson.%Set("ctf_startdate","")
	d subjson.%Set("ctf_enddate","")
	d subjson.%Set("ctf_creatdate","")
	d subjson.%Set("ctf_creattime","")
	d subjson.%Set("ctf_updatedate","")
	d subjson.%Set("ctf_updatetime","")
	d subjson.%Set("ctf_updateusercode","")
	d subjson.%Set("ctf_remarks","")
	}
	catch
	{
		s subjson={}
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTFreq).PostCTFreqBatch()
ClassMethod PostCTFreqBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
