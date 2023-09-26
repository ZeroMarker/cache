Import SQLUser

/// Creator: bianshuai
/// CreateDate: 2015-09-21
/// Descript: 手术用药
Class web.DHCSTPHCMPATBASEINFOQUERY Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:查询在院病人列表
/// w ##class(web.DHCSTPHCMPATBASEINFOQUERY).QueryInHosPatList("20","1","2015-09-21^2015-09-21^^^^")
ClassMethod QueryInHosPatList(rows As %String, page As %String, param As %String) As %String
{
	N (rows,page,param,%session)
	S pid=..NewPid()
	S EndPage=page*rows  	   //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S StDate=$p(param,"^",1)   //开始日期
	S EndDate=$p(param,"^",2)  //结束日期
	S WardID=$p(param,"^",3)   //病区
	S LocID=$p(param,"^",4)    //科室
	S Type=$p(param,"^",5)     //类型
	S RegNo=$p(param,"^",6)    //登记号
	S HospID=$p(param,"^",7)   //医院ID
	d ..killTmpGlobal(pid)
	S ^BIANSHUAI(1)=param
	S StDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(StDate) ;$zdh(StDate,3)
	S EndDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(EndDate) ;$zdh(EndDate,3)

	S Num=0
	F dd=StDate:1:EndDate D
	.S time=""
	.F  S time=$o(^PAADMi("TypeDate","I",dd,time)) q:time=""  d
	..S AdmDr=""
	..F  S AdmDr=$o(^PAADMi("TypeDate","I",dd,time,AdmDr)) q:AdmDr=""  d
	...S AdmDate=$p(^PAADM(AdmDr),"^",6)  //就诊日期
	...S AdmTime=$p(^PAADM(AdmDr),"^",7)  //就诊时间
	...I AdmDate'="" S AdmDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(AdmDate) ;$zd(AdmDate,3)
	...I AdmTime'="" S AdmTime=$zt(AdmTime,1)
	...S AdmDate=AdmDate_" "_AdmTime
	...S DisCDate=$p(^PAADM(AdmDr),"^",17)  //出院日期
	...S DisCTime=$p(^PAADM(AdmDr),"^",18)  //出院时间
	...I DisCDate'="" S DisCDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(DisCDate) ;$zd(DisCDate,3)
	...I DisCTime'="" S DisCTime=$zt(DisCTime,1)
	...S DisCTime=DisCDate_" "_DisCTime
	...S patVisit=$p($g(^PAADM(AdmDr)),"^",20)
    ...Q:(Type="I")&(patVisit'="A")
    ...Q:(Type="O")&(patVisit'="D")
	...S AdmWard=""
	...S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	...Q:(WardID'="")&(WardID'=AdmWardDr)
	...I AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //qunianpeng 2017/8/14 新版描述没有拼音码 
	...S AdmBed=""
	...S AdmBedID=$p(^PAADM(AdmDr),"^",73) //床号
	...i AdmBedID'="" S AdmBed=$p(^PAWARD($p(AdmBedID,"||",1),"BED",$p(AdmBedID,"||",2)),"^",1)
	...S Papmi=$p(^PAADM(AdmDr),"^",1)
	...S PatName=$p(^PAPER(Papmi,"ALL"),"^",1) //姓名
	...S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1) //登记号
	...Q:(RegNo'="")&(RegNo'=PatNo)
	...S InMedicare=$p($g(^PAPER(Papmi,"PAT",3)),"^",4) ;病案号
	...S SexID=$p(^PAPER(Papmi,"ALL"),"^",7 )  //姓别
	...S PatSex=$p(^CT("SEX",SexID),"^",2)
	...S PatAge=##class(PHA.FACE.IN.Com).GetAge(Papmi,AdmDr)  //年龄
	...S PatDiag=##class(PHA.COM.Order).MrDiagnose(AdmDr,",") //##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",") //诊断
	...S PatW=##class(PHA.COM.Order).PatWeight(AdmDr) //体重
	...S PatH=##class(PHA.COM.Order).PatHeight(AdmDr) //身高
	...S AdmLoc=""
	...S AdmLocID=$p(^PAADM(AdmDr),"^",4) //科室
	...Q:(LocID'="")&(LocID'=AdmLocID)
	...S:AdmLocID'="" AdmLoc=$p(^CTLOC(AdmLocID),"^",2) //qunianpeng 2017/8/14 新版描述没有拼音码 AdmLoc=$p($p(^CTLOC(AdmLocID),"^",2),"-",2)
	...Q:(HospID'="")&(HospID'=$p(^CTLOC(AdmLocID),"^",22))
	...S AdmDoc=""
	...S AdmDocID=$p(^PAADM(AdmDr),"^",9) //医生
	...S:+AdmDocID'=0 AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2)
	...s AdmWard=##class(PHA.FACE.IN.Com).GetTransDesc("User.PACWard","WARDDesc","",AdmWard)
	...s PatName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",PatName)
    ...s PatSex=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
    ...s AdmLoc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLoc","CTLOCDesc","",AdmLoc)
    ...s AdmDoc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTCareProv","CTPCPDesc","",AdmDoc)
	...s PatDiag=##class(PHA.FACE.IN.Com).GetTransDesc("User.MRCICDDx","MRCIDDesc","",PatDiag)
	...S ListData=AdmWard_"^"_AdmBed_"^"_PatNo_"^"_InMedicare_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatH_"^"_PatW_"^"_AdmDate_"^"_DisCTime_"^"_AdmLoc_"^"_AdmDr_"^"_PatDiag_"^"_AdmDoc
	...S Num=Num+1
	...S index=AdmDate_"^"_AdmWard_"^"_PatNo
	...S ^TMP("DHCST","web.DHCSTPHCMPATBASEINFOQUERY","QueryInHosPatList",pid,index)=ListData
	.

	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S ListTitle="Ward^Bed^PatNo^InMedicare^PatName^PatSex^PatAge^PatHeight^PatWeight^PatInDate^PatOutDate^AdmLoc^AdmDr^PatDiag^AdmDoc"
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPATBASEINFOQUERY","QueryInHosPatList",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMPATBASEINFOQUERY","QueryInHosPatList",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMPATBASEINFOQUERY","QueryInHosPatList",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMPATBASEINFOQUERY"))
}

}
