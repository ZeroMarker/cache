Import SQLUser

/// 创建时间		：2007.01.15
/// 创建人		：xuwm
/// 存在系统		：体检系统
/// 关联数据		: DHC_PE_Report
/// 索引			: 
/// 主要功能		：团体报告
/// 主要功能		：
/// 最后修改时间	：
/// 最后修改人	：
/// 文件状态		: 未完成
/// 
Class web.DHCPE.GroupReport Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 328;

/// 疾病汇总
/// d ##class(web.DHCPE.GroupReport).GetDiagnosisList("3^6^15^","9^","","","","","1")
/// d ##class(web.DHCPE.GroupReport).GetDiagnosisList("6^","10^","","","","","")
/// 								团体列表(以 ^ 分割)						疾病诊断列表(以 ^ 分割)			体检起始日期							体检结束日期						起始年龄							结束年龄							年龄区间							性别			
ClassMethod GDiagnosisStatistic(DiagnosisList As %Library.String = "", GList As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", AgeArea As %Library.String = "", Sex As %Library.String = "")
{
	
	k ^TMPGREPORT("DiagnosisStatistic")

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
	..s IADMRowId="0"
	..f  s IADMRowId=$O(^DHCPEIADM(0,"GADM",GADMRowId,IADMRowId)) Q:(""=IADMRowId)  d
	...// DHC_PE_IADM.{ IADM_PAADM_DR }
	...s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	...Q:(""=IADMPAADMDR)
	...Q:(1=$D(^TMPGREPORT("DiagnosisList", GADMRowId, IADMPAADMDR)))
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
	...s:(0=$D(^TMPGREPORT("DiagnosisList", "Total"))) ^TMPGREPORT("DiagnosisList", "Total")=0
	...s:(0'=$D(^TMPGREPORT("DiagnosisList", "Total"))) ^TMPGREPORT("DiagnosisList", "Total")=+^TMPGREPORT("DiagnosisList", "Total")+1
	...
	...// 第二层循环 疾病信息 
	...f iILLoop=1:1:$Length(DiagnosisList,"^") d
	....s Diagnosis=$P(DiagnosisList,"^",iILLoop)
	....Q:(""=Diagnosis)
	....
	....// 查询同时患有所选疾病
	....//i (("Y"=IsHaveAllDiagnosis)&(0=$D(^DHCPEGenED("GetSummarize",IADMPAADMDR,Diagnosis)))) d
	.....//k ^TMPGREPORT("DiagnosisList", "Group", GADMRowId, IADMPAADMDR)
	....
	....Q:(0=$D(^DHCPEGenED("GetSummarize",IADMPAADMDR,Diagnosis)))
	....
	....s EDDiagnoseConclus=$P($G(^DHCPEED(Diagnosis,1)),"^",1)
	....s OutData=GBIDesc_"^"_AdmDate_"^"_PAPMIIPNo_"^"_PAPERName_"^"_PAPERSex_"^"_PAPERDob_"^"_Age
	....
	....// 患有疾病的客户列表
	....s ^TMPGREPORT("DiagnosisList", "Diagnosis", Diagnosis, "Group", GADMRowId, IADMPAADMDR)=EDDiagnoseConclus_"^"_OutData
	....
	....// 团体内患病客户列表
	....s ^TMPGREPORT("DiagnosisList", "Group", GADMRowId, IADMPAADMDR)=OutData
	....
	....
}

/// 统计人数
/// d ##class(web.DHCPE.GroupReport).GetGroupDiagnosisCount(47, "1","100","10")
/// 																																										年龄区间大小		
ClassMethod GetGroupDiagnosisCount(GADMDR As %Library.String = "", AgeFrom As %Library.String = "0", AgeTo As %Library.String = "100", AgeStep As %Library.String = "10", PartFlag As %Library.String = "", PreIADMStr As %Library.String = "")
{
	k ^TMPGREPORT("DS")
	k ^TMPGREPORT("GReport","Temp")
	//s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s MainDoctor=$G(^DHCPESetting("DHCPE","MainDoctorGroup",%session.Get("LOGON.CTLOCID")))
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.s LocID=$P(^DHCPEPreIADM(PreIADM),"^",26)
	.s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType",LocID)),"^",1)
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"
	.Q:((PartFlag="Part")&&(("^"_PreIADMStr_"^")'[("^"_PreIADM_"^")))                        //add by zhouli
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.s ^TMPGREPORT("DS", "TotalCount")=$G(^TMPGREPORT("DS", "TotalCount"))+1
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
	.s:(""'=PAPERSex) PAPERSex=$p(^CT("SEX",PAPERSex),"^",2)
	.s PAPERName=$p($g(^PAPER(PAPMIdr,"ALL")),"^",1)
	.s PAPERDob=$p($g(^PAPER(PAPMIdr,"ALL")),"^",6)
 	.i PAPERDob'="" d
 	..s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPERDob,+$h)
 	..s Age=+$P(Age,"Y",1)
 	..s PAPERDob=$ZD(PAPERDob,3)
	.e  d
	..s Age=0
	.s AgeArea=..GetAgeArea(AgeFrom, AgeTo, AgeStep, Age)
	.s PAPMIIPNo=$p(^PAPER(PAPMIdr,"PAT",1),"^",1)
	.s ^TMPGREPORT("DS","Sex", "Count", PAPERSex)=$G(^TMPGREPORT("DS","Sex", "Count", PAPERSex))+1
	.s ^TMPGREPORT("DS", "AgeArea", "Count", AgeArea)=$G(^TMPGREPORT("DS", "AgeArea", "Count", AgeArea))+1
	.s AgeAreaFlag=..GetAgeAreaFlag(Age)  //得到固定的年龄段标志  2010-08-24
	.s IsDiagnosis=0
	.s GSRowId=0
	.f  s GSRowId=$O(^DHCPEGS(0,"IADM",IADMRowId,GSRowId)) Q:(""=GSRowId)  d
	..s AuditUser=$p(^DHCPEGS(GSRowId,1),"^",7)
	..q:AuditUser=""
	..s MainUser=$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",IADMPAADMDR))
	..q:(MainUser="")&&(MainDoctor="Y")
	..// 统计团体体检人数
	..s ^TMPGREPORT("DS", "TotalHCount")=$G(^TMPGREPORT("DS", "TotalHCount"))+1
	..// 统计性别（男女）人数
	..s ^TMPGREPORT("DS","Sex", "HCount", PAPERSex)=$G(^TMPGREPORT("DS", "Sex", "HCount", PAPERSex))+1
	..// 统计各年龄区间的人数
	..// 2008-09-04 start
	..i Age>"45" s ^TMPGREPORT("DS", "AgeArea", "HCount",">45")=$G(^TMPGREPORT("DS", "AgeArea", "HCount", ">45"))+1
	..e  s ^TMPGREPORT("DS", "AgeArea", "HCount","<=45")=$G(^TMPGREPORT("DS", "AgeArea", "HCount", "<=45"))+1
	..
	..s Conclus=""    //by zhouli 2008-11-07
	..s GSDChildSub=0
	..f  s GSDChildSub=$O(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)) Q:(""=GSDChildSub)  d // 
	...// 当前客户患有疾病
	...S HaveConclusFlag=""    //by zhouli 2008-11-07
	...s IsDiagnosis=1
	...s Diagnosis=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",1)
	...////疾病与诊断不对照
	...//Q:HaveConclusFlag=1     //by zhouli 2008-11-07
	...i DiagnosisType="N" d
	....// 病患信息
	....s EDDiagnoseConclus=$P($G(^DHCPEED(Diagnosis,1)),"^",1)
	....Q:(EDDiagnoseConclus=" ")||(EDDiagnoseConclus="  ")
	....Q:(EDDiagnoseConclus["未见明显异常")||(EDDiagnoseConclus["项目未完成")||(EDDiagnoseConclus["本科未见异常")  //add by zl  YY 091101
	....s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus)=EDDiagnoseConclus
	....// 体检建议
	....s DiagnoseDetail=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",9) //$G(^DHCPEED(Diagnosis,"Detail"))
	....//s ^TMPGREPORT("DS", "Diagnosis", Diagnosis,"DiagnoseDetail")=DiagnoseDetail
	....s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus,"DiagnoseDetail")=DiagnoseDetail
	....// 病患人员名单
	....s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "List")=$G(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "List"))_","_PAPERName
	....// 统计患有某种疾病的客户人数
	....// 2008-09-04
	....i Age>"45"  s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus,">45")=$G(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus,">45"))+1
	....i Age<="45"  s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus,"<=45")=$G(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus,"<=45"))+1
	....s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus,"ALL")=$G(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus,"ALL"))+1
	....s CurNumber=+$G(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "DiagnosisCount"))
	....s CurNumber=+CurNumber+1
	....s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "DiagnosisCount")=+CurNumber
	....// 按性别统计患有某种疾病的客户人数
	....s CurNumber=+$G(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "Sex", "DiagnosisCount", PAPERSex))
	....s CurNumber=+CurNumber+1
	....s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "Sex", "DiagnosisCount", PAPERSex)=+CurNumber
	....
	....// 按年龄区间统计患有某种疾病的客户
	....s:(""'=AgeArea) CurNumber=+$G(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "AgeArea", "DiagnosisCount", AgeArea))
	....s CurNumber=+CurNumber+1
	....s:(""'=AgeArea) ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "AgeArea", "DiagnosisCount", AgeArea)=+CurNumber
	....i AgeAreaFlag'="" S AgeCurNumber=+$G(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "AgeAreaFlag", "Sex",PAPERSex, AgeAreaFlag))
	....S AgeCurNumber=+AgeCurNumber+1
	....s:(""'=AgeAreaFlag) ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "AgeAreaFlag", "Sex",PAPERSex, AgeAreaFlag)=+AgeCurNumber
	....i Age>45 d
	.....s Num=+$G(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus,"Sex",PAPERSex,">45"))
	.....s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus,"Sex",PAPERSex,">45")=Num+1
	....e  d
	.....s Num=+$G(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus,"Sex",PAPERSex,"<=45"))
	.....s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus,"Sex",PAPERSex,"<=45")=Num+1
	...////疾病与诊断对照d ^%urcomp
	...e  d
	....s IDRRowID=0
	....f  s IDRRowID=$o(^DHCPEIDR(0,"EDDR",Diagnosis,IDRRowID)) q:IDRRowID=""  d
	.....s ILLnessID=$P(^DHCPEIDR(IDRRowID),"^",2)
	.....///判断某人是否已经在此种疾病列表里面
	.....s Flag=$G(^TMPGREPORT("GReport","Temp",PreIADM,ILLnessID))
	.....q:Flag=1
	.....s ^TMPGREPORT("GReport","Temp",PreIADM,ILLnessID)="1"
	.....// 病患信息
	.....Q:$G(^DHCPEILLS(ILLnessID))=""
	.....s EDDiagnoseConclus=$P($G(^DHCPEILLS(ILLnessID)),"^",2)
	.....s ^TMPGREPORT("DS", "Diagnosis", ILLnessID)=EDDiagnoseConclus
	.....// 体检建议     实际打印建议以医生建议为准
	.....s DiagnoseDetail=$P($G(^DHCPEILLS(ILLnessID)),"^",3)
	.....s ^TMPGREPORT("DS", "Diagnosis", ILLnessID,"DiagnoseDetail")=DiagnoseDetail
	.....// 病患人员名单
	.....s ^TMPGREPORT("DS", "Diagnosis", ILLnessID, "List")=$G(^TMPGREPORT("DS", "Diagnosis", ILLnessID, "List"))_","_PAPERName
	.....// 统计患有某种疾病的客户人数
	.....s CurNumber=+$G(^TMPGREPORT("DS", "Diagnosis", ILLnessID, "DiagnosisCount"))
	.....s CurNumber=+CurNumber+1
	.....s ^TMPGREPORT("DS", "Diagnosis", ILLnessID, "DiagnosisCount")=+CurNumber
	.....// 按性别统计患有某种疾病的客户人数
	.....s CurNumber=+$G(^TMPGREPORT("DS", "Diagnosis", ILLnessID, "Sex", "DiagnosisCount", PAPERSex))
	.....s CurNumber=+CurNumber+1
	.....s ^TMPGREPORT("DS", "Diagnosis", ILLnessID, "Sex", "DiagnosisCount", PAPERSex)=+CurNumber
	.....//
	.....//
	.....// 按年龄区间统计患有某种疾病的客户
	.....s:(""'=AgeArea) CurNumber=+$G(^TMPGREPORT("DS", "Diagnosis", ILLnessID, "AgeArea", "DiagnosisCount", AgeArea))
	.....s CurNumber=+CurNumber+1
	.....s:(""'=AgeArea) ^TMPGREPORT("DS", "Diagnosis", ILLnessID, "AgeArea", "DiagnosisCount", AgeArea)=+CurNumber
    .....i AgeAreaFlag'="" S AgeCurNumber=+$G(^TMPGREPORT("DS", "Diagnosis", ILLnessID, "AgeAreaFlag", "Sex",PAPERSex, AgeAreaFlag))
	.....S AgeCurNumber=+AgeCurNumber+1
	.....s:(""'=AgeAreaFlag) ^TMPGREPORT("DS", "Diagnosis", ILLnessID, "AgeAreaFlag", "Sex",PAPERSex, AgeAreaFlag)=+AgeCurNumber
	.....i Age>45 d
	......s Num=+$G(^TMPGREPORT("DS", "Diagnosis", ILLnessID,"Sex",PAPERSex,">45"))
	......s ^TMPGREPORT("DS", "Diagnosis", ILLnessID,"Sex",PAPERSex,">45")=Num+1
	.....e  d
	......s Num=+$G(^TMPGREPORT("DS", "Diagnosis", ILLnessID,"Sex",PAPERSex,"<=45"))
	......s ^TMPGREPORT("DS", "Diagnosis", ILLnessID,"Sex",PAPERSex,"<=45")=Num+1
	...... //2008-09-04
	.....s ^TMPGREPORT("DS", "Diagnosis", ILLnessID,"all")=$G(^TMPGREPORT("DS", "Diagnosis", ILLnessID,"all"))+1
    .....i Age>"45" s ^TMPGREPORT("DS", "Diagnosis", ILLnessID,">45")=$G(^TMPGREPORT("DS", "Diagnosis", ILLnessID,">45"))+1
    .....e  s ^TMPGREPORT("DS", "Diagnosis", ILLnessID,"<=45")=$G(^TMPGREPORT("DS", "Diagnosis", ILLnessID,"<=45"))+1
	.i 1=IsDiagnosis d
	..// 统计团体的有疾病体检人数
	..s CurNumber=+$G(^TMPGREPORT("DS", "DiagnosisCount"))
	..s CurNumber=+CurNumber+1
	..s ^TMPGREPORT("DS", "DiagnosisCount")=+CurNumber
}

/// 统计发病率
/// d ##class(web.DHCPE.GroupReport).GetGroupDiagnosisPercent(47)
/// 
ClassMethod GetGroupDiagnosisPercent(GADMDR As %Library.String = "", PartFlag As %Library.String = "", PreIADMStr As %Library.String = "")
{
	k ^TMPGREPORT("DS")

	d ..GetGroupDiagnosisCount(GADMDR,10,100,10,PartFlag,PreIADMStr)

	
	//b //GetGroupDiagnosisPercent
	// 团体体检人数
	s TotalCount=$G(^TMPGREPORT("DS", "TotalHCount"))
	//q:TotalCount=""
	
	s DiagnosisCount=$G(^TMPGREPORT("DS", "DiagnosisCount"))
	s DiagnosisPercent=""
	i +TotalCount'=0 s DiagnosisPercent=DiagnosisCount/TotalCount*100
	i DiagnosisPercent'="" s DiagnosisPercent=$fn(DiagnosisPercent,"",2)
	s ^TMPGREPORT("DS", "DiagnosisPercent")=DiagnosisPercent
	
   
	
	s EDDiagnoseConclus=""
	f  s EDDiagnoseConclus=$O(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus)) Q:(""=EDDiagnoseConclus)  d
	.
	.// 疾病的发病人数
	.s DiagnosisCount=$G(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "DiagnosisCount"))
	.q:DiagnosisCount=""
	.s ^TMPGREPORT("DS", "Count", DiagnosisCount,EDDiagnoseConclus)=EDDiagnoseConclus  //按发病率统计
	.
	.// 疾病的发病率
	.i +TotalCount'=0 s DiagnosisPercent=DiagnosisCount/TotalCount*100
	.s DiagnosisPercent=$fn(DiagnosisPercent,"",2)
	.s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "Percent")=DiagnosisPercent
	.s ^TMPGREPORT("DS", "Percent", DiagnosisPercent)=EDDiagnoseConclus  //按发病率排序
	.
	.s Sex=""
	.f  s Sex=$O(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "Sex", "DiagnosisCount", Sex)) Q:(""=Sex)  d
	..s SexTotal=$G(^TMPGREPORT("DS","Sex", "HCount", Sex))
	..// 疾病的某性别人数
	..s SexCount=$G(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "Sex", "DiagnosisCount", Sex))
	..
	..// 疾病在团体中的发病率 
	..s SexPerent=$FN(SexCount/SexTotal*100,"",2)
	..
	..s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "Sex", "Sex/Total", Sex)=SexPerent
	..
	..// 某性别在发病人中的比例
	..s SexPerent=$FN(SexCount/DiagnosisCount*100,"",2)
	..s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "Sex", "Sex/Diagnosis", Sex)=SexPerent
	..
	.
	.s AgeArea=""
	.f  s AgeArea=$O(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "AgeArea", "Count", AgeArea)) Q:(""=AgeArea)  d
	..s AgeAreaCount=$G(^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "AgeArea", "Count", AgeArea, GADMDR))
	..
	..// 团体中某种疾病在某年龄段的发病率 
	..i +TotalCount'=0 s AgeAreaPerent=AgeAreaCount/TotalCount*100
	..s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "AgeArea", "AgeArea/Total", AgeArea)=AgeAreaPerent
	..
	..
	..// 某年龄段在发病人群中所占的比例
	..s AgeAreaPerent=AgeAreaCount/DiagnosisCount*100
	..s ^TMPGREPORT("DS", "Diagnosis", EDDiagnoseConclus, "AgeArea", "AgeArea/Diagnosis", AgeArea)=AgeAreaPerent
	..
}

