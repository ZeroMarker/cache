Import sqluser

Class web.DHCADVMEDADRREPORT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 医疗不良事件中的重要标记
/// Creator:     yangyongtao
/// CreateDate:  2016-4-27
/// Table: 		 DHC_MedAdrReport
/// Input:  	     报告表数据
/// Return： 	 数据id
/// Others:		 w ##class(web.DHCADVMEDADRREPORT).InsImpReport("144","N")
ClassMethod InsImpReport(adrRepID As %String, adrRepImpFlag As %String) As %String
{
	N (adrRepID,adrRepImpFlag)
    I adrRepImpFlag="N" D
    .S adrRepImpFlag="Y"
    E  S adrRepImpFlag="N"  ;2016-10-17
    &SQL(Update DHC_MedAdrReport Set MEDADR_RepImpFlag=:adrRepImpFlag where MEDADR_RowID=:adrRepID)	
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 保存  医疗不良事件报告表
/// Creator:	 CongYue
/// CreateDate:  2016-03-30
/// Table: 		 DHC_MedAdrReport
/// Input:  	 DataList:医疗不良事件报告表数据信息
/// Return： 	 保存成功 返回报告ID，保存失败 返回错误值
/// Others:		 w ##class(web.DHCADVMEDADRREPORT).InsMataReport("MEDREP20160331001^2^24^^^^^^^事件过程描述^^^^^^^^^600^63^^^0000000001^^2016-03-31^10:10:59^5||2^1^^")
ClassMethod InsMedReport(dataList As %String) As %String
{

	
	N (dataList)
	S adrNo=..GetAdrReportCurMaxNo("MEDREP"_$zd(+$H,8),"3")	 //报告单号 $p(dataList,"^",1)
	S adrPatSex=$p(dataList,"^",2)	//性别
	S adrPatAge=$p(dataList,"^",3)	//年龄
	S adrPatJob=$p(dataList,"^",4)	//职别
	S adrAdmDate=$p(dataList,"^",5)	//诊疗日期
	S:adrAdmDate'="" adrAdmDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(adrAdmDate)
	S adrAdmTime=$p(dataList,"^",6)    //诊疗 时间
	S:adrAdmTime'="" adrAdmTime=$zth(adrAdmTime,1)
	S adrLiveLoc=$p(dataList,"^",7)	//现场相关科室
	S adrResult=$p(dataList,"^",8)	//不良后果
	S adrResultDesc=$p(dataList,"^",9)	//不良后果描述
	S adrProcDesc=$p(dataList,"^",10)	//过程描述
	S adrLevel=$p(dataList,"^",11)	//等级
	S adrReason=$p(dataList,"^",12)	//原因
	S adrHandInfo=$p(dataList,"^",13)	//处理情况
	S adrAdvice=$p(dataList,"^",14)	//处理意见
	S adrImprovie=$p(dataList,"^",15)	//改进情况
	S adrRepUserCareer=$p(dataList,"^",16)	//报告人职业
	S adrPartyType=$p(dataList,"^",17)	//当事人类别
	S adrCarPrvTp=$p(dataList,"^",18)	//报告人职称
	
	S adrRepUserDr=$p(dataList,"^",19)	//报告人
	S adrRepUser=""
	I adrRepUserDr'="" S adrRepUser=$p(^SSU("SSUSR",adrRepUserDr),"^",1) //报告人工号
	S adradrRepDeptDr=$p(dataList,"^",20)	//报告人科室
	S adradrRepDept=""
	I adradrRepDeptDr'="" S adradrRepDept=$p(^CTLOC(adradrRepDeptDr),"^",1)
	
	S adrRepTel=$p(dataList,"^",21)	//报告人联系电话
	S adrEmail=$p(dataList,"^",22)	//报告人邮件
	
	S adrPatID=$p(dataList,"^",23)	//病人登记号
	S adrPlace=$p(dataList,"^",24)	//不良事件场所
	S adrCreateDate=$p(dataList,"^",25)		//创建日期
	S:adrCreateDate'="" adrCreateDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(adrCreateDate)
	S adrCreateTime=$p(dataList,"^",26)   	//创建时间
	S:adrCreateTime'="" adrCreateTime=$zth(adrCreateTime,1)
	S adrCurStatusDR="" //$p(dataList,"^",27)	//当前状态
	S ReportTypeCode=$p(dataList,"^",28)	//类别
	S ReportTypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(ReportTypeCode),"")) //类别指向
	
	S adrRemark=$p(dataList,"^",29)	//备注
	S adrPlaceOth=$p(dataList,"^",30)	//不良事件场所其它
	S adrAnonymFlag=$p(dataList,"^",31)	//匿名标志
	S adrRepImpFlag=$p(dataList,"^",32)  //重要标记
	S adrAdmNo=$p(dataList,"^",33)  //就诊ID
	
	S adrDateOccu=$p(dataList,"^",34)  //日期
	S:adrDateOccu'="" adrDateOccu=##class(web.DHCADVCOMMON).DateHtmlToLogical(adrDateOccu)
	S adrTimeOccu=$p(dataList,"^",35)  //时间
	S:adrTimeOccu'="" adrTimeOccu=$zth(adrTimeOccu,1)
	
	&SQL(Insert Into DHC_MedAdrReport(MEDADR_No,MEDADR_Sex,MEDADR_Age,MEDADR_Job,
		MEDADR_AdmDate,MEDADR_AdmTime,MEDADR_LiveLoc,MEDADR_Result,MEDADR_ResultDesc,MEDADR_ProcDesc,
		MEDADR_Level,MEDADR_Reason,MEDADR_HandInfo,MEDADR_Advice,MEDADR_Improvie,MEDADR_RepUserCareer,
		MEDADR_PartyType,MEDADR_CarPrvTp,MEDADR_RepName,MEDADR_RepLocDr,MEDADR_RepTel,MEDADR_Email,
		MEDADR_PatID,MEDADR_CreateDate,MEDADR_CreateTime,MEDADR_AdrPlace,MEDADR_Remark,MEDADR_AdrPlaceOth,
		MEDADR_ReportType,MEDADR_CurStatus_DR,MEDADR_AnonymFlag,MEDADR_RepImpFlag,MEDADR_AdmNo,MEDADR_DateOccu,MEDADR_TimeOccu
		
	) Values(:adrNo,:adrPatSex,:adrPatAge,:adrPatJob,
		:adrAdmDate,:adrAdmTime,:adrLiveLoc,:adrResult,:adrResultDesc,:adrProcDesc,
		:adrLevel,:adrReason,:adrHandInfo,:adrAdvice,:adrImprovie,:adrRepUserCareer,
		:adrPartyType,:adrCarPrvTp,:adrRepUser,:adradrRepDept,:adrRepTel,:adrEmail,
		:adrPatID,:adrCreateDate,:adrCreateTime,:adrPlace,:adrRemark,:adrPlaceOth,
		:ReportTypeDr,:adrCurStatusDR,:adrAnonymFlag,:adrRepImpFlag,:adrAdmNo,
		:adrDateOccu,:adrTimeOccu

	))


	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 更新  医疗不良事件报告表  
