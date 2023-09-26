/// 名称:DHCMed.DTH.Report
/// 描述: 死亡报告主表
/// 编写者：wangCS
/// 编写日期: 2011-07-19
Class DHCMed.DTH.Report Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ChildReportStatus As DHCMed.DTH.ReportStatus [ Cardinality = children, Inverse = ParRef ];

// Relationship PaperNo As DHCMed.DTH.PaperNo [ Cardinality = children, Inverse = ParRef ];

Relationship ChildPrintStatus As DHCMed.DTH.PrintStatus [ Cardinality = children, Inverse = ParRef ];

/// 基本信息ID Pa_Patmas
Property PatientID As %String(TRUNCATE = 1) [ Required ];

/// 就诊表 ID
Property EpisodeID As %String(TRUNCATE = 1) [ Required ];

/// 住院登记号
Property PapmiNo As %String(TRUNCATE = 1) [ Required ];

/// 病案号
Property MrNo As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 性别
Property Sex As %String(TRUNCATE = 1);

/// 孕产情况
Property Pregnancies As DHCMed.SS.Dictionary;

/// 出生日期
Property Birthday As %Date;

/// 实足年龄
Property Age As %String(TRUNCATE = 1);

/// 证件类型
Property CardTypeDR As DHCMed.SS.Dictionary;

/// 身份证号
Property Identify As %String(TRUNCATE = 1);

/// 户口地址
Property RegAddress As %String(TRUNCATE = 1);

/// 生前常住地址、现住址
Property CurrAddress As %String(TRUNCATE = 1);

/// 户籍性质
Property Household As DHCMed.SS.Dictionary;

/// 职业
Property Occupation As DHCMed.SS.Dictionary;

/// 工种
Property WorkType As DHCMed.SS.Dictionary;

/// 国籍
Property Country As %String(TRUNCATE = 1);

/// 民族
Property Nation As %String(TRUNCATE = 1);

/// 婚姻
Property Marital As DHCMed.SS.Dictionary;

/// 文化程度
Property Education As DHCMed.SS.Dictionary;

/// 生前工作单位
Property Company As %String(TRUNCATE = 1);

/// 家属姓名
Property FamName As %String(TRUNCATE = 1);

/// 家属身份证号
Property FamIdentify As %String(TRUNCATE = 1);

/// 家属证件类型
Property FamCardTypeDR As DHCMed.SS.Dictionary;

/// 与死者的关系
Property FamRelation As DHCMed.SS.Dictionary;

/// 联系电话
Property FamTel As %String(TRUNCATE = 1);

/// 联系住址或工作单位
Property FamAddr As %String(TRUNCATE = 1);

/// 死亡证明书编号
Property DeathNo As %String(TRUNCATE = 1);

/// 死亡日期
Property DeathDate As %Date;

/// 死亡时间
Property DeathTime As %Time;

/// 死亡地点 医院病房、急诊室、家中、赴医院途中、外地及其它、不详
Property DeathPlace As DHCMed.SS.Dictionary;

/// A_直接导致死亡的疾病或情况 诊断
Property AReason As %String(MAXLEN = 500, TRUNCATE = 1);

/// A_发病到死亡的时间间隔
Property AInterval As %Numeric;

/// B_引起A的疾病或情况
Property BReason As %String(MAXLEN = 500, TRUNCATE = 1);

/// B_发病到死亡的时间间隔
Property BInterval As %Numeric;

/// C_引起B的疾病或情况
Property CReason As %String(MAXLEN = 500, TRUNCATE = 1);

/// C_发病到死亡的时间间隔
Property CInterval As %Numeric;

/// D_引起A的疾病或情况
Property DReason As %String(MAXLEN = 500, TRUNCATE = 1);

/// D_发病到死亡的时间间隔
Property DInterval As %Numeric;

/// 其他疾病诊断（促进死亡，但与导致死亡无关的其他重要情况）
Property OtherDiagnose As %String(TRUNCATE = 1);

/// 病案室编码后其他疾病诊断_直接导致死亡的疾病或情况
Property OtherDiagnoseFP As %String(MAXLEN = 200, TRUNCATE = 1);

/// 病案室编码其他疾病诊断ICD编码
Property OtherDiagnoseFPICD As %String(TRUNCATE = 1);

/// 其他疾病诊断ICD编码
Property OtherDiagnoseICD As %String(TRUNCATE = 1);

/// 其他疾病诊断_发病到死亡的时间间隔
Property OtherDiagnoseInterval As %Numeric;

/// 其他疾病诊断时间单位
Property OtherDiagnoseTime As DHCMed.SS.Dictionary;

/// 最高诊断单位 省级医院、地市级医院、县区级医院、卫生院、村卫生室、未就诊、其它及不详
Property DiagnoseUnit As DHCMed.SS.Dictionary;

/// 最高诊断依据 尸检、病理、手术、临床+理化、临床、死后推断、不详
Property DiagnoseBasis As DHCMed.SS.Dictionary;

/// 根本死因
Property BaseReason As %String(MAXLEN = 500, TRUNCATE = 1);

/// 根本死因ICD编码
Property BaseReasonICD As %String(TRUNCATE = 1);

/// 死因统计分类
Property DeathClassify As %String(TRUNCATE = 1);

/// 损伤中毒原因
Property Damage As %String(TRUNCATE = 1);

/// 损伤中毒ICD
Property DamageICD As %String(TRUNCATE = 1);

/// 损伤中毒统计分类
Property DamageClassify As %String(TRUNCATE = 1);

/// 备注
Property ResumeText As %String(MAXLEN = 500, TRUNCATE = 1);

/// 死者生前病史及症状体征
Property ExamMedical As %String(MAXLEN = 500, TRUNCATE = 1);

/// 被调查者姓名
Property ExamName As %String(TRUNCATE = 1);

/// 与死者关系
Property ExamRelation As DHCMed.SS.Dictionary;

/// 联系地址或工作单位
Property ExamAddress As %String(TRUNCATE = 1);

/// 联系电话
Property ExamTel As %String(TRUNCATE = 1);

/// 死因推断
Property ExamDeathReason As %String(MAXLEN = 500, TRUNCATE = 1);

/// 调查者
Property ExamUserDR As %String(TRUNCATE = 1);

/// 调查日期
Property ExamDate As %Date;

/// 报告编号
Property RepNo As %String(TRUNCATE = 1);

/// 医生
Property RepDocDR As %String(TRUNCATE = 1);

/// 报告科室
Property RepLocDR As %String(TRUNCATE = 1);

/// 报告人
Property RepUsrDR As %String(TRUNCATE = 1);

/// 报告日期
Property RepDate As %Date;

/// 报告时间
Property RepTime As %Time;

/// 报告状态
Property RepStatusDR As DHCMed.SS.Dictionary;

/// 损伤中毒诊断  add by liulan 20130410
Property DamageDiagnose As %String(TRUNCATE = 1);

/// AReasonICD
Property AReasonICD As %String(TRUNCATE = 1);

/// BReasonICD
Property BReasonICD As %String(TRUNCATE = 1);

/// CReasonICD
Property CReasonICD As %String(TRUNCATE = 1);

/// DReasonICD
Property DReasonICD As %String(TRUNCATE = 1);

/// DamageDiagnoseICD
Property DamageDiagnoseICD As %String(TRUNCATE = 1);

/// ATime
Property ATime As DHCMed.SS.Dictionary;

/// BTime
Property BTime As DHCMed.SS.Dictionary;

/// CTime
Property CTime As DHCMed.SS.Dictionary;

/// DTime
Property DTime As DHCMed.SS.Dictionary;

/// 是否无名氏
Property IsJohnDoe As %String(TRUNCATE = 1);

/// 是否新生儿
Property IsNewBorn As %String(TRUNCATE = 1);

/// 居住地 省
Property MEPDProvince As %String(TRUNCATE = 1);

