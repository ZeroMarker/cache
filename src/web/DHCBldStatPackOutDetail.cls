Class web.DHCBldStatPackOutDetail Extends %Persistent
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
/// D ##class(%ResultSet).RunQuery("web.DHCBldStatPackOutDetail","QuerySampleStatistics","2013-04-01","2014-05-15","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, PackId As %String, SupplierId As %String, ProductCode As %String, GroupCode As %String, productGroupCode As %String, BGFlag As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  S HospitalCode=""
  S HospitalCode=$O(^TTABi("CC",1,""))
  K ^TMP($zn,$j,"OUT")
  S row=0,HospitalCode=$g(HospitalCode)
  S stockstatus="OUT"
  S del=$c(28)
  I '$L(DateS) S DateS=+$H-1,DateS=$ZD(DateS,3)
  I '$L(DateE) S DateE=+$H,DateE=$ZD(DateE,3)
  S DateS=$ZDH(DateS,3)
  S DateE=$ZDH(DateE,3)
  S PackId=$TR($TR(PackId," "),$C(13))
  S ProductCode=$P(ProductCode,"^",1)    
  F iDate=DateS:1:DateE D
  .S iTime=""  F  S iTime=$O(^TBBPi("TR-DateTime",iDate,iTime))  Q:iTime=""  D
  ..//I (iDate=startdate)&(iTime<starttime) Q
  ..//I (iDate=enddate)&(iTime>endtime) Q
  ..S PackID=""  F  S PackID=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID))  Q:PackID=""  D
  ...S SecondId=""  F  S SecondId=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID,SecondId))  Q:SecondId=""  D
  ....;-----多医院-------->
  ....S BPCode=$P($g(^TBBP(PackID,SecondId)),"\",4),CurHospitalCode=""
  ....I $L(PackId),PackId'=PackID Q
  ....///血制品代码和血袋id一起作为血袋唯一标示,保存在BBP_Donor_ID字段中 20111215 huhm
  ....//s BPBarcode=SecondId
  ....//s BloodType=$P(^TBBP(PackID,SecondId),"\",40)
  ....//i $L(BloodType) s BPBarcode=BloodType
  ....//b ;2  
  ....S BPBarcode=$P($$GetPackRowId(PackID,SecondId),"||",2)
  ....///
  ....I $L(BPCode) s CurHospitalCode=$P(^TTAB("BB-BP",BPCode),"\",11)
  ....I $L(HospitalCode),$L(CurHospitalCode),CurHospitalCode'=HospitalCode Quit
  ....I $L(HospitalCode),'$L(CurHospitalCode),'$D(^TTABi("CC",1,HospitalCode)) Quit
  ....;------------------<
  ....S Sequence=""  F  S Sequence=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID,SecondId,Sequence))  Q:Sequence=""  D
  .....I $D(^TMP($zn,$j,"OUT",PackID,SecondId))'=0 D
  ......S zz=^TMP($zn,$j,"OUT",PackID,SecondId)
  ......I Sequence>zz s ^TMP($zn,$j,"OUT",PackID,SecondId)=Sequence
  .....e  D
  ......S ^TMP($zn,$j,"OUT",PackID,SecondId)=Sequence
  s PackID=""  F  S PackID=$O(^TMP($zn,$j,"OUT",PackID))  Q:PackID=""  D
  .S SecondId=""  F  S SecondId=$O(^TMP($zn,$j,"OUT",PackID,SecondId))  Q:SecondId=""  D
  ..S (donorName,Units,InputPrice,BloodPtDesc,BloodGPDesc,SupDesc,PackVolume,OutType)=""
  ..S (VisitNumber,testset,testcount,depament,paientname,debtor,standvalue1,standvalue2,standvalue3,XMUser,IssUser)=""
  ..;删除的血袋处理
  ..I '$D(^TBBP(PackID,SecondId)) Q
  ..I ($D(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId))),($P(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId),"\",6)="Y") Q  
  ..S Sequence=^TMP($zn,$j,"OUT",PackID,SecondId)
  ..S sStock=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",8)
  ..S transTypeID=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",1)
  ..S StockCode=$P(^TTAB("BB-ST",sStock),"\",2)
  ..I StockCode'=stockstatus Q
  ..S BloodProduct=$P(^TBBP(PackID,SecondId),"\",4)
  ..S BloodGroup=$P(^TBBP(PackID,SecondId),"\",5)
  ..I BloodProduct'="" s BloodPtDesc=$P(^TTAB("BB-BP",BloodProduct),"\",1)
  ..I BloodGroup'="" s BloodGPDesc=$P(^TTAB("BB-BG",BloodGroup),"\",1)
  ..I (ProductCode'="")&(ProductCode'=BloodProduct) Q
  ..I (GroupCode'="")&(GroupCode'=BloodGroup) Q
  ..;血成分
  ..I $L(BloodProduct),$D(^TTAB("BB-BP",BloodProduct)) s ProductGroup=$P(^TTAB("BB-BP",BloodProduct),"\",21)
  ..I $L(productGroupCode),productGroupCode'=ProductGroup Q
  ..S PackVolume=$P(^TBBP(PackID,SecondId),"\",21)
  ..S SupCode=$P(^TBBP(PackID,SecondId),"\",12)
  ..I SupCode'="" s SupDesc=$P(^TTAB("BB-SUP",SupCode),"\",1)
  ..I (SupplierId'="")&(SupplierId'=SupCode) Q
  ..S Units=""
  ..I $D(^TTAB("BB-BP",BloodProduct,"REM",1)),$L(^TTAB("BB-BP",BloodProduct,"REM",1)) s Units=$P(^TTAB("BB-BP",BloodProduct,"REM",1),"&")
  ..S:$D(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId)) InputPrice=$P(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId),"\",1)
  ..S:$D(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId)) donorName=$P(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId),"\",2)  ;献血者
  ..S ptdate=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",2)
  ..S pttime=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",3)
  ..S SplitOutTrans=""  ;拆分出库
  ..I $D(^[sLabNameSpace]DHCLabParameter(0,"PackTrans","BloodTrans"))'=0 D
  ...S SplitOutTrans=$P(^[sLabNameSpace]DHCLabParameter(0,"PackTrans","BloodTrans"),"\",3)
  ..I $P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",1)=SplitOutTrans D 
  ...S OutType="拆分出库"
  ..I $P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",1)=SplitOutTrans Q
  ..I $$CT012(PackID_"||"_SecondId)'="" D
  ...S OutType="正常出库"
  ..e  D
  ...S OutType="非正常出库"
  ...I transTypeID="SPTOUT" D
  ....S OutType="拆分出库"
  ..S row=row+1
  ..S add=""
  ..S VisitNumber=$P($P(^TBBP(PackID,SecondId),"\",11),"||",1)
  ..S testset=$P($P(^TBBP(PackID,SecondId),"\",11),"||",2)
  ..S testcount=$P($P(^TBBP(PackID,SecondId),"\",11),"||",3)
  ..;病人明细
  ..S (sex,age,wardname,bed,hospno,BloodTag)=""
  ..I VisitNumber'="" D
  ...S loccode=$P(^TEPI(VisitNumber),"\",36)
  ...I loccode'="",$D(^TTAB("USLOC",loccode)) s depament=$P($g(^TTAB("USLOC",loccode)),"\",1)
  ...I depament["-" s depament=$P(depament,"-",2)
  ...S paientname=$P(^TEPI(VisitNumber),"\",1)
  ...S dobtor=$P(^TEPI(VisitNumber),"\",18)
  ...I debtor'="" s hospno=##class(web.DHCLabCommonUse).GetHospnoByDebno(debtor)  ;病案号
  ...S age=##class(web.DHCLabCommonUse).AgeOut(##class(web.DHCLabCommonUse).GetPatAge(VisitNumber))
  ...S sex=""				;性别
  ...S spcode=$P(^TEPI(VisitNumber),"\",3)
  ...I spcode'="",$D(^TTAB("SP",spcode)) s sex=$P(^TTAB("SP",spcode),"\",1)
  ...;病区
  ...S wardname=""
  ...S tempatwarddr=$P(^TEPI(VisitNumber),"\",20)
  ...I $L(tempatwarddr),$D(^TTAB("RH",tempatwarddr)) s wardname=$P(^TTAB("RH",tempatwarddr),"\",1)
  ...I wardname["-" s wardname=$P(wardname,"-",2)
  ...I $D(^TEPI(VisitNumber,0)) s bed=$P(^TEPI(VisitNumber,0),"\",29)	 ;床号
  ...;s ktsc="B0020" ;抗体筛查
  ...;s:$D(^TEPI(VisitNumber,1,"B050",testcount,"DATA",ktsc)) standvalue1=$P(^TEPI(VisitNumber,1,"B050",testcount,"DATA",ktsc),"\")
  ...;s:standvalue1'="" standvalue1=^TTAB("TC",ktsc,2,standvalue1,1)
  ...;主,次交叉
  ...;s:$D(^TEPI(VisitNumber,1,testset,testcount,"BBP",PackID,SecondId)) standvalue2=$P($P(^TEPI(VisitNumber,1,testset,testcount,"BBP",PackID,SecondId),"\",4),",",1)
  ...;s:$D(^TEPI(VisitNumber,1,testset,testcount,"BBP",PackID,SecondId)) standvalue3=$P($P(^TEPI(VisitNumber,1,testset,testcount,"BBP",PackID,SecondId),"\",4),",",2)
  ...I $D(^TEPI(VisitNumber,1,testset,testcount))'=0 D
  ....S IssUserID=$P(^[sLabNameSpace]DHCVisitTSBBPacksInfo(VisitNumber,1,testset,testcount,"BBP",PackID,SecondId),"\",1) ;发血者
  ....I IssUserID'="" s IssUser=$P(^[sLabNameSpace]SSU("SSUSR",1,IssUserID),"^",2)
  ....S XMUserID=$P(^[sLabNameSpace]DHCVisitTSBBPacksInfo(VisitNumber,1,testset,testcount,"BBP",PackID,SecondId),"\",4)  ;配血者
  ....I XMUserID'="" s XMUser=$P(^[sLabNameSpace]SSU("SSUSR",1,XMUserID),"^",2)       
  ...S BloodTag=""  ;位置
  ...S:$D(^TBBP(PackID,SecondId,"TAG")) BloodTag=$P(^TTAB("BB-BT",$O(^TBBP(PackID,SecondId,"TAG",""))),"\")
  ..S add=depament_del_paientname_del_debtor_del_standvalue1_del_standvalue2_del_standvalue3_del_XMUser_del_IssUser_del_VisitNumber
  ..///将SecondId修改为BPBarcode 20111215 huhm
  ..S BPBarcode=$P($$GetPackRowId(PackID,SecondId),"||",2)
  ..S stemp=PackID_"||"_BPBarcode_del_BloodPtDesc_del_BloodGPDesc_del_SupDesc_del_PackVolume_del_Units
  ..S temp1(row)=stemp_del_$zd(ptdate,3)_del_$zt(pttime)_del_donorName_del_BloodTag_del_OutType_del_add
  ..S temp1(row)=temp1(row)_del_hospno_del_sex_del_age_del_wardname_del_bed
  ..S PackRowId=PackID_"||"_BPBarcode
  ..S Patdate=$zd(ptdate,3)
  ..S Pattime=$zt(pttime)
  ..S Data=$lb(PackRowId,BloodPtDesc,BloodGPDesc,SupDesc,PackVolume,Units,Patdate,Pattime,donorName,BloodTag,OutType,depament,paientname,debtor,standvalue1,standvalue2,standvalue3,XMUser,IssUser,VisitNumber,hospno,sex,age,wardname,bed)
  ..D Output
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
CT012(rowid)  s rowid=$g(rowid),x1=$P(rowid,"||",1),x2=$P(rowid,"||",2),result=""
 i $L(x1),$L(x2) D
 s x3="" F  S x3=$O(^TBBP(x1,x2,"TRAN",x3),-1) q:x3=""  i $P(^TBBP(x1,x2,"TRAN",x3),"\",10)'="Y" s result=$P(^TBBP(x1,x2,"TRAN",x3),"\",7) q
 q result  
Output
	S Data=$lb(PackRowId,BloodPtDesc,BloodGPDesc,SupDesc,PackVolume,Units,Patdate,Pattime,donorName,BloodTag,OutType,depament,paientname,debtor,standvalue1,standvalue2,standvalue3,XMUser,IssUser,VisitNumber,hospno,sex,age,wardname,bed)
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
Query QuerySampleStatistics(DateS As %String, DateE As %String, PackId As %String, SupplierId As %String, ProductCode As %String, GroupCode As %String, productGroupCode As %String, BGFlag As %String) As %Query(ROWSPEC = "PackRowId:%String,BloodPtDesc:%String,BloodGPDesc:%String,SupDesc:%String,PackVolume:%String,Units:%String,Patdate:%String,Pattime:%String,donorName:%String,BloodTag:%String,OutType:%String,depament:%String,paientname:%String,debtor:%String,standvalue1:%String,standvalue2:%String,standvalue3:%String,XMUser:%String,IssUser:%String,VisitNumber:%String,hospno:%String,sex:%String,age:%String,wardname:%String,bed:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCBldStatPackOutDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatPackOutDetailD</DataLocation>
<DefaultData>DHCBldStatPackOutDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatPackOutDetailD</IdLocation>
<IndexLocation>^web.DHCBldStatPackOutDetailI</IndexLocation>
<StreamLocation>^web.DHCBldStatPackOutDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
