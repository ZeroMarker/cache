Import sqluser

Class web.DHCSTPHCMLogon Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod logon(userName As %String, password As %String) As %GlobalCharacterStream
{
		n (userName , password )
		s OutBinStream=##Class(%GlobalCharacterStream).%New()
		s $zt="errorLogon"
		s userId=##class(web.SSUser).IsValidUser(userName,password)
		s json=##class(%ArrayOfDataTypes).%New()
		i userId<0 d
		.s errorInfo=$s(userId="-100":"用户不存在",userId="-101":"密码不正确",userId="-102":"用户没有激活",1:"")
		s sscode="",ssname="" 
		i +userId>0 d
		.s sscode=$p(^SSU("SSUSR",userId),"^",1)
		.s ssname=$p(^SSU("SSUSR",userId),"^",2)
		.s sspwd=$p(^SSU("SSUSR",userId),"^",3)
		.//s chkloc=..CheckUserLoc(userId)
		.s PrvTpDesc=##Class(web.DHCSTPHCMLogon).GetCarPrvTp(userId)
		s chkloc=1
		s locJson=..getUserLoc(userId)
		d json.SetAt($g(errorInfo),"ErrorInfo")
		d json.SetAt($g(locJson),"Locs")
		d json.SetAt(userId,"UserID")
		d json.SetAt(sscode,"UserCode")
		d json.SetAt(ssname,"UserName")
		d json.SetAt($g(sspwd),"UserPwd")
		d json.SetAt(PrvTpDesc,"PrvTpDesc")
		i ($g(errorInfo)="")&&(locJson.Count()=0) d
		.s errorInfo="用户没有可登陆的科室"
		.d json.SetAt($g(errorInfo),"ErrorInfo")
		e  d
		.i $g(chkloc)=0 d
		..s errorInfo="用户无配液中心登录权限"
		..d json.SetAt($g(errorInfo),"ErrorInfo")
		.
		.d OutBinStream.Write(##class(Nur.JSON).Encode(json))
		q OutBinStream
errorLogon
	s error=$ze
	s json=##class(%ArrayOfDataTypes).%New()
	d json.SetAt($g(error),"ErrorInfo")
	d OutBinStream.Write(##class(Nur.JSON).Encode(json))
	q OutBinStream
}

ClassMethod getUserLoc(userId As %String) As %ListOfDataTypes
{
		n (userId)

		s locJson=##class(%ListOfDataTypes).%New()
		q:+userId=0 locJson
		q:'$d(^SSU("SSUSR",userId)) locJson

		s ssuser=userId
		s ctlocdr=$p(^SSU("SSUSR",ssuser),"^",4)
		s ctloc=$p(^CTLOC(ctlocdr),"^",2)
		i $f(ctloc,"-") s ctloc=$p(ctloc,"-",2)
		s grpdr=$p(^SSU("SSUSR",ssuser),"^",5)
		s grpdesc=$p(^SSU("SSGRP",grpdr),"^",1)
		;s locChildJson=##class(%ArrayOfDataTypes).%New()
		;d locChildJson.SetAt("科室ID","ctlocdr")
		;d locChildJson.SetAt("科室","ctloc")
		;d locChildJson.SetAt("安全组ID","grpdr")
		;d locChildJson.SetAt("安全组","grpdesc")
		;d locJson.Insert(locChildJson)
		s locChildJson=##class(%ArrayOfDataTypes).%New()
		d locChildJson.SetAt(ctlocdr,"ctlocdr")
		d locChildJson.SetAt(ctloc,"ctloc")
		d locChildJson.SetAt(grpdr,"grpdr")
		d locChildJson.SetAt(grpdesc,"grpdesc")
		d locJson.Insert(locChildJson)
		
		s chl=""
		f  s chl=$o(^SSU("SSUSR",ssuser,"OTHLL",chl)) q:chl=""  d
		.s ctlocdr=$p(^SSU("SSUSR",ssuser,"OTHLL",chl),"^",1)
		.q:ctlocdr=""
		.s ctloc=$p(^CTLOC(ctlocdr),"^",2)
		.i $f(ctloc,"-") s ctloc=$p(ctloc,"-",2)
		.s grpdr=$p(^SSU("SSUSR",ssuser,"OTHLL",chl),"^",2)
		.q:grpdr=""
		.s grpdesc=$p(^SSU("SSGRP",grpdr),"^",1)
		.s locChildJson=##class(%ArrayOfDataTypes).%New()
		.d locChildJson.SetAt(ctlocdr,"ctlocdr")
		.d locChildJson.SetAt(ctloc,"ctloc")
		.d locChildJson.SetAt(grpdr,"grpdr")
		.d locChildJson.SetAt(grpdesc,"grpdesc")
		.d locJson.Insert(locChildJson)
		
		q locJson
}

/// Creator:    bianshuai
/// CreateDate: 2017-07-20
/// Descript:   用户职称
/// InPut:      UserID-用户ID
/// OutPut:     职称描述
/// w ##Class(web.DHCSTPHCMLogon).GetCarPrvTp("")
ClassMethod GetCarPrvTp(UserID As %String) As %String
{
	n (UserID)
	Q:UserID="" ""
	s CareProvID=$p(^SSU("SSUSR",UserID),"^",14)
	Q:CareProvID="" ""
	s PrvTpID=$p(^CTPCP(CareProvID,1),"^",4)
	Q:PrvTpID="" ""
	s PrvTpDesc=$p(^CT("CPT",PrvTpID),"^",2)
	Q PrvTpDesc
}

}
