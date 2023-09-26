Import sqluser

Class web.DHCEMECheck Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 传就诊ID和就诊日期
/// w ##class(web.DHCEMECheck).DHCEMECheckInfo("633","64294")
ClassMethod DHCEMECheckInfo(PaAdm, PAAdmDate)
{
	q:PaAdm="" ""
	q:PAAdmDate="" ""
	s:PAAdmDate["-" PAAdmDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(PAAdmDate) //hxy 2017-03-08 $zdh(PAAdmDate,3)
	s rs = ""
	s QueueId=""
	f  s QueueId=$o(^User.DHCQueueI("QueDateIndex",PAAdmDate,QueueId)) q:QueueId=""  d   //err1
	.;b ;err 
	.s EpisodeID=$List(^User.DHCQueueD(QueueId),11)  //就诊ID
	.q:EpisodeID'=PaAdm                             ///过滤
	.s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",+EpisodeID,""),-1) 
	.q:EmPCLvID=""  								//分针ID  为空
	.s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)  	/// 病人ID
	.s EmRegDate=$p(^PAADM(EpisodeID),"^",6)    	/// 登记日期
	.s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate) //hxy(EmRegDate,3) 
	.s EmRegTime=$p(^PAADM(EpisodeID),"^",7)    	/// 登记时间
	.s:EmRegTime'="" EmRegTime=$zt(EmRegTime,2)
	.s EmRegDate=EmRegDate_" "_EmRegTime
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	/// 病人登记号
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 病人姓名
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)     /// 性别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID)  /// 年龄
	.s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	.i birthday'="" s birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) //
	.s IdentNo=$p(^PAPER(PatientID,"ALL"),"^",9)         /// 身份证号
	.s:$p($g(^PAPER(PatientID,"PAT",3)),"^",7)'=1 IdentNo=""
	.s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  /// 民族
	.i nationdr'="" s PatNation=$p(^CT("NAT",nationdr),"^",2)
	.s countrydr=$p(^PAPER(PatientID,"PER",1),"^",8) 	  /// 国家
	.i countrydr'="" s PatCountry=$p(^CT("COU",countrydr),"^",2)
	.s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	  /// 电话 
	.s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 	  /// 家庭住址
	.s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	.s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	.s PatDiag=""
	.s PatCardNo=""
	.s CardTypeID=""
	.s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
	.i CardNoID'="" d
	..s PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) 		 /// 卡号
	..s CardTypeID=$p($g(^DHCCARD("CF",CardNoID)),"^",16) 		 /// 卡类型
	.s NurseLevel="",EmtArea=""
	.i EmPCLvID'="" d
	..s EmRecLevel=$p(^DHCEMPCL(EmPCLvID),"^",6)  /// 推荐分级
	..s EmRecLevel=$s(EmRecLevel=1:"一级",EmRecLevel=2:"二级",EmRecLevel=3:"三级",EmRecLevel=4:"四级",1:"")
	..s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)   /// 护士分级
	..s NurseLevel=$s(NurseLevel=1:"一级",NurseLevel=2:"二级",NurseLevel=3:"三级",NurseLevel=4:"四级",1:"")
	..s EmtArea=$p(^DHCEMPCL(EmPCLvID),"^",9)      /// 去向
	..s EmtArea=$s(EmtArea=1:"红区",EmtArea=2:"黄区",EmtArea=3:"绿区",1:"")
	..s EmLocID=$p(^DHCEMPCL(EmPCLvID),"^",10) 	/// 分诊科室
	..i EmLocID'="" s EmLocDesc=$p(^CTLOC(EmLocID),"^",2)
	..b ;科室
	..s EmUpdLevRe=$p(^DHCEMPCL(EmPCLvID),"^",8)  /// 护士更改分级原因
	..i EmUpdLevRe'="" s EmUpdLevRe=$p(^DHCEMULR(EmUpdLevRe),"^",2)
	..s EmAgainFlag=$p(^DHCEMPCL(EmPCLvID),"^",11) 	/// 重返标识
	..s EmAgainFlag=$s(EmAgainFlag="Y":"是",EmAgainFlag="N":"否",1:"")
	..s EmBatchFlag=$p(^DHCEMPCL(EmPCLvID),"^",12) 	/// 成批就诊
	..s EmBatchFlag=$s(EmBatchFlag="Y":"是",EmBatchFlag="N":"否",1:"")
	..s EmBatchNum=$p(^DHCEMPCL(EmPCLvID),"^",13) 	/// 成批就诊人数
	..s EmPatSource=$p(^DHCEMPCL(EmPCLvID),"^",15) 	/// 病人来源
	..i EmPatSource'="" s EmPatSource=$p(^DHCEMPSO(EmPatSource),"^",2)
	..s EmPatAdmWay=$p(^DHCEMPCL(EmPCLvID),"^",16) 	/// 来诊方式
	..i EmPatAdmWay'="" s EmPatAdmWay=$p(^DHCEMPADW(EmPatAdmWay),"^",2)
	..s EmAware=$p(^DHCEMPCL(EmPCLvID),"^",17) 	    /// 意识状态
	..i EmAware'="" s EmAware=$p(^DHCEMPAW(EmAware),"^",2)
	..s EmScreenFlag=$p(^DHCEMPCL(EmPCLvID),"^",18) 	/// 筛查
	..s EmScreenFlag=$s(EmScreenFlag="1":"发热",EmScreenFlag="2":"肠道",1:"")
	..s EmHisDrug=$p(^DHCEMPCL(EmPCLvID),"^",19) 	    /// 用药情况
	..s EmHisDrugDesc=$p(^DHCEMPCL(EmPCLvID),"^",20) 	/// 用药情况描述
	..s EmMaterial=$p(^DHCEMPCL(EmPCLvID),"^",21) 	/// 辅助物
	..s EmMaterialDesc=$p(^DHCEMPCL(EmPCLvID),"^",22) /// 辅助物描述
	..s EmCombFlag=$p(^DHCEMPCL(EmPCLvID),"^",26) 	/// 复合伤
	..s EmCombFlag=$s(EmCombFlag="Y":"是",EmCombFlag="N":"否",1:"")
	..s EmECGFlag=$p(^DHCEMPCL(EmPCLvID),"^",27) 	    /// ECG
	..s EmECGFlag=$s(EmECGFlag="Y":"是",EmECGFlag="N":"否",1:"")
	..s EmPoisonFlag=$p(^DHCEMPCL(EmPCLvID),"^",28)   /// 中毒
	..s EmPoisonFlag=$s(EmPoisonFlag="Y":"是",EmPoisonFlag="N":"否",1:"")
	..s EmPainFlag=$p(^DHCEMPCL(EmPCLvID),"^",29) 	/// 疼痛
	..s EmPainLev=$p(^DHCEMPCL(EmPCLvID),"^",30) 	    /// 疼痛分级
	..s EmPainRange=$p(^DHCEMPCL(EmPCLvID),"^",31) 	/// 疼痛范围
	..s EmPainRangeDesc=$s(EmPainRange="1":"中枢",EmPainRange="2":"外周",1:"")
	..s EmPainDate=$p(^DHCEMPCL(EmPCLvID),"^",32) 	/// 疼痛日期
	..s:EmPainDate'="" EmPainDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmPainDate) //hxy
	..s EmPainTime=$p(^DHCEMPCL(EmPCLvID),"^",33) 	/// 疼痛时间
	..s:EmPainTime'="" EmPainTime=$zt(EmPainTime,2)
	..s:EmPainDate'="" EmPainTime=EmPainDate_" "_EmPainTime
	..s EmPainLev="疼痛指数："_EmPainLev_"级,疼痛范围："_EmPainRangeDesc_",疼痛时间："_EmPainTime
	..i EmPainFlag="N" s EmPainLev=""
	..i EmPainFlag="" s EmPainLev=""
	..s EmOxygenFlag=$p(^DHCEMPCL(EmPCLvID),"^",34)   /// 吸氧
	..s EmOxygenFlag=$s(EmOxygenFlag="Y":"是",EmOxygenFlag="N":"否",1:"")
	..s EmOtherDesc=$p(^DHCEMPCL(EmPCLvID),"^",36) 	/// 其它
	..s EmSymDesc=$p(^DHCEMPCL(EmPCLvID),"^",25) 	    /// 症状
	..s EmSymDesc=##class(web.DHCEMPatCheckLevQuery).GetEmSymDesc(EmSymDesc)		    /// 症状
	
	..s EmPatChkHis=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkLvHisDesc(EmPCLvID)		/// 既往史
	..s EmPatChkSign=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkSignDesc(EmPCLvID)      /// 生命体征
	..s EmPatChkCare=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkCareDesc(EmPCLvID)      /// 预检号别表

	.;i EpisodeID'="" s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID) //诊断
	.s rs = EmPCLvID_"^"_PatientID_"^"_EmRegDate_"^"_EmRegTime_"^"_PatNo_"^"_PatName_"^"_PatSex
	.s rs = rs_"^"_PatAge_"^"_birthday_"^"_IdentNo_"^"_PatNation_"^"_countrydr_"^"_PatTelH_"^"_Address
	.s rs = rs_"^"_BillType_"^"_PatCardNo_"^"_CardTypeID_"^"_NurseLevel_"^"_EmtArea_"^"_EmLocDesc_"^"_EmUpdLevRe
	.s rs = rs_"^"_EmAgainFlag_"^"_EmBatchFlag_"^"_EmBatchNum_"^"_EmPatSource_"^"_EmPatAdmWay_"^"_EmAware_"^"_EmRecLevel
	.s rs = rs_"^"_EmScreenFlag_"^"_EmHisDrug_"^"_EmMaterialDesc_"^"_EmCombFlag_"^"_EmECGFlag_"^"_EmPoisonFlag_"^"_EmOxygenFlag
	.s rs = rs_"^"_EmPainFlag_"^"_EmPainLev_"^"_EmOtherDesc_"^"_EmSymDesc_"^"_PatNation_"^"_PatCountry_"^"_EmHisDrugDesc_"^"_EmPatChkHis_"^"_EmPatChkSign_"^"_EmPatChkCare
	.s str  ="EmPCLvID^PatientID^EmRegDate^EmRegTime^PatNo^PatName^PatSex^PatAge^birthday^IdentNo"
	.s str  =str_"^nationdr^countrydr^PatTelH^Address^BillType^PatCardNo^CardTypeID^NurseLevel^EmtArea^EmLocDesc^EmUpdLevRe"
	.s str = str_"^EmAgainFlag^EmBatchFlag^EmBatchNum^EmPatSource^EmPatAdmWay^EmAware^EmRecLevel"
	.s str = str_"^EmScreenFlag^EmHisDrug^EmMaterialDesc^EmCombFlag^EmECGFlag^EmPoisonFlag^EmOxygenFlag"
	.s str = str_"^EmPainFlag^EmPainLev^EmOtherDesc^EmSymDesc^PatNation^PatCountry^EmHisDrugDesc^EmPatChkHis^EmPatChkSign^EmPatChkCare"
	.w ##class(web.DHCAPPJsonCommon).getJsonData(str,rs)
	q ""
}

