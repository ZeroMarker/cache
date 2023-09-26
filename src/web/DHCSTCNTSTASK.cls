Import sqluser

Class web.DHCSTCNTSTASK Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 抗菌药点评方案
/// 每月有开抗菌药资质医生25%,每医生抽50张处方
/// Input:doccent - 医生比例,prescnum - 处方张数,管制分类
/// 
ClassMethod GetAntimicrobialData(sdate, edate, doccent, prescnum, posionstr, otherstr) As %String
{
	
	s formaxnum=100000
	s doccnt=0 //医生数
	s indexcode="PAADM_AdmDate"  //门诊
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s curdate=+$h
	s yesterday=curdate-1
	s tmpday=##class(websys.Conversions).DateLogicalToHtml(yesterday) //$zd(yesterday,"3")
	s endnum=$p(tmpday,"-",3)-1
	s enddate=yesterday
	s stdate=enddate-endnum
	
	i sdate'="" s stdate=sdate
	i edate'="" s enddate=edate
	s prefix=$p(otherstr,"^",1)	
    s wayid=$o(^DHCPCWAY(0,"Code",prefix,""),-1)	//获取点评方式代码
    s resaveflag=""
    s:wayid'="" resaveflag=$p(^DHCPCWAY(wayid),"^",5)	//重复抽取标记
	
	s h=0 //本次查询记录数
	f date=stdate:1:enddate d
	.s phl=""
	.f  s phl=$o(^DHCPHDISPi("FYDATE",date,phl)) q:(phl="")  d
	..s phd=""
	..f  s phd=$o(^DHCPHDISPi("FYDATE",date,phl,phd)) q:(phd="")  d
	...s prescno=$p(^DHCPHDISP(phd,2),"^",1)	//处方号
    ...q:prescno=""
    ...s ord=$o(^OEORD(0,"PrescNo",prescno,""),-1)
    ...q:ord=""
    ...s adm=$p(^OEORD(ord),"^",1)
	...s admtype=$p(^PAADM(adm),"^",2)
	...q:admtype="I"
	...s papmi=$p(^PAADM(adm),"^",1)
    ...q:##Class(web.DHCSTCNTSMAIN).ChkPrescDisp(prescno)'="1"
	...s chl=$o(^OEORD(0,"PrescNo",prescno,ord,"")) 
	...q:chl=""
	...s orditem=ord_"||"_chl
	...q:##class(web.DHCSTCNTSMAIN).GetOrdItmStatus(orditem)=0
	...q:($D(^DHCPHCNTS(0,"OrdItem",orditem))&&(resaveflag'="Y")) //已生成过点评单
	...s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	...s itmmastid=$p(arcimid,"||",1)
	...s itmmastver=$p(arcimid,"||",2)
	...s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
	...q:inci=""  //医嘱名称
	...q:##class(web.DHCSTCNTSMAIN).GetAntibioticFlag(orditem)=0
	...q:##class(web.DHCSTCNTSMAIN).ChkItmByPrescNo(prescno,"",posionstr)=0
	...s orddeptdr=$p(^OEORD(ord,"I",chl,1),"^",3)
	...s orddept=$p(^CTLOC(orddeptdr),"^",2)
	...i $f(orddept,"-") s orddept=$p(orddept,"-",2)
	...s docdr=$p($g(^OEORD(ord,"I",chl,7)),"^",1) //医生
	...q:docdr=""
	...;s docflag=##class(web.DHCDocOrderCommon).GetDoctorTypePoisonStr(DoctorID,PAAdmType)
	...//每个医生的处方集合
	...i '$d(^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Presc",prescno)) d
	....s docmaxnum=+$o(^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doc",docdr,""),-1)+1 //医生最大处方数量
	....s ^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doc",docdr,docmaxnum)=prescno
	....s ^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Presc",prescno)=""
	...//医生的集合
	...i '$d(^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doctor",docdr)) d
	....s ^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doctor",docdr)=""
	....s doccnt=doccnt+1
	...s h=h+1
	q:h=0 0
	
	//取得医生处方数大于50的集合
	s h=0
	s docdr=""
	f  s docdr=$o(^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doctor",docdr)) q:docdr=""  d
	.s docmaxnum=$o(^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doc",docdr,""),-1)
	.q:docmaxnum<prescnum
	.s h=h+1
	.s ^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"DocItm",h,docdr)=""
	k ^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doctor")
	q:h=0 0
	
	///取医生集合的随机数
	s doccnt=$p((doccnt*doccent)/100,".") //随机医生总数
	i doccnt<1 s doccnt=1
	q:h<doccnt 0		//满足抽取处方张数的医生数小于抽取的百分比
	
	s docmaxcnt=$o(^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"DocItm",""),-1)	//满足抽取张数的医生总数
	s rcnt=##class(web.DHCSTCNTSMAIN).GetRandNumList(pid,docmaxcnt,formaxnum,doccnt)
	q:rcnt=0 0
	s randnum=""
	f  s randnum=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetRandNum",pid,"RandNum",randnum)) q:randnum=""  d
	.s docdr=$o(^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"DocItm",randnum,""))
	.s ^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"RandDoc",docdr)=""
	
	///取每个医生的处方集合的随机数
	s h=0
	s docdr=""
	f  s docdr=$o(^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"RandDoc",docdr)) q:docdr=""  d
	.s docmaxnum=$o(^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doc",docdr,""),-1)
	.s rcnt=##class(web.DHCSTCNTSMAIN).GetRandNumList(pid,docmaxnum,formaxnum,prescnum)
	.s randnum=""
	.f  s randnum=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetRandNum",pid,"RandNum",randnum)) q:randnum=""  d
	..s prescno=^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doc",docdr,randnum)
    ..s h=h+1
    ..s ord=$o(^OEORD(0,"PrescNo",prescno,""))
    ..s itm=$o(^OEORD(0,"PrescNo",prescno,ord,""))
    ..s orditm=ord_"||"_itm
    ..s adm=$p(^OEORD(ord),"^",1)
	..s ^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","ForSaveData",pid,h)=prescno_"^"_orditm_"^"_adm
	..

	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetRandNum",pid)
	k ^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid)
	 
	q pid
}

