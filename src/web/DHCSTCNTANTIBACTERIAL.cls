Import sqluser

/// Creator: bianshuai
/// CreateDate: 2015-03-11
/// Descript: 抗菌药点评相关
Class web.DHCSTCNTANTIBACTERIAL Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:获取病人基本就诊信息
ClassMethod GetPatEssInfo(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s patNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    //姓别
	s patSex=""
	i sexId'="" s patSex=$p(^CT("SEX",sexId),"^",2)
	s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)   //出生日期
	s nationdr=$p(^PAPER(PatientID,"PER",1),"^",2) //民族
	s nation=""
	i nationdr'="" s nation=$p(^CT("NAT",nationdr),"^",2)
	i birthday'="" s birthday=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(birthday) ;$zd(birthday,3)
	s patAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  //年龄
	s natplace=""    //籍贯
	s patWeight=##class(web.DHCSTCNTSCOMMON).GetPatWeight(EpisodeID) //体重
	s patHeight=##class(web.DHCSTCNTSCOMMON).GetPatHeight(EpisodeID) //身高
	s patTel=""      //电话
	s idcard=""      //身份证
	s workunit=""    //工作单位
	s medicalNo=patNo //
	
	s AdmLoc=""
	s AdmLocID=$p(^PAADM(EpisodeID),"^",4) //科室
	s:AdmLocID'="" AdmLoc=$p(^CTLOC(AdmLocID),"^",2)
	s:AdmLoc["-" AdmLoc=$p(AdmLoc,"-",2)
	s AdmDoc=""
	s AdmDocID=$p(^PAADM(EpisodeID),"^",9) //医生
	s:AdmDocID'="" AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2)
	s AdmWard=""
	s AdmWardID=$p(^PAADM(EpisodeID),"^",70) //病区
	s:AdmWardID'="" AdmWard=$p(^PAWARD(AdmWardID),"^",2)
	s AdmBed=""
	s AdmBedID=$p(^PAADM(EpisodeID),"^",73) //床号
	i AdmBedID'="" s AdmBed=$p(^PAWARD($p(AdmBedID,"||",1),"BED",$p(AdmBedID,"||",2)),"^",1)
	
	s AdmDate=$p(^PAADM(EpisodeID),"^",6)  //就诊日期
	s AdmTime=$p(^PAADM(EpisodeID),"^",7)  //就诊时间
	i AdmDate'="" S AdmDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(AdmDate) ;$zd(AdmDate,3)
	i AdmTime'="" S AdmTime=$zt(AdmTime,1)
	
	s DischgDate=$p(^PAADM(EpisodeID),"^",17)  //出院日期
	s DischgTime=$p(^PAADM(EpisodeID),"^",18)  //出院时间
	i DischgDate'="" S DischgDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(DischgDate) ;$zd(DischgDate,3)
	i DischgTime'="" S DischgTime=$zt(DischgTime,1)
	
	s patdiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") //诊断
	/// 入院诊断
	S InHosMRDiagnosDesc=##Class(web.DHCSTPHCMCOMMON).getInHosMRDiagnosDesc(EpisodeID)
	s billtype=""
	s patBillTypedr=+$p(^PAPER(PatientID,"PER",1),"^",10)
	i patBillTypedr'="" s billtype=$p(^CT("SS",patBillTypedr),"^",2)
	s allergy=..GetPatAllergy(PatientID)  //过敏史
	s nurlev="一级"
	
	s ListData=PatientID_"^"_EpisodeID_"^"_patNo_"^"_patName_"^"_sexId_"^"_patSex_"^"_patAge
	s ListData=ListData_"^"_birthday_"^"_nationdr_"^"_nation_"^"_medicalNo_"^"_natplace_"^"_patWeight
	s ListData=ListData_"^"_patHeight_"^"_patTel_"^"_workunit_"^"_idcard_"^"_patdiag_"^"_allergy
	s ListData=ListData_"^"_AdmDoc_"^"_AdmLoc_"^"_AdmWard_"^"_AdmBed_"^"_AdmDate_"^"_DischgDate_"^"_nurlev
	s ListData=ListData_"^"_billtype_"^"_InHosMRDiagnosDesc_"^"_patdiag
	
	s ListTitle="PatientID^EpisodeID^patno^patname^sexId^patsex^patage^patdob^nationdr^nation^medicalNo^native^weight^height^modphone^workunit^idcard^patdiag^allergy"
	s ListTitle=ListTitle_"^doctor^admloc^AdmWard^AdmBed^admdate^dischgdate^nurlev^billtype^inhosICD^discICD"
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:取病人的过敏信息
/// w ##class(web.DHCSTCNTANTIBACTERIAL).GetPatAllergy("8")
ClassMethod GetPatAllergy(PatientID As %String) As %String
{
	n (PatientID)
	s AlgsSub="",Allergy="",i=0,DelimStr=" "
	f  s AlgsSub=$o(^PAPER(PatientID,"ALG",AlgsSub)) q:AlgsSub=""  d
	.s AlgDesc="",PHCGEName="",PHCDName="",INGRDesc=""
	.i $p(^PAPER(PatientID,"ALG",AlgsSub),"^",9)'=""  d    //自定义过敏源
	..s AlgTypeDr=$p(^PAPER(PatientID,"ALG",AlgsSub),"^",9)
	..s AlgDesc=$p(^PAC("ALG",AlgTypeDr),"^",2)
    .i $p(^PAPER(PatientID,"ALG",AlgsSub),"^",4)'=""  d    //通用项过敏源 
    ..s AlgPHCGEDr=$p(^PAPER(PatientID,"ALG",AlgsSub),"^",4)
	..s PHCGEName=$p(^PHCGE("GE",AlgPHCGEDr),"^",2)
	.i $p(^PAPER(PatientID,"ALG",AlgsSub),"^",27)'=""  d    //药学过敏源 
	..s AlgPHCDMDr=$p(^PAPER(PatientID,"ALG",AlgsSub),"^",27)
	..s PHCDName=$p(^PHCD(AlgPHCDMDr,1),"^",2)
	.i $p(^PAPER(PatientID,"ALG",AlgsSub),"^",32)'=""  d   
	..s AlgIngredDr=$p(^PAPER(PatientID,"ALG",AlgsSub),"^",32)
	..s INGRDesc=$p(^PHC("INGR",AlgIngredDr),"^",2)
	.i AlgDesc'=""  d
	..s i=i+1
	..s AlgDesc=i_"、"_AlgDesc
	..i Allergy="" s Allergy=AlgDesc
	..e  s Allergy=Allergy_DelimStr_AlgDesc
	.i PHCGEName'=""  d
	..s i=i+1
	..s PHCGEName=i_"、"_PHCGEName
	..i Allergy="" s Allergy=PHCGEName
	..e  s Allergy=Allergy_DelimStr_PHCGEName
	.i PHCDName'=""  d
	..s i=i+1
	..s PHCDName=i_"、"_PHCDName
	..i Allergy="" s Allergy=PHCDName
	..e  s Allergy=Allergy_DelimStr_PHCDName
	.i INGRDesc'=""
	..s i=i+1
	..s INGRDesc=i_"、"_INGRDesc
	..i Allergy="" s Allergy=INGRDesc
	..e  s Allergy=Allergy_DelimStr_INGRDesc
	q Allergy
}

/// Descript:取病人的诊断信息
ClassMethod GetPatRelaDiag(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
}

/// Descript:获取本次医嘱列表
ClassMethod GetPatOrdItmDetail(rows As %String, page As %String, EpisodeID As %String, Type As %String) As %String
{
	n (rows, page, EpisodeID, Type)
	s pid=..NewPid()
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1 //开始行
	d ..killTmpGlobal(pid)
	
	s Num=0
	s ord=""
	f  s ord=$o(^OEORD(0,"Adm",EpisodeID,ord)) q:ord=""  d
	.s chl=0
	.f  s chl=$o(^OEORD(ord,"I",chl)) q:(chl=0)||(chl="")  d
	..s orditm=ord_"||"_chl
	..s StatDr=$p(^OEORD(ord,"I",chl,1),"^",13)
    ..s OeFlag=$p(^OEC("OSTAT",StatDr),"^",1) 
	..s FillerNo=$p($g(^OEORD(ord,"I",chl,9)),"^",12) //滚医嘱来源信息 OEORI_FillerNo
	..Q:(FillerNo'="")&(OeFlag'="D")  		  //长嘱非首日和截止日期的记录过滤
	..s presc=$p(^OEORD(ord,"I",chl,1),"^",14)   //处方号
	..s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..
	..s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
	..s puomdr=+$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	..
	..s ItemCatDR=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)
	..s ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
	..q:(Type'="AE")&(ordertype'="R")
	..
	..s qty=$p(^OEORD(ord,"I",chl,1),"^",12) //医嘱数量
	..s inci=+$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),""))
	..s buomdr=+$p($g(^INCI(inci,1)),"^",10)
	..s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	..s uomdr=buomdr
	..i (qty#fac)=0 d
	...s qty=qty/fac   //数量
	...s uomdr=puomdr
	..s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	..s dosage=$p($g(^OEORD(ord,"I",chl,2)),"^",1) //剂量
    ..s doseuom=""
	..s dosuomID=$p($g(^OEORD(ord,"I",chl,2)),"^",3)
	..i dosuomID'="" s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) //剂量单位
	..s freq=""
	..s freqdr=$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
    ..i freqdr'="" s freq=$p($g(^PHCFR(freqdr)),"^",3)  //频率
    ..s instru=""
    ..s instrudr=$p($g(^OEORD(ord,"I",chl,2)),"^",7)
    ..s:instrudr'="" instru=$p(^PHCIN(instrudr),"^",2)  //用法
    ..s duration=""
    ..s durationdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	..s:durationdr'=0 duration=$p(^PHCDU(durationdr),"^",1)  //用药疗程
	..s priorty=""
	..s pri=+$p(^OEORD(ord,"I",chl,1),"^",8)
	..i pri'=0 s priorty=$E($p(^OECPR(pri),"^",2),1,2)   //医嘱优先级
	..q:(Type="AN")&(priorty'["长期")
	..q:(Type="AL")&(priorty'["临时")
	..Q:(priorty["临时")&(OeFlag="D")
	..s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	..q:(Type="AC")&(StkGrpInfo'["中成药")
	..q:(Type="AZ")&(StkGrpInfo'["中草药")
	..q:(Type="AH")&(StkGrpInfo'["西药")
	..s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm)  //医生
	..s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  //剂型
	..i $F(form,$c(13)) s form=$p(form,$c(13))
	..s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) //规格
	..s:spec'="" spec="["_spec_"]"
	..s basflag=""
	..s infor=$o(^DHCITMINFO(0,"INCI",inci,""))
	..i infor'="" s basflag=$p(^DHCITMINFO(infor),"^",4) //基本药物
	..i basflag'="Y" s basflag=""
	..
	..s rArcimPhcdfDr=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)   //指向PHC_DrgForm
 	..s rPhcDrgForm1=+$p(rArcimPhcdfDr,"||",1)
 	..s rPhcDrgForm2=+$p(rArcimPhcdfDr,"||",2)
 	..s AntibioticFlag=""
 	..i $d(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2,"DHC")) d
 	...s AntibioticFlag=$p(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2,"DHC"),"^",8) //抗菌药标志
    ..i AntibioticFlag="N" s AntibioticFlag=""
    ..q:(Type="AA")&(AntibioticFlag'="Y")
    ..
	..s spamt=1
	..s orddate=$p(^OEORD(ord,"I",chl,3),"^",7)  //医嘱日期
    ..s ordtime=$p(^OEORD(ord,"I",chl,1),"^",10) //医嘱时间
    ..i orddate'="" s orddate=$zd(orddate,3)
    ..i ordtime'="" s ordtime=$zt(ordtime,2)
    ..s ordtime=orddate_" "_ordtime  //开单日期
    ..s orddept=$p(^OEORD(ord,"I",chl,1),"^",3)
    ..s:orddept'="" orddept=$p(^CTLOC(orddept),"^",2)
    ..s:orddept["-" orddept=$p(orddept,"-",2)
    ..s enddate=$p(^OEORD(ord,"I",chl,3),"^",34) //停止日期
	..s:enddate'="" enddate=$zd(enddate,3)
	..s endtime=$p(^OEORD(ord,"I",chl,2),"^",15)  //停止时间
	..i endtime'="" s endtime=$zt(endtime,2)
	..s enddate=enddate_" "_endtime  //开单日期
	..s pyuser=""
	..s fyuser=""
	..s purpose=##Class(web.DHCOutPhCommon).GetOrdRemark(orditm)
	..s prescno=$p(^OEORD(ord,"I",chl,1),"^",14) //处方号
	..s execdate="",exectime=""
	..i $d(^OEORD(ord,"I",chl,"X",1)) d
	...s execdate=$p(^OEORD(ord,"I",chl,"X",1),"^",19)  //执行日期
	...i execdate'="" s execdate=$zd(execdate,3)
	...s exectime=$p(^OEORD(ord,"I",chl,"X",1),"^",20)  //执行时间
	...i exectime'="" s exectime=$zt(exectime,2)
	...s execdate=execdate_" "_exectime
	...s CareProvDesc=""
	...s CareProvID=$p(^OEORD(ord,"I",chl,"X",1),"^",15)  //执行人
	...i CareProvID'="" s CareProvDesc=$p(^CTPCP(CareProvID,1),"^",2)
	..i priorty["长期" s execdate="" s CareProvDesc=""
	..i FillerNo'="" d
	...s orditm=$p(FillerNo,"!!",1)
	...s orddate=$p(^OEORD(ord,"I",$p(orditm,"||",2),3),"^",7)  //医嘱日期
    ...s ordtime=$p(^OEORD(ord,"I",$p(orditm,"||",2),1),"^",10) //医嘱时间
    ...i orddate'="" s orddate=$zd(orddate,3)
    ...i ordtime'="" s ordtime=$zt(ordtime,2)
    ...s ordtime=orddate //_" "_ordtime  //开单日期
    ..s moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm)
    ..i $d(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatOrdItmDetail",pid,moeori_"^"_orditm)) d
    ...s $p(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatOrdItmDetail",pid,moeori_"^"_orditm),"^",20)=enddate
    ..q:$d(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatOrdItmDetail",pid,moeori_"^"_orditm))
    ..
    ..i moeori'=orditm s arcitmdesc="_____"_arcitmdesc
	..S ListData=priorty_"^"_AntibioticFlag_"^"_basflag_"^"_arcitmdesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_form_"^"_spec_"^"_freq_"^"_instru_"^"_duration_"^"_doctor_"^"_spamt_"^"_ordtime_"^"_pyuser_"^"_fyuser_"^"_purpose_"^"_orddept
	..S ListData=ListData_"^"_enddate_"^"_prescno_"^"_execdate_"^"_CareProvDesc
	..
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatOrdItmDetail",pid,moeori_"^"_orditm)=ListData
	.
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatOrdItmDetail",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatOrdItmDetail",pid,index)
	.S Title="priorty^antflag^basflag^arcitmdesc^qty^uomdesc^dosage^form^spec^freq^instru^duration^doctor^spamt^ordtime^pyuser^fyuser^purpose^orddept^enddate^prescno^execdate^careprovdesc"
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

/// Descript:获取处方调配人员
ClassMethod GetPrescNoPyUser() As %String
{
}

/// Descript:检查列表
ClassMethod GetPatExaList(rows As %String, page As %String, EpisodeID As %String) As %String
{
	n (rows, page, EpisodeID, Type)
	s pid=..NewPid()
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1 //开始行
	d ..killTmpGlobal(pid)
	
	s Num=0
	s PatientID = $p(^PAADM(EpisodeID),"^",1)
	s Type="" 
	f  s Type=$o(^PAPERdr(PatientID,"ADM",Type)) q:Type=""  d
	.s AdmID=0 
	.f  s AdmID=$o(^PAPERdr(PatientID,"ADM",Type,AdmID)) q:(AdmID="")  d
	..q:AdmID'=EpisodeID  //筛选本次的就诊记录
	..s ord=""
	..s ord=$o(^OEORD(0,"Adm",AdmID,ord))
	..//f  s ord=$o(^OEORD(0,"Adm",AdmID,ord)) q:ord=""  d
	..s chl=0
	..f  s chl=$o(^OEORD(ord,"I",chl)) q:(chl=0)||(chl="")  d
	...s replocdr=$p($g(^OEORD(ord,"I",chl,3)),"^",6)
	...q:replocdr=""
	...s locdesc=""
	...i replocdr'="" s locdesc=$p(^CTLOC(replocdr),"^",2)  //检查科室
	...s ItemStatusCode=""
	...s ItemStatDR=$p(^OEORD(ord,"I",chl,1),"^",13) //医嘱状态
	...i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	...q:(ItemStatusCode'="V")&(ItemStatusCode'="E")
	...
	...s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	...s itmmastid=$p(arcimid,"||",1)
	...s itmmastver=$p(arcimid,"||",2)
	...
	...s ServerMaterial=$p($g(^ARCIM(itmmastid,itmmastver,7)),"^",6)
	...q:ServerMaterial'="S" //不是检查项目的则退出  
	...
	...s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) //医嘱项代码
	...s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
	...
    ...s StudyNo="",ItemStatus="",IshasImg=""
    ...s RegDR=$o(^DHCPACRegInfoi("OEORI",ord_"||"_chl,""))
	...i $g(RegDR)'="" d
	....s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	....s ImageUrl=$p(^DHCPACRegInfo(RegDR),"^",22)    //存放外部传输过来的URL
	...s reports="",IsIll="",Memo="",part="",resulttime="",reportdocdesc=""
	...i StudyNo'="" d
	....s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId)) q:(RptRowId="")  d
	.....s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	.....s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
	.....s Memo=$g(^DHCRBStudy("Report",RptRowId,"MemoEx"))
	.....s reports=^DHCRBStudy("Report",RptRowId,"ExamDescEx")
	.....s reportdate=$p(^DHCRBStudy("Report",RptRowId),"^",9)
	.....s reporttime=$p(^DHCRBStudy("Report",RptRowId),"^",10)
	.....s resulttime=$zd(reportdate,3)_" "_$zt(reporttime,3)
	.....s reportdoc=$p(^DHCRBStudy("Report",RptRowId),"^",8)
	.....s reportdocdesc=""
	.....i reportdoc'="" s reportdocdesc=$p(^SSU("SSUSR",reportdoc),"^",2)
	.....i $g(StatusDR)'="" d
	......s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	......i StatusCode="S" s ItemStatus="Y"
	.....s Imgrowid=0
	.....s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,Imgrowid))
	.....i Imgrowid'="" s IshasImg="Y"
    .....s instrument="",part=""
	....
	...S ListData=EpisodeID_"^"_StudyNo_"^"_arcitmcode_"^"_arcitmdesc_"^"_reports_"^"_part_"^"_resulttime_"^"_reportdocdesc_"^"_IsIll_"^"_Memo
	...
	...S Num=Num+1
	...S index=Num
	...S ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatExaList",pid,index)=ListData
	.
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatExaList",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatExaList",pid,index)
	.S Title="EpisodeID^StudyNo^arcitmcode^arcitmdesc^reports^part^resulttime^reportdocdesc^IsIll^Memo"
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

/// Descript:检验列表
/// w ##class(web.DHCSTCNTANTIBACTERIAL).GetPatLabList(100,1,7,"")
ClassMethod GetPatLabList(rows As %String, page As %String, EpisodeID As %String, param As %String) As %String
{
	n (rows, page, EpisodeID, param)
	s pid=..NewPid()
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1 //开始行
	d ..killTmpGlobal(pid)
	s ThemeCode=$p(param,"^",1) //应用主题代码
	s Num=0
	s ord=""
	s ord=$o(^OEORD(0,"Adm",EpisodeID,ord))
	s chl=0
	f  s chl=$o(^OEORD(ord,"I",chl)) q:(chl=0)||(chl="")  d
	.s replocdr=$p($g(^OEORD(ord,"I",chl,3)),"^",6)
	.q:replocdr=""
	.s locdesc="",HospitalCode=""
	.i replocdr'="" s locdesc=$p(^CTLOC(replocdr),"^",2)  //检查科室
	.s HospID=$p(^CTLOC(replocdr),"^",22)
	.s:HospID'="" HospitalCode=$p(^CT("HOSP",HospID),"^",1)
	.s ItemStatusCode=""
	.s ItemStatDR=$p(^OEORD(ord,"I",chl,1),"^",13) //医嘱状态
	.i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	.q:(ItemStatusCode'="V")&(ItemStatusCode'="E")
	.s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	.s funLibTheItmList=##class(web.DHCSTPHCMCOMMON).getFunLibTheItmList(ThemeCode)
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.q:..isLabTS(arcimid)=0  //是否是检验医嘱
	.s reqdate=$p(^OEORD(ord,"I",chl,3),"^",7)   //申请日期
	.s:reqdate'="" reqdate=$zd(reqdate,3)
	.s reqtime=$p(^OEORD(ord,"I",chl,1),"^",17)  //申请时间
	.s:reqtime'="" reqtime=$zt(reqtime,2)
	.s coltime=""  //采集时间 目前走的执行时间
    .s sub="" f  s oeexsub=$o(^OEORD(ord,"I",chl,"X",sub)) q:sub=""  d
    ..s oexdate=$p(^OEORD(ord,"I",chl,"X",sub),"^",19)
    ..s oexdate=$zd(oexdate,3)
    ..s oextime=$p(^OEORD(ord,"I",chl,"X",sub),"^",20)
    ..s oextime=$zt(oextime,1)
    ..s coltime=oexdat_" "_oextime   
    .s useradd=$p(^OEORD(ord,"I",chl,7),"^",1)     //申请医生
    .s useradd=$p(^SSU("SSUSR",useradd),"^",2)
	.//标本OE_OrdSpecimen
	.s (SpecCode,SpecName)=""
	.s SpecDr=$o(^OEORD(ord,"I",chl,"SPEC",""),-1)
	.i SpecDr'="" s SpecCode=$p(^OEORD(ord,"I",chl,"SPEC",SpecDr),"^",1)
	.i SpecCode'="" d
	..s SpecName=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(SpecCode,HospitalCode),$c(2),2)		   
	.s LabEpisode=$p(^OEORD(ord,"I",chl,3),"^",20)     //检验号
	.s LabTestSetRow=$p(^OEORD(ord,"I",chl,3),"^",35)  //报告ID
	.// 新版
	.//s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",$c(32)_LabEpisode,""))
	.s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(LabEpisode),""))
	.//q:LabTestSetRow=""
	.s LabNo=$p(LabTestSetRow,"||",1)
	.i LabNo="" s LabNo=0
	.s TS=+$p(LabTestSetRow,"||",2)
	.s TSCnt=+$p(LabTestSetRow,"||",3)
	.s recdate="",rectime=""
	.i $l(VisitNumberDR) d
	..//接收日期时间
	..s recdate=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),66)
	..s dateFormat=##class(websys.Conversions).DateFormat()  // 4:"DMY" DD/MM/YYYY 3:"YMD" YYYY-MM-DD  1:"MDY" MM/DD/YYYY
	..i (dateFormat=1)&(recdate'="") s recdate=$e(recdate,5,6)_"/"_$e(recdate,7,8)_"/"_$e(recdate,1,4) //qunianpeng 2017/7/14 根据日期配置显示
	..i (dateFormat=3)&(recdate'="") s recdate=$e(recdate,1,4)_"-"_$e(recdate,5,6)_"-"_$e(recdate,7,8)
	..i (dateFormat=4)&(recdate'="") s recdate=$e(recdate,7,8)_"/"_$e(recdate,5,6)_"/"_$e(recdate,1,4)
	..//s:recdate'="" recdate=$e(recdate,1,4)_"-"_$e(recdate,5,6)_"-"_$e(recdate,7,8)
	..s rectime=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),67)
	..s:rectime'="" rectime=$zt(rectime)
	.;i $d(^TEPI(LabNo,1,TS,TSCnt)) d
	..//接收日期时间
	..;s recdate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",21)
	..;s:recdate'="" recdate=$zd(recdate,3)
	..;s rectime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",22)
	..;s:rectime'="" rectime=$zt(rectime*60,2)
	..//审核日期时间
	..s authdate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",4)
	..s:authdate'="" authdate=$zd(authdate,3)
	..s authtime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",5)
	..s:authtime'="" authtime=$zt(authtime*60,2)
	.
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) //医嘱项代码
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
	.
	.S ListData=EpisodeID_"^"_LabTestSetRow_"^"_LabEpisode_"^"_arcitmcode_"^"_arcitmdesc_"^"_SpecName_"^"_coltime_"^"_useradd_"^"_$g(reqdate)_" "_$g(reqtime)_"^"_$g(recdate)_"^"_$g(rectime)_"^"_$g(authdate)_" "_$g(authtime)_"^"_ord_"||"_chl
	.
	.S Num=Num+1
	.S index=reqdate_"^"_reqtime_"^"_Num
	.S ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatLabList",pid,index)=ListData
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatLabList",pid,index),-1) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatLabList",pid,index)
	.S Title="EpisodeID^LabTestSetRow^LabEpisode^arcitmcode^arcitmdesc^SpecName^coltime^useradd^reqtime^recdate^rectime^authtime^oeori"
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

