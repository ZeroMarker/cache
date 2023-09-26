Import sqluser

/// Descript:   药学咨询查询
/// Creator:    bianshuai
/// CreateDate: 2016-02-02
Class web.DHCSTPHCMCONSULTQUERY Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:药学咨询列表
/// w ##Class(web.DHCSTPHCMCONSULTQUERY).QueryPhConsult("10","1","2016-02-18^2016-03-18")
ClassMethod QueryPhConsult(rows As %String, page As %String, strParam As %String) As %String
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
	s InConsDesc=$p(strParam,"^",4)  //咨询描述
	s consStatus=$p(strParam,"^",5)  //咨询状态
	s InconsDept=$p(strParam,"^",6)  //咨询部门
	
	s consTypeCode=$p(strParam,"^",7) //咨询类型                 //xiugai
	s hospID=$p(strParam,"^",8)
	s consTypeID=##Class(web.DHCSTPHCMCONSULTQUERY).GetConsTypeByCode(consTypeCode)

	s Num=0
	s ansCount=""
	f dd=StartDate:1:EndDate d
	.s consDeptID=""
	.f  s consDeptID=$o(^DHCPHCONS(0,"DATELOC",dd,consDeptID)) Q:consDeptID=""  D
	..s consultID=""
	..f  s consultID=$o(^DHCPHCONS(0,"DATELOC",dd,consDeptID,consultID)) Q:consultID=""  D
	...;显示回复次数 duwensheng 2016-09-20
	...&sql(select count(*) into:ansCount from DHC_PHConsultDetail where PHCONTD_CON_ParRef=:consultID And PHCONTD_Desc!='')
	...//sql增加描述不为空条件  描述为空 认为没有回复 qunianpeng 2018/3/19	
	...s consDate=$p(^DHCPHCONS(consultID),"^",1)  ///咨询日期
	...s:consDate'="" consDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(consDate) ;$zd(consDate,3)
	...s consTime=$p(^DHCPHCONS(consultID),"^",2)  ///咨询时间
	...s:consTime'="" consTime=$zt(consTime,1)
	...s consName=$p(^DHCPHCONS(consultID),"^",3)  ///咨询人
	...i consName'="" s consName=$p(^SSU("SSUSR",consName),"^",2)
	...s consTypeDR=$p(^DHCPHCONS(consultID),"^",4)  ///咨询类型
	...Q:(consTypeID'="")&(consTypeID'=consTypeDR)
	...s consDept=$p(^DHCPHCONS(consultID),"^",5)  ///咨询部门
	...s locdr=$p(^DHCPHCONS(consultID),"^",5)
	...s hospital=$p(^CTLOC(locdr),"^",22)
	...q:(hospID'="")&(hospID'=hospital)   //过滤病区
	...q:(InconsDept'="")&(InconsDept'=consDept)
	...i consDept'=""  s consDept=$p(^CTLOC(consDept),"^",2)
	...s consDesc=$p(^DHCPHCONS(consultID),"^",6)  ///咨询描述
	...q:(InConsDesc'="")&(consDesc'[InConsDesc)
	...s finiFlag=$p(^DHCPHCONS(consultID),"^",7)  ///完成标志
	...i finiFlag="" s finiFlag="N"
	...q:(consStatus'="")&(consStatus'=finiFlag)
	...s consType=""  ///咨询类型
	...s quesType=+$p(^DHCPHCONS(consultID),"^",8)  ///问题类型
	...i quesType'="0" s quesType=$p($g(^DHCPHCONQT(quesType)),"^",2)
	...s consIden=$p(^DHCPHCONS(consultID),"^",9)  ///咨询身份
	...s consIden=$p(^CD.PHA.CPW.ConsIden(consIden),"^",2)
	...s consTele=$p(^DHCPHCONS(consultID),"^",13) ///联系电话
	...s consName=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",consName)
	...s consDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConsult","PHCONDesc","",consDesc)
	...s quesType=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConQueType","PHCONQTDesc","",quesType)
	...s consIden=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHACPWConsIden","CIDesc","",consIden)
	...s consDept=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLoc","CTLOCDesc","",consDept)

	...s ListData=consultID_"^"_consDate_"^"_consTime_"^"_consName_"^"_consDept_"^"_consDesc_"^"_consType_"^"_quesType_"^"_consIden_"^"_consTele_"^"_finiFlag_"^"_ansCount
	...
	...s Num=Num+1
	...s ^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryPhConsult",pid,Num)=ListData

	i Num="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	q:Num="0"

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	
	S ListTitle="consultID^consDate^consTime^consName^consDept^consDesc^consType^quesType^consIden^consTele^finiFlag^ansCount"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	
	S quitflag=0
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryPhConsult",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryPhConsult",pid,index)
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
///  w ##Class(web.DHCSTPHCMCONSULTQUERY).QyConsultDetail("15")
ClassMethod QyConsultDetail(consultID As %String) As %String
{
	n (consultID,%session)
	s consDate=$p(^DHCPHCONS(consultID),"^",1)  ///咨询日期
	s:consDate'="" consDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(consDate)  ;$zd(consDate,3)
	s consTime=$p(^DHCPHCONS(consultID),"^",2)  ///咨询时间
	s:consTime'="" consTime=$zt(consTime,1)
	s consUserID=$p(^DHCPHCONS(consultID),"^",3)  ///咨询人
	s consName="",consCode=""
	i consUserID'="" d
	.s consName=$p(^SSU("SSUSR",consUserID),"^",2)
	.s consCode=$p(^SSU("SSUSR",consUserID),"^",1)
	s consDeptDesc=""
	s consDept=$p(^DHCPHCONS(consultID),"^",5)  ///咨询部门
	i consDept'=""  s consDeptDesc=$p(^CTLOC(consDept),"^",2)
	s consDesc=$p(^DHCPHCONS(consultID),"^",6)  ///咨询描述
	s consType=""  ///咨询类型
	s quesTypeID=+$p(^DHCPHCONS(consultID),"^",8)  ///问题类型
	i quesTypeID'="0" s quesTypeDesc=$p($g(^DHCPHCONQT(quesTypeID)),"^",2)
	s consIden=$p(^DHCPHCONS(consultID),"^",9)  ///咨询身份
	i consIden=5  s consIdenDesc="患者"
	e  s consIdenDesc=$p(^CD.PHA.CPW.ConsIden(consIden),"^",2)
	s consTele=$p(^DHCPHCONS(consultID),"^",13) ///联系电话
	s consName=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",consName)
	s consDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConsult","PHCONDesc","",consDesc)
	s quesTypeDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConQueType","PHCONQTDesc","",quesTypeDesc)
	s consIdenDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHACPWConsIden","CIDesc","",consIdenDesc)
	s consDeptDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLoc","CTLOCDesc","",consDeptDesc)
	s ListData=consUserID_"^"_consName_"^"_consCode_"^"_consDept_"^"_consDesc_"^"_consType_"^"_quesTypeID_"^"_$g(quesTypeDesc)_"^"_consIden_"^"_consIdenDesc_"^"_consTele_"^"_consDate_"^"_consDeptDesc
 	
 	s ListTitle="consUserID^consName^consCode^consDept^consDesc^consType^quesType^quesTypeDesc^consIden^consIdenDesc^consTele^consDate^consDeptDesc"
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData,"^")
 	q ""
}

