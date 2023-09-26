Import SQLUser

Class web.DHCSTPHCMAPPPatManage Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// ===========================================================================================================
/// Descript: 科室病人列表
/// W ##Class(web.DHCSTPHCMAPPPatManage).QueryLocPatientList("256")
ClassMethod QueryLocPatientList(LgLocID As %String) As %String
{
	n (LgLocID)
    s pid=..NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    s OutBinStream=##Class(%GlobalCharacterStream).%New()
    /// 根据取本科室病人列表
    s Num=##Class(web.DHCSTPHCMAPPPatManage).QueryPatListByLocID(pid,LgLocID)
	///转换数据为Json格式
	s ListTitle="PatientID^hasAllergy^EpisodeID^AdmLocId^WardID^Ward^CurrRoom^BedId^BedNo^PatNo^PatName^PatSex^PatAge^PatWeight^PatHeight^AdmDate^AdmDoctor^EmpPatMonLevel^EmpPatMonLevelId^monSubClassId^PatLoc^PatDiagDesc^BillType^PatCardNo^TotalMount^DrugTotalMount"
	d OutBinStream.Write("[") //输出json前缀串
	s BedId="",index="",count=0
	f  s BedId=$o(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","QueryLocPatientList",BedId)) Q:BedId=""  D
	.f  s index=$o(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","QueryLocPatientList",BedId,pid,index)) Q:index=""  D
	..s ListData=$g(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","QueryLocPatientList",BedId,pid,index))
	..s count = count+1
	..I count=1 d
	...d OutBinStream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	..e  d
	...d OutBinStream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
    d OutBinStream.Write("]") //输出json结尾符	
	D ..killTmpGlobal(pid) //k掉临时global
	Q OutBinStream
}

/// Descript: 根据科室获取科室病人列表
/// W ##Class(web.DHCSTPHCMPatientManage).QueryPatListByLocID("36")
ClassMethod QueryPatListByLocID(pid As %String, LgLocID As %String) As %String
{
	n (pid, LgLocID)
	s Num=0
	s WardID=""
	f  s WardID=$o(^PAWARD(0,"WARD_LocationDR",LgLocID,WardID)) Q:WardID=""  D
	.s CurRoomID=""
	.f  s CurRoomID=$o(^PAADMi("CurrWard",WardID,CurRoomID)) q:CurRoomID=""  d
	..s EpisodeID=""
	..f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,CurRoomID,EpisodeID)) q:EpisodeID=""  d
	...s PatVisit=$p(^PAADM(EpisodeID),"^",20)
	...Q:PatVisit'="A"
	...s ListData=##Class(web.DHCSTPHCMAPPPatManage).GetPatientInfo(EpisodeID,LgLocID)
	...s Num=Num+1
	...s BedId = $p($p(ListData,"^",8),"||",2)
	...q:BedId="" //qunianpeng 2017/11/29 入院病人还没有安排床位,在等待区  此时床号为空 
	...s ^TMP("DHCST","web.DHCSTPHCMAPPPatManage","QueryLocPatientList",BedId,pid,Num)=ListData
	Q Num
}

/// Descript: 病人就诊信息
/// W ##Class(web.DHCSTPHCMAPPPatManage).GetPatientInfo("1653","36")
ClassMethod GetPatientInfo(EpisodeID As %String, PatLocId As %String) As %String
{
	n (EpisodeID,PatLocId)
	Q:EpisodeID="" ""
	s AdmDate=$p(^PAADM(EpisodeID),"^",6)  /// 就诊日期
	s AdmTime=$p(^PAADM(EpisodeID),"^",7)  /// 就诊时间
	i AdmDate'="" s AdmDate=$zd(AdmDate,3)
	i AdmTime'="" s AdmTime=$zt(AdmTime,1)
	s AdmDate=AdmDate //_" "_AdmTime
	s Ward=""
	s WardID=$p(^PAADM(EpisodeID),"^",70)  /// 病区
	i WardID'="" s Ward=$p(^PAWARD(WardID),"^",2)
	s BedID=$p(^PAADM(EpisodeID),"^",73)      /// 床号
	s BedNo=""
    i BedID'="" s BedNo=$p(^PAWARD($p(BedID,"||",1),"BED",$p(BedID,"||",2)),"^",1)
	s PatientID=$p(^PAADM(EpisodeID),"^",1)      /// 病人ID
	s algChildSub=$o(^PAPER(PatientID,"ALG","")) 
	i algChildSub="" s hasAllergy="false"
	e  s hasAllergy="true"
	s AdmLocId=$p(^PAADM(EpisodeID),"^",4) //科室
    s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 病人姓名
    s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 病人登记号
	s SexID=$p(^PAPER(PatientID,"ALL"),"^",7 )   /// 姓别
    s PatSex=""
    i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID)         /// 年龄
	s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") /// 诊断
    s PatWeight=##class(web.DHCSTCNTSCOMMON).GetPatWeight(EpisodeID) /// 体重
    s PatHeight=##class(web.DHCSTCNTSCOMMON).GetPatHeight(EpisodeID) /// 身高
 	i PatLocId'="" s PatLoc=$p($p(^CTLOC(PatLocId),"^",2),"-",2)
	s CurrRoom=""
	s CurrRoomID=$p(^PAADM(EpisodeID),"^",69)   /// 房间号
	s:CurrRoomID'="" CurrRoom=$p(^PAROOM(CurrRoomID),"^",2)
	s AdmDoctor=""
	s AdmDocCodeDR=$p(^PAADM(EpisodeID),"^",9)   /// 医生
	s:AdmDocCodeDR'="" AdmDoctor=$p(^CTPCP(AdmDocCodeDR,1),"^",2)
	s EmpPatLevel=..GetEmpPatMonLevel(EpisodeID) /// 监护级别
	s EmpPatMonLevelId=$p(EmpPatLevel,"^",1)
	s EmpPatMonLevel=$p(EmpPatLevel,"^",2)
	s monSubClassId=##Class(web.DHCSTPHCMPHARCAREMAIN).getMonSubClass(AdmLocId) //学科分类id
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s PatCardNo=##Class(web.DHCSTPHCMAPPPatManage).GetCardNoByRegNo(PatientID)    /// 获取卡号
	s PatCost=..GetTotalAmount(EpisodeID)	//qunianpeng 2017/12/12增加总费用和药品费用
	s TotalMount=$p(PatCost,"^",1)			//总费用
	s DrugTotalMount=$p(PatCost,"^",2)		//药品费用
	i DrugTotalMount=0 s DrugTotalMount=""
	s ListData=PatientID_"^"_hasAllergy_"^"_EpisodeID_"^"_AdmLocId_"^"_WardID_"^"_Ward_"^"_CurrRoom_"^"_BedID_"^"_BedNo_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge
	s ListData=ListData_"^"_PatWeight_"^"_PatHeight_"^"_AdmDate_"^"_AdmDoctor_"^"_EmpPatMonLevel_"^"_EmpPatMonLevelId_"^"_monSubClassId_"^"_PatLoc_"^"_PatDiagDesc
	s ListData=ListData_"^"_BillType_"^"_PatCardNo_"^"_TotalMount_"^"_DrugTotalMount	
	Q ListData
}