/// 居住地 市
Property MEPDCity As %String(TRUNCATE = 1);

/// 居住地 县（区）
Property MEPDCounty As %String(TRUNCATE = 1);

/// 居住地 乡
Property MEPDVillage As %String(TRUNCATE = 1);

/// 户籍地 省
Property RegProvince As %String(TRUNCATE = 1);

/// 户籍地 市
Property RegCity As %String(TRUNCATE = 1);

/// 户籍地 县（区）
Property RegCounty As %String(TRUNCATE = 1);

/// 户籍地 乡
Property RegVillage As %String(TRUNCATE = 1);

/// 户籍地 小区（村）
Property RegRoad As %String(TRUNCATE = 1);

/// 生前住址 小区（村）
Property CurrRoad As %String(TRUNCATE = 1);

/// 病案室编码后的基本诊断
/// A_直接导致死亡的疾病或情况 诊断
Property AFPReason As %String(MAXLEN = 200, TRUNCATE = 1);

/// B_引起A的疾病或情况
Property BFPReason As %String(MAXLEN = 500, TRUNCATE = 1);

/// C_引起B的疾病或情况
Property CFPReason As %String(MAXLEN = 500, TRUNCATE = 1);

/// D_引起A的疾病或情况
Property DFPReason As %String(MAXLEN = 500, TRUNCATE = 1);

/// AFPReasonICD
Property AFPReasonICD As %String(TRUNCATE = 1);

/// BFPReasonICD
Property BFPReasonICD As %String(TRUNCATE = 1);

/// CFPReasonICD
Property CFPReasonICD As %String(TRUNCATE = 1);

/// DFPReasonICD
Property DFPReasonICD As %String(TRUNCATE = 1);

/// 病人ID索引
Index IndexPatientID On PatientID;

/// 报告日期索引
Index IndexDate On RepDate;

/// 死亡日期索引
Index IndexDeathDate On DeathDate;

/// 死亡证明书编号索引
Index IndexDeathNo On DeathNo;

/// 查询用到的索引
Index IndexSearch On (RepDate, RepLocDR, RepStatusDR);

/// Creator:wangCS
/// CreateDate:2011-07-26
/// Description:将DHCMed.DTH.Report对象转为字符串
/// Input:       separate:分割符
/// Output:      返回字符串
/// w ##Class(DHCMed.DTH.Report).ToString()
Method ToString(separate As %String, Languages As %String) As %String
{
	new (separate,Languages)
	if ($g(separate)=""){
		set separate=..#SEPARATE
	}
	set return=..%Id()   //1
	set return=return_separate_..PapmiNo  //2
	set return=return_separate_..MrNo  //3
	set return=return_separate_..Name  //4
	set return=return_separate_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc",Languages,..Sex)  //5
	set return=return_separate_..Identify  //6
	
	set Birthday=..Birthday
	;set:Birthday'="" Birthday=$zd(Birthday,3)
	set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
	set return=return_separate_Birthday  //7
	
	set return=return_separate_..Age   //8
	set return=return_separate_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCountry","CTCOUDesc",Languages,..Country)   //9
	set return=return_separate_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,..Nation)	           //10
	set return=return_separate_..GetDicByObj(..Marital,Languages)  //11
	set return=return_separate_..GetDicByObj(..Education,Languages)  //12
	set return=return_separate_..GetDicByObj(..Occupation,Languages)  //13
	set return=return_separate_..GetDicByObj(..WorkType,Languages)  //14
	set return=return_separate_..Company  //15
	set return=return_separate_..GetDicByObj(..Pregnancies,Languages)  //16
	set return=return_separate_..RegAddress  //17
	set return=return_separate_..CurrAddress  //18
	set return=return_separate_..FamName  //19
	set return=return_separate_..GetDicByObj(..FamRelation,Languages)  //20
	set return=return_separate_..FamTel  //21
	set return=return_separate_..FamAddr  //22
	set return=return_separate_..DeathNo  //23
	
	set DeathDate=..DeathDate
	;set:DeathDate'="" DeathDate=$zd(DeathDate,3)
	set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate)
	set return=return_separate_DeathDate  //24
	set DeathTime=..DeathTime
	set:DeathTime'="" DeathTime=$zt(DeathTime,1)
	set return=return_separate_DeathTime  //25
	
	set return=return_separate_..GetDicByObj(..DeathPlace,Languages)   //26
	set return=return_separate_..BaseReason   //27
	set return=return_separate_..BaseReasonICD   //28
	set return=return_separate_..Damage   //29   //update 2019-03-21 修复bug 853983 导致死亡的疾病或情况、中毒损伤、其他诊断等显示修改为全部诊断描述
	set return=return_separate_..DamageICD            //30
	set return=return_separate_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.MRCICDDx","MRCIDDesc",Languages,..AReason)   //31
	set return=return_separate_..AInterval   //32
	set return=return_separate_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.MRCICDDx","MRCIDDesc",Languages,..BReason)  //33
	set return=return_separate_..BInterval  //34
	set return=return_separate_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.MRCICDDx","MRCIDDesc",Languages,..CReason)   //35
	set return=return_separate_..CInterval   //36
	set return=return_separate_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.MRCICDDx","MRCIDDesc",Languages,..DReason)   //37
	set return=return_separate_..DInterval   //38
	set return=return_separate_..OtherDiagnose   //39
	set return=return_separate_..GetDicByObj(..DiagnoseUnit,Languages)  //40
	set return=return_separate_..GetDicByObj(..DiagnoseBasis,Languages)  //41
	set return=return_separate_..ResumeText  //42
	set return=return_separate_..ExamMedical  //43
	set return=return_separate_..ExamName  //44
	set return=return_separate_..GetDicByObj(..ExamRelation,Languages)   //45
	set return=return_separate_..ExamTel  //46
	
	set return=return_separate_..ExamDeathReason   //47
	set return=return_separate_..ExamAddress   //48
	
	set ExamUser=..ExamUserDR  //字段直接存的姓名
	//set ExamUserDesc=""
	//set objUser=##Class(DHCMed.Base.SSUser).GetObjById(ExamUser)
	//if $IsObject(objUser) {
	//	set ExamUserDesc=objUser.Name
	//}
	set return=return_separate_ExamUser  // 49
	
	set ExamDate=..ExamDate                           
	;set:ExamDate'="" ExamDate=$zd(ExamDate,3)
	set:ExamDate'="" ExamDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ExamDate)
	set return=return_separate_ExamDate  //50
	
	set RepDate=..RepDate
	;set:RepDate'="" RepDate=$zd(RepDate,3)
	set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	set return=return_separate_RepDate  //51
	set RepTime=..RepTime
	set:RepTime'="" RepTime=$zt(RepTime,1)
	set return=return_separate_RepTime  //52
	
	set return=return_separate_..GetDicByObj(..Household)   //53
	set return=return_separate_..DamageDiagnose  //54
	set return=return_separate_..AReasonICD  //55   
	set return=return_separate_..BReasonICD  //56
	set return=return_separate_..CReasonICD  //57
	set return=return_separate_..DReasonICD  //58
	set return=return_separate_..DamageDiagnoseICD  //59
	set return=return_separate_..GetDicByObj(..ATime,Languages)   //60
	set return=return_separate_..GetDicByObj(..BTime,Languages)  //61
	set return=return_separate_..GetDicByObj(..CTime,Languages)  //62
	set return=return_separate_..GetDicByObj(..DTime,Languages)  //63
	set return=return_separate_..GetDicByObj(..CardTypeDR,Languages)  //64
	set return=return_separate_..IsJohnDoe  //65
	
	Set (CurrProvince,CurrCity,CurrCounty,CurrVillage)=""
	set CurrProvinceID=..MEPDProvince
	if CurrProvinceID'="" {
		set CurrProvinceDesc=##class(DHCMed.SS.AreaDic).GetShordDescById(CurrProvinceID)
		set:CurrProvinceDesc'="" CurrProvince=CurrProvinceID_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc",Languages,CurrProvinceDesc)	
	}
	set CurrCityID=..MEPDCity
	if CurrCityID'="" {
		set CurrCityDesc=##class(DHCMed.SS.AreaDic).GetShordDescById(CurrCityID)
		set:CurrCityDesc'="" CurrCity=CurrCityID_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc",Languages,CurrCityDesc)
	}
	set CurrCountyID=..MEPDCounty
	if CurrCountyID'="" {
		set CurrCountyDesc=##class(DHCMed.SS.AreaDic).GetShordDescById(CurrCountyID)
		set:CurrCountyDesc'="" CurrCounty=CurrCountyID_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc",Languages,CurrCountyDesc)
	}
	set CurrVillageID=..MEPDVillage
	if CurrVillageID'="" {
		set CurrVillageDesc=##class(DHCMed.SS.AreaDic).GetShordDescById(CurrVillageID)
		set:CurrVillageDesc'="" CurrVillage=CurrVillageID_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc",Languages,CurrVillageDesc)
	}
	
	Set (RegProvince,RegCity,RegCounty,RegVillage)=""
	set RegProvinceID=..RegProvince
	if RegProvinceID'="" {
		set RegProvinceDesc=##class(DHCMed.SS.AreaDic).GetShordDescById(RegProvinceID)
		set:RegProvinceDesc'="" RegProvince=RegProvinceID_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc",Languages,RegProvinceDesc)	
	}
	set RegCityID=..RegCity
	if RegCityID'="" {
		set RegCityDesc=##class(DHCMed.SS.AreaDic).GetShordDescById(RegCityID)
		set:RegCityDesc'="" RegCity=RegCityID_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc",Languages,RegCityDesc)
	}
	set RegCountyID=..RegCounty
	if RegCountyID'="" {
		set RegCountyDesc=##class(DHCMed.SS.AreaDic).GetShordDescById(RegCountyID)
		set:RegCountyDesc'="" RegCounty=RegCountyID_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc",Languages,RegCountyDesc)
	}
	set RegVillageID=..RegVillage
	if RegVillageID'="" {
		set RegVillageDesc=##class(DHCMed.SS.AreaDic).GetShordDescById(RegVillageID)
		set:RegVillageDesc'="" RegVillage=RegVillageID_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc",Languages,RegVillageDesc)
	}
	set return=return_separate_CurrProvince  //66
	set return=return_separate_CurrCity  //67
	set return=return_separate_CurrCounty  //68
	
	set return=return_separate_..AFPReason  //69
	set return=return_separate_..BFPReason  //70
	set return=return_separate_..CFPReason  //71
	set return=return_separate_..DFPReason  //72
	set return=return_separate_..AFPReasonICD  //73
	set return=return_separate_..BFPReasonICD  //74
	set return=return_separate_..CFPReasonICD  //75
	set return=return_separate_..DFPReasonICD  //76
	
	set RepUsrDR=..RepUsrDR,RepUsrDesc=""
	if (RepUsrDR'=""){
		set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+RepUsrDR)
		if ($IsObject(objUser)){
			set RepUsrDesc=objUser.Name
		}
	}
	set return=return_separate_RepUsrDesc  //77
	
	set return=return_separate_CurrVillage  //78
	set return=return_separate_RegProvince  //79
	set return=return_separate_RegCity            //80
	set return=return_separate_RegCounty  //81
	set return=return_separate_RegVillage  //82
	set return=return_separate_..GetDicByObj(..FamCardTypeDR)  //83
	set return=return_separate_..FamIdentify  //84
	set return=return_separate_..RegRoad  //85
	set return=return_separate_..CurrRoad  //86
	
	
	set return=return_separate_..OtherDiagnoseICD  //87
	set return=return_separate_..OtherDiagnoseFP  //88
	set return=return_separate_..OtherDiagnoseFPICD  //89
	set return=return_separate_..OtherDiagnoseInterval   //90
	set return=return_separate_..GetDicByObj(..OtherDiagnoseTime)  //91
	set return=return_separate_..IsNewBorn  //92
	quit return
}

