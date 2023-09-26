Import sqluser

Class web.DHCSTPHCMADRREPORT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存DHC_PHAdrReport
/// w ##class(web.DHCSTPHCMADRREPORT).InsAdrReport()
ClassMethod InsAdrReport(dataList As %String) As %String
{
	N (dataList)
	S adrrRepCode=..GetAdrReportCurMaxNo("ADR"_$zd(+$H,8),"3") //$p(dataList,"^",1) //报告编号
	S adrrRepDate=+$H //报告日期
	S adrrPriority=$p(dataList,"^",2) //首次报告
	S adrrRepType=$p(dataList,"^",3)  //报告类型 
	S adrrDeptType=$p(dataList,"^",4) //报告单位类型
	S adrrDeptElse=$p(dataList,"^",5) //报告单位其它类型描述	

	S adrrPatID=$p(dataList,"^",6) 	  //患者ID
	Q:'$d(^PAPER(adrrPatID)) "-1"
	S adrrPatName=$p(dataList,"^",7)  //患者姓名
	S adrrPatSex=$p(dataList,"^",8)   //性别
	Q:adrrPatSex="" "-2"
	S adrrPatAge=$p(dataList,"^",9)   //年龄
	S adrrPatDOB=$p(dataList,"^",10)  //出生日期
	S:adrrPatDOB'="" adrrPatDOB=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(adrrPatDOB) ;$zdh(adrrPatDOB,3)
	S adrrPatNation=$p(dataList,"^",11)   //民族
	I adrrPatNation'="" Q:'$d(^CT("NAT",adrrPatNation)) "-3"
	S adrrPatWeight=$p(dataList,"^",12)   //体重
	S adrrPatContact=$p(dataList,"^",13)  //联系方式
	S adrrPatMedNo=$p(dataList,"^",14)    //病历号
	
	S adrrEvtHis=$p(dataList,"^",15)  //既往药品不良反应事件
	S adrrEvtHisDesc=$p(dataList,"^",16) //既往药品不良反应事件描述
	S adrrEvtFam=$p(dataList,"^",17)   //家族药品不良反应事件
	S adrrEvtFamDesc=$p(dataList,"^",18) //家族药品不良反应事件描述
	S adrrEventDr=$p(dataList,"^",19) 		//事件名称
	S adrrEvtDateOcc=$p(dataList,"^",20) 	//事件发生日期
	S:adrrEvtDateOcc'="" adrrEvtDateOcc=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(adrrEvtDateOcc) ;$zdh(adrrEvtDateOcc,3)
	S adrrEvtRes=$p(dataList,"^",21) 		//事件的结果
	S adrrEvtResDesc=$p(dataList,"^",22)    //事件的结果描述
	
	S adrrEvtDRes=$p(dataList,"^",23)       //好转(死亡)日期
	S:adrrEvtDRes'="" adrrEvtDRes=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(adrrEvtDRes) ;$zdh(adrrEvtDRes,3)
	S adrrEvtTRes=$p(dataList,"^",24)       //好转(死亡)时间
	S:adrrEvtTRes'="" adrrEvtTRes=$zth(adrrEvtTRes,1)
	S adrrEvtSRes=$p(dataList,"^",25)       //停药后是否减轻
	S adrrEvtTakAg=$p(dataList,"^",26)      //是否再次出现同样反应
	S adrrEvtEff=$p(dataList,"^",27)        //对原疾病的影响

	S adrrEvtCUser=$p(dataList,"^",28)  //关联性评价之报告人评价
	S adrrEvtRepUser=$p(dataList,"^",29)  //报告人评价签字
	S adrrEvtCDept=$p(dataList,"^",30)  //关联性评价之报告单位评价
	S adrrEvtRepDept=$p(dataList,"^",31)  //报告单位签字
	S adrrEvtUserOfRepTel=$p(dataList,"^",32)  //报告人联系电话
	S adrrEvtCarOfRepUser=$p(dataList,"^",33)  //报告人职业

	S adrrEvtCarOfRepElse=$p(dataList,"^",34)  //报告人职业[其他]
	S adrrEvtEOfRepUser=$p(dataList,"^",35)    //报告人邮箱
	S adrrEvtLocOfRep=$p(dataList,"^",46)      //报告人所属科室
	S adrrEvtProTitOfRep="" //$p(dataList,"^",38)   //报告人职称
	S adrrEvtProPosOfRep="" //$p(dataList,"^",39)   //报告人职务
	S adrrEvtProWishes="" //$p(dataList,"^",40)     //填报意愿

	S adrrEvtProDeptName=$p(dataList,"^",36) //报告单位名称
	S adrrEvtProDeptCon=$p(dataList,"^",37)  //报告单位联系人
	S adrrEvtProDeptTel=$p(dataList,"^",38)  //报告单位联系电话
	S adrrRepDate=$p(dataList,"^",39)  //报告日期
	S:adrrRepDate'="" adrrRepDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(adrrRepDate) ;$zdh(adrrRepDate,3)
	S adrrEvtRemark=$p(dataList,"^",42)      //备注
	S adrrEvtCurStatDR=$p(dataList,"^",45)   //当前状态
	S adrrRepTSDesc=$p(dataList,"^",43)   //损害情形
	S adrrRepTypeNew=$p(dataList,"^",44)  //新的

	&SQL(Insert Into DHC_PHAdrReport(ADRR_Code,ADRR_Date,ADRR_Priority,ADRR_RepType,
		ADRR_DeptType,ADRR_DeptElse,ADRR_PatID,ADRR_PatName,ADRR_PatSex,ADRR_PatAge,
		ADRR_PatDOB,ADRR_PatNation,ADRR_PatWeight,ADRR_PatContact,ADRR_PatMedNo,
		ADRR_EventHistory,ADRR_EventHistDesc,ADRR_EventFamily,ADRR_EventFamiDesc,
		ADRR_ADRE_Dr,ADRR_DateOccu,ADRR_Result,ADRR_ResultDesc,ADRR_DateResult,
		ADRR_TimeResult,ADRR_StopResultt,ADRR_TakingAgain,ADRR_EffectOfTreatment,
		ADRR_CommentOfUser,ADRR_UserOfReport,ADRR_CommentOfDept,ADRR_DeptOfReport,
		ADRR_Telephone,ADRR_CareerOfRepUser,ADRR_CareerOfRepElse,ADRR_EmailOfRepUser,
		ADRR_LocOfReporter,ADRR_ProTitleOfReporter,ADRR_PosOfReporter,ADRR_Wishes,
		ADRR_DeptName,ADRR_DeptContacts,ADRR_DeptTel,ADRR_Remark,ADRR_CurStatus_DR,
		ADRR_RepNew,ADRR_DamSit
	) Values(:adrrRepCode,:adrrRepDate,:adrrPriority,:adrrRepType,
		:adrrDeptType,:adrrDeptElse,:adrrPatID,:adrrPatName,:adrrPatSex,:adrrPatAge,
		:adrrPatDOB,:adrrPatNation,:adrrPatWeight,:adrrPatContact,:adrrPatMedNo,
		:adrrEvtHis,:adrrEvtHisDesc,:adrrEvtFam,:adrrEvtFamDesc,
		:adrrEventDr,:adrrEvtDateOcc,:adrrEvtRes,:adrrEvtResDesc,:adrrEvtDRes,
		:adrrEvtTRes,:adrrEvtSRes,:adrrEvtTakAg,:adrrEvtEff,
		:adrrEvtCUser,:adrrEvtRepUser,:adrrEvtCDept,:adrrEvtRepDept,
		:adrrEvtUserOfRepTel,:adrrEvtCarOfRepUser,:adrrEvtCarOfRepElse,:adrrEvtEOfRepUser,
		:adrrEvtLocOfRep,:adrrEvtProTitOfRep,:adrrEvtProPosOfRep,:adrrEvtProWishes,
		:adrrEvtProDeptName,:adrrEvtProDeptCon,:adrrEvtProDeptTel,:adrrEvtRemark,
		:adrrEvtCurStatDR,:adrrRepTypeNew,:adrrRepTSDesc
	))

	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:更新DHC_PHAdrReport
/// w ##class(web.DHCSTPHCMADRREPORT).UpdAdrReport()
ClassMethod UpdAdrReport(adrrepID As %String, dataList As %String) As %String
{
	N (adrrepID,dataList)
	S adrrRepCode=$p(dataList,"^",1) //报告编号
	S adrrRepDate=+$H //报告日期
	S adrrPriority=$p(dataList,"^",2) //首次报告
	S adrrRepType=$p(dataList,"^",3)  //报告类型 
	S adrrDeptType=$p(dataList,"^",4) //报告单位类型
	S adrrDeptElse=$p(dataList,"^",5) //报告单位其它类型描述	

	S adrrPatID=$p(dataList,"^",6) 	  //患者ID
	Q:'$d(^PAPER(adrrPatID)) "-1"
	S adrrPatName=$p(dataList,"^",7)  //患者姓名
	S adrrPatSex=$p(dataList,"^",8)   //性别
	Q:adrrPatSex="" "-2"
	S adrrPatAge=$p(dataList,"^",9)   //年龄
	S adrrPatDOB=$p(dataList,"^",10)  //出生日期
	S:adrrPatDOB'="" adrrPatDOB=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(adrrPatDOB) ;$zdh(adrrPatDOB,3)
	S adrrPatNation=$p(dataList,"^",11)   //民族
	I adrrPatNation'="" Q:'$d(^CT("NAT",adrrPatNation)) "-3"
	S adrrPatWeight=$p(dataList,"^",12)   //体重
	S adrrPatContact=$p(dataList,"^",13)  //联系方式
	S adrrPatMedNo=$p(dataList,"^",14)    //病历号
	
	S adrrEvtHis=$p(dataList,"^",15)  //既往药品不良反应事件
	S adrrEvtHisDesc=$p(dataList,"^",16) //既往药品不良反应事件描述
	S adrrEvtFam=$p(dataList,"^",17)   //家族药品不良反应事件
	S adrrEvtFamDesc=$p(dataList,"^",18) //家族药品不良反应事件描述
	S adrrEventDr=$p(dataList,"^",19) 		//事件名称
	S adrrEvtDateOcc=$p(dataList,"^",20) 	//事件发生日期
	S:adrrEvtDateOcc'="" adrrEvtDateOcc=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(adrrEvtDateOcc) ;$zdh(adrrEvtDateOcc,3)
	S adrrEvtRes=$p(dataList,"^",21) 		//事件的结果
	S adrrEvtResDesc=$p(dataList,"^",22)    //事件的结果描述
	
	S adrrEvtDRes=$p(dataList,"^",23)       //好转(死亡)日期
	S:adrrEvtDRes'="" adrrEvtDRes=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(adrrEvtDRes) ;$zdh(adrrEvtDRes,3)
	S adrrEvtTRes=$p(dataList,"^",24)       //好转(死亡)时间
	S:adrrEvtTRes'="" adrrEvtTRes=$zth(adrrEvtTRes,1)
	S adrrEvtSRes=$p(dataList,"^",25)       //停药后是否减轻
	S adrrEvtTakAg=$p(dataList,"^",26)      //是否再次出现同样反应
	S adrrEvtEff=$p(dataList,"^",27)        //对原疾病的影响

	S adrrEvtCUser=$p(dataList,"^",28)  //关联性评价之报告人评价
	S adrrEvtRepUser=$p(dataList,"^",29)  //报告人评价签字
	S adrrEvtCDept=$p(dataList,"^",30)  //关联性评价之报告单位评价
	S adrrEvtRepDept=$p(dataList,"^",31)  //报告单位签字
	S adrrEvtUserOfRepTel=$p(dataList,"^",32)  //报告人联系电话
	S adrrEvtCarOfRepUser=$p(dataList,"^",33)  //报告人职业

	S adrrEvtCarOfRepElse=$p(dataList,"^",34)  //报告人职业[其他]
	S adrrEvtEOfRepUser=$p(dataList,"^",35)    //报告人邮箱
	S adrrEvtLocOfRep=$p(dataList,"^",46)      //报告人所属科室
	S adrrEvtProTitOfRep="" //$p(dataList,"^",38)   //报告人职称
	S adrrEvtProPosOfRep="" //$p(dataList,"^",39)   //报告人职务
	S adrrEvtProWishes="" //$p(dataList,"^",40)     //填报意愿

	S adrrEvtProDeptName=$p(dataList,"^",36) //报告单位名称
	S adrrEvtProDeptCon=$p(dataList,"^",37)  //报告单位联系人
	S adrrEvtProDeptTel=$p(dataList,"^",38)  //报告单位联系电话
	S adrrRepDate=$p(dataList,"^",39)  //报告日期
	S:adrrRepDate'="" adrrRepDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(adrrRepDate) ;$zdh(adrrRepDate,3)
	S adrrEvtRemark=$p(dataList,"^",42)      //备注
	S adrrEvtCurStatDR=$p(dataList,"^",45)   //当前状态
	S adrrRepTSDesc=$p(dataList,"^",43)   //损害情形
	S adrrRepTypeNew=$p(dataList,"^",44)  //新的

	&SQL(Update DHC_PHAdrReport Set ADRR_Code=:adrrRepCode,ADRR_Date=:adrrRepDate,ADRR_Priority=:adrrPriority,ADRR_RepType=:adrrRepType,
		ADRR_DeptType=:adrrDeptType,ADRR_DeptElse=:adrrDeptElse,ADRR_PatID=:adrrPatID,ADRR_PatName=:adrrPatName,ADRR_PatSex=:adrrPatSex,ADRR_PatAge=:adrrPatAge,
		ADRR_PatDOB=:adrrPatDOB,ADRR_PatNation=:adrrPatNation,ADRR_PatWeight=:adrrPatWeight,ADRR_PatContact=:adrrPatContact,ADRR_PatMedNo=:adrrPatMedNo,
		ADRR_EventHistory=:adrrEvtHis,ADRR_EventHistDesc=:adrrEvtHisDesc,ADRR_EventFamily=:adrrEvtFam,ADRR_EventFamiDesc=:adrrEvtFamDesc,
		ADRR_ADRE_Dr=:adrrEventDr,ADRR_DateOccu=:adrrEvtDateOcc,ADRR_Result=:adrrEvtRes,ADRR_ResultDesc=:adrrEvtResDesc,ADRR_DateResult=:adrrEvtDRes,
		ADRR_TimeResult=:adrrEvtTRes,ADRR_StopResultt=:adrrEvtSRes,ADRR_TakingAgain=:adrrEvtTakAg,ADRR_EffectOfTreatment=:adrrEvtEff,
		ADRR_CommentOfUser=:adrrEvtCUser,ADRR_UserOfReport=:adrrEvtRepUser,ADRR_CommentOfDept=:adrrEvtCDept,ADRR_DeptOfReport=:adrrEvtRepDept,
		ADRR_Telephone=:adrrEvtUserOfRepTel,ADRR_CareerOfRepUser=:adrrEvtCarOfRepUser,ADRR_CareerOfRepElse=:adrrEvtCarOfRepElse,ADRR_EmailOfRepUser=:adrrEvtEOfRepUser,
		ADRR_LocOfReporter=:adrrEvtLocOfRep,ADRR_ProTitleOfReporter=:adrrEvtProTitOfRep,ADRR_PosOfReporter=:adrrEvtProPosOfRep,ADRR_Wishes=:adrrEvtProWishes,
		ADRR_DeptName=:adrrEvtProDeptName,ADRR_DeptContacts=:adrrEvtProDeptCon,ADRR_DeptTel=:adrrEvtProDeptTel,ADRR_Remark=:adrrEvtRemark,ADRR_CurStatus_DR=:adrrEvtCurStatDR,
		ADRR_RepNew=:adrrRepTypeNew,ADRR_DamSit=:adrrRepTSDesc Where ADRR_RowID=:adrrepID)

	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:保存不良反应报告患者诊断信息
ClassMethod InsAdrRepDiag(adrrRepID As %String, adrRepMRCICItms As %String) As %String
{
	N (adrrRepID,adrRepMRCICItms)
	S Len=$L(adrRepMRCICItms,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S MRCICItms=$p(adrRepMRCICItms,"||",i)
	.S addrICDCodeDr=$p(MRCICItms,"^",1) //诊断
	.S addrDDesc=$p(MRCICItms,"^",2)     //诊断描述
	.Q:(addrICDCodeDr="")&(addrDDesc="")
	.S childSub=$o(^DHCPHADRR(adrrRepID,"ADRRD",""),-1)+1
	.&SQL(Insert into DHC_PHAdrRepDiag(ADRRD_ADRR_Parref,ADRRD_ChildSub,ADRRD_ICDCode_DR,ADRRD_Desc)
		Values(:adrrRepID,:childSub,:addrICDCodeDr,:addrDDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:不良反应报告患者相关重要信息
ClassMethod InsAdrRepImpInfo(adrrRepID As %String, adrRepImpInfodataList As %String) As %String
{
	N (adrrRepID,adrRepImpInfodataList)
	S Len=$L(adrRepImpInfodataList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S ImpInfoList=$p(adrRepImpInfodataList,"||",i)
	.S adrADRIICode=$p(ImpInfoList,"^",1)  //患者重要信息ID
	.Q:adrADRIICode=""
	.S adrADRIIDr=$o(^DHCPHADRII(0,"Code",adrADRIICode,""))  //取患者相关信息ID
	.S:adrADRIIDr="" adrADRIIDr=adrADRIICode
	.S adrImpInfoDesc=$p(ImpInfoList,"^",2)  //重要信息描述
	.S childSub=$o(^DHCPHADRR(adrrRepID,"ADRRII",""),-1)+1
	.&SQL(Insert into DHC_PHAdrRepImpInfo(ADRRI_ADRR_Parref,ADRRI_ChildSub,ADRRI_ADRII_DR,ADRRI_ImpInfo) 
		Values(:adrrRepID,:childSub,:adrADRIIDr,:adrImpInfoDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:不良反应报告过程描述
ClassMethod InsAdrRepProc(adrrRepID As %String, adrRepProcdataList As %String) As %String
{
	N (adrrRepID,adrRepProcdataList)
	S childSub=1
	S adrTherapMeas=$p(adrRepProcdataList,"^",1)   //治疗措施
	S adrSymptom=$p(adrRepProcdataList,"^",2)      //症状、体征、临床检验
	S adrOtherExp=$p(adrRepProcdataList,"^",3)     //其它说明内容
	S adrProcDesc=$p(adrRepProcdataList,"^",4)     //过程描述
	&SQL(Insert into DHC_PHAdrRepProc(ADRRP_ADRR_Parref,ADRRP_ChildSub,ADRRP_TherapMeas,ADRRP_Symptom,
		ADRRP_OtherExplanation,ADRRP_ProcessDesc) 
		Values(:adrrRepID,:childSub,:adrTherapMeas,:adrSymptom,:adrOtherExp,:adrProcDesc))
	Q SQLCODE
}

/// Descript:不良反应报告审批流程
ClassMethod InsAdrRepAudit(adrrRepID As %String, adrRepAuditdataList As %String) As %String
{
	N (adrrRepID,adrRepAuditdataList)
	
	S adrAudStatusDr=$p(adrRepAuditdataList,"^",1) //审核状态
	S AuditUserID=$p(adrRepAuditdataList,"^",2)    //审核人
	S adrAuditDate=+$h  //$p(adrRepAuditdataList,"^",3)   //审核日期
	S adrAuditTime=$p($h,",",2) //$p(adrRepAuditdataList,"^",4)   //审核时间
	S childSub=$o(^DHCPHADRR(adrrRepID,"ADRRA",""),-1)+1
	&SQL(Insert into DHC_PHAdrRepAudit(ADRRA_ADRR_Parref,ADRRA_ChildSub,ADRRA_Status_DR,ADRRA_AuditUser_DR,
		ADRRA_AuditDate,ADRRA_AuditTime) 
		Values(:adrrRepID,:childSub,:adrAudStatusDr,:AuditUserID,:adrAuditDate,:adrAuditTime))
	Q SQLCODE
}

/// Descript:保存不良反应相关药品
ClassMethod InsAdrRepDrugItm(adrrRepID As %String, adrRepItmStr As %String) As %String
{
	N (adrrRepID,adrRepItmStr)
	S Len=$L(adrRepItmStr,"!!")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S tmpStr=$p(adrRepItmStr,"!!",i)
	.S type=$p(tmpStr,"^",1)   //类型
	.S oeori=$p(tmpStr,"^",2)  //医嘱ID
	.S phcid=$p(tmpStr,"^",3)     //药学项ID
	.S apprdocu=$p(tmpStr,"^",4)  //批准文号
	.S goodname=$p(tmpStr,"^",5)  //商品名称
	.S genericdr=$p(tmpStr,"^",6) //通用名
	.S phformdr=$p(tmpStr,"^",7)  //剂型
	.S manfdr=$p(tmpStr,"^",8)    //生产厂家
	.S productno=$p(tmpStr,"^",9) //生产批号
	.S dosage=+$p(tmpStr,"^",10)    //剂量
	.S dosuomdr=$p(tmpStr,"^",11)  //剂量单位
	.S instrucdr=$p(tmpStr,"^",12) //途径(用法)
	.S freqdr=$p(tmpStr,"^",13)    //日次数(频次)
	.S startdate=$p(tmpStr,"^",14) //用药起始日期
	.S:startdate'="" startdate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(startdate) ;$zdh(startdate,3)
	.S starttime=""
	.S enddate=$p(tmpStr,"^",15)   //用药结束日期
	.S:enddate'="" enddate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(enddate) ;$zdh(enddate,3)
	.S endtime=""
	.S reasondr=$p(tmpStr,"^",16)  //用药原因
	.S reason=$p(tmpStr,"^",17)    //用药原因(手写)
	.S childSub=$o(^DHCPHADRR(adrrRepID,"ADRRDI",""),-1)+1
	.
	.&SQL(Insert into DHC_PHAdrRepDrugItm(ADRRDI_ADRR_Parref,ADRRDI_ChildSub,ADRRDI_Type,ADRRDI_OEORI_DR,ADRRDI_ApprDocu,
		ADRRDI_PHCD_DR,ADRRDI_GoodsName,ADRRDI_Generic_DR,ADRRDI_PhForm_DR,ADRRDI_Manf_DR,ADRRDI_ProductNo,ADRRDI_Dosage,
		ADRRDI_DosUom_DR,ADRRDI_Instruc_DR,ADRRDI_Freq_DR,ADRRDI_StartDate,ADRRDI_StartTime,ADRRDI_EndDate,ADRRDI_EndTime,
		ADRRDI_Reason_DR,ADRRDI_Reason) 
		Values(:adrrRepID,:childSub,:type,:oeori,:apprdocu,:phcid,:goodname,:genericdr,:phformdr,:manfdr,:productno,
		:dosage,:dosuomdr,:instrucdr,:freqdr,:startdate,:starttime,:enddate,:endtime,:reasondr,:reason))
	.i SQLCODE'=0 S quitflag="1"
	.b
	Q quitflag
}

/// Descript:保存不良反应报告事件信息
ClassMethod InsAdrRepEvent(adrrRepID As %String, adrRepEvtItems As %String) As %String
{
	N (adrrRepID,adrRepEvtItems)
	S Len=$L(adrRepEvtItems,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S adrEvtItms=$p(adrRepEvtItems,"||",i)
	.S addrEvtDr=$p(adrEvtItms,"^",1)       //事件代码
	.S addrEvtDesc=$p(adrEvtItms,"^",2)     //事件描述
	.S childSub=$o(^DHCPHADRR(adrrRepID,"ADRRE",""),-1)+1
	.&SQL(Insert into DHC_PHAdrRepEvent(ADRRE_ADRR_Parref,ADRRE_ChildSub,ADRRE_ADRE_DR,ADRRE_Desc)
		Values(:adrrRepID,:childSub,:addrEvtDr,:addrEvtDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除不良反应报告表
ClassMethod DelAdrReport(adrRepID As %String) As %String
{
	N (adrRepID)
	&SQL(DELETE DHC_PHAdrReport WHERE ADRR_RowID=:adrRepID)
	Q SQLCODE
}

/// Descript:删除不良反应相关信息表
ClassMethod DelAdrRelatInfo(adrRepID As %String) As %String
{
	n (adrRepID)
	//患者相关重要信息
	i $d(^DHCPHADRR(adrRepID,"ADRRII",1)) d
	.&SQL(DELETE DHC_PHAdrRepImpInfo WHERE ADRRI_ADRR_Parref=:adrRepID)
	q:+$g(SQLCODE)'=0 SQLCODE
	//患者诊断信息
	i $d(^DHCPHADRR(adrRepID,"ADRRD",1)) d
	.&SQL(DELETE DHC_PHAdrRepDiag WHERE ADRRD_ADRR_Parref=:adrRepID)
	q:+$g(SQLCODE)'=0 SQLCODE
	//过程描述
	i $d(^DHCPHADRR(adrRepID,"ADRRP",1)) d
	.&SQL(DELETE DHC_PHAdrRepProc WHERE ADRRP_ADRR_Parref=:adrRepID)
	q:+$g(SQLCODE)'=0 SQLCODE
	//药品明细
	i $d(^DHCPHADRR(adrRepID,"ADRRDI",1)) d
	.&SQL(DELETE DHC_PHAdrRepDrugItm WHERE ADRRDI_ADRR_Parref=:adrRepID)
	q:+$g(SQLCODE)'=0 SQLCODE
	//不良反应事件
	i $d(^DHCPHADRR(adrRepID,"ADRRE",1)) d
	.&SQL(DELETE DHC_PHAdrRepEvent WHERE ADRRE_ADRR_Parref=:adrRepID)
	q:+$g(SQLCODE)'=0 SQLCODE
	q 0
}

/// Descript:保存不良反应报表
ClassMethod Insert(adrRepDataList As %String, adrRepImpInfodataList As %String, adrRepItmStr As %String, adrRepMRCICItms As %String, adrRepEvtItems As %String, adrrEvtProcessDesc As %String, adrRepAuditList As %String) As %String
{
	N (adrRepDataList,adrRepImpInfodataList,adrRepItmStr,adrRepMRCICItms,adrRepEvtItems,adrrEvtProcessDesc,adrRepAuditList)
	s Err=0

	TS
	s adrrepID=..InsAdrReport(adrRepDataList)
	i adrrepID<0 tro
	q:adrrepID<0 adrrepID

	//保存患者相关重要信息
	i adrRepImpInfodataList'="" d
	.s Err=..InsAdrRepImpInfo(adrrepID,adrRepImpInfodataList)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	//保存不良反应报告患者诊断信息
	i adrRepMRCICItms'="" d
	.s Err=..InsAdrRepDiag(adrrepID,adrRepMRCICItms)
	i Err'=0 tro
	q:Err'=0 "-13"
	
	//不良反应报告过程描述
	i adrrEvtProcessDesc'="" d
	.s Err=..InsAdrRepProc(adrrepID,adrrEvtProcessDesc)
	i Err'=0 tro
	q:Err'=0 "-14"
	
	//不良反应报告药品明细
	i adrRepItmStr'="" d
	.s Err=..InsAdrRepDrugItm(adrrepID,adrRepItmStr)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	//不良反应事件信息
	i adrRepEvtItems'="" d
	.s Err=..InsAdrRepEvent(adrrepID,adrRepEvtItems)
	i Err'=0 tro
	q:Err'=0 "-16"
	
	
	//不良反应报告审批流程[默认插入初始状态]
	i adrRepAuditList'="" d
	.s Err=..InsAdrRepAudit(adrrepID,adrRepAuditList)
	i Err'=0 tro
	q:Err'=0 "-17"
	
	TC
	S adrRepNo=$p(^DHCPHADRR(adrrepID),"^",1)   //编号
	Q "0^"_adrrepID_"^"_adrRepNo
}

/// Descript:保存不良反应报表
ClassMethod Update(adrrepID As %String, adrRepDataList As %String, adrRepImpInfodataList As %String, adrRepItmStr As %String, adrRepMRCICItms As %String, adrRepEvtItems As %String, adrrEvtProcessDesc As %String, adrRepAuditList As %String) As %String
{
	N (adrrepID,adrRepDataList,adrRepImpInfodataList,adrRepItmStr,adrRepMRCICItms,adrRepEvtItems,adrrEvtProcessDesc,adrRepAuditList)
	s Err=0

	TS
	s adrrepID=..UpdAdrReport(adrrepID,adrRepDataList)
	i adrrepID<0 tro
	q:adrrepID<0 adrrepID
	
	//删除相关子表
	s Err=..DelAdrRelatInfo(adrrepID)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//保存患者相关重要信息
	i adrRepImpInfodataList'="" d
	.s Err=..InsAdrRepImpInfo(adrrepID,adrRepImpInfodataList)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	//保存不良反应报告患者诊断信息
	i adrRepMRCICItms'="" d
	.s Err=..InsAdrRepDiag(adrrepID,adrRepMRCICItms)
	i Err'=0 tro
	q:Err'=0 "-13"
	
	//不良反应报告过程描述
	i adrrEvtProcessDesc'="" d
	.s Err=..InsAdrRepProc(adrrepID,adrrEvtProcessDesc)
	i Err'=0 tro
	q:Err'=0 "-14"
	
	//不良反应报告药品明细
	i adrRepItmStr'="" d
	.s Err=..InsAdrRepDrugItm(adrrepID,adrRepItmStr)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	//不良反应事件信息
	i adrRepEvtItems'="" d
	.s Err=..InsAdrRepEvent(adrrepID,adrRepEvtItems)
	i Err'=0 tro
	q:Err'=0 "-16"
	
	//不良反应报告审批流程[默认插入初始状态]
	i adrRepAuditList'="" d
	.s Err=..InsAdrRepAudit(adrrepID,adrRepAuditList)
	i Err'=0 tro
	q:Err'=0 "-17"
	
	TC
	S adrRepNo=$p(^DHCPHADRR(adrrepID),"^",1)   //编号
	Q "0^"_adrrepID_"^"_adrRepNo
}

// w ##class(web.DHCSTPHCMADRREPORT).SaveAdrEvent("","","","","","","","")

/// Descript:保存不良反应报表
ClassMethod SaveAdrEvent(adrRepID As %String, adrRepDataList As %String, adrRepImpInfodataList As %String, adrRepItmStr As %String, adrRepMRCICItms As %String, adrRepEvtItems As %String, adrrEvtProcessDesc As %String, adrRepAuditList As %String) As %String
{
	n (adrRepID,adrRepDataList,adrRepImpInfodataList,adrRepItmStr,adrRepMRCICItms,adrRepEvtItems,adrrEvtProcessDesc,adrRepAuditList)
	s ret=0
	;s ^tlq("1")=adrRepDataList
	;s ^tlq("2")=adrRepImpInfodataList
	;s ^tlq("3")=adrRepItmStr
	;s ^tlq("4")=adrRepMRCICItms
	;s ^tlq("5")=adrRepEvtItems
	;s ^tlq("6")=adrrEvtProcessDesc
	;s ^tlq("7")=adrRepAuditList
	;s adrRepDataList="^10^^10^^4^RR^2^19岁^1996-11-06^1^^1^0000000004^^^^^^2015-11-09^10^^^^10^10^10^10^孙凤霞^10^^24^10^^42^北京地坛医院^孙凤霞^^2015-11-09^^^^^^28^6"
	;s adrRepImpInfodataList="||||||||||||^"
	;s adrRepItmStr="10^4||1^1034||1^国药准字H37022973-^维生素AD滴剂(胶囊型)[伊可欣][A1500:D500iu*20粒]^942^5^324^^1粒^19^2^4^2015-11-06^2015-11-06^^3!!11^4||2^1089||1^国药准字H22021054^氯化钠注射液[东宝][0.9%100ml]^482^43^337^^100ml^20^8^4^2015-11-06^2015-11-02^^4"
	;s adrRepMRCICItms="^1.咳嗽"
	;s adrRepEvtItems="1^药品不良反应/事件报告[一般]"
	;s adrrEvtProcessDesc="^^^4"
	;s adrRepAuditList="28^359"
	
	i adrRepID="" d
	.S ret=..Insert(adrRepDataList,adrRepImpInfodataList,adrRepItmStr,adrRepMRCICItms,adrRepEvtItems,adrrEvtProcessDesc,adrRepAuditList)
	e  d
	.S ret=..Update(adrRepID,adrRepDataList,adrRepImpInfodataList,adrRepItmStr,adrRepMRCICItms,adrRepEvtItems,adrrEvtProcessDesc,adrRepAuditList)
	q ##class(web.DHCSTPHCMCOMMON).getJsonData("ErrCode^AdrRepID^AdrRepCode",ret)
}

/// Descript:获取不良反应报告药品信息
/// w ##class(web.DHCSTPHCMADRREPORT).getAdrRepDrgItm("10","102")
ClassMethod getAdrRepDrgItm(intype As %String, adrRepID As %String) As %String
{
	N (intype,adrRepID)

	S pid=..NewPid()
	d ..killTmpGlobal(pid)

	S Num=0
	S ch=""
	F  S ch=$o(^DHCPHADRR(adrRepID,"ADRRDI",ch)) Q:ch=""  D
	.S type=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",1) //类型
	.Q:type'=intype
	.S oeori=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",2) //医嘱ID
	.S apprdocu=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",3) //批准文号
	.S phcddr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",4) //药学项ID
	.S goodsname=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",5) //商品名
	.S genericdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",6) //通用名ID
	.i genericdr'="" S genenic=$p($g(^PHCGE("GE",genericdr)),"^",2) //通用名
	.S formdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",7) //剂型
	.i formdr'=""  s form=$p(^PHCF(formdr),"^",2)
	.S manfdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",8) //产地
	.S:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
	.S:manf["-" manf=$p(manf,"-",2)
	.S productno=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",9) //批号
	.S dosage=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",10) //剂量
	.S:$p(dosage,".")="" dosage=0_dosage
	.S dosageuomdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",11) //剂量单位
	.i dosageuomdr'="" S doseuom=$p($g(^CT("UOM",dosageuomdr)),"^",2)
	.S instrucdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",12) //用法
	.i formdr'="" S instru=$p($g(^PHCIN(instrucdr)),"^",2)
	.S freqdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",13) //频次
	.i freqdr'="" S freq=$p($g(^PHCFR(freqdr)),"^",3)
	.S startdate=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",14)  //开始日期
	.S:startdate'="" startdate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(startdate)  ;$zd(startdate,3)
	.//S starttime=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",15)  //开始时间
	.//S starttime=$zdh(startdate,3)_" "_$zt(starttime,3)
	.S enddate=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",16)  //结束日期
	.S:enddate'="" enddate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(enddate) ;$zd(enddate,3)
	.//S endtime=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",17)  //结束时间
	.//S endtime=$zdh(enddate,3)_" "_$zt(endtime,1)
	.S reason=""
	.S reasondr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",18)  //原因ID
	.i reasondr'="" S reason=$p(^DHCPHADRRM(reasondr),"^",2)
	.i reasondr=""  S reason=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",19)  //原因
	.S dgID=$S(type="10":"susdrgdg",type="11":"blenddg")
	.S ListData=oeori_"^"_apprdocu_"^"_phcddr_"^"_goodsname_"^"_manfdr_"^"_$g(manf)_"^"_formdr
	.S ListData=ListData_"^"_genericdr_"^"_$g(genenic)_" "_$g(form)_"^"_dosage_$g(doseuom)_"/"_$g(instru)_"/"_$g(freq)_"^"_instrucdr_"^"_freqdr
	.S ListData=ListData_"^"_dosageuomdr_"^"_startdate_"^"_enddate_"^"_reasondr_"^"_$g(reason)_"^"_productno_"^"_dgID
	.
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCSTPHCMADRREPORT","getAdrRepDrgItm",pid,Num)=ListData
	
	i 4>Num d
	.S Len=4-Num
	.f i=1:1:Len d
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTPHCMADRREPORT","getAdrRepDrgItm",pid,Num)=""

	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMADRREPORT","getAdrRepDrgItm",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMADRREPORT","getAdrRepDrgItm",pid,index)
	.S Title="orditm^apprdocu^phcdf^incidesc^manfdr^manf^formdr^genenicdr^genenic^usemethod^instrudr^freqdr^dosuomID^starttime^endtime^reasondr^usereason^batno^dgID"
	.S Num=Num+1
	.//Q:Num<StPage
	.//S:Num=EndPage quitflag=1
	.I Num=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:获取报告信息
ClassMethod getAdrRepInfo(adrRepID As %String) As %String
{
	N (adrRepID)
	Q:'$d(^DHCPHADRR(adrRepID)) ""
	S adrRepNo=$p(^DHCPHADRR(adrRepID),"^",1)   //编号
	S adrRepDate=$p(^DHCPHADRR(adrRepID),"^",2) //日期
	S:adrRepDate'="" adrRepDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(adrRepDate)  ;$zd(adrRepDate,3)
	S adrRepPri=$p(^DHCPHADRR(adrRepID),"^",3)     //优先级
	S adrRepType=$p(^DHCPHADRR(adrRepID),"^",4)     //报告类型
	S adrRepNew=$p(^DHCPHADRR(adrRepID),"^",46)     //是否新的
	S adrrRepTSDesc=$p(^DHCPHADRR(adrRepID),"^",47) //严重情形描述
	S adrrDeptType=$p(^DHCPHADRR(adrRepID),"^",5)   //科室类型
	S adrrDeptElse=$p(^DHCPHADRR(adrRepID),"^",6)   //科室描述
	
	S adrrPatID=$p(^DHCPHADRR(adrRepID),"^",7)       //病人ID
	S adrRepPaAdm=$o(^PAPERdr(adrrPatID,"ADM","I",""),-1)
	S adrrPatName=$p(^DHCPHADRR(adrRepID),"^",8)     //姓名
	S adrrPatSex=$p(^DHCPHADRR(adrRepID),"^",9)      //性别
	S adrrPatAge=$p(^DHCPHADRR(adrRepID),"^",10)     //年龄
	S adrrPatDOB=$p(^DHCPHADRR(adrRepID),"^",11)     //出生日期
	S:adrrPatDOB'="" adrrPatDOB=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(adrrPatDOB) ;$zd(adrrPatDOB,3)
	S adrrPatNation=$p(^DHCPHADRR(adrRepID),"^",12)  //民族
	S adrrPatWeight=$p(^DHCPHADRR(adrRepID),"^",13)  //体重
	S adrrPatContact=$p(^DHCPHADRR(adrRepID),"^",14) //联系方式
	S adrrPatMedNo=$p(^DHCPHADRR(adrRepID),"^",15)   //病历号
	
	S adrrEvtHis=$p(^DHCPHADRR(adrRepID),"^",16)     //既往药品不良反应/事件
	S adrrEvtHisDesc=$p(^DHCPHADRR(adrRepID),"^",17) //既往药品不良反应/事件描述
	S adrrEvtFam=$p(^DHCPHADRR(adrRepID),"^",18)     //家族药品不良反应/事件
	S adrrEvtFamDesc=$p(^DHCPHADRR(adrRepID),"^",19) //家族药品不良反应/事件描述
	S adrrEvtDateOcc=$p(^DHCPHADRR(adrRepID),"^",21) //事件发生日期
	S:adrrEvtDateOcc'="" adrrEvtDateOcc=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(adrrEvtDateOcc) ;$zd(adrrEvtDateOcc,3)
	S adrrEvtRes=$p(^DHCPHADRR(adrRepID),"^",22)     //事件结果
	S adrrEvtResDesc=$p(^DHCPHADRR(adrRepID),"^",23) //事件结果描述
	
	S adrrEvtDRes=$p(^DHCPHADRR(adrRepID),"^",24)    //死亡/好转 日期
	S:adrrEvtDRes'="" adrrEvtDRes=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(adrrEvtDRes)  ;$zd(adrrEvtDRes,3)
	S adrrEvtTRes=$p(^DHCPHADRR(adrRepID),"^",25)    //死亡/好转 时间
	S:adrrEvtTRes'="" adrrEvtTRes=$zt(adrrEvtTRes,1)
	S adrrEvtSRes=$p(^DHCPHADRR(adrRepID),"^",26)    //是否停止使用
	S adrrEvtTakAg=$p(^DHCPHADRR(adrRepID),"^",27)   //是否再次使用
	S adrrEvtEff=$p(^DHCPHADRR(adrRepID),"^",28)     //对原患疾病的影响
	S adrrEvtCUser=$p(^DHCPHADRR(adrRepID),"^",29)   //报告人评价
	S adrrEvtRepUser=$p(^DHCPHADRR(adrRepID),"^",30) //报告人
	S adrrEvtCDept=$p(^DHCPHADRR(adrRepID),"^",31)   //报告单位评价
	S adrrEvtRepDept=$p(^DHCPHADRR(adrRepID),"^",32) //单位签字
	
	S adrrEvtUserOfRepTel=$p(^DHCPHADRR(adrRepID),"^",33) //电话
	S adrrEvtCarOfRepUser=$p(^DHCPHADRR(adrRepID),"^",34) //职业
	S adrrEvtCarOfRepElse=$p(^DHCPHADRR(adrRepID),"^",35) //其他
	S adrrEvtEOfRepUser=$p(^DHCPHADRR(adrRepID),"^",36)   //E-mail
	S Hosptial=$p(^DHCPHADRR(adrRepID),"^",41)  		  //报告单位
	s HospID = ""
	s:Hosptial'="" HospID = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hosptial),""))
	S adrrEvtProDeptCon=$p(^DHCPHADRR(adrRepID),"^",42)   //单位联系人
	S adrrEvtProDeptTel=$p(^DHCPHADRR(adrRepID),"^",43)   //单位电话
	S adrrEvtRemark=$p(^DHCPHADRR(adrRepID),"^",44) 	  //备注
	S adrrEvtCurStatDR=$p(^DHCPHADRR(adrRepID),"^",45)    //当前状态
	s adrrEvtProDeptID=+$p(^DHCPHADRR(adrRepID),"^",37)  //报告科室
	s adrrEvtProDeptName=$p($g(^CTLOC(adrrEvtProDeptID)),"^",2)
	
	S adrrEvtInitStatDR=$o(^DHCPHADRS(0)) //初始状态
	
	S adrRepDiag=..getAdrRepDiag(adrRepID) //原患疾病
	S adrRepEvent=..getAdrRepEvent(adrRepID) //不良反应报告
	S adrRepImpInfo=..getAdrRepImpInfo(adrRepID) //相关重要信息
	S adrRepProcDesc=..getAdrRepProcDesc(adrRepID) //不良反应过程描述

	s ListData=adrRepID_"!"_adrRepNo_"!"_adrRepPri_"!"_adrRepNew_"!"_adrRepType_"!"_adrrRepTSDesc_"!"_adrrDeptType_"!"_adrrDeptElse
	s ListData=ListData_"!"_adrrPatID_"!"_adrrPatName_"!"_adrrPatSex_"!"_adrrPatAge_"!"_adrrPatDOB_"!"_adrrPatNation_"!"_adrrPatWeight
	s ListData=ListData_"!"_adrrPatContact_"!"_adrrPatMedNo_"!"_adrrEvtHis_"!"_adrrEvtHisDesc_"!"_adrrEvtFam_"!"_adrrEvtFamDesc_"!"_adrrEvtDateOcc
	s ListData=ListData_"!"_adrrEvtRes_"!"_adrrEvtResDesc_"!"_adrrEvtDRes_"!"_adrrEvtTRes_"!"_adrrEvtSRes_"!"_adrrEvtTakAg_"!"_adrrEvtEff
	s ListData=ListData_"!"_adrrEvtCUser_"!"_adrrEvtRepUser_"!"_adrrEvtCDept_"!"_adrrEvtRepDept_"!"_adrrEvtUserOfRepTel_"!"_adrrEvtCarOfRepUser
	s ListData=ListData_"!"_adrrEvtCarOfRepElse_"!"_adrrEvtEOfRepUser_"!"_adrrEvtProDeptName_"!"_adrrEvtProDeptID_"!"_adrrEvtProDeptCon_"!"_adrrEvtProDeptTel_"!"_adrrEvtRemark
	s ListData=ListData_"!"_adrRepDate_"!"_adrRepPaAdm_"!"_Hosptial_"!"_HospID_"!"_adrrEvtInitStatDR_"!"_adrrEvtCurStatDR_"!"_adrRepDiag_"!"_adrRepEvent_"!"_adrRepImpInfo_"!"_adrRepProcDesc
 
 	s ListTitle="adrRepID!adrRepNo!adrRepPri!adrRepNew!adrRepType!adrrRepTSDesc!adrrDeptType!adrrDeptElse!adrrPatID!adrrPatName!adrrPatSex!adrrPatAge!adrrPatDOB!adrrPatNation!adrrPatWeight"
	s ListTitle=ListTitle_"!adrrPatContact!adrrPatMedNo!adrrEvtHis!adrrEvtHisDesc!adrrEvtFam!adrrEvtFamDesc!adrrEvtDateOcc!adrrEvtRes!adrrEvtResDesc!adrrEvtDRes!adrrEvtTRes!adrrEvtSRes!adrrEvtTakAg!adrrEvtEff"
	s ListTitle=ListTitle_"!adrrEvtCUser!adrrEvtRepUser!adrrEvtCDept!adrrEvtRepDept!adrrEvtUserOfRepTel!adrrEvtCarOfRepUser!adrrEvtCarOfRepElse!adrrEvtEOfRepUser!adrrEvtProDeptName!adrrEvtProDeptID!adrrEvtProDeptCon!adrrEvtProDeptTel!adrrEvtRemark"
	s ListTitle=ListTitle_"!adrRepDate!adrRepPaAdm!Hosptial!HospID!adrrEvtInitStatDR!adrrEvtCurStatDR!adrRepDiagList!adrRepDiagDesc!adrRepEvtList!adrRepEvtDesc!adrRepImpInfo!adrRepProcDesc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData,"!")
 	q ""
}

/// Descript:获取原患疾病
ClassMethod getAdrRepDiag(adrRepID) As %String
{
	N (adrRepID)
	S tmpStr="",tmpDescStr=""
	S ch=""
	F  S ch=$o(^DHCPHADRR(adrRepID,"ADRRD",ch)) Q:ch=""  D
	.S adrEvtDiagDr=$p(^DHCPHADRR(adrRepID,"ADRRD",ch),"^",1)
	.S adrEvtDiagDesc=$p(^DHCPHADRR(adrRepID,"ADRRD",ch),"^",2) //描述
	.
	.I tmpDescStr="" S tmpDescStr=adrEvtDiagDesc
	.E  S tmpDescStr=tmpDescStr_","_adrEvtDiagDesc
	.I tmpStr="" S tmpStr=adrEvtDiagDr_"^"_adrEvtDiagDesc
	.E  S tmpStr=tmpStr_"||"_adrEvtDiagDr_"^"_adrEvtDiagDesc
	Q tmpStr_"!"_tmpDescStr
}

/// Descript:获取不良反应报告
ClassMethod getAdrRepEvent(adrRepID) As %String
{
	N (adrRepID)
	S tmpStr="",tmpDescStr=""
	S ch=""
	F  S ch=$o(^DHCPHADRR(adrRepID,"ADRRE",ch)) Q:ch=""  D
	.S adrEvtDr=$p(^DHCPHADRR(adrRepID,"ADRRE",ch),"^",1)
	.S adrEvtRepDesc=$p(^DHCPHADRR(adrRepID,"ADRRE",ch),"^",2) //描述
	.
	.I tmpDescStr="" S tmpDescStr=adrEvtRepDesc
	.E  S tmpDescStr=tmpDescStr_","_adrEvtRepDesc
	.I tmpStr="" S tmpStr=adrEvtDr_"^"_adrEvtRepDesc
	.E  S tmpStr=tmpStr_"||"_adrEvtDr_"^"_adrEvtRepDesc
	Q tmpStr_"!"_tmpDescStr
}

/// Descript:不良反应过程描述
ClassMethod getAdrRepProcDesc(adrRepID) As %String
{
	N (adrRepID)
	S ch=$o(^DHCPHADRR(adrRepID,"ADRRP",""))
	Q:ch="" ""
	S adrTherapMeas=$p(^DHCPHADRR(adrRepID,"ADRRP",ch),"^",1)
	S adrSymptom=$p(^DHCPHADRR(adrRepID,"ADRRP",ch),"^",2)
	S adrOtherExp=$p(^DHCPHADRR(adrRepID,"ADRRP",ch),"^",3)
	S adrProcDesc=$p(^DHCPHADRR(adrRepID,"ADRRP",ch),"^",4)
	Q adrTherapMeas_"^"_adrSymptom_"^"_adrOtherExp_"^"_adrProcDesc
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMADRREPORT","QueryAdrReport",pid)
	k ^TMP("DHCST","web.DHCSTPHCMADRREPORT","getAdrRepDrgItm",pid)
	k ^TMP("DHCST","web.DHCSTPHCMADRREPORT","QueryAuditLog",pid)
	k ^TMP("DHCST","web.DHCSTPHCMADRREPORT","getBatNoList",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMADRREPORT"))
}

/// Descript:获取病人基本就诊信息
/// w ##class(web.DHCSTPHCMADRREPORT).GetPatEssInfo("646","1602")
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
	s nationdr=$p(^PAPER(PatientID,"PER",2),"^",1) //民族
	s nation=""
	i nationdr'="" s nation=$p(^CT("NAT",nationdr),"^",2)
	i birthday'="" s birthday=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(birthday) ;$zd(birthday,3)
	s patAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  //年龄
	s natplace=""    //籍贯
	s patWeight=##class(web.DHCSTCNTSCOMMON).GetPatWeight(EpisodeID) //体重
	s patHeight=##class(web.DHCSTCNTSCOMMON).GetPatHeight(EpisodeID) //身高
	s patTel=$p($g(^PAPER(PatientID,"PER",1)),"^",11)     //电话
	s idcard=""      //身份证
	s workunit=""    //工作单位
	s medicalNo=patNo //##Class(web.DHCWMRService).IGetMrNoByEpisodeID(AdmDr) //病案号
	
	s AdmLoc=""
	s AdmLocID=$p(^PAADM(EpisodeID),"^",4) //科室
	s:AdmLocID'="" AdmLoc=$p($p(^CTLOC(AdmLocID),"^",2),"-",2)
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
	s AdmTime=AdmDate_" "_AdmTime
	S PayType=..PayType(EpisodeID) //费别  nisijia 2016-09-22
	s patdiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") //诊断
	s allergy=""  //过敏史
	s sysdate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(+$h) ;$zd(+$h,3)
	
	s adrrEvtInitStatDR=$o(^DHCPHADRS(0)) //初始状态

	s ListData=PatientID_"^"_EpisodeID_"^"_patNo_"^"_patName_"^"_sexId_"^"_patSex_"^"_patAge
	s ListData=ListData_"^"_birthday_"^"_nationdr_"^"_nation_"^"_medicalNo_"^"_natplace_"^"_patWeight
	s ListData=ListData_"^"_patHeight_"^"_patTel_"^"_workunit_"^"_idcard_"^"_patdiag_"^"_allergy
	s ListData=ListData_"^"_AdmDoc_"^"_AdmLoc_"^"_AdmWard_"^"_AdmBed_"^"_AdmTime_"^"_sysdate_"^"_adrrEvtInitStatDR_"^"_AdmDate_"^"_PayType
	
	s ListTitle="PatientID^EpisodeID^patno^patname^sexId^patsex^patage^patdob^nationdr^nation^medicalNo^native^weight^height^modphone^workunit^idcard^patdiag^allergy" 
	s ListTitle=ListTitle_"^doctor^admloc^admward^admbed^admdate^sysdate^adrrEvtInitStatDR^admdate^paytype"
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:	病人费用类型  nisijia 
ClassMethod PayType(EpisodeID As %String) As %String
{
	N (EpisodeID)
	Q:EpisodeID="" ""
	S PayTypeDR=$p($g(^PAADM(EpisodeID,1)),"^",7)
	Q:(PayTypeDR="") ""
	S PayType=$p($g(^PAC("ADMREA",PayTypeDR)),"^",2)
	Q PayType
}

/// Descript:获取相关重要信息
ClassMethod getAdrRepImpInfo(adrRepID) As %String
{
	N (adrRepID)
	S tmpStr="",tmpDescStr=""
	S ch=""
	F  S ch=$o(^DHCPHADRR(adrRepID,"ADRRII",ch)) Q:ch=""  D
	.S adrRepIIDr=$p(^DHCPHADRR(adrRepID,"ADRRII",ch),"^",1)
	.S adrRepIIDesc=$p(^DHCPHADRR(adrRepID,"ADRRII",ch),"^",2) //描述
	.S adrRepIICode=""
	.i $d(^DHCPHADRII(adrRepIIDr)) D
	..S adrRepIICode=$p(^DHCPHADRII(adrRepIIDr),"^",1)
	..S adrRepIIDesc=$p(^DHCPHADRII(adrRepIIDr),"^",2)
	.S:adrRepIICode="" adrRepIICode=adrRepIIDr
	.//S adrRepIIDesc=$p(^DHCPHADRR(adrRepID,"ADRRII",ch),"^",2) //描述
	.
	.I tmpStr="" S tmpStr=adrRepIICode_"^"_adrRepIIDesc
	.E  S tmpStr=tmpStr_"||"_adrRepIICode_"^"_adrRepIIDesc
	Q tmpStr
}

/// Descript:获取相关重要信息
ClassMethod getExportAdrRepImpInfo(adrRepID) As %String
{
	N (adrRepID)
	S tmpStr="",tmpDescStr=""
	S ch=""
	F  S ch=$o(^DHCPHADRR(adrRepID,"ADRRII",ch)) Q:ch=""  D
	.S adrRepIIDr=$p(^DHCPHADRR(adrRepID,"ADRRII",ch),"^",1)
	.S adrRepIIDesc=$p(^DHCPHADRR(adrRepID,"ADRRII",ch),"^",2) //描述
	.S adrRepIICode=""
	.i $d(^DHCPHADRII(adrRepIIDr)) D
	..S adrRepIICode=$p(^DHCPHADRII(adrRepIIDr),"^",1)
	..S adrRepIIDesc=$p(^DHCPHADRII(adrRepIIDr),"^",2)
	.S:adrRepIICode="" adrRepIICode=adrRepIIDr
	.//S adrRepIIDesc=$p(^DHCPHADRR(adrRepID,"ADRRII",ch),"^",2) //描述
	.
	.I tmpStr="" S tmpStr=adrRepIIDesc
	.E  S tmpStr=tmpStr_","_adrRepIIDesc
	Q tmpStr
}

/// Descript:不良反应报告审批
ClassMethod AuditAdrReport(params As %String) As %String
{
	n (params)
	s ListData = ..Audit(params)
	s ListTitle="ErrCode^ErrMsg"
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:不良反应报告审批
ClassMethod Audit(params As %String) As %String
{
	n (params)
	s adrRepID=+$p(params,"^",1)       //不良反应报告ID
	s unitEvaFlag=..CheckAdrRepIfUnitEvaed(adrRepID)
	q:+unitEvaFlag'=1 unitEvaFlag
	s adrAudStatusDr=+$p(params,"^",2)  //审核状态
      //s AuditUserID=+$p(params,"^",3)     //用户ID
	s AuditGroupID=$p(params,"^",3)   //安全组ID     // wangxuejian  2016/11/3  将登陆的用户的信息传进来判断授权的状态
        s AuditLocID=$p(params,"^",4)     //科室ID
        s AuditUserID=$p(params,"^",5)    //用户ID
        s StrParam=AuditGroupID_"^"_AuditLocID_"^"_AuditUserID  
	s adrAuditDate=+$h
	s adrAuditTime=$p($h,",",2)
	s AdrRepStatusID=$p(^DHCPHADRR(adrRepID),"^",45) //当前状态
	q:AdrRepStatusID="" "-1^报告未提交!"
	s NextStatusID=##class(web.DHCSTPHCMCOMMON).getNextStauts("",AdrRepStatusID)
	q:NextStatusID="" "-2^下一状态为空!"
	s StatusGrantID=##class(web.DHCSTPHCMCOMMON).GetUserStatusGrant("",StrParam) //wangxuejian 2016/11/3   获取授权状态
	q:NextStatusID'=StatusGrantID "-3^下一状态不是登录人的授权状态"  //下一状态不是登录人的授权状态时,退出

	ts
	&SQL(update DHC_PHAdrReport set ADRR_CurStatus_DR=:adrAudStatusDr WHERE ADRR_RowID=:adrRepID)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 SQLCODE
	s adrRepAuditdataList=adrAudStatusDr_"^"_AuditUserID_"^"_adrAuditDate_"^"_adrAuditTime
	s retVal=..InsAdrRepAudit(adrRepID,adrRepAuditdataList)
	i retVal'=0 tro
	q:retVal'=0 retVal
	tc
	q 0
}

/// Creator:    bianshuai
/// CreateDate: 2015-02-03
/// Descript:   取当前不良反应报告最大码
ClassMethod GetAdrReportCurMaxNo(Prefix As %String, NoLen As %String) As %String
{
	N (Prefix,NoLen)
	S NextNo=""
	L +^DHCPHCMADR("DHCPHCMADR",Prefix):10 E  Q -100
	S PreLen=$L(Prefix)
	S MinSuffix=1
	F i=1:1:NoLen-1 S MinSuffix="0"_MinSuffix
	S MinNo=Prefix_MinSuffix	//最小码
	S CurLen=PreLen+NoLen	    //单号长度
	///表里记录的最大码
	S CurrMaxNo=..GetMaxCodeByCode(Prefix)
	S CurPrefix=$E(CurrMaxNo,1,PreLen)
	S CurrNo=$E(CurrMaxNo,PreLen+1,CurLen)

	i Prefix'=CurPrefix D
	.S NextNo=MinNo
	.L -^DHCPHCMADR("DHCPHCMADR",Prefix)
	Q:NextNo'="" NextNo

	S Suffix=CurrNo+1
	
	S slen=$L(Suffix)
	S flen=NoLen-slen
	F i=1:1:flen S Suffix="0"_Suffix
	S NextNo=Prefix_Suffix
	L -^DHCPHCMADR("DHCPHCMADR",Prefix)
	Q NextNo
}

/// Descript:获取当前最大码
/// 科室当前处方最编码
ClassMethod GetMaxCodeByCode(Prefix As %String) As %String
{
	N (Prefix)
	Q:Prefix="" ""
	S adrrcode=""
	&sql(select max(ADRR_Code) into :adrrcode from DHC_PHAdrReport Where ADRR_Code %STARTSWITH %ALPHAUP :Prefix)
	Q adrrcode
}

/// Descript:获取报告信息
ClassMethod getAdrRepExportInfo(adrRepID As %String) As %String
{
	N (adrRepID)
	Q:'$d(^DHCPHADRR(adrRepID)) ""
	S adrRepNo=$p(^DHCPHADRR(adrRepID),"^",1)   //编号
	S adrRepDate=$p(^DHCPHADRR(adrRepID),"^",2) //日期
	S:adrRepDate'="" adrRepDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(adrRepDate) ;$zd(adrRepDate,3)
	S adrRepPri=$p(^DHCPHADRR(adrRepID),"^",3)     //优先级
	S adrRepPri=$S(adrRepPri="10":"首次报告",adrRepPri="11":"跟踪报告",1:"")   
	S adrRepType=$p(^DHCPHADRR(adrRepID),"^",4)     //报告类型
	S adrRepType=$S(adrRepType="10":"一般",adrRepType="11":"严重",1:"") 
	S adrRepNew=$p(^DHCPHADRR(adrRepID),"^",46)     //是否新的
	S:adrRepNew="Y" adrRepNew="新的"
	S adrrRepTSDesc=$p(^DHCPHADRR(adrRepID),"^",47) //严重情形描述
	S:adrrRepTSDesc'="" adrRepType=adrRepType_","_adrrRepTSDesc
	S adrrDeptType=$p(^DHCPHADRR(adrRepID),"^",5)   //科室类型
	S adrrDeptType="医疗机构"
	S adrrDeptElse=$p(^DHCPHADRR(adrRepID),"^",6)   //科室描述
	
	S adrrPatID=$p(^DHCPHADRR(adrRepID),"^",7)       //病人ID
	S adrRepPaAdm=$o(^PAPERdr(adrrPatID,"ADM","I",""),-1)
	S adrrPatName=$p(^DHCPHADRR(adrRepID),"^",8)     //姓名
	S adrrPatSex=$p(^DHCPHADRR(adrRepID),"^",9)      //性别
	S:adrrPatSex'="" adrrPatSex=$p(^CT("SEX",adrrPatSex),"^",2)
	S adrrPatAge=$p(^DHCPHADRR(adrRepID),"^",10)     //年龄
	S adrrPatDOB=$p(^DHCPHADRR(adrRepID),"^",11)     //出生日期
	S:adrrPatDOB'="" adrrPatDOB=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(adrrPatDOB) ;$zd(adrrPatDOB,3)
	S adrrPatNation=$p(^DHCPHADRR(adrRepID),"^",12)  //民族
	S:adrrPatNation'="" adrrPatNation=$p(^CT("NAT",adrrPatNation),"^",2)
	S adrrPatWeight=$p(^DHCPHADRR(adrRepID),"^",13)  //体重
	S adrrPatContact=$p(^DHCPHADRR(adrRepID),"^",14) //联系方式
	S adrrPatMedNo=$p(^DHCPHADRR(adrRepID),"^",15)   //病历号
	
	S adrrEvtHis=$p(^DHCPHADRR(adrRepID),"^",16)     //既往药品不良反应/事件
	S adrrEvtHis=$S(adrrEvtHis="10":"无",adrrEvtHis="99":"不详",1:"")
	S adrrEvtHisDesc=$p(^DHCPHADRR(adrRepID),"^",17) //既往药品不良反应/事件描述
	S adrrEvtFam=$p(^DHCPHADRR(adrRepID),"^",18)     //家族药品不良反应/事件
	S adrrEvtFam=$S(adrrEvtFam="10":"无",adrrEvtFam="99":"不详",1:"")
	S adrrEvtFamDesc=$p(^DHCPHADRR(adrRepID),"^",19) //家族药品不良反应/事件描述
	S adrrEvtDateOcc=$p(^DHCPHADRR(adrRepID),"^",21) //事件发生日期
	S:adrrEvtDateOcc'="" adrrEvtDateOcc=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(adrrEvtDateOcc) ;$zd(adrrEvtDateOcc,3)
	S adrrEvtRes=$p(^DHCPHADRR(adrRepID),"^",22)     //事件结果
	S adrrEvtRes=$S(adrrEvtRes="10":"痊愈",adrrEvtRes="11":"好转",adrrEvtRes="12":"未好转",adrrEvtRes="99":"不详",adrrEvtRes="13":"有后遗症",adrrEvtRes="14":"死亡",1:"有")
	S adrrEvtResDesc=$p(^DHCPHADRR(adrRepID),"^",23) //事件结果描述
	
	S adrrEvtDRes=$p(^DHCPHADRR(adrRepID),"^",24)    //死亡/好转 日期
	S:adrrEvtDRes'="" adrrEvtDRes=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(adrrEvtDRes) ;$zd(adrrEvtDRes,3)
	S adrrEvtTRes=$p(^DHCPHADRR(adrRepID),"^",25)    //死亡/好转 时间
	S:adrrEvtTRes'="" adrrEvtTRes=$zt(adrrEvtTRes,1)
	S adrrEvtSRes=$p(^DHCPHADRR(adrRepID),"^",26)    //是否停止使用
	S adrrEvtSRes=$S(adrrEvtSRes="10":"是",adrrEvtSRes="11":"否",adrrEvtSRes="99":"不明",adrrEvtSRes="12":"未停药或未减量",1:"")
	S adrrEvtTakAg=$p(^DHCPHADRR(adrRepID),"^",27)   //是否再次使用
	S adrrEvtTakAg=$S(adrrEvtTakAg="10":"是",adrrEvtTakAg="11":"否",adrrEvtTakAg="99":"不明",adrrEvtTakAg="12":"未再使用",1:"")
	S adrrEvtEff=$p(^DHCPHADRR(adrRepID),"^",28)     //对原患疾病的影响
	S adrrEvtEff=$S(adrrEvtEff="10":"不明显",adrrEvtEff="11":"病程延长",adrrEvtEff="12":"病情加重",adrrEvtEff="13":"导致后遗症",adrrEvtEff="14":"导致死亡",1:"")
	S adrrEvtCUser=$p(^DHCPHADRR(adrRepID),"^",29)   //报告人评价
	S adrrEvtCUser=$S(adrrEvtCUser="10":"肯定",adrrEvtCUser="11":"很可能",adrrEvtCUser="12":"可能",adrrEvtCUser="13":"可能无关",adrrEvtCUser="14":"待评价",adrrEvtCUser="15":"无法评价",1:"")
	S adrrEvtRepUser=$p(^DHCPHADRR(adrRepID),"^",30) //报告人
	S adrrEvtCDept=$p(^DHCPHADRR(adrRepID),"^",31)   //报告单位评价
	S adrrEvtCDept=$S(adrrEvtCDept="10":"肯定",adrrEvtCDept="11":"很可能",adrrEvtCDept="12":"可能",adrrEvtCDept="13":"可能无关",adrrEvtCDept="14":"待评价",adrrEvtCDept="15":"无法评价",1:"")
	S adrrEvtRepDept=$p(^DHCPHADRR(adrRepID),"^",32) //单位签字
	
	S adrrEvtUserOfRepTel=$p(^DHCPHADRR(adrRepID),"^",33) //电话
	S adrrEvtCarOfRepUser=$p(^DHCPHADRR(adrRepID),"^",34) //职业
	S adrrEvtCarOfRepUser=$S(adrrEvtCarOfRepUser="10":"医生",adrrEvtCarOfRepUser="11":"药师",adrrEvtCarOfRepUser="12":"护士",1:"")
	S adrrEvtCarOfRepElse=$p(^DHCPHADRR(adrRepID),"^",35) //其他
	S adrrEvtEOfRepUser=$p(^DHCPHADRR(adrRepID),"^",36)   //E-mail
	S adrrEvtProDeptName=$p(^DHCPHADRR(adrRepID),"^",41)  //报告单位
	S adrrEvtProDeptCon=$p(^DHCPHADRR(adrRepID),"^",42)   //单位联系人
	S adrrEvtProDeptTel=$p(^DHCPHADRR(adrRepID),"^",43)   //单位电话
	S adrrEvtRemark=$p(^DHCPHADRR(adrRepID),"^",44) 	  //备注
	S adrrEvtCurStatDR=$p(^DHCPHADRR(adrRepID),"^",45)    //当前状态
	s LocID=$p(^DHCPHADRR(adrRepID),"^",37)     //报告科室
	I LocID'="" D
	.S LocDesc=$p(^CTLOC(LocID),"^",2)
	S adrrEvtInitStatDR=$o(^DHCPHADRS(0)) //初始状态
	
	S adrRepDiag=..getAdrRepDiag(adrRepID) //原患疾病
	S adrRepDiag=$p(adrRepDiag,"!",2)
	//S adrRepDiag=$tr(adrRepDiag,"^","")
	//S adrRepDiag=$REPLACE(adrRepDiag,"||",",")
	S adrRepEvent=..getAdrRepEvent(adrRepID) //不良反应报告
	S adrRepEvent=$p(adrRepEvent,"!",2)
	//S adrRepEvent=$tr(adrRepEvent,"^","")
	//S adrRepEvent=$REPLACE(adrRepEvent,"||",",")
	S adrRepImpInfo=..getExportAdrRepImpInfo(adrRepID) //相关重要信息
	//S adrRepImpInfo=$tr(adrRepImpInfo,"^","")
	//S adrRepImpInfo=$REPLACE(adrRepImpInfo,"||",",")
	S adrRepProcDesc=..getAdrRepProcDesc(adrRepID) //不良反应过程描述
	S adrRepProcDesc=$tr(adrRepProcDesc,"^","")
	S adrRepDrgItm=..getAdrReportExport(adrRepID)  //不良反应过程药品信息

	S adrRepDataList=adrRepID_"&&"_adrRepNo_"&&"_adrRepPri_"&&"_adrRepNew_"&&"_adrRepType_"&&"_adrrRepTSDesc_"&&"_adrrDeptType_"&&"_adrrDeptElse
	S adrRepDataList=adrRepDataList_"&&"_adrrPatID_"&&"_adrrPatName_"&&"_adrrPatSex_"&&"_adrrPatAge_"&&"_adrrPatDOB_"&&"_adrrPatNation_"&&"_adrrPatWeight
	S adrRepDataList=adrRepDataList_"&&"_adrrPatContact_"&&"_adrrPatMedNo_"&&"_adrrEvtHis_"&&"_adrrEvtHisDesc_"&&"_adrrEvtFam_"&&"_adrrEvtFamDesc_"&&"_adrrEvtDateOcc
	S adrRepDataList=adrRepDataList_"&&"_adrrEvtRes_"&&"_adrrEvtResDesc_"&&"_adrrEvtDRes_"&&"_adrrEvtTRes_"&&"_adrrEvtSRes_"&&"_adrrEvtTakAg_"&&"_adrrEvtEff
	S adrRepDataList=adrRepDataList_"&&"_adrrEvtCUser_"&&"_adrrEvtRepUser_"&&"_adrrEvtCDept_"&&"_adrrEvtRepDept_"&&"_adrrEvtUserOfRepTel_"&&"_adrrEvtCarOfRepUser
	S adrRepDataList=adrRepDataList_"&&"_adrrEvtCarOfRepElse_"&&"_adrrEvtEOfRepUser_"&&"_adrrEvtProDeptName_"&&"_adrrEvtProDeptCon_"&&"_adrrEvtProDeptTel_"&&"_adrrEvtRemark
	S adrRepDataList=adrRepDataList_"&&"_adrRepDate_"&&"_adrRepPaAdm_"&&"_LocDesc_"&&"_LocID_"&&"_adrrEvtInitStatDR_"&&"_adrrEvtCurStatDR_"&&"_adrRepDiag_"&&"_adrRepEvent_"&&"_adrRepImpInfo_"&&"_adrRepProcDesc_"&&"_adrRepDrgItm
 Q adrRepDataList
}

/// Descript:获取导出药品信息
ClassMethod getAdrReportExport(adrRepID As %String) As %String
{
		
	N (adrRepID)
	Q:'$d(^DHCPHADRR(adrRepID)) ""
	S adrRepDrgStr=""
	S ch=""
	F  S ch=$o(^DHCPHADRR(adrRepID,"ADRRDI",ch)) Q:ch=""  D
	.S type=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",1) //类型
	.S type=$S(type="10":"怀疑",type="11":"并用",1:"")
	.S oeori=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",2) //医嘱ID
	.S apprdocu=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",3) //批准文号
	.S phcddr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",4) //药学项ID
	.S goodsname=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",5) //商品名
	.S goodsname=$p(goodsname,"(",1)
	.S genericdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",6) //通用名ID
	.i genericdr'="" S genenic=$p($g(^PHCGE("GE",genericdr)),"^",2) //通用名
	.S formdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",7) //剂型
	.i formdr'=""  s form=$p(^PHCF(formdr),"^",2)
	.S form=$tr(form,$C(13,10))
	.S manfdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",8) //产地
	.S:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
	.S:manf["-" manf=$p(manf,"-",2)
	.S productno=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",9) //批号
	.S dosage=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",10) //剂量
	.S dosageuomdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",11) //剂量单位
	.i dosageuomdr'="" S doseuom=$p($g(^CT("UOM",dosageuomdr)),"^",2)
	.S instrucdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",12) //用法
	.i formdr'="" S instru=$p($g(^PHCIN(instrucdr)),"^",2)
	.S freqdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",13) //频次
	.i freqdr'="" S freq=$p($g(^PHCFR(freqdr)),"^",3)
	.S startdate=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",14)  //开始日期
	.S:startdate'="" startdate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(startdate) ;$zd(startdate,3)
	.//S starttime=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",15)  //开始时间
	.//S starttime=$zdh(startdate,3)_" "_$zt(starttime,3)
	.S enddate=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",16)  //结束日期
	.S:enddate'="" enddate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(enddate) ;$zd(enddate,3)
	.//S endtime=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",17)  //结束时间
	.//S endtime=$zdh(enddate,3)_" "_$zt(endtime,1)
	.S reason=""
	.S reasondr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",18)  //原因ID
	.i reasondr'="" S reason=$p(^DHCPHADRRM(reasondr),"^",2)
	.i reasondr="" S reason=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",19)  //原因
	.S ListData=type_"^"_apprdocu_"^"_phcddr_"^"_goodsname_"^"_manfdr_"^"_$g(manf)_"^"_formdr
	.S ListData=ListData_"^"_genericdr_"^"_$g(genenic)_" "_$g(form)_"^"_dosage_$g(doseuom)_"/"_$g(instru)_"/"_$g(freq)_"^"_instrucdr_"^"_freqdr
	.S ListData=ListData_"^"_dosageuomdr_"^"_startdate_"^"_enddate_"^"_reasondr_"^"_$g(reason)_"^"_productno
	.i adrRepDrgStr="" S adrRepDrgStr=ListData
	.E  S adrRepDrgStr=adrRepDrgStr_"||"_ListData

	Q adrRepDrgStr
}

/// Descript:获取病人用药批次列表
ClassMethod getBatNoList(oeori As %String) As %String
{
	n (oeori)
	s pid=..NewPid()
	d ..killTmpGlobal(pid)
	s dsp=""
	f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,dsp)) q:dsp=""  d
	.s type=$p(^DHCOEDISQTY(dsp),"^",13)
	.s pointor=$p(^DHCOEDISQTY(dsp),"^",14)
	.s main=+pointor
	.s ch=$p(pointor,"||",2)
	.i type="F" d
	..s sub=""
	..f  s sub=$o(^DHCPHDI(main,"PHDI",ch,"INCLB",sub)) q:sub=""  d
	...s inclb=$p(^DHCPHDI(main,"PHDI",ch,"INCLB",sub),"^",3)
	...s incib=$$CIBrow^at299(inclb)
	...q:incib=""
	...s batno=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",1)
	...s ^TMP("DHCST","web.DHCSTPHCMADRREPORT","getBatNoList",pid,batno)=batno
	...
	.i type="P" d
	..s sub=""
	..f  s sub=$o(^DHCPHAC(main,"I",ch,"B",sub)) q:sub=""  d
	...s inclb=$p(^DHCPHAC(main,"I",ch,"B",sub),"^",1)
	...s incib=$$CIBrow^at299(inclb)
	...q:incib=""
	...s batno=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",1)
	...s ^TMP("DHCST","web.DHCSTPHCMADRREPORT","getBatNoList",pid,batno)=batno

	s count=0
	w "["
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMADRREPORT","getBatNoList",pid,index)) q:index=""  d	
	.s tmp=index_"^"_index
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCSTPHCMCOMMON).getJsonData("val^text",tmp)
	.e  d
	..W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("val^text",tmp)
	w "]"
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:检查报告单位是否已评价
ClassMethod CheckAdrRepIfUnitEvaed(adrRepID As %String) As %String
{
	n (adrRepID)
	q:'$d(^DHCPHADRR(adrRepID)) "-1^报告不存在"
	s adrrEvtCDept=$p(^DHCPHADRR(adrRepID),"^",31)   //报告单位评价
	q:adrrEvtCDept="" "-2^报告单位未评价"
	s adrrEvtRepDept=$p(^DHCPHADRR(adrRepID),"^",32) //单位签字
	q:adrrEvtRepDept="" "-3^报告单位未签字"
	q "1"
}

/// Descript:保存退回原因
ClassMethod saveAdrRetReason(adrRepID As %String, retreason As %String, userID As %String) As %String
{
	N (adrRepID, retreason, userID)
	q:'$d(^DHCPHADRR(adrRepID)) "-1"
	s retStatusID=##Class(web.DHCSTPHCMCOMMON).GetAdrStatusIDByCode("99")  ///退回状态ID
	q:retStatusID="" "-2"
	ts
	&SQL(update DHC_PHAdrReport set ADRR_RetReason=:retreason,ADRR_CurStatus_DR=:retStatusID WHERE ADRR_RowID=:adrRepID)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 SQLCODE
	s adrRepAuditdataList=retStatusID_"^"_userID  ///退回状态ID
	s retVal=..InsAdrRepAudit(adrRepID,adrRepAuditdataList)
	i retVal'=0 tro
	q:retVal'=0 retVal
	tc
	q 0
}

}