ClassMethod SaveData(stdate, enddate, prefix, User, ParStr, logonloc) As %String
{
	
    s doccent=$p(ParStr,"^",3)
	s prescnum=$p(ParStr,"^",4)
    s posionstr=$p(ParStr,"^",5)
    s otherstr=prefix
	s Note="日期范围:"_stdate_"至"_enddate
    s Note=Note_","_"医生比例:"_doccent_","_"处方数:"_prescnum
    s pid=..GetAntimicrobialData(stdate,enddate,doccent,prescnum,posionstr,otherstr)
    q:pid=0 -4_"^"_"没有抽取到符合条件的处方,请更换规则后再试!" 
    s Prefix=prefix 
    s logonhosp=$p(^CTLOC(logonloc),"^",22)
    
    s waycode=$p(ParStr,"^",6)		//点评方式代码
    s wayid=$o(^DHCPCWAY(0,"Code",waycode,""),-1)	//获取点评方式代码
    s resaveflag=""
    s:wayid'="" resaveflag=$p(^DHCPCWAY(wayid),"^",5)	//重复抽取标记
    
	tstart
	s main=##class(web.DHCSTCNTSMAIN).SaveCommentNo(User,Note,Prefix,logonhosp)
	i +main'>0 d exitsave
	q:+main'>0 -1_"^"_"保存主表失败"
	s itm=##class(web.DHCSTCNTSMAIN).SaveCommentItm(pid,main,resaveflag)
	i +itm'=0 d exitsave
	q:+itm=-10 -2_"^"_"有部分医嘱不能重复生成点评单,请重新查询后再试!"
	q:+itm'=0 -3_"^"_"保存子表失败"
	tcommit
	s commentno=$p(^DHCPHCNTS(main),"^",1)
	q 0_"^"_commentno
exitsave
    tro
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","ForSaveData",pid)
    q
}