/// w ##class(DHCMed.DTH.Report).GetDicByObj("4610")
ClassMethod GetDicByObj(obj As DHCMed.SS.Dictionary, Languages As %String  = { ""}) As %String
{
	new (obj,Languages)
	set return=""
	quit:'$IsObject(obj) return
	
	Set Desc=obj.Description
	Set:Desc'="" Desc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,Desc)
	set return=obj.%Id()_$c(1)_Desc
	quit return
}

/// 根据字典类型和描述取ID
/// w ##class(DHCMed.DTH.Report).GetDicByTypeDesc("DTHCardType","身份证")
ClassMethod GetDicByTypeDesc(aType As %String, aValue As %String) As %String
{
	New (aType,aValue)
	Set return=""
	Quit:(aType="")||(aValue="") return
	
	If $d(^DHCMed.SS.DictionaryD(aValue)) {
		Set return=aValue
		Quit return
	} Else {
		Set xID=""
		For {
			Set xID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," "_$zcvt(aType,"U")," "_$zcvt(aValue,"U"),xID))
			Quit:xID=""
			Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(xID)
			Continue:'$IsObject(objDic)
			Set return=objDic.%Id()
		}
	}
	
	Quit return
}

/// Creator:     wangCS
/// CreateDate:  2011-07-27
/// Description: 根据Id得到DHCMed.DTH.Report对象
/// Input:       Id:RowId
/// Output:      DHCMed.DTH.Report对象
/// w ##Class(DHCMed.DTH.Report).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DTH.Report
{
	new (id)
	set return=""
	set obj=##Class(DHCMed.DTH.Report).%OpenId(id)
	if $IsObject(obj){
		/*
		set obj.Marital=..GetDicByTypeDesc("DTHMarriage",obj.Marital)
		set obj.Education=..GetDicByTypeDesc("DTHEducation",obj.Education)
		set obj.FamRelation=..GetDicByTypeDesc("DTHFamilyRelation",obj.FamRelation)
		if obj.RegRoad="" {
			if (obj.RegVillage'="")&&(obj.RegAddress'="") {
				set RegVillage=##class(DHCMed.SS.AreaDic).GetShordDescById(obj.RegVillage)
				set obj.RegRoad=$p(obj.RegAddress,RegVillage,2)
			}
		}
		if obj.CurrRoad="" {
			if (obj.MEPDVillage'="")&&(obj.CurrAddress'="") {
				set CurrVillage=##class(DHCMed.SS.AreaDic).GetShordDescById(obj.MEPDVillage)
				set obj.CurrRoad=$p(obj.CurrAddress,CurrVillage,2)
			}
		}
		*/
		set return=obj
		do obj.%Close()
	}
	quit return
}

/// Creator:     wangCS
/// CreateDate:  2011-07-27
/// Description: 得到DHCMed.DTH.Report对象内容
/// Input:       Id:RowId
///             separate:分割符
/// Output:      返回字符串
/// w ##Class(DHCMed.DTH.Report).GetStringById("4","")
ClassMethod GetStringById(id As %String, separate As %String) As %String
{
	new (id,separate,%session)
	set ret=""
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	if ($g(separate)="")
	{
	    set separate=..#SEPARATE
	}
	set obj=..GetObjById(+id)
	if ($IsObject(obj))
	{
		set ret=obj.ToString($g(separate),Languages)
	}
	quit ret
}

