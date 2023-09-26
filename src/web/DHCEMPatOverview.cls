/// Descript:   急诊病人概览
/// Creator:    yuliping
/// CreateDate: 2016-04-11
Class web.DHCEMPatOverview Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 获取病人分诊信息
/// Creator:     yuliping
/// CreateDate:  2017-10-11
/// Table: 		 DHC_EmPatCheckLev
/// Input:  	 rowid
/// Return： 	
/// w ##class(web.DHCEMPatOverview).getPatCheckLevInfo(1123,2)
ClassMethod getPatCheckLevInfo(EpisodeID, TypeMode)
{
		
	n (EpisodeID,TypeMode,%session)
	s pclRowid=""
	s:$d(^DHCEMPCA(0,"AdmChkLev",EpisodeID))>=10 pclRowid =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	s rtn=""
	q:pclRowid="" "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	s pcldata = ""
	s pcldata=..getPatFZMessageByPclID(pclRowid)	//分诊信息
	s SickHistory = "" 
	s SickHistory = ##class(web.DHCEMPatCheckLevQuery).GetEmPatChkLvHisDesc(pclRowid)   	//既往史
	s AisData="", EmPainLev="",GCSData=""
	i TypeMode=1 d
	.s AisData=..GetAisData(pclRowid)		//创伤评分
	.s EmPainLev=$p(^DHCEMPCL(pclRowid),"^",30) 	    						// 疼痛分级
	.s GCSData=+..GetGCSData(pclRowid) 		//格拉斯哥
	.i GCSData=0 s GCSData=""
	i TypeMode=2 d
	.s AisData=##class(web.DHCEMPatCheckLevQuery).GetAisData(pclRowid)		//创伤评分
	.s EmPainLev=$p(^DHCEMPCL(pclRowid),"^",30) 	    /// 疼痛分级
	.s EmPainRange=$p(^DHCEMPCL(pclRowid),"^",31) 	/// 疼痛范围
	.s EmPainRangeDesc=$s(EmPainRange="1":"中枢",EmPainRange="2":"外周",1:"")
	.s EmPainDate=$p(^DHCEMPCL(pclRowid),"^",32) 	/// 疼痛日期
	.s:EmPainDate'="" EmPainDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmPainDate) //$zd(EmPainDate,3)
	.s EmPainTime=$p(^DHCEMPCL(pclRowid),"^",33) 	/// 疼痛时间
	.s:EmPainTime'="" EmPainTime=$zt(EmPainTime,2)
	.s:EmPainDate'="" EmPainTime=EmPainDate_" "_EmPainTime
	.s EmPainLev="疼痛指数："_EmPainLev_"、疼痛范围："_EmPainRangeDesc_"、疼痛时间："_EmPainTime
	.s GCSData=##class(web.DHCEMPatCheckLevQuery).GetGCSData(pclRowid) 		//格拉斯哥
	
	s:GCSData<=4 GCSData=4
	s:(GCSData>4)&(GCSData<8) GCSData=3
	s:(GCSData>=8)&(GCSData<11) GCSData=2
	s:(GCSData>=11)&(GCSData<14) GCSData=1
	s:GCSData>=14 GCSData=0
	
	s EmtArea=$p(^DHCEMPCL(pclRowid),"^",7)     							// 去向
	;s EmtArea=$s(EmtArea=1:"红区",EmtArea=2:"红区",EmtArea=3:"黄区",EmtArea=4:"绿区",1:"")
	s EmtArea=$s(EmtArea=1:"红区",EmtArea=2:"橙区",EmtArea=3:"黄区",EmtArea=4:"绿区",EmtArea=5:"绿区",1:"") //hxy 2020-02-21
	s CreatorDr=$p(^DHCEMPCL(pclRowid),"^",3)     							// 分诊护士
	s CreatorDesc=""
	i CreatorDr'="" s CreatorDesc=$p($g(^SSU("SSUSR",CreatorDr)),"^",2) 
	s greenFlag="否"
	;i $d(^DHCEMPGR(0,"PatCheckLev",pclRowid)) s greenFlag="是"				//绿色通道
	s:##Class(web.DHCEMPatCheckLev).GetEmPatGreenFlag(pclRowid,"")=1 greenFlag="是" //绿色通道 hxy 2022-09-29
	
	s patTypeId= $o(^DHCEMPT(0,"Code","三无人员",""))						//三无人员
	s patType="否"
	i patTypeId=$p(^DHCEMPCL(pclRowid),"^",40)  s patType="是"
				
	s EmPatChkType="",EmPatChkDesc=""										//特殊人群
	s EmPatChkType=$p(^DHCEMPCL(pclRowid),"^",40)
	i EmPatChkType'="" s EmPatChkDesc=$p(^DHCEMPT(EmPatChkType),"^",1)
	
	s wardId="",wardDesc=""
	s wardId=$p(^PAADM(EpisodeID),"^",70)
	s:wardId'="" wardDesc=$p(^PAWARD(wardId),"^",2)
	s ScoreInfo = ##class(web.DHCEMPatCheckLevQuery).GetAutoScore(pclRowid)
	i AisData="" s AisData="--"
	i EmPainLev="" s EmPainLev="--"
	i GCSData="" s GCSData="--"
	S EmtArea=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp",EmtArea)
	S patType=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp",patType)
	S greenFlag=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp",greenFlag)
	S wardDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",wardDesc)
	S CreatorDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",CreatorDesc)
	
	s rtn=pcldata_"^"_SickHistory_"^"_AisData_"^"_EmPainLev_"^"_GCSData_"^"_EmtArea_"^"_CreatorDesc_"^"_greenFlag_"^"_patType_"^"_EmPatChkDesc_"^"_wardDesc_"^"_ScoreInfo
	
	
	q rtn
}

