Import SQLUser

/// Creator: bianshuai
/// CreateDate: 2014-09-23
/// Descript: 药历查询
Class web.DHCSTPHCMMEDRECORDS Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:查询药历
/// w ##class(web.DHCSTPHCMMEDRECORDS).QueryMedRecord(200,1,"2014-09-23^2014-09-23")
ClassMethod QueryMedRecord(rows As %String, page As %String, input As %String) As %String
{
	N (rows,page,input)

	S pid=..NewPid()
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S StDate=$p(input,"^",1)   //开始日期
	S EndDate=$p(input,"^",2)   //结束日期
	
	S Num="0"
	S StDate=$zdh(StDate,3)
	S EndDate=$zdh(EndDate,3)
	S EPRDocID=" 319",EPRNum="1"
	F DD=StDate:1:EndDate  D
	.S DD=" "_DD
	.S Time=""
	.F  S Time=$o(^DHCEPRI.EPRLogsI("IdxCreateDateTime",DD,Time)) Q:Time=""  D
	..S EpisodeID=""
	..F  S EpisodeID=$o(^DHCEPRI.EPRLogsI("IdxCreateDateTime",DD,Time,EpisodeID)) Q:EpisodeID=""  D
	...S ID=""
	...F  S ID=$o(^DHCEPRI.EPRLogsI("IdxCreateDateTime",DD,Time,EpisodeID,EPRDocID,EPRNum,ID)) Q:ID=""  D
    ....S objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(ID)
	....Q:objEPRLogs=""
	....S CreateUserID=objEPRLogs.CreateUserID //创建人
	....S CreateDate=objEPRLogs.CreateDate  //创建日期
	....S CreateTime=objEPRLogs.CreateTime  //创建时间
	....S:CreateDate'="" CreateTime=$zd(CreateDate,3)_" "_$zt(CreateTime,1)
	....S CreateUser=""
	....S:CreateUserID'="" CreateUser=$p(^SSU("SSUSR",CreateUserID),"^",2)
	....S AdmDr=$tr(EpisodeID," ","")
	....S AdmDate=$p(^PAADM(AdmDr),"^",6)  //就诊日期
	....S AdmTime=$p(^PAADM(AdmDr),"^",7)  //就诊时间
	....S:AdmDate'="" AdmDate=$zd(AdmDate,3)
	....S AdmWard=""
	....S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	....//Q:(WardID'="")&(WardID'=AdmWardDr)
	....I AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //病区
	....S bedid=$p(^PAADM(AdmDr),"^",73) //床号
    ....I bedid="" S AdmBed=""
    ....E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	....S Papmi=$p(^PAADM(AdmDr),"^",1)
	....S PatName=$p(^PAPER(Papmi,"ALL"),"^",1) //姓名
	....S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1) //登记号
	....S InMedicare=$p($g(^PAPER(Papmi,"PAT",3)),"^",4) ;病案号
	....S SexID=$p(^PAPER(Papmi,"ALL"),"^",7 )  //姓别
	....S PatSex=$p(^CT("SEX",SexID),"^",2)
	....S PatAge=##class(PHA.FACE.IN.Com).GetAge(Papmi,AdmDr)  //年龄
	....S PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",") //诊断
	....S AdmLoc=$p(^PAADM(AdmDr),"^",4) //科室
	....S:AdmLoc'="" AdmLoc=$p($p(^CTLOC(AdmLoc),"^",2),"-",2)
	....S ListData=AdmWard_"^"_AdmBed_"^"_PatNo_"^"_InMedicare_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_AdmDate_"^"_AdmLoc_"^"_AdmDr_"^"_PatDiag_"^"_CreateTime_"^"_CreateUser
	....
	....S Num=Num+1
	....S index=AdmWard_"^"_AdmBed_"^"_AdmDate_"^"_PatNo
	....S ^TMP("DHCST","web.DHCSTPHCMMEDRECORDS","QueryMedRecord",pid,index)=ListData
	.S DD=$tr(DD," ","")

	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMMEDRECORDS","QueryMedRecord",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMMEDRECORDS","QueryMedRecord",pid,index)
	.S Title="Ward^Bed^PatNo^InMedicare^PatName^PatSex^PatAge^PatInDate^AdmLoc^AdmDr^PatDiag^CreateTime^CreateUser"
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

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMMEDRECORDS","QueryMedRecord",pid)
	k ^TMP("DHCST","web.DHCSTPHCMMEDRECORDS","QueryInHosPatList",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMMEDRECORDS"))
}

