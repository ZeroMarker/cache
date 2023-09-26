Class web.DHCBldStatByDiagnose Extends %Persistent
{

Parameter BUILD = 60;

ClassMethod QuerySampleStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
	Q $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCBldStatByDiagnose","QuerySampleStatistics","2015-03-09 15:46:26","2015-03-20 15:46:26","","","","","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, SupplierId As %String, ProductCode As %String, GroupCode As %String, productGroupCode As %String, HospitalCode As %String, CliDep As %String, TansFormType As %String, USERCODE As %String, Diagnose As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  I CliDep="null" S CliDep=""
  S ^TMP("icd10")=$LB(DateS, DateE, SupplierId, ProductCode, GroupCode, productGroupCode, HospitalCode, CliDep, TansFormType, USERCODE, Diagnose)
  I '$L(DateS) S qHandle=$lb(0,repid,0) Q $$$OK
  I '$L(DateE) S qHandle=$lb(0,repid,0) Q $$$OK
  S TimeS=""
  S TimeE=""
  I $L(DateS) S TimeS=$P(DateS," ",2),DateS=$P(DateS," ",1)
  I $L(DateE) S TimeE=$P(DateE," ",2),DateE=$P(DateE," ",1)
  I $L(TimeS) S TimeS=$ZTH(TimeS,1)
  I $L(TimeE) S TimeE=$ZTH(TimeE,1)
  I '$L(USERCODE) S USERCODE="demo"
  S HospitalCode=$G(HospitalCode)
  S HospitalDesc=""
  //S HospitalCode=$O(^TTABi("CC",1,""))
  I $L(HospitalCode) S HospitalDesc=$P(^TTAB("CC",HospitalCode),"\",1)
  S TansFormType=$G(TansFormType)
  S DateS=$G(DateS),DateE=$G(DateE)
  S Deli=$C(2)
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
  I $L(DateS),$L(DateE){
		D QueryDiagnoseByDate 
  }
  S num=""  F  S num=$O(^TMP($ZN ,$J,"QueryDiagnose",num))  Q:num=""  D
  .Q:'$L(^TMP($ZN ,$J,"QueryDiagnose",num))
  .S Data=$G(^TMP($ZN ,$J,"QueryDiagnose",num))
  .S PatBasicInfo=$P(Data,"#",1)
  .S tBPGList=$P(Data,"#",2)
  .S DiagnoseInfo=$P(Data,"#",3)
  .S DiagnoseICD=$P(DiagnoseInfo,"\",1)
  .S DiagnoseDesc=$P(DiagnoseInfo,"\",2)
  .S (patName,patSex,patAge,patRegNo,patMedicare,CliDepDesc,patWardDesc,lstSaveUserDesc,patDiagnos)=""
  .S patName=$P(PatBasicInfo,Deli,1)
  .S patSex=$P(PatBasicInfo,Deli,2)
  .S patAge=$P(PatBasicInfo,Deli,3)
  .S patRegNo=$P(PatBasicInfo,Deli,4)
  .S patMedicare=$P(PatBasicInfo,Deli,5)
  .S CliDepDesc=$P(PatBasicInfo,Deli,6)
  .S patWardDesc=$P(PatBasicInfo,Deli,7)
  .S lstSaveUserDesc=$P(PatBasicInfo,Deli,8)
  .S patDiagnos=$P(PatBasicInfo,Deli,9)
  .S tBPGList=##Class(web.DHCBldStatOverTransRecord).BuildOutPutSeq(tBPGList)
  .S RBC1=$P(tBPGList,vbTab,1)
  .Q:'$L(RBC1)
  .S RBC2=$P(tBPGList,vbTab,2)
  .S FFP1=$P(tBPGList,vbTab,3)
  .S FFP2=$P(tBPGList,vbTab,4)
  .I '$L(RBC2)!(+RBC2=0) D
  ..S Rate=""
  .E  D
  ..S Rate=$Fn(RBC2/RBC1,",",3)*100_"%"
  .S (Field1,Field2,Field3,Field4,Field5,tBPGList)=""
  .S Field1=Rate
  .S Field2=DiagnoseICD
  .S Field3=DiagnoseDesc
  .S Field5=HospitalDesc
  .S Data=$lb(patName,patSex,patAge,patRegNo,patMedicare,CliDepDesc,patWardDesc,lstSaveUserDesc,patDiagnos,RBC1,RBC2,FFP1,FFP2,Field1,Field2,Field3,Field4,Field5)
  .D Output  
  K ^TMP($ZN,$J)
  S qHandle=$lb(0,repid,0)
  Q $$$OK 

QueryDiagnoseByDate
  S isQuit=0,index=1
  S curAppFormID=$O(^DHCBLDAPPFORM(stAppFormIDPre),-1)
  F  S curAppFormID=$O(^DHCBLDAPPFORM(curAppFormID)) Q:('$L(curAppFormID))!(isQuit=1)  D
  .Q:$E(curAppFormID,1,8)'?8N
  .S curDate=$ZDH($E(curAppFormID,1,4)_"-"_$E(curAppFormID,5,6)_"-"_$E(curAppFormID,7,8),3)
  .Q:curDate<DateS
  .S:DateE<curDate isQuit=1
  .S AuthAppFormTime=""
  .I $D(^DHCBLDAPPFORM(curAppFormID,"OPERATION",2,"CH")) D 
  ..S DoctorCode=$O(^DHCBLDAPPFORM(curAppFormID,"OPERATION",2,"CH",""))
  ..S AuthAppFormTime=$P(^DHCBLDAPPFORM(curAppFormID,"OPERATION",2,"CH",DoctorCode),"\",5)
  .I '$L(AuthAppFormTime) Q
  .I (curDate=DateS),(AuthAppFormTime<TimeS) Q
  .I (curDate=DateE),(AuthAppFormTime>TimeE) Q
  .Q:isQuit=1
  .Q:'$D(^DHCBLDAPPFORM(curAppFormID,"F"))
  .S Labno=""
  .S OrderId=$O(^DHCBLDAPPFORM(curAppFormID,"ORDER",""))
  .Q:'$L(OrderId)
  .S Labno=$P(^DHCBLDAPPFORM(curAppFormID,"ORDER",OrderId),"\",4)
  .S AdmId=##class(web.DHCLabCommonUse).EpisNoToAdm(Labno)
  .S diagDesc=##Class(LIS.Core.Patient).GetDiagnosis(AdmId)
  .S diagICD=..GetDiagnosisICD(AdmId)
  .I '$L(diagICD) Q
  .//W diagICD,!
  .S DiagnoseDesc=""
  .I $L(Diagnose) S DiagnoseDesc=$P(^MRC("ID",Diagnose),"^",2)
  .I $L(DiagnoseDesc),diagDesc'[DiagnoseDesc Q
  .S curFormType=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",2)
  .S curTansFormType=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",4)
  .Q:$L(TansFormType)&(curTansFormType'=TansFormType)
  .S appInfo=..GetAppFormInfo(curAppFormID,labdata,meddata,CliDep,HospitalCode,"")
  .S PatDiagnose=""
  .Q:$L(appInfo,"#")<2
  .S:$L(appInfo) ^TMP($ZN ,$J,"QueryDiagnose",index)=appInfo_"#"_diagICD_"\"_diagDesc
  .S index=index+1
  Q 
 
Output
	S Data=$lb(patName,patSex,patAge,patRegNo,patMedicare,CliDepDesc,patWardDesc,lstSaveUserDesc,patDiagnos,RBC1,RBC2,FFP1,FFP2,Field1,Field2,Field3,Field4,Field5)
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
Query QuerySampleStatistics(DateS As %String, DateE As %String, SupplierId As %String, ProductCode As %String, GroupCode As %String, productGroupCode As %String, HospitalCode As %String, CliDep As %String, TansFormType As %String, USERCODE As %String, Diagnose As %String) As %Query(ROWSPEC = "patName:%String,patSex:%String,patAge:%String,patRegNo:%String,patMedicare:%String,CliDepDesc:%String,patWardDesc:%String,lstSaveUserDesc:%String,patDiagnos:%String,RBC1:%String,RBC2:%String,FFP1:%String,FFP2:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

ClassMethod GetAppFormInfo(appFormID As %String, labdata = "", meddata = "", CliDep, HospitalCode, Ward) As %String
{
    S appFormID=$G(appFormID),labdata=$G(labdata),CliDep=$G(CliDep),HospitalCode=$G(HospitalCode)
    S ret="",deli=$C(2),AppFormInfo="",TempRes=""
    Q:'$L(appFormID) ret
    Q:'$D(^DHCBLDAPPFORM(appFormID)) ret
    S:'$L(labdata) labdata=##Class(LIS.Core.Util).GetLabDataNS()
    S:'$L(meddata) meddata=##Class(LIS.Core.Util).GetDataNS()
    S CurNameSpace=$ZUTIL(5)
    K ^TMP($ZN,$J,"OEORD")
    ZN meddata
    S appFormBasicData=$$GetAppFormBasicInfo^DHCUtlBldAppForm(appFormID)
    S patBasicData=$$GetPatInfo^DHCUtlBldAppFormCore(appFormID,"")
    S ordersData=$$GetAllOrders^DHCUtlBldAppForm(appFormID,"","")
    ZN CurNameSpace
    S patRegNo=$P(patBasicData,deli,1)
    ;Q:patRegNo'="0001221873" ret
    S patSex=$P(patBasicData,deli,5)
    S patName=$P(patBasicData,deli,6)
    S patBed=$P(patBasicData,deli,8)
    S patAge=$P(patBasicData,deli,10)
    S patWardDesc=$P(patBasicData,deli,11)
    S patTypeDesc=$P(patBasicData,deli,18)
    S patDiagnos=$P(patBasicData,deli,21)
    S lstSaveUserCode=$P(appFormBasicData,deli,19)
    S lstSaveUserDesc=$P(appFormBasicData,deli,20)
    S patMedicare=$P(patBasicData,deli,35)
    S appFormID=$P(appFormBasicData,deli,1)
    S patType=$P(patBasicData,deli,17)  ;得到开医嘱的登陆科室
    S patLocDr=$P(patBasicData,deli,24)  ;得到开医嘱的登陆科室ID
    S patWard=$P(patBasicData,deli,25)  ;得到开医嘱的病区
    s CurHospitalCode="",HospID=""
    S patLocCode=""
    I $L(patLocDr) D
    .I $D(^CTLOC(patLocDr)) S patLocCode=$P(^CTLOC(patLocDr),"^",1)
    I $L(CliDep),$L(patLocCode),patLocCode'=CliDep Q ret
    I $L(Ward),$L(patWard),patWard'=Ward Q ret
    I $L(patLocDr) S HospID=$P(^CTLOC(patLocDr),"^",22)
    I $L(HospID) S CurHospitalCode=$p(^CT("HOSP",HospID),"^",1)
    I $L(HospitalCode),$L(CurHospitalCode),CurHospitalCode'=HospitalCode Q ret
	S CliDepDesc=$P(^CTLOC(patLocDr),"^",2)
	S fieldDeli=$C(3),recordDeli=$C(2)
    S bldBankProc="",proGrpDesc=""
    S (ordersDesc,ordersVolume,ordersUnit,labno,labRowIDs,OrderInfo,bldProductInfo)=""
    F i=1:1:$L(ordersData,recordDeli) {
	    S order=$P(ordersData,recordDeli,i)
	    Continue:'$L(order)
	    S orderRowID=$P(order,fieldDeli,1)
	    S labRowID=##Class(web.DHCBldStatOverTransRecord).GetOrderLabRowID(orderRowID)
	    S:$L(labRowID) labRowIDs=labRowIDs_labRowID_","
	    S orderDesc=$P(order,fieldDeli,2)
	    Continue:orderDesc["血型复检"
	    S:orderDesc["红细胞" proGrpDesc="RC"
        S:orderDesc["血小板" proGrpDesc="PLT"
    	S:orderDesc["血浆" proGrpDesc="FFP"
    	S:orderDesc["冷沉淀" proGrpDesc="CRYO"
    	S:orderDesc["全血" proGrpDesc="WB"
	    S ordervolume=+$P(order,fieldDeli,6)
	    S unit=$P(order,fieldDeli,7)
	    Continue:(unit="次")
	    I '$D(^TMP($ZN,$J,"OEORD",proGrpDesc)){
			S ^TMP($ZN,$J,"OEORD",proGrpDesc)=ordervolume
	    }ELSE {
		    S ^TMP($ZN,$J,"OEORD",proGrpDesc)=+^TMP($ZN,$J,"OEORD",proGrpDesc)+ordervolume
		}		
	}
	S bldProductInfo=..GetTransBldProducts(labRowIDs,labdata,proGrpDesc)
	S AppFormInfo=patName_deli_patSex_deli_patAge_deli_patRegNo_deli_patMedicare_deli_CliDepDesc_deli_patWardDesc_deli_lstSaveUserDesc_deli_patDiagnos_deli_patType_deli_patLocDr_deli_patWard
	S BPG=0,num=1
	F j=1:1:$L(bldProductInfo,",") {
		S TempStr=$P(bldProductInfo,",",j)
		S TempBpg=$P(TempStr,"\",1),TempTransVol=+$P(TempStr,"\",2)
		Continue:'$L(TempBpg)
		Continue:'$D(^TMP($ZN,$J,"OEORD",TempBpg))
		S ordervolume=+$G(^TMP($ZN,$J,"OEORD",TempBpg))
	    S TempRes=TempRes_TempBpg_"\"_ordervolume_"\"_TempBpg_"\"_TempTransVol_","
	}
	S:$L(TempRes) ret=AppFormInfo_"#"_TempRes
	Q ret
}

ClassMethod GetTransBldProducts(labRowIDs As %String, labdata As %String, proGrpDesc) As %String
{
    S labRowIDs=$G(labRowIDs),labdata=$G(labdata),proGrpDesc=$G(proGrpDesc)
    S:'$L(labdata) labdata="labdata"
    S ret="",TransInfo=""
    K ^TMP($ZN,$J,"PROGRP")
    S bldProductDesc="",bldProductVolume="",bldProductUnit=""
    F i=1:1:$L(labRowIDs,",") {
		S labRowID=$P(labRowIDs,",",i)
		Continue:'$L(labRowID)
		S labno=$P(labRowID,"||",1)
		S tsCode=$P(labRowID,"||",2)
		S tsCnt=$P(labRowID,"||",3)
		Continue:('$L(labno))||('$L(tsCode))||('$L(tsCnt)) 
		S packMainID=""
		F {
			S packMainID=$O(^|labdata|TEPI(labno,1,tsCode,tsCnt,"BBP",packMainID))
			Q:'$L(packMainID)
			S packSubID=""
			F {
				S packSubID=$O(^|labdata|TEPI(labno,1,tsCode,tsCnt,"BBP",packMainID,packSubID))
				Q:'$L(packSubID)
				S packData=$G(^|labdata|TBBP(packMainID,packSubID))
				S packStatus=$P(^|labdata|TEPI(labno,1,tsCode,tsCnt,"BBP",packMainID,packSubID),"\",3)
				//Continue:packStatus'="T"
				S storeStatus=$P(packData,"\",3)
				//Continue:storeStatus'="OUT"
				S bldProCode=$P(packData,"\",4)
				I $L(bldProCode),$D(^TTAB("BB-BP",bldProCode)) S ProductGroop=$P(^TTAB("BB-BP",bldProCode),"\",21)
				;W ProductGroop,!
				;Continue:ProductGroop'=ProductGroop
				S bldProdDesc="",bldProUnit=""
				I $L(bldProCode) { 
					S bldProdDesc=$P($G(^|labdata|TTAB("BB-BP",bldProCode)),"\",1)
					S bldProUnit=$P($G(^|labdata|TTAB("BB-BP",bldProCode,"REM",1)),"&",1)
				}
				S bldProBldGrpID=$P(packData,"\",5)
				S bldProBldGrpDesc=""
				S:$L(bldProBldGrpID) bldProBldGrpDesc=$P($G(^|labdata|TTAB("BB-BG",bldProBldGrpID)),"\",1)
				S bldProVolume=$P(packData,"\",21)
				I packStatus'="T" S bldProVolume=0
				I storeStatus'="OUT" S bldProVolume=0
				I '$D(^TMP($ZN,$J,"PROGRP",ProductGroop)){
						S ^TMP($ZN,$J,"PROGRP",ProductGroop)=bldProVolume
				}ELSE{
					    S ^TMP($ZN,$J,"PROGRP",ProductGroop)=+^TMP($ZN,$J,"PROGRP",ProductGroop)+bldProVolume
				}
			}	
		}
	}
	S pbg=""
	F {
		S pbg=$O(^TMP($ZN,$J,"PROGRP",pbg))
	    Q:'$L(pbg)
		S Vol=+$G(^TMP($ZN,$J,"PROGRP",pbg))
		S TransInfo=TransInfo_pbg_"\"_Vol_","	
	}
	S:$L(TransInfo) ret=TransInfo
	Q ret
}

ClassMethod GetDiagnosisICD(admID As %String) As %String
{
	S admID=$G(admID)
	S GetDiagnosisID=..GetMRAdmID(admID)
	S GetDiagnosisICD=..GetDiagnosisICDCode(GetDiagnosisID)
	Q GetDiagnosisICD
}

ClassMethod GetMRAdmID(admID As %String) As %String
{
	S admID=$G(admID)
	Q:'$L(admID) ""
    Q $P($G(^PAADM(admID)),"^",61)
}

ClassMethod GetDiagnosisICDCode(MRAdmID As %String) As %String
{
	//^MRC("DTYP",2)	=	"M^主诊断^N"
	S MRAdmID=$G(MRAdmID)
	S ret=""
    Q:'$L(MRAdmID) ret
    I '$D(^MR(MRAdmID,"DIA",1)) Q ret
    S ICDDR=$P(^MR(MRAdmID,"DIA",1),"^",1)
    S ICDCode=$P(^MRC("ID",ICDDR),"^",1)
    S ret=ICDCode
    //W ret,!
    Q ret
}

Storage Default
{
<Data name="DHCBldStatByDiagnoseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatByDiagnoseD</DataLocation>
<DefaultData>DHCBldStatByDiagnoseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatByDiagnoseD</IdLocation>
<IndexLocation>^web.DHCBldStatByDiagnoseI</IndexLocation>
<StreamLocation>^web.DHCBldStatByDiagnoseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
