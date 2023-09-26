Class web.DHCENS.STBLL.MDMR2.Method.HOSProvince Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：liyan
/// CreatDate：2022-12-11
/// Description：获取省字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.HOSProvince).GetHOSProvince()
ClassMethod GetHOSProvince(input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	s tablecode="hos_province"
	s returnstream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s reqjson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s businessfieldcode=..#BusinessFieldCode
	s id=input
	if +id=0 {
		s reqjson.data=dataarr
		s reqjson.tablecode=tablecode
		s json.request=reqjson
		d returnstream.Write(json.%ToJSON())
		Quit returnstream
	}
	s provincecode=$p($g(^CT("PROV",id)),"^",1)
	s provincedesc=$p($g(^CT("PROV",id)),"^",2)
	s datefrom=$p($g(^CT("PROV",id)),"^",4)
	s dateto=$p($g(^CT("PROV",id)),"^",5)
	if +datefrom'=0 s datefrom=$zd(datefrom,3)
	if +dateto'=0 s dateto=$zd(dateto,3)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("prov_code",provincecode)
	d subjson.%Set("prov_desc",provincedesc)
	d subjson.%Set("prov_activity","Y")
	d subjson.%Set("prov_startdate",datefrom)
	d subjson.%Set("prov_enddate",dateto)
	d dataarr.%Push(subjson)
	s reqjson.data=dataarr
	s reqjson.tablecode=tablecode
	s json.request=reqjson
	d returnstream.Write(json.%ToJSON())
	Quit returnstream
Exception
	s returnstream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s reqjson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s reqjson.data=dataarr
	s reqjson.tablecode=tablecode
	s json.request=reqjson
	d returnstream.Write(json.%ToJSON())
	Quit returnstream
}

/// Creator：liyan
/// CreatDate：2022-12-11
/// Description：同步省字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.HOSProvince).SendHOSProvince().Read()
ClassMethod SendHOSProvince(input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	s returnstream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s reqjson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s businessfieldcode=..#BusinessFieldCode
	s reqstream=##class(%GlobalCharacterStream).%New()
	s id=0
	f {
		s id=$o(^CT("PROV",id))
		q:id=""
		s provincecode=$p($g(^CT("PROV",id)),"^",1)
		s provincedesc=$p($g(^CT("PROV",id)),"^",2)
		s datefrom=$p($g(^CT("PROV",id)),"^",4)
		s dateto=$p($g(^CT("PROV",id)),"^",5)
		if +datefrom'=0 s datefrom=$zd(datefrom,3)
		if +dateto'=0 s dateto=$zd(dateto,3)
		s subjson=##class(%DynamicObject).%New()
		d subjson.%Set("businessrowid",id)
		d subjson.%Set("sourcerowid",id)
		d subjson.%Set("businessfieldcode",businessfieldcode)
		d subjson.%Set("prov_code",provincecode)
		d subjson.%Set("prov_desc",provincedesc)
		d subjson.%Set("prov_activity","Y")
		d subjson.%Set("prov_startdate",datefrom)
		d subjson.%Set("prov_enddate",dateto)
		d dataarr.%Push(subjson)
	}
	s reqjson.data=dataarr
	s reqjson.tablecode="hos_province"
	s json.request=reqjson
	d reqstream.Write(json.%ToJSON())
	s httprequest=##class(%Net.HttpRequest).%New()
	d httprequest.SetHeader("Content-Type","application/json;charset=utf-8")
	//s url="http://119.255.194.78:8003/api/dict/general"
	//s url="http://211.101.232.11:9003/api/dict/general"
	s url=..#DictUrl
	d httprequest.EntityBody.CopyFrom(reqstream)
	s ret = httprequest.Post(url)
	s returnstream = httprequest.HttpResponse.Data
	q returnstream
Exception
	s returnstream=##class(%GlobalCharacterStream).%New()
	Quit returnstream
}

}
