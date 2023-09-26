Class web.DHCENS.STBLL.MDMR2.Method.CTEncounterStatus Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步就诊状态字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTEncounterStatus).SendCTEncounterStatus().Read()
ClassMethod SendCTEncounterStatus(input As %String = "") As %GlobalCharacterStream
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
	s admStatusList="A,C,D,P" ///在就诊、取消就诊、出院、其他
	s len=$l(admStatusList,","),num=1,i=1
	f {
		s admStatusCode=$p(admStatusList,",",i)
		s admStatusDesc=$case(admStatusCode,"A":"在就诊","C":"取消就诊","D":"出院","P":"其他",:"")
		s subjson=##class(%DynamicObject).%New()
		d subjson.%Set("businessrowid",i)
		d subjson.%Set("sourcerowid",i)
		d subjson.%Set("businessfieldcode",businessfieldcode)
		d subjson.%Set("ctes_code",admStatusCode)
		d subjson.%Set("ctes_desc",admStatusDesc)
		d subjson.%Set("ctes_codesystemcode","ct_encounterstatus")
		d subjson.%Set("ctes_status","1")
		d subjson.%Set("ctes_startdate","")
		d subjson.%Set("ctes_enddate","")
		d subjson.%Set("ctes_creatdate","")
		d subjson.%Set("ctes_creattime","")
		d subjson.%Set("ctes_updatedate","")
		d subjson.%Set("ctes_updatetime","")
		d subjson.%Set("ctes_updateusercode","")
		d subjson.%Set("ctes_remarks","")
		d subjson.%Set("version","")
		d dataarr.%Push(subjson)
		s i=i+1
		q:i>len
		s num=num+1	
	}
	s reqJson."data"=dataarr
	s reqJson."tableCode"="ct_encounterstatus"
	s mainJson."request"=reqJson
	s jsonStr=mainJson.%ToJSON()
	d retStream.Write(jsonStr)
	s returnStream=..PostCTEncounterStatusBatch(retStream)
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTEncounterStatus).PostCTEncounterStatusBatch()
ClassMethod PostCTEncounterStatusBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
