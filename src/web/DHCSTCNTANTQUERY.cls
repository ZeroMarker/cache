/// Creator: bianshuai
/// CreateDate: 2015-03-11
/// Descript: 点评查询
Class web.DHCSTCNTANTQUERY Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询住院点评明细内容
ClassMethod QueryInHosCmtList(rows As %String, page As %String, pcntID) As %String
{
	N (rows,page,pcntID)

	s End = page*rows
	s Start=(page-1)*rows+1
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	Q:'$d(^DHCPHCNTS(pcntID)) ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S pcntNo=$p(^DHCPHCNTS(pcntID),"^",1)   //点评单
	S pcntDate=$p(^DHCPHCNTS(pcntID),"^",2) //点评日期
	S:pcntDate'="" pcntDate=$zd(pcntDate,3)
	S pcntTime=$p(^DHCPHCNTS(pcntID),"^",3) //点评时间
	S:pcntTime'="" pcntTime=$zt(pcntTime,2)
	
	S pcntNotes=$p(^DHCPHCNTS(pcntID),"^",4) //点评信息
	S pcntUser=""
	S pcntUserID=$p(^DHCPHCNTS(pcntID),"^",6) //点评人
	S:pcntUserID'="" pcntUser=$p(^SSU("SSUSR",pcntUserID),"^",2)
	
	S Num=0
	S ch=""
	F  S ch=$o(^DHCPHCNTS(pcntID,"I",ch)) q:ch=""  d
	.S pcntItmID=pcntID_"||"_ch
	.S CntRes=$p(^DHCPHCNTS(pcntID,"I",ch),"^",6)
	.i CntRes="Y" s CntRes="合理"
	.i CntRes="N" s CntRes="不合理"
	.S AdmDr=$p(^DHCPHCNTS(pcntID,"I",ch),"^",3)
	.Q:'$d(^PAADM(AdmDr))
	.S Papmi=$p(^PAADM(AdmDr),"^",1)
	.S PatName=$p(^PAPER(Papmi,"ALL"),"^", 1) //姓名
	.S PatSex=""
	.S PatSexID=$p(^PAPER(Papmi,"ALL"),"^",7 ) //姓别
	.S:PatSexID'="" PatSex=$p(^CT("SEX",PatSexID),"^",2)
	.S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
	.S PatAge=##class(web.DHCSTKUTIL).GetAge(Papmi)  //年龄
	.S PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",") //诊断
    .
    .S AdmDate=$p(^PAADM(AdmDr),"^",6)  //就诊日期
	.S AdmTime=$p(^PAADM(AdmDr),"^",7)  //就诊时间
	.I AdmDate'="" S AdmDate=$zd(AdmDate,3)
	.I AdmTime'="" S AdmTime=$zt(AdmTime,2)
	.S AdmDate=AdmDate //_" "_AdmTime
	.S AdmWard=""
	.S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	.I AdmWardDr'="" s AdmWard=$p($p(^PAWARD(AdmWardDr),"^",2),"-",2) //病区
    .S AdmLoc=$p(^PAADM(AdmDr),"^",4) //科室
	.S:AdmLoc'="" AdmLoc=$p($p(^CTLOC(AdmLoc),"^",2),"-",2)
	.S AdmDoc=""
	.S AdmDocID=$p(^PAADM(AdmDr),"^",9) //医生
	.S:AdmDocID'="" AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2)
	.
	.s DischgDate=$p(^PAADM(AdmDr),"^",17)  //出院日期
	.s DischgTime=$p(^PAADM(AdmDr),"^",18)  //出院时间
	.i DischgDate'="" S DischgDate=$zd(DischgDate,3)
	.i DischgTime'="" S DischgTime=$zt(DischgTime,1)
	.S OutHosDate=DischgDate  //出院日期
	.s OpArrageFlag=""
	.s OpArrageID=$o(^DHCANOPArrange(0,"Adm",AdmDr,"")) //手术
	.i OpArrageID'="" s OpArrageFlag="√"
	.
	.s PatSpecCmtTypeStr=##Class(web.DHCSTCNTANTQUERY).getPatSpecCmtTypeStr(AdmDr)
	.s AntibioticFlag=$p(PatSpecCmtTypeStr,"^",1)
	.s SpecAntibioticFlag=$p(PatSpecCmtTypeStr,"^",2)
	.s CordialFlag=$p(PatSpecCmtTypeStr,"^",3)
	.s InjectFlag=$p(PatSpecCmtTypeStr,"^",4)
	.s PoisonFlag=$p(PatSpecCmtTypeStr,"^",5)
	.
	.s PcntResDesc=""
	.s sub=$o(^DHCPHCNTS(pcntID,"I",ch,"L",""),-1)
	.i sub'="" s PcntResDesc=$p(^DHCPHCNTS(pcntID,"I",ch,"L",sub),"^",9) ///点评结果描述
	.
	.S ListData=AdmDr_"^"_PatNo_"^"_PatName_"^"_PatAge_"^"_AdmWard_"^"_AdmLoc_"^"_AdmDoc_"^"_AdmDate_"^"_OutHosDate_"^"_PatDiag_"^"_PatDiag_"^"_pcntUser_"^"_CntRes_"^"_pcntDate_" "_pcntTime_"^"_pcntItmID
	.S ListData=ListData_"^"_OpArrageFlag_"^"_AntibioticFlag_"^"_SpecAntibioticFlag_"^"_CordialFlag_"^"_InjectFlag_"^"_PoisonFlag_"^"_PcntResDesc
	.
	.S Num=Num+1
	.S index=Num
	.S ^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryInHosCmtList",pid,index)=ListData
	.
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S count=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryInHosCmtList",pid,index)) Q:index=""  D
	.S mdata=^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryInHosCmtList",pid,index)
	.S Title="AdmDr^PatNo^PatName^PatAge^AdmWard^AdmLoc^AdmDoc^InHosDate^OutHosDate^InHosDiag^OutHosDiag^pcntUser^pcntRes^pcntDate^pcntItmID^OpArrageFlag^AntibioticFlag^SpecAntibioticFlag^CordialFlag^InjectFlag^PoisonFlag^PcntResDesc"
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// 查询门诊点评明细内容
ClassMethod QueryOutHosCmtList(rows As %String, page As %String, pcntID As %String) As %String
{
	N (rows,page,pcntID)

	s End = page*rows
	s Start=(page-1)*rows+1
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	Q:'$d(^DHCPHCNTS(pcntID)) ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S pcntNo=$p(^DHCPHCNTS(pcntID),"^",1)   //点评单
	S pcntDate=$p(^DHCPHCNTS(pcntID),"^",2) //点评日期
	S:pcntDate'="" pcntDate=$zd(pcntDate,3)
	S pcntTime=$p(^DHCPHCNTS(pcntID),"^",3) //点评时间
	S:pcntTime'="" pcntTime=$zt(pcntTime,2)
	
	S pcntNotes=$p(^DHCPHCNTS(pcntID),"^",4) //点评信息
	S pcntUser=""
	S pcntUserID=$p(^DHCPHCNTS(pcntID),"^",6) //点评人
	S:pcntUserID'="" pcntUser=$p(^SSU("SSUSR",pcntUserID),"^",2)
	
	S Num=0
	S ch=""
	F  S ch=$o(^DHCPHCNTS(pcntID,"I",ch)) q:ch=""  d
	.S pcntItmID=pcntID_"||"_ch
	.S CntRes=$p(^DHCPHCNTS(pcntID,"I",ch),"^",6)
	.i CntRes="Y" s CntRes="合理"
	.i CntRes="N" s CntRes="不合理"
	.S AdmDr=$p(^DHCPHCNTS(pcntID,"I",ch),"^",3)
	.Q:'$d(^PAADM(AdmDr))
	.S Papmi=$p(^PAADM(AdmDr),"^",1)
	.S PatName=$p(^PAPER(Papmi,"ALL"),"^", 1) //姓名
	.S PatSex=""
	.S PatSexID=$p(^PAPER(Papmi,"ALL"),"^",7 ) //姓别
	.S:PatSexID'="" PatSex=$p(^CT("SEX",PatSexID),"^",2)
	.S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
	.S PatAge=##class(web.DHCSTKUTIL).GetAge(Papmi)  //年龄
	.S PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",") //诊断
    .
    .S AdmDate=$p(^PAADM(AdmDr),"^",6)  //就诊日期
	.S AdmTime=$p(^PAADM(AdmDr),"^",7)  //就诊时间
	.I AdmDate'="" S AdmDate=$zd(AdmDate,3)
	.I AdmTime'="" S AdmTime=$zt(AdmTime,2)
	.S AdmDate=AdmDate //_" "_AdmTime
	.S AdmWard=""
	.S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	.I AdmWardDr'="" s AdmWard=$p($p(^PAWARD(AdmWardDr),"^",2),"-",2) //病区
    .S AdmLoc=$p(^PAADM(AdmDr),"^",4) //科室
	.S:AdmLoc'="" AdmLoc=$p($p(^CTLOC(AdmLoc),"^",2),"-",2)
	.S AdmDoc=""
	.S AdmDocID=$p(^PAADM(AdmDr),"^",9) //医生
	.S:AdmDocID'="" AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2)
	.s OpArrageFlag=""
	.s OpArrageID=$o(^DHCANOPArrange(0,"Adm",AdmDr,"")) //手术
	.i OpArrageID'="" s OpArrageFlag="√"
	.
	.s PatSpecCmtTypeStr=##Class(web.DHCSTCNTANTQUERY).getPatSpecCmtTypeStr(AdmDr)
	.s AntibioticFlag=$p(PatSpecCmtTypeStr,"^",1)
	.s SpecAntibioticFlag=$p(PatSpecCmtTypeStr,"^",2)
	.s CordialFlag=$p(PatSpecCmtTypeStr,"^",3)
	.s InjectFlag=$p(PatSpecCmtTypeStr,"^",4)
	.s PoisonFlag=$p(PatSpecCmtTypeStr,"^",5)
	.
	.s PcntResDesc=""
	.s sub=$o(^DHCPHCNTS(pcntID,"I",ch,"L",""),-1)
	.i sub'="" s PcntResDesc=$p(^DHCPHCNTS(pcntID,"I",ch,"L",sub),"^",9) ///点评结果描述
	.
	.S ListData=AdmDr_"^"_PatNo_"^"_PatName_"^"_PatAge_"^"_AdmWard_"^"_AdmLoc_"^"_AdmDoc_"^"_AdmDate_"^"_PatDiag_"^"_pcntUser_"^"_CntRes_"^"_pcntDate_" "_pcntTime_"^"_pcntItmID
	.S ListData=ListData_"^"_OpArrageFlag_"^"_AntibioticFlag_"^"_SpecAntibioticFlag_"^"_CordialFlag_"^"_InjectFlag_"^"_PoisonFlag_"^"_PcntResDesc
	.
	.S Num=Num+1
	.S index=Num
	.S ^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryInHosCmtList",pid,index)=ListData
	.
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S count=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryInHosCmtList",pid,index)) Q:index=""  D
	.S mdata=^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryInHosCmtList",pid,index)
	.S Title="AdmDr^PatNo^PatName^PatAge^AdmWard^AdmLoc^AdmDoc^AdmDate^AdmDiag^pcntUser^pcntRes^pcntDate^pcntItmID^OpArrageFlag^AntibioticFlag^SpecAntibioticFlag^CordialFlag^InjectFlag^PoisonFlag^PcntResDesc"
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript：查找点评单列表
/// W ##Class(web.DHCSTCNTANTQUERY).QueryCommentNo("10","1","2014-01-01^2015-10-10^F")
ClassMethod QueryCommentNo(rows As %String, page As %String, otherparam As %String) As %String
{
	N (rows,page,otherparam)

	s End = page*rows
	s Start=(page-1)*rows+1
	S pid=..NewPid()
	d ..killTmpGlobal(pid)

	S StDate=$p(otherparam,"^",1)  //起始日期
	S:StDate'="" StDate=$zdh(StDate,3)
	S EndDate=$p(otherparam,"^",2) //结束日期
	S:EndDate'="" EndDate=$zdh(EndDate,3)
	S PcntType=$p(otherparam,"^",3)  //点评类型
	S PcntWayID=$p(otherparam,"^",4) //点评方式
    i PcntType="F" s PcntTypeDesc="门(急)诊"
	i PcntType="P" s PcntTypeDesc="住院"
	
    S Num=0
	F dd=StDate:1:EndDate D
	.S PcntID=""
	.F  S PcntID=$o(^DHCPHCNTS(0,"Date",dd,PcntType,PcntID)) Q:PcntID=""  D
	..S PcntNo=$p(^DHCPHCNTS(PcntID),"^",1)
	..S PcntDate=$p(^DHCPHCNTS(PcntID),"^",2)
	..i PcntDate'="" s PcntDate=$zd(PcntDate,3)
	..S PcntTime=$p(^DHCPHCNTS(PcntID),"^",3)
	..i PcntTime'="" s PcntTime=$zt(PcntTime,2)
	..S PcntText=$p(^DHCPHCNTS(PcntID),"^",4)
	..S PcntUserID=$p(^DHCPHCNTS(PcntID),"^",6)
	..S PcntUser=$p($g(^SSU("SSUSR",PcntUserID)),"^",2)
	..S PcntWayDr=$p(^DHCPHCNTS(PcntID),"^",7)
    ..Q:(PcntWayID'=PcntWayDr)&(PcntWayID'="")
	..i PcntWayDr'="" d
	...Q:'$d(^DHCPCWAY(PcntWayDr))
	...S PcntWayDesc=$p(^DHCPCWAY(PcntWayDr),"^",2)
	..S Num=Num+1
	..S ListData=PcntNo_"^"_PcntDate_"^"_PcntTime_"^"_PcntText_"^"_PcntUser_"^"_PcntTypeDesc_"^"_PcntWayDesc_"^"_PcntID
	..S index=Num
	..S ^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryCommentNo",pid,index)=ListData
	.
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S count=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryCommentNo",pid,index)) Q:index=""  D
	.S mdata=^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryCommentNo",pid,index)
	.S Title="PcntNo^PcntDate^PcntTime^PcntCon^PcntUser^PcntType^PcntWay^PcntID"
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript：获取点评方式集合(激活)
ClassMethod QueryActiveWayDs(Type As %String) As %String
{
	N (Type)
	S count=0
	W "["
	S wayid=""
	F  S wayid=$o(^DHCPCWAY(wayid)) q:wayid=""  d
	.S waycode=$p(^DHCPCWAY(wayid),"^",1)
	.Q:(Type="2")&(waycode'="IP")
	.Q:(Type="1")&(waycode="IP")
	.S waydesc=$p(^DHCPCWAY(wayid),"^",2)
	.Q:waydesc=""
	.S wayactive=$p(^DHCPCWAY(wayid),"^",3)
	.Q:wayactive'="Y"
	.i $f(waydesc,$c(13))  s waydesc=$p(waydesc,$c(13))
	.S tmp=wayid_"^"_waydesc
	.S count = count+1
	.I count=1 d
	..W ##class(web.DHCSTPHCMCOMMON).getJsonData("val^text",tmp)
	.e  d
	..W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("val^text",tmp)
	.
	W "]"
	Q ""
}

/// Descript:点评不合理原因
ClassMethod jsonQueryUnCmtReason(InWayCode As %String) As %String
{
	N (InWayCode)
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	S Num=0
	S reasondr="0"
	F  S reasondr=$o(^DHCPCREASON(reasondr)) Q:reasondr=""  D
	.S PCRCode=$p(^DHCPCREASON(reasondr),"^",1)  ///点评代码
	.S PCRDesc=$p(^DHCPCREASON(reasondr),"^",2)  ///点评描述
	.S PCRLevl=+$p(^DHCPCREASON(reasondr),"^",3)
	.S:PCRLevl=0 PCRLevl=""
	.S PCRWayID=$p(^DHCPCREASON(reasondr),"^",4)
	.Q:'$D(^DHCPCWAY(PCRWayID))
	.S WayCode=$p(^DHCPCWAY(PCRWayID),"^",1)  ///点评方式
	.Q:(InWayCode'="")&(InWayCode'=WayCode)
	.S mdata=reasondr_"^"_PCRDesc_"^"_PCRLevl_"^"_WayCode
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCSTCNTANTQUERY","jsonQueryUnCmtReason",pid,Num)=mdata
	.
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S count=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTQUERY","jsonQueryUnCmtReason",pid,index)) Q:index=""  D
	.S mdata=^TMP("DHCST","web.DHCSTCNTANTQUERY","jsonQueryUnCmtReason",pid,index)
	.S count=count+1
	.I count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData("id^text^_parentId",mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("id^text^_parentId",mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript: 是否存在特定点评类型
ClassMethod getPatSpecCmtTypeStr(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s AntibioticFlag="",SpecAntibioticFlag="",CordialFlag="",InjectFlag="",PoisonFlag=""
	s BaseDrugFlag=""
	s quitflag=0
	s ord=""
	f  s ord=$o(^OEORD(0,"Adm",EpisodeID,ord)) q:(ord="")||(quitflag=1)  d
	.s chl=0
	.f  s chl=$o(^OEORD(ord,"I",chl)) q:(chl=0)||(chl="")  d
	..s orditm=ord_"||"_chl
	..s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s ItemCatDR=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)
	..s ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
	..q:ordertype'="R"
	..s FillerNo=$p(^OEORD(ord,"I",chl,9),"^",12)  	  //滚医嘱来源信息 OEORI_FillerNo
    ..q:(FillerNo'="")&(FillerNo'=orditm_"!!"_orditm) //长嘱非首日记录过滤
    ..s inci=+$o(^INCI(0,"ARCIM_DR",itmmastid,""))
    ..s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  //剂型
	..i (form["兴奋")&(CordialFlag="") s CordialFlag="√"
	..i (form["注射")&(CordialFlag="") s InjectFlag="√"
	..s rArcimPhcdfDr=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)   //指向PHC_DrgForm
 	..s rPhcDrgForm1=+$p(rArcimPhcdfDr,"||",1)
 	..s rPhcDrgForm2=+$p(rArcimPhcdfDr,"||",2)
 	..i $d(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2,"DHC")) d
 	...s AntibFlag=$p(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2,"DHC"),"^",8) //抗菌药标志
    ..i (AntibFlag="Y")&(AntibioticFlag="") s AntibioticFlag="√"
	..s drugpoisonstr=##class(web.DHCSTCOMMONSRV).getPoisonByInci(inci)  //管制分类
	..s drugpoisondesc=$p(drugpoisonstr,"^",3)
	..i (drugpoisondesc["抗菌")&(drugpoisondesc["特")&(SpecAntibioticFlag="") s SpecAntibioticFlag="√"
	..i ((drugpoisondesc["毒")||(drugpoisondesc["麻")||(drugpoisondesc["精"))&(PoisonFlag="") s PoisonFlag="√"
	..s infoid=$o(^DHCITMINFO(0,"INCI",inci,""))
	..q:infoid=""
	..q:'$d(^DHCITMINFO(infoid))
	..s baseflag=$p(^DHCITMINFO(infoid),"^",4)
	..i baseflag="Y" s BaseDrugFlag="√"
	..q:(AntibioticFlag="")||(SpecAntibioticFlag="")||(CordialFlag="")||(InjectFlag="")||(PoisonFlag="")||(BaseDrugFlag="")
	..s quitflag=1
	Q AntibioticFlag_"^"_SpecAntibioticFlag_"^"_CordialFlag_"^"_InjectFlag_"^"_PoisonFlag
}

///  Creator: bian shuai
///  CreateDate: 2015-04-03
///  Descript: 门诊点评明细(Query)(润乾)
///  D ##Class(%ResultSet).RunQuery("web.DHCSTCNTANTQUERY","QueryOutHosCmtDetail","82")
Query QueryOutHosCmtDetail(pcntID As %String) As %Query(ROWSPEC = "TAdmDr:%String,TPatNo:%String,TPatName:%String,TPatAge:%String,TAdmLoc:%String,TAdmDoc:%String,TAdmDate:%String,TPatDiag:%String,TPcntUser:%String,TCntRes:%String,TPcntDate:%String,TPcntTime:%String,TPcntItmID:%String,TOpArrageFlag:%String,TAntibioticFlag:%String,TSpecAntibioticFlag:%String,TCordialFlag:%String,TInjectFlag:%String,TPoisonFlag:%String,TBaseDrugFlag:%String,TPcntResDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryOutHosCmtDetailExecute(ByRef qHandle As %Binary, pcntID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1

	i pcntID'>0 Quit $$$OK
	
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	
	S pcntNo=$p(^DHCPHCNTS(pcntID),"^",1)   //点评单
	S pcntDate=$p(^DHCPHCNTS(pcntID),"^",2) //点评日期
	S:pcntDate'="" pcntDate=$zd(pcntDate,3)
	S pcntTime=$p(^DHCPHCNTS(pcntID),"^",3) //点评时间
	S:pcntTime'="" pcntTime=$zt(pcntTime,2)
	
	S pcntNotes=$p(^DHCPHCNTS(pcntID),"^",4) //点评信息
	S pcntUser=""
	S pcntUserID=$p(^DHCPHCNTS(pcntID),"^",6) //点评人
	S:pcntUserID'="" pcntUser=$p(^SSU("SSUSR",pcntUserID),"^",2)
	
	S Num=0
	S ch=""
	F  S ch=$o(^DHCPHCNTS(pcntID,"I",ch)) q:ch=""  d
	.S pcntItmID=pcntID_"||"_ch
	.S CntRes=$p(^DHCPHCNTS(pcntID,"I",ch),"^",6)
	.i CntRes="Y" s CntRes="合理"
	.i CntRes="N" s CntRes="不合理"
	.S AdmDr=$p(^DHCPHCNTS(pcntID,"I",ch),"^",3)
	.Q:'$d(^PAADM(AdmDr))
	.S Papmi=$p(^PAADM(AdmDr),"^",1)
	.S PatName=$p(^PAPER(Papmi,"ALL"),"^", 1) //姓名
	.S PatSex=""
	.S PatSexID=$p(^PAPER(Papmi,"ALL"),"^",7 ) //姓别
	.S:PatSexID'="" PatSex=$p(^CT("SEX",PatSexID),"^",2)
	.S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
	.S PatAge=##class(web.DHCSTKUTIL).GetAge(Papmi)  //年龄
	.S PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",") //诊断
    .
    .S AdmDate=$p(^PAADM(AdmDr),"^",6)  //就诊日期
	.S AdmTime=$p(^PAADM(AdmDr),"^",7)  //就诊时间
	.I AdmDate'="" S AdmDate=$zd(AdmDate,3)
	.I AdmTime'="" S AdmTime=$zt(AdmTime,2)
	.S AdmDate=AdmDate //_" "_AdmTime
    .S AdmLoc=$p(^PAADM(AdmDr),"^",4) //科室
	.S:AdmLoc'="" AdmLoc=$p($p(^CTLOC(AdmLoc),"^",2),"-",2)
	.S AdmDoc=""
	.S AdmDocID=$p(^PAADM(AdmDr),"^",9) //医生
	.S:AdmDocID'="" AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2)
	.s OpArrageFlag=""
	.s OpArrageID=$o(^DHCANOPArrange(0,"Adm",AdmDr,"")) //手术
	.i OpArrageID'="" s OpArrageFlag="√"
	.
	.s PatSpecCmtTypeStr=##Class(web.DHCSTCNTANTQUERY).getPatSpecCmtTypeStr(AdmDr)
	.s AntibioticFlag=$p(PatSpecCmtTypeStr,"^",1)
	.s SpecAntibioticFlag=$p(PatSpecCmtTypeStr,"^",2)
	.s CordialFlag=$p(PatSpecCmtTypeStr,"^",3)
	.s InjectFlag=$p(PatSpecCmtTypeStr,"^",4)
	.s PoisonFlag=$p(PatSpecCmtTypeStr,"^",5)
	.s BaseDrugFlag=$p(PatSpecCmtTypeStr,"^",6)
	.
	.s PcntResDesc=""
	.s sub=$o(^DHCPHCNTS(pcntID,"I",ch,"L",""),-1)
	.i sub'="" s PcntResDesc=$p(^DHCPHCNTS(pcntID,"I",ch,"L",sub),"^",9) ///点评结果描述
	.
	.S ListData=AdmDr_"^"_PatNo_"^"_PatName_"^"_PatAge_"^"_AdmLoc_"^"_AdmDoc_"^"_AdmDate_"^"_PatDiag_"^"_pcntUser_"^"_CntRes_"^"_pcntDate_"^"_pcntTime_"^"_pcntItmID
	.S ListData=ListData_"^"_OpArrageFlag_"^"_AntibioticFlag_"^"_SpecAntibioticFlag_"^"_CordialFlag_"^"_InjectFlag_"^"_PoisonFlag_"^"_BaseDrugFlag_"^"_PcntResDesc
	.
	.S Num=Num+1
	.S index=Num
	.S ^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryOutHosCmtDetail",pid,index)=ListData
	.

	S i=""
	f  S i=$o(^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryOutHosCmtDetail",pid,i)) Q:i=""  D
	.S mdata=$g(^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryOutHosCmtDetail",pid,i))
	.//mdata列表 TAdmDr,TPatNo,TPatName,TPatAge,TAdmLoc,TAdmDoc,TAdmDate,TPatDiag,TPcntUser,TCntRes,TPcntDate,TPcntTime,TPcntItmID,TOpArrageFlag,TAntibioticFlag,TSpecAntibioticFlag,TCordialFlag,TInjectFlag,TPoisonFlag,TBaseDrugFlag,TPcntResDesc
	.//mdata列表 就诊ID,登记号,患者姓名,年龄,科室,医生,就诊日期,诊断,点评人,点评结果,点评日期,点评时间,点评明细ID,手术标志,抗菌药标志,特抗标志,兴奋标志,注射标志,毒麻精标志,基本药物,点评结果描述
	.S ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
	.Set ^CacheTemp(repid,ind)=ListData	
	.Set ind=ind+1
	.
	
	d ..killTmpGlobal(pid)
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryOutHosCmtDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOutHosCmtDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOutHosCmtDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOutHosCmtDetailExecute ]
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

///  Creator: bian shuai
///  CreateDate: 2015-04-03
///  Descript: 住院点评明细(Query)(润乾)
///  D ##Class(%ResultSet).RunQuery("web.DHCSTCNTANTQUERY","QueryInHosCmtDetail","83")
Query QueryInHosCmtDetail(pcntID As %String) As %Query(ROWSPEC = "TAdmDr:%String,TPatNo:%String,TPatName:%String,TPatAge:%String,TAdmWard:%String,TAdmLoc:%String,TAdmDoc:%String,TAdmDate:%String,TOutHosDate:%String,TInPatDiag:%String,TOutPatDiag:%String,TPcntUser:%String,TCntRes:%String,TPcntDate:%String,TPcntTime:%String,TPcntItmID:%String,TOpArrageFlag:%String,TAntibioticFlag:%String,TSpecAntibioticFlag:%String,TCordialFlag:%String,TInjectFlag:%String,TPoisonFlag:%String,TBaseDrugFlag:%String,TPcntResDesc:%String,TOpBladeType:%String") [ SqlProc ]
{
}

ClassMethod QueryInHosCmtDetailExecute(ByRef qHandle As %Binary, pcntID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1

	i pcntID'>0 Quit $$$OK
	
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	
	S pcntNo=$p(^DHCPHCNTS(pcntID),"^",1)   //点评单
	S pcntDate=$p(^DHCPHCNTS(pcntID),"^",2) //点评日期
	S:pcntDate'="" pcntDate=$zd(pcntDate,3)
	S pcntTime=$p(^DHCPHCNTS(pcntID),"^",3) //点评时间
	S:pcntTime'="" pcntTime=$zt(pcntTime,2)
	
	S pcntNotes=$p(^DHCPHCNTS(pcntID),"^",4) //点评信息
	S pcntUser=""
	S pcntUserID=$p(^DHCPHCNTS(pcntID),"^",6) //点评人
	S:pcntUserID'="" pcntUser=$p(^SSU("SSUSR",pcntUserID),"^",2)
	
	S Num=0
	S ch=""
	F  S ch=$o(^DHCPHCNTS(pcntID,"I",ch)) q:ch=""  d
	.S pcntItmID=pcntID_"||"_ch
	.S CntRes=$p(^DHCPHCNTS(pcntID,"I",ch),"^",6)
	.i CntRes="Y" s CntRes="合理"
	.i CntRes="N" s CntRes="不合理"
	.S AdmDr=$p(^DHCPHCNTS(pcntID,"I",ch),"^",3)
	.Q:'$d(^PAADM(AdmDr))
	.S Papmi=$p(^PAADM(AdmDr),"^",1)
	.S PatName=$p(^PAPER(Papmi,"ALL"),"^", 1) //姓名
	.S PatSex=""
	.S PatSexID=$p(^PAPER(Papmi,"ALL"),"^",7 ) //姓别
	.S:PatSexID'="" PatSex=$p(^CT("SEX",PatSexID),"^",2)
	.S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
	.S PatAge=##class(web.DHCSTKUTIL).GetAge(Papmi)  //年龄
	.S PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",") //诊断
    .
    .S AdmDate=$p(^PAADM(AdmDr),"^",6)  //就诊日期
	.S AdmTime=$p(^PAADM(AdmDr),"^",7)  //就诊时间
	.I AdmDate'="" S AdmDate=$zd(AdmDate,3)
	.I AdmTime'="" S AdmTime=$zt(AdmTime,2)
	.S AdmDate=AdmDate //_" "_AdmTime
	.S AdmWard=""
	.S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	.I AdmWardDr'="" s AdmWard=$p($p(^PAWARD(AdmWardDr),"^",2),"-",2) //病区
    .S AdmLoc=$p(^PAADM(AdmDr),"^",4) //科室
	.S:AdmLoc'="" AdmLoc=$p($p(^CTLOC(AdmLoc),"^",2),"-",2)
	.S AdmDoc=""
	.S AdmDocID=$p(^PAADM(AdmDr),"^",9) //医生
	.S:AdmDocID'="" AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2)
	.
	.s DischgDate=$p(^PAADM(AdmDr),"^",17)  //出院日期
	.s DischgTime=$p(^PAADM(AdmDr),"^",18)  //出院时间
	.i DischgDate'="" S DischgDate=$zd(DischgDate,3)
	.i DischgTime'="" S DischgTime=$zt(DischgTime,1)
	.S OutHosDate=DischgDate  //出院日期
	.s OpArrageFlag=""
	.s OpArrageID=$o(^DHCANOPArrange(0,"Adm",AdmDr,"")) //手术
	.i OpArrageID'="" s OpArrageFlag="√"
	.
	.s PatSpecCmtTypeStr=##Class(web.DHCSTCNTANTQUERY).getPatSpecCmtTypeStr(AdmDr)
	.s AntibioticFlag=$p(PatSpecCmtTypeStr,"^",1)
	.s SpecAntibioticFlag=$p(PatSpecCmtTypeStr,"^",2)
	.s CordialFlag=$p(PatSpecCmtTypeStr,"^",3)
	.s InjectFlag=$p(PatSpecCmtTypeStr,"^",4)
	.s PoisonFlag=$p(PatSpecCmtTypeStr,"^",5)
	.s BaseDrugFlag=$p(PatSpecCmtTypeStr,"^",6)
	.
	.s PcntResDesc=""
	.s sub=$o(^DHCPHCNTS(pcntID,"I",ch,"L",""),-1)
	.i sub'="" s PcntResDesc=$p(^DHCPHCNTS(pcntID,"I",ch,"L",sub),"^",9) ///点评结果描述
	.
	.s OpBladeType=##Class(web.DHCSTCNTANTQUERY).getPatAnOpBladeType(AdmDr)
	.
	.S ListData=AdmDr_"^"_PatNo_"^"_PatName_"^"_PatAge_"^"_AdmWard_"^"_AdmLoc_"^"_AdmDoc_"^"_AdmDate_"^"_OutHosDate_"^"_PatDiag_"^"_PatDiag_"^"_pcntUser_"^"_CntRes_"^"_pcntDate_"^"_pcntTime_"^"_pcntItmID
	.S ListData=ListData_"^"_OpArrageFlag_"^"_AntibioticFlag_"^"_SpecAntibioticFlag_"^"_CordialFlag_"^"_InjectFlag_"^"_PoisonFlag_"^"_PcntResDesc_"^"_OpBladeType
	.
	.S Num=Num+1
	.S index=Num
	.S ^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryInHosCmtDetail",pid,index)=ListData
	.


	S i=""
	f  S i=$o(^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryInHosCmtDetail",pid,i)) Q:i=""  D
	.S mdata=$g(^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryInHosCmtDetail",pid,i))
	.//mdata列表 TAdmDr,TPatNo,TPatName,TPatAge,TAdmWard,TAdmLoc,TAdmDoc,TAdmDate,TOutHosDate,TInPatDiag,TOutPatDiag,TPcntUser,TCntRes,TPcntDate,TPcntTime,TPcntItmID,TOpArrageFlag,TAntibioticFlag,TSpecAntibioticFlag,TCordialFlag,TInjectFlag,TPoisonFlag,TBaseDrugFlag,TPcntResDesc,TOpBladeType
	.//mdata列表 就诊ID,登记号,患者姓名,年龄,病区,科室,医生,就诊日期,出院日期,入院诊断,出院诊断,点评人,点评结果,点评日期,点评时间,点评明细ID,手术标志,抗菌药标志,特抗标志,兴奋标志,注射标志,毒麻精标志,基本药物,点评结果描述
	.S ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
	.Set ^CacheTemp(repid,ind)=ListData	
	.Set ind=ind+1
	.
	
	d ..killTmpGlobal(pid)
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryInHosCmtDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInHosCmtDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryInHosCmtDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInHosCmtDetailExecute ]
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

/// Descript:获取点评单主信息
ClassMethod getPCommentMainInfo(pcntID) As %String
{
	n (pcntID)
	S pcntNo=$p(^DHCPHCNTS(pcntID),"^",1)   //点评单
	S pcntDate=$p(^DHCPHCNTS(pcntID),"^",2) //点评日期
	S:pcntDate'="" pcntDate=$zd(pcntDate,3)
	S pcntTime=$p(^DHCPHCNTS(pcntID),"^",3) //点评时间
	S:pcntTime'="" pcntTime=$zt(pcntTime,2)
	
	S pcntNotes=$p(^DHCPHCNTS(pcntID),"^",4) //点评信息
	S pcntUser=""
	S pcntUserID=$p(^DHCPHCNTS(pcntID),"^",6) //点评人
	S:pcntUserID'="" pcntUser=$p(^SSU("SSUSR",pcntUserID),"^",2)
	S ListData=pcntNo_"^"_pcntDate_"^"_pcntNotes_"^"_pcntUser
	Q ListData
}

/// Descript:获取病人的切口类型
ClassMethod getPatAnOpBladeType(EpisodeID As %String) As %String
{
	N (EpisodeID)
	S ListData=""
	S OpArrangeID="" 
	F  S OpArrangeID=$o(^DHCANOPArrange(0,"Adm",EpisodeID,OpArrangeID)) Q:(OpArrangeID="")  D
	.S CH=$P($P(^DHCANOPArrange(OpArrangeID),"^",2),"||",2)
	.S Sub="" 
	.F  S Sub=$O(^OR(EpisodeID,"ANA",CH,"OP",Sub)) Q:(Sub="")  D
	..S BladeID=$P(^OR(EpisodeID,"ANA",CH,"OP",Sub),"^",9)
	..Q:BladeID=""
	..S BladeType=$p(^ORC("BLDTP",BladeID),"^",2)  //切口类型
	..i ListData="" S ListData=BladeType
	..E  S ListData=ListData_","_BladeType
	Q ListData
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryInHosCmtList",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryInHosCmtList",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryCommentNo",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTQUERY","jsonQueryUnCmtReason",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryOutHosCmtDetail",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTQUERY","QueryInHosCmtDetail",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("STCNTANTQUERY"))
}

}
