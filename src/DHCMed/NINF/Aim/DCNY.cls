Class DHCMed.NINF.Aim.DCNY Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

//临床上报ID  指向CRReport

Property CRReportDR As %String [ Required ];

Index CRReportDRIndex On CRReportDR [ Unique ];

//CRAB

Property CRAB As %String;

//MRSA

Property MRSA As %String;

//MDRPA

Property MDRPA As %String;

//VRE

Property VRE As %String;

//CRE

Property CRE As %String;

//感染部位

Property Infpos1 As %String;

//送检日期

Property Infpos1PathDate As %String;

//标本

Property InfPos1Sample As %String;

//病原体

Property InfPos1Object As %String;

//感染种类（是否医院感染）

Property IfPos1HosInf As %String;

//感染

Property Pos1MixedInf As %String;

//继发感染

Property Pos1SecondaryInf As %String;

//影起其他感染

Property Pos1CauseOtherInf As %String;

//感染部位

Property Infpos2 As %String;

//送检日期

Property Infpos2PathDate As %String;

//标本

Property InfPos2Sample As %String;

//病原体

Property InfPos2Object As %String;

//感染种类（是否医院感染）

Property IfPos2HosInf As %String;

//感染

Property Pos2MixedInf As %String;

//继发感染

Property Pos2SecondaryInf As %String;

//影起其他感染

Property Pos2CauseOtherInf As %String;

//感染部位

Property Infpos3 As %String;

//送检日期

Property Infpos3PathDate As %String;

//标本

Property InfPos3Sample As %String;

//病原体

Property InfPos3Object As %String;

//感染种类（是否医院感染）

Property IfPos3HosInf As %String;

//感染

Property Pos3MixedInf As %String;

//继发感染

Property Pos3SecondaryInf As %String;

//影起其他感染

Property Pos3CauseOtherInf As %String;

//感染部位

Property Infpos4 As %String;

//送检日期

Property Infpos4PathDate As %String;

//标本

Property InfPos4Sample As %String;

//病原体

Property InfPos4Object As %String;

//感染种类（是否医院感染）

Property IfPos4HosInf As %String;

//感染

Property Pos4MixedInf As %String;

//继发感染

Property Pos4SecondaryInf As %String;

//影起其他感染

Property Pos4CauseOtherInf As %String;

//隔离相关报告日期

Property IsolationRepDate As %String;

//科室接电话人员DR

Property TelUser As %String;

//主管医生

Property DocDR As %String;

//隔离日期

Property Isolation1Date As %String;

//是够隔离

Property IfIsolation1 As %String;

//是否使用隔离标志

Property IfIsolation1Flag As %String;

//是否配备手卫生用品

Property HandHealth1 As %String;

//医疗用品是否专人专用

Property PersonalUse1 As %String;

//床旁环境消毒是否符合要求

Property DisInfRit1 As %String;

//科室签名DR

Property LocSign1 As %String;

//监控人签名DR

Property ObserUser1 As %String;

//隔离日期

Property Isolation2Date As %String;

//是够隔离

Property IfIsolation2 As %String;

//是否使用隔离标志

Property IfIsolation2Flag As %String;

//是否配备手卫生用品

Property HandHealth2 As %String;

//医疗用品是否专人专用

Property PersonalUse2 As %String;

//床旁环境消毒是否符合要求

Property DisInfRit2 As %String;

//科室签名DR

Property LocSign2 As %String;

//监控人签名DR

Property ObserUser2 As %String;

//隔离日期

Property Isolation3Date As %String;

//是够隔离

Property IfIsolation3 As %String;

//是否使用隔离标志

Property IfIsolation3Flag As %String;

//是否配备手卫生用品

Property HandHealth3 As %String;

//医疗用品是否专人专用

Property PersonalUse3 As %String;

//床旁环境消毒是否符合要求

Property DisInfRit3 As %String;

//科室签名DR

Property LocSign3 As %String;

//监控人签名DR

Property ObserUser3 As %String;

//糖尿病

Property IfTNB As %String;

//高血压

Property IfGXY As %String;

//呼吸衰竭

Property IfHXSJ As %String;

//肾功不全

Property IfSGBQ As %String;

//心功不全

Property IfXGBQ As %String;

//结核病

Property IfJHB As %String;

//早产儿

Property IfZCE As %String;

//肿瘤

Property IfZL As %String;

//血液病

Property IfXYB As %String;

//HIV

Property IfHIV As %String;

//过去一年接受免疫抑制药物治疗

Property YZYWTreatInYear As %String;

//过去一年接受糖皮质激素治疗

Property TPZJSTreatInYear As %String;

//昏迷

Property IfComa As %String;

//侵入性操作观察日期

Property ObserDate1 As %String;

//外科干预

Property WKGY1 As %String;

//气道类型

Property DipeType1 As %String;