/// 传病人就诊ID
/// w ##class(web.DHCEMECheck).GetAdmInfoByAdm("298")
ClassMethod GetAdmInfoByAdm(EpisodeID As %String)
{
	n (EpisodeID)
	q:EpisodeID="" ""
	s PatDr = $p(^PAADM(EpisodeID),"^",1)
	s EmRegDate=""
	s EmRegDate=$p(^PAADM(EpisodeID),"^",6)    	/// 登记日期
	s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate) //hxy 
	s EmRegTime=""
	s EmRegTime=$p(^PAADM(EpisodeID),"^",7)    	/// 登记时间
	s:EmRegTime'="" EmRegTime=$zt(EmRegTime,2)
	
	///由于医生修改病人分级是按照就诊走的这里取出医生对病人分级
	s DocCheckInfo = ##class(web.DHCEMECheck).GetDocCheckLev(EpisodeID)
	s EmPatCheckLevId = ##class(web.DHCEMECheck).GetEmPatCheckLevDr(EpisodeID)
	s EmRegDate=""
	i EmPatCheckLevId'="" D
	.s EmRegID=$p(^DHCEMPCL(EmPatCheckLevId),"^",2)  /// 登记表ID
	.s EmRegDate=$p(^DOCEMREG("EM",EmRegID),"^",4)   /// 登记时间
	.s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate) //$zd(EmRegDate,3)

	s PatInfo=""
	b ;err
	s PatInfo=..GetPatInfoByPatId(PatDr)
	b ;err1
	s rsData =PatInfo_"^"_EmRegDate_"^"_EmRegTime_"^"_EmPatCheckLevId_"^"_DocCheckInfo
	b ;err2
	s str="PatNo"_"^"_"PatName"_"^"_"PatSex"_"^"_"PatAge"_"^"_"birthday"_"^"_"IdentNo"
	s str=str_"^"_"PatNation"_"^"_"PatCountry"_"^"_"PatTelH"_"^"_"Address"_"^"_"BillType"
	s str=str_"^"_"PatCardNo"_"^"_"CardTypeID"_"^"_"EmRegDate"_"^"_"EmRegTime"_"^"_"EmPCLvID"
	s str=str_"^"_"DocCheckLev"_"^"_"DocCheckReason"
	b ;err
	w ##class(web.DHCAPPJsonCommon).getJsonData(str,rsData)
	q ""
}