/// ====================================关注患者============================================
/// Descript:获取患者监护级别
/// w ##class(web.DHCSTPHCMPatientManage).GetEmpPatMonLevel("1609")
ClassMethod GetEmpPatMonLevel(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s EmpPatID=$o(^DHCPHEP(0,"ADMDR",EpisodeID,""),-1)
	Q:EmpPatID="" ""
	Q:$p(^DHCPHEP(EmpPatID),"^",7)'="" ""
	s mLevelID=$p(^DHCPHEP(EmpPatID),"^",6)   /// 监护级别ID
	s mLevelDesc=$p(^DHCPHML(mLevelID),"^",2) /// 监护级别
	Q mLevelID_"^"_mLevelDesc
}

/// Descript:  保存重点关注患者
/// Input:     empPatID：重点患者表ID
/// 			   empPatDataList：开始日期^开始时间^病人ADM^病区ID^科室ID^监护级别^操作人^备注^结束日期^结束时间^原因
/// w ##class(web.DHCAPPPatManage).saveEmpPat("3","^^1609^0^578^^^^")
ClassMethod saveEmpPat(mLevelID As %String, empPatDataList As %String) As %GlobalCharacterStream
{
	n (mLevelID, empPatDataList)
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	i mLevelID="" d
	.s ret=..insEmpPat(empPatDataList)
	e  d
	.s ret=..updEmpPat(mLevelID,empPatDataList)
	d OutBinStream.Write(ret)
	Q OutBinStream
}

/// Descript:插入重点关注患者记录表
/// w ##class(web.DHCAPPPatManage).insEmpPat("^^273^3^578^^2017-03-17^16:01^")
ClassMethod insEmpPat(empPatDataList As %String) As %String
{
	n (empPatDataList)
	s startDate=$p(empPatDataList,"^",1)   /// 开始日期
	s:startDate'="" startDate=$zdh(startDate,3)
	s startTime=$p(empPatDataList,"^",2)   /// 开始时间
	s:startTime'="" startTime=$zth(startTime_":00",1)
	s EpisodeID=$p(empPatDataList,"^",3)   /// 病人ADM
	s wardID=$p(^PAADM(EpisodeID),"^",70)  /// 病区
	s locID=$p(^PAADM(EpisodeID),"^",4)    /// 科室
	s mLevelID=$p(empPatDataList,"^",4)    /// 监护级别
	s opUserID=$p(empPatDataList,"^",5)    /// 操作人
	s remark=$p(empPatDataList,"^",6)      /// 备注
	s reason = $p(empPatDataList,"^",7)    ///原因
	&SQL(Insert Into DHC_PHEmpPat(PHEP_StartDate,PHEP_StartTime,PHEP_Adm_Dr,PHEP_Ward_Dr,PHEP_Dept_Dr,PHEP_ML_DR,PHEP_User_Dr,PHEP_Remark,PHEP_Reason)
		 Values(:startDate,:startTime,:EpisodeID,:wardID,:locID,:mLevelID,:opUserID,:remark,:reason))
	Q SQLCODE
}

/// Descript:更新重点关注患者记录表
/// w ##class(web.DHCSTPHCMPatientManage).updEmpPat("1","^^273^3^578^^2017-03-17^16:01^")
ClassMethod updEmpPat(mLevelID As %String, empPatDataList As %String) As %String
{
	n (mLevelID,empPatDataList)
	s EpisodeID=$p(empPatDataList,"^",3)   /// 病人ADM
	s emLevelID=$p(empPatDataList,"^",4)    /// 监护级别
	s remark=$p(empPatDataList,"^",6)      /// 备注
	s reason=$p(empPatDataList,"^",7) 	 /// 原因
	s endDate=$p(empPatDataList,"^",8)   /// 结束日期
	s:endDate'="" endDate=$zdh(endDate,3)
	s endTime=$p(empPatDataList,"^",9)   /// 结束时间
	s:endTime'="" endTime=$zth(endTime_":00",1)
	&SQL(update DHC_PHEmpPat set PHEP_EndDate=:endDate,PHEP_EndTime=:endTime,PHEP_Remark=:remark,PHEP_Reason=:reason,PHEP_ML_DR=:emLevelID where PHEP_Adm_Dr=:EpisodeID)
	Q SQLCODE
}

