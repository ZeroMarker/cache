Import sqluser

Class web.DHCADVMEDREPORT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 器械医疗不良事件中的重要标记
/// Creator:     yangyongtao
/// CreateDate:  2016-4-27
/// Table: 		 DHC_MatAdrReport
/// Input:  	    报告表数据
/// Return： 	 数据id
/// Others:		 w ##class(web.DHCADVMEDREPORT).InsImpReport("144","N")
ClassMethod InsImpReport(matadrID As %String, matadrRepImpFlag As %String) As %String
{
    N (matadrID,matadrRepImpFlag)
    I matadrRepImpFlag="N" D
    .S matadrRepImpFlag="Y"
    E  S matadrRepImpFlag="N"  ;2016-10-17
    &SQL(Update DHC_MatAdrReport Set MATADR_RepImpFlag=:matadrRepImpFlag Where MATADR_RowID=:matadrID)	
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 保存  器械报告表 
/// Creator:	 CongYue
/// CreateDate:  2015-09-23
/// Table: 		 DHC_MatAdrReport
/// Input:  	 DataList:不良反应/事件的id^代码^描述
/// Return： 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPORT).InsMataReport("MATADR20151128003^2^24^杜桑^0000000001^qq^2015-11-27^16:37:22^
/// 			 sqs^2015-11-27^2015-11-27^11^^13^^^单核细胞:10个；^^^^^^^^^^^^^^^^^^^^^^蒋荣猛^传染科门诊^^^2015-11-27^16:37:17^")
ClassMethod InsMataReport(dataList As %String) As %String
{
	N (dataList)
	S matadrNo=..GetAdrReportCurMaxNo("MATADR"_$zd(+$H,8),"3") //报告编码 $p(dataList,"^",1)
	S matadrSex=$p(dataList,"^",2) //性别
	S matadrAge=$p(dataList,"^",3) //年龄
	S matadrName=$p(dataList,"^",4) //患者姓名
	S matadrPatNo=$p(dataList,"^",5) //患者登记号	
	S matadrExpectEff=$p(dataList,"^",6) //预期治疗疾病或作用	
	S matadrAdmDateResult=$p(dataList,"^",7)    //诊疗 日期
	S:matadrAdmDateResult'="" matadrAdmDateResult=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrAdmDateResult)
	S matadrAdmTimeResult=$p(dataList,"^",8)    //诊疗 时间
	S:matadrAdmTimeResult'="" matadrAdmTimeResult=$zth(matadrAdmTimeResult,1)

	S matadrMainExp=$p(dataList,"^",9)     //事件主要表现
	S matadrAdrDate=$p(dataList,"^",10) //事件发生日期
	S:matadrAdrDate'="" matadrAdrDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrAdrDate)	
	S matadrDiscDate=$p(dataList,"^",11) //事件发现时间
	S:matadrDiscDate'="" matadrDiscDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrDiscDate)	
	S matadrUsePlace=$p(dataList,"^",12)     //医疗器械实际使用场所
	S matadrUsePlaceOth=$p(dataList,"^",13)     //医疗器械实际使用场所其他
	S matadrResult=$p(dataList,"^",14)    //事件后果
	S matadrDeathDate=$p(dataList,"^",15)    //死亡 日期
	S:matadrDeathDate'="" matadrDeathDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrDeathDate)
	S matadrDeathTime=$p(dataList,"^",16)    //死亡 时间
	S:matadrDeathTime'="" matadrDeathTime=$zth(matadrDeathTime,1)
	
	S matadrEventDesc=$p(dataList,"^",17)     //事件陈述
	S matadrProName=$p(dataList,"^",18)     //产品名称
	S matadrInciName=$p(dataList,"^",19) //商品名称
	S matadrRegNo=$p(dataList,"^",20) //注册证号
	S matadrManf=$p(dataList,"^",21)     //生产企业名称
	S matadrManfAddress=$p(dataList,"^",22)     //生产企业地址
	S matadrManfTel=$p(dataList,"^",23) //企业联系电话
	S matadrSpec=$p(dataList,"^",24)    //型号规格
	S matadrProCode=$p(dataList,"^",25)   //产品编号	
	S matadrProBatNo=$p(dataList,"^",26)    //产品批号
	S matadrOperator=$p(dataList,"^",27)   //操作人
	S matadrOperatorOth=$p(dataList,"^",28)     //操作人其他
	
	S matadrExpDate=$p(dataList,"^",29) //有效期至
	S:matadrExpDate'="" matadrExpDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrExpDate)
	S matadrProDate=$p(dataList,"^",30) //生产日期
	S:matadrProDate'="" matadrProDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrProDate)
	S matadrDisDate=$p(dataList,"^",31) //停用日期
	S:matadrDisDate'="" matadrDisDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrDisDate)
	S matadrUseDate=$p(dataList,"^",32) //植入日期
	S:matadrUseDate'="" matadrUseDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrUseDate)
	
	S matadrReasonDesc=$p(dataList,"^",33) //事件发生初步原因分
	S matadrHandInfo=$p(dataList,"^",34) //事件初步处理情况
	S matadrHandStatus=$p(dataList,"^",35) //事件报告状态
	S matadrProAdvice=$p(dataList,"^",36)   //省级监测技术机构评价意见
	S matadrCountryAdvice=$p(dataList,"^",37)  //国家监测技术机构评价意见
	S matadrCarPrvTp=$p(dataList,"^",38)   //报告人职称
	S matadrRepUserDr=$p(dataList,"^",39)   //报告人
	S matadrRepName=""
	I matadrRepUserDr'="" S matadrRepName=$p(^SSU("SSUSR",matadrRepUserDr),"^",1)	
	
	S matadrRepLocDr=$p(dataList,"^",40)     //报告科室
	S matadrRepLocCode=""
	I matadrRepLocDr'="" S matadrRepLocCode=$p(^CTLOC(matadrRepLocDr),"^",1)
	
	S matadrRepTel=$p(dataList,"^",41)   //报告人联系电话
	S matadrRepEmail=$p(dataList,"^",42) 	  //邮箱
	S matadrCreateDateResult=$p(dataList,"^",43)    //报告 日期
	S:matadrCreateDateResult'="" matadrCreateDateResult=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrCreateDateResult)
	S matadrCreateTimeResult=$p(dataList,"^",44)    //报告 时间
	S:matadrCreateTimeResult'="" matadrCreateTimeResult=$zth(matadrCreateTimeResult,1)

	S matadrCurStatDR="" //$p(dataList,"^",45)  //当前状态
	
	S matadrReportType=$p(dataList,"^",46)  //报告类型
	S matadrRepImpFlag=$p(dataList,"^",47)  //重要标记
	S matadrAdmNo=$p(dataList,"^",48)  //就诊ID

	S matadrIfReaOrder=$p(dataList,"^",49)  // 是否具有合理的先后顺序
	S matadrIfDamageType=$p(dataList,"^",50)  // 是否属于所使用医疗器械可能导致的伤害类型
	S matadrIfReasonable=$p(dataList,"^",51)  // 是否可以用合并用药的作用、患者病情或其他非医疗器械因素来解释
	S matadrRelEvaluation=$p(dataList,"^",52)  // 关联性评价结果
	S matadrEventLevel=$P(dataList,"^",53)  //医疗安全（不良）事件类别
	S matadrInjuryLevel=$P(dataList,"^",54)  //给患者造成损害的轻重程度
	S matadrHappenTime=$P(dataList,"^",55)  //发生时间段
	

	&SQL(Insert Into DHC_MatAdrReport(
		MATADR_No,MATADR_Sex,MATADR_Age,MATADR_Name,MATADR_PatId,MATADR_AdmDate,
		MATADR_AdmTime,MATADR_MainExp,MATADR_AdrDate,MATADR_DiscDate,MATADR_UsePlace,
		MATADR_UsePlaceOth,MATADR_EventDesc,MATADR_ProName,MATADR_InciName,MATADR_RegNo,MATADR_Manf,
		MATADR_ManfAddress,MATADR_ManfTel,MATADR_Spec,MATADR_ProCode,MATADR_ProBatNo,MATADR_Operator,
		MATADR_OperatorOth,MATADR_ExpDate,MATADR_ProDate,MATADR_DisDate,MATADR_UseDate,MATADR_ReasonDesc,
		MATADR_HandInfo,MATADR_HandStatus,MATADR_ProAdvice,MATADR_CountryAdvice,MATADR_CarPrvTp,
		MATADR_RepName,MATADR_RepLocDr,MATADR_RepTel,MATADR_RepEmail,MATADR_CreateDate,
		MATADR_CreateTime,MATADR_CurStatus_DR,MATADR_ExpectEff,MATADR_AdrResult,MATADR_DeathDate,
		MATADR_DeathTime,MATADR_Type_Dr,MATADR_RepImpFlag,MATADR_AdmNo,
		MATADR_IfReaOrder,MATADR_IfDamageType,MATADR_IfReasonable,MATADR_RelEvaluation
	) Values(
		:matadrNo,:matadrSex,:matadrAge,:matadrName,:matadrPatNo,:matadrAdmDateResult,
		:matadrAdmTimeResult,:matadrMainExp,:matadrAdrDate,:matadrDiscDate,:matadrUsePlace,
		:matadrUsePlaceOth,:matadrEventDesc,:matadrProName,:matadrInciName,:matadrRegNo,:matadrManf,
		:matadrManfAddress,:matadrManfTel,:matadrSpec,:matadrProCode,:matadrProBatNo,:matadrOperator,
		:matadrOperatorOth,:matadrExpDate,:matadrProDate,:matadrDisDate,:matadrUseDate,:matadrReasonDesc,
		:matadrHandInfo,:matadrHandStatus,:matadrProAdvice,:matadrCountryAdvice,:matadrCarPrvTp,
		:matadrRepName,:matadrRepLocCode,:matadrRepTel,:matadrRepEmail,:matadrCreateDateResult,
		:matadrCreateTimeResult,:matadrCurStatDR,:matadrExpectEff,:matadrResult,:matadrDeathDate,
		:matadrDeathTime,:matadrReportType,:matadrRepImpFlag,:matadrAdmNo,
		:matadrIfReaOrder,:matadrIfDamageType,:matadrIfReasonable,:matadrRelEvaluation
	))

	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 更新  器械报告表  
/// Creator:	 CongYue
/// CreateDate:  2015-09-23
/// Table:		 DHC_MatAdrReport
/// Input:		 报告表id , 报告表数据
/// Return:		 报告表rowid
/// Others:		 w ##class(web.DHCADVMEDREPORT).UpdMataReport("79","MATADR20151130006^2^24^杜桑^0000000001^qq^2015-11-27^16:37:22^sqs
/// 			 ^2015-11-27^2015-11-27^11^^13^^^单核细胞:10个；^^^^^^^^^^^^^^^^^^^^^^蒋荣猛^传染科门诊^^^2015-11-27^16:37:17^")
ClassMethod UpdMataReport(matadrID As %String, dataList As %String) As %String
{
	
	N (matadrID,dataList)
	S matadrNo=$p(^DHCMATADRR(matadrID),"^",1)    //报告编码
	S matadrSex=$p(dataList,"^",2) //性别
	S matadrAge=$p(dataList,"^",3) //年龄
	S matadrName=$p(dataList,"^",4) //患者姓名
	S matadrPatNo=$p(dataList,"^",5) //患者登记号	
	S matadrExpectEff=$p(dataList,"^",6) //预期治疗疾病或作用	
	S matadrAdmDateResult=$p(dataList,"^",7)    //诊疗 日期
	S:matadrAdmDateResult'="" matadrAdmDateResult=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrAdmDateResult)
	S matadrAdmTimeResult=$p(dataList,"^",8)    //诊疗 时间
	S:matadrAdmTimeResult'="" matadrAdmTimeResult=$zth(matadrAdmTimeResult,1)

	S matadrMainExp=$p(dataList,"^",9)     //事件主要表现
	S matadrAdrDate=$p(dataList,"^",10) //事件发生日期
	S:matadrAdrDate'="" matadrAdrDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrAdrDate)	
	S matadrDiscDate=$p(dataList,"^",11) //事件发现时间
	S:matadrDiscDate'="" matadrDiscDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrDiscDate)	
	S matadrUsePlace=$p(dataList,"^",12)     //医疗器械实际使用场所
	S matadrUsePlaceOth=$p(dataList,"^",13)     //医疗器械实际使用场所其他
	S matadrResult=$p(dataList,"^",14)    //事件后果
	S matadrDeathDate=$p(dataList,"^",15)    //死亡 日期
	S:matadrDeathDate'="" matadrDeathDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrDeathDate)
	S matadrDeathTime=$p(dataList,"^",16)    //死亡 时间
	S:matadrDeathTime'="" matadrDeathTime=$zth(matadrDeathTime,1)
	
	S matadrEventDesc=$p(dataList,"^",17)     //事件陈述
	S matadrProName=$p(dataList,"^",18)     //产品名称
	S matadrInciName=$p(dataList,"^",19) //商品名称
	S matadrRegNo=$p(dataList,"^",20) //注册证号
	S matadrManf=$p(dataList,"^",21)     //生产企业名称
	S matadrManfAddress=$p(dataList,"^",22)     //生产企业地址
	S matadrManfTel=$p(dataList,"^",23) //企业联系电话
	S matadrSpec=$p(dataList,"^",24)    //型号规格
	S matadrProCode=$p(dataList,"^",25)   //产品编号	
	S matadrProBatNo=$p(dataList,"^",26)    //产品批号
	S matadrOperator=$p(dataList,"^",27)   //操作人
	S matadrOperatorOth=$p(dataList,"^",28)     //操作人其他
	
	S matadrExpDate=$p(dataList,"^",29) //有效期至
	S:matadrExpDate'="" matadrExpDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrExpDate)
	S matadrProDate=$p(dataList,"^",30) //生产日期
	S:matadrProDate'="" matadrProDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrProDate)
	S matadrDisDate=$p(dataList,"^",31) //停用日期
	S:matadrDisDate'="" matadrDisDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrDisDate)
	S matadrUseDate=$p(dataList,"^",32) //植入日期
	S:matadrUseDate'="" matadrUseDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrUseDate)
	
	S matadrReasonDesc=$p(dataList,"^",33) //事件发生初步原因分
	S matadrHandInfo=$p(dataList,"^",34) //事件初步处理情况
	S matadrHandStatus=$p(dataList,"^",35) //事件报告状态
	S matadrProAdvice=$p(dataList,"^",36)   //省级监测技术机构评价意见
	S matadrCountryAdvice=$p(dataList,"^",37)  //国家监测技术机构评价意见
	S matadrCarPrvTp=$p(dataList,"^",38)   //报告人职称
	S matadrRepUserDr=$p(dataList,"^",39)   //报告人
	S matadrRepName=""
	I matadrRepUserDr'="" S matadrRepName=$p(^SSU("SSUSR",matadrRepUserDr),"^",1)	
	
	S matadrRepLocDr=$p(dataList,"^",40)     //报告科室
	S matadrRepLocCode=""
	I matadrRepLocDr'="" S matadrRepLocCode=$p(^CTLOC(matadrRepLocDr),"^",1)
	S matadrRepTel=$p(dataList,"^",41)   //报告人联系电话
	S matadrRepEmail=$p(dataList,"^",42) 	  //邮箱
	S matadrCreateDateResult=$p(dataList,"^",43)    //报告 日期
	S:matadrCreateDateResult'="" matadrCreateDateResult=##class(web.DHCADVCOMMON).DateHtmlToLogical(matadrCreateDateResult)
	S matadrCreateTimeResult=$p(dataList,"^",44)    //报告 时间
	S:matadrCreateTimeResult'="" matadrCreateTimeResult=$zth(matadrCreateTimeResult,1)
	S matadrCurStatDR=$p(dataList,"^",45)  //当前状态
	S matadrReportType=$p(dataList,"^",46)  //报告类型
	S matadrRepImpFlag=$p(dataList,"^",47)  //重要标记
	S matadrAdmNo=$p(dataList,"^",48)  //就诊ID
	
	S matadrIfReaOrder=$p(dataList,"^",49)  // 是否具有合理的先后顺序
	S matadrIfDamageType=$p(dataList,"^",50)  // 是否属于所使用医疗器械可能导致的伤害类型
	S matadrIfReasonable=$p(dataList,"^",51)  // 是否可以用合并用药的作用、患者病情或其他非医疗器械因素来解释
	S matadrRelEvaluation=$p(dataList,"^",52)  // 关联性评价结果

	&SQL(Update DHC_MatAdrReport Set 
		MATADR_No=:matadrNo,MATADR_Sex=:matadrSex,MATADR_Age=:matadrAge,MATADR_Name=:matadrName,MATADR_PatId=:matadrPatNo,
		MATADR_AdmDate=:matadrAdmDateResult,MATADR_AdmTime=:matadrAdmTimeResult,MATADR_MainExp=:matadrMainExp,MATADR_AdrDate=:matadrAdrDate,
		MATADR_DiscDate=:matadrDiscDate,MATADR_UsePlace=:matadrUsePlace,MATADR_UsePlaceOth=:matadrUsePlaceOth,MATADR_EventDesc=:matadrEventDesc,
		MATADR_ProName=:matadrProName,MATADR_InciName=:matadrInciName,MATADR_RegNo=:matadrRegNo,MATADR_Manf=:matadrManf,
		MATADR_ManfAddress=:matadrManfAddress,MATADR_ManfTel=:matadrManfTel,MATADR_Spec=:matadrSpec,MATADR_ProCode=:matadrProCode,
		MATADR_ProBatNo=:matadrProBatNo,MATADR_Operator=:matadrOperator,MATADR_OperatorOth=:matadrOperatorOth,MATADR_ExpDate=:matadrExpDate,
		MATADR_ProDate=:matadrProDate,MATADR_DisDate=:matadrDisDate,MATADR_UseDate=:matadrUseDate,MATADR_ReasonDesc=:matadrReasonDesc,
		MATADR_HandInfo=:matadrHandInfo,MATADR_HandStatus=:matadrHandStatus,MATADR_ProAdvice=:matadrProAdvice,MATADR_CountryAdvice=:matadrCountryAdvice,
		MATADR_CarPrvTp=:matadrCarPrvTp,MATADR_RepName=:matadrRepName,MATADR_RepLocDr=:matadrRepLocCode,MATADR_RepTel=:matadrRepTel,
		MATADR_RepEmail=:matadrRepEmail,MATADR_CreateDate=:matadrCreateDateResult,MATADR_CreateTime=:matadrCreateTimeResult,
		MATADR_CurStatus_DR=:matadrCurStatDR,MATADR_ExpectEff=:matadrExpectEff,MATADR_AdrResult=:matadrResult,MATADR_DeathDate=:matadrDeathDate,
		MATADR_DeathTime=:matadrDeathTime,MATADR_Type_Dr=:matadrReportType,MATADR_RepImpFlag=:matadrRepImpFlag,MATADR_AdmNo=:matadrAdmNo,
		MATADR_IfReaOrder=:matadrIfReaOrder,MATADR_IfDamageType=:matadrIfDamageType,MATADR_IfReasonable=:matadrIfReasonable,MATADR_RelEvaluation=:matadrRelEvaluation Where MATADR_RowID=:matadrID)
		
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 保存  器械报告表  
/// Creator:	 CongYue
/// CreateDate:  2015-09-23
/// Table: 		 DHC_MatAdrReport
/// Input:  	 报告表id , 报告表数据 , matadrRepAuditList:以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return： 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPORT).saveMataReport("131","MATADR20160419001^1^20^test^0000000420^预期治疗疾病或作用^2015-09-07^09:20:47^事件主要表现^2016-04-19^2016-04-19^10^^11^^^器械使用时间:2016-04-19；使用目的:SD；使用依据:AA；使用情况:z；不良事件情况:ZZX；^^^^^^^^^^^^^^^^^^^省级监测技术机构评价意见（可另附附页）：^国家监测技术机构评价意见（可另附附页）：^^60^63^^^2016-04-19^15:36:42^^3","^60^63^126^^^^3")
ClassMethod saveMataReport(matadrID As %String, matadrDataList As %String, matadrRepAuditList As %String, flag As %String) As %String
{
	N (matadrID,matadrDataList,matadrRepAuditList,flag)
	S ret=0
	I matadrID="" D
	.S ret=..Insert(matadrDataList,matadrRepAuditList,flag)
	E  D
	.S ret=..Update(matadrID,matadrDataList,matadrRepAuditList,flag)
	Q ret
}

/// Description: 删除  器械报告表  
/// Creator:     CongYue
/// CreateDate:  2015-09-24
/// Table: 		 DHC_MatAdrReport
/// Input:  	 报告表id 
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPORT).DelMataReport("")
ClassMethod DelMataReport(params As %String) As %String
{
	N (params)
	S matadrID=$p(params,"^",1)
	S UserID=$p(params,"^",2)
	
	S repUser=$p(^DHCMATADRR(matadrID),"^",35)    //填报人工号
	S repCurStatDR=$p(^DHCMATADRR(matadrID),"^",41)    //当前状态
	
	S repUserID=""
	I repUser'=""  d
	.S repUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(repUser),""))
	S reportType=$p(^DHCMATADRR(matadrID),"^",46)   //报告类型
	S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",reportType,matadrID,""))
	S MedadrReceive=""
	I MedadrID'=""  S MedadrReceive=$p(^DHCMEDREPADT(MedadrID),"^",9)
	Q:UserID'=repUserID -1
	Q:repCurStatDR'="" -2
	;Q:MedadrReceive="2" -3
	
	&SQL(DELETE DHC_MatAdrReport WHERE MATADR_RowID=:matadrID)
	Q SQLCODE
}

