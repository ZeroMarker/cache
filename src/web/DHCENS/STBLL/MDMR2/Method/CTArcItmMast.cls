Class web.DHCENS.STBLL.MDMR2.Method.CTArcItmMast Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步医嘱项目字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTArcItmMast).SendCTArcItmMast().Read()
ClassMethod SendCTArcItmMast(input As %String = "") As %GlobalCharacterStream
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
	s ordCatRowId="0"
	f {
		set ordCatRowId=$o(^OEC("ORCAT",ordCatRowId))
		q:ordCatRowId=""
		s arcIcRowId="0"
		f {
			set arcIcRowId=$o(^ARC("IC",0,"OrdCat",ordCatRowId,arcIcRowId))
			q:arcIcRowId=""
			s arcItmId="0"
			f {
				set arcItmId=$O(^ARCIM(0,"ARCIC_DR",arcIcRowId,arcItmId))
				q:arcItmId=""
				s arcVerId="0"
				f {
					set arcVerId=$O(^ARCIM(0,"ARCIC_DR",arcIcRowId,arcItmId,arcVerId))
					q:arcVerId=""
					set rowid=arcItmId_"||"_arcVerId_"^"_arcIcRowId
					do plist.SetAt(rowid,num)
					s num=num+1
					if num>100
					{
						s datas=..GetCTArcItmMastByID(plist)
						s reqJson."data"=datas
						s reqJson."tableCode"="ct_arcitmmast"
						s mainJson."request"=reqJson
						s jsonStr=mainJson.%ToJSON()
						d retStream.Write(jsonStr)
						s returnStream=..PostCTArcItmMastBatch(retStream)
						do plist.Clear()
						s num=1
					}
				}
			}
		}
	}
		
		set length=plist.Count()
		if length>0 
		{
		set datas=..GetCTArcItmMastByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="ct_arcitmmast"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostCTArcItmMastBatch(retStream)
	}
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetCTArcItmMastByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetCTArcItmMastJson(rowid)
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
/// Description：获取医嘱项目字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTArcItmMast).GetCTArcItmMastJson()
ClassMethod GetCTArcItmMastJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s subjson=##class(%DynamicObject).%New()
	s businessfieldcode=..#BusinessFieldCode
	s arcItmRowid=$p(id,"^",1),arcItmCat=$p(id,"^",2)
	s arcItmSub=$p(arcItmRowid,"||",1),arcItmVer=$p(arcItmRowid,"||",2)
	s itemCode=$p($g(^ARCIM(arcItmSub,arcItmVer,1)),"^",1)
	q:itemCode="" 
	s itemDesc=$p($g(^ARCIM(arcItmSub,arcItmVer,1)),"^",2)
	s itemAbbrv=$p($g(^ARCIM(arcItmSub,arcItmVer,1)),"^",3)
	s itemEffDate=$p($p($g(^ARCIM(arcItmSub,arcItmVer,1)),"^",13),"Z",1)
	s:itemEffDate'="" itemEffDate=$zd(itemEffDate,3)
	s itemEffTime=$p($p($g(^ARCIM(arcItmSub,arcItmVer,1)),"^",13),"Z",2)
	s:itemEffTime'="" itemEffTime=$zt(itemEffTime)
	s itemUpdDate=$p($g(^ARCIM(arcItmSub,arcItmVer,8)),"^",1)
	s:itemUpdDate'="" itemUpdDate=$zd(itemUpdDate,3)
	s itemUpdTime=$p($g(^ARCIM(arcItmSub,arcItmVer,8)),"^",2)
	s:itemUpdTime'="" itemUpdTime=$zt(itemUpdTime)
	s itemUpdUserID=$p($g(^ARCIM(arcItmSub,arcItmVer,8)),"^",3),itemUpdUserCode=""
	s:itemUpdUserID'="" itemUpdUserCode=$p($g(^SSU("SSUSR",itemUpdUserID)),"^",1)
	
	d subjson.%Set("businessrowid",arcItmRowid)
	d subjson.%Set("sourcerowid",arcItmRowid)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("ctarcim_code",itemCode)
	d subjson.%Set("ctarcim_desc",itemDesc)
	d subjson.%Set("ctarcim_anoname",itemAbbrv)
	d subjson.%Set("ctarcim_childcategory",arcItmCat)
	d subjson.%Set("ctarcim_codesystemcode","ct_arcitmmast")
	d subjson.%Set("ctarcim_status","1")
	d subjson.%Set("ctarcim_startdate",itemEffDate)
	d subjson.%Set("ctarcim_enddate","")
	d subjson.%Set("ctarcim_creatdate",itemEffDate)
	d subjson.%Set("ctarcim_creattime",itemEffTime)
	d subjson.%Set("ctarcim_updatedate",itemUpdDate)
	d subjson.%Set("ctarcim_updatetime",itemUpdTime)
	d subjson.%Set("ctarcim_updateusercode",itemUpdUserCode)
	d subjson.%Set("ctarcim_remarks","")
	}
	catch
	{
		s subjson={}
		b ;st
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTArcItmMast).PostCTArcItmMastBatch()
ClassMethod PostCTArcItmMastBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
		;w !,returnStream.Read()
	}
	catch
	{
		s $zt=""
	}
	q returnStream
}

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步医嘱项目字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTArcItmMast).SendCTArcItmMastByID("4431||1").Read()
ClassMethod SendCTArcItmMastByID(input As %String = "") As %GlobalCharacterStream
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
	set rowid=input
	do plist.SetAt(rowid,num)
	s datas=..GetCTArcItmMastByID(plist)
	s reqJson."data"=datas
	s reqJson."tableCode"="ct_arcitmmast"
	s mainJson."request"=reqJson
	s jsonStr=mainJson.%ToJSON()
	d retStream.Write(jsonStr)
	b ;jso
	s returnStream=..PostCTArcItmMastBatch(retStream)
	do plist.Clear()
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

}
