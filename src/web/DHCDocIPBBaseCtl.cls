Import SQLUser

/// Creator  吴群科
/// Description 公共函数库
Class web.DHCDocIPBBaseCtl Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 201;

/// 获取所有科室
/// Return RowID^Code^Description
ClassMethod GetAllDep()
{
	n 
	k PLIST 
    s i=0
    s ctloc=0 f  s ctloc=$o(^CTLOC(ctloc)) q:ctloc=""  d
    .q:$p($g(^CTLOC(ctloc)),"^",13)'="E"
    .s Desc=$p($g(^CTLOC(ctloc)),"^",2)
    .s i=i+1
    .s PLIST(i)=+ctloc_$c(2)_Desc
	s iCount=i
	s s=""
	f i=1:1:iCount d
	.s s=s_$g(PLIST(i))_$c(1)
	q s
}

/// 通过科室ID取得病区
/// DepRowid：科室ID
/// Update by lxf 2008-11-03 for ChengDu_HX
ClassMethod GetCtLocByDep(DepRowid)
{
	;w ##class(web.DHCDocIPBBaseCtl).GetCtLocByDep(6)
	s ^RP("GetCtLocByDep")=DepRowid
	n (DepRowid)
	s str="",desc=""
    i DepRowid="" q
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s childid=""
	f  s childid=$o(^CTLOC(DepRowid,"LINK",childid))  q:childid=""  d
	.q:childid=0
	.s linkid=$p(^CTLOC(DepRowid,"LINK",childid),"^",1)
	.q:($d(^CTLOC(linkid))=0)
	.s loctype=$p(^CTLOC(linkid),"^",13)
	.q:(loctype'="W")
	.s ctdesc=$p(^CTLOC(linkid),"^",2)
	.s rowid=""
	.s rowid=$o(^PAWARD(0,"WARD_LocationDR",linkid,rowid))
	.s ctdesc1=$$ALPHAUP^SSUTIL4(ctdesc)
	.i desc'=""  d
	..i ctdesc1[desc  d
	...i $f(ctdesc,"-")'=0  d
    ....s ctdesc=$p(ctdesc,"-",2)
    ...s str=str_rowid_$c(2)_ctdesc_$c(1)
 	.e  d
 	..i $f(ctdesc,"-")'=0  d
    ...s ctdesc=$p(ctdesc,"-",2)
    ..s str=str_rowid_$c(2)_ctdesc_$c(1)
 	q str
}

/// 2009-2-2  By LiYang
ClassMethod ReplaceString(Str, OldStr, NewStr)
{
	n (Str, OldStr, NewStr)
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

/// update by zf 2008-06-05
/// Trakcare用户可以有多个安全组,不使用默认安全组登陆
/// 取登陆人员信息
/// 参数：
/// UserId=xUserId
/// 或
/// UserId=xUserId^xGroupId^xCtlocId
/// 
/// xUserId    登陆人员Rowid
/// xGroupId   登陆安全组Rowid
/// xCtlocId   登陆科室Rowid
ClassMethod GetLogUserInfo(UserId) As %String
{
	n (UserId)
	s ret=""
	s xUserId=+$p(UserId,"^",1)
	s xGroupId=+$p(UserId,"^",2)
	s xCtlocId=+$p(UserId,"^",3)
	q:'$d(^SSU("SSUSR",+xUserId)) ret
	s s=$g(^SSU("SSUSR",+xUserId))
	s Code=$p(s,"^",1)
	s Desc=$p(s,"^",2)
	s ctloc=+$p(s,"^",4)
	s:xCtlocId'=0 ctloc=xCtlocId
	s ctlocCode=$p($g(^CTLOC(+ctloc)),"^",1)
	s ctlocDesc=$p($g(^CTLOC(+ctloc)),"^",2)
	s ctloc=ctloc_"/"_ctlocCode_"/"_ctlocDesc
	s sGroup=+$p(s,"^",5)
	s:xGroupId'=0 sGroup=xGroupId
	s grpCode=$p($g(^SSU("SSGRP",sGroup)),"^",1)
	s grpDesc=$p($g(^SSU("SSGRP",sGroup)),"^",2)
	s sGroup=sGroup_"/"_grpCode_"/"_grpDesc
	s dep=+$p($g(^CTLOC(+ctloc)),"^",19)
	s depCode=$p($g(^RBC("DEP",dep)),"^",1)
	s depDesc=$p($g(^RBC("DEP",dep)),"^",2)
	s dep=dep_"/"_depCode_"/"_depDesc
	s dep=ctloc
	s ret=xUserId_"^"_Code_"^"_Desc_"^"_ctloc_"^"_dep_"^"_sGroup
    s ret=..ReplaceString(ret,$c(13),"") //add by LiYang 2009-2-2 替换字符串中的回车符
    s ret=..ReplaceString(ret,$c(10),"") //add by LiYang 2009-2-2 替换字符串中的回车符	
	q ret
}

/// 通过病人ID获取基本信息
/// Papmi：病人的RowID
ClassMethod GetPatInfo(papmi, EpisodeID = "")
{
	n (papmi,EpisodeID,%session)
	q:papmi="" ""
	q:'$d(^PAPER(papmi)) ""
	s papmino=$p(^PAPER(papmi,"PAT",1),"^",1)
	s s=..GetPatInfo2(papmino,EpisodeID)
	q s
}

/// add by wuqk for RegNo length
ClassMethod RegNoCon(PAPMINo As %String) As %String
{
	q:PAPMINo="" PAPMINo
	s len=8
	s PATCFid=$o(^CF("PATCF",""))
	i PATCFid'="" s len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	if $l(PAPMINo)<len d
	.s prelen=len-$l(PAPMINo)
	.for i=1:1:prelen s PAPMINo="0"_PAPMINo
	Q PAPMINo
}

/// 通过登记号获取病人信息
/// regno：登记号
ClassMethod GetPatInfo2(regno As %String, EpisodeID As %String = "")
{
	s ^RP("GetPatInfo2")=$lb(regno,EpisodeID)
	;w ##class(web.DHCDocIPBBaseCtl).GetPatInfo2(0000000003)
	;GetPatInfo2(regno,arglocID,argdepartID)
	;n (regno,arglocID,argdepartID)
	n (regno,EpisodeID,%session)
	s logonHospID=%session.Get("LOGON.HOSPID")
	Set langid=..%LanguageID()
	s regno=..RegNoCon(regno)
	q:'$d(^PAPERi("PAPMI_PatNo",regno)) "" //^PAPERi("PAPMI_PatNo","0000000480",481)
	;k P5,P6                 ;GetPatInfo(regno,paadmID)
	s regno=$$ALPHAUP^SSUTIL4(regno)
	s ProvinceDesc="",CityBirthDesc="",DeptDesc="",SocialDESC="",PatCategoryDesc=""
	s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",regno,-1)) 
	s PAPMIRowId=+PAPMIRowId
	s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","I",-1))
	i paadmID="" s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","O",-1))
	i paadmID="" s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","E",-1))
	i paadmID="" s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","H",-1))
	q:paadmID="" ""
	s name=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7))),"^",2)
	s sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",sex,langid)
	s today=..%SysDate()
	s birth=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",6)
	i birth'="" s birthdate=$zd(birth,3)
	;s age=..CalAge(birth,today)
	s age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PAPMIRowId,EpisodeID,logonHospID)
	s SocialStatusDR=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",10)
	s SocialStatusDR=+SocialStatusDR
	i SocialStatusDR=0  {
		s SocialDESC="3自费医疗"
	}else{
		s SocialDESC=$p($g(^CT("SS",SocialStatusDR)),"^",2)
		;i (SocialDESC'["医疗保险")&(SocialDESC'["公费医疗") s SocialDESC="3自费医疗"
	}	
	s ProvinceDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",11)
	s ProvinceDR=+ProvinceDR        
	i ProvinceDR'=0 s ProvinceDesc=$p(^CT("PROV",ProvinceDR),"^",2)
	i ProvinceDesc["-" s ProvinceDesc=$p(ProvinceDesc,"-",2)
	s GovernCardNo= $p($g(^PAPER(PAPMIRowId,"PER",4)),"^",4) 
	
	;家庭住址,工作单位
	s SecondAddress=$g(^PAPER(PAPMIRowId,"PER","ADD",1))
	s workAdress=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",18)
	
	s CityBirthDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",18)
	s CityBirthDR=+CityBirthDR
	i CityBirthDR'=0 s CityBirthDesc=$p(^CT("CIT",CityBirthDR),"^",2)
	i $g(CityBirthDesc)["-" s CityBirthDesc=$p(CityBirthDesc,"-",2)
	s DepCodeDR=$p(^PAADM(paadmID),"^",4)
	q:DepCodeDR=""
	s DeptDesc=$p($g(^CTLOC(DepCodeDR)),"^",2)
	s DeptDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",DeptDesc,langid)
	s DepCodeDR=+DepCodeDR
	i $g(DeptDesc)["-" s DeptDesc=$p(DeptDesc,"-",2)
	;s P6=0
	;i (arglocID'="")&(arglocID'=DepCodeDR) s P6=1
	;q:(P6=1) $g(DeptDesc)
	s curdepdr=$P($g(^CTLOC(DepCodeDR)),"^",19)  
	s curdepdrdesc=$p($g(^RBC("DEP",+curdepdr)),"^",2)
	;i (argdepartID'="")&(argdepartID'=curdepdr) s P6=2
	;q:(P6=2) $g(curdepdrdesc)
	s admDate=$p(^PAADM(paadmID),"^",6)
	i admDate'="" s admDate=$zd(admDate,3)
	s papmiId=$p($g(^PAPER(PAPMIRowId,"PAT",3)),"^",6)
	s papmiId=$tr(papmiId," ","")
	s papersonGX=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",4)
	s papersonGXAdress=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",5)
	s papersonGXman=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",1)
	s papersonGXTel=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",8)
	s Marital=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",3)
	i Marital'="" s MaritalDesc=$p(^CT("MAR",+Marital),"^",2) 
	s nationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",1)
	i nationdr'="" s nationDesc=$p(^CT("NAT",+nationdr),"^",2) 
	i $g(nationDesc)'="" {
		i nationDesc["-" s nationDesc=$p(nationDesc,"-",2)
	}
	s telphone=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",11)
	s educationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",5)
	i educationdr'="" s educationDesc=$p(^CT("EDU",+Marital),"^",2) 
	;i $d(^PAPER(PAPMIRowId,"PER","ADD",1))'=0 d 
	;.s workAdress= $g(^PAPER(PAPMIRowId,"PER","ADD",1))   ;同MEM
	;PAC_PatientCategory
	s PatCategoryDR=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",8) 
	s PatCategoryDR=+PatCategoryDR
	i PatCategoryDR'=0 s PatCategoryDesc=$p(^PAC("PCAT",PatCategoryDR),"^",2 )
	s countrydr=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",8)
	i countrydr'="" s countryDesc=$p(^CT("COU",+countrydr),"^",2) 
	i $g(ProvinceDesc)=$g(CityBirthDesc) s CityBirthDesc=""
	//s gvCardNo=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",4) 
	//住院病历号
	s gvCardNo=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",22)        ;中医院病案号
	
	
	s RelationName = $p($g(^PAPER(PAPMIRowId,"PER",2)),"^",13)   ;联系人
	;s RelationPhone = $p($g(^PAPER(PAPMIRowId,"PER",2)),"^",8)   ;联系人电话
	s RelationPhone=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",4)  ;联系人电话
	s EmployeeFunction="",SecretLevel=""
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PAPMIRowId,.ErrMsg)
	i PatEncryptLevel'="" {
		s EmployeeFunction=$p(PatEncryptLevel,"^",2)
		s SecretLevel=$p(PatEncryptLevel,"^",1)
	}
	set TPAPMICardTypeDR=$p($g(^PAPER(PAPMIRowId,"PAT",3)),"^",7)
	set TPAPMICardType=$s(+$p($g(^PAPER(PAPMIRowId,"PAT",3)),"^",7)'=0:$p($g(^PAC("CARD",$p($g(^PAPER(PAPMIRowId,"PAT",3)),"^",7))),"^",2),1:"")
	Set TPAPMICardType= ##class(User.DHCCredType).GetTranByDesc("CRTDesc",TPAPMICardType,langid)	
	s s=$g(name)_$c(2)_$g(sex)_$c(2)_$g(birthdate)_$c(2)_$g(age)
	s s=s_$c(2)_$g(papmiId)_$c(2)_$g(ProvinceDesc)_$g(CityBirthDesc)
	s s=s_$c(2)_$g(MaritalDesc)_$c(2)_$g(nationDesc)_$c(2)_$g(telphone)
	s s=s_$c(2)_$g(educationDesc)_$c(2)_$g(workAdress)_$c(2)_$g(papersonGX)
	s s=s_$c(2)_$g(papersonGXAdress)_$c(2)_$g(papersonGXman)_$c(2)_$g(papersonGXTel)
	s s=s_$c(2)_$g(PatCategoryDesc)_$c(2)_$g(DeptDesc)_$c(2)_$g(SecondAddress)
	s s=s_$c(2)_$g(countryDesc)_$c(2)_$g(gvCardNo)_$c(2)_$g(SocialDESC)
	s s=s_$c(2)_PAPMIRowId_$c(2)_regno_$c(2)_RelationName_$c(2)_RelationPhone
	s s=s_$c(2)_EmployeeFunction_$c(2)_SecretLevel_$c(2)_TPAPMICardType
	s s=$tr(s,$c(0),"")              //add by zf 2008-05-06
	s s=..ReplaceString(s,$c(13),"") //add by LiYang 2009-2-2
	s s=..ReplaceString(s,$c(10),"") //add by LiYang 2009-2-2    
	q s
}

/// 通过用户的ID获取用户信息
/// usrid：用户ID
ClassMethod GetUsrStr(usrId)
{
     n (usrId,%session)
     q:usrId="" ""
     q:'$d(^SSU("SSUSR",+usrId)) ""
     Set langid=..%LanguageID()
     s Desc=$p($g(^SSU("SSUSR",+usrId)),"^",2)
     s Desc =##class(User.SSUser).GetTranByDesc("SSUSRName",Desc,langid)
     s s=usrId_"/"_$p($g(^SSU("SSUSR",+usrId)),"^",1)_"/"_Desc
     q s
}

/// 计算年龄
/// IBirth：出生日期
/// IToday：今天的日期
ClassMethod CalAge(IBirth, IToday)
{
     n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
     s IBirth=$g(IBirth),IToday=$g(IToday)
     i IBirth>2980000 s IBirth=""
     i IBirth<0 s IBirth=""
     q:'$G(IBirth) ""
     s XBirth=$ZD(IBirth)
     s XToday=$ZD(IToday)
     s AgeMth=XToday-XBirth
     s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
     s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
     s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
     s AgeYear=CurrYear-BirthYear
     i AgeDay<0 d
     . s AgeMth=AgeMth-1
     . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
     . q:XToday'=2
     . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
     i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
     s $P(AgeYr,"|",12)=AgeYear
     s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
     i $p(AgeYr,"|",12)>0  d
     .s reage=$p(AgeYr,"|",12)_"岁"
     e  d
     .i AgeMth>0 d
     ..s reage=AgeMth_"月"
     .e  d
     ..s reage=AgeDay_"天"
     q reage
}

}