/// 传病人就诊ID
/// w ##class(web.DHCEMECheck).GetAdmInfoByAdmAdnPatID("1283","","")
ClassMethod GetAdmInfoByAdmAdnPatID(EpisodeID As %String, PatientID As %String, EmPCLvID)
{
	n (EpisodeID,PatientID,EmPCLvID,%session)
	q:'EpisodeID&&'PatientID ""
	s PatDr = PatientID
	s:(PatDr="")&&(EpisodeID'="") PatDr=$p(^PAADM(EpisodeID),"^",1)
	s EmRegDate="",EmRegTime="",EmPatCheckLevId="",DocCheckInfo="",PatLocID=""
	
	i EpisodeID'="" d
	.s EmRegDate=$p(^PAADM(EpisodeID),"^",6)    	/// 登记日期
	.s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate) //hxy 
	.s EmRegTime=""
	.s EmRegTime=$p(^PAADM(EpisodeID),"^",7)    	/// 登记时间
	.s:EmRegTime'="" EmRegTime=$zt(EmRegTime,2)
	.;由于医生修改病人分级是按照就诊走的这里取出医生对病人分级
	.s DocCheckInfo = ##class(web.DHCEMECheck).GetDocCheckLev(EpisodeID)
	.s EmPatCheckLevId = ##class(web.DHCEMECheck).GetEmPatCheckLevDr(EpisodeID)
	.s PatLocID=$p(^PAADM(EpisodeID),"^",4) //hxy 2020-06-11
	i EmPCLvID'="" d
	.s EmRegDate=$p(^DHCEMPCL(EmPCLvID),"^",59)   /// 登记时间
	.s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate)
	.s PatLocID=$p(^DHCEMPCL(EmPCLvID),"^",10) //hxy 2020-06-11
	s IdentNumber=$p($g(^PAPER(PatDr,"PAT",3)),"^",6) 
	s IdentID = $p($g(^PAPER(PatDr,"PAT",3)),"^",7)
	s Ident=""
	s:IdentID'="" Ident=$p(^PAC("CARD",IdentID),"^",2)
	
	s HOSPID=$p($g(^CTLOC(+PatLocID)),"^",22) //hxy 2020-06-11 
	s PatInfo=..GetPatInfoByPatId(PatDr,HOSPID) //hxy 2020-06-11 HOSPID
	S Ident=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCCredType","CRTDesc","",Ident)
	s rsData =PatInfo_"^"_Ident_"^"_EmRegDate_"^"_EmRegTime_"^"_EmPatCheckLevId_"^"_DocCheckInfo
	s $p(rsData,"^",6)=IdentNumber

	s str="PatNo^PatName^PatSex^PatAge^birthday^IdentNo"
	s str=str_"^PatNation^PatCountry^PatTelH^Address^BillType"
	s str=str_"^PatCardNo^CardTypeID^Ident^EmRegDate^EmRegTime^EmPCLvID"
	s str=str_"^DocCheckLev^DocCheckReason"
	
	w ##class(web.DHCAPPJsonCommon).getJsonData(str,rsData)
	q ""
}