/// Description:保存医疗器械不良反应报表
/// Creator:	 CongYue
/// CreateDate:  2015-09-23
/// Table: 		 DHC_MatAdrReport
/// Input:  	 报告表数据 , matadrRepAuditList:以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return： 	 "0^"_matadrID:保存成功标志^报告表id
ClassMethod Insert(matadrDataList As %String, matadrRepAuditList As %String, flag As %String) As %String
{
	N (matadrDataList,matadrRepAuditList,flag)
	S Err=0
	TS
	S matadrID=..InsMataReport(matadrDataList)
	I matadrID<0 tro
	Q:matadrID<0 matadrID
	
	
	//更新状态
	S adtList=matadrID_"^"_$p(matadrRepAuditList,"^",8)_"^"_$p(matadrRepAuditList,"^",2)_"^"_$p(matadrRepAuditList,"^",3)_"^"_$p(matadrRepAuditList,"^",4)
    S nextStatuDr=""
	I flag="1" D
	.S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(adtList)
	I (flag="1")&(+nextStatuDr'>0) tro
	Q:(flag="1")&(+nextStatuDr'>0) nextStatuDr
	
	I flag="1" D
	.&sql(update DHC_MatAdrReport set MATADR_CurStatus_DR=:nextStatuDr where MATADR_RowID=:matadrID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 s Err="-16"
	
	Q:Err'=0 "-16"
	
	S matadrRepAuditList=nextStatuDr_"^"_$p(matadrRepAuditList,"^",2,8)
	
	
	//不良反应报告审批流程[默认插入初始状态]
	I matadrRepAuditList'="" D
	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(matadrID,matadrRepAuditList)
	I Err'=0 tro
	Q:Err'=0 "-17"

	TC
	Q "0^"_matadrID
}

/// Description:保存医疗器械不良反应报表
/// Creator:	 CongYue
/// CreateDate:  2015-09-23
/// Table: 		 DHC_MatAdrReport
/// Input:  	 报告表id,报告表数据 , matadrRepAuditList:以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return： 	 "0^"_matadrID:保存成功标志^报告表id
ClassMethod Update(matadrID As %String, matadrDataList As %String, matadrRepAuditList As %String, flag As %String) As %String
{
	N (matadrID,matadrDataList,matadrRepAuditList,flag)
	S Err=0
	S RepStatus=$p(^DHCMATADRR(matadrID),"^",41)    //当前状态
	TS
	S matadrID=..UpdMataReport(matadrID,matadrDataList)
	I matadrID<0 tro
	Q:matadrID<0 matadrID
	
	
	//更新状态
	S adtList=matadrID_"^"_$p(matadrRepAuditList,"^",8)_"^"_$p(matadrRepAuditList,"^",2)_"^"_$p(matadrRepAuditList,"^",3)_"^"_$p(matadrRepAuditList,"^",4)
    S nextStatuDr=""
	I flag="1" D
	.S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(adtList)
	
	I (flag="1")&(+nextStatuDr'>0) tro
	Q:(flag="1")&(+nextStatuDr'>0) nextStatuDr
	
	I flag="1" D
	.&sql(update DHC_MatAdrReport set MATADR_CurStatus_DR=:nextStatuDr where MATADR_RowID=:matadrID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 s Err="-16"
	
	Q:Err'=0 "-16"
	
	S:flag="1" matadrRepAuditList=nextStatuDr_"^"_$p(matadrRepAuditList,"^",2,8)
	S:flag="0" matadrRepAuditList=RepStatus_"^"_$p(matadrRepAuditList,"^",2,8)
	
	//不良反应报告审批流程[默认插入初始状态]
	I matadrRepAuditList'="" D
	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(matadrID,matadrRepAuditList)
	I Err'=0 tro
	Q:Err'=0 "-17"
	
	TC
	
	Q "0^"_matadrID
}

/// Description: 获取医疗器械报告信息  
/// Creator:     CongYue
/// CreateDate:  2015-10-14
/// Table: 		 DHC_MatAdrReport
/// Input: 		 报告表id , params:以字符"^"分割,格式为:人员id^科室id^安全组id^报告类型代码
/// Return： 	 报告表数据
/// Others:		 w ##class(web.DHCADVMEDREPORT).getMataRepInfo("119","600^63^126^material")
ClassMethod getMataRepInfo(matadrID As %String, params As %String) As %String
{
	N (matadrID, params)
	Q:'$d(^DHCMATADRR(matadrID)) ""
	S matadrNo=$p(^DHCMATADRR(matadrID),"^",1)   //编号
	
	S matadrCreateDateResult=$p(^DHCMATADRR(matadrID),"^",39)    //报告 日期
	S:matadrCreateDateResult'="" matadrCreateDateResult=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrCreateDateResult)    ;$zd(matadrCreateDateResult,3)
	S matadrCreateTimeResult=$p(^DHCMATADRR(matadrID),"^",40)    //报告 时间
	S:matadrCreateTimeResult'="" matadrCreateTimeResult=$zt(matadrCreateTimeResult,1)
	
	
	S matadrSex=$p(^DHCMATADRR(matadrID),"^",2)      //性别
	S matadrAge=$p(^DHCMATADRR(matadrID),"^",3)     //年龄
	S matadrName=$p(^DHCMATADRR(matadrID),"^",4)     //姓名
	S matadrPatNo=$p(^DHCMATADRR(matadrID),"^",5)   //登记号
	S matadrAdmDateResult=$p(^DHCMATADRR(matadrID),"^",6)    //诊疗 日期
	S:matadrAdmDateResult'="" matadrAdmDateResult=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrAdmDateResult)
	S matadrAdmTimeResult=$p(^DHCMATADRR(matadrID),"^",7)    //诊疗 时间
	S:matadrAdmTimeResult'="" matadrAdmTimeResult=$zt(matadrAdmTimeResult,1)

	S matadrMainExp=$p(^DHCMATADRR(matadrID),"^",8)     //事件主要表现
	S matadrAdrDate=$p(^DHCMATADRR(matadrID),"^",9) //事件发生日期
	S:matadrAdrDate'="" matadrAdrDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrAdrDate) ;$zd(matadrAdrDate,3)	
	S matadrDiscDate=$p(^DHCMATADRR(matadrID),"^",10) //事件发现时间
	S:matadrDiscDate'="" matadrDiscDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrDiscDate) ; $zd(matadrDiscDate,3)	
	S matadrUsePlace=$p(^DHCMATADRR(matadrID),"^",11)     //医疗器械实际使用场所
	S matadrUsePlaceOth=$p(^DHCMATADRR(matadrID),"^",12)     //医疗器械实际使用场所其他
	
	S matadrEventDesc=$p(^DHCMATADRR(matadrID),"^",13)     //事件陈述
	S matadrProName=$p(^DHCMATADRR(matadrID),"^",14)     //产品名称
	S matadrInciName=$p(^DHCMATADRR(matadrID),"^",15) //商品名称
	S matadrRegNo=$p(^DHCMATADRR(matadrID),"^",16) //注册证号
	S matadrManf=$p(^DHCMATADRR(matadrID),"^",17)     //生产企业名称
	S matadrManfAddress=$p(^DHCMATADRR(matadrID),"^",18)     //生产企业地址
	S matadrManfTel=$p(^DHCMATADRR(matadrID),"^",19) //企业联系电话
	S matadrSpec=$p(^DHCMATADRR(matadrID),"^",20)    //型号规格
	S matadrProCode=$p(^DHCMATADRR(matadrID),"^",21)   //产品编号	
	S matadrProBatNo=$p(^DHCMATADRR(matadrID),"^",22)    //产品批号
	S matadrOperator=$p(^DHCMATADRR(matadrID),"^",23)   //操作人
	S matadrOperatorOth=$p(^DHCMATADRR(matadrID),"^",24)     //操作人其他
	
	S matadrExpDate=$p(^DHCMATADRR(matadrID),"^",25) //有效期至
	S:matadrExpDate'="" matadrExpDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrExpDate)
	S matadrProDate=$p(^DHCMATADRR(matadrID),"^",26) //生产日期
	S:matadrProDate'="" matadrProDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrProDate)
	S matadrDisDate=$p(^DHCMATADRR(matadrID),"^",27) //停用日期
	S:matadrDisDate'="" matadrDisDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrDisDate)
	S matadrUseDate=$p(^DHCMATADRR(matadrID),"^",28) //植入日期
	S:matadrUseDate'="" matadrUseDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrUseDate)
	
	S matadrReasonDesc=$p(^DHCMATADRR(matadrID),"^",29) //事件发生初步原因分
	S matadrHandInfo=$p(^DHCMATADRR(matadrID),"^",30) //事件初步处理情况
	S matadrHandStatus=$p(^DHCMATADRR(matadrID),"^",31) //事件报告状态
	S matadrProAdvice=$p(^DHCMATADRR(matadrID),"^",32)   //省级监测技术机构评价意见
	S matadrCountryAdvice=$p(^DHCMATADRR(matadrID),"^",33)  //国家监测技术机构评价意见
	S matadrCarPrvTp=$p(^DHCMATADRR(matadrID),"^",34)   //报告人职称
	
	S matadrRepTel=$p(^DHCMATADRR(matadrID),"^",37)   //报告人联系电话
	S matadrRepEmail=$p(^DHCMATADRR(matadrID),"^",38) 	  //邮箱
	S matadrCurStatDR=$p(^DHCMATADRR(matadrID),"^",41)    //当前状态
	S matadrExpectEff=$p(^DHCMATADRR(matadrID),"^",42)    //预期治疗疾病或作用
	S matadrResult=$p(^DHCMATADRR(matadrID),"^",43)    //事件后果
	S matadrDeathDate=$p(^DHCMATADRR(matadrID),"^",44)    //死亡 日期
	S:matadrDeathDate'="" matadrDeathDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrDeathDate)
	S matadrDeathTime=$p(^DHCMATADRR(matadrID),"^",45)    //死亡 时间
	S:matadrDeathTime'="" matadrDeathTime=$zt(matadrDeathTime,1)
		
	S matadrRepLocCode=$p(^DHCMATADRR(matadrID),"^",36) //科室代码
	S matadrRepLocDr=""
	S matadrRepLocDesc=""
	I matadrRepLocCode'=""  d
	.S matadrRepLocDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(matadrRepLocCode),""))
	.S matadrRepLocDesc=$p(^CTLOC(matadrRepLocDr),"^",2)
	
	S matadrRepUserCode=$p(^DHCMATADRR(matadrID),"^",35)    //填报人工号
	S matadrRepUserDr=""
	S matadrRepName=""
	I matadrRepUserCode'=""  d
	.S matadrRepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(matadrRepUserCode),""))
	.S matadrRepName=$p(^SSU("SSUSR",matadrRepUserDr),"^",2)
	

	S mataReportType=$p(^DHCMATADRR(matadrID),"^",46)   //报告类型
	S mataRepImpFlag=$p(^DHCMATADRR(matadrID),"^",47)   //重要标记
	S matadrAdmNo=$p(^DHCMATADRR(matadrID),"^",48)   //就诊ID
	S medadrAuditID=$o(^DHCMEDREPADT(0,"Pointer",mataReportType,matadrID,""),-1)
	I medadrAuditID=""  D
	.S medadrNextLoc=""
	.S medadrLocAdvice=""
	.S medadrReceive=""
	E  D
	.S medadrNextLoc=$p(^DHCMEDREPADT(medadrAuditID),"^",7)
	.S medadrLocAdvice=$p(^DHCMEDREPADT(medadrAuditID),"^",8)
	.S medadrReceive=$p(^DHCMEDREPADT(medadrAuditID),"^",9)
	
	S List=##class(web.DHCADVCOMMON).GetStatusDr(params)
	S MatadrInitStatDR=$p(List,"^",2)       //初始状态
	
	S matadrIfReaOrder=$p(^DHCMATADRR(matadrID),"^",49)  // 是否具有合理的先后顺序
	S matadrIfDamageType=$p(^DHCMATADRR(matadrID),"^",50)  // 是否属于所使用医疗器械可能导致的伤害类型
	S matadrIfReasonable=$p(^DHCMATADRR(matadrID),"^",51)  // 是否可以用合并用药的作用、患者病情或其他非医疗器械因素来解释
	S matadrRelEvaluation=$p(^DHCMATADRR(matadrID),"^",52)  // 关联性评价结果

	S matadrDataList=matadrID_"!"_matadrNo_"!"_matadrSex_"!"_matadrAge_"!"_matadrName_"!"_matadrPatNo_"!"_matadrExpectEff
	S matadrDataList=matadrDataList_"!"_matadrAdmDateResult_"!"_matadrAdmTimeResult_"!"_matadrMainExp_"!"_matadrAdrDate
	S matadrDataList=matadrDataList_"!"_matadrDiscDate_"!"_matadrUsePlace_"!"_matadrUsePlaceOth_"!"_matadrResult_"!"_matadrDeathDate
	S matadrDataList=matadrDataList_"!"_matadrDeathTime_"!"_matadrEventDesc_"!"_matadrProName_"!"_matadrInciName_"!"_matadrRegNo
	S matadrDataList=matadrDataList_"!"_matadrManf_"!"_matadrManfAddress_"!"_matadrManfTel_"!"_matadrSpec_"!"_matadrProCode
	S matadrDataList=matadrDataList_"!"_matadrProBatNo_"!"_matadrOperator_"!"_matadrOperatorOth_"!"_matadrExpDate_"!"_matadrProDate
	S matadrDataList=matadrDataList_"!"_matadrDisDate_"!"_matadrUseDate_"!"_matadrReasonDesc_"!"_matadrHandInfo_"!"_matadrHandStatus
	S matadrDataList=matadrDataList_"!"_matadrProAdvice_"!"_matadrCountryAdvice_"!"_matadrCarPrvTp_"!"_matadrRepUserDr_"!"_matadrRepLocDr_"!"_matadrRepTel
	S matadrDataList=matadrDataList_"!"_matadrRepEmail_"!"_matadrCreateDateResult_"!"_matadrCreateTimeResult_"!"_MatadrInitStatDR
	S matadrDataList=matadrDataList_"!"_matadrCurStatDR_"!"_matadrRepLocDesc_"!"_matadrRepName_"!"_mataReportType
	S matadrDataList=matadrDataList_"!"_medadrNextLoc_"!"_medadrLocAdvice_"!"_medadrReceive_"!"_mataRepImpFlag_"!"_matadrAdmNo
	S matadrDataList=matadrDataList_"!"_matadrIfReaOrder_"!"_matadrIfDamageType_"!"_matadrIfReasonable_"!"_matadrRelEvaluation //新增 判断内容
 Q matadrDataList
}

/// Description:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	K ^TMP("DHCST","web.DHCADVMEDREPORT","QueryMataEvent",pid)
	K ^TMP("DHCST","web.DHCADVMEDREPORT","QueryEventType",pid)
	K ^TMP("DHCST","web.DHCADVMEDREPORT","QueryMataEventType",pid)
	K ^TMP("DHCST","web.DHCADVMEDREPORT","QueryMataReport",pid)
	K ^TMP("DHCST","web.DHCADVMEDREPORT","QueryAdrEvtworkFlow",pid)
	K ^TMP("DHCST","web.DHCADVMEDREPORT","QueryEventWorkFlowItm",pid)
	K ^TMP("DHCST","web.DHCADVMEDREPORT","QueryEventWorkFlowGrant",pid)
	K ^TMP("DHCST","web.DHCADVMEDREPORT","InsMataRepAudit",pid)
}

/// Description: 获取页面默认信息（日期，编码） 
/// Creator:     CongYue
/// CreateDate:  2015-10-10
/// Input: 		 params : 以字符"^"分割,格式为:人员id^科室id^安全组id^报告类型代码
/// Return: 	 页面默认信息: 以字符"^"分割,格式为:报告编码^报告日期^报告初始状态^报告类型^科室描述
/// Others:		 w ##class(web.DHCADVMEDREPORT).getMataInfo()
ClassMethod getMataInfo(params As %String) As %String
{
	N (params)
	S repdate=$zdt($H,3)
	S Prefix="MATADR"_$zd(+$H,8)  //报告编码规则 "MATADR"+年月日+顺序号
	S mataReportNo=..GetAdrReportCurMaxNo(Prefix,"3")	
	S List=##class(web.DHCADVCOMMON).GetStatusDr(params)
	Q:List="" -1
	S mataReportType=$p(List,"^",1)  //报告类型
	S matadrInitStatDR=$p(List,"^",2)  //审核状态
	
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
	Q repdate_"^"_matadrInitStatDR_"^"_mataReportType_"^"_mataReportNo_"^"_UserID_"^"_UserName_"^"_LocID_"^"_$g(LocDesc)_"^"_CreatorCareProv
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
/// Input:  	 报告编码规则,编码数字长度
/// Return:  	 当前不良反应报告最大码  
ClassMethod GetMaxCodeByCode(Prefix As %String) As %String
{
	N (Prefix)
	Q:Prefix="" ""
	S matacode=""
	&sql(select max(MATADR_No) into matacode from DHC_MatAdrReport Where MATADR_No %STARTSWITH %ALPHAUP :Prefix)
	Q matacode
}

/// Description: 查询 [检查项目名称] 
/// Creator:     CongYue
/// CreateDate:  2015-10-12
/// Table:		 DHC_MedAdrLabItem
/// Input:  	 params :以字符"^"分割,格式为:代码^描述
/// Output:		 检查项目名称数据
/// Others:		 w ##class(web.DHCADVMEDREPORT).QueryMataEvent("50","1","")
ClassMethod QueryMataEvent(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S End = page*rows
	S Start=(page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    S maItemCode=$p(params,"^",1)
    S maItemDesc=$p(params,"^",2)
	S h=0,count=0
	S MataID="0"
	F  S MataID=$o(^DHCMEDADRLI(MataID)) Q:MataID=""  D
	.S ItemCode=$p(^DHCMEDADRLI(MataID),"^",1) //代码
	.S ItemDesc=$p(^DHCMEDADRLI(MataID),"^",2) //描述
	.S ItemVal=$p(^DHCMEDADRLI(MataID),"^",3) //数据
	.S ItemUomDr=$p(^DHCMEDADRLI(MataID),"^",4) //单位dr
	.S ItemUom=$p(^CT("UOM",ItemUomDr),"^",2) //单位描述
	.S ItemActiveFlag=$p(^DHCMEDADRLI(MataID),"^",5) //标志
	.S TypeDr=$p(^DHCMEDADRLI(MataID),"^",6) //类别
	.S Type=$p(^DHCMEDADRLTP(TypeDr),"^",2) //类别描述
	.Q:(maItemCode'="")&(ItemCode'[maItemCode)
	.Q:(maItemDesc'="")&(ItemDesc'[maItemDesc)
	.S h=h+1
	.S TempStr=MataID_"^"_ItemCode_"^"_ItemDesc_"^"_ItemVal_"^"_ItemUom_"^"_ItemActiveFlag_"^"_Type
	.S ^TMP("DHCST","web.DHCADVMEDREPORT","QueryMataEvent",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="MataID^ItemCode^ItemDesc^ItemVal^ItemUom^ItemActiveFlag^Type"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCADVMEDREPORT","QueryMataEvent",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCST","web.DHCADVMEDREPORT","QueryMataEvent",pid,index))
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

/// Description: 保存[检查项目名称] 
/// Creator:     CongYue
/// CreateDate:  2015-10-12
/// Table:	     DHC_MedAdrLabItem
/// Input:  	 DataList:以字符"^"分割,格式为: id^代码^描述^数据^单位dr^标志^类别
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPORT).SaveMaEvent("^RBC^红细胞^10^桶^Y^血常规")
ClassMethod SaveMaEvent(DataList As %String) As %String
{
	N (DataList)
	S len=$L(DataList,"||")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"||",i)
	.I $p(TmpStr,"^",1)'="" D
	..S ret=..UpdMataEvent(TmpStr)
	.E  D
	..S ret=..InsMataEvent(TmpStr)
	Q 0
}

/// Description: 修改[检查项目名称]
/// Creator:     CongYue
/// CreateDate:  2015-10-12
/// Table:		 DHC_MedAdrLabItem
/// Input:  	 DataList: 以字符"^"分割,格式为: id^代码^描述^数据^单位desc^标志^类别
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPORT).UpdMataEvent("47^RBC^红细胞^10^桶^Y^血常规")
ClassMethod UpdMataEvent(DataList As %String) As %String
{
	N (DataList)
	S MataID=$p(DataList,"^",1)
	S MaItemCode=$p(DataList,"^",2)
	S MaItemDesc=$p(DataList,"^",3)
	S MaItemVal=$p(DataList,"^",4)
	S MaItemUomDesc=$p(DataList,"^",5)
	S MaItemUomDr=$o(^CT("UOM",0,"Desc",MaItemUomDesc,""))
	S MaItemActiveFlag=$p(DataList,"^",6)
	S MaTypeDesc=$p(DataList,"^",7)
	S MaTypeDr=$o(^DHCMEDADRLTP(0,"Desc",MaTypeDesc,""))
	&SQL(Update DHC_MedAdrLabItem Set MADRLI_ItemCode=:MaItemCode,MADRLI_ItemDesc=:MaItemDesc,MADRLI_ItemVal=:MaItemVal,MADRLI_ItemUom=:MaItemUomDr,MADRLI_ItemActiveFlag=:MaItemActiveFlag,MADRLI_Type=:MaTypeDr WHERE MADRLI_RowID=:MataID)
 	Q SQLCODE
}

/// Description: 增加[检查项目名称]
/// Creator:     CongYue
/// CreateDate:  2015-10-12
/// Table:		 DHC_MedAdrLabItem
/// Input:  	 DataList:以字符"^"分割,格式为: id^代码^描述^数据^单位desc^标志^类别
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPORT).InsMataEvent("^RBC^红细胞^10^桶^Y^血常规")
ClassMethod InsMataEvent(DataList As %String) As %String
{
	N (DataList)
	S MaItemCode=$p(DataList,"^",2)
	S MaItemDesc=$p(DataList,"^",3)
	S MaItemVal=$p(DataList,"^",4)
	S MaItemUomDesc=$p(DataList,"^",5)
	S MaItemUomDr=$o(^CT("UOM",0,"Desc",MaItemUomDesc,""))
	S MaItemActiveFlag=$p(DataList,"^",6)
	S MaTypeDesc=$p(DataList,"^",7)
	S MaTypeDr=$o(^DHCMEDADRLTP(0,"Desc",MaTypeDesc,""))
 	&SQL(INSERT INTO DHC_MedAdrLabItem(MADRLI_ItemCode,MADRLI_ItemDesc,MADRLI_ItemVal,MADRLI_ItemUom,MADRLI_ItemActiveFlag,MADRLI_Type) VALUES(:MaItemCode,:MaItemDesc,:MaItemVal,:MaItemUomDr,:MaItemActiveFlag,:MaTypeDr))
 	Q SQLCODE
}

/// Description: 删除[检查项目名称]
/// Creator:     CongYue
/// CreateDate:  2015-10-12
/// Table:		 DHC_MedAdrLabItem
/// Input:  	 检查项目名称数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPORT).DelMaEvent("1")
ClassMethod DelMaEvent(MataID As %String) As %String
{
	N (MataID)
	&SQL(Delete From DHC_MedAdrLabItem WHERE MADRLI_RowID=:MataID)
	Q SQLCODE
}

/// Description: 保存[小界面检查项目名称]
/// Creator:     CongYue
/// CreateDate:  2015-10-16
/// Table:		 DHC_MedAdrLabItem
/// Input:  	 DataList:以字符"^"分割,格式为: id^代码^描述^数据^单位desc^标志^类别dr
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPORT).SaveEvent("^RBC^红细胞^10^个^Y^40")
ClassMethod SaveEvent(DataList As %String) As %String
{
	N (DataList)
	S len=$L(DataList,"||")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"||",i)
	.I $p(TmpStr,"^",1)'="" D
	..S ret=..UpdateEvent(TmpStr)
	
	Q 0
}