/// Creator:	 CongYue
/// CreateDate:  2016-03-30
/// Table:		 DHC_MedAdrReport
/// Input:		 报告表id , 报告表数据
/// Return： 	 保存成功 返回报告ID，保存失败 返回错误值
/// Others:		 w ##class(web.DHCADVMEDADRREPORT).UpdMedReport("25","MEDREP20160331001^2^24^^^^^^^事件过程描述^^^^^^^^^600^63^^^0000000001^^2016-03-31^10:10:59^5||2^1^^")
ClassMethod UpdMedReport(adrRepID As %String, dataList As %String) As %String
{
	
	N (adrRepID,dataList)
	S adrNo=$p(^DHCMEDADRR(adrRepID),"^",1)		//报告单号
	S adrPatSex=$p(dataList,"^",2)	//性别
	S adrPatAge=$p(dataList,"^",3)	//年龄
	S adrPatJob=$p(dataList,"^",4)	//职别
	S adrAdmDate=$p(dataList,"^",5)	//诊疗日期
	S:adrAdmDate'="" adrAdmDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(adrAdmDate)
	S adrAdmTime=$p(dataList,"^",6)    //诊疗 时间
	S:adrAdmTime'="" adrAdmTime=$zth(adrAdmTime,1)
	S adrLiveLoc=$p(dataList,"^",7)	//现场相关科室
	S adrResult=$p(dataList,"^",8)	//不良后果
	S adrResultDesc=$p(dataList,"^",9)	//不良后果描述
	S adrProcDesc=$p(dataList,"^",10)	//过程描述
	S adrLevel=$p(dataList,"^",11)	//等级
	S adrReason=$p(dataList,"^",12)	//原因
	S adrHandInfo=$p(dataList,"^",13)	//处理情况
	S adrAdvice=$p(dataList,"^",14)	//处理意见
	S adrImprovie=$p(dataList,"^",15)	//改进情况
	S adrRepUserCareer=$p(dataList,"^",16)	//报告人职业
	S adrPartyType=$p(dataList,"^",17)	//当事人类别
	S adrCarPrvTp=$p(dataList,"^",18)	//报告人职称
	S adrRepUserDr=$p(dataList,"^",19)	//报告人
	S adrRepUser=""
	I adrRepUserDr'="" S adrRepUser=$p(^SSU("SSUSR",adrRepUserDr),"^",1) //报告人工号
	S adradrRepDeptDr=$p(dataList,"^",20)	//报告人科室
	S adradrRepDept=""
	I adradrRepDeptDr'="" S adradrRepDept=$p(^CTLOC(adradrRepDeptDr),"^",1)
	S adrRepTel=$p(dataList,"^",21)	//报告人联系电话
	S adrEmail=$p(dataList,"^",22)	//报告人邮件
	S adrPatID=$p(dataList,"^",23)	//病人ID
	S adrPlace=$p(dataList,"^",24)	//不良事件场所
	S adrCreateDate=$p(dataList,"^",25)		//创建日期
	S:adrCreateDate'="" adrCreateDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(adrCreateDate)
	S adrCreateTime=$p(dataList,"^",26)   	//创建时间
	S:adrCreateTime'="" adrCreateTime=$zth(adrCreateTime,1)
	S adrCurStatusDR=$p(dataList,"^",27)	//当前状态
	S ReportTypeCode=$p(dataList,"^",28)	//类别
	S ReportTypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(ReportTypeCode),"")) //类别指向
	S adrRemark=$p(dataList,"^",29)	//备注
	S adrPlaceOth=$p(dataList,"^",30)	//不良事件场所其它
	S adrAnonymFlag=$p(dataList,"^",31)	//匿名标志
	S adrRepImpFlag=$p(dataList,"^",32)  //重要标记
	S adrAdmNo=$p(dataList,"^",33)  //就诊ID
	S adrDateOccu=$p(dataList,"^",34)  //日期
	S:adrDateOccu'="" adrDateOccu=##class(web.DHCADVCOMMON).DateHtmlToLogical(adrDateOccu)
	S adrTimeOccu=$p(dataList,"^",35)  //时间
	S:adrTimeOccu'="" adrTimeOccu=$zth(adrTimeOccu,1)
	
	&SQL(update DHC_MedAdrReport set MEDADR_No=:adrNo,MEDADR_Sex=:adrPatSex,MEDADR_Age=:adrPatAge,MEDADR_Job=:adrPatJob,
		MEDADR_AdmDate=:adrAdmDate,MEDADR_AdmTime=:adrAdmTime,MEDADR_LiveLoc=:adrLiveLoc,MEDADR_Result=:adrResult,MEDADR_ResultDesc=:adrResultDesc,MEDADR_ProcDesc=:adrProcDesc,
		MEDADR_Level=:adrLevel,MEDADR_Reason=:adrReason,MEDADR_HandInfo=:adrHandInfo,MEDADR_Advice=:adrAdvice,MEDADR_Improvie=:adrImprovie,MEDADR_RepUserCareer=:adrRepUserCareer,
		MEDADR_PartyType=:adrPartyType,MEDADR_CarPrvTp=:adrCarPrvTp,MEDADR_RepName=:adrRepUser,MEDADR_RepLocDr=:adradrRepDept,MEDADR_RepTel=:adrRepTel,MEDADR_Email=:adrEmail,
		MEDADR_PatID=:adrPatID,MEDADR_CreateDate=:adrCreateDate,MEDADR_CreateTime=:adrCreateTime,MEDADR_AdrPlace=:adrPlace,MEDADR_Remark=:adrRemark,MEDADR_AdrPlaceOth=:adrPlaceOth,
		MEDADR_ReportType=:ReportTypeDr,MEDADR_CurStatus_DR=:adrCurStatusDR,MEDADR_AnonymFlag=:adrAnonymFlag,MEDADR_RepImpFlag=:adrRepImpFlag,MEDADR_AdmNo=:adrAdmNo,
		MEDADR_DateOccu=:adrDateOccu,MEDADR_TimeOccu=:adrTimeOccu where MEDADR_RowID=:adrRepID
    )						
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 保存  医疗不良事件报告表  
/// Creator:	 CongYue
/// CreateDate:  2016-03-30
/// Table: 		 DHC_MedAdrReport
/// Input:  	 报告表id , 报告表数据 , matadrRepAuditList:以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return： 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDADRREPORT).SaveMedReport("","MEDREP20160705001^2^25^^^^^^^事件过程描述:^^存在隐患：^改进建议^^^^11^11^600^63^^^0000000001^10^2016-07-05^08:10:36^^med^^^^N^1^2016-07-05^08:10:47","")
ClassMethod SaveMedReport(adrRepID As %String, adrRepDataList As %String, adrRepAuditList As %String, flag As %String) As %String
{
	N (adrRepID,adrRepDataList,adrRepAuditList,flag)
	S ret=0
	I adrRepID="" D
	.S ret=..Insert(adrRepDataList,adrRepAuditList,flag)
	E  D
	.S ret=..Update(adrRepID,adrRepDataList,adrRepAuditList,flag)
	Q ret
}

