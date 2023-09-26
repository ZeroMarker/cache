Import SQLUser

/// Creator:    bianshuai
/// CreateDate: 2016-06-12
/// Descript:   用药错误查询
Class web.DHCSTPHCMDrugMisUseQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 病人信息查询
/// w ##class(web.DHCSTPHCMDrugMisUseQuery).GetPatInfo("24")
ClassMethod GetPatInfo(EpisodeID As %String, PatientID As %String) As %String
{
	n (EpisodeID, PatientID)
    i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
    Q:PatientID="" ""
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	   /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	i birthday'="" s birthday=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(birthday) ;$zd(birthday,3)
	s IdentNo=$p(^PAPER(PatientID,"ALL"),"^",9)         /// 身份证号
	s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  /// 民族
	s countrydr=$p(^PAPER(PatientID,"PER",1),"^",8) 	/// 国家
	s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话
	s PatWeight=+##class(web.DHCSTCNTSCOMMON).GetPatWeight(EpisodeID) //体重
	i PatWeight=0 s PatWeight=" "    //让体重为0的时候返回空 nisijia 2016-09-08
	s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") //诊断
	
	s ListData=EpisodeID_"^"_PatientID_"^"_PatNo_"^"_PatName_"^"_sexId_"^"_PatSex_"^"_PatAge_"^"_nationdr_"^"_countrydr_"^"_birthday
	s ListData=ListData_"^"_IdentNo_"^"_PatTelH_"^"_PatWeight_"^"_PatDiag
	
	s ListTitle="EpisodeID^PatientID^PatNo^PatName^sexId^PatSex^PatAge^nationdr^countrydr^birthday^IdentNo^PatTelH^PatWeight^PatDiag"
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript: 获取报告数据
/// w ##class(web.DHCSTPHCMDrugMisUseQuery).GetMisRep("32")
ClassMethod GetMisRep(mrRepID As %String) As %String
{
	n (mrRepID)
	Q:'$d(^DHCPHDMR(mrRepID)) ""
	s mrRepDate=$p(^DHCPHDMR(mrRepID),"^",1)             /// 报告日期
	s:mrRepDate'="" mrRepDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(mrRepDate)  ;$zd(mrRepDate,3)
	s mrRepOccDate=$p(^DHCPHDMR(mrRepID),"^",2)          /// 错误发生日期 
	s:mrRepOccDate'="" mrRepOccDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(mrRepOccDate)  ;$zd(mrRepOccDate,3)
	s mrRepDisDate=$p(^DHCPHDMR(mrRepID),"^",3)          /// 发现错误日期
	s:mrRepDisDate'="" mrRepDisDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(mrRepDisDate)  ;$zd(mrRepDisDate,3)
	s mrRepDspToPat=$p(^DHCPHDMR(mrRepID),"^",4)    /// 是否发放给患者
	s mrRepPatTaked=$p(^DHCPHDMR(mrRepID),"^",5)    /// 患者是否使用
	s mrRepLevel=$p(^DHCPHDMR(mrRepID),"^",6)       /// 伤害级别
	s mrRepPatID=$p(^DHCPHDMR(mrRepID),"^",7)       /// 病人ID
	S mrRepPatAdm=$o(^PAPERdr(mrRepPatID,"ADM","I",""),-1)  //就诊id  liyarong 2016-10-08
	s mrRepPatName=$p(^DHCPHDMR(mrRepID),"^",8)     /// 姓名
	s mrRepPatSex=$p(^DHCPHDMR(mrRepID),"^",9)      /// 性别
	s mrRepPatAge=$p(^DHCPHDMR(mrRepID),"^",10)     /// 年龄
	s mrRepPatDOB=$p(^DHCPHDMR(mrRepID),"^",11)     /// 出生日期
	s:mrRepPatDOB'="" mrRepPatDOB=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(mrRepPatDOB)
	s mrRepPatWeight=$p(^DHCPHDMR(mrRepID),"^",12)  /// 体重
	s mrRepPatContact=$p(^DHCPHDMR(mrRepID),"^",13) /// 联系方式
	s mrRepPatMedNo=$p(^DHCPHDMR(mrRepID),"^",14)   /// 就诊号
	s mrRepPatICDDesc=$p(^DHCPHDMR(mrRepID),"^",15) /// 诊断
	s mrRepHarmRet=$p(^DHCPHDMR(mrRepID),"^",16)    /// 伤害结果
	s mrRepHarmRetDesc=$p(^DHCPHDMR(mrRepID),"^",17) /// 伤害描述
	s mrRepDeathDate=$p(^DHCPHDMR(mrRepID),"^",18)   /// 死亡日期
	s:mrRepDeathDate'="" mrRepDeathDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(mrRepDeathDate)  ;$zd(mrRepDeathDate,3)
	s mrRepDeathTime=$p(^DHCPHDMR(mrRepID),"^",19)   /// 死亡时间
	s:mrRepDeathTime'="" mrRepDeathTime=$zt(mrRepDeathTime,3)
	s mrRepRescue=$p(^DHCPHDMR(mrRepID),"^",20)      /// 是否抢救
	s mrRepResMeasDesc=$p(^DHCPHDMR(mrRepID),"^",21) /// 抢救措施
	s mrRepRecProc=$p(^DHCPHDMR(mrRepID),"^",22)     /// 恢复过程
	s mrRepUser=$p(^DHCPHDMR(mrRepID),"^",23)        /// 报告人
	s mrRepDept=$p(^DHCPHDMR(mrRepID),"^",24)        /// 报告科室
	s mrRepProTitle=$p(^DHCPHDMR(mrRepID),"^",25)    /// 报告人职称
	s mrRepTel=$p(^DHCPHDMR(mrRepID),"^",26)         /// 电话
	s mrRepEmail=$p(^DHCPHDMR(mrRepID),"^",27)       /// E-mail
	s mrRepPostCode=$p(^DHCPHDMR(mrRepID),"^",28)    /// 邮编
	s mrRepHappSite=$p(^DHCPHDMR(mrRepID),"^",29)    /// 发生位置
	s mrRepHappSiteDesc=$p(^DHCPHDMR(mrRepID),"^",30)   /// 发生位置描述
	s mrRepTriErrUser=$p(^DHCPHDMR(mrRepID),"^",31)     /// 引起错误的人员
	s mrRepTriErrUserDesc=$p(^DHCPHDMR(mrRepID),"^",32) /// 引起错误的人员描述
	s mrRepDisErrUser=$p(^DHCPHDMR(mrRepID),"^",33)     /// 发错错误人员
	s mrRepDisErrUserDesc=$p(^DHCPHDMR(mrRepID),"^",34) /// 发错错误人员描述
	s mrRepErrRelUser=$p(^DHCPHDMR(mrRepID),"^",35)     /// 错误相关人员
	s mrRepErrRelUserDesc=$p(^DHCPHDMR(mrRepID),"^",36) /// 错误相关人员描述
	s mrDisAndHandMea=$p(^DHCPHDMR(mrRepID),"^",37)     /// 发现和预防措施
	s mrProDrgRelInfo=$p(^DHCPHDMR(mrRepID),"^",38)     /// 是否提供相关信息
	s mrDrgRelInfoDesc=$p(^DHCPHDMR(mrRepID),"^",39)    /// 相关信息描述
	s mrRepErrContent=$p(^DHCPHDMR(mrRepID),"^",41)     /// 错误内容
	s mrRepTriErrFac=$p(^DHCPHDMR(mrRepID),"^",42)      /// 诱发因素
	s mrRepNo=$p(^DHCPHDMR(mrRepID),"^",43)             /// 编码
		
	s ListData=mrRepID_"^"_mrRepDate_"^"_mrRepOccDate_"^"_mrRepDisDate_"^"_mrRepDspToPat_"^"_mrRepPatTaked_"^"_mrRepLevel_"^"_mrRepPatID_"^"_mrRepPatName_"^"_mrRepPatSex
	s ListData=ListData_"^"_mrRepPatAge_"^"_mrRepPatDOB_"^"_mrRepPatWeight_"^"_mrRepPatContact_"^"_mrRepPatMedNo_"^"_mrRepPatICDDesc_"^"_mrRepHarmRet
	s ListData=ListData_"^"_mrRepHarmRetDesc_"^"_mrRepDeathDate_"^"_mrRepDeathTime_"^"_mrRepRescue_"^"_mrRepResMeasDesc_"^"_mrRepRecProc_"^"_mrRepUser
	s ListData=ListData_"^"_mrRepDept_"^"_mrRepProTitle_"^"_mrRepTel_"^"_mrRepEmail_"^"_mrRepPostCode_"^"_mrRepHappSite_"^"_mrRepHappSiteDesc
	s ListData=ListData_"^"_mrRepTriErrUser_"^"_mrRepTriErrUserDesc_"^"_mrRepDisErrUser_"^"_mrRepDisErrUserDesc_"^"_mrRepErrRelUser_"^"_mrRepErrRelUserDesc
	s ListData=ListData_"^"_mrDisAndHandMea_"^"_mrProDrgRelInfo_"^"_mrDrgRelInfoDesc_"^"_mrRepErrContent_"^"_mrRepTriErrFac_"^"_mrRepNo_"^"_mrRepPatAdm   //liyarong 2016-10-08
	
	s ListTitle="mrRepID^mrRepDate^mrRepOccDate^mrRepDisDate^mrRepDspToPat^mrRepPatTaked^mrRepLevel^mrRepPatID^mrRepPatName^mrRepPatSex^mrRepPatAge^mrRepPatDOB^mrRepPatWeight^mrRepPatContact^mrRepPatMedNo^mrRepPatICDDesc^mrRepHarmRet"
	s ListTitle=ListTitle_"^"_"mrRepHarmRetDesc^mrRepDeathDate^mrRepDeathTime^mrRepRescue^mrRepResMeasDesc^mrRepRecProc^mrRepUser^mrRepDept^mrRepProTitle^mrRepTel^mrRepEmail^mrRepPostCode^mrRepHappSite^mrRepHappSiteDesc"
	s ListTitle=ListTitle_"^"_"mrRepTriErrUser^mrRepTriErrUserDesc^mrRepDisErrUser^mrRepDisErrUserDesc^mrRepErrRelUser^mrRepErrRelUserDesc^mrDisAndHandMea^mrProDrgRelInfo^mrDrgRelInfoDesc^mrRepErrContent^mrRepTriErrFac^mrRepNo^mrRepPatAdm" //liyarong 2016-10-08"
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:用药错误报告药品信息
ClassMethod QueryMRDrugMisList(mrRepID As %String) As %String
{
	n (mrRepID)
	s pid=..NewPid()
	d ..killTmpGlobal(pid)

	s Num=0
	s ch=""
	f  s ch=$o(^DHCPHDMR(mrRepID,"DMRDI",ch)) q:ch=""  d
	.s oeori=$p(^DHCPHDMR(mrRepID,"DMRDI",ch),"^",1) 	   /// 医嘱ID
	.s phcddr=$p(^DHCPHDMR(mrRepID,"DMRDI",ch),"^",2)      /// 药学项ID
	.s goodsname=$p(^DHCPHDMR(mrRepID,"DMRDI",ch),"^",3)   /// 商品名
	.s genericdr=$p(^DHCPHDMR(mrRepID,"DMRDI",ch),"^",4)   /// 通用名ID
	.i genericdr'="" S genenic=$p($g(^PHCGE("GE",genericdr)),"^",2) //通用名
	.s formdr=$p(^DHCPHDMR(mrRepID,"DMRDI",ch),"^",5) 	   /// 剂型
	.i formdr'=""  s form=$p(^PHCF(formdr),"^",2)
	.s dosage=$p(^DHCPHDMR(mrRepID,"DMRDI",ch),"^",6)      /// 剂量
	.i $p(dosage,".")="" s dosage=0_dosage
	.s dosuomdr=$p(^DHCPHDMR(mrRepID,"DMRDI",ch),"^",7) /// 剂量单位
	.i dosuomdr'="" S doseuom=$p($g(^CT("UOM",dosuomdr)),"^",2)
	.s instrucdr=$p(^DHCPHDMR(mrRepID,"DMRDI",ch),"^",8)   /// 用法
	.i formdr'="" S instru=$p($g(^PHCIN(instrucdr)),"^",2)
	.s freqdr=$p(^DHCPHDMR(mrRepID,"DMRDI",ch),"^",9)      /// 频次
	.i freqdr'="" S freq=$p($g(^PHCFR(freqdr)),"^",3)
	.s manfdr=$p(^DHCPHDMR(mrRepID,"DMRDI",ch),"^",10)     /// 产地
	.s:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
	.s ListData=oeori_"^"_phcddr_"^"_goodsname_"^"_genericdr_"^"_$g(genenic)_"^"_formdr_"^"_form_"^"_dosage_doseuom
	.s ListData=ListData_"^"_dosuomdr_"^"_manfdr_"^"_$g(manf)_"^"_instrucdr_"^"_freqdr_"^"_instru_"^"_freq
	.
	.s Num=Num+1
	.s ^TMP("DHCST","web.DHCSTPHCMDrugMisUseQuery","QueryMRDrugMisList",pid,Num)=ListData
	
	q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	s quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	s Num=0
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMDrugMisUseQuery","QueryMRDrugMisList",pid,index)) Q:(index="")||(quitflag=1)  D
	.s mdata=^TMP("DHCST","web.DHCSTPHCMDrugMisUseQuery","QueryMRDrugMisList",pid,index)
	.s Title="orditm^phcdf^incidesc^genenicdr^genenic^formdr^form^dosage^dosuomdr^manfdr^manf^instrudr^freqdr^instru^freq"
	.s Num=Num+1
	.i Num=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:查询用药错误报告
/// w ##class(web.DHCSTPHCMDrugMisUseQuery).QueryMRDrugMisRepList("30","1","2016-07-11^2016-07-15")
ClassMethod QueryMRDrugMisRepList(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)

	s pid=..NewPid()
	s EndPage=page*rows  		   /// 结束行
	s StPage=((page-1)*rows)+1     /// 开始行
	s StartDate=$p(params,"^",1)   /// 开始日期
	s EndDate=$p(params,"^",2)     /// 结束日期
	d ..killTmpGlobal(pid)
	
	s StartDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(StartDate) ;$zdh(StartDate,3)
	s EndDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(EndDate) ;$zdh(EndDate,3)
	s QuitFlag=0
	s Num=0
	f dd=StartDate:1:EndDate D
	.s dmRepID=""
	.f  s dmRepID=$o(^DHCPHDMR(0,"RepDate",dd,dmRepID)) Q:dmRepID=""  D
	..s dmRepLocID=$p(^DHCPHDMR(dmRepID),"^",24)   /// 报告科室
	..s dmRepLoc=""
	..i dmRepLocID'="" s dmRepLoc=$p(^CTLOC(dmRepLocID),"^",2)
	..s dmRepNo=$p(^DHCPHDMR(dmRepID),"^",43)      /// 编码
	..s dmRepDate=$p(^DHCPHDMR(dmRepID),"^",1)     /// 日期
	..I dmRepDate'="" S dmRepDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dmRepDate)  ;$zd(dmRepDate,3)
	..s PatientID=$p(^DHCPHDMR(dmRepID),"^",7)      /// 病人ID
	..s dmPatName=$p(^DHCPHDMR(dmRepID),"^",8)      /// 病人姓名
	..s dmRepUser=$p(^DHCPHDMR(dmRepID),"^",23)     /// 报告人
	..i dmRepUser'="" s dmRepUser=$p(^SSU("SSUSR",dmRepUser),"^",2) //姓名
	..s dmPatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..s EpisodeID=+$o(^PAPERdr(PatientID,"ADM","I",""),-1)
	..s dmAdmLoc=""
	..s dmAdmLocID=$p($g(^PAADM(EpisodeID)),"^",4)   /// 科室
	..s:dmAdmLocID'="" dmAdmLoc=$p($p(^CTLOC(dmAdmLocID),"^",2),"-",2)
	..s dmAdmWard=""
	..s dmAdmWardID=$p($g(^PAADM(EpisodeID)),"^",70) /// 病区
	..s:dmAdmWardID'="" AdmWard=$p(^PAWARD(AdmWardID),"^",2)
	..
	..s ListData=dmRepID_"^"_dmRepNo_"^"_dmRepLoc_"^"_dmRepDate_"^"_dmPatNo_"^"_dmPatName_"^"_dmRepUser_"^"_dmAdmLoc_"^"_dmAdmWard
	..
	..s Num=Num+1
	..s ^TMP("DHCST","web.DHCSTPHCMDrugMisUseQuery","QueryMRDrugMisRepList",pid,Num)=ListData
	.
	
	q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	s quitflag=0
	s ListTitle="dmRepID^dmRepNo^dmRepLoc^dmRepDate^dmPatNo^dmPatName^dmRepUser^dmAdmLoc^dmAdmWard"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	s Num=0
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMDrugMisUseQuery","QueryMRDrugMisRepList",pid,index)) Q:(index="")||(quitflag=1)  D
	.s ListData=^TMP("DHCST","web.DHCSTPHCMDrugMisUseQuery","QueryMRDrugMisRepList",pid,index)
	.s Num=Num+1
	.i Num=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMDrugMisUseQuery","QueryMRDrugMisList",pid)
	k ^TMP("DHCST","web.DHCSTPHCMDrugMisUseQuery","QueryMRDrugMisRepList",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMDrugMisUseQuery"))
}

}