/// Creator:    wangCS
/// CreateDate: 2011-07-25
/// Description:更新DHCMed.DTH.Report
/// Input:      instr:字符串
///             separate:分割符
/// Output:     更新成功返回RowId，失败返回小于0数字
/// w ##Class(DHCMed.DTH.Report).Update("2^10^李赫宰^20140001^105^1^0000000010^24岁^男^130684198911162293^1989-11-16^ZG-中国^汉族^5643^5630^5609^^工作单位测试^^北京市市辖区西城区德胜街道asd^河北省唐山市古冶区赵各庄办事处爱的色放^联系人^5639^2935931^阿道夫^20140001^2014-07-18^02:45^5622^^^^^^^^^^^^^^5672^5669^^~！@#￥%……&*（）^"",./——+~!@#$% &*()_+^^^^^^^^6^^500274^^^^^^^^^^^5761^0^665^1005^35^35^^^^^^^^^1035^2^3^23^24^5761^^asd^爱的色放^^^^^^0","^")
ClassMethod Update(instr As %String, separate As %String) As %String
{
	new (instr,separate,%session)
	set return=-100
	quit:instr="" return
	
	set:($g(separate)="") separate=..#SEPARATE
	Set (RepLocDr,RepUsrDR) = ""
	Set RepLocDr	= +$g(%session.Data("LOGON.CTLOCID"))
	Set RepUsrDR	= +$g(%session.Data("LOGON.USERID"))
	Set LogID=##class(DHCMed.DTH.ReportLog).SaveDTHEditLog(instr,RepLocDr,RepUsrDR)
	
	set Id=$p(instr,separate,1)
	set EpisodeID=$p(instr,separate,72)  //就诊号不允许为空
	quit:EpisodeID="" return
	set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	quit:PatientID="" return
	set AdmLoc=$p($g(^PAADM(EpisodeID)),"^",4)
	quit:AdmLoc="" return
	set HospitalID=$p($g(^CTLOC(AdmLoc)),"^",22)  //就诊科室对应医院
	
	//死亡报告不能重复报告
	set return=-200
	if (PatientID'="")&&(Id="") {
		set xID=0,IsHave=0
		for {
			set xID=$o(^DHCMed.DTHi("REP","IndexPatientID"," "_PatientID,xID))
			quit:xID=""
			quit:IsHave=1
			set objRep=..GetObjById(xID)
			continue:'$IsObject(objRep)
			continue:'$IsObject(objRep.RepStatusDR)
			set RepStatus=objRep.RepStatusDR.Code
			continue:RepStatus="0" //删除状态
			continue:RepStatus="5" //作废状态
			set IsHave=1
		}
		quit:IsHave=1 return
	}
	
	//检查报告状态字典
	set return=-300
	set RepStatus=$p(instr,separate,6)
	quit:RepStatus="" return
	set objRepStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("DTHRunningState",RepStatus,"1")
	quit:'$IsObject(objRepStatus) return
	set RepStatusCode=objRepStatus.Code
	
	set UpdateDate=+$h
	set UpdateTime=+$p($h,",",2)
	set UpdateUser=$p(instr,separate,5)
	//set UpdateLoc=AdmLoc   ///$p(instr,separate,54)
	set UpdateLoc=$p(instr,separate,54)
	
	TSTART
	
	if (Id="") {
		set obj=##Class(DHCMed.DTH.Report).%New()
		Set $p(instr,separate,1)=obj.%Id()
		Set LogID=##class(DHCMed.DTH.ReportLog).SaveDTHEditLog(instr,RepLocDr,RepUsrDR)
		
	} else {
		set obj=##Class(DHCMed.DTH.Report).%OpenId(Id)
	}
	quit:'$IsObject(obj) return
	
	set obj.PatientID=PatientID
	set obj.EpisodeID=EpisodeID
	set obj.IsJohnDoe=$p(instr,separate,68)
	set obj.Name=$p(instr,separate,3)
	set obj.PapmiNo=$p(instr,separate,7)
	set obj.MrNo=$p(instr,separate,56)
	set obj.Age=$p(instr,separate,8)
	set obj.Sex=$p(instr,separate,9)
	set obj.CardTypeDR=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,67))
	set obj.Identify=$p(instr,separate,10)
	set Birthday=$p(instr,separate,11)
	//set:Birthday["-" Birthday=$zdh(Birthday,3)
	//set:Birthday["/" Birthday=$zdh(Birthday,4)
	set obj.Birthday=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(Birthday)
	set obj.Country=$p(instr,separate,12)
	set obj.Nation=$p(instr,separate,13)
	set obj.Marital=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,14))
	set obj.Education=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,15))
	set obj.Occupation=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,16))
	set obj.WorkType=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,17))
	set obj.Company=$p(instr,separate,18)
	set obj.Pregnancies=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,19))
	set RegAddress = $p(instr,separate,20)
	/*set RegAddressBefore = $e(RegAddress,1,4)
	set RegAddressBefore=..ReplaceString(RegAddressBefore,"区","")
	set RegAddressBefore=..ReplaceString(RegAddressBefore,"县","")
	set RegAddressBack = $e(RegAddress,5,$l(RegAddress))
	set RegAddress = RegAddressBefore_RegAddressBack
	set RegAddress=..ReplaceString(RegAddress,"市辖区","")
	set RegAddress=..ReplaceString(RegAddress,"不详市","")
	set RegAddress=..ReplaceString(RegAddress,"不详县","")
	set RegAddress=..ReplaceString(RegAddress,"不详乡镇","")*/
	set obj.RegAddress=RegAddress
	set obj.RegProvince=$p(instr,separate,82)
	set obj.RegCity=$p(instr,separate,83)
	set obj.RegCounty=$p(instr,separate,84)
	set obj.RegVillage=$p(instr,separate,85)
	set obj.RegRoad=$p(instr,separate,88)
	set CurrAddress=$p(instr,separate,21)
	/*set CurrAddressBefore = $e(CurrAddress,1,4)
	set CurrAddressBefore=..ReplaceString(CurrAddressBefore,"区","")
	set CurrAddressBefore=..ReplaceString(CurrAddressBefore,"县","")
	set CurrAddressBack = $e(CurrAddress,5,$l(CurrAddress))
	set CurrAddress = CurrAddressBefore_CurrAddressBack
	set CurrAddress=..ReplaceString(CurrAddress,"市辖区","")
	set CurrAddress=..ReplaceString(CurrAddress,"不详市","")
	set CurrAddress=..ReplaceString(CurrAddress,"不详县","")
	set CurrAddress=..ReplaceString(CurrAddress,"不详乡镇","")*/
	set obj.CurrAddress=CurrAddress
	set obj.MEPDProvince=$p(instr,separate,69)
	set obj.MEPDCity=$p(instr,separate,70)
	set obj.MEPDCounty=$p(instr,separate,71)
	set obj.MEPDVillage=$p(instr,separate,81)
	set obj.CurrRoad=$p(instr,separate,89)
	set obj.FamName=$p(instr,separate,22)
	set obj.FamRelation=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,23))
	set obj.FamTel=$p(instr,separate,24)
	set obj.FamAddr=$p(instr,separate,25)
	set obj.Household=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,55))
	set obj.FamCardTypeDR=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,86))
	set obj.FamIdentify=$p(instr,separate,87)
	
	set DeathDate=$p(instr,separate,27)
	//set:DeathDate["-" DeathDate=$zdh(DeathDate,3)
	//set:DeathDate["/" DeathDate=$zdh(DeathDate,4)
	set obj.DeathDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DeathDate)
	set DeathTime=$p(instr,separate,28)
	set:DeathTime[":" DeathTime=$zth(DeathTime,1)
	set obj.DeathTime=DeathTime
	set obj.DeathPlace=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,29))
	
	set obj.BaseReason=$p(instr,separate,30)
	set obj.BaseReasonICD=$p(instr,separate,31)
	set obj.Damage=$p(instr,separate,32)
	set obj.DamageICD=$p(instr,separate,33)
	set obj.AReason=$p(instr,separate,34)
	set obj.AInterval=$p(instr,separate,35)
	set obj.BReason=$p(instr,separate,36)
	set obj.BInterval=$p(instr,separate,37)
	set obj.CReason=$p(instr,separate,38)
	set obj.CInterval=$p(instr,separate,39)
	set obj.DReason=$p(instr,separate,40)
	set obj.DInterval=$p(instr,separate,41)
	set obj.OtherDiagnose=$p(instr,separate,42)
	set obj.DiagnoseUnit=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,43))
	set obj.DiagnoseBasis=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,44))
	set obj.ResumeText=$p(instr,separate,45)
	
	set obj.ExamMedical=$p(instr,separate,46)
	set obj.ExamName=$p(instr,separate,47)
	set obj.ExamRelation=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,48))
	set obj.ExamTel=$p(instr,separate,49)
	set obj.ExamDeathReason=$p(instr,separate,50)
	set obj.ExamAddress=$p(instr,separate,51)
	set obj.ExamUserDR=$p(instr,separate,52)
	set ExamDate=$p(instr,separate,53)
	//set:ExamDate["-" ExamDate=$zdh(ExamDate,3)
	//set:ExamDate["/" ExamDate=$zdh(ExamDate,4)
	set obj.ExamDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ExamDate)
	
	set obj.DamageDiagnose=$p(instr,separate,57)
	set obj.AReasonICD=$p(instr,separate,58)
	set obj.BReasonICD=$p(instr,separate,59)
	set obj.CReasonICD=$p(instr,separate,60)
	set obj.DReasonICD=$p(instr,separate,61)
	set obj.DamageDiagnoseICD=$p(instr,separate,62)
	set obj.ATime=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,63))
	set obj.BTime=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,64))
	set obj.CTime=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,65))
	set obj.DTime=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,66))
	set obj.AFPReason=$p(instr,separate,73)
	set obj.BFPReason=$p(instr,separate,74)
	set obj.CFPReason=$p(instr,separate,75)
	set obj.DFPReason=$p(instr,separate,76)
	set obj.AFPReasonICD=$p(instr,separate,77)
	set obj.BFPReasonICD=$p(instr,separate,78)
	set obj.CFPReasonICD=$p(instr,separate,79)
	set obj.DFPReasonICD=$p(instr,separate,80)
	
	set obj.OtherDiagnoseICD=$p(instr,separate,90)
	set obj.OtherDiagnoseFP=$p(instr,separate,91)
	set obj.OtherDiagnoseFPICD=$p(instr,separate,92)
	set obj.OtherDiagnoseInterval=$p(instr,separate,93)
	set obj.OtherDiagnoseTime=##Class(DHCMed.SS.Dictionary).GetObjById(+$p(instr,separate,94))
	set obj.IsNewBorn=$p(instr,separate,95)
	
	set obj.RepStatusDR=objRepStatus
	if (Id="")||((Id'="")&&(RepStatusCode="1")){
		set obj.RepDate=UpdateDate
		set obj.RepTime=UpdateTime
		set obj.RepLocDR=UpdateLoc
		set obj.RepUsrDR=UpdateUser
	}
	set sc=obj.%Save()
	if ($system.Status.IsError(sc)) {
	   d $system.OBJ.DisplayError(sc)
	   TROLLBACK
	   set return=-1
	}else{
	    set return=obj.%Id()
	}
	if obj'="" do obj.%Close()
	quit:return<0 return
	
	//死亡证明 报告ID
	set ReportID=return
	
	//新建报告时，以传进来的编号为准（如果为空，下边会自动分配一个号）
	//修改报告时，以系统中存在的编号为准
	set tmpDeathNo=obj.DeathNo
	set:tmpDeathNo'="" $p(instr,separate,26)=tmpDeathNo
	//更新报告状态
    set objStatus=##Class(DHCMed.DTH.ReportStatus).%New()
    set objStatus.ParRef=obj
	set objStatus.StatusDR=objRepStatus
	set objStatus.OpeUserDR=UpdateUser
	set objStatus.OpeDate=UpdateDate
	set objStatus.OpeTime=UpdateTime
	set sc=objStatus.%Save()
	if ($system.Status.IsError(sc)) {
	   //d $system.OBJ.DisplayError(sc)
	   TROLLBACK
	   set return=-2
	}
	if objStatus'="" do objStatus.%Close()
	quit:return<0 return
	Set IsExistCode = ##class(DHCMed.DTH.CodeRecycle).IsExistCode()
	//更新死亡证明编号
	set DeathNo=$p(instr,separate,26)
	if DeathNo="" {
		if (objStatus.StatusDR.Code=6) {
			//草稿状态时不生成死亡编号
		} 
		elseif (IsExistCode=1){
			// 存在回收且未使用的编码
			Set DeathNo = ##class(DHCMed.DTH.CodeRecycle).GetRecycleCode() 
			set obj=##Class(DHCMed.DTH.Report).%OpenId(ReportID)
			quit:'$IsObject(obj) return
			set obj.RepNo=DeathNo
			set obj.DeathNo=DeathNo
			set sc=obj.%Save()
			Set Recycle = ##class(DHCMed.DTH.CodeRecycle).UpdateNewReportID(ReportID,DeathNo) 
			if ($system.Status.IsError(sc)) {
			   //d $system.OBJ.DisplayError(sc)
			   TROLLBACK
			   set return=-4
			}
		}
		else {
			set GetDeathNoType=##Class(DHCMed.DTHService.RepNoSrv).GetDeathNoType(HospitalID)
			if (GetDeathNoType=1){
				//根据医院编码自动分号
				set DeathNo=##Class(DHCMed.DTHService.RepNoSrv).GetNewDeathNo(HospitalID)
				if DeathNo="" {
					TROLLBACK
					set return=-3
				}
				set obj=##Class(DHCMed.DTH.Report).%OpenId(ReportID)
				quit:'$IsObject(obj) return
				set obj.RepNo=DeathNo
				set obj.DeathNo=DeathNo
				set sc=obj.%Save()
				if ($system.Status.IsError(sc)) {
				   //d $system.OBJ.DisplayError(sc)
				   TROLLBACK
				   set return=-4
				}
			} elseif (GetDeathNoType=99){
					//手工输入死亡编号
			} else {}
		}
	} else {
		set obj.RepNo=DeathNo
		set obj.DeathNo=DeathNo
		set sc=obj.%Save()	
	}
	quit:return<0 return
	
	
	
	TCOMMIT
	
	set return=ReportID
	quit return
}

