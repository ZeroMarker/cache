Import sqluser

Class web.DHCCM.QueryPatient Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2016-10-25
/// Description：  按病区查询患者信息
/// Table：        PA_Adm,Pa_PatMas,PAC_Ward,CT_Loc,User.DHCPHInstanceData
/// input:		   分隔符^,登记号^结束时间^病案号^病区
/// Output：       患者信息
/// Others：       w ##class(web.DHCCM.QueryPatient).GetPatientinfoByWard(10,1,"^^^99")
ClassMethod GetPatientinfoByWard(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s pid=##class(web.DHCCM.MedRecCom).NewPid()
    d ..killTmpGlobal(pid) 		// k掉临时global
    s WardId=$p(params,"^",4)    // 科室Id
    s h=0,count=0
    s CurentRoomdr=""
    f  s CurentRoomdr=$o(^PAADMi("CurrWard",WardId,CurentRoomdr)) q:CurentRoomdr=""  d
    .s Admdr=""
    .f  s Admdr=$o(^PAADMi("CurrWard",WardId,CurentRoomdr,Admdr)) q:Admdr=""  d
    ..s PatientID=$p(^PAADM(Admdr),"^",1)
    ..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)					// 登记号
    ..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)					// 姓名
    ..s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)					    // 性别Id
    ..s SexDesc=$p(^CT("SEX",SexId),"^",2)							// 性别描述
    ..s PatAge=##class(PHA.FACE.IN.Com).GetAge(PatientID,Admdr)			// 年龄
    ..s AdmDate=$p(^PAADM(Admdr),"^",6)							    // 就诊日期
    ..s AdmDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(AdmDate)
    ..s DepId=$p(^PAADM(Admdr),"^",4)  							    // 就诊科室Id
    ..s CtlocDesc=$p(^CTLOC(DepId),"^",2)							// 科室描述
    ..s WardId=$p(^PAADM(Admdr),"^",70)							    // 病区Id
    ..s WardDesc=""
    ..i WardId'="" d
    ...s WardDesc=$p(^PAWARD(WardId),"^",2)							// 病区描述
    ..s MainDiag=##class(PHA.COM.Order).MrDiagnose(Admdr,",") //##class(web.DHCSTKUTIL).GetMRDiagnosDesc(Admdr,",") // 诊断
    ..s AdmDocId=$p(^PAADM(Admdr),"^",9)							// 医生Id
    ..s AdmDocName=""
    ..i AdmDocId'=""  d
    ...s AdmDocName=$p(^CTPCP(AdmDocId,1),"^",2)					// 医生姓名
    ..s PhaomId=$o(^DHCPHORDM(0,"Adm",Admdr,"")) 
    ..s PhaomResult=""
    ..i PhaomId'="" d
    ...s PhaomResult=$p(^DHCPHORDM(PhaomId),"^",2)				    // 重点患者标记
    ..s Statues=""     ///..GetEMRStatuesByEpisodeID(Admdr)			// 药历状态
    ..s h=h+1
    ..s tmpstr=PatientID_"^"_PatNo_"^"_PatName_"^"_SexDesc_"^"_PatAge_"^"_AdmDate_"^"_CtlocDesc_"^"_WardDesc_"^"_MainDiag_"^"_AdmDocName_"^"_PhaomResult_"^"_Statues
    ..s ^TMP("DHCST","web.DHCCM.QueryPatient","GetPatientinfoByWard",pid,h)=tmpstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="PatientID^PatNo^PatName^SexDesc^PatAge^AdmDate^CtlocDesc^WardDesc^MainDiag^AdmDocName^PhaomResult^Statues"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCCM.QueryPatient","GetPatientinfoByWard",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCCM.QueryPatient","GetPatientinfoByWard",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：    2016-11-05
