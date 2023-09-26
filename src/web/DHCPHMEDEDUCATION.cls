Import SQLUser

/// Creator:    bianshuai
/// CreateDate: 2014-11-27
/// Descript:   用药教育
Class web.DHCPHMEDEDUCATION Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:用药教育
/// w ##class(web.DHCPHMEDEDUCATION).SaveMedEducation("13","16243032^In^^^^10^1111^21679^1.骨折,2.骨折!5!16149701||14,16149701||15,16149701||14,16149701||15")
ClassMethod SaveMedEducation(medEduID As %String, medEduDataList As %String) As %String
{
	n (medEduID,medEduDataList)
	s medEduMasDataList=$p(medEduDataList,"!",1) //用药教育主信息
	s medEduGuiConList=$p(medEduDataList,"!",2)  //指导内容
	s medEduDrgItmList=$p(medEduDataList,"!",3)  //药品关注
	s ret=0
	i medEduID="" d
	.S ret=..Insert(medEduMasDataList,medEduGuiConList,medEduDrgItmList)
	e  d
	.S ret=..Update(medEduID,medEduMasDataList,medEduGuiConList,medEduDrgItmList)
	q ret
}

/// Descript:用药教育
ClassMethod Insert(medEduMasDataList, medEduGuiConList, medEduDrgItmList) As %String
{
	N (medEduMasDataList,medEduGuiConList,medEduDrgItmList)
	s Err=0

	TS
	//用药教育主表
	s medEduID=..InsMedEducation(medEduMasDataList)
	i medEduID<0 tro
	q:medEduID<0 medEduID

	//用药指导内容
	i medEduGuiConList'="" d
	.s Err=..InsMedEduGuiContent(medEduID, medEduGuiConList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//相关药品
	i medEduDrgItmList'="" d
	.s Err=..InsMedEduDrgItm(medEduID, medEduDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-12"

	TC
	Q 0
}

/// Descript:每日病情记录表
ClassMethod Update(medEduID, medEduMasDataList, medEduGuiConList, medEduDrgItmList) As %String
{
	N (medEduID,medEduMasDataList,medEduGuiConList,medEduDrgItmList)
	s Err=0

	TS
	//查房主表
	s Err=..UpdMedEducation(medEduID,medEduMasDataList)
	i Err<0 tro
	q:Err<0 "-10"

	//删除相关子表
	s Err=..DelMedEduRelaTable(medEduID)
	i Err'=0 tro
	q:Err'=0 Err
	
	//用药指导内容
	i medEduGuiConList'="" d
	.s Err=..InsMedEduGuiContent(medEduID, medEduGuiConList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//相关药品
	i medEduDrgItmList'="" d
	.s Err=..InsMedEduDrgItm(medEduID, medEduDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-12"

	TC
	Q 0
}

/// Descript:插入查房信息
ClassMethod InsMedEducation(medEduMasDataList As %String) As %String
{
	N (medEduMasDataList)
	S MEAdmDr=$p(medEduMasDataList,"^",1)        //病人Adm
	S MECurStatus=$p(medEduMasDataList,"^",2)    //当前状态
	i MECurStatus="New" s MECurStatus="N"
	else  if MECurStatus="In" s MECurStatus="I"
	else  s MECurStatus="O"
	S MEBadHabits=$p(medEduMasDataList,"^",3)    //不良嗜好
	S MEConDisAndTre=$p(medEduMasDataList,"^",4) //伴发疾病与用药情况
	S MEGrantFlag=$p(medEduMasDataList,"^",5)    //发放临床药师联系卡
	S MEGuidObject=$p(medEduMasDataList,"^",6)   //指导对象
	S MEGuidContent=$p(medEduMasDataList,"^",7)  //指导意见/内容
	S MEUserDr=$p(medEduMasDataList,"^",8)       //记录人
	S MEIcd=$p(medEduMasDataList,"^",9)          //诊断
	S modPhone=$p(medEduMasDataList,"^",10)      //电话
	S address=$p(medEduMasDataList,"^",11)       //家庭住址
	S MEDate=+$H                                 //记录日期
	S METime=$p($H,",",2)                        //记录时间
	s otherObject=$p(medEduMasDataList,"^",12)	 //指导对象（其他）
	
	&SQL(Insert Into DHC_PHMedEducation(PHME_Adm_Dr,PHME_CurStatus,PHME_User_Dr,PHME_Date,PHME_Time,PHME_BadHabits,PHME_ConDisAndTre,PHME_GrantFlag,PHME_GuidObject,PHME_GuidContent,PHME_Icd,PHME_MobPhone,PHME_Address,PHME_OtherObject) 
		Values(:MEAdmDr,:MECurStatus,:MEUserDr,:MEDate,:METime,:MEBadHabits,:MEConDisAndTre,:MEGrantFlag,:MEGuidObject,:MEGuidContent,:MEIcd,:modPhone,:address,:otherObject))
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:更新查房信息
ClassMethod UpdMedEducation(medEduID As %String, medEduMasDataList As %String) As %String
{
	N (medEduID,medEduMasDataList)
	S MEAdmDr=$p(medEduMasDataList,"^",1)        //病人Adm
	S MECurStatus=$p(medEduMasDataList,"^",2)    //当前状态
	S MECurStatus=$p(medEduMasDataList,"^",2)    //当前状态
	i MECurStatus="New" s MECurStatus="N"
	else  if MECurStatus="In" s MECurStatus="I"
	else  s MECurStatus="O"
	S MEBadHabits=$p(medEduMasDataList,"^",3)    //不良嗜好
	S MEConDisAndTre=$p(medEduMasDataList,"^",4) //伴发疾病与用药情况
	S MEGrantFlag=$p(medEduMasDataList,"^",5)    //发放临床药师联系卡
	S MEGuidObject=$p(medEduMasDataList,"^",6)   //指导对象
	S MEGuidContent=$p(medEduMasDataList,"^",7)  //指导意见/内容
	S MEUserDr=$p(medEduMasDataList,"^",8)       //记录人
	S MEIcd=$p(medEduMasDataList,"^",9)          //诊断
	S modPhone=$p(medEduMasDataList,"^",10)      //电话
	S address=$p(medEduMasDataList,"^",11)       //家庭住址
	S MEDate=+$H                                 //记录日期
	S METime=$p($H,",",2)                        //记录时间
	s otherObject=$p(medEduMasDataList,"^",12)	 //指导对象（其他）
	
	&SQL(Update DHC_PHMedEducation Set PHME_Adm_Dr=:MEAdmDr,PHME_CurStatus=:MECurStatus,PHME_User_Dr=:MEUserDr,
		PHME_Date=:MEDate,PHME_Time=:METime,PHME_BadHabits=:MEBadHabits,PHME_ConDisAndTre=:MEConDisAndTre,PHME_GrantFlag=:MEGrantFlag,
		PHME_GuidObject=:MEGuidObject,PHME_GuidContent=:MEGuidContent,PHME_Icd=:MEIcd,PHME_MobPhone=:modPhone,PHME_Address=:address
		,PHME_OtherObject=:otherObject Where PHME_RowID=:medEduID) 

	Q SQLCODE
}

/// Descript:保存用药指导内容
ClassMethod InsMedEduGuiContent(medEduID As %String, medEduGuiConList As %String) As %String
{
	N (medEduID,medEduGuiConList)
	S Len=$L(medEduGuiConList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S medEduGuiCon=$p(medEduGuiConList,"||",i)
	.;S ItemCode=$p(medEduGuiCon,"^",1)    //代码
	.;S ItemDesc=$p(medEduGuiCon,"^",2)    //指导意见
	.S ItemCode=medEduGuiCon
	.S childSub=$o(^DHCPHME(medEduID,"GC",""),-1)+1
	.&SQL(Insert into DHC_PHMEGuiContent(PHMEGC_PHME_Parref,PHMEGC_ChildSub,PHMEGC_Code,PHMEGC_GuidDesc)
		Values(:medEduID,:childSub,:ItemCode,:ItemDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除用药指导内容
ClassMethod DelMedEduGuiContent(medEduID As %String) As %String
{
	N (medEduID)
	&SQL(delete from DHC_PHMEGuiContent where PHMEGC_PHME_Parref=:medEduID)
	Q SQLCODE
}

/// Descript:保存关注药品
ClassMethod InsMedEduDrgItm(medEduID As %String, medEduDrgItmList As %String) As %String
{
	N (medEduID,medEduDrgItmList)
	S Len=$L(medEduDrgItmList,",")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S medEduDrgItm=$p(medEduDrgItmList,",",i)
	.S oeoriDr=$p(medEduDrgItm,"^",1)        //医嘱ID
	.;S guiContent=$p(medEduDrgItm,"^",2)     //指导内容
	.s guiContent=""
	.S childSub=$o(^DHCPHME(medEduID,"DI",""),-1)+1
	.&SQL(Insert into DHC_PHMEDrgItm(PHMEDI_PHME_Parref,PHMEDI_ChildSub,PHMEDI_OEORI_DR,PHMEDI_Desc)
		Values(:medEduID,:childSub,:oeoriDr,:guiContent))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除关注药品
ClassMethod DelMedEduDrgItm(medEduID As %String) As %String
{
	N (medEduID)
	&SQL(delete from DHC_PHMEDrgItm where PHMEDI_PHME_Parref=:medEduID)
	Q SQLCODE
}

/// Descript: 删除用药教育相关信息表
ClassMethod DelMedEduRelaTable(medEduID As %String) As %String
{
	n (medEduID)
	
	//用药指导内容
	i $d(^DHCPHME(medEduID,"GC",1)) d
	.&SQL(delete from DHC_PHMEGuiContent where PHMEGC_PHME_Parref=:medEduID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	//关注药品
	i $d(^DHCPHME(medEduID,"DI",1)) d
	.&SQL(delete from DHC_PHMEDrgItm where PHMEDI_PHME_Parref=:medEduID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	q 0
}

/// Descript:获取用药教育数据
/// w ##class(web.DHCPHMEDEDUCATION).getMedEducation("16243032","New")
ClassMethod getMedEducation(AdmDr As %String, curStatus As %String) As %String
{
	N (AdmDr,curStatus,%session)
	i curStatus="New"  s curStatus="N"
	e  i curStatus="Out"  s curStatus="O"
	S medEduID=$o(^DHCPHME(0,"CurStatus",curStatus,AdmDr,""),-1)
	Q:medEduID="" "-999"  ;没有记录，返回-999

	S AdmDr=$p(^DHCPHME(medEduID),"^",1)     //病人Adm
    S AdmWard=""
	S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	I AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //病区
	S bedid=$p(^PAADM(AdmDr),"^",73)             //床号
	I bedid="" S AdmBed=""
    E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
    S Papmi=$p(^PAADM(AdmDr),"^",1)
    S PatName=$p(^PAPER(Papmi,"ALL"),"^",1)      //姓名
	S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)      //登记号
	S mobPhone=$p(^PAPER(Papmi,"PER",4),"^",21)  //电话
    S SexID=$p(^PAPER(Papmi,"ALL"),"^",7 )       //姓别
	S PatSex=$p(^CT("SEX",SexID),"^",2)
	S PatAge=##class(PHA.FACE.IN.Com).GetAge(Papmi, AdmDr)  //年龄
	S PatW=##class(PHA.COM.Order).PatWeight(AdmDr)       //体重
	S PatH=##class(PHA.COM.Order).PatHeight(AdmDr)       //身高
	
	S EDCurStatus=$p(^DHCPHME(medEduID),"^",2) //当前状态
	S EDUser=""
	S EDUserDr=$p(^DHCPHME(medEduID),"^",3)    //记录人
	S:EDUserDr'="" EDUser=$p(^SSU("SSUSR",EDUserDr),"^",2)
	S EDDate=$p(^DHCPHME(medEduID),"^",4)      //记录日期
	//S:EDDate'="" EDDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(EDDate)  ;$zd(EDDate,3)
	S:EDDate'="" EDDate=$zd(EDDate,3)
	S EDTime=$p(^DHCPHME(medEduID),"^",5)      //记录时间
	S:EDTime'="" EDTime=$zt(EDTime,2)
	S MEBadHabits=$p(^DHCPHME(medEduID),"^",6)    //不良嗜好
	S MEConDisAndTre=$p(^DHCPHME(medEduID),"^",7) //伴发疾病与用药情况
	S MEGrantFlag=$p(^DHCPHME(medEduID),"^",8)    //发放临床药师联系卡
	S MEGuidObject=$p(^DHCPHME(medEduID),"^",9)   //指导对象
	S MEGuidContent=$p(^DHCPHME(medEduID),"^",10)  //指导意见/内容
	S MEIcd=$p(^DHCPHME(medEduID),"^",11)  	  //诊断描述
	S mobPhone=$p(^DHCPHME(medEduID),"^",12)  //联系方式
	S Address=$p(^DHCPHME(medEduID),"^",13)     //家庭地址
	s otherObject=$p(^DHCPHME(medEduID),"^",24)
	
	s PatName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",PatName)
    s PatSex=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
    s EDUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",EDUser)
    s MEBadHabits=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEBadHabits","",MEBadHabits)
    s MEConDisAndTre=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEConDisAndTre","",MEConDisAndTre)
    s MEGuidContent=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEGuidContent","",MEGuidContent)
    s MEIcd=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEIcd","",MEIcd)   
	s Address=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEAddress","",Address)
	s otherObject=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEOtherObject","",otherObject)
	
	
	S medEduMasDataList=PatNo_"^"_PatName_"^"_AdmBed_"^"_PatSex_"^"_PatAge_"^"_PatW_"^"_PatH_"^"_mobPhone
	S medEduMasDataList=medEduMasDataList_"^"_EDCurStatus_"^"_EDUser_"^"_EDDate_"^"_EDTime_"^"_MEBadHabits
	s medEduMasDataList=medEduMasDataList_"^"_MEConDisAndTre_"^"_MEGrantFlag_"^"_MEGuidObject_"^"_MEGuidContent
	s medEduMasDataList=medEduMasDataList_"^"_MEIcd_"^"_medEduID_"^"_Address_"^"_otherObject
	
	S medEduGuiConList=..getMedEduGuiContent(medEduID)    //用药指导内容
	S ret=medEduMasDataList_"!"_medEduGuiConList
	
	Q ret
}

/// Descript:获取用药教育数据
/// 住院期间患者列表
/// w ##class(web.DHCPHMEDEDUCATION).getMedEduRecord("15","1","16243032","In","2014-10-10","2014-12-30")
ClassMethod getMedEduRecord(rows, page, AdmDr, curStatus, startDate, endDate) As %String
{
	n (rows,page,AdmDr,curStatus,startDate,endDate,%session)
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	i curStatus="In"  s curStatus="I"
	s stdate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(startDate) ;$zdh(startDate,3)
	s enddate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(endDate) ;$zdh(endDate,3)
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s h=0
	s fdate=0
	f fdate=stdate:1:enddate  d
	.s medEduID=""
	.f  s medEduID=$o(^DHCPHME(0,"DateAdm",fdate,AdmDr,medEduID)) q:(medEduID="")||(medEduID=0)  d
	..S AdmDr=$p(^DHCPHME(medEduID),"^",1)     //病人Adm
    ..S AdmWard=""
	..S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	..I AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //病区
	..S bedid=$p(^PAADM(AdmDr),"^",73)             //床号
	..I bedid="" S AdmBed=""
    ..E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
    ..S Papmi=$p(^PAADM(AdmDr),"^",1)
    ..S PatName=$p(^PAPER(Papmi,"ALL"),"^",1)      //姓名
	..S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)      //登记号
	..S mobPhone=$p(^PAPER(Papmi,"PER",4),"^",21)  //电话
    ..S SexID=$p(^PAPER(Papmi,"ALL"),"^",7 )       //姓别
	..S PatSex=$p(^CT("SEX",SexID),"^",2)
	..S PatAge=##class(PHA.FACE.IN.Com).GetAge(Papmi, AdmDr)  //年龄
	..S PatW=##class(PHA.COM.Order).PatWeight(AdmDr)       //体重
	..S PatH=##class(PHA.COM.Order).PatHeight(AdmDr)       //身高
	..S EDCurStatus=$p(^DHCPHME(medEduID),"^",2) //当前状态
	..Q:EDCurStatus'=curStatus  //Quit出 不是住院期间患者的信息列表
	..S EDUser=""
	..S EDUserDr=$p(^DHCPHME(medEduID),"^",3)    //记录人
	..S:EDUserDr'="" EDUser=$p(^SSU("SSUSR",EDUserDr),"^",2)
	..S EDDate=$p(^DHCPHME(medEduID),"^",4)      //记录日期
	..S:EDDate'="" EDDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(EDDate)  ;$zd(EDDate,3)
	..S EDTime=$p(^DHCPHME(medEduID),"^",5)      //记录时间
	..S:EDTime'="" EDTime=$zt(EDTime,2)
	..S MEBadHabits=$p(^DHCPHME(medEduID),"^",6)    //不良嗜好
	..S MEConDisAndTre=$p(^DHCPHME(medEduID),"^",7) //伴发疾病与用药情况
	..S MEGrantFlag=$p(^DHCPHME(medEduID),"^",8)    //发放临床药师联系卡
	..S MEGuidObject=$p(^DHCPHME(medEduID),"^",9)   //指导对象
	..S MEGuidContent=$p(^DHCPHME(medEduID),"^",10)  //指导意见/内容
	..S MEIcd=$p(^DHCPHME(medEduID),"^",11)  //诊断描述
	..s otherObject=$p(^DHCPHME(medEduID),"^",24)
	..s h=h+1
	..s PatName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",PatName)
    ..s PatSex=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
    ..s EDUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",EDUser)
    ..s MEBadHabits=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEBadHabits","",MEBadHabits)
    ..s MEConDisAndTre=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEConDisAndTre","",MEConDisAndTre)
    ..s MEGuidContent=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEGuidContent","",MEGuidContent)
    ..s MEIcd=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEIcd","",MEIcd)   
	..s otherObject=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEOtherObject","",otherObject)
	..S data=AdmDr_"^"_PatNo_"^"_PatName_"^"_AdmBed_"^"_PatSex_"^"_PatAge_"^"_PatW_"^"_PatH_"^"_mobPhone
	..S data=data_"^"_EDCurStatus_"^"_EDUser_"^"_EDDate_"^"_EDTime_"^"_MEBadHabits_"^"_MEConDisAndTre
	..s data=data_"^"_MEGrantFlag_"^"_MEGuidObject_"^"_MEGuidContent_"^"_MEIcd_"^"_medEduID_"^"_otherObject
	..s ^TMP("DHCST","DHCPHMEDEDUCATION","getMedEduRecord",pid,h)=data
	
	    
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
    i endpage>maxrow s endpage=maxrow
	
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCPHMEDEDUCATION","getMedEduRecord",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCPHMEDEDUCATION","getMedEduRecord",pid,h)
	.s AdmDr=$p(data,"^",1)
	.s PatNo=$p(data,"^",2)
	.s PatName=$p(data,"^",3)
	.s AdmBed=$p(data,"^",4)
	.s PatSex=$p(data,"^",5)
	.s PatAge=$p(data,"^",6)
	.s PatW=$p(data,"^",7)
	.s PatH=$p(data,"^",8)
	.s mobPhone=$p(data,"^",9)
	.s EDCurStatus=$p(data,"^",10)
	.s EDUser=$p(data,"^",11)
	.s EDDate=$p(data,"^",12)
	.s EDTime=$p(data,"^",13)
	.s MEBadHabits=$p(data,"^",14)
	.s MEConDisAndTre=$p(data,"^",15)
	.s MEGrantFlag=$p(data,"^",16)
	.s MEGuidObject=$p(data,"^",17)
	.s MEGuidContent=$p(data,"^",18)
	.s MEIcd=$p(data,"^",19)
	.s medEduID=$p(data,"^",20)
	.s otherObject=$p(data,"^",21)
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
	.s AdmDr=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("AdmDr",AdmDr)
	.s PatNo=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatNo",PatNo) 
	.s PatName=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatName",PatName)
	.s AdmBed=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("AdmBed",AdmBed)
	.s PatSex=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatSex",PatSex)
	.s PatAge=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatAge",PatAge)
	.s PatW=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatW",PatW)
	.s PatH=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatH",PatH)
	.s mobPhone=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("mobPhone",mobPhone)
	.s EDCurStatus=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("EDCurStatus",EDCurStatus)
	.s EDUser=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("EDUser",EDUser)
	.s EDDate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("EDDate",EDDate)
	.s EDTime=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("EDTime",EDTime)
	.s MEGrantFlag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("MEGrantFlag",MEGrantFlag)
	.s MEGuidObject=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("MEGuidObject",MEGuidObject)
	.s MEGuidContent=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("MEGuidContent",MEGuidContent)
	.s MEIcd=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("MEIcd",MEIcd)
	.s otherObject=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("OtherObject",otherObject)
	.s medEduID=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("medEduID",medEduID)
	.
	.s tmpstr=AdmDr_PatNo_PatName_AdmBed_PatSex_PatAge_PatW_PatH_mobPhone_EDCurStatus_EDUser_EDDate_EDTime_MEGrantFlag_MEGuidObject_MEGuidContent_MEIcd_otherObject_medEduID
	.s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	.s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	.s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("DHCST","DHCPHMEDEDUCATION","getMedEduRecord",pid)
	q ""
}

/// Descript:指导意见
/// w ##class(web.DHCPHMEDEDUCATION).getMedEduGuiContent("2")
ClassMethod getMedEduGuiContent(medEduID As %String) As %String
{
	N (medEduID)
	S CH="",ret=""
	F  S CH=$o(^DHCPHME(medEduID,"GC",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHME(medEduID,"GC",CH))
	.i ret="" S ret=mdata
	.E  S ret=ret_mdata
	Q ret
}

/// Descript:关注药品
/// w ##class(web.DHCPHMEDEDUCATION).getMedEduDrgItm("70")
ClassMethod getMedEduDrgItm(medEduID As %String, StPage = "1", EndPage = "999") As %String
{
	N (medEduID,StPage,EndPage,%session)	
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	
	S curStatus=$p(^DHCPHME(medEduID),"^",2)
	S Num=0
	S CH=""
	F  S CH=$o(^DHCPHME(medEduID,"DI",CH)) Q:CH=""  D
	.S orditm=$p(^DHCPHME(medEduID,"DI",CH),"^",1)		/// 医嘱ID
	.S guiCon=$p(^DHCPHME(medEduID,"DI",CH),"^",2)		/// 指导意见
	.S ord=+orditm
	.S chl=$p(orditm,"||",2)
	.S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)			/// 医嘱 ARC_ItmMast ARCIM_RowId
	.S ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .Q:(ordertype'="R")
	.S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.Q:inci=""  										/// 医嘱名称
	.;S inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	.S inciDesc=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2) //lbb 2019/1/4 取医嘱项名称，因为医嘱项和库存项存在一对多关系 
	.s moeoriflag=##class(web.DHCSTPHCMCOMMON).GetMainOeoriNew(orditm)
	.i moeoriflag'="" d
	..s inciDesc="______"_inciDesc
	.;S dosage=$p($g(^OEORD(ord,"I",chl,2)),"^",1)	/// 剂量
	.//S dosage=$fn(dosage,".",2)
	.s dosage=##class(PHA.FACE.IN.Com).GetOrdDoseQty(orditm)  //lbb  2019/7/3 同频次不同剂量,剂量串
	.S dosuomID=+$p($g(^OEORD(ord,"I",chl,2)),"^",3)
	.S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)		/// 剂量单位
	.;S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) //OEORI_PHFreq_DR
    .;S freq=$p($g(^PHCFR(freqdr)),"^",3)           		/// 频率
	.s freqInfo=##class(PHA.COM.Order).OeoriFreq(orditm)   //取频次调用统一接口
	.s freqdr=$p(freqInfo,"^",1)  
    .s freq=$p(freqInfo,"^",2) 
    .S instrudr=+$p($g(^OEORD(ord,"I",chl,2)),"^",7)
    .S instru=$p($g(^PHCIN(instrudr)),"^",2)        	/// 用法
	.s duration=""
    .s durId=$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	.s:durId'="" duration=$p($g(^PHCDU(durId)),"^",1)  /// 用药疗程
	.S phcdf=$p($g(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1)),"^",12) q:phcdf=""
    .s genenicdr=$p($g(^PHCD(+phcdf,4)),"^",1)
    .s genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2)		/// 通用名
    .s formdr=$p($g(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1)),"^",1)
    .s form=$p($g(^PHCF(formdr)),"^",2)						/// 剂型
    .s manf=""
    .s manfdr=$p($g(^PHCD(+phcdf,2)),"^",4)				/// 厂家
    .s:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
    .s execStat=##class(web.DHCSTPHCMCOMMON).CheckIfExec(ord,chl)	/// 是否执行 qunianpeng 2018/3/12
	.s execStat=$case(execStat,"Y":"已执行","N":"未执行",:"") 
	.S doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm)		/// 医生
	.S StartDate=+$p($g(^OEORD(ord,"I",chl,1)),"^",9)   				/// 开始日期
	.S:StartDate'="" StartDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(StartDate)  ;$zd(StartDate,3)
	.S dgID=$S(curStatus="I":"drugdg",curStatus="O":"outdrugdg",1:"")
	.s inciDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.ARCItmMast","ARCIMDesc","",inciDesc)
	.s freq=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCFreq","PHCFRDesc1","",freq)
	.s instru=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCInstruc","PHCINDesc1","",instru)
	.s duration=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCDuration","PHCDUCode","",duration)
	.s doctor=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTCareProv","CTPCPDesc","",doctor)
	.s genenic=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCGeneric","PHCGEName","",genenic)
	.s form=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCForm","PHCFDesc","",form)
	.s manf=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHManufacturer","PHMNFName","",manf)
	.s execStat=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(execStat)
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCPHMEDEDUCATION","getMedEduDrgItm",pid,Num)=orditm_"^"_StartDate_"^"_inciDesc_"^"_dosage_doseuom_"^"_freq_"^"_instru_"^"_duration_"^"_doctor_"^"_genenic_"^"_form_"^"_manf_"^"_dgID_"^"_execStat

	i 4>Num d
	.S Len=4-Num
	.f i=1:1:Len d
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCPHMEDEDUCATION","getMedEduDrgItm",pid,Num)=""
	
	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) 		/// 输出空的json串
	
	//S Title="orditm^StartDate^incidesc^Dosage^freq^Instance^duration^Doctor^genenic^form^manf^dgID"
	S Title="orditm^StartDate^incidesc^dosage^freq^instru^duration^Doctor^genenic^form^manf^dgID^execStat" 	//更换剂量和用法 qunianpeng 2018/3/12
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) 			/// 输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCPHMEDEDUCATION","getMedEduDrgItm",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCPHMEDEDUCATION","getMedEduDrgItm",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	
	k ^TMP("DHCST","web.DHCPHMEDEDUCATION","getMedEduDrgItm")
	q ""
}

/// Descript:药师指导列表
/// w ##class(web.DHCPHMEDEDUCATION).getGuidContList("14")
ClassMethod getGuidContList(EduRid As %String) As %String
{
	
	S GuidanceList=..getMedEduGuiContent(EduRid)
	q GuidanceList
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCPHMEDEDUCATION","getMedEduDrgItm",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMMEDEDUCATION"))
}

