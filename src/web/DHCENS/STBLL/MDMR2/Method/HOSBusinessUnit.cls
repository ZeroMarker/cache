Class web.DHCENS.STBLL.MDMR2.Method.HOSBusinessUnit Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：获取科室字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.HOSBusinessUnit).GetHOSBusinessUnit()
ClassMethod GetHOSBusinessUnit(input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	s tableCode="hos_businessunit"
	s returnStream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s reqjson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s businessfieldcode=..#BusinessFieldCode
	s id=input
	if +id=0 {
		s reqjson.data=dataarr
		s reqjson.tableCode=tableCode
		s json.request=reqjson
		d returnStream.Write(json.%ToJSON())
		Quit returnStream
	}
	s locCode=$p($g(^CTLOC(id)),"^",1)
	s locDesc=$p($g(^CTLOC(id)),"^",2)
	s hospDr=$p($g(^CTLOC(id)),"^",22),hospCode="",hospDesc=""
	s:hospDr'="" hospCode=$p($g(^CT("HOSP",hospDr)),"^",1)
	s:hospDr'="" hospDesc=$p($g(^CT("HOSP",hospDr)),"^",2)
	s address=$p($g(^CTLOC(id,"ADDR")),"^",5)
	s typeCode=$p($g(^CTLOC(id)),"^",13)
	s typeDesc=$case(typeCode,"W":"Ward","E":"Execute","DI":"Drug Injection","D":"Dispensing","C":"Cashier","O":"Other","OP":"Operating Theatre","EM":"Emergency","DS":"Day Surgery","MR":"Medical Records","OR":"OutPatient Consulting Room","CL":"Clinic","ADM":"Admission Point",:"")
	s flag=$p($g(^CTLOC(id)),"^",14)
	s dateFrom=$p($g(^CTLOC(id)),"^",24)
	s:dateFrom'="" dateFrom=$zd(dateFrom,3)
	s dateTo=$p($g(^CTLOC(id)),"^",25)
	s:dateTo'="" dateTo=$zd(dateTo,3)
	s seqNo="" ;$p($g(^CTLOC(id)),"^",21)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("bu_code",locCode)
	d subjson.%Set("bu_desc",locDesc)
	d subjson.%Set("bu_orgcode","")
	d subjson.%Set("bu_domaincode","")
	d subjson.%Set("bu_location",address)
	d subjson.%Set("bu_typecode",typeCode)
	d subjson.%Set("bu_typedesc",typeDesc)
	d subjson.%Set("bu_hospital","")
	d subjson.%Set("bu_activity",flag)
	d subjson.%Set("bu_startdate",dateFrom)
	d subjson.%Set("bu_enddate",dateTo)
	d subjson.%Set("bu_createdate","")
	d subjson.%Set("bu_createtime","")
	d subjson.%Set("bu_createuser","")
	d subjson.%Set("bu_seqno",seqNo)
	d subjson.%Set("bu_lastupdatedate","")
	d subjson.%Set("bu_lastupdatetime","")
	d subjson.%Set("bu_lastupdateuser","")
	d subjson.%Set("bu_remarks","")
	d dataarr.%Push(subjson)
	s reqjson.data=dataarr
	s reqjson.tableCode=tableCode
	s json.request=reqjson
	d returnStream.Write(json.%ToJSON())
	Quit returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s reqjson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s reqjson.data=dataarr
	s reqjson.tableCode=tableCode
	s json.request=reqjson
	d returnStream.Write(json.%ToJSON())
	Quit returnStream
}

/// Creator：liyan
/// CreatDate：2022-12-11
/// Description：同步科室字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.HOSBusinessUnit).SendHOSBusinessUnit().Read()
ClassMethod SendHOSBusinessUnit(input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	s returnstream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s mainJson=##class(%DynamicObject).%New()
	s reqJson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s plist=##class(%ArrayOfDataTypes).%New()
	s businessfieldcode=..#BusinessFieldCode
	s retStream=##class(%GlobalCharacterStream).%New()
	s id=0,num=1
	f {
		s id=$o(^CTLOC(id))
		q:id=""
		d plist.SetAt(id,num)
		s num=num+1
		if num>100
		{
			s datas=..GetHOSBusinessUnitByID(plist)
			s reqJson."data"=datas
			s reqJson."tableCode"="hos_businessunit"
			s mainJson."request"=reqJson
			
			s jsonStr=mainJson.%ToJSON()
			d retStream.Write(jsonStr)
			s returnStream=..PostHOSBusinessUnitBatch(retStream)
			do plist.Clear()
			s num=1
		}
	}
	
	set length=plist.Count()
	if length>0 
	{
		set datas=..GetHOSBusinessUnitByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="hos_businessunit"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostHOSBusinessUnitBatch(retStream)
	}
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetHOSBusinessUnitByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetHOSBusinessUnitJson(rowid)
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
/// Description：获取科室字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.HOSBusinessUnit).GetHOSBusinessUnitJson()
ClassMethod GetHOSBusinessUnitJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s businessfieldcode=..#BusinessFieldCode
	s locCode=$p($g(^CTLOC(id)),"^",1)
	s locDesc=$p($g(^CTLOC(id)),"^",2)
	s hospDr=$p($g(^CTLOC(id)),"^",22),hospCode="",hospDesc=""
	s:hospDr'="" hospCode=$p($g(^CT("HOSP",hospDr)),"^",1)
	s:hospDr'="" hospDesc=$p($g(^CT("HOSP",hospDr)),"^",2)
	s address=$p($g(^CTLOC(id,"ADDR")),"^",5)
	s typeCode=$p($g(^CTLOC(id)),"^",13)
	s typeDesc=$case(typeCode,"W":"Ward","E":"Execute","DI":"Drug Injection","D":"Dispensing","C":"Cashier","O":"Other","OP":"Operating Theatre","EM":"Emergency","DS":"Day Surgery","MR":"Medical Records","OR":"OutPatient Consulting Room","CL":"Clinic","ADM":"Admission Point",:"")
	s flag=$p($g(^CTLOC(id)),"^",14)
	s dateFrom=$p($g(^CTLOC(id)),"^",24)
	s:dateFrom'="" dateFrom=$zd(dateFrom,3)
	s dateTo=$p($g(^CTLOC(id)),"^",25)
	s:dateTo'="" dateTo=$zd(dateTo,3)
	s seqNo="" ;$p($g(^CTLOC(id)),"^",21)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("bu_code",locCode)
	d subjson.%Set("bu_desc",locDesc)
	d subjson.%Set("bu_orgcode","")
	d subjson.%Set("bu_domaincode","")
	d subjson.%Set("bu_location",address)
	d subjson.%Set("bu_typecode",typeCode)
	d subjson.%Set("bu_typedesc",typeDesc)
	d subjson.%Set("bu_hospital","")
	d subjson.%Set("bu_activity",flag)
	d subjson.%Set("bu_startdate",dateFrom)
	d subjson.%Set("bu_enddate",dateTo)
	d subjson.%Set("bu_createdate","")
	d subjson.%Set("bu_createtime","")
	d subjson.%Set("bu_createuser","")
	d subjson.%Set("bu_seqno",seqNo)
	d subjson.%Set("bu_lastupdatedate","")
	d subjson.%Set("bu_lastupdatetime","")
	d subjson.%Set("bu_lastupdateuser","")
	d subjson.%Set("bu_remarks","")
	}
	catch
	{
		s subjson={}
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.HOSBusinessUnit).PostHOSBusinessUnitBatch()
ClassMethod PostHOSBusinessUnitBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