/// Descript:检查医嘱项目是否是否检验医嘱
ClassMethod isLabTS(ItemMast As %String) As %String
{
	s ItemMast=$g(ItemMast)
	s RtnValue="0"
	s ItmCat=$p(^ARCIM(+ItemMast,$p(ItemMast,"||",2),1),"^",10)
	i $l(ItmCat),$d(^ARC("IC",ItmCat)){
		i $p(^ARC("IC",ItmCat),"^",7)="L" s RtnValue="1"
	}
	Quit RtnValue
}

/// Descript:检验项目值
ClassMethod LabItmsValue(rows As %String, page As %String, LabTestSetRow As %String) As %String
{
	n (rows, page, LabTestSetRow)
	s pid=..NewPid()
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1 //开始行
	d ..killTmpGlobal(pid)
	s Num=0
	s VisitNumberTestSetDR=LabTestSetRow
	q:VisitNumberTestSetDR="" ""
	//报告信息
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),2)
	s TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),3)
	q:'$l(VisitNumberDR) ""
	s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),5)
	q:'$l(WorkGroupMachineDR) ""
	s WorkGroupDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)
	s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,"")) 
	q:'$l(OrderNo) ""
	s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""),-1)
 	q:'$l(ReportDR) ""
 	q:$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),22)'=3 ""
 	s TestCodeDR="" 
 	f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR)) q:TestCodeDR=""  d
 	.Q:'$d(^dbo.BTTestSetLayoutI("IndexTestCode",TestCodeDR,TestSetDR,WorkGroupDR))
 	.s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
 	.s ItemCode=$lg(TestCodeData,2)    //检验项目代码
	.s ItemDesc=$lg(TestCodeData,3)    //检验项目描述
	.s TCSync=$lg(TestCodeData,7)
 	.s ResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR,"")) 
 	.q:'$l(ResultDR)
 	.s ResultData=$g(^dbo.RPVisitNumberReportResultD(ResultDR))
	.s ItemResult=$lg(ResultData,5)  //结果
	.s ItemUnit=$lg(ResultData,11)   //检验项目的单位
	.s AbnorFlag=$lg(ResultData,9)   //异常标记
	.s ItmRange=$lg(ResultData,12)   //参考范围
	.//s RangL=$p(RefRanges,"-",1)  //低值
	.//s RangH=$p(RefRanges,"-",2)  //高值
	.//s ItmRange=""
	.//If $Length(RangL) s ItmRange=RangL_"-"_RangH
	.//If $E(RangL,1)="<" s ItmRange=RangL
	.//If $E(RangL,1)=">" s ItmRange=RangL
	.//s $p(LabResult,$c(2),6)=ItmRange
	.s LabResult="" //$TRanslate(ResultData,$c(2),"\")
	.S ListData=ItemCode_"^"_ItemDesc_"^"_ItemUnit_"^"_ItemResult_"^"_ItmRange_"^"_AbnorFlag_"^"_LabResult
	.S Num=Num+1
	.S index=Num
	.S ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","LabItmsValue",pid,index)=ListData
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","LabItmsValue",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","LabItmsValue",pid,index)
	.S Title="itmcode^itmname^units^itmval^ItmRange^AbnorFlag^ItemRes"
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