/// Descript: 获取病人诊断信息
/// Creator:     yuliping
/// CreateDate:  2017-10-11
/// Table: 		 
/// Input:  	 rowid
/// Return： 	
/// w ##class(web.DHCEMPatOverview).getDiagnosis(1151)
ClassMethod getDiagnosis(MRADMID)
{
	n (MRADMID)
	
	if MRADMID="" q ""
		
	Set RetStr="",NO=1
	k TempArr("FindDiagnos",$J)
	
	s defaultDiagnosTypeID=""

	Set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MRADMID)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s MRDiagnosTypeDesc=""
	.s MRDiagnosTypeDr=""
	.S MRdiagnosNoteDr=""
	.S MRdiagnosNoteDesc=""
	.s MRdiagnosNoteSubRowid=""
	.S SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
	.if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
	.Q:(defaultDiagnosTypeID'="")&&(MRDiagnosTypeDr'=defaultDiagnosTypeID)
	.I MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
	.S MRdiagnosNoteSubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",0))
	.I MRdiagnosNoteSubRowid'="" Set MRdiagnosNoteDesc=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",MRdiagnosNoteSubRowid))
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRCIDCode=obj.Data("MRDIAICDCodeDRCode")
	.S MRDiagnosDate=obj.Data("MRDIADate")
	.s MRdiagnosTime=obj.Data("MRDIATime")
	.I MRDiagnosDate'="" Set MRDiagnosDate=$zd(MRDiagnosDate,3)
	.I MRdiagnosTime'="" Set MRdiagnosTime=$zt(MRdiagnosTime,3)
	.s BillFlag3="" 
	.s BillFlag3=""
	.i CodeRowid'="" s BillFlag3=$P($g(^MRC("ID",+CodeRowid)),"^",15)
	.//Q:(ICDType'="1")&&(BillFlag3="Y")
	.s MRDesc=obj.Data("MRDIADesc")
	.if MRDesc'="" s MRDesc=MRDesc_"["_MRdiagnosNoteDesc_"]"
	.s DiagStat=""
	.s DiagStatDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",9)
	.s DiagnosLeavel=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",1) //取诊断级别
	.s DiagnosNumber=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",2) //取顺序号
	.s DIAOnsetDate=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",35) //取发病日期
	.s:DIAOnsetDate'="" DIAOnsetDate=$zd(DIAOnsetDate,3) //取发病日期
	.if DiagStatDr'="" s DiagStat=$p($g(^MRC("DSTAT",DiagStatDr)),"^",2)
	.if DiagnosNumber="" s DiagnosNumber=$g(^MR($P(Rowid,"||",1),"DIA",0))+1
	.s banlkSpace="" f i=1:1:(+DiagnosLeavel-1) s banlkSpace=banlkSpace_"&nbsp" ;根椐级别加空格
    .s Desc=banlkSpace_Desc
	
	.s TempArr("FindDiagnos",$j,DiagnosNumber,Rowid)=Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate
	d obj.Close()
	s rtn=""
	//按顺序输出设置
	s TempDia=""
	s DiagnosNumber=0  f  {
		s DiagnosNumber=$O(TempArr("FindDiagnos",$j,DiagnosNumber)) 
		Q:DiagnosNumber=""  d
		s Temprowid=0 f {
			s Temprowid=$O(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid))
			q:Temprowid=""
			s DiagnosDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",1)
			s DiagnosValue=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",2)
			s DiagnosCodeRowid=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",3)
			s DiagnosMRDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",4)
			s DiagnosICDCode=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",5)
			s DiagnosType=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",6)
			s DiagnosNote=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",7)
			s DiagnosDate=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",8)
			s DiagnosOnsetDate=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",13)
			s DiagnosLeavel=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",11)
			s DiagStat=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",10)
			i DiagnosDesc="" s DiagnosDesc=DiagnosMRDesc
			i rtn="" d
			.s rtn=DiagnosDesc_"^"_DiagnosValue_"^"_DiagnosCodeRowid_"^"_DiagnosMRDesc_"^"_DiagnosICDCode_"^"_DiagnosType_"^"_DiagnosDate_"^"_DiagnosOnsetDate_"^"_DiagStat_"^"_DiagnosLeavel
			e  d
			.s rtn=rtn_"!"_DiagnosDesc_"^"_DiagnosValue_"^"_DiagnosCodeRowid_"^"_DiagnosMRDesc_"^"_DiagnosICDCode_"^"_DiagnosType_"^"_DiagnosDate_"^"_DiagnosOnsetDate_"^"_DiagStat_"^"_DiagnosLeavel
		}

}
	
	q rtn
}