/// 传病人ID
/// w ##class(web.DHCEMECheck).GetPatInfoByPatId("1")
/// return :登记号^病人姓名^性别^年龄^生日^省份证^民族^国家^电话^住址^费别^卡号^卡类型
ClassMethod GetPatInfoByPatId(PatientID As %String, HOSPID = "")
{
	s LgHospID=""
	s:$d(%session) LgHospID=%session.Get("LOGON.HOSPID")
	s:+HOSPID'=0 LgHospID=HOSPID //hxy 2020-06-10
	s rs=""
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	                    /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)                     /// 病人姓名
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)     					/// 性别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",LgHospID)   /// 年龄
	s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        			/// 出生日期
	i birthday'="" s birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) //hxy
	s IdentNo=$p(^PAPER(PatientID,"ALL"),"^",9)         			/// 身份证号
	;s:$p($g(^PAPER(PatientID,"PAT",3)),"^",7)'=1 IdentNo=""        ///这个判断暂时取消
	s PatNation=""
	s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  			/// 民族
	i nationdr'="" s PatNation=$p(^CT("NAT",nationdr),"^",2)
	s PatCountry=""
	s countrydr=$p(^PAPER(PatientID,"PER",1),"^",8) 	 			/// 国家
	i countrydr'="" s PatCountry=$p(^CT("COU",countrydr),"^",2)
	s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	  				/// 电话 
	s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 	  				/// 家庭住址
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     			/// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s PatDiag=""
	s PatCardNo=""
	s CardTypeID=""
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
	i CardNoID'="" d
	.s PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) 		 		/// 卡号
	.s CardTypeID=$p($g(^DHCCARD("CF",CardNoID)),"^",16) 		 	/// 卡类型
	S PatNation=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTNation","CTNATDesc","",PatNation)
	S PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	S PatCountry=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCountry","CTCOUDesc","",PatCountry)
	S BillType=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSocialStatus","SSDesc","",BillType)
	s rs= PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_birthday_"^"_IdentNo
	s rs=rs_"^"_PatNation_"^"_PatCountry_"^"_PatTelH_"^"_Address_"^"_BillType
	s rs=rs_"^"_PatCardNo_"^"_CardTypeID
	q rs
}

ClassMethod GetPatInfoByPatNo(PatNo)
{
	n (PatNo)
	s PatDr=$O(^PAPERi("PAPMI_PatNo",PatNo,""),-1)
	q ..GetPatInfoByPatId(PatDr)
}

