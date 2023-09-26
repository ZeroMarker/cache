Class web.DHCENS.STBLL.MDMR2.Method.CTAllergeryCategory Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步过敏类别字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTAllergeryCategory).SendCTAllergeryCategory().Read()
ClassMethod SendCTAllergeryCategory(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^PAC("ALRGCAT",id))
		q:id=""
		d plist.SetAt(id,num)
		s num=num+1
		if num>100
		{
			s datas=..GetCTAllergeryCategoryByID(plist)
			s reqJson."data"=datas
			s reqJson."tableCode"="ct_allergycategory"
			s mainJson."request"=reqJson
			s jsonStr=mainJson.%ToJSON()
			d retStream.Write(jsonStr)
			s returnStream=..PostCTAllergeryCategoryBatch(retStream)
			do plist.Clear()
			s num=1
		}
	}
	
	set length=plist.Count()
	if length>0 
	{
		set datas=..GetCTAllergeryCategoryByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="ct_allergycategory"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostCTAllergeryCategoryBatch(retStream)
	}
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetCTAllergeryCategoryByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetCTAllergeryCategoryJson(rowid)
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
/// Description：获取过敏类别字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTAllergeryCategory).GetCTAllergeryCategoryJson()
ClassMethod GetCTAllergeryCategoryJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s businessfieldcode=..#BusinessFieldCode
	s catCode=$p($g(^PAC("ALRGCAT",id)),"^",1)
	s catDesc=$p($g(^PAC("ALRGCAT",id)),"^",2)
	s stDate=$p($g(^PAC("ALRGCAT",id)),"^",5)
	s:stDate'="" stDate=$zd(stDate,3)
	s edDate=$p($g(^PAC("ALRGCAT",id)),"^",6)
	s:edDate'="" edDate=$zd(edDate,3)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("ctac_code",catCode)
	d subjson.%Set("ctac_desc",catDesc)
	d subjson.%Set("ctac_codesystemcode","ct_allergycategory")
	d subjson.%Set("ctac_status","1")
	d subjson.%Set("ctac_startdate",stDate)
	d subjson.%Set("ctac_enddate",edDate)
	d subjson.%Set("ctac_creatdate","")
	d subjson.%Set("ctac_creattime","")
	d subjson.%Set("ctac_updatedate","")
	d subjson.%Set("ctac_updatetime","")
	d subjson.%Set("ctac_updateusercode","")
	d subjson.%Set("ctac_remarks","")
	}
	catch
	{
		s subjson={}
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTAllergeryCategory).PostCTAllergeryCategoryBatch()
ClassMethod PostCTAllergeryCategoryBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
