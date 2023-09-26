Class web.DHCENS.STBLL.MDMR2.Method.CTLISItem Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步检验项目字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTLISItem).SendCTLISItem().Read()
ClassMethod SendCTLISItem(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^dbo.BTTestCodeD(id))
		q:id=""
		d plist.SetAt(id,num)
		s num=num+1
		if num>100
		{
			s datas=..GetCTLISItemByID(plist)
			s reqJson."data"=datas
			s reqJson."tableCode"="ct_lisitem"
			s mainJson."request"=reqJson
			s jsonStr=mainJson.%ToJSON()
			d retStream.Write(jsonStr)
			s returnStream=..PostCTLISItemBatch(retStream)
			do plist.Clear()
			s num=1
		}
	}
	
	set length=plist.Count()
	if length>0 
	{
		set datas=..GetCTLISItemByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="ct_lisitem"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostCTLISItemBatch(retStream)
	}
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetCTLISItemByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetCTLISItemJson(rowid)
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
/// Description：获取检验项目字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTLISItem).GetCTLISItemJson()
ClassMethod GetCTLISItemJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s businessfieldcode=..#BusinessFieldCode
	s testCode=$lg($g(^dbo.BTTestCodeD(id)),2)
	s testDesc=$lg($g(^dbo.BTTestCodeD(id)),3)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("ctli_code",testCode)
	d subjson.%Set("ctli_desc",testDesc)
	d subjson.%Set("ctli_codesystemcode","ct_lisitem")
	d subjson.%Set("ctli_status","1")
	d subjson.%Set("ctli_startdate","")
	d subjson.%Set("ctli_enddate","")
	d subjson.%Set("ctli_creatdate","")
	d subjson.%Set("ctli_creattime","")
	d subjson.%Set("ctli_updatedate","")
	d subjson.%Set("ctli_updatetime","")
	d subjson.%Set("ctli_updateusercode","")
	d subjson.%Set("ctli_remarks","")
	d subjson.%Set("version","")
	}
	catch
	{
		s subjson={}
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTLISItem).PostCTLISItemBatch()
ClassMethod PostCTLISItemBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
