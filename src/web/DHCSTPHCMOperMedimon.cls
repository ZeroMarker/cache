Import SQLUser

/// Creator: bianshuai
/// CreateDate: 2014-09-18
/// Descript: 手术用药
Class web.DHCSTPHCMOperMedimon Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:查询在院病人列表
/// w ##class(web.DHCSTPHCMOperMedimon).GetOperMedPatList("20","1","2016-10-15^2016-11-01^^^^SSYY^^1306||1")
ClassMethod GetOperMedPatList(rows As %String, page As %String, input As %String) As %String
{
	N (rows,page,input)
	S pid=..NewPid()
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S StDate=$p(input,"^",1)   //开始日期
	S EndDate=$p(input,"^",2)   //结束日期
	S WardID=$p(input,"^",3)   //病区
	S LocID=$p(input,"^",4)    //科室
	S RegNo=$p(input,"^",5)    //登记号
	S AppType=$p(input,"^",6)  //AppType 应用类型
	s OperID=$p(input,"^",7)   //手术ID
	s ItmID=$p(input,"^",8)    //医嘱项ID
	s hospID=$p(input,"^",9)
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
	..//Q:(LabItm'="")&(LabItm'=FunTheItmDr)
	..S AdmDr=$p(^DHCPHM(phMonID),"^",1)
	..q:'$d(^DHCANOPArrange(0,"Adm",AdmDr))
	..s Locdr=$p(^PAADM(AdmDr),"^",4)
	..q:(hospID'="")&(hospID'=$p($g(^CTLOC(Locdr)),"^",22))   //过滤病区
	..s OperIDList=..getOperIDList(AdmDr)  //获取病人做过的手术ID	//qunianpeng 2016/11/5
	..q:(OperID'="")&(OperIDList'[OperID)
	..s OrderID=$o(^OEORD(0,"Adm",AdmDr,""))  //获取医嘱ID
	..q:OrderID=""
	..s:ItmID="" ItmID=0
	..q:(ItmID'=0)&('$d(^OEORDi(0,"ARCIM",OrderID,ItmID))) //  当病人没有开过查询条件的医嘱时退出 qunianpeng 2016/11/5
	..S AdmDate=$p(^PAADM(AdmDr),"^",6)  //就诊日期
	..S AdmTime=$p(^PAADM(AdmDr),"^",7)  //就诊时间
	..S patVisit=$p($g(^PAADM(AdmDr)),"^",20)
    ..Q:patVisit'="A"
	..I AdmDate'="" S AdmDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(AdmDate) ;$zd(AdmDate,3)
	..I AdmTime'="" S AdmTime=$zt(AdmTime,1)
	..S AdmTime=AdmTime //_" "_admtime
	..S AdmWard=""
	..S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	..Q:(WardID'="")&(WardID'=AdmWardDr)
	..I AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //qunianpeng 2017/8/14 新版描述没有拼音码$p($p(^PAWARD(AdmWardDr),"^",2),"-",2) //病区
	..S bedid=$p(^PAADM(AdmDr),"^",73) //床号
    ..I bedid="" S AdmBed=""
    ..E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	..S Papmi=$p(^PAADM(AdmDr),"^",1)
	..S PatName=$p(^PAPER(Papmi,"ALL"),"^",1) //姓名
	..S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1) //登记号
	..Q:(RegNo'="")&(RegNo'=PatNo)
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
	..S ListData=AdmWard_"^"_AdmBed_"^"_PatNo_"^"_InMedicare_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatH_"^"_PatW_"^"_AdmDate_"^"_AdmLoc_"^"_AdmDr_"^"_PatDiag_"^"_ExpCause_"^"_AdmDoc
	..
	..S Num=Num+1
	..S index=AdmWard_"^"_AdmBed_"^"_AdmDate_"^"_PatNo
	..S ^TMP("DHCST","web.DHCSTPHCMOperMedimon","QueryInHosPatList",pid,index)=ListData
	.
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMOperMedimon","QueryInHosPatList",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMOperMedimon","QueryInHosPatList",pid,index)
	.S Title="Ward^Bed^PatNo^InMedicare^PatName^PatSex^PatAge^PatHeight^PatWeight^PatInDate^AdmLoc^AdmDr^PatDiag^ExpCause^AdmDoc"
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

/// Creator: qunianpeng
/// CreateDate: 2016-11-05
/// Descript: 在手术排班表中通过就诊ID获取手术ID
/// w ##class(web.DHCSTPHCMOperMedimon).getOperIDList("1362")
ClassMethod getOperIDList(EpisodeID As %String)
{

	s opaId=""
	s OperDesc=""
	s OperIDList=""
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
	.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	.s subchl=0 
	.f  s subchl=$O(^OR(EpisodeID,"ANA",chl,"OP",subchl)) q:(subchl="")  d
	..s opdr=$P(^OR(EpisodeID,"ANA",chl,"OP",subchl),"^",6) //手术名称
	..i OperIDList="" d
	...s OperIDList=opdr
	..e  d
	...s OperIDList=OperIDList_","_opdr
	..;i OperDesc'="" s OperDesc=OperDesc_";"
	..;i opdr'=""  d
	...;i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d
	....;s OperDesc=OperDesc_$P($g(^ORC("OPER",+opdr)),"^",2)
	..;e  d
	...;i $g(^OR(EpisodeID,"ANA",chl,"OP",subchl,"REM",2))'="" d
	....;s OperDesc=OperDesc_$g(^OR(EpisodeID,"ANA",chl,"OP",subchl,"REM",2))
	
	q OperIDList
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMOperMedimon","QueryInHosPatList",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMOperMedimon"))
}

}
