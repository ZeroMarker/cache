Import SQLUser

/// 疾病汇总 特指团体的疾病统计
Class web.DHCPE.Report.IllnessCollect Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 285;

/// 疾病汇总 DHCPEIllnessCollect.IllnessList
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.IllnessCollect","IllnessCollect", "*","1^;","","","","","","")
Query IllnessCollect(IllnessList As %Library.String = "", GList As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", Sex As %Library.String = "", Married As %Library.String = "", AgeStep As %Library.String = "", DepartName As %String = "") As %Query(ROWSPEC = "TDiagnoseDR:%String, TDiagnoseConclus:%String, TTotal:%String, TPercent:%String, TCurPercent:%String, TList:%String")
{
}

ClassMethod IllnessCollectExecute(ByRef qHandle As %Binary, IllnessList As %Library.String = "", GList As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", Sex As %Library.String = "", Married As %Library.String = "", AgeStep As %Library.String = "", DepartName As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1 
 	K ^DHCPETEMPIllness("IllnessCollect")
 	k ^DHCPETMIC
	k ^DHCPETMPICExport("RowData")
	k ^DHCPETMPFTZYYExport("RowData")
	s ^DHCPETMIC("IllnessCollect")=""""_IllnessList_""","""_GList_""","""_DateFrom_""","""_DateTo_""","""_AgeFrom_""","""_AgeTo_""","""_Sex_""","""_Married_""""
	i DateFrom'="" s DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
	i DateTo'=""   s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
	// 疾病统计
	d ..GetIllnessList(IllnessList, GList, DateFrom, DateTo, AgeFrom, AgeTo, Sex, Married,AgeStep,DepartName)

	// 输出统计数据到页面
	d ..IllnessCollectDataToHTML()
 	// 输出查询统计数据
 	
 	i ""'=$G(^DHCPETMIC("IllnessCollect", "Total")) d
	.s Data=$lb("", "此次查询统计数据:", "", "", "", "")
	.s ^DHCPETMPICExport("RowData",ind)=""_"^"_"此次查询统计数据:"_"^"_""_"^"_""_"^"_""_"$$"_""
	.d IllnessCollectOut
	.s Total=^DHCPETMIC("IllnessCollect", "Total")
	.s PIBISex=0,SexStr=""
	.f  s PIBISex=$o(^DHCPETMIC("IllnessCollect", "SexTotal",PIBISex))  q:PIBISex=""  d
	..i SexStr=""  s SexStr=PIBISex_":"_$G(^DHCPETMIC("IllnessCollect", "SexTotal",PIBISex))_"人"
	..else  s SexStr=SexStr_","_PIBISex_":"_$G(^DHCPETMIC("IllnessCollect", "SexTotal",PIBISex))_"人"
	.i SexStr'="" s Total=Total_"人，其中"_SexStr
	.s Data=$lb("", "查询人数", Total, "", "", "")
	.s ^DHCPETMPICExport("RowData",ind)=""_"^"_"查询人数"_"^共："_Total_"^"_""_"^"_""_"$$"_""
	.d IllnessCollectOut
	.s Sex=""
	.f  s Sex=$O(^DHCPETMIC("IllnessCollect", "SexTotal", Sex)) Q:(""=Sex)  d
	..s SexTotal=^DHCPETMIC("IllnessCollect", "SexTotal", Sex)
	..s HasIllSexTotal=$g(^DHCPETMIC("HaveIllnessCollect", "SexTotal", Sex))
	..s SexPercent=$FN(HasIllSexTotal/SexTotal*100,"",2)_"%" 
	..s List="HaveIllnessCollect"_","_Sex_","_"SexList"_","_"All"
	..s Data=$lb("", Sex_"性", HasIllSexTotal, SexPercent, "", List)
	..s ^DHCPETMPICExport("RowData",ind)=""_"^"_Sex_"性"_"^"_HasIllSexTotal_"^"_SexPercent_"^"_""_"$$"_"" 
	..d IllnessCollectOut
	.
	.s Married=""
	.f  s Married=$O(^DHCPETMIC("IllnessCollect", "MarriedTotal", Married)) Q:(""=Married)  d
	..s MarriedTotal=^DHCPETMIC("IllnessCollect", "MarriedTotal", Married)
	..s HasIllMarriedTotal=$g(^DHCPETMIC("HaveIllnessCollect", "MarriedTotal", Married))
	..s MarriedPercent=$FN(HasIllMarriedTotal/MarriedTotal*100,"",2)_"%"  
	..s List="HaveIllnessCollect"_","_Married_","_"MarriedList"_","_"All"
	..s Data=$lb("", "婚姻状况:"_Married, HasIllMarriedTotal, MarriedPercent, "", List)
	..s ^DHCPETMPICExport("RowData",ind)=""_"^"_"婚姻状况:"_Married_"^"_HasIllMarriedTotal_"^"_MarriedPercent_"^"_""_"$$"_""
	..d IllnessCollectOut
	.
	.s AgeArea=""
	.f  s AgeArea=$O(^DHCPETMIC("IllnessCollect", "AgeArea", AgeArea)) Q:(""=AgeArea)  d
	..s AgeAreaTotal=^DHCPETMIC("IllnessCollect", "AgeArea", AgeArea)
	..//s HasIllAgeAreaTotal=1
	..s HasIllAgeAreaTotal=$g(^DHCPETMIC("HaveIllnessCollect", "AgeArea", AgeArea))
	..s AgeAreaPercent=$FN(HasIllAgeAreaTotal/AgeAreaTotal*100,"",2)_"%" 
	..s List="HaveIllnessCollect"_","_AgeArea_","_"AgeList"_","_"All"
	..s Data=$lb("", "("_AgeArea_")年龄区间", HasIllAgeAreaTotal, AgeAreaPercent, "", List)
	..s ^DHCPETMPICExport("RowData",ind)=""_"^"_"("_AgeArea_")年龄区间"_"^"_HasIllAgeAreaTotal_"^"_AgeAreaPercent_"^"_""_"$$"_""
	..d IllnessCollectOut
	.
	.
	.s Data=$lb("", "", "", "", "", "")
	.s ^DHCPETMPICExport("RowData",ind)=""_"^"_""_"^"_""_"^"_""_"^"_""_"$$"_""
	.d IllnessCollectOut
 	
 	// 循环项目
 	s Percent="",i=0,j=0
 	f  s Percent=$O(^DHCPETMIC("IllnessList", "Percent", Percent),-1) Q:(""=Percent)  d
 	.s Illness="1"
 	.f  s Illness=$O(^DHCPETMIC("IllnessList", "Percent", Percent, Illness)) Q:(""=Illness)  d
	..// 显示疾病名称
	..s i=i+1
	..s IllnessDesc=$G(^DHCPETMIC("IllnessList", "IllnessStandard",Illness,"Desc"))
	..s Total=+$G(^DHCPETMIC("IllnessList", "IllnessStandard",Illness,"Total")) 
	..s List="IllnessList"_","_"IllnessStandard"_","_Illness_","_"List" 
	..s CurPercent="" 
	..s IllnessCode=$G(^DHCPETMIC("IllnessList", "IllnessStandard",Illness,"Code"))
	..set Data=$lb(Illness, IllnessDesc, Total, Percent_"%", CurPercent, List)
	..;s ^DHCPETMPICExport("RowData",ind)=IllnessCode_"^"_IllnessDesc_"^"_Total_"^"_Percent_"%"_"^"_CurPercent_"$$"_List
	..s ^DHCPETMPICExport("RowData",ind)=""_"^"_IllnessDesc_"^"_Total_"^"_Percent_"%"_"^"_CurPercent_"$$"_List
	..d IllnessCollectOut  
	..s j=j+1 
	..s MaleTotal=+$G(^DHCPETMIC("IllnessList", "IllnessStandard", Illness, "MaleTotal"))  
	..s MaleList="IllnessList"_","_"IllnessStandard"_","_Illness_","_"MaleList"
	..s MalePercent=+$G(^DHCPETMIC("IllnessList", "IllnessStandard", Illness,"MalePercent"))
	..s FemaleTotal=+$G(^DHCPETMIC("IllnessList", "IllnessStandard", Illness, "FemaleTotal"))  
	..s FemaleList="IllnessList"_","_"IllnessStandard"_","_Illness_","_"FemaleList"
	..s FemalePercent=+$G(^DHCPETMIC("IllnessList", "IllnessStandard", Illness,"FemalePercent"))
	..s ElseTotal=+$G(^DHCPETMIC("IllnessList", "IllnessStandard", Illness, "ElseTotal"))  
	..s ElseList="IllnessList"_","_"IllnessStandard"_","_Illness_","_"ElseList"
	..s ElsePercent=+$G(^DHCPETMIC("IllnessList", "IllnessStandard", Illness,"ElsePercent")) 
	..s Data=$lb(Illness, "男", MaleTotal, MalePercent_"%", CurPercent, MaleList)
	..;s ^DHCPETMPICExport("RowData",ind)=IllnessCode_"^"_"男"_"^"_MaleTotal_"^"_MalePercent_"%"_"^"_CurPercent_"$$"_MaleList
	..s ^DHCPETMPICExport("RowData",ind)=""_"^"_"男"_"^"_MaleTotal_"^"_MalePercent_"%"_"^"_CurPercent_"$$"_MaleList
	..d IllnessCollectOut
	..s Data=$lb(Illness, "女", FemaleTotal, FemalePercent_"%", CurPercent, FemaleList)
	..;s ^DHCPETMPICExport("RowData",ind)=IllnessCode_"^"_"女"_"^"_FemaleTotal_"^"_FemalePercent_"%"_"^"_CurPercent_"$$"_FemaleList
	..s ^DHCPETMPICExport("RowData",ind)=""_"^"_"女"_"^"_FemaleTotal_"^"_FemalePercent_"%"_"^"_CurPercent_"$$"_FemaleList
	..d IllnessCollectOut
	..i ElseTotal>0 d
 	...s Data=$lb(Illness, "其他", ElseTotal, ElsePercent_"%", CurPercent, ElseList)
 	...;s ^DHCPETMPICExport("RowData",ind)=IllnessCode_"^"_"其他"_"^"_ElseTotal_"^"_ElsePercent_"%"_"^"_CurPercent_"$$"_ElseList
 	...s ^DHCPETMPICExport("RowData",ind)=""_"^"_"其他"_"^"_ElseTotal_"^"_ElsePercent_"%"_"^"_CurPercent_"$$"_ElseList
	...d IllnessCollectOut
	..s MaleAllTotal=+$G(^DHCPETMIC("IllnessCollect", "SexTotal","男"))
	..s FemaleAllTotal=+$G(^DHCPETMIC("IllnessCollect", "SexTotal","女")) 
	..s AllTotal=^DHCPETMIC("IllnessCollect", "Total")
	..;s ^DHCPETMPFTZYYExport("RowData",$J,i)=IllnessCode_"^"_IllnessDesc_"^"_MaleAllTotal_"^"_MaleTotal_"^"_MalePercent_"%"_"^"_FemaleAllTotal_"^"_FemaleTotal_"^"_FemalePercent_"%"_"^"_AllTotal
 	..s ^DHCPETMPFTZYYExport("RowData",$J,i)=""_"^"_IllnessDesc_"^"_MaleAllTotal_"^"_MaleTotal_"^"_MalePercent_"%"_"^"_FemaleAllTotal_"^"_FemaleTotal_"^"_FemalePercent_"%"_"^"_AllTotal
 	
 	//同时患所有疾病
 	i ""'=$g(^DHCPETMIC("IllnessCollect", "Total")) d
 	.s Illness=IllnessList
 	.s Total=0
 	.s Total=+$G(^DHCPETMIC("IllnessList", "HasAllIll","IADM"))
	.;s List=$G(^DHCPETMIC("IllnessList", "HasAllIll", "List"))
	.s List="IllnessList"_","_"HasAllIll"_","_"List"_","_"All"
    .s AllTotal=+$G(^DHCPETMIC("IllnessCollect", "Total"))
	.s Percent=+$FN(Total/AllTotal*100,"",2)
	.s IllnessDesc="患全部疾病"	
	.s CurPercent=""
	.set Data=$lb(IllnessList, IllnessDesc, Total, Percent_"%", CurPercent, List)
	.s ^DHCPETMPICExport("RowData",ind)=""_"^"_IllnessDesc_"^"_Total_"^"_Percent_"%"_"^"_CurPercent_"$$"_List
	.d IllnessCollectOut
	
	.s MaleTotal=+$G(^DHCPETMIC("IllnessList", "HasAllIll","IADM","男"))
	.;s MaleList=$G(^DHCPETMIC("IllnessList", "HasAllIll", "List","男"))
	.s MaleList="IllnessList"_","_"HasAllIll"_","_"List"_","_"男"
	.s MalePercent=+$FN(MaleTotal/AllTotal*100,"",2)
	.set Data=$lb(IllnessList, "男", MaleTotal, MalePercent_"%", CurPercent, MaleList)
	.d IllnessCollectOut
	
	.s FemaleTotal=+$G(^DHCPETMIC("IllnessList", "HasAllIll","IADM","女"))
	.;s FemaleList=$G(^DHCPETMIC("IllnessList", "HasAllIll", "List","女"))
	.s FemaleList="IllnessList"_","_"HasAllIll"_","_"List"_","_"女"
	.s FemalePercent=+$FN(FemaleTotal/AllTotal*100,"",2)
	.set Data=$lb(IllnessList, "女", FemaleTotal, FemalePercent_"%", CurPercent, FemaleList)
	.d IllnessCollectOut 
	
	.s ElseTotal=+$G(^DHCPETMIC("IllnessList", "HasAllIll","IADM","ElseSex")) 
	.;s ElseList=$G(^DHCPETMIC("IllnessList", "HasAllIll", "List","ElseSex"))
	.s ElseList="IllnessList"_","_"HasAllIll"_","_"List"_","_"ElseSex"
	.s ElsePercent=+$FN(ElseTotal/AllTotal*100,"",2)
	.i 0'=ElseTotal d
	..set Data=$lb(IllnessList, "其他", ElseTotal, ElsePercent_"%", CurPercent, ElsePercent)
	..d IllnessCollectOut	
	
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
	
IllnessCollectOut
	
 	Set ^CacheTemp(repid,ind)=Data 
 	Set ind=ind+1
 	q
}

ClassMethod IllnessCollectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IllnessCollectExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid, ind)
 	}
 	s qHandle=$lb(AtEnd,repid, ind)
	Quit $$$OK
}