/// Descript:手术列表
ClassMethod GetPatOpList(rows As %String, page As %String, EpisodeID As %String) As %String
{
	n (rows, page, EpisodeID)
	s pid=..NewPid()
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1 //开始行
	d ..killTmpGlobal(pid)
	
	s Num=0
	s opaId=""
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
	.s opStartDate=$P(^DHCANOPArrange(opaId),"^",14) //开始日期
	.s opStarTime=$P(^DHCANOPArrange(opaId),"^",15)  //开始时间
	.s:opStartDate'="" opStartDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(opStartDate)  ;$zd(opStartDate,3)
	.s:opStarTime'="" opStarTime=$zt(opStarTime,1)
	.
	.s opEndDate=$P(^DHCANOPArrange(opaId),"^",16)   //结束日期
	.s opEndTime=$P(^DHCANOPArrange(opaId),"^",17)   //结束时间
	.s:opEndDate'="" opEndDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(opEndDate)  ;$zd(opEndDate,3)
	.s:opEndTime'="" opEndTime=$zt(opEndTime,1)
	.
	.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	.s OperCode="", OperDesc="", BladeType=""
	.s subchl=0 
	.f  s subchl=$O(^OR(EpisodeID,"ANA",chl,"OP",subchl)) q:(subchl="")  d
	..s opdr=$P(^OR(EpisodeID,"ANA",chl,"OP",subchl),"^",6) //手术名称
	..i OperDesc'="" s OperDesc=OperDesc_";"
	..i opdr'=""  d
	...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d
	....s OperDesc=OperDesc_$P($g(^ORC("OPER",+opdr)),"^",2)
	....s OperCode=$P($g(^ORC("OPER",+opdr)),"^",1)
	..e  d
	...i $g(^OR(EpisodeID,"ANA",chl,"OP",subchl,"REM",2))'="" d
	....s OperDesc=OperDesc_$g(^OR(EpisodeID,"ANA",chl,"OP",subchl,"REM",2))
	..
	..//手术部位
	..s bodsIdList=$P(^OR(EpisodeID,"ANA",chl,"OP",subchl),"^",24)
	..s bodsList="",BodsDesc=""
	..i bodsIdList'="" d
	...s bodsIdNum=$l(bodsIdList,"|")
	...f j=1:1:bodsIdNum d
	....s bodsId=$p(bodsIdList,"|",j)
	....q:bodsId=""
	....s bodsDesc2=$p($g(^OEC("BODS",+bodsId)),"^",2)
	....i BodsDesc="" s BodsDesc=bodsDesc2
	....e  s BodsDesc=BodsDesc_"|"_bodsDesc2
	..
	..S PreDiag=""
	..S PrediagID=$p(^OR(EpisodeID,"ANA",chl,"OP",subchl),"^",4)  //ANAOP_PreopDiag_DR 术前诊断
	..i PrediagID'=""  d
	...S PreDiag=$p($g(^MRC("ID",PrediagID)),"^",2)
	..
	..s BladeTypeID=$P(^OR(EpisodeID,"ANA",chl,"OP",subchl),"^",9)
	..i BladeTypeID'="" s BladeType=$p(^ORC("BLDTP",BladeTypeID),"^",2)
	.
	.//手术体位
	.s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	.s anaSub=$P(anaId,"||",2)
	.s operPositionId=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",1)),"^")
	.i operPositionId'="" s OperPosition=$P($G(^ORC("OPPOS",operPositionId)),"^",2)
	.e  s OperPosition=""
	.
	.S ListData=EpisodeID_"^"_OperCode_"^"_OperDesc_"^"_opStartDate_" "_opStarTime_"^"_opEndDate_" "_opEndTime_"^"_PreDiag_"^"_BodsDesc_"^"_OperPosition_"^"_BladeType
	.
	.S Num=Num+1
	.S index=Num
	.S ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatOpList",pid,index)=ListData
	.

	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatOpList",pid,index),-1) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatOpList",pid,index)
	.S Title="EpisodeID^OperCode^OperDesc^OperStartDate^OperEndDate^PreDiag^BodsDesc^OperPosition^qktype"
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
	k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatOrdItmDetail",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatExaList",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatLabList",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","LabItmsValue",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPatOpList",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","ExecCntAntCareDrug",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","jsQueryDoc",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","jsQueryExecLoc",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetMRCICDDx",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","jsOutQueryCmtDetail",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","QueryOutPhCmtData",pid)
	k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPhDesc",pid)
	q ""
}

/// Descript:抗菌药物点评(治疗性药物)
/// w ##Class(web.DHCSTCNTANTIBACTERIAL).ExecCntAntCareDrug("2015-03-01^2015-03-16^1")
ClassMethod ExecCntAntCareDrug(param As %String) As %String
{
	n (param)

	s StartDate=$p(param,"^",1)  //开始日期
	s:StartDate'="" StartDate=$zdh(StartDate,3)
	s Enddate=$p(param,"^",2)    //截止日期
	s:Enddate'="" Enddate=$zdh(Enddate,3)
	s CntAntType=$p(param,"^",3) //类型
    s PatLocList=$p(param,"^",4) //病人科室
    s DoctorList=$p(param,"^",5) //开嘱医生
    s DiagList=$p(param,"^",6)   //诊断
    s DrugList=$p(param,"^",7)   //药品
    s PatNameList=$p(param,"^",8) //病人姓名
    s PatNoList=$p(param,"^",9)   //门诊住院号
    s DisList=$p(param,"^",10)    //疾病类型
    s SampMethod=$p(param,"^",11)  //抽样方式
    s SampNum=$p(param,"^",12)     //抽样数
    s SampRate=$p(param,"^",13)    //抽样率
    
    s PrescList=DrugList_"^"_DoctorList

	i CntAntType=1 s IndexCode="PAADM_AdmDate"  //门诊
	i CntAntType=2 s IndexCode="DischDate"      //住院
	s pid=..NewPid()
	d ..killTmpGlobal(pid)

	s Num=0
	f dd=StartDate:1:Enddate d
	.s AdmDr=""
	.f  s AdmDr=$o(^PAADMi(IndexCode,dd,AdmDr)) q:AdmDr=""  d
	..q:'$d(^PAADM(AdmDr))
	..s AdmType=$p(^PAADM(AdmDr),"^",2)
	..q:AdmType'="O"
	..
	..s AdmLocID=$p(^PAADM(AdmDr),"^",4) //就诊科室
	..q:'..CheckStrIfExitVar(PatLocList,AdmLocID)
	..
	..s Papmi=$p(^PAADM(AdmDr),"^",1)
	..s PatName=$p(^PAPER(Papmi,"ALL"),"^",1) //姓名
	..q:'..CheckStrIfExitVar(PatNameList,PatName)
	..
	..s PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1) //登记号
	..q:'..CheckStrIfExitVar(PatNoList,PatNo)
	..
    ..s QuerID=""
    ..f  s QuerID=$o(^PAQUE1(0,"QUE1_PAADM_DR",AdmDr,QuerID)) q:QuerID=""  d
    ...s PrescNo=$p(^PAQUE1(QuerID),"^",14)
    ...s ord=$o(^OEORD(0,"PrescNo",PrescNo,"")) 
    ...q:ord=""
	...s itm=$o(^OEORD(0,"PrescNo",PrescNo,ord,"")) 
	...q:itm=""
	...s orditem=ord_"||"_itm
	...q:$d(^DHCPHCNTS(0,"OrdItem",orditem))  //已生成过点评单
	...
	...s doctocid=$p($g(^OEORD(ord,"I",itm,7)),"^",1)  //医生
	...q:'..CheckStrIfExitVar(DoctorList,doctocid)
	...
	...s quitflag=1
    ...i DrugList'="" d
    ....s quitflag=..FilterPresc(PrescList,PrescNo)  //过滤药品
    ...q:quitflag=0
    ...s Index=PrescNo_"^"_orditem_"^"_AdmDr
    ...s Num=Num+1
    ...s ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","ExecCntAntCareDrug",pid,Num)=Index
    ...

    q:Num=0 0

    S TempIndexList=""
    I Num<SampNum S SampNum=Num    //样本数量少于抽样数
	///随机抽样
	I SampMethod=1 D
	.f i=1:1:SampNum d
	..I Num>SampNum S Index=$RANDOM(Num)+1
	..E  S Index=i
	..S TempIndexList=$s($g(TempIndexList)'="":$g(TempIndexList)_","_Index,1:Index)
	
	///等间隔抽样
	S Index=0
	I SampMethod=2 D
	.s SapceNum=Num/SampNum  //间距
	.s SapceNum=$p(SapceNum,".")
	.f i=1:1:SampNum d
	..S Index=Index+SapceNum
	..S TempIndexList=$s($g(TempIndexList)'="":$g(TempIndexList)_","_Index,1:Index)
	
	///医生固定数量抽样
	I SampMethod=3 D
	.
	//d ..killTmpGlobal(pid)
	
	///删除不符合条件的数据
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","ExecCntAntCareDrug",pid,index)) Q:index=""  D
	.q:..CheckStrIfExitVar(TempIndexList,index)
	.k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","ExecCntAntCareDrug",pid,index)

	Q pid_"^"_Num_"^"_TempIndexList
}

/// Descript:过滤处方明细信息
ClassMethod FilterPresc(InParam As %String, prescno As %String) As %String
{
	N (InParam, prescno)

	s drugList=$p(InParam,"^",1)   //药品列表
	s docotrList=$p(InParam,"^",2) //开医嘱医生
	s quitflag=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:(ord="")||(quitflag=1)  d
	.s itm=""
    .f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:(itm="")||(quitflag=1)  d
 	..s orditem=ord_"||"_itm
	..//i $d(^DHCPHCNTS(0,"OrdItem",orditem)) s quitflag=1 //已生成过点评单
	..//q:quitflag=1 
	..
	..S StatDr=$p(^OEORD(ord,"I",itm,1),"^",13) //医嘱状态
    ..S OeFlag=$p(^OEC("OSTAT",StatDr),"^",1) 
	..Q:(OeFlag'="V")&(OeFlag'="E")
	..
	..//s doctocid=$p($g(^OEORD(ord,"I",itm,7)),"^",1)  //医生
	..//I '..CheckStrIfExitVar(docotrList,doctocid) s quitflag=1 
	..//q:quitflag=1
	..
	..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
	..q:inci=""  //医嘱名称
	..q:'..CheckIfAntDrg(inci) //是否抗菌药品
	..q:'..CheckStrIfExitVar(drugList,inci)
	..
	..s drugpoisonstr=##class(web.DHCSTCOMMONSRV).getPoisonByInci(inci)
	..s drugpoisondr=$p(drugpoisonstr,"^",1)
	..//q:$p(drugpoisonstr,"^",1)'["抗菌"
	..s quitflag=1

	q quitflag
}

/// Descript:检查字符串中是否存在对应的变量
ClassMethod CheckStrIfExitVar(InString As %String, varChar As %String) As %String
{
	N (InString, varChar)
	q:varChar="" "1"
	q:InString="" "1"
	S InStrArrList=$LISTFROMSTRING(InString,",")
 	q:$lv(InStrArrList)=0 "1"
    q:$lf(InStrArrList,varChar)=0 "0"
    q 1
}

/// Descript:对应的检验项目中是否存在指定指标
ClassMethod CheckTsCodeIfExit(InString As %String, oeori As %String) As %String
{
	N (InString, oeori)
	q:InString="" "1"
	S InStrArrList=$LISTFROMSTRING(InString,",")
	q:$lv(InStrArrList)=0 "1"
	s LabTestSetRow=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),3)),"^",35)
	s VisitNumber=$p(LabTestSetRow,"||",1)
	s TestSet=$p(LabTestSetRow,"||",2)
	s TestSetCount=$p(LabTestSetRow,"||",3)
	q:(VisitNumber="")||(TestSet="")||(TestSetCount="") "0"
	
	s quitflag=0
	s TestCode=""
    f  s TestCode=$o(^TEPI(VisitNumber,1,TestSet,TestSetCount,"DATA",TestCode)) q:(TestCode="")||(quitflag=1)  d
	.s tmpResult=$g(^TEPI(VisitNumber,1,TestSet,TestSetCount,"DATA",TestCode))
    .q:$lf(InStrArrList,TestCode)=0
    .s quitflag=1
    q quitflag
}

