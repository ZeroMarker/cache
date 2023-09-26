Import SQLUser

/// 创建时间		：2006.09.07
/// 创建人			：xuwm
/// 存在系统		：体检系统
/// 关联数据		: 
/// 索引			: 
/// 主要功能		: 疾病统计、阳性特征查询
/// 主要功能		: 
/// 最后修改时间	: 
/// 最后修改人	: 
/// 完成
Class web.DHCPE.StatisticQuery Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

/// 疾病汇总
/// d ##class(web.DHCPE.StatisticQuery).GetDiagnosisList("3^6^15^","9^","","","","","1")
/// d ##class(web.DHCPE.StatisticQuery).GetDiagnosisList("6^","10^","","","","","")
/// 								团体列表(以 ^ 分割)						疾病诊断列表(以 ^ 分割)			体检起始日期							体检结束日期						起始年龄							结束年龄							年龄区间							性别			
ClassMethod GDiagnosisStatistic(DiagnosisList As %Library.String = "", GList As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", AgeArea As %Library.String = "", Sex As %Library.String = "")
{
	k ^DHCPEDSTMP("DiagnosisStatistic")

	// 团体客户基本信息登记表 DHC_PE_GBaseInfo 第一层循环 团体-团体条件
	f iGLLoop=1:1:$Length(GList,"^") d
	.s GBIRowId=$P(GList,"^",iGLLoop)
	.Q:(""=GBIRowId)
	.
	.// DHC_PE_GBaseInfo.{ GBI_Desc }	团体名称
	.s GBIDesc=$P($G(^DHCPEGBI(GBIRowId)),"^",2)
	.// DHC_PE_GADM	团体客户ADM表 第二层循环 团体内客户
	.s GADMRowId="0"
	.f  s GADMRowId=$O(^DHCPEGADM(0,"GBI",GBIRowId,GADMRowId)) Q:(""=GADMRowId)  d
	..
	..// DHC_PE_GADM.{ GADM_AdmDate }	体检日期
	..s AdmDate=$P($G(^DHCPEGADM(GADMRowId)),"^",2)
	..Q:(""=AdmDate)
	..Q:(""'=DateFrom)&(""'=AdmDate)&(DateFrom>AdmDate)
	..Q:(""'=DateTo)&(""'=AdmDate)&(DateTo<AdmDate)
	..s AdmDate=$ZD(AdmDate,3)
	..
	..// DHC_PE_IADM 第三层循环 团体客户的就诊(检验)记录
	..s IAdmRowId="0"
	..f  s IAdmRowId=$O(^DHCPEIADM(0,"GADM",GADMRowId,IAdmRowId)) Q:(""=IAdmRowId)  d
	...// DHC_PE_IADM.{ IADM_PAADM_DR }
	...s IADMPAADMDR=$P($G(^DHCPEIADM(IAdmRowId)),"^",1)
	...
	...Q:(1=$D(^DHCPEDSTMP("DiagnosisList", GADMRowId, IADMPAADMDR)))
	...
	...// PA_ADM.{ PAADM_PAPMI_DR }
	...s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	...
	...
	...// PA_PatMas.{ PAPMI_Sex_DR }	性别
	...s PAPERSex=$p(^PAPER(PAPMIdr,"ALL"),"^",7)
	...Q:(""'=Sex)&(Sex'=PAPERSex)
	...//  CT_Sex
	...i PAPERSex'="" s PAPERSex=$p(^CT("SEX",PAPERSex),"^",2)
	...
	...// PA_PatMas.{ PAPMI_Name }	姓名
	...s PAPERName=$p(^PAPER(PAPMIdr,"ALL"),"^",1)
	...
	...// PA_PatMas.{ PAPMI_Sex_DR_Dob }	出生日期
	...s PAPERDob=$p(^PAPER(PAPMIdr,"ALL"),"^",6)
	...
 	...i PAPERDob'="" d
 	....//年龄
 	....s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPERDob,+$h)
 	....s Age=+$P(Age,"Y",1)
 	....s PAPERDob=$ZD(PAPERDob,3)
	...e  d
	....s Age=""
	...Q:(""'=AgeFrom)&(""'=Age)&(+AgeFrom>+Age)
	...Q:(""'=AgeTo)&(""'=Age)&(+AgeTo<+Age)
	...// 登记号	PA_PatMas.{PAPMI_IPNo}
	...s PAPMIIPNo=$p(^PAPER(PAPMIdr,"PAT",1),"^",1)
	...
	...// 统计总人数
	...s:(0=$D(^DHCPEDSTMP("DiagnosisList", "Total"))) ^DHCPEDSTMP("DiagnosisList", "Total")=0
	...s:(0'=$D(^DHCPEDSTMP("DiagnosisList", "Total"))) ^DHCPEDSTMP("DiagnosisList", "Total")=+^DHCPEDSTMP("DiagnosisList", "Total")+1
	...
	...// 第二层循环 疾病信息 
	...f iILLoop=1:1:$Length(DiagnosisList,"^") d
	....s Diagnosis=$P(DiagnosisList,"^",iILLoop)
	....Q:(""=Diagnosis)
	....
	....// 查询同时患有所选疾病
	....//i (("Y"=IsHaveAllDiagnosis)&(0=$D(^DHCPEGenED("GetSummarize",IADMPAADMDR,Diagnosis)))) d
	.....//k ^DHCPEDSTMP("DiagnosisList", "Group", GADMRowId, IADMPAADMDR)
	....
	....Q:(0=$D(^DHCPEGenED("GetSummarize",IADMPAADMDR,Diagnosis)))
	....
	....s EDDiagnoseConclus=$P($G(^DHCPEED(Diagnosis,1)),"^",1)
	....s OutData=GBIDesc_"^"_AdmDate_"^"_PAPMIIPNo_"^"_PAPERName_"^"_PAPERSex_"^"_PAPERDob_"^"_Age
	....
	....// 患有疾病的客户列表
	....s ^DHCPEDSTMP("DiagnosisList", "Diagnosis", Diagnosis, "Group", GADMRowId, IADMPAADMDR)=EDDiagnoseConclus_"^"_OutData
	....
	....// 团体内患病客户列表
	....s ^DHCPEDSTMP("DiagnosisList", "Group", GADMRowId, IADMPAADMDR)=OutData
	....
	....
}

/// 统计团体病患人数
/// d ##class(web.DHCPE.StatisticQuery).GetGroupDiagnosisCount(13, "3^6^15^","1","100","10")
/// 
ClassMethod GetGroupDiagnosisCount(GADMDR As %Library.String = "", DiagnosisList As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", AgeStep As %Library.String = "")
{
	// DHC_PE_IADM 第三层循环 团体客户的就诊(检验)记录
	s IAdmRowId="0"
	f  s IAdmRowId=$O(^DHCPEIADM(0,"GADM",GADMDR,IAdmRowId)) Q:(""=IAdmRowId)  d
	.// DHC_PE_IADM.{ IADM_PAADM_DR }
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IAdmRowId)),"^",1)
	.
	.// PA_ADM.{ PAADM_PAPMI_DR }
	.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	.
	.// PA_PatMas.{ PAPMI_Sex_DR }	性别
	.s PAPERSex=$p(^PAPER(PAPMIdr,"ALL"),"^",7)
	.s:(""'=PAPERSex) PAPERSex=$p(^CT("SEX",PAPERSex),"^",2)  // CT_Sex
	.
	.// PA_PatMas.{ PAPMI_Name }	姓名
	.s PAPERName=$p(^PAPER(PAPMIdr,"ALL"),"^",1)
	.
	.// PA_PatMas.{ PAPMI_Sex_DR_Dob }	出生日期
	.s PAPERDob=$p(^PAPER(PAPMIdr,"ALL"),"^",6)
 	.i PAPERDob'="" d
 	..//年龄
 	..s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPERDob,+$h)
 	..s Age=+$P(Age,"Y",1)
 	..s PAPERDob=$ZD(PAPERDob,3)
	.e  d
	..s Age=0
	.s AgeArea=..GetAgeArea(AgeFrom, AgeTo, AgeStep, Age)
	.
	.// 登记号	PA_PatMas.{PAPMI_IPNo}
	.s PAPMIIPNo=$p(^PAPER(PAPMIdr,"PAT",1),"^",1)
	.
	.// 统计总人数
	.s CurNumber=+$G(^DHCPEDSTMP("DiagnosisStatistic", "Group", GADMDR))
	.s CurNumber=+CurNumber+1
	.s ^DHCPEDSTMP("DiagnosisStatistic", "Group", GADMDR)=+CurNumber
	.
	.// 统计男女人数
	.s CurNumber=+$G(^DHCPEDSTMP("DiagnosisStatistic", "Group", GADMDR, "Sex", "Count", PAPERSex))
	.s CurNumber=+CurNumber+1
	.s ^DHCPEDSTMP("DiagnosisStatistic", "Group", GADMDR, "Sex", "Count", PAPERSex)=+CurNumber
	.
	.// 统计各年龄区间人数
	.s:(""'=AgeArea) CurNumber=+$G(^DHCPEDSTMP("DiagnosisStatistic", "Group", GADMDR, "AgeArea", "Count", AgeArea))
	.s CurNumber=+CurNumber+1
	.s:(""'=AgeArea) ^DHCPEDSTMP("DiagnosisStatistic", "Group", GADMDR, "AgeArea", "Count", AgeArea)=+CurNumber
	.
	.// 第二层循环 疾病信息 
	.f iILLoop=1:1:$Length(DiagnosisList,"^") d
	..s Diagnosis=$P(DiagnosisList,"^",iILLoop)
	..Q:(""=Diagnosis)
	..Q:(0=$D(^DHCPEGenED("GetSummarize",IADMPAADMDR,Diagnosis)))
	..
	..s EDDiagnoseConclus=$P($G(^DHCPEED(Diagnosis,1)),"^",1)
	..
	..// 患有某种疾病的客户人数
	..s CurNumber=+$G(^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "Group", "Count", GADMDR))
	..s CurNumber=+CurNumber+1
	..s ^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "Group", "Count", GADMDR)=+CurNumber
	..
	..// 按性别统计患有某种疾病的客户
	..s CurNumber=+$G(^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "Sex", "Count", PAPERSex, GADMDR))
	..s CurNumber=+CurNumber+1
	..s ^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "Sex", "Count", PAPERSex, GADMDR)=+CurNumber
	..
	..// 按年龄区间统计患有某种疾病的客户
	..s:(""'=AgeArea) CurNumber=+$G(^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "AgeArea", "Count", AgeArea, GADMDR))
	..s CurNumber=+CurNumber+1
	..s:(""'=AgeArea) ^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "AgeArea", "Count", AgeArea, GADMDR)=+CurNumber
	.
}

/// 统计团体病患率
/// d ##class(web.DHCPE.StatisticQuery).GetGroupDiagnosisPercent(13)
/// 
ClassMethod GetGroupDiagnosisPercent(GADMDR As %Library.String = "")
{
	
	s TotalCount=$G(^DHCPEDSTMP("DiagnosisStatistic", "Group", GADMDR))
	
	s Diagnosis=""
	f  s Diagnosis=$O(^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis)) Q:(""=Diagnosis)  d
	.// 某种疾病的发病率
	.s DiagnosisCount=$G(^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "Group", "Count", GADMDR))
	.s DiagnosisPercent=DiagnosisCount/TotalCount*100
	.s ^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "Group", "Percent", GADMDR)=DiagnosisPercent
	.
	.s Sex=""
	.f  s Sex=$O(^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "Sex", "Count", Sex)) Q:(""=Sex)  d
	..
	..s SexCount=$G(^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "Sex", "Count", Sex, GADMDR))
	..// 某种疾病的某性别发病率 
	..s SexPerent=SexCount/TotalCount*100
	..s ^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "Sex", "SexPercent1", Sex, GADMDR)=SexPerent
	..// 某种疾病的某性别所占比例
	..s SexPerent=SexCount/DiagnosisCount*100
	..s ^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "Sex", "SexPercent2", Sex, GADMDR)=SexPerent
	..
	.
	.s AgeArea=""
	.f  s AgeArea=$O(^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "AgeArea", "Count", AgeArea)) Q:(""=AgeArea)  d
	..s AgeAreaCount=$G(^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "AgeArea", "Count", AgeArea, GADMDR))
	..// 某种疾病的某年龄段的发病率 
	..s AgeAreaPerent=AgeAreaCount/TotalCount*100
	..s ^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "AgeArea", "AgeAreaPercent1", AgeArea, GADMDR)=AgeAreaPerent
	..// 某种疾病的某年龄段的所占比例
	..s AgeAreaPerent=AgeAreaCount/DiagnosisCount*100
	..s ^DHCPEDSTMP("DiagnosisStatistic", "Diagnosis", Diagnosis, "AgeArea", "AgeAreaPercent2", AgeArea, GADMDR)=AgeAreaPerent
	..
	.
}

/// 获取年龄所在的区间
/// w ##class(web.DHCPE.StatisticQuery).GetAgeArea(10,40,4,25)
ClassMethod GetAgeArea(aAgeFrom, aAgeTo, aAgeStep, aAge)
{
	n LowerAgeArea,HeightAgeArea
	Q:(aAge>aAgeTo) ""
	Q:(aAge<aAgeFrom) ""
	s n=(aAge-aAgeFrom)\aAgeStep
	s LowerAgeArea=aAgeFrom+(aAgeStep*n)
	s HeightAgeArea=aAgeFrom+(aAgeStep*(n+1))
	s:(HeightAgeArea>aAgeTo) HeightAgeArea=aAgeTo
	Q LowerAgeArea_"-"_HeightAgeArea
}

}