///  Descript:	获取病人分级信息
///  W ##Class(web.DHCEMECheck).GetEmPatCheckLev("19")
ClassMethod GetEmPatCheckLev(EmPCLvID As %String) As %String
{
	n (EmPCLvID,%session)
	Q:EmPCLvID="" ""
	s EmRecLevel=$p(^DHCEMPCL(EmPCLvID),"^",6)  /// 推荐分级
	s:EmRecLevel'="" EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级",EmRecLevel=5:"5级",1:"") //hxy 2020-02-21
	s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)  /// 护士分级
	s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",NurseLevel=5:"5级",1:"") //hxy 2020-02-21
	s EmUpdLevRe=$p(^DHCEMPCL(EmPCLvID),"^",8)  /// 护士更改分级原因
	s:EmUpdLevRe'="" EmUpdLevRe=$p(^DHCEMDUR(EmUpdLevRe),"^",2)
	;s:EmUpdLevRe'="" EmUpdLevRe=$p($g(^DHCEMULR(EmUpdLevRe)),"^",2)
	s Area=$p(^DHCEMPCL(EmPCLvID),"^",9)  		/// 去向分区
	;s Area=$s(Area=1:"红区",Area=2:"黄区",Area=3:"绿区",1:"")
	s Area=$s(Area=1:"红区",Area=2:"橙区",Area=3:"黄区",Area=4:"绿区",1:"") //hxy 2020-02-21
	s EmLocID=$p(^DHCEMPCL(EmPCLvID),"^",10) 	/// 分诊科室
	s:EmLocID'="" EmLocID=$p(^CTLOC(EmLocID),"^",2)
	s EmAgainFlag=$p(^DHCEMPCL(EmPCLvID),"^",11) 	/// 重返标识
	s EmBatchFlag=$p(^DHCEMPCL(EmPCLvID),"^",12) 	/// 成批就诊
	s EmBatchNum=$p(^DHCEMPCL(EmPCLvID),"^",13) 	/// 成批就诊人数
	s EmPatSource=$p(^DHCEMPCL(EmPCLvID),"^",15) 	/// 病人来源
	s:EmPatSource'="" EmPatSource=$p(^DHCEMPSO(EmPatSource),"^",2)
	s EmPatAdmWay=$p(^DHCEMPCL(EmPCLvID),"^",16) 	/// 来诊方式
	s:EmPatAdmWay'="" EmPatAdmWay=$p(^DHCEMPADW(EmPatAdmWay),"^",2)
	s EmAware=$p(^DHCEMPCL(EmPCLvID),"^",17) 	    /// 意识状态
	s:EmAware'="" EmAware=$p($g(^DHCEMPAW(EmAware)),"^",2)
	s EmScreenFlag=$p(^DHCEMPCL(EmPCLvID),"^",18) 	/// 筛查 这里筛查是Y/N
	;s:EmScreenFlag'="" EmScreenFlag=$SELECT(EmScreenFlag=1:"发热",EmScreenFlag=2:"肠道",1:"")
	s EmHisDrug=$p(^DHCEMPCL(EmPCLvID),"^",19) 	    /// 用药情况
	s EmHisDrugDesc=$p(^DHCEMPCL(EmPCLvID),"^",20) 	/// 用药情况描述
	s EmMaterial=$p(^DHCEMPCL(EmPCLvID),"^",21) 	/// 辅助物
	s EmMaterialDesc=$p(^DHCEMPCL(EmPCLvID),"^",22) /// 辅助物描述
	s EmCombFlag=$p(^DHCEMPCL(EmPCLvID),"^",26) 	/// 复合伤
	s EmECGFlag=$p(^DHCEMPCL(EmPCLvID),"^",27) 	    /// ECG
	s EmPoisonFlag=$p(^DHCEMPCL(EmPCLvID),"^",28)   /// 中毒
	s EmPainFlag=$p(^DHCEMPCL(EmPCLvID),"^",29) 	/// 疼痛
	
	s EmPainLev=$p(^DHCEMPCL(EmPCLvID),"^",30) 	    /// 疼痛分级
	s EmPainRange=$p(^DHCEMPCL(EmPCLvID),"^",31) 	/// 疼痛范围
	s EmPainRangeDesc=$s(EmPainRange="1":"中枢",EmPainRange="2":"外周",1:"")
	s EmPainDate=$p(^DHCEMPCL(EmPCLvID),"^",32) 	/// 疼痛日期
	s:EmPainDate'="" EmPainDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmPainDate)  //hxy
	s EmPainTime=$p(^DHCEMPCL(EmPCLvID),"^",33) 	/// 疼痛时间
	s:EmPainTime'="" EmPainTime=$zt(EmPainTime,2)
	s:EmPainDate'="" EmPainTime=EmPainDate_" "_EmPainTime
	
	s EmOxygenFlag=$p(^DHCEMPCL(EmPCLvID),"^",34)   /// 吸氧
	s EmPatAskFlag=$p(^DHCEMPCL(EmPCLvID),"^",35) 	/// 请假
	s EmOtherDesc=$p(^DHCEMPCL(EmPCLvID),"^",36) 	/// 其它
	s EmSymDescStr=$p(^DHCEMPCL(EmPCLvID),"^",25) 	    /// 症状 
	s EmSymDesc=##Class(web.DHCEMECheck).GetSymDesc(EmPCLvID)
	s EmPatChkType=$p(^DHCEMPCL(EmPCLvID),"^",40) 	/// 特殊人群 2016-09-05 congyue
	s EmToLocID=$p(^DHCEMPCL(EmPCLvID),"^",41) 	/// 转向科室 2016-09-09 congyue
	s:EmToLocID'="" EmToLocID=$p(^CTLOC(EmToLocID),"^",1)
	s EmPatChkHisStr=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkLvHis(EmPCLvID)		/// 既往史
	s EmPatChkHis=""
	i EmPatChkHisStr'="" d
	.s Len=""
	.s Len = $l(EmPatChkHisStr,"#")
	.for i=1:1:Len d
	..s EmPatChkHisDesc=$p(^DHCEMPHI($p(EmPatChkHisStr,"#",i)),"^",2)
	..s:EmPatChkHisDesc'="" EmPatChkHisDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatHistory","PHDesc","",EmPatChkHisDesc)
	..s:EmPatChkHis'="" EmPatChkHis=EmPatChkHis_"; "_EmPatChkHisDesc
	..s:EmPatChkHis="" EmPatChkHis=EmPatChkHisDesc
	s EmPatChkSign=..GetEmPatChkSignItm(EmPCLvID)      /// 生命体征
	s EmPatChkCare=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkCare(EmPCLvID)      /// 预检号别表
	I EmPatChkCare'="" D
	.S EmPatChkCareLoc=$p($g(^CTLOC($p(EmPatChkCare,"@",3))),"^",2)
	.S EmPatChkCareLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",EmPatChkCareLoc)
	.S EmPatChkCareDoc=$p(^CTPCP($p(EmPatChkCare,"@",1),1),"^",2)
	.S EmPatChkCareDoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",EmPatChkCareDoc)
	s:EmPatChkCare'="" EmPatChkCare=EmPatChkCareLoc_"("_EmPatChkCareDoc_")"      /// 号别
	S AisDataStr = ##class(web.DHCEMPatCheckLevQuery).GetAisData(EmPCLvID)       	/// 创伤分级
	S GCSDataStr = ##class(web.DHCEMPatCheckLevQuery).GetGCSData(EmPCLvID)    		/// 格拉斯哥
	s PCLDate = $p(^DHCEMPCL(EmPCLvID),"^",4)
	s PCLTime = $p(^DHCEMPCL(EmPCLvID),"^",5)
	s:PCLDate'="" PCLDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PCLDate)  //hxy
	s:PCLTime'="" PCLTime=$zt(PCLTime,2)
	s EmRecLevel=##class(web.DHCEMCommonUtil).LevFormat(EmRecLevel) //hxy 2020-02-21
	s NurseLevel=##class(web.DHCEMCommonUtil).LevFormat(NurseLevel) //hxy 2020-02-21
	
	S EmRecLevel=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp",EmRecLevel)
	S NurseLevel=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp",NurseLevel)
	S EmUpdLevRe=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmDocUpdReason","DURDesc","",EmUpdLevRe)
	S Area=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp",Area)
	S EmLocID=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",EmLocID)
	S EmPatSource=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatSource","PSDesc","",EmPatSource)
	S EmPatAdmWay=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatAdmWay","PAWDesc","",EmPatAdmWay)
	S EmAware=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatAware","PADesc","",EmAware)
	
	s ListData=EmRecLevel_"^"_NurseLevel_"^"_EmUpdLevRe_"^"_Area_"^"_EmLocID_"^"_EmAgainFlag_"^"_EmBatchFlag_"^"_EmBatchNum_"^"_EmPatSource_"^"_EmPatAdmWay_"^"_EmAware_"^"_EmScreenFlag
	s ListData=ListData_"^"_EmHisDrug_"^"_EmHisDrugDesc_"^"_EmMaterial_"^"_EmMaterialDesc_"^"_EmCombFlag_"^"_EmECGFlag_"^"_EmPoisonFlag_"^"_EmPainFlag_"^"_EmOxygenFlag_"^"_EmPatAskFlag
	s ListData=ListData_"^"_EmOtherDesc_"^"_EmPatChkHis_"^"_EmPatChkSign_"^"_EmPainLev_"^"_EmPainRange_"^"_EmPainTime_"^"_EmPatChkCare_"^"_EmPainRangeDesc_"^"_EmSymDesc_"^"_EmPatChkType_"^"_EmToLocID
	s ListData=ListData_"^"_AisDataStr_"^"_GCSDataStr_"^"_PCLDate_"^"_PCLTime
	s ListTitle="EmRecLevel^NurseLevel^EmUpdLevRe^Area^EmLocID^EmAgainFlag^EmBatchFlag^EmBatchNum^EmPatSource^EmPatAdmWay^EmAware^EmScreenFlag"
	s ListTitle=ListTitle_"^EmHisDrug^EmHisDrugDesc^EmMaterial^EmMaterialDesc^EmCombFlag^EmECGFlag^EmPoisonFlag^EmPainFlag^EmOxygenFlag^EmPatAskFlag"
	s ListTitle=ListTitle_"^EmOtherDesc^EmPatChkHis^EmPatChkSign^EmPainLev^EmPainRange^EmPainTime^EmPatChkCare^EmPainRangeDesc^EmSymDesc^EmPatChkType^EmToLocID^AisDataStr^GCSDataStr"
	s ListTitle=ListTitle_"^PCLDate^PCLTime"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// W ##Class(web.DHCEMECheck).GetSymDesc("252")
