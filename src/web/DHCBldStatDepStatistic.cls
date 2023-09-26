Class web.DHCBldStatDepStatistic Extends %Persistent
{

/// 药敏分离统计
Parameter BUILD = 60;

ClassMethod QuerySampleStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
	Q $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCBldStatDepStatistic","QuerySampleStatistics","2015","2",0,"","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, Year As %String, Month As %String, TimeFlag As %String, Product As %String, ProductGroup As %String, BloodGroup As %String, Diagnose As %String, HospitalCode As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  S sLabNameSpace=$g(sLabNameSpace),HospitalCode=$G(HospitalCode),TimeFlag=$G(TimeFlag)
  S Product=$G(Product),ProductGroup=$G(ProductGroup),BloodGroup=$G(BloodGroup),Diagnose=$G(Diagnose)
  I ProductGroup="null" S ProductGroup=""
  I BloodGroup="null" S BloodGroup=""
  I Diagnose="null" S Diagnose=""
  I '$L(TimeFlag) S TimeFlag=0
  S ^TMP("xq")=$lb(Year,Month,TimeFlag,Product,ProductGroup,BloodGroup,Diagnose,HospitalCode,USERCODE)
  I '$L(Year) S qHandle=$lb(0,repid,0) Q $$$OK
  I '$L(Month),TimeFlag=0 S qHandle=$lb(0,repid,0) Q $$$OK
  //TimeFlag 0 按月查询,1 按年查询
  //S DateS=Year_"-"_Month
  //S DateE=Year_"-"_Month
  I '$L(USERCODE) S USERCODE="demo"
  S HospitalCode=$g(HospitalCode)
  S Month=+Month
  S PreMonth=Month-1
  I Month=12 S PreMonth=1
  S HospitalDesc=""
  I $L(HospitalCode) S HospitalDesc=$P(^TTAB("CC",HospitalCode),"\",1)
  I '$L(HospitalDesc) S HospitalDesc=$P(^TTAB("CC",$O(^TTABi("CC",1,""))),"\",1)
  K ^TMP($zn,$j)
  S LocID=""
  I TimeFlag=0 D
  .F  S LocID=$O(^lab.DHCBldStatBloodUseI("IndexLocation",LocID)) Q:'$L(LocID)  D
  ..//本月出院人次，上个月出院人次
  ..S DischargeNum=0,PreDischargeNum=0
  ..//本月输注人次，上个月输注人次
  ..S ISSNum=0,PreISSNum=0
  ..S PackSumVol=0
  ..S iDate=""
  ..F  S iDate=$O(^lab.DHCBldStatBloodUseI("IndexLocation",LocID,iDate)) Q:'$L(iDate)  D
  ...I $L(iDate)'=5 Q
  ...S iYear=$P($ZD(iDate,3),"-",1)
  ...S iYear=+iYear
  ...S iMonth=$P($ZD(iDate,3),"-",2)
  ...S iMonth=+iMonth
  ...I Year'=iYear Q
  ...I iMonth'=Month,iMonth'=PreMonth Q
  ...S PatType=""
  ...F  S PatType=$O(^lab.DHCBldStatBloodUseI("IndexLocation",LocID,iDate,PatType)) Q:'$L(PatType)  D
  ....S DiagnoseID=""
  ....F  S DiagnoseID=$O(^lab.DHCBldStatBloodUseI("IndexLocation",LocID,iDate,PatType,DiagnoseID)) Q:'$L(DiagnoseID)  D
  .....S PatAdm=""
  .....I $L(Diagnose),Diagnose'=DiagnoseID Q
  .....F  S PatAdm=$O(^lab.DHCBldStatBloodUseI("IndexLocation",LocID,iDate,PatType,DiagnoseID,PatAdm)) Q:'$L(PatAdm)  D
  ......//S PAPMIDR=$P(^PAADM(PatAdm),"^",1)
  ......//S Debtor=$P(^PAPER(PAPMIDR,"PAT",1),"^",1)
  ......S BloodGrp=##Class(LIS.Core.Patient).GetBloodGroupID(PatAdm)
  ......I $L(BloodGroup),BloodGroup'=BloodGrp Q
  ......S PackVolInfo=$$AdmPackVolume(PatAdm,LocID,iMonth)
  ......I iMonth=PreMonth D
  .......//Num 人次
  .......S PreDischargeNum=PreDischargeNum+1
  .......I $li(^lab.DHCBldStatBloodUseD(PatAdm),9)'="Y" Q
  .......//S PreISSNum=PreISSNum+1
  .......D GetIssueNo(PatAdm,Year,PreMonth,"Pre")
  .......//S ^TMP($ZN,$J,"PreNum",LocID)=PreISSNum_"\"_PreDischargeNum
  ......E  D
  .......S DischargeNum=DischargeNum+1
  .......I $li(^lab.DHCBldStatBloodUseD(PatAdm),9)'="Y" Q
  .......D GetIssueNo(PatAdm,Year,Month,"Now")
  E  D
  .F  S LocID=$O(^lab.DHCBldStatBloodUseI("IndexLocation",LocID)) Q:'$L(LocID)  D
  ..//出院人次
  ..S DischargeNum=0
  ..//输注人次
  ..S ISSNum=0
  ..S LocDesc=$P(^CTLOC(LocID),"^",2)
  ..S PackSumVol=0
  ..S iDate=""
  ..F  S iDate=$O(^lab.DHCBldStatBloodUseI("IndexLocation",LocID,iDate)) Q:'$L(iDate)  D
  ...S iYear=$P($ZD(iDate,3),"-",1)
  ...S iMonth=$P($ZD(iDate,3),"-",2)
  ...I Year'=iYear Q
  ...S PatType=""
  ...F  S PatType=$O(^lab.DHCBldStatBloodUseI("IndexLocation",LocID,iDate,PatType)) Q:'$L(PatType)  D
  ....S DiagnoseID=""
  ....F  S DiagnoseID=$O(^lab.DHCBldStatBloodUseI("IndexLocation",LocID,iDate,PatType,DiagnoseID)) Q:'$L(DiagnoseID)  D
  .....S PatAdm=""
  .....I $L(Diagnose),Diagnose'=DiagnoseID Q
  .....F  S PatAdm=$O(^lab.DHCBldStatBloodUseI("IndexLocation",LocID,iDate,PatType,DiagnoseID,PatAdm)) Q:'$L(PatAdm)  D
  ......//Num 人次
  ......S DischargeNum=DischargeNum+1
  ......S BloodGrp=##Class(LIS.Core.Patient).GetBloodGroupID(PatAdm)
  ......I $L(BloodGroup),BloodGroup'=BloodGrp Q
  ......I $li(^lab.DHCBldStatBloodUseD(PatAdm),9)'="Y" Q
  ......S ISSNum=ISSNum+1
  ......S PackVolInfo=$$AdmPackVolume(PatAdm,LocID,iYear)
  I TimeFlag=0 D
  .S LocID=""
  .F  S LocID=$O(^TMP($ZN,$J,"ProductGroup",LocID)) Q:'$L(LocID)  D
  ..S (HospID,CurHospitalCode,locCode)=""
  ..S HospID=$P(^CTLOC(LocID),"^",22),locCode=$P(^CTLOC(LocID),"^",1)
  ..I $L(HospID) s CurHospitalCode=$P(^CT("HOSP",HospID),"^",1)
  ..I $L(HospitalCode),HospitalCode'=CurHospitalCode Q
  ..S PreISSNum=0
  ..S ISSNum=0
  ..S TotalVolume=0
  ..S PreTotalVolume=0
  ..S FFP=0
  ..S RBC=0
  ..S CRYO=0
  ..S PLT=0
  ..S WB=0
  ..S PreFFP=0
  ..S PreRBC=0
  ..S PreCRYO=0
  ..S PrePLT=0
  ..S PreWB=0
  ..S LocDesc=$P(^CTLOC(LocID),"^",2)
  ..I $L(LocDesc,"-")=2 S LocDesc=$P((LocDesc),"-",2)
  ..S ProductGrp=""
  ..F  S ProductGrp=$O(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp)) Q:'$L(ProductGrp)  D
  ...I $L(ProductGroup),ProductGroup'=ProductGrp Q
  ...S Time=""
  ...F  S Time=$O(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time)) Q:'$L(Time)  D
  ....I Month=Time D
  .....S ISSNum=$P($G(^TMP($ZN,$J,"Num",LocID)),"\",1)
  .....S TotalVolume=TotalVolume+$G(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time))
  .....I ProductGrp["FFP" S FFP=$G(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time))
  .....I ProductGrp["RC" S RBC=$G(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time))
  .....I ProductGrp["CRYO" S CRYO=$G(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time))
  .....I ProductGrp["PLT" S PLT=$G(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time))
  .....I ProductGrp["WB" S WB=$G(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time))
  ....E  D
  .....S PreISSNum=$P($G(^TMP($ZN,$J,"PreNum",LocID)),"\",1)
  .....S PreTotalVolume=PreTotalVolume+$G(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time))
  .....I ProductGrp["FFP" S PreFFP=$G(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time))
  .....I ProductGrp["RC" S PreRBC=$G(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time))
  .....I ProductGrp["CRYO" S PreCRYO=$G(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time))
  .....I ProductGrp["PLT" S PrePLT=$G(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time))
  .....I ProductGrp["WB" S PreWB=$G(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time))
  ..S MaxRate="上个月为0"
  ..S TotalVolRate=0
  ..I PreTotalVolume'=0 S TotalVolRate=$E((TotalVolume-PreTotalVolume)/PreTotalVolume,1,4)*100_"%"
  ..S AvergeVol=0
  ..I '$L(ISSNum) S ISSNum=0
  ..I ISSNum'=0 S AvergeVol=$E(TotalVolume/ISSNum,1,4)
  ..S RBCRate=0_"%"
  ..I PreRBC=0 S RBCRate=MaxRate
  ..I PreRBC'=0 S RBCRate=$E((RBC-PreRBC)/PreRBC,1,4)*100_"%"
  ..S FFPRate=0_"%"
  ..I PreFFP=0 S FFPRate=MaxRate
  ..I PreFFP'=0 S FFPRate=$E((FFP-PreFFP)/PreFFP,1,4)*100_"%"
  ..S PLTRate=0_"%"
  ..I PrePLT=0 S PLTRate=MaxRate
  ..I PrePLT'=0 S PLTRate=$E((PLT-PrePLT)/PrePLT,1,4)*100_"%"
  ..S WBRate=0_"%"
  ..I PreWB=0 S WBRate=MaxRate
  ..I PreWB'=0 S WBRate=$E((WB-PreWB)/PreWB,1,4)*100_"%"
  ..S CRYORate=0_"%"
  ..I PreCRYO=0 S CRYORate=MaxRate
  ..I PreCRYO'=0 S CRYORate=$E((CRYO-PreCRYO)/PreCRYO,1,4)*100_"%"
  ..S (Field1,Field2,Field3,Field4,Field5)=""
  ..S Field5=HospitalDesc
  ..S PreRBC=$E(PreRBC/100,1,4)
  ..S PrePLT=$E(PrePLT/200,1,4)
  ..S PreWB=$E(PreWB/200,1,4)
  ..S PreCRYO=$E(PreCRYO*2,1,4)
  ..S RBC=$E(RBC/100,1,4)
  ..S PLT=$E(PLT/200,1,4)
  ..S WB=$E(WB/200,1,4)
  ..S CRYO=$E(CRYO*2,1,4)
  ..I $L(ProductGroup),"RC"'=ProductGroup S (RBC,PreRBC,RBCRate)=""
  ..I $L(ProductGroup),"FFP"'=ProductGroup S (FFP,PreFFP,FFPRate)=""
  ..I $L(ProductGroup),"PLT"'=ProductGroup S (PLT,PrePLT,PLTRate)=""
  ..I $L(ProductGroup),"CRYO"'=ProductGroup S (CRYO,PreCRYO,CRYORate)=""
  ..I $L(ProductGroup),"WB"'=ProductGroup S (WB,PreWB,WBRate)=""
  ..S Data=$lb(LocDesc,ISSNum,TotalVolume,PreTotalVolume,TotalVolRate,AvergeVol,RBC,PreRBC,RBCRate,FFP,PreFFP,FFPRate,PLT,PrePLT,PLTRate,CRYO,PreCRYO,CRYORate,Field1,Field2,Field3,Field4,Field5)
  ..D Output
  K ^TMP($zn,$j)
  S qHandle=$lb(0,repid,0)
  Q $$$OK
  