/// 获取年龄所在的区间
/// w ##class(web.DHCPE.GroupReport).GetAgeArea("0","100","10",26)
ClassMethod GetAgeArea(aAgeFrom, aAgeTo, aAgeStep, aAge)
{
	n LowerAgeArea,HeightAgeArea
	Q:(aAge>aAgeTo) ">"_aAgeTo
	Q:(aAge<aAgeFrom) "<"_aAgeFrom
	s n=(aAge-aAgeFrom)\aAgeStep
	s LowerAgeArea=aAgeFrom+(aAgeStep*n)
	s HeightAgeArea=aAgeFrom+(aAgeStep*(n+1))
	s:(HeightAgeArea>aAgeTo) HeightAgeArea=aAgeTo
	i $g(^DHCPESetting("DHCPE","HospitalCode"))="YY" s HeightAgeArea=HeightAgeArea-1
	Q LowerAgeArea_"-"_HeightAgeArea
}

ClassMethod GetAgeAreaFlag(Age)
{
	s Age=+$G(Age)
	
    q:(Age<20) 1
	q:(Age>=20)&(Age<=29) 2
	q:(Age>=30)&(Age<=39) 3
	q:(Age>=40)&(Age<=49) 4
	q:(Age>=50)&(Age<=59) 5
	q:(Age>=60)&(Age<=69) 6
	q:(Age>=70) 7
	
	q
}

