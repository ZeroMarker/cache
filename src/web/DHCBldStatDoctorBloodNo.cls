Class web.DHCBldStatDoctorBloodNo Extends %Persistent
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
/// D ##class(%ResultSet).RunQuery("web.DHCBldStatDoctorBloodNo","QuerySampleStatistics","2015","2","0","","","","","","","0")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, Year As %String, Month As %String, TimeFlag As %String, Product As %String, ProductGroup As %String, BloodGroup As %String, Diagnose As %String, HospitalCode As %String, USERCODE As %String, CheckWB As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  S sLabNameSpace=$g(sLabNameSpace),HospitalCode=$G(HospitalCode),TimeFlag=$G(TimeFlag)
  S Product=$G(Product),ProductGroup=$G(ProductGroup),BloodGroup=$G(BloodGroup),Diagnose=$G(Diagnose),CheckWB=$G(CheckWB)
  //S TimeFlag=1
  I ProductGroup="null" S ProductGroup=""
  I BloodGroup="null" S BloodGroup=""
  I Diagnose="null" S Diagnose=""
  I '$L(TimeFlag) S TimeFlag=0
  S ^TMP("xq")=$lb(Year,Month,TimeFlag,Product,ProductGroup,BloodGroup,Diagnose,HospitalCode,USERCODE,CheckWB)
  I '$L(Year) S qHandle=$lb(0,repid,0) Q $$$OK
  I '$L(Month),TimeFlag=0 S qHandle=$lb(0,repid,0) Q $$$OK
  //TimeFlag 0 按月查询,1 按年查询
  //S DateS=Year_"-"_Month
  //S DateE=Year_"-"_Month
  I $L(USERCODE) S USERCODE="demo"
  S HospitalCode=$g(HospitalCode)
  S Month=+Month
  S PreMonth=Month-1
  I Month=12 S PreMonth=1
  S HospitalDesc=""
  I $L(HospitalCode) S HospitalDesc=$P(^TTAB("CC",HospitalCode),"\",1)
  K ^TMP($zn,$j)
  S DoctorID=""
  S HospRBCTotalVol=0
  S HospFFPTotalVol=0
  S HospPLTTotalVol=0
  S HospCRYOTotalVol=0
  S HospWBTotalVol=0
  S HospISSNum=0
  I TimeFlag=0 D
  .F  S DoctorID=$O(^lab.DHCBldStatBloodUseI("IndexDoctor",DoctorID)) Q:'$L(DoctorID)  D
  ..//本月出院人次，上个月出院人次
  ..S DischargeNum=0,PreDischargeNum=0
  ..//本月输注人次，上个月输注人次
  ..S ISSNum=0,PreISSNum=0
  ..S PackSumVol=0
  ..S iDate=""
  ..F  S iDate=$O(^lab.DHCBldStatBloodUseI("IndexDoctor",DoctorID,iDate)) Q:'$L(iDate)  D
  ...I $L(iDate)'=5 Q
  ...S iYear=$P($ZD(iDate,3),"-",1)
  ...S iYear=+iYear
  ...S iMonth=$P($ZD(iDate,3),"-",2)
  ...S iMonth=+iMonth
  ...I Year'=iYear Q
  ...I iMonth'=Month,iMonth'=PreMonth Q
  ...S PatType=""
  ...F  S PatType=$O(^lab.DHCBldStatBloodUseI("IndexDoctor",DoctorID,iDate,PatType)) Q:'$L(PatType)  D
  ....S DiagnoseID=""
  ....F  S DiagnoseID=$O(^lab.DHCBldStatBloodUseI("IndexDoctor",DoctorID,iDate,PatType,DiagnoseID)) Q:'$L(DiagnoseID)  D
  .....S PatAdm=""
  .....I $L(Diagnose),Diagnose'=DiagnoseID Q
  .....F  S PatAdm=$O(^lab.DHCBldStatBloodUseI("IndexDoctor",DoctorID,iDate,PatType,DiagnoseID,PatAdm)) Q:'$L(PatAdm)  D
  ......//S PAPMIDR=$P(^PAADM(PatAdm),"^",1)
  ......//S Debtor=$P(^PAPER(PAPMIDR,"PAT",1),"^",1)
  ......S BloodGrp=..GetBloodGroupID(PatAdm)
  ......I $L(BloodGroup),BloodGroup'=BloodGrp Q
  ......S PackVolInfo=$$AdmPackVolume(PatAdm,DoctorID,iMonth)
  ......S DischargeNum=DischargeNum+1
  ......I $li(^lab.DHCBldStatBloodUseD(PatAdm),9)'="Y" Q
  ......D GetIssueNo(PatAdm,Year,Month,"Now")
  E  D
  .S Num=0
  .F  S DoctorID=$O(^lab.DHCBldStatBloodUseI("IndexDoctor",DoctorID)) Q:'$L(DoctorID)  D
  ..//本月出院人次，上个月出院人次
  ..S DischargeNum=0,PreDischargeNum=0
  ..//本月输注人次，上个月输注人次
  ..S ISSNum=0,PreISSNum=0
  ..S PackSumVol=0
  ..S iDate=""
  ..F  S iDate=$O(^lab.DHCBldStatBloodUseI("IndexDoctor",DoctorID,iDate)) Q:'$L(iDate)  D
  ...S iYear=$P($ZD(iDate,3),"-",1)
  ...S iYear=+iYear
  ...I Year'=iYear Q
  ...S PatType=""
  ...F  S PatType=$O(^lab.DHCBldStatBloodUseI("IndexDoctor",DoctorID,iDate,PatType)) Q:'$L(PatType)  D
  ....S DiagnoseID=""
  ....F  S DiagnoseID=$O(^lab.DHCBldStatBloodUseI("IndexDoctor",DoctorID,iDate,PatType,DiagnoseID)) Q:'$L(DiagnoseID)  D
  .....S PatAdm=""
  .....I $L(Diagnose),Diagnose'=DiagnoseID Q
  .....F  S PatAdm=$O(^lab.DHCBldStatBloodUseI("IndexDoctor",DoctorID,iDate,PatType,DiagnoseID,PatAdm)) Q:'$L(PatAdm)  D
  ......//S PAPMIDR=$P(^PAADM(PatAdm),"^",1)
  ......//S Debtor=$P(^PAPER(PAPMIDR,"PAT",1),"^",1)
  ......S BloodGrp=..GetBloodGroupID(PatAdm)
  ......I $L(BloodGroup),BloodGroup'=BloodGrp Q
  ......S PackVolInfo=$$AdmPackVolume(PatAdm,DoctorID,Year)
  ......S DischargeNum=DischargeNum+1
  ......I $li(^lab.DHCBldStatBloodUseD(PatAdm),9)'="Y" Q
  ......D GetYearIssueNo(PatAdm,Year)
  ...S Num=Num+1
  ...//W Num,"+",$ZD(iDate,3),"+",DoctorID,!
  I CheckWB=0 D
  .S HospTotalVol=HospFFPTotalVol+HospRBCTotalVol+HospCRYOTotalVol+HospPLTTotalVol
  Else  D
  .S HospTotalVol=HospFFPTotalVol+HospRBCTotalVol+HospCRYOTotalVol+HospPLTTotalVol+HospWBTotalVol
  S TotalRBC=0,TotalFFP=0,TotalPLT=0,TotalCRYO=0,TotalWB=0
  S AllVolume=0,AllISSNum=0
  S DoctorID="",DoctorIdCTPCP=""
  F  S DoctorID=$O(^TMP($ZN,$J,"ProductGroup",DoctorID)) Q:'$L(DoctorID)  D
  .S DoctorIdCTPCP=DoctorID
  .S (HospID,CurHospitalCode,locCode)=""
  .I '$D(^SSU("SSUSR",DoctorID)) D
  ..I $D(^SSU("SSUSR",0,"CTPCP",DoctorID)) S DoctorIdCTPCP=$O(^SSU("SSUSR",0,"CTPCP",DoctorID,""))
  .S LocID=$O(^SSU("SSUSR",DoctorIdCTPCP,"OTHLL",""),-1)
  .I '$L(LocID) Q
  .S HospID=$P(^CTLOC(LocID),"^",22),locCode=$P(^CTLOC(LocID),"^",1)
  .I $L(HospID) s CurHospitalCode=$P(^CT("HOSP",HospID),"^",1)
  .I $L(HospitalCode),HospitalCode'=CurHospitalCode Q
  .S PreISSNum=0
  .S ISSNum=0
  .S TotalVolume=0
  .S PreTotalVolume=0
  .S FFP=0
  .S RBC=0
  .S CRYO=0
  .S PLT=0
  .S WB=0
  .S PreFFP=0
  .S PreRBC=0
  .S PreCRYO=0
  .S PrePLT=0
  .S PreWB=0
  .S DoctorDesc=$P($G(^SSU("SSUSR",DoctorIdCTPCP)),"^",2)
  .S ProductGrp=""
  .F  S ProductGrp=$O(^TMP($ZN,$J,"ProductGroup",DoctorID,ProductGrp)) Q:'$L(ProductGrp)  D
  ..I $L(ProductGroup),ProductGroup'=ProductGrp Q
  ..S Time=""
  ..F  S Time=$O(^TMP($ZN,$J,"ProductGroup",DoctorID,ProductGrp,Time)) Q:'$L(Time)  D
  ...I Month=Time D
  ....D GetProGrpVolume
  ...I Year=Time D
  ....D GetProGrpVolume
  .//S TotalVolRate=0
  .//I PreTotalVolume'=0 S TotalVolRate=$E((TotalVolume-PreTotalVolume)/PreTotalVolume,1,4)*100_"%"
  .//S AvergeVol=0
  .S HospTitalVolRate=0_"%"
  .I HospTotalVol'=0 S HospTitalVolRate=$E(TotalVolume/HospTotalVol,1,5)*100_"%"
  .S HospISSNumRate=0_"%"
  .I HospISSNum'=0 S HospISSNumRate=$E(ISSNum/HospISSNum,1,5)*100_"%"
  .I '$L(ISSNum) S ISSNum=0
  .I ISSNum'=0 S AvergeVol=$E(TotalVolume/ISSNum,1,5)*100_"%"
  .S RBCRate=0_"%"
  .I HospRBCTotalVol'=0 S RBCRate=$E(RBC/HospRBCTotalVol,1,5)*100_"%"
  .S FFPRate=0_"%"
  .I HospFFPTotalVol'=0 S FFPRate=$E(FFP/HospFFPTotalVol,1,5)*100_"%"
  .S PLTRate=0_"%"
  .I HospPLTTotalVol'=0 S PLTRate=$E(PLT/HospPLTTotalVol,1,5)*100_"%"
  .S CRYORate=0_"%"
  .I HospCRYOTotalVol'=0 S CRYORate=$E(CRYO/HospCRYOTotalVol,1,5)*100_"%"
  .S WBRate=0_"%"
  .I HospWBTotalVol'=0 S WBRate=$E(WB/HospWBTotalVol,1,5)*100_"%"
  .S (Field1,Field2,Field3,Field4,Field5)=""
  .S Field5=HospitalDesc
  .I $E(HospTitalVolRate,1)="." S HospTitalVolRate=0_HospTitalVolRate
  .I $E(HospISSNumRate,1)="." S HospISSNumRate=0_HospISSNumRate
  .I $E(RBCRate,1)="." S RBCRate=0_RBCRate
  .I $E(FFPRate,1)="." S FFPRate=0_FFPRate
  .I $E(PLTRate,1)="." S PLTRate=0_PLTRate
  .I $E(CRYORate,1)="." S CRYORate=0_CRYORate
  .I $E(WBRate,1)="." S WBRate=0_WBRate
  .I TotalVolume=0,ISSNum=0,RBC=0,FFP=0,PLT=0,CRYO=0,WB=0 Q
  .I $L(ProductGroup),"RC"'=ProductGroup S (RBC,PreRBC,RBCRate)=""
  .I $L(ProductGroup),"FFP"'=ProductGroup S (FFP,PreFFP,FFPRate)=""
  .I $L(ProductGroup),"PLT"'=ProductGroup S (PLT,PrePLT,PLTRate)=""
  .I $L(ProductGroup),"CRYO"'=ProductGroup S (CRYO,PreCRYO,CRYORate)=""
  .I $L(ProductGroup),"WB"'=ProductGroup S (WB,PreWB,WBRate)=""
  .//W LocDesc,"+",TotalVolume,"+",HospTotalVol,"+",HospTitalVolRate,"-->",ISSNum,"+",HospISSNum,"+",HospISSNumRate,"-->",RBC,"+",HospRBCTotalVol,"+",RBCRate,"-->",FFP,"+",HospFFPTotalVol,"+",FFPRate,"-->",CRYO,"+",HospCRYOTotalVol,"+",CRYORate,"-->",PLT,"+",HospPLTTotalVol,"+",PLTRate,"-->",!
  .I CheckWB="0" S (WB,WBRate)=""
  .S Data=$lb(DoctorDesc,TotalVolume,HospTitalVolRate,ISSNum,HospISSNumRate,RBC,RBCRate,FFP,FFPRate,PLT,PLTRate,CRYO,CRYORate,WB,WBRate,Field1,Field2,Field3,Field4,Field5)
  .D Output
  S (LocDesc,TotalVolume,HospTitalVolRate,ISSNum,HospISSNumRate,RBC,RBCRate,FFP,FFPRate,PLT,PLTRate,CRYO,CRYORate,WB,WBRate)=""
  S LocDesc="合计：",TotalVolume=AllVolume,ISSNum=AllISSNum
  S RBC=TotalRBC,FFP=TotalFFP,PLT=TotalPLT,CRYO=TotalCRYO,WB=TotalWB
  K ^TMP($zn,$j)
  S qHandle=$lb(0,repid,0)
  Q $$$OK

  
  
GetProGrpVolume
  I CheckWB=0,ProductGrp["WB" Q
  S ISSNum=$P($G(^TMP($ZN,$J,"Num",DoctorID)),"\",1)
  S TotalVolume=TotalVolume+$G(^TMP($ZN,$J,"ProductGroup",DoctorID,ProductGrp,Time))
  I ProductGrp["FFP" S FFP=$G(^TMP($ZN,$J,"ProductGroup",DoctorID,ProductGrp,Time))
  I ProductGrp["RC" S RBC=$G(^TMP($ZN,$J,"ProductGroup",DoctorID,ProductGrp,Time))
  I ProductGrp["CRYO" S CRYO=$G(^TMP($ZN,$J,"ProductGroup",DoctorID,ProductGrp,Time))
  I ProductGrp["PLT" S PLT=$G(^TMP($ZN,$J,"ProductGroup",DoctorID,ProductGrp,Time))
  I ProductGrp["WB" S WB=$G(^TMP($ZN,$J,"ProductGroup",DoctorID,ProductGrp,Time))
  
AdmPackVolume(AdmID,DoctorID,Time)
	S AdmID=$G(AdmID),DoctorID=$G(DoctorID),Time=$G(Time)
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
	.I CheckWB=0,ProductGrp["WB" Q
	.I $D(^TMP($ZN,$J,"ProductGroup",DoctorID,ProductGrp,Time)) D
	..S ^TMP($ZN,$J,"ProductGroup",DoctorID,ProductGrp,Time)=^TMP($ZN,$J,"ProductGroup",DoctorID,ProductGrp,Time)+PackVolume
	.E  D
	..S ^TMP($ZN,$J,"ProductGroup",DoctorID,ProductGrp,Time)=PackVolume
    .I '$L(PackProduct) Q
	.I $D(^TMP($ZN,$J,"Product",DoctorID,PackProduct,Time)) D
	..S ^TMP($ZN,$J,"Product",DoctorID,PackProduct,Time)=^TMP($ZN,$J,"Product",DoctorID,PackProduct,Time)+PackVolume
	.E  D
	..S ^TMP($ZN,$J,"Product",DoctorID,PackProduct,Time)=PackVolume
	.I ProductGrp["FFP" S HospFFPTotalVol=HospFFPTotalVol+PackVolume
    .I ProductGrp["RC" S HospRBCTotalVol=HospRBCTotalVol+PackVolume
    .I ProductGrp["CRYO" S HospCRYOTotalVol=HospCRYOTotalVol+PackVolume
    .I ProductGrp["PLT" S HospPLTTotalVol=HospPLTTotalVol+PackVolume
    .I ProductGrp["WB" S HospWBTotalVol=HospWBTotalVol+PackVolume
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
    ...S PackProduct=$P(^TBBP(PackId,PackSubId),"\",4)
	...S ProductGrp=$P(^TTAB("BB-BP",PackProduct),"\",21)
	...I CheckWB=0,ProductGrp["WB" Q 
    ...I MonDateS>IssueDate Q
    ...I MonDateE<IssueDate Q
    ...I MonthFlag="Now" D
    ....I $D(^TMP($ZN,$J,"Num",DoctorID)) D
    .....S ^TMP($ZN,$J,"Num",DoctorID)=^TMP($ZN,$J,"Num",DoctorID)+1
    ....E  D
    .....S ^TMP($ZN,$J,"Num",DoctorID)=1
    ...E  D
    ....I $D(^TMP($ZN,$J,"PreNum",DoctorID)) D
    .....S ^TMP($ZN,$J,"PreNum",DoctorID)=^TMP($ZN,$J,"PreNum",DoctorID)+1
    ....E  D
    .....S ^TMP($ZN,$J,"PreNum",DoctorID)=1
    ...S HospISSNum=HospISSNum+1
    Q
GetYearIssueNo(PatAdm,Years)
    S PatAdm=$G(PatAdm),Years=$G(Years)
    S PAPMIDR=$P(^PAADM(PatAdm),"^",1)
    S Debtor=$P(^PAPER(PAPMIDR,"PAT",1),"^",1)
    S IssueNo=""
    F  S IssueNo=$O(^[sLabNameSpace]DHCBBIssueRecord(0,"DEBTORNO",Debtor,IssueNo)) Q:'$L(IssueNo)  D
    .S PackId=""
    .F  S PackId=$O(^[sLabNameSpace]DHCBBIssueRecord(0,"DEBTORNO",Debtor,IssueNo,PackId)) Q:'$L(PackId)  D
    ..S PackSubId=""
    ..F  S PackSubId=$O(^[sLabNameSpace]DHCBBIssueRecord(0,"DEBTORNO",Debtor,IssueNo,PackId,PackSubId)) Q:'$L(PackSubId)  D
    ...S IssueDate=$P(^[sLabNameSpace]DHCBBIssueRecord(IssueNo,PackId,PackSubId),"\",2)
    ...S PackProduct=$P(^TBBP(PackId,PackSubId),"\",4)
	...S ProductGrp=$P(^TTAB("BB-BP",PackProduct),"\",21)
	...I CheckWB=0,ProductGrp["WB" Q 
    ...S IssueYear=$P($ZD(IssueDate,3),"-",1)
    ...I Years'=IssueYear Q
    ...I $D(^TMP($ZN,$J,"Num",DoctorID)) D
    ....S ^TMP($ZN,$J,"Num",DoctorID)=^TMP($ZN,$J,"Num",DoctorID)+1
    ...E  D
    ....S ^TMP($ZN,$J,"Num",DoctorID)=1
    ...S HospISSNum=HospISSNum+1
    Q
Output
	S Data=$lb(DoctorDesc,TotalVolume,HospTitalVolRate,ISSNum,HospISSNumRate,RBC,RBCRate,FFP,FFPRate,PLT,PLTRate,CRYO,CRYORate,WB,WBRate,Field1,Field2,Field3,Field4,Field5)
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
Query QuerySampleStatistics(Year As %String, Month As %String, TimeFlag As %String, Product As %String, ProductGroup As %String, BloodGroup As %String, Diagnose As %String, HospitalCode As %String, USERCODE As %String, CheckWB As %String) As %Query(ROWSPEC = "DoctorDesc:%String,TotalVolume:%String,HospTitalVolRate:%String,ISSNum:%String,HospISSNumRate:%String,RBC:%String,RBCRate:%String,FFP:%String,FFPRate:%String,PLT:%String,PLTRate:%String,CRYO:%String,CRYORate:%String,WB:%String,WBRate:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

ClassMethod GetBloodGroupID(admID As %String) As %String
{
	S admID=$G(admID)
	//S patientID=..GetPatientID(admID)
	S PAPMIDR=$P(^PAADM(admID),"^",1)
    S patientID=$P(^PAPER(PAPMIDR,"PAT",1),"^",1)
	Q:'$L(patientID) ""
	S labdata="LABDATA"
	S ret=$P($G(^|labdata|TDEB(patientID)),"\",4)
	Q:$L(ret) ret
	S ret=$P($G(^|labdata|TDEB(patientID)),"\",10) 
	Q:$L(ret) ret
	//获取最近ABO,RH血型结果
	S (resultABO,resultRhD)=""
	S result=##Class(LIS.Service.LAB).GetLatestResult(patientID,"ABO","")
	S:$L(result) resultABO=result.Result
	S result=##Class(LIS.Service.LAB).GetLatestResult(patientID,"RH","")
	S:$L(result) resultRhD=result.Result 
	S ret=##Class(LIS.Core.Util).GetBloodGroupID(resultABO_resultRhD)			
	Q:$L(ret) ret
	//从第三方获取血型结果
	S ret=##Class(LIS.Service.TMS.Core).GetBloodGroupID(admID,.error) 
    Q ret
}

Storage Default
{
<Data name="DHCBldStatDoctorBloodNoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatDoctorBloodNoD</DataLocation>
<DefaultData>DHCBldStatDoctorBloodNoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatDoctorBloodNoD</IdLocation>
<IndexLocation>^web.DHCBldStatDoctorBloodNoI</IndexLocation>
<StreamLocation>^web.DHCBldStatDoctorBloodNoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