/// Descript:保存点评单
ClassMethod SaveOutComment(pid As %String, userID As %String, notes As %String, param As %String) As %String
{
	N (pid, userID, notes, param)
	d ##Class(web.DHCSTCNTANTIBACTERIAL).SampCommentData(pid,param) //准备数据

	s Prefix="P"
	TS
	s main=##Class(web.DHCSTCNTSMAIN).SaveCommentNo(userID, notes, Prefix)
	i main'>0 tro  d ..killTmpGlobal(pid)
	q:main'>0 -2_"^"_"保存主表失败"

	//s itm=..SaveCommentItm(pid,main)
	s itm=..SaveIPCommentItm(pid,main)
	
	i +itm'=0 tro  d ..killTmpGlobal(pid)
	q:+itm'=0 -3_"^"_"保存子表失败"
	TC
	d ..killTmpGlobal(pid)
	s commentno=$p(^DHCPHCNTS(main),"^",1)
	q 0_"^"_commentno_"^"_main
}

/// Descript:保存点评明细数据
ClassMethod SaveCommentItm(pid, main) As %String
{
	s ret=0
	s index="" 
	f  s index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","QueryOutPhCmtData",pid,index)) q:(index="")||(ret'=0)  d
	.s itmdata=$g(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","QueryOutPhCmtData",pid,index))
	.s prescno=$p(itmdata,"^",1)
	.s orditem=$p(itmdata,"^",3)
	.s adm=$p(itmdata,"^",2)
	.s ord=$p(orditem,"||",1)
	.s chl=$p(orditem,"||",2)
	.s doclocdr=$p(^OEORD(ord,"I",chl,1),"^",3)
	.s docdr=$p($g(^OEORD(ord,"I",chl,7)),"^",1)
	.s ret=##Class(web.DHCSTCNTSMAIN).SaveItm(main,prescno,orditem,adm,doclocdr,docdr)
	.
	q:ret'=0 ret
	q 0
}

/// Descript:出院点评
ClassMethod ExecCntAntOutHosCmt(param As %String) As %String
{
	n (param)
	
	s StartDate=$p(param,"^",1)  //开始日期
	s:StartDate'="" StartDate=$zdh(StartDate,3)
	s Enddate=$p(param,"^",2)    //截止日期
	s:Enddate'="" Enddate=$zdh(Enddate,3)
	s CntAntType=$p(param,"^",3) //类型
    s PatLocList=$p(param,"^",4) //病人科室
    s DoctorList=$p(param,"^",5) //开嘱医生
    s DiagList=$p(param,"^",6)   //诊断
    s DrugList=$p(param,"^",7)   //药品
    s PatNameList=$p(param,"^",8) //病人姓名
    s PatNoList=$p(param,"^",9)   //门诊住院号
    s DisList=$p(param,"^",10)    //疾病类型
    s SampMethod=$p(param,"^",11)  //抽样方式
    s SampNum=$p(param,"^",12)     //抽样数
    s SampRate=$p(param,"^",13)    //抽样率
    
    s InString=DrugList_"^"_DoctorList

	s pid=..NewPid()
	d ..killTmpGlobal(pid)

	s Num=0
	f dd=StartDate:1:Enddate d
	.s AdmDr=""
	.f  s AdmDr=$o(^PAADMi("DischDate",dd,AdmDr)) q:AdmDr=""  d
	..q:'$d(^PAADM(AdmDr))
	..s AdmType=$p(^PAADM(AdmDr),"^",2)
	..q:AdmType'="I"
    ..q:$d(^DHCPHCNTS(0,"Adm",AdmDr))
    ..
	..s AdmLocID=$p(^PAADM(AdmDr),"^",4) //就诊科室
	..q:'..CheckStrIfExitVar(PatLocList,AdmLocID)
	..
	..s Papmi=$p(^PAADM(AdmDr),"^",1)
	..s PatName=$p(^PAPER(Papmi,"ALL"),"^",1) //姓名
	..q:'..CheckStrIfExitVar(PatNameList,PatName)
	..
	..s PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1) //登记号
	..q:'..CheckStrIfExitVar(PatNoList,PatNo)
	..
    ..q:..ChkExistDsp(AdmDr,InString)=0
    ..s Num=Num+1
    ..s ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","ExecCntAntOutHosCmt",pid,Num)=AdmDr
    
    q:Num=0 0

    S TempIndexList=""
	///随机抽样
	I SampMethod=1 D
	.f i=1:1:SampNum d
	..S Index=$RANDOM(Num)+1
	..S TempIndexList=$s($g(TempIndexList)'="":$g(TempIndexList)_","_Index,1:Index)
	
	///等间隔抽样
	S Index=0
	I SampMethod=2 D
	.s SapceNum=Num/SampNum  //间距
	.s SapceNum=$p(SapceNum,".")
	.f i=1:1:SampNum d
	..S Index=Index+SapceNum
	..S TempIndexList=$s($g(TempIndexList)'="":$g(TempIndexList)_","_Index,1:Index)
	
	///医生固定数量抽样
	I SampMethod=3 D
	.
	//d ..killTmpGlobal(pid)
   	
   	///删除不符合条件的数据
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","ExecCntAntOutHosCmt",pid,index)) Q:index=""  D
	.q:..CheckStrIfExitVar(TempIndexList,index)
	.k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","ExecCntAntOutHosCmt",pid,index)
	
	Q pid_"^"_Num_"^"_TempIndexList
}

/// 检查是否有已执行的药品医嘱
/// Return:0-未执行 1-已执行
ClassMethod ChkExistDspOld(AdmDr As %String, InParam As %String) As %String
{
	n (AdmDr, InParam)
	s drugList=$p(InParam,"^",1)   //药品列表
	s docotrList=$p(InParam,"^",2) //开医嘱医生
	
	s quitflag=0
	s LocStr=##class(web.DHCSTCNTSCOMMON).GetPhaLocStr()
	q:LocStr="" quitflag
	s ord=$o(^OEORD(0,"Adm",AdmDr,""))
	q:ord="" quitflag
	
	f i=1:1:$L(LocStr,"^") d
	.s recLocID=$p(LocStr,"^",i)
	.s chl=""
	.f  s chl=$o(^OEORDi(0,"RecDepOrd",ord,recLocID,chl)) q:(chl="")||(quitflag=1)  d
    ..s orditm=ord_"||"_chl
    ..//s orddeptdr=$p(^OEORD(ord,"I",chl,1),"^",3) //医生科室
    ..//q:'..CheckStrIfExitVar(docLocList,orddeptdr)
    ..
    ..s doctocid=$p($g(^OEORD(ord,"I",chl,7)),"^",1)  //医生
	..q:'..CheckStrIfExitVar(docotrList,doctocid)
	..
    ..s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"")) 
	..q:inci=""  //医嘱名称
	..q:'..CheckIfAntDrg(inci) //是否抗菌药品
	..q:'..CheckStrIfExitVar(drugList,inci)
	..
	..s quitflag=1
	
	q quitflag
}

/// Descript:生成住院医嘱点评单
ClassMethod SaveIPComment(pid As %String, userID As %String, notes As %String, param As %String) As %String
{
	n (pid, userID, notes, param)
	
	d ##Class(web.DHCSTCNTANTIBACTERIAL).SampCommentData(pid,param) //准备数据

	s Prefix="IP"
	TS
	s main=##class(web.DHCSTCNTSMAIN).SaveCommentNo(userID,notes,Prefix,"P")
	i main'>0 tro  d ..killTmpGlobal(pid)
	q:main'>0 -1_"^"_"保存主表失败"

	s itm=..SaveIPCommentItm(pid,main)
	i +itm'=0 tro  d ..killTmpGlobal(pid)
	q:+itm'=0 -3_"^"_"保存子表失败"
	TC
	d ..killTmpGlobal(pid)
	s commentno=$p(^DHCPHCNTS(main),"^",1)
	q 0_"^"_commentno_"^"_main
}