/// Descript:咨询答复明细列表
/// w ##Class(web.DHCSTPHCMCONSULTQUERY).QueryConsultBakDet("")
ClassMethod QueryConsultBakDet(rows As %String, page As %String, consultID As %String) As %String
{
	n (rows,page,consultID)

	s pid=..NewPid()
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行

	d ..killTmpGlobal(pid)
	
	s Num=0
	s CH=""
	f  s CH=$o(^DHCPHCOND(consultID,"I",CH)) Q:CH=""  D
	.s consItmID=consultID_"||"_CH
	.s consDDate=$p(^DHCPHCOND(consultID,"I",CH),"^",1)
	.s:consDDate'="" consDDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(consDDate) ;$zd(consDDate,3)  ///咨询日期
	.s consDTime=$p(^DHCPHCOND(consultID,"I",CH),"^",2)
	.s:consDTime'="" consDTime=$zt(consDTime,1)  ///咨询时间
	.s consDName=""
	.s consDUserID=$p(^DHCPHCOND(consultID,"I",CH),"^",3)
	.i consDUserID'="" s consDName=$p(^SSU("SSUSR",consDUserID),"^",2)
	.s consDDesc=$p(^DHCPHCOND(consultID,"I",CH),"^",4)		///描述
	.s consDOkFlag=$p(^DHCPHCOND(consultID,"I",CH),"^",6)	///采纳标志
	.q:consDDesc=""											/// 回复内容为空的记录不显示在咨询答复列表 qunianpeng 2018/3/21	
	.
	.s ListData=consItmID_"^"_consDDate_" "_consDTime_"^"_consDName_"^"_consDDesc_"^"_consDOkFlag
	.
	.s Num=Num+1
	.s ^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryConsultBakDet",pid,Num)=ListData

	q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	
	S ListTitle="consItmID^consDDate^consDName^consDDesc^consDOkFlag"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	
	S quitflag=0
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryConsultBakDet",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryConsultBakDet",pid,index)
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

