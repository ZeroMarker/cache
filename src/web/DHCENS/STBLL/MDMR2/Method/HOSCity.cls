Class web.DHCENS.STBLL.MDMR2.Method.HOSCity Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：liyan
/// CreatDate：2022-12-11
/// Description：获取市字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.HOSCity).GetHOSCity()
ClassMethod GetHOSCity(input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	s tablecode="hos_city"
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
	s citycode=$p($g(^CT("CIT",id)),"^",1)
	s citydesc=$p($g(^CT("CIT",id)),"^",2)
	s province=$p($g(^CT("CIT",id)),"^",4)
	s datefrom=$p($g(^CT("CIT",id)),"^",5)
	s dateto=$p($g(^CT("CIT",id)),"^",6)
	if +datefrom'=0 s datefrom=$zd(datefrom,3)
	if +dateto'=0 s dateto=$zd(dateto,3)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("city_code",citycode)
	d subjson.%Set("city_desc",citydesc)
	d subjson.%Set("city_provcode",province)
	d subjson.%Set("city_activity","Y")
	d subjson.%Set("city_startdate",datefrom)
	d subjson.%Set("city_enddate",dateto)
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
/// Description：同步市字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.HOSCity).SendHOSCity().Read()
ClassMethod SendHOSCity(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^CT("CIT",id))
		q:id=""
		s citycode=$p($g(^CT("CIT",id)),"^",1)
		s citydesc=$p($g(^CT("CIT",id)),"^",2)
		continue:citydesc=""
		s province=$p($g(^CT("CIT",id)),"^",4)
		s datefrom=$p($g(^CT("CIT",id)),"^",5)
		s dateto=$p($g(^CT("CIT",id)),"^",6)
		if +datefrom'=0 s datefrom=$zd(datefrom,3)
		if +dateto'=0 s dateto=$zd(dateto,3)
		s subjson=##class(%DynamicObject).%New()
		d subjson.%Set("businessrowid",id)
		d subjson.%Set("sourcerowid",id)
		d subjson.%Set("businessfieldcode",businessfieldcode)
		d subjson.%Set("city_code",citycode)
		d subjson.%Set("city_desc",citydesc)
		d subjson.%Set("city_provcode",province)
		d subjson.%Set("city_activity","Y")
		d subjson.%Set("city_startdate",datefrom)
		d subjson.%Set("city_enddate",dateto)
		d dataarr.%Push(subjson)
	}
	s reqjson.data=dataarr
	s reqjson.tablecode="hos_city"
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
