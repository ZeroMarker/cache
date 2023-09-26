Class web.DHCENS.STBLL.MDMR2.Method.CTChildCategory Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步医嘱子类字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTChildCategory).SendCTChildCategory().Read()
ClassMethod SendCTChildCategory(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^ARC("IC",id))
		q:id=""
		d plist.SetAt(id,num)
		s num=num+1
		if num>100
		{
			s datas=..GetCTChildCategoryByID(plist)
			s reqJson."data"=datas
			s reqJson."tableCode"="ct_childcategory"
			s mainJson."request"=reqJson
			s jsonStr=mainJson.%ToJSON()
			d retStream.Write(jsonStr)
			s returnStream=..PostCTChildCategoryBatch(retStream)
			do plist.Clear()
			s num=1
		}
	}
	
	set length=plist.Count()
	if length>0 
	{
		set datas=..GetCTChildCategoryByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="ct_childcategory"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostCTChildCategoryBatch(retStream)
	}
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetCTChildCategoryByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetCTChildCategoryJson(rowid)
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
/// Description：获取医嘱子类字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTChildCategory).GetCTChildCategoryJson()
ClassMethod GetCTChildCategoryJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s businessfieldcode=..#BusinessFieldCode
	s ccatCode=$p($g(^ARC("IC",id)),"^",1)
	s ccatDesc=$p($g(^ARC("IC",id)),"^",2)
	s category=$p($g(^ARC("IC",id)),"^",8)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("ctcc_code",ccatCode)
	d subjson.%Set("ctcc_desc",ccatDesc)
	d subjson.%Set("ctcc_category",category)
	d subjson.%Set("ctcc_codesystemcode","ct_childcategory")
	d subjson.%Set("ctcc_status","1")
	d subjson.%Set("ctcc_startdate","")
	d subjson.%Set("ctcc_enddate","")
	d subjson.%Set("ctcc_creatdate","")
	d subjson.%Set("ctcc_creattime","")
	d subjson.%Set("ctcc_updatedate","")
	d subjson.%Set("ctcc_updatetime","")
	d subjson.%Set("ctcc_updateusercode","")
	d subjson.%Set("ctcc_remarks","")
	d subjson.%Set("version","")
	}
	catch
	{
		s subjson={}
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTChildCategory).PostCTChildCategoryBatch()
ClassMethod PostCTChildCategoryBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