/// Descript:患者类药学咨询列表
/// w ##Class(web.DHCSTPHCMCONSULTQUERY).QueryPatConsult("10","1","2016-09-07^2020-09-28^578^^^PHC^2")
/// w ##Class(web.DHCSTPHCMCONSULTQUERY).QueryPatConsult("10","1","2016-09-05^2016-09-05^578^^^")
ClassMethod QueryPatConsult(rows As %String, page As %String, strParam As %String) As %String
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
	s InConsDesc=$p(strParam,"^",4)  //咨询描述
	s consStatus=$p(strParam,"^",5)  //咨询状态
	s consTypeCode=$p(strParam,"^",6) //咨询类型
	s hospID=$p(strParam,"^",7)
	s consTypeID=##Class(web.DHCSTPHCMCONSULTQUERY).GetConsTypeByCode(consTypeCode)      //xiugai
	s ^TMP("ddd")=consTypeID
	
	s Num=0
	f dd=StartDate:1:EndDate d
	.s consQusTyID=""
	.f  s consQusTyID=$o(^DHCPHCONS(0,"DATEQETYPE",dd,consQusTyID)) Q:consQusTyID=""  D
	..s consultID=""
	..f  s consultID=$o(^DHCPHCONS(0,"DATEQETYPE",dd,consQusTyID,consultID)) Q:consultID=""  D
	...;i consultID=0 q:0
	...s consDate=$p(^DHCPHCONS(consultID),"^",1)  ///咨询日期
	...s:consDate'="" consDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(consDate) ;$zd(consDate,3)
	...s consTime=$p(^DHCPHCONS(consultID),"^",2)  ///咨询时间
	...s:consTime'="" consTime=$zt(consTime,1)
	...s consName=$p(^DHCPHCONS(consultID),"^",3)  ///记录人 or 咨询回复人
	...i consName'="" s consName=$p(^SSU("SSUSR",consName),"^",2)
	...s consTypeDR=$p(^DHCPHCONS(consultID),"^",4)  ///咨询类型                   //xiugai1 
	
	...Q:(consTypeID'="")&(consTypeID'=consTypeDR)
    ...s AdmDr=$p(^DHCPHCONS(consultID),"^",15)
	...s:AdmDr'="" Locdr=$p(^PAADM(AdmDr),"^",4)
	...q:(hospID'="")&(hospID'=$p($g(^CTLOC(Locdr)),"^",22))   //过滤病区
	...s consDeptDesc=""
	...s consDept=$p(^DHCPHCONS(consultID),"^",5)     ///咨询部门
	...i consDept'=""  s consDeptDesc=$p(^CTLOC(consDept),"^",2)
	...s consQusDesc=$p(^DHCPHCONS(consultID),"^",6)  ///咨询描述
	...q:(InConsDesc'="")&(consQusDesc'[InConsDesc)
	...s finiFlag=$p(^DHCPHCONS(consultID),"^",7)  	  ///完成标志
	...i finiFlag="" s finiFlag="N"
	...q:(consStatus'="")&(consStatus'=finiFlag)
	...s consIden=$p(^DHCPHCONS(consultID),"^",9)  	  ///咨询身份
	...i consIden=5  s consIdenDesc="患者"
	...e  s consIdenDesc=$p(^CD.PHA.CPW.ConsIden(consIden),"^",2)
	...s consType=""  ///咨询类型
	...s consQusType=$p(^DHCPHCONS(consultID),"^",8)  ///问题类型
	...i consQusType'="" s consQusTypeDesc=$p($g(^DHCPHCONQT(consQusType)),"^",2)
	...s consSpeCrowd=$p(^DHCPHCONS(consultID),"^",10) ///特殊人群
	...s consContact=$p(^DHCPHCONS(consultID),"^",13)  ///联系电话
	...s consPatientID=+$p(^DHCPHCONS(consultID),"^",14) ///病人ID
	...s CardNo=""
	...s CFRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",consPatientID,""))
 	...s:CFRowID'="" CardNo=$p($g(^DHCCARD("CF",CFRowID)),"^",2) ///卡号   
	...s consPatNo=$p($g(^PAPER(consPatientID,"PAT",1)),"^",1)  ///登记号
	...s consPatName=$p(^DHCPHCONS(consultID),"^",16)           ///病人姓名
	...s consPatSex=$p(^DHCPHCONS(consultID),"^",17) 			///性别
	...s consPatAge=$p(^DHCPHCONS(consultID),"^",18) 			///年龄
	...s consDiagDesc=$p(^DHCPHCONS(consultID),"^",19) 			///诊断信息 or 病情描述
	...s consWays=$p(^DHCPHCONS(consultID),"^",20) 				///咨询方式
	...s consRefMat=$p(^DHCPHCONS(consultID),"^",21) 			///参考资料
	...s consDuration=$p(^DHCPHCONS(consultID),"^",22) 			///服务时间
	...s consTraArc=$p(^DHCPHCONS(consultID),"^",23) 			///追踪建档
	...s consResDeptDesc=""
	...s consResDept=$p(^DHCPHCONS(consultID),"^",24) 			///预约科室
	...i consResDept'=""  s consResDeptDesc=$p(^CTLOC(consResDept),"^",2)
	...s consTipLimt=$p(^DHCPHCONS(consultID),"^",25) 			///服务期限
	...s:consTipLimt'="" consTipLimt=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(consTipLimt) ;$zd(consTipLimt,3)
	...s consTraWay=$p(^DHCPHCONS(consultID),"^",26) 			///追踪方式
	...s consAnsUser=$p(^DHCPHCONS(consultID),"^",27) 			///回答人员
	...s consTraRes=$p(^DHCPHCONS(consultID),"^",28) 			///追踪结果
	...s CH=$o(^DHCPHCOND(consultID,"I",""),-1) 
	...S consAnsDesc=""                                           //wangxuejian 2016-09-02                                   
	...S:CH'="" consAnsDesc=$p(^DHCPHCOND(consultID,"I",CH),"^",4)      
	...s consName=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",consName)
	...s consQusDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConsult","PHCONDesc","",consQusDesc)
	...s consQusTypeDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConQueType","PHCONQTDesc","",consQusTypeDesc)
	...s consIdenDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHACPWConsIden","CIDesc","",consIdenDesc)
	...s consPatName=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConsult","PHCONPatName","",consPatName)
	...s consDiagDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConsult","PHCONPatDiag","",consDiagDesc)
	...s consAnsDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConsultDetail","PHCONTDDesc","",consAnsDesc)
	...s consDeptDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLoc","CTLOCDesc","",consDeptDesc)
	...s consResDeptDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLoc","CTLOCDesc","",consResDeptDesc)
	...s ListData=consultID_"^"_consDate_"^"_consTime_"^"_consName_"^"_consQusDesc_"^"_consType_"^"_consQusType_"^"_consQusTypeDesc_"^"_consIden_"^"_consIdenDesc_"^"_consPatientID_"^"_consPatNo
	...s ListData=ListData_"^"_consPatName_"^"_consPatSex_"^"_consPatAge_"^"_consDiagDesc_"^"_consContact_"^"_consSpeCrowd_"^"_consWays_"^"_consRefMat
	...s ListData=ListData_"^"_consDuration_"^"_consTraArc_"^"_consResDept_"^"_consTipLimt_"^"_consTraWay_"^"_consAnsUser_"^"_consTraRes_"^"_finiFlag_"^"_consAnsDesc_"^"_consDept_"^"_consDeptDesc_"^"_consResDeptDesc_"^"_CardNo
	...
	...s Num=Num+1
	...s ^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryPatConsult",pid,Num)=ListData
	
	q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	
	S ListTitle="consultID^consDate^consTime^consName^consQusDesc^consType^consQusT^consQusTypeDesc^consIden^consIdenDesc^consPatientID^consPatNo^consPatName^consPatSex^consPatAge^consDiagDesc"
	S ListTitle=ListTitle_"^consContact^consSpeCrowd^consWays^consRefMat^consDuration^consTraArc^consResDept^consTipLimt^consTraWay^consAnsUser^consTraRes^finiFlag^consAnsDesc^consDept^consDeptDesc^consResDeptDesc^CardNo"
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	
	S quitflag=0
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryPatConsult",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryPatConsult",pid,index)
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

