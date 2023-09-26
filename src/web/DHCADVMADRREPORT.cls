Import sqluser

Class web.DHCADVMADRREPORT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:  药物不良事件中的重要标记
/// Creator:     yangyongtao
/// CreateDate:  2016-4-27
/// Table: 		 DHC_AdvDrugReport
/// Input:  	 报告表数据
/// Return： 	 数据id
/// Others:		 w ##class(web.DHCADVMADRREPORT).InsImpReport("144","N")
ClassMethod InsImpReport(advdrID As %String, RepImpFlag As %String) As %String
{
	N (advdrID,RepImpFlag)
    I RepImpFlag="N" D
    .S RepImpFlag="Y"
    E  S RepImpFlag="N"  ;2016-10-17
    &SQL(Update DHC_AdvDrugReport Set ADVDR_RepImpFlag=:RepImpFlag Where ADVDR_RowID=:advdrID)	
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 添加 药物不良事件报告表
/// Creator:     yangyongtao
/// CreateDate:  2016-3-31
/// Table: 		 DHC_AdvDrugReport
/// Input:  	 报告表数据
/// Return： 	 数据id
/// Others:		 w ##class(web.DHCADVMADRREPORT).InsMadrReport("MATADR20160409010^10^10^^10^^1^0000000001^杜桑^2^^1991-05-28^^^^^000086^10,11,12,13,14,,^^^^^^^^^^^^^^^10^蒋荣猛^^^^^^^^63^^^蒋荣猛^^^^2^^2016-04-09^21:43:13^^Y")
ClassMethod InsMadrReport(DataList As %String) As %String
{
	N (DataList)
	S advdrRepCode=..GetAdrReportCurMaxNo("DRUGADV"_$zd(+$H,8),"3") //报告编号 $p(DataList,"^",1)
	//S advdrRepDate=+$H //报告日期
	S advdrPriority=$p(DataList,"^",2) //首次报告 报告优先级
	S advdrRepType=$p(DataList,"^",3)  //报告类型 
	s advdrDamSit=$p(DataList,"^",4)   //严重时损伤
	S advdrDeptType=$p(DataList,"^",5) //报告单位类型
	S advdrDeptElse=$p(DataList,"^",6) //报告单位其它类型描述	
    S advdrAdm=$p(DataList,"^",7) 	  //就诊adm号
	S advdrPatID=$p(DataList,"^",8) 	  //患者ID
	;Q:'$d(^PAPER(advdrPatID)) "-1"
	S advdrPatName=$p(DataList,"^",9)  //患者姓名
	S advdrPatSex=$p(DataList,"^",10)   //性别
	Q:advdrPatSex="" "-2"
	S advdrPatAge=$p(DataList,"^",11)   //年龄
	S advdrPatDOB=$p(DataList,"^",12)  //出生日期
	S:advdrPatDOB'="" advdrPatDOB=##class(web.DHCADVCOMMON).DateHtmlToLogical(advdrPatDOB)
	S advdrPatNation=""
	S advdrPatNation=$p(DataList,"^",13)   //民族
	I advdrPatNation'="" Q:'$d(^CT("NAT",advdrPatNation)) "-6"
	S advdrPatWeight=$p(DataList,"^",14)   //体重
	S advdrPatContact=$p(DataList,"^",15)  //联系方式
	S advdrHosp=$p(DataList,"^",16)        //医院代码
	S advdrPatMedNo=$p(DataList,"^",17)    //病历号
	S advdrImportInfo=$p(DataList,"^",18)  //相关重要信息
	
	S advdrEvtHis=$p(DataList,"^",19)  //既往药品不良反应事件
	S advdrEvtHisDesc=$p(DataList,"^",20) //既往药品不良反应事件描述
	S advdrEvtFam=$p(DataList,"^",21)   //家族药品不良反应事件
	S advdrEvtFamDesc=$p(DataList,"^",22) //家族药品不良反应事件描述
	
	S advdrEventDr=$p(DataList,"^",23) 		//事件名称
	S advdrEvtDateOcc=$p(DataList,"^",24) 	//事件发生日期
	S:advdrEvtDateOcc'="" advdrEvtDateOcc=##class(web.DHCADVCOMMON).DateHtmlToLogical(advdrEvtDateOcc)
	S advdrTimeOccu=$p(DataList,"^",25)       //事件发生时间
	S:advdrTimeOccu'="" advdrTimeOccu=$zth(advdrTimeOccu,1)
	S advdrEvtRes=$p(DataList,"^",26) 		//事件的结果
	S advdrEvtResDesc=$p(DataList,"^",27)    //事件的结果描述
	
	S advdrEvtDRes=$p(DataList,"^",28)       //好转(死亡)日期
	S:advdrEvtDRes'="" advdrEvtDRes=##class(web.DHCADVCOMMON).DateHtmlToLogical(advdrEvtDRes)
	S advdrEvtTRes=$p(DataList,"^",29)       //好转(死亡)时间
	S:advdrEvtTRes'="" advdrEvtTRes=$zth(advdrEvtTRes,1)
	S advdrEvtSRes=$p(DataList,"^",30)       //停药后是否减轻
	S advdrEvtTakAg=$p(DataList,"^",31)      //是否再次出现同样反应
	S advdrEvtEff=$p(DataList,"^",32)        //对原疾病的影响

	S advdrEvtCUser=$p(DataList,"^",33)  //关联性评价之报告人评价
	
	;S userEvtUser="",advdrEvtRepUser=""
	S advdrEvtRepUser=$p(DataList,"^",34)  //报告人评价签字
	;I advdrEvtUser'="" s userEvtUser=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(advdrEvtUser),""))
	;I userEvtUser'="" s advdrEvtRepUser=$p(^SSU("SSUSR",userEvtUser),"^",1)
	S advdrEvtCDept=$p(DataList,"^",35)  //关联性评价之报告单位评价
	
	;S userDeptName="",advdrEvtRepDept=""
	S advdrEvtRepDept=$p(DataList,"^",36)  //报告单位签字
	;I advdrDeptName'="" s userDeptName=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(advdrDeptName),""))
	;I userDeptName'="" s advdrEvtRepDept=$p(^SSU("SSUSR",userDeptName),"^",1)
	
	S advdrEvtUserOfRepTel=$p(DataList,"^",37)  //报告人联系电话
	S advdrEvtCarOfRepUser=$p(DataList,"^",38)  //报告人职业

	S advdrEvtCarOfRepElse=$p(DataList,"^",39)  //报告人职业[其他]
	S advdrEvtEOfRepUser=$p(DataList,"^",40)    //报告人邮箱
	S CreatorID=$p(DataList,"^",41)           //报告人  advdrRepUser
	S advdrRepUser=""
	I CreatorID'="" S advdrRepUser=$p(^SSU("SSUSR",CreatorID),"^",1)
	  
	S LocID=$p(DataList,"^",42)   //报告人所属科室
    S advdrEvtLocOfRep=""
	I LocID'=""  S advdrEvtLocOfRep=$p(^CTLOC(LocID),"^",1)
	
	S advdrEvtProTitOfRep=$p(DataList,"^",43)   //报告人职称
	S advdrEvtProDeptName=$p(DataList,"^",44) //报告单位名称
	
	S userDeptCon="",advdrEvtProDeptCon=""
	S advdrEvtProDeptCon=$p(DataList,"^",45)  //报告单位联系人
	;I advdrDeptCon'=""  S userDeptCon=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(advdrDeptCon),""))
	;I userDeptCon'="" s advdrEvtProDeptCon=$p(^SSU("SSUSR",userDeptCon),"^",1)
	
	S advdrEvtProDeptTel=$p(DataList,"^",46)  //报告单位联系电话
	
	S advdrEvtRemark=$p(DataList,"^",47)      //备注
	S advdrEvtCurStatDR=$p(DataList,"^",48)   //当前状态
	S advdrReportType=$p(DataList,"^",49)   //报告类型
	
	S advdrImportInfoOth=$p(DataList,"^",50) //相关重要信息其他
	S advdrRepDate=$p(DataList,"^",51)     //报告日期
	S:advdrRepDate'="" advdrRepDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(advdrRepDate)
	S advdrRepTime=$p(DataList,"^",52)    //报告时间
	S:advdrRepTime'="" advdrRepTime=$zth(advdrRepTime,1)
	S advdrRepProc=$p(DataList,"^",53)   //过程描述
	S advdrRepNew=$p(DataList,"^",54)    //报告类型新的 Y N
    S advdrRepImpFlag=$p(DataList,"^",55)    //重点标记  Y N  ADVDR_RepImpFlag
    
	&SQL(Insert Into DHC_AdvDrugReport(ADVDR_Code,ADVDR_Priority,ADVDR_RepType,ADVDR_DamSit,
	   ADVDR_DeptType,ADVDR_DeptElse,ADVDR_Adm,ADVDR_PatID,ADVDR_PatName,
	   ADVDR_PatSex,ADVDR_PatAge,ADVDR_PatDOB,ADVDR_PatNation,ADVDR_PatWeight,
	   ADVDR_PatContact,ADVDR_Hosp,ADVDR_PatMedNo,ADVDR_ImportInfo,ADVDR_EventHistory,
	   ADVDR_EventHistDesc,ADVDR_EventFamily,ADVDR_EventFamiDesc,ADVDR_ADRE_Dr,ADVDR_DateOccu,
	   ADVDR_TimeOccu,ADVDR_Result,ADVDR_ResultDesc,ADVDR_DateResult,ADVDR_TimeResult,
	   ADVDR_StopResultt,ADVDR_TakingAgain,ADVDR_EffectOfTreatment,ADVDR_CommentOfUser, 
	   ADVDR_UserOfReport,ADVDR_CommentOfDept,ADVDR_DeptOfReport,ADVDR_Telephone,
	   ADVDR_CareerOfRepUser,ADVDR_CareerOfRepElse,ADVDR_EmailOfRepUser,ADVDR_RepUser,
	   ADVDR_LocOfReporter,ADVDR_ProTitleOfReporter,ADVDR_DeptName,ADVDR_DeptContacts, 
	   ADVDR_DeptTel,ADVDR_Remark,ADVDR_CurStatus_DR,ADVDR_ReportType,ADVDR_ImportInfoOth,
	   ADVDR_RepDate,ADVDR_RepTime,ADVDR_RepProc,ADVDR_RepNew,ADVDR_RepImpFlag) 
	     Values(:advdrRepCode,:advdrPriority,:advdrRepType,:advdrDamSit,
		:advdrDeptType,:advdrDeptElse,:advdrAdm,:advdrPatID,:advdrPatName,:advdrPatSex,:advdrPatAge,
		:advdrPatDOB,:advdrPatNation,:advdrPatWeight,:advdrPatContact,:advdrHosp,:advdrPatMedNo,
		:advdrImportInfo,:advdrEvtHis,:advdrEvtHisDesc,:advdrEvtFam,:advdrEvtFamDesc,
		:advdrEventDr,:advdrEvtDateOcc,:advdrTimeOccu,:advdrEvtRes,:advdrEvtResDesc,:advdrEvtDRes,
		:advdrEvtTRes,:advdrEvtSRes,:advdrEvtTakAg,:advdrEvtEff,
		:advdrEvtCUser,:advdrEvtRepUser,:advdrEvtCDept,:advdrEvtRepDept,
		:advdrEvtUserOfRepTel,:advdrEvtCarOfRepUser,:advdrEvtCarOfRepElse,:advdrEvtEOfRepUser,:advdrRepUser,
		:advdrEvtLocOfRep,:advdrEvtProTitOfRep,:advdrEvtProDeptName,:advdrEvtProDeptCon,
		:advdrEvtProDeptTel,:advdrEvtRemark,:advdrEvtCurStatDR,:advdrReportType,:advdrImportInfoOth,
		:advdrRepDate,:advdrRepTime,:advdrRepProc,:advdrRepNew,:advdrRepImpFlag
		
	))


	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 更新 药物不良事件报告表
/// Creator:     yangyongtao
/// CreateDate:  2016-3-31
/// Table: 		 DHC_AdvDrugReport
/// Input:  	 报告表数据
/// Return： 	 数据id
/// Others:		 w ##class(web.DHCADVMADRREPORT).UpdMadrReport("190","ADR20160615007^10^10^^10^^^0000000310^lhcs070101^2^174岁^1841-07-01^1^^112^^0000000310^10,11,12,13,14,15,99^11^^11^^测试[严重]^2016-06-15^00:00:00^14^直接死因^2016-06-15^19:21:41^10^10^^10^^10^^11111^10^^2222222^600^63^^^^^备注^^2^其他^2016-06-15^00:00:00^,,,不良反应/事件过程描述（包括症状、体征、临床检验等）及处理情况^Y^N")
/// 
ClassMethod UpdMadrReport(advdrID As %String, DataList As %String) As %String
{
	N (advdrID,DataList)
	S advdrRepCode=$p(^DHCADVDRUGREP(advdrID),"^",1) //报告编号 $p(DataList,"^",1)
	//S AdvRepDate=+$H //报告日期
	S advdrPriority=$p(DataList,"^",2) //首次报告 报告优先级
	S advdrRepType=$p(DataList,"^",3)  //报告类型 
	s advdrDamSit=$p(DataList,"^",4)   //严重时损伤
	S advdrDeptType=$p(DataList,"^",5) //报告单位类型
	S advdrDeptElse=$p(DataList,"^",6) //报告单位其它类型描述	
    S advdrAdm=$p(DataList,"^",7) 	  //就诊adm号
	S advdrPatID=$p(DataList,"^",8) 	  //患者ID
	;Q:'$d(^PAPER(advdrPatID)) "-1"
	S advdrPatName=$p(DataList,"^",9)  //患者姓名
	S advdrPatSex=$p(DataList,"^",10)   //性别
	Q:advdrPatSex="" "-2"
	S advdrPatAge=$p(DataList,"^",11)   //年龄
	S advdrPatDOB=$p(DataList,"^",12)  //出生日期
	S:advdrPatDOB'="" advdrPatDOB=##class(web.DHCADVCOMMON).DateHtmlToLogical(advdrPatDOB)
	S advdrPatNation=""
	S advdrPatNation=$p(DataList,"^",13)   //民族
	
	I advdrPatNation'="" Q:'$d(^CT("NAT",advdrPatNation)) "-6"
	S advdrPatWeight=$p(DataList,"^",14)   //体重
	S advdrPatContact=$p(DataList,"^",15)  //联系方式
	S advdrHosp=$p(DataList,"^",16)        //医院代码
	S advdrPatMedNo=$p(DataList,"^",17)    //病历号
	S advdrImportInfo=$p(DataList,"^",18)  //相关重要信息
	S advdrEvtHis=$p(DataList,"^",19)  //既往药品不良反应事件
	S advdrEvtHisDesc=$p(DataList,"^",20) //既往药品不良反应事件描述
	S advdrEvtFam=$p(DataList,"^",21)   //家族药品不良反应事件
	S advdrEvtFamDesc=$p(DataList,"^",22) //家族药品不良反应事件描述
	
	S advdrEventDr=$p(DataList,"^",23) 		//事件名称
	S advdrEvtDateOcc=$p(DataList,"^",24) 	//事件发生日期
	S:advdrEvtDateOcc'="" advdrEvtDateOcc=##class(web.DHCADVCOMMON).DateHtmlToLogical(advdrEvtDateOcc)
	S advdrTimeOccu=$p(DataList,"^",25)       //事件发生时间
	S:advdrTimeOccu'="" advdrTimeOccu=$zth(advdrTimeOccu,1)
	S advdrEvtRes=$p(DataList,"^",26) 		//事件的结果
	S advdrEvtResDesc=$p(DataList,"^",27)    //事件的结果描述
	
	S advdrEvtDRes=$p(DataList,"^",28)       //好转(死亡)日期
	S:advdrEvtDRes'="" advdrEvtDRes=##class(web.DHCADVCOMMON).DateHtmlToLogical(advdrEvtDRes)
	S advdrEvtTRes=$p(DataList,"^",29)       //好转(死亡)时间
	S:advdrEvtTRes'="" advdrEvtTRes=$zth(advdrEvtTRes,1)
	S advdrEvtSRes=$p(DataList,"^",30)       //停药后是否减轻
	S advdrEvtTakAg=$p(DataList,"^",31)      //是否再次出现同样反应
	S advdrEvtEff=$p(DataList,"^",32)        //对原疾病的影响

	S advdrEvtCUser=$p(DataList,"^",33)  //关联性评价之报告人评价
	
	;S userEvtUser="",advdrEvtRepUser=""
	S advdrEvtRepUser=$p(DataList,"^",34)  //报告人评价签字
	;I advdrEvtUser'="" s userEvtUser=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(advdrEvtUser),""))
	;I userEvtUser'="" s advdrEvtRepUser=$p(^SSU("SSUSR",userEvtUser),"^",1)
	S advdrEvtCDept=$p(DataList,"^",35)  //关联性评价之报告单位评价
	
	;S userDeptName="",advdrEvtRepDept=""
	S advdrEvtRepDept=$p(DataList,"^",36)  //报告单位签字
	;I advdrDeptName'="" s userDeptName=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(advdrDeptName),""))
	;I userDeptName'="" s advdrEvtRepDept=$p(^SSU("SSUSR",userDeptName),"^",1)
	
	
	S advdrEvtUserOfRepTel=$p(DataList,"^",37)  //报告人联系电话
	
	
	S advdrEvtCarOfRepUser=$p(DataList,"^",38)  //报告人职业

	S advdrEvtCarOfRepElse=$p(DataList,"^",39)  //报告人职业[其他]
	
	S advdrEvtEOfRepUser=$p(DataList,"^",40)    //报告人邮箱
	S CreatorID=$p(DataList,"^",41)           //报告人签名
	S advdrRepUser=""
	I CreatorID'="" S advdrRepUser=$p(^SSU("SSUSR",CreatorID),"^",1)
	
	S LocID=$p(DataList,"^",42)   //报告人所属科室
    S advdrEvtLocOfRep=""
	I LocID'=""  S advdrEvtLocOfRep=$p(^CTLOC(LocID),"^",1)
	
	S advdrEvtProTitOfRep=$p(DataList,"^",43)   //报告人职称
	

	S advdrEvtProDeptName=$p(DataList,"^",44) //报告单位名称
	
	;S userDeptCon="",advdrEvtProDeptCon=""
	S advdrEvtProDeptCon=$p(DataList,"^",45)  //报告单位联系人
	;I advdrDeptCon'=""  S userDeptCon=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(advdrDeptCon),""))
	;I userDeptCon'="" s advdrEvtProDeptCon=$p(^SSU("SSUSR",userDeptCon),"^",1)
	
	S advdrEvtProDeptTel=$p(DataList,"^",46)  //报告单位联系电话

	S advdrEvtRemark=$p(DataList,"^",47)      //备注
	S advdrEvtCurStatDR=$p(DataList,"^",48)   //当前状态
	S advdrReportType=$p(DataList,"^",49)   //报告类型

	S advdrImportInfoOth=$p(DataList,"^",50) //相关重要信息其他
	S advdrRepDate=$p(DataList,"^",51)     //报告日期
	S:advdrRepDate'="" advdrRepDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(advdrRepDate)
	S advdrRepTime=$p(DataList,"^",52)    //报告时间
	S:advdrRepTime'="" advdrRepTime=$zth(advdrRepTime,1)
	S advdrRepProc=$p(DataList,"^",53)   //过程描述
	S advdrRepNew=$p(DataList,"^",54)    //报告类型新的 Y N
	S advdrRepImpFlag=$p(DataList,"^",55)    //重点标记  Y N  
	
	&SQL(Update DHC_AdvDrugReport Set ADVDR_Code=:advdrRepCode,ADVDR_Priority=:advdrPriority,ADVDR_RepType=:advdrRepType,ADVDR_DamSit=:advdrDamSit,
	   ADVDR_DeptType=:advdrDeptType,ADVDR_DeptElse=:advdrDeptElse,ADVDR_Adm=:advdrAdm,ADVDR_PatID=:advdrPatID,ADVDR_PatName=:advdrPatName,
	   ADVDR_PatSex=:advdrPatSex,ADVDR_PatAge=:advdrPatAge,ADVDR_PatDOB=:advdrPatDOB,ADVDR_PatNation=:advdrPatNation,ADVDR_PatWeight=:advdrPatWeight,
	   ADVDR_PatContact=:advdrPatContact,ADVDR_Hosp=:advdrHosp,ADVDR_PatMedNo=:advdrPatMedNo,ADVDR_ImportInfo=:advdrImportInfo,ADVDR_EventHistory=:advdrEvtHis,
	   ADVDR_EventHistDesc=:advdrEvtHisDesc,ADVDR_EventFamily=:advdrEvtFam,ADVDR_EventFamiDesc=:advdrEvtFamDesc,ADVDR_ADRE_Dr=:advdrEventDr,ADVDR_DateOccu=:advdrEvtDateOcc,
	   ADVDR_TimeOccu=:advdrTimeOccu,ADVDR_Result=:advdrEvtRes,ADVDR_ResultDesc=:advdrEvtResDesc,ADVDR_DateResult=:advdrEvtDRes,ADVDR_TimeResult=:advdrEvtTRes,
	   ADVDR_StopResultt=:advdrEvtSRes,ADVDR_TakingAgain=:advdrEvtTakAg,ADVDR_EffectOfTreatment=:advdrEvtEff,ADVDR_CommentOfUser=:advdrEvtCUser, 
       ADVDR_UserOfReport=:advdrEvtRepUser,ADVDR_CommentOfDept=:advdrEvtCDept,ADVDR_DeptOfReport=:advdrEvtRepDept,ADVDR_Telephone=:advdrEvtUserOfRepTel,
	   ADVDR_CareerOfRepUser=:advdrEvtCarOfRepUser,ADVDR_CareerOfRepElse=:advdrEvtCarOfRepElse,ADVDR_EmailOfRepUser=:advdrEvtEOfRepUser,ADVDR_RepUser=:advdrRepUser,
	   ADVDR_LocOfReporter=:advdrEvtLocOfRep,ADVDR_ProTitleOfReporter=:advdrEvtProTitOfRep,ADVDR_DeptName=:advdrEvtProDeptName,ADVDR_DeptContacts=:advdrEvtProDeptCon, 
	   ADVDR_DeptTel=:advdrEvtProDeptTel,ADVDR_Remark=:advdrEvtRemark,ADVDR_CurStatus_DR=:advdrEvtCurStatDR,ADVDR_ReportType=:advdrReportType,ADVDR_ImportInfoOth=:advdrImportInfoOth,
	   ADVDR_RepDate=:advdrRepDate,ADVDR_RepTime=:advdrRepTime,ADVDR_RepProc=:advdrRepProc,ADVDR_RepNew=:advdrRepNew,ADVDR_RepImpFlag=:advdrRepImpFlag Where ADVDR_RowID=:advdrID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 保存 药物不良事件报告表
/// Creator:     yangyongtao
/// CreateDate:  2016-3-31  
/// Table: 		 DHC_AdvDrugReport
/// Input:  	 报告表id,advdrDataList:报告表数据,advdrRepAuditList:以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMADRREPORT).SaveMadrReport("","MATADR20160405001^10^10^^10^^advdr00000001^^test^1^^2016-04-05^1^1111^^11111^,,,,,,^^11^^11^^11111111^2016-04-05^13:47:50^10^^^^10^10^10^10^1111111^^^111111111^10^^11111111111^^^^2016-04-05^600^63^111","")
/// 			w ##class(web.DHCADVMADRREPORT).SaveMadrReport("239","DRUGADV20160721001^^11^导致死亡^^^697^0000000422^小李^2^^1990-01-01^1^^123456^^^,11,12,13,,15,^11^^11^^感冒[一般]^2016-07-21^16:18:27^10^^^^10^10^10^^^10^蒋荣猛^111111^10^^22222222222^600^63^^^^^备注^4||2^2^^2016-07-21^16:17:02^不良反应/事件过程描述（包括症状、体征、临床检验等）及处理情况^Y^N","10^651||5^1040^国药准字H12020593-^维生素B2片[飞鹰][5mg*100片]^948^32^131^07111823^5mg/口服/Qdmg/口服/Qdmg/口服/Qdmg/口服/Qd^149^2^4^2016-07-11^2016-07-31^^用药原因!!10^651||6^1035^国药准字H33020234-^维生素A胶丸[2.5万iu*100粒]^943^5^325^07111825^2.5万IU/口服/Qd万IU/口服/Qd万IU/口服/Qd万IU/口服/Qd^153^2^4^2016-07-11^2016-07-31^^用药原因!!10^651||7^1903^国药准字H32021769^亚硫酸氢钠甲萘醌注射液[4mg:1ml]^1277^45^213^07111821*10^1mg/注射/Qdmg/注射/Qdmg/注射/Qdmg/注射/Qd^149^4^4^2016-07-11^2016-07-31^^用药原因","1^感冒[一般]","")
///   w ##class(web.DHCADVMADRREPORT).SaveMadrReport("","^10^^^10^^1^0000000001^连接件^1^29岁^2017-08-09^1^60^112323223213213^2^000002^10,11,,,,,^10^wdwwe_ewweew^10^ewewew_weweewew^sdfds[一般],药品过敏反应[一般]^2017-08-09^15:57:06^14^sadfsdf^2017-08-09^15:57:16^10^11^12^13^孙凤霞^13^孙凤霞^23324324^^^23324324^359^6^232^单位名称^DWAASDS^12342Q32132^备注^^2^^2017-08-09^15:55:36^sdfsdfsfsdfsdf^Y^N","^sasdasdasd&ItmStr=10^14||1^1369||1^国药准字Z10970009-^护肝颗粒[2g*12袋]^1215^7^476^2016010415^1袋^18^2^25^2017-03-14^2017-03-20^^333333!!11^14||2^1091||1^国药准字H51221158-^氯化钠注射液[科伦][0.9%25500ml]^482^43^340^34344343^500ml^20^8^4^2017-03-14^2017-03-14^^dfdfdfdf","^sdfds[一般]||6^药品过敏反应[一般]","") 
ClassMethod SaveMadrReport(advdrID As %String, advdrDataList As %String, advRepMRCICItms As %String, advdrRepItmStr As %String, advRepEvtItems As %String, advdrRepAuditList As %String, flag As %String) As %String
{
	N (advdrID,advdrDataList,advRepMRCICItms,advdrRepItmStr,advRepEvtItems,advdrRepAuditList,flag)
	S ret=0
	I advdrID="" D
	.S ret=..Insert(advdrDataList,advRepMRCICItms,advdrRepItmStr,advRepEvtItems,advdrRepAuditList,flag)
	E  D
	.S ret=..Update(advdrID,advdrDataList,advRepMRCICItms,advdrRepItmStr,advRepEvtItems,advdrRepAuditList,flag)
	Q ret
}

/// Description: 删除  药物不良事件报告表  
/// Creator:     yangyongtao
/// CreateDate:  2016-3-31
/// Table: 		 DHC_AdvDrugReport
/// Input:  	 报告表id 
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVMADRREPORT).DelMadrReport("2")
ClassMethod DelMadrReport(params As %String) As %String
{
	N (params)
	S advdrID=$p(params,"^",1)
	S UserID=$p(params,"^",2)
	S repUser=$p(^DHCADVDRUGREP(advdrID),"^",41)        //报告人
    S repCurStatDR=$p(^DHCADVDRUGREP(advdrID),"^",48)   //当前状态
	S repUserID=""
	I repUser'=""  D
	.S repUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(repUser),""))
	Q:UserID'=repUserID -1  //不是本人，不能删除
	Q:repCurStatDR'="" -2  //已提交，不能删除
	
	TS
	&SQL(DELETE DHC_AdvDrugReport WHERE ADVDR_RowID=:advdrID)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 -3

	//删除相关表
	S Err=..DelAdvRelatInfo(advdrID)
	I Err'=0 tro
	Q:Err'=0 "-10"
	TC
	Q 0
}

/// Descript:删除不良反应相关信息表
/// w ##class(web.DHCADVMADRREPORT).DelAdvRelatInfo("239")
ClassMethod DelAdvRelatInfo(advdrID As %String) As %String
{
	n (advdrID)
	//原患疾病
	i $d(^DHCADVDRUGDI(advdrID,"DIAG",1)) d
	.&SQL(DELETE DHC_AdvDrugRepDiag WHERE ADVDRD_ADRR_Parref=:advdrID)
	q:+$g(SQLCODE)'=0 SQLCODE
	//药品明细
	i $d(^DHCADVDRUGREP(advdrID,"Drug",1)) d
	.&SQL(DELETE DHC_AdvDrugRepItm WHERE ADVDRI_ADRR_Parref=:advdrID)
	q:+$g(SQLCODE)'=0 SQLCODE
	//不良反应事件
	i $d(^DHCADVDRUGREP(advdrID,"Event",1)) d
	.&SQL(DELETE DHC_AdvDrugRepEvent WHERE ADVDRE_ADRR_Parref=:advdrID)
	q:+$g(SQLCODE)'=0 SQLCODE
	q 0
}

/// Description: 添加药物不良事件
/// Creator:     yangyongtao
/// CreateDate:  2016-3-31
/// Table: 		 DHC_AdvDrugReport
/// Input:  	 advdrDataList:报告表数据,advdrRepAuditList:以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return： 	 "0^"_advdrID:保存成功标志^报告表id
ClassMethod Insert(advdrDataList As %String, advRepMRCICItms As %String, advdrRepItmStr As %String, advRepEvtItems As %String, advdrRepAuditList As %String, flag As %String) As %String
{
	N (advdrDataList,advRepMRCICItms,advdrRepItmStr,advRepEvtItems,advdrRepAuditList,flag)
	S Err=0

	TS
	S advdrID=..InsMadrReport(advdrDataList)
	I advdrID<0 tro
	Q:advdrID<0 advdrID
	
	//保存不良反应报告患者诊断信息
	i advRepMRCICItms'="" d
	.s Err=..InsAdvRepDiag(advdrID,advRepMRCICItms)
	i Err'=0 tro
	q:Err'=0 "-14"
	
	//不良反应报告药品明细
	i advdrRepItmStr'="" d  
	.s Err=..InsAdvRepDrugItm(advdrID,advdrRepItmStr)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	//不良反应事件信息
	i advRepEvtItems'="" d
	.s Err=..InsAdvRepEvent(advdrID,advRepEvtItems)
	i Err'=0 tro
	q:Err'=0 "-16"
	
	//更新状态
	S adtList=advdrID_"^"_$p(advdrRepAuditList,"^",8)_"^"_$p(advdrRepAuditList,"^",2)_"^"_$p(advdrRepAuditList,"^",3)_"^"_$p(advdrRepAuditList,"^",4)
    S nextStatuDr=""
	I flag="1" D
	.S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(adtList)
	I (flag="1")&(+nextStatuDr'>0) tro
	Q:(flag="1")&(+nextStatuDr'>0) nextStatuDr
	
	I flag="1" D
	.&sql(update DHC_AdvDrugReport set ADVDR_CurStatus_DR=:nextStatuDr where ADVDR_RowID=:advdrID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 S Err="-17"
	
	Q:Err'=0 "-17"
	
	S advdrRepAuditList=nextStatuDr_"^"_$p(advdrRepAuditList,"^",2,8)
	
	//不良反应报告审批流程[默认插入初始状态]
	I advdrRepAuditList'="" D
	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(advdrID,advdrRepAuditList)
	I Err'=0 tro
	Q:Err'=0 "-18"

	TC
	Q "0^"_advdrID
}

/// Description: 修改药物不良事件
/// Creator:     yangyongtao
/// CreateDate:  2016-3-31
/// Table: 		 DHC_AdvDrugReport
/// Input:  	 报告表id,advdrDataList:报告表数据,advdrRepAuditList:以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return： 	 "0^"_advdrID:保存成功标志^报告表id
ClassMethod Update(advdrID As %String, advdrDataList As %String, advRepMRCICItms As %String, advdrRepItmStr As %String, advRepEvtItems As %String, advdrRepAuditList As %String, flag As %String) As %String
{
	N (advdrID,advdrDataList,advRepMRCICItms,advdrRepItmStr,advRepEvtItems,advdrRepAuditList,flag)
	S Err=0
	S RepStatus=$p(^DHCADVDRUGREP(advdrID),"^",48)   //当前状态
	TS
	S advdrID=..UpdMadrReport(advdrID,advdrDataList)
	I advdrID<0 tro
	Q:advdrID<0 advdrID
	//删除相关子表
	s Err=..DelAdvRelatInfo(advdrID)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//保存不良反应报告患者诊断信息
	i advRepMRCICItms'="" d
	.s Err=..InsAdvRepDiag(advdrID,advRepMRCICItms)
	i Err'=0 tro
	q:Err'=0 "-14"
	
	//不良反应报告药品明细
	i advdrRepItmStr'="" d
	.s Err=..InsAdvRepDrugItm(advdrID,advdrRepItmStr)
	i Err'=0 tro
	q:Err'=0 "-15"
	//不良反应事件信息
	i advRepEvtItems'="" d
	.s Err=..InsAdvRepEvent(advdrID,advRepEvtItems)
	i Err'=0 tro
	q:Err'=0 "-16"
	;S ^TMP("yangyongtao123")=advdrRepAuditList
	//更新状态
	S adtList=advdrID_"^"_$p(advdrRepAuditList,"^",8)_"^"_$p(advdrRepAuditList,"^",2)_"^"_$p(advdrRepAuditList,"^",3)_"^"_$p(advdrRepAuditList,"^",4)
    S nextStatuDr=""
	I flag="1" D
	.S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(adtList)
	;S ^TMP("yangyongtao")=advdrRepAuditList
	I (flag="1")&(+nextStatuDr'>0) tro
	Q:(flag="1")&(+nextStatuDr'>0) nextStatuDr
	
	I flag="1" D
	.&sql(update DHC_AdvDrugReport set ADVDR_CurStatus_DR=:nextStatuDr where ADVDR_RowID=:advdrID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 s Err="-17"
	
	Q:Err'=0 "-17"
	
	S:flag="1" advdrRepAuditList=nextStatuDr_"^"_$p(advdrRepAuditList,"^",2,8)
	S:flag="0" advdrRepAuditList=RepStatus_"^"_$p(advdrRepAuditList,"^",2,8)
	
	//不良反应报告审批流程[默认插入初始状态]
	I advdrRepAuditList'="" D
	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(advdrID,advdrRepAuditList)
	I Err'=0 tro
	Q:Err'=0 "-18"
	
	TC
	
	Q "0^"_advdrID
}

/// Description: 获取药物不良事件报告信息  
/// Creator:     yangyongtao
/// CreateDate:  2016-3-31
/// Table: 		 DHC_AdvDrugReport
/// Input: 		 报告表id , params:以字符"^"分割,格式为:人员id^科室id^安全组id^报告类型代码
/// Return： 	 报告表数据
/// Others:		 w ##class(web.DHCADVMADRREPORT).GetMadrRepInfo("184","359^6^134^drug")
ClassMethod GetMadrRepInfo(advdrID As %String, params As %String) As %String
{
	N (advdrID, params)
	Q:'$d(^DHCADVDRUGREP(advdrID)) ""
	S advdrRepCode=$p(^DHCADVDRUGREP(advdrID),"^",1)   //编号
	S advdrPriority=$p(^DHCADVDRUGREP(advdrID),"^",2) //首次报告 报告优先级
	S advdrRepType=$p(^DHCADVDRUGREP(advdrID),"^",3)  //报告类型 
	s advdrDamSit=$p(^DHCADVDRUGREP(advdrID),"^",4)   //严重时损伤
	S advdrDeptType=$p(^DHCADVDRUGREP(advdrID),"^",5) //报告单位类型
	S advdrDeptElse=$p(^DHCADVDRUGREP(advdrID),"^",6) //报告单位其它类型描述	
    S advdrAdm=$p(^DHCADVDRUGREP(advdrID),"^",7) 	  //就诊adm号
	S advdrPatID=$p(^DHCADVDRUGREP(advdrID),"^",8) 	  //患者ID
	S advdrPatName=$p(^DHCADVDRUGREP(advdrID),"^",9)  //患者姓名
	S advdrPatSex=$p(^DHCADVDRUGREP(advdrID),"^",10)   //性别
	Q:advdrPatSex="" "-2"
	S advdrPatAge=$p(^DHCADVDRUGREP(advdrID),"^",11)   //年龄
	S advdrPatDOB=$p(^DHCADVDRUGREP(advdrID),"^",12)  //出生日期
	S:advdrPatDOB'="" advdrPatDOB=##class(web.DHCADVCOMMON).DateLogicalToHtml(advdrPatDOB)
	S advdrPatNation=$p(^DHCADVDRUGREP(advdrID),"^",13)   //民族  advdrPatNation
	;S advdrPatNation=""
	I advdrPatNation'="" Q:'$d(^CT("NAT",advdrPatNation)) "-6"  
	;I advdrNation'="" S advdrPatNation=$p(^CT("NAT",advdrNation),"^",2)
   
	S advdrPatWeight=$p(^DHCADVDRUGREP(advdrID),"^",14)   //体重
	S advdrPatContact=$p(^DHCADVDRUGREP(advdrID),"^",15)  //联系方式
	S advdrHosp=$p(^DHCADVDRUGREP(advdrID),"^",16)        //医院代码
	S advdrPatMedNo=$p(^DHCADVDRUGREP(advdrID),"^",17)    //病历号
	
	S advdrImportInfo=..getMadrImportInfo(advdrID)  //相关重要信息
	
	
	
	S advdrEvtHis=$p(^DHCADVDRUGREP(advdrID),"^",19)  //既往药品不良反应事件
	S advdrEvtHisDesc=$p(^DHCADVDRUGREP(advdrID),"^",20) //既往药品不良反应事件描述
	S advdrEvtFam=$p(^DHCADVDRUGREP(advdrID),"^",21)   //家族药品不良反应事件
	S advdrEvtFamDesc=$p(^DHCADVDRUGREP(advdrID),"^",22) //家族药品不良反应事件描述
	
	S advdrEventDr=$p(^DHCADVDRUGREP(advdrID),"^",23) 		//事件名称
	S advdrEvtDateOcc=$p(^DHCADVDRUGREP(advdrID),"^",24) 	//事件发生日期
	S:advdrEvtDateOcc'="" advdrEvtDateOcc=##class(web.DHCADVCOMMON).DateLogicalToHtml(advdrEvtDateOcc)
		
	S advdrTimeOccu=$p(^DHCADVDRUGREP(advdrID),"^",25)       //事件发生时间
	S:advdrTimeOccu'="" advdrTimeOccu=$zt(advdrTimeOccu,1)
	S advdrEvtRes=$p(^DHCADVDRUGREP(advdrID),"^",26) 		//事件的结果
	S advdrEvtResDesc=$p(^DHCADVDRUGREP(advdrID),"^",27)    //事件的结果描述
	
	S advdrEvtDRes=$p(^DHCADVDRUGREP(advdrID),"^",28)       //好转(死亡)日期
	S:advdrEvtDRes'="" advdrEvtDRes=##class(web.DHCADVCOMMON).DateLogicalToHtml(advdrEvtDRes)
	S advdrEvtTRes=$p(^DHCADVDRUGREP(advdrID),"^",29)       //好转(死亡)时间
	S:advdrEvtTRes'="" advdrEvtTRes=$zt(advdrEvtTRes,1)
	S advdrEvtSRes=$p(^DHCADVDRUGREP(advdrID),"^",30)       //停药后是否减轻
	S advdrEvtTakAg=$p(^DHCADVDRUGREP(advdrID),"^",31)      //是否再次出现同样反应
	S advdrEvtEff=$p(^DHCADVDRUGREP(advdrID),"^",32)        //对原疾病的影响

	S advdrEvtCUser=$p(^DHCADVDRUGREP(advdrID),"^",33)  //关联性评价之报告人评价
	;S userEvtUser="",advdrEvtRepUser=""
	S advdrEvtRepUser=$p(^DHCADVDRUGREP(advdrID),"^",34)  //报告人评价签字
	;I advdrEvtUser'="" s userEvtUser=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(advdrEvtUser),""))
	;I userEvtUser'="" s advdrEvtRepUser=$p(^SSU("SSUSR",userEvtUser),"^",2)
	
	S advdrEvtCDept=$p(^DHCADVDRUGREP(advdrID),"^",35)  //关联性评价之报告单位评价
	;S userDeptName="",advdrEvtRepDept=""
	S advdrEvtRepDept=$p(^DHCADVDRUGREP(advdrID),"^",36)  //报告单位签字
	;I advdrDeptName'="" s userDeptName=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(advdrDeptName),""))
	;I userDeptName'=""  s advdrEvtRepDept=$p(^SSU("SSUSR",userDeptName),"^",2)
	
	S advdrEvtUserOfRepTel=$p(^DHCADVDRUGREP(advdrID),"^",37)  //报告人联系电话
	S advdrEvtCarOfRepUser=$p(^DHCADVDRUGREP(advdrID),"^",38)  //报告人职业

	S advdrEvtCarOfRepElse=$p(^DHCADVDRUGREP(advdrID),"^",39)  //报告人职业[其他]
	S advdrEvtEOfRepUser=$p(^DHCADVDRUGREP(advdrID),"^",40)    //报告人邮箱
	
	S advdrUserCode=$p(^DHCADVDRUGREP(advdrID),"^",41)           //报告人
	S advdrRepUser=""  S advdrRepUserDesc=""
	I advdrUserCode'="" S advdrRepUser=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(advdrUserCode),""))
	I advdrRepUser'=""  S advdrRepUserDesc=$p(^SSU("SSUSR",advdrRepUser),"^",2)
	
    
     S LocCode=$p(^DHCADVDRUGREP(advdrID),"^",42)     //科室代码
	 S advdrEvtLocOfRep=""  S advdrEvtLocOfRepDesc=""  
	 I LocCode'="" D
	 .S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	 .S advdrEvtLocOfRep=$p(^CTLOC(LocID),"^",1)
	 .S advdrEvtLocOfRepDesc=$p(^CTLOC(LocID),"^",2)
    
	
	S advdrEvtProTitOfRep=$p(^DHCADVDRUGREP(advdrID),"^",43)   //报告人职称
	
	S advdrEvtProDeptName=$p(^DHCADVDRUGREP(advdrID),"^",44) //报告单位名称
	
	;S userDeptCon=""  S advdrEvtProDeptCon=""
	S advdrEvtProDeptCon=$p(^DHCADVDRUGREP(advdrID),"^",45)  //报告单位联系人
	;I advdrDeptCon'="" S userDeptCon=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(advdrDeptCon),""))
	;I userDeptCon'=""  S advdrEvtProDeptCon=$p(^SSU("SSUSR",userDeptCon),"^",2)
	
	
	S advdrEvtProDeptTel=$p(^DHCADVDRUGREP(advdrID),"^",46)  //报告单位联系电话
    
    S advdrEvtRemark=$p(^DHCADVDRUGREP(advdrID),"^",47)      //备注
    S advdrEvtCurStatDR=$p(^DHCADVDRUGREP(advdrID),"^",48)   //当前状态
	S advdrReportType=$p(^DHCADVDRUGREP(advdrID),"^",49)   //报告类型
    
    S advdrImportInfoOth=$p(^DHCADVDRUGREP(advdrID),"^",50) //相关重要信息其他
	S advdrRepDate=$p(^DHCADVDRUGREP(advdrID),"^",51)     //报告日期
	S:advdrRepDate'="" advdrRepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(advdrRepDate)
	S advdrRepTime=$p(^DHCADVDRUGREP(advdrID),"^",52)    //报告时间
	S:advdrRepTime'="" advdrRepTime=$zt(advdrRepTime,1)
	S advdrRepProc=$p(^DHCADVDRUGREP(advdrID),"^",53)   //过程描述
	S advdrRepNew=$p(^DHCADVDRUGREP(advdrID),"^",54)    //报告类型新的 Y N
	S advdrRepImpFlag=$p(^DHCADVDRUGREP(advdrID),"^",55)    //重要标记
	S advRepEvent=..getAdvRepEvent(advdrID) //不良反应报告
	;S advRepEvent=$p(advRepEvent,"!",2)
	S AdvRepDiag=..getAdvRepDiag(advdrID) //原患疾病
	;S AdvRepDiag=$p(AdvRepDiag,"!",2)
	
	
	S medadrAuditID=$o(^DHCMEDREPADT(0,"Pointer",advdrReportType,advdrID,""),-1)
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
	
	S advdrDataList=advdrID_"!"_advdrRepCode_"!"_advdrPriority_"!"_advdrRepType_"!"_advdrDamSit_"!"_advdrDeptType_"!"_advdrDeptElse  //6
	S advdrDataList=advdrDataList_"!"_advdrAdm_"!"_advdrPatID_"!"_advdrPatName_"!"_advdrPatSex  //10
	S advdrDataList=advdrDataList_"!"_advdrPatAge_"!"_advdrPatDOB_"!"_advdrPatNation_"!"_advdrPatWeight_"!"_advdrPatContact //15
	S advdrDataList=advdrDataList_"!"_advdrHosp_"!"_advdrPatMedNo_"!"_advdrImportInfo_"!"_advdrEvtHis_"!"_advdrEvtHisDesc   //20
	S advdrDataList=advdrDataList_"!"_advdrEvtFam_"!"_advdrEvtFamDesc_"!"_advdrEventDr_"!"_advdrEvtDateOcc_"!"_advdrTimeOccu //25
	S advdrDataList=advdrDataList_"!"_advdrEvtRes_"!"_advdrEvtResDesc_"!"_advdrEvtDRes_"!"_advdrEvtTRes_"!"_advdrEvtSRes      //30
	S advdrDataList=advdrDataList_"!"_advdrEvtTakAg_"!"_advdrEvtEff_"!"_advdrEvtCUser_"!"_advdrEvtRepUser_"!"_advdrEvtCDept  //35
	S advdrDataList=advdrDataList_"!"_advdrEvtRepDept_"!"_advdrEvtUserOfRepTel_"!"_advdrEvtCarOfRepUser_"!"_advdrEvtCarOfRepElse_"!"_advdrEvtEOfRepUser  //40
	S advdrDataList=advdrDataList_"!"_advdrRepUserDesc_"!"_advdrEvtLocOfRepDesc_"!"_advdrEvtProTitOfRep  //43
	S advdrDataList=advdrDataList_"!"_advdrEvtProDeptName_"!"_advdrEvtProDeptCon_"!"_advdrEvtProDeptTel_"!"_advdrEvtRemark_"!"_advdrEvtCurStatDR_"!"_advdrReportType //49
	S advdrDataList=advdrDataList_"!"_advdrImportInfoOth_"!"_advdrRepDate_"!"_advdrRepTime_"!"_advdrRepProc_"!"_advdrRepNew_"!"_MatadrInitStatDR  //55
	S advdrDataList=advdrDataList_"!"_medadrNextLoc_"!"_medadrLocAdvice_"!"_medadrReceive
	S advdrDataList=advdrDataList_"!"_advdrRepUser_"!"_advdrEvtLocOfRep _"!"_advRepEvent_"!"_LocID_"!"_advdrRepImpFlag_"!"_AdvRepDiag //66
	
 Q advdrDataList
}

/// Description: 获取报告表的重要信息 (打印/导出)
/// Creator:   	 yangyongtao
/// CreateDate:  2016-05-26
/// Input:  	 报告表id  
/// Output:  	 此报告所选的项目环节信息   
/// Others:		 w ##class(web.DHCADVMADRREPORT).getMadrExpImpInfo("184")
ClassMethod getMadrExpImpInfo(advdrID) As %String
{
	N (advdrID)
	S tmpStr=""
	S advdrImport=$p(^DHCADVDRUGREP(advdrID),"^",18) //重要信息
	S advdrImportOtherDesc=$p(^DHCADVDRUGREP(advdrID),"^",50) //其他
	
	S smokhis=$p(advdrImport,",",1)
    S drinhis=$p(advdrImport,",",2)
	S gestper=$p(advdrImport,",",3)
	S hepahis=$p(advdrImport,",",4)
	S nephhis=$p(advdrImport,",",5)
	S allehis=$p(advdrImport,",",6)
	S iiothers=$p(advdrImport,",",7)
	S advdrImportstr=""
    I (smokhis="10")&(smokhis'="")  d
    .S smokhisdesc="吸烟史"
    .s advdrImportstr=$s(advdrImportstr'="":advdrImportstr_","_smokhisdesc,1:smokhisdesc)
    I (drinhis="11")&(drinhis'="")  d
    .S drinhisdesc="饮酒史"
    .s advdrImportstr=$s(advdrImportstr'="":advdrImportstr_","_drinhisdesc,1:drinhisdesc)
    I (gestper="12")&(gestper'="")  d
    .S gestperdesc="妊娠期"
    .s advdrImportstr=$s(advdrImportstr'="":advdrImportstr_","_gestperdesc,1:gestperdesc)
    I (hepahis="13")&(hepahis'="")  d
    .S hepahisdesc="肝病史"
    .s advdrImportstr=$s(advdrImportstr'="":advdrImportstr_","_hepahisdesc,1:hepahisdesc)
    I (nephhis="14")&(nephhis'="")  d
    .S nephhisdesc="肾病史"
    .s advdrImportstr=$s(advdrImportstr'="":advdrImportstr_","_nephhisdesc,1:nephhisdesc)
    I (allehis="15")&(allehis'="")  d
    .S allehisdesc="过敏史"
    .s advdrImportstr=$s(advdrImportstr'="":advdrImportstr_","_allehisdesc,1:allehisdesc)
    I (iiothers="99")&(iiothers'="")  d
    .S iiothersdesc="其他"
    .s advdrImportstr=$s(advdrImportstr'="":advdrImportstr_","_iiothersdesc,1:iiothersdesc)
    //S advdrImport=smokhis_","_drinhis_","_gestper_","_hepahis_","_nephhis_","_allehis_","_iiothers
	S ListData=$s(advdrImportOtherDesc'="":advdrImportstr_"^"_advdrImportOtherDesc,1:advdrImportstr)
	
	I tmpStr="" S tmpStr=ListData
	E  S tmpStr=tmpStr_","_ListData
	Q tmpStr
}

/// Description: 获取药物不良事件报告信息(打印/导出)
/// Creator:   	 yangyongtao
/// CreateDate:  2016-05-26
/// Input:  	 药物报告id  
/// Return：  	 药物报告信息   
/// Others:		 w ##class(web.DHCADVMADRREPORT).getMadrRepExportInfo("184")
ClassMethod getMadrRepExportInfo(advdrID As %String) As %String
{
	Q:'$d(^DHCADVDRUGREP(advdrID)) ""
	S advdrRepCode=$p(^DHCADVDRUGREP(advdrID),"^",1)   //编号
	S advdrPriority=$p(^DHCADVDRUGREP(advdrID),"^",2) //首次报告 报告优先级
	S advdrPriority=$S(advdrPriority="10":"首次报告",advdrPriority="11":"跟踪报告",1:"")
	S advdrRepType=$p(^DHCADVDRUGREP(advdrID),"^",3)  //报告类型 一般，严重
	S advdrRepType=$S(advdrRepType="10":"一般",advdrRepType="11":"严重",1:"")
	s advdrDamSit=$p(^DHCADVDRUGREP(advdrID),"^",4)   //严重时损伤
	S advdrDeptType=$p(^DHCADVDRUGREP(advdrID),"^",5) //报告单位类型
	S advdrDeptType=$S(advdrDeptType="10":"医疗机构",advdrDeptType="11":"经营企业",advdrDeptType="12":"生产企业",advdrDeptType="13":"个人",advdrDeptType="99":"其他",1:"")
	S advdrDeptElse=$p(^DHCADVDRUGREP(advdrID),"^",6) //报告单位其它类型描述	
    S advdrAdm=$p(^DHCADVDRUGREP(advdrID),"^",7) 	  //就诊adm号
	S advdrPatID=$p(^DHCADVDRUGREP(advdrID),"^",8) 	  //患者ID
	S advdrPatName=$p(^DHCADVDRUGREP(advdrID),"^",9)  //患者姓名
	S advdrPatSex=$p(^DHCADVDRUGREP(advdrID),"^",10)   //性别
	S:advdrPatSex'="" advdrPatSex=$p(^CT("SEX",advdrPatSex),"^",2)
	Q:advdrPatSex="" "-2"
	S advdrPatAge=$p(^DHCADVDRUGREP(advdrID),"^",11)   //年龄
	S advdrPatDOB=$p(^DHCADVDRUGREP(advdrID),"^",12)  //出生日期
	S:advdrPatDOB'="" advdrPatDOB=##class(web.DHCADVCOMMON).DateLogicalToHtml(advdrPatDOB)
	S advdrNation=$p(^DHCADVDRUGREP(advdrID),"^",13)   //民族
    S advdrPatNation=""
	I advdrNation'="" Q:'$d(^CT("NAT",advdrNation)) "-6"
	I advdrNation'="" S advdrPatNation=$p(^CT("NAT",advdrNation),"^",2)
	S advdrPatWeight=$p(^DHCADVDRUGREP(advdrID),"^",14)   //体重
	S advdrPatContact=$p(^DHCADVDRUGREP(advdrID),"^",15)  //联系方式
	S Hospital=$p(^DHCADVDRUGREP(advdrID),"^",16)        //医院代码
	S advdrHosp=""     
	I Hospital'="" S advdrHosp=$p(^CT("HOSP",Hospital),"^",2) //医院名称
	
	S advdrPatMedNo=$p(^DHCADVDRUGREP(advdrID),"^",17)    //病历号
	
	S advdrImport=..getMadrExpImpInfo(advdrID)  //相关重要信息
	S advdrImportInfo=$p(advdrImport,"^",1)  //重要信息
	S advdrImportInfoOth=$p(advdrImport,"^",2)   //其他
	
	
	S advdrEvtHis=$p(^DHCADVDRUGREP(advdrID),"^",19)  //既往药品不良反应事件
	S advdrEvtHis=$S(advdrEvtHis="10":"有",advdrEvtHis="11":"无",advdrEvtHis="12":"不详",1:"")
	S advdrEvtHisDesc=$p(^DHCADVDRUGREP(advdrID),"^",20) //既往药品不良反应事件描述
	S advdrEvtFam=$p(^DHCADVDRUGREP(advdrID),"^",21)   //家族药品不良反应事件
    S advdrEvtFam=$S(advdrEvtFam="10":"有",advdrEvtFam="11":"无",advdrEvtFam="12":"不详",1:"")
	S advdrEvtFamDesc=$p(^DHCADVDRUGREP(advdrID),"^",22) //家族药品不良反应事件描述
	
	S advdrEventDr=$p(^DHCADVDRUGREP(advdrID),"^",23) 		//事件名称
	S advdrEvtDateOcc=$p(^DHCADVDRUGREP(advdrID),"^",24) 	//事件发生日期
	S:advdrEvtDateOcc'="" advdrEvtDateOcc=##class(web.DHCADVCOMMON).DateLogicalToHtml(advdrEvtDateOcc)
		
	S advdrTimeOccu=$p(^DHCADVDRUGREP(advdrID),"^",25)       //事件发生时间
	S:advdrTimeOccu'="" advdrTimeOccu=$zt(advdrTimeOccu,1)
	S advdrEvtRes=$p(^DHCADVDRUGREP(advdrID),"^",26) 		//事件的结果
	
	S advdrEvtRes=$S(advdrEvtRes="10":"痊愈",advdrEvtRes="11":"好转",advdrEvtRes="12":"未好转",advdrEvtRes="99":"不详",advdrEvtRes="13":"有后疑症",advdrEvtRes="14":"死亡",1:"")
	
	S advdrEvtResDesc=$p(^DHCADVDRUGREP(advdrID),"^",27)    //事件的结果描述
	
	S advdrEvtDRes=$p(^DHCADVDRUGREP(advdrID),"^",28)       //好转(死亡)日期
	S:advdrEvtDRes'="" advdrEvtDRes=##class(web.DHCADVCOMMON).DateLogicalToHtml(advdrEvtDRes)
	S advdrEvtTRes=$p(^DHCADVDRUGREP(advdrID),"^",29)       //好转(死亡)时间
	S:advdrEvtTRes'="" advdrEvtTRes=$zt(advdrEvtTRes,1)
	S advdrEvtSRes=$p(^DHCADVDRUGREP(advdrID),"^",30)       //停药后是否减轻
	S advdrEvtSRes=$S(advdrEvtSRes="10":"是",advdrEvtSRes="11":"否",advdrEvtSRes="99":"不明",advdrEvtSRes="12":"未停药或未减量",1:"")

	S advdrEvtTakAg=$p(^DHCADVDRUGREP(advdrID),"^",31)      //是否再次出现同样反应
    S advdrEvtTakAg=$S(advdrEvtTakAg="10":"是",advdrEvtTakAg="11":"否",advdrEvtTakAg="99":"不明",advdrEvtTakAg="12":"未再使用",1:"")
	S advdrEvtEff=$p(^DHCADVDRUGREP(advdrID),"^",32)        //对原疾病的影响
    S advdrEvtEff=$S(advdrEvtEff="10":"不明显",advdrEvtEff="11":"病程延长",advdrEvtEff="12":"病情加重",advdrEvtEff="13":"导致后遗症",advdrEvtEff="14":"导致死亡",1:"")
	S advdrEvtCUser=$p(^DHCADVDRUGREP(advdrID),"^",33)  //关联性评价之报告人评价
	S advdrEvtCUser=$S(advdrEvtCUser="10":"肯定",advdrEvtCUser="11":"很可能",advdrEvtCUser="12":"可能",advdrEvtCUser="13":"可能无关",advdrEvtCUser="14":"待评价",advdrEvtCUser="15":"无法评价",1:"")
	S advdrEvtRepUser=$p(^DHCADVDRUGREP(advdrID),"^",34)  //报告人评价签字
	;s userEvtUser=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(advdrEvtRepUser),""))
	;s advdrEvtRepUser=$p(^SSU("SSUSR",userEvtUser),"^",2)
	
	S advdrEvtCDept=$p(^DHCADVDRUGREP(advdrID),"^",35)  //关联性评价之报告单位评价
	S advdrEvtCDept=$S(advdrEvtCDept="10":"肯定",advdrEvtCDept="11":"很可能",advdrEvtCDept="12":"可能",advdrEvtCDept="13":"可能无关",advdrEvtCDept="14":"待评价",advdrEvtCDept="15":"无法评价",1:"")

	;S advdrDeptName="",userDeptName="",advdrEvtRepDept=""
	S advdrEvtRepDept=$p(^DHCADVDRUGREP(advdrID),"^",36)  //报告单位签字
	;I advdrDeptName'="" s userDeptName=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(advdrDeptName),""))
	;I userDeptName'=""  s advdrEvtRepDept=$p(^SSU("SSUSR",userDeptName),"^",2)
	
	S advdrEvtUserOfRepTel=$p(^DHCADVDRUGREP(advdrID),"^",37)  //报告人联系电话
	S advdrEvtCarOfRepUser=$p(^DHCADVDRUGREP(advdrID),"^",38)  //报告人职业
    S advdrEvtCarOfRepUser=$S(advdrEvtCarOfRepUser="10":"医生",advdrEvtCarOfRepUser="11":"药师",advdrEvtCarOfRepUser="12":"护士",advdrEvtCarOfRepUser="13":"其他",1:"")
	S advdrEvtCarOfRepElse=$p(^DHCADVDRUGREP(advdrID),"^",39)  //报告人职业[其他]
	S advdrEvtEOfRepUser=$p(^DHCADVDRUGREP(advdrID),"^",40)    //报告人邮箱
	
	S advdrUserCode=$p(^DHCADVDRUGREP(advdrID),"^",41)           //报告人
	S advdrRepUser=""  S advdrRepUserDesc=""
	I advdrUserCode'="" S advdrRepUser=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(advdrUserCode),""))
	I advdrRepUser'=""  S advdrRepUserDesc=$p(^SSU("SSUSR",advdrRepUser),"^",2)
	
    
     S LocCode=$p(^DHCADVDRUGREP(advdrID),"^",42)     //科室代码
	 S advdrEvtLocOfRep=""  S advdrEvtLocOfRepDesc=""  
	 I LocCode'="" D
	 .S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	 .S advdrEvtLocOfRep=$p(^CTLOC(LocID),"^",1)
	 .S advdrEvtLocOfRepDesc=$p(^CTLOC(LocID),"^",2)
    
	
	S advdrEvtProTitOfRep=$p(^DHCADVDRUGREP(advdrID),"^",43)   //报告人职称
	
	S advdrEvtProDeptName=$p(^DHCADVDRUGREP(advdrID),"^",44) //报告单位名称
	
	;S userDeptCon=""  S advdrEvtProDeptCon=""
	S advdrEvtProDeptCon=$p(^DHCADVDRUGREP(advdrID),"^",45)  //报告单位联系人
	;I advdrDeptCon'="" S userDeptCon=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(advdrDeptCon),""))
	;I userDeptCon'=""  S advdrEvtProDeptCon=$p(^SSU("SSUSR",userDeptCon),"^",2)
	
	
	S advdrEvtProDeptTel=$p(^DHCADVDRUGREP(advdrID),"^",46)  //报告单位联系电话
    
    S advdrEvtRemark=$p(^DHCADVDRUGREP(advdrID),"^",47)      //备注
    S StatusID=$p(^DHCADVDRUGREP(advdrID),"^",48)   //当前状态    
    
	S advdrReportType=$p(^DHCADVDRUGREP(advdrID),"^",49)   //报告类型
	S advdrTypeDesc=$p(^DHCMEDADREVT(advdrReportType),"^",2)
    
    S advdrImportInfoOth=$p(^DHCADVDRUGREP(advdrID),"^",50) //相关重要信息其他
	S advdrRepDate=$p(^DHCADVDRUGREP(advdrID),"^",51)     //报告日期
	S:advdrRepDate'="" advdrRepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(advdrRepDate) //$zd(advdrRepDate,3)
	S advdrRepTime=$p(^DHCADVDRUGREP(advdrID),"^",52)    //报告时间
	S:advdrRepTime'="" advdrRepTime=$zt(advdrRepTime,1)
	S advdrRepProc=$p(^DHCADVDRUGREP(advdrID),"^",53)   //过程描述
	S advdrRepNew=$p(^DHCADVDRUGREP(advdrID),"^",54)    //报告类型新的 Y N
	I advdrRepNew="Y" S advdrRepNew="新的" 
	S advdrRepImpFlag=$p(^DHCADVDRUGREP(advdrID),"^",55)    //重要标记
	
	S advRepEvent=..getAdvRepEvent(advdrID) //不良反应/事件名称
	S advRepEvent=$p(advRepEvent,"!",2)
	S AdvRepDiag=..getAdvRepDiag(advdrID) //原患疾病
	S AdvRepDiag=$p(AdvRepDiag,"!",2)
	
	S medadrAuditID=$o(^DHCMEDREPADT(0,"Pointer",advdrReportType,advdrID,""),-1)
	I medadrAuditID=""  D
	.S medadrNextLoc=""
	.S medadrLocAdvice=""
	.S medadrReceive=""
	E  D
	.S medadrNextLoc=$p(^DHCMEDREPADT(medadrAuditID),"^",7)
	.S medadrLocAdvice=$p(^DHCMEDREPADT(medadrAuditID),"^",8)
	.S medadrReceive=$p(^DHCMEDREPADT(medadrAuditID),"^",9)
    
    S advRepDrgItm=..getAdvReportExport(advdrID)  //不良反应过程药品信息
    
    S advdrDataList=advdrPriority_"&&"_advdrRepCode_"&&"_advdrRepNew _"&&"_advdrRepType_"&&"_advdrDamSit  //4
    S advdrDataList=advdrDataList_"&&"_advdrDeptType_"&&"_advdrDeptElse_"&&"_advdrPatName_"&&"_advdrPatSex_"&&"_advdrPatDOB //9
    S advdrDataList=advdrDataList_"&&"_advdrPatNation_"&&"_advdrPatWeight_"&&"_advdrPatContact_"&&"_AdvRepDiag_"&&"_advdrHosp  //14
    S advdrDataList=advdrDataList_"&&"_advdrEvtHis_"&&"_advdrEvtHisDesc_"&&"_advdrPatMedNo_"&&"_advdrEvtFam_"&&"_advdrEvtFamDesc //19
    S advdrDataList=advdrDataList_"&&"_advdrImportInfo_"&&"_advdrImportInfoOth_"&&"_advRepEvent  //不良反/应事件名称 //22
    
    S advdrDataList=advdrDataList_"&&"_advdrEvtDateOcc_"&&"_advdrTimeOccu_"&&"_advdrRepProc_"&&"_advdrEvtRes_"&&"_advdrEvtResDesc //27
    S advdrDataList=advdrDataList_"&&"_advdrEvtDRes_"&&"_advdrEvtTRes_"&&"_advdrEvtSRes_"&&"_advdrEvtTakAg_"&&"_advdrEvtEff //32
    S advdrDataList=advdrDataList_"&&"_advdrEvtCUser_"&&"_advdrEvtRepUser_"&&"_advdrEvtCDept_"&&"_advdrEvtRepDept //36
    S advdrDataList=advdrDataList_"&&"_advdrEvtUserOfRepTel_"&&"_advdrEvtCarOfRepUser_"&&"_advdrEvtCarOfRepElse  //39
    S advdrDataList=advdrDataList_"&&"_advdrEvtEOfRepUser_"&&"_advdrRepUserDesc_"&&"_advdrEvtLocOfRepDesc_"&&"_advdrEvtProDeptName //43
    S advdrDataList=advdrDataList_"&&"_advdrEvtProDeptCon_"&&"_advdrEvtProDeptTel_"&&"_advdrRepDate_"&&"_advdrRepTime_"&&"_advdrEvtRemark_"&&"_advRepDrgItm //49
    
    Q advdrDataList
}

/// Descript:获取不良反应报告
/// Creator:     yangyongtao
/// CreateDate:  2016-4-12
/// Table: 		 DHC_AdvDrugRepEvent
/// Input:  	 报告表数据
/// Return： 	 数据id
/// w ##class(web.DHCADVMADRREPORT).getAdvRepEvent("169")
ClassMethod getAdvRepEvent(advdrID) As %String
{
	N (advdrID)
	S tmpStr="",tmpDescStr=""
	S ch=""
	F  S ch=$o(^DHCADVDRUGREP(advdrID,"Event",ch)) Q:ch=""  D
	.S adrEvtDr=$p(^DHCADVDRUGREP(advdrID,"Event",ch),"^",1)
	.S adrEvtRepDesc=$p(^DHCADVDRUGREP(advdrID,"Event",ch),"^",2) //描述
	.
	.I tmpDescStr="" S tmpDescStr=adrEvtRepDesc
	.E  S tmpDescStr=tmpDescStr_","_adrEvtRepDesc
	.I tmpStr="" S tmpStr=adrEvtDr_"^"_adrEvtRepDesc
	.E  S tmpStr=tmpStr_"||"_adrEvtDr_"^"_adrEvtRepDesc
	Q tmpStr_"!"_tmpDescStr
}

/// Descript:获取原患疾病
/// Creator:     yangyongtao
/// CreateDate:  2016-7-27
/// Table: 		 DHC_AdvDrugRepDiag
/// Input:  	     报告表数据
/// Return： 	 数据id    	.S childSub=$o(^DHCADVDRUGDI(advdrID,"DIAG",""),-1)+1  
/// w ##class(web.DHCADVMADRREPORT).getAdvRepDiag("184")
ClassMethod getAdvRepDiag(advdrID) As %String
{
	N (advdrID)
	S tmpStr="",tmpDescStr=""
	S ch=""
	F  S ch=$o(^DHCADVDRUGDI(advdrID,"DIAG",ch)) Q:ch=""  D
	.S adrEvtDiagDr=$p(^DHCADVDRUGDI(advdrID,"DIAG",ch),"^",1)
	.S adrEvtDiagDesc=$p(^DHCADVDRUGDI(advdrID,"DIAG",ch),"^",2) //描述
	.
	.I tmpDescStr="" S tmpDescStr=adrEvtDiagDesc
	.E  S tmpDescStr=tmpDescStr_","_adrEvtDiagDesc
	.I tmpStr="" S tmpStr=adrEvtDiagDr_"^"_adrEvtDiagDesc
	.E  S tmpStr=tmpStr_"||"_adrEvtDiagDr_"^"_adrEvtDiagDesc
	Q tmpStr_"!"_tmpDescStr
}

/// Descript:获取导出药物信息
/// Creator:     yangyongtao
/// CreateDate:  2016-4-12
/// Table: 		 DHC_AdvDrugRepItm
/// Input:  	 报告表数据
/// Return： 	 数据id
/// w ##class(web.DHCADVMADRREPORT).getAdvReportExport("168")
ClassMethod getAdvReportExport(advdrID As %String) As %String
{
		
	N (advdrID)
	Q:'$d(^DHCADVDRUGREP(advdrID)) ""
	S advRepDrgStr=""
	S ch=""
	F  S ch=$o(^DHCADVDRUGREP(advdrID,"Drug",ch)) Q:ch=""  D
	.S type=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",1) //类型
	.S type=$S(type="10":"怀疑",type="11":"并用",1:"")
	.S oeori=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",2) //医嘱ID
	.S apprdocu=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",3) //批准文号
	.S phcddr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",4) //药学项ID
	.S goodsname=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",5) //商品名
	.S goodsname=$p(goodsname,"(",1)
	.S genericdr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",6) //通用名ID
	.i genericdr'="" S genenic=$p($g(^PHCGE("GE",genericdr)),"^",2) //通用名
	.S formdr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",7) //剂型
	.i formdr'=""  s form=$p(^PHCF(formdr),"^",2)
	.S form=$tr(form,$C(13,10))
	.S manfdr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",8) //产地
	.S manf=""
	.S:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
	.S:manf["-" manf=$p(manf,"-",2)
	.S productno=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",9) //批号
	.S dosage=+$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",10) //剂量
	.S dosageuomdr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",11) //剂量单位
	.i dosageuomdr'="" S doseuom=$p($g(^CT("UOM",dosageuomdr)),"^",2)
	.S instrucdr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",12) //用法
	.i formdr'="" S instru=$p($g(^PHCIN(instrucdr)),"^",2)
	.S freqdr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",13) //频次
	.i freqdr'="" S freq=$p($g(^PHCFR(freqdr)),"^",3)
	.S startdate=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",14)  //开始日期
	.S:startdate'="" startdate=##class(web.DHCADVCOMMON).DateLogicalToHtml(startdate)
	.//S starttime=$p(^DHCADVDRUGREP(adrRepID,"Drug",ch),"^",15)  //开始时间
	.//S starttime=$zdh(startdate,3)_" "_$zt(starttime,3)
	.S enddate=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",16)  //结束日期
	.S:enddate'="" enddate=##class(web.DHCADVCOMMON).DateLogicalToHtml(enddate)
	.//S endtime=$p(^DHCADVDRUGREP(adrRepID,"Drug",ch),"^",17)  //结束时间
	.//S endtime=$zdh(enddate,3)_" "_$zt(endtime,1)
	.S reasondr=""
	.//S reasondr=$p(^DHCPHADRR(advdrID,"Drug",ch),"^",18)  //原因ID
	.//i reasondr'="" S reason=$p(^DHCPHADRRM(reasondr),"^",2)
	.S reason=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",19)  //原因
	.S ListData=type_"^"_apprdocu_"^"_phcddr_"^"_goodsname_"^"_manfdr_"^"_$g(manf)_"^"_formdr
	.S ListData=ListData_"^"_genericdr_"^"_$g(genenic)_" "_$g(form)_"^"_dosage_$g(doseuom)_"/"_$g(instru)_"/"_$g(freq)_"^"_instrucdr_"^"_freqdr
	.S ListData=ListData_"^"_dosageuomdr_"^"_startdate_"^"_enddate_"^"_reasondr_"^"_$g(reason)_"^"_productno
	.i advRepDrgStr="" S advRepDrgStr=ListData
	.E  S advRepDrgStr=advRepDrgStr_"||"_ListData
	 Q advRepDrgStr
}

/// Descript:获取不良反应报告药物信息
/// Creator:     yangyongtao
/// CreateDate:  2016-4-12
/// Table: 		 DHC_AdvDrugRepItm
/// Input:  	 报告表数据
/// Return： 	 数据id
/// w ##class(web.DHCADVMADRREPORT).getAdvRepDrgItm("10","243")
ClassMethod getAdvRepDrgItm(intype As %String, advdrID As %String) As %String
{
	N (intype,advdrID)

	S pid=##class(web.DHCADVCOMMON).NewPid()
	d ..killTmpGlobal(pid)

	S Num=0
	S ch=""
	F  S ch=$o(^DHCADVDRUGREP(advdrID,"Drug",ch)) Q:ch=""  D
	.S type=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",1) //类型
	.Q:type'=intype
	.S oeori=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",2) //医嘱ID
	.S apprdocu=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",3) //批准文号
	.S phcddr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",4) //药学项ID
	.S goodsname=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",5) //商品名
	.S genericdr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",6) //通用名ID
	.i genericdr'="" S genenic=$p($g(^PHCGE("GE",genericdr)),"^",2) //通用名
	.S formdr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",7) //剂型
	.i formdr'=""  s form=$p(^PHCF(formdr),"^",2)
	.S manfdr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",8) //产地
	.S manf=""
	.S:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
	.S:manf["-" manf=$p(manf,"-",2)
	.S productno=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",9) //批号
	.S dosage=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",10) //剂量
	.S dosageuomdr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",11) //剂量单位
	.i dosageuomdr'="" S doseuom=$p($g(^CT("UOM",dosageuomdr)),"^",2)
	.S instrucdr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",12) //用法
	.i formdr'="" S instru=$p($g(^PHCIN(instrucdr)),"^",2)
	.S freqdr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",13) //频次
	.i freqdr'="" S freq=$p($g(^PHCFR(freqdr)),"^",3)
	.S startdate=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",14)  //开始日期
	.S:startdate'="" startdate=##class(web.DHCADVCOMMON).DateLogicalToHtml(startdate)
	.//S starttime=$p(^DHCPHADRR(advdrID,"Drug",ch),"^",15)  //开始时间
	.//S starttime=$zdh(startdate,3)_" "_$zt(starttime,3)
	.S enddate=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",16)  //结束日期
	.S:enddate'="" enddate=##class(web.DHCADVCOMMON).DateLogicalToHtml(enddate)
	.//S endtime=$p(^DHCPHADRR(advdrID,"Drug",ch),"^",17)  //结束时间
	.//S endtime=$zdh(enddate,3)_" "_$zt(endtime,1)
	.S reason=""
	.S reasondr=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",18)  //原因ID
	.i reasondr'="" S reason=$p(^DHCPHADRRM(reasondr),"^",2)
	.i reasondr=""  S reason=$p(^DHCADVDRUGREP(advdrID,"Drug",ch),"^",19)  //原因
	.S dgID=$S(type="10":"susdrgdg",type="11":"blenddg")
	.S ListData=oeori_"^"_apprdocu_"^"_phcddr_"^"_goodsname_"^"_manfdr_"^"_$g(manf)_"^"_formdr
	.S ListData=ListData_"^"_genericdr_"^"_$g(genenic)_" "_$g(form)_"^"_dosage_"/"_$g(instru)_"/"_$g(freq)_"^"_instrucdr_"^"_freqdr
	.S ListData=ListData_"^"_dosageuomdr_"^"_startdate_"^"_enddate_"^"_reasondr_"^"_$g(reason)_"^"_productno_"^"_dgID_"^"_dosage
	.;b ;22222
	.S Num=Num+1
	.S ^TMP("DHCADV","web.DHCADVMADRREPORT","getAdvRepDrgItm",pid,Num)=ListData
	
	i 4>Num d
	.S Len=4-Num
	.f i=1:1:Len d
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVMADRREPORT","getAdvRepDrgItm",pid,Num)=""

	Q:Num="0" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串

	S quitflag=0
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVMADRREPORT","getAdvRepDrgItm",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCADV","web.DHCADVMADRREPORT","getAdvRepDrgItm",pid,index)
	.S Title="orditm^apprdocu^phcdf^incidesc^manfdr^manf^formdr^genenicdr^genenic^usemethod^instrudr^freqdr^dosuomID^starttime^endtime^reasondr^usereason^batno^dgID^dosage"
	.S Num=Num+1
	.//Q:Num<StPage
	.//S:Num=EndPage quitflag=1
	.I Num=1 d 
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Description: 添加 不良反应相关药物报告表
/// Creator:     yangyongtao
/// CreateDate:  2016-4-11
/// Table: 		 DHC_AdvDrugRepItm
/// Input:  	 报告表数据
/// Return： 	 数据id
/// Others:		 w ##class(web.DHCADVMADRREPORT).InsAdvRepDrugItm("239","10^651||5^1040^国药准字H12020593-^维生素B2片[飞鹰][5mg*100片]^948^32^131^07111823^5mg/口服/Qdmg/口服/Qdmg/口服/Qdmg/口服/Qd^149^2^4^2016-07-11^2016-07-31^^用药原因!!10^651||6^1035^国药准字H33020234-^维生素A胶丸[2.5万iu*100粒]^943^5^325^07111825^2.5万IU/口服/Qd万IU/口服/Qd万IU/口服/Qd万IU/口服/Qd^153^2^4^2016-07-11^2016-07-31^^用药原因!!10^651||7^1903^国药准字H32021769^亚硫酸氢钠甲萘醌注射液[4mg:1ml]^1277^45^213^07111821*10^1mg/注射/Qdmg/注射/Qdmg/注射/Qdmg/注射/Qd^149^4^4^2016-07-11^2016-07-31^^用药原因")
ClassMethod InsAdvRepDrugItm(advdrID As %String, advdrRepItmStr As %String) As %String
{
	N (advdrID,advdrRepItmStr)
	S Len=$L(advdrRepItmStr,"!!")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S tmpStr=$p(advdrRepItmStr,"!!",i)
	.S type=$p(tmpStr,"^",1)   //类型
	.S oeori=$p(tmpStr,"^",2)  //医嘱ID
	.S phcid=$p(tmpStr,"^",3)     //药学项ID
	.S apprdocu=$p(tmpStr,"^",4)  //批准文号
	.S goodname=$p(tmpStr,"^",5)  //商品名称
	.S genericdr=$p(tmpStr,"^",6) //通用名
	.S phformdr=$p(tmpStr,"^",7)  //剂型
	.S manfdr=$p(tmpStr,"^",8)    //生产厂家
	.S productno=$p(tmpStr,"^",9) //生产批号
	.S dosage=$p(tmpStr,"^",10)    //剂量
	.S dosuomdr=$p(tmpStr,"^",11)  //剂量单位
	.S instrucdr=$p(tmpStr,"^",12) //途径(用法)
	.S freqdr=$p(tmpStr,"^",13)    //日次数(频次)
	.S startdate=$p(tmpStr,"^",14) //用药起始日期
	.S:startdate'="" startdate=##class(web.DHCADVCOMMON).DateHtmlToLogical(startdate)
	.S starttime=""
	.S enddate=$p(tmpStr,"^",15)   //用药结束日期
	.S:enddate'="" enddate=##class(web.DHCADVCOMMON).DateHtmlToLogical(enddate)
	.S endtime=""
	.S reasondr=$p(tmpStr,"^",16)  //用药原因
	.S reason=$p(tmpStr,"^",17)    //用药原因
	.S childSub=$o(^DHCADVDRUGREP(advdrID,"Drug",""),-1)+1
	.&SQL(Insert into DHC_AdvDrugRepItm(ADVDRI_ADRR_Parref,ADVDRI_ChildSub,ADVDRI_Type,ADVDRI_OEORI_DR,ADVDRI_ApprDocu,
		ADVDRI_PHCD_DR,ADVDRI_GoodsName,ADVDRI_Generic_DR,ADVDRI_PhForm_DR,ADVDRI_Manf_DR,ADVDRI_ProductNo,ADVDRI_Dosage,
		ADVDRI_DosUom_DR,ADVDRI_Instruc_DR,ADVDRI_Freq_DR,ADVDRI_StartDate,ADVDRI_StartTime,ADVDRI_EndDate,ADVDRI_EndTime,
		ADVDRI_Reason_DR,ADVDRI_Reason) 
		Values(:advdrID,:childSub,:type,:oeori,:apprdocu,:phcid,:goodname,:genericdr,:phformdr,:manfdr,:productno,
		:dosage,:dosuomdr,:instrucdr,:freqdr,:startdate,:starttime,:enddate,:endtime,:reasondr,:reason))
	.i SQLCODE'=0 S quitflag="1"
	Q quitflag
}

/// Description: 添加 不良反应报告事件信息报告表
/// Creator:     yangyongtao
/// CreateDate:  2016-4-11
/// Table: 		 DHC_AdvDrugRepEvent
/// Input:  	 报告表数据
/// Return： 	 数据id
/// Others:		 w ##class(web.DHCADVMADRREPORT).InsAdvRepEvent("")
ClassMethod InsAdvRepEvent(advdrID As %String, advRepEvtItems As %String) As %String
{
	N (advdrID,advRepEvtItems)
	S Len=$L(advRepEvtItems,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S advEvtItms=$p(advRepEvtItems,"||",i)
	.S addvEvtDr=$p(advEvtItms,"^",1)       //事件代码
	.S addvEvtDesc=$p(advEvtItms,"^",2)     //事件描述
	.S childSub=$o(^DHCADVDRUGREP(advdrID,"Event",""),-1)+1
	.&SQL(Insert into DHC_AdvDrugRepEvent(ADVDRE_ADRR_Parref,ADVDRE_ChildSub,ADVDRE_ADRE_DR,ADVDRE_Desc)
		Values(:advdrID,:childSub,:addvEvtDr,:addvEvtDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Description: 添加 不良反应报告患者诊断信息
/// Creator:     yangyongtao
/// CreateDate:  2016-7-27
/// Table: 		 DHC_AdvDrugRepDiag
/// Input:  	 报告表数据
/// Return： 	 数据id
/// Others:		 w ##class(web.DHCADVMADRREPORT).InsAdvRepDiag("279","^感冒")
ClassMethod InsAdvRepDiag(advdrID As %String, advRepMRCICItms As %String) As %String
{
	N (advdrID,advRepMRCICItms)
	S Len=$L(advRepMRCICItms,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S MRCICItms=$p(advRepMRCICItms,"||",i)
	.S advdrICDCodeDr=$p(MRCICItms,"^",1) //诊断
	.S advdrDDesc=$p(MRCICItms,"^",2)     //诊断描述
	.Q:(advdrICDCodeDr="")&(advdrDDesc="")
	.S childSub=$o(^DHCADVDRUGDI(advdrID,"DIAG",""),-1)+1  
	.&SQL(Insert into DHC_AdvDrugRepDiag(ADVDRD_ADRR_Parref,ADVDRD_ChildSub,ADVDRD_ICDCode_DR,ADVDRD_Desc)
		Values(:advdrID,:childSub,:advdrICDCodeDr,:advdrDDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCADV","web.DHCADVMADRREPORT","getAdvRepDrgItm",pid)
}

/// Description:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCADV("DHCADVMADRREPORT"))
}

/// Description: 获取报告表的重要信息
/// Creator:     yangyongtao
/// CreateDate:  2016-4-10
/// Input:  	 报告表id  
/// Output:  	 此报告所选的项目环节信息   
/// Others:		 w ##class(web.DHCADVMADRREPORT).getMadrImportInfo("12")
ClassMethod getMadrImportInfo(advdrID) As %String
{
	N (advdrID)
	S tmpStr=""
	S advdrImport=$p(^DHCADVDRUGREP(advdrID),"^",18) //重要信息
	S advdrImportOtherDesc=$p(^DHCADVDRUGREP(advdrID),"^",50) //其他
	S ListData=advdrImport_"^"_advdrImportOtherDesc
	
	I tmpStr="" S tmpStr=ListData
	E  S tmpStr=tmpStr_","_ListData
	Q tmpStr
}

/// Description: 获取页面默认信息（日期，编码） 
/// Creator:     yangyongtao
/// CreateDate:  2016-3-31
/// Input: 		 params : 以字符"^"分割,格式为:人员id^科室id^安全组id^报告类型代码
/// Return: 	 页面默认信息: 以字符"^"分割,格式为:报告编码^报告日期^报告初始状态^报告类型^科室描述
/// Others:		 w ##class(web.DHCADVMADRREPORT).getMadrInfo()
ClassMethod getMadrInfo(params As %String) As %String
{
	N (params)
	S repdate=$zdt($H,3)
	S Prefix="DRUGADV"_$zd(+$H,8)  //报告编码规则 "DRUGADV"+年月日+顺序号
	S MataReportNo=..GetAdrReportCurMaxNo(Prefix,"3")	
	
	S List=##class(web.DHCADVCOMMON).GetStatusDr(params)
	Q:List="" -1
	S MataReportType=$p(List,"^",1)  //报告类型
	S MatadrInitStatDR=$p(List,"^",2)  //审核状态
	
	S UserID=$p(params,"^",1)  //科室ID
	I UserID'="" D
	.S CreatorCareProvDr=$p(^SSU("SSUSR",UserID),"^",9)
	.I CreatorCareProvDr'=""  D
	..S CtpcpCarPrvTpDR=$p(^CTPCP(CreatorCareProvDr,1),"^",4)
	..I CtpcpCarPrvTpDR'="" D
	...S CreatorCareProv=$p(^CT("CPT",CtpcpCarPrvTpDR),"^",1)
	..
	.E  D
	..S CreatorCareProv=""
	
	S LocID=$p(params,"^",2)  //科室ID
	I LocID'="" D
	.S LocDesc=$p(^CTLOC(LocID),"^",2)
	
	Q MataReportNo_"^"_repdate_"^"_MatadrInitStatDR_"^"_MataReportType_"^"_$g(LocDesc)_"^"_CreatorCareProv_"^"_UserID_"^"_LocID
}

/// Description: 取当前不良反应报告最大码
/// Creator:     yangyongtao
/// CreateDate:  2016-3-31
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
/// Creator:     yangyongtao
/// CreateDate:  2016-3-31
/// Input:  	 报告编码规则,编码数字长度
/// Return:  	 当前不良反应报告最大码  
ClassMethod GetMaxCodeByCode(Prefix As %String) As %String
{
	N (Prefix)
	Q:Prefix="" ""
	S matacode=""
	&sql(select max(ADVDR_Code) into matacode from DHC_AdvDrugReport Where ADVDR_Code %STARTSWITH %ALPHAUP :Prefix)
	Q matacode
}

/// Description: 检查报告编码是否存在
/// Creator:     CongYue
/// CreateDate:  2016-05-04
/// Table:		 DHC_MatAdrReport
/// Input:  	 params :报告编码
/// Output:		 0 不存在  1 存在
/// Others:		 w ##class(web.DHCADVMADRREPORT).SearchRepNoRepet("DRUGADV20160421001")
ClassMethod SearchRepNoRepet(RepNo As %String) As %String
{
	N (RepNo)
	S flag=0
	I $d(^DHCADVDRUGREP(0,"RepNo",RepNo)) D
	.S flag=1
	Q flag
}

/// ========================================================================================================
/// Descript:保存不良反应报表 (shuai)
/// Creator:     yangyongtao
/// CreateDate:  2016-4-8
/// Table: 		 DHC_AdvDrugReport
/// w ##class(web.DHCSTPHCMADRREPORT).SaveAdvEvent("","^^^10^^10^mic9^2^21岁^1995-05-28^1^^^0000000010^11^^11^^^2016-06-15^^^^^^^^^蒋荣猛^^^^^^^北京地坛医院^蒋荣猛^^2016-06-15^^^^^^^63","||||12||||||||^","","^1.赖氏综合征","^[]","^^^","")
ClassMethod SaveAdvEvent(adrRepID As %String, adrRepDataList As %String, adrRepImpInfodataList As %String, adrRepItmStr As %String, adrRepMRCICItms As %String, adrRepEvtItems As %String, adrrEvtProcessDesc As %String, adrRepAuditList As %String) As %String
{
	n (adrRepID,adrRepDataList,adrRepImpInfodataList,adrRepItmStr,adrRepMRCICItms,adrRepEvtItems,adrrEvtProcessDesc,adrRepAuditList)
	s ret=0
	i adrRepID="" d
	.S ret=..Inserts(adrRepDataList,adrRepImpInfodataList,adrRepItmStr,adrRepEvtItems,adrrEvtProcessDesc)
	e  d
	.S ret=..Updates(adrRepID,adrRepDataList,adrRepImpInfodataList,adrRepItmStr,adrRepEvtItems,adrrEvtProcessDesc)
	q ##class(web.DHCADVJSONCOMMON).getJsonData("ErrCode^AdrRepID^AdrRepCode",ret)
}

/// Descript:保存不良反应报表
/// Creator:     yangyongtao
/// CreateDate:  2016-4-8
/// Table: 		 DHC_AdvDrugReport
ClassMethod Inserts(adrRepDataList As %String, adrRepImpInfodataList As %String, adrRepItmStr As %String, adrRepEvtItems As %String, adrrEvtProcessDesc As %String, adrRepAuditList As %String) As %String
{
	N (adrRepDataList,adrRepImpInfodataList,adrRepItmStr,adrRepEvtItems,adrrEvtProcessDesc,adrRepAuditList)
	s Err=0

	TS
	s adrrepID=..InsAdvReport(adrRepDataList,adrRepImpInfodataList,adrrEvtProcessDesc)
	i adrrepID<0 tro
	q:adrrepID<0 adrrepID
	
	//不良反应报告药品明细
	i adrRepItmStr'="" d  
	.s Err=..InsAdvRepDrugItm(adrrepID,adrRepItmStr)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	//不良反应事件信息
	i adrRepEvtItems'="" d
	.s Err=..InsAdvRepEvent(adrrepID,adrRepEvtItems)
	i Err'=0 tro
	q:Err'=0 "-16"
	
	//更新状态
	S typedr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4("drug"),""))
	S adtList=adrrepID_"^"_typedr_"^"_$p(adrRepAuditList,"^",2)_"^"_"1"_"^"_"1"
    S nextStatuDr=""
	I adrRepAuditList'="" D
	.S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(adtList)
	I (adrRepAuditList'="")&(+nextStatuDr'>0) tro
	Q:(adrRepAuditList'="")&(+nextStatuDr'>0) nextStatuDr
	I adrRepAuditList'="" D
	.&sql(update DHC_AdvDrugReport set ADVDR_CurStatus_DR=:nextStatuDr where ADVDR_RowID=:adrrepID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 S Err="-17"
	Q:Err'=0 "-17"
	;b ;11
	;S advdrRepAuditList=nextStatuDr_"^"_$p(advdrRepAuditList,"^",2,8)
	
#;	//不良反应报告审批流程[默认插入初始状态]
#;	I adrRepAuditList'="" D
#;	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(adrrepID,adrRepAuditList)
#;	I Err'=0 tro
#;	Q:Err'=0 "-18"
	
	TC
	Q "0"
}

/// Descript:保存不良反应报表
/// Creator:     yangyongtao
/// CreateDate:  2016-4-8
/// Table: 		 DHC_AdvDrugReport
ClassMethod Updates(adrrepID As %String, adrRepDataList As %String, adrRepImpInfodataList As %String, adrRepItmStr As %String, adrRepEvtItems As %String, adrrEvtProcessDesc As %String) As %String
{
	N (adrrepID,adrRepDataList,adrRepImpInfodataList,adrRepItmStr,adrRepEvtItems,adrrEvtProcessDesc)
	s Err=0

	TS
	s adrrepID=..UpdAdvReport(adrrepID,adrRepDataList,adrRepImpInfodataList,adrrEvtProcessDesc)
	i adrrepID<0 tro
	q:adrrepID<0 adrrepID
	
	
	//删除相关子表
	s Err=..DelAdvRelatInfo(adrrepID)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//不良反应报告药品明细
	i adrRepItmStr'="" d
	.s Err=..InsAdvRepDrugItm(adrrepID,adrRepItmStr)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	//不良反应事件信息
	i adrRepEvtItems'="" d
	.s Err=..InsAdvRepEvent(adrrepID,adrRepEvtItems)
	i Err'=0 tro
	q:Err'=0 "-16"
	
	//更新状态
	S adtList=advdrID_"^"_$p(advdrRepAuditList,"^",8)_"^"_$p(advdrRepAuditList,"^",2)_"^"_$p(advdrRepAuditList,"^",3)_"^"_$p(advdrRepAuditList,"^",4)
    S nextStatuDr=""
	I advdrRepAuditList'="" D
	.S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(adtList)
	S ^TMP("yangyongtao")=advdrRepAuditList
	I (advdrRepAuditList'="")&(+nextStatuDr'>0) tro
	Q:(advdrRepAuditList'="")&(+nextStatuDr'>0) nextStatuDr
	
	I advdrRepAuditList'="" D
	.&sql(update DHC_AdvDrugReport set ADVDR_CurStatus_DR=:nextStatuDr where ADVDR_RowID=:advdrID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 s Err="-17"
	
	Q:Err'=0 "-17"
	
	S advdrRepAuditList=nextStatuDr_"^"_$p(advdrRepAuditList,"^",2,8)
	
	//不良反应报告审批流程[默认插入初始状态]
	I advdrRepAuditList'="" D
	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(advdrID,advdrRepAuditList)
	I Err'=0 tro
	Q:Err'=0 "-18"
	TC
	Q "0^"_adrrepID
}

/// Description: 添加 药品不良事件报告表(shuai)
/// Creator:     yangyongtao
/// CreateDate:  2016-4-8
/// Table: 		 DHC_AdvDrugReport
/// Input:  	 报告表数据
/// Return： 	 数据id
/// Others:		 w ##class(web.DHCSTPHCMADRREPORT).InsMadrReport("","","10||11||12||13||14||15||99^流感","","","","")
ClassMethod InsAdvReport(dataList As %String, adrRepImpInfodataList As %String, adrrEvtProcessDesc As %String) As %String
{
   N (dataList,adrRepImpInfodataList,adrrEvtProcessDesc)
	
    //获取报告类型
	S typeID="0"
	F  S typeID=$o(^DHCMEDADREVT(typeID))  Q:typeID=""  D
	.S typeCode=$p(^DHCMEDADREVT(typeID),"^",1)
	.;S type=$p(^DHCMEDADREVT(typeID),"^",2)
	.I typeCode="drug" S typeEvent=typeID

	
	//获取相关重要信息
	f i=1:1:$l(adrRepImpInfodataList,"^") d
	.S ImpInfoList=$p(adrRepImpInfodataList,"^",i)
	.S ImpInfos=$p(adrRepImpInfodataList,"^",1) 
	.s ImpInfoOth=$p(adrRepImpInfodataList,"^",2)
	f i=1:1:$l(ImpInfos,"||") d
	.S List=$p(ImpInfos,"||",i)
	.S smokhis=$p(ImpInfos,"||",1)
	.S drinhis=$p(ImpInfos,"||",2)
	.S gestper=$p(ImpInfos,"||",3)
	.S hepahis=$p(ImpInfos,"||",4)
	.S nephhis=$p(ImpInfos,"||",5)
	.S allehis=$p(ImpInfos,"||",6)
	.S iiothers=$p(ImpInfos,"||",7)
	s ImpInfodata=smokhis_","_drinhis_","_gestper_","_hepahis_","_nephhis_","_allehis_","_iiothers
   
    //获取过程描述
    f i=1:1:$l(adrrEvtProcessDesc,"^") d
	.S EvtProcess=$p(adrrEvtProcessDesc,"^",i)
	.S adrrTherapMeas=$p(adrrEvtProcessDesc,"^",1) 
	.s adrrSymptom=$p(adrrEvtProcessDesc,"^",2)
    .s adrrOtherExplanation=$p(adrrEvtProcessDesc,"^",3)
    .s adrrProcessDesc=$p(adrrEvtProcessDesc,"^",4)
    s ProcessDesc=adrrTherapMeas_","_adrrSymptom_","_adrrOtherExplanation_","_adrrProcessDesc


	S adrrRepCode=..GetAdvReportCurMaxNo("ADR"_$zd(+$H,8),"3")
	S adrrRepDate=+$H //报告日期
	S adrrPriority=$p(dataList,"^",2) //首次报告
	S adrrRepType=$p(dataList,"^",3)  //报告类型 
	S adrrDeptType=$p(dataList,"^",4) //报告单位类型
	S adrrDeptElse=$p(dataList,"^",5) //报告单位其它类型描述	

	S adrrPatID=$p(dataList,"^",6) 	  //患者ID
	I adrrPatID'="" S AdrPatNo=$p(^PAPER(adrrPatID,"PAT",1),"^",1)       //登记

	S adrrPatName=$p(dataList,"^",7)  //患者姓名
	S adrrPatSex=$p(dataList,"^",8)   //性别
	Q:adrrPatSex="" "-2"
	S adrrPatAge=$p(dataList,"^",9)   //年龄
	S adrrPatDOB=$p(dataList,"^",10)  //出生日期
	S:adrrPatDOB'="" adrrPatDOB=##class(web.DHCADVCOMMON).DateHtmlToLogical(adrrPatDOB)
	S adrrPatNation=$p(dataList,"^",11)   //民族
    Q:adrrPatNation=""
	I adrrPatNation'="" Q:'$d(^CT("NAT",adrrPatNation)) "-6"
	S adrrPatWeight=$p(dataList,"^",12)   //体重
	S adrrPatContact=$p(dataList,"^",13)  //联系方式
	S adrrPatMedNo=$p(dataList,"^",14)    //病历号
	S adrrEvtHis=$p(dataList,"^",15)  //既往药品不良反应事件
	S adrrEvtHisDesc=$p(dataList,"^",16) //既往药品不良反应事件描述
	S adrrEvtFam=$p(dataList,"^",17)   //家族药品不良反应事件
	S adrrEvtFamDesc=$p(dataList,"^",18) //家族药品不良反应事件描述
	S adrrEventDr=$p(dataList,"^",19) 		//事件名称
	S adrrEvtDateOcc=$p(dataList,"^",20) 	//事件发生日期
	S:adrrEvtDateOcc'="" adrrEvtDateOcc=##class(web.DHCADVCOMMON).DateHtmlToLogical(adrrEvtDateOcc)
	S adrrEvtRes=$p(dataList,"^",21) 		//事件的结果
	S adrrEvtResDesc=$p(dataList,"^",22)    //事件的结果描述
	
	S adrrEvtDRes=$p(dataList,"^",23)       //好转(死亡)日期
	S:adrrEvtDRes'="" adrrEvtDRes=##class(web.DHCADVCOMMON).DateHtmlToLogical(adrrEvtDRes)
	S adrrEvtTRes=$p(dataList,"^",24)       //好转(死亡)时间
	S:adrrEvtTRes'="" adrrEvtTRes=$zth(adrrEvtTRes,1)
	S adrrEvtSRes=$p(dataList,"^",25)       //停药后是否减轻
	S adrrEvtTakAg=$p(dataList,"^",26)      //是否再次出现同样反应
	S adrrEvtEff=$p(dataList,"^",27)        //对原疾病的影响

	S adrrEvtCUser=$p(dataList,"^",28)  //关联性评价之报告人评价
	
	S adrrEvtUser=$p(dataList,"^",29)  //报告人评价签字
	s userEvtUser=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(adrrEvtUser),""))
	s adrrEvtRepUser=$p(^SSU("SSUSR",userEvtUser),"^",1)
	
	S adrrEvtCDept=$p(dataList,"^",30)  //关联性评价之报告单位评价
	S adrrEvtRepDept=$p(dataList,"^",31)  //报告单位签字
	
	S adrrEvtUserOfRepTel=$p(dataList,"^",32)  //报告人联系电话
	S adrrEvtCarOfRepUser=$p(dataList,"^",33)  //报告人职业

	S adrrEvtCarOfRepElse=$p(dataList,"^",34)  //报告人职业[其他]
	S adrrEvtEOfRepUser=$p(dataList,"^",35)    //报告人邮箱
	S LocID=$p(dataList,"^",46)      //报告人所属科室
	S adrrEvtLocOfRep=""
	I LocID'=""  S adrrEvtLocOfRep=$p(^CTLOC(LocID),"^",1)
	
	
	S adrrEvtProTitOfRep="" //$p(dataList,"^",38)   //报告人职称
	S adrrEvtProPosOfRep="" //$p(dataList,"^",39)   //报告人职务
	S adrrEvtProWishes="" //$p(dataList,"^",40)     //填报意愿

	S adrrEvtProDeptName=$p(dataList,"^",36) //报告单位名称
	
	S adrrDeptCon=$p(dataList,"^",37)  //报告单位联系人
	s userDeptCon=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(adrrDeptCon),""))
	s adrrEvtProDeptCon=$p(^SSU("SSUSR",userDeptCon),"^",1)
	
	S adrrEvtProDeptTel=$p(dataList,"^",38)  //报告单位联系电话
	S adrrRepDate=$p(dataList,"^",39)  //报告日期
	S:adrrRepDate'="" adrrRepDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(adrrRepDate)
	S adrrEvtRemark=$p(dataList,"^",42)      //备注
	S adrrEvtCurStatDR=$p(dataList,"^",45)   //当前状态
	S adrrRepTSDesc=$p(dataList,"^",43)   //损害情形
	S adrrRepTypeNew=$p(dataList,"^",44)  //新的

  //ADVDR_Adm,ADVDR_Hosp,ADVDR_ImportInfo,ADVDR_TimeOccu,ADVDR_RepUser,
  //ADVDR_ReportType,,ADVDR_ImportInfoOth,ADVDR_RepDate,ADVDR_RepTime,ADVDR_RepProc
  //ADVDR_PosOfReporter,ADVDR_Wishes,
  ////:adrrEvtProPosOfRep,:adrrEvtProWishes,
	&SQL(Insert Into DHC_AdvDrugReport(ADVDR_Code,ADVDR_RepDate,ADVDR_Priority,ADVDR_RepType,
	   ADVDR_DeptType,ADVDR_DeptElse,ADVDR_PatID,ADVDR_PatName,ADVDR_PatSex,ADVDR_PatAge,
	   ADVDR_PatDOB,ADVDR_PatNation,ADVDR_PatWeight,ADVDR_PatContact,ADVDR_PatMedNo,
	   ADVDR_EventHistory,ADVDR_EventHistDesc,ADVDR_EventFamily,ADVDR_EventFamiDesc,
	   ADVDR_ADRE_Dr,ADVDR_DateOccu,ADVDR_Result,ADVDR_ResultDesc,ADVDR_DateResult,
	   ADVDR_TimeResult,ADVDR_StopResultt,ADVDR_TakingAgain,ADVDR_EffectOfTreatment,
	   ADVDR_CommentOfUser,ADVDR_RepUser,ADVDR_CommentOfDept,ADVDR_DeptOfReport,
	   ADVDR_Telephone,ADVDR_CareerOfRepUser,ADVDR_CareerOfRepElse,ADVDR_EmailOfRepUser,
	   ADVDR_LocOfReporter,ADVDR_ProTitleOfReporter,ADVDR_DeptName, 
	   ADVDR_DeptContacts,ADVDR_DeptTel,ADVDR_Remark,ADVDR_CurStatus_DR,ADVDR_RepNew,ADVDR_DamSit,   
	   ADVDR_ImportInfo,ADVDR_ImportInfoOth,ADVDR_RepProc,ADVDR_ReportType
	  ) Values(:adrrRepCode,:adrrRepDate,:adrrPriority,:adrrRepType,
		:adrrDeptType,:adrrDeptElse,:AdrPatNo,:adrrPatName,:adrrPatSex,:adrrPatAge,
		:adrrPatDOB,:adrrPatNation,:adrrPatWeight,:adrrPatContact,:adrrPatMedNo,
		:adrrEvtHis,:adrrEvtHisDesc,:adrrEvtFam,:adrrEvtFamDesc,
		:adrrEventDr,:adrrEvtDateOcc,:adrrEvtRes,:adrrEvtResDesc,:adrrEvtDRes,
		:adrrEvtTRes,:adrrEvtSRes,:adrrEvtTakAg,:adrrEvtEff,
		:adrrEvtCUser,:adrrEvtRepUser,:adrrEvtCDept,:adrrEvtRepDept,
		:adrrEvtUserOfRepTel,:adrrEvtCarOfRepUser,:adrrEvtCarOfRepElse,:adrrEvtEOfRepUser,
		:adrrEvtLocOfRep,:adrrEvtProTitOfRep,  
		:adrrEvtProDeptName,:adrrEvtProDeptCon,:adrrEvtProDeptTel,:adrrEvtRemark,
		:adrrEvtCurStatDR,:adrrRepTypeNew,:adrrRepTSDesc,:ImpInfodata,:ImpInfoOth,
		:ProcessDesc,:typeEvent
	))

	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 更新 药品不良事件报告表
/// Creator:     yangyongtao
/// CreateDate:  2016-4-8
/// Table: 		 DHC_AdvDrugReport
/// Input:  	 报告表数据
/// Return： 	 数据id
/// Others:		 w ##class(web.DHCADVMADRREPORT).UpdMadrReport("3","MATADR20160407005^10^10^^10^^undefined^0000000001^杜桑^2^^1991-05-28^1^^111111^西安医院^000086^10,11,12,,,,,^11^^11^^药品反应[严重]^2016-04-07^22:06:04^10^^^^10^10^10^10^蒋荣猛^^^1111111111^10^^1111111111^600^63^医师^^^^备注^4||1^2^^2016-04-07^22:06:34")
/// 
ClassMethod UpdAdvReport(adrrRepID As %String, dataList As %String, adrRepImpInfodataList As %String, adrrEvtProcessDesc As %String) As %String
{
	N (adrrRepID,dataList,adrRepImpInfodataList,adrrEvtProcessDesc)
	S adrrRepCode=$p(dataList,"^",1) //报告编号
	S adrrRepDate=+$H //报告日期
	S adrrPriority=$p(dataList,"^",2) //首次报告
	S adrrRepType=$p(dataList,"^",3)  //报告类型 
	S adrrDeptType=$p(dataList,"^",4) //报告单位类型
	S adrrDeptElse=$p(dataList,"^",5) //报告单位其它类型描述	

   	S adrrPatID=$p(dataList,"^",6) 	  //患者ID
	
	I adrrPatID'="" S AdrPatNo=$p(^PAPER(adrrPatID,"PAT",1),"^",1)       //登记
	;Q:'$d(^PAPER(adrrPatID)) "-1"
	S adrrPatName=$p(dataList,"^",7)  //患者姓名
	S adrrPatSex=$p(dataList,"^",8)   //性别
	Q:adrrPatSex="" "-2"
	S adrrPatAge=$p(dataList,"^",9)   //年龄
	S adrrPatDOB=$p(dataList,"^",10)  //出生日期
	
	S:adrrPatDOB'="" adrrPatDOB=##class(web.DHCADVCOMMON).DateHtmlToLogical(adrrPatDOB)
	S adrrPatNation=$p(dataList,"^",11)   //民族
	Q:adrrPatNation=""
	I adrrPatNation'="" Q:'$d(^CT("NAT",adrrPatNation)) "-6"
	S adrrPatWeight=$p(dataList,"^",12)   //体重
	S adrrPatContact=$p(dataList,"^",13)  //联系方式
	S adrrPatMedNo=$p(dataList,"^",14)    //病历号
	
	S adrrEvtHis=$p(dataList,"^",15)  //既往药品不良反应事件
	S adrrEvtHisDesc=$p(dataList,"^",16) //既往药品不良反应事件描述
	S adrrEvtFam=$p(dataList,"^",17)   //家族药品不良反应事件
	S adrrEvtFamDesc=$p(dataList,"^",18) //家族药品不良反应事件描述
	S adrrEventDr=$p(dataList,"^",19) 		//事件名称
	S adrrEvtDateOcc=$p(dataList,"^",20) 	//事件发生日期
	S:adrrEvtDateOcc'="" adrrEvtDateOcc=##class(web.DHCADVCOMMON).DateHtmlToLogical(adrrEvtDateOcc)
	S adrrEvtRes=$p(dataList,"^",21) 		//事件的结果
	S adrrEvtResDesc=$p(dataList,"^",22)    //事件的结果描述
	
	S adrrEvtDRes=$p(dataList,"^",23)       //好转(死亡)日期
	S:adrrEvtDRes'="" adrrEvtDRes=##class(web.DHCADVCOMMON).DateHtmlToLogical(adrrEvtDRes)
	S adrrEvtTRes=$p(dataList,"^",24)       //好转(死亡)时间
	S:adrrEvtTRes'="" adrrEvtTRes=$zth(adrrEvtTRes,1)
	S adrrEvtSRes=$p(dataList,"^",25)       //停药后是否减轻
	S adrrEvtTakAg=$p(dataList,"^",26)      //是否再次出现同样反应
	S adrrEvtEff=$p(dataList,"^",27)        //对原疾病的影响

	S adrrEvtCUser=$p(dataList,"^",28)  //关联性评价之报告人评价
	
	S adrrEvtUser=$p(dataList,"^",29)  //报告人评价签字
	s userEvtUser=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(adrrEvtUser),""))
	s adrrEvtRepUser=$p(^SSU("SSUSR",userEvtUser),"^",1)
	
	S adrrEvtCDept=$p(dataList,"^",30)  //关联性评价之报告单位评价
	S adrrEvtRepDept=$p(dataList,"^",31)  //报告单位签字
	S adrrEvtUserOfRepTel=$p(dataList,"^",32)  //报告人联系电话
	S adrrEvtCarOfRepUser=$p(dataList,"^",33)  //报告人职业

	S adrrEvtCarOfRepElse=$p(dataList,"^",34)  //报告人职业[其他]
	S adrrEvtEOfRepUser=$p(dataList,"^",35)    //报告人邮箱
	
	S LocID=$p(dataList,"^",46)      //报告人所属科室
	S adrrEvtLocOfRep=""
	I LocID'=""  S adrrEvtLocOfRep=$p(^CTLOC(LocID),"^",1)
	
	S adrrEvtProTitOfRep="" //$p(dataList,"^",38)   //报告人职称
	S adrrEvtProPosOfRep="" //$p(dataList,"^",39)   //报告人职务
	S adrrEvtProWishes="" //$p(dataList,"^",40)     //填报意愿

	S adrrEvtProDeptName=$p(dataList,"^",36) //报告单位名称
	
	S adrrDeptCon=$p(dataList,"^",37)  //报告单位联系人
	s userDeptCon=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(adrrDeptCon),""))
	s adrrEvtProDeptCon=$p(^SSU("SSUSR",userDeptCon),"^",1)
	
	S adrrEvtProDeptTel=$p(dataList,"^",38)  //报告单位联系电话
	S adrrRepDate=$p(dataList,"^",39)  //报告日期
	S:adrrRepDate'="" adrrRepDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(adrrRepDate)
	S adrrEvtRemark=$p(dataList,"^",42)      //备注
	S adrrEvtCurStatDR=$p(dataList,"^",45)   //当前状态
	S adrrRepTSDesc=$p(dataList,"^",43)   //损害情形
	S adrrRepTypeNew=$p(dataList,"^",44)  //新的
     //ADVDR_PosOfReporter=:adrrEvtProPosOfRep,ADVDR_Wishes=:adrrEvtProWishes,
	&SQL(Update DHC_AdvDrugReport Set ADVDR_Code=:adrrRepCode,ADVDR_RepDate=:adrrRepDate,ADVDR_Priority=:adrrPriority,ADVDR_RepType=:adrrRepType,
	   ADVDR_DeptType=:adrrDeptType,ADVDR_DeptElse=:adrrDeptElse,ADVDR_PatID=:AdrPatNo,ADVDR_PatName=:adrrPatName,ADVDR_PatSex=:adrrPatSex,ADVDR_PatAge=:adrrPatAge,
	   ADVDR_PatDOB=:adrrPatDOB,ADVDR_PatNation=:adrrPatNation,ADVDR_PatWeight=:adrrPatWeight,ADVDR_PatContact=:adrrPatContact,ADVDR_PatMedNo=:adrrPatMedNo,
	   ADVDR_EventHistory=:adrrEvtHis,ADVDR_EventHistDesc=:adrrEvtHisDesc,ADVDR_EventFamily=:adrrEvtFam,ADVDR_EventFamiDesc=:adrrEvtFamDesc,
	   ADVDR_ADRE_Dr=:adrrEventDr,ADVDR_DateOccu=:adrrEvtDateOcc,ADVDR_Result=:adrrEvtRes,ADVDR_ResultDesc=:adrrEvtResDesc,ADVDR_DateResult=:adrrEvtDRes,
	   ADVDR_TimeResult=:adrrEvtTRes,ADVDR_StopResultt=:adrrEvtSRes,ADVDR_TakingAgain=:adrrEvtTakAg,ADVDR_EffectOfTreatment=:adrrEvtEff,
	   ADVDR_CommentOfUser=:adrrEvtCUser,ADVDR_UserOfReport=:adrrEvtRepUser,ADVDR_CommentOfDept=:adrrEvtCDept,ADVDR_DeptOfReport=:adrrEvtRepDept,
	   ADVDR_Telephone=:adrrEvtUserOfRepTel,ADVDR_CareerOfRepUser=:adrrEvtCarOfRepUser,ADVDR_CareerOfRepElse=:adrrEvtCarOfRepElse,ADVDR_EmailOfRepUser=:adrrEvtEOfRepUser,
	   ADVDR_LocOfReporter=:adrrEvtLocOfRep,ADVDR_ProTitleOfReporter=:adrrEvtProTitOfRep,
	   ADVDR_DeptName=:adrrEvtProDeptName,ADVDR_DeptContacts=:adrrEvtProDeptCon,ADVDR_DeptTel=:adrrEvtProDeptTel,ADVDR_Remark=:adrrEvtRemark,ADVDR_CurStatus_DR=:adrrEvtCurStatDR,
	   ADVDR_RepNew=:adrrRepTypeNew,ADVDR_DamSit=:adrrRepTSDesc,ADVDR_ImportInfo=:ImpInfodata,ADVDR_ImportInfoOth=:ImpInfoOth,
	   ADVDR_RepProc=:ProcessDesc Where ADVDR_RowID=:adrrRepID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 取当前不良反应报告最大码
/// Creator:     yangyongtao
/// CreateDate:  2016-4-8
/// Input:  	 报告编码规则,编码数字长度
/// Return:  	 当前不良反应报告最大码  
ClassMethod GetAdvReportCurMaxNo(Prefix As %String, NoLen As %String) As %String
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
	S CurrMaxNo=..GetAdvMaxCodeByCode(Prefix)
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
/// Creator:     yangyongtao
/// CreateDate:  2016-4-8
/// Input:  	 报告编码规则,编码数字长度
/// Return:  	 当前不良反应报告最大码  
ClassMethod GetAdvMaxCodeByCode(Prefix As %String) As %String
{
	N (Prefix)
	Q:Prefix="" ""
	S matacode=""
	&sql(select max(ADVDR_Code) into matacode from DHC_AdvDrugReport Where ADVDR_Code %STARTSWITH %ALPHAUP :Prefix)
	Q matacode
}

}