/// Descript:获取重点患者相关信息
/// w ##class(web.DHCAPPPatManage).getEmpPatInfo("1653")
ClassMethod getEmpPatInfo(admDr As %String) As %GlobalCharacterStream
{
	n (admDr)
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	s empPatID=$o(^DHCPHEP(0,"ADMDR",admDr,""),-1)
	q:empPatID="" ""
	q:$p(^DHCPHEP(empPatID),"^",7)'="" ""
	s startDate=$p(^DHCPHEP(empPatID),"^",1)  //开始日期
	s:startDate'="" startDate=$zd(startDate,3)
	s startTime=$p(^DHCPHEP(empPatID),"^",2)  //开始时间
	s:startTime'="" startTime=$zt(startTime,1)
	s mLevelID=$p(^DHCPHEP(empPatID),"^",6)   //监护级别
	s opUser=""
	s opUserID=$p(^DHCPHEP(empPatID),"^",9)   //操作人
	s:opUserID'="" opUser=$p(^SSU("SSUSR",opUserID),"^",2)
	s remark=$p(^DHCPHEP(empPatID),"^",10)    //备注
	s reason=$p(^DHCPHEP(empPatID),"^",11)    //原因
	d OutBinStream.Write(##class(web.DHCAPPJsonCommon).getJsonData("empPatID^startDate^startTime^mLevelID^opUserID^opUser^remark^reason",empPatID_"^"_startDate_"^"_startTime_"^"_mLevelID_"^"_opUserID_"^"_opUser_"^"_remark_"^"_reason))
	Q OutBinStream
}

/// 获取监护级别列表
/// DHC_PHMonLevel
/// w ##class(web.DHCAPPPatManage).QueryMonLevel()
ClassMethod QueryMonLevel() As %GlobalCharacterStream
{
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s OutBinStream=##Class(%GlobalCharacterStream).%New()
	s h=0,count=0
	s ID=""
    f  s ID=$o(^DHCPHML(ID)) q:ID=""  d
    .s Code=$p(^DHCPHML(ID),"^",1)
    .s Desc=$p(^DHCPHML(ID),"^",2)
	.s h=h+1
	.s TempStr=ID_"^"_Code_"^"_Desc
	.s ^TMP("DHCST","web.DHCSTPHCMAPPPatManage","QueryMonLevel",pid,h)=TempStr	
	///转换数据为Json格式
	S Title="ID^Code^Desc"
	d OutBinStream.Write("[")
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","QueryMonLevel",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","QueryMonLevel",pid,index))
	.s count = count+1
	.I count=1 d
	..d OutBinStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate))
	.e  d
	..d OutBinStream.Write(","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate))
	d OutBinStream.Write("]")
	d ..killTmpGlobal(pid) //k掉临时global
	q OutBinStream
}

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMPatientManage"))
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCSTPHCMAPPPatManage","QueryLocPatientList",pid)
	K ^TMP("DHCST","web.DHCSTPHCMAPPPatManage","GetPatOEInfoNew",pid)
	k ^TMP("DHCST","web.DHCSTPHCMAPPPatManage","QueryMonLevel",pid)
	Q ""
}

/// Descript: 获取病人卡号
/// w ##Class(web.DHCAPPPrintCom).GetCardNoByRegNo("6335788")
ClassMethod GetCardNoByRegNo(Papmi As %String) As %String
{
	n (Papmi)
	Q:Papmi="" ""
	s CardNo=""
 	s CFRowID="0"
	f  s CFRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",Papmi,CFRowID))  Q:CFRowID=""  D
 	.s ActiveFlag=$p(^DHCCARD("CF",CFRowID),"^",10)
 	.Q:ActiveFlag'="N"
 	.s CardNo=$p(^DHCCARD("CF",CFRowID),"^",2)
 	.
 	Q CardNo
}

/// ====================================患者诊断信息============================================
/// 获取诊断信息
/// Creator: 	yangyongtao
/// CreateDate: 2016-12-27
/// 通过病人的ID获取诊断信息
/// Creator: 	yangyongtao
/// CreateDate: 2016-12-27
/// Others:		 w ##class(web.DHCSTPHCMPatientManage).QueryAppDiagtList("100","1","651")
ClassMethod QueryAppDiagtList(PatID As %String) As %GlobalCharacterStream
{
	 n (PatID)
	 s OutBinStream=##Class(%GlobalCharacterStream).%New()
	 S pid=..NewPid()
	 S patNo=$p(PatID,"^",1)    //病人I
	 S admID=$p(PatID,"^",2)     //就诊ID
	 S n=0     
     S admtype=""
     F  S admtype=$o(^PAPERdr(patNo,"ADM",admtype),-1) Q:admtype=""  D
	 .S adm="" 
	 .F  S adm=$o(^PAPERdr(patNo,"ADM",admtype,adm),-1) Q:adm=""  D  //就诊ID
	 ..Q:(admID'="")&(admID'=adm)
	 ..S depDesc=""  
	 ..S depcodedr=$p(^PAADM(adm),"^",4)  //
	 ..s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",") /// 诊断
	 ..Q:PatDiagDesc=""
	 ..s AdmDoctor=""
	 ..s AdmDocCodeDR=$p(^PAADM(adm),"^",9)   /// 医生
	 ..s:AdmDocCodeDR'="" AdmDoctor=$p(^CTPCP(AdmDocCodeDR,1),"^",2)
	 ..I depcodedr'="" S depDesc=$p(^CTLOC(depcodedr),"^",2)
	 ..I depDesc'="" S depDesc=$p(depDesc,"-",2) //获取科室描述
	 ..S admdate=$p(^PAADM(adm),"^",6) //就诊日期
	 ..I +admdate>0 S admdate=$zd(admdate,3) 
	 ..S admtime=$p(^PAADM(adm),"^",7) //就诊时间
	 ..I +admtime>0 S admtime=$zt(admtime)
	 ..S n=n+1
	 ..S data=$g(adm)_"^"_$g(depDesc)_"^"_$g(admdate)_" "_$g(admtime)_"^"_patNo_"^"_PatDiagDesc_"^"_AdmDoctor_"^"_AdmDocCodeDR
	 ..S ^TMP("DHCST","web.DHCSTPHCMAPPPatManage","QueryDiagtList",pid,n)=data	 
    ; Q:n=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(n) //输出空的json串
     ;S maxrow=n
     S count=0
     d OutBinStream.Write("[") //输出json前缀串
     S h=""
     F  S h=$o(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","QueryDiagtList",pid,h)) Q:h=""  D
     .S mdata=^TMP("DHCST","web.DHCSTPHCMAPPPatManage","QueryDiagtList",pid,h)
     .S count = count+1
	 .S Title="Adm^AdmLoc^dateTime^patNo^diagDesc^AdmDoctor^AdmDocCodeDR"
	 .;Q:(count<Start)||(count>End)
	 .I count=1 D
	 ..d OutBinStream.Write(##class(web.DHCAPPJsonCommon).getJsonData(Title,mdata))
	 .E  D
	 ..d OutBinStream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(Title,mdata))	
	 d OutBinStream.Write("]") //输出json结尾符
	 K ^TMP("DHCST","web.DHCSTPHCMAPPPatManage","QueryDiagtList",pid)
     Q OutBinStream
}

