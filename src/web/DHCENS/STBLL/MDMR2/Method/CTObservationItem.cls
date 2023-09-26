Class web.DHCENS.STBLL.MDMR2.Method.CTObservationItem Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步生命体征项目字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTObservationItem).SendCTObservationItem().Read()
ClassMethod SendCTObservationItem(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^MRC("OBITM",id))
		q:id=""
		d plist.SetAt(id,num)
		s num=num+1
		if num>100
		{
			s datas=..GetCTObservationItemByID(plist)
			s reqJson."data"=datas
			s reqJson."tableCode"="ct_observationitem"
			s mainJson."request"=reqJson
			s jsonStr=mainJson.%ToJSON()
			d retStream.Write(jsonStr)
			s returnStream=..PostCTObservationItemBatch(retStream)
			do plist.Clear()
			s num=1
		}
	}
	
	set length=plist.Count()
	if length>0 
	{
		set datas=..GetCTObservationItemByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="ct_observationitem"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostCTObservationItemBatch(retStream)
	}
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetCTObservationItemByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetCTObservationItemJson(rowid)
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
/// Description：获取生命体征项目字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTObservationItem).GetCTObservationItemJson()
ClassMethod GetCTObservationItemJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s businessfieldcode=..#BusinessFieldCode
	s itemCode=$p($g(^MRC("OBITM",id)),"^",1)
	s itemDesc=$p($g(^MRC("OBITM",id)),"^",2)
	s itemInputType=$p($g(^MRC("OBITM",id)),"^",3)
	s itemUnitDr=$p($g(^MRC("OBITM",id)),"^",4),itemUnitCode=""
	s:itemUnitDr'="" itemUnitCode=$p($g(^CT("UOM",itemUnitDr)),"^",1)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("ctoi_code",itemCode)
	d subjson.%Set("ctoi_desc",itemDesc)
	d subjson.%Set("ctoi_inputtype",itemInputType)
	d subjson.%Set("ctoi_inputunit",itemUnitCode)
	d subjson.%Set("ctoi_valuetype","")
	d subjson.%Set("ctoi_codesystemcode","ct_observationitem")
	d subjson.%Set("ctoi_status","1")
	d subjson.%Set("ctoi_startdate","")
	d subjson.%Set("ctoi_enddate","")
	d subjson.%Set("ctoi_creatdate","")
	d subjson.%Set("ctoi_creattime","")
	d subjson.%Set("ctoi_updatedate","")
	d subjson.%Set("ctoi_updatetime","")
	d subjson.%Set("ctoi_updateusercode","")
	d subjson.%Set("ctoi_remarks","")
	}
	catch
	{
		s subjson={}
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTObservationItem).PostCTObservationItemBatch()
ClassMethod PostCTObservationItemBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
