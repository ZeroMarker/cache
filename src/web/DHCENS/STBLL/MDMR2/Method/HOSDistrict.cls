Class web.DHCENS.STBLL.MDMR2.Method.HOSDistrict Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：liyan
/// CreatDate：2022-12-11
/// Description：获取区县字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.HOSDistrict).GetHOSDistrict()
ClassMethod GetHOSDistrict(input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	s tablecode="hos_district"
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
	s districtcode=$p($g(^CT("CITAREA",id)),"^",1)
	s districtdesc=$p($g(^CT("CITAREA",id)),"^",2)
	s city=$p($g(^CT("CITAREA",id)),"^",3)
	s datefrom=$p($g(^CT("CITAREA",id)),"^",4)
	s dateto=$p($g(^CT("CITAREA",id)),"^",5)
	if +datefrom'=0 s datefrom=$zd(datefrom,3)
	if +dateto'=0 s dateto=$zd(dateto,3)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("distr_code",districtcode)
	d subjson.%Set("distr_desc",districtdesc)
	d subjson.%Set("distr_citycode",city)
	d subjson.%Set("distr_activity","Y")
	d subjson.%Set("distr_startdate",datefrom)
	d subjson.%Set("distr_enddate",dateto)
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
/// Description：同步区县字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.HOSDistrict).SendHOSDistrict().Read()
ClassMethod SendHOSDistrict(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^CT("CITAREA",id))
		q:id=""
		s districtcode=$p($g(^CT("CITAREA",id)),"^",1)
		s districtdesc=$p($g(^CT("CITAREA",id)),"^",2)
		s city=$p($g(^CT("CITAREA",id)),"^",3)
		s datefrom=$p($g(^CT("CITAREA",id)),"^",4)
		s dateto=$p($g(^CT("CITAREA",id)),"^",5)
		if +datefrom'=0 s datefrom=$zd(datefrom,3)
		if +dateto'=0 s dateto=$zd(dateto,3)
		s subjson=##class(%DynamicObject).%New()
		d subjson.%Set("businessrowid",id)
		d subjson.%Set("sourcerowid",id)
		d subjson.%Set("businessfieldcode",businessfieldcode)
		d subjson.%Set("distr_code",districtcode)
		d subjson.%Set("distr_desc",districtdesc)
		d subjson.%Set("distr_citycode",city)
		d subjson.%Set("distr_activity","Y")
		d subjson.%Set("distr_startdate",datefrom)
		d subjson.%Set("distr_enddate",dateto)
		d dataarr.%Push(subjson)
		if dataarr.%Size()=100 {
			s reqjson.data=dataarr
			s reqjson.tablecode="hos_district"
			s json.request=reqjson
			s httprequest=##class(%Net.HttpRequest).%New()
			d httprequest.SetHeader("Content-Type","application/json;charset=utf-8")
			//s url="http://119.255.194.78:8003/api/dict/general"
			s url="http://211.101.232.11:9003/api/dict/general"
			d httprequest.EntityBody.Write(json.%ToJSON())
			s ret = httprequest.Post(url)
			s returnstream = httprequest.HttpResponse.Data
			s dataarr=##class(%DynamicArray).%New()
			d reqstream.Clear()
		}
	}
	s reqjson.data=dataarr
	s reqjson.tablecode="hos_district"
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