/// Descript: 获取病人基本信息
/// Creator:     yuliping
/// CreateDate:  2017-10-12
/// Table: 		 
/// Input:  	 rowid
/// Return： 	
/// w ##class(web.DHCEMPatOverview).GetEmRegPatInfo(6893)
ClassMethod GetEmRegPatInfo(EpisodeID As %String, UserCode = "") As %String
{
	n (EpisodeID,UserCode,%session)
	q:EpisodeID="" ""
	q:UserCode="" ""
	i EpisodeID'="" s PatientID=$P(^PAADM(EpisodeID),"^",1)
	
    ;i PatientID="" s PatientID=$o(^PAPERi("PAPMI_PatNo",EmPatNo,""))
    Q:PatientID="" ""
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	   /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	//s PatAge=##Class(web.DHCEMPatCheckLevCom).GetAge(PatientID)  /// 年龄
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID)  /// 年龄
	s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	i birthday'="" s birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) //$zd(birthday,3)
	s IdentNo=$p(^PAPER(PatientID,"ALL"),"^",9)         /// 身份证号 
	s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  /// 民族
	i nationdr'="" s nationdr=$p(^CT("NAT",nationdr),"^",2)
	s countrydr=$p(^PAPER(PatientID,"PER",1),"^",8) 	/// 国家
	s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	;s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	;s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s BillType=""
	s PAADMAdmReasonDR=$p(^PAADM(EpisodeID,1),"^",7)
	s:PAADMAdmReasonDR'="" BillType=$p(^PAC("ADMREA",PAADMAdmReasonDR),"^",2)
	s PatDiag=""
	//s EpisodeID=$o(^PAPERdr(PatientID,"ADM","E",""),-1)
	//i EpisodeID'="" s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID) //诊断
	s CardNoID=##class(web.DHCEMPatCheckLevQuery).GetPatCardNoID(PatientID)  		         /// 病人卡号ID
	s PatCardNo="",CardTypeID=0
	i CardNoID'="" D
	.s PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) 		 /// 卡号
	.s CardTypeID=$p($g(^DHCCARD("CF",CardNoID)),"^",16) 	 /// 卡类型
	s EmRegID=$o(^DOCEMREGi(0,"PAPMI",PatientID,""),-1) 	 /// 登记ID  显示最后一天登记记录
	s EmPCLvID="",EmRegDate="",EmRegTime="",NurseLevel=""
	
	i EmRegID'="" d
	.q:'$d(^DOCEMREG("EM",EmRegID))
	.s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,""),-1)  /// 分诊ID
	.i EmPCLvID'="" d
	..s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)    /// 护士分级
	.s EmRegDate=$p(^DOCEMREG("EM",EmRegID),"^",4)  /// 登记时间
	.s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate) //hxy $zd(EmRegDate,3)
	.s EmRegTime=$p(^DOCEMREG("EM",EmRegID),"^",7)  /// 登记时间
	.s:EmRegTime'="" EmRegTime=$zt(EmRegTime,2)
	s TSecretLevelDr=$p($g(^PAPER(PatientID,"DHC")),"^",30)		//病人密级
	s TSecretLevel=""
	s:TSecretLevelDr'="" TSecretLevel = $lg(^User.DHCSecretLevelD(TSecretLevelDr),3)
	S TSecretLevel=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCSecretLevel","Level_Desc","",TSecretLevel)
	s:TSecretLevelDr'="" TSecretLevel=TSecretLevel_"("_$lg(^User.DHCSecretLevelD(TSecretLevelDr),4)_")"  //密级显示简写：qqa 2018-03-01
	s EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(+$h) //$zd(+$h,3)
	
	
	s docDr=$p(^PAADM(EpisodeID),"^",9)				//医生
	s docDesc=""
	i docDr'="" s docDesc=$p(^CTPCP(docDr,1),"^",2) ;docDesc=$p($g(^SSU("SSUSR",docDr)),"^",2) //22
	
	s MRAdmID=$p(^PAADM(EpisodeID),"^",61)
	s MRHeight=""
	s:MRAdmID'="" MRHeight=$p(^MR(MRAdmID,"PRO",1),"^",27)
	
	;s nurseDr=$p(^PAADM(EpisodeID,2),"^",50)			//护士	
	;s nurseDesc=""
	;i nurseDr'="" s nurseDesc=$p(^CTPCP(nurseDr,1),"^",2) //22
	s nurseDesc = ##class(Nur.CommonInterface.Patient).getMainNurse(EpisodeID)   //qqa 2018-03-13 修复主管护士问题
	;w ##class(web.DHCSETIMAGE).
	s careDesc=""			//护理级别
	s carelevel=..getCarByAdm(EpisodeID)
	s careDesc=$case(carelevel,1:"二级护理",2:"一级护理",3:"特级护理",:"")
	s ActLevel=""
	;s ActLevel=..getMesLevType(EpisodeID) 
	;s ActLevel = $case(ActLevel,"":0,:$l(ActLevel,","))   //危急值
	s ActLevel =##class(web.DHCAntService).GetReportWarnNum(EpisodeID)       //基础平台方法 qqa 2018-03-30
	s specilCare=""
	s specilCare=##class(web.DHCSETIMAGE).IfOrddailyExistByConfig(EpisodeID,"CRITICALCARE")  //特级护理
	s:specilCare=1 specilCare="特级护理"
	s stayTime=""
	//s stayTime=..getPatKeepTime(EpisodeID)          //留观滞留时间
	s stayTime=##class(web.DHCEMInComUseMethod).GetObserTime(EpisodeID)          //留观滞留时间
	s:(stayTime<1)&&(stayTime>0) stayTime = "0"_stayTime
	s labrset=##Class(LabService.TSResult).GetSomeQtyInfoByAdmNo(EpisodeID) ///检验项目
	s LabItmNum1=$P(labrset,"^",1), LabItmNum2=$P(labrset,"^",2),LabItmNum3=$P(labrset,"^",3)
	s labrset=##Class(web.DHCEMPatCurStatus).QueryExaReqDetListNum(EpisodeID,UserCode)  ///检查项目
	s SalvageDate=##class(web.DHCEMPatOverview).GetRescueStayTime(EpisodeID)
	
	S nationdr=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTNation","CTNATDesc","",nationdr)
	S PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	S BillType=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACAdmReason","READesc","",BillType)
	S docDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",docDesc)
	S nurseDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",nurseDesc)
	
	s ChkItmNum1=$P(labrset,"^",1), ChkItmNum2=$P(labrset,"^",2),ChkItmNum3=$P(labrset,"^",3)
	s ListData=EmRegID_"^"_EmRegDate_"^"_EmRegTime_"^"_PatientID_"^"_PatCardNo_"^"_CardNoID_"^"_PatNo_"^"_PatName_"^"_sexId_"^"_PatSex_"^"_PatDiag
	s ListData=ListData_"^"_PatAge_"^"_nationdr_"^"_countrydr_"^"_birthday_"^"_IdentNo_"^"_PatTelH_"^"_Address_"^"_BillType_"^"_EmPCLvID_"^"_NurseLevel_"^"_CardTypeID_"^"_TSecretLevel_"^"_docDesc_"^"_nurseDesc_"^"_careDesc_"^"_ActLevel_"^"_specilCare_"^"_stayTime
	s ListData=ListData_"^"_LabItmNum1_"^"_LabItmNum2_"^"_LabItmNum3_"^"_ChkItmNum1_"^"_ChkItmNum2_"^"_ChkItmNum3_"^"_MRHeight
	s ListData=ListData_"^"_SalvageDate

	q ListData
}