AdmPackVolume(AdmID,LocID,Time)
	S AdmID=$G(AdmID),LocID=$G(LocID),Time=$G(Time)
	S PackVolumeStr=""
	S PackVolume=0
	I '$D(^lab.DHCBldStatBloodUseD(AdmID,"ChildDHCBldStatBloodUseProduct")) Q PackVolumeStr
	S ProductCode=""
	F  S ProductCode=$O(^lab.DHCBldStatBloodUseD(AdmID,"ChildDHCBldStatBloodUseProduct",ProductCode)) Q:'$L(ProductCode)  D
	.S PackVolume=$li(^lab.DHCBldStatBloodUseD(AdmID,"ChildDHCBldStatBloodUseProduct",ProductCode),2)
	.S BBPackId=$P(ProductCode,"||",1)
	.S BBPackSubId=$P(ProductCode,"||",2)
	.S PackProduct=$P(^TBBP(BBPackId,BBPackSubId),"\",4)
	.S ProductGrp=$P(^TTAB("BB-BP",PackProduct),"\",21)
	.I ProductGrp["RC" S PackVolume=PackVolume*100
	.I ProductGrp["PLT" S PackVolume=PackVolume*200
	.I ProductGrp["CRYO" S PackVolume=PackVolume*0.5
	.//S BloodGrp=
	.I '$L(ProductGrp) Q
	.I $D(^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time)) D
	..S ^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time)=^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time)+PackVolume
	.E  D
	..S ^TMP($ZN,$J,"ProductGroup",LocID,ProductGrp,Time)=PackVolume
    .I '$L(PackProduct) Q
	.I $D(^TMP($ZN,$J,"Product",LocID,PackProduct,Time)) D
	..S ^TMP($ZN,$J,"Product",LocID,PackProduct,Time)=^TMP($ZN,$J,"Product",LocID,PackProduct,Time)+PackVolume
	.E  D
	..S ^TMP($ZN,$J,"Product",LocID,ProductCode,Time)=PackVolume
	Q 0
GetIssueNo(PatAdm,Years,Months,MonthFlag)
    S PatAdm=$G(PatAdm),Years=$G(Years),Months=$G(Months),sLabNameSpace=$G(sLabNameSpace)
    S MonDateS=Years_"-"_Months_"-"_1
    S MonDateS=$ZDH(MonDateS,3)
    S NextMonths=Months+1
    S MonDateE=Years_"-"_NextMonths_"-"_1
    I Months=12 D
    .S Years=Years+1
    .S NextMonths=1
    .S MonDateE=Years_"-"_NextMonths_"-"_1
    S MonDateE=$ZDH(MonDateE,3)-1
    S PAPMIDR=$P(^PAADM(PatAdm),"^",1)
    S Debtor=$P(^PAPER(PAPMIDR,"PAT",1),"^",1)
    S IssueNo=""
    F  S IssueNo=$O(^[sLabNameSpace]DHCBBIssueRecord(0,"DEBTORNO",Debtor,IssueNo)) Q:'$L(IssueNo)  D
    .S PackId=""
    .F  S PackId=$O(^[sLabNameSpace]DHCBBIssueRecord(0,"DEBTORNO",Debtor,IssueNo,PackId)) Q:'$L(PackId)  D
    ..S PackSubId=""
    ..F  S PackSubId=$O(^[sLabNameSpace]DHCBBIssueRecord(0,"DEBTORNO",Debtor,IssueNo,PackId,PackSubId)) Q:'$L(PackSubId)  D
    ...S IssueDate=$P(^[sLabNameSpace]DHCBBIssueRecord(IssueNo,PackId,PackSubId),"\",2)
    ...I MonDateS>IssueDate Q
    ...I MonDateE<IssueDate Q
    ...I MonthFlag="Now" D
    ....I $D(^TMP($ZN,$J,"Num",LocID)) D
    .....S ^TMP($ZN,$J,"Num",LocID)=^TMP($ZN,$J,"Num",LocID)+1
    ....E  D
    .....S ^TMP($ZN,$J,"Num",LocID)=1
    ...E  D
    ....I $D(^TMP($ZN,$J,"PreNum",LocID)) D
    .....S ^TMP($ZN,$J,"PreNum",LocID)=^TMP($ZN,$J,"PreNum",LocID)+1
    ....E  D
    .....S ^TMP($ZN,$J,"PreNum",LocID)=1
    Q
Output
	S Data=$lb(LocDesc,ISSNum,TotalVolume,PreTotalVolume,TotalVolRate,AvergeVol,RBC,PreRBC,RBCRate,FFP,PreFFP,FFPRate,PLT,PrePLT,PLTRate,CRYO,PreCRYO,CRYORate,Field1,Field2,Field3,Field4,Field5)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	Q
}

ClassMethod QuerySampleStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
 	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$O(^CacheTemp(repid,ind))
 	I ind="" 
 	{				// if there are no more rows, finish fetching
 		S AtEnd=1
 		S Row=""
 	}
 	Else      
 	{	// fetch row
 		S Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

/// Creator：      Qiuxianfu
/// CreatDate：    20140331
/// Description:： 样本数统计
/// Table：        
/// Input：        DateS:起始日期,DateE:结束日期，DepCode：检验科科室代码,MachCode仪器代码为空全部检索，MachTG：仪器组代码为空全部检索，CliCode：医生申请科室代码为空全部检索，DocCode:医生工号为空全部检索，PatientType：病人类型为空默认检索全部类型(N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人")
/// Output：       Debtor:登记号,PatName：病人姓名,SpeName：性别,PatAge：年龄,CliDepName：申请科室,Labno：检验号,TestName：医嘱名称,ColectDateTime:采集时间,RecevieDateTime:接收时间,AuthorDateTime:审核时间
/// Return：       无
/// Others：
Query QuerySampleStatistics(Year As %String, Month As %String, TimeFlag As %String, Product As %String, ProductGroup As %String, BloodGroup As %String, Diagnose As %String, HospitalCode As %String, USERCODE As %String) As %Query(ROWSPEC = "LocDesc:%String,ISSNum:%Integer,TotalVolume:%Float,PreTotalVolume:%String,TotalVolRate:%String,AvergeVol:%String,RBC:%Float,PreRBC:%String,RBCRate:%String,FFP:%Float,PreFFP:%String,FFPRate:%String,PLT:%Float,PrePLT:%String,PLTRate:%String,CRYO:%Float,PreCRYO:%String,CRYORate:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCBldStatDepStatisticDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatDepStatisticD</DataLocation>
<DefaultData>DHCBldStatDepStatisticDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatDepStatisticD</IdLocation>
<IndexLocation>^web.DHCBldStatDepStatisticI</IndexLocation>
<StreamLocation>^web.DHCBldStatDepStatisticS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
