Class web.DHCBldStatDisPatient Extends %Persistent
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
/// D ##class(%ResultSet).RunQuery("web.DHCBldStatDisPatient","QuerySampleStatistics","2014-12-01 09:19:03","2014-12-15 09:19:03","","","QYFYZY","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, Debtor As %String, AdmID As %String, HospitalCode As %String, USERCODE As %String, CliDep As %String, Condition1 As %String, Condition2 As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  I CliDep="null" S CliDep=""
  S ^TMP("xq")=$lb(DateS,DateE,Debtor,AdmID,HospitalCode,CliDep,Condition1)
  I '$L(DateS) S qHandle=$lb(0,repid,0) Q $$$OK
  I '$L(DateE) S qHandle=$lb(0,repid,0) Q $$$OK
  I CliDep="null" S CliDep=""
  S TimeS=""
  S TimeE=""
  I $L(DateS) S TimeS=$P(DateS," ",2),DateS=$P(DateS," ",1)
  I $L(DateE) S TimeE=$P(DateE," ",2),DateE=$P(DateE," ",1)
  I $L(TimeS) S TimeS=$ZTH(TimeS,1)
  I $L(TimeE) S TimeE=$ZTH(TimeE,1)
  I $L(USERCODE) S USERCODE="demo"
  S HospitalCode=$g(HospitalCode)
  S HospitalDesc=""
  I $L(HospitalCode) S HospitalDesc=$P(^TTAB("CC",HospitalCode),"\",1)
  s DateS=$g(DateS),DateE=$g(DateE),sLabNameSpace=$g(sLabNameSpace),HospitalCode=$G(HospitalCode)
  S Condition1=$G(Condition1),Condition2=$G(Condition2)
  S DateS=$ZDH(DateS,3)
  S DateE=$ZDH(DateE,3)
  S Debtor=$G(Debtor),AdmID=$G(AdmID)
  K ^TMP($zn,$j)
  S vbTab=$c(9)
  b ;111
  F Date=DateS:1:DateE D
  .S AdmId="" F  S AdmId=$O(^PAADMi("DisDateT","I",Date,AdmId)) q:AdmId=""  d
  ..S DisDate=$ZD(Date,3)
  ..S AdmDocDr=$p(^PAADM(AdmId),"^",9)
  ..S AdmDate=$p(^PAADM(AdmId),"^",6)
  ..S AdmTime=$p(^PAADM(AdmId),"^",7)
  ..S (CurHospitalCode,locID,locCode,HospID)=""
  ..I $l(AdmId),$d(^PAADM(AdmId)) s locID=$p(^PAADM(AdmId),"^",4)
  ..I $l(locID) s HospID=$p(^CTLOC(locID),"^",22),locCode=$p(^CTLOC(locID),"^",1)
  ..I $L(CliDep),CliDep'=locCode Q
  ..I $l(HospID) s CurHospitalCode=$p(^CT("HOSP",HospID),"^",1)
  ..I $l(HospitalCode),$l(CurHospitalCode),CurHospitalCode'=HospitalCode q 
  ..;I $l(HospitalCode),'$l(CurHospitalCode),'$d(^TTABi("CC",1,HospitalCode)) q
  ..;<--------------------------
  ..S WardDr=$p(^PAADM(AdmId),"^",70)
  ..S WardDr=##class(web.DHCBldCommonUse).GetWardDesc(WardDr)
  ..S PapmiDr=$p(^PAADM(AdmId),"^",1)
  ..I $L(AdmID),$L(PapmiDr),PapmiDr'=AdmID Q
  ..S Name=$p(^PAPER(PapmiDr,"ALL"),"^",1)
  ..S SexDr=$p(^PAPER(PapmiDr,"ALL"),"^",7)
  ..S:SexDr="1" SexDr="男"
  ..S:SexDr="2" SexDr="女"
  ..S DOB=$p(^PAPER(PapmiDr,"ALL"),"^",6)
  ..S DOB=##class(web.DHCLabCommonUse).GetPatAgeByAdm(AdmId)
  ..S AGE=$P(DOB,$C(1),1)
  ..S Units=$P(DOB,$C(1),2)
  ..S:Units="0" DOB=AGE_" 岁"
  ..S:Units="1" DOB=AGE_" 月"
  ..S:Units="2" DOB=AGE_" 天"
  ..S:Units="3" DOB=AGE_" 小时"
  ..S debtor=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
  ..I debtor="0000000412" b ;21
  ..I $L(Debtor),$L(debtor),debtor'=Debtor Q
  ..;<------------------------  ADD  BY  MCR   20140117
  ..S diagDesc=##Class(LIS.Core.Patient).GetDiagnosis(AdmId)
  ..;<------------------------  ADD  BY  MCR   20140117
  ..D OrderNew(AdmId)
  ..S str=debtor_$c(2)_Name_$c(2)_SexDr_$c(2)_DOB_$C(2)_diagDesc_$c(2)_WardDr_$C(2)_DisDate  //_PapmiDr_$c(2)_AdmDate_$c(2)_AdmTime_
  ..S ^TMP($zn,$j,"ADM",Date,AdmId)=str
  S num=0
  S Date=""
  F  S Date=$O(^TMP($zn,$j,"ADM",Date)) Q:'$L(Date)  D
  .S AdmId="" F  S AdmId=$O(^TMP($zn,$j,"ADM",Date,AdmId)) Q:AdmId=""  D
  ..S str=^(AdmId)
  ..S str=$tr(str,$c(2),vbTab)
  ..S tBPGList=""
  ..S DisDate=$P(str,$C(9),7) 
  ..S bpg="" F  S bpg=$O(^TMP($zn,$j,"ADM",AdmId,bpg)) Q:bpg=""  D
  ...S tBPGList=tBPGList_bpg_"\"_$g(^TMP($zn,$j,"ADM",AdmId,bpg))_","
  ..Q:'$L(tBPGList)
  ..S tBPGList=$$BuildOutPutSeq(tBPGList)
  ..I $l(tBPGList) D
  ...S num=num+1,^TMP($zn,$j,"DATA",num)=num_vbTab_str_vbTab_tBPGList 
  ...S debtor=$P(str,vbTab,1)
  ...S patName=$P(str,vbTab,2)
  ...S sex=$P(str,vbTab,3)
  ...S age=$P(str,vbTab,4)
  ...S dianog=$P(str,vbTab,5)
  ...S ward=$P(str,vbTab,6)
  ...S RBC=$P(tBPGList,vbTab,1)
  ...S FFP=$P(tBPGList,vbTab,2)
  ...S PLT=$P(tBPGList,vbTab,3)
  ...S CRYO=$P(tBPGList,vbTab,4)
  ...//备用字段Field1用作出院日期
  ...S Field1=DisDate
  ...S Field2=""
  ...S Field3=""
  ...S Field4=""
  ...S Field5=HospitalDesc
  ...S Data=$lb(num,debtor,patName,sex,age,dianog,ward,RBC,FFP,PLT,CRYO,Field1,Field2,Field3,Field4,Field5)
  ...d Output
  S P8="序号|登记号|姓名|性别|年龄|诊断|病区|红细胞量(U)|血浆量(ML)|血小板量(治疗量)|冷沉淀量(U)"
  S P9="900|1000|1200|900|1200|1600|1600|1300|1300|2000|1300"
  K ^TMP($zn,$j)
  S qHandle=$lb(0,repid,0)
  Q $$$OK
OrderNew(AdmId)  s AdmId=$g(AdmId)
  S OrdId="" F  S OrdId=$O(^OEORD(0,"Adm",AdmId,OrdId)) Q:OrdId=""  D
  .S OrdSubId="" F  S OrdSubId=$O(^OEORDi(0,"LabNotRead",OrdId,OrdSubId)) Q:OrdSubId=""  D
  ..S TSRow=$P(^OEORD(OrdId,"I",OrdSubId,3),"^",35)
  ..Q:'$l(TSRow)
  ..S labno=$p(TSRow,"||",1)
  ..S TS=$p(TSRow,"||",2)
  ..S TSCnt=$p(TSRow,"||",3)
  ..Q:'$l(TS) 
  ..Q:'$D(^TTAB("TS",TS,"XM")) 
  ..S PackId="" F  S PackId=$O(^TEPI(labno,1,TS,TSCnt,"BBP",PackId)) Q:PackId=""  D
  ...S SubId="" F  S SubId=$O(^TEPI(labno,1,TS,TSCnt,"BBP",PackId,SubId)) Q:SubId=""  D
  ....S PackStr=$g(^TBBP(PackId,SubId))
  ....S XMStus=$g(^TEPI(labno,1,TS,TSCnt,"BBP",PackId,SubId))
  ....S PackStus=$p(XMStus,"\",3)
  ....I PackStus'="T" Q  
  ....S PackTSId=$p(PackStr,"\",11)
  ....I PackTSId'=TSRow Q
  ....S ProductDr=$p(PackStr,"\",4)
  ....S Vol=+$p(PackStr,"\",21)
  ....S ProdGrp=""
  ....I '$l(ProdGrp) s ProdGrp=ProductDr
  ....I $D(^TTAB("BB-BP",ProdGrp)) S bpg=$P(^TTAB("BB-BP",ProdGrp),"\",21)
  ....I bpg["RC"  D 
  .....;W "AdmId="_AdmId,"PackId="_PackId,"SubId="_SubId,!
  ....I '$D(^TMP($zn,$j,"ADM",AdmId,bpg)) D
  .....S ^TMP($zn,$j,"ADM",AdmId,bpg)=Vol
  ....E  D
  .....S ^TMP($zn,$j,"ADM",AdmId,bpg)=+$G(^TMP($zn,$j,"ADM",AdmId,bpg))+Vol
  Q
BuildOutPutSeq(tBPGList) 
	S tBPGList=$G(tBPGList)
	S res="",vbTab=$c(9),Vol=""
	I tBPGList["RC" D
	.F i=1:1:$L(tBPGList,",")  D
	..S temRes=$P(tBPGList,",",i)
	..S bgg=$P(temRes,"\",1)
	..Q:bgg'="RC"
	..S res=$P(temRes,"\",2)_vbTab
	E  D
	.S res=Vol_vbTab

	I tBPGList["FFP" D
	.F j=1:1:$L(tBPGList,",")  D
	..S temRes=$P(tBPGList,",",j)
	..S bgg=$P(temRes,"\",1)
	..Q:bgg'="FFP"
	..S res=res_$P(temRes,"\",2)_vbTab
	E  D
	.S res=res_Vol_vbTab

	I tBPGList["PLT" D
	.F k=1:1:$L(tBPGList,",")  D
	..S temRes=$P(tBPGList,",",k)
	..S bgg=$P(temRes,"\",1)
	..Q:bgg'="PLT"
	..S res=res_$P(temRes,"\",2)_vbTab
	E  D
	.S res=res_Vol_vbTab
	I tBPGList["CRYO" D
	.F l=1:1:$L(tBPGList,",")  D
	..S temRes=$P(tBPGList,",",l)
	..S bgg=$P(temRes,"\",1)
	..Q:bgg'="CRYO"
	..S res=res_$P(temRes,"\",2)_vbTab
	E  D
	.S res=res_Vol_vbTab
	Q res
   
Output
	S Data=$lb(num,debtor,patName,sex,age,dianog,ward,RBC,FFP,PLT,CRYO,Field1,Field2,Field3,Field4,Field5)
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
Query QuerySampleStatistics(DateS As %String, DateE As %String, Debtor As %String, AdmID As %String, HospitalCode As %String, USERCODE As %String, CliDep As %String, Condition1 As %String, Condition2 As %String) As %Query(ROWSPEC = "num:%String,debtor:%String,patName:%String,sex:%String,age:%String,dianog:%String,ward:%String,RBC:%String,FFP:%String,PLT:%String,CRYO:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCBldStatDisPatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatDisPatientD</DataLocation>
<DefaultData>DHCBldStatDisPatientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatDisPatientD</IdLocation>
<IndexLocation>^web.DHCBldStatDisPatientI</IndexLocation>
<StreamLocation>^web.DHCBldStatDisPatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