/// Description:保存 医疗不良事件报告表
/// Creator:	 CongYue
/// CreateDate:  2016-03-31
/// Table: 		 DHC_MedAdrReport
/// Input:  	 报告表数据 , adrRepAuditList :以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return： 	 "0^"_adrRepID:保存成功标志^报告表id
ClassMethod Insert(adrRepDataList As %String, adrRepAuditList As %String, flag As %String) As %String
{
	N (adrRepDataList,adrRepAuditList,flag)
	S Err=0
	TS
	S adrRepID=..InsMedReport(adrRepDataList)
	I adrRepID<0 tro
	Q:adrRepID<0 adrRepID

	//更新状态
	S TypeDr=""
    S nextStatuDr=""
    S TypeCode=$p(adrRepAuditList,"^",8)	//类别
	S TypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(TypeCode),"")) //类别指向
	I flag="1" D
	.S adtList=adrRepID_"^"_TypeDr_"^"_$p(adrRepAuditList,"^",2)_"^"_$p(adrRepAuditList,"^",3)_"^"_$p(adrRepAuditList,"^",4)
	.S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(adtList)
	I (flag="1")&(+nextStatuDr'>0) tro
	Q:(flag="1")&(+nextStatuDr'>0) nextStatuDr
	
	I flag="1" D
	.&sql(update DHC_MedAdrReport set MEDADR_CurStatus_DR=:nextStatuDr where MEDADR_RowID=:adrRepID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 S Err="-16"
	
	Q:Err'=0 "-16"
	
	S adrRepAuditList=nextStatuDr_"^"_$p(adrRepAuditList,"^",2,7)_"^"_TypeDr
	
	
	//不良反应报告审批流程[默认插入初始状态]
	I adrRepAuditList'="" D
	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(adrRepID,adrRepAuditList)
	I Err'=0 tro
	Q:Err'=0 "-18"

	TC
	Q "0^"_adrRepID
}

/// Description:保存 医疗不良事件报告表
/// Creator:	 CongYue
/// CreateDate:  2016-03-31
/// Table: 		 DHC_MedAdrReport
/// Input:  	 报告表id,报告表数据 , adrRepAuditList :以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return： 	 "0^"_adrRepID:保存成功标志^报告表id
ClassMethod Update(adrRepID As %String, adrRepDataList As %String, adrRepAuditList As %String, flag As %String) As %String
{
	N (adrRepID,adrRepDataList,adrRepAuditList,flag)
	S Err=0
	S RepStatus=$p(^DHCMEDADRR(adrRepID),"^",27) ;报告当前状态
	TS
	S adrRepID=..UpdMedReport(adrRepID,adrRepDataList)
	I adrRepID<0 tro
	Q:adrRepID<0 adrRepID
	

	//更新状态
	S TypeDr=""
    S nextStatuDr=""
    S TypeCode=$p(adrRepAuditList,"^",8)	//类别
	S TypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(TypeCode),"")) //类别指向
	I flag="1" D
	.S adtList=adrRepID_"^"_TypeDr_"^"_$p(adrRepAuditList,"^",2)_"^"_$p(adrRepAuditList,"^",3)_"^"_$p(adrRepAuditList,"^",4)
	.S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(adtList)
	
	I (flag="1")&(+nextStatuDr'>0) tro
	Q:(flag="1")&(+nextStatuDr'>0) nextStatuDr
	
	I flag="1" D
	.&sql(update DHC_MedAdrReport set MEDADR_CurStatus_DR=:nextStatuDr where MEDADR_RowID=:adrRepID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 s Err="-16"
	
	Q:Err'=0 "-16"
	S:flag=1 adrRepAuditList=nextStatuDr_"^"_$p(adrRepAuditList,"^",2,7)_"^"_TypeDr
	S:flag=0 adrRepAuditList=RepStatus_"^"_$p(adrRepAuditList,"^",2,7)_"^"_TypeDr
	;S adrRepAuditList=nextStatuDr_"^"_$p(adrRepAuditList,"^",2,7)_"^"_TypeDr
	//不良反应报告审批流程[默认插入初始状态]
	I adrRepAuditList'="" D
	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(adrRepID,adrRepAuditList)
	I Err'=0 tro
	Q:Err'=0 "-17"
	
	TC
	
	Q "0^"_adrRepID
}

/// Description: 删除  医疗不良事件报告表  
/// Creator:     CongYue
/// CreateDate:  2016-04-01
/// Table: 		 DHC_MedAdrReport
/// Input:  	 报告表id 
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVMEDADRREPORT).DelMedReport("36^600")
ClassMethod DelMedReport(params As %String) As %String
{
	N (params)
	S adrRepID=$p(params,"^",1)
	S UserID=$p(params,"^",2)
	S repUser=$p(^DHCMEDADRR(adrRepID),"^",19)    //填报人
	S repCurStatDR=$p(^DHCMEDADRR(adrRepID),"^",27) //当前状态
	S repUserID=""
	I repUser'=""  D
	.S repUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(repUser),""))
	Q:UserID'=repUserID -1  //不是本人，不能删除
	Q:repCurStatDR'="" -2  //已提交，不能删除
	
	&SQL(DELETE DHC_MedAdrReport WHERE MEDADR_RowID=:adrRepID)
	Q SQLCODE
}

