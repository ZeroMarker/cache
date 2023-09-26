Import SQLUser

/// Creator: bianshuai
/// CreateDate: 2014-09-18
/// Descript: 不良反应
Class web.DHCSTPHCMUntoEffect Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:查询在院病人列表
/// w ##class(web.DHCSTPHCMUntoEffect).GetUntoEffectPatList("20","1","2015-05-05^2015-05-07^^^^ADR")
ClassMethod GetUntoEffectPatList(rows As %String, page As %String, input As %String) As %String
{
	N (rows,page,input,%session)

	S pid=..NewPid()
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S StDate=$p(input,"^",1)   //开始日期
	S EndDate=$p(input,"^",2)  //结束日期
	S WardID=$p(input,"^",3)   //病区
	S LocID=$p(input,"^",4)    //科室
	S RegNo=$p(input,"^",5)    //登记号
	S AppType=$p(input,"^",6)  //AppType 应用类型
	S MonItem=$p(input,"^",7)  //监测项目
	S MonItmSubList=$p(input,"^",8)  //监测子项目
	S MonItmSubLibList=$p(input,"^",9) //监测函数项目
	s hospID=$p(input,"^",10)
	d ..killTmpGlobal(pid)

	S StDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(StDate) ;$zdh(StDate,3)
	S EndDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(EndDate) ;$zdh(EndDate,3)
	S ThemID=$o(^DHCPHFUTHE(0,"Code",AppType,""))    
	Q:ThemID="" ""

	S Num=0
	F dd=StDate:1:EndDate D
	.S phMonID=""
	.F  S phMonID=$o(^DHCPHM(0,"IndexUpdDate",dd,phMonID)) q:phMonID=""  d
	..S FunTheItmDr=$p(^DHCPHM(phMonID),"^",2)
	..Q:ThemID'=+FunTheItmDr  //主题过滤
	..Q:(MonItem'="")&(MonItem'=FunTheItmDr)  ///监测项目
	..Q:'..CheckMonItmIfExit(phMonID,MonItmSubLibList) ///监测函数项目
	..S AdmDr=$p(^DHCPHM(phMonID),"^",1)
	..s:AdmDr'="" Locdr=$p(^PAADM(AdmDr),"^",4)
	..q:(hospID'="")&(hospID'=$p($g(^CTLOC(Locdr)),"^",22))   //过滤病区
	..S AdmDate=$p($g(^PAADM(AdmDr)),"^",6)  //就诊日期
	..S AdmTime=$p($g(^PAADM(AdmDr)),"^",7)  //就诊时间
	..S patVisit=$p($g(^PAADM(AdmDr)),"^",20)
    ..Q:patVisit'="A"
	..s AdmType=$p(^PAADM(AdmDr),"^",2)
	..q:AdmType'="I"
	..I AdmDate'="" S AdmDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(AdmDate) ;$zd(AdmDate,3)
	..I AdmTime'="" S AdmTime=$zt(AdmTime,1)
	..S AdmTime=AdmTime //_" "_admtime
	..S AdmWard=""
	..S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	..Q:(WardID'="")&(WardID'=AdmWardDr)
	..I AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) // qunianpeng 2017/8/14 新版描述没有拼音码 $p($p(^PAWARD(AdmWardDr),"^",2),"-",2) //病区
	..S bedid=$p(^PAADM(AdmDr),"^",73) //床号
    ..I bedid="" S AdmBed=""
    ..E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	..S Papmi=$p(^PAADM(AdmDr),"^",1)
	..S PatName=$p(^PAPER(Papmi,"ALL"),"^",1) //姓名
	..S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1) //登记号
	..Q:(RegNo'="")&(RegNo'=PatNo)
	..S:(RegNo'="")&(RegNo=PatNo) QuitFlag=1
	..S InMedicare=$p($g(^PAPER(Papmi,"PAT",3)),"^",4) ;病案号
	..S SexID=$p(^PAPER(Papmi,"ALL"),"^",7 )  //姓别
	..S PatSex=$p(^CT("SEX",SexID),"^",2)
	..S PatAge=##class(PHA.FACE.IN.Com).GetAge(Papmi,AdmDr)  //年龄
	..S PatDiag=##class(PHA.COM.Order).MrDiagnose(AdmDr,",")   //##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",") //诊断
	..S PatW=##class(PHA.COM.Order).PatWeight(AdmDr) //体重
	..S PatH=##class(PHA.COM.Order).PatHeight(AdmDr) //身高
	..S PatWeiHei=##Class(web.DHCSTPHCMCOMMON).GetPatHighWeight(AdmDr,AdmWard)
	..i PatH="" s PatH=$p(PatWeiHei,"^",1)
	..i PatW="" s PatW=$p(PatWeiHei,"^",2)
	..S AdmLoc=$p(^PAADM(AdmDr),"^",4) //科室
	..Q:(LocID'="")&(LocID'=AdmLoc)
	..S:AdmLoc'="" AdmLoc=$p(^CTLOC(AdmLoc),"^",2) //qunianpeng 2017/8/14 新版描述没有拼音码 $p($p(^CTLOC(AdmLoc),"^",2),"-",2)
	..S AdmDoc=""
	..S AdmDocID=$p(^PAADM(AdmDr),"^",9) //医生
	..S:AdmDocID'="" AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2)
	..S ExpCause=##Class(web.DHCSTPHCMBLOODCONMONITOR).CheckIfExitExpCause(phMonID)
	..s AdmWard=##class(PHA.FACE.IN.Com).GetTransDesc("User.PACWard","WARDDesc","",AdmWard)
	..s PatName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",PatName)
    ..s PatSex=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
    ..s AdmLoc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLoc","CTLOCDesc","",AdmLoc)
    ..s AdmDoc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTCareProv","CTPCPDesc","",AdmDoc)
	..s PatDiag=##class(PHA.FACE.IN.Com).GetTransDesc("User.MRCICDDx","MRCIDDesc","",PatDiag)
	..S ListData=AdmWard_"^"_AdmBed_"^"_PatNo_"^"_InMedicare_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatH_"^"_PatW_"^"_AdmDate_"^"_AdmLoc_"^"_AdmDr_"^"_PatDiag_"^"_AdmDoc_"^"_ExpCause
	..
	..S Num=Num+1
	..S index=AdmWard_"^"_AdmBed_"^"_AdmDate_"^"_PatNo
	..S ^TMP("DHCST","web.DHCSTPHCMUntoEffect","QueryInHosPatList",pid,index)=ListData
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMUntoEffect","QueryInHosPatList",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMUntoEffect","QueryInHosPatList",pid,index)
	.S Title="Ward^Bed^PatNo^InMedicare^PatName^PatSex^PatAge^PatHeight^PatWeight^PatInDate^AdmLoc^AdmDr^PatDiag^AdmDoc^ExpCause"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:是否存在对应的监测项目