ClassMethod GetSymDesc(EmPCLvID)
{
	n (EmPCLvID,%session)	
	s SymDescs =""
	s PCSYRowID=""
	f  s PCSYRowID = $o(^DHCEMPCSY(0,"PatCheckLev",EmPCLvID,PCSYRowID)) q:PCSYRowID=""  d
	.s SymDr=$p(^DHCEMPCSY(PCSYRowID),"^",2)
	.q:+SymDr=0
	.s SymDesc=$p(^DHCSYMFEI(SymDr),"^",2)
	.s SymDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCSymptomFeild","SYFDesc","",SymDesc)
	.s:SymDescs'="" SymDescs = SymDescs_","_SymDesc
	.s:SymDescs="" SymDescs = SymDesc
	q SymDescs
}

/// Descript:	生命体征
/// w ##class(web.DHCEMECheck).GetEmPatChkSign("292")
ClassMethod GetEmPatChkSign(EmPCLvID) As %String
{
	n (EmPCLvID)
	s ListData=""
	s EmPcsID=""
	f  s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",EmPCLvID,EmPcsID)) Q:EmPcsID=""  D
	.s EmPcsTime=$p(^DHCEMPCS(EmPcsID),"^",2)   /// 时间
	.s EmPcsTemp=$p(^DHCEMPCS(EmPcsID),"^",3)   /// 体温
	.s EmPcsHeart=$p(^DHCEMPCS(EmPcsID),"^",4)  /// 心率HR
	.s EmPcsPulse=$p(^DHCEMPCS(EmPcsID),"^",5)  /// 脉搏R
	.s EmPcsSBP=$p(^DHCEMPCS(EmPcsID),"^",6)    /// 血压(BP)收缩压
	.s EmPcsDBP=$p(^DHCEMPCS(EmPcsID),"^",7)    /// 舒张压
	.s EmPcsSoP2=$p(^DHCEMPCS(EmPcsID),"^",8)   /// 血氧饱合度SoP2
	.s EmPcsBreath=$p(^DHCEMPCS(EmPcsID),"^",9)   /// 呼吸频率
	.b ;err
	.i EmPcsTime'=""  d
	..s EmPcsTime="时间:"_$zt(EmPcsTime,2)
	..s:ListData'="" ListData=ListData_"; "_EmPcsTime
	..s:ListData="" ListData=EmPcsTime
	.
	.i EmPcsTemp'=""  d
	..s EmPcsTemp="体温:"_EmPcsTemp_"℃"
	..s:ListData'="" ListData=ListData_"; "_EmPcsTemp
	..s:ListData="" ListData=EmPcsTemp
	.
	.i EmPcsHeart'=""  d
	..s EmPcsHeart="心率HR:"_EmPcsHeart_"次/分"
	..s:ListData'="" ListData=ListData_"; "_EmPcsHeart
	..s:ListData="" ListData=EmPcsHeart
	.
	.i EmPcsPulse'=""  d
	..s EmPcsPulse="脉搏P:"_EmPcsPulse_"次/分"
	..s:ListData'="" ListData=ListData_"; "_EmPcsPulse
	..s:ListData="" ListData=EmPcsPulse
	.
	.i EmPcsSBP'=""  d
	..s EmPcsSBP="血压(BP)收缩压:"_EmPcsSBP_"mmHg"
	..s:ListData'="" ListData=ListData_"; "_EmPcsSBP
	..s:ListData="" ListData=EmPcsSBP
	.
	.i EmPcsDBP'=""  d
	..s EmPcsDBP="舒张压:"_EmPcsDBP_"mmHg"
	..s:ListData'="" ListData=ListData_"; "_EmPcsDBP
	..s:ListData="" ListData=EmPcsDBP
	.
	.i EmPcsSoP2'=""  d
	..s EmPcsSoP2="血氧饱合度SPO2:"_EmPcsSoP2_"%"
	..s:ListData'="" ListData=ListData_"; "_EmPcsSoP2
	..s:ListData="" ListData=EmPcsSoP2
	.
	.i EmPcsBreath'=""  d
	..s EmPcsBreath="呼吸频率:"_EmPcsBreath_"次/分"
	..s:ListData'="" ListData=ListData_"; "_EmPcsBreath
	..s:ListData="" ListData=EmPcsBreath
	
	q ListData
}