/// Descript:保存点评明细数据
ClassMethod SaveIPCommentItm(pid, main) As %String
{
	s ret=0
	s index="" 
	f  s index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","QueryOutPhCmtData",pid,index)) q:(index="")||(ret'=0)  d
	.s itmdata=$g(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","QueryOutPhCmtData",pid,index))
	.s adm=$p(itmdata,"^",1)
	.s ret=##Class(web.DHCSTCNTSIPDATA).SaveItm(main,adm)
	q:ret'=0 ret
	q 0
}

/// Descript:抗菌药点评
ClassMethod SaveAntComment(UserID As %String, Notes As %String, Prefix As %String, Param As %String) As %String
{
	n (UserID, Notes, Prefix, Param)
	s AdmType=$p(Param,"^",3) //就诊类型
	s ret=""
	i AdmType="P" d
	.s ret=##class(web.DHCSTCNTANTIBACTERIAL).SaveIPComment(UserID,Notes,Prefix,Param)
	e  d
	.s ret=##class(web.DHCSTCNTANTIBACTERIAL).SaveOutComment(UserID,Notes,Prefix,Param)
	q ret
}

/// Descript:获取科室
ClassMethod jsQueryExecLoc(Start As %Integer, Limit As %String, param As %String)
{
	N (Start,Limit,param)
	S EndPage=Start+Limit  //结束行
	S StPage=Start+1 	   //开始行
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	S AliseDesc=$p(param,"^",1)
	S AliseDesc=$ZCVT(AliseDesc,"U")
	S InNationCode=$p(param,"^",2)
	S InHospID=$p(param,"^",3)
	S Num=0
	S LocID=""
	f  S LocID=$o(^CTLOC(LocID)) Q:LocID=""  D
	.S HospID=$p(^CTLOC(LocID),"^",22)
	.Q:(InHospID'="")&(InHospID'=HospID)
	.S LocDesc=$p(^CTLOC(LocID),"^",2)
	.Q:LocDesc["停用"
	.Q:(AliseDesc'="")&(LocDesc'[AliseDesc)
	.S ActiveDate=$p(^CTLOC(LocID),"^",25)
    .Q:(ActiveDate'="")&(ActiveDate<+$H)
    .S type=$p(^CTLOC(LocID),"^",13)
    .Q:type'="E"
    .S NationCode=$p(^CTLOC(LocID),"^",51)
    .S NationCode=$p(NationCode,$C(13),1)
    .Q:(InHospID="1")&(NationCode'="M")&(NationCode'="Z")
    .Q:(InHospID="1")&(InNationCode'="")&(InNationCode'=NationCode)
    .S LocID=$p(LocID,$C(13),1)
    .S LocDesc=$p(LocDesc,$C(13),1)
	.S ListData=LocID_"^"_LocDesc
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","jsQueryExecLoc",pid,Num)=ListData
	.
	
	Q:Num=0 ##class(web.DHCSTCNTUTILCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="rowid^desc"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTCNTUTILCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","jsQueryExecLoc",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","jsQueryExecLoc",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTCNTUTILCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTCNTUTILCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTCNTUTILCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// 获取医生列表
ClassMethod jsQueryDoc(Start As %String, Limit As %String, doclocstr As %String) As %String
{
	N (Start,Limit,doclocstr)
	S EndPage=Start+Limit  //结束行
	S StPage=Start+1 	   //开始行
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	S Num=0
	s ctpt=""
	f  s ctpt=$o(^CT("CPT",ctpt)) q:ctpt=""  d
	.s active=$p(^CT("CPT",ctpt),"^",3)
	.q:active'="Y"
	.s type=$p(^CT("CPT",ctpt),"^",4)
	.q:type'="DOCTOR"
	.s ctpcp=""
	.f  s ctpcp=$o(^CTPCP(0,"CareProvType",ctpt,ctpcp)) q:ctpcp=""  d 
	..s ssuser=$o(^SSU("SSUSR",0,"CTPCP",ctpcp,""))
	..q:ssuser=""
	..S quitflag=0
	..s reslocdr=""
	..f  s reslocdr=$o(^RB("RES",0,"CTPCP",ctpcp,reslocdr)) q:(reslocdr="")||(quitflag=1)  d
	...q:'..CheckStrIfExitVar(doclocstr,reslocdr)
	...S quitflag=1
	..//Q:quitflag=0
	..s docname=$p(^SSU("SSUSR",ssuser),"^",2)
	..i $f(docname,$c(13)) s docname=$p(docname,$c(13),1)
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","jsQueryDoc",pid,Num)=ssuser_"^"_docname

	Q:Num=0 ##class(web.DHCSTCNTUTILCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="rowid^desc"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTCNTUTILCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","jsQueryDoc",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","jsQueryDoc",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTCNTUTILCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTCNTUTILCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTCNTUTILCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:获取诊断字典信息
/// W ##class(web.DHCSTCNTANTIBACTERIAL).GetMRCICDDx("2","1","")
ClassMethod GetMRCICDDx(Start As %String, Limit As %String, param As %String)
{
	N (Start,Limit,param)
	S EndPage=Start+Limit  //结束行
	S StPage=Start+1 	   //开始行
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	S AliseDesc=$p(param,"^",1)
	S Num=0
    S MRCID=0 
    F  S MRCID=$o(^MRC("ID",MRCID)) q:MRCID=""  d
    .S MRCCode=$p(^MRC("ID",MRCID),"^",1)  //代码
    .S MRCDesc=$p(^MRC("ID",MRCID),"^",2)  //描述
    .Q:MRCDesc'[AliseDesc
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetMRCICDDx",pid,Num)=MRCID_"^"_MRCDesc

	Q:Num=0 ##class(web.DHCSTCNTUTILCOMMON).getJsonEmptySign(0) //输出空的json串
	
	//S Title="MRCID^MRCDesc"
	S Title="rowid^desc"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTCNTUTILCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetMRCICDDx",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetMRCICDDx",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTCNTUTILCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTCNTUTILCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTCNTUTILCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:获取药品列表
/// W ##class(web.DHCSTCNTANTIBACTERIAL).GetPhDesc("2","1","")
ClassMethod GetPhDesc(Start As %String, Limit As %String, param As %String) As %String
{
	N (Start,Limit,param)
	S EndPage=Start+Limit  //结束行
	S StPage=Start+1 	   //开始行
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	S AliseDesc=$p(param,"^",1)
	S Num=0
    S INCI=0 
    F  S INCI=$o(^INCI(INCI)) q:INCI=""  d
    .Q:+INCI=0
    .//S InciCode=$p(^INCI(INCI,1),"^",1)  //代码
    .S InciDesc=$p(^INCI(INCI,1),"^",2)    //描述
    .//Q:'..CheckIfAntDrg(INCI)  //判断是否是抗菌药
    .S IncStkCatGrpStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(INCI)
    .Q:$p(IncStkCatGrpStr,"^",3)'="G"
    .Q:InciDesc'[AliseDesc
    .
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPhDesc",pid,Num)=INCI_"^"_InciDesc

	Q:Num=0 ##class(web.DHCSTCNTUTILCOMMON).getJsonEmptySign(0) //输出空的json串
	
	//S Title="MRCID^MRCDesc"
	S Title="rowid^desc"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTCNTUTILCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPhDesc",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","GetPhDesc",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTCNTUTILCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTCNTUTILCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTCNTUTILCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:判断药品是否是抗菌药
ClassMethod CheckIfAntDrg(Inci As %String) As %String
{
	N (Inci)
	Q:Inci="" "0"
	S arcimid=$p(^INCI(Inci,1),"^",3)
	Q:arcimid="" "0"
	S itmmastid=$p(arcimid,"||",1)
	S itmmastver=$p(arcimid,"||",2)
	S drgfrm=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",12)
	Q:drgfrm="" "0"
	S drg=+drgfrm q:drg="" ""
	Q:'$d(^PHCD(drg,1)) "0"
	S subcat=$p(^PHCD(drg,1),"^",3) 
	Q:subcat="" "0"
	S cat=+subcat,sub=$p(subcat,"||",2)
	Q:cat="" "0"
	Q:sub="" "0"
	S catdesc=$p($G(^PHCC(cat)),"^",2)
	S subcatdesc=$p($G(^PHCC(cat,"SC",sub)),"^",2)
	Q:subcatdesc'["抗菌" "0"
	/*
	S minsubcat=$p(^PHCD(drg,1),"^",6) 
	i minsubcat="" S minsubcatdesc=""
	E  S minsubcatdesc=$p($g(^PHCC(cat,"SC",sub,"MIN",$P(minsubcat,"||",3))),"^",2)
	i subcatdesc="" S phcCatDesc=catdesc
	E  S phcCatDesc=catdesc_"/"_subcatdesc  
	i minsubcatdesc'="" S phcCatDesc=phcCatDesc_"/"_minsubcatdesc
	Q $g(phcCatDesc)
	*/
	Q 1
}

/// Descript:门诊抗菌药物点评明细
/// W ##Class(web.DHCSTCNTANTIBACTERIAL).jsOutQueryCmtDetail("0","2","1/12/2014^3/04/2015^P20150114_003")
ClassMethod jsOutQueryCmtDetail(StartPage As %String, Limit As %String, ParamList As %String) As %String
{
	N (StartPage, Limit, ParamList)
	S pid=..NewPid()
	d ..killTmpGlobal(pid)

	S StPage=StartPage+1 	   //开始行
	S EndPage=StartPage+Limit  //结束行
	
	S StartDate=$p(ParamList,"^",1) //开始日期
	S EndDate=$p(ParamList,"^",2)   //结束日期
	S:StartDate["-" StartDate=$zdh(StartDate,3)
	S:StartDate["/" StartDate=$zdh(StartDate,4)
   	S:EndDate["-" EndDate=$zdh(EndDate,3)
   	S:EndDate["/" EndDate=$zdh(EndDate,4)
	S CommentNoList=$p(ParamList,"^",3)     //单号
	S DLocID=$p(ParamList,"^",4)     //医生科室
	S ResFlag=$p(ParamList,"^",5) 	 //点评结果

	S Num=0
	F dd=StartDate:1:EndDate D
	.S pcnts=""
	.F  S pcnts=$o(^DHCPHCNTS(0,"Date",dd,"F",pcnts)) Q:pcnts=""  D
	..S pcntsno=$p(^DHCPHCNTS(pcnts),"^",1)
	..q:'..CheckStrIfExitVar(CommentNoList,pcntsno)  //过滤点评单
	..S pcntsdate=$p(^DHCPHCNTS(pcnts),"^",2)
	..S:pcntsdate'="" pcntsdate=$zd(pcntsdate,3)
	..S pcntstime=$p(^DHCPHCNTS(pcnts),"^",3)
	..S:pcntstime'="" pcntstime=$zt(pcntstime,1)
	..S pcntstext=$p(^DHCPHCNTS(pcnts),"^",4)
	..S pcntsuserdr=$p(^DHCPHCNTS(pcnts),"^",6)
	..S username=$p(^SSU("SSUSR",pcntsuserdr),"^",2)
	..s chl=""
	..f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	...s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	...s orditem=$p(^DHCPHCNTS(pcnts,"I",chl),"^",2)
	...s ord=$p(orditem,"||",1)
	...s itm=$p(orditem,"||",2)
	...s orddate=$p(^OEORD(ord,"I",itm,3),"^",7)
	...i orddate'="" s orddate=$zd(orddate,3)  //处方日期
	...s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	...s papmi=$p(^PAADM(adm),"^",1)
	...s patname=$p(^PAPER(papmi,"ALL"),"^", 1) //患者姓名
	...s patsex=""
	...s patsexdr=$p(^PAPER(papmi,"ALL"),"^",7 ) 
	...s:patsexdr'="" patsex=$p(^CT("SEX",patsexdr),"^",2 ) //性别
	...s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	...s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  //年龄   
    ...s diag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",") //诊断
    ...i $f(diag,$c(13)) s diag=$p(diag,$c(13),1)
	...s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
    ...s orddept=$p(^CTLOC(doclocdr),"^",2)
    ...q:'..CheckStrIfExitVar(DLocID,doclocdr) //过滤医生科室
	...s docdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
	...s doctorcode=$p(^SSU("SSUSR",docdr),"^",1)  	  	//医生工号
	...s doctorname=$p(^SSU("SSUSR",docdr),"^",2)  	  	//医生姓名
	...s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) 	//结果
	...q:(ResFlag=1)&(curret'="Y")
	...q:(ResFlag=2)&(curret'="N")
	...q:(ResFlag=4)&(curret="") //仅有结果
	...i curret="Y" s curret="合格"
	...i curret="N" s curret="不合格"
	...s retdata=##Class(web.DHCSTCNTSQUERY).GetPrescNoInfo(prescno)
	...s datanum=$p(retdata,"^",1)  //品种数
	...s amt=$p(retdata,"^",2)      //处方金额
	...s pyuser=$p(retdata,"^",3) 	//配药人
	...s fyuser=$p(retdata,"^",4) 	//发药人
	...s zsnum=$p(retdata,"^",5) 	//注射
	...s kjnum=$p(retdata,"^",6) 	//抗菌
	...s bnum=$p(retdata,"^",7) 	//基本药物
	...s gernum=$p(retdata,"^",8) 	//通用药品名数
	...s reasoninfo=##Class(web.DHCSTCNTSQUERY).GetCommentRea(orditem) //不合理原因
	...s reacode=$p(reasoninfo,"^",1)
	...s reason=$p(reasoninfo,"^",2)
	...s phadvice=$p(reasoninfo,"^",3)
	...s phnote=$p(reasoninfo,"^",4)
	...
    ...s dataList=pcntsno_"^"_patno_"^"_orddept_"^"_doctorcode_"^"_doctorname_"^"_patname_"^"_orddate
    ...s dataList=dataList_"^"_patage_"^"_diag_"^"_datanum_"^"_zsnum_"^"_kjnum_"^"_bnum_"^"_gernum_"^"_pyuser_"^"_fyuser
    ...s dataList=dataList_"^"_username_"^"_curret_"^"_reason_"^"_phadvice_"^"_phnote_"^"_pid_"^"_pcntsdate
	...
	...S Num=Num+1
	...S ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","jsOutQueryCmtDetail",pid,Num)=dataList

	Q:Num=0 ##class(web.DHCSTCNTUTILCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="pcntsno^patno^orddept^doctorcode^doctor^patname^prescdate^patage^diag^datanum^zsnum^kjnum^bnum^gernum^pyuser^fyuser^username^curret^reason^phadvice^phnote^pid^pcntsdate"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTCNTUTILCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","jsOutQueryCmtDetail",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","jsOutQueryCmtDetail",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTCNTUTILCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTCNTUTILCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTCNTUTILCOMMON).getJsonEndSign() //输出json结尾符
	//d ..killTmpGlobal(pid)
	q ""
}

/// ========================================特定药物点评=========================
/// Descript:特定药物点评
/// param - 开始日期^结束日期^就诊类型^医生科室^医生^抗拒药物级别^费别^管制分类^
///         年龄范围^药学分类^审核人^剂型^疗程^给药途径^登记号^临床诊断^疾病类型
/// w ##Class(web.DHCSTCNTANTIBACTERIAL).QueryCommentData("2015-10-06^2015-11-06^O^951,955,958^^^^^^^^^^^^^^^^^")
ClassMethod QueryCommentData(pid As %String, param As %String) As %String
{
	n (pid,param)
	i pid="" s pid=..NewPid()
	d ..killTmpGlobal(pid)
	s AdmType=$p(param,"^",3) //类型
	s ret=""
	i AdmType="I" d
	.s ret=##class(web.DHCSTCNTANTIBACTERIAL).QueryInPhCmtData(pid,param)  	  //在院
	
	i AdmType="D" d
	.s ret=##class(web.DHCSTCNTANTIBACTERIAL).QueryDisInPhCmtData(pid,param)  //出院
		
	i (AdmType="O")||(AdmType="E") d
	.s ret=##class(web.DHCSTCNTANTIBACTERIAL).QueryOutPhCmtData(pid,param) //门诊

	w ##class(web.DHCSTPHCMCOMMON).getJsonData("Num^Pid",ret_"^"_pid)
	q ""
}

/// Descript:特定药物点评[门诊]
ClassMethod QueryOutPhCmtData(pid As %String, param As %String) As %String
{
	N (pid,param)
	s StartDate=$p(param,"^",1) //开始日期
	s:StartDate'="" StartDate=$zdh(StartDate,3)
	s Enddate=$p(param,"^",2) 	//结束日期
	s:Enddate'="" Enddate=$zdh(Enddate,3)	
	s InAdmType=$p(param,"^",3) 	//类型
	s LocIDList=$p(param,"^",4) 	    //医生科室
	s BillTypeID=$p(param,"^",10)       //费别
	s InPatNoList=$p(param,"^",18) 	    //登记号
	s InPatNameList=$p(param,"^",19) 	//病人姓名
	s PatICDList=$p(param,"^",20) 	    //临床诊断
	s DisType=$p(param,"^",21)          //疾病类型
	s PatAgeRange=$p(param,"^",12)      //年龄范围
	s PatSexID=$p(param,"^",22)         //病人年龄
	s CTPTypeID=$p(param,"^",23)        //医生职称

	s Num=0
	f AdmData=StartDate:1:Enddate d
	.f i=1:1:$L(LocIDList,",") d
	..s LocID=$p(LocIDList,",",i)
 	..s AdmTime=""
	..f  s AdmTime=$o(^PAADMi("PAADM_LocDateTime",LocID,AdmData,AdmTime)) q:AdmTime=""  d
	...s AdmDr=""
	...f  s AdmDr=$o(^PAADMi("PAADM_LocDateTime",LocID,AdmData,AdmTime,AdmDr)) q:AdmDr=""  d
	....Q:'$d(^PAADM(AdmDr))
	....//Q:$d(^DHCPHCNTS(0,"Adm",AdmDr))    //已经点评过的病人
	....s AdmType=$p(^PAADM(AdmDr),"^",2)
	....q:AdmType'=InAdmType
	....s PatientID=$p(^PAADM(AdmDr),"^",1)
	....s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  	   //登记号
	....Q:'..CheckStrIfExitVar(InPatNoList,PatNo)
	....S PatName=$p(^PAPER(PatientID,"ALL"),"^", 1)       //患者姓名
	....Q:'..CheckStrIfExitVar(InPatNameList,PatName)
	....s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)          //姓别
	....Q:(PatSexID'="")&(PatSexID'=sexId)
	....//s PatAge=+##Class(web.DHCSTKUTIL).GetAge(PatientID)  //年龄
	....Q:..CheckAgeRange(PatAgeRange,PatientID)
    ....s PatBillTypedr=+$p(^PAPER(PatientID,"PER",1),"^",10)
	....Q:(BillTypeID'="")&(PatBillTypedr'=BillTypeID)      //过滤费别
	....s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",") //诊断
	....Q:'..CheckStrIfExitVar(PatDiag,PatICDList)
    ....Q:..CheckPrescData(AdmDr,param)=0
    ....s ListData=AdmDr
    ....s Num=Num+1
    ....s ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","QueryOutPhCmtData",pid,Num)=ListData
    ...

    q Num
}

/// Descript:特定药物点评[在院]
ClassMethod QueryInPhCmtData(pid, param As %String) As %String
{
	N (pid,param)
	S LocIDList=$p(param,"^",4) 	//医生科室
	s BillTypeID=$p(param,"^",10)   //费别
	s InPatNoList=$p(param,"^",18) 	    //登记号
	s InPatNameList=$p(param,"^",19) 	//病人姓名
	s PatICDList=$p(param,"^",20) 	//临床诊断
	s DisType=$p(param,"^",21)      //疾病类型
	s PatAgeRange=$p(param,"^",12)  //年龄范围
	s PatSexID=$p(param,"^",22)     //病人年龄
	s CTPTypeID=$p(param,"^",23)    //医生职称
	s BladeTypeID=$p(param,"^",24)    //切口类型
	
	S Num=0
	S AdmDr=""
	F  S AdmDr=$o(^PAADMi("AdmTypeCurr","I",AdmDr)) Q:AdmDr=""  D
	.Q:'$d(^PAADM(AdmDr))
	.S AdmLocID=$p(^PAADM(AdmDr),"^",4) //科室
	.Q:'..CheckStrIfExitVar(LocIDList,AdmLocID)
	.Q:$d(^DHCPHCNTS(0,"Adm",AdmDr))    //已经点评过的病人
	.S PatientID=$p(^PAADM(AdmDr),"^",1)
	.S PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  		 //登记号
	.Q:'..CheckStrIfExitVar(InPatNoList,PatNo)
	.S PatName=$p(^PAPER(PatientID,"ALL"),"^", 1)        //患者姓名
	.Q:'..CheckStrIfExitVar(InPatNameList,PatName)
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)           //姓别
	.Q:(PatSexID'="")&(PatSexID'=sexId)
	.//S patAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  //年龄
	.Q:..CheckAgeRange(PatAgeRange,PatientID)
    .S PatBillTypedr=+$p(^PAPER(PatientID,"PER",1),"^",10)
	.Q:(BillTypeID'="")&(PatBillTypedr'=BillTypeID)      //过滤费别
	.S PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",") //诊断
	.Q:'..CheckStrIfExitVar(PatDiag,PatICDList)
	.s PatAnOpBladeTypeList=..getPatAnOpBladeType(AdmDr)
	.Q:(BladeTypeID'="")&(PatAnOpBladeTypeList'[BladeTypeID)
    .Q:..ChkExistDsp(AdmDr,param)=0
    .S Num=Num+1
    .S ListData=AdmDr
    .S ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","QueryOutPhCmtData",pid,Num)=ListData
    .
    Q Num
}

/// Descript:特定药物点评[出院]
ClassMethod QueryDisInPhCmtData(pid, param As %String) As %String
{
	N (pid,param)
	S StartDate=$p(param,"^",1) 	//开始日期
	S:StartDate'="" StartDate=$zdh(StartDate,3)
	S Enddate=$p(param,"^",2) 		//结束日期
	S:Enddate'="" Enddate=$zdh(Enddate,3)	
	S AdmType=$p(param,"^",3) 		//类型
	S LocIDList=$p(param,"^",4) 	//医生科室
	S BillTypeID=$p(param,"^",10)   //费别
	S InPatNoList=$p(param,"^",18) 	    //登记号
	S InPatNameList=$p(param,"^",19) 	//病人姓名
	S PatICDList=$p(param,"^",20) 	//临床诊断
	S DisType=$p(param,"^",21)      //疾病类型
	s PatAgeRange=$p(param,"^",12)  //年龄范围
	s PatSexID=$p(param,"^",22)     //病人年龄
	s CTPTypeID=$p(param,"^",23)    //医生职称
	s BladeTypeID=$p(param,"^",24)    //切口类型

	S Num=0
	F dd=StartDate:1:Enddate D
	.S AdmDr=""
	.F  S AdmDr=$o(^PAADMi("DischDate",dd,AdmDr)) Q:AdmDr=""  D
	..Q:'$d(^PAADM(AdmDr))
	..S AdmLocID=$p(^PAADM(AdmDr),"^",4) //科室
	..Q:'..CheckStrIfExitVar(LocIDList,AdmLocID)
	..Q:$d(^DHCPHCNTS(0,"Adm",AdmDr))    //已经点评过的病人
	..S PatientID=$p(^PAADM(AdmDr),"^",1)
	..S PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  		  //登记号
	..Q:'..CheckStrIfExitVar(InPatNoList,PatNo)
	..S PatName=$p(^PAPER(PatientID,"ALL"),"^", 1)        //患者姓名
	..Q:'..CheckStrIfExitVar(InPatNameList,PatName)
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)           //姓别
	..Q:(PatSexID'="")&(PatSexID'=sexId)
	..//S patAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  //年龄
	..Q:..CheckAgeRange(PatAgeRange,PatientID)
    ..S PatBillTypedr=+$p(^PAPER(PatientID,"PER",1),"^",10)
	..Q:(BillTypeID'="")&(PatBillTypedr'=BillTypeID)      //过滤费别
	..S PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",") //诊断
	..Q:'..CheckStrIfExitVar(PatDiag,PatICDList)
	..s PatAnOpBladeTypeList=..getPatAnOpBladeType(AdmDr)
	..Q:(BladeTypeID'="")&(PatAnOpBladeTypeList'[BladeTypeID)
    ..Q:..ChkExistDsp(AdmDr,param)=0
    ..S Num=Num+1
    ..S ListData=AdmDr
    ..S ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","QueryOutPhCmtData",pid,Num)=ListData
    ..

    Q Num
}

/// Descript:特定药物点评[门诊]
ClassMethod QueryOutPhCmtDataByDate(pid As %String, param As %String, HospID As %String) As %String
{
	N (pid,param,HospID)
	s StartDate=$p(param,"^",1) //开始日期
	s:StartDate'="" StartDate=$zdh(StartDate,3)
	s Enddate=$p(param,"^",2) 	//结束日期
	s:Enddate'="" Enddate=$zdh(Enddate,3)	
	s InAdmType=$p(param,"^",3) 	//类型
	s LocIDList=$p(param,"^",4) 	    //医生科室
	s BillTypeID=$p(param,"^",10)       //费别
	s InPatNoList=$p(param,"^",18) 	    //登记号
	s InPatNameList=$p(param,"^",19) 	//病人姓名
	s PatICDList=$p(param,"^",20) 	    //临床诊断
	s DisType=$p(param,"^",21)          //疾病类型
	s PatAgeRange=$p(param,"^",12)      //年龄范围
	s PatSexID=$p(param,"^",22)         //病人年龄
	s CTPTypeID=$p(param,"^",23)        //医生职称

	s Num=0
	f AdmData=StartDate:1:Enddate d
	.s AdmDr=""
	.f  s AdmDr=$o(^PAADMi("PAADM_AdmDate",AdmData,AdmDr)) q:AdmDr=""  d
	..Q:'$d(^PAADM(AdmDr))
	..s AdmType=$p(^PAADM(AdmDr),"^",2)
	..q:AdmType'="O"
	..s PatientID=$p(^PAADM(AdmDr),"^",1)
	..Q:'$d(^DHCPHDISPi("PAPMI",PatientID))  		   //未发药处方为无效处方
	..s AdmLocID=$p(^PAADM(AdmDr),"^",4)			   //科室
	..Q:$p(^CTLOC(AdmLocID),"^",22)'=HospID
	..s AdmLocDesc=$p($g(^CTLOC(+AdmLocID)),"^",2)
	..Q:(InAdmType="E")&(AdmLocDesc'["急诊")
	..Q:(InAdmType="O")&(AdmLocDesc["急诊")
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  	   //登记号
	..Q:'..CheckStrIfExitVar(InPatNoList,PatNo)
	..S PatName=$p(^PAPER(PatientID,"ALL"),"^", 1)       //患者姓名
	..Q:'..CheckStrIfExitVar(InPatNameList,PatName)
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)          //姓别
	..Q:(PatSexID'="")&(PatSexID'=sexId)
	..//s PatAge=+##Class(web.DHCSTKUTIL).GetAge(PatientID)  //年龄
	..Q:..CheckAgeRange(PatAgeRange,PatientID)
    ..s PatBillTypedr=+$p(^PAPER(PatientID,"PER",1),"^",10)
	..Q:(BillTypeID'="")&(PatBillTypedr'=BillTypeID)      //过滤费别
	..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",") //诊断
	..Q:'..CheckStrIfExitVar(PatDiag,PatICDList)
    ..Q:..CheckPrescData(AdmDr,param)=0
    ..s ListData=AdmDr
    ..s Num=Num+1
    ..s ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","QueryOutPhCmtData",pid,Num)=ListData
    ..
    
    q Num
}

/// Descript:筛选符合条件的处方
/// param - 开始日期^结束日期^就诊类型^医生科室^医生^抗拒药物级别^费别^管制分类^
///         年龄范围^药学分类^审核人^剂型^疗程^给药途径^登记号^临床诊断^疾病类型
ClassMethod CheckPrescData(EpisodeID As %String, Param As %String) As %String
{
	N (EpisodeID,Param)
	S DoctorID=$p(Param,"^",5) 		//医生
	S AntFlag=$p(Param,"^",6) 		//是否包含抗菌药
    S CntAntLev=$p(Param,"^",7) 	//抗菌药级别
    S IncItmIDList=$p(Param,"^",8)  //药品
    S PhaLocID=$p(Param,"^",9)  	//药房名称
    S PoisonID=$p(Param,"^",11)   	//管制分类
    S PhaCatList=$p(Param,"^",13) 	//药学分类
    S PhaCatDr=$p(PhaCatList,"@",2)
    S AuditUserID=$p(Param,"^",14) 	//审核药师
    S PhcFormDr=$p(Param,"^",15) 	//剂型
    S PhcDurID=$p(Param,"^",16)     //疗程 
    S InstrucID=$p(Param,"^",17)    //给药途径

    q:(AntFlag'="")&(..CheckIfExitAntDrug(EpisodeID)'=AntFlag) 0
    
    S quitflag=0,ret=0
	S quer=""
    F  S quer=$o(^PAQUE1(0,"QUE1_PAADM_DR",EpisodeID,quer)) q:(quer="")||(ret=1)  d
    .S prescno=$p(^PAQUE1(quer),"^",14)
    .S auditUser=##Class(web.DHCSTCNTSMAIN).getPrescAuditUser(prescno)
    .Q:(AuditUserID'="")&(auditUser'=AuditUserID)
	.S ord=""
	.f  S ord=$o(^OEORD(0,"PrescNo",prescno,ord))  Q:(ord="")||(quitflag=1)||(ret=1)  D
	..S itm=""
    ..f  S itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) Q:(itm="")||(quitflag=1)||(ret=1)  D
 	...S orditem=ord_"||"_itm
	...S StatDr=$p(^OEORD(ord,"I",itm,1),"^",13) //医嘱状态
    ...S OeFlag=$p(^OEC("OSTAT",StatDr),"^",1) 
	...Q:(OeFlag'="V")&(OeFlag'="E")  			//检查医嘱是否有效
	...
	...S doctocid=$p($g(^OEORD(ord,"I",itm,7)),"^",1)  //医生
	...I (DoctorID'="")&(DoctorID'=doctocid) S quitflag=1
	...Q:quitflag=1
	...
	...S reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)     //药房名称
	...I (PhaLocID'=reclocdr)&(PhaLocID'="") S quitflag=1
	...Q:quitflag=1
	...
	...S instrdr=+$p(^OEORD(ord,"I",itm,2),"^",7)  	  //用法
	...Q:(InstrucID'="")&(InstrucID'=instrdr)
	...
	...S durtionID=+$p(^OEORD(ord,"I",itm,2),"^",6)    //疗程
	...Q:(PhcDurID'="")&(PhcDurID'=durtionID)
	...
	...S arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)       //医嘱 ARC_ItmMast ARCIM_RowId
	...S itmmastid=$p(arcimid,"||",1)
	...S itmmastver=$p(arcimid,"||",2)
	...
	...S inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
	...Q:inci=""  //医嘱名称
	...Q:'..CheckStrIfExitVar(IncItmIDList,inci)
	...
	...S rArcimPhcdfDr=$p(^ARCIM(itmmastid,itmmastver,1),"^",12) //指向PHC_DrgForm
 	...S rPhcDrgForm1=$p(rArcimPhcdfDr,"||",1)
 	...S rPhcDrgForm2=$p(rArcimPhcdfDr,"||",2)
 	...Q:(rPhcDrgForm1="")&(rPhcDrgForm2="") 
 	...Q:'$d(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2))
 	...S rPhcdfPhcfDr=$p(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2,1),"^",1) //指向PHC_Form
 	...Q:(PhcFormDr'="")&(PhcFormDr'=rPhcdfPhcfDr)
 	...
	...S drugpoisonstr=##class(web.DHCSTCOMMONSRV).getPoisonByInci(inci)
	...S drugpoisondr=$p(drugpoisonstr,"^",1)
	...S drugpoisondesc=$p(drugpoisonstr,"^",3)
	...Q:(CntAntLev'="")&(CntAntLev'=drugpoisondr)
	...Q:(PoisonID'="")&(PoisonID'=drugpoisondr)     //管制分类
	...
	...S phccat="",phcsubcat="",phcmincat=""
	...i PhaCatDr'="" d
	....S phccat=##class(web.DHCSTCNTSCOMMON).PhaCatByArcim(arcimid)
	....S phcsubcat=##class(web.DHCSTCNTSCOMMON).PhaSubCatByArcim(arcimid)
	....S phcmincat=##class(web.DHCSTCNTSCOMMON).PhaMinorSubCatByArcim(arcimid)
	...Q:(PhaCatDr'="")&(PhaCatDr'=phccat)&(PhaCatDr'=phcsubcat)&(PhaCatDr'=phcmincat)
	...s ret=1
	.
	Q ret
}

/// Descript：筛选数据
ClassMethod ChkExistDsp(AdmDr As %String, Param As %String) As %String
{
	N (AdmDr,Param)
	S DoctorID=$p(Param,"^",5) 		//医生
	S AntFlag=$p(Param,"^",6) 		//是否包含抗菌药
    S CntAntLev=$p(Param,"^",7) 	//抗菌药级别
    S IncItmIDList=$p(Param,"^",8)  //药品
    S PhaLocID=$p(Param,"^",9)  	//药房名称
    S PoisonID=$p(Param,"^",11)   	//管制分类
    S PhaCatList=$p(Param,"^",13) 	//药学分类
    S PhaCatDr=$p(PhaCatList,"@",2)
    S AuditUserID=$p(Param,"^",14) 	//审核药师
    S PhcFormDr=$p(Param,"^",15) 	//剂型
    S PhcDurID=$p(Param,"^",16)     //疗程 
    S InstrucID=$p(Param,"^",17)    //给药途径
	
	S quitflag=0,ret=0
	S ord=$o(^OEORD(0,"Adm",AdmDr,""))
	Q:ord="" ret
	
	q:(AntFlag'="")&(..CheckIfExitAntDrug(AdmDr)'=AntFlag) 0
	
	S LocList="1136^1129^1987^898"

	f i=1:1:$L(LocList,"^") Q:(ret=1)  D
	.S recLocID=$p(LocList,"^",i)
	.Q:(PhaLocID'="")&(PhaLocID'=recLocID)
	.S itm=""
	.f  S itm=$o(^OEORDi(0,"RecDepOrd",ord,recLocID,itm)) Q:(itm="")||(quitflag=1)||(ret=1)  D
    ..S orditm=ord_"||"_itm
    ..S FillerNo=$p(^OEORD(ord,"I",itm,9),"^",12)  	  //滚医嘱来源信息 OEORI_FillerNo
    ..Q:(FillerNo'="")&(FillerNo'=orditm_"!!"_orditm) //长嘱非首日记录过滤
    ..
	..S StatDr=$p(^OEORD(ord,"I",itm,1),"^",13)       //医嘱状态
	..Q:StatDr=""
    ..S OeFlag=$p(^OEC("OSTAT",StatDr),"^",1) 
	..Q:(OeFlag'="V")&(OeFlag'="E")  			      //检查医嘱是否有效
	..
	..S doctocid=$p($g(^OEORD(ord,"I",itm,7)),"^",1)  //医生
	..Q:(DoctorID'="")&(DoctorID'=doctocid)
	..
	..S instrdr=+$p(^OEORD(ord,"I",itm,2),"^",7)  	  //用法
	..Q:(InstrucID'="")&(InstrucID'=instrdr)
	..
	..S durtionID=+$p(^OEORD(ord,"I",itm,2),"^",6)    //疗程
	..Q:(PhcDurID'="")&(PhcDurID'=durtionID)
	..
	..S arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)       //医嘱 ARC_ItmMast ARCIM_RowId
	..S itmmastid=$p(arcimid,"||",1)
	..S itmmastver=$p(arcimid,"||",2)
	..
	..S inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
	..Q:inci=""  //医嘱名称
	..Q:'..CheckStrIfExitVar(IncItmIDList,inci)
	..
	..S rArcimPhcdfDr=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)   //指向PHC_DrgForm
 	..S rPhcDrgForm1=$p(rArcimPhcdfDr,"||",1)
 	..S rPhcDrgForm2=$p(rArcimPhcdfDr,"||",2)
 	..Q:(rPhcDrgForm1="")&(rPhcDrgForm2="") 
 	..Q:'$d(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2))
 	..S rPhcdfPhcfDr=$p(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2,1),"^",1)   //指向PHC_Form
 	..Q:(PhcFormDr'="")&(PhcFormDr'=rPhcdfPhcfDr)
 	..
	..S drugpoisonstr=##class(web.DHCSTCOMMONSRV).getPoisonByInci(inci)
	..S drugpoisondr=$p(drugpoisonstr,"^",1)
	..S drugpoisondesc=$p(drugpoisonstr,"^",3)
	..Q:(CntAntLev'="")&(CntAntLev'=drugpoisondr)
	..Q:(PoisonID'="")&(PoisonID'=drugpoisondr)    //管制分类
	..
	..S phccat="",phcsubcat="",phcmincat=""
	..i PhaCatDr'="" d
	...S phccat=##class(web.DHCSTCNTSCOMMON).PhaCatByArcim(arcimid)
	...S phcsubcat=##class(web.DHCSTCNTSCOMMON).PhaSubCatByArcim(arcimid)
	...S phcmincat=##class(web.DHCSTCNTSCOMMON).PhaMinorSubCatByArcim(arcimid)
	..Q:(PhaCatDr'="")&(PhaCatDr'=phccat)&(PhaCatDr'=phcsubcat)&(PhaCatDr'=phcmincat)
	..S ret=1
	.
	
	q ret
}

/// Descript:保存点评单
ClassMethod SaveComment(pid As %String, userID As %String, notes As %String, param As %String) As %String
{
	n (pid,userID,notes,param)
	s admType=$p(param,"^",1) //就诊类型
	s ret=""
	i (admType="O")||(admType="E") d
	.s ret=##class(web.DHCSTCNTANTIBACTERIAL).SaveOutComment(pid,userID,notes,param)
	e  d
	.s ret=##class(web.DHCSTCNTANTIBACTERIAL).SaveIPComment(pid,userID,notes,param)
	w ##class(web.DHCSTPHCMCOMMON).getJsonData("retvalue^CommentNo^CommentID",ret)
	q ""
}

/// Descript:抽取点评数据
ClassMethod SampCommentData(pid As %String, param As %String) As %String
{
	n (pid,param)

	s SamWay=$p(param,"^",2)  /// 抽样方式
	s SampNum=$p(param,"^",3)  /// 抽样数
	s Num=$p(param,"^",5)  	  /// 处方总数

	s TempIndexList=""
	/*
	///随机抽样
	i SamWay=1 d
	.f i=1:1:SamNum d
	..s Index=$RANDOM(Num)+1
	..s quitflag=..CheckStrIfExitVar(TempIndexList,Index)
	..i quitflag=1 s i=i-1
	..q:quitflag=1          ///存在相同数据
	..
	..i TempIndexList=""  s TempIndexList=Index
	..e  s TempIndexList=TempIndexList_","_Index
	.
	*/

	///等间隔抽样
	i (SamWay=2)||(SamWay=1) d
	.s SapceNum=Num/SampNum  //间距
	.s SapceNum=$p(SapceNum,".")
	.f i=1:1:SampNum d
	..s Index=+$g(Index)+SapceNum
	..
	..i TempIndexList=""  s TempIndexList=Index
	..e  s TempIndexList=TempIndexList_","_Index
	.

	///医生固定数量抽样
	I SamWay=3 D
	.
   	
   	///删除不符合条件的数据
	S index=""
	f  S index=$o(^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","QueryOutPhCmtData",pid,index)) Q:index=""  D
	.q:..CheckStrIfExitVar(TempIndexList,index)
	.k ^TMP("DHCST","web.DHCSTCNTANTIBACTERIAL","QueryOutPhCmtData",pid,index)

	q ""
}

/// Descript:检查病人年龄是否包含在年龄范围之内
ClassMethod CheckAgeRange(rangeArg As %String, PatientID As %String) As %String
{
	N (rangeArg,PatientID)
	Q:rangeArg="" 0
	S patAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  //年龄
	Q:patAge'["岁" 1
	S fromAge=+$p(rangeArg,"-",1)
	S toAge=+$p(rangeArg,"-",2)
	Q:fromAge>toAge 1
	S patAge=+patAge
	Q:(fromAge>patAge)||(toAge<patAge) 1
	Q 0
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("STCNTANTIBACTERIAL"))
}

/// Descript:保存点评结果
/// W ##Class(web.DHCSTCNTANTIBACTERIAL).saveCommentRet("1","Y","则是测试ojk","194||9")
ClassMethod SaveCommentRet(userid As %String, resflag As %String, resdesc As %String, otherparam As %String) As %String
{
	n (userid,resflag,resdesc,otherparam)
	q:userid="" "-1^点评人员不能为空!"
	q:resflag="" "-2^点评结果不能为空!"
	q:resflag="" "-3^点评结果描述不能为空!"
	
	s pcntsi=$p(otherparam,"^",1)
	s main=$p(pcntsi,"||",1)
	s itm=$p(pcntsi,"||",2)
	s currdate=+$h
    s currtime=$p($h,",",2)
	ts
	
	s ret=..CancelCommentRes(pcntsi) /// 取消已经点评结果
	i ret'=0 tro
	q:ret'=0 ret
	
	&sql(update DHC_PHCOMMENTSITM set PCNTSI_CurrRet=:resflag where PCNTSI_RowID=:pcntsi)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 "-5^更新点评结果明细出错！"
	
	s grpno=##Class(web.DHCSTCNTSMAIN).GetLogGrpNo(main,itm)
	k PLIST
	s PLIST(0)=pcntsi
	s PLIST(2)=+$o(^DHCPHCNTS(main,"I",itm,"L",""),-1)+1
	s PLIST(4)=currdate
	s PLIST(5)=currtime
	s PLIST(6)=userid
	s PLIST(11)=resdesc
	s PLIST(10)=resflag
	s PLIST(13)="Y"
	s PLIST(14)=grpno
	&sql(INSERT INTO DHC_PHCOMMENTSLOG VALUES :PLIST())
	i SQLCODE'=0 tro
	q:SQLCODE'=0 "-6^保存点评结果日志出错！"
	tc
	q 0
}

/// Descript:撤销点评结果
ClassMethod CancelCommentRes(PcntItmID As %String) As %String
{
	n (PcntItmID)
	s main=$p(PcntItmID,"||",1)
	s itm=$p(PcntItmID,"||",2)
	s resflag=""
	&sql(update DHC_PHCOMMENTSITM set PCNTSI_CurrRet=:resflag where PCNTSI_RowID=:PcntItmID)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 "-4^更新点评结果明细出错！"
	
	s sub=""
	f  s sub=$o(^DHCPHCNTS(main,"I",itm,"L",sub),-1) q:sub=""  d
	.s active=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)
	.s $p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)="N"
	.
	q 0
}

