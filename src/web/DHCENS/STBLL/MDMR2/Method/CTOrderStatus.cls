Class web.DHCENS.STBLL.MDMR2.Method.CTOrderStatus Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步医嘱状态字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTOrderStatus).SendCTOrderStatus().Read()
ClassMethod SendCTOrderStatus(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^OEC("OSTAT",id))
		q:id=""
		d plist.SetAt(id,num)
		s num=num+1
		if num>100
		{
			s datas=..GetCTOrderStatusByID(plist)
			s reqJson."data"=datas
			s reqJson."tableCode"="ct_orderStatus"
			s mainJson."request"=reqJson
			s jsonStr=mainJson.%ToJSON()
			d retStream.Write(jsonStr)
			s returnStream=..PostCTOrderStatusBatch(retStream)
			do plist.Clear()
			s num=1
		}
	}
	
	set length=plist.Count()
	if length>0 
	{
		set datas=..GetCTOrderStatusByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="ct_orderStatus"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostCTOrderStatusBatch(retStream)
	}
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetCTOrderStatusByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetCTOrderStatusJson(rowid)
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
/// Description：获取医嘱状态字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTOrderStatus).GetCTOrderStatusJson()
ClassMethod GetCTOrderStatusJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s businessfieldcode=..#BusinessFieldCode
	s catCode=$p($g(^OEC("OSTAT",id)),"^",1)
	s catDesc=$p($g(^OEC("OSTAT",id)),"^",2)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("ctos_code",catCode)
	d subjson.%Set("ctos_desc",catDesc)
	d subjson.%Set("ctos_codesystemcode","ct_orderstatus")
	d subjson.%Set("ctos_status","1")
	d subjson.%Set("ctos_startdate","")
	d subjson.%Set("ctos_enddate","")
	d subjson.%Set("ctos_creatdate","")
	d subjson.%Set("ctos_creattime","")
	d subjson.%Set("ctos_creatuser","")
	d subjson.%Set("ctos_updatedate","")
	d subjson.%Set("ctos_updatetime","")
	d subjson.%Set("ctos_updateusercode","")
	d subjson.%Set("ctos_remarks","")
	}
	catch
	{
		s subjson={}
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTOrderStatus).PostCTOrderStatusBatch()
ClassMethod PostCTOrderStatusBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