/// Description: 获取页面默认信息（日期，编码） 
/// Creator:     CongYue
/// CreateDate:  2016-03-31
/// Input: 		 params : 以字符"^"分割,格式为:人员id^科室id^安全组id^报告类型代码
/// Return: 	 页面默认信息: 以字符"^"分割,格式为:报告编码^报告日期^报告初始状态^报告类型^科室描述
/// Others:		 w ##class(web.DHCADVMEDADRREPORT).getMataInfo()
ClassMethod getMedInfo(params As %String) As %String
{
	N (params)
	S repdate=$zdt($H,3)
	S Prefix="MEDREP"_$zd(+$H,8)  //报告编码规则 "MATADR"+年月日+顺序号
	S MedNo=..GetAdrReportCurMaxNo(Prefix,"3")	
	S List=##class(web.DHCADVCOMMON).GetStatusDr(params)
	Q:List="" -1
	S MedReportType=$p(List,"^",1)  //报告类型
	S MedInitStatDR=$p(List,"^",2)  //审核状态
	S LocID=$p(params,"^",2)  //科室ID
	I LocID'="" D
	.S LocDesc=$p(^CTLOC(LocID),"^",2)
	
	Q MedNo_"^"_repdate_"^"_MedInitStatDR_"^"_MedReportType_"^"_$g(LocDesc)
}

