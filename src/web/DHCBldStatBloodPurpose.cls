Class web.DHCBldStatBloodPurpose Extends %Persistent
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
/// D ##class(%ResultSet).RunQuery("web.DHCBldStatBloodPurpose","QuerySampleStatistics","2015-02-01","2015-02-07","","","","","","","","","","","","","demo")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, CliDep As %String, Ward As %String, Doctor As %String, PatType As %String, Purpose As %String, SupplierId As %String, ProductCode As %String, GroupCode As %String, productGroupCode As %String, HospitalCode As %String, Diagnose As %String, TansFormType As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  S ^TMP("xq1")=$lb(DateS, DateE, CliDep, Ward, Doctor, PatType, Purpose, SupplierId, ProductCode, GroupCode, productGroupCode, HospitalCode, Diagnose, TansFormType, USERCODE)
  I '$L(DateS) S qHandle=$lb(0,repid,0) Q $$$OK
  I '$L(DateE) S qHandle=$lb(0,repid,0) Q $$$OK
  S TimeS=""
  S TimeE=""
  I $L(DateS) S TimeS=$P(DateS," ",2),DateS=$P(DateS," ",1)
  I $L(DateE) S TimeE=$P(DateE," ",2),DateE=$P(DateE," ",1)
  I $L(TimeS) S TimeS=$ZTH(TimeS,1)
  I $L(TimeE) S TimeE=$ZTH(TimeE,1)
  I DateS=DateE,TimeS>=TimeE S qHandle=$lb(0,repid,0) Q $$$OK
  I '$L(USERCODE) S USERCODE="demo"
  //I CTLoc="null" S CTLoc=""
  I CliDep="null" S CliDep=""
  I Ward="null" S Ward=""
  I Doctor="null" S Doctor=""
  I Purpose="null" S Purpose=""
  S HospitalCode=$G(HospitalCode)
  S HospitalDesc=""
  //S HospitalCode=$O(^TTABi("CC",1,""))
  I $L(HospitalCode) S HospitalDesc=$P(^TTAB("CC",HospitalCode),"\",1)
  S TansFormType=$G(TansFormType)
  K ^TMP($zn,$j,"Purpose")
  I DateS?4N1"-"1.2N1"-"1.2N D
  .S DateS=$ZDH(DateS,3)
  E  S DateS=+H
  I DateE?4N1"-"1.2N1"-"1.2N D
  .S DateE=$ZDH(DateE,3)
  E  S DateE=+H
  S stAppFormIDPre=$TR($ZD(DateS,3),"-")_"000"
  S endAppFormIDPre=$TR($ZD(DateE,3),"-")_"000"
  S tBPGList="",vbTab=$C(9)
  S (labdata,meddata)=""
  S Deli=$C(2)
  I $L(DateS),$L(DateE){
		D QueryDiagnoseByDate 
  }
  b ;1
  S PurposeCode="" 
  F  S PurposeCode=$O(^TMP($ZN ,$J,"Purpose",PurposeCode)) Q:'$L(PurposeCode)  D
  .S ReqBldGrpCode=""
  .F  S ReqBldGrpCode=$O(^TMP($ZN ,$J,"Purpose",PurposeCode,ReqBldGrpCode)) Q:ReqBldGrpCode=""  D
  ..Q:'$L(^TMP($ZN ,$J,"Purpose",PurposeCode,ReqBldGrpCode))
  ..S Data=$G(^TMP($ZN ,$J,"Purpose",PurposeCode,ReqBldGrpCode))
  ..S PurposeDesc=$P(^DHCBLDSTDCOMMENT(PurposeCode),"\",2)
  ..S ReqBldGrpVolume=$P(^TMP($ZN ,$J,"Purpose",PurposeCode,ReqBldGrpCode),"\",1)
  ..S TRANS3BldGrpVolume=$P(^TMP($ZN ,$J,"Purpose",PurposeCode,ReqBldGrpCode),"\",2)
  ..S tBPGList=ReqBldGrpCode_"\"_ReqBldGrpVolume_"\"_ReqBldGrpCode_"\"_TRANS3BldGrpVolume_","
  ..S tBPGList=##Class(web.DHCBldStatOverTransRecord).BuildOutPutSeq(tBPGList)
  ..S RBC1=$P(tBPGList,vbTab,1)
  ..S RBC2=$P(tBPGList,vbTab,2)
  ..S FFP1=$P(tBPGList,vbTab,3)
  ..S FFP2=$P(tBPGList,vbTab,4)
  ..S PLT1=$P(tBPGList,vbTab,5)
  ..S PLT2=$P(tBPGList,vbTab,6)
  ..S CRYO1=$P(tBPGList,vbTab,7)
  ..S CRYO2=$P(tBPGList,vbTab,8)
  ..I '$L(RBC2)!(+RBC2=0) D
  ...S RateRBC=""
  ..E  D
  ...S RateRBC=$Fn(RBC2/RBC1,",",3)*100_"%"
  ..I '$L(FFP2)!(+FFP2=0) D
  ...S RateFFP=""
  ..E  D
  ...S RateFFP=$Fn(FFP2/FFP1,",",3)*100_"%"
  ..I '$L(PLT2)!(+PLT2=0) D
  ...S RatePLT=""
  ..E  D
  ...S RatePLT=$Fn(PLT2/PLT1,",",3)*100_"%"
  ..I '$L(CRYO2)!(+CRYO2=0) D
  ...S RateCRYO=""
  ..E  D
  ...S RateCRYO=$Fn(CRYO2/CRYO1,",",3)*100_"%"
  ..S (Field1,Field2,Field3,Field4,Field5,tBPGList)=""
  ..;S Field1=Rate
  ..;S Field2=DiagnoseICD
  ..;S Field3=DiagnoseDesc
  ..//S Field5=HospitalDesc
  ..I '$L(RBC1),'$L(FFP1),'$L(PLT1) Q
  ..S Data=$lb(PurposeDesc,HospitalDesc,RBC1,RBC2,FFP1,FFP2,PLT1,PLT2,CRYO1,CRYO2,Field1,Field2,Field3,Field4,Field5)
  ..D Output 
  K ^TMP($zn,$j)
  S qHandle=$lb(0,repid,0)
  Q $$$OK
QueryDiagnoseByDate
  S isQuit=0,index=1
  S curAppFormID=$O(^DHCBLDAPPFORM(stAppFormIDPre),-1)
  //b ;12
  F  S curAppFormID=$O(^DHCBLDAPPFORM(curAppFormID)) Q:('$L(curAppFormID))!(isQuit=1)  D
  .Q:$E(curAppFormID,1,8)'?8N
  .S curDate=$ZDH($E(curAppFormID,1,4)_"-"_$E(curAppFormID,5,6)_"-"_$E(curAppFormID,7,8),3)
  .Q:curDate<DateS
  .//W "A",curAppFormID,!
  .S:DateE<curDate isQuit=1
  .Q:isQuit=1
  .//W "B",curAppFormID,!
  .Q:'$D(^DHCBLDAPPFORM(curAppFormID,"F"))
  .S Labno=""
  .S OrderId=$O(^DHCBLDAPPFORM(curAppFormID,"ORDER",""))
  .Q:'$L(OrderId)
  .S AuthAppFormTime=""
  .I $D(^DHCBLDAPPFORM(curAppFormID,"OPERATION",2,"CH")) D 
  ..S DoctorCode=$O(^DHCBLDAPPFORM(curAppFormID,"OPERATION",2,"CH",""))
  ..S AuthAppFormTime=$P(^DHCBLDAPPFORM(curAppFormID,"OPERATION",2,"CH",DoctorCode),"\",5)
  .I $L(Doctor),Doctor'=DoctorCode Q 
  .I '$L(AuthAppFormTime) Q
  .//I (curDate=DateS),(AuthAppFormTime<TimeS) Q
  .//I (curDate=DateE),(AuthAppFormTime>TimeE) Q
  .S curFormType=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",2)
  .S curTansFormType=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",4)
  .S (PurposeCode,PurposeDesc,PurposeGruopCode,PurposeGruopDesc)=""
  .//B ;"C",curAppFormID,!
  .F  S PurposeCode=$O(^DHCBLDAPPFORM(curAppFormID,"PURPOSE",PurposeCode)) Q:PurposeCode=""  D
  ..//S PurposeDesc=$P(^DHCBLDSTDCOMMENT(PurposeCode),"\",2)
  ..//S PurposeGruopCode=PurposeGruopCode_PurposeCode_","
  ..//S PurposeGruopDesc=PurposeGruopDesc_PurposeGruopDesc_","
  ..//S PurposeGruopCode=$E(PurposeGruopCode,1,$L(PurposeGruopCode)-1)
  ..//S PurposeGruopDesc=$E(PurposeGruopDesc,1,$L(PurposeGruopDesc)-1)
  ..I $L(Purpose),PurposeCode'[Purpose Q
  ..Q:$L(TansFormType)&(curTansFormType'=TansFormType)
  ..S appInfo=##class(web.DHCBldStatByDiagnose).GetAppFormInfo(curAppFormID,labdata,meddata,CliDep,HospitalCode,Ward)
  ..S patType=$P(appInfo,Deli,10)
  ..I $L(PatType),patType'=PatType Q
  ..S PatDiagnose=""
  ..Q:$L(appInfo,"#")<2
  ..S BldGrpStr=$P(appInfo,"#",2)
  ..F i=1:1:$L(BldGrpStr,",")-1 D
  ...S BldGrpInfo=$P(BldGrpStr,",",i)
  ...S ReqBldGrpCode=$P(BldGrpInfo,"\",1)
  ...S ReqBldGrpVolume=$P(BldGrpInfo,"\",2)
  ...S TRANS3BldGrpCode=$P(BldGrpInfo,"\",3)
  ...S TRANS3BldGrpVolume=$P(BldGrpInfo,"\",4)
  ...I '$D(^TMP($ZN ,$J,"Purpose",PurposeCode,ReqBldGrpCode)) D
  ....S ^TMP($ZN ,$J,"Purpose",PurposeCode,ReqBldGrpCode)=ReqBldGrpVolume_"\"_TRANS3BldGrpVolume
  ...E  D
  ....S $P(^TMP($ZN ,$J,"Purpose",PurposeCode,ReqBldGrpCode),"\",1)=$P(^TMP($ZN ,$J,"Purpose",PurposeCode,ReqBldGrpCode),"\",1)+ReqBldGrpVolume
  ....S $P(^TMP($ZN ,$J,"Purpose",PurposeCode,ReqBldGrpCode),"\",2)=$P(^TMP($ZN ,$J,"Purpose",PurposeCode,ReqBldGrpCode),"\",2)+TRANS3BldGrpVolume
  Q 
Output
    S Data=$lb(PurposeDesc,HospitalDesc,RBC1,RBC2,FFP1,FFP2,PLT1,PLT2,CRYO1,CRYO2,Field1,Field2,Field3,Field4,Field5)
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
Query QuerySampleStatistics(DateS As %String, DateE As %String, CliDep As %String, Ward As %String, Doctor As %String, PatType As %String, Purpose As %String, SupplierId As %String, ProductCode As %String, GroupCode As %String, productGroupCode As %String, HospitalCode As %String, Diagnose As %String, TansFormType As %String, USERCODE As %String) As %Query(ROWSPEC = "PurposeDesc:%String,HospitalDesc:%String,RBC1:%String,RBC2:%String,FFP1:%String,FFP2:%String,PLT1:%String,PLT2:%String,CRYO1:%String,CRYO2:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCBldStatBloodPurposeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatBloodPurposeD</DataLocation>
<DefaultData>DHCBldStatBloodPurposeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatBloodPurposeD</IdLocation>
<IndexLocation>^web.DHCBldStatBloodPurposeI</IndexLocation>
<StreamLocation>^web.DHCBldStatBloodPurposeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
