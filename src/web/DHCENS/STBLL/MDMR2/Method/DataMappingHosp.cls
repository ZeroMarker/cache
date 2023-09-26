Class web.DHCENS.STBLL.MDMR2.Method.DataMappingHosp Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：liyan
/// CreatDate：2022-12-11
/// Description：获取BDP_MappingHosp表的映射数据
/// Table：BDP_MappingHosp
/// Input： BDP_MappingHosp id
/// Return：字典与院区映射数据
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.DataMappingHosp).GetBDPMappingHosp()
ClassMethod GetBDPMappingHosp(input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	s length=$L(input,"^")
	s returnstream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s reqjson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s (tablecode,tablerowid,hosprowid)=""
	s businessfieldcode=..#BusinessFieldCode
	f i=1:1:length {
		s id=$p(input,"^",i)
		continue:+id=0
		s tablecode=$LG(^User.BDPMappingHospD(input),2)
		s tablerowid=$LG(^User.BDPMappingHospD(input),3)
		continue:(tablecode="")||(tablerowid="")
		s hosprowids=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospitalDetail(tablecode,tablerowid)
		s hospcounts=$L(hosprowids,",")
		f j=1:1:hospcounts {
			s hosprowid=$p(hosprowids,",",j)
			continue:hosprowid=""
			s subjson=##class(%DynamicObject).%New()
			d subjson.%Set("dlh_tablecode",tablecode)
			d subjson.%Set("dlh_tablerowid",tablerowid)
			d subjson.%Set("dlh_hosprowid",hosprowid)
			d subjson.%Set("businessfieldcode",businessfieldcode)
			d dataarr.%Push(subjson)
		}
	}
	s reqjson.data=dataarr
	s reqjson.tablecode="ct_datalinkhospital"
	s json.request=reqjson
	d returnstream.Write(json.%ToJSON())
	Quit returnstream
Exception
	s returnstream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s reqjson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s reqjson.data=dataarr
	s reqjson.tablecode="ct_datalinkhospital"
	s json.request=reqjson
	d returnstream.Write(json.%ToJSON())
	Quit returnstream
}

/// Creator：liyan
/// CreatDate：2022-12-11
/// Description：同步BDP_MappingHosp表的映射数据到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.DataMappingHosp).SendBDPMappingHosp().Read()
ClassMethod SendBDPMappingHosp(input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	s returnstream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s reqjson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s (tablecode,tablerowid,hosprowid)=""
	s businessfieldcode=..#BusinessFieldCode
	if input'="" {
		s reqstream=##class(%GlobalCharacterStream).%New()
		s tablecode=$LG(^User.BDPMappingHospD(input),2)
		s tablerowid=$LG(^User.BDPMappingHospD(input),3)
		q:(tablecode="")||(tablerowid="")
		s hosprowids=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospitalDetail(tablecode,tablerowid)
		s hospcounts=$L(hosprowids,",")
		f j=1:1:hospcounts {
			s hosprowid=$p(hosprowids,",",j)
			continue:hosprowid=""
			s subjson=##class(%DynamicObject).%New()
			d subjson.%Set("dlh_tablecode",tablecode)
			d subjson.%Set("dlh_tablerowid",tablerowid)
			d subjson.%Set("dlh_hosprowid",hosprowid)
			d subjson.%Set("businessfieldcode",businessfieldcode)
			d dataarr.%Push(subjson)
		}
		s reqjson.data=dataarr
		s reqjson.tablecode="ct_datalinkhospital"
		s json.request=reqjson
		s httprequest=##class(%Net.HttpRequest).%New()
		d httprequest.SetHeader("Content-Type","application/json;charset=utf-8")
		s url="http://119.255.194.78:8003/api/dict/general"
		d httprequest.EntityBody.Write(json.%ToJSON())
		s ret = httprequest.Post(url)
		s returnstream = httprequest.HttpResponse.Data
	}
	else {
		s reqstream=##class(%GlobalCharacterStream).%New()
		s id=""
		f {
			s id=$o(^User.BDPMappingHospD(id))
			q:id=""
			s tablecode=$LG(^User.BDPMappingHospD(id),2)
			s tablerowid=$LG(^User.BDPMappingHospD(id),3)
			continue:(tablecode="")||(tablerowid="")
			s hosprowids=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospitalDetail(tablecode,tablerowid)
			s hospcounts=$L(hosprowids,",")
			f j=1:1:hospcounts {
				s hosprowid=$p(hosprowids,",",j)
				continue:hosprowid=""
				s subjson=##class(%DynamicObject).%New()
				d subjson.%Set("dlh_tablecode",tablecode)
				d subjson.%Set("dlh_tablerowid",tablerowid)
				d subjson.%Set("dlh_hosprowid",hosprowid)
				d subjson.%Set("businessfieldcode",businessfieldcode)
				d dataarr.%Push(subjson)
				if dataarr.%Size()=50 {
					s reqjson.data=dataarr
					s reqjson.tablecode="ct_datalinkhospital"
					s json.request=reqjson
					s httprequest=##class(%Net.HttpRequest).%New()
					d httprequest.SetHeader("Content-Type","application/json;charset=utf-8")
					//s url="http://119.255.194.78:8003/api/dict/general"
					s url="http://211.101.232.11:9003/api/dict/general"
					d httprequest.EntityBody.Write(json.%ToJSON())
					s ret = httprequest.Post(url)
					s returnstream = httprequest.HttpResponse.Data
					s dataarr=##class(%DynamicArray).%New()
					d reqstream.Clear()
				}
			}
		}
		if dataarr.%Size()>0 {
			s reqjson.data=dataarr
			s reqjson.tablecode="ct_datalinkhospital"
			s json.request=reqjson
			s httprequest=##class(%Net.HttpRequest).%New()
			d httprequest.SetHeader("Content-Type","application/json;charset=utf-8")
			//s url="http://119.255.194.78:8003/api/dict/general"
			s url="http://211.101.232.11:9003/api/dict/general"
			d httprequest.EntityBody.Write(json.%ToJSON())
			s ret = httprequest.Post(url)
			s returnstream = httprequest.HttpResponse.Data
		}
	}
	q returnstream