/// Descript:    抢救时间
/// Creator:     qqa
/// CreateDate:  2020-7-15	
/// w ##class(web.DHCEMPatOverview).GetRescueStayTime(228)
ClassMethod GetRescueStayTime(EpisodeID As %String) As %String
{
	n (EpisodeID,%session)
	Q:EpisodeID="" ""
	s dd=##class(web.DHCEMCommonUtil).GetTrans("","天")
	s hh=##class(web.DHCEMCommonUtil).GetTrans("","小时")
	s mm=##class(web.DHCEMCommonUtil).GetTrans("","分钟")
	s Ret=""
	s ThisLimitDate=0,ThisLimitTime=0
	s SalvageStDate="",SalvageStTime="",SalvageEndDate="",SalvageEndTime=""
	s AVSRowId=0
	f  s AVSRowId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,AVSRowId)) q:AVSRowId=""  d
	.s AVSStatusID=$p($g(^DHCADMVisitStatus(AVSRowId)),"^",2)
	.s PatVisitStat=$p(^DHCPACVisitStatus(AVSStatusID),"^",2)
	.s:PatVisitStat="抢救" SalvageStDate=$p(^DHCADMVisitStatus(AVSRowId),"^",5),SalvageStTime=$p(^DHCADMVisitStatus(AVSRowId),"^",6)
	.i ((PatVisitStat["死亡")||(PatVisitStat="抢救脱危")||(PatVisitStat="离院")||(PatVisitStat="留观")) d
	..q:SalvageStDate=""
	..s SalvageEndDate=$p(^DHCADMVisitStatus(AVSRowId),"^",5),SalvageEndTime=$p(^DHCADMVisitStatus(AVSRowId),"^",6)
	..s ThisLimitDate=ThisLimitDate+(SalvageEndDate-SalvageStDate)
	..s ThisLimitTime=ThisLimitTime+(SalvageEndTime-SalvageStTime)
	..s SalvageStDate="",SalvageStTime="",SalvageEndDate="",SalvageEndTime=""
	
	i (SalvageStDate'="")&&(SalvageEndDate="") d
	.s SalvageEndDate=+$h,SalvageEndTime=$p($h,",",2)
	.s ThisLimitDate=ThisLimitDate+(SalvageEndDate-SalvageStDate)
	.s ThisLimitTime=ThisLimitTime+(SalvageEndTime-SalvageStTime)
	s LimitMin=(ThisLimitDate*24*60)+(ThisLimitTime\60)
	s LimitHours = LimitMin\60
	s:LimitHours<24 Ret=(LimitMin\60)_hh_(LimitMin#60)_mm
	s:LimitHours'<24 Ret=(LimitHours\24)_dd_(LimitHours#24)_hh_(LimitMin#60)_mm
	q Ret
}

/// Descript: 保存病人基本信息
/// Creator:     yuliping
/// CreateDate:  2017-10-12
/// Table: 		 
/// Input:  	 rowid
/// Return： 	
/// w ##class(web.DHCEMPatOverview).savePatInfo("601^0000000601^lc041102^^2^1990-04-11^1^汉族^13112345678^威海市^47053^0017041102^27岁")
ClassMethod savePatInfo(PatListData As %String)
{
	n (PatListData)
	
	s PatientID = $p(PatListData,"^",1)  /// 病人ID
	
	s PatNo = $p(PatListData,"^",2)      /// 登记号
	s PatName = $p(PatListData,"^",3)    /// 姓名
	s IdentNo = $p(PatListData,"^",4)    /// 身份证
	s PatSexID = $p(PatListData,"^",5)   /// 性别
	i PatSexID = "" s PatSexID = "3"
	s PatDob = $p(PatListData,"^",6)     /// 出生日期
	s:PatDob'="" PatDob=##class(web.DHCEMCommonUtil).DateHtmlToLogical(PatDob) //hxy $zdh(PatDob,3)
	
	s CountryID = $p(PatListData,"^",7)  /// 国籍
	i CountryID = "" s CountryID = "1"
	s NationID = $p(PatListData,"^",8)   /// 民族
	s TelHNo = $p(PatListData,"^",9)     /// 联系电话
	s Address = $p(PatListData,"^",10)   /// 家庭地址
	s age= $p(PatListData,"^",11)
	s userID=$p(PatListData,"^",12)
	s patVOObj=##class(web.DHCEntity.PCA.PATMAS).%New()
	s patVOObj.Address=Address
	s patVOObj.Birth=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatDob) //hxy $zd(PatDob,4)
	
	s BirthTime=##Class(web.DHCEMPatCheckLev).CalBirthTime(PatDob,age)
	s patVOObj.BirthTime=BirthTime
	s patVOObj.Sex=PatSexID
	s patVOObj.Name=PatName
	s patVOObj.UpdateDate=+$h
	s patVOObj.UpdateTime=$p($h,",",2)
	s patVOObj.PatType=$o(^CT("SS",0))
	s patVOObj.PAPMIRowID=PatientID
	s patVOObj.NationDescLookUpRowID=NationID
	s patVOObj.CountryDescLookUpRowID=CountryID
	s patVOObj.CredNo=IdentNo
	//s patVOObj.IDCardNo1=IdentNo
	s patVOObj.CredType=1
	s patVOObj.TelHome=TelHNo
	s patVOObj.UserDR=userID
	i +PatientID'=0 d
	.s patVOObj.PatType=$p(^PAPER(PatientID,"PER",1),"^",10)
	.s patVOObj.EMail=$p($g(^PAPER(PatientID,"PER",4)),"^",19)
	.s patVOObj.EmployeeNo=$p($g(^PAPER(PatientID,"EMP")),"^",5)
	.s patVOObj.ForeignPhone=$p($g(^PAPER(PatientID,"ALL")),"^",4)
	.s patVOObj.ForeignName=$p($g(^PAPER(PatientID,"PER",2)),"^",13)
	.s patVOObj.Company=$p($g(^PAPER(PatientID,"PER",4)),"^",18)
	.s patVOObj.PatYBCode=$p($g(^PAPER(PatientID,"ALL")),"^",19)
	.s patVOObj.Allergy=$g(^PAPER(PatientID,"ALLERGY",1))
	.s oldType=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	.i (+IdentNo=0)&&(oldType'=1) d
	..s patVOObj.CredNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	..s patVOObj.CredType=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	s rtn=##class(web.DHCBL.CARD.UCardPaPatMasInfo).SavePatInfo(patVOObj)
	s err=$p(rtn,"^",1)
	s ret=$p(rtn,"^",2)
	q:err'=0 -11 
	q rtn
}

/// Descript: 获取病人危急值
/// Creator:     yuliping
/// CreateDate:  2017-10-26
/// Table: 		 
/// Input:  	 EpisodeID
/// Return： 	
/// w ##class(web.DHCEMPatOverview).getMesLevType(1135)
ClassMethod getMesLevType(EpisodeID As %String)
{
	n (EpisodeID)
	q:+EpisodeID=0 ""
	s EpisodeID=" "_EpisodeID
	s ActionLevelTypeDesc=""
	s message=""
	f  s message=$o(^websys.DHCMessageContentI("TypeOrderObj",1,EpisodeID,message)) q:message=""  d
	.q:+message=""
	.s mesid=""
	.f  s mesid=$o(^websys.DHCMessageContentI("TypeOrderObj",1,EpisodeID,message,mesid)) q:mesid=""  d
	..s details=$g(^websys.DHCMessageDetailsD(mesid))
	..q:details=""
	..s ContentDr = $listget(details,2)
	..s content = ^websys.DHCMessageContentD(ContentDr)
	..s ActionDr = $lg(content ,2)
	..s action = ^websys.DHCMessageActionTypeD(ActionDr)
	..s ActionLevelType = $lg(action,5)
	..i ActionLevelTypeDesc="" s ActionLevelTypeDesc=$case(ActionLevelType,"D":"紧急","I":"重要","V":"非常重要",:"一般")
	..e  d
	...s ActionLevelTypeDesc =ActionLevelTypeDesc_","_$case(ActionLevelType,"D":"紧急","I":"重要","V":"非常重要",:"一般")
	
	q ActionLevelTypeDesc
}

ClassMethod getPatFZMessageByPclID(PCLRowID)
{
	Q:PCLRowID="" ""
	s FzData=""
	s PCLNurseLevel=$p(^DHCEMPCL(PCLRowID),"^",7)  //护士分级
    s admDate=$p(^DHCEMPCL(PCLRowID),"^",4)        //分诊日期
    s admDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(admDate) //$zd(admDate,3)
    s admTime=$p(^DHCEMPCL(PCLRowID),"^",5)        //分诊时间
    s admTime=$zt(admTime,1)

	s PCLAdmDr=$p(^DHCEMPCL(PCLRowID),"^",37)
	;s MRDiagnos=""
	;i PCLAdmDr'="" d
	.;s MRDiagnos=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(PCLAdmDr) //诊断(入参：就诊号) 
	s symptom=""
	s symptom=$p(^DHCEMPCL(PCLRowID),"^",25)        //症状   
    s symptom=##class(web.DHCEMRegister).TrNumto(symptom,"")
    s symptom=$tr(symptom,"!","")
    s symptom=$tr(symptom,"#",",")
    s PCLOther=$p(^DHCEMPCL(PCLRowID),"^",36)       //其他 2016-09-13 congyue
    s symptom=symptom_" "_PCLOther 					//其他 2016-09-13 congyue
    s FzData=FzData_PCLNurseLevel_"^"_admDate_"^"_admTime_"^"_symptom_"^"_""
	s PCSRowID="",PCSTime="",PCSHeart="",PCSPCSPulse="",PCSSBP=""
	s PCSRowID=$o(^DHCEMPCS(0,"PatCheckLev",PCLRowID,PCSRowID))
	s PCLAdmWay="",PCLAdmWayDr="",PCLPatAskFlag=""
	s PCLAdmWayDr=$p(^DHCEMPCL(PCLRowID),"^",16) 
 	i PCLAdmWayDr'="" d
 	.s PCLAdmWay=$p(^DHCEMPADW(PCLAdmWayDr),"^",2)  //来诊方式
 	s PCLPatAskFlag=$p(^DHCEMPCL(PCLRowID),"^",35)  //是否假条
 	s EmAware=$p(^DHCEMPCL(PCLRowID),"^",17) 	    /// 意识状态 2016-09-21 congyue
	i +EmAware'=0 s EmAware=$p(^DHCEMPAW(EmAware),"^",2)
 	s FzData=FzData_"^"_PCLPatAskFlag_"^"_PCLAdmWay_"^"_PCLAdmWayDr_"^"_EmAware_"^"_PCLRowID
 	s (PCSTemp,PCSHeart,PCSPCSPulse,PCSBP,PCSR)=""    	
	i (PCSRowID'="")  d
 	.s PCSTime=$p(^DHCEMPCS(PCSRowID),"^",2)
 	.s PCSTime=$zt(PCSTime,1)
 	.s PCSTemp=$p(^DHCEMPCS(PCSRowID),"^",3)        //体温T 2016-09-03 congyue
 	.s PCSHeart=$p(^DHCEMPCS(PCSRowID),"^",4)
 	.s PCSPCSPulse=$p(^DHCEMPCS(PCSRowID),"^",5)
 	.s PCSDBP=$p(^DHCEMPCS(PCSRowID),"^",7)         // 2016-09-03 congyue
 	.s PCSSBP=$p(^DHCEMPCS(PCSRowID),"^",6)
 	.s PCSBP=PCSSBP_"/"_PCSDBP //BP 2016-09-03 congyue
 	.s PCSSOP=$p(^DHCEMPCS(PCSRowID),"^",8)
 	.s:(PCSSOP>0)&&(PCSSOP<1) PCSSOP = "0"_PCSSOP
 	.s PCSR = $p(^DHCEMPCS(PCSRowID),"^",9)
    s FzData=FzData_"^"_PCSTemp_"^"_PCSHeart_"^"_PCSPCSPulse_"^"_PCSBP_":"_PCSR
    
    s EmRecLevel=$p(^DHCEMPCL(PCLRowID),"^",6)  /// 推荐分级
	s NurseLevel=$p(^DHCEMPCL(PCLRowID),"^",7)  /// 护士分级
    s pcLLocDr=$p(^DHCEMPCL(PCLRowID),"^",10)      //分诊科室  liyarong
    s PCLSouDr=$p(^DHCEMPCL(PCLRowID),"^",15)      //病人来源  liyarong
    s FzData=FzData_"^"_PCSSOP_"^"_NurseLevel_"^"_pcLLocDr_"^"_PCLSouDr_"^"_PCSTime  //liyarong
    q FzData
}

// 创伤评分

ClassMethod GetAisData(EmPCLvID)
{
	
	S PCAId="",AisDataStr="",AddScore=0,PCAAISIDr=""
	F  S PCAId=$o(^DHCEMPCAI(0,"CHECKLEV",EmPCLvID,PCAId))  Q:PCAId=""  D
	.S PCAAISIDr=$P($G(^DHCEMPCAI(PCAId)),"^",3)
	.Q:PCAAISIDr=""
	.S DHCEMAISDesc=""
	.S DHCEMAISDesc=$p($g(^DHCEMAIS($p(PCAAISIDr,"||",1))),"^",2)
	.Q:DHCEMAISDesc=""
	.S DHCEMAISSubScore=""
	.S DHCEMAISSubScore=$p(^DHCEMAIS($p(PCAAISIDr,"||",1),$p(PCAAISIDr,"||",2)),"^",5)
	.S AisDataStr=AisDataStr_DHCEMAISDesc_":("_DHCEMAISSubScore_"分)"_","
	.S AddScore=AddScore+DHCEMAISSubScore
	i (PCAAISIDr'="") d
	.S AisDataStr=AddScore
	Q AisDataStr
}

ClassMethod GetGCSData(EmPCLvID)
{
	S PCGId="",dStr=""
    F  S PCGId=$o(^DHCEMPCG(0,"ChkDr",EmPCLvID,PCGId))  Q:PCGId=""  D
    .S PCAGCSIDr=$P($G(^DHCEMPCG(PCGId)),"^",3)
	.Q:PCAGCSIDr=""
	.S DHCEMGCSDesc=""
	.S DHCEMGCSDesc=$p($g(^DHCEMGCS($p(PCAGCSIDr,"||",1))),"^",2)
	.Q:DHCEMGCSDesc=""
	.s DHCEMGCSIDesc=""
	.S DHCEMGCSIDesc=$p($g(^DHCEMGCS($p(PCAGCSIDr,"||",1),"I",$p(PCAGCSIDr,"||",2))),"^",3)
	.S DHCEMGCSSubScore=""
	.S DHCEMGCSSubScore=$p($g(^DHCEMGCS($p(PCAGCSIDr,"||",1),"I",$p(PCAGCSIDr,"||",2))),"^",5)
	.S dStr=dStr+DHCEMGCSSubScore
	s dStr=dStr
	Q dStr
}

/// Descript: 获取病人特殊护理
/// Creator:     yuliping
/// CreateDate:  2017-11-22
/// Table: 		
/// Input:  	 rowid
/// Return： 
/// w ##class(web.DHCEMPatOverview).getSpecilCarByAdm(1135)
ClassMethod getSpecilCarByAdm(admId)
{
	n (admId)
	s arcimdesc="",execCtcpDesc=""
	s ord=0
	f  s ord=$o(^OEORD(0,"Adm",admId,ord)) q:ord=""  d
	.s itm=""
	.f  s itm=$o(^OEORD(ord,"I",itm)) q:itm=""  d
	..s sub=0
	..f  s sub=$o(^OEORD(ord,"I",itm,"X",sub))  q:sub=""  d //执行记录id
	...
	...s seqNo=$p($g(^OEORD(ord,"I",itm,11)),"^",39)
	...s:seqNo="" seqNo=ord_"||"_itm
	...s execStatusId=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",16) //执行状态
	...s execStatusCode=""
    ...i $g(execStatusId)'="" s execStatusCode=$p($g(^OEC("STAT",execStatusId)),"^",1) 
    ...;q:execStatusCode="F"			//执行状态				
	...s arcimdesc=##class(web.DHCEMOrdInfoVO).getArcimDesc(ord,itm)
    ...;q:(arcimdesc'["特殊疾病")
    ...q:(arcimdesc'["特级护理")
    ...
    ...s execCTPCP=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",15)
    ...s:execCTPCP'="" execCtcpDesc=$p($g(^CTPCP(execCTPCP,1)),"^",2)	//执行科室描述
    ...;q:((arcimdesc'["阿司")&&(arcimdesc'["肠溶"))
   	...;w arcimdesc_"^"_execCtcpDesc
    q execCtcpDesc
}

/// Descript: 获取病人护理级别
/// Creator:     yuliping
/// CreateDate:  2017-11-22
/// Return： 
/// w ##class(web.DHCEMPatOverview).getCarByAdm(1383)
ClassMethod getCarByAdm(admId)
{
	n (admId)
	/*
	s rtn=0,flag=0
	s ord=0
	f  s ord=$o(^OEORD(0,"Adm",admId,ord)) q:ord=""  d
	.s itm=""
	.f  s itm=$o(^OEORD(ord,"I",itm)) q:itm=""  d
	..s arcimdesc=##class(web.DHCEMOrdInfoVO).getArcimDesc(ord,itm)
	..i arcimdesc["二级护理" s flag=1
	..i arcimdesc["一级护理" s flag=2
	..i arcimdesc["特级护理" s flag=3
	..i flag>rtn s rtn=flag
	*/
	s Ret=""
	s Flag = ##class(web.DHCSETIMAGE).IfOrddailyExistByConfig(admId,"FIRSTCLSCARE")
	s:Flag=1 Ret=1  
	s Flag = ##class(web.DHCSETIMAGE).IfOrddailyExistByConfig(admId,"SECONDCLSCARE")
	s:Flag=1 Ret=2
	s Flag = ##class(web.DHCSETIMAGE).IfOrddailyExistByConfig(admId,"THIRDCLSCARE")
	s:Flag=1 Ret=3
	q Ret
}

/// w ##class(web.DHCEMPatOverview).getPatKeepTime(7053)
ClassMethod getPatKeepTime(Adm)
{
	n (Adm)
	q:Adm="" ""
	s ObsAllDate=""
	s ObsDate = ..GetFirstInSeatDate(Adm)
	q:+ObsDate=0 ""       //对于没有安排到留观室的病人没有留观抢救时间
	s ObsStDate = +ObsDate
	s ObsStTime = $p(ObsDate,"^",2)
	s ObsEndDate = +$h
	s ObsEndTime = $p($h,",",2)
	s ObsAllDate=(ObsEndDate-ObsStDate*24)+(ObsEndTime-ObsStTime\(60*60))
	i ObsAllDate<24 d
	.s ObsAllDate = ObsAllDate_"小时"
	e  d
	.s ObsAllDate = ObsAllDate\24_"天"
	q ObsAllDate
}

/// Descript: 获取病人留观滞留时间
/// Creator:     yuliping
/// CreateDate:  2017-11-22
/// Return： 
/// w ##class(web.DHCEMPatOverview).getPatKeepTime(6067)
ClassMethod GetFirstInSeatDate(Adm)
{
	n (Adm)
	s ObsStDate="",ObsStTime=""
	s AdmTransSub=0 
	f  s AdmTransSub = $o(^PAADM(Adm,"TRANS",AdmTransSub)) q:(AdmTransSub="")!(ObsStDate'="")  d
	.q:$p(^PAADM(Adm,"TRANS",AdmTransSub),"^",8)=""
	.s ObsStDate=$p(^PAADM(Adm,"TRANS",AdmTransSub),"^",1)
	.s ObsStTime = $p(^PAADM(Adm,"TRANS",AdmTransSub),"^",2)
	q ObsStDate_"^"_ObsStTime
}

ClassMethod getPatKeepTime1(EpisodeID)
{
	n (EpisodeID)
	s PCLRowID="",rtnStr="",days=0,hour=0,hours=""
	s:$d(^DHCEMPCA(0,"AdmChkLev",EpisodeID))>=10 PCLRowID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	q:PCLRowID="" ""
	s admDate=$p(^DHCEMPCL(PCLRowID),"^",4)        //分诊日期
    s admTime=$p(^DHCEMPCL(PCLRowID),"^",5)        //分诊时间
    
	s stayDate="",stayTime=""
	s Dadvid=0
	f  s Dadvid = $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,Dadvid)) q:Dadvid=""  d  //首次留观时间
    .s DadvStu=$p(^DHCADMVisitStatus(Dadvid),"^",2)
    .;q:(DadvStu'="5")&&(DadvStu'=10)   //10为抢救 5为留观
    .q:DadvStu'="5"
   	.s stayDate=$p(^DHCADMVisitStatus(Dadvid),"^",5)
    .s stayTime=$p(^DHCADMVisitStatus(Dadvid),"^",6) 
   	.q:+stayDate=0    //没有留观过直接Q
   	.s days=(stayDate-admDate)*24
   	.s hour=$j((stayTime-admTime)/3600,2,2)
   	.s hours=days+hour
   	
	s minute=""
	i hours'="" s minute=$p(hours,".",2)
	i +minute'=0 d
	.s minute=$j(minute*0.6,1,0)
	.s rtnStr=$p(hours,".",1)_"小时"_minute_"分钟"
	
	q rtnStr
}

/// Descript:    留观时间
/// Creator:     bianshuai
/// CreateDate:  2018-06-20	
/// w ##class(web.DHCEMPatOverview).GetObserTime(608)
ClassMethod GetObserTime(EpisodeID As %String) As %String
{
	n (EpisodeID)
	Q:EpisodeID="" ""
	s StayFlag=0
	///留观日期时间
	s stayDate="",stayTime="",Dadvid=""
	s Dadvid=0
	F  s Dadvid = $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,Dadvid)) Q:Dadvid=""!+StayFlag'=0  D  //首次留观时间
    .s DadvStu=$p(^DHCADMVisitStatus(Dadvid),"^",2)
    .Q:(DadvStu'="5")&&(DadvStu'="10")
    .s StayFlag=1
   	Q:+StayFlag=0 ""    //没有留观过直接Q
   	
   	s stayDateInfo = ##class(web.DHCEMInComUseMethod).GetFirstInSeatDate(EpisodeID)
   	s stayDate=$p(stayDateInfo,"^",1)
    s stayTime=$p(stayDateInfo,"^",2) 
   	q:stayDate="" ""
   	
   	///离院日期时间
	s GoDate="",GoTime="",Dadvid=""     //取最后一次离院时间
	s Dadvid=""
	s Dadvid =$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,Dadvid),-1)
	Q:Dadvid="" ""
    s DadvStu=$p(^DHCADMVisitStatus(Dadvid),"^",2)
    i DadvStu=6 D
    .s GoDate=$p(^DHCADMVisitStatus(Dadvid),"^",5)  //离院时间
    .s GoTime=$p(^DHCADMVisitStatus(Dadvid),"^",6)
    
   	i GoDate="" d
    .s Hours=(+$h-stayDate)*24+$j(($p($h,",",2)-stayTime)/3600,2,2)
    e  d
    .s Hours=(GoDate-stayDate)*24+$j((GoTime-stayTime)/3600,2,2)
    Q Hours_"小时"
}

/// Descript: 获取病人诊断信息 json
/// Creator:     yuliping
/// CreateDate:  2017-10-11
/// Table: 		 
/// Input:  	 rowid
/// Return： 	
/// w ##class(web.DHCEMPatOverview).getDiagnosisJson(1151)
ClassMethod getDiagnosisJson(MRADMID)
{
	
	n (MRADMID,%session)
	
	i MRADMID="" w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	q:MRADMID="" ""
			
	Set RetStr="",NO=1
	k TempArr("FindDiagnos",$J)
	
	s defaultDiagnosTypeID=""

	s MRAdmRowid=$p(^PAADM(MRADMID),"^",61)   ///修改 bianshuai 2017-12-22
	s ADMNo=$p(^PAADM(MRADMID),"^",81) 
	
    Q:MRAdmRowid="" ""
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
 	d obj.Execute(MRAdmRowid)
 	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s MRDiagnosTypeDesc=""
	.s MRDiagnosTypeDr=""
	.S MRdiagnosNoteDr=""
	.S MRdiagnosNoteDesc=""
	.s MRdiagnosNoteSubRowid=""
	.S SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
	.s DiagnosPrefix=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",26)
	.if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
	.Q:(defaultDiagnosTypeID'="")&&(MRDiagnosTypeDr'=defaultDiagnosTypeID)
	.I MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
	.S MRdiagnosNoteSubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",0))
	.I MRdiagnosNoteSubRowid'="" Set MRdiagnosNoteDesc=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",MRdiagnosNoteSubRowid))
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRCIDCode=obj.Data("MRDIAICDCodeDRCode")
	.S MRDiagnosDate=obj.Data("MRDIADate")
	.s MRdiagnosTime=obj.Data("MRDIATime")
	.I MRDiagnosDate'="" Set MRDiagnosDate=$zd(MRDiagnosDate,3)
	.I MRdiagnosTime'="" Set MRdiagnosTime=$zt(MRdiagnosTime,3)
	.s BillFlag3="" 
	.s BillFlag3=""
	.i CodeRowid'="" s BillFlag3=$P($g(^MRC("ID",+CodeRowid)),"^",15)
	.//Q:(ICDType'="1")&&(BillFlag3="Y")
	.s MRDesc=obj.Data("MRDIADesc")
	.if MRDesc'="" s MRDesc=MRdiagnosNoteDesc
	.s DiagStat=""
	.s DiagStatDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",9)
	.s DiagnosLeavel=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",1) //取诊断级别
	.s DiagnosNumber=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",2) //取顺序号
	.s DIAOnsetDate=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",35) //取发病日期
	.s:DIAOnsetDate'="" DIAOnsetDate=$zd(DIAOnsetDate,3) //取发病日期
	.if DiagStatDr'="" s DiagStat=$p($g(^MRC("DSTAT",DiagStatDr)),"^",2)
	.if DiagnosNumber="" s DiagnosNumber=$g(^MR($P(Rowid,"||",1),"DIA",0))+1
	.s banlkSpace="" f i=1:1:(+DiagnosLeavel-1) s banlkSpace=banlkSpace_"&nbsp" ;根椐级别加空格
    .s Desc=banlkSpace_Desc
    .s SDSInfo=##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetStructDiagnos(ADMNo,Rowid)
    .s SDSDesc=$P(SDSInfo,"^",4)
	.s TempArr("FindDiagnos",$j,DiagnosNumber,Rowid)=Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate_"^"_DiagnosPrefix_"^"_SDSDesc
	d obj.Close()
	s rtn=""
	//按顺序输出设置
	s TempDia=""
	s count=0
	w "{""rows"":["
	s DiagnosNumber=0  f  {
		s DiagnosNumber=$O(TempArr("FindDiagnos",$j,DiagnosNumber)) 
		Q:DiagnosNumber=""  d
		s Temprowid=0 f {
			s Temprowid=$O(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid))
			q:Temprowid=""
			s DiagnosDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",1)
			s DiagnosValue=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",2)
			s DiagnosCodeRowid=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",3)
			s DiagnosMRDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",4)
			s DiagnosICDCode=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",5)
			s DiagnosType=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",6)
			s DiagnosNote=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",7)
			s DiagnosDate=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",8)
			s DiagnosOnsetDate=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",13)
			s DiagnosLeavel=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",11)
			s DiagStat=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",10)
			s DiagnosPrefix=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",14)
			s SDSDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",15)
			;s:DiagnosMRDesc'="" DiagnosDesc=DiagnosDesc_"["_DiagnosMRDesc_"]"
			s:DiagnosDesc'="" DiagnosDesc=$replace(DiagnosDesc,"&nbsp","")
			S DiagnosDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.MRCICDDx","MRCIDDesc","",DiagnosDesc)
			S DiagnosMRDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.MRCICDDx","MRCIDDesc","",DiagnosMRDesc)
			S SDSDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.MKBTerm","MKBTDesc","",SDSDesc)
			S DiagnosType=##class(web.DHCEMCommonUtil).GetTransDesc("User.MRCDiagnosType","DTYPDesc","",DiagnosType)
			s DiagnosDesc=DiagnosPrefix_DiagnosDesc_DiagnosMRDesc
			s tmp=DiagnosType_"^"_DiagnosDesc_"^"_SDSDesc
			s count=count+1
			i count=1 w ##class(web.DHCAPPJsonCommon).getJsonData("DiagType^DiagDesc^SDSDesc",tmp)
			i count>1 d
			.w ","
			.w ##class(web.DHCAPPJsonCommon).getJsonData("DiagType^DiagDesc^SDSDesc",tmp)
			

		}
		
}
	w "],""total"":"_count_"}"
	q ""
}

/// Descript: 获取病人生命体征 json
/// Creator:     yuliping
/// CreateDate:  2017-11-23
/// Table: 		 
/// Input:  	 rowid
/// Return： 	
/// w ##class(web.DHCEMPatOverview).getVSJson(655)
ClassMethod getVSJson(EpisodeID)
{
	n (EpisodeID,%session)

	s PCLRowID=""
	s PCLRowID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	s SignInfo = ##class(web.DHCEMPatCheckLevQuery).GetEmPatChkSignItm(PCLRowID)
	s PCSTemp = $p(SignInfo,"@",2)       //体温
	s PCSHeart = $p(SignInfo,"@",3)		 //心率HR
	s PCSPCSPulse = $p(SignInfo,"@",4)	 //脉搏R
	s PCSBP =$p(SignInfo,"@",5)      //血压(BP)收缩压
	s PCSDBP = $p(SignInfo,"@",6)
	s PcsSoP2=$p(SignInfo,"@",7)   /// 血氧饱合度
	s PCSR = $p(SignInfo,"@",8)         //呼吸频率
	s PCSGlu = $p(SignInfo,"@",9)
	
	
	s TmpData=PCSTemp_"^"_PCSHeart_"^"_PCSPCSPulse_"^"_PCSBP_"^"_PCSDBP_"^"_PCSR_"^"_PcsSoP2_"^"_PCSGlu
	s TranUnit=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp","次/分")
	s TmpUnit="℃^"_TranUnit_"^"_TranUnit_"^mmHg^mmHg^"_TranUnit_"^mmol/l"
	;s TmpUnit="℃^次/分^次/分^mmHg^mmHg^次/分^%^mmol/l"
	s TmpTitle = "PCSTemp^PCSHeart^PCSPCSPulse^PCSBP^PCSDBP^PCSR^PCSSOP^PCSGlu"
	w "{""rows"":["
	w ##class(web.DHCAPPJsonCommon).getJsonData(TmpTitle,TmpData)
	w ","
	w ##class(web.DHCAPPJsonCommon).getJsonData(TmpTitle,TmpUnit)

	w "],""total"":""2""}"
	
	q ""
}

/// 2023-03-03 22库方法
/// w ##class(web.DHCEMPatOverview).listOrdData(655)
ClassMethod listOrdData(admId)
{
	n (admId)
	
	s itemTitle="id^stDateTime^arcimDesc^openOrdDoctor^itemStatDesc^ordDept^recDep"
	s itemTitle=itemTitle_"^doseQtyUnit^phcinDesc^durat^phcfrCode"
	s count=0
	w "{""rows"":["
	s ord=0
	f {
		s ord=$o(^OEORD(0,"Adm",admId,ord))
		q:ord=""
		s itm=0
		f {
			s itm=$o(^OEORD(ord,"I",itm))	
			q:itm=""
			s str1=^OEORD(ord,"I",itm,1)
			s str3=^OEORD(ord,"I",itm,3)
			s str7=$g(^OEORD(ord,"I",itm,7))
			s stDateTime = ##class(web.DHCEMCommonUtil).DateLogicalToHtml($p(str1,"^",9))_" "_$zt($p(str1,"^",10),2)
			s arcimDesc = ##class(web.DHCEMOrdInfoVO).getArcimDesc(ord,itm)
			s doctorDr=$p(str1,"^",11)
			s openOrdDoctor = $p($g(^CTPCP(+doctorDr,1)),"^",2)
			s itemStatDr = $p(str1,"^",13) 		;OEORI_ItemStat_DR ;OEC_OrderStatus
			s itemStatDesc = $p($g(^OEC("OSTAT",+itemStatDr)),"^",2)
			s ordDeptId = $p(str7,"^",2)
			s ordDept = ##class(web.DHCDocOrderCommon).GetLocDesc(ordDeptId)
			s recDepId = $p(str3,"^",6)
			s recDep = ##class(web.DHCDocOrderCommon).GetLocDesc(recDepId)
			s doseQtyUnit=""
	
			i '($d(^OEORD(ord,"I",itm,"X"))<10) {
				s sub=$o(^OEORD(ord,"I",itm,"X",0))
				s doseQtyUnit=##class(web.DHCEMOrdInfoVO).GetdoseQtyUnit(ord,itm,sub)
			}
			
			s phcinDesc=##class(web.DHCEMOrdInfoVO).getPhcinDesc(ord,itm)
			s durat=##class(web.DHCEMOrdInfoVO).getDurat(ord,itm)
			s phcfrCode=##class(web.DHCEMOrdInfoVO).getPhcfrCode(ord,itm)
			s count=count+1
			s itemData=ord_"||"_itm_"^"_stDateTime_"^"_arcimDesc_"^"_openOrdDoctor_"^"_itemStatDesc_"^"_ordDept_"^"_recDep
			s itemData=itemData_"^"_doseQtyUnit_"^"_phcinDesc_"^"_durat_"^"_phcfrCode
			w $case(count,1:"",:",")
			w ##class(web.DHCAPPJsonCommon).getJsonData(itemTitle,itemData)
		}
	}  
	
	w "],""total"":"_count_"}"
	q ""
}

}