/// 成人处方点评方案
/// 每月16号抽取 大于等于  16岁的成人处方,100张,排除儿科,急诊,高干,传染,中药等科室
/// Input:开始日期,结束日期,排除科室,处方张数
ClassMethod GetAdultData(ParStr) As %String
{
	
	s stdate=$p(ParStr,"^",1)
	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s enddate=$p(ParStr,"^",2)
	s enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	s prescnum=$p(ParStr,"^",3)
    s limtdocstr=$p(ParStr,"^",4)
    s poisonstr=$p(ParStr,"^",5)
    s optype=$p(ParStr,"^",6)
    s waycode=$p(ParStr,"^",7)		//点评方式代码
    s wayid=$o(^DHCPCWAY(0,"Code",waycode,""),-1)	//获取点评方式代码
    s resaveflag=""
    s:wayid'="" resaveflag=$p(^DHCPCWAY(wayid),"^",5)	//重复抽取标记
    
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s formaxnum=100000
	s indexcode="PAADM_AdmDate"  //门诊
    s h=0 //本次查询记录数
	f date=stdate:1:enddate d
	.s phl=""
	.f  s phl=$o(^DHCPHDISPi("FYDATE",date,phl)) q:(phl="")  d
	..s phd=""
	..f  s phd=$o(^DHCPHDISPi("FYDATE",date,phl,phd)) q:(phd="")  d
    ...s prescno=$p(^DHCPHDISP(phd,2),"^",1)	//处方号
    ...q:prescno=""
    ...s ord=$o(^OEORD(0,"PrescNo",prescno,""),-1)
    ...q:ord=""
    ...s adm=$p(^OEORD(ord),"^",1)	//就诊id
	...s admtype=$p(^PAADM(adm),"^",2)
	...q:(optype="1")&(admtype'="O")
	...q:(optype="2")&(admtype'="E")
	...q:admtype="I"  //只考虑门诊
	...s papmi=$p(^PAADM(adm),"^",1)
	...s patage=##class(web.DHCSTKUTIL).GetAgeNum(papmi)  ;年龄 
	...q:patage<16 
    ...q:##Class(web.DHCSTCNTSMAIN).ChkPrescDisp(prescno)'="1"
	...s chl=$o(^OEORD(0,"PrescNo",prescno,ord,"")) 
	...q:chl=""
	...s orditem=ord_"||"_chl
	...q:##class(web.DHCSTCNTSMAIN).GetOrdItmStatus(orditem)=0
	...q:($D(^DHCPHCNTS(0,"OrdItem",orditem))&&(resaveflag'="Y")) //已生成过点评单
	...s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	...s itmmastid=$p(arcimid,"||",1)
	...s itmmastver=$p(arcimid,"||",2)
	...s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
	...q:inci=""  //医嘱名称
	...q:##class(web.DHCSTCNTSMAIN).ChkItmByPrescNo(prescno,"",poisonstr)=0
	...s orddeptdr=$p(^OEORD(ord,"I",chl,1),"^",3)
	...s orddept=$p(^CTLOC(orddeptdr),"^",2)
	...i $f(orddept,"-") s orddept=$p(orddept,"-",2)
	...s docdr=$p($g(^OEORD(ord,"I",chl,7)),"^",1) //医生
	...q:docdr=""
	...s limitloc=##class(web.DHCSTCNTSMAIN).LimitLoc(limtdocstr,orddeptdr)
	...q:(limitloc=0)&(limtdocstr'="")
	...s h=h+1
	...s ^TMP("dhcpha","DHCSTCNTSTASK","GetAdultData",pid,"PrescNo",h)=prescno_"^"_orditem_"^"_adm
	q:h=0 0
	i prescnum'<(h*0.8) q -100 // 20170221
	s rcnt=##class(web.DHCSTCNTSMAIN).GetRandNumList(pid,h,formaxnum,prescnum)
	q:rcnt=0 0
	s h=0
	s randnum=""
	f  s randnum=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetRandNum",pid,"RandNum",randnum)) q:randnum=""  d
	.s data=^TMP("dhcpha","DHCSTCNTSTASK","GetAdultData",pid,"PrescNo",randnum)
	.s h=h+1
	.s ^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","ForSaveData",pid,h)=data
	
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetRandNum",pid)
	k ^TMP("dhcpha","DHCSTCNTSTASK","GetAdultData",pid)
	q pid
}

/// 保存成人处方点评数据
ClassMethod SaveAdultData(User, ParStr, logonloc) As %String
{
	s prefix="C"
	s StartDate=$p(ParStr,"^",1)
	s EndDate=$p(ParStr,"^",2)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s Note="日期范围:"_StartDate_"至"_EndDate
    s Note=Note_","_"处方数:"_$p(ParStr,"^",3) 
    s pid=..GetAdultData(ParStr)
    q:pid<0 -100_"^"_"随机数超过当前可抽取处方总数的80%，建议调整随机数!"
    q:pid=0 -4_"^"_"没有抽取到符合条件的处方,请更换规则后再试!" 
    s Prefix=prefix
    s logonhosp=$p(^CTLOC(logonloc),"^",22) 
    
    s waycode=$p(ParStr,"^",7)		//点评方式代码
    s wayid=$o(^DHCPCWAY(0,"Code",waycode,""),-1)	//获取点评方式代码
    s resaveflag=""
    s:wayid'="" resaveflag=$p(^DHCPCWAY(wayid),"^",5)	//重复抽取标记
    
	tstart
	s main=##class(web.DHCSTCNTSMAIN).SaveCommentNo(User,Note,Prefix,logonhosp)
	i +main'>0 d exitsave
	q:+main'>0 -1_"^"_"保存主表失败"
	s itm=##class(web.DHCSTCNTSMAIN).SaveCommentItm(pid,main,resaveflag)
	i +itm'=0 d exitsave
	q:+itm=-10 -2_"^"_"有部分医嘱不能重复生成点评单,请重新查询后再试!"
	q:+itm'=0 -3_"^"_"保存子表失败"
	tcommit
	s commentno=$p(^DHCPHCNTS(main),"^",1)
	q 0_"^"_commentno
exitsave
    tro
    k ^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","ForSaveData",pid)
    q
}

// s a="s b=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()"

// x b

ClassMethod SaveSysTask(User, ParStr, LogonLoc) As %String
{
	
	k PLIST
	s PLIST(2)=+$h
	s PLIST(3)=$p($h,",",2)
	s PLIST(4)=User
	s PLIST(5)="##class(web.DHCSTCNTSMAIN).SaveCommentData("""_User_""","""_ParStr_""","""_LogonLoc_""")"
	s PLIST(6)="N"
	&sql(INSERT INTO DHC_PHSysTask VALUES :PLIST())
	q:SQLCODE'=0 -1
 	q +$g(%ROWID)
}

/// ##class(web.DHCSTCNTSMAIN).SaveKCommentData(User,ParStr,logonloc)
ClassMethod SaveKSysTask(User, ParStr, LogonLoc) As %String
{
	
	k PLIST
	s PLIST(2)=+$h
	s PLIST(3)=$p($h,",",2)
	s PLIST(4)=User
	s PLIST(5)="##class(web.DHCSTCNTSMAIN).SaveKCommentData("""_User_""","""_ParStr_""","""_LogonLoc_""")"
	s PLIST(6)="N"
	&sql(INSERT INTO DHC_PHSysTask VALUES :PLIST())
	q:SQLCODE'=0 -1
 	q +$g(%ROWID)
}

/// 保存系统任务(住院)
/// ##class(web.DHCSTCNTSIPDATA).SaveIPCommentData(ParStr,User,logonloc)
ClassMethod SaveIPSysTask(User, ParStr, LogonLoc) As %String
{
	
	k PLIST
	s PLIST(2)=+$h
	s PLIST(3)=$p($h,",",2)
	s PLIST(4)=User
	s PLIST(5)="##class(web.DHCSTCNTSIPDATA).SaveIPCommentData("""_ParStr_""","""_User_""","""_LogonLoc_""")"
	s PLIST(6)="N"
	&sql(INSERT INTO DHC_PHSysTask VALUES :PLIST())
	q:SQLCODE'=0 -1
 	q +$g(%ROWID)
}

/// 查询日期范围内的瓶签单号
/// w ##class(web.DHCSTCNTSTASK).QuerySysTaskDs("2014-01-22^2018-05-22",0,200)
ClassMethod QuerySysTaskDs(Input, StPage, Limit) As %String
{
	s endpage=StPage+Limit  //结束行
	s stpage=StPage+1 //开始行
	s stdate=$p(Input,"^",1)
	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
    s enddate=$p(Input,"^",2)
	s enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
   
    s h=0
    s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
    f date=stdate:1:enddate d
    .s tak=""
    .f  s tak=$o(^DHCPHSYSTASK(0,"Date",date,tak)) q:tak=""  d
    ..s taskdate=$p(^DHCPHSYSTASK(tak),"^",1)
    ..s tasktime=$p(^DHCPHSYSTASK(tak),"^",2)
	..s taskuser=$p(^DHCPHSYSTASK(tak),"^",3)
	..s taskuser=$p($g(^SSU("SSUSR",taskuser)),"^",2)
    ..s taskdesc=$p(^DHCPHSYSTASK(tak),"^",4)
    ..s taskactive=$p(^DHCPHSYSTASK(tak),"^",5)
    ..s taskpno=$p(^DHCPHSYSTASK(tak),"^",6)
    ..s taskrowid=tak
    ..s data=taskdate_"^"_tasktime_"^"_taskuser_"^"_taskdesc_"^"_taskactive_"^"_taskrowid_"^"_taskpno
    ..s h=h+1
 	..s ^TMP("dhcpha","DHCSTCNTSTASK","QuerySysTaskDs",pid,"Index",h)=data
   
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
  	s h=0
 	s index=""
 	f  s index=$o(^TMP("dhcpha","DHCSTCNTSTASK","QuerySysTaskDs",pid,"Index",index)) q:index=""  d
 	.s data=^TMP("dhcpha","DHCSTCNTSTASK","QuerySysTaskDs",pid,"Index",index)
 	.s taskdate=$p(data,"^",1)
 	.s taskdate=##class(websys.Conversions).DateLogicalToHtml(taskdate) //$zd(taskdate,3)
 	.s tasktime=$p(data,"^",2)
 	.s tasktime=##class(websys.Conversions).TimeLogicalToHtml(tasktime)
 	.s taskuser=$p(data,"^",3)
 	.s taskdesc=$p(data,"^",4)
 	.s taskdesc=$tr(taskdesc,"!","^")
 	.s taskactive=$p(data,"^",5)
 	.s taskrowid=$p(data,"^",6)
 	.s pcntsno=$p(data,"^",7)
 	.s h=h+1
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s taskdate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("taskdate",taskdate)
    .s tasktime=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("tasktime",tasktime)
	.s taskuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("taskuser",taskuser)
	.s taskdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("taskdesc",taskdesc)
	.s taskactive=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("taskactive",taskactive)
	.s pcntsno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pcntsno",pcntsno)
	.s taskrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("taskrowid",taskrowid)
	.
	.s tmpstr=taskdate_tasktime_taskuser_taskdesc_taskactive_pcntsno_taskrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSTASK","QuerySysTaskDs",pid)
	q ""
}

/// 启用/停用任务
ClassMethod UpdTask(taskId) As %String
{
	s taskactive=$p(^DHCPHSYSTASK(taskId),"^",5)
	i taskactive="Y" s active="N"
	e  s active="Y"
	&sql(update DHC_PHSysTask set PHSTK_Active=:active where PHSTK_RowId=:taskId )
	q:SQLCODE'=0 -1
 	q 0
}

}
