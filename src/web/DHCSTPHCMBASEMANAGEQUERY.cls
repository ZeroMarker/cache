Import sqluser

/// Descript:   基地管理查询
/// Creator:    bianshuai
/// CreateDate: 2016-02-02
Class web.DHCSTPHCMBASEMANAGEQUERY Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:带教老师列表
/// d ##Class(web.DHCSTPHCMBASEMANAGEQUERY).QuerybmTeaList("10","1","2016-02-18^2016-03-18")
ClassMethod QuerybmTeaList(rows As %String, page As %String, strParam As %String) As %String
{
	n (rows,page,strParam,%session)

	s pid=..NewPid()
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行

	d ..killTmpGlobal(pid)
	s StartDate=$p(strParam,"^",1)   //开始日期
	s EndDate=$p(strParam,"^",2)     //结束日期
	s StartDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(StartDate) ;$zdh(StartDate,3)
	s EndDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(EndDate) ;$zdh(EndDate,3)
	s userCode=$p(strParam,"^",3)  //工号
	s hospID=$p(strParam,"^",4)
	s userName=$p(strParam,"^",5)
	s Num=0
	F dd=StartDate:1:EndDate D
	.s bmTeaID=""
	.f  s bmTeaID=$o(^DHCPHBMT(0,"RepDate",dd,bmTeaID)) Q:bmTeaID=""  D
	..s bmTUserID=$p(^DHCPHBMT(bmTeaID),"^",1)  ///用户ID
	..q:bmTUserID=""
	..s bmTUserCode=$p(^SSU("SSUSR",bmTUserID),"^",1)
	..q:(userCode'="")&($zcvt(bmTUserCode,"U")'=$zcvt(userCode,"U"))
	..s bmTUserName=$p(^SSU("SSUSR",bmTUserID),"^",2)
	..q:(userName'="")&(bmTUserName'[userName)
	..s bmTSex=""
	..s bmTSexID=$p(^DHCPHBMT(bmTeaID),"^",2)   ///性别
	..i bmTSexID'="" s bmTSex=$p(^CT("SEX",bmTSexID),"^",2)
	..s bmTEduca=$p(^DHCPHBMT(bmTeaID),"^",3)   ///学历
    ..s bmTEducaDesc=$s(bmTEduca="1":"博士及以上",bmTEduca="2":"硕士",bmTEduca="3":"本科",bmTEduca="4":"大专",1:"")
	..s bmTLoc=""
	..s bmTLocID=$p(^DHCPHBMT(bmTeaID),"^",4)   ///科室
	..q:(hospID'="")&(hospID'=$p(^CTLOC(bmTLocID),"^",22))   //过滤病区
	..s:bmTLocID'="" bmTLoc=$p(^CTLOC(bmTLocID),"^",2)
	..s bmTCareer=$p(^DHCPHBMT(bmTeaID),"^",5)  ///带教专业
	..s bmTCareerDesc=$p($g(^DHCPHPDT(bmTCareer)),"^",2)
	..s bmTCarePrvID=+$p(^DHCPHBMT(bmTeaID),"^",6) //职称
	..s bmTCarePrvTP=$p($g(^CT("CPT",bmTCarePrvID)),"^",2)
	..s bmTDate=$p(^DHCPHBMT(bmTeaID),"^",7)  ///增加日期
	..s:bmTDate'="" bmTDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(bmTDate)  ;$zd(bmTDate,3)
	..s bmTTime=$p(^DHCPHBMT(bmTeaID),"^",8)  ///增加时间
	..s:bmTTime'="" bmTTime=$zt(bmTTime,1)
	..s bmTRemark=$p(^DHCPHBMT(bmTeaID),"^",9)  ///备注
	..s bmTAge=$p(^DHCPHBMT(bmTeaID),"^",10)
	..s bmTClinicalDate=$p(^DHCPHBMT(bmTeaID),"^",12)
	..s:bmTClinicalDate'="" bmTClinicalDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(bmTClinicalDate)
	..s bmTTeacherDate=$p(^DHCPHBMT(bmTeaID),"^",13)
	..s:bmTTeacherDate'="" bmTTeacherDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(bmTTeacherDate)
	..s bmStuID="",bmSNameStr=""
	..f  s bmStuID=$o(^DHCPHBMS(0,"Teacher",bmTUserID,bmStuID)) Q:bmStuID=""  D 
	...s bmSCareer=$p(^DHCPHBMS(bmStuID),"^",6)      ///培训专业
	...q:bmTCareer'=bmSCareer
	...s bmSName=$p(^DHCPHBMS(bmStuID),"^",1)    ///带教学员姓名
	...q:bmSNameStr[bmSName
	...i bmSNameStr=""  s bmSNameStr=bmSName
	...e  s bmSNameStr=bmSNameStr_","_bmSName
	..s bmTUserName=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",bmTUserName)
	..s bmTCarePrvTP=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",bmTCarePrvTP)
	..s bmTSex=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",bmTSex)
	..s bmTEducaDesc=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(bmTEducaDesc)
	..s bmTLoc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLoc","CTLOCDesc","",bmTLoc)
	..s bmTCareerDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHProfDirection","PHPDDesc","",bmTCareerDesc)
	..s bmTRemark=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHBasManTeacher","PHBMTRemark","",bmTRemark)
	..s ListData=bmTeaID_"^"_bmTUserID_"^"_bmTUserCode_"^"_bmTUserName_"^"_bmTCarePrvID_"^"_bmTCarePrvTP_"^"_bmTSexID_"^"_bmTSex_"^"_bmTEduca_"^"_bmTEducaDesc_"^"_bmTLocID_"^"_bmTLoc_"^"_bmTCareer_"^"_bmTCareerDesc_"^"_bmTDate_"^"_bmTTime_"^"_bmTRemark_"^"_bmTAge_"^"_bmTClinicalDate_"^"_bmTTeacherDate_"^"_bmSNameStr
	..
	..s Num=Num+1
	..s ^TMP("DHCST","web.DHCSTPHCMBASEMANAGEQUERY","QuerybmTeaList",pid,Num)=ListData

	i Num="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	q:Num="0" 

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	
	S ListTitle="bmTeaID^bmTUserID^bmTUserCode^bmTUserName^bmTCarePrvID^bmTCarePrvTP^bmTSexID^bmTSex^bmTEduca^bmTEducaDesc^bmTLocID^bmTLoc^bmTCareer^bmTCareerDesc^bmTDate^bmTTime^bmTRemark^bmTAge^bmTClinicalDate^bmTTeacherDate^bmSNameStr"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	
	S quitflag=0
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMBASEMANAGEQUERY","QuerybmTeaList",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMBASEMANAGEQUERY","QuerybmTeaList",pid,index)
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

///  Descript:药学咨询
///  w ##Class(web.DHCSTPHCMBASEMANAGEQUERY).QueryUserInfo("15")
ClassMethod QueryUserInfo(usercode As %String) As %String
{
	n (usercode,%session)
	s bmTUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	i bmTUserID="" w "{}"
	q:bmTUserID="" ""
	s bmTUserCode=$p(^SSU("SSUSR",bmTUserID),"^",1) ///用户工号
	s bmTUserName=$p(^SSU("SSUSR",bmTUserID),"^",2) ///用户姓名
	s bmTUserGroup=$p(^SSU("SSUSR",bmTUserID),"^",5)
	s bmTUserName=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",bmTUserName)
	s ListData=bmTUserID_"^"_bmTUserCode_"^"_bmTUserName_"^"_bmTUserGroup
 	
 	s ListTitle="bmTUserID^bmTUserCode^bmTUserName^bmTUserGroup"
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData,"^")
 	q ""
}

/// Descript:基地学员列表
/// w ##Class(web.DHCSTPHCMBASEMANAGEQUERY).QuerybmStudentList("10","1","2016-02-18^2016-03-18")
ClassMethod QuerybmStudentList(rows As %String, page As %String, strParam As %String) As %String
{
	n (rows,page,strParam,%session)

	s pid=..NewPid()
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行

	d ..killTmpGlobal(pid)
	s StartDate=$p(strParam,"^",1)   //开始日期
	s EndDate=$p(strParam,"^",2)     //结束日期
	s StartDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(StartDate) ;$zdh(StartDate,3)
	s EndDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(EndDate) ;$zdh(EndDate,3)
	s userName=$p(strParam,"^",3)    //姓名
	s Career=$p(strParam,"^",4)
	s TrainStartDate=$p(strParam,"^",5)   //开始日期
	s TrainEndDate=$p(strParam,"^",6)     //结束日期
	s TrainStartDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(TrainStartDate) ;$zdh(StartDate,3)
	s TrainEndDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(TrainEndDate) ;$zdh(EndDate,3)
	s Num=0
	s bmStuID=""
	f date=StartDate:1:EndDate d
	.f  s bmStuID=$o(^DHCPHBMS(bmStuID)) Q:bmStuID=""  D
	..q:bmStuID=0
	..s bmSName=$p(^DHCPHBMS(bmStuID),"^",1)    ///姓名
	..q:(userName'="")&(bmSName'[userName)
	
	..s bmSSex=""
	..s bmSSexID=$p(^DHCPHBMS(bmStuID),"^",2)   ///性别
	..i bmSSexID'="" s bmSSex=$p(^CT("SEX",bmSSexID),"^",2)
	..s bmSAge=$p(^DHCPHBMS(bmStuID),"^",3)     ///年龄
	..s bmSEdu=$p(^DHCPHBMS(bmStuID),"^",4)     ///学历
    ..s bmSEducaDesc=$s(bmSEdu="1":"博士及以上",bmSEdu="2":"硕士",bmSEdu="3":"本科",bmSEdu="4":"大专",1:"")
	..s bmSCarePrvID=$p(^DHCPHBMS(bmStuID),"^",5)    ///职称
	..s bmSCarePrvTP=$p($g(^CT("CPT",bmSCarePrvID)),"^",2)
	..s bmSCareer=$p(^DHCPHBMS(bmStuID),"^",6)      ///培训专业
	..q:(Career'="")&(Career'=bmSCareer)
	..s bmSCareerDesc=$p($g(^DHCPHPDT(bmSCareer)),"^",2)
	..s bmSWorkUnit=$p(^DHCPHBMS(bmStuID),"^",7)    ///工作单位
	..s bmSBegEduDate=$p(^DHCPHBMS(bmStuID),"^",8)  ///开学时间
	..s:bmSBegEduDate'="" bmSBegEduDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(bmSBegEduDate) ;$zd(bmSBegEduDate,3)
	..s bmSEndEduDate=$p(^DHCPHBMS(bmStuID),"^",9)  ///毕业时间
	..s:bmSEndEduDate'="" bmSEndEduDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(bmSEndEduDate) ;$zd(bmSEndEduDate,3)
	..s bmSOutProFlag=$p(^DHCPHBMS(bmStuID),"^",10) ///是否省外
	..s bmSOutProFlagDesc=$s(bmSOutProFlag="1":"是",bmSOutProFlag="2":"否",1:"")
	..s bmSAddDate=$p(^DHCPHBMS(bmStuID),"^",11)    ///增加日期
	..s:bmSAddDate'="" bmSAddDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(bmSAddDate) ;$zd(bmSAddDate,3)
	..s bmSAddTime=$p(^DHCPHBMS(bmStuID),"^",12)    ///增加时间
	..s:bmSAddTime'="" bmSAddTime=$zt(bmSAddTime,1)
	..s bmSRemark=$p(^DHCPHBMS(bmStuID),"^",13)     ///备注
	..;按时间查询 duwensheng 2016-09-14
	..q:(date'=$p(^DHCPHBMS(bmStuID),"^",11))
	..s bmSProfession=$p(^DHCPHBMS(bmStuID),"^",15)
	..s bmSProfessionDesc=$s(bmSProfession="1":"临床药学",bmSProfession="2":"药学",bmSProfession="3":"药物制剂",bmSProfession="4":"药物分析",bmSProfession="5":"药物化学",bmSProfession="6":"药理学",bmSProfession="7":"药剂学",bmSProfession="8":"中药学及其他",1:"")
	..s bmSHigEdu=$p(^DHCPHBMS(bmStuID),"^",16)
	..s bmSHigEduDesc=$s(bmSHigEdu="1":"博士及以上",bmSHigEdu="2":"硕士",bmSHigEdu="3":"本科",bmSHigEdu="4":"大专",1:"")
	..s bmSTopProfession=$p(^DHCPHBMS(bmStuID),"^",17)
	..s bmSTopProfessionDesc=$s(bmSTopProfession="1":"临床药学",bmSTopProfession="2":"药学",bmSTopProfession="3":"药物制剂",bmSTopProfession="4":"药物分析",bmSTopProfession="5":"药物化学",bmSTopProfession="6":"药理学",bmSTopProfession="7":"药剂学",bmSTopProfession="8":"中药学及其他",1:"")
	..s bmSTeacher=$p(^DHCPHBMS(bmStuID),"^",18)
	..S:bmSTeacher'="" bmSTeacherDesc=$p(^SSU("SSUSR",bmSTeacher),"^",2)
	..s TrainDate=$p(^DHCPHBMS(bmStuID),"^",19)
	..S bmSTrainDate=""
	..q:((TrainStartDate'="")&(TrainStartDate>TrainDate))||((TrainEndDate'="")&(TrainEndDate<TrainDate))
	..s:TrainDate'="" bmSTrainDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(TrainDate)
	..s bmSIsAssessment=$p(^DHCPHBMS(bmStuID),"^",20)
	..s bmSIsAssessmentDesc=$s(bmSIsAssessment="0":"否",bmSIsAssessment="1":"是",1:"")
	..s bmSName=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHBasManStudent","PHBMSName","",bmSName)
	..s bmSSex=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",bmSSex)
	..s bmSCarePrvTP=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",bmSCarePrvTP)	
	..s bmSEducaDesc=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(bmSEducaDesc)
	..s bmSCareerDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHProfDirection","PHPDDesc","",bmSCareerDesc)
	..s bmSWorkUnit=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHBasManStudent","PHBMSWorkUnit","",bmSWorkUnit)
	..s bmSRemark=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHBasManStudent","PHBMSRemark","",bmSRemark )
	..s bmSOutProFlagDesc=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(bmSOutProFlagDesc)
	..s ListData=bmStuID_"^"_bmSName_"^"_bmSSexID_"^"_bmSSex_"^"_bmSAge_"^"_bmSEdu_"^"_bmSEducaDesc_"^"_bmSCarePrvID_"^"_bmSCarePrvTP_"^"_bmSCareer_"^"_bmSCareerDesc
	..s ListData=ListData_"^"_bmSWorkUnit_"^"_bmSBegEduDate_"^"_bmSEndEduDate_"^"_bmSOutProFlag_"^"_bmSOutProFlagDesc_"^"_bmSAddDate_"^"_bmSAddTime_"^"_bmSRemark
	..s ListData=ListData_"^"_bmSProfession_"^"_bmSProfessionDesc_"^"_bmSHigEdu_"^"_bmSHigEduDesc_"^"_bmSTopProfession_"^"_bmSTopProfessionDesc_"^"_bmSTeacher
	..s ListData=ListData_"^"_bmSTeacherDesc_"^"_ bmSTrainDate_"^"_ bmSIsAssessment_"^"_ bmSIsAssessmentDesc
	..
	..s Num=Num+1
	..s ^TMP("DHCST","web.DHCSTPHCMBASEMANAGEQUERY","QuerybmStudentList",pid,bmSCareer,TrainDate,Num)=ListData
	
	i Num="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	q:Num="0" 
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	
	S ListTitle="bmStuID^bmSName^bmSSexID^bmSSex^bmSAge^bmSEdu^bmSEducaDesc^bmSCarePrvID^bmSCarePrvTP^bmSCareer^bmSCareerDesc^bmSWorkUnit^bmSBegEduDate^bmSEndEduDate^bmSOutProFlag^bmSOutProFlagDesc^bmSAddDate^bmSAddTime^bmSRemark^bmSProfession^bmSProfessionDesc^bmSHigEdu^bmSHigEduDesc^bmSTopProfession^bmSTopProfessionDesc^bmSTeacher^bmSTeacherDesc^bmSTrainDate^bmSIsAssessment^bmSIsAssessmentDesc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	
	S quitflag=0
	S Num=0
	s ID=""
	F  S ID=$o(^TMP("DHCST","web.DHCSTPHCMBASEMANAGEQUERY","QuerybmStudentList",pid,ID)) q:ID=""||(quitflag=1)  D
	.s Date=""
	.F  S Date=$o(^TMP("DHCST","web.DHCSTPHCMBASEMANAGEQUERY","QuerybmStudentList",pid,ID,Date)) q:Date=""  d
	..S index=""
	..F  S index=$o(^TMP("DHCST","web.DHCSTPHCMBASEMANAGEQUERY","QuerybmStudentList",pid,ID,Date,index)) Q:(index="")   d
	...S ListData=^TMP("DHCST","web.DHCSTPHCMBASEMANAGEQUERY","QuerybmStudentList",pid,ID,Date,index)
	...S Num=Num+1
	...Q:Num<StPage
	...S:Num=EndPage quitflag=1
	...I Num=StPage d
	....w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	...e  d
	....w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:查询[专业方向]
/// Table:DHC_PH ProfDirection
/// w ##class(web.DHCSTPHCMBASEMANAGEQUERY).QueryProDirect("12","1","")
ClassMethod QueryProDirect(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
	s h=0,count=0
	s ID="0"
	f  s ID=$o(^DHCPHPDT(ID)) q:ID=""  d
	.s Code=$p(^DHCPHPDT(ID),"^",1) //代码
	.s Desc=$p(^DHCPHPDT(ID),"^",2) //描述
	.s h=h+1
	.s TempStr=ID_"^"_Code_"^"_Desc
	.s ^TMP("DHCST","web.DHCSTPHCMBASEMANAGEQUERY","QueryProDirect",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMBASEMANAGEQUERY","QueryProDirect",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMBASEMANAGEQUERY","QueryProDirect",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descritp:专业方向
/// 
ClassMethod SelProDirect() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PHPD_RowID,PHPD_Desc FROM DHC_PHProfDirection"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s SexDr = result.Data("PHPD_RowID")
		s SexDesc = result.Data("PHPD_Desc")
		s SexDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHProfDirection","PHPDDesc","",SexDesc)
		s tmp=SexDr_"^"_SexDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMBASEMANAGEQUERY","QuerybmTeaList",pid)
	k ^TMP("DHCST","web.DHCSTPHCMBASEMANAGEQUERY","QuerybmStudentList",pid)
	k ^TMP("DHCST","web.DHCSTPHCMBASEMANAGEQUERY","QueryProDirect",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMBASEMANAGEQUERY"))
}

}
