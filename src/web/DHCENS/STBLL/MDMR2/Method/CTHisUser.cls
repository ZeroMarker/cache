Class web.DHCENS.STBLL.MDMR2.Method.CTHisUser Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2023-01-11
/// Description：同步用户字典到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTHisUser).SendCTHisUser().Read()
ClassMethod SendCTHisUser(input As %String = "") As %GlobalCharacterStream
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
		s id=$o(^SSU("SSUSR",id))
		q:id=""
		d plist.SetAt(id,num)
		s num=num+1
		if num>100
		{
			s datas=..GetCTHisUserByID(plist)
			s reqJson."data"=datas
			s reqJson."tableCode"="ct_hisuser"
			s mainJson."request"=reqJson
			s jsonStr=mainJson.%ToJSON()
			d retStream.Write(jsonStr)
			s returnStream=..PostCTHisUserBatch(retStream)
			do plist.Clear()
			s num=1
		}
	}
	
	set length=plist.Count()
	if length>0 
	{
		set datas=..GetCTHisUserByID(plist)
		s reqJson."data"=datas
		s reqJson."tableCode"="ct_hisuser"
		s mainJson."request"=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Clear()
		d retStream.Write(jsonStr)
		s returnStream=..PostCTHisUserBatch(retStream)
	}
	
	q returnStream
Exception
	s returnStream=##class(%GlobalCharacterStream).%New()
	Quit returnStream
}

ClassMethod GetCTHisUserByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetCTHisUserJson(rowid)
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
/// Description：获取用户字典
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.CTHisUser).GetCTHisUserJson()
ClassMethod GetCTHisUserJson(id As %String = "") As %Library.DynamicObject
{
	try
	{
	s businessfieldcode=..#BusinessFieldCode
	s userCode=$p($g(^SSU("SSUSR",id)),"^",1)
	s userDesc=$p($g(^SSU("SSUSR",id)),"^",2)
	s deptDr=$p($g(^SSU("SSUSR",id)),"^",4),deptCode=""
	s:deptDr'="" deptCode=$p($g(^CTLOC(deptDr)),"^",1)
	s groupDr=$p($g(^SSU("SSUSR",id)),"^",5),groupCode=""
	s:groupDr'="" groupCode=$p($g(^SSU("SSGRP",groupDr)),"^",1)
	s stDate=$p($g(^SSU("SSUSR",id)),"^",96)
	s:stDate'="" stDate=$zd(stDate,3)
	s edDate=$p($g(^SSU("SSUSR",id)),"^",97)
	s:edDate'="" edDate=$zd(edDate,3)
	s mobile=$p($g(^SSU("SSUSR",id)),"^",99)
	s email=$p($g(^SSU("SSUSR",id)),"^",101)
	s creatDate=$p($g(^SSU("SSUSR",id)),"^",115)
	s:creatDate'="" creatDate=$zd(creatDate,3)
	s creatTime=$p($g(^SSU("SSUSR",id)),"^",116)
	s:creatTime'="" creatTime=$zt(creatTime)
	s updDate=$p($g(^SSU("SSUSR",id)),"^",76)
	s:updDate'="" updDate=$zd(updDate,3)
	s updTime=$p($g(^SSU("SSUSR",id)),"^",77)
	s:updTime'="" updTime=$zt(updTime)
	s updUserDr=$p($g(^SSU("SSUSR",id)),"^",75),updUserCode=""
	s:updUserDr'="" updUserCode=$p($g(^SSU("SSUSR",updUserDr)),"^",1)
	s subjson=##class(%DynamicObject).%New()
	d subjson.%Set("businessrowid",id)
	d subjson.%Set("sourcerowid",id)
	d subjson.%Set("businessfieldcode",businessfieldcode)
	d subjson.%Set("cthu_id",userCode)
	d subjson.%Set("cthu_name",userDesc)
	d subjson.%Set("cthu_codesystemcode","ct_hisuser")
	d subjson.%Set("cthu_status","1")
	d subjson.%Set("cthu_phonenum",mobile)
	d subjson.%Set("cthu_email",email)
	d subjson.%Set("cthu_deptcode",deptCode)
	d subjson.%Set("cthu_secugroupcode",groupCode)
	d subjson.%Set("cthu_startdate",stDate)
	d subjson.%Set("cthu_enddate",edDate)
	d subjson.%Set("cthu_creatdate",creatDate)
	d subjson.%Set("cthu_creattime",creatTime)
	d subjson.%Set("cthu_updatedate",updDate)
	d subjson.%Set("cthu_updatetime",updTime)
	d subjson.%Set("cthu_updateusercode",updUserCode)
	d subjson.%Set("cthu_remarks","")
	}
	catch
	{
		s subjson={}
		s $zt=""
	}
	Quit subjson
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.CTHisUser).PostCTHisUserBatch()
ClassMethod PostCTHisUserBatch(stream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
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
