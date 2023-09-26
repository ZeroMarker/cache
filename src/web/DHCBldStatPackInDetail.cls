Class web.DHCBldStatPackInDetail Extends %Persistent
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
/// D ##class(%ResultSet).RunQuery("web.DHCBldStatPackInDetail","QuerySampleStatistics","2014-12-08","2014-12-11","","","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, PackID As %String, SupplierId As %String, ProductCode As %String, GroupCode As %String, productGroupCode As %String, BGFlag As %String, USERCODE As %String, HospitalCode As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  I '$L(DateS) S qHandle=$lb(0,repid,0) Q $$$OK
  I '$L(DateE) S qHandle=$lb(0,repid,0) Q $$$OK
  S TimeS=""
  S TimeE=""
  I $L(DateS) S TimeS=$P(DateS," ",2),DateS=$P(DateS," ",1)
  I $L(DateE) S TimeE=$P(DateE," ",2),DateE=$P(DateE," ",1)
  I $L(TimeS) S TimeS=$ZTH(TimeS,1)
  I $L(TimeE) S TimeE=$ZTH(TimeE,1)
  I '$L(USERCODE) S USERCODE="demo"
  I ProductCode="null" S ProductCode=""
  I GroupCode="null" S GroupCode=""
  I productGroupCode="null" S productGroupCode=""
  S ^TMP("xq1")=DateS_","_DateE_","_SupplierId_","_ProductCode_","_GroupCode_","_productGroupCode
  S HospitalCode=$G(HospitalCode)
  S HospitalDesc=""
  //S HospitalCode=$O(^TTABi("CC",1,""))
  I $L(HospitalCode) S HospitalDesc=$P(^TTAB("CC",HospitalCode),"\",1)
  k ^TMP($zn,$j)
  S HospitalCode=$g(HospitalCode)
  S DateS=$ZDH(DateS,3)
  S DateE=$ZDH(DateE,3)
  S del=$c(28)
  S ProductCode=$tr(ProductCode," ")
  S PackID=$TR($TR(PackID," "),$C(13))
  S GroupCode=$tr(GroupCode," ")
  S j=0
  F iDate=DateS:1:DateE D
  .S iTime=""  F  S iTime=$O(^TBBPi("DateTimeRec",iDate,iTime))  Q:iTime=""  D
  ..I (iDate=DateS)&(iTime<TimeS) Q
  ..I (iDate=DateE)&(iTime>TimeE) Q
  ..S packid=""  F  S packid=$O(^TBBPi("DateTimeRec",iDate,iTime,packid))  Q:packid=""  D
  ...S subid=""  F  S subid=$O(^TBBPi("DateTimeRec",iDate,iTime,packid,subid))  Q:subid=""  D
  ....S (DonorName,sBloodProduct,BloodPtDesc,sBloodGroup,BloodGPDesc,PackVolume,SupCode,SupDesc,DateOfCollection,Patientdebtor)=""
  ....S (StatusRes,ParentPack,Location,Visitts,DateExpired,UserRec,StatusCode,StatusDesc,StatusStock,Donordebtor)=""
  ....;删除的血袋处理
  ....I $L(PackID),PackID'=packid Q
  ....I '$D(^TBBP(packid,subid)) Q
  ....I ($D(^[sLabNameSpace]Dhcbbpackprice(packid,subid))),($P(^[sLabNameSpace]Dhcbbpackprice(packid,subid),"\",6)="Y") Q  
  ....S sBloodProduct=$P(^TBBP(packid,subid),"\",4)
  ....I sBloodProduct'="" S BloodPtDesc=$P(^TTAB("BB-BP",sBloodProduct),"\",1)
  ....;-----多医院-------->
  ....S BPCode=$P($g(^TBBP(packid,subid)),"\",4),CurHospitalCode=""
  ....///血制品代码和血袋id一起作为血袋唯一标示 20111215 huhm
  ....//s BPBarcode=subid
  ....//s BloodType=$P(^TBBP(packid,subid),"\",40)
  ....//i $L(BloodType) S BPBarcode=BloodType
  ....S BPBarcode=$P($$GetPackRowId(packid,subid),"||",2)
  ....///
  ....I $L(BPCode) S CurHospitalCode=$P(^TTAB("BB-BP",BPCode),"\",11)
  ....I $L(HospitalCode),$L(CurHospitalCode),CurHospitalCode'=HospitalCode Q
  ....I $L(HospitalCode),'$L(CurHospitalCode),'$D(^TTABi("CC",1,HospitalCode)) Q
  ....;------------------<
  ....S sBloodGroup=$P(^TBBP(packid,subid),"\",5)
  ....I sBloodGroup'="" S BloodGPDesc=$P(^TTAB("BB-BG",sBloodGroup),"\",1)
  ....;血成分
  ....I $L(sBloodProduct),$D(^TTAB("BB-BP",sBloodProduct)) S ProductGroup=$P(^TTAB("BB-BP",sBloodProduct),"\",21)
  ....I $L(productGroupCode),productGroupCode'=ProductGroup Q
  ....S PackVolume=$P(^TBBP(packid,subid),"\",21)
  ....S SupCode=$P(^TBBP(packid,subid),"\",12)
  ....I SupCode'="" S SupDesc=$P(^TTAB("BB-SUP",SupCode),"\",1)
  ....I (SupplierId'="")&(SupplierId'=SupCode) Q
  ....I (ProductCode'="")&(ProductCode'=sBloodProduct) Q
  ....I (GroupCode'="")&(GroupCode'=sBloodGroup) Q
  ....S DateOfCollection=$P(^TBBP(packid,subid),"\",6)
  ....S Patientdebtor=$P(^TBBP(packid,subid),"\",10)
  ....S StatusRes=$P(^TBBP(packid,subid),"\",1)
  ....S ParentPack=$P(^TBBP(packid,subid),"\",9)
  ....S Location=$P(^TBBP(packid,subid),"\",8) ;bbp_do_location_dr
  ....S Visitts=$P(^TBBP(packid,subid),"\",11) ;bbp_do_visitts_dr
  ....S DateExpired=$P(^TBBP(packid,subid),"\",7) ;bbp_dateexpired
  ....I $L(DateExpired) S DateExpired=$zd(DateExpired,3)
  ....///失效时间 20120217
  ....S timeExpired=$P(^TBBP(packid,subid),"\",34) ;bbp_timeExpired
  ....S:$L(timeExpired) timeExpired=$ZT(timeExpired,2)
  ....S UserRec=$P(^TBBP(packid,subid),"\",15) ;bbp_userreceived_dr
  ....I UserRec'="" S UserRec=$P(^[sLabNameSpace]SSU("SSUSR",1,UserRec),"^",2)
  ....S StatusCode=$P(^TBBP(packid,subid),"\",2) ; bbp_do_status_dr
  ....I StatusCode'="" S StatusDesc=$P(^TTAB("BB-ST",StatusCode),"\",1)
  ....S StatusStock=$P(^TBBP(packid,subid),"\",3) ; bbp_do_statusstock
  ....S Donordebtor=$P(^TBBP(packid,subid),"\",16) ; bbp_donordebtor_dr
  ....S Units=""
  ....I $D(^TTAB("BB-BP",sBloodProduct,"REM",1)),$L(^TTAB("BB-BP",sBloodProduct,"REM",1)) S Units=$P(^TTAB("BB-BP",sBloodProduct,"REM",1),"&")
  ....S (Remarks,Genotype,GenotDesc,LabelPrDate,LabelPrMRN,Autologous,ReceivedByDM,Timeofcollection)=""
  ....S No=""
  ....S No=$O(^TBBP(packid,subid,"REM",No),-1)
  ....I No'=0 S Remarks=^TBBP(packid,subid,"REM",No) ; bbp_remarks
  ....S Genotype=$P(^TBBP(packid,subid),"\",17) ; bbp_genotype_dr
  ....I Genotype'="" S GenotDesc=$P(^TTAB("BB-GEN",Genotype),"\",1)
  ....S LabelPrDate=$P(^TBBP(packid,subid),"\",18) ; bbp_labelprinted_date
  ....S LabelPrMRN=$P(^TBBP(packid,subid),"\",19) ; bbp_labelprinted_mrn_dr
  ....S Autologous=$P(^TBBP(packid,subid),"\",20) ; bbp_autologous
  ....S ReceivedByDM=$P(^TBBP(packid,subid),"\",22) ; bbp_receivedbydonormodule
  ....S Timeofcollection=$P(^TBBP(packid,subid),"\",23) ; bbp_timeofcollection
  ....S BloodTag=""  ;位置
  ....S:$D(^TBBP(packid,subid,"TAG")) BloodTag=$P(^TTAB("BB-BT",$O(^TBBP(packid,subid,"TAG",""))),"\")
  ....;取血袋复检者
  ....S UserPGC=$$GetUserPGC(packid,subid)
  ....S DonorName=""
  ....I $D(^[sLabNameSpace]Dhcbbpackprice(packid,subid)) S DonorName=$P(^[sLabNameSpace]Dhcbbpackprice(packid,subid),"\",2)
  ....S temp=""
  ....S rowid=packid_"||"_subid
  ....///添加入库单号 20120209 huhm
  ....S RecordNo=$O(^[sLabNameSpace]DHCBBPackInRecord(0,"PACKID",packid,subid,""))
  ....///将subid修改为BPBarcode 20111215 huhm
  ....S DateOfCollection=$zd(DateOfCollection,3)
  ....S TimeExpired=DateExpired_" "_timeExpired
  ....S IDate=$zd(iDate,3)
  ....S ITime=$zt(iTime)
  ....S temp=rowid_del_packid_del_BPBarcode_del_ $zd(DateOfCollection,3)_del_SupCode_del_SupDesc_del_Patientdebtor
  ....S temp=temp_del_StatusRes_del_sBloodProduct_del_BloodPtDesc_del_sBloodGroup_del_BloodGPDesc_del_ParentPack
  ....S temp=temp_del_Location_del_Visitts_del_DateExpired_" "_timeExpired_del_$zd(iDate,3)_del_$zt(iTime)_del_UserRec_del_StatusCode_del_StatusDesc
  ....S temp=temp_del_StatusStock_del_Donordebtor_del_Remarks_del_Genotype_del_GenotDesc_del_LabelPrDate_del_LabelPrMRN
  ....S temp=temp_del_Autologous_del_PackVolume_del_ReceivedByDM_del_Timeofcollection
  ....S temp=temp_del_BloodTag_del_DonorName  ;位置;献血者
  ....S temp=temp_del_UserPGC_del_Units_del_RecordNo
  ....S (Field1,Field2,Field3,Field4,Field5)=""
  ....S Field5=HospitalDesc
  ....S Data=$lb(rowid,packid,BPBarcode,DateOfCollection,SupCode,SupDesc,Patientdebtor,StatusRes,sBloodProduct,BloodPtDesc,sBloodGroup,BloodGPDesc,ParentPack,Location,Visitts,TimeExpired,IDate,ITime,UserRec,StatusCode,StatusDesc,StatusStock,Donordebtor,Remarks,Genotype,GenotDesc,LabelPrDate,LabelPrMRN,Autologous,PackVolume,ReceivedByDM,Timeofcollection,BloodTag,DonorName,UserPGC,Units,RecordNo,ProductGroup,Field1,Field2,Field3,Field4,Field5)
  ....D Output
  K ^TMP($zn,$j)
  S qHandle=$lb(0,repid,0)
  Q $$$OK
GetPackRowId(PackId,SecId)
  //血制品代码和血袋id一起作为血袋唯一标示,保存在BBP_Donor_ID字段中 20111130 huhm
  S RetValue=PackId_"||"_SecId
  S BloodType=$P($G(^TBBP(PackId,SecId)),"\",40)
  ///添加界面上血袋条码和血制品条码 20111202 huhm
  I $L(BloodType) S RetValue=PackId_"||"_BloodType 
  Q RetValue 
GetUserPGC(packid,subid)
  S No="",UserPGC=""
  F  S No=$O(^TBBP(packid,subid,"TRAN",No))  Q:No=""  D
  .I $P(^TBBP(packid,subid,"TRAN",No),"\",1)="PGC" D
  ..S UserPGC=$P(^TBBP(packid,subid,"TRAN",No),"\",4)
  ..I UserPGC'="" S UserPGC=$P(^[sLabNameSpace]SSU("SSUSR",1,UserPGC),"^",2)
  Q UserPGC
   
Output
	S Data=$lb(rowid,packid,BPBarcode,DateOfCollection,SupCode,SupDesc,Patientdebtor,StatusRes,sBloodProduct,BloodPtDesc,sBloodGroup,BloodGPDesc,ParentPack,Location,Visitts,TimeExpired,IDate,ITime,UserRec,StatusCode,StatusDesc,StatusStock,Donordebtor,Remarks,Genotype,GenotDesc,LabelPrDate,LabelPrMRN,Autologous,PackVolume,ReceivedByDM,Timeofcollection,BloodTag,DonorName,UserPGC,Units,RecordNo,ProductGroup,Field1,Field2,Field3,Field4,Field5)
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
Query QuerySampleStatistics(DateS As %String, DateE As %String, PackID As %String, SupplierId As %String, ProductCode As %String, GroupCode As %String, productGroupCode As %String, BGFlag As %String, USERCODE As %String, HospitalCode As %String) As %Query(ROWSPEC = "rowid:%String,packid:%String,BPBarcode:%String,DateOfCollection:%String,SupCode:%String,SupDesc:%String,Patientdebtor:%String,StatusRes:%String,sBloodProduct:%String,BloodPtDesc:%String,sBloodGroup:%String,BloodGPDesc:%String,ParentPack:%String,Location:%String,Visitts:%String,TimeExpired:%String,IDate:%String,ITime:%String,UserRec:%String,StatusCode:%String,StatusDesc:%String,StatusStock:%String,Donordebtor:%String,Remarks:%String,Genotype:%String,GenotDesc:%String,LabelPrDate:%String,LabelPrMRN:%String,Autologous:%String,PackVolume:%String,ReceivedByDM:%String,Timeofcollection:%String,BloodTag:%String,DonorName:%String,UserPGC:%String,Units:%String,RecordNo:%String,ProductGroup:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCBldStatPackInDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatPackInDetailD</DataLocation>
<DefaultData>DHCBldStatPackInDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatPackInDetailD</IdLocation>
<IndexLocation>^web.DHCBldStatPackInDetailI</IndexLocation>
<StreamLocation>^web.DHCBldStatPackInDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