/// Descript:查询在院病人列表
/// w ##class(web.DHCSTPHCMMEDRECORDS).QueryInHosPatList("20","1","180")
ClassMethod QueryInHosPatList(rows As %String, page As %String, input As %String) As %String
{
	N (rows,page,input)
	S pid=..NewPid()
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S wardID=$p(input,"^",1)   //病区
	S ^BIANSHUAI(123)=rows_"||"_page_"||"_input
	d ..killTmpGlobal(pid)	//k掉临时global
	S QuitFlag=0
	S Num=0
	S curRoomDr=""
	F  S curRoomDr=$o(^PAADMi("CurrWard",wardID,curRoomDr)) Q:curRoomDr=""  D
	.S AdmDr=""
	.F  S AdmDr=$o(^PAADMi("CurrWard",wardID,curRoomDr,AdmDr)) Q:AdmDr=""  D
	..//S AdmDr=""
	..//F  S AdmDr=$o(^PAADMi("PAADM_Type","I",AdmDr)) Q:(Num>500)||(AdmDr="")||(QuitFlag=1)  D
	..S AdmDate=$p(^PAADM(AdmDr),"^",6)  //就诊日期
	..S AdmTime=$p(^PAADM(AdmDr),"^",7)  //就诊时间
	..S patVisit=$p($g(^PAADM(AdmDr)),"^",20)
    ..Q:patVisit'="A"
	..I AdmDate'="" S AdmDate=$zd(AdmDate,3)
	..I AdmTime'="" S AdmTime=$zt(AdmTime,1)
	..S AdmTime=AdmTime //_" "_admtime
	..S AdmWard=""
	..S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	..I AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //病区
	..S bedid=$p(^PAADM(AdmDr),"^",73) //床号
    ..I bedid="" S AdmBed=""
    ..E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	..S Papmi=$p(^PAADM(AdmDr),"^",1)
	..S PatName=$p(^PAPER(Papmi,"ALL"),"^",1) //姓名
	..S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1) //登记号
	..S InMedicare=$p($g(^PAPER(Papmi,"PAT",3)),"^",4) ;病案号
	..S SexID=$p(^PAPER(Papmi,"ALL"),"^",7 )  //姓别
	..S PatSex=$p(^CT("SEX",SexID),"^",2)
	..S PatAge=##class(PHA.FACE.IN.Com).GetAge(Papmi,AdmDr)  //年龄
	..S PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",") //诊断
	..S PatW=##class(PHA.COM.Order).PatWeight(AdmDr) //体重
	..S PatH=##class(PHA.COM.Order).PatHeight(AdmDr) //身高
	..S AdmLoc=$p(^PAADM(AdmDr),"^",4) //科室
	..S:AdmLoc'="" AdmLoc=$p($p(^CTLOC(AdmLoc),"^",2),"-",2)
	..S ListData=AdmWard_"^"_AdmBed_"^"_PatNo_"^"_InMedicare_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatH_"^"_PatW_"^"_AdmDate_"^"_AdmLoc_"^"_AdmDr_"^"_PatDiag_"^"_Papmi
	..
	..S Num=Num+1
	..S index=AdmWard_"^"_AdmBed_"^"_AdmDate_"^"_PatNo
	..S ^TMP("DHCST","web.DHCSTPHCMMEDRECORDS","QueryInHosPatList",pid,index)=ListData
	.
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMMEDRECORDS","QueryInHosPatList",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMMEDRECORDS","QueryInHosPatList",pid,index)
	.S Title="Ward^Bed^PatNo^InMedicare^PatName^PatSex^PatAge^PatHeight^PatWeight^PatInDate^AdmLoc^AdmDr^PatDiag^PatientID"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)  //k掉临时global
	q ""
}

}