ClassMethod IllnessCollectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IllnessCollectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRowData(rownum)
{
	s DataStr=$g(^DHCPETMPICExport("RowData",rownum))
	q DataStr
}

ClassMethod GetRowLength()
{
	s ind=""
	s ind=$o(^DHCPETMPICExport("RowData",ind),-1)
	q ind
}

/// //////////////////////////////////////////////////////////////////////////////
/// //////////////////////////////////////////////////////////////////////////////
/// 疾病汇总
/// d ##class(web.DHCPE.Report.IllnessCollect).GetIllnessList("3^6^15^","9^","","","","","1")
/// d ##class(web.DHCPE.Report.IllnessCollect).GetIllnessList("6^","10^","","","","","")
/// d ##class(web.DHCPE.Report.IllnessCollect).GetIllnessList("",":1||2","","","","","")
/// 						团体列表(以 ^ 分割)			疾病诊断列表(以 ^ 分割)						体检起始日期							体检结束日期						起始年龄							结束年龄							性别			
ClassMethod GetIllnessList(IllnessList As %Library.String = "", GTList As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", Sex As %Library.String = "", Married As %Library.String = "", AgeStep As %Library.String = "", DepartName As %String = "", CTLocID As %String = "")
{
	
	Q:(":"=GTList) 0
	Q:(""=IllnessList) 0
	s GList=$P(GTList,";",1)
	s ^sxt("g")=GList
	i GList=""  
	{
	i DateFrom=""  s DateFrom=0
    i DateTo=""  s DateTo=+$h
    s IADM=0
    f CurDate=DateFrom:1:DateTo d
    .
    .s DateTime=""
    .f  s DateTime=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,DateTime)) q:DateTime=""  d
    ..f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,DateTime,IADM)) q:IADM=""  d
    ...//q:$p(^DHCPEIADM(IADM),"^",2)'=""
    ...Q:(0=..FilterIADM(IADM, DateFrom, DateTo, AgeFrom, AgeTo, Sex, Married,AgeStep,DepartName))
    ...s ^DHCPETMIC("IADM", IADM,1)=""
	}
    else  
    {
	i ("I"=$P(GList,"^",1)) 
	{
	i DateFrom=""  s DateFrom=0
    i DateTo=""  s DateTo=+$h
    s IADM=0
    f CurDate=DateFrom:1:DateTo d
    .
    .s DateTime=""
    .f  s DateTime=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,DateTime)) q:DateTime=""  d
    ..f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,DateTime,IADM)) q:IADM=""  d
    ...q:$p(^DHCPEIADM(IADM),"^",2)'=""
    ...Q:(0=..FilterIADM(IADM, DateFrom, DateTo, AgeFrom, AgeTo, Sex, Married,AgeStep,DepartName))
    ...s ^DHCPETMIC("IADM", IADM,1)=""
    
	}
	
	// 团体客户基本信息登记表 DHC_PE_GBaseInfo 第一层循环
	else {
	f iGLLoop=1:1:$Length(GList,"^") d
	.s GADMRowId=$P(GList,"^",iGLLoop)
	.Q:(""=GADMRowId)
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("GADM",GADMRowId)          //add 2009-07-07 
  	.q:LocFlag=1
	.// DHC_PE_GADM.{ GADM_CRMGADM } 
	.s CRMGADM=$P($G(^DHCPEGADM(GADMRowId)),"^",2)
	.d ..PrePersonStatistic(CRMGADM,"G")
	.
	.
	.// DHC_PE_IADM.{ IADM_GTeam_DR }	
	.s GTeamDR="0"
	.f  s GTeamDR=$O(^DHCPEIADM(0,"GADM",GADMRowId,GTeamDR)) Q:(""=GTeamDR)  d
	..s IAdmRowId="0"
  	..f  s IAdmRowId=$O(^DHCPEIADM(0,"GADM", GADMRowId, GTeamDR, IAdmRowId)) Q:(""=IAdmRowId)  d
	...//s GSRowId=$O(^DHCPEGS(0, "IADM", IAdmRowId,0))  //按总检统计
	...//q:GSRowId="" 
	...Q:(0=..FilterIADM(IAdmRowId, DateFrom, DateTo, AgeFrom, AgeTo, Sex, Married,AgeStep,DepartName))
	...s ^DHCPETMIC("IADM", IAdmRowId)=GADMRowId_"^G"
	...
	
	}
    }
	s IAdmRowId=0
	f  s IAdmRowId=$O(^DHCPETMIC("IADM", IAdmRowId)) Q:(""=IAdmRowId)  d
	.s PIAdmRowId=$P($g(^DHCPEIADM(IAdmRowId)),"^",4)
	.Q:(""=PIAdmRowId)
	.s PIBIDR=$P($G(^DHCPEPreIADM(PIAdmRowId)),"^",1)
	.Q:(""=PIBIDR)
	.s PIBISex=$p(^DHCPEPreIBI(PIBIDR),"^",3)
	.i PIBISex'="" s PIBISex=$p($G(^CT("SEX",PIBISex)),"^",2)
	.i PIBISex=""  s PIBISex="未知"
	.s PIBIDOB=$p(^DHCPEPreIBI(PIBIDR),"^",4)
	.s Age=""
 	.i PIBIDOB'="" d
 	.//年龄
 	.s Age=##class(web.DHCLCNUREXCUTE).CalAge(PIBIDOB,+$h)
 	.s Age=+$P(Age,"Y",1)
 	.i AgeStep=""  s AgeStep=10

 	.s AgeArea=..GetAgeArea(0,100,AgeStep,Age)
	.s PIBIMarried=$p(^DHCPEPreIBI(PIBIDR),"^",17)
	.s:(PIBIMarried'="") PIBIMarried=$p($G(^CT("MAR",PIBIMarried)),"^",2)
	.s:(PIBIMarried="") PIBIMarried="未知"
	.
	.s GSRowId=0
	.// DHC_PE_GeneralSummarize.{ GS_RowId }
	.f  s GSRowId=$O(^DHCPEGS(0,"IADM", IAdmRowId, GSRowId)) Q:(""=GSRowId)  d
	..d ..GetHasALLIllnessList(IllnessList,GSRowId,PIBISex)
	..s GSDChildSub=0
	..// DHC_PE_GSDiagnosis.{ GSDChildSub }
	..f  s GSDChildSub=$O(^DHCPEGS(GSRowId, "Diagnosis", GSDChildSub)) Q:(""=GSDChildSub)  d
	...s GSDEDDR=$P($G(^DHCPEGS(GSRowId, "Diagnosis", GSDChildSub)),"^",1)	
	...;S RDiagnosisType=$P($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	...S RDiagnosisType=$P($G(^DHCPESetting("DHCPE","GRDiagnosisType",CTLocID)),"^",1)
	...i RDiagnosisType="Y"  d
	....s IDRRowId=0
	....f  s IDRRowId=$O(^DHCPEIDR(0,"EDDR", GSDEDDR, IDRRowId)) Q:(""=IDRRowId)  d
	.....s IDRILLSDR=$P($G(^DHCPEIDR(IDRRowId)), "^", 2)
	.....Q:((""'=IllnessList)&(IllnessList'[("^"_IDRILLSDR_"^")))&("*"'=IllnessList)
	.....s ILLSCode=$P($G(^DHCPEILLS(IDRILLSDR)),"^",1)
	.....s ILLSDesc=$P($G(^DHCPEILLS(IDRILLSDR)),"^",2)
	.....s ^DHCPETMIC("IADM","Code",IAdmRowId, IDRILLSDR)=ILLSCode
	.....s ^DHCPETMIC("IADM", IAdmRowId, IDRILLSDR)=ILLSDesc
    ....i '$d(^DHCPETMIC("HaveIllnessCollect", IAdmRowId))   d
	.....// 性别统计人数
	.....s ^DHCPETMIC("HaveIllnessCollect", "SexTotal",PIBISex)=+$G(^DHCPETMIC("HaveIllnessCollect", "SexTotal",PIBISex))+1
	.....// 按年龄客户列表
	.....s ^DHCPETMIC("HaveIllnessCollect", "Age", Age, IAdmRowId)=$ZD(PIBIDOB,3)
	.....// 按婚姻状况列表
	.....s ^DHCPETMIC("HaveIllnessCollect", "MarriedTotal", PIBIMarried)=+$G(^DHCPETMIC("HaveIllnessCollect", "MarriedTotal", PIBIMarried))+1
	.....// 年龄区间
	.....s ^DHCPETMIC("HaveIllnessCollect", "AgeArea", AgeArea)=+$G(^DHCPETMIC("HaveIllnessCollect", "AgeArea", AgeArea))+1
	.....;s ^DHCPETMIC("HaveIllnessCollect", IAdmRowId, IDRILLSDR)=1
	.....s ^DHCPETMIC("HaveIllnessCollect", IAdmRowId)=1
	.....;s ^DHCPETMIC("HaveIllnessCollect", PIBISex, "SexList")=$G(^DHCPETMIC("HaveIllnessCollect", PIBISex, "SexList"))_IAdmRowId_"^"
	.....s ^DHCPETMIC("HaveIllnessCollect", PIBISex, "SexList","All",IAdmRowId)=""
	.....;s ^DHCPETMIC("HaveIllnessCollect", PIBIMarried, "MarriedList")=$G(^DHCPETMIC("HaveIllnessCollect", PIBIMarried, "MarriedList"))_IAdmRowId_"^"
	.....s ^DHCPETMIC("HaveIllnessCollect", PIBIMarried, "MarriedList","All",IAdmRowId)=""
	.....;s ^DHCPETMIC("HaveIllnessCollect", AgeArea, "AgeList")=$G(^DHCPETMIC("HaveIllnessCollect", AgeArea, "AgeList"))_IAdmRowId_"^"
	.....s ^DHCPETMIC("HaveIllnessCollect", AgeArea, "AgeList","All",IAdmRowId)=""
	...else  d
	....s GSDEDesc=$p($G(^DHCPEED(GSDEDDR,1)),"^",1)
	....s GSDECode=$p($G(^DHCPEED(GSDEDDR,1)),"^",6)
	....//             
	....Q:((""'=IllnessList)&(IllnessList'[("^"_GSDEDDR_"^")))&("*"'=IllnessList)
	....s ^DHCPETMIC("IADM", IAdmRowId, GSDEDDR)=GSDEDesc
	....s ^DHCPETMIC("IADM","Code",IAdmRowId, GSDEDDR)=GSDECode
	....//s ^tmpzl("IADM",IAdmRowId,GSDEDDR,1)=GSDEDesc
	....i '$d(^DHCPETMIC("HaveIllnessCollect", IAdmRowId))   d
	.....// 性别统计人数
	.....s ^DHCPETMIC("HaveIllnessCollect", "SexTotal",PIBISex)=+$G(^DHCPETMIC("HaveIllnessCollect", "SexTotal",PIBISex))+1
	.....// 按年龄客户列表
	.....s ^DHCPETMIC("HaveIllnessCollect", "Age", Age, IAdmRowId)=$ZD(PIBIDOB,3)
	.....// 按婚姻状况列表
	.....s ^DHCPETMIC("HaveIllnessCollect", "MarriedTotal", PIBIMarried)=+$G(^DHCPETMIC("HaveIllnessCollect", "MarriedTotal", PIBIMarried))+1
	.....// 年龄区间
	.....s ^DHCPETMIC("HaveIllnessCollect", "AgeArea", AgeArea)=+$G(^DHCPETMIC("HaveIllnessCollect", "AgeArea", AgeArea))+1
	.....s ^DHCPETMIC("HaveIllnessCollect", IAdmRowId)=1
	.....;s ^DHCPETMIC("HaveIllnessCollect", PIBISex, "SexList")=$G(^DHCPETMIC("HaveIllnessCollect", PIBISex, "SexList"))_IAdmRowId_"^"
	.....s ^DHCPETMIC("HaveIllnessCollect", PIBISex, "SexList","ALl",IAdmRowId)=""
	.....;s ^DHCPETMIC("HaveIllnessCollect", PIBIMarried, "MarriedList")=$G(^DHCPETMIC("HaveIllnessCollect", PIBIMarried, "MarriedList"))_IAdmRowId_"^"
	.....s ^DHCPETMIC("HaveIllnessCollect", PIBIMarried, "MarriedList","All",IAdmRowId)=""
	.....;s ^DHCPETMIC("HaveIllnessCollect", AgeArea, "AgeList")=$G(^DHCPETMIC("HaveIllnessCollect", AgeArea, "AgeList"))_IAdmRowId_"^"
	.....s ^DHCPETMIC("HaveIllnessCollect", AgeArea, "AgeList","All",IAdmRowId)=""
	.// 同一个人不同的诊断可能对应相同的疾病,所以统计单独提出来
	.s ISDR=""
	.f  s ISDR=$O(^DHCPETMIC("IADM", IAdmRowId, ISDR)) Q:(""=ISDR)  d
	..s ISDesc=^DHCPETMIC("IADM", IAdmRowId, ISDR) 
	..s ISCode=$G(^DHCPETMIC("IADM","Code",IAdmRowId, ISDR))
	..s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "Total")=+$G(^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "Total"))+1
	
	..;s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "List")=$G(^DHCPETMIC("IllnessList", "IllnessStandard", ISDR,"List"))_IAdmRowId_"^"
	..s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "List",IAdmRowId)=""
	..s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "Desc")=ISDesc
	..s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "Code")=ISCode
	..i PIBISex="男" d
	...s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "MaleTotal")=+$G(^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "MaleTotal"))+1
	...;s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "MaleList")=$G(^DHCPETMIC("IllnessList", "IllnessStandard", ISDR,"MaleList"))_IAdmRowId_"^"
	...s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "MaleList",IAdmRowId)=""
	..i PIBISex="女" d
	...s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "FemaleTotal")=+$G(^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "FemaleTotal"))+1
	...;s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "FemaleList")=$G(^DHCPETMIC("IllnessList", "IllnessStandard", ISDR,"FemaleList"))_IAdmRowId_"^"
	...s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "FemaleList",IAdmRowId)=""
	..i ((PIBISex'="男")&&(PIBISex'="女"))  d
	...s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "ElseTotal")=+$G(^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "ElseTotal"))+1
	...;s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "ElseList")=$G(^DHCPETMIC("IllnessList", "IllnessStandard", ISDR,"ElseList"))_IAdmRowId_"^"
	...s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "ElseList",IAdmRowId)=""

	s ISDR=0
	f  s ISDR=$O(^DHCPETMIC("IllnessList", "IllnessStandard", ISDR)) Q:(""=ISDR)  d
	.s AllTotal=+$G(^DHCPETMIC("IllnessCollect", "Total"))
	.s IllnessTotal=+^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "Total")
	.s IllnessPercent=+$FN(IllnessTotal/AllTotal*100,"",2)
	.s ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR,"Percent")=IllnessPercent
	.s MaleAllTotal=+$G(^DHCPETMIC("IllnessCollect", "SexTotal","男"))
	.s MaleIllnessTotal=+$G(^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "MaleTotal"))
	.s:0'=MaleAllTotal ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR,"MalePercent")=+$FN(MaleIllnessTotal/MaleAllTotal*100,"",2)
	.s FemaleAllTotal=+$G(^DHCPETMIC("IllnessCollect", "SexTotal","女"))
	.s FemaleIllnessTotal=+$G(^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "FemaleTotal"))
	.s:0'=FemaleAllTotal ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR,"FemalePercent")=+$FN(FemaleIllnessTotal/FemaleAllTotal*100,"",2)
	.s ElseAllTotal=AllTotal-MaleAllTotal-FemaleAllTotal
	.s ElseIllnessTotal=+$G(^DHCPETMIC("IllnessList", "IllnessStandard", ISDR, "ElseTotal"))
	.s:(ElseAllTotal>0) ^DHCPETMIC("IllnessList", "IllnessStandard", ISDR,"ElsePercent")=+$FN(ElseIllnessTotal/ElseAllTotal*100,"",2)
	.// 按发病率给疾病排序
	.s ^DHCPETMIC("IllnessList", "Percent", IllnessPercent, ISDR)=IllnessPercent

   
	Q 1
}

