Class web.DHCENS.STBLL.MDMR2.Method.CTRelation Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：liyan
/// CreatDate：2022-12-11
/// Description：获取联系人关系字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTRelation).GetCTRelation()
ClassMethod GetCTRelation(input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	s tablecode="ct_relation"
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
	s relationcode=$p($g(^CT("RLT",id)),"^",1)
	s relationdesc=$p($g(^CT("RLT",id)),"^",2)
	s datefrom=$p($g(^CT("RLT",id)),"^",3)
	s dateto=$p($g(^CT("RLT",id)),"^",4)
	if +datefrom'=0 s datefrom=$zd(datefrom,3)
	if +dateto'=0 s dateto=$zd(dateto,3)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("ctr_code",relationcode)
	d subjson.%Set("ctr_desc",relationdesc)
	d subjson.%Set("ctr_status","Y")
	d subjson.%Set("ctr_startdate",datefrom)
	d subjson.%Set("ctr_enddate",dateto)
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
/// Description：同步联系人关系字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTRelation).SendCTRelation().Read()
ClassMethod SendCTRelation(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^CT("RLT",id))
		q:id=""
		s relationcode=$p($g(^CT("RLT",id)),"^",1)
		s relationdesc=$p($g(^CT("RLT",id)),"^",2)
		s datefrom=$p($g(^CT("RLT",id)),"^",3)
		s dateto=$p($g(^CT("RLT",id)),"^",4)
		if +datefrom'=0 s datefrom=$zd(datefrom,3)
		if +dateto'=0 s dateto=$zd(dateto,3)
		s subjson=##class(%DynamicObject).%New()
		d subjson.%Set("businessrowid",id)
		d subjson.%Set("sourcerowid",id)
		d subjson.%Set("businessfieldcode",businessfieldcode)
		d subjson.%Set("ctr_code",relationcode)
		d subjson.%Set("ctr_desc",relationdesc)
		d subjson.%Set("ctr_status","Y")
		d subjson.%Set("ctr_startdate",datefrom)
		d subjson.%Set("ctr_enddate",dateto)
		d dataarr.%Push(subjson)
	}
	s reqjson.data=dataarr
	s reqjson.tablecode="ct_relation"
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