/// w ##class(web.DHCSTPHCMCONSULTQUERY).QueryConsDrgItmList("31")
ClassMethod QueryConsDrgItmList(consultID As %String) As %String
{
	N (consultID,%session)

	S pid=..NewPid()
	d ..killTmpGlobal(pid)

	S Num=0
	S ch=""
	F  S ch=$o(^DHCPHCONI(consultID,"D",ch)) Q:ch=""  D
	.S consDesc=$p(^DHCPHCONI(consultID,"D",ch),"^",2)
	.S consSpec=$p(^DHCPHCONI(consultID,"D",ch),"^",3)
	.S consForm=$p(^DHCPHCONI(consultID,"D",ch),"^",4)
	.S consManf=$p(^DHCPHCONI(consultID,"D",ch),"^",5)
	.S consInstruc=$p(^DHCPHCONI(consultID,"D",ch),"^",6)
	.S consDosage=$p(^DHCPHCONI(consultID,"D",ch),"^",7)
	.S consDuration=$p(^DHCPHCONI(consultID,"D",ch),"^",8)
	.s consDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConsultItm","PHCONIGoodsName","",consDesc)
	.s consForm=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConsultItm","PHCONIForm","",consForm)
	.s consManf=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConsultItm","PHCONIManf","",consManf)
	.s consInstruc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConsultItm","PHCONIInstruc","",consInstruc)
	.s consDuration=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConsultItm","PHCONIDuration","",consDuration)
	.S ListData=consDesc_"^"_consSpec_"^"_consForm_"^"_consManf_"^"_consInstruc
	.S ListData=ListData_"^"_consDosage_"^"_consDuration
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryConsDrgItmList",pid,Num)=ListData
	
	i 4>Num d
	.S Len=4-Num
	.f i=1:1:Len d
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryConsDrgItmList",pid,Num)=""

	i Num="0" w ##Class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	Q:Num="0"
	
	S ListTitle="consDesc^consSpec^consForm^consManf^consInstruc^consDosage^consDuration"
	S quitflag=0
	w ##Class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryConsDrgItmList",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryConsDrgItmList",pid,index)
	.S Num=Num+1
	.I Num=1 d
	..w ##Class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##Class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	
	w ##Class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript: 通过代码获取咨询类型ID    //xiugai
/// w ##Class(web.DHCSTPHCMCONSULTQUERY).GetConsTypeByCode("PAT")
ClassMethod GetConsTypeByCode(ConsTypeCode As %String) As %String
{
	n (ConsTypeCode)
	Q:ConsTypeCode="" ""
	s ConsTypeID=$o(^DHCPHCONT(0,"Code",$$ALPHAUP^SSUTIL4(ConsTypeCode),""))
	s ^F("q")=ConsTypeID
	Q ConsTypeID
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryPhConsult",pid)
	k ^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryConsultBakDet",pid)
	k ^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryPatConsult",pid)
	k ^TMP("DHCST","web.DHCSTPHCMCONSULTQUERY","QueryConsDrgItmList",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMCONSULTQUERY"))
}

}