ClassMethod OutHeaderToWeb()
{

	w "<P class=ParagraphOut>"
	w "根据"
	w "的安排，我中心对贵单位人员进行了体检，现将汇总分析报告提交贵方，供指导贵单位人员健康工作，提高健康水平之参考。"
	w "</p>"
	w "<p class=ParagraphOut></p>",!
	w "<p class=ParagraphOut></p>",!
	w "<p class=ParagraphOut></p>",!
	w "<p class=ParagraphOut></p>",!
	Q ""
}

ClassMethod GetGroupInfo(GADMDR As %Library.String = "")
{
	k ^TMPGREPORT("GInfor")
	//  DHC_PE_GADM.{ GADM_GBI_DR}
	s GBIDR=$P($G(^DHCPEGADM(GADMDR)),"^",1)
	s CRMID=$P($G(^DHCPEGADM(GADMDR)),"^",2)
	s StartDate=$P($G(^DHCPEPreGADM(CRMID)),"^",2)
	i StartDate'="" s StartDate=$ZD(StartDate,3)
	s EndDate=$P($G(^DHCPEPreGADM(CRMID)),"^",3)
	i EndDate'="" s EndDate=$ZD(EndDate,3)
	s ^TMPGREPORT("GInfor","GBIDR")=GBIDR
	//  DHC_PE_GBaseInfo.{ GBI_Desc }
	s GroupName=$P($G(^DHCPEGBI(GBIDR)),"^",2)
	s ^TMPGREPORT("GInfor","GName")=GroupName
	s ^TMPGREPORT("GInfor","StartDate")=StartDate
	s ^TMPGREPORT("GInfor","EndDate")=EndDate
	Q GroupName
}

