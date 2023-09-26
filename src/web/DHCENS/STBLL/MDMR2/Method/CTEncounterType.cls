Class web.DHCENS.STBLL.MDMR2.Method.CTEncounterType Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步就诊类型字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTEncounterType).SendCTEncounterType().Read()
ClassMethod SendCTEncounterType(input As %String = "") As %GlobalCharacterStream
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
	s admTypeList="I,O,E,P,N,R,G,H,Urgent" ///住院、门诊、急诊、药理、新生儿、科研、其他、体检、加急
	s len=$l(admTypeList,","),num=1,i=1
	f {
		s admTypeCode=$p(admTypeList,",",i)
		s admTypeDesc=$case(admTypeCode,"I":"住院","O":"门诊","E":"急诊","P":"药理","N":"新生儿","R":"科研","G":"其他","H":"体检","Urgent":"加急",:"")
		s subjson=##class(%DynamicObject).%New()
		d subjson.%Set("businessrowid",i)
		d subjson.%Set("sourcerowid",i)
		d subjson.%Set("businessfieldcode",businessfieldcode)
		d subjson.%Set("ctet_code",admTypeCode)
		d subjson.%Set("ctet_desc",admTypeDesc)
		d subjson.%Set("ctet_codesystemcode","ct_encountertype")
		d subjson.%Set("ctet_status","1")
		d subjson.%Set("ctet_startdate","")
		d subjson.%Set("ctet_enddate","")
		d subjson.%Set("ctet_creatdate","")
		d subjson.%Set("ctet_creattime","")
		d subjson.%Set("ctet_updatedate","")
		d subjson.%Set("ctet_updatetime","")
		d subjson.%Set("ctet_updateusercode","")
		d subjson.%Set("ctet_remarks","")
		d dataarr.%Push(subjson)
		s i=i+1
		q:i>len
		s num=num+1	
	}
	s reqJson."data"=dataarr
	s reqJson."tableCode"="ct_encountertype"
	s mainJson."request"=reqJson
	s jsonStr=mainJson.%ToJSON()
	d retStream.Write(jsonStr)
	s returnStream=..PostCTEncounterTypeBatch(retStream)
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTEncounterType).PostCTEncounterTypeBatch()
ClassMethod PostCTEncounterTypeBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
