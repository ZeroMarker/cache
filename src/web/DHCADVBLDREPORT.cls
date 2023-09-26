Import sqluser

Class web.DHCADVBLDREPORT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:  输血不良事件中的重要标记
/// Creator:     yangyongtao
/// CreateDate:  2016-4-27
/// Table: 		 DHC_AdvBloodReport
/// Input:  	 报告表数据
/// Return： 	 数据id
/// Others:		 w ##class(web.DHCADVBLDREPORT).InsImpReport("144","N")
ClassMethod InsImpReport(bldrptID As %String, bldrptRepImpFlag As %String) As %String
{
    N (bldrptID,bldrptRepImpFlag)
    I bldrptRepImpFlag="N" D
    .S bldrptRepImpFlag="Y"
    E  S bldrptRepImpFlag="N"  ;2016-10-17
    &SQL(Update DHC_AdvBloodReport Set BLDRPT_RepImpFlag=:bldrptRepImpFlag Where BLDRPT_RowID=:bldrptID)	
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 保存  输血不良反应报告  
/// Creator:	 CongYue
/// CreateDate:  2016-01-20
/// Table: 		 DHC_AdvBloodReport
/// Input:  	 dataList: 输血不良反应报告的数据
/// Return： 	 输血不良反应报告的数据RowID
/// Others:		 w ##class(web.DHCADVBLDREPORT).InsBldrptReport("CRKMZ-传染科门诊^298^BLDRPT20160120001^2016-01-20^14:05:33^^^^0000000001^杜桑^2^24^1991-05-28^^
/// 				 0^0^0^A^阴性^阴性^A^阴性^100ml^37℃^92^72^40^0^^2016-01-20^14:06:43^298^2016-01-20^14:06:49^298^输血器厂家/批^50ml^*输血不良反应拟诊^1^1^*临床处置^2^^^2^^7")
ClassMethod InsBldrptReport(dataList As %String) As %String
{
	N (dataList)
	S bldrptRepLocDr=$p(dataList,"^",1) //科室
	S bldrptRepLocCode=""
	I bldrptRepLocDr'="" S bldrptRepLocCode=$p(^CTLOC(bldrptRepLocDr),"^",1)
	S bldrptRepNo=..GetAdrReportCurMaxNo("BLDRPT"_$zd(+$H,8),"3") ;$p(dataList,"^",2)    //报告编码
	S bldrptCreateDate=$p(dataList,"^",3)    //报告日期
	S:bldrptCreateDate'="" bldrptCreateDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(bldrptCreateDate)
	S bldrptCreateTime=$p(dataList,"^",4)    //报告时间
	S:bldrptCreateTime'="" bldrptCreateTime=$zth(bldrptCreateTime,1)
	S bldrptCreatorDr=$p(dataList,"^",5)    //报告人签名
	S bldrptCreator=""
	I bldrptCreatorDr'="" S bldrptCreator=$p(^SSU("SSUSR",bldrptCreatorDr),"^",1)
	S bldrptAdmNo=$p(dataList,"^",6) //病人就诊ID
	S bldrptPatNo=$p(dataList,"^",7) //病人病案号
	S bldrptPatID=$p(dataList,"^",8) //病人ID（登记号）
	S bldrptName=$p(dataList,"^",9) //患者姓名
	S bldrptSex=$p(dataList,"^",10) //性别	
	S bldrptAge=$p(dataList,"^",11) //年龄
	S bldrptBrithDate=$p(dataList,"^",12)     //出生日期
	S:bldrptBrithDate'="" bldrptBrithDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(bldrptBrithDate)
	S bldrptPatCardNo=$p(dataList,"^",13) //身份证号
	S bldrptGestation=$p(dataList,"^",14) //孕产史数
	S bldrptWardDr=$p(dataList,"^",15) //病区
	S bldrptWard=""
	S:bldrptWardDr'="" bldrptWard=$p(^PAWARD(+bldrptWardDr),"^",1)
	S bldrptBloodhis=$p(dataList,"^",16)    //继往输血史
	S bldrptADVBloodhis=$p(dataList,"^",17)     //输血反应史
	S bldrptBloodType=$p(dataList,"^",18)     //输血前血型检查结果
	S bldrptBloodAttr=$p(dataList,"^",19) //阴阳性
	S bldrptAntibody=$p(dataList,"^",20) //意外抗体筛查（阴阳性）
	S bldrptCurrBloodType=$p(dataList,"^",21) //本次输注的血液信息
	S bldrptCurrBloodAttr=$p(dataList,"^",22)     //阴阳性
	S bldrptDiscNum=$p(dataList,"^",23) //输注血量
	S bldrptTemp=$p(dataList,"^",24)    //体温
	S bldrptBloodPress=$p(dataList,"^",25)   //血压	
	S bldrptSphygmus=$p(dataList,"^",26)    //脉搏
	S bldrptBreathes=$p(dataList,"^",27)   //呼吸频次
	S bldrptDrugDesc=$p(dataList,"^",28)     //输血前预防用药
	S bldrptDrugRemark=$p(dataList,"^",29) //输血前预防用药其他
	
	S bldrptStartDate=$p(dataList,"^",30) //开始日期
	S:bldrptStartDate'="" bldrptStartDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(bldrptStartDate)
	S bldrptStartTime=$p(dataList,"^",31) //开始时间
	S:bldrptStartTime'="" bldrptStartTime=$zth(bldrptStartTime,1)
	S bldrptOperator=$p(dataList,"^",32) //操作者工号
	S bldrptOccDate=$p(dataList,"^",33) //发现日期
	S:bldrptOccDate'="" bldrptOccDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(bldrptOccDate)
	S bldrptOccTime=$p(dataList,"^",34) //发现时间
	S:bldrptOccTime'="" bldrptOccTime=$zth(bldrptOccTime,1)
	S bldrptDisUser=$p(dataList,"^",35) //发现者工号
	
	S bldrptManf=$p(dataList,"^",36)   //输血器厂家/批号
	S bldrptRemain=$p(dataList,"^",37)  //剩余血量(ml)
	S bldrptAnalyze=$p(dataList,"^",38)   //输血不良反应拟诊
	S bldrptSerLevel=$p(dataList,"^",39)   //严重程度
	S bldrptRelation=$p(dataList,"^",40)     //相关性
	S bldrptWardOp=$p(dataList,"^",41)   //临床处置
	S bldrptPatInfo=$p(dataList,"^",42) 	  //患者转归
	S bldrptDeathDate=$p(dataList,"^",43)    //死亡日期
	S:bldrptDeathDate'="" bldrptDeathDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(bldrptDeathDate)
	S bldrptDeathTime=$p(dataList,"^",44)    //死亡时间
	S:bldrptDeathTime'="" bldrptDeathTime=$zth(bldrptDeathTime,1)

	S bldrptBloodRelat=$p(dataList,"^",45)  //与输血相关性
	
	S bldrptCurStatusDR="" //$p(dataList,"^",46)  //当前状态
	S bldrptReportType=$p(dataList,"^",47)  //报告类型
	S bldrptRepImpFlag=$p(dataList,"^",48)  //重要标记
	
	&SQL(Insert Into DHC_AdvBloodReport(
		BLDRPT_RepLoc_Dr,BLDRPT_Creator,BLDRPT_RepNo,BLDRPT_CreateDate,BLDRPT_CreateTime,BLDRPT_Ward,
		BLDRPT_AdmNo,BLDRPT_PatNo,BLDRPT_PatID,BLDRPT_PatName,BLDRPT_PatSex,BLDRPT_PatAge,
		BLDRPT_BrithDate,BLDRPT_PatCardNo,BLDRPT_Gestation,BLDRPT_Bloodhis,BLDRPT_ADVBloodhis,BLDRPT_BloodType,
		BLDRPT_BloodAttr,BLDRPT_Antibody,BLDRPT_CurrBloodType,BLDRPT_CurrBloodAttr,BLDRPT_DiscNum,BLDRPT_Temp,
		BLDRPT_BloodPress,BLDRPT_Sphygmus,BLDRPT_Breathes,BLDRPT_DrugDesc,BLDRPT_DrugRemark,BLDRPT_StartDate,
		BLDRPT_StartTime,BLDRPT_Operator,BLDRPT_OccDate,BLDRPT_OccTime,BLDRPT_DisUser,BLDRPT_Manf,
		BLDRPT_Remain,BLDRPT_Analyze,BLDRPT_SerLevel,BLDRPT_Relation,BLDRPT_WardOp,BLDRPT_PatInfo,
		BLDRPT_DeathDate,BLDRPT_DeathTime,BLDRPT_BloodRelat,BLDRPT_CurStatus_DR,BLDRPT_ReportType,BLDRPT_RepImpFlag  	
	) Values(
		:bldrptRepLocCode,:bldrptCreator,:bldrptRepNo,:bldrptCreateDate,:bldrptCreateTime,:bldrptWard,
		:bldrptAdmNo,:bldrptPatNo,:bldrptPatID,:bldrptName,:bldrptSex,:bldrptAge,
		:bldrptBrithDate,:bldrptPatCardNo,:bldrptGestation,:bldrptBloodhis,:bldrptADVBloodhis,:bldrptBloodType,
		:bldrptBloodAttr,:bldrptAntibody,:bldrptCurrBloodType,:bldrptCurrBloodAttr,:bldrptDiscNum,:bldrptTemp,
		:bldrptBloodPress,:bldrptSphygmus,:bldrptBreathes,:bldrptDrugDesc,:bldrptDrugRemark,:bldrptStartDate,
		:bldrptStartTime,:bldrptOperator,:bldrptOccDate,:bldrptOccTime,:bldrptDisUser,:bldrptManf,
		:bldrptRemain,:bldrptAnalyze,:bldrptSerLevel,:bldrptRelation,:bldrptWardOp,:bldrptPatInfo,
		:bldrptDeathDate,:bldrptDeathTime,:bldrptBloodRelat,:bldrptCurStatusDR,:bldrptReportType,:bldrptRepImpFlag
	))
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 更新  输血不良反应报告  
/// Creator:	 CongYue
/// CreateDate:	 2016-01-20
/// Table:		 DHC_AdvBloodReport
/// Input:		 bldrptID: 输血不良反应报告的数据id, dataList: 输血不良反应报告的数据
/// Return:		 输血不良反应报告的数据RowID
/// Others:		 w ##class(web.DHCADVBLDREPORT).UpdBldrptReport()
ClassMethod UpdBldrptReport(bldrptID As %String, dataList As %String) As %String
{
	N (bldrptID,dataList)
	S bldrptRepLocDr=$p(dataList,"^",1) //科室
	S bldrptRepLocCode=""
	I bldrptRepLocDr'="" S bldrptRepLocCode=$p(^CTLOC(bldrptRepLocDr),"^",1)
	S bldrptRepNo=$p(^DHCBLDADVRPT(bldrptID),"^",3)    //报告编码
	S bldrptCreateDate=$p(dataList,"^",3)    //报告日期
	S:bldrptCreateDate'="" bldrptCreateDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(bldrptCreateDate)
	S bldrptCreateTime=$p(dataList,"^",4)    //报告时间
	S:bldrptCreateTime'="" bldrptCreateTime=$zth(bldrptCreateTime,1)
	S bldrptCreatorDr=$p(dataList,"^",5)    //报告人签名
	S bldrptCreator=""
	I bldrptCreatorDr'="" S bldrptCreator=$p(^SSU("SSUSR",bldrptCreatorDr),"^",1)
	S bldrptAdmNo=$p(dataList,"^",6) //病人就诊ID
	S bldrptPatNo=$p(dataList,"^",7) //病人病案号
	S bldrptPatID=$p(dataList,"^",8) //病人ID（登记号）
	S bldrptName=$p(dataList,"^",9) //患者姓名
	S bldrptSex=$p(dataList,"^",10) //性别	
	S bldrptAge=$p(dataList,"^",11) //年龄
	S bldrptBrithDate=$p(dataList,"^",12)     //出生日期
	S:bldrptBrithDate'="" bldrptBrithDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(bldrptBrithDate)
	S bldrptPatCardNo=$p(dataList,"^",13) //身份证号
	S bldrptGestation=$p(dataList,"^",14) //孕产史数
	S bldrptWardDr=$p(dataList,"^",15) //病区
	S bldrptWard=""
	S:bldrptWardDr'="" bldrptWard=$p(^PAWARD(+bldrptWardDr),"^",1)
	S bldrptBloodhis=$p(dataList,"^",16)    //继往输血史
	S bldrptADVBloodhis=$p(dataList,"^",17)     //输血反应史
	S bldrptBloodType=$p(dataList,"^",18)     //输血前血型检查结果
	S bldrptBloodAttr=$p(dataList,"^",19) //阴阳性
	S bldrptAntibody=$p(dataList,"^",20) //意外抗体筛查（阴阳性）
	S bldrptCurrBloodType=$p(dataList,"^",21) //本次输注的血液信息
	S bldrptCurrBloodAttr=$p(dataList,"^",22)     //阴阳性
	S bldrptDiscNum=$p(dataList,"^",23) //输注血量
	S bldrptTemp=$p(dataList,"^",24)    //体温
	S bldrptBloodPress=$p(dataList,"^",25)   //血压	
	S bldrptSphygmus=$p(dataList,"^",26)    //脉搏
	S bldrptBreathes=$p(dataList,"^",27)   //呼吸频次
	S bldrptDrugDesc=$p(dataList,"^",28)     //输血前预防用药
	S bldrptDrugRemark=$p(dataList,"^",29) //输血前预防用药其他
	
	S bldrptStartDate=$p(dataList,"^",30) //开始日期
	S:bldrptStartDate'="" bldrptStartDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(bldrptStartDate)
	S bldrptStartTime=$p(dataList,"^",31) //开始时间
	S:bldrptStartTime'="" bldrptStartTime=$zth(bldrptStartTime,1)
	S bldrptOperator=$p(dataList,"^",32) //操作者工号
	
	S bldrptOccDate=$p(dataList,"^",33) //发现日期
	S:bldrptOccDate'="" bldrptOccDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(bldrptOccDate)
	S bldrptOccTime=$p(dataList,"^",34) //发现时间
	S:bldrptOccTime'="" bldrptOccTime=$zth(bldrptOccTime,1)
	S bldrptDisUser=$p(dataList,"^",35) //发现者工号
	
	S bldrptManf=$p(dataList,"^",36)   //输血器厂家/批号
	S bldrptRemain=$p(dataList,"^",37)  //剩余血量(ml)
	S bldrptAnalyze=$p(dataList,"^",38)   //输血不良反应拟诊
	S bldrptSerLevel=$p(dataList,"^",39)   //严重程度
	S bldrptRelation=$p(dataList,"^",40)     //相关性
	S bldrptWardOp=$p(dataList,"^",41)   //临床处置
	S bldrptPatInfo=$p(dataList,"^",42) 	  //患者转归
	S bldrptDeathDate=$p(dataList,"^",43)    //死亡日期
	S:bldrptDeathDate'="" bldrptDeathDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(bldrptDeathDate)
	S bldrptDeathTime=$p(dataList,"^",44)    //死亡时间
	S:bldrptDeathTime'="" bldrptDeathTime=$zth(bldrptDeathTime,1)

	S bldrptBloodRelat=$p(dataList,"^",45)  //与输血相关性
	
	S bldrptCurStatusDR=$p(dataList,"^",46)  //当前状态
	S bldrptReportType=$p(dataList,"^",47)  //报告类型
	S bldrptRepImpFlag=$p(dataList,"^",48)  //重要标记
	&SQL(Update DHC_AdvBloodReport Set 
		BLDRPT_RepLoc_Dr=:bldrptRepLocCode,BLDRPT_Creator=:bldrptCreator,BLDRPT_RepNo=:bldrptRepNo,BLDRPT_CreateDate=:bldrptCreateDate,BLDRPT_CreateTime=:bldrptCreateTime,BLDRPT_Ward=:bldrptWard,
		BLDRPT_AdmNo=:bldrptAdmNo,BLDRPT_PatNo=:bldrptPatNo,BLDRPT_PatID=:bldrptPatID,BLDRPT_PatName=:bldrptName,BLDRPT_PatSex=:bldrptSex,BLDRPT_PatAge=:bldrptAge,
		BLDRPT_BrithDate=:bldrptBrithDate,BLDRPT_PatCardNo=:bldrptPatCardNo,BLDRPT_Gestation=:bldrptGestation,BLDRPT_Bloodhis=:bldrptBloodhis,BLDRPT_ADVBloodhis=:bldrptADVBloodhis,BLDRPT_BloodType=:bldrptBloodType,
		BLDRPT_BloodAttr=:bldrptBloodAttr,BLDRPT_Antibody=:bldrptAntibody,BLDRPT_CurrBloodType=:bldrptCurrBloodType,BLDRPT_CurrBloodAttr=:bldrptCurrBloodAttr,BLDRPT_DiscNum=:bldrptDiscNum,BLDRPT_Temp=:bldrptTemp,
		BLDRPT_BloodPress=:bldrptBloodPress,BLDRPT_Sphygmus=:bldrptSphygmus,BLDRPT_Breathes=:bldrptBreathes,BLDRPT_DrugDesc=:bldrptDrugDesc,BLDRPT_DrugRemark=:bldrptDrugRemark,BLDRPT_StartDate=:bldrptStartDate,
		BLDRPT_StartTime=:bldrptStartTime,BLDRPT_Operator=:bldrptOperator,BLDRPT_OccDate=:bldrptOccDate,BLDRPT_OccTime=:bldrptOccTime,BLDRPT_DisUser=:bldrptDisUser,BLDRPT_Manf=:bldrptManf,
		BLDRPT_Remain=:bldrptRemain,BLDRPT_Analyze=:bldrptAnalyze,BLDRPT_SerLevel=:bldrptSerLevel,BLDRPT_Relation=:bldrptRelation,BLDRPT_WardOp=:bldrptWardOp,BLDRPT_PatInfo=:bldrptPatInfo,
		BLDRPT_DeathDate=:bldrptDeathDate,BLDRPT_DeathTime=:bldrptDeathTime,BLDRPT_BloodRelat=:bldrptBloodRelat,BLDRPT_CurStatus_DR=:bldrptCurStatusDR,BLDRPT_ReportType=:bldrptReportType,BLDRPT_RepImpFlag=:bldrptRepImpFlag Where BLDRPT_RowID=:bldrptID)
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 保存 输血报告中输血患者体征  
/// Creator:	 CongYue
/// CreateDate:	 2016-01-22
/// Table:		 DHC_AdvBldBasInfo
/// Input:		 bldrptID:报告id , DataList: 以字符"^"分割,格式为:是否选择^体征id^体征描述^体征类型
/// Return:		 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVBLDREPORT).InsMedsReportLink("15","1")
ClassMethod InsBldBasicInfo(bldrptID As %String, DataList As %String) As %String
{
	N (bldrptID,DataList)
	S BciBRepDr=bldrptID
	S BciBasDr=$p(DataList,"^",1)
	
 	&SQL(INSERT INTO DHC_AdvBldBasInfo(BCI_BRep_Dr,BCI_Bas_Dr) 
 	VALUES(:BciBRepDr,:BciBasDr))
 	Q SQLCODE
}

/// Description: 保存 输血报告中输血类别  
/// Creator:	 CongYue
/// CreateDate:	 2016-04-08
/// Table:		 DHC_AdvBldRepList
/// Input:		 bldrptID:报告id , DataList: 以字符"^"分割,格式为:输血类型^输血编号1,输血编号2,输血编号3,输血编号4
/// Return:		 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVBLDREPORT).InsBldTypeInfo("15","1")
ClassMethod InsBldTypeInfo(bldrptID As %String, DataList As %String) As %String
{
	N (bldrptID,DataList)
	S BldRepDr=bldrptID
	S BldBldType=$p(DataList,"^",1)
	
 	&SQL(INSERT INTO DHC_AdvBldRepList(BLD_Rep_Dr,BLD_BldType) 
 	VALUES(:BldRepDr,:BldBldType))
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 保存 输血报告中输血类别  
/// Creator:	 CongYue
/// CreateDate:	 2016-04-08
/// Table:		 DHC_AdvBldRepListNo
/// Input:		 bldrptID:报告id , DataList: 以字符"^"分割,格式为:输血类型^输血编号1,输血编号2,输血编号3,输血编号4
/// Return:		 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVBLDREPORT)InsBldNoInfo("15","1")
ClassMethod InsBldNoInfo(bldID As %String, DataList As %String) As %String
{
	N (bldID,DataList)
	S BldParRef=bldID
	S BldChlidSub=$o(^DHCADVBLDRLIN(BldParRef,"BLDI",""),-1)+1
	S BldNo=$p(DataList,"^",1)
 	&SQL(INSERT INTO DHC_AdvBldRepListNo(BLD_RepList_ParRef,BLD_ChlidSub,BLD_No) 
 	VALUES(:BldParRef,:BldChlidSub,:BldNo))
	Q SQLCODE
}

/// Description: 删除输血不良反应相关信息表
/// Creator:	 CongYue
/// CreateDate:	 2016-01-22
/// Input:		 bldrptID:报告id
/// Return:		 删除成功 0，删除失败 非0
/// Others:		 w ##class(web.DHCADVBLDREPORT).DelBldRelatInfo("24")
ClassMethod DelBldRelatInfo(bldrptID As %String) As %String
{
	N (bldrptID)
	//输血体征
	I $o(^DHCADVBLDBACI(0,"BRepDr",bldrptID,""))'=""  D
	.&SQL(DELETE DHC_AdvBldBasInfo WHERE  BCI_BRep_Dr=:bldrptID)
	Q:+$g(SQLCODE)'=0 SQLCODE
	//输血类别
	I $o(^DHCADVBLDRLI(0,"RepDr",bldrptID,""))'=""  D
	.&SQL(DELETE DHC_AdvBldRepList WHERE  BLD_Rep_Dr=:bldrptID)
	Q:+$g(SQLCODE)'=0 SQLCODE
		
	Q 0
}

/// Description: 保存  输血不良反应报告
/// Creator:	 CongYue
/// CreateDate:  2016-01-20
/// Table: 		 DHC_AdvBloodReport
/// Input: 		 bldrptID:报告表的id,bldrptDataList:报告表的数据,bldrptRepAuditList:以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return： 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVBLDREPORT).saveBldrptReport("34","63^BLDRPT20160418001^2016-04-18^08:50:40^600^^000091^0000000003^mic2^2^25^1990-10-10^^0^产科护理单元^1^0^^^^^^^^^^^^^^^^^^^^^^^^^2^^^2^^7$c(2)$c(2)红细胞悬液^1,2,3,4$c(2)$c(1)$c(2)15$c(1)17$c(1)","")
ClassMethod saveBldrptReport(bldrptID As %String, bldrptDataList As %String, bldrptRepAuditList As %String, flag As %String) As %String
{
	N (bldrptID,bldrptDataList,bldrptRepAuditList,flag)
	S ret=0
	I bldrptID="" D
	.S ret=..Insert(bldrptDataList,bldrptRepAuditList,flag)
	E  D
	.S ret=..Update(bldrptID,bldrptDataList,bldrptRepAuditList,flag)
	Q ret
}

/// Description: 保存输血不良反应报告
/// Creator:	 CongYue
/// CreateDate:  2016-01-20
/// Input: 		 bldrptDataList:报告表的数据,bldrptRepAuditList:以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return： 	 "0^"_bldrptID:保存成功标志^报告表id
ClassMethod Insert(bldrptDataList As %String, bldrptRepAuditList As %String, flag As %String) As %String
{
	N (bldrptDataList,bldrptRepAuditList,flag)
	S Err=0
	S DataList=$p(bldrptDataList,"$c(2)",1)
	S AdmDataList=$p(bldrptDataList,"$c(2)",2)
	S BldTypedatalist=$p(bldrptDataList,"$c(2)",3)
	S BldAdatalist=$p(bldrptDataList,"$c(2)",4)
	S BldBdatalist=$p(bldrptDataList,"$c(2)",5)
	TS
	S bldrptID=..InsBldrptReport(DataList)
	I bldrptID<0 tro
	Q:bldrptID<0 bldrptID
	
	//输血类别 输血编号
	I BldTypedatalist'="" D
	.S len=$L(BldTypedatalist,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(BldTypedatalist,"$c(1)",i)
	..S BldTypelist=$p(TmpStr,"^",1)
	..I BldTypelist'="" D
	...S bldID=..InsBldTypeInfo(bldrptID,BldTypelist)
	..S BldNolist=$p(TmpStr,"^",2)
	..S len=$L(BldNolist,",")
	..F j=1:1:len D
	...S TmpStrs=$p(BldNolist,",",j)
	...I TmpStrs'="" D
	....S Err=..InsBldNoInfo(bldID,TmpStrs)
	...
	..
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-11"
	
	//输血患者体征
	I BldAdatalist'="" D
	.S len=$L(BldAdatalist,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(BldAdatalist,"$c(1)",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsBldBasicInfo(bldrptID,TmpStr)
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-12"
	
	//输血临床症状
	I BldBdatalist'="" D
	.S len=$L(BldBdatalist,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(BldBdatalist,"$c(1)",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsBldBasicInfo(bldrptID,TmpStr)
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-13"
	
	//更新状态
	S adtList=bldrptID_"^"_$p(bldrptRepAuditList,"^",8)_"^"_$p(bldrptRepAuditList,"^",2)_"^"_$p(bldrptRepAuditList,"^",3)_"^"_$p(bldrptRepAuditList,"^",4)
    S nextStatuDr=""
	I flag="1" D
	.S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(adtList)
	I (flag="1")&(+nextStatuDr'>0) tro
	Q:(flag="1")&(+nextStatuDr'>0) nextStatuDr
	
	I flag="1" D
	.&sql(update DHC_AdvBloodReport set BLDRPT_CurStatus_DR=:nextStatuDr where BLDRPT_RowID=:bldrptID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 S Err="-16"
	
	Q:Err'=0 "-16"
	
	S bldrptRepAuditList=nextStatuDr_"^"_$p(bldrptRepAuditList,"^",2,8)
	
	
	//不良反应报告审批流程[默认插入初始状态]
	I bldrptRepAuditList'="" D
	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(bldrptID,bldrptRepAuditList)
	I Err'=0 tro
	Q:Err'=0 "-18"
	
	
	TC
	Q "0^"_bldrptID
}

/// Description: 保存输血不良反应报告
/// Creator:	 CongYue
/// CreateDate:  2016-01-20
/// Input: 		 bldrptID:报告表的id,bldrptDataList:报告表的数据,bldrptRepAuditList:以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return： 	 "0^"_bldrptID:保存成功标志^报告表id
ClassMethod Update(bldrptID As %String, bldrptDataList As %String, bldrptRepAuditList As %String, flag As %String) As %String
{
	N (bldrptID,bldrptDataList,bldrptRepAuditList,flag)
	S Err=0
	S DataList=$p(bldrptDataList,"$c(2)",1)
	S AdmDataList=$p(bldrptDataList,"$c(2)",2)
	S BldTypedatalist=$p(bldrptDataList,"$c(2)",3)
	S BldAdatalist=$p(bldrptDataList,"$c(2)",4)
	S BldBdatalist=$p(bldrptDataList,"$c(2)",5)
	S RepStatus=$p(^DHCBLDADVRPT(bldrptID),"^",46)  //当前状态
	TS
	
	S bldrptID=..UpdBldrptReport(bldrptID,DataList)
	I bldrptID<0 tro
	Q:bldrptID<0 bldrptID
	
	//删除相关子表
	S Err=..DelBldRelatInfo(bldrptID)
	I Err'=0 tro
	Q:Err'=0 "-10"
	
	//输血类别 输血编号
	I BldTypedatalist'="" D
	.S len=$L(BldTypedatalist,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(BldTypedatalist,"$c(1)",i)
	..S BldTypelist=$p(TmpStr,"^",1)
	..I BldTypelist'="" D
	...S bldID=..InsBldTypeInfo(bldrptID,BldTypelist)
	..S BldNolist=$p(TmpStr,"^",2)
	..S lens=$L(BldNolist,",")
	..F j=1:1:lens D
	...S TmpStrs=$p(BldNolist,",",j)
	...I TmpStrs'="" D
	....S Err=..InsBldNoInfo(bldID,TmpStrs)
	...
	..
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-11"
	
	//输血患者体征
	I BldAdatalist'="" D
	.S ^yhd("JJHG")=BldAdatalist
	.S len=$L(BldAdatalist,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(BldAdatalist,"$c(1)",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsBldBasicInfo(bldrptID,TmpStr)
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-12"
	
	//输血临床症状
	I BldBdatalist'="" D
	.S len=$L(BldBdatalist,"$c(1)")
	.F i=1:1:len D
	..S TmpStr=$p(BldBdatalist,"$c(1)",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsBldBasicInfo(bldrptID,TmpStr)
	..
	.
	I Err'=0 tro
	Q:Err'=0 "-13"
	
	//更新状态
	S adtList=bldrptID_"^"_$p(bldrptRepAuditList,"^",8)_"^"_$p(bldrptRepAuditList,"^",2)_"^"_$p(bldrptRepAuditList,"^",3)_"^"_$p(bldrptRepAuditList,"^",4)
    S nextStatuDr=""
	I flag="1" D
	.S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(adtList)
	
	I (flag="1")&(+nextStatuDr'>0) tro
	Q:(flag="1")&(+nextStatuDr'>0) nextStatuDr
	
	I flag="1" D
	.&sql(update DHC_AdvBloodReport set BLDRPT_CurStatus_DR=:nextStatuDr where BLDRPT_RowID=:bldrptID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 s Err="-16"
	
	Q:Err'=0 "-16"
	
	S:flag="1" bldrptRepAuditList=nextStatuDr_"^"_$p(bldrptRepAuditList,"^",2,8)
	S:flag="0" bldrptRepAuditList=RepStatus_"^"_$p(bldrptRepAuditList,"^",2,8)

	//不良反应报告审批流程[默认插入初始状态]
	I bldrptRepAuditList'="" D
	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(bldrptID,bldrptRepAuditList)
	I Err'=0 tro
	Q:Err'=0 "-17"

	TC
	
	Q "0^"_bldrptID
}

/// Description: 删除  输血不良反应报告  
/// Creator:	 CongYue
/// CreateDate:	 2016-01-20
/// Table:		 DHC_AdvBloodReport
/// Input:		 报告表的id 
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVBLDREPORT).DelBldrptReport("24")
ClassMethod DelBldrptReport(params As %String) As %String
{
	N (params)
	S bldrptID=$p(params,"^",1)
	S UserID=$p(params,"^",2)
	S repUser=$p(^DHCBLDADVRPT(bldrptID),"^",2)    //填报人
	S repCurStatDR=$p(^DHCBLDADVRPT(bldrptID),"^",46)  //当前状态
	S repUserID=""
	I repUser'=""  D
	.S repUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(repUser),""))
	Q:UserID'=repUserID -1  //不是本人，不能删除
	Q:repCurStatDR'="" -2  //已提交，不能删除
	
	TS
	&SQL(DELETE DHC_AdvBloodReport WHERE BLDRPT_RowID=:bldrptID)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 SQLCODE

	//删除相关表
	S Err=..DelBldRelatInfo(bldrptID)
	I Err'=0 tro
	Q:Err'=0 "-10"
	TC
	Q 0
}

/// Description: 保存[输血患者体征]
/// Creator:	 CongYue
/// CreateDate:	 2015-12-15
/// Table:		 DHC_AdvBldBasic
/// Input:		 DataList: 输血患者体征数据信息, 以字符"^"分割,格式为：代码^描述^类型&&代码^描述^类型,
/// Return:		 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVBLDREPORT).SaveBldBasic("^器械填报^器械填报")
ClassMethod SaveBldBasic(DataList As %String) As %String
{
	N (DataList)
	S Err=0
	S len=$L(DataList,"&&")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"&&",i)
	.S Err=..CheckRepeatDeal(TmpStr)   /// 重复性判断
	.Q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdBldBasic(TmpStr)
	.E  D
	..S Err=..InsBldBasic(TmpStr)
	Q Err
}

/// Description: 保存[检查代码是否重复]
/// Creator:     CongYue
/// CreateDate:  2016-05-31
/// Table:		 DHC_AdvBldBasic
/// Others:		 w ##class(web.DHCADVBLDREPORT).CheckRepeatDeal("2^DocL^医生环节")
ClassMethod CheckRepeatDeal(TmpStr As %String) As %String
{
	N (TmpStr)
	s BldbID=$p(TmpStr,"^",1)   		///ID
	s BldbCode=$p(TmpStr,"^",2)   	///代码
	/// 新记录
	q:(BldbID="")&($d(^DHCADVBLDBASIC(0,"Code",$$ALPHAUP^SSUTIL4(BldbCode)))) "-1"
	q:BldbID="" 0
	
	/// 修改记录
	s Code=$p($g(^DHCADVBLDBASIC(BldbID)),"^",1)    //代码
	q:(BldbCode'=Code)&($d(^DHCADVBLDBASIC(0,"Code",$$ALPHAUP^SSUTIL4(BldbCode)))) "-2"
	q 0
}

/// Description: 更新[输血患者体征]
/// Creator:	 CongYue
/// CreateDate:	 2015-12-15
/// Table:		 DHC_AdvBldBasic
/// Input:		 DataList: 输血患者体征数据信息, 以字符"^"分割,格式为：id^代码^描述^类型,
/// Return:		 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVBLDREPORT).UpdBldBasic("")
ClassMethod UpdBldBasic(DataList As %String) As %String
{
	N (DataList)
	S BldbID=$p(DataList,"^",1)
	S BldbCode=$p(DataList,"^",2)
	S BldbDesc=$p(DataList,"^",3)
	S BldbType=$p(DataList,"^",4)
	&SQL(Update DHC_AdvBldBasic Set BLDB_Code=:BldbCode, BLDB_Desc=:BldbDesc, BLDB_Type=:BldbType WHERE BLDB_RowID=:BldbID)
 	Q SQLCODE
}

/// Description: 增加[输血患者体征]
/// Creator:	 CongYue
/// CreateDate:	 2015-12-15
/// Table:		 DHC_AdvBldBasic
/// Input:		 DataList: 输血患者体征数据信息, 以字符"^"分割,格式为：id^代码^描述^类型,
/// Return:		 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVBLDREPORT).InsBldBasic("")
ClassMethod InsBldBasic(DataList As %String) As %String
{
	N (DataList)
	S BldbCode=$p(DataList,"^",2)
	S BldbDesc=$p(DataList,"^",3)
	S BldbType=$p(DataList,"^",4)
 	&SQL(INSERT INTO DHC_AdvBldBasic(BLDB_Code,BLDB_Desc,BLDB_Type) VALUES(:BldbCode,:BldbDesc,:BldbType))
 	Q SQLCODE
}

/// Description: 删除 [输血患者体征]
/// Creator:	 CongYue
/// CreateDate:	 2015-12-15
/// Table:		 DHC_AdvBldBasic
/// Input:		 MulID:表的id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVBLDREPORT).DelBldBasic("3")
ClassMethod DelBldBasic(BldbID As %String) As %String
{
	N (BldbID)
	Q:$d(^DHCADVBLDBACI(0,"BasDr",BldbID)) -1  ;判断此输血患者体征是否存在报告使用记录
	&SQL(Delete From DHC_AdvBldBasic Where BLDB_RowID=:BldbID)
	Q SQLCODE
}

/// Description: 查询[输血患者体征]
/// Creator:	 CongYue
/// CreateDate:	 2015-12-15
/// Table:		 DHC_AdvBldBasic
/// Input:		 params：订单信息，以字符"^"分割,格式为:代码^描述,
/// Output:		 DHC_AdvBldBasic表中的数据信息   
/// Others:		 w ##class(web.DHCADVBLDREPORT).QueryBldBasic("12","1","")
ClassMethod QueryBldBasic(rows As %String, page As %String, params As %String) As %String
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
	F  S ID=$o(^DHCADVBLDBASIC(ID)) Q:ID=""  D
	.S Code=$p(^DHCADVBLDBASIC(ID),"^",1) //代码
	.S Desc=$p(^DHCADVBLDBASIC(ID),"^",2) //描述
	.S TypeID=$p(^DHCADVBLDBASIC(ID),"^",3) //类型
	.S TypeName=$S(TypeID="A":"患者体征",TypeID="B":"临床症状",1:"")
	.Q:(code'="")&(Code'[code)
	.Q:(desc'="")&(Desc'[desc)
	.S h=h+1
	.S TempStr=ID_"^"_Code_"^"_Desc_"^"_TypeID_"^"_TypeName
	.S ^TMP("DHCADV","web.DHCADVBLDREPORT","QueryBldBasic",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc^TypeID^Type"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVBLDREPORT","QueryBldBasic",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVBLDREPORT","QueryBldBasic",pid,index))
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

/// Description: 获取页面默认信息（日期，编码）
/// Creator:	 CongYue
/// CreateDate:	 2016-01-18
/// Input:  	 params:  以字符"^"分割,格式为:人员id^科室id^安全组id^报告类型代码
/// Return:  	 页面默认信息: 报告日期^报告初始状态^报告类型^科室^报告编码^报告人职称^病区  
/// Others:		 w ##class(web.DHCADVBLDREPORT).getBloodInfo("600^63^126^blood")
ClassMethod getBloodInfo(params As %String) As %String
{
	N (params)
	S repdate=$zdt($H,3)
	S List=##class(web.DHCADVCOMMON).GetStatusDr(params)
	Q:List="" -1
	S bldrptReportType=$p(List,"^",1)  //报告类型
	S BldrptInitStatDR=$p(List,"^",2)  //审核状态
	
	S UserID=$p(params,"^",1)  //报告人ID
	S UserName=""
	I UserID'="" D
	.S UserName=$p(^SSU("SSUSR",UserID),"^",2)
	.S CreatorCareProvDr=$p(^SSU("SSUSR",UserID),"^",9)
	.I CreatorCareProvDr'=""  D
	..S CtpcpCarPrvTpDR=$p(^CTPCP(CreatorCareProvDr,1),"^",4)
	..I CtpcpCarPrvTpDR'="" D
	...S CreatorCareProv=$p(^CT("CPT",CtpcpCarPrvTpDR),"^",1) // 报告人职称
	..
	.E  D
	..S CreatorCareProv=""
	S LocID=$p(params,"^",2)  //科室ID
	I LocID'="" D
	.S LocDesc=$p(^CTLOC(LocID),"^",2)
	
	S AdmWardID=$o(^PAWARD(0,"WARD_LocationDR",LocID,""))
	S AdmWardDesc=""
	S:AdmWardID'="" AdmWardDesc=$p(^PAWARD(AdmWardID),"^",2) // 病区

	S Prefix="BLDRPT"_$zd(+$H,8)  //报告编码规则 "BLDRPT"+年月日+顺序号
	S bldrptRepNo=..GetAdrReportCurMaxNo(Prefix,"3")	

	Q repdate_"^"_BldrptInitStatDR_"^"_bldrptReportType_"^"_bldrptRepNo_"^"_UserID_"^"_UserName_"^"_LocID_"^"_$g(LocDesc)_"^"_AdmWardDesc_"^"_CreatorCareProv
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
	&sql(select max(BLDRPT_RepNo) into matacode from DHC_AdvBloodReport Where BLDRPT_RepNo %STARTSWITH %ALPHAUP :Prefix)
	Q matacode
}

/// Description: 报告页面加载输血患者体征
/// Creator:	 CongYue
/// CreateDate:  2016-01-22	(01-26日改)
/// Table: 		 DHC_AdvBldBasic
/// Input:  	 params: 患者体征类型^输血报告id,
/// Output:  	 DHC_AdvBldBasic 表中的数据信息   
/// Others:		 w ##class(web.DHCADVBLDREPORT).QueryBldBasRpt("12","1","A^3")
ClassMethod QueryBldBasRpt(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	
	S typedr=$p(params,"^",1)
	S bldrptID=$p(params,"^",2)

	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
	S h=0,count=0
	S ID="0"
	I bldrptID="" D
	.S ID="0"
	.F  S ID=$o(^DHCADVBLDBASIC(ID)) Q:ID=""  D
	..S Code=$p(^DHCADVBLDBASIC(ID),"^",1) //代码
	..S Desc=$p(^DHCADVBLDBASIC(ID),"^",2) //描述
	..S Typedr=$p(^DHCADVBLDBASIC(ID),"^",3) //类型
	..S Type=$S(Typedr="A":"患者体征",Typedr="B":"临床症状",1:"")
	..S flag="N"
	..Q:(typedr'="")&(Typedr'[typedr)
	..S h=h+1
	..S TempStr=ID_"^"_Code_"^"_Desc_"^"_Type_"^"_flag
	..S ^TMP("DHCADV","web.DHCADVBLDREPORT","QueryBldBasRpt",pid,h)=TempStr
	.
	E  D
	.S ID="0"
	.F  S ID=$o(^DHCADVBLDBASIC(ID)) Q:ID=""  D
	..S Code=$p(^DHCADVBLDBASIC(ID),"^",1) //代码
	..S Desc=$p(^DHCADVBLDBASIC(ID),"^",2) //描述
	..S Typedr=$p(^DHCADVBLDBASIC(ID),"^",3) //类型
	..S Type=$S(Typedr="A":"患者体征",Typedr="B":"临床症状",1:"")
	..Q:(typedr'="")&(Typedr'[typedr)
	..S BciID="",flag="N"
	..F  S BciID=$o(^DHCADVBLDBACI(0,"BRepDr",bldrptID,BciID))  Q:BciID=""  D 
	...S BciBasDr=$p(^DHCADVBLDBACI(BciID),"^",2)
	...S:BciBasDr=ID flag="Y"
	..S h=h+1
	..S TempStr=ID_"^"_Code_"^"_Desc_"^"_Type_"^"_flag
	..S ^TMP("DHCADV","web.DHCADVBLDREPORT","QueryBldBasRpt",pid,h)=TempStr
	.
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	/*i (h/2)>(h\2)  d
	.s h=(h\2)+1
	e  d
	.s h=(h\2)*/
	///转换数据为Json格式
	S Title="ID^Code^Desc^Type^flag^IDt^Codet^Desct^Typet^flagt"
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVBLDREPORT","QueryBldBasRpt",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVBLDREPORT","QueryBldBasRpt",pid,index))
	.S mdate1=$g(^TMP("DHCADV","web.DHCADVBLDREPORT","QueryBldBasRpt",pid,index+1))
	.S mdata=mdate_"^"_mdate1
	.S count = count+1
	.S index = index+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 获取输血不良反应报告信息  
/// Creator:     CongYue
/// CreateDate:  2016-01-20
/// Table: 		 DHC_AdvBloodReport
/// Input:  	 报告id , params:以字符"^"分割,格式为:人员id^科室id^安全组id^报告类型代码
/// Return： 	 报告表的数据
/// Others:		 w ##class(web.DHCADVBLDREPORT).getBldrptRepInfo("1","600^63^126^blood")
ClassMethod getBldrptRepInfo(bldrptID As %String, params As %String) As %String
{
	N (bldrptID, params)
	Q:'$d(^DHCBLDADVRPT(bldrptID)) ""
	S bldrptRepLocCode=$p(^DHCBLDADVRPT(bldrptID),"^",1) //科室
	S bldrptRepLocDr=""
	S bldrptRepLocDesc=""
	I bldrptRepLocCode'=""  d
	.S bldrptRepLocDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(bldrptRepLocCode),""))
	.S bldrptRepLocDesc=$p(^CTLOC(bldrptRepLocDr),"^",2)
	
	S bldrptCreatorCode=$p(^DHCBLDADVRPT(bldrptID),"^",2)    //填报人
	S bldrptCreator=""
	S bldrptCreatorDesc=""
	I bldrptCreatorCode'=""  d
	.S bldrptCreator=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(bldrptCreatorCode),""))
	.S bldrptCreatorDesc=$p(^SSU("SSUSR",bldrptCreator),"^",2)

	S bldrptRepNo=$p(^DHCBLDADVRPT(bldrptID),"^",3)    //报告编码
	S bldrptCreateDate=$p(^DHCBLDADVRPT(bldrptID),"^",4)    //报告日期
	S:bldrptCreateDate'="" bldrptCreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(bldrptCreateDate)
	S bldrptCreateTime=$p(^DHCBLDADVRPT(bldrptID),"^",5)    //报告时间
	S:bldrptCreateTime'="" bldrptCreateTime=$zt(bldrptCreateTime,1)
	S bldrptWardCode=$p(^DHCBLDADVRPT(bldrptID),"^",6) //病区
	S bldrptWard="",bldrptWardDesc=""
	I bldrptWardCode'=""  S bldrptWard=$o(^PAWARD(0,"WARD_Code",bldrptWardCode,"")) //病区
	I bldrptWard'="" S bldrptWardDesc=$p(^PAWARD(+bldrptWard),"^",2)
	
	S bldrptAdmNo=$p(^DHCBLDADVRPT(bldrptID),"^",7) //病人就诊ID
	S bldrptPatNo=$p(^DHCBLDADVRPT(bldrptID),"^",8) //病人病案号
	S bldrptPatID=$p(^DHCBLDADVRPT(bldrptID),"^",9) //病人ID（登记号）
	S bldrptName=$p(^DHCBLDADVRPT(bldrptID),"^",10) //患者姓名
	S bldrptSex=$p(^DHCBLDADVRPT(bldrptID),"^",11) //性别	
	S bldrptAge=$p(^DHCBLDADVRPT(bldrptID),"^",12) //年龄
	S bldrptBrithDate=$p(^DHCBLDADVRPT(bldrptID),"^",13)     //出生日期
	S:bldrptBrithDate'="" bldrptBrithDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(bldrptBrithDate)
	S bldrptPatCardNo=$p(^DHCBLDADVRPT(bldrptID),"^",14) //身份证号
	
	S bldrptGestation=$p(^DHCBLDADVRPT(bldrptID),"^",15) //孕产史
	S bldrptBloodhis=$p(^DHCBLDADVRPT(bldrptID),"^",16)    //继往输血史
	S bldrptADVBloodhis=$p(^DHCBLDADVRPT(bldrptID),"^",17)     //输血反应史
	S bldrptBloodType=$p(^DHCBLDADVRPT(bldrptID),"^",18)     //输血前血型检查结果
	S bldrptBloodAttr=$p(^DHCBLDADVRPT(bldrptID),"^",19) //阴阳性
	S bldrptAntibody=$p(^DHCBLDADVRPT(bldrptID),"^",20) //意外抗体筛查（阴阳性）
	S bldrptCurrBloodType=$p(^DHCBLDADVRPT(bldrptID),"^",21) //本次输注的血液信息
	S bldrptCurrBloodAttr=$p(^DHCBLDADVRPT(bldrptID),"^",22)     //阴阳性
	S bldrptDiscNum=$p(^DHCBLDADVRPT(bldrptID),"^",23) //输注血量
	S bldrptTemp=$p(^DHCBLDADVRPT(bldrptID),"^",24)    //体温
	S bldrptBloodPress=$p(^DHCBLDADVRPT(bldrptID),"^",25)   //血压	
	S bldrptSphygmus=$p(^DHCBLDADVRPT(bldrptID),"^",26)    //脉搏
	S bldrptBreathes=$p(^DHCBLDADVRPT(bldrptID),"^",27)   //呼吸频次
	S bldrptDrugDesc=$p(^DHCBLDADVRPT(bldrptID),"^",28)     //输血前预防用药
	S bldrptDrugRemark=$p(^DHCBLDADVRPT(bldrptID),"^",29) //输血前预防用药其他
	
	S bldrptStartDate=$p(^DHCBLDADVRPT(bldrptID),"^",30) //开始日期
	S:bldrptStartDate'="" bldrptStartDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(bldrptStartDate)
	S bldrptStartTime=$p(^DHCBLDADVRPT(bldrptID),"^",31) //开始时间
	S:bldrptStartTime'="" bldrptStartTime=$zt(bldrptStartTime,1)
	S bldrptOperator=$p(^DHCBLDADVRPT(bldrptID),"^",32) //操作者工号
	
	S bldrptOccDate=$p(^DHCBLDADVRPT(bldrptID),"^",33) //发现日期
	S:bldrptOccDate'="" bldrptOccDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(bldrptOccDate)
	S bldrptOccTime=$p(^DHCBLDADVRPT(bldrptID),"^",34) //发现时间
	S:bldrptOccTime'="" bldrptOccTime=$zt(bldrptOccTime,1)
	S bldrptDisUser=$p(^DHCBLDADVRPT(bldrptID),"^",35) //发现者工号
	
	S bldrptManf=$p(^DHCBLDADVRPT(bldrptID),"^",36)   //输血器厂家/批号
	S bldrptRemain=$p(^DHCBLDADVRPT(bldrptID),"^",37)  //剩余血量(ml)
	S bldrptAnalyze=$p(^DHCBLDADVRPT(bldrptID),"^",38)   //输血不良反应拟诊
	S bldrptSerLevel=$p(^DHCBLDADVRPT(bldrptID),"^",39)   //严重程度
	S bldrptRelation=$p(^DHCBLDADVRPT(bldrptID),"^",40)     //相关性
	S bldrptWardOp=$p(^DHCBLDADVRPT(bldrptID),"^",41)   //临床处置
	S bldrptPatInfo=$p(^DHCBLDADVRPT(bldrptID),"^",42) 	  //患者转归
	S bldrptDeathDate=$p(^DHCBLDADVRPT(bldrptID),"^",43)    //死亡日期
	S:bldrptDeathDate'="" bldrptDeathDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(bldrptDeathDate)
	S bldrptDeathTime=$p(^DHCBLDADVRPT(bldrptID),"^",44)    //死亡时间
	S:bldrptDeathTime'="" bldrptDeathTime=$zt(bldrptDeathTime,1)

	S bldrptBloodRelat=$p(^DHCBLDADVRPT(bldrptID),"^",45)  //与输血相关性
	S bldrptCurStatusDR=$p(^DHCBLDADVRPT(bldrptID),"^",46)  //当前状态
	S bldrptReportType=$p(^DHCBLDADVRPT(bldrptID),"^",47)  //报告类型
	S bldrptRepImpFlag=$p(^DHCBLDADVRPT(bldrptID),"^",48)  //重要标记
	S PatInfo=##class(web.DHCADVCOMMON).getRepPatInfo(bldrptPatID,bldrptAdmNo)
	S bldrptPatDiag=$p(PatInfo,"^",11)  //病床诊断
	
	S medadrAuditID=$o(^DHCMEDREPADT(0,"Pointer",bldrptReportType,bldrptID,""),-1)
	I medadrAuditID=""  D
	.S medadrNextLoc=""
	.S medadrLocAdvice=""
	.S medadrReceive=""
	E  D
	.S medadrNextLoc=$p(^DHCMEDREPADT(medadrAuditID),"^",7)
	.S medadrLocAdvice=$p(^DHCMEDREPADT(medadrAuditID),"^",8)
	.S medadrReceive=$p(^DHCMEDREPADT(medadrAuditID),"^",9)
	
	S List=##class(web.DHCADVCOMMON).GetStatusDr(params)
	S BldrptInitStatDR=$p(List,"^",2)          //初始状态
	
	S bldrptDataList=bldrptID_"!"_bldrptRepLocDesc_"!"_bldrptCreatorDesc_"!"_bldrptRepNo_"!"_bldrptCreateDate_"!"_bldrptCreateTime_"!"_bldrptWard
	S bldrptDataList=bldrptDataList_"!"_bldrptAdmNo_"!"_bldrptPatNo_"!"_bldrptPatID_"!"_bldrptName_"!"_bldrptSex_"!"_bldrptAge_"!"_bldrptBrithDate_"!"_bldrptPatCardNo
	S bldrptDataList=bldrptDataList_"!"_bldrptGestation_"!"_bldrptBloodhis_"!"_bldrptADVBloodhis_"!"_bldrptBloodType_"!"_bldrptBloodAttr_"!"_bldrptAntibody_"!"_bldrptCurrBloodType
	S bldrptDataList=bldrptDataList_"!"_bldrptCurrBloodAttr_"!"_bldrptDiscNum_"!"_bldrptTemp_"!"_bldrptBloodPress_"!"_bldrptSphygmus_"!"_bldrptBreathes_"!"_bldrptDrugDesc
	S bldrptDataList=bldrptDataList_"!"_bldrptDrugRemark_"!"_bldrptStartDate_"!"_bldrptStartTime_"!"_bldrptOperator_"!"_bldrptOccDate_"!"_bldrptOccTime_"!"_bldrptDisUser
	S bldrptDataList=bldrptDataList_"!"_bldrptManf_"!"_bldrptRemain_"!"_bldrptAnalyze_"!"_bldrptSerLevel_"!"_bldrptRelation_"!"_bldrptWardOp_"!"_bldrptPatInfo_"!"_bldrptDeathDate
	S bldrptDataList=bldrptDataList_"!"_bldrptDeathTime_"!"_bldrptBloodRelat_"!"_bldrptCurStatusDR_"!"_bldrptReportType_"!"_BldrptInitStatDR_"!"_medadrNextLoc
	S bldrptDataList=bldrptDataList_"!"_medadrLocAdvice_"!"_medadrReceive_"!"_bldrptCreator_"!"_bldrptRepLocDr_"!"_bldrptRepImpFlag_"!"_bldrptPatDiag_"!"_bldrptWardDesc
		
 	Q bldrptDataList
}

/// Description: 获取血液类别  
/// Creator:     CongYue
/// CreateDate:  2016-04-8
/// Table: 		 DHC_AdvBldRepList
/// Input:  	 报告id 
/// Return： 	 报告表的数据
/// Others:		 w ##class(web.DHCADVBLDREPORT).getBldTypeInfo("12","1","")
ClassMethod getBldTypeInfo(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	Q:params="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	S bldrptID=params
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
	S h=0,count=0
	S bldid=""
	S childSub=""
	S bldNos=""
	F  S bldid=$o(^DHCADVBLDRLI(0,"RepDr",bldrptID,bldid)) Q:bldid=""  d
	.S bldtype=$p(^DHCADVBLDRLI(bldid),"^",2) //血液类别
	.F  S childSub=$o(^DHCADVBLDRLIN(bldid,"BLDI",childSub))  Q:childSub=""  d
	..S bldNo=$p(^DHCADVBLDRLIN(bldid,"BLDI",childSub),"^",1) 
	..S bldNos=bldNos_"^"_bldNo
	.Q:bldNos="" 
	.S h=h+1
	.S TempStr=bldid_"^"_bldtype_"^"_bldNos
	.S ^TMP("DHCADV","web.DHCADVBLDREPORT","getBldTypeInfo",pid,h)=TempStr
	.S bldNos=""
	
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="bldid^bldtype^^bldone^bldtwo^bldthree^bldfour"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVBLDREPORT","getBldTypeInfo",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVBLDREPORT","getBldTypeInfo",pid,index))
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

/// Description: 获取输血不良反应报告信息(打印/导出)
/// Creator:   	 CongYue
/// CreateDate:  2016-01-26
/// Input:  	 输血报告id  
/// Return：  	 输血报告信息   
/// Others:		 w ##class(web.DHCADVBLDREPORT).getBldRepExportInfo("1")
ClassMethod getBldRepExportInfo(bldrptID As %String) As %String
{
	N (bldrptID)
	Q:'$d(^DHCBLDADVRPT(bldrptID)) ""
	S bldrptRepLocCode=$p(^DHCBLDADVRPT(bldrptID),"^",1) //科室
	S bldrptRepLocDr=""
	S bldrptRepLocDesc=""
	I bldrptRepLocCode'=""  d
	.S bldrptRepLocDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(bldrptRepLocCode),""))
	.S bldrptRepLocDesc=$p(^CTLOC(bldrptRepLocDr),"^",2)
	
	S bldrptCreatorCode=$p(^DHCBLDADVRPT(bldrptID),"^",2)    //填报人
	S bldrptCreator=""
	S bldrptCreatorDesc=""
	I bldrptCreatorCode'=""  d
	.S bldrptCreator=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(bldrptCreatorCode),""))
	.S bldrptCreatorDesc=$p(^SSU("SSUSR",bldrptCreator),"^",2)
	S bldrptRepNo=$p(^DHCBLDADVRPT(bldrptID),"^",3)    //报告编码
	S bldrptCreateDate=$p(^DHCBLDADVRPT(bldrptID),"^",4)    //报告日期
	S:bldrptCreateDate'="" bldrptCreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(bldrptCreateDate)
	S bldrptCreateTime=$p(^DHCBLDADVRPT(bldrptID),"^",5)    //报告时间
	S:bldrptCreateTime'="" bldrptCreateTime=$zt(bldrptCreateTime,1)
	S bldrptWardCode=$p(^DHCBLDADVRPT(bldrptID),"^",6) //病区
	S bldrptWardDr="",bldrptWard=""
	S:bldrptWardCode'="" bldrptWardDr=$o(^PAWARD(0,"WARD_Code",bldrptWardCode,"")) //病区
	S:bldrptWardDr'="" bldrptWard=$p(^PAWARD(bldrptWardDr),"^",2) //病区
	S:bldrptWard["-" bldrptWard=$p(bldrptWard,"-",2)
	
	S bldrptAdmNo=$p(^DHCBLDADVRPT(bldrptID),"^",7) //病人就诊ID
	S bldrptPatNo=$p(^DHCBLDADVRPT(bldrptID),"^",8) //病人病案号
	S bldrptPatID=$p(^DHCBLDADVRPT(bldrptID),"^",9) //病人ID（登记号）
	S bldrptName=$p(^DHCBLDADVRPT(bldrptID),"^",10) //患者姓名
	S bldrptSex=$p(^DHCBLDADVRPT(bldrptID),"^",11) //性别
	S:bldrptSex'="" bldrptSex=$p(^CT("SEX",bldrptSex),"^",2)
	S bldrptAge=$p(^DHCBLDADVRPT(bldrptID),"^",12) //年龄
	S bldrptBrithDate=$p(^DHCBLDADVRPT(bldrptID),"^",13)     //出生日期
	S:bldrptBrithDate'="" bldrptBrithDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(bldrptBrithDate)
	S bldrptPatCardNo=$p(^DHCBLDADVRPT(bldrptID),"^",14) //身份证号
	
	S bldrptGestation=$p(^DHCBLDADVRPT(bldrptID),"^",15) //孕产史
	S bldrptGestation=$S(bldrptGestation="0":"无",bldrptGestation="1":"孕",bldrptGestation="2":"产",1:"")
	S bldrptBloodhis=$p(^DHCBLDADVRPT(bldrptID),"^",16)    //继往输血史
	S bldrptBloodhis=$S(bldrptBloodhis="0":"无",bldrptBloodhis="1":"有",1:"")
	S bldrptADVBloodhis=$p(^DHCBLDADVRPT(bldrptID),"^",17)     //输血反应史
	S bldrptADVBloodhis=$S(bldrptADVBloodhis="0":"无",bldrptADVBloodhis="1":"有",1:"")
	
	S bldrptBloodType=$p(^DHCBLDADVRPT(bldrptID),"^",18)     //输血前血型检查结果
	S bldrptBloodAttr=$p(^DHCBLDADVRPT(bldrptID),"^",19) //阴阳性
	S bldrptAntibody=$p(^DHCBLDADVRPT(bldrptID),"^",20) //意外抗体筛查（阴阳性）
	S bldrptCurrBloodType=$p(^DHCBLDADVRPT(bldrptID),"^",21) //本次输注的血液信息
	S bldrptCurrBloodAttr=$p(^DHCBLDADVRPT(bldrptID),"^",22)     //阴阳性
	S bldrptDiscNum=$p(^DHCBLDADVRPT(bldrptID),"^",23) //输注血量
	S bldrptTemp=$p(^DHCBLDADVRPT(bldrptID),"^",24)    //体温
	S bldrptBloodPress=$p(^DHCBLDADVRPT(bldrptID),"^",25)   //血压	
	S bldrptSphygmus=$p(^DHCBLDADVRPT(bldrptID),"^",26)    //脉搏
	S bldrptBreathes=$p(^DHCBLDADVRPT(bldrptID),"^",27)   //呼吸频次
	
	S bldrptDrugDesc=$p(^DHCBLDADVRPT(bldrptID),"^",28)     //输血前预防用药
	S bldrptDrugDesc=$S(bldrptDrugDesc="0":"无",bldrptDrugDesc="1":"有",1:"")
	S bldrptDrugRemark=$p(^DHCBLDADVRPT(bldrptID),"^",29) //输血前预防用药其他
	
	S bldrptStartDate=$p(^DHCBLDADVRPT(bldrptID),"^",30) //开始日期
	S:bldrptStartDate'="" bldrptStartDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(bldrptStartDate)
	S bldrptStartTime=$p(^DHCBLDADVRPT(bldrptID),"^",31) //开始时间
	S:bldrptStartTime'="" bldrptStartTime=$zt(bldrptStartTime,1)
	S bldrptOperator=$p(^DHCBLDADVRPT(bldrptID),"^",32) //操作者工号
	
	S bldrptOccDate=$p(^DHCBLDADVRPT(bldrptID),"^",33) //发现日期
	S:bldrptOccDate'="" bldrptOccDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(bldrptOccDate)
	S bldrptOccTime=$p(^DHCBLDADVRPT(bldrptID),"^",34) //发现时间
	S:bldrptOccTime'="" bldrptOccTime=$zt(bldrptOccTime,1)
	S bldrptDisUser=$p(^DHCBLDADVRPT(bldrptID),"^",35) //发现者工号
	
	S bldrptManf=$p(^DHCBLDADVRPT(bldrptID),"^",36)   //输血器厂家/批号
	S bldrptRemain=$p(^DHCBLDADVRPT(bldrptID),"^",37)  //剩余血量(ml)
	S bldrptAnalyze=$p(^DHCBLDADVRPT(bldrptID),"^",38)   //输血不良反应拟诊
	S bldrptSerLevel=$p(^DHCBLDADVRPT(bldrptID),"^",39)   //严重程度
	S bldrptSerLevel=$S(bldrptSerLevel="1":"不严重",bldrptSerLevel="2":"严重",bldrptSerLevel="3":"危及生命",bldrptSerLevel="4":"死亡",bldrptSerLevel="5":"不确定",1:"")
	S bldrptRelation=$p(^DHCBLDADVRPT(bldrptID),"^",40)     //相关性
	S bldrptRelation=$S(bldrptRelation="1":"明确",bldrptRelation="2":"可能",bldrptRelation="3":"疑似",bldrptRelation="4":"排除",bldrptRelation="5":"不确定",1:"")
	S bldrptWardOp=$p(^DHCBLDADVRPT(bldrptID),"^",41)   //临床处置
	S bldrptPatInfo=$p(^DHCBLDADVRPT(bldrptID),"^",42) 	  //患者转归
	S bldrptPatInfo=$S(bldrptPatInfo="1":"死亡",bldrptPatInfo="2":"严重或长期后遗症",bldrptPatInfo="3":" 轻微或无后疑症",bldrptPatInfo="4":"不确定",1:"")
	S bldrptDeathDate=$p(^DHCBLDADVRPT(bldrptID),"^",43)    //死亡日期
	S:bldrptDeathDate'="" bldrptDeathDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(bldrptDeathDate)
	S bldrptDeathTime=$p(^DHCBLDADVRPT(bldrptID),"^",44)    //死亡时间
	S:bldrptDeathTime'="" bldrptDeathTime=$zt(bldrptDeathTime,1)

	S bldrptBloodRelat=$p(^DHCBLDADVRPT(bldrptID),"^",45)  //与输血相关性
	S bldrptBloodRelat=$S(bldrptBloodRelat="1":"明确",bldrptBloodRelat="2":"可能",bldrptBloodRelat="3":"疑似",bldrptBloodRelat="4":"排除",bldrptBloodRelat="5":"不确定",1:"")
	S bldrptCurStatusDR=$p(^DHCBLDADVRPT(bldrptID),"^",46)  //当前状态
	S bldrptReportType=$p(^DHCBLDADVRPT(bldrptID),"^",47)  //报告类型
	
	S bldrptBldBasA=..getBldBasRpt(bldrptID,"A") //输血不良反应描述 患者体征 
	S bldrptBldBasB=..getBldBasRpt(bldrptID,"B") //输血不良反应描述 临床症状
	S bldrptBldType=..getBldTypeExportInfo(bldrptID) //输血信息  血液类别
	
	S PatInfo=##class(web.DHCADVCOMMON).getRepPatInfo(bldrptPatID,bldrptAdmNo)
	S bldrptPatDiag=$p(PatInfo,"^",11)  //病床诊断
	
	S bldrptDataList=bldrptID_"&&"_bldrptRepLocDesc_"&&"_bldrptCreatorDesc_"&&"_bldrptRepNo_"&&"_bldrptCreateDate_"&&"_bldrptCreateTime_"&&"_bldrptWard
	S bldrptDataList=bldrptDataList_"&&"_bldrptAdmNo_"&&"_bldrptPatNo_"&&"_bldrptPatID_"&&"_bldrptName_"&&"_bldrptSex_"&&"_bldrptAge_"&&"_bldrptBrithDate_"&&"_bldrptPatCardNo
	S bldrptDataList=bldrptDataList_"&&"_bldrptGestation_"&&"_bldrptBloodhis_"&&"_bldrptADVBloodhis_"&&"_bldrptBloodType_"&&"_bldrptBloodAttr_"&&"_bldrptAntibody_"&&"_bldrptCurrBloodType
	S bldrptDataList=bldrptDataList_"&&"_bldrptCurrBloodAttr_"&&"_bldrptDiscNum_"&&"_bldrptTemp_"&&"_bldrptBloodPress_"&&"_bldrptSphygmus_"&&"_bldrptBreathes_"&&"_bldrptDrugDesc
	S bldrptDataList=bldrptDataList_"&&"_bldrptDrugRemark_"&&"_bldrptStartDate_"&&"_bldrptStartTime_"&&"_bldrptOperator_"&&"_bldrptOccDate_"&&"_bldrptOccTime_"&&"_bldrptDisUser
	S bldrptDataList=bldrptDataList_"&&"_bldrptManf_"&&"_bldrptRemain_"&&"_bldrptAnalyze_"&&"_bldrptSerLevel_"&&"_bldrptRelation_"&&"_bldrptWardOp_"&&"_bldrptPatInfo_"&&"_bldrptDeathDate
	S bldrptDataList=bldrptDataList_"&&"_bldrptDeathTime_"&&"_bldrptBloodRelat_"&&"_bldrptCurStatusDR_"&&"_bldrptReportType_"&&"_bldrptBldBasA_"&&"_bldrptBldBasB_"&&"_bldrptBldType_"&&"_bldrptPatDiag
	
	Q bldrptDataList
}

/// Description: 获取血液类别(打印/导出)信息  
/// Creator:     CongYue
/// CreateDate:  2016-05-26
/// Table: 		 DHC_AdvBldRepList
/// Input:  	 报告id 
/// Return： 	 报告表的数据
/// Others:		 w ##class(web.DHCADVBLDREPORT).getBldTypeExportInfo("45")
ClassMethod getBldTypeExportInfo(bldrptID As %String) As %String
{
	N (bldrptID)
	Q:bldrptID="" ""
	S tempStr=""
	S tempList=""
	S h=0,count=0
	S bldid=""
	S childSub=""
	S bldNos=""
	F  S bldid=$o(^DHCADVBLDRLI(0,"RepDr",bldrptID,bldid)) Q:bldid=""  d
	.S bldtype=$p(^DHCADVBLDRLI(bldid),"^",2) //血液类别
	.F  S childSub=$o(^DHCADVBLDRLIN(bldid,"BLDI",childSub))  Q:childSub=""  d
	..S bldNo=$p(^DHCADVBLDRLIN(bldid,"BLDI",childSub),"^",1) 
	..S bldNos=bldNos_"^"_bldNo
	.Q:bldNos="" 
	.S h=h+1
	.S ListData=bldid_"^"_bldtype_"^"_bldNos
	.I tempStr="" S tempStr=ListData
	.E  S tempStr=tempStr_"&"_ListData	
	.S bldNos=""
	Q tempStr
}

/// Description: 获取输血患者体征信息(打印/导出)
/// Creator:     CongYue
/// CreateDate:  2016-01-26
/// Input:  	 报告表id
/// Return:  	 tempStr : 是否选择^体征描述  
/// Others:		 w ##class(web.DHCADVBLDREPORT).getBldBasRpt("1","A")
ClassMethod getBldBasRpt(bldrptID As %String, typedr As %String) As %String
{
	N (bldrptID,typedr)
	S ID="0"
	S tempStr=""
	F  S ID=$o(^DHCADVBLDBASIC(ID)) Q:ID=""  D
	.S Code=$p(^DHCADVBLDBASIC(ID),"^",1) //代码
	.S Desc=$p(^DHCADVBLDBASIC(ID),"^",2) //描述
	.S Type=$p(^DHCADVBLDBASIC(ID),"^",3) //类型
	.Q:(typedr'="")&(Type'[typedr)
	.S BciID="",flag="  "
	.F  S BciID=$o(^DHCADVBLDBACI(0,"BRepDr",bldrptID,BciID))  Q:BciID=""  D 
	..S BciBasDr=$p(^DHCADVBLDBACI(BciID),"^",2)
	..S:BciBasDr=ID flag="√"
	.S ListData=flag_"^"_Desc
	.I tempStr="" S tempStr=ListData
	.E  S tempStr=tempStr_"&"_ListData	
	Q tempStr
}

/// Description:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	K ^TMP("DHCADV","web.DHCADVBLDREPORT","QueryBldBasic",pid)
	
	K ^TMP("DHCADV","web.DHCADVBLDREPORT","QueryBldBasRpt",pid)
	
	K ^TMP("DHCADV","web.DHCADVBLDREPORT","getBldTypeInfo",pid)
}

/// Description: 检查报告编码是否存在
/// Creator:     CongYue
/// CreateDate:  2016-05-04
/// Table:		 DHC_AdvBloodReport
/// Input:  	 params :报告编码
/// Output:		 0 不存在  1 存在
/// Others:		 w ##class(web.DHCADVBLDREPORT).SearchRepNoRepet("BLDRPT20160120001")
ClassMethod SearchRepNoRepet(RepNo As %String) As %String
{
	N (RepNo)
	S flag=0
	I $d(^DHCBLDADVRPT(0,"RepNo",RepNo)) D
	.S flag=1
	Q flag
}

}
