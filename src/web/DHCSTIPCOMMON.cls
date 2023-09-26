Import sqluser

Class web.DHCSTIPCOMMON Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 验证用户名密码并且返回可以登录的病区
/// w ##class(web.DHCSTIPCOMMON).logon("702","1")
ClassMethod logon(userName As %String, password As %String) As %String
{
		n (userName , password )
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
		s chkloc=1
		s locJson=..getUserLoc(userId)
		d json.SetAt($g(errorInfo),"ErrorInfo")
		d json.SetAt($g(locJson),"Locs")
		d json.SetAt(userId,"UserID")
		d json.SetAt(sscode,"UserCode")
		d json.SetAt(ssname,"UserName")
		d json.SetAt($g(sspwd),"UserPwd")
		i ($g(errorInfo)="")&&(locJson.Count()=0) d
		.s errorInfo="用户没有可登陆的科室"
		.d json.SetAt($g(errorInfo),"ErrorInfo")
		e  d
		.i $g(chkloc)=0 d
		..s errorInfo="用户无配液中心登录权限"
		..d json.SetAt($g(errorInfo),"ErrorInfo")
		.
		q ##class(Nur.JSON).Encode(json)
errorLogon
	s error=$ze
	s json=##class(%ArrayOfDataTypes).%New()
	d json.SetAt($g(error),"ErrorInfo")
	q ##class(Nur.JSON).Encode(json)
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

/// 根据病区ID查找病人分组分别存在不同的组里group
/// 最后插入到list里    groups 存储  group  存储  patients
/// w ##class(Nur.Iphone.Common).getWardPats(20)
ClassMethod getWardPats(wardId As %String) As %String
{
	n (wardId)
	s profileobj=##Class(epr.CTIconProfile).%OpenId(1)
	s groups=##class(%ListOfDataTypes).%New()
	s rs=##class(%ResultSet).%New("Nur.Iphone.Query:findWardPat")
	d rs.Execute(wardId)
	while(rs.Next()){
			s episodeID=rs.GetDataByName("EpisodeID")
			s groupDesc=rs.GetDataByName("GroupDesc")
			i $g(Exist(groupDesc))="" d
			.b
			.s group(groupDesc)=##class(%ArrayOfDataTypes).%New()
			.d group(groupDesc).SetAt(groupDesc,"GroupDesc")
			.s groupPats(groupDesc)=##class(%ListOfDataTypes).%New()
			s patInfo=##class(web.DHCNurIpComm).NurPatInfo(episodeID)
			//G(PatName)_"^"_$G(Sex)_"^"_$G(Age)_"^"_$G(BedCode)_"^"_$G(RegNo)_"^"_$G(AdmDate)_"^"_$G(total)_"^"_$G(depos)_"^"_$G(warrant)_"^"_$G(admreason)_"^"_$G(ctloc)_"^"_$G(docdes)_"^"_$G(InsuId)_"^"_homeaddres_"^"_hometel_"^"_MedCareNo_"^"_$G(Nation)_"^"_$G(paersonLX)_"^"_$g(IdentityNo)
			s patName=$p(patInfo,"^",1)
			s patBedCode=$p(patInfo,"^",4)_"床"
			s patRegNo=$p(patInfo,"^",5)
			s pat=##class(%ArrayOfDataTypes).%New()
			d pat.SetAt(patName,"PatName")
			d pat.SetAt(patBedCode,"PatBedCode")
			d pat.SetAt(patRegNo,"PatRegNo")
			d pat.SetAt(episodeID,"PatEpisodeID")
			d pat.SetAt(..getImages(episodeID),"PatImages")
			
			d groupPats(groupDesc).Insert(pat)
			s Exist(groupDesc)=1
		}
	s index=""
	b //d
	f  s index=$o(group(index)) q:index=""  d
	.d group(index).SetAt(groupPats(index),"Patients")
	.d groups.Insert(group(index))
	.b ///dd
	q ##class(Nur.JSON).Encode(groups)
}

/// 查询病人应该显示哪些图标
ClassMethod getImages(EpisodeID As %String) As %ListOfDataTypes
{
	n (EpisodeID)
	s images=##class(%ListOfDataTypes).%New()
	s profileobj=##Class(epr.CTIconProfile).%OpenId(1)
	if $IsObject(profileobj){
		s count=profileobj.Items.Count()
		for i=1:1:count {
			s itemobj=profileobj.Items.GetAt(i)
			s iconobj=itemobj.IconDR
			if $IsObject(iconobj) {
				s img=0
				s title=""
				continue:iconobj.CondExpr=""
				d ##class(websys.Conversions).expressionExecute(iconobj.CondExpr)
				continue:img'=1 
				continue:iconobj.Icon=""
				if $g(title)="" s title=iconobj.Description
				;if iconobj.CondDescription'="" XECUTE iconobj.CondDescription  //add by wuqk 2011-07-14
				s Sequence=itemobj.Sequence
				s imageName=$replace(iconobj.Icon,"\","/")
				if Sequence="" {
					d images.Insert(imageName)
				}else{
					s iconArr(Sequence)=imageName
				}
			}
		}
		s seq=$O(iconArr(""))
		while (seq'=""){
			d images.InsertAt(iconArr(seq),+seq)
			s seq=$O(iconArr(seq))
			Q:seq=""
		}
	}
	q images
}

/// 转换日期时间成系统数字
ClassMethod transDatetoLogical(date As %String) As %String
{
	n (date)
	s logicalDate=+date
	i $l(date,"/")=3 s logicalDate=$zdh(date,4)
	i $l(date,"-")=3 s logicalDate=$zdh(date,3)
	i date="" s logicalDate=+$h
	q logicalDate
}

/// 转换时间成系统数字
ClassMethod transTimetoLogical(time As %String) As %String
{
	n (time)
	s logicalTime=+time
	i $l(time,":")=3 s logicalTime=$zth(time)
	i time="" s logicalTime=$p($h,2)
	q logicalTime
}

/// 统一取最大进程号
ClassMethod GetPID() As %String
{
	 s pid=$I(^DHCSTIPHONE("ANDROID"))
     q pid
}

/// 　获取安全组集合
ClassMethod GetUserGrpDs(GrpName) As %String
{
    n (GrpName)

    s GrpName=$$ALPHAUP^SSUTIL4(GrpName)
    s StPage=0
    s Limit=99999
	s h=0
	s pid=##class(web.DHCSTIPCOMMON).GetPID()
	s endpage=StPage+Limit  //结束行
	s StPage=StPage+1 //开始行
	s ssgrp=""
	f  s ssgrp=$o(^SSU("SSGRP",ssgrp)) q:ssgrp=""  d
	.s desc=$p(^SSU("SSGRP",ssgrp),"^",1)
	.s tmpdesc=$$ALPHAUP^SSUTIL4(desc)
	.q:tmpdesc'[GrpName
	.s rowid=ssgrp
    .s h=h+1
	.s data=desc_"^"_rowid
    .s ^TMP("DHCST","DHCSTIPCOMMON","GetUserGrpDs",pid,h)=data

    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    
 	s maxrow=h
 	i endpage>maxrow s endpage=maxrow

    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTIPCOMMON","GetUserGrpDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTIPCOMMON","GetUserGrpDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .s count=count+1
    .q:count<StPage
    .q:count>endpage
    .
	.s desc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=desc_rowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=StPage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("DHCST","DHCSTIPCOMMON","GetUserGrpDs",pid)

    q ""
}

/// 获取用户密码
ClassMethod GetUserPwd(userName As %String) As %String
{
	n (userName)
	s json=##class(%ArrayOfDataTypes).%New()
	s ssusr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userName),""))
	s userId=ssusr
	i ssusr="" d
	.s userId="-100"
	.s errorInfo=$s(userId="-100":"用户不存在",userId="-101":"密码不正确",userId="-102":"用户没有激活",1:"")
	e  d 
	.s sscode=$p(^SSU("SSUSR",userId),"^",1)
	.s ssname=$p(^SSU("SSUSR",userId),"^",2)
	.s sspwd=$p(^SSU("SSUSR",userId),"^",3)
	.s chkloc=..CheckUserLoc(userId)
	.s locJson=..getUserLoc(userId)
	d json.SetAt($g(errorInfo),"ErrorInfo")
	d json.SetAt($g(locJson),"Locs")
	d json.SetAt($g(userId),"UserID")
	d json.SetAt($g(sscode),"UserCode")
	d json.SetAt($g(ssname),"UserName")
	d json.SetAt($g(sspwd),"UserPwd")
	i ($g(errorInfo)="")&&(locJson.Count()=0) d
	.s errorInfo="用户没有可登陆的科室"
	.d json.SetAt($g(errorInfo),"ErrorInfo")
	e  d
	.i $g(chkloc)=0 d
	..s errorInfo="用户无配液中心登录权限"
	..d json.SetAt($g(errorInfo),"ErrorInfo")
    q ##class(Nur.JSON).Encode(json)
}

ClassMethod CheckUserLoc(userId As %String) As %ListOfDataTypes
{
		
	    s chkflag=0
		s ssuser=userId
		s ctlocdr=$p(^SSU("SSUSR",ssuser),"^",4)
		i ctlocdr="1259" s chkflag=1
		
		s chl=""
		f  s chl=$o(^SSU("SSUSR",ssuser,"OTHLL",chl)) q:chl=""  d
		.s ctlocdr=$p(^SSU("SSUSR",ssuser,"OTHLL",chl),"^",1)
		.q:ctlocdr=""
		.i ctlocdr="1259" s chkflag=1
		
	
		
		q chkflag
}

}