/// Description：  查询就诊病人的药历
/// Table：        PA_Adm,Pa_PatMas,PAC_Ward,CT_Loc,User.DHCPHECRecord,User.DHCPHInstanceData
/// input:		   分隔符^:开始时间^结束时间^病案号^病区^登记号^药历状态
/// Output：       患者的药历信息
/// Modify:        liubeibei 2018-0703  查询改为按照药历日期查询非住院日期查询
/// Others：       w ##class(web.DHCCM.QueryPatient).QueryMedRecord(20,1,"2018-6-26^2018-6-26^^^^Save")
ClassMethod QueryMedRecord(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page, params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s pid=##class(web.DHCCM.MedRecCom).NewPid()
    d ..killTmpGlobal(pid) 			// k掉临时global
    s Stdate=$p(params,"^",1)   	// 取查询条件,开始日期
    s Enddate=$p(params,"^",2)		// 结束日期
    s Medicalno=$p(params,"^",3)	// 病案号
    s Ward=$p(params,"^",4)			// 病区
    s PatNo=$p(params,"^",5)		// 登记号
    s Recflag=$p(params,"^",6)		// 药历状态
    s hospID=$p(params,"^",7)
    s h=0,count=0
    s Stdate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(Stdate)
    s Enddate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(Enddate)
    s TheECRecord=""
    f  s TheECRecord=$o(^DHCPHI.InstanceDataI("IdxECRecord",TheECRecord)) q:TheECRecord=""  d
    .s ID=""  f  s ID=$o(^DHCPHI.InstanceDataI("IdxECRecord",TheECRecord,ID)) q:ID=""  d
    ..s objrecord=##class(User.DHCPHECRecord).%OpenId(TheECRecord)
    ..s Episodtype=objrecord.EpisodeType     							// 获取病人类型
    ..s Episodtype=$s(Episodtype="I":"住院",Episodtype="O":"门诊",Episodtype="E":"急诊",1:"")
    ..s instanceId=TheECRecord_"||"_ID
    ..s objinstance=##class(User.DHCPHInstanceData).%OpenId(instanceId)
    ..s Admdr=objinstance.EpisodeID
    ..s Locdr=$p(^PAADM(Admdr),"^",4)
	..s hospital=$p(^CTLOC(Locdr),"^",22)
	..q:(hospID'="")&(hospID'=hospital)   //过滤病区
	..q:('$d(^DHCPHI.ECRecordI("IdxEpisodeIDCategoryID"," "_Admdr)))	// 判断患者是否有药历信息
    ..s HappenDate=objinstance.HappenDate
    ..q:HappenDate=""
    ..q:(HappenDate>Enddate)||(HappenDate<Stdate)
    ..s status=objinstance.Status									// 获取药历状态
    ..s CreateuserDr=objinstance.CreateUser
    ..
    ..s Createuser=""
    ..i CreateuserDr'=""  d 
    ...q:'$d(^SSU("SSUSR",CreateuserDr))
    ...s Createuser=$p(^SSU("SSUSR",CreateuserDr),"^",2) // 药师姓名
    ..s EpisodeID=objinstance.EpisodeID
    ..;s Itmname=objinstance.GroupItemName
    ..q:(Recflag'="")&(status'=Recflag)
    ..s:status="UnSave" status="在建"
    ..s:status="Save" status="完成"
    ..s PatientID=$p(^PAADM(Admdr),"^",1)
    ..s Patno=$p(^PAPER(PatientID,"PAT",1),"^",1)					    // 登记号
    ..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)					    // 姓名
    ..s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)							// 性别Id
    ..s SexDesc=$p(^CT("SEX",SexId),"^",2)								// 性别描述
    ..s PatAge=##class(PHA.FACE.IN.Com).GetAge(PatientID,Admdr)				// 年龄
    ..s DepId=$p(^PAADM(Admdr),"^",4)  									// 就诊科室Id
    ..s CtlocDesc=$p(^CTLOC(DepId),"^",2)								// 科室描述
    ..s WardId=$p(^PAADM(Admdr),"^",70)									// 病区Id
    ..s MedicalNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(Admdr) //病案号
    ..s WardDesc=""
    ..i WardId'="" d
    ...s WardDesc=$p(^PAWARD(WardId),"^",2)						    	// 病区描述
    ..s MainDiag=##class(PHA.COM.Order).MrDiagnose(Admdr,",") //##class(web.DHCSTKUTIL).GetMRDiagnosDesc(Admdr,",")	// 诊断
    ..q:(Medicalno'="")&(MedicalNo'[Medicalno)
    ..q:(PatNo'="")&(Patno'[PatNo)
    ..q:(Ward'="")&(WardDesc'[Ward)    
    ..s h=h+1
    ..s PatName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",PatName)
    ..s SexDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",SexDesc)
    ..s CtlocDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLoc","CTLOCDesc","",CtlocDesc)
    ..s WardDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.PACWard","WARDDesc","",WardDesc)
    ..s MainDiag=##class(PHA.FACE.IN.Com).GetTransDesc("User.MRCICDDx","MRCIDDesc","",MainDiag)
    ..s Episodtype=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(Episodtype)
    ..s status=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(status)
    ..s Createuser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",Createuser)
    ..s tmpstr=PatientID_"^"_Admdr_"^"_Patno_"^"_PatName_"^"_SexDesc_"^"_PatAge_"^"_CtlocDesc_"^"_WardDesc_"^"_MainDiag_"^"_Episodtype_"^"_status_"^"_Createuser_"^"_MedicalNo
    ..s ^TMP("DHCST","web.DHCCM.QueryPatient","QueryMedRecord",pid,h)=tmpstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="PatientID^Admdr^Patno^PatName^SexDesc^PatAge^CtlocDesc^WardDesc^MainDiag^Episodtype^status^Createuser^MedicalNo"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCCM.QueryPatient","QueryMedRecord",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCCM.QueryPatient","QueryMedRecord",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：    2016-11-10
/// Description：  获取用药教育时间列表
/// Table：        DHC_PHMedEducation
/// input:		   病人类型(I 新入院患者),就诊号,检索条件(可为空)
/// Output：       患者用药教育时间
/// Others：       w ##class(web.DHCCM.QueryPatient).Gettiemtreelist("1609","")
ClassMethod Gettiemtreelist(EpisodeID As %String, Searchdate = "") As %String
{
	n (EpisodeID,Searchdate)
	s pid=##class(web.DHCCM.MedRecCom).NewPid()
    d ..killTmpGlobal(pid) 		// k掉临时global
    s h=0,count=0
    s tmpdate=""
	s PhmerowId=""
	s CurStatus=""
	
	f  s CurStatus=$o(^DHCPHME(0,"CurStatus",CurStatus))  q:CurStatus=""  d
	.f  s PhmerowId=$o(^DHCPHME(0,"CurStatus",CurStatus,EpisodeID,PhmerowId)) q:PhmerowId=""  d
	..s Phmedate=$p(^DHCPHME(PhmerowId),"^",4)
	..q:Phmedate=tmpdate
	..s tmpdate=Phmedate
	..s Phmedate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(Phmedate)
	..s text=Phmedate
	..q:(Searchdate'="")&(text'[Searchdate)
	..s h=h+1
	..s ^TMP("DHCST","web.DHCCM.QueryPatient","Gettiemtreelist",pid,h)=text
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="text"
	w "["  
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCCM.QueryPatient","Gettiemtreelist",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCCM.QueryPatient","Gettiemtreelist",pid,index))
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w "]"
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：    2016-11-11
/// Description：  通过时间获取用药教育信息
/// Table：        DHC_PHMedEducation,DHC_PHMEGuiContent
/// input:		   日期
/// Output：       患者用药教育信息串
/// Others：       w ##class(web.DHCCM.QueryPatient).GetMedinfo("2017-01-11","970")
ClassMethod GetMedinfo(date As %String, EpisodeID As %String) As %String
{
	n (date,EpisodeID)
	s pid=##class(web.DHCCM.MedRecCom).NewPid()
    d ..killTmpGlobal(pid) 		// k掉临时global
    s h=0,count=0
	s date=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(date)
	s PhmegrowId=""
	f  s PhmegrowId=$o(^DHCPHME(0,"DateAdm",date,EpisodeID,PhmegrowId))   q:PhmegrowId=""  d  //(^DHCPHME(0,"Date",date,PhmegrowId))  
	.s Phmegcontent=$p(^DHCPHME(PhmegrowId),"^",10)      // 指导内容
	.s Phmegobject=$p(^DHCPHME(PhmegrowId),"^",9)		 // 指导对象
	.s:Phmegobject="10" Phmegobject="患者本人"
	.s:Phmegobject="11" Phmegobject="患者家属"
	.s:Phmegobject="12" Phmegobject="其他"
	.s PhmegCode=..GetMedContent(PhmegrowId)
	.s PhmegDrug=..GetMedDrugs(PhmegrowId)
	.s tempstr=Phmegcontent_"^"_PhmegCode_"^"_Phmegobject_"^"_PhmegDrug
	.s h=h+1
	.s ^TMP("DHCST","web.DHCCM.QueryPatient","GetMedinfo",pid,h)=tempstr
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="Phmegcontent^PhmegCode^Phmegobject^PhmegDrug"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串  
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCCM.QueryPatient","GetMedinfo",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCCM.QueryPatient","GetMedinfo",pid,index))
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// 获取用药教育指导内容
/// w ##class(web.DHCCM.QueryPatient).GetMedContent("16")
ClassMethod GetMedContent(PhmegrowId)
{
	n (PhmegrowId)
	s curstatus=""
	&sql(select PHME_CurStatus into:curstatus from DHC_PHMedEducation where PHME_RowID=:PhmegrowId)
	s PhmegSub="",ListData=""
	f  s PhmegSub=$o(^DHCPHME(PhmegrowId,"GC",PhmegSub))  q:PhmegSub=""  d
	.s phgsRowId=$p(^DHCPHME(PhmegrowId,"GC",PhmegSub),"^",1)
	.q:phgsRowId=""
	.i curstatus="N"  d
	..s phgsDesc=$p(^DHCPHGS(phgsRowId),"^",2)
	..s phgsCode=$p(^DHCPHGS(phgsRowId),"^")
	..i phgsCode["." d
	...s ListData=ListData_"-"_phgsDesc_"；<br>"
	..e  d
	...s ListData=ListData_phgsDesc_"；<br>"
	.i curstatus="I"  d
	..s phgsDesc=$p(^DHCPHGS(phgsRowId),"^",2)
	..s phgsCode=$p(^DHCPHGS(phgsRowId),"^")
	..i phgsCode["." d
	...s ListData=ListData_"-"_phgsDesc_"；<br>"
	..e  d
	...s ListData=ListData_phgsDesc_"；<br>"
	q ListData
}

/// 获取用药教育关注药品信息
ClassMethod GetMedDrugs(PhmegrowId)
{
	n (PhmegrowId)
	s InciDesc="",i=1
	s PhmegSub=""
	f  s PhmegSub=$o(^DHCPHME(PhmegrowId,"DI",PhmegSub))  q:PhmegSub=""  d
	.s OeordItmId=$p(^DHCPHME(PhmegrowId,"DI",PhmegSub),"^",1)
	.s OeordRowId=$p(OeordItmId,"||",1)
	.s OeoriChildsub=$p(OeordItmId,"||",2)
	.s ItmastId=$p(^OEORD(OeordRowId,"I",OeoriChildsub,1),"^",2)   //医嘱项ARC_ItmMast ARCIM_RowId
	.s inciId=$o(^INCI(0,"ARCIM_DR",$p(ItmastId,"||",1),""))     //INC_Itm
	.q:inciId=""	
	.s InciDesc=InciDesc_","_i_"、"_$p(^INCI(inciId,1),"^",2)   //药品名称
	.s i=i+1
	q InciDesc
}

/// Creator：      sufan
/// CreatDate：    2016-11-20
/// Description：  获取时间列表
/// Table：        DHC_PHWardRound
/// input:		   病人类型(I 新入院患者),就诊号,检索条件(可为空)
/// Output：       患者用药教育时间
/// Others：       w ##class(web.DHCCM.QueryPatient).GetPhwardDateList("I","32595","")
ClassMethod GetPhwardDateList(EpisodeID As %String, Searchdate = "") As %String
{
	n (EpisodeID,Searchdate)
	s pid=##class(web.DHCCM.MedRecCom).NewPid()
    d ..killTmpGlobal(pid) 		// k掉临时global
    s h=0,count=0
    s tmpdate=""
	s PhwrRowId=""
	s CurStatus=""
	f  s CurStatus=$o(^DHCPHWR(0,"CurStatus",CurStatus)) q:CurStatus=""  d
	.f  s PhwrRowId=$o(^DHCPHWR(0,"CurStatus",CurStatus,EpisodeID,PhwrRowId)) q:PhwrRowId=""  d
	..s PhwrDate=$p(^DHCPHWR(PhwrRowId),"^",9)
	..q:PhwrDate=tmpdate
	..s tmpdate=PhwrDate
	..s PhwrDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(PhwrDate)
	..s text=PhwrDate
	..q:(Searchdate'="")&(text'[Searchdate)
	..s h=h+1
	..s ^TMP("DHCST","web.DHCCM.QueryPatient","GetPhwardDateList",pid,h)=text
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="text"
	w "["  
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCCM.QueryPatient","GetPhwardDateList",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCCM.QueryPatient","GetPhwardDateList",pid,index))
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w "]"
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：    2016-11-21
/// Description：  通过日期查询药学查房的信息
/// Table：        DHC_PHWardRound,DHC_PHWRGuidance ,DHC_PHWRDrgItm     
/// input:		   日期
/// Output：       患者药学查房信息串
/// Others：       w ##class(web.DHCCM.QueryPatient).GetPharoundsInfo("2017-01-11",1609)
ClassMethod GetPharoundsInfo(date As %String, EpisodeID As %String) As %String
{
	n (date,EpisodeID)
	s pid=##class(web.DHCCM.MedRecCom).NewPid()
    d ..killTmpGlobal(pid) 		// k掉临时global
    s h=0,count=0
	s date=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(date)
	s DataList="",Datastr=""
	s PhwrRowId=""
	f  s PhwrRowId=$o(^DHCPHWR(0,"DataAdm",date,EpisodeID,PhwrRowId)) q:PhwrRowId=""  d //^DHCPHWR(0,"DataAdm",{PHWR_Date},{PHWR_Adm_Dr},{PHWR_RowID})
	.s Phwrguidance=$p(^DHCPHWR(PhwrRowId),"^",7)
	.s PhwrCode= ..GetPhwrcontent(PhwrRowId)
	.s InciDesc= ..GetDrugDesc(PhwrRowId)
	.s Datastr=Phwrguidance_"^"_PhwrCode_"^"_InciDesc
	.s h=h+1
	.s ^TMP("DHCST","web.DHCCM.QueryPatient","GetPharoundsInfo",pid,h)=Datastr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="Phwrguidance^PhwrCode^InciDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串  
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCCM.QueryPatient","GetPharoundsInfo",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCCM.QueryPatient","GetPharoundsInfo",pid,index))
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// descript: 获取药学查房指导信息
/// w ##class(web.DHCCM.QueryPatient).GetPhwrcontent(4)
ClassMethod GetPhwrcontent(PhwrRowId)
{
	n (PhwrRowId)
	s curstatu=""
	s phgsCode=""
	&sql(select PHWR_CurStatus into:curstatu from DHC_PHWardRound where PHWR_RowID=:PhwrRowId)
	s PhwrSub="",ListData=""   //指导内容表 DHC_PHWRGuidance
	f  s PhwrSub=$o(^DHCPHWR(PhwrRowId,"G",PhwrSub)) q:PhwrSub=""  d
	.s phgsRowId=$p(^DHCPHWR(PhwrRowId,"G",PhwrSub),"^",1)
	.q:phgsRowId="-100"
	.q:+phgsRowId=0
	.i curstatu="N"  d
	..s phgsDesc=$p(^DHCPHGS(phgsRowId),"^",2)
	..s phgsCode=$p(^DHCPHGS(phgsRowId),"^")
	..i phgsCode["." d
	...s ListData=ListData_"-"_phgsDesc_"；<br>"
	..e  d
	...s ListData=ListData_phgsDesc_"；<br>"
	.i curstatu="I"  d
	..s phgsDesc=$p(^DHCPHGS(phgsRowId),"^",2)
	..s phgsCode=$p(^DHCPHGS(phgsRowId),"^")
	..i phgsCode["." d
	...s ListData=ListData_"-"_phgsDesc_"；<br>"
	..e  d
	...s ListData=ListData_phgsDesc_"；<br>"
	.i curstatu="O"  d
	..s phgsDesc=$p(^DHCPHGS(phgsRowId),"^",2)
	..s phgsCode=$p(^DHCPHGS(phgsRowId),"^")
	..i phgsCode["." d
	...s ListData=ListData_"-"_phgsDesc_"；<br>"
	..e  d
	...s ListData=ListData_phgsDesc_"；<br>"
	q ListData
}

/// descript: 获取药学查房关注药品信息
/// w ##class(web.DHCCM.QueryPatient).GetDrugDesc(1)
ClassMethod GetDrugDesc(PhwrRowId)
{
	n (PhwrRowId)
	s i=1
	s InciDesc=""
	s PhdSub=""
	f  s PhdSub=$o(^DHCPHWR(PhwrRowId,"DI",PhdSub)) q:PhdSub=""  d
	.s OeordItmId=$p(^DHCPHWR(PhwrRowId,"DI",PhdSub),"^",1) //OE_OrdItem
	.s OeordRowId=$p(OeordItmId,"||",1)
	.s OeoriChildsub=$p(OeordItmId,"||",2)
	.s ItmastId=$p(^OEORD(OeordRowId,"I",OeoriChildsub,1),"^",2)   //医嘱项ARC_ItmMast ARCIM_RowId
	.;s ArcimSub=$p(ItmastId,"||",1)
	.;s ArcimVersion=$p(ItmastId,"||",2)
	.;s ItmcatId=$p(^ARCIM(ArcimSub,ArcimVersion,1),"^",10)    //ARC_ItemCat  ARCIC_RowId
	.;s Ordertype=$P(^ARC("IC",ItmcatId),"^",7)
	.;q:(Ordertype'="R")
	.s inciId=$o(^INCI(0,"ARCIM_DR",$p(ItmastId,"||",1),""))     //INC_Itm
	.q:inciId=""	
	.s InciDesc=InciDesc_","_i_"、"_$p(^INCI(inciId,1),"^",2)  //药品名称
	.s i=i+1
	q InciDesc
}

/// Descritp:病区列表
/// w ##class(web.DHCCM.QueryPatient).SelAllWard()
ClassMethod SelAllWard() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT Ward_Rowid As WardID,Ward_Desc As WardDesc FROM PAC_WARD"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s WardDr = result.Data("WardID")
		s WardDesc = result.Data("WardDesc")
		continue:WardDesc["停"
		s tmp=WardDr_"^"_WardDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descritp:科室信息
/// d ##class(web.DHCCM.QueryPatient).SelAllLoc()
ClassMethod SelAllLoc(LocType As %String = "", HospID As %String = "") As %String
{
	N (LocType, HospID)
	//s LocType=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTLOC_ROWID as LocDr,CTLOC_DESC as LocDesc FROM CT_LOC"
	s:LocType'="" sqlStr=sqlStr_" where CTLOC_NationCode="_""""_LocType_""""
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s LocDr = result.Data("LocDr")
		continue:(HospID'="")&(HospID'=$p(^CTLOC(LocDr),"^",22))
		s LocDesc = result.Data("LocDesc")
		continue:(LocDesc["停")||(LocDesc["工作量")
		s tmp=LocDr_"^"_LocDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCCM.QueryPatient","QueryMedRecord",pid)
	k ^TMP("DHCST","web.DHCCM.QueryPatient","GetPatientinfoByWard",pid)
	k ^TMP("DHCST","web.DHCCM.QueryPatient","Gettiemtreelist",pid)
	k ^TMP("DHCST","web.DHCCM.QueryPatient","GetPhwardDateList",pid)
	k ^TMP("DHCST","web.DHCCM.QueryPatient","GetPharoundsInfo",pid)
	k ^TMP("DHCST","web.DHCCM.QueryPatient","GetMedinfo",pid)
}

}