/// Creator:     liulan
/// CreateDate:  2013-04-09
/// Description: 更新诊断和损伤中毒诊断
/// Input:       Id:RowId 
///             separate:分割符
/// Output:      返回字符串
/// w ##Class(DHCMed.DTH.Report).UpdateDMRepDiagnose("44","")
ClassMethod UpdateDMRepDiagnose(instr As %String, separate As %String) As %String
{
	new (instr,separate)
	set return=0
	quit:instr="" return
	
	if ($g(separate)=""){
	    set separate="^"
	}
	
	set ReportID=$p(instr,separate,1)
	quit:(ReportID="") return
	
	set obj=##Class(DHCMed.DTH.Report).%OpenId(+ReportID)
 	set obj.BaseReason=$p(instr,separate,2)
 	set obj.BaseReasonICD=$p(instr,separate,3)
 	set obj.Damage=$p(instr,separate,4)
 	set obj.DamageICD=$p(instr,separate,5)
 	set obj.AFPReason=$p(instr,separate,6)
	set obj.BFPReason=$p(instr,separate,7)
	set obj.CFPReason=$p(instr,separate,8)
	set obj.DFPReason=$p(instr,separate,9)
	set obj.AFPReasonICD=$p(instr,separate,10)
	set obj.BFPReasonICD=$p(instr,separate,11)
	set obj.CFPReasonICD=$p(instr,separate,12)
	set obj.DFPReasonICD=$p(instr,separate,13)
	set obj.OtherDiagnoseFP=$p(instr,separate,14)
	set obj.OtherDiagnoseFPICD=$p(instr,separate,15)
	set sc=obj.%Save()
	if ($system.Status.IsError(sc)) {
		do $system.OBJ.DisplayError(sc)
		set return=-1
	} else {
		set return=obj.%Id()
	}	
	do obj.%Close()
	
	quit return
}

