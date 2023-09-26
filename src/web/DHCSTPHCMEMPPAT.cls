Import sqluser

/// 临床药学管理
/// clinical pharmacy manage
/// 重点患者列表
Class web.DHCSTPHCMEMPPAT Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 查询药品列表   bianshuai 2014-09-22 修改
/// w ##class(web.DHCSTPHCMEMPPAT).QueryInHosPatList("30","1","^199")
ClassMethod QueryInHosPatList(rows, page, input) As %String
{
        s empflag=$p(input,"^",1)
        s LocID=$p(input,"^",2)
        s wardID=$p(input,"^",3)
        s InPatNo=$p(input,"^",4)
		s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行
	    s h=0
		///取最近一次就诊记录
		If (wardID="")&(InPatNo'="") D
		.s papmi=$o(^PAPERi("PAPMI_PatNo",InPatNo,""))
		.q:papmi=""
		.s AdmDr=$o(^PAPERdr(papmi,"ADM","I",""),-1)
		.q:AdmDr=""
		.//S wardID=$p(^PAADM(AdmDr),"^",70)
		.d getPatInfo
		E   d
		
		.i LocID'=""  D
		..s wardID=""
		..f  s wardID=$o(^PAWARD(0,"WARD_LocationDR",LocID,wardID)) Q:wardID=""  D
		...s curRoomDr=""
		...f  s curRoomDr=$o(^PAADMi("CurrWard",wardID,curRoomDr)) q:curRoomDr=""  d
		....s AdmDr=""
		....f  s AdmDr=$o(^PAADMi("CurrWard",wardID,curRoomDr,AdmDr)) q:AdmDr=""  d
	    .....s patVisit=$p($g(^PAADM(AdmDr)),"^",20)
        .....q:patVisit'="A"
		.....d getPatInfo
		.E  D
		..s curRoomDr=""
		..f  s curRoomDr=$o(^PAADMi("CurrWard",wardID,curRoomDr)) q:curRoomDr=""  d
		...s AdmDr=""
		...f  s AdmDr=$o(^PAADMi("CurrWard",wardID,curRoomDr,AdmDr)) q:AdmDr=""  d
	    ....s patVisit=$p($g(^PAADM(AdmDr)),"^",20)
        ....q:patVisit'="A"
		....d getPatInfo
		
		q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
		
		s maxrow=h
		i endpage>maxrow s endpage=maxrow
		s count=0
	    s h=""
	    f  s h=$o(^TMP("DHCST","DHCSTPHCMEMPPAT","QueryInHosPatList",pid,h)) q:h=""  d
	    .s data=^TMP("DHCST","DHCSTPHCMEMPPAT","QueryInHosPatList",pid,h)
	    .s patward=$p(data,"^",1)
	    .i $f(patward,"-") s patward=$p(patward,"-",2)
	    .s patbed=$p(data,"^",2)
	    .s patno=$p(data,"^",3)
	    .s patname=$p(data,"^",4)
	    .s patsex=$p(data,"^",5)
	    .s patage=$p(data,"^",6)
	    .s patheight=$p(data,"^",7)
	    .s patweight=$p(data,"^",8)
	    .s patindate=$p(data,"^",9)
	    .s patdoctor=$p(data,"^",10)
	    .s patempflag=$p(data,"^",11)
	    .s patadm=$p(data,"^",12)
	    .s patloc=$p(data,"^",13)
	    .s patroom=$p(data,"^",14)
	    .s patdiag=$p(data,"^",15)
	    .s mLevel=$p(data,"^",16)     //qunianpeng 2016-08-04
	    .s monLevel=$p(mLevel,"/",1)  //qunianpeng 2016-08-04
	    .s monLevelDesc=$p(mLevel,"/",2)  //qunianpeng 2016-08-04
	    .s PatientID=$p(data,"^",17)
	    .s AdmLocId=$p(data,"^",18)
	    .s SubClassId=$p(data,"^",19)
	    .s WardID=$p(data,"^",20)
	    .s monCount=$p(data,"^",21)
	    .	
	    .s count=count+1
	    .q:count<stpage
	    .q:count>endpage
	    .
	    .s patward=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patward",patward)
	    .s patbed=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patbed",patbed)
	    .s patno=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patno",patno)
	    .s patname=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patname",patname)
	    .s patsex=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patsex",patsex)
	    .s patage=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patage",patage)
	    .s patheight=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patheight",patheight)
	    .s patweight=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patweight",patweight)
	    .s patindate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patindate",patindate)
	    .s patdoctor=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patdoctor",patdoctor)
	    .s patempflag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patempflag",patempflag)
		.s patadm=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patadm",patadm)
		.s patloc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patloc",patloc)
		.s patroom=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patroom",patroom)
		.s monLevel=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("monLevel",monLevel)
		.s monLevelDesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("monLevelDesc",monLevelDesc)  //qunianpeng 2016-08-04
		.s PatientID=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatientID",PatientID)
		.s AdmLocID=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("AdmLocID",AdmLocId)
		.s monSubCId=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("monSubCId",SubClassId)
		.s WardID=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("WardID",WardID)
		.s monCount=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("monCount",monCount)
		.s patdiag=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("patdiag",patdiag)
		.
		.;s tmpstr=patward_patbed_patno_patname_patsex_patage_patheight_patweight_patindate_patdoctor_patempflag_patadm_patloc_patroom_monLevel_PatientID_AdmLocID_monSubCId_WardID_monCount_patdiag
		.s tmpstr=patward_patbed_patno_patname_patsex_patage_patheight_patweight_patindate_patdoctor_patempflag_patadm_patloc_patroom_monLevel_monLevelDesc_PatientID_AdmLocID_monSubCId_WardID_monCount_patdiag //qunianpeng 2016-08-04
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.
	    .i count=stpage w startString
	    .i count<endpage w firstrow
	    .i count=endpage w lastrow
		.
	 
		k ^TMP("DHCST","DHCSTPHCMEMPPAT","QueryInHosPatList",pid)
	    
	    q ""
getPatInfo
	s admdate=$p(^PAADM(AdmDr),"^",6) //就诊日期
	s admtime=$p(^PAADM(AdmDr),"^",7) //就诊时间
	i admdate'="" s admdate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(admdate)  ;$zd(admdate,3)
	i admtime'="" s admtime=$zt(admtime,1)
	s admdate=admdate //_" "_admtime
	s admward=""
	s admwarddr=$p(^PAADM(AdmDr),"^",70)  //病区
	
	i admwarddr'="" s admward=$p(^PAWARD(admwarddr),"^",2)
	S bedid=$p(^PAADM(AdmDr),"^",73) //床号
    I bedid="" S AdmBed=""
    E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	s admbed=""
	s papmi=$p(^PAADM(AdmDr),"^",1)
    s patname=$p(^PAPER(papmi,"ALL"),"^",1)
    s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
    q:(InPatNo'="")&(InPatNo'=patno)
	s sex=$p(^PAPER(papmi,"ALL"),"^",7 ) ;姓别
    s patsex=$p(^CT("SEX",sex),"^",2)
    s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
    s patage=##class(PHA.FACE.IN.Com).GetAge(papmi,AdmDr)  ;年龄
    s diag=##class(PHA.FACE.IN.Com).GetAdmDiagDesc(AdmDr) //lbb 2021-09-29 根据就诊号取结构化诊断 ##class(PHA.COM.Order).MrDiagnose(AdmDr,",")
    ;s diag=$Replace(diag,"'","")
    s patW=##class(PHA.COM.Order).PatWeight(AdmDr)
    s patH=##class(PHA.COM.Order).PatHeight(AdmDr)
    s patempflag=..GetEmpFlagByAdm(AdmDr)
    q:(empflag="Y")&(patempflag'="Y")
    s AdmLoc=""
    s AdmLocId=$p(^PAADM(AdmDr),"^",4) //科室
	s:AdmLocId'="" AdmLoc=$p(^CTLOC(AdmLocId),"^",2)  //qunianpeng 2017/8/14 新版描述没有拼音码 $p($p(^CTLOC(AdmLocId),"^",2),"-",2) 
	s AdmCurrRoom=$p(^PAADM(AdmDr),"^",69) //房间号
	s:AdmCurrRoom'="" AdmCurrRoom=$p(^PAROOM(AdmCurrRoom),"^",2)
	s AdmDoctor=""
	s AdmDocCodeDR=$p(^PAADM(AdmDr),"^",9) //医生
	s:+AdmDocCodeDR'=0 AdmDoctor=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2)
	s mLevel=..getPatMonLevel(AdmDr) //获取患者监护级别 qunianpeng  2016-08-04
	s monSubClassId=##Class(web.DHCSTPHCMPHARCAREMAIN).getMonSubClass(AdmLocId)
	s monCount=##Class(web.DHCSTPHCMPHARMACYCARE).getPatMonCount("",AdmDr)
	s admward=##class(PHA.FACE.IN.Com).GetTransDesc("User.PACWard","WARDDesc","",admward)
	s patname=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",patname)
	s patsex=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",patsex)
	s patage=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",patage)
	s AdmDoctor=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTCareProv","CTPCPDesc","",AdmDoctor)
	s AdmLoc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLoc","CTLOCDesc","",AdmLoc)
	s diag=##class(PHA.FACE.IN.Com).GetTransDesc("User.MRCICDDx","MRCIDDesc","",diag)
	s data=admward_"^"_AdmBed_"^"_patno_"^"_patname_"^"_patsex_"^"_patage_"^"_patH_"^"_patW_"^"_admdate_"^"_AdmDoctor_"^"_patempflag_"^"_AdmDr_"^"_AdmLoc_"^"_AdmCurrRoom_"^"_diag_"^"_mLevel_"^"_papmi_"^"_AdmLocId_"^"_monSubClassId_"^"_admwarddr_"^"_monCount  //qunianpeng 2016-08-04
	s h=h+1
	s index=admward_"^"_AdmBed_"^"_admdate_"^"_patno_"^"_h
	s ^TMP("DHCST","DHCSTPHCMEMPPAT","QueryInHosPatList",pid,index)=data
}

// lbb   2018/7/20 通过科室id取得科室描述

/// w ##class(web.DHCSTPHCMEMPPAT).GetLocNameByLocID(119)
ClassMethod GetLocNameByLocID(LocID) As %String
{
	s AdmLoc=$p(^CTLOC(LocID),"^",2)	//得到科室描述
	q AdmLoc
}

/// 加入重点关注	
/// w ##class(web.DHCSTPHCMEMPPAT).AddEmpFlag(input)
ClassMethod AddEmpFlag(input) As %String
{
	
	s user=$p(input,"^",1)
	s adm=$p(input,"^",2)
	s result=$p(input,"^",3)
	s type=$p(input,"^",4)
	
	s currdate=$p($h,",",1)
	s currtime=$p($h,",",2)
	//判断是否已存在相同
	s flag="1"
	s main=..GetMFlagByAdm(adm,type)
	s main=+main
	i main'=0 s flag=$p(^DHCPHORDM(main),"^",2)

	q:flag=result 0
    
	q:(main=0)&(result="N") -99 //未关注不能取消 
	
	tstart
	s err=0
	k PLIST
	s PLIST(2)=user
	s PLIST(3)=result
	s PLIST(4)=currdate
	s PLIST(5)=currtime
	s PLIST(10)=type //重点患者
	&sql(INSERT INTO DHC_PHAORDMONITOR  VALUES :PLIST())
	i SQLCODE'=0  tro 
	i SQLCODE'=0 s err=1
	q:err'=0 -2
	s phaomr=+%ROWID
	//
	k PLIST
	s PLIST(0)=phaomr
	s PLIST(5)=+$o(^DHCPHORDM(phaomr,"I",""),-1)+1
	s PLIST(7)=adm
	&sql(INSERT INTO DHC_PHAORDMONITORLIST  VALUES :PLIST())
	i SQLCODE'=0  tro 
	i SQLCODE'=0 s err=1

	q:err'=0 -1
	tcommit
	
	q err
}

/// 通过adm获取是否重点关注标志
ClassMethod GetEmpFlagByAdm(adm) As %String
{
	s main=+..GetMFlagByAdm(adm,"EMP")
	q:main=0 ""
	s flag=$p(^DHCPHORDM(main),"^",2)
	q flag
}

/// 获取监控标志
ClassMethod GetMFlagByAdm(adm, app) As %String
{
	s ret=""
	s main=""
	f  s main=$o(^DHCPHORDM(0,"Adm",adm,main)) q:main=""  d
	.s apptype=$p(^DHCPHORDM(main),"^",9)
	.i apptype=app d
	..s ret=main
	
	q ret
}

/// 保存查房情况
/// w ##Class(web.DHCSTPHCMEMPPAT).SaveAdmRoomLog("查房记录^578^22^Room")
ClassMethod SaveAdmRoomLog(input) As %String
{
	
	s log=$p(input,"^",1)
	s user=$p(input,"^",2)
	s adm=$p(input,"^",3)
	s type=$p(input,"^",4)
	s main=$p(input,"^",5)

	s currdate=$p($h,",",1)
	s currtime=$p($h,",",2)
	
	i main'="" s ret=..UpaAdmRoomLog(input)
	q:main'="" ret

	tstart
	s err=0
	k PLIST
	s PLIST(2)=user
	s PLIST(4)=currdate
	s PLIST(5)=currtime
	s PLIST(7)=log
	s PLIST(10)=type //查房情况
	&sql(INSERT INTO DHC_PHAORDMONITOR  VALUES :PLIST())
	i SQLCODE'=0  tro 
	i SQLCODE'=0 s err=1
	q:err'=0 -2
	s phaomr=+%ROWID
	//
	k PLIST
	s PLIST(0)=phaomr
	s PLIST(5)=+$o(^DHCPHORDM(phaomr,"I",""),-1)+1
	s PLIST(7)=adm
	&sql(INSERT INTO DHC_PHAORDMONITORLIST  VALUES :PLIST())
	i SQLCODE'=0  tro 
	i SQLCODE'=0 s err=1

	q:err'=0 -1
	tcommit
	
	q err
}

/// 更新查房情况
/// w ##class(web.DHCSTPHCMEMPPAT).UpaAdmRoomLog("1111^578^22^Room^77")
ClassMethod UpaAdmRoomLog(input) As %String
{
	
	s log=$p(input,"^",1)
	s user=$p(input,"^",2)
	s adm=$p(input,"^",3)
	s type=$p(input,"^",4)
	s rowid=$p(input,"^",5)

	s currdate=$p($h,",",1)
	s currtime=$p($h,",",2)
	
	&sql(update DHC_PHAORDMONITOR set PHAOM_User_Dr=:user,PHAOM_Date=:currdate,PHAOM_TIME=:currtime
	,PHAOM_PhNote=:log
	where PHAOM_ROWID=:rowid  )
	q SQLCODE
}

/// 获取查房情况列表
/// w ##class(web.DHCSTPHCMEMPPAT).QueryAdmRoomLogList("100","1","22")
ClassMethod QueryAdmRoomLogList(rows, page, input) As %String
{
	
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
		
	s h=0
	s adm=$p(input,"^",1)
	s type="Room"
	s ret=""
	s main=""
	f  s main=$o(^DHCPHORDM(0,"Adm",adm,main)) q:main=""  d
	.s apptype=$p(^DHCPHORDM(main),"^",9)
	.q:apptype'=type
	.s user=$p(^DHCPHORDM(main),"^",1)
	.s user=$p(^SSU("SSUSR",user),"^",2)
	.s date=$p(^DHCPHORDM(main),"^",3)
	.i date'="" s date=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(date) ;$zd(date,3)
	.s time=$p(^DHCPHORDM(main),"^",4)
	.i time'="" s time=$zt(time,1)
	.s date=date_","_time
	.s rowid=main
	.s data=user_"^"_date_"^"_rowid
	.
	.s h=h+1
	.s ^TMP("DHCST","DHCSTPHCMEMPPAT","QueryAdmRoomLogList",pid,h)=data
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMEMPPAT","QueryAdmRoomLogList",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMEMPPAT","QueryAdmRoomLogList",pid,h)
    .s user=$p(data,"^",1)
    .s date=$p(data,"^",2)
    .s rowid=$p(data,"^",3)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s user=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("user",user)
    .s date=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("date",date)
    .s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=user_date_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
 
	k ^TMP("DHCST","DHCSTPHCMEMPPAT","QueryAdmRoomLogList",pid)
    
    q ""
}

/// 获取查房情况列表
/// w ##class(web.DHCSTPHCMEMPPAT).GetAdmRoomLog(input)
ClassMethod GetAdmRoomLog(input) As %String
{
	s main=$p(input,"^",1)
	s note=$p(^DHCPHORDM(main),"^",6)
	q note
}

/// Descript:保存重点患者
ClassMethod saveEmpPat(empPatID As %String, empPatDataList As %String) As %String
{
	//n (empPatID, empPatDataList)
	i empPatID="" d
	.s ret=..insEmpPat(empPatDataList)
	e  d
	.s ret=..updEmpPat(empPatID,empPatDataList)
	q ret
}

/// Descript:插入重点患者记录表
ClassMethod insEmpPat(empPatDataList As %String) As %String
{
	//n (empPatDataList)
	s startDate=$p(empPatDataList,"^",1)   //开始日期
	s:startDate'="" startDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(startDate) ;$zdh(startDate,3)
	s:startDate="" startDate=+$h
	s startTime=$p(empPatDataList,"^",2)   //开始时间
	s:startTime'="" startTime=$zth(startTime_":00",1)
	s:startTime="" startTime=$p($h,",",2)
	s admDr=$p(empPatDataList,"^",3) 	   //病人ADM
	s wardID=$p(^PAADM(admDr),"^",70)      //病区
	s locID=$p(^PAADM(admDr),"^",4)        //科室
	s mLevelID=$p(empPatDataList,"^",4)    //监护级别
	s opUserID=$p(empPatDataList,"^",5)    //操作人
	s remark=$p(empPatDataList,"^",6)      //备注
    s reason=$p(empPatDataList,"^",9)      //原因
    s endDate=$p(empPatDataList,"^",7)   //结束日期
	s:endDate'="" endDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(endDate) ;$zdh(endDate,3)
	s endTime=$p(empPatDataList,"^",8)   //结束时间
	s:endTime'="" endTime=$zth(endTime_":00",1)
	&SQL(Insert Into DHC_PHEmpPat(PHEP_StartDate,PHEP_StartTime,PHEP_Adm_Dr,PHEP_Ward_Dr,PHEP_Dept_Dr,PHEP_ML_DR,PHEP_User_Dr,PHEP_Remark,PHEP_Reason,PHEP_EndDate,PHEP_EndTime)
		 Values(:startDate,:startTime,:admDr,:wardID,:locID,:mLevelID,:opUserID,:remark,:reason,:endDate,:endTime))
	q SQLCODE
}

/// Descript:更新重点患者记录表
ClassMethod updEmpPat(empPatID As %String, empPatDataList As %String) As %String
{
	//n (empPatID,empPatDataList)
	s endDate=$p(empPatDataList,"^",7)   //结束日期
	s:endDate'="" endDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(endDate) ;$zdh(endDate,3)
	s endTime=$p(empPatDataList,"^",8)   //结束时间
	s:endTime'="" endTime=$zth(endTime_":00",1)
	s reason=$p(empPatDataList,"^",9) 	 //原因
	&SQL(update DHC_PHEmpPat set PHEP_EndDate=:endDate,PHEP_EndTime=:endTime,PHEP_Reason=:reason where PHEP_RowID=:empPatID)
	q SQLCODE
}

/// Descript:获取重点患者相关信息
ClassMethod getEmpPatInfo(admDr As %String) As %String
{
	//n (admDr)
	s empPatID=$o(^DHCPHEP(0,"ADMDR",admDr,""),-1)
	q:empPatID="" ""
	//q:$p(^DHCPHEP(empPatID),"^",7)'="" ""
	s enddate=$p(^DHCPHEP(empPatID),"^",7)
	s endtime=$p(^DHCPHEP(empPatID),"^",8)
	q:(enddate'="")&((enddate<+$h)||((enddate=+$h)&(endtime<$p($h,",",2)))) ""
	s startDate=$p(^DHCPHEP(empPatID),"^",1)  //开始日期
	s:startDate'="" startDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(startDate) ;$zd(startDate,3)
	s startTime=$p(^DHCPHEP(empPatID),"^",2)  //开始时间
	s:startTime'="" startTime=$zt(startTime,1)
	s mLevelID=$p(^DHCPHEP(empPatID),"^",6)   //监护级别
	s opUser=""
	s opUserID=$p(^DHCPHEP(empPatID),"^",9)   //操作人
	s:opUserID'="" opUser=$p(^SSU("SSUSR",opUserID),"^",2)
	s remark=$p(^DHCPHEP(empPatID),"^",10)    //备注
	s reason=$p(^DHCPHEP(empPatID),"^",11)    //原因
	s opUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",opUser)
	s remark=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHEmpPat","PHEPRemark","",remark)
	s reason=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHEmpPat","PHEPReason","",reason)
    q empPatID_"^"_startDate_"^"_startTime_"^"_mLevelID_"^"_opUserID_"^"_opUser_"^"_remark_"^"_reason
}

/// Descript:获取患者监护级别
ClassMethod getPatMonLevel(admDr As %String) As %String
{
	//n (admDr)
	s empPatID=$o(^DHCPHEP(0,"ADMDR",admDr,""),-1)
	q:empPatID="" ""
	;q:$p(^DHCPHEP(empPatID),"^",7)'="" ""
	s enddate=$p(^DHCPHEP(empPatID),"^",7)
	s endtime=$p(^DHCPHEP(empPatID),"^",8)
	q:(enddate'="")&((enddate<+$h)||((enddate=+$h)&(endtime<$p($h,",",2)))) ""
	s mLevelID=$p(^DHCPHEP(empPatID),"^",6)   //监护级别ID
	s mLevelDesc=$p(^DHCPHML(mLevelID),"^",2) //监护级别desc  qunianpeng 2016-08-04
	s mLevelDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMonLevel","PHMLDesc","",mLevelDesc)
	s mLevelColor=$p(^DHCPHML(mLevelID),"^",3)
	s mLevel=mLevelID_"/"_mLevelDesc_"@"_mLevelColor
	q mLevel
}

/// 取关联科室
/// w ##class(web.DHCSTPHCMEMPPAT).GetLinkLoc(131)
ClassMethod GetLinkLoc(locDr)
{
	q:locDr="" ""
	s ret="",curDate=+$h
	s chl=0
	f  s chl=$o(^CTLOC(locDr,"LINK",chl)) q:(chl="")||(ret'="")  d
	.s linkLocDr=$p(^CTLOC(locDr,"LINK",chl),"^",1)
	.q:linkLocDr=""
	.s activeDateTo=+$p($g(^CTLOC(linkLocDr)),"^",25)
	.q:(activeDateTo'=0)&&(activeDateTo<curDate)
	.s wardID=$o(^PAWARD(0,"WARD_LocationDR",linkLocDr,""))
	.q:wardID=""
	.s ret=linkLocDr
	q ret
}

}