/// Descript:获取点评结果
ClassMethod LoadPCommentRes(PcntItmID As %String) As %String
{
	n (PcntItmID)
	s ListTitle="ErrCode^ErrMsg^PcntCntRes^PcntResDesc"
	s pcntID=$p(PcntItmID,"||",1)
	s itm=$p(PcntItmID,"||",2)
	s PcntCntRes=$p(^DHCPHCNTS(pcntID,"I",itm),"^",6)
	s sub=+$o(^DHCPHCNTS(pcntID,"I",itm,"L",""),-1)
	s PcntResDesc=$p($g(^DHCPHCNTS(pcntID,"I",itm,"L",sub)),"^",9) ///点评结果描述
	s ListData="0^^"_PcntCntRes_"^"_PcntResDesc
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:获取点评单子项目
/// w ##Class(web.DHCSTCNTANTIBACTERIAL).getCommentItm("170||4","1")
ClassMethod getCommentItm(PcntItmID As %String, SortDir As %String) As %String
{
	n (PcntItmID,SortDir)
	s ListTitle="ErrCode^ErrMsg^EpisodeID^PcntItmID^PatName"
	s PcntID=$p(PcntItmID,"||",1)
	s CH=$p(PcntItmID,"||",2)
	s CH=CH+SortDir
	i CH<"1" d
	.w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,"-1^当前样例已经是第一个")
	q:CH<"1" ""
	s LastPcntID=$o(^DHCPHCNTS(PcntID,"I",""),-1)+1
	i CH=LastPcntID d
	.w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,"-2^当前样例已经是最后一个")
	q:CH=LastPcntID ""
	s PcntItmID=PcntID_"||"_CH
	s EpisodeID=$p(^DHCPHCNTS(PcntID,"I",CH),"^",3)
	s Papmi=$p(^PAADM(EpisodeID),"^",1)
	s PatName=$p(^PAPER(Papmi,"ALL"),"^", 1) //姓名
	s ListData="0^^"_EpisodeID_"^"_PcntItmID_"^"_PatName
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:删除点评单
ClassMethod DelCommentNo(PcntID As %String) As %String
{
	n (PcntID)
	&SQL(delete from DHC_PHCOMMENTS where PCNTS_RowID =:PcntID)
	Q SQLCODE
}