/// Creator:    wuqk
/// CreateDate: 2013-08-30
/// Description:根据PatientID获取死亡报告对象
/// Input:      PatientID
/// Output:      DHCMed.DTH.Report对象
/// w ##Class(DHCMed.DTH.Report).GetObjByPatientID(44)
ClassMethod GetObjByPatientID(PatientID) As DHCMed.DTH.Report
{
	//n (PatientID)
    q:+PatientID=0 ""
    q:'$d(^DHCMed.DTHi("REP","IndexPatientID"," "_PatientID)) ""
    s reportId=$o(^DHCMed.DTHi("REP","IndexPatientID"," "_PatientID,""),-1)
	s Reportobj=##Class(DHCMed.DTH.Report).%OpenId(+reportId)
    q Reportobj
}

/// Creator:    liuyh
/// CreateDate: 2013-12-05
/// Description:根据病人基本信息判断是否为新生儿
/// Input:      aEpisodeID
/// w ##Class(DHCMed.DTH.Report).GetIsNewBornByPaadm(67)
ClassMethod GetIsNewBornByPaadm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Quit:+PatientID=0 return
	
	//出生日期<28天
	Set BirDate = $p($g(^PAPER(PatientID,"ALL")),"^",6)
	if (+$h-BirDate)<28 {
		Set return=1
	}
	//分娩产生就诊记录
	Set MotherDr=$p($g(^PAADM(aEpisodeID)),"^",75)
	Set:MotherDr'="" return=1
	Quit return
}

