Import SQLUser

/// Creator  吴群科
/// Description 公共函数库
Class web.DHCWMRMedBaseCtl Extends (%Library.RegisteredObject, websys.Abstract) [ Not ProcedureBlock ]
{

Parameter BUILD = 186;

/// 获取所有科室
/// Return RowID^Code^Description
ClassMethod GetAllDep()
{
	n 
	d ##Class(DHCWMRMedBase01).GetDepByHosp()   ;by wuqk 2007-10-11
	s iCount=P1
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
	n (DepRowid)
	//add by lxf below for ChengDu_HX 2008-11-03
	set Hospital = ##class(web.DHCWMRMedBase01).GetDefaultHosp() ;
	set Code = $p(Hospital, "/", 4) ;
	s str=""
	s desc=""
	;w !,"Hospital="_Hospital_";Code="_Code
	i Code="ChengDu_HX" d
    .i DepRowid="" q
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s childid=""
	.f  s childid=$o(^CTLOC(DepRowid,"LINK",childid))  q:childid=""  d
	..q:childid=0
	..s linkid=$p(^CTLOC(DepRowid,"LINK",childid),"^",1)
	..q:($d(^CTLOC(linkid))=0)
	..s loctype=$p(^CTLOC(linkid),"^",13)
	..q:(loctype'="W")
	..s ctdesc=$p(^CTLOC(linkid),"^",2)
	..;w !,"ctdesc="_ctdesc
	..s rowid=""
	..s rowid=$o(^PAWARD(0,"WARD_LocationDR",linkid,rowid))
	..s ctdesc1=$$ALPHAUP^SSUTIL4(ctdesc)
	..i desc'=""  d
	...i ctdesc1[desc  d
	....i $f(ctdesc,"-")'=0  d
    .....s ctdesc=$p(ctdesc,"-",2)
    ....s str=str_rowid_$c(2)_ctdesc_$c(1)
 	..e  d
 	...i $f(ctdesc,"-")'=0  d
    ....s ctdesc=$p(ctdesc,"-",2)
    ...s str=str_rowid_$c(2)_ctdesc_$c(1)
 	q:Code="ChengDu_HX" str
 	//add by lxf above for ChengDu_HX 2008-11-03
	
	;s iCount=$$GetgroupLocDesc2^DHCWMRMedBase02(DepRowid)
	s iCount=##Class(DHCWMRMedBase01).getLocList(DepRowid)    ;by wuqk 2007-10-11
	s s1=""
	f i=1:1:iCount d
	.s s1=s1_$g(PLIST(i))_$c(1)
	q s1
}

///   根据部门组/科室取科室列表
ClassMethod GetLocByDep(DepRowid)
{
	n (DepRowid) 	
	s iCount=##Class(DHCWMRMedBase01).getLocList(DepRowid)    ;by wuqk 2007-10-11
	s s1=""
	f i=1:1:iCount d
	.s s1=s1_$g(PLIST(i))_$c(1)
	q s1
}

/// 更新病人的身份证号码
/// papmi：病人的ID
/// Identity：身份证号码
ClassMethod UpdateIdentity(papmi, Identity)
{
	n (papmi, Identity)
	q:(papmi="")!(Identity="") "-1"
	
	s ret=##Class(DHCWMRMedBase).UpdatePapmiID(papmi,Identity)
	
    q ret
}

/// 检验用户是否具有某种权限（Medtrak的权限设置）
/// UserGroupId：用户组ID
/// ModuleName：模块名称
///  MenuName：菜单名称
///  返回0代表有权限
///  Modified By LiYang 2009-02-11 增加返回值类型描述
/// debug:w ##Class(web.DHCWMRMedBaseCtl).UserFunction("12","病案收回","")
ClassMethod UserFunction(UserGroupId, ModuleName, MenuName) As %String
{
	/*
	n (UserGroupId,ModuleName,MenuName)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$UserFunction^SMLUserFunc(UserGroupId,ModuleName,MenuName)
	zn CurrentNS
	q ret
	*/
	q ..IsHasPower(UserGroupId,ModuleName,MenuName)
}

/// Creator:wangcs
/// CreateDate:2012-03-12
/// Description:检查用户是否具有病案流通的权限(DHCMedBase2.0设置)
/// Debug:w ##Class(web.DHCWMRMedBaseCtl).IsHasPower("12","","")
ClassMethod IsHasPower(UserGroupId, ModuleName, MenuName) As %String
{
	new (UserGroupId,ModuleName,MenuName)
	;^DHCMed.SS.SecurityOperaI("IndexOfGOpera",197,15,63)=""
	set ret=-1
	set ^Test=UserGroupId_","_ModuleName_","_MenuName
	if ($d(^DHCMed.SS.SecurityOperaI("IndexOfGOpera",UserGroupId))){
		set menuOperaDr=""
		for {
			set menuOperaDr=$o(^DHCMed.SS.SecurityOperaI("IndexOfGOpera",UserGroupId,menuOperaDr))
			quit:menuOperaDr=""
			set securityOperId=$o(^DHCMed.SS.SecurityOperaI("IndexOfGOpera",UserGroupId,menuOperaDr,""),-1)
			set securityOperObj=##Class(DHCMed.SS.SecurityOpera).GetObjById(securityOperId)
			if $IsObject(securityOperObj){
				set authority=securityOperObj.Authority
				Continue:authority=0
			}
			
			/*Modified by wuqk 2013-05-15  --begin ---
			* for : 重复定义菜单和操作，无效数据引起异常，增加对菜单有效性的判断
			*/
			set menuOperObj=##Class(DHCMed.SS.MenuOperation).GetObjById(menuOperaDr)
			Continue:'$IsObject(menuOperObj)
			if $IsObject(menuOperObj){
				set menuOperaName=menuOperObj.OperaName
			}
			set menuObj=##class(DHCMed.SS.Menus).GetObjById(menuOperObj.MenuDr)
			Continue:'$IsObject(menuObj)
			/*Modified by wuqk 2013-05-15  --end */
			
			if (menuOperaName=MenuName){
			    set ret=0
			    quit
			}
		}	
	}
	quit ret
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
	s:$p(##Class(web.DHCWMRMedBase01).GetDefaultHosp(),"/",2)=1 dep=ctloc
	s ret=xUserId_"^"_Code_"^"_Desc_"^"_ctloc_"^"_dep_"^"_sGroup
    s ret=..ReplaceString(ret,$c(13),"") //add by LiYang 2009-2-2 替换字符串中的回车符
    s ret=..ReplaceString(ret,$c(10),"") //add by LiYang 2009-2-2 替换字符串中的回车符	
	q ret
}

/// 通过病人ID获取基本信息
/// Papmi：病人的RowID
ClassMethod GetPatInfo(papmi)
{
	n (papmi)
	q:papmi="" ""
	q:'$d(^PAPER(papmi)) ""
	s papmino=$p(^PAPER(papmi,"PAT",1),"^",1)
	s s=..GetPatInfo2(papmino)
	q s
	/*
	q:papmi="" ""
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s sPat=$$GetPatInfo^DHCWMRMedBase(papmi)
	zn CurrentNS
    q sPat
    */
}

/// 通过登记号获取病人信息
/// regno：登记号
ClassMethod GetPatInfo2(regno As %String)
{
	     ;GetPatInfo2(regno,arglocID,argdepartID)
         ;n (regno,arglocID,argdepartID)
         n (regno)
         s regno=##Class(web.DHCWMRMedBaseCtl).RegNoCon(regno)    //add by zf 2008-10-08  十位登记号
         q:'$d(^PAPERi("PAPMI_PatNo",regno)) ""
         ;k P5,P6                 ;GetPatInfo(regno,paadmID)
         s regno=$$ALPHAUP^SSUTIL4(regno)
         s ProvinceDesc="",CityBirthDesc="",DeptDesc="",SocialDESC="",PatCategoryDesc=""
         s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",regno,-1)) 
         s PAPMIRowId=+PAPMIRowId
         s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","I",-1))
         i paadmID="" s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","O",-1))
         i paadmID="" s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","E",-1))
         i paadmID="" s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","H",-1))       //add by wuqk 2009-12-28 增加对体检就诊的支持
         q:paadmID="" ""
         s name=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1)
         s sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7))),"^",2)
         s today=$p($h,",",1)
         s birth=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",6)
         i birth'="" s birthdate=$zd(birth,3)
         s age=..CalAge(birth,today)
         s SocialStatusDR=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",10)
         s SocialStatusDR=+SocialStatusDR
         i SocialStatusDR=0  d
         .s SocialDESC="3自费医疗"
         e  d
         .s SocialDESC=$p($g(^CT("SS",SocialStatusDR)),"^",2)
         .i (SocialDESC'["医疗保险")&(SocialDESC'["公费医疗") d
         ..s SocialDESC="3自费医疗"
         s ProvinceDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",11)
         s ProvinceDR=+ProvinceDR        
         i ProvinceDR'=0 s ProvinceDesc=$p(^CT("PROV",ProvinceDR),"^",2)
         i ProvinceDesc["-" s ProvinceDesc=$p(ProvinceDesc,"-",2)
         s GovernCardNo= $p($g(^PAPER(PAPMIRowId,"PER",4)),"^",4) 
        
		;家庭住址,工作单位
		;友谊医院
		;s SecondAddress=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",18)
		;s workAdress=$g(^PAPER(PAPMIRowId,"PER","ADD",1))
		;地坛医院P8
		;s SecondAddress=$g(^PAPER(PAPMIRowId,"PER","ADD",1))
	    ;s workAdress=$p($g(^PAPER(PAPMIRowId,"PER",3)),"^",2)
	    s SecondAddress=..xGetHomeAddress(PAPMIRowId)
	    s workAdress=..xGetCompany(PAPMIRowId)
          
         s CityBirthDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",18)
         s CityBirthDR=+CityBirthDR
         i CityBirthDR'=0 s CityBirthDesc=$p(^CT("CIT",CityBirthDR),"^",2)
         i $g(CityBirthDesc)["-" s CityBirthDesc=$p(CityBirthDesc,"-",2)
        s DepCodeDR=$p(^PAADM(paadmID),"^",4)
        q:DepCodeDR=""
         s DeptDesc=$p($g(^CTLOC(DepCodeDR)),"^",2)
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
        s papmiId=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",9)
        s papmiId=$tr(papmiId," ","")
        ;s papersonGX=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",4)
        s papersonGX=..xGetGX(PAPMIRowId)			 		;Modified By liuxuefeng 2009-06-01
        ;s papersonGXAdress=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",5)
        s papersonGXAdress=..xGetGXAddress(PAPMIRowId) 		;Modified By liuxuefeng 2009-06-01
        ;s papersonGXman=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",1)
        s papersonGXman=..xGetGXMan(PAPMIRowId) //Modified By LiYang 2008-11-11 成都华西医院的联系人保存位置与众不同，所以修改之  $p($g(^PAPER(PAPMIRowId,"PER",1)),"^",1)
        ;s papersonGXTel=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",8)
        s papersonGXTel=..xGetGXTel(PAPMIRowId) 			;Modified By liuxuefeng 2009-06-01
        s Marital=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",3)
        i Marital'="" s MaritalDesc=$p(^CT("MAR",+Marital),"^",2) 
        s nationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",1)
        i nationdr'="" s nationDesc=$p(^CT("NAT",+nationdr),"^",2) 
        i $g(nationDesc)'="" d
        .i nationDesc["-" s nationDesc=$p(nationDesc,"-",2)
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
        //update by zf 2008-10-23
        //住院病历号
        //s gvCardNo=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",22) //中医院病案号
        s gvCardNo=..xGetGVCardNo(PAPMIRowId)
        s s=$g(name)_$c(2)_$g(sex)_$c(2)_$g(birthdate)_$c(2)_$g(age)_$c(2)_$g(papmiId)_$c(2)_$g(ProvinceDesc)_$g(CityBirthDesc)_$c(2)_$g(MaritalDesc)_$c(2)_$g(nationDesc)_$c(2)_$g(telphone)_$c(2)_$g(educationDesc)_$c(2)_$g(workAdress)_$c(2)_$g(papersonGX)_$c(2)_$g(papersonGXAdress)_$c(2)_$g(papersonGXman)_$c(2)_$g(papersonGXTel)_$c(2)_$g(PatCategoryDesc)_$c(2)_$g(DeptDesc)_$c(2)_$g(SecondAddress)_$c(2)_$g(countryDesc)_$c(2)_$g(gvCardNo)_$c(2)_$g(SocialDESC)_$c(2)_PAPMIRowId_$c(2)_regno
        s s=$tr(s,$c(0),"")  //add by zf 2008-05-06
        s s=..ReplaceString(s,$c(13),"") //add by LiYang 2009-2-2
        s s=..ReplaceString(s,$c(10),"") //add by LiYang 2009-2-2        
        q s
}

ClassMethod KillStyle()
{
	s sub=""
	
	f  s sub=$O(^websys.ComponentTableItemsD(50541,sub)) q:sub=""  d
	.s s=$g(^websys.ComponentTableItemsD(50541,+sub))
    .s $li(s,3)=""
    .s $li(s,25)=""
    .s ^websys.ComponentTableItemsD(50541,+sub)=s
    q
}

/// 获取Http服务器信息
/// Trakcare的服务器，不是Medtrak的
ClassMethod GetServerInfo()
{
	n
    Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    //Set Server=Config.WebServer
    Set Server=$p(Config.LayoutManager,":",2)
    Set Path=Config.PathToReports
    Set LayOutManager=Config.LayoutManager
    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
   // Set WebServerAppURL = "http://127.0.0.1"_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
    d Config.%Close()
    s s=CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
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

/// 通过病区的ID获取病区信息
/// Ctloc：病区的RowID
ClassMethod GetCtlocStr(ctloc)
{
	
     n (ctloc)
     q:(ctloc="") ""
     q:(+ctloc=0) ""
     q:'$d(^CTLOC(+ctloc)) ""
     s LocDesc=$p($g(^CTLOC(+ctloc)),"^",2)
     s LocDesc=$s(LocDesc["-":$p(LocDesc,"-",2),1:LocDesc)
     s s=ctloc_"/"_LocDesc
     q s
}

ClassMethod GetSSUSERByCode(SSUSRInitials)
{
   ;n (SSUSRInitials)
   q:SSUSRInitials="" ""
   ;^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP({SSUSR_Initials}),{SSUSR_RowId})
   ;s SSUSRInitials=$ZCVT(SSUSRInitials,"U")
   s SSUSRInitials=$$ALPHAUP^SSUTIL4(SSUSRInitials)
   q:'$d(^SSU("SSUSR",0,"SSUSR_Initials",SSUSRInitials)) ""
   s ssusr=$o(^SSU("SSUSR",0,"SSUSR_Initials",SSUSRInitials,""),-1)
   q ssusr
}

ClassMethod GetUserByCTCP(CTCPDR)
{
	       ;CT_CareProv
    q:'$d(^CTPCP(CTCPDR)) ""
 s Code=$p($g(^CTPCP((CTCPDR),1)),"^",1)
 s Desc=$p($g(^CTPCP((CTCPDR),1)),"^",2)
 s ssusr=..GetSSUSERByCode(Code)
 s s=ssusr_"/"_Code_"/"_Desc
 q s
}

/// 通过用户的ID获取用户信息
/// usrid：用户ID
ClassMethod GetUsrStr(usrId)
{
     n (usrId)
     q:usrId="" ""
     q:'$d(^SSU("SSUSR",+usrId)) ""
     s s=usrId_"/"_$p($g(^SSU("SSUSR",+usrId)),"^",1)_"/"_$p($g(^SSU("SSUSR",+usrId)),"^",2)
     q s
}

/// 验证用户的用户名/密码
/// userCode：用户工号
/// Pass：密码
/// 如果用户验证成功，返回用户信息，否则返回空
/// //Modified By LiYAng 2009-2-10 让CacheObject能够获取返回值
ClassMethod VerifyUser(userCode, Pass) As %String
{
	New (userCode, Pass)	
	Set Ret=-1
	Set UserID=##Class(web.SSUser).IsValidUser(userCode,Pass)
	If (UserID>0){
		Set ObjUser=##Class(User.SSUser).%OpenId(UserID)
		If ($IsObject(ObjUser)){
			Set UserName=ObjUser.SSUSRName	
			Set Ret=UserID_"/"_userCode_"/"_UserName
		}	
		Do ObjUser.%Close()
	}
	Quit Ret
}

ClassMethod test()
{
	;Set Config=##Class(User.DHCINVPRT).%OpenId(1)
	;s x=Config.flag.DISPLAYLIST
	w $zn
    q
}

// 2009-2-2  By LiYang

ClassMethod GetPercent(Number)
{
	n (Number)
	s Number=+Number
	s ret=$j(Number*100,1,2)
	s ret=ret_"%"
    q ret
}

/// 更新住院病案号
/// MrNo：住院病案号
/// papmi：病人ID
ClassMethod UpdateIPMrNo(MrNo, papmi)
{
	n (MrNo,papmi)
    s ret=##Class(DHCWMRMedBase01).UpdateIPMrNo(MrNo,papmi)
	;w  
	q ret
}

ClassMethod UpdateMrNoA(MrNo, papmi)
{
	n (MrNo,papmi)
    s ret=##Class(DHCWMRMedBase01).UpdateMrNoA(MrNo,papmi)
	q ret
}

ClassMethod UpdateMrNoB(MrNo, papmi)
{
	n (MrNo,papmi)
    s ret=##Class(DHCWMRMedBase01).UpdateMrNoB(MrNo,papmi)
	q ret
}

/// w ##Class(web.DHCWMRMedBaseCtl).UpdateMrNoC(1000,11351)
/// User.DHCPerson.PAPERSGMedicareCode1
ClassMethod UpdateMrNoC(MrNo, papmi)
{
	n (MrNo,papmi)
	/*
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateMrNoC^DHCWMRMedBase01(MrNo,papmi)
	zn CurrentNS
	;w
	q ret
	*/
	
	/* 没有表结构 DHC_Person*/
	;update by zf 2008-05-22  DHC_Person表中没有Papmi对应的记录情况，插入一条数据
	;^DHCPERSON(0,"PAPERSON",{PAPER_PaPerson_dr},{PAPER_RowID})
	i $d(^DHCPERSON(0,"PAPERSON",papmi)) d
 	.&sql(update SQLUSER.DHC_Person set PAPER_FCMedicareCode1=:MrNo where PAPER_PaPerson_dr=:papmi)
 	e  d
 	.&sql(insert into SQLUSER.DHC_Person(PAPER_PaPerson_dr,PAPER_FCMedicareCode1) values(:papmi,:MrNo))
 	q SQLCODE
 	
 	q 1
}

/// w ##Class(web.DHCWMRMedBaseCtl).UpdateMrNoD(1000,11351)
/// User.DHCPerson.PAPERSGMedicareCode2
ClassMethod UpdateMrNoD(MrNo, papmi)
{
	n (MrNo,papmi)
	/*
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateMrNoD^DHCWMRMedBase01(MrNo,papmi)
	zn CurrentNS
	;w  
	q ret
	*/
	
	/* 没有表结构 DHC_Person*/
	;update by zf 2008-05-22  DHC_Person表中没有Papmi对应的记录情况，插入一条数据
	i $d(^DHCPERSON(0,"PAPERSON",papmi)) d
 	.&sql(update SQLUSER.DHC_Person set PAPER_FCMedicareCode2=:MrNo where PAPER_PaPerson_dr=:papmi)
 	e  d
 	.&sql(insert into SQLUSER.DHC_Person(PAPER_PaPerson_dr,PAPER_FCMedicareCode2) values(:papmi,:MrNo))
 	q SQLCODE
 	
 	q 1
}

/// paperson.paper_governcardno
ClassMethod GetMrNoA(papmi)
{
	n (papmi)
	s MrNo=""
 	s MrNo=$p($g(^PAPER(papmi,"PER",4)),"^",4) 
 	q MrNo
}

/// PA_PatMas.PAPMI_Medicare
ClassMethod GetMrNoB(papmi)
{
	n (papmi)
	s MrNo=""
 	s MrNo=$p($g(^PAPER(papmi,"PAT",1)),"^",22) 
 	q MrNo
}

/// User.DHCPerson.PAPERSGMedicareCode1
ClassMethod GetMrNoC(papmi)
{
	n (papmi)
	s MrNo=""
	q:'$d(^DHCPERSON(0,"PAPERSON",papmi)) MrNo
	s dhcperson=$O(^DHCPERSON(0,"PAPERSON",papmi,""))
 	s MrNo=$p($g(^DHCPERSON(dhcperson)),"^",5) 
 	q MrNo
}

/// User.DHCPerson.PAPERSGMedicareCode2
ClassMethod GetMrNoD(papmi)
{
	n (papmi)
	s MrNo=""
	q:'$d(^DHCPERSON(0,"PAPERSON",papmi)) MrNo
	s dhcperson=$O(^DHCPERSON(0,"PAPERSON",papmi,""))
 	s MrNo=$p($g(^DHCPERSON(dhcperson)),"^",6) 
 	q MrNo
}

/// 根据病案类型和Pa_PatMas.PAPMI_RowId和病案类型取HIS中的病案号
ClassMethod GetHISMrNo(PatientId As %String, MrType As %String)
{
	n (PatientId , MrType)
	s MrNo=""
	
	;取病案类型设置
	s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	q:strMrType="" MrNo
	s MrNoField=$p($p(strMrType,"^",5),"/",2)
	q:MrNoField="" MrNo
	
	;PA_Person.paper_governcardno
	s:MrNoField="A" MrNo=..GetMrNoA(PatientId)
	;PA_PatMas.PAPMI_Medicare
	s:MrNoField="B" MrNo=..GetMrNoB(PatientId)
	;User.DHCPerson.PAPERFCMedicareCode1
	s:MrNoField="C" MrNo=..GetMrNoC(PatientId)
	;User.DHCPerson.PAPERFCMedicareCode2
	s:MrNoField="D" MrNo=..GetMrNoD(PatientId)
	
	q MrNo
}

ClassMethod GetChinese(Ind)
{
	s ret=""
	s:Ind="DHCMedEpdFeedBackQry" ret="全院^全科"
	s:Ind="DHCMedEpdReportQry" ret="全院^全科"
	q ret
}

/// 通过卡号,登记号查询病人基本信息
/// w ##class(web.DHCWMRMedBaseCtl).GetPatInfoByNo(CardNo,RegNo)
ClassMethod GetPatInfoByNo(CardNo, RegNo)
{
	n (CardNo,RegNo)
	
	s ret=""
	q:(CardNo="")&&(RegNo="") ret
	s RegNo=##Class(web.DHCWMRMedBaseCtl).RegNoCon(RegNo)    //add by zf 2008-10-08  十位登记号
	i CardNo'="" d
	.;^DHCCARDi("CF",0,"CardNo",{CF_CardNo},{CF_RowID})
	.s CardRefRowid=0,Flag=0
	.f  s CardRefRowid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardRefRowid)) q:(CardRefRowid="")||(Flag=1)  d
	..s tmp=$g(^DHCCARD("CF",+CardRefRowid))
	..q:tmp=""
	..s Papmi=$p(tmp,"^",4)
	..q:Papmi=""
	..s Papmi=+Papmi
	..s ret=..GetPatInfoTMP(Papmi)
	..s Flag=1
	q:ret'="" ret
	
	i RegNo'="" d
	.s Papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,-1))
    .q:Papmi=""
    .s Papmi=+Papmi
	.s ret=..GetPatInfoTMP(Papmi)
	q ret
}

