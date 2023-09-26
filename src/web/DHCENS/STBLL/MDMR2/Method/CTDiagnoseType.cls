Class web.DHCENS.STBLL.MDMR2.Method.CTDiagnoseType Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步诊断类型字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTDiagnoseType).SendCTDiagnoseType().Read()
ClassMethod SendCTDiagnoseType(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^MRC("DTYP",id))
		q:id=""
		d plist.SetAt(id,num)
		s num=num+1
		if num>100
		{
			s datas=..GetCTDiagnoseTypeByID(plist)
			s reqJson."data"=datas
			s reqJson."tableCode"="ct_diagnosetype"
			s mainJson."request"=reqJson
			s jsonStr=mainJson.%ToJSON()
			d retStream.Write(jsonStr)
			s returnStream=..PostCTDiagnoseTypeBatch(retStream)
			do plist.Clear()
			s num=1
		}
	}
	
	set length=plist.Count()
	if length>0 
	{
		set datas=..GetCTDiagnoseTypeByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="ct_diagnosetype"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostCTDiagnoseTypeBatch(retStream)
	}
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetCTDiagnoseTypeByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetCTDiagnoseTypeJson(rowid)
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
/// Description：获取诊断类型字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTDiagnoseType).GetCTDiagnoseTypeJson()
ClassMethod GetCTDiagnoseTypeJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s businessfieldcode=..#BusinessFieldCode
	s diagTypeCode=$p($g(^MRC("DTYP",id)),"^",1)
	s diagTypeDesc=$p($g(^MRC("DTYP",id)),"^",2)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("ctdt_code",diagTypeCode)
	d subjson.%Set("ctdt_desc",diagTypeDesc)
	d subjson.%Set("ctdt_codesystemcode","ct_diagnosetype")
	d subjson.%Set("ctdt_status","1")
	d subjson.%Set("ctdt_startdate","")
	d subjson.%Set("ctdt_enddate","")
	d subjson.%Set("ctdt_creatdate","")
	d subjson.%Set("ctdt_creattime","")
	d subjson.%Set("ctdt_updatedate","")
	d subjson.%Set("ctdt_updatetime","")
	d subjson.%Set("ctdt_updateusercode","")
	d subjson.%Set("ctdt_remarks","")
	d subjson.%Set("version","")
	}
	catch
	{
		s subjson={}
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTDiagnoseType).PostCTDiagnoseTypeBatch()
ClassMethod PostCTDiagnoseTypeBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