/// Description: 修改[小界面检查项目名称]
/// Creator:     CongYue
/// CreateDate:  2015-10-16
/// Table:		 DHC_MedAdrLabItem
/// Input:  	 DataList:以字符"^"分割,格式为: id^代码^描述^数据^单位desc^标志^类别dr
/// return: 	 保存成功 0，保存失败1
/// Others:		 w ##class(web.DHCADVMEDREPORT).UpdateEvent("47^RBC^红细胞^10^个^Y^40")
ClassMethod UpdateEvent(DataList As %String) As %String
{
	N (DataList)
	S MataID=$p(DataList,"^",1)
	S MaItemCode=$p(DataList,"^",2)
	S MaItemDesc=$p(DataList,"^",3)
	S MaItemVal=$p(DataList,"^",4)
	S MaItemUomDesc=$p(DataList,"^",5)
	S MaItemUomDr=$o(^CT("UOM",0,"Desc",MaItemUomDesc,""))
	S MaItemActiveFlag=$p(DataList,"^",6)
	S MaType=$p(DataList,"^",7)
	;S MaTypeDr=$o(^DHCMEDADRLTP(0,"Desc",MaTypeDesc,""))
	&SQL(Update DHC_MedAdrLabItem Set MADRLI_ItemCode=:MaItemCode,MADRLI_ItemDesc=:MaItemDesc,MADRLI_ItemVal=:MaItemVal,MADRLI_ItemUom=:MaItemUomDr,MADRLI_ItemActiveFlag=:MaItemActiveFlag,MADRLI_Type=:MaType WHERE MADRLI_RowID=:MataID)
 	Q SQLCODE
}

