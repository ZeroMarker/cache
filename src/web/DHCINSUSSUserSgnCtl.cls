Import SQLUser

/// 描述：医保签到用户信息表操作类
/// 作者：DingSH 
/// 日期：2019-07-16
Class web.DHCINSUSSUserSgnCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：      DingSH 
/// CreatDate：    2019-07-16
/// Description:   保存用户签到信息
/// Table：        User.INSUSSUserSgn
/// Input：        InString:^操作员Dr^操作员Code^操作员Desc^医保类型^签到日期^签到时间^签退日期^签退时间^签到MAC地址^签到IP地址^签退MAC地址^签退IP地址^业务类型（空:全部、 1:门诊、2:住院）^业务周期流水号    ^有效标志    ^操作日期^操作时间^院区Dr^扩展01^扩展02^扩展03^扩展04^扩展05
/// Output：   
/// Return：       保存成功：Rowid或失败:小于0的提示
/// Others：w ##class(web.DHCINSUSSUserSgnCtl).Save("^1^^^ZZB^2019-07-16^15:25:33^^^FF0COE7F8B^10.1.60.89^^^1^1389subdifg7923uf9h2u9nf2nfo2f^A^^^2^^^^^")
ClassMethod Save(InString As %String) As %String
{
	q:InString="" "-100^入参串为空"
	s UserDr=$P(InString,"^",2)
	q:UserDr="" "-100^操作员Dr不能为空"
	q:+$d(^SSU("SSUSR",UserDr))=0 "-100^操作员Dr非法,UserDr="_UserDr
	s (UserCode,UserName)=""
    s UserCode=$P(InString,"^",3)
    s:UserCode="" UserCode=$P(^SSU("SSUSR",UserDr),"^",1)
    s UserName=$P(InString,"^",4)
    s:UserName="" UserName=$P(^SSU("SSUSR",UserDr),"^",2)
    s $P(InString,"^",3)=UserCode
    s $P(InString,"^",4)=UserName
    b ;01
    s rtn=$$Save^DHCINSUSSUserSgn(InString)
	q rtn
}

