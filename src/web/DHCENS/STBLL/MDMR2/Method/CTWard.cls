Class web.DHCENS.STBLL.MDMR2.Method.CTWard Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步病区字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTWard).SendCTWard().Read()
ClassMethod SendCTWard(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^PAWARD(id))
		continue:id="BED_BedType_DR"
		continue:id="BED_Room_DR"
		q:id=""
		d plist.SetAt(id,num)
		s num=num+1
		if num>100
		{
			s datas=..GetCTWardByID(plist)
			s reqJson."data"=datas
			s reqJson."tableCode"="ct_ward"
			s mainJson."request"=reqJson
			s jsonStr=mainJson.%ToJSON()
			d retStream.Write(jsonStr)
			s returnStream=..PostCTWardBatch(retStream)
			do plist.Clear()
			s num=1
		}
	}
	
	set length=plist.Count()
	if length>0 
	{
		set datas=..GetCTWardByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="ct_ward"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostCTWardBatch(retStream)
	}
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetCTWardByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetCTWardJson(rowid)
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
/// Description：获取病区字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTWard).GetCTWardJson()
ClassMethod GetCTWardJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s businessfieldcode=..#BusinessFieldCode
	s paCode=$p($g(^PAWARD(id)),"^",1)
	q:paCode=""
	s paDesc=$p($g(^PAWARD(id)),"^",2)
	s paLocDr=$p($g(^PAWARD(id)),"^",5),paLocCode=""
	s:paLocDr'="" paLocCode=$p($g(^CTLOC(paLocDr)),"^",1)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("ctw_code",paCode)
	d subjson.%Set("ctw_desc",paDesc)
	d subjson.%Set("ctw_deptcode",paLocCode)
	d subjson.%Set("ctw_codesystemcode","ct_ward")
	d subjson.%Set("ctw_status","1")
	d subjson.%Set("ctw_startdate","")
	d subjson.%Set("ctw_enddate","")
	d subjson.%Set("ctw_creatdate","")
	d subjson.%Set("ctw_creattime","")
	d subjson.%Set("ctw_updatedate","")
	d subjson.%Set("ctw_updatetime","")
	d subjson.%Set("ctw_updateusercode","")
	d subjson.%Set("ctw_remarks","")
	}
	catch
	{
		s subjson={}
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTWard).PostCTWardBatch()
ClassMethod PostCTWardBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