/// Description: 单位
/// Creator:     CongYue
/// Table:		 CT_UOM
/// Output:  	 单位描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVMEDREPORT).SelUom()
ClassMethod SelUom() As %String
{
	S result = ##class(%Library.ResultSet).%New()
	S sqlStr = "SELECT CTUOM_RowId as UomDr,CTUOM_Desc as UomDesc FROM CT_UOM"
    D result.Prepare(sqlStr)
	D result.Execute()
	s count = 0
	W "["
	While(result.Next())
	{	
		S UomDr = result.Data("UomDr")
		S UomDesc = result.Data("UomDesc")
		S:UomDesc["-" UomDesc=$p(UomDesc,"-",2)
		S tmp=UomDr_"^"_UomDesc
		S count = count+1
		I count=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	}
	W "]"
}

/// Description: 类别
/// Creator:     CongYue
/// Table:		 DHC_MedAdrLabType
/// Output:  	 类别描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVMEDREPORT).SelType()
ClassMethod SelType() As %String
{
	S result = ##class(%Library.ResultSet).%New()
	S sqlStr = "SELECT MADRLT_RowID as TypeDr,MADRLT_Desc as TypeDesc FROM DHC_MedAdrLabType"
    D result.Prepare(sqlStr)
	D result.Execute()
	S count = 0
	W "["
	While(result.Next())
	{	
		S TypeDr = result.Data("TypeDr")
		S TypeDesc = result.Data("TypeDesc")
		S:TypeDesc["-" TypeDesc=$p(TypeDesc,"-",2)
		S tmp=TypeDr_"^"_TypeDesc
		S count = count+1
		I count=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Description: 查询[检查项目类型名称]
/// Creator:     CongYue
/// CreateDate:  2015-10-20
/// Table:		 DHC_MedAdrLabType
/// Input:  	 params:检查项目代码^检查项目描述
/// Others:		 w ##class(web.DHCADVMEDREPORT).QueryEventType("5","1","")
ClassMethod QueryEventType(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S End = page*rows
	S Start=(page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    S typeCode=$p(params,"^",1)
    S typeDesc=$p(params,"^",2)
	S h=0,count=0
	S ID="0"
	F  S ID=$o(^DHCMEDADRLTP(ID)) Q:ID=""  D
	.S Code=$p(^DHCMEDADRLTP(ID),"^",1) //代码
	.S Desc=$p(^DHCMEDADRLTP(ID),"^",2) //描述
	.Q:(typeCode'="")&(Code'[typeCode)
	.Q:(typeDesc'="")&(Desc'[typeDesc)
	.S h=h+1
	.S TempStr=ID_"^"_Code_"^"_Desc
	.S ^TMP("DHCST","web.DHCADVMEDREPORT","QueryEventType",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCADVMEDREPORT","QueryEventType",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCST","web.DHCADVMEDREPORT","QueryEventType",pid,index))
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

/// Description: 保存[检查项目类型名称]
/// Creator:     CongYue
/// CreateDate:  2015-10-20
/// Table:		 DHC_MedAdrLabType
/// Input:   	 DataList:以字符"^"分割,格式为：id^代码^描述
/// Return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPORT).SaveEventType("^BC^血常规")
ClassMethod SaveEventType(DataList As %String) As %String
{
	N (DataList)
	S len=$L(DataList,"||")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"||",i)
	.I $p(TmpStr,"^",1)'="" D
	..S ret=..UpdEventType(TmpStr)
	.E  D
	..S ret=..InsEventType(TmpStr)
	Q 0
}

/// Description: 更新[检查项目类型名称]
/// Creator:     CongYue
/// CreateDate:  2015-10-20
/// Table:		 DHC_MedAdrLabType
/// Input:   	 DataList:以字符"^"分割,格式为：id^代码^描述
/// Return:  	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPORT).UpdEventType("1^BC^血常规")
ClassMethod UpdEventType(DataList As %String) As %String
{
	N (DataList)
	S ID=$p(DataList,"^",1)
	S Code=$p(DataList,"^",2)
	S Desc=$p(DataList,"^",3)
	
	&SQL(Update DHC_MedAdrLabType Set MADRLT_Code=:Code,MADRLT_Desc=:Desc WHERE MADRLT_RowID=:ID)
 	Q SQLCODE
}

/// Description: 增加[检查项目类型名称]
/// Creator:     CongYue
/// CreateDate:  2015-10-20
/// Table:		 DHC_MedAdrLabType
/// Input:   	 DataList:以字符"^"分割,格式为：id^代码^描述
/// Return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPORT).InsEventType("^BC^血常规")
ClassMethod InsEventType(DataList As %String) As %String
{
	N (DataList)
	S Code=$p(DataList,"^",2)
	S Desc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_MedAdrLabType(MADRLT_Code,MADRLT_Desc) VALUES(:Code,:Desc))
 	Q SQLCODE
}

/// Description: 删除[检查项目类型名称]
/// Creator:     CongYue
/// CreateDate:  2015-10-20
/// Table:		 DHC_MedAdrLabType
/// Input:  	 检查项目类型名称id
/// Return: 	 删除成功 0，删除失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPORT).DelEventType("1")
ClassMethod DelEventType(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MedAdrLabType WHERE MADRLT_RowID=:ID)
	Q SQLCODE
}

/// Description: 查询[检查项目名称按类别]
/// Creator:     CongYue
/// CreateDate:  2015-10-26
/// Table:		 DHC_MedAdrLabItem
/// Input:  	 params:检查项目类别描述
/// Others:		 w ##class(web.DHCADVMEDREPORT).QueryMataEventType("20","1","血常规")
ClassMethod QueryMataEventType(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S End = page*rows
	S Start=(page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    S TypeDesc=$p(params,"^",1)
    S TypeDr=$o(^DHCMEDADRLTP(0,"Desc",TypeDesc,""))
    S MataID=$o(^DHCMEDADRLI(0,"Type",TypeDr,""))
    S MataID=MataID-1
	S h=0,count=0
	F  S MataID=$o(^DHCMEDADRLI(MataID)) Q:MataID=""  D
	.S ItemCode=$p(^DHCMEDADRLI(MataID),"^",1) //代码
	.S ItemDesc=$p(^DHCMEDADRLI(MataID),"^",2) //描述
	.S ItemVal=$p(^DHCMEDADRLI(MataID),"^",3) //数据
	.S ItemUomDr=$p(^DHCMEDADRLI(MataID),"^",4) //单位dr
	.S ItemUom=$p(^CT("UOM",ItemUomDr),"^",2) //单位描述
	.S ItemActiveFlag=$p(^DHCMEDADRLI(MataID),"^",5) //标志
	.S Type=$p(^DHCMEDADRLI(MataID),"^",6)
	.Q:(Type'="")&(TypeDr'[Type)
	.S h=h+1
	.S TempStr=MataID_"^"_ItemCode_"^"_ItemDesc_"^"_ItemVal_"^"_ItemUom_"^"_ItemActiveFlag_"^"_Type
	.S ^TMP("DHCST","web.DHCADVMEDREPORT","QueryMataEventType",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="MataID^ItemCode^ItemDesc^ItemVal^ItemUom^ItemActiveFlag^Type"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCADVMEDREPORT","QueryMataEventType",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCST","web.DHCADVMEDREPORT","QueryMataEventType",pid,index))
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

/// Description: 获取报告信息(打印/导出)
/// Creator:     CongYue
/// CreateDate:  2015-11-20
/// Input:  	 报告id
/// Return: 	 matadrDataList:报告表数据
/// Others:		 w ##class(web.DHCADVMEDREPORT).getMataRepExportInfo("42")
ClassMethod getMataRepExportInfo(matadrID As %String) As %String
{
	N (matadrID)
	Q:'$d(^DHCMATADRR(matadrID)) ""
	S matadrNo=$p(^DHCMATADRR(matadrID),"^",1)   //编号
	S matadrSex=$p(^DHCMATADRR(matadrID),"^",2)      //性别
	S:matadrSex'="" matadrSex=$p(^CT("SEX",matadrSex),"^",2)
	S matadrAge=$p(^DHCMATADRR(matadrID),"^",3)     //年龄
	S matadrName=$p(^DHCMATADRR(matadrID),"^",4)     //姓名
	S matadrPatNo=$p(^DHCMATADRR(matadrID),"^",5)   //登记号	
	S matadrAdmDateResult=$p(^DHCMATADRR(matadrID),"^",6)    //诊疗 日期
	S:matadrAdmDateResult'="" matadrAdmDateResult=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrAdmDateResult)
	S matadrAdmTimeResult=$p(^DHCMATADRR(matadrID),"^",7)    //诊疗 时间
	S:matadrAdmTimeResult'="" matadrAdmTimeResult=$zt(matadrAdmTimeResult,1)

	S matadrMainExp=$p(^DHCMATADRR(matadrID),"^",8)     //事件主要表现
	S matadrAdrDate=$p(^DHCMATADRR(matadrID),"^",9) //事件发生日期
	S:matadrAdrDate'="" matadrAdrDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrAdrDate)	
	S matadrDiscDate=$p(^DHCMATADRR(matadrID),"^",10) //事件发现时间
	S:matadrDiscDate'="" matadrDiscDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrDiscDate)	
	S matadrUsePlace=$p(^DHCMATADRR(matadrID),"^",11)     //医疗器械实际使用场所
	S matadrUsePlace=$S(matadrUsePlace="10":"医疗机构",matadrUsePlace="11":"家庭",1:"")
	S matadrUsePlaceOth=$p(^DHCMATADRR(matadrID),"^",12)     //医疗器械实际使用场所其他描述
	
	S matadrEventDesc=$p(^DHCMATADRR(matadrID),"^",13)     //事件陈述
	S matadrProName=$p(^DHCMATADRR(matadrID),"^",14)     //产品名称
	S matadrInciName=$p(^DHCMATADRR(matadrID),"^",15) //商品名称
	S matadrRegNo=$p(^DHCMATADRR(matadrID),"^",16) //注册证号
	S matadrManf=$p(^DHCMATADRR(matadrID),"^",17)     //生产企业名称
	S matadrManfAddress=$p(^DHCMATADRR(matadrID),"^",18)     //生产企业地址
	S matadrManfTel=$p(^DHCMATADRR(matadrID),"^",19) //企业联系电话
	S matadrSpec=$p(^DHCMATADRR(matadrID),"^",20)    //型号规格
	S matadrProCode=$p(^DHCMATADRR(matadrID),"^",21)   //产品编号	
	S matadrProBatNo=$p(^DHCMATADRR(matadrID),"^",22)    //产品批号
	S matadrOperator=$p(^DHCMATADRR(matadrID),"^",23)   //操作人
	S matadrOperator=$S(matadrOperator="10":"专业人员",matadrOperator="11":"非专业人员",matadrOperator="12":"患者",1:"")
	S matadrOperatorOth=$p(^DHCMATADRR(matadrID),"^",24)     //操作人其他描述
	
	S matadrExpDate=$p(^DHCMATADRR(matadrID),"^",25) //有效期至
	S:matadrExpDate'="" matadrExpDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrExpDate)
	S matadrProDate=$p(^DHCMATADRR(matadrID),"^",26) //生产日期
	S:matadrProDate'="" matadrProDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrProDate)
	S matadrDisDate=$p(^DHCMATADRR(matadrID),"^",27) //停用日期
	S:matadrDisDate'="" matadrDisDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrDisDate)
	S matadrUseDate=$p(^DHCMATADRR(matadrID),"^",28) //植入日期
	S:matadrUseDate'="" matadrUseDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrUseDate)
		
	S matadrReasonDesc=$p(^DHCMATADRR(matadrID),"^",29) //事件发生初步原因分
	S matadrHandInfo=$p(^DHCMATADRR(matadrID),"^",30) //事件初步处理情况
	S matadrHandStatus=$p(^DHCMATADRR(matadrID),"^",31) //事件报告状态
	S matadrHandStatus=$S(matadrHandStatus="10":"已通知使用单位",matadrHandStatus="11":"已通知生产企业",matadrHandStatus="12":"已通知经营企业",matadrHandStatus="13":"已通知药监部门",1:"")
	S matadrProAdvice=$p(^DHCMATADRR(matadrID),"^",32)   //省级监测技术机构评价意见
	S matadrCountryAdvice=$p(^DHCMATADRR(matadrID),"^",33)  //国家监测技术机构评价意见
	S matadrCarPrvTp=$p(^DHCMATADRR(matadrID),"^",34)   //报告人职称
	S matadrCarPrvTp=$S(matadrCarPrvTp="10":"医师",matadrCarPrvTp="11":"技师",matadrCarPrvTp="12":"护士",matadrCarPrvTp="99":"其他",1:"")
	
	S matadrRepTel=$p(^DHCMATADRR(matadrID),"^",37)   //报告人联系电话
	S matadrRepEmail=$p(^DHCMATADRR(matadrID),"^",38) 	  //邮箱
	S matadrCreateDateResult=$p(^DHCMATADRR(matadrID),"^",39)    //报告 日期
	S:matadrCreateDateResult'="" matadrCreateDateResult=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrCreateDateResult)
	S matadrCreateTimeResult=$p(^DHCMATADRR(matadrID),"^",40)    //报告 时间
	S:matadrCreateTimeResult'="" matadrCreateTimeResult=$zt(matadrCreateTimeResult,1)
	S matadrCurStatDR=$p(^DHCMATADRR(matadrID),"^",41)    //当前状态
	S matadrExpectEff=$p(^DHCMATADRR(matadrID),"^",42)    //预期治疗疾病或作用
	S matadrResult=$p(^DHCMATADRR(matadrID),"^",43)    //事件后果
	S matadrResult=$S(matadrResult="10":"死亡",matadrResult="11":"危及生命",matadrResult="12":"机体功能结构永久性损伤",matadrResult="13":"可能导致机体功能机构永久性损伤",matadrResult="14":"需要内、外科治疗避免上述永久损伤",matadrResult="99":"其它（在事件陈述中说明）",1:"")
	S matadrDeathDate=$p(^DHCMATADRR(matadrID),"^",44)    //死亡 日期
	S:matadrDeathDate'="" matadrDeathDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(matadrDeathDate)
	S matadrDeathTime=$p(^DHCMATADRR(matadrID),"^",45)    //死亡 时间
	S:matadrDeathTime'="" matadrDeathTime=$zt(matadrDeathTime,1)
	S MatadrInitStatDR="" //初始状态

	S matadrRepLocCode=$p(^DHCMATADRR(matadrID),"^",36) //科室代码
	S LocID=""
	S LocDesc=""
	I matadrRepLocCode'=""  d
	.S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(matadrRepLocCode),""))
	.S LocDesc=$p(^CTLOC(LocID),"^",2)
	
	S matadrRepUserCode=$p(^DHCMATADRR(matadrID),"^",35)    //填报人工号
	S matadrRepNameID=""
	S matadrRepName=""
	I matadrRepUserCode'=""  d
	.S matadrRepNameID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(matadrRepUserCode),""))
	.S matadrRepName=$p(^SSU("SSUSR",matadrRepNameID),"^",2)
	
	S mataReportType=$p(^DHCMATADRR(matadrID),"^",46)   //报告类型
	
	S matadrIfReaOrder=$p(^DHCMATADRR(matadrID),"^",49)  // 是否具有合理的先后顺序
	S matadrIfReaOrder=$S(matadrIfReaOrder="0":"否",matadrIfReaOrder="1":"是",1:"")
	S matadrIfDamageType=$p(^DHCMATADRR(matadrID),"^",50)  // 是否属于所使用医疗器械可能导致的伤害类型
	S matadrIfDamageType=$S(matadrIfDamageType="0":"否",matadrIfDamageType="1":"是",matadrIfDamageType="99":"无法确定",1:"")
	S matadrIfReasonable=$p(^DHCMATADRR(matadrID),"^",51)  // 是否可以用合并用药的作用、患者病情或其他非医疗器械因素来解释
	S matadrIfReasonable=$S(matadrIfReasonable="0":"否",matadrIfReasonable="1":"是",matadrIfReasonable="99":"无法确定",1:"")
	S matadrRelEvaluation=$p(^DHCMATADRR(matadrID),"^",52)  // 关联性评价结果
	S matadrRelEvaluation=$S(matadrRelEvaluation="1":"很有可能",matadrRelEvaluation="2":"可能有关",matadrRelEvaluation="3":"可能无关",matadrRelEvaluation="99":"无法确定",1:"")
	
	S matadrDataList=matadrID_"&&"_matadrNo_"&&"_matadrSex_"&&"_matadrAge_"&&"_matadrName_"&&"_matadrPatNo_"&&"_matadrExpectEff
	S matadrDataList=matadrDataList_"&&"_matadrAdmDateResult_"&&"_matadrAdmTimeResult_"&&"_matadrMainExp_"&&"_matadrAdrDate
	S matadrDataList=matadrDataList_"&&"_matadrDiscDate_"&&"_matadrUsePlace_"&&"_matadrUsePlaceOth_"&&"_matadrResult_"&&"_matadrDeathDate
	S matadrDataList=matadrDataList_"&&"_matadrDeathTime_"&&"_matadrEventDesc_"&&"_matadrProName_"&&"_matadrInciName_"&&"_matadrRegNo
	S matadrDataList=matadrDataList_"&&"_matadrManf_"&&"_matadrManfAddress_"&&"_matadrManfTel_"&&"_matadrSpec_"&&"_matadrProCode
	S matadrDataList=matadrDataList_"&&"_matadrProBatNo_"&&"_matadrOperator_"&&"_matadrOperatorOth_"&&"_matadrExpDate_"&&"_matadrProDate
	S matadrDataList=matadrDataList_"&&"_matadrDisDate_"&&"_matadrUseDate_"&&"_matadrReasonDesc_"&&"_matadrHandInfo_"&&"_matadrHandStatus
	S matadrDataList=matadrDataList_"&&"_matadrProAdvice_"&&"_matadrCountryAdvice_"&&"_matadrCarPrvTp_"&&"_matadrRepName_"&&"_LocID_"&&"_LocDesc
	S matadrDataList=matadrDataList_"&&"_matadrRepTel_"&&"_matadrRepEmail_"&&"_matadrCreateDateResult_"&&"_matadrCreateTimeResult_"&&"_MatadrInitStatDR_"&&"_mataReportType //47
	S matadrDataList=matadrDataList_"&&"_matadrIfReaOrder_"&&"_matadrIfDamageType_"&&"_matadrIfReasonable_"&&"_matadrRelEvaluation //新增 判断内容
 Q matadrDataList
}

/// Description: 检查报告编码是否存在
/// Creator:     CongYue
/// CreateDate:  2016-05-04
/// Table:		 DHC_MatAdrReport
/// Input:  	 params :报告编码
/// Output:		 0 不存在  1 存在
/// Others:		 w ##class(web.DHCADVMEDREPORT).SearchRepNoRepet("MATADR20151211001")
ClassMethod SearchRepNoRepet(RepNo As %String) As %String
{
	N (RepNo)
	S flag=0
	I $d(^DHCMATADRR(0,"RepNo",RepNo)) D
	.S flag=1
	Q flag
}

}
