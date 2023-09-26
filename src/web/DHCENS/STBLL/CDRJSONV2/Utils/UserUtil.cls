Class web.DHCENS.STBLL.CDRJSONV2.Utils.UserUtil Extends (%RegisteredObject, %XML.Adaptor)
{

/// descrption：HIS根据CTCarepoovid获取Userid
/// create: lzb
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.Utils.UserUtil).queryUseridByCTCarepoovid()
ClassMethod queryUseridByCTCarepoovid(CTCarepoovid As %String) As %String
{
	set userId=""
	try{
		if (CTCarepoovid'=""){
			set userId=$o(^SSU("SSUSR",0,"CTPCP",CTCarepoovid,""))
		}		
	}catch{	
		set userId=CTCarepoovid
	}
	quit userId
}

/// descrption：HIS根据Userid获取CTCarepoovid
/// create: lzb
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.Utils.UserUtil).queryCarepoovidByUserid(3425)
ClassMethod queryCarepoovidByUserid(userid As %String) As %String
{
	set CTCarepoovid=""
	try{
		if (userid'=""){
			set CTCarepoovid=$p($g(^SSU("SSUSR",userid)),"^",14)
		}		
	}catch{	
		set CTCarepoovid=userid
	}
	quit CTCarepoovid
}

}