Exception
	s returnstream=##class(%GlobalCharacterStream).%New()
	Quit returnstream
}

/// Creator：liyan
/// CreatDate：2022-12-11
/// Description：获取医嘱项和院区的映射数据
/// Table：ARC_ItemHosp
/// Input： ARC_ItemHosp id
/// Return：库存项与院区的映射数据
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.DataMappingHosp).GetARCItemMappingHosp()
ClassMethod GetARCItemMappingHosp(input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	s returnstream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s reqjson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s businessfieldcode=..#BusinessFieldCode
	s tablerowid=$p(input,"||",1,2)
	s tablecode="ARC_ItmMast"
	s hosprowids=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospitalDetail(tablecode,tablerowid)
	s hospcounts=$L(hosprowids,",")
	f j=1:1:hospcounts {
		s hosprowid=$p(hosprowids,",",j)
		continue:hosprowid=""
		s subjson=##class(%DynamicObject).%New()
		d subjson.%Set("dlh_tablecode",tablecode)
		d subjson.%Set("dlh_tablerowid",tablerowid)
		d subjson.%Set("dlh_hosprowid",hosprowid)
		d subjson.%Set("businessfieldcode",businessfieldcode)
		d dataarr.%Push(subjson)
	}
	s reqjson.data=dataarr
	s reqjson.tablecode="ct_datalinkhospital"
	s json.request=reqjson
	d returnstream.Write(json.%ToJSON())
	Quit returnstream
Exception
	s returnstream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s reqjson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s reqjson.data=dataarr
	s reqjson.tablecode="ct_datalinkhospital"
	s json.request=reqjson
	d returnstream.Write(json.%ToJSON())
	Quit returnstream
}