ClassMethod OutBodyToWeb()
{
	Q ""
}

ClassMethod OutFooterToWeb()
{
	Q ""
}

/// w ##class(web.DHCPE.GroupReport).DiagnosisOutWeb(13)
/// 
ClassMethod DiagnosisOutWeb(GADMDR As %Library.String = "")
{
	//d ..GetGroupDiagnosisPercent(GADMDR)

	s Diagnosis=""
	f  s Diagnosis=$O(^TMPGREPORT("DS", "Diagnosis", Diagnosis)) Q:(""=Diagnosis)  d
	.w "<table width='100%'  border='0'>",!
	.w "<tr>",!
	.w "<td width='100px'>发现印象</td>",!
	.w "<td>"_$G(^TMPGREPORT("DS", "Diagnosis", Diagnosis))_"</td>",!
	.w "<td>"_"共有"_$G(^TMPGREPORT("DS", "Diagnosis", Diagnosis, "DiagnosisCount"))_"人"_"</td>",!
	.w "<td>"_"(占已检人数的"_$G(^TMPGREPORT("DS", "Diagnosis", Diagnosis, "Percent"))_"%)"_"</td>",!
	.w "</tr>",!
	.w "<tr>",!
	.w "<td width='100px'>名单如下</td>",!
	.w "<td colspan=3>"_$G(^TMPGREPORT("DS", "Diagnosis", Diagnosis, "List"))_"</td>",!
	.w "</tr>",!
	.w "<tr>",!
	.w "<td  width='100px' align='left' valign='top'>建议</td>",!
	.w "<td colspan=3>"
	.w "<textarea wrap=PHYSICAL class=TextOut readonly>"
	.w $G(^TMPGREPORT("DS", "Diagnosis", Diagnosis,"DiagnoseDetail"))
	.w "</textarea>"
	.w "</td>",!
	.w "</tr>",!
	.w "</table>",!
	.
}

