Class web.PMP.ImproventFindShenhe Extends %Persistent
{

Query SelectPMPImprovementList(TJCreateDateStart As %String, TJCreateDateEnd As %String, TJCode As %String, TJName As %String, TJMenu As %String, TJFinish As %String, XYSHSJ As %String) As %Query(ROWSPEC = "XQxiangxi:%String,XQCode:%String,XQName:%String,XQStatus:%String,XQEmergency:%String,XQDegree:%String,XQMenu:%String,XQAssignEngineer:%String,XQAdjunctFlag:%String,XQRowid:%String,XQSituation:%String,XQStandby3:%String,XQGoutongjieguo:%String,XQCreateTel:%String,XQStandby2:%String,XQType:%String,XQzhidinggcs:%String")
{
}

//张枕平  2014-11-07

//根据条件查询需求列表

//d ##class(%ResultSet).RunQuery("web.PMP.ImproventFindShenhe","SelectPMPImprovementList","","","","","","")

//^dongzt("select")="63492^63561^^^^on^!!5280!!132"

ClassMethod SelectPMPImprovementListExecute(ByRef qHandle As %Binary, TJCreateDateStart As %String, TJCreateDateEnd As %String, TJCode As %String, TJName As %String, TJMenu As %String, TJFinish As %String, XYSHSJ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	K ^TMPZZP($j),^TMPZZP1($j),^TMPZZP2($j),^CacheTemp($j,"Net")
	;s ^zhmtemp("Select")=TJCreateDateStart_","_TJCreateDateEnd_","_TJCode_","_TJName_","_TJMenu_","_TJFinish
	S (XQxiangxi,XQCode,XQName,XQStatus,XQEmergency,XQDegree,XQMenu,XQAssignEngineer,XQAdjunctFlag,XQRowid,XQSituation,XQStandby3,XQGoutongjieguo,XQCreateTel,XQStandby2,XQType,IPRLtype,XQStatus)=""
	s userId=%session.Data("LOGON.USERID")  ;"79" 武尚峰 "1456" ;  "1456" ;
	s locid=%session.Data("LOGON.CTLOCID")  ;"1" ;
	;s ^zhmtemp("Select")=$g(^zhmtemp("Select"))_"^"_userId_"^"_locid
	s idno=0
	s ROWIDD="" F  S ROWIDD=$O(^PMPPermission(ROWIDD)) Q:ROWIDD=""  D
	.s PERLevel=$p(^PMPPermission(ROWIDD),"^",3)
	.s PERSpare2=$p(^PMPPermission(ROWIDD),"^",5)
	.s PERSpare3=$p(^PMPPermission(ROWIDD),"^",6)  //
	.s PERSpare5=$p(^PMPPermission(ROWIDD),"^",8)  //是否必须审核
	.q:PERSpare2'="Y"
	.s idno=idno+1
	.s ^TMPZZP2($j,idno)=PERLevel_"^"_PERSpare3_"^"_PERSpare5
	.s ROWID="" F  S ROWID=$O(^PMPPermisBusinessi("PERBusUserDr",ROWIDD,userId,ROWID)) Q:ROWID=""  D
	..s PERBusIsEffect=$P(^PMPPermisBusiness(ROWIDD,"E",ROWID),"^",3)
	..q:PERBusIsEffect'="Y"
	..s PERBusSpare1=$P(^PMPPermisBusiness(ROWIDD,"E",ROWID),"^",5)
	..I PERBusSpare1="" S PERBusSpare1="全部"
	..s ^TMPZZP1($j,userId,PERLevel)=PERSpare3_"^"_PERSpare5
	..s ^TMPZZP($j,PERLevel,userId,PERBusSpare1)=PERSpare5
	i TJCreateDateStart=""  s TJCreateDateStart=+$h-15
	i TJCreateDateEnd=""  s TJCreateDateEnd=+$h
	f date=TJCreateDateStart:1:TJCreateDateEnd  d
	.s IPMLRowid="" f  s IPMLRowid=$o(^PMPImprovementListi("CreateDate",date,IPMLRowid)) q:IPMLRowid=""  d
	..s IPMLStatusDR=$p(^PMPImprovementList(IPMLRowid),"^",28)
	..Q:IPMLStatusDR=""     //暂时出w
	..q:IPMLStatusDR="91"
	..s spare=$o(^TMPZZP1($j,userId,""))
	..q:spare=""
	..s spare3=$p(^TMPZZP1($j,userId,spare),"^",1)
	..s spare5=$p(^TMPZZP1($j,userId,spare),"^",2)
	..s IPMUser=$p(^PMPImprovementList(IPMLRowid),"^",42)    ;;存科室审核人id
	..i IPMUser'="" Q:(spare5'="F")&(userId'=IPMUser)    ;;退出登陆人与审核人不一致
    ..s XQStatus=$P(^PMPDictionary(IPMLStatusDR),"^",2)
	..s XQCode=$p(^PMPImprovementList(IPMLRowid),"^",1)
	..q:(TJCode'="")&(XQCode'[TJCode)
	..s XQName=$p(^PMPImprovementList(IPMLRowid),"^",2)
	..q:(TJName'="")&(XQName'[TJName)
	..s IPMLCreateUserDR=$p(^PMPImprovementList(IPMLRowid),"^",15)
	..s TYPCreatUser=$p(^SSU("SSUSR",IPMLCreateUserDR),"^",2)
	..s IPMLRevList=$p(^PMPImprovementList(IPMLRowid),"^",39)
	..S IPRLChildsub=""
	..i IPMLRevList'=""   d          //需要审核人不为空的情况
	...f  s IPRLChildsub=$O(^PMPImprovementRevListi("User",IPMLRowid,userId,IPRLChildsub)) q:IPRLChildsub=""  d
	....i IPRLChildsub'="" d         //登陆人在需审核列表中的情况
	.....s IPRLtype=$p(^PMPImprovementRevList(IPMLRowid,IPRLChildsub),"^",6)
	.....q:(TJFinish="")&(IPRLtype'="")&(IPRLChildsub'="")
	.....q:(TJFinish="on")&(IPRLtype="")&(IPRLChildsub'="")
	.....s IPMLModuleDR=$p(^PMPImprovementList(IPMLRowid),"^",23)
	.....i IPMLModuleDR'=""  d
	......s IPMLModule=$p(^PMPModule(IPMLModuleDR),"^",2)
	......s MODEProduct=$p(^PMPModule(IPMLModuleDR),"^",7)
	.....e  s IPMLModule="",MODEProduct=""
	.....s TYPCreatDate=$p(^PMPImprovementList(IPMLRowid),"^",11)
	.....S TYPCreatDate=$ZD(TYPCreatDate,3)
	.....;s IPMDChildsub=$o(^PMPImprovementDetaili("Flag",IPMLRowid,"133",""))
	.....;s TYPCheckDate=$p(^PMPImprovementDetail(IPMLRowid,IPMDChildsub),"^",11)
	.....s TYPEmergencyDR=$p(^PMPImprovementList(IPMLRowid),"^",18)
	.....i TYPEmergencyDR="" s TYPEmergency=""
	.....i TYPEmergencyDR'=""  d
	......s XQEmergency=$P(^PMPDictionary(TYPEmergencyDR),"^",2)
	.....s TYPtypeDR=$p(^PMPImprovementList(IPMLRowid),"^",31)
	.....i TYPtypeDR="" s TYPtype=""
	.....i TYPtypeDR'="" s TYPtype=$p(^PMPDictionary(TYPtypeDR),"^",2)
	.....s TYPDegreeDR=$p(^PMPImprovementList(IPMLRowid),"^",16)
	.....i TYPDegreeDR="" s XQDegree=""
	.....i TYPDegreeDR'="" s XQDegree=$p(^PMPDictionary(TYPDegreeDR),"^",2)
	.....s XQAdjunctFlag=$p(^PMPImprovementList(IPMLRowid),"^",3)
	.....i XQAdjunctFlag'="Y" s XQAdjunctFlag=""
	.....s TYPRowid=IPMLRowid
	.....s XQSituation=$p(^PMPImprovementList(IPMLRowid),"^",26)
	.....s XQCreateTel=$p(^PMPImprovementList(IPMLRowid),"^",13)
	.....S TYPPredictTime=$p(^PMPImprovementList(IPMLRowid),"^",24)
	.....s XQMenu=$p(^PMPImprovementList(IPMLRowid),"^",21)
	.....s IPMLDevelopUser=$p(^PMPImprovementList(IPMLRowid),"^",17)
	.....s IPMLAssignEngineerDR=$p(^PMPImprovementList(IPMLRowid),"^",4)
	.....I IPMLAssignEngineerDR="" S XQAssignEngineer=""
	.....I IPMLAssignEngineerDR'="" S XQAssignEngineer=$p(^SSU("SSUSR",IPMLAssignEngineerDR),"^",2)
	.....S XQRowid=IPMLRowid
	.....S XQStandby3=$p(^PMPImprovementList(IPMLRowid),"^",34)
	.....s XQGoutongjieguo=$p(^PMPImprovementList(IPMLRowid),"^",33)
	.....s XQStandby2dr=$p(^PMPImprovementList(IPMLRowid),"^",35)
	.....I XQStandby2dr'="" D
	......s XQStandby2=$p(^SSU("SSUSR",XQStandby2dr),"^",2)
	.....E  S XQStandby2=""
	.....s XQTypedr=$p(^PMPImprovementList(IPMLRowid),"^",31)
	.....I XQTypedr'="" D
	......S XQType=$P(^PMPDictionary(XQTypedr),"^",2)
	.....E  S XQType=""
	.....;----begin----增加科室审核过滤
	.....s XQloc=$p(^PMPImprovementList(IPMLRowid),"^",12)   //创建需求科室id
	.....s loc=..IsDepartAudit(userId)
	.....i loc'="" Q:loc'=XQloc
	..... ;---end---------
	.....D OutputRow1
	

	...i IPRLChildsub="" d    //登录人不在需审核列表中
	....s IPRLLISTChildsub="" F  S IPRLLISTChildsub=$O(^PMPImprovementRevList(IPMLRowid,IPRLLISTChildsub)) Q:IPRLLISTChildsub=""  D
	.....S IPRLtype=$p(^PMPImprovementRevList(IPMLRowid,IPRLLISTChildsub),"^",6)
	.....Q:IPRLtype'="Y"
	.....s IPMLCreateLocDR=$p(^PMPImprovementList(IPMLRowid),"^",12)
	.....q:IPMLCreateLocDR=""
	.....s loctype=$p(^CTLOC(IPMLCreateLocDR),"^",19)
	.....s PERLevelid="" f  s PERLevelid=$o(^TMPZZP1($j,userId,PERLevelid)) q:PERLevelid=""  d
	......s IPMLStandtb1=$p(^PMPImprovementList(IPMLRowid),"^",42)
	......i IPMLStandtb1'=""  d
	.......f IPMLStandtb1id=1:1:$l(IPMLStandtb1,",")  d
	........s IPMLStandtb1desc=$p(IPMLStandtb1,",",IPMLStandtb1id)
	........s ^TMPZZP3(IPMLStandtb1desc)=""
	......q:($p(^TMPZZP1($j,userId,PERLevelid),"^",2)="N")&('$D(^TMPZZP3($p(^TMPZZP1($j,userId,PERLevelid),"^",1))))
	......q:('$d(^TMPZZP($j,PERLevelid,userId,"全部")))&('$d(^TMPZZP($j,PERLevelid,userId,PERLevelid)))
	......s PERLevelid1="" f  s PERLevelid1=$o(^TMPZZP2($j,PERLevelid1)) q:PERLevelid1=""  d ;=PERLevel_"^"_PERSpare3
	.......s PERLevel=$p(^TMPZZP2($j,PERLevelid1),"^",1)  //获取当前审核级别的级别权限
	.......q:PERLevel'=PERLevelid  //帅选掉不符当前登录帐号的审核级别
	.......s PERSpare3=$o(^PMPDictionary(0,"DTY_Desc","提交",""))
	.......i PERLevelid1'="1" s PERSpare3=$p(^TMPZZP2($j,PERLevelid1-1),"^",2)  //获取上一级审核情况
	.......q:(TJFinish="")&(IPMLStatusDR'=PERSpare3)
	.......b ;12333
	.......q:(TJFinish="on")&(IPMLStatusDR<$p(^TMPZZP2($j,PERLevelid1),"^",2))
    .......s IPMLModuleDR=$p(^PMPImprovementList(IPMLRowid),"^",23)
	.......i IPMLModuleDR'=""  d
	........s IPMLModule=$p(^PMPModule(IPMLModuleDR),"^",2)
	........s MODEProduct=$p(^PMPModule(IPMLModuleDR),"^",7)
	.......e  s IPMLModule="",MODEProduct=""
	.......s TYPCreatDate=$p(^PMPImprovementList(IPMLRowid),"^",11)
	.......S TYPCreatDate=$ZD(TYPCreatDate,3)
	.......;s IPMDChildsub=$o(^PMPImprovementDetaili("Flag",IPMLRowid,"133",""))
	.......;s TYPCheckDate=$p(^PMPImprovementDetail(IPMLRowid,IPMDChildsub),"^",11)
	.......s TYPEmergencyDR=$p(^PMPImprovementList(IPMLRowid),"^",18)
	.......i TYPEmergencyDR="" s TYPEmergency=""
	.......i TYPEmergencyDR'=""  d
	........s XQEmergency=$P(^PMPDictionary(TYPEmergencyDR),"^",2)
	.......s TYPtypeDR=$p(^PMPImprovementList(IPMLRowid),"^",31)
	.......i TYPtypeDR="" s TYPtype=""
	.......i TYPtypeDR'="" s TYPtype=$p(^PMPDictionary(TYPtypeDR),"^",2)
	.......s TYPDegreeDR=$p(^PMPImprovementList(IPMLRowid),"^",16)
	.......i TYPDegreeDR="" s XQDegree=""
	.......i TYPDegreeDR'="" s XQDegree=$p(^PMPDictionary(TYPDegreeDR),"^",2)
	.......s XQAdjunctFlag=$p(^PMPImprovementList(IPMLRowid),"^",3)
	.......i XQAdjunctFlag'="Y" s XQAdjunctFlag=""
	.......s TYPRowid=IPMLRowid
	.......s XQSituation=$p(^PMPImprovementList(IPMLRowid),"^",26)
	.......s XQCreateTel=$p(^PMPImprovementList(IPMLRowid),"^",13)
	.......S TYPPredictTime=$p(^PMPImprovementList(IPMLRowid),"^",24)
	.......s XQMenu=$p(^PMPImprovementList(IPMLRowid),"^",21)
	.......s IPMLDevelopUser=$p(^PMPImprovementList(IPMLRowid),"^",17)
	.......s IPMLAssignEngineerDR=$p(^PMPImprovementList(IPMLRowid),"^",4)
	.......I IPMLAssignEngineerDR="" S XQAssignEngineer=""
	.......I IPMLAssignEngineerDR'="" S XQAssignEngineer=$p(^SSU("SSUSR",IPMLAssignEngineerDR),"^",2)
	.......S XQRowid=IPMLRowid
	.......S XQStandby3=$p(^PMPImprovementList(IPMLRowid),"^",34)
	.......s XQGoutongjieguo=$p(^PMPImprovementList(IPMLRowid),"^",33)
	.......s XQStandby2dr=$p(^PMPImprovementList(IPMLRowid),"^",35)
	.......I XQStandby2dr'="" D
	........s XQStandby2=$p(^SSU("SSUSR",XQStandby2dr),"^",2)
	.......E  S XQStandby2=""
	.......s XQTypedr=$p(^PMPImprovementList(IPMLRowid),"^",31)
	.......I XQTypedr'="" D
	........S XQType=$P(^PMPDictionary(XQTypedr),"^",2)
	.......E  S XQType=""
	.......;--begin增加审核过滤
	.......s XQloc=$p(^PMPImprovementList(IPMLRowid),"^",12)   //创建需求科室id
	.......s loc=..IsDepartAudit(userId)
	.......i loc'="" Q:loc'=XQloc
	.......;----end-----------
	.......D OutputRow1
	..E  d   //需审核人为空的情况（不需要需审核人）
	...s XQloc=$p(^PMPImprovementList(IPMLRowid),"^",12)   //创建需求科室id
	...s loc=..IsDepartAudit(userId)
	...i loc'=""  d  ;)&(spare5="F")&(loc'=XQloc)
	....B ;123
	....q:loc'=XQloc
	....s IPMLCreateLocDR=$p(^PMPImprovementList(IPMLRowid),"^",12)
	....q:IPMLCreateLocDR=""
	....s IPRLtype=$p(^PMPImprovementList(IPMLRowid),"^",28)
	....s loctype=$p(^CTLOC(IPMLCreateLocDR),"^",19)
	....s PERLevelid=$o(^TMPZZP1($j,userId,"")) 
	....s IPMLStandtb1=$p(^PMPImprovementList(IPMLRowid),"^",43)
	....i IPMLStandtb1'=""  d
	.....f IPMLStandtb1id=1:1:$l(IPMLStandtb1,",")  d
	......s IPMLStandtb1desc=$p(IPMLStandtb1,",",IPMLStandtb1id)
	......s ^TMPZZP3(IPMLStandtb1desc)=""
	....s IPMLStandtb2=$p(^PMPImprovementList(IPMLRowid),"^",42)
	....S typezzp3=$p(^TMPZZP1($j,userId,PERLevelid),"^",1)
	....q:($p(^TMPZZP1($j,userId,PERLevelid),"^",2)="N")&(IPMLStandtb2=PERLevelid)
	....;s ^tempbaoshi("11")=PERLevelid_",,"_userId_",,"_PERLevelid
	....q:(('$d(^TMPZZP($j,PERLevelid,userId,PERLevelid)))&('$d(^TMPZZP($j,PERLevelid,userId,"全部"))))
	....s PERLevelid1="" f  s PERLevelid1=$o(^TMPZZP2($j,PERLevelid1)) q:PERLevelid1=""  d ;=PERLevel_"^"_PERSpare3
	.....s PERLevel=$p(^TMPZZP2($j,PERLevelid1),"^",1)  //获取当前审核级别的级别权限
	.....q:PERLevel'=PERLevelid  //帅选掉不符当前登录帐号的审核级别
	.....s PERSpare3=$o(^PMPDictionary(0,"DTY_Desc","提交",""))
	.....i PERLevelid1'="1" s PERSpare3=$p(^TMPZZP2($j,PERLevelid1-1),"^",2)  //获取上一级审核情况
	.....b ;XQloc
	.....q:((TJFinish="")&(IPMLStatusDR'=PERSpare3))
	.....b ;23
	.....q:(TJFinish="on")&(IPMLStatusDR<$p(^TMPZZP2($j,PERLevelid1),"^",2))
    .....s IPMLModuleDR=$p(^PMPImprovementList(IPMLRowid),"^",23)
	.....i IPMLModuleDR'=""  d
	......s IPMLModule=$p(^PMPModule(IPMLModuleDR),"^",2)
	......s MODEProduct=$p(^PMPModule(IPMLModuleDR),"^",7)
	.....e  s IPMLModule="",MODEProduct=""
	.....s TYPCreatDate=$p(^PMPImprovementList(IPMLRowid),"^",11)
	.....S TYPCreatDate=$ZD(TYPCreatDate,3)
	.....;s IPMDChildsub=$o(^PMPImprovementDetaili("Flag",IPMLRowid,"133",""))
	.....;s TYPCheckDate=$p(^PMPImprovementDetail(IPMLRowid,IPMDChildsub),"^",11)
	.....s TYPEmergencyDR=$p(^PMPImprovementList(IPMLRowid),"^",18)
	.....i TYPEmergencyDR="" s TYPEmergency=""
	.....i TYPEmergencyDR'=""  d       ;下一步循环
	......s XQEmergency=$P(^PMPDictionary(TYPEmergencyDR),"^",2)
	.....s TYPtypeDR=$p(^PMPImprovementList(IPMLRowid),"^",31)
	.....i TYPtypeDR="" s TYPtype=""
	.....i TYPtypeDR'="" s TYPtype=$p(^PMPDictionary(TYPtypeDR),"^",2)
	.....s TYPDegreeDR=$p(^PMPImprovementList(IPMLRowid),"^",16)
	.....i TYPDegreeDR="" s XQDegree=""
	.....i TYPDegreeDR'="" s XQDegree=$p(^PMPDictionary(TYPDegreeDR),"^",2)
	.....s XQAdjunctFlag=$p(^PMPImprovementList(IPMLRowid),"^",3)
	.....i XQAdjunctFlag'="Y" s XQAdjunctFlag=""
	.....s TYPRowid=IPMLRowid
	.....s XQSituation=$p(^PMPImprovementList(IPMLRowid),"^",26)
	.....s XQCreateTel=$p(^PMPImprovementList(IPMLRowid),"^",13)
	.....S TYPPredictTime=$p(^PMPImprovementList(IPMLRowid),"^",24)
	.....s XQMenu=$p(^PMPImprovementList(IPMLRowid),"^",21)
	.....s IPMLDevelopUser=$p(^PMPImprovementList(IPMLRowid),"^",17)
	.....s IPMLAssignEngineerDR=$p(^PMPImprovementList(IPMLRowid),"^",4)
	.....I IPMLAssignEngineerDR="" S XQAssignEngineer=""
	.....I IPMLAssignEngineerDR'="" S XQAssignEngineer=$p(^SSU("SSUSR",IPMLAssignEngineerDR),"^",2)
	.....S XQRowid=IPMLRowid
	.....S XQStandby3=$p(^PMPImprovementList(IPMLRowid),"^",34)
	.....s XQGoutongjieguo=$p(^PMPImprovementList(IPMLRowid),"^",33)
	.....s XQStandby2dr=$p(^PMPImprovementList(IPMLRowid),"^",35)
	.....I XQStandby2dr'="" D
	......s XQStandby2=$p(^SSU("SSUSR",XQStandby2dr),"^",2)
	.....E  S XQStandby2=""
	.....s XQTypedr=$p(^PMPImprovementList(IPMLRowid),"^",31)
	.....I XQTypedr'="" D
	......S XQType=$P(^PMPDictionary(XQTypedr),"^",2)
	.....E  S XQType=""
	.....D OutputRow1
	
	...; 
	...i loc=""  d
	....s ret=..NedIsDepartAudit()
	....i ret'=""  d
	.....f no=1:1:$l(ret,"^")   d
	......s nedlocid=$p(ret,"^",no)
	......s ^CacheTemp($j,"Net",nedlocid)=""
	....q:$d(^CacheTemp($j,"Net",XQloc))
	....s IPMLCreateLocDR=$p(^PMPImprovementList(IPMLRowid),"^",12)
	....q:IPMLCreateLocDR=""
	....s IPRLtype=$p(^PMPImprovementList(IPMLRowid),"^",28)
	....s loctype=$p(^CTLOC(IPMLCreateLocDR),"^",19)
	....s PERLevelid=$o(^TMPZZP1($j,userId,"")) 
	....s IPMLStandtb1=$p(^PMPImprovementList(IPMLRowid),"^",43)
	....i IPMLStandtb1'=""  d
	.....f IPMLStandtb1id=1:1:$l(IPMLStandtb1,",")  d
	......s IPMLStandtb1desc=$p(IPMLStandtb1,",",IPMLStandtb1id)
	......s ^TMPZZP3(IPMLStandtb1desc)=""
	....s IPMLStandtb2=$p(^PMPImprovementList(IPMLRowid),"^",42)
	....S typezzp3=$p(^TMPZZP1($j,userId,PERLevelid),"^",1)
	....q:($p(^TMPZZP1($j,userId,PERLevelid),"^",2)="N")&(IPMLStandtb2=PERLevelid)
	....;s ^tempbaoshi("11")=PERLevelid_",,"_userId_",,"_PERLevelid
	....q:(('$d(^TMPZZP($j,PERLevelid,userId,PERLevelid)))&('$d(^TMPZZP($j,PERLevelid,userId,"全部"))))
	....s PERLevelid1="" f  s PERLevelid1=$o(^TMPZZP2($j,PERLevelid1)) q:PERLevelid1=""  d ;=PERLevel_"^"_PERSpare3
	.....s PERLevel=$p(^TMPZZP2($j,PERLevelid1),"^",1)  //获取当前审核级别的级别权限
	.....q:PERLevel'=PERLevelid  //帅选掉不符当前登录帐号的审核级别
	.....s PERSpare3=$o(^PMPDictionary(0,"DTY_Desc","提交",""))
	.....i PERLevelid1>"2" s PERSpare3=$p(^TMPZZP2($j,PERLevelid1-1),"^",2)  //获取上一级审核情况
	.....b ;XQloc
	.....q:((TJFinish="")&(IPMLStatusDR'=PERSpare3))
	.....b ;23
	.....q:(TJFinish="on")&(IPMLStatusDR<$p(^TMPZZP2($j,PERLevelid1),"^",2))
    .....s IPMLModuleDR=$p(^PMPImprovementList(IPMLRowid),"^",23)
	.....i IPMLModuleDR'=""  d
	......s IPMLModule=$p(^PMPModule(IPMLModuleDR),"^",2)
	......s MODEProduct=$p(^PMPModule(IPMLModuleDR),"^",7)
	.....e  s IPMLModule="",MODEProduct=""
	.....s TYPCreatDate=$p(^PMPImprovementList(IPMLRowid),"^",11)
	.....S TYPCreatDate=$ZD(TYPCreatDate,3)
	.....;s IPMDChildsub=$o(^PMPImprovementDetaili("Flag",IPMLRowid,"133",""))
	.....;s TYPCheckDate=$p(^PMPImprovementDetail(IPMLRowid,IPMDChildsub),"^",11)
	.....s TYPEmergencyDR=$p(^PMPImprovementList(IPMLRowid),"^",18)
	.....i TYPEmergencyDR="" s TYPEmergency=""
	.....i TYPEmergencyDR'=""  d       ;下一步循环
	......s XQEmergency=$P(^PMPDictionary(TYPEmergencyDR),"^",2)
	.....s TYPtypeDR=$p(^PMPImprovementList(IPMLRowid),"^",31)
	.....i TYPtypeDR="" s TYPtype=""
	.....i TYPtypeDR'="" s TYPtype=$p(^PMPDictionary(TYPtypeDR),"^",2)
	.....s TYPDegreeDR=$p(^PMPImprovementList(IPMLRowid),"^",16)
	.....i TYPDegreeDR="" s XQDegree=""
	.....i TYPDegreeDR'="" s XQDegree=$p(^PMPDictionary(TYPDegreeDR),"^",2)
	.....s XQAdjunctFlag=$p(^PMPImprovementList(IPMLRowid),"^",3)
	.....i XQAdjunctFlag'="Y" s XQAdjunctFlag=""
	.....s TYPRowid=IPMLRowid
	.....s XQSituation=$p(^PMPImprovementList(IPMLRowid),"^",26)
	.....s XQCreateTel=$p(^PMPImprovementList(IPMLRowid),"^",13)
	.....S TYPPredictTime=$p(^PMPImprovementList(IPMLRowid),"^",24)
	.....s XQMenu=$p(^PMPImprovementList(IPMLRowid),"^",21)
	.....s IPMLDevelopUser=$p(^PMPImprovementList(IPMLRowid),"^",17)
	.....s IPMLAssignEngineerDR=$p(^PMPImprovementList(IPMLRowid),"^",4)
	.....I IPMLAssignEngineerDR="" S XQAssignEngineer=""
	.....I IPMLAssignEngineerDR'="" S XQAssignEngineer=$p(^SSU("SSUSR",IPMLAssignEngineerDR),"^",2)
	.....S XQRowid=IPMLRowid
	.....S XQStandby3=$p(^PMPImprovementList(IPMLRowid),"^",34)
	.....s XQGoutongjieguo=$p(^PMPImprovementList(IPMLRowid),"^",33)
	.....s XQStandby2dr=$p(^PMPImprovementList(IPMLRowid),"^",35)
	.....I XQStandby2dr'="" D
	......s XQStandby2=$p(^SSU("SSUSR",XQStandby2dr),"^",2)
	.....E  S XQStandby2=""
	.....s XQTypedr=$p(^PMPImprovementList(IPMLRowid),"^",31)
	.....I XQTypedr'="" D
	......S XQType=$P(^PMPDictionary(XQTypedr),"^",2)
	.....E  S XQType=""
	.....;b ;begin
	.....;b ;---begin--增加科室审核过滤
	
	.....;b ;spare
	.....;b ;---end------------
	.....D OutputRow1
	K ^TMPZZP($j),^TMPZZP1($j),^TMPZZP2($j),^CacheTemp($j,"Net")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1      
	set Data=$lb(XQxiangxi,XQCode,XQName,XQStatus,XQEmergency,XQDegree,XQMenu,XQAssignEngineer,XQAdjunctFlag,XQRowid,XQSituation,XQStandby3,XQGoutongjieguo,XQCreateTel,XQStandby2,XQType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SelectPMPImprovementListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPMPImprovementListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectPMPImprovementListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPMPImprovementListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QuanXianGuanLi() As %String
{
	s ret=""
    s userId=%session.Data("LOGON.USERID")
	s ROWIDD="" F  S ROWIDD=$O(^PMPPermission(ROWIDD)) Q:ROWIDD=""  D
	.s PERLevel=$p(^PMPPermission(ROWIDD),"^",3)
	.s PERSpare2=$p(^PMPPermission(ROWIDD),"^",5)
	.s PERSpare3=$p(^PMPPermission(ROWIDD),"^",6)
	.q:PERSpare2'="Y"
	.s ROWID="" F  S ROWID=$O(^PMPPermisBusinessi("PERBusUserDr",ROWIDD,userId,ROWID)) Q:ROWID=""  D
	..s PERBusIsEffect=$P(^PMPPermisBusiness(ROWIDD,"E",ROWID),"^",3)
	..q:PERBusIsEffect'="Y"
	..s XQStatus=$P(^PMPDictionary(PERSpare3),"^",2)
	..s ret=XQStatus
	q ret
}

ClassMethod QuanXianGuanLiold() As %String
{
	s ret=""
    s userId=%session.Data("LOGON.USERID")
	S ROWIDD="" F  S ROWIDD=$O(^PMPPermission(ROWIDD)) Q:ROWIDD=""  D
	.S ROWID=$O(^PMPPermisBusinessi("PERBusUserDr",ROWIDD,userId,"")) 
	.i ROWID'=""  s ret=ROWIDD
	q ret
}

ClassMethod LingShi(Input As %String, UserId As %String) As %String
{
	s ret=""
    q:(Input="")||(UserId="")
    S Rowid=$g(^TMPPMP(UserId))
    s data=+$h,time=$p($h,",",2)
    s locid=%session.Data("LOGON.CTLOCID")
    s userId=%session.Data("LOGON.USERID")
    i Rowid'="" d
    .s neirong=$p(^PMPImprovementList(Rowid),"^",34)
    .S Input=neirong_"||"_Input
    .&sql(update sqluser.PMP_ImprovementList set IPML_Status_DR="104",IPML_Standby3=:Input WHERE IPML_Rowid=:Rowid)
    .&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR,IPMD_Remark,IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,"132","104",:Input,:data,:time,:UserId,:locid))
    .S IPRLChildsub=$O(^PMPImprovementRevListi("User",Rowid,userId,""))
    .i IPRLChildsub'=""  d
    ..s $p(^PMPImprovementRevList(Rowid,IPRLChildsub),"^",9)="N"
    ..S $p(^PMPImprovementRevList(Rowid,IPRLChildsub),"^",8)=Input
    S ret="OK"
	q ret
}

ClassMethod Selectbutongguo(UserId As %String) As %String
{
	s ret="1"
    q:(UserId="")
    S ret=$g(^TMPPMP(UserId))
	q ret
}

ClassMethod SelectbutongguoID(Input As %String, UserId As %String) As %String
{
	s ret="1"
	q:(UserId="")||(Input="")
	k ^TMPPMP(UserId)
	S ^TMPPMP(UserId)=Input
	s ret="1"
	q ret
}

ClassMethod FenPei(objUserId As %String, objRowid As %String, userId As %String, BeiZhu As %String) As %String
{
	s ret=""
	q:(objUserId="")||(objRowid="")||(userId="")
	s data=+$h,time=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")
    i objRowid'="" d
    .;s neirong=$p(^PMPImprovementList(objRowid),"^",34)
    .s Status=$p(^PMPImprovementList(objRowid),"^",28)
    .&sql(update sqluser.PMP_ImprovementList set IPML_AssignEngineer_DR=:objUserId WHERE IPML_Rowid=:objRowid)
    .&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR,IPMD_Remark,IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:objRowid,"135",:Status,:BeiZhu,:data,:time,:userId,:locid))
    .s ret="chenggong"
    q ret
}

ClassMethod cunID(Rowid As %String, Userid As %String) As %String
{
	s ret=""
	q:Rowid=""
	q:Userid=""
	k ^TMPpmpzzp(Userid)
	s ^TMPpmpzzp(Userid)=Rowid
	s ret="1"
	q ret
}

/**
**@Authod shenbo
**@date 2015.1.30
**@Use 设置该需求的第四个备用字段为n  该字段为院长审核 N为需要院长审核
**/
ClassMethod SetYzshN(Rowid As %String) As %String
{
	s ret=""
	q:(Rowid="") ret
	&sql(update sqluser.PMP_ImprovementList set IPML_Standtb4="N" WHERE IPML_Rowid=:Rowid)
    s ret="caozuochenggong"
    q ret
}

/**
**@Authod shenbo
**@date 2015.1.30
**@Use 设置该需求的第四个备用字段为Y  该字段为院长审核 Y为需要院长审核
**/
ClassMethod SetYzshY(Rowid As %String) As %String
{
	s ret=""
	q:(Rowid="") ret
	&sql(update sqluser.PMP_ImprovementList set IPML_President="Y" WHERE IPML_Rowid=:Rowid)
    s ret="OK"
    q ret
}

/**
**@Authod shenbo
**@date 2015.1.30
**@Use 获取该条权限的院长审核标识
**/
ClassMethod GetYzshBs(Rowid As %String) As %String
{
	s ret=""
	q:(Rowid="") ret
	s Standtb4=""
	&sql(select IPML_Standtb4 into :Standtb4 from sqluser.PMP_ImprovementList WHERE IPML_Rowid=:Rowid)
    s ret=Standtb4
    q ret
}

ClassMethod Huoqushujv(Userid As %String) As %String
{
	s ret=""
	q:Userid=""
	s ret=$g(^TMPpmpzzp(Userid))
	k ^TMPpmpzzp(Userid)
	q ret
}

ClassMethod CESHIBUTONGGUOCHULI(Rowid As %String, Userid As %String, Beizhu As %String) As %String
{
	s ret=""
	q:(Rowid="")||(Userid="")||(Beizhu="") ret
	s data=+$h,time=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")
	&sql(update sqluser.PMP_ImprovementList set IPML_Status_DR="106" WHERE IPML_Rowid=:Rowid)
    &sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR,IPMD_Remark,IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,"135","106",:Beizhu,:data,:time,:Userid,:locid))
    s ret="caozuochenggong"
    q ret
}

ClassMethod UpdateXQ(Rowid As %String, Str As %String) As %String
{
	s ret="full"
	q:(Rowid="")||(Str="") ret
	s XQStandby3Str=$p(Str,"||",2)
	s CRSituationStr=$P(Str,"||",1)
	;s status=$p(^PMPImprovementList(Rowid),"^",34)
	s XQStandby3=$p(^PMPImprovementList(Rowid),"^",34)
	s XQSituation=$p(^PMPImprovementList(Rowid),"^",26)
	s IPMLStatusDR=$p(^PMPImprovementList(Rowid),"^",28)
	s data=+$h,time=$p($h,",",2)
	s userId=%session.Data("LOGON.USERID")
	s locid=%session.Data("LOGON.CTLOCID")
	s NewStr="原需求："_XQSituation_"||"_XQStandby3_"$新需求："_Str
	&sql(update sqluser.PMP_ImprovementList set IPML_Standby3=:XQStandby3Str,IPML_Situation=:CRSituationStr,IPML_Status_DR="150",IPML_UpdateType="Y" WHERE IPML_Rowid=:Rowid)
	&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR,IPMD_Remark,IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid,IPMD_Standby4) values (:Rowid,"149","150",:NewStr,:data,:time,:userId,:locid,:IPMLStatusDR))
	s ret="ful"
	q ret
}

ClassMethod QueRenXiuGai(Input As %String) As %String
{
	s ret="XGSHIBAI" 
	q:Input="" ret
	s Rowid=$p(Input,"^",1)
	q:Rowid="" ret
	s neirong=$p(Input,"^",4)
	s Date=+$h,Time=$p($h,",",1)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	s UserId=%session.Data("LOGON.USERID")
	s chid=$o(^PMPImprovementDetaili("Flag",Rowid,"149",""),-1)
	s status=$p(^PMPImprovementDetail(Rowid,chid),"^",18)
	S Reamk=$p(^PMPImprovementDetail(Rowid,chid),"^",9)
	s stion=$p($p(Reamk,"$",1),"||",1)
	i stion["原需求：" s stion=$p(stion,"原需求：",2)
	s st3=$p($p(Reamk,"$",1),"||",2)
	i st3["新需求：" s st3=$p(st3,"新需求：",2)
	&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:status,IPML_Situation=:stion,IPML_Standby3=:st3 where IPML_Rowid=:Rowid)
	&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid,IPMD_Remark) values (:Rowid,'149',:status,:Date,:Time,:UserId,:locid,:neirong))
	s ret="XGQUERENN"
	Q ret
}

ClassMethod DaiShenHe(Rowid As %String) As %String
{
	s userId=%session.Data("LOGON.USERID")
	;s userId="4361"
	k ^zzppmpd(userId)
	s ret=""
	s IPRLChildsub="" F  S IPRLChildsub=$O(^PMPImprovementRevList(Rowid,IPRLChildsub)) Q:IPRLChildsub=""  D
	.S IPRLType=$p(^PMPImprovementRevList(Rowid,IPRLChildsub),"^",6)
	.s IPRLUser=$p(^PMPImprovementRevList(Rowid,IPRLChildsub),"^",2)
	.i IPRLUser'="" s ^zzppmpd(userId,Rowid,IPRLUser)=IPRLType
	q $g(^zzppmpd)
}

Query QXmingxi(Rowid As %String, Userid As %String = "") As %Query(ROWSPEC = "QXJB:%String,QXMS:%String,QXYH:%String,QXGXRQ:%String,QXGXSJ:%String,id:%String,LocLX:%String")
{
}

ClassMethod QXmingxiExecute(ByRef qHandle As %Binary, Rowid As %String, Userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1,F=$j
	k zzppmpuser(F)
	s userId=%session.Data("LOGON.USERID")
	s locid=%session.Data("LOGON.CTLOCID")
	S PERBusChildsub="" f  s PERBusChildsub=$o(^PMPPermisBusiness(Rowid,"E",PERBusChildsub)) q:PERBusChildsub=""  d
	.s PERBusUserDR=$p(^PMPPermisBusiness(Rowid,"E",PERBusChildsub),"^",4)
	.q:PERBusUserDR=""
	.Q:$P(^PMPPermisBusiness(Rowid,"E",PERBusChildsub),"^",3)'="Y"
	.q:(Userid'="")&(Userid'=PERBusUserDR)
	.;q:$d(zzppmpuser(F,Rowid,PERBusUserDR))
	.s zzppmpuser(F,Rowid,PERBusUserDR)=""
	.s QXYH=$p(^SSU("SSUSR",PERBusUserDR),"^",2)
	.s ^zhmtemp("123")=Userid_","_PERBusUserDR
	.s QXJB=$P(^PMPPermission(Rowid),"^",3)
	.S QXMS=$P(^PMPPermission(Rowid),"^",2)
	.S QXGXRQ=$P(^PMPPermisBusiness(Rowid,"E",PERBusChildsub),"^",1)
	.i QXGXRQ'="" s QXGXRQ=$zd(QXGXRQ,3)
	.s QXGXSJ=$P(^PMPPermisBusiness(Rowid,"E",PERBusChildsub),"^",2)
	.i QXGXSJ'="" s QXGXSJ=$zt(QXGXSJ,1)
	.s LocLX=$P(^PMPPermisBusiness(Rowid,"E",PERBusChildsub),"^",5)
	.i LocLX'="" s LocLX=$p(^RBC("DEP",LocLX),"^",2)
	.s id=Rowid_"||"_PERBusChildsub_"||"_QXYH
	.d OutputRowpmp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowpmp    
	set Data=$lb(QXJB,QXMS,QXYH,QXGXRQ,QXGXSJ,id,LocLX)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QXmingxiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QXmingxiExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QXmingxiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QXmingxiExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod insertPermisBusiness(Input As %String) As %String
{
	s ^zzp("crshi")=Input
	s ret="1006",type=""
	q:Input="" ret
	s rowid=$p(Input,"^",1)
	S User=$P(Input,"^",2)
	S LocLx=$p(Input,"^",3)
	s date=+$h,time=$p($h,",",2)
	S PERBusChildsub="" f  s PERBusChildsub=$o(^PMPPermisBusinessi("PERBusUserDr",rowid,User,PERBusChildsub)) q:PERBusChildsub=""  d
	.s PERBusSpare1=$P(^PMPPermisBusiness(rowid,"E",PERBusChildsub),"^",5)
	.i LocLx=PERBusSpare1  d
	..s type="1"
	..s ret="1003"
	..s $P(^PMPPermisBusiness(rowid,"E",PERBusChildsub),"^",3)="Y"
	q:type="1" ret
	&sql(insert into sqluser.PMP_PermisBusiness (PMP_Permission_ParRef,PERBus_User_DR,PERBus_IsEffect,PERBus_Date,PERBus_Time,PERBus_Spare1) values (:rowid,:User,'Y',:date,:time,:LocLx))
	s ret="1005"
	q ret
}

ClassMethod DeletePermisBusiness(Input As %String, type As %String) As %String
{
	s ret="1007" 
	q:(Input="")||(type="") ret
	s rowid=$p(Input,"^",1)
	S User=$P(Input,"^",2)
	S LocLx=$p(Input,"^",3)
	s date=+$h,time=$p($h,",",2)
	i type="ok" d
	.S PERBusChildsub="" f  s PERBusChildsub=$o(^PMPPermisBusinessi("PERBusUserDr",rowid,User,PERBusChildsub)) q:PERBusChildsub=""  d
	..s $P(^PMPPermisBusiness(rowid,"E",PERBusChildsub),"^",3)="N"
	..s ret="1008"
	i type="no" d
	.S PERBusChildsub="" f  s PERBusChildsub=$o(^PMPPermisBusinessi("PERBusUserDr",rowid,User,PERBusChildsub)) q:PERBusChildsub=""  d
	..s PERBusSpare1=$P(^PMPPermisBusiness(rowid,"E",PERBusChildsub),"^",5)
	..q:LocLX'=PERBusSpare1
	..s $P(^PMPPermisBusiness(rowid,"E",PERBusChildsub),"^",3)="N"
	..s ret="1009"
	q ret
}

ClassMethod UpdatePermisBusiness(Input As %String) As %String
{
	s ret="1011"
	q:Input="" ret
	s rowid=$p(Input,"^",1)
	S User=$P(Input,"^",2)
	S LocLx=$p(Input,"^",3)
	s date=+$h,time=$p($h,",",2)
    s ycys=$p(Input,"^",4)
	S Chid=$P(ycys,"||",2)
	s $P(^PMPPermisBusiness(rowid,"E",Chid),"^",5)=LocLx
	s $P(^PMPPermisBusiness(rowid,"E",Chid),"^",4)=User
	S $P(^PMPPermisBusiness(rowid,"E",Chid),"^",1)=date
	S $P(^PMPPermisBusiness(rowid,"E",Chid),"^",2)=time
	Q ret="1012"
}

ClassMethod XYSH(rowid As %String, userid As %String, ID As %String) As %String
{
	s ret=""
	q:(rowid="")||(userid="") ret
	s $p(^PMPImprovementList(rowid),"^",42)=ID
	Q ret="1"
}

/**
*@分配需求到其他科室、
*@Author shenbo
**/
/// w ##class(web.PMP.ImproventFindShenhe).FenPeiBks()
ClassMethod FenPeiBks(objUserId As %String, objUserId1 As %String, rowid As %String, userId As %String, BeiZhu As %String) As %String
{
	s ^zhm("FenPeiBks")=objUserId_","_objUserId1_","_rowid_","_userId_","_BeiZhu
	s ret=""
	q:(objUserId="")||(objUserId1="")||(userId="")
	s data=+$h,time=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")
	;s rowid=$o(^PMPImprovementListi("Code",objRowid,""))
    i rowid'="" d
    .;s neirong=$p(^PMPImprovementList(objRowid),"^",34)
    .s Status=$p(^PMPImprovementList(rowid),"^",28)
    .&sql(update sqluser.PMP_ImprovementList set IPML_Standtb2=:objUserId,IPML_Standtb3=:objUserId1 WHERE IPML_Rowid=:rowid)
    .&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR,IPMD_Remark,IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:rowid,:locid,:Status,:BeiZhu,:data,:time,:userId,:locid))
    .s ret="chenggong"
    q ret
}

//shenbo

/// 获取必须审核标识（Y 必须审核，N非必须审核，F需求分配，E院长审核）
/// w ##class(web.PMP.ImproventFindShenhe).getStutsPer()
ClassMethod getStutsPer() As %String
{
	s ret=""
    s userId=%session.Data("LOGON.USERID")
	s ROWIDD="" F  S ROWIDD=$O(^PMPPermission(ROWIDD)) Q:ROWIDD=""  D
	.s PERLevel=$p(^PMPPermission(ROWIDD),"^",3)
	.s PERSpare2=$p(^PMPPermission(ROWIDD),"^",5)
	.s PERSpare3=$p(^PMPPermission(ROWIDD),"^",6)
	.q:PERSpare2'="Y"
	.s ROWID="" F  S ROWID=$O(^PMPPermisBusinessi("PERBusUserDr",ROWIDD,userId,ROWID)) Q:ROWID=""  D
	..s PERBusIsEffect=$P(^PMPPermisBusiness(ROWIDD,"E",ROWID),"^",3)
	..q:PERBusIsEffect'="Y"
	..s StutsPer=$P(^PMPPermission(ROWIDD),"^",8)
	..s ret=StutsPer
	q ret
}

/// 增加科室取值
/// 通过session userid 查找科室是否存在
/// w ##class(web.PMP.ImproventFindShenhe).IsDepartAudit("3174")
ClassMethod IsDepartAudit(userid As %String) As %String
{
 Q:userid="" ""
 s id=""
 f  s id=$o(^DepartAuditUser(0, "DepartUser",userid,id)) Q:(id="")  d
 .s loc=$p(^DepartAudit(id),"^",1)
 .s effect=$p(^DepartAudit(id),"^",3)
 .q:$p(^DepartAudit(id),"^",4)'="L"
 .Q:effect'="Y"
 Q $g(loc)
}

/// 获取需要科室审核的列表
/// 
/// w ##class(web.PMP.ImproventFindShenhe).NedIsDepartAudit()
ClassMethod NedIsDepartAudit() As %String
{
 s ret=""
 s id="0"
 f  s id=$o(^DepartAudit(id)) Q:(id="")  d
 .s loc=$p(^DepartAudit(id),"^",1)
 .s effect=$p(^DepartAudit(id),"^",3)
 .q:$p(^DepartAudit(id),"^",4)'="L"
 .Q:effect'="Y"
 .i ret'="" s ret=$g(ret)_"^"_loc
 .i ret="" s ret=loc
 Q $g(ret)
}

Storage Default
{
<Data name="ImproventFindShenheDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.PMP.ImproventFindShenheD</DataLocation>
<DefaultData>ImproventFindShenheDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.PMP.ImproventFindShenheD</IdLocation>
<IndexLocation>^web.PMP.ImproventFindShenheI</IndexLocation>
<StreamLocation>^web.PMP.ImproventFindShenheS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
