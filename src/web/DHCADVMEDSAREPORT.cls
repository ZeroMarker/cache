Import sqluser

Class web.DHCADVMEDSAREPORT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 用药差错不良事件中的重要标记
/// Creator:     yangyongtao
/// CreateDate:  2016-4-27
/// Table: 		 DHC_MedSafetyReport
/// Input:  	     报告表数据
/// Return： 	 数据id
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).InsImpReport("144","N")
ClassMethod InsImpReport(medsrID As %String, medsrRepImpFlag As %String) As %String
{
	N (medsrID,medsrRepImpFlag)
    I medsrRepImpFlag="N" D
    .S medsrRepImpFlag="Y"
    E  S medsrRepImpFlag="N"  ;2016-10-17
    &SQL(Update DHC_MedSafetyReport Set MEDSR_RepImpFlag=:medsrRepImpFlag Where MEDSR_RowID=:medsrID)	
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 保存  用药差错报告表  
/// Creator:     CongYue
/// CreateDate:  2015-12-23
/// Table: 		 DHC_MedSafetyReport
/// Input:  	 报告表数据
/// Return： 	 数据id
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).InsMedsReport("63^2016-04-15^12:25:58^2016-04-15^12:26:05^白班^000086^0000000001^杜桑^2^24^865^6g^^600^^^MEDSAR20160415001^4^^1||4")
ClassMethod InsMedsReport(dataList As %String) As %String
{
	N (dataList)
	S medsrRepLocDr=$p(dataList,"^",1) //科室
	S medsrRepLocCode=""
	I medsrRepLocDr'="" S medsrRepLocCode=$p(^CTLOC(medsrRepLocDr),"^",1)
	S medsrCreateDate=$p(dataList,"^",2)    //报告日期
	S:medsrCreateDate'="" medsrCreateDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(medsrCreateDate)
	S medsrCreateTime=$p(dataList,"^",3)    //报告时间
	S:medsrCreateTime'="" medsrCreateTime=$zth(medsrCreateTime,1)
	
	S medsrOccDate=$p(dataList,"^",4)    //发生日期
	S:medsrOccDate'="" medsrOccDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(medsrOccDate)
	S medsrOccTime=$p(dataList,"^",5)    //发生时间
	S:medsrOccTime'="" medsrOccTime=$zth(medsrOccTime,1)

	S medsrOccBatNo=$p(dataList,"^",6) //班次
	S medsrPatNo=$p(dataList,"^",7) //病人病案号（登记号）
	S medsrPatID=$p(dataList,"^",8) //病人ID
	S medsrName=$p(dataList,"^",9) //患者姓名
	S medsrSex=$p(dataList,"^",10) //性别	
	S medsrAge=$p(dataList,"^",11) //年龄

	S medsrDrugDr=$p(dataList,"^",12)     //应给药物id
	S medsrDrugName=""
	I medsrDrugDr'="" d
	.S medsrDrugName=$p(^INCI(medsrDrugDr,1),"^",1)     //应给药物代码
	
	S medsrDosage=$p(dataList,"^",13) //应给剂量
	S medsrErrNum=$p(dataList,"^",14) //累计错误给药次数
	
	S medsrCreatorDr=$p(dataList,"^",15)     //报告人id
	S medsrCreator=""
	I medsrCreatorDr'="" S medsrCreator=$p(^SSU("SSUSR",medsrCreatorDr),"^",1) //报告人工号
	S medsrCreatorCareProv=$p(dataList,"^",16)     //报告人职称
	
	S medsrCurStatusDR=$p(dataList,"^",17) //报告当前状态
	S medsrReportNo=..GetAdrReportCurMaxNo("MEDSAR"_$zd(+$H,8),"3") //报告编码 $p(dataList,"^",18)
	S medsrReportType=$p(dataList,"^",19) //报告填报类型
	S medsrAdmNo=$p(dataList,"^",20) //就诊id
	S medsrOrdItm=$p(dataList,"^",21) //医嘱id
	
	S medsrRepImpFlag=$p(dataList,"^",22)  //重要标记
	
	&SQL(Insert Into DHC_MedSafetyReport(MEDSR_RepLoc_Dr,MEDSR_CreateDate,MEDSR_CreateTime,MEDSR_OccDate,
		MEDSR_OccTime,MEDSR_OccBatNo,MEDSR_PatNo,MEDSR_PatID,MEDSR_PatName,MEDSR_PatSex,
		MEDSR_PatAge,MEDSR_DrugName,MEDSR_Dosage,MEDSR_Creator,
		MEDSR_CreatorCareProv,MEDSR_ErrNum,MEDSR_CurStatus_DR,MEDSR_ReportNo,MEDSR_ReportType,MEDSR_AdmNo,MEDSR_OrdItm,MEDSR_RepImpFlag 
	) Values(
		:medsrRepLocCode,:medsrCreateDate,:medsrCreateTime,:medsrOccDate,
		:medsrOccTime,:medsrOccBatNo,:medsrPatNo,:medsrPatID,:medsrName,:medsrSex,
		:medsrAge,:medsrDrugName,:medsrDosage,:medsrCreator,
		:medsrCreatorCareProv,:medsrErrNum,:medsrCurStatusDR,:medsrReportNo,:medsrReportType,:medsrAdmNo,:medsrOrdItm,:medsrRepImpFlag
	))

	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 更新  用药差错报告表  
/// Creator:     CongYue
/// CreateDate:  2015-12-23
/// Table:  	 DHC_MedSafetyReport
/// Input:  	 报告id , 报告表数据
/// Return: 	 数据id
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).UpdMedsReport("53","63^2016-04-15^12:25:58^2016-04-15^12:26:05^白班^000086^0000000001^杜桑^2^24^865^6g^^600^^^MEDSAR20160415001^4^^1||4")
ClassMethod UpdMedsReport(medsrID As %String, dataList As %String) As %String
{
	N (medsrID,dataList)
	S medsrRepLocDr=$p(dataList,"^",1) //科室
	S medsrRepLocCode=""
	I medsrRepLocDr'="" S medsrRepLocCode=$p(^CTLOC(medsrRepLocDr),"^",1)
	S medsrCreateDate=$p(dataList,"^",2)    //报告日期
	S:medsrCreateDate'="" medsrCreateDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(medsrCreateDate)
	S medsrCreateTime=$p(dataList,"^",3)    //报告时间
	S:medsrCreateTime'="" medsrCreateTime=$zth(medsrCreateTime,1)
	
	S medsrOccDate=$p(dataList,"^",4)    //发生日期
	S:medsrOccDate'="" medsrOccDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(medsrOccDate)
	S medsrOccTime=$p(dataList,"^",5)    //发生时间
	S:medsrOccTime'="" medsrOccTime=$zth(medsrOccTime,1)

	S medsrOccBatNo=$p(dataList,"^",6) //班次
	S medsrPatNo=$p(dataList,"^",7) //病人病案号（登记号）
	S medsrPatID=$p(dataList,"^",8) //病人ID
	S medsrName=$p(dataList,"^",9) //患者姓名
	S medsrSex=$p(dataList,"^",10) //性别	
	S medsrAge=$p(dataList,"^",11) //年龄

	S medsrDrugDr=$p(dataList,"^",12)     //应给药物id
	S medsrDrugName=""
	I medsrDrugDr'="" d
	.S medsrDrugName=$p(^INCI(medsrDrugDr,1),"^",1)     //应给药物代码
	S medsrDosage=$p(dataList,"^",13) //应给剂量
	S medsrErrNum=$p(dataList,"^",14) //累计错误给药次数
	
	S medsrCreatorDr=$p(dataList,"^",15)     //报告人id
	S medsrCreator=""
	I medsrCreatorDr'="" S medsrCreator=$p(^SSU("SSUSR",medsrCreatorDr),"^",1) //报告人工号
	S medsrCreatorCareProv=$p(dataList,"^",16)     //报告人职称
	
	S medsrCurStatusDR=$p(dataList,"^",17) //报告当前状态
	S medsrReportNo=$p(^DHCADVMEDSAR(medsrID),"^",19) //报告编码 $p(dataList,"^",18)
	S medsrReportType=$p(dataList,"^",19) //报告填报类型
	S medsrAdmNo=$p(dataList,"^",20) //就诊id
	S medsrOrdItm=$p(dataList,"^",21) //医嘱id
	S medsrRepImpFlag=$p(dataList,"^",22)  //重要标记
	
	&SQL(Update DHC_MedSafetyReport Set MEDSR_RepLoc_Dr=:medsrRepLocCode,MEDSR_CreateDate=:medsrCreateDate,MEDSR_CreateTime=:medsrCreateTime,MEDSR_OccDate=:medsrOccDate,
		MEDSR_OccTime=:medsrOccTime,MEDSR_OccBatNo=:medsrOccBatNo,MEDSR_PatNo=:medsrPatNo,MEDSR_PatID=:medsrPatID,MEDSR_PatName=:medsrName,MEDSR_PatSex=:medsrSex,
		MEDSR_PatAge=:medsrAge,MEDSR_DrugName=:medsrDrugName,MEDSR_Dosage=:medsrDosage,MEDSR_Creator=:medsrCreator,
		MEDSR_CreatorCareProv=:medsrCreatorCareProv,MEDSR_ErrNum=:medsrErrNum,MEDSR_CurStatus_DR=:medsrCurStatusDR,MEDSR_ReportNo=:medsrReportNo,MEDSR_ReportType=:medsrReportType,
		MEDSR_AdmNo=:medsrAdmNo,MEDSR_OrdItm=:medsrOrdItm,MEDSR_RepImpFlag=:medsrRepImpFlag Where MEDSR_RowID=:medsrID)
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 获取  用药安全环节id  
/// Creator:     CongYue
/// CreateDate:  2016-04-15
/// Table: 		 DHC_AdvMedUseLinkItm
/// Input:  	 DataList:环节代码^应当是^错误是^其他
/// Return: 	 用药安全环节id
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).GetMedUseLinkDr("1-1^^^")
ClassMethod GetMedUseLinkDr(DataList As %String) As %String
{
	N (DataList)
	S medItmCode=$p(DataList,"^",1)
	S medItmParref=$o(^DHCADVMUSELK(0,"ItmCode",$$ALPHAUP^SSUTIL4(medItmCode),""))
 	Q medItmParref
}