/// 团体患病排序 d ##class(web.DHCPE.GroupReport).DiagnosisSort()
ClassMethod DiagnosisSort()
{
	//^TMPGREPORT("DS", "Diagnosis", Diagnosis, "Sex", "DiagnosisCount", PAPERSex)
	s SortDiagnosis=0
	f  s SortDiagnosis=$O(^TMPGREPORT("DS", "Diagnosis", SortDiagnosis)) q:SortDiagnosis=""  d
	.s SortCount=$G(^TMPGREPORT("DS", "Diagnosis", SortDiagnosis, "DiagnosisCount"))
	.q:SortCount=""
	.s Sort=$O(^TMPGREPORT("DS","DiagnosisSortTemp",SortCount,""),-1)
	.i Sort="" s Sort=0
	.s Sort=Sort+1
	.s ^TMPGREPORT("DS","DiagnosisSortTemp",SortCount,Sort)=SortDiagnosis
	.
	.s Sex=""
	.f  s Sex=$o(^TMPGREPORT("DS", "Diagnosis", SortDiagnosis, "Sex", "DiagnosisCount", Sex)) q:Sex=""  d
	..s SortCount=$G(^TMPGREPORT("DS", "Diagnosis", SortDiagnosis, "Sex", "DiagnosisCount", Sex))
	..q:SortCount=""
	..s Sort=$O(^TMPGREPORT("DS","DiagnosisSortSexTemp",Sex,SortCount,""),-1)
	..i Sort="" s Sort=0
	..s Sort=Sort+1
	..s ^TMPGREPORT("DS","DiagnosisSortSexTemp",Sex,SortCount,Sort)=SortDiagnosis
	
	k ^TMPGREPORT("DS","DiagnosisSort")
	s i=1
	s SortCount=""
	s DiagnosisStr=""
	f  s SortCount=$O(^TMPGREPORT("DS","DiagnosisSortTemp",SortCount),-1) q:SortCount=""  d
	.s Sort=0
	.f  s Sort=$o(^TMPGREPORT("DS","DiagnosisSortTemp",SortCount,Sort)) q:Sort=""  d
	..s Diagnosis=$g(^TMPGREPORT("DS","DiagnosisSortTemp",SortCount,Sort))
	..s ^TMPGREPORT("DS","DiagnosisSort",i)=Diagnosis
	..
	..
	..
	..//s i=i+1
	..s DiagnosisPerson=$G(^TMPGREPORT("DS", "Diagnosis", Diagnosis, "DiagnosisCount"))
	..s DiagnosisPercent=$G(^TMPGREPORT("DS", "Diagnosis", Diagnosis, "Percent"))
    ..i DiagnosisStr="" d 
	...s DiagnosisStr="<TR><TD class=td>"_$G(^TMPGREPORT("DS","Diagnosis",Diagnosis))_"</TD><TD class=td>"_"("_DiagnosisPerson_", "_DiagnosisPercent_"%)"_"</TD>"
	..e  d
	...i i#2=1 s DiagnosisStr=DiagnosisStr_"<TR><TD class=td>"_$G(^TMPGREPORT("DS","Diagnosis",Diagnosis))_"</TD><TD class=td>"_"("_DiagnosisPerson_", "_DiagnosisPercent_"%)"_"</TD>"
	...i i#2=0 s DiagnosisStr=DiagnosisStr_"<TD class=td>"_$G(^TMPGREPORT("DS","Diagnosis",Diagnosis))_"</TD><TD class=td>"_"("_DiagnosisPerson_", "_DiagnosisPercent_"%)"_"</TD></TR>"
	..s i=i+1
	i i#2=0 s DiagnosisStr=DiagnosisStr_"<TD class=td>"_"&nbsp"_"</TD>"_"<TD class=td>"_"&nbsp"_"</TD></TR>"
	
	s DiagnosisTotal=i-1
	
	//添加
	k ^TMPGREPORT("DS","DiagnosisSexSort")
	s i=1
	s SortCount=""
	s MDiagnosisStr="",AgeMDiagnosisStr="",AgeMDiagnosisOneStr=""
	s AgeMDiagnosisStr="<TR><TD class=td>"_"疾病名称"_"</TD><TD class=td>"_"患病人数"_"</TD><TD class=td>"_"<20"_"</TD><TD class=td>"_"20-29"
	s AgeMDiagnosisStr=AgeMDiagnosisStr_"</TD><TD class=td>"_"30-39"_"</TD><TD class=td>"_"40-49"_"</TD><TD class=td>"_"50-59"_"</TD><TD class=td>"_"60-69"
	s AgeMDiagnosisStr=AgeMDiagnosisStr_"</TD><TD class=td>"_">=70"_"</TD></TR>"
	s Sex="男"
	f  s SortCount=$O(^TMPGREPORT("DS","DiagnosisSortSexTemp",Sex,SortCount),-1) q:(SortCount="")||(i>20)  d
	.s Sort=0
	.f  s Sort=$O(^TMPGREPORT("DS","DiagnosisSortSexTemp",Sex,SortCount,Sort)) q:(Sort="")||(i>20)  d
	..s Diagnosis=$g(^TMPGREPORT("DS","DiagnosisSortSexTemp",Sex,SortCount,Sort))
	..s ^TMPGREPORT("DS","DiagnosisSexSort",Sex,i)=Diagnosis
	..//s i=i+1
	..s DiagnosisPerson=$G(^TMPGREPORT("DS", "Diagnosis", Diagnosis, "Sex", "DiagnosisCount",Sex))
	..s DiagnosisPercent=$G(^TMPGREPORT("DS", "Diagnosis", Diagnosis, "Sex", "Sex/Total", Sex))
	..i MDiagnosisStr="" d 
	...s MDiagnosisStr="<TR><TD class=td>"_$G(^TMPGREPORT("DS","Diagnosis",Diagnosis))_"</TD><TD class=td>"_"("_DiagnosisPerson_", "_DiagnosisPercent_"%)"_"</TD>"
	..e  d
	...i i#2=1 s MDiagnosisStr=MDiagnosisStr_"<TR><TD class=td>"_$G(^TMPGREPORT("DS","Diagnosis",Diagnosis))_"</TD><TD class=td>"_"("_DiagnosisPerson_", "_DiagnosisPercent_"%)"_"</TD>"
	...i i#2=0 s MDiagnosisStr=MDiagnosisStr_"<TD class=td>"_$G(^TMPGREPORT("DS","Diagnosis",Diagnosis))_"</TD><TD class=td>"_"("_DiagnosisPerson_", "_DiagnosisPercent_"%)"_"</TD></TR>"
	..s i=i+1
	..s AgeMDiagnosisOneStr=..GetAgeDiagnosisStr(Diagnosis,Sex)
    ..i AgeMDiagnosisStr=""  s AgeMDiagnosisStr=AgeMDiagnosisOneStr
    ..else  s AgeMDiagnosisStr=AgeMDiagnosisStr_""_AgeMDiagnosisOneStr
	i i#2=0 s MDiagnosisStr=MDiagnosisStr_"<TD class=td>"_"&nbsp"_"</TD>"_"<TD class=td>"_"&nbsp"_"</TD></TR>"	
	i MDiagnosisStr=""  s AgeMDiagnosisStr=""



	s i=1
	s SortCount=""
	s FMDiagnosisStr="",AgeFMDiagnosisOneStr="",AgeFMDiagnosisStr=""
	s AgeFMDiagnosisStr="<TR><TD class=td>"_"疾病名称"_"</TD><TD class=td>"_"患病人数"_"</TD><TD class=td>"_"<20"_"</TD><TD class=td>"_"20-29"
	s AgeFMDiagnosisStr=AgeFMDiagnosisStr_"</TD><TD class=td>"_"30-39"_"</TD><TD class=td>"_"40-49"_"</TD><TD class=td>"_"50-59"_"</TD><TD class=td>"_"60-69"
	s AgeFMDiagnosisStr=AgeFMDiagnosisStr_"</TD><TD class=td>"_">=70"_"</TD></TR>"
	s Sex="女"
	f  s SortCount=$O(^TMPGREPORT("DS","DiagnosisSortSexTemp",Sex,SortCount),-1) q:(SortCount="")||(i>20)  d
	.s Sort=0
	.f  s Sort=$O(^TMPGREPORT("DS","DiagnosisSortSexTemp",Sex,SortCount,Sort)) q:(Sort="")||(i>20)  d
	..s Diagnosis=$g(^TMPGREPORT("DS","DiagnosisSortSexTemp",Sex,SortCount,Sort))
	..s ^TMPGREPORT("DS","DiagnosisSexSort",Sex,i)=Diagnosis
	..//s i=i+1
	..s DiagnosisPerson=$G(^TMPGREPORT("DS", "Diagnosis", Diagnosis, "Sex", "DiagnosisCount",Sex))
	..s DiagnosisPercent=$G(^TMPGREPORT("DS", "Diagnosis", Diagnosis, "Sex", "Sex/Total", Sex))
	..i FMDiagnosisStr="" d 
	...s FMDiagnosisStr="<TR><TD class=td>"_$G(^TMPGREPORT("DS","Diagnosis",Diagnosis))_"</TD><TD class=td>"_"("_DiagnosisPerson_", "_DiagnosisPercent_"%)"_"</TD>"
	..e  d
	...i i#2=1 s FMDiagnosisStr=FMDiagnosisStr_"<TR><TD class=td>"_$G(^TMPGREPORT("DS","Diagnosis",Diagnosis))_"</TD><TD class=td>"_"("_DiagnosisPerson_", "_DiagnosisPercent_"%)"_"</TD>"
	...i i#2=0 s FMDiagnosisStr=FMDiagnosisStr_"<TD class=td>"_$G(^TMPGREPORT("DS","Diagnosis",Diagnosis))_"</TD><TD class=td>"_"("_DiagnosisPerson_", "_DiagnosisPercent_"%)"_"</TD></TR>"
	..s i=i+1
	..s AgeFMDiagnosisOneStr=..GetAgeDiagnosisStr(Diagnosis,Sex)
    ..i AgeFMDiagnosisStr=""  s AgeFMDiagnosisStr=AgeFMDiagnosisOneStr
    ..else  s AgeFMDiagnosisStr=AgeFMDiagnosisStr_""_AgeFMDiagnosisOneStr
	i i#2=0 s FMDiagnosisStr=FMDiagnosisStr_"<TD class=td>"_"&nbsp"_"</TD>"_"<TD class=td>"_"&nbsp"_"</TD></TR>"	
	i FMDiagnosisStr=""  s AgeFMDiagnosisStr=""
	
	k ^TMPGREPORT("DS","DiagnosisSortTemp")
	k ^TMPGREPORT("DS","DiagnosisSortSexTemp")
}