/// Creator：liyan
/// CreatDate：2022-12-11
/// Description：同步医嘱项和院区的映射数据到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.DataMappingHosp).SendARCItemMappingHosp()
ClassMethod SendARCItemMappingHosp(input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	s returnstream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s reqjson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s (tablecode,tablerowid,hosprowid)=""
	s businessfieldcode=..#BusinessFieldCode
	if input'="" {
		//^ARCIM(1,1,"HOSP",1)
		s tablecode="ARC_ItmMast"
		s tablerowid=$p(input,"||",1,2)
		q:(tablecode="")||(tablerowid="")
		s reqstream=##class(%GlobalCharacterStream).%New()
		s hosprowids=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospitalDetail(tablecode,tablerowid)
		s hospcounts=$L(hosprowids,",")
		f j=1:1:hospcounts {
			s hosprowid=$p(hosprowids,",",j)
			continue:hosprowid=""
			s subjson=##class(%DynamicObject).%New()
			d subjson.%Set("dlh_tablecode",tablecode)
			d subjson.%Set("dlh_tablerowid",tablerowid)
			d subjson.%Set("dlh_hosprowid",hosprowid)
			d subjson.%Set("businessfieldcode",businessfieldcode)
			d dataarr.%Push(subjson)
		}
		s reqjson.data=dataarr
		s reqjson.tablecode="ct_datalinkhospital"
		s json.request=reqjson
		s httprequest=##class(%Net.HttpRequest).%New()
		d httprequest.SetHeader("Content-Type","application/json;charset=utf-8")
		s url="http://119.255.194.78:8003/api/dict/general"
		d httprequest.EntityBody.Write(json.%ToJSON())
		s ret = httprequest.Post(url)
		s returnstream = httprequest.HttpResponse.Data
	}
	else {
		s reqstream=##class(%GlobalCharacterStream).%New()
		s sql="select distinct HOSP_ParRef as tablerowid from ARC_ItemHosp"
		s rs=##class(%ResultSet).%New()
		d rs.Prepare(sql)
		s sc=rs.Execute()
		While(rs.Next())  {
			s tablecode="ARC_ItmMast"
			s tablerowid=rs.Data("tablerowid")
			continue:(tablecode="")||(tablerowid="")
			s hosprowids=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospitalDetail(tablecode,tablerowid)
			s hospcounts=$L(hosprowids,",")
			f j=1:1:hospcounts {
				s hosprowid=$p(hosprowids,",",j)
				continue:hosprowid=""
				s subjson=##class(%DynamicObject).%New()
				d subjson.%Set("dlh_tablecode",tablecode)
				d subjson.%Set("dlh_tablerowid",tablerowid)
				d subjson.%Set("dlh_hosprowid",hosprowid)
				d subjson.%Set("businessfieldcode",businessfieldcode)
				d dataarr.%Push(subjson)
				if dataarr.%Size()=50 {
					s reqjson.data=dataarr
					s reqjson.tablecode="ct_datalinkhospital"
					s json.request=reqjson
					s httprequest=##class(%Net.HttpRequest).%New()
					d httprequest.SetHeader("Content-Type","application/json;charset=utf-8")
					s url="http://119.255.194.78:8003/api/dict/general"
					d httprequest.EntityBody.Write(json.%ToJSON())
					s ret = httprequest.Post(url)
					s returnstream = httprequest.HttpResponse.Data
					s dataarr=##class(%DynamicArray).%New()
					d reqstream.Clear()
				}
			}
		}
		if dataarr.%Size()>0 {
			s reqjson.data=dataarr
			s reqjson.tablecode="ct_datalinkhospital"
			s json.request=reqjson
			s httprequest=##class(%Net.HttpRequest).%New()
			d httprequest.SetHeader("Content-Type","application/json;charset=utf-8")
			s url="http://119.255.194.78:8003/api/dict/general"
			d httprequest.EntityBody.Write(json.%ToJSON())
			s ret = httprequest.Post(url)
			s returnstream = httprequest.HttpResponse.Data
		}
	}
	q returnstream
Exception
	s returnstream=##class(%GlobalCharacterStream).%New()
	Quit returnstream
}

/// Creator：liyan
/// CreatDate：2022-12-11
/// Description：获取库存项和院区的映射数据
/// Table：DHC_ItmAddHosp
/// Input： DHC_ItmAddHosp id
/// Return：库存项与院区的映射数据
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.DataMappingHosp).GetINCItmMappingHosp()
ClassMethod GetINCItmMappingHosp(input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	s returnstream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s reqjson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	if input="" {
		s reqjson.data=dataarr
		s reqjson.tablecode="ct_datalinkhospital"
		s json.request=reqjson
		d returnstream.Write(json.%ToJSON())
		Quit returnstream
		}
	s businessfieldcode=..#BusinessFieldCode
	s tablerowid=$p($g(^ITMADDHOP(input)),"^",1)
	s tablecode="INC_Itm"
	s hosprowids=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospitalDetail(tablecode,tablerowid)
	s hospcounts=$L(hosprowids,",")
	f j=1:1:hospcounts {
		s hosprowid=$p(hosprowids,",",j)
		continue:hosprowid=""
		s subjson=##class(%DynamicObject).%New()
		d subjson.%Set("dlh_tablecode",tablecode)
		d subjson.%Set("dlh_tablerowid",tablerowid)
		d subjson.%Set("dlh_hosprowid",hosprowid)
		d subjson.%Set("businessfieldcode",businessfieldcode)
		d dataarr.%Push(subjson)
	}
	s reqjson.data=dataarr
	s reqjson.tablecode="ct_datalinkhospital"
	s json.request=reqjson
	d returnstream.Write(json.%ToJSON())
	Quit returnstream
Exception
	s returnstream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s reqjson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s reqjson.data=dataarr
	s reqjson.tablecode="ct_datalinkhospital"
	s json.request=reqjson
	d returnstream.Write(json.%ToJSON())
	Quit returnstream
}