//上呼吸机日期

Property OnHXJDate1 As %String;

//脱呼吸机日期

Property OffHXJDate1 As %String;

//中心静脉置管部位

Property CVPPos1 As %String;

//中心静脉导管类型

Property CVPType1 As %String;

//中心静脉插管日期

Property OnCVPDate1 As %String;

//中心静脉拔管日期

Property OffCVPDate1 As %String;

//尿管类型

Property CathetersType1 As %String;

//插管时间

Property OnCathetersDate1 As %String;

//拔管时间

Property OffCathetersDate1 As %String;

//侵入性操作观察日期

Property ObserDate2 As %String;

//外科干预

Property WKGY2 As %String;

//气道类型

Property DipeType2 As %String;

//上呼吸机日期

Property OnHXJDate2 As %String;

//脱呼吸机日期

Property OffHXJDate2 As %String;

//中心静脉置管部位

Property CVPPos2 As %String;

//中心静脉导管类型

Property CVPType2 As %String;

//中心静脉插管日期

Property OnCVPDate2 As %String;

//中心静脉拔管日期

Property OffCVPDate2 As %String;

//尿管类型

Property CathetersType2 As %String;

//插管时间

Property OnCathetersDate2 As %String;

//拔管时间

Property OffCathetersDate2 As %String;

//侵入性操作观察日期

Property ObserDate3 As %String;

//外科干预

Property WKGY3 As %String;

//气道类型

Property DipeType3 As %String;

//上呼吸机日期

Property OnHXJDate3 As %String;

//脱呼吸机日期

Property OffHXJDate3 As %String;

//中心静脉置管部位

Property CVPPos3 As %String;

//中心静脉导管类型

Property CVPType3 As %String;

//中心静脉插管日期

Property OnCVPDate3 As %String;

//中心静脉拔管日期

Property OffCVPDate3 As %String;

//尿管类型

Property CathetersType3 As %String;

//插管时间

Property OnCathetersDate3 As %String;

//拔管时间

Property OffCathetersDate3 As %String;

//起止日期

Property DrugIn7SDDate1 As %String;

//名称

Property DrugName1 As %String;

//剂量和用法

Property DoseAndMethod1 As %String;

//起止日期

Property DrugIn7SDDate2 As %String;

//名称

Property DrugName2 As %String;

//剂量和用法

Property DoseAndMethod2 As %String;

//起止日期

Property DrugIn7SDDate3 As %String;

//名称

Property DrugName3 As %String;

//剂量和用法

Property DoseAndMethod3 As %String;

//起止日期

Property DrugIn7SDDate4 As %String;

//名称

Property DrugName4 As %String;

//剂量和用法

Property DoseAndMethod4 As %String;

//起止日期

Property DrugIn7SDDate5 As %String;

//名称

Property DrugName5 As %String;

//剂量和用法

Property DoseAndMethod5 As %String;

//起止日期

Property DrugIn7SDDate6 As %String;

//名称

Property DrugName6 As %String;

//剂量和用法

Property DoseAndMethod6 As %String;

//起止日期

Property DrugIn7SDDate7 As %String;

//名称

Property DrugName7 As %String;

//剂量和用法

Property DoseAndMethod7 As %String;

//起止日期

Property DrugIn7SDDate8 As %String;

//名称

Property DrugName8 As %String;

//剂量和用法

Property DoseAndMethod8 As %String;

//起止日期

Property DrugIn7SDDate9 As %String;

//名称

Property DrugName9 As %String;

//剂量和用法

Property DoseAndMethod9 As %String;

//起止日期

Property DrugIn7SDDate10 As %String;

//名称

Property DrugName10 As %String;

//剂量和用法

Property DoseAndMethod10 As %String;

//感染前七天是否使用抗生素

Property DrugIn7Day As %String;

//是否针对用药

Property IfSpecialDrug As %String;

//愈后情况

Property TreatResult As %String;

//填表人

Property FillUser As %String;

//填表日期

Property FillDate As %String;