ClassMethod CheckMonItmIfExit(phMonID, MonItmSubLibList) As %String
{
	N (phMonID,MonItmSubLibList)
	Q:MonItmSubLibList="" 1
	S quitflag=0
	S CH=""
	F  S CH=$o(^DHCPHM(phMonID,"I",CH)) Q:(CH="")||(quitflag=1)  D
	.S ARCIMRowid=$p(^DHCPHM(phMonID,"I",CH),"^",2)
	.Q:'$d(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1))
	.S drgFormId=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",12)
	.Q:'##Class(web.DHCSTCNTANTIBACTERIAL).CheckStrIfExitVar(MonItmSubLibList,drgFormId)
	.S quitflag=1
	Q quitflag
}

/// Descript:监测记录是否属于监测子项目
ClassMethod CheckMonItmSubIfExit(FunTheItmDr, MonItmSubList) As %String
{
	N (FunTheItmDr, MonItmSubList)	
	S quitflag=0
	S phfliID=""
	F  S phfliID=$o(^DHCPHFULITM(0,"Theme",FunTheItmDr,phfliID)) Q:(phfliID="")||(quitflag=1)  D
	.S monType=$p(^DHCPHFULITM(phfliID),"^",5)
	.Q:'##Class(web.DHCSTCNTANTIBACTERIAL).CheckStrIfExitVar(MonItmSubList,monType)
	.Q:'##Class(web.DHCSTCNTANTIBACTERIAL).CheckStrIfExitVar(MonItmSubList,phfliID)
	.S quitflag=1
	Q 1
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMUntoEffect","QueryInHosPatList",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMUntoEffect"))
}

}