ClassMethod GetAgeDiagnosisStr(Diagnosis, Sex)
{
                
    s TotalPersons=$G(^TMPGREPORT("DS", "Diagnosis", Diagnosis, "Sex", "DiagnosisCount",Sex))
    i $p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)="Y"   d
    .S Diagnosis=$g(^TMPGREPORT("DS", "Diagnosis", Diagnosis))
    s AgeAreaPersonStr="<TR><TD class=td>"_Diagnosis_"</TD><TD class=td>"_TotalPersons_"</TD>"
    f AgeAreaFlag=1:1:7
    { 
    s AgeAreaPerson=0
    s AgeAreaPerson=$g(^TMPGREPORT("DS", "Diagnosis", Diagnosis, "AgeAreaFlag", "Sex",Sex, AgeAreaFlag)) 
    s AgeAreaPersonStr=AgeAreaPersonStr_"<TD class=td>"_AgeAreaPerson_"</TD>"
    }
   S AgeAreaPersonStr=AgeAreaPersonStr_"</TR>"
   
   Q AgeAreaPersonStr
}

/// 获取团体病患数据
ClassMethod GetGADMStatisticData()
{
	// 预约人数
	s TotalCount=$G(^TMPGREPORT("DS", "TotalCount"))
	//q:TotalCount=""
	// 男性客户人数及比例
	s MaleCount=$G(^TMPGREPORT("DS","Sex", "Count", "男"))
	s MalePercent=""
	i +TotalCount'=0 s MalePercent=$fn(MaleCount/TotalCount*100,"",2)
	
	// 女客户人数及比例
	s FemaleCount=$G(^TMPGREPORT("DS","Sex","Count","女"))
	s FemalePercent=""
	i +TotalCount'=0 s FemalePercent=$fn(FemaleCount/TotalCount*100,"",2)
	
	
	// 体检人数
	s HTotalCount=$G(^TMPGREPORT("DS", "TotalHCount"))
	i HTotalCount="" s HTotalCount=0
	//q:HTotalCount=""
	// 男性客户人数及比例
	s HMaleCount=$G(^TMPGREPORT("DS","Sex", "HCount", "男"))
	i HMaleCount="" s HMaleCount=0
	s HMalePercent=""
	i +HTotalCount'=0 s HMalePercent=$fn(HMaleCount/HTotalCount*100,"",2)
	
	// 女客户人数及比例
	s HFemaleCount=$G(^TMPGREPORT("DS","Sex","HCount","女"))
	i HFemaleCount="" s HFemaleCount=0
	s HFemalePercent=""
	i +HFemaleCount'=0 s HFemalePercent=$fn(HFemaleCount/HTotalCount*100,"",2)
	
	// 患有疾病的人数及比例
	s DiagnosisCount=$G(^TMPGREPORT("DS", "DiagnosisCount"))
	s DiagnosisPercent=$G(^TMPGREPORT("DS", "DiagnosisPercent"))
	
	// 正常人数及比例
	s NormalCount=HTotalCount-DiagnosisCount
	s NormalPercent=100-DiagnosisPercent
	
	//各区间人数  2008-09-04
	s AgeAreaTotal=""
	s AgeAreaTotal1=""
	s AgeAreaTotal2=""
	s AgeAreaTotal1=$g(^TMPGREPORT("DS", "AgeArea", "HCount", ">45"))
	s AgeAreaTotal2=$g(^TMPGREPORT("DS", "AgeArea", "HCount", "<=45"))
	i AgeAreaTotal1="" s AgeAreaTotal1=0
	i AgeAreaTotal2="" s AgeAreaTotal2=0

    s AgeAreaTotal=AgeAreaTotal_": "_">45"_"岁:"_AgeAreaTotal1_"人"_"; "_"<=45"_"岁:"_AgeAreaTotal2_"人"
}