///   Creator：     lk
///   CreatDate：   2012-05-30
///   Description:  将对象格式化为字符串
///   Table：        DHCMed.NINF.Aim.DCNY
///   Input：       separete:指定的分隔符
///   Return：      返回各属性值，按照separete分隔
///  
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..CRReportDR_separete
	set return=return_..CRAB_separete
	set return=return_..MRSA_separete
	set return=return_..MDRPA_separete
	set return=return_..VRE_separete
	set return=return_..CRE_separete
	set return=return_..Infpos1_separete
	set return=return_..Infpos1PathDate_separete
	set return=return_..InfPos1Sample_separete
	set return=return_..InfPos1Object_separete
	set return=return_..IfPos1HosInf_separete
	set return=return_..Pos1MixedInf_separete
	set return=return_..Pos1SecondaryInf_separete
	set return=return_..Pos1CauseOtherInf_separete
	set return=return_..Infpos2_separete
	set return=return_..Infpos2PathDate_separete
	set return=return_..InfPos2Sample_separete
	set return=return_..InfPos2Object_separete
	set return=return_..IfPos2HosInf_separete
	set return=return_..Pos2MixedInf_separete
	set return=return_..Pos2SecondaryInf_separete
	set return=return_..Pos2CauseOtherInf_separete
	set return=return_..Infpos3_separete
	set return=return_..Infpos3PathDate_separete
	set return=return_..InfPos3Sample_separete
	set return=return_..InfPos3Object_separete
	set return=return_..IfPos3HosInf_separete
	set return=return_..Pos3MixedInf_separete
	set return=return_..Pos3SecondaryInf_separete
	set return=return_..Pos3CauseOtherInf_separete
	set return=return_..Infpos4_separete
	set return=return_..Infpos4PathDate_separete
	set return=return_..InfPos4Sample_separete
	set return=return_..InfPos4Object_separete
	set return=return_..IfPos4HosInf_separete
	set return=return_..Pos4MixedInf_separete
	set return=return_..Pos4SecondaryInf_separete
	set return=return_..Pos4CauseOtherInf_separete
	set return=return_..IsolationRepDate_separete
	set return=return_..TelUser_separete
	set return=return_..DocDR_separete
	set return=return_..Isolation1Date_separete
	set return=return_..IfIsolation1_separete
	set return=return_..IfIsolation1Flag_separete
	set return=return_..HandHealth1_separete
	set return=return_..PersonalUse1_separete
	set return=return_..DisInfRit1_separete
	set return=return_..LocSign1_separete
	set return=return_..ObserUser1_separete
	set return=return_..Isolation2Date_separete
	set return=return_..IfIsolation2_separete
	set return=return_..IfIsolation2Flag_separete
	set return=return_..HandHealth2_separete
	set return=return_..PersonalUse2_separete
	set return=return_..DisInfRit2_separete
	set return=return_..LocSign2_separete
	set return=return_..ObserUser2_separete
	set return=return_..Isolation3Date_separete
	set return=return_..IfIsolation3_separete
	set return=return_..IfIsolation3Flag_separete
	set return=return_..HandHealth3_separete
	set return=return_..PersonalUse3_separete
	set return=return_..DisInfRit3_separete
	set return=return_..LocSign3_separete
	set return=return_..ObserUser3_separete
	set return=return_..IfTNB_separete
	set return=return_..IfGXY_separete
	set return=return_..IfHXSJ_separete
	set return=return_..IfSGBQ_separete
	set return=return_..IfXGBQ_separete
	set return=return_..IfJHB_separete
	set return=return_..IfZCE_separete
	set return=return_..IfXYB_separete
	set return=return_..IfHIV_separete
	set return=return_..YZYWTreatInYear_separete
	set return=return_..TPZJSTreatInYear_separete
	set return=return_..IfComa_separete
	set return=return_..ObserDate1_separete
	set return=return_..WKGY1_separete
	set return=return_..DipeType1_separete
	set return=return_..OnHXJDate1_separete
	set return=return_..OffHXJDate1_separete
	set return=return_..CVPPos1_separete
	set return=return_..CVPType1_separete
	set return=return_..OnCVPDate1_separete
	set return=return_..OffCVPDate1_separete
	set return=return_..CathetersType1_separete
	set return=return_..OnCathetersDate1_separete
	set return=return_..OffCathetersDate1_separete
	set return=return_..ObserDate2_separete
	set return=return_..WKGY2_separete
	set return=return_..DipeType2_separete
	set return=return_..OnHXJDate2_separete
	set return=return_..OffHXJDate2_separete
	set return=return_..CVPPos2_separete
	set return=return_..CVPType2_separete
	set return=return_..OnCVPDate2_separete
	set return=return_..OffCVPDate2_separete
	set return=return_..CathetersType2_separete
	set return=return_..OnCathetersDate2_separete
	set return=return_..OffCathetersDate2_separete
	set return=return_..ObserDate3_separete
	set return=return_..WKGY3_separete
	set return=return_..DipeType3_separete
	set return=return_..OnHXJDate3_separete
	set return=return_..OffHXJDate3_separete
	set return=return_..CVPPos3_separete
	set return=return_..CVPType3_separete
	set return=return_..OnCVPDate3_separete
	set return=return_..OffCVPDate3_separete
	set return=return_..CathetersType3_separete
	set return=return_..OnCathetersDate3_separete
	set return=return_..OffCathetersDate3_separete
	set return=return_..DrugIn7SDDate1_separete
	set return=return_..DrugName1_separete
	set return=return_..DoseAndMethod1_separete
	set return=return_..DrugIn7SDDate2_separete
	set return=return_..DrugName2_separete
	set return=return_..DoseAndMethod2_separete
	set return=return_..DrugIn7SDDate3_separete
	set return=return_..DrugName3_separete
	set return=return_..DoseAndMethod3_separete
	set return=return_..DrugIn7SDDate4_separete
	set return=return_..DrugName4_separete
	set return=return_..DoseAndMethod4_separete
	set return=return_..DrugIn7SDDate5_separete
	set return=return_..DrugName5_separete
	set return=return_..DoseAndMethod5_separete
	set return=return_..DrugIn7SDDate6_separete
	set return=return_..DrugName6_separete
	set return=return_..DoseAndMethod6_separete
	set return=return_..DrugIn7SDDate7_separete
	set return=return_..DrugName7_separete
	set return=return_..DoseAndMethod7_separete
	set return=return_..DrugIn7SDDate8_separete
	set return=return_..DrugName8_separete
	set return=return_..DoseAndMethod8_separete
	set return=return_..DrugIn7SDDate9_separete
	set return=return_..DrugName9_separete
	set return=return_..DoseAndMethod9_separete
	set return=return_..DrugIn7SDDate10_separete
	set return=return_..DrugName10_separete
	set return=return_..DoseAndMethod10_separete
    set return=return_..DrugIn7Day_separete
    set return=return_..IfSpecialDrug_separet
	set return=return_..TreatResult_separete
	set return=return_..FillUser_separete
	set return=return_..FillDate
	quit return
}