/// Descript:	生命体征
/// w ##class(web.DHCEMECheck).GetEmPatChkSign("292")
ClassMethod GetEmPatChkSignItm(EmPCLvID) As %String
{
	n (EmPCLvID,%session)
	s ListData=""
	s EmPcsID=""
	s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",EmPCLvID,EmPcsID),-1)
	s EmPcsTime=$p(^DHCEMPCS(EmPcsID),"^",2)   /// 时间
	s EmPcsTemp=$p(^DHCEMPCS(EmPcsID),"^",3)   /// 体温
	s EmPcsHeart=$p(^DHCEMPCS(EmPcsID),"^",4)  /// 心率HR
	s EmPcsPulse=$p(^DHCEMPCS(EmPcsID),"^",5)  /// 脉搏R
	s EmPcsSBP=$p(^DHCEMPCS(EmPcsID),"^",6)    /// 血压(BP)收缩压
	s EmPcsDBP=$p(^DHCEMPCS(EmPcsID),"^",7)    /// 舒张压
	s EmPcsSoP2=$p(^DHCEMPCS(EmPcsID),"^",8)   /// 血氧饱合度SoP2
	s EmPcsBreath=$p(^DHCEMPCS(EmPcsID),"^",9) /// 呼吸频率
	s EmPcsGLU=$p(^DHCEMPCS(EmPcsID),"^",10)   /// 血糖
	i EmPcsTime'=""  d
	.s TimeText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp","时间")
	.s EmPcsTime=TimeText_":"_$zt(EmPcsTime,2)
	.s:ListData'="" ListData=ListData_"; "_EmPcsTime
	.s:ListData="" ListData=EmPcsTime
	.
	i EmPcsTemp'=""  d
	.s TempText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp","体温")
	.s EmPcsTemp=TempText_":"_EmPcsTemp_"℃"
	.s:ListData'="" ListData=ListData_"; "_EmPcsTemp
	.s:ListData="" ListData=EmPcsTemp
	.
	i EmPcsHeart'=""  d
	.s PcsHeartText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp","心率HR")
	.s PcsHeartunit=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp","次/分")
	.s EmPcsHeart=PcsHeartText_":"_EmPcsHeart_PcsHeartunit
	.s:ListData'="" ListData=ListData_"; "_EmPcsHeart
	.s:ListData="" ListData=EmPcsHeart
	.
	i EmPcsPulse'=""  d
	.s PulseText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp","脉搏P")
	.s Pulsetunit=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp","次/分")
	.s EmPcsPulse=PulseText_":"_EmPcsPulse_Pulsetunit
	.s:ListData'="" ListData=ListData_"; "_EmPcsPulse
	.s:ListData="" ListData=EmPcsPulse
	.
	i EmPcsSBP'=""  d
	.s PcsSBPText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp","血压(BP)")
	.s PcsSBPText=PcsSBPText_##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp","收缩压")
	.s EmPcsSBP=PcsSBPText_":"_EmPcsSBP_"mmHg"
	.s:ListData'="" ListData=ListData_"; "_EmPcsSBP
	.s:ListData="" ListData=EmPcsSBP
	.
	i EmPcsDBP'=""  d
	.s PcsDBPText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp","舒张压")
	.s EmPcsDBP=PcsDBPText_":"_EmPcsDBP_"mmHg"
	.s:ListData'="" ListData=ListData_"; "_EmPcsDBP
	.s:ListData="" ListData=EmPcsDBP
	.
	i EmPcsSoP2'=""  d
	.s SoP2Text=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp","血氧饱合度SPO2")
	.s EmPcsSoP2=SoP2Text_":"_EmPcsSoP2_"%"
	.s:ListData'="" ListData=ListData_"; "_EmPcsSoP2
	.s:ListData="" ListData=EmPcsSoP2
	.
	i EmPcsBreath'=""  d
	.s BreathText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp","呼吸频率")
	.s Breathunit=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp","次/分")
	.s EmPcsBreath=BreathText_":"_EmPcsBreath_Breathunit
	.s:ListData'="" ListData=ListData_"; "_EmPcsBreath
	.s:ListData="" ListData=EmPcsBreath
	i EmPcsGLU'=""  d
	.s GLUText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp","血糖")
	.s EmPcsGLU=GLUText_":"_EmPcsGLU_"mmol/l"
	.s:ListData'="" ListData=ListData_"; "_EmPcsGLU
	.s:ListData="" ListData=EmPcsGLU
	
	q ListData
}

