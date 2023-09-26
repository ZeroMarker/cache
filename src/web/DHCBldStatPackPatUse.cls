Class web.DHCBldStatPackPatUse Extends %Persistent
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
/// D ##class(%ResultSet).RunQuery("web.DHCBldStatPackPatUse","QuerySampleStatistics","2014-11-01","2014-11-11","","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, Debtor As %String, PatName As %String, PatType As %String, HospitalCode As %String, USERCODE As %String, CliDep As %String, Condition2 As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  //Condition2 血成份
  S ^TMP("xq")=DateS_","_DateE_","_Debtor_","_PatType_","_PatName_","_HospitalCode_","_USERCODE_","_Condition2
  I '$L(DateS) S qHandle=$lb(0,repid,0) Q $$$OK
  I '$L(DateE) S qHandle=$lb(0,repid,0) Q $$$OK
  S TimeS=""
  S TimeE=""
  I $L(DateS) S TimeS=$P(DateS," ",2),DateS=$P(DateS," ",1)
  I $L(DateE) S TimeE=$P(DateE," ",2),DateE=$P(DateE," ",1)
  I $L(TimeS) S TimeS=$ZTH(TimeS,1)
  I $L(TimeE) S TimeE=$ZTH(TimeE,1)
  I $L(USERCODE) S USERCODE="demo"
  //S HospitalCode=""
  //S HospitalCode=$O(^TTABi("CC",1,""))
  //S HospitalCode="QYFYZY"
  S HospitalCode=$G(HospitalCode)
  S HospitalDesc=""
  I CliDep="null" S CliDep=""
  I $L(HospitalCode) S HospitalDesc=$P(^TTAB("CC",HospitalCode),"\",1)
  s DateS=$G(DateS),DateE=$G(DateE),sLabNameSpace=$G(sLabNameSpace),HospitalCode=$G(HospitalCode)
  S Condition2=$G(Condition2)
  S DateS=$ZDH(DateS,3)
  S DateE=$ZDH(DateE,3)
  K ^TMP($zn,$j)
  //I status="ALL" s status=""
  S row=0
  S del=$c(28)
  F iDate=DateS:1:DateE D
  .S iTime=""  F  S iTime=$O(^TBBPi("TR-DateTime",iDate,iTime))  Q:iTime=""  D
  ..I (DateS=iDate),(TimeS>iTime) Q
  ..I (DateE=iDate),(TimeE<iTime) Q
  ..S PackID=""  F  S PackID=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID))  Q:PackID=""  D
  ...S SecondId=""  F  S SecondId=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID,SecondId))  Q:SecondId=""  D
  ....;-----多医院-------->
  ....S BPCode=$P($G(^TBBP(PackID,SecondId)),"\",4),CurHospitalCode=""
  ....I $L(BPCode) s CurHospitalCode=$P(^TTAB("BB-BP",BPCode),"\",11)
  ....I $L(HospitalCode),$L(CurHospitalCode),CurHospitalCode'=HospitalCode Quit
  ....//i $L(HospitalCode),'$L(CurHospitalCode),'$D(^TTABi("CC",1,HospitalCode)) Quit
  ....;------------------<
  ....S Sequence=""  F  S Sequence=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID,SecondId,Sequence))  Q:Sequence=""  D
  .....I $D(^TMP($zn,$j,"PatUse",PackID,SecondId)) D
  ......S zz=^TMP($zn,$j,"PatUse",PackID,SecondId)
  ......I Sequence>zz s ^TMP($zn,$j,"PatUse",PackID,SecondId)=Sequence
  .....E  D
  ......S ^TMP($zn,$j,"PatUse",PackID,SecondId)=Sequence
  S PackID=""  F  S PackID=$O(^TMP($zn,$j,"PatUse",PackID))  Q:PackID=""  D
  .S SecondId=""  F  S SecondId=$O(^TMP($zn,$j,"PatUse",PackID,SecondId))  Q:SecondId=""  D
  ..S (donorName,Units,InputPrice,BloodPtDesc,BloodGPDesc,SupDesc,PackVolume,OutType)=""
  ..S (ep,TestSet,TestCount,DepDesc,paientname,doctor,standvalue1,standvalue2,standvalue3,XMUser,IssUser)=""
  ..;删除的血袋处理
  ..I '$D(^TBBP(PackID,SecondId)) Q
  ..I ($D(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId))),($P(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId),"\",6)="Y") Q  
  ..S Sequence=^TMP($zn,$j,"PatUse",PackID,SecondId)
  ..S BPStatus=$P(^TBBP(PackID,SecondId),"\",2)
  ..I BPStatus="ISS" Q
  ..S sStock=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",8)
  ..S IssDate=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",2)
  ..S IssTime=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",3)
  ..S IssDT=""
  ..I $L(IssDate),$L(IssTime) D
  ...S IssDate=$ZD(IssDate,3)
  ...S IssTime=$ZT(IssTime,2)
  ...S IssDT=IssDate_" "_IssTime
  ..S statusDesc=$P(^TTAB("BB-ST",sStock),"\",1)
  ..//I $L(status),sStock'=status Q
  ..S BloodProduct=$P(^TBBP(PackID,SecondId),"\",4)
  ..S BloodGroup=$P(^TBBP(PackID,SecondId),"\",5)
  ..S (BloodPtDesc,ProductGroup,ProductGroupDesc)=""
  ..I $L(BloodProduct) s BloodPtDesc=$P(^TTAB("BB-BP",BloodProduct),"\",1)
  ..I $L(BloodProduct) s ProductGroup=$P(^TTAB("BB-BP",BloodProduct),"\",21)
  ..I $L(Condition2),Condition2'=ProductGroup Q
  ..I $L(ProductGroup) s ProductGroupDesc=$P(^TTAB("BB-PG",ProductGroup),"\",1)
  ..I $L(BloodGroup) s BloodGPDesc=$P(^TTAB("BB-BG",BloodGroup),"\",1)
  ..//I (ProductCode'="")&(ProductCode'=BloodProduct) Q
  ..//I (GroupCode'="")&(GroupCode'=BloodGroup) Q
  ..S PackVolume=$P(^TBBP(PackID,SecondId),"\",21)
  ..S SupCode=$P(^TBBP(PackID,SecondId),"\",12)
  ..I SupCode'="" s SupDesc=$P(^TTAB("BB-SUP",SupCode),"\",1)
  ..//I (supid'="")&(supid'=SupCode) Q
  ..S Units=""
  ..I $D(^TTAB("BB-BP",BloodProduct,"REM",1)),$L(^TTAB("BB-BP",BloodProduct,"REM",1)) s Units=$P(^TTAB("BB-BP",BloodProduct,"REM",1),"&")
  ..S:$D(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId)) InputPrice=$P(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId),"\",1)
  ..S:$D(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId)) donorName=$P(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId),"\",2)  ;献血者
  ..S ptdate=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",2)
  ..S pttime=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",3)
  ..S SplitOutTrans=""  ;拆分出库
  ..I $D(^[sLabNameSpace]DHCLabParameter(0,"PackTrans","BloodTrans")) D
  ...S SplitOutTrans=$P(^[sLabNameSpace]DHCLabParameter(0,"PackTrans","BloodTrans"),"\",3)
  ..I $P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",1)=SplitOutTrans D 
  ...S OutType="拆分出库"
  ..I $P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",1)=SplitOutTrans Q
  ..I $$CT012(PackID_"||"_SecondId)'="" D
  ...S OutType="正常出库"
  ..E  D
  ...;s OutType="非正常出库"  ^TBBP("=0160213016965","=<P0065V00 2","TRAN",3)
  ...S OutType=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",1)
  ...I $L(OutType),OutType="TRANS5" S OutType="库存转移"
  ...I $L(OutType),OutType="TRANS2" S OutType="非正常出库"
  ..S aiDate=""
  ..S VisitNumber=$P($P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",11),"||",1)
  ..S TestSet=$P($P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",11),"||",2)
  ..S TestCount=$P($P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",11),"||",3)
  ..I '$L(VisitNumber) Q
  ..I '$D(^TEPI(VisitNumber,1,TestSet,TestCount,"BBP",PackID,SecondId)) Q
  ..S BldPatOutType=$P(^TEPI(VisitNumber,1,TestSet,TestCount,"BBP",PackID,SecondId),"\",3)
  ..I BldPatOutType'="T" Q
  ..S loccode=$P(^TEPI(VisitNumber),"\",36)
  ..I $L(CliDep),CliDep'=loccode Q
  ..S PatientName=$P(^TEPI(VisitNumber),"\",1)
  ..I $L(PatName),PatientName'=PatName Q
  ..S PatDebtor=$P(^TEPI(VisitNumber),"\",18)
  ..I $L(Debtor),Debtor'=PatDebtor Q
  ..S Sex=$P(^TEPI(VisitNumber),"\",3)
  ..I Sex="M" S Sex="男"
  ..I Sex="F" S Sex="女"
  ..S Age=##class(web.DHCLabCommonUse).AgeOut(##class(web.DHCLabCommonUse).GetPatAge(VisitNumber))
  ..I loccode'="",$D(^TTAB("USLOC",loccode)) s DepDesc=$P($G(^TTAB("USLOC",loccode)),"\",1)
  ..I DepDesc["-" s DepDesc=$P(DepDesc,"-",2)
  ..S paientname=$P(^TEPI(VisitNumber),"\",1)
  ..S doctor=$P(^TEPI(VisitNumber),"\",18)
  ..;主,次交叉
  ..I $D(^[sLabNameSpace]DHCVisitTSBBPacksInfo(VisitNumber,1,TestSet,TestCount,"BBP",PackID,SecondId)) D
  ...S IssUserID=$P(^[sLabNameSpace]DHCVisitTSBBPacksInfo(VisitNumber,1,TestSet,TestCount,"BBP",PackID,SecondId),"\",1) ;发血者
  ...I IssUserID'="" s IssUser=$P(^[sLabNameSpace]SSU("SSUSR",1,IssUserID),"^",2)
  ...S XMUserID=$P(^[sLabNameSpace]DHCVisitTSBBPacksInfo(VisitNumber,1,TestSet,TestCount,"BBP",PackID,SecondId),"\",4)  ;配血者
  ...I XMUserID'="" s XMUser=$P(^[sLabNameSpace]SSU("SSUSR",1,XMUserID),"^",2)                                  
  ..//I $L(Debtor),$L(doctor),doctor'=Debtor Q
  ..//Set PatBldGrp=$$GetPatBldGrp(doctor)
  ..//S aiDate=DepDesc_del_paientname_del_doctor_del_standvalue1_del_standvalue2_del_standvalue3_del_XMUser_del_IssUser_del_VisitNumber_del_PatBldGrp
  ..//S stemp=PackID_"||"_SecondId_del_BloodPtDesc_del_BloodGPDesc_del_SupDesc_del_PackVolume_del_Units
  ..S PackRowID=PackID_"||"_SecondId
  ..S DonorsNumber=""
  ..//扩充字段Field1发血时间
  ..S (Field1,Field2,Field3,Field4,Field5)=""
  ..S Field1=IssDT
  ..S Field5=HospitalDesc
  ..S Data=$lb(PackRowID,BloodPtDesc,PatientName,PatDebtor,Sex,Age,DepDesc,BloodGPDesc,DonorsNumber,ProductGroupDesc,PackVolume,Field1,Field2,Field3,Field4,Field5)
  ..D Output
  K ^TMP($zn,$j)
  S qHandle=$lb(0,repid,0)
  Q $$$OK
CT012(rowid)  s rowid=$G(rowid),x1=$P(rowid,"||",1),x2=$P(rowid,"||",2),result=""
 I $L(x1),$L(x2) D
 S x3="" F  S x3=$O(^TBBP(x1,x2,"TRAN",x3),-1) Q:x3=""  I $P(^TBBP(x1,x2,"TRAN",x3),"\",10)'="Y" S result=$P(^TBBP(x1,x2,"TRAN",x3),"\",7) Q
 Q result
Output
	S Data=$lb(PackRowID,BloodPtDesc,PatientName,PatDebtor,Sex,Age,DepDesc,BloodGPDesc,DonorsNumber,ProductGroupDesc,PackVolume,Field1,Field2,Field3,Field4,Field5)
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
 	ElsE      
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
Query QuerySampleStatistics(DateS As %String, DateE As %String, Debtor As %String, PatName As %String, PatType As %String, HospitalCode As %String, USERCODE As %String, CliDep As %String, Condition2 As %String) As %Query(ROWSPEC = "PackRowID:%String,BloodPtDesc:%String,PatientName:%String,PatDebtor:%String,Sex:%String,Age:%String,DepDesc:%String,BloodGPDesc:%String,DonorsNumber:%String,ProductGroupDesc:%String,PackVolume:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCBldStatPackPatUseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatPackPatUseD</DataLocation>
<DefaultData>DHCBldStatPackPatUseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatPackPatUseD</IdLocation>
<IndexLocation>^web.DHCBldStatPackPatUseI</IndexLocation>
<StreamLocation>^web.DHCBldStatPackPatUseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