/// Creator:    pylian
/// CreateDate: 2019-12-05
/// Description:根据病人是否为5岁以下儿童/报告5岁以下儿童报告
/// Input:      aEpisodeID
/// w ##Class(DHCMed.DTH.Report).GetIsChild("","162")
ClassMethod GetIsChild(aReportID As %String, aEpisodeID As %String) As %String
{
	New (aReportID,aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="")&&(aReportID="") return
		
	//死亡日期时间
	Set DeathDate="",DeathTime=""
	If (aReportID) {
		Set ChRepID=##class(DHCMed.DTH.ChildReport).GetRepIDByDthID(aReportID)
		Quit:+ChRepID>0 1    //存在5岁以下死亡报告
		Set objRep = ##Class(DHCMed.DTH.Report).GetObjById(aReportID)
		Quit:'$IsObject(objRep) return
		Set DeathDate=objRep.DeathDate
		Set DeathTime=objRep.DeathTime
		Set EpisodeID =objRep.EpisodeID
		Set PatientID =objRep.PatientID
	}Else {
		Set EpisodeID=aEpisodeID
		Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
		Quit:+PatientID=0 return
		Set DeathDate=$p($g(^PAPER(PatientID,"ALL")),"^",13)
		Set DeathTime=$p($g(^PAPER(PatientID,"ALL")),"^",8)
	}
	
    //有死亡日期按死亡日期算，没有死亡日期按当前算
	Set PatAge = ##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,DeathDate,DeathTime)
	If (PatAge["岁") {
		Set PatAge=$p(PatAge,"岁",1)
		Set:PatAge<5 return=1
	}Elseif(PatAge="未知"){
		Set return=0
	}
	Else {
		Set return=1
	}
	 
	Quit return
}

/// w ##Class(DHCMed.DTH.Report).ReplaceString("杨红彬","红","")
ClassMethod ReplaceString(Str, OldStr, NewStr)
{
	new (Str,OldStr,NewStr)
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
	
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
		
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
			
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

/// 获取死亡证明书编号
/// w ##Class(DHCMed.DTH.Report).CheckDeathNo(aHospitalID)
ClassMethod CheckDeathNo(aHospitalID As %String) As %String
{
	New (aHospitalID)
	Quit:aHospitalID="" ""
	
	Set IsNewNo=0
	While (IsNewNo=0) {
		Set DeathNo=##Class(DHCMed.DTHService.RepNoSrv).GetNewDeathNo(aHospitalID)
		If $d(^DHCMed.DTHi("REP","IndexDeathNo"," "_DeathNo)) {
			Set IsNewNo=0
		} Else {
			Set IsNewNo=1
		}
	}
	
	Quit DeathNo
}

/// 把历史死亡编号改成新版本格式
/// d ##Class(DHCMed.DTH.Report).UpdateHistoryDeathNo(0)
ClassMethod UpdateHistoryDeathNo(aHospitalID As %String)
{
	New (aHospitalID)
	set hisRepID = ""
	for {
		set hisRepID = $o(^DHCMed.DTH("REP",hisRepID))
		q:hisRepID=""
		set return= ""
		if ((+hisRepID<1000)&&(+hisRepID'=50)) {
			set hisRepObj=##Class(DHCMed.DTH.Report).%OpenId(hisRepID)
			set hisAdmLoc = hisRepObj.RepLocDR
			set hisRepDate = hisRepObj.RepDate
			set hisDeathNo = hisRepObj.DeathNo
			;set hisRepDate = $zd(hisRepDate,3)
			set hisRepDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(hisRepDate)
			set hisRepYear = $p(hisRepDate,"-",1)
			set hisHospitalID=+$p($g(^CTLOC(hisAdmLoc)),"^",22)
			if (hisDeathNo'="") {
				set DeathRepHospCode=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("DTH-DeathRepHospCode",aHospitalID)
				set $p(return,"0",5-$l(hisDeathNo))=hisDeathNo
				set newDeathNo = DeathRepHospCode_"-"_hisRepYear_"-"_return
				if (hisHospitalID=aHospitalID) {
					&sql(update DHCMed_DTH.Report set DeathNo=:newDeathNo where ID=:hisRepID)
					w "更新成功",!
				}
			}
		}
	}
}

/// 向历史数据中插入最后一条急诊或是住院的就诊号
/// d ##Class(DHCMed.DTH.Report).UpdateHistoryEpisodeID()
ClassMethod UpdateHistoryEpisodeID()
{
	New (aHospitalID)
	set hisRepID = ""
	for {
		set hisRepID = $o(^DHCMed.DTH("REP",hisRepID))
		q:hisRepID=""
		set return= ""
		if ((+hisRepID<1000)) {
			set hisRepObj=##Class(DHCMed.DTH.Report).%OpenId(hisRepID)
			set hisPatientID = hisRepObj.PatientID
			Set AdmType=""
				For {
				Set AdmType=$o(^PAPERdr(+hisPatientID,"ADM",AdmType))
				Continue:AdmType="O"
				Quit:AdmType=""
				Set Paadm=0
				For {
					Set Paadm=$o(^PAPERdr(+hisPatientID,"ADM",AdmType,Paadm))
					Quit:Paadm=""
				}
			}
			&sql(update DHCMed_DTH.Report set EpisodeID=:Paadm where ID=:hisRepID)
			w "更新成功",!
			
		}
	}
}

/// 把历史婚姻状况文化程度与死者关系改成新版本格式
/// UpdateHistoryMaritalEducationFamRelation改为ProcessHistoryData，超长
/// d ##Class(DHCMed.DTH.Report).ProcessHistoryData()
ClassMethod ProcessHistoryData()
{
	//q   //上线时用，其他时候不要操作，固q退出，起保护作用
	set hisRepID = ""
	for {
		set hisRepID = $o(^DHCMed.DTH("REP",hisRepID))
		q:hisRepID=""
		if (+hisRepID<1000) {
			//set hisRepObj=##Class(DHCMed.DTH.Report).%OpenId(hisRepID)
			&sql(select Marital,Education,FamRelation,Occupation,Pregnancies Into:Marital,:Education,:FamRelation,:Occupation,:Pregnancies from DHCMed_DTH.Report where ID=:hisRepID)
			//set Marital = hisRepObj.Marital
			//set Education = hisRepObj.Education
			//set FamRelation = hisRepObj.FamRelation
			w "Marital="_Marital_"Education="_Education_"FamRelation="_FamRelation_"Occupation"_Occupation,!
			/*
			set:Education="文盲或半文盲" Education="初中及以下"
			set:Education="中学" Education="初中及以下"
			set:Education="大学及以上" Education="大学本科"
			set:Education="小学" Education="初中及以下"
			set:Education="不详" Education="初中及以下"
			*/
			set:FamRelation="子" FamRelation="父母子女"
			set:FamRelation="女" FamRelation="父母子女"
			set:FamRelation="其他" FamRelation="朋友"
			set:FamRelation="夫妻" FamRelation="其他亲属"
			set:FamRelation="亲属" FamRelation="其他亲属"
			set:FamRelation="父亲" FamRelation="父母子女"
			set:Marital="其它" Marital="未说明"
			set MaritalID = ##Class(DHCMed.DTHService.ReportSrv).GetDataByDesc("DTHMarriage",Marital)
			set EducationID = ##Class(DHCMed.DTHService.ReportSrv).GetDataByDesc("DTHEducation",Education)
			set FamRelationID = ##Class(DHCMed.DTHService.ReportSrv).GetDataByDesc("DTHFamilyRelation",FamRelation)
			set Occupation = ##Class(DHCMed.DTHService.ReportSrv).GetDescById(Occupation)
			set Pregnancies = ##Class(DHCMed.DTHService.ReportSrv).GetDescById(Pregnancies)
			
			/*
			set:Occupation="中国共产党中央委员会和地方各级党组织负责人" Occupation="公务员"
			set:Occupation="国家机关及其工作机构负责人" Occupation="公务员"
			set:Occupation="民主党派和社会团体及其工作机构负责人" Occupation="公务员"
			set:Occupation="事业单位负责人" Occupation="公务员"
			set:Occupation="企业负责人" Occupation="公务员"
			set:Occupation="科学研究人员" Occupation="公务员"
			set:Occupation="工程技术人员" Occupation="公务员"
			set:Occupation="农业技术人员" Occupation="公务员"
			set:Occupation="飞机和船舶技术人员（厂船技术员）" Occupation="公务员"
			set:Occupation="卫生专业技术人员（医务人员、医生、护士）" Occupation="公务员"
			set:Occupation="经济业务人员" Occupation="公务员"
			set:Occupation="金融业务人员（银行人员）" Occupation="公务员"
			set:Occupation="法律专业人员" Occupation="公务员"
			set:Occupation="教学人员（教师）" Occupation="公务员"
			set:Occupation="文学艺术工作人员" Occupation="公务员"
			set:Occupation="体育工作人员" Occupation="公务员"
			set:Occupation="新闻出版、文化工作人员" Occupation="公务员"
			set:Occupation="宗教职业者" Occupation="公务员"
			set:Occupation="其他专业技术人员" Occupation="公务员"
			set:Occupation="行政办公人员（干部）" Occupation="公务员"
			set:Occupation="安全保卫和消防人员（公安、消防）" Occupation="公务员"
			set:Occupation="邮政和电信业务人员" Occupation="公务员"
			set:Occupation="其他办事人员和有关人员" Occupation="公务员"
			set:Occupation="购销人员（销售员）" Occupation="公务员"
			set:Occupation="仓储人员" Occupation="公务员"
			set:Occupation="餐饮服务人员" Occupation="公务员"
			set:Occupation="饭店、旅游及健身娱乐场所服务人员（服务员）" Occupation="公务员"
			set:Occupation="运输服务人员" Occupation="公务员"
			set:Occupation="医疗卫生辅助服务人员" Occupation="公务员"
			set:Occupation="社会服务和居民生活服务人员" Occupation="公务员"
			set:Occupation="其他商业、服务业人员（个体工商户）" Occupation="公务员"
			set:Occupation="种植业生产人员（农民）" Occupation="公务员"
			set:Occupation="林业生产及野生动植物保护人员" Occupation="公务员"
			set:Occupation="畜牧业生产人员（牧民）" Occupation="公务员"
			set:Occupation="渔业生产人员（渔民）" Occupation="公务员"
			set:Occupation="水利设施管理养护人员" Occupation="公务员"
			set:Occupation="其他农、林、牧、渔、水利业生产人员" Occupation="公务员"
			set:Occupation="环境监测与废物处理人员" Occupation="公务员"
			set:Occupation="检验、计量人员" Occupation="公务员"
			set:Occupation="化工产品生产人员" Occupation="公务员"
			set:Occupation="勘测及矿物开采人员" Occupation="公务员"
			set:Occupation="金属冶炼、轧制人员" Occupation="公务员"
			set:Occupation="机械制造加工人员" Occupation="公务员"
			set:Occupation="机电产品装配人员" Occupation="公务员"
			set:Occupation="机械设备修理人员" Occupation="公务员"
			set:Occupation="电力设备安装、运行、检修及供电人员" Occupation="公务员"
			set:Occupation="电子元器件与设备制造、装配调试及维修人员" Occupation="公务员"
			set:Occupation="橡胶和塑料制品生产人员" Occupation="公务员"
			set:Occupation="纺织、针织、印染人员" Occupation="公务员"
			set:Occupation="裁剪缝纫和皮革、毛皮制品加工制作人员" Occupation="公务员"
			set:Occupation="粮油、食品、饮料生产加工及饲料生产加工人员" Occupation="公务员"
			set:Occupation="烟草及其制品加工人员" Occupation="公务员"
			set:Occupation="药品生产人员" Occupation="公务员"
			set:Occupation="木材加工、人造板生产及木材制品制作人员" Occupation="公务员"
			set:Occupation="建筑材料生产加工人员" Occupation="公务员"
			set:Occupation="玻璃、陶瓷、搪瓷及其制品生产加工人员" Occupation="公务员"
			set:Occupation="广播影视制品制作、播放及文物保护作业人员" Occupation="公务员"
			set:Occupation="印刷人员" Occupation="公务员"
			set:Occupation="工艺、美术品制作人员" Occupation="公务员"
			set:Occupation="文化教育、体育用品制作人员" Occupation="公务员"
			set:Occupation="工程施工人员" Occupation="公务员"
			set:Occupation="运输设备操作人员及有关人员（司机）" Occupation="公务员"
			set:Occupation="其他生产、运输设备操作人员及有关人员（民工）" Occupation="公务员"
			set:Occupation="军人" Occupation="公务员"
			set:Occupation="不便分类的其他从业人员" Occupation="公务员"
			set:Occupation="婴幼儿、学龄前儿童" Occupation="公务员"
			set:Occupation="学生" Occupation="公务员"
			set:Occupation="家务" Occupation="公务员"
			set:Occupation="无业或待业" Occupation="公务员"
			*/
			set OccupationID = ##Class(DHCMed.DTHService.ReportSrv).GetDataByDesc("DTHCareer",Occupation)
			set PregnanciesID = ##Class(DHCMed.DTHService.ReportSrv).GetDataByDesc("DTHCareer",Pregnancies)
			&sql(update DHCMed_DTH.Report set Occupation=:OccupationID,Marital=:MaritalID,Education=:EducationID,FamRelation=:FamRelationID,Pregnancies=:PregnanciesID where ID=:hisRepID)
			w "更新成功",!
		}
	}
}

/// 把上报科室改成病人的就诊科室
/// d ##Class(DHCMed.DTH.Report).UpdateHistoryLocID()
ClassMethod UpdateHistoryLocID()
{

	set hisRepID = ""
	for {
		set hisRepID = $o(^DHCMed.DTH("REP",hisRepID))
		q:hisRepID=""
		set return= ""
		set hisRepObj=##Class(DHCMed.DTH.Report).%OpenId(hisRepID)
		if $IsObject(hisRepObj) {
			set hisEpisodeID = hisRepObj.EpisodeID
			set AdmLoc=$p($g(^PAADM(hisEpisodeID)),"^",4)
			&sql(update DHCMed_DTH.Report set RepLocDR=:AdmLoc where ID=:hisRepID)
			w "更新成功",!
		}	
	}
}

/// w ##Class(DHCMed.DTH.Report).GetStatusInfoByID(8)
ClassMethod GetStatusInfoByID(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	
	Set objRep=..GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.RepStatusDR) return
	Set StatusCode=objRep.RepStatusDR.Code
	Set StatusDesc=objRep.RepStatusDR.Description
	
	Set $p(return,"^",1)=aReportID
	Set $p(return,"^",2)=StatusCode
	Set $p(return,"^",3)=StatusDesc
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RepNo</Value>
</Value>
<Value name="3">
<Value>MrNo</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>PatientID</Value>
</Value>
<Value name="6">
<Value>AInterval</Value>
</Value>
<Value name="7">
<Value>AReason</Value>
</Value>
<Value name="8">
<Value>Age</Value>
</Value>
<Value name="9">
<Value>Sex</Value>
</Value>
<Value name="10">
<Value>BInterval</Value>
</Value>
<Value name="11">
<Value>BReason</Value>
</Value>
<Value name="12">
<Value>BaseReason</Value>
</Value>
<Value name="13">
<Value>BaseReasonICD</Value>
</Value>
<Value name="14">
<Value>Birthday</Value>
</Value>
<Value name="15">
<Value>CInterval</Value>
</Value>
<Value name="16">
<Value>CReason</Value>
</Value>
<Value name="17">
<Value>Company</Value>
</Value>
<Value name="18">
<Value>Country</Value>
</Value>
<Value name="19">
<Value>CurrAddress</Value>
</Value>
<Value name="20">
<Value>DInterval</Value>
</Value>
<Value name="21">
<Value>DReason</Value>
</Value>
<Value name="22">
<Value>Damage</Value>
</Value>
<Value name="23">
<Value>DamageClassify</Value>
</Value>
<Value name="24">
<Value>DamageICD</Value>
</Value>
<Value name="25">
<Value>DeathClassify</Value>
</Value>
<Value name="26">
<Value>DeathDate</Value>
</Value>
<Value name="27">
<Value>DeathNo</Value>
</Value>
<Value name="28">
<Value>DeathPlace</Value>
</Value>
<Value name="29">
<Value>DeathTime</Value>
</Value>
<Value name="30">
<Value>DiagnoseBasis</Value>
</Value>
<Value name="31">
<Value>DiagnoseUnit</Value>
</Value>
<Value name="32">
<Value>Education</Value>
</Value>
<Value name="33">
<Value>ExamAddress</Value>
</Value>
<Value name="34">
<Value>ExamDate</Value>
</Value>
<Value name="35">
<Value>ExamDeathReason</Value>
</Value>
<Value name="36">
<Value>ExamMedical</Value>
</Value>
<Value name="37">
<Value>ExamName</Value>
</Value>
<Value name="38">
<Value>ExamRelation</Value>
</Value>
<Value name="39">
<Value>ExamTel</Value>
</Value>
<Value name="40">
<Value>ExamUserDR</Value>
</Value>
<Value name="41">
<Value>FamAddr</Value>
</Value>
<Value name="42">
<Value>FamName</Value>
</Value>
<Value name="43">
<Value>FamRelation</Value>
</Value>
<Value name="44">
<Value>FamTel</Value>
</Value>
<Value name="45">
<Value>Household</Value>
</Value>
<Value name="46">
<Value>Identify</Value>
</Value>
<Value name="47">
<Value>Marital</Value>
</Value>
<Value name="48">
<Value>Nation</Value>
</Value>
<Value name="49">
<Value>Occupatio</Value>
</Value>
<Value name="50">
<Value>OtherDiagnose</Value>
</Value>
<Value name="51">
<Value>Pregnancies</Value>
</Value>
<Value name="52">
<Value>RegAddress</Value>
</Value>
<Value name="53">
<Value>RepDate</Value>
</Value>
<Value name="54">
<Value>RepDocDR</Value>
</Value>
<Value name="55">
<Value>RepLocDR</Value>
</Value>
<Value name="56">
<Value>RepStatusDR</Value>
</Value>
<Value name="57">
<Value>RepTime</Value>
</Value>
<Value name="58">
<Value>RepUsrDR</Value>
</Value>
<Value name="59">
<Value>ResumeText</Value>
</Value>
<Value name="60">
<Value>WorkType</Value>
</Value>
<Value name="61">
<Value>PapmiNo</Value>
</Value>
<Value name="62">
<Value>Occupation</Value>
</Value>
<Value name="63">
<Value>DamageDiagnose</Value>
</Value>
<Value name="64">
<Value>AReasonICD</Value>
</Value>
<Value name="65">
<Value>BReasonICD</Value>
</Value>
<Value name="66">
<Value>CReasonICD</Value>
</Value>
<Value name="67">
<Value>DReasonICD</Value>
</Value>
<Value name="68">
<Value>DamageDiagnoseICD</Value>
</Value>
<Value name="69">
<Value>ATime</Value>
</Value>
<Value name="70">
<Value>BTime</Value>
</Value>
<Value name="71">
<Value>CTime</Value>
</Value>
<Value name="72">
<Value>DTime</Value>
</Value>
<Value name="73">
<Value>CardTypeDR</Value>
</Value>
<Value name="74">
<Value>IsJohnDoe</Value>
</Value>
<Value name="75">
<Value>MEPDProvince</Value>
</Value>
<Value name="76">
<Value>MEPDCity</Value>
</Value>
<Value name="77">
<Value>MEPDCounty</Value>
</Value>
<Value name="78">
<Value>EpisodeID</Value>
</Value>
<Value name="79">
<Value>AFPReason</Value>
</Value>
<Value name="80">
<Value>BFPReason</Value>
</Value>
<Value name="81">
<Value>CFPReason</Value>
</Value>
<Value name="82">
<Value>DFPReason</Value>
</Value>
<Value name="83">
<Value>AFPReasonICD</Value>
</Value>
<Value name="84">
<Value>BFPReasonICD</Value>
</Value>
<Value name="85">
<Value>CFPReasonICD</Value>
</Value>
<Value name="86">
<Value>DFPReasonICD</Value>
</Value>
<Value name="87">
<Value>MEPDVillage</Value>
</Value>
<Value name="88">
<Value>RegProvince</Value>
</Value>
<Value name="89">
<Value>RegCity</Value>
</Value>
<Value name="90">
<Value>RegCounty</Value>
</Value>
<Value name="91">
<Value>RegVillage</Value>
</Value>
<Value name="92">
<Value>FamCardTypeDR</Value>
</Value>
<Value name="93">
<Value>FamIdentify</Value>
</Value>
<Value name="94">
<Value>RegRoad</Value>
</Value>
<Value name="95">
<Value>CurrRoad</Value>
</Value>
<Value name="96">
<Value>OtherDiagnoseFP</Value>
</Value>
<Value name="97">
<Value>OtherDiagnoseFPICD</Value>
</Value>
<Value name="98">
<Value>OtherDiagnoseICD</Value>
</Value>
<Value name="99">
<Value>OtherDiagnoseInterval</Value>
</Value>
<Value name="100">
<Value>OtherDiagnoseTime</Value>
</Value>
<Value name="101">
<Value>IsNewBorn</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DTH("REP")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DTH("REP")</IdLocation>
<IndexLocation>^DHCMed.DTHi("REP")</IndexLocation>
<StreamLocation>^DHCMed.DTH.ReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