/// Description: 取当前不良反应报告最大码
/// Creator:	 CongYue
/// CreateDate:  2016-03-31
/// Input:  	 报告编码规则,编码数字长度
/// Return:  	 当前不良反应报告最大码  
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

	I Prefix'=CurPrefix D
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

/// Description: 获取当前最大码
/// Creator:	 CongYue
/// CreateDate:  2016-03-31
/// Input:  	 报告编码规则,编码数字长度
/// Return:  	 当前不良反应报告最大码  
ClassMethod GetMaxCodeByCode(Prefix As %String) As %String
{
	N (Prefix)
	Q:Prefix="" ""
	S medcode=""
	&sql(select max(MEDADR_No) into medcode from DHC_MedAdrReport Where MEDADR_No %STARTSWITH %ALPHAUP :Prefix)
	Q medcode
}

/// Description: 获取  医疗不良事件报告表 信息 
/// Creator:	 CongYue
/// CreateDate:  2016-03-31
/// Table: 		 DHC_MedAdrReport
/// Input:  	 报告表id
/// Return： 	 报告表数据
/// Others:		 w ##class(web.DHCADVMEDADRREPORT).GetMedRepInfo("107","600^63^126^med")
ClassMethod GetMedRepInfo(adrRepID As %String, params As %String) As %String
{
	N (adrRepID,params)
	Q:'$d(^DHCMEDADRR(adrRepID)) ""
	S adrNo=$p(^DHCMEDADRR(adrRepID),"^",1) // 报告号
	S adrPatSex=$p(^DHCMEDADRR(adrRepID),"^",2) //性别
	S adrPatAge=$p(^DHCMEDADRR(adrRepID),"^",3) //年龄
	S adrPatJob=$p(^DHCMEDADRR(adrRepID),"^",4) //病人职业
	S adrAdmDate=$p(^DHCMEDADRR(adrRepID),"^",5) //就诊日期
	I adrAdmDate'="" S adrAdmDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(adrAdmDate)
	S adrAdmTime=$p(^DHCMEDADRR(adrRepID),"^",6) //就诊时间
	I adrAdmTime'="" S adrAdmTime=$zt(adrAdmTime,1)
	S adrLiveLoc=$p(^DHCMEDADRR(adrRepID),"^",7) //现场相关科室
	S adrResult=$p(^DHCMEDADRR(adrRepID),"^",8) //不良后果
	S adrResultDesc=$p(^DHCMEDADRR(adrRepID),"^",9) //不良后果描述
	S adrProcDesc=$p(^DHCMEDADRR(adrRepID),"^",10) //过程描述
	S adrLevel=$p(^DHCMEDADRR(adrRepID),"^",11) //等级
	S adrReason=$p(^DHCMEDADRR(adrRepID),"^",12) //原因
	S AdrHandInfo=$p(^DHCMEDADRR(adrRepID),"^",13) //处理情况
	S adrAdvice=$p(^DHCMEDADRR(adrRepID),"^",14) //处理意见
	S adrImprovie=$p(^DHCMEDADRR(adrRepID),"^",15) //改进情况
	S adrRepUserCareer=$p(^DHCMEDADRR(adrRepID),"^",16) //报告人职业
	S adrPartyType=$p(^DHCMEDADRR(adrRepID),"^",17) //当事人类别
	S adrCarPrvTp=$p(^DHCMEDADRR(adrRepID),"^",18) //报告人职称
		
	S adrRepUserCode=$p(^DHCMEDADRR(adrRepID),"^",19)    //填报人
	S adrRepUserDr=""
	S adrRepUser=""
	I adrRepUserCode'=""  D
	.S adrRepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(adrRepUserCode),""))
	.S adrRepUser=$p(^SSU("SSUSR",adrRepUserDr),"^",2)

	S adradrRepDeptCode=$p(^DHCMEDADRR(adrRepID),"^",20) //科室
	S adradrRepDeptDr=""
	S adradrRepDept=""
	I adradrRepDeptCode'=""  D
	.S adradrRepDeptDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(adradrRepDeptCode),""))
	.S adradrRepDept=$p(^CTLOC(adradrRepDeptDr),"^",2)


	S adrRepTel=$p(^DHCMEDADRR(adrRepID),"^",21) //报告人联系电话
	S adrEmail=$p(^DHCMEDADRR(adrRepID),"^",22) //报告人邮件
	
	S adrPatNo=$p(^DHCMEDADRR(adrRepID),"^",23) //病人登记号
	I adrPatNo'="" S adrPatID=$O(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(adrPatNo),""))
	S:adrAdmNo'="" medicalNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(adrAdmNo,"") 
	S:(adrPatID'="")&&(medicalNo="") medicalNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",adrPatID)  //病案号
	S adrPlace=$p(^DHCMEDADRR(adrRepID),"^",24) //不良事件场所
	S adrCreateDate=$p(^DHCMEDADRR(adrRepID),"^",25) //报告日期
	I adrCreateDate'="" S adrCreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(adrCreateDate)
	S adrCreateTime=$p(^DHCMEDADRR(adrRepID),"^",26) //报告时间
	I adrCreateTime'="" S adrCreateTime=$zt(adrCreateTime,1)
	S adrCurStatusDR=$p(^DHCMEDADRR(adrRepID),"^",27) //当前状态
	S ReportTypeDr=$p(^DHCMEDADRR(adrRepID),"^",30) //报告类型
	S ReportTypeCode=$p(^DHCMEDADREVT(ReportTypeDr),"^",1)
	S adrRemark=$p(^DHCMEDADRR(adrRepID),"^",28) //备注
	S adrPlaceOth=$p(^DHCMEDADRR(adrRepID),"^",29) //不良事件场其它
	S adrAnonymFlag=$p(^DHCMEDADRR(adrRepID),"^",31) //匿名标志
	S adrRepImpFlag=$p(^DHCMEDADRR(adrRepID),"^",32) //重要标记
	S adrAdmNo=$p(^DHCMEDADRR(adrRepID),"^",33) //就诊ID
	S adrDateOccu=$p(^DHCMEDADRR(adrRepID),"^",34)  //日期
	I adrDateOccu'="" S adrDateOccu=##class(web.DHCADVCOMMON).DateLogicalToHtml(adrDateOccu)
	S adrTimeOccu=$p(^DHCMEDADRR(adrRepID),"^",35)  //时间
	I adrTimeOccu'="" S adrTimeOccu=$zt(adrTimeOccu,1)
	;S PatInfo=##class(web.DHCADVMEDCOMMON).GetPatBaseInfo(adrPatNo,adrAdmNo) //就诊信息
	S PatInfo=##class(web.DHCADVCOMMON).getRepPatInfo(adrPatNo,adrAdmNo) //就诊信息
	
	;S param=patNo_"^"_patName_"^"_sexId_"^"_patSex_"^"_patAge_"^"_medicalNo_"^"_birthday_"^"_IDcard_"^"_admdate_"^"_admtime_"^"_patdiag
	;S param=param_"^"_curWardDesc_"^"_curWard_"^"_nationdr_"^"_countrydr_"^"_patTelH_"^"_address_"^"_weight_"^"_height
	
	;S EpisodeID=$p(PatInfo,"^",2)  
	S AdmWardID=""
	;I EpisodeID="" S AdmWardID=$p(^PAADM(EpisodeID),"^",70) //病区
	S PatDiag=$p(PatInfo,"^",11) //诊断
	S Sexdr=$p(PatInfo,"^",4) //性别
	S Admdate=$p(PatInfo,"^",9) //就诊日期
	S PatName=$p(PatInfo,"^",2) //病人姓名
	S AdmWardID="",AdmWardDesc=""
	S:adrAdmNo'="" AdmWardID=$p(^PAADM(adrAdmNo),"^",70) //病区
	I AdmWardID'="" S AdmWardDesc=$p(^PAWARD(+AdmWardID),"^",2)
	S medsrAuditID=$o(^DHCMEDREPADT(0,"Pointer",ReportTypeDr,adrRepID,""),-1)
	I medsrAuditID=""  D
	.S adrNextLoc=""
	.S adrLocAdvice=""
	.S adrReceive=""
	E  D
	.S adrNextLoc=$p(^DHCMEDREPADT(medsrAuditID),"^",7)
	.S adrLocAdvice=$p(^DHCMEDREPADT(medsrAuditID),"^",8)
	.S adrReceive=$p(^DHCMEDREPADT(medsrAuditID),"^",9)
	S List=##class(web.DHCADVCOMMON).GetStatusDr(params)
	S adrInitStatDR=$p(List,"^",2)          //初始状态
	
	S ListData=adrNo_"!"_adrPatSex_"!"_adrPatAge_"!"_adrPatJob_"!"_adrAdmDate_"!"_adrAdmTime_"!"_adrLiveLoc
	S ListData=ListData_"!"_adrResult_"!"_adrResultDesc_"!"_adrProcDesc_"!"_adrLevel_"!"_adrReason
	S ListData=ListData_"!"_AdrHandInfo_"!"_adrAdvice_"!"_adrImprovie_"!"_adrRepUserCareer_"!"_adrPartyType
	S ListData=ListData_"!"_adrCarPrvTp_"!"_adrRepUser_"!"_adradrRepDept_"!"_adrRepTel_"!"_adrEmail
	S ListData=ListData_"!"_adrPatNo_"!"_adrPlace_"!"_adrCreateDate_"!"_adrCreateTime_"!"_adrCurStatusDR_"!"_ReportTypeDr
	S ListData=ListData_"!"_adrRemark_"!"_adrPlaceOth_"!"_PatDiag_"!"_medicalNo_"!"_adrInitStatDR
	S ListData=ListData_"!"_adrNextLoc_"!"_adrLocAdvice_"!"_adrReceive_"!"_PatName_"!"_adrRepUserDr_"!"_adradrRepDeptDr
	S ListData=ListData_"!"_adrAnonymFlag_"!"_AdmWardID_"!"_ReportTypeCode_"!"_adrRepImpFlag_"!"_adrAdmNo_"!"_adrDateOccu_"!"_adrTimeOccu_"!"_AdmWardDesc
	
	Q ListData
}