/// 预约情况统计
ClassMethod PrePersonStatistic(PreGDR As %Library.String = "", GType As %Library.String = "")
{
	i "G"=GType d
	.
	.
	.s PIADMRowId=0
	.f  s PIADMRowId=$O(^DHCPEPreIADM(0,"PGADM",PreGDR,PIADMRowId)) Q:(""=PIADMRowId)  d
	..
	..// DHC_PE_PreIADM.{ PIADM_Status }
	..s PIADMStatus=$P($G(^DHCPEPreIADM(PIADMRowId)),"^",8)
	..
	..Q:("PREREG"=PIADMStatus) // 预约
	..//Q:("PREREGED"=PIADMStatus) // 预约完成
	..//Q:("ARRIVED"=PIADMStatus) // 到达
	..Q:("CANCELPREREG"=PIADMStatus) // 取消预约
	..s ^DHCPETMIC("IllnessCollect", "PreTotal")=+$G(^DHCPETMIC("IllnessCollect", "PreTotal"))+1
	..
	..s:("PREREGED"=PIADMStatus) ^DHCPETMIC("IllnessCollect", "NoARRIVED")=+$G(^DHCPETMIC("IllnessCollect", "NoARRIVED"))+1
	..s:("ARRIVED"=PIADMStatus) ^DHCPETMIC("IllnessCollect", "ARRIVED")=+$G(^DHCPETMIC("IllnessCollect", "ARRIVED"))+1
	..
	
	i "T"=GType d
	.// DHC_PE_PreIADM.{ PIADM_RowId }
	.s PIADMRowId=0
	.f  s PIADMRowId=$O(^DHCPEPreIADM(0,"PGTeam",PreGDR,PIADMRowId)) Q:(""=PIADMRowId)  d
	..s PIADMStatus=$P($G(^DHCPEPreIADM(PIADMRowId)),"^",8)
	..
	..Q:("PREREG"=PIADMStatus) // 预约
	..//Q:("PREREGED"=PIADMStatus) // 预约完成
	..//Q:("ARRIVED"=PIADMStatus) // 到达
	..Q:("CANCELPREREG"=PIADMStatus) // 取消预约
	..s ^DHCPETMIC("IllnessCollect", "PreTotal")=+$G(^DHCPETMIC("IllnessCollect", "PreTotal"))+1
	..
	..s:("PREREGED"=PIADMStatus) ^DHCPETMIC("IllnessCollect", "NoARRIVED")=+$G(^DHCPETMIC("IllnessCollect", "NoARRIVED"))+1
	..s:("ARRIVED"=PIADMStatus) ^DHCPETMIC("IllnessCollect", "ARRIVED")=+$G(^DHCPETMIC("IllnessCollect", "ARRIVED"))+1
	..

	Q 0
}

