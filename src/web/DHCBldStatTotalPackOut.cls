Class web.DHCBldStatTotalPackOut Extends %Persistent
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
/// D ##class(%ResultSet).RunQuery("web.DHCBldStatTotalPackOut","QuerySampleStatistics","2014-11-01","2014-11-15","","","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, SupplierId As %String, ProductCode As %String, GroupCode As %String, productGroupCode As %String, HospitalCode As %String, BGFlag As %String, TransType As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  I '$L(DateS) S DateS=+$H-1,DateS=$ZD(DateS,3)
  I '$L(DateE) S DateE=+$H,DateE=$ZD(DateE,3)
  I '$L(USERCODE) S USERCODE="demo"
  S ^TMP("xq1")=DateS_","_DateE_","_SupplierId_","_ProductCode_","_GroupCode_","_productGroupCode_","_HospitalCode_","_BGFlag_","_TransType
  S HospitalCode=$G(HospitalCode)
  S HospitalDesc=""
  //S HospitalCode=$O(^TTABi("CC",1,""))
  I $L(HospitalCode) S HospitalDesc=$P(^TTAB("CC",HospitalCode),"\",1)
  S TransType=$G(TransType)
  K ^TMP($zn,$j,"OUT"),^TMP($zn,$j,"TotalOut")
  S stockstatus="OUT"
  S BGFlag=$G(BGFlag)
  S DateS=$ZDH(DateS,3)
  S DateE=$ZDH(DateE,3)
  s total=0,totalValume=0
  F iDate=DateS:1:DateE D
  .S iTime=""  F  S iTime=$O(^TBBPi("TR-DateTime",iDate,iTime))  Q:iTime=""  D
  ..//i (iDate=startdate)&(iTime<starttime) q
  ..//i (iDate=enddate)&(iTime>endtime) q
  ..S PackID=""  F  S PackID=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID))  Q:PackID=""  D
  ...S SecondId=""  F  S SecondId=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID,SecondId))  Q:SecondId=""  d
  ....I '$D(^TBBP(PackID,SecondId)) Q
  ....;-----多医院-------->
  ....S BPCode=$P($G(^TBBP(PackID,SecondId)),"\",4),CurHospitalCode=""
  ....I $L(BPCode) S CurHospitalCode=$P(^TTAB("BB-BP",BPCode),"\",11)
  ....I $L(HospitalCode),$L(CurHospitalCode),CurHospitalCode'=HospitalCode Quit
  ....//I $L(HospitalCode),'$L(CurHospitalCode),'$D(^TTABi("CC",1,HospitalCode)) Quit
  ....;------------------<
  ....S Sequence=""  F  S Sequence=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID,SecondId,Sequence))  Q:Sequence=""  d
  .....I $D(^TMP($zn,$j,"OUT",PackID,SecondId))'=0 D
  ......S zz=^TMP($zn,$j,"OUT",PackID,SecondId)
  ......I Sequence>zz s ^TMP($zn,$j,"OUT",PackID,SecondId)=Sequence
  .....E  D
  ......S ^TMP($zn,$j,"OUT",PackID,SecondId)=Sequence
  S PackID=""  F  S PackID=$O(^TMP($zn,$j,"OUT",PackID))  Q:PackID=""  d
  .S SecondId=""  F  S SecondId=$O(^TMP($zn,$j,"OUT",PackID,SecondId))  Q:SecondId=""  d
  ..;删除的血袋处理
  ..I '$D(^TBBP(PackID,SecondId)) Q
  ..I ($D(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId))),($P(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId),"\",6)="Y") Q  
  ..S Sequence=^TMP($zn,$j,"OUT",PackID,SecondId)
  ..S sStock=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",8)
  ..S transTypeID=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",1)  //处理类型
  ..I $L(TransType),$L(transTypeID),transTypeID'=TransType Q
  ..S StockCode=$P(^TTAB("BB-ST",sStock),"\",2)
  ..I StockCode'=stockstatus Q
  ..S BloodProduct=$P(^TBBP(PackID,SecondId),"\",4)
  ..S BloodGroup=$P(^TBBP(PackID,SecondId),"\",5)
  ..
  ..;血成分
  ..I $L(BloodProduct),$D(^TTAB("BB-BP",BloodProduct)) s ProductGroup=$P(^TTAB("BB-BP",BloodProduct),"\",21)
  ..I $L(productGroupCode),productGroupCode'=ProductGroup Q
  ..S PackVolume=$P(^TBBP(PackID,SecondId),"\",21)
  ..S bldProductUnit=$P($G(^TTAB("BB-BP",BloodProduct,"REM",1)),"&",1)
  ..//I BloodProduct="DT003" w PackID,SecondId,"-",PackVolume,!
  ..S rate=+bldProductUnit
  ..S:rate=0 rate=1
  ..S PackVolume=PackVolume*rate
  ..S:rate>1 bldProductUnit=$P(bldProductUnit,rate,2)
  ..S tranStatus=$P(^TBBP(PackID,SecondId),"\",2)
  ..//Q:(tranStatus'="ISS")&(tranStatus'="STOCK")
  ..S SupCode=$P(^TBBP(PackID,SecondId),"\",12)
  ..I SupCode'="" s SupDesc=$P(^TTAB("BB-SUP",SupCode),"\",1)
  ..I (ProductCode'="")&(ProductCode'=BloodProduct) Q
  ..I (GroupCode'="")&(GroupCode'=BloodGroup) Q
  ..I (SupplierId'="")&(SupplierId'=SupCode) Q
  ..I BGFlag=1,$L(ProductGroup) S BloodProduct=ProductGroup  ;血成份统计
  ..S outStoreType="正常发血"
  ..;I transTypeID'="TRANS3" D
  ..;.S outStoreType="非正常出库"
  ..I tranStatus="RTN" D
  ...S outStoreType="非正常出库"
  ..I tranStatus="TRANS" D
  ...S outStoreType="过期处理"
  ..I tranStatus="TRANS1" D
  ...S outStoreType="直接发血"
  ..I tranStatus="TRANS2" D
  ...S outStoreType="出库操作"
  ..I tranStatus="TRANS3" D
  ...S outStoreType="正常发血"
  ..I tranStatus="TRANS4" D
  ...S outStoreType="非消耗出库"
  ..I tranStatus="TRANS5" D
  ...S outStoreType="院区血袋转出"
  ..I tranStatus="TRANS6" D
  ...S outStoreType="退回血站"
  ..I tranStatus="OUT" D
  ...S outStoreType="非正常出库1"
  ..I tranStatus="OUT2" D
  ...S outStoreType="非正常出库2"
  ..I tranStatus="SPTOUT" D
  ...S outStoreType="拆分出库"
  ..I tranStatus="RTN" B ;1
  ..S ^TMP("XQ100",PackID,SecondId,outStoreType)=""
  ..S curTotalPackNum=+$P($G(^TMP($zn,$j,"TotalOut",BloodProduct,BloodGroup,outStoreType,tranStatus,PackVolume)),"^",1)
  ..S curTotalPackVolume=+$P($G(^TMP($zn,$j,"TotalOut",BloodProduct,BloodGroup,outStoreType,tranStatus,PackVolume)),"^",2)
  ..S $P(^TMP($zn,$j,"TotalOut",BloodProduct,BloodGroup,outStoreType,tranStatus,PackVolume),"^",1)=curTotalPackNum+1
  ..S $P(^TMP($zn,$j,"TotalOut",BloodProduct,BloodGroup,outStoreType,tranStatus,PackVolume),"^",2)=curTotalPackVolume+PackVolume
  ..S:$L(bldProductUnit) $P(^TMP($zn,$j,"TotalOut",BloodProduct,BloodGroup,outStoreType,tranStatus,PackVolume),"^",3)=bldProductUnit
  //m ^TMP("XQ300")=^TMP($zn,$j,"TotalOut")
  K PLIST
  S BloodProduct="",deli=$C(2),ret=0,P8=0,P9=0,totalSumNum=0,totalSumVol=0
  F  S BloodProduct=$O(^TMP($zn,$j,"TotalOut",BloodProduct)) Q:'$L(BloodProduct)  D
  .S bldProductDesc=$P($G(^TTAB("BB-BP",BloodProduct)),"\",1)
  .I '$L(bldProductDesc) D
  ..S bldProductDesc=$P($G(^TTAB("BB-PG",BloodProduct)),"\",1)
  .S BloodGroup="",bldProSumNum=0,bldProSumVol=0
  .F  S BloodGroup=$O(^TMP($zn,$j,"TotalOut",BloodProduct,BloodGroup)) Q:'$L(BloodGroup)  D 
  ..S bldGrpDesc=$P($G(^TTAB("BB-BG",BloodGroup)),"\",1)
  ..S outStoreType=""
  ..S bldSumXJNum=0,bldSumXJVol=0,bldSumNum=0,bldSumVol=0
  ..F  S outStoreType=$O(^TMP($zn,$j,"TotalOut",BloodProduct,BloodGroup,outStoreType)) Q:'$L(outStoreType)  D 
  ...S tranStatus="",bldSumNum=0,bldSumVol=0
  ...F  S tranStatus=$O(^TMP($zn,$j,"TotalOut",BloodProduct,BloodGroup,outStoreType,tranStatus)) Q:'$L(tranStatus)  D 
  ....S statusDesc=$P($G(^TTAB("BB-ST",tranStatus)),"\",1)
  ....S PackVolume=""
  ....F  S PackVolume=$O(^TMP($zn,$j,"TotalOut",BloodProduct,BloodGroup,outStoreType,tranStatus,PackVolume)) Q:'$L(PackVolume)  D
  .....S curTotalPackNum=$P($G(^TMP($zn,$j,"TotalOut",BloodProduct,BloodGroup,outStoreType,tranStatus,PackVolume)),"^",1)
  .....S curTotalPackVolume=$P($G(^TMP($zn,$j,"TotalOut",BloodProduct,BloodGroup,outStoreType,tranStatus,PackVolume)),"^",2)
  .....S bldProductUnit=$P($G(^TMP($zn,$j,"TotalOut",BloodProduct,BloodGroup,outStoreType,tranStatus,PackVolume)),"^",3)
  .....S record=bldProductDesc_deli_bldGrpDesc_deli_outStoreType_deli_statusDesc_deli_PackVolume_deli_bldProductUnit_deli_curTotalPackNum_deli_curTotalPackVolume_deli
  .....S ret=ret+1,PLIST(ret)=record
  .....S OPutbldSumNum=curTotalPackNum,OPutbldSumVol=curTotalPackVolume
  .....S Field1=""
  .....S Field2=""
  .....S Field3=""
  .....S Field4=BloodProduct
  .....S Field5=HospitalDesc
  .....S Data=$lb(bldProductDesc,bldGrpDesc,outStoreType,statusDesc,PackVolume,bldProductUnit,OPutbldSumNum,OPutbldSumVol,Field1,Field2,Field3,Field4,Field5)
  .....D Output
  .....I BGFlag=1 S bldSumNum=0,bldSumVol=0 
  .....S bldSumNum=bldSumNum+curTotalPackNum,bldSumVol=bldSumVol+curTotalPackVolume
  .....S bldSumXJNum=bldSumNum
  .....S bldSumXJVol=bldSumVol
  .....I BloodProduct="DT003" w bldSumXJNum,"+",curTotalPackNum,"+",bldSumNum,!
  .....//S ^TMP("XQ100")=
  ..I BloodProduct="DT003" w bldSumXJNum,!
  ..S record=bldProductDesc_deli_bldGrpDesc_deli_"小计"_deli_"小计"_deli_"小计"_deli_"小计"_deli_bldSumXJNum_deli_bldSumXJVol_deli
  ..//S ret=ret+1,PLIST(ret)=record
  ..S Xj="小计"
  ..S outStoreType=Xj,statusDesc=Xj,PackVolume=Xj,bldProductUnit=Xj,OPutbldSumNum=bldSumXJNum,OPutbldSumVol=bldSumXJVol
  ..S Field1=""
  ..S Field2=""
  ..S Field3=""
  ..S Field4=BloodProduct
  ..S Field5=HospitalDesc
  ..S Data=$lb(bldProductDesc,bldGrpDesc,outStoreType,statusDesc,PackVolume,bldProductUnit,OPutbldSumNum,OPutbldSumVol,Field1,Field2,Field3,Field4,Field5)
  ..D Output
  ..//S bldProSumNum=bldProSumNum+bldSumNum,bldProSumVol=bldProSumVol+bldSumVol
  ..S bldProSumNum=bldProSumNum+bldSumXJNum,bldProSumVol=bldProSumVol+bldSumXJVol
  .S record=bldProductDesc_deli_"合计"_deli_"合计"_deli_"合计"_deli_"合计"_deli_"合计"_deli_bldProSumNum_deli_bldProSumVol_deli
  .//S record=bldProductDesc_deli_"合计"_deli_"合计"_deli_"合计"_deli_"合计"_deli_"合计"_deli_bldSumXJNum_deli_bldProSumVol_deli
  .//S ret=ret+1,PLIST(ret)=record
  .S Hj="合计" 
  .S bldGrpDesc=Hj,outStoreType=Hj,statusDesc=Hj,PackVolume=Hj,bldProductUnit=Hj,OPutbldSumNum=bldProSumNum,OPutbldSumVol=bldProSumVol
  .S Field1=""
  .S Field2=""
  .S Field3=""
  .S Field4=BloodProduct
  .S Field5=HospitalDesc
  .S Data=$lb(bldProductDesc,bldGrpDesc,outStoreType,statusDesc,PackVolume,bldProductUnit,OPutbldSumNum,OPutbldSumVol,Field1,Field2,Field3,Field4,Field5)
  .D Output
  .S totalSumNum=totalSumNum+bldProSumNum,totalSumVol=totalSumVol+bldProSumVol
  //I ret>0 D
  //.S record="汇总"_deli_"汇总"_deli_"汇总"_deli_"汇总"_deli_"汇总"_deli_totalSumNum_deli_totalSumVol_deli
  //.S ret=ret+1,PLIST(ret)=record
  S P9=totalSumNum,P8=totalSumVol
  //S PLIST=ret
  K ^TMP($zn,$j,"TotalOut")
  S qHandle=$lb(0,repid,0)
  Q $$$OK
 
Output
	S Data=$lb(bldProductDesc,bldGrpDesc,outStoreType,statusDesc,PackVolume,bldProductUnit,OPutbldSumNum,OPutbldSumVol,Field1,Field2,Field3,Field4,Field5)
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
Query QuerySampleStatistics(DateS As %String, DateE As %String, SupplierId As %String, ProductCode As %String, GroupCode As %String, productGroupCode As %String, HospitalCode As %String, BGFlag As %String, TransType As %String, USERCODE As %String) As %Query(ROWSPEC = "bldProductDesc:%String,bldGrpDesc:%String,outStoreType:%String,statusDesc:%String,PackVolume:%String,bldProductUnit:%String,OPutbldSumNum:%String,OPutbldSumVol:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCBldStatTotalPackOutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatTotalPackOutD</DataLocation>
<DefaultData>DHCBldStatTotalPackOutDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatTotalPackOutD</IdLocation>
<IndexLocation>^web.DHCBldStatTotalPackOutI</IndexLocation>
<StreamLocation>^web.DHCBldStatTotalPackOutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