/// Descript:出院用药教育打印内容
/// w ##class(web.DHCPHMEDEDUCATION).getOutMedEduPrintInfo(72)
ClassMethod getOutMedEduPrintInfo(medEduID As %String) As %String
{
	N (medEduID)
	Q:'$d(^DHCPHME(medEduID)) ""
	S AdmDr=$p(^DHCPHME(medEduID),"^",1)     //病人Adm
    S AdmWard=""
	S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	I AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //病区
	S:AdmWard["-" AdmWard=$p(AdmWard,"-",2)
	S bedid=$p(^PAADM(AdmDr),"^",73)             //床号
	I bedid="" S AdmBed=""
    E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
    S Papmi=$p(^PAADM(AdmDr),"^",1)
    S PatName=$p(^PAPER(Papmi,"ALL"),"^",1)      //姓名
	S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)      //登记号
	S mobPhone=$p(^PAPER(Papmi,"PER",4),"^",21)  //电话
    S SexID=$p(^PAPER(Papmi,"ALL"),"^",7 )       //姓别
	S PatSex=$p(^CT("SEX",SexID),"^",2)
	S PatAge=##class(PHA.FACE.IN.Com).GetAge(Papmi, AdmDr)  //年龄
	S EDUser=""
	S EDUserDr=$p(^DHCPHME(medEduID),"^",3)    //记录人
	S:EDUserDr'="" EDUser=$p(^SSU("SSUSR",EDUserDr),"^",2)
	S EDDate=$p(^DHCPHME(medEduID),"^",4)      //记录日期
	S:EDDate'="" EDDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(EDDate) ;$zd(EDDate,3)
	S MEGuidContent=$p(^DHCPHME(medEduID),"^",10)  //指导意见/内容
	S MEIcd=$p(^DHCPHME(medEduID),"^",11)  //诊断描述
	S mDataList=AdmWard_"^"_AdmBed_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_MEIcd_"^"_EDUser_"^"_EDDate_"^"_MEGuidContent
	S dDateList=""
	S CH=""
	F  S CH=$o(^DHCPHME(medEduID,"DI",CH)) Q:CH=""  D
	.S orditm=$p(^DHCPHME(medEduID,"DI",CH),"^",1)  //医嘱ID
	.S guiCon=$p(^DHCPHME(medEduID,"DI",CH),"^",2)  //指导意见
	.S ord=+orditm
	.S chl=$p(orditm,"||",2)
	.S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)     //医嘱 ARC_ItmMast ARCIM_RowId
	.S ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .Q:(ordertype'="R")
	.S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.Q:inci=""  //医嘱名称
	.;S inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	.S inciDesc=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2) //lbb 2019/1/7 取医嘱项名称，因为医嘱项和库存项存在一对多关系 
	.S phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) q:phcdf=""
    .S genenicdr=$p($g(^PHCD(+phcdf,4)),"^",1)
    .S genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) //通用名    
   	.;S dosage=$p($g(^OEORD(ord,"I",chl,2)),"^",1)		/// 剂量 qunianpeng 2018/3/12 增加剂量，单位，频率，用法，疗程，执行标志
	.//s dosage=$fn(dosage,"")
	.s dosage=##class(PHA.FACE.IN.Com).GetOrdDoseQty(orditm)  //lbb  2019/7/3 同频次不同剂量,剂量串
	.s dosuomID=+$p($g(^OEORD(ord,"I",chl,2)),"^",3)	
	.s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)	/// 剂量单位
	.;s freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4)  /// OEORI_PHFreq_DR
    .;s freq=$p($g(^PHCFR(freqdr)),"^",3)			/// 频率
	.s freqInfo=##class(PHA.COM.Order).OeoriFreq(orditm)   //取频次调用统一接口
	.s freqdr=$p(freqInfo,"^",1)  
    .s freq=$p(freqInfo,"^",2) 
    .s instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    .s instru=$p($g(^PHCIN(instrudr)),"^",2)		/// 用法
	.s duration=""
    .s durId=$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	.s:durId'="" duration=$p($g(^PHCDU(durId)),"^",1)  /// 用药疗程 
	.s execStat=##class(web.DHCSTPHCMCOMMON).CheckIfExec(ord,chl)				/// 是否执行
	.s execStat=$case(execStat,"Y":"已执行","N":"未执行",:"")  
    .S manf=""
    .S manfdr=$p($g(^PHCD(+phcdf,2)),"^",4) //厂家
    .S:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
    .I dDateList="" S dDateList=inciDesc_"^"_genenic_"^"_manf_"^"_dosage_doseuom_"^"_freq_"^"_instru_"^"_duration_"^"_execStat
    .E  S dDateList=dDateList_"||"_inciDesc_"^"_genenic_"^"_manf_"^"_dosage_doseuom_"^"_freq_"^"_instru_"^"_duration_"^"_execStat
    
    Q mDataList_"&&"_dDateList
}