/// ====================================患者医嘱信息============================================
/// 获取医嘱信息
/// 2016-11-27^2017-11-30^460^S#^V#^R#
/// w ##class(web.DHCSTPHCMAPPPatManage).GetPatOEInfoNew("2016-11-27","2017-11-30","7500125","S#^","V#","R#")
ClassMethod GetPatOEInfoNew(startDate As %String, stopDate As %String, AdmDr As %String, priCodeString As %String, OeFlagString As %String, orderTypeString As %String) As %GlobalCharacterStream
{
	N (startDate,stopDate,AdmDr,priCodeString,OeFlagString,orderTypeString)
	s sDate=$case(+startDate,0:$h-100,:$zdh(startDate,3))
	s sTop=$case(+stopDate,0:+$h,:$zdh(stopDate,3))
	Q:AdmDr="" "-1"
	S ord=$o(^OEORD(0,"Adm",AdmDr,""))
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	S Num=0
	S chl=0 
	F  S chl=$o(^OEORD(ord,"I",chl)) q:(chl="")||(chl=0)  d  
	.S orditm=ord_"||"_chl
	.S priDr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    .Q:priDr=0 
    .S priorty=$p(^OECPR(priDr),"^",1) //医嘱优先级代码     //OEC_Priority 医嘱优先级的表  如果要保留出院带药的，proCode=OUT的不要退出即可
    .s lpriorty=$p(priCodeString,"#",1)
    .s tpriorty=$p(priCodeString,"#",2)
    .s tempPriorty=""					//qunianpeng 2017/12/14默认优先级为空  查询优先级选择：1.长嘱空 临嘱空 2.长嘱不空 临嘱不空  查全部
    .i (lpriorty'="")&&(tpriorty="") s tempPriorty=$LB("S","OMST")	//长嘱不空,临嘱空时，查医嘱优先级为长期医嘱S 和 自备药长期OMST
	.i (lpriorty="")&&(tpriorty'="") s tempPriorty=$LB("NORM","ONE","OM","OUT")	//长嘱空，临嘱不空，要查询出医嘱优先级为临嘱NORM 取药医嘱ONE 自备药即刻OM 出院带药OUT
    .q:(tempPriorty'="")&&($LISTFIND(tempPriorty,priorty)=0)    
    .//i (lpriorty'="")&&(tpriorty'="") Q:(priorty'=lpriorty)&&(priorty'=tpriorty)
    .//e  Q:((lpriorty'="")&&(priorty'=lpriorty)&&(priorty '="OUT"))||((tpriorty'="")&&(priorty'=tpriorty)&&(priorty '="OUT") )
    .S priortyDesc=$p(^OECPR(priDr),"^",2) //医嘱优先级
    .s orddate=$p(^OEORD(ord,"I",chl,3),"^",7) //开单日期
    .q:(sDate'="")&&(sTop'="")&&(sDate>orddate)
    .q:(sDate'="")&&(sTop'="")&&(sTop<orddate)
    .q:(sDate'="")&&(sTop="")&&(sDate>orddate)
	.i orddate'="" s orddate=$zd(orddate,3)	
    .s ordtime=$p(^OEORD(ord,"I",chl,3),"^",15) //开单时间
    .i ordtime'="" s ordtime=$zt(ordtime,1)
    .s orddatetime=orddate_" "_ordtime  //开单日期^开单时间
    .S StatDr=$p(^OEORD(ord,"I",chl,1),"^",13)
    .S OeFlag=$p(^OEC("OSTAT",StatDr),"^",1)			
    .S OeRowID=$o(^OEC("OSTAT",0,"Code",$$ALPHAUP^SSUTIL4(OeFlag),""))
    .s OeDesc=$p(^OEC("OSTAT",OeRowID),"^",2) 	//医嘱状态
	.Q:OeFlag="U" //作废
    .s OeFlagy=$p(OeFlagString,"#",1)
    .s OeFlagn=$p(OeFlagString,"#",2)
    .i (OeFlagy'="")&&(OeFlagn'="") Q:(OeFlag'=OeFlagy)&&(OeFlag'=OeFlagn)
    .e  Q:((OeFlagy'="")&&(OeFlag'=OeFlagy))||((OeFlagn'="")&&(OeFlag'=OeFlagn))
	.S FillerNo=$p(^OEORD(ord,"I",chl,9),"^",12) //滚医嘱来源信息 OEORI_FillerNo（首条长嘱）
    .Q:(FillerNo'="")&(FillerNo'=orditm_"!!"_orditm)&(OeFlag'="D")  //长嘱非首日和截止日期的记录过滤
	.S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	.S ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .s drugType=$p(orderTypeString,"#",1)
    .s allType=$p(orderTypeString,"#",2)			//qunianpeng 2017/12/14 重写过滤条件
    .s tmpType=""	//默认查询医嘱类别为空 1查询类别为 药品状态R,全部状态为all  2药品状态空 全部状态all 3药品状态空 全部状态空  
   	.i (drugType="R")&&(allType="") s tmpType="R"	//药品状态R，全部状态空
	.q:(tmpType'="")&&(ordertype'=tmpType)
    .//Q:(drugType'="")&&(ordertype'=drugType)
    .s OeFlagn=$p(OeFlagString,"#",2)
    .s itmmastid=$p(ArcItmId,"||",1)
	.s itmmastver=$p(ArcItmId,"||",2)
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) /// 医嘱项名称 
    .i ordertype="R"  d
	..S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	..Q:inci=""  //医嘱名称
	..S arcitmdesc=$p(^INCI(inci,1),"^",2) //药品名称
	..S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) //OEORI_PHFreq_DR
    ..S freq=$p($g(^PHCFR(freqdr)),"^",3) //频率
    ..S instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    ..S instru=$p($g(^PHCIN(instrudr)),"^",2) //用法
    ..S dosage=$p(^OEORD(ord,"I",chl,2),"^",1)      //剂量
	..S dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	..S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)   //剂量单位
	..S phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) q:phcdf=""
    ..S EndDate=$p(^OEORD(ord,"I",chl,3),"^",34)     //停止日期
	..S:EndDate'="" EndDate=$zd(EndDate,3)
	..S EndTime=$p(^OEORD(ord,"I",chl,2),"^",15)     //停止时间
	..S:EndTime'="" EndTime=$zt(EndTime,3)
	.S doctorID=$p($g(^OEORD(ord,"I",chl,7)),"^",1) //医生ID
    .Q:doctorID=""
    .S doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(ord_"||"_chl)  //医生
	.S StartDate=$p(^OEORD(ord,"I",$p(orditm,"||",2),1),"^",9)  //开始日期(要求开始执行)
	.S DEndDate=""
	.S:StartDate'="" DEndDate=$zd(StartDate+3,3) //结束日期
	.S:StartDate'="" StartDate=$zd(StartDate,3)
	.S StartTime=$p(^OEORD(ord,"I",$p(orditm,"||",2),1),"^",10)  //开始时间(要求开始执行)
	.S:StartTime'="" StartTime=$zt(StartTime,3)
	.S moeori=..GetMainOeoriNew(orditm)
	.S groupFlag=""	//成组医嘱显示符	
    .S index=Num 
	.S Num=Num+1 
	.S ^TMP("DHCST","web.DHCSTPHCMAPPPatManage","GetPatOEInfoNew",pid,index)=moeori_"^"_orditm_"^"_$g(phcdf)_"^"_$g(arcitmdesc)_"^"_$g(freqdr)_"^"_$g(freq)_"^"_$g(instrudr)_"^"_$g(instru)_"^"_StartDate_"^"_StartTime_"^"_$g(EndDate)_"^"_$g(EndTime)_"^"_OeFlag_"^"_OeDesc_"^"_priortyDesc_"^"_doctor_"^"_groupFlag_"^"_orddatetime_"^"_$g(dosage)_"^"_$g(doseuom)_"^"_DEndDate
	.// 临时global用于输出时判断成组医嘱  显示成组符
	.S ^TMP("DHCST","web.DHCSTPHCMAPPPatManage","GetPatOEInfoNew","moeori",ord,chl)=^TMP("DHCST","web.DHCSTPHCMAPPPatManage","GetPatOEInfoNew",pid,index)
	S Title="moeori^orditm^phcdf^arcitmdesc^freqdr^freq^instrudr^instru^StartDate^StartTime^EndDate^EndTime^OeFlag^OeDesc^priortyDesc^doctor^groupFlag^orddatetime^dosage^doseuom^DEndDate"
	//主医嘱^开始时间^^药品名称^OEORI_PHFreq_DR^频次^用法^开始日期^开始时间^结束日期^结束时间^作废医嘱^医嘱优先级^医生
	S quitflag=0
	;w "["
	d OutBinStream.Write("[")
	S Num=0
	S index=""
	s chl=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","GetPatOEInfoNew",pid,index)) Q:(index="")||(quitflag=1)  D	
	.s moeori=$p(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","GetPatOEInfoNew",pid,index),"^",1)
	.s orditm=$p(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","GetPatOEInfoNew",pid,index),"^",2)
	.s ord=$p(orditm,"||",1)
	.s markChild=$d(^OEORDi(0,"OEORI",ord,orditm))	
	.s chl=$p(orditm,"||",2) 
	.s chl=$o(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","GetPatOEInfoNew","moeori",ord,chl)) 	
	.s tempMoeori=""
	.s:chl'="" tempMoeori=$p(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","GetPatOEInfoNew","moeori",ord,chl),"^",1)
	.//主医嘱 
	.s:(moeori="")&&(markChild>0)&&(tempMoeori'="") $p(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","GetPatOEInfoNew",pid,index),"^",17)="┏"
	.s:(moeori="")&&(markChild>0)&&(tempMoeori="") $p(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","GetPatOEInfoNew",pid,index),"^",17)=""
	.//子医嘱
	.s:(moeori'="")&&(tempMoeori'="") $p(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","GetPatOEInfoNew",pid,index),"^",17)="▏"
	.s:(moeori'="")&&(tempMoeori="") $p(^TMP("DHCST","web.DHCSTPHCMAPPPatManage","GetPatOEInfoNew",pid,index),"^",17)="┗"		
	.S mdata=^TMP("DHCST","web.DHCSTPHCMAPPPatManage","GetPatOEInfoNew",pid,index)	
	.S Num=Num+1
	.;Q:Num<StPage
	.;S:Num=EndPage quitflag=1
	.I Num=1 d
	..d OutBinStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata))
	..;w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..d OutBinStream.Write(","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata))
	..;w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	d OutBinStream.Write("]")  //输出json结尾符
	;w "]"
	d ..killTmpGlobal(pid)
	q OutBinStream
	;q ""
}

ClassMethod GetMainOeoriNew(oeori As %String) As %String
{
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	Q:'$D(^OEORD(ord,"I",chl,11)) ""
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:loeori'="" loeori
 	Q ""
}

/// ====================================药学监护============================================
/// ========================================================================================
/// Descript:获取监护范围列表
/// w ##class(web.DHCSTPHCMPHARCAREMAIN).getMonScopeList("1/2/3/4","1")
ClassMethod getMonScopeList(monSubClassID As %String, monLevelID As %String) As %GlobalCharacterStream
{
	n (monSubClassID,monLevelID)
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	s Len=$l(monSubClassID,"/")						//qunianpeng 2016-09-20  
	s count=0 
	i (monSubClassID="")||(monLevelID="") d OutBinStream.Write("[]")
	q:(monSubClassID="")||(monLevelID="") ""
	d OutBinStream.Write("[")
	f i=1:1:Len d 								//qunianpeng 2016-09-20
	.s PHMSSubClassDR=$p(monSubClassID,"/",i)   //qunianpeng 2016-09-20
	.s monScopeID=""
	.f  s monScopeID=$o(^DHCPHMS(0,"SubClassLevel",PHMSSubClassDR,monLevelID,monScopeID)) q:monScopeID=""  d
	..s monScopeDesc=$p(^DHCPHMS(monScopeID),"^",2)
	..s PHMSCRowID=$p(^DHCPHMS(monScopeID),"^",5)    //取学科分类的ID    qunianpeng 2016-09-20
	..s PHMSCDesc=$p(^DHCPHMSC(PHMSCRowID),"^",2)    //取纳入标准对应的学科分类   qunianpeng 2016-09-20
	..s ListData=PHMSCRowID_"^"_PHMSCDesc_"^"_monScopeID_"^"_monScopeDesc	
	..s count = count+1
	..I count=1 d
	...d OutBinStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonData("PHMSCRowID^PHMSCDesc^monScopeID^monScopeDesc",ListData))
	..e  d
	...d OutBinStream.Write(","_##class(web.DHCSTPHCMCOMMON).getJsonData("PHMSCRowID^PHMSCDesc^monScopeID^monScopeDesc",ListData))
	d OutBinStream.Write("]")
	q OutBinStream
}

/// Descript:获取监护项目列表
/// w ##class(web.DHCSTPHCMPHARCAREMAIN).getMonItemList("1/2/3","1")
ClassMethod getMonItemList(monSubClassID As %String, monLevelID As %String) As %GlobalCharacterStream
{
	n (monSubClassID,monLevelID)
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	s Len=$l(monSubClassID,"/")						//qunianpeng 2016-09-20
	s count=0
	
	i (monSubClassID="")||(monLevelID="") d OutBinStream.Write("[]")
	q:(monSubClassID="")||(monLevelID="") ""
	d OutBinStream.Write("[")
	
	f i=1:1:Len d 								//qunianpeng 2016-09-20
	.s PHMISubClassDR=$p(monSubClassID,"/",i)   //qunianpeng 2016-09-20
	.s monItemID=""
	.f  s monItemID=$o(^DHCPHMI(0,"SubClassLevel",PHMISubClassDR,monLevelID,monItemID)) q:monItemID=""  d
	..s monItemDesc=$p(^DHCPHMI(monItemID),"^",2)
	..s monItemUom=$p(monItemDesc,"[]","2")
	..s monItemDesc=$p(monItemDesc,":")_"："
	..s PHMSCRowID=$p(^DHCPHMI(monItemID),"^",5)  	//取学科分类的ID 
	..s PHMSCDesc=$p(^DHCPHMSC(PHMSCRowID),"^",2)   //取监护项目对应的学科分类
	..s ListData=PHMSCRowID_"^"_PHMSCDesc_"^"_monItemID_"^"_monItemDesc_"^"_monItemUom
	..s count = count+1
	..I count=1 d
	...d OutBinStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonData("PHMSCRowID^PHMSCDesc^monItemID^monItemDesc^monItemUom",ListData))
	..e  d
	...d OutBinStream.Write(","_##class(web.DHCSTPHCMCOMMON).getJsonData("PHMSCRowID^PHMSCDesc^monItemID^monItemDesc^monItemUom",ListData))
	d OutBinStream.Write("]")
	q OutBinStream
}

/// Descript:药学监护
/// w ##class(web.DHCSTPHCMAPPPatManage).saveMedMonInfo("","1^41^19^15^578^患者目前诊断慢性肾功能不全^5.23降钙素原 PCT 10.860 ng/ml血象正常!!30||33||!!20^80||")
ClassMethod saveMedMonInfo(phaCareID As %String, phaCareDataList As %String) As %GlobalCharacterStream
{
	n (phaCareID,phaCareDataList)
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	s phaCareMasDataList=$p(phaCareDataList,"!!",1)   //药学监护主信息
	s phaCareMonScopeList=$p(phaCareDataList,"!!",2)  //监护范围
	s phaCareMonItemList=$p(phaCareDataList,"!!",3)   //监护项目
	s phaCareDrgItmList=$p(phaCareDataList,"!!",4)    //医嘱信息
	s ret=0
	i phaCareID="" d
	.S ret=..Insert(phaCareMasDataList,phaCareMonScopeList,phaCareMonItemList,phaCareDrgItmList)
	e  d
	.S ret=..Update(phaCareID,phaCareMasDataList,phaCareMonScopeList,phaCareMonItemList,phaCareDrgItmList)
	s ret=##class(web.DHCSTPHCMCOMMON).getJsonData("ErrCode",ret)
	;w "["_ret_"]"
	;q ""
	d OutBinStream.Write("["_ret_"]")
	q OutBinStream
}

/// Descript:药学监护
ClassMethod Insert(phaCareMasDataList, phaCareMonScopeList, phaCareMonItemList, phaCareDrgItmList) As %String
{
	N (phaCareMasDataList,phaCareMonScopeList,phaCareMonItemList,phaCareDrgItmList)
	s Err=0

	TS
	//药学监护
	s phaCareID=..InsphaCare(phaCareMasDataList)
	i phaCareID<0 tro
	q:phaCareID<0 phaCareID

	//监护范围
	i phaCareMonScopeList'="" d
	.s Err=..InsphaCareMonScope(phaCareID, phaCareMonScopeList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//监护项目
	i phaCareMonItemList'="" d
	.s Err=..InsphaCareMonItem(phaCareID, phaCareMonItemList)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	//医嘱信息
	i phaCareDrgItmList'="" d
	.s Err=..InsphaCareDrgItm(phaCareID, phaCareDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-12"

	TC
	Q 0
}

/// Descript:药学监护
ClassMethod Update(phaCareID, phaCareMasDataList, phaCareMonScopeList, phaCareMonItemList, phaCareDrgItmList) As %String
{
	N (phaCareID,phaCareMasDataList,phaCareMonScopeList,phaCareMonItemList,phaCareDrgItmList)
	s Err=0

	TS
	//药学监护
	s Err=..UpdphaCare(phaCareID,phaCareMasDataList)
	i Err<0 tro
	q:Err<0 "-10"

	//删除相关子表
	s Err=..DelphaCareRelaTable(phaCareID)
	i Err'=0 tro
	q:Err'=0 Err

	//监护范围
	i phaCareMonScopeList'="" d
	.s Err=..InsphaCareMonScope(phaCareID, phaCareMonScopeList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//监护项目
	i phaCareMonItemList'="" d
	.s Err=..InsphaCareMonItem(phaCareID, phaCareMonItemList)
	i Err'=0 tro
	q:Err'=0 "-12"
	B  ///BBB
	//医嘱信息
	i phaCareDrgItmList'="" d
	.s Err=..InsphaCareDrgItm(phaCareID, phaCareDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-12"

	TC
	Q 0
}

/// Descript:插入查房信息
ClassMethod InsphaCare(phaCareMasDataList As %String) As %String
{
	N (phaCareMasDataList)
	S PHPCMLDR=$p(phaCareMasDataList,"^",1)     //监护级别
	S PHPCAdmDr=$p(phaCareMasDataList,"^",2)    //病人AdmDr
	S PHPCWardDr=$p(phaCareMasDataList,"^",3)   //病区ID
	S PHPCDeptDr=$p(phaCareMasDataList,"^",4)   //科室ID
	S PHPCUserDr=$p(phaCareMasDataList,"^",5)   //记录人
	S PHPCContent=$p(phaCareMasDataList,"^",6)  //监护内容
	S ImpMonItems=$p(phaCareMasDataList,"^",7)  //重要检验检测项目
	S PHPCDate=+$H                              //记录日期
	S PHPCTime=$p($H,",",2)                     //记录时间
	
	&SQL(Insert Into DHC_PHPharCare(PHPC_ML_DR,PHPC_Adm_Dr,PHPC_Ward_Dr,PHPC_Dept_Dr,PHPC_User_Dr,PHPC_Date,PHPC_Time,PHPC_Content,PHPC_ImpMonItems) 
		Values(:PHPCMLDR,:PHPCAdmDr,:PHPCWardDr,:PHPCDeptDr,:PHPCUserDr,:PHPCDate,:PHPCTime,:PHPCContent,:ImpMonItems))
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:更新查房信息
ClassMethod UpdphaCare(phaCareID As %String, phaCareMasDataList As %String) As %String
{
	N (phaCareID,phaCareMasDataList)
	S ImpMonContent=$p(phaCareMasDataList,"^",6)  //监护内容
	S ImpMonItems=$p(phaCareMasDataList,"^",7)  //重要检验检测项目
	
	&SQL(Update DHC_PHPharCare Set PHPC_Content=:ImpMonContent, PHPC_ImpMonItems=:ImpMonItems Where PHPC_RowID=:phaCareID) 

	Q SQLCODE
}

/// Descript: 删除用药教育相关信息表
ClassMethod DelphaCareRelaTable(phaCareID As %String) As %String
{
	n (phaCareID)
	
	//监护范围
	i $d(^DHCPHPC(phaCareID,"MS",1)) d
	.&SQL(delete from DHC_PHPCMonScope where PHMS_PHPC_Parref=:phaCareID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	//监护项目
	i $d(^DHCPHPC(phaCareID,"MI",1)) d
	.&SQL(delete from DHC_PHPCMonItem where PHMI_PHPC_Parref=:phaCareID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	//关注药品
	i $d(^DHCPHPC(phaCareID,"DI",1)) d
	.&SQL(delete from DHC_PHPCDrgItm where PHDI_PHPC_Parref=:phaCareID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	q 0
}

/// Descript:监护范围
ClassMethod InsphaCareMonScope(phaCareID As %String, phaCareMonScopeList As %String) As %String
{
	N (phaCareID,phaCareMonScopeList)
	S Len=$L(phaCareMonScopeList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S phaCareMonScope=$p(phaCareMonScopeList,"||",i) q:phaCareMonScope=""
	.S ItemCode=$p(phaCareMonScope,"^",1)    //代码
	.
	.S childSub=$o(^DHCPHPC(phaCareID,"MS",""),-1)+1
	.&SQL(Insert into DHC_PHPCMonScope(PHMS_PHPC_Parref,PHMS_ChildSub,PHMS_MonScope_Dr)
		Values(:phaCareID,:childSub,:ItemCode))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:监护项目
ClassMethod InsphaCareMonItem(phaCareID As %String, phaCareMonItemList As %String) As %String
{
	N (phaCareID,phaCareMonItemList)
	S Len=$L(phaCareMonItemList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S phaCareMonItem=$p(phaCareMonItemList,"||",i) q:phaCareMonItem=""
	.S ItemCode=$p(phaCareMonItem,"^",1)    //代码
	.S ItemDesc=$p(phaCareMonItem,"^",2)    //值
	.S childSub=$o(^DHCPHPC(phaCareID,"MI",""),-1)+1
	.&SQL(Insert into DHC_PHPCMonItem(PHMI_PHPC_Parref,PHMI_ChildSub,PHMI_MonItm_Dr,PHMI_Desc)
		Values(:phaCareID,:childSub,:ItemCode,:ItemDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:保存关注药品
ClassMethod InsphaCareDrgItm(phaCareID As %String, phaCareDrgItmList As %String) As %String
{
	N (phaCareID,phaCareDrgItmList)
	S Len=$L(phaCareDrgItmList,",")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S phaCareDrgItm=$p(phaCareDrgItmList,",",i)
	.S oeoriDr=$p(phaCareDrgItm,"^",1)        //医嘱ID
	.S childSub=$o(^DHCPHPC(phaCareID,"DI",""),-1)+1
	.&SQL(Insert into DHC_PHPCDrgItm(PHDI_PHPC_Parref,PHDI_ChildSub,PHDI_OEORI_DR)
		Values(:phaCareID,:childSub,:oeoriDr))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

ClassMethod GetPatMonList(monLevId As %String, AdmDr As %String, startDate As %String, stopDate As %String) As %GlobalCharacterStream
{
		n (monLevId, AdmDr,startDate,stopDate)
		s OutBinStream=##Class(%GlobalCharacterStream).%New()
		q:AdmDr=""
		s sDate=$case(+startDate,0:$h-100,:$zdh(startDate,3))
    	s sTop=$case(+stopDate,0:+$h,:$zdh(stopDate,3))
		d OutBinStream.Write("[")
		s monID="", count=0
		f  s monID=$o(^DHCPHPC(0,"ADM",AdmDr,monID)) q:monID=""  d
		.s monLeID=$p(^DHCPHPC(monID),"^",1)
		.//q:(monLevId'="")&(monLevId'=monLeID)
		.s monUser=""
		.s monUserID=$p(^DHCPHPC(monID),"^",5)  //监护人
		.s:monUserID'="" monUser=$p(^SSU("SSUSR",monUserID),"^",2)
		.s monDate=$p(^DHCPHPC(monID),"^",6)  //监护日期
		.q:sDate>monDate
		.q:sTop<monDate
		.s:monDate'="" monDate=$zd(monDate,3)
		.s monTime=$p(^DHCPHPC(monID),"^",7)  //监护时间
		.s:monTime'="" monTime=$zt(monTime,1)
		.s ListData=monID_"^"_monLeID_"^"_monUser_"^"_monDate_"^"_monTime
		.s count = count+1
		.I count=1 d
		..d OutBinStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonData("monID^monLeID^monUser^monDate^monTime",ListData))
		.e  d
		..d OutBinStream.Write(","_##class(web.DHCSTPHCMCOMMON).getJsonData("monID^monLeID^monUser^monDate^monTime",ListData))
		d OutBinStream.Write("]")
		q OutBinStream
}

/// Descript:病人监护范围
/// d ##class(web.DHCSTPHCMPHARMACYCARE).getPatMonScopeList("1")
ClassMethod GetPatMonScopeList(monId As %String) As %GlobalCharacterStream
{
    n (monId)
    s OutBinStream=##Class(%GlobalCharacterStream).%New()
    q:monId=""
	d OutBinStream.Write("[")
	s CH="",count=0
	f  s CH=$o(^DHCPHPC(monId,"MS",CH)) q:CH=""  d
	.s monScopeID=$p(^DHCPHPC(monId,"MS",CH),"^",1)
	.q:'$D(^DHCPHMS(monScopeID))
	.s monScopeDesc=$p(^DHCPHMS(monScopeID),"^",2)
	.
	.s ListData=monScopeID_"^"_monScopeDesc
	.s count = count+1
	.I count=1 d
	..d OutBinStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonData("monScopeID^monScopeDesc",ListData))
	.e  d
	..d OutBinStream.Write(","_##class(web.DHCSTPHCMCOMMON).getJsonData("monScopeID^monScopeDesc",ListData))
	d OutBinStream.Write("]")
	q OutBinStream
}

/// Descript:病人监护项目
/// d ##class(web.DHCSTPHCMPHARMACYCARE).getPatMonItemList("1")
ClassMethod GetPatMonItemList(monId As %String) As %GlobalCharacterStream
{
    n (monId)
    s OutBinStream=##Class(%GlobalCharacterStream).%New()
    q:monId="" 
	d OutBinStream.Write("[")
	s CH="",count=0
	f  s CH=$o(^DHCPHPC(monId,"MI",CH)) q:CH=""  d
	.s monItemID=$p(^DHCPHPC(monId,"MI",CH),"^",1)
	.q:$d(^DHCPHMI(monItemID))=10
	.q:'$d(^DHCPHMI(monItemID))
	.s monItemDesc=$p(^DHCPHMI(monItemID),"^",2)
	.s monItemVal=$p(^DHCPHPC(monId,"MI",CH),"^",2)
	.s monItemDesc=$replace(monItemDesc,"[]",monItemVal)_"："
	.
	.s ListData=monItemID_"^"_monItemVal_"^"_monItemDesc
	.s count = count+1
	.I count=1 d
	..d OutBinStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonData("monItemID^monItemVal^monItemDesc",ListData))
	.e  d
	..d OutBinStream.Write(","_##class(web.DHCSTPHCMCOMMON).getJsonData("monItemID^monItemVal^monItemDesc",ListData))
	d OutBinStream.Write("]")
	q OutBinStream
}

/// Descript:病人监护项目
/// d ##class(web.DHCSTPHCMPHARMACYCARE).getMonImpLabsAndGuidCon("1")
ClassMethod GetMonImpLabsAndGuidCon(monID As %String) As %GlobalCharacterStream
{
    n (monID)
    s OutBinStream=##Class(%GlobalCharacterStream).%New()
    q:monID="" 
	d OutBinStream.Write("[")
	s ImpMonContent=$p(^DHCPHPC(monID),"^",8)  //相关内容
	s ImpMonItems=$p(^DHCPHPC(monID),"^",9)  //重要检验
	s ListData=ImpMonContent_"^"_ImpMonItems
	d OutBinStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonData("ImpMonContent^ImpMonItems",ListData))
	d OutBinStream.Write("]")
	q OutBinStream
}

/// Description:	获取患者全部费用
/// Creator:		(QuNianpeng ) 江苏中医
/// CreateDate:		2017-12-12
/// Input:			就诊号
/// return:			全部费用
/// Table:			DHC_PatientBill 账单表  DHC_PatBillOrder 医嘱账单表 DHC_PatBillDetails
/// other:			 W ##Class(web.DHCSTPHCMAPPPatManage).GetTotalAmount("5630914")
ClassMethod GetTotalAmount(adm As %String) As %String
{
	n (adm)
	
	q:adm="" ""
	q:'$d(^DHCPB(0,"ADM",adm)) ""
	s pbRowId=$o(^DHCPB(0,"ADM",adm,""))
	s totalAmount=$p(^DHCPB(pbRowId),"^",8)		//总费用
	s drugTotal=0								//药品费用
	
	s pbSub=""
	f  s pbSub=$o(^DHCPB(pbRowId,"O",pbSub)) q:pbSub=""  d
	.q:$d(^DHCPB(pbRowId,"O",pbSub))="10"
	.s arci=$p(^DHCPB(pbRowId,"O",pbSub),"^",3)	//医嘱项id
	.q:arci=""
	.s sub=$p(arci,"||",1),ver=$p(arci,"||",2)
	.s itemCatDr="",itemCatCode=""
	
	.i +sub'=0 s itemCatDr=$P(^ARCIM(+sub,ver,1),"^",10)  //ARC_ItemCat
	.s orderType=""
	.i itemCatDr'="" s orderType=$P(^ARC("IC",itemCatDr),"^",7) 
	.q:orderType'="R"							//只保留药品医嘱
	.//s tmpDrugtoAmount=$p(^DHCPB(pbRowId,"O",pbSub),"^",8)
	.s pbdeSub=""
	.f  s pbdeSub=$o(^DHCPB(pbRowId,"O",pbSub,"D",pbdeSub)) q:pbdeSub=""  d
	..s tmpDrugtoAmount=$p(^DHCPB(pbRowId,"O",pbSub,"D",pbdeSub),"^",7)
	..s drugTotal=drugTotal+tmpDrugtoAmount
	
	q totalAmount_"^"_drugTotal
}

}
