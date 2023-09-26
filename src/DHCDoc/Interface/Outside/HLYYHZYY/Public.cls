Class DHCDoc.Interface.Outside.HLYYHZYY.Public Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 去掉XML中的特殊字符
/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).FormatXML(".34")
ClassMethod FormatXML(XMLInfo As %String) As %String
{
	s XMLInfo=$replace(XMLInfo,$c(0),"")
	s XMLInfo=$replace(XMLInfo,$c(10),"")
	s XMLInfo=$replace(XMLInfo,$c(13),"")
	s XMLInfo=$replace(XMLInfo,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
	Q XMLInfo
}

/// 转换日期格式
/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).TransDateFormat("25/02/2021")
ClassMethod TransDateFormat(Date As %String) As %String
{
	Q:Date="" ""
	if (Date["-") s Date=$zdh(Date,3)
	if (Date["/") s Date=$zdh(Date,4)
	s Date=$zd(Date,3)
	Q Date
}

/// 转换时间格式
/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).TransTimeFormat("15:56")
ClassMethod TransTimeFormat(Time As %String) As %String
{
	Q:Time="" ""
	if (Time[":") s Time=$zth(Time,1)
	s Time=$zt(Time,1)
	Q Time
}

/// 包装规格数量
/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).GetCountUnit("","","")
ClassMethod GetCountUnit(ARCIMRowId As %String, InciRowid As %String, PackUOMRowid As %String) As %String
{
	s countunit=##class(web.DHCDocOrderEntry).GetConFac(ARCIMRowId,InciRowid,PackUOMRowid)
	;不清楚为啥 第三方要求只要数量单位不是盒 包装数量写死1
	s PackUOMDesc=""
	if (PackUOMRowid'="") s PackUOMDesc=$p($g(^CT("UOM",PackUOMRowid)),"^",2)
    if (PackUOMDesc'["盒") s countunit=1
    ;
    Q countunit
}

/// 得到医嘱是否为草药	0 不是,1 是
/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).IsCNMedItem("23","1||1")
ClassMethod IsCNMedItem(EpisodeID As %String, ARCIMRowid As %String) As %String
{
	s HospitalId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID),"^",1)
	s ret=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowid,HospitalId)
	Q ret
}

}