/// Descript:指导意见
/// w ##class(web.DHCPHMEDEDUCATION).getMedEduGuiContentObject("2")
ClassMethod getMedEduGuiContentObject(medEduID As %String) As %String
{
	N (medEduID)
	S CH="",ret=""
	S EduGuiObject=$p(^DHCPHME(medEduID),"^",9)   //指导对象
	F  S CH=$o(^DHCPHME(medEduID,"GC",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHME(medEduID,"GC",CH))
	.S mdataId=$p(mdata,"^",1)
	.s desc=$p($g(^DHCPHGS(mdataId)),"^",2) //指导内容
	.i ret="" S ret=mdataId_"^"_desc
	.E  S ret=ret_"!"_mdataId_"^"_desc
	Q ret_"$"_EduGuiObject
}

/// Creator: Huxt 2019-12-15
/// Desc: 获取新入院患者用药教育打印数据
/// Input: adm - 就诊ID
/// 	   curStatus - New:新入院患者; Out:出院患者
/// Output: JSON
/// w ##class(web.DHCPHMEDEDUCATION).GetMedEduNewPrint(6,"New")
ClassMethod GetMedEduNewPrint(adm As %String, curStatus As %String) As %String
{
	n (adm, curStatus)
	i curStatus="New" s curStatus="N"
	e  i curStatus="Out" s curStatus="O"
	s medEduID = $o(^DHCPHME(0,"CurStatus",curStatus,adm,""),-1)
	q:medEduID="" "-100^获取数据错误"
	s adm = $p(^DHCPHME(medEduID),"^",1)     					//病人Adm
    s admWard = ""
	s admWardDr = $p(^PAADM(adm),"^",70)
	s:admWardDr'="" admWard = $p(^PAWARD(admWardDr),"^",2) 		//病区
	s:admWard["-" admWard=$p(admWard,"-",2)
	s bedID = $p(^PAADM(adm),"^",73)             				//床号
	s patBed = ""
	s:bedID'="" patBed = $p(^PAWARD($p(bedID,"||",1),"BED",$p(bedID,"||",2)),"^",1)
    s papmi = $p(^PAADM(adm),"^",1)
    s patName = $p(^PAPER(papmi,"ALL"),"^",1)      				//姓名
	s patNo = $p(^PAPER(papmi,"PAT",1),"^",1)      				//登记号
	s mobPhone = $p(^PAPER(papmi,"PER",4),"^",21)  				//电话
    s sexID = $p(^PAPER(papmi,"ALL"),"^",7 )       				//姓别
	s patSex = $p(^CT("SEX",sexID),"^",2)
	s patAge = ##class(PHA.FACE.IN.Com).GetAge(papmi, adm)  			//年龄
	s patW = ##class(PHA.COM.Order).PatWeight(adm)     //体重
	s patH = ##class(PHA.COM.Order).PatHeight(adm)     //身高
	s EDCurStatus = $p(^DHCPHME(medEduID),"^",2) 				//当前状态
	s EDUser=""
	s EDUserDr = $p(^DHCPHME(medEduID),"^",3)    				//记录人
	s:EDUserDr'="" EDUser = $p(^SSU("SSUSR",EDUserDr),"^",2)
	s EDDate = $p(^DHCPHME(medEduID),"^",4)      				//记录日期
	s:EDDate'="" EDDate = $zd(EDDate,3)
	s EDTime = $p(^DHCPHME(medEduID),"^",5)      				//记录时间
	s:EDTime'="" EDTime = $zt(EDTime,2)
	s MEBadHabits = $p(^DHCPHME(medEduID),"^",6)    			//不良嗜好
	s MEConDisAndTre = $p(^DHCPHME(medEduID),"^",7) 			//伴发疾病与用药情况
	s MEGrantFlag = $p(^DHCPHME(medEduID),"^",8)    			//发放临床药师联系卡
	s MEGuidObject = $p(^DHCPHME(medEduID),"^",9)   			//指导对象
	s MEGuidContent= $p(^DHCPHME(medEduID),"^",10)  			//指导意见/内容 -- 注意事项
	s MEIcd = $p(^DHCPHME(medEduID),"^",11)  	  				//诊断描述
	s mobPhone = $p(^DHCPHME(medEduID),"^",12)  				//联系方式
	s Address = $p(^DHCPHME(medEduID),"^",13)					//家庭地址
	//指导内容对象
	s ret = ..getMedEduGuiContentObject(medEduID)
	q:ret="" "-101^获取指导内容对象错误"
	s EduGuiObect = ""
	s medEduMasterIN = $p(ret,"$",1)
	s medEduMasterINLen = $l(medEduMasterIN,"!")
	f i=1:1:medEduMasterINLen d
	.s oneMedEduMasterIN = $p(medEduMasterIN,"!",i)
	.s medEdu = $p(oneMedEduMasterIN,"^",2)
	.i EduGuiObect=""  s EduGuiObect=medEdu
	.e  s EduGuiObect = EduGuiObect_"    "_medEdu
	//超长字符串处理
	s MEBadHabits = ##class(PHA.COM.Print).SplitStr(MEBadHabits,64,4) 		//xml:不良嗜好(烟、酒、药物依赖)
	s MEIcd = ##class(PHA.COM.Print).SplitStr(MEIcd,64,4) 					//xml:入院诊断
	s MEConDisAndTre = ##class(PHA.COM.Print).SplitStr(MEConDisAndTre,64,4) //xml:伴发疾病与用药情况
	s EduGuiObect = ##class(PHA.COM.Print).SplitStr(EduGuiObect,60,4) 		//xml:患者用药指导内容
	s MEGuidContent = ##class(PHA.COM.Print).SplitStr(MEGuidContent,64,4) 	//xml:注意事项
	//json
	s Para = {}
	s Para.patName = patName
	s Para.admWard = admWard
	s Para.patBed = patBed
	s Para.patNo = patNo
	s Para.mobPhone = mobPhone
	s Para.patSex = patSex
	s Para.patAge = patAge
	s Para.patWeight = patW
	s Para.patHeight = patH
	s Para.EDCurStatus = EDCurStatus
	s Para.EDUser = EDUser
	s Para.EDDate = EDDate
	s Para.EDTime = EDTime
	s Para.MEBadHabits1 = $p(MEBadHabits,"^",1)
	s Para.MEBadHabits2 = $p(MEBadHabits,"^",2)
	s Para.MEBadHabits3 = $p(MEBadHabits,"^",3)
	s Para.MEBadHabits4 = $p(MEBadHabits,"^",4)
	s Para.MEIcd1 = $p(MEIcd,"^",1)
	s Para.MEIcd2 = $p(MEIcd,"^",2)
	s Para.MEIcd3 = $p(MEIcd,"^",3)
	s Para.MEIcd4 = $p(MEIcd,"^",4)
	s Para.MEConDisAndTre1 = $p(MEConDisAndTre,"^",1)
	s Para.MEConDisAndTre2 = $p(MEConDisAndTre,"^",2)
	s Para.MEConDisAndTre3 = $p(MEConDisAndTre,"^",3)
	s Para.MEConDisAndTre4 = $p(MEConDisAndTre,"^",4)
	s Para.EduGuiObect1 = $p(EduGuiObect,"^",1)
	s Para.EduGuiObect2 = $p(EduGuiObect,"^",2)
	s Para.EduGuiObect3 = $p(EduGuiObect,"^",3)
	s Para.EduGuiObect4 = $p(EduGuiObect,"^",4)
	s Para.MEGuidContent1 = $p(MEGuidContent,"^",1)
	s Para.MEGuidContent2 = $p(MEGuidContent,"^",2)
	s Para.MEGuidContent3 = $p(MEGuidContent,"^",3)
	s Para.MEGuidContent4 = $p(MEGuidContent,"^",4)
	s:MEGrantFlag="Y" Para.f11 = "√"
	s:MEGrantFlag'="Y" Para.f12 = "√"
	s:MEGuidObject=10 Para.f21 = "√"
	s:MEGuidObject=11 Para.f22 = "√"
	i MEGuidObject=12 d
	.s Para.f23 = "√"
	.s Para.otherObject = "（"_$p(^DHCPHME(medEduID),"^",24)_"）"
	s List = []
	s retJosn = {}
	s retJosn.Para = Para
	s retJosn.List = List
	q retJosn.%ToJSON()
}

/// Creator: Huxt 2019-12-15
/// Desc: 获取在院患者或者出院患者用药教育打印数据
/// Input: adm - 就诊ID
/// 	   curStatus - New:新入院患者; Out:出院患者
/// Output: JSON
/// w ##class(web.DHCPHMEDEDUCATION).GetMedEduPrint(3)
ClassMethod GetMedEduPrint(medEduID) As %String
{
	n (medEduID)
	q:'$d(^DHCPHME(medEduID)) "-100^数据不存在"
	s adm = $p(^DHCPHME(medEduID),"^",1)     				//病人Adm
    s admWard = ""
	s admWardDr = $p(^PAADM(adm),"^",70)
	s:admWardDr'="" admWard = $p(^PAWARD(admWardDr),"^",2) 	//病区
	s:admWard["-" admWard=$p(admWard,"-",2)
	s admLocID = $p(^PAADM(adm),"^",4)
	s admLoc = $p(^CTLOC(admLocID),"^",2) 					//就诊科室
	s:admLoc["-" admLoc=$p(admLoc,"-",2)
	s hospID = $p(^CTLOC(admLocID),"^",22)
	s hospDesc = $p(^CT("HOSP",hospID),"^",2)				//医院
	s bedID = $p(^PAADM(adm),"^",73)             			//床号
	s patBed = ""
	s:bedID'="" patBed = $p(^PAWARD($p(bedID,"||",1),"BED",$p(bedID,"||",2)),"^",1)
    s papmi = $p(^PAADM(adm),"^",1)
    s patName = $p(^PAPER(papmi,"ALL"),"^",1)      			//姓名
	s patNo = $p(^PAPER(papmi,"PAT",1),"^",1)      			//登记号
	s mobPhone = $p(^PAPER(papmi,"PER",4),"^",21)  			//电话
    s sexID = $p(^PAPER(papmi,"ALL"),"^",7 )       			//姓别
	s patSex = $p(^CT("SEX",sexID),"^",2)
	s patAge = ##class(PHA.FACE.IN.Com).GetAge(papmi, adm) 	 	//年龄
	s patW = ##class(PHA.COM.Order).PatWeight(adm) //体重
	s patH = ##class(PHA.COM.Order).PatHeight(adm) //身高
	s EDUser = ""
	s EDUserDr = $p(^DHCPHME(medEduID),"^",3)    			//记录人
	s:EDUserDr'="" EDUser=$p(^SSU("SSUSR",EDUserDr),"^",2)
	s EDDate = $p(^DHCPHME(medEduID),"^",4)     	 		//记录日期
	s:EDDate'="" EDDate = ##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(EDDate)
	s MEGuidContent = $p(^DHCPHME(medEduID),"^",10)  		//指导意见/内容
	s MEIcd = $p(^DHCPHME(medEduID),"^",11)  				//诊断描述
	//指导内容对象
	s ret = ..getMedEduGuiContentObject(medEduID)
	q:ret="" "-101^获取指导内容对象错误"
	s EduGuiObect = ""
	s medEduMasterIN = $p(ret,"$",1)
	s medEduMasterINLen = $l(medEduMasterIN,"!")
	f i=1:1:medEduMasterINLen d
	.s oneMedEduMasterIN = $p(medEduMasterIN,"!",i)
	.s medEdu = $p(oneMedEduMasterIN,"^",2)
	.i EduGuiObect=""  s EduGuiObect=medEdu
	.e  s EduGuiObect = EduGuiObect_"    "_medEdu
	s EduGuiObectFlag =  $p(ret,"$",2) //指导对象
	//超长字符串处理
	s MEIcd = ##class(PHA.COM.Print).SplitStr(MEIcd,64,4) 					//xml:诊断
	s EduGuiObect = ##class(PHA.COM.Print).SplitStr(EduGuiObect,60,4) 		//xml:患者用药指导内容
	s MEGuidContent = ##class(PHA.COM.Print).SplitStr(MEGuidContent,64,4) 	//xml:注意事项
	//josn
	s retJson = {}
	s Para = {}
	s Para.title = hospDesc_"用药教育"
	s Para.patName = patName
	s Para.admWard = admWard
	s Para.admLoc = admLoc
	s Para.hospDesc = hospDesc
	s Para.patBed = patBed
	s Para.patNo = patNo
	s Para.mobPhone = mobPhone
	s Para.patSex = patSex
	s Para.patAge = patAge
	s Para.patWeight = patW
	s Para.patHeight = patH
	s Para.EDUser = EDUser
	s Para.Doctor = EDUser
	s Para.EDDate = EDDate
	s Para.MEIcd1 = $p(MEIcd,"^",1)
	s Para.MEIcd2 = $p(MEIcd,"^",2)
	s Para.MEIcd3 = $p(MEIcd,"^",3)
	s Para.MEIcd4 = $p(MEIcd,"^",4)
	s Para.EduGuiObect1 = $p(EduGuiObect,"^",1)
	s Para.EduGuiObect2 = $p(EduGuiObect,"^",2)
	s Para.EduGuiObect3 = $p(EduGuiObect,"^",3)
	s Para.EduGuiObect4 = $p(EduGuiObect,"^",4)
	s Para.MEGuidContent1 = $p(MEGuidContent,"^",1)
	s Para.MEGuidContent2 = $p(MEGuidContent,"^",2)
	s Para.MEGuidContent3 = $p(MEGuidContent,"^",3)
	s Para.MEGuidContent4 = $p(MEGuidContent,"^",4)
	s:EduGuiObectFlag=10 Para.f11 = "√"
	s:EduGuiObectFlag=11 Para.f12 = "√"
	i EduGuiObectFlag=12 d
	.s Para.f13 = "√"
	.s Para.otherObject = "（"_$p(^DHCPHME(medEduID),"^",24)_"）"
	
	//药品明细
	s List = []
	s chlid = 0
	f  s chlid = $o(^DHCPHME(medEduID,"DI",chlid)) Q:chlid=""  D
	.b ;1
	.s guiCon = $p(^DHCPHME(medEduID,"DI",chlid),"^",2)  					//指导意见
	.s orditm = $p(^DHCPHME(medEduID,"DI",chlid),"^",1)
	.s ord = +orditm
	.s ordChl = $p(orditm,"||",2)
	.s ArcItmId = $p(^OEORD(ord,"I",ordChl,1),"^",2)
	.s ItemCatDR = $p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .s ordertype = $P(^ARC("IC",ItemCatDR),"^",7)
    .q:ordertype'="R"
	.s inci = $o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.q:inci=""
	.//s inciDesc = $p(^INCI(inci,1),"^",2) 							//药品名称
	.s inciDesc = $p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2)
	.s moeoriflag=##class(web.DHCSTPHCMCOMMON).GetMainOeoriNew(orditm) 
    .i moeoriflag'="" d
    ..s inciDesc="______"_inciDesc	
	.s phcdf = $p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12)
	.q:phcdf=""
    .s genenicdr = $p($g(^PHCD(+phcdf,4)),"^",1)
    .s genenic = $p($g(^PHCGE("GE",genenicdr)),"^",2) 					//通用名
	.s dosage = ##class(PHA.FACE.IN.Com).GetOrdDoseQty(orditm)
	.s dosuomID = +$p($g(^OEORD(ord,"I",ordChl,2)),"^",3)	
	.s doseuom = $p($g(^CT("UOM",dosuomID)),"^",2)						//剂量单位
	.s dosage=dosage_doseuom
	.;s freqdr = +$p($g(^OEORD(ord,"I",ordChl,2)),"^",4)  				//OEORI_PHFreq_DR
    .;s freq = $p($g(^PHCFR(freqdr)),"^",3)								//频率
	.s freqInfo=##class(PHA.COM.Order).OeoriFreq(orditm)   //取频次调用统一接口
	.s freqdr=$p(freqInfo,"^",1)  
    .s freq=$p(freqInfo,"^",2) 
    .s instrudr = +$p(^OEORD(ord,"I",ordChl,2),"^",7)
    .s instru = $p($g(^PHCIN(instrudr)),"^",2)							//用法
	.s duration=""
    .s durId=$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	.s:durId'="" duration=$p($g(^PHCDU(durId)),"^",1)  /// 用药疗程  
	.s execStat = ##class(web.DHCSTPHCMCOMMON).CheckIfExec(ord,ordChl)	//是否执行
	.s execStat = $case(execStat, "Y":"已执行", "N":"未执行", :"")
    .s manf=""
    .s manfdr=$p($g(^PHCD(+phcdf,2)),"^",4) 							//厂家
    .s:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
    .//json
    .s oneRow = {}
    .s oneRow.inciDesc = inciDesc
    .s oneRow.dosage = dosage
    .s oneRow.instru = instru
    .s oneRow.freq = freq
    .s oneRow.duration = duration
    .d List.%Push(oneRow)
    
    s retJson.Para = Para
    s retJson.List = List
    q retJson.%ToJSON()
}

/// Creator: psc 2020-03-06
/// Desc: 获取在院患者或者出院患者用药教育id
/// Input: adm - 就诊ID
/// Output: JSON
/// w ##class(web.DHCPHMEDEDUCATION).GetMedEducationIdS(236)
ClassMethod GetMedEducationIdS(admId)
{
	q:admId="" [].%ToJSON()
	s retJson = []
	s status=""
	f  s status=$o(^DHCPHME(0,"CurStatus",status)) q:status=""  d
	.s phmeId=""
	.f  s phmeId=$o(^DHCPHME(0,"CurStatus",status,admId,phmeId)) q:phmeId=""  d
	..s tmp = {}
	..s tmp.Id = phmeId
	..s tmp.status = status
	..d retJson.%Push(tmp)
	q retJson.%ToJSON()
}

}