///  Creator：     lk
///  CreatDate：   2012-05-30
///  Description:  根据ID取手术部位感染报告 
///  Table：       DHCMed.NINF.Aim.DCNY
///  Input：       ID:    DHCMed.NINF.Aim.DCNY.ID
///  Return：      返回obj
///  w ##class(DHCMed.NINF.Aim.DCNY).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.Aim.DCNY
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Aim.DCNY).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Aim.DCNY).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

///  Creator：     lk
///  CreatDate：   2012-05-30
///  Description:  根据ID取手术部位感染报告
///  Table：       DHCMed.NINF.Aim.DCNY
///  Input：       ID:    DHCMed.NINF.Aim.DCNY.ID
///                separete: 指定的分隔符
///  Return：      返回obj.ToString()
///  w ##class(DHCMed.NINF.Aim.DCNY).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

///   Creator：     lk
///   CreatDate：   2012-05-30
///   Description:  根据ID取手术部位感染报告
///   Table：       DHCMed.NINF.Aim.DCNY
///   Input：       各属性列表 ^分隔
///   Return：      成功：返回id，失败：返回<0的代码
///   w ##class(DHCMed.NINF.Aim.DCNY).Update("^2^3^5^^1^^^^EPD","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.NINF.Aim.DCNY).%New()
		} 
	else {
		set obj=##class(DHCMed.NINF.Aim.DCNY).%OpenId(ID)
		}
	set obj.CRReportDR=$p(InStr,separete,2)
	set obj.CRAB=$p(InStr,separete,3)
	set obj.MRSA=$p(InStr,separete,4)
	set obj.MDRPA=$p(InStr,separete,5)
	set obj.VRE=$p(InStr,separete,6)
	set obj.CRE=$p(InStr,separete,7)
	set obj.Infpos1=$p(InStr,separete,8)
	set obj.Infpos1PathDate=$p(InStr,separete,9)
	set obj.InfPos1Sample=$p(InStr,separete,10)
	set obj.InfPos1Object=$p(InStr,separete,11)
	set obj.IfPos1HosInf=$p(InStr,separete,12)
	set obj.Pos1MixedInf=$p(InStr,separete,13)
	set obj.Pos1SecondaryInf =$p(InStr,separete,14)
	set obj.Pos1CauseOtherInf=$p(InStr,separete,15)
	set obj.Infpos2=$p(InStr,separete,16)
	set obj.Infpos2PathDate=$p(InStr,separete,17)
	set obj.InfPos2Sample=$p(InStr,separete,18)
	set obj.InfPos2Object=$p(InStr,separete,19)
	set obj.IfPos2HosInf=$p(InStr,separete,20)
	set obj.Pos2MixedInf=$p(InStr,separete,21)
	set obj.Pos2SecondaryInf =$p(InStr,separete,22)
	set obj.Pos2CauseOtherInf=$p(InStr,separete,23)
	set obj.Infpos3=$p(InStr,separete,24)
	set obj.Infpos3PathDate=$p(InStr,separete,25)
	set obj.InfPos3Sample=$p(InStr,separete,26)
	set obj.InfPos3Object=$p(InStr,separete,27)
	set obj.IfPos3HosInf=$p(InStr,separete,28)
	set obj.Pos3MixedInf=$p(InStr,separete,29)
	set obj.Pos3SecondaryInf =$p(InStr,separete,30)
	set obj.Pos3CauseOtherInf=$p(InStr,separete,31)
	set obj.Infpos4=$p(InStr,separete,32)
	set obj.Infpos4PathDate=$p(InStr,separete,33)
	set obj.InfPos4Sample=$p(InStr,separete,34)
	set obj.InfPos4Object=$p(InStr,separete,35)
	set obj.IfPos4HosInf=$p(InStr,separete,36)
	set obj.Pos4MixedInf=$p(InStr,separete,37)
	set obj.Pos4SecondaryInf =$p(InStr,separete,38)
	set obj.Pos4CauseOtherInf=$p(InStr,separete,39)
	set obj.IsolationRepDate=$p(InStr,separete,40)
	set obj.TelUser=$p(InStr,separete,41)
	set obj.DocDR=$p(InStr,separete,42)
	set obj.Isolation1Date=$p(InStr,separete,43)
	set obj.IfIsolation1=$p(InStr,separete,44)
	set obj.IfIsolation1Flag=$p(InStr,separete,45)
	set obj.HandHealth1=$p(InStr,separete,46)
	set obj.PersonalUse1=$p(InStr,separete,47)
	set obj.DisInfRit1=$p(InStr,separete,48)
	set obj.LocSign1=$p(InStr,separete,49)
	set obj.ObserUser1=$p(InStr,separete,50)
	set obj.Isolation1Date=$p(InStr,separete,51)
	set obj.IfIsolation2=$p(InStr,separete,52)
	set obj.IfIsolation2Flag=$p(InStr,separete,53)
	set obj.HandHealth2=$p(InStr,separete,54)
	set obj.PersonalUse2=$p(InStr,separete,55)
	set obj.DisInfRit2=$p(InStr,separete,56)
	set obj.LocSign2=$p(InStr,separete,57)
	set obj.ObserUser2=$p(InStr,separete,58)
	set obj.Isolation1Date=$p(InStr,separete,59)
	set obj.IfIsolation3=$p(InStr,separete,60)
	set obj.IfIsolation3Flag=$p(InStr,separete,61)
	set obj.HandHealth3=$p(InStr,separete,62)
	set obj.PersonalUse3=$p(InStr,separete,63)
	set obj.DisInfRit3=$p(InStr,separete,64)
	set obj.LocSign3=$p(InStr,separete,65)
	set obj.ObserUser3=$p(InStr,separete,66)
	set obj.IfTNB=$p(InStr,separete,67)
	set obj.IfGXY=$p(InStr,separete,68)
	set obj.IfHXSJ=$p(InStr,separete,69)
	set obj.IfSGBQ=$p(InStr,separete,70)
	set obj.IfXGBQ=$p(InStr,separete,71)
	set obj.IfJHB=$p(InStr,separete,72)
	set obj.IfZCE=$p(InStr,separete,73)
	set obj.IfZL=$p(InStr,separete,74)
	set obj.IfXYB=$p(InStr,separete,75)
	set obj.IfHIV=$p(InStr,separete,76)
	set obj.YZYWTreatInYear=$p(InStr,separete,77)
	set obj.TPZJSTreatInYear=$p(InStr,separete,78)
	set obj.IfComa=$p(InStr,separete,79)
	set obj.ObserDate1=$p(InStr,separete,80)
	set obj.WKGY1=$p(InStr,separete,81)
	set obj.DipeType1=$p(InStr,separete,82)
	set obj.OnHXJDate1=$p(InStr,separete,83)
	set obj.OffHXJDate1=$p(InStr,separete,84)
	set obj.CVPPos1=$p(InStr,separete,85)
	set obj.CVPType1=$p(InStr,separete,86)
	set obj.OnCVPDate1=$p(InStr,separete,87)
	set obj.OffCVPDate1=$p(InStr,separete,88)
	set obj.CathetersType1=$p(InStr,separete,89)
	set obj.OnCathetersDate1=$p(InStr,separete,90)
	set obj.OffCathetersDate1=$p(InStr,separete,91)
	set obj.ObserDate2=$p(InStr,separete,92)
	set obj.WKGY2=$p(InStr,separete,93)
	set obj.DipeType2=$p(InStr,separete,94)
	set obj.OnHXJDate2=$p(InStr,separete,95)
	set obj.OffHXJDate2=$p(InStr,separete,96)
	set obj.CVPPos2=$p(InStr,separete,97)
	set obj.CVPType2=$p(InStr,separete,98)
	set obj.OnCVPDate2=$p(InStr,separete,99)
	set obj.OffCVPDate2=$p(InStr,separete,100)
	set obj.CathetersType2=$p(InStr,separete,101)
	set obj.OnCathetersDate2=$p(InStr,separete,102)
	set obj.OffCathetersDate2=$p(InStr,separete,103)
	set obj.ObserDate3=$p(InStr,separete,104)
	set obj.WKGY3=$p(InStr,separete,105)
	set obj.DipeType3=$p(InStr,separete,106)
	set obj.OnHXJDate3=$p(InStr,separete,107)
	set obj.OffHXJDate3=$p(InStr,separete,108)
	set obj.CVPPos3=$p(InStr,separete,109)
	set obj.CVPType3=$p(InStr,separete,110)
	set obj.OnCVPDate3=$p(InStr,separete,111)
	set obj.OffCVPDate3=$p(InStr,separete,112)
	set obj.CathetersType3=$p(InStr,separete,113)
	set obj.OnCathetersDate3=$p(InStr,separete,114)
	set obj.OffCathetersDate3=$p(InStr,separete,115)
	set obj.DrugIn7SDDate1=$p(InStr,separete,116)
	set obj.DrugName1=$p(InStr,separete,117)
	set obj.DoseAndMethod1=$p(InStr,separete,118)
	set obj.DrugIn7SDDate2=$p(InStr,separete,119)
	set obj.DrugName2=$p(InStr,separete,120)
	set obj.DoseAndMethod2=$p(InStr,separete,121)
	set obj.DrugIn7SDDate3=$p(InStr,separete,122)
	set obj.DrugName3=$p(InStr,separete,123)
	set obj.DoseAndMethod3=$p(InStr,separete,124)
	set obj.DrugIn7SDDate4=$p(InStr,separete,125)
	set obj.DrugName4=$p(InStr,separete,126)
	set obj.DoseAndMethod4=$p(InStr,separete,127)
	set obj.DrugIn7SDDate5=$p(InStr,separete,128)
	set obj.DrugName5=$p(InStr,separete,129)
	set obj.DoseAndMethod5=$p(InStr,separete,130)
	set obj.DrugIn7SDDate6=$p(InStr,separete,131)
	set obj.DrugName6=$p(InStr,separete,132)
	set obj.DoseAndMethod6=$p(InStr,separete,133)
	set obj.DrugIn7SDDate7=$p(InStr,separete,134)
	set obj.DrugName7=$p(InStr,separete,135)
	set obj.DoseAndMethod7=$p(InStr,separete,136)
	set obj.DrugIn7SDDate8=$p(InStr,separete,137)
	set obj.DrugName8=$p(InStr,separete,138)
	set obj.DoseAndMethod8=$p(InStr,separete,139)
	set obj.DrugIn7SDDate9=$p(InStr,separete,140)
	set obj.DrugName9=$p(InStr,separete,141)
	set obj.DoseAndMethod9=$p(InStr,separete,142)
	set obj.DrugIn7SDDate10=$p(InStr,separete,143)
	set obj.DrugName10=$p(InStr,separete,144)
	set obj.DoseAndMethod10=$p(InStr,separete,145)
	set obj.DrugIn7Day=$p(InStr,separete,146)
	set obj.IfSpecialDrug=$p(InStr,separete,147)
	set obj.TreatResult=$p(InStr,separete,148)
	set obj.FillUser=$p(InStr,separete,149)
	set obj.FillDate=$p(InStr,separete,150)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     lk