/// Descript:删除点评单结果明细
ClassMethod DelCommentDetail(pcntItmID As %String) As %String
{
	n (pcntItmID)
	&SQL(delete from DHC_PHCOMMENTSITM where PCNTSI_RowID =:pcntItmID)
	Q SQLCODE
}

/// Descript:系统任务(生成点评单)
ClassMethod CreateCommentNo(StatConParam As %String, SampConParam As %String) As %String
{
	n (StatConParam,SampConParam)
	s pid=..NewPid()
	d ..killTmpGlobal(pid)
	S StatConParam=$TR(StatConParam,"!","^")
	s AdmType=$p(StatConParam,"^",3) //类型
	s LocList=$p(StatConParam,"^",4) //科室
	s HospID=$p(StatConParam,"^",24)  //医院ID

	/// 1、统计抽样总数
	s StatMaxNum="0"
	i AdmType="I" d
	.s StatMaxNum=##class(web.DHCSTCNTANTIBACTERIAL).QueryInPhCmtData(pid,StatConParam)  	//在院
	
	i AdmType="D" d
	.s StatMaxNum=##class(web.DHCSTCNTANTIBACTERIAL).QueryDisInPhCmtData(pid,StatConParam)  //出院

	i ((AdmType="O")||(AdmType="E"))&(LocList'="") d
	.s StatMaxNum=##class(web.DHCSTCNTANTIBACTERIAL).QueryOutPhCmtData(pid,StatConParam) //门诊

	i ((AdmType="O")||(AdmType="E"))&(LocList="") d
	.s StatMaxNum=##class(web.DHCSTCNTANTIBACTERIAL).QueryOutPhCmtDataByDate(pid,StatConParam,HospID) //门诊

	q:StatMaxNum=0 ""

	/// 2、抽样
	s SampConparam=$TR(SampConParam,"!","^")
	s $p(SampConParam,"^",5)=StatMaxNum
	s UserID=$p(SampConParam,"^",6)   		//用户ID
	s CommentNotes=$p(SampConParam,"^",7)   //点平单抽样描述
	d ..SaveComment(pid,UserID,CommentNotes,SampConParam)
	q ""
}

/// Descript:保存系统任务
ClassMethod SaveSysTask(UserID, StatConParam, SampConParam) As %String
{
	n (UserID, StatConParam, SampConParam)
	S StatConParam=$TR(StatConParam,"^","!")
	S SampConParam=$TR(SampConParam,"^","!")
	k PLIST
	s PLIST(2)=+$h
	s PLIST(3)=$p($h,",",2)
	s PLIST(4)=UserID
	s PLIST(5)="##class(web.DHCSTCNTANTIBACTERIAL).CreateCommentNo("""_StatConParam_""","""_SampConParam_""")"
	s PLIST(6)="N"
	&sql(INSERT INTO DHC_PHSysTask VALUES :PLIST())
	q:SQLCODE'=0 -1
 	q 0
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
	..S tOperId=+$P(^OR(EpisodeID,"ANA",CH,"OP",Sub),"^",6)   ////bianshuai 2016-01-20 再次修改
	..//S tOperCode=$p(^ORC("OPER",tOperId),"^",1)   ///手术名称
 	..//S tOperDesc=$p(^ORC("OPER",tOperId),"^",2)   ///手术代码
 	..S tBldtpId=$p($g(^ORC("OPER",tOperId,"DHC")),"^",2)  ///手术名称对应切口类型
	..S BladeID=$P(^OR(EpisodeID,"ANA",CH,"OP",Sub),"^",9) ///手术申请单切口类型
	..i BladeID="" S BladeID=tBldtpId   ///申请单切口类型未填写的情况下取手术名称对应切口类型
	..Q:BladeID=""
	..S BladeType=$p(^ORC("BLDTP",BladeID),"^",1)  //切口类型
	..i ListData="" S ListData=BladeType
	..E  S ListData=ListData_","_BladeType
	Q ListData
}

/// Descript:抗菌药标志判断  1-存在，0-不存在
ClassMethod CheckIfExitAntDrug(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s quitflag=0
	s quer=""
    f  s quer=$o(^PAQUE1(0,"QUE1_PAADM_DR",EpisodeID,quer)) q:(quer="")||(quitflag=1)  d
    .s prescno=$p(^PAQUE1(quer),"^",14)
	.s ord=""
	.f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:(ord="")||(quitflag=1)  d
	..s itm=""
    ..f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:(itm="")||(quitflag=1)  d
    ...s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)       //医嘱 ARC_ItmMast ARCIM_RowId
	...s itmmastid=$p(arcimid,"||",1)
	...s itmmastver=$p(arcimid,"||",2)
	...
	...S inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
	...Q:inci=""  //医嘱名称
	...s rArcimPhcdfDr=$p(^ARCIM(itmmastid,itmmastver,1),"^",12) //指向PHC_DrgForm
 	...s rPhcDrgForm1=$p(rArcimPhcdfDr,"||",1)
 	...s rPhcDrgForm2=$p(rArcimPhcdfDr,"||",2)
 	...q:(rPhcDrgForm1="")&(rPhcDrgForm2="") 
 	...q:'$d(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2))
 	...q:'$d(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2,"DHC"))
 	...s AntibioticFlag=$p(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2,"DHC"),"^",8) //抗菌药标志
 	...s:AntibioticFlag="" AntibioticFlag="N"
    ...q:AntibioticFlag="N"
    ...s quitflag=1
    q quitflag
}

}