/// Description: 增加  用药安全报告环节  
/// Creator:     CongYue
/// CreateDate:  2015-12-23
/// Table: 		 DHC_MedReportLink
/// Input:  	 报告id , 报告环节id ,DataList:以字符"^"分割,格式为:工作类别^职称^其他 
/// Return: 	 保存成功 id,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).InsMedsReportLink("19","15","DocL^10^医生职称^")
/// InsMedsReportLink(medsrID,medUseLinkDr,DoctorMesList)
ClassMethod InsMedsReportLink(medsrID As %String, medUseLinkDr As %String, DataList As %String) As %String
{
	N (medsrID,medUseLinkDr,DataList)
	S medsrRepDr=medsrID
	S medsrLinkDr=medUseLinkDr
	S medsrJob=$p(DataList,"^",1)
	S medsrCareProv=$p(DataList,"^",2)
	S medsrOtherDesc=$p(DataList,"^",3)

 	&SQL(INSERT INTO DHC_MedReportLink(MEDSR_RepDr,MEDSR_LinkDr,MEDSR_Job,MEDSR_CareProv,MEDSR_OtherDesc) 
 	VALUES(:medsrRepDr,:medsrLinkDr,:medsrJob,:medsrCareProv,:medsrOtherDesc))
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 增加  用药安全报告环节项目  
/// Creator:     CongYue
/// CreateDate:  2015-12-24
/// Table: 		 DHC_MedReportLinkItm
/// Input:  	 报告环节id ,DataList:以字符"^"分割,格式为:环节代码^应当是^错误是^其他 
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).InsMedsReportLinkItm("1","","1-3^^^")
ClassMethod InsMedsReportLinkItm(medUseLinkDr As %String, medRepLinkDr As %String, DataList As %String) As %String
{
	N (medUseLinkDr,medRepLinkDr,DataList)
	
	S medsrParref=medRepLinkDr
	S medsrLinkItemCode=$p(DataList,"^",1)
	S medsrUseLinkItmSub=$o(^DHCADVMUSELK(0,"ItmCode",$$ALPHAUP^SSUTIL4(medsrLinkItemCode),medUseLinkDr,""))
	S medsrUseLinkItmDr=medUseLinkDr_"||"_medsrUseLinkItmSub
	S medsrCorrect=$p(DataList,"^",2)
	S medsrError=$p(DataList,"^",3)
	S medsrOtherDesc=$p(DataList,"^",4)
	S medsrChildSub=$o(^DHCADVMEDRLK(medsrParref,"MEDSRI",""),-1)+1
 	&SQL(INSERT INTO DHC_MedReportLinkItm(MEDSRI_MEDSR_Parref,MEDSR_ItmChildSub,MEDSR_LinkItem,MEDSR_Correct,MEDSR_Error,MEDSR_OtherDesc) 
 	VALUES(:medsrParref,:medsrChildSub,:medsrUseLinkItmDr,:medsrCorrect,:medsrError,:medsrOtherDesc))
 	Q SQLCODE
}

/// Description: 增加  用药差错报告后果  
/// Creator:     CongYue
/// CreateDate:  2015-12-24
/// Table: 		 DHC_MedReportResult
/// Input:  	 报告id , DataList:报告结果^报告子结果
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).InsMedsResult("1","2&3")
ClassMethod InsMedsResult(medsrID As %String, DataList As %String) As %String
{
	N (medsrID,DataList)
	S MedsrRepDr=medsrID
	S MedsrReslutDr=DataList
 	&SQL(INSERT INTO DHC_MedReportResult(MEDSR_RepDr,MEDSR_ReslutDr) 
 	VALUES(:MedsrRepDr,:MedsrReslutDr))
 	Q SQLCODE
}

/// Description: 删除不良反应相关信息表
/// Creator:     CongYue
/// CreateDate:  2015-12-24
/// Input:  	 报告id 
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).DelAdrRelatInfo("20")
ClassMethod DelAdrRelatInfo(medsrID As %String) As %String
{
	N (medsrID)
	//用药安全报告环节
	I $d(^DHCADVMEDRLK(0,"RepDr",medsrID)) D
	.&SQL(DELETE DHC_MedReportLink WHERE  MEDSR_RepDr=:medsrID)
	Q:+$g(SQLCODE)'=0 SQLCODE
	
	//用药差错报告后果
	I $d(^DHCADVMEDRRET(0,"RepDr",medsrID)) D
	.&SQL(DELETE DHC_MedReportResult WHERE MEDSR_RepDr=:medsrID)
	Q:+$g(SQLCODE)'=0 SQLCODE
	
	Q 0
}

/// Description: 保存  用药差错报告表
/// Creator:     CongYue
/// CreateDate:  2015-12-22
/// Table: 		 DHC_MedSafetyReport
/// Input:  	 报告表id,medsrDataList:报告表数据,medsrRepAuditList:以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).saveMedsafetyReport("76","63^2016-04-17^19:45:18^2016-04-17^19:45:25^白班^000090^0000000002^mic1^2^26^1034^1粒^^600^^^MEDSAR20160417001^4^5^6||73$c(2)10^yis^$c(2)1-2^阿莫西林胶囊[0.5g*16]^维生素AD滴剂(胶囊型)[伊可欣][A1500:D500iu*20粒]^$c(1)1-3^2粒^1粒^$c(2)23^^事药师信$c(2)2-1^维生素AD滴剂(胶囊型)[伊可欣][A1500:D500iu*20粒]^阿莫西林胶囊[0.5g*16]^$c(2)3-3^^^wqqw$c(2)4-4^口服^外用^$c(2)30^qweqwe^$c(2)5-3^一次^Bid^$c(2)2,10$c(2)即时行动/干预","")
ClassMethod saveMedsafetyReport(medsrID As %String, medsrDataList As %String, medsrRepAuditList As %String, flag As %String) As %String
{
	N (medsrID,medsrDataList,medsrRepAuditList,flag)
	S ret=0
	I medsrID="" D
	.S ret=..Insert(medsrDataList,medsrRepAuditList,flag)
	E  D
	.S ret=..Update(medsrID,medsrDataList,medsrRepAuditList,flag)
	Q ret
}