/// CreatDate：   2012-05-30
/// Description:  删除手术感染部位报告
/// Table：       DHCMed.NINF.Aim.DCNY
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.NINF.Aim.DCNY).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

Storage Default
{
<Data name="DCNYDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CRAB</Value>
</Value>
<Value name="3">
<Value>CRE</Value>
</Value>
<Value name="4">
<Value>CRReportDR</Value>
</Value>
<Value name="5">
<Value>CVPPos1</Value>
</Value>
<Value name="6">
<Value>CVPPos2</Value>
</Value>
<Value name="7">
<Value>CVPPos3</Value>
</Value>
<Value name="8">
<Value>CVPType1</Value>
</Value>
<Value name="9">
<Value>CVPType2</Value>
</Value>
<Value name="10">
<Value>CVPType3</Value>
</Value>
<Value name="11">
<Value>CathetersType1</Value>
</Value>
<Value name="12">
<Value>CathetersType2</Value>
</Value>
<Value name="13">
<Value>CathetersType3</Value>
</Value>
<Value name="14">
<Value>DipeType1</Value>
</Value>
<Value name="15">
<Value>DipeType2</Value>
</Value>
<Value name="16">
<Value>DipeType3</Value>
</Value>
<Value name="17">
<Value>DisInfRit1</Value>
</Value>
<Value name="18">
<Value>DisInfRit2</Value>
</Value>
<Value name="19">
<Value>DisInfRit3</Value>
</Value>
<Value name="20">
<Value>DocDR</Value>
</Value>
<Value name="21">
<Value>DoseAndMethod1</Value>
</Value>
<Value name="22">
<Value>DoseAndMethod10</Value>
</Value>
<Value name="23">
<Value>DoseAndMethod2</Value>
</Value>
<Value name="24">
<Value>DoseAndMethod3</Value>
</Value>
<Value name="25">
<Value>DoseAndMethod4</Value>
</Value>
<Value name="26">
<Value>DoseAndMethod5</Value>
</Value>
<Value name="27">
<Value>DoseAndMethod6</Value>
</Value>
<Value name="28">
<Value>DoseAndMethod7</Value>
</Value>
<Value name="29">
<Value>DoseAndMethod8</Value>
</Value>
<Value name="30">
<Value>DoseAndMethod9</Value>
</Value>
<Value name="31">
<Value>DrugIn7Day</Value>
</Value>
<Value name="32">
<Value>DrugIn7SDDate1</Value>
</Value>
<Value name="33">
<Value>DrugIn7SDDate10</Value>
</Value>
<Value name="34">
<Value>DrugIn7SDDate2</Value>
</Value>
<Value name="35">
<Value>DrugIn7SDDate3</Value>
</Value>
<Value name="36">
<Value>DrugIn7SDDate4</Value>
</Value>
<Value name="37">
<Value>DrugIn7SDDate5</Value>
</Value>
<Value name="38">
<Value>DrugIn7SDDate6</Value>
</Value>
<Value name="39">
<Value>DrugIn7SDDate7</Value>
</Value>
<Value name="40">
<Value>DrugIn7SDDate8</Value>
</Value>
<Value name="41">
<Value>DrugIn7SDDate9</Value>
</Value>
<Value name="42">
<Value>DrugName1</Value>
</Value>
<Value name="43">
<Value>DrugName10</Value>
</Value>
<Value name="44">
<Value>DrugName2</Value>
</Value>
<Value name="45">
<Value>DrugName3</Value>
</Value>
<Value name="46">
<Value>DrugName4</Value>
</Value>
<Value name="47">
<Value>DrugName5</Value>
</Value>
<Value name="48">
<Value>DrugName6</Value>
</Value>
<Value name="49">
<Value>DrugName7</Value>
</Value>
<Value name="50">
<Value>DrugName8</Value>
</Value>
<Value name="51">
<Value>DrugName9</Value>
</Value>
<Value name="52">
<Value>FillDate</Value>
</Value>
<Value name="53">
<Value>FillUser</Value>
</Value>
<Value name="54">
<Value>HandHealth1</Value>
</Value>
<Value name="55">
<Value>HandHealth2</Value>
</Value>
<Value name="56">
<Value>HandHealth3</Value>
</Value>
<Value name="57">
<Value>IfGXY</Value>
</Value>
<Value name="58">
<Value>IfHIV</Value>
</Value>
<Value name="59">
<Value>IfHXSJ</Value>
</Value>
<Value name="60">
<Value>IfIsolation1</Value>
</Value>
<Value name="61">
<Value>IfIsolation1Flag</Value>
</Value>
<Value name="62">
<Value>IfIsolation2</Value>
</Value>
<Value name="63">
<Value>IfIsolation2Flag</Value>
</Value>
<Value name="64">
<Value>IfIsolation3</Value>
</Value>
<Value name="65">
<Value>IfIsolation3Flag</Value>
</Value>
<Value name="66">
<Value>IfJHB</Value>
</Value>
<Value name="67">
<Value>IfPos1HosInf</Value>
</Value>
<Value name="68">
<Value>IfPos2HosInf</Value>
</Value>
<Value name="69">
<Value>IfPos3HosInf</Value>
</Value>
<Value name="70">
<Value>IfPos4HosInf</Value>
</Value>
<Value name="71">
<Value>IfSGBQ</Value>
</Value>
<Value name="72">
<Value>IfSpecialDrug</Value>
</Value>
<Value name="73">
<Value>IfTNB</Value>
</Value>
<Value name="74">
<Value>IfXGBQ</Value>
</Value>
<Value name="75">
<Value>IfXYB</Value>
</Value>
<Value name="76">
<Value>IfZCE</Value>
</Value>
<Value name="77">
<Value>IfZL</Value>
</Value>
<Value name="78">
<Value>InfPos1Object</Value>
</Value>
<Value name="79">
<Value>InfPos1Sample</Value>
</Value>
<Value name="80">
<Value>InfPos2Object</Value>
</Value>
<Value name="81">
<Value>InfPos2Sample</Value>
</Value>
<Value name="82">
<Value>InfPos3Object</Value>
</Value>
<Value name="83">
<Value>InfPos3Sample</Value>
</Value>
<Value name="84">
<Value>InfPos4Object</Value>
</Value>
<Value name="85">
<Value>InfPos4Sample</Value>
</Value>
<Value name="86">
<Value>Infpos1</Value>
</Value>
<Value name="87">
<Value>Infpos1PathDate</Value>
</Value>
<Value name="88">
<Value>Infpos2</Value>
</Value>
<Value name="89">
<Value>Infpos2PathDate</Value>
</Value>
<Value name="90">
<Value>Infpos3</Value>
</Value>
<Value name="91">
<Value>Infpos3PathDate</Value>
</Value>
<Value name="92">
<Value>Infpos4</Value>
</Value>
<Value name="93">
<Value>Infpos4PathDate</Value>
</Value>
<Value name="94">
<Value>Isolation1Date</Value>
</Value>
<Value name="95">
<Value>Isolation2Date</Value>
</Value>
<Value name="96">
<Value>Isolation3Date</Value>
</Value>
<Value name="97">
<Value>IsolationRepDate</Value>
</Value>
<Value name="98">
<Value>LocSign1</Value>
</Value>
<Value name="99">
<Value>LocSign2</Value>
</Value>
<Value name="100">
<Value>LocSign3</Value>
</Value>
<Value name="101">
<Value>MDRPA</Value>
</Value>
<Value name="102">
<Value>MRSA</Value>
</Value>
<Value name="103">
<Value>ObserDate1</Value>
</Value>
<Value name="104">
<Value>ObserDate2</Value>
</Value>
<Value name="105">
<Value>ObserDate3</Value>
</Value>
<Value name="106">
<Value>ObserUser1</Value>
</Value>
<Value name="107">
<Value>ObserUser2</Value>
</Value>
<Value name="108">
<Value>ObserUser3</Value>
</Value>
<Value name="109">
<Value>OffCVPDate1</Value>
</Value>
<Value name="110">
<Value>OffCVPDate2</Value>
</Value>
<Value name="111">
<Value>OffCVPDate3</Value>
</Value>
<Value name="112">
<Value>OffCathetersDate1</Value>
</Value>
<Value name="113">
<Value>OffCathetersDate2</Value>
</Value>
<Value name="114">
<Value>OffCathetersDate3</Value>
</Value>
<Value name="115">
<Value>OffHXJDate1</Value>
</Value>
<Value name="116">
<Value>OffHXJDate2</Value>
</Value>
<Value name="117">
<Value>OffHXJDate3</Value>
</Value>
<Value name="118">
<Value>OnCVPDate1</Value>
</Value>
<Value name="119">
<Value>OnCVPDate2</Value>
</Value>
<Value name="120">
<Value>OnCVPDate3</Value>
</Value>
<Value name="121">
<Value>OnCathetersDate1</Value>
</Value>
<Value name="122">
<Value>OnCathetersDate2</Value>
</Value>
<Value name="123">
<Value>OnCathetersDate3</Value>
</Value>
<Value name="124">
<Value>OnHXJDate1</Value>
</Value>
<Value name="125">
<Value>OnHXJDate2</Value>
</Value>
<Value name="126">
<Value>OnHXJDate3</Value>
</Value>
<Value name="127">
<Value>PersonalUse1</Value>
</Value>
<Value name="128">
<Value>PersonalUse2</Value>
</Value>
<Value name="129">
<Value>PersonalUse3</Value>
</Value>
<Value name="130">
<Value>Pos1CauseOtherInf</Value>
</Value>
<Value name="131">
<Value>Pos1MixedInf</Value>
</Value>
<Value name="132">
<Value>Pos2CauseOtherInf</Value>
</Value>
<Value name="133">
<Value>Pos2MixedInf</Value>
</Value>
<Value name="134">
<Value>Pos3CauseOtherInf</Value>
</Value>
<Value name="135">
<Value>Pos3MixedInf</Value>
</Value>
<Value name="136">
<Value>Pos4CauseOtherInf</Value>
</Value>
<Value name="137">
<Value>Pos4MixedInf</Value>
</Value>
<Value name="138">
<Value>TPZJSTreatInYear</Value>
</Value>
<Value name="139">
<Value>TelUser</Value>
</Value>
<Value name="140">
<Value>TreatResult</Value>
</Value>
<Value name="141">
<Value>VRE</Value>
</Value>
<Value name="142">
<Value>WKGY1</Value>
</Value>
<Value name="143">
<Value>WKGY2</Value>
</Value>
<Value name="144">
<Value>WKGY3</Value>
</Value>
<Value name="145">
<Value>YZYWTreatInYear</Value>
</Value>
<Value name="146">
<Value>昏迷</Value>
</Value>
<Value name="147">
<Value>Pos1SecondaryInf</Value>
</Value>
<Value name="148">
<Value>Pos2SecondaryInf</Value>
</Value>
<Value name="149">
<Value>Pos3SecondaryInf</Value>
</Value>
<Value name="150">
<Value>Pos4SecondaryInf</Value>
</Value>
<Value name="151">
<Value>IfComa</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.DCNYD</DataLocation>
<DefaultData>DCNYDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.DCNYD</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.DCNYI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.DCNYS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