/// Creator：liyan
/// CreatDate：2022-12-11
/// Description：同步库存项和院区的映射数据到MDM
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.DataMappingHosp).SendINCItmMappingHosp()
ClassMethod SendINCItmMappingHosp(input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	s returnstream=##class(%GlobalCharacterStream).%New()
	s json=##class(%DynamicObject).%New()
	s reqjson=##class(%DynamicObject).%New()
	s dataarr=##class(%DynamicArray).%New()
	s (tablecode,tablerowid,hosprowid)=""
	s businessfieldcode=..#BusinessFieldCode
	if input'="" {
		s tablecode="INC_Itm"
		s tablerowid=$p($g(^ITMADDHOP(input)),"^",1)
		q:(tablecode="")||(tablerowid="")
		s reqstream=##class(%GlobalCharacterStream).%New()
		s hosprowids=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospitalDetail(tablecode,tablerowid)
		s hospcounts=$L(hosprowids,",")
		f j=1:1:hospcounts {
			s hosprowid=$p(hosprowids,",",j)
			continue:hosprowid=""
			s subjson=##class(%DynamicObject).%New()
			d subjson.%Set("dlh_tablecode",tablecode)
			d subjson.%Set("dlh_tablerowid",tablerowid)
			d subjson.%Set("dlh_hosprowid",hosprowid)
			d subjson.%Set("businessfieldcode",businessfieldcode)
			d dataarr.%Push(subjson)
		}
		s reqjson.data=dataarr
		s reqjson.tablecode="ct_datalinkhospital"
		s json.request=reqjson
		s httprequest=##class(%Net.HttpRequest).%New()
		d httprequest.SetHeader("Content-Type","application/json;charset=utf-8")
		s url="http://119.255.194.78:8003/api/dict/general"
		d httprequest.EntityBody.Write(json.%ToJSON())
		s ret = httprequest.Post(url)
		s returnstream = httprequest.HttpResponse.Data
	}
	else {
		s reqstream=##class(%GlobalCharacterStream).%New()
		s id=""
		f {
			s id=$o(^ITMADDHOP(id))
			q:id=""
			s tablecode="INC_Itm"
			s tablerowid=$p($g(^ITMADDHOP(id)),"^",1)
			continue:(tablecode="")||(tablerowid="")
			s hosprowids=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospitalDetail(tablecode,tablerowid)
			s hospcounts=$L(hosprowids,",")
			f j=1:1:hospcounts {
				s hosprowid=$p(hosprowids,",",j)
				continue:hosprowid=""
				s subjson=##class(%DynamicObject).%New()
				d subjson.%Set("dlh_tablecode",tablecode)
				d subjson.%Set("dlh_tablerowid",tablerowid)
				d subjson.%Set("dlh_hosprowid",hosprowid)
				d subjson.%Set("businessfieldcode",businessfieldcode)
				d dataarr.%Push(subjson)
				if dataarr.%Size()=50 {
					s reqjson.data=dataarr
					s reqjson.tablecode="ct_datalinkhospital"
					s json.request=reqjson
					s httprequest=##class(%Net.HttpRequest).%New()
					d httprequest.SetHeader("Content-Type","application/json;charset=utf-8")
					s url="http://119.255.194.78:8003/api/dict/general"
					d httprequest.EntityBody.Write(json.%ToJSON())
					s ret = httprequest.Post(url)
					s returnstream = httprequest.HttpResponse.Data
					s dataarr=##class(%DynamicArray).%New()
					d reqstream.Clear()
				}
			}
		}
		if dataarr.%Size()>0 {
			s reqjson.data=dataarr
			s reqjson.tablecode="ct_datalinkhospital"
			s json.request=reqjson
			s httprequest=##class(%Net.HttpRequest).%New()
			d httprequest.SetHeader("Content-Type","application/json;charset=utf-8")
			;s url="http://119.255.194.78:8003/api/dict/general"
			s url=..#DictUrl
			d httprequest.EntityBody.Write(json.%ToJSON())
			s ret = httprequest.Post(url)
			s returnstream = httprequest.HttpResponse.Data
		}
	}
	q returnstream
Exception
	s returnstream=##class(%GlobalCharacterStream).%New()
	Quit returnstream
}

}