/// Creator:    qiaoqingao
/// CreateDate: 2017-03-09
/// Descript:   Insert医生变更病人分级表
/// InPut:      "就诊ID","级别^分诊原因id^医生id^护士分级评估^评估说明^日期(数字)^时间(数字)"
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMECheck).InsDHCEmDocUpdPatLev("1141","1^2^600^1^的发射点")
/// 1141:
ClassMethod InsDHCEmDocUpdPatLev(Adm As %String, Params As %String) As %String
{
	n (Adm, Params)
	s ^joe("data") = $lb(Adm,Params)
	q:Adm="" "-1"
	s DocCheckLev = $p(Params,"^",1) 
	s DocCheckDesc = DocCheckLev_"级"
	s CTAcuDr = $o(^CT("ACU",0,"Code",DocCheckDesc,""),-1)
	s CheckLevCause = $p(Params,"^",2)
	s DocUser = $p(Params,"^",3)
	s NurCheckAssess = $p(Params,"^",4)
	s NurCheckComments = $p(Params,"^",5)
	s Date = +$h
	s Time = $p($h,",",2)
	s OperateType="Doc"
	s UpdLocID=""
	s EmPCLvID=""
	TS
	i '$d(^CT("ACU",CTAcuDr)) TRO
	q:'$d(^CT("ACU",CTAcuDr)) -1
	s $P(^PAADM(Adm),"^",33)=CTAcuDr
	&sql(INSERT INTO DHC_EmDocUpdPatLev VALUES (:Adm,:DocCheckLev,:CheckLevCause,:NurCheckAssess,:NurCheckComments,:DocUser,:Date,:Time,:OperateType,:UpdLocID,:EmPCLvID))
	i SQLCODE<0 TRO
	q:SQLCODE<0 SQLCODE
	TC
	q SQLCODE
}

ClassMethod GetDocCheckLev(EpisodeID)
{
	n (EpisodeID,%session)
	s tmp=""
	s DHCDuplDr = $o(^DHCEMDUPL(0,"PAADM",EpisodeID,""),-1)
	q:+DHCDuplDr=0 ""
	s DocCheckLev = $p(^DHCEMDUPL(DHCDuplDr),"^",4)     //医生分级
	s:DocCheckLev'="" DocCheckLev=DocCheckLev_"级"
	s DocUpdReasonDr = $p(^DHCEMDUPL(DHCDuplDr),"^",2)
	s DocUpdReasonDesc = $p($g(^DHCEMDUR(DocUpdReasonDr)),"^",2)
	S PatNation=##class(web.DHCEMCommonUtil).GetTrans("dhcem.emerpatientinfom.csp",DocCheckLev)
	S DocUpdReasonDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmDocUpdReason","DURDesc","",DocUpdReasonDesc)
	s tmp = DocCheckLev_"^"_DocUpdReasonDesc
	q tmp
}

/// Creator:    qiaoqingao
/// CreateDate: 2017-03-09
/// Descript:   通过就诊查询病人分诊ID
/// InPut:      "就诊ID"
/// OutPut:     
/// w ##Class(web.DHCEMECheck).InsDHCEmDocUpdPatLev("1141","1^2^600^1^的发射点")
/// 
ClassMethod GetEmPatCheckLevDr(EpisodeID)
{
	n (EpisodeID)
	s PCLRowID=""
	s:$d(^DHCEMPCA(0,"AdmChkLev",EpisodeID))>=10 PCLRowID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	q PCLRowID
}

/// Creator:    qiaoqingao
/// CreateDate: 2017-03-09
/// Descript:   通过就诊查询病人分诊级别
/// InPut:      "就诊ID"
/// OutPut:    	护士分级^医生分级 
/// w ##Class(web.DHCEMECheck).GetEmPatCheckLevGrade("1141")
/// 
ClassMethod GetEmPatCheckLevGrade(EpisodeID)
{
	n (EpisodeID)
	s EmPCLvID = ..GetEmPatCheckLevDr(EpisodeID)
	s NursCheckGrade=""
	s:+EmPCLvID NursCheckGrade = $p($g(^DHCEMPCL(EmPCLvID)),"^",7)_"级"
	s DocCheckInfo = ..GetDocCheckLev(EpisodeID)
	s Priority=$P($g(^PAADM(EpisodeID)),"^",33)
	s PAAdmPriority=""
	i Priority'="" s PAAdmPriority=$p($g(^CT("ACU",Priority)),"^",1)
	s:PAAdmPriority="" PAAdmPriority=NursCheckGrade
	q NursCheckGrade_"^"_PAAdmPriority
}

/// w ##Class(web.DHCEMECheck).GetAdmStatus("1141")
/// 
ClassMethod GetAdmStatus(EpisodeID)
{
	n (EpisodeID)
	s AdmStatus=$p($g(^PAADM(+EpisodeID)),"^",20)
	q AdmStatus
}

Storage Default
{
<Data name="DHCEMECheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMECheckD</DataLocation>
<DefaultData>DHCEMECheckDefaultData</DefaultData>
<IdLocation>^web.DHCEMECheckD</IdLocation>
<IndexLocation>^web.DHCEMECheckI</IndexLocation>
<StreamLocation>^web.DHCEMECheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