/// //////////////////////////////////////////////////////////////////////////////
/// w ##class(web.DHCPE.Report.IllnessCollect).FilterIADM("56","","","","","")
ClassMethod FilterIADM(IAdmRowId As %String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", Sex As %Library.String = "", Married As %Library.String = "", AgeStep As %Library.String = "", DepartName As %String = "")
{
  	

	s ^DHCPETMIC("FilterIADM")=""""_IAdmRowId_""","""_DateFrom_""","""_DateTo_""","""_AgeFrom_""","""_AgeTo_""","""_Sex_""","""_Married_""""
	// DHC_PE_IADM.{ IADM_Status }
	s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	Q:'(("ARRIVED"=Status)||("COMPLETED"=Status)) 0
	
	// DHC_PE_IADM.{ IADM_AdmDate }	体检日期
	s AdmDate=$P($G(^DHCPEIADM(IAdmRowId)),"^",5)
	Q:(""=AdmDate) 0
	Q:(""'=DateFrom)&(""'=AdmDate)&(DateFrom>AdmDate) 0
	Q:(""'=DateTo)&(""'=AdmDate)&(DateTo<AdmDate) 0
	s AdmDate=$ZD(AdmDate,3)
	// DHC_PE_IADM.{ IADM_CRMADM } = DHC_PE_PreIADM.{ PIADM_RowId }
	s PIAdmRowId=$P($g(^DHCPEIADM(IAdmRowId)),"^",4)
	Q:(""=PIAdmRowId) 0
	
	s CurDepartName=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PIAdmRowId)
	q:(DepartName'="")&&(CurDepartName'[DepartName) 0
	
	// DHC_PE_IADM.{ PIADM_PIBI_DR }
	s PIBIDR=$P($G(^DHCPEPreIADM(PIAdmRowId)),"^",1)
	Q:(""=PIBIDR) 0
	
	// DHC_PE_PreIBaseInfo.{ PIBI_Sex_DR } 性别
	s PIBISex=$p(^DHCPEPreIBI(PIBIDR),"^",3)
	Q:(""'=Sex)&(Sex'=PIBISex) 0
	
	//  CT_Sex
	i PIBISex'="" s PIBISex=$p($G(^CT("SEX",PIBISex)),"^",2)
	i PIBISex=""  s PIBISex="未知"
	// DHC_PE_PreIBaseInfo.{ PIBI_DOB }	出生日期
	s PIBIDOB=$p(^DHCPEPreIBI(PIBIDR),"^",4)
	s Age=""
 	i PIBIDOB'="" d
 	.//年龄
 	.s Age=##class(web.DHCLCNUREXCUTE).CalAge(PIBIDOB,+$h)
 	.s Age=+$P(Age,"Y",1)
 	i Age="" s Age=0
	Q:(""'=AgeFrom)&(""'=Age)&(+AgeFrom>+Age) 0
	Q:(""'=AgeTo)&(""'=Age)&(+AgeTo<+Age) 0
	i AgeStep=""  s AgeStep=10
 	s AgeArea=..GetAgeArea(0,100,AgeStep,Age)
	// DHC_PE_PreIBaseInfo.{ PIBI_Married_DR }
	s PIBIMarried=$p(^DHCPEPreIBI(PIBIDR),"^",17)
	Q:(""'=Married)&(Married'=PIBIMarried) 0
	// CT_Marital
	s:(PIBIMarried'="") PIBIMarried=$p($G(^CT("MAR",PIBIMarried)),"^",2)
	s:(PIBIMarried="") PIBIMarried="未知"
	
	// 统计总人数
	s ^DHCPETMIC("IllnessCollect", "Total")=+$G(^DHCPETMIC("IllnessCollect", "Total"))+1
	;s ^DHCPETMIC("IllnessCollect", "List")=$G(^DHCPETMIC("IllnessCollect", "List"))_IAdmRowId_"^"
	s ^DHCPETMIC("IllnessCollect", "List",IAdmRowId)=""
	// 性别统计人数
	s ^DHCPETMIC("IllnessCollect", "SexTotal",PIBISex)=+$G(^DHCPETMIC("IllnessCollect", "SexTotal",PIBISex))+1

	// 按年龄客户列表
	s ^DHCPETMIC("IllnessCollect", "Age", Age, IAdmRowId)=$ZD(PIBIDOB,3)
	// 按婚姻状况列表
	s ^DHCPETMIC("IllnessCollect", "MarriedTotal", PIBIMarried)=+$G(^DHCPETMIC("IllnessCollect", "MarriedTotal", PIBIMarried))+1
	// 年龄区间
	s ^DHCPETMIC("IllnessCollect", "AgeArea", AgeArea)=+$G(^DHCPETMIC("IllnessCollect", "AgeArea", AgeArea))+1
	
	Q 1
}

/// 将疾病统计数据以javascript数组的形式输入到页面,以便以图形方式显示
/// d ##class(web.DHCPE.Report.IllnessCollect).IllnessCollectDataToHTML()
ClassMethod IllnessCollectDataToHTML()
{
	//w "<Label>查询总人数:"_$G(^DHCPEDSTMP("IllnessCollect", "Total"))_"个</Label>",!
	w "<input id=DSJ name=DSJ type=hidden value="_$J_"/>"
	w "<SCRIPT>",!
	w "var DSlabel=new Array();",!
	w "var DSvalue=new Array();",!
	s DSlabel=""
	s DSvalue=""
 	s Illness="0"
 	s iLLoop=0
 	s Percent=""
 	f  s Percent=$O(^DHCPETMIC("IllnessList", "Percent", Percent),-1) Q:(""=Percent)  d
 	.s Illness="0"
 	.f  s Illness=$O(^DHCPETMIC("IllnessList", "Percent", Percent, Illness)) Q:(""=Illness)  d
	..// 统计患有此种疾病的人数
	..s IllnessDesc=$G(^DHCPETMIC("IllnessList", "IllnessStandard", Illness, "Desc"))
	..s IllnessCount=$G(^DHCPETMIC("IllnessList", "IllnessStandard", Illness,"Total"))
	..s IllnessPerent=(+IllnessCount/+$G(^DHCPETMIC("IllnessCollect", "Total"))*100)
	..s IllnessPerent=$FN(IllnessPerent,"",2)
	..w "DSlabel["_iLLoop_"]="""_IllnessDesc_""";",!
	..w "DSvalue["_iLLoop_"]="_Percent_";",!
	..s DSlabel=DSlabel_IllnessDesc_"^"
	..s DSvalue=DSvalue_Percent_"^"
	..
	..s ^DHCPETEMPIllness("IllnessCollect","IllnessDesc",iLLoop)=IllnessDesc
    ..s ^DHCPETEMPIllness("IllnessCollect","IllnessPercent",iLLoop)=Percent
	..s iLLoop=iLLoop+1
	..
	w "</SCRIPT>",!
	w "<input type='hidden' id='DSlabel' name='DSlabel' value='"_DSlabel_"'>",!
	w "<input type='hidden' id='DSvalue' name='DSvalue' value='"_DSvalue_"'>",!
}

// //////////////////////////////////////////////////////////////////////////////////////////////

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.IllnessCollect", "GetIllnessCollectImageInfo")

Query GetIllnessCollectImageInfo() As %Query(ROWSPEC = "IllnessDesc:%String, Percent:%String") [ SqlProc ]
{
}

ClassMethod GetIllnessCollectImageInfoExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s IllnessDesc="",Percent=""
 	s i=0
 	f  s i=$o(^DHCPETEMPIllness("IllnessCollect","IllnessDesc",i)) q:i=""  d
 	.s IllnessDesc=$g(^DHCPETEMPIllness("IllnessCollect","IllnessDesc",i))
    .s Percent=$g(^DHCPETEMPIllness("IllnessCollect","IllnessPercent",i))
    .d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	
	set Data=$lb(IllnessDesc,Percent)
	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetIllnessCollectImageInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIllnessCollectImageInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetIllnessCollectImageInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIllnessCollectImageInfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// DHCPEIllnessCollect.PersonList
/// 显示疾病汇总各数据里涉及到的人员信息,由组件DHCPEIllnessStatistic.IllnessCollectList触发
/// 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.IllnessCollect","IADMsPersonInfo","994^6403^8267^","","","","","","")
Query IADMsPersonInfo(IADMList As %Library.String = "", Standard As %Library.String = "") As %Query(ROWSPEC = "DPS_PIBIDR:%String, DPS_PAPMINo:%String, DPS_Name:%String, DPS_Sex:%String, DPS_DOB:%String, DPS_Married:%String, DPS_IADMRowId:%String, DPS_AdmDate:%String, DPS_GDesc:%String,DPS_PAADM:%String,DPS_Standard:%String,DPS_Part:%String")
{
}

ClassMethod IADMsPersonInfoExecute(ByRef qHandle As %Binary, IADMList As %Library.String = "", Standard As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
	s ind=1 
	i ""=IADMList 
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	} 
	s Node1=$P(IADMList,",",1)
	s Node2=$P(IADMList,",",2)
	s Node3=$P(IADMList,",",3)
	s Node4=$P(IADMList,",",4)
	i (""=Node1)||(""=Node2)||(""=Node3)||(""=Node4)
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	} 
	s IAdmRowId=""
	f  s IAdmRowId=$O(^DHCPETMIC(Node1,Node2,Node3,Node4,IAdmRowId)) Q:(""=IAdmRowId)  d 
	.s StandardId=Standard
	.s PAADM=$P($G(^DHCPEIADM(IAdmRowId)),"^",1) 
	.// DHC_PE_IADM.{ IADM_Status }
	.s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	.Q:'(("ARRIVED"=Status)||("COMPLETED"=Status)) 
	.// DHC_PE_IADM.{ IADM_AdmDate }
	.s AdmDate=$P($G(^DHCPEIADM(IAdmRowId)),"^",5)
	.s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
	.
	.// DHC_PE_IADM.{ IADM_CRMADM } = DHC_PE_PreIADM.{ PIADM_RowId }
	.s PIAdmRowId=$P($g(^DHCPEIADM(IAdmRowId)),"^",4)
	.Q:(""=PIAdmRowId)  
	.s DepartName=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PIAdmRowId)
	.s GDesc=""
	.// DHC_PE_PreIADM.{ PIADM_PGADM_DR }
	.s PGADMDR=$P($G(^DHCPEPreIADM(PIAdmRowId)),"^",2)
	.i ""'=PGADMDR d
	..// DHC_PE_PreGADM.{ PGADM_PGBI_DR }
	..s PGBIDR=$P($G(^DHCPEPreGADM(PGADMDR)),"^",1)
	..// DHC_PE_PreGBaseInfo.{ PGBI_Desc }
	..s GDesc=$P($G(^DHCPEPreGBI(PGBIDR)),"^",2)
	.
	.// DHC_PE_PreIADM.{ PIADM_PIBI_DR }
	.s PIBIDR=$P($G(^DHCPEPreIADM(PIAdmRowId)),"^",1)
	.Q:(""=PIBIDR) 
	.
	.// DHC_PE_PreIBaseInfo.{ PIBI_PAPMINo }
	.s PAPMINo=$p(^DHCPEPreIBI(PIBIDR),"^",1)
	.
	.// DHC_PE_PreIBaseInfo.{ PIBI_Name }
	.s Name=$p(^DHCPEPreIBI(PIBIDR),"^",2)
	.
	.// DHC_PE_PreIBaseInfo.{ PIBI_Married_DR }
	.s Married=$p(^DHCPEPreIBI(PIBIDR),"^",17)
	.// CT_Marital
	.s:(Married'="") Married=$p($G(^CT("MAR",Married)),"^",2)
	.
	.s PIBISex=$p(^DHCPEPreIBI(PIBIDR),"^",3)
	.s:(PIBISex'="") PIBISex=$p(^CT("SEX",PIBISex),"^",2)
	.
	.s PapmiNo=$p($g(^PAADM(PAADM)),"^",1)
	.q:""=PapmiNo 
	.s PIBIDOB=$p($g(^PAPER(PapmiNo,"ALL")),"^",6)
    .i ""'=PIBIDOB s PIBIDOB=##class(websys.Conversions).DateLogicalToHtml(PIBIDOB) 
	.set Data=$lb(PIBIDR, PAPMINo, Name, PIBISex, PIBIDOB, Married, IAdmRowId, AdmDate, GDesc, PAADM ,StandardId,DepartName)
	.d IADMsPersonInfoOut 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
IADMsPersonInfoOut	
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	q
}

ClassMethod QueryIADMsPersonInfo(IADMList)
{
	k ^DHCPETMPPerInfoExport("RowData") 
	Q:(""=IADMList) ""
	s Node1=$P(IADMList,",",1)
	s Node2=$P(IADMList,",",2)
	s Node3=$P(IADMList,",",3)
	s Node4=$P(IADMList,",",4)
	s IAdmRowId=""
	s i=0
	f  s IAdmRowId=$O(^DHCPETMIC(Node1,Node2,Node3,Node4,IAdmRowId)) Q:(""=IAdmRowId)  d 
	.s PAADM=$P($G(^DHCPEIADM(IAdmRowId)),"^",1) 
	.// DHC_PE_IADM.{ IADM_Status }
	.s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	.Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	.
	.// DHC_PE_IADM.{ IADM_AdmDate }
	.s AdmDate=$P($G(^DHCPEIADM(IAdmRowId)),"^",5)
	.s AdmDate=$ZD(AdmDate,3)
	.
	.// DHC_PE_IADM.{ IADM_CRMADM } = DHC_PE_PreIADM.{ PIADM_RowId }
	.s PIAdmRowId=$P($g(^DHCPEIADM(IAdmRowId)),"^",4)
	.Q:(""=PIAdmRowId) 
	.s GDesc=""
	.// DHC_PE_PreIADM.{ PIADM_PGADM_DR }
	.s PGADMDR=$P($G(^DHCPEPreIADM(PIAdmRowId)),"^",2)
	.i ""'=PGADMDR d
	..// DHC_PE_PreGADM.{ PGADM_PGBI_DR }
	..s PGBIDR=$P($G(^DHCPEPreGADM(PGADMDR)),"^",1)
	..// DHC_PE_PreGBaseInfo.{ PGBI_Desc }
	..s GDesc=$P($G(^DHCPEPreGBI(PGBIDR)),"^",2)
	.
	.// DHC_PE_PreIADM.{ PIADM_PIBI_DR }
	.s PIBIDR=$P($G(^DHCPEPreIADM(PIAdmRowId)),"^",1)
	.Q:(""=PIBIDR) 
	.
	.// DHC_PE_PreIBaseInfo.{ PIBI_PAPMINo }
	.s PAPMINo=$p(^DHCPEPreIBI(PIBIDR),"^",1)
	.
	.// DHC_PE_PreIBaseInfo.{ PIBI_Name }
	.s Name=$p(^DHCPEPreIBI(PIBIDR),"^",2)
	.
	.// DHC_PE_PreIBaseInfo.{ PIBI_Married_DR }
	.s Married=$p(^DHCPEPreIBI(PIBIDR),"^",17)
	.// CT_Marital
	.s:(Married'="") Married=$p($G(^CT("MAR",Married)),"^",2)
	.
	.// DHC_PE_PreIBaseInfo.{ PIBI_Sex_DR } 
	.s PIBISex=$p(^DHCPEPreIBI(PIBIDR),"^",3)
	.// CT_Sex
	.s:(PIBISex'="") PIBISex=$p(^CT("SEX",PIBISex),"^",2)
	.
	.s PapmiNo=$p($g(^PAADM(PAADM)),"^",1)
	.q:""=PapmiNo
	.s PIBIDOB=$p($g(^PAPER(PapmiNo,"ALL")),"^",6)
    .i ""'=PIBIDOB s PIBIDOB=$ZD(PIBIDOB,3)
    .s i=i+1
    .s ^DHCPETMPPerInfoExport("RowData",i)=PAPMINo_"^"_Name_"^"_PIBISex 
    q 0
}

ClassMethod GetRowDataForPerInfo(rownum)
{
	s DataStr=$g(^DHCPETMPPerInfoExport("RowData",rownum))
	q DataStr
}

ClassMethod GetRowLengthForPerInfo()
{
	s ind=""
	s ind=$o(^DHCPETMPPerInfoExport("RowData",ind),-1)
	s:ind="" ind=0
	q ind
}

ClassMethod GetRowDataForFTZYY(rownum)
{
	s DataStr=$g(^DHCPETMPFTZYYExport("RowData",$J,rownum))
	q DataStr
}

ClassMethod GetRowLengthForFTZYY()
{
	s ind=""
	s ind=$o(^DHCPETMPFTZYYExport("RowData",$J,ind),-1)
	s:ind="" ind=0
	q ind
}

ClassMethod IADMsPersonInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IADMsPersonInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid, ind)
 	}
 	s qHandle=$lb(AtEnd,repid, ind)
	Quit $$$OK
}

ClassMethod IADMsPersonInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IADMsPersonInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 团体预约记录
/// 使用组件:DHCPEIllnessStatistic.GList
Query GADMList(GBIDesc As %String = "") As %Query(ROWSPEC = "TGRowId:%String, TGDesc:%String,TAdmDate:%String")
{
}

ClassMethod GADMListExecute(ByRef qHandle As %Binary, GBIDesc As %String = "") As %Status
{
	
	s STatusList="ARRIVED"
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s GADMRowId="I"
 	s Desc="全体个人"
 	s GAdmDate="/"
 	d GADMListBuild	
 	// DHC_PE_GADM
 	s Gid=""	
	f  s Gid=$o(^DHCPEGADM(Gid),-1) q:Gid=""  d
	.s GADMRowId=Gid
	.s CurData=$g(^DHCPEGADM(Gid))			
	.s GBIDR=$p(CurData,"^",1)
	.q:GBIDR=""
	.s Desc=$p($g(^DHCPEGBI(GBIDR)),"^",2)		
	.q:((""'=GBIDesc)&(Desc'[GBIDesc))	
	.s GAdmDate=$p(CurData,"^",4)
	.i (""'=GAdmDate) s GAdmDate=##class(websys.Conversions).DateLogicalToHtml(GAdmDate)
	.s GStatus=$p(CurData,"^",6)
	.q:(STatusList'[GStatus)
    .d GADMListBuild
   
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GADMListBuild
	set Data=$lb( GADMRowId, Desc, GAdmDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GADMListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GADMListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GADMListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GADMListExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取年龄所在的区间
/// w ##class(web.DHCPE.Report.IllnessCollect).GetAgeArea(0,100,20,40)
ClassMethod GetAgeArea(aAgeFrom As %String = "", aAgeTo As %String = "", aAgeStep As %String = "", aAge As %String = "")
{
	s aAge=+$G(aAge)
	n LowerAgeArea,HeightAgeArea
	Q:(aAge>+aAgeTo) ">"_aAgeTo
	Q:(aAge<+aAgeFrom) "<"_aAgeFrom
	s n=(aAge-aAgeFrom)\aAgeStep
	s LowerAgeArea=aAgeFrom+(aAgeStep*n)
	s HeightAgeArea=aAgeFrom+(aAgeStep*(n+1))
	s:(HeightAgeArea>aAgeTo) HeightAgeArea=aAgeTo
	Q LowerAgeArea_"-"_HeightAgeArea
}

/// w ##class(web.DHCPE.Report.IllnessCollect).ImportIllnessCollect("IllnessStatisticToExcel","","")
ClassMethod ImportIllnessCollect(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
 	// 输出查询统计数据
 	i ""'=$G(^DHCPETMIC("IllnessCollect", "Total")) d
	.s Data=$lb("", "此次查询统计数据:", "", "", "", "")
	.d IllnessCollectOut
	.s Total=^DHCPETMIC("IllnessCollect", "Total")
	.s Data=$lb("", "查询人数", Total, "", "", "")
	.d IllnessCollectOut
	.s Sex=""
	.f  s Sex=$O(^DHCPETMIC("IllnessCollect", "SexTotal", Sex)) Q:(""=Sex)  d
	..s SexTotal=^DHCPETMIC("IllnessCollect", "SexTotal", Sex)
	..s SexPercent=$FN(SexTotal/Total*100,"",2)_"%"
	..s Data=$lb("", Sex_"性", SexTotal, SexPercent, "", "")
	..d IllnessCollectOut
	.
	.s Married=""
	.f  s Married=$O(^DHCPETMIC("IllnessCollect", "MarriedTotal", Married)) Q:(""=Married)  d
	..s MarriedTotal=^DHCPETMIC("IllnessCollect", "MarriedTotal", Married)
	..s MarriedPercent=$FN(MarriedTotal/Total*100,"",2)_"%"
	..s Data=$lb("", "婚姻状况:"_Married, MarriedTotal, MarriedPercent, "", "")
	..d IllnessCollectOut
	.
	.s AgeArea=""
	.f  s AgeArea=$O(^DHCPETMIC("IllnessCollect", "AgeArea", AgeArea)) Q:(""=AgeArea)  d
	..s AgeAreaTotal=^DHCPETMIC("IllnessCollect", "AgeArea", AgeArea)
	..s AgeAreaPercent=$FN(AgeAreaTotal/Total*100,"",2)_"%"
	..s Data=$lb("", "("_AgeArea_")年龄区间", AgeAreaTotal, AgeAreaPercent, "", "")
	..d IllnessCollectOut
	.
	.
	.s Data=$lb("", "", "", "", "", "")
	.d IllnessCollectOut
 	
 	// 循环项目
 	s Percent=""
 	f  s Percent=$O(^DHCPETMIC("IllnessCollect", "Percent", Percent),-1) Q:(""=Percent)  d
 	.s Illness="0"
 	.f  s Illness=$O(^DHCPETMIC("IllnessCollect", "Percent", Percent, Illness)) Q:(""=Illness)  d
	..// 显示疾病名称
	..s DiagnoseConclus=$G(^DHCPETMIC("IllnessCollect", "Diagnosis", Illness, "Desc"))
	..s Total=$G(^DHCPETMIC("IllnessList", "IllnessStandard", Illness, "Total"))
	..//s Percent=$G(^DHCPETMIC("IllnessList", "IllnessStandard", Illness, "Percent"))
	..//s List=$G(^DHCPETMIC("IllnessList", "IllnessStandard", Illness, "List"))
	..s CurPercent=""
	..s Data=Illness_"^"_IllnessDesc_"^"_Total_"^"_Percent_"%"_"^"_CurPercent
	..i ""'=itmjs d
	...s retval=itmjs_"('详细信息','"_$ZCVT(Data,"O","JS")_"');"
	...//w retval,!
	...&javascript<#(retval)#>
	...
 	.. 	
	
 	Q 0
}

/// w ##class(web.DHCPE.Report.MonthStatistic).MonthPEIADMDataImport("","","60823")
ClassMethod IllnessCollectDataImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
	s AdmDate=Instring
	s SalesName=""
	s Datas=""
	f  s SalesName=$O(^DHCPEPATMP("DayPerson", AdmDate,"PEADM",SalesName)) q:(""=SalesName)  d
	.s Date=$ZD(AdmDate,3)_"("_+$G(^DHCPEPATMP("DayPerson", AdmDate))_"人)"
	.s PAID=0
	.f  s PAID=$O(^DHCPEPATMP("DayPerson", AdmDate,"PEADM",SalesName, PAID)) q:(""=PAID)  d
	..s CurData=$G(^DHCPEPATMP("DayPerson", AdmDate,"PEADM",SalesName, PAID))
	..// 	日期	业务员 		套餐			价格			姓名					单位					电话				收费情况(金额)		收费情况(款到日期)		加项项目			加项收费	折扣	备注								
	..s Data=Date_"^"_SalesName_"^"		_"^"_$P(CurData,"^",4)_"^"_$P(CurData,"^",1)_"^"_$P(CurData,"^",2)_"^"_$P(CurData,"^",3)_"^"_$P(CurData,"^",5)_"^"					_"^"_$P(CurData,"^",6)_"^"			_"^"	_"^"
	..s Datas=Datas_Data_";"
	..s Date=""
	

	Q Datas
}

ClassMethod GetHasALLIllnessList(IllStr, GSID, Sex)
{
	
	S PAAdmRowid=$p($g(^DHCPEGS(GSID,1)),"^",8)
     s CurLoc=$P($G(^PAADM(PAAdmRowid)),"^",4)

	s GSDChildSub=0
	f  s GSDChildSub=$O(^DHCPEGS(GSID, "Diagnosis", GSDChildSub)) Q:(""=GSDChildSub)  d
	.s GSDEDDR=$P($G(^DHCPEGS(GSID, "Diagnosis", GSDChildSub)),"^",1)	
	.;S RDiagnosisType=$P($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	.S RDiagnosisType=$P($G(^DHCPESetting("DHCPE","GRDiagnosisType",CurLoc)),"^",1)
	.i RDiagnosisType="Y"  d
	..s IDRRowId=0
	..f  s IDRRowId=$O(^DHCPEIDR(0,"EDDR", GSDEDDR, IDRRowId)) Q:(""=IDRRowId)  d
	...s IDRILLSDR=$P($G(^DHCPEIDR(IDRRowId)), "^", 2)
	...q:IDRILLSDR=""
    ...s ILLSDesc=$P($G(^DHCPEILLS(IDRILLSDR)),"^",2)
    ...s ^DHCPETMIC("IllnessList", "HasAllIll",GSID, IDRILLSDR)=0
	.else  d
	..s GSDEDesc=$p($G(^DHCPEED(GSDEDDR,1)),"^",1)
	..s ^DHCPETMIC("IllnessList","HasAllIll", GSID, GSDEDDR)=0


	s IsHaveIllness=1 // 默认记录为真
	// 循环项目
	s iLoop=1
	do{
		s ISID=$P(IllStr, "^", iLoop)
		i (""'=ISID) d
		.s:(0=$D(^DHCPETMIC("IllnessList", "HasAllIll", GSID, ISID))) IsHaveIllness=0
		s iLoop=1+iLoop
	}while (+iLoop<=+$l(IllStr,"^"))&(IsHaveIllness=1)
	
	i IsHaveIllness=1  d
	.s ^DHCPETMIC("IllnessList", "HasAllIll","IADM")=+$g(^DHCPETMIC("IllnessList", "HasAllIll","IADM"))+1
	.;s ^DHCPETMIC("IllnessList", "HasAllIll", "List")=$G(^DHCPETMIC("IllnessList", "HasAllIll", "List"))_IAdmRowId_"^"
	.s ^DHCPETMIC("IllnessList", "HasAllIll", "List","All",IAdmRowId)=""
	.i ((Sex'="女")&&(Sex'="男")) d
	..s ^DHCPETMIC("IllnessList", "HasAllIll","IADM","ElseSex")=+$g(^DHCPETMIC("IllnessList", "HasAllIll","IADM","ElseSex"))+1
	..;s ^DHCPETMIC("IllnessList", "HasAllIll", "List","ElseSex")=$G(^DHCPETMIC("IllnessList", "HasAllIll", "List","ElseSex"))_IAdmRowId_"^"
	..s ^DHCPETMIC("IllnessList", "HasAllIll", "List","ElseSex",IAdmRowId)=""
	.e  d
	..s ^DHCPETMIC("IllnessList", "HasAllIll","IADM",Sex)=+$g(^DHCPETMIC("IllnessList", "HasAllIll","IADM",Sex))+1
	..;s ^DHCPETMIC("IllnessList", "HasAllIll", "List",Sex)=$G(^DHCPETMIC("IllnessList", "HasAllIll", "List",Sex))_IAdmRowId_"^"
	..s ^DHCPETMIC("IllnessList", "HasAllIll", "List",Sex,IAdmRowId)=""
	Q 1
}

}