/// d ##class(web.DHCWMRMedBaseCtl).GetPatInfoTMP(374)
ClassMethod GetPatInfoTMP(xPapmi)
{
	n (xPapmi)
	s ret=""
	q:xPapmi="" ret
	q:'$d(^PAPER(xPapmi)) ret
	
	s ProvinceDesc="",CityBirthDesc="",DeptDesc="",SocialDESC="",PatCategoryDesc=""
	s PAPMIRowId=+xPapmi
	s regno=$p(^PAPER(PAPMIRowId,"PAT",1),"^",1)
	s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","I",-1))
	i paadmID="" s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","O",-1))
	i paadmID="" s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","E",-1))
	;q:paadmID="" ""
	s name=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1)
	s sex=""
	s:$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7)'="" sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7))),"^",2)
	s today=$p($h,",",1)
	s birth=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",6)
	i birth'="" s birthdate=$zd(birth,3)
	s age=..CalAge(birth,today)
	s SocialStatusDR=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",10)
	s SocialStatusDR=+SocialStatusDR
	i SocialStatusDR=0  d
	.s SocialDESC="3自费医疗"
	e  d
	.s SocialDESC=$p($g(^CT("SS",SocialStatusDR)),"^",2)
	.i (SocialDESC'["医疗保险")&(SocialDESC'["公费医疗") d
	..s SocialDESC="3自费医疗"
	s ProvinceDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",11)
	s ProvinceDR=+ProvinceDR        
	i ProvinceDR'=0 s ProvinceDesc=$p($g(^CT("PROV",ProvinceDR)),"^",2)
	i ProvinceDesc["-" s ProvinceDesc=$p(ProvinceDesc,"-",2)
	s GovernCardNo= $p($g(^PAPER(PAPMIRowId,"PER",4)),"^",4) 
	
	;家庭住址,工作单位
	;友谊医院
	;s SecondAddress=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",18)
	;s workAdress=$g(^PAPER(PAPMIRowId,"PER","ADD",1))
	;地坛医院P8
	;s SecondAddress=$g(^PAPER(PAPMIRowId,"PER","ADD",1))
    ;s workAdress=$p($g(^PAPER(PAPMIRowId,"PER",3)),"^",2)
    s SecondAddress=..xGetHomeAddress(PAPMIRowId)
	s workAdress=..xGetCompany(PAPMIRowId)
	s CityBirthDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",18)
	s CityBirthDR=+CityBirthDR
	i CityBirthDR'=0 s CityBirthDesc=$p(^CT("CIT",CityBirthDR),"^",2)
	i $g(CityBirthDesc)["-" s CityBirthDesc=$p(CityBirthDesc,"-",2)
	i paadmID'="" d
	.s DepCodeDR=$p(^PAADM(paadmID),"^",4)
	.q:DepCodeDR=""
	.s DeptDesc=$p($g(^CTLOC(DepCodeDR)),"^",2)
	.s DepCodeDR=+DepCodeDR
	.i $g(DeptDesc)["-" s DeptDesc=$p(DeptDesc,"-",2)
	.;s P6=0
	.;i (arglocID'="")&(arglocID'=DepCodeDR) s P6=1
	.;q:(P6=1) $g(DeptDesc)
	.s curdepdr=$P($g(^CTLOC(DepCodeDR)),"^",19)  
	.s curdepdrdesc=$p($g(^RBC("DEP",+curdepdr)),"^",2)
	.;i (argdepartID'="")&(argdepartID'=curdepdr) s P6=2
	.;q:(P6=2) $g(curdepdrdesc)
	i paadmID'="" d
	.s admDate=$p(^PAADM(paadmID),"^",6)
	.i admDate'="" s admDate=$zd(admDate,3)
	s papmiId=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",9)
	s papmiId=$tr(papmiId," ","")
	;s papersonGX=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",4)
	s papersonGX=..xGetGX(PAPMIRowId)			 		;Modified By liuxuefeng 2009-06-01
	;s papersonGXAdress=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",5)
	s papersonGXAdress=..xGetGXAddress(PAPMIRowId) 		;Modified By liuxuefeng 2009-06-01
	;s papersonGXman=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",1)
	s papersonGXman=..xGetGXMan(PAPMIRowId)				;Modified By liuxuefeng 2009-06-01
	;s papersonGXTel=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",8)
	s papersonGXTel=..xGetGXTel(PAPMIRowId) 			;Modified By liuxuefeng 2009-06-01
	s Marital=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",3)
	i Marital'="" s MaritalDesc=$p($g(^CT("MAR",+Marital)),"^",2)
	//up date by liulan 职业
	s CTOCCDesc=""
	s Occupationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",6) 
	i Occupationdr'="" s CTOCCDesc=$p($g(^CT("OCC",+Occupationdr)),"^",2)
	s nationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",1)
	i nationdr'="" s nationDesc=$p($g(^CT("NAT",+nationdr)),"^",2) 
	i $g(nationDesc)'="" d
	.i nationDesc["-" s nationDesc=$p(nationDesc,"-",2)
	s telphone=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",11)
	s educationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",5)
	i educationdr'="" s educationDesc=$p($g(^CT("EDU",+Marital)),"^",2) 
	;i $d(^PAPER(PAPMIRowId,"PER","ADD",1))'=0 d 
	;.s workAdress= $g(^PAPER(PAPMIRowId,"PER","ADD",1))   ;同MEM
	;PAC_PatientCategory
	s PatCategoryDR=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",8) 
	s PatCategoryDR=+PatCategoryDR
	i PatCategoryDR'=0 s PatCategoryDesc=$p($g(^PAC("PCAT",PatCategoryDR)),"^",2 )
	s countrydr=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",8)
	i countrydr'="" s countryDesc=$p($g(^CT("COU",+countrydr)),"^",2) 
	i $g(ProvinceDesc)=$g(CityBirthDesc) s CityBirthDesc=""
	//s gvCardNo=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",4) 
    //update by zf 2008-10-23
    //住院病历号
    //s gvCardNo=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",22) //中医院病案号
    
    s gvCardNo=..xGetGVCardNo(PAPMIRowId)
	s countryDesc=$g(countryDesc)
	s gvCardNo=$g(gvCardNo)
	s s=$g(name)_$c(2)_$g(sex)_$c(2)_$g(birthdate)_$c(2)_$g(age)_$c(2)_$g(papmiId)_$c(2)_$g(ProvinceDesc)_$g(CityBirthDesc)_$c(2)_$g(MaritalDesc)_$c(2)_$g(nationDesc)_$c(2)_$g(telphone)_$c(2)_$g(educationDesc)_$c(2)_$g(workAdress)_$c(2)_$g(papersonGX)_$c(2)_$g(papersonGXAdress)_$c(2)_$g(papersonGXman)_$c(2)_$g(papersonGXTel)_$c(2)_$g(PatCategoryDesc)_$c(2)_$g(DeptDesc)_$c(2)_$g(SecondAddress)_$c(2)_countryDesc_$c(2)_gvCardNo_$c(2)_$g(SocialDESC)_$c(2)_PAPMIRowId_$c(2)_regno _$c(2)_CTOCCDesc
	;s s=$g(name)_$c(2)_$g(sex)_$c(2)_$g(birthdate)_$c(2)_$g(age)_$c(2)_$g(papmiId)_$c(2)_$g(ProvinceDesc)_$g(CityBirthDesc)_$c(2)_$g(MaritalDesc)_$c(2)_$g(nationDesc)_$c(2)_$g(telphone)_$c(2)_$g(educationDesc)_$c(2)_$g(workAdress)_$c(2)_$g(papersonGX)_$c(2)_$g(papersonGXAdress)_$c(2)_$g(papersonGXman)_$c(2)_$g(papersonGXTel)_$c(2)_$g(PatCategoryDesc)_$c(2)_$g(DeptDesc)_$c(2)_$g(SecondAddress)_$c(2)_""_$c(2)_""_$c(2)_$g(SocialDESC)_$c(2)_PAPMIRowId_$c(2)_regno
	s s=$tr(s,$c(0),"")  //add by zf 2008-05-06
	s s=..ReplaceString(s,$c(13),"") //add by LiYang 2009-2-2
    s s=..ReplaceString(s,$c(10),"") //add by LiYang 2009-2-2	
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

/// Creator：    刘学峰
/// CreatDate：  2009-05-31
/// Description：根据病案号格式设置，补足病案号位数
/// Input：      MrType，MrNo
/// Return：     MrNo
/// Debug:       w ##class(web.DHCWMRMedBaseCtl).FormatMrNo(7,500073) 
ClassMethod FormatMrNo(MrType As %String, MrNo As %String) As %String
{
	n (MrType,MrNo)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).FormatMrNo(MrType,MrNo)
		quit return
	}
	
	q:MrType="" MrNo
	q:MrNo="" MrNo
	q:'$d(^DHCWMRNOTYPE("NoFormat",MrType)) MrNo
	;s MrNo=$ZSTRIP(MrNo,"*A")
	;^DHCWMRNOTYPE("NoFormat",MrType)=NumLen_"^"_NoHead_"^"_DefaultLocFlg_"^"_MinNo_"^"_MrNoField
	s strNoType=$g(^DHCWMRNOTYPE("NoFormat",MrType))
	s MrNoLen=$p(strNoType,"^",1)
	s NoHead=$p(strNoType,"^",2)

	i $l(MrNo)<=MrNoLen d
	.s prelen=MrNoLen-$l(MrNo)
	.for i=1:1:prelen s MrNo="0"_MrNo
	.s:NoHead'="" MrNo=NoHead_MrNo

	q MrNo
}

/// 家庭住址
/// w ##Class(web.DHCWMRMedBaseCtl).xGetHomeAddress(xPapmi)
ClassMethod xGetHomeAddress(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
   
	s ret=##Class(DHCWMRMedBase).xGetHomeAddress(xPapmi)
    q ret
}

/// 工作单位
/// w ##Class(web.DHCWMRMedBaseCtl).xGetCompany(374)
ClassMethod xGetCompany(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    
	s ret=##Class(web.DHCWMRMedBase).xGetCompany(xPapmi)
    q ret
}

/// 住院病历号
/// w ##Class(web.DHCWMRMedBaseCtl).xGetGVCardNo(xPapmi)
ClassMethod xGetGVCardNo(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
	s ret=##Class(DHCWMRMedBase).xGetGVCardNo(xPapmi)
    
    q ret
}

/// 获取联系人姓名
/// Create By LiYang 2008-11-11
/// w ##Class(web.DHCWMRMedBaseCtl).xGetGXMan(xPapmi)
ClassMethod xGetGXMan(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
	s ret=##Class(DHCWMRMedBase).xGetGXMan(xPapmi)
    q ret
}

/// 通过病人的ID取得其联系人地址 
/// Create By liuxuefeng 2009-06-01  
/// w ##Class(web.DHCWMRMedBaseCtl).xGetGXAddress(xPapmi)  		
ClassMethod xGetGXAddress(xPapmi)
{
	
 	n (xPapmi)
    s ret=""
    q:xPapmi="" ret
   
	s ret=##Class(DHCWMRMedBase).xGetGXAddress(xPapmi)
    
    q ret
}

/// 通过病人的ID取得其联系人电话 
/// Create By liuxuefeng 2009-06-01  
/// w ##Class(web.DHCWMRMedBaseCtl).xGetGXTel(xPapmi)  		
ClassMethod xGetGXTel(xPapmi)
{
	
 	n (xPapmi)
    s ret=""
    q:xPapmi="" ret
   
	s ret=##Class(DHCWMRMedBase).xGetGXTel(xPapmi)
    q ret
}

/// 通过病人的ID取得病人与联系人关系
/// Create By liuxuefeng 2009-06-01  
/// w ##Class(web.DHCWMRMedBaseCtl).xGetGX(xPapmi)  		
ClassMethod xGetGX(xPapmi)
{
	
 	n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    
	s ret=##Class(DHCWMRMedBase).xGetGX(xPapmi)
    q ret
}

/// 通过病人的ID取得病人手机号(公司电话)
/// Create By liuxuefeng 2009-06-01  
/// w ##Class(web.DHCWMRMedBaseCtl).xGetMobPhone(xPapmi)  		
ClassMethod xGetMobPhone(xPapmi)
{
	
 	n (xPapmi)
    s ret=""
    q:xPapmi="" ret
   
	s ret=##Class(DHCWMRMedBase).xGetMobPhone(xPapmi)
    
    q ret
}

/// add by zf 2008-11-17
/// 根据科室取病区
/// w ##Class(web.DHCWMRMedBaseCtl).GetWardByDepHosp()
ClassMethod GetWardByDepHosp(LocRowid)
{
	n (LocRowid)
	
	s ret=##Class(DHCWMRMedBase01).GetWardByDepHosp(LocRowid)
	s ret=$tr(ret,"^",$c(2))
	q ret
}

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

/// Creator：    刘学峰
/// CreatDate：  2009-07-01
/// Description：根据 病人姓名 和 病案类型 先后查询
/// 			 病人基本信息表Pa_PatMas 和 病人历史基本信息表DHC_WMR_History 中符合的数据，
/// 			 并以此查询DHC_WMR_Main表中存在有效病案的病案号，
/// 			 如果传入病案类型MrTypeIn为空，则查询全部
/// Table：      Pa_PatMas
/// 			 DHC_WMR_History
/// 			 DHC_WMR_Main	 
/// Input：     
/// 			 PatNameIn       	： 病人姓名(汉字)
/// 			 MrTypeIn		    ： 病案类型ID
/// Return：     符合条件的病案号,"^"分隔：MrNoStr
/// Debug:       w ##Class(web.DHCWMRMedBaseCtl).GetMrNoStrByPatName(PatNameIn,MrTypeIn)
ClassMethod GetMrNoStrByPatName(PatNameIn, MrTypeIn)
{
	n (PatNameIn,MrTypeIn)
	s ret=""
	s PatNameIn=$tr(PatNameIn," ","")
	q:PatNameIn="" ret
	s PatNameIn=$$ALPHAUP^SSUTIL4(PatNameIn)
	;首先在Pa_PatMas表中查找
	;^PAPERi("PAPER_PatName",$$ALPHAUP({PAPMI_Name}),{PAPMI_RowId})
	s PatientID=0
	s MrNoStr=""
	f  s PatientID=$o(^PAPERi("PAPER_PatName",PatNameIn,PatientID)) q:PatientID=""  d
	.;^DHCWMRMAIN(0,"PAPMI",{Papmi_Dr},{Rowid})
	.s MainRowID=0
	.s MainRowID=$o(^DHCWMRMAIN(0,"PAPMI",PatientID,MainRowID))
	.q:MainRowID=""
	.s sMain=$g(^DHCWMRMAIN(MainRowID))
	.s IsActive=$p(sMain,"^",6) ;是否有效
	.;w !,"IsActive="_IsActive
	.q:IsActive'="Y"
	.s MrTypeDr=$p(sMain,"^",1)	;病案类型
	.q:(MrTypeIn'="")&&(MrTypeIn'=MrTypeDr)
	.s MrNo=$p(sMain,"^",2)
	.s MrNoStr=MrNoStr_MrNo_"^"
	
	;然后在病人历史基本信息表DHC_WMR_History中查找
	;^DHCWMRHISTORY(0,"PatientName",$$ALPHAUP({PatientName}),{Rowid})
	s HistoryDR=0
	f  s HistoryDR=$o(^DHCWMRHISTORY(0,"PatientName",PatNameIn,HistoryDR)) q:HistoryDR=""  d
	.;^DHCWMRMAIN(0,"HISTORY",{History_DR},{Rowid})
	.s MainRowID=0
	.s MainRowID=$o(^DHCWMRMAIN(0,"HISTORY",HistoryDR,MainRowID))
	.q:MainRowID=""
	.s sMain=$g(^DHCWMRMAIN(MainRowID))
	.s IsActive=$p(sMain,"^",6) ;是否有效
	.;w !,"History IsActive="_IsActive
	.q:IsActive'="Y"
	.s MrTypeDr=$p(sMain,"^",1)	;病案类型
	.q:(MrTypeIn'="")&&(MrTypeIn'=MrTypeDr)
	.s MrNo=$p(sMain,"^",2)
	.s:MrNoStr'[MrNo MrNoStr=MrNoStr_MrNo_"^"

	s MrNoStr=$e(MrNoStr,1,$l(MrNoStr)-1)
	q MrNoStr
}

/// Creator：    刘学峰
/// CreatDate：  2010-01-18
/// Description：通过登录科室查询对应登录医院
/// Table：      CT_Loc、CT_Hospital
/// Input：      CTLocID:CT_Loc表 RowID
/// Return：     CTLOC_Hospital_DR
/// Debug:       w ##class(web.DHCWMRMedBaseCtl).GetHospitalDRByCTLocID(CTLocID)
ClassMethod GetHospitalDRByCTLocID(CTLocID)
{
	n (CTLocID)
	s ret=-1
	q:CTLocID="" ret
	s ret=-2
	s strCTLoc=$g(^CTLOC(CTLocID))
	q:strCTLoc="" ret
	s HospitalDR=$p(strCTLoc,"^",22) ;CTLOC_Hospital_DR
	q HospitalDR
}

}
