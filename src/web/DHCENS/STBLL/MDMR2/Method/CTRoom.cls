Class web.DHCENS.STBLL.MDMR2.Method.CTRoom Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步病房字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTRoom).SendCTRoom().Read()
ClassMethod SendCTRoom(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^PAROOM(id))
		q:id=""
		d plist.SetAt(id,num)
		s num=num+1
		if num>100
		{
			s datas=..GetCTRoomByID(plist)
			s reqJson."data"=datas
			s reqJson."tableCode"="ct_room"
			s mainJson."request"=reqJson
			s jsonStr=mainJson.%ToJSON()
			d retStream.Write(jsonStr)
			s returnStream=..PostCTRoomBatch(retStream)
			do plist.Clear()
			s num=1
		}
	}
	
	set length=plist.Count()
	if length>0 
	{
		set datas=..GetCTRoomByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="ct_room"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostCTRoomBatch(retStream)
	}
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetCTRoomByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetCTRoomJson(rowid)
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
/// Description：获取病房字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTRoom).GetCTRoomJson()
ClassMethod GetCTRoomJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s businessfieldcode=..#BusinessFieldCode
	s paCode=$p($g(^PAROOM(id)),"^",1)
	s paDesc=$p($g(^PAROOM(id)),"^",2)
	s paRoomTypeDr=$p($g(^PAROOM(id)),"^",3),paRoomTypeCode=""
	s:paRoomTypeDr'="" paRoomTypeCode=$p($g(^PAC("ROOMT",paRoomTypeDr)),"^",1)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("ctr_code",paCode)
	d subjson.%Set("ctr_desc",paDesc)
	d subjson.%Set("ctr_typecode",paRoomTypeCode)
	d subjson.%Set("ctr_codesystemcode","ct_room")
	d subjson.%Set("ctr_status","1")
	d subjson.%Set("ctr_startdate","")
	d subjson.%Set("ctr_enddate","")
	d subjson.%Set("ctr_creatdate","")
	d subjson.%Set("ctr_creattime","")
	d subjson.%Set("ctr_updatedate","")
	d subjson.%Set("ctr_updatetime","")
	d subjson.%Set("ctr_updateusercode","")
	d subjson.%Set("ctr_remarks","")
	}
	catch
	{
		s subjson={}
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTRoom).PostCTRoomBatch()
ClassMethod PostCTRoomBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