/// Description: 获取医疗不良事件报告表 信息(打印/导出)
/// Creator:   	 yangyongtao
/// CreateDate:  2016-05-27
/// Table: 		 DHC_MedAdrReport
/// Input:  	 报告表id
/// Return： 	 报告表数据
/// Others:		 w ##class(web.DHCADVMEDADRREPORT).getMedRepExportInfo("25")
ClassMethod getMedRepExportInfo(adrRepID As %String) As %String
{
	N (adrRepID)
	Q:'$d(^DHCMEDADRR(adrRepID)) ""
	S adrNo=$p(^DHCMEDADRR(adrRepID),"^",1) // 报告号
	S adrPatSex=$p(^DHCMEDADRR(adrRepID),"^",2) //性别
	S:adrPatSex'="" adrPatSex=$p(^CT("SEX",adrPatSex),"^",2)
	S adrPatAge=$p(^DHCMEDADRR(adrRepID),"^",3) //年龄
	S adrPatJob=$p(^DHCMEDADRR(adrRepID),"^",4) //病人职业
	S adrAdmDate=$p(^DHCMEDADRR(adrRepID),"^",5) //就诊日期
	I adrAdmDate'="" S adrAdmDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(adrAdmDate)
	S adrAdmTime=$p(^DHCMEDADRR(adrRepID),"^",6) //就诊时间
	I adrAdmTime'="" S adrAdmTime=$zt(adrAdmTime,3)
	S adrLiveLoc=$p(^DHCMEDADRR(adrRepID),"^",7) //现场相关科室
	S adrResult=$p(^DHCMEDADRR(adrRepID),"^",8) //不良后果
	S adrResultDesc=$p(^DHCMEDADRR(adrRepID),"^",9) //不良后果描述
	S adrProcDesc=$p(^DHCMEDADRR(adrRepID),"^",10) //过程描述
	S adrLevel=$p(^DHCMEDADRR(adrRepID),"^",11) //等级
	S adrReason=$p(^DHCMEDADRR(adrRepID),"^",12) //原因
	S AdrHandInfo=$p(^DHCMEDADRR(adrRepID),"^",13) //处理情况
	S adrAdvice=$p(^DHCMEDADRR(adrRepID),"^",14) //处理意见
	S adrImprovie=$p(^DHCMEDADRR(adrRepID),"^",15) //改进情况
	S adrRepUserCareer=$p(^DHCMEDADRR(adrRepID),"^",16) //报告人职业
	S adrPartyType=$p(^DHCMEDADRR(adrRepID),"^",17) //当事人类别
	S adrPartyType=$S(adrPartyType="11":"医师",adrPartyType="12":"药师",adrPartyType="13":"技师",adrPartyType="14":"护理人员",adrPartyType="15":"管理人员",adrPartyType="16":"其他",1:"")

	
	S adrCarPrvTp=$p(^DHCMEDADRR(adrRepID),"^",18) //报告人职称
	S adrCarPrvTp=$S(adrCarPrvTp="11":"高级",adrCarPrvTp="12":"中级",adrCarPrvTp="13":"初级",adrCarPrvTp="14":"士级",1:"")
	
	S adrRepUserCode=$p(^DHCMEDADRR(adrRepID),"^",19)    //填报人
	S adrRepUserDr=""
	S adrRepUser=""
	I adrRepUserCode'=""  D
	.S adrRepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(adrRepUserCode),""))
	.S adrRepUser=$p(^SSU("SSUSR",adrRepUserDr),"^",2)

	S adradrRepDeptCode=$p(^DHCMEDADRR(adrRepID),"^",20) //科室
	S adradrRepDeptDr=""
	S adradrRepDept=""
	I adradrRepDeptCode'=""  D
	.S adradrRepDeptDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(adradrRepDeptCode),""))
	.S adradrRepDept=$p(^CTLOC(adradrRepDeptDr),"^",2)


	S adrRepTel=$p(^DHCMEDADRR(adrRepID),"^",21) //报告人联系电话
	S adrEmail=$p(^DHCMEDADRR(adrRepID),"^",22) //报告人邮件
	
	S adrPatNo=$p(^DHCMEDADRR(adrRepID),"^",23) //病人登记号
	I adrPatNo'="" S adrPatID=$O(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(adrPatNo),""))
	S:adrAdmNo'="" medicalNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(adrAdmNo,"") 
	S:(adrPatID'="")&&(medicalNo="") medicalNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",adrPatID)  //病案号
	S adrPlace=$p(^DHCMEDADRR(adrRepID),"^",24) //不良事件场所
	S adrPlace=$S(adrPlace="10":"急诊",adrPlace="11":"门诊",adrPlace="12":"病房部",adrPlace="16":"手术室",adrPlace="13":"医技检查室",adrPlace="14":"后勤区域",adrPlace="15":"其他",1:"")
	S adrCreateDate=$p(^DHCMEDADRR(adrRepID),"^",25) //报告日期
	I adrCreateDate'="" S adrCreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(adrCreateDate)
	S adrCreateTime=$p(^DHCMEDADRR(adrRepID),"^",26) //报告时间
	I adrCreateTime'="" S adrCreateTime=$zt(adrCreateTime,1)
	S adrCurStatusDR=$p(^DHCMEDADRR(adrRepID),"^",27) //当前状态
	S ReportTypeDr=$p(^DHCMEDADRR(adrRepID),"^",30) //报告类型
	S ReportTypeCode=$p(^DHCMEDADREVT(ReportTypeDr),"^",1)
	S ReportTypeCode=$S(ReportTypeCode="med":"医疗",ReportTypeCode="bldevent":"输血不良事件",ReportTypeCode="blood":"输血不良反应",ReportTypeCode="material":"器械",ReportTypeCode="drug":"药物不良反应",ReportTypeCode="drugerr":"用药差错",1:"")
	S adrRemark=$p(^DHCMEDADRR(adrRepID),"^",28) //备注
	S adrPlaceOth=$p(^DHCMEDADRR(adrRepID),"^",29) //不良事件场其它
	S adrAnonymFlag=$p(^DHCMEDADRR(adrRepID),"^",31) //匿名标志
	S adrRepImpFlag=$p(^DHCMEDADRR(adrRepID),"^",32) //重要标记
	S adrAdmNo=$p(^DHCMEDADRR(adrRepID),"^",33) //就诊ID
	S adrDateOccu=$p(^DHCMEDADRR(adrRepID),"^",34)  //日期
	I adrDateOccu'="" S adrDateOccu=##class(web.DHCADVCOMMON).DateLogicalToHtml(adrDateOccu)
	S adrTimeOccu=$p(^DHCMEDADRR(adrRepID),"^",35)  //时间
	I adrTimeOccu'="" S adrTimeOccu=$zt(adrTimeOccu,3)
    S PatInfo=##class(web.DHCADVCOMMON).getRepPatInfo(adrPatNo,adrAdmNo) //就诊信息
	;S PatInfo=##class(web.DHCADVMEDCOMMON).GetPatBaseInfo(adrPatNo,adrAdmNo) //就诊信息
	;S EpisodeID=$p(PatInfo,"^",2)
	S AdmWardID="" 
	S AdmWardDesc=""
	;I EpisodeID="" S AdmWardID=$p(^PAADM(EpisodeID),"^",70) //病区
	S PatDiag=$p(PatInfo,"^",11) //诊断
	S Sexdr=$p(PatInfo,"^",4) //性别
	S Admdate=$p(PatInfo,"^",9) //就诊日期
	S PatName=$p(PatInfo,"^",2) //病人姓名
	I adrAdmNo'="" S AdmWardID=$p(^PAADM(adrAdmNo),"^",70) //病区
	I AdmWardID'="" S AdmWardDesc=$p(^PAWARD(AdmWardID),"^",2) //病区Desc
	;I AdmWardDesc["-" S AdmWardDesc=$P(AdmWardDesc,"-",2) //以"-"截取字符
	S medsrAuditID=$o(^DHCMEDREPADT(0,"Pointer",ReportTypeDr,adrRepID,""),-1)
	I medsrAuditID=""  D
	.S adrNextLoc=""
	.S adrLocAdvice=""
	.S adrReceive=""   
	E  D
	.S adrNextLoc=$p(^DHCMEDREPADT(medsrAuditID),"^",7)
	.S adrLocAdvice=$p(^DHCMEDREPADT(medsrAuditID),"^",8)
	.S adrReceive=$p(^DHCMEDREPADT(medsrAuditID),"^",9)
	
	S adrListData=adrCreateDate_"&&"_adrCreateTime_"&&"_adrNo_"&&"_ adrPatNo_"&&"_AdmWardDesc_"&&"_medicalNo  //5
	S adrListData=adrListData_"&&"_PatName_"&&"_adrPatSex_"&&"_adrPatAge_"&&"_PatDiag //9
    S adrListData=adrListData_"&&"_adrAnonymFlag_"&&"_adrRepUser_"&&"_adradrRepDept_"&&"_adrAdmDate_"&&"_adrAdmTime //14
	S adrListData=adrListData_"&&"_adrPartyType_"&&"_adrCarPrvTp_"&&"_adrRepTel_"&&"_adrEmail_"&&"_ReportTypeCode  //19
	S adrListData=adrListData_"&&"_adrPlace_"&&"_adrPlaceOth_"&&"_adrProcDesc_"&&"_adrReason_"&&"_AdrHandInfo_"&&"_adrDateOccu_"&&"_adrTimeOccu  //26
	Q adrListData
}

}