/// Creator：      DingSH 
/// CreatDate：    2019-07-16
/// Description:   根据UserDr和医保类型获取有效业务周期号
/// Table：        User.INSUSSUserSgn
/// Input：        UserDr:操作表Rowid,InsuType:医保类型,ExpStr:日期^^^
/// Output：      
/// Return：       BusiNo
/// Others：w ##class(web.DHCINSUSSUserSgnCtl).GetBusiNoByUserDr(1,"ZZB")
ClassMethod GetBusiNoByUserDr(UserDr As %String, InsuType As %String, HospDr As %String, ExpStr As %String = "") As %String
{
	n (UserDr,InsuType,HospDr,ExpStr)
	q:UserDr="" "-100^操作员DR不能为空"
	q:InsuType="" "-100^医保类型不能为空"
	s iDate="",YWLX=""
	s iDate=$P(ExpStr,"^",1)
	s YWLX=$P(ExpStr,"^",2)
	s BusiNo="",ActDate="",LgInDate=""
	s:iDate="" iDate=+$h
	s:$l(iDate)=10&&(iDate["-") iDate=$zdh(iDate)
	s Rowid="",Flag=""
	s iDate=iDate+1
	f  s iDate=$O(^DHCINSUSSGN("0","USERDR",UserDr,"DATE",iDate),-1) q:(iDate="")||(Flag="Y")  d
	.f  s Rowid=$O(^DHCINSUSSGN("0","USERDR",UserDr,"DATE",iDate,Rowid),-1)  q:(Rowid="")||(Flag="Y")  d
	..s SgnStr=$g(^DHCINSUSSGN(Rowid))
	..s tInsuType=$P(SgnStr,"^",4)
	..s tActFlag=$P(SgnStr,"^",15)
	..s LgOutDate=$P(SgnStr,"^",7)
	..s tYWLX=$P(SgnStr,"^",13)
	..s tHospDr=$P(SgnStr,"^",18)
	..q:tHospDr'=HospDr
	..q:tInsuType'=InsuType
	..q:tActFlag'="A"
	..q:LgOutDate'=""
	..q:(YWLX'="")&&(tYWLX'=YWLX)
	..s Flag="Y"
	..s BusiNo=$P(SgnStr,"^",14)
	..s LgInDate=$P(SgnStr,"^",5)
	..b ;00
	
	//..todo 对应周期号生效判断
	//s:(InsuType="GDE")&&(+LgInDate'=+$H) BusiNo=""  ;广东省工伤签到信息24点自动失效
	
	q BusiNo
}

/// Creator：      DingSH 
/// CreatDate：    2019-07-16
/// Description:   根据UserDr和医保类型获取用户操作表信息
/// Table：        User.INSUSSUserSgn
/// Input：        UserDr:操作表Rowid,InsuType:医保类型,HospDr:院区指针,ExpStr:日期^业务类型^数业务周期号^
/// Output：      
/// Return：       用户操作表信息
/// Others：w ##class(web.DHCINSUSSUserSgnCtl).GetSSUserSgnByUserDr(1,"00A","2","^1^")
ClassMethod GetSSUserSgnByUserDr(UserDr As %String, InsuType As %String, HospDr As %String, ExpStr As %String = "") As %String
{
	n (UserDr,InsuType,HospDr,ExpStr)
	s ^CacheTemp("GetSSUserSgnByUserDr")=$lb(UserDr,InsuType,HospDr,ExpStr)
	q:UserDr="" "-100^操作员DR不能为空"
	q:InsuType="" "-100^医保类型不能为空"
	s rtn="-100^"
	s iDate="",YWLX=""
	s iDate=$P(ExpStr,"^",1)
	s YWLX=$P(ExpStr,"^",2)
	s BusiNo="",ActDate="",LgInDate=""
	s BusiNo=$P($g(ExpStr),"^",3)  //业务周期号  DingSH 20211221
	s:iDate="" iDate=+$h
	s:$l(iDate)=10&&(iDate["-") iDate=$zdh(iDate)
	s Rowid="",Flag="",SgnId=""
	s iDate=iDate+1
	f  s iDate=$O(^DHCINSUSSGN("0","USERDR",UserDr,"DATE",iDate),-1) q:(iDate="")||(Flag="Y")  d
	.f  s Rowid=$O(^DHCINSUSSGN("0","USERDR",UserDr,"DATE",iDate,Rowid),-1)  q:(Rowid="")||(Flag="Y")  d
	..s SgnStr=$g(^DHCINSUSSGN(Rowid))
	..s tInsuType=$P(SgnStr,"^",4)
	..s tActFlag=$P(SgnStr,"^",15)
	..s LgOutDate=$P(SgnStr,"^",7)
	..s tYWLX=$P(SgnStr,"^",13)
	..s tHospDr=$P(SgnStr,"^",18)
	..q:tHospDr'=HospDr
	..q:tInsuType'=InsuType
	..q:(YWLX'="")&&(tYWLX'=YWLX)
	..s tBusiNo=$P(SgnStr,"^",14)
	..q:(BusiNo'="")&&(tBusiNo'=BusiNo)
	..s Flag="Y"
	..s SgnId=Rowid
    b ;00
    i SgnId'="" d
	.s rtn=$$GetInfoById^DHCINSUSSUserSgn(SgnId)
	
	q $g(rtn)
}

/// Creator：      DingSH 
/// CreatDate：    2019-07-16
/// Description:   用户签到信息保存
/// Table：        User.INSUSSUserSgn
/// Input：        InString:^操作员Dr^操作员Code^操作员Desc^医保类型^签到日期^签到时间^签到MAC地址^签到IP地址^业务类型（空:全部、 1:门诊、2:住院）^业务周期流水号^有效标志^院区Dr^扩展01^扩展02^扩展03^扩展04^扩展05
/// Output：   
/// Return：       保存成功：Rowid或失败:小于0的提示
/// w ##class(web.DHCINSUSSUserSgnCtl).SignIn("^1^^^ZZB^^^9C:5A:44:07:66:B3^192.168.1.120^1^20051117052435152^A^2^^^^^")
/// Others： w ##class(web.DHCINSUSSUserSgnCtl).SignIn("^1^^^ZZB^2019-07-16^19:22:40^QE0FOE9B8C^10.1.60.89^1^23989subdifg7923uf9h2u9nf2nfo2h^A^2^^^^^")
ClassMethod SignIn(InString As %String) As %String
{
	n (InString)
	s InsuType=$P(InString,"^",5)
	s YWLX=$P(InString,"^",10)
	s BusiNo=$P(InString,"^",11)
	s Rowid="",Flag="",rtn=""
	f  s Rowid=$O(^DHCINSUSSGN("0","BUSINO",BusiNo,Rowid),-1) q:(Rowid="")||(Flag="Y")  d
	.s SgnStr=$g(^DHCINSUSSGN(Rowid))
	.s tInsuType=$P(SgnStr,"^",4)
	.s tActFlag=$P(SgnStr,"^",15)
	.s tYWLX=$P(SgnStr,"^",13)
	.q:tActFlag'="A"
	.q:tInsuType'=InsuType
	.q:(YWLX'="")&&(tYWLX'=YWLX)
	.s Flag="Y"
	.s rtn=Rowid
	i +rtn=0 d
	.s len=$l(InString,"^")
	.s InStringNew=$P(InString,"^",1,7)_"^^^"_$P(InString,"^",8,9)_"^^^"_$P(InString,"^",10,12)_"^^^"_$P(InString,"^",13,len)
	.b ;000
	.s rtn=..Save(InStringNew)
	
	q +rtn
}

/// Creator：      DingSH 
/// CreatDate：    2019-07-16
/// Description:   用户签退信息保存
/// Table：        User.INSUSSUserSgn
/// Input：        InString:^操作员Dr^操作员Code^操作员Desc^医保类型^签退日期^签退时间^签退MAC地址^签退IP地址^业务类型（空:全部、 1:门诊、2:住院）^业务周期流水号^院区Dr^扩展01^扩展02^扩展03^扩展04^扩展05
/// Output：   
/// Return：       保存成功：Rowid或失败:小于0的提示
/// Others w ##class(web.DHCINSUSSUserSgnCtl).SignOut("^1^^^ZZB^2019-07-16^19:12:33^FF0COE7F88^10.1.60.118^1^1389subdifg7923uf9h2u9nf2nfo2f^2^^^^^")
ClassMethod SignOut(InString As %String) As %String
{
	n (InString)
	s InsuType=$P(InString,"^",5)
	s YWLX=$P(InString,"^",10)
	s BusiNo=$P(InString,"^",11)
	s Rowid="",Flag="",rtn=""
	f  s Rowid=$O(^DHCINSUSSGN("0","BUSINO",BusiNo,Rowid),-1) q:(Rowid="")||(Flag="Y")  d
	.s SgnStr=$g(^DHCINSUSSGN(Rowid))
	.s tInsuType=$P(SgnStr,"^",4)
	.s tActFlag=$P(SgnStr,"^",15)
	.s tYWLX=$P(SgnStr,"^",13)
	.q:tActFlag'="A"
	.q:tInsuType'=InsuType
	.q:(YWLX'="")&&(tYWLX'=YWLX)
	.s Flag="Y"
	.s rtn=Rowid
	
	q:+rtn=0 "-100^签退失败,HIS签到信息表中无业务周期号,BusiNo="_BusiNo_"有效记录"
	s Rowid=+rtn
	s LgOutDate=$P(InString,"^",6)
	s:LgOutDate'="" LgOutDate=$zdh(LgOutDate,3)
	s:LgOutDate="" LgOutDate=+$H
	s LgOutTime=$P(InString,"^",7)
	s:LgOutTime'="" LgOutTime=$zth(LgOutTime)
	s:LgOutTime="" LgOutTime=$P($H,",",2)
	s LgOutMac=$P(InString,"^",8)
	s LgOutIP=$P(InString,"^",9)
	
	
	&sql(Update INSU_SSUserSgn set INS_ActFlag='S', INS_LgOutDate=:LgOutDate, INS_LgOutTime=:LgOutTime,INS_LgOutMAC=:LgOutMac,INS_LgOutIP=:LgOutIP where INS_RowID=:Rowid)
	
	q SQLCODE
	
	q 0
}

/// Creator: tangzf
/// CreatDate: 2020-03-09
/// Description: 查询保存用户签到信息
/// Input: 
/// Output: 
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCINSUSSUserSgnCtl","QueryINSUSSUserSgn",66100,66100,"909","2","00A","")
Query QueryINSUSSUserSgn(StartDate, EndDate, User, HospId, INSUType, AdmType) As websys.Query(ROWSPEC = "INSUserDr,INSUserCode,INSUserDesc,INSInsuType,INSLgInDate,INSLgOutDate,INSLgInMAC,INSLgInIP,INSLgOutMAC,INSLgOutIP,INSYWLX,INSBusiNo,INSActFlag,INSiDate,INSHospDr,INSExpStr1,INSExpStr2,INSExpStr3,INSExpStr4,INSExpStr5,INSAdmType,TInsuType") [ SqlProc ]
{
}

ClassMethod QueryINSUSSUserSgnExecute(ByRef qHandle As %Binary, StartDate, EndDate, User, HospId, INSUType, AdmType) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    s:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	s ^CacheTemp("QueryINSUSSUserSgnExecute")=$lb(StartDate, EndDate, User, HospId,INSUType, AdmType)
    s Rowid=0
	f  s Rowid=$O(^DHCINSUSSGN(Rowid))  q:(Rowid="")  d
	.s SgnStr=$g(^DHCINSUSSGN(Rowid))
	.s INSUserDr=$P(SgnStr,"^",1)
	.q:(User'="")&&(User'=INSUserDr)
	.s INSUserCode=$P(SgnStr,"^",2)
	.s INSUserDesc=$P(SgnStr,"^",3)
	.q:(INSUType'="")&&(INSUType'=$P(SgnStr,"^",4))
	.s TInsuType=$P(SgnStr,"^",4)
	.s INSInsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DLLType",$P(SgnStr,"^",4),4,HospId) 
	.q:$P(SgnStr,"^",5)<StartDate
	.q:$P(SgnStr,"^",5)>EndDate
    .s:$P(SgnStr,"^",5)'="" $P(SgnStr,"^",5)=##class(websys.Conversions).DateLogicalToHtml($P(SgnStr,"^",5))
    .s:$P(SgnStr,"^",6)'="" $P(SgnStr,"^",6)=##class(websys.Conversions).TimeLogicalToHtml($P(SgnStr,"^",6))
    .s:$P(SgnStr,"^",7)'="" $P(SgnStr,"^",7)=##class(websys.Conversions).DateLogicalToHtml($P(SgnStr,"^",7))
    .s:$P(SgnStr,"^",8)'="" $P(SgnStr,"^",8)=##class(websys.Conversions).TimeLogicalToHtml($P(SgnStr,"^",8))
	.s INSLgInDate=$P(SgnStr,"^",5)_" "_$P(SgnStr,"^",6) 
	.s INSLgOutDate=$P(SgnStr,"^",7)_" "_$P(SgnStr,"^",8) 
	.s INSLgInMAC=$P(SgnStr,"^",9)
	.s INSLgInIP=$P(SgnStr,"^",10)
	.s INSLgOutMAC=$P(SgnStr,"^",11)
	.s INSLgOutIP=$P(SgnStr,"^",12)
	.q:(AdmType'="")&&($P(SgnStr,"^",13)'=AdmType)
	.s INSAdmType=$P(SgnStr,"^",13)
	.s INSYWLX=$case(INSAdmType,"1":"门诊","2":"住院",:"全部")
	.s INSBusiNo=$P(SgnStr,"^",14)
	.s INSActFlag=$P(SgnStr,"^",15)
	.s INSActFlag=$case(INSActFlag,"A":"已签到","S":"已签退",:INSActFlag)
	.s:$P(SgnStr,"^",16)'="" $P(SgnStr,"^",16)=##class(websys.Conversions).DateLogicalToHtml($P(SgnStr,"^",16))
    .s:$P(SgnStr,"^",17)'="" $P(SgnStr,"^",17)=##class(websys.Conversions).TimeLogicalToHtml($P(SgnStr,"^",17))
	.s INSiDate=$P(SgnStr,"^",16)_" "_$P(SgnStr,"^",17) 
	.s INSHospDr=$P(SgnStr,"^",18)
	.q:INSHospDr'=HospId
	.s INSExpStr1=$P(SgnStr,"^",19)
	.s INSExpStr2=$P(SgnStr,"^",20)
	.s INSExpStr3=$P(SgnStr,"^",21)
	.s INSExpStr4=$P(SgnStr,"^",22)
	.s INSExpStr5=$P(SgnStr,"^",23)
	.s HospDesc=$p($G(^CT("HOSP",INSHospDr)),"^",2)
	.d BuildData
	.;q:tInsuType'=InsuType
	.;q:tActFlag'="A"
	.;q:LgOutDate'=""
	// 	INSUserDr,INSUserCode,INSUserDesc,INSInsuType,INSLgInDate,INSLgOutDate,INSLgInMAC,INSLgInIP,INSLgOutMAC,INSLgOutIP,INSYWLX,INSBusiNo,INSActFlag,INSiDate,INSHospDr
	quit $$$OK
BuildData	
	set data=$lb(INSUserDr,INSUserCode,INSUserDesc,INSInsuType,INSLgInDate,INSLgOutDate,INSLgInMAC,INSLgInIP,INSLgOutMAC,INSLgOutIP,INSYWLX,INSBusiNo,INSActFlag,INSiDate,HospDesc,INSExpStr1,INSExpStr2,INSExpStr3,INSExpStr4,INSExpStr5,INSAdmType,TInsuType)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	quit
}

}