/// 获取团体病患数据
ClassMethod GetReportInfo()
{
	// 体检中心名称
	s HosptionName=$G(^DHCPESetting("DHCPE","HospitalName"))
	
	// 总检医师
	s CheckName=""

	
	// 首席总检医师
	s FristCheckName=""

	
	// 报告日期
	s ReportDate=$ZD($H,3)
}

ClassMethod GetGDiagnosis(GADMDR As %Library.String = "")
{
	k ^TMPGREPORT("GDiagnosis")
	s SSID=##class(web.DHCPE.GGSDiagnosis).GetGGSD(GADMDR)
	q:SSID="" ""
 	s Sub=0
 	s Sort=0
 	s i=1
 	i SSID'=""  Do
 	.f  s Sort=$o(^DHCPEGGS(0,"GSSDSort",SSID,Sort)) q:Sort=""  d
 	..s Sub=0
 	..f  s Sub=$o(^DHCPEGGS(0,"GSSDSort",SSID,Sort,Sub)) q:Sub=""  d
 	...s SSRId=SSID_"||"_Sub
 	...s RLID=$p(^DHCPEGGS(SSID,"Diagnosis",Sub),"^",1)
 	...q:RLID=""
 	...s RIDDesc=$p(^DHCPEGGS(SSID,"Diagnosis",Sub),"^",8)
 	...//$p($g(^DHCPEED(RLID,"Detail")),"^",1)
 	...s ItemDesc=$p($g(^DHCPEILLS(RLID)),"^",2)
 	...s User=$p($g(^DHCPEGGS(SSID,"Diagnosis",Sub)),"^",4)
 	...i User'="" s User=$p($g(^SSU("SSUSR",User)),"^",2)
 	...s (Date)=""
 	...s Remark=$p(^DHCPEGGS(SSID,"Diagnosis",Sub),"^",2)
 	...s ReportFlag=$p(^DHCPEGGS(SSID,"Diagnosis",Sub),"^",3)
 	...s GenType=$p(^DHCPEGGS(SSID,"Diagnosis",Sub),"^",7)
 	...i ReportFlag="Y" d
 	....s ^TMPGREPORT("GDiagnosis","RowID",i)=RLID
 	....s ^TMPGREPORT("GDiagnosis","Desc",RLID)=ItemDesc
 	....s ^TMPGREPORT("GDiagnosis","Detail",RLID)=RIDDesc
 	....s i=i+1
}

}