/// Description: 保存用药差错报表
/// Creator:     CongYue
/// CreateDate:  2015-12-22
/// Table: 		 DHC_MedSafetyReport
/// Input:  	 medsrDataList:报告表数据,medsrRepAuditList:以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return： 	 "0^"_medsrID:保存成功标志^报告表id
ClassMethod Insert(medsrDataList As %String, medsrRepAuditList As %String, flag As %String) As %String
{
	N (medsrDataList,medsrRepAuditList,flag)
	;s ^tlq("abc")=medsrDataList_","_medsrRepAuditList
	S Err=0
	S DataList=$p(medsrDataList,"$c(2)",1)
	S DoctorMesList=$p(medsrDataList,"$c(2)",2) //医生信息
	S DocLitmList=$p(medsrDataList,"$c(2)",3)  //医生环节信息
	S ApoMesList=$p(medsrDataList,"$c(2)",4) //药师信息
	S ApoLitmList=$p(medsrDataList,"$c(2)",5)  //药师环节信息
	S DispLitmList=$p(medsrDataList,"$c(2)",6) //配送环节信息
	S NurLitmList=$p(medsrDataList,"$c(2)",7)  //护士环节信息
	S NurseMesList=$p(medsrDataList,"$c(2)",8) //护士信息
	S PatLitmList=$p(medsrDataList,"$c(2)",9)  //患者环节信息
	
	S medsrReslutList=$p(medsrDataList,"$c(2)",10)  //报告后果
	S medsrNurAction=$p(medsrDataList,"$c(2)",11)  //报告干预
	S medUseLinkDr=""
	S medRepLinkDr=""
	TS
	S medsrID=..InsMedsReport(DataList)
	I medsrID<0 tro
	Q:medsrID<0 medsrID

	//医生环节信息与医生信息
	I DocLitmList'="" D
	.S ItmList=$p(DocLitmList,"$c(1)",1)
	.S medUseLinkDr=..GetMedUseLinkDr(ItmList)
	.S medRepLinkDr=..InsMedsReportLink(medsrID,medUseLinkDr,DoctorMesList)
	.S len=$L(DocLitmList,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(DocLitmList,"$c(1)",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsMedsReportLinkItm(medUseLinkDr,medRepLinkDr,TmpStr)
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-11"

	//药师环节信息与药师信息
	I ApoLitmList'="" D
	.S ItmList=$p(ApoLitmList,"$c(1)",1)
	.S medUseLinkDr=..GetMedUseLinkDr(ItmList)
	.S medRepLinkDr=..InsMedsReportLink(medsrID,medUseLinkDr,ApoMesList)
	.S len=$L(ApoLitmList,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(ApoLitmList,"$c(1)",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsMedsReportLinkItm(medUseLinkDr,medRepLinkDr,TmpStr)
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-12"

	//配送环节信息
	I DispLitmList'="" D
	.S ItmList=$p(DispLitmList,"$c(1)",1)
	.S medUseLinkDr=..GetMedUseLinkDr(ItmList)
	.S DispMesList=""_"^"_""_"^"_""
	.S medRepLinkDr=..InsMedsReportLink(medsrID,medUseLinkDr,DispMesList)
	.S len=$L(DispLitmList,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(DispLitmList,"$c(1)",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsMedsReportLinkItm(medUseLinkDr,medRepLinkDr,TmpStr)
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-13"

	//护士环节信息与护士信息
	I NurLitmList'="" D
	.S ItmList=$p(NurLitmList,"$c(1)",1)
	.S medUseLinkDr=..GetMedUseLinkDr(ItmList)
	.S medRepLinkDr=..InsMedsReportLink(medsrID,medUseLinkDr,NurseMesList)
	.S len=$L(NurLitmList,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(NurLitmList,"$c(1)",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsMedsReportLinkItm(medUseLinkDr,medRepLinkDr,TmpStr)
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-14"

	//患者环节信息
	I PatLitmList'="" D
	.S ItmList=$p(PatLitmList,"$c(1)",1)
	.S medUseLinkDr=..GetMedUseLinkDr(ItmList)
	.S PatMesList=""_"^"_""_"^"_""
	.S medRepLinkDr=..InsMedsReportLink(medsrID,medUseLinkDr,PatMesList)
	.S len=$L(PatLitmList,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(PatLitmList,"$c(1)",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsMedsReportLinkItm(medUseLinkDr,medRepLinkDr,TmpStr)
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-15"

	//用药差错报告后果
	I medsrReslutList'="" D
	.S Err=..InsMedsResult(medsrID,medsrReslutList)
	I Err'=0 tro
	Q:Err'=0 "-16"
	
	//报告干预
	I medsrNurAction'="" D
	.&sql(update DHC_MedSafetyReport set MEDSR_NurAction=:medsrNurAction where MEDSR_RowID=:medsrID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 s Err="-17"
	Q:Err'=0 "-17"
	
	//更新状态
	S adtList=medsrID_"^"_$p(medsrRepAuditList,"^",8)_"^"_$p(medsrRepAuditList,"^",2)_"^"_$p(medsrRepAuditList,"^",3)_"^"_$p(medsrRepAuditList,"^",4)
    S nextStatuDr=""
	I flag="1" D
	.S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(adtList)
	
	I (flag="1")&(+nextStatuDr'>0) tro
	Q:(flag="1")&(+nextStatuDr'>0) nextStatuDr
	
	I flag="1" D
	.&sql(update DHC_MedSafetyReport set MEDSR_CurStatus_DR=:nextStatuDr where MEDSR_RowID=:medsrID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 s Err="-19"
	Q:Err'=0 "-19"
	
	s medsrRepAuditList=nextStatuDr_"^"_$p(medsrRepAuditList,"^",2,8)
	
	//不良反应报告审批流程[默认插入初始状态]
	I medsrRepAuditList'="" D
	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(medsrID,medsrRepAuditList)
	I Err'=0 tro
	Q:Err'=0 "-20"
	
	TC
	Q "0^"_medsrID
}

/// Description: 保存用药差错报告表
/// Creator:     CongYue
/// CreateDate:  2015-12-22
/// Table: 		 DHC_MedSafetyReport
/// Input:  	 报告表id,medsrDataList:报告表数据,medsrRepAuditList:以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return： 	 "0^"_medsrID:保存成功标志^报告表id
ClassMethod Update(medsrID As %String, medsrDataList As %String, medsrRepAuditList As %String, flag As %String) As %String
{
	N (medsrID,medsrDataList,medsrRepAuditList,flag)
	S DataList=$p(medsrDataList,"$c(2)",1)
	S DoctorMesList=$p(medsrDataList,"$c(2)",2) //医生信息
	S DocLitmList=$p(medsrDataList,"$c(2)",3)  //医生环节信息
	
	S ApoMesList=$p(medsrDataList,"$c(2)",4) //药师信息
	S ApoLitmList=$p(medsrDataList,"$c(2)",5)  //药师环节信息
	S DispLitmList=$p(medsrDataList,"$c(2)",6) //配送环节信息
	S NurLitmList=$p(medsrDataList,"$c(2)",7)  //护士环节信息
	S NurseMesList=$p(medsrDataList,"$c(2)",8) //护士信息
	S PatLitmList=$p(medsrDataList,"$c(2)",9)  //患者环节信息
	
	S medsrReslutList=$p(medsrDataList,"$c(2)",10)  //报告后果
	S medsrNurAction=$p(medsrDataList,"$c(2)",11)  //报告干预
	S RepStatus=$p(^DHCADVMEDSAR(medsrID),"^",18)     //当前状态
	TS
	S medsrID=..UpdMedsReport(medsrID,DataList)
	I medsrID<0 tro
	Q:medsrID<0 medsrID
	
	//删除相关子表
	S Err=..DelAdrRelatInfo(medsrID)
	I Err'=0 tro
	Q:Err'=0 "-10"
	
	//医生环节信息与医生信息
	I DocLitmList'="" D
	.S ItmList=$p(DocLitmList,"$c(1)",1)
	.S medUseLinkDr=..GetMedUseLinkDr(ItmList)
	.S medRepLinkDr=..InsMedsReportLink(medsrID,medUseLinkDr,DoctorMesList)
	.S len=$L(DocLitmList,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(DocLitmList,"$c(1)",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsMedsReportLinkItm(medUseLinkDr,medRepLinkDr,TmpStr)
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-11"

	//药师环节信息与药师信息
	I ApoLitmList'="" D
	.S ItmList=$p(ApoLitmList,"$c(1)",1)
	.S medUseLinkDr=..GetMedUseLinkDr(ItmList)
	.S medRepLinkDr=..InsMedsReportLink(medsrID,medUseLinkDr,ApoMesList)
	.S len=$L(ApoLitmList,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(ApoLitmList,"$c(1)",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsMedsReportLinkItm(medUseLinkDr,medRepLinkDr,TmpStr)
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-12"

	//配送环节信息
	I DispLitmList'="" D
	.S ItmList=$p(DispLitmList,"$c(1)",1)
	.S medUseLinkDr=..GetMedUseLinkDr(ItmList)
	.S DispMesList=""_"^"_""_"^"_""
	.S medRepLinkDr=..InsMedsReportLink(medsrID,medUseLinkDr,DispMesList)
	.S len=$L(DispLitmList,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(DispLitmList,"$c(1)",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsMedsReportLinkItm(medUseLinkDr,medRepLinkDr,TmpStr)
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-13"

	//护士环节信息与护士信息
	I NurLitmList'="" D
	.S ItmList=$p(NurLitmList,"$c(1)",1)
	.S medUseLinkDr=..GetMedUseLinkDr(ItmList)
	.S medRepLinkDr=..InsMedsReportLink(medsrID,medUseLinkDr,NurseMesList)
	.S len=$L(NurLitmList,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(NurLitmList,"$c(1)",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsMedsReportLinkItm(medUseLinkDr,medRepLinkDr,TmpStr)
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-14"
	
	//患者环节信息
	I PatLitmList'="" D
	.S ItmList=$p(PatLitmList,"$c(1)",1)
	.S medUseLinkDr=..GetMedUseLinkDr(ItmList)
	.S PatMesList=""_"^"_""_"^"_""
	.S medRepLinkDr=..InsMedsReportLink(medsrID,medUseLinkDr,PatMesList)
	.S len=$L(PatLitmList,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(PatLitmList,"$c(1)",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsMedsReportLinkItm(medUseLinkDr,medRepLinkDr,TmpStr)
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-15"
	
	//用药差错报告后果
	I medsrReslutList'="" D
	.S Err=..InsMedsResult(medsrID,medsrReslutList)
	I Err'=0 tro
	Q:Err'=0 "-16"

	//报告干预
	I medsrNurAction'="" D
	.&sql(update DHC_MedSafetyReport set MEDSR_NurAction=:medsrNurAction where MEDSR_RowID=:medsrID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 s Err="-17"
	Q:Err'=0 "-17"
		
	//更新状态
	S adtList=medsrID_"^"_$p(medsrRepAuditList,"^",8)_"^"_$p(medsrRepAuditList,"^",2)_"^"_$p(medsrRepAuditList,"^",3)_"^"_$p(medsrRepAuditList,"^",4)
	S nextStatuDr=""
	I flag="1" D
	.S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(adtList)
	
	I (flag="1")&(+nextStatuDr'>0) tro
	Q:(flag="1")&(+nextStatuDr'>0) nextStatuDr

	I flag="1" D
	.&sql(update DHC_MedSafetyReport set MEDSR_CurStatus_DR=:nextStatuDr where MEDSR_RowID=:medsrID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 s Err="-19"
	
	Q:Err'=0 "-19"
	
	S:flag="1" medsrRepAuditList=nextStatuDr_"^"_$p(medsrRepAuditList,"^",2,8)
	S:flag="0" medsrRepAuditList=RepStatus_"^"_$p(medsrRepAuditList,"^",2,8)
	//不良反应报告审批流程[默认插入初始状态]
	I medsrRepAuditList'="" D
	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(medsrID,medsrRepAuditList)
	I Err'=0 tro
	Q:Err'=0 "-20"
	
	TC
	
	Q "0^"_medsrID
}

/// Description: 删除  用药差错报告表  
/// Creator:     CongYue
/// CreateDate:  2016-01-12
/// Table: 		 DHC_MedSafetyReport
/// Input:  	 报告表的id 
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).DelMedsReport("88")
ClassMethod DelMedsReport(params As %String) As %String
{
	N (params)
	S medsrID=$p(params,"^",1)
	S UserID=$p(params,"^",2)
	S repUser=$p(^DHCADVMEDSAR(medsrID),"^",15)    //报告人工号
	S repCurStatDR=$p(^DHCADVMEDSAR(medsrID),"^",18)     //当前状态
	S repUserID=""
	I repUser'=""  d
	.S repUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(repUser),""))
	Q:UserID'=repUserID "-1" //不是本人，不能删除
	Q:repCurStatDR'="" "-2" //已提交，不能删除
	
	TS
	&SQL(DELETE DHC_MedSafetyReport WHERE MEDSR_RowID=:medsrID)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 -3

	//删除相关表
	S Err=..DelAdrRelatInfo(medsrID)
	I Err'=0 tro
	Q:Err'=0 "-10"
	TC
	Q 0
}

/// Description: 保存[用药环节]
/// Creator:     CongYue
/// CreateDate:  2015-12-15
/// Table: 		 DHC_AdvMedUseLink
/// Input:  	 DataList: 用药环节数据信息, 以字符"^"分割,格式为：代码^描述&&代码^描述,
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).SaveMedUseLink("^DocL^医生环节")
ClassMethod SaveMedUseLink(DataList As %String) As %String
{
	N (DataList)
	S Err=0
	S len=$L(DataList,"&&")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"&&",i)
	.S Err=..CheckRepeatDeal(TmpStr)   /// 重复性判断
	.Q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdMedUseLink(TmpStr)
	.E  D
	..S Err=..InsMedUseLink(TmpStr)
	Q Err
}

/// Description: 保存[检查代码是否重复]
/// Creator:     CongYue
/// CreateDate:  2016-05-23
/// Table:		 DHC_AdvMedUseLink
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).CheckRepeatDeal("2^DocL^医生环节")
ClassMethod CheckRepeatDeal(TmpStr As %String) As %String
{
	N (TmpStr)
	s MulID=$p(TmpStr,"^",1)   		///ID
	s MulCode=$p(TmpStr,"^",2)   	///代码
	/// 新记录
	q:(MulID="")&($d(^DHCADVMUSELK(0,"Code",$$ALPHAUP^SSUTIL4(MulCode)))) "-1"
	q:MulID="" 0
	
	/// 修改记录
	s Code=$p($g(^DHCADVMUSELK(MulID)),"^",1)    //代码
	q:(MulCode'=Code)&($d(^DHCADVMUSELK(0,"Code",$$ALPHAUP^SSUTIL4(MulCode)))) "-2"
	q 0
}

/// Description: 更新[用药环节]
/// Creator:     CongYue
/// CreateDate:  2015-12-15
/// Table: 		 DHC_AdvMedUseLink
/// Input:  	 DataList: 用药环节数据信息, 以字符"^"分割,格式为：id^代码^描述,
/// Return:	 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).UpdMedUseLink("")
ClassMethod UpdMedUseLink(DataList As %String) As %String
{
	N (DataList)
	S MulID=$p(DataList,"^",1)
	S MulCode=$p(DataList,"^",2)
	S MulDesc=$p(DataList,"^",3)
	&SQL(Update DHC_AdvMedUseLink Set MUL_Code=:MulCode, MUL_Desc=:MulDesc WHERE MUL_RowID=:MulID)
 	Q SQLCODE
}

/// Description: 增加[用药环节]
/// Creator:     CongYue
/// CreateDate:  2015-12-15
/// Table: 		 DHC_AdvMedUseLink
/// Input:  	 DataList: 用药环节数据信息, 以字符"^"分割,格式为：id^代码^描述,
/// Return:	 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).InsMedUseLink("")
ClassMethod InsMedUseLink(DataList As %String) As %String
{
	N (DataList)
	S MulCode=$p(DataList,"^",2)
	S MulDesc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_AdvMedUseLink(MUL_Code,MUL_Desc) VALUES(:MulCode,:MulDesc))
 	Q SQLCODE
}

/// Description: 删除 [用药环节]
/// Creator:     CongYue
/// CreateDate:  2015-12-15
/// Table: 	 	 DHC_AdvMedUseLink
/// Input:   	 表的id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).DelMedUseLink("1")
ClassMethod DelMedUseLink(MulID As %String) As %String
{
	N (MulID)
	Q:$d(^DHCADVMEDRLK(0,"LinkDr",MulID)) -1  ;判断此用药环节是否存在报告使用记录
	&SQL(Delete From DHC_AdvMedUseLink Where MUL_RowID=:MulID)
	Q SQLCODE
}

/// Description: 查询[用药环节]
/// Creator:     CongYue
/// CreateDate:  2015-12-15
/// Table: 		 DHC_AdvMedUseLink
/// Input:  	 params：订单信息，以字符"^"分割,格式为：代码^描述,
/// Output:  	 DHC_AdvMedUseLink表中的数据信息   
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).QueryMedUseLink("12","1","")
ClassMethod QueryMedUseLink(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    S code=$p(params,"^",1)
    S desc=$p(params,"^",2)
	S h=0,count=0
	S ID="0"
	F  S ID=$o(^DHCADVMUSELK(ID)) Q:ID=""  D
	.S Code=$p(^DHCADVMUSELK(ID),"^",1) //代码
	.S Desc=$p(^DHCADVMUSELK(ID),"^",2) //描述
	.Q:(code'="")&(Code'[code)
	.Q:(desc'="")&(Desc'[desc)
	.S h=h+1
	.S TempStr=ID_"^"_Code_"^"_Desc
	.S ^TMP("DHCADV","web.DHCADVMEDSAREPORT","QueryMedUseLink",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVMEDSAREPORT","QueryMedUseLink",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVMEDSAREPORT","QueryMedUseLink",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 保存[用药环节项目]
/// Creator:     CongYue
/// CreateDate:  2015-12-15
/// Table: 	 	 DHC_AdvMedUseLinkItm
/// Input:  	 DataList: 用药环节项目数据信息, 以字符"^"分割,格式为：代码^描述^是否可用&&代码^描述^是否可用,
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).SaveMedUseLinkItm("^器械填报^器械填报^")
ClassMethod SaveMedUseLinkItm(DataList As %String) As %String
{
	N (DataList)
	S Err=0
	S len=$L(DataList,"&&")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"&&",i)
	.S Err=..CheckRepeatDealItm(TmpStr)   /// 重复性判断
	.Q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdMedUseLinkItm(TmpStr)
	.E  D
	..S Err=..InsMedUseLinkItm(TmpStr)
	Q Err
}

/// Description: 保存[检查代码是否重复]
/// Creator:     CongYue
/// CreateDate:  2016-05-23
/// Table:		 DHC_AdvMedUseLinkItm
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).CheckRepeatDealItm("2||1^2^2-1^医生环节^Y")
ClassMethod CheckRepeatDealItm(TmpStr As %String) As %String
{
	N (TmpStr)
	S MULiID=$p(TmpStr,"^",1)   		///ID
	S Parref=+$p(TmpStr,"^",2)			///主表ID
	S ChildSub=$p(MULiID,"||",2)
	S MULiCode=$p(TmpStr,"^",3)   	///代码
	/// 新记录
	Q:(MULiID="")&($d(^DHCADVMUSELK(0,"ItmCode",$$ALPHAUP^SSUTIL4(MULiCode),Parref))) "-1"
	Q:MULiID="" 0
	
	/// 修改记录
	S Code=$p(^DHCADVMUSELK(Parref,"MULI",ChildSub),"^",1) //代码
	Q:(MULiCode'=Code)&($d(^DHCADVMUSELK(0,"ItmCode",$$ALPHAUP^SSUTIL4(MULiCode),Parref))) "-2"
	Q 0
}

/// Description: 更新[用药环节项目]
/// Creator:     CongYue
/// CreateDate:  2015-12-15
/// Table: 		 DHC_AdvMedUseLinkItm    
/// Input:  	 DataList: 用药环节项目数据信息, 以字符"^"分割,格式为：id^主表id^代码^描述^是否可用（1||2^1^1-2^医嘱转抄错误^Y）,
/// Return:		 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).UpdMedUseLinkItm("")
ClassMethod UpdMedUseLinkItm(DataList As %String) As %String
{
	N (DataList)
	S MULiID=$p(DataList,"^",1)
	S Code=$p(DataList,"^",3)
	S Desc=$p(DataList,"^",4)
	S Active=$p(DataList,"^",5)
	&SQL(Update DHC_AdvMedUseLinkItm Set MUL_ItmCode=:Code,MUL_ItmDesc=:Desc,MUL_ItmActive=:Active WHERE MUL_ItmRowID=:MULiID)
 	Q SQLCODE
}

/// Description: 增加[用药环节项目]
/// Creator:     CongYue
/// CreateDate:  2015-12-15
/// Table: 		 DHC_AdvMedUseLinkItm  
/// Input:  	 DataList: 用药环节项目数据信息, 以字符"^"分割,格式为：id^主表id^代码^描述^是否可用(^1^1-2^医嘱转抄错误^Y),
/// Return:		 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).InsMedUseLinkItm("")
ClassMethod InsMedUseLinkItm(DataList As %String) As %String
{
	N (DataList)
	S parref=+$p(DataList,"^",2)
	S Code=$p(DataList,"^",3)
	S Desc=$p(DataList,"^",4)
	S Active=$p(DataList,"^",5)
	S childSub=$o(^DHCADVMUSELK(parref,"MULI",""),-1)+1
 	&SQL(INSERT INTO DHC_AdvMedUseLinkItm(MULI_MUL_Parref, MUL_ItmChildSub,MUL_ItmCode,MUL_ItmDesc,MUL_ItmActive)
 		 VALUES(:parref,:childSub,:Code,:Desc,:Active))
 	Q SQLCODE
}

/// Description: 删除 [用药环节项目]
/// Creator:     CongYue
/// CreateDate:  2015-12-15
/// Table: 		 DHC_AdvMedUseLinkItm
/// Input:  	 表的id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).DelMedUseLinkItm("1||4")
ClassMethod DelMedUseLinkItm(MULiID As %String) As %String
{
	N (MULiID)
	Q:$d(^DHCADVMEDRLK(0,"LinkItem",MULiID)) -1  ;判断此用药环节项目是否存在报告使用记录
	&SQL(Delete From DHC_AdvMedUseLinkItm Where MUL_ItmRowID=:MULiID)
	Q SQLCODE
}

/// Description: 查询[用药环节项目]
/// Creator:     CongYue
/// CreateDate:  2015-12-15
/// Table: 		 DHC_AdvMedUseLinkItm
/// Input:  	 主表的id
/// Output:  	 DHC_AdvMedUseLinkItm表中的数据信息   
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).QueryMedUseLinkItm("12","1","1")
ClassMethod QueryMedUseLinkItm(rows As %String, page As %String, MULID As %String) As %String
{
	N (rows,page,MULID)
	S endpage = page*rows
	S stpage = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
	S h=0,count=0
	S CH=""
	F  S CH=$o(^DHCADVMUSELK(MULID,"MULI",CH)) Q:CH=""  D
	.S Code=$p(^DHCADVMUSELK(MULID,"MULI",CH),"^",1) //代码
	.S Desc=$p(^DHCADVMUSELK(MULID,"MULI",CH),"^",2) //描述
	.S Active=$p(^DHCADVMUSELK(MULID,"MULI",CH),"^",3) //是否可用
	.S h=h+1
	.S TempStr=MULID_"||"_CH_"^"_Code_"^"_Desc_"^"_Active
	.S ^TMP("DHCADV","web.DHCADVMEDSAREPORT","QueryMedUseLinkItm",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).GetNoJson()
	
	///转换数据为Json格式
	S Title="ID^Code^Desc^Active"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVMEDSAREPORT","QueryMedUseLinkItm",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVMEDSAREPORT","QueryMedUseLinkItm",pid,index))
	.S count = count+1
	.Q:(count<stpage)||(count>endpage)
	.I count=stpage D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 查询[用药环节项目]
/// Creator:     CongYue
/// CreateDate:  2015-12-15
/// Table: 		 DHC_AdvMedUseLinkItm
/// Input:  	 params:用药环节id^报告表id
/// Output:  	 DHC_AdvMedUseLinkItm表中的数据信息   
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).QueryMULinkItm("12","1","PatL^76")
ClassMethod QueryMULinkItm(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S MULCode=$p(params,"^",1)
	S MULID=$o(^DHCADVMUSELK(0,"Code",$$ALPHAUP^SSUTIL4(MULCode),""))
	S medsrID=$p(params,"^",2)
	S endpage = page*rows
	S stpage = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
	
	S h=0,count=0
	I medsrID="" D
	.S CH=""
	.F  S CH=$o(^DHCADVMUSELK(MULID,"MULI",CH)) Q:CH=""  D
	..S Code=$p(^DHCADVMUSELK(MULID,"MULI",CH),"^",1) //代码
	..S Desc=$p(^DHCADVMUSELK(MULID,"MULI",CH),"^",2) //描述
	..S Active=$p(^DHCADVMUSELK(MULID,"MULI",CH),"^",3) //是否可用
	..Q:Active="N"  //2017-07-13
	..S Correct=""
	..S Error=""
	..S OtherDesc=""
	..S h=h+1
	..S TempStr=MULID_"||"_CH_"^"_Code_"^"_Desc_"^"_Active_"^"_Correct _"^"_Error_"^"_OtherDesc
	..S ^TMP("DHCADV","web.DHCADVMEDSAREPORT","QueryMULinkItm",pid,h)=TempStr
	.
	E  D
	.S CH=""
	.F  S CH=$o(^DHCADVMUSELK(MULID,"MULI",CH)) Q:CH=""  D
	..S Code=$p(^DHCADVMUSELK(MULID,"MULI",CH),"^",1) //代码
	..S Desc=$p(^DHCADVMUSELK(MULID,"MULI",CH),"^",2) //描述
	..S Active=$p(^DHCADVMUSELK(MULID,"MULI",CH),"^",3) //是否可用
	..Q:Active="N"
	..S Correct=""
	..S Error=""
	..S OtherDesc=""
	..S parref=""
	..S flag="N"
	..S ID=MULID_"||"_CH
	..F  S parref=$o(^DHCADVMEDRLK(0,"RepDr",medsrID,parref)) Q:parref=""  D 
	...S ChildSub=""
	...F  S ChildSub=$o(^DHCADVMEDRLK(parref,"MEDSRI",ChildSub)) Q:ChildSub=""  D 
	....S IDdr=parref_"||"_ChildSub
	....S medsrLinkItem=$p(^DHCADVMEDRLK(parref,"MEDSRI",ChildSub),"^",1)
	....I medsrLinkItem=ID D
	.....S flag="Y"
	.....S Correct=$p(^DHCADVMEDRLK(parref,"MEDSRI",ChildSub),"^",2)
	.....S Error=$p(^DHCADVMEDRLK(parref,"MEDSRI",ChildSub),"^",3)
	.....S OtherDesc=$p(^DHCADVMEDRLK(parref,"MEDSRI",ChildSub),"^",4)
	....
	...
	..S h=h+1
	..S TempStr=MULID_"||"_CH_"^"_Code_"^"_Desc_"^"_Active_"^"_Correct _"^"_Error_"^"_OtherDesc_"^"_flag
	..S ^TMP("DHCADV","web.DHCADVMEDSAREPORT","QueryMULinkItm",pid,h)=TempStr
	.
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).GetNoJson()
	
	///转换数据为Json格式
	S Title="ID^Code^Desc^Active^Correct^Error^OtherDesc^flag"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVMEDSAREPORT","QueryMULinkItm",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVMEDSAREPORT","QueryMULinkItm",pid,index))
	.S count = count+1
	.Q:(count<stpage)||(count>endpage)
	.I count=stpage D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 获取页面默认信息（日期，编码）
/// Creator:     CongYue
/// CreateDate:  2015-12-21
/// Input:  	 params:  以字符"^"分割,格式为:人员id^科室id^安全组id^报告类型代码
/// Return:  	 页面默认信息: 报告日期^报告初始状态^报告类型^科室^报告编码^报告人职称 
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).getMedsrInfo("600^63^126^material")
ClassMethod getMedsrInfo(params As %String) As %String
{
	N (params)
	S repdate=$zdt($H,3)
	S List=##class(web.DHCADVCOMMON).GetStatusDr(params)
	Q:List="" -1
	S MedsrReportType=$p(List,"^",1)  //报告类型
	S MedsrInitStatDR=$p(List,"^",2)  //审核状态
	
	S UserID=$p(params,"^",1)  //报告人ID
	S UserName=""
	I UserID'="" D
	.S UserName=$p(^SSU("SSUSR",UserID),"^",2)
	.S CreatorCareProvDr=$p(^SSU("SSUSR",UserID),"^",14) ;2017-08-03 cy修改 获取报告人职称指向
	.I CreatorCareProvDr'=""  D
	..S CtpcpCarPrvTpDR=$p(^CTPCP(CreatorCareProvDr,1),"^",4)
	..I CtpcpCarPrvTpDR'="" D
	...S CreatorCareProv=$p(^CT("CPT",CtpcpCarPrvTpDR),"^",2) // 报告人职称
	..
	.E  D
	..S CreatorCareProv=""
	S LocID=$p(params,"^",2)  //科室ID
	I LocID'="" D
	.S LocDesc=$p(^CTLOC(LocID),"^",2)

	S Prefix="MEDSAR"_$zd(+$H,8)  //报告编码规则 "MEDSAR"+年月日+顺序号
	S MedsaReportNo=..GetAdrReportCurMaxNo(Prefix,"3")	

	Q repdate_"^"_MedsrInitStatDR_"^"_MedsrReportType_"^"_MedsaReportNo_"^"_UserID_"^"_UserName_"^"_LocID_"^"_$g(LocDesc)_"^"_CreatorCareProv
}

/// Description: 取当前不良反应报告最大码
/// Creator:	 CongYue
/// CreateDate:  2015-12-21
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
/// CreateDate:  2015-12-21
/// Input:  	 报告编码规则
/// Return:  	 当前最大码  
ClassMethod GetMaxCodeByCode(Prefix As %String) As %String
{
	N (Prefix)
	Q:Prefix="" ""
	S matacode=""
	&sql(select max(MEDSR_ReportNo) into matacode from DHC_MedSafetyReport Where MEDSR_ReportNo %STARTSWITH %ALPHAUP :Prefix)
	Q matacode
}

/// Description: k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	K ^TMP("DHCADV","web.DHCADVMEDSAREPORT","QueryMedUseLink",pid)
	K ^TMP("DHCADV","web.DHCADVMEDSAREPORT","QueryMedUseLinkItm",pid)
	K ^TMP("DHCADV","web.DHCADVMEDSAREPORT","QueryMULinkItm",pid)
	K ^TMP("DHCST","web.DHCADVMEDSAREPORT","QueryDrugDesc",pid)
	K ^TMP("DHCST","web.DHCADVMEDSAREPORT","QueryPhcInDesc",pid)
	K ^TMP("DHCST","web.DHCADVMEDSAREPORT","QueryPhcFreqDesc",pid)
}

/// Description: 科室
/// Creator:     congyue
/// CreateDate:  2015-12-28
/// Table: 		 CT_LOC
/// Output:  	 所有科室描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).SelLocDesc("")
ClassMethod SelLocDesc(input) As %String
{
	n (input)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT CTLOC_ROWID as LocDr, CTLOC_Desc as LocDesc,CTLOC_ContactName as LocContactName  FROM CT_LOC"
	i input'=""  d
	.s input=$zcvt(input,"U") 
	.s sqlStr=sqlStr_" WHERE CTLOC_ContactName LIKE """_""_input_""_"%"_""" OR CTLOC_Desc LIKE """_""_input_""_"%"_""_""" "
	;.//旧版(拼音码和描述为分开) S sqlStr = "SELECT CTLOC_ROWID as LocDr, CTLOC_Desc as LocDesc FROM CT_LOC"
    D result.Prepare(sqlStr)
	D result.Execute()
	S count = 0
	W "["
	While(result.Next())
	{	
		S LocDr = result.Data("LocDr")
		S LocDesc = result.Data("LocDesc")
		;S LocContactName=result.Data("LocContactName")
		;continue:(input'="")&(LocContactName'[input)&(LocDesc'[input)
		S tmp=LocDr_"^"_LocDesc
		S count = count+1
		I count=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	}
	W "]"
}

/// Description: 药物
/// Creator:     congyue
/// CreateDate:  2015-12-29
/// Table: 		 INC_ALIAS
/// Output:  	 所有药物描述（小界面显示）  
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).QueryDrugDesc("12","1","amxl")
ClassMethod QueryDrugDesc(rows As %String, page As %String, Input As %String, MedUseCode As %String) As %String
{
	N (rows,page,Input,MedUseCode)
	
	S End = page*rows
	S Start=(page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    S DrugID=""
	S h=0,count=0
	F  S DrugID=$o(^INCALIAS(DrugID)) Q:DrugID=""  D
	.Q:+DrugID=0
	.S Inci=$p(^INCALIAS(DrugID),"^",1)
	.s CatGrpCode=..CatGrpCode(Inci)
	.Q:CatGrpCode'="G"
	.S DrugCode=$p(^INCALIAS(DrugID),"^",2)
	.S DrugDesc=$p(^INCALIAS(DrugID),"^",3)
	.S Drugtext=$p(^INCALIAS(DrugID),"^",4)
	.i Drugtext'="" s Drugtext=$ZCVT(Drugtext,"U")
	.i Input'="" s Input=$ZCVT(Input,"U")
	.Q:Drugtext'[Input
	.
	.S h=h+1
	.S TempStr=DrugID_"^"_DrugCode_"^"_DrugDesc_"^"_MedUseCode
	.S ^TMP("DHCST","web.DHCADVMEDSAREPORT","QueryDrugDesc",pid,h)=TempStr
	.
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	///转换数据为Json格式
	S Title="DrugID^DrugCode^DrugDesc^MedUseCode"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCADVMEDSAREPORT","QueryDrugDesc",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCST","web.DHCADVMEDSAREPORT","QueryDrugDesc",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

ClassMethod CatGrpCode(inci As %String) As %String
{
	N (inci)
	Q:'$d(^INCI(inci,2)) ""
	S INCSC=$p(^INCI(inci,2),"^",2)
	Q:INCSC="" ""
	S SCG=$o(^DHCSCG("STKCAT",+INCSC,"")) Q:SCG="" ""
	;s CH=$o(^DHCSCG("STKCAT",INCSC,SCG,"")) q:CH="" ""
	S CATGRPCODE=$P(^DHCSCG(+SCG),"^",3)
	Q $g(CATGRPCODE)
}

/// Description: 给药途径（药品用法）
/// Creator:     congyue
/// CreateDate:  2016-03-15
/// Table: 		 PHC_Instruc
/// Output:  	 所有药品用法描述（小界面显示）  
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).QueryPhcInDesc("12","1","")
ClassMethod QueryPhcInDesc(rows As %String, page As %String, Input As %String, MedUseCode As %String) As %String
{
	N (rows,page,Input,MedUseCode)
	
	S End = page*rows
	S Start=(page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    S PhcInID=""
	S h=0,count=0
	F  S PhcInID=$o(^PHCIN(PhcInID)) Q:PhcInID=""  D
	.Q:+PhcInID=0
	.S PhcInCode=$p(^PHCIN(PhcInID),"^",1)
	.S PhcInDesc=$p(^PHCIN(PhcInID),"^",2)
	.Q:PhcInDesc'[Input
	.
	.S h=h+1
	.S TempStr=PhcInID_"^"_PhcInCode_"^"_PhcInDesc_"^"_MedUseCode
	.S ^TMP("DHCST","web.DHCADVMEDSAREPORT","QueryPhcInDesc",pid,h)=TempStr
	.
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	///转换数据为Json格式
	S Title="PhcInID^PhcInCode^PhcInDesc^MedUseCode"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCADVMEDSAREPORT","QueryPhcInDesc",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCST","web.DHCADVMEDSAREPORT","QueryPhcInDesc",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 给药频率（用药频率）
/// Creator:     congyue
/// CreateDate:  2016-03-15
/// Table: 		 PHC_Freq 
/// Output:  	 所有药品用法描述（小界面显示）  
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).QueryPhcFreqDesc("12","1","")
ClassMethod QueryPhcFreqDesc(rows As %String, page As %String, Input As %String, MedUseCode As %String) As %String
{
	N (rows,page,Input,MedUseCode)
	
	S End = page*rows
	S Start=(page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    S PhcFreqID=""
	S h=0,count=0
	F  S PhcFreqID=$o(^PHCFR(PhcFreqID)) Q:PhcFreqID=""  D
	.Q:+PhcFreqID=0
	.S PhcFreqCode=$p(^PHCFR(PhcFreqID),"^",1)
	.S PhcFreqDesc=$p(^PHCFR(PhcFreqID),"^",3)
	.S PhcFreqDescs=$p(^PHCFR(PhcFreqID),"^",4)
	.Q:PhcFreqDesc'[Input
	.
	.S h=h+1
	.S TempStr=PhcFreqID_"^"_PhcFreqCode_"^"_PhcFreqDesc_"^"_PhcFreqDescs_"^"_MedUseCode
	.S ^TMP("DHCST","web.DHCADVMEDSAREPORT","QueryPhcFreqDesc",pid,h)=TempStr
	.
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	///转换数据为Json格式
	S Title="PhcFreqID^PhcFreqCode^PhcFreqDesc^PhcFreqDescs^MedUseCode"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCADVMEDSAREPORT","QueryPhcFreqDesc",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCST","web.DHCADVMEDSAREPORT","QueryPhcFreqDesc",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 获取用药差错报告信息
/// Creator:     CongYue
/// CreateDate:  2015-12-30
/// Input:  	 报告表id  , params:以字符"^"分割,格式为:人员id^科室id^安全组id^报告类型代码
/// Output:  	 报告表数据   
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).getMedsRepInfo("46","600^63^126^drugerr")
ClassMethod getMedsRepInfo(medsrID As %String, params As %String) As %String
{
	N (medsrID,params)

	Q:'$d(^DHCADVMEDSAR(medsrID)) ""
	
	S medsrRepLocDr=$p(^DHCADVMEDSAR(medsrID),"^",1)   //科室
	
	S medsrRepLocCode=$p(^DHCADVMEDSAR(medsrID),"^",1) //科室
	S medsrRepLocDr=""
	S medsrRepLocDesc=""
	I medsrRepLocCode'=""  d
	.S medsrRepLocDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(medsrRepLocCode),""))
	.S medsrRepLocDesc=$p(^CTLOC(medsrRepLocDr),"^",2)
	
	S medsrCreateDate=$p(^DHCADVMEDSAR(medsrID),"^",2)    //报告 日期
	S:medsrCreateDate'="" medsrCreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(medsrCreateDate)
	S medsrCreateTime=$p(^DHCADVMEDSAR(medsrID),"^",3)    //报告 时间
	S:medsrCreateTime'="" medsrCreateTime=$zt(medsrCreateTime,1)
	
	S medsrOccDate=$p(^DHCADVMEDSAR(medsrID),"^",4)    //报告 日期
	S:medsrOccDate'="" medsrOccDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(medsrOccDate)
	S medsrOccTime=$p(^DHCADVMEDSAR(medsrID),"^",5)    //报告 时间
	S:medsrOccTime'="" medsrOccTime=$zt(medsrOccTime,1)
	
	S medsrOccBatNo=$p(^DHCADVMEDSAR(medsrID),"^",6)      //班次
	S medsrPatNo=$p(^DHCADVMEDSAR(medsrID),"^",7)     //病案号
	S medsrPatID=$p(^DHCADVMEDSAR(medsrID),"^",8)     //病人ID（登记号）
	S medsrName=$p(^DHCADVMEDSAR(medsrID),"^",9)   //姓名
	S medsrSex=$p(^DHCADVMEDSAR(medsrID),"^",10)     //性别
	S medsrAge=$p(^DHCADVMEDSAR(medsrID),"^",11)     //年龄
	
	S medsrDrugCode=$p(^DHCADVMEDSAR(medsrID),"^",12)     //药物名称
	S medsrDrugName=""
	S medsrDrugDr=""
	I medsrDrugCode'=""  d
	.S medsrDrugDr=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(medsrDrugCode),"")) //药物id
	.S medsrDrugName=$p(^INCI(medsrDrugDr,1),"^",2)
	S medsrDosage=$p(^DHCADVMEDSAR(medsrID),"^",13)     //应给剂量
	S medsrNurAction=$p(^DHCADVMEDSAR(medsrID),"^",14)     //即时行动
	S medsrCreatorCode=$p(^DHCADVMEDSAR(medsrID),"^",15)    //报告人工号
	S medsrCreator=""
	S medsrCreatorDesc=""
	I medsrCreatorCode'=""  d
	.S medsrCreator=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(medsrCreatorCode),""))
	.S medsrCreatorDesc=$p(^SSU("SSUSR",medsrCreator),"^",2)
	
	
	S medsrCreatorCareProv=$p(^DHCADVMEDSAR(medsrID),"^",16) //报告人职称
	S medsrErrNum=$p(^DHCADVMEDSAR(medsrID),"^",17)     //累计错误次数
	
	S medsrCurStatusDR=$p(^DHCADVMEDSAR(medsrID),"^",18)     //当前状态
	
	S medsrReportNo=$p(^DHCADVMEDSAR(medsrID),"^",19) //报告编码
	S medsrReportType=$p(^DHCADVMEDSAR(medsrID),"^",20)    //填报类型
	S medsrReportType=$p(^DHCADVMEDSAR(medsrID),"^",20)    //填报类型
	S medsrAdmNo=$p(^DHCADVMEDSAR(medsrID),"^",21) //就诊id
	S medsrOrdItm=$p(^DHCADVMEDSAR(medsrID),"^",22)    //医嘱id
    S medsrRepImpFlag=$p(^DHCADVMEDSAR(medsrID),"^",23)    //重要标记
   
	S MedsRepLinkList=..getMedRepLink(medsrID)  
	
#;	S medsrDocDr=""  S medsrDoctorMes=""  S medsrDCProv=""  S medsrDOtherDesc="" //当事医生信息
#;	S medsrApoDr=""  S medsrApothecaryMes=""  S medsrACProv=""  S medsrAOtherDesc="" //当事药师信息
#;	S medsrNusDr=""  S medsrNurseMes=""  S medsrNCProv=""  S medsrNOtherDesc="" //当事护士信息
#;	
#;	S len=$L(MedsRepLink,"&&")
#;	F i=1:1:len D
#;	.S TmpStr=$p(MedsRepLink,"&&",i)
#;	.S medsrUseLinkCode=""
#;	.S medsrUseLinkDr=$p(TmpStr,"^",1)
#;	.I medsrUseLinkDr'=""  S medsrUseLinkCode=$p(^DHCADVMUSELK(medsrUseLinkDr),"^",1)
#;	.I medsrUseLinkCode="DocL" D //当事医生信息
#;	..S medsrDocDr=$p(TmpStr,"^",1) 
#;	..S medsrDoctorMes=$p(TmpStr,"^",2)
#;	..S medsrDCProv=$p(TmpStr,"^",3)
#;	..S medsrDOtherDesc=$p(TmpStr,"^",4)
#;	.E  I medsrUseLinkCode="ApoL" D //当事药师信息
#;	..S medsrApoDr=$p(TmpStr,"^",1)
#;	..S medsrApothecaryMes=$p(TmpStr,"^",2)
#;	..S medsrACProv=$p(TmpStr,"^",3)
#;	..S medsrAOtherDesc=$p(TmpStr,"^",4)
#;	.E  I medsrUseLinkCode="NurL" D //当事护士信息
#;	..S medsrNusDr=$p(TmpStr,"^",1)
#;	..S medsrNurseMes=$p(TmpStr,"^",2)
#;	..S medsrNCProv=$p(TmpStr,"^",3)
#;	..S medsrNOtherDesc=$p(TmpStr,"^",4)
#;	.
	S MedsRepResult=..getMedRepResult(medsrID)
	
	S medsrAuditID=$o(^DHCMEDREPADT(0,"Pointer",medsrReportType,medsrID,""),-1)
	I medsrAuditID=""  D
	.S medadrNextLoc=""
	.S medadrLocAdvice=""
	.S medadrReceive=""
	E  D
	.S medadrNextLoc=$p(^DHCMEDREPADT(medsrAuditID),"^",7)
	.S medadrLocAdvice=$p(^DHCMEDREPADT(medsrAuditID),"^",8)
	.S medadrReceive=$p(^DHCMEDREPADT(medsrAuditID),"^",9)
	S List=##class(web.DHCADVCOMMON).GetStatusDr(params)
	S MedsrInitStatDR=$p(List,"^",2)          //初始状态
	
	
	S medsrDataList=medsrID_"!"_medsrRepLocDesc_"!"_medsrCreateDate_"!"_medsrCreateTime_"!"_medsrOccDate_"!"_medsrOccTime_"!"_medsrOccBatNo
	S medsrDataList=medsrDataList_"!"_medsrPatNo_"!"_medsrPatID_"!"_medsrName_"!"_medsrSex_"!"_medsrAge
	S medsrDataList=medsrDataList_"!"_medsrDrugName_"!"_medsrDosage_"!"_medsrNurAction_"!"_medsrCreatorDesc_"!"_medsrCreatorCareProv
	S medsrDataList=medsrDataList_"!"_medsrErrNum_"!"_medsrCurStatusDR_"!"_medsrReportNo_"!"_medsrReportType_"!"_MedsrInitStatDR
	
	S medsrDataList=medsrDataList_"!"_MedsRepLinkList_"!"_MedsRepResult
	S medsrDataList=medsrDataList_"!"_medadrNextLoc_"!"_medadrLocAdvice_"!"_medadrReceive_"!"_medsrAdmNo_"!"_medsrOrdItm
	S medsrDataList=medsrDataList_"!"_medsrRepLocDr_"!"_medsrCreator_"!"_medsrDrugDr_"!"_medsrRepImpFlag
	
	;S medsrDataList=medsrDataList_"!"_medsrDoctorMes_"!"_medsrDCProv_"!"_medsrDOtherDesc_"!"_medsrApothecaryMes_"!"_medsrACProv
	;S medsrDataList=medsrDataList_"!"_medsrAOtherDesc_"!"_medsrNurseMes_"!"_medsrNCProv_"!"_medsrNOtherDesc
 Q medsrDataList
}

/// Description: 获取报告表项目环节
/// Creator:     CongYue
/// CreateDate:  2015-12-31
/// Input:  	 报告表id  
/// Output:  	 此报告所选的项目环节信息   
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).getMedRepLink("85")
ClassMethod getMedRepLink(medsrID) As %String
{
	N (medsrID)
	S tmpStr=""
	S ID=""
	S MULID=""
	S medsRepLinkDr=""
	F  S MULID=$o(^DHCADVMUSELK(MULID)) Q:MULID=""  D
	.Q:MULID=0
	.S medsRepLinkDr=""
	.S medsrJob="" //工作人（医生。。。）
	.S medsrCareProv="" //职称
	.S medsrOtherDesc="" //其他
	.F  S ID=$o(^DHCADVMEDRLK(0,"RepDr",medsrID,ID)) Q:ID=""  D
	..S medsRepLinkDr=$p(^DHCADVMEDRLK(ID),"^",2) //项目环节（表DHC_AdvMedUseLink）id
	..S MULCode=$p(^DHCADVMUSELK(MULID),"^",1)
	..I medsRepLinkDr=MULID  D
	...S medsrJob=$p(^DHCADVMEDRLK(ID),"^",3) //工作人（医生。。。）
	...S medsrCareProv=$p(^DHCADVMEDRLK(ID),"^",4) //职称
	...S medsrOtherDesc=$p(^DHCADVMEDRLK(ID),"^",5) //其他
	..Q:medsRepLinkDr=MULID
	.S ListData=MULID_"^"_medsrJob_"^"_medsrCareProv_"^"_medsrOtherDesc_"^"_MULCode 
	.I tmpStr="" S tmpStr=ListData
	.E  S tmpStr=tmpStr_"&"_ListData
	.
	Q tmpStr
}

/// Description: 获取报告表结果
/// Creator:     CongYue
/// CreateDate:  2015-12-31
/// Input:  	 报告id  
/// Output:  	 此报告的报告结果   
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).getMedRepResult("83")
ClassMethod getMedRepResult(medsrID) As %String
{
	N (medsrID)

	S ID=""  ;^DHCADVMEDRRET(0,"RepDr",{MEDSR_RepDr},{MEDSR_RowID})
	F  S ID=$o(^DHCADVMEDRRET(0,"RepDr",medsrID,ID)) Q:ID=""  D
	.S ReslutDr=$p(^DHCADVMEDRRET(ID),"^",2) //结果
	S tmpStr=ReslutDr
	Q tmpStr
}

/// Description: 获取报告信息(打印/导出)
/// Creator:     CongYue
/// CreateDate:  2016-01-04
/// Input:  	 报告表id  
/// Output:  	 报告表数据   
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).getMedsRepExportInfo("35")
ClassMethod getMedsRepExportInfo(medsrID As %String) As %String
{
	N (medsrID)
	
	Q:'$d(^DHCADVMEDSAR(medsrID)) ""
	
	S medsrRepLocDr=$p(^DHCADVMEDSAR(medsrID),"^",1)   //科室
	
	S medsrRepLocCode=$p(^DHCADVMEDSAR(medsrID),"^",1) //科室
	S medsrRepLocDr=""
	S medsrRepLocDesc=""
	I medsrRepLocCode'=""  d
	.S medsrRepLocDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(medsrRepLocCode),""))
	.S medsrRepLocDesc=$p(^CTLOC(medsrRepLocDr),"^",2)
	
	S medsrCreateDate=$p(^DHCADVMEDSAR(medsrID),"^",2)    //报告 日期
	S:medsrCreateDate'="" medsrCreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(medsrCreateDate)
	S medsrCreateTime=$p(^DHCADVMEDSAR(medsrID),"^",3)    //报告 时间
	S:medsrCreateTime'="" medsrCreateTime=$zt(medsrCreateTime,1)
	
	S medsrOccDate=$p(^DHCADVMEDSAR(medsrID),"^",4)    //报告 日期
	S:medsrOccDate'="" medsrOccDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(medsrOccDate)
	S medsrOccTime=$p(^DHCADVMEDSAR(medsrID),"^",5)    //报告 时间
	S:medsrOccTime'="" medsrOccTime=$zt(medsrOccTime,1)

	S medsrOccBatNo=$p(^DHCADVMEDSAR(medsrID),"^",6)      //班次
	S medsrOccBatNo=$S(medsrOccBatNo="白班":"白班",medsrOccBatNo="夜班":"夜班",medsrOccBatNo="交接班":"交接班",1:"")
	S medsrPatNo=$p(^DHCADVMEDSAR(medsrID),"^",7)     //病案号
	S medsrPatID=$p(^DHCADVMEDSAR(medsrID),"^",8)     //病人ID（登记号）
	S medsrName=$p(^DHCADVMEDSAR(medsrID),"^",9)   //姓名
	S medsrSex=$p(^DHCADVMEDSAR(medsrID),"^",10)     //性别
	S:medsrSex'="" medsrSex=$p(^CT("SEX",medsrSex),"^",2)
	S medsrAge=$p(^DHCADVMEDSAR(medsrID),"^",11)     //年龄
	
	S medsrDrugCode=$p(^DHCADVMEDSAR(medsrID),"^",12)     //药物名称
	S medsrDrugName=""
	S medsrDrugDr=""
	I medsrDrugCode'=""  d
	.S medsrDrugDr=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(medsrDrugCode),"")) //药物id
	.S medsrDrugName=$p(^INCI(medsrDrugDr,1),"^",2)
	S medsrDosage=$p(^DHCADVMEDSAR(medsrID),"^",13)     //应给剂量
	S medsrNurAction=$p(^DHCADVMEDSAR(medsrID),"^",14)     //即时行动
	S medsrCreatorCode=$p(^DHCADVMEDSAR(medsrID),"^",15)    //报告人工号
	S medsrCreator=""
	S medsrCreatorDesc=""
	I medsrCreatorCode'=""  d
	.S medsrCreator=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(medsrCreatorCode),""))
	.S medsrCreatorDesc=$p(^SSU("SSUSR",medsrCreator),"^",2)
	S medsrCreatorCareProv=$p(^DHCADVMEDSAR(medsrID),"^",16) //报告人职称
	S medsrErrNum=$p(^DHCADVMEDSAR(medsrID),"^",17)     //累计错误次数

	S medsrCurStatusDR=$p(^DHCADVMEDSAR(medsrID),"^",18)     //当前状态
	
	S medsrReportNo=$p(^DHCADVMEDSAR(medsrID),"^",19) //报告编码
	S medsrReportType=$p(^DHCADVMEDSAR(medsrID),"^",20)    //填报类型

	S MedsRepLinkList=..getMedRepLink(medsrID) //当事医生、药师、护士信息
	
	S MULID=""
	S MULtmpStr=""  //环节信息
	F  S MULID=$o(^DHCADVMUSELK(MULID)) Q:MULID=""  D
	.Q:MULID=0
	.S ListData=..getMULItm(medsrID,MULID) 
	.S ListData=($p(^DHCADVMUSELK(MULID),"^",1))_"&"_ListData
	.I MULtmpStr="" S MULtmpStr=ListData
	.E  S MULtmpStr=MULtmpStr_"!!"_ListData

	S MedsRepResult=..getMedRepResult(medsrID)
	S MedsRepResultDr=$p(MedsRepResult,",",1)
	S MedsRepResultDr=$S(MedsRepResultDr="1":"差错未到达患者",MedsRepResultDr="2":"差错到达患者，并且：",1:"")
	S MedsRepResDr=$p(MedsRepResult,",",2)
	S MedsRepResDr=$S(MedsRepResDr="10":"未对患者造成伤害",MedsRepResDr="11":"需要监测/干预以防止伤害",MedsRepResDr="12":"患者经受短暂的伤害",MedsRepResDr="13":"永久性伤害",MedsRepResDr="14":"需采取挽救生命的干预",MedsRepResDr="15":"患者死亡",1:"")

	
	S medsrDataList=medsrID_"&&"_medsrRepLocDesc_"&&"_medsrCreateDate_"&&"_medsrCreateTime_"&&"_medsrOccDate_"&&"_medsrOccTime_"&&"_medsrOccBatNo
	S medsrDataList=medsrDataList_"&&"_medsrPatNo_"&&"_medsrPatID_"&&"_medsrName_"&&"_medsrSex_"&&"_medsrAge
	S medsrDataList=medsrDataList_"&&"_medsrDrugName_"&&"_medsrDosage_"&&"_medsrNurAction_"&&"_medsrCreatorDesc_"&&"_medsrCreatorCareProv
	S medsrDataList=medsrDataList_"&&"_medsrErrNum_"&&"_medsrCurStatusDR_"&&"_medsrReportNo_"&&"_medsrReportType
	S medsrDataList=medsrDataList_"&&"_MedsRepLinkList_"&&"_MULtmpStr_"&&"_MedsRepResultDr_"&&"_MedsRepResDr
	
	
	
 Q medsrDataList
}

/// Description: 获取项目环节选项信息(打印/导出)
/// Creator:     CongYue
/// CreateDate:  2016-01-06
/// Input:  	 报告表id^项目环节id
/// Output:  	 此报告中此项目环节所选的信息  
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).getMULItm("82","1")
ClassMethod getMULItm(medsrID As %String, MULID As %String) As %String
{
	N (medsrID,MULID)
	S tempStr=""
	S tempList=""
	S h=0,count=0
	S CH=""
	F  S CH=$o(^DHCADVMUSELK(MULID,"MULI",CH)) Q:CH=""  D
	.S Code=$p(^DHCADVMUSELK(MULID,"MULI",CH),"^",1) //代码
	.S Desc=$p(^DHCADVMUSELK(MULID,"MULI",CH),"^",2) //描述
	.S Active=$p(^DHCADVMUSELK(MULID,"MULI",CH),"^",3) //是否可用
	.Q:Active="N"
	.S Correct=""
	.S Error=""
	.S OtherDesc=""
	.S flag=""
	.S parref=""
	.S ID=MULID_"||"_CH
	.F  S parref=$o(^DHCADVMEDRLK(0,"RepDr",medsrID,parref)) Q:parref=""  D 
	..S ChildSub=""
	..F  S ChildSub=$o(^DHCADVMEDRLK(parref,"MEDSRI",ChildSub)) Q:ChildSub=""  D 
	...S IDdr=parref_"||"_ChildSub
	...
	...S medsrLinkItem=$p(^DHCADVMEDRLK(parref,"MEDSRI",ChildSub),"^",1)
	...I medsrLinkItem=ID D
	....S flag="√"  
	....S Correct=$p(^DHCADVMEDRLK(parref,"MEDSRI",ChildSub),"^",2)
	....S Error=$p(^DHCADVMEDRLK(parref,"MEDSRI",ChildSub),"^",3)
	....S OtherDesc=$p(^DHCADVMEDRLK(parref,"MEDSRI",ChildSub),"^",4)
	...
	..
	.S h=h+1
	.S ListData=flag_"^"_MULID_"||"_CH_"^"_Code_"^"_Desc_"^"_Active_"^"_Correct _"^"_Error_"^"_OtherDesc
	.I tempStr="" S tempStr=ListData
	.E  S tempStr=tempStr_"&"_ListData	
	Q tempStr
}

/// Description: 获取病人医嘱信息
/// Creator:     CongYue
/// CreateDate:  2016-03-16
/// Input:  	 医嘱id
/// Output:  	 医嘱信息  
/// W ##class(web.DHCADVMEDSAREPORT).getRepOrdInfo("1||4")
ClassMethod getRepOrdInfo(params As %String)
{
	N ( params )
	;S data=""
	S medsrOrdItm=params
	S ord=$p(medsrOrdItm,"||",1)
	S chl=$p(medsrOrdItm,"||",2)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	
	S Num=0
    ;F  S chl=$o(^OEORD(ord,"I",chl)) q:(chl="")||(chl=0)  d
	;.S medsrOrdItm=ord_"||"_chl
	S priDr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    Q:priDr=0 
    S priorty=$p(^OECPR(priDr),"^",1) //医嘱优先级代码              
    ;Q:priorty["OM" //自备药
    S priorty=$p(^OECPR(priDr),"^",2) //医嘱优先级
    S StatDr=$p(^OEORD(ord,"I",chl,1),"^",13)
    S OeFlag=$p(^OEC("OSTAT",StatDr),"^",1) 
	//Q:(OeFlag'="V")&(OeFlag'="E")
	S FillerNo=$p(^OEORD(ord,"I",chl,9),"^",12) //滚医嘱来源信息 OEORI_FillerNo
    Q:(FillerNo'="")&(FillerNo'=medsrOrdItm_"!!"_medsrOrdItm)&(OeFlag'="D")  //长嘱非首日和截止日期的记录过滤
	S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	S ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    Q:(ordertype'="R")
	S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	Q:inci=""  //医嘱名称
	S inciflag=##class(web.DHCSTPHCMStkDrgUtil).JudgeArcimInci(inci) ;判断医嘱项和库存项是否存在一对多 1 是
	;S incidesc=$p(^INCI(inci,1),"^",2) //药品名称
	S incidesc=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2)  ; 取医嘱项名称，因为医嘱项和库存项存在一对多关系
	S dosage="",dosuomID="",doseuom="",freqdr="",freq="",instrudr="",instru="",durId=""
	I $D(^OEORD(ord,"I",chl,2))  D
	.S dosage=$p(^OEORD(ord,"I",chl,2),"^",1) //剂量
	.S dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	.S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) //剂量单位
	.S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) //OEORI_PHFreq_DR
    .S freq=$p($g(^PHCFR(freqdr)),"^",3) //频率
    .S instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    .S instru=$p($g(^PHCIN(instrudr)),"^",2) //用法
    .S durId=+$p(^OEORD(ord,"I",chl,2),"^",6)
	.S duration=$p($g(^PHCDU(durId)),"^",3) //用药疗程
    .S dspid=$o(^DHCOEDISQTY(0,"OEORI",medsrOrdItm,""))
    ;$p(^DHCOEDISQTY({DSP_RowId}),"^",1)//医嘱表id
    S qty=$p(^DHCOEDISQTY(dspid),"^",2) //药品数量
    S qtyuomdr=$p(^DHCOEDISQTY(dspid),"^",6) //药品数量单位指向
    S qtyuom=$p(^CT("UOM",qtyuomdr),"^",2)
    S qty=qty_qtyuom
	;S qty=$p(^OEORD(ord,"I",chl,1),"^",18) //药品数量
    S phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) q:phcdf=""
    S genenicdr=+$p($g(^PHCD(+phcdf,4)),"^",1)
    S genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) //通用名
    S formdr="",form=""
    S:$d(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1)) formdr=$p(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1),"^",1)
    S:formdr'="" form=$p(^PHCF(formdr),"^",2) //剂型
    S manf=""
    S manfdr=$p($g(^PHCD(+phcdf,2)),"^",4) //厂家
    S:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
    S:manf["-" manf=$p(manf,"-",2)
    S apprdocu=""
    S itminfo=$o(^DHCITMINFO(0,"INCI",inci,""))
    I itminfo'="" s apprdocu=$p(^DHCITMINFO(itminfo),"^",10) //批准文号
	S spec=""
	S add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	I add'=""  d
	.S spec=$p($G(^DHCITMINFO(add)),"^",27) //规格
    S:inciflag=1 spec=""
    S EndDate=$p(^OEORD(ord,"I",chl,3),"^",34)     //停止日期
	S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(EndDate)
	i FillerNo'="" d
	.S medsrOrdItm=$p(FillerNo,"!!",1)
	S StartDate=$p(^OEORD(ord,"I",$p(medsrOrdItm,"||",2),1),"^",9)  //开始日期
	S:StartDate'="" StartDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(StartDate)  
	S moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(medsrOrdItm) //主医嘱   data_"^"_
	S orddata=medsrOrdItm_"^"_phcdf_"^"_incidesc_"^"_dosage_doseuom_"^"_dosuomID_"^"_freqdr_"^"_freq_"^"_instrudr_"^"_instru_"^"_durId_"^"_duration_"^"_genenicdr_"^"_genenic_"^"_formdr_"^"_form_"^"_manfdr_"^"_manf_"^"_apprdocu_"^"_spec_"^"_StartDate_"^"_EndDate_"^"_OeFlag_"^"_priorty_"^"_qty
	
	q orddata
}

/// Description: 检查报告编码是否存在
/// Creator:     CongYue
/// CreateDate:  2016-05-04
/// Table:		 DHC_MedSafetyReport
/// Input:  	 params :报告编码
/// Output:		 0 不存在  1 存在
/// Others:		 w ##class(web.DHCADVMEDSAREPORT).SearchRepNoRepet("MEDSAR20151229001")
ClassMethod SearchRepNoRepet(RepNo As %String) As %String
{
	N (RepNo)
	S flag=0
	I $d(^DHCADVMEDSAR(0,"RepNo",RepNo)) D
	.S flag=1
	Q flag
}

}
